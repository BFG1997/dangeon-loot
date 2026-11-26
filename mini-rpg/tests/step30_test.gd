## Тест шага 30: пауза на Escape (Продолжить/Загрузить/Сохранить/Настройки/
## В главное меню), HUD с единственной кнопкой ИНВЕНТАРЬ и пустым блоком
## «СПОСОБНОСТИ», иконка брони в HUD обновляется при надевании
## (сигнал armor_changed), клавиши приёмов поменялись местами (приём
## героя — ПРОБЕЛ, бывший пробел — CTRL) и звёзды в Хабе стоят на месте
## (тряска экрана шага 30: Parallax2D и сглаживание камеры убраны).
## Запуск: godot --headless --path . res://tests/step30_test.tscn
extends Node

var failed := 0

func check(name: String, condition: bool) -> void:
    if condition:
        print("  [OK] ", name)
    else:
        failed += 1
        print("  [ПРОВАЛ] ", name)

func load_dungeon() -> Node2D:
    var dungeon: Node2D = (load("res://scenes/dungeon/dungeon.tscn") as PackedScene).instantiate()
    add_child(dungeon)
    await get_tree().process_frame
    await get_tree().process_frame
    return dungeon

func load_world() -> Node2D:
    var world: Node2D = (load("res://scenes/world/world.tscn") as PackedScene).instantiate()
    add_child(world)
    await get_tree().process_frame
    await get_tree().process_frame
    return world

func hud_button_texts(hud_bar: Control) -> Array[String]:
    var texts: Array[String] = []
    for child in hud_bar.get_children():
        if child is Button and child.has_meta("action_button"):
            texts.append((child as Button).text)
    return texts

func pause_button_texts(pm) -> Array[String]:
    var texts: Array[String] = []
    for child in pm.main_panel.find_children("*", "Button", true, false):
        texts.append((child as Button).text)
    return texts

func _ready() -> void:
    print("STEP30 TEST: пауза на Escape, HUD (ИНВЕНТАРЬ + СПОСОБНОСТИ), броня в HUD, пробел/CTRL, звёзды в Хабе")
    Saves.wipe_all_slots()
    Game.meta["last_slot"] = 0
    Game.meta["last_bonus_date"] = ""
    Game.meta["pending_gold"] = 0
    Game.meta["pending_items"] = []
    Game.save_meta()

    # ================== клавиши: ПРОБЕЛ <-> CTRL ==================
    var special_ev: InputEventKey = InputMap.action_get_events("special")[0]
    var dash_ev: InputEventKey = InputMap.action_get_events("dash")[0]
    check("действие special теперь на CTRL (щит/барьер/газ/прыжок)",
        int(special_ev.physical_keycode) == KEY_CTRL)
    check("действие dash теперь на ПРОБЕЛЕ (приём героя)",
        int(dash_ev.physical_keycode) == KEY_SPACE)
    check("dash переназначаем, special — модификатор вне ACTIONS",
        Controls.get_actions().has(&"dash")
        and not Controls.get_actions().has(&"special")
        and Controls.PROFILE_VERSION == 4)

    # ================== мир: HUD и звёзды ==================
    Game.new_run(1, "warrior")
    var world := await load_world()
    check("HUD мира: одна кнопка ИНВЕНТАРЬ",
        hud_button_texts(world._hud_bar) == ["ИНВЕНТАРЬ"])
    var block: Control = null
    for child in world._hud_bar.get_children():
        if child is Control and child.has_meta("abilities_block"):
            block = child
    check("в HUD есть блок «СПОСОБНОСТИ»", block != null)
    if block != null:
        var cells := 0
        var title := ""
        for sub in block.get_children():
            if sub is Label:
                title = (sub as Label).text
            elif sub is Panel:
                cells += 1
        check("блок «СПОСОБНОСТИ»: заголовок и 4 пустых слота-заглушки",
            title == "СПОСОБНОСТИ" and cells == 4)
    check("слоты: ПРОБЕЛ — приём героя, CTRL — щит воина",
        world._hud_slots[1]["key"] == "ПРОБЕЛ" and world._hud_slots[1]["kind"] == "dash"
        and world._hud_slots[3]["key"] == "CTRL" and world._hud_slots[3]["kind"] == "special")

    # звёзды: статичные Sprite2D вместо Parallax2D — не двигаются вообще
    check("звёздные слои — статичные Sprite2D с region-повтором",
        world._star_layers.size() == 2
        and (world._star_layers[0]["sprite"] as Sprite2D).region_enabled
        and (world._star_layers[0]["sprite"] as Sprite2D).get_class() == "Sprite2D")
    var star0: Sprite2D = world._star_layers[0]["sprite"]
    var star1: Sprite2D = world._star_layers[1]["sprite"]
    var cam: Camera2D = world._camera
    check("сглаживание камеры в мире выключено", not cam.position_smoothing_enabled)
    # 30 кадров стоя: камера и звёзды не должны шевелиться
    var center0: Vector2 = cam.get_screen_center_position()
    var s0a: Vector2 = star0.global_position
    var s1a: Vector2 = star1.global_position
    for i in range(30):
        await get_tree().physics_frame
    check("в покое камера стоит на месте",
        cam.get_screen_center_position().distance_to(center0) < 0.01)
    check("в покое звёзды стоят на месте",
        star0.global_position == s0a and star1.global_position == s1a)
    # 40 кадров шага ВНИЗ по улице: звёзды НЕ двигаются, камера следует
    # жёстко (по горизонтали обзор равен карте — двигается только вертикаль)
    world.player.position = Vector2(28 * 16 + 8, 25 * 16 + 8)
    var centers: Array[Vector2] = []
    var player_at: Array[Vector2] = []
    var star_moved := false
    Input.action_press("move_down")
    for i in range(40):
        await get_tree().physics_frame
        if star0.global_position != s0a or star1.global_position != s1a:
            star_moved = true
        if i % 10 == 9:
            centers.append(cam.get_screen_center_position())
            player_at.append(world.player.position)
    Input.action_release("move_down")
    check("звёзды не двигаются при ходьбе (тряски нет)", not star_moved)
    # в каждый сэмпл центр камеры обязан совпадать с ограниченным лимитами
    # положением героя В ТОТ ЖЕ кадр — без сглаживания и запаздывания
    var rigid_ok := true
    for i in range(centers.size()):
        var half := Vector2(world._walk_holder.size.x, world._walk_holder.size.y) \
            / (2.0 * cam.zoom.x)
        var expected := Vector2(
            clampf(player_at[i].x, half.x,
                float(WorldMap.MAP_W * WorldMap.TILE_SIZE) - half.x),
            clampf(player_at[i].y, half.y,
                float(WorldMap.MAP_H * WorldMap.TILE_SIZE) - half.y))
        if centers[i].distance_to(expected) > 0.6:
            rigid_ok = false
    check("камера следует за героем жёстко (без сглаживания и запаздывания)", rigid_ok)
    check("за 40 кадров ходьбы камера вообще двигалась", centers.size() >= 4
        and centers[centers.size() - 1] != centers[0])
    world.queue_free()
    await get_tree().process_frame

    # ================== иконка брони в HUD (мир) ==================
    Game.new_run(1, "warrior")
    world = await load_world()
    var armor_rec: Dictionary = world._hud_equip["armor"]
    check("слот брони пуст на старте", (armor_rec["icon"] as TextureRect).texture == null)
    Game.add_item({"item_id": "armor_leather", "title": "Кожаный доспех", "quality": "green"})
    check("надеть броню можно", bool(Game.equip_armor("armor_leather").get("ok", false)))
    var armor_tex: Texture2D = (armor_rec["icon"] as TextureRect).texture
    check("иконка брони появилась в HUD сразу после надевания",
        armor_tex != null and String(armor_tex.resource_path).contains("armor_leather"))
    Game.unequip_armor()
    check("после снятия брони иконка исчезла",
        (armor_rec["icon"] as TextureRect).texture == null)
    # оружие по-прежнему обновляется (регрессии нет)
    Game.add_item({"item_id": "sword", "title": "Меч", "quality": "gray"})
    Game.equip_weapon("sword")
    var weapon_rec: Dictionary = world._hud_equip["weapon"]
    check("иконка оружия в HUD на месте",
        (weapon_rec["icon"] as TextureRect).texture != null
        and String((weapon_rec["icon"] as TextureRect).texture.resource_path).contains("sword"))
    world.queue_free()
    await get_tree().process_frame

    # ================== пауза на Escape (мир) ==================
    Game.new_run(1, "warrior")
    world = await load_world()
    var pm = world._pause_menu
    check("пауза прикреплена к миру", pm != null and is_instance_valid(pm))
    if pm != null:
        check("список пунктов: Продолжить/Загрузить/Сохранить/Настройки/Меню",
            pause_button_texts(pm) == ["ПРОДОЛЖИТЬ", "ЗАГРУЗИТЬ", "СОХРАНИТЬ",
                "НАСТРОЙКИ", "В ГЛАВНОЕ МЕНЮ"])
        check("на старте пауза скрыта и мир живой",
            not pm.root.visible and not get_tree().paused)
        # настоящий Escape открывает паузу
        var esc := InputEventKey.new()
        esc.keycode = KEY_ESCAPE
        esc.physical_keycode = KEY_ESCAPE
        esc.pressed = true
        Input.parse_input_event(esc)
        await get_tree().process_frame
        await get_tree().process_frame
        check("Escape поставил паузу и открыл меню",
            get_tree().paused and pm.root.visible)
        var esc2 := InputEventKey.new()
        esc2.keycode = KEY_ESCAPE
        esc2.physical_keycode = KEY_ESCAPE
        esc2.pressed = true
        Input.parse_input_event(esc2)
        await get_tree().process_frame
        await get_tree().process_frame
        check("второй Escape снял паузу",
            not get_tree().paused and not pm.root.visible)
        # открытое окно блокирует паузу
        world._inventory_ui.open()
        pm.open()
        check("при открытой сумке пауза не открывается",
            not pm.root.visible and not get_tree().paused)
        world._inventory_ui.close()
        # настройки: панель, звук/музыка, редактор управления
        pm.open()
        check("пауза открылась снова", get_tree().paused and pm.root.visible)
        pm._show_settings()
        check("панель настроек открылась из паузы",
            pm.settings_panel.visible and not pm.main_panel.visible)
        check("в настройках есть звук и музыка",
            pm.sound_check != null and pm.music_check != null
            and pm.sound_check.text == "Звук" and pm.music_check.text == "Музыка")
        pm._show_controls()
        check("редактор управления открывается из паузы", pm.controls_editor.visible)
        pm.controls_editor.back_requested.emit()
        check("назад из редактора возвращает в настройки",
            pm.settings_panel.visible and not pm.controls_editor.visible)
        # СОХРАНИТЬ: снимает паузу и сохраняет в слот
        pm._show_main()
        pm._on_save_pressed()
        await get_tree().process_frame
        check("СОХРАНИТЬ снял паузу и записал слот",
            not get_tree().paused and Game.current_slot >= 1
            and Platform.has_slot(Game.current_slot))
        pm.close()
        check("повторное закрытие безвредно", not get_tree().paused and not pm.root.visible)
    world.queue_free()
    await get_tree().process_frame

    # ================== иконка брони в HUD (данж) + пауза данжа ==================
    Game.new_run(1, "warrior")
    Game.dungeon_floor = 1
    var dungeon := await load_dungeon()
    check("HUD данжа: одна кнопка ИНВЕНТАРЬ",
        hud_button_texts(dungeon._hud_bar) == ["ИНВЕНТАРЬ"])
    check("в данже тоже есть блок «СПОСОБНОСТИ»",
        dungeon._hud_bar.get_node_or_null("AbilitiesBlock") != null)
    check("пауза прикреплена к данжу", dungeon._pause_menu != null
        and is_instance_valid(dungeon._pause_menu))
    var dun_armor: Dictionary = dungeon._hud_equip["armor"]
    check("слот брони данжа пуст на старте", (dun_armor["icon"] as TextureRect).texture == null)
    Game.add_item({"item_id": "armor_chain", "title": "Кольчуга", "quality": "green"})
    Game.equip_armor("armor_chain")
    var dun_tex: Texture2D = (dun_armor["icon"] as TextureRect).texture
    check("иконка брони в данже обновилась",
        dun_tex != null and String(dun_tex.resource_path).contains("armor_chain"))
    # при открытой сумке пауза данжа не открывается
    dungeon._inventory_ui.open()
    dungeon._pause_menu.open()
    check("в данже сумка блокирует паузу", not dungeon._pause_menu.root.visible)
    dungeon._inventory_ui.close()
    dungeon.queue_free()
    await get_tree().process_frame

    # ================== подсказка HUD ==================
    Game.new_run(1, "warrior")
    var hint := Controls.get_hud_hint(false,
        String(Game.ability_info("q").get("hint", "")),
        String(Game.ability_info("special").get("hint", "")),
        String(Game.ability_info("t").get("hint", "")))
    check("подсказка мира: пробел — рывок, Ctrl — щит",
        hint.contains("Пробел — Рывок") and hint.contains("Ctrl — Оборона щитом"))

    print("STEP30 TEST: ПРОВАЛОВ: ", failed)
    get_tree().quit(1 if failed else 0)

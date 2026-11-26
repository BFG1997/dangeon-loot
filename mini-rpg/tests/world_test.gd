## Тест мира (шаг 7): тайлмап, игрок, движение, коллизии,
## 6 NPC (Злус, Лира, Глот и Зоран в замке, Гура и Вирас на улице), двери данжей,
## диалоги с портретами и кнопкой «ТОРГОВАТЬ», лавка (покупка/продажа),
## инвентарь, HUD (хп/мана), заклинание мага, джойстик.
## Шаг 7: кнопка УДАР у всех героев, удар рукой/оружием по хп NPC,
## смерть NPC без воскрешения в сессии, память остальных NPC.
## Шаг 11: консоль UI сжата до 112 px, удар на ЛКМ, диалог на E —
## проверки InputMap и точек клика.
## Запуск: godot --headless --path . res://tests/world_test.tscn
extends Node

var failed := 0
var state_before: Dictionary
var slots_before := {}
var meta_before: Dictionary

func check(name: String, condition: bool) -> void:
    if condition:
        print("  [OK] ", name)
    else:
        failed += 1
        print("  [ПРОВАЛ] ", name)

func snapshot() -> void:
    state_before = Game.to_save_data()
    meta_before = Game.meta.duplicate(true)
    for slot in range(1, Game.SLOT_COUNT + 1):
        slots_before[slot] = Platform.load_data(slot)

func restore() -> void:
    Saves.wipe_all_slots()
    for slot in slots_before:
        var data: Dictionary = slots_before[slot]
        if not data.is_empty():
            Platform.save_data(data, slot)
    Game.meta = meta_before.duplicate(true)
    Game.current_slot = 0
    Game.save_meta()
    Game.load_save_data(state_before)
    var last := int(Game.meta.get("last_slot", 0))
    if last >= 1 and Platform.has_slot(last):
        Game.current_slot = last

func _ready() -> void:
    print("WORLD TEST: тайлы, игрок, NPC, диалоги, инвентарь, край мира")
    snapshot()
    Saves.wipe_all_slots()
    Game.meta["last_slot"] = 0
    Game.meta["last_bonus_date"] = ""
    Game.meta["pending_gold"] = 0
    Game.meta["pending_items"] = []
    Game.save_meta()
    Platform.calls.clear()
    Game.new_run(1, "barbarian")
    Platform.calls.clear()

    var world: Node2D = (load("res://scenes/world/world.tscn") as PackedScene).instantiate()
    add_child(world)
    await get_tree().process_frame
    await get_tree().process_frame

    # --- структура мира ---
    # Ground живёт внутри SubViewport (шаг 10/11): WalkScreen/WalkViewport/WorldContent
    var ground: TileMapLayer = world.get_node("WalkScreen/WalkViewport/WorldContent/Ground")
    check("тайлмап заполнен", ground.get_used_cells().size() == WorldMap.MAP_W * WorldMap.MAP_H)
    check("размер карты 60x56 (расширение хаба)", WorldMap.MAP_W == 60 and WorldMap.MAP_H == 56)
    check("спавн в замке", WorldMap.PLAYER_SPAWN.y <= WorldMap.CASTLE_LAST_ROW)

    var player: CharacterBody2D = world.player
    check("игрок создан", player != null)
    check("камера с границами карты", world._camera.limit_right == WorldMap.MAP_W * 16 \
        and world._camera.limit_bottom == WorldMap.MAP_H * 16)
    check("лист анимаций героя — варвар", world._hero_sheet_tex != null \
        and world._hero_sheet_tex.resource_path.contains("barbarian"))
    check("у игрока покадровые анимации", world._player_sprite.sprite_frames != null \
        and world._player_sprite.sprite_frames.has_animation("walk_down") \
        and world._player_sprite.sprite_frames.has_animation("idle_down"))

    # --- NPC: 4 в замке (Злус + Лира + Глот + Зоран), 2 на улице ---
    check("всего 6 NPC", world._npcs.size() == 6)
    var castle_npcs := 0
    var street_npcs := 0
    for npc in world._npcs:
        var ty: int = int((npc["tile"] as Vector2).y)
        if ty <= WorldMap.CASTLE_LAST_ROW:
            castle_npcs += 1
        elif ty < WorldMap.RAILING_ROW:
            street_npcs += 1
    check("4 NPC в замке (Злус, Лира, Глот, Зоран)", castle_npcs == 4)
    check("2 NPC на улице (Гура и Вирас)", street_npcs == 2)
    var ids := []
    for npc in world._npcs:
        ids.append(npc["id"])
    check("это Гура, Вирас, Злус, Лира, Глот, Зоран", "gura" in ids and "viras" in ids \
        and "zlus" in ids and "lira" in ids and "glot" in ids and "zoran" in ids)
    # у каждого NPC: лист спрайтов, портрет, золотой указатель
    var npcs_ok := true
    for npc in world._npcs:
        var data: Dictionary = npc["data"]
        if not ResourceLoader.exists(String(data["sheet"])) \
                or not ResourceLoader.exists(String(data["portrait"])):
            npcs_ok = false
    check("у всех NPC есть спрайты и портреты", npcs_ok)
    check("у NPC анимации idle/walk", (world._npcs[0]["sprite"] as AnimatedSprite2D) \
        .sprite_frames.has_animation("idle_down"))

    # --- двери данжей ---
    check("4 прохода в данжи", world._doors.size() == 4)
    var doors_on_top_wall := true
    for door in WorldMap.DOORS:
        for t in door["tiles"]:
            if int(t.y) != 0 or WorldMap.MAP[0][int(t.x)] != "D":
                doors_on_top_wall = false
    check("двери стоят в верхней стене замка", doors_on_top_wall)
    # шаг 9/13: двери явные — видимый спрайт, клик (и E рядом) отвечает.
    # Шаг 13: подписи «Данж N» убраны, дверь 1 открыта — ведёт в
    # Подземелье замка, остальные заперты.
    var door_node := world.get_node_or_null(
        "WalkScreen/WalkViewport/WorldContent/Door_dungeon_1") as Node2D
    check("у двери есть узел в мире", door_node != null)
    if door_node != null:
        var door_spr := door_node.get_node_or_null("Sprite") as Sprite2D
        check("у двери есть видимый спрайт", door_spr != null \
            and door_spr.texture != null \
            and door_spr.texture.resource_path.contains("door_dungeon"))
        var door_label: Label = null
        for child in door_node.get_children():
            if child is Label:
                door_label = child
        check("подписи «Данж N» на дверях больше нет (шаг 13)", door_label == null)
    var door_click := InputEventMouseButton.new()
    door_click.button_index = MOUSE_BUTTON_LEFT
    door_click.pressed = true
    # шаг 16: дверь 2 («Скит Пустоты») заперта шёпотом, пока не пройден данж 1
    world._on_door_input(null, door_click, 0, "dungeon_2")
    await get_tree().process_frame
    check("дверь 2 заперта шёпотом до победы над демоном", world._dialogue.visible \
        and world._dialogue._lines.size() > 0 \
        and String(world._dialogue._lines[0]).contains("шёпот"))
    check("с дверью 2 нельзя торговать", not world._dialogue._trade_button.visible)
    world._dialogue._close()
    await get_tree().process_frame
    # дверь 3 (шаг 20): «Глубины Р'льеха» — своя заглушка: заперто сном
    world._on_door_input(null, door_click, 0, "dungeon_3")
    await get_tree().process_frame
    check("дверь 3 заперта сном: сначала пройди Скит Пустоты", world._dialogue.visible \
        and world._dialogue._lines.size() > 0 \
        and String(world._dialogue._lines[0]).contains("дверью вода"))
    check("с запертой дверью нельзя торговать", not world._dialogue._trade_button.visible)
    world._dialogue._close()
    await get_tree().process_frame
    # шаг 16: данж 1 пройден — дверь 2 ведёт в Скит Пустоты (маршрут без диалога;
    # смену сцены в тесте не запускаем — флаг «уже переходим», как у двери 1)
    Game.dungeon_floor = 1
    Game.dungeons_cleared = ["dungeon_1"]
    world._open_door_dialog("dungeon_2")
    await get_tree().process_frame
    check("дверь 2 после победы над демоном — маршрут в скит (без диалога)", \
        not world._dialogue.visible and Game.current_dungeon == "dungeon_2")
    Game.dungeon_floor = 0
    Game.current_dungeon = "dungeon_1"
    Game.dungeons_cleared = []
    await get_tree().process_frame
    # шаг 13: дверь 1 открыта — маршрут в Подземелье замка. Смену сцены
    # в тесте не запускаем: под флагом «уже переходим» (dungeon_floor > 0)
    # вызов только подтверждает маршрут — диалог запертости не открывается.
    check("сцена данжа существует", ResourceLoader.exists("res://scenes/dungeon/dungeon.tscn"))
    Game.dungeon_floor = 1
    world._open_door_dialog("dungeon_1")
    await get_tree().process_frame
    check("дверь 1 не открывает диалог запертости", not world._dialogue.visible)
    check("маршрут двери 1 — вход в данж (флаг этажа)", Game.dungeon_floor == 1)
    Game.dungeon_floor = 0
    await get_tree().process_frame

    # --- диалог с портретом ---
    world.npc_say("gura")
    await get_tree().process_frame
    check("диалог открыт", world._dialogue.visible)
    check("в диалоге имя Гуры", world._dialogue._name_label.text == "Гура")
    check("в диалоге портрет Гуры", world._dialogue._portrait.texture != null \
        and world._dialogue._portrait.texture.resource_path.contains("gura"))
    check("реплика печатается", world._dialogue._text_label.text.length() > 0)
    check("у торговца в диалоге есть ТОРГОВАТЬ", world._dialogue._trade_button.visible)
    for _i in 8:
        world._dialogue._advance()
    await get_tree().process_frame
    check("диалог закрылся после реплик", not world._dialogue.visible)
    # шаг 6 (регресс мигания): то же нажатие E не переоткрывает диалог —
    # мир игнорирует interact первые 250 мс после закрытия.
    check("E сразу после закрытия заблокирован", not world._interact_allowed())
    await get_tree().create_timer(0.3).timeout
    check("после паузы E снова работает", world._interact_allowed())

    # --- торговля (шаг 5): товары NPC ---
    var goods_of := {}
    for npc_data in WorldMap.NPCS:
        goods_of[String(npc_data["id"])] = npc_data.get("goods", [])
    check("Гура торгует едой (окорок)", "ham" in goods_of["gura"] \
        and (goods_of["gura"] as Array).size() == 1)
    check("Глот торгует напитками: вода, морс, сок, пиво", "water" in goods_of["glot"] \
        and "mors" in goods_of["glot"] and "juice" in goods_of["glot"] \
        and "beer" in goods_of["glot"] and (goods_of["glot"] as Array).size() == 4)
    check("Зоран торгует магическим оружием и одеяниями (шаг 12)", "wand_lightning" in goods_of["zoran"] \
        and "blade_frost" in goods_of["zoran"] and "scepter_comet" in goods_of["zoran"] \
        and "robe_faded" in goods_of["zoran"] and "robe_void" in goods_of["zoran"] \
        and (goods_of["zoran"] as Array).size() == 6)
    check("Вирас торгует оружием", "sword" in goods_of["viras"] \
        and "greatsword" in goods_of["viras"] and "morgenstern" in goods_of["viras"])
    check("Злус торгует зельями", "hp_potion" in goods_of["zlus"])
    check("Лира не торговец", (goods_of["lira"] as Array).is_empty())
    # напитки Глота стоят растущим рядом (цена и хп)
    check("ряд напитков по цене", ItemDB.price("water") < ItemDB.price("mors") \
        and ItemDB.price("mors") < ItemDB.price("juice") \
        and ItemDB.price("juice") < ItemDB.price("beer"))

    # --- лавка: открытие из диалога, покупка и продажа через UI ---
    world.npc_say("gura")
    await get_tree().process_frame
    world._dialogue._trade_button.pressed.emit()
    await get_tree().process_frame
    check("реплики закрылись, лавка открылась", not world._dialogue.visible \
        and world._trade_ui.visible)
    check("в лавке Гуры 1 товар (пиво у Глота с шага 6)", world._trade_ui._rows.get_child_count() == 1)
    var gold_before: int = Game.gold
    var buy_row: HBoxContainer = world._trade_ui._rows.get_child(0)
    var buy_btn: Button = null
    for child in buy_row.get_children():
        if child is Button and (child as Button).text == "КУПИТЬ":
            buy_btn = child
    check("кнопка КУПИТЬ у первого товара найдена", buy_btn != null \
        and not (buy_btn as Button).disabled)
    if buy_btn != null:
        buy_btn.pressed.emit()
        await get_tree().process_frame
    check("покупка через UI списала 10 з.", Game.gold == gold_before - 10)
    check("купленный окорок в сумке", String((Game.inventory.back() as Dictionary) \
        .get("item_id", "")) == "ham")
    world._trade_ui._tab_sell.pressed.emit()
    await get_tree().process_frame
    check("вкладка ПРОДАЖА показывает сумку", \
        world._trade_ui._rows.get_child_count() == Game.inventory.size())
    var sell_row: HBoxContainer = world._trade_ui._rows.get_child(0)
    var sell_btn: Button = null
    for child in sell_row.get_children():
        if child is Button and (child as Button).text == "ПРОДАТЬ":
            sell_btn = child
    check("кнопка ПРОДАТЬ у окорока найдена", sell_btn != null \
        and not (sell_btn as Button).disabled)
    if sell_btn != null:
        sell_btn.pressed.emit()
        await get_tree().process_frame
    check("продажа через UI вернула 5 з.", Game.gold == gold_before - 5 \
        and Game.inventory.is_empty())
    world._trade_ui.close()
    check("лавка закрывается", not world._trade_ui.visible)
    world.npc_say("lira")
    await get_tree().process_frame
    check("у Лиры нет кнопки ТОРГОВАТЬ", not world._dialogue._trade_button.visible)
    world._dialogue._close()

    # --- инвентарь ---
    check("инвентарь закрыт по умолчанию", not world._inventory_ui.visible)
    world._inventory_ui.open()
    check("инвентарь открывается", world._inventory_ui.visible)
    check("в инвентаре 20 слотов", world._inventory_ui._grid.get_child_count() == 20)
    check("в инвентаре две ячейки экипировки (ОРУЖИЕ и БРОНЯ, шаг 12)", \
        world._inventory_ui._weapon_cell != null and world._inventory_ui._armor_cell != null)
    Game.add_item({"item_id": "star_blade", "title": "Звёздный клинок", "quality": "violet"})
    world._inventory_ui.open()
    var first_slot: PanelContainer = world._inventory_ui._grid.get_child(0)
    var has_icon := false
    for sub in first_slot.get_children():
        for subsub in sub.get_children():
            if subsub is TextureRect and subsub.texture != null:
                has_icon = true
    check("предмет из бонуса виден в слоте", has_icon)
    world._inventory_ui.close()
    check("инвентарь закрывается", not world._inventory_ui.visible)

    # --- анимированные пропы (факелы, фонтан, горн, жаровни) ---
    var animated_props := 0
    for prop in WorldMap.PROPS:
        if prop.has("anim"):
            animated_props += 1
    check("есть анимированные пропы (>=9)", animated_props >= 9)
    check("Лира и трон в замке", WorldMap.NPCS.any(
        func(n: Dictionary) -> bool: return n["id"] == "lira" and n["zone"] == "castle"))

    # --- коллизии: ограда края мира непроходима ---
    # шаг 10: физика мира живёт в SubViewport экрана ходьбы, поэтому
    # пространство запрашиваем через игрока (он внутри этого мира).
    # Фикс шага 11 (Godot 4.7.2): world.player через переменную типа Node2D —
    # это Variant, и «:=» не может вывести тип (Parse Error: Cannot infer
    # the type of "space"/"hits" variable). Ставим явные типы.
    var walker: CharacterBody2D = world.player
    var space: PhysicsDirectSpaceState2D = walker.get_world_2d().direct_space_state
    var query := PhysicsPointQueryParameters2D.new()
    query.position = Vector2(480, WorldMap.RAILING_ROW * 16.0 + 8.0)   # середина острова
    query.collision_mask = 1
    var hits: Array = space.intersect_point(query, 4)
    check("ограда края имеет коллизию", hits.size() > 0)

    # --- движение: игрок слушает действия ввода ---
    var x_before: float = player.position.x
    Input.action_press("move_left")
    for _i in 30:
        await get_tree().physics_frame
    Input.action_release("move_left")
    check("влево игрок идёт", player.position.x < x_before - 5.0)

    # --- игрок не проваливается за край ---
    var controls_hint: String = world._hud_hint.text   # подсказка до сообщений у края
    player.position = Vector2(480, 45 * 16.0 - 6.0)
    Input.action_press("move_down")
    for _i in 90:
        await get_tree().physics_frame
    Input.action_release("move_down")
    check("ограда остановила игрока", player.position.y < WorldMap.RAILING_ROW * 16.0 + 2.0)

    # --- замок: стены верхнего ряда не проходимы ---
    player.position = Vector2(23 * 16.0 + 8.0, 2 * 16.0 + 8.0)
    Input.action_press("move_up")
    for _i in 60:
        await get_tree().physics_frame
    Input.action_release("move_up")
    check("стена замка остановила игрока", player.position.y > 8.0)

    # --- смена героя подменяет лист анимаций ---
    Game.hero_id = "warrior"
    world._apply_hero_textures()
    check("анимации воина применились", world._hero_sheet_tex.resource_path.contains("warrior"))
    Game.hero_id = "barbarian"
    world._apply_hero_textures()

    # --- HUD ---
    var hud_gold: Label = world.get_node("HUD/HudBar").get_children().filter(
        func(c: Node) -> bool: return c is PanelContainer)[0].get_child(0).get_child(1).get_child(1)
    check("HUD показывает золото", hud_gold.text == "Золото: %d" % Game.gold)
    Game.add_gold(11)
    check("HUD реагирует на золото", hud_gold.text == "Золото: %d" % (Game.gold))
    Game.spend_gold(11)
    check("подсказка управления: E — говорить, ЛКМ — удар", controls_hint.contains("E — говорить") \
        and controls_hint.contains("ЛКМ — удар"))
    # шаг 11: удар переехал на ЛКМ, диалог — на E (F тоже работает)
    var lmb_attack := false
    var e_in_attack := false
    for ev in InputMap.action_get_events("attack"):
        if ev is InputEventMouseButton \
                and (ev as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT:
            lmb_attack = true
        if ev is InputEventKey and (ev as InputEventKey).physical_keycode == KEY_E:
            e_in_attack = true
    check("удар на ЛКМ и больше не на E", lmb_attack and not e_in_attack)
    var e_interact := false
    for ev in InputMap.action_get_events("interact"):
        if ev is InputEventKey and (ev as InputEventKey).physical_keycode == KEY_E:
            e_interact = true
    check("диалог на E", e_interact)
    # шаг 20: удар по умолчанию на F (ЛКМ тоже работает), бег — на Shift
    var f_attack := false
    for ev in InputMap.action_get_events("attack"):
        if ev is InputEventKey and (ev as InputEventKey).physical_keycode == KEY_F:
            f_attack = true
    check("удар на F по умолчанию", f_attack)
    check("действие run есть и на Shift", InputMap.has_action("run") \
        and (InputMap.action_get_events("run")[0] as InputEventKey).physical_keycode == KEY_SHIFT)
    # шаг 30: в HUD одна кнопка — ИНВЕНТАРЬ (меню/сейвы — в паузе на Escape)
    var hud_texts: Array[String] = []
    for child in world._hud_bar.get_children():
        if child is Button and child.has_meta("action_button"):
            hud_texts.append((child as Button).text)
    check("в HUD одна кнопка: ИНВЕНТАРЬ",
        hud_texts == ["ИНВЕНТАРЬ"])
    check("HUD показывает «В руках: Кулаки»", world._hud_weapon.text.contains("Кулаки"))

    # --- джойстик ---
    # шаг 26 (ПК): джойстик нужен только на сенсорных экранах (шаг 25);
    # в headless-прогоне сенсорного ввода нет — джойстик не спавнится.
    check("VirtualJoystick подключён",
        world._joystick != null or not DisplayServer.is_touchscreen_available())

    # --- шаг 20: дверь 3 «Глубины Р'льеха» заперта до победы в ските ---
    world._open_door_dialog("dungeon_3")
    await get_tree().process_frame
    check("дверь 3 заперта до победы в Ските Пустоты", world._dialogue.visible \
        and String(world._dialogue._name_label.text).contains("глубин"))
    world._dialogue._close()
    await get_tree().process_frame

    # --- шаг 11: компактная консоль и клик-удар ---
    check("консоль UI сжата до 112 px (экран ходьбы вырос)", world.UI_BAR_H == 112.0 \
        and world._walk_holder.size == world.get_viewport_rect().size - Vector2(0, world.UI_BAR_H))
    var npc_pos: Vector2 = (world._npcs[0]["node"] as Node2D).position
    check("точка NPC интерактивна (клик по ней не бьёт)", \
        world._point_on_interactive(npc_pos + Vector2(0, -16)))
    check("пустая точка мира не интерактивна", \
        not world._point_on_interactive(Vector2(420, 300)))

    # --- жизненный цикл площадки ---
    check("gameplay_start вызван миром", "gameplay_start" in Platform.calls)

    world.free()
    await get_tree().process_frame

    # --- шаг 6: мир под магом — мана в HUD, кнопка МАГИЯ, снаряд ---
    Game.new_run(2, "mage")
    var world_mage: Node2D = (load("res://scenes/world/world.tscn") as PackedScene).instantiate()
    add_child(world_mage)
    await get_tree().process_frame
    await get_tree().process_frame
    check("HUD мага: полоса маны есть", world_mage._hud_mana != null)
    check("HUD мага: одна кнопка ИНВЕНТАРЬ (шаг 30)",
        world_mage._hud_bar.get_children().filter(
            func(c: Node) -> bool: return c is Button \
                and c.has_meta("action_button")).size() == 1)
    check("мана мага полная (70)", Game.mana == 70 and Game.max_mana() == 70)
    check("лист анимаций героя — маг", world_mage._hero_sheet_tex.resource_path.contains("mage"))
    check("каст через Game списал ману", Game.cast_spell() \
        and Game.mana == 70 - int(Game.SPELL["cost"]))
    world_mage._spawn_bolt(Vector2(1, 0))
    check("снаряд появился в мире", world_mage._bolts.size() == 1)
    var bolt_node: Sprite2D = world_mage._bolts[0]["node"]
    var bx: float = bolt_node.position.x
    for _i in 10:
        await get_tree().physics_frame
    check("снаряд летит вправо", bolt_node.position.x > bx + 20.0)
    for _i in 80:
        await get_tree().physics_frame
    check("снаряд гаснет в конце дистанции", world_mage._bolts.is_empty())
    # --- шаг 9: магия наносит урон NPC (как удар, но издалека) ---
    var zl: Dictionary = {}
    for npc in world_mage._npcs:
        if String(npc["id"]) == "zlus":
            zl = npc
    check("Злус найден в мире мага с полным хп", not zl.is_empty() \
        and int(zl["hp"]) == 40)
    world_mage.player.position = (zl["node"] as Node2D).position + Vector2(-20, 0)
    world_mage._facing = "side"
    world_mage._player_sprite.flip_h = false
    world_mage._spawn_bolt(Vector2(1, 0))
    check("стрела запущена в Злуса", world_mage._bolts.size() == 1)
    for _i in 12:
        await get_tree().physics_frame
    check("магическая стрела сняла %d хп Злуса (40 -> %d)" \
        % [int(Game.SPELL["damage"]), 40 - int(Game.SPELL["damage"])],
        int(zl["hp"]) == 40 - int(Game.SPELL["damage"]))
    check("стрела исчезла при попадании", world_mage._bolts.is_empty())
    check("полоска хп Злуса показана после магии", (zl["hp_bar"] as ProgressBar).visible)
    # --- шаг 12: залп магического оружия — веер снарядов вместо одной стрелы ---
    world_mage.player.position = Vector2(480, 30 * 16.0)   # пустая улица
    world_mage._facing = "side"
    world_mage._player_sprite.flip_h = false
    Game.add_item({"item_id": "wand_lightning", "title": "Жезл молний", "quality": "gray"})
    check("маг взял жезл в руки (35 урона)", Game.equip_weapon("wand_lightning") \
        and Game.strike_damage() == 35)
    var volley := Game.spell_info()
    check("Q жезла — «Залп молний»: 3 стрелы за 15 маны", \
        String(volley.get("title", "")) == "Залп молний" \
        and int(volley.get("count", 0)) == 3 and int(volley.get("cost", 0)) == 15)
    world_mage._spell_cd = 0.0
    world_mage._cast_spell()
    check("залп выпустил 3 снаряда", world_mage._bolts.size() == 3)
    for _i in 110:
        await get_tree().physics_frame
    check("залп погас в конце дистанции", world_mage._bolts.is_empty())
    Game.unequip_weapon()
    world_mage.free()
    await get_tree().process_frame

    # --- шаг 7: удары по NPC, хп, смерть, память остальных ---
    Game.new_run(3, "warrior")
    var world_w: Node2D = (load("res://scenes/world/world.tscn") as PackedScene).instantiate()
    add_child(world_w)
    await get_tree().process_frame
    await get_tree().process_frame
    var glot: Dictionary = {}
    for npc in world_w._npcs:
        if String(npc["id"]) == "glot":
            glot = npc
    check("Глот найден с хп 50", not glot.is_empty() and int(glot["max_hp"]) == 50)
    # воин вплотную слева от Глота, смотрит вправо
    world_w.player.position = (glot["node"] as Node2D).position + Vector2(-18, 0)
    world_w._facing = "side"
    world_w._player_sprite.flip_h = false
    # кулаки: 5 урона за удар
    world_w._strike_cd = 0.0
    world_w._strike()
    check("удар рукой снял 5 хп (50 -> 45)", int(glot["hp"]) == 45)
    check("полоска хп появилась над Глотом", (glot["hp_bar"] as ProgressBar).visible)
    check("куладдаун удара включился", world_w._strike_cd > 0.0)
    world_w._strike()
    check("куладдаун не даёт бить дважды подряд", int(glot["hp"]) == 45)
    # меч из сумки: 30 урона
    Game.add_item({"item_id": "sword", "title": "Меч", "quality": "gray"})
    check("меч в руках через Game", Game.equip_weapon("sword") and Game.strike_damage() == 30)
    check("HUD обновил оружие в руках", world_w._hud_weapon.text.contains("Меч"))
    world_w._strike_cd = 0.0
    world_w._strike()
    check("удар мечом снял 30 хп (45 -> 15)", int(glot["hp"]) == 15)
    # добиваем: 30 урона по остатку 15
    world_w._strike_cd = 0.0
    world_w._strike()
    check("Глот мёртв", bool(glot["dead"]) and Game.is_npc_dead("glot") and int(glot["hp"]) == 0)
    await get_tree().process_frame
    check("труп: спрайт повален на бок", absf((glot["sprite"] as AnimatedSprite2D).rotation) > 1.0)
    check("труп: коллизия выключена", (glot["body"].get_child(0) as CollisionShape2D).disabled)
    check("труп: полоска хп скрыта", not (glot["hp_bar"] as ProgressBar).visible)
    # мёртвый не разговаривает и не торгует
    world_w.npc_say("glot")
    await get_tree().process_frame
    check("труп молчит", not world_w._dialogue.visible)
    # остальные помнят убийство: реплика про жертву + отказ торговать
    world_w.npc_say("gura")
    await get_tree().process_frame
    check("Гура помнит: реплика про Глота", world_w._dialogue.visible \
        and world_w._dialogue._text_label.text.contains("Глота"))
    check("Гура не торгует с убийцей", not world_w._dialogue._trade_button.visible)
    world_w._dialogue._close()
    world_w.free()
    await get_tree().process_frame
    # новая игра воскрешает NPC (список убитых живёт только в сессии)
    Game.new_run(3, "warrior")
    check("новая игра воскресила NPC", Game.dead_npcs.is_empty())

    # Возвращаем исходное состояние, чтобы тест не портил сейвы.
    restore()

    if failed == 0:
        print("WORLD TEST: ВСЁ ОК")
        get_tree().quit(0)
    else:
        print("WORLD TEST: ПРОВАЛОВ: ", failed)
        get_tree().quit(1)

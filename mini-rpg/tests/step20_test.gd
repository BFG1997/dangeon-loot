## Тест полировки шага 20: бег на Shift, третьи приёмы T у четырёх
## классов (выплеск магии / передышка / смертельный прыжок / град мечей),
## лечение до полного ХП при повышении уровня, HUD из трёх кнопок
## (МЕНЮ / СУМКА / СОХРАНИТЬ / ЗАГРУЗИТЬ), быстрое сохранение в слот,
## дверь 3 заперта до победы в Ските Пустоты, приёмы T в мире, звук
## шага 20 (18 эффектов + эмбиент). Управление сбрасывается к дефолтам
## в начале теста (профиль v3).
## Запуск: godot --headless --path . res://tests/step20_test.tscn
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

func any_living_foe(world: Node2D, boss_only: bool = false) -> Dictionary:
    for foe in world._foes:
        if bool(foe.get("dead", false)):
            continue
        if bool(foe.get("boss", false)) != boss_only:
            continue
        return foe
    return {}

func hud_button_texts(hud_bar: Control) -> Array[String]:
    var texts: Array[String] = []
    for child in hud_bar.get_children():
        if child is Button and child.has_meta("action_button"):
            texts.append((child as Button).text)
    return texts

func _ready() -> void:
    print("STEP20 TEST: бег, приёмы T, лечение уровнем, HUD, дверь 3, звук")
    Saves.wipe_all_slots()
    Game.meta["last_slot"] = 0
    Game.meta["last_bonus_date"] = ""
    Game.meta["pending_gold"] = 0
    Game.meta["pending_items"] = []
    Game.save_meta()
    Controls.reset_defaults()

    # ================== управление шага 20 ==================
    check("действие run есть и на Shift по умолчанию",
        InputMap.has_action("run")
        and (InputMap.action_get_events("run")[0] as InputEventKey).physical_keycode == KEY_SHIFT)
    check("special2 есть и на T по умолчанию",
        InputMap.has_action("special2")
        and (InputMap.action_get_events("special2")[0] as InputEventKey).physical_keycode == KEY_T)
    var f_attack := false
    for ev in InputMap.action_get_events("attack"):
        if ev is InputEventKey and (ev as InputEventKey).physical_keycode == KEY_F:
            f_attack = true
    check("удар по умолчанию на F (ЛКМ тоже)", f_attack)
    var f_in_interact := false
    for ev in InputMap.action_get_events("interact"):
        if ev is InputEventKey and (ev as InputEventKey).physical_keycode == KEY_F:
            f_in_interact = true
    check("взаимодействие — только E (F переехал на удар)",
        not f_in_interact
        and (InputMap.action_get_events("interact")[0] as InputEventKey).physical_keycode == KEY_E)
    check("профиль управления v3", Controls.PROFILE_VERSION == 3)

    # ================== звук шага 20 ==================
    check("у Sfx 20 эффектов, включая приёмы T и голос Ктулху",
        Sfx.SOUNDS.size() == 20 and Sfx.SOUNDS.has("surge")
        and Sfx.SOUNDS.has("heal") and Sfx.SOUNDS.has("leap")
        and Sfx.SOUNDS.has("rain") and Sfx.SOUNDS.has("roar")
        and Sfx.SOUNDS.has("slam"))
    var audio_ok := true
    for sound_name in Sfx.SOUNDS:
        if not ResourceLoader.exists("res://assets/audio/sfx/"
                + String(Sfx.SOUNDS[sound_name])):
            audio_ok = false
    check("все файлы эффектов на месте", audio_ok)
    check("эмбиент шага 20 существует",
        ResourceLoader.exists(Sfx.AMBIENT_PATH))

    # ================== уровень лечит героя ==================
    Game.new_run(1, "warrior")
    Game.hp = 1
    Game.add_xp(Game.xp_needed())
    check("повышение уровня лечит героя полностью",
        Game.level == 2 and Game.hp == Game.max_hp())

    # ================== маг: выплеск (T) ==================
    Game.new_run(1, "mage")
    Game.dungeon_floor = 1
    var dungeon: Node2D = await load_dungeon()
    Game.mana = 50
    var before_hps := {}
    for foe in dungeon._foes:
        if not bool(foe.get("dead", false)):
            before_hps[foe["node"]] = int(foe["hp"])
    dungeon._on_t_pressed()
    check("выплеск магии тратит ВСЮ ману", Game.mana == 0)
    check("кулдаун выплеска 14 с (шаг 22)", dungeon._t_cd > 13.0)
    var burst_ok := true
    for foe in dungeon._foes:
        if not before_hps.has(foe["node"]):
            continue
        var was: int = before_hps[foe["node"]]
        if bool(foe.get("dead", false)):
            if was > 20:
                burst_ok = false
        else:
            if int(foe["hp"]) != was - 20:
                burst_ok = false
    check("выплеск бьёт всех врагов карты ровно на 20 (уровень 1)", burst_ok)
    dungeon.free()
    await get_tree().process_frame

    # ================== бомж: передышка (T) ==================
    Game.new_run(1, "bum")
    Game.dungeon_floor = 1
    var d2: Node2D = await load_dungeon()
    Game.damage_hp(7)
    check("бомж ранен перед передышкой", Game.hp < Game.max_hp())
    d2._on_t_pressed()
    check("передышка восстанавливает всё ХП", Game.hp == Game.max_hp())
    check("кулдаун передышки 25 с (шаг 22)", d2._t_cd > 24.0)
    d2.free()
    await get_tree().process_frame

    # ================== варвар: смертельный прыжок (пробел, шаг 22) ======
    Game.new_run(1, "barbarian")
    Game.dungeon_floor = 1
    var d3: Node2D = await load_dungeon()
    var target: Dictionary = any_living_foe(d3, false)
    check("рядом есть цель для прыжка", not target.is_empty())
    (target["node"] as Node2D).position = d3.player.position + Vector2(30, 0)
    d3._on_special_pressed()
    check("прыжок с пробела: полёт запущен, кулдаун 15 с",
        not d3._leap_flight.is_empty() and d3._special_cd > 14.0)
    for i in range(120):
        await get_tree().physics_frame
        if d3._leap_flight.is_empty():
            break
    check("прыжок приземлился", d3._leap_flight.is_empty())
    check("враг раздавлен одним прыжком", bool(target.get("dead", false)))
    d3.free()
    await get_tree().process_frame

    # ================== воин: град мечей (T) ==================
    Game.new_run(1, "warrior")
    Game.dungeon_floor = 1
    var d4: Node2D = await load_dungeon()
    var victim: Dictionary = any_living_foe(d4, false)
    var victim_hp: int = int(victim["hp"])
    (victim["node"] as Node2D).position = d4.player.position + Vector2(0, 24)
    d4._do_sword_rain(Game.ability_info("t"))
    check("град мечей: 12 клинков летят", d4._sword_rain.size() == 12)
    for rec in d4._sword_rain:
        rec["target"] = (victim["node"] as Node2D).position
    for i in range(120):
        await get_tree().physics_frame
        if d4._sword_rain.is_empty():
            break
    check("град мечей отгремел", d4._sword_rain.is_empty())
    check("мечи бьют урон актуального удара (враг ранен или мёртв)",
        bool(victim.get("dead", false)) or int(victim["hp"]) < victim_hp)

    # ================== HUD и сохранение ==================
    check("HUD подземелья: МЕНЮ / СУМКА / СОХРАНИТЬ / ЗАГРУЗИТЬ",
        hud_button_texts(d4._hud_bar) == ["МЕНЮ", "СУМКА", "СОХРАНИТЬ", "ЗАГРУЗИТЬ"])
    var slot := Game.current_slot
    d4._on_save_pressed()
    await get_tree().process_frame
    check("СОХРАНИТЬ пишет текущий слот", slot >= 1 and Platform.has_slot(slot))
    var saved_gold: int = Game.gold
    Game.gold = saved_gold + 500   # прямая мутация без автосейва
    Game.continue_run(slot)
    check("ЗАГРУЗИТЬ откатывает состояние из слота", Game.gold == saved_gold)
    d4.free()
    await get_tree().process_frame

    # ================== мир: дверь 3 и приёмы T ==================
    Game.new_run(2, "warrior")
    var world: Node2D = (load("res://scenes/world/world.tscn") as PackedScene).instantiate()
    add_child(world)
    await get_tree().process_frame
    await get_tree().process_frame
    world._open_door_dialog("dungeon_3")
    await get_tree().process_frame
    check("дверь 3 заперта до победы в Ските Пустоты", world._dialogue.visible
        and String(world._dialogue._name_label.text).contains("глубин"))
    world._dialogue._close()
    await get_tree().process_frame
    check("HUD мира: МЕНЮ / СУМКА / СОХРАНИТЬ / ЗАГРУЗИТЬ",
        hud_button_texts(world._hud_bar) == ["МЕНЮ", "СУМКА", "СОХРАНИТЬ", "ЗАГРУЗИТЬ"])
    Game.hero_id = "bum"
    Game.hp = 5
    world._on_t_pressed()
    check("в мире передышка лечит героя", Game.hp == Game.max_hp())
    world.free()
    await get_tree().process_frame

    if failed == 0:
        print("STEP20 TEST: ВСЁ ОК")
        get_tree().quit(0)
    else:
        print("STEP20 TEST: ПРОВАЛОВ: ", failed)
        get_tree().quit(1)

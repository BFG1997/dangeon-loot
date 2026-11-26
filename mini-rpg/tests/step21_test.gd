## Тест шага 21: Ктулху стал УСТРАШАЮЩИМ; кнопка инвентаря в HUD (шаг 30:
## единственная кнопка ИНВЕНТАРЬ). Проверки: кнопка HUD в мире и данже,
## кнопка открывает инвентарь; статы Ктулху (hp 850, урон 26, x4); глаза-угли
## и аура; рёв после диалога; удар щупалец (круг-предупреждение, 30 урона);
## веер из 5 болтов безумия; шёпоты Р'льеха; призыв Отродий звёзд на 70%/35%;
## фаза 2 «небо гаснет» (воздух темнеет, когти быстрее); при победе воздух
## возвращается. Звук: 22 эффекта (шаг 27 добавил crit/dash), roar/slam на месте.
## Запуск: godot --headless --path . res://tests/step21_test.tscn
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

func hud_button_texts(hud_bar: Control) -> Array[String]:
    var texts: Array[String] = []
    for child in hud_bar.get_children():
        if child is Button and child.has_meta("action_button"):
            texts.append((child as Button).text)
    return texts

func _ready() -> void:
    print("STEP21 TEST: страшный Ктулху + СУМКА в кнопках")
    Saves.wipe_all_slots()

    # ================== звук шага 21 ==================
    check("Sfx: 22 эффекта, есть roar/slam и боевые crit/dash",
        Sfx.SOUNDS.size() == 22 and Sfx.SOUNDS.has("roar")
        and Sfx.SOUNDS.has("crit") and Sfx.SOUNDS.has("dash")
        and Sfx.SOUNDS.has("slam"))
    check("файл рёва существует",
        ResourceLoader.exists("res://assets/audio/sfx/" + String(Sfx.SOUNDS["roar"])))
    check("файл удара щупалец существует",
        ResourceLoader.exists("res://assets/audio/sfx/" + String(Sfx.SOUNDS["slam"])))

    # ================== статы Ктулху ==================
    var b3: Dictionary = DungeonBestiary.boss_for("dungeon_3")
    check("Ктулху: hp 850, урон 26, x4, досягаемость 46",
        int(b3.get("hp", 0)) == 850 and int(b3.get("damage", 0)) == 26
        and int(b3.get("scale", 0)) == 4 and int(b3.get("attack_range", 0)) == 46)
    check("Ктулху: xp 500, золото 650",
        int(b3.get("xp", 0)) == 500 and int(b3.get("gold", 0)) == 650)
    var whispers: Array = DungeonBestiary.dungeon_meta("dungeon_3").get("boss_whispers", [])
    check("шёпоты Р'льеха описаны (4 реплики)", whispers.size() == 4)

    # ================== бой с Ктулху ==================
    Game.new_run(3, "warrior")
    Game.current_dungeon = "dungeon_3"
    Game.dungeon_floor = 4
    var dun: Node2D = await load_dungeon()
    var boss: Dictionary = dun._boss_record()
    check("Ктулху на 4-м этаже", not boss.is_empty()
        and String(boss["id"]) == "boss_cthulhu")
    check("глаза-угли и таймеры тактики на месте",
        boss.has("eyes") and (boss["eyes"] as Array).size() == 2
        and boss.has("slam_cd") and boss.has("volley_cd"))
    check("HUD данжа: одна кнопка ИНВЕНТАРЬ",
        hud_button_texts(dun._hud_bar) == ["ИНВЕНТАРЬ"])
    dun._on_bag_pressed()
    await get_tree().process_frame
    check("ИНВЕНТАРЬ открывает инвентарь в данже", dun._inventory_ui.visible)
    dun._on_bag_pressed()
    await get_tree().process_frame
    check("ИНВЕНТАРЬ закрывает инвентарь", not dun._inventory_ui.visible)

    # диалог и пробуждение: рёв, агрессия
    dun._open_boss_dialog()
    await get_tree().process_frame
    dun._dialogue._close()
    await get_tree().process_frame
    check("после диалога Ктулху дерётся", dun._boss_hostile)
    boss["aggro"] = true
    boss["speed_override"] = 0.0     # босс не подходит — чистота проверок
    # Шаг 23 (стабильность): замораживаем и отгоняем обычных врагов этажа.
    # Раньше они добегали до героя между проверками: точная проверка
    # «-30 урона» ломалась лишним ударом, а редкая смерть 50-хп воина
    # до веера болтов делала «веер безумия» невыполнимым (Game.hp > 0).
    for foe in dun._foes:
        if bool(foe.get("boss", false)) or bool(foe.get("dead", false)):
            continue
        foe["speed_override"] = 0.0
        foe["aggro"] = 0.0
        (foe["node"] as Node2D).position += Vector2(0, -800)

    # --- удар щупалец: круг-предупреждение, потом урон
    Game.hero_immune = false
    var hp_before: int = Game.hp
    boss["slam_cd"] = 0.0
    boss["volley_cd"] = 999.0
    var told := false
    for i in range(30):
        await get_tree().physics_frame
        if boss.has("slam_at") and boss.has("slam_mark"):
            told = true
            break
    check("щупальца предупреждают кругом", told)
    if told:
        (dun.player as Node2D).position = boss["slam_pos"]   # стоим в круге
        var hit := false
        for i in range(140):
            await get_tree().physics_frame
            if not boss.has("slam_at"):
                hit = true
                break
        check("удар щупалец состоялся", hit)
        check("удар щупалец нанёс 30 урона", Game.hp == hp_before - 30)
        check("круг-предупреждение погас",
            not boss.has("slam_mark"))

    # --- веер болтов безумия
    Game.hero_immune = true     # болты не должны убить героя в тесте
    boss["volley_cd"] = 0.0
    for i in range(10):
        await get_tree().physics_frame
        if dun._foe_bolts.size() >= 5:
            break
    check("веер безумия: 5 болтов", dun._foe_bolts.size() == 5)
    dun._foe_bolts.clear()      # убрать снаряды из дальнейших проверок

    # --- шёпоты Р'льеха
    boss["whisper_cd"] = 0.0
    await get_tree().physics_frame
    await get_tree().physics_frame
    check("шёпот Р'льеха звучит",
        String(dun._hud_hint.text).contains("Шёпот Р'льеха"))

    # --- призывы отродий (70% и 35%)
    var base_foes: int = dun._foes.size()
    boss["hp"] = int(float(boss["max_hp"]) * 0.6)
    for i in range(20):
        await get_tree().physics_frame
        if dun._foes.size() >= base_foes + 2:
            break
    check("на 70% ХП призваны Отродья звёзд", dun._foes.size() == base_foes + 2)
    var stars := 0
    for foe in dun._foes:
        if String(foe.get("id", "")) == "star_spawn":
            stars += 1
    check("призваны именно Отродья звёзд (4 шт. к концу)", stars >= 2)
    boss["hp"] = int(float(boss["max_hp"]) * 0.3)
    for i in range(20):
        await get_tree().physics_frame
        if dun._foes.size() >= base_foes + 4:
            break
    check("на 35% ХП призваны ещё Отродья", dun._foes.size() >= base_foes + 4)
    stars = 0
    for foe in dun._foes:
        if String(foe.get("id", "")) == "star_spawn":
            stars += 1
    check("отродий звёзд стало не меньше четырёх (4 призваны)",
        stars >= 4)

    # --- фаза 2: небо гаснет
    boss["hp"] = int(float(boss["max_hp"]) * 0.4)
    var phase2 := false
    for i in range(30):
        await get_tree().physics_frame
        if bool(boss.get("phase2", false)):
            phase2 = true
            break
    check("фаза 2 наступила на 40% ХП", phase2)
    check("небо над Р'льехом гаснет (темнее базового)",
        dun._air.color.r < dun._air_base.r * 0.75
        and dun._air.color.g < dun._air_base.g * 0.75)
    check("когти Ктулху в фазе 2 быстрее",
        float(boss.get("attack_cd_override", -1.0)) == 0.85
        and float(boss.get("speed_override", -1.0)) == 62.0)

    # --- победа: воздух возвращается
    dun._hit_foe(boss, 99999)
    await get_tree().process_frame
    check("Ктулху повержен", bool(boss.get("dead", false)))
    check("небо вернулось после победы", dun._air.color == dun._air_base)
    dun.free()
    await get_tree().process_frame

    # ================== мир: СУМКА в кнопках ==================
    Game.new_run(2, "warrior")
    var world: Node2D = (load("res://scenes/world/world.tscn") as PackedScene).instantiate()
    add_child(world)
    await get_tree().process_frame
    await get_tree().process_frame
    check("HUD мира: одна кнопка ИНВЕНТАРЬ",
        hud_button_texts(world._hud_bar) == ["ИНВЕНТАРЬ"])
    world._on_bag_pressed()
    await get_tree().process_frame
    check("ИНВЕНТАРЬ открывает инвентарь в мире", world._inventory_ui.visible)
    world._on_bag_pressed()
    await get_tree().process_frame
    check("ИНВЕНТАРЬ закрывает инвентарь", not world._inventory_ui.visible)
    world.free()
    await get_tree().process_frame

    if failed == 0:
        print("STEP21 TEST: ВСЁ ОК")
        get_tree().quit(0)
    else:
        print("STEP21 TEST: ПРОВАЛОВ: ", failed)
        get_tree().quit(1)

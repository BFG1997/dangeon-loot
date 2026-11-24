## Тест подземелья (шаги 13–15): генерация 4 больших тематических этажей,
## пулы врагов по глубине, элитные чемпионы и хранитель сокровищницы,
## факелы/реквизит/мозаика/ковёр, лестница вниз открыта сразу (шаг 19),
## переход между этажами, босс 4-го этажа (Таинственный демон):
## мирен до диалога, узнаёт героя, если видели его у края мира, дерётся
## после реплик, при смерти — demon_defeated, ожившие NPC, данж пройден,
## выход в замок; после победы босса на 4-м этаже его больше нет.
## Шаг 17: коридоры шириной 3 для кайтинга (полосы-вырезы, проход зала
## босса, BFS-связность всех этажей двух данжей, враги медленнее героя).
## Шаг 19: сундуки 5–7, лестница открыта, опыт/уровни (математика, урон
## приёмов), 14 видов оружия с иконками, xp у всех врагов, звук (Sfx).
## Шаг 20: данж 3 «Глубины Р'льеха» (этажи, чудовища, Ктулху, победа),
## BFS-связность 12 этажей трёх данжей, кайт против всех бестиариев.
## Запуск: godot --headless --path . res://tests/dungeon_test.tscn
extends Node

var failed := 0

func check(name: String, condition: bool) -> void:
    if condition:
        print("  [OK] ", name)
    else:
        failed += 1
        print("  [ПРОВАЛ] ", name)

func find_foe(world: Node2D, foe_id: String) -> Dictionary:
    for foe in world._foes:
        if String(foe["id"]) == foe_id and not bool(foe.get("dead", false)):
            return foe
    return {}

func _ready() -> void:
    print("DUNGEON TEST: этажи, враги, лестницы, босс, вечная смерть демона")
    Saves.wipe_all_slots()
    Game.meta["last_slot"] = 0
    Game.meta["last_bonus_date"] = ""
    Game.meta["pending_gold"] = 0
    Game.meta["pending_items"] = []
    Game.save_meta()
    Game.new_run(1, "warrior")

    # --- жертвы до подземелья: босс вернёт их к жизни ---
    Game.kill_npc("glot")
    Game.kill_npc("lira")
    check("до подземелья убиты двое жителей", Game.dead_npcs.size() == 2)

    # --- вход на 1-й этаж ---
    Game.dungeon_floor = 1
    var dungeon: Node2D = (load("res://scenes/dungeon/dungeon.tscn") as PackedScene).instantiate()
    add_child(dungeon)
    await get_tree().process_frame
    await get_tree().process_frame

    check("этаж 1 установлен в Game", Game.dungeon_floor == 1 \
        and dungeon._floor_num == 1)
    check("сетка этажа 64x48 сгенерирована", dungeon._grid.size() == DungeonBestiary.MAP_H \
        and String(dungeon._grid[0]).length() == DungeonBestiary.MAP_W)
    check("есть лестница наверх", not dungeon._stairs_up.is_empty())
    check("есть лестница вниз", not dungeon._stairs_down.is_empty())
    check("на этаже 7–9 врагов (шаг 15)", dungeon._foes.size() >= 7 \
        and dungeon._foes.size() <= 9)
    check("тема этажа — Смрадные катакомбы", \
        String(dungeon._theme.get("id", "")) == "catacombs")
    var pool_ok := true
    for foe in dungeon._foes:
        if String(foe["id"]) != "spider" and String(foe["id"]) != "snake":
            pool_ok = false   # на 1-м этаже только пауки и змеи (пул 1+этаж)
    check("на 1-м этаже только пауки и змеи", pool_ok)
    var spread_ok := true
    for foe in dungeon._foes:
        if (foe["node"] as Node2D).position.distance_to(dungeon.player.position) < 80.0:
            spread_ok = false
    check("враги не толпятся у спавна", spread_ok)
    var elite_found := false
    for foe in dungeon._foes:
        if bool(foe.get("elite", false)):
            elite_found = true
            check("элита крупнее и злее", int(foe["max_hp"]) \
                > int((foe["def"] as Dictionary)["hp"]) \
                and int(foe["dmg"]) > int((foe["def"] as Dictionary)["damage"]))
    check("на этаже есть элитный чемпион (хранитель)", elite_found)
    check("HUD показывает уровень 1/4", String(dungeon._hud_floor.text) \
        .contains("ур. 1/4"))
    check("HUD считает врагов", String(dungeon._hud_floor.text).contains("врагов"))

    # --- шаг 15/19: сундуки на этаже (5–7 шт.), сокровищница, реквизит ---
    check("на этаже 5–7 сундуков (шаг 19)", dungeon._chests.size() >= 5 \
        and dungeon._chests.size() <= 7)
    var chest_floor_ok := true
    for chest in dungeon._chests:
        var ct: Vector2i = chest["tile"]
        if String(dungeon._grid[ct.y][ct.x]) in DungeonBestiary.SOLID:
            chest_floor_ok = false
        if (chest["sprite"] as Sprite2D).texture == null:
            chest_floor_ok = false
        if bool(chest.get("opened", true)):
            chest_floor_ok = false   # спавнятся закрытыми
    check("сундуки стоят на полу, закрыты, со спрайтом", chest_floor_ok)
    var mosaic_ok := false
    for y in range(DungeonBestiary.MAP_H):
        if mosaic_ok:
            break
        for x in range(DungeonBestiary.MAP_W):
            if String(dungeon._grid[y][x]) == "m":
                mosaic_ok = true
                break
    check("сокровищница из золотой мозаики на этаже", mosaic_ok)
    var torch_count := 0
    var prop_count := 0
    for child in dungeon._entities.get_children():
        if String(child.name).begins_with("Torch_"):
            torch_count += 1
        elif String(child.name).begins_with("Prop_"):
            prop_count += 1
    check("факелы на этаже (10–14)", torch_count >= 10 and torch_count <= 14)
    check("реквизит на этаже (>=3)", prop_count >= 3)
    var chest_gold_before: int = Game.gold
    var chest_inv_before: int = Game.inventory.size()
    dungeon._open_chest(dungeon._chests[0])
    await get_tree().process_frame
    check("сундук открылся (флаг и спрайт)", bool(dungeon._chests[0]["opened"])
        and (dungeon._chests[0]["sprite"] as Sprite2D).texture != null)
    check("сундук дал добычу (золото или предмет)", Game.gold > chest_gold_before \
        or Game.inventory.size() > chest_inv_before)
    var chest_gold_mid: int = Game.gold
    var chest_inv_mid: int = Game.inventory.size()
    dungeon._open_chest(dungeon._chests[0])
    check("повторное открытие сундука пусто", Game.gold == chest_gold_mid \
        and Game.inventory.size() == chest_inv_mid)

    # --- таблицы сундуков: на всех этажах только золото или РЕАЛЬНЫЙ предмет ---
    var loot_ok := true
    for floor_num in range(1, DungeonBestiary.FLOORS + 1):
        for _try in range(150):
            var roll: Dictionary = Loot.chest_loot(floor_num)
            if roll.has("item_id"):
                var iid := String(roll["item_id"])
                if iid.is_empty() or ItemDB.get_item(iid).is_empty():
                    loot_ok = false
                    print("    плохой дроп: этаж ", floor_num, " id=", iid)
            elif not roll.has("gold"):
                loot_ok = false
    check("таблицы сундуков дают золото или существующие предметы", loot_ok)
    var epic_ok := true
    for wid in Loot.EPIC_WEAPONS:
        if ItemDB.get_item(String(wid)).is_empty():
            epic_ok = false
    check("все эпические оружия босса существуют в ItemDB", epic_ok)

    # --- шаг 19: лестница вниз открыта сразу — убивать всех не обязательно ---
    check("лестница вниз открыта при живых врагах (шаг 19)", dungeon._stairs_open())

    # --- убийства дают золото и опыт (шаг 19) ---
    var gold_before: int = Game.gold
    var xp_before: int = Game.xp
    for foe in dungeon._foes.duplicate():
        dungeon._hit_foe(foe, 999)
    check("все враги этажа мертвы", dungeon._stairs_open())
    check("за убийства начислено золото", Game.gold > gold_before)
    check("за убийства начислен опыт (шаг 19)", \
        Game.xp > xp_before or Game.level > 1)
    dungeon._use_stairs("_use_stairs_down")
    await get_tree().process_frame
    await get_tree().process_frame
    check("переход на этаж 2", dungeon._floor_num == 2 and Game.dungeon_floor == 2)
    check("этаж 2 перегенерирован: снова 8–10 врагов", dungeon._foes.size() >= 8 \
        and dungeon._foes.size() <= 10)
    check("тема этажа 2 — Пустотные чертоги", \
        String(dungeon._theme.get("id", "")) == "void_halls")
    check("игрок переставлен на новый спавн", dungeon.player != null)

    # --- этаж 4: обязательный босс и зал с жаровнями/троном/ковром ---
    dungeon._goto_floor(4)
    await get_tree().process_frame
    await get_tree().process_frame
    var boss: Dictionary = dungeon._boss_record()
    check("на 4-м этаже есть босс", not boss.is_empty())
    check("босс — демон с юга карты (лист 72x96, втрое крупнее)", \
        String(boss["def"]["sheet"]).contains("demon") \
        and int(boss["def"]["scale"]) == 3 and int(boss["max_hp"]) == 300)
    check("тема этажа 4 — Багровое логово", \
        String(dungeon._theme.get("id", "")) == "crimson_lair")
    var carpet_ok := false
    for y in range(DungeonBestiary.MAP_H):
        if carpet_ok:
            break
        for x in range(DungeonBestiary.MAP_W):
            if String(dungeon._grid[y][x]) == "p":
                carpet_ok = true
                break
    check("ковровая дорожка к трону есть", carpet_ok)
    var top_pool_ok := true
    for foe in dungeon._foes:
        if bool(foe.get("boss", false)):
            continue
        if String(foe["id"]) != "demon_swordsman" \
                and String(foe["id"]) != "demon_sorcerer":
            top_pool_ok = false
    check("миньоны 10-го этажа — высшие демоны", top_pool_ok)
    check("босс ещё мирен (до диалога)", not dungeon._boss_hostile)

    # --- диалог босса: демона не видели — он представляется ---
    dungeon._open_boss_dialog()
    await get_tree().process_frame
    check("босс заговорил", dungeon._dialogue.visible)
    check("роль незнакомца", String(dungeon._dialogue._role_label.text) \
        .contains("хозяин"))
    check("реплики незнакомца", String(dungeon._dialogue._lines[0]).contains("А вот и ты"))
    dungeon._dialogue._close()
    await get_tree().process_frame
    check("после диалога босс в ярости", dungeon._boss_hostile)

    # --- демон узнаёт героя, если мы видели его у края мира ---
    Game.mark_demon_seen()
    dungeon._open_boss_dialog()
    await get_tree().process_frame
    check("роль узнавшего", String(dungeon._dialogue._role_label.text) \
        .contains("узнавш"))
    check("реплики узнавания", String(dungeon._dialogue._lines[0]) \
        .contains("Ты помнишь меня"))
    dungeon._dialogue._close()
    await get_tree().process_frame

    # --- битва: босс преследует и бьёт ---
    boss = dungeon._boss_record()
    var hp_before: int = Game.hp
    dungeon.player.position = (boss["node"] as Node2D).position + Vector2(-60, 0)
    for _i in 150:
        await get_tree().physics_frame   # ~2.5 с: демон догоняет и бьёт
    # Воин (50 хп) за 2.5 с под боссом (12 ур.) и миньонами (15-17 ур.)
    # может и погибнуть — это честный исход: проверяем только, что босс бьёт.
    check("босс догнал героя и бьёт", Game.hp < hp_before)

    # --- победа над боссом ---
    boss = dungeon._boss_record()
    dungeon._hit_foe(boss, 9999)
    await get_tree().process_frame
    check("босс мёртв", bool(boss.get("dead", false)))
    check("демон повержен навсегда", Game.demon_gone_forever())
    check("данж 1 засчитан пройденным", "dungeon_1" in Game.dungeons_cleared)
    check("жертвы оживили и забыли (Глот и Лира)", Game.dead_npcs.is_empty())
    check("выход в замок появился", not dungeon._stairs_exit.is_empty())
    check("тайл выхода X в сетке", dungeon._grid[int(dungeon._stairs_exit["pos"].y / 16.0)] \
        [int(dungeon._stairs_exit["pos"].x / 16.0)] == "X")
    check("флаг победы на этаже", dungeon._boss_defeated_here)
    var epic_found := false
    for item in Game.inventory:
        if String(item.get("item_id", "")) in Loot.EPIC_WEAPONS \
                and String(item.get("quality", "")) == Loot.EPIC_QUALITY:
            epic_found = true
    check("за босса выпало эпическое оружие (золотое качество)", epic_found)
    var exit_free_of_chests := true
    for chest in dungeon._chests:
        if (chest["tile"] as Vector2i) == Vector2i(
            int(dungeon._stairs_exit["pos"].x / 16.0),
            int(dungeon._stairs_exit["pos"].y / 16.0)):
            exit_free_of_chests = false
    check("выход не встал на сундук", exit_free_of_chests)

    # --- после победы босса на 4-м этаже его больше нет ---
    dungeon._load_floor(4)
    await get_tree().process_frame
    await get_tree().process_frame
    check("на 4-м этаже больше нет босса", dungeon._boss_record().is_empty())
    check("выход в замок доступен сразу", not dungeon._stairs_exit.is_empty())
    check("спавн-страж на карте: демон не вернётся", Game.demon_gone_forever())

    dungeon.free()
    await get_tree().process_frame

    # --- сейв v7: demon_defeated, уровень и опыт переживают загрузку ---
    var data: Dictionary = Game.to_save_data()
    check("сейв v8 с demon_defeated, уровнем и опытом (шаг 24)", int(data.get("v", 0)) == 8 \
        and bool(data.get("demon_defeated", false)) \
        and data.has("level") and data.has("xp"))
    Game.new_run(2, "warrior")
    check("новая игра: demon_defeated сброшен", not Game.demon_defeated)
    Game.load_save_data(data)
    check("загрузка слота: демон остаётся мёртвым", Game.demon_defeated)
    check("загрузка слота: уровень и опыт восстановились", \
        int(data.get("level", 0)) == Game.level \
        and int(data.get("xp", 0)) == Game.xp)

    # ================== шаг 19: опыт, уровни, оружие x2, звук ==================
    Game.new_run(1, "warrior")
    check("новая игра: уровень 1 и 0 опыта (шаг 19)", \
        Game.level == 1 and Game.xp == 0)
    check("порог опыта: 45 за 1-й уровень", Game.xp_needed() == 45)
    Game.add_xp(45)
    check("45 опыта = уровень 2", Game.level == 2 and Game.xp == 0)
    check("уровень 2: ХП и урон кулаков +35% (шаг 25)", \
        Game.max_hp() == 68 and Game.strike_damage() == 7)
    check("порог опыта за 2-й уровень — 180", Game.xp_needed() == 180)
    Game.add_xp(60)
    check("лишний опыт копится до следующего порога", \
        Game.level == 2 and Game.xp == 60)
    Game.add_xp(120)   # 60 + 120 = 180 ровно
    check("уровень 3: ХП выросли на 70% (шаг 25)", \
        Game.level == 3 and Game.max_hp() == 85)
    Game.add_xp(100)   # меньше порога 405 для 3-го уровня
    check("уровень 4 не наступает раньше порога", \
        Game.level == 3 and Game.xp == 100)
    # урон приёмов растёт уровнем: варвар на 3-м — топор 100 -> 400
    Game.new_run(1, "barbarian")
    Game.add_xp(45 + 180)
    check("урон топора растёт с уровнем (170 на 3-м, шаг 25)", \
        Game.level == 3 and int(Game.ability_info("q")["damage"]) == 170)
    # шаг 22: экипировки ВТРОЕ больше — сталь 18, магия 18, уников-оружия 3,
    # броня 9, одеяния 9; все иконки существуют
    var weapon_count := 0
    var armor_count := 0
    var robe_count := 0
    for item_id in ItemDB.ITEMS:
        var itype := String((ItemDB.ITEMS[item_id] as Dictionary).get("type", ""))
        if itype == "weapon":
            weapon_count += 1
        elif itype == "armor":
            armor_count += 1
        elif itype == "robe":
            robe_count += 1
    check("видов оружия 39 — втрое больше (шаг 22)", weapon_count == 39)
    check("видов брони 11 и одеяний 9 (шаг 22; броня включает 2 уника)",
        armor_count == 11 and robe_count == 9)
    var new_icons_ok := true
    for new_id in ["rusty_dagger", "axe_war", "warhammer", "staff_embers",
            "orb_abyss", "chakram_moon", "moon_reaper", "bone_chopper",
            "guard_spear", "flail", "espadon", "storm_eye", "frost_needles",
            "sun_scepter", "polaris_wand", "quilted_jacket", "brigandine",
            "dragon_scale", "robe_runes", "robe_dawn", "comet_wreath",
            "void_carapace"]:
        if not ResourceLoader.exists(ItemDB.icon(String(new_id))):
            new_icons_ok = false
    check("иконки новой экипировки на месте (шаги 19/22)", new_icons_ok)
    check("Серп полумесяца — фиолетовый уник (шаг 19)", \
        "moon_reaper" in ItemDB.VIOLET_UNIQUES)
    check("Венок комет и Панцирь бездны — фиолетовые уники (шаг 22)", \
        "comet_wreath" in ItemDB.VIOLET_UNIQUES \
        and "void_carapace" in ItemDB.VIOLET_UNIQUES)
    check("новые оружия в пул сундуков и эпического босса", \
        "rusty_dagger" in Loot.CHEST_POOLS["weapon"]["early"] \
        and "warhammer" in Loot.CHEST_POOLS["weapon"]["late"] \
        and "orb_abyss" in Loot.EPIC_WEAPONS)
    check("новая экипировка шага 22 в пулы добавлена", \
        "bone_chopper" in Loot.CHEST_POOLS["weapon"]["early"] \
        and "claymore" in Loot.CHEST_POOLS["weapon"]["late"] \
        and "flame_blade" in Loot.CHEST_POOLS["weapon"]["late"] \
        and "polaris_wand" in Loot.EPIC_WEAPONS \
        and "dragon_scale" in Loot.CHEST_POOLS["armor"]["late"] \
        and "robe_dawn" in Loot.CHEST_POOLS["robe"]["late"])
    # у всех врагов и боссов — награда опытом
    var foe_xp_ok := true
    for source: Array in [DungeonBestiary.FOES, DungeonBestiary.FOES_2,
            DungeonBestiary.FOES_3, DungeonBestiary.FOES_4]:
        for def: Dictionary in source:
            if int(def.get("xp", 0)) <= 0:
                foe_xp_ok = false
    check("у каждого врага есть награда опытом (шаг 19)", foe_xp_ok)
    check("у боссов есть награда опытом", \
        int(DungeonBestiary.BOSS.get("xp", 0)) == 200 \
        and int(DungeonBestiary.BOSS_2.get("xp", 0)) == 250 \
        and int(DungeonBestiary.BOSS_3.get("xp", 0)) == 500 \
        and int(DungeonBestiary.BOSS_4.get("xp", 0)) == 800)
    # --- шаг 24: данж 4 в бестиарии ---
    check("5 видов Древних в бестиарии (шаг 24)", \
        DungeonBestiary.foe_def("night_gaunt").size() > 0 \
        and DungeonBestiary.foe_def("moon_beast").size() > 0 \
        and DungeonBestiary.foe_def("ghoul_priest").size() > 0 \
        and DungeonBestiary.foe_def("elder_thing").size() > 0 \
        and DungeonBestiary.foe_def("tentacle_abomination").size() > 0)
    var d4_sheets_ok := true
    for fid4 in ["night_gaunt", "moon_beast", "ghoul_priest", "elder_thing",
            "tentacle_abomination"]:
        if not ResourceLoader.exists(String(DungeonBestiary.foe_def(fid4)
                .get("sheet", "res://assets/sprites/dungeon/none.png"))):
            d4_sheets_ok = false
    # босс — не «foe», его лист проверяем через boss_for
    if not ResourceLoader.exists(String(DungeonBestiary.boss_for("dungeon_4")
            .get("sheet", "res://assets/sprites/dungeon/none.png"))):
        d4_sheets_ok = false
    check("листы Древних и Шуб-Ниггурат существуют", d4_sheets_ok \
        and ResourceLoader.exists("res://assets/sprites/portraits/boss_shub.png") \
        and ResourceLoader.exists("res://assets/sprites/dungeon/tentacle_wall.png"))
    var boss4_def: Dictionary = DungeonBestiary.boss_for("dungeon_4")
    check("босс данжа 4 — Шуб-Ниггурат (лист 96x128, x4)", \
        String(boss4_def["id"]) == "boss_shub" \
        and String(boss4_def["sheet"]).contains("boss_shub") \
        and int(boss4_def["scale"]) == 4)
    check("темы данжа 4 — Древние (шаг 24)", \
        String(DungeonBestiary.theme_for_floor(1, "dungeon_4").get("id", "")) == "blasphemous_grove" \
        and String(DungeonBestiary.theme_for_floor(4, "dungeon_4").get("id", "")) == "black_altar")
    check("у данжей 1-3 есть ключ босса (шаг 24)", \
        String(DungeonBestiary.dungeon_meta("dungeon_1").get("boss_key", "")) == "key_skit" \
        and String(DungeonBestiary.dungeon_meta("dungeon_2").get("boss_key", "")) == "key_depths" \
        and String(DungeonBestiary.dungeon_meta("dungeon_3").get("boss_key", "")) == "key_ancients" \
        and String(DungeonBestiary.dungeon_meta("dungeon_4").get("boss_key", "")) == "")
    check("ключи существуют и не продаются", \
        int(ItemDB.get_item("key_skit").get("price", -1)) == 0 \
        and int(ItemDB.get_item("key_depths").get("price", -1)) == 0 \
        and int(ItemDB.get_item("key_ancients").get("price", -1)) == 0)
    # звук: 14 SFX-файлов и жуткий эмбиент сгенерированы
    check("Sfx: 20 эффектов описаны (шаг 21 — голос Ктулху)",
        Sfx.SOUNDS.size() == 20 and Sfx.SOUNDS.has("surge")
        and Sfx.SOUNDS.has("heal") and Sfx.SOUNDS.has("leap")
        and Sfx.SOUNDS.has("rain") and Sfx.SOUNDS.has("roar")
        and Sfx.SOUNDS.has("slam"))
    var sfx_files_ok := true
    for s_name in Sfx.SOUNDS:
        if not ResourceLoader.exists(Sfx.SFX_DIR + String(Sfx.SOUNDS[s_name])):
            sfx_files_ok = false
    check("все SFX-файлы сгенерированы (шаг 19)", sfx_files_ok)
    check("эмбиент в духе Silent Hill на месте", \
        ResourceLoader.exists(Sfx.AMBIENT_PATH))
    # new_run сбросил прогресс — возвращаем «демон повержен», которого
    # ждут проверки секции скита ниже
    Game.defeat_demon_permanently()

    # ================== шаг 16: данж 2 «Скит Пустоты» (культисты) ==================
    # --- бестиарий культистов ---
    check("5 видов культистов в бестиарии", DungeonBestiary.foe_def("cultist_acolyte").size() > 0 \
        and DungeonBestiary.foe_def("cultist_fanatic").size() > 0 \
        and DungeonBestiary.foe_def("cultist_chanter").size() > 0 \
        and DungeonBestiary.foe_def("cultist_guardian").size() > 0 \
        and DungeonBestiary.foe_def("cultist_elder").size() > 0)
    var cult_sheets_ok := true
    for fid in ["cultist_acolyte", "cultist_fanatic", "cultist_guardian",
            "cultist_chanter", "cultist_elder"]:
        if not ResourceLoader.exists(String(DungeonBestiary.foe_def(fid)["sheet"])):
            cult_sheets_ok = false
    check("листы культистов существуют", cult_sheets_ok)
    var boss2_def: Dictionary = DungeonBestiary.boss_for("dungeon_2")
    check("босс данжа 2 — Великий культист со щупальцами", \
        String(boss2_def["id"]) == "boss_cultist_overlord" \
        and String(boss2_def["sheet"]).contains("cultist_overlord") \
        and ResourceLoader.exists(String(boss2_def["sheet"])) \
        and ResourceLoader.exists(String(boss2_def["portrait"])))
    check("у демона и культиста разные диалоги", \
        String(DungeonBestiary.boss_for("dungeon_1")["id"]) == "boss_demon" \
        and not bool(DungeonBestiary.boss_for("dungeon_2").get("knows_hero", false)))
    check("темы данжа 2 — культ Пустоты", \
        String(DungeonBestiary.theme_for_floor(1, "dungeon_2").get("id", "")) == "cult_cells" \
        and String(DungeonBestiary.theme_for_floor(2, "dungeon_2").get("id", "")) == "light_halls" \
        and String(DungeonBestiary.theme_for_floor(3, "dungeon_2").get("id", "")) == "sacrarium" \
        and String(DungeonBestiary.theme_for_floor(4, "dungeon_2").get("id", "")) == "void_sanctum")

    # ================== шаг 17: широкие коридоры для кайтинга ==================
    # полосы-вырезы коридоров режут 3 клетки (ширина коридора 3)
    var sg1: Array[String] = []
    for i in range(6):
        sg1.append("######")
    DungeonBestiary._carve_strip_h(sg1, 2, 1)
    check("полоса горизонтальная режет 3 клетки (коридор шириной 3)", \
        String(sg1[1][2]) == "." and String(sg1[2][2]) == "." \
        and String(sg1[3][2]) == "." and String(sg1[4][2]) == "#")
    var sg2: Array[String] = []
    for i in range(6):
        sg2.append("######")
    DungeonBestiary._carve_strip_v(sg2, 2, 1)
    check("полоса вертикальная режет 3 клетки (коридор шириной 3)", \
        String(sg2[1][2]) == "." and String(sg2[1][3]) == "." \
        and String(sg2[1][4]) == "." and String(sg2[2][4]) == "#")
    # проход из зала босса в прихожую — 3 тайла; заодно BFS-связность
    # всех 8 этажей обоих данжей: спавн -> лестницы наверх/вниз/босс
    var door_ok := true
    var conn_ok := true
    for d_id in ["dungeon_1", "dungeon_2", "dungeon_3", "dungeon_4"]:
        for f in range(1, DungeonBestiary.FLOORS + 1):
            var fl: Dictionary = DungeonBestiary.generate_floor(f,
                f == DungeonBestiary.FLOORS, d_id)
            var g: Array[String] = fl["grid"]
            if f == DungeonBestiary.FLOORS:
                for dx in range(3):
                    if String(g[19][31 + dx]) == "#":
                        door_ok = false
            var start: Vector2i = fl["spawn"]
            var up_t: Vector2i = fl["up"]
            var down_t: Vector2i = fl["down"]
            var boss_t: Vector2i = fl["boss_tile"]
            var seen := {start: true}
            var queue: Array[Vector2i] = [start]
            while not queue.is_empty():
                var cur: Vector2i = queue.pop_front()
                for off in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1),
                        Vector2i(0, -1)]:
                    var nxt: Vector2i = cur + off
                    if nxt.x <= 0 or nxt.y <= 0 \
                            or nxt.x >= DungeonBestiary.MAP_W - 1 \
                            or nxt.y >= DungeonBestiary.MAP_H - 1 \
                            or seen.has(nxt):
                        continue
                    if not DungeonBestiary.SOLID.contains(String(g[nxt.y][nxt.x])):
                        seen[nxt] = true
                        queue.append(nxt)
            if not seen.has(up_t):
                conn_ok = false
            if down_t.x >= 0 and not seen.has(down_t):
                conn_ok = false
            if f == DungeonBestiary.FLOORS and not seen.has(boss_t):
                conn_ok = false
    check("проход в зал босса шириной 3 (шаг 17)", door_ok)
    check("все 16 этажей четырёх данжей связны (шаги 17/20/24)", conn_ok)
    # кайт возможен, только если враг не догоняет героя (герой — 95)
    var kite_ok := true
    for source: Array in [DungeonBestiary.FOES, DungeonBestiary.FOES_2,
            DungeonBestiary.FOES_3, DungeonBestiary.FOES_4]:
        for def: Dictionary in source:
            if float(def["speed"]) >= 95.0:
                kite_ok = false
    for boss_d in ["dungeon_1", "dungeon_2", "dungeon_3", "dungeon_4"]:
        if float(DungeonBestiary.boss_for(boss_d)["speed"]) >= 95.0:
            kite_ok = false
    check("все враги медленнее героя — кайт возможен (шаг 17)", kite_ok)

    # --- жертва: босс данжа 2 НЕ воскрешает жителей (это умеет только демон) ---
    Game.kill_npc("zlus")
    check("жертва до скита (Злус)", Game.dead_npcs.size() == 1)

    # --- вход в скит через дверь 2 ---
    Game.current_dungeon = "dungeon_2"
    Game.dungeon_floor = 1
    var skit: Node2D = (load("res://scenes/dungeon/dungeon.tscn") as PackedScene).instantiate()
    add_child(skit)
    await get_tree().process_frame
    await get_tree().process_frame
    check("скит принят: id данжа в сцене и в Game", skit._dungeon_id == "dungeon_2" \
        and Game.current_dungeon == "dungeon_2")
    check("тема этажа 1 скита — Шёпотущие кельи", \
        String(skit._theme.get("id", "")) == "cult_cells")
    var cult_pool_ok := true
    for foe in skit._foes:
        if String(foe["id"]) != "cultist_acolyte" \
                and String(foe["id"]) != "cultist_fanatic":
            cult_pool_ok = false
    check("на 1-м этаже скита только послушники и фанатики", cult_pool_ok)
    check("HUD скита показывает имя и уровень", String(skit._hud_floor.text) \
        .contains("Скит Пустоты") and String(skit._hud_floor.text).contains("ур. 1/4"))
    skit._goto_floor(2)
    await get_tree().process_frame
    await get_tree().process_frame
    var skit2_pool_ok := true
    for foe in skit._foes:
        if String(foe["id"]) != "cultist_acolyte" \
                and String(foe["id"]) != "cultist_fanatic" \
                and String(foe["id"]) != "cultist_chanter":
            skit2_pool_ok = false
    check("этаж 2 скита — Зал свечений (чтецы в пуле)", \
        skit._floor_num == 2 \
        and String(skit._theme.get("id", "")) == "light_halls" \
        and skit2_pool_ok)

    # --- этаж 4: Великий культист ---
    skit._goto_floor(4)
    await get_tree().process_frame
    await get_tree().process_frame
    var boss2_rec: Dictionary = skit._boss_record()
    check("на 4-м этаже скита есть босс", not boss2_rec.is_empty())
    check("босс — культист (лист 72x96, втрое крупнее, хп 420)", \
        String(boss2_rec["def"]["sheet"]).contains("cultist_overlord") \
        and int(boss2_rec["def"]["scale"]) == 3 and int(boss2_rec["max_hp"]) == 420)
    check("тема этажа 4 скита — Святилище Пустоты", \
        String(skit._theme.get("id", "")) == "void_sanctum")

    # --- диалог: культист никогда не видел героя — Пустота лишь шептала ---
    skit._open_boss_dialog()
    await get_tree().process_frame
    check("культист заговорил", skit._dialogue.visible)
    check("роль верховного жреца", String(skit._dialogue._role_label.text) \
        .contains("жрец"))
    check("реплики культиста о Пустоте", String(skit._dialogue._lines[0]) \
        .contains("Пустота"))
    skit._dialogue._close()
    await get_tree().process_frame

    # --- победа над культистом: данж 2 засчитан, житель НЕ воскресает ---
    boss2_rec = skit._boss_record()
    skit._hit_foe(boss2_rec, 9999)
    await get_tree().process_frame
    check("культист мёртв", bool(boss2_rec.get("dead", false)))
    check("данж 2 засчитан пройденным", "dungeon_2" in Game.dungeons_cleared)
    check("демон из данжа 1 остаётся поверженным", Game.demon_gone_forever())
    check("босс данжа 2 НЕ воскрешает жителей (Злус мёртв)", \
        Game.dead_npcs.size() == 1)
    check("выход в замок появился", not skit._stairs_exit.is_empty())
    var epic2_found := false
    for item in Game.inventory:
        if String(item.get("item_id", "")) in Loot.EPIC_WEAPONS \
                and String(item.get("quality", "")) == Loot.EPIC_QUALITY:
            epic2_found = true
    check("за культиста выпало эпическое оружие", epic2_found)

    # --- повторный вход: босса больше нет, выход открыт сразу ---
    skit._load_floor(4)
    await get_tree().process_frame
    await get_tree().process_frame
    check("на 4-м этаже скита больше нет босса", skit._boss_record().is_empty())
    check("выход в замок доступен сразу", not skit._stairs_exit.is_empty())

    skit.free()
    await get_tree().process_frame

    # --- данж 3 «Глубины Р'льеха» (шаг 20): чудовища и Ктулху ---
    Game.current_dungeon = "dungeon_3"
    Game.dungeon_floor = 1
    var rlyeh: Node2D = (load("res://scenes/dungeon/dungeon.tscn") as PackedScene).instantiate()
    add_child(rlyeh)
    await get_tree().process_frame
    await get_tree().process_frame
    check("данж 3 принят: id в сцене и в Game", rlyeh._dungeon_id == "dungeon_3" \
        and Game.current_dungeon == "dungeon_3")
    check("тема этажа 1 — Затопленные гроты", \
        String(rlyeh._theme.get("id", "")) == "drowned_grottos")
    var abyss_pool_ok := true
    for foe in rlyeh._foes:
        if String(foe["id"]) != "deep_one" \
                and String(foe["id"]) != "tentacle_crawler":
            abyss_pool_ok = false
    check("на 1-м этаже Р'льеха только глубинные и ползуны", abyss_pool_ok)
    check("HUD показывает «Глубины Р'льеха»", String(rlyeh._hud_floor.text) \
        .contains("Р'льеха"))
    var boss3_def: Dictionary = DungeonBestiary.boss_for("dungeon_3")
    check("босс данжа 3 — Большой Ктулху (лист 96x128, шаг 21)", \
        String(boss3_def.get("id", "")) == "boss_cthulhu" \
        and String(boss3_def.get("sheet", "")).contains("boss_cthulhu") \
        and int(boss3_def.get("scale", 0)) == 4)
    rlyeh._goto_floor(4)
    await get_tree().process_frame
    await get_tree().process_frame
    var boss3_rec: Dictionary = rlyeh._boss_record()
    check("на 4-м этаже Р'льеха ждёт Ктулху", not boss3_rec.is_empty() \
        and String(boss3_rec["def"]["id"]) == "boss_cthulhu")
    check("тема этажа 4 — Трон Р'льеха", \
        String(rlyeh._theme.get("id", "")) == "rlyeh_throne")
    rlyeh._open_boss_dialog()
    await get_tree().process_frame
    check("Ктулху заговорил", rlyeh._dialogue.visible)
    rlyeh._dialogue._close()
    await get_tree().process_frame
    boss3_rec = rlyeh._boss_record()
    rlyeh._hit_foe(boss3_rec, 99999)
    await get_tree().process_frame
    check("Ктулху повержен, данж 3 засчитан", bool(boss3_rec.get("dead", false)) \
        and "dungeon_3" in Game.dungeons_cleared)
    check("выход из Р'льеха появился", not rlyeh._stairs_exit.is_empty())

    rlyeh.free()
    await get_tree().process_frame

    Game.new_run(2, "warrior")
    check("новая игра: current_dungeon сброшен на данж 1", \
        Game.current_dungeon == "dungeon_1")

    if failed == 0:
        print("DUNGEON TEST: ВСЁ ОК")
        get_tree().quit(0)
    else:
        print("DUNGEON TEST: ПРОВАЛОВ: ", failed)
        get_tree().quit(1)

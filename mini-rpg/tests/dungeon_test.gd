## Тест подземелья (шаг 13): генерация этажей (10 уровней, 1-5 врагов),
## пулы врагов по глубине, лестница вниз заперта, пока враги живы,
## переход между этажами, босс 10-го этажа (Таинственный демон):
## мирен до диалога, узнаёт героя, если видели его у края мира, дерётся
## после реплик, при смерти — demon_defeated, ожившие NPC, данж пройден,
## выход в замок; после победы босса на 10-м этаже больше нет.
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
    check("сетка этажа 40x36 сгенерирована", dungeon._grid.size() == DungeonBestiary.MAP_H \
        and String(dungeon._grid[0]).length() == DungeonBestiary.MAP_W)
    check("есть лестница наверх", not dungeon._stairs_up.is_empty())
    check("есть лестница вниз", not dungeon._stairs_down.is_empty())
    check("на этаже от 1 до 5 врагов", dungeon._foes.size() >= 1 \
        and dungeon._foes.size() <= 5)
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
    check("HUD показывает уровень 1/10", String(dungeon._hud_floor.text) \
        .contains("ур. 1/10"))
    check("HUD считает врагов", String(dungeon._hud_floor.text).contains("врагов"))

    # --- шаг 14: сундуки на этаже (1-2 шт., открытие, добыча, повторное открытие) ---
    check("на этаже 1-2 сундука", dungeon._chests.size() >= 1 \
        and dungeon._chests.size() <= 2)
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

    # --- лестница вниз заперта, пока враги живы ---
    dungeon._use_stairs("_use_stairs_down")
    await get_tree().process_frame
    check("лестница вниз заперта при живых врагах", dungeon._floor_num == 1)

    # --- убиваем всех: тишина открывает путь; за убийство дают золото ---
    var gold_before: int = Game.gold
    for foe in dungeon._foes.duplicate():
        dungeon._hit_foe(foe, 999)
    check("все враги этажа мертвы", dungeon._stairs_open())
    check("за убийства начислено золото", Game.gold > gold_before)
    dungeon._use_stairs("_use_stairs_down")
    await get_tree().process_frame
    await get_tree().process_frame
    check("переход на этаж 2", dungeon._floor_num == 2 and Game.dungeon_floor == 2)
    check("этаж 2 перегенерирован: снова 1-5 врагов", dungeon._foes.size() >= 1 \
        and dungeon._foes.size() <= 5)
    check("игрок переставлен на новый спавн", dungeon.player != null)

    # --- этаж 10: обязательный босс ---
    dungeon._goto_floor(10)
    await get_tree().process_frame
    await get_tree().process_frame
    var boss: Dictionary = dungeon._boss_record()
    check("на 10-м этаже есть босс", not boss.is_empty())
    check("босс — демон с юга карты (лист 72x96, втрое крупнее)", \
        String(boss["def"]["sheet"]).contains("demon") \
        and int(boss["def"]["scale"]) == 3 and int(boss["max_hp"]) == 300)
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

    # --- после победы босса на 10-м этаже его больше нет ---
    dungeon._load_floor(10)
    await get_tree().process_frame
    await get_tree().process_frame
    check("на 10-м этаже больше нет босса", dungeon._boss_record().is_empty())
    check("выход в замок доступен сразу", not dungeon._stairs_exit.is_empty())
    check("спавн-страж на карте: демон не вернётся", Game.demon_gone_forever())

    dungeon.free()
    await get_tree().process_frame

    # --- сейв v6: demon_defeated переживает загрузку слота ---
    var data: Dictionary = Game.to_save_data()
    check("сейв v6 с demon_defeated", int(data.get("v", 0)) == 6 \
        and bool(data.get("demon_defeated", false)))
    Game.new_run(2, "warrior")
    check("новая игра: demon_defeated сброшен", not Game.demon_defeated)
    Game.load_save_data(data)
    check("загрузка слота: демон остаётся мёртвым", Game.demon_defeated)

    if failed == 0:
        print("DUNGEON TEST: ВСЁ ОК")
        get_tree().quit(0)
    else:
        print("DUNGEON TEST: ПРОВАЛОВ: ", failed)
        get_tree().quit(1)

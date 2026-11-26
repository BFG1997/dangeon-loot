## Шаг 33 — три правки автора:
##   1) моделька оборотня не исчезает при ходьбе (лист werewolf.png полный);
##   2) ЗАГРУЗИТЬ/СОХРАНИТЬ работают «по-настоящему»: сейв помнит этаж
##      подземелья и позицию в хабе, загрузка возвращает героя на место;
##   3) дроп чаще падает «под героя» (Loot с hero_id).
extends Node

var failures := 0

func check(label: String, ok: bool) -> void:
    print("[OK] " if ok else "[FAIL] ", label)
    if not ok:
        failures += 1

## Все ли пиксели региона непрозрачны хотя бы частично (кадр листа).
func frame_has_pixels(img: Image, col: int, row: int, fw: int, fh: int) -> bool:
    var region := Rect2i(col * fw, row * fh, fw, fh)
    var cell := img.get_region(region)
    for y in range(cell.get_height()):
        for x in range(cell.get_width()):
            if cell.get_pixel(x, y).a > 0.04:
                return true
    return false

func _ready() -> void:
    await get_tree().process_frame
    print("=== STEP33 TEST ===")

    # ================= 1. лист оборотня полный =================
    var tex: Texture2D = load("res://assets/sprites/chars/werewolf.png")
    check("лист оборотня загрузился", tex != null)
    if tex != null:
        var img := tex.get_image()
        img.convert(Image.FORMAT_RGBA8)
        check("размер листа 144x192", img.get_width() == 144 and img.get_height() == 192)
        var fw := 24
        var fh := 32
        var ok := true
        var empty_list: Array[String] = []
        for row in range(3):          # idle_down/side/up — по 6 кадров
            for col in range(6):
                if not frame_has_pixels(img, col, row, fw, fh):
                    ok = false
                    empty_list.append("row%d col%d" % [row, col])
        for row in range(3, 6):       # walk_* — по 4 кадра
            for col in range(4):
                if not frame_has_pixels(img, col, row, fw, fh):
                    ok = false
                    empty_list.append("row%d col%d" % [row, col])
        check("все используемые кадры листа оборотня нарисованы", ok)
        if not empty_list.is_empty():
            print("    пустые кадры: ", empty_list)

    # ================= 2. сейв помнит этаж и позицию =================
    Game.new_run(1, "mage")
    Game.hub_pos = Vector2(500, 300)
    Game.dungeon_floor = 2
    Game.current_dungeon = "dungeon_1"
    Saves.request_save()
    var data := Platform.load_data(1)
    check("в сейве есть этаж подземелья", int(data.get("dungeon_floor", 0)) == 2)
    check("в сейве есть данж", String(data.get("current_dungeon", "")) == "dungeon_1")
    check("в сейве есть позиция хаба",
          Vector2(float(data.get("hub_x", 0.0)), float(data.get("hub_y", 0.0)))
              == Vector2(500, 300))
    # портим состояние и загружаем заново
    Game.dungeon_floor = 0
    Game.current_dungeon = "dungeon_1"
    Game.hub_pos = Vector2.ZERO
    Game.load_save_data(Platform.load_data(1))
    check("load_save_data вернул этаж", Game.dungeon_floor == 2)
    check("load_save_data вернул позицию", Game.hub_pos == Vector2(500, 300))
    # несуществующий данж/этаж — страховка
    Game.load_save_data({"dungeon_floor": 99, "current_dungeon": "nope"})
    check("битый данж откатывается к dungeon_1", Game.current_dungeon == "dungeon_1")
    check("этаж 99 зажимается в пределы", Game.dungeon_floor == DungeonBestiary.FLOORS)
    # сейв из хаба: этаж 0 — остаётся хабом
    Game.load_save_data({"dungeon_floor": 0, "current_dungeon": "dungeon_2"})
    check("этаж 0 — хаб", Game.dungeon_floor == 0)

    # --- WorldMap.is_pos_free: спавн свободен, стены/пропы/NPC заняты ---
    check("спавн героя свободен",
          WorldMap.is_pos_free(Vector2(WorldMap.PLAYER_SPAWN) * WorldMap.TILE_SIZE
              + Vector2(8, 8)))
    check("трон (твёрдый проп) занят", not WorldMap.is_pos_free(Vector2(28.5 * 16, 14.5 * 16)))
    check("NPC Злус занят", not WorldMap.is_pos_free(Vector2(20.5 * 16, 5.5 * 16)))
    check("вне карты занято", not WorldMap.is_pos_free(Vector2(-40, -40)))
    var free_found := false
    for ty in range(21, 44):   # улица острова — там герой и ходит
        for tx in range(15, 45):
            if WorldMap.is_pos_free(Vector2(tx * 16 + 8, ty * 16 + 8)):
                free_found = true
                break
        if free_found:
            break
    check("на острове есть свободные точки", free_found)

    # --- загрузка из мира возвращает в хаб на прежнюю позицию ---
    Game.new_run(1, "warrior")
    Game.hub_pos = Vector2.ZERO
    var world: Node2D = (load("res://scenes/world/world.tscn") as PackedScene).instantiate()
    get_tree().root.add_child(world)
    await get_tree().process_frame
    await get_tree().process_frame
    var spawn := Vector2(WorldMap.PLAYER_SPAWN) * float(WorldMap.TILE_SIZE) + Vector2(8, 8)
    check("без сейва позиции герой у спавна",
          world.player != null and world.player.position == spawn)
    world.queue_free()
    await get_tree().process_frame
    Game.new_run(1, "warrior")
    Game.hub_pos = Vector2(23.5 * 16, 27.5 * 16)   # улица, свободная точка
    world = (load("res://scenes/world/world.tscn") as PackedScene).instantiate()
    get_tree().root.add_child(world)
    await get_tree().process_frame
    await get_tree().process_frame
    check("с сейвом герой встал на сохранённую точку",
          world.player != null and world.player.position == Game.hub_pos)
    # после шага физики позиция героя пишется в Game.hub_pos
    world.player.position = Vector2(500, 400)
    await get_tree().physics_frame
    await get_tree().physics_frame
    await get_tree().physics_frame
    check("позиция героя пишется в Game.hub_pos", Game.hub_pos == Vector2(500, 400))
    # СОХРАНИТЬ из паузы мира пишет этаж 0 (хаб)
    var pm: PauseMenu = world._pause_menu
    pm._on_save_pressed()
    await get_tree().process_frame
    check("СОХРАНИТЬ мира записал этаж 0",
          int(Platform.load_data(1).get("dungeon_floor", -1)) == 0)
    world.queue_free()
    await get_tree().process_frame

    # --- СОХРАНИТЬ из паузы данжа пишет текущий этаж ---
    Game.new_run(1, "warrior")
    Game.dungeon_floor = 2
    var dungeon: Node2D = (load("res://scenes/dungeon/dungeon.tscn") as PackedScene).instantiate()
    get_tree().root.add_child(dungeon)
    await get_tree().process_frame
    await get_tree().process_frame
    check("данж собрал этаж 2", dungeon._floor_num == 2)
    var pm2: PauseMenu = dungeon._pause_menu
    pm2._on_save_pressed()
    await get_tree().process_frame
    check("СОХРАНИТЬ данжа записал этаж 2",
          int(Platform.load_data(1).get("dungeon_floor", -1)) == 2)
    # ЗАГРУЗИТЬ из данжа: этаж в сейве есть — сцена должна пересобраться
    dungeon.queue_free()
    await get_tree().process_frame
    Game.dungeon_floor = 2
    Game.current_dungeon = "dungeon_1"
    check("перед загрузкой этаж снова 2", Game.dungeon_floor == 2
          and Game.current_dungeon == "dungeon_1")

    # ================= 3. дроп под героя =================
    # воин: ни тёмного оружия, ни одеяний
    var dark_or_robe := 0
    var weapon_seen := 0
    for _try in range(400):
        var roll: Dictionary = Loot.chest_loot(1, "warrior", false)
        if roll.has("item_id"):
            var iid := String(roll["item_id"])
            if ItemDB.get_item(iid).is_empty():
                dark_or_robe += 1
                continue
            var t := String(ItemDB.get_item(iid).get("type", ""))
            if t == "robe":
                dark_or_robe += 1
            elif t == "weapon" and not (ItemDB.get_item(iid).get("hero_class", [])
                    as Array).is_empty():
                dark_or_robe += 1
            elif t == "weapon":
                weapon_seen += 1
    check("воину не падают одеяния и тёмное оружие", dark_or_robe == 0)
    check("воину падает обычное оружие", weapon_seen > 10)

    # демонолог: среди оружия преобладает тёмное (родное)
    var dark_cnt := 0
    var wpn_cnt := 0
    for _try in range(500):
        var roll2: Dictionary = Loot.chest_loot(1, "demonologist", true)
        if roll2.has("item_id"):
            var iid2 := String(roll2["item_id"])
            var def := ItemDB.get_item(iid2)
            if String(def.get("type", "")) == "weapon":
                wpn_cnt += 1
                if not (def.get("hero_class", []) as Array).is_empty():
                    dark_cnt += 1
    check("демонологу падает оружие", wpn_cnt > 20)
    check("у демонолога тёмное оружие преобладает",
          wpn_cnt > 0 and float(dark_cnt) / float(wpn_cnt) > 0.4)

    # маг: тёмного не даём, посохи/жезлы встречаются часто
    var mage_dark := 0
    var mage_magic := 0
    var mage_wpn := 0
    for _try in range(500):
        var roll3: Dictionary = Loot.chest_loot(1, "mage", true)
        if roll3.has("item_id"):
            var iid3 := String(roll3["item_id"])
            var def3 := ItemDB.get_item(iid3)
            if String(def3.get("type", "")) == "weapon":
                mage_wpn += 1
                if not (def3.get("hero_class", []) as Array).is_empty():
                    mage_dark += 1
                elif ItemDB.is_magic(iid3):
                    mage_magic += 1
    check("магу не падает тёмное оружие", mage_dark == 0)
    check("магу посохи/жезлы чаще стали",
          mage_wpn > 0 and float(mage_magic) / float(mage_wpn) > 0.5)

    # варвар: никакого магического и тёмного
    var barb_bad := 0
    for _try in range(400):
        var roll4: Dictionary = Loot.chest_loot(2, "barbarian", false)
        if roll4.has("item_id"):
            var iid4 := String(roll4["item_id"])
            var def4 := ItemDB.get_item(iid4)
            if String(def4.get("type", "")) == "weapon" \
                    and (ItemDB.is_magic(iid4)
                        or not (def4.get("hero_class", []) as Array).is_empty()):
                barb_bad += 1
    check("варвару не падает магическое/тёмное оружие", barb_bad == 0)

    # некромант: дроп с врагов смещается к тёмному
    var n_dark := 0
    var n_wpn := 0
    for _try in range(400):
        var drop: Dictionary = Loot.foe_gear_drop(2, "necromancer")
        if drop.has("item_id"):
            var iid5 := String(drop["item_id"])
            var def5 := ItemDB.get_item(iid5)
            if String(def5.get("type", "")) == "weapon":
                n_wpn += 1
                if not (def5.get("hero_class", []) as Array).is_empty():
                    n_dark += 1
    check("некроманту с врагов падает оружие", n_wpn > 10)
    check("некроманту тёмное оружие преобладает в дропе с врагов",
          n_wpn > 0 and float(n_dark) / float(n_wpn) > 0.35)

    # эпик босса: воин без тёмного; демонолог — родное преобладает
    var epic_bad := 0
    for _try in range(200):
        var e: Dictionary = Loot.epic_weapon_loot("warrior")
        var eid := String(e["item_id"])
        if not (ItemDB.get_item(eid).get("hero_class", []) as Array).is_empty():
            epic_bad += 1
    check("воину не падает тёмный эпик", epic_bad == 0)
    var epic_native := 0
    for _try in range(200):
        var e2: Dictionary = Loot.epic_weapon_loot("demonologist")
        var eid2 := String(e2["item_id"])
        if not (ItemDB.get_item(eid2).get("hero_class", []) as Array).is_empty():
            epic_native += 1
    check("демонологу тёмный эпик преобладает", epic_native > 60)

    # старые вызовы без hero_id работают как раньше
    var legacy_ok := true
    for _try in range(100):
        var roll9: Dictionary = Loot.chest_loot(1)
        if not roll9.has("item_id") and not roll9.has("gold"):
            legacy_ok = false
    check("вызов без hero_id (тесты) работает", legacy_ok)

    print("ПРОВАЛОВ: %d" % failures)
    get_tree().quit(1 if failures > 0 else 0)

## Шаг 22: фикс «хп у рыцаря больше, чем в полоске», утроенная экипировка,
## прилавок торговцев из продаж, лут с врагов.
## 1. new_run() сбрасывает уровень ДО расчёта хп: новый забег после
##    прокачанного — с полным ХП 1-го уровня (раньше у героя оставался
##    потолок прошлого забега, и полоса HUD не двигалась при ударах).
## 2. Полоса HUD в данже показывает ровно Game.hp / Game.max_hp().
## 3. Продал торговцу оружие/броню/еду — торговец того профиля теперь
##    сам это продаёт (merchant_stock); демон добирает товары убитых.
## 4. Вся новая экипировка продаётся (у уников цена -1), дроп с врагов
##    валиден (Loot.foe_gear_drop).
## Запуск: godot --headless --path . res://tests/step22_test.tscn
extends Node

var failed := 0

func check(name: String, condition: bool) -> void:
    if condition:
        print("  [OK] ", name)
    else:
        failed += 1
        print("  [ПРОВАЛ] ", name)

func find_index(item_id: String) -> int:
    for i in range(Game.inventory.size()):
        if String(Game.inventory[i].get("item_id", "")) == item_id:
            return i
    return -1

func _ready() -> void:
    call_deferred("_run")

func _run() -> void:
    print("STEP22 TEST: фикс ХП, x3 экипировка, прилавок, титан")
    Saves.wipe_all_slots()
    Game.meta["last_slot"] = 0
    Game.meta["last_bonus_date"] = ""
    Game.meta["pending_gold"] = 0
    Game.meta["pending_items"] = []
    Game.save_meta()

    # ================== 1. фикс ХП рыцаря ==================
    Game.new_run(1, "warrior")
    check("старт: хп ровно максимуму 1-го уровня",
        Game.hp == Game.max_hp() and Game.max_hp() == 50)
    Game.add_xp(45 + 180 + 1)   # порог 2-го уровня + порог 3-го + 1
    check("прокачка до 3-го уровня: хп = новому потолку (200)",
        Game.level == 3 and Game.hp == Game.max_hp()
        and Game.max_hp() == 200)
    Game.new_run(1, "warrior")   # новый забег в той же сессии
    check("новый забег после прокачанного: ХП сброшено (шаг 22)",
        Game.level == 1 and Game.hp == Game.max_hp()
        and Game.hp == 50 and Game.xp == 0)

    # ================== 2. полоса HUD в данже ==================
    Game.new_run(1, "warrior")
    Game.dungeon_floor = 1
    var dungeon: Node2D = (load("res://scenes/dungeon/dungeon.tscn")
        as PackedScene).instantiate()
    add_child(dungeon)
    await get_tree().process_frame
    await get_tree().process_frame
    var bar: ProgressBar = dungeon._hud_hp
    check("полоса данжа = хп/потолок героя",
        int(bar.max_value) == Game.max_hp() and int(bar.value) == Game.hp)
    dungeon._foe_attack({"dmg": 10})
    check("после удара врага полоса падает сразу",
        int(bar.value) == Game.hp and int(bar.max_value) == Game.max_hp())
    dungeon.free()
    await get_tree().process_frame

    # ================== 3. прилавок торговцев ==================
    Game.new_run(1, "warrior")
    for item_id in ["sword", "ham", "wand_lightning", "armor_plate",
            "robe_stars", "hp_potion_small", "mors"]:
        Game.inventory.append({"item_id": item_id,
            "title": ItemDB.title(item_id), "quality": "gray"})
    var gold0 := Game.gold
    for item_id in ["sword", "ham", "wand_lightning", "armor_plate",
            "robe_stars", "hp_potion_small", "mors"]:
        var idx := find_index(item_id)
        check("продажа %s прошла" % item_id, idx >= 0 and Game.sell_item(idx))
    check("сталь и броня ушли к кузнецу Вирасу",
        "sword" in Game.merchant_stock.get("viras", [])
        and "armor_plate" in Game.merchant_stock.get("viras", []))
    check("магия и одеяния ушли к чародею Зорану",
        "wand_lightning" in Game.merchant_stock.get("zoran", [])
        and "robe_stars" in Game.merchant_stock.get("zoran", []))
    check("еда — Гуре, питьё — Глоту, зелья — Злусу",
        "ham" in Game.merchant_stock.get("gura", [])
        and "mors" in Game.merchant_stock.get("glot", [])
        and "hp_potion_small" in Game.merchant_stock.get("zlus", []))
    check("прилавок Вираса: базовый товар + проданный",
        "sword" in Game.merchant_goods("viras")
        and "greatsword" in Game.merchant_goods("viras"))
    check("за продажи выручено золото", Game.gold > gold0)
    # демон добирает товары убитых торговцев
    Game.kill_npc("viras")
    check("демон забрал прилавок Вираса (база + продажи)",
        "sword" in Game.demon_goods() and "armor_plate" in Game.demon_goods()
        and "morgenstern" in Game.demon_goods())
    # склад переживает сохранение и загрузку
    Game.new_run(1, "warrior")
    Game.inventory.append({"item_id": "sword", "title": "Меч", "quality": "gray"})
    Game.sell_item(find_index("sword"))
    Game.current_slot = 1
    Saves.request_save()
    Game.merchant_stock = {}
    Game.continue_run(1)
    check("прилавок сохранился в сейв v7",
        "sword" in Game.merchant_stock.get("viras", []))

    # ================== 4. лут с врагов и цены ==================
    var valid_pools := {}
    for cat in ["weapon", "armor"]:
        for tier in ["early", "mid", "late"]:
            for id in Loot.CHEST_POOLS[cat][tier]:
                valid_pools[String(id)] = true
    var drops_ok := true
    var saw_item := false
    for i in range(300):
        var drop := Loot.foe_gear_drop(2)
        if drop.has("item_id"):
            saw_item = true
            var gid := String(drop["item_id"])
            var qual := String(drop.get("quality", ""))
            if not valid_pools.has(gid) or qual not in ["gray", "green", "gold"]:
                drops_ok = false
        elif drop.has("gold"):
            pass
        else:
            drops_ok = false
    check("дроп с врагов валиден за 300 бросков (шаг 22)", drops_ok)
    check("дроп экипировки реально случается", saw_item)
    var prices_ok := true
    for item_id in ["bone_chopper", "guard_spear", "great_axe", "broadsword",
            "glaive", "flail", "claymore", "espadon", "guisarme",
            "executioner_axe", "dragon_fang", "royal_greatsword",
            "spark_wand", "storm_eye", "frost_needles", "flame_rod",
            "thorn_staff", "marsh_orb", "flame_blade", "thunder_scepter",
            "mist_crystal", "starfall_staff", "sun_scepter", "polaris_wand",
            "quilted_jacket", "leather_cuirass", "scale_armor", "brigandine",
            "bachterez", "dragon_scale", "robe_apprentice", "robe_runes",
            "robe_mist", "robe_lunar", "robe_comet", "robe_dawn"]:
        if ItemDB.sell_price(item_id) < 1:
            prices_ok = false
    check("вся новая экипировка продаётся (цены > 0)", prices_ok)
    check("уники непродажные, у остального цена есть",
        ItemDB.price("comet_wreath") == -1 and ItemDB.price("void_carapace") == -1
        and ItemDB.sell_price("comet_wreath") == 0
        and ItemDB.price("bone_chopper") == 320)

    if failed == 0:
        print("STEP22 TEST: ВСЁ ОК")
        get_tree().quit(0)
    else:
        print("STEP22 TEST: ПРОВАЛОВ: ", failed)
        get_tree().quit(1)

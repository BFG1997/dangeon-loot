## Тест торговли (шаг 6): стартовое золото героев, товары торговцев
## из WorldMap.NPCS (включая Глота и Зорана), цены покупки/продажи ItemDB,
## логика Game.buy_item()/Game.sell_item(), окно лавки TradeUI, сейв после покупки.
## Запуск: godot --headless --path . res://tests/trade_test.tscn
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
    print("TRADE TEST: золото героев, товары NPC, покупка, продажа, лавка, сейв")
    snapshot()
    Saves.wipe_all_slots()
    Game.meta["last_slot"] = 0
    Game.meta["last_bonus_date"] = ""
    Game.meta["pending_gold"] = 0
    Game.meta["pending_items"] = []
    Game.current_slot = 0
    Game.save_meta()

    # --- стартовое золото героев ---
    Game.new_run(1, "warrior")
    check("воин начал со 100 з.", Game.gold == 100 and Game.hero_start_gold("warrior") == 100)
    Game.new_run(1, "barbarian")
    check("варвар начал с 50 з.", Game.gold == 50 and Game.hero_start_gold("barbarian") == 50)
    Game.new_run(1, "bum")
    check("бомж начал с 1 з.", Game.gold == 1 and Game.hero_start_gold("bum") == 1)
    check("стартовое золото попало в сейв", \
        int(Platform.load_data(1).get("gold", -1)) == 1)

    # --- товары торговцев (расстановка из дизайн-документа) ---
    var goods_of := {}
    for npc_data in WorldMap.NPCS:
        goods_of[String(npc_data["id"])] = npc_data.get("goods", [])
    check("Гура (повар): окорок", "ham" in goods_of["gura"] \
        and (goods_of["gura"] as Array).size() == 1)
    check("Вирас (кузнец): меч, большой меч, моргенштерн + броня (шаг 12)", "sword" in goods_of["viras"] \
        and "greatsword" in goods_of["viras"] and "morgenstern" in goods_of["viras"] \
        and "armor_leather" in goods_of["viras"] and "armor_chain" in goods_of["viras"] \
        and "armor_plate" in goods_of["viras"] and (goods_of["viras"] as Array).size() == 6)
    check("Злус (маг): зелья лечения и маны 3 размеров", "hp_potion" in goods_of["zlus"] \
        and "hp_potion_small" in goods_of["zlus"] and "hp_potion_large" in goods_of["zlus"] \
        and "mana_potion_small" in goods_of["zlus"] and "mana_potion" in goods_of["zlus"] \
        and "mana_potion_large" in goods_of["zlus"] and (goods_of["zlus"] as Array).size() == 6)
    check("Глот (трактирщик): вода, морс, сок, пиво", "water" in goods_of["glot"] \
        and "mors" in goods_of["glot"] and "juice" in goods_of["glot"] \
        and "beer" in goods_of["glot"] and (goods_of["glot"] as Array).size() == 4)
    check("Зоран (чародей): жезл, клинок инея, скипетр + одеяния (шаг 12)", \
        "wand_lightning" in goods_of["zoran"] \
        and "blade_frost" in goods_of["zoran"] and "scepter_comet" in goods_of["zoran"] \
        and "robe_faded" in goods_of["zoran"] and "robe_stars" in goods_of["zoran"] \
        and "robe_void" in goods_of["zoran"] and (goods_of["zoran"] as Array).size() == 6)
    check("Лира не торгует", (goods_of["lira"] as Array).is_empty())
    var all_goods_known := true
    var all_goods_priced := true
    for npc_data in WorldMap.NPCS:
        for item_id in npc_data.get("goods", []):
            if ItemDB.get_item(String(item_id)).is_empty():
                all_goods_known = false
            if ItemDB.price(String(item_id)) <= 0:
                all_goods_priced = false
    check("все товары есть в ItemDB", all_goods_known)
    check("у всех товаров цена больше нуля", all_goods_priced)

    # --- цены продажи: половина цены покупки ---
    check("цены продажи: 5/12/500/1000/2500/25", ItemDB.sell_price("ham") == 5 \
        and ItemDB.sell_price("beer") == 12 and ItemDB.sell_price("sword") == 500 \
        and ItemDB.sell_price("greatsword") == 1000 and ItemDB.sell_price("morgenstern") == 2500 \
        and ItemDB.sell_price("hp_potion") == 25)
    check("цены продажи шага 6: 2/5/7/600/1250/3000", ItemDB.sell_price("water") == 2 \
        and ItemDB.sell_price("mors") == 5 and ItemDB.sell_price("juice") == 7 \
        and ItemDB.sell_price("wand_lightning") == 600 and ItemDB.sell_price("blade_frost") == 1250 \
        and ItemDB.sell_price("scepter_comet") == 3000)
    check("цены продажи брони и одеяний (шаг 12): 20/45/90 и 17/45/85", \
        ItemDB.sell_price("armor_leather") == 20 and ItemDB.sell_price("armor_chain") == 45 \
        and ItemDB.sell_price("armor_plate") == 90 \
        and ItemDB.sell_price("robe_faded") == 17 and ItemDB.sell_price("robe_stars") == 45 \
        and ItemDB.sell_price("robe_void") == 85)
    check("уники не продаются (price < 0)", ItemDB.sell_price("star_blade") == 0 \
        and ItemDB.sell_price("comet_elixir") == 0)

    # --- покупка: бомжу с 1 монетой недоступно ничего ---
    check("бомжу окорок за 10 не по карману", not Game.buy_item("ham") and Game.gold == 1)
    check("бомжу пиво за 25 не по карману", not Game.buy_item("beer") and Game.gold == 1)
    check("бомжу даже вода за 5 не по карману", not Game.buy_item("water") and Game.gold == 1)

    # --- продажа может спасти нищего героя ---
    Game.add_item({"item_id": "ham", "title": "Окорок", "quality": "gray"})
    check("продажа окорока бомжу дала +5 з.", Game.sell_item(Game.inventory.size() - 1) \
        and Game.gold == 6)

    # --- воин с 100 з.: полный цикл покупки и продажи ---
    Game.new_run(1, "warrior")
    check("покупка зелья у Злуса: 100 -> 50", Game.buy_item("hp_potion") and Game.gold == 50)
    check("покупка пива у Глота: 50 -> 25", Game.buy_item("beer") and Game.gold == 25)
    check("меч за 1000 не по карману даже воину", not Game.buy_item("sword") and Game.gold == 25)
    check("в сумке зелье и пиво", Game.inventory.size() == 2 \
        and String((Game.inventory[0] as Dictionary).get("item_id", "")) == "hp_potion" \
        and String((Game.inventory[1] as Dictionary).get("item_id", "")) == "beer")
    check("продажа пива вернула 12 з.", Game.sell_item(1) and Game.gold == 37)
    check("продажа зелья вернула 25 з.", Game.sell_item(0) and Game.gold == 62)
    check("после продаж сумка пуста", Game.inventory.is_empty())

    # --- окно лавки TradeUI ---
    var trade_ui := TradeUI.new()
    add_child(trade_ui)
    await get_tree().process_frame
    await trade_ui.open({"name": "Вирас", "role": "Кузнец",
                         "goods": ["sword", "greatsword", "morgenstern"]})
    await get_tree().process_frame
    check("лавка открылась", trade_ui.visible)
    check("имя торговца в шапке", trade_ui._trader_label.text.contains("Вирас"))
    check("кошелёк героя в шапке", trade_ui._gold_label.text == "Золото: %d" % Game.gold)
    check("в лавке кузнеца 3 товара", trade_ui._rows.get_child_count() == 3)
    var buy_row: HBoxContainer = trade_ui._rows.get_child(0)
    var buy_btn: Button = null
    for child in buy_row.get_children():
        if child is Button and (child as Button).text == "КУПИТЬ":
            buy_btn = child
    check("меч воину не по карману — кнопка отключена", buy_btn != null \
        and (buy_btn as Button).disabled)
    trade_ui.close()
    check("лавка закрылась", not trade_ui.visible)

    # лавка Глота: покупка и продажа прямо через кнопки UI
    var gold_before: int = Game.gold
    await trade_ui.open({"name": "Глот", "role": "Трактирщик",
                         "goods": ["water", "mors", "juice", "beer"]})
    await get_tree().process_frame
    check("в лавке Глота 4 напитка", trade_ui._rows.get_child_count() == 4)
    buy_row = trade_ui._rows.get_child(0)
    buy_btn = null
    for child in buy_row.get_children():
        if child is Button and (child as Button).text == "КУПИТЬ":
            buy_btn = child
    check("вода по карману — кнопка активна", buy_btn != null \
        and not (buy_btn as Button).disabled)
    if buy_btn != null:
        buy_btn.pressed.emit()
        await get_tree().process_frame
    check("покупка через UI списала цену", Game.gold == gold_before - ItemDB.price("water"))
    trade_ui._tab_sell.pressed.emit()
    await get_tree().process_frame
    check("вкладка ПРОДАЖА отражает сумку", \
        trade_ui._rows.get_child_count() == Game.inventory.size())
    var sell_row: HBoxContainer = trade_ui._rows.get_child(0)
    var sell_btn: Button = null
    for child in sell_row.get_children():
        if child is Button and (child as Button).text == "ПРОДАТЬ":
            sell_btn = child
    if sell_btn != null:
        sell_btn.pressed.emit()
        await get_tree().process_frame
    check("продажа через UI вернула половину цены", \
        Game.gold == gold_before - ItemDB.price("water") + ItemDB.sell_price("water"))
    trade_ui.close()
    trade_ui.free()
    await get_tree().process_frame

    # --- шаг 12: покупка и надевание брони ---
    Game.new_run(1, "warrior")
    check("воин купил кожаный доспех за 40 з. у Вираса", Game.buy_item("armor_leather") \
        and Game.gold == 60)
    check("доспех надет: максимум ХП 50 -> 60", \
        bool(Game.equip_armor("armor_leather").get("ok", false)) and Game.max_hp() == 60)
    check("надетая броня уехала в сейв (v5)", \
        String(Platform.load_data(1).get("equipped_armor_id", "")) == "armor_leather")
    check("загрузка слота восстанавливает броню", Game.continue_run(1) \
        and Game.has_armor() and Game.equipped_armor_id == "armor_leather")

    # --- сейв после покупок ---
    Game.new_run(1, "warrior")
    Game.buy_item("ham")
    Game.buy_item("hp_potion")
    var saved: Dictionary = Platform.load_data(1)
    check("золото после покупок сохранилось (100-10-50=40)", \
        int(saved.get("gold", -1)) == 40)
    var saved_items: Array = saved.get("inventory", [])
    check("купленные предметы сохранились", saved_items.size() == 2 \
        and String((saved_items[0] as Dictionary).get("item_id", "")) == "ham" \
        and String((saved_items[1] as Dictionary).get("item_id", "")) == "hp_potion")
    check("загрузка слота возвращает 40 з.", Game.continue_run(1) and Game.gold == 40)

    # Возвращаем исходное состояние, чтобы тест не портил сейвы.
    restore()

    if failed == 0:
        print("TRADE TEST: ВСЁ ОК")
        get_tree().quit(0)
    else:
        print("TRADE TEST: ПРОВАЛОВ: ", failed)
        get_tree().quit(1)

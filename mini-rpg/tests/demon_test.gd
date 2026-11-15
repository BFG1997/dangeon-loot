## Тест демона (шаг 8; шаги 12/13): спавн Таинственного демона у края
## улицы после первого убийства, его реплики-обработка, товары и цены павших
## торговцев со скидкой -10% за каждого убитого NPC, запрет старых диалогов
## у живых NPC, лавка демона через UI (покупка со скидкой), ярость после
## трёх ударов (преследование, удары по герою, лавка закрыта), СБРОС ЯРОСТИ
## при возрождении героя (шаг 13), вечная смерть демона: жертвы оживают
## и забывают, демон больше не возвращается (сейв v7).
## Запуск: godot --headless --path . res://tests/demon_test.tscn
extends Node

var failed := 0

func check(name: String, condition: bool) -> void:
    if condition:
        print("  [OK] ", name)
    else:
        failed += 1
        print("  [ПРОВАЛ] ", name)

func find_npc(world: Node2D, npc_id: String) -> Dictionary:
    for npc in world._npcs:
        if String(npc["id"]) == npc_id:
            return npc
    return {}

func _ready() -> void:
    print("DEMON TEST: демон, скидки, лавка, память NPC")
    Saves.wipe_all_slots()
    Game.meta["last_slot"] = 0
    Game.meta["last_bonus_date"] = ""
    Game.meta["pending_gold"] = 0
    Game.meta["pending_items"] = []
    Game.save_meta()
    Platform.calls.clear()
    Game.new_run(1, "warrior")   # воин: моргенштерн бьёт ровно 100 (без множителей варвара)
    Game.add_gold(500)   # кошелёк на покупки у демона
    Platform.calls.clear()

    var world: Node2D = (load("res://scenes/world/world.tscn") as PackedScene).instantiate()
    add_child(world)
    await get_tree().process_frame
    await get_tree().process_frame

    # --- до убийств: демона нет, товаров нет, скидки нет ---
    check("демона нет на старте мира", find_npc(world, "demon").is_empty())
    check("товаров у демона нет", Game.demon_goods().is_empty())
    check("скидка нулевая", Game.demon_discount_pct() == 0)
    check("уровень NPC в мире: только 6 жителей", world._npcs.size() == 6)

    # --- убиваем торговца Глота ударом (как в бою) ---
    var glot := find_npc(world, "glot")
    check("Глот найден", not glot.is_empty())
    world.player.position = (glot["node"] as Node2D).position + Vector2(-18, 0)
    world._facing = "side"
    world._player_sprite.flip_h = false
    Game.add_item({"item_id": "morgenstern", "title": "Моргенштерн", "quality": "gray"})
    check("моргенштерн в руках", Game.equip_weapon("morgenstern") and Game.strike_damage() == 100)
    world._strike_cd = 0.0
    world._strike()
    check("Глот убит одним ударом", bool(glot["dead"]) and Game.is_npc_dead("glot"))
    await get_tree().process_frame
    await get_tree().process_frame   # спавн демона отложен на кадр

    # --- демон появился у края улицы ---
    var demon := find_npc(world, "demon")
    check("демон появился после первого убийства", not demon.is_empty())
    check("демон втрое крупнее обычного NPC", int(demon["data"].get("scale", 1)) == 3 \
        and int(demon["max_hp"]) == 200)
    check("демон стоит у самого края улицы", int((demon["tile"] as Vector2).y) \
        >= WorldMap.RAILING_ROW - 3)
    check("товары Глота переехали к демону", Game.demon_goods() \
        == ["water", "mors", "juice", "beer"])
    check("скидка 10% за одну жертву", Game.demon_discount_pct() == 10)
    check("цена морса у демона 9 з. (было 10)", Game.demon_price("mors") == 9)
    check("цена пива у демона 23 з. (было 25, 22.5 округляется)", Game.demon_price("beer") == 23)
    check("buy_from_demon отказывает чужому товару", not Game.buy_from_demon("ham"))

    # --- реплики демона: он рад, а не пугается ---
    world.npc_say("demon")
    await get_tree().process_frame
    check("демон заговорил", world._dialogue.visible)
    check("имя демона в диалоге", world._dialogue._name_label.text.contains("демон"))
    check("демон радуется убийству", world._dialogue._text_label.text.contains("Хе-хе"))
    check("демон помнит имя жертвы", world._dialogue._lines.size() > 1 \
        and String(world._dialogue._lines[1]).contains("Глота"))
    check("демон зовёт торговать", world._dialogue._trade_button.visible)
    world._dialogue._close()
    await get_tree().process_frame

    # --- лавка демона: покупка со скидкой через UI ---
    world.npc_say("demon")
    await get_tree().process_frame
    world._dialogue._trade_button.pressed.emit()
    await get_tree().process_frame
    check("лавка демона открылась", world._trade_ui.visible and world._trade_ui._is_demon)
    check("в лавке демона 4 товара Глота", world._trade_ui._rows.get_child_count() == 4)
    var gold_before: int = Game.gold
    var mors_row: HBoxContainer = world._trade_ui._rows.get_child(1)   # морс второй
    var buy_btn: Button = null
    for child in mors_row.get_children():
        if child is Button and (child as Button).text == "КУПИТЬ":
            buy_btn = child
    check("кнопка КУПИТЬ у морса найдена", buy_btn != null \
        and not (buy_btn as Button).disabled)
    if buy_btn != null:
        buy_btn.pressed.emit()
        await get_tree().process_frame
    check("покупка у демона списала 9 з.", Game.gold == gold_before - 9)
    check("морс в сумке", String((Game.inventory.back() as Dictionary) \
        .get("item_id", "")) == "mors")
    world._trade_ui.close()
    await get_tree().process_frame

    # --- шаг 23: продали демону магическое оружие — оно в ЕГО лавке ---
    Game.add_item({"item_id": "blade_frost", "title": "Морозный клинок",
        "quality": "blue"})
    var frost_idx := -1
    for i in range(Game.inventory.size()):
        if String((Game.inventory[i] as Dictionary).get("item_id", "")) \
                == "blade_frost":
            frost_idx = i
    check("морозный клинок в сумке для продажи", frost_idx >= 0)
    var stock_before: Dictionary = Game.merchant_stock.duplicate()
    check("продажа демону принята", frost_idx >= 0 \
        and Game.sell_item(frost_idx, true))
    check("клинок исчез из сумки", not Game._has_item("blade_frost"))
    check("демон выставил клинок на свой прилавок",
        Game.demon_goods().has("blade_frost"))
    check("прилавок живого Зорана не тронут",
        Game.merchant_stock == stock_before)
    check("клинок у демона по скидочной цене", Game.demon_price("blade_frost") \
        == int(round(float(ItemDB.price("blade_frost")) * 0.9)))
    check("demon_stock уехал в сейв v7", "blade_frost" \
        in (Game.to_save_data().get("demon_stock", []) as Array))
    await get_tree().process_frame

    # --- убиваем не-торговца Лиру: скидка растёт, товары не растут ---
    var lira := find_npc(world, "lira")
    world.player.position = (lira["node"] as Node2D).position + Vector2(-18, 0)
    world._facing = "side"
    world._player_sprite.flip_h = false
    world._strike_cd = 0.0
    world._strike()
    check("Лира убита", bool(lira["dead"]) and Game.is_npc_dead("lira"))
    await get_tree().process_frame
    check("скидка 20% за двух убитых", Game.demon_discount_pct() == 20)
    check("цена морса упала до 8 з.", Game.demon_price("mors") == 8)
    check("товаров у демона: 4 базовых + проданный клинок (Лира не торговала)",
        Game.demon_goods().size() == 5)
    check("демон не появился второй раз", world._npcs.size() == 7)   # 6 жителей + демон

    # --- старые диалоги пропали: у живых NPC только реплика про убийство ---
    world.npc_say("gura")
    await get_tree().process_frame
    check("старых реплик нет: только реакция", world._dialogue.visible \
        and world._dialogue._lines.size() == 1)
    check("реакция помнит обе жертвы", world._dialogue._text_label.text.contains("Глота") \
        and world._dialogue._text_label.text.contains("Лиру"))
    check("торговать с жителем нельзя", not world._dialogue._trade_button.visible)
    world._dialogue._close()
    await get_tree().process_frame

    # --- шаг 12: три удара по демону — ярость, преследование и удары по герою ---
    demon = find_npc(world, "demon")
    Game.add_item({"item_id": "sword", "title": "Меч", "quality": "gray"})
    check("меч в руках (30 урона у воина)", Game.equip_weapon("sword") \
        and Game.strike_damage() == 30)
    check("до ударов демон спокоен", not Game.demon_enraged and Game.demon_hits == 0)
    world.player.position = (demon["node"] as Node2D).position + Vector2(-20, 0)
    world._facing = "side"
    world._player_sprite.flip_h = false
    world._strike_cd = 0.0
    world._strike()
    check("первый удар: демон шепчет «Один», не в ярости", Game.demon_hits == 1 \
        and not Game.demon_enraged)
    world._strike_cd = 0.0
    world._strike()
    check("второй удар: счёт 2, демон всё ещё сдерживается", Game.demon_hits == 2 \
        and not Game.demon_enraged)
    world._strike_cd = 0.0
    world._strike()
    check("третий удар: демон в ярости и жив (200-90=110)", Game.demon_hits == 3 \
        and Game.demon_enraged and not bool(demon["dead"]) and int(demon["hp"]) == 110)
    await get_tree().process_frame
    world.npc_say("demon")
    await get_tree().process_frame
    check("в ярости демон грозит, а не торгует", world._dialogue.visible \
        and not world._dialogue._trade_button.visible \
        and world._dialogue._text_label.text.contains("Ты ударил меня"))
    world._dialogue._close()
    await get_tree().process_frame
    var hp_before: int = Game.hp
    var demon_dist_before: float = world.player.position.distance_to(
        (demon["node"] as Node2D).position)
    for _i in 150:
        await get_tree().physics_frame   # ~2.5 с: демон догоняет и бьёт когтями
    var demon_dist_after: float = world.player.position.distance_to(
        (demon["node"] as Node2D).position)
    check("демон преследует героя (в дистанции когтей)", demon_dist_after <= 34.0 \
        and demon_dist_after <= demon_dist_before)
    check("демон бьёт героя: хп упали", Game.hp < hp_before and Game.hp > 0)
    check("герой не умер от пары когтей (воин 50 хп)", not world._player_dead)

    # --- шаг 13: возрождение героя гасит ярость демона ---
    world._respawn_player()
    await get_tree().process_frame
    check("после возрождения ярость погасла", not Game.demon_enraged \
        and Game.demon_hits == 0)
    check("аура демона снята (спрайт снова белый)", \
        (demon["sprite"] as AnimatedSprite2D).modulate == Color.WHITE)
    check("демон вернулся к краю улицы", \
        (demon["node"] as Node2D).position.distance_to(\
            Vector2(15 * 16 + 8, 45 * 16 - 3)) < 8.0)
    var demon_dist_calm: float = world.player.position.distance_to(\
        (demon["node"] as Node2D).position)
    for _i in 60:
        await get_tree().physics_frame
    check("мирный демон не преследует героя", \
        world.player.position.distance_to((demon["node"] as Node2D).position) \
            >= demon_dist_calm - 4.0)

    # --- демон тоже смертен: добиваем моргенштерном (хп уже не восстановились) ---
    demon = find_npc(world, "demon")
    check("моргенштерн снова в руках (100 урона)", Game.equip_weapon("morgenstern") \
        and Game.strike_damage() == 100)
    world.player.position = (demon["node"] as Node2D).position + Vector2(-20, 0)
    world._facing = "side"
    world._player_sprite.flip_h = false
    world._strike_cd = 0.0
    world._strike()
    check("первый удар моргенштерном: 110 -> 10", not bool(demon["dead"]) \
        and int(demon["hp"]) == 10)
    world._strike_cd = 0.0
    world._strike()
    # Демон мёртв в мире, но в списке убитых его НЕТ: defeat_demon_permanently()
    # очищает dead_npcs (жертвы оживают и забывают), труп демона остаётся трупом.
    check("демон убит добиванием (труп, не жертва)", bool(demon["dead"]) \
        and not Game.is_npc_dead("demon"))
    await get_tree().process_frame

    # --- шаг 13: демон повержен НАВСЕГДА — жертвы оживают и забывают ---
    check("демон повержен навсегда (Game)", Game.demon_gone_forever() \
        and Game.demon_defeated)
    check("жертвы забыты: список убитых пуст", Game.dead_npcs.is_empty())
    check("скидка сброшена (жертв больше нет)", Game.demon_discount_pct() == 0)
    check("товаров у демона больше нет", Game.demon_goods().is_empty())
    check("сейв v7 хранит demon_defeated", int(Game.to_save_data().get("v", 0)) == 7 \
        and bool(Game.to_save_data().get("demon_defeated", false)))
    glot = find_npc(world, "glot")
    check("Глот ожил", not bool(glot["dead"]) and int(glot["hp"]) == 50)
    world.npc_say("glot")
    await get_tree().process_frame
    check("Глот забыл убийство: обычные реплики вернулись", world._dialogue.visible \
        and world._dialogue._lines.size() > 1)
    check("торговля с ожившим Глотом вернулась", world._dialogue._trade_button.visible)
    world._dialogue._close()
    await get_tree().process_frame
    world.npc_say("viras")
    await get_tree().process_frame
    check("Вирас тоже забыл: обычные реплики", world._dialogue.visible \
        and world._dialogue._lines.size() > 1)
    world._dialogue._close()
    await get_tree().process_frame
    # --- демон больше не вернётся, даже если снова убить NPC ---
    var gura_rec: Dictionary = find_npc(world, "gura")
    world.player.position = (gura_rec["node"] as Node2D).position + Vector2(-18, 0)
    world._facing = "side"
    world._player_sprite.flip_h = false
    world._strike_cd = 0.0
    world._strike()
    check("Гура убита уже после победы над демоном", bool(gura_rec["dead"]))
    await get_tree().process_frame
    await get_tree().process_frame
    var demon_after: Dictionary = find_npc(world, "demon")
    check("демон не вернулся после нового убийства", \
        demon_after.is_empty() or bool(demon_after.get("dead", true)))
    world.npc_say("demon")
    await get_tree().process_frame
    check("труп демона молчит и не торгует", not world._dialogue.visible)

    # --- новая игра воскрешает мир: демон исчезает вместе с памятью ---
    world.free()
    await get_tree().process_frame
    Game.new_run(2, "warrior")
    check("новая игра: убитых нет", Game.dead_npcs.is_empty())
    check("новая игра: удары демона забыты, ярость снята", Game.demon_hits == 0 \
        and not Game.demon_enraged)
    check("новая игра: демон снова жив (demon_defeated сброшен)", \
        not Game.demon_defeated)
    check("новая игра: товаров у демона нет", Game.demon_goods().is_empty())
    check("новая игра: скидки нет", Game.demon_discount_pct() == 0)
    var world2: Node2D = (load("res://scenes/world/world.tscn") as PackedScene).instantiate()
    add_child(world2)
    await get_tree().process_frame
    await get_tree().process_frame
    check("в новом мире демона нет", find_npc(world2, "demon").is_empty())
    world2.free()
    await get_tree().process_frame

    if failed == 0:
        print("DEMON TEST: ВСЁ ОК")
        get_tree().quit(0)
    else:
        print("DEMON TEST: ПРОВАЛОВ: ", failed)
        get_tree().quit(1)

## Дымовой тест обвязки проекта. Запуск из папки проекта:
##   godot --headless --path . res://tests/smoke_test.tscn
## Проверяет автозагрузки, слоты сейвов, meta, героев, бонус,
## базу предметов и шансы лута. В конце восстанавливает исходное состояние.
extends Node

const ROLLS := 20000

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
    print("SMOKE: автозагрузки, слоты, герои, бонус, предметы, лут")
    snapshot()
    Saves.wipe_all_slots()
    Game.meta["last_slot"] = 0
    Game.meta["last_bonus_date"] = ""
    Game.meta["pending_gold"] = 0
    Game.meta["pending_items"] = []
    Game.current_slot = 0
    Game.save_meta()

    # --- золото и инвентарь ---
    var gold_before: int = Game.gold
    Game.add_gold(25)
    check("Game.add_gold", Game.gold == gold_before + 25)
    check("Game.spend_gold хватает", Game.spend_gold(10) and Game.gold == gold_before + 15)
    check("Game.spend_gold не уводит в минус", not Game.spend_gold(1000000))
    var items_before: int = Game.inventory.size()
    Game.add_item({"quality": "green", "title": "Зелёная"})
    check("Game.add_item", Game.inventory.size() == items_before + 1)

    # --- слоты Platform ---
    var data1 := {"v": 2, "hero_id": "warrior", "gold": 111, "inventory": [], "dungeons_cleared": []}
    check("Platform.save_data слот 1", Platform.save_data(data1, 1) == OK)
    var data2 := {"v": 2, "hero_id": "barbarian", "gold": 222, "inventory": [], "dungeons_cleared": []}
    check("Platform.save_data слот 2", Platform.save_data(data2, 2) == OK)
    check("Platform.has_slot(1,2)", Platform.has_slot(1) and Platform.has_slot(2))
    check("слоты изолированы", int(Platform.load_data(1).get("gold", 0)) == 111 \
        and int(Platform.load_data(2).get("gold", 0)) == 222)
    check("пустой слот 3", Platform.load_data(3).is_empty() and not Platform.has_slot(3))

    # --- meta Platform ---
    check("Platform.save_meta", Platform.save_meta({"settings": {"sound": true}}) == OK)
    check("Platform.load_meta", bool(Platform.load_meta().get("settings", {}).get("sound", false)))

    # --- настройки (теперь в meta) ---
    Game.set_setting("sound", false)
    check("Game.set_setting хранится в meta", \
        not bool((Platform.load_meta().get("settings", {}) as Dictionary).get("sound", true)))
    Game.set_setting("sound", true)

    # --- герои и новая игра ---
    check("HEROES: четыре героя", Game.HEROES.size() == 4 \
        and Game.HEROES.has("warrior") and Game.HEROES.has("barbarian") \
        and Game.HEROES.has("bum") and Game.HEROES.has("mage"))
    check("маг: хп 30 и мана 70 (числа автора)", \
        Game.hero_max_hp("mage") == 30 and Game.hero_max_mana("mage") == 70)
    check("стартовое золото: воин 100, варвар 50, бомж 1", \
        Game.hero_start_gold("warrior") == 100 and Game.hero_start_gold("barbarian") == 50 \
        and Game.hero_start_gold("bum") == 1)
    Game.new_run(1, "barbarian")
    check("new_run: сброс и герой", Game.gold == Game.hero_start_gold("barbarian") \
        and Game.inventory.is_empty() and Game.hero_id == "barbarian" and Game.current_slot == 1)
    check("to_save_data содержит героя", Game.to_save_data().get("hero_id", "") == "barbarian")
    check("new_run записал слот 1", Platform.has_slot(1) \
        and int(Platform.load_data(1).get("gold", -1)) == Game.hero_start_gold("barbarian"))
    check("meta.last_slot обновлён", int(Game.meta.get("last_slot", 0)) == 1)

    # --- выбор слота для новой игры ---
    Saves.wipe_all_slots()
    Game.meta["last_slot"] = 0
    check("pick_new_slot: первый свободный", Game.pick_new_slot() == 1)
    Platform.save_data({"v": 2}, 1)
    check("pick_new_slot: обходит занятый", Game.pick_new_slot() == 2)
    Platform.save_data({"v": 2}, 2)
    Platform.save_data({"v": 2}, 3)
    Game.meta["last_slot"] = 3
    check("pick_new_slot: все заняты — последний", Game.pick_new_slot() == 3)

    # --- продолжить/загрузить ---
    Saves.wipe_all_slots()
    Game.meta["last_slot"] = 0
    Game.current_slot = 0
    check("continue_run на пустом слоте — false", not Game.continue_run(1))
    Game.gold = 500
    Game.hero_id = "warrior"
    Game.current_slot = 3
    Saves.request_save()
    Game.gold = 0
    Game.hero_id = "bum"
    check("continue_run грузит слот", Game.continue_run(3) and Game.gold == 500 \
        and Game.hero_id == "warrior" and Game.current_slot == 3)

    # --- база предметов (числа из дизайн-документа) ---
    var ham: Dictionary = ItemDB.get_item("ham")
    check("окорок: 10 з., +50 хп", int(ham.get("price", 0)) == 10 and int(ham.get("heal", 0)) == 50)
    var beer: Dictionary = ItemDB.get_item("beer")
    var beer_debuff: Dictionary = beer.get("debuff", {})
    check("пиво: +100 хп, -50 к попаданию на 2 хода", int(beer.get("heal", 0)) == 100 \
        and int(beer_debuff.get("hit_chance", 0)) == -50 and int(beer_debuff.get("turns", 0)) == 2)
    var sword: Dictionary = ItemDB.get_item("sword")
    check("меч: 1000 з., 30 урона", int(sword.get("price", 0)) == 1000 and int(sword.get("damage", 0)) == 30)
    var greatsword: Dictionary = ItemDB.get_item("greatsword")
    check("большой меч: 2000 з., 50 урона", int(greatsword.get("price", 0)) == 2000 and int(greatsword.get("damage", 0)) == 50)
    var morgenstern: Dictionary = ItemDB.get_item("morgenstern")
    check("моргенштерн: 5000 з., 100 урона", int(morgenstern.get("price", 0)) == 5000 and int(morgenstern.get("damage", 0)) == 100)
    check("зелье на хп есть", ItemDB.get_item("hp_potion").get("type", "") == "potion" \
        and ItemDB.get_item("hp_potion").has("heal"))
    var violet_id := ItemDB.random_violet_unique()
    check("фиолетовый уник в списке", violet_id in ItemDB.VIOLET_UNIQUES \
        and bool(ItemDB.get_item(violet_id).get("violet", false)))
    check("названия предметов на русском", ItemDB.title("ham") == "Окорок" \
        and ItemDB.title("morgenstern") == "Моргенштерн")

    # --- шаг 6: напитки Глота (ряд растёт по цене и хп) и магическое оружие ---
    check("вода: 5 з., +20 хп", ItemDB.price("water") == 5 \
        and int(ItemDB.get_item("water").get("heal", 0)) == 20)
    check("морс: 10 з., +40 хп", ItemDB.price("mors") == 10 \
        and int(ItemDB.get_item("mors").get("heal", 0)) == 40)
    check("сок: 15 з., +60 хп", ItemDB.price("juice") == 15 \
        and int(ItemDB.get_item("juice").get("heal", 0)) == 60)
    check("ряд напитков растёт по цене и хп", ItemDB.price("water") < ItemDB.price("mors") \
        and ItemDB.price("mors") < ItemDB.price("juice") \
        and ItemDB.price("juice") < ItemDB.price("beer") \
        and int(ItemDB.get_item("water").get("heal", 0)) < int(ItemDB.get_item("mors").get("heal", 0)) \
        and int(ItemDB.get_item("mors").get("heal", 0)) < int(ItemDB.get_item("juice").get("heal", 0)) \
        and int(ItemDB.get_item("juice").get("heal", 0)) < int(ItemDB.get_item("beer").get("heal", 0)))
    check("жезл молний: 1200 з., 35 урона", ItemDB.price("wand_lightning") == 1200 \
        and int(ItemDB.get_item("wand_lightning").get("damage", 0)) == 35)
    check("клинок инея: 2500 з., 55 урона", ItemDB.price("blade_frost") == 2500 \
        and int(ItemDB.get_item("blade_frost").get("damage", 0)) == 55)
    check("скипетр кометы: 6000 з., 110 урона", ItemDB.price("scepter_comet") == 6000 \
        and int(ItemDB.get_item("scepter_comet").get("damage", 0)) == 110)
    check("еда/питьё/зелья можно использовать", "food" in ItemDB.USABLE_TYPES \
        and "drink" in ItemDB.USABLE_TYPES and "potion" in ItemDB.USABLE_TYPES)

    # --- торговля (шаг 5): цены продажи — половина цены покупки ---
    check("продажа: окорок 5, пиво 12, меч 500", ItemDB.sell_price("ham") == 5 \
        and ItemDB.sell_price("beer") == 12 and ItemDB.sell_price("sword") == 500)
    check("продажа: большой меч 1000, моргенштерн 2500, зелье 25", \
        ItemDB.sell_price("greatsword") == 1000 and ItemDB.sell_price("morgenstern") == 2500 \
        and ItemDB.sell_price("hp_potion") == 25)
    check("продажа: вода 2, морс 5, сок 7", ItemDB.sell_price("water") == 2 \
        and ItemDB.sell_price("mors") == 5 and ItemDB.sell_price("juice") == 7)
    check("продажа: жезл 600, клинок инея 1250, скипетр 3000", \
        ItemDB.sell_price("wand_lightning") == 600 and ItemDB.sell_price("blade_frost") == 1250 \
        and ItemDB.sell_price("scepter_comet") == 3000)
    check("уники и несуществующие не продаются", ItemDB.sell_price("star_blade") == 0 \
        and ItemDB.sell_price("abyss_cloak") == 0 and ItemDB.sell_price("no_such_item") == 0)

    # --- торговля: покупка и продажа ---
    Saves.wipe_all_slots()
    Game.meta["last_slot"] = 0
    Game.current_slot = 0
    Game.new_run(1, "warrior")
    check("воин начал со 100 з.", Game.gold == 100)
    check("покупка окорока: 100 -> 90", Game.buy_item("ham") and Game.gold == 90)
    check("окорок оказался в сумке", not Game.inventory.is_empty() \
        and String((Game.inventory.back() as Dictionary).get("item_id", "")) == "ham")
    check("моргенштерн не по карману", not Game.buy_item("morgenstern") and Game.gold == 90)
    check("уник купить нельзя", not Game.buy_item("star_blade") \
        and not Game.buy_item("no_such_item"))
    check("продажа окорока: +5 з.", Game.sell_item(Game.inventory.size() - 1) \
        and Game.gold == 95)
    check("сумка снова пуста", Game.inventory.is_empty())
    Game.add_item({"quality": "green", "title": "Безымянная добыча"})
    check("безымянную добычу не продать", not Game.sell_item(Game.inventory.size() - 1))
    Game.add_item({"item_id": "abyss_cloak", "title": "Плащ бездны", "quality": "violet"})
    check("фиолетовый уник не продать", not Game.sell_item(Game.inventory.size() - 1))
    check("кривые индексы продажи безопасны", not Game.sell_item(-1) and not Game.sell_item(999))
    check("золото не изменилось от неудачных продаж", Game.gold == 95)

    # --- шаг 6: герой Маг — хп 30, мана 70, заклинание, напитки ---
    Game.new_run(1, "mage")
    check("маг начал с 60 з. (ЗАГЛУШКА, задать автору)", Game.gold == 60 \
        and Game.hero_start_gold("mage") == 60)
    check("маг: хп 30/30 и мана 70/70 на старте", Game.hp == 30 and Game.mana == 70 \
        and Game.max_hp() == 30 and Game.max_mana() == 70 and Game.is_mage())
    check("хп и мана мага попали в сейв (v3)", int(Platform.load_data(1).get("hp", -1)) == 30 \
        and int(Platform.load_data(1).get("mana", -1)) == 70)
    check("стрела списывает ману: 70 -> 58", Game.cast_spell() and Game.mana == 58)
    Game.regen_mana(3)
    check("реген маны: 58 -> 61", Game.mana == 61)
    Game.mana = 5
    check("без маны заклинание не кастуется", not Game.cast_spell() and Game.mana == 5)
    Game.damage_hp(20)                                   # 30 -> 10
    check("урон по герою: хп 10/30", Game.hp == 10)
    Game.buy_item("mors")                                # 48 - 10 = 38 з.
    check("морс куплен и в сумке", String((Game.inventory.back() as Dictionary).get("item_id", "")) == "mors")
    var used := Game.use_consumable(Game.inventory.size() - 1)
    check("морс выпит: +20 хп (срезано до максимума 30)", bool(used.get("ok", false)) \
        and Game.hp == 30 and int(used.get("healed", 0)) == 20)
    check("выпитый морс исчез из сумки", Game.inventory.is_empty())
    Game.add_item({"item_id": "water", "title": "Вода", "quality": "gray"})
    var full_res := Game.use_consumable(Game.inventory.size() - 1)
    check("при полных хп напиток не тратится", bool(full_res.get("full", false)) \
        and not bool(full_res.get("ok", false)) and Game.inventory.size() == 1)
    check("кривой индекс безопасен", not bool((Game.use_consumable(-1)).get("ok", true)) \
        and not bool((Game.use_consumable(999)).get("ok", true)))
    Game.hero_id = "warrior"
    check("воин не маг — каст запрещён", not Game.cast_spell())

    # --- шаг 7: зелья трёх размеров, мана-зелья только магу ---
    Game.new_run(1, "mage")
    check("зелья лечения: 25/50/100 з. и +40/80/160 хп", \
        ItemDB.price("hp_potion_small") == 25 and ItemDB.price("hp_potion") == 50 \
        and ItemDB.price("hp_potion_large") == 100 \
        and int(ItemDB.get_item("hp_potion_small").get("heal", 0)) == 40 \
        and int(ItemDB.get_item("hp_potion").get("heal", 0)) == 80 \
        and int(ItemDB.get_item("hp_potion_large").get("heal", 0)) == 160)
    check("зелья маны: 30/60/120 з. и +30/60/120 маны", \
        ItemDB.price("mana_potion_small") == 30 and ItemDB.price("mana_potion") == 60 \
        and ItemDB.price("mana_potion_large") == 120 \
        and ItemDB.mana_restored("mana_potion_small") == 30 \
        and ItemDB.mana_restored("mana_potion") == 60 \
        and ItemDB.mana_restored("mana_potion_large") == 120)
    check("продажа зелий: 12/25/50 и 15/30/60", ItemDB.sell_price("hp_potion_small") == 12 \
        and ItemDB.sell_price("hp_potion") == 25 and ItemDB.sell_price("hp_potion_large") == 50 \
        and ItemDB.sell_price("mana_potion_small") == 15 and ItemDB.sell_price("mana_potion") == 30 \
        and ItemDB.sell_price("mana_potion_large") == 60)
    Game.mana = 10
    Game.add_item({"item_id": "mana_potion", "title": "Зелье маны", "quality": "gray"})
    var mana_res := Game.use_consumable(Game.inventory.size() - 1)
    check("маг выпил зелье маны: 10 -> 70 (срезано до максимума)", \
        bool(mana_res.get("ok", false)) and Game.mana == 70 \
        and int(mana_res.get("restored", 0)) == 60)
    check("выпитое мана-зелье исчезло", Game.inventory.is_empty())
    Game.hero_id = "warrior"
    Game.add_item({"item_id": "mana_potion_small", "title": "Малое зелье маны", "quality": "gray"})
    var blocked_res := Game.use_consumable(Game.inventory.size() - 1)
    check("не-магу мана-зелье не тратится", not bool(blocked_res.get("ok", false)) \
        and String(blocked_res.get("blocked", "")) == "not_mage" \
        and Game.inventory.size() == 1)

    # --- шаг 7: оружие в руках — удар рукой vs удар оружием ---
    check("кулаки: удар рукой у всех (заглушка 5 урона)", not Game.has_weapon() \
        and Game.strike_damage() == Game.HAND_DAMAGE and Game.strike_title() == "Кулаки")
    Game.add_item({"item_id": "sword", "title": "Меч", "quality": "gray"})
    check("экипировка меча: 30 урона", Game.equip_weapon("sword") and Game.has_weapon() \
        and Game.strike_damage() == 30 and Game.strike_title() == "Меч")
    check("оружие в руках сохраняется в сейве (v5)", \
        String(Platform.load_data(1).get("equipped_weapon_id", "")) == "sword")
    check("повторная экипировка того же — false", not Game.equip_weapon("sword"))
    check("экипировать не-оружие нельзя", not Game.equip_weapon("ham"))
    check("экипировать то, чего нет в сумке, нельзя", not Game.equip_weapon("greatsword"))
    Game.add_item({"item_id": "morgenstern", "title": "Моргенштерн", "quality": "gray"})
    check("смена оружия в руках: 100 урона", Game.equip_weapon("morgenstern") \
        and Game.strike_damage() == 100)
    Game.unequip_weapon()
    check("снятие оружия возвращает кулаки", not Game.has_weapon() \
        and Game.strike_damage() == Game.HAND_DAMAGE)
    check("меч снова в руках", Game.equip_weapon("sword"))
    check("продажа оружия из рук снимает его", Game.sell_item(1) \
        and not Game.has_weapon() and Game.gold == Game.hero_start_gold("mage") + 500)

    # --- шаг 12: броня и одеяния — база предметов ---
    check("типы экипировки в ItemDB.EQUIP_TYPES", "weapon" in ItemDB.EQUIP_TYPES \
        and "armor" in ItemDB.EQUIP_TYPES and "robe" in ItemDB.EQUIP_TYPES)
    check("броня Вираса: 40/90/180 з. и +10/+20/+35 ХП (ЗАГЛУШКИ)", \
        ItemDB.price("armor_leather") == 40 and ItemDB.price("armor_chain") == 90 \
        and ItemDB.price("armor_plate") == 180 \
        and ItemDB.hp_bonus("armor_leather") == 10 and ItemDB.hp_bonus("armor_chain") == 20 \
        and ItemDB.hp_bonus("armor_plate") == 35)
    check("одеяния Зорана: +мана и немного ХП (ЗАГЛУШКИ)", \
        ItemDB.price("robe_faded") == 35 and ItemDB.price("robe_stars") == 90 \
        and ItemDB.price("robe_void") == 170 \
        and ItemDB.mana_bonus("robe_faded") == 10 and ItemDB.hp_bonus("robe_faded") == 3 \
        and ItemDB.mana_bonus("robe_stars") == 20 and ItemDB.mana_bonus("robe_void") == 35)
    check("магическое оружие помечено magic", ItemDB.is_magic("wand_lightning") \
        and ItemDB.is_magic("blade_frost") and ItemDB.is_magic("scepter_comet") \
        and ItemDB.is_magic("star_blade") and not ItemDB.is_magic("morgenstern") \
        and not ItemDB.is_magic("sword"))
    check("у магического оружия есть залп", not ItemDB.volley("wand_lightning").is_empty() \
        and int(ItemDB.volley("wand_lightning").get("count", 0)) == 3 \
        and not ItemDB.volley("scepter_comet").is_empty() \
        and ItemDB.volley("morgenstern").is_empty())

    # --- шаг 12: экипировка брони и одеяний ---
    Game.new_run(1, "warrior")
    check("воин: базовый максимум 50 (ЗАГЛУШКА)", Game.max_hp() == 50)
    Game.add_item({"item_id": "armor_plate", "title": "Латный доспех", "quality": "gray"})
    check("броня надета: максимум 50 -> 85", bool(Game.equip_armor("armor_plate").get("ok", false)) \
        and Game.max_hp() == 85 and Game.has_armor())
    check("текущие хп не выросли от надевания", Game.hp == 50)
    check("надетая броня сохраняется в сейве (v5)", \
        String(Platform.load_data(1).get("equipped_armor_id", "")) == "armor_plate")
    Game.damage_hp(10)   # 50 -> 40
    Game.unequip_armor()
    check("снятие брони вернуло потолок 50 и срезало хп под него", \
        not Game.has_armor() and Game.max_hp() == 50 and Game.hp == 40)
    Game.add_item({"item_id": "robe_faded", "title": "Выцветшая мантия", "quality": "gray"})
    var robe_res := Game.equip_armor("robe_faded")
    check("одеяние не слушается не-мага", not bool(robe_res.get("ok", false)) \
        and String(robe_res.get("reason", "")) == "robe_not_mage")

    # --- шаг 12: маг + одеяние: потолок маны растёт ---
    Game.new_run(1, "mage")
    Game.add_item({"item_id": "robe_void", "title": "Одеяние Пустоты", "quality": "gray"})
    check("маг: одеяние надето, мана 70 -> 105, ХП 30 -> 40", \
        bool(Game.equip_armor("robe_void").get("ok", false)) \
        and Game.max_mana() == 105 and Game.max_hp() == 40)
    check("стрела по умолчанию: «Магическая стрела» без оружия", \
        String(Game.spell_info().get("title", "")) == "Магическая стрела" \
        and int(Game.spell_info().get("cost", 0)) == 12)

    # --- шаг 12: классовые множители и магический эффект оружия ---
    Game.hero_id = "warrior"
    Game.add_item({"item_id": "morgenstern", "title": "Моргенштерн", "quality": "gray"})
    check("воин: моргенштерн 100 урона (х1)", Game.equip_weapon("morgenstern") \
        and Game.strike_damage() == 100)
    Game.hero_id = "mage"
    check("маг: моргенштерн 50 урона (х0.5)", Game.strike_damage() == 50)
    Game.add_item({"item_id": "sword", "title": "Меч", "quality": "gray"})
    check("маг: меч 15 урона (х0.5)", Game.equip_weapon("sword") and Game.strike_damage() == 15)
    Game.add_item({"item_id": "wand_lightning", "title": "Жезл молний", "quality": "gray"})
    check("маг: жезл в полную силу 35", Game.equip_weapon("wand_lightning") \
        and Game.strike_damage() == 35)
    var volley_info := Game.spell_info()
    check("маг: на Q — Залп молний жезла (3 стрелы за 15 маны)", \
        String(volley_info.get("title", "")) == "Залп молний" \
        and int(volley_info.get("count", 0)) == 3 and int(volley_info.get("cost", 0)) == 15 \
        and int(volley_info.get("damage", 0)) == 10)
    Game.hero_id = "warrior"
    check("воин: жезл с магическим эффектом 44 (35 + 25%)", Game.strike_damage() == 44)
    check("воину залп недоступен — spell_info пуст", Game.spell_info().is_empty())
    check("подсказка не-магу с магическим оружием", \
        Game.non_mage_spell_hint().contains("залп"))
    Game.unequip_weapon()
    Game.hero_id = "barbarian"
    check("варвар: меч 60 урона (х2)", Game.equip_weapon("sword") and Game.strike_damage() == 60)
    check("варвару магическое оружие взять нельзя", not Game.equip_weapon("wand_lightning") \
        and Game.strike_damage() == 60 and Game.has_weapon() \
        and String(Game.equipped_weapon_id) == "sword")
    check("варвар: моргенштерн 200 урона (х2)", Game.equip_weapon("morgenstern") \
        and Game.strike_damage() == 200)
    check("варвару Q отвечает отказ магии", Game.non_mage_spell_hint().contains("варвара"))
    Game.unequip_weapon()

    # --- шаг 12: ярость демона после трёх ударов ---
    check("демон в новой игре мирен: 0 ударов", not Game.demon_enraged and Game.demon_hits == 0)
    Game.register_demon_hit()
    Game.register_demon_hit()
    check("после 2 ударов демон ещё сдерживается", Game.demon_hits == 2 and not Game.demon_enraged)
    Game.register_demon_hit()
    check("после 3 ударов демон в ярости", Game.demon_enraged)
    Game.new_run(2, "warrior")
    check("новая игра: демон забывает удары", Game.demon_hits == 0 and not Game.demon_enraged)

    # --- шаг 7: смерть NPC — память на текущую сессию ---
    check("NPC живы по умолчанию", not Game.is_npc_dead("glot") and not Game.is_npc_dead("gura"))
    Game.kill_npc("glot")
    check("убитый NPC мёртв", Game.is_npc_dead("glot"))
    Game.kill_npc("glot")
    check("повторное kill_npc не дублирует", Game.dead_npcs.size() == 1)
    Game.kill_npc("gura")
    check("несколько убитых помнятся", Game.dead_npcs.size() == 2)
    Game.new_run(2, "warrior")
    check("новая игра: мёртвые воскресли (список живёт в сессии)", Game.dead_npcs.is_empty())


    # --- ежедневный бонус: 50-200 золота + фиолетовая добыча ---
    Game.meta["last_bonus_date"] = ""
    Game.current_slot = 0
    var gold_pre_bonus: int = Game.gold
    check("can_claim_bonus после сброса даты", Game.can_claim_bonus())
    var reward := Game.claim_daily_bonus()
    check("бонус выдаётся", not reward.is_empty())
    check("бонус: 50-200 золота", int(reward.get("gold", 0)) >= 50 and int(reward.get("gold", 0)) <= 200)
    check("бонус: золото начислено", Game.gold == gold_pre_bonus + int(reward.get("gold", 0)))
    check("бонус: фиолетовая добыча в инвентаре", not Game.inventory.is_empty() \
        and String((Game.inventory.back() as Dictionary).get("item_id", "")) in ItemDB.VIOLET_UNIQUES)
    check("бонус: дата зафиксирована", String(Game.meta.get("last_bonus_date", "")) == Time.get_date_string_from_system())
    check("повторный бонус блокируется", Game.claim_daily_bonus().is_empty() and not Game.can_claim_bonus())

    # --- отложенный бонус переносится при новой игре ---
    Game.meta["pending_gold"] = 77
    Game.meta["pending_items"] = ["abyss_cloak"]
    Saves.wipe_all_slots()
    Game.meta["last_slot"] = 0
    Game.current_slot = 0
    Game.new_run(2, "warrior")
    check("новая игра: отложенное золото выдано", \
        Game.gold == Game.hero_start_gold("warrior") + 77)
    check("новая игра: отложенный предмет выдан", Game.inventory.size() == 1 \
        and String((Game.inventory[0] as Dictionary).get("item_id", "")) == "abyss_cloak")
    check("новая игра: отложенное обнулено", int(Game.meta.get("pending_gold", -1)) == 0 \
        and (Game.meta.get("pending_items", []) as Array).is_empty())

    # --- сброс прогресса ---
    Game.reset_progress()
    check("reset_progress чистит всё", Game.gold == 0 and Game.inventory.is_empty() \
        and Game.dungeons_cleared.is_empty() and Game.current_slot == 0 \
        and int(Game.meta.get("last_slot", -1)) == 0 and not Platform.has_slot(2))
    check("reset хранит дату бонуса", String(Game.meta.get("last_bonus_date", "")) == Time.get_date_string_from_system())

    # --- сцены ---
    for scene_path in [
        "res://scenes/main/main.tscn",
        "res://scenes/character_select/character_select.tscn",
        "res://scenes/world/world.tscn",
    ]:
        var packed: PackedScene = load(scene_path)
        check("%s грузится" % scene_path.get_file(), packed != null)
        if packed != null:
            var inst: Node = packed.instantiate()
            check("%s инстанцируется" % scene_path.get_file(), inst != null)
            if scene_path.ends_with("world.tscn"):
                await get_tree().process_frame
            inst.free()

    # --- лут ---
    var counts := {}
    for quality in Loot.QUALITIES:
        counts[quality["id"]] = 0
    for _i in ROLLS:
        counts[Loot.roll_quality()["id"]] += 1
    print("  распределение качества (ожидание 70/20/7/3):")
    for quality in Loot.QUALITIES:
        var share := float(counts[quality["id"]]) / float(ROLLS) * 100.0
        check("%s: %.1f%%" % [quality["id"], share], absf(share - float(quality["weight"])) < 1.5)

    # Возвращаем исходное состояние, чтобы тест не портил сейвы.
    restore()

    if failed == 0:
        print("SMOKE: ВСЁ ОК")
        get_tree().quit(0)
    else:
        print("SMOKE: ПРОВАЛОВ: ", failed)
        get_tree().quit(1)

## База предметов «Dungeon Loot».
## Цены и эффекты, подтверждённые гейм-дизайном:
##   окорок 10 з. (+50 хп), пиво (+100 хп, -50 к попаданию на 2 хода),
##   меч 1000 з. (30 урона), большой меч 2000 з. (50 урона),
##   моргенштерн 5000 з. (100 урона).
## Напитки Глота (шаг 6): ряд растёт по цене И по лечению —
##   вода 5 з. (+20 хп) < морс 10 з. (+40 хп) < сок 15 з. (+60 хп) < пиво 25 з. (+100 хп).
## Магическое оружие Зорана (шаг 6): жезл 1200 з. (35), клинок инея 2500 з. (55),
##   скипетр кометы 6000 з. (110).
## Зелья Злуса (шаг 7): три размера, цена и эффект растут вместе с размером.
##   Лечение: малое 25 з. (+40 хп) < среднее 50 з. (+80) < большое 100 з. (+160).
##   Мана: малое 30 з. (+30) < среднее 60 з. (+60) < большое 120 з. (+120).
##   Мана-зелья пригодны только магу (проверяет Game.use_consumable).
## Шаг 12 (экипировка): новые типы "armor" (броня: +hp_bonus к максимуму ХП,
## носят все) и "robe" (магические одеяния: +mana_bonus к максимуму маны
## и немного +hp_bonus; надевает только маг). У оружия с ключом "magic": true
## есть "volley" — параметры магического залпа мага на Q (см. Game.spell_info).
## Значения с пометкой ЗАГЛУШКА — временные, уточняются с автором проекта.
## icon — иконка для инвентаря, desc — короткое описание (тултип в сумке).
## Торговля (шаг 5): price — цена покупки у NPC, sell_price — половина цены
## (см. SELL_FACTOR). Предметы с price < 0 (фиолетовые уники) не продаются.
class_name ItemDB
extends RefCounted

const ICON_DIR := "res://assets/sprites/icons/"
## Доля цены покупки, за которую NPC готовы выкупить предмет у героя.
const SELL_FACTOR := 0.5

const ITEMS: Dictionary = {
    "ham": {
        "title": "Окорок", "type": "food",
        "price": 10, "heal": 50,
        "desc": "Восстанавливает 50 HP. Рецепт Гуры — пальчики оближешь.",
    },
    "water": {
        "title": "Вода", "type": "drink",
        "price": 5, "heal": 20,
        "desc": "Восстанавливает 20 HP. Ключница космоса, чистая и бодрая.",
    },
    "mors": {
        "title": "Морс", "type": "drink",
        "price": 10, "heal": 40,
        "desc": "Восстанавливает 40 HP. Брусника с поля за оградой мира.",
    },
    "juice": {
        "title": "Сок", "type": "drink",
        "price": 15, "heal": 60,
        "desc": "Восстанавливает 60 HP. Солнечный апельсин из оранжереи замка.",
    },
    "beer": {
        "title": "Пиво", "type": "drink",
        "price": 25,
        "heal": 100,
        "debuff": {"hit_chance": -50, "turns": 2},
        "desc": "Восстанавливает 100 HP, но -50 к попаданию на 2 хода.",
    },
    "sword": {
        "title": "Меч", "type": "weapon",
        "price": 1000, "damage": 30,
        "desc": "30 урона. Надёжный клинок для первых данжей.",
    },
    "greatsword": {
        "title": "Большой меч", "type": "weapon",
        "price": 2000, "damage": 50,
        "desc": "50 урона. Двуручный, рубит с плеча.",
    },
    "morgenstern": {
        "title": "Моргенштерн", "type": "weapon",
        "price": 5000, "damage": 100,
        "desc": "100 урона. Спорах не увернёшься.",
    },
    # --- магическое оружие Зорана (шаг 6; шаг 12 — флаг magic и залп для мага);
    # цены и параметры залпов — ЗАГЛУШКИ ---
    "wand_lightning": {
        "title": "Жезл молний", "type": "weapon", "magic": true,
        "price": 1200, "damage": 35,
        "volley": {
            "title": "Залп молний", "count": 3, "spread_deg": 14.0,
            "damage": 10, "mana": 15, "speed": 300.0, "range_px": 170.0,
            "cooldown": 0.45, "color": [1.0, 0.88, 0.4], "size": 1.0,
        },
        "desc": "35 урона. Бьёт искрой туда, куда смотрит хозяин. Залп молний на Q (у мага).",
    },
    "blade_frost": {
        "title": "Клинок инея", "type": "weapon", "magic": true,
        "price": 2500, "damage": 55,
        "volley": {
            "title": "Залп инея", "count": 3, "spread_deg": 12.0,
            "damage": 12, "mana": 16, "speed": 260.0, "range_px": 160.0,
            "cooldown": 0.5, "color": [0.62, 0.86, 1.0], "size": 1.0,
        },
        "desc": "55 урона. Лезвие всегда холодное, раны не греются. Залп инея на Q (у мага).",
    },
    "scepter_comet": {
        "title": "Скипетр кометы", "type": "weapon", "magic": true,
        "price": 6000, "damage": 110,
        "volley": {
            "title": "Кометный залп", "count": 1, "spread_deg": 0.0,
            "damage": 40, "mana": 25, "speed": 220.0, "range_px": 210.0,
            "cooldown": 0.6, "color": [0.78, 0.6, 1.0], "size": 1.8,
        },
        "desc": "110 урона. Осколок хвоста кометы на золотом древке. Кометный залп на Q (у мага).",
    },
    # --- броня Вираса (шаг 12): +hp_bonus к максимуму ХП, носит любой герой;
    # цены и бонусы — ЗАГЛУШКИ ---
    "armor_leather": {
        "title": "Кожаный доспех", "type": "armor",
        "price": 40, "hp_bonus": 10,
        "desc": "+10 к максимуму ХП. Пахнет гарью, но держит удар.",
    },
    "armor_chain": {
        "title": "Кольчуга", "type": "armor",
        "price": 90, "hp_bonus": 20,
        "desc": "+20 к максимуму ХП. Кольца звенят шёпотом мёртвых кузнецов.",
    },
    "armor_plate": {
        "title": "Латный доспех", "type": "armor",
        "price": 180, "hp_bonus": 35,
        "desc": "+35 к максимуму ХП. Внутри холодно, будто тебя уже схоронили.",
    },
    # --- магические одеяния Зорана (шаг 12): +мана и немного ХП, только магу;
    # цены и бонусы — ЗАГЛУШКИ ---
    "robe_faded": {
        "title": "Выцветшая мантия", "type": "robe",
        "price": 35, "mana_bonus": 10, "hp_bonus": 3,
        "desc": "+10 к максимуму маны, +3 к ХП. Ткань помнит чужие сны. Только для Мага.",
    },
    "robe_stars": {
        "title": "Мантия звёздочёта", "type": "robe",
        "price": 90, "mana_bonus": 20, "hp_bonus": 6,
        "desc": "+20 к максимуму маны, +6 к ХП. Созвездия на подоле не совпадают с картами. Только для Мага.",
    },
    "robe_void": {
        "title": "Одеяние Пустоты", "type": "robe",
        "price": 170, "mana_bonus": 35, "hp_bonus": 10,
        "desc": "+35 к максимуму маны, +10 к ХП. Сшито из куска самой Пустоты. Только для Мага.",
    },
    # --- зелья Злуса (шаг 7): три размера, цена и эффект растут с размером ---
    "hp_potion_small": {
        "title": "Малое зелье лечения", "type": "potion",
        "price": 25, "heal": 40,
        "desc": "Восстанавливает 40 HP. Маленький флакон варки Злуса.",
    },
    "hp_potion": {
        "title": "Зелье лечения", "type": "potion",
        "price": 50, "heal": 80,
        "desc": "Восстанавливает 80 HP. Средний размер — классика Злуса.",
    },
    "hp_potion_large": {
        "title": "Большое зелье лечения", "type": "potion",
        "price": 100, "heal": 160,
        "desc": "Восстанавливает 160 HP. Большой флакон, хватит на весь данж.",
    },
    "mana_potion_small": {
        "title": "Малое зелье маны", "type": "potion",
        "price": 30, "mana": 30,
        "desc": "Восстанавливает 30 маны. Только для мага.",
    },
    "mana_potion": {
        "title": "Зелье маны", "type": "potion",
        "price": 60, "mana": 60,
        "desc": "Восстанавливает 60 маны. Почти полная фляга силы, только для мага.",
    },
    "mana_potion_large": {
        "title": "Большое зелье маны", "type": "potion",
        "price": 120, "mana": 120,
        "desc": "Восстанавливает 120 маны. Запас на целую битву, только для мага.",
    },
    # --- фиолетовые уники для ежедневного бонуса (ЗАГЛУШКИ, составим позже);
    # шаг 12: у уников появились бонусы и залп — как у обычной экипировки ---
    "star_blade": {
        "title": "Звёздный клинок", "type": "weapon", "violet": true, "magic": true,
        "price": -1, "damage": 120,
        "volley": {
            "title": "Звёздный залп", "count": 5, "spread_deg": 20.0,
            "damage": 14, "mana": 22, "speed": 320.0, "range_px": 200.0,
            "cooldown": 0.55, "color": [1.0, 0.95, 0.62], "size": 1.0,
        },
        "desc": "120 урона. Выкован из осколка кометы. Звёздный залп на Q (у мага).",
    },
    "abyss_cloak": {
        "title": "Плащ бездны", "type": "armor", "violet": true,
        "price": -1, "hp_bonus": 25, "mana_bonus": 15,
        "desc": "+25 к максимуму ХП, +15 к максимуму маны. Плащ, сшитый из самой тьмы космоса.",
    },
    "comet_elixir": {
        "title": "Эликсир кометы", "type": "potion", "violet": true,
        "price": -1, "heal": 200,
        "desc": "Восстанавливает 200 HP. Светится, как хвост кометы.",
    },
}

## Типы предметов, которые герой может использовать из сумки (шаг 6):
## еда/питьё/зелье восстанавливают HP (см. heal).
const USABLE_TYPES: Array[String] = ["food", "drink", "potion"]

## Типы экипировки (шаг 12): weapon — в руки (игрок любого класса),
## armor — на тело (+ХП), robe — одеяние мага (+мана и немного ХП).
const EQUIP_TYPES: Array[String] = ["weapon", "armor", "robe"]

## Фиолетовая добыча (самая редкая, выпадает из ежедневного бонуса).
const VIOLET_UNIQUES: Array[String] = ["star_blade", "abyss_cloak", "comet_elixir"]

static func get_item(id: String) -> Dictionary:
    return ITEMS.get(id, {})

static func title(id: String) -> String:
    return String(ITEMS.get(id, {}).get("title", id))

## Цена покупки у торговца. Отрицательная — предмет не продаётся (уник).
static func price(id: String) -> int:
    return int(ITEMS.get(id, {}).get("price", -1))

## Цена продажи торговцу: половина цены покупки, минимум 1 золото.
## Возвращает 0, если предмет продать нельзя (уники и безымянная добыча).
static func sell_price(id: String) -> int:
    var base := price(id)
    if base <= 0:
        return 0
    return maxi(1, int(floor(float(base) * SELL_FACTOR)))

static func desc(id: String) -> String:
    return String(ITEMS.get(id, {}).get("desc", ""))

## Урон предмета (у оружия). 0 — предмет не является оружием или не бьёт.
static func damage(id: String) -> int:
    return int(ITEMS.get(id, {}).get("damage", 0))

## Сколько маны восстанавливает предмет (у мана-зелий). 0 — ману не даёт.
static func mana_restored(id: String) -> int:
    return int(ITEMS.get(id, {}).get("mana", 0))

## Бонус к максимуму ХП (у брони и одеяний, шаг 12). 0 — бонуса нет.
static func hp_bonus(id: String) -> int:
    return int(ITEMS.get(id, {}).get("hp_bonus", 0))

## Бонус к максимуму маны (у одеяний и уникального плаща, шаг 12).
static func mana_bonus(id: String) -> int:
    return int(ITEMS.get(id, {}).get("mana_bonus", 0))

## Магическое ли оружие (шаг 12): варвару такое не достаётся,
## маг бьёт им в полную силу и получает залп на Q,
## остальные герои получают небольшой магический эффект (см. Game).
static func is_magic(id: String) -> bool:
    return bool(ITEMS.get(id, {}).get("magic", false))

## Параметры магического залпа оружия (у магического оружия).
## Пустой словарь — залпа нет (обычная сталь).
static func volley(id: String) -> Dictionary:
    var v: Variant = ITEMS.get(id, {}).get("volley", {})
    return v if v is Dictionary else {}

## Путь к иконке предмета (пустая строка — рисуем мешочек цвета качества).
static func icon(id: String) -> String:
    if ITEMS.has(id):
        return ICON_DIR + id + ".png"
    return ""

static func random_violet_unique() -> String:
    return VIOLET_UNIQUES[randi() % VIOLET_UNIQUES.size()]

## Лут: качество добычи и таблицы предметов для данжей (шаг 14 — сундуки).
class_name Loot
extends RefCounted

## Шансы качества (вес из 100): серая — частая и слабая,
## фиолетовая — самая редкая и самая сильная.
const QUALITIES: Array[Dictionary] = [
    {"id": "gray", "title": "Серая", "hex": "#9aa0a6", "weight": 70},
    {"id": "green", "title": "Зелёная", "hex": "#4caf50", "weight": 20},
    {"id": "gold", "title": "Золотая", "hex": "#ffd700", "weight": 7},
    {"id": "violet", "title": "Фиолетовая", "hex": "#b388ff", "weight": 3},
]

## Случайный бросок качества по весам.
static func roll_quality() -> Dictionary:
    var total := 0
    for quality in QUALITIES:
        total += int(quality["weight"])
    var roll := randi_range(1, total)
    for quality in QUALITIES:
        roll -= int(quality["weight"])
        if roll <= 0:
            return quality
    return QUALITIES[0]

# --------------------------------------------- сундуки подземелий (шаг 14)

## Категории добычи из сундука и их веса (из 100). Все числа — ЗАГЛУШКИ:
## состав и шансы утверждает автор. Золото — чаще всего, питьё и зелья —
## на подъём, экипировка — реже, одеяния (только магу) — реже прочего.
const CHEST_TABLES: Array[Dictionary] = [
    {"id": "gold", "weight": 30},
    {"id": "potion", "weight": 22},
    {"id": "drink", "weight": 14},
    {"id": "weapon", "weight": 14},
    {"id": "armor", "weight": 12},
    {"id": "robe", "weight": 8},
]

## Качество экипировки из сундуков: сундуки щедрее обычных падений
## (серое 40, зелёное 30, золотое 20, фиолетовое 10 — ЗАГЛУШКИ).
const CHEST_QUALITY_TABLES: Array[Dictionary] = [
    {"id": "gray", "weight": 40},
    {"id": "green", "weight": 30},
    {"id": "gold", "weight": 20},
    {"id": "violet", "weight": 10},
]

## Пулы предметов по глубине этажа (1–3 «early», 4–7 «mid», 8–10 «late»).
## Оружие: обычная сталь и магическое — у мага залп на Q. Зелья: у «late»
## изредка попадается фиолетовый эликсир кометы. Все составы — ЗАГЛУШКИ.
const CHEST_POOLS: Dictionary = {
    "weapon": {
        "early": ["sword", "wand_lightning"],
        "mid": ["wand_lightning", "greatsword", "blade_frost"],
        "late": ["greatsword", "blade_frost", "scepter_comet", "morgenstern"],
    },
    "armor": {
        "early": ["armor_leather"],
        "mid": ["armor_leather", "armor_chain"],
        "late": ["armor_chain", "armor_plate"],
    },
    "robe": {
        "early": ["robe_faded"],
        "mid": ["robe_faded", "robe_stars"],
        "late": ["robe_stars", "robe_void"],
    },
    "potion": {
        "early": ["hp_potion_small", "mana_potion_small"],
        "mid": ["hp_potion", "mana_potion"],
        "late": ["hp_potion_large", "mana_potion_large", "comet_elixir"],
    },
    "drink": {
        "early": ["water", "mors", "ham"],
        "mid": ["mors", "juice", "beer", "ham"],
        "late": ["juice", "beer", "ham"],
    },
}

## Золото из сундука: база растёт с глубиной этажа (ЗАГЛУШКА).
static func chest_gold(floor_num: int) -> int:
    return 8 + floor_num * 4 + randi_range(0, 12)

## Добыча из сундука (шаг 14). Возвращает {"gold": int} либо
## {"item_id": String, "quality": String}. Сундук всегда не пуст.
static func chest_loot(floor_num: int) -> Dictionary:
    var category := String(_weighted_pick(CHEST_TABLES).get("id", "gold"))
    var pools: Dictionary = CHEST_POOLS.get(category, {})
    if pools.is_empty():
        return {"gold": chest_gold(floor_num)}
    var item_id := _pick_id(_tier_pool(pools, floor_num))
    if item_id.is_empty():   # пустой пул — сундук отступает к золоту
        return {"gold": chest_gold(floor_num)}
    var quality := "gray"
    if category == "weapon" or category == "armor" or category == "robe":
        quality = String(_weighted_pick(CHEST_QUALITY_TABLES).get("id", "gray"))
    return {"item_id": item_id, "quality": quality}

## Пул «early» / «mid» / «late» для этажа: 1–3 — ранний, 4–7 — средний,
## 8–10 — поздний.
static func _tier_pool(pools: Dictionary, floor_num: int) -> Array:
    var key := "early"
    if floor_num >= 8:
        key = "late"
    elif floor_num >= 4:
        key = "mid"
    return pools.get(key, pools.get("early", []))

## Случайный id из пула строк: пулы CHEST_POOLS — простые массивы id
## ("sword", "armor_chain", ...) без весов, поэтому _weighted_pick им не подходит.
static func _pick_id(pool: Array) -> String:
    if pool.is_empty():
        return ""
    return String(pool[randi() % pool.size()])

## Взвешенный выбор строки таблицы ({"id": ..., "weight": ...}).
static func _weighted_pick(table: Array) -> Dictionary:
    var total := 0
    for row in table:
        total += int((row as Dictionary).get("weight", 0))
    var roll := randi_range(1, maxi(1, total))
    for row in table:
        roll -= int((row as Dictionary).get("weight", 0))
        if roll <= 0:
            return row
    return table[0]

## ------------------------------------------------ эпическое оружие босса

## Награда за босса данжа (шаг 14): случайное оружие из сильного пула
## золотого («эпического») качества. Обычный «Меч» в пул не входит:
## эпическая добыча обязана быть сильнее стартовой. Состав пула — ЗАГЛУШКА.
const EPIC_QUALITY := "gold"
const EPIC_WEAPONS: Array[String] = [
    "greatsword", "morgenstern", "wand_lightning", "blade_frost",
    "scepter_comet",
]

## Эпическая награда босса: {"item_id": ..., "quality": "gold"}.
static func epic_weapon_loot() -> Dictionary:
    return {"item_id": EPIC_WEAPONS[randi() % EPIC_WEAPONS.size()],
        "quality": EPIC_QUALITY}

## Лут: качество добычи и таблицы предметов для данжей (шаг 14 — сундуки).
## Шаг 19: оружий вдвое больше — новые клинки в пулы сундуков по глубине
## и в эпический пул босса (боёк молота, сфера бездны, лунный чакрам).
## Шаг 22: экипировки ВТРОЕ больше — вся новая сталь/магия/броня/одеяния
## разложены по пулам глубины, эпический пул пополнен, у врагов изредка
## падает оружие или броня (foe_gear_drop).
## Шаг 33: дроп подстраивается под героя — чаще падает то, что герой
## реально наденет: колдунам — тёмное оружие, магу — посохи и жезлы,
## варвару — простая сталь, не-магам — не падают одеяния.
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

## Категории добычи из сундука и их веса (из 100). Числа подтверждены
## (шаг 25). Золото — чаще всего, питьё и зелья — на подъём,
## экипировка — реже, одеяния (только магу) — реже прочего.
const CHEST_TABLES: Array[Dictionary] = [
    {"id": "gold", "weight": 30},
    {"id": "potion", "weight": 22},
    {"id": "drink", "weight": 14},
    {"id": "weapon", "weight": 14},
    {"id": "armor", "weight": 12},
    {"id": "robe", "weight": 8},
]

## Качество экипировки из сундуков: сундуки щедрее обычных падений
## (серое 40, зелёное 30, золотое 20, фиолетовое 10 — подтверждено, шаг 25).
const CHEST_QUALITY_TABLES: Array[Dictionary] = [
    {"id": "gray", "weight": 40},
    {"id": "green", "weight": 30},
    {"id": "gold", "weight": 20},
    {"id": "violet", "weight": 10},
]

## Пулы предметов по глубине этажа (шаг 15 — четыре этажа:
## 1 «early», 2–3 «mid», 4 «late»). Оружие: обычная сталь и магическое —
## у мага залп на Q. Зелья: у «late» изредка попадается фиолетовый
## эликсир кометы. Составы подтверждены (шаг 25).
## Шаг 22: пулы втрое богаче — вся новая экипировка падает из сундуков.
const CHEST_POOLS: Dictionary = {
    "weapon": {
        # шаг 32: в пулы добавлено тёмное оружие колдунов (hero_class):
        # носить его сможет только Демоноолог и Некромант — остальным героям
        # находка продаётся торговцу.
        "early": ["rusty_dagger", "sword", "wand_lightning", "bone_chopper",
            "guard_spear", "spark_wand", "bone_needle", "shroud_pin",
            "bone_wand"],
        "mid": ["wand_lightning", "greatsword", "blade_frost", "axe_war",
            "staff_embers", "great_axe", "broadsword", "storm_eye",
            "frost_needles", "flame_rod", "glaive", "rat_crown",
            "hex_mirror", "skull_whispers", "coffin_nail", "ghoul_fang",
            "spine_whip", "wax_doll", "doom_staff", "ember_sigil"],
        "late": ["greatsword", "blade_frost", "scepter_comet", "morgenstern",
            "warhammer", "orb_abyss", "chakram_moon", "flail", "claymore",
            "espadon", "guisarme", "marsh_orb", "flame_blade",
            "thunder_scepter", "mist_crystal", "executioner_axe",
            "licth_jar", "blood_chalice", "grave_scythe", "ash_censer",
            "crypt_lantern", "marrow_flute", "gall_pearl", "blind_idol",
            "grave_bell", "abyss_hook", "horn_baal", "brimstone_flask",
            "pact_quill", "chained_heart"],
    },
    "armor": {
        "early": ["armor_leather", "quilted_jacket"],
        "mid": ["armor_leather", "armor_chain", "leather_cuirass",
            "scale_armor"],
        "late": ["armor_chain", "armor_plate", "brigandine", "bachterez",
            "dragon_scale"],
    },
    "robe": {
        "early": ["robe_faded", "robe_apprentice"],
        "mid": ["robe_faded", "robe_stars", "robe_runes", "robe_mist"],
        "late": ["robe_stars", "robe_void", "robe_lunar", "robe_comet",
            "robe_dawn"],
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

## Золото из сундука: база растёт с глубиной этажа (шаг 25: щедрее —
## сундук обязан ощущаться находкой, а не мелочью из подола).
static func chest_gold(floor_num: int) -> int:
    return 14 + floor_num * 8 + randi_range(0, 16)

# ----------------------------------- дроп под героя (шаг 33)

## Тёмное оружие колдунов — их «родная» тема (носируют только они).
const DARK_CASTERS: Array[String] = ["demonologist", "necromancer"]

## Шанс (в %) выбрать из «родного» пула героя, если он не пуст:
## чуть чаще половины — подгон заметен, но находки не однообразны.
const HERO_BIAS_PERCENT := 55

## Тёмное ли оружие (ключ hero_class непуст).
static func _is_dark(id: String) -> bool:
    var allowed: Variant = ItemDB.get_item(id).get("hero_class", [])
    return allowed is Array and not (allowed as Array).is_empty()

## Можно ли герому hero_id ВООБЩЕ надеть оружие id (шаг 33).
static func _weapon_suits(id: String, hero_id: String) -> bool:
    if hero_id.is_empty():
        return true
    if _is_dark(id):
        return hero_id in DARK_CASTERS
    if ItemDB.is_magic(id) and hero_id == "barbarian":
        return false   # варвару чужая воля в металле жжёт руки
    return true

## «Родное» ли оружие для героя — то, что хочется ему видеть в руках.
static func _weapon_native(id: String, hero_id: String) -> bool:
    if not _weapon_suits(id, hero_id):
        return false
    match hero_id:
        "demonologist", "necromancer":
            return _is_dark(id)          # колдуны — тёмное оружие
        "mage":
            return ItemDB.is_magic(id)   # маг — посохи и жезлы
        "barbarian":
            return not ItemDB.is_magic(id)
        _:
            return true   # воину/бомжу годится вся носимая сталь

## Пул оружия со смещением к «родному» (шаг 33): с шансом HERO_BIAS_PERCENT
## выбираем из «родного» подмножества, иначе — из всего НОСИМОГО героем.
## Неподходящее оружие (тёмное не-колдуну, магическое варвару) не падает вовсе:
## находка не должна мёртвым грузом оседать в сумке.
static func _biased_weapon_pool(pool: Array, hero_id: String) -> Array:
    if hero_id.is_empty():
        return pool
    var native: Array = []
    var suited: Array = []
    for id in pool:
        var sid := String(id)
        if _weapon_native(sid, hero_id):
            native.append(id)
        if _weapon_suits(sid, hero_id):
            suited.append(id)
    if suited.is_empty():
        return pool   # пул совсем не подходит герою — отдаём как есть
    if not native.is_empty() and randi() % 100 < HERO_BIAS_PERCENT:
        return native
    return suited

## Таблица категорий сундука под героя: не-магам одеяния не падают
## (они их всё равно не наденут), вместо них чуть чаще золото/оружие.
static func _chest_table(caster: bool) -> Array[Dictionary]:
    if caster:
        return CHEST_TABLES
    var table: Array[Dictionary] = []
    for row in CHEST_TABLES:
        if String(row["id"]) != "robe":
            table.append(row)
    return table

## Добыча из сундука (шаг 14; шаг 33 — дроп под героя). Возвращает
## {"gold": int} либо {"item_id": String, "quality": String}. Сундук всегда не пуст.
## hero_id пуст — старое поведение без смещения (тесты детерминизма).
static func chest_loot(floor_num: int, hero_id: String = "", caster: bool = false) -> Dictionary:
    # hero_id пуст (старые вызовы тестов) — таблица без изменений
    var category := String(_weighted_pick(
        _chest_table(caster or hero_id.is_empty())).get("id", "gold"))
    var pools: Dictionary = CHEST_POOLS.get(category, {})
    if pools.is_empty():
        return {"gold": chest_gold(floor_num)}
    var pool := _tier_pool(pools, floor_num)
    if category == "weapon":
        pool = _biased_weapon_pool(pool, hero_id)
    var item_id := _pick_id(pool)
    if item_id.is_empty():   # пустой пул — сундук отступает к золоту
        return {"gold": chest_gold(floor_num)}
    var quality := "gray"
    if category == "weapon" or category == "armor" or category == "robe":
        quality = String(_weighted_pick(CHEST_QUALITY_TABLES).get("id", "gray"))
    return {"item_id": item_id, "quality": quality}

## Пул «early» / «mid» / «late» для этажа: 1 — ранний, 2–3 — средний,
## 4 (этаж босса) — поздний.
static func _tier_pool(pools: Dictionary, floor_num: int) -> Array:
    var key := "early"
    if floor_num >= 4:
        key = "late"
    elif floor_num >= 2:
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
## эпическая добыча обязана быть сильнее стартовой. Пул подтверждён (шаг 25).
const EPIC_QUALITY := "gold"
const EPIC_WEAPONS: Array[String] = [
    "greatsword", "morgenstern", "wand_lightning", "blade_frost",
    "scepter_comet", "warhammer", "orb_abyss", "chakram_moon",
    "espadon", "guisarme", "executioner_axe", "dragon_fang",
    "royal_greatsword", "thunder_scepter", "mist_crystal",
    "starfall_staff", "sun_scepter", "polaris_wand",
    # шаг 32: тёмное оружие колдунов тоже бывает эпической наградой босса
    "grave_scythe", "grave_bell", "pact_quill", "chained_heart",
]

## Эпическая награда босса: {"item_id": ..., "quality": "gold"}.
## Шаг 33: босс отдаёт то, что герой наденет; «родному» оружию — приоритет.
static func epic_weapon_loot(hero_id: String = "") -> Dictionary:
    var suited: Array = []
    var native: Array = []
    for id in EPIC_WEAPONS:
        if _weapon_suits(id, hero_id):
            suited.append(id)
        if _weapon_native(id, hero_id):
            native.append(id)
    var pool := suited if not suited.is_empty() else EPIC_WEAPONS
    var chosen: Array = native if (not native.is_empty()
        and randi() % 100 < HERO_BIAS_PERCENT) else pool
    return {"item_id": String(chosen[randi() % chosen.size()]),
        "quality": EPIC_QUALITY}

# --------------------------------------------- добыча с врагов (шаг 22)

## Шанс (в процентах), что враг уронит экипировку: оружие или броню.
const FOE_GEAR_CHANCE := 12

## Качество дропа с врагов: скромнее сундуков — серое чаще,
## золотое — большая редкость.
const FOE_GEAR_QUALITY: Array[Dictionary] = [
    {"id": "gray", "weight": 60},
    {"id": "green", "weight": 30},
    {"id": "gold", "weight": 10},
]

## Дроп экипировки с врага (шаг 22; шаг 33 — смещение под героя):
## случайное оружие или броня из пула глубины этажа, качество — по
## FOE_GEAR_QUALITY. Пустой пул — отступаем к золоту.
static func foe_gear_drop(floor_num: int, hero_id: String = "") -> Dictionary:
    var category := "weapon" if randi() % 100 < 60 else "armor"
    var pools: Dictionary = CHEST_POOLS.get(category, {})
    var pool := _tier_pool(pools, floor_num)
    if category == "weapon":
        pool = _biased_weapon_pool(pool, hero_id)
    var item_id := _pick_id(pool)
    if item_id.is_empty():
        return {"gold": chest_gold(floor_num)}
    var quality := String(_weighted_pick(FOE_GEAR_QUALITY).get("id", "gray"))
    return {"item_id": item_id, "quality": quality}

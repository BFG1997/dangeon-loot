## Автозагрузка Game: герой, золото, здоровье/мана, инвентарь (добыча),
## прогресс по данжам и заклинания мага.
## Прогресс хранится в 3 слотах сейва; настройки и ежедневный бонус —
## глобально в meta.json (общие для всех слотов).
## Все изменения дергают сигналы и просят Saves сохранить состояние.
## Торговля (шаг 5): у каждого героя своё стартовое золото,
## buy_item()/sell_item() — покупка у NPC и продажа своих вещей.
## Шаг 6: новый герой Маг (хп 30, мана 70), использование еды/питья/зелий
## и «Магическая стрела» — заклинание за ману (визуал в world.gd).
## Шаг 7 (боевая система): оружие в руках (equipped_weapon_id) — удар E
## идёт оружием, без него — рукой (кулаки, у всех героев, маг тоже);
## мана-зелья лечат ману только магу; список убитых NPC (dead_npcs)
## живёт только в текущей сессии: в сейв не пишется, при новой игре
## и загрузке слота обнуляется — мёртвые NPC не воскресают в этой сессии,
## а остальные NPC помнят убийство (реплики и отказ торговать — в world.gd).
## Шаг 12 (боевая система: экипировка и ярость демона):
## - второй слот экипировки — броня/одеяние (equipped_armor_id): броня даёт
##   +hp_bonus к максимуму ХП (носят все), одеяния — +мана и немного ХП
##   (только маг); max_hp()/max_mana() считаются с бонусом экипировки;
## - классовые множители удара обычным оружием: маг х0.5, варвар х2,
##   остальные х1; магическое оружие магу — полная сила и залп на Q
##   (spell_info()), воину/бомжу — обычный урон + магический эффект
##   (+25% урона, strike_is_magic_surge), варвару — отказ (оружие отвергает);
## - демон: после DEMON_RAGE_HITS ударов (3) впадает в ярость
##   (demon_hits/demon_enraged, состояние сессии, в сейв не пишется);
## - сейв v5: добавлен equipped_armor_id (старые сейвы мигрируют: без брони).
## Шаг 13 (данж 1 и вечная смерть демона):
## - ярость демона гаснет при возрождении героя (reset_demon_rage): после
##   «ОЧНУТЬСЯ В ЗАМКЕ» демон снова мирный, счёт ударов обнулён;
## - demon_seen — «мы видели демона» (диалог с ним у края мира, сессия);
## - demon_defeated — демон убит навсегда (на карте или как босс данжа 1):
##   сейв v6, все убитые NPC оживают и забывают убийства, демон больше
##   не возвращается даже после новых убийств (revive_all_npcs);
## - dungeon_floor — текущий этаж данжа (0 = не в данже, только сессия).
extends Node

signal gold_changed(new_gold: int)
signal inventory_changed()
signal hp_changed(hp: int, max_hp: int)
signal mana_changed(mana: int, max_mana: int)
signal equipped_changed(weapon_id: String)
signal armor_changed(armor_id: String)
signal npc_killed(npc_id: String)
signal demon_enraged_changed
signal npcs_revived

const START_GOLD := 0
const SLOT_COUNT := 3
## ЗАГЛУШКА характеристик: точные числа неиграбельных героев уточняются позже.
## sheet — лист 24x32 (6 рядов анимаций), portrait — крупный портрет для диалогов,
## start_gold — стартовый кошелёк героя при новой игре (шаг 5),
## hp/mana — стартовое здоровье и мана (шаг 6; мана есть только у мага).
const HEROES: Dictionary = {
    "warrior": {
        "title": "Воин",
        "flavor": "Сталь, дисциплина и верный меч.",
        "sheet": "res://assets/sprites/chars/warrior.png",
        "portrait": "res://assets/sprites/portraits/warrior.png",
        "start_gold": 100,
        "hp": 50, "mana": 0,
    },
    "barbarian": {
        "title": "Варвар",
        "flavor": "Бьёт первым. Вопросов не задаёт.",
        "sheet": "res://assets/sprites/chars/barbarian.png",
        "portrait": "res://assets/sprites/portraits/barbarian.png",
        "start_gold": 50,
        "hp": 60, "mana": 0,
    },
    "bum": {
        "title": "Бомж",
        "flavor": "Живёт у стен замка. Терять нечего.",
        "sheet": "res://assets/sprites/chars/bum.png",
        "portrait": "res://assets/sprites/portraits/bum.png",
        "start_gold": 1,
        "hp": 20, "mana": 0,
    },
    "mage": {
        "title": "Маг",
        "flavor": "Хрупкий, но повелевает маной. Стреляет стрелами света.",
        "sheet": "res://assets/sprites/chars/mage.png",
        "portrait": "res://assets/sprites/portraits/mage.png",
        "start_gold": 60,   # ЗАГЛУШКА: стартовое золото мага не задано автором
        "hp": 30, "mana": 70,
    },
}
const DEFAULT_HERO := "warrior"

## Урон удара рукой (шаг 7, ЗАГЛУШКА — уточняется с автором).
## Удар без оружия в руках доступен всем героям, включая мага.
const HAND_DAMAGE := 5
## Название удара без оружия (для HUD, сумки и подсказок).
const HAND_TITLE := "Кулаки"

## Шаг 12: множители урона обычного (не магического) оружия по классам.
## Маг клинками машет плохо (х0.5), варвар — сильнее всех (х2; у мага
## относительно варвара выходит в 4 раза слабее). Остальные — х1.
const CLASS_STRIKE_MULT := {
    "mage": 0.5,
    "barbarian": 2.0,
}
## Шаг 12: магический эффект магического оружия у не-магов (воин и бомж):
## удар наносит обычный урон + 25% сверх (вспышка цвета оружия).
## Варвару магическое оружие вообще не даётся, а маг бьёт им в полную силу.
const MAGIC_SURGE_FACTOR := 0.25

## Заклинание мага (шаг 6): «Магическая стрела».
## cost — цена в мане, damage — урон в будущих боях, regen — реген маны в секунду.
const SPELL := {
    "id": "magic_bolt",
    "title": "Магическая стрела",
    "cost": 12,
    "damage": 15,
    "speed": 240.0,
    "range_px": 150.0,
    "cooldown": 0.35,
    "regen_per_sec": 2,
}

var gold: int = START_GOLD
var inventory: Array = []          # [{"quality": "...", "title": "..."} или {"item_id": "..."}]
var dungeons_cleared: Array = []   # id пройденных данжей: ["forest_cave", ...]
var hero_id: String = DEFAULT_HERO
var hp: int = 0                    # текущее здоровье героя (шаг 6)
var mana: int = 0                  # текущая мана героя (шаг 6, у не-магов 0)
## Оружие в руках (шаг 7): item_id из ItemDB или "" — удары идут кулаками.
var equipped_weapon_id: String = ""
## Броня/одеяние на теле (шаг 12): item_id из ItemDB (type "armor" или "robe")
## или "" — ничего не надето. Даёт +ХП (броня) и +мана/+ХП (одеяния мага).
var equipped_armor_id: String = ""
## Убитые NPC (шаг 7): только текущая сессия — в сейв не пишется.
## Остальные NPC помнят убийство (реплики и отказ торговать — в world.gd).
var dead_npcs: Array[String] = []
## Ярость демона (шаг 12, состояние сессии — в сейв не пишется):
## сколько раз герой ударил демона и впал ли он в ярость после 3-го удара.
var demon_hits: int = 0
var demon_enraged: bool = false
## Сколько ударов демон терпит, прежде чем броситься драться (шаг 12).
const DEMON_RAGE_HITS := 3
## Шаг 13: видели ли мы демона (диалог с ним у края мира) — босс данжа 1
## по этому флагу узнаёт героя. Только сессия, в сейв не пишется.
var demon_seen: bool = false
## Шаг 13: демон убит НАВСЕГДА (на карте или как босс данжа 1). Пишется
## в сейв v6: убитые NPC оживают и забывают убийства, демон больше
## не возвращается даже после новых убийств жителей.
var demon_defeated: bool = false
## Шаг 13: текущий этаж данжа 1 (1..10), 0 — герой не в подземелье.
## Только сессия: в сейв не пишется, при выходе/смерти обнуляется.
var dungeon_floor: int = 0
## Текущий слот сейва: 0 — игра не идёт (просто смотрим меню).
var current_slot: int = 0
## Глобальные настройки игрока (хранятся в meta.json).
var settings := {"sound": true, "music": true}
## Глобальная meta: последний слот, дата бонуса, отложенные награды бонуса.
var meta := {"last_slot": 0, "last_bonus_date": "", "pending_gold": 0, "pending_items": []}

func _ready() -> void:
    randomize()
    meta = Platform.load_meta()
    var saved_settings: Dictionary = meta.get("settings", {})
    settings["sound"] = bool(saved_settings.get("sound", true))
    settings["music"] = bool(saved_settings.get("music", true))

## Записать глобальную meta на диск.
func save_meta() -> void:
    meta["settings"] = settings.duplicate()
    Platform.save_meta(meta)

func hero_title() -> String:
    return String(HEROES.get(hero_id, {}).get("title", hero_id))

## Стартовый кошелёк героя при новой игре (Воин 100, Варвар 50, Бомж 1, Маг 60).
func hero_start_gold(hero: String) -> int:
    return int(HEROES.get(hero, {}).get("start_gold", START_GOLD))

## Максимум здоровья/маны героя (Маг: 30 хп и 70 маны — задал автор).
## Шаг 12: максимум растёт от экипировки — броня даёт +hp_bonus,
## одеяния/плащ дают +mana_bonus (и немного +hp_bonus).
func hero_max_hp(hero: String) -> int:
    return int(HEROES.get(hero, {}).get("hp", 1))

func hero_max_mana(hero: String) -> int:
    return int(HEROES.get(hero, {}).get("mana", 0))

func max_hp() -> int:
    return hero_max_hp(hero_id) + ItemDB.hp_bonus(equipped_armor_id)

func max_mana() -> int:
    return hero_max_mana(hero_id) + ItemDB.mana_bonus(equipped_armor_id)

## Является ли текущий герой магом по природе (у него врождённая мана
## и заклинания). Экипировка потолок маны растит, но магом не делает.
func is_mage() -> bool:
    return hero_max_mana(hero_id) > 0

func add_gold(amount: int) -> void:
    gold = maxi(0, gold + amount)
    gold_changed.emit(gold)
    Saves.request_save()

func spend_gold(amount: int) -> bool:
    if amount > gold:
        return false
    gold -= amount
    gold_changed.emit(gold)
    Saves.request_save()
    return true

# ------------------------------------------------------------- хп и мана (шаг 6)

## Выпить/съесть предмет: лечит хп и/или ману, предмет исчезает из сумки.
## Зелья маны (шаг 7) годятся только магу; остальным героям отказ —
## зелье не тратится (result["blocked"] == "not_mage").
## Возвращает {"ok", "healed", "restored", "full", "blocked"}.
func use_consumable(index: int) -> Dictionary:
    var result := {"ok": false, "healed": 0, "restored": 0, "full": false, "blocked": ""}
    if index < 0 or index >= inventory.size():
        return result
    var item: Dictionary = inventory[index]
    var item_id := String(item.get("item_id", ""))
    var def := ItemDB.get_item(item_id)
    if def.is_empty() or not (String(def.get("type", "")) in ItemDB.USABLE_TYPES):
        return result
    var heal_amount := int(def.get("heal", 0))
    var mana_amount := int(def.get("mana", 0))
    if mana_amount > 0 and not is_mage():
        result["blocked"] = "not_mage"
        return result
    var hp_needed := heal_amount > 0 and hp < max_hp()
    var mana_needed := mana_amount > 0 and mana < max_mana()
    if not hp_needed and not mana_needed:
        result["full"] = true
        return result
    if hp_needed:
        result["healed"] = heal_hp(heal_amount)
    if mana_needed:
        result["restored"] = restore_mana(mana_amount)
    inventory.remove_at(index)
    inventory_changed.emit()
    Saves.request_save()
    result["ok"] = true
    return result

## Лечит героя, возвращает фактически восстановленное хп.
func heal_hp(amount: int) -> int:
    if amount <= 0:
        return 0
    var before := hp
    hp = mini(max_hp(), hp + amount)
    if hp != before:
        hp_changed.emit(hp, max_hp())
        Saves.request_save()
    return hp - before

## Урон по герою (бои появятся позже; сейчас используется тестами).
func damage_hp(amount: int) -> void:
    if amount <= 0:
        return
    hp = maxi(0, hp - amount)
    hp_changed.emit(hp, max_hp())
    Saves.request_save()

## Потратить ману на заклинание. false — маны не хватает.
func spend_mana(amount: int) -> bool:
    if amount > mana:
        return false
    mana -= amount
    mana_changed.emit(mana, max_mana())
    Saves.request_save()
    return true

## Плавный реген маны (вызывает мир раз в секунду).
func regen_mana(amount: int) -> void:
    if max_mana() <= 0 or amount <= 0 or mana >= max_mana():
        return
    mana = mini(max_mana(), mana + amount)
    mana_changed.emit(mana, max_mana())

## Восстанавливает ману (зелья маны, шаг 7), возвращает фактически
## восстановленное количество. Лишнее срезается по максимуму маны героя.
func restore_mana(amount: int) -> int:
    if amount <= 0:
        return 0
    var before := mana
    mana = mini(max_mana(), mana + amount)
    if mana != before:
        mana_changed.emit(mana, max_mana())
        Saves.request_save()
    return mana - before

## Каст заклинания (шаг 6; шаг 12 — цена зависит от оружия в руках):
## списывает ману, если это маг и маны хватает.
func cast_spell() -> bool:
    var info := spell_info()
    if info.is_empty():
        return false
    return spend_mana(int(info["cost"]))

## Что получится на Q прямо сейчас (шаг 12).
## Маг с магическим оружием получает залп этого оружия (volley из ItemDB);
## маг без оружия или с обычной сталью — классическую «Магическую стрелу».
## Не-маг получает пустой словарь.
func spell_info() -> Dictionary:
    if not is_mage():
        return {}
    if has_weapon() and ItemDB.is_magic(equipped_weapon_id):
        var v := ItemDB.volley(equipped_weapon_id)
        if not v.is_empty():
            var info := SPELL.duplicate()
            info["id"] = equipped_weapon_id + "_volley"
            info["title"] = String(v.get("title", "Залп"))
            info["cost"] = int(v.get("mana", SPELL["cost"]))
            info["damage"] = int(v.get("damage", SPELL["damage"]))
            info["speed"] = float(v.get("speed", SPELL["speed"]))
            info["range_px"] = float(v.get("range_px", SPELL["range_px"]))
            info["cooldown"] = float(v.get("cooldown", SPELL["cooldown"]))
            info["count"] = int(v.get("count", 1))
            info["spread_deg"] = float(v.get("spread_deg", 0.0))
            info["color"] = v.get("color", [0.55, 0.85, 0.95])
            info["size"] = float(v.get("size", 1.0))
            info["weapon_id"] = equipped_weapon_id
            return info
    return SPELL.duplicate()

## Подсказка не-магу, нажавшему Q (шаг 12): у каждого класса свой отказ.
func non_mage_spell_hint() -> String:
    if hero_id == "barbarian":
        return "Магия отвергает варвара — залп не выйдет"
    if has_weapon() and ItemDB.is_magic(equipped_weapon_id):
        return "Оружие шепчет на своём языке, но залп тебе неподвластен"
    return "Колдовать умеет только Маг"

# ------------------------------------------------- оружие в руках и удары (шаг 7)

## Взять вещь из сумки в руки (шаг 7; шаг 12 — варвару отказ на магическое).
## Только оружие из ItemDB; если оно уже в руках — ничего.
func equip_weapon(item_id: String) -> bool:
    return bool(try_equip_weapon(item_id).get("ok", false))

## Шаг 12: экипировка оружия с причиной отказа (для сообщений в сумке):
## {"ok": bool, "reason": ""} — reason: not_weapon | already | not_in_bag |
## barbarian_rejected (магическое оружие отвергает варвара).
func try_equip_weapon(item_id: String) -> Dictionary:
    var result := {"ok": false, "reason": ""}
    var def := ItemDB.get_item(item_id)
    if def.is_empty() or String(def.get("type", "")) != "weapon":
        result["reason"] = "not_weapon"
        return result
    if item_id == equipped_weapon_id:
        result["reason"] = "already"
        return result
    if not _has_item(item_id):
        result["reason"] = "not_in_bag"
        return result
    # Варвар может драться только обычным оружием: магическое его отвергает
    # (металл, пропитанный чужой волей, жжёт его руки).
    if hero_id == "barbarian" and ItemDB.is_magic(item_id):
        result["reason"] = "barbarian_rejected"
        return result
    equipped_weapon_id = item_id
    equipped_changed.emit(equipped_weapon_id)
    Saves.request_save()
    result["ok"] = true
    return result

## Убрать оружие из рук — удары снова идут кулаками.
func unequip_weapon() -> void:
    if equipped_weapon_id.is_empty():
        return
    equipped_weapon_id = ""
    equipped_changed.emit("")
    Saves.request_save()

## Есть ли у героя оружие в руках (иначе удары рукой).
func has_weapon() -> bool:
    return not equipped_weapon_id.is_empty()

# ----------------------------------------- броня и одеяния (шаг 12)

## Надеть броню/одеяние из сумки. Броню (type "armor") носят все герои —
## она даёт +hp_bonus к максимуму ХП. Одеяния (type "robe") слушаются
## только мага: +mana_bonus к максимуму маны и немного +hp_bonus.
## Возвращает {"ok": bool, "reason": ""}:
## reason: not_armor | robe_not_mage | already | not_in_bag.
func equip_armor(item_id: String) -> Dictionary:
    var result := {"ok": false, "reason": ""}
    var t := String(ItemDB.get_item(item_id).get("type", ""))
    if t != "armor" and t != "robe":
        result["reason"] = "not_armor"
        return result
    if t == "robe" and not is_mage():
        result["reason"] = "robe_not_mage"
        return result
    if item_id == equipped_armor_id:
        result["reason"] = "already"
        return result
    if not _has_item(item_id):
        result["reason"] = "not_in_bag"
        return result
    equipped_armor_id = item_id
    armor_changed.emit(equipped_armor_id)
    # Текущие хп/мана остаются как были: вырос только потолок.
    hp = mini(hp, max_hp())
    mana = mini(mana, max_mana())
    hp_changed.emit(hp, max_hp())
    mana_changed.emit(mana, max_mana())
    Saves.request_save()
    result["ok"] = true
    return result

## Снять броню/одеяние: максимум ХП/маны возвращается к базовому,
## текущие значения срезаются под новый потолок.
func unequip_armor() -> void:
    if equipped_armor_id.is_empty():
        return
    equipped_armor_id = ""
    armor_changed.emit("")
    hp = mini(hp, max_hp())
    mana = mini(mana, max_mana())
    hp_changed.emit(hp, max_hp())
    mana_changed.emit(mana, max_mana())
    Saves.request_save()

## Есть ли на герое броня/одеяние.
func has_armor() -> bool:
    return not equipped_armor_id.is_empty()

## Урон удара: оружием в руках или кулаками (маг тоже бьёт рукой).
## Шаг 12: классы по-разному ладят с обычной сталью (CLASS_STRIKE_MULT):
## маг х0.5, варвар х2. Магическое оружие: маг — полная сила,
## воин/бомж — урон + магический эффект (+MAGIC_SURGE_FACTOR).
func strike_damage() -> int:
    if not has_weapon():
        return HAND_DAMAGE
    var base := ItemDB.damage(equipped_weapon_id)
    if ItemDB.is_magic(equipped_weapon_id):
        if is_mage():
            return base
        return base + maxi(1, int(round(float(base) * MAGIC_SURGE_FACTOR)))
    var mult := float(CLASS_STRIKE_MULT.get(hero_id, 1.0))
    return maxi(1, int(round(float(base) * mult)))

## Шаг 12: магический эффект в действии? (не-маг бьёт магическим оружием:
## урон с прибавкой, вспышка цвета оружия — визуал в world.gd)
func strike_is_magic_surge() -> bool:
    return has_weapon() and ItemDB.is_magic(equipped_weapon_id) and not is_mage()

## Цвет росчерка удара (шаг 12): магическое оружие — свой цвет,
## обычное — золото, кулаки — серый.
func strike_swing_color() -> Color:
    if has_weapon() and ItemDB.is_magic(equipped_weapon_id):
        var c: Array = ItemDB.volley(equipped_weapon_id).get("color", [1.0, 0.9, 0.5])
        return Color(float(c[0]), float(c[1]), float(c[2]))
    if has_weapon():
        return Color(1.0, 0.84, 0.0)
    return Color(0.8, 0.84, 0.95)

## Название того, чем герой бьёт (для HUD и подсказок).
func strike_title() -> String:
    if has_weapon():
        return ItemDB.title(equipped_weapon_id)
    return HAND_TITLE

# ------------------------------------------------------ смерть NPC (шаг 7)

## NPC мёртв? (мёртвые не разговаривают, не торгуют и не получают урон)
func is_npc_dead(npc_id: String) -> bool:
    return npc_id in dead_npcs

## NPC убит ударом героя: помечается на всю сессию. В сейв не пишется:
## при новой игре и загрузке слота мир жив снова, но в текущей сессии
## мёртвые не воскресают, а остальные NPC помнят убийство.
func kill_npc(npc_id: String) -> void:
    if npc_id.is_empty() or npc_id in dead_npcs:
        return
    dead_npcs.append(npc_id)
    npc_killed.emit(npc_id)

# ------------------------------------------------------------- демон (шаг 8)

## Скидка лавки демона: -10% за каждого убитого NPC (сам демон не в счёт).
const DEMON_DISCOUNT_PER_KILL := 10

## Сколько жителей убито: демон сам в подсчёте не участвует.
func demon_kill_count() -> int:
    var count := 0
    for npc_id in dead_npcs:
        if String(npc_id) != "demon":
            count += 1
    return count

## Шаг 12: герой ударил демона. После DEMON_RAGE_HITS ударов демон впадает
## в ярость (сигнал demon_enraged_changed): лавка закрывается, демон
## охотится на героя (ИИ — в world.gd). Возвращает текущий счёт ударов.
func register_demon_hit() -> int:
    demon_hits += 1
    if demon_hits >= DEMON_RAGE_HITS and not demon_enraged:
        demon_enraged = true
        demon_enraged_changed.emit()
    return demon_hits

## Шаг 13: погасить ярость демона — вызывается при возрождении героя
## («ОЧНУТЬСЯ В ЗАМКЕ»): демон снова мирен, счёт ударов обнулён,
## лавка открыта. Сигнал демон-мир получает world.gd (снимает красную ауру).
func reset_demon_rage() -> void:
    if demon_hits == 0 and not demon_enraged:
        return
    demon_hits = 0
    demon_enraged = false
    demon_enraged_changed.emit()

## Шаг 13: герой поговорил с демоном у края мира — «мы видели демона».
## Босс данжа 1 по этому флагу узнаёт героя и говорит об этом.
func mark_demon_seen() -> void:
    demon_seen = true

## Демон уже убит навсегда (больше не появится ни у края мира, ни в данже).
func demon_gone_forever() -> bool:
    return demon_defeated

## Шаг 13: оживить всех убитых NPC и стереть память об убийствах.
## Вызывается, когда демон повержен (на карте или как босс данжа 1):
## жертвы возвращаются в замок и не помнят, что их убивали.
func revive_all_npcs() -> void:
    if dead_npcs.is_empty():
        return
    dead_npcs.clear()
    npcs_revived.emit()

## Шаг 13: демон повержен НАВСЕГДА (на карте или как босс данжа 1):
## убитые NPC оживают и забывают убийства, ярость гаснет, демон больше
## не возвращается — ни у края мира, ни в подземелье (demon_defeated
## пишется в сейв v6).
func defeat_demon_permanently() -> void:
    demon_defeated = true
    demon_seen = false
    demon_hits = 0
    demon_enraged = false
    dead_npcs.clear()
    demon_enraged_changed.emit()
    npcs_revived.emit()
    Saves.request_save()

## Текущая скидка демона в процентах (-10% за убитого NPC, не больше 90%).
func demon_discount_pct() -> int:
    return mini(90, DEMON_DISCOUNT_PER_KILL * demon_kill_count())

## Данные NPC по id из WorldMap.NPCS (пустой словарь — не найден).
func npc_def(npc_id: String) -> Dictionary:
    for npc_data in WorldMap.NPCS:
        if String(npc_data.get("id", "")) == npc_id:
            return npc_data
    return {}

## Ассортимент демона (шаг 8): товары убитых торговцев — в порядке убийств,
## без повторов. Убитый не-торговец (Лира) товаров не приносит.
func demon_goods() -> Array[String]:
    var goods: Array[String] = []
    for npc_id in dead_npcs:
        for item_id in npc_def(String(npc_id)).get("goods", []):
            var id := String(item_id)
            if id not in goods and ItemDB.price(id) > 0:
                goods.append(id)
    return goods

## Цена демона: обычная цена лавки со скидкой, минимум 1 золото.
## Непродажные вещи (price <= 0) остаются непродажными.
func demon_price(item_id: String) -> int:
    var base := ItemDB.price(item_id)
    if base <= 0:
        return base
    var discounted := int(round(float(base) * (100.0 - float(demon_discount_pct())) / 100.0))
    return maxi(1, discounted)

## Купить у демона: как buy_item, но по демонической цене со скидкой
## и только из ассортимента павших торговцев.
func buy_from_demon(item_id: String) -> bool:
    if item_id not in demon_goods():
        return false
    var cost := demon_price(item_id)
    if cost <= 0 or cost > gold:
        return false
    gold -= cost
    add_item({"item_id": item_id, "title": ItemDB.title(item_id),
              "quality": "gray"}, false)
    gold_changed.emit(gold)
    Saves.request_save()
    return true

func add_item(item: Dictionary, do_save: bool = true) -> void:
    inventory.append(item.duplicate())
    inventory_changed.emit()
    if do_save:
        Saves.request_save()

# ------------------------------------------------------------- торговля (шаг 5)

## Купить предмет у торговца: списывает цену из ItemDB, кладёт вещь в сумку.
## Возвращает false, если товара нет в базе, он бесплатный/непродажный
## или не хватает золота.
func buy_item(item_id: String) -> bool:
    var cost := ItemDB.price(item_id)
    if cost <= 0:
        return false
    if not spend_gold(cost):
        return false
    add_item({"item_id": item_id, "title": ItemDB.title(item_id),
              "quality": "gray"}, false)
    Saves.request_save()
    return true

## Продать предмет из сумки торговцу за половину цены (ItemDB.sell_price).
## index — позиция в Game.inventory. Безымянная добыча без item_id и
## фиолетовые уники (price < 0) не продаются. Если продали оружие,
## бывшее в руках — оно снимается (шаг 7); если продали надетую броню —
## она снимается (шаг 12).
func sell_item(index: int) -> bool:
    if index < 0 or index >= inventory.size():
        return false
    var item: Dictionary = inventory[index]
    var item_id := String(item.get("item_id", ""))
    if item_id.is_empty():
        return false
    var earned := ItemDB.sell_price(item_id)
    if earned <= 0:
        return false
    inventory.remove_at(index)
    if equipped_weapon_id == item_id and not _has_item(equipped_weapon_id):
        equipped_weapon_id = ""
        equipped_changed.emit("")
    if equipped_armor_id == item_id and not _has_item(equipped_armor_id):
        unequip_armor()
    inventory_changed.emit()
    add_gold(earned)
    return true

## Есть ли предмет с таким item_id в сумке.
func _has_item(item_id: String) -> bool:
    for item in inventory:
        if String(item.get("item_id", "")) == item_id:
            return true
    return false

func mark_dungeon_cleared(dungeon_id: String) -> void:
    if dungeon_id not in dungeons_cleared:
        dungeons_cleared.append(dungeon_id)
        Saves.request_save()

func set_setting(key: String, value: bool) -> void:
    settings[key] = value
    save_meta()

## Полный сброс: очищает слоты сейвов, прогресс в памяти и meta-указатели.
## Настройки и дата ежедневного бонуса сохраняются (чтобы бонус не «фармили»).
func reset_progress() -> void:
    gold = START_GOLD
    inventory = []
    dungeons_cleared = []
    hero_id = DEFAULT_HERO
    equipped_weapon_id = ""
    equipped_armor_id = ""
    hp = hero_max_hp(hero_id)
    mana = hero_max_mana(hero_id)
    dead_npcs = []
    demon_hits = 0
    demon_enraged = false
    demon_seen = false
    demon_defeated = false
    dungeon_floor = 0
    current_slot = 0
    meta["last_slot"] = 0
    meta["pending_gold"] = 0
    meta["pending_items"] = []
    Saves.wipe_all_slots()
    save_meta()
    gold_changed.emit(gold)
    inventory_changed.emit()
    equipped_changed.emit("")
    armor_changed.emit("")

## Слот для новой игры: первый свободный, иначе последний игравшийся.
func pick_new_slot() -> int:
    for slot in range(1, SLOT_COUNT + 1):
        if not Platform.has_slot(slot):
            return slot
    var last := int(meta.get("last_slot", 0))
    return last if (last >= 1 and last <= SLOT_COUNT) else 1

## Начать новую игру в слоте slot за героя hero.
## Кошелёк на старте зависит от героя: Воин 100, Варвар 50, Бомж 1, Маг 60.
## Хп/мана ставятся на максимум героя (у мага: 30 хп, 70 маны).
## Оружие, броня и убитые NPC сбрасываются (шаги 7/12); демон забывает удары
## и возвращается (demon_defeated — только для текущего прохождения).
func new_run(slot: int, hero: String) -> void:
    gold = START_GOLD
    inventory = []
    dungeons_cleared = []
    hero_id = hero if HEROES.has(hero) else DEFAULT_HERO
    current_slot = clampi(slot, 1, SLOT_COUNT)
    gold = hero_start_gold(hero_id)
    equipped_weapon_id = ""
    equipped_armor_id = ""
    hp = max_hp()
    mana = max_mana()
    dead_npcs = []
    demon_hits = 0
    demon_enraged = false
    demon_seen = false
    demon_defeated = false
    dungeon_floor = 0
    _transfer_pending_bonus()
    gold_changed.emit(gold)
    inventory_changed.emit()
    hp_changed.emit(hp, max_hp())
    mana_changed.emit(mana, max_mana())
    equipped_changed.emit("")
    armor_changed.emit("")
    Saves.request_save()

## Загрузить игру из слота.
func continue_run(slot: int) -> bool:
    var data := Platform.load_data(slot)
    if data.is_empty():
        return false
    load_save_data(data)
    current_slot = clampi(slot, 1, SLOT_COUNT)
    _transfer_pending_bonus()
    Saves.request_save()
    return true

## Ежедневный бонус: раз в календарный день 50-200 золота + фиолетовая добыча.
## Возвращает {"gold": int, "item_id": String} или {} если сегодня уже получено.
## Награда сразу попадает в состояние игры; если игра ещё не идёт
## (нет активного слота) — дополнительно откладывается в meta и будет
## выдана при начале/загрузке игры (см. _transfer_pending_bonus).
func claim_daily_bonus() -> Dictionary:
    var today := Time.get_date_string_from_system()
    if String(meta.get("last_bonus_date", "")) == today:
        return {}
    var gold_reward := randi_range(50, 200)
    var item_id := ItemDB.random_violet_unique()
    meta["last_bonus_date"] = today
    add_gold(gold_reward)
    add_item({"item_id": item_id, "title": ItemDB.title(item_id), "quality": "violet"})
    if current_slot < 1:
        meta["pending_gold"] = int(meta.get("pending_gold", 0)) + gold_reward
        var pending: Array = meta.get("pending_items", [])
        pending.append(item_id)
        meta["pending_items"] = pending
    save_meta()
    return {"gold": gold_reward, "item_id": item_id}

## Может ли игрок забрать бонус прямо сейчас.
func can_claim_bonus() -> bool:
    return String(meta.get("last_bonus_date", "")) != Time.get_date_string_from_system()

## Отложенные награды бонуса (случились, когда игры ещё не было).
func _transfer_pending_bonus() -> void:
    var pending_gold := int(meta.get("pending_gold", 0))
    if pending_gold > 0:
        gold += pending_gold
        meta["pending_gold"] = 0
        gold_changed.emit(gold)
    var pending_items: Array = meta.get("pending_items", [])
    for item_id in pending_items:
        add_item({"item_id": String(item_id), "title": ItemDB.title(String(item_id)),
                  "quality": "violet"}, false)
    if not pending_items.is_empty():
        meta["pending_items"] = []
        inventory_changed.emit()
    if pending_gold > 0 or not pending_items.is_empty():
        save_meta()

func to_save_data() -> Dictionary:
    return {
        "v": 6,
        "hero_id": hero_id,
        "gold": gold,
        "hp": hp,
        "mana": mana,
        "inventory": inventory,
        "dungeons_cleared": dungeons_cleared,
        "equipped_weapon_id": equipped_weapon_id,
        "equipped_armor_id": equipped_armor_id,
        "demon_defeated": demon_defeated,
        "saved_at": Time.get_datetime_string_from_system(false, true),
    }

func load_save_data(data: Dictionary) -> void:
    hero_id = String(data.get("hero_id", DEFAULT_HERO))
    if not HEROES.has(hero_id):
        hero_id = DEFAULT_HERO
    gold = int(data.get("gold", hero_start_gold(hero_id)))
    inventory = []
    for item in data.get("inventory", []):
        if item is Dictionary:
            inventory.append(item)
    dungeons_cleared = []
    for dungeon_id in data.get("dungeons_cleared", []):
        dungeons_cleared.append(String(dungeon_id))
    # Шаг 7: оружие в руках восстанавливаем, только если оно действительно
    # лежит в сумке и является оружием (защита от старых/битых сейвов).
    # Шаг 12: магическое оружие у варвара из старого сейва снимается —
    # варвар может драться только обычной сталью.
    equipped_weapon_id = ""
    var saved_weapon := String(data.get("equipped_weapon_id", ""))
    if not saved_weapon.is_empty() \
            and String(ItemDB.get_item(saved_weapon).get("type", "")) == "weapon" \
            and _has_item(saved_weapon) \
            and not (hero_id == "barbarian" and ItemDB.is_magic(saved_weapon)):
        equipped_weapon_id = saved_weapon
    # Шаг 12: броня/одеяние восстанавливается только если это экипировка
    # из сумки; одеяние — только магу. Старые сейвы (v4 и раньше) мигрируют
    # с пустым слотом брони.
    equipped_armor_id = ""
    var saved_armor := String(data.get("equipped_armor_id", ""))
    var armor_type := String(ItemDB.get_item(saved_armor).get("type", ""))
    if not saved_armor.is_empty() \
            and (armor_type == "armor" or armor_type == "robe") \
            and _has_item(saved_armor) \
            and not (armor_type == "robe" and not is_mage()):
        equipped_armor_id = saved_armor
    # Совместимость с сейвами шагов 1-5: если хп/маны в сейве нет —
    # ставим максимум героя с учётом надетой экипировки (шаг 12).
    hp = clampi(int(data.get("hp", max_hp())), 0, max_hp())
    mana = clampi(int(data.get("mana", max_mana())), 0, max_mana())
    # Ярость демона и «мы видели демона» — состояние сессии (шаги 12/13).
    demon_hits = 0
    demon_enraged = false
    demon_seen = false
    dungeon_floor = 0
    # Шаг 13: демон, убитый навсегда, остаётся мёртвым и после загрузки
    # (сейв v6; старые сейвы мигрируют: демон ещё жив).
    demon_defeated = bool(data.get("demon_defeated", false))
    # Мёртвые NPC в сейв не пишутся: список живёт только в сессии.
    # Совместимость с сейвами шагов 1-2: настройки жили в сейве.
    if data.has("settings"):
        var saved_settings: Dictionary = data.get("settings", {})
        settings["sound"] = bool(saved_settings.get("sound", true))
        settings["music"] = bool(saved_settings.get("music", true))
        save_meta()
    gold_changed.emit(gold)
    inventory_changed.emit()
    hp_changed.emit(hp, max_hp())
    mana_changed.emit(mana, max_mana())
    equipped_changed.emit(equipped_weapon_id)
    armor_changed.emit(equipped_armor_id)

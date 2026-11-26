## FoeFx — компонент боевых эффектов на врагах (шаг 32).
## Тёмное оружие колдунов (черепа, посохи...) и луч мага накладывают на
## врагов эффекты: ЯД и ГОРЕНИЕ (урон временем), ЗАМЕДЛЕНИЕ, СТРАХ (враг
## убегает), ОГЛУШЕНИЕ (общее с броском варвара) и ПОХИЩЕНИЕ ЖИЗНИ (leech —
## часть урона возвращается герою). Состояние живёт в записи врага:
##   poison_until/poison_dmg/poison_next — яд (тик раз в 1.0 с);
##   burn_until/burn_dmg/burn_next — горение (тик раз в 0.8 с);
##   slow_until — замедление (скорость x0.45);
##   stun_until — оглушение (общее с варваром);
##   fear_until — страх (враг бежит от героя, не бьёт).
## Тики и поведение зовутся из FoeAi.update_foes (данж) и из ИИ демона/
## Королевы в мире. Урон тиков идёт через мост сцены (host._minion_strike_
## enemy → _hit_foe/_hit_npc), поэтому опыт и добыча начисляются как обычно.
class_name FoeFx
extends RefCounted

const POISON_INTERVAL := 1.0     # тик яда, сек
const BURN_INTERVAL := 0.8       # тик горения, сек
const SLOW_MULT := 0.45          # скорость замедленного врага
const POISON_COLOR := Color(0.45, 0.85, 0.4)
const BURN_COLOR := Color(1.0, 0.55, 0.25)
const FEAR_COLOR := Color(0.75, 0.6, 0.95)

## Наложить эффект на врага (rec — запись foe/NPC). power — урон за тик
## (для leech — сколько хп вернуть герою за попадание), seconds — длительность.
static func apply(host, rec: Dictionary, effect: String, power: int,
        seconds: float) -> void:
    if rec.is_empty() or bool(rec.get("dead", false)):
        return
    var now := Time.get_ticks_msec()
    var until := now + int(round(seconds * 1000.0))
    match effect:
        "poison":
            rec["poison_until"] = maxi(int(rec.get("poison_until", 0)), until)
            rec["poison_dmg"] = maxi(int(rec.get("poison_dmg", 0)), power)
            rec["poison_next"] = now   # первый тик — сразу, дальше по интервалу
        "burn":
            rec["burn_until"] = maxi(int(rec.get("burn_until", 0)), until)
            rec["burn_dmg"] = maxi(int(rec.get("burn_dmg", 0)), power)
            rec["burn_next"] = now   # первый тик — сразу
        "slow":
            rec["slow_until"] = maxi(int(rec.get("slow_until", 0)), until)
        "stun":
            # оглушение — общий ключ с броском варвара (шаг 18)
            rec["stun_until"] = maxi(int(rec.get("stun_until", 0)), until)
        "fear":
            rec["fear_until"] = maxi(int(rec.get("fear_until", 0)), until)
            rec["aggro"] = false
        "leech":
            var heal := maxi(1, power)
            if Game.hp > 0 and Game.hp < Game.max_hp():
                Game.heal_hp(heal)
                StrikeFx.poof(host, fx_of(host),
                    (host.player as Node2D).position + Vector2(0, -18),
                    Color(0.85, 0.3, 0.4), 6)

## Родитель эффектов (в данже — _fx, в мире — _world).
static func fx_of(host) -> Node:
    var fx: Variant = host.get("_fx")
    if fx != null:
        return fx
    return host.get("_world")

## Тики эффектов врага (яд и горение). Зовётся КАЖДЫЙ кадр ИИ врага —
## до проверок оглушения/слепоты, чтобы урон временем не замирал.
static func tick_effects(host, rec: Dictionary, delta: float) -> void:
    if rec.is_empty() or bool(rec.get("dead", false)):
        return
    var now := Time.get_ticks_msec()
    if int(rec.get("poison_until", 0)) > now \
            and now >= int(rec.get("poison_next", 2147483647)):
        rec["poison_next"] = now + int(POISON_INTERVAL * 1000.0)
        _dot_tick(host, rec, int(rec.get("poison_dmg", 1)), POISON_COLOR)
    if int(rec.get("burn_until", 0)) > now \
            and now >= int(rec.get("burn_next", 2147483647)):
        rec["burn_next"] = now + int(BURN_INTERVAL * 1000.0)
        _dot_tick(host, rec, int(rec.get("burn_dmg", 1)), BURN_COLOR)

## Один тик урона временем (яд/горение): цифра, вспышка, урон через мост.
static func _dot_tick(host, rec: Dictionary, damage: int, color: Color) -> void:
    var node: Node2D = rec.get("node")
    if node == null:
        return
    StrikeFx.poof(host, fx_of(host), node.position + Vector2(0, -14),
        color, 6)
    host._minion_strike_enemy(rec, maxi(1, damage))

## Скорость врага с учётом замедления (1.0 — не замедлен).
static func speed_mult(rec: Dictionary, now_ms: int) -> float:
    return SLOW_MULT if int(rec.get("slow_until", 0)) > now_ms else 1.0

## Враг в страхе бежит от героя (зовётся вместо обычного ИИ). Урон временем
## тикает как обычно (tick_effects зовётся раньше). Возвращает true, если
## эффект ещё держится и враг «побежал».
static func flee_from_hero(host, rec: Dictionary, delta: float) -> bool:
    var node: Node2D = rec.get("node")
    var spr: AnimatedSprite2D = rec.get("sprite")
    if node == null or host.player == null:
        return false
    var now := Time.get_ticks_msec()
    if int(rec.get("fear_until", 0)) <= now:
        return false
    var away: Vector2 = node.position - (host.player as Node2D).position
    var dirv := away.normalized() if away.length() > 1.0 else Vector2.RIGHT
    var speed: float = float((rec.get("def", {}) as Dictionary).get("speed", 60.0))
    var base := node.position
    var step := speed * delta
    var nx: Vector2 = base + Vector2(dirv.x, 0.0) * step
    if not host._tile_is_solid(nx + Vector2(0, -8)):
        node.position.x = nx.x
    var ny: Vector2 = base + Vector2(0.0, dirv.y) * step
    if not host._tile_is_solid(ny + Vector2(0, -8)):
        node.position.y = ny.y
    if spr != null:
        FoeAi.foe_anim(spr, dirv)
    return true

## Зачистка эффектов при смерти врага (записи трупов не должны тикать).
static func clear(rec: Dictionary) -> void:
    for key in ["poison_until", "poison_dmg", "poison_next", "burn_until",
            "burn_dmg", "burn_next", "slow_until", "stun_until", "fear_until"]:
        rec.erase(key)

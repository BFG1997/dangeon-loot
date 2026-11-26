## DarkCast — исполнитель F-атак оружием (шаг 32).
## Тёмное оружие колдунов (Демоноолог/Некромант) и луч мага стреляют
## ударом «attack» (F/ЛКМ) вместо обычного замаха. Три формы атаки:
##   bolt — снаряды (StrikeFx.spawn_bolt, веер из count штук): летят,
##          первый враг на пути получает урон и эффект оружия;
##   beam — мгновенный ЛУЧ по направлению взгляда: бьёт ВСЕХ врагов на
##          линии (пробивает ряды), рисуется светящейся линией;
##   nova — вспышка вокруг героя: урон и эффект всем врагам в radius.
## Оба вида сцен работают через общие мосты:
##   host._bolt_target_at(pos)     — враг в точке (мир: NPC, данж: foe);
##   host._minion_strike_enemy(rec,dmg) — урон средствами сцены;
##   host._tile_is_solid(pos)      — стены;
##   FoeFx.apply_effect            — эффекты оружия (яд/горение/страх...).
## Мана, кулдаун и подсказки — на стороне сцены (F-атака за ману).
class_name DarkCast
extends RefCounted

## Родитель эффектов в сцене (данж — _fx, мир — _world).
static func fx_of(host) -> Node:
    var fx: Variant = host.get("_fx")
    if fx != null:
        return fx
    return host.get("_world")

## Цвет из записи [r,g,b].
static func color_of(info: Dictionary, fallback: Color) -> Color:
    var c: Variant = info.get("color", null)
    if c is Array and (c as Array).size() >= 3:
        return Color(float(c[0]), float(c[1]), float(c[2]))
    return fallback

## Выполнить F-атаку оружием. info — Game.f_attack_info(); dir — направление
## взгляда героя. Возвращает число поражённых целей (для подсказок сцены).
static func fire_attack(host, dir: Vector2, info: Dictionary) -> int:
    if info.is_empty() or host.player == null:
        return 0
    match String(info.get("kind", "bolt")):
        "beam":
            return fire_beam(host, dir, info)
        "nova":
            return fire_nova(host, info)
        _:
            return fire_bolt(host, dir, info)

## --- bolt: снаряды с эффектом оружия ----------------------------------
static func fire_bolt(host, dir: Vector2, info: Dictionary) -> int:
    var parent := fx_of(host)
    var bolt_info := {
        "damage": int(info.get("damage", 1)),
        "speed": float(info.get("speed", 280.0)),
        "range_px": float(info.get("range_px", 190.0)),
        "color": info.get("color", [0.7, 0.9, 0.7]),
        "size": float(info.get("size", 1.0)),
        "effect": String(info.get("effect", "")),
        "effect_sec": float(info.get("effect_sec", 0.0)),
    }
    var count := maxi(1, int(info.get("count", 1)))
    var spread := deg_to_rad(float(info.get("spread_deg", 0.0)))
    for i in range(count):
        var shot_dir := dir
        if count > 1:
            shot_dir = dir.rotated(
                (float(i) - float(count - 1) / 2.0) * spread)
        StrikeFx.spawn_bolt(host, parent, shot_dir, bolt_info,
            host.get("_bolt_tex"), host.get("_glow_tex"),
            host.get("_glow_mat"), 10)
    Sfx.play("bolt", -2.0, 0.06, 0.9)
    return 0   # цели считает StrikeFx.update_bolts по ходу полёта

## --- beam: мгновенный луч, бьёт всех на линии --------------------------
static func fire_beam(host, dir: Vector2, info: Dictionary) -> int:
    var parent := fx_of(host)
    var color := color_of(info, Color(0.55, 0.85, 0.95))
    var from: Vector2 = (host.player as Node2D).position + Vector2(0, -12)
    var range_px := float(info.get("range_px", 180.0))
    var damage := maxi(1, int(info.get("damage", 1)))
    var effect := String(info.get("effect", ""))
    var effect_sec := float(info.get("effect_sec", 0.0))
    var size := maxf(1.4, float(info.get("size", 1.4)))
    # шаг по линии: стены гасят луч, врагов собираем без повторов
    var step := 6.0
    var end_pos := from + dir * range_px
    var hit: Array = []
    var hit_ids: Array = []
    var d := step
    while d <= range_px:
        var sample: Vector2 = from + dir * d
        if host._tile_is_solid(sample):
            end_pos = sample - dir * step
            break
        var target: Dictionary = host._bolt_target_at(sample)
        if not target.is_empty():
            var tnode: Node2D = target["node"]
            if tnode != null and tnode not in hit_ids:
                hit_ids.append(tnode)
                hit.append(target)
        d += step
    # визуал: светящаяся линия + вспышки у цели и в конце
    var beam := Line2D.new()
    beam.points = PackedVector2Array([from, end_pos])
    beam.width = size
    beam.default_color = Color(color.r, color.g, color.b, 0.9)
    var mat := CanvasItemMaterial.new()
    mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
    beam.material = mat
    beam.z_index = 11
    parent.add_child(beam)
    var tw: Tween = host.create_tween()   # твин умирает вместе со сценой
    tw.set_parallel(true)
    tw.tween_property(beam, "width", 0.5, 0.18).set_delay(0.06)
    tw.tween_property(beam, "modulate:a", 0.0, 0.18).set_delay(0.06)
    tw.chain().tween_callback(beam.queue_free)
    StrikeFx.poof(host, parent, from, color, 10)
    StrikeFx.poof(host, parent, end_pos, color, 10)
    for foe in hit:
        var node: Node2D = foe["node"]
        StrikeFx.hit_impact(host, parent, node.position + Vector2(0, -12),
            color, 10)
        host._minion_strike_enemy(foe, damage)
        if not effect.is_empty():
            FoeFx.apply(host, foe, effect, damage, effect_sec)
    Sfx.play("bolt", 0.0, 0.05, 1.25)
    return hit.size()

## --- nova: вспышка вокруг героя ----------------------------------------
static func fire_nova(host, info: Dictionary) -> int:
    var parent := fx_of(host)
    var color := color_of(info, Color(0.8, 0.7, 0.9))
    var radius := float(info.get("radius", 60.0))
    var damage := maxi(1, int(info.get("damage", 1)))
    var effect := String(info.get("effect", ""))
    var effect_sec := float(info.get("effect_sec", 0.0))
    var center: Vector2 = (host.player as Node2D).position + Vector2(0, -10)
    StrikeFx.ring(host, parent, center, color, 2.6)
    StrikeFx.poof(host, parent, center, color, 10)
    var hit := 0
    var now := Time.get_ticks_msec()
    for foe in host._enemy_records():
        if bool(foe.get("dead", false)) or bool(foe.get("thrown", false)):
            continue
        var node: Node2D = foe["node"]
        if node.position.distance_to(center) > radius + 10.0:
            continue
        StrikeFx.hit_impact(host, parent, node.position + Vector2(0, -12),
            color, 10)
        host._minion_strike_enemy(foe, damage)
        if not effect.is_empty():
            FoeFx.apply(host, foe, effect, damage, effect_sec)
        hit += 1
    return hit

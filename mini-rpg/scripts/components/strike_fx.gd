## Шаг 28 (декомпозиция): визуальные эффекты ударов, снарядов и всплесков.
## Раньше эти функции жили копиями в world.gd и dungeon.gd (~300 строк
## дубликата); оба монолита теперь зовут их здесь через 1-строчные
## обёртки. Поведение не менялось, различия сцен уложены в параметры:
##  - host  — сцена (мир/данж): у неё создаются твины (шаг 23: твин умирает
##    вместе со сценой), из неё берутся player, кэши текстур и массивы
##    снарядов (_bolts, _foe_bolts);
##  - parent — узел-родитель эффектов: в мире это _world, в данже — _fx;
##  - z     — z_index частиц: мир ставил 10, данж оставлял ноль движка;
##  - отдельные различия (масштаб дуги удара, «крупный урон» >= 30) —
##    явные параметры start_scale и big.
class_name StrikeFx
extends RefCounted

const GLOW_TEX_PATH := "res://assets/sprites/props/glow.png"

## Вспышка-частицы при исчезновении снаряда (и при смерти NPC — серым).
static func poof(host, parent: Node, pos: Vector2, color: Color, z: int = 0) -> void:
        var poof := CPUParticles2D.new()
        poof.position = pos
        poof.amount = 10
        poof.lifetime = 0.3
        poof.one_shot = true
        poof.explosiveness = 1.0
        poof.direction = Vector2(0, -1)
        poof.spread = 180.0
        poof.initial_velocity_min = 20.0
        poof.initial_velocity_max = 50.0
        poof.scale_amount_min = 1.5
        poof.scale_amount_max = 3.0
        poof.color = color
        poof.emitting = true
        poof.z_index = z
        parent.add_child(poof)
        var tw: Tween = host.create_tween()   # шаг 23: твин умирает вместе со сценой
        tw.tween_interval(0.6)
        tw.tween_callback(func() -> void:
                if is_instance_valid(poof):
                        poof.queue_free())

## Взмах — сноп искр у точки удара (шаг 19: сочный).
static func swing(host, parent: Node, pos: Vector2, color: Color, z: int = 0) -> void:
        var swing := CPUParticles2D.new()
        swing.position = pos
        swing.amount = 14                       # шаг 19: сочнее
        swing.lifetime = 0.24
        swing.one_shot = true
        swing.explosiveness = 1.0
        swing.direction = Vector2(0, -1)
        swing.spread = 120.0
        swing.initial_velocity_min = 60.0
        swing.initial_velocity_max = 130.0
        swing.scale_amount_min = 1.6
        swing.scale_amount_max = 3.2
        swing.color = color
        swing.emitting = true
        swing.z_index = z
        parent.add_child(swing)
        var tw: Tween = host.create_tween()   # шаг 23: твин умирает вместе со сценой
        tw.tween_interval(0.5)
        tw.tween_callback(func() -> void:
                if is_instance_valid(swing):
                        swing.queue_free())

## Видимое оружие (шаг 19): иконка того, что в руках, проносится дугой
## в направлении взгляда и тает. Кулаки — без иконки (искры и дуга).
static func weapon_swing(host, parent: Node, dir: Vector2, _color: Color) -> void:
        var icon_path: String = Game.strike_weapon_icon()
        if icon_path.is_empty() or not ResourceLoader.exists(icon_path):
                return
        if not host._weapon_tex_cache.has(icon_path):
                host._weapon_tex_cache[icon_path] = load(icon_path)
        var tex: Texture2D = host._weapon_tex_cache[icon_path]
        var base := atan2(dir.y, dir.x)
        var weapon := Sprite2D.new()
        weapon.texture = tex
        weapon.position = host.player.position + dir * 13.0 + Vector2(0, -12)
        weapon.rotation = base - PI / 2.0 - 1.1
        weapon.scale = Vector2(1.5, 1.5)
        weapon.z_index = 11
        parent.add_child(weapon)
        var tw: Tween = host.create_tween()
        tw.set_parallel(true)
        tw.tween_property(weapon, "rotation", base - PI / 2.0 + 1.1, 0.14) \
                .set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
        tw.tween_property(weapon, "scale", Vector2(1.15, 1.15), 0.14)
        tw.tween_property(weapon, "modulate:a", 0.0, 0.12).set_delay(0.1)
        tw.chain().tween_callback(weapon.queue_free)

## Дуга удара (шаг 19): белая дуга slash_arc.png в цвет оружия/заклинания.
## start_scale: мир — 0.4, данж — 0.55 (шаг 20: дуга заметнее).
static func slash_arc(host, parent: Node, pos: Vector2, color: Color,
                start_scale: float) -> void:
        if host._slash_tex == null:
                return
        var arc := Sprite2D.new()
        arc.texture = host._slash_tex
        arc.position = pos
        arc.modulate = Color(color.r, color.g, color.b, 0.9)
        var mat := CanvasItemMaterial.new()
        mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
        arc.material = mat
        arc.rotation = randf_range(-0.5, 0.5)
        arc.scale = Vector2(start_scale, start_scale)
        arc.z_index = 11
        parent.add_child(arc)
        var tw: Tween = host.create_tween()
        tw.set_parallel(true)
        tw.tween_property(arc, "scale", Vector2(1.1, 1.1), 0.16) \
                .set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
        tw.tween_property(arc, "modulate:a", 0.0, 0.2).set_delay(0.08)
        tw.chain().tween_callback(arc.queue_free)

## Импакт попадания (шаг 19): яркая вспышка искр из точки удара.
static func hit_impact(host, parent: Node, pos: Vector2, color: Color,
                z: int = 0) -> void:
        var impact := CPUParticles2D.new()
        impact.position = pos
        impact.amount = 14
        impact.lifetime = 0.18
        impact.one_shot = true
        impact.explosiveness = 1.0
        impact.direction = Vector2(0, -1)
        impact.spread = 180.0
        impact.initial_velocity_min = 60.0
        impact.initial_velocity_max = 140.0
        impact.scale_amount_min = 1.0
        impact.scale_amount_max = 2.4
        impact.color = color
        impact.emitting = true
        impact.z_index = z
        parent.add_child(impact)
        var tw: Tween = host.create_tween()   # шаг 23: твин умирает вместе со сценой
        tw.tween_interval(0.5)
        tw.tween_callback(func() -> void:
                if is_instance_valid(impact):
                        impact.queue_free())

## След снаряда (шаг 19): одна тающая искра.
static func trail_dot(host, parent: Node, pos: Vector2, color: Color,
                z: int = 0) -> void:
        var dot := CPUParticles2D.new()
        dot.position = pos
        dot.amount = 1
        dot.lifetime = 0.28
        dot.one_shot = true
        dot.explosiveness = 1.0
        dot.direction = Vector2.ZERO
        dot.spread = 0.0
        dot.initial_velocity_min = 0.0
        dot.initial_velocity_max = 0.0
        dot.scale_amount_min = 1.4
        dot.scale_amount_max = 2.2
        dot.color = Color(color.r, color.g, color.b, 0.65)
        dot.emitting = true
        dot.z_index = z
        parent.add_child(dot)
        var tw: Tween = host.create_tween()   # шаг 23: твин умирает вместе со сценой
        tw.tween_interval(0.4)
        tw.tween_callback(func() -> void:
                if is_instance_valid(dot):
                        dot.queue_free())

## Всплывающее число урона над врагом: поднимается и тает.
## big (только данж, шаг 20): урон >= 30 — крупная золотая цифра.
## crit (шаг 27): КРУПНАЯ жёлтая цифра со звёздочкой и звук crit.
static func damage_label(host, parent: Node, pos: Vector2, damage: int,
                big: bool = false, crit: bool = false) -> void:
        var label := Label.new()
        label.text = ("-%d!" if crit else "-%d") % damage
        label.position = pos + Vector2(-14 if not crit else -20, 0)
        label.size = Vector2(28 if not crit else 40, 14)
        label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
        # шаг 20: крупный урон — крупная золотая цифра (почувствуй удар)
        # шаг 27: крит — ещё крупнее, ярче и с собственным звуком
        if crit:
                label.add_theme_font_size_override("font_size", 19)
                label.add_theme_color_override("font_color", Color(1.0, 0.92, 0.25))
        elif big and damage >= 30:
                label.add_theme_font_size_override("font_size", 14)
                label.add_theme_color_override("font_color", Color(1.0, 0.84, 0.3))
        else:
                label.add_theme_font_size_override("font_size", 11)
                label.add_theme_color_override("font_color", Color(1.0, 0.42, 0.36))
        label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.8))
        label.add_theme_constant_override("shadow_offset_y", 1)
        label.z_index = 12
        parent.add_child(label)
        if crit:
                Sfx.play("crit")
        var tw: Tween = host.create_tween()
        tw.set_parallel(true)
        tw.tween_property(label, "position:y", label.position.y - 16.0, 0.6) \
                .set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
        tw.tween_property(label, "modulate:a", 0.0, 0.6).set_delay(0.15)
        tw.chain().tween_callback(label.queue_free)

## Расширяющееся кольцо (шаг 20, данж): свечение, растущее и тающее.
## Шаг 32: в мире у сцены нет кэша _glow_tex/_glow_mat — материал создаётся
## на месте (как это было у болтов мира до шага 28).
static func ring(host, parent: Node, pos: Vector2, color: Color,
                scale_to: float) -> void:
        var glow_tex: Texture2D = host.get("_glow_tex")
        if glow_tex == null:
                glow_tex = load(GLOW_TEX_PATH)
        var glow_mat: CanvasItemMaterial = host.get("_glow_mat")
        if glow_mat == null:
                glow_mat = CanvasItemMaterial.new()
                glow_mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
        var ring := Sprite2D.new()
        ring.texture = glow_tex
        ring.material = glow_mat
        ring.position = pos
        ring.scale = Vector2(0.5, 0.5)
        ring.modulate = Color(color.r, color.g, color.b, 0.65)
        ring.z_index = 9
        parent.add_child(ring)
        var tw: Tween = host.create_tween()
        tw.set_parallel(true)
        tw.tween_property(ring, "scale", Vector2(scale_to, scale_to), 0.32) \
                .set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
        tw.tween_property(ring, "modulate:a", 0.0, 0.34)
        tw.chain().tween_callback(ring.queue_free)

## Всплывающий опыт (шаг 19, данж): золотое «+N опыта» над убитым врагом.
static func xp_label(host, parent: Node, pos: Vector2, amount: int) -> void:
        var label := Label.new()
        label.text = "+%d опыта" % amount
        label.position = pos + Vector2(-24, 0)
        label.size = Vector2(48, 14)
        label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
        label.add_theme_font_size_override("font_size", 10)
        label.add_theme_color_override("font_color", Color(1.0, 0.84, 0.2))
        label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.8))
        label.add_theme_constant_override("shadow_offset_y", 1)
        parent.add_child(label)
        var tw: Tween = host.create_tween()
        tw.set_parallel(true)
        tw.tween_property(label, "position:y", label.position.y - 18.0, 0.8) \
                .set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
        tw.tween_property(label, "modulate:a", 0.0, 0.8).set_delay(0.25)
        tw.chain().tween_callback(label.queue_free)

## Снаряд героя (магия/метательный топор): летит по dir, светится.
## z: мир ставил 10, данж оставлял ноль. glow_tex/glow_mat: у данжа кэш
## (_glow_tex/_glow_mat), в мире материал создавался на каждый болт —
## передаётся null и создаётся на месте, как раньше.
static func spawn_bolt(host, parent: Node, dir: Vector2, info: Dictionary,
                bolt_tex: Texture2D, glow_tex: Texture2D,
                glow_mat: CanvasItemMaterial, z: int = 0) -> void:
        if dir == Vector2.ZERO or bolt_tex == null:
                return
        if info.is_empty():
                info = Game.spell_info()
                if info.is_empty():
                        return
        var bolt := Sprite2D.new()
        bolt.texture = bolt_tex
        var col: Array = info.get("color", [0.55, 0.85, 0.95])
        bolt.modulate = Color(float(col[0]), float(col[1]), float(col[2]))
        var size := float(info.get("size", 1.0))
        bolt.scale = Vector2(size, size)
        bolt.position = host.player.position + Vector2(0, -14)
        bolt.z_index = z
        # шаг 19: снаряды светятся и оставляют тающий след
        if glow_tex == null:
                glow_tex = load(GLOW_TEX_PATH)
        if glow_mat == null:
                glow_mat = CanvasItemMaterial.new()
                glow_mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
        var glow := Sprite2D.new()
        glow.texture = glow_tex
        glow.material = glow_mat
        glow.scale = Vector2(1.1, 1.1)
        glow.modulate = Color(float(col[0]), float(col[1]), float(col[2]), 0.7)
        bolt.add_child(glow)
        parent.add_child(bolt)
        # шаг 32: снаряд F-атаки несёт эффект оружия (яд/горение/страх...)
        host._bolts.append({"node": bolt, "dir": dir.normalized(),
                "left": float(info["range_px"]), "speed": float(info["speed"]),
                "damage": int(info["damage"]), "color": bolt.modulate, "trail": 0.0,
                "effect": String(info.get("effect", "")),
                "effect_sec": float(info.get("effect_sec", 0.0))})

## Полёт снарядов героя: шаг, след, попадание по цели (через мосты
## _bolt_target_at/_bolt_hit сцены: в мире это NPC, в данже — враги),
## гашение у стен или по дистанции.
static func update_bolts(host, parent: Node, delta: float, z: int = 0) -> void:
        if host._bolts.is_empty():
                return
        for i in range(host._bolts.size() - 1, -1, -1):
                var b: Dictionary = host._bolts[i]
                var node: Sprite2D = b["node"]
                var step: Vector2 = (b["dir"] as Vector2) * float(b["speed"]) * delta
                node.position += step
                if bool(b.get("spin", false)):
                        node.rotation += 10.0 * delta   # метательный топор крутится (шаг 18)
                b["left"] = float(b["left"]) - step.length()
                # шаг 19: след из тающих искр за снарядом (и за топором)
                b["trail"] = float(b.get("trail", 0.0)) + delta
                if float(b["trail"]) >= 0.05:
                        b["trail"] = 0.0
                        trail_dot(host, parent, node.position,
                                b.get("color", Color(0.55, 0.85, 0.95)), z)
                # шаг 9: снаряд бьёт первую живую цель, в чьё тело он попал
                var target: Dictionary = host._bolt_target_at(node.position)
                if not target.is_empty():
                        hit_impact(host, parent, node.position,
                                b.get("color", Color(0.55, 0.85, 0.95)), z)
                        node.queue_free()
                        host._bolts.remove_at(i)
                        var hit_damage := int(b["damage"])
                        host._bolt_hit(target, hit_damage)
                        # шаг 32: снаряд F-атаки несёт эффект оружия
                        # (яд/горение/страх/оглушение/похищение жизни)
                        var effect := String(b.get("effect", ""))
                        if not effect.is_empty():
                                FoeFx.apply(host, target, effect, hit_damage,
                                        float(b.get("effect_sec", 0.0)))
                        continue
                var faded := float(b["left"]) <= 0.0
                if faded or host._tile_is_solid(node.position):
                        poof(host, parent, node.position,
                                b.get("color", Color(0.55, 0.85, 0.95)), z)
                        node.queue_free()
                        host._bolts.remove_at(i)

## Болт врага/колдуна (данж): летит в героя, гаснет у стен. Урон — из
## записи врага. Шаг 21: spread_deg — угол веера (залпы безумия Ктулху),
## color_override — чужой цвет болта (a > 0 — использовать его).
static func spawn_foe_bolt(host, parent: Node, foe: Dictionary,
                def: Dictionary, spread_deg: float = 0.0,
                color_override: Color = Color(0, 0, 0, 0), glow_tex: Texture2D = null,
                glow_mat: CanvasItemMaterial = null) -> void:
        var col: Array = def.get("bolt_color", [0.6, 0.8, 0.7])
        if color_override.a > 0.0:
                col = [color_override.r, color_override.g, color_override.b]
        var bolt := Sprite2D.new()
        bolt.texture = host._bolt_tex
        bolt.modulate = Color(float(col[0]), float(col[1]), float(col[2]))
        bolt.scale = Vector2(0.9, 0.9)
        var from: Node2D = foe["node"]
        bolt.position = from.position + Vector2(0, -14)
        # шаг 19: болты колдунов тоже светятся
        if glow_tex == null:
                glow_tex = load(GLOW_TEX_PATH)
        if glow_mat == null:
                glow_mat = CanvasItemMaterial.new()
                glow_mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
        var glow := Sprite2D.new()
        glow.texture = glow_tex
        glow.material = glow_mat
        glow.scale = Vector2(1.0, 1.0)
        glow.modulate = Color(float(col[0]), float(col[1]), float(col[2]), 0.65)
        bolt.add_child(glow)
        parent.add_child(bolt)
        Sfx.play("bolt", -6.0)
        var dir: Vector2 = (host.player.position + Vector2(0, -14) \
                - bolt.position).normalized()
        if dir == Vector2.ZERO:
                dir = Vector2(0, 1)   # совпадение точек: болт падает вниз, а не висит
        if spread_deg != 0.0:
                dir = dir.rotated(deg_to_rad(spread_deg))
        host._foe_bolts.append({"node": bolt, "dir": dir,
                "left": float(def.get("bolt_range_px", 190.0)),
                "speed": float(def.get("bolt_speed", 130.0)),
                "damage": maxi(1, int(foe.get("dmg", 1))),
                "color": bolt.modulate})

## Полёт болтов врагов (данж): попадание в героя — урон и вспышка;
## гашение у стен или по дистанции.
static func update_foe_bolts(host, parent: Node, delta: float) -> void:
        if host._foe_bolts.is_empty() or host.player == null:
                return
        for i in range(host._foe_bolts.size() - 1, -1, -1):
                var b: Dictionary = host._foe_bolts[i]
                var node: Sprite2D = b["node"]
                var step: Vector2 = (b["dir"] as Vector2) * float(b["speed"]) * delta
                node.position += step
                b["left"] = float(b["left"]) - step.length()
                var hit: bool = absf(node.position.x - host.player.position.x) <= 9.0 \
                        and node.position.y >= host.player.position.y - 28.0 \
                        and node.position.y <= host.player.position.y + 4.0
                if hit and Game.hp > 0 and not host._player_dead:
                        poof(host, parent, node.position, b.get("color", Color(0.7, 0.8, 0.7)))
                        node.queue_free()
                        host._foe_bolts.remove_at(i)
                        Game.damage_hp(int(b["damage"]), true)   # шаг 27: i-frames
                        Sfx.play_variant("hurt")
                        hit_impact(host, parent, node.position, Color(0.8, 0.85, 0.8))
                        damage_label(host, parent,
                                host.player.position + Vector2(0, -40), int(b["damage"]), true)
                        host._flash_player()
                        continue
                var faded := float(b["left"]) <= 0.0
                if faded or host._tile_is_solid(node.position):
                        poof(host, parent, node.position, b.get("color", Color(0.7, 0.8, 0.7)))
                        node.queue_free()
                        host._foe_bolts.remove_at(i)

# --------------------------- приёмы героев с шага 30 на пробеле

## Анимация питья бомжа («Хмельной запал»): герой запрокидывает голову
## (наклон спрайта назад с «пьяным» колебанием), вокруг летят зелёные
## пузырьки; в конце — тихий «бульк». Flask из инвентаря не тратится.
static func drink_pose(host, seconds: float) -> void:
        var spr: AnimatedSprite2D = host._player_sprite
        if spr != null:
                var tw: Tween = host.create_tween()   # шаг 23: умирает со сценой
                tw.tween_property(spr, "rotation", -0.38, 0.28) \
                        .set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
                tw.tween_property(spr, "rotation", -0.3, 0.22)
                tw.tween_property(spr, "rotation", -0.36, 0.22)
                tw.tween_property(spr, "rotation", 0.0, 0.3) \
                        .set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
                tw.tween_callback(func() -> void: Sfx.play("gas", -8.0, 0.02, 0.7))
        var parent: Node = host.get("_fx")
        if parent == null:
                parent = host.get("_world")
        if parent == null or host.player == null:
                return
        var bubbles := CPUParticles2D.new()
        bubbles.position = (host.player as CharacterBody2D).position + Vector2(2, -26)
        bubbles.amount = 12
        bubbles.lifetime = 0.55
        bubbles.one_shot = true
        bubbles.direction = Vector2(0, -1)
        bubbles.spread = 28.0
        bubbles.initial_velocity_min = 26.0
        bubbles.initial_velocity_max = 46.0
        bubbles.scale_amount_min = 1.2
        bubbles.scale_amount_max = 2.4
        bubbles.color = Color(0.5, 0.95, 0.45)
        bubbles.emitting = true
        parent.add_child(bubbles)
        var btw: Tween = host.create_tween()
        btw.tween_interval(1.0)
        btw.tween_callback(func() -> void:
                if is_instance_valid(bubbles):
                        bubbles.queue_free())

## Пинок варвара: резкий выпад корпусом — спрайт «ныряет» вперёд по
## направлению удара и пружиной возвращается; масштаб запоминается,
## чтобы не ломать «Гнев титана».
static func kick_pose(host, dir: Vector2) -> void:
        var spr: AnimatedSprite2D = host._player_sprite
        if spr == null or host.player == null:
                return
        var base_scale: Vector2 = spr.scale
        var base_pos: Vector2 = spr.position
        var lunge := dir * 5.0
        var tw: Tween = host.create_tween()
        tw.set_parallel(true)
        tw.tween_property(spr, "position", base_pos + lunge, 0.09) \
                .set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
        tw.tween_property(spr, "scale", base_scale * 1.05, 0.09)
        tw.chain().set_parallel(true)
        tw.tween_property(spr, "position", base_pos, 0.16) \
                .set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
        tw.tween_property(spr, "scale", base_scale, 0.16) \
                .set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

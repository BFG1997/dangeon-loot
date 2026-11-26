## FoeAi — компонент спавна и ИИ врагов (шаг 28, декомпозиция).
## Раньше логика врагов лежала копиями в dungeon.gd (~450 строк) и
## world.gd (демон, ~40 строк). Поведение не менялось: тела перенесены
## дословно, различия сцен — через параметры:
##  - d/w — сцена-хост: из неё берутся player, массивы _foes/_npcs,
##    константы баланса (CHAR_H, ELITE_*, TENTACLE_*, DEMON_*) и методы
##    _tile_is_solid/_add_shadow/_make_frames/_feet_pos/_shake_camera;
##  - тактика боссов — отдельный компонент BossAi (boss_ai.gd);
##  - визуальные эффекты — StrikeFx, HUD-подсказки — HudBuilder.
class_name FoeAi
extends RefCounted

## Шаг 31: безумие Некроманта — дальность, с которой безумый моб видит
## собратьев, и цвет безумия (спрайт краснеет на все 10 секунд).
const MADNESS_SIGHT := 180.0
const MAD_TINT := Color(1.0, 0.5, 0.45)

## Противник этажа: спрайт 24x32 (тот же формат листов, что у героев),
## маленькое тело (блокирует героя). Враги не говорят — зоны клика нет.
## elite (шаг 15): «элитный чемпион» — крупнее (1.25x), вдвое жилистей,
## больнее и втрое богаче; имя — с приставкой «Элитный ».
static func spawn_foe(d, def: Dictionary, tile: Vector2i,
                elite: bool = false) -> Dictionary:
        var pos: Vector2 = d._feet_pos(Vector2(tile))
        var node := Node2D.new()
        node.name = "Foe_%s" % String(def["id"])
        node.position = pos
        d._add_shadow(node, 1.1 if elite else 0.9)
        var spr := AnimatedSprite2D.new()
        spr.sprite_frames = d._make_frames(load(String(def["sheet"])))
        spr.position = Vector2(0, -d.CHAR_H / 2.0 + 3.0)
        # шаг 19: враги чуть крупнее, элита — заметно крупнее
        spr.scale = Vector2(d.ELITE_SIZE_MULT, d.ELITE_SIZE_MULT) if elite \
                else Vector2(d.FOE_SIZE_MULT, d.FOE_SIZE_MULT)
        spr.play("idle_down")
        node.add_child(spr)
        var body := StaticBody2D.new()
        body.collision_layer = 1
        body.collision_mask = 0
        var body_shape := CollisionShape2D.new()
        var circle := CircleShape2D.new()
        circle.radius = 6.0 if elite else 5.0
        body_shape.shape = circle
        body_shape.position = Vector2(0, -2)
        body.add_child(body_shape)
        node.add_child(body)
        var hp := maxi(1, int(def["hp"]))
        var dmg := maxi(1, int(def["damage"]))
        if elite:
                hp = maxi(2, int(round(float(hp) * 1.9)))
                dmg = maxi(1, int(round(float(dmg) * 1.5)))
        var hp_bar := hp_bar_for(d, hp, 1.25 if elite else 1.0)
        node.add_child(hp_bar)
        d._entities.add_child(node)
        var title := String(def.get("name", "Враг"))
        if elite:
                title = String(d.ELITE_PREFIX) + title
        var foe := {"id": String(def["id"]), "def": def, "node": node,
                "sprite": spr, "hp": hp, "max_hp": hp, "hp_bar": hp_bar,
                "body": body, "aggro": false, "atk_cd": 0.0,
                "bolt_cd": 0.0, "boss": false, "dead": false,
                "elite": elite, "dmg": dmg, "title": title,
                "gold_mult": 3 if elite else 1, "flash_tween": null}
        d._foes.append(foe)
        return foe

## Босс последнего этажа: Таинственный демон — тот же лист 72x96, что у
## демона с юга карты (втрое крупнее врагов). Дерётся только после диалога.
static func spawn_boss(d, tile: Vector2i) -> void:
        var def: Dictionary = DungeonBestiary.boss_for(d._dungeon_id)
        var s := maxi(1, int(def.get("scale", 3)))
        var node := Node2D.new()
        node.name = "Boss"
        node.position = d._feet_pos(Vector2(tile))
        d._add_shadow(node, 0.9 * s)
        var spr := AnimatedSprite2D.new()
        spr.sprite_frames = d._make_frames(load(String(def["sheet"])),
                d.CHAR_W * s, d.CHAR_H * s)
        spr.position = Vector2(0, -(d.CHAR_H * s) / 2.0 + 3.0)
        spr.scale = Vector2(d.BOSS_SIZE_MULT, d.BOSS_SIZE_MULT)   # шаг 19
        spr.play("idle_down")
        node.add_child(spr)
        var body := StaticBody2D.new()
        body.collision_layer = 1
        body.collision_mask = 0
        var body_shape := CollisionShape2D.new()
        var circle := CircleShape2D.new()
        circle.radius = 5.0 * s
        body_shape.shape = circle
        body_shape.position = Vector2(0, -2)
        body.add_child(body_shape)
        node.add_child(body)
        var hp := maxi(1, int(def["hp"]))
        var hp_bar := hp_bar_for(d, hp, float(s))
        node.add_child(hp_bar)
        d._entities.add_child(node)
        var boss := {"id": String(def["id"]), "def": def, "node": node,
                "sprite": spr, "hp": hp, "max_hp": hp, "hp_bar": hp_bar,
                "body": body, "aggro": false, "atk_cd": 0.0, "bolt_cd": 0.0,
                "boss": true, "dead": false, "flash_tween": null}
        if String(def["id"]) == "boss_cthulhu":
                BossAi.decorate_cthulhu(d, boss)   # шаг 21: глаза-угли, аура, дыхание
        elif String(def["id"]) == "boss_shub":
                BossAi.decorate_shub(d, boss)      # шаг 24: три глаза, аура спор, дыхание
        d._foes.append(boss)

## Полоска хп врага над головой (скрыта до первого удара).
static func hp_bar_for(d, hp: int, s: float) -> ProgressBar:
        var hp_bar := ProgressBar.new()
        hp_bar.min_value = 0
        hp_bar.max_value = hp
        hp_bar.value = hp
        hp_bar.show_percentage = false
        hp_bar.custom_minimum_size = Vector2(24.0 * s, 4)
        hp_bar.size = Vector2(24.0 * s, 4)
        hp_bar.position = Vector2(-12.0 * s, -float(d.CHAR_H) * s - 4)
        hp_bar.visible = false
        hp_bar.add_theme_stylebox_override("background",
                HudBuilder.bar_style(Color(0.09, 0.08, 0.1), Color(0.4, 0.18, 0.18)))
        hp_bar.add_theme_stylebox_override("fill",
                HudBuilder.bar_style(Color(0.72, 0.26, 0.26), Color(0.72, 0.26, 0.26)))
        return hp_bar

## Живой враг в точке (прямоугольник тела с учётом масштаба босса).
static func foe_at_point(d, pos: Vector2) -> Dictionary:
        for foe in d._foes:
                if bool(foe.get("dead", false)):
                        continue
                var node: Node2D = foe["node"]
                var s := maxi(1, int((foe["def"] as Dictionary).get("scale", 1)))
                if pos.x < node.position.x - 10.0 * s or pos.x > node.position.x + 10.0 * s:
                        continue
                if pos.y < node.position.y - float(d.CHAR_H * s) - 6.0 \
                                or pos.y > node.position.y + 4.0:
                        continue
                return foe
        return {}

## Ближайший живой враг перед героем в конусе удара (шаг 18).
## range_px: своя дальность поиска (шаг 29 — пинок варвара бьёт дальше
## меча); по умолчанию — дальность удара сцены (STRIKE_RANGE).
static func living_foe_in_front(d, dir: Vector2, range_px: float = -1.0) -> Dictionary:
        var reach: float = range_px if range_px > 0.0 else d.STRIKE_RANGE
        var best: Dictionary = {}
        var best_d: float = reach
        for foe in d._foes:
                if bool(foe.get("dead", false)):
                        continue
                var node: Node2D = foe["node"]
                var to: Vector2 = node.position - d.player.position
                var dist := to.length()
                if dist > best_d:
                        continue
                if dist > 1.0 and dir.dot(to.normalized()) < 0.2:
                        continue
                best_d = dist
                best = foe
        return best

## Ходы противников: спят, пока герой не подойдёт (радиус aggro), потом
## преследуют. Колдуны (ranged) держат дистанцию и швыряют болты,
## остальные бьются вплотную. Босс ждёт диалога — и только потом дерётся.
static func update_foes(d, delta: float) -> void:
        if d.player == null:
                return
        for foe in d._foes:
                if bool(foe.get("dead", false)):
                        continue
                if bool(foe.get("thrown", false)):
                        continue   # варвар кинул врага — им управляет полёт (шаг 18)
                var def: Dictionary = foe["def"]
                var node: Node2D = foe["node"]
                var spr: AnimatedSprite2D = foe["sprite"]
                var now_ms := Time.get_ticks_msec()
                # шаг 32: яд и горение тикают всегда (даже оглушённые горят)
                FoeFx.tick_effects(d, foe, delta)
                if int(foe.get("stun_until", 0)) > now_ms:
                        spr.play("idle_down")
                        continue   # оглушён броском варвара (шаг 18)
                # шаг 32: страх — враг бросает бой и бежит от героя
                if FoeFx.flee_from_hero(d, foe, delta):
                        continue
                if int(foe.get("blind_until", 0)) > now_ms:
                        foe["aggro"] = false
                        spr.play("idle_down")
                        continue   # ослеплён пылью бомжа: не видит и не бьёт (шаг 18)
                # шаг 32: замедление тёмным оружием — скорость режется
                var speed_mult := FoeFx.speed_mult(foe, now_ms)
                # шаг 31: безумие Некроманта — моб бьёт СВОИХ (других мобов этажа)
                if int(foe.get("mad_until", 0)) > now_ms:
                        update_mad_foe(d, foe, delta)
                        continue
                if foe.has("mad_until"):
                        foe.erase("mad_until")
                        spr.modulate = Color.WHITE   # безумие кончилось — к норме
                foe["atk_cd"] = maxf(0.0, float(foe["atk_cd"]) - delta)
                foe["bolt_cd"] = maxf(0.0, float(foe["bolt_cd"]) - delta)
                # босс мирен, пока не прозвучали его реплики
                if bool(foe.get("boss", false)) and not d._boss_hostile:
                        var to_boss: Vector2 = d.player.position - node.position
                        if absf(to_boss.x) >= absf(to_boss.y):
                                spr.play("idle_side")
                                spr.flip_h = to_boss.x < 0.0
                        else:
                                spr.play("idle_down" if to_boss.y > 0.0 else "idle_up")
                        continue
                if String(foe.get("id", "")) == "boss_cthulhu":
                        BossAi.update_cthulhu(d, foe, def, delta)   # шаг 21: тактика Ктулху
                elif String(foe.get("id", "")) == "boss_shub":
                        BossAi.update_shub(d, foe, def, delta)      # шаг 24: тактика Шуб-Ниггурат
                var to: Vector2 = d.player.position - node.position
                var dist := to.length()
                if not bool(foe["aggro"]):
                        if dist < float(def["aggro"]) and Game.hp > 0 and not d._player_dead:
                                foe["aggro"] = true
                                HudBuilder.show_hint(d, String(d.AGGRO_HINT) % String(foe.get("title",
                                        def.get("name", "Враг"))), 2.2)
                        else:
                                spr.play("idle_down")
                                continue
                if Game.hp <= 0 or d._player_dead:
                        spr.play("idle_down")
                        continue
                if bool(def.get("ranged", false)):
                        # колдун: держит дистанцию, швыряет болты
                        var keep := float(def.get("keep_distance", 90.0))
                        var moved := false
                        if dist > keep + 24.0:
                                move_foe(d, node, to.normalized(), float(def["speed"]) * speed_mult, delta)
                                moved = true
                        elif dist < keep - 24.0:
                                move_foe(d, node, -to.normalized(), float(def["speed"]) * 0.7 * speed_mult, delta)
                                moved = true
                        if moved:
                                foe_anim(spr, to)
                        elif absf(to.x) >= absf(to.y):
                                spr.play("idle_side")
                                spr.flip_h = to.x < 0.0
                        else:
                                spr.play("idle_down" if to.y > 0.0 else "idle_up")
                        if dist <= float(def["attack_range"]) and float(foe["bolt_cd"]) <= 0.0:
                                foe["bolt_cd"] = float(def.get("attack_cd", 1.8))
                                StrikeFx.spawn_foe_bolt(d, d._fx, foe, def)
                else:
                        # ближний бой: догнать и бить
                        # шаг 27: во время телеграфа враг замирает — удар читается
                        if Combat.telegraph_pending(foe):
                                spr.play("idle_down")
                                continue
                        if dist > float(def["attack_range"]) * 0.8:
                                move_foe(d, node, to.normalized(),
                                        float(foe.get("speed_override", float(def["speed"]))) * speed_mult, delta)
                                foe_anim(spr, to)
                        else:
                                spr.play("idle_down")
                        if dist <= float(def["attack_range"]) and float(foe["atk_cd"]) <= 0.0:
                                # шаг 27: телеграф атаки — приседание/замах за 0.35-0.45 с
                                if not Combat.telegraph_ready(foe):
                                        Combat.begin_telegraph(d, foe, bool(foe.get("elite", false)))
                                        continue
                                Combat.end_telegraph(d, foe)
                                foe["atk_cd"] = float(foe.get("attack_cd_override",
                                        def.get("attack_cd", 1.1)))
                                foe_attack(d, foe)

static func foe_anim(spr: AnimatedSprite2D, to: Vector2) -> void:
        if absf(to.x) >= absf(to.y):
                spr.play("walk_side")
                spr.flip_h = to.x < 0.0
        else:
                spr.play("walk_down" if to.y > 0.0 else "walk_up")

## Безумый моб (шаг 31, T Некроманта): 10 секунд бьёт СОБРАТЬЕВ — ближайшего
## другого живого моба этажа. Боссов и союзников не трогает; награда за
## убийство идёт как обычно (через _hit_foe хоста).
static func update_mad_foe(d, foe: Dictionary, delta: float) -> void:
        var node: Node2D = foe["node"]
        var spr: AnimatedSprite2D = foe["sprite"]
        foe["atk_cd"] = maxf(0.0, float(foe["atk_cd"]) - delta)
        if spr.modulate != MAD_TINT:
                spr.modulate = MAD_TINT   # краснеет от безумия
        var target: Dictionary = {}
        var best_d := MADNESS_SIGHT
        var foe_node: Node2D = foe["node"]
        for other in d._foes:
                if (other["node"] as Node2D) == foe_node \
                                or bool(other.get("dead", false)) \
                                or bool(other.get("thrown", false)):
                        continue
                var dist: float = (other["node"] as Node2D).position \
                        .distance_to(node.position)
                if dist < best_d:
                        best_d = dist
                        target = other
        if target.is_empty():
                spr.play("idle_down")
                return
        var tnode: Node2D = target["node"]
        var to := tnode.position - node.position
        var reach := float((foe["def"] as Dictionary).get("attack_range", 16.0))
        if to.length() > reach * 0.8:
                move_foe(d, node, to.normalized(), float(foe["def"]["speed"]), delta)
                foe_anim(spr, to)
        else:
                spr.play("idle_down")
                spr.flip_h = tnode.position.x < node.position.x
        if to.length() <= reach and float(foe["atk_cd"]) <= 0.0:
                foe["atk_cd"] = float((foe["def"] as Dictionary).get("attack_cd", 1.1))
                StrikeFx.swing(d, d._fx, tnode.position + Vector2(0, -10),
                        Color(0.9, 0.35, 0.25))
                Sfx.play("swing", -4.0)
                d._hit_foe(target, maxi(1, int(foe.get("dmg", 1))), false)

## Движение врага по осям с проверкой стен (как ИИ демона в мире).
static func move_foe(d, node: Node2D, dirv: Vector2, speed: float,
                delta: float) -> void:
        if dirv == Vector2.ZERO:
                return
        var step := speed * delta
        var nx: Vector2 = node.position + Vector2(dirv.x, 0.0) * step
        if not d._tile_is_solid(nx + Vector2(0, -8)):
                node.position.x = nx.x
        var ny: Vector2 = node.position + Vector2(0.0, dirv.y) * step
        if not d._tile_is_solid(ny + Vector2(0, -8)):
                node.position.y = ny.y

## Атака вплотную: урон герою, взмах, вспышка (как когти демона в мире).
## Урон берётся из записи врага: у элиты он усилен (шаг 15).
## Шаг 27: удар уважает i-frames героя; герой ушёл за время замаха —
## враг промахивается (награда за рывок/внимательность).
## Шаг 31: если рядом с врагом стоит союзник-призыв (демон/мертвец) и он
## БЛИЖЕ героя — удар принимает союзник: демоны дерутся за героя телом.
static func foe_attack(d, foe: Dictionary) -> void:
        if Combat.attack_missed(d, foe):
                Sfx.play("swing", -4.0)   # враг бьёт воздух
                return
        var damage := maxi(1, int(foe.get("dmg", 1)))
        # шаг 31: перехват удара союзником; синтетические записи тестов
        # без "def"/"node" бьют героя как раньше (дальности по умолчанию)
        var fdef: Dictionary = foe.get("def", {})
        var fnode: Node2D = foe.get("node")
        if fnode != null:
                var reach: float = float(fdef.get("attack_range", 16.0)) * 1.2
                if Minions.intercept(d, fnode.position, reach, damage):
                        return
        Game.damage_hp(damage, true)
        Sfx.play_variant("hurt")
        StrikeFx.swing(d, d._fx, d.player.position + Vector2(0, -10),
                Color(0.9, 0.3, 0.25))
        StrikeFx.damage_label(d, d._fx, d.player.position + Vector2(0, -40),
                damage, true)
        StrikeFx.poof(d, d._fx, d.player.position + Vector2(0, -14),
                Color(0.85, 0.3, 0.25))
        StrikeFx.hit_impact(d, d._fx, d.player.position + Vector2(0, -14),
                Color(0.9, 0.35, 0.3))
        d._flash_player()

## Отброс врага от удара (шаг 20): на пару пикселей от героя, сквозь
## стены не проходит; боссов и летящих врагов не трогает.
static func knockback_foe(d, foe: Dictionary, distance: float) -> void:
        if bool(foe.get("boss", false)) or bool(foe.get("thrown", false)):
                return
        var node: Node2D = foe["node"]
        var away: Vector2 = (node.position - d.player.position).normalized()
        if away == Vector2.ZERO:
                away = Vector2(0, 1)
        var back: Vector2 = node.position + away * distance
        if not d._tile_is_solid(back):
                node.position = back

# ------------------------------------ щупальца из стен (данжи 3-4, шаг 22)

## Вылазка щупальца: НЕУЯЗВИМЫЙ и незаблокирующий хазард — не в _foes,
## кликом не выделяется, бьёт с предупреждением и прячется обратно.
static func update_wall_tentacles(d, delta: float) -> void:
        if d.player == null or d._player_dead:
                return
        # спавн по таймеру: только в данжах 3 и 4 (в 4-м — чаще: они «дома»)
        if d._dungeon_id != "dungeon_3" and d._dungeon_id != "dungeon_4":
                return
        d._tentacle_timer -= delta
        if d._tentacle_timer <= 0.0:
                spawn_wall_tentacle(d)
                d._tentacle_timer = randf_range(d.TENTACLE_MIN_INTERVAL_4, d.TENTACLE_MAX_INTERVAL_4) \
                        if d._dungeon_id == "dungeon_4" \
                        else randf_range(d.TENTACLE_MIN_INTERVAL, d.TENTACLE_MAX_INTERVAL)
        # жизнь активных щупалец: предупреждение -> удар -> отступление
        var now_ms := Time.get_ticks_msec()
        for i in range(d._wall_tentacles.size() - 1, -1, -1):
                var rec: Dictionary = d._wall_tentacles[i]
                var node: Node2D = rec["node"]
                var t := float(now_ms - int(rec["born"])) / 1000.0
                # выдвижение: рост из стены
                var grow := clampf(t / 0.5, 0.0, 1.0)
                (node.get_child(1) as Sprite2D).scale = \
                        (rec["base_scale"] as Vector2) * grow
                if t >= float(rec["slam_in"]) and not bool(rec["slammed"]):
                        rec["slammed"] = true
                        wall_tentacle_slam(d, rec)
                if t >= d.TENTACLE_LIFE:
                        # отступление: щупальце уходит обратно в камень
                        var tw: Tween = d.create_tween()
                        tw.tween_property(node, "scale", Vector2(0.05, 0.05), 0.45) \
                                .set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
                        tw.tween_callback(func() -> void:
                                if is_instance_valid(node):
                                        node.queue_free())
                        d._wall_tentacles.remove_at(i)

## Спавн щупальца у стены рядом с героем (2..8 тайлов, из стены в пол).
static func spawn_wall_tentacle(d) -> void:
        var ptile := Vector2i(int(floor(d.player.position.x / 16.0)),
                int(floor(d.player.position.y / 16.0)))
        var best := Vector2i(-1, -1)
        var wall_t := Vector2i(-1, -1)
        for attempt in range(40):
                var dx := randi_range(-8, 8)
                var dy := randi_range(-8, 8)
                var t: Vector2i = ptile + Vector2i(dx, dy)
                var dist := float(Vector2(t - ptile).length())
                if dist < 2.5 or dist > 8.0:
                        continue
                if t.x < 1 or t.y < 1 or t.x >= DungeonBestiary.MAP_W - 1 \
                                or t.y >= DungeonBestiary.MAP_H - 1:
                        continue
                if d._tile_is_solid(Vector2(t.x * 16.0 + 8.0, t.y * 16.0 + 8.0)):
                        continue
                # ищем стену-соседа: щупальце лезет ИЗ стены
                for off: Vector2i in [Vector2i(0, -1), Vector2i(0, 1), Vector2i(-1, 0), Vector2i(1, 0)]:
                        var n: Vector2i = t + off
                        if n.x < 0 or n.y < 0 or n.x >= DungeonBestiary.MAP_W \
                                        or n.y >= DungeonBestiary.MAP_H:
                                continue
                        if String(d._grid[n.y][n.x]) == "#":
                                best = t
                                wall_t = n
                                break
                if best.x >= 0:
                        break
        if best.x < 0:
                return
        var center := Vector2(best.x * 16.0 + 8.0, best.y * 16.0 + 8.0)
        var node := Node2D.new()
        node.name = "WallTentacle_%d_%d" % [best.x, best.y]
        node.position = center
        node.z_index = 9
        var spr := Sprite2D.new()
        spr.texture = load(d.TENTACLE_TEX_PATH)
        # ориентация: жало торчит ОТ стены в пол
        var toward := Vector2(best - wall_t)
        spr.rotation = Vector2(0, -1).angle_to(Vector2(toward))
        spr.position = Vector2(0, -10)
        spr.modulate = Color(0.85, 0.95, 0.8)
        node.add_child(spr)
        var glow := Sprite2D.new()
        glow.texture = d._glow_tex
        glow.material = d._glow_mat
        glow.scale = Vector2(1.4, 1.4)
        glow.modulate = Color(0.35, 0.7, 0.4, 0.4)
        node.add_child(glow)
        node.move_child(glow, 0)
        node.scale = Vector2(0.05, 0.05)
        d._level_root.add_child(node)
        var warn := Sprite2D.new()
        warn.texture = d._glow_tex
        warn.material = d._glow_mat
        warn.position = center
        warn.scale = Vector2(0.6, 0.6)
        warn.modulate = Color(0.85, 0.3, 0.12, 0.35)
        warn.z_index = 8
        d._fx.add_child(warn)
        var wt: Tween = warn.create_tween().set_loops()
        wt.tween_property(warn, "modulate:a", 0.75, 0.2)
        wt.tween_property(warn, "modulate:a", 0.3, 0.2)
        d._wall_tentacles.append({"node": node, "pos": center,
                "born": Time.get_ticks_msec(),
                "slam_in": d.TENTACLE_TELL + 0.4, "slammed": false, "warn": warn,
                "base_scale": Vector2(1.5, 1.5)})
        if not d._tentacle_hint_shown:
                d._tentacle_hint_shown = true
                HudBuilder.show_hint(d, d.TENTACLE_HINT_FIRST, 4.5)
        else:
                HudBuilder.show_hint(d, d.TENTACLE_HINT, 2.0)
        Sfx.play("slam", -10.0)

## Удар щупальца: мокрый звук, тряска, урон в радиусе круга.
static func wall_tentacle_slam(d, rec: Dictionary) -> void:
        if rec.has("warn") and is_instance_valid(rec["warn"]):
                (rec["warn"] as Sprite2D).queue_free()
        var pos: Vector2 = rec["pos"]
        Sfx.play("slam", -4.0)
        d._shake_camera(2.6, 0.25)
        StrikeFx.ring(d, d._fx, pos, Color(0.35, 0.6, 0.4), 2.0)
        for k in range(5):
                var ang := TAU * float(k) / 5.0
                StrikeFx.poof(d, d._fx, pos + Vector2(cos(ang), sin(ang)) * 10.0,
                        Color(0.3, 0.52, 0.38))
        if Game.hp > 0 and not d._player_dead \
                        and d.player.position.distance_to(pos) <= d.TENTACLE_RADIUS + 6.0:
                Game.damage_hp(d.TENTACLE_DMG, true)   # шаг 27: i-frames
                Sfx.play_variant("hurt")
                d._flash_player()
                StrikeFx.hit_impact(d, d._fx, d.player.position + Vector2(0, -14),
                        Color(0.5, 0.75, 0.55))
                StrikeFx.damage_label(d, d._fx, d.player.position + Vector2(0, -40),
                        d.TENTACLE_DMG, true)

# ----------------------------------------------- демон мира (шаги 12/13/18)

## ИИ демона в мире (спит до ярости): преследует героя, бьёт когтями
## раз в DEMON_ATTACK_CD секунд. Ослеплён пылью бомжа — не видит и не бьёт.
## Шаг 27: телеграф — демон замахивается за 0.45 с до когтей, замирая;
## герой ушёл — когти бьют воздух; удар уважает i-frames.
static func update_demon(w, delta: float) -> void:
        if w.player == null or not Game.demon_enraged or Game.hp <= 0:
                return
        var demon: Dictionary = w._demon_record()
        if demon.is_empty():
                return
        var node: Node2D = demon["node"]
        var spr: AnimatedSprite2D = demon["sprite"]
        # шаг 32: яд и горение тикают и на демоне мира
        FoeFx.tick_effects(w, demon, delta)
        # шаг 32: оглушение (вой оборотня) — демон замирает
        if int(demon.get("stun_until", 0)) > Time.get_ticks_msec():
                spr.play("idle_down")
                return
        # шаг 32: страх — демон бросает погоню и убегает
        if FoeFx.flee_from_hero(w, demon, delta):
                return
        # шаг 18: ослеплён пылью бомжа — не видит героя, не гонится и не бьёт
        if int(demon.get("blind_until", 0)) > Time.get_ticks_msec():
                spr.play("idle_down")
                return
        # шаг 27: во время телеграфа демон замирает
        if Combat.telegraph_pending(demon):
                spr.play("idle_down")
                return
        var to: Vector2 = w.player.position - node.position
        demon["atk_cd"] = maxf(0.0, float(demon.get("atk_cd", 0.0)) - delta)
        if to.length() > w.DEMON_ATTACK_RANGE * 0.8:
                var dirv := to.normalized()
                var step: float = w.DEMON_SPEED * delta
                var nx: Vector2 = node.position + Vector2(dirv.x, 0.0) * step
                if not w._tile_is_solid(nx):
                        node.position.x = nx.x
                var ny: Vector2 = node.position + Vector2(0.0, dirv.y) * step
                if not w._tile_is_solid(ny):
                        node.position.y = ny.y
                if absf(dirv.x) >= absf(dirv.y):
                        spr.play("walk_side")
                        spr.flip_h = dirv.x < 0.0
                else:
                        spr.play("walk_down" if dirv.y > 0.0 else "walk_up")
        else:
                spr.play("idle_down")
        if to.length() <= w.DEMON_ATTACK_RANGE and float(demon.get("atk_cd", 0.0)) <= 0.0:
                # шаг 27: телеграф атаки — красный замах
                if not Combat.telegraph_ready(demon):
                        Combat.begin_telegraph(w, demon, true)
                        return
                Combat.end_telegraph(w, demon)
                demon["atk_cd"] = w.DEMON_ATTACK_CD
                if w.player.position.distance_to(node.position) > w.DEMON_ATTACK_RANGE * 1.45:
                        Sfx.play("swing", -4.0)   # герой отпрыгнул — промах
                        return
                Game.damage_hp(w.DEMON_DAMAGE, true)
                Sfx.play_variant("hurt")
                StrikeFx.swing(w, w._world, w.player.position + Vector2(0, -10),
                        Color(0.9, 0.3, 0.25), 10)
                StrikeFx.damage_label(w, w._world, w.player.position + Vector2(0, -40),
                        w.DEMON_DAMAGE)
                StrikeFx.poof(w, w._world, w.player.position + Vector2(0, -14),
                        Color(0.85, 0.3, 0.25), 10)
                StrikeFx.hit_impact(w, w._world, w.player.position + Vector2(0, -14),
                        Color(0.9, 0.35, 0.3), 10)

## Minions — компонент союзников-призывов (шаг 31: Демоноолог и Некромант).
## Демоны Демоноолога и армия/босс Некроманта ходят за героем, дерутся
## с его врагами и не мешают движению (тела нет — герой проходит сквозь).
## Работает в ОБЕИХ сценах (мир и данж): различия — через контракт хоста:
##  - host.player, host._minions, host._entities;
##  - host._make_frames(tex, fw, fh), host._add_shadow(node, scale),
##    host._tile_is_solid(pos), host._show_hint, host._spell_poof(pos, c);
##  - host._minion_strike_enemy(rec, dmg) — удар врага средствами сцены
##    (данж: _hit_foe, мир: _hit_npc);
##  - host._enemy_records() — живые враги сцены (данж: _foes, мир: демон
##    в ярости + Королева в бою);
##  - host._minion_slot_cd(slot, cd) — кулдаун на кнопку призыва.
## Состояние призывов живёт в Game (summons_active/necro_army), поэтому
## при переходе мир<->данж призывы пересобираются сценой через restore.
class_name Minions
extends RefCounted

const FOLLOW_DIST := 26.0     # строй: дистанция около героя
const CHASE_RANGE := 150.0    # радиус, в котором союзник сам видит врага
const TELEPORT_DIST := 240.0  # отстал дальше — телепорт к герою
const ALLY_IFRAMES_MS := 350  # мигание после получения урона (мс)

## Смещения строя вокруг героя (по индексу союзника).
const RALLY_OFFSETS := [
    Vector2(-26, -4), Vector2(26, -4), Vector2(-38, 12), Vector2(38, 12),
    Vector2(0, -34), Vector2(-20, 22), Vector2(20, 22), Vector2(0, 26),
]

## Родитель эффектов в сцене (в данже — _fx, в мире — _world).
static func fx_of(host) -> Node:
    var fx: Variant = host.get("_fx")
    if fx != null:
        return fx
    return host.get("_world")

# ------------------------------------------------------------------ спавн

## Создать узел союзника по записи rec (build_summon_rec/build_undead_rec/
## build_boss_rec) и поставить его в строй. Возвращает запись ally.
static func spawn_ally(host, rec: Dictionary) -> Dictionary:
    var fw := maxi(1, int(rec.get("frame_w", 24)))
    var fh := maxi(1, int(rec.get("frame_h", 32)))
    var node := Node2D.new()
    node.name = "Ally_%s" % String(rec.get("id", "unit"))
    node.position = rally_pos(host, host._minions.size())
    host._add_shadow(node, 0.9 * (float(fw) / 24.0))
    var spr := AnimatedSprite2D.new()
    spr.sprite_frames = host._make_frames(load(String(rec["sheet"])), fw, fh)
    spr.position = Vector2(0, -fh / 2.0 + 3.0)
    spr.scale = Vector2(1.18, 1.18) if fh <= 32 else Vector2(1.0, 1.0)
    spr.modulate = ally_tint(rec)
    spr.play("idle_down")
    node.add_child(spr)
    var hp := maxi(1, int(rec["hp"]))
    var bar_w := 24.0 * (float(fw) / 24.0)
    var hp_bar := ProgressBar.new()
    hp_bar.min_value = 0
    hp_bar.max_value = hp
    hp_bar.value = hp
    hp_bar.show_percentage = false
    hp_bar.custom_minimum_size = Vector2(bar_w, 4)
    hp_bar.size = Vector2(bar_w, 4)
    hp_bar.position = Vector2(-bar_w / 2.0, -float(fh) - 4)
    hp_bar.visible = false
    hp_bar.add_theme_stylebox_override("background",
        HudBuilder.bar_style(Color(0.09, 0.08, 0.1), Color(0.18, 0.4, 0.22)))
    hp_bar.add_theme_stylebox_override("fill",
        HudBuilder.bar_style(Color(0.34, 0.72, 0.4), Color(0.34, 0.72, 0.4)))
    node.add_child(hp_bar)
    host._entities.add_child(node)
    var ally := {
        "kind": String(rec.get("kind", "summon")),      # summon/undead/boss
        "summon_id": String(rec.get("summon_id", "")),
        "slot": String(rec.get("slot", "")),
        "title": String(rec.get("title", "Союзник")),
        "node": node, "sprite": spr, "hp_bar": hp_bar,
        "hp": hp, "max_hp": hp,
        "dmg": maxi(1, int(rec.get("damage", 1))),
        "speed": float(rec.get("speed", 80.0)),
        "attack_range": float(rec.get("attack_range", 18.0)),
        "attack_cd": float(rec.get("attack_cd", 1.0)),
        "atk_cd": 0.0, "flash_until": 0,
        "tint": rec.get("tint", Color.WHITE),
        "sheet_path": String(rec.get("sheet", "")),
        "frame_w": fw, "frame_h": fh,
    }
    if rec.has("until"):
        ally["until"] = int(rec["until"])
    host._minions.append(ally)
    return ally

## Постоянный оттенок союзника (после вспышки урона им восстанавливается).
static func ally_tint(rec: Dictionary) -> Color:
    match String(rec.get("kind", "summon")):
        "undead":
            return Color(0.72, 0.95, 0.78)   # поднятые мертвецы зеленеют
        "boss":
            return Color(0.86, 0.78, 1.0)    # призванный босс — лиловый
        _:
            return rec.get("tint", Color.WHITE)

## Точка в строю: смещение вокруг героя, не в стене.
static func rally_pos(host, idx: int) -> Vector2:
    if host.player == null:
        return Vector2.ZERO
    var base: Vector2 = (host.player as Node2D).position
    for i in range(RALLY_OFFSETS.size()):
        var off: Vector2 = RALLY_OFFSETS[(idx + i) % RALLY_OFFSETS.size()]
        var candidate := base + off
        if not host._tile_is_solid(candidate + Vector2(0, -8)):
            return candidate
    return base   # всё занято — встаёт прямо у ног героя

## Запись призыва Демоноолога (из Game.DEMON_SUMMONS с масштабом уровня).
static func build_summon_rec(summon_id: String, slot: String, hp: int) -> Dictionary:
    var def: Dictionary = Game.DEMON_SUMMONS.get(summon_id, {})
    return {
        "kind": "summon", "summon_id": summon_id, "slot": slot,
        "id": summon_id, "title": String(def.get("title", "Демон")),
        "sheet": String(def.get("sheet", "")),
        "frame_w": int(def.get("frame_w", 24)),
        "frame_h": int(def.get("frame_h", 32)),
        "hp": hp, "damage": Game.summon_damage(summon_id),
        "speed": float(def.get("speed", 80.0)),
        "attack_range": float(def.get("attack_range", 18.0)),
        "attack_cd": float(def.get("attack_cd", 1.0)),
        "tint": def.get("tint", Color.WHITE),
    }

## Запись поднятого врага (Некромант Q) из определения врага данжа.
static func build_undead_rec(def: Dictionary, hp: int) -> Dictionary:
    var dmg := maxi(1, int(round(float(def.get("damage", 1))
        * Game.hero_level_mult())))
    return {
        "kind": "undead", "id": String(def.get("id", "undead")),
        "title": "Мёртвый %s" % String(def.get("name", "враг")),
        "sheet": String(def.get("sheet", "")),
        "frame_w": 24, "frame_h": 32,
        "hp": hp, "damage": dmg,
        "speed": float(def.get("speed", 70.0)),
        "attack_range": float(def.get("attack_range", 16.0)),
        "attack_cd": float(def.get("attack_cd", 1.1)),
    }

## Запись призванного босса (Некромант Ctrl; «первый босс» — Таинственный
## демон, DungeonBestiary.boss_for("dungeon_1")); живёт до until_ms.
static func build_boss_rec(until_ms: int) -> Dictionary:
    var def: Dictionary = DungeonBestiary.boss_for("dungeon_1")
    var s := maxi(1, int(def.get("scale", 3)))
    var hp := maxi(1, int(round(float(def.get("hp", 100)) * Game.hero_level_mult())))
    return {
        "kind": "boss", "id": String(def.get("id", "boss")),
        "title": String(def.get("name", "Босс")),
        "sheet": String(def.get("sheet", "")),
        "frame_w": 24 * s, "frame_h": 32 * s,
        "hp": hp, "damage": maxi(1, int(round(float(def.get("damage", 10))
            * Game.hero_level_mult()))),
        "speed": 70.0, "attack_range": 30.0, "attack_cd": 1.2,
        "until": until_ms,
    }

# ------------------------------------------------------- тумблер призыва

## Нажатие кнопки призыва Демоноолога: вызвал / отпустил / отказ.
## Отпуск — без кулдауна и без возврата маны; отказ — без списания.
static func toggle_summon(host, info: Dictionary) -> void:
    var summon_id := String(info.get("summon", ""))
    if summon_id.is_empty() or host.player == null:
        return
    var def: Dictionary = Game.DEMON_SUMMONS.get(summon_id, {})
    var title := String(def.get("title", "Демон"))
    if Game.summons_active.has(summon_id):
        # повторное нажатие — демон уходит (кулдауна нет)
        for ally in host._minions.duplicate():
            if String(ally.get("summon_id", "")) == summon_id:
                depart_ally(host, ally)
        Game.summons_active.erase(summon_id)
        host._show_hint("%s возвращается в бездну" % title, 1.8)
        return
    var cd_left := Game.summon_cd_left(summon_id)
    if cd_left > 0.0:
        host._show_hint("%s ещё не вернулся из бездны (%.0f с)"
            % [title, cd_left], 1.6)
        return
    var cost := int(info.get("mana_cost", 0))
    if Game.mana < cost:
        host._show_hint("Не хватает маны: нужно %d, у тебя %d"
            % [cost, Game.mana], 2.2)
        return
    Game.spend_mana(cost)
    var rec := build_summon_rec(summon_id, String(info.get("_slot", "q")),
        Game.summon_max_hp(summon_id))
    var ally := spawn_ally(host, rec)
    Game.summons_active[summon_id] = {"slot": rec["slot"], "hp": rec["hp"]}
    StrikeFx.poof(host, fx_of(host),
        (ally["node"] as Node2D).position + Vector2(0, -12),
        Color(0.85, 0.45, 0.35), 8)
    Sfx.play("bolt", -2.0, 0.06, 0.72)
    host._show_hint("%s призван! Повторное нажатие отпустит его" % title, 2.4)

# --------------------------------------------------------- жизнь союзника

## Тик всех союзников (из _physics_process сцены).
static func update_allies(host, delta: float) -> void:
    if host.player == null:
        return
    var now := Time.get_ticks_msec()
    for ally in host._minions.duplicate():
        var node: Node2D = ally["node"]
        var spr: AnimatedSprite2D = ally["sprite"]
        if not is_instance_valid(node):
            host._minions.erase(ally)
            continue
        # временные союзники (босс на 10 с) уходят по таймеру
        if ally.has("until") and now >= int(ally["until"]):
            if String(ally["kind"]) == "boss":
                Game.boss_summon_until = 0
            depart_ally(host, ally)
            host._show_hint("Зов иссяк — %s возвращается в смерть"
                % String(ally["title"]), 2.0)
            continue
        # гаснет вспышка урона
        if int(ally.get("flash_until", 0)) > 0 and int(ally["flash_until"]) <= now:
            ally["flash_until"] = 0
            spr.modulate = ally_tint(ally)
        ally["atk_cd"] = maxf(0.0, float(ally["atk_cd"]) - delta)
        var target := nearest_enemy(host, node.position, CHASE_RANGE)
        if target.is_empty():
            follow_hero(host, ally, delta)
            continue
        var tnode: Node2D = target["node"]
        var to := tnode.position - node.position
        var dist := to.length()
        var reach := float(ally["attack_range"])
        if dist > reach * 0.8:
            move_ally(host, node, to.normalized(), float(ally["speed"]), delta)
            anim_for(spr, to)
        else:
            spr.play("idle_down")
            spr.flip_h = tnode.position.x < node.position.x
        if dist <= reach and float(ally["atk_cd"]) <= 0.0:
            ally["atk_cd"] = float(ally["attack_cd"])
            host._minion_strike_enemy(target, int(ally["dmg"]))
            StrikeFx.swing(host, fx_of(host),
                tnode.position + Vector2(0, -10), Color(0.85, 0.5, 0.4), 8)

## Догнать героя и встать в строй.
static func follow_hero(host, ally: Dictionary, delta: float) -> void:
    var node: Node2D = ally["node"]
    var spr: AnimatedSprite2D = ally["sprite"]
    var home := rally_pos(host, host._minions.find(ally))
    var to := home - node.position
    if to.length() > TELEPORT_DIST:
        node.position = home   # отстал сильно — возвращается мгновенно
        return
    if to.length() > FOLLOW_DIST * 0.7:
        move_ally(host, node, to.normalized(), float(ally["speed"]), delta)
        anim_for(spr, to)
    else:
        spr.play("idle_down")
        spr.flip_h = (host.player as Node2D).position.x < node.position.x

## Движение союзника по осям с проверкой стен (как у врагов FoeAi.move_foe).
static func move_ally(host, node: Node2D, dirv: Vector2, speed: float,
        delta: float) -> void:
    if dirv == Vector2.ZERO:
        return
    var step := speed * delta
    var nx: Vector2 = node.position + Vector2(dirv.x, 0.0) * step
    if not host._tile_is_solid(nx + Vector2(0, -8)):
        node.position.x = nx.x
    var ny: Vector2 = node.position + Vector2(0.0, dirv.y) * step
    if not host._tile_is_solid(ny + Vector2(0, -8)):
        node.position.y = ny.y

static func anim_for(spr: AnimatedSprite2D, to: Vector2) -> void:
    if absf(to.x) >= absf(to.y):
        spr.play("walk_side")
        spr.flip_h = to.x < 0.0
    else:
        spr.play("walk_down" if to.y > 0.0 else "walk_up")

## Ближайший живой враг сцены в радиусе radius от точки (через хост).
static func nearest_enemy(host, from_pos: Vector2, radius: float) -> Dictionary:
    var best: Dictionary = {}
    var best_d := radius
    for rec in host._enemy_records():
        if bool(rec.get("dead", false)):
            continue
        var node: Node2D = rec["node"]
        var d: float = node.position.distance_to(from_pos)
        if d < best_d:
            best_d = d
            best = rec
    return best

# -------------------------------------------------------- урон и смерть

## Урон союзнику от врага (перехват атаки). Возвращает true, если умер.
static func damage_ally(host, ally: Dictionary, damage: int) -> bool:
    if bool(ally.get("dying", false)):
        return false
    ally["hp"] = maxi(0, int(ally["hp"]) - maxi(1, damage))
    var node: Node2D = ally["node"]
    var bar: ProgressBar = ally["hp_bar"]
    bar.max_value = int(ally["max_hp"])
    bar.value = int(ally["hp"])
    bar.visible = true
    ally["flash_until"] = Time.get_ticks_msec() + ALLY_IFRAMES_MS
    var spr: AnimatedSprite2D = ally["sprite"]
    spr.modulate = Color(1.0, 0.4, 0.4)
    StrikeFx.damage_label(host, fx_of(host),
        node.position + Vector2(0, -34), damage, true)
    if int(ally["hp"]) <= 0:
        kill_ally(host, ally)
        return true
    return false

## Смерть союзника: демон ставит кулдаун своей кнопке, армия просто тает.
static func kill_ally(host, ally: Dictionary) -> void:
    ally["dying"] = true
    var node: Node2D = ally["node"]
    StrikeFx.poof(host, fx_of(host), node.position + Vector2(0, -12),
        Color(0.75, 0.3, 0.3), 8)
    StrikeFx.ring(host, fx_of(host), node.position + Vector2(0, -10),
        Color(0.85, 0.4, 0.35), 1.4)
    Sfx.play_variant("die")
    var summon_id := String(ally.get("summon_id", ""))
    match String(ally["kind"]):
        "summon":
            Game.summons_active.erase(summon_id)
            Game.start_summon_cd(summon_id)
            var cd := float(Game.DEMON_SUMMONS.get(summon_id, {}) \
                .get("respawn_cd", 20.0))
            host._minion_slot_cd(String(ally.get("slot", "q")), cd)
            host._show_hint("%s пал! Кнопка призыва на %.0f с" \
                % [String(ally["title"]), cd], 2.6)
        "undead":
            Game.necro_army.erase(ally.get("army_ref", {}))
    remove_ally(host, ally)

## Отпуск/истечение: союзник уходит мирно, без кулдауна.
static func depart_ally(host, ally: Dictionary) -> void:
    var node: Node2D = ally["node"]
    StrikeFx.poof(host, fx_of(host), node.position + Vector2(0, -12),
        Color(0.62, 0.42, 0.95), 8)
    remove_ally(host, ally)

static func remove_ally(host, ally: Dictionary) -> void:
    host._minions.erase(ally)
    var node: Node2D = ally.get("node")
    if node != null and is_instance_valid(node):
        node.queue_free()

# ------------------------------------------------------- армия Некроманта

## Поднять врага в армию (Некромант Q): запись пишется в Game.necro_army,
## союзник появляется на месте трупа (corpse_pos).
static func raise_undead(host, foe_def: Dictionary, corpse_pos: Vector2) -> Dictionary:
    var hp := maxi(1, int(round(float(foe_def.get("hp", 10))
        * Game.hero_level_mult())))
    var rec := build_undead_rec(foe_def, hp)
    var entry := {"title": rec["title"], "def": foe_def.duplicate(true), "hp": hp}
    Game.necro_army.append(entry)
    var ally := spawn_ally(host, rec)
    ally["army_ref"] = entry
    (ally["node"] as Node2D).position = corpse_pos
    StrikeFx.poof(host, fx_of(host), corpse_pos + Vector2(0, -12),
        Color(0.45, 0.85, 0.55), 10)
    StrikeFx.ring(host, fx_of(host), corpse_pos + Vector2(0, -10),
        Color(0.4, 0.8, 0.5), 1.6)
    Sfx.play("bolt", -4.0, 0.05, 0.6)
    return ally

## Пересобрать союзников при входе в сцену (мир<->данж, призыв ходит с героем).
static func restore_allies(host) -> void:
    for summon_id in Game.summons_active.keys():
        var state: Dictionary = Game.summons_active[summon_id]
        var rec := build_summon_rec(String(summon_id),
            String(state.get("slot", "q")), maxi(1, int(state.get("hp", 10))))
        spawn_ally(host, rec)
    for entry in Game.necro_army:
        if not entry is Dictionary or (entry as Dictionary).is_empty():
            continue
        var rec := build_undead_rec(entry.get("def", {}),
            maxi(1, int(entry.get("hp", 10))))
        rec["title"] = String(entry.get("title", rec["title"]))
        var ally := spawn_ally(host, rec)
        ally["army_ref"] = entry
    if Game.boss_summon_until > Time.get_ticks_msec():
        spawn_ally(host, build_boss_rec(Game.boss_summon_until))

## Сохранить хп союзников в Game (при выходе из сцены).
static func stash_allies(host) -> void:
    for ally in host._minions:
        match String(ally["kind"]):
            "summon":
                var summon_id := String(ally.get("summon_id", ""))
                if Game.summons_active.has(summon_id):
                    Game.summons_active[summon_id]["hp"] = int(ally["hp"])
            "undead":
                var entry: Variant = ally.get("army_ref")
                if entry != null and (entry as Dictionary).is_empty() == false:
                    (entry as Dictionary)["hp"] = int(ally["hp"])

## Стереть союзников СЦЕНЫ (шаг 32): узлы этажа снесены, записи в _minions
## протухли. Состояние Game (summons_active/necro_army) НЕ трогается —
## после пересборки этажа restore_allies соберёт союзников заново.
static func clear_scene_allies(host) -> void:
    host._minions.clear()

## Перехват вражеской атаки союзником: ближайший союзник в радиусе удара
## врага и БЛИЖЕ героя получает удар вместо героя. Возвращает true, если
## удар перехвачен.
static func intercept(host, foe_pos: Vector2, reach: float,
        damage: int) -> bool:
    if host.player == null or host._minions.is_empty():
        return false
    var best: Dictionary = {}
    var best_d := reach
    for ally in host._minions:
        if bool(ally.get("dying", false)):
            continue
        var node: Node2D = ally["node"]
        var d: float = node.position.distance_to(foe_pos)
        if d < best_d:
            best_d = d
            best = ally
    if best.is_empty():
        return false
    var hero_d: float = (host.player as Node2D).position.distance_to(foe_pos)
    if hero_d <= best_d:
        return false   # герой ближе — враг бьёт героя, как раньше
    var node: Node2D = best["node"]
    StrikeFx.swing(host, fx_of(host), node.position + Vector2(0, -10),
        Color(0.9, 0.3, 0.25), 8)
    StrikeFx.poof(host, fx_of(host), node.position + Vector2(0, -12),
        Color(0.85, 0.3, 0.25), 6)
    Sfx.play_variant("hit")
    damage_ally(host, best, maxi(1, damage))
    return true

## Живых союзников у героя (для HUD и подсказок).
static func ally_count(host) -> int:
    var n := 0
    for ally in host._minions:
        if not bool(ally.get("dying", false)):
            n += 1
    return n

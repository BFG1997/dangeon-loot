## Combat — компонент боевой системы (шаг 27).
## «Бои перестают быть „маши F по кулдауну“»: разброс урона и криты,
## серия ударов (комбо), неуязвимость после урона (i-frames), рывок-
## уклонение, телеграфы атак врагов. Живая боевка мира и данжа зовёт
## одни и те же функции; константы — единые для обеих сцен.
##
## Случайность (разброс/крит/комбо-усиление) включается флагом
## Game.combat_variance. Сцены выставляют его в _ready через
## Game.under_test(self): в тестовом прогоне (сценарии res://tests/)
## урон детерминирован — проверки существующих шагов не меняются.
class_name Combat
extends RefCounted

# ------------------------------------------------------------- урон героя

const SPREAD := 0.15            # разброс урона ±15% от базового
const CRIT_CHANCE := 0.10       # 10% шанс крита
const CRIT_MULT := 2.0          # крит бьёт вдвое
const COMBO_WINDOW := 1.2       # окно серии быстрых ударов, сек
const COMBO_INDEX := 3          # третий подряд удар — усиленный
const COMBO_MULT := 1.5         # усиленный удар: х1.5 урона
const COMBO_COLOR := Color(1.0, 0.82, 0.3)   # дуга комбо — золотая

## Бросок урона героя: базовый урон -> {value, crit}.
## Порядок множителей: комбо (x1.5) -> разброс (±15%) -> крит (x2).
## allow_variance=false — детерминированный режим тестов: ровно base.
static func roll(base: int, combo_index: int = 0,
        allow_variance: bool = true) -> Dictionary:
    var value := maxi(1, base)
    var crit := false
    if allow_variance:
        if combo_index >= COMBO_INDEX:
            value = maxi(1, int(round(float(value) * COMBO_MULT)))
        value = maxi(1, int(round(float(value)
            * randf_range(1.0 - SPREAD, 1.0 + SPREAD))))
        crit = randf() < CRIT_CHANCE
        if crit:
            value = maxi(1, int(round(float(value) * CRIT_MULT)))
    return {"value": value, "crit": crit}

## Границы броска (для тестов): мин/макс урона при серии длиной combo_index.
static func roll_range(base: int, combo_index: int = 0) -> Vector2i:
    var value := float(maxi(1, base))
    if combo_index >= COMBO_INDEX:
        value = round(value * COMBO_MULT)
    return Vector2i(maxi(1, int(round(value * (1.0 - SPREAD)))),
        maxi(1, int(round(value * (1.0 + SPREAD) * CRIT_MULT))))

# --------------------------------------------------- неуязвимость (i-frames)

const IFRAMES_AFTER_HIT := 0.5  # мерцание героя после попадания, сек
const IFRAMES_DASH := 0.25      # i-frames рывка, сек

# ------------------------------------------------------------- рывок-уклонение

const DASH_CD := 2.0            # кулдаун рывка, сек
const DASH_TIME := 0.16         # длительность рывка, сек
const DASH_SPEED := 300.0       # ~48 px за рывок (план: 40-60 px)
const DASH_DOUBLE_TAP_MS := 250 # двойное нажатие направления = рывок

# ---------------------------------------- приём героя (шаг 29/30)

## У каждого героя СВОЙ приём (таблица ABILITIES[hero]["dash"]), с шага 30
## он на ПРОБЕЛЕ (действие "dash"):
##   воин    — прежний рывок-уклонение (кулдаун ужат до 1 с);
##   маг     — телепорт на то же расстояние (48 px), в стены нельзя:
##             суть тот же рывок, но анимация другая (миг-исчезновение);
##   бомж    — «Хмельной запал»: пьёт (не из инвентаря), мир зеленеет на
##             5 с и урон по герою эти 5 с не проходит; кулдаун 20 с;
##   варвар  — пинок: враг в конусе отлетает (кроме боссов) и получает
##             х1.5 от урона актуального удара; кулдаун 10 с.
## Двойной тап направления вызывает только приёмы-перемещения (dash/blink) —
## чтобы пинок и хмель не тратились случайно при ходьбе.
static func dash_kind() -> String:
    return String(Game.ability_info("dash").get("kind", "dash"))

static func start_dash(host, dir: Vector2 = Vector2.ZERO) -> bool:
    if host.player == null or bool(host.get("_player_dead")):
        return false
    if float(host.get("_dash_cd")) > 0.0 or float(host.get("_dash_time")) > 0.0:
        return false
    var move_dir := dir.normalized()
    if move_dir == Vector2.ZERO:
        move_dir = host._facing_vector()
    var info := Game.ability_info("dash")
    match dash_kind():
        "blink":
            return _blink(host, move_dir, info)
        "drink":
            return _drink(host, info)
        "kick":
            return host._ctrl_kick(move_dir, info)
        "pounce":
            # шаг 32: наброситься оборотня — прыжок на врага (съесть/босс)
            return host._werewolf_pounce(move_dir, info)
        "phase_dash":
            return _phase_dash(host, move_dir, info)
        "summon":
            # шаг 31: у Демоноолога на пробеле — призыв крылатого демона
            # (тумблер: кулдаун живёт в Game.summon_cd_until)
            Minions.toggle_summon(host, info)
            return true
        _:
            return _glide_dash(host, move_dir, info)

## Двойной тап направления: второй тап в пределах окна — рывок туда.
## Вызывается из _input сцены на КАЖДОЕ нажатие move_*. У героев, чей
## приём-перемещение на пробеле не является перемещением (бомж/варвар),
## двойной тап ничего не тратит — их приём только на пробеле.
## Шаг 31: фазовый рывок Некроманта — тоже перемещение; призывы Демоноолога
## двойным тапом не тратятся.
static func on_direction_tap(host, action: StringName) -> bool:
    var kind := dash_kind()
    if kind != "dash" and kind != "blink" and kind != "phase_dash":
        return false
    var now := Time.get_ticks_msec()
    var taps: Dictionary = host._last_dir_taps
    var last := int(taps.get(action, -1000000))
    taps[action] = now
    if now - last <= DASH_DOUBLE_TAP_MS:
        return start_dash(host, dir_action_vector(action))
    return false

static func dir_action_vector(action: StringName) -> Vector2:
    match action:
        &"move_left":
            return Vector2.LEFT
        &"move_right":
            return Vector2.RIGHT
        &"move_up":
            return Vector2.UP
        _:
            return Vector2.DOWN

# -------------------------------------- реализации приёма героя

## Рывок-уклонение воина (и прежнее поведение по двойному тапу).
static func _glide_dash(host, move_dir: Vector2, info: Dictionary) -> bool:
    host._dash_dir = move_dir
    host._dash_time = DASH_TIME
    host._dash_cd = maxf(0.1, float(info.get("cd", DASH_CD)))
    host._dash_ghost = 0.0
    Game.grant_iframes(IFRAMES_DASH)
    Sfx.play("dash", -2.0)
    return true

const BLINK_RANGE := DASH_SPEED * DASH_TIME   # 48 px — как рывок воина
const BLINK_STEP := 6.0                        # шаг отступа от стены, px
const PHASE_STEP := 4.0                        # шаг сканирования стены, px
const PHASE_MAX_RANGE := 96.0                  # потолок фазового рывка, px
const PHASE_EXIT_NUDGE := 5.0                  # выход из стены — вглубь свободной клетки

## Телепорт мага: мгновенный перенос на расстояние рывка в сторону взгляда
## или движения; в стены и за край нельзя — позиция ищется перебором
## с отступом. Если впереди глухая стена — приём не тратится (false).
static func _blink(host, move_dir: Vector2, info: Dictionary) -> bool:
    var fx: Node = host.get("_fx")
    if fx == null:
        fx = host.get("_world")
    var target := _first_free_blink_pos(host, move_dir)
    if target.is_finite():
        # шторка кулдауна идёт по _dash_cd; время рывка не нужно — перенос мгновенный
        host._dash_cd = maxf(0.1, float(info.get("cd", DASH_CD)))
        var from := (host.player as CharacterBody2D).position
        StrikeFx.poof(host, fx, from + Vector2(0, -10), Color(0.62, 0.42, 0.95), 6)
        host.player.position = target
        host.player.velocity = Vector2.ZERO
        Game.grant_iframes(IFRAMES_DASH)
        Sfx.play("dash", -4.0, 0.04, 1.4)   # выше тон — «пшик» портала
        StrikeFx.poof(host, fx, target + Vector2(0, -10), Color(0.8, 0.65, 1.0), 6)
        if host.has_method("_spawn_ring"):
            host._spawn_ring(target + Vector2(0, -10), Color(0.7, 0.5, 1.0), 1.4)
        return true
    return false   # стена в упор: приём не тратится

## Свободная точка для телепорта: от полного расстояния отступаем по 6 px
## до минимального; все варианты упёрлись в стены — INF (некуда).
static func _first_free_blink_pos(host, move_dir: Vector2) -> Vector2:
    var from: Vector2 = (host.player as CharacterBody2D).position
    var d := BLINK_RANGE
    while d >= BLINK_STEP:
        var candidate := from + move_dir * d
        if not host._blink_blocked_at(candidate):
            return candidate
        d -= BLINK_STEP
    return Vector2.INF

## Фазовый рывок Некроманта (шаг 31, пробел; шаг 32 — фикс застревания):
## проходит СКВОЗЬ стены и пол, но НЕ за край карты (out of bounds
## запрещён). Шаг 32 (задал автор): в стене застревать нельзя — если герой
## прыгает в сторону стены, он ВЫХОДИТ с другой её стороны; приземление
## всегда на свободной точке внутри карты (проверка точки ног; тело
## доталкивается физикой из краевых касаний).
## Стену толще PHASE_MAX_RANGE фазовый рывок не пробивает — приём
## не тратится. Бонус: если герой оказался внутри стены, рывок вытаскивает
## его на первое свободное место.
static func _phase_dash(host, move_dir: Vector2, info: Dictionary) -> bool:
    var fx: Node = host.get("_fx")
    if fx == null:
        fx = host.get("_world")
    var from: Vector2 = (host.player as CharacterBody2D).position
    var blocked := func(pos: Vector2) -> bool:
        return host._tile_is_solid(pos)
    var in_map := func(pos: Vector2) -> bool:
        return host._pos_in_map(pos)
    # Шаг сканирования 4 px; PHASE_MAX_RANGE — потолок полёта: прыжок длиной
    # 48 px, но сквозь стену выход ищется дальше (потолок — 96 px, стену
    # толще не пробить — приём не тратится). Выход из стены сдвигаем на
    # PHASE_EXIT_NUDGE внутрь свободной клетки — чтобы не встать на границе.
    var target := Vector2.INF
    var plain := Vector2.INF        # свободная точка обычного прыжка (<= 48 px)
    var crossed_wall := false
    var started_inside: bool = blocked.call(from)
    var d := PHASE_STEP
    while d <= PHASE_MAX_RANGE:
        var candidate: Vector2 = from + move_dir * d
        if not in_map.call(candidate):
            break   # дальше край карты — лететь за него нельзя
        if blocked.call(candidate):
            crossed_wall = true
        elif crossed_wall or started_inside:
            # вышли за стену (или стартовали внутри неё) — приземление здесь
            target = candidate + move_dir * PHASE_EXIT_NUDGE
            if in_map.call(target) and not blocked.call(target):
                break
            target = candidate   # сдвиг уехал за край/в стену — встаём как есть
            break
        elif d <= BLINK_RANGE + 0.1:
            plain = candidate   # свободное место в пределах обычного прыжка
        d += PHASE_STEP
    # стены не было: обычный прыжок — самое дальнее свободное место <= 48 px
    if not crossed_wall and not started_inside:
        target = plain
    if not target.is_finite():
        return false   # глухая стена / только край карты — приём не тратится
    host._dash_cd = maxf(0.1, float(info.get("cd", 2.0)))
    StrikeFx.poof(host, fx, from + Vector2(0, -10), Color(0.45, 0.8, 0.55), 6)
    host.player.position = target
    host.player.velocity = Vector2.ZERO
    Game.grant_iframes(IFRAMES_DASH)
    Sfx.play("dash", -6.0, 0.05, 0.78)
    StrikeFx.poof(host, fx, target + Vector2(0, -10), Color(0.72, 0.95, 0.78), 6)
    if host.has_method("_spawn_ring"):
        host._spawn_ring(target + Vector2(0, -10), Color(0.5, 0.9, 0.6), 1.4)
    return true

## «Хмельной запал» бомжа: Flask из инвентаря не тратится — герой пьёт
## сам. Game хранит drink_until; сцена красит мир зеленым и крутит
## анимацию питья через _ctrl_drink_visual.
static func _drink(host, info: Dictionary) -> bool:
    var duration := float(info.get("duration", 5.0))
    Game.drink_until = Time.get_ticks_msec() + int(duration * 1000.0)
    host._dash_cd = maxf(0.1, float(info.get("cd", 20.0)))
    if host.has_method("_ctrl_drink_visual"):
        host._ctrl_drink_visual(duration)
    Sfx.play("heal", -3.0, 0.04, 1.12)
    return true

## Тик рывка (из _physics_process): гасит кулдаун и время, гонит героя
## по направлению рывка, оставляет призрачный след.
static func tick_dash(host, delta: float, fx_parent: Node) -> void:
    host._dash_cd = maxf(0.0, float(host._dash_cd) - delta)
    if float(host._dash_time) <= 0.0 or host.player == null:
        return
    host._dash_time = maxf(0.0, float(host._dash_time) - delta)
    host.player.velocity = host._dash_dir * DASH_SPEED
    host._dash_ghost += delta
    if fx_parent != null and float(host._dash_ghost) >= 0.05:
        host._dash_ghost = 0.0
        StrikeFx.poof(host, fx_parent,
            host.player.position + Vector2(0, -10), Color(0.6, 0.8, 0.9), 5)

# --------------------------------------------------------------- телеграфы

const TELEGRAPH_MS := 350       # обычные враги: 0.35 с до удара
const TELEGRAPH_ELITE_MS := 450 # элита и боссы: заметный замах 0.45 с
const TELEGRAPH_MISS_MULT := 1.45   # герой отходил — удар промахивается

static func telegraph_ms(elite: bool) -> int:
        return TELEGRAPH_ELITE_MS if elite else TELEGRAPH_MS

## Телеграф идёт (удар ещё не пришёл): враг замирает и «замахивается».
static func telegraph_pending(rec: Dictionary) -> bool:
        return int(rec.get("tell_until", 0)) > Time.get_ticks_msec()

## Телеграф истёк — пора наносить удар (или промахнуться, если герой ушёл).
static func telegraph_ready(rec: Dictionary) -> bool:
        var tell := int(rec.get("tell_until", 0))
        return tell != 0 and Time.get_ticks_msec() >= tell

## Предупреждение об ударе: обычные враги приседают и желтеют,
## элита и боссы — размашистый красный замах (распрямление вверх).
## rec — запись врага/демона/Королевы: sprite, node и пр.
static func begin_telegraph(host, rec: Dictionary, elite: bool) -> void:
        rec["tell_until"] = Time.get_ticks_msec() + telegraph_ms(elite)
        var spr: AnimatedSprite2D = rec["sprite"]
        var base_scale: Vector2 = spr.scale
        rec["tell_scale"] = base_scale
        var tell := telegraph_ms(elite) / 1000.0
        var tw: Tween = host.create_tween()
        rec["tell_tween"] = tw
        if elite:
                tw.tween_property(spr, "scale", base_scale * 1.2, tell * 0.55) \
                        .set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
                tw.parallel().tween_property(spr, "modulate", Color(1.0, 0.4, 0.2),
                        tell * 0.55)
                tw.tween_property(spr, "scale", base_scale, tell * 0.3)
        else:
                tw.tween_property(spr, "scale",
                        Vector2(base_scale.x * 1.12, base_scale.y * 0.8), tell * 0.55)
                tw.parallel().tween_property(spr, "modulate", Color(1.0, 0.85, 0.4),
                        tell * 0.55)
                tw.tween_property(spr, "scale", base_scale, tell * 0.3)

## Завершить телеграф: вернуть спрайт в норму (если твин не успел).
static func end_telegraph(host, rec: Dictionary) -> void:
        rec.erase("tell_until")
        var tw: Tween = rec.get("tell_tween")
        if tw != null and tw.is_valid():
                tw.kill()
        rec.erase("tell_tween")
        var spr: AnimatedSprite2D = rec["sprite"]
        spr.modulate = Color.WHITE
        if rec.has("tell_scale"):
                spr.scale = rec["tell_scale"]
        rec.erase("tell_scale")

## Промах врага: герой ушёл с места за время замаха (награда за рывок).
## Синтетические записи без node/def (прямые вызовы из тестов) не промахиваются.
static func attack_missed(host, rec: Dictionary) -> bool:
        var node: Node2D = rec.get("node")
        var def: Dictionary = rec.get("def", {})
        if node == null or def.is_empty() or host.player == null:
                return false
        var reach: float = float(def.get("attack_range", 16.0)) * TELEGRAPH_MISS_MULT
        return host.player.position.distance_to(node.position) > reach

## BossAi — компонент тактики и декора боссов (шаг 28, декомпозиция).
## Ктулху (шаг 21) и Шуб-Ниггурат (шаг 24) жили в dungeon.gd (~330 строк).
## Тела перенесены дословно, поведение не менялось. Константы баланса
## (CTHULHU_*, SHUB_*, BOSS_SIZE_MULT) остались в dungeon.gd рядом с
## остальным конфигом данжа — компонент берёт их через хост d.
## Спавн врагов — FoeAi, эффекты — StrikeFx, подсказки — HudBuilder.
class_name BossAi
extends RefCounted

# ------------------------------------ Ктулху (шаг 21): УСТРАШЕНИЕ

## Ужас вокруг босса: пульсирующие угли-глаза, тёмная аура у ног,
## медленное «дыхание» тела. Вызывается один раз при спавне.
static func decorate_cthulhu(d, boss: Dictionary) -> void:
	var node: Node2D = boss["node"]
	var spr: AnimatedSprite2D = boss["sprite"]
	var eyes: Array = []
	for dx: float in [-9.0, 9.0]:
		var eye := Sprite2D.new()
		eye.texture = d._glow_tex
		eye.material = d._glow_mat
		eye.position = Vector2(dx, -99.0)   # лицо листа 96x128 (x4)
		eye.modulate = Color(1.0, 0.3, 0.1, 0.55)
		eye.scale = Vector2(0.55, 0.55)
		node.add_child(eye)
		var tw: Tween = eye.create_tween().set_loops()
		tw.tween_property(eye, "modulate:a", 0.95, 1.1)
		tw.tween_property(eye, "modulate:a", 0.5, 1.1)
		eyes.append(eye)
	var aura := Sprite2D.new()
	aura.texture = d._glow_tex
	aura.material = d._glow_mat
	aura.position = Vector2(0, -10)
	aura.modulate = Color(0.14, 0.3, 0.18, 0.42)
	aura.scale = Vector2(1.8, 1.3)
	node.add_child(aura)
	node.move_child(aura, 0)                 # аура — под спрайтом
	var breathe: Tween = node.create_tween().set_loops()
	breathe.tween_property(spr, "scale",
		Vector2(d.BOSS_SIZE_MULT * 1.045, d.BOSS_SIZE_MULT * 1.045), 1.6) \
		.set_trans(Tween.TRANS_SINE)
	breathe.tween_property(spr, "scale",
		Vector2(d.BOSS_SIZE_MULT, d.BOSS_SIZE_MULT), 1.6) \
		.set_trans(Tween.TRANS_SINE)
	boss["eyes"] = eyes
	boss["slam_cd"] = 4.0
	boss["volley_cd"] = 3.0
	boss["whisper_cd"] = 6.0

## Тактика Ктулху в бою (из update_foes): веер болтов безумия, удар
## щупалец с предупреждением, шёпоты, призывы отродий, фаза 2.
static func update_cthulhu(d, foe: Dictionary, def: Dictionary,
		delta: float) -> void:
	if not bool(foe["aggro"]):
		return   # тактика только в бою (после диалога и при агрессии)
	var node: Node2D = foe["node"]
	var hp_frac := float(foe["hp"]) / maxf(1.0, float(foe["max_hp"]))
	# --- фаза 2: небо гаснет, глаза разгораются, когти быстрее
	if not bool(foe.get("phase2", false)) and hp_frac <= d.CTHULHU_PHASE2_HP:
		foe["phase2"] = true
		foe["attack_cd_override"] = d.CTHULHU_PHASE2_CD
		foe["speed_override"] = d.CTHULHU_PHASE2_SPEED
		if d._air != null:
			d._air.color = Color(d._air_base.r * 0.5, d._air_base.g * 0.45,
				d._air_base.b * 0.6)
		for eye in foe.get("eyes", []):
			(eye as Sprite2D).modulate = Color(1.0, 0.18, 0.05, 1.0)
		d._shake_camera(4.0, 0.5)
		Sfx.play("roar")
		StrikeFx.ring(d, d._fx, node.position + Vector2(0, -24),
			Color(0.7, 0.22, 0.12), 3.4)
		HudBuilder.show_hint(d,
			"Небо над Р'льехом гаснет. Ктулху больше не играет.", 3.0)
		return
	# --- призыв Отродий звёзд на порогах ХП (по одному разу на порог)
	for i in range(d.CTHULHU_SUMMON_HP.size()):
		var key := "summon_%d" % i
		if not bool(foe.get(key, false)) \
				and hp_frac <= float(d.CTHULHU_SUMMON_HP[i]):
			foe[key] = true
			cthulhu_summon(d, node)
	# --- шёпоты Р'льеха
	foe["whisper_cd"] = maxf(0.0, float(foe.get("whisper_cd", 6.0)) - delta)
	if float(foe["whisper_cd"]) <= 0.0:
		foe["whisper_cd"] = d.CTHULHU_WHISPER_CD
		cthulhu_whisper(d)
	# --- веер болтов безумия
	foe["volley_cd"] = maxf(0.0, float(foe.get("volley_cd", 3.0)) - delta)
	if float(foe["volley_cd"]) <= 0.0 and Game.hp > 0 and not d._player_dead:
		foe["volley_cd"] = d.CTHULHU_VOLLEY_CD
		for k in range(d.CTHULHU_VOLLEY_N):
			var spread: float = -d.CTHULHU_VOLLEY_SPREAD \
				+ 2.0 * d.CTHULHU_VOLLEY_SPREAD * float(k) \
				/ float(d.CTHULHU_VOLLEY_N - 1)
			StrikeFx.spawn_foe_bolt(d, d._fx, foe, def, spread,
				Color(0.45, 0.85, 0.6), d._glow_tex, d._glow_mat)
	# --- удар щупалец: круг-предупреждение, затем мокрый удар
	var now_ms := Time.get_ticks_msec()
	if foe.has("slam_at"):
		if now_ms >= int(foe["slam_at"]):
			var mark: Vector2 = foe["slam_pos"]
			foe.erase("slam_at")
			cthulhu_slam_hit(d, foe, mark)
	else:
		foe["slam_cd"] = maxf(0.0, float(foe.get("slam_cd", 4.0)) - delta)
		if float(foe["slam_cd"]) <= 0.0 and Game.hp > 0 and not d._player_dead:
			foe["slam_cd"] = d.CTHULHU_SLAM_CD
			var target: Vector2 = d.player.position + Vector2(0, -6)
			foe["slam_pos"] = target
			foe["slam_at"] = now_ms + int(d.CTHULHU_SLAM_TELL * 1000.0)
			cthulhu_slam_tell(d, foe, target)

## Круг-предупреждение на полу: щупальца вот-вот ударят в это место.
static func cthulhu_slam_tell(d, foe: Dictionary, pos: Vector2) -> void:
	if d._glow_tex == null:
		return
	var warn := Sprite2D.new()
	warn.texture = d._glow_tex
	warn.material = d._glow_mat
	warn.position = pos
	warn.scale = Vector2(0.62, 0.62)
	warn.modulate = Color(0.85, 0.3, 0.12, 0.35)
	warn.z_index = 8
	d._fx.add_child(warn)
	foe["slam_mark"] = warn
	var tw: Tween = warn.create_tween().set_loops()
	tw.tween_property(warn, "modulate:a", 0.75, 0.2)
	tw.tween_property(warn, "modulate:a", 0.3, 0.2)

## Удар щупалец: мокрый звук, тряска, урон в радиусе круга.
static func cthulhu_slam_hit(d, foe: Dictionary, pos: Vector2) -> void:
	if foe.has("slam_mark") and is_instance_valid(foe["slam_mark"]):
		(foe["slam_mark"] as Sprite2D).queue_free()
		foe.erase("slam_mark")
	Sfx.play("slam")
	d._shake_camera(3.2, 0.35)
	StrikeFx.ring(d, d._fx, pos, Color(0.35, 0.6, 0.4), 2.2)
	for k in range(5):
		var ang := TAU * float(k) / 5.0
		StrikeFx.poof(d, d._fx, pos + Vector2(cos(ang), sin(ang)) * 12.0,
			Color(0.3, 0.52, 0.38))
	if Game.hp > 0 and not d._player_dead \
			and d.player.position.distance_to(pos) <= d.CTHULHU_SLAM_RADIUS + 6.0:
		Game.damage_hp(d.CTHULHU_SLAM_DMG, true)   # шаг 27: i-frames
		Sfx.play_variant("hurt")
		d._flash_player()
		StrikeFx.hit_impact(d, d._fx, d.player.position + Vector2(0, -14),
			Color(0.5, 0.75, 0.55))
		StrikeFx.damage_label(d, d._fx, d.player.position + Vector2(0, -40),
			d.CTHULHU_SLAM_DMG, true)

## Из тени крыльев — Отродья звёзд: двое на свободных плитах рядом.
static func cthulhu_summon(d, boss_node: Node2D) -> void:
	var def: Dictionary = DungeonBestiary.foe_def("star_spawn")
	if def.is_empty():
		return
	var placed := 0
	for off: Vector2 in [Vector2(-26, -22), Vector2(26, -22),
			Vector2(-22, 26), Vector2(22, 26)]:
		if placed >= 2:
			break
		var pos: Vector2 = boss_node.position + off
		var tile := Vector2i(int(floor(pos.x / 16.0)),
			int(floor((pos.y - 8.0) / 16.0)))
		if tile.x < 1 or tile.y < 1 \
				or tile.x >= DungeonBestiary.MAP_W - 1 \
				or tile.y >= DungeonBestiary.MAP_H - 1:
			continue
		if d._tile_is_solid(Vector2(pos.x, pos.y - 8.0)):
			continue
		FoeAi.spawn_foe(d, def, tile)
		StrikeFx.poof(d, d._fx,
			d._feet_pos(Vector2(tile)) + Vector2(0, -16),
			Color(0.5, 0.85, 0.8))
		placed += 1
	if placed > 0:
		Sfx.play("bolt", -4.0)
		StrikeFx.ring(d, d._fx, boss_node.position + Vector2(0, -24),
			Color(0.5, 0.85, 0.8), 2.6)
		HudBuilder.show_hint(d, "Из тени крыльев выплывают Отродья звёзд!", 2.6)

## Шёпоты Р'льеха: по кругу, одна реплика за раз (boss_whispers данжа).
## Общий механизм и для Шуб-Ниггурат: текст берётся из меты данжа.
static func cthulhu_whisper(d) -> void:
	var whispers: Array = DungeonBestiary.dungeon_meta(d._dungeon_id) \
		.get("boss_whispers", [])
	if whispers.is_empty():
		return
	d._cthulhu_whisper_idx = (int(d._cthulhu_whisper_idx) + 1) % whispers.size()
	HudBuilder.show_hint(d, String(whispers[int(d._cthulhu_whisper_idx)]), 3.4)

## -------------------------------- Шуб-Ниггурат (шаг 24, п.10)

## Декор Шуб-Ниггурат: третий глаз, аура спор, дыхание массой, пороги.
static func decorate_shub(d, boss: Dictionary) -> void:
	var node: Node2D = boss["node"]
	var spr: AnimatedSprite2D = boss["sprite"]
	var eyes: Array = []
	for eye_pos: Vector2 in [Vector2(-12, -96), Vector2(12, -96),
			Vector2(0, -84)]:
		var eye := Sprite2D.new()
		eye.texture = d._glow_tex
		eye.material = d._glow_mat
		eye.position = eye_pos
		eye.modulate = Color(0.85, 0.95, 0.3, 0.55)
		eye.scale = Vector2(0.5, 0.5)
		node.add_child(eye)
		var tw: Tween = eye.create_tween().set_loops()
		tw.tween_property(eye, "modulate:a", 0.95, 1.0)
		tw.tween_property(eye, "modulate:a", 0.4, 1.0)
		eyes.append(eye)
	var aura := Sprite2D.new()
	aura.texture = d._glow_tex
	aura.material = d._glow_mat
	aura.position = Vector2(0, -16)
	aura.modulate = Color(0.2, 0.34, 0.12, 0.45)
	aura.scale = Vector2(2.0, 1.5)
	node.add_child(aura)
	node.move_child(aura, 0)
	var breathe: Tween = node.create_tween().set_loops()
	breathe.tween_property(spr, "scale",
		Vector2(d.BOSS_SIZE_MULT * 1.05, d.BOSS_SIZE_MULT * 1.05), 1.7) \
		.set_trans(Tween.TRANS_SINE)
	breathe.tween_property(spr, "scale",
		Vector2(d.BOSS_SIZE_MULT, d.BOSS_SIZE_MULT), 1.7) \
		.set_trans(Tween.TRANS_SINE)
	boss["eyes"] = eyes
	boss["volley_cd"] = 3.0
	boss["whisper_cd"] = 5.0

## Тактика Шуб-Ниггурат: веер спор, полчища детенышей на порогах ХП,
## шёпот Козни, фаза 2 «сад гаснет» (воздух темнеет, когти быстрее).
static func update_shub(d, foe: Dictionary, def: Dictionary,
		delta: float) -> void:
	if not bool(foe["aggro"]):
		return
	var node: Node2D = foe["node"]
	var hp_frac := float(foe["hp"]) / maxf(1.0, float(foe["max_hp"]))
	# --- фаза 2: сад гаснет
	if not bool(foe.get("phase2", false)) and hp_frac <= d.SHUB_PHASE2_HP:
		foe["phase2"] = true
		foe["attack_cd_override"] = d.SHUB_PHASE2_CD
		foe["speed_override"] = d.SHUB_PHASE2_SPEED
		if d._air != null:
			d._air.color = Color(d._air_base.r * 0.45, d._air_base.g * 0.5,
				d._air_base.b * 0.5)
		for eye in foe.get("eyes", []):
			(eye as Sprite2D).modulate = Color(0.95, 0.2, 0.1, 1.0)
		d._shake_camera(4.0, 0.5)
		Sfx.play("roar")
		StrikeFx.ring(d, d._fx, node.position + Vector2(0, -26),
			Color(0.55, 0.75, 0.3), 3.4)
		HudBuilder.show_hint(d,
			"Сад Шуб-Ниггурат гаснет. Её молоко больше не для тебя.", 3.0)
		return
	# --- полчища детенышей на порогах ХП
	for i in range(d.SHUB_SUMMON_HP.size()):
		var key := "summon_%d" % i
		if not bool(foe.get(key, false)) and hp_frac <= float(d.SHUB_SUMMON_HP[i]):
			foe[key] = true
			shub_summon(d, node, i)
	# --- шёпот Козни
	foe["whisper_cd"] = maxf(0.0, float(foe.get("whisper_cd", 5.0)) - delta)
	if float(foe["whisper_cd"]) <= 0.0:
		foe["whisper_cd"] = d.SHUB_WHISPER_CD
		cthulhu_whisper(d)   # общий механизм шёпота: текст берётся из данжа
	# --- веер спор
	foe["volley_cd"] = maxf(0.0, float(foe.get("volley_cd", 3.0)) - delta)
	if float(foe["volley_cd"]) <= 0.0 and Game.hp > 0 and not d._player_dead:
		foe["volley_cd"] = d.SHUB_VOLLEY_CD
		for k in range(d.SHUB_VOLLEY_N):
			var spread: float = -d.SHUB_VOLLEY_SPREAD \
				+ 2.0 * d.SHUB_VOLLEY_SPREAD * float(k) \
				/ float(d.SHUB_VOLLEY_N - 1)
			StrikeFx.spawn_foe_bolt(d, d._fx, foe, def, spread,
				Color(0.75, 0.9, 0.5), d._glow_tex, d._glow_mat)

## Полчище детенышей (шаг 24): пара тварей из бестиария данжа 4 вокруг Матери.
static func shub_summon(d, boss_node: Node2D, threshold_idx: int) -> void:
	var placed := 0
	var offs: Array[Vector2] = [Vector2(-30, -20), Vector2(30, -20),
		Vector2(0, 30)]
	for k in range(d.SHUB_SUMMON_COUNT):
		var foe_id := String(d.SHUB_SUMMON_IDS[(threshold_idx * d.SHUB_SUMMON_COUNT + k)
			% d.SHUB_SUMMON_IDS.size()])
		var def: Dictionary = DungeonBestiary.foe_def(foe_id)
		if def.is_empty():
			continue
		if k >= offs.size():
			break
		var pos: Vector2 = boss_node.position + offs[k]
		var tile := Vector2i(int(floor(pos.x / 16.0)),
			int(floor((pos.y - 8.0) / 16.0)))
		if tile.x < 1 or tile.y < 1 \
				or tile.x >= DungeonBestiary.MAP_W - 1 \
				or tile.y >= DungeonBestiary.MAP_H - 1:
			continue
		if d._tile_is_solid(Vector2(pos.x, pos.y - 8.0)):
			continue
		FoeAi.spawn_foe(d, def, tile)
		StrikeFx.poof(d, d._fx,
			d._feet_pos(Vector2(tile)) + Vector2(0, -16),
			Color(0.75, 0.9, 0.5))
		placed += 1
	if placed > 0:
		Sfx.play("bolt", -4.0)
		StrikeFx.ring(d, d._fx, boss_node.position + Vector2(0, -24),
			Color(0.75, 0.9, 0.5), 2.8)
		HudBuilder.show_hint(d, "Из спор Шуб-Ниггурат выходят её младенцы!", 2.6)

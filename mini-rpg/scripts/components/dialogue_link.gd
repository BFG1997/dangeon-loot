## DialogueLink — компонент диалоговой привязки (шаг 28, декомпозиция).
## Логика «кто что говорит» жила в world.gd (~110 строк) и dungeon.gd
## (диалог босса). Тела перенесены дословно, поведение не изменилось.
## Константы реплик (NPC_LINES, NPC_MAD_LINES, NPC_DUNGEON_REACTIONS,
## NPC_MURDER_REACTIONS, NPC_VICTIM_ACC, DEMON_RAGE_LINES, QUEEN_*)
## остались в world.gd рядом с остальными данными мира — компонент
## берёт их через хост w. Трейд-обработчики (_on_trade_requested,
## _on_dialogue_closed) остались в сценах: они вяжут сигналы UI с
## состоянием конкретной сцены.
class_name DialogueLink
extends RefCounted

## Разговор с NPC в мире: живой NPC открывает диалог, труп молчит,
## демон узнаёт героя, мутант бредит, убийцу боятся, Королева признаётся.
static func npc_say(w, npc_id: String) -> void:
	for npc in w._npcs:
		if npc["id"] != npc_id:
			continue
		if bool(npc.get("dead", false)) or Game.is_npc_dead(npc_id):
			return
		var data: Dictionary = npc["data"]
		w._dialogue_npc = data
		# Шаг 24 (п.9): в финале Лира — Королева ночи: разговор = признание.
		if Game.finale_active() and String(npc_id) == String(w.QUEEN_ID):
			w._talk_queen()
			return
		var lines: Array
		var goods: Array
		if bool(data.get("demon", false)):
			# демон: до ярости радуется убийству жителей и зовёт к своей лавке.
			# Шаг 13: разговор с демоном — «мы видели демона»: босс данжа 1
			# по этому флагу узнаёт героя.
			Game.mark_demon_seen()
			# Ассортимент динамический — товары павших торговцев, поэтому
			# для лавки кладём его прямо в словарь торговца (TradeUI
			# читает goods из данных торговца).
			# Шаг 12: в ярости лавки нет — только угрозы.
			w._dialogue_npc = data.duplicate()
			if Game.demon_enraged:
				(w._dialogue_npc as Dictionary)["role"] = "разбуженная ярость"
				(w._dialogue_npc as Dictionary)["goods"] = []
				lines = w.DEMON_RAGE_LINES.duplicate()
				goods = []
			else:
				(w._dialogue_npc as Dictionary)["goods"] = Game.demon_goods()
				lines = demon_lines(w)
				goods = Game.demon_goods()
		else:
			# Шаг 24 (п.8): мутант говорит бред (и торгует — дороже);
			# иначе обычные реплики + реакция на пройденный данж (п.1)
			if Game.mutation_active():
				lines = mad_lines(w, npc_id)
			else:
				lines = (w.NPC_LINES.get(npc_id, ["..."]) as Array).duplicate()
				var reaction := dungeon_reaction(w, npc_id)
				if not reaction.is_empty():
					lines.push_front(reaction)
			if not Game.dead_npcs.is_empty():
				# шаг 8: старые диалоги больше не появятся — только память
				# об убийстве; торговцы отказываются торговать с убийцей
				lines = [murder_reaction(w, npc_id)]
				goods = []
			else:
				# шаг 22: прилавок = базовый товар + то, что герой продал
				# торговцу этого профиля (смотря что это и какой торговец)
				goods = Game.merchant_goods(String(data.get("id", "")))
		var role_text := String(data["role"])
		if Game.mutation_active() and not bool(data.get("demon", false)):
			role_text = "мутант"
		if Game.finale_active() and String(npc_id) == String(w.QUEEN_ID):
			role_text = String(w.QUEEN_TITLE)
		w._dialogue.open({
			"name": data["name"],
			"role": role_text,
			"portrait": data["portrait"],
			"lines": lines,
			"goods": goods,
		})
		(npc["sprite"] as AnimatedSprite2D).play("idle_down")
		return

## Бред замутанта (шаг 24, п.8): две реплики из NPC_MAD_LINES.
static func mad_lines(w, npc_id: String) -> Array:
	var lines: Array = w.NPC_MAD_LINES.get(npc_id,
		["МЫ... МЫ... МЫ... торг... торг...", "Пустота говорит твоим ртом."])
	return (lines as Array).duplicate()

## Реакция NPC на последний пройденный данж (шаг 24, п.1): пусто — реакции нет.
static func dungeon_reaction(w, npc_id: String) -> String:
	var cleared := Game.last_cleared_dungeon()
	if cleared.is_empty() or Game.dungeon_4_open() or Game.finale_active():
		return ""
	var per_npc: Dictionary = w.NPC_DUNGEON_REACTIONS.get(cleared, {})
	return String(per_npc.get(npc_id, ""))

## Реплики живого NPC про убитых героем: имена подставляются
## в винительном падеже (см. NPC_VICTIM_ACC).
static func murder_reaction(w, speaker_id: String) -> String:
	var victims: Array[String] = []
	for victim_id in Game.dead_npcs:
		victims.append(String(w.NPC_VICTIM_ACC.get(String(victim_id), String(victim_id))))
	var template: String = w.NPC_MURDER_REACTIONS.get(speaker_id, "Ты убил %s!")
	return template % ", ".join(victims)

## Реплики демона (шаг 8; шаг 9/12 — лавкрафтовский хоррор): рад убийству
## жителей, перечисляет жертв, хвастается лавкой из товаров павших и зовёт
## убивать ещё — каждая новая жертва дешевит его лавку ещё на 10%.
## (В ярости реплики другие — DEMON_RAGE_LINES, см. npc_say.)
static func demon_lines(w) -> Array:
	var lines: Array = []
	var victims: Array[String] = []
	for victim_id in Game.dead_npcs:
		var vid := String(victim_id)
		if vid != "demon":
			victims.append(String(w.NPC_VICTIM_ACC.get(vid, vid)))
	lines.append("Хе-хе-хе! Я чую это с края мира: смертный остыл — и это сделал ты. Пустота аплодирует стоя.")
	if not victims.is_empty():
		lines.append("Ты убил %s. Я всё видел отсюда: их тени уже переползли через ограду и ползут ко мне. Теперь они мои." % ", ".join(victims))
	if Game.demon_goods().is_empty():
		lines.append("Пока мне нечего тебе продать. Убей торговца — его лавка переедет ко мне. Вместе с ценами. Вместе с голосом.")
	else:
		lines.append("Товары павших торговцев теперь мои. И дешевле, чем у них были: скидка %d%%. Мёртвые не торгуются." % Game.demon_discount_pct())
	lines.append("Убей ещё жителя — и цены упадут ещё на десять процентов. Каждая новая тень делает мой товар щедрее.")
	return lines

## Обязательная встреча с боссом данжа: герой подошёл близко — босс
## говорит. Если мы видели демона у края мира, он узнаёт героя; после
## диалога (см. _on_dialogue_closed сцены) начинается бой.
static func open_boss_dialog(d) -> void:
	d._boss_dialog_done = true
	var def: Dictionary = DungeonBestiary.boss_for(d._dungeon_id)
	# демон данжа 1 узнаёт героя, если видели его у края мира (шаг 13);
	# босс данжа 2 с героем не говорил — Пустота лишь шептала (шаг 16)
	var seen: bool = bool(def.get("knows_hero", false)) and Game.demon_seen
	var lines: Array = def.get("lines_seen", []) if seen \
		else def.get("lines_new", [])
	if lines.is_empty():
		lines = def.get("lines_new", [])
	d._dialogue.open({
		"name": String(def.get("name", "Хозяин подземелья")),
		"role": String(def.get("role_seen", "")) if seen \
			else String(def.get("role_new", "")),
		"portrait": String(def.get("portrait", "")),
		"lines": lines,
	})

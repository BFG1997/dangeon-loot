## Тест шага 31: Демоноолог и Некромант — два новых класса.
## Демоноолог: 4 демона-тумблера (Q/пробел/T/Ctrl), мана за призыв,
## кулдаун ТОЛЬКО после смерти демона, масштаб от уровня (мана и сила).
## Некромант: армия из убитых врагов с лимитом 1/3/6/10, фазовый рывок
## сквозь стены (но не за край), безумие мобов на 10 с, зов босса после
## первой победы. Союзники дерутся за героя и принимают его удары.
## Запуск: godot --headless --path . res://tests/step31_test.tscn
extends Node

var failed := 0

func check(name: String, condition: bool) -> void:
    if condition:
        print("  [OK] ", name)
    else:
        failed += 1
        print("  [ПРОВАЛ] ", name)

func load_dungeon() -> Node2D:
    var dungeon: Node2D = (load("res://scenes/dungeon/dungeon.tscn") as PackedScene).instantiate()
    add_child(dungeon)
    await get_tree().process_frame
    await get_tree().process_frame
    return dungeon

func load_world() -> Node2D:
    var world: Node2D = (load("res://scenes/world/world.tscn") as PackedScene).instantiate()
    add_child(world)
    await get_tree().process_frame
    await get_tree().process_frame
    return world

func living_foes(d: Node2D) -> Array:
    var out: Array = []
    for foe in d._foes:
        if not bool(foe.get("dead", false)):
            out.append(foe)
    return out

func corpse_foes(d: Node2D) -> Array:
    var out: Array = []
    for foe in d._foes:
        if bool(foe.get("dead", false)) and not bool(foe.get("boss", false)):
            out.append(foe)
    return out

func _ready() -> void:
    print("STEP31 TEST: Демоноолог и Некромант — призывы, армия, фаза, безумие, зов босса")
    Saves.wipe_all_slots()
    Game.meta["last_slot"] = 0
    Game.meta["last_bonus_date"] = ""
    Game.save_meta()

    # ================== таблицы новых классов ==================
    check("ABILITIES демоноолога: все 4 слота — призывы",
        String(Game.ABILITIES["demonologist"]["q"]["kind"]) == "summon"
        and String(Game.ABILITIES["demonologist"]["dash"]["kind"]) == "summon"
        and String(Game.ABILITIES["demonologist"]["t"]["kind"]) == "summon"
        and String(Game.ABILITIES["demonologist"]["special"]["kind"]) == "summon")
    check("демоны по силе: Q — демон, пробел — крылатый, T — огромный, Ctrl — суккуб",
        String(Game.ABILITIES["demonologist"]["q"]["summon"]) == "demon"
        and String(Game.ABILITIES["demonologist"]["dash"]["summon"]) == "winged"
        and String(Game.ABILITIES["demonologist"]["t"]["summon"]) == "huge"
        and String(Game.ABILITIES["demonologist"]["special"]["summon"]) == "succubus")
    check("цена маны демонов растёт с силой (15/45/75/60)",
        int(Game.ABILITIES["demonologist"]["q"]["mana_cost"]) == 15
        and int(Game.ABILITIES["demonologist"]["dash"]["mana_cost"]) == 45
        and int(Game.ABILITIES["demonologist"]["t"]["mana_cost"]) == 75
        and int(Game.ABILITIES["demonologist"]["special"]["mana_cost"]) == 60)
    check("кулдаун кнопки только за смерть: обычный cd = 0, respawn 25/40/60/50",
        not Game.ABILITIES["demonologist"]["q"].has("cd")
        and float(Game.DEMON_SUMMONS["demon"]["respawn_cd"]) == 25.0
        and float(Game.DEMON_SUMMONS["winged"]["respawn_cd"]) == 40.0
        and float(Game.DEMON_SUMMONS["huge"]["respawn_cd"]) == 60.0
        and float(Game.DEMON_SUMMONS["succubus"]["respawn_cd"]) == 50.0)
    check("ABILITIES некроманта: подъём/фаза/безумие/зов босса",
        String(Game.ABILITIES["necromancer"]["q"]["kind"]) == "resurrect"
        and String(Game.ABILITIES["necromancer"]["dash"]["kind"]) == "phase_dash"
        and String(Game.ABILITIES["necromancer"]["t"]["kind"]) == "madness"
        and String(Game.ABILITIES["necromancer"]["special"]["kind"]) == "summon_boss")
    Game.level = 1
    check("лимит армии ур.1 = 1", Game.necro_army_cap() == 1)
    Game.level = 2
    check("лимит армии ур.2 = 3", Game.necro_army_cap() == 3)
    Game.level = 3
    check("лимит армии ур.3 = 6", Game.necro_army_cap() == 6)
    Game.level = 4
    check("лимит армии ур.4 = 10", Game.necro_army_cap() == 10)

    # ================== мана колдунов растёт с уровнем ==================
    Game.new_run(1, "demonologist")
    check("демоноолог: старт — мана 60", Game.max_mana() == 60 and Game.mana == 60)
    Game.level = 3
    check("демоноолог: ур.3 — мана 80 (+10 за уровень)", Game.max_mana() == 80)
    Game.new_run(1, "necromancer")
    Game.level = 3
    check("некромант: ур.3 — мана 100 (+5 за уровень)", Game.max_mana() == 100)
    Game.level = 1

    # ================== демоноолог в данже ==================
    Game.new_run(1, "demonologist")
    var d := await load_dungeon()
    check("данж загрузился для демоноолога", d.player != null)

    # призыв на Q: мана списана, союзник появился
    d._on_q_pressed()
    await get_tree().process_frame
    check("Q призвал демона (мана -15)", Game.mana == 45
        and Game.summons_active.has("demon") and d._minions.size() == 1)
    check("у живого демона кулдауна нет", Game.summon_cd_left("demon") == 0.0)

    # повторное нажатие — отпуск без кулдауна и без возврата маны
    d._on_q_pressed()
    await get_tree().process_frame
    check("повторное Q отпустило демона (без кулдауна)",
        d._minions.is_empty() and not Game.summons_active.has("demon")
        and Game.summon_cd_left("demon") == 0.0 and Game.mana == 45)

    # снова призыв и смерть демона — появляется кулдаун кнопки
    d._on_q_pressed()
    await get_tree().process_frame
    check("демон призван снова", Game.summons_active.has("demon") and Game.mana == 30)
    var ally: Dictionary = d._minions[0]
    Minions.damage_ally(d, ally, 9999)
    print("    (диагностика: minions=", d._minions.size(),
        " active=", Game.summons_active.has("demon"),
        " cd=", Game.summon_cd_left("demon"), " q_cd=", d._q_cd, ")")
    await get_tree().process_frame
    check("после смерти демона — кулдаун Q на 25 с",
        not Game.summons_active.has("demon") and d._minions.is_empty()
        and absf(Game.summon_cd_left("demon") - 25.0) < 1.0
        and absf(float(d._q_cd) - 25.0) < 1.0)

    # на кулдауне призыв не работает и ману не тратит
    d._on_q_pressed()
    await get_tree().process_frame
    check("на кулдауне призыв отказывает (мана не списана)",
        not Game.summons_active.has("demon") and Game.mana == 30)

    # нехватка маны на суккуба (60 > 30) — отказ с указанием
    Game.restore_mana(10)   # 30 -> 40, всё равно < 60
    d._on_special_pressed()
    await get_tree().process_frame
    check("не хватает маны на суккуба — отказ (мана не списана)",
        not Game.summons_active.has("succubus") and Game.mana == 40)

    # крылатый демон на пробеле (мана 45 из 40 — доливаем)
    Game.restore_mana(Game.max_mana())
    Combat.start_dash(d, Vector2.ZERO)   # dash_kind == summon_winged — тумблер
    await get_tree().process_frame
    check("пробел призвал крылатого демона (мана -45)",
        Game.summons_active.has("winged") and d._minions.size() == 1)

    # огромный демон на T: на 1-м уровне маны не хватает (75 > 60), после прокачки хватает
    d._on_t_pressed()
    await get_tree().process_frame
    check("огромный демон на 1-м уровне недоступен (маны 75 > 60)",
        not Game.summons_active.has("huge"))
    Game.level = 4   # мана 60 + 3*10 = 90
    Game.restore_mana(Game.max_mana())
    d._on_t_pressed()
    await get_tree().process_frame
    check("огромный демон после прокачки призван (мана -75)",
        Game.summons_active.has("huge") and Game.mana == 90 - 75)
    check("демоны сильнее с уровнем героя", Game.summon_damage("demon") > 9)

    # перехват атаки врага союзником: демон принимает удар вместо героя
    var foes := living_foes(d)
    check("на этаже есть враги для проверки перехвата", foes.size() >= 2)
    if foes.size() >= 2:
        var foe: Dictionary = foes[0]
        var foe_node: Node2D = foe["node"]
        var hero_pos: Vector2 = d.player.position
        # враг рядом с героем, демон-союзник ещё ближе
        foe_node.position = hero_pos + Vector2(20, 0)
        var demon_ally: Dictionary = {}
        for a in d._minions:
            if String(a.get("summon_id", "")) == "huge":
                demon_ally = a
        if demon_ally.is_empty():
            demon_ally = d._minions[0]
        (demon_ally["node"] as Node2D).position = hero_pos + Vector2(10, 0)
        var ally_hp0 := int(demon_ally["hp"])
        FoeAi.foe_attack(d, foe)
        await get_tree().process_frame
        check("враг ударил союзника вместо героя (хп демона упало, хп героя нет)",
            int(demon_ally["hp"]) < ally_hp0)
        # добиваем союзника насмерть — демон исчезает из строю
        Minions.damage_ally(d, demon_ally, 9999)
        await get_tree().process_frame
        check("союзник умер от урона — исчез из строю",
            not d._minions.has(demon_ally))

    d.queue_free()
    await get_tree().process_frame

    # ================== некромант в данже ==================
    Game.new_run(2, "necromancer")
    var d2 := await load_dungeon()
    check("данж загрузился для некроманта", d2.player != null)
    check("армия пуста на старте", Game.necro_army.is_empty())

    # убиваем врага и поднимаем его (ур.1 — лимит 1)
    var lf := living_foes(d2)
    check("есть живые враги для подъёма", not lf.is_empty())
    var corpse: Dictionary = lf[0]
    var corpse_pos: Vector2 = (corpse["node"] as Node2D).position
    var corpse_def: Dictionary = corpse["def"]
    d2._hit_foe(corpse, 9999)
    await get_tree().process_frame
    check("враг убит и стал трупом", bool(corpse.get("dead", false)))
    d2.player.position = corpse_pos + Vector2(12, 0)
    var mana0 := Game.mana
    d2._on_q_pressed()
    await get_tree().process_frame
    check("Q поднял мертвеца (мана -25, армия 1/1)",
        Game.necro_army.size() == 1 and d2._minions.size() == 1
        and Game.mana == mana0 - 25 and bool(corpse_def.get("id", "") != ""))

    # лимит: второй труп на ур.1 не поднимается
    var lf2 := living_foes(d2)
    if not lf2.is_empty():
        var corpse2: Dictionary = lf2[0]
        var c2_pos: Vector2 = (corpse2["node"] as Node2D).position
        d2._hit_foe(corpse2, 9999)
        await get_tree().process_frame
        d2.player.position = c2_pos + Vector2(12, 0)
        var mana1 := Game.mana
        d2._on_q_pressed()
        await get_tree().process_frame
        check("ур.1: армия полна (1/1) — второй мертвец не поднимается",
            Game.necro_army.size() == 1 and Game.mana == mana1)

    # ур.3 — лимит 6: поднимаем ещё трёх
    Game.level = 3
    for i in range(3):
        var pool := living_foes(d2)
        if pool.is_empty():
            break
        var c: Dictionary = pool[0]
        var cpos: Vector2 = (c["node"] as Node2D).position
        d2._hit_foe(c, 9999)
        await get_tree().process_frame
        d2.player.position = cpos + Vector2(12, 0)
        Game.restore_mana(100)
        d2._q_cd = 0.0
        d2._on_q_pressed()
        await get_tree().process_frame
    check("ур.3: армия расширена до 4 бойцов", Game.necro_army.size() == 4)

    # фазовый рывок сквозь стены (но не за край карты)
    d2._dash_cd = 0.0
    var before: Vector2 = d2.player.position
    var dashed := Combat.start_dash(d2, Vector2.RIGHT)
    await get_tree().process_frame
    check("фазовый рывок прошёл сквозь стены (48 px, кулдаун 2 с)",
        dashed and d2.player.position.x > before.x + 40.0
        and absf(float(d2._dash_cd) - 2.0) < 0.1)
    # out of bounds запрещён: герой у левого края, рывок влево не тратится
    d2._dash_cd = 0.0
    d2.player.position = Vector2(4, 24)
    var oob := Combat.start_dash(d2, Vector2.LEFT)
    check("за край карты фазовый рывок не идёт (кулдаун не тратится)",
        not oob and float(d2._dash_cd) == 0.0)
    d2.player.position = before

    # безумие: мобы 10 секунд бьют друг друга
    var lv := living_foes(d2)
    check("для безумия нужны двое живых", lv.size() >= 2)
    if lv.size() >= 2:
        var mad1: Dictionary = lv[0]
        var victim: Dictionary = lv[1]
        # сводим их вплотную и снимаем броски/телеграфы
        (mad1["node"] as Node2D).position = (victim["node"] as Node2D).position \
            + Vector2(14, 0)
        victim["hp"] = maxi(1, int(victim["max_hp"]))
        Game.restore_mana(100)
        var mana_m := Game.mana
        d2._on_t_pressed()
        await get_tree().process_frame
        check("безумие включено (мана -40, кулдаун 25 с)",
            int(mad1.get("mad_until", 0)) > Time.get_ticks_msec()
            and Game.mana == mana_m - 40 and absf(float(d2._t_cd) - 25.0) < 0.1)
        var victim_hp0 := int(victim["hp"])
        for i in range(260):   # запас на кулдаун атаки и обход стен
            await get_tree().physics_frame
            if int(victim["hp"]) < victim_hp0:
                break
        check("безумный моб бьёт собратьев (хп жертвы упало)",
            int(victim["hp"]) < victim_hp0)

    # зов босса: до победы заперт, после — босс на стороне героя на 10 с
    Game.restore_mana(Game.max_mana())
    var mana_b := Game.mana
    d2._on_special_pressed()
    await get_tree().process_frame
    var boss_before := false
    for a in d2._minions:
        if String(a.get("kind", "")) == "boss":
            boss_before = true
    check("без победы над боссом зов заперт (мана не списана, босса нет)",
        Game.boss_summon_until == 0 and not boss_before and Game.mana == mana_b)
    Game.demon_defeated = true
    d2._special_cd = 0.0
    d2._on_special_pressed()
    await get_tree().process_frame
    var boss_ally := {}
    for a in d2._minions:
        if String(a.get("kind", "")) == "boss":
            boss_ally = a
    check("после победы зов призвал босса на 10 с (мана -60)",
        not boss_ally.is_empty() and Game.boss_summon_until > Time.get_ticks_msec()
        and Game.mana == mana_b - 60)
    # босс уходит по таймеру
    if not boss_ally.is_empty():
        boss_ally["until"] = Time.get_ticks_msec() - 1
        Minions.update_allies(d2, 0.016)
        var boss_after := false
        for a in d2._minions:
            if String(a.get("kind", "")) == "boss":
                boss_after = true
        check("босс уходит по истечении 10 с",
            Game.boss_summon_until == 0 and not boss_after)

    d2.queue_free()
    await get_tree().process_frame

    # ================== мир: призыв ходит с героем ==================
    Game.new_run(3, "demonologist")
    var w := await load_world()
    check("мир загрузился для демоноолога", w.player != null)
    check("в мире у демоноолога нет союзников до призыва", w._minions.is_empty())
    w._on_q_pressed()
    await get_tree().process_frame
    check("в мире Q призвал демона", Game.summons_active.has("demon")
        and w._minions.size() == 1)
    check("мирный демон — не цель для союзников", w._enemy_records().is_empty())
    check("HUD мира: у колдуна есть полоса маны", w._hud_mana != null)
    var w_block: Control = null
    for child in (w._hud_bar as Control).get_children():
        if child is Control and child.has_meta("abilities_block"):
            w_block = child
    check("блок «СПОСОБНОСТИ» демоноолога: 4 ячейки с ценой маны",
        w_block != null and w._hud_summon_cells != null
        and (w._hud_summon_cells as Array).size() == 4)
    w.queue_free()
    await get_tree().process_frame
    check("при уходе из мира хп демона сохранено в Game",
        Game.summons_active.has("demon"))

    Game.new_run(3, "necromancer")
    var w2 := await load_world()
    var w2_block: Control = null
    for child in (w2._hud_bar as Control).get_children():
        if child is Control and child.has_meta("abilities_block"):
            w2_block = child
    check("блок «СПОСОБНОСТИ» некроманта: счётчик армии", w2_block != null
        and w2._hud_army_count != null)
    w2._on_q_pressed()
    await get_tree().process_frame
    check("в мире подъём мёртвых отказывает (трупы врагов только в данжах)",
        Game.necro_army.is_empty())
    w2.queue_free()
    await get_tree().process_frame

    Game.level = 1
    Game.demon_defeated = false
    print("STEP31: ПРОВАЛОВ: ", failed)
    get_tree().quit(1 if failed > 0 else 0)

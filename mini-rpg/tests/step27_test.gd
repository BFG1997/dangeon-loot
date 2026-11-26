## Тест боевой системы (шаг 27): разброс урона и криты, серия ударов
## (комбо — третий удар усилен), i-frames после попадания, рывок-уклонение
## (Ctrl и двойной тап), телеграфы врагов (приседание/замах до удара,
## промах при отходе), слоты приёмов в HUD (Q/пробел/T с кулдаунами),
## варианты боевых звуков и крит-метка урона.
## Запуск: godot --headless --path . res://tests/step27_test.tscn
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

func _ready() -> void:
    print("STEP27 TEST: боёвка — комбо, криты, i-frames, рывок, телеграфы")
    Saves.wipe_all_slots()
    Game.meta["last_slot"] = 0
    Game.meta["last_bonus_date"] = ""
    Game.meta["pending_gold"] = 0
    Game.meta["pending_items"] = []
    Game.save_meta()

    # ================== Combat.roll: детерминизм и границы ==================
    var det := Combat.roll(10, 0, false)
    check("без случайности урон ровно базовый", int(det["value"]) == 10
        and not bool(det["crit"]))
    var det_combo := Combat.roll(10, 3, false)
    check("без случайности комбо тоже не меняет урон", int(det_combo["value"]) == 10)
    var lo_hi := Combat.roll_range(10, 0)
    check("границы разброса ±15%: низ 9, верх с критом 23", lo_hi.x == 9 and lo_hi.y == 23)
    var crit_seen := 0
    var in_bounds := true
    var crit_min := 10000
    for i in range(300):
        var r := Combat.roll(10, 0, true)
        var v := int(r["value"])
        if v < lo_hi.x or v > lo_hi.y:
            in_bounds = false
        if bool(r["crit"]):
            crit_seen += 1
            crit_min = mini(crit_min, v)
    check("300 бросков урона в границах ±15%", in_bounds)
    check("крит удваивает: минимум крита >= 2*низ разброса", crit_min >= 2 * lo_hi.x)
    check("криты случаются около 10% (5..20%)", crit_seen >= 15 and crit_seen <= 60)
    var plain_max := int(round(10.0 * (1.0 + Combat.SPREAD)))
    var combo_min := 10000
    for i in range(100):
        combo_min = mini(combo_min, int(Combat.roll(10, 3, true)["value"]))
    check("третий удар серии всегда сильнее обычного максимума",
        combo_min > plain_max)
    check("roll_range серии: минимум x1.5 и максимум с критом",
        Combat.roll_range(10, 3).x == 13 and Combat.roll_range(10, 3).y == 35)

    # ================== i-frames героя (уровень Game) ==================
    Game.new_run(1, "warrior")
    var hp0 := Game.hp
    Game.grant_iframes(0.5)
    check("i-frames активны сразу", Game.hero_iframes_left() > 0.4)
    Game.damage_hp(10, true)
    check("боевое попадание при i-frames глотается", Game.hp == hp0)
    Game.damage_hp(10)
    check("прямой damage_hp (без respect) проходит как раньше",
        Game.hp == hp0 - 10)
    await get_tree().create_timer(0.6).timeout
    check("i-frames гаснут по таймеру", Game.hero_iframes_left() == 0.0)
    Game.grant_iframes(0.05)
    check("повторное попадание не удлиняет защиту (maxf)",
        Game.hero_iframes_left() <= 0.05)
    await get_tree().create_timer(0.1).timeout
    check("короткие i-frames тоже гаснут", Game.hero_iframes_left() == 0.0)
    var hp_before := Game.hp
    Game.damage_hp(10, true)
    check("после истечения i-frames урон проходит", Game.hp == hp_before - 10)

    # ================== рывок-уклонение (мир, воин — шаг 29: кд 1 с) ==================
    Game.new_run(1, "warrior")
    Game.dungeon_floor = 1
    var world := await load_world()
    check("в тестовом окружении боевая случайность выключена",
        not Game.combat_variance)
    check("у воина на пробеле именно рывок", Combat.dash_kind() == "dash")
    var dash_ok := Combat.start_dash(world)
    check("рывок начался", dash_ok and world._dash_time > 0.0)
    check("кулдаун рывка — из приёма героя (1 с)",
        absf(world._dash_cd - float(Game.ability_info("dash").get("cd", 1.0))) < 0.05
        and world._dash_cd < 1.1)
    check("рывок даёт i-frames 0.25 с", Game.hero_iframes_left() >= 0.24)
    check("второй рывок сразу не выходит (кулдаун)", not Combat.start_dash(world))
    var ghost_pos := (world.player as CharacterBody2D).position
    var time_before: float = world._dash_time
    Combat.tick_dash(world, 0.05, world._world)
    check("рывок гонит героя по направлению",
        (world.player as CharacterBody2D).velocity.length() > 200.0)
    check("тик рывка гасит его время", world._dash_time < time_before)
    # двойной тап направления
    world._last_dir_taps.clear()
    world._dash_cd = 0.0
    world._dash_time = 0.0
    var tap1 := Combat.on_direction_tap(world, &"move_right")
    var tap2 := Combat.on_direction_tap(world, &"move_right")
    check("первый тап направления не рывок, второй — рывок",
        not tap1 and tap2)
    world.queue_free()
    await get_tree().process_frame

    # ================== комбо: серия ударов (мир) ==================
    Game.new_run(1, "warrior")
    world = await load_world()
    check("серия пуста на старте", world._combo_idx == 0 and world._combo_left == 0.0)
    # промах по воздуху серию не наполняет
    world._facing = "down"
    world._strike_cd = 0.0
    world._strike()
    check("удар мимо серию не растит", world._combo_idx == 0)
    # три подряд удара по Глоту (кулачный урон 5, в тестах без случайности)
    var glot: Dictionary = {}
    for npc in world._npcs:
        if String(npc["id"]) == "glot" and not bool(npc.get("dead", false)):
            glot = npc
    check("Глот найден", not glot.is_empty())
    var glot_hp: int = int(glot["hp"])
    world.player.position = ((glot["node"] as Node2D).position) + Vector2(-18, 0)
    world._facing = "side"
    world._player_sprite.flip_h = false
    for i in range(3):
        world._strike_cd = 0.0
        world._strike()
        if i == 0:
            check("первый удар серии — номер 1", world._combo_idx == 1)
        if i == 1:
            check("второй удар серии — номер 2", world._combo_idx == 2)
    check("в тест-режиме усиления нет: третий удар — номер 3, урон ровно 15",
        world._combo_idx == 3 and int(glot["hp"]) == glot_hp - 15)
    check("окно серии заведено", world._combo_left > 0.0)
    await get_tree().create_timer(1.3).timeout
    check("серия гаснет после окна 1.2 с", world._combo_idx == 0
        and world._combo_left == 0.0)
    # усиленный третий удар: включаем случайность — суммарный урон серии
    # обязан превысить 15 (x1.5 на третьем: минимум 5+5+6=16)
    Game.combat_variance = true
    glot_hp = int(glot["hp"])
    for i in range(3):
        world._strike_cd = 0.0
        world._strike()
    check("с вариативностью третий удар серии усилен (сумма > 15)",
        glot_hp - int(glot["hp"]) > 15)
    check("усиленный удар обнулил счётчик серии", world._combo_idx == 0)
    Game.combat_variance = false
    world.queue_free()
    await get_tree().process_frame

    # ================== телеграфы врагов (данж) ==================
    Game.new_run(1, "warrior")
    Game.dungeon_floor = 1
    var dungeon := await load_dungeon()
    var foe: Dictionary = {}
    for foe_scan in dungeon._foes:
        if not bool(foe_scan.get("dead", false)) and not bool(foe_scan.get("boss", false)):
            foe = foe_scan
            break
    check("живой враг найден", not foe.is_empty())
    # прочих врагов убираем с дороги и замораживаем
    for other in dungeon._foes:
        if other != foe and not bool(other.get("dead", false)):
            other["speed_override"] = 0.0
            (other["node"] as Node2D).position = Vector2(200, 900)
    dungeon.player.position = (foe["node"] as Node2D).position + Vector2(0, -14)
    foe["atk_cd"] = 0.0
    foe["tell_until"] = 0
    await get_tree().create_timer(0.25).timeout
    check("враг начал телеграф (удар ещё не пришёл)",
        Combat.telegraph_pending(foe) and Game.hp == Game.max_hp())
    var tell_base_y: float = float(foe.get("tell_scale", Vector2.ONE).y)
    check("спрайт врага меняется при телеграфе (приседает или замахивается)",
        absf((foe["sprite"] as AnimatedSprite2D).scale.y - tell_base_y) > 0.02)
    await get_tree().create_timer(0.6).timeout
    check("после телеграфа удар дошёл (герой в радиусе)", Game.hp < Game.max_hp())
    # промах: герой отпрыгнул за время замаха
    var hp_mid := Game.hp
    foe["atk_cd"] = 0.0
    foe["tell_until"] = 0
    await get_tree().process_frame
    await get_tree().create_timer(0.1).timeout
    dungeon.player.position = (foe["node"] as Node2D).position + Vector2(200, 0)
    await get_tree().create_timer(0.5).timeout
    check("герой ушёл — удар врага промахнулся", Game.hp == hp_mid)
    dungeon.queue_free()
    await get_tree().process_frame

    # ================== слоты приёмов в HUD (мир и данж) ==================
    Game.new_run(1, "barbarian")
    world = await load_world()
    check("в HUD четыре слота приёмов (шаг 29: + приём героя)", world._hud_slots.size() == 4)
    var kinds_ok: bool = world._hud_slots[0]["kind"] == "q" \
        and world._hud_slots[1]["kind"] == "dash" \
        and world._hud_slots[2]["kind"] == "t" \
        and world._hud_slots[3]["kind"] == "special"
    check("порядок слотов: Q, ПРОБЕЛ, T, CTRL (шаг 30: приём героя на пробеле)", kinds_ok)
    var icons_ok := true
    for rec in world._hud_slots:
        var tex: Texture2D = (rec["icon"] as TextureRect).texture
        if tex == null or not String(tex.resource_path).begins_with("res://assets"):
            icons_ok = false
    check("иконки слотов загружены (ability_*)", icons_ok)
    check("иконка Q варвара — топор",
        String((world._hud_slots[0]["icon"] as TextureRect).texture.resource_path)
            .contains("ability_axe"))
    check("иконка ПРОБЕЛА варвара — пинок (шаг 30: приём героя переехал)",
        String((world._hud_slots[1]["icon"] as TextureRect).texture.resource_path)
            .contains("ability_kick"))
    check("под слотом ПРОБЕЛ написана короткая метка приёма",
        String((world._hud_slots[1]["name_label"] as Label).text) == "ПИНОК")
    check("иконка CTRL варвара — прыжок (бывший пробел переехал на CTRL)",
        String((world._hud_slots[3]["icon"] as TextureRect).texture.resource_path)
            .contains("ability_death_leap"))
    check("подсказка слота называет приём",
        String((world._hud_slots[0]["panel"] as Panel).tooltip_text)
            .contains("Метательный топор"))
    world._q_cd = 1.0
    HudBuilder.update_slots(world)
    var shade: ColorRect = world._hud_slots[0]["shade"]
    var cd_label: Label = world._hud_slots[0]["cd_label"]
    check("шторка кулдауна видна и цифра секунд стоит",
        shade.size.y > 10.0 and cd_label.text == "1")
    check("иконка приглушена на кулдауне",
        (world._hud_slots[0]["icon"] as TextureRect).modulate != Color.WHITE)
    world._q_cd = 0.0
    HudBuilder.update_slots(world)
    check("без кулдауна шторка пуста и цифра исчезла",
        shade.size.y == 0.0 and cd_label.text == "")
    check("иконка вернула яркость",
        (world._hud_slots[0]["icon"] as TextureRect).modulate == Color.WHITE)
    # Пробел-слот: шторка идёт от _dash_cd с кулдауном пинка (10 с)
    world._dash_cd = 10.0
    HudBuilder.update_slots(world)
    check("шторка приёма героя идёт от _dash_cd",
        (world._hud_slots[1]["shade"] as ColorRect).size.y > 30.0
        and (world._hud_slots[1]["cd_label"] as Label).text == "10")
    world._dash_cd = 0.0
    HudBuilder.update_slots(world)
    check("Пробел-слот вернулся в готовность", (world._hud_slots[1]["shade"] as ColorRect).size.y == 0.0)
    # шаг 29: экипировка и индикаторы эффектов в консоли
    check("мини-слоты экипировки собраны", world.get("_hud_equip") != null
        and (world.get("_hud_equip") as Dictionary).has("weapon")
        and (world.get("_hud_equip") as Dictionary).has("armor"))
    check("ряд эффектов собран и пуст на старте", world.get("_hud_buffs_box") != null
        and (world.get("_hud_buffs_box") as HBoxContainer).get_child_count() == 0)
    Game.drink_until = Time.get_ticks_msec() + 3000
    HudBuilder.update_slots(world)
    check("индикатор хмеля появляется у активного эффекта",
        (world.get("_hud_buffs_box") as HBoxContainer).get_child_count() == 1)
    Game.drink_until = 0
    HudBuilder.update_slots(world)
    check("индикатор хмеля гаснет после окончания",
        (world.get("_hud_buffs_box") as HBoxContainer).get_child_count() == 0)
    # маг: слот Q — заклинание (иконка spell), шторка от _spell_cd; пробел — телепорт
    world.queue_free()
    await get_tree().process_frame
    Game.new_run(1, "mage")
    world = await load_world()
    check("у мага слот Q показывает магию",
        String((world._hud_slots[0]["icon"] as TextureRect).texture.resource_path)
            .contains("ability_spell"))
    check("у мага слот ПРОБЕЛА — телепорт",
        String((world._hud_slots[1]["icon"] as TextureRect).texture.resource_path)
            .contains("ability_blink"))
    check("у мага слот CTRL — барьер",
        String((world._hud_slots[3]["icon"] as TextureRect).texture.resource_path)
            .contains("ability_hold_barrier"))
    world._spell_cd = 0.8
    HudBuilder.update_slots(world)
    check("кулаун мага идёт от _spell_cd",
        (world._hud_slots[0]["shade"] as ColorRect).size.y > 10.0)
    world.queue_free()
    await get_tree().process_frame

    # ================== крит-метка урона ==================
    Game.new_run(1, "warrior")
    Game.dungeon_floor = 1
    dungeon = await load_dungeon()
    var fx_parent: Node = dungeon._fx
    StrikeFx.damage_label(dungeon, fx_parent, Vector2.ZERO, 25, false, true)
    var crit_label: Label = null
    for child in fx_parent.get_children():
        if child is Label and (child as Label).text == "-25!":
            crit_label = child
    check("крит-метка: текст с восклицательным знаком", crit_label != null)
    if crit_label != null:
        check("крит-метка крупнее обычной (19 px)",
            crit_label.get_theme_font_size("font_size") == 19)
        check("крит-метка жёлтая",
            crit_label.get_theme_color("font_color") == Color(1.0, 0.92, 0.25))
    StrikeFx.damage_label(dungeon, fx_parent, Vector2(50, 0), 25)
    var plain_label: Label = null
    for child in fx_parent.get_children():
        if child is Label and (child as Label).text == "-25":
            plain_label = child
    check("обычная метка урона без восклицания", plain_label != null)
    dungeon.queue_free()
    await get_tree().process_frame

    # ================== звуковые варианты ==================
    check("у боевых звуков 3 варианта тона", Sfx.VARIANT_PITCHES.size() == 3)
    var pitches_ok := true
    for p in Sfx.VARIANT_PITCHES:
        if float(p) < 0.85 or float(p) > 1.15:
            pitches_ok = false
    check("варианты тона в пределах ±10-15%", pitches_ok)

    # ================== Ctrl-приёмы героев (шаг 29) ==================
    # маг: телепорт — мгновенный перенос на расстояние рывка.
    # Карта генерируется случайно: спавн может стоять под стеной, поэтому
    # сначала ищем точку с гарантированно открытым коридором вверх на 48 px.
    Game.new_run(1, "mage")
    Game.dungeon_floor = 1
    dungeon = await load_dungeon()
    check("у мага на пробеле телепорт", Combat.dash_kind() == "blink")
    var mage_pos := Vector2.INF
    for ty in range(4, DungeonBestiary.MAP_H - 4):
        if mage_pos.is_finite():
            break
        for tx in range(4, DungeonBestiary.MAP_W - 4):
            var pt := Vector2(tx * 16.0 + 8.0, ty * 16.0 + 12.0)
            if dungeon._blink_blocked_at(pt):
                continue
            var clear := true
            for d in [18, 24, 30, 36, 42, 48]:
                if dungeon._blink_blocked_at(pt + Vector2(0, -d)):
                    clear = false
                    break
            if clear:
                mage_pos = pt
                break
    check("найдена открытая зона для телепорта", mage_pos.is_finite())
    if mage_pos.is_finite():
        dungeon.player.position = mage_pos
        dungeon._facing = "up"   # вверх — гарантированно открытое место
        var blink_ok := Combat.start_dash(dungeon)
        var mage_new_pos: Vector2 = dungeon.player.position
        check("телепорт сработал", blink_ok)
        check("телепорт мгновенный (время рывка не заведено)", dungeon._dash_time == 0.0)
        check("телепорт переносит примерно на 48 px",
            absf(mage_new_pos.distance_to(mage_pos) - Combat.BLINK_RANGE) < 8.0)
        check("телепорт даёт i-frames как рывок", Game.hero_iframes_left() >= 0.2)
        check("второй телепорт сразу не выходит (кулдаун 1 с)", not Combat.start_dash(dungeon))
        dungeon._dash_cd = 0.0
        dungeon.player.position = mage_pos
        dungeon._facing = "up"
        var blink_tap1 := Combat.on_direction_tap(dungeon, &"move_up")
        var blink_tap2 := Combat.on_direction_tap(dungeon, &"move_up")
        check("первый тап из пары — ещё не телепорт", not blink_tap1)
        check("двойной тап вверх у мага — телепорт вверх",
            blink_tap2 and dungeon.player.position.y < mage_pos.y)
        check("третий тап не третий телепорт (кулдаун)",
            not Combat.on_direction_tap(dungeon, &"move_up"))
    dungeon.queue_free()
    await get_tree().process_frame

    # бомж: хмельной запал — 5 с неуязвимости, Flask из инвентаря не тратится
    Game.new_run(1, "bum")
    Game.dungeon_floor = 1
    dungeon = await load_dungeon()
    check("у бомжа на пробеле хмельной запал", Combat.dash_kind() == "drink")
    Game.combat_variance = false
    var bum_hp := Game.hp
    check("хмель сработал", Combat.start_dash(dungeon))
    check("хмель включил неуязвимость", Game.drink_active())
    check("кулдаун хмеля 20 с", absf(dungeon._dash_cd - 20.0) < 0.05)
    Game.damage_hp(5, true)
    check("боевой урон при хмеле глотается", Game.hp == bum_hp)
    Game.damage_hp(5)
    check("даже прямой damage_hp при хмеле глотается", Game.hp == bum_hp)
    check("двойной тап направления НЕ тратит хмель",
        not Combat.on_direction_tap(dungeon, &"move_right"))
    Game.drink_until = Time.get_ticks_msec() - 1
    check("хмель гаснет по таймеру", not Game.drink_active())
    Game.damage_hp(3)
    check("после хмеля урон проходит как раньше", Game.hp == bum_hp - 3)
    Game.combat_variance = true
    dungeon.queue_free()
    await get_tree().process_frame

    # варвар: пинок — враг в конусе получает х1.5 и отлетает, босс держит место
    Game.new_run(1, "barbarian")
    Game.dungeon_floor = 1
    dungeon = await load_dungeon()
    check("у варвара на пробеле пинок", Combat.dash_kind() == "kick")
    Game.combat_variance = false
    var kick_foe: Dictionary = {}
    for foe_scan in dungeon._foes:
        if not bool(foe_scan.get("dead", false)) and not bool(foe_scan.get("boss", false)):
            kick_foe = foe_scan
            break
    check("живой враг для пинка найден", not kick_foe.is_empty())
    for other in dungeon._foes:
        if other != kick_foe and not bool(other.get("dead", false)):
            (other["node"] as Node2D).position = Vector2(200, 900)
    # запас хп, чтобы пинок не убил врага — проверяем именно отброс
    kick_foe["hp"] = int(kick_foe["hp"]) + 200
    kick_foe["max_hp"] = int(kick_foe["max_hp"]) + 200
    # ставим пару «герой/враг» на открытое место: впереди и позади врага
    # должны быть свободные тайлы, иначе отброс честно упрётся в стену
    var placed := false
    for ty in range(2, DungeonBestiary.MAP_H - 6):
        for tx in range(2, DungeonBestiary.MAP_W - 6):
            var base := Vector2(tx * 16 + 8, ty * 16 + 8)
            if dungeon._tile_is_solid(base) \
                    or dungeon._tile_is_solid(base + Vector2(0, -30)) \
                    or dungeon._tile_is_solid(base + Vector2(0, 64)):
                continue
            (kick_foe["node"] as Node2D).position = base
            dungeon.player.position = base + Vector2(0, -30)
            placed = true
            break
        if placed:
            break
    check("найдено открытое место для проверки пинка", placed)
    dungeon._facing = "down"
    var foe_pos_before: Vector2 = (kick_foe["node"] as Node2D).position
    var foe_hp_before: int = int(kick_foe["hp"])
    var strike_now := Game.strike_damage()
    var kick_ok := Combat.start_dash(dungeon)
    check("пинок сработал", kick_ok)
    check("пинок снял ровно х1.5 урона удара (без случайности)",
        int(kick_foe["hp"]) == foe_hp_before - maxi(1, int(round(float(strike_now) * 1.5))))
    check("враг отлетел от пинка",
        (kick_foe["node"] as Node2D).position.distance_to(foe_pos_before) > 30.0)
    check("кулдаун пинка 10 с", absf(dungeon._dash_cd - 10.0) < 0.05)
    check("второй пинок сразу не выходит", not Combat.start_dash(dungeon))
    # босс не отлетает
    var boss_foe: Dictionary = {}
    for foe_scan in dungeon._foes:
        if bool(foe_scan.get("boss", false)) and not bool(foe_scan.get("dead", false)):
            boss_foe = foe_scan
            break
    if not boss_foe.is_empty() and not dungeon._boss_hostile:
        dungeon._dash_cd = 0.0
        dungeon.player.position = (boss_foe["node"] as Node2D).position + Vector2(0, -34)
        dungeon._facing = "down"
        var boss_pos_before: Vector2 = (boss_foe["node"] as Node2D).position
        var boss_hp_before: int = int(boss_foe["hp"])
        var boss_kick_ok := Combat.start_dash(dungeon)
        check("пинок достаёт босса (урон есть)", boss_kick_ok
            and int(boss_foe["hp"]) < boss_hp_before)
        check("но босс на месте не отлетает",
            (boss_foe["node"] as Node2D).position.distance_to(boss_pos_before) < 1.0)
    Game.combat_variance = true
    dungeon.queue_free()
    await get_tree().process_frame

    # ================== under_test ==================
    check("under_test видит тестовый сценарий", Game.under_test(self))
    var stranger := Node.new()
    get_tree().root.add_child(stranger)
    check("узел без тестового предка — живая игра", not Game.under_test(stranger))
    stranger.queue_free()

    print("STEP27 TEST: ПРОВАЛОВ: ", failed)
    get_tree().quit(1 if failed else 0)

## Тест способностей героев (шаг 18): у каждого класса приём на Q и приём
## на пробел (действие "special"), таблица Game.ABILITIES.
## Маг: барьер — неуязвимость пока держишь (мана 7/с, макс 5 с), бить нельзя.
## Воин: вихрь — урон оружием всем вокруг; щит — неуязвим, шаг и удары слабее.
## Бомж: пыль — враги слепнут 2 с и сбрасывают агрессию; газ — 3 тика по 15
## в радиусе 3 клеток. Варвар: топор — 100 урона снарядом; смертельный
## прыжок — на пробеле (шаг 22): не-босс умирает, боссу 200 + урон оружия;
## на T — «Гнев титана» (шаг 22): 4 секунды герой огромен, урон не
## проходит, бьёт в 4 раза сильнее. В мире приёмы действуют на демона.
## Шаг 20: у каждого класса ТРЕТИЙ приём на T (special2); шаг 22:
## кулдауны снижены ещё, приёмы варвара переезжают.
## Запуск: godot --headless --path . res://tests/abilities_test.tscn
extends Node

var failed := 0

func check(name: String, condition: bool) -> void:
    if condition:
        print("  [OK] ", name)
    else:
        failed += 1
        print("  [ПРОВАЛ] ", name)

func find_foe(world: Node2D, foe_id: String) -> Dictionary:
    for foe in world._foes:
        if String(foe["id"]) == foe_id and not bool(foe.get("dead", false)):
            return foe
    return {}

func any_foe(world: Node2D) -> Dictionary:
    for foe in world._foes:
        if not bool(foe.get("dead", false)) and not bool(foe.get("boss", false)):
            return foe
    return {}

func load_dungeon() -> Node2D:
    var dungeon: Node2D = (load("res://scenes/dungeon/dungeon.tscn") as PackedScene).instantiate()
    add_child(dungeon)
    await get_tree().process_frame
    await get_tree().process_frame
    return dungeon

func _ready() -> void:
    print("ABILITIES TEST: приёмы Q/пробел у четырёх классов")
    Saves.wipe_all_slots()
    Game.meta["last_slot"] = 0
    Game.meta["last_bonus_date"] = ""
    Game.meta["pending_gold"] = 0
    Game.meta["pending_items"] = []
    Game.save_meta()

    # ================== таблицы и управление ==================
    var kinds_ok := true
    for pair in [["mage", "spell", "hold_barrier", "mana_burst"],
            ["warrior", "swords_orbit", "hold_shield", "sword_rain"],
            ["barbarian", "axe", "death_leap", "titan_rage"],
            ["bum", "dust", "gas", "werewolf_form"]]:
        Game.new_run(1, String(pair[0]))
        var q: Dictionary = Game.ability_info("q")
        var s: Dictionary = Game.ability_info("special")
        var t: Dictionary = Game.ability_info("t")
        if q.is_empty() or s.is_empty() or t.is_empty():
            kinds_ok = false
            continue
        if String(q["kind"]) != String(pair[1]) or String(s["kind"]) != String(pair[2]):
            kinds_ok = false
        if String(t["kind"]) != String(pair[3]):
            kinds_ok = false
        if float(t["cd"]) <= 0.0:
            kinds_ok = false
        if String(pair[0]) != "mage" and (float(q["cd"]) <= 0.0 or float(s["cd"]) <= 0.0):
            kinds_ok = false
    check("у всех 4 классов заданы три приёма (Q, пробел, T)", kinds_ok)
    Game.new_run(1, "mage")
    check("барьер мага: мана 7/с и максимум 5 секунд удержания",
        float(Game.ability_info("special")["mana_per_sec"]) == 7.0
        and float(Game.ability_info("special")["max_hold"]) == 5.0)
    Game.new_run(1, "barbarian")
    check("топор варвара: 100 урона (задано автором)",
        int(Game.ability_info("q")["damage"]) == 100)
    Game.new_run(1, "bum")
    check("газ бомжа: 3 тика по 15 в радиусе 48 px (3 клетки)",
        int(Game.ability_info("special")["tick_damage"]) == 15
        and int(Game.ability_info("special")["ticks"]) == 3
        and float(Game.ability_info("special")["radius"]) == 48.0)
    # --- шаг 20: кулдауны снижены, третьи приёмы заданы ---
    Game.new_run(1, "warrior")
    # шаг 32: вихрь воина заменён на «Танцующие мечи» (10 с орбита)
    check("мечи воина: кулдаун 14 с, щит 3 с (шаги 22/32)",
        float(Game.ability_info("q")["cd"]) == 14.0
        and String(Game.ability_info("q")["kind"]) == "swords_orbit"
        and float(Game.ability_info("special")["cd"]) == 3.0)
    Game.new_run(1, "mage")
    check("выплеск магии: 20 урона за уровень, кулдаун 14 с (шаг 22)",
        int(Game.ability_info("t")["damage_per_level"]) == 20
        and float(Game.ability_info("t")["cd"]) == 14.0)
    Game.new_run(1, "bum")
    # шаг 32: T бомжа — превращение в оборотня (кулдаун 30 с, задал автор)
    check("оборотень бомжа: кулдаун смены формы 30 с (шаг 32)",
        String(Game.ability_info("t")["kind"]) == "werewolf_form"
        and float(Game.ability_info("t")["cd"]) == 30.0)
    Game.new_run(1, "barbarian")
    check("прыжок варвара на пробеле: боссу 200 урона, 15 с, радиус 140",
        int(Game.ability_info("special")["boss_damage"]) == 200
        and float(Game.ability_info("special")["cd"]) == 15.0
        and float(Game.ability_info("special")["leap_range"]) == 140.0)
    check("гнев титана на T: 4 секунды, урон x4, рост спрайта 1.55",
        float(Game.ability_info("t")["duration"]) == 4.0
        and float(Game.ability_info("t")["damage_mult"]) == 4.0
        and float(Game.ability_info("t")["scale"]) == 1.55)
    check("хватки и броска больше нет (шаг 22)",
        not Game.ABILITIES["barbarian"].has("grab_throw")
        and "grab_throw" not in String(Game.ABILITIES["barbarian"]["special"]["id"]))
    check("действие special теперь на Ctrl, приём героя (dash) — на пробеле",
        InputMap.has_action("special") and InputMap.has_action("dash")
        and (InputMap.action_get_events("special")[0] as InputEventKey).physical_keycode == KEY_CTRL
        and Controls.get_bindings("dash").size() > 0
        and (Controls.get_bindings("dash")[0] as InputEventKey).physical_keycode == KEY_SPACE)
    check("у Controls десять действий, все приёмы подписаны (шаг 30)",
        Controls.get_actions().size() == 10
        and not Controls.get_actions().has(&"special")
        and Controls.get_actions().has(&"dash")
        and Controls.get_action_label(&"dash") != ""
        and Controls.get_action_label(&"special2") == "Приём T"
        and Controls.get_action_label(&"cast_spell").contains("Q"))
    var hint := Controls.get_hud_hint(false, "Танцующие мечи", "Оборона щитом",
        "Град мечей")
    check("подсказка HUD называет приёмы, пробел и бег", hint.contains("Танцующие мечи")
        and hint.contains("Оборона щитом") and hint.contains("Град мечей")
        and hint.contains("Shift — бег") and hint.contains("Пробел — ")
        and hint.contains("Ctrl — Оборона щитом"))

    # ================== неуязвимость и щит (уровень Game) ==================
    Game.new_run(1, "warrior")
    var hp0 := Game.hp
    Game.hero_immune = true
    Game.damage_hp(10)
    check("hero_immune поглощает урон", Game.hp == hp0)
    Game.hero_immune = false
    Game.damage_hp(10)
    check("без иммунитета урон проходит", Game.hp == hp0 - 10)
    # шаг 22: форма титана — урон не проходит, удар в 4 раза сильнее
    var hp_t := Game.hp
    Game.start_titan_rage(4.0, 4.0)
    Game.damage_hp(10)
    check("в форме титана урон поглощается (но бить можно)", Game.hp == hp_t)
    Game.titan_until = 0
    Game.damage_hp(10)
    check("форма спала — урон проходит снова", Game.hp == hp_t - 10)
    Game.hp = hp_t
    Game.guard_active = true
    var base := Game._strike_damage_base()
    check("под щитом удар вдвое слабее",
        Game.strike_damage() == maxi(1, int(round(float(base) * 0.5))))
    Game.guard_active = false

    # ================== маг: барьер ==================
    Game.new_run(1, "mage")
    Game.dungeon_floor = 1
    var dungeon := await load_dungeon()
    var foe := any_foe(dungeon)
    dungeon.player.position = (foe["node"] as Node2D).position + Vector2(0, -22)
    dungeon._on_special_pressed()
    check("барьер включился (hero_immune, удержание)",
        Game.hero_immune and dungeon._special_held)
    var mana0 := Game.mana
    await get_tree().create_timer(1.2).timeout
    check("барьер тратит ману (7/с)", Game.mana < mana0)
    var foe_hp0 := int(foe["hp"])
    dungeon._strike()
    check("под барьером бить нельзя", int(foe["hp"]) == foe_hp0)
    dungeon._on_q_pressed()
    check("под барьером магия не кастуется", dungeon._bolts.is_empty())
    dungeon._on_special_released()
    check("барьер кончился по отпусканию пробела", not Game.hero_immune
        and not dungeon._special_held)
    # Шаг 23 (стабильность): за 1.2 с удержания барьера соседние враги
    # этажа успевают подойти ближе 22 px — контрольный удар уходил в
    # БЛИЖАЙШЕГО из конуса (_living_foe_in_front), а не в целевого. Отгоняем
    # и замораживаем прочих, героя ставим рядом с целью заново.
    for other in dungeon._foes:
        if not bool(other.get("dead", false)) \
                and (other["node"] as Node2D) != (foe["node"] as Node2D):
            other["speed_override"] = 0.0
            (other["node"] as Node2D).position += Vector2(0, -800)
    dungeon.player.position = (foe["node"] as Node2D).position + Vector2(0, -22)
    dungeon._facing = "down"
    dungeon._player_sprite.flip_h = false
    dungeon._strike_cd = 0.0
    dungeon._strike()
    check("после барьера удар проходит (кулаки мага)",
        int(foe["hp"]) == foe_hp0 - Game.strike_damage())
    dungeon.free()
    await get_tree().process_frame

    # ================== воин: вихрь и щит ==================
    Game.new_run(1, "warrior")
    Game.dungeon_floor = 1
    dungeon = await load_dungeon()
    var foe_a := any_foe(dungeon)
    var foe_b := any_foe(dungeon)
    if foe_b == foe_a:
        foe_b = {}
        for foe_scan in dungeon._foes:
            if not bool(foe_scan.get("dead", false)) and not bool(foe_scan.get("boss", false)) \
                    and foe_scan != foe_a:
                foe_b = foe_scan
                break
    (foe_a["node"] as Node2D).position = dungeon.player.position + Vector2(0, 30)
    (foe_b["node"] as Node2D).position = dungeon.player.position + Vector2(30, 0)
    var a_hp := int(foe_a["hp"])
    var b_hp := int(foe_b["hp"])
    dungeon._on_q_pressed()
    # шаг 32: мечи крутятся 10 секунд и бьют при касании
    check("мечи призваны: орбита активна 10 с (шаг 32)",
        dungeon._sword_orbit.size() == 3 and dungeon._orbit_left > 9.0
        and dungeon._q_cd > 0.0)
    # мечи кружат: враги около героя получают удары при касании
    for i in range(300):
        await get_tree().physics_frame
        if int(foe_a["hp"]) < a_hp and int(foe_b["hp"]) < b_hp:
            break
    check("мечи бьют всех вокруг при касании",
        int(foe_a["hp"]) < a_hp and int(foe_b["hp"]) < b_hp)
    dungeon._on_q_pressed()
    check("мечи на кулдауне не призываются второй раз",
        dungeon._sword_orbit.size() == 3 and dungeon._q_cd > 0.0)
    dungeon._on_special_pressed()
    check("щит включился (неуязвимость + guard)",
        Game.hero_immune and Game.guard_active)
    dungeon._on_special_pressed()
    check("щит не перезапускается, пока держится", dungeon._special_held)
    var shield_foe := any_foe(dungeon)
    var s_hp := int(shield_foe["hp"])
    (shield_foe["node"] as Node2D).position = dungeon.player.position + Vector2(0, 22)
    dungeon._strike()
    check("под щитом удар проходит, но вдвое слабее",
        int(shield_foe["hp"]) == s_hp - maxi(1, int(round(float(Game._strike_damage_base()) * 0.5))))
    dungeon._special_hold_left = 0.05
    await get_tree().create_timer(0.3).timeout
    check("щит гаснет по лимиту 4 с и встаёт на кулдаун",
        not Game.hero_immune and not Game.guard_active
        and dungeon._special_cd > 0.0)
    dungeon._on_special_pressed()
    check("щит на кулдауне не поднимается", not Game.guard_active)
    dungeon.free()
    await get_tree().process_frame

    # ================== бомж: пыль и газ ==================
    Game.new_run(1, "bum")
    Game.dungeon_floor = 3
    dungeon = await load_dungeon()
    # заморозка: слепота на 60 с — колдун не отходит от облака газа,
    # ближники не разбегаются, дистанции детерминированы
    for foe_freeze in dungeon._foes:
        if not bool(foe_freeze.get("dead", false)):
            foe_freeze["blind_until"] = Time.get_ticks_msec() + 60000
            foe_freeze["aggro"] = false
    var blind_foe := any_foe(dungeon)
    blind_foe["aggro"] = true
    (blind_foe["node"] as Node2D).position = dungeon.player.position + Vector2(30, 0)
    dungeon._on_q_pressed()
    check("пыль слепит врага и сбрасывает агрессию",
        bool(blind_foe.get("aggro", true)) == false
        and int(blind_foe.get("blind_until", 0)) > Time.get_ticks_msec())
    var blind_pos: Vector2 = (blind_foe["node"] as Node2D).position
    await get_tree().create_timer(0.6).timeout
    check("ослеплённый враг не двигается и не атакует",
        (blind_foe["node"] as Node2D).position == blind_pos)
    # газ: три тика по 15, дальний враг не задет
    var gas1: Dictionary = any_foe(dungeon)
    var gas2: Dictionary = {}
    for gas_scan in dungeon._foes:
        if not bool(gas_scan.get("dead", false)) and not bool(gas_scan.get("boss", false)) \
                and gas_scan != gas1:
            gas2 = gas_scan
            break
    var far_foe: Dictionary = {}
    for far_scan in dungeon._foes:
        if not bool(far_scan.get("dead", false)) and not bool(far_scan.get("boss", false)) \
                and far_scan != gas1 and far_scan != gas2:
            far_foe = far_scan
            break
    gas1["hp"] = 100
    gas1["max_hp"] = 100
    gas2["hp"] = 100
    gas2["max_hp"] = 100
    (gas1["node"] as Node2D).position = dungeon.player.position + Vector2(0, 24)
    (gas2["node"] as Node2D).position = dungeon.player.position + Vector2(40, 0)
    if not far_foe.is_empty():
        (far_foe["node"] as Node2D).position = dungeon.player.position + Vector2(0, 120)
    var far_hp := int(far_foe["hp"]) if not far_foe.is_empty() else 0
    # пыль выше перекорачивала заморозку (слепота 2 с): колдун успел бы
    # отойти от облака до третьего тика — пере-замораживаем участников
    gas1["blind_until"] = Time.get_ticks_msec() + 60000
    gas1["aggro"] = false
    gas2["blind_until"] = Time.get_ticks_msec() + 60000
    gas2["aggro"] = false
    if not far_foe.is_empty():
        far_foe["blind_until"] = Time.get_ticks_msec() + 60000
    dungeon._on_special_pressed()
    check("газ: первый тик сразу (15 урона обоим в радиусе)",
        int(gas1["hp"]) == 85 and int(gas2["hp"]) == 85)
    await get_tree().create_timer(1.2).timeout
    check("газ: второй тик раз в секунду",
        int(gas1["hp"]) == 70 and int(gas2["hp"]) == 70)
    await get_tree().create_timer(1.0).timeout
    check("газ: третий тик — итого 45 урона",
        int(gas1["hp"]) == 55 and int(gas2["hp"]) == 55)
    await get_tree().create_timer(1.2).timeout
    check("газ: четвёртого тика нет (всего 3 тика)",
        int(gas1["hp"]) == 55 and int(gas2["hp"]) == 55)
    if not far_foe.is_empty():
        check("газ не достаёт дальше 3 клеток", int(far_foe["hp"]) == far_hp)
    dungeon.free()
    await get_tree().process_frame

    # ================== варвар: топор и бросок ==================
    Game.new_run(1, "barbarian")
    Game.dungeon_floor = 1
    dungeon = await load_dungeon()
    # заморозка: слепота на 60 с — враги стоят на местах, агрессия не растёт
    for foe_freeze in dungeon._foes:
        if not bool(foe_freeze.get("dead", false)):
            foe_freeze["blind_until"] = Time.get_ticks_msec() + 60000
            foe_freeze["aggro"] = false
    # чистая вертикаль из 4 полов: игрок сверху, цель в 48 px ниже
    var axe_tile := Vector2i(-1, -1)
    for axe_y in range(2, DungeonBestiary.MAP_H - 4):
        for axe_x in range(1, DungeonBestiary.MAP_W - 1):
            var axe_clear := true
            # снаряд спавнится на 14 px выше центра тайла героя: ряд y-1
            # тоже должен быть полом, иначе топор сразу гаснет о стену
            for axe_dy in range(-1, 4):
                if DungeonBestiary.SOLID.contains(String(dungeon._grid[axe_y + axe_dy][axe_x])):
                    axe_clear = false
                    break
            if axe_clear:
                axe_tile = Vector2i(axe_x, axe_y)
                break
        if axe_tile.x >= 0:
            break
    check("найден чистый коридор для топора", axe_tile.x >= 0)
    var axe_foe := any_foe(dungeon)
    var gold0 := Game.gold
    # прочих врагов убираем с траектории полёта
    for foe_clear in dungeon._foes:
        if not bool(foe_clear.get("dead", false)) and foe_clear != axe_foe:
            (foe_clear["node"] as Node2D).position = Vector2(200, 900)
    dungeon.player.position = Vector2(axe_tile) * 16.0 + Vector2(8, 8)
    dungeon._facing = "down"
    (axe_foe["node"] as Node2D).position = dungeon.player.position + Vector2(0, 48)
    dungeon._on_q_pressed()
    check("топор вылетел снарядом с вращением",
        dungeon._bolts.size() == 1 and bool(dungeon._bolts[0].get("spin", false)))
    await get_tree().create_timer(0.7).timeout
    check("топор нанёс 100 урона первому врагу на пути",
        bool(axe_foe.get("dead", false)) and dungeon._bolts.is_empty()
        and Game.gold > gold0)
    # смертельный прыжок (шаг 22: спец-приём; шаг 30: клавиша CTRL): не-босс умирает
    var leap_foe: Dictionary = {}
    for foe_scan in dungeon._foes:
        if not bool(foe_scan.get("dead", false)) \
                and not bool(foe_scan.get("boss", false)):
            leap_foe = foe_scan
            break
    check("рядом есть живой враг для прыжка", not leap_foe.is_empty())
    if not leap_foe.is_empty():
        (leap_foe["node"] as Node2D).position \
            = dungeon.player.position + Vector2(30, 0)
        dungeon._on_special_pressed()
        check("прыжок спец-приёмом: полёт запущен, кулдаун 15 с",
            not dungeon._leap_flight.is_empty() and dungeon._special_cd > 14.0)
        for i in range(120):
            await get_tree().physics_frame
            if dungeon._leap_flight.is_empty():
                break
        check("прыжок приземлился и раздавил врага",
            dungeon._leap_flight.is_empty()
            and bool(leap_foe.get("dead", false)))
    # гнев титана (шаг 22: на T): спрайт растёт, урон не проходит, удар x4
    var base_strike := Game._strike_damage_base()
    dungeon._on_t_pressed()
    check("гнев титана включён: форма и кулдаун 45 с",
        Game.titan_active() and dungeon._t_cd > 44.0
        and Game.titan_damage_mult() == 4.0)
    await get_tree().create_timer(0.4).timeout
    check("гнев титана: спрайт вырос",
        dungeon._titan_big and dungeon._player_sprite.scale.x > 1.2)
    var hp_titan := Game.hp
    dungeon._foe_attack({"dmg": 10})
    check("гнев титана: урон врага не проходит", Game.hp == hp_titan)
    check("гнев титана: удар в 4 раза сильнее",
        Game.strike_damage() == base_strike * 4)
    Game.titan_until = Time.get_ticks_msec() - 1
    await get_tree().create_timer(0.4).timeout
    check("гнев титана: форма спала, спрайт и удар вернулись",
        not Game.titan_active() and not dungeon._titan_big
        and Game.strike_damage() == base_strike
        and dungeon._player_sprite.scale.x < 1.1)
    # боссу прыжок не убивает, а наносит 200 + урон актуального удара
    dungeon._goto_floor(4)
    await get_tree().process_frame
    await get_tree().process_frame
    var boss: Dictionary = dungeon._boss_record()
    check("на 4-м этаже есть босс", not boss.is_empty())
    if not boss.is_empty():
        # прочих врагов этажа убираем: прыжок бьёт по ближайшему
        for foe_clear in dungeon._foes:
            if not bool(foe_clear.get("dead", false)) \
                    and not bool(foe_clear.get("boss", false)):
                (foe_clear["node"] as Node2D).position = Vector2(200, 900)
        dungeon.player.position = (boss["node"] as Node2D).position + Vector2(0, -30)
        await get_tree().process_frame
        await get_tree().process_frame
        if dungeon._dialogue.visible:
            dungeon._dialogue._close()
            await get_tree().process_frame
        var boss_hp := int(boss["hp"])
        dungeon._special_cd = 0.0   # прыжок на 1-м этаже оставил кулдаун
        dungeon._on_special_pressed()
        check("прыжок на босса запущен с пробела",
            dungeon._special_cd > 0.0 or not dungeon._leap_flight.is_empty())
        for i in range(120):
            await get_tree().physics_frame
            if dungeon._leap_flight.is_empty():
                break
        check("боссу нанесено 200 + урон оружия, он выжил",
            int(boss["hp"]) == boss_hp - (200 + Game.strike_damage())
            and not bool(boss.get("dead", false)))
    dungeon.free()
    await get_tree().process_frame

    # ================== мир: демон ==================
    Game.new_run(1, "bum")
    Game.kill_npc("glot")
    var world: Node2D = (load("res://scenes/world/world.tscn") as PackedScene).instantiate()
    add_child(world)
    await get_tree().process_frame
    await get_tree().process_frame
    var demon: Dictionary = world._demon_record()
    check("демон вышел к краю улицы после жертвы", not demon.is_empty())
    if not demon.is_empty():
        Game.demon_enraged = true
        var demon_node: Node2D = demon["node"]
        world.player.position = demon_node.position + Vector2(-40, 0)
        var hp_demon := int(demon["hp"])
        world._on_q_pressed()   # пыль бомжа
        check("пыль слепит разъярённого демона",
            int(demon.get("blind_until", 0)) > Time.get_ticks_msec())
        var demon_pos: Vector2 = demon_node.position
        await get_tree().create_timer(0.7).timeout
        check("ослеплённый демон не гонится и не бьёт",
            demon_node.position == demon_pos and Game.hp == Game.max_hp())
        world._on_special_pressed()   # газ бомжа
        check("газ жжёт демона (первый тик -15)", int(demon["hp"]) == hp_demon - 15)
        # барьер мага против когтей демона
        Game.hero_immune = true
        world.player.position = demon_node.position + Vector2(0, -20)
        demon["atk_cd"] = 0.0
        var hp_hero := Game.hp
        await get_tree().create_timer(1.3).timeout
        check("барьер поглощает удары демона", Game.hp == hp_hero)
        Game.hero_immune = false
        demon["atk_cd"] = 0.0
        await get_tree().create_timer(0.7).timeout
        # шаг 26: урон берём из константы сцены — шаг 25 поднял его 8 → 10,
        # захардкоженное ожидание ломало тест при каждом ребалансе.
        check("без барьера демон бьёт (урон демона)",
            Game.hp == hp_hero - int(world.DEMON_DAMAGE))
    world.free()
    await get_tree().process_frame
    Game.hero_immune = false
    Game.guard_active = false

    if failed == 0:
        print("ABILITIES TEST: ВСЁ ОК")
        get_tree().quit(0)
    else:
        print("ABILITIES TEST: ПРОВАЛОВ: ", failed)
        get_tree().quit(1)

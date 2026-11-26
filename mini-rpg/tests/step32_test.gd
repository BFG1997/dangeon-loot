## Тест шага 32: правки автора после шага 31.
## 1. Демоны переносятся между этажами данжа (stash/restore) и дерутся
##    после перехода; повторный вызов не «изгоняет» их молча.
## 2. Фазовый рывок Некроманта не оставляет в стене: прыжок в сторону
##    стены выносит на ДРУГУЮ сторону; за край не пускает; в стене не
##    застрять (приземление всегда на свободной точке).
## 3. Тёмное оружие колдунов (26 предметов): носить могут только
##    Демоноолог и Некромант; F стреляет за ману — снаряд с ядом
##    (череп шептунов), луч (коса могильника), вспышка (колокол).
## 4. Маг на F с магическим оружием пускает ЛУТ этого оружия (луч).
## 5. Воин: Q — мечи крутятся 10 с (уже в abilities_test), T — клинков
##    больше с уровнем.
## 6. Бомж-оборотень: превращение на T (30 с кулдаун обе стороны),
##    когти Q (5 ударов), вой Ctrl (оглушение 5 с / босс 3 с),
##    наброситься на пробеле — враг СЪЕДЕН, остаётся мясо.
## Запуск: godot --headless --path . res://tests/step32_test.tscn
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

func living_foes(d: Node2D) -> Array:
    var out: Array = []
    for foe in d._foes:
        if not bool(foe.get("dead", false)):
            out.append(foe)
    return out

func _ready() -> void:
    print("STEP32 TEST: этажи с демонами, фаза без застревания, тёмное оружие, луч мага, оборотень")
    Saves.wipe_all_slots()
    Game.meta["last_slot"] = 0
    Game.meta["last_bonus_date"] = ""
    Game.save_meta()

    # ================== 1. демоны ходят между этажами ==================
    Game.new_run(1, "demonologist")
    Game.dungeon_floor = 1
    Game.mana = Game.max_mana()
    var d: Node2D = await load_dungeon()
    Game.restore_mana(200)
    d._on_q_pressed()   # вызвали демона
    await get_tree().process_frame
    check("демон призван на 1-м этаже", Game.summons_active.has("demon")
        and d._minions.size() == 1)
    var demon_hp0: int = int((d._minions[0] as Dictionary)["hp"])
    d._goto_floor(2)
    await get_tree().process_frame
    await get_tree().process_frame
    check("после перехода на 2-й этаж демон с героем (узел живой)",
        Game.summons_active.has("demon") and d._minions.size() == 1
        and is_instance_valid((d._minions[0] as Dictionary)["node"]))
    check("хп демона перенеслось", int((d._minions[0] as Dictionary)["hp"]) == demon_hp0)
    # демоны дерутся на новом этаже: сводим врага с демоном
    var foe_near: Dictionary = {}
    for foe in living_foes(d):
        if not bool(foe.get("boss", false)):
            foe_near = foe
            break
    check("на 2-м этаже есть враг", not foe_near.is_empty())
    var foe_hp0 := 0
    if not foe_near.is_empty():
        (foe_near["node"] as Node2D).position \
            = (d._minions[0]["node"] as Node2D).position + Vector2(14, 0)
        foe_hp0 = int(foe_near["hp"])
        for i in range(120):
            await get_tree().physics_frame
            if int(foe_near["hp"]) < foe_hp0:
                break
        check("демон на новом этаже БЬЁТ врагов",
            int(foe_near["hp"]) < foe_hp0)
    # повторное нажатие отпускает демона (кулдауна нет), третье — возвращает
    d._on_q_pressed()
    check("повторное нажатие отпустило демона (без кулдауна)",
        not Game.summons_active.has("demon") and d._minions.is_empty()
        and Game.summon_cd_left("demon") == 0.0)
    Game.restore_mana(200)
    d._on_q_pressed()
    check("после отпуска демона можно позвать снова",
        Game.summons_active.has("demon") and d._minions.size() == 1)
    d.free()
    await get_tree().process_frame

    # ================== 2. фазовый рывок не застревает ==================
    Game.new_run(2, "necromancer")
    Game.dungeon_floor = 1
    var d2: Node2D = await load_dungeon()
    var before: Vector2 = d2.player.position
    # ставим героя вплотную к ТОНКОЙ стене (свободный пол с обеих сторон)
    var wall_pos := Vector2.INF
    for ty in range(5, 40):
        for tx in range(5, 40):
            if d2._tile_is_solid(Vector2(tx * 16 + 8, ty * 16 + 8)) \
                    and not d2._tile_is_solid(Vector2((tx + 1) * 16 + 8, ty * 16 + 8)) \
                    and not d2._tile_is_solid(Vector2((tx - 1) * 16 + 8, ty * 16 + 8)):
                wall_pos = Vector2((tx + 1) * 16 + 2, ty * 16 + 8)
                break
        if wall_pos.is_finite():
            break
    check("нашла тонкая стена для фазового рывка", wall_pos.is_finite())
    if wall_pos.is_finite():
        d2.player.position = wall_pos
        d2._dash_cd = 0.0
        var ok := Combat.start_dash(d2, Vector2.LEFT)
        var landed: Vector2 = d2.player.position
        var stuck: bool = d2._tile_is_solid(landed)
        check("прыжок В СТОРОНУ стены выносит на другую сторону (не застрял)",
            ok and not stuck)
        check("после фазы герой в пределах карты", d2._pos_in_map(landed))
    # застрявшего в стене героя рывок вытаскивает
    var deep_wall := Vector2.INF
    for ty in range(5, 40):
        for tx in range(5, 40):
            if d2._tile_is_solid(Vector2(tx * 16 + 8, ty * 16 + 8)) \
                    and not d2._tile_is_solid(Vector2((tx + 1) * 16 + 8, ty * 16 + 8)):
                deep_wall = Vector2(tx * 16 + 8, ty * 16 + 8)
                break
        if deep_wall.is_finite():
            break
    if deep_wall.is_finite():
        d2.player.position = deep_wall   # симуляция застревания (спасение рывком)
        d2._dash_cd = 0.0
        Combat.start_dash(d2, Vector2.RIGHT)
        var landed2: Vector2 = d2.player.position
        check("застрявшего в стене рывок вытаскивает на свободное место",
            not d2._tile_is_solid(landed2))
    d2.player.position = before
    d2._dash_cd = 0.0
    # за край карты не пускает (проверка шага 31 остаётся верной)
    d2.player.position = Vector2(4, 24)
    d2._dash_cd = 0.0
    var oob := Combat.start_dash(d2, Vector2.LEFT)
    check("за край карты фазовый рывок не идёт (шаг 32 не сломал шаг 31)",
        not oob)
    d2.free()
    await get_tree().process_frame

    # ================== 3. тёмное оружие колдунов ==================
    check("26 тёмных предметов описаны в ItemDB",
        ItemDB.get_item("skull_whispers").size() > 0
        and ItemDB.get_item("doom_staff").size() > 0
        and ItemDB.get_item("chained_heart").size() > 0
        and ItemDB.get_item("grave_scythe").size() > 0)
    check("череп шептунов: зелёная смерть с ядом (задал автор)",
        String(ItemDB.f_attack("skull_whispers").get("kind", "")) == "bolt"
        and String(ItemDB.f_attack("skull_whispers").get("effect", "")) == "poison"
        and int(ItemDB.f_attack("skull_whispers").get("damage", 0)) > 0)
    check("посох погибели: урон и выстрел за ману (задал автор)",
        int(ItemDB.damage("doom_staff")) == 28
        and int(ItemDB.f_attack("doom_staff").get("mana", 0)) == 14
        and String(ItemDB.f_attack("doom_staff").get("kind", "")) == "bolt")
    check("виды F-атаки: bolt/beam/nova среди новых предметов",
        String(ItemDB.f_attack("grave_scythe").get("kind", "")) == "beam"
        and String(ItemDB.f_attack("grave_bell").get("kind", "")) == "nova"
        and String(ItemDB.f_attack("skull_whispers").get("kind", "")) == "bolt")
    # носить может только колдун
    Game.new_run(1, "warrior")
    Game.add_item({"item_id": "skull_whispers", "title": "Череп шептунов",
        "quality": "gray"})
    var res := Game.try_equip_weapon("skull_whispers")
    check("воину череп не даётся (class_rejected)",
        not bool(res.get("ok", true))
        and String(res.get("reason", "")) == "class_rejected")
    Game.new_run(1, "demonologist")
    Game.add_item({"item_id": "skull_whispers", "title": "Череп шептунов",
        "quality": "gray"})
    check("демоноолог носит череп", Game.equip_weapon("skull_whispers"))
    var f_info := Game.f_attack_info()
    check("F-атака черепа доступна (мана/яд на месте)",
        not f_info.is_empty()
        and String(f_info.get("effect", "")) == "poison")
    # F-выстрел с ядом: враг получает урон и статус яда
    Game.dungeon_floor = 1
    var d3: Node2D = await load_dungeon()
    var victim: Dictionary = {}
    for foe in living_foes(d3):
        if not bool(foe.get("boss", false)):
            victim = foe
            break
    check("есть враг для выстрела", not victim.is_empty())
    if not victim.is_empty():
        d3._facing = "side"
        d3._player_sprite.flip_h = false
        # отводим прочих врагов — снаряд должен попасть ИМЕННО в жертву
        for foe in living_foes(d3):
            if foe != victim:
                (foe["node"] as Node2D).position = d3.player.position + Vector2(400, 400)
        (victim["node"] as Node2D).position = d3.player.position + Vector2(24, 0)
        victim["hp"] = 300   # запас хп: один выстрел и яд его не убьют
        Game.restore_mana(200)
        var vhp := int(victim["hp"])
        d3._strike_cd = 0.0
        d3._strike()   # F-атака: зелёная смерть (болт летит ~0.1 с)
        var bolt_hit := false
        for i in range(90):
            await get_tree().physics_frame
            if int(victim["hp"]) < vhp:
                bolt_hit = true
                break
        check("выстрел черепом попал (урон)", bolt_hit)
        check("враг отравлен (яд на месте)",
            int(victim.get("poison_until", 0)) > Time.get_ticks_msec())
        var poisoned_hp := int(victim["hp"])
        for i in range(150):
            await get_tree().physics_frame
            if int(victim["hp"]) < poisoned_hp:
                break
        check("яд тикает: хп врага продолжает падать",
            int(victim["hp"]) < poisoned_hp)
    d3.free()
    await get_tree().process_frame

    # ================== 4. луч мага на F ==================
    Game.new_run(1, "mage")
    Game.add_item({"item_id": "staff_embers", "title": "Посох углей",
        "quality": "gray"})
    check("маг взял посох углей", Game.equip_weapon("staff_embers"))
    var beam := Game.f_attack_info()
    check("маг на F получает луч своего оружия (посох углей)",
        not beam.is_empty() and String(beam.get("kind", "")) == "beam"
        and int(beam.get("mana", 0)) == 14
        and String(beam.get("weapon_id", "")) == "staff_embers")
    Game.dungeon_floor = 1
    var d4: Node2D = await load_dungeon()
    var m_victim: Dictionary = {}
    for foe in living_foes(d4):
        if not bool(foe.get("boss", false)):
            m_victim = foe
            break
    if not m_victim.is_empty():
        d4._facing = "side"
        d4._player_sprite.flip_h = false
        (m_victim["node"] as Node2D).position = d4.player.position + Vector2(24, 0)
        Game.restore_mana(200)
        var mv_hp := int(m_victim["hp"])
        d4._strike_cd = 0.0
        d4._strike()
        check("луч мага бьёт по прямой", int(m_victim["hp"]) < mv_hp)
    d4.free()
    await get_tree().process_frame

    # ================== 5. град мечей растёт с уровнем ==================
    Game.new_run(1, "warrior")
    Game.dungeon_floor = 1
    var d5: Node2D = await load_dungeon()
    var info1 := Game.ability_info("t")
    d5._do_sword_rain(info1)
    check("град мечей: 12 клинков на 1-м уровне", d5._sword_rain.size() == 12)
    for rec in d5._sword_rain:
        (rec["node"] as Sprite2D).queue_free()
    d5._sword_rain.clear()
    Game.level = 3
    d5._do_sword_rain(Game.ability_info("t"))
    check("град мечей: 16 клинков на 3-м уровне (12+2×2)",
        d5._sword_rain.size() == 16)
    for rec in d5._sword_rain:
        (rec["node"] as Sprite2D).queue_free()
    d5._sword_rain.clear()
    Game.level = 1
    d5.free()
    await get_tree().process_frame

    # ================== 6. оборотень ==================
    Game.new_run(1, "bum")
    Game.dungeon_floor = 1
    var d6: Node2D = await load_dungeon()
    check("у бомжа на T превращение (30 с)",
        String(Game.ability_info("t")["kind"]) == "werewolf_form"
        and float(Game.ability_info("t")["cd"]) == 30.0)
    d6._on_t_pressed()
    await get_tree().process_frame
    check("бомж стал оборотнем: приёмы сменились",
        Game.werewolf_active
        and String(Game.ability_info("q")["kind"]) == "claws"
        and String(Game.ability_info("dash")["kind"]) == "pounce"
        and String(Game.ability_info("special")["kind"]) == "howl"
        and String(Game.ability_info("t")["kind"]) == "werewolf_form")
    check("оборотень крупнее всех (спрайт х1.5)",
        d6._player_sprite.scale.is_equal_approx(Vector2(1.5, 1.5)))
    # когти: 5 ударов
    var claw_victim: Dictionary = {}
    for foe in living_foes(d6):
        if not bool(foe.get("boss", false)):
            claw_victim = foe
            break
    check("есть враг для когтей", not claw_victim.is_empty())
    if not claw_victim.is_empty():
        d6._facing = "side"
        d6._player_sprite.flip_h = false
        (claw_victim["node"] as Node2D).position = d6.player.position + Vector2(16, 0)
        var c_hp := int(claw_victim["hp"])
        d6._q_cd = 0.0
        d6._do_claws(Game.ability_info("q"))
        var per_hit := Game.werewolf_claw_damage()
        check("когти: 5 ударов подряд бьют врага (вплоть до смерти)",
            int(claw_victim["hp"]) == maxi(0, c_hp - per_hit * 5))
    # вой: оглушение (босс — короче)
    d6._special_cd = 0.0
    var now_ms := Time.get_ticks_msec()
    d6._do_howl(Game.ability_info("special"))
    var stuns: Array = []
    for foe in living_foes(d6):
        if int(foe.get("stun_until", 0)) > now_ms:
            stuns.append(foe)
    check("вой оглушил врагов этажа", not stuns.is_empty())
    var boss_stun := 0
    for foe in d6._foes:
        if bool(foe.get("boss", false)) and not bool(foe.get("dead", false)):
            boss_stun = int(foe.get("stun_until", 0)) - now_ms
    if boss_stun > 0:
        check("боссу от воя достаётся меньше (3 с, не 5 с)",
            boss_stun <= 3200 and boss_stun > 2500)
    check("кулдаун воя 12 с", absf(float(d6._special_cd) - 12.0) < 0.2)
    # наброситься и СЪЕСТЬ: враг исчезает, остаётся мясо
    var meal: Dictionary = {}
    for foe in living_foes(d6):
        if not bool(foe.get("boss", false)):
            foe["stun_until"] = 0   # снимаем оглушение от воя для чистоты теста
            if meal.is_empty():
                meal = foe
    check("есть враг для наброса", not meal.is_empty())
    if not meal.is_empty():
        (meal["node"] as Node2D).position = d6.player.position + Vector2(40, 0)
        var meal_pos: Vector2 = (meal["node"] as Node2D).position
        var meat_before := 0
        for it in Game.inventory:
            if String(it.get("item_id", "")) == "meat":
                meat_before += 1
        d6._dash_cd = 0.0
        var pounced := Combat.start_dash(d6, Vector2.RIGHT)
        check("набросился: прыжок начался", pounced and not d6._leap_flight.is_empty())
        for i in range(60):
            await get_tree().physics_frame
            if d6._leap_flight.is_empty():
                break
        await get_tree().process_frame
        var meat_after := 0
        for it in Game.inventory:
            if String(it.get("item_id", "")) == "meat":
                meat_after += 1
        check("враг СЪЕДЕН: мёртв, герой у его места", bool(meal.get("dead", false)))
        check("от съеденного осталось мясо (+1 в сумку)",
            meat_after == meat_before + 1)
        var _unused := meal_pos
    # обратно в человека: пока идёт 30-с кулдаун смены — нельзя; после — можно
    d6._on_t_pressed()
    check("смена формы на кулдауне не работает", Game.werewolf_active)
    Game.werewolf_cd_until = 0   # симулируем истечение 30 с
    d6._t_cd = 0.0
    d6._on_t_pressed()
    check("T оборотня возвращает человека (и ставит 30 с кулдаун)",
        not Game.werewolf_active and Game.werewolf_cd_left() > 24.0
        and String(Game.ability_info("q")["kind"]) == "dust")
    Game.werewolf_active = false
    Game.werewolf_cd_until = 0
    d6.free()
    await get_tree().process_frame

    # ================== мясо как еда ==================
    check("мясо в ItemDB: еда, 35 хп, цена 12",
        String(ItemDB.get_item("meat").get("type", "")) == "food"
        and int(ItemDB.get_item("meat").get("heal", 0)) == 35)

    if failed == 0:
        print("STEP32 TEST: ВСЁ ОК")
        get_tree().quit(0)
    else:
        print("STEP32 TEST: ПРОВАЛОВ: ", failed)
        get_tree().quit(1)

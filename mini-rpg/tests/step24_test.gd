## Тест шага 24: портал и ключи боссов, баг диалога в босс-комнатах,
## бездонный скроллящийся инвентарь, баланс, лестницы, интерактивный
## реквизит, щупальца из стен, мутация NPC, финал с Королевой ночи и
## Шуб-Ниггурат (данж 4).
## Запуск: godot --headless --path . res://tests/step24_test.tscn
extends Node

var failed := 0

func check(name: String, condition: bool) -> void:
    if condition:
        print("  [OK] ", name)
    else:
        failed += 1
        print("  [ПРОВАЛ] ", name)

func free_scene(node: Node) -> void:
    if node != null and is_instance_valid(node):
        node.queue_free()
        await get_tree().process_frame
        await get_tree().process_frame

func load_dungeon(dungeon_id: String, floor_num: int) -> Node2D:
    Game.current_dungeon = dungeon_id
    Game.dungeon_floor = floor_num
    var dun: Node2D = (load("res://scenes/dungeon/dungeon.tscn") as PackedScene).instantiate()
    add_child(dun)
    await get_tree().process_frame
    await get_tree().process_frame
    return dun

func freeze_minions(dun: Node2D) -> void:
    for foe in dun._foes:
        if bool(foe.get("boss", false)) or bool(foe.get("dead", false)):
            continue
        foe["speed_override"] = 0.0
        foe["aggro"] = false

func _ready() -> void:
    print("STEP24 TEST: портал/ключи, диалог в босс-комнатах, сумка,",
        " лестницы, интерактив, щупальца, мутация, финал, Шуб-Ниггурат")
    Saves.wipe_all_slots()
    Game.meta["last_slot"] = 0
    Game.meta["last_bonus_date"] = ""
    Game.meta["pending_gold"] = 0
    Game.meta["pending_items"] = []
    Game.save_meta()
    Game.new_run(1, "warrior")

    # ================================================================ п.2
    # --- БАГ ДИАЛОГА В БОСС-КОМНАТАХ: панель не раздувается и не уезжает ---
    Game.demon_seen = true   # самые длинные реплики босса данжа 1
    var dun: Node2D = await load_dungeon("dungeon_1", 4)
    var boss: Dictionary = dun._boss_record()
    check("босс на 4-м этаже на месте", not boss.is_empty())
    dun.player.position = (boss["node"] as Node2D).position + Vector2(40, 20)
    dun._open_boss_dialog()
    await get_tree().process_frame
    await get_tree().process_frame
    await get_tree().process_frame
    var dlg: DialogueUI = dun._dialogue
    var panel: PanelContainer = dlg._panel
    var rect := panel.get_global_rect()
    check("диалог открылся", dlg.visible)
    check("панель диалога не выше PANEL_MAX_H (460)", panel.size.y <= 460.5)
    check("панель не уехала за нижний край (низ = 640-120)", \
        rect.end.y <= 640.0 - 120.0 + 0.5)
    check("offset_bottom канонический (-120)", \
        absf(panel.offset_bottom - (-120.0)) < 0.5)
    # листаем все реплики: геометрия честная на каждой
    var geo_ok := true
    for i in range(10):
        if not dlg.visible:
            break
        var r := panel.get_global_rect()
        if r.end.y > 640.0 - 120.0 + 0.5 or panel.size.y > 460.5:
            geo_ok = false
        if panel.offset_bottom != -120.0:
            geo_ok = false
        dlg._advance()
        await get_tree().process_frame
        await get_tree().process_frame
    check("геометрия диалога честная на всех репликах", geo_ok)
    check("диалог закрылся после последней реплики", not dlg.visible)
    check("после диалога босс в ярости", dun._boss_hostile)
    await free_scene(dun)

    # ============================================== п.1 (портал + ключ)
    # --- с босса падает КЛЮЧ следующего подземелья и открывается ПОРТАЛ ---
    dun = await load_dungeon("dungeon_1", 4)
    boss = dun._boss_record()
    var inv_before := Game.inventory.size()
    dun._hit_foe(boss, 99999)
    await get_tree().process_frame
    check("босс данжа 1 повержен", dun._boss_defeated_here)
    var has_key := false
    for item in Game.inventory:
        if String(item.get("item_id", "")) == "key_skit":
            has_key = true
    check("с демона упал КЛЮЧ Скита (в сумке)", has_key)
    check("ключ не продаётся (трофей)", ItemDB.sell_price("key_skit") == 0)
    check("эпическое оружие тоже упало", Game.inventory.size() >= inv_before + 2)
    var portal: Node = dun.get_tree().get_first_node_in_group("portal")
    check("ПОРТАЛ в замок появился", portal != null \
        and is_instance_valid(portal))
    check("у портала есть подпись и зона клика", \
        portal.get_child_count() >= 4)
    check("выход в замке стоит в сетке (X)", \
        not dun._stairs_exit.is_empty())
    await free_scene(dun)

    # ============================================== п.3 (бездонная сумка)
    # --- инвентарь бездонный и скроллится ---
    var inv_script: GDScript = load("res://scenes/world/inventory_ui.gd") as GDScript
    var inv_ui: CanvasLayer = inv_script.new()
    add_child(inv_ui)
    for i in range(30):
        Game.add_item({"item_id": "water", "title": "Вода", "quality": "gray"},
            false)
    inv_ui.open()
    await get_tree().process_frame
    await get_tree().process_frame
    check("сумка показывает ВСЕ 30 вещей (было 20 слотов)", \
        inv_ui._grid.get_child_count() >= 30)
    var vbar: VScrollBar = inv_ui._scroll.get_v_scroll_bar()
    check("список сумки реально скроллится", vbar.max_value > 0.0)
    inv_ui.close()
    # минимум 20 ячеек на пустой сумке — как раньше
    Game.inventory.clear()
    Game.inventory_changed.emit()
    inv_ui.open()
    await get_tree().process_frame
    check("пустая сумка — минимум 20 ячеек (старое поведение)", \
        inv_ui._grid.get_child_count() == 20)
    inv_ui.close()
    await free_scene(inv_ui)
    Game.gold = 500

    # ============================================== п.7 (щупальца из стен)
    # --- данж 3: неуязвимые щупальца из стен ---
    dun = await load_dungeon("dungeon_3", 1)
    var spawned := false
    for attempt in range(24):
        dun._spawn_wall_tentacle()
        if not dun._wall_tentacles.is_empty():
            spawned = true
            break
    check("щупальце вырвалось из стены (данж 3)", spawned)
    if spawned:
        var rec: Dictionary = dun._wall_tentacles[0]
        check("щупальце НЕ враг: не бьётся и не в списке foes", \
            dun._foe_at_point(rec["pos"]).is_empty())
        check("у щупальца есть круг-предупреждение", \
            rec.has("warn") and is_instance_valid(rec["warn"]))
        var hp_before: int = Game.hp
        dun.player.position = rec["pos"] + Vector2(0, 4)
        rec["born"] -= 1200   # форсируем удар
        for i in range(90):
            await get_tree().process_frame
            if bool(rec.get("slammed", false)):
                break
        check("щупальце нанесло удар из стены", bool(rec.get("slammed", false)) \
            and Game.hp == hp_before - 14)
        rec["born"] -= int(4.2 * 1000.0) + 1500   # форсируем отступление
        for i in range(120):
            await get_tree().process_frame
            if dun._wall_tentacles.is_empty():
                break
        check("щупальце ушло обратно в стену", dun._wall_tentacles.is_empty())
    await free_scene(dun)

    # ============================================== п.6 (интерактив)
    # --- реквизит этажа живой: бочки, кристаллы ---
    dun = await load_dungeon("dungeon_1", 1)
    check("на этаже есть интерактивный реквизит", dun._interactives.size() > 0)
    var barrel: Dictionary = {}
    var crystal: Dictionary = {}
    for rec2 in dun._interactives:
        var k := String(rec2["kind"])
        if k == "barrel" or k == "crate":
            if barrel.is_empty():
                barrel = rec2
        elif k == "crystal" or k == "crystal_violet":
            if crystal.is_empty():
                crystal = rec2
    check("кристалл в сокровищнице интерактивен", not crystal.is_empty())
    if not barrel.is_empty():
        check("реквизит «интерактивен» для кликов", \
            dun._point_on_interactive(barrel["pos"]))
        Game.gold = 100
        (barrel["sprite"] as Node2D).visible = true
        dun._use_interactive(barrel)
        await get_tree().process_frame
        check("бочка разбилась (использована)", bool(barrel.get("used", false)) \
            and not (barrel["sprite"] as Node2D).visible)
    if not crystal.is_empty():
        Game.hp = 10
        dun._use_interactive(crystal)
        await get_tree().process_frame
        check("кристалл поделился силой: воину +5 хп", Game.hp == 15)
        dun._use_interactive(crystal)
        check("кристалл одноразовый", Game.hp == 15)
    # ============================================== п.5 (лестницы)
    # --- лестницы крупнее и интереснее: свет/искры/подпись ---
    var stairs_up: Node = dun._level_root.get_node_or_null("Лестница наверх")
    check("у лестницы есть узел-маркер", stairs_up != null)
    if stairs_up != null:
        check("лестница нарядная: спрайт+свет+искры+подпись", \
            stairs_up.get_child_count() >= 4)
        var shape_node: CollisionShape2D = stairs_up.get_child(0).get_child(0)
        check("зона клика лестницы расширена (24x24)", \
            (shape_node.shape as RectangleShape2D).size.x >= 24.0)
    await free_scene(dun)

    # ============================================== п.10 (Шуб-Ниггурат)
    # --- данж 4: босс стреляет веером спор и зовёт полчища ---
    dun = await load_dungeon("dungeon_4", 4)
    boss = dun._boss_record()
    check("Шуб-Ниггурат ждёт на 4-м этаже", not boss.is_empty() \
        and String(boss["id"]) == "boss_shub")
    check("у Шуб-Ниггурат три глаза и дыхание", boss.has("eyes") \
        and (boss["eyes"] as Array).size() == 3)
    freeze_minions(dun)
    dun._open_boss_dialog()
    await get_tree().process_frame
    await get_tree().process_frame
    dun._dialogue.close()
    await get_tree().process_frame
    check("после диалога Шуб-Ниггурат дерётся", dun._boss_hostile)
    boss["aggro"] = true
    boss["speed_override"] = 0.0
    var base_foes: int = dun._foes.size()
    # веер спор: 7 снарядов
    boss["volley_cd"] = 0.0
    boss["whisper_cd"] = 999.0
    for i in range(8):
        await get_tree().process_frame
    check("Шуб-Ниггурат стреляет веером спор (7 снарядов)", \
        dun._foe_bolts.size() >= 7)
    # полчища на пороге 75%
    boss["hp"] = int(float(boss["max_hp"]) * 0.7)
    for i in range(12):
        await get_tree().process_frame
    var summoned: bool = dun._foes.size() >= base_foes + 2
    var kinds_ok := true
    for foe in dun._foes:
        var fid := String(foe["id"])
        if fid != "boss_shub" and DungeonBestiary.foe_def(fid).is_empty():
            kinds_ok = false
    check("на 75% ХП вышло полчище детенышей (шаг 24)", summoned)
    check("детеныши из бестиария данжа 4", kinds_ok)
    # фаза 2 «сад гаснет»
    boss["hp"] = int(float(boss["max_hp"]) * 0.35)
    for i in range(12):
        await get_tree().process_frame
    check("фаза 2: сад гаснет (воздух темнеет)", bool(boss.get("phase2", false)) \
        and dun._air.color.r < dun._air_base.r)
    check("в фазе 2 когти быстрее и Шуб быстрее", \
        float(boss.get("attack_cd_override", -1.0)) == 0.9 \
        and float(boss.get("speed_override", -1.0)) == 58.0)
    # победа: эпик, без ключа (финал), данж засчитан
    var keys_before := 0
    for item in Game.inventory:
        if String(item.get("item_id", "")).begins_with("key_"):
            keys_before += 1
    dun._hit_foe(boss, 999999)
    await get_tree().process_frame
    check("Шуб-Ниггурат повержена, данж 4 засчитан", \
        bool(boss.get("dead", false)) \
        and Game.dungeons_cleared.has("dungeon_4"))
    var keys_after := 0
    for item in Game.inventory:
        if String(item.get("item_id", "")).begins_with("key_"):
            keys_after += 1
    check("у финального босса ключа нет", keys_after == keys_before)
    await free_scene(dun)

    # ============================================== п.8 (мутация NPC)
    # --- данж 3 пройден: NPC мутанты, бредят, торгуют дороже ---
    Game.dungeons_cleared = ["dungeon_1", "dungeon_2", "dungeon_3"]
    var world: Node2D = (load("res://scenes/world/world.tscn") as PackedScene).instantiate()
    add_child(world)
    await get_tree().process_frame
    await get_tree().process_frame
    check("мутация активна", Game.mutation_active())
    var zlus: Dictionary = {}
    for npc in world._npcs:
        if String(npc["id"]) == "zlus":
            zlus = npc
    check("житель мутировал: больной цвет и ярлык", \
        not zlus.is_empty() \
        and (zlus["sprite"] as AnimatedSprite2D).modulate == world.MUTATION_TINT \
        and String((zlus["name_label"] as Label).text).contains("мутант"))
    world.npc_say("zlus")
    await get_tree().process_frame
    check("мутант бредит (язык, которого нет)", \
        String(world._dialogue._text_label.text).contains("рецеп"))
    world._dialogue.close()
    await get_tree().process_frame
    var water_base := ItemDB.price("water")
    var water_mutant := maxi(1, int(round(float(water_base) * 1.5)))
    check("цены мутантов +50% (%d -> %d)" % [water_base, water_mutant], \
        Game.npc_buy_price("water") == water_mutant \
        and water_mutant > water_base)
    Game.gold = water_mutant
    check("покупка у мутанта списывает цену мутанта", \
        Game.buy_item("water") and Game.gold == 0)
    # космос-юг: три пройденных данжа — жуть растёт
    check("космос на юге затемнился (шаг 24, п.1)", \
        world._cosmos_overlay.color.a > 0.2)
    var visible_eyes := 0
    for eye in world._cosmos_eyes:
        if (eye as Sprite2D).visible:
            visible_eyes += 1
    check("глаза смотрят из тьмы (4 из 6 на стадии 3)", visible_eyes == 4)
    check("текст края мира стал другим", \
        String(world.COSMOS_DREAD[3]["hint"]) != world.EDGE_HINT)
    await free_scene(world)

    # ============================================== п.9 (финал)
    # --- данж 4 пройден: все NPC мертвы, Лира — Королева ночи ---
    Game.dungeons_cleared = ["dungeon_1", "dungeon_2", "dungeon_3", "dungeon_4"]
    Game.queen_slain = false
    Game.queen_hostile = false
    world = (load("res://scenes/world/world.tscn") as PackedScene).instantiate()
    add_child(world)
    await get_tree().process_frame
    await get_tree().process_frame
    check("финал активен", Game.finale_active())
    var all_dead_but_queen := true
    var queen_rec: Dictionary = {}
    for npc in world._npcs:
        if String(npc["id"]) == world.QUEEN_ID:
            queen_rec = npc
        elif not bool(npc.get("dead", false)):
            all_dead_but_queen = false
    check("все NPC мертвы, кроме Лир", all_dead_but_queen \
        and not queen_rec.is_empty())
    check("Лира стала Королевой ночи (ярлык)", \
        String((queen_rec["name_label"] as Label).text).contains("Королева ночи"))
    check("у Королевы хп финального босса (шаг 25: усилена)", int(queen_rec["max_hp"]) == 850)
    # признание и бой (пролистываем до реплики про план)
    world.npc_say("lira")
    await get_tree().process_frame
    check("признание Королевы открылось", \
        String(world._dialogue._name_label.text) == "Лира" \
        and String(world._dialogue._role_label.text) == "Королева ночи")
    for i in range(3):
        world._dialogue._advance()
        await get_tree().process_frame
    check("признание: «это был её план»", \
        String(world._dialogue._text_label.text).contains("МОЯ сцена"))
    world._dialogue.close()
    await get_tree().process_frame
    check("после признания Королева в бою", Game.queen_hostile)
    # бой: удары по Королеве
    var qhp_before: int = int(queen_rec["hp"])
    world._hit_npc(queen_rec, 100)
    check("Королева получает урон и показывает полоску", \
        int(queen_rec["hp"]) == qhp_before - 100 \
        and (queen_rec["hp_bar"] as ProgressBar).visible)
    # гибель — концовка
    world._hit_npc(queen_rec, 999999)
    check("Королева повержена: queen_slain в сейве", Game.queen_slain \
        and bool(Game.to_save_data().get("queen_slain", false)))
    # твин концовки живёт на РЕАЛЬНОМ времени (не на кадрах headless)
    await get_tree().create_timer(2.2).timeout
    check("экран «КОНЕЦ ИГРЫ» показан", world._ending_layer.visible)
    check("ввод мира заглушен финалом", world._gameplay_input_blocked())
    await free_scene(world)

    # ============================================== п.4 (баланс)
    # --- плавная кривая хп внутри данжей и рост между ними ---
    var d1_min: int = 999
    var d1_max: int = 0
    for def in DungeonBestiary.FOES:
        d1_min = mini(d1_min, int(def["hp"]))
        d1_max = maxi(d1_max, int(def["hp"]))
    # Шаг 24: у слабейшего данжа 1 — 10 хп, у сильнейшего не больше 70
    # (плавная кривая вместо старых скалков 12 -> 75)
    check("данж 1: кривая хп плавная (10..70, шаг 24)", \
        d1_min == 10 and d1_max <= 70 and d1_max >= 50)
    check("данж 2 крепче данжа 1", \
        int(DungeonBestiary.foe_def("cultist_guardian")["hp"]) \
            > int(DungeonBestiary.foe_def("undead_knight")["hp"]))
    check("данж 3 крепче данжа 2", \
        int(DungeonBestiary.foe_def("shoggoth")["hp"]) \
            > int(DungeonBestiary.foe_def("cultist_guardian")["hp"]))
    check("данж 4 крепче данжа 3", \
        int(DungeonBestiary.foe_def("tentacle_abomination")["hp"]) \
            > int(DungeonBestiary.foe_def("shoggoth")["hp"]))
    check("Шуб-Ниггурат сильнее Ктулху", \
        int(DungeonBestiary.BOSS_4["hp"]) > int(DungeonBestiary.BOSS_3["hp"]))
    var elites_ok := true
    for def2 in DungeonBestiary.FOES_4:
        if int(def2["damage"]) < 12 or int(def2["hp"]) < 48:
            elites_ok = false
    check("Древние бьют больно (мин. 12 урона)", elites_ok)

    # --- итог ---
    if failed == 0:
        print("STEP24 TEST: ВСЁ ОК")
    else:
        print("STEP24 TEST: ПРОВАЛОВ: ", failed)
    get_tree().quit(failed)

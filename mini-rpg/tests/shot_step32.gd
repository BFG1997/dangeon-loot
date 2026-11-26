## Съёмка скриншотов шага 32: демоны между этажами, мечи воина,
## оборотень, фазовый рывок, F-атака черепом, луч мага.
## Запуск: godot --path . res://tests/shot_step32.tscn  (с DISPLAY)
extends Node

func snap(name: String, wait: float = 0.5) -> void:
    await get_tree().create_timer(wait).timeout
    var img := get_viewport().get_texture().get_image()
    img.save_png("user://" + name)
    print("SAVED ", name)

func _ready() -> void:
    Saves.wipe_all_slots()
    Game.meta["last_slot"] = 0
    Game.meta["last_bonus_date"] = ""
    Game.save_meta()
    var dungeon: Node2D = null

    # --- 1. Демоноолог: демоны перешли на новый этаж и дерутся ---
    Game.new_run(1, "demonologist")
    Game.dungeon_floor = 1
    dungeon = (load("res://scenes/dungeon/dungeon.tscn") as PackedScene).instantiate()
    add_child(dungeon)
    await get_tree().process_frame
    await get_tree().process_frame
    Game.restore_mana(500)
    dungeon._on_q_pressed()          # демон (Q)
    Combat.start_dash(dungeon)       # крылатый демон (пробел)
    await get_tree().process_frame
    dungeon._goto_floor(2)
    await get_tree().process_frame
    await get_tree().process_frame
    # подвести врага к демонам — видно бой
    for i in range(90):
        await get_tree().physics_frame
    await snap("s32_demons_floor2.png", 0.4)
    dungeon.free()
    await get_tree().process_frame

    # --- 2. Воин: танцующие мечи ---
    Game.new_run(2, "warrior")
    Game.level = 4
    Game.dungeon_floor = 1
    dungeon = (load("res://scenes/dungeon/dungeon.tscn") as PackedScene).instantiate()
    add_child(dungeon)
    await get_tree().process_frame
    await get_tree().process_frame
    Game.level = 4
    dungeon._on_q_pressed()          # мечи крутятся (3+3=6 на 4-м уровне)
    for i in range(30):
        await get_tree().physics_frame
    await snap("s32_warrior_swords.png", 0.3)
    dungeon.free()
    await get_tree().process_frame

    # --- 3. Бомж-оборотень ---
    Game.new_run(3, "bum")
    Game.dungeon_floor = 1
    dungeon = (load("res://scenes/dungeon/dungeon.tscn") as PackedScene).instantiate()
    add_child(dungeon)
    await get_tree().process_frame
    await get_tree().process_frame
    dungeon._on_t_pressed()          # превращение в оборотня
    for i in range(20):
        await get_tree().physics_frame
    await snap("s32_werewolf.png", 0.4)
    # кадр с воем (кольцо оглушения)
    dungeon._special_cd = 0.0
    dungeon._do_howl(Game.ability_info("special"))
    await snap("s32_werewolf_howl.png", 0.25)
    dungeon.free()
    await get_tree().process_frame

    # --- 4. Некромант: фазовый рывок сквозь стену ---
    Game.new_run(1, "necromancer")
    Game.dungeon_floor = 1
    dungeon = (load("res://scenes/dungeon/dungeon.tscn") as PackedScene).instantiate()
    add_child(dungeon)
    await get_tree().process_frame
    await get_tree().process_frame
    var wall_pos := Vector2.INF
    for ty in range(5, 40):
        for tx in range(5, 40):
            if dungeon._tile_is_solid(Vector2(tx * 16 + 8, ty * 16 + 8)) \
                    and not dungeon._tile_is_solid(Vector2((tx + 1) * 16 + 8, ty * 16 + 8)) \
                    and not dungeon._tile_is_solid(Vector2((tx - 1) * 16 + 8, ty * 16 + 8)):
                wall_pos = Vector2((tx + 1) * 16 + 10, ty * 16 + 8)
                break
        if wall_pos.is_finite():
            break
    if wall_pos.is_finite():
        dungeon.player.position = wall_pos
        dungeon._facing = "side"
        dungeon._player_sprite.flip_h = false
        dungeon._dash_cd = 0.0
        Combat.start_dash(dungeon, Vector2.LEFT)   # сквозь стену
        await snap("s32_phase_dash.png", 0.12)
    dungeon.free()
    await get_tree().process_frame

    # --- 5. Череп шептунов: зелёная смерть по врагам ---
    Game.new_run(2, "demonologist")
    Game.dungeon_floor = 1
    dungeon = (load("res://scenes/dungeon/dungeon.tscn") as PackedScene).instantiate()
    add_child(dungeon)
    await get_tree().process_frame
    await get_tree().process_frame
    Game.add_item({"item_id": "skull_whispers", "title": "Череп шептунов",
        "quality": "gray"})
    Game.equip_weapon("skull_whispers")
    var victim: Dictionary = {}
    for foe in dungeon._foes:
        if not bool(foe.get("dead", false)) and not bool(foe.get("boss", false)):
            victim = foe
            break
    dungeon._facing = "side"
    dungeon._player_sprite.flip_h = false
    if not victim.is_empty():
        for foe in dungeon._foes:
            if foe != victim:
                (foe["node"] as Node2D).position = dungeon.player.position \
                    + Vector2(500, 500)
        (victim["node"] as Node2D).position = dungeon.player.position + Vector2(70, 0)
        Game.restore_mana(300)
        dungeon._strike_cd = 0.0
        dungeon._strike()   # зелёный снаряд летит
        await snap("s32_skull_bolt.png", 0.16)
    dungeon.free()
    await get_tree().process_frame

    # --- 6. Маг: луч посоха углей ---
    Game.new_run(2, "mage")
    Game.dungeon_floor = 1
    dungeon = (load("res://scenes/dungeon/dungeon.tscn") as PackedScene).instantiate()
    add_child(dungeon)
    await get_tree().process_frame
    await get_tree().process_frame
    Game.add_item({"item_id": "staff_embers", "title": "Посох углей",
        "quality": "gray"})
    Game.equip_weapon("staff_embers")
    var m_victim: Dictionary = {}
    for foe in dungeon._foes:
        if not bool(foe.get("dead", false)) and not bool(foe.get("boss", false)):
            m_victim = foe
            break
    dungeon._facing = "side"
    dungeon._player_sprite.flip_h = false
    if not m_victim.is_empty():
        for foe in dungeon._foes:
            if foe != m_victim:
                (foe["node"] as Node2D).position = dungeon.player.position \
                    + Vector2(500, 500)
        (m_victim["node"] as Node2D).position = dungeon.player.position + Vector2(60, 0)
        Game.restore_mana(300)
        dungeon._strike_cd = 0.0
        dungeon._strike()   # мгновенный луч
        await snap("s32_mage_beam.png", 0.05)
    dungeon.free()
    await get_tree().process_frame

    print("SHOTS DONE")
    get_tree().quit(0)

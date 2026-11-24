## Съёмка скриншотов шага 24: диалог в босс-комнате (фикс геометрии),
## портал и ключ босса, щупальце из стены, Шуб-Ниггурат, мутанты и космос,
## финал с Королевой ночи, бездонная сумка.
## Запуск: xvfb-run godot --path . --rendering-driver opengl3 res://tests/shot_step24.tscn
extends Node

const OUT := "/home/z/my-project/download/shots_step24"

func snap(path: String) -> void:
    await RenderingServer.frame_post_draw
    var img := get_viewport().get_texture().get_image()
    img.save_png(path)
    print("SHOT ", path)

func load_dungeon(dungeon_id: String, floor_num: int) -> Node2D:
    Game.current_dungeon = dungeon_id
    Game.dungeon_floor = floor_num
    var dun: Node2D = (load("res://scenes/dungeon/dungeon.tscn") as PackedScene).instantiate()
    add_child(dun)
    await get_tree().create_timer(0.8).timeout
    return dun

func drop_dungeon(dun: Node2D) -> void:
    dun.queue_free()
    await get_tree().process_frame
    await get_tree().process_frame

func _ready() -> void:
    DirAccess.make_dir_recursive_absolute(OUT)
    Saves.wipe_all_slots()
    Game.new_run(3, "warrior")
    Game.gold = 777

    # --- 1) диалог босса в босс-комнате (проверка фикса геометрии) ---
    Game.demon_seen = true
    var dun: Node2D = await load_dungeon("dungeon_1", 4)
    var boss: Dictionary = dun._boss_record()
    dun.player.position = (boss["node"] as Node2D).position + Vector2(60, 40)
    dun._camera.reset_smoothing()
    await get_tree().create_timer(0.4).timeout
    dun._open_boss_dialog()
    await get_tree().create_timer(0.6).timeout
    await snap(OUT + "/1_boss_dialog_fixed.png")
    await drop_dungeon(dun)

    # --- 2) портал в замок на месте убитого босса ---
    dun = await load_dungeon("dungeon_1", 4)
    boss = dun._boss_record()
    dun._hit_foe(boss, 99999)
    await get_tree().create_timer(0.9).timeout
    await snap(OUT + "/2_portal_and_key.png")
    await drop_dungeon(dun)

    # --- 3) щупальце из стены (данж 3) ---
    dun = await load_dungeon("dungeon_3", 2)
    for i in range(30):
        dun._spawn_wall_tentacle()
        if not dun._wall_tentacles.is_empty():
            break
    if not dun._wall_tentacles.is_empty():
        var rec: Dictionary = dun._wall_tentacles[0]
        dun.player.position = rec["pos"] + Vector2(30, 26)
        dun._camera.reset_smoothing()
        await get_tree().create_timer(0.5).timeout
    await snap(OUT + "/3_wall_tentacle.png")
    await drop_dungeon(dun)

    # --- 4) Шуб-Ниггурат в чёрном алтаре ---
    dun = await load_dungeon("dungeon_4", 4)
    boss = dun._boss_record()
    dun.player.position = (boss["node"] as Node2D).position + Vector2(90, 70)
    dun._camera.reset_smoothing()
    await get_tree().create_timer(0.5).timeout
    await snap(OUT + "/4_shub_niggurath.png")
    await drop_dungeon(dun)

    # --- 5) мир: мутанты и жуткий космос на юге ---
    Game.dungeons_cleared = ["dungeon_1", "dungeon_2", "dungeon_3"]
    var world: Node2D = (load("res://scenes/world/world.tscn") as PackedScene).instantiate()
    add_child(world)
    await get_tree().create_timer(0.7).timeout
    world.player.position = Vector2(14 * 16.0, 47 * 16.0)
    world._camera.reset_smoothing()
    await get_tree().create_timer(0.4).timeout
    await snap(OUT + "/5_mutation_and_cosmos.png")
    await drop_dungeon(world)

    # --- 6) финал: Королева ночи среди трупов ---
    Game.dungeons_cleared = ["dungeon_1", "dungeon_2", "dungeon_3", "dungeon_4"]
    world = (load("res://scenes/world/world.tscn") as PackedScene).instantiate()
    add_child(world)
    await get_tree().create_timer(0.7).timeout
    var queen: Dictionary = world._queen_record()
    if not queen.is_empty():
        world.player.position = (queen["node"] as Node2D).position + Vector2(-50, 30)
        world._camera.reset_smoothing()
        await get_tree().create_timer(0.4).timeout
    await snap(OUT + "/6_queen_of_night.png")
    await drop_dungeon(world)

    # --- 7) бездонная сумка (30 вещей, скролл) ---
    for i in range(30):
        Game.add_item({"item_id": "water", "title": "Вода", "quality": "gray"},
            false)
    var inv_script: GDScript = load("res://scenes/world/inventory_ui.gd") as GDScript
    var inv_ui: CanvasLayer = inv_script.new()
    add_child(inv_ui)
    inv_ui.open()
    await get_tree().create_timer(0.5).timeout
    await snap(OUT + "/7_bottomless_inventory.png")
    inv_ui.queue_free()
    get_tree().quit(0)

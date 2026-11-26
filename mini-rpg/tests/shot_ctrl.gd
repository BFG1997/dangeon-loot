## Съёмка шага 29: меню с каскадом, HUD со слотом CTRL, мини-слоты
## экипировки, индикатор хмеля (зелёный мир), пинок варвара в данже.
## Запуск: godot --path . --rendering-driver opengl3 res://tests/shot_ctrl.tscn
extends Node

func snap(path: String) -> void:
    await RenderingServer.frame_post_draw
    var img := get_viewport().get_texture().get_image()
    img.save_png(path)
    print("SHOT ", path)

func _ready() -> void:
    # --- меню: один тап — каскад кнопок ---
    var menu: Control = (load("res://scenes/main/main.tscn") as PackedScene).instantiate()
    add_child(menu)
    await get_tree().create_timer(0.6).timeout
    var tap := InputEventMouseButton.new()
    tap.button_index = MOUSE_BUTTON_LEFT
    tap.pressed = true
    menu._on_chest_gui_input(tap)
    await get_tree().create_timer(0.24).timeout
    await snap("/tmp/shot_menu_cascade.png")
    await get_tree().create_timer(0.8).timeout
    await snap("/tmp/shot_menu_open.png")
    menu.free()
    await get_tree().process_frame

    # --- мир, воин: 4 слота, экипировка (меч + броня), CTRL-слот рывка ---
    Game.new_run(1, "warrior")
    Game.add_item({"item_id": "sword", "title": ItemDB.title("sword"), "quality": "gray"})
    Game.try_equip_weapon("sword")
    Game.add_item({"item_id": "armor_leather", "title": ItemDB.title("armor_leather"), "quality": "gray"})
    Game.equip_armor("armor_leather")
    var world: Node2D = (load("res://scenes/world/world.tscn") as PackedScene).instantiate()
    add_child(world)
    await get_tree().create_timer(0.8).timeout
    await snap("/tmp/shot_world_warrior.png")

    # --- мир, бомж: хмельной запал — зелёный мир и индикатор ---
    world.free()
    await get_tree().process_frame
    Game.new_run(1, "bum")
    var world_bum: Node2D = (load("res://scenes/world/world.tscn") as PackedScene).instantiate()
    add_child(world_bum)
    await get_tree().create_timer(0.8).timeout
    Combat.start_dash(world_bum)
    await get_tree().create_timer(0.7).timeout
    await snap("/tmp/shot_world_bum_drink.png")
    world_bum.free()
    await get_tree().process_frame

    # --- данж, варвар: CTRL-слот пинка ---
    Game.new_run(1, "barbarian")
    Game.dungeon_floor = 1
    var dungeon: Node2D = (load("res://scenes/dungeon/dungeon.tscn") as PackedScene).instantiate()
    add_child(dungeon)
    await get_tree().create_timer(1.0).timeout
    await snap("/tmp/shot_dungeon_barbarian.png")

    # --- данж, маг: CTRL-слот телепорта, шаг кулдауна ---
    dungeon.free()
    await get_tree().process_frame
    Game.new_run(1, "mage")
    Game.dungeon_floor = 1
    var dungeon_mage: Node2D = (load("res://scenes/dungeon/dungeon.tscn") as PackedScene).instantiate()
    add_child(dungeon_mage)
    await get_tree().create_timer(1.0).timeout
    dungeon_mage._facing = "up"
    Combat.start_dash(dungeon_mage)
    await get_tree().create_timer(0.15).timeout
    await snap("/tmp/shot_dungeon_mage_blink.png")

    get_tree().quit(0)

## Съёмка HUD мира и данжа для проверки раскладки на ПК (1920x1080).
## Запуск: xvfb-run godot --path . --rendering-driver opengl3 res://tests/shot_hud.tscn
extends Node

func snap(path: String) -> void:
    await RenderingServer.frame_post_draw
    var img := get_viewport().get_texture().get_image()
    img.save_png(path)
    print("SHOT ", path)

func _ready() -> void:
    Game.new_run(1, "barbarian")
    var world: Node2D = (load("res://scenes/world/world.tscn") as PackedScene).instantiate()
    add_child(world)
    await get_tree().create_timer(0.8).timeout
    await snap("/tmp/hud_world_barbarian.png")

    # маг: полоса маны в HUD
    world.queue_free()
    await get_tree().process_frame
    Game.new_run(1, "mage")
    var world_mage: Node2D = (load("res://scenes/world/world.tscn") as PackedScene).instantiate()
    add_child(world_mage)
    await get_tree().create_timer(0.8).timeout
    await snap("/tmp/hud_world_mage.png")

    # данж: HUD с строкой этажа
    world_mage.queue_free()
    await get_tree().process_frame
    Game.new_run(1, "barbarian")
    var dungeon: Node2D = (load("res://scenes/dungeon/dungeon.tscn") as PackedScene).instantiate()
    add_child(dungeon)
    await get_tree().create_timer(1.0).timeout
    await snap("/tmp/hud_dungeon.png")

    get_tree().quit(0)

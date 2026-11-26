## Съёмка расширенного хаба (2026-11-26): остров по центру, космос
## снизу и по бокам. Запуск: xvfb + godot --path . res://tests/shot_hub.tscn
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
    await snap("/tmp/hub_spawn.png")
    # вид к югу: двор, ограда, космос снизу и по бокам
    world.player.position = Vector2(29 * 16.0, 40 * 16.0)
    await get_tree().create_timer(1.2).timeout
    await snap("/tmp/hub_south.png")
    get_tree().quit(0)

## Съёмка боёвки шага 27: телеграф врага, крит-метка, дуга комбо.
## Запуск: DISPLAY=:N godot --path . --rendering-driver opengl3 res://tests/shot_combat.tscn
extends Node

func snap(path: String) -> void:
    await RenderingServer.frame_post_draw
    var img := get_viewport().get_texture().get_image()
    img.save_png(path)
    print("SHOT ", path)

func _ready() -> void:
    Game.new_run(1, "warrior")
    Game.dungeon_floor = 1
    var dungeon: Node2D = (load("res://scenes/dungeon/dungeon.tscn") as PackedScene).instantiate()
    add_child(dungeon)
    await get_tree().create_timer(0.6).timeout
    var foe: Dictionary = {}
    for foe_scan in dungeon._foes:
        if not bool(foe_scan.get("dead", false)) and not bool(foe_scan.get("boss", false)):
            foe = foe_scan
            break
    for other in dungeon._foes:
        if other != foe and not bool(other.get("dead", false)):
            other["speed_override"] = 0.0
            (other["node"] as Node2D).position = Vector2(200, 900)
    dungeon.player.position = (foe["node"] as Node2D).position + Vector2(0, -14)
    foe["atk_cd"] = 0.0
    foe["tell_until"] = 0
    # замах врага в середине приседания
    await get_tree().create_timer(0.18).timeout
    # крит и обычные цифры урона над героем для наглядности
    StrikeFx.damage_label(dungeon, dungeon._fx,
        dungeon.player.position + Vector2(24, -56), 25, false, true)
    StrikeFx.damage_label(dungeon, dungeon._fx,
        dungeon.player.position + Vector2(-30, -48), 12)
    await get_tree().create_timer(0.12).timeout
    await snap("/tmp/shot_combat_telegraph.png")
    get_tree().quit(0)

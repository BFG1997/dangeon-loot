## Проверяет смену разрешения и ориентации в меню, мире и подземелье.
## godot --headless --path . res://tests/responsive_test.tscn
extends Node

var failed := 0

func check(label: String, condition: bool) -> void:
    if condition:
        print("[OK] ", label)
    else:
        failed += 1
        push_error(label)

func _ready() -> void:
    Game.new_run(1, "mage")
    var window := get_window()
    var original_size := window.size
    for scene_path in ["main/main", "character_select/character_select", "world/world", "dungeon/dungeon"]:
        var scene: Node = load("res://scenes/%s.tscn" % scene_path).instantiate()
        add_child(scene)
        if scene_path == "main/main":
            for i in 4:
                scene._reveal_next_item()
            await get_tree().create_timer(0.6).timeout
        for resolution in [Vector2i(720, 1280), Vector2i(1080, 2400), Vector2i(1536, 2048), Vector2i(1920, 1080), Vector2i(1280, 720)]:
            window.size = resolution
            for i in 3:
                await get_tree().process_frame
            var view_size := get_viewport().get_visible_rect().size
            var screen := Rect2(Vector2.ZERO, view_size)
            var label := "%s %s" % [scene_path, resolution]
            check(label + " aspect", absf(view_size.x / view_size.y - float(resolution.x) / resolution.y) < 0.002)
            if scene_path == "world/world" or scene_path == "dungeon/dungeon":
                check(label + " world fills screen", scene._walk_holder.size.is_equal_approx(view_size - Vector2(0, scene.UI_BAR_H)))
                check(label + " HUD at bottom", is_equal_approx(scene._hud_bar.get_global_rect().end.y, view_size.y))
                for control in scene._hud_bar.get_children():
                    if control is Control and (control.has_meta("action_button") or control is PanelContainer):
                        check(label + " HUD control fits", screen.encloses(control.get_global_rect()))
            elif scene_path == "main/main":
                for button in scene.buttons_layer.get_children():
                    check(label + " menu button fits", screen.encloses(button.get_global_rect()))
                check(label + " chest centered", is_equal_approx(scene.chest.get_global_rect().get_center().x, view_size.x / 2.0))
            else:
                check(label + " hero cards fit", screen.encloses(scene.cards_box.get_global_rect()))
                check(label + " play button fits", screen.encloses(scene.play_button.get_global_rect()))
        scene.free()
        await get_tree().process_frame
    window.size = original_size
    print("RESPONSIVE TEST: failures=", failed)
    get_tree().quit(1 if failed else 0)

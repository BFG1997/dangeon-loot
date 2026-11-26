## Съёмка шага 30: HUD с ИНВЕНТАРЬ и блоком «СПОСОБНОСТИ», иконки
## оружия/брони, слоты ПРОБЕЛ/CTRL, пауза на Escape и её настройки.
## Запуск (нужен Xvfb): godot --path . --rendering-driver opengl3 res://tests/shot_step30.tscn
extends Node

func snap(path: String) -> void:
    await RenderingServer.frame_post_draw
    var img := get_viewport().get_texture().get_image()
    img.save_png(path)
    print("SHOT ", path)

func _ready() -> void:
    # 1) воин с оружием и бронёй: иконки экипировки, СПОСОБНОСТИ, ИНВЕНТАРЬ
    Game.new_run(1, "warrior")
    Game.add_item({"item_id": "sword", "title": "Меч", "quality": "gray"})
    Game.equip_weapon("sword")
    Game.add_item({"item_id": "armor_leather", "title": "Кожаный доспех", "quality": "green"})
    Game.equip_armor("armor_leather")
    var world: Node2D = (load("res://scenes/world/world.tscn") as PackedScene).instantiate()
    add_child(world)
    await get_tree().create_timer(0.9).timeout
    await snap("/tmp/step30_world_warrior.png")

    # 2) пауза на Escape: главный список
    world._pause_menu.open()
    await get_tree().create_timer(0.4).timeout
    await snap("/tmp/step30_pause.png")

    # 3) настройки из паузы
    world._pause_menu._show_settings()
    await get_tree().create_timer(0.3).timeout
    await snap("/tmp/step30_pause_settings.png")
    world._pause_menu.close()
    world.queue_free()
    await get_tree().process_frame

    # 4) варвар в мире: слот ПРОБЕЛ = ПИНОК, CTRL = ПРЫЖОК
    Game.new_run(1, "barbarian")
    var world2: Node2D = (load("res://scenes/world/world.tscn") as PackedScene).instantiate()
    add_child(world2)
    await get_tree().create_timer(0.9).timeout
    await snap("/tmp/step30_world_barbarian.png")
    world2.queue_free()
    await get_tree().process_frame

    # 5) данж: HUD с ИНВЕНТАРЬ и СПОСОБНОСТИ
    Game.new_run(1, "warrior")
    Game.add_item({"item_id": "armor_chain", "title": "Кольчуга", "quality": "green"})
    Game.equip_armor("armor_chain")
    var dungeon: Node2D = (load("res://scenes/dungeon/dungeon.tscn") as PackedScene).instantiate()
    add_child(dungeon)
    await get_tree().create_timer(1.0).timeout
    await snap("/tmp/step30_dungeon.png")

    get_tree().quit(0)

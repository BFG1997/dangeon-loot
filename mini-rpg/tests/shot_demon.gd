## Съёмка скриншотов демона (шаг 8) для визуальной проверки.
## Запуск: xvfb-run godot --path . res://tests/shot_demon.tscn
extends Node

func _ready() -> void:
    Saves.wipe_all_slots()
    Game.meta["last_slot"] = 0
    Game.save_meta()
    Game.new_run(1, "warrior")
    var world: Node2D = (load("res://scenes/world/world.tscn") as PackedScene).instantiate()
    add_child(world)
    await get_tree().process_frame
    await get_tree().process_frame
    # убиваем Глота, чтобы призвать демона
    var glot := {}
    for npc in world._npcs:
        if String(npc["id"]) == "glot":
            glot = npc
    world.player.position = (glot["node"] as Node2D).position + Vector2(-18, 0)
    world._facing = "side"
    world._player_sprite.flip_h = false
    Game.add_item({"item_id": "morgenstern", "title": "Моргенштерн", "quality": "gray"})
    Game.equip_weapon("morgenstern")
    world._strike_cd = 0.0
    world._strike()
    await get_tree().process_frame
    await get_tree().process_frame
    var demon := {}
    for npc in world._npcs:
        if String(npc["id"]) == "demon":
            demon = npc
    if demon.is_empty():
        print("NO DEMON SPAWNED")
        get_tree().quit(1)
        return
    print("DEMON AT: ", (demon["node"] as Node2D).position)
    # кадр 1: демон у края улицы
    world.player.position = (demon["node"] as Node2D).position + Vector2(-34, 14)
    world._facing = "side"
    world._player_sprite.flip_h = false
    await get_tree().create_timer(1.6).timeout
    var img := get_viewport().get_texture().get_image()
    img.save_png("user://demon_shot.png")
    print("SAVED world shot")
    # кадр 2: диалог демона с портретом и кнопкой ТОРГОВАТЬ
    world.npc_say("demon")
    await get_tree().create_timer(1.4).timeout
    img = get_viewport().get_texture().get_image()
    img.save_png("user://demon_dialog.png")
    print("SAVED dialog shot")
    # кадр 3: лавка демона со скидочными ценами
    world._dialogue._trade_button.pressed.emit()
    await get_tree().create_timer(0.8).timeout
    img = get_viewport().get_texture().get_image()
    img.save_png("user://demon_shop.png")
    print("SAVED shop shot")
    get_tree().quit(0)

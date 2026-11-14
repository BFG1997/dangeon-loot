## Съёмка скриншотов мира (шаг 6): тронная, диалог, двор, инвентарь,
## лавки торговцев (покупка/продажа), Глот, Зоран, маг в HUD, край мира.
## Запуск: xvfb-run godot --path . --rendering-driver opengl3 res://tests/screenshot.tscn
extends Node

func snap(path: String) -> void:
    await RenderingServer.frame_post_draw
    var img := get_viewport().get_texture().get_image()
    img.save_png(path)
    print("SHOT ", path)

func _ready() -> void:
    # чистый прогон для съёмки: новая игра в слоте 1
    Game.new_run(1, "barbarian")
    Platform.calls.clear()
    var world: Node2D = (load("res://scenes/world/world.tscn") as PackedScene).instantiate()
    add_child(world)
    await get_tree().create_timer(0.8).timeout

    # тронная зала с Лирой
    world.player.position = Vector2(14.5 * 16.0, 18.2 * 16.0)
    await get_tree().create_timer(1.4).timeout
    await snap("/tmp/shot_throne.png")

    # диалог с Лирой
    world.npc_say("lira")
    await get_tree().create_timer(1.2).timeout
    await snap("/tmp/shot_dialogue.png")
    world._dialogue._close()

    # двор: фонтан и палатка
    world.player.position = Vector2(15.0 * 16.0, 28.0 * 16.0)
    await get_tree().create_timer(1.4).timeout
    await snap("/tmp/shot_yard.png")

    # рынок Гуры
    world.player.position = Vector2(8.0 * 16.0, 32.0 * 16.0)
    await get_tree().create_timer(1.4).timeout
    await snap("/tmp/shot_market.png")

    # инвентарь с предметами
    Game.add_item({"item_id": "star_blade", "title": "Звёздный клинок", "quality": "violet"})
    Game.add_item({"item_id": "comet_elixir", "title": "Эликсир кометы", "quality": "violet"})
    world._inventory_ui.open()
    await get_tree().create_timer(0.6).timeout
    await snap("/tmp/shot_inventory.png")
    world._inventory_ui.close()

    # --- торговля (шаг 5) ---
    # диалог Гуры с кнопкой ТОРГОВАТЬ
    world.npc_say("gura")
    await get_tree().create_timer(1.2).timeout
    await snap("/tmp/shot_trade_dialogue.png")
    world._dialogue.close()

    # лавка Гуры: покупка еды
    world._trade_ui.open({"name": "Гура", "role": "Повар", "goods": ["ham"]})
    await get_tree().create_timer(0.6).timeout
    await snap("/tmp/shot_trade_gura.png")

    # шаг 6: лавка Глота — растущий ряд напитков
    world.npc_say("glot")
    await get_tree().create_timer(1.0).timeout
    world._trade_ui.open({"name": "Глот", "role": "Трактирщик",
                          "goods": ["water", "mors", "juice", "beer"]})
    await get_tree().create_timer(0.6).timeout
    await snap("/tmp/shot_trade_glot.png")

    # шаг 6: лавка Зорана — магическое оружие
    world._trade_ui.open({"name": "Зоран", "role": "Оружейный чародей",
                          "goods": ["wand_lightning", "blade_frost", "scepter_comet"]})
    await get_tree().create_timer(0.6).timeout
    await snap("/tmp/shot_trade_zoran.png")

    # лавка Вираса: дорогое оружие варвару не по карману (кнопки неактивны)
    world._trade_ui.open({"name": "Вирас", "role": "Кузнец",
                          "goods": ["sword", "greatsword", "morgenstern"]})
    await get_tree().create_timer(0.6).timeout
    await snap("/tmp/shot_trade_viras.png")

    # вкладка ПРОДАЖА: выкуп вещей за половину цены
    world._trade_ui._tab_sell.pressed.emit()
    await get_tree().create_timer(0.4).timeout
    await snap("/tmp/shot_trade_sell.png")
    world._trade_ui.close()

    # край мира с планетой
    world.player.position = Vector2(15.0 * 16.0, 44.0 * 16.0)
    await get_tree().create_timer(1.4).timeout
    await snap("/tmp/shot_edge.png")

    # шаг 6: мир под магом — полосы хп и маны, кнопка МАГИЯ, снаряд
    world.queue_free()
    await get_tree().process_frame
    Game.new_run(1, "mage")
    var world_mage: Node2D = (load("res://scenes/world/world.tscn") as PackedScene).instantiate()
    add_child(world_mage)
    await get_tree().create_timer(0.8).timeout
    world_mage.player.position = Vector2(14.0 * 16.0, 13.0 * 16.0)
    world_mage._cast_spell()
    await get_tree().create_timer(0.25).timeout
    await snap("/tmp/shot_mage_cast.png")
    await get_tree().create_timer(1.0).timeout

    # экран выбора героя (мир выгружаем, как при смене сцены)
    world_mage.queue_free()
    await get_tree().process_frame
    var select: Control = (load("res://scenes/character_select/character_select.tscn") as PackedScene).instantiate()
    add_child(select)
    select.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    await get_tree().create_timer(0.5).timeout
    await snap("/tmp/shot_select.png")

    get_tree().quit(0)

## Съёмка шага 31 для проверки визуала (1920x1080): экран выбора шести
## героев, мир Демоноолога с призывами (демон + крылатый + суккуб) и
## данж Некроманта с армией мертвецов и безумием мобов.
## Запуск: DISPLAY=:99 godot --path . --rendering-driver opengl3 res://tests/shot_step31.tscn
extends Node

func snap(path: String) -> void:
    await RenderingServer.frame_post_draw
    var img := get_viewport().get_texture().get_image()
    img.save_png(path)
    print("SHOT ", path)

func _ready() -> void:
    Saves.wipe_all_slots()

    # 1) экран выбора героя: шесть карточек в ряд
    var select: Control = (load("res://scenes/character_select/character_select.tscn") as PackedScene).instantiate()
    add_child(select)
    await get_tree().create_timer(0.6).timeout
    await snap("/tmp/step31_select.png")
    select.queue_free()
    await get_tree().process_frame

    # 2) мир Демоноолога: три призыва рядом с героем
    Game.new_run(1, "demonologist")
    Game.restore_mana(Game.max_mana())
    var world: Node2D = (load("res://scenes/world/world.tscn") as PackedScene).instantiate()
    add_child(world)
    await get_tree().create_timer(0.5).timeout
    # призываем через тумблер (мана и кулдауны — как в живой игре)
    Game.restore_mana(500)
    world._on_q_pressed()          # демон (Q)
    Minions.toggle_summon(world, Game.ability_info("dash"))    # крылатый
    Minions.toggle_summon(world, Game.ability_info("special")) # суккуб
    await get_tree().create_timer(0.5).timeout
    await snap("/tmp/step31_world_demonologist.png")
    world.queue_free()
    await get_tree().process_frame

    # 3) данж Некроманта: армия из трёх мертвецов + безумие
    Game.new_run(2, "necromancer")
    Game.restore_mana(500)
    var dungeon: Node2D = (load("res://scenes/dungeon/dungeon.tscn") as PackedScene).instantiate()
    add_child(dungeon)
    await get_tree().create_timer(0.7).timeout
    # поднимаем трёх врагов рядом с героем (ур.3 — лимит 6)
    Game.level = 3
    var raised := 0
    for foe in dungeon._foes.duplicate():
        if raised >= 3:
            break
        if bool(foe.get("dead", false)) or bool(foe.get("boss", false)):
            continue
        var def: Dictionary = foe["def"]
        var pos: Vector2 = (foe["node"] as Node2D).position
        dungeon._foes.erase(foe)
        (foe["node"] as Node2D).queue_free()
        var ally := Minions.raise_undead(dungeon, def, dungeon.player.position \
            + Vector2(-30 + raised * 24, -6))
        raised += 1
    # безумие двух ближайших врагов — красные, бьют друг друга
    Game.restore_mana(500)
    dungeon._on_t_pressed()
    await get_tree().create_timer(0.4).timeout
    await snap("/tmp/step31_dungeon_necromancer.png")

    get_tree().quit(0)

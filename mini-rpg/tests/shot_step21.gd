## Съёмка скриншотов шага 21: Ктулху на троне Р'льеха, рёв пробуждения,
## фаза 2 «небо гаснет», круг-предупреждение щупалец, СУМКА в кнопках HUD.
## Запуск: xvfb-run godot --path . --rendering-driver opengl3 res://tests/shot_step21.tscn
extends Node

func snap(path: String) -> void:
    await RenderingServer.frame_post_draw
    var img := get_viewport().get_texture().get_image()
    img.save_png(path)
    print("SHOT ", path)

func _ready() -> void:
    Game.new_run(3, "warrior")
    Game.current_dungeon = "dungeon_3"
    Game.dungeon_floor = 4
    Game.hero_immune = true
    var dun: Node2D = (load("res://scenes/dungeon/dungeon.tscn") as PackedScene).instantiate()
    add_child(dun)
    await get_tree().create_timer(1.0).timeout
    var boss: Dictionary = dun._boss_record()
    if boss.is_empty():
        print("NO BOSS — EXIT")
        get_tree().quit(1)
        return
    var bnode: Node2D = boss["node"]

    # 1) Ктулху на троне (спит) + HUD с четырьмя кнопками
    (dun.player as Node2D).position = bnode.position + Vector2(70, 60)
    if dun._camera != null:
        dun._camera.reset_smoothing()
    await get_tree().create_timer(1.3).timeout
    await snap("/tmp/shot21_cthulhu_idle.png")

    # 2) пробуждение: диалог закрыт — рёв, глаза, аура
    dun._open_boss_dialog()
    await get_tree().create_timer(0.5).timeout
    dun._dialogue._close()
    boss["aggro"] = true
    boss["speed_override"] = 0.0
    boss["volley_cd"] = 999.0
    boss["whisper_cd"] = 999.0
    boss["slam_cd"] = 999.0
    await get_tree().create_timer(1.2).timeout
    await snap("/tmp/shot21_cthulhu_awake.png")

    # 3) круг-предупреждение щупалец
    Game.hero_immune = true
    boss["slam_cd"] = 0.0
    (dun.player as Node2D).position = bnode.position + Vector2(26, 36)
    for i in range(60):
        await get_tree().physics_frame
        if boss.has("slam_mark"):
            break
    await get_tree().create_timer(0.4).timeout
    if dun._camera != null:
        dun._camera.reset_smoothing()
    await snap("/tmp/shot21_slam_tell.png")
    for i in range(140):
        await get_tree().physics_frame
        if not boss.has("slam_at"):
            break
    await get_tree().create_timer(0.12).timeout
    await snap("/tmp/shot21_slam_hit.png")

    # 4) фаза 2: небо гаснет
    boss["hp"] = int(float(boss["max_hp"]) * 0.4)
    for i in range(60):
        await get_tree().physics_frame
        if bool(boss.get("phase2", false)):
            break
    await get_tree().create_timer(1.0).timeout
    await snap("/tmp/shot21_phase2.png")

    # 5) СУМКА открыта (кнопки HUD)
    dun._on_bag_pressed()
    await get_tree().create_timer(0.4).timeout
    await snap("/tmp/shot21_bag.png")
    dun._on_bag_pressed()

    print("STEP21 SHOTS DONE")
    get_tree().quit(0)

## Съёмка скриншотов шага 33: оборотень ИДЁТ (лист полный — моделька
## не пропадает), меню паузы, подсказка сохранения с этажом.
## Запуск: godot --path . res://tests/shot_step33.tscn  (с DISPLAY)
extends Node

func snap(name: String, wait: float = 0.5) -> void:
    await get_tree().create_timer(wait).timeout
    var img := get_viewport().get_texture().get_image()
    img.save_png("user://" + name)
    print("SAVED ", name)

func _ready() -> void:
    Saves.wipe_all_slots()
    Game.meta["last_slot"] = 0
    Game.save_meta()

    # --- 1. оборотень ИДЁТ: walk-анимация, моделька на месте ---
    Game.new_run(1, "bum")
    Game.dungeon_floor = 1
    var dungeon: Node2D = (load("res://scenes/dungeon/dungeon.tscn") as PackedScene).instantiate()
    add_child(dungeon)
    await get_tree().process_frame
    await get_tree().process_frame
    dungeon._on_t_pressed()          # превращение в оборотня
    for i in range(15):
        await get_tree().physics_frame
    Input.action_press("move_right")   # шаг вправо — walk_side
    for i in range(30):
        await get_tree().physics_frame
    await snap("s33_werewolf_walk.png", 0.05)
    Input.action_release("move_right")
    # шаг вверх — walk_up
    Input.action_press("move_up")
    for i in range(30):
        await get_tree().physics_frame
    await snap("s33_werewolf_walk_up.png", 0.05)
    Input.action_release("move_up")
    dungeon.free()
    await get_tree().process_frame

    # --- 2. пауза в данже: пункты меню ---
    Game.new_run(2, "warrior")
    Game.dungeon_floor = 2
    Game.add_gold(333)
    dungeon = (load("res://scenes/dungeon/dungeon.tscn") as PackedScene).instantiate()
    add_child(dungeon)
    await get_tree().process_frame
    await get_tree().process_frame
    var pm: PauseMenu = dungeon._pause_menu
    pm.open()
    await snap("s33_pause_menu.png", 0.3)
    # СОХРАНИТЬ: подсказка «Игра сохранена в слот 1 (этаж 2)»
    pm._on_save_pressed()
    await snap("s33_save_hint.png", 0.25)
    dungeon.free()
    await get_tree().process_frame
    print("SHOT STEP33 DONE")
    get_tree().quit(0)

## Виртуальный джойстик «Dungeon Loot» (шаг 3, восстановлен в шаге 8).
## Тянешь палец (или мышь — emulate_mouse_from_touch включён) внутри круга —
## world.gd читает output как вектор движения (аналог Input.get_vector).
## Фикс шага 8: раньше world.gd искал класс через ClassDB.class_exists(),
## а скриптовые классы в ClassDB не видны — джойстик никогда не спавнился.
## Фикс шага 9 (Godot 4.7.2): class_name VirtualJoystick больше нельзя —
## в движке появился нативный класс VirtualJoystick, и скрипт падал с
## Parse Error «hides a native class». Имени класса больше нет вовсе:
## мир грузит скрипт по пути res://scripts/ui/virtual_joystick.gd и
## создаёт инстанс через GDScript.new() (см. world.gd: _build_joystick).
## Шаг 11: джойстик уменьшен (100 px в консоли, RADIUS 36) — консоль UI
## сжалась до 112 px, экран ходьбы стал больше.
extends Control

const RADIUS := 36.0
const THUMB := 13.0

var output := Vector2.ZERO
var _pressed := false
var _thumb := Vector2.ZERO

func _ready() -> void:
    _thumb = size / 2.0
    mouse_filter = Control.MOUSE_FILTER_STOP

func _input(event: InputEvent) -> void:
    # мышь и эмулированный из касания ввод покрывают и мобильные платформы
    if event is InputEventMouseButton \
            and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT:
        var mb := event as InputEventMouseButton
        if mb.pressed:
            if get_global_rect().has_point(mb.position):
                _pressed = true
                _update_thumb(mb.position)
        elif _pressed:
            _reset()
    elif event is InputEventMouseMotion and _pressed:
        _update_thumb((event as InputEventMouseMotion).position)

func _update_thumb(global_pos: Vector2) -> void:
    var offset := (global_pos - get_global_rect().get_center()).limit_length(RADIUS)
    _thumb = size / 2.0 + offset
    output = offset / RADIUS
    queue_redraw()

func _reset() -> void:
    _pressed = false
    output = Vector2.ZERO
    _thumb = size / 2.0
    queue_redraw()

func _exit_tree() -> void:
    output = Vector2.ZERO   # мир не должен уйти с зажатым направлением

func _draw() -> void:
    var center := size / 2.0
    draw_circle(center, RADIUS, Color(0.07, 0.08, 0.13, 0.55))
    draw_arc(center, RADIUS, 0.0, TAU, 40, Color(0.5, 0.42, 0.16, 0.9), 2.0, true)
    draw_circle(_thumb, THUMB, Color(0.85, 0.88, 0.94, 0.45))
    draw_arc(_thumb, THUMB, 0.0, TAU, 24, Color(1.0, 0.84, 0.0, 0.9), 2.0, true)

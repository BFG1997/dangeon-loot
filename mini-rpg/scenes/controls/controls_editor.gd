extends PanelContainer
signal back_requested

var rows: VBoxContainer
var message: Label
var save_notice: Label
var retry: Button
var choices: VBoxContainer
var capture := false
var action: StringName
var old_event: InputEvent
var candidate: InputEvent
var conflict: StringName
var held_capture: String = ""
var back_button: Button

func _ready() -> void:
    # ФИКС ПК (шаг 26): высота панели тянется за экраном. Раньше минимум
    # был жёстко 580 px (мобильные 640) — на ПК-вьюпорте 960x540 панель
    # вылезала за нижний край, и кнопка «НАЗАД» уходила за экран.
    custom_minimum_size = Vector2(328, _fit_height())
    add_theme_stylebox_override("panel", UiStyle.panel_style())
    get_viewport().size_changed.connect(_on_viewport_resized)
    var box := VBoxContainer.new()
    add_child(box)
    var title := Label.new()
    title.text = "УПРАВЛЕНИЕ ПК"
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.add_theme_color_override("font_color", UiStyle.COLOR_GOLD)
    box.add_child(title)
    var scroll := ScrollContainer.new()
    scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
    scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
    box.add_child(scroll)
    rows = VBoxContainer.new()
    rows.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    scroll.add_child(rows)
    message = Label.new()
    message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    message.add_theme_font_size_override("font_size", 12)
    box.add_child(message)
    save_notice = Label.new()
    save_notice.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    save_notice.add_theme_font_size_override("font_size", 12)
    save_notice.add_theme_color_override("font_color", Color(1.0, 0.65, 0.35))
    box.add_child(save_notice)
    choices = VBoxContainer.new()
    box.add_child(choices)
    retry = _button(box, "ПОВТОРИТЬ СОХРАНЕНИЕ", func(): Controls.save_bindings())
    _button(box, "ПО УМОЛЧАНИЮ", _ask_reset)
    back_button = _button(box, "НАЗАД", _back)
    Controls.bindings_changed.connect(_refresh)
    Controls.save_state_changed.connect(_save_state)
    _refresh()
    _save_state(Controls.last_save_error, Controls.save_pending)

func _exit_tree() -> void:
    Controls.bindings_changed.disconnect(_refresh)
    Controls.save_state_changed.disconnect(_save_state)
    var vp := get_viewport()
    if vp != null and vp.size_changed.is_connected(_on_viewport_resized):
        vp.size_changed.disconnect(_on_viewport_resized)

## Актуальная минимальная высота панели: не выше экрана минус поля,
## но не ниже 320 (список внутри скроллится).
func _fit_height() -> float:
    var height := 580.0
    var vp := get_viewport()
    if vp != null:
        height = minf(height, maxf(320.0, vp.get_visible_rect().size.y - 24.0))
    return height

func _on_viewport_resized() -> void:
    custom_minimum_size = Vector2(328, _fit_height())

func _button(parent: Node, text: String, callback: Callable) -> Button:
    var button := Button.new()
    button.text = text
    UiStyle.style_button(button, 12)
    button.focus_mode = Control.FOCUS_ALL
    button.custom_minimum_size.y = 28
    button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    button.pressed.connect(callback)
    parent.add_child(button)
    return button

func _clear(node: Node) -> void:
    for child in node.get_children():
        node.remove_child(child)
        child.queue_free()

func _refresh() -> void:
    _clear(rows)
    for id in Controls.get_actions():
        var label := Label.new()
        label.text = Controls.get_action_label(id)
        label.add_theme_font_size_override("font_size", 12)
        rows.add_child(label)
        var flow := HFlowContainer.new()
        rows.add_child(flow)
        for event in Controls.get_bindings(id):
            var button := _button(flow, Controls.get_event_label(event), _select.bind(id, event))
            button.custom_minimum_size.x = 56
        _button(flow, "+", _begin.bind(id, null))

func _select(id: StringName, event: InputEvent) -> void:
    _cancel()
    action = id
    old_event = event
    message.text = Controls.get_action_label(id) + ": " + Controls.get_event_label(event)
    _button(choices, "ИЗМЕНИТЬ", _begin.bind(id, event))
    _button(choices, "УДАЛИТЬ", func(): _finish(Controls.remove_binding(id, event)))
    _button(choices, "ОТМЕНА", _cancel)

func _begin(id: StringName, event: InputEvent) -> void:
    _cancel()
    action = id
    old_event = event
    capture = true
    message.text = "Нажмите клавишу или кнопку мыши\nEscape — отмена"
    var focused := get_viewport().gui_get_focus_owner()
    if focused != null:
        focused.release_focus()
    _button(choices, "ОТМЕНА", _cancel)
    get_viewport().set_input_as_handled()

func _is_cancel(event: InputEvent) -> bool:
    return event is InputEventKey and event.pressed and not event.echo and (event.keycode == KEY_ESCAPE or event.physical_keycode == KEY_ESCAPE)

func _identity(event: InputEvent) -> String:
    if event is InputEventKey:
        return "k%d" % (event.physical_keycode if event.physical_keycode else event.keycode)
    if event is InputEventMouseButton:
        return "m%d" % event.button_index
    return ""

func _input(event: InputEvent) -> void:
    if not is_visible_in_tree():
        return
    # Swallow the release too: captured Enter/Space must not activate focused UI.
    if held_capture != "" and _identity(event) == held_capture:
        get_viewport().set_input_as_handled()
        if not event.is_pressed():
            held_capture = ""
        return
    if capture:
        if event is InputEventMouseButton and choices.get_child_count() == 1:
            if (choices.get_child(0) as Control).get_global_rect().has_point(event.position):
                return
        if not event is InputEventKey and not event is InputEventMouseButton:
            return
        get_viewport().set_input_as_handled()
        if not event.is_pressed() or event.is_echo():
            return
        if _is_cancel(event):
            held_capture = _identity(event)
            _cancel()
            return
        held_capture = _identity(event)
        candidate = event.duplicate()
        var result: Dictionary
        if old_event == null:
            result = Controls.add_binding(action, candidate)
        else:
            result = Controls.replace_binding(action, old_event, candidate)
        if result.status == "conflict":
            capture = false
            conflict = result.conflict
            _clear(choices)
            message.text = "%s уже используется: %s. Перенести на «%s»?" % [Controls.get_event_label(candidate), Controls.get_action_label(conflict), Controls.get_action_label(action)]
            _button(choices, "ПЕРЕНЕСТИ", _transfer)
            _button(choices, "ОТМЕНА", _cancel)
        elif result.status == "invalid_event":
            message.text = "Недопустимое назначение. Без Escape, Tab, колеса и модификаторов.\nНажмите другую клавишу."
        else:
            _finish(result)
    elif _is_cancel(event):
        get_viewport().set_input_as_handled()
        if choices.get_child_count() > 0:
            _cancel()
        else:
            _back()

func _transfer() -> void:
    var result: Dictionary
    if old_event == null:
        result = Controls.move_binding(conflict, action, candidate)
    else:
        result = Controls.move_replace_binding(conflict, action, old_event, candidate)
    _finish(result)

func _ask_reset() -> void:
    _cancel()
    message.text = "Восстановить стандартное управление?"
    _button(choices, "ВОССТАНОВИТЬ", func(): _finish(Controls.reset_defaults()))
    _button(choices, "ОТМЕНА", _cancel)

func _finish(result: Dictionary) -> void:
    _cancel()
    match result.status:
        "ok": message.text = "Назначение изменено."
        "unchanged": message.text = "Без изменений."
        "last_binding": message.text = "У действия должна остаться хотя бы одна клавиша"
        _: message.text = "Не удалось изменить назначение: " + result.status
    if Controls.save_pending:
        _save_state(Controls.last_save_error, true)

func _save_state(error: int, pending: bool) -> void:
    retry.visible = pending
    save_notice.visible = pending
    save_notice.text = "Не удалось сохранить управление. Изменения действуют в этом запуске." if pending else ""
    if pending:
        message.text = "Не удалось сохранить управление (код %d). Изменения действуют в этом запуске." % error
    elif message.text.begins_with("Не удалось сохранить"):
        message.text = "Управление сохранено."

func _cancel() -> void:
    capture = false
    _clear(choices)
    message.text = ""
    if back_button != null and is_visible_in_tree():
        back_button.grab_focus()

func _back() -> void:
    _cancel()
    back_requested.emit()

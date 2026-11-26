## Persistent bindings for the nine gameplay actions. Never modifies ui_*.
extends Node

signal bindings_changed
signal save_state_changed(error: int, pending: bool)

## Шаг 18: v2 — добавлено девятое действие "special" (второй приём героя,
## пробел). Профили v1 (8 действий) несовместимы и заменяются дефолтами.
## Шаг 20: v3 — десятое действие "special2" (третий приём, T); заодно
## сменились дефолты: удар на F, взаимодействие на E. Профили v2 (9
## действий) несовместимы и заменяются новыми дефолтами.
## Шаг 30: v4 — клавиши приёмов поменялись местами: приём героя (действие
## "dash", раньше был Ctrl) теперь на ПРОБЕЛЕ и ПЕРЕНАЗНАЧАЕТСЯ, а бывший
## пробел ("special": щит/барьер/газ/прыжок) переехал на Ctrl и стал
## модификатором — из ACTIONS он убран. Профили v3 несовместимы.
const PROFILE_VERSION := 4
var last_save_error: int = OK
var save_pending: bool = false
var load_diagnostic: String = ""

const ACTIONS: Array[StringName] = [
    &"move_up", &"move_down", &"move_left", &"move_right",
    &"interact", &"attack", &"cast_spell", &"dash", &"special2",
    &"toggle_inventory",
]
## Шаг 18: cast_spell — первый приём героя (Q: у мага — магия, у остальных —
## свой приём).
## Шаг 20: special2 — третий приём (T: выплеск магии/передышка/прыжок/град).
## Шаг 30: dash — приём героя на ПРОБЕЛЕ (у воина рывок, у мага телепорт,
## у бомжа хмель, у варвара пинок); он переназначается в редакторе.
## Действия "special" (щит/барьер/газ/прыжок — теперь Ctrl) и "run" (бег
## на Shift) в ACTIONS не входят: клавиши-модификаторы _normalize не
## принимает, они не переназначаются.
const ACTION_LABELS := {
    &"move_up": "Вверх", &"move_down": "Вниз", &"move_left": "Влево",
    &"move_right": "Вправо", &"interact": "Взаимодействие", &"attack": "Атака",
    &"cast_spell": "Приём Q", &"dash": "Приём героя", &"special2": "Приём T",
    &"toggle_inventory": "Инвентарь",
}

var _defaults: Dictionary = {}

func _ready() -> void:
    for action in ACTIONS:
        if not InputMap.has_action(action):
            push_error("Controls: missing action %s" % action)
            continue
        # Keep independent copies: callers must not mutate the defaults.
        _defaults[action] = get_bindings(action)
    Game.meta_saved.connect(_on_meta_saved)
    if not Platform.meta_load_error.is_empty():
        load_diagnostic = Platform.meta_load_error
    elif Game.meta.has("controls"):
        var checked := _decode_profile(Game.meta["controls"])
        if checked["error"].is_empty():
            _apply(checked["bindings"], false)
        else:
            load_diagnostic = checked["error"]
            push_warning("Controls: " + load_diagnostic)

func get_actions() -> Array[StringName]:
    return ACTIONS.duplicate()

func get_action_label(action: StringName) -> String:
    return ACTION_LABELS.get(action, "")

func get_bindings(action: StringName) -> Array[InputEvent]:
    var result: Array[InputEvent] = []
    if action not in ACTIONS or not InputMap.has_action(action):
        return result
    for event in InputMap.action_get_events(action):
        result.append(event.duplicate() as InputEvent)
    return result

## Mutations return {status, conflict}. Only "ok" means a change occurred.
## Other statuses: unchanged, invalid_action, invalid_event, not_found,
## conflict, last_binding, defaults_unavailable.
func _result(status: String, conflict: StringName = &"") -> Dictionary:
    var result := {"status": status, "conflict": conflict}
    if status == "ok":
        # Operation succeeded in memory; disk success is reported separately.
        result["save_error"] = last_save_error
        result["save_pending"] = save_pending
    return result

## A single normalization path also validates events used for lookup/removal.
## Logical-only key events use their base keycode as the physical-code fallback.
func _normalize(event: InputEvent) -> InputEvent:
    if event is InputEventKey:
        var key := event as InputEventKey
        if key.ctrl_pressed or key.alt_pressed or key.shift_pressed or key.meta_pressed:
            return null
        var code := int(key.physical_keycode if key.physical_keycode != 0 else key.keycode)
        if code in [KEY_NONE, KEY_ESCAPE, KEY_TAB, KEY_BACKTAB, KEY_SHIFT,
                KEY_CTRL, KEY_ALT, KEY_META]:
            return null
        # Round-trip through Godot's key names rejects unknown codes and masks.
        var label := OS.get_keycode_string(code)
        if label.is_empty() or int(OS.find_keycode_from_string(label)) != code:
            return null
        var normalized := InputEventKey.new()
        normalized.physical_keycode = code
        return normalized
    if event is InputEventMouseButton:
        var mouse := event as InputEventMouseButton
        if mouse.ctrl_pressed or mouse.alt_pressed or mouse.shift_pressed or mouse.meta_pressed:
            return null
        if mouse.button_index not in [MOUSE_BUTTON_LEFT, MOUSE_BUTTON_RIGHT,
                MOUSE_BUTTON_MIDDLE, MOUSE_BUTTON_XBUTTON1, MOUSE_BUTTON_XBUTTON2]:
            return null
        var normalized := InputEventMouseButton.new()
        normalized.button_index = mouse.button_index
        return normalized
    return null

func _id(event: InputEvent) -> String:
    var normalized := _normalize(event)
    if normalized is InputEventKey:
        return "key:%d" % normalized.physical_keycode
    if normalized is InputEventMouseButton:
        return "mouse:%d" % normalized.button_index
    return ""

func _index(events: Array[InputEvent], event: InputEvent) -> int:
    var wanted := _id(event)
    for i in events.size():
        if _id(events[i]) == wanted:
            return i
    return -1

## Empty means no conflicting gameplay action; validate via a mutation result.
func find_conflict(action: StringName, event: InputEvent) -> StringName:
    if action not in ACTIONS or _normalize(event) == null:
        return &""
    for other in ACTIONS:
        if other != action and _index(get_bindings(other), event) >= 0:
            return other
    return &""

func add_binding(action: StringName, event: InputEvent) -> Dictionary:
    return _edit(action, null, event, "add")

func replace_binding(action: StringName, old_event: InputEvent, new_event: InputEvent) -> Dictionary:
    return _edit(action, old_event, new_event, "replace")

func remove_binding(action: StringName, event: InputEvent) -> Dictionary:
    return _edit(action, event, null, "remove")

func _edit(action: StringName, old_event: InputEvent, new_event: InputEvent, mode: String) -> Dictionary:
    if action not in ACTIONS or not InputMap.has_action(action):
        return _result("invalid_action")
    var events := get_bindings(action)
    var index := -1
    if mode != "add":
        if _normalize(old_event) == null:
            return _result("invalid_event")
        index = _index(events, old_event)
        if index < 0:
            return _result("not_found")
    if mode != "remove":
        var normalized := _normalize(new_event)
        if normalized == null:
            return _result("invalid_event")
        # An existing target binding is a no-op, including replacement.
        if _index(events, normalized) >= 0:
            return _result("unchanged")
        var conflict := find_conflict(action, normalized)
        if conflict != &"":
            return _result("conflict", conflict)
        if mode == "add":
            events.append(normalized)
        else:
            events[index] = normalized
    else:
        if events.size() <= 1:
            return _result("last_binding")
        events.remove_at(index)
    _apply({action: events})
    return _result("ok")

func move_binding(from_action: StringName, to_action: StringName, event: InputEvent) -> Dictionary:
    if from_action not in ACTIONS or to_action not in ACTIONS \
            or not InputMap.has_action(from_action) or not InputMap.has_action(to_action):
        return _result("invalid_action")
    var normalized := _normalize(event)
    if normalized == null:
        return _result("invalid_event")
    var source := get_bindings(from_action)
    var index := _index(source, normalized)
    if index < 0:
        return _result("not_found")
    if from_action == to_action:
        return _result("unchanged")
    if source.size() <= 1:
        return _result("last_binding")
    var target := get_bindings(to_action)
    if _index(target, normalized) >= 0:
        return _result("unchanged")
    for other in ACTIONS:
        if other != from_action and other != to_action \
                and _index(get_bindings(other), normalized) >= 0:
            return _result("conflict", other)
    source.remove_at(index)
    target.append(normalized)
    _apply({from_action: source, to_action: target})
    return _result("ok")

func reset_defaults() -> Dictionary:
    if _defaults.size() != ACTIONS.size():
        return _result("defaults_unavailable")
    var changed := false
    for action in ACTIONS:
        var current := get_bindings(action)
        var defaults: Array[InputEvent] = _defaults[action]
        if current.size() != defaults.size():
            changed = true
        else:
            for i in current.size():
                if _id(current[i]) != _id(defaults[i]):
                    changed = true
    if not changed:
        return _result("unchanged")
    _apply(_defaults)
    return _result("ok")

## No awaits or signals inside the commit; listeners see the complete change.
func _apply(changes: Dictionary, persist: bool = true) -> void:
    if not persist:
        var changed := false
        for action in changes:
            var current := get_bindings(action)
            var incoming: Array[InputEvent] = changes[action]
            if current.size() != incoming.size():
                changed = true
            else:
                for i in current.size():
                    if _id(current[i]) != _id(incoming[i]):
                        changed = true
        if not changed:
            return
    for action in changes:
        InputMap.action_erase_events(action)
        for event in changes[action]:
            InputMap.action_add_event(action, event.duplicate() as InputEvent)
    if persist:
        save_bindings()
    bindings_changed.emit()

func get_event_label(event: InputEvent) -> String:
    var normalized := _normalize(event)
    if normalized is InputEventKey:
        # Шаг 30: Пробел по-русски — слот приёма подписан «ПРОБЕЛ», и в
        # подсказке/редакторе он должен называться так же.
        if int(normalized.physical_keycode) == KEY_SPACE:
            return "Пробел"
        return OS.get_keycode_string(normalized.physical_keycode)
    if normalized is InputEventMouseButton:
        return {
            MOUSE_BUTTON_LEFT: "ЛКМ", MOUSE_BUTTON_RIGHT: "ПКМ",
            MOUSE_BUTTON_MIDDLE: "Средняя кнопка мыши",
            MOUSE_BUTTON_XBUTTON1: "Кнопка мыши 4",
            MOUSE_BUTTON_XBUTTON2: "Кнопка мыши 5",
        }.get(normalized.button_index, "")
    return ""


## Explicit retry after a failed save. User edits/reset also call this method.
func save_bindings() -> int:
    var profile := serialize_profile()
    # Revalidate the whole profile, including unexpected external InputMap edits.
    var checked := _decode_profile(profile)
    if not checked["error"].is_empty():
        last_save_error = ERR_INVALID_DATA
        save_pending = true
        save_state_changed.emit(last_save_error, save_pending)
        return last_save_error
    Game.meta["controls"] = profile
    save_pending = true
    return Game.save_meta()

func _on_meta_saved(error: int) -> void:
    if not save_pending:
        return
    last_save_error = error
    # Any successful write of the shared metadata also saves pending controls.
    if error == OK and Game.meta.get("controls") == serialize_profile():
        save_pending = false
    save_state_changed.emit(last_save_error, save_pending)

func serialize_profile() -> Dictionary:
    var bindings := {}
    for action in ACTIONS:
        var events: Array = []
        for event in get_bindings(action):
            var normalized := _normalize(event)
            if normalized is InputEventKey:
                events.append({"type": "key", "physical_keycode": int(normalized.physical_keycode)})
            elif normalized is InputEventMouseButton:
                events.append({"type": "mouse", "button_index": int(normalized.button_index)})
            else:
                # Do not silently drop externally injected invalid events.
                events.append(null)
        bindings[String(action)] = events
    return {"version": PROFILE_VERSION, "bindings": bindings}

## JSON numbers are floats. Reject booleans, fractions, strings and overflow.
func _integer(value: Variant) -> bool:
    return (value is int or value is float) and is_finite(float(value)) \
        and float(value) == floor(float(value)) and float(value) >= 0.0 \
        and float(value) <= 2147483647.0

func _invalid_profile(message: String) -> Dictionary:
    return {"error": message, "bindings": {}}

func _decode_profile(value: Variant) -> Dictionary:
    if not value is Dictionary:
        return _invalid_profile("controls must be an object")
    if not _integer(value.get("version")):
        return _invalid_profile("Invalid controls version")
    if int(value["version"]) != PROFILE_VERSION:
        return _invalid_profile("Unsupported controls version: %s" % value["version"])
    var raw: Variant = value.get("bindings")
    if not raw is Dictionary or raw.size() != ACTIONS.size():
        return _invalid_profile("Expected all %d gameplay actions" % ACTIONS.size())
    for action in raw:
        if not action is String or StringName(action) not in ACTIONS:
            return _invalid_profile("Unknown gameplay action: %s" % action)
    var profile := {}
    var owners := {}
    for action in ACTIONS:
        var entries: Variant = raw.get(String(action))
        if not entries is Array or entries.is_empty():
            return _invalid_profile("Missing or empty bindings: %s" % action)
        var events: Array[InputEvent] = []
        for entry in entries:
            if not entry is Dictionary:
                return _invalid_profile("Invalid event: %s" % action)
            var event: InputEvent
            match entry.get("type"):
                "key":
                    if entry.size() != 2 or not _integer(entry.get("physical_keycode")):
                        return _invalid_profile("Invalid key data: %s" % action)
                    var key := InputEventKey.new()
                    key.physical_keycode = int(entry["physical_keycode"])
                    event = key
                "mouse":
                    if entry.size() != 2 or not _integer(entry.get("button_index")):
                        return _invalid_profile("Invalid mouse data: %s" % action)
                    var mouse := InputEventMouseButton.new()
                    mouse.button_index = int(entry["button_index"])
                    event = mouse
                _:
                    return _invalid_profile("Unsupported event type: %s" % action)
            var normalized := _normalize(event)
            if normalized == null:
                return _invalid_profile("Disallowed binding: %s" % action)
            var identity := _id(normalized)
            if owners.has(identity):
                if owners[identity] != action:
                    return _invalid_profile("Binding conflict: %s / %s" % [owners[identity], action])
                continue # Normalize repeats within an action without writing on load.
            owners[identity] = action
            events.append(normalized)
        profile[action] = events
    return {"error": "", "bindings": profile}

## Atomic conflict resolution for replacement: validate both lists before commit.
func move_replace_binding(from_action: StringName, to_action: StringName, old_event: InputEvent, event: InputEvent) -> Dictionary:
    if from_action not in ACTIONS or to_action not in ACTIONS or from_action == to_action:
        return _result("invalid_action")
    var normalized := _normalize(event)
    if normalized == null or _normalize(old_event) == null:
        return _result("invalid_event")
    var source := get_bindings(from_action)
    var target := get_bindings(to_action)
    var source_index := _index(source, normalized)
    var target_index := _index(target, old_event)
    if source_index < 0 or target_index < 0:
        return _result("not_found")
    if source.size() <= 1:
        return _result("last_binding")
    if _index(target, normalized) >= 0:
        return _result("unchanged")
    for other in ACTIONS:
        if other != from_action and other != to_action and _index(get_bindings(other), normalized) >= 0:
            return _result("conflict", other)
    source.remove_at(source_index)
    target[target_index] = normalized
    _apply({from_action: source, to_action: target})
    return _result("ok")

func get_binding_text(action: StringName, primary_only: bool = false) -> String:
    var labels: PackedStringArray = []
    for event in get_bindings(action):
        labels.append(get_event_label(event))
        if primary_only:
            break
    return " / ".join(labels)

## Шаг 18: в подсказку добавлены приёмы героя. ability_q/ability_special —
## названия приёмов текущего класса (пустая строка — строчка не выводится;
## у мага «магия» уже напечатана по has_magic, его приём Q не дублируется).
## Шаг 30: клавиши приёмов поменялись местами. Приём героя (dash) теперь
## на ПРОБЕЛЕ и зовётся привязкой действия (переназначается); бывший
## пробел (special) — на Ctrl, это модификатор: печатаем жёсткое «Ctrl».
## Двойной тап направления — только у героев, чей приём перемещает
## (воин и маг).
func get_hud_hint(has_magic: bool, ability_q: String = "",
        ability_special: String = "", ability_t: String = "") -> String:
    var movement: PackedStringArray = []
    for action in [&"move_up", &"move_left", &"move_down", &"move_right"]:
        movement.append(get_binding_text(action, true))
    var dash_title := String(Game.ability_info("dash").get("title", "Рывок"))
    var dash_note := "%s — %s" % [get_binding_text(&"dash", true), dash_title]
    var kind := String(Game.ability_info("dash").get("kind", "dash"))
    # шаг 31: фазовый рывок некроманта тоже перемещение — двойной тап работает
    if kind == "dash" or kind == "blink" or kind == "phase_dash":
        dash_note += " · двойной тап направления — тоже"
    var text := "%s / джойстик — идти · %s — говорить / использовать\n%s — удар · %s — сумка · Shift — бег · %s" % [
        " / ".join(movement), get_binding_text(&"interact", true),
        get_binding_text(&"attack", true), get_binding_text(&"toggle_inventory", true),
        dash_note]
    if has_magic:
        text += " · %s — магия" % get_binding_text(&"cast_spell", true)
    if not ability_q.is_empty():
        text += " · %s — %s" % [get_binding_text(&"cast_spell", true), ability_q]
    if not ability_special.is_empty():
        text += " · Ctrl — %s" % ability_special
    if not ability_t.is_empty():
        text += " · %s — %s" % [get_binding_text(&"special2", true), ability_t]
    return text

## Run ONLY with isolated user data (e.g. a temporary XDG_DATA_HOME on Linux):
## godot --headless --path . res://tests/controls_test.tscn -- --isolated-controls-test
## Шаг 30: донор переноса — "dash" (пробел, приём героя),
## потому что у "attack" теперь две привязки (ЛКМ + F).
extends Node
var failed := 0
var checks := 0
var changes := 0
func check(value: bool, label: String) -> void:
    checks += 1
    if not value:
        failed += 1
        push_error(label)
func key(code: int) -> InputEventKey:
    var e := InputEventKey.new()
    e.physical_keycode = code
    return e
func _ready() -> void:
    if "--isolated-controls-test" not in OS.get_cmdline_user_args():
        push_error("Controls test refused: use isolated user data and --isolated-controls-test")
        get_tree().quit(2)
        return
    Controls.reset_defaults()
    Controls.bindings_changed.connect(func(): changes += 1)
    var ui := InputMap.action_get_events("ui_accept").map(func(e): return e.as_text())
    for action in Controls.get_actions():
        var original := Controls.serialize_profile()
        var count := changes
        check(Controls.add_binding(action,key(KEY_ESCAPE)).status == "invalid_event", "reserved key")
        check(original == Controls.serialize_profile() and changes == count, "invalid operation atomic")
        check(Controls.add_binding(action,key(KEY_G)).status == "ok", "add: "+str(action))
        check(Controls.add_binding(action,key(KEY_G)).status == "unchanged", "duplicate")
        check(Controls.replace_binding(action,key(KEY_G),key(KEY_H)).status == "ok", "replace")
        check(Controls.remove_binding(action,key(KEY_H)).status == "ok", "remove")
        check(original == Controls.serialize_profile() and changes == count+3, "profile restored; exact signal count")
    check(ui == InputMap.action_get_events("ui_accept").map(func(e): return e.as_text()), "ui actions untouched")
    var original := Controls.serialize_profile()
    check(Controls.move_replace_binding("dash","attack",Controls.get_bindings("attack")[0],key(KEY_SPACE)).status == "last_binding", "reject empty donor")
    check(original == Controls.serialize_profile(), "failed transfer atomic")
    Controls.add_binding("dash",key(KEY_J))
    var victim: InputEvent = Controls.get_bindings("attack")[0]
    check(Controls.move_replace_binding("dash","attack",victim,key(KEY_SPACE)).status == "ok", "atomic replacement")
    check(Controls.get_bindings("attack").size()==2 \
        and Controls._index(Controls.get_bindings("attack"), key(KEY_SPACE)) >= 0 \
        and Controls._index(Controls.get_bindings("attack"), victim) < 0,
        "replacement does not append")
    Controls.reset_defaults()
    var editor := preload("res://scenes/controls/controls_editor.tscn").instantiate()
    add_child(editor)
    editor.visible = true
    var temporary := ProjectSettings.globalize_path("user://meta.json.tmp")
    DirAccess.make_dir_absolute(temporary)
    Controls.add_binding("attack",key(KEY_J))
    check(Controls.save_pending and editor.save_notice.visible, "save warning")
    editor._cancel()
    check(editor.save_notice.visible and not editor.save_notice.text.is_empty(), "cancel preserves unsaved warning")
    editor._select("attack",key(KEY_J))
    check(editor.save_notice.visible, "selection preserves warning")
    DirAccess.remove_absolute(temporary)
    check(Controls.save_bindings()==OK and not editor.save_notice.visible, "retry clears warning")
    # Existing temp file stays writable while directory rename is forbidden.
    # This exercises replacement failure, not merely failure to open the temp.
    var meta_path := ProjectSettings.globalize_path("user://meta.json")
    var previous := FileAccess.get_file_as_string(meta_path)
    var file := FileAccess.open(temporary, FileAccess.WRITE)
    file.store_string("staged")
    file.close()
    var directory := ProjectSettings.globalize_path("user://")
    var permissions := FileAccess.get_unix_permissions(directory)
    if OS.has_feature("linux"):
        FileAccess.set_unix_permissions(directory, 320) # owner read + execute
        var result := Controls.add_binding("attack",key(KEY_K))
        FileAccess.set_unix_permissions(directory, permissions)
        check(result.save_error != OK and Controls.save_pending, "rename failure reported")
        check(FileAccess.get_file_as_string(meta_path) == previous, "rename failure preserves previous meta")
        check(Controls.save_bindings() == OK, "retry after rename failure")
    var profile := Controls.serialize_profile()
    Game.reset_progress()
    check(profile == Controls.serialize_profile(), "progress reset preserves active controls")
    check(JSON.parse_string(JSON.stringify(profile)) == Platform.load_meta().get("controls"), "progress reset preserves stored controls")
    editor.queue_free()
    await get_tree().process_frame
    Controls.reset_defaults()
    print("CONTROLS TEST: checks=",checks," failed=",failed)
    get_tree().quit(1 if failed else 0)

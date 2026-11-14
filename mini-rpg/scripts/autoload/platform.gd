## Автозагрузка Platform: мост между игрой и площадкой.
## Сейчас работает «локальный режим» (десктоп/RuStore: файлы сохранений).
## Перед экспортом на Яндекс Игры сюда добавим вызовы Yandex Games SDK:
## LoadingAPI.ready(), GameplayAPI.start()/stop(), player.setData()/getData().
extends Node

enum Provider { LOCAL, YANDEX, RUSTORE }

const SLOT_TEMPLATE := "user://save_slot_%d.json"
const META_PATH := "user://meta.json"
const LEGACY_SAVE_PATH := "user://save.json"  # сейв из шагов 1-2

## Diagnostic for the most recent global metadata read; missing file is normal.
var meta_load_error: String = ""

var provider: Provider = Provider.LOCAL
## Журнал вызовов для автотестов (в релизе не используется).
var calls: Array[String] = []

## Игра действительно готова к взаимодействию (на Яндексе — LoadingAPI.ready(),
## модерация проверяет этот вызов).
func notify_ready() -> void:
    calls.append("notify_ready")
    if provider == Provider.YANDEX:
        pass  # TODO(экспорт): ysdk.LoadingAPI.ready()

## Игрок начал играть (разметка геймплея для аналитики Яндекса).
func gameplay_start() -> void:
    calls.append("gameplay_start")
    if provider == Provider.YANDEX:
        pass  # TODO(экспорт): ysdk.GameplayAPI.start()

## Игрок остановился (меню, пауза, конец уровня).
func gameplay_stop() -> void:
    calls.append("gameplay_stop")
    if provider == Provider.YANDEX:
        pass  # TODO(экспорт): ysdk.GameplayAPI.stop()

func slot_path(slot: int) -> String:
    return SLOT_TEMPLATE % maxi(1, slot)

## Сохранить прогресс в слот. Локально — файл, на Яндексе — player.setData().
func save_data(data: Dictionary, slot: int = 1) -> int:
    var file := FileAccess.open(slot_path(slot), FileAccess.WRITE)
    if file == null:
        return FAILED
    file.store_string(JSON.stringify(data, "\t"))
    return OK

## Загрузить слот. Пустой словарь — сохранения нет.
func load_data(slot: int = 1) -> Dictionary:
    var path := slot_path(slot)
    if not FileAccess.file_exists(path):
        return {}
    var file := FileAccess.open(path, FileAccess.READ)
    if file == null:
        return {}
    var parsed: Variant = JSON.parse_string(file.get_as_text())
    if parsed is Dictionary:
        return parsed
    return {}

func has_slot(slot: int) -> bool:
    return FileAccess.file_exists(slot_path(slot))

## Удалить файл слота (не ошибка, если слота и не было).
func delete_slot(slot: int) -> void:
    if not has_slot(slot):
        return
    var dir := DirAccess.open("user://")
    if dir != null:
        dir.remove(slot_path(slot).get_file())

## Сохранить глобальные данные (настройки, последний слот, бонус) — meta.json.
func save_meta(meta: Dictionary) -> int:
    # Stage in the same directory: a failed write must not truncate meta.json.
    var temporary := META_PATH + ".tmp"
    var file := FileAccess.open(temporary, FileAccess.WRITE)
    if file == null:
        return FileAccess.get_open_error()
    file.store_string(JSON.stringify(meta, "\t"))
    file.flush()
    var error := file.get_error()
    file.close()
    if error != OK:
        DirAccess.remove_absolute(temporary)
        return error
    error = DirAccess.rename_absolute(temporary, META_PATH)
    if error != OK:
        DirAccess.remove_absolute(temporary)
    return error

func load_meta() -> Dictionary:
    meta_load_error = ""
    if not FileAccess.file_exists(META_PATH):
        return {}
    var file := FileAccess.open(META_PATH, FileAccess.READ)
    if file == null:
        meta_load_error = "Cannot open meta.json (%d)" % FileAccess.get_open_error()
        push_warning(meta_load_error)
        return {}
    var source := file.get_as_text()
    var read_error := file.get_error()
    if read_error != OK and read_error != ERR_FILE_EOF:
        meta_load_error = "Cannot read meta.json (%d)" % read_error
    else:
        var json := JSON.new()
        var error := json.parse(source)
        if error != OK:
            meta_load_error = "Invalid meta.json at line %d: %s" % [json.get_error_line(), json.get_error_message()]
        elif not json.data is Dictionary:
            meta_load_error = "meta.json root must be an object"
        else:
            return json.data
    push_warning(meta_load_error)
    return {}

## Чтение старого сейва шагов 1-2 (миграция в слоты).
func load_legacy() -> Dictionary:
    if not FileAccess.file_exists(LEGACY_SAVE_PATH):
        return {}
    var file := FileAccess.open(LEGACY_SAVE_PATH, FileAccess.READ)
    if file == null:
        return {}
    var parsed: Variant = JSON.parse_string(file.get_as_text())
    if parsed is Dictionary:
        return parsed
    return {}

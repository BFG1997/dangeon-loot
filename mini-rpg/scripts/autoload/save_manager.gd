## Автозагрузка Saves: управление 3 слотами сохранений.
## Само хранилище абстрагировано в Platform: сейчас это файлы user://save_slot_N.json,
## на Яндекс Играх станет облачным сохранением игрока (player.setData).
extends Node

func _ready() -> void:
    # Миграция старого сейва шагов 1-2 (user://save.json) в первый свободный слот.
    var legacy := Platform.load_legacy()
    if not legacy.is_empty():
        for slot in range(1, Game.SLOT_COUNT + 1):
            if not Platform.has_slot(slot):
                if Platform.save_data(legacy, slot) == OK:
                    Game.meta["last_slot"] = slot
                    Game.save_meta()
                break
    # Подтягиваем последний игравшийся слот в память (для меню и бонуса).
    var last := int(Game.meta.get("last_slot", 0))
    if last >= 1 and last <= Game.SLOT_COUNT and Platform.has_slot(last):
        Game.load_save_data(Platform.load_data(last))
        Game.current_slot = last

## Запрос на сохранение (вызывается из Game при любом изменении).
## Сохраняем только когда игра реально идёт (есть активный слот).
func request_save() -> void:
    if Game.current_slot < 1:
        return
    var err := Platform.save_data(Game.to_save_data(), Game.current_slot)
    if err != OK:
        push_warning("Saves: не удалось сохранить, код ошибки %d" % err)
        return
    Game.meta["last_slot"] = Game.current_slot
    Game.save_meta()

## Сводка по слоту для списка «Загрузить игру».
func get_slot_info(slot: int) -> Dictionary:
    var data := Platform.load_data(slot)
    if data.is_empty():
        return {"exists": false}
    var items: Array = data.get("inventory", [])
    return {
        "exists": true,
        "hero": Game.HEROES.get(String(data.get("hero_id", Game.DEFAULT_HERO)), {}).get("title", "?"),
        "gold": int(data.get("gold", 0)),
        "items": items.size(),
        "ts": String(data.get("saved_at", "")),
    }

## Удалить все слоты (используется при полном сбросе прогресса).
func wipe_all_slots() -> void:
    for slot in range(1, Game.SLOT_COUNT + 1):
        Platform.delete_slot(slot)

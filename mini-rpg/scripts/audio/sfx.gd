## Шаг 19: звук игры — эффекты (SFX) и эмбиент в духе Silent Hill.
## Шаг 20: весь WAV-синтез перегенерирован tools/gen_audio_step20.py —
## звуки стали мягче и приятнее на слух, эмбиент — мелодичнее; добавлены
## эффекты третьих приёмов (surge/heal/leap/rain). Никаких внешних файлов.
## Шаг 21: голос Большого Ктулху — roar (рёв пробуждения, нарастает
## как землетрясение) и slam (мокрый удар щупалец); 20 эффектов,
## генератор tools/gen_audio_step21.py.
## Шаг 27: звуки боя — crit (критический удар) и dash (рывок); для
## удара/попадания/боли/смерти — 3 варианта тона (play_variant, питч
## ±8%) вместо одного сэмпла: ощущение боя заметно живее.
## Тумблеры настроек: Game.settings["sound"] — эффекты,
## Game.settings["music"] — эмбиент (панель НАСТРОЙКИ в меню).
## Использование из сцен:
##   Sfx.play("swing")                      — разовый эффект с джиттером тона;
##   Sfx.start_ambient(self, -6.0)          — зацикленный эмбиент в сцене;
##   Sfx.stop_ambient()                     — остановить при выходе из сцены.
class_name Sfx
extends RefCounted

const SFX_DIR := "res://assets/audio/sfx/"
const AMBIENT_PATH := "res://assets/audio/music/ambient_dungeon.wav"

## Все эффекты игры (имя -> файл). 22 штуки (шаг 27: +2 боевых).
const SOUNDS := {
    "swing": "sfx_swing.wav",      # взмах оружием
    "throw": "sfx_throw.wav",      # тяжёлый бросок (топор, враг)
    "hit": "sfx_hit.wav",          # попадание по врагу
    "hurt": "sfx_hurt.wav",        # герой получил урон
    "die": "sfx_die.wav",          # враг рассыпался
    "bolt": "sfx_bolt.wav",        # каст магии / болт
    "chest": "sfx_chest.wav",      # открытие сундука
    "coin": "sfx_coin.wav",        # золото
    "levelup": "sfx_levelup.wav",  # повышение уровня
    "dust": "sfx_dust.wav",        # горсть пыли бомжа
    "gas": "sfx_gas.wav",          # гнилой газ
    "shield": "sfx_shield.wav",    # щит воина
    "barrier": "sfx_barrier.wav",  # барьер мага
    "stairs": "sfx_stairs.wav",    # спуск по лестнице
    # шаг 20: приёмы T — выплеск/передышка/прыжок/град
    "surge": "sfx_surge.wav",      # выплеск магии (маг, T)
    "heal": "sfx_heal.wav",        # передышка (бомж, T)
    "leap": "sfx_leap.wav",        # смертельный прыжок (варвар, T)
    "rain": "sfx_rain.wav",        # град мечей (рыцарь, T)
    # шаг 21: голос Большого Ктулху
    "roar": "sfx_cthulhu_roar.wav",   # рёв пробудившегося Ктулху
    "slam": "sfx_tentacle_slam.wav",  # мокрый удар щупалец
    # шаг 27: боевая система
    "crit": "sfx_crit.wav",           # критический удар (жёлтая цифра)
    "dash": "sfx_dash.wav",           # рывок-уклонение
}

## Шаг 27: три варианта тона для боевых звуков (удар/попадание/боль/смерть):
## фиксированные питчи вместо одного сэмпла — бой звучит разнообразно.
const VARIANT_PITCHES := [0.92, 1.0, 1.08]

static var _streams := {}               # кэш загруженных AudioStream
static var _ambient_player: AudioStreamPlayer = null

## Загрузить (и закэшировать) поток по полному пути.
static func _stream_for(path: String) -> AudioStream:
    if not _streams.has(path):
        _streams[path] = load(path)
    return _streams[path]

## Проиграть эффект: игрок живёт в корне сцены и освобождается сам.
## pitch_jitter — лёгкий разброс тона, чтобы одинаковые звуки не зудели.
## pitch_base — базовый тон (шаг 27: комбо бьёт ниже/выше обычного).
static func play(sound: String, volume_db: float = 0.0,
        pitch_jitter: float = 0.06, pitch_base: float = 1.0) -> void:
    if not bool(Game.settings.get("sound", true)):
        return
    var file := String(SOUNDS.get(sound, ""))
    if file.is_empty():
        push_warning("Sfx: неизвестный звук: " + sound)
        return
    var tree := Engine.get_main_loop() as SceneTree
    if tree == null or tree.root == null:
        return
    var player := AudioStreamPlayer.new()
    player.stream = _stream_for(SFX_DIR + file)
    player.volume_db = volume_db
    player.pitch_scale = pitch_base
    if pitch_jitter > 0.0:
        player.pitch_scale *= 1.0 + randf_range(-pitch_jitter, pitch_jitter)
    tree.root.add_child(player)
    player.finished.connect(player.queue_free)
    player.play()

## Шаг 27: боевой звук одним из трёх фиксированных тонов (±8%).
## Для swing/hit/hurt/die вместо одного и того же сэмпла.
static func play_variant(sound: String, volume_db: float = 0.0) -> void:
    play(sound, volume_db, 0.0,
        float(VARIANT_PITCHES[randi() % VARIANT_PITCHES.size()]))

## Запустить зацикленный эмбиент (владелец — сцена; при смене сцены
## вызывается stop_ambient). У WAV включается луп на весь файл.
static func start_ambient(host: Node, volume_db: float = -8.0) -> void:
    if not bool(Game.settings.get("music", true)):
        return
    stop_ambient()
    var tree := Engine.get_main_loop() as SceneTree
    if tree == null or tree.root == null:
        return
    var stream := _stream_for(AMBIENT_PATH)
    if stream is AudioStreamWAV:
        var looped := (stream as AudioStreamWAV).duplicate()
        looped.loop_mode = AudioStreamWAV.LOOP_FORWARD
        looped.loop_begin = 0
        # 16 бит стерео: 4 байта на кадр
        looped.loop_end = int(looped.data.size() / 4)
        stream = looped
    var player := AudioStreamPlayer.new()
    player.name = "Ambient"
    player.stream = stream
    player.volume_db = volume_db
    host.add_child(player)
    player.play()
    _ambient_player = player

## Остановить эмбиент (вызывается сценой в _exit_tree).
static func stop_ambient() -> void:
    if _ambient_player != null and is_instance_valid(_ambient_player):
        _ambient_player.queue_free()
    _ambient_player = null

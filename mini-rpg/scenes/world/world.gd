## Мир «Dungeon Loot» (шаг 7): замок + двор + край мира с безграничным космосом.
## Персонажи 24x32 с покадровыми анимациями (idle с дыханием/морганием,
## ходьба в 4 направления), y-sort глубины, диалоги с портретами,
## торговля с NPC (покупка/продажа), инвентарь, анимированные факелы/жаровни/
## фонтан/горн, парящие астероиды.
## Шаг 6: полосы ХП и маны в HUD, у мага — кнопка МАГИЯ (Q) и снаряд
## «Магической стрелы», реген маны; фиксы мигания диалога.
## Шаг 7 (боевая система): удар E и кнопка УДАР у всех героев — без оружия
## в руках удар рукой, с оружием — оружием (урон из ItemDB); у NPC есть хп
## и полоска над головой; убитый NPC падает и не воскресает в этой сессии,
## остальные NPC запоминают убийство (реплика + отказ торговать).
## Шаг 18: способности героев — приём на Q и приём на пробел у каждого
## класса (таблица Game.ABILITIES); в мире приёмы действуют только на
## разъярённого демона (мирная зона), барьер/щит дают неуязвимость.
## Шаг 8 (демон): после первого убийства у края улицы из теней выступает
## Таинственный демон (втрое крупнее NPC, парит на хвосте). Он радуется
## убийству жителей, хвалит героя и зовёт убивать ещё: -10% за каждого
## убитого NPC, а товары убитых торговцев переезжают в его лавку.
## Старые диалоги живых NPC пропадают: остаётся только реплика про убийство.
## Шаг 9: «Магическая стрела» больше не пустышка — наносит урон первому
## живому NPC на пути (урон из Game.SPELL); двери данжей стали явными:
## видимые запертые створки с подписью «Данж N», клик или E рядом —
## «Подземелье пока недоступно»; реплики NPC переписаны под хтонический
## космический хоррор; фикс Godot 4.7.2: у джойстика больше нет class_name
## (конфликт с нативным классом VirtualJoystick).
## Шаг 10 (UI вне экрана ходьбы): мир рендерится в SubViewport у верхнего
## края экрана, нижняя полоса отдана консоли UI — панель героя (хп/мана/
## золото), кнопки действий и джойстик живут там и физически не могут
## перекрыть окружение. Временные подсказки переехали к верхнему краю
## экрана ходьбы.
## Шаг 11 (управление и компактный HUD): диалог теперь на E (F тоже
## работает), удар — на левую кнопку мыши (E больше не бьёт; телефон
## адаптируем позже). Кнопки действий уменьшены (64x22), джойстик 100 px,
## консоль сжата до 112 px — экран ходьбы вырос до 360x528. Клик по пустому
## месту экрана ходьбы = удар, клик по NPC/двери = диалог (как раньше).
## Диалоговые панели (dialogue_ui.gd) больше не могут уехать за экран:
## высота считается от размера вьюпорта и резерва консоли.
## Движение: клавиатура (стрелки/WASD/E — говорить, F/ЛКМ — удар,
## I — сумка, Q — магия у мага, Shift — бег, T — третий приём) + джойстик.
## Шаг 12 (боевая система на демоне):
## - демон терпит ровно 3 удара (DEMON_RAGE_HITS), потом впадает в ярость:
##   красный аура, преследует героя (DEMON_SPEED), бьёт когтями по
##   DEMON_DAMAGE с кулдауном; лавка демона в ярости закрыта, реплики
##   меняются на угрозы; в этом состоянии он остаётся до конца сессии;
## - герой получил смерть: при хп 0 — затемнение «ТЫ ПАЛ», по кнопке герой
##   очинается в замке с полными хп/маной (без штрафов — ЗАГЛУШКА);
## - у мага Q стал зависимым от оружия: с магическим оружием — залп
##   этого оружия (веер снарядов из ItemDB.volley), без него — классическая
##   «Магическая стрела»; не-магам Q отвечает отказом (свой у каждого класса);
## - реплики NPC и демона переписаны под лавкрафтовский космо-хоррор
##   («добряки» в тексте заменены на «жителей»/«смертных»).
## Шаг 13 (данж 1 и вечная смерть демона):
## - подписи «Данж N» с дверей убраны — двери говорят сами за себя;
## - дверь 1 открывается: она ведёт в Подземелье замка (сцена dungeon.tscn);
##   остальные двери всё ещё заперты (хоррор-диалог);
## - при возрождении героя ярость демона ГАСНЕТ (Game.reset_demon_rage):
##   демон снова мирен, счёт ударов обнулён, аура снята;
## - если убить демона НА КАРТЕ — Game.defeat_demon_permanently(): убитые
##   NPC оживают и забывают убийства (сигнал npcs_revived), демон больше
##   не возвращается (и как босс данжа 1 тоже — см. dungeon.gd);
## - демона больше нет и если он уже повержен: спавн у края мира
##   блокируется навсегда (Game.demon_gone_forever).
## Шаг 19: жители и демон чуть крупнее; удар — с видимым оружием и дугой,
## снаряды со свечением и следом; звук эффектов (Sfx) и тихий эмбиент
## (Silent Hill); демона можно убить — с него опыт (Game.DEMON_XP), у
## героя — уровни (урон и ХП удваиваются; HUD: полоса опыта, «УРОВЕНЬ N!»).
## Шаг 20 (полировка): звук мягче, эмбиент мелодичнее; кулдауны приёмов
## снижены; бег на
## Shift; удар по умолчанию на F, взаимодействие — на E; у каждого класса
## ТРЕТИЙ приём на T (special2): маг — выплеск магии (вся мана, 20×уровень,
## бьёт демона), бомж — передышка (полное ХП), рыцарь — град мечей.
## Шаг 22: у варвара на пробеле «Смертельный прыжок» (переехал с T;
## демон — «босс»: 200 + урон оружия), на T — новая ульта «Гнев титана»:
## 4 секунды герой огромен, урон не проходит, бьёт x4; дверь 3
## «Глубины Р'льеха» открывается после победы в Ските Пустоты (данж 3 —
## в бестиарии, шаг 20). Проданная торговцу экипировка попадает на его
## прилавок (Game.merchant_goods).
extends Node2D

const MAIN_SCENE := "res://scenes/main/main.tscn"
const DUNGEON_SCENE := "res://scenes/dungeon/dungeon.tscn"
const SPEED := 95.0
## Шаг 20: бег на Shift — быстрее в мире и в данже.
const RUN_MULT := 1.55
const COLOR_GOLD := Color(1, 0.84, 0)
const CHAR_W := 24
const CHAR_H := 32

## Шаг 10/11: экран ходьбы и консоль UI. Мир рендерится в SubViewport
## 360xWALK_H, вставленный в верхнюю часть экрана; нижние UI_BAR_H
## пикселей отданы нижней консоли: панель героя, кнопки действий и
## джойстик живут там и окружение не перекрывают. Шаг 11: консоль сжата
## с 148 до 112 px (кнопки 64x22, джойстик 100 px) — экран ходьбы вырос.
const UI_BAR_H := 112.0
const WALK_H := 640.0 - UI_BAR_H
## Геометрия консоли (в её локальных координатах, 360 x UI_BAR_H):
## слева джойстик 100 px, в центре панель героя, справа столбик кнопок.
const BAR_JOY_POS := Vector2(2, 6)
const BAR_HERO_POS := Vector2(110, 6)
const BAR_BUTTONS_X := 292.0
## Размер кнопок действий (шаг 11): подписи без клавиш — клавиши
## перечислены в подсказке у верхнего края экрана ходьбы.
const BAR_BTN_SIZE := Vector2(64, 22)
const BAR_BTN_STEP := 22.0   # шаг 21: кнопок четыре (МЕНЮ/СУМКА/СОХРАНИТЬ/ЗАГРУЗИТЬ)

## Реплики NPC (шаг 4; шаг 9/12 — лавкрафтовский космо-хоррор: замок висит
## над Пустотой уже тысячу лет, и жители давно перестали делать вид,
## что это нормально). Числа товаров в репликах совпадают с ItemDB.
const NPC_LINES := {
    "zlus": [
        "Рецепты приходят ко мне во сне. Я не сплю девятую ночь, но зелья готовы: лечение и мана, флаконы трёх размеров.",
        "Не заглядывай в котёл надолго. Он смотрит в ответ и запоминает лица. Малое зелье — 25 з., большое — 100.",
        "Верхние двери запечатаны не замком, а страхом. То, что спит за ними, видело тебя ещё до твоего рождения.",
    ],
    "lira": [
        "Добро пожаловать в замок, смертный. Он плывёт по Пустоте уже тысячу лет, и никто не помнит, куда мы плывём.",
        "Звёзды сегодня стоят неправильно. Я сверяла с картами: так они стояли в ночь, когда замок оторвался от земли.",
        "Это платье сшито из тьмы между звёздами. Мне больше ничего не снится. Тебе скоро тоже перестанет.",
    ],
    "glot": [
        "Пей, пока горло ещё твоё. Вода, морс, сок, пиво — всё, что удерживает тебя в этом мире.",
        "Чем дороже напиток, тем крепче он держит: вода 20 хп, морс 40, сок 60, пиво 100.",
        "Пиво даёт сто хп, но потом в затылке дышит кто-то другой. Это не похмелье. Не оборачивайся.",
    ],
    "zoran": [
        "Обычная сталь — к Вирасу. Магическое оружие и одеяния — ко мне: металлы шепчут мне имена прежних хозяев. Все они мертвы.",
        "Жезл молний — 1200 з. и 35 урона. Клинок инея — 2500 з. и 55: его раны не греются даже у костра. Скипетр кометы — 6000 з. и 110.",
        "Одеяния для мага висят справа: чем темнее ткань, тем больше маны она вмещает. Луну в окне я не вывешивал. Она пришла сама.",
    ],
    "gura": [
        "Кухня ещё заперта, но окорок готов: мясо зрело во тьме между звёздами. 10 золота — и оно твоё.",
        "Пиво не варю. Ножи не любят пьяных, а я не спорю с тем, что живёт в ящиках с ножами.",
        "Голодный слышит зов запертых дверей громче всех. Ешь, смертный. Пока еда ещё еда.",
    ],
    "viras": [
        "Меч — 1000, большой меч — 2000, моргенштерн — 5000. Каждый удар в моргенштерн уже вбит заранее. Как гвоздь. Как судьба.",
        "Горн дышит. Я кую всю жизнь и ни разу не видел пламени — только тень пламени, отброшенную из-за края мира.",
        "Теперь вью и доспехи: кожа 40 з., кольчуга 90, латы 180. Чем крепче железо на груди, тем дольше космос будет ждать твою душу.",
    ],
}
## Двери данжей (шаг 9; шаг 13): подписи с дверей убраны. Дверь 1 открыта:
## ведёт в Подземелье замка. Остальные заперты — клик или E рядом — сообщение.
const DOOR_LINES := [
    "Подземелье пока недоступно. Дверь запечатана изнутри — тем, что спит за ней. Это милосердие, а не замок.",
    "Прислушайся: иногда по ту сторону что-то скребётся в ответ на твои шаги. Сегодня оно молчит. Это хуже.",
]
const EDGE_HINT := "Край мира. Дальше — безграничный космос. Он давно смотрит в ответ, и тебе уже кажется, что ты узнал этот взгляд."
## Название двери в диалоге (шаг 9): клик или E рядом с запертой дверью.
const DOOR_NAME := "Дверь данжа"
const DOOR_ROLE := "Заперто"
## Дверь 2 (шаг 16): «Скит Пустоты» — открывается после победы над
## демоном в Подземелье замка. Пока данж 1 не пройден — заперта шёпотом.
const DOOR2_NAME := "Дверь скита"
const DOOR2_ROLE := "Заперто шёпотом"
const DOOR2_LOCKED_LINES := [
    "Дверь не заперта на замок — она заперта на шёпот. Тысячи голосов за ней бормочут на языке, которого не существует.",
    "«Замолчи», — говорят голоса, — «сначала замолчи тот, кто внизу. Подземелье замка ещё дышит».",
    "Пройди Подземелье замка до конца и поверь того, кто его хозяин. Тогда эта дверь услышит твои шаги и откроется.",
]
## Дверь 3 (шаг 20): «Глубины Р'льеха» — открывается после победы над
## Великим культистом в Ските Пустоты. Пока данж 2 не пройден, дверь
## спит тем же сном, что и спящий за ней.
const DOOR3_NAME := "Дверь глубин"
const DOOR3_ROLE := "Заперто сном"
const DOOR3_LOCKED_LINES := [
    "За этой дверью вода и звёзды одновременно. Изнутри доносится храп — такой, что дрожит ограда мира.",
    "«Ещё рано», — говорит сам сон. — «Сначала замолчи Скит Пустоты: его жрец ещё поёт». Пройди скит до конца.",
    "Когда верховный жрец умолкнет, дверь услышит твои шаги и откроется. Или её сорвёт с петель то, что спит.",
]
## Шаг 13: диалог открытой двери 1 (перед входом в данж — у двери свой голос).
const DOOR_OPEN_LINES := [
    "Эта дверь дышит. За ней — десять этажей вниз, и на каждом что-то шевелится.",
    "На самом дне ждёт тот, кто уже знает твоё имя. Лестницы открываются тишине: очисти зал — и путь вниз откроется.",
]
const DOOR_OPEN_ROLE := "Открыто"
## Дистанция до двери для E-взаимодействия (клик работает издалека).
const DOOR_INTERACT_RANGE := 44.0

## Параметры удара (шаг 7): дистанция до цели и кулдаун между ударами.
const STRIKE_RANGE := 28.0
const STRIKE_COOLDOWN := 0.4
## Шаг 19: жители чуть крупнее (визуал), демон — на 8% поверх своего х3.
const NPC_SIZE_MULT := 1.18
const DEMON_SIZE_MULT := 1.08
## Шаг 19: визуал удара — белая дуга slash_arc.png в цвет оружия.
const SLASH_TEX_PATH := "res://assets/sprites/fx/slash_arc.png"
## Шаг 19: эмбиент в мире тише, чем в подземелье (замок всё же «спокойнее»).
const AMBIENT_DB := -16.0

## Шаг 12: ярость демона. Порог ударов — в Game.DEMON_RAGE_HITS (3).
## Скорость преследования ниже скорости героя (SPEED 95) — убежать можно.
## DEMON_DAMAGE и дистанция когтей — ЗАГЛУШКИ, утверждает автор.
const DEMON_SPEED := 55.0
const DEMON_DAMAGE := 8
const DEMON_ATTACK_RANGE := 30.0
const DEMON_ATTACK_CD := 1.0
const DEMON_RAGE_TINT := Color(1.2, 0.45, 0.45)
## Демон считает удары вслух: после третьего следует ярость (сигнал Game).
const DEMON_HIT_HINTS := [
    "Демон шепчет: «Один...»",
    "Демон шепчет: «Два... ДВА!»",
]
const DEMON_ENRAGE_HINT := "Демон взревел! Три удара пробудили древнюю ярость: лавка закрыта, а сам он охотится на тебя."
## Реплики демона в ярости (шаг 12): лавки больше нет, только угрозы.
const DEMON_RAGE_LINES := [
    "Ты ударил меня. ТРИЖДЫ. Смертный, ты не понимаешь, чью руку поднял.",
    "Моя лавка закрыта. Милосердие кончилось. Сейчас я покажу тебе, что живёт между звёздами.",
    "Беги или стой — всё равно. Пустота уже держит твою тень за горло.",
]
## Текст экрана смерти (шаг 12, ЗАГЛУШКА: штрафов нет — автор утвердит позже).
const DEATH_TITLE := "ТЫ ПАЛ"
const DEATH_TEXT := "Космос равнодушно смотрел, как твоя тень растворилась между звёзд. Но замок ещё держит тебя в этом сне — и возвращать не собирается."
const DEATH_BUTTON := "ОЧНУТЬСЯ В ЗАМКЕ"
const RESPAWN_HINT := "Ты очнулся в замке. Демон забыл свою ярость — он снова мирен... пока что."
## Шаг 13: демон повержен НАВСЕГДА (на карте). Жертвы возвращаются к жизни.
const DEMON_DEFEATED_HINT := "Демон повержен! Убитые тобой жители вернулись в замок и ничего не помнят. Демон больше не вернётся — ни сюда, ни из глубины подземелья."
# Шаг 18: способности героев (параметры — в Game.ABILITIES; в мире
# действуют только на демона, бросок варвара не работает вовсе).
const AXE_TEX_PATH := "res://assets/sprites/dungeon/throwing_axe.png"
const DUST_HINT := "Горсть пыли в глаза: демон тебя не видит!"
const GAS_HINT := "Гнилой газ заполняет воздух."
## Шаг 22: «Гнев титана» варвара — форма с ростом спрайта.
const TITAN_HINT := "ГНЕВ ТИТАНА: урон не проходит, бьёшь в 4 раза сильнее!"
const TITAN_FADED_HINT := "Гнев титана угас."

## Реакция живых NPC на убийства (шаг 7; шаг 9/12 — тон жутче): id говорящего
## -> шаблон, %s заменяется на имена убитых (в винительном падеже).
## У торговцев при этом скрывается кнопка «ТОРГОВАТЬ» — они помнят.
const NPC_MURDER_REACTIONS := {
    "zlus": "Ты убил %s! Котёл замолчал навсегда. Теперь рецепты будут шептаться только о тебе.",
    "lira": "Ты убил %s... Звёзды отвернулись от замка. Даже Пустота осуждает тебя, смертный.",
    "glot": "Ты убил %s?! В моём зале убийце не нальют. Даже вода помнит вкус твоих рук.",
    "zoran": "Ты убил %s... Сталь почуяла кровь убийцы. Она не ляжет в твою руку, что бы ты ни платил.",
    "gura": "Ты убил %s?! Ножи всё видели. Ножи всё запомнили. Однажды они заговорят с тобой.",
    "viras": "Ты убил %s... Я не кую для убийц: металл ржавеет от одного твоего дыхания.",
}

## Имена убитых NPC в винительном падеже (для реплик остальных).
const NPC_VICTIM_ACC := {
    "zlus": "Злуса", "lira": "Лиру", "glot": "Глота",
    "zoran": "Зорана", "gura": "Гуру", "viras": "Вираса",
    "demon": "демона",
}

var _ground: TileMapLayer
var _entities: Node2D
var player: CharacterBody2D
var _player_sprite: AnimatedSprite2D
var _camera: Camera2D
var _joystick: Control = null
var _world: Node2D = null              # контент мира внутри SubViewport (шаг 10)
var _walk_holder: SubViewportContainer = null  # контейнер экрана ходьбы (шаг 11)
var _walk_view: SubViewport = null     # сам SubViewport экрана ходьбы (шаг 11)
var _hud_bar: Control = null           # нижняя консоль UI (шаг 10)
var _npcs: Array[Dictionary] = []
var _doors: Array[Dictionary] = []
var _hud_gold: Label
var _hud_hp: ProgressBar
var _hud_mana: ProgressBar
var _hud_xp: ProgressBar               # полоса опыта (шаг 19)
var _hud_weapon: Label
var _hud_hint: Label
var _dialogue: DialogueUI
var _inventory_ui: InventoryUI
var _trade_ui: TradeUI
var _dialogue_npc: Dictionary = {}   # данные NPC последнего открытого диалога

## Лямбды HUD хранятся отдельно: сигналы Game (автозагрузка) переживают
## смену сцены, поэтому в _exit_tree их нужно отвязать — иначе после ухода
## из мира мёртвая лямбда падает на первом же изменении золота/хп в данже.
var _cb_gold: Callable
var _cb_equipped: Callable
var _cb_hp: Callable
var _cb_mana: Callable
var _cb_xp: Callable                   # полоса опыта (шаг 19)
var _cb_level: Callable                # строка «имя · ур. N» (шаг 19)
var _anim_time := 0.0
var _facing := "down"
var _edge_hint_shown := false
var _hero_sheet_tex: Texture2D
var _shadow_tex: Texture2D
var _pointer_tex: Texture2D
var _bolt_tex: Texture2D
# --- шаг 6: заклинание мага и фиксы мигания ---
var _bolts: Array[Dictionary] = []       # летящие стрелы: {node, dir, left}
var _spell_cd := 0.0                     # кулдаун каста, сек
var _mana_regen_accum := 0.0             # накопитель регена маны
var _dialogue_closed_at := -10000        # msec, когда диалог закрылся
var _hint_tween: Tween
# --- шаг 7: удары и память NPC ---
var _strike_cd := 0.0                    # кулдаун удара, сек
# --- шаг 18: способности героев ---
var _q_cd := 0.0                        # кулдаун приёма Q (не-маги)
var _special_cd := 0.0                  # кулдаун приёма на пробеле
var _t_cd := 0.0                        # кулдаун приёма T (шаг 20)
var _sword_rain: Array[Dictionary] = [] # падающие мечи рыцаря (шаг 20)
var _leap_flight: Dictionary = {}       # полёт варвара на демона (шаг 20)
var _titan_big := false                 # шаг 22: спрайт вырос (гнев титана)
var _titan_base_scale := Vector2.ONE    # шаг 22: обычный размер спрайта
var _special_held := false              # приём-удержание активен (пробел зажат)
var _special_hold_left := 0.0           # сколько секунд удержания осталось
var _special_drain_accum := 0.0         # накопитель расхода маны барьера
var _hold_visual: Sprite2D = null       # круг барьера/щита (glow.png)
var _gas_clouds: Array[Dictionary] = []  # облака газа бомжа
var _ability_axe_tex: Texture2D = null
# --- шаг 8: Таинственный демон ---
var _demon_spawned := false              # демон появляется один раз за сессию
# --- шаг 11: удар по клику ЛКМ — время клика, который открыл диалог ---
# физпикинг может сработать позже gui_input: без метки клик по NPC
# успевал бы и ударить, и открыть диалог
var _click_dialog_at := -10000           # msec, когда клик открыл диалог
# --- шаг 12: ярость демона и смерть героя ---
var _player_dead := false                # экран смерти поверх мира
var _death_layer: CanvasLayer = null     # затемнение «ТЫ ПАЛ» (шаг 12)
# --- шаг 19: звук, видимое оружие и следы снарядов, праздник уровня ---
var _weapon_tex_cache := {}              # иконки оружия для видимого взмаха
var _slash_tex: Texture2D = null
var _level_layer: CanvasLayer = null

func _ready() -> void:
    _shadow_tex = load("res://assets/sprites/props/shadow.png")
    _pointer_tex = load("res://assets/sprites/props/pointer.png")
    _bolt_tex = load("res://assets/sprites/icons/magic_bolt.png")
    get_viewport().size_changed.connect(_resize_layout)
    _build_walk_screen()
    _build_background()
    _build_tiles()
    _build_entities()
    _build_props()
    _build_npcs()
    _build_doors()
    _build_player()
    _build_hud()
    _build_joystick()
    _build_death_ui()
    # шаг 8/9/13: демон следит за убийствами и выходит из теней строго после
    # первой жертвы — но только если он ещё не повержен навсегда.
    Game.npc_killed.connect(_on_npc_killed)
    if Game.demon_kill_count() > 0 and not Game.demon_gone_forever():
        _spawn_demon()   # сессия продолжается — демон уже ждёт у края
    # шаг 13: ожившие жертвы демона возвращаются на свои места
    Game.npcs_revived.connect(_revive_npcs_in_world)
    # шаг 12: ярость демона (третий удар) и смерть героя (хп до нуля)
    Game.demon_enraged_changed.connect(_on_demon_enraged)
    Game.hp_changed.connect(_on_player_hp_changed)
    _dialogue = DialogueUI.new()
    add_child(_dialogue)
    # шаг 11: диалоговая панель держится над консолью UI — резерв берётся
    # из её высоты, поэтому панель не уедет и за экран при любом контенте
    _dialogue.bottom_reserve = UI_BAR_H + 8.0
    _dialogue.trade_requested.connect(_on_trade_requested)
    _dialogue.closed.connect(_on_dialogue_closed)
    _inventory_ui = InventoryUI.new()
    add_child(_inventory_ui)
    _trade_ui = TradeUI.new()
    add_child(_trade_ui)
    for modal in [_dialogue, _inventory_ui, _trade_ui]:
        modal.visibility_changed.connect(_on_modal_visibility_changed)
    # шаг 19: дуга удара, тихий эмбиент мира и опыт героя
    _slash_tex = load(SLASH_TEX_PATH)
    Sfx.start_ambient(self, AMBIENT_DB)
    Game.level_up.connect(_on_level_up)
    Game.xp_changed.connect(_on_xp_changed)
    Platform.gameplay_start()

func _exit_tree() -> void:
    # шаг 18: неуязвимость/щит не переживают смену сцены
    Game.hero_immune = false
    Game.guard_active = false
    # шаг 19: эмбиент и сигналы опыта не переживают смену сцены
    Sfx.stop_ambient()
    if Game.level_up.is_connected(_on_level_up):
        Game.level_up.disconnect(_on_level_up)
    if Game.xp_changed.is_connected(_on_xp_changed):
        Game.xp_changed.disconnect(_on_xp_changed)
    if Controls.bindings_changed.is_connected(_refresh_controls_hint):
        Controls.bindings_changed.disconnect(_refresh_controls_hint)
    Platform.gameplay_stop()
    _disconnect_cb(Game.gold_changed, _cb_gold)
    _disconnect_cb(Game.equipped_changed, _cb_equipped)
    _disconnect_cb(Game.hp_changed, _cb_hp)
    _disconnect_cb(Game.mana_changed, _cb_mana)
    # Шаг 23: полоса опыта и строка уровня ТОЖЕ лямбды на сигналах Game —
    # без отвязки они переживали free() сцены и сыпали «Lambda capture
    # ... was freed» при каждом изменении опыта/уровня.
    _disconnect_cb(Game.xp_changed, _cb_xp)
    _disconnect_cb(Game.level_up, _cb_level)
    if Game.npc_killed.is_connected(_on_npc_killed):
        Game.npc_killed.disconnect(_on_npc_killed)
    if Game.npcs_revived.is_connected(_revive_npcs_in_world):
        Game.npcs_revived.disconnect(_revive_npcs_in_world)
    if Game.demon_enraged_changed.is_connected(_on_demon_enraged):
        Game.demon_enraged_changed.disconnect(_on_demon_enraged)
    if Game.hp_changed.is_connected(_on_player_hp_changed):
        Game.hp_changed.disconnect(_on_player_hp_changed)

## Отвязать лямбду HUD от сигнала Game (если была привязана).
func _disconnect_cb(sig: Signal, cb: Callable) -> void:
    if not cb.is_null() and sig.is_connected(cb):
        sig.disconnect(cb)

# ----------------------------------------------------------- экран ходьбы

## Шаг 10/11: мир живёт в SubViewport 360xWALK_H, вставленном контейнером в
## верхнюю часть экрана. Вся нижняя полоса отдана консоли UI, поэтому
## интерфейс физически не может перекрыть окружение. Клики по NPC и
## дверям работают внутри SubViewport: physics_object_picking включён,
## ввод в него пробрасывает SubViewportContainer (область 360xWALK_H).
## The container routes mapped mouse commands via gui_input; Area2D keeps LMB picking.
func _build_walk_screen() -> void:
    var holder := SubViewportContainer.new()
    holder.name = "WalkScreen"
    holder.stretch = true
    holder.position = Vector2.ZERO
    holder.size = get_viewport_rect().size - Vector2(0, UI_BAR_H)
    holder.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
    var walk_view := SubViewport.new()
    walk_view.name = "WalkViewport"
    walk_view.disable_3d = true
    walk_view.canvas_item_default_texture_filter = \
        Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST
    walk_view.snap_2d_transforms_to_pixel = true
    walk_view.physics_object_picking = true
    holder.add_child(walk_view)
    add_child(holder)
    _walk_holder = holder
    _walk_view = walk_view
    # Route all mapped mouse buttons, preserving object picking.
    holder.gui_input.connect(_on_walk_click)
    _world = Node2D.new()
    _world.name = "WorldContent"
    walk_view.add_child(_world)

# ---------------------------------------------------------------- космос

func _build_background() -> void:
    var parallax := ParallaxBackground.new()
    for config in [
        {"tex": "res://assets/backgrounds/stars_far.png", "scale": Vector2(0.12, 0.12)},
        {"tex": "res://assets/backgrounds/stars_near.png", "scale": Vector2(0.3, 0.3)},
    ]:
        var layer := ParallaxLayer.new()
        layer.motion_scale = config["scale"]
        layer.motion_mirroring = Vector2(360, 640)
        var spr := Sprite2D.new()
        spr.texture = load(config["tex"])
        spr.centered = false
        layer.add_child(spr)
        parallax.add_child(layer)
    _world.add_child(parallax)

# ---------------------------------------------------------------- тайлы

func _build_tiles() -> void:
    var atlas_tex: Texture2D = load("res://assets/tilesets/world_tiles.png")
    var tileset := TileSet.new()
    tileset.tile_size = Vector2i(WorldMap.TILE_SIZE, WorldMap.TILE_SIZE)
    tileset.add_physics_layer()
    tileset.set_physics_layer_collision_layer(0, 1)
    var source := TileSetAtlasSource.new()
    source.texture = atlas_tex
    source.texture_region_size = Vector2i(WorldMap.TILE_SIZE, WorldMap.TILE_SIZE)
    var source_id := tileset.add_source(source)
    var half := WorldMap.TILE_SIZE / 2.0
    var square := PackedVector2Array([
        Vector2(-half, -half), Vector2(half, -half),
        Vector2(half, half), Vector2(-half, half),
    ])
    for symbol in WorldMap.TILE_ATLAS:
        var coords: Vector2i = WorldMap.TILE_ATLAS[symbol]
        source.create_tile(coords)
        if WorldMap.SOLID_TILES.contains(symbol):
            var data := source.get_tile_data(coords, 0)
            data.add_collision_polygon(0)
            data.set_collision_polygon_points(0, 0, square)

    _ground = TileMapLayer.new()
    _ground.name = "Ground"
    _ground.tile_set = tileset
    _world.add_child(_ground)
    for y in WorldMap.MAP_H:
        for x in WorldMap.MAP_W:
            var symbol: String = WorldMap.MAP[y][x]
            _ground.set_cell(Vector2i(x, y), source_id, WorldMap.TILE_ATLAS[symbol])

# ---------------------------------------------------------------- сущности (y-sort)

func _build_entities() -> void:
    _entities = Node2D.new()
    _entities.name = "Entities"
    _entities.y_sort_enabled = true
    _world.add_child(_entities)

## Позиция сущности у «ног» (для честной y-сортировки глубины).
func _feet_pos(tile: Vector2, w: int, h: int) -> Vector2:
    return Vector2(tile.x * 16.0 + w * 8.0, (tile.y + h) * 16.0 - 3.0)

func _add_shadow(parent: Node2D, width_scale: float = 1.0) -> void:
    var sh := Sprite2D.new()
    sh.texture = _shadow_tex
    sh.position = Vector2(0, 2)
    sh.scale = Vector2(width_scale, 1.0)
    parent.add_child(sh)

func _make_frames(tex: Texture2D, fw: int = CHAR_W, fh: int = CHAR_H) -> SpriteFrames:
    var frames := SpriteFrames.new()
    frames.remove_animation("default")
    var rows := [
        ["idle_down", 0, 6, 3.0], ["idle_side", 1, 6, 3.0], ["idle_up", 2, 6, 3.0],
        ["walk_down", 3, 4, 7.0], ["walk_side", 4, 4, 7.0], ["walk_up", 5, 4, 7.0],
    ]
    for r in rows:
        var anim: String = r[0]
        frames.add_animation(anim)
        frames.set_animation_speed(anim, r[3])
        frames.set_animation_loop(anim, true)
        for i in range(int(r[2])):
            var at := AtlasTexture.new()
            at.atlas = tex
            at.region = Rect2(i * fw, int(r[1]) * fh, fw, fh)
            frames.add_frame(anim, at)
    return frames

# ---------------------------------------------------------------- пропы

func _build_props() -> void:
    for prop in WorldMap.PROPS:
        var w: int = prop["w"]
        var h: int = prop["h"]
        var pos := _feet_pos(prop["tile"], w, h)
        var node := Node2D.new()
        node.name = "Prop_%s" % prop["name"]
        node.position = pos
        _entities.add_child(node)

        var visual: Node2D
        if prop.has("anim"):
            var anim_info: Array = prop["anim"]
            var spr := AnimatedSprite2D.new()
            var frames := SpriteFrames.new()
            frames.remove_animation("default")
            frames.add_animation("idle")
            frames.set_animation_speed("idle", anim_info[2])
            frames.set_animation_loop("idle", true)
            for i in range(int(anim_info[1])):
                var variant_tex: Texture2D = load("%s_%d.png" % [anim_info[0], i])
                frames.add_frame("idle", variant_tex)
            spr.sprite_frames = frames
            spr.play("idle")
            visual = spr
        else:
            var spr := Sprite2D.new()
            spr.texture = load(String(prop["texture"]))
            visual = spr
        var visual_h: float
        if visual is AnimatedSprite2D:
            visual_h = (visual as AnimatedSprite2D).sprite_frames \
                .get_frame_texture("idle", 0).get_height()
        else:
            visual_h = (visual as Sprite2D).texture.get_height()
        visual.position = Vector2(0, -(visual_h / 2.0) + 3.0)
        node.add_child(visual)

        # орбита луны вокруг планеты
        if prop["name"] == "planet":
            var moon := Node2D.new()
            var moon_spr := Sprite2D.new()
            moon_spr.texture = load("res://assets/sprites/props/moon.png")
            moon_spr.position = Vector2(44, 0)
            moon.add_child(moon_spr)
            node.add_child(moon)
            var tw := create_tween().set_loops()
            tw.tween_property(moon, "rotation", TAU, 14.0).from(0.0)

        # покачивание парящих островов и астероидов
        if prop.has("bob"):
            var bob: Vector2 = prop["bob"]
            var tw := create_tween().set_loops()
            tw.tween_property(visual, "position:y",
                visual.position.y - bob.x, bob.y) \
                .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
            tw.tween_property(visual, "position:y", visual.position.y, bob.y) \
                .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

        if bool(prop["solid"]):
            var body := StaticBody2D.new()
            body.collision_layer = 1
            body.collision_mask = 0
            var shape := CollisionShape2D.new()
            var rect := RectangleShape2D.new()
            rect.size = Vector2(w * 16.0 - 4.0, 10.0)
            shape.shape = rect
            shape.position = Vector2(0, -4)
            body.add_child(shape)
            node.add_child(body)

# ---------------------------------------------------------------- NPC

func _build_npcs() -> void:
    for npc_data in WorldMap.NPCS:
        if bool(npc_data.get("demon", false)):
            continue   # шаг 8: демон появляется только после первого убийства
        _spawn_npc(npc_data)

## Создать узел NPC по данным из WorldMap.NPCS и добавить его в мир.
## scale (шаг 8) — во сколько раз NPC крупнее обычного (демон втрое крупнее):
## кадры листа 24x32 * scale, крупнее тело, зона клика, имя и полоска хп.
func _spawn_npc(npc_data: Dictionary) -> Dictionary:
    var npc_id: String = npc_data["id"]
    var s := maxi(1, int(npc_data.get("scale", 1)))
    var fw := CHAR_W * s
    var fh := CHAR_H * s
    var pos := _feet_pos(npc_data["tile"], 1, 1)
    var node := Node2D.new()
    node.name = "NPC_%s" % npc_id
    node.position = pos

    _add_shadow(node, 0.9 * s)
    var spr := AnimatedSprite2D.new()
    var tex: Texture2D = load(String(npc_data["sheet"]))
    spr.sprite_frames = _make_frames(tex, fw, fh)
    spr.position = Vector2(0, -fh / 2.0 + 3.0)
    # шаг 19: жители чуть крупнее, демон — на 8% поверх своих трёх
    spr.scale = Vector2(DEMON_SIZE_MULT, DEMON_SIZE_MULT) if s > 1 \
        else Vector2(NPC_SIZE_MULT, NPC_SIZE_MULT)
    spr.play("idle_down")
    node.add_child(spr)

    # Небольшое тело, чтобы нельзя было пройти сквозь NPC.
    var body := StaticBody2D.new()
    body.collision_layer = 1
    body.collision_mask = 0
    var body_shape := CollisionShape2D.new()
    var circle := CircleShape2D.new()
    circle.radius = 5.0 * s
    body_shape.shape = circle
    body_shape.position = Vector2(0, -2)
    body.add_child(body_shape)
    node.add_child(body)

    var area := Area2D.new()
    area.input_pickable = true
    area.collision_layer = 4
    area.collision_mask = 0
    var area_shape := CollisionShape2D.new()
    var rect := RectangleShape2D.new()
    rect.size = Vector2(18.0 * s, 24.0 * s)
    area_shape.shape = rect
    area_shape.position = Vector2(0, -10.0 * s)
    area.add_child(area_shape)
    area.input_event.connect(_on_npc_input.bind(npc_id))
    node.add_child(area)

    var name_label := Label.new()
    name_label.text = "%s · %s" % [npc_data["name"], npc_data["role"]]
    name_label.position = Vector2(-66.0 * s, -fh - 14)
    name_label.size = Vector2(132.0 * s, 12)
    name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    name_label.add_theme_font_size_override("font_size", 9)
    name_label.add_theme_color_override("font_color", COLOR_GOLD)
    name_label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.7))
    name_label.add_theme_constant_override("shadow_offset_y", 1)
    node.add_child(name_label)

    # шаг 7: полоска хп NPC над головой — видна после первого урона
    var npc_hp := maxi(1, int(npc_data.get("hp", 1)))
    var hp_bar := ProgressBar.new()
    hp_bar.min_value = 0
    hp_bar.max_value = npc_hp
    hp_bar.value = npc_hp
    hp_bar.show_percentage = false
    hp_bar.custom_minimum_size = Vector2(24.0 * s, 4)
    hp_bar.size = Vector2(24.0 * s, 4)
    hp_bar.position = Vector2(-12.0 * s, -fh - 4)
    hp_bar.visible = false
    hp_bar.add_theme_stylebox_override("background",
        _bar_style(Color(0.09, 0.08, 0.1), Color(0.4, 0.18, 0.18)))
    hp_bar.add_theme_stylebox_override("fill",
        _bar_style(Color(0.72, 0.26, 0.26), Color(0.72, 0.26, 0.26)))
    node.add_child(hp_bar)

    # золотой указатель: появляется, когда игрок рядом
    var pointer := Sprite2D.new()
    pointer.texture = _pointer_tex
    pointer.position = Vector2(0, -fh - 10)
    pointer.visible = false
    node.add_child(pointer)
    var ptw := create_tween().set_loops()
    ptw.tween_property(pointer, "position:y", -float(fh) - 14.0, 0.5) \
        .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
    ptw.tween_property(pointer, "position:y", -float(fh) - 10.0, 0.5) \
        .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

    _entities.add_child(node)
    var npc := {"id": npc_id, "node": node, "sprite": spr, "pointer": pointer,
                "tile": npc_data["tile"], "zone": npc_data["zone"],
                "data": npc_data, "hp": npc_hp, "max_hp": npc_hp,
                "hp_bar": hp_bar, "body": body, "area": area,
                "name_label": name_label, "dead": false}
    _npcs.append(npc)
    return npc

# ------------------------------------------------------------- демон (шаг 8)

## Определение демона из WorldMap.NPCS (пустой словарь — не задан).
func _demon_def() -> Dictionary:
    for npc_data in WorldMap.NPCS:
        if bool(npc_data.get("demon", false)):
            return npc_data
    return {}

## Таинственный демон выходит из теней у края улицы: строго после первой
## жертвы (см. _on_npc_killed и проверку Game.demon_kill_count в _ready).
## При продолжении сессии (мир пересобран) встаёт на место молча.
func _spawn_demon() -> void:
    if _demon_spawned:
        return
    # шаг 13: демон, поверженный навсегда, не возвращается — даже если
    # убить нового жителя после его смерти в подземелье.
    if Game.demon_gone_forever():
        return
    var def := _demon_def()
    if def.is_empty():
        return
    _demon_spawned = true
    var npc := _spawn_npc(def)
    var node: Node2D = npc["node"]
    _spell_poof(node.position + Vector2(0, -46), Color(0.62, 0.4, 0.9))
    _show_hint("У самого края улицы из теней выступил Таинственный демон — втрое выше любого из жителей. Он доволен тем, что ты уже сделал.", 5.0)

## NPC убит: демон материализуется у края мира — но только когда жертвой
## стал житель (демон сам в подсчёте не участвует).
func _on_npc_killed(_npc_id: String) -> void:
    if not _demon_spawned and Game.demon_kill_count() > 0:
        # отложенно: спавн не должен срабатывать внутри сигнала об убийстве
        call_deferred("_spawn_demon")

## Шаг 12/13: демон впал в ярость (сигнал Game) — красная аура, вспышка,
## подсказка. Если сигнал пришёл при ПОГАШЕННОЙ ярости (возрождение героя
## или его смерть) — аура снимается, демон возвращается на своё место
## у края улицы и снова становится мирным.
func _on_demon_enraged() -> void:
    var demon := _demon_record()
    if demon.is_empty():
        return
    var node: Node2D = demon["node"]
    if Game.demon_enraged:
        (demon["sprite"] as AnimatedSprite2D).modulate = DEMON_RAGE_TINT
        _spell_poof(node.position + Vector2(0, -46), Color(0.85, 0.25, 0.2))
        _show_hint(DEMON_ENRAGE_HINT, 4.5)
    else:
        (demon["sprite"] as AnimatedSprite2D).modulate = Color.WHITE
        var def := _demon_def()
        if not def.is_empty():
            node.position = _feet_pos(def["tile"], 1, 1)
        demon["atk_cd"] = 0.0

## Запись живого демона в мире (пустой словарь — не спавнен или мёртв).
func _demon_record() -> Dictionary:
    for npc in _npcs:
        if String(npc["id"]) == "demon" and not bool(npc.get("dead", false)):
            return npc
    return {}

func _on_npc_input(_viewport: Node, event: InputEvent, _shape_idx: int, npc_id: String) -> void:
    if _gameplay_input_blocked():
        return
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        _click_dialog_at = Time.get_ticks_msec()   # шаг 11: этот клик — не удар
        npc_say(npc_id)

# ------------------------------------------------- удар по клику (шаг 11)

## Клик ЛКМ по экрану ходьбы (ловится в gui_input контейнера SubViewport).
## Клик по NPC или двери не бьёт — он открывает диалог/сообщение: точка
## клика проверяется по тем же прямоугольникам, что и их зоны кликов.
## The container supplies local SubViewport coordinates. Do not accept the
## event here: Area2D picking must still receive pointer interactions.
func _on_walk_click(event: InputEvent) -> void:
    if not event is InputEventMouseButton or not event.pressed:
        return
    if _gameplay_input_blocked():
        return
    var position := (event as InputEventMouseButton).position
    var world_pos := _walk_pos_to_world(position)
    if not world_pos.is_finite():
        return
    # Picking may run later than gui_input. Test geometry before any command,
    # including magic/inventory/interact, so LMB objects always have priority.
    if event.button_index == MOUSE_BUTTON_LEFT and _point_on_interactive(world_pos):
        return
    _handle_gameplay_input(event, position)

func _try_click_strike(view_pos: Vector2) -> void:
    if _dialogue.visible or _inventory_ui.visible or _trade_ui.visible \
            or _player_dead:
        return
    if player == null:
        return
    if Time.get_ticks_msec() - _click_dialog_at <= 100:
        return   # этот же клик уже открыл диалог через физпикинг
    var world_pos := _walk_pos_to_world(view_pos)
    if not world_pos.is_finite() or _point_on_interactive(world_pos):
        return
    _strike()

## Точка клика в координатах мира (локальные координаты контейнера —
## это координаты SubViewport, камера живёт внутри него же).
func _walk_pos_to_world(view_pos: Vector2) -> Vector2:
    if _walk_view == null:
        return Vector2.INF
    return _walk_view.get_canvas_transform().affine_inverse() * view_pos

## Есть ли под точкой интерактивный объект: живой NPC или дверь данжа.
## NPC — через _npc_at_point (те же прямоугольники, что и у снаряда),
## дверь — по прямоугольнику зоны клика из _build_doors.
func _point_on_interactive(pos: Vector2) -> bool:
    if not _npc_at_point(pos).is_empty():
        return true
    for door in _doors:
        var half: Vector2 = door["half"]
        var dnode: Node2D = door["node"]
        if absf(pos.x - dnode.position.x) <= half.x \
                and absf(pos.y - dnode.position.y) <= half.y:
            return true
    return false

## Открыть диалог с NPC (публично: используется и тестами).
## Мёртвый NPC молчит (труп не разговаривает и не торгует).
## Шаг 8: если в этой сессии герой уже кого-то убил, у живых NPC старые
## диалоги пропадают — остаётся только реплика про убийство, и торговать
## с ними больше нельзя. Демон же убийцу приветствует и сам зовёт торговать.
func npc_say(npc_id: String) -> void:
    for npc in _npcs:
        if npc["id"] != npc_id:
            continue
        if bool(npc.get("dead", false)) or Game.is_npc_dead(npc_id):
            return
        var data: Dictionary = npc["data"]
        _dialogue_npc = data
        var lines: Array
        var goods: Array
        if bool(data.get("demon", false)):
            # демон: до ярости радуется убийству жителей и зовёт к своей лавке.
            # Шаг 13: разговор с демоном — «мы видели демона»: босс данжа 1
            # по этому флагу узнаёт героя.
            Game.mark_demon_seen()
            # Ассортимент динамический — товары павших торговцев, поэтому
            # для лавки кладём его прямо в словарь торговца (TradeUI
            # читает goods из данных торговца).
            # Шаг 12: в ярости лавки нет — только угрозы.
            _dialogue_npc = data.duplicate()
            if Game.demon_enraged:
                (_dialogue_npc as Dictionary)["role"] = "разбуженная ярость"
                (_dialogue_npc as Dictionary)["goods"] = []
                lines = DEMON_RAGE_LINES.duplicate()
                goods = []
            else:
                (_dialogue_npc as Dictionary)["goods"] = Game.demon_goods()
                lines = _demon_lines()
                goods = Game.demon_goods()
        else:
            lines = NPC_LINES.get(npc_id, ["..."])
            if not Game.dead_npcs.is_empty():
                # шаг 8: старые диалоги больше не появятся — только память
                # об убийстве; торговцы отказываются торговать с убийцей
                lines = [_murder_reaction(npc_id)]
                goods = []
            else:
                # шаг 22: прилавок = базовый товар + то, что герой продал
                # торговцу этого профиля (смотря что это и какой торговец)
                goods = Game.merchant_goods(String(data.get("id", "")))
        _dialogue.open({
            "name": data["name"],
            "role": data["role"],
            "portrait": data["portrait"],
            "lines": lines,
            "goods": goods,
        })
        (npc["sprite"] as AnimatedSprite2D).play("idle_down")
        return

## Реплики живого NPC про убитых героем: имена подставляются
## в винительном падеже (см. NPC_VICTIM_ACC).
func _murder_reaction(speaker_id: String) -> String:
    var victims: Array[String] = []
    for victim_id in Game.dead_npcs:
        victims.append(String(NPC_VICTIM_ACC.get(String(victim_id), String(victim_id))))
    var template: String = NPC_MURDER_REACTIONS.get(speaker_id, "Ты убил %s!")
    return template % ", ".join(victims)

## Реплики демона (шаг 8; шаг 9/12 — лавкрафтовский хоррор): рад убийству
## жителей, перечисляет жертв, хвастается лавкой из товаров павших и зовёт
## убивать ещё — каждая новая жертва дешевит его лавку ещё на 10%.
## (В ярости реплики другие — DEMON_RAGE_LINES, см. npc_say.)
func _demon_lines() -> Array:
    var lines: Array = []
    var victims: Array[String] = []
    for victim_id in Game.dead_npcs:
        var vid := String(victim_id)
        if vid != "demon":
            victims.append(String(NPC_VICTIM_ACC.get(vid, vid)))
    lines.append("Хе-хе-хе! Я чую это с края мира: смертный остыл — и это сделал ты. Пустота аплодирует стоя.")
    if not victims.is_empty():
        lines.append("Ты убил %s. Я всё видел отсюда: их тени уже переползли через ограду и ползут ко мне. Теперь они мои." % ", ".join(victims))
    if Game.demon_goods().is_empty():
        lines.append("Пока мне нечего тебе продать. Убей торговца — его лавка переедет ко мне. Вместе с ценами. Вместе с голосом.")
    else:
        lines.append("Товары павших торговцев теперь мои. И дешевле, чем у них были: скидка %d%%. Мёртвые не торгуются." % Game.demon_discount_pct())
    lines.append("Убей ещё жителя — и цены упадут ещё на десять процентов. Каждая новая тень делает мой товар щедрее.")
    return lines

## Кнопка «ТОРГОВАТЬ» в диалоге: закрываем реплики и открываем лавку.
func _on_trade_requested() -> void:
    _dialogue.close()
    if not _dialogue_npc.is_empty():
        _trade_ui.open(_dialogue_npc)

## Диалог закрылся: запоминаем время — ближайшие 250 мс мир не реагирует
## на E, чтобы то же нажатие не переоткрыло диалог (фикс мигания).
func _on_dialogue_closed() -> void:
    _dialogue_closed_at = Time.get_ticks_msec()

## Разрешено ли сейчас взаимодействие E (вне кулдауна после закрытия диалога).
func _interact_allowed() -> bool:
    return Time.get_ticks_msec() - _dialogue_closed_at > 250

# ---------------------------------------------------------------- двери данжей

## Явные двери данжей (шаг 9; шаг 13): каменные створки с фиолетовым зевом
## (props/door_dungeon.png) поверх тайлов D. Подписи убраны — двери говорят
## сами за себя. Дверь 1 открыта: ведёт в Подземелье замка; остальные
## заперты — клик или E рядом — диалог «Подземелье пока недоступно».
func _build_doors() -> void:
    var door_tex: Texture2D = load("res://assets/sprites/props/door_dungeon.png")
    for i in range(WorldMap.DOORS.size()):
        var door: Dictionary = WorldMap.DOORS[i]
        var tiles: Array = door["tiles"]
        var center := Vector2.ZERO
        for t in tiles:
            center += Vector2(t) * float(WorldMap.TILE_SIZE) + Vector2(8, 8)
        center /= float(tiles.size())
        var node := Node2D.new()
        node.name = "Door_%s" % door["id"]
        node.position = center
        # видимые створки: спрайт 32x16 ровно накрывает два тайла двери
        var spr := Sprite2D.new()
        spr.name = "Sprite"
        spr.texture = door_tex
        node.add_child(spr)
        # клик по двери — диалог: дверь 1 ведёт в данж, остальные молчат
        var area := Area2D.new()
        area.input_pickable = true
        area.collision_layer = 4
        area.collision_mask = 0
        var shape := CollisionShape2D.new()
        var rect := RectangleShape2D.new()
        rect.size = Vector2(tiles.size() * 16.0, 16.0)
        shape.shape = rect
        area.add_child(shape)
        area.input_event.connect(_on_door_input.bind(String(door["id"])))
        node.add_child(area)
        _world.add_child(node)
        _doors.append({"id": String(door["id"]), "area": area, "node": node,
            "half": Vector2(tiles.size() * 8.0, 8.0)})

## Клик по двери данжа.
func _on_door_input(_viewport: Node, event: InputEvent, _shape_idx: int,
        door_id: String) -> void:
    if _gameplay_input_blocked():
        return
    if event is InputEventMouseButton and event.pressed \
            and event.button_index == MOUSE_BUTTON_LEFT:
        _click_dialog_at = Time.get_ticks_msec()   # шаг 11: этот клик — не удар
        _open_door_dialog(door_id)

## Сообщение двери (шаги 13/16): дверь 1 открыта — «Подземелье замка»;
## дверь 2 «Скит Пустоты» открывается после победы над демоном; 3–4 пока
## заперты (подземелья 3-4 появятся позже).
func _open_door_dialog(door_id: String = "") -> void:
    if _dialogue.visible:
        return
    if door_id == "dungeon_1":
        _begin_dungeon_transition("dungeon_1")
        return
    if door_id == "dungeon_2":
        if Game.dungeons_cleared.has("dungeon_1"):
            _begin_dungeon_transition("dungeon_2")
            return
        _dialogue.open({
            "name": DOOR2_NAME,
            "role": DOOR2_ROLE,
            "portrait": "res://assets/sprites/portraits/door.png",
            "lines": DOOR2_LOCKED_LINES,
        })
        return
    if door_id == "dungeon_3":
        # шаг 20: третье подземелье — после победы над Великим культистом
        if Game.dungeons_cleared.has("dungeon_2"):
            _begin_dungeon_transition("dungeon_3")
            return
        _dialogue.open({
            "name": DOOR3_NAME,
            "role": DOOR3_ROLE,
            "portrait": "res://assets/sprites/portraits/door.png",
            "lines": DOOR3_LOCKED_LINES,
        })
        return
    _dialogue.open({
        "name": DOOR_NAME,
        "role": DOOR_ROLE,
        "portrait": "res://assets/sprites/portraits/door.png",
        "lines": DOOR_LINES,
    })

## Шаги 13/16: вход в подземелье. Фиксируем данж и этаж, меняем сцену;
## сам данж генерирует этажи заново (см. dungeon.gd).
func _begin_dungeon_transition(dungeon_id: String = "dungeon_1") -> void:
    # маршрут фиксируем всегда: повторный клик по той же двери безопасен,
    # а защитный флаг ниже лишь мешает запустить смену сцены дважды
    Game.current_dungeon = dungeon_id
    if Game.dungeon_floor > 0:
        return   # уже переходим
    Game.dungeon_floor = 1
    Platform.gameplay_stop()
    get_tree().change_scene_to_file(DUNGEON_SCENE)

# ---------------------------------------------------------------- игрок

func _build_player() -> void:
    _apply_hero_textures()
    player = CharacterBody2D.new()
    player.name = "Player"
    player.motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
    player.collision_layer = 2
    player.collision_mask = 1
    player.position = Vector2(WorldMap.PLAYER_SPAWN) * float(WorldMap.TILE_SIZE) + Vector2(8, 8)
    _entities.add_child(player)

    var shape := CollisionShape2D.new()
    var circle := CircleShape2D.new()
    circle.radius = 5.0
    shape.shape = circle
    shape.position = Vector2(0, 3)
    player.add_child(shape)

    _add_shadow(player, 0.9)
    _player_sprite = AnimatedSprite2D.new()
    _player_sprite.sprite_frames = _make_frames(_hero_sheet_tex)
    _player_sprite.position = Vector2(0, -CHAR_H / 2.0 + 3.0)
    _player_sprite.play("idle_down")
    player.add_child(_player_sprite)

    _camera = Camera2D.new()
    _camera.limit_left = 0
    _camera.limit_top = 0
    _camera.limit_right = WorldMap.MAP_W * WorldMap.TILE_SIZE
    _camera.limit_bottom = WorldMap.MAP_H * WorldMap.TILE_SIZE
    _camera.position_smoothing_enabled = true
    _camera.position_smoothing_speed = 6.0
    player.add_child(_camera)
    _camera.make_current()

## Подставить лист анимаций выбранного героя (публично: используется тестами).
func _apply_hero_textures() -> void:
    var hero: Dictionary = Game.HEROES.get(Game.hero_id, Game.HEROES[Game.DEFAULT_HERO])
    _hero_sheet_tex = load(String(hero["sheet"]))
    if _player_sprite != null:
        _player_sprite.sprite_frames = _make_frames(_hero_sheet_tex)
        _player_sprite.play("idle_down")

func _physics_process(delta: float) -> void:
    if player == null:
        return
    var moving := false
    var dir := Vector2.ZERO
    var blocked := _dialogue.visible or _inventory_ui.visible \
        or _trade_ui.visible or _player_dead or not _leap_flight.is_empty()
    if not blocked:
        if _blocked_movement_inputs.is_empty():
            dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
        var joy_vec := _joystick_output()
        if joy_vec.length() > 0.15:
            dir = (dir + joy_vec).limit_length(1.0)
        moving = dir.length() > 0.05
        # шаг 18: щит воина замедляет шаг; шаг 20: Shift — бег
        # (бег не отменяет штраф щита: под щитом бегать нельзя)
        var move_speed := SPEED
        if Game.guard_active:
            move_speed *= float(Game.ability_info("special").get("speed_mult", 0.5))
        elif Input.is_action_pressed("run"):
            move_speed *= RUN_MULT
        player.velocity = dir * move_speed
        player.move_and_slide()
        if not _edge_hint_shown and player.position.y > 43.0 * WorldMap.TILE_SIZE:
            _edge_hint_shown = true
            _show_hint(EDGE_HINT, 4.5)
    else:
        player.velocity = Vector2.ZERO
    # шаг 6: мана мага — кулдаун заклинания, реген, полёт снарядов
    if _spell_cd > 0.0:
        _spell_cd = maxf(0.0, _spell_cd - delta)
    if Game.is_mage() and Game.mana < Game.max_mana():
        _mana_regen_accum += delta
        if _mana_regen_accum >= 1.0:
            Game.regen_mana(int(Game.SPELL["regen_per_sec"]) * int(_mana_regen_accum))
            _mana_regen_accum = 0.0
    else:
        _mana_regen_accum = 0.0
    # шаг 7: кулдаун удара
    if _strike_cd > 0.0:
        _strike_cd = maxf(0.0, _strike_cd - delta)
    # шаг 18: кулдауны приёмов, удержания, облака газа
    if _q_cd > 0.0:
        _q_cd = maxf(0.0, _q_cd - delta)
    if _special_cd > 0.0:
        _special_cd = maxf(0.0, _special_cd - delta)
    if _t_cd > 0.0:
        _t_cd = maxf(0.0, _t_cd - delta)
    _update_special_hold(delta)
    _update_sword_rain(delta)
    _update_leap_flight(delta)
    _update_titan(delta)
    _update_gas(delta)
    _update_bolts(delta)
    _update_walk_anim(delta, moving, dir)
    _update_pointers()
    # шаг 12: разъярённый демон охотится на героя
    _update_demon(delta)

## Шаг 12: ИИ разъярённого демона. Демон парит к герою (стены и ограда
## его держат — точки-проверки по тайлам), а вплотную бьёт когтями:
## урон Game.damage_hp(DEMON_DAMAGE) раз в DEMON_ATTACK_CD секунд.
## Атака продолжается и при открытых окнах — это бой, а не экскурсия.
func _update_demon(delta: float) -> void:
    if player == null or not Game.demon_enraged or Game.hp <= 0:
        return
    var demon := _demon_record()
    if demon.is_empty():
        return
    var node: Node2D = demon["node"]
    var spr: AnimatedSprite2D = demon["sprite"]
    # шаг 18: ослеплён пылью бомжа — не видит героя, не гонится и не бьёт
    if int(demon.get("blind_until", 0)) > Time.get_ticks_msec():
        spr.play("idle_down")
        return
    var to := player.position - node.position
    demon["atk_cd"] = maxf(0.0, float(demon.get("atk_cd", 0.0)) - delta)
    if to.length() > DEMON_ATTACK_RANGE * 0.8:
        var dirv := to.normalized()
        var step := DEMON_SPEED * delta
        var nx := node.position + Vector2(dirv.x, 0.0) * step
        if not _tile_is_solid(nx):
            node.position.x = nx.x
        var ny := node.position + Vector2(0.0, dirv.y) * step
        if not _tile_is_solid(ny):
            node.position.y = ny.y
        if absf(dirv.x) >= absf(dirv.y):
            spr.play("walk_side")
            spr.flip_h = dirv.x < 0.0
        else:
            spr.play("walk_down" if dirv.y > 0.0 else "walk_up")
    else:
        spr.play("idle_down")
    if to.length() <= DEMON_ATTACK_RANGE and float(demon.get("atk_cd", 0.0)) <= 0.0:
        demon["atk_cd"] = DEMON_ATTACK_CD
        Game.damage_hp(DEMON_DAMAGE)
        Sfx.play("hurt")
        _spawn_swing(player.position + Vector2(0, -10), Color(0.9, 0.3, 0.25))
        _spawn_damage_label(player.position + Vector2(0, -40), DEMON_DAMAGE)
        _spell_poof(player.position + Vector2(0, -14), Color(0.85, 0.3, 0.25))
        _spawn_hit_impact(player.position + Vector2(0, -14), Color(0.9, 0.35, 0.3))

func _joystick_output() -> Vector2:
    if _joystick == null or not "output" in _joystick:
        return Vector2.ZERO
    var value: Variant = _joystick.get("output")
    return value if value is Vector2 else Vector2.ZERO

func _update_walk_anim(_delta: float, moving: bool, dir: Vector2 = Vector2.ZERO) -> void:
    var anim := "idle_down"
    if moving:
        if absf(dir.x) >= absf(dir.y) and absf(dir.x) > 0.01:
            anim = "walk_side"
            _player_sprite.flip_h = dir.x < 0.0
            _facing = "side"
        elif dir.y < 0.0:
            anim = "walk_up"
            _facing = "up"
        else:
            anim = "walk_down"
            _facing = "down"
    else:
        match _facing:
            "side":
                anim = "idle_side"
            "up":
                anim = "idle_up"
            _:
                anim = "idle_down"
    if _player_sprite.animation != anim:
        _player_sprite.play(anim)

func _update_pointers() -> void:
    if player == null:
        return
    for npc in _npcs:
        var node: Node2D = npc["node"]
        var pointer: Sprite2D = npc["pointer"]
        var near := player.position.distance_to(node.position) < 30.0 \
            and not _dialogue.visible and not _inventory_ui.visible \
            and not _trade_ui.visible \
            and not bool(npc.get("dead", false))   # над трупом указателя нет
        pointer.visible = near

# InputMap remains the movement source. Track press/release origins so input
# held across modal visibility changes stays blocked until a fresh press.
var _blocked_movement_inputs: Dictionary = {}
var _held_movement_inputs: Dictionary = {}

func _input(event: InputEvent) -> void:
    var identity: String
    if event is InputEventMouseButton:
        identity = "mouse:%d" % event.button_index
    elif event is InputEventKey:
        identity = "key:%d" % (event.physical_keycode if event.physical_keycode else event.keycode)
    else:
        return
    if not event.is_pressed():
        _blocked_movement_inputs.erase(identity)
        _held_movement_inputs.erase(identity)
        return
    if event.is_echo():
        return
    for action in ["move_left", "move_right", "move_up", "move_down"]:
        if not event.is_action_pressed(action):
            continue
        _held_movement_inputs[identity] = true
        _blocked_movement_inputs.erase(identity)
        if _gameplay_input_blocked():
            _blocked_movement_inputs[identity] = true
        elif event is InputEventMouseButton:
            var local := _walk_local_position(event.position)
            var hovered := get_viewport().gui_get_hovered_control()
            var over_ui := hovered != null and hovered != _walk_holder \
                and not _walk_holder.is_ancestor_of(hovered)
            if not local.is_finite() or over_ui:
                _blocked_movement_inputs[identity] = true
            elif event.button_index == MOUSE_BUTTON_LEFT \
                    and _point_on_interactive(_walk_pos_to_world(local)):
                _blocked_movement_inputs[identity] = true
        return

func _on_modal_visibility_changed() -> void:
    if _gameplay_input_blocked():
        _blocked_movement_inputs.merge(_held_movement_inputs, true)

func _notification(what: int) -> void:
    if what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
        _blocked_movement_inputs.clear()
        _held_movement_inputs.clear()

func _walk_local_position(root_position: Vector2) -> Vector2:
    if _walk_holder == null:
        return Vector2.INF
    var local := _walk_holder.get_global_transform_with_canvas().affine_inverse() * root_position
    return local if Rect2(Vector2.ZERO, _walk_holder.size).has_point(local) else Vector2.INF

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        # Mouse commands inside WalkScreen have exactly one entry: gui_input.
        if _walk_local_position((event as InputEventMouseButton).position).is_finite():
            return
    _handle_gameplay_input(event)

func _gameplay_input_blocked() -> bool:
    return _player_dead or _dialogue.visible or _inventory_ui.visible or _trade_ui.visible

func _handle_gameplay_input(event: InputEvent, walk_position: Vector2 = Vector2.INF) -> void:
    if _player_dead:
        return   # шаг 12: на экране смерти мир не слушает удары и диалоги
    if event.is_action_pressed("toggle_inventory"):
        if _trade_ui.visible:
            return
        if _inventory_ui.visible:
            _inventory_ui.close()
        elif not _dialogue.visible:
            _inventory_ui.open()
        return
    if event.is_action_pressed("attack") and not _dialogue.visible \
            and not _inventory_ui.visible and not _trade_ui.visible:
        if walk_position.is_finite():
            _try_click_strike(walk_position)
        else:
            _strike()
        return
    if event.is_action_pressed("cast_spell") and not _dialogue.visible \
            and not _inventory_ui.visible and not _trade_ui.visible:
        _on_q_pressed()
        return
    if event.is_action_pressed("special") and not event.is_echo() \
            and not _dialogue.visible and not _inventory_ui.visible \
            and not _trade_ui.visible:
        _on_special_pressed()
        return
    if event.is_action_released("special"):
        _on_special_released()
        return
    if event.is_action_pressed("special2") and not _dialogue.visible \
            and not _inventory_ui.visible and not _trade_ui.visible:
        _on_t_pressed()
        return
    if event.is_action_pressed("interact") and not _dialogue.visible \
            and not _inventory_ui.visible and not _trade_ui.visible \
            and player != null and _interact_allowed():
        # шаг 11: диалог на E (F тоже работает — обе клавиши в действии
        # "interact"); ближайший живой NPC в радиусе 32 px
        var nearest: Dictionary = {}
        var best := 32.0
        for npc in _npcs:
            if bool(npc.get("dead", false)):
                continue   # с трупом не поговоришь
            var d: float = player.position.distance_to((npc["node"] as Node2D).position)
            if d < best:
                best = d
                nearest = npc
        if not nearest.is_empty():
            npc_say(String(nearest["id"]))
        else:
            # шаг 9/13: рядом с дверью данжа E тоже работает — дверь 1
            # ведёт в подземелье, остальные открывают сообщение о запертости
            var door: Dictionary = _nearest_door()
            if not door.is_empty():
                _open_door_dialog(String(door["id"]))

## Ближайшая дверь данжа в радиусе DOOR_INTERACT_RANGE (шаг 9).
func _nearest_door() -> Dictionary:
    if player == null:
        return {}
    var best: Dictionary = {}
    var best_d := DOOR_INTERACT_RANGE
    for door in _doors:
        var d: float = player.position.distance_to((door["node"] as Node2D).position)
        if d < best_d:
            best_d = d
            best = door
    return best

# ---------------------------------------------------------------- магия (шаг 6)

## Каст заклинания: кнопка МАГИЯ или клавиша Q. Только у мага.
## Шаг 12: оружие в руках определяет, что вылетит:
## магическое оружие — залп этого оружия (веер из spell_info["count"]
## снарядов с цветом и размером оружия), обычная сталь или пустые руки —
## классическая «Магическая стрела». Не-магу — отказ по классу.
func _cast_spell() -> void:
    if not Game.is_mage():
        _show_hint(Game.non_mage_spell_hint(), 2.0)
        return
    if _spell_cd > 0.0:
        return
    var info := Game.spell_info()
    if not Game.cast_spell():
        _show_hint("Не хватает маны: нужно %d" % int(info["cost"]), 2.0)
        return
    _spell_cd = float(info["cooldown"])
    Sfx.play("bolt")
    var dir := _facing_vector()
    var count := maxi(1, int(info.get("count", 1)))
    var spread := deg_to_rad(float(info.get("spread_deg", 0.0)))
    if count == 1:
        _spawn_bolt(dir, info)
    else:
        for i in range(count):
            var offset := (float(i) - float(count - 1) / 2.0) * spread
            _spawn_bolt(dir.rotated(offset), info)

## Направление взгляда героя — вектор полёта стрелы.
func _facing_vector() -> Vector2:
    match _facing:
        "up":
            return Vector2(0, -1)
        "side":
            return Vector2(-1, 0) if _player_sprite.flip_h else Vector2(1, 0)
        _:
            return Vector2(0, 1)

## Создать снаряд в точке героя: летит по dir, наносит урон живому NPC
## на пути (шаг 9), гаснет у стен или по дистанции. info — параметры
## заклинания (Game.spell_info): урон, скорость, дистанция, цвет и размер;
## пустой/отсутствующий — классическая «Магическая стрела» (шаг 12).
func _spawn_bolt(dir: Vector2, info: Dictionary = {}) -> void:
    if dir == Vector2.ZERO or _bolt_tex == null:
        return
    if info.is_empty():
        info = Game.spell_info()
        if info.is_empty():
            return
    var bolt := Sprite2D.new()
    bolt.texture = _bolt_tex
    var col: Array = info.get("color", [0.55, 0.85, 0.95])
    bolt.modulate = Color(float(col[0]), float(col[1]), float(col[2]))
    var size := float(info.get("size", 1.0))
    bolt.scale = Vector2(size, size)
    bolt.position = player.position + Vector2(0, -14)
    bolt.z_index = 10
    # шаг 19: снаряды светятся и оставляют тающий след
    var glow := Sprite2D.new()
    glow.texture = load("res://assets/sprites/props/glow.png")
    var glow_mat := CanvasItemMaterial.new()
    glow_mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
    glow.material = glow_mat
    glow.scale = Vector2(1.1, 1.1)
    glow.modulate = Color(float(col[0]), float(col[1]), float(col[2]), 0.7)
    bolt.add_child(glow)
    _world.add_child(bolt)
    _bolts.append({"node": bolt, "dir": dir.normalized(),
        "left": float(info["range_px"]), "speed": float(info["speed"]),
        "damage": int(info["damage"]), "color": bolt.modulate, "trail": 0.0})

func _update_bolts(delta: float) -> void:
    if _bolts.is_empty():
        return
    for i in range(_bolts.size() - 1, -1, -1):
        var b: Dictionary = _bolts[i]
        var node: Sprite2D = b["node"]
        var step: Vector2 = (b["dir"] as Vector2) * float(b["speed"]) * delta
        node.position += step
        if bool(b.get("spin", false)):
            node.rotation += 10.0 * delta   # метательный топор крутится (шаг 18)
        b["left"] = float(b["left"]) - step.length()
        # шаг 19: след из тающих искр за снарядом (и за топором)
        b["trail"] = float(b.get("trail", 0.0)) + delta
        if float(b["trail"]) >= 0.05:
            b["trail"] = 0.0
            _spawn_trail_dot(node.position, b.get("color",
                Color(0.55, 0.85, 0.95)))
        # шаг 9: стрела бьёт первого живого NPC, в чьё тело она попала
        var target := _npc_at_point(node.position)
        if not target.is_empty():
            _spawn_hit_impact(node.position, b.get("color",
                Color(0.55, 0.85, 0.95)))
            node.queue_free()
            _bolts.remove_at(i)
            _hit_npc(target, int(b["damage"]))
            continue
        var faded := float(b["left"]) <= 0.0
        if faded or _tile_is_solid(node.position):
            _spell_poof(node.position, b.get("color", Color(0.55, 0.85, 0.95)))
            node.queue_free()
            _bolts.remove_at(i)

## Живой NPC в точке (шаг 9): прямоугольник тела с учётом масштаба
## (демон втрое крупнее — его зона попадания тоже втрое больше).
func _npc_at_point(pos: Vector2) -> Dictionary:
    for npc in _npcs:
        if bool(npc.get("dead", false)):
            continue   # труп стрела не бьёт
        var node: Node2D = npc["node"]
        var s := maxi(1, int((npc["data"] as Dictionary).get("scale", 1)))
        if pos.x < node.position.x - 10.0 * s or pos.x > node.position.x + 10.0 * s:
            continue
        if pos.y < node.position.y - float(CHAR_H * s) - 6.0 \
                or pos.y > node.position.y + 4.0:
            continue
        return npc
    return {}

## Символ тайла под точкой (за границей карты — «твёрдый» космос).
func _tile_is_solid(pos: Vector2) -> bool:
    var tx := int(floor(pos.x / float(WorldMap.TILE_SIZE)))
    var ty := int(floor(pos.y / float(WorldMap.TILE_SIZE)))
    if tx < 0 or ty < 0 or tx >= WorldMap.MAP_W or ty >= WorldMap.MAP_H:
        return true
    return WorldMap.SOLID_TILES.contains(WorldMap.MAP[ty][tx])

## Вспышка-частицы при исчезновении стрелы (и при смерти NPC — серым).
func _spell_poof(pos: Vector2, color: Color = Color(0.55, 0.85, 0.95)) -> void:
    var poof := CPUParticles2D.new()
    poof.position = pos
    poof.amount = 10
    poof.lifetime = 0.3
    poof.one_shot = true
    poof.explosiveness = 1.0
    poof.direction = Vector2(0, -1)
    poof.spread = 180.0
    poof.initial_velocity_min = 20.0
    poof.initial_velocity_max = 50.0
    poof.scale_amount_min = 1.5
    poof.scale_amount_max = 3.0
    poof.color = color
    poof.emitting = true
    poof.z_index = 10
    _world.add_child(poof)
    var tw := create_tween()   # шаг 23: твин умирает вместе со сценой
    tw.tween_interval(0.6)
    tw.tween_callback(func() -> void:
        if is_instance_valid(poof):
            poof.queue_free())

# --------------------------------------------- способности героев (шаг 18)

## Нажатие Q (действие cast_spell): у мага — магия (шаги 6/12), у остальных
## героев — свой приём из Game.ABILITIES с кулдауном. В мире приёмы
## действуют только на разъярённого демона (мирная зона).
func _on_q_pressed() -> void:
    if player == null or _player_dead:
        return
    if _dialogue.visible or _inventory_ui.visible or _trade_ui.visible:
        return
    var info := Game.ability_info("q")
    if info.is_empty():
        return
    match String(info["kind"]):
        "spell":
            if _barrier_blocks_cast():
                return
            _cast_spell()
        "whirl":
            if _barrier_blocks_cast():
                return
            if _q_cd > 0.0:
                _show_hint("Вихрь ещё не готов (%.0f с)" % _q_cd, 1.2)
                return
            _q_cd = float(info["cd"])
            _do_whirl(info)
        "axe":
            if _barrier_blocks_cast():
                return
            if _q_cd > 0.0:
                _show_hint("Топор ещё не готов (%.0f с)" % _q_cd, 1.2)
                return
            _q_cd = float(info["cd"])
            _throw_axe(info)
        "dust":
            if _barrier_blocks_cast():
                return
            if _q_cd > 0.0:
                _show_hint("Пыль ещё не готова (%.0f с)" % _q_cd, 1.2)
                return
            _q_cd = float(info["cd"])
            _throw_dust(info)
        _:
            pass

## Пока барьер мага держится, другие приёмы недоступны.
func _barrier_blocks_cast() -> bool:
    if Game.hero_immune and not Game.guard_active:
        _show_hint("Барьер поглощает всё внимание", 1.6)
        return true
    return false

## Живой демон рядом (в радиусе radius) или пустой словарь.
func _demon_in_radius(radius: float) -> Dictionary:
    var demon := _demon_record()
    if demon.is_empty() or player == null:
        return {}
    if (demon["node"] as Node2D).position.distance_to(player.position) > radius:
        return {}
    return demon

## Вихрь клинка воина: урон оружием демону в радиусе (в мире — только
## демон: вихрь клинка в толпе жителей — это бойня, а не приём).
func _do_whirl(info: Dictionary) -> void:
    var radius := float(info["radius"])
    var color := Game.strike_swing_color()
    for i in range(8):
        var ang := TAU * float(i) / 8.0
        _spawn_swing(player.position + Vector2(cos(ang), sin(ang)) * 16.0 + Vector2(0, -10), color)
    _spell_poof(player.position + Vector2(0, -10), color)
    # шаг 19: вихрь — с дугой и звуком
    _spawn_slash_arc(player.position + Vector2(0, -10), color)
    Sfx.play("swing", 2.0)
    var demon := _demon_in_radius(radius)
    if demon.is_empty():
        _show_hint("Вихрь рассёк воздух", 1.2)
        return
    _hit_npc(demon, Game.strike_damage())

## Метательный топор варвара: летит вперёд и бьёт первого живого NPC на
## пути (как стрела магии, шаг 9). Урон — из Game.ABILITIES (100).
func _throw_axe(info: Dictionary) -> void:
    if _ability_axe_tex == null:
        _ability_axe_tex = load(AXE_TEX_PATH)
    var axe := Sprite2D.new()
    axe.texture = _ability_axe_tex
    axe.position = player.position + Vector2(0, -14)
    axe.z_index = 10
    # шаг 19: топор несётся со свечением и свистом
    var axe_glow := Sprite2D.new()
    axe_glow.texture = load("res://assets/sprites/props/glow.png")
    var axe_mat := CanvasItemMaterial.new()
    axe_mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
    axe_glow.material = axe_mat
    axe_glow.scale = Vector2(0.8, 0.8)
    axe_glow.modulate = Color(0.85, 0.9, 1.0, 0.6)
    axe.add_child(axe_glow)
    _world.add_child(axe)
    Sfx.play("throw")
    _bolts.append({"node": axe, "dir": _facing_vector().normalized(),
        "left": float(info["range_px"]), "speed": float(info["speed"]),
        "damage": maxi(1, int(round(float(info["damage"])
            * Game.titan_damage_mult()))),
        "color": Color(0.85, 0.9, 1.0), "spin": true})

## Горсть пыли бомжа: демон в радиусе слепнет на blind_sec — не видит
## героя, не гонится и не бьёт (в мире пыль бросают только в демона).
func _throw_dust(info: Dictionary) -> void:
    var demon := _demon_in_radius(float(info["radius"]))
    if demon.is_empty():
        _show_hint("Пыль осела — демона рядом нет", 1.6)
        return
    var blind_ms := int(round(float(info["blind_sec"]) * 1000.0))
    demon["blind_until"] = Time.get_ticks_msec() + blind_ms
    _spell_poof(player.position + Vector2(0, -12), Color(0.76, 0.62, 0.42))
    _spell_poof((demon["node"] as Node2D).position + Vector2(0, -18),
        Color(0.7, 0.58, 0.4))
    Sfx.play("dust")
    _show_hint(DUST_HINT, 1.6)

## Гнилой газ бомжа: облако на месте выпуска, тик раз в tick_interval:
## демон в радиусе (3 клетки) получает tick_damage. Первый тик сразу.
func _cast_gas(info: Dictionary) -> void:
    var cloud := CPUParticles2D.new()
    cloud.amount = 26
    cloud.lifetime = 1.1
    cloud.position = player.position + Vector2(0, -10)
    cloud.direction = Vector2(0, -1)
    cloud.spread = 180.0
    cloud.initial_velocity_min = 8.0
    cloud.initial_velocity_max = 22.0
    cloud.scale_amount_min = 2.0
    cloud.scale_amount_max = 4.5
    cloud.color = Color(0.45, 0.72, 0.35, 0.55)
    cloud.emitting = true
    _world.add_child(cloud)
    Sfx.play("gas")
    _gas_clouds.append({"pos": cloud.position, "ticks_left": int(info["ticks"]),
        "tick_accum": 0.0, "interval": float(info["tick_interval"]),
        "radius": float(info["radius"]), "damage": int(info["tick_damage"]),
        "node": cloud})
    _tick_gas_clouds()
    _show_hint(GAS_HINT, 1.6)

## Один тик всех живых облаков газа (в мире газ жжёт только демона).
func _tick_gas_clouds() -> void:
    for cloud in _gas_clouds:
        if int(cloud["ticks_left"]) <= 0:
            continue
        cloud["ticks_left"] = int(cloud["ticks_left"]) - 1
        var demon := _demon_record()
        if demon.is_empty():
            continue
        var node: Node2D = demon["node"]
        if node.position.distance_to(cloud["pos"]) <= float(cloud["radius"]):
            _hit_npc(demon, int(cloud["damage"]))

## Жизнь облаков: тики по интервалу, гашение после последнего тика.
func _update_gas(delta: float) -> void:
    if _gas_clouds.is_empty():
        return
    for i in range(_gas_clouds.size() - 1, -1, -1):
        var cloud: Dictionary = _gas_clouds[i]
        if int(cloud["ticks_left"]) > 0:
            cloud["tick_accum"] = float(cloud["tick_accum"]) + delta
            if float(cloud["tick_accum"]) >= float(cloud["interval"]):
                cloud["tick_accum"] = 0.0
                _tick_gas_clouds()
        if int(cloud["ticks_left"]) <= 0:
            var node: CPUParticles2D = cloud["node"]
            node.emitting = false
            var tw := create_tween()   # шаг 23: твин умирает вместе со сценой
            tw.tween_interval(1.2)
            tw.tween_callback(func() -> void:
                if is_instance_valid(node):
                    node.queue_free())
            _gas_clouds.remove_at(i)

## Пробел (действие special): у мага барьер, у воина щит, у бомжа газ,
## у варвара бросок (в мире бросок не работает — демон не поддаётся).
func _on_special_pressed() -> void:
    if player == null or _player_dead:
        return
    if _dialogue.visible or _inventory_ui.visible or _trade_ui.visible:
        return
    var info := Game.ability_info("special")
    if info.is_empty():
        return
    match String(info["kind"]):
        "hold_barrier":
            if _special_held:
                return
            if Game.mana <= 0:
                _show_hint("Мана на барьер уже иссякла", 1.6)
                return
            _start_hold(info)
            Game.hero_immune = true
            _spawn_hold_visual(Color(0.58, 0.42, 0.95, 0.55), 4.6)
            Sfx.play("barrier")
            _show_hint("Барьер: неуязвим, но бить нельзя", 1.8)
        "hold_shield":
            if _special_held:
                return
            if _special_cd > 0.0:
                _show_hint("Щит ещё не готов (%.0f с)" % _special_cd, 1.5)
                return
            _start_hold(info)
            Game.hero_immune = true
            Game.guard_active = true
            _spawn_hold_visual(Color(0.62, 0.74, 0.95, 0.5), 3.4)
            Sfx.play("shield")
            _show_hint("Щит поднят: урон не проходит, но ты медленнее и слабее", 2.0)
        "gas":
            if _special_cd > 0.0:
                _show_hint("Газ ещё не готов (%.0f с)" % _special_cd, 1.5)
                return
            _special_cd = float(info["cd"])
            _cast_gas(info)
        "death_leap":
            # шаг 22: прыжок переехал с T на пробел (у варвара)
            if _special_cd > 0.0:
                _show_hint("Прыжок ещё не готов (%.0f с)" % _special_cd, 1.5)
                return
            if not _try_death_leap(info):
                return   # фальстарт: кулдаун не тратится
            _special_cd = float(info["cd"])
        _:
            pass

func _on_special_released() -> void:
    if _special_held:
        _end_hold("")

func _start_hold(info: Dictionary) -> void:
    _special_held = true
    _special_hold_left = float(info["max_hold"])
    _special_drain_accum = 0.0

## Завершить удержание: снять неуязвимость, потушить визуал, у щита —
## запустить кулдаун.
func _end_hold(end_hint: String) -> void:
    var was_shield := Game.guard_active
    _special_held = false
    _special_hold_left = 0.0
    _special_drain_accum = 0.0
    Game.hero_immune = false
    Game.guard_active = false
    _clear_hold_visual()
    if was_shield:
        _special_cd = float(Game.ability_info("special").get("cd", 10.0))
        _show_hint("Щит опущен", 1.4)
    elif not end_hint.is_empty():
        _show_hint(end_hint, 1.6)

## Тик удержания: время, расход маны барьера, смерть героя.
func _update_special_hold(delta: float) -> void:
    if not _special_held:
        return
    if player == null or Game.hp <= 0 or _player_dead:
        _end_hold("")
        return
    var info := Game.ability_info("special")
    _special_hold_left -= delta
    if String(info["kind"]) == "hold_barrier":
        _special_drain_accum += delta * float(info["mana_per_sec"])
        var whole := int(_special_drain_accum)
        if whole > 0:
            _special_drain_accum -= float(whole)
            if Game.mana >= whole:
                Game.spend_mana(whole)
            else:
                if Game.mana > 0:
                    Game.spend_mana(Game.mana)
                _end_hold("Мана иссякла — барьер угас")
                return
    if _special_hold_left <= 0.0:
        _end_hold("")

## Круг барьера/щита: мягкое свечение glow.png вокруг героя.
func _spawn_hold_visual(color: Color, scale_f: float) -> void:
    _clear_hold_visual()
    var glow := Sprite2D.new()
    glow.texture = load("res://assets/sprites/props/glow.png")
    var mat := CanvasItemMaterial.new()
    mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
    glow.material = mat
    glow.scale = Vector2(scale_f, scale_f)
    glow.modulate = color
    glow.position = Vector2(0, -10)
    glow.z_index = 6
    player.add_child(glow)
    _hold_visual = glow

func _clear_hold_visual() -> void:
    if _hold_visual != null and is_instance_valid(_hold_visual):
        _hold_visual.queue_free()
    _hold_visual = null

# ---------------------------------------------------------------- удары (шаг 7)

## Удар (ЛКМ, кнопка УДАР или клик по пустому месту экрана ходьбы):
## есть оружие в руках — бьём оружием (урон из ItemDB с классовыми
## множителями и магическим эффектом — см. Game), нет — рукой
## (кулаки, у всех героев, маг тоже). Цель — живой NPC в направлении
## взгляда на дистанции STRIKE_RANGE.
# --------------------------------------------- третий приём T (шаг 20)

## Гнев титана варвара (шаг 22): форма на 4 секунды — герой вырастает,
## урон по нему не проходит (Game.damage_hp), а удары и приёмы бьют
## в 4 раза сильнее (Game.strike_damage и множитель в топоре). Рёв и
## красные вспышки по активации; гаснет сам по таймеру.
func _do_titan_rage(info: Dictionary) -> void:
    Game.start_titan_rage(float(info["duration"]), float(info["damage_mult"]))
    var scale_to := float(info.get("scale", 1.55))
    Sfx.play("roar")
    _spell_poof(player.position + Vector2(0, -8), Color(0.85, 0.25, 0.2))
    _spell_poof(player.position + Vector2(0, -18), Color(1.0, 0.45, 0.3))
    _spawn_hit_impact(player.position + Vector2(0, -12),
        Color(1.0, 0.45, 0.3))
    _show_hint(TITAN_HINT, float(info["duration"]) * 0.6)
    if not _titan_big:
        _titan_big = true
        _titan_base_scale = _player_sprite.scale
        var tw := create_tween()
        tw.tween_property(_player_sprite, "scale",
            _titan_base_scale * scale_to, 0.25) \
            .set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

## Синхронизация формы титана со состоянием Game: растёт по активации
## (в том числе если сцена сменилась в середине формы), гаснет по таймеру.
func _update_titan(delta: float) -> void:
    if Game.titan_active() and not _titan_big:
        _titan_big = true
        _titan_base_scale = _player_sprite.scale
        var tw := create_tween()
        tw.tween_property(_player_sprite, "scale",
            _titan_base_scale * float(Game.ability_info("t").get("scale", 1.55)),
            0.25)
        return
    if not Game.titan_active() and _titan_big:
        _titan_big = false
        var tw := create_tween()
        tw.tween_property(_player_sprite, "scale", _titan_base_scale, 0.25)
        _show_hint(TITAN_FADED_HINT, 1.4)

## T (действие "special2"): третий приём каждого класса. В мире враг
## один — демон: выплеск и град мечей бьют по нему, прыжок варвара
## считается «боссовским» (демона убить прыжком нельзя — только
## 200 урона плюс урон актуального удара), передышка лечит героя.
func _on_t_pressed() -> void:
    if _player_dead:
        return
    if _dialogue.visible or _inventory_ui.visible or _trade_ui.visible:
        return
    var info := Game.ability_info("t")
    if info.is_empty():
        return
    if _t_cd > 0.0:
        _show_hint("%s ещё не готов (%.0f с)" % [String(info["title"]), _t_cd], 1.5)
        return
    match String(info["kind"]):
        "mana_burst":
            if _barrier_blocks_cast():
                return
            if Game.mana <= 0:
                _show_hint("Мана иссякла — выплеску нечем разгореться", 1.8)
                return
            _t_cd = float(info["cd"])
            _do_mana_burst(info)
        "second_wind":
            _t_cd = float(info["cd"])
            _do_second_wind()
        "titan_rage":
            if _barrier_blocks_cast():
                return
            _t_cd = float(info["cd"])
            _do_titan_rage(info)
        "sword_rain":
            if _barrier_blocks_cast():
                return
            _t_cd = float(info["cd"])
            _do_sword_rain(info)
        _:
            pass

## Выплеск магии: вся мана — в волну на 20 × уровень (бьёт демона).
func _do_mana_burst(info: Dictionary) -> void:
    var spent := Game.mana
    Game.spend_mana(Game.mana)
    var damage := int(info["damage_per_level"]) * Game.level
    var color := Color(0.62, 0.42, 0.95)
    _spell_poof(player.position + Vector2(0, -10), color)
    _spell_poof(player.position + Vector2(0, -22), Color(0.8, 0.65, 1.0))
    Sfx.play("surge")
    var demon := _demon_record()
    if demon.is_empty():
        _show_hint("Выплеск магии: -%d маны. В мире некому достаться" % spent, 2.2)
        return
    _hit_npc(demon, damage)
    _show_hint("Выплеск магии: -%d маны, %d урона демону" % [spent, damage], 2.2)

## Передышка бомжа: полное лечение (кулдаун минута — задал автор).
func _do_second_wind() -> void:
    var healed := Game.heal_hp(Game.max_hp())
    for i in range(3):
        _spell_poof(player.position + Vector2(-10 + i * 10, -14 - i * 8),
            Color(0.55, 0.9, 0.5))
    Sfx.play("heal")
    _show_hint("Передышка: восстановлено %d хп" % healed, 2.2)

## Смертельный прыжок варвара в мире: демон — «босс», ему 200 + урон.
func _try_death_leap(info: Dictionary) -> bool:
    var demon := _demon_record()
    if demon.is_empty():
        _show_hint("В мире некого топтать: прыжок не сработал", 1.8)
        return false
    var dnode: Node2D = demon["node"]
    if dnode.position.distance_to(player.position) > float(info["leap_range"]):
        _show_hint("Демон далеко: прыжок не дотянется", 1.8)
        return false
    _leap_flight = {"npc": demon, "t": 0.0, "from": player.position,
        "to": dnode.position + Vector2(0, 6),
        "boss_damage": int(info["boss_damage"])}
    Sfx.play("leap")
    return true

## Полёт прыжка: дуга над улицей; приземление — удар по демону.
func _update_leap_flight(delta: float) -> void:
    if _leap_flight.is_empty() or player == null:
        return
    var rec: Dictionary = _leap_flight
    rec["t"] = minf(1.0, float(rec["t"]) + delta / 0.38)
    var t := float(rec["t"])
    var to: Vector2 = rec["to"]
    player.position = (rec["from"] as Vector2).lerp(to, t) \
        + Vector2(0, -sin(t * PI) * 26.0)
    if t >= 1.0:
        var demon: Dictionary = rec["npc"]
        var damage := int(rec["boss_damage"]) + Game.strike_damage()
        _spell_poof(player.position + Vector2(0, -8), Color(0.85, 0.75, 0.5))
        _leap_flight = {}
        if not bool(demon.get("dead", false)):
            _hit_npc(demon, damage)
        _show_hint("Прыжок тряхнул демона: %d урона" % damage, 1.8)

## Град мечей в мире: мечи падают вокруг героя, демон в точке падения
## получает урон актуального удара (Game.strike_damage).
func _do_sword_rain(info: Dictionary) -> void:
    var radius := float(info["radius"])
    var count := int(info["swords"])
    var damage := Game.strike_damage()
    var color := Game.strike_swing_color()
    Sfx.play("rain")
    _show_hint("Град мечей: %d клинков на %d урона" % [count, damage], 2.2)
    var tex: Texture2D = load("res://assets/sprites/icons/sword.png")
    for i in range(count):
        var ang := TAU * float(i) / float(count) + randf_range(-0.2, 0.2)
        var r := radius * sqrt(randf_range(0.35, 1.0))
        var target := player.position + Vector2(cos(ang) * r, sin(ang) * r * 0.7)
        if _tile_is_solid(target):
            target = player.position
        var sword := Sprite2D.new()
        sword.texture = tex
        sword.position = target + Vector2(0, -46)
        sword.rotation = PI * 0.75
        sword.scale = Vector2(1.5, 1.5)
        sword.z_index = 11
        sword.modulate = Color(color.r, color.g, color.b, 0.0)
        _world.add_child(sword)
        _sword_rain.append({"node": sword, "target": target,
            "delay": 0.06 * i, "fall": 0.0, "damage": damage,
            "hit_radius": float(info["hit_radius"])})

## Падение мечей (мир): удар по демону в точке падения.
func _update_sword_rain(delta: float) -> void:
    if _sword_rain.is_empty():
        return
    for i in range(_sword_rain.size() - 1, -1, -1):
        var rec: Dictionary = _sword_rain[i]
        var node: Sprite2D = rec["node"]
        if float(rec["delay"]) > 0.0:
            rec["delay"] = float(rec["delay"]) - delta
            continue
        node.modulate.a = minf(1.0, node.modulate.a + delta * 8.0)
        rec["fall"] = minf(1.0, float(rec["fall"]) + delta / 0.22)
        var target: Vector2 = rec["target"]
        node.position = target + Vector2(0, -46.0 * (1.0 - float(rec["fall"])))
        if float(rec["fall"]) >= 1.0:
            _spawn_hit_impact(target + Vector2(0, -10), Color(0.9, 0.92, 1.0))
            var demon := _demon_record()
            if not demon.is_empty() and not bool(demon.get("dead", false)) \
                    and (demon["node"] as Node2D).position.distance_to(target) \
                        <= float(rec["hit_radius"]):
                _hit_npc(demon, int(rec["damage"]))
            node.queue_free()
            _sword_rain.remove_at(i)

func _strike() -> void:
    if player == null or _strike_cd > 0.0 or _player_dead:
        return
    if Game.hero_immune and not Game.guard_active:
        _show_hint("Барьер поглощает всё внимание — бить нельзя", 1.6)
        return
    _strike_cd = STRIKE_COOLDOWN
    if Game.guard_active:
        _strike_cd *= float(Game.ability_info("special").get("strike_cd_mult", 2.0))
    var dir := _facing_vector()
    var target := _living_npc_in_front(dir)
    var weapon_color := Game.strike_swing_color()
    # шаг 19: оружие видно в замахе, свист — в ушах
    _spawn_weapon_swing(dir, weapon_color)
    Sfx.play("swing")
    if target.is_empty():
        # промах: просто взмах в сторону взгляда
        _spawn_swing(player.position + dir * 14.0 + Vector2(0, -12), weapon_color)
        return
    var npc_node: Node2D = target["node"]
    _spawn_swing((player.position + npc_node.position) * 0.5 + Vector2(0, -12), weapon_color)
    _spawn_slash_arc(npc_node.position + Vector2(0, -12), weapon_color)
    _hit_npc(target, Game.strike_damage())
    # шаг 12: не-маг бьёт магическим оружием — в точке цели синеет вспышка
    # «магического эффекта» (бонус урона уже учтён в Game.strike_damage)
    if Game.strike_is_magic_surge():
        _spell_poof(npc_node.position + Vector2(0, -16), weapon_color)

## Нанести урон NPC (шаг 9, общее для удара ЛКМ и магии):
## всплывающее число, вспышка боли, полоска хп; при нуле — NPC умирает.
## Шаг 12: удар по живому демону — регистрируется в Game (register_demon_hit);
## после третьего удара демон взрывается яростью (см. _on_demon_enraged).
func _hit_npc(npc: Dictionary, damage: int) -> void:
    var npc_node: Node2D = npc["node"]
    var s := maxi(1, int((npc["data"] as Dictionary).get("scale", 1)))
    npc["hp"] = maxi(0, int(npc["hp"]) - damage)
    _spawn_damage_label(npc_node.position + Vector2(0, -float(CHAR_H * s) - 2), damage)
    # шаг 19: яркая вспышка в точке попадания
    _spawn_hit_impact(npc_node.position + Vector2(0, -12),
        Color(1.0, 0.85, 0.6))
    Sfx.play("hit")
    _flash_npc(npc)
    _show_npc_hp_bar(npc)
    if int(npc["hp"]) <= 0:
        _kill_npc(npc)
    elif String(npc["id"]) == "demon":
        var count := Game.register_demon_hit()
        if not Game.demon_enraged:
            var idx := count - 1
            if idx >= 0 and idx < DEMON_HIT_HINTS.size():
                _show_hint(String(DEMON_HIT_HINTS[idx]), 2.2)

## Ближайший живой NPC перед героем (в дуге взгляда).
func _living_npc_in_front(dir: Vector2) -> Dictionary:
    var best: Dictionary = {}
    var best_d := STRIKE_RANGE
    for npc in _npcs:
        if bool(npc.get("dead", false)):
            continue   # труп не бьётся
        var node: Node2D = npc["node"]
        var to := node.position - player.position
        var dist := to.length()
        if dist > best_d:
            continue
        if dist > 1.0 and dir.dot(to.normalized()) < 0.2:
            continue   # за спиной
        best_d = dist
        best = npc
    return best

## Взмах: россыпь искр в точке удара (золотые — оружие, серые — кулаки).
func _spawn_swing(pos: Vector2, color: Color) -> void:
    var swing := CPUParticles2D.new()
    swing.position = pos
    swing.amount = 14                       # шаг 19: сочнее
    swing.lifetime = 0.24
    swing.one_shot = true
    swing.explosiveness = 1.0
    swing.direction = Vector2(0, -1)
    swing.spread = 120.0
    swing.initial_velocity_min = 60.0
    swing.initial_velocity_max = 130.0
    swing.scale_amount_min = 1.6
    swing.scale_amount_max = 3.2
    swing.color = color
    swing.emitting = true
    swing.z_index = 10
    _world.add_child(swing)
    var tw := create_tween()   # шаг 23: твин умирает вместе со сценой
    tw.tween_interval(0.5)
    tw.tween_callback(func() -> void:
        if is_instance_valid(swing):
            swing.queue_free())

## Видимое оружие (шаг 19): иконка того, что в руках, проносится дугой
## в направлении взгляда и тает. Кулаки — без иконки (искры и дуга).
func _spawn_weapon_swing(dir: Vector2, color: Color) -> void:
    var icon_path := Game.strike_weapon_icon()
    if icon_path.is_empty() or not ResourceLoader.exists(icon_path):
        return
    if not _weapon_tex_cache.has(icon_path):
        _weapon_tex_cache[icon_path] = load(icon_path)
    var tex: Texture2D = _weapon_tex_cache[icon_path]
    var base := atan2(dir.y, dir.x)
    var weapon := Sprite2D.new()
    weapon.texture = tex
    weapon.position = player.position + dir * 13.0 + Vector2(0, -12)
    weapon.rotation = base - PI / 2.0 - 1.1
    weapon.scale = Vector2(1.5, 1.5)
    weapon.z_index = 11
    _world.add_child(weapon)
    var tw := create_tween()
    tw.set_parallel(true)
    tw.tween_property(weapon, "rotation", base - PI / 2.0 + 1.1, 0.14) \
        .set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
    tw.tween_property(weapon, "scale", Vector2(1.15, 1.15), 0.14)
    tw.tween_property(weapon, "modulate:a", 0.0, 0.12).set_delay(0.1)
    tw.chain().tween_callback(weapon.queue_free)

## Дуга удара (шаг 19): белая дуга slash_arc.png в цвет оружия/заклинания.
func _spawn_slash_arc(pos: Vector2, color: Color) -> void:
    if _slash_tex == null:
        return
    var arc := Sprite2D.new()
    arc.texture = _slash_tex
    arc.position = pos
    arc.modulate = Color(color.r, color.g, color.b, 0.9)
    var mat := CanvasItemMaterial.new()
    mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
    arc.material = mat
    arc.rotation = randf_range(-0.5, 0.5)
    arc.scale = Vector2(0.4, 0.4)
    arc.z_index = 11
    _world.add_child(arc)
    var tw := create_tween()
    tw.set_parallel(true)
    tw.tween_property(arc, "scale", Vector2(1.1, 1.1), 0.16) \
        .set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
    tw.tween_property(arc, "modulate:a", 0.0, 0.2).set_delay(0.08)
    tw.chain().tween_callback(arc.queue_free)

## Импакт попадания (шаг 19): яркая вспышка искр из точки удара.
func _spawn_hit_impact(pos: Vector2, color: Color) -> void:
    var impact := CPUParticles2D.new()
    impact.position = pos
    impact.amount = 14
    impact.lifetime = 0.18
    impact.one_shot = true
    impact.explosiveness = 1.0
    impact.direction = Vector2(0, -1)
    impact.spread = 180.0
    impact.initial_velocity_min = 60.0
    impact.initial_velocity_max = 140.0
    impact.scale_amount_min = 1.0
    impact.scale_amount_max = 2.4
    impact.color = color
    impact.emitting = true
    impact.z_index = 10
    _world.add_child(impact)
    var tw := create_tween()   # шаг 23: твин умирает вместе со сценой
    tw.tween_interval(0.5)
    tw.tween_callback(func() -> void:
        if is_instance_valid(impact):
            impact.queue_free())

## След снаряда (шаг 19): одна тающая искра.
func _spawn_trail_dot(pos: Vector2, color: Color) -> void:
    var dot := CPUParticles2D.new()
    dot.position = pos
    dot.amount = 1
    dot.lifetime = 0.28
    dot.one_shot = true
    dot.explosiveness = 1.0
    dot.direction = Vector2.ZERO
    dot.spread = 0.0
    dot.initial_velocity_min = 0.0
    dot.initial_velocity_max = 0.0
    dot.scale_amount_min = 1.4
    dot.scale_amount_max = 2.2
    dot.color = Color(color.r, color.g, color.b, 0.65)
    dot.emitting = true
    dot.z_index = 10
    _world.add_child(dot)
    var tw := create_tween()   # шаг 23: твин умирает вместе со сценой
    tw.tween_interval(0.4)
    tw.tween_callback(func() -> void:
        if is_instance_valid(dot):
            dot.queue_free())

## Всплывающее число урона над NPC: поднимается и тает.
func _spawn_damage_label(pos: Vector2, damage: int) -> void:
    var label := Label.new()
    label.text = "-%d" % damage
    label.position = pos + Vector2(-14, 0)
    label.size = Vector2(28, 14)
    label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    label.add_theme_font_size_override("font_size", 11)
    label.add_theme_color_override("font_color", Color(1.0, 0.42, 0.36))
    label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.8))
    label.add_theme_constant_override("shadow_offset_y", 1)
    label.z_index = 12
    _world.add_child(label)
    var tw := create_tween()
    tw.set_parallel(true)
    tw.tween_property(label, "position:y", label.position.y - 16.0, 0.6) \
        .set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
    tw.tween_property(label, "modulate:a", 0.0, 0.6).set_delay(0.15)
    tw.chain().tween_callback(label.queue_free)

## Короткая вспышка боли на спрайте NPC (твин хранится, чтобы при смерти
## его можно было погасить и труп остался серым). Разъярённый демон
## после вспышки возвращается не к белому, а к своей красной ауре (шаг 12).
func _flash_npc(npc: Dictionary) -> void:
    var spr: AnimatedSprite2D = npc["sprite"]
    var restore := Color.WHITE
    if String(npc["id"]) == "demon" and Game.demon_enraged:
        restore = DEMON_RAGE_TINT
    var old: Tween = npc.get("flash_tween")
    if old != null and old.is_valid():
        old.kill()
    spr.modulate = Color(1.0, 0.35, 0.35)
    var tw := create_tween()
    tw.tween_property(spr, "modulate", restore, 0.25)
    npc["flash_tween"] = tw

## Показать/обновить полоску хп NPC (после первого удара остаётся видимой).
func _show_npc_hp_bar(npc: Dictionary) -> void:
    var bar: ProgressBar = npc["hp_bar"]
    bar.max_value = int(npc["max_hp"])
    bar.value = int(npc["hp"])
    bar.visible = true

## NPC убит: Game запоминает на всю сессию, труп падает и сероет,
## сквозь него можно пройти, разговор и торговля больше недоступны.
## Остальные NPC узнают об этом через Game.dead_npcs (см. npc_say).
## Шаг 13: демон умирает по-настоящему — Game.defeat_demon_permanently():
## убитые NPC оживают и забывают убийства, демон больше не возвращается
## (ни у края мира, ни в подземелье), состояние пишется в сейв v6.
func _kill_npc(npc: Dictionary) -> void:
    var npc_id := String(npc["id"])
    npc["dead"] = true
    Game.kill_npc(npc_id)
    var npc_name := String((npc["data"] as Dictionary).get("name", npc_id))
    var spr: AnimatedSprite2D = npc["sprite"]
    var flash: Tween = npc.get("flash_tween")
    if flash != null and flash.is_valid():
        flash.kill()   # вспышка боли не должна перекрасить труп обратно
    spr.stop()
    spr.rotation = PI / 2.0   # падает на бок
    spr.modulate = Color(0.5, 0.47, 0.55)
    var bar: ProgressBar = npc["hp_bar"]
    bar.visible = false
    var pointer: Sprite2D = npc["pointer"]
    pointer.visible = false
    (npc["name_label"] as Label).add_theme_color_override("font_color", Color(0.52, 0.52, 0.58))
    # через труп можно ходить, кликать по нему больше нельзя
    var body: StaticBody2D = npc["body"]
    (body.get_child(0) as CollisionShape2D).set_deferred("disabled", true)
    var area: Area2D = npc["area"]
    area.set_deferred("monitorable", false)
    area.set_deferred("monitoring", false)
    area.input_pickable = false
    _spell_poof((npc["node"] as Node2D).position + Vector2(0, -12),
        Color(0.6, 0.6, 0.66))
    if npc_id == "demon":
        Game.defeat_demon_permanently()
        # шаг 19: демона победили — герой получает опыт и, возможно, уровень
        Game.add_xp(Game.DEMON_XP)
        _show_hint(DEMON_DEFEATED_HINT, 5.0)
    else:
        _show_hint("%s больше нет. Остальные жители это запомнят... А кое-кто у края улицы улыбается." % npc_name, 4.0)

## Шаг 13: ожившие жертвы демона (сигнал Game.npcs_revived): трупы встают,
## хп восстанавливается, разговоры и торговля снова доступны.
## Труп самого демона остаётся трупом — он повержен навсегда.
func _revive_npcs_in_world() -> void:
    for npc in _npcs:
        if String(npc["id"]) == "demon" or not bool(npc.get("dead", false)):
            continue
        npc["dead"] = false
        npc["hp"] = int(npc["max_hp"])
        var spr: AnimatedSprite2D = npc["sprite"]
        spr.rotation = 0.0
        spr.modulate = Color.WHITE
        spr.play("idle_down")
        (npc["hp_bar"] as ProgressBar).visible = false
        (npc["name_label"] as Label).add_theme_color_override("font_color", COLOR_GOLD)
        var body: StaticBody2D = npc["body"]
        (body.get_child(0) as CollisionShape2D).set_deferred("disabled", false)
        var area: Area2D = npc["area"]
        area.set_deferred("monitorable", true)
        area.set_deferred("monitoring", true)
        area.input_pickable = true

# ------------------------------------------- уровни героя (шаг 19)

## Повышение уровня — красиво: фанфары, золотой взрыв вокруг героя и
## большая надпись «УРОВЕНЬ N!» в центре экрана (та же, что в данже).
func _on_level_up(new_level: int) -> void:
    Sfx.play("levelup")
    if player != null:
        for i in range(3):
            _spell_poof(player.position + Vector2(0, -8 - i * 9),
                Color(1.0, 0.84, 0.2))
        _spawn_slash_arc(player.position + Vector2(0, -12),
            Color(1.0, 0.84, 0.2))
    if _level_layer == null:
        _level_layer = CanvasLayer.new()
        _level_layer.name = "LevelUp"
        _level_layer.layer = 25
        add_child(_level_layer)
    var center := CenterContainer.new()
    center.set_anchors_preset(Control.PRESET_FULL_RECT)
    center.mouse_filter = Control.MOUSE_FILTER_IGNORE
    center.offset_bottom = -UI_BAR_H
    _level_layer.add_child(center)
    var label := Label.new()
    label.text = "УРОВЕНЬ %d!" % new_level
    label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    label.add_theme_font_size_override("font_size", 30)
    label.add_theme_color_override("font_color", Color(1.0, 0.84, 0.2))
    label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.9))
    label.add_theme_constant_override("shadow_offset_y", 2)
    label.modulate.a = 0.0
    center.add_child(label)
    var tw := create_tween()
    tw.tween_property(label, "modulate:a", 1.0, 0.2)
    tw.tween_interval(1.4)
    tw.tween_property(label, "modulate:a", 0.0, 0.5)
    tw.tween_callback(func() -> void: center.queue_free())
    _show_hint("Уровень %d: урон и ХП выросли вдвое!" % new_level, 3.0)

## Полоса опыта в HUD — по сигналу Game.xp_changed.
func _on_xp_changed(xp_value: int, xp_need: int) -> void:
    if _hud_xp != null and is_instance_valid(_hud_xp):
        _hud_xp.max_value = xp_need
        _hud_xp.value = xp_value

# ---------------------------------------------------------------- джойстик

func _build_joystick() -> void:
    # шаг 8 (фикс): VirtualJoystick — скриптовый класс, ClassDB его не видит
    # (class_exists всегда false), поэтому джойстик никогда не спавнился.
    # Загружаем скрипт напрямую и создаём инстанс через GDScript.new().
    var script: GDScript = load("res://scripts/ui/virtual_joystick.gd") as GDScript
    if script == null or not script.can_instantiate():
        push_warning("VirtualJoystick недоступен: только клавиатура")
        return
    var joystick: Control = script.new() as Control
    if joystick == null:
        return
    # шаг 10/11: джойстик — часть нижней консоли UI, вне экрана ходьбы
    if _hud_bar == null:
        return
    joystick.size = Vector2(100, 100)
    joystick.position = BAR_JOY_POS
    _hud_bar.add_child(joystick)
    _joystick = joystick

# ---------------------------------------------------------------- смерть героя (шаг 12)

## Экран смерти: затемнение поверх всего («ТЫ ПАЛ») с кнопкой пробуждения.
## Штрафов за смерть нет (ЗАГЛУШКА): герой очинается в замке с полными
## хп/маной, демон остаётся в ярости и продолжает охоту.
func _build_death_ui() -> void:
    _death_layer = CanvasLayer.new()
    _death_layer.name = "DeathOverlay"
    _death_layer.layer = 30
    _death_layer.visible = false
    add_child(_death_layer)
    var dim := ColorRect.new()
    dim.name = "Dim"
    dim.set_anchors_preset(Control.PRESET_FULL_RECT)
    dim.color = Color(0.02, 0.02, 0.06, 0.82)
    _death_layer.add_child(dim)
    var center := CenterContainer.new()
    center.set_anchors_preset(Control.PRESET_FULL_RECT)
    center.mouse_filter = Control.MOUSE_FILTER_IGNORE
    dim.add_child(center)
    var panel := PanelContainer.new()
    panel.custom_minimum_size = Vector2(300, 0)
    panel.add_theme_stylebox_override("panel", UiStyle.panel_style())
    center.add_child(panel)
    var vbox := VBoxContainer.new()
    vbox.add_theme_constant_override("separation", 10)
    panel.add_child(vbox)
    var title := Label.new()
    title.text = DEATH_TITLE
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 22)
    title.add_theme_color_override("font_color", Color(0.85, 0.3, 0.3))
    vbox.add_child(title)
    var body := Label.new()
    body.text = DEATH_TEXT
    body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    body.add_theme_font_size_override("font_size", 11)
    body.add_theme_color_override("font_color", Color(0.72, 0.75, 0.84))
    vbox.add_child(body)
    var btn := Button.new()
    btn.text = DEATH_BUTTON
    btn.custom_minimum_size = Vector2(0, 38)
    UiStyle.style_button(btn, 13)
    btn.pressed.connect(_respawn_player)
    vbox.add_child(btn)

## Хп героя упало до нуля — показать экран смерти (один раз).
func _on_player_hp_changed(hp: int, _max_hp: int) -> void:
    if hp <= 0 and not _player_dead:
        _player_dead = true
        if _death_layer != null:
            _death_layer.visible = true

## Пробуждение: полные хп/мана, герой в замке. Шаг 13: ярость демона ГАСНЕТ
## (Game.reset_demon_rage) — демон снова мирен и возвращается к краю улицы.
func _respawn_player() -> void:
    _player_dead = false
    if _death_layer != null:
        _death_layer.visible = false
    Game.reset_demon_rage()
    Game.heal_hp(Game.max_hp() * 2)   # излишек срезается до максимума
    if Game.is_mage():
        Game.restore_mana(Game.max_mana() * 2)
    player.position = Vector2(WorldMap.PLAYER_SPAWN) \
        * float(WorldMap.TILE_SIZE) + Vector2(8, 8)
    if _camera != null:
        _camera.reset_smoothing()
    var demon := _demon_record()
    if not demon.is_empty():
        demon["atk_cd"] = 2.0
    _show_hint(RESPAWN_HINT, 4.0)

# ---------------------------------------------------------------- HUD

func _build_hud() -> void:
    var layer := CanvasLayer.new()
    layer.name = "HUD"
    layer.layer = 20
    add_child(layer)

    # --- шаг 10: нижняя консоль UI — непрозрачная полоса вне экрана ходьбы.
    # Панель героя и кнопки кладём прямо в слой HUD (абсолютные координаты
    # в полосе консоли), джойстик — внутрь консоли (см. _build_joystick).
    _hud_bar = Control.new()
    _hud_bar.name = "HudBar"
    _hud_bar.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
    _hud_bar.offset_top = -UI_BAR_H
    layer.add_child(_hud_bar)
    var bar_bg := Panel.new()
    bar_bg.name = "BarBackground"
    bar_bg.set_anchors_preset(Control.PRESET_FULL_RECT)
    var bar_style := StyleBoxFlat.new()
    bar_style.bg_color = Color(0.07, 0.08, 0.13)
    bar_style.border_color = Color(0.5, 0.42, 0.16)
    bar_style.set_border_width_all(0)
    bar_style.border_width_top = 2
    bar_bg.add_theme_stylebox_override("panel", bar_style)
    _hud_bar.add_child(bar_bg)
    var bar_top := 0.0   # координаты внутри нижней панели

    # мини-панель героя: портрет + имя + золото (в консоли, шаг 10)
    var hero_panel := PanelContainer.new()
    hero_panel.position = Vector2(BAR_HERO_POS.x, bar_top + BAR_HERO_POS.y)
    var hero_style := UiStyle.flat_style(Color(0.11, 0.12, 0.19), Color(0.5, 0.42, 0.16))
    hero_style.content_margin_left = 6
    hero_style.content_margin_right = 10
    hero_style.content_margin_top = 4
    hero_style.content_margin_bottom = 4
    hero_panel.add_theme_stylebox_override("panel", hero_style)
    _hud_bar.add_child(hero_panel)
    var hero_row := HBoxContainer.new()
    hero_row.add_theme_constant_override("separation", 7)
    hero_panel.add_child(hero_row)
    var hero_face := TextureRect.new()
    hero_face.custom_minimum_size = Vector2(28, 28)
    hero_face.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    hero_face.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
    hero_face.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
    hero_face.texture = load(String(Game.HEROES.get(Game.hero_id, {}).get("portrait", "")))
    hero_row.add_child(hero_face)
    var hero_box := VBoxContainer.new()
    hero_box.add_theme_constant_override("separation", 0)
    hero_row.add_child(hero_box)
    var hero_name := Label.new()
    # шаг 19: рядом с именем — уровень героя
    hero_name.text = "%s · ур. %d" % [Game.hero_title(), Game.level]
    hero_name.add_theme_font_size_override("font_size", 10)
    hero_name.add_theme_color_override("font_color", Color(0.85, 0.88, 0.94))
    hero_box.add_child(hero_name)
    _hud_gold = Label.new()
    _hud_gold.add_theme_font_size_override("font_size", 12)
    _hud_gold.add_theme_color_override("font_color", COLOR_GOLD)
    _hud_gold.text = "Золото: %d" % Game.gold
    hero_box.add_child(_hud_gold)
    _cb_gold = func(new_gold: int) -> void:
        if is_instance_valid(_hud_gold):
            _hud_gold.text = "Золото: %d" % new_gold
    Game.gold_changed.connect(_cb_gold)

    # шаг 7: чем герой бьёт (кулаки или оружие из сумки); шаг 10: автоперенос —
    # длинное название оружия не распирает панель в узкой консоли
    _hud_weapon = Label.new()
    _hud_weapon.add_theme_font_size_override("font_size", 9)
    _hud_weapon.add_theme_color_override("font_color", Color(0.62, 0.66, 0.74))
    _hud_weapon.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    _hud_weapon.text = _weapon_text()
    hero_box.add_child(_hud_weapon)
    _cb_equipped = func(_weapon_id: String) -> void:
        if is_instance_valid(_hud_weapon):
            _hud_weapon.text = _weapon_text()
    Game.equipped_changed.connect(_cb_equipped)

    # шаг 6: полоса здоровья героя (видна всем героям)
    _hud_hp = ProgressBar.new()
    _hud_hp.custom_minimum_size = Vector2(74, 8)
    _hud_hp.min_value = 0
    _hud_hp.max_value = Game.max_hp()
    _hud_hp.value = Game.hp
    _hud_hp.show_percentage = false
    _hud_hp.add_theme_stylebox_override("background", _bar_style(Color(0.09, 0.08, 0.1), Color(0.45, 0.2, 0.2)))
    _hud_hp.add_theme_stylebox_override("fill", _bar_style(Color(0.72, 0.26, 0.26), Color(0.72, 0.26, 0.26)))
    hero_box.add_child(_hud_hp)
    _cb_hp = func(hp: int, max_hp: int) -> void:
        if is_instance_valid(_hud_hp):
            _hud_hp.max_value = max_hp
            _hud_hp.value = hp
    Game.hp_changed.connect(_cb_hp)
    # шаг 19: полоса опыта до следующего уровня
    _hud_xp = ProgressBar.new()
    _hud_xp.custom_minimum_size = Vector2(74, 5)
    _hud_xp.min_value = 0
    _hud_xp.max_value = Game.xp_needed()
    _hud_xp.value = Game.xp
    _hud_xp.show_percentage = false
    _hud_xp.add_theme_stylebox_override("background",
        _bar_style(Color(0.08, 0.08, 0.12), Color(0.35, 0.3, 0.16)))
    _hud_xp.add_theme_stylebox_override("fill",
        _bar_style(Color(0.85, 0.7, 0.2), Color(0.85, 0.7, 0.2)))
    hero_box.add_child(_hud_xp)
    _cb_xp = func(xp_value: int, xp_need: int) -> void:
        if is_instance_valid(_hud_xp):
            _hud_xp.max_value = xp_need
            _hud_xp.value = xp_value
    Game.xp_changed.connect(_cb_xp)
    _cb_level = func(new_level: int) -> void:
        if is_instance_valid(hero_name):
            hero_name.text = "%s · ур. %d" % [Game.hero_title(), new_level]
        # урон в руках вырос вместе с уровнем — обновить строку HUD
        if is_instance_valid(_hud_weapon):
            _hud_weapon.text = _weapon_text()
    Game.level_up.connect(_cb_level)

    # шаг 6: полоса маны — только у мага (новый показатель при выборе мага)
    if Game.is_mage():
        _hud_mana = ProgressBar.new()
        _hud_mana.custom_minimum_size = Vector2(74, 8)
        _hud_mana.min_value = 0
        _hud_mana.max_value = Game.max_mana()
        _hud_mana.value = Game.mana
        _hud_mana.show_percentage = false
        _hud_mana.add_theme_stylebox_override("background", _bar_style(Color(0.08, 0.09, 0.13), Color(0.2, 0.3, 0.45)))
        _hud_mana.add_theme_stylebox_override("fill", _bar_style(Color(0.3, 0.6, 0.85), Color(0.3, 0.6, 0.85)))
        hero_box.add_child(_hud_mana)
        _cb_mana = func(mana: int, max_mana: int) -> void:
            if is_instance_valid(_hud_mana):
                _hud_mana.max_value = max_mana
                _hud_mana.value = mana
        Game.mana_changed.connect(_cb_mana)

    # --- шаг 10/11: кнопки действий — столбик в правой части консоли,
    # вертикально центрированы. Порядок прежний: МЕНЮ, СУМКА, (МАГИЯ), УДАР.
    # Шаг 11: подписи без клавиш (клавиши — в подсказке у края экрана),
    # размер 64x22 — консоль стала ниже, экран ходьбы больше.
    # Шаг 20: приёмы и удар живут на клавишах (подсказка у края экрана).
    # Шаг 21 (автор): СУМКА вернулась в кнопки — инвентарь открывается
    # одним нажатием, как и раньше.
    var actions: Array = [
        {"text": "МЕНЮ", "font": 10, "cb": _on_menu_pressed},
        {"text": "СУМКА", "font": 9, "cb": _on_bag_pressed},
        {"text": "СОХРАНИТЬ", "font": 9, "cb": _on_save_pressed},
        {"text": "ЗАГРУЗИТЬ", "font": 9, "cb": _on_load_pressed},
    ]
    var total_h := float(actions.size()) * BAR_BTN_SIZE.y \
        + float(actions.size() - 1) * (BAR_BTN_STEP - BAR_BTN_SIZE.y)
    var start_y := (UI_BAR_H - total_h) / 2.0
    for i in range(actions.size()):
        var spec: Dictionary = actions[i]
        var btn := Button.new()
        btn.text = String(spec["text"])
        btn.position = Vector2(BAR_BUTTONS_X, bar_top + start_y + float(i) * BAR_BTN_STEP)
        _style_small_button(btn, int(spec["font"]))
        btn.size = BAR_BTN_SIZE
        btn.pressed.connect(spec["cb"] as Callable)
        btn.set_meta("action_button", true)
        _hud_bar.add_child(btn)

    _resize_layout.call_deferred()

    _hud_hint = Label.new()
    # шаг 10: подсказки — у верхнего края экрана ходьбы (временные, гаснут:
    # внизу теперь консоль UI, перекрывать мир они больше не должны)
    _hud_hint.set_anchors_preset(Control.PRESET_TOP_WIDE)
    _hud_hint.offset_top = 4.0
    _hud_hint.offset_bottom = 42.0
    _hud_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    _hud_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    _hud_hint.add_theme_font_size_override("font_size", 12)
    _hud_hint.add_theme_color_override("font_color", Color(0.85, 0.88, 0.94))
    _hud_hint.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.8))
    _hud_hint.add_theme_constant_override("shadow_offset_y", 1)
    layer.add_child(_hud_hint)
    Controls.bindings_changed.connect(_refresh_controls_hint)
    _refresh_controls_hint()

## Строка «В руках: …» в HUD — что у героя в руках и сколько урона.
func _weapon_text() -> String:
    return "В руках: %s · %d ур." % [Game.strike_title(), Game.strike_damage()]

func _show_hint(text: String, seconds: float) -> void:
    # фикс: предыдущий твин подсказки гасим, чтобы два твина не мигали в борьбе
    if _hint_tween != null and _hint_tween.is_valid():
        _hint_tween.kill()
    _hud_hint.text = text
    _hud_hint.modulate.a = 1.0
    _hint_tween = create_tween()
    _hint_tween.tween_interval(seconds)
    _hint_tween.tween_property(_hud_hint, "modulate:a", 0.0, 0.6)

## Стиль полосы ХП/маны: рамка 1 px, без внутренних отступов.
func _bar_style(bg: Color, border: Color) -> StyleBoxFlat:
    var sb := StyleBoxFlat.new()
    sb.bg_color = bg
    sb.border_color = border
    sb.set_border_width_all(1)
    sb.content_margin_left = 1.0
    sb.content_margin_right = 1.0
    sb.content_margin_top = 1.0
    sb.content_margin_bottom = 1.0
    return sb

## Кнопка действия в нижней консоли (шаг 11): те же цвета, но компактные
## отступы — иначе Button не даст себе стать ниже 29 px и столбик 64x22
## не влезет в консоль высотой 112 px.
func _style_small_button(btn: Button, font_size: int) -> void:
    UiStyle.style_button(btn, font_size)
    for state in ["normal", "hover", "pressed"]:
        var sb := btn.get_theme_stylebox(state)
        if sb is StyleBoxFlat:
            (sb as StyleBoxFlat).content_margin_top = 3.0
            (sb as StyleBoxFlat).content_margin_bottom = 3.0
            (sb as StyleBoxFlat).content_margin_left = 4.0
            (sb as StyleBoxFlat).content_margin_right = 4.0

func _on_menu_pressed() -> void:
    Platform.gameplay_stop()
    get_tree().change_scene_to_file(MAIN_SCENE)

## Кнопка СУМКА (шаг 21): инвентарь вернулся в кнопки HUD — то же,
## что клавиша toggle_inventory (открыть/закрыть).
func _on_bag_pressed() -> void:
    if _inventory_ui.visible:
        _inventory_ui.close()
    else:
        _inventory_ui.open()

## Кнопка СОХРАНИТЬ (шаг 20): быстрое сохранение в текущий слот.
func _on_save_pressed() -> void:
    if Game.current_slot < 1:
        _show_hint("Сохранение недоступно: слот не выбран", 2.0)
        return
    Saves.request_save()
    _show_hint("Игра сохранена в слот %d" % Game.current_slot, 2.0)

## Кнопка ЗАГРУЗИТЬ (шаг 20): перечитать текущий слот (мир собирается заново).
func _on_load_pressed() -> void:
    if Game.current_slot < 1 or not Platform.has_slot(Game.current_slot):
        _show_hint("Загрузить нечего: слот пуст", 2.0)
        return
    if not Game.continue_run(Game.current_slot):
        _show_hint("Сейв повреждён: загрузить не вышло", 2.0)
        return
    Platform.gameplay_stop()
    get_tree().reload_current_scene()

## Пересчитывается при изменении размера окна и повороте устройства.
func _resize_layout() -> void:
    var view_size := get_viewport_rect().size
    if is_instance_valid(_walk_holder):
        _walk_holder.size = Vector2(view_size.x, view_size.y - UI_BAR_H)
    if is_instance_valid(_hud_bar):
        for child in _hud_bar.get_children():
            if child is Control and child.has_meta("action_button"):
                child.size = BAR_BTN_SIZE
                child.position.x = view_size.x - BAR_BTN_SIZE.x - 4.0


func _refresh_controls_hint() -> void:
    if _hud_hint == null:
        return
    _hud_hint.add_theme_font_size_override("font_size", 10)
    _hud_hint.tooltip_text = ""
    for action in Controls.get_actions():
        _hud_hint.tooltip_text += Controls.get_action_label(action) + ": " + Controls.get_binding_text(action) + "\n"
    _show_hint(Controls.get_hud_hint(Game.is_mage(),
        String(Game.ability_info("q").get("hint", "")),
        String(Game.ability_info("special").get("hint", "")),
        String(Game.ability_info("t").get("hint", ""))), 5.0)

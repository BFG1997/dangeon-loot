# -*- coding: utf-8 -*-
"""Шаг 28: генератор PROJECT_DUMP_FULL.md — ПОЛНЫЙ дамп кода проекта
«Dungeon Loot» для контекста нового чата (в отличие от кураторского
PROJECT_DUMP.md здесь весь код целиком).

Перегенерировать после правок кода:
    python3 tools/gen_project_dump_full.py

Собирает: project.godot, docs/*.md, все .gd (autoloads, data, audio,
ui, components, сцены, тесты) и все .tscn — каждый файл отдельной
секцией с путём res://... и подсветкой синтаксиса."""
from pathlib import Path
from datetime import date

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "PROJECT_DUMP_FULL.md"

GD = {".gd"}
TEXT = {".tscn", ".godot"}

def collect(subdir: str, patterns: list) -> list:
    base = ROOT / subdir
    if not base.exists():
        return []
    out: list = []
    for pat in patterns:
        out.extend(sorted(base.rglob(pat)))
    return out

def block(path: Path) -> str:
    rel = path.relative_to(ROOT).as_posix()
    try:
        text = path.read_text(encoding="utf-8")
    except Exception as e:
        return f"\n### res://{rel}\n\n(не прочитан: {e})\n"
    lang = "gdscript" if path.suffix in GD else ""
    return f"\n### res://{rel}\n\n```{lang}\n{text}```\n"

def main() -> None:
    files: list = []

    godot = ROOT / "project.godot"
    files.append(godot)
    for doc in sorted((ROOT / "docs").glob("*.md")):
        files.append(doc)
    files += collect("scripts", ["*.gd"])
    files += collect("scripts/components", ["*.gd"])
    files += collect("scenes", ["*.gd", "*.tscn"])
    files += collect("tests", ["*.gd", "*.tscn"])

    # дедупликация с сохранением порядка
    seen = set()
    ordered = []
    for f in files:
        if f not in seen:
            seen.add(f)
            ordered.append(f)

    head = [
        "# ДАМП ПРОЕКТА «DUNGEON LOOT» — ПОЛНЫЙ (весь код)",
        "",
        f"Дата генерации: {date.today().isoformat()}. Генератор: `tools/gen_project_dump_full.py`.",
        "",
        "Состояние: выполнены шаги 1–25, ФИКС ПК-интерфейса (шаг 26) и",
        "шаг 28 (техдолг: декомпозиция монолитов в components/, документация,",
        "репозиторий). Все 13 наборов тестов зелёные (945 проверок, headless).",
        "Дальше по PLAN.md: визуальная составляющая и боевая система, релиз.",
        "",
        "Структура кода после шага 28:",
        "- `scripts/components/strike_fx.gd` — эффекты ударов и снарядов;",
        "- `scripts/components/hud_builder.gd` — сборка HUD мира и данжа;",
        "- `scripts/components/foe_ai.gd` — спавн и ИИ врагов (вкл. демона мира);",
        "- `scripts/components/boss_ai.gd` — тактика Ктулху и Шуб-Ниггурат;",
        "- `scripts/components/dialogue_link.gd` — диалоговая привязка.",
        "",
        "---",
    ]

    parts = ["\n".join(head)]
    for f in ordered:
        parts.append(block(f))

    OUT.write_text("\n".join(parts), encoding="utf-8")
    kb = OUT.stat().st_size / 1024
    print(f"PROJECT_DUMP_FULL.md: {len(ordered)} файлов, {kb:.0f} КБ")

if __name__ == "__main__":
    main()

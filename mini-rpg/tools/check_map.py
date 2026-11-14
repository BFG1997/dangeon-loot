# -*- coding: utf-8 -*-
"""Проверка world_map.gd: проходимость от спавна до всех NPC/точек интереса."""
import os
import re
from collections import deque

src = open(os.path.join(os.path.dirname(__file__), "..",
                        "scripts/data/world_map.gd")).read()
rows = re.findall(r'^\s+"([#WDkBFRdpqcg.,fsVm123456]{30})",?$', src, re.M)
assert len(rows) == 56, f"рядов: {len(rows)}"
SOLID = set("#BDFRWkf")
start = (14, 13)
targets = {"zlus": (5, 5), "lira": (16, 15), "gura": (6, 29), "viras": (23, 31),
           "glot": (22, 9), "zoran": (8, 11),
           "edge": (14, 44), "fountain": (17, 23), "stall_r": (8, 33), "stall_b": (22, 38),
           "crystal": (4, 41), "doors": (4, 1), "throne": (14, 13)}
seen = {start}
q = deque([start])
while q:
    x, y = q.popleft()
    for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
        nx, ny = x + dx, y + dy
        if 0 <= nx < 30 and 0 <= ny < 56 and (nx, ny) not in seen and rows[ny][nx] not in SOLID:
            seen.add((nx, ny))
            q.append((nx, ny))
bad = 0
for name, (tx, ty) in targets.items():
    ok = any((tx + dx, ty + dy) in seen for dx in range(-1, 2) for dy in range(-1, 2))
    if not ok:
        bad += 1
    print(name, "достижим" if ok else "!!! БЛОКИРОВАН")
print("достижимо клеток:", len(seen))
print("ПРОВАЛОВ:", bad)

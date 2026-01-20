#!/usr/bin/env python3

import configparser
from pathlib import Path
import json

DIRS = [
    Path.home() / ".local/share/applications",
    Path("/var/lib/flatpak/exports/share/applications"),
    Path("/usr/local/share/applications"),
    Path("/usr/share/applications"),
]

apps = {}

for base in DIRS:
    if not base.exists():
        continue

    for file in base.glob("*.desktop"):
        cp = configparser.ConfigParser(interpolation=None)
        try:
            cp.read(file, encoding="utf-8")
        except Exception:
            continue

        if "Desktop Entry" not in cp:
            continue

        e = cp["Desktop Entry"]

        # ❌ không có Exec → bỏ
        if not e.get("Exec"):
            continue

        # ❌ NoDisplay / Hidden
        if e.get("NoDisplay", "false").lower() == "true":
            continue
        if e.get("Hidden", "false").lower() == "true":
            continue

        # ❌ OnlyShowIn / NotShowIn (đơn giản hoá)
        if "OnlyShowIn" in e or "NotShowIn" in e:
            continue

        app_id = file.stem

        apps[app_id] = {
            "id": app_id,
            "name": e.get("Name", ""),
            "comment": e.get("Comment", ""),
            "exec": e.get("Exec", ""),
            "icon": e.get("Icon", ""),
            "path": str(file),
        }

print(json.dumps(list(apps.values()), ensure_ascii=False))


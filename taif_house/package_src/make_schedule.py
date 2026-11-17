"""make_schedule.py · Taif / Palm House · writes package_src/room_schedule.csv (every room of both floors: axis size, axis area, clear area)
from the presentation's own schedule (typst query presentation.typ: the same numbers as sheet 08, clear = inside the walls as drawn).

Run from anywhere:   python taif_house/package_src/make_schedule.py [out.csv]
"""
import csv
import json
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent          # taif_house
OUT = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "package_src" / "room_schedule.csv"
typst = shutil.which("typst")
r = subprocess.run([typst, "query", "--root", str(ROOT), str(ROOT / "presentation.typ"), "metadata", "--field", "value"], capture_output=True, text=True, encoding="utf-8")
if r.returncode != 0:
    sys.exit("typst query failed: " + r.stderr[-400:])
data = next(m for m in json.loads(r.stdout) if isinstance(m, dict) and "gf" in m and "ff" in m)
rows = []
for floor, key in (("GF", "gf"), ("FF", "ff")):
    for room in data[key]:
        rows.append({"floor": floor, "id": room["id"], "name": room["name"], "axis_size_m": room["size"], "axes_m2": room["axes"], "clear_m2": room["clear"]})
with open(OUT, "w", encoding="utf-8", newline="") as f:
    w = csv.DictWriter(f, fieldnames=["floor", "id", "name", "axis_size_m", "axes_m2", "clear_m2"])
    w.writeheader()
    w.writerows(rows)
    w.writerow({"floor": "GF", "id": "total", "name": "Ground-floor rooms (axes, the courtyard excluded)", "axis_size_m": "", "axes_m2": data["gf-area"], "clear_m2": ""})
    w.writerow({"floor": "FF", "id": "total", "name": "First-floor rooms (axes, the suite court excluded)", "axis_size_m": "", "axes_m2": data["ff-area"], "clear_m2": ""})
    w.writerow({"floor": "", "id": "footprint", "name": "Outside footprint incl. the courtyard", "axis_size_m": "", "axes_m2": data["footprint"], "clear_m2": ""})
print(f"{OUT}: {len(rows)} rooms (GF {sum(1 for r in rows if r['floor'] == 'GF')}, FF {sum(1 for r in rows if r['floor'] == 'FF')})")

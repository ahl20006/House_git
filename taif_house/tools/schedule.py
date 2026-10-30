"""schedule.py · Taif / Palm House V6.3 · room schedule of the ground floor: axis sizes, axis areas and clear (finished-face) areas.
(The first-floor schedule with clear areas is on design_ff.pdf page 3, and both floors are on presentation sheet 08.)

Run from anywhere:   python taif_house/tools/schedule.py          (prints a Markdown table)
Clear areas: every room edge moves inwards by half its wall: 250 mm on the building outline, 100 mm on the dry
partition between laundry and maid room (x = 10.65), 200 mm everywhere else. Concept values, not survey values.
"""
import ast
import csv
import math
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent          # taif_house
OUT, IN, DRY = 0.25, 0.20, 0.10
_m = re.search(r"#let outline-csv-gf\s*=\s*(\(.*\))", (ROOT / "design_gf.typ").read_text(encoding="utf-8"))
OUTLINE = list(ast.literal_eval(_m.group(1)))                                     # read from design_gf.typ (CSV)
DRY_X = 10.65                                                                  # laundry / maid room partition


def area(P):
    return abs(sum(P[i][0] * P[(i + 1) % len(P)][1] - P[(i + 1) % len(P)][0] * P[i][1] for i in range(len(P)))) / 2


def on_segment(p, a, b, tol=0.002):
    ax, ay = b[0] - a[0], b[1] - a[1]
    L = math.hypot(ax, ay)
    cross = abs((p[0] - a[0]) * ay - (p[1] - a[1]) * ax) / L
    t = ((p[0] - a[0]) * ax + (p[1] - a[1]) * ay) / (L * L)
    return cross < tol and -tol <= t <= 1 + tol


def wall(a, b):
    edges = list(zip(OUTLINE, OUTLINE[1:] + OUTLINE[:1]))
    if any(on_segment(a, *e) and on_segment(b, *e) for e in edges):
        return OUT
    if abs(a[0] - DRY_X) < 1e-6 and abs(b[0] - DRY_X) < 1e-6:
        return DRY
    return IN


def clear(P):
    """Inside the wall faces: every edge moved inward by half its wall and the adjacent offset edges intersected at each corner
    (the presentation's offset-poly; V6.3: it also works for concave rooms such as the lobby with its lift-door notch)."""
    s = 1 if sum(P[i][0] * P[(i + 1) % len(P)][1] - P[(i + 1) % len(P)][0] * P[i][1] for i in range(len(P))) > 0 else -1
    n = len(P)

    def offset_line(i):
        a, b = P[i], P[(i + 1) % n]
        L = math.hypot(b[0] - a[0], b[1] - a[1])
        d = ((b[0] - a[0]) / L, (b[1] - a[1]) / L)
        nv = (-d[1] * s, d[0] * s)
        off = wall(a, b) / 2
        return (a[0] + nv[0] * off, a[1] + nv[1] * off), d

    out = []
    for i in range(n):
        p1, d1 = offset_line((i - 1) % n)
        p2, d2 = offset_line(i)
        cr = d1[0] * d2[1] - d1[1] * d2[0]
        if abs(cr) < 1e-9:
            out.append(p2)
        else:
            w = (p2[0] - p1[0], p2[1] - p1[1])
            t = (w[0] * d2[1] - w[1] * d2[0]) / cr
            out.append((p1[0] + d1[0] * t, p1[1] + d1[1] * t))
    return area(out)


def poly(r):
    pts = [s.strip() for s in (r.get("pts") or "").split(";") if s.strip()]
    if len(pts) >= 3:
        return [tuple(float(v) for v in s.split()) for s in pts]
    x, y, w, d = (float(r[k]) for k in ("x", "y", "w", "d"))
    return [(x - w / 2, y - d / 2), (x + w / 2, y - d / 2), (x + w / 2, y + d / 2), (x - w / 2, y + d / 2)]


with open(ROOT / "data" / "rooms_gf.csv", encoding="utf-8", newline="") as f:
    rows = [r for r in csv.DictReader(f) if r.get("name") and not r["name"].startswith("#")]

print("| Room | Axes w × d (m) | Axes m² | Clear m² |")
print("|---|---|---|---|")
tot_a = tot_c = 0.0
for r in rows:
    P = poly(r)
    size = "sloped" if (r.get("pts") or "").strip() else f"{float(r['w']):g} × {float(r['d']):g}"
    a, c = area(P), clear(P)
    tot_a += a
    tot_c += c
    print(f"| {r['name']} | {size} | {a:.2f} | {c:.2f} |")
print(f"| **Total (incl. courtyard)** | | **{tot_a:.2f}** | **{tot_c:.2f}** |")
print(f"\nOutline on axes: {area(OUTLINE):.2f} m²")

"""schedule.py · Taif / Palm House · room schedule of the ground floor: axis sizes, axis areas and clear (finished-face) areas.

Run from anywhere:   python taif_house/tools/schedule.py          (prints a Markdown table)
Clear areas: every room edge moves inwards by half its wall: 250 mm on the building outline, 100 mm on the dry
partition between laundry and maid room (x = 10.65), 200 mm everywhere else. Concept values, not survey values.
"""
import csv
import math
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent          # taif_house
OUT, IN, DRY = 0.25, 0.20, 0.10
OUTLINE = [(0, 0), (10.051, 0), (13.311, 6.0), (13.311, 24.0), (0, 24.0)]     # same as design_gf.typ (CSV)
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


def clip(poly, a, n, off):
    out = []
    for i in range(len(poly)):
        p, q = poly[i], poly[(i + 1) % len(poly)]
        fp = (p[0] - a[0]) * n[0] + (p[1] - a[1]) * n[1] - off
        fq = (q[0] - a[0]) * n[0] + (q[1] - a[1]) * n[1] - off
        if fp >= 0:
            out.append(p)
        if fp * fq < 0:
            t = fp / (fp - fq)
            out.append((p[0] + t * (q[0] - p[0]), p[1] + t * (q[1] - p[1])))
    return out


def clear(P):
    s = 1 if sum(P[i][0] * P[(i + 1) % len(P)][1] - P[(i + 1) % len(P)][0] * P[i][1] for i in range(len(P))) > 0 else -1
    C = list(P)
    for i in range(len(P)):
        a, b = P[i], P[(i + 1) % len(P)]
        L = math.hypot(b[0] - a[0], b[1] - a[1])
        n = (-(b[1] - a[1]) / L * s, (b[0] - a[0]) / L * s)
        C = clip(C, a, n, wall(a, b) / 2)
    return area(C)


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

"""bedroom_test.py · Taif / Palm House · the two-children test of bedrooms 2 and 3 (design review, V6.3): can each room take two single beds
0.9 × 2.0, two wardrobes 0.6 × 1.2 and two desks 0.6 × 1.2 with the door swinging freely? A test only: it changes no file.

Run from anywhere:   python taif_house/tools/bedroom_test.py [trials]
It reads the rooms from data/rooms_ff.csv and the doors from studies/ff_family.typ, builds each room's clear polygon (walls 0.25 outer, 0.20
inner), and searches wall-hugging layouts at random (every piece flush against a wall, long side along it or across it): a layout passes when
nothing overlaps, every piece is inside the room, the door's swing (a square of the door's width into the room, as the study checks it) is
free, every bed keeps ≥ 0.75 m free along one long side, every wardrobe and desk ≥ 0.75 m in front, and a 0.75 m wide path leads from the
door to every bed's free side. It prints the first passing layout per room, or the best failing one and what is missing. Then it checks the
hand layouts in HAND (drawn by hand for V6.3) with the same rules, so a room is not failed only because the random search missed a layout.
"""
import csv
import random
import re
import sys
from pathlib import Path

from shapely.geometry import LineString, Point, Polygon, box
from shapely.ops import unary_union

sys.stdout.reconfigure(encoding="utf-8", errors="replace")
ROOT = Path(__file__).resolve().parent.parent
BED, WARD, DESK, CLEAR = (0.9, 2.0), (0.6, 1.2), (0.6, 1.2), 0.75
OUTER = Polygon([(0, 0), (10.051, 0), (13.311, 6.0), (13.311, 24.0), (0, 24.0)])
TRIALS = int(sys.argv[1]) if len(sys.argv) > 1 else 4000
random.seed(6)


def rooms():
    with open(ROOT / "data" / "rooms_ff.csv", encoding="utf-8", newline="") as f:
        out = {}
        for r in csv.DictReader(f):
            if not r["name"] or r["name"].startswith("#"):
                continue
            pts = [tuple(float(v) for v in s.split()) for s in r["pts"].split(";") if s.strip()]
            if len(pts) < 3:
                x, y, w, d = (float(r[k]) for k in ("x", "y", "w", "d"))
                pts = [(x - w / 2, y - d / 2), (x + w / 2, y - d / 2), (x + w / 2, y + d / 2), (x - w / 2, y + d / 2)]
            out[r["name"]] = Polygon(pts)
        return out


def doors(name):
    text = (ROOT / "studies" / "ff_family.typ").read_text(encoding="utf-8")
    block = text[text.index("#let doors = ("):]
    block = block[:block.index("\n)")]
    out = []
    for m in re.finditer(r'D\(\(([-\d.]+), ([-\d.]+)\), \(([-\d.]+), ([-\d.]+)\), \[([^\]]*)\], "([^"]+)", \(([-\d.]+), ([-\d.]+)\)', block):
        if m.group(6) == name:
            out.append({"a": (float(m.group(1)), float(m.group(2))), "b": (float(m.group(3)), float(m.group(4))), "into": (float(m.group(7)), float(m.group(8))), "label": m.group(5), "w": round(float(m.group(1)) + float(m.group(2)) - float(m.group(3)) - float(m.group(4)), 3)})
            out[-1]["w"] = round(Point(out[-1]["a"]).distance(Point(out[-1]["b"])), 3)
    return out


def clear_poly(P):
    inner = P.buffer(-0.1, join_style=2)
    for i in range(len(P.exterior.coords) - 1):
        a, b = P.exterior.coords[i], P.exterior.coords[i + 1]
        if OUTER.exterior.distance(Point(a)) < 1e-6 and OUTER.exterior.distance(Point(b)) < 1e-6:
            inner = inner.difference(LineString([a, b]).buffer(0.125, cap_style=2, join_style=2))
    return inner


def swing_square(d):
    """The study's test: a square of the door's width projected into the room."""
    a, b, into = d["a"], d["b"], d["into"]
    w = d["w"]
    return Polygon([a, b, (b[0] + into[0] * w, b[1] + into[1] * w), (a[0] + into[0] * w, a[1] + into[1] * w)])


def wall_segments(room):
    c = list(room.exterior.coords)
    return [(c[i], c[i + 1]) for i in range(len(c) - 1)]


def place(room, segs, size, along):
    """A piece flush against a random wall: `along` = its long side along the wall. Returns (poly, front) with front = the side facing the room."""
    (ax, ay), (bx, by) = random.choice(segs)
    L = ((bx - ax) ** 2 + (by - ay) ** 2) ** 0.5
    ux, uy = (bx - ax) / L, (by - ay) / L
    nx, ny = -uy, ux                                   # inward normal (the room is on the left of a counter-clockwise ring)
    if not room.contains(Point(ax + ux * L / 2 + nx * 0.2, ay + uy * L / 2 + ny * 0.2)):
        nx, ny = -nx, -ny
    w_along, depth = (size[1], size[0]) if along else (size[0], size[1])
    if L < w_along + 0.02:
        return None
    t = random.uniform(0, L - w_along)
    p0 = (ax + ux * t, ay + uy * t)
    poly = Polygon([p0, (p0[0] + ux * w_along, p0[1] + uy * w_along), (p0[0] + ux * w_along + nx * depth, p0[1] + uy * w_along + ny * depth), (p0[0] + nx * depth, p0[1] + ny * depth)])
    front = poly.buffer(0).exterior   # unused
    front_strip = Polygon([(p0[0] + nx * depth, p0[1] + ny * depth), (p0[0] + ux * w_along + nx * depth, p0[1] + uy * w_along + ny * depth),
                           (p0[0] + ux * w_along + nx * (depth + CLEAR), p0[1] + uy * w_along + ny * (depth + CLEAR)), (p0[0] + nx * (depth + CLEAR), p0[1] + ny * (depth + CLEAR))])
    side_strips = [Polygon([(p0[0] - ux * CLEAR, p0[1] - uy * CLEAR), p0, (p0[0] + nx * depth, p0[1] + ny * depth), (p0[0] - ux * CLEAR + nx * depth, p0[1] - uy * CLEAR + ny * depth)]),
                   Polygon([(p0[0] + ux * w_along, p0[1] + uy * w_along), (p0[0] + ux * (w_along + CLEAR), p0[1] + uy * (w_along + CLEAR)), (p0[0] + ux * (w_along + CLEAR) + nx * depth, p0[1] + uy * (w_along + CLEAR) + ny * depth), (p0[0] + ux * w_along + nx * depth, p0[1] + uy * w_along + ny * depth)])]
    return {"poly": poly, "front": front_strip, "sides": side_strips, "along": along}


def try_layout(room, segs, swings):
    items = []
    for kind, size, along_choices in (("bed", BED, (True, False)), ("bed", BED, (True, False)), ("wardrobe", WARD, (True,)), ("wardrobe", WARD, (True,)), ("desk", DESK, (True,)), ("desk", DESK, (True,))):
        for _ in range(40):
            it = place(room, segs, size, random.choice(along_choices))
            if it is None or not room.buffer(1e-6).contains(it["poly"]):
                continue
            if any(it["poly"].intersects(o["poly"].buffer(-1e-6)) for o in items):
                continue
            if any(it["poly"].intersects(sw.buffer(-1e-6)) for sw in swings):
                continue
            it["kind"] = kind
            items.append(it)
            break
        else:
            return None
    return items


def problems(room, items, swings, door_pts):
    out = []
    occ = unary_union([it["poly"] for it in items])
    for i, it in enumerate(items):
        others = unary_union([o["poly"] for o in items if o is not it])   # the clearance strips may overlap the door swing (both transient), not the furniture
        if it["kind"] == "bed":
            # a bed: ≥ 0.75 free along one long side (the long side is along the wall if `along`, else the front)
            strips = it["sides"] if it["along"] else [it["front"]]
            if it["along"]:
                strips = [it["front"]]          # the long side along the wall faces the room through its front
            else:
                strips = it["sides"]
            if not any(room.buffer(1e-6).contains(s) and not s.intersects(others.buffer(-1e-6)) for s in strips):
                out.append(f"bed {i + 1}: no {CLEAR} m free along a long side")
        else:
            if not (room.buffer(1e-6).contains(it["front"]) and not it["front"].intersects(others.buffer(-1e-6))):
                out.append(f"{it['kind']} {i + 1}: no {CLEAR} m free in front")
    free = room.difference(occ)
    walk = free.buffer(-CLEAR / 2 + 1e-6)
    parts = list(getattr(walk, "geoms", [walk]))
    for dp in door_pts:
        comp = next((g for g in parts if g.buffer(CLEAR / 2 + 0.02).contains(dp)), None)
        for i, it in enumerate(items):
            if it["kind"] == "bed" and (comp is None or not comp.buffer(CLEAR / 2 + 0.05).intersects(it["poly"])):
                out.append(f"no {CLEAR} m path from the door to bed {i + 1}")
    return out


def hand(kind, x0, y0, x1, y1, face):
    """A hand-placed piece: its front (the free side for a bed) faces `face` = N (smaller y), S, E or W."""
    poly = box(x0, y0, x1, y1)
    strip = {"N": box(x0, y0 - CLEAR, x1, y0), "S": box(x0, y1, x1, y1 + CLEAR), "E": box(x1, y0, x1 + CLEAR, y1), "W": box(x0 - CLEAR, y0, x0, y1)}[face]
    return {"kind": kind, "poly": poly, "front": strip, "sides": [strip], "along": True}


# hand layouts (V6.3): (kind, x0, y0, x1, y1, face); the CSV frame (x east, y south)
HAND = {
    "Bedroom 2": [   # 4.025 × 3.2 clear; the door swing x 3.25–4.15, y 11.1–12.1
        ("two beds, two wardrobes, one desk (the second desk has no wall left: 0.45 m between the first desk and the door swing)",
         [("bed", 0.125, 11.10, 2.125, 12.00, "S"), ("bed", 0.125, 13.40, 2.125, 14.30, "N"), ("wardrobe", 3.55, 12.10, 4.15, 13.30, "W"),
          ("wardrobe", 2.30, 13.70, 3.50, 14.30, "N"), ("desk", 2.15, 11.10, 2.75, 12.30, "E")]),
    ],
    "Bedroom 3": [   # 4.025 × 2.95 clear plus the entry arm 1.85 × 1.7; the door swing x 3.25–4.15, y 15.2–16.2
        ("two beds, two wardrobes, two desks",
         [("bed", 0.125, 16.20, 2.125, 17.10, "S"), ("bed", 0.125, 18.25, 2.125, 19.15, "N"), ("wardrobe", 3.55, 16.95, 4.15, 18.15, "W"),
          ("wardrobe", 2.30, 18.55, 3.50, 19.15, "N"), ("desk", 2.95, 14.50, 4.15, 15.10, "S"), ("desk", 2.30, 15.10, 2.90, 16.30, "E")]),
    ],
}


def check_hand(name, room, swings, door_pts):
    for title, pieces in HAND.get(name, []):
        items = [hand(*p) for p in pieces]
        pr = []
        for it in items:
            if not room.buffer(1e-6).contains(it["poly"]):
                pr.append(f"{it['kind']} at {describe(it)} is outside the clear room")
            if any(it["poly"].intersects(sw.buffer(-1e-6)) for sw in swings):
                pr.append(f"{it['kind']} at {describe(it)} is in the door swing")
        for i, a in enumerate(items):
            for b in items[i + 1:]:
                if a["poly"].intersects(b["poly"].buffer(-1e-6)):
                    pr.append(f"{a['kind']} and {b['kind']} overlap")
        pr += problems(room, items, swings, door_pts)
        print(f"  hand layout · {title}: " + ("PASS" if not pr else "FAIL") + " · free floor " + f"{room.difference(unary_union([it['poly'] for it in items])).area:.2f} m²")
        for it in items:
            print("   · " + describe(it))
        for p in pr:
            print("   - missing: " + p)


def describe(it):
    x0, y0, x1, y1 = it["poly"].bounds
    return f"{it['kind']} x {x0:.2f}–{x1:.2f} y {y0:.2f}–{y1:.2f}"


def run(name):
    P = rooms()[name]
    room = clear_poly(P)
    segs = wall_segments(room)
    ds = doors(name)
    swings = [swing_square(d) for d in ds]
    door_pts = [Point((d["a"][0] + d["b"][0]) / 2 + d["into"][0] * 0.5, (d["a"][1] + d["b"][1]) / 2 + d["into"][1] * 0.5) for d in ds]
    best = None
    for _ in range(TRIALS):
        items = try_layout(room, segs, swings)
        if items is None:
            continue
        pr = problems(room, items, swings, door_pts)
        if best is None or len(pr) < len(best[0]):
            best = (pr, items)
        if not pr:
            break
    door_txt = ", ".join("%s %.2f m" % (d["label"], d["w"]) for d in ds)
    print(f"\n{name}: clear {room.area:.2f} m², doors {door_txt}")
    if best is None:
        print("  FAIL: no layout places the six pieces without overlap")
        check_hand(name, room, swings, door_pts)
        return
    pr, items = best
    print(("  PASS" if not pr else "  FAIL (best of the trials)") + " · free floor " + f"{room.difference(unary_union([it['poly'] for it in items])).area:.2f} m²")
    for it in items:
        print("   · " + describe(it))
    for p in pr:
        print("   - missing: " + p)
    check_hand(name, room, swings, door_pts)


print(f"Two-children test · two single beds {BED[0]} × {BED[1]}, two wardrobes {WARD[0]} × {WARD[1]}, two desks {DESK[0]} × {DESK[1]}, {CLEAR} m clearances, the door swing as a square of its width · {TRIALS} random wall-hugging layouts per room")
for n in ("Bedroom 2", "Bedroom 3"):
    run(n)

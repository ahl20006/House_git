"""make_dxf.py · Taif / Palm House V6.1 · writes the DXF of the ground floor (site, building, rooms, doors, fixtures).

Run from anywhere:   python taif_house/tools/make_dxf.py
Output:              taif_house/output/taif_ground_floor_V6.1.dxf   (units: metres, north up as on the Typst plan)
The first floor has its own tool: tools/make_dxf_ff.py.

Everything is read from the same sources as the Typst drawing, nothing is typed in twice:
  base.typ            site: land, envelope, driveway, lane, north wall, palms, M pegs, north
  design_gf.typ       building shift / rotation, outline, air tower, inner boxes, level marks, entries,
                      and the door / window / opening lines of both blocks (west-lines, east-lines)
  data/rooms_gf.csv   every room (rectangle from x, y, w, d, angle, or corner points from "pts")
  studies/east_wing.typ   fixtures (counters, machines, bed …) and the solid wall of the east block
  studies/guest_wing.typ  fixtures of the west block (hospitality counter, basin counter, trough, shoe cabinet)
Coordinates: the Typst design frame has y pointing south; the DXF uses y up, so a point (x, y) becomes (x, -y).
Needs: pip install ezdxf
"""
import ast
import csv
import math
import re
import sys
from pathlib import Path

import ezdxf

ROOT = Path(__file__).resolve().parent.parent          # taif_house
OUT = ROOT / "output" / "taif_ground_floor_V6.1.dxf"


# ---------- reading the Typst sources ----------
def grab(text, name):
    """Return the balanced (...) value of `#let name = (...)` as a string."""
    m = re.search(r"#let\s+" + re.escape(name) + r"\s*=\s*\(", text)
    if not m:
        raise SystemExit(f"ERROR: '#let {name} = (' not found")
    i = m.end() - 1
    depth = 0
    for j in range(i, len(text)):
        if text[j] == "(":
            depth += 1
        elif text[j] == ")":
            depth -= 1
            if depth == 0:
                return text[i:j + 1]
    raise SystemExit(f"ERROR: unbalanced value for {name}")


def numbers(text, name):
    return ast.literal_eval(grab(text, name))


def clean(label):
    """Typst label markup → plain text."""
    return re.sub(r"\s+", " ", label.replace("\\", " ").replace("*", "")).strip()


base = (ROOT / "base.typ").read_text(encoding="utf-8")
design = (ROOT / "design_gf.typ").read_text(encoding="utf-8")
east = (ROOT / "studies" / "east_wing.typ").read_text(encoding="utf-8")

site = {k: numbers(base, k) for k in ("land", "env", "drv", "lane", "nwall", "south", "T1", "T2", "Ms", "north")}
shift = numbers(design, "shift")
rot = math.radians(float(re.search(r"#let\s+rot\s*=\s*(-?[\d.]+)deg", design).group(1)))
outline_csv = numbers(design, "outline-csv-gf")
tower_csv = numbers(design, "tower-pts")

PAIR = r"\(\s*(-?[\d.]+)\s*,\s*(-?[\d.]+)\s*\)"
inner_boxes = [(float(a), float(b), float(c), float(d), clean(l)) for a, b, c, d, l in
               re.findall(r"\(\s*(-?[\d.]+),\s*(-?[\d.]+),\s*(-?[\d.]+),\s*(-?[\d.]+),\s*\[(.*?)\]\s*\)", grab(design, "inner-boxes"))]
level = [((float(a), float(b)), (float(c), float(d)), clean(l)) for a, b, c, d, l in re.findall(
    r"place\(" + PAIR + r"\),\s*place\(" + PAIR + r"\)\),\s*\[(.*?)\]", re.search(r"#let level-marks.*", design).group(0))]
entries = [((float(a), float(b)), (float(c), float(d)), clean(l)) for a, b, c, d, l in
           re.findall(PAIR + r",\s*" + PAIR + r",\s*\[(.*?)\]", grab(design, "entries"))]


def lines_with_comments(name):
    """((x1, y1), (x2, y2), [label]),  // comment   →  (p1, p2, comment, else label)"""
    block = grab(design, name)
    out = []
    for line in block.splitlines():
        m = re.search(PAIR + r",\s*" + PAIR + r",\s*\[(.*?)\]\s*\)\s*,?\s*(?://\s*(.*))?$", line)
        if m:
            x1, y1, x2, y2, lab, com = m.groups()
            out.append(((float(x1), float(y1)), (float(x2), float(y2)), (com or "").strip() or clean(lab)))
    return out


openings = lines_with_comments("west-lines") + lines_with_comments("east-lines")
EAST = (8.95, 0.0)  # east_wing.typ local → CSV (the east band starts at x 8.95)
fixtures = [((float(a) + EAST[0], float(b) + EAST[1]), (float(c) + EAST[0], float(d) + EAST[1]), clean(l)) for a, b, c, d, l in
            re.findall(r"\(\s*(-?[\d.]+),\s*(-?[\d.]+),\s*(-?[\d.]+),\s*(-?[\d.]+),\s*\[(.*?)\]\s*\)", grab(east, "fixtures"))]
WEST = (0.0, 10.4)  # guest_wing.typ local → CSV
west = (ROOT / "studies" / "guest_wing.typ").read_text(encoding="utf-8")
fixtures += [((float(a) + WEST[0], float(b) + WEST[1]), (float(c) + WEST[0], float(d) + WEST[1]), clean(l)) for a, b, c, d, l in
             re.findall(r"\(\s*(-?[\d.]+),\s*(-?[\d.]+),\s*(-?[\d.]+),\s*(-?[\d.]+),\s*\[(.*?)\]\s*\)", grab(west, "fixtures"))]
solid = [((float(a) + EAST[0], float(b)), (float(c) + EAST[0], float(d)), clean(l)) for a, b, c, d, l in
         re.findall(PAIR + r",\s*" + PAIR + r",\s*\[(.*?)\]", grab(east, "solid"))]


# ---------- rooms from the CSV ----------
def room_poly(r):
    pts = [s.strip() for s in (r.get("pts") or "").split(";") if s.strip()]
    if len(pts) >= 3:
        return [tuple(float(v) for v in s.split()) for s in pts]
    x, y, w, d = (float(r[k]) for k in ("x", "y", "w", "d"))
    if (r.get("frame") or "M") != "M":
        raise SystemExit(f"ERROR: frame N not supported in the DXF yet ({r['name']})")
    t = math.radians(float(r.get("angle") or 0))
    u, v = (math.cos(t), math.sin(t)), (-math.sin(t), math.cos(t))
    return [(x + a * u[0] + b * v[0], y + a * u[1] + b * v[1]) for a, b in ((-w / 2, -d / 2), (w / 2, -d / 2), (w / 2, d / 2), (-w / 2, d / 2))]


with open(ROOT / "data" / "rooms_gf.csv", encoding="utf-8", newline="") as f:
    rows = [r for r in csv.DictReader(f) if r.get("name") and not r["name"].startswith("#")]
court_row = next(r for r in rows if r["name"] == "Courtyard")


# ---------- CSV coordinates → design frame (shift, then rotate round the courtyard centre) ----------
pivot = (float(court_row["x"]) + shift[0], float(court_row["y"]) + shift[1])


def place(p):
    x, y = p[0] + shift[0] - pivot[0], p[1] + shift[1] - pivot[1]
    return (pivot[0] + x * math.cos(rot) - y * math.sin(rot), pivot[1] + x * math.sin(rot) + y * math.cos(rot))


def dxf(p):
    return (p[0], -p[1])


def area(P):
    return abs(sum(P[i][0] * P[(i + 1) % len(P)][1] - P[(i + 1) % len(P)][0] * P[i][1] for i in range(len(P)))) / 2


def centroid(P):
    a = 0.0
    cx = cy = 0.0
    for i in range(len(P)):
        x0, y0 = P[i]
        x1, y1 = P[(i + 1) % len(P)]
        c = x0 * y1 - x1 * y0
        a += c
        cx += (x0 + x1) * c
        cy += (y0 + y1) * c
    a /= 2
    return (cx / (6 * a), cy / (6 * a)) if abs(a) > 1e-9 else P[0]


# ---------- the DXF ----------
doc = ezdxf.new("R2010", setup=True)
doc.units = ezdxf.units.M
doc.header["$INSUNITS"] = 6
doc.header["$MEASUREMENT"] = 1
doc.appids.add("HOUSE")
msp = doc.modelspace()

LAYERS = {   # name: (ACI colour, linetype, description)
    "SITE-LAND": (8, "CONTINUOUS", "plot boundary"),
    "SITE-ENVELOPE": (3, "CONTINUOUS", "buildable envelope (setback lines)"),
    "SITE-DRIVEWAY": (5, "CONTINUOUS", "driveway"),
    "SITE-LANE": (7, "CONTINUOUS", "lane edge and north wall"),
    "SITE-SOUTH": (3, "DASHED", "south line of the plot"),
    "SITE-PALMS": (94, "CONTINUOUS", "palm trunks and 1 m clear circles"),
    "SITE-PEGS": (94, "CONTINUOUS", "M1–M4 survey pegs on the M line"),
    "BUILDING-OUTLINE": (1, "CONTINUOUS", "ground-floor outline, wall centre lines"),
    "COURTYARD": (150, "CONTINUOUS", "courtyard, open to the sky"),
    "ROOMS-FAMILY": (40, "CONTINUOUS", "family rooms"),
    "ROOMS-GUEST": (32, "CONTINUOUS", "guest rooms"),
    "ROOMS-SERVICE": (140, "CONTINUOUS", "service and wet rooms"),
    "ROOMS-CIRC": (9, "CONTINUOUS", "circulation"),
    "ROOMS-CORE": (252, "CONTINUOUS", "lift, stair, utility"),
    "ROOM-LABELS": (7, "CONTINUOUS", "room name and area"),
    "AIR-TOWER": (4, "CONTINUOUS", "air tower in the cut corner"),
    "DOORS": (1, "CONTINUOUS", "doors"),
    "OPENINGS": (6, "CONTINUOUS", "open entrances and openings, no door"),
    "WINDOWS": (4, "CONTINUOUS", "windows"),
    "WALLS-SPECIAL": (7, "CONTINUOUS", "solid walls, coffee / basins wall, screen wall, living low partition, family / guest line"),
    "FIXTURES": (8, "DASHED", "counters, machines, bed, wardrobe, shower, WC, basins (east block); hospitality counter, basin counter, trough, shoe cabinet (west block)"),
    "MARKS": (4, "DASHED", "shaft, under-stair store, the three columns, ceiling-height change, the first-floor edge beam above"),
    "ENTRIES": (30, "CONTINUOUS", "entry arrows"),
    "ANNOTATION": (7, "CONTINUOUS", "title, north arrow, scale bar"),
}
for name, (colour, ltype, desc) in LAYERS.items():
    lay = doc.layers.add(name, color=colour, linetype=ltype)
    lay.description = desc


def pline(P, layer, closed=True):
    return msp.add_lwpolyline([dxf(p) for p in P], close=closed, dxfattribs={"layer": layer})


def seg(a, b, layer):
    return msp.add_line(dxf(a), dxf(b), dxfattribs={"layer": layer})


def label(p, text, layer, h=0.15, attach=5):
    m = msp.add_mtext(text, dxfattribs={"layer": layer, "char_height": h, "attachment_point": attach})
    m.set_location(dxf(p))
    return m


# site (already in the design frame)
pline(site["land"], "SITE-LAND")
pline(site["env"], "SITE-ENVELOPE")
pline(site["drv"], "SITE-DRIVEWAY")
pline(site["lane"], "SITE-LANE", closed=False)
pline(site["nwall"], "SITE-LANE", closed=False)
pline(site["south"], "SITE-SOUTH", closed=False)
for T, n in ((site["T1"], "Palm 1"), (site["T2"], "Palm 2")):
    msp.add_circle(dxf(T), 0.265, dxfattribs={"layer": "SITE-PALMS"})
    msp.add_circle(dxf(T), 1.0, dxfattribs={"layer": "SITE-PALMS"})
    label((T[0] + 1.3, T[1]), n, "SITE-PALMS", h=0.35, attach=4)
for p, n in zip(site["Ms"], ("M1", "M2", "M3", "M4")):
    msp.add_circle(dxf(p), 0.18, dxfattribs={"layer": "SITE-PEGS"})
    label((-0.6, p[1]), n, "SITE-PEGS", h=0.35, attach=6)
label((-2.5, 9), "Driveway", "SITE-DRIVEWAY", h=0.4)
label((4, -1.7), "North street", "SITE-LANE", h=0.4)

# building
pline([place(p) for p in outline_csv], "BUILDING-OUTLINE")
room_areas = {}
for r in rows:
    P = [place(p) for p in room_poly(r)]
    if r["name"] == "Courtyard":
        e = pline(P, "COURTYARD")
        label(centroid(P), f"COURTYARD\\P{area(P):.2f} m²", "ROOM-LABELS", h=0.25)
    else:
        layer = "ROOMS-" + (r.get("colour") or "service").upper()
        if layer not in LAYERS:
            layer = "ROOMS-SERVICE"
        e = pline(P, layer)
        label(centroid(P), f"{r['name']}\\P{area(P):.2f} m²", "ROOM-LABELS", h=0.14)
    e.set_xdata("HOUSE", [(1000, r["name"]), (1040, round(area(P), 4))])
    room_areas[r["name"]] = area(P)

pline([place(p) for p in tower_csv], "AIR-TOWER")
label(place((9.5, 0.5)), "Air tower", "AIR-TOWER", h=0.12)

for x0, y0, x1, y1, l in inner_boxes:
    pline([place(p) for p in ((x0, y0), (x1, y0), (x1, y1), (x0, y1))], "MARKS")
    label(place(((x0 + x1) / 2, (y0 + y1) / 2)), l, "MARKS", h=0.12)
for a, b, l in level:   # ceiling-height change, and the first-floor edges above this floor
    seg(place(a), place(b), "MARKS")
    label(place((a[0] + 0.15, (a[1] + b[1]) / 2)), l, "MARKS", h=0.12, attach=4)

for a, b, l in openings:
    low = l.lower()
    if "window" in low:
        layer = "WINDOWS"
    elif "shelf" in low:
        layer = "FIXTURES"
    elif "door" in low and "no door" not in low:
        layer = "DOORS"
    elif "partition" in low or "line" in low or "screen wall" in low or "basins wall" in low:
        layer = "WALLS-SPECIAL"
    elif re.search(r"\bopen\b", low):
        layer = "OPENINGS"
    else:
        layer = "DOORS"
    seg(place(a), place(b), layer)
    if l:
        m = ((a[0] + b[0]) / 2, (a[1] + b[1]) / 2)
        label(place((m[0] + 0.1, m[1] + 0.12)), l, layer, h=0.08, attach=1)
for a, b, l in solid:
    seg(place(a), place(b), "WALLS-SPECIAL")
for a, b, l in fixtures:
    pline([place(p) for p in ((a[0], a[1]), (b[0], a[1]), (b[0], b[1]), (a[0], b[1]))], "FIXTURES")
    label(place(((a[0] + b[0]) / 2, (a[1] + b[1]) / 2)), l, "FIXTURES", h=0.07)

for p, d, l in entries:
    tip = place(p)
    tail = (tip[0] + 2.6 * (d[0] * math.cos(rot) - d[1] * math.sin(rot)), tip[1] + 2.6 * (d[0] * math.sin(rot) + d[1] * math.cos(rot)))
    seg(tail, tip, "ENTRIES")
    label(tail, l, "ENTRIES", h=0.25, attach=8)

# annotation: north arrow, scale bar, title
n = site["north"]           # canvas frame (y up)
msp.add_line((24, -2), (24 + 2.2 * n[0], -2 + 2.2 * n[1]), dxfattribs={"layer": "ANNOTATION"})
msp.add_mtext("N", dxfattribs={"layer": "ANNOTATION", "char_height": 0.6}).set_location((24 + 2.6 * n[0], -2 + 2.6 * n[1]))
msp.add_line((18, -42), (28, -42), dxfattribs={"layer": "ANNOTATION"})
msp.add_mtext("10 m", dxfattribs={"layer": "ANNOTATION", "char_height": 0.35, "attachment_point": 8}).set_location((23, -41.7))
title = ("Taif / Palm House · Ground floor V6.1 (no east duct, three columns at x 5.6, site option Z4)\\P"
         "Units: metres. Origin = peg M1; x east, square to the M line; y along the M line (drawn north up). "
         "Room outlines on wall centre lines. Generated by tools/make_dxf.py from design_gf.typ, data/rooms_gf.csv, base.typ and studies/.")
msp.add_mtext(title, dxfattribs={"layer": "ANNOTATION", "char_height": 0.45, "width": 30}).set_location((0, -44))

doc.saveas(OUT)
print(f"wrote {OUT.relative_to(ROOT.parent)}  · {len(room_areas)} rooms · {len(openings)} door/window lines · {len(fixtures)} fixtures")
sys.exit(0)

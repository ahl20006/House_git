"""make_dxf_ff.py · Taif / Palm House V6.0 · writes the DXF of the first floor (site, outline, rooms, voids, doors, windows, furniture).

Run from anywhere:   python taif_house/tools/make_dxf_ff.py
Output:              taif_house/output/taif_first_floor_V6.0.dxf   (units: metres, north up, same frame as the ground-floor DXF)

Nothing is typed in twice: the geometry is the <ff-data> metadata of design_ff.typ (rooms from data/rooms_ff.csv placed on the
site, doors, windows and furniture from studies/ff_family.typ and studies/ff_suite.typ), read with `typst eval`; the site from base.typ.
Coordinates: the Typst design frame has y pointing south; the DXF uses y up, so a point (x, y) becomes (x, -y).
Needs: typst on PATH, pip install ezdxf
"""
import ast
import json
import re
import shutil
import subprocess
import sys
from pathlib import Path

import ezdxf

ROOT = Path(__file__).resolve().parent.parent          # taif_house
OUT = ROOT / "output" / "taif_first_floor_V6.0.dxf"

typst = shutil.which("typst")
if not typst:
    raise SystemExit("ERROR: typst not found on PATH")
r = subprocess.run([typst, "eval", "--root", str(ROOT), "--in", str(ROOT / "design_ff.typ"), "query(<ff-data>).first().value"],
                   capture_output=True, text=True, encoding="utf-8")
if r.returncode != 0:
    raise SystemExit("ERROR: typst eval failed: " + r.stderr.strip()[-400:])
data = json.loads(r.stdout)


def grab(text, name):
    m = re.search(r"#let\s+" + re.escape(name) + r"\s*=\s*\(", text)
    i, depth = m.end() - 1, 0
    for j in range(i, len(text)):
        depth += {"(": 1, ")": -1}.get(text[j], 0)
        if depth == 0:
            return ast.literal_eval(text[i:j + 1])


base = (ROOT / "base.typ").read_text(encoding="utf-8")
site = {k: grab(base, k) for k in ("land", "env", "drv", "lane", "nwall", "south", "T1", "T2")}


def dxf(p):
    return (p[0], -p[1])


def area(P):
    return abs(sum(P[i][0] * P[(i + 1) % len(P)][1] - P[(i + 1) % len(P)][0] * P[i][1] for i in range(len(P)))) / 2


def centroid(P):
    a = cx = cy = 0.0
    for i in range(len(P)):
        (x0, y0), (x1, y1) = P[i], P[(i + 1) % len(P)]
        c = x0 * y1 - x1 * y0
        a += c
        cx += (x0 + x1) * c
        cy += (y0 + y1) * c
    a /= 2
    return (cx / (6 * a), cy / (6 * a)) if abs(a) > 1e-9 else P[0]


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
    "BUILDING-OUTLINE": (1, "CONTINUOUS", "first-floor outline, wall centre lines"),
    "GF-OUTLINE": (8, "DASHED", "ground-floor outline below"),
    "VOIDS": (150, "CONTINUOUS", "courtyard (open to the sky) and the double-height living (no floor)"),
    "ROOMS-FAMILY": (40, "CONTINUOUS", "family rooms"),
    "ROOMS-GUEST": (32, "CONTINUOUS", "master suite"),
    "ROOMS-SERVICE": (140, "CONTINUOUS", "baths, office, linen"),
    "ROOMS-CIRC": (9, "CONTINUOUS", "circulation"),
    "ROOMS-OPEN": (3, "CONTINUOUS", "suite court, open to the sky"),
    "ROOMS-GYM": (4, "CONTINUOUS", "gym"),
    "ROOMS-CORE": (252, "CONTINUOUS", "stair, lift shaft, west shaft, air tower (rising from the ground floor)"),
    "ROOM-LABELS": (7, "CONTINUOUS", "room number, name and area"),
    "DOORS": (1, "CONTINUOUS", "doors"),
    "OPENINGS": (6, "CONTINUOUS", "openings and sliding doors"),
    "WINDOWS": (4, "CONTINUOUS", "windows"),
    "FURNITURE": (8, "DASHED", "furniture and fixtures from the two first-floor studies"),
    "MARKS": (4, "DASHED", "the GF lines the cantilevers start from (x 4.25, x 0)"),
    "ANNOTATION": (7, "CONTINUOUS", "title, north arrow, scale bar"),
}
for name, (colour, ltype, desc) in LAYERS.items():
    doc.layers.add(name, color=colour, linetype=ltype).description = desc


def pline(P, layer, closed=True):
    return msp.add_lwpolyline([dxf(p) for p in P], close=closed, dxfattribs={"layer": layer})


def label(p, text, layer, h=0.15, attach=5):
    m = msp.add_mtext(text, dxfattribs={"layer": layer, "char_height": h, "attachment_point": attach})
    m.set_location(dxf(p))


pline(site["land"], "SITE-LAND")
pline(site["env"], "SITE-ENVELOPE")
pline(site["drv"], "SITE-DRIVEWAY")
for k in ("lane", "nwall"):
    pline(site[k], "SITE-LANE", closed=False)
pline(site["south"], "SITE-SOUTH", closed=False)
for T in (site["T1"], site["T2"]):
    msp.add_circle(dxf(T), 0.265, dxfattribs={"layer": "SITE-PALMS"})
    msp.add_circle(dxf(T), 1.0, dxfattribs={"layer": "SITE-PALMS"})

pline(data["outline"], "BUILDING-OUTLINE")
pline(data["gf-outline"], "GF-OUTLINE")
for v in data["voids"]:
    pline(v["pts"], "VOIDS")
    label(centroid(v["pts"]), v["name"], "ROOM-LABELS", h=0.18)
for f in data["fixed"]:
    pline(f["pts"], "ROOMS-CORE")
    label(centroid(f["pts"]), f["name"], "ROOM-LABELS", h=0.12)
LAYER_OF = {"family": "ROOMS-FAMILY", "guest": "ROOMS-GUEST", "service": "ROOMS-SERVICE", "circ": "ROOMS-CIRC", "open": "ROOMS-OPEN", "tower": "ROOMS-GYM"}
for room in data["rooms"]:
    e = pline(room["pts"], LAYER_OF.get(room["colour"], "ROOMS-SERVICE"))
    e.set_xdata("HOUSE", [(1000, room["name"]), (1040, round(area(room["pts"]), 4))])
    label(centroid(room["pts"]), f"{room['id']} {room['name']}\\P{area(room['pts']):.2f} m²", "ROOM-LABELS", h=0.13)
for d in data["doors"]:
    msp.add_line(dxf(d["a"]), dxf(d["b"]), dxfattribs={"layer": "OPENINGS" if d["open"] else "DOORS"})
for a, b in data["windows"]:
    msp.add_line(dxf(a), dxf(b), dxfattribs={"layer": "WINDOWS"})
for f in data["furniture"]:
    (x0, y0), (x1, y1) = f["a"], f["b"]
    pline([(x0, y0), (x1, y0), (x1, y1), (x0, y1)], "FURNITURE")
    if f["label"].strip():
        label(((x0 + x1) / 2, (y0 + y1) / 2), f["label"], "FURNITURE", h=0.08)
m = data["marks"]
for a, b in ((m[0], m[1]), (m[2], m[3])):
    msp.add_line(dxf(a), dxf(b), dxfattribs={"layer": "MARKS"})

msp.add_line((18, -42), (28, -42), dxfattribs={"layer": "ANNOTATION"})
msp.add_mtext("10 m", dxfattribs={"layer": "ANNOTATION", "char_height": 0.35, "attachment_point": 8}).set_location((23, -41.7))
title = ("Taif / Palm House · First floor V6.0 (split west projection, no columns; FF west face "
         f"{data['m-gap']:.2f} m from the M line, approval pending)\\P"
         "Units: metres. Origin = peg M1; x east, square to the M line; y along the M line (drawn north up). "
         "Room outlines on wall centre lines. Generated by tools/make_dxf_ff.py from design_ff.typ, data/rooms_ff.csv, base.typ and the first-floor studies.")
msp.add_mtext(title, dxfattribs={"layer": "ANNOTATION", "char_height": 0.45, "width": 30}).set_location((0, -44))

doc.saveas(OUT)
print(f"wrote {OUT.relative_to(ROOT.parent)}  · {len(data['rooms'])} rooms · {len(data['doors'])} doors · {len(data['windows'])} windows · {len(data['furniture'])} furniture items")
sys.exit(0)

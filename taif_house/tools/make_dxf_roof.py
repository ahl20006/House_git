"""make_dxf_roof.py · Taif / Palm House V7.0 · writes the DXF of the roof plan (outline, the holes, the attic line, the stair room, the lift head,
the malqaf head, the reserved zones, the outlets, the walkways, the guards, the attic doors).

Run from anywhere:   python taif_house/tools/make_dxf_roof.py
Output:              taif_house/output/taif_roof_V7.0.dxf   (units: metres, north up, the same site frame as the floor DXFs)

Nothing is typed in twice: the geometry is the <roof-data> metadata of studies/roof.typ (read with `typst eval`), placed on the site with the
shift of design_gf.typ; the site from base.typ. Coordinates: the Typst frame has y pointing south; the DXF uses y up, so (x, y) becomes (x, -y).
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
OUT = ROOT / "output" / "taif_roof_V7.0.dxf"

typst = shutil.which("typst")
if not typst:
    raise SystemExit("ERROR: typst not found on PATH")
r = subprocess.run([typst, "eval", "--root", str(ROOT), "--in", str(ROOT / "studies" / "roof.typ"), "query(<roof-data>).first().value"],
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
SHIFT = grab((ROOT / "design_gf.typ").read_text(encoding="utf-8"), "shift")


def place(p):
    return (p[0] + SHIFT[0], p[1] + SHIFT[1])


def dxf(p):
    return (p[0], -p[1])


def centroid(P):
    return (sum(p[0] for p in P) / len(P), sum(p[1] for p in P) / len(P))


doc = ezdxf.new("R2010", setup=True)
doc.units = ezdxf.units.M
doc.header["$INSUNITS"] = 6
doc.header["$MEASUREMENT"] = 1
doc.appids.add("HOUSE")
msp = doc.modelspace()
LAYERS = {
    "SITE-LAND": (8, "CONTINUOUS", "plot boundary"), "SITE-ENVELOPE": (3, "CONTINUOUS", "buildable envelope (setback lines)"), "SITE-DRIVEWAY": (5, "CONTINUOUS", "driveway"),
    "SITE-LANE": (7, "CONTINUOUS", "lane edge and north wall"), "SITE-SOUTH": (3, "DASHED", "south line of the plot"), "SITE-PALMS": (94, "CONTINUOUS", "palm trunks and 1 m clear circles"),
    "ROOF-OUTLINE": (1, "CONTINUOUS", "the outer walls, wall centre lines (the main cornice on their outer face all round)"),
    "ROOF-STEP": (1, "DASHED", "the north block / south wing line y 19.25: the attic's south wall, the parapet step"),
    "ROOF-HOLES": (150, "CONTINUOUS", "the courtyard sky, the suite court, the malqaf shaft"),
    "ROOF-ATTIC": (30, "CONTINUOUS", "the attic screen wall's outer face, set back 1.0 m from the facade face"),
    "ROOF-STAIR": (252, "CONTINUOUS", "the stair room on the well, the lift shaft (no head above the roof)"),
    "ROOF-ZONES": (40, "DASHED", "reserved zones: plant, tank, PV"),
    "ROOF-DRAINS": (4, "CONTINUOUS", "roof outlets"),
    "ROOF-WALKWAYS": (1, "DASHDOT", "0.9 m maintenance walkways"),
    "ROOF-GUARDS": (7, "CONTINUOUS", "black steel bar guards 1.10 m"),
    "DOORS": (1, "CONTINUOUS", "the attic doors and the stair room door"),
    "LABELS": (7, "CONTINUOUS", "labels"), "ANNOTATION": (7, "CONTINUOUS", "title, scale bar"),
}
for name, (colour, ltype, desc) in LAYERS.items():
    doc.layers.add(name, color=colour, linetype=ltype).description = desc


def pline(P, layer, closed=True, placed=False):
    pts = [dxf(p if placed else place(p)) for p in P]
    return msp.add_lwpolyline(pts, close=closed, dxfattribs={"layer": layer})


def label(p, text, layer="LABELS", h=0.15, attach=5):
    m = msp.add_mtext(text, dxfattribs={"layer": layer, "char_height": h, "attachment_point": attach})
    m.set_location(dxf(place(p)))


pline(site["land"], "SITE-LAND", placed=True)
pline(site["env"], "SITE-ENVELOPE", placed=True)
pline(site["drv"], "SITE-DRIVEWAY", placed=True)
for k in ("lane", "nwall"):
    pline(site[k], "SITE-LANE", closed=False, placed=True)
pline(site["south"], "SITE-SOUTH", closed=False, placed=True)
for T in (site["T1"], site["T2"]):
    msp.add_circle(dxf(T), 0.265, dxfattribs={"layer": "SITE-PALMS"})
    msp.add_circle(dxf(T), 1.0, dxfattribs={"layer": "SITE-PALMS"})

lv = data["levels"]
pline(data["outline"], "ROOF-OUTLINE")
pline(data["block_s"], "ROOF-STEP")
for name, P in (("courtyard sky (open) · guard 1.10", data["sky"]), ("suite court (open)", data["court"]), (f"malqaf head +{lv['stair_room'] and lv['attic_top'] and 9.8:.2f}", data["tower"])):
    pline(P, "ROOF-HOLES")
    label(centroid(P), name, h=0.14)
e = pline(data["attic"], "ROOF-ATTIC")
e.set_xdata("HOUSE", [(1000, "attic line"), (1040, lv["attic_top"])])
label((6.6, 1.5), f"attic screen · set back {lv['setback']:.1f} m · coping +{lv['attic_top']:.2f} · north block coping +{lv['coping']:.2f} · south wing parapet +{lv['south']:.2f}", h=0.14)
e = pline(data["stair_room"], "ROOF-STAIR")
e.set_xdata("HOUSE", [(1000, "stair room"), (1040, lv["stair_room"])])
label(centroid(data["stair_room"]), f"stair room · roof +{lv['stair_room']:.2f}", h=0.12)
pline(data["lift"], "ROOF-STAIR")
label(centroid(data["lift"]), "lift shaft · no head above the roof", h=0.1)
for z in data["zones"]:
    e = pline(z["pts"], "ROOF-ZONES")
    e.set_xdata("HOUSE", [(1000, z["name"]), (1040, round(z["area"], 4))])
    label(centroid(z["pts"]), f"{z['name']}\\P{z['area']:.1f} m²", h=0.13)
for p in data["outlets"]:
    msp.add_circle(dxf(place(p)), 0.15, dxfattribs={"layer": "ROOF-DRAINS"})
for w in data["walkways"]:
    pline(w, "ROOF-WALKWAYS", closed=False)
for gline in data["guards"]:
    pline(gline, "ROOF-GUARDS", closed=False)
for a, b in data["attic_doors"]:
    msp.add_line(dxf(place(a)), dxf(place(b)), dxfattribs={"layer": "DOORS"})
msp.add_line((18, -42), (28, -42), dxfattribs={"layer": "ANNOTATION"})
msp.add_mtext("10 m", dxfattribs={"layer": "ANNOTATION", "char_height": 0.35, "attachment_point": 8}).set_location((23, -41.7))
title = ("Taif / Palm House · Roof plan V7.0 (the stair to the roof, the set-back attic, the main cornice, the stepped roofline, the reserved zones)\\P"
         "Units: metres. Origin = peg M1; x east, square to the M line; y along the M line (drawn north up). The outline on wall centre lines; "
         f"roof slab +{lv['roof']:.2f}; the main cornice +{lv['cornice'][0]:.2f} … +{lv['cornice'][1]:.2f}. Generated by tools/make_dxf_roof.py from studies/roof.typ and base.typ. All sizes assumed.")
msp.add_mtext(title, dxfattribs={"layer": "ANNOTATION", "char_height": 0.45, "width": 30}).set_location((0, -44))

doc.saveas(OUT)
print(f"wrote {OUT.relative_to(ROOT.parent)}  · {len(data['zones'])} zones · {len(data['outlets'])} outlets · {len(data['walkways'])} walkways · attic line {len(data['attic'])} points")
sys.exit(0)

"""build_3d.py · Taif / Palm House · builds the 3D model FROM the project files (phases 1–2: slabs, outer walls, interior walls).

Run from anywhere:   python taif_house/3d/build_3d.py
Reads (paths in 3d/params.yaml):
  data/rooms_gf.csv, data/rooms_ff.csv   every room (rectangles, or corner points in "pts"); # at the start of a name switches a row off
  design_gf.typ                          the outline (wall centre lines) and the air tower polygon
  studies/ff_family.typ                  the projection edge (proj-x) and the first-floor fixed elements (stair, lift, shaft, air tower)
  3d/open_edges.csv                      room edges that have NO wall (openings, railings later) or a low wall (height > 0)
  3d/params.yaml                         levels, slab and wall thicknesses
Writes: the GLB, the same GLB as base64 in a .js file for the viewer, and a JSON summary for 3d/check_3d.py.
Nothing in the output is edited by hand: change the CSVs or the design files and run this script again.

Frames: everything is built in the CSV frame (x east, y south, metres, origin = the building's north-west wall corner), which is
left-handed with z up; the GLB is Y-up and right-handed as glTF expects: X = x (east), Y = height, Z = y (south). The axis swap is
baked into every mesh (trimesh flips the face winding for it). Walls stand on wall centre lines, full storey height
(floor to the underside of the slab above); walls meeting another wall are lengthened by half a thickness to close the corner.
Needs: pip install trimesh shapely numpy pyyaml mapbox_earcut
"""
import ast
import base64
import csv
import json
import math
import re
import sys
from pathlib import Path

import numpy as np
import trimesh
import yaml
from shapely.geometry import LineString, Polygon, box
from shapely.ops import unary_union

HERE = Path(__file__).resolve().parent          # taif_house/3d
ROOT = HERE.parent                              # taif_house
P = yaml.safe_load((HERE / "params.yaml").read_text(encoding="utf-8"))
EPS = 1e-6


# ---------- reading the project files ----------
def grab(text, name):
    """The balanced (...) after `#let name = (`."""
    m = re.search(r"^#let\s+" + re.escape(name) + r"\s*=\s*\(", text, re.M)
    if not m:
        raise SystemExit(f"ERROR: '#let {name} = (' not found")
    i, depth = m.end() - 1, 0
    for j in range(i, len(text)):
        depth += {"(": 1, ")": -1}.get(text[j], 0)
        if depth == 0:
            return text[i:j + 1]
    raise SystemExit(f"ERROR: unbalanced value for {name}")


def read_rooms(path):
    with open(ROOT / path, encoding="utf-8", newline="") as f:
        rows = [r for r in csv.DictReader(f) if r.get("name") and not r["name"].startswith("#")]
    out = []
    for r in rows:
        pts = [s.strip() for s in (r.get("pts") or "").split(";") if s.strip()]
        if len(pts) >= 3:
            poly = [tuple(float(v) for v in s.split()) for s in pts]
        else:
            x, y, w, d = (float(r[k]) for k in ("x", "y", "w", "d"))
            poly = [(x - w / 2, y - d / 2), (x + w / 2, y - d / 2), (x + w / 2, y + d / 2), (x - w / 2, y + d / 2)]
        out.append({"name": r["name"], "colour": r.get("colour", ""), "pts": [(round(a, 6), round(b, 6)) for a, b in poly]})
    return out


def read_fixed_ff(path):
    """studies/ff_family.typ `fixed`: (name: "...", pts: rect-pts(x0, y0, x1, y1)) or pts: ((x, y), ...)."""
    block = grab((ROOT / path).read_text(encoding="utf-8"), "fixed")
    out = []
    for m in re.finditer(r'name:\s*"([^"]+)",\s*pts:\s*(rect-pts\(([^)]*)\)|\((?:\s*\([^()]*\)\s*,?)+\s*\))', block):
        name, raw, rect = m.group(1), m.group(2), m.group(3)
        if rect:
            x0, y0, x1, y1 = (float(v) for v in rect.split(","))
            pts = [(x0, y0), (x1, y0), (x1, y1), (x0, y1)]
        else:
            pts = [tuple(float(v) for v in p) for p in ast.literal_eval(raw)]
        out.append({"name": name, "colour": "core", "pts": pts})
    return out


gf_text = (ROOT / P["sources"]["outline"]).read_text(encoding="utf-8")
fam_text = (ROOT / P["sources"]["projection_edge"]).read_text(encoding="utf-8")
OUTLINE = [tuple(float(v) for v in p) for p in ast.literal_eval(grab(gf_text, "outline-csv-gf"))]
TOWER = [tuple(float(v) for v in p) for p in ast.literal_eval(re.search(r"#let tower-pts\s*=\s*(\(\(.*?\)\))\.map", gf_text).group(1))]
PROJ_X = float(re.search(r"#let proj-x\s*=\s*([\d.]+)", fam_text).group(1))
GF = read_rooms(P["sources"]["rooms_gf"]) + [{"name": "Air tower", "colour": "tower", "pts": TOWER}]
FF = read_rooms(P["sources"]["rooms_ff"]) + read_fixed_ff(P["sources"]["ff_fixed"])
court = next(r for r in GF if r["name"] == "Courtyard")
dh_living = next(r for r in GF if r["name"].startswith("Living (double height)"))
court_west = min(p[0] for p in court["pts"])
if abs(PROJ_X - court_west - P["projection"]["width"]) > EPS:
    raise SystemExit(f"ERROR: proj-x {PROJ_X} - courtyard edge {court_west} != projection width {P['projection']['width']} in params.yaml")

with open(ROOT / P["sources"]["open_edges"], encoding="utf-8", newline="") as f:
    OPEN = [{"floor": r["floor"], "a": (float(r["x1"]), float(r["y1"])), "b": (float(r["x2"]), float(r["y2"])), "height": float(r["height"]), "kind": r["kind"], "note": r["note"]}
            for r in csv.DictReader(f)]

# ---------- levels ----------
L = P["levels"]
T_SLAB = P["slab_thickness"]
T_OUT, T_IN = P["walls"]["outer"], P["walls"]["inner"]
STOREY = {"GF": (L["gf_floor"], L["ff_floor"] - T_SLAB), "FF": (L["ff_floor"], L["roof"] - T_SLAB)}   # wall bottom, wall top

# ---------- voids (first floor): the courtyard sky and the double-height living, east of the projection edge ----------
east_of_projection = box(PROJ_X, -1e3, 1e3, 1e3)
COURT_SKY = Polygon(court["pts"]).intersection(east_of_projection)
DH_VOID = Polygon(dh_living["pts"]).intersection(east_of_projection)
SUITE_COURT = Polygon(next(r for r in FF if r["colour"] in ("open", "terrace"))["pts"])   # open to the sky: a hole in the roof


# ---------- wall pieces: every room edge, split where other edges start or end, deduplicated, minus the outline and the open edges ----------
def line_key(p, q):
    dx, dy = q[0] - p[0], q[1] - p[1]
    n = math.hypot(dx, dy)
    ux, uy = dx / n, dy / n
    if ux < -1e-9 or (abs(ux) < 1e-9 and uy < 0):
        ux, uy = -ux, -uy
    c = p[0] * uy - p[1] * ux
    return (round(ux, 6), round(uy, 6), round(c, 4))


def param(p, key):
    return p[0] * key[0] + p[1] * key[1]


def point(key, t):
    ux, uy, c = key
    return (round(c * uy + t * ux, 6), round(-c * ux + t * uy, 6))


def edges(poly):
    return [(poly[i], poly[(i + 1) % len(poly)]) for i in range(len(poly))]


def wall_pieces(rooms, open_edges, floor):
    lines = {}   # key -> list of (t0, t1, tag, payload)

    def add(p, q, tag, payload=None):
        k = line_key(p, q)
        t0, t1 = sorted((param(p, k), param(q, k)))
        lines.setdefault(k, []).append((t0, t1, tag, payload))

    for r in rooms:
        for p, q in edges(r["pts"]):
            add(p, q, "room", r["name"])
    for p, q in edges(OUTLINE):
        add(p, q, "outline")
    for o in open_edges:
        if o["floor"] == floor:
            add(o["a"], o["b"], "open", o["height"])
    pieces = []
    for k, segs in lines.items():
        cuts = sorted({round(t, 6) for s in segs for t in s[:2]})
        for t0, t1 in zip(cuts, cuts[1:]):
            mid = (t0 + t1) / 2
            on = [s for s in segs if s[0] - EPS <= mid <= s[1] + EPS]
            rooms_on = [s[3] for s in on if s[2] == "room"]
            if not rooms_on:
                continue
            opens = [s[3] for s in on if s[2] == "open"]
            piece = {"key": k, "t0": t0, "t1": t1, "rooms": rooms_on, "outline": any(s[2] == "outline" for s in on),
                     "open": bool(opens) and min(opens) == 0, "height": max(opens) if opens else None}
            pieces.append(piece)
    # merge consecutive pieces on one line into walls
    walls = []
    for k in sorted({p["key"] for p in pieces}):
        run = None
        for p in sorted((p for p in pieces if p["key"] == k), key=lambda p: p["t0"]):
            kind = "outer" if p["outline"] else "open" if p["open"] else "low" if p["height"] else "wall"
            if kind in ("outer", "open"):
                run = None
                continue
            h = p["height"] if kind == "low" else None
            if run and abs(run["t1"] - p["t0"]) < EPS and run["kind"] == kind and run["h"] == h:
                run["t1"] = p["t1"]
            else:
                run = {"key": k, "t0": p["t0"], "t1": p["t1"], "kind": kind, "h": h}
                walls.append(run)
    return pieces, [{"a": point(w["key"], w["t0"]), "b": point(w["key"], w["t1"]), "kind": w["kind"], "h": w["h"]} for w in walls]


# ---------- meshes ----------
COLOURS = {"slab": [205, 200, 190, 255], "outer": [120, 112, 100, 255], "wall": [190, 182, 170, 255], "low": [200, 167, 126, 255]}


def extrude(poly, z0, z1, colour, name):
    m = trimesh.creation.extrude_polygon(poly, z1 - z0)
    m.apply_translation([0, 0, z0])
    m.visual.vertex_colors = colour
    m.metadata["name"] = name
    return m


def wall_mesh(a, b, t, z0, z1, extend_a, extend_b, colour, name):
    ax, ay = a
    bx, by = b
    n = math.hypot(bx - ax, by - ay)
    ux, uy = (bx - ax) / n, (by - ay) / n
    if extend_a:
        ax, ay = ax - ux * t / 2, ay - uy * t / 2
    if extend_b:
        bx, by = bx + ux * t / 2, by + uy * t / 2
    poly = LineString([(ax, ay), (bx, by)]).buffer(t / 2, cap_style=2, join_style=2)
    return extrude(poly, z0, z1, colour, name)


def touches_other(p, walls, me, ring):
    """Does the end point p meet another wall (a corner or a T junction) or the outer wall ring?"""
    if ring.exterior.distance(_pt(p)) < EPS:
        return True
    for w in walls:
        if w is me:
            continue
        if LineString([w["a"], w["b"]]).distance(_pt(p)) < EPS:
            return True
    return False


def _pt(p):
    from shapely.geometry import Point
    return Point(p)


scene = trimesh.Scene()
summary = {"version": P["version"], "params": P, "outline": OUTLINE, "proj_x": PROJ_X, "walls": [], "slabs": [], "voids": {}, "rooms": {"GF": [r["name"] for r in GF], "FF": [r["name"] for r in FF]}}
outline_poly = Polygon(OUTLINE)


TO_GLTF = np.array([[1, 0, 0, 0], [0, 0, 1, 0], [0, 1, 0, 0], [0, 0, 0, 1]], dtype=float)   # (x, y south, z up) -> (X east, Y up, Z south); its own inverse


def add(mesh):
    mesh.apply_transform(TO_GLTF)
    scene.add_geometry(mesh, node_name=mesh.metadata["name"], geom_name=mesh.metadata["name"])


def slab(name, poly, z0, z1):
    add(extrude(poly, z0, z1, COLOURS["slab"], name))
    summary["slabs"].append({"name": name, "area": round(poly.area, 4), "z0": z0, "z1": z1})


# slabs
slab("gf_slab", outline_poly, L["gf_floor"] - T_SLAB, L["gf_floor"])
ff_slab_poly = outline_poly.difference(unary_union([COURT_SKY, DH_VOID]))
slab("ff_slab", ff_slab_poly, L["ff_floor"] - T_SLAB, L["ff_floor"])
roof_poly = outline_poly.difference(unary_union([COURT_SKY, SUITE_COURT]))
slab("roof_slab", roof_poly, L["roof"] - T_SLAB, L["roof"])
summary["voids"] = {"ff": {"courtyard_sky": round(COURT_SKY.area, 4), "double_height_living": round(DH_VOID.area, 4)},
                    "roof": {"courtyard_sky": round(COURT_SKY.area, 4), "suite_court": round(SUITE_COURT.area, 4)}}

# outer walls: the outline ring, 0.25 m centred on the centre line, each storey
ring = outline_poly.buffer(T_OUT / 2, join_style=2).difference(outline_poly.buffer(-T_OUT / 2, join_style=2))
for floor, (z0, z1) in STOREY.items():
    add(extrude(ring, z0, z1, COLOURS["outer"], f"{floor.lower()}_outer"))
    summary["walls"].append({"floor": floor, "kind": "outer", "t": T_OUT, "z0": z0, "z1": z1, "length": round(outline_poly.exterior.length, 4)})

# interior walls
for floor, rooms in (("GF", GF), ("FF", FF)):
    z0, z1 = STOREY[floor]
    pieces, walls = wall_pieces(rooms, OPEN, floor)
    for i, w in enumerate(walls):
        top = z0 + w["h"] if w["kind"] == "low" else z1
        name = f"{floor.lower()}_{'low' if w['kind'] == 'low' else 'wall'}_{i:03d}"
        ea = touches_other(w["a"], walls, w, outline_poly)
        eb = touches_other(w["b"], walls, w, outline_poly)
        add(wall_mesh(w["a"], w["b"], T_IN, z0, top, ea, eb, COLOURS[w["kind"]], name))
        summary["walls"].append({"floor": floor, "kind": w["kind"], "name": name, "a": w["a"], "b": w["b"], "t": T_IN, "z0": z0, "z1": top,
                                 "length": round(math.dist(w["a"], w["b"]), 4)})

out = ROOT / P["output"]["glb"]
out.parent.mkdir(parents=True, exist_ok=True)
scene.export(out)
glb = out.read_bytes()
(ROOT / P["output"]["viewer_data"]).write_text(
    "// generated by 3d/build_3d.py · do not edit\nwindow.TAIF_HOUSE = " + json.dumps({"version": P["version"], "levels": L, "glb": base64.b64encode(glb).decode("ascii")}) + ";\n", encoding="utf-8")
(ROOT / P["output"]["summary"]).write_text(json.dumps(summary, indent=1), encoding="utf-8")
n_walls = sum(1 for w in summary["walls"] if w["kind"] in ("wall", "low"))
print(f"wrote {out.relative_to(ROOT.parent)}  · {len(glb) // 1024} kB · 3 slabs · 2 outer wall rings · {n_walls} interior walls "
      f"(GF {sum(1 for w in summary['walls'] if w['floor'] == 'GF' and w['kind'] != 'outer')}, FF {sum(1 for w in summary['walls'] if w['floor'] == 'FF' and w['kind'] != 'outer')})")
sys.exit(0)

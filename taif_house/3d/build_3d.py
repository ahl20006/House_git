"""build_3d.py · Taif / Palm House · builds the 3D model FROM the project files.
Phases 1–3: slabs and finishes, outer and interior walls, doors and windows (glass), the stair with its opening, trimmers and
balustrades, the colonnade columns, the edge beam, beam B5, the roof beams R6 / R11 (marked assumed / unconfirmed), railings,
coloured room plates, the sun positions and the eye-level bookmarks for the viewer.

Run from anywhere:   python taif_house/3d/build_3d.py
Reads (paths in 3d/params.yaml):
  data/rooms_gf.csv, data/rooms_ff.csv   every room (rectangles, or corner points in "pts"); # at the start of a name switches a row off
  design_gf.typ                          the outline (wall centre lines) and the air tower polygon
  studies/ff_family.typ                  the projection edge (proj-x) and the first-floor fixed elements (stair, lift, shaft, air tower)
  presentation.typ                       the ground-floor doors (gf-doors, with their kind) and windows (gf-windows)
  studies/ff_family.typ, ff_suite.typ    the first-floor doors (D(...)) and windows
  studies/structure.typ                  the stair (st), the columns C21–C23 / C33, the beams B3, B5, B16–B18, R6, R11
  studies/sections.typ, base.typ         the clerestory levels, the latitude, true north
  3d/open_edges.csv                      room edges that have NO wall (openings, railings) or a low wall (height > 0)
  3d/params.yaml                         levels, finishes, slab and wall thicknesses, opening heights, railing heights, views, sun
Writes: the GLB, the same GLB as base64 in a .js file for the viewer (with the rooms, flags, sun and bookmarks), and a JSON summary
for 3d/check_3d.py. Nothing in the output is edited by hand: change the project files or params.yaml and run this script again.

Frames: everything is built in the CSV frame (x east, y south, metres, origin = the building's north-west wall corner), which is
left-handed with z up; the GLB is Y-up and right-handed as glTF expects: X = x (east), Y = height, Z = y (south). The axis swap is
baked into every mesh (trimesh flips the face winding for it).
Levels: slabs and beams at STRUCTURAL levels (finished level − finish), doors, windows, stair and railings at FINISHED levels.
Walls stand on wall centre lines from the structural slab top to the underside of the slab above; walls meeting another wall are
lengthened by half a thickness to close the corner; the slabs run to the outer face of the outer walls.
Mesh names: <floor>_<kind>_<id> with floor = gf | ff | roof | all (columns), kind = slab, finish, outer, wall, low, glass, door, rail,
stair, beam, col, room. The viewer groups and colours the meshes by these names.
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
from shapely.geometry import LineString, MultiPolygon, Point, Polygon, box
from shapely.ops import unary_union

sys.stdout.reconfigure(encoding="utf-8", errors="replace")   # the messages use ≥ → · whatever the console code page
HERE = Path(__file__).resolve().parent          # taif_house/3d
ROOT = HERE.parent                              # taif_house
P = yaml.safe_load((HERE / "params.yaml").read_text(encoding="utf-8"))
EPS = 1e-6
SNAP = 0.02                                     # an opening must lie within this of its wall line (the cut wall's window corners are rounded in the study)


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


def live(block):
    """The block without its comment lines, keeping the end-of-line comments (they name the doors)."""
    return "\n".join(l for l in block.splitlines() if not l.strip().startswith("//"))


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


NUM = r"(-?\d+(?:\.\d+)?)"
PAIR = r"\(\s*" + NUM + r"\s*,\s*" + NUM + r"\s*\)"


def read_gf_openings(path):
    """presentation.typ: gf-doors = (G((x1, y1), (x2, y2), (ix, iy), "kind"),  // name ...) and gf-windows = (((x1, y1), (x2, y2)), ...)."""
    text = (ROOT / path).read_text(encoding="utf-8")
    doors, windows = [], []
    for line in live(grab(text, "gf-doors")).splitlines():
        for m in re.finditer(r"G\(\s*" + PAIR + r"\s*,\s*" + PAIR + r"\s*,\s*" + PAIR + r"\s*,\s*\"(\w+)\"\s*\)", line):
            name = line.split("//", 1)[1].strip() if "//" in line else m.group(7)
            doors.append({"floor": "GF", "a": (float(m.group(1)), float(m.group(2))), "b": (float(m.group(3)), float(m.group(4))), "kind": m.group(7), "name": name})
    for m in re.finditer(r"\(\s*" + PAIR + r"\s*,\s*" + PAIR + r"\s*\)", live(grab(text, "gf-windows"))):
        windows.append({"floor": "GF", "a": (float(m.group(1)), float(m.group(2))), "b": (float(m.group(3)), float(m.group(4)))})
    return doors, windows


def read_ff_openings(paths):
    """studies/ff_*.typ: doors = (D((x1, y1), (x2, y2), [label], "room", (ix, iy), from: "...", open: true), ...) and windows = (((x1, y1), (x2, y2)), ...)."""
    doors, windows = [], []
    for path in paths:
        text = (ROOT / path).read_text(encoding="utf-8")
        for m in re.finditer(r"D\(\s*" + PAIR + r"\s*,\s*" + PAIR + r"\s*,\s*\[([^\]]*)\]\s*,\s*\"([^\"]+)\"(.*?)\),?\s*$", live(grab(text, "doors")), re.M):
            label, room, rest = m.group(5), m.group(6), m.group(7)
            is_open = "open: true" in rest
            kind = "hinged" if not is_open else ("sliding" if "sliding" in label.lower() else "open")
            doors.append({"floor": "FF", "a": (float(m.group(1)), float(m.group(2))), "b": (float(m.group(3)), float(m.group(4))), "kind": kind, "name": f"{label} ({room})"})
        for m in re.finditer(r"\(\s*" + PAIR + r"\s*,\s*" + PAIR + r"\s*\)", live(grab(text, "windows"))):
            windows.append({"floor": "FF", "a": (float(m.group(1)), float(m.group(2))), "b": (float(m.group(3)), float(m.group(4)))})
    return doors, windows


def read_structure(path):
    """studies/structure.typ: the stair dictionary `st`, the columns and the beams (ids, lines, sizes)."""
    text = (ROOT / path).read_text(encoding="utf-8")
    st = {}
    for k, expr in re.findall(r"(\w+):\s*([\d. /*+-]+?)(?:,|\)$)", grab(text, "st").strip()[1:-1] + ")"):
        if not re.fullmatch(r"[\d. /*+-]+", expr.strip()):
            raise SystemExit(f"ERROR: stair value {k}: {expr!r}")
        st[k] = eval(expr, {"__builtins__": {}})   # arithmetic only, checked above
    cols = {}
    for m in re.finditer(r'\(\s*"(C\d+)"\s*,\s*' + NUM + r"\s*,\s*" + NUM + r'\s*,\s*"[^"]*"\s*,\s*"([^"]+)"', live(grab(text, "columns"))):
        size = m.group(4)
        if "Ø" in size:
            shape = {"round": float(size.replace("Ø", ""))}
        else:
            w, d = (float(v) for v in re.search(r"(\d\.\d+)×(\d\.\d+)", size).groups())
            shape = {"across": w, "along": d}
        cols[m.group(1)] = {"x": float(m.group(2)), "y": float(m.group(3)), "size": size, **shape}
    beams = {}
    for name in ("beams-ff", "beams-roof"):
        for m in re.finditer(r'\(\s*"([BR]\d+)"\s*,\s*' + PAIR + r"\s*,\s*" + PAIR + r'\s*,\s*"[^"]*"\s*,\s*"([^"]+)"', live(grab(text, name))):
            size = re.search(r"(\d\.\d+)×(\d\.\d+)", m.group(6))
            beams[m.group(1)] = {"a": (float(m.group(2)), float(m.group(3))), "b": (float(m.group(4)), float(m.group(5))), "level": name.split("-")[1],
                                 "w": float(size.group(1)) if size else None, "d": float(size.group(2)) if size else None, "size": m.group(6),
                                 "upturned": "upturned" in m.group(6).lower() and "or drop" not in m.group(6).lower()}
    return st, cols, beams


def read_let_number(path, name):
    m = re.search(r"^#let\s+" + re.escape(name) + r"\s*=\s*" + NUM, (ROOT / path).read_text(encoding="utf-8"), re.M)
    if not m:
        raise SystemExit(f"ERROR: '#let {name}' not found in {path}")
    return float(m.group(1))


def read_air(path):
    """studies/air_system.typ: every `#let air-<name> = (...)` tuple (the tower polygon, levels, route, box, chamber, kerb, grating ...)."""
    out = {}
    for m in re.finditer(r"^#let air-([\w-]+)\s*=\s*(\(.*?\))\s*(?://.*)?$", (ROOT / path).read_text(encoding="utf-8"), re.M):
        try:
            out[m.group(1)] = ast.literal_eval(m.group(2))
        except (ValueError, SyntaxError):
            pass   # expressions (air-length) are not data
    for k in ("tower", "head", "head-opening", "base", "route", "box", "clear", "invert", "channel", "chamber", "kerb", "grating"):
        if k not in out:
            raise SystemExit(f"ERROR: air-{k} not found in {path}")
    return out


def read_fixtures(path, dx, dy):
    """studies/east_wing.typ fixtures: (x0, y0, x1, y1, [label]) in the block's local frame."""
    out = []
    for m in re.finditer(r"\(\s*" + NUM + r"\s*,\s*" + NUM + r"\s*,\s*" + NUM + r"\s*,\s*" + NUM + r"\s*,\s*\[([^\]]*)\]", live(grab((ROOT / path).read_text(encoding="utf-8"), "fixtures"))):
        out.append({"box": (float(m.group(1)) + dx, float(m.group(2)) + dy, float(m.group(3)) + dx, float(m.group(4)) + dy), "label": m.group(5).replace("\\", " ")})
    return out


S = P["sources"]
gf_text = (ROOT / S["outline"]).read_text(encoding="utf-8")
fam_text = (ROOT / S["projection_edge"]).read_text(encoding="utf-8")
OUTLINE = [tuple(float(v) for v in p) for p in ast.literal_eval(grab(gf_text, "outline-csv-gf"))]
TOWER = [tuple(float(v) for v in p) for p in ast.literal_eval(re.search(r"#let tower-pts\s*=\s*(\(\(.*?\)\))\.map", gf_text).group(1))]
PROJ_X = float(re.search(r"#let proj-x\s*=\s*([\d.]+)", fam_text).group(1))
GF = read_rooms(S["rooms_gf"]) + [{"name": "Air tower", "colour": "tower", "pts": TOWER}]
FF_CSV = read_rooms(S["rooms_ff"])
FF = FF_CSV + read_fixed_ff(S["ff_fixed"])
court = next(r for r in GF if r["name"] == "Courtyard")
dh_living = next(r for r in GF if r["name"].startswith("Living (double height)"))
court_west = min(p[0] for p in court["pts"])
if abs(PROJ_X - court_west - P["projection"]["width"]) > EPS:
    raise SystemExit(f"ERROR: proj-x {PROJ_X} - courtyard edge {court_west} != projection width {P['projection']['width']} in params.yaml")

with open(ROOT / S["open_edges"], encoding="utf-8", newline="") as f:
    OPEN = [{"floor": r["floor"], "a": (float(r["x1"]), float(r["y1"])), "b": (float(r["x2"]), float(r["y2"])), "height": float(r["height"]), "kind": r["kind"], "note": r["note"]}
            for r in csv.DictReader(f)]
GF_DOORS, GF_WINDOWS = read_gf_openings(S["gf_openings"])
FF_DOORS, FF_WINDOWS = read_ff_openings(S["ff_openings"])
ST, COLS, BEAMS = read_structure(S["structure"])
CL_SILL, CL_HEAD = read_let_number(S["sections"], "cl-sill"), read_let_number(S["sections"], "cl-head")
LATITUDE = read_let_number(S["sections"], "latitude")
NORTH = tuple(float(v) for v in re.search(r"^#let north\s*=\s*\(\s*" + NUM + r"\s*,\s*" + NUM + r"\s*\)", (ROOT / S["north"]).read_text(encoding="utf-8"), re.M).groups())
FIXTURES_EAST = read_fixtures(S["fixtures_east"], 8.95, 0.0)
AIR = read_air(S["air_system"])
TOWER_HOLE = Polygon(AIR["tower"]).buffer(-0.1, join_style=2)   # the shaft: the slab opening inside the tower walls (B15 / R9 frame it)

# ---------- levels ----------
L = P["levels"]
FIN, T_SLAB = P["finish"], P["slab_thickness"]
T_OUT, T_IN = P["walls"]["outer"], P["walls"]["inner"]
FINISHED = {"GF": L["gf_floor"], "FF": L["ff_floor"]}
STRUCT_TOP = {"GF": L["gf_floor"] - FIN, "FF": L["ff_floor"] - FIN, "roof": L["roof"]}
STOREY = {"GF": (STRUCT_TOP["GF"], STRUCT_TOP["FF"] - T_SLAB), "FF": (STRUCT_TOP["FF"], STRUCT_TOP["roof"] - T_SLAB)}   # wall bottom (structural slab top), wall top (slab underside)

# ---------- voids (first floor): the courtyard sky and the double-height living, east of the projection edge ----------
east_of_projection = box(PROJ_X, -1e3, 1e3, 1e3)
COURT_SKY = Polygon(court["pts"]).intersection(east_of_projection)
DH_VOID = Polygon(dh_living["pts"]).intersection(east_of_projection)
SUITE_COURT = Polygon(next(r for r in FF if r["colour"] in ("open", "terrace"))["pts"])   # open to the sky: a hole in the roof
# the stair opening in the first-floor slab (studies/structure.typ: over flight 1 beyond the trimmer B16, over the half landing and flight 2)
STAIR_OPENING = unary_union([box(ST["x0"], ST["y0"], ST["split"], ST["b16"] - T_IN / 2), box(ST["split"], ST["y0"], ST["x1"], ST["top"])])


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
COLOURS = {"slab": [205, 200, 190, 255], "finish": [222, 218, 208, 255], "outer": [120, 112, 100, 255], "wall": [190, 182, 170, 255], "low": [200, 167, 126, 255],
           "glass": [120, 185, 225, 110], "door": [150, 100, 60, 255], "rail": [70, 70, 80, 255], "stair": [175, 170, 160, 255],
           "assumed": [235, 150, 50, 255], "unconfirmed": [205, 55, 45, 255],
           "room": {"court": [185, 220, 235, 255], "family": [246, 227, 192, 255], "guest": [233, 215, 190, 255], "service": [214, 228, 236, 255],
                    "core": [226, 220, 208, 255], "circ": [240, 237, 229, 255], "tower": [214, 226, 206, 255], "open": [250, 250, 250, 255]}}
TO_GLTF = np.array([[1, 0, 0, 0], [0, 0, 1, 0], [0, 1, 0, 0], [0, 0, 0, 1]], dtype=float)   # (x, y south, z up) -> (X east, Y up, Z south); its own inverse
scene = trimesh.Scene()
summary = {"version": P["version"], "params": P, "outline": OUTLINE, "proj_x": PROJ_X, "levels": {"finished": FINISHED, "structural_top": STRUCT_TOP, "storey": STOREY},
           "walls": [], "slabs": [], "voids": {}, "openings": [], "stair": {}, "structure": {"columns": [], "beams": []}, "rails": [], "flags": [],
           "rooms": {"GF": [r["name"] for r in GF], "FF": [r["name"] for r in FF]}}
outline_poly = Polygon(OUTLINE)
outer_face = outline_poly.buffer(T_OUT / 2, join_style=2)          # the outer face of the outer walls
ring = outer_face.difference(outline_poly.buffer(-T_OUT / 2, join_style=2))


def polys(geom):
    if geom.is_empty:
        return []
    if isinstance(geom, Polygon):
        return [geom]
    if isinstance(geom, MultiPolygon):
        return list(geom.geoms)
    return [g for g in getattr(geom, "geoms", []) if isinstance(g, Polygon) and not g.is_empty]


def extrude(geom, z0, z1, colour, name):
    parts = []
    for poly in polys(geom):
        m = trimesh.creation.extrude_polygon(poly, z1 - z0)
        m.apply_translation([0, 0, z0])
        parts.append(m)
    if not parts:
        return None
    m = trimesh.util.concatenate(parts) if len(parts) > 1 else parts[0]
    m.visual.vertex_colors = colour
    m.metadata["name"] = name
    return m


def add(mesh):
    if mesh is None:
        return
    mesh.apply_transform(TO_GLTF)
    scene.add_geometry(mesh, node_name=mesh.metadata["name"], geom_name=mesh.metadata["name"])


def seg_box(a, b, t):
    return LineString([a, b]).buffer(t / 2, cap_style=2, join_style=2)


def slab(name, poly, z0, z1):
    add(extrude(poly, z0, z1, COLOURS["slab"], name))
    summary["slabs"].append({"name": name, "area": round(poly.area, 4), "z0": z0, "z1": z1})


# ---------- slabs (structural) and floor finishes, to the outer face of the outer walls ----------
slab("gf_slab", outer_face, STRUCT_TOP["GF"] - T_SLAB, STRUCT_TOP["GF"])
ff_slab_poly = outer_face.difference(unary_union([COURT_SKY, DH_VOID, STAIR_OPENING, TOWER_HOLE]))
slab("ff_slab", ff_slab_poly, STRUCT_TOP["FF"] - T_SLAB, STRUCT_TOP["FF"])
roof_poly = outer_face.difference(unary_union([COURT_SKY, SUITE_COURT, TOWER_HOLE]))
slab("roof_slab", roof_poly, STRUCT_TOP["roof"] - T_SLAB, STRUCT_TOP["roof"])
add(extrude(outer_face.difference(ring), STRUCT_TOP["GF"], FINISHED["GF"], COLOURS["finish"], "gf_finish_floor"))
add(extrude(ff_slab_poly.difference(ring), STRUCT_TOP["FF"], FINISHED["FF"], COLOURS["finish"], "ff_finish_floor"))
add(extrude(roof_poly, STRUCT_TOP["roof"], STRUCT_TOP["roof"] + P["roof_finish"], COLOURS["finish"], "roof_finish_floor"))
summary["voids"] = {"ff": {"courtyard_sky": round(COURT_SKY.area, 4), "double_height_living": round(DH_VOID.area, 4), "stair_opening": round(STAIR_OPENING.area, 4), "tower_shaft": round(TOWER_HOLE.area, 4)},
                    "roof": {"courtyard_sky": round(COURT_SKY.area, 4), "suite_court": round(SUITE_COURT.area, 4), "tower_shaft": round(TOWER_HOLE.area, 4)}}

# ---------- room plates (colour by room type, for the plan views) ----------
for floor, rooms in (("GF", GF), ("FF", FF_CSV)):
    for i, r in enumerate(rooms):
        poly = Polygon(r["pts"]).buffer(-0.1, join_style=2)
        if floor == "FF":
            poly = poly.difference(unary_union([COURT_SKY, DH_VOID]))
        add(extrude(poly, FINISHED[floor], FINISHED[floor] + 0.01, COLOURS["room"].get(r["colour"], [235, 235, 235, 255]), f"{floor.lower()}_room_{i:02d}"))


# ---------- openings: doors and windows matched to their walls ----------
def on_line(p, a, b):
    return LineString([a, b]).distance(Point(p)) < SNAP


def project(p, a, b):
    ln = LineString([a, b])
    q = ln.interpolate(ln.project(Point(p)))
    return (round(q.x, 6), round(q.y, 6))


def opening_heights(o, floor):
    f = FINISHED[floor]
    if o["kind"] == "window":
        key = " ".join(f"{v:g}" for v in (*o["a"], *o["b"])).replace("13.311", "13.311")
        for w in P["openings"]["windows"]:
            if w["floor"] == floor and all(abs(float(x) - y) < 1e-6 for x, y in zip(w["at"].split(), (*o["a"], *o["b"]))):
                w["_used"] = True
                return f + w["sill"], f + w["head"], w.get("note", "")
        return f + P["openings"]["window"]["sill"], f + P["openings"]["window"]["head"], "default window"
    return STRUCT_TOP[floor], f + P["openings"]["door_height"], o["name"]


def build_walls(floor, walls, ops):
    """Walls of one floor with their openings: the solid part, the sill and lintel pieces, the glass and the door leaves."""
    z0, z1 = STOREY[floor]
    leaf, glass_t = P["openings"]["leaf"], P["openings"]["glass"]
    unmatched = list(ops)
    zcut = FINISHED[floor] + P["plan_cut"]
    cuts = []         # the wall footprints sectioned at the plan cut (minus the openings that cross it), for the plan views
    footprints = []   # (name, footprint, zb, zt, colour, wall record)
    for i, w in enumerate(walls):
        top = FINISHED[floor] + w["h"] if w["kind"] == "low" else z1
        name = f"{floor.lower()}_{'low' if w['kind'] == 'low' else 'wall'}_{i:03d}"
        ea = touches_other(w["a"], walls, w, outline_poly)
        eb = touches_other(w["b"], walls, w, outline_poly)
        a, b = w["a"], w["b"]
        ux, uy = (b[0] - a[0]) / math.dist(a, b), (b[1] - a[1]) / math.dist(a, b)
        a2 = (a[0] - ux * T_IN / 2, a[1] - uy * T_IN / 2) if ea else a
        b2 = (b[0] + ux * T_IN / 2, b[1] + uy * T_IN / 2) if eb else b
        colour = COLOURS[w["kind"]]
        if floor == "FF" and any(on_line(w["a"], (u[0], u[1]), (u[2], u[3])) and on_line(w["b"], (u[0], u[1]), (u[2], u[3])) for u in P["structure"]["unconfirmed_walls"]):
            colour = COLOURS["unconfirmed"]
            summary["flags"].append(f"FF wall {w['a']}–{w['b']} carries the gym roof beam R6 over the men's majlis ribs: proposed load path, NOT verified (X5)")
        footprints.append((name, seg_box(a2, b2, T_IN), z0, top, colour, {"floor": floor, "kind": w["kind"], "name": name, "a": w["a"], "b": w["b"], "t": T_IN, "z0": z0, "z1": top, "length": round(math.dist(a, b), 4)}))
    footprints.append((f"{floor.lower()}_outer", ring, z0, z1, COLOURS["outer"], {"floor": floor, "kind": "outer", "name": f"{floor.lower()}_outer", "t": T_OUT, "z0": z0, "z1": z1, "length": round(outline_poly.exterior.length, 4)}))
    for name, foot, zb, zt, colour, rec in footprints:
        solid = foot
        cut = foot if zt > zcut else None
        extra = []
        for o in list(unmatched):
            if rec["kind"] == "outer":
                hit = any(on_line(o["a"], p, q) and on_line(o["b"], p, q) for p, q in edges(OUTLINE))
                line = next(((p, q) for p, q in edges(OUTLINE) if on_line(o["a"], p, q) and on_line(o["b"], p, q)), None)
            else:
                hit = rec["kind"] != "low" and on_line(o["a"], rec["a"], rec["b"]) and on_line(o["b"], rec["a"], rec["b"])
                line = (rec["a"], rec["b"])
            if not hit:
                continue
            unmatched.remove(o)
            a, b = project(o["a"], *line), project(o["b"], *line)
            zs, zh, note = opening_heights(o, floor)
            t = rec["t"]
            solid = solid.difference(seg_box(a, b, t + 0.02))
            if cut is not None and zs < zcut < zh:
                cut = cut.difference(seg_box(a, b, t + 0.02))
            core = seg_box(a, b, t).intersection(foot)
            n = len(summary["openings"])
            if zs > zb + EPS:
                extra.append((core, zb, zs, f"{name}_sill{n}"))
            if zh < zt - EPS:
                extra.append((core, zh, zt, f"{name}_head{n}"))
            if o["kind"] == "window":
                add(extrude(seg_box(a, b, glass_t), zs, zh, COLOURS["glass"], f"{floor.lower()}_glass_{n:03d}"))
            elif o["kind"] != "open":
                is_glass = any(abs(float(gx) - o["a"][0]) < 1e-6 and abs(float(gy) - o["a"][1]) < 1e-6 for gx, gy in (s.split() for s in P["openings"]["glass_doors"]))
                add(extrude(seg_box(a, b, glass_t if is_glass else leaf), FINISHED[floor], zh, COLOURS["glass" if is_glass else "door"], f"{floor.lower()}_{'glass' if is_glass else 'door'}_{n:03d}"))
            summary["openings"].append({"floor": floor, "kind": o["kind"], "name": note if o["kind"] == "window" else o["name"], "a": a, "b": b, "width": round(math.dist(a, b), 3),
                                        "sill": round(zs, 3), "head": round(zh, 3), "wall": name})
        add(extrude(solid, zb, zt, colour, name))
        for core, za, zc, nm in extra:
            add(extrude(core, za, zc, colour, nm))
        summary["walls"].append(rec)
        if cut is not None:
            cuts.append(cut)
    PLAN_CUTS[floor] = unary_union(cuts)
    return unmatched


def touches_other(p, walls, me, outline):
    """Does the end point p meet another wall (a corner or a T junction) or the outline (the outer wall)?"""
    if outline.exterior.distance(Point(p)) < EPS:
        return True
    return any(w is not me and LineString([w["a"], w["b"]]).distance(Point(p)) < EPS for w in walls)


def on_open_edge(o, floor):
    return any(e["floor"] == floor and e["height"] == 0 and on_line(o["a"], e["a"], e["b"]) and on_line(o["b"], e["a"], e["b"]) for e in OPEN)


skipped, open_doors, PLAN_CUTS = [], [], {}
for floor, rooms, doors, windows in (("GF", GF, GF_DOORS, GF_WINDOWS), ("FF", FF, FF_DOORS, FF_WINDOWS)):
    pieces, walls = wall_pieces(rooms, OPEN, floor)
    ops = []
    for d in doors:
        key = f"{d['a'][0]:g} {d['a'][1]:g}"
        if key in P["openings"]["skip_doors"]:
            skipped.append(f"{floor} {d['name']} (params: skip_doors)")
            continue
        if d["kind"] == "open" and on_open_edge(d, floor):
            open_doors.append(f"{floor} {d['name']}")      # already an open edge: nothing to cut
            continue
        ops.append({"kind": "door" if d["kind"] != "open" else "open", "a": d["a"], "b": d["b"], "name": d["name"], "door_kind": d["kind"]})
    for w in windows:
        ops.append({"kind": "window", "a": w["a"], "b": w["b"], "name": ""})
    left = build_walls(floor, walls, ops)
    if left:
        raise SystemExit(f"ERROR: {floor} openings on no wall: {[(o['kind'], o['a'], o['b'], o['name']) for o in left]}")
unused = [w for w in P["openings"]["windows"] if not w.get("_used")]
if unused:
    raise SystemExit(f"ERROR: params.yaml window heights that match no window of the plans: {[w['at'] for w in unused]}")
summary["openings_note"] = {"skipped": skipped, "open_edges": open_doors}


# ---------- the stair (studies/structure.typ · st): two flights side by side, half landing at the north end, arrival at the south end ----------
def profile_mesh(profile_yz, x0, x1, colour, name):
    """A polygon in the (y, z) plane extruded from x0 to x1."""
    m = trimesh.creation.extrude_polygon(Polygon(profile_yz), x1 - x0)   # built in (y, z, w)
    m.vertices = m.vertices[:, [2, 0, 1]] + np.array([x0, 0, 0])          # (w, y, z) -> (x, y, z)
    # (w, y, z) -> (x, y, z) is a cyclic permutation: the winding is kept
    m.visual.vertex_colors = colour
    m.metadata["name"] = name
    return m


r, g = ST["r"], ST["g"]
risers = round(FINISHED["FF"] / r)
if abs(risers * r - (FINISHED["FF"] - FINISHED["GF"])) > 1e-6:
    raise SystemExit(f"ERROR: {risers} risers × {r} != the storey height")
per_flight = risers // 2
waist = P["stair"]["waist"]
land_level = FINISHED["GF"] + per_flight * r
f1x = (ST["x0"], ST["split"] - ST["gap"] / 2)       # flight 1: west, rises to the north
f2x = (ST["split"] + ST["gap"] / 2, ST["x1"])       # flight 2: east, rises to the south
# flight 1 profile: nosings from (top, 0) up to (land, land_level); soffit back down
p1 = [(ST["top"], FINISHED["GF"])]
for i in range(1, per_flight):
    p1 += [(ST["top"] - (i - 1) * g, FINISHED["GF"] + i * r), (ST["top"] - i * g, FINISHED["GF"] + i * r)]
p1 += [(ST["land"], FINISHED["GF"] + per_flight * r - r), (ST["land"], land_level), (ST["land"], land_level - waist - r), (ST["top"] - 0.001, FINISHED["GF"])]
add(profile_mesh(p1, *f1x, COLOURS["stair"], "gf_stair_flight1"))
# flight 2 profile: from the landing (land, land_level) up to (top, FF)
p2 = [(ST["land"], land_level)]
for i in range(1, per_flight):
    p2 += [(ST["land"] + (i - 1) * g, land_level + i * r), (ST["land"] + i * g, land_level + i * r)]
p2 += [(ST["top"], land_level + per_flight * r - r), (ST["top"], FINISHED["FF"]), (ST["top"], FINISHED["FF"] - waist - r), (ST["land"] + 0.001, land_level - waist - r)]
add(profile_mesh(p2, *f2x, COLOURS["stair"], "gf_stair_flight2"))
add(extrude(box(ST["x0"], ST["y0"], ST["x1"], ST["land"]), land_level - waist - FIN, land_level, COLOURS["stair"], "gf_stair_landing"))
# trimmers (B16–B18 from the structural study, total depth incl. the slab): the part below the slab
for bid in ("B16", "B17", "B18"):
    b = BEAMS[bid]
    add(extrude(seg_box(b["a"], b["b"], b["w"]), STRUCT_TOP["FF"] - b["d"], STRUCT_TOP["FF"] - T_SLAB, COLOURS["assumed"], f"ff_beam_{bid}"))
    summary["structure"]["beams"].append({"id": bid, "a": b["a"], "b": b["b"], "w": b["w"], "d": b["d"], "z0": round(STRUCT_TOP["FF"] - b["d"], 3), "z1": round(STRUCT_TOP["FF"] - T_SLAB, 3), "state": "assumed", "note": "stair trimmer"})
# balustrades (panels, assumed): central between the flights, the east side of flight 2 and the landing (open to the riwaq), the first-floor well edges
hr, rh, bt = P["handrail_height"], P["railing_height"], P["stair"]["balustrade"]
z1 = lambda y: FINISHED["GF"] + (ST["top"] - y) / g * r            # flight 1 nosing line
z2 = lambda y: land_level + (y - ST["land"]) / g * r                # flight 2 nosing line
add(profile_mesh([(ST["land"], z1(ST["land"])), (ST["top"], z1(ST["top"])), (ST["top"], z2(ST["top"]) + hr), (ST["land"], z2(ST["land"]) + hr)], ST["split"] - bt / 2, ST["split"] + bt / 2, COLOURS["rail"], "gf_rail_stair_centre"))
add(profile_mesh([(ST["land"], z2(ST["land"])), (ST["top"], z2(ST["top"])), (ST["top"], z2(ST["top"]) + hr), (ST["land"], z2(ST["land"]) + hr)], ST["x1"] - bt, ST["x1"], COLOURS["rail"], "gf_rail_stair_east"))
gf_open_stair = next(e for e in OPEN if e["floor"] == "GF" and "stair" in e["note"])
add(extrude(box(ST["x1"] - bt, min(gf_open_stair["a"][1], gf_open_stair["b"][1]), ST["x1"], ST["land"]), land_level, land_level + hr, COLOURS["rail"], "gf_rail_stair_landing"))
rails_ff = [((ST["x0"], ST["b16"] - T_IN / 2), (ST["split"], ST["b16"] - T_IN / 2), "stair well, over flight 1"),
            ((ST["split"], ST["b16"] - T_IN / 2), (ST["split"], ST["top"]), "stair well, between the flights"),
            ((2.75, ST["y0"]), (2.75, ST["top"]), "gallery edge on the stair well")]
summary["stair"] = {"risers": risers, "riser": round(r, 4), "going": g, "per_flight": per_flight, "landing_level": round(land_level, 3), "well": [ST["x0"], ST["y0"], ST["x1"], ST["y1"]],
                    "flight1_x": f1x, "flight2_x": f2x, "landing_y": [ST["y0"], ST["land"]], "flights_y": [ST["land"], ST["top"]], "arrival_y": [ST["top"], ST["y1"]],
                    "opening_area": round(STAIR_OPENING.area, 3), "opening_wkt": STAIR_OPENING.wkt,
                    # tread i (level i × r) runs from the nosing of riser i to riser i + 1; the top riser of each flight lands on the half landing / the first floor
                    "nosings": [{"flight": 1, "tread": i, "x": round(sum(f1x) / 2, 4), "y": round(ST["top"] - (i - 1) * g, 4), "y_mid": round(ST["top"] - (i - 0.5) * g, 4), "z": round(FINISHED["GF"] + i * r, 4)} for i in range(1, per_flight + 1)]
                             + [{"flight": 2, "tread": i, "x": round(sum(f2x) / 2, 4), "y": round(ST["land"] + (i - 1) * g, 4), "y_mid": round(ST["land"] + (i - 0.5) * g, 4), "z": round(land_level + i * r, 4)} for i in range(1, per_flight + 1)],
                    "flight_clear_width": round(f1x[1] - f1x[0], 4)}

# ---------- railings on the first-floor open edges (gallery on the upturned edge beam, courtyard edge, stair well) ----------
b3 = BEAMS["B3"]
upturned = P["structure"]["edge_beam_upturned"]
b3_top = STRUCT_TOP["FF"] - T_SLAB + b3["d"] if upturned else STRUCT_TOP["FF"]
rails_ff.append((b3["a"], b3["b"], "gallery edge, on the upturned edge beam B3" if upturned else "gallery edge"))
rails_ff.append(((4.25, 6.5), (PROJ_X, 6.5), "family living edge on the courtyard sky"))
rails_ff.append(((PROJ_X, 6.5), (8.95, 6.5), "family living edge on the courtyard sky"))
for i, (a, b, note) in enumerate(rails_ff):
    base = b3_top if "B3" in note else FINISHED["FF"]
    add(extrude(seg_box(a, b, bt), base, FINISHED["FF"] + rh, COLOURS["rail"], f"ff_rail_{i:02d}"))
    summary["rails"].append({"a": a, "b": b, "z0": round(base, 3), "z1": round(FINISHED["FF"] + rh, 3), "note": note})

# ---------- the structure of the zone (assumed / unconfirmed): columns C21–C23 (to the roof, X8) and C33, beams B3, B5, R11, R6 ----------
for cid in P["structure"]["assumed"]:
    if cid in COLS:
        c = COLS[cid]
        to_roof = cid in P["structure"]["column_to_roof"] or True   # every column of the study runs to the roof
        if "round" in c:
            foot = Point(c["x"], c["y"]).buffer(c["round"] / 2, resolution=12)
        else:   # along the wall the column stands in: the outer walls x 0 / x 13.311 run north–south, y 0 / y 24 east–west
            along_y = abs(c["x"]) < EPS or abs(c["x"] - max(p[0] for p in OUTLINE)) < EPS
            w, d = (c["across"], c["along"]) if along_y else (c["along"], c["across"])
            foot = box(c["x"] - w / 2, c["y"] - d / 2, c["x"] + w / 2, c["y"] + d / 2)
        add(extrude(foot, STRUCT_TOP["GF"], STRUCT_TOP["roof"] - T_SLAB, COLOURS["assumed"], f"all_col_{cid}"))
        summary["structure"]["columns"].append({"id": cid, "x": c["x"], "y": c["y"], "size": c["size"], "z0": STRUCT_TOP["GF"], "z1": STRUCT_TOP["roof"] - T_SLAB, "state": "assumed",
                                                "bounds": [round(v, 4) for v in foot.bounds], "to_roof": to_roof})
for bid, state in [(b, "assumed") for b in P["structure"]["assumed"] if b in BEAMS and b not in ("B16", "B17", "B18")] + [(b, "unconfirmed") for b in P["structure"]["unconfirmed"]]:
    b = BEAMS[bid]
    top = STRUCT_TOP["FF"] if b["level"] == "ff" else STRUCT_TOP["roof"]
    if bid == "B3" and upturned:
        z0, z1 = top - T_SLAB, top - T_SLAB + b["d"]
    else:
        z0, z1 = top - b["d"], top - T_SLAB
    add(extrude(seg_box(b["a"], b["b"], b["w"]), z0, z1, COLOURS[state], f"{'ff' if b['level'] == 'ff' else 'roof'}_beam_{bid}"))
    summary["structure"]["beams"].append({"id": bid, "a": b["a"], "b": b["b"], "w": b["w"], "d": b["d"], "z0": round(z0, 3), "z1": round(z1, 3), "state": state, "note": b["size"]})
    if state == "unconfirmed":
        summary["flags"].append(f"{bid} ({b['size']}): proposed load path on the first-floor walls x 5.6 and x 11.586 over the men's majlis ribs, NOT verified (X5)")
# the plan cuts: walls (built above) and columns sectioned at the plan-cut height, a thin dark plate shown only in the viewer's plan views
for floor in ("GF", "FF"):
    cols_cut = unary_union([box(*c["bounds"]) for c in summary["structure"]["columns"]])
    zc = FINISHED[floor] + P["plan_cut"]
    add(extrude(unary_union([PLAN_CUTS[floor], cols_cut]), zc, zc + 0.02, [70, 70, 70, 255], f"{floor.lower()}_plancut"))
summary["flags"].insert(0, "Orange elements (columns C21–C23 to the roof, C33, beams B3, B5, R11, trimmers B16–B18): sizes assumed in studies/structure.typ, not approved by the engineer")
# X3: the suite bath east window against column C33 (the column keeps its assumed size and orientation)
c33 = next(c for c in summary["structure"]["columns"] if c["id"] == "C33")
x3 = next(o for o in summary["openings"] if o["floor"] == "FF" and "suite bath east" in o["name"])
clear = c33["bounds"][1] - max(x3["a"][1], x3["b"][1])    # the window ends north of the column: gap between the window's south jamb and the column's north face
summary["flags"].append(f"X3: suite bath east window y {min(x3['a'][1], x3['b'][1]):g}–{max(x3['a'][1], x3['b'][1]):g} against column C33 ({c33['size']} along the wall, y {c33['bounds'][1]:g}–{c33['bounds'][3]:g}): "
                        f"clearance {clear:+.2f} m ({'CLASH' if clear < 0 else 'clear'}); the column's size and orientation are for the engineer")
summary["x3_clearance"] = round(clear, 3)

# ---------- the air system (studies/air_system.typ): tower head, base box, tunnel, water channel, outlet chamber, kerb · all assumed ----------
A = AIR
tower_poly = Polygon(A["tower"])
roof_fin = STRUCT_TOP["roof"] + P["roof_finish"]
head_ring = tower_poly.buffer(T_OUT / 2, join_style=2).difference(tower_poly.buffer(-0.1, join_style=2))
h0, h1 = A["head"]
os_, oh = A["head-opening"]
head_solid = head_ring
for a, b in (((9.1, 0.0), (9.9, 0.0)), ((8.95, 0.1), (8.95, 0.9))):       # louvred openings on the north and west faces, 0.8 wide
    head_solid = head_solid.difference(seg_box(a, b, T_OUT + 0.02))
    add(extrude(seg_box(a, b, 0.02), os_, oh, COLOURS["glass"], f"roof_air_louvre_{int(a[1] * 10)}"))
    add(extrude(seg_box(a, b, T_OUT).intersection(head_ring), h0, os_, COLOURS["outer"], f"roof_air_head_sill_{int(a[1] * 10)}"))
    add(extrude(seg_box(a, b, T_OUT).intersection(head_ring), oh, h1, COLOURS["outer"], f"roof_air_head_lintel_{int(a[1] * 10)}"))
add(extrude(head_solid, h0, h1, COLOURS["outer"], "roof_air_head"))
add(extrude(tower_poly.buffer(0.25, join_style=2), h1, h1 + 0.15, COLOURS["slab"], "roof_air_cap"))
# the base box under the tower (one RC box with the shaft walls), the tunnel (two legs) and the outlet chamber: walls 0.20, floor 0.25
zb0, zb1 = A["base"][1], STRUCT_TOP["GF"] - T_SLAB      # box underside ... ground slab underside
add(extrude(tower_poly.buffer(T_OUT / 2, join_style=2).difference(tower_poly.buffer(-0.1, join_style=2)), zb0 + 0.25, zb1, COLOURS["assumed"], "gf_air_base_walls"))
add(extrude(tower_poly.buffer(T_OUT / 2, join_style=2), zb0, zb0 + 0.25, COLOURS["assumed"], "gf_air_base_floor"))
bw, bt, bb = A["box"]
legs = list(zip(A["route"][:-1], A["route"][1:]))
foot = unary_union([seg_box(a, b, bw) for a, b in legs] + [Point(A["route"][1]).buffer(bw / 2, resolution=4)])
inner = unary_union([seg_box(a, b, A["clear"][0]) for a, b in legs] + [Point(A["route"][1]).buffer(A["clear"][0] / 2, resolution=4)])
tower_out = tower_poly.buffer(T_OUT / 2, join_style=2)
add(extrude(foot.difference(inner).difference(tower_out), bb + 0.25, bt - 0.2, COLOURS["assumed"], "gf_air_tunnel_walls"))
add(extrude(foot.difference(tower_out), bb, bb + 0.25, COLOURS["assumed"], "gf_air_tunnel_floor"))
add(extrude(foot.difference(tower_out), bt - 0.2, bt, COLOURS["assumed"], "gf_air_tunnel_roof"))
cx0, cy0, cx1, cy1 = A["chamber"]
ch_out, ch_in = box(cx0, cy0, cx1, cy1), box(cx0 + 0.2, cy0 + 0.2, cx1 - 0.2, cy1 - 0.2)
add(extrude(ch_out.difference(ch_in), bb + 0.25, zb1, COLOURS["assumed"], "gf_air_chamber_walls"))
add(extrude(ch_out, bb, bb + 0.25, COLOURS["assumed"], "gf_air_chamber_floor"))
kx0, ky0, kx1, ky1, kh = A["kerb"]
add(extrude(box(kx0, ky0, kx1, ky1), FINISHED["GF"], FINISHED["GF"] + kh, COLOURS["assumed"], "gf_air_kerb"))
gx0, gy0, gx1, gy1 = A["grating"]
add(extrude(box(gx0, gy0, gx1, gy1), FINISHED["GF"] - 0.02, FINISHED["GF"] + 0.005, COLOURS["rail"], "gf_air_grating"))
c0, c1 = A["channel"]
add(extrude(seg_box((A["route"][2][0], c0), (A["route"][2][0], c1), 0.4), A["invert"][1] - 0.02, A["invert"][1] + 0.06, [79, 159, 207, 255], "gf_air_water"))
add(extrude(ring, -0.6, -0.5, COLOURS["outer"], "gf_air_outline"))   # the building's outline below the ground slab, for the underground plan view
summary["air"] = {"tower": A["tower"], "head": [h0, h1], "base": A["base"], "route": A["route"], "box": A["box"], "clear": A["clear"], "invert": A["invert"], "channel": A["channel"], "chamber": A["chamber"],
                  "kerb": A["kerb"], "tunnel_footprint_wkt": foot.wkt, "tower_shaft_area": round(TOWER_HOLE.area, 4)}
summary["flags"].append("Air system (studies/air_system.typ): tower head, base box, tunnel route A, water channel and outlet chamber modelled with ASSUMED sizes and levels (MEP / structural engineer)")

# ---------- the sun (Taif) in the model frame ----------
nx, ny = NORTH                                   # true north on the drawing: canvas x east, y up (= plan north)
north_m = (nx, -ny)                              # (X east, Z south)
east_m = (-north_m[1], north_m[0])
north_bearing = math.degrees(math.atan2(nx, ny))  # true north is this many degrees east of the plans' north


def sun(day, hour):
    lat, decl = math.radians(LATITUDE), math.radians(23.44 * math.sin(math.radians(360 * (284 + day) / 365)))
    H = math.radians(15 * (hour - 12))
    el = math.asin(math.sin(lat) * math.sin(decl) + math.cos(lat) * math.cos(decl) * math.cos(H))
    cos_az = (math.sin(decl) - math.sin(lat) * math.sin(el)) / (math.cos(lat) * math.cos(el))
    az = math.degrees(math.acos(max(-1, min(1, cos_az))))
    if hour > 12:
        az = 360 - az
    a, h = math.radians(az), el
    d = (math.cos(h) * (north_m[0] * math.cos(a) + east_m[0] * math.sin(a)), math.sin(h), math.cos(h) * (north_m[1] * math.cos(a) + east_m[1] * math.sin(a)))
    return {"azimuth": round(az, 1), "elevation": round(math.degrees(el), 1), "dir": [round(v, 4) for v in d]}


SUN = {f"{season}-{hour:02d}": sun(day, hour) for season, day in P["sun"]["days"].items() for hour in P["sun"]["hours"]}
summary["sun"] = {"latitude": LATITUDE, "true_north_bearing_from_plan_north": round(north_bearing, 1), "positions": SUN}

# ---------- write ----------
out = ROOT / P["output"]["glb"]
out.parent.mkdir(parents=True, exist_ok=True)
scene.export(out)
glb = out.read_bytes()
rooms_js = [{"floor": fl, "name": r["name"], "colour": r["colour"], "c": [round(v, 3) for v in Polygon(r["pts"]).representative_point().coords[0]]}
            for fl, rooms in (("GF", GF), ("FF", FF_CSV)) for r in rooms]
bm = {k: {"title": v["title"], "eye": [v["eye"][0], v["eye"][2], v["eye"][1]], "target": [v["target"][0], v["target"][2], v["target"][1]]} for k, v in P["views"]["bookmarks"].items()}
data = {"version": P["version"], "levels": {"finished": FINISHED, "structural_top": STRUCT_TOP, "finish": FIN}, "rooms": rooms_js, "flags": summary["flags"],
        "sun": SUN, "true_north": [north_m[0], north_m[1]], "north_bearing": round(north_bearing, 1), "bookmarks": bm, "extent": [list(outer_face.bounds)], "glb": base64.b64encode(glb).decode("ascii")}
(ROOT / P["output"]["viewer_data"]).write_text("// generated by 3d/build_3d.py · do not edit\nwindow.TAIF_HOUSE = " + json.dumps(data) + ";\n", encoding="utf-8")
(ROOT / P["output"]["summary"]).write_text(json.dumps(summary, indent=1, default=str), encoding="utf-8")
n_walls = sum(1 for w in summary["walls"] if w["kind"] in ("wall", "low"))
n_doors = sum(1 for o in summary["openings"] if o["kind"] != "window")
n_win = sum(1 for o in summary["openings"] if o["kind"] == "window")
print(f"wrote {out.relative_to(ROOT.parent)}  · {len(glb) // 1024} kB · 3 slabs · {n_walls} interior walls · {n_doors} doors · {n_win} windows · stair {risers} risers · "
      f"{len(summary['structure']['columns'])} columns · {len(summary['structure']['beams'])} beams · {len(summary['flags'])} flags")
sys.exit(0)

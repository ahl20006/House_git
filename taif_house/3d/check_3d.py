"""check_3d.py · Taif / Palm House · checks the 3D model against the project files (also called from tools/check.py).

Run from anywhere:   python taif_house/3d/check_3d.py     (after 3d/build_3d.py)
It reads data/rooms_*.csv, design_gf.typ, studies/ff_family.typ, 3d/params.yaml, 3d/open_edges.csv, 3d/output/model_summary.json and the GLB, and checks:
  1. every room of both floors is enclosed: each piece of every room edge is on the outline, on a built wall or on a listed open edge;
  2. no duplicate walls (no two walls of one floor overlap on the same line); every wall has the thickness of params.yaml (measured in the GLB)
     and the full storey height (or the low-partition height);
  3. the slab areas measured in the GLB equal the CSV room totals: GF = rooms + courtyard + air tower; FF = rooms + suite court + the fixed elements;
     the voids equal the courtyard sky and the double-height living east of the projection; the roof holes equal the courtyard sky + the suite court;
  4. the model fits the outline (plus the outer wall) and the levels of params.yaml.
Ends with "3D CHECKS PASSED" or a list of problems (exit code 1).
"""
import csv
import json
import math
import sys
from pathlib import Path

import numpy as np
import trimesh
import yaml
from shapely.geometry import LineString, Point, Polygon

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
sys.path.insert(0, str(HERE))
P = yaml.safe_load((HERE / "params.yaml").read_text(encoding="utf-8"))
EPS, TOL_AREA = 1e-6, 0.05
problems = []


def ok(msg):
    print("  ok  " + msg)


def bad(msg):
    print("  !!  " + msg)
    problems.append(msg)


# the same readers as the builder (import without running the build)
src = (HERE / "build_3d.py").read_text(encoding="utf-8")
ns = {"__name__": "check", "__file__": str(HERE / "build_3d.py")}
exec(src[:src.index("# ---------- meshes ----------")] + "\n" + src[src.index("TO_GLTF = "):src.index("def add(mesh)")], ns)   # readers, OUTLINE, GF, FF, OPEN, voids, wall_pieces, TO_GLTF
GF, FF, OUTLINE, OPEN, PROJ_X = ns["GF"], ns["FF"], ns["OUTLINE"], ns["OPEN"], ns["PROJ_X"]
COURT_SKY, DH_VOID, SUITE_COURT = ns["COURT_SKY"], ns["DH_VOID"], ns["SUITE_COURT"]
summary = json.loads((ROOT / P["output"]["summary"]).read_text(encoding="utf-8"))
scene = trimesh.load(ROOT / P["output"]["glb"], force="scene")
# every mesh back from the glTF frame (X east, Y up, Z south) to the CSV frame (x east, y south, z up): the same axis swap
meshes = {}
for name in scene.graph.nodes_geometry:
    matrix, geom = scene.graph[name]
    m = scene.geometry[geom].copy()
    m.apply_transform(matrix)
    m.apply_transform(ns["TO_GLTF"])
    meshes[name] = m
area = lambda P: abs(sum(P[i][0] * P[(i + 1) % len(P)][1] - P[(i + 1) % len(P)][0] * P[i][1] for i in range(len(P)))) / 2
outline_poly = Polygon(OUTLINE)
T_OUT, T_IN, T_SLAB = P["walls"]["outer"], P["walls"]["inner"], P["slab_thickness"]
L = P["levels"]

# ---------- 1: every room enclosed ----------
print("1. Rooms enclosed")
for floor, rooms in (("GF", GF), ("FF", FF)):
    walls = [w for w in summary["walls"] if w["floor"] == floor and w["kind"] != "outer"]
    wall_lines = [LineString([w["a"], w["b"]]) for w in walls]
    open_lines = [LineString([o["a"], o["b"]]) for o in OPEN if o["floor"] == floor]
    pieces, _ = ns["wall_pieces"](rooms, OPEN, floor)
    missing = []
    for p in pieces:
        a, b = ns["point"](p["key"], p["t0"]), ns["point"](p["key"], p["t1"])
        seg = LineString([a, b])
        if p["outline"]:
            continue
        covered = any(seg.distance(wl) < EPS and wl.distance(Point(a)) < EPS and wl.distance(Point(b)) < EPS for wl in wall_lines) \
            or any(ol.distance(Point(a)) < EPS and ol.distance(Point(b)) < EPS and seg.distance(ol) < EPS for ol in open_lines)
        if not covered:
            missing.append(f"{p['rooms'][0]} {a}-{b}")
    if missing:
        bad(f"{floor}: room edges with neither wall nor open edge: {missing[:5]}")
    else:
        ok(f"{floor}: {len(rooms)} rooms, {len(pieces)} edge pieces, every one on the outline, a wall or a listed open edge")
    # open edges must lie on a room edge
    stray = [o["note"] for o in OPEN if o["floor"] == floor and not any(
        LineString([e[0], e[1]]).distance(Point(o["a"])) < EPS and LineString([e[0], e[1]]).distance(Point(o["b"])) < EPS
        for r in rooms for e in ns["edges"](r["pts"]))]
    if stray:
        bad(f"{floor}: open edges not on any room edge: {stray}")

# ---------- 2: walls ----------
print("2. Walls")
for floor in ("GF", "FF"):
    walls = [w for w in summary["walls"] if w["floor"] == floor and w["kind"] != "outer"]
    dup = []
    for i, w in enumerate(walls):
        for v in walls[i + 1:]:
            if ns["line_key"](w["a"], w["b"]) == ns["line_key"](v["a"], v["b"]):
                k = ns["line_key"](w["a"], w["b"])
                a0, a1 = sorted((ns["param"](w["a"], k), ns["param"](w["b"], k)))
                b0, b1 = sorted((ns["param"](v["a"], k), ns["param"](v["b"], k)))
                if min(a1, b1) - max(a0, b0) > EPS:
                    dup.append((w["name"], v["name"]))
    if dup:
        bad(f"{floor}: overlapping walls: {dup[:5]}")
    thick, height = [], []
    z0, z1 = (L["gf_floor"], L["ff_floor"] - T_SLAB) if floor == "GF" else (L["ff_floor"], L["roof"] - T_SLAB)
    for w in walls:
        m = meshes[w["name"]]
        ux, uy = np.array(w["b"]) - np.array(w["a"])
        n = np.array([-uy, ux]) / math.hypot(ux, uy)
        across = m.vertices[:, :2] @ n
        t = across.max() - across.min()
        if abs(t - w["t"]) > 1e-4 or abs(w["t"] - T_IN) > EPS:
            thick.append((w["name"], round(t, 4)))
        want = (z0, z0 + P["walls"]["low_partition"]) if w["kind"] == "low" else (z0, z1)
        if abs(m.bounds[0][2] - want[0]) > 1e-4 or abs(m.bounds[1][2] - want[1]) > 1e-4:
            height.append((w["name"], [round(m.bounds[0][2], 3), round(m.bounds[1][2], 3)]))
    if thick:
        bad(f"{floor}: wall thickness not {T_IN}: {thick[:5]}")
    if height:
        bad(f"{floor}: wall height not floor → slab underside ({z0}–{z1}) or the low partition: {height[:5]}")
    ring = meshes[f"{floor.lower()}_outer"]
    if abs(ring.bounds[0][2] - z0) > 1e-4 or abs(ring.bounds[1][2] - z1) > 1e-4:
        bad(f"{floor}: outer wall height {ring.bounds[:, 2].tolist()} != {z0}–{z1}")
    outer_t = (ring.bounds[1][0] - ring.bounds[0][0]) - (outline_poly.bounds[2] - outline_poly.bounds[0])
    if abs(outer_t - T_OUT) > 1e-4:
        bad(f"{floor}: outer wall thickness {outer_t:.4f} != {T_OUT}")
    if not (dup or thick or height):
        ok(f"{floor}: {len(walls)} interior walls, no overlaps, all {T_IN} m thick, floor → slab underside ({z0}–{z1}); outer ring {T_OUT} m")

# ---------- 3: areas ----------
print("3. Slab areas against the CSVs")
def mesh_area(name, t):
    m = meshes[name]
    return m.volume / t
gf_csv = sum(area(r["pts"]) for r in GF)            # 22 CSV rooms incl. the courtyard + the air tower
ff_csv = sum(area(r["pts"]) for r in FF)            # 21 CSV rooms incl. the suite court + the 4 fixed elements
gf_slab, ff_slab, roof = mesh_area("gf_slab", T_SLAB), mesh_area("ff_slab", T_SLAB), mesh_area("roof_slab", T_SLAB)
voids = COURT_SKY.area + DH_VOID.area
for label, got, want in (("GF slab = CSV rooms + courtyard + air tower", gf_slab, gf_csv),
                         ("FF slab = CSV rooms + suite court + stair, lift, shaft, air tower", ff_slab, ff_csv),
                         ("FF slab = outline − courtyard sky − double-height void", ff_slab, outline_poly.area - voids),
                         ("roof = outline − courtyard sky − suite court", roof, outline_poly.area - COURT_SKY.area - SUITE_COURT.area)):
    if abs(got - want) < TOL_AREA:
        ok(f"{label}: {got:.2f} m² = {want:.2f} m²")
    else:
        bad(f"{label}: {got:.2f} m² != {want:.2f} m²")
court = next(r for r in GF if r["name"] == "Courtyard")
dh = next(r for r in GF if r["name"].startswith("Living (double height)"))
want_voids = {"courtyard_sky": (max(p[0] for p in court["pts"]) - PROJ_X) * (max(p[1] for p in court["pts"]) - min(p[1] for p in court["pts"])),
              "double_height_living": (max(p[0] for p in dh["pts"]) - PROJ_X) * (max(p[1] for p in dh["pts"]) - min(p[1] for p in dh["pts"]))}
for k, v in want_voids.items():
    if abs(summary["voids"]["ff"][k] - v) < TOL_AREA:
        ok(f"void {k}: {v:.2f} m² (east of the projection edge x {PROJ_X})")
    else:
        bad(f"void {k}: built {summary['voids']['ff'][k]} != {v:.2f}")

# ---------- 4: outline and levels ----------
print("4. Outline and levels")
allv = np.vstack([m.vertices for m in meshes.values()])
lo, hi = allv.min(axis=0), allv.max(axis=0)
ob = outline_poly.bounds
if all(abs(v) < 1e-4 for v in (lo[0] - (ob[0] - T_OUT / 2), lo[1] - (ob[1] - T_OUT / 2), hi[0] - (ob[2] + T_OUT / 2), hi[1] - (ob[3] + T_OUT / 2))):
    ok(f"plan extent = outline + half the outer wall: {hi[0] - lo[0]:.3f} × {hi[1] - lo[1]:.3f} m")
else:
    bad(f"plan extent {lo[:2].round(3).tolist()}–{hi[:2].round(3).tolist()} does not match the outline {ob}")
if abs(lo[2] - (L["gf_floor"] - T_SLAB)) < 1e-4 and abs(hi[2] - L["roof"]) < 1e-4:
    ok(f"levels: ground slab underside {lo[2]:+.2f}, roof top {hi[2]:+.2f} (GF {L['gf_floor']:+.2f}, FF {L['ff_floor']:+.2f}, roof {L['roof']:+.2f})")
else:
    bad(f"levels {lo[2]:+.3f}…{hi[2]:+.3f} do not match params")
if abs(PROJ_X - (min(p[0] for p in court["pts"]) + P["projection"]["width"])) > EPS:
    bad("projection width in params != proj-x in studies/ff_family.typ")

print()
if problems:
    print(f"{len(problems)} 3D PROBLEM(S)")
    sys.exit(1)
print("3D CHECKS PASSED")

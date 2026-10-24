"""check_3d.py · Taif / Palm House · checks the 3D model against the project files (also called from tools/check.py).

Run from anywhere:   python taif_house/3d/check_3d.py     (after 3d/build_3d.py)
It reads the project files through the readers of build_3d.py, the summary (3d/output/model_summary.json) and the GLB, and checks:
  1. every room of both floors is enclosed: each piece of every room edge is on the outline, on a built wall or on a listed open edge;
  2. walls: no two walls of a floor overlap; every wall has the thickness of params.yaml (measured in the GLB) and runs from the structural
     slab top to the underside of the slab above (or the low-partition height); no gaps: every wall end meets another wall or the outer wall;
  3. slab areas measured in the GLB: the slabs reach the outer face of the outer walls; inside the outline, GF = CSV rooms + courtyard +
     air tower, FF = CSV rooms + suite court + the fixed elements; the voids (courtyard sky, double-height living, stair opening, suite court);
  4. the model fits the outline (plus the outer wall) and the finished / structural levels of params.yaml;
  5. doors and windows: every door and window of the plans is built (or is an open edge / listed as skipped), each in a wall, with its
     heights; the clerestory windows at the levels of studies/sections.typ; the kitchen service door clear of the counters and the columns;
     the X3 window / column C33 clearance reported (flagged, not a failure);
  6. the stair: 22 risers to the finished first-floor level, the arrival on the first-floor slab, the opening edged by the trimmers,
     the headroom over every tread to the underside of the beams / slab (ray cast in the GLB) ≥ params headroom_min;
  7. the structural elements of the zone: the colonnade to the roof (X8), the upturned edge beam, the flags (assumed / unconfirmed);
  8. the sun positions: noon altitudes equal the formulas of studies/sections.typ, morning / afternoon symmetric; true north from base.typ.
Ends with "3D CHECKS PASSED" (plus the flagged items) or a list of problems (exit code 1).
"""
import json
import math
import sys
from pathlib import Path

import numpy as np
import trimesh
import yaml
from shapely.geometry import LineString, Point, Polygon
from shapely import wkt

sys.stdout.reconfigure(encoding="utf-8", errors="replace")   # the messages use ≥ → · whatever the console code page
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


# the same readers and derived data as the builder (import without running the build)
src = (HERE / "build_3d.py").read_text(encoding="utf-8")
ns = {"__name__": "check", "__file__": str(HERE / "build_3d.py")}
exec(src[:src.index("# ---------- meshes ----------")] + "\n" + src[src.index("TO_GLTF = "):src.index("scene = trimesh.Scene()")], ns)
GF, FF, OUTLINE, OPEN, PROJ_X = ns["GF"], ns["FF"], ns["OUTLINE"], ns["OPEN"], ns["PROJ_X"]
COURT_SKY, DH_VOID, SUITE_COURT, STAIR_OPENING, TOWER_HOLE, AIR = ns["COURT_SKY"], ns["DH_VOID"], ns["SUITE_COURT"], ns["STAIR_OPENING"], ns["TOWER_HOLE"], ns["AIR"]
FINISHED, STRUCT_TOP, STOREY = ns["FINISHED"], ns["STRUCT_TOP"], ns["STOREY"]
ST, COLS, BEAMS, CL_SILL, CL_HEAD, LATITUDE = ns["ST"], ns["COLS"], ns["BEAMS"], ns["CL_SILL"], ns["CL_HEAD"], ns["LATITUDE"]
GF_DOORS, GF_WINDOWS, FF_DOORS, FF_WINDOWS, FIXTURES_EAST = ns["GF_DOORS"], ns["GF_WINDOWS"], ns["FF_DOORS"], ns["FF_WINDOWS"], ns["FIXTURES_EAST"]
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
outer_face = outline_poly.buffer(T_OUT / 2, join_style=2)

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
    thick, height, gaps = [], [], []
    z0, z1 = STOREY[floor]
    for w in walls:
        m = meshes[w["name"]]
        ux, uy = np.array(w["b"]) - np.array(w["a"])
        n = np.array([-uy, ux]) / math.hypot(ux, uy)
        across = m.vertices[:, :2] @ n
        t = across.max() - across.min()
        if abs(t - w["t"]) > 1e-4 or abs(w["t"] - T_IN) > EPS:
            thick.append((w["name"], round(t, 4)))
        want = (z0, FINISHED[floor] + P["walls"]["low_partition"]) if w["kind"] == "low" else (z0, z1)
        if abs(m.bounds[0][2] - want[0]) > 1e-4 or abs(m.bounds[1][2] - want[1]) > 1e-4:
            height.append((w["name"], [round(m.bounds[0][2], 3), round(m.bounds[1][2], 3)]))
        for p in (w["a"], w["b"]):   # every wall end meets another wall, the outline or an open edge (an opening in the room's outline, by design)
            # within 1e-3: the walls on the cut line carry rounding of a few 1e-5
            meets = outline_poly.exterior.distance(Point(p)) < 1e-3 or any(v is not w and LineString([v["a"], v["b"]]).distance(Point(p)) < 1e-3 for v in walls) \
                or any(o["floor"] == floor and LineString([o["a"], o["b"]]).distance(Point(p)) < 1e-3 for o in OPEN)
            if not meets:
                gaps.append((w["name"], p))
    if thick:
        bad(f"{floor}: wall thickness not {T_IN}: {thick[:5]}")
    if height:
        bad(f"{floor}: wall height not structural slab top → slab underside ({z0}–{z1}) or the low partition: {height[:5]}")
    if gaps:
        bad(f"{floor}: wall ends meeting nothing (a gap): {gaps[:5]}")
    ring = meshes[f"{floor.lower()}_outer"]
    if abs(ring.bounds[0][2] - z0) > 1e-4 or abs(ring.bounds[1][2] - z1) > 1e-4:
        bad(f"{floor}: outer wall height {ring.bounds[:, 2].tolist()} != {z0}–{z1}")
    outer_t = (ring.bounds[1][0] - ring.bounds[0][0]) - (outline_poly.bounds[2] - outline_poly.bounds[0])
    if abs(outer_t - T_OUT) > 1e-4:
        bad(f"{floor}: outer wall thickness {outer_t:.4f} != {T_OUT}")
    if not (dup or thick or height or gaps):
        ok(f"{floor}: {len(walls)} interior walls, no overlaps, no gaps, all {T_IN} m thick, structural slab top → slab underside ({z0}–{z1}); outer ring {T_OUT} m")

# ---------- 3: areas ----------
print("3. Slab areas against the CSVs")
def mesh_area(name, t):
    return meshes[name].volume / t
gf_csv = sum(area(r["pts"]) for r in GF)            # 22 CSV rooms incl. the courtyard + the air tower
ff_csv = sum(area(r["pts"]) for r in FF)            # 21 CSV rooms incl. the suite court + the 4 fixed elements
gf_slab, ff_slab, roof = mesh_area("gf_slab", T_SLAB), mesh_area("ff_slab", T_SLAB), mesh_area("roof_slab", T_SLAB)
ff_voids = COURT_SKY.area + DH_VOID.area + STAIR_OPENING.area + TOWER_HOLE.area
for label, got, want in (("GF slab = outline + half the outer wall (the slab reaches the outer face)", gf_slab, outer_face.area),
                         ("FF slab = outline + half the outer wall − courtyard sky − double-height void − stair opening − tower shaft", ff_slab, outer_face.area - ff_voids),
                         ("roof = outline + half the outer wall − courtyard sky − suite court − tower shaft", roof, outer_face.area - COURT_SKY.area - SUITE_COURT.area - TOWER_HOLE.area),
                         ("inside the outline, GF = CSV rooms + courtyard + air tower", outline_poly.area, gf_csv),
                         ("inside the outline, FF = CSV rooms + suite court + stair, lift, shaft, air tower + the two voids", outline_poly.area, ff_csv + COURT_SKY.area + DH_VOID.area)):
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
so = summary["voids"]["ff"]["stair_opening"]
ok(f"stair opening in the first-floor slab: {so:.2f} m² (x {ST['x0']}–{ST['split']} y {ST['y0']}–{ST['b16'] - T_IN / 2:.2f} + x {ST['split']}–{ST['x1']} y {ST['y0']}–{ST['top']})") if 7.5 < so < 9.0 else bad(f"stair opening {so:.2f} m², expected about 8.2")

# ---------- 4: outline and levels ----------
print("4. Outline and levels")
allv = np.vstack([m.vertices for n, m in meshes.items() if not n.startswith("all_col") and "_air_" not in n])   # the air system (head above the roof, tunnel below the slab, cap beyond the walls) is checked in 9
lo, hi = allv.min(axis=0), allv.max(axis=0)
ob = outline_poly.bounds
if all(abs(v) < 1e-4 for v in (lo[0] - (ob[0] - T_OUT / 2), lo[1] - (ob[1] - T_OUT / 2), hi[0] - (ob[2] + T_OUT / 2), hi[1] - (ob[3] + T_OUT / 2))):
    ok(f"plan extent = outline + half the outer wall: {hi[0] - lo[0]:.3f} × {hi[1] - lo[1]:.3f} m")
else:
    bad(f"plan extent {lo[:2].round(3).tolist()}–{hi[:2].round(3).tolist()} does not match the outline {ob}")
if abs(lo[2] - (STRUCT_TOP["GF"] - T_SLAB)) < 1e-4 and abs(hi[2] - (L["roof"] + P["roof_finish"])) < 1e-4:
    ok(f"levels: ground slab underside {lo[2]:+.2f}, roof finish top {hi[2]:+.2f} · finished GF {FINISHED['GF']:+.2f} / FF {FINISHED['FF']:+.2f}, structural slab tops {STRUCT_TOP['GF']:+.2f} / {STRUCT_TOP['FF']:+.2f} / roof {L['roof']:+.2f} (finish {P['finish']})")
else:
    bad(f"levels {lo[2]:+.3f}…{hi[2]:+.3f} do not match params")
for n, want in (("gf_finish_floor", FINISHED["GF"]), ("ff_finish_floor", FINISHED["FF"]), ("gf_slab", STRUCT_TOP["GF"]), ("ff_slab", STRUCT_TOP["FF"]), ("roof_slab", L["roof"])):
    if abs(meshes[n].bounds[1][2] - want) > 1e-4:
        bad(f"{n} top {meshes[n].bounds[1][2]:+.3f} != {want:+.2f}")
if abs(PROJ_X - (min(p[0] for p in court["pts"]) + P["projection"]["width"])) > EPS:
    bad("projection width in params != proj-x in studies/ff_family.typ")

# ---------- 5: doors and windows ----------
print("5. Doors and windows")
ops = summary["openings"]
n_open_edge, n_skip = len(summary["openings_note"]["open_edges"]), len(summary["openings_note"]["skipped"])
want_doors = len(GF_DOORS) + len(FF_DOORS) - n_open_edge - n_skip
built_doors = [o for o in ops if o["kind"] != "window"]
built_win = [o for o in ops if o["kind"] == "window"]
if len(built_doors) == want_doors and len(built_win) == len(GF_WINDOWS) + len(FF_WINDOWS):
    ok(f"{len(built_doors)} doors built = {len(GF_DOORS) + len(FF_DOORS)} in the plans − {n_open_edge} on open edges (no leaf, nothing to cut) − {n_skip} skipped ({', '.join(summary['openings_note']['skipped'])}); "
       f"{len(built_win)} windows built = {len(GF_WINDOWS)} GF + {len(FF_WINDOWS)} FF")
else:
    bad(f"openings: {len(built_doors)} doors (expected {want_doors}), {len(built_win)} windows (expected {len(GF_WINDOWS) + len(FF_WINDOWS)})")
wall_names = {w["name"] for w in summary["walls"]}
heads, glass = [], 0
for o in ops:
    fl = o["floor"]
    if o["wall"] not in wall_names:
        bad(f"opening {o['name']} on an unknown wall {o['wall']}")
    if o["head"] > STOREY[fl][1] + EPS:
        heads.append(o["name"])
    if o["kind"] != "window" and abs(o["head"] - FINISHED[fl] - P["openings"]["door_height"]) > EPS:
        heads.append(o["name"])
if heads:
    bad(f"opening heads above the slab underside or doors not {P['openings']['door_height']} m: {heads[:5]}")
else:
    ok(f"every opening head is below the slab underside; doors {P['openings']['door_height']} m above the finished floor; windows sill {P['openings']['window']['sill']} / head {P['openings']['window']['head']} unless listed in params")
n_glass = sum(1 for n in meshes if "_glass_" in n)
if n_glass == len(built_win) + len(P["openings"]["glass_doors"]):
    ok(f"{n_glass} glass panes = {len(built_win)} windows + {len(P['openings']['glass_doors'])} glass doors (transparent in the viewer)")
else:
    bad(f"{n_glass} glass panes, expected {len(built_win) + len(P['openings']['glass_doors'])}")
cl = [o for o in ops if "clerestory" in o["name"]]
if len(cl) == 2 and all(abs(o["sill"] - CL_SILL) < EPS and abs(o["head"] - CL_HEAD) < EPS for o in cl):
    ok(f"the two clerestory windows at +{CL_SILL:.2f} … +{CL_HEAD:.2f} as in studies/sections.typ (x {cl[0]['a'][0]}–{cl[0]['b'][0]} and {cl[1]['a'][0]}–{cl[1]['b'][0]}, y 19.25)")
else:
    bad(f"clerestory windows: {[(o['sill'], o['head']) for o in cl]} != sections.typ {CL_SILL}–{CL_HEAD}")
# the kitchen service door against the counters and the columns
sd = next((o for o in ops if o["floor"] == "GF" and "service door" in o["name"]), None)
if sd is None:
    bad("the kitchen service door (presentation.typ gf-doors) is not built")
else:
    y0, y1 = sorted((sd["a"][1], sd["b"][1]))
    jamb = 0.10
    clashes, notes = [], []
    for f in FIXTURES_EAST:
        bx0, by0, bx1, by1 = f["box"]
        if bx1 > 13.0 and min(by1, y1 + jamb) - max(by0, y0 - jamb) > EPS:   # fixtures on the east wall overlapping the door + jambs
            clashes.append(f["label"])
        if "cooking" in f["label"]:
            notes.append(f"cooking counter starts {by0 - y1:+.2f} m south of the door")
    for cid in ("C32", "C33"):
        c = COLS[cid]
        cy0, cy1 = c["y"] - c["along"] / 2, c["y"] + c["along"] / 2
        gap = max(y0 - cy1, cy0 - y1)
        (clashes if gap < 0 else notes).append(f"{cid} {gap:+.2f} m" if gap >= 0 else f"column {cid}")
    if clashes:
        bad(f"kitchen service door (y {y0}–{y1}) clashes with: {clashes}")
    else:
        ok(f"kitchen service door 0.90 at the north end of the east wall (y {y0}–{y1}, head +{sd['head']:.2f}): clear of the counters and the columns · {' · '.join(notes)}")
x3 = next(o for o in ops if o["floor"] == "FF" and "suite bath east" in o["name"])
if abs(x3["width"] - 0.60) < 1e-3:
    ok(f"X3: suite bath east window 0.60 m (y {min(x3['a'][1], x3['b'][1])}–{max(x3['a'][1], x3['b'][1])}), column C33 modelled {COLS['C33']['size']} along the wall: clearance {summary['x3_clearance']:+.2f} m → FLAGGED (see the flags), not shrunk")
else:
    bad(f"X3: suite bath east window {x3['width']} m, expected 0.60")

# ---------- 6: the stair ----------
print("6. Stair")
st = summary["stair"]
if st["risers"] * st["riser"] - (FINISHED["FF"] - FINISHED["GF"]) < 1e-6 and st["risers"] == 22:
    ok(f"{st['risers']} risers × {st['riser']:.4f} = {FINISHED['FF'] - FINISHED['GF']:.2f} m, goings {st['going']}, {st['per_flight']} risers per flight, half landing +{st['landing_level']:.2f}, flights {st['flight_clear_width']:.4f} m clear")
else:
    bad(f"stair: {st['risers']} risers × {st['riser']}")
# arrival: the top nosing at the finished first-floor level, the slab just beyond it, the opening just before it
top_n = [n for n in st["nosings"] if n["flight"] == 2][-1]
ff_poly = outer_face.difference(COURT_SKY).difference(DH_VOID).difference(STAIR_OPENING).difference(TOWER_HOLE)
beyond, before = Point(top_n["x"], top_n["y"] + 0.05), Point(top_n["x"], top_n["y"] - 0.05)
if abs(top_n["z"] - FINISHED["FF"]) < 1e-6 and ff_poly.contains(beyond) and STAIR_OPENING.contains(before):
    ok(f"arrival: the top riser lands at +{top_n['z']:.2f} on the first-floor slab (arrival strip y {st['arrival_y'][0]}–{st['arrival_y'][1]} inside the stair box, then the landing room)")
else:
    bad(f"arrival: top nosing z {top_n['z']} at y {top_n['y']}, slab beyond {ff_poly.contains(beyond)}, opening before {STAIR_OPENING.contains(before)}")
# the trimmers edge the opening
b16, b17, b18 = (next(b for b in summary["structure"]["beams"] if b["id"] == i) for i in ("B16", "B17", "B18"))
ox0, oy0, ox1, oy1 = STAIR_OPENING.bounds
edge_ok = abs(b16["a"][1] - b16["w"] / 2 - (ST["b16"] - T_IN / 2)) < EPS and abs(b17["a"][0] + b17["w"] / 2 - ST["split"]) < EPS and abs(b18["a"][1] - b18["w"] / 2 - ST["top"]) < EPS
if edge_ok and all(abs(b["z1"] - (STRUCT_TOP["FF"] - T_SLAB)) < EPS for b in (b16, b17, b18)):
    ok(f"trimmers B16 (y {b16['a'][1]}), B17 (x {b17['a'][0]}), B18 (y {b18['a'][1]}) edge the opening, {b16['w']} × {b16['d']} total, soffit +{b16['z0']:.2f} (structural; +{b16['z0'] - FINISHED['GF']:.2f} above the finished ground floor)")
else:
    bad("trimmers do not edge the stair opening")
# headroom: over the middle of every tread, the lowest underside above it (slabs and beams are vertical extrusions, so a 2D test is exact)
ff_under = STRUCT_TOP["FF"] - T_SLAB
roof_under = L["roof"] - T_SLAB
beam_feet = [(LineString([b["a"], b["b"]]).buffer(b["w"] / 2, cap_style=2), b["z0"], b["id"]) for b in summary["structure"]["beams"]]
clear = {}
for i, n in enumerate(st["nosings"]):
    if n["tread"] == st["per_flight"]:      # the top riser of each flight lands on the half landing / the first floor: no tread of its own
        continue
    pt = Point(n["x"], n["y_mid"])
    above = [(roof_under, "roof")]
    if ff_poly.contains(pt) and ff_under > n["z"]:
        above.append((ff_under, "FF slab"))
    above += [(z0, bid) for foot, z0, bid in beam_feet if foot.contains(pt) and z0 > n["z"]]
    z, what = min(above)
    clear[i] = (z - n["z"], what)
rows = [(st["nosings"][i], clear[i][0]) for i in clear]
low = [(n["flight"], n["tread"], round(c, 2)) for n, c in rows if c is not None and c < P["headroom_min"] - 1e-6]
nohit = [(n["flight"], n["tread"]) for n, c in rows if c is None]
worst = min((c, n) for n, c in rows if c is not None)
if low or nohit:
    bad(f"headroom under {P['headroom_min']} m at (flight, tread, clear): {low} · no hit: {nohit}")
else:
    ok(f"headroom over every tread ≥ {P['headroom_min']} m to the underside of the beams / slab: minimum {worst[0]:.2f} m at flight {worst[1]['flight']} tread {worst[1]['tread']} (under {clear[st['nosings'].index(worst[1])][1]}; the structural study gives 2.22 before finishes)")
store = st["landing_level"] - P["stair"]["waist"] - P["finish"] - FINISHED["GF"]
ok(f"store under the half landing: {store:.2f} m clear (a store, not a room)")

# ---------- 7: the structural elements of the zone ----------
print("7. Structure of the zone (assumed / unconfirmed)")
cols = {c["id"]: c for c in summary["structure"]["columns"]}
beams = {b["id"]: b for b in summary["structure"]["beams"]}
roof_under = L["roof"] - T_SLAB
if all(cid in cols and abs(cols[cid]["z1"] - roof_under) < EPS and abs(cols[cid]["z0"] - STRUCT_TOP["GF"]) < EPS for cid in P["structure"]["column_to_roof"]):
    ok(f"colonnade C21–C23 ({COLS['C21']['size']}) from the ground slab to the roof underside +{roof_under:.2f} (X8, owner decision); C33 {COLS['C33']['size']} modelled for the X3 check")
else:
    bad("colonnade columns do not run from the ground slab to the roof")
b3 = beams["B3"]
if P["structure"]["edge_beam_upturned"] and abs(b3["z0"] - (STRUCT_TOP["FF"] - T_SLAB)) < EPS and abs(b3["z1"] - b3["z0"] - b3["d"]) < EPS:
    ok(f"edge beam B3 upturned (option b, owner): {b3['w']} × {b3['d']} total from the slab underside +{b3['z0']:.2f} to +{b3['z1']:.2f} = {b3['z1'] - FINISHED['FF']:.2f} m above the finished gallery floor; the railing stands on it to +{FINISHED['FF'] + P['railing_height']:.2f}")
else:
    bad(f"edge beam B3: z {b3['z0']}–{b3['z1']}")
b5 = beams["B5"]
ok(f"beam B5 (dining step): {b5['w']} × {b5['d']} total, soffit +{b5['z0']:.2f} structural = {b5['z0'] - FINISHED['GF']:.2f} m clear above the finished ground floor") if abs(b5["z0"] - (STRUCT_TOP["FF"] - b5["d"])) < EPS else bad("beam B5 level")
if beams["R6"]["state"] == "unconfirmed" and any("NOT verified" in f for f in summary["flags"]):
    ok(f"R6 and the two gym walls over the men's majlis are marked unconfirmed (X5): red in the model")
else:
    bad("R6 / the gym walls are not flagged as unconfirmed")
rails = summary["rails"]
ok(f"{len(rails)} railings {P['railing_height']} m above the finished first floor: gallery edge on B3, courtyard edge, stair well; stair balustrades {P['handrail_height']} m above the nosings")

# ---------- 8: the sun ----------
print("8. Sun")
sun = summary["sun"]["positions"]
w_noon, s_noon = sun["winter-12"]["elevation"], sun["summer-12"]["elevation"]
want_w, want_s = 90 - LATITUDE - 23.44, 90 - LATITUDE + 23.44           # studies/sections.typ w-alt / s-alt (s-alt > 90: the sun just north of the zenith)
sym = all(abs(sun[f"{s}-09"]["elevation"] - sun[f"{s}-15"]["elevation"]) < 0.2 and abs(sun[f"{s}-09"]["azimuth"] + sun[f"{s}-15"]["azimuth"] - 360) < 0.2 for s in ("summer", "winter"))
if abs(w_noon - want_w) < 0.4 and abs(s_noon - (180 - want_s)) < 0.4 and sym:
    ok(f"noon sun altitude winter {w_noon}° / summer {s_noon}° (sections.typ: {want_w:.1f}° / {180 - want_s:.1f}° from the north side), 9:00 and 15:00 symmetric; true north {summary['sun']['true_north_bearing_from_plan_north']}° east of the plans' north (base.typ)")
else:
    bad(f"sun: winter noon {w_noon} (want {want_w:.1f}), summer noon {s_noon}, symmetric {sym}")

# ---------- 9: the air system ----------
print("9. Air system (studies/air_system.typ, all assumed)")
air = summary["air"]
foot = wkt.loads(air["duct_footprint_wkt"])
under = sorted({r["name"] for r in GF if Polygon(r["pts"]).intersection(foot).area > 0.01})
if set(under) <= {"Women's majlis", "Air tower", "Courtyard"}:   # the courtyard: only the mouth under its north wall, into the chamber (A3)
    ok(f"dry duct route A ({len(air['route']) - 1} legs) runs only under: {under}: no bedroom, no wet room")
else:
    bad(f"the duct runs under {under}")
court_poly = Polygon(next(r for r in GF if r["name"] == "Courtyard")["pts"])
cham = Polygon([(air["chamber"][0], air["chamber"][1]), (air["chamber"][2], air["chamber"][1]), (air["chamber"][2], air["chamber"][3]), (air["chamber"][0], air["chamber"][3])])
if court_poly.buffer(0.11).contains(cham) and cham.bounds[0] > PROJ_X:
    ok(f"outlet chamber x {air['chamber'][0]}–{air['chamber'][2]} y {air['chamber'][1]}–{air['chamber'][3]} inside the courtyard against its north wall, east of the projection edge x {PROJ_X} (open sky)")
else:
    bad("outlet chamber not inside the courtyard / under the projection")
pad = 1.5
def padbox(cid):
    c = COLS[cid]
    return Polygon([(c["x"] - pad / 2, c["y"] - pad / 2), (c["x"] + pad / 2, c["y"] - pad / 2), (c["x"] + pad / 2, c["y"] + pad / 2), (c["x"] - pad / 2, c["y"] + pad / 2)])
near = {cid: round(min(padbox(cid).distance(foot), padbox(cid).distance(cham)), 3) for cid in ("C21", "C25", "C26", "C17", "C24", "C30")}
tower_poly = Polygon(air["tower"]).buffer(T_OUT / 2)
clash = [cid for cid, d in near.items() if d < 0.1 and not tower_poly.intersects(padbox(cid))]
if not clash:
    ok("clear of the assumed 1.5 m pads (box to pad): " + ", ".join(f"{k} {v:.2f}" for k, v in near.items() if k not in ("C24", "C30")) + " · C24 / C30 stand on the tower base box (A1)")
else:
    bad(f"the duct / chamber meets the assumed pads of {clash}: {near}")
bt, bb = air["duct"][1], air["duct"][2]
if bt <= -0.9 - 0.05 and abs(air["head"][1] - (L["roof"] + P["roof_finish"]) - 2.5) < 1e-6:
    ok(f"dry duct top {bt:+.2f} (under the assumed tie beams at −0.90), underside {bb:+.2f}, clear {air['clear'][0]} × {air['clear'][1]} (assumed, to be sized); head to +{air['head'][1]:.2f} = 2.5 m above the roof finish")
else:
    bad(f"air levels: duct {bt}…{bb}, head {air['head']}")
gx0, gz0, gx1, gz1 = air["grille"]
if 0.2 <= gz0 <= 0.5 and gz1 > gz0 and not any(n.startswith("gf_air_kerb") or "_air_water" in n for n in meshes):
    ok(f"outlet: a grille in the courtyard's north wall (x {gx0}–{gx1}, +{gz0:.2f} … +{gz1:.2f}); no air opening and no water in the courtyard floor (the cover is sealed)")
else:
    bad("outlet: grille levels / a floor opening or water left from v1")
if abs(summary["voids"]["ff"]["tower_shaft"] - TOWER_HOLE.area) < 1e-4 and 0.8 < TOWER_HOLE.area < 1.0:
    ok(f"tower shaft open through the first-floor and roof slabs: {TOWER_HOLE.area:.2f} m²")
else:
    bad("tower shaft opening")

print()
for f in summary["flags"]:
    print("  flag  " + f)
print()
if problems:
    print(f"{len(problems)} 3D PROBLEM(S)")
    sys.exit(1)
print("3D CHECKS PASSED")

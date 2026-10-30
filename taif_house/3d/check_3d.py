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
  8. the sun positions: noon altitudes equal the formulas of studies/sections.typ, morning / afternoon symmetric; true north from base.typ;
  9. the air system (route, chamber, pads, levels, the wall grille);
 10. the character study (3d/character.yaml, STYLE STUDY): every chr_* mesh named and grouped, the base model untouched (the few replaced
     meshes exist), the outer-window glazing recessed by the reveal, every mashrabiya on a window of the plans and flush with the face,
     the stone sleeves round the colonnade, the parapet / glass railing on B3 to the railing height, the pergola leaving the sky open,
     the roof parapet, the arches variant (bays, headroom, where the intermediate columns stand), props in the courtyard, nothing
     beyond the outer face + the plinth / coping.
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
EPS, TOL_AREA, SNAP = 1e-6, 0.05, 0.02
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
    walls = [w for w in summary["walls"] if w["floor"] == floor and w["kind"] not in ("outer", "void")]
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
    walls = [w for w in summary["walls"] if w["floor"] == floor and w["kind"] not in ("outer", "void")]
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
    on_outline = [w["name"] for w in walls if outline_poly.exterior.distance(Point(w["a"])) < 0.003 and outline_poly.exterior.distance(Point(w["b"])) < 0.003
                  and outline_poly.exterior.distance(LineString([w["a"], w["b"]]).interpolate(0.5, normalized=True)) < 0.003]
    if on_outline:   # a room edge with rounded corners on the cut wall once built a 0.20 wall inside the 0.25 outer ring (and took the cut wall's windows)
        bad(f"{floor}: interior walls lying on the outline (duplicates of the outer wall): {on_outline}")
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
def level_area(level):   # V6.3: a slab is several meshes (its bays with their own thickness)
    return sum(meshes[s["name"]].volume / s["t"] for s in summary["slabs"] if s["level"] == level)
gf_slab, ff_slab, roof = level_area("gf"), level_area("ff"), level_area("roof")
ff_voids = COURT_SKY.area + DH_VOID.area + STAIR_OPENING.area + TOWER_HOLE.area
for label, got, want in (("GF slab = outline + half the outer wall (the slab reaches the outer face)", gf_slab, outer_face.area),
                         ("FF slab = outline + half the outer wall − courtyard sky − double-height void − stair opening − tower shaft", ff_slab, outer_face.area - ff_voids),
                         ("roof = outline + half the outer wall − courtyard sky − suite court − tower shaft − stair well (V7.0)", roof, outer_face.area - COURT_SKY.area - SUITE_COURT.area - TOWER_HOLE.area - STAIR_OPENING.area),
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
PROUD = ("roof_cornice", "ff_band", "roof_coping_n", "roof_coping_s")   # V7.0: the cornice, the band and the copings stand proud of the facade: checked in 11
allv = np.vstack([m.vertices for n, m in meshes.items() if not n.startswith("all_col") and "_air_" not in n and not n.startswith("chr_") and n not in PROUD])   # the air system (head above the roof, tunnel below the slab, cap beyond the walls) is checked in 9, the character study in 10
lo, hi = allv.min(axis=0), allv.max(axis=0)
ob = outline_poly.bounds
if all(abs(v) < 1e-4 for v in (lo[0] - (ob[0] - T_OUT / 2), lo[1] - (ob[1] - T_OUT / 2), hi[0] - (ob[2] + T_OUT / 2), hi[1] - (ob[3] + T_OUT / 2))):
    ok(f"plan extent = outline + half the outer wall: {hi[0] - lo[0]:.3f} × {hi[1] - lo[1]:.3f} m")
else:
    bad(f"plan extent {lo[:2].round(3).tolist()}–{hi[:2].round(3).tolist()} does not match the outline {ob}")
RD = P["roof_design"]
if abs(lo[2] - (STRUCT_TOP["GF"] - T_SLAB)) < 1e-4 and abs(hi[2] - RD["stair_room"]["edge"]) < 1e-4:
    ok(f"levels: ground slab underside {lo[2]:+.2f}, the stair room's edge {hi[2]:+.2f} (the highest base mesh, V7.0) · finished GF {FINISHED['GF']:+.2f} / FF {FINISHED['FF']:+.2f}, structural slab tops {STRUCT_TOP['GF']:+.2f} / {STRUCT_TOP['FF']:+.2f} / roof {L['roof']:+.2f} (finish {P['finish']})")
else:
    bad(f"levels {lo[2]:+.3f}…{hi[2]:+.3f} do not match params")
for n, want in (("gf_finish_floor", FINISHED["GF"]), ("ff_finish_floor", FINISHED["FF"]), ("gf_slab", STRUCT_TOP["GF"]), ("ff_slab", STRUCT_TOP["FF"]), ("roof_slab", L["roof"])):
    if abs(meshes[n].bounds[1][2] - want) > 1e-4:
        bad(f"{n} top {meshes[n].bounds[1][2]:+.3f} != {want:+.2f}")
# V6.3: the slab bays of studies/structure.typ: every bay mesh has its study thickness and the structural top of its level
bays = [s for s in summary["slabs"] if "_bay" in s["name"]]
want_t = {("ff", t): [] for t in ()}
bad_bays = [s["name"] for s in bays if abs(meshes[s["name"]].bounds[1][2] - (STRUCT_TOP["FF"] if s["level"] == "ff" else L["roof"])) > 1e-4 or abs((meshes[s["name"]].bounds[1][2] - meshes[s["name"]].bounds[0][2]) - s["t"]) > 1e-4]
if bad_bays:
    bad(f"slab bays not at the structural top or not their study thickness: {bad_bays}")
else:
    ff_t = sorted({s["t"] for s in summary["slabs"] if s["level"] == "ff"}); roof_t = sorted({s["t"] for s in summary["slabs"] if s["level"] == "roof"})
    ok(f"slab bays from studies/structure.typ (assumed): FF {len([s for s in bays if s['level'] == 'ff'])} bays thicker than {T_SLAB} ({', '.join(f'{t:.2f}' for t in ff_t)} m), roof {len([s for s in bays if s['level'] == 'roof'])} bays ({', '.join(f'{t:.2f}' for t in roof_t)} m); "
       f"clear heights before finishes: under the 0.20 slabs +{STRUCT_TOP['FF'] - T_SLAB:.2f}, under the 0.30 bays +{STRUCT_TOP['FF'] - 0.30:.2f} (kitchen, dining, men's majlis); roof underside +{L['roof'] - 0.22:.2f} over the void (0.22 flat), +{L['roof'] - 0.30:.2f} under the suite / office bays")
if abs(PROJ_X - (min(p[0] for p in court["pts"]) + P["projection"]["width"])) > EPS:
    bad("projection width in params != proj-x in studies/ff_family.typ")

# ---------- 5: doors and windows ----------
print("5. Doors and windows")
ops = summary["openings"]
n_open_edge, n_skip = len(summary["openings_note"]["open_edges"]), len(summary["openings_note"]["skipped"])
want_doors = len(GF_DOORS) + len(FF_DOORS) - n_open_edge - n_skip
built_doors = [o for o in ops if o["kind"] != "window"]
built_win = [o for o in ops if o["kind"] == "window"]
if len(built_doors) == want_doors and len(built_win) == len(GF_WINDOWS) + len(FF_WINDOWS) + 1:   # + W3 (V7.0)
    ok(f"{len(built_doors)} doors built = {len(GF_DOORS) + len(FF_DOORS)} in the plans − {n_open_edge} on open edges (no leaf, nothing to cut) − {n_skip} skipped ({', '.join(summary['openings_note']['skipped'])}); "
       f"{len(built_win)} windows built = {len(GF_WINDOWS)} GF + {len(FF_WINDOWS)} FF + W3 (the void wall, V7.0)")
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
    special = [d["head"] for d in P["openings"].get("doors", []) if d["floor"] == fl and all(abs(float(x) - y) < 1e-6 for x, y in zip(d["at"].split(), (*o["a"], *o["b"])))]   # V6.3: the living's entrance arch
    if o["kind"] != "window" and abs(o["head"] - FINISHED[fl] - (special[0] if special else P["openings"]["door_height"])) > EPS:
        heads.append(o["name"])
if heads:
    bad(f"opening heads above the slab underside or doors not {P['openings']['door_height']} m: {heads[:5]}")
else:
    ok(f"every opening head is below the slab underside; doors {P['openings']['door_height']} m above the finished floor ({len(P['openings'].get('doors', []))} special: the living's entrance arch +{P['openings']['doors'][0]['head']:.2f}); windows sill {P['openings']['window']['sill']} / head {P['openings']['window']['head']} unless listed in params")
n_glass = sum(1 for n in meshes if "_glass_" in n and not n.startswith("chr_"))   # the character study's recessed panes are checked in 10
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
if abs(x3["width"] - 0.55) < 1e-3 and summary["x3_clearance"] >= 0.10 - 1e-6:
    ok(f"X3 (V6.3): suite bath east window 0.55 m (y {min(x3['a'][1], x3['b'][1])}–{max(x3['a'][1], x3['b'][1])}), column C33 modelled {COLS['C33']['size']} along the wall (y {COLS['C33']['y'] - 0.3:.2f}–{COLS['C33']['y'] + 0.3:.2f}): opening clearance {summary['x3_clearance']:+.2f} m = 0.05 m beyond a 0.05 frame")
else:
    bad(f"X3: suite bath east window {x3['width']} m (expected 0.55) or clearance {summary['x3_clearance']} < 0.10")

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
def slab_under(level, pt):   # V6.3: the slab underside over a point, from the bays
    hits = [s["z0"] for s in summary["slabs"] if s["level"] == level and meshes[s["name"]].bounds[0][0] - 1e-6 <= pt.x <= meshes[s["name"]].bounds[1][0] + 1e-6 and meshes[s["name"]].bounds[0][1] - 1e-6 <= pt.y <= meshes[s["name"]].bounds[1][1] + 1e-6]
    return min(hits) if hits else (STRUCT_TOP["FF"] - T_SLAB if level == "ff" else L["roof"] - T_SLAB)
ff_under = STRUCT_TOP["FF"] - T_SLAB
roof_under = L["roof"] - T_SLAB
beam_feet = [(LineString([b["a"], b["b"]]).buffer(b["w"] / 2, cap_style=2), b["z0"], b["id"]) for b in summary["structure"]["beams"]]
clear = {}
for i, n in enumerate(st["nosings"]):
    if n["tread"] == st["per_flight"]:      # the top riser of each flight lands on the half landing / the first floor: no tread of its own
        continue
    pt = Point(n["x"], n["y_mid"])
    above = [(slab_under("roof", pt), "roof")]
    if ff_poly.contains(pt) and slab_under("ff", pt) > n["z"]:
        above.append((slab_under("ff", pt), "FF slab"))
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
# V7.0: the upper flights to the roof: the arrival on the roof slab, R16–R18 edging the roof opening, the headroom under the roof slab / trimmers / flight 4
su = summary["stair_upper"]
top4 = [n for n in su["nosings"] if n["flight"] == 4][-1]
roof_poly = outer_face.difference(COURT_SKY).difference(SUITE_COURT).difference(STAIR_OPENING).difference(TOWER_HOLE)
if abs(top4["z"] - (FINISHED["FF"] + FINISHED["FF"] - FINISHED["GF"])) < 1e-6 and roof_poly.contains(Point(top4["x"], top4["y"] + 0.05)) and STAIR_OPENING.contains(Point(top4["x"], top4["y"] - 0.05)) and abs(summary["voids"]["roof"]["stair_opening"] - STAIR_OPENING.area) < 1e-3:
    ok(f"stair to the roof (V7.0): flights 3 / 4 repeat 1 / 2 one storey up, upper half landing +{su['landing_level']:.2f}, the top riser lands at +{top4['z']:.2f} on the roof slab; the roof opening = the first-floor one ({STAIR_OPENING.area:.2f} m²)")
else:
    bad(f"upper stair: top nosing {top4}, roof opening {summary['voids']['roof']}")
r16, r17, r18 = (next(b for b in summary["structure"]["beams"] if b["id"] == i) for i in ("R16", "R17", "R18"))
if abs(r16["a"][1] - r16["w"] / 2 - (ST["b16"] - T_IN / 2)) < EPS and abs(r17["a"][0] + r17["w"] / 2 - ST["split"]) < EPS and abs(r18["a"][1] - r18["w"] / 2 - ST["top"]) < EPS and all(abs(b["z1"] - (L["roof"] - T_SLAB)) < EPS for b in (r16, r17, r18)):
    ok(f"roof trimmers R16 / R17 / R18 edge the roof opening as B16–B18, soffit +{r16['z0']:.2f}")
else:
    bad("roof trimmers do not edge the roof opening")
flight4 = meshes["ff_stair_flight4"]
clear_u = {}
for i, n in enumerate(su["nosings"]):
    if n["tread"] == st["per_flight"]:
        continue
    pt = Point(n["x"], n["y_mid"])
    above = [(slab_under("roof", pt), "roof slab")] if roof_poly.contains(pt) else [(RD["stair_room"]["soffit"], "stair room roof")]
    above += [(z0, bid) for foot, z0, bid in beam_feet if foot.contains(pt) and z0 > n["z"]]
    if n["flight"] == 3:   # flight 4 crosses above flight 3 only beside it (the central balustrade): nothing of it over flight 3's treads
        pass
    z, what = min(above)
    clear_u[i] = (z - n["z"], what)
low_u = [(n["flight"], n["tread"], round(c, 2)) for i, n in enumerate(su["nosings"]) if i in clear_u and clear_u[i][0] < P["headroom_min"] - 1e-6]
worst_u = min((c, su["nosings"][i]) for i, (c, w) in clear_u.items())
if low_u:
    bad(f"upper stair headroom under {P['headroom_min']} m at (flight, tread, clear): {low_u}")
else:
    ok(f"headroom over every tread of flights 3 / 4 ≥ {P['headroom_min']} m: minimum {worst_u[0]:.2f} m at flight {worst_u[1]['flight']} tread {worst_u[1]['tread']} (under {clear_u[su['nosings'].index(worst_u[1])][1]}); the stair room {summary['stair_room']['clear']:.2f} m clear over the roof arrival")

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
ok(f"{len(rails)} railings {P['railing_height']} m above the finished first floor on the stair well (the gallery and family living edges are the steel windows W1 / W2 since V7.0); stair balustrades {P['handrail_height']} m above the nosings on both storeys")

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
under = sorted({r["name"] for r in GF if Polygon(r["pts"]).buffer(-T_IN / 2, join_style=2).intersection(foot).area > 0.01})   # the rooms between their wall faces
if set(under) <= {"Maid bath", "Laundry", "Kitchen", "Air tower"}:   # route E (owner, 3d-char2): south under the maid wing to the chamber under the kitchen floor; no bedroom
    ok(f"dry duct route E ({len(air['route']) - 1} leg(s), x {air['route'][0][0]}) runs only under: {under}: no bedroom (it passes under the laundry's east partition line x 10.65 by 0.05, a light partition); the maid bath and laundry drains cross above it (A6)")
else:
    bad(f"the duct runs under {under}")
kitchen_poly = Polygon(next(r for r in GF if r["name"] == "Kitchen")["pts"])
cham = Polygon([(air["chamber"][0], air["chamber"][1]), (air["chamber"][2], air["chamber"][1]), (air["chamber"][2], air["chamber"][3]), (air["chamber"][0], air["chamber"][3])])
if kitchen_poly.buffer(0.01).contains(cham) and abs(cham.bounds[0] - (air["grille_x"] + T_IN / 2)) < 1e-6:
    ok(f"outlet chamber x {air['chamber'][0]}–{air['chamber'][2]} y {air['chamber'][1]}–{air['chamber'][3]} under the kitchen floor against the kitchen's west wall (x {air['grille_x']}); the sealed cover in the kitchen floor")
else:
    bad("outlet chamber not under the kitchen floor against its west wall")
pad = 1.5
def padbox(cid):
    c = COLS[cid]
    return Polygon([(c["x"] - pad / 2, c["y"] - pad / 2), (c["x"] + pad / 2, c["y"] - pad / 2), (c["x"] + pad / 2, c["y"] + pad / 2), (c["x"] - pad / 2, c["y"] + pad / 2)])
near = {cid: round(min(padbox(cid).distance(foot), padbox(cid).distance(cham)), 3) for cid in ("C25", "C26", "C31", "C27", "C24", "C30")}
tower_poly = Polygon(air["tower"]).buffer(T_OUT / 2)
clash = [cid for cid, d in near.items() if d < 0.1 - 1e-6 and not tower_poly.intersects(padbox(cid))]
if not clash:
    ok("clear of the assumed 1.5 m pads (box to pad): " + ", ".join(f"{k} {v:.2f}" for k, v in near.items() if k not in ("C24", "C30")) + " · C24 / C30 stand on the tower base box (A1)")
else:
    bad(f"the duct / chamber meets the assumed pads of {clash}: {near}")
bt, bb = air["duct"][1], air["duct"][2]
if bt <= -0.9 - 0.05 and abs(air["head"][1] - (L["roof"] + P["roof_finish"]) - 2.5) < 1e-6:
    ok(f"dry duct top {bt:+.2f} (under the assumed tie beams at −0.90), underside {bb:+.2f}, clear {air['clear'][0]} × {air['clear'][1]} (assumed, to be sized); head to +{air['head'][1]:.2f} = 2.5 m above the roof finish")
else:
    bad(f"air levels: duct {bt}…{bb}, head {air['head']}")
gy0, gz0, gy1, gz1 = air["grille"]
gm = meshes.get("gf_air_grille")
sink = next((o for o in ops if o["floor"] == "GF" and "kitchen sink" in o["name"]), None)
grille_ok = gm is not None and abs(gm.bounds[0][0] - (air["grille_x"] - T_IN / 2 - 0.015)) < 1e-3 and gm.bounds[0][1] > air["chamber"][1] - 0.5 and gm.bounds[1][1] < air["chamber"][3] + 0.5
clear_of_sink = sink is None or gy1 <= min(sink["a"][1], sink["b"][1]) - 0.3
if grille_ok and 0.1 <= gz0 <= 0.5 and gz1 > gz0 and clear_of_sink and "gf_air_plenum" in meshes and not any(n.startswith("gf_air_kerb") or "_air_water" in n for n in meshes):
    ok(f"outlet: a grille on the courtyard face of the kitchen's west wall (x {air['grille_x']}, y {gy0}–{gy1}, +{gz0:.2f} … +{gz1:.2f}) over the chamber, with the plenum in the wall base, "
       f"{min(sink['a'][1], sink['b'][1]) - gy1:.2f} m north of the kitchen sink window; no air opening and no water in the courtyard floor (the cover is sealed, in the kitchen)")
else:
    bad(f"outlet: grille on the wrong wall / levels / not clear of the sink window / a floor opening or water left from v1 (grille ok {grille_ok}, sink clear {clear_of_sink})")
if abs(summary["voids"]["ff"]["tower_shaft"] - TOWER_HOLE.area) < 1e-4 and 0.8 < TOWER_HOLE.area < 1.0:
    ok(f"tower shaft open through the first-floor and roof slabs: {TOWER_HOLE.area:.2f} m²")
else:
    bad("tower shaft opening")

# ---------- 10: the character study (3d/character.yaml) · STYLE STUDY, PROVISIONAL ----------
print("10. Character study (3d/character.yaml, style study, provisional)")
C = yaml.safe_load((HERE / "character.yaml").read_text(encoding="utf-8"))
ch = summary.get("character", {})
chr_meshes = {n: m for n, m in meshes.items() if n.startswith("chr_")}
if not C.get("enabled", True) or not ch.get("enabled"):
    ok("character study disabled in character.yaml: no chr_* meshes") if not chr_meshes else bad(f"character disabled but {len(chr_meshes)} chr_* meshes in the GLB")
else:
    GROUPS = {"base", "pergola", "sunken", "props", "light"}
    badnames = [n for n in chr_meshes if len(n.split("_")) < 4 or n.split("_")[1] not in GROUPS or n.split("_")[2] not in C["palette"]]
    listed = {m["name"] for m in ch["meshes"]}
    if badnames or listed != set(chr_meshes):
        bad(f"character meshes not named chr_<group>_<material>_<label> or not in the summary: {badnames[:5]} · {sorted(listed ^ set(chr_meshes))[:5]}")
    else:
        groups = {g: sum(1 for n in chr_meshes if n.split('_')[1] == g) for g in GROUPS}
        ok(f"{len(chr_meshes)} character meshes, every one chr_<group>_<material>_<label> with a material of the palette: " + ", ".join(f"{g} {k}" for g, k in sorted(groups.items())))
    # the base model is untouched: the meshes the viewer hides when the character is on exist, and are exactly the outer windows' glass + the B3 railing
    want_hide = {f"{o['floor'].lower()}_glass_{i:03d}" for i, o in enumerate(ops) if o["kind"] == "window" and o["wall"].endswith("_outer")}
    if set(ch["hide"]) == want_hide and all(n in meshes for n in ch["hide"]):
        ok(f"the viewer replaces only {len(ch['hide'])} base meshes when the character is on: the outer windows' centre-line glass (recessed instead); every other mesh is only re-coloured")
    else:
        bad(f"hidden base meshes {sorted(ch['hide'])} != {sorted(want_hide)}")
    # the recessed glazing: the outer face of every recessed pane lies reveal − glass/2 inside the outer wall face
    pane = chr_meshes.get("chr_base_glass_recessed_glazing")
    reveal, tg = C["reveal"], P["openings"]["glass"]
    wrong = []
    for r in ch["recessed_windows"]:
        a, b, n = np.array(r["a"]), np.array(r["b"]), np.array(r["normal"])
        u = (b - a) / np.linalg.norm(b - a)
        o = ops[r["index"]]
        v = pane.vertices
        s = (v[:, :2] - a) @ u
        sel = (s > -1e-3) & (s < np.linalg.norm(b - a) + 1e-3) & (v[:, 2] > o["sill"] - 1e-3) & (v[:, 2] < o["head"] + 1e-3) & (np.abs((v[:, :2] - a) @ n - r["offset"]) < tg)
        if not sel.any():
            wrong.append((r["name"], "no pane"))
            continue
        depth = T_OUT / 2 - ((v[sel, :2] - a) @ n).max()          # outer wall face → the pane's outer face
        if abs(depth - (reveal - tg / 2)) > 1e-3:
            wrong.append((r["name"], round(depth, 3)))
    if pane is None or wrong:
        bad(f"recessed glazing: {wrong[:5]}")
    else:
        ok(f"{len(ch['recessed_windows'])} outer-wall windows: glass set back {reveal} m from the outer wall face (deep reveals), black steel frames on all {ch['frames']} windows with {ch.get('lites', 0)} divided-lite bars (V7.0)")
    # mashrabiya: on windows of the plans, inside the opening, flush with the face it sits on
    bad_ms = []
    for m in ch["mashrabiya"]:
        at = [float(v) for v in m["at"].split()]
        o = next((o for o in ops if o["kind"] == "window" and o["floor"] == m["floor"] and all(abs(x - y) < 0.01 for x, y in zip((*o["a"], *o["b"]), at))), None)
        mesh = chr_meshes.get(m["name"])
        if o is None or mesh is None:
            bad_ms.append((m["at"], "not a window of the plans" if o is None else "no mesh"))
            continue
        a, b = np.array(o["a"]), np.array(o["b"])
        u = (b - a) / np.linalg.norm(b - a)
        n = np.array([u[1], -u[0]])
        v = mesh.vertices
        s, d = (v[:, :2] - a) @ u, np.abs((v[:, :2] - a) @ n)
        inside = s.min() > -1e-3 and s.max() < np.linalg.norm(b - a) + 1e-3 and v[:, 2].min() > o["sill"] - 1e-3 and v[:, 2].max() < o["head"] + 1e-3
        if not inside or abs(d.max() - m["face_offset"]) > 1e-3 or abs(d.max() - d.min() - C["mashrabiya"]["depth"]) > 1e-3:
            bad_ms.append((m["at"], "outside its opening" if not inside else f"face {d.max():.3f} / depth {d.max() - d.min():.3f}"))
    if bad_ms:
        bad(f"mashrabiya: {bad_ms[:5]}")
    else:
        ok(f"{len(ch['mashrabiya'])} mashrabiya screens, each on a window of the plans, inside its opening and flush with the wall face (depth {C['mashrabiya']['depth']}): "
           + "; ".join(f"{m['floor']} {m['window'] if m['window'] != 'default window' else m['at']}" for m in ch["mashrabiya"]))
    # the colonnade's stone sleeves
    bad_sl = []
    for s in ch["sleeves"]:
        m = chr_meshes.get(f"chr_base_stone_column_{s['column']}")
        if m is None or abs(m.bounds[0][2] - FINISHED["GF"]) > 1e-3 or abs(m.bounds[1][2] - (L["roof"] - T_SLAB)) > 1e-3 \
                or abs((m.bounds[1][0] - m.bounds[0][0]) - C["colonnade"]["base"]["diameter"]) > 0.02:
            bad_sl.append(s["column"])
    if bad_sl or len(ch["sleeves"]) != len(P["structure"]["column_to_roof"]):
        bad(f"colonnade sleeves: {bad_sl}")
    else:
        ok(f"stone sleeves Ø{C['colonnade']['diameter']} with base and capital bands on {', '.join(s['column'] for s in ch['sleeves'])} ({ch['sleeves'][0]['structural']} assumed inside), finished ground floor → roof underside")
    # the pergola
    pg = ch["pergola"]
    pm = chr_meshes.get("chr_pergola_timber_beams")
    cy0, cy1 = COURT_SKY.bounds[1], COURT_SKY.bounds[3]
    if pm is not None and pg["over_y"][0] >= cy0 - EPS and pg["over_y"][1] <= cy1 + EPS and abs(pm.bounds[0][2] - (L["roof"] + P["roof_finish"])) < 1e-3 and pg["sky_covered_share"] <= 0.15:
        ok(f"pergola: {pg['beams']} timber beams {pg['section'][0]} × {pg['section'][1]} at {pg['spacing']} m over y {pg['over_y'][0]}–{pg['over_y'][1]} of the courtyard sky (y {cy0}–{cy1}), on the roof finish; "
           f"covers {pg['sky_covered_share'] * 100:.0f} % of the sky hole (toggle; default {'on' if pg['default'] else 'off'})")
    else:
        bad(f"pergola: {pg}")
    # the roof guards and the character meshes' plan extent
    rg = chr_meshes.get("chr_base_steel_roof_railings")
    if rg is not None and abs(rg.bounds[1][2] - (L["roof"] + P["roof_finish"] + RD["guard"]["height"])) < 1e-3:
        ok(f"black steel bar guards {RD['guard']['height']} m round the courtyard sky hole and the suite court's open edges (clear of the attic wall; the gym roof edge stays a railing)")
    else:
        bad("roof guards")
    proud = max(C["plinth"]["thickness"], C["feature_walls"]["thickness"], C["quoins"]["thickness"]) + 1e-3
    chrv = np.vstack([m.vertices for m in chr_meshes.values()])
    ob = outline_poly.bounds
    if chrv[:, 0].min() > ob[0] - T_OUT / 2 - proud and chrv[:, 1].min() > ob[1] - T_OUT / 2 - proud and chrv[:, 0].max() < ob[2] + T_OUT / 2 + proud and chrv[:, 1].max() < ob[3] + T_OUT / 2 + proud:
        ok(f"every character mesh lies within the outer wall face + {proud - 1e-3:.2f} m (plinth, cladding, coping); props and lanterns in the courtyard / under the soffit")
    else:
        bad(f"character meshes beyond the outer face: x {chrv[:, 0].min():.3f}–{chrv[:, 0].max():.3f}, y {chrv[:, 1].min():.3f}–{chrv[:, 1].max():.3f}")
    # the sunken seating variant: replaces the base model's courtyard floor; depth, steps, level edges at every door and glass wall, the grille over the bench, the drain
    sk = ch["sunken"]
    court_floor = Polygon(court["pts"]).buffer(-T_IN / 2, join_style=2)
    px0, py0, px1, py1 = sk["box"]
    pit = Polygon([(px0, py0), (px1, py0), (px1, py1), (px0, py1)])
    pf, st_m, cf = chr_meshes.get("chr_sunken_stone_light_pit_floor"), chr_meshes.get("chr_sunken_stone_light_steps"), chr_meshes.get("chr_sunken_stone_light_court_floor")
    base_ok = all(n in meshes for n in sk["replaces"]) and abs(mesh_area("gf_slab_court", T_SLAB) - court_floor.area) < TOL_AREA
    floor_ok = pf is not None and abs(pf.bounds[1][2] - (FINISHED["GF"] + sk["floor"])) < 1e-3 and cf is not None and abs(cf.bounds[1][2] - FINISHED["GF"]) < 1e-3 and abs(cf.volume - (court_floor.area - pit.area) * (T_SLAB + P["finish"])) < TOL_AREA
    tread_tops = sorted({round(float(z), 3) for z in st_m.vertices[:, 2]}) if st_m is not None else []
    steps_ok = st_m is not None and all(abs(FINISHED["GF"] - sk["riser"] * k - t) < 1e-3 for k, t in zip(range(sk["risers"] - 1, 0, -1), [t for t in tread_tops if t > FINISHED["GF"] + sk["floor"] + 1e-3])) \
        and abs(sk["risers"] * sk["riser"] + sk["floor"]) < 1e-6
    # every courtyard door / full-height glass (sill at the floor) keeps a level edge ≥ walking_edge_min in front of it
    court_edge = Polygon(court["pts"]).exterior
    low = [o for o in ops if o["floor"] == "GF" and o["sill"] <= FINISHED["GF"] + 1e-6 and court_edge.distance(Point(o["a"])) < SNAP and court_edge.distance(Point(o["b"])) < SNAP]
    too_close = [(o["name"], round(LineString([o["a"], o["b"]]).distance(pit), 2)) for o in low if LineString([o["a"], o["b"]]).distance(pit) < sk["walking_edge_min"] + T_IN / 2 - 1e-6]
    edges_ok = court_floor.contains(pit) and min(sk["level_edges"]["north"], sk["level_edges"]["south"], sk["level_edges"]["west"]) >= sk["walking_edge_min"] - 1e-6 and abs(sk["level_edges"]["east"]) < 1e-6
    g_ = sk["grille"]
    grille_ok = g_["above_floor"] >= 0.15 and g_["above_seat"] >= 0.15 and sk["bench"]["y"][0] <= g_["y"][0] and g_["y"][1] <= sk["bench"]["y"][1] and "chr_sunken_stone_grille_upstand" in chr_meshes
    dm = chr_meshes.get("chr_sunken_bronze_drain")
    drain_ok = dm is not None and pit.contains(Point(sk["drain"])) and abs(dm.bounds[0][2] - (FINISHED["GF"] + sk["floor"] - 0.01)) < 1e-3 and "chr_sunken_bronze_overflow" in chr_meshes and sk["overflow_level"] > sk["floor"]
    if base_ok and floor_ok and steps_ok and not too_close and edges_ok and grille_ok and drain_ok:
        ok(f"sunken seating (variant, default {'on' if sk['default'] else 'off'}): the courtyard floor replaced ({', '.join(sk['replaces'])}) by a pit {-sk['floor']:.2f} deep against the east wall, x {px0}–{px1} y {py0}–{py1}, "
           f"{sk['risers']} risers × {sk['riser']} from the west; level edges north {sk['level_edges']['north']:.2f} / south {sk['level_edges']['south']:.2f} / west {sk['level_edges']['west']:.2f} m (≥ {sk['walking_edge_min']}): "
           f"no step at any door or glass wall ({len(low)} floor-level openings on the courtyard checked); the grille y {g_['y'][0]}–{g_['y'][1]} over the bench (y {sk['bench']['y'][0]}–{sk['bench']['y'][1]}), "
           f"{g_['above_seat']:.2f} above the seat and {g_['above_floor']:.2f} above the sunken floor, with an upstand; a drain at the lowest point ({sk['drain'][0]}, {sk['drain'][1]}) and an overflow at {sk['overflow_level']:+.2f} (MEP, A6)")
    else:
        bad(f"sunken seating: base {base_ok}, floor {floor_ok}, steps {steps_ok} {tread_tops}, too close to a door {too_close}, edges {edges_ok} {sk['level_edges']}, grille {grille_ok}, drain {drain_ok}")
    # the fountain on the east wall between the grille and the sink window
    fo = ch["fountain"]
    if fo["clear_of_grille"] >= 0.3 and (fo["below_sink_sill"] is None or fo["below_sink_sill"] >= 0) and "chr_base_stone_fountain_panel" in chr_meshes:
        ok(f"wall fountain (shape only) on the courtyard's east wall y {fo['along'][0]}–{fo['along'][1]}: {fo['clear_of_grille']:.2f} m south of the malqaf grille, under the kitchen sink window with its top {fo['below_sink_sill']:.2f} m below the sill; the women's majlis glass untouched")
    else:
        bad(f"fountain: {fo}")
    # V6.3: the TV wall: the living's solid west wall with the arched entrance and the arched TV niche (owner decision)
    tv = ch["tv_wall"]
    entrance = next((o for o in ops if o["floor"] == "GF" and o["name"].startswith("living entrance")), None)
    niche = chr_meshes.get("chr_base_plaster_tv_niche_frame")
    pier = chr_meshes.get("chr_base_plaster_tv_pier")
    wall_west = [w for w in summary["walls"] if w["kind"] != "outer" and w["floor"] == "GF" and abs(w["a"][0] - 4.25) < 1e-6 and abs(w["b"][0] - 4.25) < 1e-6 and min(w["a"][1], w["b"][1]) <= 13.0 + 1e-6 and max(w["a"][1], w["b"][1]) >= 19.25 - 1e-6]   # the wall run that covers the living's west side y 13–19.25
    full = all(abs(w["z1"] - (STRUCT_TOP["FF"] - T_SLAB)) < 1e-6 and w["kind"] == "wall" for w in wall_west)
    if entrance is not None and abs(entrance["head"] - FINISHED["GF"] - tv["entrance_head"]) < 1e-6 and niche is not None and pier is not None and full and wall_west and abs(tv["niche_width"] - 4.4) < 1e-6 and abs(tv["eye_to_screen"] - 3.45) < 0.06 and tv["path_north"] >= 1.0:
        ok(f"TV wall (V6.3): the living's west wall x 4.25 is solid to the slab underside (+{STRUCT_TOP['FF'] - T_SLAB:.2f}); the entrance arch {entrance['width']:.2f} m wide, head +{entrance['head'] - FINISHED['GF']:.2f}; the TV niche {tv['niche_width']:.2f} × {tv['niche_depth']:.2f} m between the pier and the south wall, head +{tv['niche_head']:.2f}; "
           f"sofa back x {tv['sofa_back_x']:.2f}, eye-to-screen {tv['eye_to_screen']:.2f} m, path {tv['path_north']:.2f} m at the sofa's north end to the dining; no arches between the colonnade columns")
    else:
        bad(f"TV wall: entrance {entrance}, niche {niche is not None}, pier {pier is not None}, wall full height {full}, {tv}")

# ---------- 11: the roofline and the enclosure (V7.0, studies/roof.typ and studies/courtyard_enclosure.typ) ----------
print("11. Roofline and enclosure (V7.0, assumed)")
rd = summary["roof_design"]
cn, at, sr = RD["cornice"], RD["attic"], RD["stair_room"]
cor = meshes["roof_cornice"]
cor_ok = abs(cor.bounds[0][2] - cn["z0"]) < 1e-3 and abs(cor.bounds[1][2] - cn["z0"] - cn["h"]) < 1e-3 and abs((cor.bounds[1][0] - cor.bounds[0][0]) - (outline_poly.bounds[2] - outline_poly.bounds[0] + T_OUT + 2 * cn["proj"])) < 1e-3
band = meshes["ff_band"]
band_ok = abs(band.bounds[0][2] - RD["band"]["z0"]) < 1e-3 and abs((band.bounds[1][0] - band.bounds[0][0]) - (outline_poly.bounds[2] - outline_poly.bounds[0] + T_OUT + 2 * RD["band"]["proj"])) < 1e-3
if cor_ok and band_ok:
    ok(f"the main cornice {cn['h']} m high projecting {cn['proj']} m at +{cn['z0']:.2f} … +{cn['z0'] + cn['h']:.2f} all round; the band between the floors at +{RD['band']['z0']:.2f}")
else:
    bad("cornice / band")
pn, cs, ps, css = meshes["roof_parapet_n"], meshes["roof_coping_n"], meshes["roof_parapet_s"], meshes["roof_coping_s"]
if abs(cs.bounds[1][2] - RD["coping_north"]["top"]) < 1e-3 and abs(css.bounds[1][2] - RD["parapet_south"]["top"]) < 1e-3 and pn.bounds[1][1] <= at["y_south"] + 1e-6 and ps.bounds[0][1] >= at["y_south"] - 1e-6:
    ok(f"north block coping +{RD['coping_north']['top']:.2f} (y < {at['y_south']}), south wing parapet +{RD['parapet_south']['top']:.2f}: the roofline steps {RD['parapet_south']['top'] - RD['coping_north']['top']:.2f} m at y {at['y_south']} on the facade, the attic coping +{at['top']:.2f} behind it")
else:
    bad("parapets / copings")
aw, ac = meshes["roof_attic_wall"], meshes["roof_attic_coping"]
attic_line = wkt.loads(rd["attic"]["line_wkt"])
setback_ok = abs(attic_line.bounds[0] - (outline_poly.bounds[0] - T_OUT / 2 + at["setback"])) < 1e-6 and abs(attic_line.bounds[1] - (outline_poly.bounds[1] - T_OUT / 2 + at["setback"])) < 1e-6 and abs(attic_line.bounds[3] - at["y_south"]) < 1e-6
if setback_ok and abs(aw.bounds[1][2] - at["wall_top"]) < 1e-3 and abs(ac.bounds[1][2] - at["top"]) < 1e-3 and abs(aw.bounds[0][2] - L["roof"]) < 1e-3:
    ok(f"attic screen wall {at['thickness']} m thick, {at['wall_top'] - L['roof']:.2f} m above the roof slab (coping +{at['top']:.2f}), set back {at['setback']} m from the facade face on the north, the cut, the east and the west (except at the stair room), its south wall on y {at['y_south']}; {len(at['doors'])} doors; ≈ {rd['attic']['length']:.1f} m long")
else:
    bad(f"attic: setback {setback_ok}, wall {aw.bounds[:, 2].tolist()}, coping {ac.bounds[1][2]}")
sw, ss = meshes["roof_stair_wall"], meshes["roof_stair_slab"]
sr_ok = abs(sw.bounds[0][2] - L["roof"]) < 1e-3 and abs(sw.bounds[1][2] - sr["soffit"]) < 1e-3 and abs(ss.bounds[1][2] - sr["soffit"] - sr["slab"]) < 1e-3 and summary["stair_room"]["clear"] >= 2.2 - 1e-6 and "roof_stair_door" in meshes and "roof_stair_glazing" in meshes
if sr_ok:
    ok(f"stair room on the well (x {sr['box'][0]}–{sr['box'][2]}, y {sr['box'][1]}–{sr['box'][3]}): walls to +{sr['soffit']:.2f}, {summary['stair_room']['clear']:.2f} m clear over the arrival, roof slab top +{sr['soffit'] + sr['slab']:.2f}, edge +{sr['edge']:.2f}; door {sr['door'][1] - sr['door'][0]:.2f} on a {sr['kerb']} kerb (head +{sr['door_head']:.2f}), window east")
else:
    bad("stair room")
w1 = [o for o in ops if o["floor"] == "FF" and abs(o["a"][0] - PROJ_X) < 1e-6 and abs(o["b"][0] - PROJ_X) < 1e-6]
w2 = [o for o in ops if o["floor"] == "FF" and abs(o["a"][1] - 6.5) < 1e-6 and abs(o["b"][1] - 6.5) < 1e-6 and o["kind"] == "window"]
w3 = [o for o in ops if o["name"].startswith("W3")]
b3z = beams["B3"]["z1"]
if len(w1) == 1 and abs(w1[0]["sill"] - b3z) < 1e-6 and abs(w1[0]["head"] - 6.75) < 1e-6 and len(w2) == 1 and abs(w2[0]["head"] - 6.75) < 1e-6 and len(w3) == 1 and abs(w3[0]["head"] - 6.75) < 1e-6 and abs(w3[0]["sill"] - STOREY["GF"][1]) < 1e-6:
    ok(f"courtyard enclosure (option A, V7.0): W1 on the gallery edge x {PROJ_X} from the B3 upstand +{b3z:.2f} to +6.75 ({w1[0]['width']:.2f} m), W2 on the family living edge +{w2[0]['sill']:.2f} … +6.75 ({w2[0]['width']:.2f} m), W3 over the living's courtyard glass +{w3[0]['sill']:.2f} … +6.75 ({w3[0]['width']:.2f} m); no railing on those edges; the sky stays open ({COURT_SKY.area:.2f} m²)")
else:
    bad(f"enclosure windows: W1 {w1}, W2 {w2}, W3 {w3}")
gal = [w for w in summary["walls"] if w["floor"] == "FF" and w["kind"] == "wall" and abs(w["a"][0] - PROJ_X) < 1e-6 and abs(w["b"][0] - PROJ_X) < 1e-6]
gal_clear = PROJ_X - 0.03 - (4.25 + T_IN / 2 + 0.015)
ok(f"gallery: the wall on x {PROJ_X} (the projection {P['projection']['width']} m) carries W1; clear ≈ {gal_clear:.3f} m between the rooms' plastered face and the window frame, {PROJ_X - 0.2 - (4.25 + T_IN / 2 + 0.015):.3f} m at the Ø0.40 column sleeves (≥ 1.20)") if gal and gal_clear >= 1.2 else bad("gallery wall / clear width")
for n in ("roof_cornice", "ff_band", "roof_coping_n", "roof_coping_s"):
    m = meshes[n]
    lim = {"roof_cornice": cn["proj"], "ff_band": RD["band"]["proj"]}.get(n, RD["coping_north"]["overhang"]) + 1e-3
    ob = outline_poly.bounds
    if not (m.bounds[0][0] > ob[0] - T_OUT / 2 - lim and m.bounds[1][0] < ob[2] + T_OUT / 2 + lim and m.bounds[0][1] > ob[1] - T_OUT / 2 - lim and m.bounds[1][1] < ob[3] + T_OUT / 2 + lim):
        bad(f"{n} projects more than {lim - 1e-3} m beyond the outer face")

print()
for f in summary["flags"]:
    print("  flag  " + f)
print()
if problems:
    print(f"{len(problems)} 3D PROBLEM(S)")
    sys.exit(1)
print("3D CHECKS PASSED")

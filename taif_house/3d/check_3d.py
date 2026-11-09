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
     the headroom over every tread to the underside of the beams / slab ≥ params headroom_min; V8.0: the roof slab closed over the well,
     V8.1: the maintenance ladder in the suite court (the pilaster, the recess, the rungs, the stiles above the roof, the gate), the set-back guardrail, the outdoor kitchen;
  7. the structural elements of the zone: the colonnade to the roof (X8), the upturned edge beam, the flags (assumed / unconfirmed);
  8. the sun positions: noon altitudes equal the formulas of studies/sections.typ, morning / afternoon symmetric; true north from base.typ;
  9. the air system (route, chamber, pads, levels, the wall grille);
 10. the character study (3d/character.yaml, STYLE STUDY): every chr_* mesh named and grouped, the base model untouched (the few replaced
     meshes exist), the outer-window glazing recessed by the reveal, every mashrabiya on a window of the plans and flush with the face,
     the rendered sleeves round the colonnade, no pergola, the roof guards, the courtyard layout (the step, the benches, the TV and its
     surround over the grille, the enclosure), the arcade, nothing beyond the outer face + the plinth / coping;
 11. the roofline: the cornice, the copings, the attic (a plain pentagon since V8.0), the HRV base under the malqaf, the enclosure windows.
Ends with "3D CHECKS PASSED" (plus the flagged items) or a list of problems (exit code 1).
"""
import json
import math
import sys
from pathlib import Path

import numpy as np
import trimesh
import yaml
from shapely.geometry import LineString, Point, Polygon, box
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
                         ("roof = outline + half the outer wall − courtyard sky − suite court − tower shaft (V8.0: the stair well closed)", roof, outer_face.area - COURT_SKY.area - SUITE_COURT.area - TOWER_HOLE.area),
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
ok(f"stair opening in the first-floor slab: {so:.2f} m² ({STAIR_OPENING.wkt[:60]}…; dir {ST.get('dir', -1):+d}, the lower flight on the {'east' if int(ST.get('lower_e', 0)) else 'west'} half)") if 7.5 < so < 9.0 else bad(f"stair opening {so:.2f} m², expected about 8.2")

# ---------- 4: outline and levels ----------
print("4. Outline and levels")
PROUD = ("roof_cornice", "ff_band", "roof_coping_n", "roof_coping_s")   # V7.0: the cornice, the band and the copings stand proud of the facade: checked in 11
allv = np.vstack([m.vertices for n, m in meshes.items() if not n.startswith("all_col") and "_air_" not in n and not n.startswith("chr_") and not n.startswith("ext_") and n not in PROUD])   # the air system (head above the roof, tunnel below the slab, cap beyond the walls) is checked in 9, the character study in 10
lo, hi = allv.min(axis=0), allv.max(axis=0)
ob = outline_poly.bounds
if all(abs(v) < 1e-4 for v in (lo[0] - (ob[0] - T_OUT / 2), lo[1] - (ob[1] - T_OUT / 2), hi[0] - (ob[2] + T_OUT / 2), hi[1] - (ob[3] + T_OUT / 2))):
    ok(f"plan extent = outline + half the outer wall: {hi[0] - lo[0]:.3f} × {hi[1] - lo[1]:.3f} m")
else:
    bad(f"plan extent {lo[:2].round(3).tolist()}–{hi[:2].round(3).tolist()} does not match the outline {ob}")
RD = P["roof_design"]
if abs(lo[2] - (STRUCT_TOP["GF"] - T_SLAB)) < 1e-4 and abs(hi[2] - RD["attic"]["top"]) < 1e-4:   # the air system (the malqaf tower) excluded here: checked in 11
    ok(f"levels: ground slab underside {lo[2]:+.2f}, the highest base mesh within the outline {hi[2]:+.2f} (the attic coping +{RD['attic']['top']:.2f}; the malqaf tower checked in 11; no stair room) · finished GF {FINISHED['GF']:+.2f} / FF {FINISHED['FF']:+.2f}, structural slab tops {STRUCT_TOP['GF']:+.2f} / {STRUCT_TOP['FF']:+.2f} / roof {L['roof']:+.2f} (finish {P['finish']})")
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
_sd = st.get("dir", -1)
beyond, before = Point(top_n["x"], top_n["y"] - _sd * 0.05), Point(top_n["x"], top_n["y"] + _sd * 0.05)
if abs(top_n["z"] - FINISHED["FF"]) < 1e-6 and ff_poly.contains(beyond) and STAIR_OPENING.contains(before):
    ok(f"arrival: the top riser lands at +{top_n['z']:.2f} on the first-floor slab (arrival strip y {st['arrival_y'][0]}–{st['arrival_y'][1]} inside the stair box, then the gallery's north part beside the lift door)" if _sd > 0 else f"arrival: the top riser lands at +{top_n['z']:.2f} on the first-floor slab (arrival strip y {st['arrival_y'][0]}–{st['arrival_y'][1]} inside the stair box, then the landing room)")
else:
    bad(f"arrival: top nosing z {top_n['z']} at y {top_n['y']}, slab beyond {ff_poly.contains(beyond)}, opening before {STAIR_OPENING.contains(before)}")
# the trimmers edge the opening
b16, b17, b18 = (next(b for b in summary["structure"]["beams"] if b["id"] == i) for i in ("B16", "B17", "B18"))
ox0, oy0, ox1, oy1 = STAIR_OPENING.bounds
_le = int(ST.get("lower_e", 0)) == 1
edge_ok = abs(b16["a"][1] + _sd * b16["w"] / 2 - (ST["b16"] + _sd * T_IN / 2)) < EPS and abs(b17["a"][0] + (-1 if _le else 1) * b17["w"] / 2 - ST["split"]) < EPS and abs(b18["a"][1] + _sd * b18["w"] / 2 - ST["top"]) < EPS
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
# V8.0: the internal stair stops at the first floor (the roof slab closed over the well); V8.1: the roof is reached by the maintenance ladder in the suite court
roof_poly = outer_face.difference(COURT_SKY).difference(SUITE_COURT).difference(TOWER_HOLE)
over_well = [Point(ST["x0"] + 0.3, ST["y0"] + 0.3), Point(ST["x1"] - 0.3, ST["top"] - 0.3)]
if all(roof_poly.contains(p) for p in over_well) and not any(n.startswith("ff_stair_flight3") or n.startswith("ff_stair_flight4") or n.startswith("roof_stair") for n in meshes) and not any(b["id"] in ("R16", "R17", "R18") for b in summary["structure"]["beams"]):
    ok("the internal stair stops at the first floor (V8.0): no flights 3 / 4, no stair room, no trimmers R16–R18; the roof slab is closed over the stair well")
else:
    bad("the internal roof stair / the roof opening over the well is still in the model")
# V8.1: the roof is reached by the maintenance ladder in the suite court (no stair tower)
ld = summary.get("ladder")
lad_names = ("ff_ladder_pilaster", "ff_ladder_panel", "ff_ladder_stile_0", "ff_ladder_stile_1", "roof_ladder_gate", "roof_guardrail_setback")
if ld and all(n in meshes for n in lad_names) and not any(n.startswith("ext_tower") for n in meshes):
    rf_ = L["roof"] + P["roof_finish"]
    pil_ = meshes["ff_ladder_pilaster"].bounds
    st_ok = all(abs(meshes[f"ff_ladder_stile_{k}"].bounds[1][2] - ld["stile_top"]) < 1e-3 for k in (0, 1)) and abs(ld["stile_top"] - rf_ - 1.10) < 1e-6
    rung_ok = abs(ld["rungs"][0] - rf_) < 1e-6 and ld["rungs"][-1] - ld["foot"] <= 0.40 + 1e-6 and all(0.25 - 1e-6 <= a - b <= 0.30 + 1e-6 for a, b in zip(ld["rungs"], ld["rungs"][1:]))
    pil_ok = abs(pil_[0][2] - FINISHED["FF"]) < 1e-3 and abs(pil_[1][2] - rf_) < 1e-3 and ld["recess"][0] >= ld["pilaster"][0] + 0.05 - 1e-6 and ld["pilaster"][0] >= 4.35 - 1e-6   # the gym wall (x 4.15–4.35) is not cut
    toe_ok = ld["toe_clearance"] >= 0.18 - 1e-6 and (ld["stiles_y"][1] - ld["stiles_y"][0]) - 0.03 >= 0.40
    gate_ok = abs(meshes["roof_ladder_gate"].bounds[1][2] - (rf_ + 1.10)) < 1e-3 and abs(ld["gate"][0] - 4.25) < 1e-6
    gs = summary["guardrail_setback"]
    gr_ok = abs(meshes["roof_guardrail_setback"].bounds[1][2] - (rf_ + gs["height"])) < 1e-3 and all(abs(min(p_[0] for p_ in l_) - (outline_poly.bounds[0] - T_OUT / 2 + gs["setback"])) < 1e-6 or abs(max(p_[0] for p_ in l_) - (outline_poly.bounds[2] + T_OUT / 2 - gs["setback"])) < 1e-6 for l_ in gs["lines"]) and all(abs(max(p_[1] for p_ in l_) - (outline_poly.bounds[3] + T_OUT / 2 - gs["setback"])) < 1e-6 for l_ in gs["lines"])
    if st_ok and rung_ok and pil_ok and toe_ok and gate_ok and gr_ok:
        ok(f"roof access (V8.1): no stair tower; the ladder in a {ld['recess'][3] - ld['recess'][1]:.2f} × {ld['recess'][2] - ld['recess'][0]:.2f} recess of a rendered pilaster on the gym's east wall (the wall not cut), climb {ld['climb']:.2f} m, "
           f"{len(ld['rungs'])} rungs, the top rung at the roof finish +{rf_:.2f}, toe clearance {ld['toe_clearance']:.2f}, the stiles to +{ld['stile_top']:.2f}, the closed walnut panel, the self-closing gate 1.10 in the court's west guard; "
           f"the guardrail {gs['height']:.2f} m set back {gs['setback']:.1f} m from the south wing's west, south and east faces")
    else:
        bad(f"ladder: stiles {st_ok}, rungs {rung_ok}, pilaster {pil_ok}, clearances {toe_ok}, gate {gate_ok}, set-back guardrail {gr_ok}")
else:
    bad("roof access: the ladder meshes are missing")
ok_k = summary.get("outdoor_kitchen")
if ok_k and all(n in meshes for n in ("ext_kitchen_counter", "ext_kitchen_grill", "ext_kitchen_tannour")) and ok_k["counter"][0] >= outline_poly.bounds[2] + T_OUT / 2 - 1e-6:
    gx0g, gy0g, gx1g, gy1g = ok_k["grill"]; gpl_ = Polygon([(gx0g, gy0g), (gx1g, gy0g), (gx1g, gy1g), (gx0g, gy1g)])
    d_house = gpl_.distance(outer_face)
    ok(f"the outdoor kitchen (3 Nov 2026): the counter against the east wall face beside the service door (x {ok_k['counter'][0]}, y {ok_k['counter'][1]}–{ok_k['counter'][3]}), the grill and tannour {d_house:.2f} m from the house") if d_house >= 3.0 - 1e-6 else bad(f"the grill {d_house:.2f} m from the house (< 3 m)")
else:
    bad("outdoor kitchen meshes")

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
if (beams.get("R6", {}).get("state") == "unconfirmed" or "R6" not in beams) and any("NOT verified" in f for f in summary["flags"]):   # v2: R6 removed; the x 10.0 wall stays unconfirmed (X5)
    ok(f"the first-floor wall(s) over the men's majlis ribs are marked unconfirmed (X5, not verified): red in the model; R6 " + ("removed (south wing v2)" if "R6" not in beams else "unconfirmed"))
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

# ---------- 9: the air system (V10.0: the malqaf at L5) ----------
print("9. Air system (studies/air_system.typ v4, the malqaf at L5, all assumed)")
air = summary["air"]
core = Polygon(air["core"]); shaft = Polygon(air["shaft"])
court_poly = Polygon(next(r for r in GF if r["name"] == "Courtyard")["pts"])
riwaq_poly = Polygon(next(r for r in GF if r["name"].startswith("Family lobby"))["pts"])
maj_poly = Polygon(next(r for r in GF if r["name"] == "Women's majlis")["pts"])
if core.touches(court_poly) and core.touches(riwaq_poly) and core.touches(maj_poly) and court_poly.intersection(core).area < 1e-6 and shaft.within(core.buffer(1e-6)) and abs(core.bounds[2] - PROJ_X) < 1e-6 and abs(core.bounds[1] - 6.5) < 1e-6:
    ok(f"the malqaf core at the courtyard's north-west corner: x {core.bounds[0]}–{core.bounds[2]}, y {core.bounds[1]}–{core.bounds[3]} ({core.area:.2f} m² on axes), against the women's majlis wall, the riwaq and the courtyard; the shaft {shaft.area:.2f} m² inside it; no bedroom touches it (D10)")
else:
    bad(f"the malqaf core's position: {core.bounds}")
if abs(summary["voids"]["ff"]["tower_shaft"] - TOWER_HOLE.area) < 1e-4 and 0.9 < TOWER_HOLE.area < 1.0:
    ok(f"the shaft open through the first-floor and roof slabs: {TOWER_HOLE.area:.2f} m² (1.2 × 0.8 clear)")
else:
    bad(f"shaft opening {TOWER_HOLE.area}")
gm = meshes.get("gf_air_grille")
ox, oy0, oy1, oz0, oz1 = air["outlet"]
grille_ok = gm is not None and abs(gm.bounds[0][0] - (ox + T_IN / 2 - 0.015)) < 1e-3 and abs(gm.bounds[0][1] - oy0) < 1e-3 and abs(gm.bounds[1][1] - oy1) < 1e-3 and abs(gm.bounds[0][2] - (FINISHED["GF"] + oz0)) < 1e-3
door_ok = any(o["floor"] == "GF" and abs(o["a"][1] - air["door"][0]) < 1e-6 and abs(o["b"][1] - air["door"][0]) < 1e-6 and min(o["a"][0], o["b"][0]) >= core.bounds[0] and max(o["a"][0], o["b"][0]) <= core.bounds[2] for o in ops)
if grille_ok and door_ok and all(n in meshes for n in ("gf_air_trap_walls", "gf_air_trap_grating", "gf_air_fan_cabinet", "gf_air_door_leaf")) and not any(n.startswith("gf_air_duct") or n.startswith("gf_air_chamber") or n == "gf_air_plenum" or n.startswith("gf_air_cover") for n in meshes):
    ok(f"the foot chamber: the louvred outlet on the core's east face into the first arcade arch (x {ox}, y {oy0}–{oy1}, +{oz0:.2f} … +{oz1:.2f}), the carved door {air['door'][2] - air['door'][1]:.2f} m onto the covered strip, the dust trap, the fan cabinet; no channel, no covers, no plenum under the floors (V10.0)")
else:
    bad(f"the foot chamber (grille {grille_ok}, door {door_ok})")
hz = air["head_z"]
if abs(meshes["roof_air_cap"].bounds[1][2] - hz[6]) < 1e-3 and abs(hz[6] - (RD["attic"]["top"] + 4.52)) < 1e-6 and hz[3] >= 11.42 - 0.25 and "roof_air_void_slots" in meshes and not any(n.startswith("roof_air_base") or n.startswith("roof_air_plant") or n == "roof_air_plenum" for n in meshes):
    ok(f"the malqaf head 1.6 × 2.4 on the shaft and the gallery roof: openings +{hz[3]:.2f} … +{hz[4]:.2f} (above the roof's wake), the crown +{hz[6]:.2f} = 4.52 m above the attic coping; no HRV plant room, no plenum (V10.0)")
else:
    bad(f"the malqaf head: {hz}")

# ---------- 10: the character study (3d/character.yaml) · STYLE STUDY, PROVISIONAL ----------
print("10. Character study (3d/character.yaml, style study, provisional)")
C = yaml.safe_load((HERE / "character.yaml").read_text(encoding="utf-8"))
ch = summary.get("character", {})
chr_meshes = {n: m for n, m in meshes.items() if n.startswith("chr_")}
if not C.get("enabled", True) or not ch.get("enabled"):
    ok("character study disabled in character.yaml: no chr_* meshes") if not chr_meshes else bad(f"character disabled but {len(chr_meshes)} chr_* meshes in the GLB")
else:
    GROUPS = {"base", "pergola", "sunken", "props", "light", "site"}   # V8.2: site = the site plan's elements outside the house
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
    # the colonnade's rendered sleeves (V10.0: no stone)
    bad_sl = []
    for s in ch["sleeves"]:
        m = chr_meshes.get(f"chr_base_honey_column_{s['column']}")
        if m is None or abs(m.bounds[0][2] - FINISHED["GF"]) > 1e-3 or abs(m.bounds[1][2] - (L["roof"] - T_SLAB)) > 1e-3 \
                or abs((m.bounds[1][0] - m.bounds[0][0]) - C["colonnade"]["base"]["diameter"]) > 0.02:
            bad_sl.append(s["column"])
    if bad_sl or len(ch["sleeves"]) != len(P["structure"]["column_to_roof"]):
        bad(f"colonnade sleeves: {bad_sl}")
    else:
        ok(f"rendered sleeves (V10.0: no stone) Ø{C['colonnade']['diameter']} with base and capital bands on {', '.join(s['column'] for s in ch['sleeves'])} ({ch['sleeves'][0]['structural']} assumed inside), finished ground floor → roof underside")
    # the pergola
    pg = ch["pergola"]
    pm = chr_meshes.get("chr_pergola_timber_beams")
    cy0, cy1 = COURT_SKY.bounds[1], COURT_SKY.bounds[3]
    if pm is None and pg["beams"] == 0 and not pg["default"]:
        ok("pergola: none (removed by the owner, 1 Nov 2026, studies/courtyard_layout.typ: no pergola and no shade structure over the courtyard)")
    elif pm is not None and pg["over_y"][0] >= cy0 - EPS and pg["over_y"][1] <= cy1 + EPS and abs(pm.bounds[0][2] - (L["roof"] + P["roof_finish"])) < 1e-3 and pg["sky_covered_share"] <= 0.15:
        ok(f"pergola: {pg['beams']} timber beams {pg['section'][0]} × {pg['section'][1]} at {pg['spacing']} m over y {pg['over_y'][0]}–{pg['over_y'][1]} of the courtyard sky (y {cy0}–{cy1}), on the roof finish; "
           f"covers {pg['sky_covered_share'] * 100:.0f} % of the sky hole (toggle; default {'on' if pg['default'] else 'off'})")
    else:
        bad(f"pergola: {pg}")
    # the roof guards and the character meshes' plan extent
    rg = chr_meshes.get("chr_base_steel_roof_railings")
    if rg is not None and abs(rg.bounds[1][2] - (L["roof"] + P["roof_finish"] + RD["guard"]["height"])) < 1e-3:
        ok(f"black steel bar guards {RD['guard']['height']} m round the courtyard sky hole and on the suite court's open edges (the gym roof / nib and the office roof; the north edge is the attic wall, the south the parapet on the frame R8)")
    else:
        bad("roof guards")
    proud = max(C["plinth"]["thickness"], C["feature_walls"]["thickness"], C["quoins"]["thickness"]) + 1e-3
    chrv = np.vstack([m.vertices for n, m in chr_meshes.items() if not n.startswith("chr_site_")])   # V8.2: the site elements lie outside the house by design (checked below)
    ob = outline_poly.bounds
    if chrv[:, 0].min() > ob[0] - T_OUT / 2 - proud and chrv[:, 1].min() > ob[1] - T_OUT / 2 - proud and chrv[:, 0].max() < ob[2] + T_OUT / 2 + proud and chrv[:, 1].max() < ob[3] + T_OUT / 2 + proud:
        ok(f"every character mesh of the house lies within the outer wall face + {proud - 1e-3:.2f} m (plinth, cladding, coping); props and lanterns in the courtyard / under the soffit")
    else:
        bad(f"character meshes beyond the outer face: x {chrv[:, 0].min():.3f}–{chrv[:, 0].max():.3f}, y {chrv[:, 1].min():.3f}–{chrv[:, 1].max():.3f}")
    # V8.2: the site elements (the site plan, study): on the ground round the house, inside the plot's extent, none higher than the hedge; the suite court's mashrabiya screen on the base up to the frame soffit
    exist_n = {e["name"] for e in summary["character"]["meshes"] if e.get("existing")}   # V9.0: the existing farm (the old house, the walls, the palms …) is checked apart
    exist_m = {n: m for n, m in chr_meshes.items() if n in exist_n}
    site_m = {n: m for n, m in chr_meshes.items() if n.startswith("chr_site_") and n not in exist_n}
    gnd = C["plinth"]["ground"]
    shx, shy = C["site"]["shift"]   # the plot's extent is checked in the SITE frame (4 Nov 2026: the house moved 1.238 m south, the driveway and the paths did not)
    if site_m and all(m.bounds[0][2] >= gnd - 0.02 and m.bounds[1][2] <= gnd + 1.85 for m in site_m.values()) and all(-4.1 <= m.bounds[0][0] + shx and m.bounds[1][0] + shx <= 26.9 and -2.2 <= m.bounds[0][1] + shy and m.bounds[1][1] + shy <= 39.9 for m in site_m.values()):
        ok(f"{len(site_m)} site elements (V8.2 / 3 Nov 2026, studies/site_plan.typ: the driveway, three paths (the workers' along the boundary wall), the parking bay, the garden, its wall, the hedge, the yard screen, the gas cabinet, the bins) on the ground round the house, inside the plot, the hedge 1.8 m the highest")
    else:
        bad(f"site elements: {len(site_m)} meshes, bounds off the ground or outside the plot")
    if exist_m and all(m.bounds[0][2] >= gnd - 0.02 and m.bounds[1][2] <= gnd + 11.0 for m in exist_m.values()) and all(-19.5 <= m.bounds[0][0] + shx and m.bounds[1][0] + shx <= 27.4 and -2.2 <= m.bounds[0][1] + shy and m.bounds[1][1] + shy <= 40.0 for m in exist_m.values()) \
            and not any(outline_poly.buffer(T_OUT / 2).intersects(box(m.bounds[0][0], m.bounds[0][1], m.bounds[1][0], m.bounds[1][1])) for n, m in exist_m.items() if "palm" not in n and "farm_wall" not in n):
        ok(f"{len(exist_m)} existing-farm meshes (V9.0: the old house and its annex, the covered parking, the tank, the septic, the north and lane walls with the gate, the two palms): on the ground, within the farm's north zone, none touching the new house; approximate, to be measured")
    else:
        bad(f"existing farm: {len(exist_m)} meshes, bounds off the ground, outside the north zone or touching the house")
    scr = chr_meshes.get("chr_base_timber_court_screen")
    sc_ = summary.get("suite_court", {})
    if scr is not None and abs(scr.bounds[0][2] - sc_["base_top"]) < 1e-3 and abs(scr.bounds[1][2] - sc_["frame_soffit"]) < 1e-3 and 0.3 <= ch["court_screen"]["open"] <= 0.5:
        ok(f"the suite court's mashrabiya screen (V8.2, owner): on the 1.10 base from +{sc_['base_top']:.2f} to the frame soffit +{sc_['frame_soffit']:.2f}, {ch['court_screen']['open'] * 100:.0f} % open, {scr.bounds[1][0] - scr.bounds[0][0]:.2f} m wide between the gym's and the office's walls")
    else:
        bad("the suite court's mashrabiya screen: missing, or not from the base top to the frame soffit, or its openness outside 30–50 %")
    # 3 Nov 2026: the courtyard layout revised (studies/courtyard_layout.typ, owner): the floor LEVEL (the base model's courtyard floor kept, no pit, no benches), the movable furniture inside
    # the seating zone and clear of the enclosure, the enclosure on the kitchen wall in front of the sink window (the water rim below the sill), the TV south of it over the grille, the drains
    cy_ = ch["courtyard"]
    court_floor = Polygon(court["pts"]).buffer(-T_IN / 2, join_style=2)
    def _b2(m):
        return Polygon([(m.bounds[0][0], m.bounds[0][1]), (m.bounds[1][0], m.bounds[0][1]), (m.bounds[1][0], m.bounds[1][1]), (m.bounds[0][0], m.bounds[1][1])])
    level_ok = cy_.get("level") and not cy_["replaces"] and all(n in meshes for n in ("gf_slab_court", "gf_finish_court")) and not any("pit_floor" in n or "bench" in n or "step_nosing" in n for n in chr_meshes)
    sz = cy_["seating_zone"]; szp = Polygon([(sz[0], sz[1]), (sz[2], sz[1]), (sz[2], sz[3]), (sz[0], sz[3])])
    eb = cy_["enclosure"]["box"]; ebp = Polygon([(eb[0], eb[1]), (eb[2], eb[1]), (eb[2], eb[3]), (eb[0], eb[3])])
    furn = [m for n, m in chr_meshes.items() if n.startswith("chr_sunken_timber_court_") or n.startswith("chr_sunken_honey_court_table")]
    furn_ok = len(furn) >= 3 and all(szp.buffer(0.01).contains(_b2(m)) and ebp.intersection(_b2(m)).area < 1e-6 for m in furn) and all(m.bounds[0][2] >= FINISHED["GF"] - 1e-6 for m in furn)
    sw = cy_["sink_window"]
    enc_ok = abs(eb[2] - court_floor.bounds[2]) < 1e-3 and eb[1] <= sw["y"][0] + 1e-6 and eb[3] >= sw["y"][1] - 1e-6 and cy_["enclosure"]["water_rim"] < sw["sill"] and cy_["enclosure"]["water_rim"] > cy_["enclosure"]["rim"] \
        and all(f"chr_base_{n}" in chr_meshes for n in ("honey_enclosure_walls", "water_basin_water", "foliage_tree_crown", "trunk_planter_soil")) and abs(chr_meshes["chr_base_honey_enclosure_walls"].bounds[1][2] - cy_["enclosure"]["water_rim"]) < 1e-3
    tv_ok = cy_["tv_crown"] < STRUCT_TOP["FF"] - T_SLAB and "chr_base_honey_tv_surround" in chr_meshes and abs(cy_["grille"]["y"][0] - summary["air"]["outlet"][1]) < 1e-6   # V10.0: the malqaf outlet is in the west arcade, no longer under the TV and "chr_base_bronze_outdoor_tv" in chr_meshes and cy_["tv"]["y"][0] >= eb[3] - 1e-6 and cy_["grille"]["z"][0] >= 0.10 - 1e-6
    gaps_ok = cy_["level_edges"]["north"] >= 0.5 - 1e-6 and cy_["level_edges"]["south"] >= 0.6 - 1e-6 and cy_["level_edges"]["west"] >= 1.5 - 1e-6
    drains_ok = len(cy_["linear_drains"]) >= 2 and court_floor.buffer(0.01).contains(Point(cy_["overflow"])) and "chr_sunken_bronze_overflow" in chr_meshes
    if level_ok and furn_ok and enc_ok and tv_ok and gaps_ok and drains_ok:
        ok(f"courtyard layout (3 Nov 2026): the floor LEVEL (no step, no benches; the base floor kept); {len(furn)} movable pieces inside the seating zone x {sz[0]}–{sz[2]} y {sz[1]}–{sz[3]}, clear of the enclosure; "
           f"the enclosure on the kitchen wall in front of the sink window (y {eb[1]}–{eb[3]}; the planter rim +{cy_['enclosure']['rim']:.2f}, the water rim +{cy_['enclosure']['water_rim']:.2f} below the sill +{sw['sill']:.2f}); "
           f"the outdoor TV +{cy_['tv']['z'][0]:.2f} … +{cy_['tv']['z'][1]:.2f} south of it over the malqaf grille (+{cy_['grille']['z'][0]:.2f} … +{cy_['grille']['z'][1]:.2f}), its surround's crown +{cy_['tv_crown']:.2f}; "
           f"the cleaning strips north {cy_['level_edges']['north']:.2f} / south {cy_['level_edges']['south']:.2f}, the colonnade walkway {cy_['level_edges']['west']:.2f} free; {len(cy_['linear_drains'])} linear drains and the overflow")
    else:
        bad(f"courtyard layout: level {level_ok}, furniture {furn_ok}, enclosure {enc_ok}, tv {tv_ok}, gaps {gaps_ok}, drains {drains_ok}")
    # the fountain on the east wall between the grille and the sink window
    fo = ch.get("fountain")
    if fo is None:
        ok("wall fountain: none on the kitchen wall (superseded 1 Nov 2026: the water basin and the tree are in the north enclosure, character.yaml courtyard_layout; the builder update is pending)")
    elif fo["clear_of_grille"] >= 0.3 and (fo["below_sink_sill"] is None or fo["below_sink_sill"] >= 0) and "chr_base_honey_fountain_panel" in chr_meshes:
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
cn, at = RD["cornice"], RD["attic"]
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
    ok(f"attic screen wall {at['thickness']} m thick, {at['wall_top'] - L['roof']:.2f} m above the roof slab (coping +{at['top']:.2f}), set back {at['setback']} m from the facade face on all four sides (a plain pentagon, V8.0), its south wall on y {at['y_south']}; {len(at['doors'])} doors (one of them to the office roof); ≈ {rd['attic']['length']:.1f} m long")
else:
    bad(f"attic: setback {setback_ok}, wall {aw.bounds[:, 2].tolist()}, coping {ac.bounds[1][2]}")
sc_ = summary["suite_court"]
if "ff_low_court_south" in meshes and "ff_beam_R8_court" in meshes and abs(meshes["ff_low_court_south"].bounds[1][2] - sc_["base_top"]) < 1e-3 and abs(meshes["ff_beam_R8_court"].bounds[0][2] - sc_["frame_soffit"]) < 1e-3:
    ok(f"the suite court v2 ({sc_['area']:.2f} m², open to the sky): its south side x {sc_['south_x'][0]}–{sc_['south_x'][1]} a 1.10 m base (+{sc_['base_top']:.2f}) under the facade frame (R8 soffit +{sc_['frame_soffit']:.2f}, the cornice and the parapet carried across); the infill is the owner's choice (mashrabiya recommended, not built)")
else:
    bad("the suite court's south side (base / frame)")
w1 = [o for o in ops if o["floor"] == "FF" and abs(o["a"][0] - PROJ_X) < 1e-6 and abs(o["b"][0] - PROJ_X) < 1e-6]
w2 = [o for o in ops if o["floor"] == "FF" and abs(o["a"][1] - 6.5) < 1e-6 and abs(o["b"][1] - 6.5) < 1e-6 and o["kind"] == "window"]
w3 = [o for o in ops if o["name"].startswith("W3")]
b3z = beams["B3"]["z1"]
soffit = L["roof"] - 0.45          # the roof edge beams' soffit +6.75
arched = ch.get("arched_windows", [])
blind = ch.get("blind_arches", [])   # V10.0: W1-1 a blind arch (the malqaf shaft behind it)
crowns_ok = all(a["crown"] <= soffit - 0.1 + 1e-6 and abs(a["crown"] - a["springing"] - a["width"] / 2) < 1e-6 for a in arched)
if len(w1) == 5 and len(blind) == 1 and abs(blind[0]["sill"] - b3z) < 1e-6 and abs(blind[0]["crown"] - arched[0]["crown"]) < 1e-6 and all(abs(o["sill"] - b3z) < 1e-6 and o["head"] <= soffit - 0.1 + 1e-6 for o in w1) and len(w2) == 2 and all(o["head"] <= soffit - 0.1 + 1e-6 for o in w2) and len(w3) == 1 and abs(w3[0]["sill"] - STOREY["GF"][1]) < 1e-6 and w3[0]["head"] <= soffit - 0.1 + 1e-6 and len(arched) == 8 and crowns_ok:
    ok(f"courtyard enclosure (option A, V7.1: semicircular heads): W1 five arched windows {w1[0]['width']:.2f} m and one BLIND arch (W1-1, V10.0: the malqaf shaft behind it) on the gallery edge x {PROJ_X} from the B3 upstand +{b3z:.2f}, springing +{arched[0]['springing']:.2f}, crown +{arched[0]['crown']:.2f} ({soffit - arched[0]['crown']:.2f} m of wall below the +{soffit:.2f} soffit); "
       f"W2 two arched windows {w2[0]['width']:.2f} m east of C21, springing +{arched[5]['springing']:.2f}; W3 one arched window {w3[0]['width']:.2f} m over the living's courtyard glass, +{w3[0]['sill']:.2f} to the crown +{w3[0]['head']:.2f} (springing +{arched[7]['springing']:.2f}); no railing on those edges; the sky stays open ({COURT_SKY.area:.2f} m²)")
else:
    bad(f"enclosure windows: W1 {len(w1)} + blind {len(blind)}, W2 {len(w2)}, W3 {len(w3)}, arched {len(arched)} crowns ok {crowns_ok}")
# V7.1: the courtyard arcade: two intermediate columns on the colonnade line in the courtyard bay, three equal bays, arches below the soffit, not in the seating step, clear of the riwaq door
arc = ch.get("arcade", {})
cs_ = ch.get("courtyard", {}).get("seating_zone")   # 3 Nov 2026: the level seating zone (no step)
pit = Polygon([(cs_[0], cs_[1]), (cs_[2], cs_[1]), (cs_[2], cs_[3]), (cs_[0], cs_[3])]) if cs_ else None
riwaq_door = next((o for o in ops if o["floor"] == "GF" and abs(o["a"][0] - 4.25) < 1e-6 and 8.0 < o["a"][1] < 12.0 and o["kind"] != "window"), None)
if arc and len(arc["columns"]) == 2 and all(abs(c[0] - PROJ_X) < 1e-6 and 6.5 < c[1] < 13.0 for c in arc["columns"]) and len(arc["bays"]) == 3 and all(b["springing"] >= 2.1 for b in arc["bays"]) \
        and abs(arc["columns"][1][1] - arc["columns"][0][1] - arc["bay_axes"]) < 1e-3 and all(f"chr_base_honey_arcade_column_{k}" in chr_meshes for k in (0, 1)) and "chr_base_plaster_arcade_arches" in chr_meshes:
    gap_pit = min(pit.distance(Point(c[0], c[1])) - arc["diameter"] / 2 for c in arc["columns"]) if pit is not None else None
    gap_riwaq = min(Point(c[0], c[1]).distance(LineString([riwaq_door["a"], riwaq_door["b"]])) - arc["diameter"] / 2 - 0.1 for c in arc["columns"]) if riwaq_door else None
    w1_c = [o for o in w1 if 6.5 < (o["a"][1] + o["b"][1]) / 2 < 13.0]
    aligned = all(any(abs((o["a"][1] + o["b"][1]) / 2 - (b["y"][0] + b["y"][1]) / 2) < 0.1 for b in arc["bays"]) for o in w1_c)
    spans_txt = " / ".join("%.2f" % b["span"] for b in arc["bays"])
    ok(f"courtyard arcade (V7.1, {'structural' if arc['structural'] else 'decorative'}): two Ø{arc['diameter']} rendered columns on x {PROJ_X} at y {arc['columns'][0][1]:.3f} / {arc['columns'][1][1]:.3f} (bays {arc['bay_axes']:.3f} m on axes), three semicircular arches under the soffit: spans {spans_txt} m, springing +{min(b['springing'] for b in arc['bays']):.2f} … +{max(b['springing'] for b in arc['bays']):.2f}, crown +{arc['bays'][0]['crown']:.2f}; "
       f"the columns stand clear of the level seating zone (gap {gap_pit:.2f} m), {gap_riwaq:.2f} m clear of the riwaq door's swing line; the three W1 windows above {'aligned' if aligned else 'NOT aligned'} with the bays") if (gap_pit is None or gap_pit >= -1e-6) and aligned else bad(f"arcade: pit gap {gap_pit}, aligned {aligned}")
else:
    bad(f"arcade: {arc}")
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

"""character_3d.py · Taif / Palm House · 3D phase "character": simple architectural character for the model (STYLE STUDY, PROVISIONAL).
Called by build_3d.py after the model is built; reads 3d/character.yaml and the model's own data (openings, columns, beams, voids)
and adds the character meshes, named chr_<group>_<material>_<label> so the viewer can colour and toggle them:
  group base      the rendered plinth (V10.0: no stone anywhere; render and paint, porcelain floors), feature-wall render, recessed outer-window glazing with bronze frames, mashrabiya screens, the
                  colonnade's rendered sleeves (base and capital bands), the timber soffit and fascia under the projection, the roof
                  parapet with its coping and the roof railings, the malqaf head's timber louvres, the courtyard fountain pier
  (V7.0: the gallery railing variants are gone: the gallery edge is the wall with the steel window W1; the roof parapets, the cornice,
  the attic is a base-model mesh of build_3d.py, re-coloured here; the windows get black steel frames and divided lites)
  group pergola   timber beams over the north part of the courtyard sky (toggle)
  (V6.3: the arches variant is removed, the owner wants no arches between the colonnade columns; the group base now also holds the
  living's TV wall: the entrance arch head, the arched TV niche with its pier, cabinet, TV and shelves)
  group sunken    3 Nov 2026: the courtyard layout (studies/courtyard_layout.typ): the movable furniture, the linear drains and the overflow on the LEVEL floor (was: the seating one step down, three benches, the low
                  table, the drain and the overflow; it replaces the base model's courtyard floor meshes gf_slab_court / gf_finish_court while it is on
                  (the TV with its rendered surround and the water / tree enclosure are in the group base; the suite court furniture in props)
  group light     the hanging lanterns (point lights in the night view)
Existing meshes are not changed here: the viewer re-colours them by name (character.yaml `assign`) when the character is on and
hides the few they replace (the outer windows' centre-line glass). Nothing is edited by hand: change character.yaml
and run build_3d.py again. Nothing here is a design decision; the structure keeps its assumed sizes underneath (the Ø0.30 columns
inside the Ø0.40 rendered sleeves).
"""
import math
from pathlib import Path

import numpy as np
import trimesh
import yaml
from shapely.geometry import LineString, Point, Polygon, box
from shapely.ops import unary_union
from shapely.wkt import loads as wkt_loads

HERE = Path(__file__).resolve().parent
EPS = 1e-6
SNAP = 0.02


def build(g):
    """g: the namespace of build_3d.py (helpers, levels, the summary, the scene). Returns the viewer block."""
    C = yaml.safe_load((HERE / "character.yaml").read_text(encoding="utf-8"))
    summary, P, add, polys, seg_box = g["summary"], g["P"], g["add"], g["polys"], g["seg_box"]
    FINISHED, STRUCT_TOP, T_SLAB, T_OUT, T_IN = g["FINISHED"], g["STRUCT_TOP"], g["T_SLAB"], g["T_OUT"], g["T_IN"]
    OUTLINE, outline_poly, outer_face, ring = g["OUTLINE"], g["outline_poly"], g["outer_face"], g["ring"]
    COLS, BEAMS, PROJ_X, COURT_SKY, SUITE_COURT = g["COLS"], g["BEAMS"], g["PROJ_X"], g["COURT_SKY"], g["SUITE_COURT"]
    GF, AIR, b3_top = g["GF"], g["AIR"], g["b3_top"]
    pal = {k: (list(v) + [255])[:4] for k, v in C["palette"].items()}
    rec = {"note": C["note"], "meshes": [], "recessed_windows": [], "frames": 0, "mashrabiya": [], "feature_walls": [], "sleeves": [],
           "flags": []}
    hide = []
    if not C.get("enabled", True):
        summary["character"] = {**rec, "enabled": False}
        return {"enabled": False, "bookmarks": {}}
    ff_under = STRUCT_TOP["FF"] - T_SLAB                      # the first-floor slab underside (+3.32)
    roof_under = STRUCT_TOP["roof"] - T_SLAB
    roof_fin = STRUCT_TOP["roof"] + P["roof_finish"]           # the roof finish top (+7.30)
    gf = FINISHED["GF"]
    soffit_bottom = ff_under - C["soffit"]["thickness"]

    # ---------- helpers ----------
    def parts(poly, z0, z1):
        out = []
        for p in polys(poly):
            if p.area < 1e-9:
                continue
            m = trimesh.creation.extrude_polygon(p, z1 - z0)
            m.apply_translation([0, 0, z0])
            out.append(m)
        return out

    def emit(group, material, label, meshes, **info):
        meshes = [m for m in meshes if m is not None]
        if not meshes:
            return None
        m = trimesh.util.concatenate(meshes) if len(meshes) > 1 else meshes[0]
        m.visual.vertex_colors = pal[material]
        name = f"chr_{group}_{material}_{label}"
        m.metadata["name"] = name
        rec["meshes"].append({"name": name, "group": group, "material": material, "bounds": [round(float(v), 4) for v in m.bounds.flatten()], **info})
        add(m)
        return name

    def unit(a, b):
        d = (b[0] - a[0], b[1] - a[1])
        n = math.hypot(*d)
        return (d[0] / n, d[1] / n), n

    def shift(p, n, d):
        return (p[0] + n[0] * d, p[1] + n[1] * d)

    def outward(a, b):
        """The outward normal of the outline edge through a and b (the outer walls)."""
        (ux, uy), _ = unit(a, b)
        n = (uy, -ux)
        mid = ((a[0] + b[0]) / 2, (a[1] + b[1]) / 2)
        return n if not outline_poly.contains(Point(shift(mid, n, 0.3))) else (-n[0], -n[1])

    def panel(a, b, n, offset, thickness, profile):
        """A profile in the (s, z) plane (s along a → b) extruded `thickness` along n, starting `offset` from the line a–b."""
        (ux, uy), _ = unit(a, b)
        out = []
        for p in polys(profile):
            if p.area < 1e-9:
                continue
            m = trimesh.creation.extrude_polygon(p, thickness)       # (s, z, w)
            s, z, w = m.vertices[:, 0], m.vertices[:, 1], m.vertices[:, 2]
            m.vertices = np.column_stack([a[0] + ux * s + n[0] * (offset + w), a[1] + uy * s + n[1] * (offset + w), z])
            if uy * n[0] - ux * n[1] < 0:                            # the basis (u, z, n) is left-handed: keep the faces outward
                m.invert()
            out.append(m)
        return out

    def on_line(p, a, b):
        return LineString([a, b]).distance(Point(p)) < SNAP

    def openings_on(a, b):
        """Every built door and window whose jambs lie on the line a–b: (s0, s1, sill, head, record)."""
        (ux, uy), L = unit(a, b)
        out = []
        for o in summary["openings"]:
            if o["kind"] == "open" or not (on_line(o["a"], a, b) and on_line(o["b"], a, b)):
                continue
            s = sorted(((o["a"][0] - a[0]) * ux + (o["a"][1] - a[1]) * uy, (o["b"][0] - a[0]) * ux + (o["b"][1] - a[1]) * uy))
            if s[1] < -SNAP or s[0] > L + SNAP:
                continue
            out.append((max(s[0], 0.0), min(s[1], L), o["sill"], o["head"], o))
        return out

    def wall_t(a, b):
        return T_OUT if any(on_line(a, p, q) and on_line(b, p, q) for p, q in zip(OUTLINE, OUTLINE[1:] + OUTLINE[:1])) else T_IN

    def match_window(floor, at):
        want = [float(v) for v in at.split()]
        for i, o in enumerate(summary["openings"]):
            if o["kind"] == "window" and o["floor"] == floor and all(abs(x - y) < 0.01 for x, y in zip((*o["a"], *o["b"]), want)):
                return i, o
        raise SystemExit(f"ERROR: character.yaml window {floor} {at!r} matches no window of the plans")

    def column_points():
        return {cid: (COLS[cid]["x"], COLS[cid]["y"]) for cid in P["structure"]["column_to_roof"]}

    def disc(c, r, res=16):
        return Point(c).buffer(r, resolution=res)

    # ---------- plinth: a rendered base course (honey tone; V10.0 no stone) around the outside, the doors cut through it ----------
    pl = C["plinth"]
    plinth = outer_face.buffer(pl["thickness"], join_style=2).difference(outer_face)
    for o in summary["openings"]:
        if o["kind"] == "door" and o["wall"].endswith("_outer"):
            plinth = plinth.difference(seg_box(o["a"], o["b"], T_OUT + 2 * pl["thickness"] + 0.02))
    emit("base", "honey", "plinth", parts(plinth, pl["ground"], gf + pl["height"]), height=pl["height"])

    # ---------- windows: bronze frames on every window; outer-wall glazing set back into a deep reveal ----------
    fr, reveal = C["frame"], C["reveal"]
    frames, panes, lites = [], [], []
    for i, o in enumerate(summary["openings"]):
        if o["kind"] != "window":
            continue
        a, b = tuple(o["a"]), tuple(o["b"])
        (ux, uy), L = unit(a, b)
        outer = o["wall"].endswith("_outer")
        if outer:
            n = outward(a, b)
            off = T_OUT / 2 - reveal                                   # the glass plane, from the wall centre line (negative = inside)
            a2, b2 = shift(a, n, off), shift(b, n, off)
            panes += parts(seg_box(a2, b2, P["openings"]["glass"]), o["sill"], o["head"])
            hide.append(f"{o['floor'].lower()}_glass_{i:03d}")
            rec["recessed_windows"].append({"index": i, "floor": o["floor"], "name": o["name"], "a": a, "b": b, "normal": [round(v, 4) for v in n], "offset": round(off, 4), "reveal": reveal})
        else:
            n, off = (uy, -ux), 0.0
            a2, b2 = a, b
        frames += parts(seg_box(a2, b2, fr), o["head"] - fr, o["head"]) + parts(seg_box(a2, b2, fr), o["sill"], o["sill"] + fr)
        frames += parts(seg_box(a2, shift(a2, (ux, uy), fr), fr), o["sill"], o["head"]) + parts(seg_box(shift(b2, (ux, uy), -fr), b2, fr), o["sill"], o["head"])
        rec["frames"] += 1
        # V7.0: divided lites (docs/DESIGN_LANGUAGE.md): mullions at ≈ `lites.pitch` on windows wider than one lite, transoms in rows of ≈ `lites.row` on the tall ones
        dl = C["lites"]
        h = o["head"] - o["sill"]
        n_m = max(1, round(L / dl["pitch"]))
        for k in range(1, n_m):
            s = L * k / n_m
            lites += parts(seg_box(shift(a2, (ux, uy), s - dl["bar"] / 2), shift(a2, (ux, uy), s + dl["bar"] / 2), dl["bar"]), o["sill"] + fr, o["head"] - fr)
        n_t = max(1, round(h / dl["row"]))
        for k in range(1, n_t):
            z = o["sill"] + h * k / n_t
            lites += parts(seg_box(a2, b2, dl["bar"]), z - dl["bar"] / 2, z + dl["bar"] / 2)
        rec["lites"] = rec.get("lites", 0) + (n_m - 1) + (n_t - 1)
    emit("base", "glass", "recessed_glazing", panes, windows=len(rec["recessed_windows"]))
    emit("base", "steel", "window_frames", frames, windows=rec["frames"])
    emit("base", "steel", "window_lites", lites, bars=rec.get("lites", 0))

    # ---------- V7.1: semicircular heads on the courtyard enclosure windows: the spandrel plate (wall thickness) above the springing and the arched frame ----------
    aw = C["arched_windows"]
    spandrels, arch_frames = [], []
    rec["arched_windows"] = []
    for w in aw["windows"]:
        i, o = match_window(w["floor"], w["at"])
        a, b = tuple(o["a"]), tuple(o["b"])
        (ux, uy), L = unit(a, b)
        n = (uy, -ux)
        t = wall_t(a, b)
        crown = o["head"]
        spring = crown - L / 2
        prof = box(0, spring, L, crown).difference(disc((L / 2, spring), L / 2, 32))
        spandrels += panel(a, b, n, -t / 2, t, prof)
        f = aw["frame"]
        ring = disc((L / 2, spring), L / 2, 32).difference(disc((L / 2, spring), L / 2 - f, 32)).intersection(box(0, spring, L, crown))
        arch_frames += panel(a, b, n, -f / 2, f, ring)
        rec["arched_windows"].append({"label": w["label"], "at": w["at"], "width": round(L, 3), "sill": o["sill"], "springing": round(spring, 3), "crown": crown, "wall_above": round(STRUCT_TOP["roof"] - 0.45 - crown, 3)})
    emit("base", "plaster", "arch_spandrels", spandrels, windows=len(aw["windows"]))
    # V10.0 (L5): the blind arches: no opening in the wall; the arched surround proud of the courtyard face and a recessed-looking panel inside it (render and paint)
    rec["blind_arches"] = []
    b_sur, b_pan = [], []
    for w in aw.get("blind", []):
        x0, y0, x1, y1 = [float(v) for v in w["at"].split()]
        a, b = (x0, y0), (x1, y1)
        (ux, uy), L = unit(a, b)
        n = (uy, -ux)
        t = wall_t(a, b)
        sill, crown, sw = w["sill"], w["crown"], w.get("surround", 0.10)
        spring = crown - L / 2
        shape = box(0, sill, L, spring).union(disc((L / 2, spring), L / 2, 32)).intersection(box(0, sill, L, crown))
        inner = box(sw, sill + sw, L - sw, spring).union(disc((L / 2, spring), L / 2 - sw, 32)).intersection(box(sw, sill + sw, L - sw, crown))
        b_sur += panel(a, b, n, t / 2, 0.04, shape.difference(inner))
        b_pan += panel(a, b, n, t / 2 - 0.03, 0.03, inner)
        rec["blind_arches"].append({"label": w["label"], "at": w["at"], "width": round(L, 3), "sill": sill, "springing": round(spring, 3), "crown": crown})
    emit("base", "honey", "blind_arch_surround", b_sur, arches=len(aw.get("blind", [])))
    emit("base", "plaster", "blind_arch_panel", b_pan, arches=len(aw.get("blind", [])))
    emit("base", "steel", "arch_frames", arch_frames, windows=len(aw["windows"]))

    # ---------- mashrabiya screens: a timber lattice in the reveal, flush with the face ----------
    ms = C["mashrabiya"]
    for k, w in enumerate(ms["windows"]):
        i, o = match_window(w["floor"], w["at"])
        a, b = tuple(o["a"]), tuple(o["b"])
        (ux, uy), L = unit(a, b)
        t = T_OUT if o["wall"].endswith("_outer") else T_IN
        n = outward(a, b) if o["wall"].endswith("_outer") else tuple(float(v) for v in w["side"])
        if abs(n[0] * ux + n[1] * uy) > 1e-6:
            raise SystemExit(f"ERROR: mashrabiya side {w['side']} is not normal to the window {w['at']}")
        z0, z1 = o["sill"], o["head"]
        h = z1 - z0
        f, s, (px, pz) = ms["frame"], ms["slat"], ms["pitch"]
        bars = [box(0, z0, L, z0 + f), box(0, z1 - f, L, z1), box(0, z0, f, z1), box(L - f, z0, L, z1)]   # the frame
        x = f + px
        while x < L - f - s / 2:                                        # vertical slats
            bars.append(box(x - s / 2, z0, x + s / 2, z1))
            x += px
        z = z0 + f + pz
        while z < z1 - f - s / 2:                                       # horizontal slats
            bars.append(box(0, z - s / 2, L, z + s / 2))
            z += pz
        lattice = unary_union(bars)
        name = emit("base", "timber", f"mashrabiya_{k:02d}", panel(a, b, n, t / 2 - ms["depth"], ms["depth"], lattice), window=o["name"], floor=o["floor"], why=w["why"])
        rec["mashrabiya"].append({"name": name, "floor": o["floor"], "window": o["name"], "at": w["at"], "why": w["why"], "width": round(L, 3), "height": round(h, 3), "face_offset": round(t / 2, 4)})

    # ---------- feature walls: the honey-tone render on selected faces (V10.0: no stone), the openings cut out ----------
    fw = C["feature_walls"]
    for k, w in enumerate(fw["walls"]):
        x1, y1, x2, y2 = (float(v) for v in w["line"].split())
        a, b, n = (x1, y1), (x2, y2), tuple(float(v) for v in w["side"])
        (ux, uy), L = unit(a, b)
        t = wall_t(a, b)
        z0, z1 = w["z"]
        prof = box(0, z0, L, z1)
        cut = []
        for s0, s1, sill, head, o in openings_on(a, b):
            cut.append(box(s0, sill, s1, head))
        prof = prof.difference(unary_union(cut)) if cut else prof
        name = emit("base", "honey", f"feature_wall_{k:02d}", panel(a, b, n, t / 2, fw["thickness"], prof), wall=w["name"], openings=len(cut))
        rec["feature_walls"].append({"name": name, "wall": w["name"], "line": w["line"], "z": w["z"], "openings_cut": len(cut), "area": round(prof.area, 2)})

    # ---------- the colonnade: rendered sleeves Ø0.40 round C21–C23 with plain base and capital bands ----------
    cl = C["colonnade"]
    cols = column_points()
    sleeves = []
    for cid, (x, y) in cols.items():
        r = cl["diameter"] / 2
        meshes = parts(disc((x, y), r), gf, roof_under)
        meshes += parts(disc((x, y), cl["base"]["diameter"] / 2), gf, gf + cl["base"]["height"])
        for top in (soffit_bottom, roof_under):
            meshes += parts(disc((x, y), cl["capital"]["diameter"] / 2), top - cl["capital"]["height"], top)
        sleeves.append(emit("base", "honey", f"column_{cid}", meshes, column=cid, diameter=cl["diameter"]))
        rec["sleeves"].append({"column": cid, "x": x, "y": y, "diameter": cl["diameter"], "structural": COLS[cid]["size"], "z0": gf, "z1": roof_under})
    col_holes = unary_union([disc(c, cl["diameter"] / 2 + 0.005) for c in cols.values()])

    # ---------- V7.1: the courtyard arcade: two intermediate rendered columns on the colonnade line and three semicircular arches under the soffit (courtyard bay only) ----------
    ac = C["arcade"]
    y_c21, y_c22 = cols["C21"][1], cols["C22"][1]
    ac_cols = []
    for k, y in enumerate(ac["columns"]["at_y"]):
        r_ = ac["columns"]["diameter"] / 2
        meshes = parts(disc((PROJ_X, y), r_), gf, soffit_bottom)
        meshes += parts(disc((PROJ_X, y), ac["columns"]["base"]["diameter"] / 2), gf, gf + ac["columns"]["base"]["height"])
        meshes += parts(disc((PROJ_X, y), ac["columns"]["capital"]["diameter"] / 2), soffit_bottom - ac["columns"]["capital"]["height"], soffit_bottom)
        emit("base", "honey", f"arcade_column_{k}", meshes, at=[PROJ_X, y], diameter=ac["columns"]["diameter"])
        ac_cols.append(y)
    faces = [y_c21 + cl["diameter"] / 2] + [v for y in ac_cols for v in (y - ac["columns"]["diameter"] / 2, y + ac["columns"]["diameter"] / 2)] + [y_c22 - cl["diameter"] / 2]
    bays = [(faces[2 * k], faces[2 * k + 1]) for k in range(len(ac_cols) + 1)]
    arches, arch_rec = [], []
    for y0, y1 in bays:
        span = y1 - y0
        spring = soffit_bottom - span / 2
        prof = box(0, spring, span, soffit_bottom).difference(disc((span / 2, spring), span / 2, 32))
        arches += panel((PROJ_X, y0), (PROJ_X, y1), (1.0, 0.0), -ac["arch"]["thickness"] / 2, ac["arch"]["thickness"], prof)
        arch_rec.append({"y": [round(y0, 4), round(y1, 4)], "span": round(span, 3), "springing": round(spring, 3), "crown": round(soffit_bottom, 3)})
    emit("base", "plaster", "arcade_arches", arches, bays=len(bays))
    col_holes = col_holes.union(unary_union([disc((PROJ_X, y), ac["columns"]["diameter"] / 2 + 0.005) for y in ac_cols]))
    rec["arcade"] = {"columns": [[PROJ_X, y] for y in ac_cols], "diameter": ac["columns"]["diameter"], "bays": arch_rec, "structural": ac["structural"], "bay_axes": round((y_c22 - y_c21) / (len(ac_cols) + 1), 4)}

    # ---------- the timber soffit under the projection and the fascia on its edge (the slab edge and the upturned beam) ----------
    b3 = BEAMS["B3"]
    so = C["soffit"]
    y0, y1 = min(b3["a"][1], b3["b"][1]) + T_IN / 2, max(b3["a"][1], b3["b"][1]) - T_IN / 2
    riwaq_x = PROJ_X - P["projection"]["width"] + T_IN / 2                 # the face of the first-floor west rooms' wall (x 4.25)
    edge_x = PROJ_X + b3["w"] / 2
    emit("base", "timber", "soffit", parts(box(riwaq_x, y0, edge_x, y1).difference(col_holes), soffit_bottom, ff_under), z=[soffit_bottom, ff_under])
    emit("base", "timber", "fascia", parts(box(edge_x, y0, edge_x + so["fascia"], y1).difference(col_holes), soffit_bottom, b3_top), z=[soffit_bottom, b3_top])

    # ---------- V7.0: the quoins at the outer corners, formed in the structure and rendered in the honey tone (V10.0: no stone) ----------
    qn = C["quoins"]
    quoins = []
    for a, b in zip(OUTLINE, OUTLINE[1:] + OUTLINE[:1]):
        (ux, uy), L = unit(a, b)
        n = outward(a, b)
        for p, sgn in ((a, 1), (b, -1)):
            q0, q1 = shift(p, n, T_OUT / 2), shift(shift(p, n, T_OUT / 2), (ux, uy), sgn * qn["width"])
            quoins += parts(seg_box(q0, q1, qn["thickness"] * 2).intersection(outer_face.buffer(qn["thickness"], join_style=2).difference(outer_face)), gf + C["plinth"]["height"], qn["top"])
    emit("base", "honey", "quoins", quoins, corners=len(OUTLINE))

    # ---------- pergola: timber beams over part of the courtyard sky, on the roof finish ----------
    pg = C.get("pergola")                 # removed by the owner (1 Nov 2026, studies/courtyard_layout.typ): the block is absent from character.yaml
    if pg:
        cx0, cy0, cx1, cy1 = COURT_SKY.bounds
        w, d = pg["section"]
        ys, y = [], pg["over_y"][0] + pg["spacing"] / 2
        while y <= pg["over_y"][1] - w / 2 + EPS:
            ys.append(round(y, 4))
            y += pg["spacing"]
        beams = [box(cx0 - pg["bearing"], y - w / 2, cx1 + pg["bearing"], y + w / 2) for y in ys]
        emit("pergola", "timber", "beams", parts(unary_union(beams), roof_fin, roof_fin + d), beams=len(ys))
        covered = unary_union(beams).intersection(COURT_SKY).area
        rec["pergola"] = {"beams": len(ys), "y": ys, "section": pg["section"], "spacing": pg["spacing"], "over_y": pg["over_y"], "z": [roof_fin, roof_fin + d],
                          "sky_covered_share": round(covered / COURT_SKY.area, 3), "default": pg["default"]}
    else:
        rec["pergola"] = {"beams": 0, "y": [], "section": None, "spacing": None, "over_y": None, "z": None, "sky_covered_share": 0.0, "default": False, "note": "no pergola (owner, 1 Nov 2026)"}

    # ---------- roof: black steel bar guards round the two roof holes (the parapets, the cornice and the attic are base-model meshes since V7.0) ----------
    rl = P["roof_design"]["guard"]
    attic_wall = wkt_loads(summary["roof_design"]["attic"]["line_wkt"])
    attic_wall = attic_wall.difference(attic_wall.buffer(-P["roof_design"]["attic"]["thickness"] - 0.02, join_style=2)).buffer(0.02)
    rails = []

    def guard_line(pts):
        out = []
        for p, q in zip(pts, pts[1:]):
            strip = seg_box(p, q, rl["bar"]).difference(attic_wall)
            out += parts(strip, roof_fin + rl["height"] - rl["bar"], roof_fin + rl["height"]) + parts(strip, roof_fin + rl["height"] / 2 - rl["bar"] / 2, roof_fin + rl["height"] / 2 + rl["bar"] / 2)
            (ux, uy), L = unit(p, q)
            n = max(1, math.ceil(L / rl["post_spacing"]))
            for k in range(n + 1):
                c = (p[0] + ux * L * k / n, p[1] + uy * L * k / n)
                out += parts(box(c[0] - rl["bar"] / 2, c[1] - rl["bar"] / 2, c[0] + rl["bar"] / 2, c[1] + rl["bar"] / 2).difference(attic_wall), roof_fin, roof_fin + rl["height"])
        return out

    hx0, hy0, hx1, hy1 = COURT_SKY.bounds
    rails += guard_line([(hx0 - 0.07, hy0 - 0.07), (hx1 + 0.07, hy0 - 0.07), (hx1 + 0.07, hy1 + 0.07), (hx0 - 0.07, hy1 + 0.07), (hx0 - 0.07, hy0 - 0.07)])
    for line in C["suite_court_v2"]["guards"]:                 # V8.0: on the gym roof / nib edge and the office roof edge (the north edge is the attic wall, the south the parapet on R8)
        rails += guard_line([tuple(p) for p in line])
    rails = [m for m in rails if m is not None]
    emit("base", "steel", "roof_railings", rails, height=rl["height"])
    rec["roof_guards"] = {"height": rl["height"], "holes": ["courtyard sky", "suite court v2 (the gym roof / nib edge and the office roof edge; the north edge is the attic wall, the south the parapet on R8)"]}

    # V10.0 (L5): the malqaf head has no louvre slats: its slender arched slots are the openings (build_3d.py), the bird mesh behind them is not modelled
    rec["malqaf_louvres"] = None

    # ---------- the wall fountain: a simple shape on the courtyard's east wall under the kitchen sink window (the malqaf grille is north of it) ----------
    ft = C.get("fountain")               # SUPERSEDED (1 Nov 2026): the courtyard water basin is in the north enclosure (character.yaml courtyard_layout); the block is absent, the builder update is pending
    if ft:
        ft = C["fountain"]
        x1, y1, x2, y2 = (float(v) for v in ft["wall"].split())
        wa, wb, n = (x1, y1), (x2, y2), tuple(float(v) for v in ft["side"])
        (ux, uy), _ = unit(wa, wb)
        axis = 1 if abs(uy) > abs(ux) else 0                       # the plan coordinate that runs along the wall
        face = wall_t(wa, wb) / 2 + fw["thickness"]                # on the rendered face

        def wall_box(v0, v1, d0, d1):
            """A plan rectangle on the wall: v0–v1 along it (plan coordinates), d0–d1 out from its centre line along n."""
            s0, s1 = v0 - wa[axis], v1 - wa[axis]
            return Polygon([(wa[0] + ux * s + n[0] * d, wa[1] + uy * s + n[1] * d) for s, d in ((s0, d0), (s1, d0), (s1, d1), (s0, d1))])

        emit("base", "honey", "fountain_panel", parts(wall_box(ft["along"][0], ft["along"][1], face, face + ft["thickness"]), gf + ft["z"][0], gf + ft["z"][1]), along=ft["along"], z=ft["z"])
        bs, d0 = ft["basin"], face + ft["thickness"]
        outer = wall_box(bs["along"][0], bs["along"][1], d0, d0 + bs["depth"])
        inner = wall_box(bs["along"][0] + 0.06, bs["along"][1] - 0.06, d0, d0 + bs["depth"] - 0.06)
        emit("base", "honey", "fountain_basin", parts(outer, gf + bs["z"][0], gf + bs["z"][0] + 0.05) + parts(outer.difference(inner), gf + bs["z"][0] + 0.05, gf + bs["z"][1]))
        sp = ft["spout"]
        emit("base", "bronze", "fountain_spout", parts(wall_box(sp["along"][0], sp["along"][1], d0, d0 + sp["depth"]), gf + sp["z"][0], gf + sp["z"][1]))
        sink = next((o for o in summary["openings"] if o["floor"] == "GF" and "kitchen sink" in o["name"]), None)
        _, gy0, gy1, gz0, gz1 = AIR["outlet"]   # V10.0: the malqaf's outlet in the first arcade arch (x 5.8)
        rec["fountain"] = {"wall": ft["wall"], "along": ft["along"], "z": ft["z"], "basin_z": bs["z"], "grille_y": [gy0, gy1],
                           "clear_of_grille": round(ft["along"][0] - gy1, 3), "below_sink_sill": round(sink["sill"] - FINISHED["GF"] - ft["z"][1], 3) if sink else None,
                           "note": "decorative shape under the sink window; its water and drain are air items A8 / A6"}
    else:
        rec["fountain"] = None

    # ---------- 3 Nov 2026 · the courtyard layout REVISED (studies/courtyard_layout.typ, owner): the whole floor LEVEL (the base model's courtyard floor stays, no step, no benches),
    # movable furniture (group "sunken" = the layout toggle in the viewer), the enclosure (water + tree) on the kitchen wall in front of the sink window, the outdoor TV south of it
    # with its rendered surround (V10.0: the malqaf outlet in the west arcade), the linear drains and the overflow ----------
    cly = C["courtyard_layout"]
    court_floor = g["COURT_FLOOR"]
    zf = gf + cly["floor"]
    for k, (x0, y0, x1, y1, kind) in enumerate(cly["furniture"]):
        bx_ = box(x0, y0, x1, y1)
        if kind in ("sofa", "armchair"):
            emit("sunken", "timber", f"court_{kind}_{k}", parts(bx_, zf, zf + 0.32) + parts(box(x0, y0, x0 + 0.12, y1), zf + 0.32, zf + 0.75))   # the back on the west side: it faces the TV on the east wall
            emit("sunken", "sand", f"court_{kind}_cushion_{k}", parts(bx_.buffer(-0.04), zf + 0.32, zf + 0.42))
        else:
            emit("sunken", "honey", f"court_table_{k}", parts(bx_, zf + 0.35, zf + 0.40) + parts(bx_.buffer(-0.12), zf, zf + 0.35))
    dr = cly["drainage"]
    for k, (x0, y0, x1, y1) in enumerate(dr["linear_drains"]):
        emit("sunken", "bronze", f"linear_drain_{k}", parts(box(x0, y0, x1, y1), zf - 0.012, zf + 0.003), box=[x0, y0, x1, y1])
    emit("sunken", "bronze", "overflow", parts(box(dr["overflow_at"][0] - 0.08, dr["overflow_at"][1] - 0.08, dr["overflow_at"][0] + 0.08, dr["overflow_at"][1] + 0.08), zf - 0.01, zf + 0.005), at=dr["overflow_at"])
    # the outdoor TV and its rendered surround on the courtyard face of the kitchen wall (base model)
    tvd, fr_ = cly["tv"], cly["tv_frame"]
    x1_, y1_, x2_, y2_ = (float(v) for v in tvd["wall"].split())
    wa, wb, nw = (x1_, y1_), (x2_, y2_), (-1.0, 0.0)
    face = T_IN / 2 + fw["thickness"]
    emit("base", "bronze", "outdoor_tv", panel(wa, wb, nw, face, 0.05, box(tvd["y"][0] - wa[1], gf + tvd["z"][0], tvd["y"][1] - wa[1], gf + tvd["z"][1])), y=tvd["y"], z=tvd["z"])
    c_ = (tvd["y"][0] + tvd["y"][1]) / 2 - wa[1]
    hw, jz0, jz1 = fr_["inner_width"] / 2, gf + fr_["jamb_z"][0], gf + fr_["jamb_z"][1]
    prof = box(c_ - hw - fr_["band"], jz0, c_ - hw, jz1).union(box(c_ + hw, jz0, c_ + hw + fr_["band"], jz1))
    prof = prof.union(disc((c_, jz1), fr_["radius"] + fr_["band"], 32).difference(disc((c_, jz1), fr_["radius"], 32)).intersection(box(c_ - 3, jz1, c_ + 3, jz1 + 3)))
    tv_crown = jz1 + fr_["radius"] + fr_["band"]
    emit("base", "honey", "tv_surround", panel(wa, wb, nw, face, fr_["proj"], prof), crown=round(tv_crown, 3))
    # the enclosure on the kitchen wall in front of the sink window: the planter (rim +0.45) in the north part with the tree, the RAISED water trough (rim +0.95) in the south part, the pump chamber between
    en = cly["enclosure"]
    ebox = box(*en["box"]).intersection(court_floor)
    w_in, p_in, pump = box(*en["water"]["inside"]), box(*en["planter"]["inside"]), box(*en["pump_cover"])
    rim, wrim = gf + en["rim"], gf + en["water"]["rim"]
    water_part = box(en["box"][0], en["water"]["inside"][1] - en["wall"], en["box"][2], en["box"][3]).intersection(ebox)
    emit("base", "honey", "enclosure_walls", parts(ebox.difference(water_part).difference(p_in), gf, rim) + parts(water_part.difference(w_in), gf, wrim), rim=en["rim"], water_rim=en["water"]["rim"])
    wl = gf + en["water"]["level"]
    emit("base", "honey", "basin_floor", parts(w_in, gf, wl - en["water"]["depth"]))
    emit("base", "water", "basin_water", parts(w_in, wl - en["water"]["depth"], wl), level=en["water"]["level"])
    emit("base", "bronze", "pump_cover", parts(pump, rim - 0.03, rim))
    emit("base", "bronze", "basin_lip", parts(box(w_in.bounds[2] - 0.06, w_in.bounds[1] + 0.1, w_in.bounds[2], w_in.bounds[3] - 0.1), gf + en["water"]["spout_z"] - 0.02, gf + en["water"]["spout_z"]))   # the laminar lip on the wall side
    soil_top = rim - 0.10
    emit("base", "trunk", "planter_soil", parts(p_in, rim - en["planter"]["depth"], soil_top))
    tr_ = en["tree"]
    tc = ((p_in.bounds[0] + p_in.bounds[2]) / 2, (p_in.bounds[1] + p_in.bounds[3]) / 2)
    emit("base", "trunk", "tree_stem", parts(disc(tc, 0.07, 8), soil_top, gf + tr_["stem"] + 0.4))
    crown = trimesh.creation.icosphere(subdivisions=2, radius=tr_["crown_radius"])
    crown.apply_translation([tc[0], tc[1], gf + tr_["crown_centre"]])
    emit("base", "foliage", "tree_crown", [crown], at=list(tc))
    _, gy0, gy1, gz0, gz1 = AIR["outlet"]   # V10.0: the malqaf's outlet in the first arcade arch (x 5.8)
    court_in = court_floor.bounds
    sz = cly["seating_zone"]
    rec["courtyard"] = {"default": True, "replaces": [], "level": True, "floor": cly["floor"], "seating_zone": sz, "furniture": len(cly["furniture"]),
                        "tv": {"y": tvd["y"], "z": tvd["z"]}, "tv_crown": round(tv_crown, 3), "grille": {"y": [gy0, gy1], "z": [gz0, gz1]},
                        "enclosure": {"box": en["box"], "rim": en["rim"], "water_rim": en["water"]["rim"], "water_level": en["water"]["level"]}, "sink_window": cly["sink_window"],
                        "tree": {"at": list(tc), "crown_centre": tr_["crown_centre"], "radius": tr_["crown_radius"]},
                        "overflow": dr["overflow_at"], "linear_drains": dr["linear_drains"],
                        "level_edges": {"north": round(en["box"][1] - court_in[1], 3), "south": round(court_in[3] - sz[3], 3), "west": round(sz[0] - court_in[0], 3)}}
    rec["flags"].append("Courtyard layout (3 Nov 2026, owner, studies/courtyard_layout.typ): the whole floor LEVEL with gentle falls to linear drains (no step, no benches); movable modern furniture for 4–6 "
                        "(a sofa, two armchairs, a low table) facing the outdoor TV (+%.2f … +%.2f) in its rendered surround on the kitchen wall; V10.0: the malqaf's breeze outlet (+%.2f … +%.2f) in the first arcade arch opposite, on the seating's west side; the enclosure "
                        "(a planter with the tree, rim +%.2f, and a raised water trough, rim +%.2f) on the kitchen wall in front of the sink window as the view from the sink; the north side in front of the women's majlis glass freed"
                        % (tvd["z"][0], tvd["z"][1], gz0, gz1, en["rim"], en["water"]["rim"]))

    # ---------- V8.0 · the suite court (south wing v2): its outdoor furniture (seating for five, a table, plants) on the first floor ----------
    sc = C["suite_court_v2"]
    ffz = FINISHED["FF"]
    for k, (x0, y0, x1, y1, kind) in enumerate(sc["furniture"]):
        bx_ = box(x0, y0, x1, y1)
        if kind in ("sofa", "armchair"):
            emit("props", "timber", f"court_{kind}_{k}", parts(bx_, ffz, ffz + 0.32) + parts(box(x0, y1 - 0.12, x1, y1) if kind == "sofa" else box(x0, y0, x1, y0 + 0.12), ffz + 0.32, ffz + 0.75))
            emit("props", "sand", f"court_{kind}_cushion_{k}", parts(bx_.buffer(-0.04), ffz + 0.32, ffz + 0.42))
        elif kind == "table":
            emit("props", "honey", f"court_table_{k}", parts(bx_, ffz + 0.40, ffz + 0.45) + parts(bx_.buffer(-0.15), ffz, ffz + 0.40))
        else:
            emit("props", "honey", f"court_pot_{k}", parts(bx_, ffz, ffz + (0.6 if kind == "tree" else 0.45)))
            leaf_ = trimesh.creation.icosphere(subdivisions=1, radius=0.55 if kind == "tree" else 0.32)
            leaf_.apply_translation([(x0 + x1) / 2, (y0 + y1) / 2, ffz + (1.9 if kind == "tree" else 0.85)])
            emit("props", "foliage", f"court_plant_{k}", [leaf_])
            if kind == "tree":
                emit("props", "trunk", f"court_tree_stem_{k}", parts(disc(((x0 + x1) / 2, (y0 + y1) / 2), 0.05, 6), ffz + 0.6, ffz + 1.5))
    rec["suite_court"] = {"furniture": len(sc["furniture"]), "guards": sc["guards"]}

    # ---------- the hanging lanterns (point lights in the night view) ----------
    la = C["props"]["lanterns"]
    lw, ld, lh = la["size"]
    lights = []
    for k, (x, y) in enumerate(la["at"]):
        z1 = soffit_bottom - la["drop"]
        emit("light", "brass", f"lantern_rod_{k}", parts(disc((x, y), 0.01, 4), z1, soffit_bottom))
        emit("light", "lantern", f"lantern_{k}", parts(box(x - lw / 2, y - ld / 2, x + lw / 2, y + ld / 2), z1 - lh, z1), at=[x, y])
        lights.append([x, y, round(z1 - lh / 2, 3)])
    rec["lanterns"] = lights

    # ---------- V6.3: the TV wall: the living's solid west wall (x 4.25, y 13–19.25) with the arched entrance and the arched TV niche ----------
    tw = C["tv_wall"]
    wx = 4.25 + T_IN / 2                                                    # the wall's living face
    x1_, y1_, x2_, y2_ = (float(v) for v in tw["entrance"]["at"].split())
    ea, eb = (x1_, y1_), (x2_, y2_)
    ew = abs(y2_ - y1_)
    e_head = gf + tw["entrance"]["head"]
    spring = e_head - ew / 2                                                 # a semicircular head
    prof = box(0, spring, ew, e_head).difference(disc((ew / 2, spring), ew / 2, 24))
    emit("base", "plaster", "entrance_arch_head", panel(ea, eb, (1.0, 0.0), -T_IN / 2, T_IN, prof), width=ew, head=tw["entrance"]["head"], springing=round(spring - gf, 3))
    ni, pr = tw["niche"], tw["pier"]
    emit("base", "plaster", "tv_pier", parts(box(wx, pr["y"][0], wx + ni["depth"], pr["y"][1]), gf, soffit_bottom))
    n_w = ni["y"][1] - ni["y"][0]
    c, h = n_w / 2, ni["rise"]
    rho = (c * c + h * h) / (2 * h)
    n_spring = gf + ni["head"] - h
    arch = box(ni["y"][0], n_spring, ni["y"][1], soffit_bottom).difference(disc((ni["y"][0] + c, n_spring + h - rho), rho, 48).intersection(box(ni["y"][0], n_spring, ni["y"][1], soffit_bottom)))
    frame = panel((wx + ni["depth"] - 0.1, 0.0), (wx + ni["depth"] - 0.1, 1.0), (1.0, 0.0), 0.0, 0.1, arch)   # the arched face plate at the niche front, 0.1 thick
    frame += parts(box(wx, ni["y"][0], wx + ni["depth"], ni["y"][1]), gf + ni["head"], soffit_bottom)       # the niche soffit above the arch's crown
    emit("base", "plaster", "tv_niche_frame", frame, width=n_w, depth=ni["depth"], head=ni["head"])
    cb, tv_, sh = tw["cabinet"], tw["tv"], tw["shelves"]
    emit("base", "timber", "tv_cabinet", parts(box(wx, cb["y"][0], wx + cb["depth"], cb["y"][1]), gf, gf + cb["height"]))
    tv_c = (ni["y"][0] + ni["y"][1]) / 2
    emit("base", "bronze", "tv_screen", parts(box(wx + 0.01, tv_c - tv_["width"] / 2, wx + 0.08, tv_c + tv_["width"] / 2), gf + tv_["bottom"], gf + tv_["bottom"] + tv_["height"]), size=[tv_["width"], tv_["height"]])
    emit("base", "timber", "tv_shelves", parts(box(wx, ni["y"][0], wx + sh["depth"], cb["y"][0]), gf, gf + sh["height"]) + parts(box(wx, cb["y"][1], wx + sh["depth"], ni["y"][1]), gf, gf + sh["height"]))
    eye_x = tw["sofa_back_x"] - 0.55
    rec["tv_wall"] = {"entrance_head": tw["entrance"]["head"], "entrance_width": ew, "niche_width": round(n_w, 3), "niche_depth": ni["depth"], "niche_head": ni["head"], "niche_springing": round(n_spring - gf, 3),
                      "sofa_back_x": tw["sofa_back_x"], "eye_to_screen": round(eye_x - (wx + 0.08), 3), "path_north": round(15.0 - (13.0 + T_IN / 2), 3), "tv_centre_y": tv_c}
    rec["flags"].append("TV wall (V6.3, owner): the living's west wall solid and full height with the 1.40 m entrance arch (head +%.2f) and the arched TV niche %.2f × %.2f m (crown +%.2f); eye-to-screen %.2f m from a sofa with its back at x %.2f; no arches between the colonnade columns" % (tw["entrance"]["head"], n_w, ni["depth"], ni["head"], eye_x - (wx + 0.08), tw["sofa_back_x"]))
    rec["flags"].append("Character study (3d/character.yaml): STYLE STUDY, PROVISIONAL (V10.0: NO stone: the honey-tone render, sand and plaster, porcelain floors, timber, bronze as flat colours); plinth, deep reveals, mashrabiya, "
                        "rendered sleeves Ø%g on the assumed Ø0.30 colonnade, timber soffit, props; V8.0: the courtyard layout (the seating one step down, the TV wall, the water and tree enclosure, no pergola), the suite court furniture; V7.0: the design language (cream plaster, the honey-tone render, black steel "
                        "divided-lite windows, walnut), the quoins, the roof guards; V7.1: the courtyard arcade (two Ø%g rendered columns, three semicircular arches under the projection, decorative) "
                        "and semicircular heads on the enclosure windows W1–W3; the living bay keeps no arches (owner, V6.3)" % (cl["diameter"], C["arcade"]["columns"]["diameter"]))
    # ---------- V8.2 · the suite court's south side: the mashrabiya screen (owner, 2 Nov 2026: option b adopted) on the 1.10 base up to the frame soffit ----------
    ssd = sc["south_side"]
    if ssd.get("chosen") == "b":
        scn = ssd["screen"]
        sx0, sx1 = P["suite_court"]["south_x"]
        ya_ = OUTLINE[3][1]                                               # the south wall's centre line (y 24.0)
        a_, b_ = (sx0 + T_IN / 2, ya_), (sx1 - T_IN / 2, ya_)
        z0_, z1_ = summary["suite_court"]["base_top"], summary["suite_court"]["frame_soffit"]
        (ux_, uy_), L_ = unit(a_, b_)
        f_, s_, (px_, pz_) = scn["frame"], scn["slat"], scn["pitch"]
        bars_ = [box(0, z0_, L_, z0_ + f_), box(0, z1_ - f_, L_, z1_), box(0, z0_, f_, z1_), box(L_ - f_, z0_, L_, z1_)]
        x_ = f_ + px_
        while x_ < L_ - f_ - s_ / 2:
            bars_.append(box(x_ - s_ / 2, z0_, x_ + s_ / 2, z1_)); x_ += px_
        z_ = z0_ + f_ + pz_
        while z_ < z1_ - f_ - s_ / 2:
            bars_.append(box(0, z_ - s_ / 2, L_, z_ + s_ / 2)); z_ += pz_
        lattice_ = unary_union(bars_)
        open_frac = 1 - lattice_.area / (L_ * (z1_ - z0_))
        name_ = emit("base", "timber", "court_screen", panel(a_, b_, (0.0, 1.0), T_OUT / 2 - scn["depth"], scn["depth"], lattice_), width=round(L_, 3), z=[round(z0_, 3), round(z1_, 3)], open=round(open_frac, 2))
        rec["court_screen"] = {"name": name_, "x": [a_[0], b_[0]], "y": ya_, "z": [round(z0_, 3), round(z1_, 3)], "open": round(open_frac, 2), "material": scn["material"]}
        rec["flags"].append("Suite court south side (V8.2, owner 2 Nov 2026): a mashrabiya screen (timber or black steel lattice) on the 1.10 base from +%.2f to the frame soffit +%.2f, %.2f m wide, %d %% open: the palms seen out, no view in" % (z0_, z1_, L_, round(open_frac * 100)))

    # ---------- V8.2 · the coat cupboard in the west half of the stair's start strip (stair flip, design_gf.typ inner boxes) ----------
    cc = C.get("coat_cupboard")
    if cc:
        emit("props", "timber", "coat_cupboard", parts(box(*cc["box"]), gf, gf + cc["height"]), box=cc["box"], height=cc["height"])
        rec["coat_cupboard"] = {"box": cc["box"], "height": cc["height"]}

    # ---------- V8.2 · the site elements (studies/site_plan.typ, STUDY: every position proposed): paths, the garden, its wall, the hedge, the yard screen, the gas cabinet, the parking bay ----------
    st_site = C.get("site")
    if st_site:
        shx, shy = st_site["shift"]
        c_ = lambda p: (p[0] - shx, p[1] - shy)
        ground_ = C["plinth"]["ground"]
        rec["site"] = []
        for el in st_site["elements"]:
            kind, lab, mat = el["kind"], el["label"], el["material"]
            if kind == "path":
                pts_ = [c_(p) for p in el["pts"]]
                poly_ = unary_union([seg_box(p, q, el["width"]) for p, q in zip(pts_, pts_[1:])] + [Point(p).buffer(el["width"] / 2, resolution=6) for p in pts_[1:-1]])
                meshes_ = parts(poly_, ground_ - 0.005, ground_ + 0.03)
            elif kind == "slab":
                meshes_ = parts(Polygon([c_(p) for p in el["pts"]]), ground_ - 0.01, ground_ + 0.012)
            elif kind in ("wall", "hedge"):
                pts_ = [c_(p) for p in el["pts"]]
                poly_ = unary_union([seg_box(p, q, el["width"]) for p, q in zip(pts_, pts_[1:])])
                meshes_ = parts(poly_, ground_, ground_ + el["height"])
            elif kind == "block":   # V9.0: an existing building as a plain mass (the old house from the deed sketch)
                meshes_ = parts(Polygon([c_(p) for p in el["pts"]]), ground_, ground_ + el["height"])
            elif kind == "canopy":   # V9.0: posts at the corners and a thin roof (the existing covered parking)
                x0_, y0_, x1_, y1_ = el["box"]
                x0_, y0_, x1_, y1_ = x0_ - shx, y0_ - shy, x1_ - shx, y1_ - shy
                meshes_ = parts(box(x0_, y0_, x1_, y1_), ground_ + el["height"] - 0.12, ground_ + el["height"])
                for px_, py_ in ((x0_, y0_), (x1_ - 0.12, y0_), (x0_, y1_ - 0.12), (x1_ - 0.12, y1_ - 0.12)):
                    meshes_ += parts(box(px_, py_, px_ + 0.12, py_ + 0.12), ground_, ground_ + el["height"] - 0.12)
            elif kind == "palm":   # V9.0: a trunk and a crown (the two palms of the v2 survey; heights assumed)
                px_, py_ = c_(el["at"])
                meshes_ = parts(Point(px_, py_).buffer(el["radius"], resolution=8), ground_, ground_ + el["height"])
                crown_ = trimesh.creation.icosphere(subdivisions=1, radius=el["crown"])
                crown_.apply_scale([1.0, 1.0, 0.45])
                crown_.apply_translation([px_, py_, ground_ + el["height"]])
                crown_.visual.vertex_colors = pal["foliage"]
                emit("site", "foliage", lab + "_crown", [crown_], kind="palm_crown", note=el.get("note", ""), existing=True)
            else:
                x0_, y0_, x1_, y1_ = el["box"]
                meshes_ = parts(box(x0_ - shx, y0_ - shy, x1_ - shx, y1_ - shy), ground_, ground_ + el["height"])
            n_ = emit("site", mat, lab, meshes_, kind=kind, note=el.get("note", ""), existing=bool(el.get("existing")))
            rec["site"].append({"name": n_, "label": lab, "kind": kind, "existing": bool(el.get("existing"))})
        rec["flags"].append("Site elements (V8.2, studies/site_plan.typ, STUDY): the driveway, the family, guest and workers' paths, the north parking bay (kept), the south family garden with its 1.2 m rendered wall and the 1.8 m hedge, the yard screen and the gas cabinet; every position proposed, to confirm with the survey and the engineers")
        rec["flags"].append("Existing farm (V9.0, data/site_v2.csv, studies/whole_farm.typ): the old house (a plain 3.8 m mass) and its annex from the deed sketch (± 1–3 m), the covered parking, the ground tank and the septic at their assumed positions, the north and lane walls on the deed line with the 4 m gate, the two palms (heights assumed): APPROXIMATE, to be measured on site")

    summary["character"] = {**rec, "enabled": True, "hide": hide, "palette": pal, "assign": C["assign"]}
    summary["flags"] += rec["flags"]

    # ---------- the viewer block ----------
    bm = {k: {"title": v["title"], "eye": [v["eye"][0], v["eye"][2], v["eye"][1]], "target": [v["target"][0], v["target"][2], v["target"][1]], "night": bool(v.get("night"))}
          for k, v in C["views"].items()}
    viewer = {"enabled": True, "note": C["note"], "palette": pal, "assign": C["assign"], "hide": hide, "hide_when_sunken": rec["courtyard"]["replaces"], "sun": C.get("sun", ""),
              "defaults": {"pergola": False, "sunken": True},
              "lights": [[x, z, y] for x, y, z in lights],
              "night": {"background": C["night"]["background"], "lights": [[x, z, y, i] for x, y, z, i in C["night"]["point_lights"]]},
              "tv_wall": rec["tv_wall"], "arcade": rec["arcade"], "arched_windows": rec["arched_windows"], "blind_arches": rec.get("blind_arches", []), "mashrabiya": [f"{m['floor']} {m['window']}: {m['why']}" for m in rec["mashrabiya"]],
              "bookmarks": bm}
    return viewer

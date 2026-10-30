"""character_3d.py · Taif / Palm House · 3D phase "character": simple architectural character for the model (STYLE STUDY, PROVISIONAL).
Called by build_3d.py after the model is built; reads 3d/character.yaml and the model's own data (openings, columns, beams, voids)
and adds the character meshes, named chr_<group>_<material>_<label> so the viewer can colour and toggle them:
  group base      stone plinth, feature-wall cladding, recessed outer-window glazing with bronze frames, mashrabiya screens, the
                  colonnade's stone sleeves (base and capital bands), the timber soffit and fascia under the projection, the roof
                  parapet with its coping and the roof railings, the malqaf head's timber louvres, the courtyard fountain pier
  (V7.0: the gallery railing variants are gone: the gallery edge is the wall with the steel window W1; the roof parapets, the cornice,
  the attic and the stair room are base-model meshes of build_3d.py, re-coloured here; the windows get black steel frames and divided lites)
  group pergola   timber beams over the north part of the courtyard sky (toggle)
  (V6.3: the arches variant is removed, the owner wants no arches between the colonnade columns; the group base now also holds the
  living's TV wall: the entrance arch head, the arched TV niche with its pier, cabinet, TV and shelves)
  group sunken    the sunken seating (variant, default on): the courtyard floor with a pit 0.45 deep against the east wall under the
                  malqaf grille, three steps, a built-in bench, a table, the drain and overflow, the grille's upstand, an olive in a planter;
                  it replaces the base model's courtyard floor meshes gf_slab_court / gf_finish_court while it is on
  group light     the hanging lanterns (point lights in the night view)
Existing meshes are not changed here: the viewer re-colours them by name (character.yaml `assign`) when the character is on and
hides the few they replace (the outer windows' centre-line glass). Nothing is edited by hand: change character.yaml
and run build_3d.py again. Nothing here is a design decision; the structure keeps its assumed sizes underneath (the Ø0.30 columns
inside the Ø0.40 stone sleeves).
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

    # ---------- plinth: a stone base course around the outside, the doors cut through it ----------
    pl = C["plinth"]
    plinth = outer_face.buffer(pl["thickness"], join_style=2).difference(outer_face)
    for o in summary["openings"]:
        if o["kind"] == "door" and o["wall"].endswith("_outer"):
            plinth = plinth.difference(seg_box(o["a"], o["b"], T_OUT + 2 * pl["thickness"] + 0.02))
    emit("base", "stone", "plinth", parts(plinth, pl["ground"], gf + pl["height"]), height=pl["height"])

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

    # ---------- feature walls: Taif stone cladding on selected faces, the openings cut out ----------
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
        name = emit("base", "stone", f"feature_wall_{k:02d}", panel(a, b, n, t / 2, fw["thickness"], prof), wall=w["name"], openings=len(cut))
        rec["feature_walls"].append({"name": name, "wall": w["name"], "line": w["line"], "z": w["z"], "openings_cut": len(cut), "area": round(prof.area, 2)})

    # ---------- the colonnade: stone sleeves Ø0.40 round C21–C23 with plain base and capital bands ----------
    cl = C["colonnade"]
    cols = column_points()
    sleeves = []
    for cid, (x, y) in cols.items():
        r = cl["diameter"] / 2
        meshes = parts(disc((x, y), r), gf, roof_under)
        meshes += parts(disc((x, y), cl["base"]["diameter"] / 2), gf, gf + cl["base"]["height"])
        for top in (soffit_bottom, roof_under):
            meshes += parts(disc((x, y), cl["capital"]["diameter"] / 2), top - cl["capital"]["height"], top)
        sleeves.append(emit("base", "stone", f"column_{cid}", meshes, column=cid, diameter=cl["diameter"]))
        rec["sleeves"].append({"column": cid, "x": x, "y": y, "diameter": cl["diameter"], "structural": COLS[cid]["size"], "z0": gf, "z1": roof_under})
    col_holes = unary_union([disc(c, cl["diameter"] / 2 + 0.005) for c in cols.values()])

    # ---------- V7.1: the courtyard arcade: two intermediate stone columns on the colonnade line and three semicircular arches under the soffit (courtyard bay only) ----------
    ac = C["arcade"]
    y_c21, y_c22 = cols["C21"][1], cols["C22"][1]
    ac_cols = []
    for k, y in enumerate(ac["columns"]["at_y"]):
        r_ = ac["columns"]["diameter"] / 2
        meshes = parts(disc((PROJ_X, y), r_), gf, soffit_bottom)
        meshes += parts(disc((PROJ_X, y), ac["columns"]["base"]["diameter"] / 2), gf, gf + ac["columns"]["base"]["height"])
        meshes += parts(disc((PROJ_X, y), ac["columns"]["capital"]["diameter"] / 2), soffit_bottom - ac["columns"]["capital"]["height"], soffit_bottom)
        emit("base", "stone", f"arcade_column_{k}", meshes, at=[PROJ_X, y], diameter=ac["columns"]["diameter"])
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

    # ---------- V7.0: stone quoins at the outer corners (docs/DESIGN_LANGUAGE.md: honey stone at the base and the corners) ----------
    qn = C["quoins"]
    quoins = []
    for a, b in zip(OUTLINE, OUTLINE[1:] + OUTLINE[:1]):
        (ux, uy), L = unit(a, b)
        n = outward(a, b)
        for p, sgn in ((a, 1), (b, -1)):
            q0, q1 = shift(p, n, T_OUT / 2), shift(shift(p, n, T_OUT / 2), (ux, uy), sgn * qn["width"])
            quoins += parts(seg_box(q0, q1, qn["thickness"] * 2).intersection(outer_face.buffer(qn["thickness"], join_style=2).difference(outer_face)), gf + C["plinth"]["height"], qn["top"])
    emit("base", "stone", "quoins", quoins, corners=len(OUTLINE))

    # ---------- pergola: timber beams over part of the courtyard sky, on the roof finish ----------
    pg = C["pergola"]
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

    # ---------- roof: black steel bar guards round the two roof holes (the parapets, the cornice and the attic are base-model meshes since V7.0) ----------
    rl = P["roof_design"]["guard"]
    attic_wall = wkt_loads(summary["roof_design"]["attic"]["line_wkt"])
    attic_wall = attic_wall.difference(attic_wall.buffer(-P["roof_design"]["attic"]["thickness"] - 0.02, join_style=2)).buffer(0.02)
    rails = []
    for hole in (COURT_SKY, SUITE_COURT):
        hx0, hy0, hx1, hy1 = hole.bounds
        inner = box(hx0 - 0.05 - rl["bar"], hy0 - 0.05 - rl["bar"], hx1 + 0.05 + rl["bar"], hy1 + 0.05 + rl["bar"])
        ringr = inner.difference(box(hx0 - 0.05, hy0 - 0.05, hx1 + 0.05, hy1 + 0.05))
        rails += parts(ringr.difference(attic_wall), roof_fin + rl["height"] - rl["bar"], roof_fin + rl["height"]) + parts(ringr.difference(attic_wall), roof_fin + rl["height"] / 2 - rl["bar"] / 2, roof_fin + rl["height"] / 2 + rl["bar"] / 2)
        corners = list(inner.exterior.coords)[:-1]
        for p, q in zip(corners, corners[1:] + corners[:1]):
            (ux, uy), L = unit(p, q)
            n = max(1, math.ceil(L / rl["post_spacing"]))
            for k in range(n + 1):
                c = (p[0] + ux * L * k / n, p[1] + uy * L * k / n)
                rails += parts(box(c[0] - rl["bar"] / 2, c[1] - rl["bar"] / 2, c[0] + rl["bar"] / 2, c[1] + rl["bar"] / 2).intersection(ringr.buffer(rl["bar"])).difference(attic_wall), roof_fin, roof_fin + rl["height"])
    rails = [m for m in rails if m is not None]
    emit("base", "steel", "roof_railings", rails, height=rl["height"])
    rec["roof_guards"] = {"height": rl["height"], "holes": ["courtyard sky", "suite court (west and east edges; the north edge is the attic wall, the south the gym roof railing)"]}

    # ---------- the malqaf head: timber louvre slats in its two openings (the head itself is re-coloured stone in the viewer) ----------
    lv = C["malqaf_louvres"]
    os_, oh = AIR["head-opening"]
    slats = []
    for a, b in (((9.1, 0.0), (9.9, 0.0)), ((8.95, 0.1), (8.95, 0.9))):          # the openings of build_3d.py (north and west faces)
        for k in range(lv["slats"]):
            z = os_ + (oh - os_) * (k + 0.5) / lv["slats"]
            slats += parts(seg_box(a, b, lv["depth"]), z - lv["thickness"] / 2, z + lv["thickness"] / 2)
    emit("base", "timber", "malqaf_louvres", slats, slats=lv["slats"] * 2)

    # ---------- the wall fountain: a simple shape on the courtyard's east wall under the kitchen sink window (the malqaf grille is north of it) ----------
    ft = C["fountain"]
    x1, y1, x2, y2 = (float(v) for v in ft["wall"].split())
    wa, wb, n = (x1, y1), (x2, y2), tuple(float(v) for v in ft["side"])
    (ux, uy), _ = unit(wa, wb)
    axis = 1 if abs(uy) > abs(ux) else 0                       # the plan coordinate that runs along the wall
    face = wall_t(wa, wb) / 2 + fw["thickness"]                # on the stone cladding of that face

    def wall_box(v0, v1, d0, d1):
        """A plan rectangle on the wall: v0–v1 along it (plan coordinates), d0–d1 out from its centre line along n."""
        s0, s1 = v0 - wa[axis], v1 - wa[axis]
        return Polygon([(wa[0] + ux * s + n[0] * d, wa[1] + uy * s + n[1] * d) for s, d in ((s0, d0), (s1, d0), (s1, d1), (s0, d1))])

    emit("base", "stone", "fountain_panel", parts(wall_box(ft["along"][0], ft["along"][1], face, face + ft["thickness"]), gf + ft["z"][0], gf + ft["z"][1]), along=ft["along"], z=ft["z"])
    bs, d0 = ft["basin"], face + ft["thickness"]
    outer = wall_box(bs["along"][0], bs["along"][1], d0, d0 + bs["depth"])
    inner = wall_box(bs["along"][0] + 0.06, bs["along"][1] - 0.06, d0, d0 + bs["depth"] - 0.06)
    emit("base", "stone", "fountain_basin", parts(outer, gf + bs["z"][0], gf + bs["z"][0] + 0.05) + parts(outer.difference(inner), gf + bs["z"][0] + 0.05, gf + bs["z"][1]))
    sp = ft["spout"]
    emit("base", "bronze", "fountain_spout", parts(wall_box(sp["along"][0], sp["along"][1], d0, d0 + sp["depth"]), gf + sp["z"][0], gf + sp["z"][1]))
    sink = next((o for o in summary["openings"] if o["floor"] == "GF" and "kitchen sink" in o["name"]), None)
    gy0, gz0, gy1, gz1 = AIR["grille"]
    rec["fountain"] = {"wall": ft["wall"], "along": ft["along"], "z": ft["z"], "basin_z": bs["z"], "grille_y": [gy0, gy1],
                       "clear_of_grille": round(ft["along"][0] - gy1, 3), "below_sink_sill": round(sink["sill"] - FINISHED["GF"] - ft["z"][1], 3) if sink else None,
                       "note": "decorative shape under the sink window; its water and drain are air items A8 / A6"}

    # ---------- the sunken seating (variant, default on): the courtyard floor with a pit against the east wall under the malqaf grille ----------
    sk = C["sunken"]
    court_floor = g["COURT_FLOOR"]                             # the base model's courtyard floor (gf_slab_court + gf_finish_court, hidden while the variant is on)
    px0, py0, px1, py1 = sk["box"]
    pit = box(px0, py0, px1, py1)
    zf = gf + sk["floor"]
    r, tr, n_r = sk["riser"], sk["tread"], sk["risers"]
    if abs(n_r * r + sk["floor"]) > EPS:
        raise SystemExit(f"ERROR: character.yaml sunken: {n_r} risers × {r} != the depth {-sk['floor']}")
    emit("sunken", "stone_light", "court_floor", parts(court_floor.difference(pit), STRUCT_TOP["GF"] - T_SLAB, gf), replaces=["gf_slab_court", "gf_finish_court"])
    emit("sunken", "stone_light", "pit_floor", parts(pit, zf - T_SLAB, zf), level=sk["floor"])
    steps = []
    for k in range(1, n_r):                                    # the treads between the risers: the top riser is the courtyard edge, the bottom one meets the pit floor
        steps += parts(box(px0 + tr * (k - 1), py0, px0 + tr * k, py1), zf, gf - r * k)
    emit("sunken", "stone_light", "steps", steps, risers=n_r, riser=r, tread=tr)
    bench = sk["bench"]
    by0, by1 = bench["y"]
    emit("sunken", "stone", "bench", parts(box(px1 - bench["depth"], by0, px1, by1), zf, gf + bench["seat"] - bench["timber_top"]), seat=bench["seat"])
    emit("sunken", "timber", "bench_top", parts(box(px1 - bench["depth"], by0, px1, by1), gf + bench["seat"] - bench["timber_top"], gf + bench["seat"]))
    tb = sk["table"]["box"]
    emit("sunken", "stone", "table", parts(box(*tb), zf + sk["table"]["height"] - 0.05, zf + sk["table"]["height"]) + parts(box(tb[0] + 0.12, tb[1] + 0.12, tb[2] - 0.12, tb[3] - 0.12), zf, zf + sk["table"]["height"] - 0.05))
    dx, dy = sk["drain"]["at"]
    ds = sk["drain"]["size"]
    emit("sunken", "bronze", "drain", parts(box(dx - ds / 2, dy - ds / 2, dx + ds / 2, dy + ds / 2), zf - 0.01, zf + 0.005), at=sk["drain"]["at"])
    ov = sk["overflow"]
    emit("sunken", "bronze", "overflow", parts(box(ov["at"][0] - ov["width"] / 2, py1 - 0.02, ov["at"][0] + ov["width"] / 2, py1), gf + ov["level"], gf + ov["level"] + ov["height"]), level=ov["level"])
    gxf = AIR["grille-x"] - T_IN / 2                           # the grille's wall face (courtyard side)
    emit("sunken", "stone", "grille_upstand", parts(box(gxf - sk["upstand"], gy0 - 0.05, gxf, gy1 + 0.05), gf + gz0 - 0.05, gf + gz0 + 0.01))
    ol = sk["olive"]
    ox, oy, half = ol["at"][0], ol["at"][1], ol["planter"] / 2
    planter = box(ox - half, oy - half, ox + half, oy + half)
    emit("sunken", "stone", "planter", parts(planter, zf, zf + 0.05) + parts(planter.difference(planter.buffer(-0.08)), zf + 0.05, zf + ol["planter_height"]))
    emit("sunken", "trunk", "olive_soil", parts(planter.buffer(-0.08), zf + ol["planter_height"] - 0.1, zf + ol["planter_height"] - 0.05))
    emit("sunken", "trunk", "olive_trunk", parts(disc((ox, oy), ol["trunk"] / 2, 6), zf + ol["planter_height"] - 0.05, zf + ol["canopy_centre"]))
    canopy = trimesh.creation.icosphere(subdivisions=1, radius=ol["canopy_radius"])
    canopy.apply_translation([ox, oy, zf + ol["canopy_centre"]])
    emit("sunken", "foliage", "olive_canopy", [canopy], at=ol["at"])
    court_in = court_floor.bounds                               # the courtyard between its wall faces
    edges_m = {"north": round(py0 - court_in[1], 3), "south": round(court_in[3] - py1, 3), "west": round(px0 - court_in[0], 3), "east": round(court_in[2] - px1, 3)}
    for p_ in (ol["at"], ((tb[0] + tb[2]) / 2, (tb[1] + tb[3]) / 2), sk["drain"]["at"]):
        if not pit.contains(Point(p_)):
            raise SystemExit(f"ERROR: character.yaml sunken element at {p_} is not in the pit")
    rec["sunken"] = {"default": sk["default"], "box": sk["box"], "floor": sk["floor"], "risers": n_r, "riser": r, "tread": tr, "bench": {"y": bench["y"], "depth": bench["depth"], "seat": bench["seat"]},
                     "grille": {"y": [gy0, gy1], "z": [gz0, gz1], "above_floor": round(gz0 - sk["floor"], 3), "above_seat": round(gz0 - bench["seat"], 3)},
                     "level_edges": edges_m, "walking_edge_min": sk["walking_edge_min"], "drain": sk["drain"]["at"], "overflow_level": ov["level"], "replaces": ["gf_slab_court", "gf_finish_court"]}
    rec["flags"].append("Sunken seating (style study, variant on by default): the courtyard floor −0.45 against the east wall under the malqaf grille (grille 0.20 above the bench seat, 0.60 above the sunken floor); "
                        "its floor drain and overflow at the lowest point are for the MEP engineer (air item A6)")

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
    rec["flags"].append("Character study (3d/character.yaml): STYLE STUDY, PROVISIONAL: stone, timber, bronze and plaster as flat colours; plinth, deep reveals, mashrabiya, "
                        "stone sleeves Ø%g on the assumed Ø0.30 colonnade, timber soffit, pergola, fountain, props; V7.0: the design language (cream plaster, honey stone, black steel "
                        "divided-lite windows, walnut), the quoins, the roof guards; V7.1: the courtyard arcade (two Ø%g stone columns, three semicircular arches under the projection, decorative) "
                        "and semicircular heads on the enclosure windows W1–W3; the living bay keeps no arches (owner, V6.3)" % (cl["diameter"], C["arcade"]["columns"]["diameter"]))
    summary["character"] = {**rec, "enabled": True, "hide": hide, "palette": pal, "assign": C["assign"]}
    summary["flags"] += rec["flags"]

    # ---------- the viewer block ----------
    bm = {k: {"title": v["title"], "eye": [v["eye"][0], v["eye"][2], v["eye"][1]], "target": [v["target"][0], v["target"][2], v["target"][1]], "night": bool(v.get("night"))}
          for k, v in C["views"].items()}
    viewer = {"enabled": True, "note": C["note"], "palette": pal, "assign": C["assign"], "hide": hide, "hide_when_sunken": rec["sunken"]["replaces"], "sun": C.get("sun", ""),
              "defaults": {"pergola": pg["default"], "sunken": sk["default"]},
              "lights": [[x, z, y] for x, y, z in lights],
              "night": {"background": C["night"]["background"], "lights": [[x, z, y, i] for x, y, z, i in C["night"]["point_lights"]]},
              "tv_wall": rec["tv_wall"], "arcade": rec["arcade"], "arched_windows": rec["arched_windows"], "mashrabiya": [f"{m['floor']} {m['window']}: {m['why']}" for m in rec["mashrabiya"]],
              "bookmarks": bm}
    return viewer

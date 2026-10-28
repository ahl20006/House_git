"""character_3d.py · Taif / Palm House · 3D phase "character": simple architectural character for the model (STYLE STUDY, PROVISIONAL).
Called by build_3d.py after the model is built; reads 3d/character.yaml and the model's own data (openings, columns, beams, voids)
and adds the character meshes, named chr_<group>_<material>_<label> so the viewer can colour and toggle them:
  group base      stone plinth, feature-wall cladding, recessed outer-window glazing with bronze frames, mashrabiya screens, the
                  colonnade's stone sleeves (base and capital bands), the timber soffit and fascia under the projection, the roof
                  parapet with its coping and the roof railings, the malqaf head's timber louvres, the courtyard fountain pier
  group parapet   variant A of the gallery railing: a plastered parapet on the upturned beam B3 with a stone coping
  group glassrail variant B: a glass railing with a bronze handrail
  group pergola   timber beams over the north part of the courtyard sky (toggle)
  group arches    the arches variant: slender intermediate columns on the ground floor and plain arches under the projection (toggle)
  group props     olive tree in a planter, a bench and a table (scale only)
  group light     the hanging lanterns (point lights in the night view)
Existing meshes are not changed here: the viewer re-colours them by name (character.yaml `assign`) when the character is on and
hides the few they replace (the outer windows' centre-line glass, the B3 railing). Nothing is edited by hand: change character.yaml
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
    frames, panes = [], []
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
    emit("base", "glass", "recessed_glazing", panes, windows=len(rec["recessed_windows"]))
    emit("base", "bronze", "window_frames", frames, windows=rec["frames"])

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

    # ---------- the timber soffit under the projection and the fascia on its edge (the slab edge and the upturned beam) ----------
    b3 = BEAMS["B3"]
    so = C["soffit"]
    y0, y1 = min(b3["a"][1], b3["b"][1]) + T_IN / 2, max(b3["a"][1], b3["b"][1]) - T_IN / 2
    riwaq_x = PROJ_X - P["projection"]["width"] + T_IN / 2                 # the face of the first-floor west rooms' wall (x 4.25)
    edge_x = PROJ_X + b3["w"] / 2
    emit("base", "timber", "soffit", parts(box(riwaq_x, y0, edge_x, y1).difference(col_holes), soffit_bottom, ff_under), z=[soffit_bottom, ff_under])
    emit("base", "timber", "fascia", parts(box(edge_x, y0, edge_x + so["fascia"], y1).difference(col_holes), soffit_bottom, b3_top), z=[soffit_bottom, b3_top])

    # ---------- the gallery railing on B3: variant A a plastered parapet with a coping, variant B a glass railing with a handrail ----------
    gr = C["gallery_railing"]
    top = FINISHED["FF"] + P["railing_height"]
    cop = gr["coping"]
    line = seg_box(b3["a"], b3["b"], b3["w"])
    emit("parapet", "plaster", "wall", parts(line.difference(col_holes), b3_top, top - cop["thickness"]), z=[b3_top, top - cop["thickness"]])
    emit("parapet", cop["material"], "coping", parts(seg_box(b3["a"], b3["b"], b3["w"] + 2 * cop["overhang"]).difference(col_holes), top - cop["thickness"], top))
    emit("glassrail", "glass", "panel", parts(seg_box(b3["a"], b3["b"], P["openings"]["glass"]).difference(col_holes), b3_top, top - gr["glass"]["handrail"]))
    emit("glassrail", "bronze", "handrail", parts(seg_box(b3["a"], b3["b"], gr["glass"]["handrail"]).difference(col_holes), top - gr["glass"]["handrail"], top))
    b3_rail = next((i for i, r in enumerate(summary["rails"]) if "B3" in r["note"]), None)
    if b3_rail is not None:
        hide.append(f"ff_rail_{b3_rail:02d}")
    rec["gallery_railing"] = {"on": "B3 upturned, top %+.2f" % b3_top, "z0": round(b3_top, 3), "z1": round(top, 3), "thickness": b3["w"], "default": gr["default"], "replaces": f"ff_rail_{b3_rail:02d}" if b3_rail is not None else None}

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

    # ---------- roof: the parapet with its coping on the outer walls; bronze railings round the two roof holes ----------
    rf = C["roof"]
    tower_out = Polygon(AIR["tower"]).buffer(T_OUT / 2 + 0.01, join_style=2)       # the malqaf head rises through the parapet here
    par = rf["parapet"]
    body_top = roof_fin + par["height"] - par["coping"]
    emit("base", "plaster", "roof_parapet", parts(ring.difference(tower_out), roof_fin, body_top), z=[roof_fin, body_top])
    coping = outer_face.buffer(par["overhang"], join_style=2).difference(outline_poly.buffer(-T_OUT / 2 - par["overhang"], join_style=2)).difference(tower_out)
    emit("base", "stone", "roof_coping", parts(coping, body_top, roof_fin + par["height"]), z=[body_top, roof_fin + par["height"]])
    rec["roof_parapet"] = {"z0": roof_fin, "z1": round(roof_fin + par["height"], 3), "coping": par["coping"]}
    rl = rf["railing"]
    rails = []
    for hole in (COURT_SKY, SUITE_COURT):
        hx0, hy0, hx1, hy1 = hole.bounds
        inner = box(hx0 - 0.05 - rl["bar"], hy0 - 0.05 - rl["bar"], hx1 + 0.05 + rl["bar"], hy1 + 0.05 + rl["bar"])
        ringr = inner.difference(box(hx0 - 0.05, hy0 - 0.05, hx1 + 0.05, hy1 + 0.05))
        rails += parts(ringr, roof_fin + rl["height"] - rl["bar"], roof_fin + rl["height"]) + parts(ringr, roof_fin + rl["height"] / 2 - rl["bar"] / 2, roof_fin + rl["height"] / 2 + rl["bar"] / 2)
        corners = list(inner.exterior.coords)[:-1]
        for p, q in zip(corners, corners[1:] + corners[:1]):
            (ux, uy), L = unit(p, q)
            n = max(1, math.ceil(L / rl["post_spacing"]))
            for k in range(n + 1):
                c = (p[0] + ux * L * k / n, p[1] + uy * L * k / n)
                rails += parts(box(c[0] - rl["bar"] / 2, c[1] - rl["bar"] / 2, c[0] + rl["bar"] / 2, c[1] + rl["bar"] / 2).intersection(ringr.buffer(rl["bar"])), roof_fin, roof_fin + rl["height"])
    emit("base", "bronze", "roof_railings", rails, height=rl["height"])

    # ---------- the malqaf head: timber louvre slats in its two openings (the head itself is re-coloured stone in the viewer) ----------
    lv = C["malqaf_louvres"]
    os_, oh = AIR["head-opening"]
    slats = []
    for a, b in (((9.1, 0.0), (9.9, 0.0)), ((8.95, 0.1), (8.95, 0.9))):          # the openings of build_3d.py (north and west faces)
        for k in range(lv["slats"]):
            z = os_ + (oh - os_) * (k + 0.5) / lv["slats"]
            slats += parts(seg_box(a, b, lv["depth"]), z - lv["thickness"] / 2, z + lv["thickness"] / 2)
    emit("base", "timber", "malqaf_louvres", slats, slats=lv["slats"] * 2)

    # ---------- the courtyard north wall: a stone pier round the malqaf grille with a simple wall-fountain shape above it ----------
    ft = C["fountain"]
    wall_a, wall_b, n = (4.25, 6.5), (8.95, 6.5), (0.0, 1.0)
    gx0, gz0, gx1, gz1 = AIR["grille"]
    prof = box(ft["pier"][0] - wall_a[0], STRUCT_TOP["GF"], ft["pier"][1] - wall_a[0], ft["height"]).difference(box(gx0 - wall_a[0], gf + gz0, gx1 - wall_a[0], gf + gz1))
    face = T_IN / 2 + fw["thickness"]
    emit("base", "stone", "fountain_pier", panel(wall_a, wall_b, n, face, ft["thickness"], prof), x=ft["pier"], grille_hole=[gx0, gx1, gz0, gz1])
    bs = ft["basin"]
    y_face = wall_a[1] + face + ft["thickness"]
    outer = box(bs["x"][0], y_face, bs["x"][1], y_face + bs["depth"])
    inner = box(bs["x"][0] + 0.06, y_face, bs["x"][1] - 0.06, y_face + bs["depth"] - 0.06)
    emit("base", "stone", "fountain_basin", parts(outer, gf + bs["z"][0], gf + bs["z"][0] + 0.05) + parts(outer.difference(inner), gf + bs["z"][0] + 0.05, gf + bs["z"][1]))
    sp = ft["spout"]
    emit("base", "bronze", "fountain_spout", parts(box(sp["x"][0], y_face, sp["x"][1], y_face + sp["depth"]), gf + sp["z"][0], gf + sp["z"][1]))
    rec["fountain"] = {"pier_x": ft["pier"], "grille": AIR["grille"], "basin_z": bs["z"], "note": "the pier shows air item A7 option 2 (the women's majlis glass shortened to x 5.1–6.4); the base model's glazing is unchanged until the owner decides"}
    rec["flags"].append("Courtyard north wall: the character study draws a stone pier x %g–%g round the malqaf grille (air item A7, owner: glass shortened to x 5.1–6.4, or a solid base under it); the glazing itself is unchanged in the model" % tuple(ft["pier"]))

    # ---------- props for scale: an olive tree in a stone planter, a bench, a table, hanging lanterns ----------
    pr = C["props"]
    ol = pr["olive"]
    ox, oy, half = ol["at"][0], ol["at"][1], ol["planter"] / 2
    planter = box(ox - half, oy - half, ox + half, oy + half)
    emit("props", "stone", "planter", parts(planter, gf, gf + 0.05) + parts(planter.difference(planter.buffer(-0.08)), gf + 0.05, gf + ol["planter_height"]))
    emit("props", "trunk", "olive_soil", parts(planter.buffer(-0.08), gf + ol["planter_height"] - 0.1, gf + ol["planter_height"] - 0.05))
    trunk = parts(disc((ox, oy), ol["trunk"] / 2, 6), gf + ol["planter_height"] - 0.05, gf + ol["canopy_centre"])
    emit("props", "trunk", "olive_trunk", trunk)
    canopy = trimesh.creation.icosphere(subdivisions=1, radius=ol["canopy_radius"])
    canopy.apply_translation([ox, oy, gf + ol["canopy_centre"]])
    emit("props", "foliage", "olive_canopy", [canopy], at=ol["at"])
    bb = pr["bench"]["box"]
    emit("props", "timber", "bench", parts(box(*bb), gf + 0.12, gf + pr["bench"]["height"]) + parts(box(bb[0] + 0.1, bb[1] + 0.1, bb[2] - 0.1, bb[3] - 0.1), gf, gf + 0.12))
    tb = pr["table"]["box"]
    emit("props", "stone", "table", parts(box(*tb), gf + pr["table"]["height"] - 0.05, gf + pr["table"]["height"]) + parts(box(tb[0] + 0.15, tb[1] + 0.15, tb[2] - 0.15, tb[3] - 0.15), gf, gf + pr["table"]["height"] - 0.05))
    la = pr["lanterns"]
    lw, ld, lh = la["size"]
    lights = []
    for k, (x, y) in enumerate(la["at"]):
        z1 = soffit_bottom - la["drop"]
        emit("light", "bronze", f"lantern_rod_{k}", parts(disc((x, y), 0.01, 4), z1, soffit_bottom))
        emit("light", "lantern", f"lantern_{k}", parts(box(x - lw / 2, y - ld / 2, x + lw / 2, y + ld / 2), z1 - lh, z1), at=[x, y])
        lights.append([x, y, round(z1 - lh / 2, 3)])
    rec["lanterns"] = lights
    for p_ in (ol["at"], ((bb[0] + bb[2]) / 2, (bb[1] + bb[3]) / 2), ((tb[0] + tb[2]) / 2, (tb[1] + tb[3]) / 2)):
        if not Polygon(g["court"]["pts"]).contains(Point(p_)):
            raise SystemExit(f"ERROR: character.yaml prop at {p_} is not in the courtyard")

    # ---------- the arches variant: slender ground-floor columns between the main ones, plain arches under the projection ----------
    ar = C["arches"]
    main = sorted(cols.items(), key=lambda kv: kv[1][1])                      # C21, C22, C23 by y
    x_line = main[0][1][0]
    inter, plates, bays = [], [], []
    rise, crown = ar["rise"], ar["crown"]
    r_main, r_int = cl["diameter"] / 2, ar["column_diameter"] / 2
    for (ca, (xa, ya)), (cb, (xb, yb)) in zip(main, main[1:]):
        L = yb - ya
        n_bays = max(2, round(L / ar["bay_target"]))
        pts = [(ya, r_main)] + [(ya + L * k / n_bays, r_int) for k in range(1, n_bays)] + [(yb, r_main)]
        for y, _ in pts[1:-1]:
            inter.append((x_line, round(y, 4)))
        for (y_l, r_l), (y_r, r_r) in zip(pts, pts[1:]):
            s0, s1 = y_l + r_l, y_r - r_r                                     # the clear bay between the column faces
            c, h = (s1 - s0) / 2, min(rise, (s1 - s0) / 2 - 0.05)
            rho = (c * c + h * h) / (2 * h)                                   # a segmental arch: chord 2c, rise h
            spring = soffit_bottom - crown - h
            mid = (s0 + s1) / 2
            hole = disc((mid, spring + h - rho), rho, 32).intersection(box(s0, spring, s1, soffit_bottom))
            plates.append(box(y_l, spring, y_r, soffit_bottom).difference(hole))
            bays.append({"from": ca if (y_l, r_l) == pts[0] else "intermediate", "y": [round(y_l, 3), round(y_r, 3)], "bay": round(y_r - y_l, 3), "clear": round(s1 - s0, 3), "springing": round(spring, 3), "rise": round(h, 3)})
    rooms_under = {}
    for (x, y) in inter:
        rooms_under[f"{x} {y}"] = next((r["name"] for r in GF if Polygon(r["pts"]).buffer(0.01).contains(Point(x, y))), "?")
    col_meshes = []
    for (x, y) in inter:
        col_meshes += parts(disc((x, y), r_int), gf, soffit_bottom) + parts(disc((x, y), r_int + 0.05), gf, gf + 0.12)
    emit("arches", "stone", "columns", col_meshes, columns=len(inter))
    emit("arches", ar["material"], "arches", panel((x_line, 0.0), (x_line, 1.0), (1.0, 0.0), -ar["thickness"] / 2, ar["thickness"], unary_union(plates)), bays=len(bays))
    effect = (f"arches variant: {len(inter)} slender columns Ø{ar['column_diameter']} on the ground floor between the three main ones → {len(cols) + len(inter)} columns on x {x_line}, "
              f"bays {', '.join(sorted({str(b['bay']) for b in bays}))} m instead of {', '.join(str(round(b[1][1] - a[1][1], 2)) for a, b in zip(main, main[1:]))} m; "
              f"the intermediate columns stand in: {', '.join(f'({k}) {v}' for k, v in rooms_under.items())}; "
              f"from the living the courtyard glass is seen through {sum(1 for b in bays if b['y'][0] >= main[1][1][1] - EPS)} arches with two columns on the living floor; "
              f"from the courtyard the colonnade reads as a {len(bays)}-bay arcade; decorative, not structural; a variant for a later decision")
    rec["arches"] = {"default": ar["default"], "intermediate_columns": inter, "rooms": rooms_under, "bays": bays, "x": x_line, "effect": effect}
    rec["flags"].append("Character study (3d/character.yaml): STYLE STUDY, PROVISIONAL: stone, timber, bronze and plaster as flat colours; plinth, deep reveals, mashrabiya, "
                        "stone sleeves Ø%g on the assumed Ø0.30 colonnade, timber soffit, parapet or glass railing on B3, pergola, roof parapet, fountain pier, props; "
                        "the arches variant is decorative and for a later decision" % cl["diameter"])
    summary["character"] = {**rec, "enabled": True, "hide": hide, "palette": pal, "assign": C["assign"]}
    summary["flags"] += rec["flags"]

    # ---------- the viewer block ----------
    bm = {k: {"title": v["title"], "eye": [v["eye"][0], v["eye"][2], v["eye"][1]], "target": [v["target"][0], v["target"][2], v["target"][1]], "night": bool(v.get("night"))}
          for k, v in C["views"].items()}
    viewer = {"enabled": True, "note": C["note"], "palette": pal, "assign": C["assign"], "hide": hide,
              "defaults": {"arches": ar["default"], "pergola": pg["default"], "railing": gr["default"]},
              "lights": [[x, z, y] for x, y, z in lights],
              "night": {"background": C["night"]["background"], "lights": [[x, z, y, i] for x, y, z, i in C["night"]["point_lights"]]},
              "arches_effect": effect, "mashrabiya": [f"{m['floor']} {m['window']}: {m['why']}" for m in rec["mashrabiya"]],
              "bookmarks": bm}
    return viewer

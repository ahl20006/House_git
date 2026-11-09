"""malqaf_L5_views.py · Taif / Palm House · STUDY ONLY (studies/malqaf_L5.typ, Phase 5): L5 rendered on a COPY of the adopted model.

Loads 3d/output/taif_house_<version>.glb, takes out the adopted (L1) tower, plant room and plenum above the roof, rebuilds the roofline
rings without their cut (3d/malqaf_variants.py helpers), adds the L5 core (the GF foot chamber with its outlet and its open carved door,
the FF shaft, the F3 head 1.6 x 2.4 to +13.20 with its slender arched slots) in render-and-paint colours, and screenshots two cameras
with headless Edge through a temporary viewer copy. The adopted model files are not touched.

    python taif_house/3d/malqaf_L5_views.py      -> 3d/output/malqaf_L5_gate.png, 3d/output/malqaf_L5_court.png
"""
import base64, importlib.util, math, re, subprocess, sys
from pathlib import Path
import numpy as np, trimesh
from shapely.geometry import Polygon, box

HERE = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location("mv", HERE / "malqaf_variants.py")
mv = importlib.util.module_from_spec(spec); spec.loader.exec_module(mv)
ext, M, VERSION, OUTLINE, T_OUT = mv.ext, mv.M, mv.VERSION, mv.OUTLINE, mv.T_OUT

SAND, HONEY, DARK, TIMBER, PLASTER = (236, 226, 204), (216, 180, 122), (32, 32, 34), (156, 107, 60), (236, 226, 204)
X0, Y0, X1, Y1, YC = 4.30, 6.4, 5.90, 8.8, 8.767          # the head's outer faces (F3) and the GF chamber's south face
Z_FF, Z_ROOF, Z_RFIN = 3.52, 7.2, 7.3
Z_BAND, Z_OPEN0, Z_OPEN1, Z_CROWN, Z_TOP = 10.6, 11.2, 12.6, 12.9, 13.2
T = 0.20

def slot(cx, w, h):
    r = w / 2
    pts = [(cx - r, 0), (cx + r, 0), (cx + r, h - r)] + [(cx + r * math.cos(t), h - r + r * math.sin(t)) for t in np.linspace(0, math.pi, 13)[1:-1]] + [(cx - r, h - r)]
    return Polygon(pts)

def face_void(face, u_centres, z0, h, w=0.20):
    """Dark slot shapes 20 mm proud of a head face: u runs along the face from its west / north end."""
    parts = []
    for cu in u_centres:
        m = trimesh.creation.extrude_polygon(slot(cu, w, h), 0.02)
        v = m.vertices.copy(); u, vv, o = v[:, 0], v[:, 1] + z0, v[:, 2] - 0.008
        if face == "N":   X, Y = X0 + u, Y0 - o
        elif face == "S": X, Y = X0 + u, Y1 + o
        elif face == "W": X, Y = X0 - o, Y0 + u
        else:             X, Y = X1 + o, Y0 + u
        m.vertices = np.column_stack([X, Y, vv]); parts.append(m)
    m = trimesh.util.concatenate(parts); m.apply_transform(M)
    m.visual.vertex_colors = np.tile(np.array(list(DARK) + [255], dtype=np.uint8), (len(m.vertices), 1))
    return m

def l5_meshes():
    out = {}
    # the GF foot chamber: west and north walls full; the east wall with the outlet (y 7.1-8.5, +0.10 … +1.10); the south wall with the open door (x 4.6-5.6, 2.4 high)
    out["chr_base_plaster_l5_gf_w"] = ext(box(X0, Y0, X0 + T, YC), 0.0, Z_FF, PLASTER)
    out["chr_base_plaster_l5_gf_n"] = ext(box(X0, Y0, X1, Y0 + T), 0.0, Z_FF, PLASTER)
    e = X1 - T
    out["chr_base_plaster_l5_gf_e"] = ext(box(e, Y0 + T, X1, 7.1).union(box(e, 8.5, X1, YC)), 0.0, Z_FF, PLASTER)
    out["chr_base_plaster_l5_gf_e_sill"] = ext(box(e, 7.1, X1, 8.5), 0.0, 0.10, PLASTER)
    out["chr_base_plaster_l5_gf_e_lintel"] = ext(box(e, 7.1, X1, 8.5), 1.10, Z_FF, PLASTER)
    out["chr_base_timber_l5_outlet"] = ext(box(X1 - 0.03, 7.1, X1 + 0.01, 8.5), 0.10, 1.10, TIMBER)
    s = YC - T
    out["chr_base_plaster_l5_gf_s"] = ext(box(X0 + T, s, 4.6, YC).union(box(5.6, s, X1 - T, YC)), 0.0, Z_FF, PLASTER)
    out["chr_base_plaster_l5_gf_s_lintel"] = ext(box(4.6, s, 5.6, YC), 2.4, Z_FF, PLASTER)
    out["chr_base_timber_l5_door_open"] = ext(box(4.6, YC, 4.65, YC + 1.0), 0.0, 2.4, TIMBER)          # the carved door swung open into the strip
    out["chr_base_steel_l5_inside"] = ext(box(X0 + T, Y0 + T, X1 - T, s), 0.0, 0.05, DARK)             # the dark chamber floor seen through the door
    # the FF shaft (y 6.4-7.6) to the roof, then the head 1.6 x 2.4 to the crown, the band and the Hijazi crown in the honey tone
    shaft = box(X0, Y0, X1, 7.6)
    out["chr_base_plaster_l5_ff"] = ext(shaft.difference(shaft.buffer(-T, join_style=2)), Z_FF, Z_RFIN, PLASTER)
    head = box(X0, Y0, X1, Y1)
    out["chr_base_plaster_l5_head"] = ext(head.difference(head.buffer(-T, join_style=2)), Z_RFIN, Z_CROWN, SAND)
    out["chr_base_stone_l5_band"] = ext(head.buffer(0.06, join_style=2).difference(head.buffer(-0.06, join_style=2)), Z_BAND, Z_BAND + 0.15, HONEY)
    out["chr_base_stone_l5_crown1"] = ext(head.buffer(0.05, join_style=2), Z_CROWN, Z_CROWN + 0.12, HONEY)
    out["chr_base_stone_l5_crown2"] = ext(head.buffer(0.10, join_style=2), Z_CROWN + 0.12, Z_TOP, HONEY)
    h = Z_OPEN1 - Z_OPEN0
    out["chr_base_steel_l5_slots_ns"] = trimesh.util.concatenate([face_void("N", [0.4, 0.8, 1.2], Z_OPEN0, h), face_void("S", [0.4, 0.8, 1.2], Z_OPEN0, h)])
    out["chr_base_steel_l5_slots_ew"] = trimesh.util.concatenate([face_void("W", [0.4, 0.8, 1.2, 1.6, 2.0], Z_OPEN0, h), face_void("E", [0.4, 0.8, 1.2, 1.6, 2.0], Z_OPEN0, h)])
    # the roof slab patched where the L1 shaft opened it (the NE corner), and the gallery-roof slab under the head's south part
    inner = OUTLINE.buffer(-T_OUT / 2, join_style=2)
    out["chr_base_plaster_l5_patch_ne"] = ext(box(9.4, -0.13, 11.45, 2.1).intersection(inner), Z_ROOF - 0.2, Z_RFIN, PLASTER)
    return out

def build():
    sc = trimesh.load(HERE / "output" / f"taif_house_{VERSION}.glb")
    keep = {n: g for n, g in sc.geometry.items() if not mv.DROP.match(n)}
    keep.update(mv.roofline(box(60, 60, 61, 61)))        # the rings without any cut (the L5 head stands inside the attic)
    keep.update(l5_meshes())
    new = trimesh.Scene()
    for n, g in keep.items():
        new.add_geometry(g, node_name=n, geom_name=n)
    return new.export(file_type="glb")

def render(glb_b64, name, query):
    js_src = (HERE / "output" / f"taif_house_{VERSION}.js").read_text(encoding="utf-8")
    js = re.sub(r'"glb": "[A-Za-z0-9+/=]+"', '"glb": "' + glb_b64 + '"', js_src, count=1)
    tmp_js, tmp_html = HERE / "output" / "_l5.js", HERE / "_l5.html"
    tmp_js.write_text(js, encoding="utf-8")
    tmp_html.write_text((HERE / "viewer.html").read_text(encoding="utf-8").replace(f"output/taif_house_{VERSION}.js", "output/_l5.js"), encoding="utf-8")
    out = HERE / "output" / name
    out.unlink(missing_ok=True)
    browser = next(p for p in (r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe", r"C:\Program Files\Google\Chrome\Application\chrome.exe") if Path(p).exists())
    try:
        for attempt in (1, 2):
            try:
                subprocess.run([browser, "--headless=new", "--disable-gpu", "--use-angle=swiftshader", "--enable-unsafe-swiftshader", "--hide-scrollbars",
                                "--window-size=1400,900", "--timeout=15000", f"--screenshot={out}", tmp_html.as_uri() + "?" + query + "&character=1&ui=0"], capture_output=True, timeout=240)
            except subprocess.TimeoutExpired:
                pass
            if out.exists():
                break
    finally:
        tmp_js.unlink(missing_ok=True); tmp_html.unlink(missing_ok=True)
    print(("wrote " if out.exists() else "FAILED ") + str(out.relative_to(HERE.parent.parent)))

if __name__ == "__main__":
    g = base64.b64encode(build()).decode("ascii")
    if "--court-only" not in sys.argv:
        render(g, "malqaf_L5_gate.png", "view=gate")
    render(g, "malqaf_L5_court.png", "eye=7.0,1.6,12.4&target=5.1,7.5,7.6")   # the viewer's URL camera is in the glTF frame: x, UP, south

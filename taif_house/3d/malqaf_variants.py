"""malqaf_variants.py · Taif / Palm House · STUDY ONLY (studies/malqaf_tower.typ): the new malqaf tower variants rendered from the gate view.

It does not change the design: it loads the current model (3d/output/taif_house_<version>.glb), takes out the present malqaf head and its HRV
base, rebuilds the roofline pieces that were cut round them (the cornice, the band, the north coping and parapet, the attic and its coping),
adds one variant of the proposed tower (a square stone tower set back on the attic's north-east corner, the HRV plant room behind the attic,
the hidden plenum), writes a temporary viewer file and screenshots the same "gate" camera as char_gate.png with headless Edge.

    python taif_house/3d/malqaf_variants.py            → 3d/output/malqaf_gate_<id>.png for every variant below
    python taif_house/3d/malqaf_variants.py b25 c35    → only those

The variants and every size are read from studies/malqaf_tower.typ's `#let variants` / `#let tw` lines (one source).
"""
import base64, io, math, re, subprocess, sys
from pathlib import Path
import numpy as np, trimesh, yaml
from shapely.geometry import Polygon, box
from shapely.affinity import translate

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
P = yaml.safe_load((HERE / "params.yaml").read_text(encoding="utf-8"))
VERSION = P["version"]
STUDY = (ROOT / "studies" / "malqaf_tower.typ").read_text(encoding="utf-8")

def typ_dict(name):
    """#let name = (key: value, ...) on one line → dict of floats (numbers only)."""
    m = re.search(r"#let " + re.escape(name) + r"\s*=\s*\((.*?)\)\s*//", STUDY)
    return {k: float(v) for k, v in re.findall(r"([\w-]+):\s*(-?[\d.]+)", m.group(1))}

TW = typ_dict("tw")                                    # x0, y0, w, the head's parts
VARIANTS = {m.group(1): (m.group(2), float(m.group(3)), m.group(4)) for m in re.finditer(r'\(id: "(\w+)", head: "(\w)", h: ([\d.]+), top: "(\w+)"', STUDY)}
RD = P["roof_design"]
T_OUT = P["walls"]["outer"]
RFIN = 7.3
ZR = 7.2
OUTLINE = Polygon([(0, 0), (10.461, 0), (13.311, 5.245), (13.311, 24.0), (0, 24.0)])
OUTER = OUTLINE.buffer(T_OUT / 2, join_style=2)
RING = OUTER.difference(OUTLINE.buffer(-T_OUT / 2, join_style=2))
M = np.array([[1, 0, 0, 0], [0, 0, 1, 0], [0, 1, 0, 0], [0, 0, 0, 1]], dtype=float)   # plan (x, y, z up) → GLB (x, z, y): the frame of build_3d.py

def ext(poly, z0, z1, rgb):
    parts = list(poly.geoms) if poly.geom_type == "MultiPolygon" else [poly]
    ms = []
    for p in parts:
        if p.area < 1e-6:
            continue
        m = trimesh.creation.extrude_polygon(p, z1 - z0)
        m.apply_translation((0, 0, z0))
        ms.append(m)
    m = trimesh.util.concatenate(ms)
    m.apply_transform(M)
    m.visual.vertex_colors = np.tile(np.array(list(rgb) + [255], dtype=np.uint8), (len(m.vertices), 1))
    return m

def face_panel(shape, face, z0, rgb):
    """A 2D opening shape (u along the face from its left end, v up from z0) laid 5 mm proud of one tower face, 20 mm thick."""
    x0, y0, w = TW["x0"], TW["y0"], TW["w"]
    m = trimesh.creation.extrude_polygon(shape, 0.02)      # in (u, v, depth)
    v = m.vertices.copy()
    u, vv, o = v[:, 0], v[:, 1] + z0, v[:, 2] - 0.008          # o: outwards from the face, −8 … +12 mm
    if face == "N":   X, Y = x0 + u, y0 - o
    elif face == "S": X, Y = x0 + w - u, y0 + w + o
    elif face == "W": X, Y = x0 - o, y0 + w - u
    else:             X, Y = x0 + w + o, y0 + u
    m.vertices = np.column_stack([X, Y, vv])
    # (no fix_normals: the viewer draws both sides)
    m.apply_transform(M)
    m.visual.vertex_colors = np.tile(np.array(list(rgb) + [255], dtype=np.uint8), (len(m.vertices), 1))
    return m

def opening_shapes(head, ho):
    """The openings of one face: (a) one semicircular arch, (b) the Yazd slots, (c) slots with small semicircular tops."""
    w = TW["w"]
    def arch(cx, width, height):
        r = width / 2
        pts = [(cx - r, 0), (cx + r, 0), (cx + r, height - r)] + [(cx + r * math.cos(t), height - r + r * math.sin(t)) for t in np.linspace(0, math.pi, 17)[1:-1]] + [(cx - r, height - r)]
        return Polygon(pts)
    if head == "a":
        return [arch(w / 2, TW["a-w"], ho)]
    n, sw, rib = (int(TW["b-n"]), TW["b-w"], TW["b-rib"]) if head == "b" else (int(TW["c-n"]), TW["c-w"], TW["c-rib"])
    total = n * sw + (n - 1) * rib
    xs = [(w - total) / 2 + k * (sw + rib) + sw / 2 for k in range(n)]
    return [box(x - sw / 2, 0, x + sw / 2, ho) if head == "b" else arch(x, sw, ho) for x in xs]

def levels(h):
    top = TW["attic-top"] + h
    c0 = top - TW["crown"]
    hb = c0 - (TW["head-25"] if h < 3 else TW["head-35"])
    band0 = hb - TW["band"]
    return top, c0, hb, band0

def tower_meshes(vid):
    head, h, top_kind = VARIANTS[vid]
    top, c0, hb, band0 = levels(h)
    x0, y0, w = TW["x0"], TW["y0"], TW["w"]
    sq = box(x0, y0, x0 + w, y0 + w)
    stone, dark, plaster = (200, 160, 100), (32, 32, 34), (236, 226, 204)
    out = {}
    out["chr_base_stone_malqaf_shaft"] = ext(sq, RFIN, band0, stone)
    out["chr_base_stone_malqaf_band"] = ext(sq.buffer(TW["band-proj"], join_style=2), band0, hb, stone)
    out["chr_base_stone_malqaf_head"] = ext(sq, hb, c0, stone)
    out["chr_base_stone_malqaf_crown1"] = ext(sq.buffer(0.05, join_style=2), c0, c0 + 0.12, stone)
    out["chr_base_stone_malqaf_crown2"] = ext(sq.buffer(0.10, join_style=2), c0 + 0.12, top, stone)
    ho = (c0 - hb) - 2 * TW["margin"]
    voids = [face_panel(s, f, hb + TW["margin"], dark) for f in "NESW" for s in opening_shapes(head, ho)]
    out["chr_base_steel_malqaf_openings"] = trimesh.util.concatenate(voids)
    if top_kind == "dome":
        r = TW["dome-r"]
        nr, ns = 8, 24                                   # a hemisphere from rings (no scipy needed)
        V = [(r * math.cos(math.pi / 2 * i / nr) * math.cos(2 * math.pi * j / ns), r * math.cos(math.pi / 2 * i / nr) * math.sin(2 * math.pi * j / ns), r * math.sin(math.pi / 2 * i / nr)) for i in range(nr) for j in range(ns)] + [(0, 0, r)]
        F = [f for i in range(nr - 1) for j in range(ns) for f in ((i * ns + j, i * ns + (j + 1) % ns, (i + 1) * ns + (j + 1) % ns), (i * ns + j, (i + 1) * ns + (j + 1) % ns, (i + 1) * ns + j))]
        F += [((nr - 1) * ns + j, (nr - 1) * ns + (j + 1) % ns, nr * ns) for j in range(ns)]
        dome = trimesh.Trimesh(vertices=V, faces=F, process=False)
        dome.apply_translation((x0 + w / 2, y0 + w / 2, top + 0.06))
        drum = trimesh.creation.cylinder(radius=r, height=0.06, sections=24); drum.apply_translation((x0 + w / 2, y0 + w / 2, top + 0.03))
        d = trimesh.util.concatenate([dome, drum]); d.apply_transform(M)
        d.visual.vertex_colors = np.tile(np.array(list(stone) + [255], dtype=np.uint8), (len(d.vertices), 1))
        out["chr_base_stone_malqaf_dome"] = d
    # hidden: the plenum behind the coping (the slim shaft's top → the tower's foot) and the HRV plant room behind the attic
    plen = Polygon(PLENUM).intersection(OUTLINE.buffer(-T_OUT / 2, join_style=2))
    out["chr_base_plaster_malqaf_plenum"] = ext(plen, RFIN, TW["plenum-top"], plaster)
    out["chr_base_plaster_malqaf_plant"] = ext(box(*PLANT), RFIN, TW["plant-top"], plaster)
    out["roof_patch_old_tower"] = ext(box(8.95 - 0.13, -0.13, 10.375 + 0.13, 1.13).intersection(OUTLINE.buffer(-T_OUT / 2, join_style=2)), ZR - 0.2, RFIN, plaster)
    return out

PLENUM = [tuple(map(float, p)) for p in re.findall(r"\((-?[\d.]+), (-?[\d.]+)\)", re.search(r"#let plenum = \((.*?)\)\s*//", STUDY).group(1))]
PLANT = tuple(float(v) for v in re.search(r"#let plant = \(([^)]*)\)", STUDY).group(1).split(","))

def roofline(tower_fp):
    """The roofline meshes of build_3d.py, rebuilt without the cuts for the present tower and its HRV base (only the new tower cuts the attic)."""
    cn, bd, cop_n, at = RD["cornice"], RD["band"], RD["coping_north"], RD["attic"]
    north_half = box(-10, -10, 40, at["y_south"])
    coping_ring = lambda ov: OUTER.buffer(ov, join_style=2).difference(OUTLINE.buffer(-T_OUT / 2 - ov, join_style=2))
    cut = tower_fp.buffer(0.01, join_style=2)
    stone, plaster = (200, 160, 100), (236, 226, 204)
    attic_in = OUTLINE.buffer(-(at["setback"] - T_OUT / 2), join_style=2).intersection(north_half)
    attic_ring = attic_in.difference(attic_in.buffer(-at["thickness"], join_style=2)).difference(cut)
    for d in at["doors"]:
        a = [float(v) for v in d[0].split()]
        (ax, ay), (bx, by) = (a[0], a[1]), (a[2], a[3])
        L = math.hypot(bx - ax, by - ay); ux, uy = (bx - ax) / L, (by - ay) / L; h = (at["thickness"] + 0.02) / 2
        attic_ring = attic_ring.difference(Polygon([(ax - uy * h, ay + ux * h), (bx - uy * h, by + ux * h), (bx + uy * h, by - ux * h), (ax + uy * h, ay - ux * h)]))
    attic_cop = attic_in.buffer(at["overhang"], join_style=2).difference(attic_in.buffer(-at["thickness"] - at["overhang"], join_style=2)).difference(cut)
    return {"roof_cornice": ext(OUTER.buffer(cn["proj"], join_style=2).difference(OUTER), cn["z0"], cn["z0"] + cn["h"], stone),
            "ff_band": ext(OUTER.buffer(bd["proj"], join_style=2).difference(OUTER), bd["z0"], bd["z0"] + bd["h"], stone),
            "roof_parapet_n": ext(RING.intersection(north_half), RFIN, cop_n["wall_top"], plaster),
            "roof_coping_n": ext(coping_ring(cop_n["overhang"]).intersection(north_half), cop_n["wall_top"], cop_n["top"], stone),
            "roof_attic_wall": ext(attic_ring, ZR, at["wall_top"], plaster),
            "roof_attic_coping": ext(attic_cop, at["wall_top"], at["top"], stone)}

DROP = re.compile(r"^(roof_air_|chr_base_timber_malqaf_louvres$|roof_cornice$|ff_band$|roof_parapet_n$|roof_coping_n$|roof_attic_wall$|roof_attic_coping$)")

def build(vid):
    sc = trimesh.load(HERE / "output" / f"taif_house_{VERSION}.glb")
    keep = {n: g for n, g in sc.geometry.items() if not DROP.match(n)}
    fp = box(TW["x0"], TW["y0"], TW["x0"] + TW["w"], TW["y0"] + TW["w"])
    keep.update(roofline(fp))
    keep.update(tower_meshes(vid))
    new = trimesh.Scene()
    for n, g in keep.items():
        new.add_geometry(g, node_name=n, geom_name=n)
    return new.export(file_type="glb")

CROP = (450, 0, 1150, 550)

def render(vid):
    js_src = (HERE / "output" / f"taif_house_{VERSION}.js").read_text(encoding="utf-8")
    glb = base64.b64encode(build(vid)).decode("ascii")
    js = re.sub(r'"glb": "[A-Za-z0-9+/=]+"', '"glb": "' + glb + '"', js_src, count=1)
    tmp_js = HERE / "output" / f"_malqaf_{vid}.js"
    tmp_html = HERE / f"_malqaf_{vid}.html"
    tmp_js.write_text(js, encoding="utf-8")
    tmp_html.write_text((HERE / "viewer.html").read_text(encoding="utf-8").replace(f"output/taif_house_{VERSION}.js", f"output/_malqaf_{vid}.js")
                        .replace("new THREE.Plane(new THREE.Vector3(0, -1, 0), 10)", "new THREE.Plane(new THREE.Vector3(0, -1, 0), 100)")
                        .replace("cutPlane.constant = h;", "cutPlane.constant = h >= 10 ? 100 : h;"), encoding="utf-8")   # the viewer's "cut off" still clips above +10.0: lifted in this copy for the taller towers
    out = HERE / "output" / f"malqaf_gate_{vid}.png"
    out.unlink(missing_ok=True)
    browser = next(p for p in (r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe", r"C:\Program Files\Google\Chrome\Application\chrome.exe") if Path(p).exists())
    try:
        for attempt in (1, 2):
            try:
                subprocess.run([browser, "--headless=new", "--disable-gpu", "--use-angle=swiftshader", "--enable-unsafe-swiftshader", "--hide-scrollbars",
                                "--window-size=1400,900", "--timeout=15000", f"--screenshot={out}", tmp_html.as_uri() + "?view=gate&character=1&ui=0"], capture_output=True, timeout=240)
            except subprocess.TimeoutExpired:
                pass
            if out.exists():
                break
    finally:
        tmp_js.unlink(missing_ok=True); tmp_html.unlink(missing_ok=True)
    if out.exists():                                         # the frame of the study: the tower and the north facade (x 450–1150, y 0–550 of the 1400 × 900 screenshot)
        from PIL import Image
        Image.open(out).crop(CROP).save(out)
    print(("wrote " if out.exists() else "FAILED ") + str(out.relative_to(ROOT.parent)))

if __name__ == "__main__":
    for vid in (sys.argv[1:] or list(VARIANTS)):
        render(vid)

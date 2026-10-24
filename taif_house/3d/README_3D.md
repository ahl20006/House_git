# 3D model · Taif / Palm House V6.2 · phases 1–2

The 3D model is **generated from the project files, never edited by hand**. One script reads the room data and the design files and builds the model; any change in the CSVs → run the script again → the 3D updates.

## What the model contains (phases 1–2)
- **Slabs:** ground slab (−0.20 … ±0.00), first-floor slab (+3.40 … +3.60) with the courtyard sky and the double-height living cut out and the 1.35 m west projection included, roof slab (+7.00 … +7.20) with the courtyard sky and the suite court cut out.
- **Outer walls** of both floors, 0.25 m, centred on the pentagon outline (the north-east cut wall included), floor to the underside of the slab above.
- **Interior walls** of both floors, 0.20 m (also the maid-wing partitions), on the room edges (wall centre lines), full storey height. Edges shared by two rooms give one wall. Walls meeting another wall are lengthened by half a thickness to close the corner.
- **Open edges** (`open_edges.csv`): room edges with no wall, left open. The living room's low partition to the riwaq is built 1.20 m high.
- **Voids:** the courtyard open to the sky through both slabs; the double-height living open from the ground floor to the roof.
- Not yet (later phases): doors and windows (3), columns and the edge beam (4, after the structural study), stair, lift, air tower head, railings and parapets (5), IFC/OBJ export (6), site, materials, furniture. The stair, lift shaft, west shaft and air tower are drawn as walled boxes with floor over them for now; their slab openings come with phase 5.

## Files
| File | What it is |
|---|---|
| `params.yaml` | every dimension the model uses (levels, slab and wall thicknesses, the projection width) and the source paths; nothing is hard-coded in the script |
| `build_3d.py` | builds the model → `output/taif_house_V6.2.glb`, `output/taif_house_V6.2.js` (the GLB as base64 for the viewer), `output/model_summary.json` |
| `open_edges.csv` | the room edges that have no wall (or a low wall), with the source of each |
| `check_3d.py` | the checks (below); also run by `tools/check.py` |
| `viewer.html` + `lib/` | the viewer (three.js r147, vendored, works offline from the repo) |
| `render_views.py` | screenshots with headless Edge → `output/view_nw.png`, `view_se.png`, `view_top_noroof.png` |

## How to run
```
pip install trimesh shapely numpy pyyaml mapbox_earcut
python taif_house/3d/build_3d.py       # build the GLB
python taif_house/3d/check_3d.py       # check it (3D CHECKS PASSED)
python taif_house/3d/render_views.py   # screenshots (Windows, Microsoft Edge)
```
`python taif_house/tools/check.py` runs the build and the checks as its step 6.

**Viewer:** open `taif_house/3d/viewer.html` in a browser (double-click; no server needed). Left drag orbits, the wheel zooms, right drag pans. Toggles hide the first floor (its walls and slab) and the roof; the slider cuts the model horizontally at any height. URL options for screenshots: `?view=nw|se|top&roof=0&ff=0&cut=5&ui=0`.

## Frame and units
- Metres. The model is in the **CSV frame** of the plans: origin = the building's north-west wall corner, x east, y south (the DXFs are in the site frame, shifted by (0.91, 3.525) m; the 3D is not shifted).
- The GLB is Y-up as glTF expects: **X = east, Y = height, Z = south** (= the plans' y). This keeps the model right-handed (not mirrored): north is −Z.

## Parameters (params.yaml)
| Parameter | Value | Note |
|---|---|---|
| GF floor | ±0.00 | |
| FF floor | +3.60 | to confirm with the engineer |
| roof | +7.20 | to confirm |
| slab thickness | 0.20 | ground, first floor and roof |
| outer walls | 0.25 | on the outline centre line |
| inner walls | 0.20 | all, incl. the maid-wing partitions |
| low partition | 1.20 | the living's partition to the riwaq |
| parapet height | 1.10 | placeholder, phase 5 |
| projection width | 1.35 | checked against proj-x in `studies/ff_family.typ` |

## What is read from where
- `data/rooms_gf.csv`, `data/rooms_ff.csv`: every room, rectangles or `pts` polygons (`#` switches a row off).
- `design_gf.typ`: the outline (`outline-csv-gf`) and the air tower polygon (`tower-pts`).
- `studies/ff_family.typ`: the projection edge (`proj-x`) and the first-floor fixed elements (`fixed`: stair, lift shaft, west shaft, air tower).
- The voids are the ground-floor courtyard and double-height living polygons east of the projection edge; the roof hole over the suite court is the court's own polygon.

## Open edges (open_edges.csv)
| Floor | Edge (x1 y1 – x2 y2) | What | Height |
|---|---|---|---|
| GF | 8.95 13.0 – 8.95 19.25 | ceiling-height change between the double-height living and the dining: one room, no wall | open |
| GF | 4.25 13.1 – 4.25 14.5 | living room entrance from the riwaq, 1.40 m, no door | open |
| GF | 4.25 14.5 – 4.25 19.25 | living room low partition to the riwaq | **1.20 m** |
| GF | 2.75 10.6 – 2.75 12.7 | hospitality kitchen open to the riwaq | open |
| GF | 2.75 13.0 – 2.75 14.3 | family basins open to the riwaq | open |
| GF | 2.75 0.2 – 2.75 2.0 | entry cupboard open to the family lobby | open |
| GF | 2.75 2.4 – 2.75 6.8 | open stair, no door (railing in phase 5) | open |
| GF | 9.7 6.5 – 10.55 6.5 | kitchen ↔ laundry open entrance | open |
| GF | 2.75 22.15 – 2.75 23.95 | foyer → men's majlis, 1.80 m opening | open |
| GF | 1.25 19.85 – 1.25 21.4 | guest passage open to the guest basins | open |
| GF | 0.1 21.4 – 1.15 21.4 | guest passage open to the foyer | open |
| FF | 0 7.9 – 2.75 7.9 | landing: the stair arrives here | open |
| FF | 2.75 7.9 – 2.75 9.2 | landing open to the gallery | open |
| FF | 2.75 2.2 – 2.75 7.9 | gallery beside the stair well (railing in phase 5) | open |
| FF | 4.25 3.1 – 4.25 4.5 | family living open to the gallery | open |
| FF | 8.95 5.3 – 8.95 6.5 | family link open to the family living | open |
| FF | 4.25 6.5 – 8.95 6.5 | family living edge on the courtyard sky (balustrade in phase 5) | open |
| FF | 5.6 6.5 – 5.6 19.25 | gallery edge on the courtyard sky and the double-height void (railing in phase 5) | open |
| FF | 4.25 19.25 – 5.6 19.25 | gallery south end → gym route | open |
| FF | 0.1 11.0 – 1.4 11.0 | wardrobe niche open to bedroom 2 | open |

Everything else on a room edge is a wall: doors and windows sit in walls and come with phase 3 (so the courtyard glazing and the clerestory windows are solid walls for now). The suite court is open to the sky (a hole in the roof); its four sides are walls. The line between the two voids (y 13.0, x 5.6–8.95) belongs to no room on the first floor, so nothing is built there.

## Checks (check_3d.py)
1. Every room of both floors is enclosed: each piece of every room edge is on the outline, on a built wall or on a listed open edge; every open edge lies on a room edge.
2. No two walls of a floor overlap; every wall is 0.20 m thick (measured in the GLB) and runs from the floor to the underside of the slab above (or 1.20 m for the low partition); the outer ring is 0.25 m.
3. Slab areas measured in the GLB: ground slab = CSV rooms + courtyard + air tower (309.68 m²); first-floor slab = CSV rooms + suite court + the fixed elements = outline − courtyard sky − double-height void (266.97 m²); roof = outline − courtyard sky − suite court (275.94 m²); the voids equal the courtyard and the living east of x 5.6 (21.78 + 20.94 m²).
4. The model's plan extent is the outline plus half the outer wall (13.561 × 24.25 m) and its levels are those of `params.yaml`.

## Phases
| Phase | Content | State |
|---|---|---|
| 1 | setup, params, slabs, outer walls, voids, viewer | done (tag `3d-p2`) |
| 2 | interior walls, open edges, low partition, checks | done (tag `3d-p2`) |
| 3 | doors and windows | to do |
| 4 | columns and the edge beam (after the structural study) | to do |
| 5 | stair, lift, air tower head, railings and parapets, slab openings | to do |
| 6 | IFC / OBJ export | to do |

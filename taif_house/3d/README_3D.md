# 3D model · Taif / Palm House V6.2 · phases 1–3

The 3D model is **generated from the project files, never edited by hand**. One script reads the room data, the design files, the two first-floor studies, the presentation's door and window lists and the structural study, and builds the model; any change in those files → run the script again → the 3D updates.

**Every structural element in the model is marked:** orange = *assumed, not approved by the engineer* (sizes from `studies/structure.typ`), red = *unconfirmed load path* (X5). Nothing here is a structural design.

## What the model contains (phases 1–3)
- **Slabs** at structural levels: ground slab (−0.28 … −0.08), first-floor slab (+3.32 … +3.52) with the courtyard sky, the double-height living and the L-shaped stair opening cut out, roof slab (+7.00 … +7.20) with the courtyard sky and the suite court cut out. The slabs run to the **outer face** of the outer walls. **Floor finishes** 0.08 on both floors (to ±0.00 and +3.60) and a 0.10 roof finish (to +7.30).
- **Outer walls** of both floors, 0.25 m, centred on the pentagon outline; **interior walls** 0.20 m on the room edges, from the structural slab top to the underside of the slab above; the living's low partition 1.20 m; **open edges** (`open_edges.csv`) left open.
- **Doors and windows of both floors**, cut through the walls with their sill and lintel pieces: 28 doors (leaves modelled closed; the courtyard glass door and the suite court door as glass) and 31 windows (glass, transparent in the viewer), among them the courtyard glazing (full height under the beams), the living glazing split by column C22, the two clerestory windows at +5.00 … +6.00, the kitchen service door and the suite bath's 0.60 m east window (X3). Heights are assumed in `params.yaml` (the plans have none yet).
- **The stair** exactly as drawn in `studies/structure.typ`: two flights of 1.21 m side by side, 22 risers × 0.164, goings 0.28, the half landing at +1.80 (store below, 1.57 m clear), the arrival at +3.60 on the first-floor slab, the L-shaped opening (≈ 8.2 m²), the trimmers B16–B18 (0.20 × 0.40 total, soffit +3.12), the balustrades (0.90 above the nosings) and the first-floor railings round the well (1.10). The headroom over every tread is checked to the underside of the beams / slab.
- **The colonnade – gallery zone:** the three colonnade columns C21–C23 (Ø0.30) from the ground slab to the roof (X8), the edge beam B3 **upturned** on x 5.6 (0.25 × 0.50 total: 0.30 above the structural slab, 0.22 above the finished gallery floor) with the gallery railing on it, the dining-step beam B5 under the suite wall (soffit +2.97), the roof edge beam R11 over the gallery strip; column C33 in the east wall (for the X3 check). **R6** (the gym roof beam on the two gym walls over the men's majlis ribs) and those two walls are **red: unconfirmed** (X5).
- **Railings** 1.10 m on the gallery edge (on the upturned beam), the family living's courtyard edge and the stair well.
- **Coloured room plates** (by room type) with the room names in the plan views; **sun positions** for Taif at 9:00 / 12:00 / 15:00 in summer and winter with shadows; three **eye-level bookmarks**.
- **The air system v2** (`studies/air_system.typ`, all assumed, orange): the dry tower head 2.5 m above the roof with its two louvred openings and the cap, the shaft open through both slabs, the tower base pit to −1.95, the small dry duct (route A, 0.9 box, top −1.00) under the women's majlis, the outlet chamber under the courtyard floor with its sealed cover, and the grille in the courtyard's north wall (+0.2 … +0.8). No water, no floor opening. The main ventilation system (ERV, exhausts, AC) is not modelled: the MEP engineer designs it. View "air system (underground)" (`?view=top_air`: the cut at −0.3 shows only what lies below the ground slab) → `output/plan_air.png`.
- Not yet (later phases): the rest of the structure (all columns and beams, ribbed slabs, 0.22 flat roof over the void: phase 4), lift, air tower head, parapets and the roof railing on the suite court edge (phase 5), IFC/OBJ export (6), site, materials, furniture.

## Levels: structural and finished
| | Finished (plans, sections) | Structural slab top | Slab | Underside |
|---|---|---|---|---|
| ground floor | ±0.00 | −0.08 | −0.28 … −0.08 | — |
| first floor | +3.60 | +3.52 | +3.32 … +3.52 | +3.32 |
| roof | +7.30 (finish top) | +7.20 | +7.00 … +7.20 | +7.00 |

The **finished** levels are the levels of the plans and sections (±0.00, +3.60); the **structural** slab top lies one floor finish (0.08, assumed: screed + tiles) below them. Slabs and beams are modelled at structural levels; doors, windows, the stair (risers, half landing, arrival) and the railing heights at finished levels. So a beam of 0.55 total depth under the first floor has its soffit at +2.97 = 2.97 m above the finished ground floor (the structural study quotes 3.05 "before finishes"; the difference is the finish). The engineer fixes the final levels (`docs/OPEN_ITEMS.md` item 6).

**Slab thicknesses:** 0.20 everywhere in the model for now. The structural study proposes 0.30 ribbed slabs for the 4.36–4.75 m bays (kitchen and dining roofs, men's majlis roof, suite, office) and a 0.22 flat roof over the double-height living; they are modelled when the structure is added (phase 4).

**The white dots of phase 2** along the slab lines were real: the slabs stopped at the wall centre line, 0.125 m inside the outer face, leaving a groove where the ends of the interior walls met the slab edge. The slabs now run to the outer face; the check confirms the plan extent of every slab and that every wall end meets another wall, the outer wall or an open edge.

## Files
| File | What it is |
|---|---|
| `params.yaml` | every dimension the model uses (levels, finishes, slab and wall thicknesses, opening heights, railing heights, stair waist, the marked structural elements, the sun and the bookmarks) and the source paths; nothing is hard-coded in the script |
| `build_3d.py` | builds the model → `output/taif_house_V6.2.glb`, `output/taif_house_V6.2.js` (the GLB as base64 + rooms, flags, sun, bookmarks for the viewer), `output/model_summary.json` |
| `open_edges.csv` | the room edges that have no wall (or a low wall), with the source of each |
| `check_3d.py` | the checks (below); also run by `tools/check.py` |
| `viewer.html` + `lib/` | the viewer (three.js r147, vendored, works offline from the repo) |
| `render_views.py` | screenshots with headless Edge → `output/view_nw.png`, `view_se.png`, `plan_gf.png`, `plan_ff.png`, `plan_air.png`, `eye1.png` … `eye3.png`, `sun_summer_09.png` … `sun_winter_15.png` |

## How to run
```
pip install trimesh shapely numpy pyyaml mapbox_earcut
python taif_house/3d/build_3d.py       # build the GLB
python taif_house/3d/check_3d.py       # check it (3D CHECKS PASSED + the flagged items)
python taif_house/3d/render_views.py   # screenshots (Windows, Microsoft Edge)
```
`python taif_house/tools/check.py` runs the build and the checks as its step 6.

**Viewer:** open `taif_house/3d/viewer.html` in a browser (double-click; no server needed). Left drag orbits, the wheel zooms, right drag pans. Buttons: north-west / south-east overviews, **plan GF / plan FF** (orthographic, room colours and names, cut 1.5 m above the floor), **eye 1–3** (eye level 1.6 m: inside the double-height living looking north to the courtyard; from the courtyard looking west to the colonnade and the gallery; from the stair landing along the gallery); a **sun** menu (Taif, true north from `base.typ`) switches on the shadows. Toggles hide the first floor and the roof; the slider cuts the model at any height; the flags are listed in the panel. URL options for screenshots: `?view=nw|se|top|top_gf|top_ff|eye1|eye2|eye3&roof=0&ff=0&cut=5&sun=winter-12&labels=0&ui=0`.

## Frame and units
- Metres. The model is in the **CSV frame** of the plans: origin = the building's north-west wall corner, x east, y south (the DXFs are in the site frame, shifted by (0.91, 3.525) m; the 3D is not shifted).
- The GLB is Y-up as glTF expects: **X = east, Y = height, Z = south** (= the plans' y). This keeps the model right-handed (not mirrored): the plans' north is −Z.
- **True north** (`base.typ`, `#let north`) is 21.4° east of the plans' north; the sun positions use it (the north arrow in the viewer shows it).

## Parameters (params.yaml)
| Parameter | Value | Note |
|---|---|---|
| finished levels | ±0.00 / +3.60 / roof slab top +7.20 | to confirm with the engineer |
| floor finish / roof finish | 0.08 / 0.10 | assumed |
| slab thickness | 0.20 | everywhere for now (see above) |
| outer / inner walls | 0.25 / 0.20 | on the centre lines |
| low partition | 1.20 | the living's partition to the riwaq |
| doors | 2.10 high | all doors; the future lift door is not cut |
| windows | sill 0.90 / head 2.10 | default; the courtyard glazing 0.00–2.90, kitchen 1.10–2.10, bath and maid windows 1.50–2.10, majlis high windows 1.80–2.90, clerestory +5.00–6.00 … listed in params |
| railing / handrail | 1.10 / 0.90 | above the finished floor / above the nosings |
| headroom | ≥ 2.10 | over every tread, to the underside of the beams / slab |
| stair waist | 0.15 | flight slabs |
| projection width | 1.35 | checked against proj-x in `studies/ff_family.typ` |
| sun | 21.4° N, 21 Jun / 21 Dec, 9 · 12 · 15 h | solar time |

## What is read from where
- `data/rooms_gf.csv`, `data/rooms_ff.csv`: every room, rectangles or `pts` polygons (`#` switches a row off).
- `design_gf.typ`: the outline (`outline-csv-gf`) and the air tower polygon (`tower-pts`).
- `studies/ff_family.typ`: the projection edge (`proj-x`) and the first-floor fixed elements (`fixed`: stair, lift shaft, west shaft, air tower).
- `presentation.typ`: the ground-floor doors (`gf-doors`, with their kind: hinged / sliding / double / open) and windows (`gf-windows`).
- `studies/ff_family.typ`, `studies/ff_suite.typ`: the first-floor doors (`doors`, `D(...)`) and windows (`windows`).
- `studies/structure.typ`: the stair (`st`), the columns (`columns`) and the beams (`beams-ff`, `beams-roof`) used in this phase.
- `studies/sections.typ`: the clerestory levels (`cl-sill`, `cl-head`) and the latitude; `base.typ`: true north; `studies/east_wing.typ`: the kitchen fixtures (service door check).
- `studies/air_system.typ`: every `#let air-*` tuple (tower, head, base, route, duct, clear, invert, chamber, cover, grille).
- Doors of the plans that lie on an open edge (no leaf) cut nothing; the open edges are in `open_edges.csv`.

## Checks (check_3d.py)
1. Every room of both floors is enclosed: each piece of every room edge is on the outline, on a built wall or on a listed open edge.
2. Walls: no overlaps, every wall 0.20 m (measured in the GLB), from the structural slab top to the slab underside (or 1.20 m); the outer ring 0.25 m; **no gaps**: every wall end meets another wall, the outer wall or an open edge.
3. Slab areas measured in the GLB: GF = outline + half the outer wall (318.77 m²); FF = the same minus the courtyard sky, the double-height void and the stair opening (267.85 m²); roof minus the courtyard sky and the suite court (285.02 m²); inside the outline the floors equal the CSV rooms (309.68 m²); the voids 21.77 + 20.94 m², the stair opening 8.21 m².
4. The plan extent is the outline plus half the outer wall (13.561 × 24.25 m); the levels are those of `params.yaml` (finished and structural).
5. Doors and windows: every door and window of the plans is built (28 + 31), or lies on an open edge, or is listed as skipped; every opening sits in a wall with its head below the slab; the clerestory windows at the levels of `studies/sections.typ`; the kitchen service door clear of the counters (the cooking counter starts 0.10 m south of it) and of the columns (C32 +0.40 m); the X3 window / column C33 clearance is reported as a flag (−0.05 m with the assumed 0.25 × 0.60 column along the wall: a clash that the engineer resolves by the column's size, not hidden).
6. The stair: 22 risers to +3.60, the top riser on the first-floor slab (the arrival strip), the opening edged by the trimmers, the headroom over every tread ≥ 2.10 m (minimum 2.14 m under B16; the study's 2.22 m before finishes).
7. The structure of the zone: the colonnade from the ground slab to the roof underside (X8), the upturned edge beam and the railing on it, B5's soffit, R6 and the gym walls flagged unconfirmed.
8. The sun: the noon altitudes equal the formulas of `studies/sections.typ` (winter 45.2°, summer 88.0°), 9:00 / 15:00 symmetric.
9. The air system: the duct runs only under the women's majlis and the tower (and the courtyard's north wall at its mouth); the chamber inside the courtyard east of the projection edge; clear of the assumed pads of C21, C25, C26 (C24 / C30 stand on the tower base pit); the duct top under the assumed tie beams (−0.90); the head 2.5 m above the roof; the shaft open through both slabs; the outlet a wall grille, no floor opening and no water.
It ends with `3D CHECKS PASSED` and the list of **flags**, or the problems. `ALL CHECKS PASSED` (tools/check.py) means the model is consistent with the files; it does not mean anything was calculated.

## Phases
| Phase | Content | State |
|---|---|---|
| 1 | setup, params, slabs, outer walls, voids, viewer | done (tag `3d-p2`) |
| 2 | interior walls, open edges, low partition, checks | done (tag `3d-p2`) |
| 3 | doors and windows, the stair with its opening and trimmers, the colonnade – gallery – living zone (columns, edge beam, B5, R6, R11), railings, finished / structural levels, plan views, eye-level bookmarks, sun and shadows | done (tag `3d-p3`) |
| 4 | the whole structure from the structural study (all columns and beams, ribbed slabs, the 0.22 roof over the void), marked assumed until the engineer approves | to do |
| 5 | lift, air tower head, parapets and the roof railing, the remaining railings | to do |
| 6 | IFC / OBJ export | to do |

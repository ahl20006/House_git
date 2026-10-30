# 3D model · Taif / Palm House V6.3 · phases 1–3 + character study

The 3D model is **generated from the project files, never edited by hand**. One script reads the room data, the design files, the two first-floor studies, the presentation's door and window lists and the structural study, and builds the model; any change in those files → run the script again → the 3D updates.

**Every structural element in the model is marked:** orange = *assumed, not approved by the engineer* (sizes from `studies/structure.typ`), red = *unconfirmed load path* (X5). Nothing here is a structural design.

**The character study** (tags `3d-char1`, `3d-char2`, `3d/character.yaml`) is a **STYLE STUDY, PROVISIONAL**: materials and a few added elements for the owner to compare in the viewer; the viewer says so on every view. It changes nothing in the design files, the room CSVs or `params.yaml`; see § Character study below. Revision 2 (`3d-char2`): lighter, warmer colours; the views rendered with the sun and shadows; the malqaf outlet on the kitchen wall (an owner decision recorded in `studies/air_system.typ`, `docs/AIR_SYSTEM.md`, `data/decisions.csv`) with the sunken seating under it (variant, on by default).

## What the model contains (phases 1–3)
- **Slabs** at structural levels: ground slab (−0.28 … −0.08), first-floor slab (top +3.52) with the courtyard sky, the double-height living and the L-shaped stair opening cut out, roof slab (top +7.20) with the courtyard sky and the suite court cut out. **Since V6.3 the first-floor and roof bays carry the thickness of `studies/structure.typ`** (`slabs-ff` / `slabs-roof`: 0.30 ribbed over the kitchen, dining, men's majlis, suite and office, 0.22 flat over the double-height void, 0.20 elsewhere), all assumed; the walls run to the 0.20 underside (+3.32 / +7.00) and the thicker bays hang below it (+3.22 / +6.90, +6.98 under the 0.22). The slabs run to the **outer face** of the outer walls. **Floor finishes** 0.08 on both floors (to ±0.00 and +3.60) and a 0.10 roof finish (to +7.30).
- **Outer walls** of both floors, 0.25 m, centred on the pentagon outline; **interior walls** 0.20 m on the room edges, from the structural slab top to the underside of the slab above; **open edges** (`open_edges.csv`) left open. A room edge that lies on the outline with rounded corners (the cut wall: 10.594 for 10.5943) is the outer wall, not a wall of its own (corrected in `3d-char1`: five 0.20 walls were built inside the outer ring along the cut, and the cut wall's four windows were cut through them instead of the outer wall).
- **Doors and windows of both floors**, cut through the walls with their sill and lintel pieces: 28 doors (leaves modelled closed; the courtyard glass door and the suite court door as glass) and 31 windows (glass, transparent in the viewer), among them the courtyard glazing (full height under the beams), the living glazing split by column C22, the two clerestory windows at +5.00 … +6.00, the kitchen service door and the suite bath's 0.60 m east window (X3). Heights are assumed in `params.yaml` (the plans have none yet).
- **The stair** exactly as drawn in `studies/structure.typ`: two flights of 1.21 m side by side, 22 risers × 0.164, goings 0.28, the half landing at +1.80 (store below, 1.57 m clear), the arrival at +3.60 on the first-floor slab, the L-shaped opening (≈ 8.2 m²), the trimmers B16–B18 (0.20 × 0.40 total, soffit +3.12), the balustrades (0.90 above the nosings) and the first-floor railings round the well (1.10). The headroom over every tread is checked to the underside of the beams / slab.
- **The colonnade – gallery zone:** the three colonnade columns C21–C23 (Ø0.30) from the ground slab to the roof (X8), the edge beam B3 **upturned** on x 5.6 (0.25 × 0.50 total: 0.30 above the structural slab, 0.22 above the finished gallery floor) with the gallery railing on it, the dining-step beam B5 under the suite wall (soffit +2.97), the roof edge beam R11 over the gallery strip; column C33 in the east wall (for the X3 check). **R6** (the gym roof beam on the two gym walls over the men's majlis ribs) and those two walls are **red: unconfirmed** (X5).
- **Railings** 1.10 m on the gallery edge (on the upturned beam), the family living's courtyard edge and the stair well.
- **Coloured room plates** (by room type) with the room names in the plan views; **sun positions** for Taif at 9:00 / 12:00 / 15:00 in summer and winter with shadows; three **eye-level bookmarks**.
- **The air system v2.1** (`studies/air_system.typ`, all assumed, orange): the dry tower head 2.5 m above the roof with its two louvred openings and the cap, the shaft open through both slabs, the tower base pit to −1.95, the small dry duct (route E, 0.9 box, top −1.00) south under the maid bath and the laundry on x 10.25, the outlet chamber under the kitchen floor against the kitchen's west wall with its sealed cover in the kitchen floor, the plenum in that wall's base and the grille on its courtyard face (y 7.7–8.7, +0.15 … +0.75) over the sunken seating's bench. No water, no floor opening. The main ventilation system (ERV, exhausts, AC) is not modelled: the MEP engineer designs it. View "air system (underground)" (`?view=top_air`: the cut at −0.3 shows only what lies below the ground slab) → `output/plan_air.png`. The courtyard floor is a mesh of its own (`gf_slab_court`, `gf_finish_court`) so the character study's sunken seating can replace it.
- Not yet (later phases): the rest of the structure (all columns and beams, ribbed slabs, 0.22 flat roof over the void: phase 4), lift, the roof railing on the suite court edge as a design element (phase 5; the character study shows one), IFC/OBJ export (6), site, furniture.

## Character study (style study, provisional)
`3d/character.yaml` → `3d/character_3d.py` (called by `build_3d.py`) adds **53 meshes named `chr_<group>_<material>_<label>`** from the file and the model's own data (openings, columns, beams, voids, the air system). The viewer's **character** toggle shows them and re-colours the model's own meshes by material (`assign` in the yaml: walls plaster, floors light stone, doors timber, railings bronze, the malqaf head stone …); off, the phase-3 model with its orange / red flags is what you see. The plan views always show the plain model. Nothing is edited by hand: change the yaml, run `build_3d.py`.

**Direction:** contemporary, inspired by Taif / Hijazi architecture: clean lines, natural stone, timber, deep shaded openings, a stone colonnade with an upper gallery round a courtyard open to the sky. Simple, not ornate. Flat colours only.

**Light (revision 2):** with the character on, the eye and overview views switch on the **sun with its shadows** (`sun: summer-09` in the yaml: 21 June 9:00, from the east-north-east at 48°, Taif, true north from `base.typ`) over a soft ambient light, so the forms read in light and shade; the viewer's sun menu changes it; the night view switches it off.

| Element | What the study draws | Where set |
|---|---|---|
| materials | cream plaster (light, warm) walls and parapets; warm honey-coloured Taif stone columns, plinth, feature walls, copings, the sunken seating's bench; light natural stone floors; medium warm timber soffit, pergola, screens, doors, louvres; dark bronze frames and railings; glass transparent | `palette`, `assign` |
| plinth | a stone base course 0.6 m high round the outside, 0.04 proud, the three outer doors cut through it | `plinth` |
| deep reveals | the 21 outer-wall windows' glass set back **0.20 m** from the outer face (the base model's centre-line panes are hidden); bronze frames 0.05 on all 31 windows | `reveal`, `frame` |
| colonnade | stone sleeves **Ø0.40** round C21–C23 (the assumed Ø0.30 columns stay inside), plain base and capital bands, from the finished ground floor to the roof underside | `colonnade` |
| soffit | timber soffit 0.05 under the projection (x 4.35–5.725, y 6.6–19.15, +3.27 … +3.32) and a timber fascia on the slab edge and the upturned beam (+3.27 … +3.82) | `soffit` |
| gallery railing on B3 | **A** (default) a plastered parapet 0.25 on the upturned beam, +3.82 → +4.70 with a stone coping; **B** glass with a bronze handrail to +4.70 (toggle) | `gallery_railing` |
| pergola | 5 timber beams 0.10 × 0.25 at 0.6 m over y 6.5–9.5 of the courtyard sky (the women's majlis side), on the roof finish, 8 % of the sky hole (toggle, default on) | `pergola` |
| mashrabiya | timber lattice screens (frame 0.06, slats 0.03 at 0.09 / 0.27) flush with the outer face on 11 windows: FF kids' room north (street); FF bedrooms 2 and 3 and the office west (driveway / street); FF bedroom 1 on the lane (2); FF suite bedroom east (service yard / neighbour); FF suite lobby onto the courtyard (the only first-floor window on the courtyard); GF women's majlis north (street); GF dining east. A proposal: edit the list | `mashrabiya.windows` |
| feature walls | Taif stone cladding 0.03 with the openings cut out: the guest entrance wall (west facade, y 19.25–24, both floors to the coping); the courtyard's east wall (kitchen below, suite lobby above, down to the sunken floor); the courtyard's north wall piers beside the women's majlis glass and the band over it (the glass stays complete) | `feature_walls` |
| malqaf outlet (owner decision, `3d-char2`) | the base model's grille (`gf_air_grille`, from `studies/air_system.typ`) now sits on the courtyard face of the **kitchen's west wall**, y 7.7–8.7, +0.15 … +0.75, directly over the sunken seating's bench; the study re-colours it timber (mashrabiya-type) and adds a stone upstand lip at its sill. The north-wall stone pier of revision 1 (A7 option 2) is removed: A7 is resolved by the move | `assign`, `sunken.upstand` |
| fountain | a simple wall-fountain *shape* on the same east wall **under the kitchen sink window** (sill +1.10), y 9.3–10.9: a stone panel from the sunken floor to +1.05 (0.05 below the sill), a stone trough +0.35 … +0.65 and a bronze spout; 0.60 m south of the grille; its water and drain are air items A8 / A6 | `fountain` |
| **sunken seating** (variant, on by default) | the courtyard floor replaced by a pit **0.45 deep** (3 risers × 0.15, treads 0.30 along the whole west side) against the east wall, x 6.7–8.85, y 7.6–11.9, a built-in stone bench with a timber seat (−0.05) under the grille (the grille 0.20 above the seat, 0.60 above the sunken floor), a low table, an olive in a planter at its south end, a **floor drain at the lowest point and an overflow slot** at −0.40 (both for the MEP engineer, A6). The courtyard edges stay level at every door and glass wall: 1.0 m at the women's majlis glass (north) and the living glass (south), 2.35 m to the riwaq glass (west), and the check refuses a pit nearer than 1.0 m to any floor-level opening on the courtyard. Off, the base model's level courtyard floor shows | `sunken` |
| roof | a 1.0 m parapet on the outer walls from the roof finish with a stone coping (+8.30); bronze railings 1.1 m round the courtyard sky and the suite court (the gym roof edge stays a railing, V6.2); the malqaf head stone with timber louvre slats | `roof`, `malqaf_louvres` |
| props (scale only) | two hanging lanterns under the soffit edge between the columns (the olive, the bench and the table belong to the sunken seating) | `props` |
| **TV wall** (V6.3, owner) | the living's west wall solid and full height (a base-model wall since V6.3); the character layer adds the 1.40 m entrance arch's head (+2.60, semicircular), the TV niche's 0.25 m pier, its 0.10 m arched face plate (4.40 wide, crown +3.10, segmental rise 0.45) and soffit, the low cabinet, the 85″ screen and the side shelves. The arches variant of r1–r2 is removed: **no arches between the colonnade columns** | `tv_wall` |
| views | living (inside the double-height living, looking north to the courtyard and the sunken seating), street (the guest entrance facade from the west, the driveway side), north facade, aerial from the south-west, the courtyard at night (lanterns, warm room lights, the glass glowing, a low light at the fountain) | `views`, `night` |

**What is not a decision here:** every colour and element; the stone sleeve is cladding, not a column size; the arches are decorative; the fountain is a shape (its water and drain are for the MEP engineer, A8 / A6); the sunken seating is a variant whose drain, overflow and waterproofing are for the MEP and structural engineers; the pergola's bearing on the roof edge beams is for the engineer if it stays. The malqaf outlet's position is an owner decision (`data/decisions.csv`), its sizes stay assumed.

**Renders** (`render_views.py`, headless Edge, the sun on): `output/char_eye2.png` (from the courtyard looking west to the colonnade), `char_living.png` (inside the double-height living looking to the courtyard and the sunken seating; the TV wall is behind the camera), `char_night.png` (the courtyard at night). Any other character view renders by name (`python render_views.py char_street.png char_aerial_sw_arches.png …`). The plain renders (`eye1.png` …, `view_nw.png`, the plans, the sun studies) are made with the character off.

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
| `build_3d.py` | builds the model → `output/taif_house_V6.3.glb`, `output/taif_house_V6.3.js` (the GLB as base64 + rooms, flags, sun, bookmarks and the character palette for the viewer), `output/model_summary.json` |
| `character.yaml`, `character_3d.py` | the character study (style, provisional): the palette, every element's sizes, the mashrabiya list, the feature walls, the arches variant, the extra views; the module that builds the `chr_*` meshes from them |
| `open_edges.csv` | the room edges that have no wall, with the source of each |
| `check_3d.py` | the checks (below); also run by `tools/check.py` |
| `viewer.html` + `lib/` | the viewer (three.js r147, vendored, works offline from the repo) |
| `render_views.py` | screenshots with headless Edge → `output/view_nw.png`, `view_se.png`, `plan_gf.png`, `plan_ff.png`, `plan_air.png`, `eye1.png` … `eye3.png`, `sun_summer_09.png` … `sun_winter_15.png`, and the character study's four `char_*.png` (others by name) |

## How to run
```
pip install trimesh shapely numpy pyyaml mapbox_earcut
python taif_house/3d/build_3d.py       # build the GLB (phases 1–3 + the character meshes)
python taif_house/3d/check_3d.py       # check it (3D CHECKS PASSED + the flagged items)
python taif_house/3d/render_views.py   # screenshots (Windows, Microsoft Edge; headless Edge needs the real GPU process: run it outside a sandbox)
```
`python taif_house/tools/check.py` runs the build and the checks as its step 6.

**Viewer:** open `taif_house/3d/viewer.html` in a browser (double-click; no server needed). Left drag orbits, the wheel zooms, right drag pans. Buttons: north-west / south-east overviews, **plan GF / plan FF** (orthographic, room colours and names, cut 1.5 m above the floor), **eye 1–3** (eye level 1.6 m: inside the double-height living looking north to the courtyard; from the courtyard looking west to the colonnade and the gallery; from the stair landing along the gallery), **living → sunken seating / street / north facade / aerial SW / courtyard at night**; a **sun** menu (Taif, true north from `base.typ`) switches on the shadows (with the character on, the eye and overview views pick the yaml's sun by themselves). Toggles hide the first floor and the roof; the slider cuts the model at any height; the flags are listed in the panel. The **character** box: character on / off, the **arches variant**, the **pergola**, the **sunken seating**, the gallery railing **parapet / glass**, **night**; a badge at the bottom right says *style study, provisional* on every character view. URL options for screenshots: `?view=nw|se|top|top_gf|top_ff|top_air|eye1|eye2|eye3|living|street|north|aerial_sw|night&roof=0&ff=0&cut=5&sun=winter-12&labels=0&ui=0&character=0|1&pergola=0|1&sunken=0|1&railing=parapet|glass&night=0|1`.

## Frame and units
- Metres. The model is in the **CSV frame** of the plans: origin = the building's north-west wall corner, x east, y south (the DXFs are in the site frame, shifted by (0.91, 3.525) m; the 3D is not shifted).
- The GLB is Y-up as glTF expects: **X = east, Y = height, Z = south** (= the plans' y). This keeps the model right-handed (not mirrored): the plans' north is −Z.
- **True north** (`base.typ`, `#let north`) is 21.4° east of the plans' north; the sun positions use it (the north arrow in the viewer shows it).

## Parameters (params.yaml)
| Parameter | Value | Note |
|---|---|---|
| finished levels | ±0.00 / +3.60 / roof slab top +7.20 | to confirm with the engineer |
| floor finish / roof finish | 0.08 / 0.10 | assumed |
| slab thickness | 0.20 default | the first-floor and roof bays from `studies/structure.typ` (0.30 / 0.22), V6.3 |
| outer / inner walls | 0.25 / 0.20 | on the centre lines |
| doors | 2.10 high | all doors; the living's entrance arch +2.60 (`openings.doors`); the lift's sliding landing doors are cut (V6.3) |
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
- `3d/character.yaml`: the character study (the mashrabiya windows are matched to the windows of the plans by their coordinates; the feature walls' openings are cut from the built openings).
- Doors of the plans that lie on an open edge (no leaf) cut nothing; the open edges are in `open_edges.csv`.

## Checks (check_3d.py)
1. Every room of both floors is enclosed: each piece of every room edge is on the outline, on a built wall or on a listed open edge.
2. Walls: no overlaps, every wall 0.20 m (measured in the GLB), from the structural slab top to the slab underside (or 1.20 m); the outer ring 0.25 m; **no gaps**: every wall end meets another wall, the outer wall or an open edge; **no interior wall on the outline** (the duplicate walls along the cut, corrected in `3d-char1`).
3. Slab areas measured in the GLB: GF = outline + half the outer wall (318.77 m²); FF = the same minus the courtyard sky, the double-height void and the stair opening (267.85 m²); roof minus the courtyard sky and the suite court (285.02 m²); inside the outline the floors equal the CSV rooms (309.68 m²); the voids 21.77 + 20.94 m², the stair opening 8.21 m².
4. The plan extent is the outline plus half the outer wall (13.561 × 24.25 m); the levels are those of `params.yaml` (finished and structural); every slab bay has its study thickness at the structural top (V6.3). The character meshes are excluded here and checked in 10.
5. Doors and windows: every door and window of the plans is built (28 + 31), or lies on an open edge, or is listed as skipped; every opening sits in a wall with its head below the slab; the clerestory windows at the levels of `studies/sections.typ`; the kitchen service door clear of the counters (the cooking counter starts 0.10 m south of it) and of the columns (C32 +0.40 m); the X3 window / column C33 clearance is reported as a flag (−0.05 m with the assumed 0.25 × 0.60 column along the wall: a clash that the engineer resolves by the column's size, not hidden).
6. The stair: 22 risers to +3.60, the top riser on the first-floor slab (the arrival strip), the opening edged by the trimmers, the headroom over every tread ≥ 2.10 m (minimum 2.14 m under B16; the study's 2.22 m before finishes).
7. The structure of the zone: the colonnade from the ground slab to the roof underside (X8), the upturned edge beam and the railing on it, B5's soffit, R6 and the gym walls flagged unconfirmed.
8. The sun: the noon altitudes equal the formulas of `studies/sections.typ` (winter 45.2°, summer 88.0°), 9:00 / 15:00 symmetric.
9. The air system: the duct (route E) runs only under the maid bath, the laundry and the kitchen (between their wall faces); the chamber under the kitchen floor against the kitchen's west wall; 0.10 m clear of the assumed pads of C25, C26, C31 (C24 / C30 stand on the tower base pit); the duct top under the assumed tie beams (−0.90); the head 2.5 m above the roof; the shaft open through both slabs; the outlet a grille on the courtyard face of the kitchen's west wall with the plenum in its base, ≥ 0.3 m north of the kitchen sink window, no floor opening and no water.
10. The character study: every `chr_*` mesh named `chr_<group>_<material>_<label>` with a palette material and listed in the summary; the viewer replaces only the 21 outer windows' centre-line glass and the B3 railing (they exist); every recessed pane 0.20 m behind the outer face (measured in the GLB); every mashrabiya on a window of the plans, inside its opening, flush with its face; the stone sleeves Ø0.40 (base band Ø0.50) from the finished ground floor to the roof underside; the parapet and the glass railing on B3 from the beam top to +4.70, the parapet as wide as the beam; the pergola inside the courtyard sky's y range, on the roof finish, ≤ 15 % of the sky; the roof parapet from the roof finish with its coping; every character mesh within the outer face + 0.04 (plinth, cladding, coping); the sunken seating: it replaces the base courtyard floor meshes (their area = the courtyard between its wall faces), the pit floor at −0.45 and the treads at −0.15 / −0.30 measured in the GLB, the level edges ≥ 1.0 m and no floor-level courtyard opening nearer than 1.0 m to the pit, the grille over the bench and ≥ 0.15 above the seat and the sunken floor with its upstand, the drain at the lowest point and the overflow above it; the fountain between the grille and the sink window; the TV wall (V6.3): the living's west wall solid to the slab underside, the entrance arch 1.40 m with its +2.60 head, the niche frame and pier, eye-to-screen ≈ 3.45 m, a ≥ 1.0 m path at the sofa's north end.
It ends with `3D CHECKS PASSED` and the list of **flags**, or the problems. `ALL CHECKS PASSED` (tools/check.py) means the model is consistent with the files; it does not mean anything was calculated, and the character study is not a decision.

## Phases
| Phase | Content | State |
|---|---|---|
| 1 | setup, params, slabs, outer walls, voids, viewer | done (tag `3d-p2`) |
| 2 | interior walls, open edges, checks | done (tag `3d-p2`) |
| 3 | doors and windows, the stair with its opening and trimmers, the colonnade – gallery – living zone (columns, edge beam, B5, R6, R11), railings, finished / structural levels, plan views, eye-level bookmarks, sun and shadows | done (tag `3d-p3`) |
| character | the style study: materials, plinth, deep reveals, mashrabiya, stone colonnade, timber soffit, parapet / glass railing, pergola, roof parapet, fountain, props, the arches variant, more views, night | done, provisional (tag `3d-char1`) |
| character r2 | lighter, warmer colours; the sun and shadows in the views; the malqaf outlet on the kitchen wall (owner decision, air study v2.1); the sunken seating variant with its bench under the grille, drain and overflow | done, provisional (tag `3d-char2`) |
| V6.3 | the slab bays from the structural study; the TV wall (solid, entrance arch, niche) and the arches variant removed; the lift's landing doors; X3 window 0.55 | done (tag `v6.3`) |
| 4 | the whole structure from the structural study (all columns and beams, ribbed slabs, the 0.22 roof over the void), marked assumed until the engineer approves | to do |
| 5 | lift, air tower head, parapets and the roof railing, the remaining railings (as design elements: the character study shows provisional ones) | to do |
| 6 | IFC / OBJ export | to do |

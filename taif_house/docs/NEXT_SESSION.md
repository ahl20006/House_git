# Next session · start here

Taif / Palm House · **V8.3** (checkpoint; git tag `v8.3`, GitHub Release "V8.3"; the branch `work` is reset to `main` for the next round)

## Where we are
- **V8.0 – V8.2** (1–3 Nov 2026): fire safety at home level, the courtyard layout, the air system v3.1, the south wing v2; the roof ladder and the lowered roofline; the stair flip with the coat cupboard and the lobby; bedroom 1 without a bath; the suite court's mashrabiya; the site and services plan; the plumbing study rounds 1–2.
- **V8.3** (3 Nov 2026, checkpoint; `PROJECT_V8.md` §4.47–4.53):
  - **Bedroom 2's en-suite and a family WC upstairs** (the F-b bath split on one service wall by the shaft); the suite, bedrooms 2 and 3 have their own bathrooms. **Bedroom 1's hotel en-suite (B4) studied, not applied:** bedroom 1 has no shower on its floor until the owner decides (open item 16).
  - **Ground floor: no shower; one luxurious family powder room** (two stone basins, a large mirror, a wall-hung WC; a door from the riwaq). G-07 closed.
  - **The courtyard revised:** the whole floor level, movable seating for 4–6, the fountain and tree in front of the kitchen window, the TV moved south, linear drains on the rain system (`studies/courtyard_layout.typ`).
  - **The outdoor kitchen next to the service door**, the grill a little apart, the yard re-planned; the workers' route proposed along the farm's boundary wall.
  - **Plumbing decisions:** the east stack external behind cladding, automatic trap primers, rain / sewage separate; the suite bath's approach still open.
  - **Facade principle R-37:** no privacy from outside (a fully walled farm); the walls to open listed for the facade stage.
- **3D** with all of it; two V8.3 renders in `3d/output/`: `char_living.png` (the courtyard from the living), `char_lobby.png` (the family entrance and the stair).
- **Interim V&V review of V8.3:** `docs/review/vv_review_v8_3.typ` → `output/VV_Review_V8.3.pdf` (verification against the requirements, the codes and practice; consistency; validation scenarios; the open decisions; the action list before V9.0).

## The next open items, in this order
1. **The owner's decisions:** bedroom 1's shower (open item 16); the suite bath's drainage approach, the heaters, the utility door, the water system (10); the V&V review's action list.
2. **The survey of the septic, the tanks and the levels** (18, 1).
3. **The engineers:** structure X5, X21 and the roof ladder (3, 4, 5), the soil report (7), MEP sizing (9, 10, 11), the lift supplier (14).
4. **The legal survey** (1) and the municipality (19).
5. **V9.0:** freeze the layout after the review's "before V9.0" items, then the full verification and validation review.
6. **The facades (R-37), the living's acoustics and the bathroom interiors** at the detail stage.

## What to open
| File | What it is |
|---|---|
| `output/VV_Review_V8.3.pdf` | the interim verification and validation review of V8.3 (read this first) |
| `output/Taif_House_V8.3_presentation.pdf` | the A3 set, 12 sheets |
| `output/Design_Review_status_V8.3.pdf` | the status of the V6 design review after V8.3; the review itself: `output/Design_Review_V6.pdf` |
| `output/courtyard_layout.pdf`, `output/site_plan.pdf`, `output/plumbing.pdf` | the courtyard (revised), the site and services plan, the plumbing study (proposals) |
| `output/bedroom1_bath.pdf` (page 3), `output/ff_family.pdf`, `output/guest_wing.pdf` | bedroom 1's B4 (not applied), the first-floor family part, the west wash block with the powder room |
| `output/design_gf.pdf`, `output/design_ff.pdf`, `output/ff_suite.pdf`, `output/structure.pdf`, `output/roof.pdf`, `output/fire_escape.pdf`, `output/air_system.pdf` | the plans, the suite, the structure, the roof, the fire and air studies |
| `output/taif_ground_floor_V8.3.dxf`, `output/taif_first_floor_V8.3.dxf`, `output/taif_roof_V8.3.dxf` | CAD, see `docs/README_DXF.md` |
| `3d/viewer.html` | the 3D (the plain model and the character study, with the site elements) |

## Compile and check
```
python taif_house/tools/check.py      # compiles everything, rebuilds the three DXFs and the 3D, must end with ALL CHECKS PASSED
typst compile --root taif_house taif_house/presentation.typ taif_house/output/Taif_House_V8.3_presentation.pdf
typst compile --root taif_house taif_house/docs/review/review_status.typ taif_house/output/Design_Review_status_V8.3.pdf
typst compile --root taif_house taif_house/docs/review/vv_review_v8_3.typ taif_house/output/VV_Review_V8.3.pdf
python taif_house/3d/render_views.py char_living.png char_lobby.png   # the two V8.3 renders (headless Edge)
```
Tools: Typst 0.15, Python 3.10+ with ezdxf, shapely, trimesh, pyyaml, mapbox_earcut, pdftotext (on Windows from Git for Windows: `C:\Program Files\Git\ucrt64\bin`) or pypdf (`pip install pypdf`, used when pdftotext is missing or broken). The 3D renders need headless Edge outside a sandbox (`3d/README_3D.md`).

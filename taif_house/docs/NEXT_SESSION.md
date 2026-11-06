# Next session · start here

Taif / Palm House · **V9.0, the layout freeze** (git tag `v9.0`, GitHub Release "V9.0", 6 Nov 2026; the branch `work` is reset to `main` for the next round)

## Where we are
- **V9.0 freezes the layout** (`PROJECT_V9.md` §5): the room positions and sizes, the stairs, the wet-room positions and the site position. What may still change: the suite bathroom's drainage approach, the water system, the bathroom interiors, the facades and details, the engineers' results, the official survey.
- **The site:** set out on site by the owner (day 1, the diagonals exact), then 0.50 m further south: **B1 5.49 m from M1** (the shift 0.91 / 5.563); the **cut wall 0.12 m shorter** after the precise field reading of 2.30 m at its tightest point: **0.42 m from the boundary wall as built, 0.90 m from the deed setback line** (`SITE_SETOUT.md`, `studies/setout.typ`).
- **The whole farm** (base v2, the deed is the boundary authority; `studies/whole_farm.typ`): the old house with its majlis west of the driveway, its covered parking and the ground tank south of it near peg R, the septic outside the north wall near C1 serving both houses: placed from the owner's answers, **approximate, to be measured**.
- **Bedroom 1** is the young children's room next to the master suite: no en-suite (they are bathed in the suite's bathroom); the family WC upstairs stays WC + basin.
- **3D** up to date (the final position, the shortened cut wall, the existing farm round the house); four V9.0 renders in `3d/output/`: `char_aerial_sw.png`, `char_gate.png`, `char_living.png`, `char_court_screen.png`.
- **Review status V9.0:** `output/Design_Review_status_V9.0.pdf` (every critical and major finding of the V6 review and of the interim V&V review of V8.3).

## The next items, in this order
1. **The official survey and the engineering office's answer on the setback** (counted from the deed line or from the wall as built) (open item 1).
2. **Measure the old house, the covered parking, the tanks and the septic's inlet level on site** (`SITE_SETOUT.md` § 8; open items 16, 18).
3. **The water system study:** the tankers, the ground tanks, a roof tank, the pumps, the greywater lines to the south garden with diversion chambers (open item 10).
4. **The suite bathroom's drainage approach** (a / b) (open items 10, 11).
5. **The full verification and validation review of V9.0.**
6. **The engineers:** structure X5, the soil report, the MEP sizing, the lift supplier (open items 2–7, 9–11, 14).
7. **The bathrooms' interior study.**
8. **The facades and the details**, acoustics included (R-37; open items 8, 15, 17).

## What to open
| File | What it is |
|---|---|
| `output/Taif_House_V9.0_presentation.pdf` | the A3 set, 12 sheets |
| `output/Design_Review_status_V9.0.pdf` | the review status after V9.0; the reviews: `output/Design_Review_V6.pdf`, `archive/VV_Review_V8.3.pdf` |
| `output/setout.pdf`, `docs/SITE_SETOUT.md` | the set-out sheet (the tapes from M1 / D and R / S) and the field record |
| `output/whole_farm.pdf`, `output/site_plan.pdf`, `output/plumbing.pdf` | the whole farm, the site and services plan, the plumbing study (proposals) |
| `output/shift_south.pdf`, `output/cut_wall.pdf` | the two studies behind the final position (0.50 m south adopted; the cut wall −0.12 m adopted) |
| `output/design_gf.pdf`, `output/design_ff.pdf`, `output/ff_family.pdf`, `output/ff_suite.pdf`, `output/structure.pdf`, `output/roof.pdf`, `output/fire_escape.pdf`, `output/air_system.pdf` | the plans, the family part, the suite, the structure, the roof, the fire and air studies |
| `output/taif_ground_floor_V9.0.dxf`, `output/taif_first_floor_V9.0.dxf`, `output/taif_roof_V9.0.dxf` | CAD, see `docs/README_DXF.md` |
| `3d/viewer.html` | the 3D (the plain model and the character study, with the site and the existing farm) |

## Compile and check
```
python taif_house/tools/check.py      # compiles everything (the presentation and the review status included), rebuilds the three DXFs and the 3D: must end with ALL CHECKS PASSED
typst compile --root taif_house taif_house/presentation.typ taif_house/output/Taif_House_V9.0_presentation.pdf
typst compile --root taif_house taif_house/docs/review/review_status.typ taif_house/output/Design_Review_status_V9.0.pdf
python taif_house/3d/render_views.py char_aerial_sw.png char_gate.png char_living.png char_court_screen.png   # the four V9.0 renders (headless Edge)
```
Tools: Typst 0.15, Python 3.10+ with ezdxf, shapely, trimesh, pyyaml, mapbox_earcut, pdftotext (on Windows from Git for Windows: `C:\Program Files\Git\ucrt64\bin`) or pypdf (`pip install pypdf`). The 3D renders need headless Edge outside a sandbox (`3d/README_3D.md`). Work on the branch `work`; record every change in `docs/PENDING_CHANGES.md`.

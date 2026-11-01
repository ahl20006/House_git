# Next session · start here

Taif / Palm House · **V8.0** (git tag `v8.0`, GitHub Release "V8.0"; the branch `work` is reset to `main` for the next round)

## Where we are
- **V8.0 = V7.1 + six owner decisions of 1 Nov 2026** (`PROJECT_V8.md` §4.31–4.36, `data/decisions.csv`, the review status `output/Design_Review_status_V8.pdf`):
  - **Fire safety at home level** (E-08): interconnected alarms, escape casements without screens, thumb-turns; the second way out via the suite court not counted while the clerestories are openable glass (`studies/fire_escape.typ`).
  - **Courtyard layout:** the seating one step down, the TV wall with the stone surround and the grille below it, the water and tree enclosure, no pergola; the kitchen sink window at y 7.3–8.9 (`studies/courtyard_layout.typ`).
  - **Air system v3 / v3.1:** one tower, two paths (the courtyard breeze in a shallow channel with an assist fan; the HRV's intake, the unit in the tower's base on the roof) (`studies/air_system.typ`, `AIR_SYSTEM.md`).
  - **External stair tower** at the south-east for the office visitors and the roof; the internal stair stops at the first floor, no stair room (`studies/roof.typ`, `studies/south_wing.typ`).
  - **South wing v2:** the gym on the west band, a 25 m² suite court from the gym to the office, the office on the east with no door to the bedroom; the sight-line test and the entry wardrobe; R6 removed, X5 improved, not verified (`studies/ff_suite.typ`, `studies/structure.typ`).
  - **Smaller:** the maid bath's WC moved, the maid room's escape casement, the suite WC door sliding.
- **3D** generated with all of it; five renders in `3d/output/`: `char_north.png`, `char_aerial_se.png`, `char_courtyard.png`, `char_suite_court.png`, `char_tv.png`.

## The next open items, in this order
1. **Bedroom 1's bathroom route** (open item 17, review F-05).
2. **The food route from the kitchen to the men's majlis** (open item 19, X-01).
3. **The south side of the suite court** (owner choice, open item 18; with the clerestory glazing, item 14).
4. **The site and services plan** (open item 20): parking, the garden door, the service yard, water tanks, gas, the generator, Civil Defense access.
5. **Engineers:** structure X5 and the soil report (items 3, 4, 7); MEP sizing of the air system and the plumbing (items 9, 10).
6. **The legal survey** (item 1).

Noted on the way: the malqaf head's south face sits behind the HRV base (three open faces; MEP to confirm); the plan views and older eye views of the 3D (`view_*.png`, `plan_*.png`, `eye*.png`, `sun_*.png`) were not re-rendered: `python taif_house/3d/render_views.py` refreshes them.

## What to open
| File | What it is |
|---|---|
| `output/Taif_House_V8.0_presentation.pdf` | the A3 set, 12 sheets: site, both floors, the family part, the south wing and the suite, the two ground-floor blocks, sections and light, schedules, decisions, open items, the roof plan with the stair tower, the elevations |
| `output/Design_Review_status_V8.pdf` | the status of the design review after V8.0; the review itself: `output/Design_Review_V6.pdf` |
| `output/fire_escape.pdf`, `output/courtyard_layout.pdf`, `output/air_system.pdf`, `output/south_wing.pdf`, `output/roof.pdf` | the V8.0 studies |
| `output/design_gf.pdf`, `output/design_ff.pdf`, `output/ff_family.pdf`, `output/ff_suite.pdf` | both floors and the room studies |
| `output/structure.pdf` | the structural study (X5 revised) |
| `output/taif_ground_floor_V8.0.dxf`, `output/taif_first_floor_V8.0.dxf`, `output/taif_roof_V8.0.dxf` | CAD, see `docs/README_DXF.md` |
| `3d/viewer.html` | the 3D (the plain model and the character study) |

## Compile and check
```
python taif_house/tools/check.py      # compiles everything, rebuilds the three DXFs and the 3D, must end with ALL CHECKS PASSED
typst compile --root taif_house taif_house/presentation.typ taif_house/output/Taif_House_V8.0_presentation.pdf
typst compile --root taif_house taif_house/docs/review/review_status.typ taif_house/output/Design_Review_status_V8.pdf
python taif_house/3d/render_views.py char_north.png char_aerial_se.png char_courtyard.png char_suite_court.png char_tv.png   # the five V8.0 renders (headless Edge)
```
Tools: Typst 0.15, Python 3.10+ with ezdxf, shapely, trimesh, pyyaml, mapbox_earcut, pdftotext (on Windows from Git for Windows: `C:\Program Files\Git\ucrt64\bin`). The 3D renders need headless Edge outside a sandbox (`3d/README_3D.md`).

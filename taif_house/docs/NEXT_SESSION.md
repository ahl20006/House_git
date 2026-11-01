# Next session · start here

Taif / Palm House · **V8.1** (checkpoint; git tag `v8.1`, GitHub Release "V8.1"; the branch `work` is reset to `main` for the next round)

## Where we are
- **V8.0** (1 Nov 2026): fire safety at home level, the courtyard layout, the air system v3.1 (one tower: the courtyard breeze and the HRV intake), the south wing v2 (the gym on the west, a 25 m² suite court, the office on the east), the maid room and kitchen window changes.
- **V8.1** (1 Nov 2026, checkpoint; `PROJECT_V8.md` §4.34, §4.37–4.38):
  - **Roof access by a maintenance ladder** in a recess of a honey-stone pilaster on the gym's east wall in the suite court, behind a locked walnut-finish panel; the stiles 1.10 m above the roof; a self-closing gate in the court guard (`studies/roof.typ` page 2). The internal stair stops at the first floor.
  - **The office for the owner only**, reached from the suite court; visitors are met in the men's majlis.
  - **Roofline lowered and balanced:** the attic 1.40 m above the roof finish (+8.70), the south parapet 0.70 m (+8.00) with a 1.10 m guardrail set back 1.0 m; walkways and PV re-planned; the guarding checked continuous.
  - **Outdoor kitchen** relocated (the counter against the east wall, the grill apart); **one site entry** (the farm's 4 m main gate; no gate on the lane).
  - **Fire study:** the main stair plus the escape windows; the suite court a fresh-air area, not an exit.
- **Study only, not applied:** the stair flip (`studies/stair_flip.typ` → `output/stair_flip.pdf`): recommendation *flip with conditions*, eight decisions listed for the owner.
- **3D** with all of it; three V8.1 renders in `3d/output/`: `char_north.png`, `char_aerial_se.png`, `char_suite_court_sw.png`.

## The next open items, in this order
1. **The internal layout round:** the stair flip (decision pending), bedroom 1's bathroom route (open item 17), a ground-floor shower (review G-07), the food route from the kitchen to the men's majlis (open item 19, X-01).
2. **The suite court's south side and the clerestory glazing** (open items 18, 14).
3. **The site and services plan** (open item 20): parking, the guest approach, the garden door, the service yard, water tanks, septic, gas, the generator, the PV conduits, security, Civil Defense access.
4. **The engineers:** structure X5 and the roof ladder (items 3, 4), the soil report (7), MEP sizing (9, 10).
5. **The legal survey** (item 1).
6. **The living's acoustics and the facades** at the detail stage.

The full verification and validation review is planned for **V9.0**, after the internal layout round.

## What to open
| File | What it is |
|---|---|
| `output/Taif_House_V8.1_presentation.pdf` | the A3 set, 12 sheets: site, both floors, the family part, the south wing and the suite, the two ground-floor blocks, sections and light, schedules, decisions, open items, the roof plan with the ladder and the set-back guardrail, the elevations |
| `output/Design_Review_status_V8.1.pdf` | the status of the design review after V8.1; the review itself: `output/Design_Review_V6.pdf` |
| `output/roof.pdf` | the roof study: the ladder (page 2), the sight lines, the lowered roofline |
| `output/stair_flip.pdf` | the stair flip study (decision pending) |
| `output/fire_escape.pdf`, `output/courtyard_layout.pdf`, `output/air_system.pdf`, `output/south_wing.pdf` | the V8.0 studies (the south wing study keeps the V8.0 stair comparison as its record) |
| `output/design_gf.pdf`, `output/design_ff.pdf`, `output/ff_family.pdf`, `output/ff_suite.pdf` | both floors and the room studies |
| `output/structure.pdf` | the structural study (X5, X17, X20) |
| `output/taif_ground_floor_V8.1.dxf`, `output/taif_first_floor_V8.1.dxf`, `output/taif_roof_V8.1.dxf` | CAD, see `docs/README_DXF.md` |
| `3d/viewer.html` | the 3D (the plain model and the character study) |

## Compile and check
```
python taif_house/tools/check.py      # compiles everything, rebuilds the three DXFs and the 3D, must end with ALL CHECKS PASSED
typst compile --root taif_house taif_house/presentation.typ taif_house/output/Taif_House_V8.1_presentation.pdf
typst compile --root taif_house taif_house/docs/review/review_status.typ taif_house/output/Design_Review_status_V8.1.pdf
python taif_house/3d/render_views.py char_north.png char_aerial_se.png char_suite_court_sw.png   # the three V8.1 renders (headless Edge)
```
Tools: Typst 0.15, Python 3.10+ with ezdxf, shapely, trimesh, pyyaml, mapbox_earcut, pdftotext (on Windows from Git for Windows: `C:\Program Files\Git\ucrt64\bin`). The 3D renders need headless Edge outside a sandbox (`3d/README_3D.md`).

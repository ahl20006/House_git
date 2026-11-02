# Next session · start here

Taif / Palm House · **V8.2** (checkpoint; git tag `v8.2`, GitHub Release "V8.2"; the branch `work` is reset to `main` for the next round)

## Where we are
- **V8.0** (1 Nov 2026): fire safety at home level, the courtyard layout, the air system v3.1 (one tower: the courtyard breeze and the HRV intake), the south wing v2 (the gym on the west, a 25 m² suite court, the office on the east), the maid room and kitchen window changes.
- **V8.1** (1 Nov 2026, checkpoint): roof access by a maintenance ladder in the suite court; the office for the owner only; the roofline lowered and balanced; the outdoor kitchen relocated; one site entry.
- **V8.2** (3 Nov 2026, checkpoint; `PROJECT_V8.md` §4.39–4.46):
  - **The main stair flipped (option B):** the lower flight rises south straight off the family lobby behind a black-bar balustrade, the upper flight arrives beside the lift; the **larger family bath F-b** with a separate WC compartment by the shaft; the **coat cupboard** in the start strip; the store under the half landing; a half-landing window and an entrance side light.
  - **Bedroom 1 without a private bath** (option A, night lights on its route); **the ground-floor shower deferred to the plumbing study** (P1 preferred); **the suite court's south side a mashrabiya** (built in the 3D); **the clerestories openable**; **the food route accepted**.
  - **The site and services plan** (`studies/site_plan.typ` → `output/site_plan.pdf`, 5 pages, a study): the single 4 m gate, the north parking kept, the guest stone path, the south family garden, the service yard and the gas cabinet, the existing water tank east of peg R with the reserved tank beside it, the existing septic outside the wall near corner C1 with the drains rerouted north (the inverts computed), rain separate, PV provision without a generator, intercom and cameras. Every position proposed, to confirm with the survey and the engineers.
  - **The plumbing study, rounds 1–2** (`studies/plumbing.typ` → `output/plumbing.pdf`, 11 pages, **proposals, not applied**): the principles, the inventory, the overlay, the scores, the scenarios (B recommended), the utility room; round 2: the suite bath over the kitchen in sections, (b) an east service wall + the tub's plinth recommended; the east stack external behind cladding; rain and sewage separate; the condensate connections; the smells list.
- **3D** with all of it; three V8.2 renders in `3d/output/`: `char_lobby.png` (the family entrance and the stair start), `char_court_screen.png` (the suite court through the mashrabiya), `char_aerial_sw.png` (the aerial from the south-west with the garden and the paths).

## The next open items, in this order
1. **The owner's plumbing decisions** (open items 10, 11): the suite bath approach (b: service wall + plinth), the ground-floor shower P1, the east stack external behind cladding, the heaters (two cylinders or a roof heat pump) and the batteries with the engineers; the utility room's door moved south.
2. **The survey of the septic, the tanks and the levels** (items 16, 1): the septic's position and inlet level outside the wall near C1, the tank east of peg R, peg R and C1, the street level at the gate.
3. **The engineers:** structure X5 and the roof ladder (items 3, 4), the soil report (7), MEP sizing (9, 10).
4. **The legal survey** (item 1) and the municipality (17: the septic outside the wall, the soakaways, the gas cabinet, the Civil Defense).
5. **V9.0** with the full verification and validation review.
6. **The living's acoustics and the facades** at the detail stage.

## What to open
| File | What it is |
|---|---|
| `output/Taif_House_V8.2_presentation.pdf` | the A3 set, 12 sheets: the site and services plan, both floors, the family part, the south wing and the suite, the two ground-floor blocks, sections and light, schedules, decisions, open items, the roof plan, the elevations |
| `output/Design_Review_status_V8.2.pdf` | the status of the design review after V8.2; the review itself: `output/Design_Review_V6.pdf` |
| `output/plumbing.pdf` | the plumbing and wet-room study, rounds 1–2 (proposals) |
| `output/site_plan.pdf` | the site and services plan (study) |
| `output/stair_flip.pdf`, `output/bedroom1_bath.pdf`, `output/gf_shower.pdf` | the studies behind the V8.2 decisions (the stair flip adopted; bedroom 1 option A; the GF shower deferred, P1 preferred) |
| `output/roof.pdf`, `output/fire_escape.pdf`, `output/courtyard_layout.pdf`, `output/air_system.pdf`, `output/south_wing.pdf` | the V8.0 / V8.1 studies |
| `output/design_gf.pdf`, `output/design_ff.pdf`, `output/ff_family.pdf`, `output/ff_suite.pdf` | both floors and the room studies |
| `output/structure.pdf` | the structural study (X5, X15, X17, X20) |
| `output/taif_ground_floor_V8.2.dxf`, `output/taif_first_floor_V8.2.dxf`, `output/taif_roof_V8.2.dxf` | CAD, see `docs/README_DXF.md` |
| `3d/viewer.html` | the 3D (the plain model and the character study, with the site elements) |

## Compile and check
```
python taif_house/tools/check.py      # compiles everything, rebuilds the three DXFs and the 3D, must end with ALL CHECKS PASSED
typst compile --root taif_house taif_house/presentation.typ taif_house/output/Taif_House_V8.2_presentation.pdf
typst compile --root taif_house taif_house/docs/review/review_status.typ taif_house/output/Design_Review_status_V8.2.pdf
python taif_house/3d/render_views.py char_lobby.png char_court_screen.png char_aerial_sw.png   # the three V8.2 renders (headless Edge)
```
Tools: Typst 0.15, Python 3.10+ with ezdxf, shapely, trimesh, pyyaml, mapbox_earcut, pdftotext (on Windows from Git for Windows: `C:\Program Files\Git\ucrt64\bin`). The 3D renders need headless Edge outside a sandbox (`3d/README_3D.md`).

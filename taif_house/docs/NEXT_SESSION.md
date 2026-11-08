# Next session · start here

Taif / Palm House · **V9.2, small fixes after the final site position** (git tag `v9.2`, GitHub Release "V9.2", 8 Nov 2026; V9.1 the final site position; the layout frozen since V9.0; the branch `work` is reset to `main` for the next round)

## Where we are
- **The layout is frozen** (`PROJECT_V9.md` §5, since V9.0): the room positions and sizes, the stairs, the wet-room positions and the site position. What may still change: the suite bathroom's drainage approach, the water system, the bathroom interiors, the facades and details, the engineers' results, the official survey, the levels.
- **V9.1 · the final site position:** **B1 exactly 6.00 m from M1** (the shift 0.91 / 6.0734), after the owner's car test on site: a full forward turn from the gate into the north strip, in one move, needs it (the swept path of a large SUV on `studies/site_plan.typ` page 2: 0.69 m to the house, 0.55 m to the gate posts). **The cut wall shortened again** (a further 0.24 m outwards, 6.08 m on the outer faces): **0.42 m from the boundary wall as built, 0.91 m from the deed setback line**. The maid room 8.41 m² clear, the maid bath 3.68, bedroom 1 15.74.
- **V9.2 · small fixes:** the utility room labelled; **the air tower a rectangle of 0.90 m² clear** (1.425 × 1.0 on axes; the breeze shaft 0.54, the HRV intake compartment 0.28), the wedge beside it to the maid bath (3.85 m² clear, a shelf niche) and bedroom 1 (15.91 m² clear, a cupboard); the HRV base at its V9.0 footprint; **the attic 2 cm lower** (+8.68): hidden from the north boundary.
- **On site:** the third set-out (`docs/SITE_SETOUT.md` § 7, `output/setout.pdf`): every block 0.51 m straight south from its V9.0 place, then B2 0.27 m east, B3 0.51 m north; check the sides and the diagonals.
- **Levels:** the ground falls slightly to the south; the owner accepts raising the house on a plinth: the finished floor, the plinth, the entrance steps or ramps, the courtyard and garden levels and the sewer falls come from the official survey (`SITE_SETOUT.md` § 9, open item 18).
- **The whole farm** (base v2, the deed is the boundary authority): the old house, its covered parking and the ground tank west of the driveway, the septic outside the north wall near C1 serving both houses: approximate, to be measured.
- **3D** up to date (V9.2: the rectangular tower, the attic +8.68; no new renders); the V9.1 render `3d/output/char_aerial_sw.png`.
- **Review status V9.1:** `output/Design_Review_status_V9.1.pdf`.

## The next work, in this order
1. **The bathrooms and WCs interior study** (the next design round; use `output/Taif_House_V9.2_presentation.pdf`): the master suite's bath and WC closet, bedroom 2's and bedroom 3's en-suites, the family WC upstairs, the ground-floor powder room, the guest WC and basins, the maid bath: the fixtures, their clearances, the finishes, the lighting, the vanities, the ventilation; the suite bath's drainage approach (a / b) decided with it (open items 10, 11).
2. **The water system study:** the tankers, the ground tanks, a roof tank, the pumps, the greywater lines to the south garden with diversion chambers (open item 10; V&V V-05).
3. **The official survey and the engineering office's answer on the setback** (from the deed line or from the wall as built), with the levels (open items 1, 18).
4. **Measure the old house, the covered parking, the tanks and the septic's inlet level on site** (`SITE_SETOUT.md` § 8; open items 16, 18).
5. **The engineers:** structure X5, the soil report, the MEP sizing, the lift supplier (open items 2–7, 9–11, 14).
6. **The full verification and validation review** of the frozen layout.
7. **The facades and the details**, acoustics included (R-37; open items 8, 15, 17).

## What to open
| File | What it is |
|---|---|
| `output/Taif_House_V9.2_presentation.pdf` | the A3 set, 12 sheets (the plans with every room, door and fixture, the site at the final position, the roof, the sections, the elevations, the decisions) |
| `output/Design_Review_status_V9.1.pdf` | the review status after V9.1; the reviews: `output/Design_Review_V6.pdf`, `archive/VV_Review_V8.3.pdf` |
| `output/setout.pdf`, `docs/SITE_SETOUT.md` | the set-out sheet (re-issued 8 Nov 2026) and the field record |
| `output/site_plan.pdf`, `output/whole_farm.pdf`, `output/plumbing.pdf` | the site and services plan (the swept path, page 2), the whole farm, the plumbing study (proposals) |
| `output/design_gf.pdf`, `output/design_ff.pdf`, `output/guest_wing.pdf`, `output/east_wing.pdf`, `output/ff_family.pdf`, `output/ff_suite.pdf` | the plans and the room studies (the bathrooms are in the wash block, the east wing, the family part and the suite) |
| `output/structure.pdf`, `output/roof.pdf`, `output/fire_escape.pdf`, `output/air_system.pdf` | the structure, the roof, the fire and air studies |
| `output/taif_ground_floor_V9.2.dxf`, `output/taif_first_floor_V9.2.dxf`, `output/taif_roof_V9.2.dxf` | CAD, see `docs/README_DXF.md` |
| `3d/viewer.html` | the 3D (the plain model and the character study, with the site and the existing farm) |

## Compile and check
```
python taif_house/tools/check.py      # compiles everything (the presentation and the review status included), rebuilds the three DXFs and the 3D: must end with ALL CHECKS PASSED
typst compile --root taif_house taif_house/presentation.typ taif_house/output/Taif_House_V9.2_presentation.pdf
typst compile --root taif_house taif_house/docs/review/review_status.typ taif_house/output/Design_Review_status_V9.1.pdf
python taif_house/3d/render_views.py char_aerial_sw.png   # the V9.1 render (headless Edge)
```
Tools: Typst 0.15, Python 3.10+ with ezdxf, shapely, trimesh, pyyaml, mapbox_earcut, pdftotext (on Windows from Git for Windows: `C:\Program Files\Git\ucrt64\bin`) or pypdf (`pip install pypdf`). The 3D renders need headless Edge outside a sandbox (`3d/README_3D.md`). Work on the branch `work`; record every change in `docs/PENDING_CHANGES.md`.

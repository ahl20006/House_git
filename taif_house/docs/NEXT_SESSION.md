# Next session · start here

Taif / Palm House · **V6.2** (git tag `v6.2`, GitHub Release "V6.2")

## Where we are
- **V6.2 = V6.1 + the L-shaped gym** (the owner's choice). Everything else from V6.1 is kept: the V5.0 columns solution, the repo, the docs, the checks and the presentation.
  - **First floor:**
    - the gallery runs on the 1.35 m projection over the courtyard and the double-height void, on an edge beam and three columns at x 5.6;
    - the first-floor walls stand on the ground-floor walls;
    - west rooms 4.25 m, gallery ≈ 1.225 m clear, courtyard sky 3.35 m.
  - **Gym (28.37 m²):**
    - the long arm along the south facade;
    - a 1.725 × 2.0 m treadmill arm at the east end, along the suite bedroom wall;
    - a mandatory acoustic double wall (≈ 55 dB), a floating floor or dense rubber, and anti-vibration pads.
  - **Suite court:** 5.99 × 2.0 m = 11.97 m², still open to the sky and private. The clerestory windows keep their light: 81 % winter noon sun, 100 % sky.
  - **Ground floor:** unchanged; the three columns form a colonnade along the courtyard.
- **3D model, phases 1–2 done** (tag `3d-p2`): slabs, outer and interior walls, generated from the CSVs by `3d/build_3d.py`; open `3d/viewer.html` to see it; `3d/README_3D.md` has the phases to do (doors and windows next). The 3D is never edited by hand.
- **Preliminary structural study** (tag `struct-p1`): `studies/structure.typ` → `output/structure.pdf` and `docs/STRUCTURE_STUDY.md`: column grid, beams, slabs, three sections, options for the projection beam, the double-height roof and the men's majlis roof, and 15 items for the engineer (X3 is a column / window clash to fix). Every size assumed.
- **Docs:**
  - master document `docs/PROJECT_V6.md`;
  - construction notes `docs/DETAILS.md`;
  - open items `docs/OPEN_ITEMS.md`.

## What to open
| File | What it is |
|---|---|
| `output/Taif_House_V6.2_presentation.pdf` | the A3 set, 10 sheets (for the owner and the engineers) |
| `output/design_gf.pdf`, `output/design_ff.pdf` | both floors in the site, with checks, schedules, the light check and the projection sections |
| `output/ff_family.pdf`, `output/ff_suite.pdf`, `output/guest_wing.pdf`, `output/east_wing.pdf` | the room studies (`ff_suite.pdf` has the L-shaped gym) |
| `output/taif_ground_floor_V6.2.dxf`, `output/taif_first_floor_V6.2.dxf` | CAD, see `docs/README_DXF.md` |

## Compile and check
```
python taif_house/tools/check.py      # compiles everything, rebuilds both DXFs, must end with ALL CHECKS PASSED
typst compile --root taif_house taif_house/presentation.typ taif_house/output/Taif_House_V6.2_presentation.pdf
```
Tools: Typst 0.15, Python 3.12 + ezdxf, pdftotext (on Windows from Git for Windows: `C:\Program Files\Git\ucrt64\bin`).

## Suggested next steps
1. **Structural engineer** (items 2–6):
   - the edge beam and columns;
   - the gym and the treadmill arm wall over the men's majlis;
   - walls off the ground-floor lines;
   - the levels.
2. **Acoustics** (item 7): the double wall and the floating floor of the treadmill arm.
3. **Plumbing study** `studies/plumbing.typ` (item 8), including the suite court drain at its west end.
4. **Detail round** on the master suite and the owner's office: windows, built-ins, lighting.
5. **Owner decisions:** laundry service door, foyer screen, clerestory glass, lift supplier (items 10–13).
6. **3D phase 3:** doors and windows from the studies' door and window lists (`3d/README_3D.md`).

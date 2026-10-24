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
- **3D model, phases 1–3 done** (tag `3d-p3`): slabs with finished / structural levels, walls, all doors and windows (glass), the stair with its opening and trimmers, the colonnade to the roof, the upturned edge beam, B5, R6 / R11 (orange = assumed, red = unconfirmed), railings, plan views with room names, three eye-level bookmarks, sun and shadows; generated from the project files by `3d/build_3d.py`; open `3d/viewer.html`; `3d/README_3D.md` has the levels, the checks and the phases to do (phase 4: the whole structure). The 3D is never edited by hand.
- **Owner decisions of 3D phase 3** (`data/decisions.csv`, PROJECT_V6.md §4 item 22a): X8 colonnade to the roof (roof edge beam R11, no cantilever); B1 a drop beam hidden by a gypsum ceiling (rule: gypsum ceilings hide drop beams and carry AC / lighting); projection edge beam upturned (b); the kitchen service door at the north end of the east wall (y 6.7–7.6; the cooking counter now starts at y 7.7, the east-wall stack moves between the door and the kitchen window). X3: the suite bath east window is 0.60 m (y 9.6–10.2); with the assumed 0.25 × 0.60 column along the wall it still overlaps C33 by 0.05 m: flagged in the 3D, for the engineer.
- **Preliminary structural study** (tag `struct-p1`): `studies/structure.typ` → `output/structure.pdf` and `docs/STRUCTURE_STUDY.md`: column grid, beams, slabs, three sections, options for the projection beam, the double-height roof and the men's majlis roof, the stair plan and section, and 15 items for the engineer. Corrected in `struct-p1b`: beam depths are total depths (soffits +3.05…+3.20), the projection edge beam upturned is the owner's preference, X5 (R6 on the gym walls over the men's majlis) is a proposed load path NOT verified, X3 is the owner's decision (C33 stays, window y 9.6–10.2; no clash only if C33 is ≤ 0.50 along the wall). Every size assumed; ALL CHECKS PASSED means the drawings are consistent, not that anything was calculated.
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
   - the levels (finished vs structural, `3d/params.yaml`);
   - the X3 clearance (column C33 ≤ 0.50 along the wall) and the X5 load path (R6 on the gym walls over the majlis ribs).
2. **Acoustics** (item 7): the double wall and the floating floor of the treadmill arm.
3. **Plumbing study** `studies/plumbing.typ` (item 8), including the suite court drain at its west end.
4. **Detail round** on the master suite and the owner's office: windows, built-ins, lighting.
5. **Owner decisions:** foyer screen, clerestory glass, lift supplier (items 11–13); the service door is decided (item 10).
6. **3D phase 4:** the whole structure from the structural study (all columns and beams, ribbed slabs, the 0.22 roof over the void), marked assumed until the engineer approves (`3d/README_3D.md`).

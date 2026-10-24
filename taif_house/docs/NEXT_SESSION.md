# Next session · start here

Taif / Palm House · **V6.1** (git tag `v6.1`, GitHub Release "V6.1")

## Where we are
- **V6.1 = V6.0 with the split projection reverted to the V5.0 columns solution.** Everything else from V6.0 is kept: the repo structure, the docs, the checks, the presentation and the rectangular gym with the treadmill at its west end.
  - **First floor:**
    - the gallery runs on the full 1.35 m projection over the courtyard and the double-height void, on an edge beam and three columns at x 5.6;
    - the first-floor west wall stands on the ground-floor west wall (0.785 m from the M line);
    - west rooms 4.25 m (≈ 4.0 m clear), gallery ≈ 1.225 m clear, courtyard sky 3.35 m (≈ 3.15 m clear);
    - family bath 2.75 × 1.8 m; gym 9.06 m and suite court 7.71 m long.
  - **Ground floor:** the three columns form a colonnade along the courtyard edge (in the women's majlis south wall, between the courtyard glass and the living, in the living's south wall). No east duct.
- **The split projection** (V5.1–V6.0) stays on branch `v5-split-projection` and in tag `v6.0`. Page 5 of `output/design_ff.pdf` compares the two.
- **Master document:** `docs/PROJECT_V6.md`. **Open items:** `docs/OPEN_ITEMS.md` (the M-line approval is no longer needed).

## What to open
| File | What it is |
|---|---|
| `output/Taif_House_V6.1_presentation.pdf` | the A3 set, 10 sheets (for the owner and the engineers) |
| `output/design_gf.pdf`, `output/design_ff.pdf` | both floors in the site, with checks, schedules, the light check and the projection sections |
| `output/ff_family.pdf`, `output/ff_suite.pdf`, `output/guest_wing.pdf`, `output/east_wing.pdf` | the room studies |
| `output/taif_ground_floor_V6.1.dxf`, `output/taif_first_floor_V6.1.dxf` | CAD, see `docs/README_DXF.md` |

## Compile and check
```
python taif_house/tools/check.py      # compiles everything, rebuilds both DXFs, must end with ALL CHECKS PASSED
typst compile --root taif_house taif_house/presentation.typ taif_house/output/Taif_House_V6.1_presentation.pdf
```
Tools: Typst 0.15, Python 3.12 + ezdxf, pdftotext (on Windows from Git for Windows: `C:\Program Files\Git\ucrt64\bin`).

## Suggested next steps
1. **Structural engineer** (items 2–5):
   - the edge beam and the three columns (sizes, foundations);
   - the gym over the men's majlis;
   - walls off the ground-floor lines;
   - the levels.
2. **Plumbing study** `studies/plumbing.typ` (item 6).
3. **Detail round** on the master suite and the owner's office: windows, built-ins, lighting.
4. **Owner decisions:** laundry service door, foyer screen, clerestory glass, lift supplier (items 8–11).

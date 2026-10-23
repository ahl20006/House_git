# Next session · start here

Taif / Palm House · **V6.0** (git tag `v6.0`, GitHub Release "V6.0")

## Where we are
- **Both floors are designed.** V6.0 is a clean release; it makes no design change from the previous version (tag `v5.1`).
  - **Ground floor:** the courtyard, the two-height living, the west service band and wash block, the east service block, the men's majlis. No columns, no east duct.
  - **First floor:**
    - the family part on the north and west;
    - the L: owner's office, rectangular gym with the treadmill at its west end, suite court, master suite;
    - the west band on the split projection (0.675 m inward without columns, 0.675 m outward on cantilever beams).
- **Top open item, before construction drawings:** the municipality must confirm the first-floor projection 0.11 m from the M line. If it is refused, fall back to the V5.0 columns solution (tag `v5.0`). The full list is in `docs/OPEN_ITEMS.md`.
- **Master document:** `docs/PROJECT_V6.md` (site, outline, schedules, decisions with reasons, construction notes, changelog).

## What to open
| File | What it is |
|---|---|
| `output/Taif_House_V6.0_presentation.pdf` | the A3 set, 10 sheets (for the owner and the engineers) |
| `output/design_gf.pdf`, `output/design_ff.pdf` | both floors in the site, with checks, schedules, the light check and the split-projection sections |
| `output/ff_family.pdf`, `output/ff_suite.pdf`, `output/guest_wing.pdf`, `output/east_wing.pdf` | the room studies (furniture, doors, drains, checks) |
| `output/taif_ground_floor_V6.0.dxf`, `output/taif_first_floor_V6.0.dxf` | CAD, see `docs/README_DXF.md` |

## Compile and check
```
python taif_house/tools/check.py      # compiles everything, rebuilds both DXFs, must end with ALL CHECKS PASSED
typst compile --root taif_house taif_house/presentation.typ taif_house/output/Taif_House_V6.0_presentation.pdf
```
- **Tools:** Typst 0.15, Python 3.12 + ezdxf, pdftotext (on Windows from Git for Windows: `C:\Program Files\Git\ucrt64\bin`).

## Suggested next steps
1. **Send the presentation** to the municipality / engineering office and ask about the M-line projection (item 1). Their answer decides between V6.0 and the V5.0 fallback.
2. **Structural engineer:** cantilever beams, the inward cantilever without columns, the gym over the men's majlis, the levels (items 3–7).
3. **Plumbing study** `studies/plumbing.typ` (item 8): drain falls, manholes, the east-wall stack, tunnel crossings.
4. **Detail round** on the master suite and the owner's office: windows, built-ins, lighting.
5. **Owner decisions:** laundry service door, foyer screen, clerestory glass, lift supplier (items 10–13).

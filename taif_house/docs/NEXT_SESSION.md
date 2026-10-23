# Next session · start here

Taif / Palm House · state on 24 Oct 2026 · git tag `v5.1`

## Top open item (before construction drawings)
- **Municipality / engineering office to confirm that an upper-floor projection 0.11 m from the M line is allowed.** If not, go back to the V5.0 solution: the full 1.35 m inward projection on three columns at x 5.6 (tag `v5.0`).

## Where we are
- **V5.1 = V5.0 + two owner decisions (24 Oct 2026):**
  - **Split west projection, accepted.** 0.675 m inward over the courtyard and the double-height void, with no columns, and 0.675 m outward beyond the ground-floor west wall, south of y 10.4. The courtyard sky opening is 4.025 m on axes (≈ 3.825 m clear). West rooms 4.25 m, gallery ≈ 1.225 m clear. The family bath is 2.075 m wide. Record of the study: `docs/VARIANT_SP.md`.
  - **L-shaped gym, rejected.** The `v5-gym-L` branch is kept for reference only. The gym stays a rectangle, with the treadmill at its west end (0.5 m clear behind and on each side, rubber floor, anti-vibration pads).
- **Ground floor V5.1** = V4.0 + the east duct removed + no columns. Drawing: `design_gf.typ` + `data/rooms_gf.csv`. Description: `docs/GROUND_FLOOR_V4.md`.
- **First floor V5.1:**
  - Whole floor: `design_ff.typ` + `data/rooms_ff.csv`. Page 5 compares V5.1 with V5.0.
  - Room by room: `studies/ff_family.typ` (family part) and `studies/ff_suite.typ` (office, gym, suite court, master suite).
  - Comparison and sections: `studies/sp_compare.typ`.
  - Decisions: `docs/FIRST_FLOOR_BRIEF.md` (V5.1 section).
- **Presentation set:** `presentation.typ` → `output/Taif_House_V5.1_presentation.pdf`, 9 sheets. Sheet 07 is the split-projection decision record.
- **Construction notes:** `docs/DETAILS.md`. **Decisions log:** `docs/notes.md` (Changes in V5.1).

## Open and compile
```
python taif_house/tools/check.py                                   # compiles everything into output/, must end with ALL CHECKS PASSED
typst compile --root taif_house taif_house/design_ff.typ taif_house/output/design_ff.pdf   # first floor only
```
Tools used on this laptop: Typst 0.15.1, Python 3.12 + ezdxf, pdftotext from Git for Windows (`C:\Program Files\Git\ucrt64\bin`).

## Open items
- **Engineer:**
  - The first-floor west wall on cantilever beams: beams, wall load, deflection.
  - Confirm that the 0.675 m inward cantilever needs no columns.
  - Loads and vibration of the gym (treadmill) and the office walls over the men's majlis.
  - The y 3.0 partition over the women's majlis.
- **MEP:** the stack outside the east wall (suite bath, vent stack); the kitchen extract through the east wall; the hood south of y ≈ 7.5.
- **Light:**
  - The clerestory sill against the suite court floor (eye height, or obscured glass).
  - A daylight check of the courtyard (sky 4.025 m).
- **Layout:** bedroom 1 is ≈ 17 m from the family bath; the bedrooms' 10 cm partition idea (DETAILS.md).
- **Still open from the ground floor:** locked laundry service door (owner), envelope gap 0.05 m (official survey), foyer majaz only partial, `plumbing.typ` study.
- **Release:** a GitHub Release "V5.1" with the PDFs and the DXF is not made yet. `gh` is not installed on this laptop.

## First question for the next session
Detail round on the master suite and the owner's office (windows, built-ins, lighting), or the municipality's answer on the M line.

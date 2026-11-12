# Next session · start here

Taif / Palm House · the last release **V10.0, the malqaf (L5)** (git tag `v10.0`, GitHub Release "V10.0", 9 Nov 2026, on `main`). **Everything since is on the branch `work`** (last commit 12 Nov 2026, tag `backup-2026-11-12`), not yet released: the owner's ground-floor review rounds and two first-floor studies, every one recorded as a row in `docs/PENDING_CHANGES.md`. New computer: read `docs/SETUP_NEW_COMPUTER.md` first.

## Where we stopped (12 Nov 2026)

- **The ground floor is done** (on `work`, applied LEAN at the owner's review, 10–11 Nov 2026): the powder room and the guest WC redrawn, the powder room open to the riwaq, the maid's wing layout D (kitchen → laundry 1.8 m deep on the structural line y 6.5 → maid bath → maid room), the courtyard H2 (no TV, the malqaf outlet raised and its louvres fixed 15° south-east, the order outlet → olive in a fixed pot → water trough under the sink window, six seats with backs, 16.4 m² free), the suite court as the winter sun-seat, **the design rule "straight walls, no jogs"** with the ground-floor jog audit (two removed, three structural ones kept). `design_gf.typ` says `All checks passed`; the presentation (12 sheets) shows it on sheets 02, 06 and 08.
- **The first floor is next, starting with the east wing** (the master suite: lobby, bedroom, bath, WC, dressing, the court door; bedroom 1, the young children's room, with its own compact en-suite; the link between them). Two studies exist for reference, none adopted: `studies/kids_room.typ` (the en-suite alone: layouts A, A′, B) and `studies/east_wing_ff.typ` (the whole wing: L1 tidy, L2 walk-through dressing, L3 from the master; then the owner's direction K1 whole in the suite, K2 half and half, K3 = A′, with one table of the seven and the acoustic note). **The owner now wants minimal-change options M1–M3: not started.** Their brief, as far as it is known: bedroom 1 keeps its present size and shape as far as possible (≈ 17.3 m² clear); its en-suite ≈ 3.3 m² clear (WC, basin, a wall-mixer shower), door from the bedroom; the master suite's priorities 1 bedroom, 2 bath, 3 dressing, 4 the court; the structure untouched (every column and beam; a column inside a room is used), partitions on the beam lines where possible, straight walls, no jogs; wet rooms over wet / service rooms only (the laundry, the kitchen), **no drain over the kitchen's hood zone** (x 12.4–13.311, y 10.1–11.3; dry fittings may stand over it); windows provisional only; the presentation untouched until the owner chooses. The numbers and the checks of the existing studies (fixtures inside rooms, no overlaps, door swings clear, wet over service, no column moved, no jog) are the starting point; `east_wing_ff.typ` page 4 lists the structural observations for the later review.
- **After the east wing:** the rest of the first floor in the same way (the family part: the kids' study, the family living, bedrooms 2 and 3 with their baths, the family WC, the gallery; then the gym, the office and the court).
- **Then the release (V10.1 or V11.0) with the file clean-up:** fold every `PENDING_CHANGES.md` row into the documentation (`PROJECT_V10.md`, `DESIGN_LANGUAGE.md`, `REQUIREMENTS.md`, `OPEN_ITEMS.md`), the presentation, the DXFs and the 3D (`3d/params.yaml`, `3d/character.yaml`); **archive the finished studies** (the courtyard haven, the malqaf outlet B, the kids' room, the superseded variants) into `archive/`; **one source for repeated values** (the courtyard's outlet, the louvre angle, the trough and olive, the laundry fixtures, the kids'-bath numbers are today written in two or three files each: give each a single home, the others read it); add the new studies' jobs to `tools/check.py`; then `python taif_house/tools/check.py` must end with `ALL CHECKS PASSED`, tag, release, reset `work` to `main`.
- **Still open from V10.0, unchanged:** the water system study, the engineers' package (structure X5, the malqaf core, the soil report; MEP; the lift), the official survey and the levels, the full verification and validation review, the facades and the details (render and paint, no stone; porcelain floors).

## The next work, in this order
1. **The east wing, minimal-change options M1–M3** (`studies/east_wing_ff.typ`, new pages, or a new `studies/east_wing_M.typ`): the smallest moves from today's layout that give bedroom 1 its en-suite under the brief above; the same plans, table and checks as K1–K3; a recommendation and an Arabic summary. The owner chooses; then apply LEAN (`data/rooms_ff.csv`, `studies/ff_family.typ`, `studies/ff_suite.typ`, `studies/plumbing.typ`, the presentation's sheets 03, 05, 08).
2. **The rest of the first floor** (the family part, the gym, the office, the court), room by room with the owner.
3. **The release with the file clean-up** (above).
4. The V10.0 list that follows: the bathrooms' interiors, the water system, the engineers' package, the verification review, the facades and the details.

## What to open
| File | What it is |
|---|---|
| `output/Taif_House_V10.0_presentation.pdf` | the A3 set, 12 sheets, compiled on `work` with the ground-floor rounds (sheet 02 the GF, 03 the FF, 05 the family FF, 06 the wash and service blocks, 08 the areas) |
| `output/east_wing_ff.pdf` | the first-floor east wing study, 6 pages (L1–L3, the structural observations, K1–K3, the table of the seven) |
| `output/kids_room.pdf` | the kids' en-suite short study (A, A′, B) |
| `output/courtyard_layout.pdf`, `output/maid_wing.pdf`, `output/air_system.pdf` | the courtyard H2 as applied, the maid's wing D, the air system (the outlet, 15°) |
| `output/malqaf_L5.pdf`, `output/Design_Review_status_V10.0.pdf` | the malqaf study (adopted at V10.0) and the review status |
| `output/setout.pdf`, `docs/SITE_SETOUT.md` | the set-out sheet and the field record |
| `output/design_gf.pdf`, `output/design_ff.pdf`, `output/guest_wing.pdf`, `output/east_wing.pdf`, `output/ff_family.pdf`, `output/ff_suite.pdf` | the plans and the room studies (`design_ff.pdf`, `ff_family.pdf`, `ff_suite.pdf` still show the first floor of V10.0) |
| `output/taif_ground_floor_V10.0.dxf`, `output/taif_first_floor_V10.0.dxf`, `output/taif_roof_V10.0.dxf` | CAD of V10.0 (not rebuilt since; see `docs/README_DXF.md`) |
| `3d/viewer.html` | the 3D of V10.0 (not rebuilt since) |
| `docs/PENDING_CHANGES.md` | every change on `work` since V10.0, one row each, with what is NOT yet updated |

## Compile and check
```
python taif_house/tools/check.py      # compiles everything, rebuilds the three DXFs and the 3D: must end with ALL CHECKS PASSED (the 3D / DXF rows in PENDING_CHANGES.md are expected to fail until the release)
typst compile --root taif_house taif_house/presentation.typ taif_house/output/Taif_House_V10.0_presentation.pdf
typst compile --root taif_house taif_house/studies/east_wing_ff.typ taif_house/output/east_wing_ff.pdf
```
Tools and the quick checks per file: `docs/SETUP_NEW_COMPUTER.md`. Work on the branch `work`; LEAN rounds touch only the listed files; record every change in `docs/PENDING_CHANGES.md`.

# Variant SP · split projection (study record · ACCEPTED in V5.1)

Taif / Palm House · 24 Oct 2026 · branch `v5-split-projection`, built from V5.0 (tag `v5.0`). **Accepted by the owner on 24 Oct 2026 and merged into `main` as V5.1 (tag `v5.1`)**, on the condition that the municipality / engineering office allows the first-floor projection 0.11 m from the M line (else back to V5.0). This file is the study as made; the current design is described in `FIRST_FLOOR_BRIEF.md` (V5.1), `DETAILS.md` and `notes.md`.

## The idea
- **V5.0:** the first-floor west band sits on a 1.35 m projection that sticks out entirely over the courtyard and the double-height void. The gallery is on the projection (x 4.25–5.6), the west rooms are 4.25 m wide, and there are three columns with an edge beam on x 5.6.
- **Variant SP:** the 1.35 m is split.
  - **0.675 m inward** over the courtyard and the void: x 4.25 → 4.925, y 6.5–19.25.
  - **0.675 m outward** beyond the ground-floor west wall: x 0 → −0.675, y 10.4–24.
  - The whole west band moves 0.675 m west: rooms, gallery, and in the L the office and the gym route.

## The split
- **The band:** 4.25 m of rooms + 1.35 m of gallery = 5.6 m on axes, kept.
- **Widths:** the west rooms need ≥ 4.225 m on axes to stay ≥ 4.0 m clear (½ of the 250 mm outer wall + ½ of the 200 mm inner wall). The gallery needs ≥ 1.125 m to stay ≥ 1.0 m clear (½ wall + ½ railing). With the band kept at 5.6 m, both hold for **any** split.
- **Site:** this is the real limit. The ground-floor outer west face is 0.785 m from the M line, so the outward part can be at most 0.785 m.
- **Chosen: the even split, 0.675 / 0.675.** It leaves **0.11 m** from the first-floor outer face to the M line. More outward would gain little sky and leave almost no margin to the line.

## Comparison (V5.0 → variant SP)
| Item | V5.0 | Variant SP |
|---|---|---|
| Courtyard sky opening, axes / ≈ clear | 3.35 / 3.15 m | **4.025 / 3.825 m** |
| Double-height void width, axes / ≈ clear | 3.35 / 3.15 m | **4.025 / 3.825 m** |
| West room width, axes / ≈ clear | 4.25 / 4.025 m | 4.25 / 4.025 m |
| Gallery width, axes / ≈ clear | 1.35 / 1.225 m | 1.35 / 1.225 m |
| Columns in the courtyard / living | yes, 3 on x 5.6 + edge beam | **no** |
| FF west face → M line | 0.785 m | **0.11 m** |
| Walls on cantilever | none | FF west wall y 10.4–24 + two 0.675 m returns (14.95 m) |
| FF outline (axes) | 309.68 m² | 318.86 m² (+9.18) |
| Courtyard sky + double-height void | 42.71 m² | 51.32 m² (+8.61) |
| FF floor (outline − voids) | 266.97 m² | 267.55 m² (+0.58) |
| FF rooms indoor (incl. circulation) | 227.75 m² | 226.97 m² (−0.78) |
| · circulation | 45.72 m² | 43.90 m² |
| · family bath | 4.95 m² (2.75 wide) | 3.74 m² (2.075 wide) |
| · gym | 24.92 m² | 26.77 m² |
| · wardrobe niche (bedroom 2) | 0.90 m² | 1.31 m² |
| Suite court (open) | 15.42 m² | 16.77 m² |

- **Clear widths:** ≈ axes − ½ wall each side.
- **Sky opening clear:** axes − 0.10 m for the east wall − 0.10 m for the slab edge with its railing. The V5.0 studies quoted 3.30 m with a thin balustrade only.
- **Source:** these numbers are generated live on `design_ff.pdf` page 5 and presentation sheet 07 (from `studies/sp_compare.typ`).

## Every change the shift forces
**First floor, family part (`studies/ff_family.typ`):**
- **Bedrooms:** bedroom 2, bedroom 3 and the bedroom 3 bath move 0.675 m west, size unchanged, with their doors, windows and furniture. The bedroom 3 bath wall moves from x 2.2 to x 1.525.
- **Family bath:** 2.75 → **2.075 m** wide (4.95 → 3.74 m²). Its west wall is the fixed west shaft (x 1.5), and its east wall follows the band to x 3.575. WC, shower and basin all still fit, and the basin moves 0.2 m west. *This is the one real loss.*
- **Wardrobe niche (bedroom 2):** 1.5 → **2.175 m**. It gains the 0.675 m outside the shaft.
- **Gallery:**
  - On the projection it is x 3.575–4.925.
  - At the stair top (y 6.5–9.2) it is 2.18 m wide; it was 2.85 m including the V5.0 projection.
  - Its area is 30.71 → 28.89 m².
- **Unchanged:** kids' room, family living, family link, bedroom 1, landing, linen cupboard, stair, lift and west shaft.
- **West face:** it steps out at y 10.4, just south of the shaft. North of that line, the stair, lift and shaft walls stay on the ground-floor wall x 0.

**First floor, the L (`studies/ff_suite.typ`):**
- **Owner's office:** same size (4.25 × 4.75), now x −0.675–3.575. Its west wall is on the outward cantilever, over the GF foyer, and it forms a canopy over the guest entrance.
- **Gym route:** x 3.575–4.925, same size.
- **Gym:** 9.06 → **9.74 m** long (24.92 → 26.77 m²). Its west wall follows the office.
- **Suite court:** 7.71 → **8.39 m** long (15.42 → 16.77 m²). It starts at the gym route, x 4.925.
- **Unchanged:** the master suite (lobby, bath, WC closet, dressing, bedroom), the two clerestory windows (x 6.0–7.0 and 7.6–8.6, still in front of open sky) and the light check.

**Ground floor (`design_gf.typ`):**
- **Columns:** the three columns at x 5.6 are removed.
- **Lower ceiling:** only under the inward 0.675 m (x 4.25–4.925).
- **Marks:** the plan shows the FF cantilever edge (x 4.925) and the FF west wall above (x −0.675).
- **Rooms:** no room changes. The CSV and the DXF areas are unchanged.

## Structure (for the engineer)
- **Inward cantilever, 0.675 m:**
  - It runs beyond the courtyard edge x 4.25, along y 6.5–19.25.
  - Back span: 1.5 m to the GF riwaq wall x 2.75.
  - It carries only the gallery (live load) and its railing.
  - Cantilever / back span = 0.45 with a short reach, so **no columns and no edge beam are expected**. The three columns were removed from both floors on that basis.
  - To confirm: slab depth, the x 4.25 beam (which already carries the rooms' east wall in V5.0, and now the cantilever moment), and the railing fixing.
- **Wall on cantilever beams:**
  - The FF west wall (250 mm, ≈ 3.6 m high, plus parapet) stands 0.675 m beyond the GF west wall from y 10.4 to y 24, with returns at y 10.4 and y 24.
  - Proposed: cantilever beams at the cross walls, with a back span of 2.75 m to x 2.75, and an edge beam under the wall.
  - Engineer: beam depth, the wall's line load, tip deflection (a cracking limit for the block wall), and the south-west corner (−0.675, 24).
- **The rooms' east wall at x 3.575** now stands on the slab between x 2.75 and x 4.25, with no wall below. It is a light partition or sits on a beam.

## Climate
- **Afternoon sun:** the outward projection shades the top of the ground-floor west wall. The shaded band is ≈ 0.675 × tan of the sun's profile angle: 0.7 m at 45°, 1.2 m at 60°. Low sun late in the afternoon still reaches the lower wall, so the west windows still need their own shading.
- **Guest entrance:** the projection also roofs the foyer's double door.
- **Courtyard:** it gets more sky (4.025 m instead of 3.35 m between ≈ 7–8 m walls), so more daylight and air, and a little less shade than V5.0.

## Open items
- **Site:** the first-floor west face is 0.11 m from the M line. **The municipality / engineering office must confirm that an upper-floor projection this close to the M line is allowed.** If it is not, the outward part shrinks (the minimum allowed gap sets it) and the inward part grows back.
- **Engineer:** the wall on cantilever beams; the inward cantilever without columns.
- **Owner:** the narrower family bath (2.075 m) is the price of the wider courtyard.
- **DXF:** `make_dxf.py` draws the ceiling-height mark only when `level-marks` holds exactly one line. That has also been true since V5.0 (two lines), so this is not new.

## Files on the branch
- **Changed:** `data/rooms_ff.csv`, `studies/ff_family.typ`, `studies/ff_suite.typ`, `design_ff.typ`, `design_gf.typ`, `presentation.typ`, `tools/check.py` (new presentation file name), `tools/make_dxf.py` (title).
- **New:** `studies/sp_compare.typ` (comparison table + east–west sections), `docs/VARIANT_SP.md` (this file), `output/Taif_House_V5.0-SP_presentation.pdf` (9 sheets).
- **Unchanged:** `base.typ`, `data/rooms_gf.csv`, the main docs, and `output/Taif_House_V5.0_presentation.pdf` (the V5.0 set).

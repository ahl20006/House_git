# Taif / Palm House · construction and detail notes

House-wide building rules and details, for the engineer, the carpenter and the contractor. Each item names its source; the layout decisions themselves are in `notes.md` and the floor briefs.

Started 19 Oct 2026 · state of **V5.1** (24 Oct 2026).

> **Top open item, before construction drawings:** municipality / engineering office to confirm that an upper-floor projection 0.11 m from the M line is allowed. If not, go back to the V5.0 solution (full 1.35 m inward projection on three columns at x 5.6, tag `v5.0`).

## Joinery

### Built-in cupboards in niches
- **Applies to:** the first-floor linen cupboard (2.0 m, north end of the gallery) and the bedroom 2 wardrobe niche (2.175 m in V5.1, beside the west shaft). Both already have walls on both sides.
- **Preferred: a joinery box.** The carpenter builds the cupboard with its own 18 mm sides, top and frame and scribes it to the walls with thin filler strips. No block is needed, and almost the full width is kept.
- **10 cm block jamb + header:** only where a side is open, or a heavy sliding door needs a solid fixing. Two jambs take 20 cm off the opening, so draw the niche **20 cm wider on plan** to keep the clear width.
- **Decide case by case with the carpenter.**
- Source: `studies/ff_family.typ` (19 Oct 2026).

## Walls

### 10 cm partitions (idea for later)
- **The idea:** a 10 cm partition instead of 20 cm, with its corridor face held where it is, gives the room beside it +10 cm of clear width.
- **Check with the engineer:** any beam on that line. A roof beam wider than the wall shows as a downstand (bulkhead) unless it is hidden or upturned.
- **Sound:** a 10 cm block between a bedroom and a corridor carries more noise. Plaster both sides, or use an insulated drywall partition.
- Source: discussion of 18 Oct 2026 (bedroom width). No longer needed for the west rooms after the west projection, but kept as a general option.

## Structure

### Split west projection (V5.1)
- **What:** the V5.0 1.35 m projection is split. **Inward 0.675 m:** a first-floor slab beyond the courtyard edge x 4.25, along y 6.5–19.25, carrying only the gallery and its railing. **Outward 0.675 m:** the first-floor west band stands beyond the ground-floor west wall (x 0 → −0.675), from y 10.4 to 24.
- **Inward cantilever, no columns:** back span 1.5 m to the GF riwaq wall x 2.75, cantilever / back span 0.45. The three V5.0 columns at x 5.6 and their edge beam are removed from both floors. **Engineer to confirm** that no columns are needed (slab depth, the x 4.25 beam, the railing fixing).
- **First-floor west wall on cantilever beams:** the 250 mm wall (≈ 3.6 m high + the parapet) stands 0.675 m beyond the GF west wall, y 10.4–24, with returns at y 10.4 and y 24 (14.95 m of wall in all). Proposed: cantilever beams at the cross walls (back span 2.75 m to x 2.75) with an edge beam under the wall. **Engineer:** beam depth, the wall's line load, tip deflection (a cracking limit for the block wall), the south-west corner (−0.675, 24).
- **The rooms' east wall at x 3.575** now stands on the slab between x 2.75 and 4.25, with no wall below: a light partition or a beam.
- **Ground floor changes only by:** no columns, a lower ceiling under the inward 0.675 m only, the fixings of the cantilever beams in the west wall.
- **Climate:** the outward part shades the top of the GF west wall from the afternoon sun (≈ 0.675 × tan of the sun's profile angle: 0.7 m at 45°, 1.2 m at 60°) and roofs the guest entrance.
- **Site:** the first-floor west face is 0.11 m from the M line (top open item above). Fallback: the V5.0 solution, tag `v5.0`.
- Source: `docs/VARIANT_SP.md`, `studies/sp_compare.typ`, `studies/ff_family.typ` (24 Oct 2026). History: V5.0 had an edge beam on x 5.6 on three columns (tag `v5.0`).

### Gym over the men's majlis
- **Loads and vibration:** the gym (9.74 × 2.75 m ≈ 26.8 m²), the owner's office and their walls stand on the men's majlis roof slab (the office partly over the GF foyer and guest passage, its west wall on the cantilever beams). The engineer checks loads and vibration, and the walls with no wall below (y 21.25, x 3.575, x 4.925).
- **Treadmill (V5.1):** at the gym's west end, away from the master suite, 0.9 × 2.0 m along the gym's length, **0.5 m clear behind and on each side**; a **dense rubber floor** (20–40 mm) under it and its clear zones and **anti-vibration pads** under its feet, so footfall and motor vibration do not go into the majlis roof slab. Its dynamic load (≈ 1.5–2 kN in use) for the engineer.
- **The gym stays a rectangle** (an L-shaped gym with a treadmill arm against the suite bedroom was rejected on 24 Oct 2026: smaller suite court, treadmill noise next to the master bedroom; branch `v5-gym-L`).
- Source: `studies/ff_suite.typ`, `studies/ff_family.typ`.

### Walls on the women's majlis roof
- **The y 3.0 partition** (kids' room / family living) stands over the women's majlis, which has no wall below: a light partition on the slab, or a beam.
- Source: `studies/ff_family.typ`.

## Drainage and services

### East duct removed
- **The 0.6 × 0.6 m duct in the kitchen's NE corner is removed** (ground floor V5.0).
- **Kitchen extract:** straight out through the east wall at the hood.
- **Vent stack and the suite bath drain:** one stack on the **outside face of the east wall** (x 13.311, y ≈ 6.7–7.1), down to the east-yard manhole where the kitchen already drains.
- **Kitchen hood:** to be placed south of y ≈ 7.5 on the east wall, clear of the stack.
- **MEP engineer to confirm.**
- Source: `studies/ff_family.typ`, `studies/ff_suite.typ` (18 Oct 2026).

### Bathrooms over the kitchens
- **Suite bath** (over the GF kitchen): a **sunken bath floor**, all pipes in the floor build-up, **nothing hanging in the kitchen ceiling**; the WC closet sits at the stack (north-east corner), the tub drain is the longest run (≈ 3.2 m).
- **Family bath** (partly over the GF hospitality kitchen): pipes in the bath floor to the west shaft, nothing in the kitchen ceiling.
- **Rule kept:** no drain over the master bedroom.

### Stacked wet rooms
- **Bedroom 3 bath:** stands exactly over the GF family WC (walls on the GF lines y 14.4 and 16.1); its WC drops straight into that stack.
- **Family bath:** WC on the west shaft wall; shower and basin run to the shaft in the floor.

## Open-air spaces

### Suite court (former light strip + suite terrace)
- **The space:** 8.39 × 2.0 m (x 4.925–13.311, V5.1), walled on four sides and open to the sky, on the men's majlis roof slab; the gym's north windows onto it are high or obscured.
- **Rain:** its own floor drain and waterproofing.
- **Gym roof edge** (the court's south side): a **railing, not a parapet** (solid top +7.20), to keep ≈ 80 % of the winter noon sun on the clerestory windows.
- **Clerestory windows** of the double-height living (two 1.0 × 1.0 m, north wall of the court): sill above eye level from the court floor, or obscured glass. Check against the floor levels.
- **Summer heat:** operable clerestory windows and the bedroom door let the court breathe.
- Source: `studies/ff_suite.typ` (18 Oct 2026).

## Doors

### Sliding doors where a swing would cost space
- **Office and gym** (from the gym route), the **suite WC closet**, the **suite court** door and the dressing wardrobes are sliding or pocket doors.
- Source: `studies/ff_suite.typ` (20 Oct 2026).

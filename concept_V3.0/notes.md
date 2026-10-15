# Taif / Palm House · Design V3.1 · decisions log

## Files and how to check
- `design_v3.typ` is the file you compile for the design (plan, schedules, philosophy). It reads `data/rooms_v3.csv` and the site in `base.typ`.
- `base.typ`: site, envelope, palms, north, checks and the drawing engine. Site data changes only if the land changes.
- `data/rooms_v3.csv`: one row per room (name, x, y, w, d, angle, frame, colour, pts). `#` at the start of a name switches a row off. `pts` ("x y; x y; …") is only for rooms that are not rectangles.
- `studies/guest_wing.typ` (west wash block) and `studies/east_wing.typ` (east service block): stand-alone layout studies with fixtures and labelled doors. They are the source for those blocks; keep them and the CSV in step.
- `site_test.typ` + `data/building.csv`: site-test options for the building footprint (Z3, Z4 …).
- `tools/make_dxf.py` writes `design_v3.dxf` (one DXF with the site, the building and every room, door and fixture); `tools/check_v3.py` compiles everything and cross-checks the CSV, the two studies and the DXF. See `README_DXF.md`.
- Check before you stop: `python tools/check_v3.py` must end with "ALL CHECKS PASSED", and the plan page must show "✓ All checks passed".

## Current design (V3.1, 15 Oct 2026)
- Site-test option Z4: a pentagon 13 × 23 m on wall centre lines (13.25 × 23.25 outside), its north-east corner cut parallel to the lane from (10.051, 0) to (13, 5.427). Square to the M line (rot = 0°), shift (0.65, 3.525). Both palms well beyond the south facade.
- Bands west → east (CSV x): west band 0–2.75 · riwaq 2.75–4.25 · middle band 4.25–9.0 · east band 9.0–13.0. Main cross lines (CSV y): 6.0 (women's majlis / courtyard) and 12.5 (courtyard / living), 18.25 (living / men's majlis), 23 (south wall).
- Middle band: women's majlis 4.75 × 6 (north) · courtyard 4.75 × 6.5, open to the sky · living (double height) 4.75 × 5.75 (south of it).
- Family lobby + riwaq: one straight strip 1.5 × 18.25 from the front door to the men's majlis; closed wall with windows onto the courtyard.
- West band, north → south: lift, stair (store under its landing), utility room with the service shaft inside it, then the west wash block (see below).
- East band, north → south: air tower in the tip of the cut corner, the east service block (maid bath, laundry, maid room, kitchen; see below), then living (normal height) · dining 4 × 5.75.
- South: men's majlis 10.25 × 4.75, its west wall on the west band line (x = 2.75).
- Living is one open room 8.75 × 5.75 with two ceiling heights (double height over the courtyard side, normal height for dining); no upper floor over the double-height part or the courtyard.
- Air: the tower catches the NW wind above the roof and brings it down to an underground tunnel that enters the courtyard through a low, closable opening. The tunnel is described, not drawn.

## Changes in V3.1 (15 Oct 2026)
- Building moved from Z3 to Z4 (0.75 m wider through the middle): courtyard, women's majlis and double-height living each 4.75 m wide; east rooms moved 0.75 m east; building 0.375 m further west.
- Men's majlis west wall moved onto the west band line (x = 2.75).
- Family basins, family WC and guest wing redesigned as ONE west wash block, with a two-door serving passage as the only family / guest link.
- East service block redesigned: kitchen 4 × 6.5 on the courtyard lines, laundry on the women's majlis wall, maid room and maid bath running up to the sloped cut wall.
- `base.typ`: optional `pts` column for rooms that are not rectangles (site data unchanged).
- Studies moved to `studies/`; one DXF of the whole design added (`design_v3.dxf`).

## Open choices
- Stair size with the engineer (≈ 2.75 × 5.7 m for a 3.6 m storey).
- Use of the coffee corner (open use) in the west wash block.
- Deliveries reach the kitchen through the family entrance (no service door, to keep the kitchen isolated).
- Structure: the engineer to set the grid; the east band works as its own 4 m bay.
- First floor: later (wet rooms to stack over the north of the west wash block and over the maid bath / laundry).

## Ideas for later (not in the drawing)
- Removable desert (evaporative) cooler with a fan at the tunnel's courtyard outlet, in a wall niche with water, drain and power; removed when not needed.
- Tunnel cleanable (≈ 1.2 m high), sloped to a drain, hatches at both ends.
- Use the tunnel as the pre-cooled fresh-air intake for the AC; consider an ERV (energy recovery ventilator).
- Route AC condensate water to the evaporative cooler pad.
- Split AC outdoor units on a screened roof plant area (or one VRF outdoor unit), not in a shaft; refrigerant and condensate pipes run in the service shaft.
- Services built for life: walk-in service shaft, service ceiling above the riwaq, manifolds, access panels, wet rooms stacked over the shaft.

## Services built for life (V3.0, 11 Oct 2026; updated 15 Oct)
- The service shaft sits INSIDE a utility room (2.75 × 2.5 m): shaft, main electrical panel, water manifold with isolation valves, water heater (ventilated) and cleaning equipment, all behind one door from the riwaq.
- Shaft: closed box ≈ 1.0 × 1.2 m clear (≈ 1.5 × 1.2 m with walls), sealed walls, one full-height maintenance door facing east; a 0.9 m clear zone in front of that door is never used for storage.
- The shaft is in the corner touching the west wash block (coffee corner), so drainage runs stay short; first-floor bathrooms must stack above or beside it.
- Store under the stair's half landing (≈ 2.75 × 1.0 m, ≈ 1.6 m headroom), door onto the riwaq; drawn inside the stair, not counted as extra area.
- Code note: the Saudi Building Code sets no fixed size for a closed pipe shaft; ≈ 0.6 × 0.6 m is the practical minimum for a pipe-only duct and ≈ 1.0 × 1.2 m is comfortable for a two-storey villa. Sources were general professional guidance, not the code text; confirm with the SBC, the municipality and the plumbing engineer.

## One living room, two heights (V3.0, 11 Oct 2026; sizes updated for Z4)
- Living is one open room, 8.75 × 5.75 m (≈ 50 m²), split by a ceiling-height change only (no wall):
  - Living (double height), middle band south of the courtyard, 4.75 × 5.75 m: faces the courtyard, high operable clerestory windows for stack ventilation; simple 4.75 m roof span; the riwaq opens here.
  - Living (normal height) · dining, east band south of the kitchen, 4 × 5.75 m (23 m²): daily dining beside the kitchen door; ducts and lighting in its ceiling; the first floor continues above it (and above the kitchen and maid wing).
- No upper floor over the double-height part or the courtyard.
- Possible south clerestory windows over the men's majlis roof: first-floor decision, noted only.

## West wash block (V3.0 on Z4, 15 Oct 2026)
- Family basins, family WC and the guest wing are now ONE section: the west wash block, x 0–2.75, y 10.4–23 (2.75 × 12.6 m = 34.65 m²), between the utility room (north), the riwaq (east, x 2.75–4.25) and the men's majlis (east, from y 18.25). Layout study: studies/guest_wing.typ (local y + 10.4 = CSV y); the same rooms are in data/rooms_v3.csv.
- One strip of wet rooms on one drain run, north → south:

  | Room | w × d (m) | m² |
  |---|---|---|
  | Coffee corner (open use) | 2.75 × 2.0 | 5.50 |
  | Family basins (2) | 2.75 × 1.5 | 4.13 |
  | Family WC + basin | 2.75 × 1.7 | 4.68 |
  | Serving passage (2 doors) | 2.75 × 1.1 | 3.03 |
  | Guest WC | 1.5 × 1.7 | 2.55 |
  | Basins (3) | 1.5 × 2.0 | 3.00 |
  | Guest passage | 1.25 × 3.7 | 4.63 |
  | Foyer + entry | 2.75 × 2.6 | 7.15 |
  | **Block** | **2.75 × 12.6** | **34.65** |

- Family side: coffee corner and family basins are open to the riwaq (no doors); the family WC door is off the basin niche. The coffee corner (counter, small sink, under-counter fridge) is the serving base; its final use is still open.
- Serving passage = the ONLY link between family and guests, with only two doors (no wall or door in the middle). The family opens door 1 from the riwaq, puts coffee, trays or food on the shelf, closes door 1 and calls the host; the host opens door 2 from the guest passage, collects and closes it. The two doors are never open together. Door 1 locks from the riwaq side and door 2 from inside the passage, so the family controls both.
- Bent entry (majaz): an open door 2 shows only the passage, the blank south wall of the family WC and the closed door 1 at the far end. The guest side has no door onto the riwaq.
- The living-room west wall opposite door 1 (x = 4.25, y ≈ 15.7–16.6) has NO window or opening.
- Guest side: guest WC (WC + hand spray only), door in its south wall at the west end, opening inwards; its west wall continues 0.6 m south as a screen wall so the WC door is out of sight from the passage. Three guest basins in one row along the east wall, open to the guest passage. Guest entrance in the foyer's west wall (y ≈ 21.6), door to the men's majlis in its east wall.
- Plumbing: the family WC and guest WC sit 1.1 m apart; the drain crosses under the serving passage floor, with a cleanout access point there. First-floor bathrooms should stack over the north part of the block, near the shaft.
- Replaces: Family basins (2) 2.75 × 2.8, Family WC + basin 2.75 × 3.5, Guest wing 2.75 × 6.3 and the old riwaq → guest wing door. The men's majlis west wall is on the west band line (x = 2.75), 10.25 × 4.75 m.

## East service block (V3.0 on Z4, 15 Oct 2026)
- Layout study: studies/east_wing.typ (stand-alone; main CSV = local + (9, 0)). Block = the east band x 9–13, from the north wall (y 0) to the kitchen's south wall (y 12.5); not a rectangle, the NE corner is cut by the lane wall from (10.051, 0) to (13, 5.427). Block 42 m², no leftover slivers.
- Rooms, north → south:

  | Room | Where (main CSV) | Size | m² |
  |---|---|---|---|
  | Air tower | tip of the cut corner | polygon | 1.65 |
  | Maid bath | y 1.2–2.8, up to the cut wall | sloped, 1.6 m on the majlis wall | 3.42 |
  | Laundry | x 9–10.5, y 2.8–6.0, on the women's majlis wall | 1.5 × 3.2 | 4.80 |
  | Maid room | x 10.5 → cut wall, y 2.8–6.0 | sloped | 6.12 |
  | Kitchen | x 9–13, y 6.0–12.5 | 4 × 6.5 | 26.00 |

- Main cross walls on the house lines: y 6.0 (women's majlis / courtyard) and y 12.5 (dining). The kitchen runs exactly with the courtyard.
- Kitchen isolated: door only to the dining (south) and an open entrance (no door) to the laundry at its north-west corner; no door to the courtyard, riwaq or women's majlis. Sink run on the courtyard wall under the window, hob and hood on the east (outside) wall, fridge and tall storage at the south-east beside the dining door, extra window on the east wall. Aisle ≈ 2.6 m; no island (only 0.6 m deep would fit); room for a small breakfast table.
- Laundry: washer, dryer, utility sink and folding counter in one line on the solid west wall (women's majlis side, no opening), 0.9 m walkway; no outside wall, so a mechanical extract fan to the roof.
- Maid route only kitchen → laundry → maid room → maid bath; no external door. Both maid doors sit at the north end (laundry → maid room at the north end of the laundry's east wall; maid room → maid bath in the room's north wall), so the single bed (0.9 × 2.0) takes the wide south part along the y 6.0 wall, with a wardrobe on the west wall. Make the bath door sliding or opening out so the two doors do not clash.
- Maid room ≈ 6.1 m² on centre lines (≈ 5.3 m² clear, under the earlier 6.5 m² target, accepted); high-sill window in the cut wall (lane side). Maid bath (WC, basin, compact shower) with a vent window in the cut wall.
- One wet line down the west side of the block: maid bath, laundry machines and kitchen sink; cleanout access in the laundry.
- Air tower kept in the tip of the cut corner (≈ 1.65 m² on centre lines, ≈ 1.1 m² clear), cleaned from a roof hatch.
- Solid wall (no door, no window) between the maid wing / laundry and the women's majlis.
- Replaces: Maid bath 1.7 × 2, Maid room 2.75 × 2.8, Laundry 4 × 1.5, Kitchen 4 × 5.
- Drawing engine: base.typ now accepts an optional `pts` column in the room CSV ("x y; x y; …", CSV coordinates) for rooms that are not rectangles; design_v3.typ shifts and rotates those points with the building. Site data in base.typ is unchanged. The maid bath and maid room use it.

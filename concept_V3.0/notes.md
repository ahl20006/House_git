# Taif / Palm House · Design V3.3 · decisions log

## Files and how to check
- `design_v3.typ` is the file you compile for the design (plan, schedules, philosophy). It reads `data/rooms_v3.csv` and the site in `base.typ`.
- `base.typ`: site, envelope, palms, north, checks and the drawing engine. Site data changes only if the land changes.
- `data/rooms_v3.csv`: one row per room (name, x, y, w, d, angle, frame, colour, pts). `#` at the start of a name switches a row off. `pts` ("x y; x y; …") is only for rooms that are not rectangles.
- `studies/guest_wing.typ` (west wash block) and `studies/east_wing.typ` (east service block): stand-alone layout studies with fixtures and labelled doors. They are the source for those blocks; keep them and the CSV in step.
- `site_test.typ` + `data/building.csv`: site-test options for the building footprint (Z3, Z4 …).
- `tools/make_dxf.py` writes `design_v3.dxf` (one DXF with the site, the building and every room, door and fixture); `tools/check_v3.py` compiles everything and cross-checks the CSV, the two studies and the DXF. See `README_DXF.md`.
- Check before you stop: `python tools/check_v3.py` must end with "ALL CHECKS PASSED", and the plan page must show "✓ All checks passed".
- Versions on GitHub: tags `v3.1` (15 Oct 2026), `v3.2` (16 Oct 2026, Revision 02) and `v3.3` (16 Oct 2026, six owner changes). The folder name stays `concept_V3.0`.

## Current design (V3.3, 16 Oct 2026 · Revision 02 + six owner changes)
- Site-test option Z4, extended: a pentagon 13.311 × 24.0 m on wall centre lines (13.561 × 24.25 outside, outside footprint ≈ 318.8 m²). The north-east cut runs parallel to the lane from (10.051, 0) to (13.311, 6.0); then the east wall goes straight south. Square to the M line (rot = 0°), shift (0.91, 3.525): the north wall is where it was in V3.2, the building grew 0.5 m to the south.
- Wall allowances: 250 mm outer walls, 200 mm inner walls, 100 mm dry block partitions in the maid wing, 150–200 mm for walls carrying pipes (clear sizes below use them; the CSV keeps wall centre lines). Outer west wall face 0.785 m from the M line; nearest outer wall face to the envelope ≈ 0.05 m (checked in design_v3.typ). Palms 6.00 / 7.95 m from the outer faces, both beyond the south facade (site_test.typ).
- Bands west → east (CSV x): west band 0–2.75 · riwaq 2.75–4.25 · middle band 4.25–8.95 (4.70 on axes = 4.50 m clear) · east band 8.95–13.311. Main cross lines (CSV y): 6.5 (women's majlis / courtyard), 13.0 (courtyard / living), 19.25 (living / men's majlis), 24.0 (south wall).
- Middle band: women's majlis 4.70 × 6.5 (≈ 28.2 m² clear) · courtyard 4.70 × 6.5 (4.50 × 6.30 clear), open to the sky · living (double height) 4.70 × 6.25.
- Family lobby + riwaq: one straight strip 1.5 × 19.25 (≈ 1.30 m clear) from the front door to the men's majlis; the riwaq end stays closed to the men's majlis.
- Living opens to the riwaq through a 1.40 m opening with no door; the rest of its west wall is a 1.20 m low partition (open above). The stair has no door either.
- West band, north → south: future lift shaft + entry cupboard, stair (store under its landing), utility room with the service shaft inside it, then the west wash block (see below).
- East band, north → south: air tower in the tip of the cut corner, the east service block (maid bath, laundry, maid room, kitchen; see below), then living (normal height) · dining 4.361 × 6.25.
- South: men's majlis 10.561 × 4.75, its west wall on the west band line (x = 2.75).
- Air: the tower catches the NW wind above the roof and brings it down to an underground tunnel that enters the courtyard through a low, closable opening. The tunnel is described, not drawn.

## Changes in V3.3 (16 Oct 2026 · six owner changes on Revision 02)
6. Building 0.5 m longer to the south (north wall and NE cut unchanged on site). The 0.5 m goes in at y 6.0 in the middle and east columns and at the utility / coffee line (y 10.4) in the west column:
   - middle: women's majlis 6.0 → 6.5 m; courtyard, living and men's majlis 0.5 m south, sizes unchanged;
   - east: the maid wing gains 0.5 m (to y 6.5); the kitchen moves 0.5 m south unchanged (still on the courtyard lines);
   - west: coffee corner 2.0 → 2.5 m; everything south of it 0.5 m south; family lobby + riwaq 0.5 m longer.
   - Maid wing: 100 mm dry block partition between laundry and maid room, moved 0.15 m towards the maid room (x 10.5 → 10.65); laundry 1.70 × 3.7 with ≈ 0.95 m clear beside the 0.6 m machines; maid room 7.06 m² on axes, ≈ 6.04 m² clear (the 6.5 m² clear target is NOT reached even with all the extra space; the slope ends at y 6.0, so the maid room now has 0.5 m of straight east wall again). Exterior walls and air tower unchanged; interior walls straight and square.
   - Kitchen: no island, two parallel counter runs (sink on the courtyard wall, hob and hood on the east outside wall).
1. Lift becomes a future placeholder: "Lift (future · shaft placeholder)" 2.25 × 2.2 at the west of the column (≈ 2.0 × 2.0 m clear shaft) + "Entry cupboard" 0.5 × 2.2 beside it (shallow, ≈ 0.4 m clear, opening onto the family lobby: shoes, coats).
   - For about 10 years from now; two stops only (ground and first, no roof stop; the roof by the stair); sized for a standard Saudi-market villa lift (4–6 persons, wheelchair-capable); final size from a supplier's civil drawing (use the largest of 2–3 quotes); ask the supplier what a future roof stop would need.
   - Build now: shaft walls on both floors; pit (≈ 1.2 m, to confirm) built and covered, clear of drains and the air tunnel; first-floor roof slab over the shaft designed to open later; a separate electrical line; the shaft is a store until then.
   - Lift door onto the family lobby: the entry cupboard stands in front of the shaft's east wall, so its south ≈ 1.0 m is built as removable joinery; when the lift comes, that part is removed to form the lift door reveal (drawn as "future lift door").
2. "Coffee corner (open use)" becomes "Hospitality kitchen" 2.75 × 2.5 (≈ 5.8 m² clear): light (clean) kitchen for coffee, tea, dates, desserts and reheating; serving base for the men's majlis. Open to the riwaq, no door, no hob; L-counter on the north wall and the west wall (the wall shared with the family basins stays plain), small sink, under-counter fridge, microwave, kettle and coffee things, storage for cups and trays, small extract fan. The full-height wall to the family basins stays. The main east kitchen is the heavy (dirty) kitchen.
3. Serving passage: no shelf, no fixed equipment; 1.6 → 1.4 m on axes (1.20 m clear). The guest WC's south wall is on the men's majlis north wall line (y 19.25); the guest WC grew northwards to 1.5 × 1.75 (≈ 1.3 × 1.55 clear). Guest basins 2.0 → 2.15 m deep (owner decision: they take the 0.15 m left by the new line); guest passage 3.7 → 3.9 m; foyer unchanged. The two serving doors stay.
4. Guest basins renamed "Guest basins (trough · 3 taps)": one trough ≈ 1.8 m with three taps on the east wall.
5. Foyer: outside entrance = double door 1.40 m (two leaves, opening in) at the north end of its west wall; opening into the men's majlis = 1.80 m, no door, at the south end of its east wall (≈ 0.65 m of wall left at its north end); shoe cabinet and bisht / shemagh hooks on that wall facing the entrance. NOTE: in a 2.6 m foyer a 1.40 m door and a 1.80 m opening cannot be fully offset; they overlap by ≈ 0.75 m, so the bent entry is partial (a curtain or a short screen in front of the opening would close the view). Guest entry arrow and door marks updated.
- Documentation-only notes (no geometry change):
  - Stair 2.75 × 5.7 m is good (≈ 16.4 cm risers, 28 cm goings, ≈ 1.10 m flights, ≈ 1.2 m half landing for a 3.6 m storey); the engineer confirms the floor-to-floor height, headroom at the slab opening (≥ ≈ 2.1 m) and handrails. The store under the half landing stays.
  - Utility room and shaft: size and position correct; the west shaft serves the west wash block and first-floor bathrooms above or beside it only.
  - Plumbing: kitchen, laundry and maid bath drain under the slab straight out to the east (manhole in the east service yard), with a small east duct (≈ 0.6 × 0.6 m) for the vent stack, any first-floor bathroom above the east side and the kitchen extract. Water: one line from the main manifold through the ceiling, with a small secondary manifold in the laundry. Coordinate drain depths with the air tunnel, which also runs under the east side. A separate plumbing study (plumbing.typ) will be made later.
  - Family basins: straight counter, no cupboards opposite (≈ 0.75–0.8 m in front, plus the open riwaq). Family WC: WC and basin, no shower (showers on the first floor).
  - Men's majlis: size unchanged (10.561 × 4.75); high windows on the south wall (light and privacy); main seating at the east end, away from the entrance; air-conditioning hidden in the ceiling or on the end wall, not above the seats.
  - Maid room window in the sloped wall: high sill (≥ 1.5 m) for privacy from the lane.
  - Gas (if used): cylinder / tank cabinet outside the east wall in the service yard, short line to the kitchen.
- Site test: data/building.csv active row "Z4 V3.3" (outside faces 13.561 × 24.25, NE cut 3.311 × 6.093, centre (7.5655, 15.525)); the V3.2 row is kept switched off. Envelope gap still 0.05 m (the 0.5 m env-margin test still shows NO).

## Changes in V3.2 (16 Oct 2026 · Revision 02, five owner notes)
1. The slope runs on to the south end of the maid room (y 6.0); the east wall then goes straight south. Width on axes 13.0 → 13.311 m; the extra 0.311 m went to the kitchen, dining and men's majlis.
2. Building moved 0.26 m east (shift 0.65 → 0.91): outer west face 0.525 → 0.785 m from the M line, inside the fixed north position and rotation.
3. Middle band exactly 4.50 m clear: 4.75 → 4.70 m on axes (its east edge moved 0.05 m west to x 8.95; the laundry gained those 5 cm).
4. Walls and openings: a full-height wall between the coffee corner and the family basins (each opens to the riwaq on its own); no stair door and no living-room door (open entrances); the living room's west wall becomes a 1.20 m low partition.
5. Serving passage 1.1 → 1.6 m on axes (1.40 m between walls = 0.20 m shelf + 1.20 m clear); door 1 0.90 m, door 2 1.05 m. The guest block (guest WC, 3 basins, guest passage, foyer) moved 0.50 m south as one; the south facade moved 0.50 m south, so the living, dining and riwaq are 0.50 m longer and the men's majlis keeps 4.75 m.
- Privacy note: with the low partition opposite serving door 1, the living room is no full screen for someone standing; family privacy now rests on the two serving doors never being open together (the V3.1 rule "solid living-room wall opposite door 1" is withdrawn).
- Laundry: ≈ 0.75 m clear beside the 0.6 m machines (below the earlier 0.9 m aim); check the real appliances.
- Site drawing extras of Revision 02 (garden, parking) are illustrations only and not in the model.
- design_v3.typ now stops with an error if the outer wall face crosses the envelope, and prints the envelope and M-line gaps in the plan note.
- Site test: data/building.csv now has the active row "Z4 Rev 02 (V3.2)" on outside wall faces: 13.561 × 23.75 m, NE cut 3.311 along the north facade × 6.093 down the east facade, centre (7.5655, 15.275); the old Z3 and Z4 rows are kept switched off with #. Result: 311.99 m², west face 0.79 m from the M line, palms 6.06 / 8.21 m clear, but only 0.05 m to the envelope, so the 0.5 m env-margin test in site_test.typ shows NO (decision open: keep the 0.5 m allowance or lower it).

## Changes in V3.1 (15 Oct 2026)
- Building moved from Z3 to Z4 (0.75 m wider through the middle): courtyard, women's majlis and double-height living each 4.75 m wide; east rooms moved 0.75 m east; building 0.375 m further west.
- Men's majlis west wall moved onto the west band line (x = 2.75).
- Family basins, family WC and guest wing redesigned as ONE west wash block, with a two-door serving passage as the only family / guest link.
- East service block redesigned: kitchen 4 × 6.5 on the courtyard lines, laundry on the women's majlis wall, maid room and maid bath running up to the sloped cut wall.
- `base.typ`: optional `pts` column for rooms that are not rectangles (site data unchanged).
- Studies moved to `studies/`; one DXF of the whole design added (`design_v3.dxf`).

## Open choices
- OPEN DECISION (not drawn): a small service door from the laundry to the east service yard, kept locked with the owner's key only, for rubbish and deliveries.
- Foyer: accept the partial bent entry (≈ 0.75 m overlap of door and majlis opening) or add a curtain / short screen.
- Maid room ≈ 6.0 m² clear, below the 6.5 m² target.
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
- Living is one open room, 9.061 × 6.25 m in V3.2 (8.75 × 5.75 m in V3.1), split by a ceiling-height change only (no wall):
  - Living (double height), middle band south of the courtyard, 4.70 × 6.25 m (V3.2): faces the courtyard, high operable clerestory windows for stack ventilation; simple 4.70 m roof span; open to the riwaq through a 1.40 m opening, then a 1.20 m low partition.
  - Living (normal height) · dining, east band south of the kitchen, 4.361 × 6.25 m (27.26 m², V3.2): daily dining beside the kitchen door; ducts and lighting in its ceiling; the first floor continues above it (and above the kitchen and maid wing).
- No upper floor over the double-height part or the courtyard.
- Possible south clerestory windows over the men's majlis roof: first-floor decision, noted only.

## West wash block (V3.0 on Z4, 15 Oct 2026)
- Family basins, family WC and the guest wing are now ONE section: the west wash block, x 0–2.75, y 10.4–24.0 (2.75 × 13.6 m = 37.4 m² in V3.3; 13.1 in V3.2; 12.6 in V3.1), between the utility room (north), the riwaq (east, x 2.75–4.25) and the men's majlis (east, from y 18.75). Layout study: studies/guest_wing.typ (local y + 10.4 = CSV y); the same rooms are in data/rooms_v3.csv.
- One strip of wet rooms on one drain run, north → south:

  | Room | w × d (m) | m² |
  |---|---|---|
  | Hospitality kitchen (V3.3, was Coffee corner) | 2.75 × 2.5 | 6.88 |
  | Family basins (2) | 2.75 × 1.5 | 4.13 |
  | Family WC + basin | 2.75 × 1.7 | 4.68 |
  | Serving passage (2 doors) | 2.75 × 1.4 (V3.3) | 3.85 |
  | Guest WC | 1.5 × 1.75 (V3.3) | 2.63 |
  | Guest basins (trough · 3 taps) | 1.5 × 2.15 (V3.3) | 3.23 |
  | Guest passage | 1.25 × 3.9 (V3.3) | 4.88 |
  | Foyer + entry | 2.75 × 2.6 | 7.15 |
  | **Block** | **2.75 × 13.6** | **37.40** |

- Family side: coffee corner and family basins are each open to the riwaq (no doors), with a full-height wall between them (V3.2); the family WC door is off the basin niche. The coffee corner (counter, small sink, under-counter fridge) is the serving base; its final use is still open.
- Serving passage = the ONLY link between family and guests, with only two doors (no wall or door in the middle). V3.2: 1.6 m deep on axes, 1.40 m between walls: a 0.70 × 0.20 shelf and 1.20 m clear in front of it; door 1 0.90 m, door 2 1.05 m. The family opens door 1 from the riwaq, puts coffee, trays or food on the shelf, closes door 1 and calls the host; the host opens door 2 from the guest passage, collects and closes it. The two doors are never open together. Door 1 locks from the riwaq side and door 2 from inside the passage, so the family controls both.
- Bent entry (majaz): an open door 2 shows only the passage, the blank south wall of the family WC and the closed door 1 at the far end. The guest side has no door onto the riwaq.
- V3.1 rule withdrawn in V3.2: the living-room west wall opposite door 1 is now a 1.20 m low partition, so privacy rests on the two serving doors.
- Guest side: guest WC (WC + hand spray only), door in its south wall at the west end, opening inwards; its west wall continues 0.6 m south as a screen wall so the WC door is out of sight from the passage. Three guest basins in one row along the east wall, open to the guest passage. Guest entrance in the foyer's west wall (y ≈ 22.1), door to the men's majlis in its east wall. V3.2: the whole guest side moved 0.50 m south (sizes unchanged); guest passage ≈ 1.025 m clear.
- Plumbing: the family WC and guest WC sit 1.1 m apart; the drain crosses under the serving passage floor, with a cleanout access point there. First-floor bathrooms should stack over the north part of the block, near the shaft.
- Replaces: Family basins (2) 2.75 × 2.8, Family WC + basin 2.75 × 3.5, Guest wing 2.75 × 6.3 and the old riwaq → guest wing door. The men's majlis west wall is on the west band line (x = 2.75), 10.25 × 4.75 m.

## East service block (V3.0 on Z4, 15 Oct 2026)
- Layout study: studies/east_wing.typ (stand-alone; main CSV = local + (8.95, 0)). Block = the east band x 8.95–13.311, from the north wall (y 0) to the kitchen's south wall (y 13.0 in V3.3); not a rectangle, the NE corner is cut by the lane wall from (10.051, 0) to (13.311, 6.0), one continuous slope to y 6.0, then straight (V3.3: 0.5 m of straight east wall at the maid room's south end). Block 46.91 m², no leftover slivers.
- Rooms, north → south:

  | Room | Where (main CSV) | Size | m² |
  |---|---|---|---|
  | Air tower | tip of the cut corner | polygon | 1.71 |
  | Maid bath | y 1.2–2.8, up to the cut wall | sloped, 1.6 m on the majlis wall | 3.50 |
  | Laundry | x 8.95–10.65, y 2.8–6.5, on the women's majlis wall | 1.70 × 3.7 | 6.29 |
  | Maid room | x 10.65 → cut wall, y 2.8–6.5 | sloped + 0.5 m straight | 7.06 (≈ 6.04 clear) |
  | Kitchen | x 8.95–13.311, y 6.5–13.0 | 4.361 × 6.5 (≈ 4.14 clear) | 28.35 |

- Main cross walls on the house lines: y 6.0 (women's majlis / courtyard) and y 12.5 (dining). The kitchen runs exactly with the courtyard.
- Kitchen isolated: door only to the dining (south) and an open entrance (no door) to the laundry at its north-west corner; no door to the courtyard, riwaq or women's majlis. Sink run on the courtyard wall under the window, hob and hood on the east (outside) wall, fridge and tall storage at the south-east beside the dining door, extra window on the east wall. ≈ 2.94 m between the counter lines (V3.2); no island (only 0.6 m deep would fit); room for a small breakfast table.
- Laundry: washer, dryer, utility sink and folding counter in one line on the solid west wall (women's majlis side, no opening), ≈ 0.75 m clear beside the machines (V3.2); no outside wall, so a mechanical extract fan to the roof.
- Maid route only kitchen → laundry → maid room → maid bath; no external door. Both maid doors sit at the north end (laundry → maid room at the north end of the laundry's east wall; maid room → maid bath in the room's north wall), so the single bed (0.9 × 2.0) takes the wide south part along the y 6.0 wall, with a wardrobe on the west wall. Make the bath door sliding or opening out so the two doors do not clash.
- Maid room ≈ 6.21 m² on centre lines (≈ 5.10 m² clear, under the earlier 6.5 m² target, accepted); high-sill window in the cut wall (lane side). Maid bath (WC, basin, compact shower) with a vent window in the cut wall.
- One wet line down the west side of the block: maid bath, laundry machines and kitchen sink; cleanout access in the laundry.
- Air tower kept in the tip of the cut corner (≈ 1.71 m² on centre lines, ≈ 1.1 m² clear), cleaned from a roof hatch.
- Solid wall (no door, no window) between the maid wing / laundry and the women's majlis.
- Replaces: Maid bath 1.7 × 2, Maid room 2.75 × 2.8, Laundry 4 × 1.5, Kitchen 4 × 5.
- Drawing engine: base.typ now accepts an optional `pts` column in the room CSV ("x y; x y; …", CSV coordinates) for rooms that are not rectangles; design_v3.typ shifts and rotates those points with the building. Site data in base.typ is unchanged. The maid bath and maid room use it.

# Taif / Palm House · Ground floor V4.0 (final) · with the V5.0 and V5.1 changes

16 Oct 2026 · git tag `v4.0` · concept design, not for construction.

**V5.0 (20 Oct 2026, git tag `v5.0`):** two coordination changes from the first floor, nothing else moved:
- the **east duct is removed**: the kitchen extract leaves straight through the east wall at the hood, the vent stack (and the suite bath drain from above) runs in a stack on the outside face of the east wall;
- **three columns** (x 5.6; y 6.5 in the women's majlis south wall, y 13.0 as a pier in the courtyard / living glass, y 19.25 in the living's south wall) carry the edge beam of the first floor's 1.35 m west projection; the ground floor under the projection (x 4.25–5.6) has a normal-height ceiling. Engineer to confirm (or a plain cantilever without columns).

**V5.1 (24 Oct 2026, git tag `v5.1`):** the first-floor projection is split (0.675 m inward, 0.675 m outward), so the **three columns at x 5.6 are removed**. The ground floor under the inward part (x 4.25–4.925) has a normal-height ceiling; the first-floor west wall stands 0.675 m beyond the ground-floor west wall (south of y 10.4) on cantilever beams, shading the west wall and roofing the guest entrance. No room changes. Top open item: municipality / engineering office to confirm the first-floor projection 0.11 m from the M line; if not allowed, back to V5.0 (tag `v5.0`).

This is the master description of the ground floor. Drawing: `output/design_gf.pdf` (from `design_gf.typ` + `data/rooms_gf.csv`). CAD: `output/taif_ground_floor_V5.1.dxf`. Room studies: `output/guest_wing.pdf`, `output/east_wing.pdf`. Site test: `output/site_test.pdf`.

## 1. Coordinates, site and placement

- **Units:** metres. **Origin:** survey peg **M1** (east post of the gate).
- **Axes:** x is east, square to the M line; y runs along the M line, **southwards**. The DXF has y pointing up.
- **Two frames:**
  - **CSV frame:** room coordinates in `data/rooms_gf.csv`. The building's north-west corner is at (0, 0).
  - **Site frame:** CSV + shift.
- **Shift:** (0.91, 3.525). **Rotation:** 0°, so the building is square to the M line. True north is 21.4° off the M line, and the NW wind is 23.6° off.
- **Site data** is in `base.typ`: plot, buildable envelope, driveway, lane, north wall, palms P1 (20.6, 28.09) and P2 (21.39, 31.87), pegs M1–M4 on the M line.
- **Outline (wall centre lines, CSV):** (0, 0) → (10.051, 0) → (13.311, 6.0) → (13.311, 24.0) → (0, 24.0).
  - It's a pentagon whose north-east corner is cut parallel to the lane, down to y 6.0. The east wall then runs straight south.
  - 13.311 × 24.0 m on axes, **13.561 × 24.25 m outside** (outside footprint ≈ 318.8 m², 309.68 m² on axes).
- **Walls (allowances):** 250 mm outer, 200 mm inner, 100 mm dry block partitions (maid wing), 150–200 mm for walls carrying pipes. Rooms are stored on wall centre lines; clear sizes subtract half of each wall.
- **Gaps:**
  - outer west wall face to the M line **0.785 m**;
  - nearest outer wall face to the envelope **0.05 m** (north / lane side). `design_gf.typ` stops with an error if this goes below 0.
  - palms **6.00 m / 7.95 m** from the outer faces, both beyond the south facade (`studies/site_test.typ`).
- **Grid of main lines (CSV):**
  - x = 0 · 2.75 · 4.25 · 8.95 · 13.311;
  - y = 6.5 · 13.0 · 19.25 · 24.0.
- **Bands west → east:** west band 0–2.75 · riwaq 2.75–4.25 · middle band 4.25–8.95 (4.70 on axes = **4.50 m clear**) · east band 8.95–13.311.

## 2. Room schedule

Areas from `tools/schedule.py` (axes = wall centre lines; clear = finished faces). Totals: 308.31 m² of rooms on axes incl. the courtyard, plus the air tower (1.37 m²) = 309.68 m².

| Room | Axes w × d (m) | Axes m² | Clear m² | Purpose · doors · rules |
|---|---|---|---|---|
| Courtyard | 4.7 × 6.5 | 30.55 | 28.35 | Open to the sky, enclosed on four sides, the cool heart. 4.50 × 6.30 clear. Low closable air opening from the tunnel. |
| Women's majlis | 4.7 × 6.5 | 30.55 | 28.24 | North of the courtyard. Women guests come in by the family door. Solid wall to the maid wing (east). |
| Living (double height) | 4.7 × 6.25 | 29.38 | 27.23 | South of the courtyard. Double height, high operable windows. Open to the riwaq through a 1.40 m opening (no door), then a 1.20 m low partition (open above). |
| Living (normal height) · dining | 4.361 × 6.25 | 27.26 | 25.02 | One open room with the living. Ceiling-height change on x 8.95. Door to the kitchen. First floor above. |
| Men's majlis | 10.561 × 4.75 | 50.16 | 46.77 | South, full width east of the west band. Entered from the foyer by a 1.80 m opening (no door). High windows on the south wall. Main seating at the east end. AC hidden in the ceiling or end wall, not over the seats. |
| Kitchen | 4.361 × 6.5 | 28.35 | 26.06 | Heavy (dirty) kitchen, isolated. Door to the dining only, open entrance to the laundry. No island; two parallel runs (sink under the courtyard window, hob + hood + fridge on the outside east wall). East duct in its NE corner. |
| Laundry | 1.7 × 3.7 | 6.29 | 5.42 | Open entrance from the kitchen. Washer, dryer, utility sink, folding shelves on the solid west wall. ≈ 0.95 m clear walkway. Extract fan to the roof. The maid's only route. |
| Maid room | sloped | 7.06 | 6.04 | Behind a 100 mm partition. Door from the laundry at the north end. Single bed 0.9 × 2.0 along the south wall, wardrobe on the west wall. Window in the cut wall, sill ≥ 1.5 m. |
| Maid bath | sloped | 3.84 | 3.03 | 1.8 m deep, from the air tower to y 2.8. WC, basin, compact shower. Vent window in the cut wall. Door from the maid room only, 0.70 m clear (sliding or opening out). |
| Lift (future · shaft placeholder) | 2.25 × 2.2 | 4.95 | 4.00 | Shaft ≈ 2.0 × 2.0 m clear, used as a store until the lift comes (§3). |
| Entry cupboard | 0.5 × 2.2 | 1.10 | 0.59 | Shallow cupboard on the family lobby (shoes, coats). Its south ≈ 1.0 m is removable joinery that becomes the future lift door reveal. |
| Family lobby + riwaq | 1.5 × 19.25 | 28.88 | 24.73 | ≈ 1.30 m clear. One straight strip from the family entrance (north wall) to the men's majlis wall (closed there). Windows onto the courtyard. |
| Stair | 2.75 × 5.7 | 15.68 | 13.89 | Open access, no door. ≈ 16.4 cm risers, 28 cm goings, ≈ 1.10 m flights, ≈ 1.2 m half landing for a 3.6 m storey. Store under the half landing. |
| Utility room (shaft inside) | 2.75 × 2.5 | 6.88 | 5.81 | West service shaft (≈ 1.0 × 1.2 m clear), main electrical panel, water manifold, water heater. One door from the riwaq. 0.9 m kept clear in front of the shaft door. |
| Hospitality kitchen | 2.75 × 2.5 | 6.88 | 5.81 | Light (clean) kitchen for coffee, tea, dates, desserts and reheating; the serving base for the men's majlis. Open to the riwaq, no door, no hob. L-counter (north + west walls), small sink, under-counter fridge, microwave, cups and trays, small extract fan. |
| Family basins (2) | 2.75 × 1.5 | 4.12 | 3.28 | Open niche on the riwaq. Straight counter, nothing opposite. Full-height wall to the hospitality kitchen. |
| Family WC + basin | 2.75 × 1.7 | 4.68 | 3.79 | WC and basin, no shower (showers on the first floor). Door off the basin niche. |
| Serving passage (2 doors) | 2.75 × 1.4 | 3.85 | 3.03 | The ONLY family / guest link. 1.20 m clear, no shelf. Door 1 (0.90) to the riwaq, door 2 (1.05) to the guest passage; never open together, both locked from the family side. |
| Guest WC | 1.5 × 1.75 | 2.62 | 2.02 | South wall on the men's majlis north line. WC and hand spray. Door in the south wall, hidden from the passage by a 0.6 m screen wall. |
| Guest basins (trough · 3 taps) | 1.5 × 2.15 | 3.22 | 2.53 | One trough ≈ 1.8 m with three taps on the east wall, open to the guest passage. |
| Guest passage | 1.25 × 3.9 | 4.88 | 3.79 | ≈ 1.025 m clear, from the serving door 2 to the foyer. |
| Foyer + entry | 2.75 × 2.6 | 7.15 | 6.00 | Double door 1.40 m (two leaves, opens in) at the north end of the west wall. 1.80 m opening into the men's majlis at the south end of the east wall. Shoe cabinet + bisht / shemagh hooks on the wall facing the entrance. |
| Air tower (not a room) | polygon, 1.0 m deep | 1.37 | 0.88 | In the tip of the cut corner. At least 0.93 m clear wide. One person can step in to clean; main cleaning from a roof hatch. |

## 3. Design decisions to date

- **Courtyard house:** the rooms the family uses most open onto a small shaded courtyard. Outer walls are quiet with small openings; light, air and view come from inside.
- **One living room, two heights:**
  - the courtyard half is double height (a stack-ventilation chimney, high operable windows);
  - the east half is normal height (dining, the first floor above).
  - No upper floor over the double-height part or the courtyard.
- **West service band:** family entrance + entry cupboard, future lift, stair, utility room with the shaft, then the west wash block. Services rise in one place and give one stiff core.
- **West wash block (2.75 × 13.6 m, `studies/guest_wing.typ`):**
  - one strip of wet rooms on one drain run: hospitality kitchen, family basins, family WC, guest WC, guest trough;
  - the family side is open to the riwaq, and the guest side has **no door onto the riwaq**;
  - the only link is the **two-door serving passage**: the family leaves the tray and closes door 1, then calls the host, who opens door 2;
  - an open door 2 shows only the passage and a blank wall (majaz).
- **Living-room privacy:** the living room's west wall to the riwaq is a 1.20 m low partition, so family privacy rests on the two serving doors never being open together.
- **Hospitality kitchen vs main kitchen:** a light kitchen in the west block (serving the majlis) and the heavy kitchen in the east block.
- **Guest foyer and majaz:** a double door at one end and the majlis opening at the other. In a 2.6 m foyer they overlap by ≈ 0.75 m, so the majaz is partial (open item).
- **Men's majlis:** size fixed; high south windows; seating at the east end; AC out of the seating zone.
- **East service block (`studies/east_wing.typ`):**
  - the kitchen sits on the courtyard lines (y 6.5–13.0);
  - the laundry runs along the solid women's-majlis wall;
  - the maid room and maid bath use the sloped corner;
  - maid access only kitchen → laundry → maid room → maid bath, with no external door.
- **Maid room size:** the maid room stays at ≈ 6.0 m² clear. The earlier 6.5 m² target is **dropped**, because the sloped cut wall makes the north part too narrow. The freed 0.2 m of the air tower went to the maid bath.
- **Air tower and tunnel:** the tower in the cut corner catches the NW wind above the roof and brings it down to an underground tunnel. The tunnel enters the courtyard through a low closable opening. Every opening can be closed. The tunnel is described, not drawn.
- **Future lift (two stops):**
  - fitted in about 10 years, ground and first floor only (no roof stop; the roof is reached by the stair);
  - for a standard Saudi-market villa lift (4–6 persons, wheelchair-capable); the final size comes from a supplier's civil drawing (use the largest of 2–3 quotes); ask the supplier what a future roof stop would need;
  - build now: shaft walls on both floors; pit ≈ 1.2 m (to confirm), built and covered, clear of drains and the air tunnel; a first-floor roof slab over the shaft designed to open later; a separate electrical line; the lift door onto the family lobby.
  - The shaft is a store until then.
- **Utility room and west shaft:** correct in size and position. The shaft serves the west wash block and the first-floor bathrooms above or beside it.
- **Plumbing strategy:**
  - **west:** the shaft and one drain run under the wash block, with a cleanout under the serving passage;
  - **east:** kitchen, laundry and maid bath drain under the slab straight out to the east, to a manhole in the east service yard. *(V5.0: the east duct is removed.)* The vent stack and the first-floor suite bath drain run in a stack on the outside face of the east wall; the kitchen extract leaves straight through the east wall at the hood;
  - **water:** from the main manifold through the ceiling, with a small secondary manifold in the laundry;
  - drain depths to be coordinated with the air tunnel (also under the east side);
  - gas, if used: a cylinder cabinet outside the east wall in the service yard.
- **Walls:**
  - 100 mm dry block partitions where nothing is carried (laundry / maid room);
  - 150–200 mm for walls with pipes;
  - all interior walls straight and square.
  - Main cross walls stay on the grid lines (y 6.5, 13.0, 19.25), so the east band works as its own bay.

## 4. Open items

1. **Locked laundry service door:** a small door from the laundry to the east service yard, for rubbish and deliveries, locked with the owner's key only. Owner decision; not drawn.
2. **Envelope gap only 0.05 m** at the north / lane side. It must be confirmed by the official survey before the wall faces are fixed. The site test's 0.5 m allowance shows NO.
3. **Foyer majaz only partial:** the door and opening overlap ≈ 0.75 m. Add a curtain or short screen.
4. **`plumbing.typ` study still to do:** drain falls, manholes, the east-wall stack, tunnel crossings.
5. **Review together with the first floor:** the middle column (women's majlis, courtyard, living) and the riwaq.
6. **Engineer:** the structural grid, wall build-ups, floor-to-floor height (3.6 m assumed), stair headroom (≥ ≈ 2.1 m at the slab opening) and handrails.
7. **East-wall stack and hood position** (V5.0: no east duct; hood south of y ≈ 7.5) to confirm with the plumbing / MEP engineer.
8. **Maid bath door:** the wall on the maid side is only ≈ 0.73 m long, so the 0.70 m clear door is tight (sliding or opening out).

## 5. Changelog

| Version | Date | What changed |
|---|---|---|
| C1 (V1–V2) | before 11 Oct 2026 | Early concept: 6 × 5 courtyard, west service band, men's majlis 10 × 5.5 (`archive/rooms_C1.csv`). |
| V3.0 | 11 Oct 2026 | Compact courtyard house on site-test option Z3; services in a utility room; one living room, two heights. |
| V3.1 | 15 Oct 2026 | Z4 (0.75 m wider); men's majlis on the west band line; one west wash block with the two-door serving link; east service block; `pts` column; first DXF. |
| V3.2 | 16 Oct 2026 | Revision 02: slope to y 6.0, building 0.26 m east, middle 4.50 m clear, coffee / basins wall, open stair and living, 1.20 m low wall, serving 1.20 m clear, guest block 0.5 m south. |
| V3.3 | 16 Oct 2026 | Building 0.5 m longer to the south; future lift + entry cupboard; hospitality kitchen; serving 1.4 m, guest WC on the majlis line, trough basin, foyer double door + 1.8 m opening. |
| V3.4 | 16 Oct 2026 | Air tower 1.2 → 1.0 m deep; maid wing 0.2 m north. |
| **V4.0** | **16 Oct 2026** | **Ground floor final:** the freed 0.2 m goes to the maid bath (1.8 m deep), maid room back to V3.3 (≈ 6.0 m² clear, target dropped); east duct placed; repo cleaned (`taif_house/`, `docs/`, `output/`, `archive/`); first-floor starting point. |
| V5.0 | 20 Oct 2026 | First floor designed (studies/ff_family.typ, studies/ff_suite.typ); ground floor coordinated: east duct removed, three columns for the first-floor west projection. |
| **V5.1** | **24 Oct 2026** | **Split first-floor projection** (0.675 in + 0.675 out): the three columns removed; M-line approval pending. |

## 6. Files and how to check

- **Ground floor:** `design_gf.typ` + `data/rooms_gf.csv` (site from `base.typ`).
- **First floor (V5.1):** `design_ff.typ` + `data/rooms_ff.csv`, room design in `studies/ff_family.typ` and `studies/ff_suite.typ`. Brief and decisions: `docs/FIRST_FLOOR_BRIEF.md`. Construction notes: `docs/DETAILS.md`.
- **Studies:** `studies/guest_wing.typ`, `studies/east_wing.typ`, `studies/site_test.typ` + `studies/building.csv`.
- **Tools:**
  - `python taif_house/tools/check.py` compiles everything into `output/`, cross-checks the studies and the CSV, rebuilds the DXF, and must end with **ALL CHECKS PASSED**;
  - `tools/schedule.py` prints the room schedule;
  - `tools/make_dxf.py` writes the DXF.
- **History:** `docs/notes.md` (decisions log); `archive/` (superseded files; git history keeps everything).

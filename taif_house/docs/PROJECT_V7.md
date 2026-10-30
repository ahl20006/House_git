# Taif / Palm House · V7.1 · master document

Concept design of a two-storey courtyard house in Taif. This document describes the whole house as of **V7.1** (git tag `v7.1`, 31 Oct 2026: the arched enclosure windows and the three-arch courtyard arcade, §4.30; V7.0 of the same day brought the courtyard enclosure, the maid room, the roof access with the attic and the design language, §4.25–4.29). The open items are listed in `OPEN_ITEMS.md`, and the next steps are in `NEXT_SESSION.md`. The figures below come from the project files: `data/*.csv`, the design files and the studies. They match the presentation `output/Taif_House_V7.1_presentation.pdf` (12 sheets; sheet 08 is the schedules, sheets 11–12 the roof and the elevations). The design language is in `DESIGN_LANGUAGE.md`.

*Concept design, not for construction. Structure, services, levels and the site survey still need the engineers' and the municipality's review.*

---

## 1. Coordinates and site

- **Units:** metres. **Origin:** survey peg **M1**, the east post of the gate.
- **Axes:**
  - x runs east, square to the M line;
  - y runs along the M line, **southwards**;
  - the DXFs draw y pointing up, so a point (x, y) is (x, −y) in the DXF.
- **Two frames:**
  - **CSV frame:** the room coordinates in `data/rooms_gf.csv` and `data/rooms_ff.csv`. The ground floor's north-west wall corner is at (0, 0).
  - **Site frame:** CSV + shift.
- **Placement** (`design_gf.typ`, also used by the first floor):
  - shift **(0.91, 3.825)** (V6.3: 0.30 m further south than before, a provisional safety margin to the lane setback line until the official survey);
  - rotation **0°**, so the house is square to the M line;
  - true north is **21.4°** off the M line and the prevailing NW wind **23.6°** off.
- **Site data** (`base.typ`, fixed):
  - the plot and the buildable envelope (**667.87 m²**);
  - the driveway on the west, the lane on the north-east, the north street wall;
  - pegs M1–M4 on the M line (y 0, 6.36, 18.52, 28.8);
  - palms **P1 (20.6, 28.09)** and **P2 (21.39, 31.87)**, both beyond the south facade.

## 2. Outline, envelope and gaps

- **Ground-floor outline** (wall centre lines, CSV): (0, 0) → (10.051, 0) → (13.311, 6.0) → (13.311, 24.0) → (0, 24.0).
  - A pentagon whose north-east corner is cut parallel to the lane down to y 6.0; the east wall then runs straight south.
  - **13.311 × 24.0 m on axes, 13.561 × 24.25 m outside.** Outline on axes 309.68 m²; outside footprint **318.77 m²**, including the courtyard.
- **First-floor outline:**
  - the same as the ground floor: the first-floor outer walls stand on the ground-floor outer walls (309.68 m² on axes);
  - the courtyard sky and the double-height void (40.16 m², 3.15 m wide) have no floor;
  - the 1.55 m west projection over the courtyard and the void is carried by an edge beam and three columns at x 5.80 (§4.15, §4.25);
  - the conditioned house is closed round the open courtyard by the steel windows W1 / W2 / W3 (§4.25), arched since V7.1 (§4.30), over a three-arch arcade in the courtyard bay.
- **Walls:**
  - allowances 250 mm outer, 200 mm inner, 100 mm dry block partitions (maid wing), ≈ 60 mm steel window frames on the courtyard edges (V7.0);
  - rooms are stored on wall centre lines; clear areas subtract half of each wall.
- **Gaps:**

| Gap | Value | Where it comes from |
|---|---|---|
| Ground-floor outer west face → M line | **0.785 m** | `design_gf.typ` (m-gap) |
| First-floor outer west face → M line | **0.785 m** | `design_ff.typ` (on the ground-floor wall) |
| Nearest outer wall face → envelope (the lane side; the north street line is 0.80 m away) | **0.20 m** (V6.3, provisional) | `design_gf.typ` (env-gap, to confirm by survey) |
| Palms P1 / P2 → outer walls (trunk faces) | **5.99 m / 7.84 m** | `presentation.typ` (sheet 01) |
| Floor to floor (assumed) | **3.60 m** | `studies/sections.typ` (to confirm) |

- **Grid of main lines (CSV):**
  - x = 0 · 2.75 · 4.25 · 5.80 (the colonnade) · 8.95 · 13.311;
  - y = 6.5 · 13.0 · 19.25 · 24.0 (the kitchen's north wall is a partition at y 7.0 since V7.0; the beam line stays at y 6.5).
- **Bands, west → east:**
  - west band 0–2.75;
  - riwaq 2.75–4.25;
  - middle band 4.25–8.95 (4.70 m on axes = **4.50 m clear**);
  - east band 8.95–13.311.

## 3. Room schedules

Room numbers follow the CSV order (G.. ground floor, F.. first floor), as in the presentation and the DXFs. *Axes* = wall centre lines; *clear* = inside the walls as drawn.

### 3.1 Ground floor (`data/rooms_gf.csv`, `design_gf.typ`, studies `guest_wing.typ` and `east_wing.typ`)

| No. | Room | Axes (m) | Axes m² | Clear m² | Purpose · doors · rules |
|---|---|---|---|---|---|
| G01 | Courtyard | 4.7 × 6.5 | 30.55 | (4.5 × 6.3) | The cool heart, open to the sky, enclosed on four sides. A low closable opening from the air tunnel. Glazed to the riwaq, the women's majlis, the living and the kitchen sink. Its west 1.55 m is under the first-floor projection, a colonnade with columns at y 6.5 and 13.0 (x 5.80). The sky opening above is 3.15 × 6.5 m; the first-floor edges round it are glazed (V7.0) with arched windows (V7.1). Under the projection a three-arch arcade: two slender stone columns Ø0.25 at y 8.667 and 10.833 between C21 and C22 (V7.1). |
| G02 | Women's majlis | 4.7 × 6.5 | 30.55 | 28.24 | North of the courtyard. Women guests come in through the family door. Solid wall to the maid wing. |
| G03 | Living (double height) | 4.7 × 6.25 | 29.38 | 27.83 | South of the courtyard: double height, high operable windows (a stack-ventilation chimney). Entered from the riwaq through a 1.40 m arched opening (head +2.60); its west wall is solid and full height with the arched TV niche 4.40 × 0.70 m (V6.3): TV 85″ centred, a long low cabinet, side shelves, hidden LED; the sofa (3.8 m) faces west with eye-to-screen 3.47 m, the dining behind it, a 1.9 m path at the sofa's north end. Column 2 stands in the glass to the courtyard (y 13.0), column 3 in its south wall (y 19.25). |
| G04 | Men's majlis | 10.56 × 4.75 | 50.16 | 46.77 | The full width on the south. Entered only from the foyer, through a 1.80 m opening with no door. High south windows; the main seating at the east end; AC hidden, not over the seats. |
| G05 | Maid bath | polygon | 3.84 | 3.03 | WC, basin and compact shower in the sloped corner; vent window in the cut wall. Door from the maid room only, 0.70 m (sliding or opening out). |
| G06 | Maid room | polygon | 8.39 | 7.28 | Behind a 100 mm partition, y 2.8–7.0 (V7.0: the kitchen's north wall moved 0.50 m south; 2.49 m clear at the bed, the municipal ≥ 6.5 m² / 2.1 m met). Door (1.00 m opening) from the laundry at its north end. Single bed along the south wall. High-sill window in the cut wall. |
| G07 | Laundry | 1.7 × 4.2 | 7.14 | 6.20 | y 2.8–7.0 (V7.0). Open entrance from the kitchen (y 7.0). Machines, utility sink, folding shelves and a drying rail on the solid west wall, 0.95 m walkway; extract fan to the roof. The maid's only route. |
| G08 | Kitchen | 4.36 × 6.0 | 26.17 | 23.99 | y 7.0–13.0 (V7.0: its north wall a non-load-bearing partition 0.5 m south of the beam line y 6.5). The heavy kitchen, isolated: door to the dining, an open entrance to the laundry, and a lockable 0.90 m service door in the east wall at its north end (y 7.2–8.1) to the east service yard (rubbish, deliveries, gas). Two parallel runs, no island: the sink run 5.4 m under the courtyard window; the cooking run 3.0 m (y 8.2–11.2) with the hob and hood at y 10.2–11.2 on the east wall, the extract straight out (no east duct); fridge and tall storage 11.2–12.9. |
| G09 | Living (normal height) · dining | 4.36 × 6.25 | 27.26 | 25.63 | One room with the living; the ceiling height changes on x 8.95. Door to the kitchen. The first floor is above it. |
| G10 | Lift (shaft placeholder) | 2.25 × 2.2 | 4.95 | 4.00 | Installed at construction (V6.3), two stops; sliding landing doors from the lobby and the gallery; the shaft size is a placeholder until a supplier's civil drawing is chosen (§4.11). |
| G11 | Entry cupboard | 0.5 × 0.9 | 0.45 | 0.20 | Shoes and coats on the family lobby, north of the lift door (V6.3: the strip in front of the lift door is lobby). |
| G12 | Family lobby + riwaq | polygon | 29.52 | 25.28 | From the family entrance (north wall) to the men's majlis wall, closed there, with the lift door reveal at its north end (V6.3). Windows onto the courtyard; the living's arched entrance and its solid TV wall on its east side. |
| G13 | Stair | 2.75 × 5.7 | 15.68 | 13.89 | Open, no door. A store under the half landing. |
| G14 | Utility room (shaft inside) | 2.75 × 2.5 | 6.88 | 5.81 | The west shaft, main electrical panel, water manifold and water heater behind one door from the riwaq. 0.9 m kept clear in front of the shaft door. |
| G15 | Hospitality kitchen | 2.75 × 2.5 | 6.88 | 5.81 | A light kitchen for coffee, tea, dates and desserts, open to the riwaq; no hob. The serving base for the men's majlis. |
| G16 | Family basins (2) | 2.75 × 1.5 | 4.13 | 3.28 | An open niche on the riwaq with a straight counter. A full-height wall to the hospitality kitchen. |
| G17 | Family WC + basin | 2.75 × 1.7 | 4.68 | 3.79 | WC and basin, no shower. Door 1.00 m opening off the basins (V6.3). |
| G18 | Serving passage (2 doors) | 2.75 × 1.4 | 3.85 | 3.03 | The only family / guest link: door 1 (0.90 m) from the riwaq, door 2 (1.05 m) from the guest passage. Never open together; both lock from the family side. |
| G19 | Guest WC | 1.5 × 1.75 | 2.63 | 2.02 | WC and hand spray. Door 0.90 m opening in the south wall (the 1.3 m wide room cannot take 1.00 m, V6.3), hidden from the passage by a 0.6 m screen wall. |
| G20 | Guest basins (trough · 3 taps) | 1.5 × 2.15 | 3.22 | 2.53 | One trough with three taps, open to the guest passage. |
| G21 | Guest passage | 1.25 × 3.9 | 4.88 | 3.79 | From serving door 2 to the foyer. |
| G22 | Foyer + entry | 2.75 × 2.6 | 7.15 | 6.00 | Double door (1.40 m, two leaves) at the north end of its west wall. A 1.80 m opening into the men's majlis at the south end of its east wall. Shoe cabinet and bisht / shemagh hooks. |
| – | Air tower (not a room) | polygon | 1.37 | ≈ 0.9 | In the tip of the cut corner, 1.0 m deep; cleaned from a roof hatch. |

- **Rooms:** 277.76 m² on axes, excluding the courtyard and the air tower.
- **Totals:** 308.31 m² on axes including the courtyard (`tools/schedule.py`), and 309.68 m² with the air tower.

### 3.2 First floor (`data/rooms_ff.csv`, `design_ff.typ`, studies `ff_family.typ` and `ff_suite.typ`)

| No. | Room | Axes (m) | Axes m² | Clear m² | Purpose · doors · rules |
|---|---|---|---|---|---|
| F01 | Landing (stair top) | 2.75 × 1.3 | 3.57 | 3.15 | The stair arrives here; since V7.0 it continues to the roof (two more flights in the same well, §4.27). No room door opens onto it. |
| F02 | Upper gallery (on the west projection) | polygon | 33.26 | 30.38 | The family corridor: beside the stair, then on the projection along the courtyard and the void (1.55 m since V7.0: 1.405 m clear, 1.235 m at the column sleeves), closed to the courtyard by six arched steel windows W1 on the edge beam's upstand (V7.1), three per column bay. Every west room door opens from it. |
| F03 | Linen cupboard | 2 × 0.7 | 1.40 | 0.95 | At the gallery's north end; a joinery box. |
| F04 | Family bath | 2.75 × 1.8 | 4.95 | 4.08 | WC on the west shaft wall, shower, basin; door from the gallery. Serves bedrooms 1 and 2, the family living and the kids' room. |
| F05 | Wardrobe niche (bedroom 2) | 1.5 × 0.6 | 0.90 | 0.51 | Beside the shaft, open to bedroom 2. |
| F06 | Bedroom 2 | 4.25 × 3.4 | 14.45 | 12.88 | Bed with bedside tables on both sides, wardrobes, a desk under the west window. Door from the gallery. |
| F07 | Bedroom 3 bath | 2.2 × 1.7 | 3.74 | 2.96 | En-suite, over the GF family WC (a wet room on a wet room). Shower, WC, basin. |
| F08 | Bedroom 3 | polygon | 16.87 | 15.02 | An entry with a wardrobe, then the room: bed on the west wall, wardrobe east, desk south. Door from the gallery. |
| F09 | Kids' room (study + gaming) | 4.7 × 3 | 14.10 | 12.49 | Two study desks and a PC desk under the north window, a gaming corner; solid door from the gallery. Can become a fourth bedroom. |
| F10 | Family living | 4.7 × 3.5 | 16.45 | 15.48 | On the courtyard edge, glazed to it by two arched steel windows W2 east of C21 from the floor to +6.60 (V7.1); open to the gallery's north end west of C21: a view, not a path. The walk to the family link passes behind and beside the sofa. |
| F11 | Family link | 1.2 × 1.2 | 1.44 | 1.10 | From the family living to bedroom 1 and to the suite door. |
| F12 | Bedroom 1 | polygon | 15.75 | 13.87 | One room, no bath; its south wall is straight on y 6.5. It uses the family bath. |
| F13 | Gym route | 1.35 × 2 | 2.70 | 2.19 | From the gallery's south end to the office and the gym (sliding doors). |
| F14 | Owner's office | 4.25 × 4.75 | 20.19 | 18.21 | Sofa and bookshelves to the north, desk with visitor chairs to the south. Windows west and south. |
| F15 | Gym | polygon (L) | 28.37 | 25.31 | An L: the long arm along the south facade (barbell and rack, kettlebells, pull-up bar, pilates mat, one cardio machine) and a short arm 1.725 × 2.0 m at the east end along the suite bedroom wall, holding only the treadmill (§4.21). Sliding door from the gym route. |
| F16 | Suite court (open to the sky) | 5.99 × 2 | 11.97 | – | Private, walled on four sides (east: the treadmill arm), in front of the clerestory windows; from the suite bedroom only. Its floor falls west to its drain. |
| F17 | Suite lobby | 1.35 × 5.4 | 7.29 | 5.98 | Entered from the family link; it opens to the bath, the dressing and the bedroom. |
| F18 | Suite bath | polygon | 10.24 | 8.84 | Freestanding tub, walk-in glass shower, double vanity. A sunken floor drains to the stack outside the east wall. |
| F19 | Suite WC (closet) | 1.1 × 1.5 | 1.65 | 1.14 | WC with shattaf at the drain stack, sliding door. |
| F20 | Suite dressing | 3.01 × 3.45 | 10.39 | 9.05 | His and hers wardrobes (sliding), shoe and bag display, make-up table. |
| F21 | Suite bedroom | polygon | 26.03 | 23.60 | King bed facing the suite court. Solid west wall to the double-height living (no window). |

- **Rooms:** 233.75 m² on axes indoors (circulation 48.27 m²), plus the suite court 11.97 m².
- **Master suite:** **55.60 m²** (lobby, bath, WC closet, dressing, bedroom).
- **Doors (V6.3):** every bedroom and bathroom door on both floors is a 1.00 m opening with a 0.90 m leaf (≥ 0.85 m clear); the suite WC closet door opens out into the bath; bedroom 3's door sits at y 15.2–16.2 (south of its entry wardrobe) and its bath door is sliding. Not reached: the guest WC (0.90 m opening) and the maid bath (0.70 m, column C31 and the cut wall).
- **Fixed elements:** stair, lift shaft, west shaft and air tower rise from the ground floor.

## 4. Design decisions and their reasons

1. **Courtyard house.**
   - A small, shaded courtyard sits at the centre, enclosed on four sides and open to the sky. The rooms the family uses most open onto it.
   - The outer walls are quiet, with small openings; light, air and view come from inside. This gives privacy from the street and the lane, protection from the hot sun and the dust, and an open family life inside its own walls.
2. **One living room, two heights.**
   - The courtyard half is double height. It continues the courtyard's vertical space and works as a chimney with high operable windows.
   - The east half (the dining) is normal height: warmer, easier to cool and light, with ducts in its ceiling. The first floor continues above it.
   - The two halves are separated only by the ceiling-height change.
3. **West service band.**
   - The family entrance, entry cupboard, future lift, stair, utility room with the shaft and the west wash block sit in one band.
   - Services rise in one place, the structure gains one stiff core, and every service is reachable without breaking a wall.
4. **West wash block and the two-door serving passage.**
   - One strip of wet rooms on one drain run: hospitality kitchen, family basins, family WC, guest WC, guest trough.
   - The family side is open to the riwaq. The guest side has **no door onto the riwaq**.
   - The only link is a passage with two doors that are never open together, both locked from the family side. The family leaves the tray, closes door 1 and calls the host, who opens door 2. An open door 2 shows only the passage and a blank wall (majaz).
   - The living's west wall is solid and full height (V6.3, the TV wall), so serving door 1 faces a blank wall; privacy rests on the two doors.
5. **Hospitality kitchen.** A light, clean kitchen for coffee, tea, dates and desserts, open to the riwaq, beside the serving passage. The east kitchen is the heavy one.
6. **Guest foyer and majaz.**
   - The double door is at one end of the foyer and the majlis opening at the other, so guests do not look straight in.
   - In a short foyer the door and the opening overlap, so the majaz is partial (open item: a curtain or a short screen).
7. **Trough basins.** One trough with three taps lets several guests wash at once before and after the meal.
8. **Men's majlis.** Full width on the south, entered only from the foyer. High south windows give light without views; the main seating is at the east end, away from the entrance; the AC is out of the seating zone.
9. **East service block and maid wing.**
   - The kitchen sits on the courtyard lines and stays isolated.
   - The laundry runs along the solid wall of the women's majlis.
   - The maid room and maid bath use the sloped corner. The maid wing is reached only kitchen → laundry → maid room → maid bath, with no outside door.
   - The maid room was ≈ 6.0 m² clear until V6.3; in V7.0 the kitchen's north wall moved 0.50 m south (§4.26) and the room is 7.28 m² clear, 2.49 m wide at the bed: the municipal minimum (≥ 6.5 m², ≥ 2.1 m) is met.
10. **Air tower and tunnel.**
    - The tower fills the tip of the cut corner (it takes no room space). It catches the north-west wind above the roof and brings it down to an underground tunnel.
    - The tunnel releases cool air through a low, closable opening in the courtyard. Every opening can be closed: open at night and early morning, closed in hot afternoons, dust and cold.
    - Studied in `studies/air_system.typ` / `docs/AIR_SYSTEM.md` (v2, tag `air-p2`): the malqaf is a *dry* natural supplement for night ventilation (screen + rated filter slot, damper closed by day, in dust and cold); a small dry sealed duct (0.6 × 0.6 clear assumed, top −1.00, route A under the women's majlis) to a chamber under the courtyard floor; the outlet a low grille in the courtyard's north wall (+0.2 … +0.8), no air opening and no water in the floor; an optional seasonal pad frame + fan in the chamber. **The house's main ventilation is a calculated system by the MEP engineer** (ERV to the closed rooms, exhausts, AC): roof plant area and risers reserved, not designed. Every size assumed; the MEP engineer compares options A / B / C before anything goes into the foundations.
11. **Lift at construction, two stops (V6.3).**
    - The lift is installed before the family moves in (ageing in place): shaft walls on both floors, a pit 1.2 m clear of the drains and the air duct, a separate electrical line, sliding landing doors from the family lobby (y 0.9–1.9) and the gallery, battery lowering on the essentials circuit.
    - Ground and first floor; the roof is reached by the stair. The shaft 2.25 × 2.2 is a placeholder until a supplier's civil drawing is chosen (open item 14).
12. **Utility room and shaft.**
    - The west shaft (≈ 1.0 × 1.2 m clear, sealed, one full-height maintenance door) sits inside a utility room, with the panel, the manifold and the water heater behind one door.
    - It serves the west wash block and the first-floor baths above or beside it.
13. **Plumbing strategy.**
    - **West:** the shaft and one drain run under the wash block, with a cleanout under the serving passage.
    - **East:** kitchen, laundry and maid bath drain straight out to the east, to a manhole in the east yard.
    - **Suite bath:** a sunken floor drains to one stack on the outside face of the east wall. The kitchen extract leaves straight through the east wall. There is **no east duct**.
    - **Rules:** wet rooms stack over wet rooms; nothing hangs in a kitchen ceiling; no drain over the master bedroom.
    - A separate plumbing study is still to do.
14. **First-floor zoning.** The family part is on the north and west, around the courtyard: children near the family bath and the family living. The L is to the south and east: owner's office → gym route → gym → suite court → master suite. The suite is private behind a lobby entered from the family link.
15. **West projection on columns** (V5.0; restored in V6.1; 1.55 m since V7.0).
    - The gallery runs on a **1.55 m projection** over the west edge of the courtyard and the double-height void (x 4.25–5.80, y 6.5–19.25), so the west rooms take the full 4.25 m band (≈ 4.0 m clear) and the gallery is 1.405 m clear (1.235 m at the column sleeves). The first-floor west wall stands directly on the ground-floor west wall, 0.785 m from the M line.
    - It is carried by an **edge beam on x 5.80** (spans 6.5 m and 6.25 m) on **three columns**, each in an existing wall or glass line, none free-standing in a room: in the south wall of the women's majlis (y 6.5), a pier between the courtyard glass and the living (y 13.0), in the south wall of the living (y 19.25). On the ground floor it reads as a colonnade along the courtyard edge, with a normal-height ceiling under the projection.
    - The courtyard sky and the double-height void are **3.15 m** wide on axes (≈ 2.925 m clear).
    - *History:* V5.1 replaced it with a split projection (0.675 m inward without columns, 0.675 m outward beyond the ground-floor west wall, the west wall on cantilever beams). V6.1 reverted that, because:
      - a wall on cantilever beams along ≈ 15 m costs more and is less direct structurally than walls stacked over walls;
      - the outward projection, 0.11 m from the M line, needed municipal approval.
    - The study stays on branch `v5-split-projection` and in tag `v6.0`. Page 5 of `output/design_ff.pdf` compares the two.
16. **Kids' room.** Study and gaming in one room on the north side, away from the bedrooms. It can become a fourth bedroom.
17. **Family living on the courtyard.** A view, not a path: nobody walks between the seats and the courtyard.
18. **Bedrooms.**
    - Bedroom 1 is one room without a bath.
    - Bedroom 2 has a wardrobe niche beside the shaft.
    - Bedroom 3 has its own bath, stacked on the ground-floor family WC.
    - One family bath by the west shaft serves the rest.
    - Every bedroom door opens from the gallery.
19. **Master suite.**
    - A lobby leads to the bath, the dressing and the bedroom. It is a bent entry: the bed is not seen from the suite door.
    - The luxury bath has a tub, a walk-in shower, two basins and a WC closet. The walk-in dressing is for two. The bedroom faces the suite court.
    - It follows the owner's programme.
20. **Owner's office.** The south-west corner, a quiet room near the stair, door from the gym route.
21. **L-shaped gym** (V6.2, the owner's choice).
    - **Long arm** along the south facade (x 4.25–13.311, y 21.25–24): barbell and rack, kettlebells, pull-up bar, pilates mat, one cardio machine. A 1.0 m walkway runs along its north wall from the sliding door to the arm.
    - **Short arm** at the east end, turning north along the suite bedroom wall: 1.725 × 2.0 m on axes (x 11.586–13.311, y 19.25–21.25). It holds **only the treadmill** (0.9 × 2.0 m, facing north), with 0.3 m clear on each side, 0.1 m off the bedroom wall, and the 0.5 m behind it kept free in the long arm. Gym 28.37 m² in all.
    - **Acoustic separation, mandatory:**
      - a double wall between the arm and the suite bedroom (target ≈ 55 dB airborne);
      - a floating floor or dense rubber under the arm;
      - anti-vibration pads under the treadmill;
      - the treadmill never touches the wall.
    - **Change in the suite court:** it becomes 5.99 × 2.0 m = **11.97 m²** (was 15.42).
22a. **Decisions of 3D phase 3** (24 Oct 2026, the owner):
    - **X8, two-storey colonnade:** the three colonnade columns on x 5.6 continue to the roof inside the gallery railing line; the roof over the gallery strip rests on them through a roof edge beam (R11), no 1.35 m roof cantilever. Slender round columns (≈ Ø0.30, assumed).
    - **Drop beams and gypsum ceilings:** beam B1 (women's majlis / kids' wall) is a drop beam hidden by a gypsum ceiling (≈ +3.05). General rule: drop beams in finished rooms are hidden by gypsum ceilings, which also carry the hidden AC and lighting.
    - **Projection edge beam:** option (b) upturned (the railing base) is the owner's preference; (a) a drop beam is acceptable if the engineer decides.
    - **Kitchen service door:** in the kitchen's east wall at its north end near the laundry (y 6.7–7.6, 0.90 m, lockable), to the east service yard; the cooking counter starts 0.1 m south of it, the east-wall stack moves between the door and the kitchen window (MEP).
    - **X3 (resolved V6.3):** C33 stays; the suite bath east window is 0.55 m, y 9.50–10.05: its frame clears the assumed 0.25 × 0.60 column (y 10.15–10.75) by 0.05 m, and any smaller column by more.
22. **Suite court and clerestory light.**
    - **The court:** private, open to the sky, enclosed on four sides (since V6.2 its east side is the treadmill arm). Its floor falls west to its drain, away from the arm. The suite bedroom's window and its sliding door to the court are unchanged; the door (x 9.3–10.7) still opens onto the court, 0.79 m from the arm's wall.
    - **The windows:** the court sits in front of the double-height living's two clerestory windows (1.0 × 1.0 m, sill +5.00). The arm stands ≈ 2.99 m east of them, so they still face open sky.
    - **Light:** the gym's roof edge ends in a **railing, not a parapet**. With the railing, ≈ 81 % of the winter noon sun reaches the windows and the sky shows on 100 % of them, as in V6.1. With a 1.10 m parapet the figures would be 0 % and 42 %. The noon sun stands south-south-west of the plan frame, so the arm's shadow falls to the north-east, away from the windows.
    - **Privacy:** the window sill stays above eye level from the court floor, or the glass is obscured.

23. **V6.3 quick fixes from the design review** (30 Oct 2026, the owner; `docs/review/design_review.typ`, tag `review-1`):
    - **TV wall** (review G-01): the living's west wall solid and full height, the 1.40 m entrance arch (head +2.60) at its north end, the arched TV niche 4.40 × 0.70 m (crown +3.10) between a 0.25 m pier and the south wall; sofa 3.8 m facing west, eye-to-screen 3.47 m, 1.9 m path at the sofa's north end; no arches between the colonnade columns (the 3D's arches variant removed).
    - **Lift at construction** (A-01): §4.11; the entry cupboard 0.5 × 0.9, the lift door reveal in the lobby.
    - **Door widths** (F-02): see the note under §3.2.
    - **X3** (T-02): item 22a.
    - **Slabs in the 3D** (review §7): the first-floor and roof bays carry the study's thicknesses (0.30 ribbed over the kitchen, dining, men's majlis, suite and office; 0.22 flat over the void; 0.20 elsewhere), assumed; clear heights before finishes +3.32 under the 0.20 slabs, +3.22 under the 0.30 bays, +3.05 under B5, +3.10 under B4, +3.20 under B1; the stair headroom stays 2.14 m (under B16).
    - **Two-children test** (`tools/bedroom_test.py`): see §4.24.
    - **0.30 m south** (S-03): §1 and §2; provisional until the survey.
24. **Two-children bedroom test (V6.3, no layout change).** `tools/bedroom_test.py` searches wall-hugging layouts for two single beds 0.9 × 2.0, two wardrobes 0.6 × 1.2 and two desks 0.6 × 1.2 with 0.75 m clearances (a free long side per bed, a free front per wardrobe and desk, the door swing free, a 0.75 m path from the door to each bed). Result (`python tools/bedroom_test.py`, 3000 random layouts plus the hand layouts in the script): **bedroom 3** (15.02 m² clear, 4.03 × 2.95 plus the 1.85 × 1.7 entry arm) takes the full set: both beds along the north and south walls, the wardrobes on the east wall and the south wall, one desk across the end of the entry arm and one against the bath wall, 8.54 m² of floor free, every clearance met. **Bedroom 2** (12.88 m² clear, 4.03 × 3.2) takes two beds, two wardrobes and **one** desk (7.12 m² free, every clearance met); a second desk has no wall left (0.45 m between the first desk and the door swing), so two children share one desk, or a 1.2 m desk gives way to two 0.9 m desks (not tested). R-01 (two beds, two wardrobes, a desk) is met by both rooms; the brief's two-desk test by bedroom 3 only.
25. **Courtyard enclosure, option A** (V7.0; design review Y-01, critical; `studies/courtyard_enclosure.typ`, `data/decisions.csv`).
    - The courtyard stays open to the sky; the conditioned house is closed round it on one air / thermal line with black steel divided-lite windows (the design language): **W1** on the gallery edge, on the upstand of the edge beam B3 (sill +3.82, guarding transom +4.70, head +6.75, four inward casements); **W2** on the family living's courtyard edge from the floor to +6.75 (two casements); **W3** over the living's courtyard glass at y 13.0 from the ground-floor glass head to +6.75 (two motorised tilt lites), so the courtyard side of the living reads as one steel wall ±0.00 … +6.75. The heads meet the roof edge beams' soffit all round.
    - To keep the gallery ≥ 1.20 m clear the projection widened 0.20 m to 1.55 m: B3, the roof edge beam R11 and the colonnade columns C21–C23 moved to x 5.80 (spans and X8 unchanged); the sky opening and the void are 3.15 m on axes. Option B (columns outside the window line) was studied and set aside.
    - Knock-ons: the malqaf grille serves only the courtyard unless the casements are open (open item 17); the pergola to reconsider (open item 18); the AC / ERV loads include the three glazed edges (≈ 60 m² of glass).
26. **Maid room to the municipal minimum** (V7.0; review G-04).
    - The kitchen's north wall moved 0.50 m south from y 6.5 to y 7.0 as one straight non-load-bearing block partition on a thickened slab / ground beam (it crosses the malqaf duct on a ground beam). The structural grid is untouched: beam B6 on the y 6.5 line became a drop beam inside the laundry / maid room ceiling (hidden by the gypsum ceiling), carrying the first-floor wall above; W5 dropped from the RC-wall proposal (X14).
    - Maid room 8.39 m² on axes / 7.28 m² clear, 2.49 m clear at the bed (y 6.0–7.0); laundry 1.70 × 4.2 (6.2 m² clear, 0.95 m walkway); kitchen 4.361 × 6.0 (23.99 m² clear) with two parallel runs; the service door at y 7.2–8.1, the cooking counter from y 8.2 (3.0 m), the hood at y 10.2–11.2; the malqaf grille stays at y 7.7–8.7.
27. **Roof access by the main stair; the stair room** (V7.0; review F-07; `studies/roof.typ`).
    - The roof is for maintenance and equipment only. The main stair continues from the first floor to the roof in the same well with the same geometry (flights 3 and 4, 11 risers each, the upper half landing at +5.40); the roof opening repeats the first-floor one with trimmers R16 / R17 / R18 (as B16–B18); headroom 2.22 m at tread 6 of flight 3.
    - A stair room on the well's walls (2.525 × 5.50 inside, 2.20 m clear, its own light slab at +9.50 / +9.62, edge +9.70) with a 0.90 door to the roof on a 0.15 m kerb (head +9.45), a window east and a louvre. The first floor loses nothing; the well's east edge stays open to the gallery with its railing and flight 4 gets a balustrade.
    - The lift stops at the first floor: 3.40 m headroom to the roof slab underside; the supplier's headroom must be ≤ 3.40 m (or ≤ 3.70 m with a 0.30 m raised shaft head hidden behind the cornice coping): open item 14.
28. **Roofline: flat roof, main cornice, set-back attic** (V7.0; `studies/roof.typ`, `DESIGN_LANGUAGE.md`).
    - Flat roof, no pitched or tiled roof anywhere. A honey-stone **main cornice** 0.45 m high projecting 0.30 m at +6.90 … +7.35 on the facade edge all round; a thin stone band 0.12 m between the floors at +3.40; honey stone at the plinth and the corners (quoins).
    - On the **north block** (y 0–19.25) a 0.30 m coped upstand on the cornice (+7.65) and an **attic screen** (200 mm block, 1.8 m, coping +9.10) set back 1.0 m from the facade face, its south wall on the y 19.25 line; the **south wing** keeps the cornice and a plain parapet to +8.40, so the roofline steps. The stair room stands inside the attic in plan but 0.6 m above its coping and, on the west, on the facade line: hidden from the north boundary and up to ≈ 15 m from the facade (across the street); the owner accepted this.
    - Sight lines: from the north boundary (3.8 m) the attic hides behind the cornice and the stair room behind the attic; the AC units and the tank are lower than the attic and hidden from any distance; the malqaf head (+9.80) is the one element above the attic, by design. The attic never cuts the courtyard's sky or sun.
    - Roof zones reserved (not designed): plant for the AC units and the ERV (14.6 m²) behind the cut / east attic, a tank zone (3.3 m²) between beams R10 and R3, PV 24.5 m² on the south wing south of y 22.0 (clear of the clerestories' winter sun) and 20.5 m² on the north block later, the 1.0 m strip in front of the attic with its own outlets, 11 roof outlets with 1.5 % falls, 0.9 m walkways, black steel bar guards 1.10 m round the courtyard sky hole and the suite court's open edges. Loads for the engineer in `STRUCTURE_STUDY.md` (X16, X17).
30. **Arched enclosure windows and the courtyard arcade** (V7.1, the owner; `studies/courtyard_enclosure.typ`, `data/decisions.csv`).
    - Every courtyard enclosure window gets a semicircular (Roman) head in black steel with divided lites, the arched head fixed, the operable lites below, the sill and the guarding transom (+4.70) as before. **W1:** six arched windows 1.60 m wide on the gallery edge, three per column bay, sill +3.82, springing +5.80, crown +6.60 (0.15 m of wall below the roof edge beams' soffit +6.75); in the courtyard bay they stand over the three arcade bays. **W2:** two arched windows 1.30 m wide east of C21, floor to the crown +6.60 (springing +5.95); the strip x 4.25–5.80 of that edge is the family living's opening to the gallery's north end. **W3:** one arched window 2.80 m wide over the living's courtyard glass (the space between C22's sleeve and the east wall), +3.32 to the crown +6.60 (springing +5.20), the two motorised tilt lites in its lower part.
    - **The arcade:** in the courtyard bay only, two slender honey-stone columns Ø0.25 on the colonnade line x 5.80 at y 8.667 and 10.833 (three equal bays of 2.167 m) with three semicircular arches under the projection's soffit (+3.27): spans 1.84 / 1.92 / 1.84 m, springing +2.35 / +2.31 / +2.35. Decorative unless the engineer uses the columns as supports of B3 (`STRUCTURE_STUDY.md` X18); the living bay keeps no arches. The columns stand 0.78 m clear of the sunken seating, 1.36 m clear of the riwaq door's swing line, 1.33 m from the riwaq glass face, away from the malqaf outlet (east wall). The courtyard reads as a two-tier classical arcade.
29. **Design language** (V7.0, `DESIGN_LANGUAGE.md`): modern classic with a Taif spirit: cream plaster, marble inside and matte honey stone in the courtyard, thin cornices, honey stone at the base and the corners, matte black metal with a few brass touches, walnut, Roman arches, black steel divided-lite windows, round honey-stone columns, a black bar stair railing, little mashrabiya, mostly hidden lighting; the roofline above.

## 5. Construction notes

The construction and detail notes (structure, the edge beam and columns, the gym arm and its acoustic separation, drainage, joinery, doors) are in **`docs/DETAILS.md`**.

## 6. Changelog

| Version | Date | What changed |
|---|---|---|
| V1–V2 (C1) | before 11 Oct 2026 | Early concept: 6 × 5 m courtyard, west service band, men's majlis 10 × 5.5 m (`archive/rooms_C1.csv`). |
| V3.0 | 11 Oct 2026 | Compact courtyard house on site option Z3; services in a utility room; one living room with two heights. |
| V3.1 | 15 Oct 2026 | Site option Z4; one west wash block with the two-door serving passage; the east service block; `pts` column for non-rectangular rooms. |
| V3.2 | 16 Oct 2026 | Slope to y 6.0 and width 13.311 m; building 0.26 m east (west face 0.785 m from the M line); middle band 4.50 m clear; living low partition. |
| V3.3 | 16 Oct 2026 | Building 0.5 m longer south; future lift placeholder; hospitality kitchen; serving passage 1.4 m; trough basins; foyer double door and majlis opening. |
| V3.4 | 16 Oct 2026 | Smaller air tower (1.0 m deep); the freed space to the maid wing. |
| V4.0 | 16 Oct 2026 | Ground floor final: maid bath 1.8 m, maid room ≈ 6.0 m² clear accepted; repo cleaned. |
| V4.1 | 17 Oct 2026 | First-floor baseline: zoning (suite east, children west, family living north) and the first room layout. |
| V5.0 | 20 Oct 2026 | First floor designed room by room; ground floor coordinated (east duct removed, three columns for a 1.35 m inward projection); first presentation set. |
| V5.1 | 24 Oct 2026 | Split west projection accepted (M-line approval pending, no columns); L-shaped gym rejected; treadmill at the gym's west end. |
| V6.0 | 24 Oct 2026 | Clean release: everything labelled V6.0; A3 presentation with 10 sheets (decisions log, open items, block details); first-floor DXF; shared sections module; master document and open-items list; extended checks. No design change. |
| V6.1 | 24 Oct 2026 | Split projection reverted to the V5.0 columns solution: the full 1.35 m inward projection on an edge beam and three columns at x 5.6, the first-floor west wall on the ground-floor wall; family bath, wardrobe niche, gym and suite court back to their V5.0 sizes; the rectangular gym with the treadmill at its west end kept. |
| V6.2 | 24 Oct 2026 | L-shaped gym with the treadmill arm at the east end (owner's choice), along the suite bedroom wall, with acoustic separation (double wall ≈ 55 dB, floating floor, anti-vibration pads); suite court 11.97 m². The V5.1 rectangular gym had kept the treadmill at the west end because the L took area from the suite court and put treadmill noise next to the master bedroom. |
| 3D phases 1–2 | 24 Oct 2026 | 3D model generated from the CSVs (`3d/`): slabs, outer and interior walls, voids, open edges, viewer and checks; tag `3d-p2`. No design change. |
| Structural study | 24 Oct 2026 | Preliminary structural study `studies/structure.typ` / `docs/STRUCTURE_STUDY.md` (tags `struct-p1`, `struct-p1b`): column grid, beams, slabs, sections, the stair, options and 15 items for the engineer; every size assumed. No design change. |
| Air system study | 24 Oct 2026 | `studies/air_system.typ` / `docs/AIR_SYSTEM.md` (tag `air-p1`): malqaf head, walk-in tunnel with a water channel, outlet chamber in the courtyard floor (all assumed). Withdrawn by `air-p2`. |
| Air system v2 | 24 Oct 2026 | Tag `air-p2`: dry malqaf for night ventilation (filter slot, damper), small dry sealed duct, outlet grille in the courtyard wall, optional seasonal pad frame + fan in the outlet chamber; the water channel and the walk-in tunnel removed; the main ventilation (ERV, exhausts, AC) stated as the MEP engineer's calculated system with a roof plant area and risers reserved; options A / B / C for the MEP engineer; the structural reservation and the 3D shrunk to the duct and the chamber. No design change. |
| 3D character | 28 Oct 2026 | `3d/character.yaml` (tags `3d-char1`, `3d-char2`): a style study (materials, plinth, deep reveals, mashrabiya, stone colonnade, timber soffit, parapet / glass railing, pergola, sunken seating, views); the malqaf outlet moved to the kitchen wall (owner, air study v2.1). No design change beyond the air outlet. |
| Design review | 30 Oct 2026 | `docs/REQUIREMENTS.md` (R-01 … R-35) and `docs/review/design_review.typ` → `output/Design_Review_V6.pdf` (tag `review-1`): 55 findings, 3 critical. No design change. |
| V7.1 | 31 Oct 2026 | Arched courtyard enclosure windows (semicircular heads in black steel: W1 six windows 1.60 m, W2 two windows 1.30 m, W3 one window 2.80 m, crowns +6.60) and the three-arch courtyard arcade (two Ø0.25 stone columns between C21 and C22, decorative); the 3D, the presentation, the DXFs and the review status regenerated. |
| V7.0 | 31 Oct 2026 | Courtyard enclosure (option A: the gallery, family living and living edges glazed with black steel divided-lite windows W1–W3, the projection 1.55 m with the colonnade at x 5.80, the sky 3.15 m), maid room to the municipal minimum (the kitchen's north wall to y 7.0: 7.28 m² clear), roof access with the main stair (flights 3 / 4, the stair room), the set-back attic and the stone main cornice (the stepped roofline), the design language; the roof study, the enclosure study and the review status; the 3D with the enclosure, the stair to the roof, the roofline and the design-language colours; the presentation with the roof plan and the elevations (12 sheets); a roof DXF. |
| V6.3 | 30 Oct 2026 | Quick fixes from the design review (§4.23): the living's west wall solid with the TV arch and the entrance arch, no arches between the colonnade columns; the lift installed at construction (sliding landing doors, the entry cupboard 0.5 × 0.9); bedroom and bathroom doors 1.00 m openings (0.90 leaves, ≥ 0.85 clear) except the guest WC (0.90) and the maid bath (0.70); the suite bath east window 0.55 m at y 9.50–10.05 (X3 resolved); the 3D with the study's slab thicknesses; the house 0.30 m further south (provisional, lane gap 0.20 m); the two-children bedroom test. |
| 3D phase 3 | 24 Oct 2026 | Doors and windows, the stair, the colonnade – gallery – living zone, railings, finished / structural levels, plan views, eye-level views, sun; tag `3d-p3`. Owner decisions (§4 item 22a): X8 colonnade to the roof, B1 hidden by a gypsum ceiling, the projection edge beam upturned, the kitchen service door (east wall, north end; the cooking counter starts at y 7.7), X3 window 0.60 m. |

Earlier documents (the ground-floor V4 description, the first-floor brief, the decisions log, the construction notes and the split-projection study) are in `archive/docs/`. Every version is a git tag (`v3.1` … `v7.1`); the work between V6.3 and V7.0 is on the branch `work` (kept for the next round). The construction notes are in `docs/DETAILS.md`.

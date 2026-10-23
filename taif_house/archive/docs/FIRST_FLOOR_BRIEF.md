# Taif / Palm House · First floor brief · V5.1

16 Oct 2026 (programme, zoning and first room layout 17 Oct 2026; V5.0 design 18–20 Oct 2026; **V5.1 24 Oct 2026**) · the first floor on top of the ground floor (`docs/GROUND_FLOOR_V4.md`).

## V5.1 · split west projection, rectangular gym (24 Oct 2026 · git tag `v5.1`)

V5.1 = V5.0 with two owner decisions on two study branches:
- **Split projection, accepted** (branch `v5-split-projection`, record in `docs/VARIANT_SP.md`):
  - the V5.0 1.35 m projection becomes 0.675 m inward over the courtyard and the double-height void (x 4.25–4.925, a plain cantilever, **no columns**) plus 0.675 m outward beyond the ground-floor west wall (x 0 → −0.675, south of y 10.4);
  - the whole west band (bedrooms 2 and 3, bedroom 3 bath, wardrobe niche, gallery, owner's office, gym route) moves 0.675 m west; stair, lift, landing and west shaft stay, so the west face steps out at y 10.4.
- **L-shaped gym, rejected** (branch `v5-gym-L`, kept for reference): it took 3.45 m² from the suite court and put treadmill noise against the master bedroom. The gym stays a rectangle along the south facade, not touching the suite bedroom; the treadmill moves to its west end.

| Item | V5.0 | V5.1 |
|---|---|---|
| Courtyard sky opening, axes / ≈ clear | 3.35 / 3.15 m | **4.025 / 3.825 m** |
| Double-height void width, axes | 3.35 m | **4.025 m** |
| West rooms, axes / ≈ clear | 4.25 / 4.025 m | 4.25 / 4.025 m |
| Gallery, axes / ≈ clear | 1.35 / 1.225 m | 1.35 / 1.225 m |
| Columns in the courtyard / living | 3 on x 5.6 | none |
| First-floor west face → M line | 0.785 m | **0.11 m** |
| Family bath | 2.75 × 1.8 = 4.95 m² | **2.075 × 1.8 = 3.74 m²** |
| Wardrobe niche (bedroom 2) | 1.5 m, 0.90 m² | 2.175 m, 1.31 m² |
| Gym | 9.06 × 2.75 = 24.92 m² | 9.74 × 2.75 = 26.77 m² |
| Suite court (open to the sky) | 7.71 × 2.0 = 15.42 m² | 8.39 × 2.0 = 16.77 m² |
| Circulation | 45.72 m² | 43.90 m² |

**Gym layout (V5.1, `studies/ff_suite.typ`):**
- *Treadmill* (0.9 × 2.0 m) at the gym's *west end*, away from the master suite, with **0.5 m clear behind** (to the office wall) **and on each side**, on a dense rubber floor with anti-vibration pads. It runs along the gym's **length** (east–west, the user facing east), not its depth: along the depth it would take 2.5 m of the 2.525 m clear depth and block the only way from the door (also at the west end) to the rest of the gym.
- Along the south wall to the east: barbell + rack, kettlebells, pull-up bar (wall), pilates mat, one cardio machine (bike), an *optional bench at the east end*.
- A 1.0 m clear walkway along the north wall from the door to the east end; the door landing is free (checked).

**Engineer:** the first-floor west wall on cantilever beams (beam depth, wall load, deflection); confirm that the 0.675 m inward cantilever needs no columns.

**Top open item, before construction drawings:** municipality / engineering office to confirm that an upper-floor projection 0.11 m from the M line is allowed. If not, go back to the V5.0 solution (full 1.35 m inward projection on three columns at x 5.6, tag `v5.0`).

*The V5.0 section below is kept as the record of V5.0; its west projection, family bath, gym and suite court sizes are superseded by the table above.*

## V5.0 · the first floor as designed (20 Oct 2026 · git tag `v5.0`)

Drawings: `output/design_ff.pdf` (whole floor, schedule, light check), `output/ff_family.pdf` (part 1, family part), `output/ff_suite.pdf` (part 2, the L). Room list: `data/rooms_ff.csv` (checked against both studies). Construction notes: `docs/DETAILS.md`.

| Room | Axes (m) | m² |
|---|---|---|
| Kids' room (study + gaming) | 4.7 × 3.0 | 14.10 |
| Family living (courtyard edge) | 4.7 × 3.5 | 16.45 |
| Bedroom 1 (no bath) | polygon | 15.75 |
| Family bath | 2.75 × 1.8 | 4.95 |
| Bedroom 2 (+ wardrobe niche 0.9) | 4.25 × 3.4 | 14.45 |
| Bedroom 3 + own bath | 4.25 × 4.85 (L) + 2.2 × 1.7 | 16.87 + 3.74 |
| Owner's office | 4.25 × 4.75 | 20.19 |
| Gym | 9.06 × 2.75 | 24.92 |
| Suite court (open to the sky) | 7.71 × 2.0 | 15.42 |
| Master suite: lobby · bath + WC closet · dressing · bedroom | 4.36 × 12.75 | 7.29 · 10.24 + 1.65 · 10.39 · 26.03 = 55.60 |
| Circulation (landing, gallery on the projection, family link, gym route, suite lobby) | | 45.72 |

**Decisions:**
- *West projection* 1.35 m (x 4.25–5.6, y 6.5–19.25) carrying the gallery (≈ 1.23 m clear); west rooms 4.25 m wide; courtyard sky and void 3.35 m; edge beam on three columns in existing wall / glass lines, or a plain cantilever (engineer).
- *Family living* is a view, not a path: the walk to the family link passes behind and beside the sofa.
- *Bedroom 1* one room, no bath, south wall straight on y 6.5. *Bedroom 3* keeps its own bath (over the GF family WC). One *family bath* by the west shaft for the rest.
- *The L:* owner's office (west), gym (one straight bar), suite court (walled, open to the sky, railing not parapet on the gym roof edge), master suite entered from the family link.
- *Suite:* luxury bath (freestanding tub + walk-in glass shower + two basins + WC in its own closet), luxury walk-in dressing (his 3.25 m, hers 2.1 m, shoes and bags, make-up), doors at the north ends of their walls.
- *East duct removed.* No drain over the master bedroom or in a kitchen ceiling (sunken bath floors).

**Open items:** engineer (projection, gym loads, y 3.0 partition), MEP (east-wall stack, hood south of y ≈ 7.5), clerestory sill vs the court floor, daylight check of the narrower courtyard, bedroom 1 ≈ 17 m from the family bath, bedrooms' 10 cm partition idea (DETAILS.md).

*The sections below are the history of the brief (V4.1 and earlier) and keep the names and sizes of their time.*

Working files:
- `design_ff.typ` + `data/rooms_ff.csv` (whole floor), `studies/ff_family.typ` + `studies/ff_suite.typ` (room design), same framework and same CSV coordinates as the ground floor;
- output: `output/design_ff.pdf`, `output/ff_family.pdf`, `output/ff_suite.pdf`.

The file already draws everything below as fixed elements.

Coordinates: **CSV frame** (the ground floor's room coordinates). Site frame = CSV + (0.91, 3.525). Units: metres, y southwards.

## 1. Outline and limits

- **Outline:** the first floor stays inside the ground-floor outline (wall centre lines): (0, 0) → (10.051, 0) → (13.311, 6.0) → (13.311, 24.0) → (0, 24.0).
- **Envelope:** the ground floor is already **0.05 m** from the envelope at the north / lane side, so no first-floor projection is possible there (no cantilever beyond the ground-floor outer faces on the north, north-east or east). Setbacks for upper floors to be confirmed with the municipality.
- **Storey height assumption:** **3.6 m** floor to floor (the stair is sized for it). The engineer confirms it.

## 2. No floor here (voids)

| Void | CSV outline | Site frame | Why |
|---|---|---|---|
| Courtyard | x 4.25–8.95, y 6.5–13.0 | x 5.16–9.86, y 10.025–16.525 | Open to the sky; the house's cool heart and air exhaust |
| Double-height living | x 4.25–8.95, y 13.0–19.25 | x 5.16–9.86, y 16.525–22.775 | Stack-ventilation chimney with high operable windows; no slab over it |

First-floor rooms can look into both voids. Windows facing the courtyard must respect the privacy of the courtyard and the women's majlis.

## 3. Fixed vertical elements

| Element | CSV outline | First-floor rule |
|---|---|---|
| Stair | x 0–2.75, y 2.2–7.9 (2.75 × 5.7) | Arrives on the first floor; slab opening to suit; headroom ≥ ≈ 2.1 m at the opening; it is also the only route to the roof |
| Future lift shaft | x 0–2.25, y 0–2.2 (≈ 2.0 × 2.0 clear) | Shaft walls on both floors now; **two stops only** (ground + first); first-floor roof slab over the shaft designed to open later; the lift door at the first floor onto a landing / corridor |
| West service shaft | x 0–1.5, y 9.2–10.4 | Continues up; first-floor bathrooms **over or beside it** |
| East duct (≈ 0.6 × 0.6) | x 12.711–13.311, y 6.5–7.1 | Continues up; vent stack, a first-floor bathroom above the east side, kitchen extract to the roof |
| Air tower | polygon (8.95, 0), (10.051, 0), (10.594, 1.0), (8.95, 1.0) | Rises through the first floor to its head above the roof; no room over it; roof hatch for cleaning |

## 4. Wet stacks

First-floor bathrooms go in one of two places:
- **West:** over or beside the west shaft, i.e. over the utility room and the north part of the west wash block (x 0–2.75, y 7.9–17.5).
- **East:** beside the east duct, i.e. over the kitchen's north-east corner or the maid wing (x 8.95–13.311, y 1.0–7.1).

Elsewhere they would need new drop pipes through the ground-floor rooms. Avoid that.

## 5. Walls that can carry first-floor walls

The straight ground-floor lines (CSV):
- **x = 0** (west wall, M side) · **x = 2.75** (west band / riwaq, full length) · **x = 4.25** (riwaq / middle, y 0–19.25) · **x = 8.95** (middle / east, y 0–19.25) · **x = 13.311** (east wall, y 6.0–24.0) and the cut wall (y 0–6.0);
- **y = 0** (north wall) · **y = 6.5** (women's majlis / courtyard; east band) · **y = 13.0** (courtyard / living; kitchen / dining) · **y = 19.25** (living / men's majlis) · **y = 24.0** (south wall);
- inside the west band: y 2.2, 7.9, 10.4, 12.9, 14.4, 16.1, 17.5.

The middle band spans 4.70 m on axes with no wall inside, so first-floor walls over the women's majlis need beams or must sit on x 4.25 / x 8.95. The structural grid is set by the engineer.

## 6. Where first-floor rooms can sit

| Zone (ground floor below) | CSV outline | First floor |
|---|---|---|
| West band: lift, stair, utility, west wash block | x 0–2.75, y 0–24.0 | Rooms and bathrooms; stair and lift landings; wet rooms over the north part |
| Riwaq | x 2.75–4.25, y 0–19.25 | Corridor / gallery along the voids, or room edges |
| Women's majlis | x 4.25–8.95, y 0–6.5 | Rooms (north light; look onto the courtyard void) |
| East band: maid wing, kitchen, dining | x 8.95–13.311, y 1.0–19.25 (minus the air tower) | Rooms; a bathroom by the east duct |
| Men's majlis | x 2.75–13.311, y 19.25–24.0 | **Roof only (proposed)**: keeps the south light and possible clerestory windows of the double-height living; a roof terrace is possible. To decide |
| Courtyard and double-height living | see §2 | **No floor** |

## 7. Programme (owner, 17 Oct 2026 · approximate areas on axes)

**Private (owner and wife only):**
- **Master suite lobby, 3–4 m²:** the bed is not seen when the suite door opens. It leads to the bedroom, dressing and bathroom.
- **Bedroom, 20–25 m²:** one main quiet view (courtyard or palms), a small sitting corner.
- **Dressing, 8–10 m²:** storage for two, a make-up table with good light, a full mirror, luggage.
- **Bathroom, 9–12 m²:** two basins, a walk-in shower, the WC in its own compartment with a door.
- **Lobby access:** the bathroom and the dressing each open from the suite lobby, so one can shower or dress while the other sleeps.
- **Private terrace:** reached from the suite only, screened from view.

**Family:**
- Bedroom 1 with its own bathroom (14–16 + 4–5 m²).
- Bedrooms 2 and 3 (≈ 14 m² each), sharing one bathroom (5–6 m²).
- Small family living room, 18–25 m².
- **Gym for the whole family, 15–20 m²:** its door from the family corridor (not from the suite); proposed over the men's majlis roof.
- **Upper riwaq / gallery along the voids:** the visual link to the double-height living is from here, not from the master bed.

**Semi-public (visitors sometimes):**
- Office, 12–15 m², at the top of the stair, so visitors reach it without passing bedrooms or the suite.
- Small visitors' WC, 2–3 m², near the office.

No laundry upstairs.

**Programme total ≈ 153.5 m²** (mid values) + landing / gallery + private terrace.

## 8. Rules

1. **Plumbing (corrected 17 Oct 2026):** bathrooms need not touch a shaft; the west shaft and the east duct are coordination points.
   - Every bathroom connects to one of them with a short, sloped drain run; state its length and route (floor build-up, sunken slab or a lowered ceiling below).
   - No drain runs over the master bedroom, or in the ground-floor kitchen ceiling over the hood zone, without a note.
   - Keep wet rooms stacked where possible.
   - In practice the wet rooms gather in the west band (CSV y ≈ 7.9–17.4, over the ground-floor wet strip) and beside the east duct (CSV 12.711–13.311, 6.5–7.1).
   - (First wording, 17 Oct: every bathroom and WC over or beside the shaft or the duct.)
2. **Open roof:** keep part of the men's majlis roof open next to the double-height living, so south light can still reach the living room (clerestory). Shown as "Open roof" on each option (≈ 1.5 m deep in front of the living; deeper is better for light).
3. **Gym = flexible zone ("gym or open roof"):** it must not drive the layout. If it harms the layout, the zone stays open roof and the gym is deferred. A gym on the roof later would be a third level reached by the stair only (the lift serves ground + first): open item. The gym, and any room over the men's majlis, needs the engineer's load and vibration check (noted, not solved).
4. **Privacy gradient:** stair landing → office and visitors' WC → family zone → master suite (most private, furthest from the stair).
5. **Fixed elements and walls:**
   - fixed elements stay exactly as drawn;
   - first-floor walls sit on ground-floor wall lines where possible (straight walls, square corners);
   - no ground-floor wall is treated as load-bearing until the owner and engineer confirm it.
6. **No final room shapes or doors** at the zoning stage.

## 9. Zoning options (17 Oct 2026 · `design_ff.typ`, zones in `data/zones_ff.csv`)

**Available first-floor area: 225.6 m² on axes.** That is the outline (309.68) minus the courtyard (30.55), the double-height void (29.38), the stair (15.68), the lift (4.95), the shafts (1.8 + 0.36) and the air tower (1.37). The programme (≈ 153.5 m²) plus a landing / gallery (≈ 30 m²), a terrace and the open roof part fills it almost exactly; there is very little spare.

**Common to both options** (forced by the plumbing rule):
- bedroom 1 + bath over the maid wing (north of the east duct) and the master suite over the kitchen (south of the duct): the two bathrooms back to back at the duct;
- visitors' WC and the shared bath for bedrooms 2 + 3 at the west shaft;
- the office just south of them in the west band (≈ 2.55 m clear wide);
- the upper gallery over the riwaq along both voids.

| | Option A · bedrooms north, family living + gym south-west | Option B · family living north, bedrooms south-west, gym south-east |
|---|---|---|
| Master suite | over kitchen + dining, ≈ 55 m², terrace ≈ 21 m² on the men's majlis roof east (palms) | over kitchen + north of dining, ≈ 43 m², terrace ≈ 12 m² over the dining |
| Bedrooms 2 + 3 | over the women's majlis (≈ 31 m², north light, courtyard) | over the men's majlis west + middle (≈ 20 + 15 m²) |
| Family living | over the foyer / men's majlis west (≈ 20 m²) | over the women's majlis (≈ 31 m², the family hub by the stair, onto the courtyard) |
| Gym | over the men's majlis middle (≈ 15 m²) | over the men's majlis east (≈ 21 m², palms) |
| Open roof by the living | ≈ 7 m² (1.5 m deep) | ≈ 7 m² (1.5 m deep) |

A third idea was tested and not drawn: keeping the **whole** men's majlis roof in front of the living open (≈ 22 m², the most light) leaves room for only one of bedrooms 2 and 3.

## 10. First room layout (17 Oct 2026 · option A, adjusted)

`design_ff.typ`:
- page 1: the plan with the checks;
- page 3: the furnished plan, with doors and drain runs;
- page 4: the room table and problems;
- page 5: the light section.

Rooms are in `data/rooms_ff.csv`; the zoning options are kept in `data/zones_ff.csv`.

**Why the layout differs from zoning option A.** With bedrooms 2 + 3 filling the band over the women's majlis, bedroom 1 and the suite could only be reached through a bedroom. The fix:
- a 1.2 m family gallery along the courtyard's north side, plus a short link to the suite door;
- only one bedroom then fits in the north, so bedroom 3 moves to the south-west, at the end of the gallery;
- the gym is deferred and the whole roof over the men's majlis middle stays open (see the section).

| Room | Axes | m² axes | ≈ clear m² |
|---|---|---|---|
| Landing (stair top) | 2.75 × 1.3 | 3.57 | 2.7 |
| Upper gallery + family link | polygon | 37.06 | 31.6 |
| Visitors' WC | 1.25 × 2.0 | 2.50 | 1.9 |
| Office | polygon (2.75 wide) | 12.75 | 11.1 |
| Shared bath (bed 2 + 3) | 2.75 × 2.0 | 5.50 | 4.5 |
| Linen store | 2.75 × 1.85 | 5.09 | 4.1 |
| Bedroom 2 (north) | 4.7 × 3.1 | 14.57 | 12.9 |
| Family living (+ open gallery) | 4.7 × 2.2 | 10.34 | 9.0 |
| Bedroom 1 | polygon | 11.74 | 10.0 |
| Bedroom 1 bath | polygon | 4.01 | 3.2 |
| Suite lobby + passage | 1.2 × 6.5 | 7.80 | 6.3 |
| Suite bathroom | polygon | 10.70 | 9.3 |
| Suite dressing | 3.16 × 3.0 | 9.48 | 8.2 |
| Suite bedroom | 4.36 × 6.25 | 27.26 | 25.0 |
| Bedroom 3 (south-west) | 4.25 × 4.75 | 20.19 | 18.2 |
| **Rooms** | | **182.56** | |
| Private terrace (suite only) | 4.36 × 4.75 | 20.71 | — |
| Open roof (gym deferred) | 4.7 × 4.75 | 22.32 | — |
| **Available = used** | | **225.6** | |

Clear ≈ axes minus half a wall on every edge (250 / 200 mm), corners ignored.

**Drain runs:**
- visitors' WC ≈ 1 m to the west shaft;
- shared bath directly over the ground-floor family WC (stacked);
- bedroom 1 bath ≈ 1 m to the east duct, in the floor build-up over the maid room;
- suite bathroom ≈ 3–4 m to the east duct, in a sunken bath floor (≈ 150–200 mm, to confirm), never in the kitchen ceiling over the hood;
- no drain over the master bedroom.

**Light section:**
- **Sun at noon in Taif:** winter ≈ 45° from the south, equinox ≈ 69°, summer ≈ 92° (almost overhead, slightly north).
- **1.5 m strip:** with a gym or room behind it (top +7.20, parapet +8.30), the winter sun is blocked on the whole clerestory (sill +4.80); the open part would need ≈ 3.5 m.
- **Decision proposed:** keep the whole roof over the men's majlis middle open.

**Problems still open** (owner to decide):
- family living small (≈ 10 m² + the gallery);
- bedroom 1 small (11.7 + 4.0 m²);
- shared bath ≈ 13 m from bedroom 2;
- bedroom 3 over the men's majlis (structural check);
- office narrow (≈ 2.55 m clear);
- suite lobby is a 6.5 m passage.

## 10b. Re-zoned layout (17 Oct 2026, replaces §10 as the current layout)

**Why.** The furnished test of option A showed linked problems:
- the shared bath was ≈ 13 m from bedroom 2;
- the family living was only 2.2 m deep;
- the suite had a 6.5 m passage;
- bedroom 1 was small;
- there was ≈ 48 m² of circulation.

They came from one zoning decision: the children's bedrooms split around a bath in the middle.

**New zoning** (a mix of A and B), in `design_ff.typ` / `data/rooms_ff.csv`:
- **Master suite east** (from A), over the kitchen + dining, with its terrace on the men's majlis roof (palm side).
  - A compact 3.5 m² lobby replaces the passage; the bathroom and the dressing each open from it.
  - The bedroom is reached through the dressing (walk-through), so the bed is not seen from the suite door. A "night door" joins the dressing and the bathroom.
- **Children together in the west:** bedroom 2 (13.3 m²) and bedroom 3 (17.6 m²) on either side of the shared bath (5.5 m²). The bath sits over the ground-floor family WC / serving passage (wet stack). Bedroom doors are ≈ 1.3 m and ≈ 2.2 m from the bath door.
- **Family living north** (from B), at the stair top over the women's majlis (18.3 m²), onto the courtyard. A 1 m route along its courtyard edge leads to bedroom 1 and the suite. It is the family hub and the buffer.
- **Office north**, next to the family living (12.2 m², north light). **Visitors' WC** kept, from the landing. Visitors go landing → gallery → office and never pass a bedroom or the suite.
- **Bedroom 1 + bath** at the east duct (11.7 + 4.0 m²), the bath back to back with the master bathroom.
- **Linen:** built-in cupboards along the gallery (against the stair wall).
- **Gym:** still deferred.

**Numbers:**
- available 225.6 m² = rooms 175.4 + terrace 20.7 + open roof 29.5;
- circulation (landing + gallery + family link + suite lobby) **38.5 m²** (was ≈ 48), plus a ≈ 4.7 m² route inside the family living.

**Men's majlis roof:** no room on it now. Bedroom 3 stays in the west band, over the ground-floor guest basins and foyer. The open roof is 29.5 m² (x 2.75–8.95), the terrace 20.7 m².

**Light check (page 5).**
- Clerestory: 4.7 × 2.0 m, sill +4.80 (just above the majlis parapet +4.70), head +6.80, ≈ 0.6 m overhang.
- Three open-roof sizes compared, with a first-floor room behind the open part (up to +7.20, parapet +8.30):

| Open roof in front of the living | Winter noon sun on the clerestory | Sky seen through it from a seated eye |
|---|---|---|
| 1.5 m strip (≈ 7 m²) | 0 % | ≈ 33 % |
| 3.5 m strip (≈ 16 m²) | 100 % | 100 % |
| full roof (4.75 m, ≈ 22 m² in the middle band) | 100 % | 100 % |

- **Seasons:** in summer the sun is almost overhead, so the clerestory gets sky light and light reflected from the roof in front. Use a light-coloured roof finish and parapet.
- **Proposal:** keep the full middle roof open. A daylight simulation (sky model, reflectances) comes at a later stage.

**Walls not on ground-floor wall lines (engineer to check):**
- y 2.6 (office / family living);
- y 11.2 and x 1.5 (visitors' WC);
- y 15.6 and 17.6 (shared bath);
- the family link;
- bedroom 1 walls (x 11.0, y 4.5);
- suite walls (x 10.35, y 9.0, 10.0, 11.9).

**Problems still open:**
- children's rooms only 2.75 m wide (≈ 2.55 m clear);
- bedroom 3 long (2.75 × 6.4);
- bedroom 1 small (fix: take ≈ 1.2 × 2.6 m from the office);
- suite bedroom reached through the dressing; the bedroom (32 m² incl. the sitting corner) is larger than the target while the lobby is minimal;
- office at the low end of its target (12.2 m²).

## V4.1 · first-floor baseline (17 Oct 2026 · git tag `v4.1`)

The layout in §10c is frozen as **First floor V4.1**, the baseline for the detail rounds. The ground floor stays **V4.0**.

**Decisions:**
- **Zoning:**
  - master suite **east**, with a lobby that distributes to the bedroom, dressing and bathroom;
  - children **west**, around the shared bath;
  - family living **north**, at the stair top;
  - office at the stair top;
  - bedroom 1 + bath at the **east duct**.
- **Men's majlis roof fully used:** bedroom 3 (west), gym (middle), suite terrace (east), and a **2.0 m open light strip** in front of the double-height living's two small clerestory windows (1.0 × 1.0 m). A **railing, not a solid parapet,** on the gym roof edge facing the strip.
- **Gym kept:** a small family gym of ≈ 16 m², for kettlebells, a barbell, one or two cardio machines, a pilates mat and a pull-up bar. The engineer checks loads and vibration over the men's majlis.
- **Terrace kept:** the couple's only private outdoor space. Its size may be reduced later to help bedroom 3 and the gym route.

**Open items for the detail rounds** (listed, not solved):
- **Review order:**
  1. stair / lift / landing;
  2. west: children's rooms, shared bath, office, children's study, storage;
  3. north: family living;
  4. east: bedroom 1 + bath, master suite;
  5. men's majlis roof: gym, terrace, light strip;
  6. the whole floor.
- **Known issues:**
  - bedroom 3 is 3.05 m wide;
  - family seating is 15.75 m²;
  - the suite lobby is ≈ 8.2 m²;
  - circulation is 49.8 m²;
  - some walls are off the ground-floor lines (engineer);
  - terrace size vs the gym route.
- **Still open from the ground floor:**
  - the locked laundry service door (owner);
  - the envelope gap of 0.05 m, to be confirmed by the official survey;
  - the foyer majaz, only partial;
  - the `plumbing.typ` study, still to do.

## 10c. Coordinated revision (17 Oct 2026, the current layout; replaces §10b)

Same zoning as §10b: suite east, children west around the shared bath, family living north at the stair top, bedroom 1 at the east duct.

**1. Men's majlis roof, now fully used** (x 2.75–13.311, y 19.25–24):
- **Bedroom 3 (west):** 3.05 × 4.75 = 14.5 m², a normal proportion.
- **Gym (middle):** 5.9 × 2.75 = 16.2 m², behind an open light strip.
- **Open light strip:** 4.7 × 2.0 = 9.4 m², directly in front of the double-height living's south wall and only as wide as that wall.
- **Suite terrace (east):** 20.7 m².
- **Gym route:** 1.2 m wide, from the end of the upper gallery along x 3.05–4.25. It passes no bedroom and not the suite, and runs beside the light strip, not across it.
- **Why bedroom 3 is not 4.25 m wide:** the gym can only be reached from the gallery end along the 1.5 m strip of majlis roof west of the light strip. A 4.25 m bedroom 3 would mean reaching the gym through bedroom 3, or across the strip.
- **Children's study:** the freed west-band piece between the shared bath and bedroom 3 becomes a small study (4.5 m²) off the gallery.
- **Engineer:** load and vibration check for the gym and bedroom 3 over the men's majlis.

**2. Clerestory and light strip.**
- **Main light:** the double-height living gets its main light from the courtyard (north glazing).
- **South windows:** now two small windows, each 1.0 × 1.0 m, sill +5.00, head +6.00, for extra light and ventilation.

| Behind the 2.0 m light strip | Winter noon sun on the windows | Equinox noon sun | Sky seen through the windows from a seated eye |
|---|---|---|---|
| gym with a 1.10 m parapet (top +8.30) | 0 % | 100 % | 42 % |
| gym with a railing only (solid top +7.20) | 81 % | 100 % | 100 % |
| no gym, full roof open | 100 % | 100 % | 100 % |

**How the percentages are defined:**
- **Sun on the windows:** the share of the window height (sill to head) that gets direct sun at solar noon (21 Dec, 21 Mar / 23 Sep), in the north–south section through the windows.
- **Sky seen:** from a seated eye 1.20 m high in the middle of the double-height living (CSV y 16.1), the share of the vertical angle of the windows that shows sky rather than the gym.
- Geometry only, no reflections. A daylight simulation comes later.

**Proposal:** the 2.0 m strip, two small windows, a railing (not a parapet) on the north edge of the gym roof, light-coloured strip and gym wall, and small hoods over the windows.

**3. Suite lobby.**
- The lobby (8.2 m²: a 1.2 m entry from the family link, then a 1.6 m wide distributor) opens to the bathroom (9.5 m²), the dressing (8.0 m²) and the bedroom (26.5 m²). Nobody walks through the dressing any more.
- The king bed stands on the bedroom's north wall, east of the door line, facing the terrace and the palms. It is not seen from the suite door.

**4. Family living:** 20.0 m² = **seating 15.75 m²** (sofa set + TV wall) + a 0.9 m route along the courtyard edge (4.2 m²). The seating target was ≥ 16.

**5. Office and bedroom 1:**
- **Office:** a 2.25 m strip, 10.6 m² (≈ 9.1 m² clear), with a desk and one visitor seat.
- **Bedroom 1:** 13.8 m² + bath 5.0 m². It grew round the east duct, taking a strip of the former suite: its bath is on the duct's west face, the suite bath on its south face.

**6. Children:**
- **Bedroom 2:** 13.3 m² (2.75 m wide).
- **Bedroom 3:** 14.5 m² (3.05 m wide).
- **Furniture:** bed 1.2 × 2.0, wardrobe and desk each; door swings clear.
- **To the shared bath door:** ≈ 1.3 m from bedroom 2, ≈ 4 m from bedroom 3.

**Numbers:**
- available 225.6 m² = rooms 195.5 + terrace 20.7 + light strip 9.4;
- circulation (landing + gallery + gym route + family link + suite lobby) **45.6 m²**, + 4.2 m² route inside the family living = **49.8 m²** (the gym route and the larger suite lobby added ≈ 6 m²).

**Walls off the ground-floor lines (engineer):**
- y 2.25 (office / living);
- x 1.5 and y 11.2 (visitors' WC);
- y 15.6 and 17.6 (shared bath);
- over the men's majlis roof slab: x 3.05, y 21.25 and the gym / terrace screen at x 8.95;
- the family link (x 10.15);
- bedroom 1 and its bath (x 11.2, y 4.8, y 7.7, x 12.711);
- the suite (x 10.15–10.55, y 7.7, 11.0, 11.9, 13.9).

## 11. Open items (first floor)

- Gym deferred. A roof gym later = a third level, by the stair only.
- Engineer:
  - load and vibration check for any room over the men's majlis;
  - slab build-up for the sunken suite bathroom;
  - levels (+3.60, +7.20, parapets 1.10, clerestory +4.80 to +6.80).

## 12. Still to decide with the first floor

- The middle column (women's majlis, courtyard, living) and the riwaq are to be reviewed together with the first floor.
- The roof: plant area (AC outdoor units on a screened roof area), water tanks, the air tower head, roof access by the stair only.
- Structure: grid, beam depths over the 4.70 m middle band, wall build-ups.

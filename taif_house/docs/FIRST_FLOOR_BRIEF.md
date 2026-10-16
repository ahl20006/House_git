# Taif / Palm House · First floor brief

16 Oct 2026 · starting point for the first-floor design, set by the ground floor V4.0 (`docs/GROUND_FLOOR_V4.md`). The first floor is **not designed yet**.

Working files:
- `design_ff.typ` + `data/rooms_ff.csv`, same framework and same CSV coordinates as the ground floor;
- output: `output/design_ff.pdf`.

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

## 7. Still to decide with the first floor

- The middle column (women's majlis, courtyard, living) and the riwaq are to be reviewed together with the first floor.
- The roof: plant area (AC outdoor units on a screened roof area), water tanks, the air tower head, roof access by the stair only.
- Structure: grid, beam depths over the 4.70 m middle band, wall build-ups.

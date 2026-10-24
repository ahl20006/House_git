# Taif / Palm House · V6.2 · preliminary structural study

> **ALL CHECKS PASSED means the drawings are consistent; it does not mean strength, deflection or vibration were calculated.**

An architectural coordination study, **not a structural design**: it shows how the whole house is carried, from the foundations to the roof, as simply and directly as possible, so that the engineer starts from a coherent scheme. **Every size below is assumed, to be calculated by the structural engineer.** Drawings: `output/structure.pdf` (from `studies/structure.typ`: both floor framing plans, the roof, three sections, the stair plan and section, the tables and the conflicts list).

**Definitions.** Beam depth = **total depth including the slab**: a 0.50 beam under a 0.20 slab drops 0.30 below it; its soffit is the floor level minus 0.50. Clear heights are given before finishes. Coordinates are the CSV frame of the plans (x east, y south, origin = the building's north-west wall corner). Levels: GF ±0.00, FF +3.60, roof +7.20 (to confirm).

## 1. The idea
- **A reinforced-concrete skeleton with block infill**, as Saudi contractors build every villa: columns hidden in the walls, beams at each slab, hollow-block or solid slabs.
- **Walls on walls, columns on footings.** Every column runs from its own footing to the roof; nothing starts on a beam except the stair trimmers (normal at a stair well) and the two short gym walls over the men's majlis (a proposed, unverified load path, §4.4 and X5).
- **Spans 2.2–6.5 m.** The only spans over 6 m are on the three courtyard lines (x 4.25, 5.6 and 8.95: 6.5 m and 6.25 m), because the courtyard and the double-height living must stay free of columns.
- **Balanced stiffness, a proposal that is not calculated.** The west core (lift shaft, west shaft, stair walls) is matched by an east box: the solid laundry / maid wall on x 8.95, the cut wall and the kitchen's north wall, proposed as RC walls 0.20 m, so that the centre of stiffness stays near the centre of mass of the long pentagon. The engineer models the lateral system (frame + walls) and confirms it; the seismic design category for Taif and the wind case are taken from SBC 301 by the engineer, not assessed here.

## 2. Column grid
Columns 0.25 × 0.50 in the inner wall lines, 0.25 × 0.60 in the 0.25 outer walls, the three colonnade columns Ø0.30. All continuous to the roof; the colonnade columns carry only the first-floor edge beam and stop there (option: continue two of them to the roof inside the gallery railing, X8).

| Line | Columns at | Spans (m) |
|---|---|---|
| x 0 and x 2.75 (west band, riwaq line) | y 0 · 2.2 · 7.9 · 10.4 · 14.4 · 19.25 · 24 | 2.2 · 5.7 · 2.5 · 4.0 · 4.85 · 4.75 |
| x 4.25 and x 8.95 (courtyard lines) | y 0 · 3.0 · 6.5 · 13.0 · 19.25 · 24 | 3.0 · 3.5 · 6.5 · 6.25 · 4.75 |
| x 5.6 (colonnade, to the first floor) | y 6.5 · 13.0 · 19.25 | 6.5 · 6.25 |
| cut wall | (10.051, 0) · (11.572, 2.8) · (13.311, 6.0) | 3.2 · 3.6 |
| x 13.311 (east wall) | y 6.0 · 10.45 · 13.0 · 19.25 · 24 | 4.45 · 2.55 · 6.25 · 4.75 |
| y 0 and y 24 (north and south walls) | x 0 · 2.75 · 4.25 · 8.95 · 13.311 (cut corner 10.051) | 2.75 · 1.5 · 4.7 · 4.36 (1.1) |
| y 6.5 · 13.0 · 19.25 (cross lines) | x 4.25 · 5.6 · 8.95 · 13.311 (+ 2.75 on y 19.25) | 1.35 · 3.35 · 4.36 |

36 columns (C1–C36 in the drawing). The pair at (4.25, 3.0) and (8.95, 3.0) carries beam B1 under the first-floor kids' room / family living wall, so the women's majlis roof spans 3.0 + 3.5 m instead of 6.5 m.

**RC walls (stiff boxes, proposed):** W1 lift shaft (x 0, y 0, y 2.2), W2 west shaft (1.5 × 1.2), W3 laundry / maid wall x 8.95 (y 0–6.5, no openings), W4 the cut wall, W5 kitchen north wall y 6.5; plus the two short gym walls x 5.6 and x 11.586 over the men's majlis (X5).

**Foundations (assumed):** isolated pads ≈ 1.5 × 1.5 m under the columns, strip footings under the RC walls, RC tie beams on the column lines; lift pit 1.2 m; the air tunnel under the east band crosses the tie beams. No soil report, no soil data (X9).

## 3. Slabs and beams
### Slabs
| Level | Bay | Type | Span |
|---|---|---|---|
| FF | west band x 0–2.75 (y 7.9–24), riwaq x 2.75–4.25 | solid 0.20 | east–west 2.75 / 1.5 m |
| FF | lift x 0–2.25 y 0–2.2 | solid 0.20 panel, removable later | – |
| FF | stair x 0–2.75 y 2.2–7.9 | L-shaped opening ≈ 8.2 m² + flight slabs 0.15 | §4.5 |
| FF | women's majlis roof x 4.25–8.95 y 0–6.5 | solid 0.20 | north–south 3.0 + 3.5 m to beam B1 |
| FF | projection x 4.25–5.6 y 6.5–19.25 | solid 0.20 (0.35 in option c) | east–west 1.35 m between B4 and B3 |
| FF | maid wing x 8.95–13.311 y 0–6.5 | solid 0.20 | east–west 4.36 m |
| FF | kitchen roof y 6.5–13 and dining roof y 13–19.25 | ribbed (hollow block) 0.30 | east–west 4.36 m; the suite bath floor sunken 0.15 |
| FF | men's majlis roof x 2.75–13.311 y 19.25–24 | ribbed 0.30, thickened ribs under the FF walls | north–south 4.75 m |
| roof | west band, riwaq / gallery line, kids' room / family living, suite, gym route, treadmill arm | solid 0.20 / ribbed 0.30 (suite, office) | 1.5–4.75 m |
| roof | gallery strip x 4.25–5.6 y 6.5–13 | solid 0.20 cantilever | 1.35 m from R3 |
| roof | **double-height living x 4.25–8.95 y 13–19.25** | **flat solid 0.22, no beam in the void** | east–west 4.7 m, R3 → R4 |
| roof | gym y 21.25–24 | solid 0.20 | north–south 2.75 m |

### Beams (first floor B, roof R; sizes width × total depth, assumed)
| Beam | Where | Span (m) | Size | Drop / soffit | Carries |
|---|---|---|---|---|---|
| B1 | y 3.0, x 4.25–8.95 | 4.70 | 0.25 × 0.40 | 0.20 below the slab, soffit +3.20 (or hidden in a 0.30 ribbed slab) | FF kids' / family living wall, nothing below |
| B2 | y 6.5, x 4.25–8.95 | 1.35 + 3.35 | 0.25 × 0.40 | edge, soffit +3.20 | FF slab edge on the courtyard |
| B3 | x 5.6, y 6.5–19.25 | 6.50 + 6.25 | 0.25 × 0.50 | **upturned, 0.30 above the slab (owner's preference)** or drop, 0.30 below (§4.1) | the projection and the gallery, on C21–C23 |
| B4 | x 4.25, y 6.5–19.25 | 6.50 + 6.25 | 0.25 × 0.50 | 0.30 below, soffit +3.10 | FF west rooms' east wall over the riwaq glazing and the low wall |
| B5 | x 8.95, y 13–19.25 | 6.25 | 0.25 × 0.55 | 0.35 below the dining ceiling, soffit +3.05 | suite bedroom west wall + half the dining roof, on the ceiling-height change |
| B6, B7 | y 6.5 and y 13.0, x 8.95–13.311 | 4.36 | hidden 0.30 | – | on the kitchen walls |
| B8 | y 19.25, x 2.75–13.311 | 1.5 + 1.35 + 3.35 + 4.36 | 0.25 × 0.45 | 0.25 above the wall, invisible | the FF walls on the majlis north wall line |
| B9–B14 | south wall, riwaq line x 2.75, west band cross walls | 2.2–5.7 | hidden 0.20–0.30 | – | on walls |
| B15 | y 1.0, x 8.95–10.594 | 1.64 | 0.20 × 0.35 | edge | air tower opening |
| B16–B18 | stair trimmers | 1.39 / 1.60 / 1.46 | 0.20 × 0.40 | soffit +3.20 | the L-shaped stair opening (§4.5) |
| B19–B21 | x 4.25, x 5.6, x 11.586 over the majlis | 4.75 / 2.0 | thickened ribs 0.30 | hidden | office wall, gym route wall, treadmill arm wall (nothing below) |
| R1, R2 | y 6.5 and y 13.0, x 4.25–8.95 | 4.70 | 0.25 × 0.45 | soffit +6.75 | the courtyard sky hole |
| R3, R4 | x 4.25 and x 8.95, full length | 3.0–6.5 | 0.25 × 0.50 | 0.30 above the FF walls, invisible | the roof over the void spans between them |
| R5 | y 19.25, x 4.25–13.311 | 1.35 + 3.35 + 4.36 | 0.25 × 0.50 | soffit +6.70, 0.70 above the clerestory head | the living's south wall line |
| R6 | y 21.25, x 5.6–11.586 | 6.0 | 0.25 × 0.50 | soffit +6.70, **drop, not upturned** (X4) | the suite court hole; on the FF walls x 5.6 / x 11.586: **proposed load path, not verified** (X5) |
| R7–R10 | north and south walls, riwaq line, air tower head | – | hidden | – | on walls |

### First-floor walls: what carries them
- **On a wall below:** the outer walls; x 2.75 at the lift and the landing; x 2.25 (lift); y 2.2, 7.9, 10.4, 14.4, 16.1 (bath 3 = the GF family WC), 19.25 (majlis north wall); x 1.5 (shaft); x 8.95 y 6.5–13 and y 6.5 x 8.95–13.311 (kitchen walls).
- **Nothing below → a beam:** y 3.0 (B1); x 4.25 y 13–19.25 (B4, over the low wall and the opening); x 8.95 y 13–19.25 (B5, over the open ceiling change); x 4.25 y 19.25–24 (B19), x 5.6 (B20), x 11.586 (B21) over the men's majlis.
- **Nothing below → light partitions** (100 mm block or dry wall, on the slab): the gym's north wall y 21.25 (7.7 m across the ribs, X6); the suite walls over the kitchen (x 10.3, y 10.45, x 12.211, y 8.0, y 11.9, y 13.9, X10); y 11.0 (family bath / niche / bedroom 2); y 9.2 x 1.5–4.25 (family bath north); x 2.2 (bath 3 / bedroom 3 entry); y 5.3 and x 10.15 (bedroom 1 / family link); the linen cupboard front (joinery).

## 4. Special zones (options compared, none imposed)
### 4.1 The west projection: edge beam B3 on the three columns (6.5 and 6.25 m)
| | (a) drop beam | (b) upturned beam | (c) deeper slab edge |
|---|---|---|---|
| size (total, incl. the 0.20 slab) | 0.25 × 0.50: 0.30 below the slab, soffit +3.10 | 0.25 × 0.50: 0.30 above the structural slab (top +3.90), ≈ 0.22–0.25 visible above a finished floor of 0.05–0.08; with 0.60 total, 0.40 above | slab 0.35 over the 1.35 m strip, no beam |
| what you see | a 0.30 m downstand along the colonnade, 3.10 m clear under it | a flush soffit at +3.40 over the colonnade; the upstand is the solid base of the gallery railing, the railing on it up to 1.10 | flush soffit, a thick slab edge seen from the courtyard |
| structure | standard, the stiffest | standard (the slab hangs from the beam's bottom, routine) | a 1.35 m band 0.35 deep over 6.5 m: depth / span ≈ 1/18, deflection-sensitive, heavy |
| cost | lowest | about the same formwork; it saves the railing base | more concrete and steel |

**(b) is the owner's architectural preference** (flush colonnade soffit); (a) is an acceptable alternative; **the engineer decides.** The visible upstand follows from the total depth the engineer needs, it is not fixed in advance.

### 4.2 The double-height living: a clean ceiling (preferred, not a rule)
1. **Flat solid roof slab 0.22 m spanning 4.7 m east–west** between the FF west rooms' wall (R3) and the suite wall (R4): no beam in the void, both beams invisible above walls. A common span for a 0.22 solid slab (not calculated); the cost of a normal solid slab. **Preferred.**
2. Ribbed 0.30 slab, ribs east–west: lighter and cheaper, but a ribbed soffit (or a false ceiling) over the void; still no cross beam.
3. A cross beam on y 16.1 with a 0.18 slab: cheapest in material, but a 0.45 m beam across the void, 7 m up, in the family's main room. Not recommended unless the engineer finds option 1 too deep.

### 4.3 The living ↔ dining opening (x 8.95, 6.25 m) under the suite wall
Beam B5, 0.25 × 0.55 total, between C27 (8.95, 13.0) and C28 (8.95, 19.25). It carries the suite bedroom's west wall, half the dining roof and the roof beam above. With the 0.20 slab it drops 0.35 below the dining ceiling: **soffit +3.05 before finishes, 3.05 m clear** (≥ 2.40). **It can sit exactly on the ceiling-height change line:** the dining ceiling is at +3.40 and the living has no ceiling, so the beam's 0.35 m *is* the step between the two heights. Alternatives: a wide-shallow beam 0.60 × 0.40 total (soffit +3.20), or a light suite wall so the beam carries only the slab (0.25 × 0.45 total, soffit +3.15).

### 4.4 The men's majlis roof (10.56 × 4.75 m) under the gym, the arm and the office
- **Ribbed slab 0.30 spanning north–south 4.75 m** from the majlis north wall (B8) to the south wall (B9). **No column inside the majlis.**
- The first-floor walls parallel to the ribs (office x 4.25, gym route x 5.6, treadmill arm x 11.586) each stand on a thickened rib (B19–B21): direct and cheap.
- The gym's north wall y 21.25 runs across the ribs for 7.7 m with nothing below: **a light partition on the slab (recommended)**; or a 200 mm wall on a solid band in the ribbed slab; a 10.56 m drop beam (≈ 0.90 m deep, visible in the majlis) is rejected.
- **Loads:** it is a **home gym** (light equipment, no dropped heavy weights, one treadmill). The engineer chooses a normal residential-gym live load as they judge (SBC 301 gives 5 kN/m² for gymnasia; what applies to a home gym is the engineer's call); the treadmill ≈ 1.5–2 kN dynamic (manufacturer's data); office 2.5–3 kN/m².
- **Vibration: not calculated here.** The natural frequency of the 4.75 m ribbed slab and its response under the treadmill arm must be checked by the engineer; the arm gets a floating floor and pads (`DETAILS.md`) in any case.
- **The gym roof beam R6** (6.0 m, the suite court's south edge) is carried by the two gym walls x 5.6 and x 11.586, which stand on the ribs B20 / B21: **a proposed load path, not verified** (X5).

### 4.5 The stair (x 0–2.75, y 2.2–7.9) · drawn on its own page
- **Well:** 2.75 × 5.70 m on wall centre lines = **2.525 × 5.50 m clear** (0.25 outer wall west, 0.20 walls north and south; the east side open to the riwaq on the ground floor, a railing on the first floor).
- **Rise:** 3.60 m = 22 risers × 0.164 m, 11 per flight; goings 0.28 m, 10 per flight = 2.80 m.
- **Plan:** half landing 1.25 m (y 2.30–3.55) at the north end, flights y 3.55–6.35, arrival 1.45 m (y 6.35–7.80) at the south end: 1.25 + 2.80 + 1.45 = 5.50 = the clear length. **It fits the reservation.** Flight 1 (west) rises northwards to the half landing at +1.80 (the store under it, ≈ 1.65 m headroom); flight 2 (east) comes back south and arrives at +3.60 on the arrival strip, then the landing room (y 7.9–9.2) and the gallery.
- **Flight clear width:** (2.525 − 0.10 central gap) / 2 = 1.21 m each, ≈ 1.13 m between a wall handrail (0.08) and the central handrail; ≥ 0.90 m (residential).
- **Opening in the first-floor slab, L-shaped, ≈ 8.2 m²:** the slab may stay only over the treads that keep ≥ 2.10 m to the *beam* soffit (+3.20 with 0.40 total trimmers), i.e. treads 1–6 of flight 1 (tread 6 at +0.98 → 2.22 m). So: open over flight 1 beyond tread 6 (x 0.125–1.39, y 2.30–4.75), and fully open over the half landing and flight 2 (x 1.39–2.65, y 2.30–6.35).
- **Trimmers, 0.20 × 0.40 total, soffit +3.20:** B16 on y 4.85 (from the west wall to B17), B17 on x 1.29 (on flight 1's side of the split, so it is never over flight 2; from B16 to B18), B18 on y 6.45 (the arrival edge, from B17 to the riwaq line beam B10). B16 and B18 bear on B17: one beam-on-beam zigzag, normal at a stair well; the engineer takes the torsion.
- **Headroom, measured to the beam soffits:** 2.22 m at tread 6 to B16; 2.91 m at tread 3 to the slab; ≥ 2.38 m under B17 (over flight 1 treads 1–5); flight 2 and the landing are under the roof (≥ 3.4 m). No conflict.

### 4.6 Glazing and the grid
- Courtyard glazing (x 4.25 and x 8.95): no column in the openings; beams B4 / B6 above the heads (B4 soffit +3.10: the riwaq glazing heads ≤ +3.10 before finishes, X12).
- Women's majlis south glazing (y 6.5, x 5.1–8.1): C21 at x 5.6 stands in it; the glass becomes 5.1–5.4 + 5.8–8.1 (comes with the colonnade).
- Living glazing (y 13.0, x 4.45–8.75): C22 at x 5.6 is the pier, a decision of the columns solution (X1).
- Clerestory windows (y 19.25, x 6.0–7.0 and 7.6–8.6, +5.00–6.00): C23 and C28 are clear of them; R5's soffit +6.70 is 0.70 above their head.
- Suite bath east window, shortened by the owner to y 9.6–10.2: the clearance to C33 depends on the column's length along the wall (X3).

### 4.7 Lift shaft, air tower, roof openings
- **Lift (future, two stops):** RC walls on x 0, y 0 and y 2.2; the east wall x 2.25 blockwork with the future door reveal. The FF slab and the roof over the shaft are framed as openings now and closed with removable panels on hidden beams, so the shaft opens later without cutting. Pit 1.2 m, clear of the air tunnel.
- **Air tower:** rises through both slabs; openings framed by B15 / R9 (y 1.0) and the RC walls W3 / W4; a light RC frame for the head above the roof.
- **Roof openings:** the courtyard sky framed by R1, R2, R3 (the cantilevered gallery strip) and R4; the suite court by R5, R6 and the FF walls x 5.6 / x 11.586; the west shaft framed in B13 / R10.

## 5. Conflicts and open questions for the structural engineer
| No. | State | Item |
|---|---|---|
| X1 | accepted | Column C22 (5.6, 13.0) stands in the courtyard / living glazing; the glass is split 4.45–5.45 + 5.75–8.75. Keep it round Ø0.30. |
| X2 | accepted | Beam B5 (0.25 × 0.55 total) shows 0.35 m below the dining ceiling on the ceiling-height change line, soffit +3.05 before finishes: it is the step itself. Alternative 0.60 × 0.40 total (soffit +3.20). |
| X3 | owner decided · column size to confirm | **C33 stays at (13.311, 10.45); the suite bath east window is shortened to y 9.6–10.2 (0.60 m).** Clearance between the column's real outline and the window: with the assumed 0.25 × 0.60 lying along the wall (y 10.15–10.75) the column **still overlaps the window by 0.05 m**; with 0.25 × 0.50 along the wall (y 10.20–10.70) the clearance is 0.00 (jamb on the column face); with 0.25 × 0.40 or a 0.30 square it is +0.05 / +0.10. Turning the 0.60 side into the room (y 10.325–10.575) gives +0.125 but a 0.35 m nib in the kitchen counter and beside the suite tub. So there is no clash only if the engineer keeps C33 to ≤ 0.50 along the wall (plausible for two storeys and light loads). The GF kitchen window (y 8.7–10.1) is clear in every case. |
| X4 | rule | The gym roof's north edge R6 must be a drop beam, not upturned: an upstand of 0.40 would raise the solid top to +7.60 and cut the clerestory's winter noon sun from ≈ 81 % to ≈ 40 %. |
| X5 | **NOT verified** | **Proposed load path, not verified:** R6 (6.0 m) carried by the first-floor walls x 5.6 and x 11.586 standing on ribs of the men's majlis roof (B20, B21), not on columns, because no column may stand in the majlis. Proposal: build those two walls as RC walls 0.20 m so the path roof → wall → rib → GF walls is explicit. **The structural engineer must confirm the supports, the sizes and the deflection of R6, B20 and B21.** In the 3D model (phase 4) R6 and these two walls are to be shown as unconfirmed (own colour / hatch) until then. Loads: a home gym (§4.4). |
| X6 | flag | The gym's north wall (y 21.25, 7.7 m) runs across the ribs with nothing below: light partition recommended. Home gym (light equipment, one treadmill): live load as the engineer judges; the slab's vibration under the treadmill arm is not calculated and must be checked; floating floor and pads in the arm. |
| X7 | flag | The living's south wall (y 19.25, x 5.6–8.95) is 7 m tall with the clerestory, tied at +3.6 only on its south face: its slenderness between C23 and C28 (3.35 m) is not checked here; the engineer confirms it, with RC stiffeners at the window jambs if needed. |
| X8 | option | The colonnade columns end at the first floor; the roof over the gallery strip cantilevers 1.35 m from R3. Option: continue C21 and C22 to the roof inside the gallery railing (a two-storey colonnade). Owner / engineer. |
| X9 | missing | No soil report, no soil data: footing type and depth, the lift pit, and the air tunnel under the east band crossing the tie beams and the footings of C24–C27 / W3. |
| X10 | flag | Suite walls over the kitchen: light partitions on the ribbed slab, or hidden beams under the bath walls with pipes; the sunken suite bath floor (≈ 0.15, x 10.3–13.311, y 6.5–10.45) is a depressed-slab detail inside a ribbed bay. |
| X11 | flag | Floor-to-floor 3.60 with 0.20 slabs and beams of 0.40–0.55 total depth gives 3.05–3.20 m clear under the beams before finishes (B4 +3.10 over the riwaq glazing, B5 +3.05 at the dining step, B1 +3.20 in the women's majlis if dropped). Acceptable; show the owner the hidden-beam option for B1. |
| X12 | open | B4 carries the bedrooms' east wall over the riwaq glazing: with 0.25 × 0.50 total (soffit +3.10) the riwaq glazing heads are at ≤ +3.10 before finishes, the dining-side heads under B5 at ≤ +3.05; confirm the window heights. |
| X13 | open | Which walls are RC: W1–W5 proposed plus the two gym walls of X5; the engineer confirms the lateral system under SBC 301 and the wind / seismic case for Taif (not assessed here). |
| X14 | open | Slab types: ribbed 0.30 for the 4.36–4.75 m bays and the majlis roof, solid 0.20 elsewhere, 0.22 flat over the void. The engineer may unify them; the clean soffit over the void is the only architectural wish. |
| X15 | open | Stair: flight widths (1.21 m clear assumed), the trimmers B16–B18 and their torsion, the store under the half landing, the arrival strip y 6.35–7.80, handrails. |

**Rules of thumb used (assumed):** beam depth = total depth incl. the slab; drop beams ≈ span / 12; hidden beams = slab depth; solid one-way slabs ≈ span / 24–28 (0.20 up to 5 m); hollow-block ribbed slabs 0.30 (25 + 5) for 4–6 m; flat solid roof 0.22 for 4.7 m; columns 0.25 × 0.50–0.60 in the walls (two storeys, light loads), colonnade Ø0.30; pad footings 1.5 × 1.5 m. Loads per SBC 301 as the engineer applies them. Nothing here was calculated for strength, deflection or vibration; nothing here replaces the structural design.

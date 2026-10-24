# Taif / Palm House · V6.2 · air system study v2 (dry malqaf, small duct, wall outlet; main ventilation by the MEP engineer)

> **Design-development study, not an engineering design.** Every size and performance statement is **assumed / not calculated, to be designed by the MEP engineer** (and the structural engineer for the duct, the tower base and the chamber). Nothing is calculated: no airflow, cooling, filtration, structural or hydraulic figure. **The study proves the performance of no option.** ALL CHECKS PASSED means the drawings are consistent with the project files, not that the system was sized.

**v1 (tag `air-p1`) is withdrawn.** It had an 8 m walk-in tunnel with a water channel inside: water in a dark underground duct adds condensation, mould and bacteria risks; a short, shallow tunnel gives little ground cooling; a walk-in tunnel (deep excavation, waterproofing, pumps, coordination with the footings) is too complex for a house; passing air over water does not clean it, and a screen is not a rated filter; an outlet into the open courtyard does not ventilate the closed rooms.

Drawings: `output/air_system.pdf` (from `studies/air_system.typ`: plan at foundation level, long section tower → duct → outlet chamber → wall grille, duct cross section, outlet chamber and grille detail, the three options, the maintenance table, the open items). The 3D model reads the same file (view "air system (underground)" in `3d/viewer.html`, `3d/output/plan_air.png`). Coordinates: the CSV frame; levels from the finished ground floor ±0.00.

## 1. The main ventilation system (the base, independent of the malqaf)
- The house needs a **calculated main system, designed by the MEP engineer**: **filtered fresh air to the closed rooms**, above all the bedrooms, through an ERV / heat-recovery unit; **exhaust** from the bathrooms, the WCs and the kitchen (hood and extract through the east wall); **air-conditioning sized separately**, ducts and AC in the gypsum ceilings (the owner's rule: drop beams, ducts and lighting hidden by gypsum ceilings).
- **The malqaf is a natural supplement, not the main system.**
- **Reserved, not designed** (items M1–M3): a **roof plant area** over the maid wing (x 9.6–13.0, y 2.6–6.0, ≈ 11.6 m², screened, beside the tower, away from the suite court and the bedroom windows) for the ERV and the AC outdoor units; **duct routes in the gypsum ceilings** of both floors with access panels; a **riser** (the west shaft 1.5 × 1.2 at x 0–1.5, y 9.2–10.4, or a second one beside the east kitchen stack).

## 2. The malqaf, simplified: dry, for night ventilation
- **Tower:** dry. A washable insect / dust screen **plus a slot for a proper rated filter** (class and pressure drop by the MEP engineer); a **closable damper**, motorised with a manual override, closed in dust storms, cold weather and the hot daytime hours; a roof access hatch in the south face; the head 2.5 m above the roof (+7.30 → +9.80) with louvred openings 0.8 × 1.2 on the north and west faces (+8.20 … +9.40); a cap with a drip. Shaft ≈ 0.78 × 1.3 clear with rungs; a grating in the shaft floor; a dry **base pit** to −1.95 with a drain point and the duct's sealed access hatch.
- **Main use: night ventilation.** Taif's nights are cool: open at night to cool the thermal mass of the courtyard's walls and floor, closed by day.
- **No water anywhere inside the tower or the duct.** The water channel of v1 is removed.

## 3. The duct (replaces the walk-in tunnel)
- A short, small, **dry** duct from the tower base to the courtyard's north wall: assumed **0.6 × 0.6 m clear** (to be sized), outer 0.9 × 0.9 (walls 0.15), smooth inside, sloped **1.5 %** to a drain point, **sealed against soil gas and ground water** (a factory-sealed precast RC / GRP box or an in-situ sealed box: engineer + MEP).
- **Route A** as in v1: from the tower's west wall 1.68 m west under the women's majlis north strip, then 5.85 m south on x 7.27 (axis 7.53 m). Under the women's majlis only (no bedroom, no wet room); no house drain crosses it; 0.48 m from the assumed C25 pad, 0.40 / 0.25 m from the C21 / C26 pads; it crosses the W3 / C24 line only at the tower (the base pit is the foundation there, A1) and the majlis south wall at the chamber (ground beam, A3). Route B (under the maid wing) rejected as in v1.
- **Levels:** top −1.00 (just under the assumed tie beams at −0.90, 0.72 m under the slab), underside −1.90; floor (clear) −1.75 at the tower, −1.86 at the chamber.
- **Not walk-in:** cleaned from both ends (brush, camera, cleaning robot) through **sealed access hatches** at the tower base pit and at the outlet chamber.

## 4. The outlet in the courtyard wall (not in the floor)
- A **low grille in the courtyard's north wall**, bottom +0.20, top +0.80, 1.0 m wide (x 6.85–7.85), decorative (mashrabiya-type), with an insect screen and a closable shutter behind it, for a slow low-level, displacement-type supply across the courtyard floor.
- **No air opening in the courtyard floor** (rain, dust, leaves, floor-washing water, trip hazard). The cleaning access is a **sealed, gas-tight floor cover** 0.6 × 0.6 beside the wall (x 7.0–7.6, y 6.8–7.4), opened only for cleaning and for the seasonal pad frame.
- **Behind the grille:** a small chamber under the courtyard floor against the wall (outer x 6.75–7.95, y 6.6–7.6; clear 0.9 × 0.7; floor −2.10; sealed like the duct) → a plenum in the wall base (0.2 × 1.0, the wall's thickness, from the slab to the grille head) → the grille. In the chamber: an **optional removable evaporative pad frame (≈ 0.6 × 0.6) and a small quiet fan**, with water, drain and power points, installed only when needed (hot daytime). **Rules: no sprays or mist; pads drained and dried daily; the duct and the tower stay dry.**
- The women's majlis glass (x 5.1–8.1) stands on this wall: the grille zone needs a solid wall base 0.9 m high there (the glass sill raised over 1.0 m) or the glass shortened to x 5.1–6.4 — owner (A7).

## 5. The three options for the MEP engineer
To be compared with **annual performance, cost and maintenance before anything goes into the foundations**:

| | A · direct dry malqaf | B · malqaf + fan + filter | C · dry earth-air heat exchanger |
|---|---|---|---|
| what | tower, screen + filter, damper, the short dry duct, the wall grille; wind and stack only | as A, plus a small quiet fan and a rated filter; the pad frame optional at the outlet | a longer, deeper dry pipe run (proper depth and length, several parallel pipes), condensate drainage, a fan; the grille or ducted supply |
| gives | night ventilation of the courtyard when the breeze blows; nothing by day | controlled night ventilation whatever the wind; filtered; optional evaporative supply by day | cooled (in winter tempered) supply by day and night; the only option with real ground cooling |
| costs / risks | lowest; depends on the wind; the courtyard only | fan power, filter changes; the pads need the daily drain-and-dry routine | excavation outside the house, length, condensate and hygiene management, fan power; must be designed, not assumed |

The study proves the performance of none of them. The drawings show option A (they also fit B); C would change the route and the depth and is not drawn.

## 6. Health and dryness rules (stated, not optional)
- **No water inside the tower or the duct:** no channel, no sprays, no mist, no fogging. The only water is in the optional pad frame in the outlet chamber, drained and dried daily; make-up water through a float valve and a backflow preventer.
- **Filtered:** a rated filter in the head's slot; the screen only keeps insects and coarse dust out.
- **Sealed and drained:** the duct sealed against soil gas and ground water, falling to a drain point with a non-return trap; drain points in the base pit and the chamber.
- **Separate from the house and closable:** a separate element; no house drain crosses it; the damper closes it; the floor cover is gas-tight and opened only for cleaning.

## 7. Levels (assumed)
| | level |
|---|---|
| head top / head openings | +9.80 / +8.20 … +9.40 |
| roof finish / roof slab | +7.30 / +7.20 |
| ground floor finished / grating in the shaft | ±0.00 / −0.08 |
| tower base pit floor | −1.95 |
| duct top / underside at the tower | −1.00 / −1.90 |
| duct floor (clear) at the tower / at the chamber | −1.75 / −1.86 |
| outlet chamber floor | −2.10 |
| grille in the wall | +0.20 … +0.80 |
| assumed tie beams / pad footing underside | −0.28 … −0.90 (the duct passes 0.10 m under them) / −1.50 (only the base pit and the chamber reach it: A1, A3) |

## 8. Maintenance (what · how often · how to reach it)
| Item | What to do | How often | How to reach it |
|---|---|---|---|
| head louvres + insect / dust screen | brush and wash the screen; clear the louvres; check the drip | monthly in the dust season, else every 3 months | from the roof, through the hatch in the head's south face |
| rated filter (head slot) | check the pressure drop / indicator; replace or wash as its class allows | per the MEP engineer; before and after the dust season | from the roof hatch |
| damper (head) | check the motor, the manual override and the control; grease, test closing | every 6 months and before the dust season | from the roof hatch |
| shaft walls, rungs, grating | brush, check the rungs, the lighting and the grating lock | yearly | rungs from the head hatch |
| tower base pit + drain point | sweep, check the drain and its trap, look for damp | every 6 months | down the shaft (two people, lid open) |
| dry duct | brush / camera inspection / cleaning robot from both ends; check that it is dry and sealed | yearly; after any smell or damp | sealed hatch 1 (base pit), sealed hatch 2 (chamber) |
| outlet chamber + drain point | sweep, check the drain and the trap, the water and power points | every 6 months | sealed floor cover beside the wall (cleaning only) |
| grille, screen and shutter | wash the screen, clear the grille, test the shutter | monthly in use | from the courtyard, standing |
| pad frame + fan (optional, seasonal) | install for the season; pads drained and dried daily; clean the pads, the tray and the fan | daily drain (automatic); pads monthly; in / out of the season | through the floor cover |
| sealing, joints | look for damp, cracks, salts, smells (soil gas) | after every heavy rain; yearly | hatches and cover |
| main system (ERV, exhausts, AC) | filters, coils, condensate, fans, controls | per the MEP engineer's schedule | roof plant area; ceiling access panels |

## 9. Coordination
- **Structure (`studies/structure.typ`, X9):** the tower's RC walls continue to −1.95 as the dry base pit, the foundation of the tower and the W3 / W4 ends (A1); the duct passes just under the assumed tie beams and clear of the pads except at its two ends; the majlis south wall bridges the duct mouth on a ground beam (A3); the chamber is a sealed box in the courtyard slab between the C21 and C26 pads; the shaft is open through both slabs (B15 / R9).
- **Plumbing:** no house drain crosses the duct; the drain points of the pit, the duct and the chamber discharge as the MEP engineer decides (A6); the courtyard floor drain at the south end.
- **Courtyard design:** the grille in the north wall's base, east of the projection line; the sealed cover beside the wall; the colonnade column C21 0.9 m away.
- **Electrical:** damper motor, lighting, the optional fan and pad pump, sockets: one dedicated circuit with an RCD.

## 10. Open items
| No. | For | Item |
|---|---|---|
| M1 | MEP | **The main ventilation system:** filtered fresh air to the closed rooms (ERV / heat recovery, the bedrooms first), exhausts for the baths, WCs and the kitchen, the AC sized separately; the design, the plant location (the reserved roof area) and the duct routes in the gypsum ceilings. |
| M2 | MEP / structure | The roof plant area: equipment loads, screening, vibration and noise to the bedrooms and the suite court, service access. |
| M3 | MEP | The risers (the west shaft; a second one if needed) and the ceiling heights with the ducts (gypsum ceilings at ≈ +3.05 … +3.20 under the drop beams). |
| A1 | structure | The tower base pit (−0.08 … −1.95) with the shaft walls as the foundation of the tower and the ends of W3 / W4; the duct leaves it through the W3 line: design the pit and the crossing. |
| A2 | structure / MEP | The duct: a factory-sealed box (precast RC or GRP) or an in-situ sealed box; its size (0.6 × 0.6 assumed), joints, bedding, soil gas and ground-water sealing; soil report first (X9). |
| A3 | structure | The women's majlis south wall (y 6.5) over the duct mouth: a ground beam bridging it between the C21 and C26 pads; the plenum in the wall base. |
| A4 | MEP | Option study A / B / C: annual performance, cost and maintenance; the head opening sizes, the filter class, the fan, the damper control (night / day, dust, cold). |
| A5 | MEP / safety | Access: the shaft rungs and fall protection; the base pit and the chamber as confined spaces (two people, lid open); the sealed hatches and the floor cover gas-tight and lockable. |
| A6 | MEP | The drain points of the pit, the duct and the chamber (traps, non-return, where they discharge); the courtyard floor drain at the south end, away from the chamber. |
| A7 | owner / design | The grille zone in the women's majlis glass wall (x 6.85–7.85): a solid 0.9 m wall base there, or the glass shortened to x 5.1–6.4. |
| A8 | MEP | The optional pad frame and fan at the outlet: water quality (float valve, backflow preventer, daily drain-and-dry), noise, power; no sprays or mist (rule). |

**Sizes assumed:** head 2.5 m above the roof, openings 0.8 × 1.2 on the north and west faces; shaft ≈ 0.78 × 1.3 clear; base pit to −1.95; duct clear 0.6 × 0.6 in a 0.9 box, top −1.00, fall 1.5 %; chamber 0.9 × 0.7 clear, floor −2.10; grille 1.0 wide, +0.20 … +0.80; roof plant area ≈ 11.6 m²; pads 1.5 × 1.5 with underside −1.50, tie beams to −0.90. Nothing here replaces the MEP or structural design.

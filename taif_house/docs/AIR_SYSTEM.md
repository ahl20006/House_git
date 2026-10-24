# Taif / Palm House · V6.2 · air system study (malqaf, tunnel, water channel)

> **Design-development study, not an engineering design.** Every size, level and performance figure is **assumed, to be checked by the MEP and structural engineers.** Nothing is calculated: no airflow, cooling, structural or hydraulic figure. ALL CHECKS PASSED means the drawings are consistent with the project files, not that the system was sized.

Drawings: `output/air_system.pdf` (from `studies/air_system.typ`: plan at foundation level, long section along the air path, cross sections of the tunnel and the channel, the outlet chamber, the maintenance table, the open items). The 3D model reads the same file (`3d/build_3d.py`, view "air system (underground)" in `3d/viewer.html`, `3d/output/plan_air.png`). Coordinates: the CSV frame (x east, y south); levels from the finished ground floor ±0.00.

## 1. Goal and idea
A **malqaf** (wind tower) in the tip of the north-east cut corner catches the north-west wind above the roof, sends it down the shaft (≈ 0.88 m² clear) into an **underground tunnel** through the cool ground to the courtyard; in the last metres the air passes over a **shallow water channel** (evaporative cooling, dust trap) and enters the courtyard through a **low, closable outlet** at the north wall. Warm air leaves through the open sky. Every opening closes (dust storms, cold, hot afternoons).

Goal: cools well, clean and healthy, easy to clean, and does not touch the house: a separate waterproof box, no standing water, no sprays, no route under bedrooms or wet rooms.

## 2. Route: two candidates, one chosen
| | **A · under the women's majlis (chosen)** | B · under the maid wing (rejected) |
|---|---|---|
| path | tower base → 1.75 m west under the majlis north strip → 5.85 m south on x 7.27 → outlet chamber at the courtyard's north wall; axis ≈ 8.3 m | tower base → south under the maid bath and the laundry → west under the kitchen north wall to the courtyard corner; ≈ 8.5 m |
| above it | GF: the women's majlis only (a sitting room, no drains); FF: kids' room / family living. No bedroom, no wet room | maid bath and laundry (drains, smells, leaks), then the kitchen north wall |
| footings crossed | the W3 / C24 line at the tower exit (unavoidable: the tower base box becomes their foundation, A1); the women's majlis south wall ground beam at the chamber (A3); clear of the assumed pads of C25, C26, C21 (≥ 0.15 m) | the walls y 1.0 and 2.8, the RC wall W5 and the pad of C26: three crossings |
| drains | none: the east block drains run east, away from the route | crosses the maid bath and laundry drains |
| cleaning | one straight leg; the courtyard chamber is the main access | two bends, longer, under wet rooms |

## 3. The parts (assumed sizes and levels)
- **Head:** the shaft's RC walls continue from the roof finish +7.30 to **+9.80** (2.5 m above the roof). Louvred openings 0.8 × 1.2 on the **north and west faces** (sill +8.20, head +9.40), facing the NW wind; the south and the cut faces closed. Inside: a washable insect / dust screen and a **closable damper** (motorised with a manual override; closed in dust storms and cold weather). A cap roof with a drip. An access hatch in the south face at roof level.
- **Shaft:** clear ≈ 0.78 × 1.3 m; steel rungs on the east wall from the head hatch to the base; the ground-floor slab inside the shaft is a **grating** (the second access hatch).
- **Base chamber:** the shaft walls continue down to **−3.15** as one RC box: the foundation of the tower, of C24 / C30 and of the ends of W3 / W4 (engineer, A1). Floor −2.80.
- **Tunnel:** a separate waterproof RC box, walls 0.20, floor 0.25, roof 0.20; outer 1.40 wide, **top of the roof slab −1.30, underside −3.15**; clear **1.0 × 1.4 m** (a person bent over). The floor falls **1.5 %** from −2.80 at the tower to −2.90 at the chamber. A flexible joint with a waterstop at each end (structurally independent of the house); waterproof membrane and protection board outside; epoxy and coved corners inside; **not insulated** from the soil (ground cooling wanted). It passes 0.40 m under the assumed ground tie beams (to −0.90) and keeps clear of the assumed 1.5 m pads except at its two ends.
- **Water channel:** only the **last 3.5 m** of the south leg (y 3.1–6.6), 0.40 wide, 0.12 deep, **0.08 m of water**, stainless steel or tiled with rounded corners, 0.30 m dry walkways on both sides. Recirculated by a small pump from a 60 L reservoir in the chamber; an overflow weir; **a timer drains and dries the channel every day**; make-up water through a float valve with a backflow preventer; drain to the sump.
- **Outlet chamber:** an RC box in the courtyard floor against its north wall, outer x 6.50–8.05, y 6.60–8.60, **clear 1.15 × 1.60**, floor −2.90, sump 0.4 × 0.4 × 0.4 (−3.30) with a submersible pump. A grating hatch 0.6 × 0.9 in the top (lockable) and a fixed ladder on the west wall (3–4 steps cannot reach −2.90; a ladder does). The **outlet is a louvred kerb 0.45 m high** on the courtyard side of the top slab, with an insect screen and a closable damper. A place for a removable desert cooler (0.6 × 0.6) with a socket, a water point and a drain to the sump; the reservoir and the circulation pump; a hose point, a light.

## 4. Health rules (stated, not optional)
- **No sprays, no mist, no fogging:** warm, stagnant or sprayed water grows Legionella and other bacteria. The channel is an open, shallow, moving surface; the air passes above it, it is never atomised.
- **No standing water:** the channel drains daily, the tunnel floor falls to the sump, the sump is pumped empty; make-up water through a float valve and a backflow preventer.
- **Smooth, washable surfaces:** epoxy or stainless steel, coved corners, no ledges; the tunnel is dark, which limits algae; a hose point in the chamber.
- **Separate from the house:** a waterproof box with joints; no house drain crosses it; the courtyard outlet closes.

## 5. Levels along the path
| | level |
|---|---|
| head top | +9.80 |
| head openings | +8.20 … +9.40 |
| roof finish / roof slab | +7.30 / +7.20 |
| ground floor finished / grating in the shaft | ±0.00 / −0.08 |
| tunnel roof top / underside | −1.30 / −1.50 |
| tunnel floor at the tower / at the chamber | −2.80 / −2.90 |
| box underside | −3.15 |
| sump | −3.30 |
| assumed pad footing underside | −1.50 (only at the tower exit and the chamber do footings and box meet, A1 / A3) |
| assumed tie beams | −0.28 … −0.90 (0.40 m above the tunnel roof) |

## 6. Maintenance (what · how often · how to reach it)
| Item | What to do | How often | How to reach it |
|---|---|---|---|
| head louvres + insect / dust screen | brush and wash the screen; clear the louvres; check the drip | monthly in the dust season, else every 3 months | from the roof, through the hatch in the head's south face |
| damper (head) | check the motor and the manual override, grease the hinges, test closing | every 6 months and before the dust season | from the roof hatch |
| shaft walls and rungs | brush the walls, check the rungs and the lighting | yearly | rungs from the head hatch down to the base |
| shaft-floor grating (hatch 2) | lift and clean, check the lock | yearly | from the shaft |
| base chamber and tunnel floor | sweep and hose down; the water runs with the fall to the sump | every 3 months | from the outlet chamber (ladder), walking bent over; or from the shaft |
| water channel | rinse and wipe; check the feed and the overflow; the timer drains and dries it every day | weekly in use; daily automatic drain | from the chamber end of the tunnel |
| reservoir, circulation pump, float valve, backflow preventer | empty and clean the reservoir; check the pump and the valves | monthly in use; before the season | in the chamber |
| sump and pump | clean the sump, test the pump and the float switch, flush the pumped line | every 3 months | in the chamber |
| outlet kerb: louvres, screen, damper | wash the screen, clear the louvres, test the damper | monthly in use | from the courtyard, standing |
| grating hatch and ladder | check the lock, the hinges and the ladder fixings | yearly | from the courtyard |
| removable desert cooler (optional) | install for the season, clean the pads and the tray, remove and store | start / end of the season; pads monthly | in the chamber, through the hatch |
| joints and waterproofing | look for damp, cracks, salts on the walls; seepage after rain | after every heavy rain; yearly | walk the tunnel |

## 7. Expected performance (qualitative only; nothing calculated)
- On nights and mornings with a north-west breeze the courtyard receives air that has passed through the ground and over the water: cooler than the street air, cleaner than ground-level air, and low, where people sit. The effect depends on the wind, the ground temperature and the humidity; the MEP engineer estimates the flow and the temperature drop and may add a low-energy fan in the shaft if the wind alone is too weak.
- Without wind the tower works weakly as a stack (cool, heavy air sinks); the optional desert cooler in the chamber gives a forced, cooled flow on still evenings.
- It is not an air-conditioning system: it cools the courtyard and the rooms around it when they are open to it, and it needs the daily routine of opening, closing and draining.

## 8. Coordination
- **Structure (`studies/structure.typ`, X9 updated):** the tower's RC walls are part of the east stiff box (W3 / W4 end); the base box replaces the pad of C24 and carries the W3 / W4 ends (A1); the tunnel keeps clear of the assumed pads of C25, C26 and C21 and passes 0.40 m under the tie beams; the women's majlis south wall sits on a ground beam bridging the tunnel mouth at the chamber (A3); the chamber is a box in the courtyard slab between the C21 and C26 pads; the shaft is open through the first-floor and roof slabs (framed by B15 / R9).
- **Plumbing:** the kitchen, laundry and maid-bath drains run east to the east manhole and never cross the tunnel; the sump's pumped line runs back along the tunnel and out east at the tower base (A7); the courtyard floor drain at the south end of the courtyard (A6).
- **Courtyard design:** the chamber and its kerb stand against the north wall, east of the projection line (open sky); the colonnade column C21 stays 0.9 m away; the kerb stands in front of the east end of the women's majlis glass (A8).
- **Electrical:** damper motor and lighting in the head and the shaft, light and sockets in the chamber, the two pumps, the timer valve: one dedicated circuit with an RCD.

## 9. Open items for the engineers
| No. | For | Item |
|---|---|---|
| A1 | structure | The tower base box (−0.08 … −3.15) as the foundation of the tower, of C24 / C30 and of the ends of W3 / W4; the tunnel leaves it through the W3 line: design the box and the crossing. |
| A2 | structure | The tunnel box: section, reinforcement, joints with waterstops, bedding, backfill, uplift / groundwater; soil report first (X9). |
| A3 | structure | The women's majlis south wall (y 6.5) over the tunnel mouth: a ground beam bridging the box between the C21 and C26 pads, independent of the chamber. |
| A4 | MEP | Airflow: expected flow and temperature drop (wind-driven and stack); whether a low-energy fan is needed; the head opening sizes; the damper control. |
| A5 | MEP / safety | The shaft as the second access: rungs, fall protection, lighting; a confined-space rule for the tunnel (two people, ventilation open while cleaning). |
| A6 | MEP | The courtyard floor drain at the south end, away from the chamber; rainwater falling into the kerb outlet: a drained tray inside the kerb. |
| A7 | MEP | The sump's pumped line to the east manhole (50 mm, along the tunnel, out at the tower base, under the maid bath, shallow); or a gravity drain if the manhole invert allows. |
| A8 | owner / design | The outlet kerb in front of the east end of the women's majlis glass (x 5.1–8.1): accept, or shorten the glass to x 5.1–6.4. |
| A9 | MEP | Water quality: make-up through a float valve and a backflow preventer; the daily drain-and-dry cycle; a monthly reservoir clean; no sprays or mist (rule). |
| A10 | structure / 3D | The roof and first-floor openings for the shaft (B15 / R9), the head above the roof (2.5 m, wind load), the cap and the hatch. |

**Sizes assumed:** head 2.5 m above the roof, openings 0.8 × 1.2 on the north and west faces; shaft ≈ 0.78 × 1.3 clear; tunnel clear 1.0 × 1.4 in a 1.4 m box, top −1.30, fall 1.5 %; channel 0.40 × 0.12, water 0.08, 3.5 m; chamber 1.15 × 1.60 clear, floor −2.90, sump −3.30; kerb 0.45; pads 1.5 × 1.5 with underside −1.50, tie beams to −0.90. Nothing here replaces the MEP or structural design.

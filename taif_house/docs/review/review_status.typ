// review_status.typ · Taif / Palm House · the review status after V10.0, the malqaf at L5 (compile THIS file → output/Design_Review_status_V10.0.pdf)
// The reviews themselves stay as they were: the design review (docs/review/design_review.typ → output/Design_Review_V6.pdf, tag review-1, written against V6.2)
// and the interim verification and validation review of V8.3 (docs/review/vv_review_v8_3.typ → archive/VV_Review_V8.3.pdf).
// This page lists every CRITICAL and MAJOR finding of both with its status after V10.0 (resolved / partly / open), the version that resolved it and
// the next items in the order to take them. The ids, places and severities are those of the two reviews.
#set page(paper: "a4", margin: (x: 13mm, y: 12mm), numbering: "1 / 1", number-align: right)
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 7.4pt)
#set par(leading: 0.45em)
#let accent = rgb("#2f6b4f")
#let red = rgb("#b5452f")
#let amber = rgb("#b58a1f")
#let green = rgb("#2f7a3f")
#let S(st) = if st == "resolved" { text(fill: green, weight: "bold")[resolved] } else if st == "partly" { text(fill: amber, weight: "bold")[partly] } else { text(fill: red, weight: "bold")[open] }

// ---------- the design review of 30 Oct 2026 (V6): (id, severity, where, status, version, what was done / what is still open) ----------
#let rows = (
  ("Y-01", "critical", "Courtyard · the envelope", "resolved", "V7.0 / V7.1", [Enclosure option A: W1 on the gallery edge, W2 on the family living's edge, W3 over the living's courtyard glass, black steel divided lites, the projection 1.55 m (B3 / R11 / C21–C23 at x 5.80); the courtyard open to the sky; semicircular heads over the three-arch arcade.]),
  ("A-01", "critical", "Ageing · the lift", "resolved", "V6.3", [The lift installed at construction, two stops; the shaft a placeholder until a supplier's drawing (open item: headroom ≤ 3.40 m / ≤ 3.70 m with a raised head).]),
  ("S-03", "critical", "Site · north and lane setbacks", "partly", "V9.1", [*Set out on site* by the owner (day 1, diagonals exact); *the final position V9.1: B1 exactly 6.00 m from M1* after the owner's car test (a full forward turn into the north strip), 0.51 m further south than V9.0, and *the cut wall shortened again* (a further 0.24 m out, 6.08 m) so the margin is *0.91 m from the deed setback line, 0.42 m from a setback counted from the wall as built* (field 2.30 m; the wall 0.62 m inside the deed line); the third set-out on the sheet (`output/setout.pdf`). *Open:* the official survey and the engineering office's answer on which line the setback is counted from; the levels from the survey.]),
  ("E-08", "major", "Services · fire and life safety", "resolved", "V8.0 / V8.1", [Home-level strategy (owner): interconnected mains smoke alarms with battery back-up, heat, CO and gas detectors, extinguishers and a blanket; escape casements without screens in every sleeping room; thumb-turns on the exits; the first floor's exits the main stair plus the escape windows; the suite court a fresh-air area, not an exit.]),
  ("G-01", "major", "GF · living wall (west)", "resolved", "V6.3", [The solid TV wall with the entrance arch and the arched TV niche.]),
  ("G-04", "major", "GF · maid room", "resolved", "V7.0 / V9.1", [The kitchen's north wall at y 7.0 (V7.0); V9.0 / V9.1: the cut wall 0.12 + 0.24 m further out: the maid room *8.41 m² clear* (V9.0 7.69, V8.3 7.28), the maid bath 3.68 m².]),
  ("F-01", "major", "FF · gallery width", "resolved", "V7.0", [The projection 1.55 m: the gallery 1.405 m clear, 1.235 m at the column sleeves.]),
  ("F-02", "major", "FF · door widths", "resolved", "V6.3", [Bedroom and bathroom doors 1.00 m openings; exceptions recorded.]),
  ("F-06", "major", "FF · family living", "resolved", "V7.0", [W2 on the courtyard edge: a conditioned room.]),
  ("F-07", "major", "FF / roof · roof access", "resolved", "V7.0 / V8.1", [A manufactured maintenance ladder in a recess of a rendered pilaster (V10.0: no stone) on the gym's east wall in the suite court, behind a locked walnut panel; the guarding continuous to every piece of equipment. *Open:* the fall protection confirmed by the specialist.]),
  ("X-01", "major", "Circulation · serving the majlis", "resolved", "V8.1 (owner)", [Accepted by the owner: the food route kitchen → dining → riwaq → serving passage stays; very large events use the old majlis (inside the old house).]),
  ("G-02", "major", "GF · living + dining", "partly", "V7.0 / V8.2", [The courtyard well decided; the clerestories get the winter noon sun and stay openable; no garden door (owner). *Open:* the daylight simulation.]),
  ("G-03", "major", "GF · kitchen", "partly", "V8.0", [The hood's make-up air: a filtered motorised inlet interlocked with the hood. *Open:* the MEP sizing.]),
  ("G-07", "major", "GF · bathrooms", "resolved", "V8.3 (owner)", [No ground-floor shower (owner): ageing in place relies on the lift and the first-floor bathrooms; the family powder room (two basins, a wall-hung WC).]),
  ("Y-02", "major", "Courtyard · size for daily use", "resolved", "V8.0 / V8.3", [The level courtyard with movable seating for 4–6 facing the TV, the water + tree enclosure in front of the kitchen window, the north side free.]),
  ("Y-03", "major", "Courtyard · sunken seating safety", "resolved", "V8.3", [No step and no pit: the whole floor level with falls to linear drains and an overflow.]),
  ("T-01", "major", "Structure · X5", "partly", "V8.0", [Load path revised, *improved, not verified* (R6 removed; B19, B22, the office wall on rib B21). *Open:* the engineer.]),
  ("T-03", "major", "Structure · soil and foundations", "open", "", [No soil report: the pads (the malqaf core's pad included, V10.0), the lift pit and the soakaways are assumed.]),
  ("E-01", "major", "Services · the malqaf's value", "resolved", "V8.0 / V10.0", [Air system v4 (V10.0): the malqaf moved to the courtyard's north-west corner (L5, `studies/malqaf_L5.typ`): the breeze outlet in the first arcade arch ≈ 1 m from the seating, no channel, ≈ 4 × the L1 flow (≈ 1.8 m³/s at the summer-evening mean wind, assumed); a filtered supply fan in place of the HRV; the core the fourth support of the west projection. The MEP and structural engineers size it (open items 9, 22).]),
  ("E-02", "major", "Services · ventilation and dust", "partly", "V10.0", [No HRV (owner): a 750 m³/h filtered supply fan (a washable pre-filter + ISO ePM1 ≥ 50 %, a silencer) in the malqaf's foot chamber, the house at a slight positive pressure; two wall switches and one dust-sensor relay, spring-return dampers; the hood's make-up inlet mandatory (assumed). *Open:* the MEP design.]),
  ("E-03", "major", "Services · plumbing", "partly", "V8.3 / V9.0", [The owner's decisions (an external east stack, trap primers, rain / sewage separate, the condensate by tundishes); bedroom 2's en-suite and the family WC on one service wall; the powder room; V9.0: the septic serves both houses, a chamber at every bend, the inlet −1.24 on the computed falls. *Open:* the suite bath's drainage approach, the water system (tankers, tanks, roof tank, pumps, greywater), the plumbing engineer.]),
  ("E-04", "major", "Services · solar PV provision", "resolved", "V8.1 / V8.2", [PV zones inside the guarded roof zones; the conduits down the west shaft to the inverter and batteries in the utility room (the electrical engineer confirms).]),
  ("E-05", "major", "Services · generator and essentials circuit", "resolved", "V8.2 (owner)", [No generator: the backup from the PV and the batteries when installed; an essentials circuit at the main panel.]),
  ("E-06", "major", "Services · security and the safe room", "resolved", "V8.1 / V8.2", [No safe room (owner); one site entry, the farm's 4 m main gate; an intercom and seven cameras, the alarm panel in the utility room.]),
  ("E-07", "major", "Services · acoustics of the living", "open", "", [The double-height living's finishes and absorption at the details round.]),
  ("S-01", "major", "Site · parking", "partly", "V9.1 (owner)", [The family's *existing covered parking for two cars is south of the old house, west of the driveway* (owner, 5 Nov 2026; approximate, to be measured); one uncovered family car in the north strip, kept: *V9.1, the swept path of a large SUV (5.0 × 2.0 m, 11.8 m turning circle) fits in one forward move from the gate into the bay* (0.69 m to the house, 0.55 m to the gate posts), the bay 1.68 m off the north wall. *Open:* where guests park (the brief's farm parking south of the build land is withdrawn).]),
  ("S-02", "major", "Site · guest approach", "resolved", "V8.2 / V9.1", [The guest path: a 1.2 m band of outdoor porcelain (V10.0: no stone) along the driveway's east edge from its south end to the guest entrance (13.2 m at V9.1, bollard lights), never entering the family areas; the old majlis guests go along the driveway to the old house.]),
  ("S-04", "major", "Site · garden access", "resolved", "V8.2 (owner)", [No garden door from the living / dining (owner): the garden is reached round the house.]),
  ("S-05", "major", "Site · east strip, service yard", "resolved", "V8.3", [The outdoor counter next to the service door, the grill and tannour apart, the screen, the gas cabinet ≥ 3 m from the grill, the bins; the workers along the farm's boundary wall.]),
  ("S-08", "major", "Site · tanks, septic, plant", "partly", "V9.1 (owner)", [The owner's answers placed: the *existing ground tank south of the old house, west of the driveway near peg R*, the reserved tank beside it (7.8 m from the house at V9.1), the pipe across the driveway to the utility room; the *septic outside the north wall near C1 serves the old house and takes the new house's drains* (the main 38.8 m at V9.1, the inlet −1.24); the two rain soakaways moved to stay ≥ 5 m from the walls (V9.1). *Open:* measure them on site (the tank's lid and fill point, the septic's position, inlet level, capacity and condition), the levels from the survey, the municipality's consent.]),
)
// ---------- the interim verification and validation review of V8.3 (3 Nov 2026): its critical and major findings ----------
#let vv = (
  ("V-01", "critical", "Site · the setback margin", "partly", "V9.1", [As S-03: B1 6.00 m from M1 (the car test) and the cut wall shortened again give *0.91 m from the deed setback line and 0.42 m from the wall as built* (field 2.30 m, a 2 cm tape cushion over the owner's 0.40 m target; 0.32 m at 2.20); B2 1.20 / 0.58 m. *Open:* the official survey; the office's answer on the setback line.]),
  ("V-02", "critical", "Structure · unverified, no soil report", "open", "", [Unchanged: every structural size assumed (X5, X21, the projection, the ribbed slabs), no soil report. *Next:* the engineers (item 6 below).]),
  ("V-03", "major", "FF · bedroom 1 without a shower", "resolved", "V9.0 (owner)", [*Bedroom 1 (next to the master suite) is the room for very young children*; they are bathed in the master suite's bathroom; no en-suite (option A kept; `studies/bedroom1_bath.typ` B / B4 and `studies/bedroom1_ensuite.typ` not adopted). The family WC upstairs stays WC + basin. The kids' room keeps the gallery's WC; a shower for it is revisited only if it becomes a bedroom.]),
  ("V-04", "major", "Services · no heating, no energy-code envelope", "open", "", [Unchanged: the heating strategy and the envelope specification (insulation, glazing U-values, the steel windows' thermal breaks) for the MEP engineer and the facades round.]),
  ("V-05", "major", "Services · water and power in a power cut", "open", "", [Unchanged: no roof tank in the water scheme yet. *Next:* the water system study (item 3 below: tankers, the ground tanks, a roof tank, pumps, greywater).]),
  ("V-06", "major", "Site · the septic and the long foul main", "partly", "V9.1 (owner)", [The owner confirmed the septic near C1 serves the old house and takes the new house's drains; the route recomputed with a chamber at every change of direction, the driveway crossed once at the gate, the main 38.8 m at V9.1, the inlet still −1.24 (≈ 0.84 m below the assumed ground at the gate). *Open:* the surveyed inlet level and the falls (the levels from the survey), the capacity for both houses, a pump if needed, the legal consent.]),
  ("V-07", "major", "Site · the north parking bay against the north facade", "partly", "V9.1", [The house moved 2.25 m south since V8.3 (B1 6.00 m from M1): the bay on the car's turning line, 1.68 m off the north wall (0.4 at V8.3); *the swept path drawn* (site plan page 2): one forward move, 0.69 m to the house, the 4 m gate now governs. *Open:* the bay still sits in front of the women's majlis north window; the facades round (R-37) decides a planted edge.]),
  ("V-08", "major", "East yard · the hood exhaust beside the outdoor counter; the bins at the maid's window", "open", "", [Not changed in V9.0: the hood outlet and the make-up inlet beside the counter's south end, the bins ≈ 1 m from the maid's escape window. *Next:* the MEP engineer (the outlet's position and height) and the facades round.]),
  ("V-09", "major", "Fire · one open stair in the riwaq", "partly", "V8.0 (owner)", [The owner's accepted residual risk (home-level strategy: early detection, interconnected alarms, escape windows). *Open:* the review's mitigations (a door between the kitchen and the dining, the clerestories' opener) at the details round.]),
  ("V-10", "major", "Suite bath over the kitchen · drainage approach; the utility room", "open", "", [Undecided (a: every drain in the depressed slab / b: the east service wall); the utility room still flagged small. *Next:* item 4 below.]),
)
#let all-rows = rows + vv
#let n(st) = all-rows.filter(r => r.at(3) == st).len()

#text(15pt, weight: "bold", fill: accent)[Review status after V10.0 · the malqaf (L5)]
#v(2pt)
#text(7.8pt, fill: gray)[Taif / Palm House · the design review of 30 Oct 2026 (`docs/review/design_review.typ` → `output/Design_Review_V6.pdf`, tag `review-1`, written against V6.2) and the interim verification and validation review of V8.3 (3 Nov 2026, `archive/VV_Review_V8.3.pdf`) · status on 9 Nov 2026 after *V10.0, the malqaf at L5*: the malqaf moved to the courtyard's north-west corner (an approved exception to the layout freeze), the HRV replaced by a filtered supply fan, the north-east corner restored, no stone anywhere (render and paint; porcelain floors); since V9.1: the final site position (B1 6.00 m from M1), the V9.3 L1 tower superseded. Nothing else of the two reviews' findings changed.]
#v(4pt)
#let tbl(r) = table(columns: (auto, auto, 1.15fr, auto, auto, 3.5fr), inset: 2.2pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
  ..([Id], [Sev.], [Where], [Status], [Version], [What was done · what is still open]).map(c => text(weight: "bold", fill: accent, c)),
  ..r.map(((id, sev, where, st, ver, body)) => (text(weight: "bold")[#id], text(fill: if sev == "critical" { red } else { amber })[#sev], [#where], S(st), [#ver], body)).flatten())
#text(10pt, weight: "bold", fill: accent)[1 · The design review (V6): #rows.len() critical and major findings]
#v(1pt)
#tbl(rows)
#v(4pt)
#text(10pt, weight: "bold", fill: accent)[2 · The interim V&V review (V8.3): #vv.len() critical and major findings]
#v(1pt)
#tbl(vv)
#v(5pt)
#text(10pt, weight: "bold", fill: accent)[3 · The next items, in this order]
#v(1pt)
#set enum(spacing: 2.6pt)
+ *The bathrooms and WCs interior study* (the suite bath's drainage approach a / b decided with it: V-10, E-03).
+ *The water system study:* the tankers, the ground tanks, a roof tank, the pumps, the greywater lines to the south garden with diversion chambers (V-05, E-03).
+ *The official survey and the engineering office's answer on the setback* (from the deed line or from the wall as built), with the levels: S-03, V-01.
+ *Measure the existing farm on site:* the old house and its annex (W1–W4, A1–A4), the covered parking (P1–P4), the tanks (K0–K2, the lid and the fill point) and the septic's inlet level (`docs/SITE_SETOUT.md` § 8): S-01, S-08, V-06.
+ *The engineers:* structure X5 (T-01, V-02), the soil report (T-03), the MEP sizing (G-03, E-01, E-02, V-04, V-08), the lift supplier.
+ *The facades and the details, acoustics included* (R-37, E-07, G-02, V-07, V-09).
+ *The full verification and validation review of the frozen layout.*
#v(3pt)
#text(6.9pt, fill: gray)[Minor findings, suggestions and strengths are unchanged in both reviews; of the minors, T-02 (X3) is resolved (V6.3), F-09 (the treadmill) in V8.0, Y-04 (courtyard dust and water) answered by the drainage section, *F-05 (bedroom 1's bath) is resolved in V9.0 by the owner's decision* (the young children's room, bathed in the suite). This page is a status update, not a new review. Nothing here is for construction: concept design, all sizes assumed until the engineers confirm.]

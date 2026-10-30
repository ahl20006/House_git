// review_status.typ · Taif / Palm House · the design review's status after V7.0 (compile THIS file → output/Design_Review_status_V7.pdf)
// The review itself (docs/review/design_review.typ → output/Design_Review_V6.pdf, tag review-1, written against V6.2) stays as it was.
// This page lists every CRITICAL and MAJOR finding with its status after V7.0 (resolved / partly / open), the version that resolved it and
// the next open items in the order to take them. The ids, places and severities are those of design_review.typ.
#set page(paper: "a4", margin: (x: 14mm, y: 14mm), numbering: "1 / 1", number-align: right)
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 8.2pt)
#let accent = rgb("#2f6b4f")
#let red = rgb("#b5452f")
#let amber = rgb("#b58a1f")
#let green = rgb("#2f7a3f")
#let S(st) = if st == "resolved" { text(fill: green, weight: "bold")[resolved] } else if st == "partly" { text(fill: amber, weight: "bold")[partly] } else { text(fill: red, weight: "bold")[open] }

// (id, severity, where, status, version, what was done / what is still open)
#let rows = (
  ("Y-01", "critical", "Courtyard · the envelope", "resolved", "V7.0", [Enclosure option A: W1 on the gallery edge (on the B3 upstand, +3.82 … +6.75), W2 on the family living's edge, W3 over the living's courtyard glass (+3.32 … +6.75), black steel divided lites; the projection 1.55 m, B3 / R11 / C21–C23 at x 5.80; the courtyard stays open to the sky (`studies/courtyard_enclosure.typ`).]),
  ("A-01", "critical", "Ageing · the lift", "resolved", "V6.3", [The lift is installed at construction, two stops, sliding landing doors; the shaft stays a placeholder until a supplier's drawing (open item 14, now with the headroom rule ≤ 3.40 m / ≤ 3.70 m with a raised head).]),
  ("S-03", "critical", "Site · north and lane setbacks", "partly", "V6.3", [The house moved 0.30 m south: 0.20 m to the lane setback line (was 0.05), 0.80 m to the north street line; provisional until the official survey (open item 1). *Open:* the survey, and the owner's choice if a larger margin is wanted (0.63 m south, or 0.30 south + 0.17 west).]),
  ("G-01", "major", "GF · living wall (west)", "resolved", "V6.3", [The living's west wall solid and full height with the 1.40 m entrance arch and the arched TV niche 4.40 × 0.70; sofa facing west, eye-to-screen 3.47 m; no arches between the colonnade columns.]),
  ("G-04", "major", "GF · maid room", "resolved", "V7.0", [The kitchen's north wall moved 0.50 m south to y 7.0 (a non-load-bearing partition; the y 6.5 beam B6 stays): maid room 7.28 m² clear, 2.49 m clear at the bed (≥ 6.5 m² / 2.1 m); laundry 6.2 m² clear; kitchen 24.0 m² clear with two runs; service door, counter and hood moved with the wall.]),
  ("F-01", "major", "FF · gallery width", "resolved", "V7.0", [The projection 1.55 m: the gallery 1.405 m clear at the window, 1.235 m at the three column sleeves (≥ 1.20).]),
  ("F-02", "major", "FF · door widths", "resolved", "V6.3", [Every bedroom and bathroom door a 1.00 m opening with a 0.90 m leaf (≥ 0.85 clear); exceptions recorded: the guest WC (0.90) and the maid bath (0.70).]),
  ("F-06", "major", "FF · family living", "resolved", "V7.0", [W2: the family living's courtyard edge glazed from the floor to +6.75 (two casements); the room is a conditioned room.]),
  ("F-07", "major", "FF / roof · roof access", "resolved", "V7.0", [The main stair continues to the roof (flights 3 / 4 in the same well, trimmers R16–R18, a stair room 2.20 m clear); the attic 1.8 m set back 1.0 m behind the main cornice; the roof zones reserved (`studies/roof.typ`).]),
  ("X-01", "major", "Circulation · serving the majlis", "open", "", [The food route from the east kitchen to the men's majlis still crosses the living (17.5 m, four doors). To decide: an outside service path to a majlis serving door, or accept.]),
  ("G-02", "major", "GF · living + dining", "partly", "V7.0", [The courtyard well is decided (open sky, glazed edges): the living keeps its courtyard light through W3 (× ≈ 0.64 for the glass) and the clerestories. *Open:* the daylight simulation (open item 15) and the garden door / larger east window (S-04).]),
  ("G-03", "major", "GF · kitchen", "open", "", [The hood's make-up air and the kitchen's exhaust in a positively pressurised house: the MEP engineer (open item 8). The hood now sits at y 10.2–11.2 on the east wall, the extract straight out.]),
  ("G-07", "major", "GF · bathrooms", "partly", "V6.3", [With the lift at construction the first-floor showers are reachable without stairs. *Open:* a ground-floor shower (the family WC has none).]),
  ("Y-02", "major", "Courtyard · size for daily use", "partly", "V7.0", [The sky opening is 3.15 × 6.5 m (was 3.35); the courtyard floor 4.5 × 6.3 m clear is unchanged. *Open:* the level play zone ≥ 3 × 3 m beside the sunken seating, the seating for 6–8, the hose point.]),
  ("Y-03", "major", "Courtyard · sunken seating safety", "open", "", [The 0.45 m pit with three open steps and no guard on three edges: to decide (guard, a shallower pit, or a level seating area) with the play zone and the drainage outfall.]),
  ("T-01", "major", "Structure · X5", "open", "", [R6 on two first-floor walls over the men's majlis ribs: the engineer verifies the load path or adds columns.]),
  ("T-03", "major", "Structure · soil and foundations", "open", "", [No soil report: pads, the lift pit, the tower pit and the duct are assumed.]),
  ("E-01", "major", "Services · the malqaf's value", "open", "", [With the house sealed round the courtyard the grille serves only the courtyard unless the casements are open; decide: a courtyard feature, the ERV's filtered intake, or drop it (open item 17); the pergola with it (open item 18).]),
  ("E-02", "major", "Services · ventilation and dust", "partly", "V7.0", [The envelope is now closable (Y-01) so a filtered, positively pressurised system makes sense; the roof plant zone (14.6 m²) and the ERV position are reserved. *Open:* the MEP design (open item 8).]),
  ("E-03", "major", "Services · plumbing", "open", "", [The plumbing study (open item 9) and the drainage outfall (where the roof, the courtyard and the suite court drain to) are still to do.]),
  ("E-04", "major", "Services · solar PV provision", "partly", "V7.0", [PV zones reserved on the roof: 24.5 m² on the south wing (y ≥ 22.0, clear of the clerestories' sun) and 20.5 m² on the north block; fixing points before waterproofing; the roof live load noted. *Open:* the inverter / battery room, the conduits, the structural allowance.]),
  ("E-05", "major", "Services · generator and essentials circuit", "open", "", [Generator position, changeover switch and the essentials circuit: the site and roof services plan.]),
  ("E-06", "major", "Services · security and the safe room", "open", "", [Cameras, alarm, intercoms and a safe room: the site plan round.]),
  ("E-07", "major", "Services · acoustics of the living", "open", "", [The double-height living's hard surfaces: finishes and absorption to decide at the detail round (the glazed W1 / W3 add hard surfaces).]),
  ("E-08", "major", "Services · fire and life safety", "open", "", [The single stair opens onto the riwaq and the gallery onto the living void; no alarms, no sprinklers; the maid's window sill 1.50 m. *Next, critical:* interconnected alarms, a smoke vent at the top of the void, the escape strategy, sprinklers to decide; the stair room door to the roof is now a second way out upwards.]),
  ("S-01", "major", "Site · parking", "open", "", [Two shaded spaces inside the plot with a covered walk to the family door: the site plan round.]),
  ("S-02", "major", "Site · guest approach", "open", "", [The guest path from the gate to the foyer: the site plan round.]),
  ("S-04", "major", "Site · garden access", "open", "", [A garden door from the living / dining and a larger east window: with the site plan.]),
  ("S-05", "major", "Site · east strip, service yard", "open", "", [Bins, gas, the service door's yard and the outdoor kitchen path: with the site plan.]),
  ("S-08", "major", "Site · tanks, septic, plant", "partly", "V7.0", [On the roof: the plant zone, the tank zone (3.3 m², if a gravity reserve is wanted) and the PV reserved. *Open:* the ground tank, septic, the generator and the inverter room on the site plan.]),
)
#let n(st) = rows.filter(r => r.at(3) == st).len()

#text(15pt, weight: "bold", fill: accent)[Design review · status after V7.0]
#v(2pt)
#text(8.5pt, fill: gray)[Taif / Palm House · the review of 30 Oct 2026 (`docs/review/design_review.typ` → `output/Design_Review_V6.pdf`, tag `review-1`, written against V6.2) · status on 31 Oct 2026 after V6.3 (quick fixes) and V7.0 (courtyard enclosure, maid room, roof access and attic, design language) · every critical and major finding: #rows.len() in all, #S("resolved") #n("resolved") · #S("partly") #n("partly") · #S("open") #n("open")]
#v(6pt)
#table(columns: (auto, auto, 1.1fr, auto, auto, 3.2fr), inset: 3pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
  ..([Id], [Sev.], [Where], [Status], [Version], [What was done · what is still open]).map(c => text(weight: "bold", fill: accent, c)),
  ..rows.map(((id, sev, where, st, ver, body)) => (text(weight: "bold")[#id], text(fill: if sev == "critical" { red } else { amber })[#sev], [#where], S(st), [#ver], body)).flatten())
#v(8pt)
#text(11pt, weight: "bold", fill: accent)[The next open items, in this order]
#v(2pt)
#set enum(spacing: 3pt)
+ *Fire and escape* (E-08, critical): interconnected alarms, a smoke vent at the top of the double-height void, the escape strategy from the first floor (the single stair opens onto the riwaq; the stair room door to the roof is a way out upwards), sprinklers to decide, the maid's window sill.
+ *Courtyard: the sunken seating, the level play zone and the drainage outfall* (Y-03, Y-02, Y-04, E-03): a guard or a shallower pit, a level play zone ≥ 3 × 3 m, the hose point, where the courtyard, the roof and the suite court drain to.
+ *The malqaf's value in the sealed house and the pergola* (E-01; open items 17 and 18): a feature only, the ERV's filtered intake, or drop it; the pergola kept, lightened or dropped.
+ *Gym: the treadmill clearances and vibration* (F-09, X6, X5): the arm's clearances and the majlis roof's vibration with the engineer; rubber floor over the whole gym.
+ *Bedroom 1's bathroom route* (F-05, open item 16): 6.9 m from the family bath; accept, or review in the detail round.
+ *The food route from the kitchen to the men's majlis* (X-01): an outside service path to a majlis serving door, or accept the route through the living.
+ *The site and roof services plan* (S-01 … S-08, E-04 … E-06): parking, the guest approach, the garden door, the service yard, the outdoor kitchen path, tanks, septic, generator, inverter room, security, the safe room; the roof zones of `studies/roof.typ` tie into it.
+ *Structure X5 and the soil report* (T-01, T-03, engineers): R6's load path, the pads, the pits.
+ *The legal survey* (S-03, open item 1): the setback margins (0.20 m to the lane, provisional) confirmed before the wall faces are fixed.
#v(6pt)
#text(7.5pt, fill: gray)[Minor findings, suggestions and strengths are unchanged in the review; of the minors, T-02 (X3) is resolved (V6.3) and A-02 (thresholds) is unchanged. Nothing here is for construction: concept design, all sizes assumed until the engineers confirm.]

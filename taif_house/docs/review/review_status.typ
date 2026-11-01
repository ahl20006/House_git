// review_status.typ · Taif / Palm House · the design review's status after V8.1 (compile THIS file → output/Design_Review_status_V8.1.pdf)
// The review itself (docs/review/design_review.typ → output/Design_Review_V6.pdf, tag review-1, written against V6.2) stays as it was.
// This page lists every CRITICAL and MAJOR finding with its status after V8.1 (resolved / partly / open), the version that resolved it and
// the next open items in the order to take them. The ids, places and severities are those of design_review.typ.
#set page(paper: "a4", margin: (x: 14mm, y: 14mm), numbering: "1 / 1", number-align: right)
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 7.9pt)
#let accent = rgb("#2f6b4f")
#let red = rgb("#b5452f")
#let amber = rgb("#b58a1f")
#let green = rgb("#2f7a3f")
#let S(st) = if st == "resolved" { text(fill: green, weight: "bold")[resolved] } else if st == "partly" { text(fill: amber, weight: "bold")[partly] } else { text(fill: red, weight: "bold")[open] }

// (id, severity, where, status, version, what was done / what is still open)
#let rows = (
  ("Y-01", "critical", "Courtyard · the envelope", "resolved", "V7.0 / V7.1", [Enclosure option A: W1 on the gallery edge, W2 on the family living's edge, W3 over the living's courtyard glass, black steel divided lites, the projection 1.55 m (B3 / R11 / C21–C23 at x 5.80); the courtyard open to the sky. V7.1: semicircular heads over the three-arch arcade.]),
  ("A-01", "critical", "Ageing · the lift", "resolved", "V6.3", [The lift installed at construction, two stops; the shaft a placeholder until a supplier's drawing (open item 15: headroom ≤ 3.40 m / ≤ 3.70 m with a raised head).]),
  ("S-03", "critical", "Site · north and lane setbacks", "partly", "V6.3", [The house 0.30 m south: 0.20 m to the lane setback line, 0.80 m to the north street line, provisional. *Open:* the legal survey (open item 1).]),
  ("E-08", "major", "Services · fire and life safety", "resolved", "V8.0 / V8.1", [Home-level strategy (owner): interconnected mains smoke alarms with battery back-up in every bedroom and on the routes, heat, CO and gas detectors, extinguishers and a blanket; escape casements without screens in every sleeping room (the maid room's at sill +1.10); thumb-turns on the exits (`studies/fire_escape.typ`). V8.1: the first floor's exits are the main stair plus the escape window of every sleeping room; the suite court is a fresh-air area, not an exit; the roof ladder is no escape device.]),
  ("G-01", "major", "GF · living wall (west)", "resolved", "V6.3", [The solid TV wall with the entrance arch and the arched TV niche.]),
  ("G-04", "major", "GF · maid room", "resolved", "V7.0", [The kitchen's north wall at y 7.0: maid room 7.28 m² clear, 2.49 m at the bed.]),
  ("F-01", "major", "FF · gallery width", "resolved", "V7.0", [The projection 1.55 m: the gallery 1.405 m clear, 1.235 m at the column sleeves.]),
  ("F-02", "major", "FF · door widths", "resolved", "V6.3", [Bedroom and bathroom doors 1.00 m openings; exceptions recorded.]),
  ("F-06", "major", "FF · family living", "resolved", "V7.0", [W2 on the courtyard edge: a conditioned room.]),
  ("F-07", "major", "FF / roof · roof access", "resolved", "V7.0 / V8.1", [V8.1: the roof by a manufactured maintenance ladder in a 0.90 × 0.30 recess of a stone pilaster on the gym's east wall in the suite court (3.70 m, the stiles 1.10 m above the roof, a self-closing gate in the court guard, a fall-arrest rail), behind a locked walnut panel (`studies/roof.typ` p. 2); the guarding continuous to every piece of equipment; the internal stair stops at the first floor, the roof slab closed over the well. *Open:* the fall protection confirmed by the specialist (open item 4).]),
  ("X-01", "major", "Circulation · serving the majlis", "open", "", [The food route from the kitchen to the men's majlis still crosses the dining and the riwaq (open item 19): an outside service path to a majlis serving door, or accept.]),
  ("G-02", "major", "GF · living + dining", "partly", "V7.0", [The courtyard well decided; V8.0: the clerestories get the winter noon sun on their whole height (the suite court open to the south facade). *Open:* the daylight simulation (open item 16) and the garden door (S-04).]),
  ("G-03", "major", "GF · kitchen", "partly", "V8.0", [The hood's make-up air: a filtered motorised inlet under the stone band on the east wall, interlocked with the hood (air v3.1). *Open:* the MEP sizing (open item 9).]),
  ("G-07", "major", "GF · bathrooms", "partly", "V6.3", [The first-floor showers reachable by the lift. *Open:* a ground-floor shower.]),
  ("Y-02", "major", "Courtyard · size for daily use", "resolved", "V8.0", [The courtyard layout (owner): the seating one step down with three benches for six to eight and a low table; the TV wall; children's play in the garden, not in the courtyard; a hose point at the enclosure (`studies/courtyard_layout.typ`).]),
  ("Y-03", "major", "Courtyard · sunken seating safety", "resolved", "V8.0", [The 0.45 m pit replaced by one 0.15 m step with a honey-stone nosing and a riser light; level strips ≥ 0.6 m at every glass line; the drain and an independent overflow (the drainage section).]),
  ("T-01", "major", "Structure · X5", "partly", "V8.0", [Load path revised, *improved, not verified*: R6 removed (the suite court open to the south facade); the gym's east wall on B19 between C19 and C20, the double wall on B8 and a new B22, the office wall non-load-bearing on rib B21. *Open:* the engineer confirms (open item 3).]),
  ("T-03", "major", "Structure · soil and foundations", "open", "", [No soil report (open item 7): the pads, the lift pit and the breeze channel are assumed.]),
  ("E-01", "major", "Services · the malqaf's value", "resolved", "V8.0", [Air system v3 / v3.1 (owner): one tower with two separate paths: a gentle courtyard breeze (a damper, a shallow channel in the slab, the grille under the TV, an assist fan) and the fresh-air intake of the HRV in the tower's base on the roof; no water, no pit, no entry (`studies/air_system.typ`). The MEP engineer sizes it (open item 9).]),
  ("E-02", "major", "Services · ventilation and dust", "partly", "V8.0", [A 750 m³/h class HRV with an ISO ePM1 ≥ 50 % filter, continuous + boost, a dust mode, the kitchen make-up air (all assumed). *Open:* the MEP design.]),
  ("E-03", "major", "Services · plumbing", "partly", "V8.0", [The courtyard's drainage section (pit drain, overflow, pipes east) and the suite court's drains (linear drains, box gutter, overflow) drawn. *Open:* the plumbing study (open item 10).]),
  ("E-04", "major", "Services · solar PV provision", "partly", "V8.1", [PV zones inside the guarded zones: 9.8 m² on the gym roof and the office roof (inside the set-back guardrail, outside the clerestories' south sector) and 20.5 m² on the north block. *Open:* the inverter / battery room, the conduits (the site and services plan); more PV area if wanted.]),
  ("E-05", "major", "Services · generator and essentials circuit", "open", "", [The generator point is only proposed (air study distances): the site and services plan (open item 20).]),
  ("E-06", "major", "Services · security and the safe room", "partly", "V8.1", [No safe room (owner, R-33); one site entry, the farm's 4 m main gate (no gate on the lane); office visitors met in the men's majlis, the first floor closed to them; the roof ladder behind a locked panel. *Open:* cameras, the alarm and intercoms with the site plan.]),
  ("E-07", "major", "Services · acoustics of the living", "open", "", [The double-height living's finishes and absorption at the detail round.]),
  ("S-01", "major", "Site · parking", "open", "", [The site and services plan (open item 20).]),
  ("S-02", "major", "Site · guest approach", "open", "", [The site and services plan.]),
  ("S-04", "major", "Site · garden access", "open", "", [A garden door from the living / dining: the site and services plan.]),
  ("S-05", "major", "Site · east strip, service yard", "partly", "V8.1", [The service yard screened (bins, gas); the outdoor counter and sink against the east wall on the service-door path, the grill and tannour apart in the garden (3.6 m from the house); no gate on the lane. *Open:* the full site plan.]),
  ("S-08", "major", "Site · tanks, septic, plant", "partly", "V8.0", [On the roof: the HRV in the malqaf's base, the AC units south of the tower, the tank zone, the PV. *Open:* the ground tank, septic, generator on the site plan.]),
)
#let n(st) = rows.filter(r => r.at(3) == st).len()

#text(15pt, weight: "bold", fill: accent)[Design review · status after V8.1]
#v(2pt)
#text(8.3pt, fill: gray)[Taif / Palm House · the review of 30 Oct 2026 (`docs/review/design_review.typ` → `output/Design_Review_V6.pdf`, tag `review-1`, written against V6.2) · status on 1 Nov 2026 after V6.3, V7.0, V7.1, V8.0 (fire safety, courtyard layout, air system, south wing v2) and V8.1 (a checkpoint: the roof ladder, the lowered roofline, the office from the suite court, one site entry); the rows updated in V8.1: E-08, F-07, T-03, E-04, E-06, S-05 · every critical and major finding: #rows.len() in all, #S("resolved") #n("resolved") · #S("partly") #n("partly") · #S("open") #n("open")]
#v(5pt)
#table(columns: (auto, auto, 1.1fr, auto, auto, 3.4fr), inset: 2.6pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
  ..([Id], [Sev.], [Where], [Status], [Version], [What was done · what is still open]).map(c => text(weight: "bold", fill: accent, c)),
  ..rows.map(((id, sev, where, st, ver, body)) => (text(weight: "bold")[#id], text(fill: if sev == "critical" { red } else { amber })[#sev], [#where], S(st), [#ver], body)).flatten())
#v(6pt)
#text(11pt, weight: "bold", fill: accent)[The next open items, in this order]
#v(2pt)
#set enum(spacing: 3pt)
+ *The internal layout round:* the stair flip (`studies/stair_flip.typ`: study done, the owner's decision pending); bedroom 1's bathroom route (F-05, open item 17); a ground-floor shower (G-07); the food route from the kitchen to the men's majlis (X-01, open item 19).
+ *The suite court's south side and the clerestory glazing* (open items 18, 14).
+ *The site and services plan* (S-01 … S-08, E-04 … E-06; open item 20): parking, the guest approach, the garden door, the service yard, water tanks, septic, gas, the generator, the PV conduits, security, Civil Defense access.
+ *The engineers:* structure X5 and the soil report (T-01, T-03; open items 3, 4, 7); MEP sizing of the air system, the HRV and the plumbing (E-01 … E-03; open items 9, 10).
+ *The legal survey* (S-03, open item 1).
+ *The living's acoustics and the facades* at the detail stage (E-07).
#v(3pt)
#text(8pt, weight: "bold", fill: accent)[The full verification and validation review is planned for V9.0, after the internal layout round.] This page is a status update, not a new review.
#v(5pt)
#text(7.3pt, fill: gray)[Minor findings, suggestions and strengths are unchanged in the review; of the minors, T-02 (X3) is resolved (V6.3), F-09 (the gym's treadmill clearance) is resolved in V8.0 (the manufacturer-type zone on the west band, vibration with the engineer), Y-04 (courtyard dust and water) is answered by the drainage section and the hose point, F-05 (bedroom 1's bath) is the first next item. Nothing here is for construction: concept design, all sizes assumed until the engineers confirm.]

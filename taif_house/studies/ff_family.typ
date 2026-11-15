// ff_family.typ · Taif / Palm House · FIRST FLOOR · focus study of the FAMILY PART (the whole floor except the master suite) · compile THIS file
// First floor V6.3, part 1 of 2 (part 2: studies/ff_suite.typ) · stand-alone: all data is in this file.
// 14 Nov 2026 (owner): the east wing's M3 adopted with adjustments (studies/east_wing_ff.typ page 7): bedroom 1 keeps its shape but for the corner x 11.5–13.311 × y 5.6–6.5, which with the suite's old WC closet
// becomes bedroom 1's own compact bath (x 11.5–13.311 × y 5.6–8.0, over the laundry and the kitchen's north band, its shower over the east stack); bedroom 1's door on the link's east wall at a right angle to the suite door; two built-in wardrobes.
// 15 Nov 2026 (owner): the WEST BAND re-planned (studies/west_wing_ff.typ, commit 4ec6911, adopted as drawn): bedrooms 2 and 3 as TWINS, each entered through an entry strip (2.55 clear wide) with a wall straight ahead:
// bedroom 2's beside the shaft (x 1.5–4.25 × y 9.2–10.4, its door on the gallery facing the shaft), bedroom 3's taken from the gym (x 1.5–4.25 × y 19.25–20.55, its door on x 4.25 from the gallery's end, a 2.55 opening on y 19.25, no leaf);
// the X3 bath pair between the rooms at y 14.125–15.525 (bath 2 west with a high window, bath 3 east with a fan, the wet wall x 2.10, both WCs at its south end, ONE stack at (2.10, 15.23) into the GF powder room's WC compartment);
// the main rooms equal (4.03 × 3.53 / 3.52 clear = 14.44 m²); the gallery extended over the old nib (x 4.25–5.8 × y 19.25–20.55) with a glass door 1.10 onto the court; the gym's pocket x 0–1.5 × y 19.25–20.55 (studies/ff_suite.typ).
// Local coordinates (metres, origin = the zone's NW corner, x east, y SOUTH) = the main first-floor CSV coordinates: no conversion.
// The room list is also in data/rooms_ff.csv (whole-floor plan: design_ff.typ, which checks that both agree).
#import "@preview/cetz:0.4.2"
#set page(paper: "a4", flipped: true, margin: 10mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 7.2pt)

#let rect-pts(x0, y0, x1, y1) = ((x0, y0), (x1, y0), (x1, y1), (x0, y1))

// ---------- The focus zone (wall centre lines): everything but the courtyard / double-height void and the master suite; with the west projection (x 4.25–5.8, y 6.5–19.25; V6.4: 1.55 m, courtyard enclosure option A) on an edge beam and three columns ----------
#let zone = ((0, 0), (10.461, 0), (13.311, 5.245), (13.311, 8.0), (11.5, 8.0), (11.5, 6.5), (8.95, 6.5), (5.8, 6.5), (5.8, 20.55), (1.5, 20.55), (1.5, 19.25), (0, 19.25))   // 15 Nov 2026: the zone takes bedroom 3's entry strip and the gallery's end (x 1.5–5.8, y 19.25–20.55) from the gym and the old nib   // 14 Nov 2026: the zone takes bedroom 1's bath (x 11.5–13.311, y 6.5–8.0) from the suite
#let plan-scale = 0.6cm
#let proj-x = 5.8   // the projection's outer edge (edge beam B3, with the steel window W1 on its upstand): 1.55 m beyond the courtyard wall line x 4.25 (V6.4, enclosure option A)
// the edge beam (x 5.8) on three columns, each in an existing wall / glass line (ground floor): the women's majlis south wall, the courtyard / living glass, the living's south wall
#let columns = ((5.8, 6.5), (5.8, 13.0), (5.8, 19.25))

// ---------- Fixed inside the zone (rising from the ground floor) ----------
#let fixed = (
  (name: "Stair (arrives at its north end · flipped)", pts: rect-pts(0, 2.2, 2.75, 7.9)),   // stair flip, option B (owner, 2 Nov 2026): the arrival strip y 2.3–3.75 opens onto the gallery beside the lift door
  (name: "Lift shaft", pts: rect-pts(0, 0, 2.25, 2.2)),
  (name: "West shaft", pts: rect-pts(0, 9.2, 1.5, 10.4)),
  (name: "Air tower", pts: ((4.25, 6.5), (5.8, 6.5), (5.8, 7.5), (4.25, 7.5))),   // 14 Nov 2026: the malqaf shaft ≈ 1.35 × 0.8 clear, its west wall on x 4.25 directly over the GF chamber's west wall (design_gf.typ tower-csv, 11 Nov 2026), in line with the family living's west wall: one RC core, the same footprint from the pad to the head, no jog   // V10.0 (L5): the malqaf shaft at the gallery's north end, the head above the roof; the gallery's turn past bedroom 2's bath 1.5 m   // V9.3: the slim shaft along the cut wall (studies/air_system.typ); its polygon is not a box, so it takes no part in the box-overlap test (the rooms round it tile the zone)
)

// ---------- Neighbours (grey: the courtyard / void and the L, studies/ff_suite.typ) ----------
#let neighbours = (
  ("Courtyard sky (void)", rect-pts(5.8, 6.5, 8.95, 13.0)),
  ("Double-height living (void)", rect-pts(5.8, 13.0, 8.95, 19.25)),
  ("Suite lobby", rect-pts(8.95, 6.5, 10.3, 11.9)),
  ("Suite WC (closet)", rect-pts(10.3, 6.5, 11.5, 8.0)),
  ("Suite bath", rect-pts(10.3, 8.0, 13.311, 10.45)),
  ("Suite dressing", rect-pts(10.3, 10.45, 13.311, 13.9)),
  ("Suite bedroom", ((8.95, 11.9), (10.3, 11.9), (10.3, 13.9), (13.311, 13.9), (13.311, 19.25), (8.95, 19.25))),
  ("Suite court (open, v2)", ((4.25, 20.55), (5.8, 20.55), (5.8, 19.25), (10.0, 19.25), (10.0, 24.0), (4.25, 24.0))),
  ("Gym (west band, v2)", ((0, 19.25), (1.5, 19.25), (1.5, 20.55), (4.25, 20.55), (4.25, 24.0), (0, 24.0))),   // 15 Nov 2026: with its pocket x 0–1.5 (the dumbbell rack) west of bedroom 3's entry strip
  ("Owner's office (east)", rect-pts(10.0, 19.25, 13.311, 24.0)),
)
#let neighbour-doors = (((9.05, 11.9), (9.95, 11.9), [suite bedroom]), ((10.3, 8.8), (10.3, 9.6), [suite bath]), ((10.5, 8.0), (11.2, 8.0), [suite WC closet (glass, into the bath)]))
// ground floor below (dotted): the full courtyard and living floors stay; the women's majlis; the wet rooms under the west band; the men's majlis
#let below = (
  ([GF courtyard (full floor)], rect-pts(4.25, 6.5, 8.95, 13.0)),
  ([GF living (full floor)], rect-pts(4.25, 13.0, 8.95, 19.25)),
  ([GF women's majlis], rect-pts(4.25, 0, 8.95, 6.5)),
  ([GF family powder room], rect-pts(0, 12.9, 2.75, 16.1)),
  ([GF powder room's WC compartment (the bedroom baths' stack)], rect-pts(0, 14.55, 2.75, 16.1)),
  ([GF guest WC], rect-pts(1.25, 17.5, 2.75, 19.25)),
  ([GF men's majlis], rect-pts(2.75, 19.25, 13.311, 24.0)),
)

// ---------- Interfaces with the master suite study (fixed) ----------
#let interfaces = (
  (pts: ((8.95, 6.5), (10.15, 6.5)), label: [① suite door: family link → suite lobby], kind: "door", at: (8.85, 7.6), anchor: "east"),
  (pts: ((10.15, 6.5), (11.5, 6.5)), label: [② bedroom 1 / the suite's WC closet: the y 6.5 line (acoustic wall); the kids' bath east of it to y 8.0], kind: "line", at: (13.45, 6.5), anchor: "west"),
  (pts: ((4.4, 20.55), (5.5, 20.55)), label: [③ the gallery's end (y 20.55, over the old nib): a glass door 1.10 onto the suite court; the gym's door beside it on x 4.25 (15 Nov 2026)], kind: "door", at: (5.95, 20.9), anchor: "west"),
  (pts: ((0, 19.25), (1.5, 19.25), (1.5, 20.55), (4.25, 20.55)), label: [④ bedroom 3 / the gym: the DOUBLE wall (Rw ≈ 55 dB) on B22 for x 0–1.5; then the entry strip's light walls x 1.5 and y 20.55 (15 Nov 2026)], kind: "line", at: (0.1, 20.9), anchor: "west"),
)

// ---------- Ground-floor wall lines in this zone ----------
#let gf-lines = [x 0, 1.25 (guest WC), 1.5 (shaft), 2.25, 2.75, 4.25, 8.95 · y 2.2, 7.9, 10.4, 12.9, 14.4, 14.55 (the powder room's WC compartment partition), 16.1, 17.5, 19.25, 21.4 (foyer) (west band); the women's majlis (x 4.25–8.95, y 0–6.5) and the men's majlis (x 2.75–13.311, y 19.25–24) have no inner wall; east part (bedroom 1, family link): over the GF maid wing, laundry and the kitchen's north wall]

// ---------- Rooms ----------
#let R(name, pts, col, parts: none) = (name: name, pts: pts, col: col, parts: if parts == none { (pts,) } else { parts })
#let rooms = (
  R("Gallery (north part + on the projection)", ((2.25, 0.7), (4.25, 0.7), (4.25, 3.0), (4.25, 6.5), (4.25, 7.5), (5.8, 7.5), (5.8, 20.55), (4.25, 20.55), (4.25, 9.2), (2.75, 9.2), (2.75, 7.9), (2.75, 2.2), (2.25, 2.2)), "circ",
    parts: (rect-pts(2.25, 0.7, 2.75, 2.2), rect-pts(2.75, 0.7, 4.25, 9.2), rect-pts(4.25, 7.5, 5.8, 20.55))),   // 15 Nov 2026: extended south over the old nib footprint to y 20.55 (the glass door onto the court at its end; bedroom 3's door on its west wall)   // 14 Nov 2026: the shaft's west wall on x 4.25 (the 0.15 m jog of V10.0 removed)
  R("Linen cupboard", rect-pts(2.25, 0, 4.25, 0.7), "store"),
  R("Family WC (gallery)", rect-pts(0, 7.9, 2.75, 9.2), "wet"),   // 14 Nov 2026 (owner): like the GF powder room: a basin zone open to the gallery (no door) east of a 100 mm partition on x 1.5 (the shaft's east face line continued), a WC-only compartment west of it behind a 0.70 door   // 3 Nov 2026: the F-b bath split: the family WC on the strip by the shaft
  R("Bedroom 2", ((1.5, 9.2), (4.25, 9.2), (4.25, 14.125), (0, 14.125), (0, 10.4), (1.5, 10.4)), "family",   // 15 Nov 2026 (twins): entered through its entry strip beside the shaft (x 1.5–4.25 × y 9.2–10.4, 2.55 × 1.10 clear; its 0.90 door on the gallery facing the shaft's wall); the main room 4.03 × 3.53 clear = 14.44 m²; no store
    parts: (rect-pts(1.5, 9.2, 4.25, 10.4), rect-pts(0, 10.4, 4.25, 14.125))),
  R("Bedroom 2 bath (en-suite)", rect-pts(0, 14.125, 2.1, 15.525), "wet"),   // 15 Nov 2026 (X3): the west half of the bath pair between the two bedrooms, 2.1 × 1.4 on axes; a small high window above the shower; its door from bedroom 2
  R("Bedroom 3 bath (en-suite)", rect-pts(2.1, 14.125, 4.25, 15.525), "wet"),   // 15 Nov 2026 (X3): the east half, 2.15 × 1.4 on axes, by the gallery (a fan); its door from bedroom 3; the wet wall x 2.10 shared, both WCs at its south end over the one stack
  R("Bedroom 3", ((0, 15.525), (4.25, 15.525), (4.25, 20.55), (1.5, 20.55), (1.5, 19.25), (0, 19.25)), "family",   // 15 Nov 2026 (twins): a full clean rectangle to y 19.25 (4.03 × 3.52 clear = 14.44 m²) + its entry strip taken from the gym (x 1.5–4.25 × y 19.25–20.55, 2.55 × 1.20 clear; its 0.90 door on x 4.25 from the gallery's end; a 2.55 opening, no leaf, on y 19.25)
    parts: (rect-pts(0, 15.525, 4.25, 19.25), rect-pts(1.5, 19.25, 4.25, 20.55))),
  R("Kids' room (study + gaming)", rect-pts(4.25, 0, 8.95, 3.0), "kids"),
  R("Family living", rect-pts(4.25, 3.0, 8.95, 6.5), "family"),
  R("Family link", rect-pts(8.95, 5.3, 10.15, 6.5), "circ"),
  R("Bedroom 1", ((8.95, 0), (10.461, 0), (13.311, 5.245), (13.311, 5.6), (11.5, 5.6), (11.5, 6.5), (10.15, 6.5), (10.15, 5.3), (8.95, 5.3)), "family",
    parts: (((8.95, 0), (13.311, 0), (13.311, 5.3), (8.95, 5.3)), rect-pts(10.15, 5.3, 11.5, 6.5), rect-pts(11.5, 5.3, 13.311, 5.6))),   // 14 Nov 2026 (M3 adopted): the entry strip's east corner is the bath
  R("Bedroom 1 bath", rect-pts(11.5, 5.6, 13.311, 8.0), "wet"),   // 14 Nov 2026: the compact en-suite (WC, basin, a wall-mixer shower over a floor drain), half from the entry strip, half from the suite's old WC closet; its door from inside bedroom 1   // V10.0: the malqaf at L5 frees the cut tip: bedroom 1 takes it (its north wall the facade); no slanted inner wall   // V9.3: one straight wall parallel to the cut (the shaft) and its square return
)
#let seating = rooms.find(r => r.name.starts-with("Family living"))
#let room(n) = { let e = rooms.find(r => r.name == n); if e != none { e } else { rooms.find(r => r.name.starts-with(n)) } }

// ---------- Doors and openings: a, b, label, room it serves, into = unit vector into that room, from = room it is reached from ("circ" = any circulation), open = no leaf ----------
#let D(a, b, label, room, into, from: "circ", open: false) = (a: a, b: b, label: label, room: room, into: into, from: from, open: open)
#let doors = (
  D((2.25, 0.9), (2.25, 1.9), [lift (sliding)], "Lift shaft", (-1, 0), open: true),
  D((2.45, 0.7), (4.05, 0.7), [linen], "Linen cupboard", (0, -1), open: true),
  D((4.25, 1.9), (4.25, 2.9), [kids' room], "Kids' room (study + gaming)", (1, 0)),
  D((4.25, 3.1), (4.25, 4.5), [living, open to the gallery], "Family living", (1, 0), open: true),
  D((2.75, 8.2), (2.75, 9.1), [family WC: an open passage 0.90, no door], "Family WC (gallery)", (-1, 0), open: true),   // 14 Nov 2026 (owner): the basin zone open to the gallery
  D((1.5, 8.4), (1.5, 9.1), [WC compartment 0.70, hinged on its south jamb, opens OUT into the basin zone], "Family WC (gallery)", (1, 0), from: "Family WC (gallery)"),   // 14 Nov 2026: the leaf folds back against the south wall (y 9.2), clear of the basin (checked)
  D((4.25, 9.35), (4.25, 10.25), [bed 2 (0.90, from the gallery into its entry strip, facing the shaft's wall)], "Bedroom 2", (-1, 0)),   // 15 Nov 2026 (twins)
  D((1.2, 14.125), (1.9, 14.125), [bath 2 (en-suite, 0.70, opening into the bath)], "Bedroom 2 bath (en-suite)", (0, 1), from: "Bedroom 2"),   // 15 Nov 2026 (X3)
  D((4.25, 19.4), (4.25, 20.3), [bed 3 (0.90, from the gallery's end into its entry strip, facing the strip's west wall)], "Bedroom 3", (-1, 0)),   // 15 Nov 2026 (twins)
  D((1.6, 19.25), (4.15, 19.25), [bedroom 3's strip → its room: an opening 2.55, no leaf (over the beams B22 + B8)], "Bedroom 3", (0, -1), from: "Bedroom 3", open: true),   // 15 Nov 2026
  D((3.0, 15.525), (3.7, 15.525), [bath 3 (en-suite, 0.70, opening into the bath)], "Bedroom 3 bath (en-suite)", (0, -1), from: "Bedroom 3"),   // 15 Nov 2026 (X3)
  D((4.4, 20.55), (5.5, 20.55), [the gallery's end: a glass door 1.10 onto the suite court (hinged, opening into the court)], "Suite court (open, v2)", (0, 1)),   // 15 Nov 2026: the old nib's sliding door and court door removed
  D((10.15, 5.4), (10.15, 6.4), [bed 1 (on the link's east wall, a right angle to the suite door)], "Bedroom 1", (1, 0)),   // 14 Nov 2026 (owner): not facing the suite door
  D((11.5, 5.7), (11.5, 6.4), [bath 1 (en-suite, 0.70)], "Bedroom 1 bath", (1, 0), from: "Bedroom 1"),   // 14 Nov 2026: on the bath's west wall from the entry strip (the 0.9 m of that wall facing bedroom 1 allows 0.70)
)

// ---------- Furniture and fixtures (x0, y0, x1, y1, label) ----------
#let furniture = (
  // kids' room: three desks under the north window, gaming corner on the east wall
  (5.15, 0.125, 6.35, 0.725, [study desk]), (6.35, 0.125, 7.55, 0.725, [study desk]), (7.65, 0.125, 8.85, 0.725, [PC desk]),
  (5.5, 0.85, 6.0, 1.35, []), (6.7, 0.85, 7.2, 1.35, []), (8.0, 0.85, 8.5, 1.35, []),
  (6.4, 1.55, 7.15, 2.85, [2-seat sofa / bean bags]), (8.45, 1.6, 8.85, 2.8, [TV ≤ 50"]),
  // family living on the courtyard edge: TV on the west wall, a sofa facing it (courtyard on its left), a loveseat facing the courtyard
  (4.35, 4.6, 4.75, 6.1, [TV wall]), (6.6, 4.3, 7.45, 6.3, [sofa · faces TV]), (5.4, 4.15, 6.4, 4.95, [loveseat · faces courtyard]), (5.25, 5.35, 6.25, 6.05, [table]),
  // family WC (14 Nov 2026, owner: as the GF powder room): the 100 mm partition on x 1.5 (y 7.9–9.2, the shaft's east face line continued) with the compartment's 0.70 door; the wall-hung WC on the WEST outer wall facing east (the concealed cistern frame in that wall, ≈ 0.7 m clear in front); ONE basin with its mirror on the NORTH wall (y 7.9, the stair wall) of the basin zone; the south wall plain; an exhaust fan from the compartment to the west shaft
  (0.125, 8.3, 0.725, 8.8, [WC · wall-hung]), (1.85, 8.0, 2.4, 8.4, [basin · mirror]), (1.45, 7.9, 1.55, 8.4, [partition 100]), (1.45, 9.1, 1.55, 9.2, []),
  // bedroom 2 (15 Nov 2026, twins): the bed's head on the west wall under its window, the desk at the second west window, the 1.8 m wardrobe on the bath wall east of the bath door; the entry strip (x 1.5–4.25 × y 9.2–10.4) kept free
  (0.125, 10.55, 2.125, 11.95, [bed 1.4 × 2.0]), (0.125, 12.0, 0.525, 12.4, []), (2.15, 10.55, 2.55, 10.95, []),
  (0.125, 13.125, 0.725, 14.025, [desk 0.9 × 0.6]), (0.8, 13.275, 1.25, 13.725, []), (2.0, 13.425, 3.8, 14.025, [wardrobe 1.8 × 0.6]),
  // the X3 bath pair (15 Nov 2026): bath 2 west (the shower NW under the high window, the basin SW, the wall-hung WC on the wet wall), bath 3 east (the shower NW, the WC on the wet wall, the basin by the gallery wall); both WCs on the wet wall x 2.10 over the one stack at (2.10, 15.23)
  (0.125, 14.225, 0.925, 15.025, [shower 0.8 × 0.8 · screen]), (0.125, 15.025, 0.475, 15.425, [basin]), (1.4, 15.025, 2.0, 15.425, [WC · wall-hung]),
  (2.2, 14.225, 3.0, 15.025, [shower 0.8 × 0.8 · screen]), (2.2, 15.025, 2.8, 15.425, [WC · wall-hung]), (3.8, 14.425, 4.15, 14.825, [basin]),
  // bedroom 3 (15 Nov 2026, twins): the bed's head on the west wall under its window, the desk at the second west window (the south-west corner), the 1.8 m wardrobe on the gallery wall; the entry strip (x 1.5–4.25 × y 19.25–20.55) kept free
  (0.125, 16.125, 2.125, 17.525, [bed 1.4 × 2.0]), (0.125, 15.675, 0.525, 16.075, []), (0.125, 17.575, 0.525, 17.975, []),
  (0.125, 18.05, 0.725, 19.15, [desk 1.1 × 0.6]), (0.8, 18.35, 1.25, 18.8, []), (3.55, 16.625, 4.15, 18.425, [wardrobe 1.8 × 0.6]),
  // bedroom 1 (14 Nov 2026, M3 adopted): the bed on the north wall, the desk under the cut window, two BUILT-IN wardrobes (10 cm block sides, a lintel, sliding doors, 0.60 deep): W1 against the bath's north wall under the cut, W2 on the west wall
  (9.05, 0.35, 10.45, 2.35, [bed 1.4 × 2.0]), (10.5, 1.95, 10.9, 2.35, []), (10.9, 3.9, 12.0, 4.5, [desk]), (11.2, 3.35, 11.65, 3.8, []),   // V10.0: the bed's head on the north wall   // V9.3: the bed's head on the west wall, clear of the shaft
  (11.6, 4.9, 12.95, 5.5, [built-in wardrobe W1 · 1.15 × 0.60 clear · sliding]), (9.05, 2.6, 9.65, 5.2, [built-in wardrobe W2 · 2.40 × 0.60 clear · sliding]),
  // bedroom 1's bath (14 Nov 2026): the basin by the door on the west wall, the wall-hung WC on the east wall, the wall-mixer shower zone at the south end over the east stack (no tray, a floor drain, a glass panel if wanted)
  (11.6, 6.5, 12.05, 7.1, [basin]), (12.6, 6.0, 13.186, 6.4, [WC]), (11.6, 7.1, 13.186, 7.9, [shower 1.6 × 0.8 · mixer on the south wall · floor drain]),
)
// fire safety (owner, 1 Nov 2026; studies/fire_escape.typ): the escape windows of the sleeping rooms: hinged casements opening fully from inside, no grille, bar or fixed mashrabiya
#let escape-windows = (("Bedroom 1", (11.33, 1.6), (12.2, 3.2)), ("Bedroom 2", (0, 10.7), (0, 11.8)), ("Bedroom 3", (0, 16.225), (0, 17.425)), ("Kids' room (a bedroom later)", (5.3, 0), (8.7, 0)))
#let windows = (((5.3, 0), (8.7, 0)), ((0, 8.3), (0, 8.8)), ((0, 10.7), (0, 11.8)), ((0, 13.125), (0, 13.925)), ((0, 14.275), (0, 14.975)), ((0, 16.225), (0, 17.425)), ((0, 18.0), (0, 18.9)),   // 15 Nov 2026 (provisional marks; the owner sets the windows with the facades): bedroom 2's two west windows (the bed's, the desk's), bath 2's small high window above its shower (sill ≥ +1.70, obscure), bedroom 3's two (the bed's, the desk's)   // 14 Nov 2026: the family WC compartment's small high window in the west outer wall above the WC (≈ 0.5 × 0.4, sill ≥ +1.70, obscure glass) ((11.33, 1.6), (12.2, 3.2)), ((12.442, 3.645), (13.039, 4.745)), ((9.2, 0), (10.2, 0)), ((13.311, 6.5), (13.311, 6.95)),   // V10.0: bedroom 1's north window in the freed tip; 14 Nov 2026: bedroom 1's bath, a PROVISIONAL east window (or a fan): the owner sets the windows with the facades
  ((5.8, 8.95), (5.8, 10.55)), ((5.8, 11.117), (5.8, 12.717)), ((5.8, 13.242), (5.8, 14.842)), ((5.8, 15.325), (5.8, 16.925)), ((5.8, 17.408), (5.8, 19.008)),   // V7.1: W1 as six arched windows 1.60 wide on the gallery edge (three per column bay, over the arcade bays), sill +3.82, springing +5.80, crown +6.60; V10.0: W1-1 (y 6.783–8.383) replaced by a BLIND arched recess beside the malqaf shaft (studies/malqaf_L5.typ Phase 3, F3)
  ((6, 6.5), (7.3, 6.5)), ((7.55, 6.5), (8.85, 6.5)))   // V7.1: W2 as two arched windows 1.30 wide on the family living's courtyard edge (east of C21), floor to the crown +6.60
#let drains = (
  (((0.5, 8.55), (0.5, 9.2), (0.6, 9.5)), [family WC (14 Nov 2026): the wall-hung pan's waste in the floor build-up ≈ 0.5 m south to the west shaft; the basin's waste in the floor build-up / a chase in the partition to the shaft]),
  (((2.1, 8.4), (1.5, 8.6), (1.5, 9.2), (1.3, 9.5)), []),
  (((1.7, 15.2), (2.1, 15.225)), [the X3 pair (15 Nov 2026): both wall-hung WCs on the wet wall x 2.10 into the ONE stack at (2.10, 15.23), straight down into the GF powder room's WC compartment (y 14.55–16.1) and on to the buried west run; the showers and basins in the floor build-up to it, ≤ 2 m]),
  (((2.5, 15.2), (2.1, 15.225)), []),
  (((0.5, 14.6), (1.2, 15.1), (2.1, 15.225)), []),
  (((0.3, 15.2), (1.0, 15.45), (2.1, 15.225)), []),
  (((2.6, 14.6), (2.1, 15.225)), []),
  (((3.95, 14.6), (3.4, 15.3), (2.1, 15.225)), []),
  (((12.9, 7.6), (13.311, 7.1)), [bedroom 1's bath (14 Nov 2026): the shower's floor drain, the WC and the basin to the east stack outside the east wall (y 7.05), ≤ 2 m each]),
  (((12.9, 6.2), (13.311, 7.1)), []),
  (((12.0, 6.8), (12.9, 7.3), (13.311, 7.1)), []),
)

// ---------- Walking routes: (name, rect, wall allowance across it, what is deducted) ----------
#let routes = (
  ("Gallery north (beside the stair)", rect-pts(2.75, 0.7, 4.25, 9.2), 0.2, [½ wall each side]),
  ("Gallery on the projection", rect-pts(4.25, 6.5, 5.8, 20.55), 0.125, [½ wall (rooms side) + ½ window frame W1 on the B3 upstand (void side)]),
  ("Walk behind the sofa (in the living)", rect-pts(4.25, 3.0, 8.95, 4.1), 0.1, [½ wall on the kids' room side; the sofa side is open]),
  ("Walk beside the sofa to the family link", rect-pts(7.85, 4.1, 8.95, 6.5), 0.1, [½ wall on the bedroom 1 side; the sofa side is open]),
  ("Family link", rect-pts(8.95, 5.3, 10.15, 6.5), 0.2, [½ wall each side (bedroom 1 to the north and east)]),
)
// walking paths for distances (polylines)
#let paths = (
  // the stair top (flipped, option B): the arrival strip's opening onto the gallery's north part, x 2.75, y 2.3–3.75
  ("Stair top → kids' room door", ((2.9, 3.05), (3.5, 3.05), (3.5, 2.4), (4.25, 2.4))),
  ("Stair top → family living (opening)", ((2.9, 3.05), (3.5, 3.05), (3.5, 3.55), (4.8, 3.55), (4.8, 4.1))),
  ("Stair top → bedroom 1 door", ((2.9, 3.05), (3.5, 3.05), (3.5, 3.55), (8.4, 3.55), (8.4, 5.9), (10.15, 5.9))),
  ("Stair top → ① suite door", ((2.9, 3.05), (3.5, 3.05), (3.5, 3.55), (8.4, 3.55), (8.4, 5.9), (9.55, 5.9), (9.55, 6.5))),
  ("Stair top → family WC door", ((2.9, 3.05), (3.5, 3.05), (3.5, 8.65), (2.75, 8.65))),
  ("Stair top → bedroom 2 door", ((2.9, 3.05), (3.5, 3.05), (3.5, 8.3), (4.9, 8.3), (4.9, 9.8), (4.25, 9.8))),
  ("Stair top → bedroom 3 door", ((2.9, 3.05), (3.5, 3.05), (3.5, 8.3), (4.9, 8.3), (4.9, 19.85), (4.25, 19.85))),
  ("Stair top → the gallery's end (the glass door to the court)", ((2.9, 3.05), (3.5, 3.05), (3.5, 8.3), (4.9, 8.3), (4.9, 20.55))),
  ("Stair top → lift door", ((2.9, 3.05), (3.5, 3.05), (3.5, 1.4), (2.5, 1.4))),
  ("Bedroom 2 door → its own bath door", ((4.25, 9.8), (3.0, 9.8), (3.0, 10.6), (1.55, 10.6), (1.55, 14.125))),
  ("Family living → family WC door", ((4.25, 3.8), (3.5, 3.8), (3.5, 8.65), (2.75, 8.65))),
  ("Bedroom 3 door → its own bath door", ((4.25, 19.85), (2.9, 19.85), (2.9, 15.525))),
  ("Bedroom 1 door → family WC door", ((10.15, 5.9), (8.4, 5.9), (8.4, 3.55), (3.5, 3.55), (3.5, 8.65), (2.75, 8.65))),
  ("Bedroom 1 door → its own bath door", ((10.15, 5.9), (11.0, 5.9), (11.0, 6.05), (11.5, 6.05))),
)

// ---------- Helpers ----------
#let q(p) = (p.at(0), -p.at(1))
#let r2(v) = str(calc.round(v, digits: 2))
#let r3(v) = str(calc.round(v, digits: 3))
#let r1(v) = str(calc.round(v, digits: 1))
#let area(P) = calc.abs(range(P.len()).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, P.len())); a.at(0) * b.at(1) - b.at(0) * a.at(1) }).sum()) / 2
#let bbox(P) = (calc.min(..P.map(p => p.at(0))), calc.min(..P.map(p => p.at(1))), calc.max(..P.map(p => p.at(0))), calc.max(..P.map(p => p.at(1))))
#let mid(a, b) = ((a.at(0) + b.at(0)) / 2, (a.at(1) + b.at(1)) / 2)
#let dist(a, b) = calc.sqrt(calc.pow(b.at(0) - a.at(0), 2) + calc.pow(b.at(1) - a.at(1), 2))
#let plen(P) = range(P.len() - 1).map(i => dist(P.at(i), P.at(i + 1))).sum()
#let path-len(n) = plen(paths.find(p => p.at(0) == n).at(1))
#let on-seg(p, a, b) = calc.abs(dist(a, p) + dist(p, b) - dist(a, b)) < 1e-6
#let inside(p, P) = {   // ray casting, boundary counts as inside
  let n = P.len(); let c = false
  for i in range(n) {
    let a = P.at(i); let b = P.at(calc.rem(i + 1, n))
    if on-seg(p, a, b) { return true }
    if (a.at(1) > p.at(1)) != (b.at(1) > p.at(1)) {
      let x = a.at(0) + (p.at(1) - a.at(1)) * (b.at(0) - a.at(0)) / (b.at(1) - a.at(1))
      if p.at(0) < x { c = not c }
    }
  }
  c
}
#let box-overlap(a, b, eps: 0.001) = calc.min(a.at(2), b.at(2)) - calc.max(a.at(0), b.at(0)) > eps and calc.min(a.at(3), b.at(3)) - calc.max(a.at(1), b.at(1)) > eps
#let is-rect(P) = P.len() == 4 and calc.abs(P.at(0).at(1) - P.at(1).at(1)) < 1e-6 and calc.abs(P.at(1).at(0) - P.at(2).at(0)) < 1e-6
// clear ≈ axes minus half a wall on every edge: 250 mm outer walls (the building outline), ≈ 50 mm for the steel window W1 / W2 on the void edges (V6.4), nothing where the edge is open, 200 mm elsewhere
#let open-edges = (((2.75, 2.2), (2.75, 3.75)), ((8.95, 5.3), (8.95, 6.5)), ((4.25, 6.5), (5.8, 6.5)))   // V7.1: the family living open to the gallery's north end (W2 runs only over the courtyard, east of C21)
#let outer-edges = (((0, 0), (0, 24)), ((0, 0), (10.461, 0)), ((10.461, 0), (13.311, 5.245)), ((13.311, 5.245), (13.311, 24)), ((0, 24), (13.311, 24)))
#let edge-t(a, b) = {
  if open-edges.any(e => on-seg(a, ..e) and on-seg(b, ..e)) { 0.0 }
  else if outer-edges.any(e => on-seg(a, ..e) and on-seg(b, ..e)) { 0.25 }
  else if (calc.abs(a.at(0) - proj-x) < 1e-6 and calc.abs(b.at(0) - proj-x) < 1e-6 and calc.min(a.at(1), b.at(1)) >= 6.5 - 1e-6 and calc.max(a.at(1), b.at(1)) <= 19.25 + 1e-6) or (calc.abs(a.at(1) - 6.5) < 1e-6 and calc.abs(b.at(1) - 6.5) < 1e-6 and calc.min(a.at(0), b.at(0)) >= 4.25 - 1e-6 and calc.max(a.at(0), b.at(0)) <= 8.95 + 1e-6) { 0.05 }
  else { 0.2 }
}
#let clear-approx(P) = area(P) - range(P.len()).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, P.len())); dist(a, b) * edge-t(a, b) / 2 }).sum()
#let colours = (circ: rgb("#f2efe8"), store: rgb("#e4ded2"), family: rgb("#f6e3c0"), kids: rgb("#f3d6c4"), wet: rgb("#cfe6ef"), gym: rgb("#d9e4f2"), open: rgb("#ffffff"))
#let green = rgb("#2f6b4f")
#let red = rgb("#b5452f")

// ---------- Checks ----------
#let issues = {
  let out = ()
  for r in rooms { if not r.pts.all(p => inside(p, zone)) { out.push(r.name + " leaves the zone") } }
  let parts = ()
  for r in rooms + fixed { for P in r.at("parts", default: (r.pts,)) { parts.push((r.name, P)) } }
  for i in range(parts.len()) {
    for j in range(i + 1, parts.len()) {
      let (na, A) = parts.at(i); let (nb, B) = parts.at(j)
      if na != nb and box-overlap(bbox(A), bbox(B)) { out.push(na + " overlaps " + nb) }
    }
  }
  let free = area(zone) - (rooms + fixed).map(r => area(r.pts)).sum()
  if calc.abs(free) > 0.01 { out.push("unassigned area " + r2(free) + " m²") }
  // furniture: inside a room, not overlapping each other, not in a walking route
  for (i, f) in furniture.enumerate() {
    let fb = (f.at(0), f.at(1), f.at(2), f.at(3))
    if not rooms.any(r => inside(((f.at(0) + f.at(2)) / 2, (f.at(1) + f.at(3)) / 2), r.pts) and r.col != "circ") { out.push("furniture " + repr(f.at(4)) + " not in a room") }
    for g in furniture.slice(i + 1) { if box-overlap(fb, (g.at(0), g.at(1), g.at(2), g.at(3))) { out.push("furniture " + repr(f.at(4)) + " overlaps " + repr(g.at(4))) } }
    for (n, P, w, t) in routes { if box-overlap(fb, bbox(P)) { out.push("furniture " + repr(f.at(4)) + " in the route " + n) } }
  }
  // door swings (door × door square into the room) clear of furniture
  for d in doors.filter(d => not d.open) {
    let w = dist(d.a, d.b); let (ix, iy) = d.into
    let sq = (d.a, d.b, (d.b.at(0) + ix * w, d.b.at(1) + iy * w), (d.a.at(0) + ix * w, d.a.at(1) + iy * w))
    for f in furniture { if box-overlap(bbox(sq), (f.at(0), f.at(1), f.at(2), f.at(3))) { out.push("door " + repr(d.label) + " swing hits " + repr(f.at(4))) } }
  }
  // every room has a door, reached from circulation (or from the room named)
  for r in rooms.filter(r => r.col != "circ" and r.col != "open") { if not doors.any(d => d.room == r.name) { out.push(r.name + " has no door") } }
  for d in doors {
    let m = mid(d.a, d.b)
    let p = (m.at(0) - d.into.at(0) * 0.3, m.at(1) - d.into.at(1) * 0.3)
    let ok = if d.from == "circ" { rooms.filter(r => r.col == "circ").any(r => inside(p, r.pts)) } else { inside(p, rooms.find(r => r.name == d.from).pts) }
    if not ok { out.push("door " + repr(d.label) + " not reached from " + d.from) }
  }
  // routes ≥ 1.0 m clear; consecutive routes touch
  for (n, P, w, t) in routes {
    let (x0, y0, x1, y1) = bbox(P)
    if calc.min(x1 - x0, y1 - y0) - w < 1.0 - 1e-6 { out.push("route " + n + " under 1.0 m clear") }
  }
  // the suite door interface is on circulation; the other interfaces are fixed lines
  for itf in interfaces.filter(i => i.kind == "door") {
    let (a, b) = itf.pts; let l = itf.label
    let m = mid(a, b)
    let p = if a.at(0) == b.at(0) { (m.at(0) - 0.2, m.at(1)) } else { (m.at(0), m.at(1) - 0.2) }
    if not (rooms.filter(r => r.col == "circ").any(r => inside(p, r.pts)) or routes.any(((n, P, w, t)) => inside(p, P))) { out.push("interface " + repr(l) + " not on circulation") }
  }
  out
}
#let circ-area = rooms.filter(r => r.col == "circ").map(r => area(r.pts)).sum()
#let H(t) = text(9.5pt, weight: "bold", fill: green, t)

// ================= PAGE 1 · plan + rooms + checks =================
#text(15pt, weight: "bold", fill: green)[First floor · family part · focus study]
#h(8pt) #text(8pt, fill: gray)[Taif / Palm House · first floor V6.3 · local = main CSV coordinates (x east, y south) · wall centre lines · north up]
#v(-2pt)
#text(10pt, weight: "bold")[First floor V7.1 · part 1 of 2 · W1 as six arched windows (V7.1): family part · west projection 1.55 m on three columns, the gallery and the family living glazed to the courtyard (W1, W2), west rooms 4.25 m wide; 15 Nov 2026: bedrooms 2 and 3 as twins with entry strips and the X3 bath pair between them · part 2 (office, gym, suite court, master suite): studies/ff_suite.typ]
#v(2pt)
#grid(columns: (auto, 1fr), column-gutter: 14pt,
  cetz.canvas(length: plan-scale, {
    import cetz.draw: *
    let poly(P, ..args) = line(..P.map(q), close: true, ..args)
    for (n, P) in neighbours {
      poly(P, fill: luma(238), stroke: (paint: luma(185), dash: "dashed"))
      let (x0, y0, x1, y1) = bbox(P)
      if area(P) > 1 { content(q(((x0 + x1) / 2, (y0 + y1) / 2)), text(5pt, fill: gray, n)) }
    }
    for (a, b, l) in neighbour-doors { line(q(a), q(b), stroke: 2pt + luma(150)) }
    for r in rooms { poly(r.pts, fill: colours.at(r.col), stroke: 0.6pt + rgb("#3d4a45")) }
    for f in fixed {
      poly(f.pts, fill: luma(205), stroke: 0.6pt + rgb("#3d4a45"))
      let (x0, y0, x1, y1) = bbox(f.pts)
      content(q(((x0 + x1) / 2, (y0 + y1) / 2)), box(width: (x1 - x0) * plan-scale * 0.95, align(center, text(5pt, f.name))))
    }
    for (l, P) in below { poly(P, stroke: (paint: rgb("#8a5a2b"), dash: "dotted", thickness: 0.7pt)) }
    for (x0, y0, x1, y1, l) in furniture {
      rect(q((x0, y0)), q((x1, y1)), fill: white.transparentize(25%), stroke: (paint: luma(110), thickness: 0.4pt, dash: "dashed"))
      content(q(((x0 + x1) / 2, (y0 + y1) / 2)), angle: if (y1 - y0) > (x1 - x0) * 1.3 { 90deg } else { 0deg }, text(4.2pt, fill: luma(80), l))
    }
    let label-at = ("Gallery (north part + on the projection)": (4.25, 11.0), "Bedroom 3": (2.7, 18.6), "Bedroom 2": (3.2, 12.2), "Bedroom 3 bath (en-suite)": (3.45, 15.25), "Kids' room (study + gaming)": (5.5, 2.25), "Family living": (5.6, 6.3), "Bedroom 2 bath (en-suite)": (1.45, 14.6), "Linen cupboard": (3.25, 0.35), "Family WC (gallery)": (2.15, 8.8), "Landing (stair top)": (1.4, 8.8), "Bedroom 1": (11.3, 5.0), "Family link": (9.55, 5.9))
    let short = ("Bedroom 2 bath (en-suite)": "Bath 2", "Bedroom 3 bath (en-suite)": "Bath 3", "Kids' room (study + gaming)": "Kids' room", "Linen cupboard": "Linen", "Family link": "Link", "Gallery (north part + on the projection)": "Gallery", "Family WC (gallery)": "Family WC")
    for r in rooms {
      let (x0, y0, x1, y1) = bbox(r.pts)
      let c = label-at.at(r.name, default: ((x0 + x1) / 2, (y0 + y1) / 2))
      content(q(c), align(center, text(if r.col == "store" { 4.4pt } else { 5.6pt })[*#short.at(r.name, default: r.name)*\ #r2(area(r.pts)) m²]))
    }
    line(..zone.map(q), close: true, stroke: 1.6pt + rgb("#3d4a45"))
    for (a, b) in windows { line(q(a), q(b), stroke: 2.6pt + rgb("#1f7a99")) }
    for d in doors {
      line(q(d.a), q(d.b), stroke: (if d.open { 1.6pt } else { 3pt }) + red)
      if not d.open {
        let w = dist(d.a, d.b)
        line(q(d.a), q((d.a.at(0) + d.into.at(0) * w, d.a.at(1) + d.into.at(1) * w)), stroke: (paint: red, thickness: 0.4pt))
      }
    }
    for itf in interfaces {
      line(..itf.pts.map(q), stroke: 2.6pt + rgb("#2f8a3f"))
      content(q(itf.at), anchor: itf.anchor, box(width: 3.6cm, align(if itf.anchor == "east" { right } else { left }, text(4.8pt, fill: rgb("#2f8a3f"), itf.label))))
    }
    for (P, l) in drains { line(..P.map(q), stroke: (paint: rgb("#1f7a99"), thickness: 0.8pt, dash: "dashed"), mark: (end: ">", fill: rgb("#1f7a99"), scale: 0.35)) }
    circle(q((2.1, 15.225)), radius: 0.12, fill: rgb("#8a5a2b"), stroke: none); content(q((2.1, 15.75)), text(4.2pt, fill: rgb("#8a5a2b"))[stack ↓ GF WC compartment])   // 15 Nov 2026: the one stack of the bath pair
    // the projection: edge beam on x 5.8 and the three ground-floor columns (grey dashed)
    line(q((proj-x, 6.5)), q((proj-x, 19.25)), stroke: (paint: luma(120), thickness: 1.4pt, dash: "dashed"))
    for (x, y) in columns { rect(q((x - 0.18, y - 0.18)), q((x + 0.18, y + 0.18)), fill: luma(150), stroke: (paint: luma(90), dash: "dashed", thickness: 0.5pt)) }
    content(q((7.0, 11.6)), box(width: 2.2cm, align(center, text(4.6pt, fill: luma(90))[courtyard sky #str(calc.round(8.95 - proj-x, digits: 3)) m on axes (GF courtyard 4.70)])))
    content(q((7.0, 17.8)), box(width: 2.2cm, align(center, text(4.6pt, fill: luma(90))[double-height void #str(calc.round(8.95 - proj-x, digits: 3)) m on axes])))
    content(q((5.05, 13.0)), anchor: "west", text(4.4pt, fill: luma(90))[◀ projection #r2(proj-x - 4.25) m · edge beam on #columns.len() columns])
    // walking line through the living to the family link (behind and beside the sofa)
    line(q((3.5, 3.55)), q((8.4, 3.55)), q((8.4, 5.9)), q((8.95, 5.9)), stroke: (paint: red, thickness: 0.7pt, dash: "dotted"), mark: (end: ">", fill: red, scale: 0.35))
    // courtyard view from the living
    line(q((5.9, 5.0)), q((5.9, 7.8)), stroke: (paint: rgb("#2f8a3f"), thickness: 0.6pt, dash: "dotted"), mark: (end: ">", fill: rgb("#2f8a3f"), scale: 0.4))
    content(q((6.0, 7.9)), anchor: "north-west", text(4.8pt, fill: rgb("#2f8a3f"))[courtyard view])
    content(q((1.0, 3.0)), text(4.8pt, fill: red)[▲ stair top (flipped)])
    line(q((0, 24.8)), q((2, 24.8)), stroke: 1.2pt)
    content(q((1, 25.2)), text(5.5pt)[2 m])
  }),
  [
    #H[Rooms]
    #table(columns: (auto, auto, auto, auto), stroke: none, inset: 2pt, fill: (_, y) => if calc.even(y) { rgb("#efece4") },
      [*Room*], [*Axes w × d (m)*], [*Axes m²*], [*≈ clear m²*],
      ..rooms.map(r => {
        let (x0, y0, x1, y1) = bbox(r.pts)
        ([#r.name], [#if is-rect(r.pts) [#r2(x1 - x0) × #r2(y1 - y0)] else [polygon]], [#r2(area(r.pts))], [#if r.col == "store" or r.col == "open" [–] else [#r2(clear-approx(r.pts))]])
      }).flatten(),
      [Fixed: stair, lift, west shaft, air tower], [], [#r2(fixed.map(f => area(f.pts)).sum())], [],
      [*Zone*], [], [*#r2(area(zone))*], [],
    )
    #text(5.8pt, fill: gray)[Clear ≈ axes minus half a wall on every edge (250 mm outer, 200 mm inner, ≈ 50 mm balustrade on the void edges, nothing on open edges), corners ignored.]
    #v(2pt)
    #if issues.len() == 0 { text(fill: green, weight: "bold")[✓ All rooms inside the zone · no overlaps · no unassigned area · furniture inside its room, not overlapping, out of the routes · door swings clear · every room has a door reached from circulation · routes ≥ 1.0 m clear · suite door and gallery end on circulation] } else { std.block(fill: rgb("#fbe3dd"), inset: 4pt, radius: 2pt)[#text(fill: red, weight: "bold")[WARNING]\ #issues.map(i => [• #i]).join(linebreak())] }
    #v(3pt)
    #H[Key numbers]
    - *West projection:* #r2(proj-x - 4.25) m over the courtyard and the double-height void (x 4.25–#r2(proj-x), y 6.5–19.25) on an *edge beam and #columns.len() columns* at x #r2(proj-x); the first-floor west wall stands on the GF west wall. Stair, lift, landing and west shaft rise from the ground floor.
    - *Courtyard sky* and *double-height void* #str(calc.round(8.95 - proj-x, digits: 3)) m on axes (the GF courtyard is 4.70); the ground-floor courtyard and living keep their full floor.
    - *West rooms* #r2(bbox(room("Bedroom 2").pts).at(2) - bbox(room("Bedroom 2").pts).at(0)) m on axes. *Gallery on the projection:* #r2(proj-x - bbox(room("Bedroom 2").pts).at(2)) m (½ wall + ½ railing off); wider at the stair top. *Circulation in the zone:* #r2(circ-area) m² (landing, gallery, family link); the walk through the living is not counted.
    - *Family living:* #r2(area(seating.pts)) m², on the courtyard edge, no separate route. *Kids' room:* #r2(area(room("Kids").pts)) m².
    - *Bedrooms (15 Nov 2026, twins):* 2 · #r2(area(room("Bedroom 2").pts)) m² (≈ #r2(clear-approx(room("Bedroom 2").pts)) clear: the main room 4.03 × 3.53 = 14.44 + its entry strip 2.55 × 1.10) · 3 · #r2(area(room("Bedroom 3").pts)) m² (≈ #r2(clear-approx(room("Bedroom 3").pts)) clear: the main room 4.03 × 3.52 = 14.44 + its entry strip 2.55 × 1.20) · their baths back to back between them: bath 2 #r2(area(room("Bedroom 2 bath").pts)) m², bath 3 #r2(area(room("Bedroom 3 bath").pts)) m² · 1 · #r2(area(room("Bedroom 1").pts)) m² + its own bath #r2(area(room("Bedroom 1 bath").pts)) m² (≈ #r2(clear-approx(room("Bedroom 1 bath").pts)) clear; 14 Nov 2026, M3 adopted). The *family WC* #r2(area(room("Family WC").pts)) m² (14 Nov 2026: a basin zone open to the gallery and a WC compartment behind a 0.70 door, as the GF powder room; it serves the family living and the kids' room).
    - *Walked to a bathroom door:* bedroom 2 → its own bath ≈ #r1(path-len("Bedroom 2 door → its own bath door")) m · bedroom 3 → its own bath ≈ #r1(path-len("Bedroom 3 door → its own bath door")) m · family living → the family WC ≈ #r1(path-len("Family living → family WC door")) m · bedroom 1 → its own bath ≈ #r1(path-len("Bedroom 1 door → its own bath door")) m (the family WC ≈ #r1(path-len("Bedroom 1 door → family WC door")) m).
    #v(2pt)
    #text(6pt, fill: gray)[Plan: red = doors (thin = opening without a leaf) with swing line · blue = windows · blue dashed = drains · green = interfaces · brown dotted = ground floor below (the full courtyard and living floors) · grey dashed = the edge beam (x 5.6) and the three ground-floor columns · grey = neighbours · dashed boxes = furniture and fixtures.]
  ],
)

// ================= PAGE 2 · the projection and the rooms =================
#pagebreak()
#set text(size: 6.7pt)
#let bed2 = bbox(room("Bedroom 2").pts)
#let bath = bbox(room("Bedroom 2 bath").pts)
#let fwc = bbox(room("Family WC").pts)
#text(15pt, weight: "bold", fill: green)[Family part · the west projection and the rooms]
#v(4pt)
#grid(columns: (1fr, 1fr), column-gutter: 18pt,
  [
    #H[The west projection · #r2(proj-x - 4.25) m over the courtyard and the double-height void]
    - *Where:* along the west edge of the courtyard and of the double-height living, x 4.25–#r2(proj-x), from the courtyard's north edge (y 6.5) to the living's south wall (y 19.25). The west rooms take the full band over the GF west band and riwaq; their west wall stands on the GF west wall.
    - *Widths:* rooms #r2(bed2.at(2) - bed2.at(0)) m on axes (≥ 4.0 m clear), gallery #r2(proj-x - bed2.at(2)) m (≥ 1.0 m clear).
    - *Carried on:* an edge beam along x #r2(proj-x) and #columns.len() columns, each in an existing wall or glass line, none free-standing in a room: column 1 in the women's majlis south wall (y 6.5), column 2 a pier in the glass between the courtyard and the living (y 13.0), column 3 in the living's south wall (y 19.25). On the ground floor it reads as a colonnade along the courtyard edge.
    - *Why columns and not a cantilever wall:* walls stand directly on walls; the earlier split projection (a west wall on cantilever beams, 0.11 m from the M line) was reverted.
    - *Gallery:* closed to the courtyard by the steel window W1 on the upstand of the edge beam (sill +3.82, guarding transom +4.70, head +6.75, four inward casements; V6.4, enclosure option A), the stair arrives at its north end beside the lift door (the flip, option B); every west room door opens from it. Clear 1.405 m (1.235 m at the three column sleeves Ø0.40).
    #v(3pt)
    #H[Kids' room · family living · bedroom 1]
    - *Kids' room* #r2(area(room("Kids").pts)) m²: two study desks + PC desk under the north window, a gaming corner (TV on the east wall), solid door from the gallery.
    - *Family living* #r2(area(seating.pts)) m²: a view, not a path; the walk to the family link passes behind and beside the sofa.
    - *Bedroom 1 (14 Nov 2026, the east wing's M3 adopted with the owner's adjustments, `studies/east_wing_ff.typ` page 7):* the young children's room keeps its shape but for the corner x 11.5–13.311 × y 5.6–6.5 of its entry strip; its *door on the link's east wall* (x 10.15, at a right angle to the suite door, not facing it; nothing at the link's start); its *own compact bath* x 11.5–13.311 × y 5.6–8.0 (#r2(area(room("Bedroom 1 bath").pts)) m², ≈ 1.6 × 2.2 clear): the 0.70 door on the bath's west wall from the entry strip, the basin by it, the wall-hung WC on the east wall, the wall-mixer shower at the south end over the east stack, back to back with the suite's shower on the shared wall y 8.0; a provisional east window or a fan. *Built-in wardrobes* (10 cm block sides, a lintel, sliding doors): W1 1.15 × 0.60 clear against the bath's north wall under the cut, W2 2.40 × 0.60 on the west wall. The suite's WC closet (x 10.3–11.5) is behind the y 6.5 wall: an acoustic wall (dense block, no sockets back to back).
    #v(3pt)
    #H[Family WC · #r3(fwc.at(2) - fwc.at(0)) × #r2(fwc.at(3) - fwc.at(1)) m, by the west shaft · as the GF powder room (14 Nov 2026)]
    - *14 Nov 2026 (owner):* the family WC works like the ground-floor powder room: a *basin zone open to the gallery* (x 1.5–2.75, ≈ 1.15 × 1.10 clear) through a 0.90 m opening with *no door* (x 2.75, y 8.2–9.1), ONE basin with its mirror on the north wall (y 7.9, the stair wall), the south wall plain; then a *100 mm partition on x 1.5* (y 7.9–9.2, the shaft's east face line continued, replacing the screen wall) with a *0.70 door hinged on its south jamb, opening OUT* into the basin zone so the leaf folds back against the south wall and clears the basin (checked); behind it the *WC compartment* (x 0–1.5, ≈ 1.33 × 1.10 clear): a wall-hung WC only, on the west outer wall facing east (the concealed cistern frame in that wall, ≈ 0.7 m clear in front), its waste in the floor build-up ≈ 0.5 m south to the west shaft; an exhaust fan to the shaft; a small high window in the west outer wall above the WC (≈ 0.5 × 0.4, sill ≥ +1.70, obscure glass). The wall on y 7.9 (B12) still closes the stair opening's south side; the gallery and the guard round the opening are untouched. *3 Nov 2026:* the F-b bath split into this strip and bedroom 2's en-suite.
  ],
  [
    #H[Bedroom 2 · #r2(area(room("Bedroom 2").pts)) m² (≈ #r2(clear-approx(room("Bedroom 2").pts)) clear) + its bath #r2(area(room("Bedroom 2 bath").pts)) m² · twins (owner, 15 Nov 2026, `studies/west_wing_ff.typ`)]
    - *Entered through its entry strip* beside the shaft (x 1.5–4.25 × y 9.2–10.4, 2.55 × 1.10 clear): the 0.90 door on the gallery inside it, facing the shaft's wall, then the main room *4.03 × 3.53 clear = 14.44 m²* (the 0.10 band beside the shaft apart). No store. *Bed 1.4 × 2.0* with its head on the west wall under its window, bedside tables both sides; *desk* at the second west window; *wardrobe 1.8 m* on the bath wall east of the bath door. No door faces the bed's head.
    - *En-suite bath (X3)* #r3(bath.at(2) - bath.at(0)) × #r2(bath.at(3) - bath.at(1)) m on axes (≈ #r2(clear-approx(room("Bedroom 2 bath").pts)) m² clear), the west half of the pair between the two bedrooms: its 0.70 door on y #r3(bath.at(1)) at x 1.2–1.9 from *inside* the bedroom, opening into the bath; the *shower 0.8 × 0.8* with a screen in the north-west corner under a *small high window*, the *basin* south-west, the *wall-hung WC* on the wet wall x 2.10 at its south end; ≈ #r1(path-len("Bedroom 2 door → its own bath door")) m from the bedroom door. *Result:* every bedroom has its own bathroom (the suite, bedrooms 1, 2 and 3) plus a family WC upstairs.
    #v(3pt)
    #H[Bedroom 3 · #r2(area(room("Bedroom 3").pts)) m² (≈ #r2(clear-approx(room("Bedroom 3").pts)) clear) + its bath #r2(area(room("Bedroom 3 bath").pts)) m² · the twin]
    - *A full clean rectangle* from the bath pair to y 19.25 (its south wall on the beams B22 + B8): the main room *4.03 × 3.52 clear = 14.44 m²*, equal to bedroom 2's. *Entered through its entry strip* taken from the gym south of y 19.25 (x 1.5–4.25 × y 19.25–20.55, 2.55 × 1.20 clear; its south wall on the old nib's line, so no sliver is left): the 0.90 door on x 4.25 from the gallery's end, facing the strip's west end wall (the gym's), then north into the room through the strip's *full-width opening on y 19.25, no leaf*. *Bed 1.4 × 2.0* head on the west wall under its window, *desk* at the second west window, *wardrobe 1.8 m* on the gallery wall.
    - *En-suite bath (X3)* 2.15 × 1.40 m on axes (≈ #r2(clear-approx(room("Bedroom 3 bath").pts)) m² clear), the east half of the pair, by the gallery (a fan, no window): its 0.70 door on y 15.525 at x 3.0–3.7 from inside the bedroom; the shower 0.8 × 0.8 north-west, the wall-hung WC on the wet wall at its south end, the basin by the gallery wall; ≈ #r1(path-len("Bedroom 3 door → its own bath door")) m from the bedroom door. The *one stack* at (2.10, 15.23) on the shared wet wall drops straight into the GF powder room's WC compartment (y 14.55–16.1).
    #v(3pt)
    #H[The gallery's end and the gym → the L study]
    - The gallery now ends at y 20.55 (19.85 m long from y 0.7) over the old nib footprint, with a *glass door 1.10* onto the suite court; nothing new east of x 4.25. The *gym* (its door from the court beside the gallery's end; the pocket with the dumbbell rack west of bedroom 3's strip), the court and the suite: studies/ff_suite.typ.
    #v(3pt)
    #H[Interfaces with the L study (fixed)]
    - ① suite door at the end of the family link (y 6.5); ② bedroom 1 / suite: one straight wall on y 6.5; ③ the gallery's end (y 20.55): the glass door to the court, the gym's door beside it; ④ bedroom 3 / the gym: the double wall on B22 for x 0–1.5, then the strip's light walls x 1.5 and y 20.55.
  ],
)

// ================= PAGE 3 · routes, walls, drains, open items =================
#pagebreak()
#text(15pt, weight: "bold", fill: green)[Family part · routes, walls, drains, open items]
#v(4pt)
#grid(columns: (1fr, 1fr), column-gutter: 18pt,
  [
    #H[Routes (≥ 1.0 m clear)]
    #table(columns: (auto, auto, auto, 1fr), stroke: none, inset: 2pt, fill: (_, y) => if calc.even(y) { rgb("#efece4") },
      [*Route*], [*Axes*], [*≈ clear*], [*Deducted*],
      ..routes.map(((n, P, w, t)) => { let (x0, y0, x1, y1) = bbox(P); ([#n], [#r2(calc.min(x1 - x0, y1 - y0))], [#r2(calc.min(x1 - x0, y1 - y0) - w)], [#t]) }).flatten(),
    )
    #table(columns: (auto, auto), stroke: none, inset: 2pt, fill: (_, y) => if calc.even(y) { rgb("#efece4") },
      [*Walking distance*], [*m*],
      ..paths.map(((n, P)) => ([#n], [#r1(plen(P))])).flatten(),
    )
    Stair top → every room, the suite door and the gallery's south end runs only on the arrival strip, the gallery, the family link and the walking line through the living (checked: every door's approach is on circulation, no furniture in a route).
  ],
  [
    #H[Engineer]
    - *Projection:* #r2(proj-x - 4.25) m slab beyond x 4.25 along y 6.5–19.25; an *edge beam* on x #r2(proj-x) (spans ≈ 6.5 m and 6.25 m, depth to confirm; seen from the courtyard and the living, expressed as the colonnade's beam); #columns.len() *columns* down to their own foundations (sizes and pads to confirm).
    - *Ground floor* changes only by the columns, their foundations, the beam line and the lower ceiling under the projection.
    #v(3pt)
    #H[Walls off the ground-floor lines]
    Ground-floor lines here: #gf-lines.
    - *Off:* y 3.0 (kids' room / living, over the women's majlis); *y 9.2 east of the shaft* (the 0.20 wall between the family WC and bedroom 2's entry strip: light, on the solid west slab); *the X3 bath pair (15 Nov 2026):* y 14.125 and y 15.525 (its two cross walls) and the wet wall x 2.10 (mid-bay; it carries the stack and the two WC frames): 0.20 block partitions on the solid west slab, none on a GF wall; *bedroom 3's entry strip:* its west wall x 1.5 (y 19.25–20.55) and its south wall y 20.55 (continued east as the gallery's end wall): light double gypsum on the men's majlis roof slab. *Removed (15 Nov 2026):* bath 2's niche walls (y 11.0, x 1.5), bath 3's walls (y 14.4, x 2.2), the nib's north wall with its sliding door and the nib's court door. No column or beam moved.
    - *On:* y 19.25 for x 0–1.5 only (the double wall to the gym on B22; over x 1.5–4.25 the strip's opening replaces it, B22 and B8 carrying the slab as before: for the engineer's list), x 1.5 / y 10.4 (shaft), y 6.5 (bedroom 1 / the suite's closet, on B6), *x 4.25* (the rooms' east wall, on the GF courtyard edge line), the outer walls. *Off (14 Nov 2026):* x 11.5 (y 5.6–8.0) and y 5.6 (the kids' bath), y 8.0 east of x 11.5 (the bath / the suite bath): light partitions on the slab; the y 6.5 wall over B6 is interrupted 1.8 m by the kids' bath (for the engineer's list).
    - The GF riwaq wall x 2.75 carries the floor; the rooms span over the riwaq.
    #v(3pt)
    #H[Drains (blue dashed)]
    - *Family WC (14 Nov 2026):* the wall-hung pan on the west outer wall, its waste in the floor build-up ≈ 0.5 m south to the west shaft; the basin's waste in the floor build-up or a chase in the x 1.5 partition to the shaft; both over the GF utility room (service). *The X3 bath pair (15 Nov 2026):* both wall-hung WCs on the shared wet wall x 2.10 at its south end into the *one stack at (2.10, 15.23)*, which drops straight into the GF powder room's WC compartment (y 14.55–16.1, x ≤ 2.75: the stack 0.67 m south of the compartment's partition) and on to the buried west run; the two showers and the two basins in the floor build-up to the stack, ≤ 2 m each, over the GF powder room (wet). The old bedroom 3 bath stack over the GF family WC is no longer needed.
    - *Bedroom 1's bath (14 Nov 2026):* over the GF laundry (y 5.6–6.5) and the kitchen's north band (y 6.5–8.0), both service rooms; the shower's floor drain, the WC and the basin run east to the *one stack outside the east wall at y 7.05* (≤ 2 m each), the same stack as the suite's; no drain over the kitchen hood (y ≥ 10.1). No east duct.
    #v(3pt)
    #H[Open items (all in docs/OPEN_ITEMS.md)]
    - *Engineer:* the edge beam and the #columns.len() columns at x #r2(proj-x) (sizes and foundations); walls off the GF lines.
    - *Gallery window W1* on the B3 upstand and *W2* on the family living's edge (black steel, divided lites, laminated glass below +4.70): the courtyard stays open to the sky, the house is closed round it (V6.4).
    - *Built-in cupboards in niches* (the linen cupboard; bedroom 2's vanity niche): joinery boxes scribed to the walls; decide with the carpenter.
    - *Courtyard light:* a daylight study of the courtyard and the double-height living.
  ],
)

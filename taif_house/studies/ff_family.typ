// ff_family.typ · Taif / Palm House · FIRST FLOOR · focus study of the FAMILY PART (the whole floor except the master suite) · compile THIS file
// First floor V6.3, part 1 of 2 (part 2: studies/ff_suite.typ) · stand-alone: all data is in this file.
// Local coordinates (metres, origin = the zone's NW corner, x east, y SOUTH) = the main first-floor CSV coordinates: no conversion.
// The room list is also in data/rooms_ff.csv (whole-floor plan: design_ff.typ, which checks that both agree).
#import "@preview/cetz:0.4.2"
#set page(paper: "a4", flipped: true, margin: 10mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 7.2pt)

#let rect-pts(x0, y0, x1, y1) = ((x0, y0), (x1, y0), (x1, y1), (x0, y1))

// ---------- The focus zone (wall centre lines): everything but the courtyard / double-height void and the master suite; with the west projection (x 4.25–5.8, y 6.5–19.25; V6.4: 1.55 m, courtyard enclosure option A) on an edge beam and three columns ----------
#let zone = ((0, 0), (10.051, 0), (13.311, 6.0), (13.311, 6.5), (10.15, 6.5), (8.95, 6.5), (5.8, 6.5), (5.8, 19.25), (0, 19.25))
#let plan-scale = 0.6cm
#let proj-x = 5.8   // the projection's outer edge (edge beam B3, with the steel window W1 on its upstand): 1.55 m beyond the courtyard wall line x 4.25 (V6.4, enclosure option A)
// the edge beam (x 5.8) on three columns, each in an existing wall / glass line (ground floor): the women's majlis south wall, the courtyard / living glass, the living's south wall
#let columns = ((5.8, 6.5), (5.8, 13.0), (5.8, 19.25))

// ---------- Fixed inside the zone (rising from the ground floor) ----------
#let fixed = (
  (name: "Stair (arrives at its south end)", pts: rect-pts(0, 2.2, 2.75, 7.9)),
  (name: "Lift shaft", pts: rect-pts(0, 0, 2.25, 2.2)),
  (name: "West shaft", pts: rect-pts(0, 9.2, 1.5, 10.4)),
  (name: "Air tower", pts: ((8.95, 0), (10.051, 0), (10.594, 1.0), (8.95, 1.0)), parts: (((8.95, 0), (10.594, 0), (10.594, 1.0), (8.95, 1.0)),)),
)

// ---------- Neighbours (grey: the courtyard / void and the L, studies/ff_suite.typ) ----------
#let neighbours = (
  ("Courtyard sky (void)", rect-pts(5.8, 6.5, 8.95, 13.0)),
  ("Double-height living (void)", rect-pts(5.8, 13.0, 8.95, 19.25)),
  ("Suite lobby", rect-pts(8.95, 6.5, 10.3, 11.9)),
  ("Suite bath", rect-pts(10.3, 6.5, 13.311, 10.45)),
  ("Suite dressing", rect-pts(10.3, 10.45, 13.311, 13.9)),
  ("Suite bedroom", ((8.95, 11.9), (10.3, 11.9), (10.3, 13.9), (13.311, 13.9), (13.311, 19.25), (8.95, 19.25))),
  ("Suite court (open)", rect-pts(5.6, 19.25, 10.0, 21.9)),
  ("Gym (west + south, 1 Nov 2026)", ((0, 19.25), (5.6, 19.25), (5.6, 21.9), (10.0, 21.9), (10.0, 24.0), (0, 24.0))),
  ("Owner's office (east)", rect-pts(10.0, 19.25, 13.311, 24.0)),
)
#let neighbour-doors = (((9.05, 11.9), (9.95, 11.9), [suite bedroom]), ((10.3, 6.7), (10.3, 7.5), [suite bath]))
// ground floor below (dotted): the full courtyard and living floors stay; the women's majlis; the wet rooms under the west band; the men's majlis
#let below = (
  ([GF courtyard (full floor)], rect-pts(4.25, 6.5, 8.95, 13.0)),
  ([GF living (full floor)], rect-pts(4.25, 13.0, 8.95, 19.25)),
  ([GF women's majlis], rect-pts(4.25, 0, 8.95, 6.5)),
  ([GF family WC], rect-pts(0, 14.4, 2.75, 16.1)),
  ([GF guest WC], rect-pts(1.25, 17.5, 2.75, 19.25)),
  ([GF men's majlis], rect-pts(2.75, 19.25, 13.311, 24.0)),
)

// ---------- Interfaces with the master suite study (fixed) ----------
#let interfaces = (
  (pts: ((8.95, 6.5), (10.15, 6.5)), label: [① suite door: family link → suite lobby], kind: "door", at: (8.85, 7.6), anchor: "east"),
  (pts: ((10.15, 6.5), (13.311, 6.5)), label: [② bedroom 1 / suite: one straight wall on y 6.5], kind: "line", at: (13.45, 6.5), anchor: "west"),
  (pts: ((4.25, 19.25), (5.6, 19.25)), label: [③ gallery's south end → the gym's sliding door (1 Nov 2026)], kind: "door", at: (5.75, 19.7), anchor: "west"),
  (pts: ((0, 19.25), (4.25, 19.25)), label: [④ bedroom 3 south wall / the gym: a DOUBLE wall, Rw ≈ 55 dB (1 Nov 2026)], kind: "line", at: (0.1, 19.7), anchor: "west"),
)

// ---------- Ground-floor wall lines in this zone ----------
#let gf-lines = [x 0, 1.25 (guest WC), 1.5 (shaft), 2.25, 2.75, 4.25, 8.95 · y 2.2, 7.9, 10.4, 12.9, 14.4, 16.1, 17.5, 19.25, 21.4 (foyer) (west band); the women's majlis (x 4.25–8.95, y 0–6.5) and the men's majlis (x 2.75–13.311, y 19.25–24) have no inner wall; east part (bedroom 1, family link): over the GF maid wing, laundry and the kitchen's north wall]

// ---------- Rooms ----------
#let R(name, pts, col, parts: none) = (name: name, pts: pts, col: col, parts: if parts == none { (pts,) } else { parts })
#let rooms = (
  R("Landing (stair top)", rect-pts(0, 7.9, 2.75, 9.2), "circ"),
  R("Gallery (north part + on the projection)", ((2.25, 0.7), (4.25, 0.7), (4.25, 3.0), (4.25, 6.5), (5.8, 6.5), (5.8, 19.25), (4.25, 19.25), (4.25, 9.2), (2.75, 9.2), (2.75, 7.9), (2.75, 2.2), (2.25, 2.2)), "circ",
    parts: (rect-pts(2.25, 0.7, 2.75, 2.2), rect-pts(2.75, 0.7, 4.25, 9.2), rect-pts(4.25, 6.5, 5.8, 19.25))),
  R("Linen cupboard", rect-pts(2.25, 0, 4.25, 0.7), "store"),
  R("Family bath (bed 1 + 2, family living)", rect-pts(1.5, 9.2, 4.25, 11.0), "wet"),
  R("Wardrobe niche (bed 2)", rect-pts(0, 10.4, 1.5, 11.0), "store"),
  R("Bedroom 2", rect-pts(0, 11.0, 4.25, 14.4), "family"),
  R("Bedroom 3 bath (en-suite)", rect-pts(0, 14.4, 2.2, 16.1), "wet"),
  R("Bedroom 3", ((2.2, 14.4), (4.25, 14.4), (4.25, 19.25), (0, 19.25), (0, 16.1), (2.2, 16.1)), "family",
    parts: (rect-pts(2.2, 14.4, 4.25, 16.1), rect-pts(0, 16.1, 4.25, 19.25))),
  R("Kids' room (study + gaming)", rect-pts(4.25, 0, 8.95, 3.0), "kids"),
  R("Family living", rect-pts(4.25, 3.0, 8.95, 6.5), "family"),
  R("Family link", rect-pts(8.95, 5.3, 10.15, 6.5), "circ"),
  R("Bedroom 1", ((8.95, 1.0), (10.594, 1.0), (13.311, 6.0), (13.311, 6.5), (10.15, 6.5), (10.15, 5.3), (8.95, 5.3)), "family",
    parts: (((8.95, 1.0), (13.311, 1.0), (13.311, 5.3), (8.95, 5.3)), rect-pts(10.15, 5.3, 13.311, 6.5))),
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
  D((4.25, 9.3), (4.25, 10.3), [family bath], "Family bath (bed 1 + 2, family living)", (-1, 0)),
  D((0.1, 11.0), (1.4, 11.0), [wardrobe], "Wardrobe niche (bed 2)", (0, -1), from: "Bedroom 2", open: true),
  D((4.25, 11.1), (4.25, 12.1), [bed 2], "Bedroom 2", (-1, 0)),
  D((4.25, 15.2), (4.25, 16.2), [bed 3], "Bedroom 3", (-1, 0)),
  D((2.2, 15.0), (2.2, 16.0), [bath (sliding)], "Bedroom 3 bath (en-suite)", (-1, 0), from: "Bedroom 3", open: true),
  D((9.05, 5.3), (10.05, 5.3), [bed 1], "Bedroom 1", (0, -1)),
)

// ---------- Furniture and fixtures (x0, y0, x1, y1, label) ----------
#let furniture = (
  // kids' room: three desks under the north window, gaming corner on the east wall
  (5.15, 0.125, 6.35, 0.725, [study desk]), (6.35, 0.125, 7.55, 0.725, [study desk]), (7.65, 0.125, 8.85, 0.725, [PC desk]),
  (5.5, 0.85, 6.0, 1.35, []), (6.7, 0.85, 7.2, 1.35, []), (8.0, 0.85, 8.5, 1.35, []),
  (6.4, 1.55, 7.15, 2.85, [2-seat sofa / bean bags]), (8.45, 1.6, 8.85, 2.8, [TV ≤ 50"]),
  // family living on the courtyard edge: TV on the west wall, a sofa facing it (courtyard on its left), a loveseat facing the courtyard
  (4.35, 4.6, 4.75, 6.1, [TV wall]), (6.6, 4.3, 7.45, 6.3, [sofa · faces TV]), (5.4, 4.15, 6.4, 4.95, [loveseat · faces courtyard]), (5.25, 5.35, 6.25, 6.05, [table]),
  // family bath: WC on the shaft wall, shower, basin by the door
  (1.6, 9.35, 2.25, 9.8, [WC]), (1.6, 10.0, 2.5, 10.9, [shower]), (2.8, 10.35, 3.6, 10.9, [basin]),
  // bedroom 2 (4.25 m wide): wardrobe in the niche + on the east wall, desk under the west window, bed head to the south wall
  (0.125, 10.5, 1.4, 11.1, [wardrobe]), (0.125, 11.3, 0.725, 12.5, [desk]), (0.85, 11.65, 1.3, 12.1, []),
  (1.2, 12.3, 2.6, 14.3, [bed 1.4 × 2.0]), (0.75, 13.9, 1.15, 14.3, []), (2.65, 13.9, 3.05, 14.3, []), (3.55, 12.2, 4.15, 14.2, [wardrobe]),
  // bedroom 3 bath (en-suite) over the GF family WC
  (0.125, 14.5, 1.025, 15.4, [shower]), (1.4, 14.5, 1.85, 15.15, [WC]), (0.125, 15.5, 0.6, 16.0, [basin]),
  // bedroom 3: entry with a wardrobe, bed head on the west wall, wardrobe east, desk on the south window
  (2.3, 14.5, 3.35, 15.1, [wardrobe]), (0.125, 17.0, 2.125, 18.4, [bed 1.4 × 2.0]), (0.125, 16.55, 0.525, 16.95, []), (0.125, 18.45, 0.525, 18.85, []),
  (3.55, 16.3, 4.15, 17.9, [wardrobe]), (2.3, 18.55, 3.5, 19.15, [desk]), (2.65, 18.0, 3.15, 18.45, []),
  // bedroom 1: one room, no bath; wardrobe wall on the straight south wall
  (9.05, 1.1, 10.45, 3.1, [bed 1.4 × 2.0]), (10.5, 2.7, 10.9, 3.1, []), (10.9, 3.9, 12.0, 4.5, [desk]), (11.2, 3.35, 11.65, 3.8, []),
  (10.3, 5.85, 12.9, 6.4, [wardrobe wall 2.6 m]),
)
// fire safety (owner, 1 Nov 2026; studies/fire_escape.typ): the escape windows of the sleeping rooms: hinged casements opening fully from inside, no grille, bar or fixed mashrabiya
#let escape-windows = (("Bedroom 1", (10.92, 1.6), (11.79, 3.2)), ("Bedroom 2", (0, 11.3), (0, 12.6)), ("Bedroom 3", (0, 17.2), (0, 18.2)), ("Kids' room (a bedroom later)", (5.3, 0), (8.7, 0)))
#let windows = (((5.3, 0), (8.7, 0)), ((0, 11.3), (0, 12.6)), ((0, 14.6), (0, 15.2)), ((0, 17.2), (0, 18.2)), ((10.92, 1.6), (11.79, 3.2)), ((12.3, 4.15), (12.9, 5.25)),
  ((5.8, 6.783), (5.8, 8.383)), ((5.8, 8.95), (5.8, 10.55)), ((5.8, 11.117), (5.8, 12.717)), ((5.8, 13.242), (5.8, 14.842)), ((5.8, 15.325), (5.8, 16.925)), ((5.8, 17.408), (5.8, 19.008)),   // V7.1: W1 as six arched windows 1.60 wide on the gallery edge (three per column bay, over the arcade bays), sill +3.82, springing +5.80, crown +6.60
  ((6, 6.5), (7.3, 6.5)), ((7.55, 6.5), (8.85, 6.5)))   // V7.1: W2 as two arched windows 1.30 wide on the family living's courtyard edge (east of C21), floor to the crown +6.60
#let drains = (
  (((1.93, 9.57), (1.5, 9.57)), [family bath: WC on the west shaft wall]),
  (((2.05, 10.45), (1.75, 10.1), (1.5, 9.9)), []),
  (((3.2, 10.6), (2.7, 9.95), (1.5, 9.95)), []),
  (((1.62, 14.82), (1.62, 14.95)), [bedroom 3 bath: over the GF family WC stack]),
  (((0.57, 14.95), (1.4, 14.9)), []),
  (((0.36, 15.75), (1.3, 15.1)), []),
)

// ---------- Walking routes: (name, rect, wall allowance across it, what is deducted) ----------
#let routes = (
  ("Landing", rect-pts(0, 7.9, 2.75, 9.2), 0.1, [½ wall on the south side; the north side is the stair arrival]),
  ("Gallery north (beside the stair)", rect-pts(2.75, 0.7, 4.25, 9.2), 0.2, [½ wall each side]),
  ("Gallery on the projection", rect-pts(4.25, 6.5, 5.8, 19.25), 0.125, [½ wall (rooms side) + ½ window frame W1 on the B3 upstand (void side)]),
  ("Walk behind the sofa (in the living)", rect-pts(4.25, 3.0, 8.95, 4.1), 0.1, [½ wall on the kids' room side; the sofa side is open]),
  ("Walk beside the sofa to the family link", rect-pts(7.85, 4.1, 8.95, 6.5), 0.1, [½ wall on the bedroom 1 side; the sofa side is open]),
  ("Family link", rect-pts(8.95, 5.3, 10.15, 6.5), 0.2, [½ wall each side (bedroom 1 to the north and east)]),
)
// walking paths for distances (polylines)
#let paths = (
  ("Stair top → kids' room door", ((1.4, 8.3), (3.5, 8.3), (3.5, 2.4), (4.25, 2.4))),
  ("Stair top → family living (opening)", ((1.4, 8.3), (3.5, 8.3), (3.5, 3.55), (4.8, 3.55), (4.8, 4.1))),
  ("Stair top → bedroom 1 door", ((1.4, 8.3), (3.5, 8.3), (3.5, 3.55), (8.4, 3.55), (8.4, 5.9), (9.55, 5.9), (9.55, 5.3))),
  ("Stair top → ① suite door", ((1.4, 8.3), (3.5, 8.3), (3.5, 3.55), (8.4, 3.55), (8.4, 5.9), (9.55, 5.9), (9.55, 6.5))),
  ("Stair top → family bath door", ((1.4, 8.3), (4.9, 8.3), (4.9, 9.8), (4.25, 9.8))),
  ("Stair top → bedroom 2 door", ((1.4, 8.3), (4.9, 8.3), (4.9, 11.6), (4.25, 11.6))),
  ("Stair top → bedroom 3 door", ((1.4, 8.3), (4.9, 8.3), (4.9, 15.0), (4.25, 15.0))),
  ("Stair top → gallery's south end (L)", ((1.4, 8.3), (4.9, 8.3), (4.9, 19.25))),
  ("Bedroom 2 door → family bath door", ((4.25, 11.6), (4.7, 11.6), (4.7, 9.8), (4.25, 9.8))),
  ("Family living → family bath door", ((4.25, 3.8), (3.5, 3.8), (3.5, 8.6), (4.9, 8.6), (4.9, 9.8), (4.25, 9.8))),
  ("Bedroom 3 door → its own bath door", ((4.25, 15.0), (3.7, 15.0), (3.7, 15.65), (2.2, 15.65))),
  ("Bedroom 1 door → family bath door", ((9.55, 5.3), (9.55, 5.9), (8.4, 5.9), (8.4, 3.55), (3.5, 3.55), (3.5, 8.6), (4.9, 8.6), (4.9, 9.8), (4.25, 9.8))),
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
#let open-edges = (((2.75, 7.9), (2.75, 9.2)), ((0, 7.9), (2.75, 7.9)), ((4.25, 19.25), (5.6, 19.25)), ((8.95, 5.3), (8.95, 6.5)), ((4.25, 6.5), (5.8, 6.5)))   // V7.1: the family living open to the gallery's north end (W2 runs only over the courtyard, east of C21)
#let outer-edges = (((0, 0), (0, 24)), ((0, 0), (10.051, 0)), ((10.051, 0), (13.311, 6.0)), ((13.311, 6.0), (13.311, 24)), ((0, 24), (13.311, 24)))
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
#text(10pt, weight: "bold")[First floor V7.1 · part 1 of 2 · W1 as six arched windows (V7.1): family part · west projection 1.55 m on three columns, the gallery and the family living glazed to the courtyard (W1, W2), west rooms 4.25 m wide · part 2 (office, gym, suite court, master suite): studies/ff_suite.typ]
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
    let label-at = ("Gallery (north part + on the projection)": (4.25, 11.0), "Bedroom 3": (2.225, 16.75), "Bedroom 2": (1.225, 11.6), "Bedroom 3 bath (en-suite)": (0.425, 15.75), "Kids' room (study + gaming)": (5.5, 2.25), "Family living": (5.6, 6.3), "Family bath (bed 1 + 2, family living)": (2.95, 9.65), "Wardrobe niche (bed 2)": (0.4, 10.75), "Linen cupboard": (3.25, 0.35), "Landing (stair top)": (1.4, 8.8), "Bedroom 1": (11.3, 5.0), "Family link": (9.55, 5.9))
    let short = ("Family bath (bed 1 + 2, family living)": "Bath", "Bedroom 3 bath (en-suite)": "Bath 3", "Kids' room (study + gaming)": "Kids' room", "Linen cupboard": "Linen", "Family link": "Link", "Gallery (north part + on the projection)": "Gallery", "Wardrobe niche (bed 2)": "niche")
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
    content(q((1.4, 8.1)), text(4.8pt, fill: red)[▲ stair top])
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
    - *Bedrooms:* 2 · #r2(area(room("Bedroom 2").pts)) m² · 3 · #r2(area(room("Bedroom 3").pts)) m² + its own bath #r2(area(room("Bedroom 3 bath").pts)) m² · 1 · #r2(area(room("Bedroom 1").pts)) m² (no bath). *Family bath* #r2(area(room("Family bath").pts)) m² for bedrooms 1 and 2, the family living and the kids' room.
    - *Walked to the family bath door:* bedroom 2 ≈ #r1(path-len("Bedroom 2 door → family bath door")) m · family living ≈ #r1(path-len("Family living → family bath door")) m · bedroom 1 ≈ #r1(path-len("Bedroom 1 door → family bath door")) m. Bedroom 3 → its own bath ≈ #r1(path-len("Bedroom 3 door → its own bath door")) m.
    #v(2pt)
    #text(6pt, fill: gray)[Plan: red = doors (thin = opening without a leaf) with swing line · blue = windows · blue dashed = drains · green = interfaces · brown dotted = ground floor below (the full courtyard and living floors) · grey dashed = the edge beam (x 5.6) and the three ground-floor columns · grey = neighbours · dashed boxes = furniture and fixtures.]
  ],
)

// ================= PAGE 2 · the projection and the rooms =================
#pagebreak()
#set text(size: 6.7pt)
#let bed2 = bbox(room("Bedroom 2").pts)
#let bath = bbox(room("Family bath").pts)
#let niche = bbox(room("Wardrobe niche").pts)
#text(15pt, weight: "bold", fill: green)[Family part · the west projection and the rooms]
#v(4pt)
#grid(columns: (1fr, 1fr), column-gutter: 18pt,
  [
    #H[The west projection · #r2(proj-x - 4.25) m over the courtyard and the double-height void]
    - *Where:* along the west edge of the courtyard and of the double-height living, x 4.25–#r2(proj-x), from the courtyard's north edge (y 6.5) to the living's south wall (y 19.25). The west rooms take the full band over the GF west band and riwaq; their west wall stands on the GF west wall.
    - *Widths:* rooms #r2(bed2.at(2) - bed2.at(0)) m on axes (≥ 4.0 m clear), gallery #r2(proj-x - bed2.at(2)) m (≥ 1.0 m clear).
    - *Carried on:* an edge beam along x #r2(proj-x) and #columns.len() columns, each in an existing wall or glass line, none free-standing in a room: column 1 in the women's majlis south wall (y 6.5), column 2 a pier in the glass between the courtyard and the living (y 13.0), column 3 in the living's south wall (y 19.25). On the ground floor it reads as a colonnade along the courtyard edge.
    - *Why columns and not a cantilever wall:* walls stand directly on walls; the earlier split projection (a west wall on cantilever beams, 0.11 m from the M line) was reverted.
    - *Gallery:* closed to the courtyard by the steel window W1 on the upstand of the edge beam (sill +3.82, guarding transom +4.70, head +6.75, four inward casements; V6.4, enclosure option A), wider at the stair top; every west room door opens from it; no room opens onto the stair landing. Clear 1.405 m (1.235 m at the three column sleeves Ø0.40).
    #v(3pt)
    #H[Kids' room · family living · bedroom 1]
    - *Kids' room* #r2(area(room("Kids").pts)) m²: two study desks + PC desk under the north window, a gaming corner (TV on the east wall), solid door from the gallery.
    - *Family living* #r2(area(seating.pts)) m²: a view, not a path; the walk to the family link passes behind and beside the sofa.
    - *Bedroom 1:* one room, no bath, its south wall straight on y 6.5; it uses the family bath.
    #v(3pt)
    #H[Family bath · #r3(bath.at(2) - bath.at(0)) × #r2(bath.at(3) - bath.at(1)) m, beside the west shaft]
    - WC on the shaft wall, shower, basin by the door; door from the gallery (opening in, swing clear), not onto the landing. For bedrooms 1 and 2, the family living and the kids' room. Its west wall is the shaft (x 1.5), its east wall the band's gallery wall.
  ],
  [
    #H[Bedroom 2 · #r2(bed2.at(2) - bed2.at(0)) × #r2(bed2.at(3) - bed2.at(1)) m + wardrobe niche #r3(niche.at(2) - niche.at(0)) m]
    - *Bed 1.4 × 2.0* with its head on the south wall and bedside tables on both sides; *wardrobes* in the niche beside the shaft and on the east wall; *desk* under the west window. Door from the gallery (swing clear), ≈ #r1(path-len("Bedroom 2 door → family bath door")) m from the family bath.
    #v(3pt)
    #H[Bedroom 3 · #r2(area(room("Bedroom 3").pts)) m² + its own bath #r2(area(room("Bedroom 3 bath").pts)) m²]
    - An entry with a wardrobe, then the room: *bed 1.4 × 2.0* head on the west wall with two bedside tables, wardrobe on the east wall, desk on the south wall. Door from the gallery (swing clear).
    - *Own bath (en-suite)* off its entry: shower, WC, basin; ≈ #r1(path-len("Bedroom 3 door → its own bath door")) m from the bedroom door. It stands *exactly over the GF family WC* (walls on the GF lines y 14.4 and 16.1).
    #v(3pt)
    #H[Gym route and the owner's office → the L study]
    - The gallery ends at y 19.25; from there the *gym route* and the *owner's office* belong to the L study (studies/ff_suite.typ), with the gym, the court and the suite.
    #v(3pt)
    #H[Interfaces with the L study (fixed)]
    - ① suite door at the end of the family link (y 6.5); ② bedroom 1 / suite: one straight wall on y 6.5; ③ the gallery's south end (y 19.25), where the gym route starts; ④ bedroom 3's south wall (y 19.25), a wall to the owner's office (no window).
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
    Stair top → every room, the suite door and the gallery's south end runs only on the landing, the gallery, the family link and the walking line through the living (checked: every door's approach is on circulation, no furniture in a route).
  ],
  [
    #H[Engineer]
    - *Projection:* #r2(proj-x - 4.25) m slab beyond x 4.25 along y 6.5–19.25; an *edge beam* on x #r2(proj-x) (spans ≈ 6.5 m and 6.25 m, depth to confirm; seen from the courtyard and the living, expressed as the colonnade's beam); #columns.len() *columns* down to their own foundations (sizes and pads to confirm).
    - *Ground floor* changes only by the columns, their foundations, the beam line and the lower ceiling under the projection.
    #v(3pt)
    #H[Walls off the ground-floor lines]
    Ground-floor lines here: #gf-lines.
    - *Off:* y 3.0 (kids' room / living, over the women's majlis); y 11.0 (family bath and niche / bedroom 2) and x 1.5 south of the shaft (niche); x #r3(bbox(room("Bedroom 3 bath").pts).at(2)) (bedroom 3 bath / entry).
    - *On:* y 14.4 and 16.1 (bedroom 3 bath = the GF family WC walls), x 1.5 / y 10.4 (shaft), y 6.5 (bedroom 1 / suite), *x 4.25* (the rooms' east wall, on the GF courtyard edge line), the outer walls.
    - The GF riwaq wall x 2.75 carries the floor; the rooms span over the riwaq.
    #v(3pt)
    #H[Drains (blue dashed)]
    - *Family bath:* WC on the west shaft wall, shower and basin in the bath floor to the shaft; floor over the GF utility room and hospitality kitchen, nothing in their ceilings.
    - *Bedroom 3 bath:* exactly over the GF family WC: WC straight into its stack, shower and basin in the floor build-up. Wet room on a wet room.
    - *Bedroom 1:* no bath. No east duct (the suite bath drains to a stack outside the east wall, see ff_suite.typ).
    #v(3pt)
    #H[Open items (all in docs/OPEN_ITEMS.md)]
    - *Engineer:* the edge beam and the #columns.len() columns at x #r2(proj-x) (sizes and foundations); walls off the GF lines.
    - *Gallery window W1* on the B3 upstand and *W2* on the family living's edge (black steel, divided lites, laminated glass below +4.70): the courtyard stays open to the sky, the house is closed round it (V6.4).
    - *Built-in cupboards in niches* (linen cupboard, bedroom 2 wardrobe niche): joinery boxes scribed to the walls; decide with the carpenter.
    - *Courtyard light:* a daylight study of the courtyard and the double-height living.
  ],
)

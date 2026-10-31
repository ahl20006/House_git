// ff_suite.typ · Taif / Palm House · FIRST FLOOR · focus study of the south wing and the MASTER SUITE (compile THIS file)
// 1 Nov 2026 (owner, studies/south_wing.typ): the south wing SWAPPED: the gym an L on the west and along the south, the suite court in the middle (2.5 m clear,
// four walls, one sliding door from the bedroom), the owner's office on the east beside the suite, entered from the gym (thumb-turn on the gym side, key on the
// office side) and by visitors from the external stair tower's landing (east wall). The pivoting TV panel is NOT applied: it does not fit beside the office door
// in the 2.1 m shared wall (the conflict and the options in studies/south_wing.typ § 2 / the report).
// First floor V6.3, part 2 of 2 (part 1: studies/ff_family.typ) · stand-alone: all data is in this file.
// Local coordinates (metres, x east, y SOUTH) = the main first-floor CSV coordinates (../data/rooms_ff.csv): no conversion.
// The room list is also in ../data/rooms_ff.csv (whole floor: design_ff.typ, which checks that both agree).
#import "@preview/cetz:0.4.2"
#set page(paper: "a4", flipped: true, margin: 10mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 7.2pt)

#let rect-pts(x0, y0, x1, y1) = ((x0, y0), (x1, y0), (x1, y1), (x0, y1))

// ---------- The focus zone (wall centre lines): the suite east of the courtyard / double-height living (x 8.95–13.311, y 6.5–24) + the suite court, the gym, the gym route and the office on the men's majlis roof ----------
#let zone = ((8.95, 6.5), (13.311, 6.5), (13.311, 24.0), (0, 24.0), (0, 19.25), (8.95, 19.25))
#let plan-scale = 0.68cm

// ---------- Neighbours (grey; the family part, fixed by studies/ff_family.typ) ----------
#let neighbours = (
  ("Bedroom 1", ((8.95, 1.0), (10.594, 1.0), (13.311, 6.0), (13.311, 6.5), (10.15, 6.5), (10.15, 5.3), (8.95, 5.3))),
  ("Family link", rect-pts(8.95, 5.3, 10.15, 6.5)),
  ("Family living", rect-pts(4.25, 3.0, 8.95, 6.5)),
  ("Courtyard sky (void)", rect-pts(5.6, 6.5, 8.95, 13.0)),
  ("Double-height living (void)", rect-pts(5.6, 13.0, 8.95, 19.25)),
  ("Gallery on the west projection", rect-pts(4.25, 6.5, 5.6, 19.25)),
  ("Bedroom 3", rect-pts(0, 16.1, 4.25, 19.25)),
)
// ground floor below (dotted)
#let below = (
  ([GF kitchen], rect-pts(8.95, 6.5, 13.311, 13.0)),
  ([GF living · dining], rect-pts(8.95, 13.0, 13.311, 19.25)),
  ([GF men's majlis], rect-pts(2.75, 19.25, 13.311, 24.0)),
)

// ---------- Interfaces with the family part (fixed by studies/ff_family.typ) ----------
#let interfaces = (
  (pts: ((8.95, 6.5), (10.15, 6.5)), label: [① suite door: from the family link], at: (8.85, 6.2), anchor: "east"),
  (pts: ((10.15, 6.5), (13.311, 6.5)), label: [② straight wall to bedroom 1 (y 6.5, on the GF kitchen wall)], at: (13.45, 6.5), anchor: "west"),
  (pts: ((4.25, 19.25), (5.6, 19.25)), label: [③ the gallery's south end → the gym (sliding door)], at: (5.7, 18.9), anchor: "west"),
  (pts: ((0, 19.25), (4.25, 19.25)), label: [④ bedroom 3's south wall: a double wall to the gym (≈ 55 dB)], at: (0.1, 18.6), anchor: "west"),
  (pts: ((13.311, 19.25), (13.311, 24.0)), label: [⑤ the external stair tower's office landing (visitors)], at: (13.45, 22.2), anchor: "west"),
)

// ---------- Rooms ----------
#let R(name, pts, col, parts: none) = (name: name, pts: pts, col: col, parts: if parts == none { (pts,) } else { parts })
#let rooms = (
  R("Suite lobby", rect-pts(8.95, 6.5, 10.3, 11.9), "circ"),
  R("Suite bath", ((10.3, 6.5), (12.211, 6.5), (12.211, 8.0), (13.311, 8.0), (13.311, 10.45), (10.3, 10.45)), "wet",
    parts: (rect-pts(10.3, 6.5, 12.211, 10.45), rect-pts(12.211, 8.0, 13.311, 10.45))),
  R("Suite WC (closet)", rect-pts(12.211, 6.5, 13.311, 8.0), "wet"),
  R("Suite dressing", rect-pts(10.3, 10.45, 13.311, 13.9), "suite"),
  R("Suite bedroom", ((8.95, 11.9), (10.3, 11.9), (10.3, 13.9), (13.311, 13.9), (13.311, 19.25), (8.95, 19.25)), "suite",
    parts: (rect-pts(8.95, 11.9, 10.3, 13.9), rect-pts(8.95, 13.9, 13.311, 19.25))),
  R("Suite court (open to the sky)", rect-pts(5.6, 19.25, 10.0, 21.9), "open"),       // 1 Nov 2026: 2.65 on axes = 2.5 m clear, four walls, one sliding door from the bedroom
  R("Owner's office", rect-pts(10.0, 19.25, 13.311, 24.0), "office"),               // 1 Nov 2026: east, beside the suite; visitors from the stair tower landing
  R("Gym", ((0, 19.25), (5.6, 19.25), (5.6, 21.9), (10.0, 21.9), (10.0, 24.0), (0, 24.0)), "gym",   // 1 Nov 2026: an L, the west part (treadmill) + the south arm along the facade
    parts: (rect-pts(0, 19.25, 5.6, 24.0), rect-pts(5.6, 21.9, 10.0, 24.0))),
)

// ---------- Doors: a, b, label, room, into (unit vector into that room), from ("circ", a room name, or "outside" = the family part), open = no leaf / sliding ----------
#let D(a, b, label, room, into, from: "circ", open: false, out: false) = (a: a, b: b, label: label, room: room, into: into, from: from, open: open, out: out)   // out = the leaf swings away from `into` (opens out of its room)
#let doors = (
  D((9.0, 6.5), (10.1, 6.5), [suite door], "Suite lobby", (0, 1), from: "outside"),
  D((10.3, 6.65), (10.3, 7.65), [bath], "Suite bath", (1, 0)),
  D((12.211, 6.8), (12.211, 7.8), [WC (opens out)], "Suite WC (closet)", (1, 0), from: "Suite bath", out: true),   // 1.00 m opening (V6.3); the leaf opens out into the bath, clear of the pan
  D((10.3, 10.6), (10.3, 11.6), [dressing], "Suite dressing", (1, 0)),
  D((9.05, 11.9), (10.05, 11.9), [bedroom], "Suite bedroom", (0, 1)),
  D((9.05, 19.25), (9.95, 19.25), [court (sliding, the only door)], "Suite court (open to the sky)", (0, 1), from: "Suite bedroom", open: true),
  D((4.3, 19.25), (5.55, 19.25), [gym, from the gallery (sliding)], "Gym", (0, 1), from: "outside", open: true),
  D((10.0, 22.95), (10.0, 23.8), [office ← gym (thumb-turn gym side · key office side)], "Owner's office", (1, 0), from: "Gym"),
  D((13.311, 22.9), (13.311, 23.75), [visitors' door from the stair tower landing (thumb-turn inside)], "Owner's office", (-1, 0), from: "outside"),
)

// ---------- The gym (owner, 1 Nov 2026): an L on the west and along the south; the treadmill on the west part against the outer (load-bearing) wall ----------
// a full-size home treadmill, ASSUMED Life Fitness T5 class: 2.03 × 0.84 m (belt 1.52 × 0.56); the manufacturer-type zone (ASTM F2115 / the manual): 2.0 m clear
// BEHIND the belt, 0.5 m each side; facing south to the window band, 0.5 m off the west wall face, 0.25 m off the south wall; no rigid contact with any wall.
#let tm-model = "Life Fitness T5 class (assumed): 2.03 × 0.84 m"
#let tm-len = 2.03
#let tm-wid = 0.84
#let tm-clear = 2.0           // behind
#let tm-side = 0.5            // each side
#let xc = 5.6                 // the court's west wall (rib B20 below)
#let xo = 10.0                // the court's east wall = the office's west wall (rib B21 below, the full 4.75 m)
#let yc = 21.9                // the court's south wall: a 100 mm partition on the slab (X6), high windows
#let gym-pts = rooms.find(r => r.name == "Gym").pts
#let west-clear = (0.125, 19.35, xc - 0.1, 24.0 - 0.125)            // the gym's west part inside its walls
#let south-clear = (xc + 0.1, yc + 0.05, xo - 0.1, 24.0 - 0.125)     // the south arm inside its walls
#let tm = (west-clear.at(0) + tm-side, west-clear.at(3) - 0.25 - tm-len, west-clear.at(0) + tm-side + tm-wid, west-clear.at(3) - 0.25)
#let tm-zones = (
  ("west side", (tm.at(0) - tm-side, tm.at(1), tm.at(0), tm.at(3)), west-clear),
  ("east side", (tm.at(2), tm.at(1), tm.at(2) + tm-side, tm.at(3)), west-clear),
  ("behind", (tm.at(0), tm.at(1) - tm-clear, tm.at(2), tm.at(1)), west-clear),
)
#let acoustic-wall = ((0, 19.25), (4.25, 19.25))   // shared with bedroom 3: a double wall, target Rw ≈ 55 dB airborne (200 dense block + an independent lined stud, DETAILS.md)
#let tm-front = 0.25          // the treadmill's gap to the south wall (presentation.typ reads tm-front)
#let arm-x0 = xo              // compatibility names (presentation.typ reads them; its sheet 05 text is stale until the presentation is rebuilt)
#let long-y0 = yc
#let arm-y0 = 19.25
#let gym-door = doors.find(d => d.room == "Gym")
#let gym-door-zone = (gym-door.a.at(0), 19.35, gym-door.b.at(0), 19.35 + 0.9)   // 0.9 m inside the sliding gym door
// the suite court: 2.5 m clear, tested with real outdoor furniture (a 2-seat sofa, two armchairs, a table) and two free strips to move
#let court-clear = (xc + 0.1, 19.35, xo - 0.1, yc - 0.05)
#let court-furniture = ((5.8, 19.6, 6.6, 21.2, [2-seat sofa 0.8 × 1.6]), (7.1, 21.0, 7.8, 21.7, [armchair 0.7]), (8.1, 21.0, 8.8, 21.7, [armchair 0.7]), (7.15, 20.2, 7.75, 20.8, [table Ø0.6]))
#let court-path = ((8.9, 19.35, 9.9, 21.85), (6.7, 19.35, 8.9, 20.1))   // free strips ≥ 0.75 wide: from the door south along the east wall, and west along the north wall to the sofa

// ---------- Furniture and fixtures (x0, y0, x1, y1, label) ----------
#let furniture = (
  // luxury bath, compact: WC in its own closet by the drain stack, walk-in glass shower on the east wall, freestanding tub by the east window, double vanity on the west (lobby) wall facing the east light, towel cupboard; the north wall kept clear as the path from the door to the WC closet
  (12.536, 6.95, 13.186, 7.4, [WC · shattaf]), (12.086, 8.1, 13.186, 9.5, [walk-in shower 1.1 × 1.4 (glass)]), (11.486, 9.6, 13.186, 10.35, [freestanding tub 1.7 × 0.75]),
  (10.4, 7.75, 10.95, 9.35, [double vanity 1.6 m · mirror]), (10.4, 9.75, 10.95, 10.35, [towels]),
  // dressing: wardrobes for two, make-up table and full mirror
  (12.586, 10.55, 13.186, 13.8, [his wardrobes 3.25 m (sliding)]), (10.4, 13.2, 12.5, 13.8, [her wardrobes 2.1 m (sliding)]), (11.3, 10.55, 12.5, 10.95, [shoes · bags display]), (10.4, 11.7, 10.95, 12.9, [make-up · full mirror]), (11.5, 11.85, 12.0, 12.35, [ottoman]),
  // bedroom: king bed on the dressing wall, facing south to the suite court; sitting corner on the solid west wall
  (10.9, 14.0, 12.7, 16.0, [king bed 1.8 × 2.0]), (10.4, 14.0, 10.85, 14.45, []), (12.75, 14.0, 13.186, 14.45, []),
  (9.05, 17.6, 10.6, 19.1, [sitting]),
  // owner's office (east, 1 Nov 2026): the desk faces the south window; a sofa on the suite wall; shelves on the east wall; the door swings kept clear
  (10.6, 20.9, 12.2, 21.7, [desk 1.6 × 0.8 · faces S]), (11.15, 20.35, 11.65, 20.85, []), (10.7, 21.9, 11.2, 22.4, []), (11.5, 21.9, 12.0, 22.4, []),
  (12.786, 19.45, 13.186, 22.7, [bookshelves]), (10.2, 19.45, 12.4, 20.05, [sofa 2.2]), (11.0, 23.3, 12.3, 23.8, [cabinet]),
  // suite court (2.5 m clear): the furniture test
  ..court-furniture,
  // gym (1 Nov 2026): the treadmill on the west part (floating floor / dense rubber, pads); pull-up bar on the north wall, barbell + rack and kettlebells at the south-west,
  // the cardio bike by the gallery door, the pilates mat and a bench in the south arm; a 1.0 m walkway from the gallery door to the office door kept free
  (tm.at(0), tm.at(1), tm.at(2), tm.at(3), [treadmill → S]),
  (2.4, 19.35, 3.6, 19.9, [pull-up bar (wall)]), (2.4, 22.4, 4.2, 23.75, [barbell · rack]), (4.5, 23.1, 5.4, 23.75, [kettlebells]), (4.5, 21.0, 5.2, 22.3, [cardio (bike)]),
  (6.2, 23.0, 8.0, 23.6, [pilates mat 1.8 × 0.6]), (8.5, 23.0, 9.7, 23.5, [bench]),
)
// fire safety (owner, 1 Nov 2026; studies/fire_escape.typ): the suite bedroom's east window is its escape window (hinged casements, no screen); the suite court is its fresh-air refuge
#let escape-windows = (("Suite bedroom", (13.311, 15.0), (13.311, 17.9)),)   // 1 Nov 2026: shortened from 18.6 to clear the stair tower's north wall (y 18.22)
#let windows = (((0, 19.6), (0, 20.9)), ((0, 22.0), (0, 23.5)), ((0.5, 24), (3.9, 24)), ((4.5, 24), (9.5, 24)), ((10.5, 24), (12.8, 24)), ((8.95, 7.6), (8.95, 9.6)), ((13.311, 9.5), (13.311, 10.05)), ((13.311, 15.0), (13.311, 17.9)),
  ((5.6, 19.6), (5.6, 20.9)), ((6.0, 21.9), (9.6, 21.9)), ((6.0, 19.25), (7.0, 19.25)), ((7.6, 19.25), (8.6, 19.25)))   // the gym's two windows onto the court (x 5.6, y 21.9) are HIGH LEVEL only (sill +1.8, 3d/params.yaml); the office: south window only (the tower covers its east wall)
#let drains = (
  (((12.86, 7.17), (13.311, 7.0)), [suite bath: WC, shower, tub and vanity to one stack outside the east wall]),
  (((12.6, 8.8), (13.05, 8.3), (13.05, 7.6), (13.311, 7.1)), []),
  (((12.3, 10.0), (13.1, 9.7), (13.1, 7.7), (13.311, 7.1)), []),
  (((10.7, 8.5), (11.6, 8.2), (12.4, 7.75), (13.311, 7.1)), []),
  (((7.2, 20.25), (6.0, 20.25)), [suite court: floor falls west to its drain]),
)

// ---------- Walking routes: (name, rect, wall allowance across it, what is deducted) ----------
#let routes = (
  ("Suite lobby", rect-pts(8.95, 6.5, 10.3, 11.9), 0.2, [½ wall each side]),
  ("Gym walkway (gallery door → south arm)", rect-pts(4.25, 19.25, 5.6, 21.0), 0.1, [between the court's west wall and the equipment]),
  ("Gym walkway (south arm → office door)", rect-pts(5.6, 21.9, 10.0, 22.95), 0.05, [along the court's south partition to the office door]),
)
#let paths = (
  ("Suite door → bedroom door", ((9.55, 6.5), (9.5, 11.9))),
  ("Suite door → bath door", ((9.55, 6.5), (9.55, 7.1), (10.3, 7.1))),
  ("Suite door → dressing door", ((9.55, 6.5), (9.55, 11.05), (10.3, 11.05))),
  ("Bedroom door → bath door", ((9.5, 11.9), (9.6, 7.1), (10.3, 7.1))),
  ("Bed → court door", ((11.8, 16.0), (11.8, 17.0), (10.0, 19.25))),
  ("Gallery end → office door", ((4.9, 19.25), (4.9, 22.4), (9.7, 22.4), (9.7, 23.375), (10.0, 23.375))),
  ("Office door → visitors' door", ((10.0, 23.375), (12.3, 23.0), (13.311, 23.3))),
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
#let inside(p, P) = {
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
// clear ≈ axes minus half a wall on every edge: 250 mm on the outer walls (x 13.311, y 24), nothing on open edges, 200 mm elsewhere
#let outer-edges = (((13.311, 6.0), (13.311, 24.0)), ((0, 24.0), (13.311, 24.0)), ((0, 19.25), (0, 24.0)))
#let open-edges = ()   // 1 Nov 2026: the court is walled on four sides at the floor level
#let edge-t(a, b) = {
  if open-edges.any(e => on-seg(a, ..e) and on-seg(b, ..e)) { 0.0 }
  else if outer-edges.any(e => on-seg(a, ..e) and on-seg(b, ..e)) { 0.25 }
  else { 0.2 }
}
#let clear-approx(P) = area(P) - range(P.len()).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, P.len())); dist(a, b) * edge-t(a, b) / 2 }).sum()
#let colours = (circ: rgb("#f2efe8"), suite: rgb("#efe0cf"), wet: rgb("#cfe6ef"), gym: rgb("#d9e4f2"), office: rgb("#e3e8d4"), open: rgb("#ffffff"))
#let green = rgb("#2f6b4f")
#let red = rgb("#b5452f")
#let room(n) = rooms.find(r => r.name == n)

// ---------- Checks ----------
#let issues = {
  let out = ()
  for r in rooms { if not r.pts.all(p => inside(p, zone)) { out.push(r.name + " leaves the zone") } }
  let parts = ()
  for r in rooms { for P in r.parts { parts.push((r.name, P)) } }
  for i in range(parts.len()) {
    for j in range(i + 1, parts.len()) {
      let (na, A) = parts.at(i); let (nb, B) = parts.at(j)
      if na != nb and box-overlap(bbox(A), bbox(B)) { out.push(na + " overlaps " + nb) }
    }
  }
  let free = area(zone) - rooms.map(r => area(r.pts)).sum()
  if calc.abs(free) > 0.01 { out.push("unassigned area " + r2(free) + " m²") }
  for (i, f) in furniture.enumerate() {
    let fb = (f.at(0), f.at(1), f.at(2), f.at(3))
    if not rooms.any(r => inside(((f.at(0) + f.at(2)) / 2, (f.at(1) + f.at(3)) / 2), r.pts) and r.col != "circ") { out.push("furniture " + repr(f.at(4)) + " not in a room") }
    for g in furniture.slice(i + 1) { if box-overlap(fb, (g.at(0), g.at(1), g.at(2), g.at(3))) { out.push("furniture " + repr(f.at(4)) + " overlaps " + repr(g.at(4))) } }
    for (n, P, w, t) in routes { if box-overlap(fb, bbox(P)) { out.push("furniture " + repr(f.at(4)) + " in the route " + n) } }
  }
  for d in doors.filter(d => not d.open) {
    let w = dist(d.a, d.b); let (ix, iy) = d.into
    let (ix, iy) = if d.out { (-ix, -iy) } else { (ix, iy) }   // a door that opens out swings on the other side of its line
    let sq = (d.a, d.b, (d.b.at(0) + ix * w, d.b.at(1) + iy * w), (d.a.at(0) + ix * w, d.a.at(1) + iy * w))
    for f in furniture { if box-overlap(bbox(sq), (f.at(0), f.at(1), f.at(2), f.at(3))) { out.push("door " + repr(d.label) + " swing hits " + repr(f.at(4))) } }
  }
  for r in rooms.filter(r => r.col != "circ") { if not doors.any(d => d.room == r.name) { out.push(r.name + " has no door") } }
  for d in doors.filter(d => d.from != "outside") {
    let m = mid(d.a, d.b)
    let p = (m.at(0) - d.into.at(0) * 0.3, m.at(1) - d.into.at(1) * 0.3)
    let ok = if d.from == "circ" { rooms.filter(r => r.col == "circ").any(r => inside(p, r.pts)) } else { inside(p, room(d.from).pts) }
    if not ok { out.push("door " + repr(d.label) + " not reached from " + d.from) }
  }
  // doors from the family part sit on an interface
  for d in doors.filter(d => d.from == "outside") {
    if not interfaces.any(i => i.pts.len() == 2 and on-seg(d.a, ..i.pts) and on-seg(d.b, ..i.pts)) { out.push("door " + repr(d.label) + " not on an interface") }
  }
  for (n, P, w, t) in routes {
    let (x0, y0, x1, y1) = bbox(P)
    if calc.min(x1 - x0, y1 - y0) - w < 1.0 - 1e-6 { out.push("route " + n + " under 1.0 m clear") }
  }
  // the treadmill: its clear zones inside the gym and free of furniture; the gym door's landing free
  if tm.at(0) < west-clear.at(0) + tm-side - 1e-6 or tm.at(3) > west-clear.at(3) + 1e-6 { out.push("treadmill clearances on the west part") }
  for f in court-furniture {
    if f.at(0) < court-clear.at(0) - 1e-6 or f.at(1) < court-clear.at(1) - 1e-6 or f.at(2) > court-clear.at(2) + 1e-6 or f.at(3) > court-clear.at(3) + 1e-6 { out.push("court furniture " + repr(f.at(4)) + " outside the court") }
    for s in court-path { if box-overlap(s, (f.at(0), f.at(1), f.at(2), f.at(3))) { out.push("court furniture " + repr(f.at(4)) + " in the moving strip") } }
  }
  if court-clear.at(3) - court-clear.at(1) < 2.5 - 1e-6 { out.push("suite court under 2.5 m clear") }
  for (n, z, within) in tm-zones {
    if z.at(0) < within.at(0) - 1e-6 or z.at(1) < within.at(1) - 1e-6 or z.at(2) > within.at(2) + 1e-6 or z.at(3) > within.at(3) + 1e-6 { out.push("treadmill zone " + n + " outside the gym") }
    let need = if n == "behind" { tm-clear } else { tm-side }
    if (if n == "behind" { z.at(3) - z.at(1) } else { z.at(2) - z.at(0) }) < need - 1e-6 { out.push("treadmill zone " + n + " under " + str(need) + " m") }
    for f in furniture.filter(f => f.at(4) != [treadmill → S]) { if box-overlap(z, (f.at(0), f.at(1), f.at(2), f.at(3))) { out.push(repr(f.at(4)) + " in the treadmill's " + n + " zone") } }
  }
  for f in furniture { if box-overlap(gym-door-zone, (f.at(0), f.at(1), f.at(2), f.at(3))) { out.push(repr(f.at(4)) + " blocks the gym door") } }
  // no window from the suite bedroom onto the double-height living (x 8.95, y 13–19.25)
  for (a, b) in windows { if calc.abs(a.at(0) - 8.95) < 1e-6 and calc.abs(b.at(0) - 8.95) < 1e-6 and calc.max(a.at(1), b.at(1)) > 13.0 and calc.min(a.at(1), b.at(1)) < 19.25 { out.push("window from the suite onto the double-height living") } }
  out
}
#let H(t) = text(9.5pt, weight: "bold", fill: green, t)

// ================= PAGE 1 · plan + rooms + checks =================
#text(15pt, weight: "bold", fill: green)[First floor · the south wing (gym west + south, the suite court, the office east) and the master suite]
#h(8pt) #text(8pt, fill: gray)[Taif / Palm House · first floor V6.3 · CSV coordinates (x east, y south) · wall centre lines · north up]
#v(-2pt)
#text(10pt, weight: "bold")[First floor V7.1 · part 2 of 2 (part 1: studies/ff_family.typ) · 1 Nov 2026: the gym an L on the west and the south (the treadmill on the west part), the suite court 2.5 m clear in the middle, the owner's office on the east beside the suite; the master suite unchanged]
#v(2pt)
#grid(columns: (auto, 1fr), column-gutter: 14pt,
  cetz.canvas(length: plan-scale, {
    import cetz.draw: *
    let poly(P, ..args) = line(..P.map(q), close: true, ..args)
    for (n, P) in neighbours {
      poly(P, fill: luma(238), stroke: (paint: luma(185), dash: "dashed"))
      let (x0, y0, x1, y1) = bbox(P)
      content(q(((x0 + x1) / 2, (y0 + y1) / 2)), box(width: (x1 - x0) * plan-scale * 0.95, align(center, text(5pt, fill: gray, n))))
    }
    for r in rooms { poly(r.pts, fill: colours.at(r.col), stroke: 0.6pt + rgb("#3d4a45")) }
    for (l, P) in below { poly(P, stroke: (paint: rgb("#8a5a2b"), dash: "dotted", thickness: 0.7pt)) }
    for (x0, y0, x1, y1, l) in furniture {
      rect(q((x0, y0)), q((x1, y1)), fill: white.transparentize(25%), stroke: (paint: luma(110), thickness: 0.4pt, dash: "dashed"))
      content(q(((x0 + x1) / 2, (y0 + y1) / 2)), angle: if (y1 - y0) > (x1 - x0) * 1.3 { 90deg } else { 0deg }, text(4.4pt, fill: luma(80), l))
    }
    let label-at = ("Suite lobby": (9.62, 10.6), "Suite bath": (11.5, 8.9), "Suite WC (closet)": (12.66, 7.75), "Suite dressing": (11.75, 12.85), "Suite bedroom": (11.5, 17.3), "Suite court (open to the sky)": (7.9, 19.55), "Gym": (3.1, 20.75), "Owner's office": (11.65, 22.55))
    for r in rooms {
      let (x0, y0, x1, y1) = bbox(r.pts)
      let c = label-at.at(r.name, default: ((x0 + x1) / 2, (y0 + y1) / 2))
      content(q(c), align(center, text(if r.name.starts-with("Suite WC") { 4.6pt } else { 5.8pt })[*#(if r.name.starts-with("Suite WC") { "WC" } else { r.name })*\ #r2(area(r.pts)) m²]))
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
      content(q(itf.at), anchor: itf.anchor, box(width: 3.2cm, align(if itf.anchor == "east" { right } else { left }, text(4.8pt, fill: rgb("#2f8a3f"), itf.label))))
    }
    for (P, l) in drains { line(..P.map(q), stroke: (paint: rgb("#1f7a99"), thickness: 0.8pt, dash: "dashed"), mark: (end: ">", fill: rgb("#1f7a99"), scale: 0.35)) }
    // the treadmill's clear zones (0.5 m) and its rubber floor
    for (n, z, w) in tm-zones { rect(q((z.at(0), z.at(1))), q((z.at(2), z.at(3))), fill: rgb("#fdf0d8"), stroke: (paint: rgb("#d08a00"), thickness: 0.3pt, dash: "dotted")) }
    line(q(acoustic-wall.at(0)), q(acoustic-wall.at(1)), stroke: 3pt + red)
    content(q((2.1, 19.0)), text(4.2pt, fill: red)[double wall ≈ 55 dB · gym ↔ bedroom 3])
    line(q((10.0, 21.9)), q((10.0, 24.0)), stroke: (paint: rgb("#c25b00"), thickness: 1.2pt, dash: "dashed")); content(q((10.2, 22.4)), anchor: "west", box(width: 1.6cm, text(4.0pt, fill: rgb("#c25b00"))[shared wall 2.1 m: the office door only; the pivoting TV panel does not fit beside it (not applied)]))
    line(q((13.436, 18.22)), q((16.036, 18.22)), q((16.036, 24.0)), q((13.436, 24.0)), stroke: (paint: luma(110), thickness: 0.8pt, dash: "dashed")); content(q((14.75, 21.0)), angle: 90deg, text(4.4pt, fill: luma(90))[external stair tower (outside)])
    // the bed's view: south to the suite court
    line(q((10.0, 16.1)), q((10.0, 20.2)), stroke: (paint: rgb("#2f8a3f"), thickness: 0.6pt, dash: "dotted"), mark: (end: ">", fill: rgb("#2f8a3f"), scale: 0.4))
    content(q((9.3, 20.6)), box(width: 1.1cm, align(center, text(3.8pt, fill: luma(90))[2.5 clear · 4 walls · open to the sky · high windows only from the gym])))
    content(q((8.85, 16.0)), anchor: "east", box(width: 1.9cm, align(right, text(4.6pt, fill: red)[solid wall: no window onto the double-height living])))
    line(q((2.75, 25.0)), q((4.75, 25.0)), stroke: 1.2pt)
    content(q((3.75, 25.4)), text(5.5pt)[2 m])
  }),
  [
    #H[Rooms]
    #table(columns: (auto, auto, auto, auto), stroke: none, inset: 2pt, fill: (_, y) => if calc.even(y) { rgb("#efece4") },
      [*Room*], [*Axes w × d (m)*], [*Axes m²*], [*≈ clear m²*],
      ..rooms.map(r => {
        let (x0, y0, x1, y1) = bbox(r.pts)
        ([#r.name], [#if is-rect(r.pts) [#r2(x1 - x0) × #r2(y1 - y0)] else [polygon]], [#r2(area(r.pts))], [#if r.col == "open" [–] else [#r2(clear-approx(r.pts))]])
      }).flatten(),
      [*Zone*], [], [*#r2(area(zone))*], [],
    )
    #text(5.8pt, fill: gray)[Clear ≈ axes minus half a wall on every edge (250 mm outer, 200 mm inner, nothing on open edges), corners ignored.]
    #v(2pt)
    #if issues.len() == 0 { text(fill: green, weight: "bold")[✓ All rooms inside the zone · no overlaps · no unassigned area · furniture inside its room, not overlapping, out of the lobby route and the gym walkways · the treadmill on the west part with its manufacturer zone (#r2(tm-side) m each side, #r2(tm-clear) m free behind), the gym door free · the suite court #r2(court-clear.at(3) - court-clear.at(1)) m clear with its furniture test · doors reached] } else { std.block(fill: rgb("#fbe3dd"), inset: 5pt, radius: 2pt)[#text(fill: red, weight: "bold")[ISSUES]\ #issues.map(i => [• #i]).join(linebreak())] }
    #v(3pt)
    #H[Key numbers]
    - *Suite:* lobby #r2(area(room("Suite lobby").pts)) · bath #r2(area(room("Suite bath").pts)) + WC closet #r2(area(room("Suite WC (closet)").pts)) · dressing #r2(area(room("Suite dressing").pts)) · bedroom #r2(area(room("Suite bedroom").pts)) = *#r2(area(room("Suite lobby").pts) + area(room("Suite bath").pts) + area(room("Suite WC (closet)").pts) + area(room("Suite dressing").pts) + area(room("Suite bedroom").pts)) m² indoors* + the suite court #r2(area(room("Suite court (open to the sky)").pts)) m².
    - *Gym* #r2(area(room("Gym").pts)) m² on axes (≈ #r2(clear-approx(room("Gym").pts)) clear) · *suite court* #r2(area(room("Suite court (open to the sky)").pts)) m² (#r2(court-clear.at(2) - court-clear.at(0)) × #r2(court-clear.at(3) - court-clear.at(1)) clear) · *owner's office* #r2(area(room("Owner's office").pts)) m² (≈ #r2(clear-approx(room("Owner's office").pts)) clear).
    - *Walked:* suite door → bedroom door ≈ #r1(path-len("Suite door → bedroom door")) m · bedroom door → bath door ≈ #r1(path-len("Bedroom door → bath door")) m · bed → court ≈ #r1(path-len("Bed → court door")) m.
    - *Interfaces with the family part (green, fixed):* ① suite door at the end of the family link; ② the straight wall to bedroom 1 on y 6.5; ③ the gallery's south end: the gym's sliding door; ④ bedroom 3's south wall: the double wall to the gym; ⑤ the external stair tower's landing: the visitors' door to the office.
    #v(2pt)
    #text(6pt, fill: gray)[Plan: red = doors (thin = sliding / no leaf) with swing line · blue = windows · blue dashed = drains · green = interfaces · brown dotted = ground floor below · grey = the family part (fixed) · dashed boxes = furniture and fixtures.]
  ],
)

// ================= PAGE 2 · rooms, drains, walls, questions =================
#pagebreak()
#set text(size: 6.9pt)
#let bb(n) = bbox(room(n).pts)
#let wd(n) = { let (x0, y0, x1, y1) = bb(n); r2(x1 - x0) + " × " + r2(y1 - y0) }
#text(15pt, weight: "bold", fill: green)[Master suite, suite court, gym and office · rooms, drains, walls, questions]
#v(4pt)
#grid(columns: (1fr, 1fr), column-gutter: 18pt,
  [
    #H[Suite lobby · #wd("Suite lobby") m]
    - The suite door (from the family link) opens into a distributor: bath, dressing and bedroom each open off it; nobody walks through the dressing. A window onto the courtyard on its west wall.
    - *Bent entry:* the bedroom door is at the lobby's south end, round the corner of the dressing: the bed is not seen from the suite door.
    #v(3pt)
    #H[Suite bath (luxury, compact) · #r2(area(room("Suite bath").pts) + area(room("Suite WC (closet)").pts)) m² incl. its WC closet]
    - *Freestanding tub* along the south wall by an east window; *walk-in glass shower* on the east wall; *double vanity* on the west (lobby) wall facing the window light; *towel cupboard*; open floor in the middle.
    - *Door* from the lobby at the north end of the west wall, opening in, swing clear; the north wall stays clear as the path from the door to the WC closet.
    - *WC in its own closet* (#wd("Suite WC (closet)") m, sliding door) in the north-east corner, at the drain stack, with a shattaf.
    #v(3pt)
    #H[Suite dressing (walk-in) · #wd("Suite dressing") m]
    - Door from the lobby at the north end of its west wall. *His wardrobes* along the east wall and *her wardrobes* along the south wall, both sliding; a shoe and bag display on the north wall; a make-up table with a full-length mirror on the west wall; an ottoman. No window: good lighting inside the wardrobes.
    #v(3pt)
    #H[Suite bedroom · #r2(area(room("Suite bedroom").pts)) m²]
    - *King bed* 1.8 × 2.0 on the dressing wall, facing south to the suite court; bedside tables; a sitting corner on the solid west wall.
    - *West wall solid:* the double-height living is behind it, no window (checked). Windows east and the sliding door to the court (south).
    #v(3pt)
    #H[Suite court · #wd("Suite court (open to the sky)") m on axes, #r2(court-clear.at(2) - court-clear.at(0)) × #r2(court-clear.at(3) - court-clear.at(1)) clear, walled on four sides, open to the sky]
    - #r2(area(room("Suite court (open to the sky)").pts)) m² on axes (#r2((court-clear.at(2) - court-clear.at(0)) * (court-clear.at(3) - court-clear.at(1))) m² clear), *2.5 m deep clear* (owner's priority 1), from the bedroom only (a 0.9 m sliding door at x 9.05–9.95, the only door). Walled on all four sides: north the double-height living (the clerestory windows) and the suite bedroom, west the gym's west part (x 5.6, one high window, sill +1.8), south the gym's south arm (y 21.9, a 100 mm partition with high windows, sill +1.8), east the office (x 10.0, solid, no window).
    - *Furniture test:* a 2-seat sofa (0.8 × 1.6) along the west wall, two armchairs (0.7) against the south wall, a table Ø0.6 between them: seating for four, with a free strip ≥ 0.75 m from the door south along the east wall and west along the north wall (checked, no overlap).
    - *Clerestory windows* of the double-height living (in its south wall y 19.25): their sill stays above eye level from the court floor (or obscured glass). The gym's south arm roof edge (R6, y 21.9) is a *railing, not a parapet*, to keep the winter sun on them: with the court 2.65 m on axes the winter noon sun now reaches the whole window height (light check on design_ff.pdf).
    - *Open to the sky:* waterproofing on the men's majlis roof slab, the floor falling *west* to its drain; the clerestory windows and the bedroom door open for air in summer.
  ],
  [
    #H[Gym · an L, #r2(area(room("Gym").pts)) m² on axes (west part #r2(xc) × 4.75 + south arm #r2(xo - xc) × #r2(24.0 - yc)), ≈ #r2(clear-approx(room("Gym").pts)) m² clear]
    - *Owner's decision (1 Nov 2026):* the gym takes the west part (x 0–#r2(xc)) and the south arm along the facade (y #r2(yc)–24, #r2(south-clear.at(3) - south-clear.at(1)) m clear deep: narrowed from 2.75 to give the court its 2.5 m); the sliding door from the gallery end at its north-east corner; windows west (two) and the south band x 0.5–9.5; onto the court *high-level windows only* (sill +1.8).
    - *Treadmill* (#tm-model) on the west part, *facing south*, #r2(tm-side) m clear each side and *#r2(tm-clear) m free behind it* (the manufacturer-type zone), 0.5 m off the west outer wall face: the slab's west edge over the foyer's load-bearing west wall, the stiffest strip of the wing, with a thickened rib B19 (x 1.05) under it; a floating floor (or dense rubber tiles) and anti-vibration pads (X6); no rigid contact with the walls.
    - *Acoustics (mandatory):* the *double wall to bedroom 3* (y 19.25, x 0–4.25, red): 200 mm dense block + an independent stud lining with mineral wool, two layers of acoustic board, target *Rw ≈ 55 dB* airborne (≈ 50 dB on site), sealed at the top, no sockets back to back; the gallery's sliding door is the gym's only opening to the family part. The gym's south arm shares 2.1 m of wall with the office (200 mm block, ≈ 50 dB): the *pivoting TV panel is NOT applied* there: 0.3 m from R6's bearing + a 1.45 m panel + the 0.85 m door need ≈ 2.9 m of wall; the options are in the report (a fixed TV on each side, or a court 2.0 m deep as in the study).
    - *Also:* pull-up bar on the north wall, barbell + rack and kettlebells at the south-west, the cardio bike by the gallery door, the pilates mat and a bench in the south arm; a 1.0 m walkway from the gallery door past the court's walls to the office door (checked, nothing in it).
    #v(3pt)
    #H[Owner's office · #wd("Owner's office") m on axes, #r2(area(room("Owner's office").pts)) m² (≈ #r2(clear-approx(room("Owner's office").pts)) m² clear) · east, beside the suite]
    - Over the men's majlis roof (east end); its east wall is the outer wall, its west wall x #r2(xo) stands on the rib B21. The desk faces the south window (x 10.5–12.8); a sofa on the suite wall (quiet: the office, not the gym, is the suite's neighbour now); bookshelves on the east wall; a cabinet south-west.
    - *Doors:* from the gym's south arm (0.85, hinged, opening into the office: free exit from the gym side with a *thumb-turn*, *key only* from the office side, so visitors cannot enter the house) and the *visitors' door* in the east wall (y 22.9–23.75) from the external stair tower's landing at +3.60 (a thumb-turn inside). No door onto the court. No east window (the tower covers the east wall).
    #v(3pt)
    #H[Drains (blue dashed) · no east duct]
    - *Suite bath:* all fixtures drain east in a *sunken bath floor* to one *stack on the outside face of the east wall*, down to the east-yard manhole where the kitchen already drains. Nothing hangs in the GF kitchen ceiling; the hood on the GF east wall stays clear of the stack (south of y ≈ 7.5).
    - No drain over the master bedroom. The suite court drains to its own floor drain.
    #v(3pt)
    #H[Walls (engineer)]
    - *On GF lines:* y 6.5 (bedroom 1 / suite: the GF kitchen's north wall), the outer walls, x 8.95 (courtyard / double-height living). The suite bedroom spans the GF kitchen / living wall (y 13.0) with no wall above it.
    - *Off the GF lines:* x 10.3, y 10.45, x 12.211 and y 8.0, y 11.9 and y 13.9, all over the GF kitchen; on the men's majlis roof (1 Nov 2026): x #r2(xc) (gym west part / court) on the rib B20, *x #r2(xo)* (court / office and gym / office) on a new full-length rib B21, y #r2(yc) (court / gym south arm) a 100 mm partition across the ribs; the court's roof edge R6 (4.4 m) on the two walls: *X5 revised, not verified* (studies/structure.typ).
    - *Loads and vibration* of the gym (treadmill) and the office over the men's majlis: engineer.
    #v(3pt)
    #H[Questions for the owner]
    + *Bedroom:* king bed facing the court, or another arrangement (TV wall, sitting area)?
    + *Suite court:* #r2(area(room("Suite court (open to the sky)").pts)) m², 2.5 m clear with seating for four: confirm the furniture; clerestory privacy (sill height or obscured glass) to settle.
  ],
)

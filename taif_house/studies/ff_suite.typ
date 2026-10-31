// ff_suite.typ · Taif / Palm House · FIRST FLOOR · focus study of the south wing and the MASTER SUITE (compile THIS file)
// SOUTH WING v2 (owner, 1 Nov 2026): the gym on the WEST band only (x 0–4.25, over the ground-floor guest block, inside the column frame C6 / C13 / C19 – C7 / C14 / C20)
// with a small entrance nib at the gallery end (x 4.25–5.8, y 19.25–20.55: the gym and the gallery only touch at a corner); the suite court in the middle
// (x 4.25–10.0, open to the sky, four sides); the owner's office on the east (x 10.0–13.311) beside the suite bedroom, NO door between them; visitors from the
// external stair tower. The three court doors (bedroom, gym, office) on the court's north edge along a 1.2 m movement strip; the seating in the south part.
// One fixed TV in the office and one in the gym (no pivoting panel). First floor, part 2 of 2 (part 1: studies/ff_family.typ) · stand-alone: all data is in this file.
// Local coordinates (metres, x east, y SOUTH) = the main first-floor CSV coordinates (../data/rooms_ff.csv): no conversion.
// The room list is also in ../data/rooms_ff.csv (whole floor: design_ff.typ, which checks that both agree).
#import "@preview/cetz:0.4.2"
#set page(paper: "a4", flipped: true, margin: 10mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 7.2pt)

#let rect-pts(x0, y0, x1, y1) = ((x0, y0), (x1, y0), (x1, y1), (x0, y1))

// ---------- The focus zone (wall centre lines): the suite east of the courtyard / double-height living (x 8.95–13.311, y 6.5–24) + the south wing on the men's majlis roof / the guest block ----------
#let zone = ((8.95, 6.5), (13.311, 6.5), (13.311, 24.0), (0, 24.0), (0, 19.25), (8.95, 19.25))
#let plan-scale = 0.62cm

// ---------- Neighbours (grey; the family part, fixed by studies/ff_family.typ) ----------
#let neighbours = (
  ("Bedroom 1", ((8.95, 1.0), (10.594, 1.0), (13.311, 6.0), (13.311, 6.5), (10.15, 6.5), (10.15, 5.3), (8.95, 5.3))),
  ("Family link", rect-pts(8.95, 5.3, 10.15, 6.5)),
  ("Family living", rect-pts(4.25, 3.0, 8.95, 6.5)),
  ("Courtyard sky (void)", rect-pts(5.8, 6.5, 8.95, 13.0)),
  ("Double-height living (void)", rect-pts(5.8, 13.0, 8.95, 19.25)),
  ("Gallery on the west projection", rect-pts(4.25, 6.5, 5.8, 19.25)),
  ("Bedroom 3", rect-pts(0, 16.1, 4.25, 19.25)),
)
// ground floor below (dotted)
#let below = (
  ([GF kitchen], rect-pts(8.95, 6.5, 13.311, 13.0)),
  ([GF living · dining], rect-pts(8.95, 13.0, 13.311, 19.25)),
  ([GF men's majlis], rect-pts(2.75, 19.25, 13.311, 24.0)),
  ([GF guest block (foyer, basins, passage)], rect-pts(0, 19.25, 2.75, 24.0)),
)

// ---------- Interfaces with the family part (fixed by studies/ff_family.typ) ----------
#let interfaces = (
  (pts: ((8.95, 6.5), (10.15, 6.5)), label: [① suite door: from the family link], at: (8.85, 6.2), anchor: "east"),
  (pts: ((10.15, 6.5), (13.311, 6.5)), label: [② straight wall to bedroom 1 (y 6.5, on the GF kitchen wall)], at: (13.45, 6.5), anchor: "west"),
  (pts: ((4.25, 19.25), (5.6, 19.25)), label: [③ the gallery's south end → the gym's entrance nib (sliding door)], at: (4.4, 18.75), anchor: "west"),
  (pts: ((0, 19.25), (4.25, 19.25)), label: [④ bedroom 3's south wall: a double wall to the gym (Rw ≈ 55 dB)], at: (0.1, 18.4), anchor: "west"),
  (pts: ((13.311, 19.25), (13.311, 24.0)), label: [⑤ the external stair tower's office landing (visitors)], at: (13.45, 22.2), anchor: "west"),
)

// ---------- Rooms ----------
#let xg = 4.25               // the gym's east wall = the court's west wall (beam B19 on C19 – C20 below)
#let xn = 5.8                // the nib's east wall (from column C23 south)
#let yn = 20.55              // the nib's south wall
#let xo = 10.0               // the court's east wall = the office's west wall (non-load-bearing, on rib B21)
#let R(name, pts, col, parts: none) = (name: name, pts: pts, col: col, parts: if parts == none { (pts,) } else { parts })
#let rooms = (
  R("Suite lobby", rect-pts(8.95, 6.5, 10.3, 11.9), "circ"),
  R("Suite bath", ((10.3, 6.5), (12.211, 6.5), (12.211, 8.0), (13.311, 8.0), (13.311, 10.45), (10.3, 10.45)), "wet",
    parts: (rect-pts(10.3, 6.5, 12.211, 10.45), rect-pts(12.211, 8.0, 13.311, 10.45))),
  R("Suite WC (closet)", rect-pts(12.211, 6.5, 13.311, 8.0), "wet"),
  R("Suite dressing", rect-pts(10.3, 10.45, 13.311, 13.9), "suite"),
  R("Suite bedroom", ((8.95, 11.9), (10.3, 11.9), (10.3, 13.9), (13.311, 13.9), (13.311, 19.25), (8.95, 19.25)), "suite",
    parts: (rect-pts(8.95, 11.9, 10.3, 13.9), rect-pts(8.95, 13.9, 13.311, 19.25))),
  R("Gym", ((0, 19.25), (xn, 19.25), (xn, yn), (xg, yn), (xg, 24.0), (0, 24.0)), "gym",          // v2: the west band + the entrance nib
    parts: (rect-pts(0, 19.25, xg, 24.0), rect-pts(xg, 19.25, xn, yn))),
  R("Suite court (open to the sky)", ((xg, yn), (xn, yn), (xn, 19.25), (xo, 19.25), (xo, 24.0), (xg, 24.0)), "open",   // v2: from the gym to the office
    parts: (rect-pts(xn, 19.25, xo, 24.0), rect-pts(xg, yn, xn, 24.0))),
  R("Owner's office", rect-pts(xo, 19.25, 13.311, 24.0), "office"),
)

// ---------- Doors: a, b, label, room, into (unit vector into that room), from ("circ", a room name, or "outside" = the family part), open = no leaf / sliding ----------
// escape: the gym → court door swings INTO the court, the court → office door INTO the office, the visitors' door OUT onto the stair landing: each opens in the escape direction
#let D(a, b, label, room, into, from: "circ", open: false, out: false, lock: none) = (a: a, b: b, label: label, room: room, into: into, from: from, open: open, out: out, lock: lock)
#let doors = (
  D((9.0, 6.5), (10.1, 6.5), [suite door], "Suite lobby", (0, 1), from: "outside"),
  D((10.3, 6.65), (10.3, 7.65), [bath], "Suite bath", (1, 0)),
  D((12.211, 6.8), (12.211, 7.8), [WC (sliding)], "Suite WC (closet)", (1, 0), from: "Suite bath", open: true),   // 1.00 m opening (V6.3); v2: SLIDING (as the study text says): a hinged leaf opening into the bath clashed with the bath door's swing
  D((10.3, 10.6), (10.3, 11.6), [dressing], "Suite dressing", (1, 0)),
  D((9.05, 11.9), (10.05, 11.9), [bedroom], "Suite bedroom", (0, 1)),
  D((4.35, 19.25), (5.45, 19.25), [gym, from the gallery end (sliding)], "Gym", (0, 1), from: "outside", open: true),
  D((9.05, 19.25), (9.95, 19.25), [court (sliding glass)], "Suite court (open to the sky)", (0, 1), from: "Suite bedroom", open: true, lock: "free from the bedroom side"),
  D((xn, 19.5), (xn, 20.4), [court (from the gym)], "Suite court (open to the sky)", (1, 0), from: "Gym", lock: "free from the gym side, no key"),
  D((xo, 19.5), (xo, 20.35), [office (from the court)], "Owner's office", (1, 0), from: "Suite court (open to the sky)", lock: "free from the court side; key only from the office side"),
  D((13.311, 22.9), (13.311, 23.75), [visitors' door (stair landing)], "Owner's office", (-1, 0), from: "outside", out: true, lock: "thumb-turn inside; key outside"),
)

// ---------- The gym (v2): the west band, inside the column frame; the treadmill along the 4.75 m length on the stiff 2.75 m solid bay next to the outer wall ----------
// a full-size home treadmill, ASSUMED Life Fitness T5 class: 2.03 × 0.84 m (belt 1.52 × 0.56); the manufacturer-type zone (ASTM F2115 / the manual): 2.0 m clear
// BEHIND the belt, 0.5 m each side; facing south to the TV and the window, 0.5 m off the west wall face, 0.25 m off the south wall; no rigid contact with any wall.
#let tm-model = "Life Fitness T5 class (assumed): 2.03 × 0.84 m"
#let tm-len = 2.03
#let tm-wid = 0.84
#let tm-clear = 2.0           // behind
#let tm-side = 0.5            // each side
#let tm-front = 0.25          // the treadmill's gap to the south wall
#let west-clear = (0.125, 19.35, xg - 0.1, 24.0 - 0.125)            // the gym's west band inside its walls (4.025 × 4.525)
#let tm = (west-clear.at(0) + tm-side, west-clear.at(3) - tm-front - tm-len, west-clear.at(0) + tm-side + tm-wid, west-clear.at(3) - tm-front)
#let tm-zones = (
  ("west side", (tm.at(0) - tm-side, tm.at(1), tm.at(0), tm.at(3)), west-clear),
  ("east side", (tm.at(2), tm.at(1), tm.at(2) + tm-side, tm.at(3)), west-clear),
  ("behind", (tm.at(0), tm.at(1) - tm-clear, tm.at(2), tm.at(1)), west-clear),
)
#let acoustic-wall = ((0, 19.25), (xg, 19.25))   // shared with bedroom 3: a double wall, target Rw ≈ 55 dB airborne (200 dense block + an independent lined stud, DETAILS.md)
#let arm-x0 = xo              // compatibility names (presentation.typ)
#let long-y0 = yn
#let arm-y0 = 19.25
#let gym-door = doors.find(d => d.room == "Gym")
#let gym-door-zone = (gym-door.a.at(0), 19.35, gym-door.b.at(0), 19.35 + 0.9)   // 0.9 m inside the sliding gym door
// ---------- The suite court (v2): the movement strip along the north edge (the three doors), the seating in the south part ----------
#let court-clear = (xg + 0.1, 19.35, xo - 0.1, 24.0 - 0.125)        // 5.55 × 4.525 (the nib cuts its north-west corner)
#let court-clear-area = (court-clear.at(2) - court-clear.at(0)) * (court-clear.at(3) - court-clear.at(1)) - (xn + 0.1 - court-clear.at(0)) * (yn + 0.1 - court-clear.at(1))
#let court-strip = (xn + 0.1, 19.35, xo - 0.1, 20.55)                 // 1.2 m clear in front of the three doors
#let court-furniture = (
  (6.0, 22.95, 8.2, 23.8, [3-seat sofa 2.2 × 0.85]), (5.0, 21.7, 5.75, 22.45, [armchair]), (8.45, 21.7, 9.2, 22.45, [armchair]), (6.5, 21.95, 7.7, 22.65, [table 1.2 × 0.7]),
  (4.4, 23.2, 5.0, 23.8, [plant]), (9.25, 23.2, 9.85, 23.8, [plant]), (4.4, 20.75, 5.0, 21.35, [tree pot]),
)
#let court-path = (court-strip, (xn + 0.1, 20.55, xo - 0.1, 21.6))   // the strip + the approach band to the seating (≥ 1.0 m)
#let court-drains = (((xn + 0.1, 19.45), (xn + 0.1, 20.45)), ((9.0, 19.4), (10.0, 19.4)), ((xo - 0.15, 19.45), (xo - 0.15, 20.4)))   // linear drains in front of the three doors (near-flush thresholds)
#let court-gutter = ((xg + 0.2, 23.75), (xo - 0.2, 23.75))          // the box gutter along the south side; the overflow spout through the south wall at x 7.1

// ---------- Privacy without a screen: the sight lines into the suite bedroom through its open court door ----------
#let bed = (10.9, 14.0, 12.7, 16.0)
#let entry-wardrobe = (10.0, 16.85, 10.6, 19.15)                     // the smallest fix: a full-height wardrobe 0.6 × 2.3 east of the court door, forming an entry zone x 8.95–10.0 (1.9 m long still showed the bed's head end from the sofa)
#let bed-door = (x0: 9.05, x1: 9.95, y-out: 19.25, y-in: 19.05)
#let sees-bed(E, blockers) = {
  let hit = false
  for k in range(61) {
    let px = bed-door.x0 + (bed-door.x1 - bed-door.x0) * k / 60
    let dx = px - E.at(0)
    let dy = bed-door.y-out - E.at(1)
    let xi = E.at(0) + dx * (bed-door.y-in - E.at(1)) / dy
    if xi >= bed-door.x0 - 1e-9 and xi <= bed-door.x1 + 1e-9 {
      for s in range(1, 120) {
        let y = bed-door.y-in - s * 0.05
        let x = E.at(0) + dx * (y - E.at(1)) / dy
        if y < 13.95 or x < 9.05 or x > 13.21 { break }
        if blockers.any(b => x > b.at(0) and x < b.at(2) and y > b.at(1) and y < b.at(3)) { break }
        if x > bed.at(0) and x < bed.at(2) and y > bed.at(1) and y < bed.at(3) { hit = true; break }
      }
    }
  }
  hit
}
#let eyes = (
  ([the gym's court door (open), standing in it], (xn + 0.15, 19.95)),
  ([the office's court door (open), standing in it], (xo - 0.05, 19.95)),
  ([the court seating: the sofa], (7.1, 23.35)),
  ([the court seating: the west armchair], (5.4, 22.1)),
  ([the court seating: the east armchair], (8.8, 22.1)),
  ([the court seating: the table], (7.1, 22.3)),
)
#let sight = eyes.map(((l, E)) => (l, sees-bed(E, ()), sees-bed(E, (entry-wardrobe,))))

// ---------- Furniture and fixtures (x0, y0, x1, y1, label) ----------
#let furniture = (
  // luxury bath, compact: WC in its own closet by the drain stack, walk-in glass shower on the east wall, freestanding tub by the east window, double vanity on the west (lobby) wall facing the east light, towel cupboard; the north wall kept clear as the path from the door to the WC closet
  (12.536, 6.95, 13.186, 7.4, [WC · shattaf]), (12.086, 8.1, 13.186, 9.5, [walk-in shower 1.1 × 1.4 (glass)]), (11.486, 9.6, 13.186, 10.35, [freestanding tub 1.7 × 0.75]),
  (10.4, 7.75, 10.95, 9.35, [double vanity 1.6 m · mirror]), (10.4, 9.75, 10.95, 10.35, [towels]),
  // dressing: wardrobes for two, make-up table and full mirror
  (12.586, 10.55, 13.186, 13.8, [his wardrobes 3.25 m (sliding)]), (10.4, 13.2, 12.5, 13.8, [her wardrobes 2.1 m (sliding)]), (11.3, 10.55, 12.5, 10.95, [shoes · bags display]), (10.4, 11.7, 10.95, 12.9, [make-up · full mirror]), (11.5, 11.85, 12.0, 12.35, [ottoman]),
  // bedroom: king bed on the dressing wall facing south; the entry wardrobe east of the court door (the entry zone, the bed out of sight); the sitting corner by the east window
  (10.9, 14.0, 12.7, 16.0, [king bed 1.8 × 2.0]), (10.4, 14.0, 10.85, 14.45, []), (12.75, 14.0, 13.186, 14.45, []),
  (entry-wardrobe.at(0), entry-wardrobe.at(1), entry-wardrobe.at(2), entry-wardrobe.at(3), [wardrobe · entry zone]),
  (10.9, 18.0, 12.4, 19.1, [sitting]),
  // owner's office (east): the desk faces the south window; a sofa on the suite wall; shelves on the east wall; one fixed TV on the court wall; the door swings kept clear
  (10.6, 20.9, 12.2, 21.7, [desk 1.6 × 0.8 · faces S]), (11.15, 20.35, 11.65, 20.85, []), (10.7, 21.9, 11.2, 22.4, []), (11.5, 21.9, 12.0, 22.4, []),
  (12.786, 19.45, 13.186, 22.7, [bookshelves]), (10.95, 19.45, 12.65, 20.05, [sofa 1.7]), (11.0, 23.3, 12.3, 23.8, [cabinet]), (10.1, 21.0, 10.2, 22.2, [TV (office)]),
  // the suite court: the furniture test (seating for five, a table, plants)
  ..court-furniture,
  // gym (v2): the treadmill along the length on the west bay, facing the TV on the south wall; a power rack with the barbell and the pull-up bar, kettlebells, the bike, the pilates mat
  (tm.at(0), tm.at(1), tm.at(2), tm.at(3), [treadmill → S]), (0.45, 23.775, 1.65, 23.875, [TV (gym)]),
  (2.05, 22.35, 4.15, 23.75, [power rack · barbell · pull-up bar]), (2.1, 21.3, 2.75, 21.95, [kettlebells]), (3.5, 21.05, 4.1, 22.25, [bike]), (2.1, 20.45, 3.9, 21.05, [pilates mat 1.8 × 0.6]),
)
// fire safety (studies/fire_escape.typ): the suite bedroom's east window is its escape window (hinged casements, no screen)
#let escape-windows = (("Suite bedroom", (13.311, 15.0), (13.311, 17.9)),)   // shortened from 18.6 to clear the stair tower's north wall (y 18.22)
#let windows = (((0, 19.6), (0, 20.9)), ((0, 22.0), (0, 23.5)), ((2.0, 24), (3.9, 24)), ((10.5, 24), (12.8, 24)), ((8.95, 7.6), (8.95, 9.6)), ((13.311, 9.5), (13.311, 10.05)), ((13.311, 15.0), (13.311, 17.9)),
  ((6.0, 19.25), (7.0, 19.25)), ((7.6, 19.25), (8.6, 19.25)))   // gym: west (two) and south; office: south only (the tower covers its east wall); the clerestory windows of the living on the court's north wall
#let drains = (
  (((12.86, 7.17), (13.311, 7.0)), [suite bath: WC, shower, tub and vanity to one stack outside the east wall]),
  (((12.6, 8.8), (13.05, 8.3), (13.05, 7.6), (13.311, 7.1)), []),
  (((12.3, 10.0), (13.1, 9.7), (13.1, 7.7), (13.311, 7.1)), []),
  (((10.7, 8.5), (11.6, 8.2), (12.4, 7.75), (13.311, 7.1)), []),
  (((7.1, 20.6), (7.1, 23.6)), [suite court: the floor falls SOUTH, away from the doors, to the box gutter]),
)

// ---------- Walking routes: (name, rect, wall allowance across it, what is deducted) ----------
#let routes = (
  ("Suite lobby", rect-pts(8.95, 6.5, 10.3, 11.9), 0.2, [½ wall each side]),
  ("Gym walkway (gallery door → equipment)", rect-pts(1.965, 19.35, xn - 0.1, 20.35), 0.0, [inside the walls]),
  ("Court movement strip (the three doors)", rect-pts(court-strip.at(0), court-strip.at(1), court-strip.at(2), court-strip.at(3)), 0.0, [clear]),
)
#let paths = (
  ("Suite door → bedroom door", ((9.55, 6.5), (9.5, 11.9))),
  ("Suite door → bath door", ((9.55, 6.5), (9.55, 7.1), (10.3, 7.1))),
  ("Suite door → dressing door", ((9.55, 6.5), (9.55, 11.05), (10.3, 11.05))),
  ("Bedroom door → bath door", ((9.5, 11.9), (9.6, 7.1), (10.3, 7.1))),
  ("Bed → court door", ((11.8, 16.0), (9.5, 17.0), (9.5, 19.25))),
  ("Gallery end → gym → court → office door", ((4.9, 19.25), (4.9, 19.95), (xn, 19.95), (xo, 19.95))),
  ("Office court door → visitors' door", ((xo, 19.95), (12.4, 22.75), (13.311, 23.3))),
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
// clear ≈ axes minus half a wall on every edge: 250 mm on the outer walls (x 13.311, y 24, x 0), nothing on open edges, 200 mm elsewhere
#let outer-edges = (((13.311, 6.0), (13.311, 24.0)), ((0, 24.0), (13.311, 24.0)), ((0, 19.25), (0, 24.0)))
#let open-edges = ()
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
#let sweep(d) = {
  let w = dist(d.a, d.b); let (ix, iy) = d.into
  let (ix, iy) = if d.out { (-ix, -iy) } else { (ix, iy) }
  bbox((d.a, d.b, (d.b.at(0) + ix * w, d.b.at(1) + iy * w), (d.a.at(0) + ix * w, d.a.at(1) + iy * w)))
}

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
  let swing = doors.filter(d => not d.open)
  for d in swing { for f in furniture { if box-overlap(sweep(d), (f.at(0), f.at(1), f.at(2), f.at(3))) { out.push("door " + repr(d.label) + " swing hits " + repr(f.at(4))) } } }
  for i in range(swing.len()) { for j in range(i + 1, swing.len()) { if box-overlap(sweep(swing.at(i)), sweep(swing.at(j))) { out.push("door swings clash: " + repr(swing.at(i).label) + " / " + repr(swing.at(j).label)) } } }
  for r in rooms.filter(r => r.col != "circ") { if not doors.any(d => d.room == r.name) { out.push(r.name + " has no door") } }
  for d in doors.filter(d => d.from != "outside") {
    let m = mid(d.a, d.b)
    let p = (m.at(0) - d.into.at(0) * 0.3, m.at(1) - d.into.at(1) * 0.3)
    let ok = if d.from == "circ" { rooms.filter(r => r.col == "circ").any(r => inside(p, r.pts)) } else { inside(p, room(d.from).pts) }
    if not ok { out.push("door " + repr(d.label) + " not reached from " + d.from) }
  }
  for d in doors.filter(d => d.from == "outside") {
    if not interfaces.any(i => i.pts.len() == 2 and on-seg(d.a, ..i.pts) and on-seg(d.b, ..i.pts)) { out.push("door " + repr(d.label) + " not on an interface") }
  }
  // no door between the suite bedroom and the office
  if doors.any(d => (d.room == "Owner's office" and d.from == "Suite bedroom") or (d.room == "Suite bedroom" and d.from == "Owner's office")) { out.push("a door between the suite bedroom and the office") }
  // the three court doors open onto the movement strip
  for d in doors.filter(d => d.room == "Suite court (open to the sky)" or d.from == "Suite court (open to the sky)") {
    let m = mid(d.a, d.b)
    if m.at(1) > court-strip.at(3) + 1e-6 { out.push("court door " + repr(d.label) + " not on the north strip") }
  }
  for (n, P, w, t) in routes {
    let (x0, y0, x1, y1) = bbox(P)
    if calc.min(x1 - x0, y1 - y0) - w < 1.0 - 1e-6 { out.push("route " + n + " under 1.0 m clear") }
  }
  if court-strip.at(3) - court-strip.at(1) < 1.2 - 1e-6 { out.push("court movement strip under 1.2 m") }
  for f in court-furniture {
    if not inside(((f.at(0) + f.at(2)) / 2, (f.at(1) + f.at(3)) / 2), room("Suite court (open to the sky)").pts) { out.push("court furniture " + repr(f.at(4)) + " outside the court") }
    for s in court-path { if box-overlap(s, (f.at(0), f.at(1), f.at(2), f.at(3))) { out.push("court furniture " + repr(f.at(4)) + " in the free path") } }
  }
  // the treadmill: its clear zones inside the gym and free of furniture; the gym door's landing free
  if tm.at(0) < west-clear.at(0) + tm-side - 1e-6 or tm.at(3) > west-clear.at(3) + 1e-6 { out.push("treadmill clearances on the west band") }
  for (n, z, within) in tm-zones {
    if z.at(0) < within.at(0) - 1e-6 or z.at(1) < within.at(1) - 1e-6 or z.at(2) > within.at(2) + 1e-6 or z.at(3) > within.at(3) + 1e-6 { out.push("treadmill zone " + n + " outside the gym") }
    let need = if n == "behind" { tm-clear } else { tm-side }
    if (if n == "behind" { z.at(3) - z.at(1) } else { z.at(2) - z.at(0) }) < need - 1e-6 { out.push("treadmill zone " + n + " under " + str(need) + " m") }
    for f in furniture.filter(f => f.at(4) != [treadmill → S]) { if box-overlap(z, (f.at(0), f.at(1), f.at(2), f.at(3))) { out.push(repr(f.at(4)) + " in the treadmill's " + n + " zone") } }
  }
  for f in furniture { if box-overlap(gym-door-zone, (f.at(0), f.at(1), f.at(2), f.at(3))) { out.push(repr(f.at(4)) + " blocks the gym door") } }
  // the bed is out of sight from the gym door, the office door and the court seating, with the doors open
  for (l, before, after) in sight { if after { out.push("the bed is seen from " + repr(l)) } }
  // no window from the suite bedroom onto the double-height living (x 8.95, y 13–19.25)
  for (a, b) in windows { if calc.abs(a.at(0) - 8.95) < 1e-6 and calc.abs(b.at(0) - 8.95) < 1e-6 and calc.max(a.at(1), b.at(1)) > 13.0 and calc.min(a.at(1), b.at(1)) < 19.25 { out.push("window from the suite onto the double-height living") } }
  out
}
#let H(t) = text(9.5pt, weight: "bold", fill: green, t)

// ================= PAGE 1 · plan + rooms + checks =================
#text(15pt, weight: "bold", fill: green)[First floor · the south wing v2 (gym west, the suite court, the office east) and the master suite]
#h(8pt) #text(8pt, fill: gray)[Taif / Palm House · CSV coordinates (x east, y south) · wall centre lines · north up]
#v(-2pt)
#text(10pt, weight: "bold")[First floor, part 2 of 2 (part 1: studies/ff_family.typ) · owner's decision 1 Nov 2026 (south wing v2): the gym on the west band, the suite court from the gym to the office, the office on the east, the three court doors on a 1.2 m strip; the master suite unchanged]
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
    rect(q((court-strip.at(0), court-strip.at(1))), q((court-strip.at(2), court-strip.at(3))), fill: rgb("#eef5e8"), stroke: (paint: green, thickness: 0.4pt, dash: "dotted"))
    for (x0, y0, x1, y1, l) in furniture {
      rect(q((x0, y0)), q((x1, y1)), fill: white.transparentize(25%), stroke: (paint: luma(110), thickness: 0.4pt, dash: "dashed"))
      content(q(((x0 + x1) / 2, (y0 + y1) / 2)), angle: if (y1 - y0) > (x1 - x0) * 1.3 { 90deg } else { 0deg }, text(4.0pt, fill: luma(80), l))
    }
    let label-at = ("Suite lobby": (9.62, 10.6), "Suite bath": (11.5, 8.9), "Suite WC (closet)": (12.66, 7.75), "Suite dressing": (11.75, 12.85), "Suite bedroom": (11.5, 17.3), "Suite court (open to the sky)": (7.6, 21.05), "Gym": (3.05, 19.85), "Owner's office": (11.65, 22.75))
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
        let w = dist(d.a, d.b); let (ix, iy) = if d.out { (-d.into.at(0), -d.into.at(1)) } else { d.into }
        line(q(d.a), q((d.a.at(0) + ix * w, d.a.at(1) + iy * w)), stroke: (paint: red, thickness: 0.4pt))
      }
    }
    for itf in interfaces {
      line(..itf.pts.map(q), stroke: 2.6pt + rgb("#2f8a3f"))
      content(q(itf.at), anchor: itf.anchor, box(width: 3.2cm, align(if itf.anchor == "east" { right } else { left }, text(4.6pt, fill: rgb("#2f8a3f"), itf.label))))
    }
    for (P, l) in drains { line(..P.map(q), stroke: (paint: rgb("#1f7a99"), thickness: 0.8pt, dash: "dashed"), mark: (end: ">", fill: rgb("#1f7a99"), scale: 0.35)) }
    for (a, b) in court-drains { line(q(a), q(b), stroke: 1.4pt + rgb("#1f7a99")) }
    line(q(court-gutter.at(0)), q(court-gutter.at(1)), stroke: (paint: rgb("#1f7a99"), thickness: 1.2pt, dash: "dotted"))
    // the treadmill's clear zones
    for (n, z, w) in tm-zones { rect(q((z.at(0), z.at(1))), q((z.at(2), z.at(3))), fill: rgb("#fdf0d8"), stroke: (paint: rgb("#d08a00"), thickness: 0.3pt, dash: "dotted")) }
    line(q(acoustic-wall.at(0)), q(acoustic-wall.at(1)), stroke: 3pt + red)
    content(q((2.1, 19.05)), text(4.0pt, fill: red)[double wall Rw ≈ 55 dB])
    // the sight lines from the court seating through the open bedroom door (blocked by the entry wardrobe)
    for E in ((7.1, 23.35), (5.4, 22.1), (8.8, 22.1)) { line(q(E), q((9.5, 19.25)), stroke: (paint: rgb("#8a5a2b"), thickness: 0.4pt, dash: "dotted")) }
    // the court's south side: the recommended mashrabiya screen, PROPOSED (not applied; studies/south_wing.typ)
    line(q((xg, 24.25)), q((xo, 24.25)), stroke: (paint: rgb("#8a5a2b"), thickness: 1.0pt, dash: "dashed")); content(q((7.1, 24.55)), text(4.2pt, fill: rgb("#8a5a2b"))[south side: mashrabiya screen PROPOSED (owner's choice open)])
    line(q((13.436, 18.22)), q((16.036, 18.22)), q((16.036, 24.0)), q((13.436, 24.0)), stroke: (paint: luma(110), thickness: 0.8pt, dash: "dashed")); content(q((14.75, 21.0)), angle: 90deg, text(4.4pt, fill: luma(90))[external stair tower (outside)])
    content(q((8.85, 16.0)), anchor: "east", box(width: 1.9cm, align(right, text(4.6pt, fill: red)[solid wall: no window onto the double-height living])))
    line(q((2.75, 25.3)), q((4.75, 25.3)), stroke: 1.2pt)
    content(q((3.75, 25.7)), text(5.5pt)[2 m])
  }),
  [
    #H[Rooms]
    #table(columns: (auto, auto, auto, auto), stroke: none, inset: 2pt, fill: (_, y) => if calc.even(y) { rgb("#efece4") },
      [*Room*], [*Axes w × d (m)*], [*Axes m²*], [*≈ clear m²*],
      ..rooms.map(r => {
        let (x0, y0, x1, y1) = bbox(r.pts)
        ([#r.name], [#if is-rect(r.pts) [#r2(x1 - x0) × #r2(y1 - y0)] else [polygon]], [#r2(area(r.pts))], [#if r.col == "open" [#r2(court-clear-area)] else [#r2(clear-approx(r.pts))]])
      }).flatten(),
      [*Zone*], [], [*#r2(area(zone))*], [],
    )
    #text(5.8pt, fill: gray)[Clear ≈ axes minus half a wall on every edge (250 mm outer, 200 mm inner), corners ignored; the court: 5.55 × 4.525 inside its walls minus the nib.]
    #v(2pt)
    #if issues.len() == 0 { text(fill: green, weight: "bold")[✓ All rooms inside the zone · no overlaps · no unassigned area · furniture inside its room, not overlapping, out of the routes · door swings clear and not clashing · the three court doors on the 1.2 m strip · the court seating out of the strip · the treadmill with its manufacturer zone (#r2(tm-side) m each side, #r2(tm-clear) m behind) · the bed out of sight from the gym door, the office door and the court seating (doors open) · no door bedroom ↔ office] } else { std.block(fill: rgb("#fbe3dd"), inset: 5pt, radius: 2pt)[#text(fill: red, weight: "bold")[ISSUES]\ #issues.map(i => [• #i]).join(linebreak())] }
    #v(3pt)
    #H[Key numbers]
    - *Suite:* lobby #r2(area(room("Suite lobby").pts)) · bath #r2(area(room("Suite bath").pts)) + WC closet #r2(area(room("Suite WC (closet)").pts)) · dressing #r2(area(room("Suite dressing").pts)) · bedroom #r2(area(room("Suite bedroom").pts)) = *#r2(area(room("Suite lobby").pts) + area(room("Suite bath").pts) + area(room("Suite WC (closet)").pts) + area(room("Suite dressing").pts) + area(room("Suite bedroom").pts)) m² indoors* + the suite court.
    - *Gym* #r2(area(room("Gym").pts)) m² on axes (≈ #r2(clear-approx(room("Gym").pts)) clear; the west band alone #r2(xg * 4.75) / #r2((west-clear.at(2) - west-clear.at(0)) * (west-clear.at(3) - west-clear.at(1)))) · *suite court* #r2(area(room("Suite court (open to the sky)").pts)) m² on axes (≈ #r2(court-clear-area) clear) · *owner's office* #r2(area(room("Owner's office").pts)) m² (≈ #r2(clear-approx(room("Owner's office").pts)) clear).
    - *Walked:* gallery end → gym → court → office door ≈ #r1(path-len("Gallery end → gym → court → office door")) m; office → the stair landing ≈ #r1(path-len("Office court door → visitors' door")) m; bed → court ≈ #r1(path-len("Bed → court door")) m.
    #v(2pt)
    #H[Sight lines into the suite bedroom (its court door open; plan)]
    #table(columns: (2fr, auto, auto), inset: 2pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      [*From*], [*without the fix*], [*with the entry wardrobe*],
      ..sight.map(((l, a, b)) => ([#l], [#if a [the bed is seen] else [bed hidden]], [#if b [the bed is seen] else [bed hidden]])).flatten())
    #text(5.8pt, fill: gray)[Rays through the 0.9 m door opening (0.2 m wall) into the room, stopped by the walls and the wardrobe; the bed 1.8 × 2.0 at x 10.9–12.7, y 14–16.]
    #v(2pt)
    #text(6pt, fill: gray)[Plan: red = doors (thin = sliding) with swing line · blue = windows, blue lines = the court's linear drains, dotted = its box gutter · green dotted = the 1.2 m movement strip · brown dotted = ground floor below and the sight lines · grey = the family part (fixed).]
  ],
)

// ================= PAGE 2 · rooms, court details, walls, questions =================
#pagebreak()
#set text(size: 6.8pt)
#let bb(n) = bbox(room(n).pts)
#let wd(n) = { let (x0, y0, x1, y1) = bb(n); r2(x1 - x0) + " × " + r2(y1 - y0) }
#text(15pt, weight: "bold", fill: green)[Master suite, suite court, gym and office · rooms, the court's details, walls, questions]
#v(4pt)
#grid(columns: (1fr, 1fr), column-gutter: 18pt,
  [
    #H[Suite lobby, bath, dressing (unchanged)]
    - The suite door (from the family link) opens into a distributor: bath, dressing and bedroom each open off it; the bedroom door at the lobby's south end (a bent entry). Luxury bath #r2(area(room("Suite bath").pts) + area(room("Suite WC (closet)").pts)) m² with tub, walk-in shower, double vanity and a WC closet; walk-in dressing #wd("Suite dressing") m.
    #v(2pt)
    #H[Suite bedroom · #r2(area(room("Suite bedroom").pts)) m² · privacy without a screen]
    - *King bed* on the dressing wall facing south; the sitting corner by the east (escape) window; *no door to the office* (owner).
    - *The court door* (0.9 m sliding glass, x 9.05–9.95) opens onto an *entry zone* inside the room (x 8.95–10.0, y 16.85–19.25) formed by a full-height *wardrobe 0.6 × 2.3* east of it: the *smallest fix* the sight-line test needs. Without it the bed is seen from the court seating through the open door (table on page 1); with it the bed is hidden from the gym door, the office door and every seat. The bedroom has no window on the court: the glass door gets a curtain.
    #v(2pt)
    #H[Suite court · #r2(area(room("Suite court (open to the sky)").pts)) m² on axes, ≈ #r2(court-clear-area) m² clear · open to the sky, four sides]
    - From the gym's east wall (x #r2(xg)) to the office (x #r2(xo)), y 19.25–24.0: 5.75 × 4.75 on axes less the gym's entrance nib (1.55 × 1.3) in its north-west corner; 5.55 × 4.525 inside its walls. Sides: north the double-height living's south wall with its clerestory windows (+5.00 … +6.00, 1.40 m above the court floor) and the bedroom's court door; west the gym (solid, its court door on the nib); east the office (solid, its court door); south the facade frame (the cornice and the parapet run across on R8; the infill is the owner's choice: a solid wall, a mashrabiya screen (recommended, *proposed*) or a 1.1 m wall, `studies/south_wing.typ` § v2).
    - *Movement strip:* the three court doors (bedroom: sliding; gym: hinged, into the court; office: hinged, into the office) open onto a *1.2 m clear strip* along the north edge (x 5.9–9.9, y 19.35–20.55); the swings do not clash (checked). The seating zone is in the south part, out of the strip.
    - *Furniture test:* a 3-seat sofa against the south side, two armchairs and a table 1.2 × 0.7: seating for five; plants in the corners and a tree pot by the gym wall; a free band ≥ 1.0 m from the strip to the seats (checked).
    - *Near-flush doors (note for the engineer):* the court floor falls *south* at 1.5 % away from the doors to a box gutter along the south side (two outlets, internal downpipes in the south wall) with an *overflow spout* through the south wall (x ≈ 7.1, below the threshold level); *linear slot drains* in front of each of the three doors; the membrane turned up ≥ 150 mm behind the slot drains and under the door sills (a low-threshold detail: threshold ≤ 20 mm, the drain grating flush); the court's structural slab set 0.10–0.15 below the first-floor slab (a depressed zone in the men's majlis roof, its soffit unchanged) so the falls, the screed and the tiles end flush with the indoor floors.
  ],
  [
    #H[Gym · the west band #wd("Gym") (axes, incl. the nib), #r2(area(room("Gym").pts)) m², ≈ #r2(clear-approx(room("Gym").pts)) m² clear]
    - *v2 (owner):* the gym on the west band only (x 0–#r2(xg), 4.25 × 4.75 on axes, #r2(west-clear.at(2) - west-clear.at(0)) × #r2(west-clear.at(3) - west-clear.at(1)) clear) plus a small *entrance nib* at the gallery end (x #r2(xg)–#r2(xn), y 19.25–#r2(yn)): the gallery and the gym only touch at a corner, so the nib takes the family's sliding door from the gallery end and the gym's door to the court. No south arm. Windows west (two) and south (x 2.0–3.9); one fixed TV on the south wall in front of the treadmill.
    - *Treadmill* (#tm-model) along the 4.75 m length, facing south, #r2(tm-side) m clear each side and *#r2(tm-clear) m free behind it*, 0.5 m off the west wall face: on the *2.75 m solid bay between the west outer wall and beam B10* (over the guest block's walls: the stiffest bay of the wing). The rest: a power rack with the barbell and the pull-up bar, kettlebells, the bike and the pilates mat on the east half; a 1.0 m walkway from the gallery door (checked).
    - *What carries it (traced, `studies/structure.typ`):* the gym sits inside the column frame C6 / C13 / C19 (y 19.25) – C7 / C14 / C20 (y 24): the west outer wall on the ground-floor west wall; B10 on x 2.75 (C13 – C14, over the foyer's 1.8 m opening); *B19 on x 4.25 between C19 and C20* (the gym's east wall); the double wall on y 19.25 on B8 (x 2.75–4.25) and on a new beam B22 (C6 – C13, over the guest passage and the WC door); the south wall on B9.
    - *Acoustics:* the *double wall to bedroom 3* (y 19.25, x 0–4.25): 200 mm dense block + an independent stud lining with mineral wool, two layers of acoustic board, target *Rw ≈ 55 dB* (≈ 50 dB on site), sealed at the top, no sockets back to back; nothing fixed to it (the rack is freestanding).
    #v(2pt)
    #H[Owner's office · #wd("Owner's office") m on axes, #r2(area(room("Owner's office").pts)) m² (≈ #r2(clear-approx(room("Owner's office").pts)) m² clear)]
    - East, beside the suite bedroom, *no door between them*. The desk faces the south window (x 10.5–12.8); a sofa on the suite wall; bookshelves on the east wall; one fixed TV on the court wall. *Doors:* the visitors' door from the external stair tower's landing (east wall, y 22.9–23.75, opening out onto the landing, thumb-turn inside) and the court door (x #r2(xo), y 19.5–20.35, opening into the office: *free from the court side, key only from the office side*, so visitors cannot enter the court or the house).
    #v(2pt)
    #H[Locks on the route house → court → office → stair → outside]
    #table(columns: (1.5fr, 1.2fr, 2fr), inset: 2pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      [*Door*], [*opens*], [*lock*],
      ..doors.filter(d => d.lock != none).map(d => ([#d.label], [#if d.open [sliding] else if d.out [out of its room] else [into #d.room]], [#d.lock])).flatten(),
      [stair foot gate], [outwards], [panic bar; key / code outside],
    )
    #v(2pt)
    #H[Questions for the owner]
    + The court's south side: solid wall, mashrabiya screen (recommended) or a 1.1 m wall (`studies/south_wing.typ`).
    + The clerestory windows on the court: fixed fire-resisting glazing if the court is to count as an escape route (`studies/fire_escape.typ`), or openable vents as today.
  ],
)

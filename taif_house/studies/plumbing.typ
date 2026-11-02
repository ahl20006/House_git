// plumbing.typ · Taif / Palm House V8.1 (work) · PLUMBING AND WET-ROOM STUDY, round 1 (design review E-03, G-07; open item 10) · 2 Nov 2026 · STUDY ONLY.
// Owner's goals: maintenance without breaking floors or walls, no drain smells, low leak risk, high quality, controlled cost. Nothing is fixed: wet rooms may
// move if that makes the system clearly better, as long as the rooms keep their function. Latest geometry: the flipped stair, the family bath F-b, the south
// wing v2, the maid room and kitchen changes, the site plan's manholes and septic route. EVERY SIZE IS ASSUMED, TO BE DESIGNED BY THE PLUMBING ENGINEER.
// Nothing here changes the room CSVs or the design files: inventory, constraints, scores, alternatives, three scenarios, a recommendation, the utility room.
// CSV frame: x east, y south, wall centre lines; levels above the finished ground floor ±0.00. Geometry copied from data/rooms_*.csv, design_gf.typ, studies/*.typ.
#import "@preview/cetz:0.4.2"
#set page(paper: "a4", flipped: true, margin: 9mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 7.2pt)
#let ink = rgb("#3d4a45")
#let accent = rgb("#5a7d2a")
#let red = rgb("#b5452f")
#let blue = rgb("#2f5f8a")
#let green = rgb("#2f7a3f")
#let amber = rgb("#b58a1f")
#let wet = rgb("#cfe6ef")
#let r1(v) = str(calc.round(v, digits: 1))
#let r2(v) = str(calc.round(v, digits: 2))
#let H(body) = text(9.5pt, weight: "bold", fill: accent, body)
#let OK = text(fill: green, weight: "bold")[OK]
#let NO = text(fill: red, weight: "bold")[NO]
#let rect-pts(x0, y0, x1, y1) = ((x0, y0), (x1, y0), (x1, y1), (x0, y1))
#let dist(a, b) = calc.sqrt(calc.pow(a.at(0) - b.at(0), 2) + calc.pow(a.at(1) - b.at(1), 2))
#let plen(P) = range(P.len() - 1).map(i => dist(P.at(i), P.at(i + 1))).sum()
#let bends(P) = P.len() - 2
#let box-overlap(a, b) = a.at(0) < b.at(2) and b.at(0) < a.at(2) and a.at(1) < b.at(3) and b.at(1) < a.at(3)
#let box-dist(a, b) = { let dx = calc.max(b.at(0) - a.at(2), 0, a.at(0) - b.at(2)); let dy = calc.max(b.at(1) - a.at(3), 0, a.at(1) - b.at(3)); calc.sqrt(dx * dx + dy * dy) }
#let area(P) = calc.abs(range(P.len()).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, P.len())); a.at(0) * b.at(1) - b.at(0) * a.at(1) }).sum()) / 2

// ---------- The rooms (data/rooms_gf.csv, data/rooms_ff.csv), by class: wet, service, habitable (no drains above), circ, open ----------
#let gf = (
  ("Lift shaft", rect-pts(0, 0, 2.25, 2.2), "nodrain"), ("Stair", rect-pts(0, 2.2, 2.75, 7.9), "circ"), ("Utility room (shaft)", rect-pts(0, 7.9, 2.75, 10.4), "service"),
  ("Hospitality kitchen", rect-pts(0, 10.4, 2.75, 12.9), "wet"), ("Family basins", rect-pts(0, 12.9, 2.75, 14.4), "wet"), ("Family WC", rect-pts(0, 14.4, 2.75, 16.1), "wet"),
  ("Serving passage", rect-pts(0, 16.1, 2.75, 17.5), "circ"), ("Guest WC", rect-pts(1.25, 17.5, 2.75, 19.25), "wet"), ("Guest basins", rect-pts(1.25, 19.25, 2.75, 21.4), "wet"),
  ("Guest passage", rect-pts(0, 17.5, 1.25, 21.4), "circ"), ("Foyer", rect-pts(0, 21.4, 2.75, 24), "circ"), ("Lobby + riwaq", ((2.25, 0), (4.25, 0), (4.25, 19.25), (2.75, 19.25), (2.75, 2.2), (2.25, 2.2)), "circ"),
  ("Women's majlis", rect-pts(4.25, 0, 8.95, 6.5), "habitable"), ("Courtyard", rect-pts(4.25, 6.5, 8.95, 13.0), "open"), ("Living (double height)", rect-pts(4.25, 13.0, 8.95, 19.25), "habitable"),
  ("Men's majlis", rect-pts(2.75, 19.25, 13.311, 24), "habitable"), ("Maid bath", ((8.95, 1), (10.594, 1), (11.572, 2.8), (8.95, 2.8)), "wet"),
  ("Maid room (a bedroom)", ((10.65, 2.8), (11.572, 2.8), (13.311, 6), (13.311, 7.0), (10.65, 7.0)), "habitable"), ("Laundry", rect-pts(8.95, 2.8, 10.65, 7.0), "wet"),
  ("Kitchen", rect-pts(8.95, 7.0, 13.311, 13.0), "kitchen"), ("Dining", rect-pts(8.95, 13.0, 13.311, 19.25), "habitable"),
)
#let ff-wet = (
  ("Family bath (F-b)", ((1.5, 7.9), (2.75, 7.9), (2.75, 9.2), (4.25, 9.2), (4.25, 11.0), (1.5, 11.0))), ("Family WC (compartment)", rect-pts(0, 7.9, 1.5, 9.2)),
  ("Bedroom 3 bath", rect-pts(0, 14.4, 2.2, 16.1)), ("Suite bath", ((10.3, 6.5), (12.211, 6.5), (12.211, 8), (13.311, 8), (13.311, 10.45), (10.3, 10.45))), ("Suite WC closet", rect-pts(12.211, 6.5, 13.311, 8)),
)
#let ff-dry = (("Kids' room", rect-pts(4.25, 0, 8.95, 3.0)), ("Family living", rect-pts(4.25, 3.0, 8.95, 6.5)), ("Bedroom 1", ((8.95, 1), (10.594, 1), (13.311, 6), (13.311, 6.5), (10.15, 6.5), (10.15, 5.3), (8.95, 5.3))), ("Bedroom 2", rect-pts(0, 11.0, 4.25, 14.4)), ("Bedroom 3", ((2.2, 14.4), (4.25, 14.4), (4.25, 19.25), (0, 19.25), (0, 16.1), (2.2, 16.1))), ("Suite bedroom", ((8.95, 11.9), (10.3, 11.9), (10.3, 13.9), (13.311, 13.9), (13.311, 19.25), (8.95, 19.25))), ("Suite dressing", rect-pts(10.3, 10.45, 13.311, 13.9)), ("Gym", ((0, 19.25), (5.8, 19.25), (5.8, 20.55), (4.25, 20.55), (4.25, 24), (0, 24))), ("Office", rect-pts(10, 19.25, 13.311, 24)))
#let scourt = ((4.25, 20.55), (5.8, 20.55), (5.8, 19.25), (10, 19.25), (10, 24), (4.25, 24))
#let hood = (12.5, 10.2, 13.311, 11.2)        // the kitchen's hood zone on the east wall: no drains above
#let panel-zone = (0, 7.9, 1.5, 9.2)           // the utility room's north-west part: the main panel (west wall) — and, since 2 Nov 2026, the battery space on the north wall (east part, see the utility room page)
#let battery = (1.6, 8.0, 2.6, 8.4)            // the inverter + battery cabinet (utility room, north wall, east part): nothing wet above or beside
#let shaft = (0, 9.2, 1.5, 10.4)               // the west shaft (GF utility room → FF → roof): the west stack and vent
#let west-stack = (1.5, 9.8)                   // the stack's foot in the shaft (east side)
#let fwc-stack = (1.5, 14.9)                   // the family WC's stack (bedroom 3's bath drains straight down into it)
#let east-stack = (13.311, 7.05)               // the suite bath's stack outside the east wall (V6.3), beside the suite WC closet
#let mh-east = (14.3, 13.5)                    // the east-yard manhole (site plan)
#let mh-west = (-1.9, 24.7)                    // the west run's manhole on the driveway (site plan)
#let west-run = ((0.5, 10.5), (0.5, 21.6), (-1.9, 24.7))   // the buried ground-floor run under the west wash block, south to the west manhole
#let channel = (((10.2, 1.0), (10.2, 10.5)), ((10.2, 10.5), (9.05, 10.5)))   // the malqaf breeze channel in the ground slab (air v3.1): 0.9 × 0.20 inside the slab depth
#let hrv-intake = (9.8, 0.5)                   // the malqaf tower (its intake louvre on the roof, north-east): vents ≥ 3 m away
#let beams-drop = (("B1", (4.25, 3.0), (8.95, 3.0)), ("B4", (4.25, 6.5), (4.25, 19.25)), ("B5", (8.95, 13.0), (8.95, 19.25)), ("B6", (8.95, 6.5), (13.311, 6.5)), ("B8", (2.75, 19.25), (13.311, 19.25)), ("B22", (0, 19.25), (2.75, 19.25)), ("B3", (5.8, 6.5), (5.8, 19.25)))
#let slabs = (("west band: solid 0.20", rect-pts(0, 0, 2.75, 24)), ("riwaq: solid 0.20", rect-pts(2.75, 0, 4.25, 19.25)), ("women's majlis roof: solid 0.20", rect-pts(4.25, 0, 8.95, 6.5)), ("maid wing: solid 0.20 (no sunken zone without thickening)", rect-pts(8.95, 0, 13.311, 6.5)), ("kitchen roof: ribbed 0.30 (the suite bath sunken 0.15 inside it, X10)", rect-pts(8.95, 6.5, 13.311, 13.0)), ("dining roof: ribbed 0.30", rect-pts(8.95, 13.0, 13.311, 19.25)), ("men's majlis roof: ribbed 0.30 (the suite court depressed)", rect-pts(2.75, 19.25, 13.311, 24)))

// ---------- 1 · Inventory: every wet point (floor, room, fixture, point, the collector it drains to, the drain route as a polyline, use) ----------
// collectors: W-RUN (the buried GF run under the west wash block), W-SHAFT (the west stack), FWC (the family WC's stack), E-STACK (the east wall stack), E-MH (the east-yard manhole, buried), RAIN (the rain branch to the east manhole / soakaways)
#let W = ("W-RUN", "W-SHAFT", "FWC", "E-STACK", "E-MH", "RAIN")
#let pts = (
  // ground floor, west cluster
  (fl: "GF", room: "Hospitality kitchen", fix: "sink", p: (0.8, 10.8), to: "W-RUN", route: ((0.8, 10.8), (0.5, 10.8)), use: "daily"),
  (fl: "GF", room: "Family basins", fix: "2 basins (wudu)", p: (1.0, 13.25), to: "W-RUN", route: ((1.0, 13.25), (0.5, 13.25)), use: "daily"),
  (fl: "GF", room: "Family WC", fix: "WC + basin", p: (0.6, 15.6), to: "W-RUN", route: ((0.6, 15.6), (0.5, 15.6)), use: "daily"),
  (fl: "GF", room: "Guest WC", fix: "WC + basin", p: (1.6, 18.6), to: "W-RUN", route: ((1.6, 18.6), (0.5, 18.6)), use: "guests"),
  (fl: "GF", room: "Guest basins", fix: "trough, 3 taps", p: (2.4, 20.3), to: "W-RUN", route: ((2.4, 20.3), (2.4, 21.6), (0.5, 21.6)), use: "guests"),
  (fl: "GF", room: "Utility room", fix: "heater drip tray · condensate", p: (1.75, 10.1), to: "W-SHAFT", route: ((1.75, 10.1), (1.5, 10.1)), use: "rare"),
  // ground floor, east cluster
  (fl: "GF", room: "Kitchen", fix: "sink + dishwasher", p: (9.35, 8.6), to: "E-MH", route: ((9.35, 8.6), (9.35, 9.9), (13.311, 9.9), (14.3, 13.5)), use: "daily"),
  (fl: "GF", room: "Laundry", fix: "washer · dryer · utility sink · floor drain", p: (9.35, 4.0), to: "E-MH", route: ((9.35, 4.0), (9.35, 6.6), (13.311, 6.6), (14.3, 13.5)), use: "daily / rare (floor drain)"),
  (fl: "GF", room: "Maid bath", fix: "WC · basin · shower", p: (10.6, 2.2), to: "E-MH", route: ((10.6, 2.2), (12.0, 2.2), (12.5, 3.0), (14.0, 6.0), (14.3, 13.5)), use: "daily"),
  (fl: "GF", room: "Courtyard", fix: "step drain · overflow · basin + planter", p: (8.6, 12.1), to: "RAIN", route: ((8.6, 12.1), (13.311, 12.1), (14.3, 13.5)), use: "rain / washing"),
  (fl: "GF", room: "Air tower", fix: "breeze channel sump · HRV condensate", p: (9.8, 0.8), to: "E-MH", route: ((9.8, 0.8), (10.6, 1.0), (12.0, 2.2), (14.0, 6.0), (14.3, 13.5)), use: "rare"),
  // first floor, west cluster
  (fl: "FF", room: "Family bath (F-b)", fix: "shower", p: (2.0, 10.45), to: "W-SHAFT", route: ((2.0, 10.45), (1.5, 10.2)), use: "daily"),
  (fl: "FF", room: "Family bath (F-b)", fix: "double basin", p: (3.2, 10.65), to: "W-SHAFT", route: ((3.2, 10.65), (1.5, 10.3)), use: "daily"),
  (fl: "FF", room: "Family WC (compartment)", fix: "WC", p: (0.5, 8.55), to: "W-SHAFT", route: ((0.5, 8.55), (0.5, 9.2), (1.0, 9.4)), use: "daily"),
  (fl: "FF", room: "Bedroom 3 bath", fix: "shower · WC · basin", p: (1.0, 15.0), to: "FWC", route: ((1.0, 15.0), (1.5, 14.9)), use: "daily"),
  // first floor, east cluster
  (fl: "FF", room: "Suite WC closet", fix: "WC", p: (12.8, 7.2), to: "E-STACK", route: ((12.8, 7.2), (13.311, 7.05)), use: "daily"),
  (fl: "FF", room: "Suite bath", fix: "shower (east wall)", p: (12.8, 8.6), to: "E-STACK", route: ((12.8, 8.6), (13.05, 7.6), (13.311, 7.05)), use: "daily"),
  (fl: "FF", room: "Suite bath", fix: "tub (by the east window)", p: (12.5, 9.8), to: "E-STACK", route: ((12.5, 9.8), (12.4, 8.2), (13.311, 7.05)), use: "weekly"),
  (fl: "FF", room: "Suite bath", fix: "double vanity (west wall)", p: (10.7, 8.5), to: "E-STACK", route: ((10.7, 8.5), (11.6, 7.7), (12.4, 7.4), (13.311, 7.05)), use: "daily"),
  (fl: "FF", room: "Suite court", fix: "3 linear drains · box gutter · overflow", p: (7.1, 23.6), to: "RAIN", route: ((7.1, 23.6), (10.0, 23.75), (10.0, 24.0)), use: "rain"),
  (fl: "roof", room: "Roof", fix: "11 outlets → internal downpipes", p: (6.6, 12.0), to: "RAIN", route: ((6.6, 12.0), (6.6, 12.0)), use: "rain"),
  (fl: "roof", room: "Roof (plant)", fix: "AC condensate (Z2b) · HRV condensate (base)", p: (11.0, 7.3), to: "E-STACK", route: ((11.0, 7.3), (13.311, 7.05)), use: "daily (summer)"),
)
#let is-wet-point(p) = p.fl != "roof"

// ---------- 2 · Overlay: each first-floor wet room over the ground floor: what lies below ----------
#let centroid(P) = (P.map(p => p.at(0)).sum() / P.len(), P.map(p => p.at(1)).sum() / P.len())
#let inside(pt, P) = { let (x, y) = pt; let c = false; for i in range(P.len()) { let (xi, yi) = P.at(i); let (xj, yj) = P.at(calc.rem(i + 1, P.len())); if (yi > y) != (yj > y) and x < (xj - xi) * (y - yi) / (yj - yi) + xi { c = not c } }; c }
#let below(P) = { let out = (); for r in gf { let b0 = (calc.min(..P.map(p => p.at(0))), calc.min(..P.map(p => p.at(1))), calc.max(..P.map(p => p.at(0))), calc.max(..P.map(p => p.at(1)))); let b1 = (calc.min(..r.at(1).map(p => p.at(0))), calc.min(..r.at(1).map(p => p.at(1))), calc.max(..r.at(1).map(p => p.at(0))), calc.max(..r.at(1).map(p => p.at(1)))); if box-overlap((b0.at(0) + 0.05, b0.at(1) + 0.05, b0.at(2) - 0.05, b0.at(3) - 0.05), b1) { out.push(r) } }; out }
#let overlay = ff-wet.map(((n, P)) => (n, below(P)))
#let verdict(rs) = if rs.any(r => r.at(2) == "habitable" or r.at(2) == "kitchen" or r.at(2) == "nodrain") { "problem" } else { "good" }

// ---------- 3 · Scores (0–10, higher is better; the weights are this study's, not a code) ----------
#let L(p) = plen(p.route)
#let score(p) = {
  let s-len = calc.max(0, 3 - L(p) / 2.0)                                   // ≤ 1 m: 3 · 6 m: 0
  let s-bend = calc.max(0, 2 - bends(p.route) * 0.7)                        // 0 bends: 2
  let s-stack = if p.fl == "GF" { 2 } else if p.room == "Suite court" { 1 } else if p.room.contains("Suite") { 0 } else { 2 }   // FF: stacked over a wet / service room = 2; rain in the court's depressed slab over the majlis = 1; over the kitchen = 0
  let s-access = if p.to == "W-SHAFT" or p.to == "FWC" { 1.5 } else if p.fl == "GF" { 1.5 } else { 0.5 }   // a shaft door / a cleanout from above vs an outside stack through a wall
  let s-smell = if p.use.contains("rare") or p.use.contains("rain") { 0.5 } else { 1.5 }
  calc.min(10, s-len + s-bend + s-stack + s-access + s-smell)
}
#let wet-rows = pts.filter(is-wet-point)
#let total-len = wet-rows.map(p => L(p)).sum()

// ---------- 4 · Scenarios: the wet points that change (name, the added or moved points, the removed fixtures, notes) ----------
// A · minimum: nothing moves; the routes, the access and the venting improved; the suite bath's vanity branch kept inside its sunken zone
// B · moderate: + the ground-floor shower P1 (the family WC + basins → one wet room on the west run), the suite bath's vanity moved to the east side (next to the stack), the maid bath's fixtures on the cut wall, the suite court's outlets down the gym / office walls (not the majlis wall)
// C · ideal: B + an internal accessible EAST DUCT (0.35 × 0.35 in the kitchen's north-east corner under the suite WC closet) replacing the outside stack, with doors on both floors; the laundry's sink beside the washer; the east heater and manifold in the laundry
#let vanity-B = (fl: "FF", room: "Suite bath", fix: "double vanity (moved beside the stack)", p: (12.6, 9.0), to: "E-STACK", route: ((12.6, 9.0), (13.05, 7.6), (13.311, 7.05)), use: "daily")
#let court-B = (fl: "FF", room: "Suite court", fix: "3 linear drains · box gutter · overflow (outlets down the gym / office walls)", p: (7.1, 23.6), to: "RAIN", route: ((7.1, 23.6), (4.25, 23.6)), use: "rain")
#let tub-B = (fl: "FF", room: "Suite bath", fix: "tub (moved to the north wall beside the stack)", p: (11.6, 7.0), to: "E-STACK", route: ((11.6, 7.0), (12.9, 7.0), (13.311, 7.05)), use: "weekly")
#let p1-shower = (fl: "GF", room: "Family wet room (P1)", fix: "level shower · WC · 2 basins", p: (0.7, 15.4), to: "W-RUN", route: ((0.7, 15.4), (0.5, 15.4)), use: "daily")
#let maid-C = (fl: "GF", room: "Maid bath", fix: "WC · basin · shower on the cut wall", p: (11.2, 2.3), to: "E-MH", route: ((11.2, 2.3), (12.5, 3.0), (14.0, 6.0), (14.3, 13.5)), use: "daily")
#let east-duct = (12.95, 7.0, 13.3, 7.35)       // C: the internal east duct in the kitchen's NE corner, under the suite WC closet's corner
#let scen-A = wet-rows
#let scen-B = wet-rows.filter(p => p.fix != "double vanity (west wall)" and p.fix != "tub (by the east window)" and p.room != "Suite court" and not (p.room == "Family basins") and not (p.room == "Family WC")) + (vanity-B, tub-B, p1-shower, court-B)
#let scen-C = scen-B.filter(p => p.room != "Maid bath") + (maid-C,)
#let s-total(S) = S.map(p => L(p)).sum()
#let s-over(S) = S.filter(p => p.fl == "FF" and p.room.contains("Suite")).map(p => p.room).dedup().len()   // wet rooms over a problem room (the suite bath over the kitchen, unavoidable)
#let s-mean(S) = S.map(p => score(p)).sum() / S.len()
#let s-longest(S) = calc.max(..S.filter(p => p.fl == "FF" and p.to != "RAIN").map(p => L(p)))   // the longest first-floor foul branch (the rain outlets excluded)
#let s-poor(S) = S.filter(p => score(p) < 5).len()

// ---------- The utility room (west cluster): the shaft, the panel, the battery space, the heater, the manifold, the door, the clearances ----------
#let ut = (0.125, 8.0, 2.65, 10.3)             // clear 2.525 × 2.3
#let ut-items = (
  (shaft, [SHAFT 1.5 × 1.2\ west stack + vent\ PV conduits ↓], rgb("#e4ded2")),
  ((0.125, 8.1, 0.35, 9.0), [main\ panel], amber),
  (battery, [inverter + battery cabinet 1.0 × 0.4 (dry: the bath's linen zone above, the slab tanked)], amber),
  ((1.6, 9.9, 2.0, 10.3), [heater\ Ø 0.40\ drip tray], wet),
  ((1.5, 9.2, 1.6, 10.3), [manifold cabinet, wall-hung above 1.8 m, on the shaft's east face], blue),
)
#let heater = (1.6, 9.9, 2.0, 10.3)
#let manifold = (1.5, 9.2, 1.6, 10.3)
#let ut-door = ((2.75, 9.45), (2.75, 10.2))    // moved south from y 8.2–9.0 (proposal): 0.75 wide, hinged south, opening west
#let ut-door-sq = (2.0, 9.45, 2.75, 10.2)
#let shaft-door = ((0.2, 9.2), (1.3, 9.2))     // the shaft's access on its NORTH face (removable panels), facing the room's north part
#let panel-clear = (0.35, 8.1, 1.25, 9.0)
#let ut-free = (ut.at(2) - ut.at(0)) * (ut.at(3) - ut.at(1)) - 1.375 * 1.1

// ---------- checks of this study ----------
#let checks = (
  ([every first-floor wet room except the suite bath stands over a wet or service room (the overlay)], overlay.filter(((n, rs)) => not n.contains("Suite")).all(((n, rs)) => verdict(rs) == "good")),
  ([the suite bath and its WC closet stand over the kitchen (reported as the one unavoidable problem, mitigated by the sunken tanked slab)], overlay.filter(((n, rs)) => n.contains("Suite")).all(((n, rs)) => verdict(rs) == "problem")),
  ([no first-floor drain crosses the kitchen's hood zone (the tub's branch kept north of y 10.2 at the east wall)], wet-rows.filter(p => p.fl == "FF").all(p => p.route.all(q => not (q.at(0) >= hood.at(0) and q.at(1) >= hood.at(1) and q.at(1) <= hood.at(3))))),
  ([the two vent stacks ≥ 3 m from the HRV intake (west #r1(dist(west-stack, hrv-intake)) m, east #r1(dist(east-stack, hrv-intake)) m)], dist(west-stack, hrv-intake) >= 3 and dist(east-stack, hrv-intake) >= 3),
  ([every first-floor foul branch ≤ 4 m horizontal (max #r1(s-longest(scen-A)) m, the suite vanity today)], s-longest(scen-A) <= 4.0),
  ([scenario B shortens the longest first-floor foul branch to #r1(s-longest(scen-B)) m and the total to #r1(s-total(scen-B)) m (A: #r1(s-total(scen-A))), and leaves fewer fixtures below 5 (#s-poor(scen-B) vs #s-poor(scen-A))], s-total(scen-B) < s-total(scen-A) and s-longest(scen-B) < s-longest(scen-A) and s-poor(scen-B) < s-poor(scen-A)),
  ([utility room: the battery cabinet not under the WC compartment (x ≥ 1.5), ≥ 1 m from the heater (#r2(box-dist(battery, heater))) and ≥ 0.75 m from the manifold (#r2(box-dist(battery, manifold)))], battery.at(0) >= 1.5 and box-dist(battery, heater) >= 1.0 and box-dist(battery, manifold) >= 0.75),
  ([utility room: the door's swing clear of the heater, the battery and the manifold; 0.9 m in front of the panel; the shaft panels on its north face reachable], not box-overlap(ut-door-sq, heater) and not box-overlap(ut-door-sq, battery) and not box-overlap(ut-door-sq, manifold) and not box-overlap(heater, manifold) and ut-items.all(((b, l, c)) => b == shaft or b == (0.125, 8.1, 0.35, 9.0) or not box-overlap(panel-clear, b))),
  ([utility room: free floor ≈ #r2(ut-free) m² (small: reported)], ut-free >= 3.5),
)
#let all-ok = checks.all(c => c.at(1))

// ---------- drawing ----------
#let q(p) = (p.at(0), -p.at(1))
#let col-of(k) = (wet: wet, service: rgb("#e4ded2"), habitable: rgb("#f6e3c0"), kitchen: rgb("#f3d6c4"), nodrain: rgb("#f3c6c6"), circ: rgb("#f2efe8"), open: white).at(k)
#let base(length, show-ff: true, show-gf: true) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, body, size: 3.4pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, body))
  let poly(P, fill: none, stroke: none) = line(..P.map(q), close: true, fill: fill, stroke: stroke)
  if show-gf { for (n, P, k) in gf { poly(P, fill: col-of(k), stroke: 0.4pt + luma(140)); if k != "circ" { T(centroid(P), n, size: 2.8pt, fill: luma(70)) } } }
  if show-ff {
    for (n, P) in ff-wet { poly(P, fill: blue.transparentize(55%), stroke: 1pt + blue); T(centroid(P), [FF · #n], size: 2.8pt, fill: white) }
    for (n, P) in ff-dry { poly(P, stroke: (paint: luma(90), thickness: 0.5pt, dash: "dashed")) }
    poly(scourt, stroke: (paint: blue, thickness: 0.5pt, dash: "dotted"))
  }
  line(q((0, 0)), q((10.051, 0)), q((13.311, 6.0)), q((13.311, 24)), q((0, 24)), close: true, stroke: 1.1pt + ink)
  // the collectors
  rect(q((shaft.at(0), shaft.at(1))), q((shaft.at(2), shaft.at(3))), fill: luma(120), stroke: none); T((0.75, 9.8), [W shaft], size: 2.6pt, fill: white)
  circle(q(east-stack), radius: 0.22, fill: rgb("#8a5a2b"), stroke: none); T((13.6, 7.05), [E stack], size: 2.6pt, fill: rgb("#8a5a2b"), anchor: "west")
  circle(q(fwc-stack), radius: 0.18, fill: rgb("#8a5a2b"), stroke: none); T((1.7, 14.9), [FWC stack], size: 2.4pt, fill: rgb("#8a5a2b"), anchor: "west")
  circle(q(mh-east), radius: 0.3, fill: white, stroke: 0.8pt + rgb("#8a5a2b")); T((14.7, 13.5), [MH east], size: 2.6pt, fill: rgb("#8a5a2b"), anchor: "west")
  circle(q(mh-west), radius: 0.3, fill: white, stroke: 0.8pt + rgb("#8a5a2b")); T((-2.1, 24.0), [MH west], size: 2.6pt, fill: rgb("#8a5a2b"), anchor: "east")
  line(..west-run.map(q), stroke: (paint: rgb("#8a5a2b"), thickness: 1pt, dash: "dashed"))
  T((6.6, -0.6), [north up · 1 m = #length], size: 3pt, fill: gray)
})
#let overlay-plan(length: 0.56cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, body, size: 3.4pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, body))
  let poly(P, fill: none, stroke: none) = line(..P.map(q), close: true, fill: fill, stroke: stroke)
  for (n, P, k) in gf { poly(P, fill: col-of(k), stroke: 0.4pt + luma(140)); if k != "circ" { T(centroid(P), n, size: 2.9pt, fill: luma(70)) } }
  for (n, P) in ff-wet { let v = verdict(below(P)); poly(P, fill: (if v == "good" { green } else { red }).transparentize(55%), stroke: 1.1pt + (if v == "good" { green } else { red })); T((centroid(P).at(0), centroid(P).at(1) + 0.35), [FF · #n], size: 2.8pt, fill: white) }
  for (n, P) in ff-dry { poly(P, stroke: (paint: luma(90), thickness: 0.5pt, dash: "dashed")) }
  rect(q((hood.at(0), hood.at(1))), q((hood.at(2), hood.at(3))), fill: red.transparentize(30%), stroke: none); T((12.0, 10.7), [hood zone], size: 2.6pt, fill: red, anchor: "east")
  rect(q((battery.at(0), battery.at(1))), q((battery.at(2), battery.at(3))), fill: amber, stroke: none); T((2.7, 8.2), [batteries], size: 2.6pt, fill: amber, anchor: "west")
  for (n, P) in ff-dry { }
  for p in wet-rows { circle(q(p.p), radius: 0.16, fill: if p.fl == "GF" { blue } else { rgb("#8a5a2b") }, stroke: none) }
  line(q((0, 0)), q((10.051, 0)), q((13.311, 6.0)), q((13.311, 24)), q((0, 24)), close: true, stroke: 1.1pt + ink)
  T((6.6, 24.8), [OVERLAY · the first-floor wet rooms (green = over a wet / service room, red = over the kitchen) on the ground floor · dots: wet points (blue GF, brown FF) · 1 m = 0.56 cm], size: 3.2pt, fill: accent)
})
#let constraints-plan(length: 0.5cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, body, size: 3.4pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, body))
  let poly(P, fill: none, stroke: none) = line(..P.map(q), close: true, fill: fill, stroke: stroke)
  for (n, P) in slabs { poly(P, fill: if n.contains("ribbed") { rgb("#eadfc8") } else { rgb("#f1efe8") }, stroke: 0.3pt + luma(160)); T(centroid(P), n, size: 2.6pt, fill: luma(90)) }
  for (n, P, k) in gf.filter(((n, P, k)) => k == "habitable" or k == "nodrain") { poly(P, fill: red.transparentize(78%), stroke: (paint: red, thickness: 0.5pt, dash: "dashed")) }
  rect(q((hood.at(0), hood.at(1))), q((hood.at(2), hood.at(3))), fill: red.transparentize(30%), stroke: none)
  rect(q((battery.at(0), battery.at(1))), q((battery.at(2), battery.at(3))), fill: red.transparentize(30%), stroke: none); T((2.7, 8.2), [battery], size: 2.5pt, fill: red, anchor: "west")
  rect(q((0.125, 8.1)), q((0.35, 9.0)), fill: red.transparentize(30%), stroke: none)
  for (id, a, b) in beams-drop { line(q(a), q(b), stroke: 1.6pt + rgb("#2f5f8a")); T(((a.at(0) + b.at(0)) / 2 + 0.3, (a.at(1) + b.at(1)) / 2), id, size: 2.6pt, fill: rgb("#2f5f8a")) }
  for P in channel { line(..P.map(q), stroke: (paint: amber, thickness: 2.4pt)) }; T((10.9, 5.5), [breeze channel\ in the ground slab], size: 2.6pt, fill: amber, anchor: "west")
  rect(q((4.25, 6.5)), q((8.95, 13.0)), stroke: 0.8pt + blue); T((6.6, 9.75), [courtyard\ (open; its drains\ east, buried)], size: 2.8pt, fill: blue)
  rect(q((shaft.at(0), shaft.at(1))), q((shaft.at(2), shaft.at(3))), fill: luma(120), stroke: none); T((0.75, 9.8), [W shaft], size: 2.6pt, fill: white)
  circle(q(east-stack), radius: 0.22, fill: rgb("#8a5a2b"), stroke: none); circle(q(fwc-stack), radius: 0.18, fill: rgb("#8a5a2b"), stroke: none)
  circle(q(mh-east), radius: 0.3, fill: white, stroke: 0.8pt + rgb("#8a5a2b")); circle(q(mh-west), radius: 0.3, fill: white, stroke: 0.8pt + rgb("#8a5a2b"))
  line(..west-run.map(q), stroke: (paint: rgb("#8a5a2b"), thickness: 1pt, dash: "dashed")); line(q(east-stack), q((14.3, 7.3)), q(mh-east), stroke: (paint: rgb("#8a5a2b"), thickness: 1pt, dash: "dashed"))
  line(q(mh-east), q((15.2, 24.0)), stroke: (paint: rgb("#8a5a2b"), thickness: 0.8pt, dash: "dotted")); T((15.4, 24.0), [→ collector MH → septic], size: 2.6pt, fill: rgb("#8a5a2b"), anchor: "west")
  circle(q(hrv-intake), radius: 0.4, stroke: 0.8pt + amber); T((11.0, 0.5), [HRV intake (roof): vents ≥ 3 m], size: 2.6pt, fill: amber, anchor: "west")
  rect(q((0, 0)), q((2.25, 2.2)), fill: red.transparentize(50%), stroke: none); T((1.1, 1.1), [lift], size: 2.6pt)
  line(q((0, 0)), q((10.051, 0)), q((13.311, 6.0)), q((13.311, 24)), q((0, 24)), close: true, stroke: 1.1pt + ink)
  T((6.6, 24.8), [CONSTRAINTS · red = no drains above (habitable rooms, the kitchen's hood zone, the panel, the batteries, the lift) · blue = drop beams · beige = ribbed bays (a sunken zone possible) · 1 m = 0.5 cm], size: 3.2pt, fill: accent)
})
#let scen-plan(S, name, length: 0.36cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, body, size: 3pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, body))
  let poly(P, fill: none, stroke: none) = line(..P.map(q), close: true, fill: fill, stroke: stroke)
  for (n, P, k) in gf { poly(P, fill: if k == "wet" { wet } else if k == "kitchen" { rgb("#f3d6c4") } else { rgb("#f2efe8") }, stroke: 0.3pt + luma(150)) }
  for (n, P) in ff-wet { poly(P, fill: blue.transparentize(60%), stroke: 0.8pt + blue) }
  if name != "A" { rect(q((0, 12.9)), q((2.75, 16.1)), fill: green.transparentize(50%), stroke: 0.8pt + green); T((1.4, 14.5), [P1 wet room], size: 2.6pt, fill: white) }
  if name == "C" { rect(q((east-duct.at(0), east-duct.at(1))), q((east-duct.at(2), east-duct.at(3))), fill: rgb("#8a5a2b"), stroke: none); T((12.4, 7.2), [E duct], size: 2.5pt, fill: rgb("#8a5a2b"), anchor: "east") }
  for p in S { line(..p.route.map(q), stroke: (paint: if p.fl == "GF" { blue } else { rgb("#8a5a2b") }, thickness: 0.7pt), mark: (end: ">", fill: if p.fl == "GF" { blue } else { rgb("#8a5a2b") }, scale: 0.35)); circle(q(p.p), radius: 0.18, fill: if p.fl == "GF" { blue } else { rgb("#8a5a2b") }, stroke: none) }
  rect(q((shaft.at(0), shaft.at(1))), q((shaft.at(2), shaft.at(3))), fill: luma(120), stroke: none)
  circle(q(east-stack), radius: 0.22, fill: rgb("#8a5a2b"), stroke: none); circle(q(mh-east), radius: 0.3, fill: white, stroke: 0.8pt + rgb("#8a5a2b")); circle(q(mh-west), radius: 0.3, fill: white, stroke: 0.8pt + rgb("#8a5a2b"))
  line(..west-run.map(q), stroke: (paint: rgb("#8a5a2b"), thickness: 0.8pt, dash: "dashed"))
  line(q((0, 0)), q((10.051, 0)), q((13.311, 6.0)), q((13.311, 24)), q((0, 24)), close: true, stroke: 1pt + ink)
  T((6.6, 24.9), [SCENARIO #name · total #r1(s-total(S)) m · blue = GF buried branches · brown = FF branches to the stacks], size: 3pt, fill: accent)
})
#let utility-plan(length: 2.4cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, body, size: 3.6pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, body))
  let R(b, fill: none, stroke: none) = rect(q((b.at(0), b.at(1))), q((b.at(2), b.at(3))), fill: fill, stroke: stroke)
  R((-0.125, 7.8, 2.85, 10.5), fill: luma(120)); R(ut, fill: rgb("#f3efe4"))
  R((2.75, 7.8, 4.0, 10.5), fill: rgb("#f6f2e6")); T((3.4, 9.1), [riwaq], size: 3.4pt, angle: 90deg)
  for (b, l, c) in ut-items { R(b, fill: c, stroke: 0.4pt + ink); T(((b.at(0) + b.at(2)) / 2, (b.at(1) + b.at(3)) / 2), l, size: 2.9pt, angle: if (b.at(3) - b.at(1)) > (b.at(2) - b.at(0)) * 1.5 { 90deg } else { 0deg }) }
  R(panel-clear, fill: none, stroke: (paint: amber, thickness: 0.5pt, dash: "dotted")); T((0.8, 8.55), [0.9 clear\ in front of\ the panel], size: 2.6pt, fill: amber)
  line(q(ut-door.at(0)), q(ut-door.at(1)), stroke: 2.4pt + red); arc(q(ut-door.at(1)), start: 90deg, stop: 180deg, radius: 0.75, stroke: (paint: red, thickness: 0.4pt, dash: "dotted"), anchor: "origin"); T((2.95, 9.8), [door (moved south,\ proposal) · hinged S], size: 2.6pt, fill: red, anchor: "west")
  line(q(shaft-door.at(0)), q(shaft-door.at(1)), stroke: 2pt + rgb("#8a5a2b")); T((0.75, 9.05), [shaft panels (north face)], size: 2.5pt, fill: rgb("#8a5a2b"))
  line(q((0.125, 7.9)), q((2.65, 7.9)), stroke: (paint: blue, thickness: 0.8pt, dash: "dashed")); T((1.4, 7.7), [the family bath above (y 7.9–11): its slab sunken and tanked; the WC compartment over x 0–1.5 only], size: 2.5pt, fill: blue)
  line(q((2.0, 8.5)), q((2.0, 9.35)), stroke: 0.4pt + ink, mark: (start: "|", end: "|", scale: 0.4)); T((2.1, 8.9), [≥ 0.9 clear], size: 2.5pt, anchor: "west")
  circle(q((1.8, 10.05)), radius: 0.06, fill: blue, stroke: none); T((2.2, 10.45), [leak sensor + drip tray\ under the heater], size: 2.4pt, fill: blue)
  T((1.4, 10.75), [UTILITY ROOM · 2.525 × 2.3 clear · 1 m = 2.4 cm · north up], size: 3.4pt, fill: accent)
})

// ====================================================================================== PAGE 1 · principles, inventory, overlay
#text(14pt, weight: "bold", fill: accent)[Plumbing and wet-room study · round 1 · inventory, overlay, constraints, scores, alternatives, three scenarios, the utility room · Taif / Palm House V8.1 · STUDY ONLY]
#v(1pt)
#text(8pt, fill: gray)[Design review E-03, G-07 · open item 10 · 2 Nov 2026 · the latest geometry (the flipped stair, the family bath F-b, the south wing v2, the maid room and kitchen changes, the site plan's manholes and septic route) · *every size is assumed, to be designed by the plumbing engineer* · nothing in the design files changes until the owner decides]
#v(3pt)
#grid(columns: (1fr, auto), gutter: 10pt,
  [
    #set text(6.4pt)
    #H[Principles applied in every scenario (owner's goals: maintenance without breaking floors or walls, no smells, low leak risk, quality, controlled cost)]
    + *Two clusters only:* west round the shaft (the utility room, the hospitality kitchen, the family basins and WC, the guest WC and basins; above: the family bath F-b and its WC compartment, bedroom 3's bath) and east along the east wall (the kitchen, the laundry, the maid bath; above: the suite bath and its WC closet). *No third cluster* (bedroom 1 stays without a bath: decided).
    + *Ground floor:* the drains buried under the ground slab, a *cleanout at every change of direction*, an *inspection chamber outside each cluster* (the west manhole on the driveway, the east manhole in the yard), reachable from above; then the collector manhole and the existing septic (site plan).
    + *Stacks:* vertical stacks inside the *west shaft* (doors on each floor) or an *accessible duct* (scenario C: an internal east duct); acoustic (triple-layer) pipes on every stack; the east stack today runs outside the east wall behind a removable cladding.
    + *First-floor bathrooms:* a *sunken waterproofed slab* (0.10–0.15 m, the leak kept inside the bathroom) wherever the bay allows it (the ribbed bays; the suite bath has it, X10), OR suspended drains only above *service rooms and corridors* behind access panels with acoustic lagging; *never* above bedrooms, the majlis, the living or the kitchen's hood zone.
    + *No smell:* real *vent stacks to the roof* (the west shaft and the east stack; ≥ 3 m from the HRV intake and the malqaf), *deep-seal traps* (≥ 75 mm) on every fixture, *anti-odour floor drains* (membrane or ball type, with a primer) on the rarely used drains: the courtyard, the suite court, the laundry and the utility room, the breeze channel's sump.
    + *Water:* a *manifold system* (one continuous PEX pipe from the manifold to each fixture, no buried joints), a *manifold cabinet per floor near the shaft* with a valve per fixture (west: the utility room GF, the family bath's wall FF; east: the laundry GF, the suite WC closet's wall FF); *one water heater per cluster* close to its bathrooms (west: the utility room; east: the laundry, serving the kitchen, the maid bath and the suite bath above); a *booster pump* from the tank (site plan) with a main sediment filter in the utility room; an *RO unit* at the kitchen sink.
    + *Leak protection:* leak sensors under the heaters, the washer, the dishwasher and every basin cabinet, wired to an *automatic main shut-off valve* after the filter; drip trays under the heaters and the washer, drained to a floor drain; the first-floor bathrooms' sunken slabs are the second line.
    #v(2pt)
    #H[1 · Inventory: every wet point (both floors and the roof)]
    #table(columns: (auto, 1fr, 1.4fr, auto, auto, auto), inset: 1.6pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      ..([Fl.], [Room], [Fixtures], [Drains to], [Branch m], [Use]).map(c => text(6pt, weight: "bold", fill: accent, c)),
      ..pts.map(p => (text(5.6pt)[#p.fl], text(5.6pt)[#p.room], text(5.6pt)[#p.fix], text(5.6pt)[#p.to], text(5.6pt)[#if p.fl == "roof" [—] else [#r1(L(p))]], text(5.6pt)[#p.use])).flatten())
    #text(5.8pt, fill: gray)[Branch = the horizontal drain from the fixture to its collector (the buried run, a stack or the manhole), measured on the routes drawn; the roof outlets (11) and the AC / HRV condensate are listed, not scored. Total of the scored branches: #r1(total-len) m.]
  ],
  overlay-plan(),
)

// ====================================================================================== PAGE 2 · constraints and the overlay verdicts
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[2 · Constraints map · what lies under each first-floor wet room · the stacks and the routes to the septic]
#v(2pt)
#grid(columns: (auto, 1fr), gutter: 10pt,
  constraints-plan(),
  [
    #set text(6.4pt)
    #H[No-drain zones above]
    - *Habitable rooms (no drains in their ceilings):* the women's majlis, the men's majlis, the living and the dining, the maid room (a bedroom); on the first floor every bedroom, the kids' room, the family living, the office and the gym carry only the roof (no first-floor fixtures above them). *The kitchen:* its *hood zone* on the east wall (y 10.2–11.2) takes no drain above it; the rest of the kitchen's ceiling carries the suite bath only inside a sunken tanked slab (no suspended pipes in the kitchen's ceiling). *The electrical panel and the battery space* (the utility room's north part) and the *lift shaft*: nothing above or beside.
    #H[Structure]
    - *Drop beams* (blue): B1 (y 3.0), B4 (x 4.25), B5 (x 8.95 south of y 13), B6 (y 6.5), B8 / B22 (y 19.25), the edge beam B3: a drain never crosses a drop beam; branches run parallel to them or through sleeves cast in the hidden beams (the engineer).
    - *Slabs:* the west band, the riwaq, the maid wing and the women's majlis roof are *solid 0.20*: a sunken bathroom zone there means a thicker bay (0.35 with the top depressed 0.15) or a raised floor; the kitchen, dining and men's majlis roofs are *ribbed 0.30*: a 0.10–0.15 depressed zone is possible (the suite bath has one). The family bath F-b over the utility room / hospitality kitchen is on the solid west band: its sunken zone needs the thicker bay (X10-type detail) or its drains stay suspended above the two *service* rooms behind panels (allowed by principle 4).
    - *The malqaf breeze channel* (amber) in the ground slab from the tower south on x 10.2 to y 10.5 then west under the kitchen's sink counter: the kitchen's drain crosses it (the sink's branch passes *under* the channel's base slab, or the channel bridges it: the engineers); the *foundations* (pads ≈ 1.5 × 1.5 under the columns, strip footings under the RC walls): the buried drains pass between them; the *courtyard*: its drains run east under the kitchen floor to the east manhole's rain branch.
    #H[The two stacks and the routes to the septic]
    - *West:* the shaft (0–1.5 × 9.2–10.4) carries the west stack and vent from the family bath / WC compartment down to the buried west run, which collects the hospitality kitchen, the family basins, the family WC (its own small stack takes bedroom 3's bath from above) and the guest WC and basins, and leaves under the west wall to the *west manhole* on the driveway. *East:* the stack outside the east wall beside the suite WC closet takes the suite bath, drops to the yard and runs south to the *east manhole*, which also takes the kitchen, the laundry, the maid bath (buried, east) and the courtyard's rain branch. Both manholes run to the *collector manhole* at the garden's south-east and the *existing septic* (site plan; the capacity, the condition and the well distance flagged).
    #H[Overlay verdicts]
    #table(columns: (1fr, 1.6fr, auto), inset: 1.8pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      ..([First-floor wet room], [Below it], [Verdict]).map(c => text(6pt, weight: "bold", fill: accent, c)),
      ..overlay.map(((n, rs)) => (text(5.8pt)[#n], text(5.8pt)[#rs.map(r => r.at(0)).join(", ")], if verdict(rs) == "good" { text(5.8pt, fill: green, weight: "bold")[good: over wet / service] } else { text(5.8pt, fill: red, weight: "bold")[problem: over the kitchen] })).flatten())
  ],
)

// ====================================================================================== PAGE 3 · scores and alternatives
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[3 · Score of every wet room · 4 · Alternatives for the rooms that score poorly]
#v(2pt)
#grid(columns: (1.2fr, 1fr), gutter: 10pt,
  [
    #set text(6.3pt)
    #table(columns: (auto, 1fr, 1.2fr, auto, auto, auto, auto, auto, auto), inset: 1.6pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      ..([Fl.], [Room], [Fixture], [m], [bends], [over], [access], [smell], [score / 10]).map(c => text(5.8pt, weight: "bold", fill: accent, c)),
      ..wet-rows.map(p => (text(5.5pt)[#p.fl], text(5.5pt)[#p.room], text(5.5pt)[#p.fix], text(5.5pt)[#r1(L(p))], text(5.5pt)[#bends(p.route)],
        text(5.5pt)[#if p.fl == "GF" [buried] else if p.room == "Suite court" [majlis roof (rain)] else if p.room.contains("Suite") [kitchen] else [wet / service]],
        text(5.5pt)[#if p.to == "W-SHAFT" [shaft door] else if p.to == "FWC" [stack panel] else if p.fl == "GF" [cleanout] else [outside stack]],
        text(5.5pt)[#if p.use.contains("rare") or p.use.contains("rain") [anti-odour drain] else [trap + vent]],
        text(5.5pt, weight: "bold", fill: if score(p) >= 7 { green } else if score(p) >= 5 { amber } else { red })[#r1(score(p))])).flatten())
    #text(5.8pt, fill: gray)[Score = branch length (3) + bends (2) + stacked over a wet / service room (2) + maintenance access (1.5) + smell risk (1.5); structural impact and cost are in the text; the weights are this study's, not a code. Mean today: #r1(s-mean(scen-A)).]
  ],
  [
    #set text(6.4pt)
    #H[The rooms that score poorly, and their alternatives]
    - *The suite bath and its WC closet (over the kitchen):* the only first-floor wet room over a problem room, and the house's longest first-floor branch (the vanity on the west wall, #r1(L(wet-rows.find(p => p.fix == "double vanity (west wall)"))) m). *Alternatives:* (a) *keep it* with its sunken tanked slab 0.15 (exists, X10), every branch inside the sunken zone, the vanity branch along the north wall; nothing in the kitchen's ceiling; (b) *move the vanity to the east side* beside the stack (#r1(L(vanity-B)) m) and the tub to the north wall (#r1(L(tub-B)) m): the branches shorten, the room keeps its function (a double vanity still faces the east light from the window); (c) *swap the bath and the dressing* (the bath over the kitchen's south part / the dining): still over the kitchen and farther from the stack: worse; (d) *move the bath over the laundry / maid wing* (y ≤ 7.0): the suite lobby and bedroom 1 are there: not possible without re-planning the suite. *Chosen for B and C: (b).*
    - *The suite court's gutter outlets* (rain, in the men's majlis's south wall): (a) keep, with acoustic lagging; (b) run the two outlets to the court's ends and down inside the *gym's and the office's* walls to the garden: no pipe in a majlis wall. *Chosen for B: (b).*
    - *The courtyard's drain, overflow and basin* (#r1(L(wet-rows.find(p => p.room == "Courtyard"))) m east under the kitchen floor): buried, fine; anti-odour drain and the basin's own trap; a cleanout at the kitchen's west wall. Keep.
    - *The maid bath* (#r1(L(wet-rows.find(p => p.room == "Maid bath"))) m round the cut corner): (a) keep; (b) *align its fixtures on the cut wall* with one short branch out through the cut wall to the strip, and the breeze channel's sump and the HRV condensate into the same branch. *Chosen for C.*
    - *The ground-floor shower* (G-07, deferred to this study): *P1* (the family WC + basins as one wet room on the west run, 0.5–1.5 m branches, a level floor drain in the ground slab: easy) scores as well as any fixture here; *P2* (the hospitality kitchen, 1 m from the shaft) is the plumbing optimum but re-plans three rooms; *P1-lite* (the family WC room only) is P1 without the basins. *Chosen for B and C: P1*, for its function as much as its plumbing.
    - *The laundry:* fine (buried east); C adds the east heater and manifold cabinet beside the washer and moves the utility sink next to it (one trap group).
  ],
)

// ====================================================================================== PAGE 4 · the three scenarios
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[4 · Three whole-house scenarios · A minimum · B moderate · C ideal · the comparison and the recommendation]
#v(2pt)
#grid(columns: (auto, auto, auto), gutter: 6pt, scen-plan(scen-A, "A"), scen-plan(scen-B, "B"), scen-plan(scen-C, "C"))
#v(3pt)
#grid(columns: (1.3fr, 1fr), gutter: 10pt,
  [
    #set text(6.3pt)
    #table(columns: (1.1fr, 1fr, 1fr, 1fr), inset: 1.8pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      ..([Criterion], [A · minimum], [B · moderate], [C · ideal]).map(c => text(6pt, weight: "bold", fill: accent, c)),
      [What changes], [nothing moves; cleanouts, two vent stacks, anti-odour drains, acoustic stacks, the manifold system, two heaters, leak protection], [A + the GF shower P1 (the family WC + basins → one wet room), the suite vanity beside the stack and the tub on the north wall, the court's outlets down the gym / office walls], [B + an internal accessible east duct (0.35 × 0.35, the kitchen's NE corner under the suite WC closet) with doors on both floors; the maid bath on the cut wall; the east heater + manifold in the laundry],
      [Total horizontal drain (scored branches)], [#r1(s-total(scen-A)) m], [#r1(s-total(scen-B)) m], [#r1(s-total(scen-C)) m],
      [Longest first-floor foul branch], [#r1(s-longest(scen-A)) m (the suite vanity)], [#r1(s-longest(scen-B)) m (the suite vanity)], [#r1(s-longest(scen-C)) m],
      [Wet rooms over a problem room], [#s-over(scen-A) (the suite bath over the kitchen: sunken tanked slab)], [#s-over(scen-B) (the same)], [#s-over(scen-C) (the same; its branches now reach an internal duct)],
      [Maintenance access], [the west shaft (doors), the east stack outside behind cladding, cleanouts], [as A; the GF wet room's floor drain from above], [every stack behind a door on each floor; no outside pipe],
      [Smell risk], [low: vents, deep traps, anti-odour drains], [low], [lowest: the rare drains grouped on the east duct with a primer],
      [Structural changes], [none (the suite bath's sunken zone exists)], [B14 under the removed wall of the family WC (a drop beam, the shower study)], [B + a 0.35 × 0.35 opening through the kitchen roof slab beside C33 and the east wall (the engineer)],
      [Rough relative cost], [1.0 (the base: pipes, stacks, manifolds, 2 heaters, sensors)], [≈ 1.15 (one wet room re-fitted, a beam, a window)], [≈ 1.3 (the duct, the maid bath re-fit, the laundry re-fit)],
      [Function impact], [none], [the wudu basins behind a sliding door; the suite vanity on the east side (lit by the window)], [B + the maid bath re-planned (same size), the laundry loses 0.6 m of counter],
      [Fixtures scoring below 5 / mean], [#s-poor(scen-A) of #scen-A.len() / #r1(s-mean(scen-A))], [#s-poor(scen-B) of #scen-B.len() / #r1(s-mean(scen-B))], [#s-poor(scen-C) of #scen-C.len() / #r1(s-mean(scen-C))],
    )
  ],
  [
    #set text(6.4pt)
    #H[Recommendation: B, plus C's internal east duct if the engineer allows the slab opening]
    - The house is already well clustered: every first-floor wet room but one stands over a wet or service room, and the one exception (the suite bath over the kitchen) is mitigated by its sunken tanked slab and cannot be moved without re-planning the suite. So the gains lie in the *routes, the access and the venting* (A) and in a few short moves (B): the GF shower as P1, the suite vanity beside the stack, the court's outlets out of the majlis wall. B costs little and removes the longest branch.
    - C's one real gain is the *internal east duct*: it brings the east stack indoors behind a door on each floor (maintenance without breaking walls, no pipe on the facade) at the price of a slab opening in the kitchen's corner; the maid bath and laundry re-fits are small. *Take the duct if the engineer accepts the opening; leave the rest of C.*
    - *In every scenario:* the sunken slabs are the second line against leaks; the manifold system and the sensors with the automatic valve are the first; the two vent stacks run to the roof ≥ 3 m from the HRV intake (#r1(dist(west-stack, hrv-intake)) / #r1(dist(east-stack, hrv-intake)) m).
    #v(2pt)
    #H[Decisions needed from the owner]
    + *Scenario:* A, B (recommended) or C; and, with B, *the internal east duct* from C (yes / no, subject to the engineer).
    + *The GF shower:* P1 confirmed as the wet room of the west cluster (or P1-lite / P2)?
    + *The suite bath:* the vanity moved to the east side beside the stack (B) — accepted?
    + *The suite court's outlets* down the gym / office walls instead of the majlis wall (B)?
    + *Heaters:* two electric cylinders (west ≈ 100–120 L in the utility room, east ≈ 150 L in the laundry), or a central heat-pump unit on the roof with a ring main (less space inside, more pipe)? (to be sized by the engineer)
    + *The utility room's door* moved south (y 9.45–10.2, 0.75 wide) to free the north wall for the panel and the batteries (page 5)?
  ],
)

// ====================================================================================== PAGE 5 · the utility room
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[The utility room (west cluster): the shaft, the panel, the battery space, the heater, the manifold, the access clearances · the water kept away from the batteries]
#v(2pt)
#grid(columns: (auto, 1fr), gutter: 12pt,
  utility-plan(),
  [
    #set text(6.5pt)
    #H[Layout (proposal, every size assumed)]
    - *The room:* x 0–2.75, y 7.9–10.4 on axes, *2.525 × 2.3 m clear*; the *shaft* 1.5 × 1.2 in its south-west corner (the west stack and vent, the PV conduits from the roof, the cold and hot risers to the first floor), its *access panels on the north face* (removable, 1.1 m wide) so the shaft is serviced from the room's north part; the *door* moved from y 8.2–9.0 to *y 9.45–10.2* (0.75 wide, hinged on the south jamb, opening west: its swing stays south of the battery wall), a proposal for `design_gf.typ`.
    - *Dry side (north and west):* the *main electrical panel* on the west wall (x 0.125–0.35, y 8.1–9.0) with 0.9 m clear in front; the *inverter and the battery cabinet* 1.0 × 0.4 on the *north wall's east part* (x 1.6–2.6): nothing wet above or beside it — above it lies the family bath's *dry linen zone* (x 1.5–2.75, y 7.9–9.2), the WC compartment sits over x 0–1.5 only, and the bath's slab is sunken and tanked; the heater is #r2(box-dist(battery, heater)) m away, the manifold #r2(box-dist(battery, manifold)) m, with a drip tray under each. The alarm panel and the recorder (site plan) share the dry side.
    - *Wet side (south):* the *water heater* (an electric cylinder Ø 0.40, ≈ 100–120 L, floor-standing on a drip tray with a leak sensor) at x 1.6–2.0 beside the shaft's east face; the *manifold cabinet* wall-hung above 1.8 m on the shaft's east face (x 1.5–1.6, y 9.2–10.3, above the heater's top) with the valves, the main sediment filter, the booster pump's connection and the automatic shut-off valve; the floor drain by the heater into the west stack.
    - *Clearances:* 0.9 m in front of the panel #OK, the battery's front free to the door swing #OK, the heater reachable from the room's middle, the shaft panels reachable from the north part; the free floor ≈ #r2(ut-free) m².
    #H[Flags]
    - *The room is small:* with the shaft it leaves #r2(ut-free) m² of free floor; a 200 L cylinder or a heat-pump unit does not fit (a roof heat pump would); the batteries and the water share one room by the owner's decision, with the layout above as the condition. *The electrical engineer confirms* the battery cabinet's space, its ventilation (a lithium cabinet, ventilated to the riwaq or the shaft), its fire safety (a steel cabinet, ≥ 0.5 m from combustibles, the smoke alarm by the stair, ideally a 60-minute separation to the stair store) and the panel's position.
    - *If the engineer wants more:* the store under the stair's half landing (north of this wall, 2.525 × 1.25, 1.65 m high, the stair above it, dry) can take the battery cabinet instead, with a fire-rated door; the owner's decision today is the utility room.
    #v(3pt)
    #text(8pt)[#if all-ok [*Study checks passed* (#checks.len())] else [*STUDY CHECKS FAILED:* #checks.filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]]
    #v(2pt)
    #text(6pt, fill: gray)[Checks: #checks.map(c => c.at(0)).join([ · ]). Every size is assumed, to be designed by the plumbing engineer; nothing here changes the room CSVs or the design files.]
  ],
)

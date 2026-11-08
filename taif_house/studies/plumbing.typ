// plumbing.typ · Taif / Palm House V8.1 (work) · PLUMBING AND WET-ROOM STUDY, round 1 (design review E-03, G-07; open item 10) · 2 Nov 2026 · STUDY ONLY.
// Owner's goals: maintenance without breaking floors or walls, no drain smells, low leak risk, high quality, controlled cost. Nothing is fixed: wet rooms may
// move if that makes the system clearly better, as long as the rooms keep their function. Latest geometry: the flipped stair, the family bath F-b, the south
// wing v2, the maid room and kitchen changes, the site plan's manholes and septic route. EVERY SIZE IS ASSUMED, TO BE DESIGNED BY THE PLUMBING ENGINEER.
// Nothing here changes the room CSVs or the design files: inventory, constraints, scores, alternatives, three scenarios, a recommendation, the utility room.
// CSV frame: x east, y south, wall centre lines; levels above the finished ground floor ±0.00. Geometry copied from data/rooms_*.csv, design_gf.typ, studies/*.typ.
#import "@preview/cetz:0.4.2"
#import "../base.typ": dist as sdist
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
  ("Hospitality kitchen", rect-pts(0, 10.4, 2.75, 12.9), "wet"), ("Family powder room", rect-pts(0, 12.9, 2.75, 16.1), "wet"),
  ("Serving passage", rect-pts(0, 16.1, 2.75, 17.5), "circ"), ("Guest WC", rect-pts(1.25, 17.5, 2.75, 19.25), "wet"), ("Guest basins", rect-pts(1.25, 19.25, 2.75, 21.4), "wet"),
  ("Guest passage", rect-pts(0, 17.5, 1.25, 21.4), "circ"), ("Foyer", rect-pts(0, 21.4, 2.75, 24), "circ"), ("Lobby + riwaq", ((2.25, 0), (4.25, 0), (4.25, 19.25), (2.75, 19.25), (2.75, 2.2), (2.25, 2.2)), "circ"),
  ("Women's majlis", rect-pts(4.25, 0, 8.95, 6.5), "habitable"), ("Courtyard", rect-pts(4.25, 6.5, 8.95, 13.0), "open"), ("Living (double height)", rect-pts(4.25, 13.0, 8.95, 19.25), "habitable"),
  ("Men's majlis", rect-pts(2.75, 19.25, 13.311, 24), "habitable"), ("Maid bath", ((8.95, 1.0), (10.094, 1.0), (10.601, 1.933), (11.303, 1.551), (11.982, 2.8), (8.95, 2.8)), "wet"),
  ("Maid room (a bedroom)", ((10.65, 2.8), (11.982, 2.8), (13.311, 5.245), (13.311, 7.0), (10.65, 7.0)), "habitable"), ("Laundry", rect-pts(8.95, 2.8, 10.65, 7.0), "wet"),
  ("Kitchen", rect-pts(8.95, 7.0, 13.311, 13.0), "kitchen"), ("Dining", rect-pts(8.95, 13.0, 13.311, 19.25), "habitable"),
)
#let ff-wet = (
  ("Bedroom 2 bath", ((1.5, 9.2), (4.25, 9.2), (4.25, 11.0), (0, 11.0), (0, 10.4), (1.5, 10.4))), ("Family WC", rect-pts(0, 7.9, 2.75, 9.2)),
  ("Bedroom 3 bath", rect-pts(0, 14.4, 2.2, 16.1)), ("Suite bath", ((10.3, 6.5), (12.211, 6.5), (12.211, 8), (13.311, 8), (13.311, 10.45), (10.3, 10.45))), ("Suite WC closet", rect-pts(12.211, 6.5, 13.311, 8)),
)
#let ff-dry = (("Kids' room", rect-pts(4.25, 0, 8.95, 3.0)), ("Family living", rect-pts(4.25, 3.0, 8.95, 6.5)), ("Bedroom 1", ((8.95, 1), (10.094, 1), (10.601, 1.933), (11.303, 1.551), (13.311, 5.245), (13.311, 6.5), (10.15, 6.5), (10.15, 5.3), (8.95, 5.3))), ("Bedroom 2", rect-pts(0, 11.0, 4.25, 14.4)), ("Bedroom 3", ((2.2, 14.4), (4.25, 14.4), (4.25, 19.25), (0, 19.25), (0, 16.1), (2.2, 16.1))), ("Suite bedroom", ((8.95, 11.9), (10.3, 11.9), (10.3, 13.9), (13.311, 13.9), (13.311, 19.25), (8.95, 19.25))), ("Suite dressing", rect-pts(10.3, 10.45, 13.311, 13.9)), ("Gym", ((0, 19.25), (5.8, 19.25), (5.8, 20.55), (4.25, 20.55), (4.25, 24), (0, 24))), ("Office", rect-pts(10, 19.25, 13.311, 24)))
#let scourt = ((4.25, 20.55), (5.8, 20.55), (5.8, 19.25), (10, 19.25), (10, 24), (4.25, 24))
#let hood = (12.5, 10.2, 13.311, 11.2)        // the kitchen's hood zone on the east wall: no drains above
#let panel-zone = (0, 7.9, 1.5, 9.2)           // the utility room's north-west part: the main panel (west wall) — and, since 2 Nov 2026, the battery space on the north wall (east part, see the utility room page)
#let battery = (1.6, 8.0, 2.6, 8.4)            // the inverter + battery cabinet (utility room, north wall, east part): nothing wet above or beside
#let shaft = (0, 9.2, 1.5, 10.4)               // the west shaft (GF utility room → FF → roof): the west stack and vent
#let west-stack = (1.5, 9.8)                   // the stack's foot in the shaft (east side)
#let fwc-stack = (1.5, 14.9)                   // the family WC's stack (bedroom 3's bath drains straight down into it)
#let east-stack = (13.311, 7.05)               // the suite bath's stack outside the east wall (V6.3), beside the suite WC closet
#let mh-east = (14.3, 13.5)                    // the east-yard FOUL chamber (site plan); the rain has its own chamber (round 2)
#let mh-west = (-1.9, 24.7)                    // the west run's manhole on the driveway (site plan)
#let west-run = ((0.5, 10.5), (0.5, 21.6), (-1.9, 24.7))   // the buried ground-floor run under the west wash block, south to the west manhole
#let channel = (((10.2, 1.0), (10.2, 10.5)), ((10.2, 10.5), (9.05, 10.5)))   // the malqaf breeze channel in the ground slab (air v3.1): 0.9 × 0.20 inside the slab depth
#let hrv-intake = (8.95, 1.5)                  // V9.3: the malqaf tower's intake louvre (its west face below the band, +9.83): vents ≥ 3 m away
#let beams-drop = (("B1", (4.25, 3.0), (8.95, 3.0)), ("B4", (4.25, 6.5), (4.25, 19.25)), ("B5", (8.95, 13.0), (8.95, 19.25)), ("B6", (8.95, 6.5), (13.311, 6.5)), ("B8", (2.75, 19.25), (13.311, 19.25)), ("B22", (0, 19.25), (2.75, 19.25)), ("B3", (5.8, 6.5), (5.8, 19.25)))
#let slabs = (("west band: solid 0.20", rect-pts(0, 0, 2.75, 24)), ("riwaq: solid 0.20", rect-pts(2.75, 0, 4.25, 19.25)), ("women's majlis roof: solid 0.20", rect-pts(4.25, 0, 8.95, 6.5)), ("maid wing: solid 0.20 (no sunken zone without thickening)", rect-pts(8.95, 0, 13.311, 6.5)), ("kitchen roof: ribbed 0.30 (the suite bath sunken 0.15 inside it, X10)", rect-pts(8.95, 6.5, 13.311, 13.0)), ("dining roof: ribbed 0.30", rect-pts(8.95, 13.0, 13.311, 19.25)), ("men's majlis roof: ribbed 0.30 (the suite court depressed)", rect-pts(2.75, 19.25, 13.311, 24)))

// ---------- 1 · Inventory: every wet point (floor, room, fixture, point, the collector it drains to, the drain route as a polyline, use) ----------
// collectors: W-RUN (the buried GF run under the west wash block), W-SHAFT (the west stack), FWC (the family WC's stack), E-STACK (the east wall stack), E-MH (the east-yard manhole, buried), RAIN (the rain branch to the east manhole / soakaways)
#let W = ("W-RUN", "W-SHAFT", "FWC", "E-STACK", "E-MH", "RAIN")
#let pts = (
  // ground floor, west cluster
  (fl: "GF", room: "Hospitality kitchen", fix: "sink", p: (0.8, 10.8), to: "W-RUN", route: ((0.8, 10.8), (0.5, 10.8)), use: "daily"),
  (fl: "GF", room: "Family powder room", fix: "2 stone basins (vanity)", p: (1.0, 13.3), to: "W-RUN", route: ((1.0, 13.3), (0.5, 13.3)), use: "daily"),
  (fl: "GF", room: "Family powder room", fix: "wall-hung WC (south service wall)", p: (0.95, 15.6), to: "W-RUN", route: ((0.95, 15.6), (0.5, 15.6)), use: "daily"),
  (fl: "GF", room: "Guest WC", fix: "WC + basin", p: (1.6, 18.6), to: "W-RUN", route: ((1.6, 18.6), (0.5, 18.6)), use: "guests"),
  (fl: "GF", room: "Guest basins", fix: "trough, 3 taps", p: (2.4, 20.3), to: "W-RUN", route: ((2.4, 20.3), (2.4, 21.6), (0.5, 21.6)), use: "guests"),
  (fl: "GF", room: "Utility room", fix: "heater drip tray · condensate", p: (1.75, 10.1), to: "W-SHAFT", route: ((1.75, 10.1), (1.5, 10.1)), use: "rare"),
  // ground floor, east cluster
  (fl: "GF", room: "Kitchen", fix: "sink + dishwasher", p: (9.35, 8.6), to: "E-MH", route: ((9.35, 8.6), (9.35, 9.9), (13.311, 9.9), (14.3, 13.5)), use: "daily"),
  (fl: "GF", room: "Laundry", fix: "washer · dryer · utility sink · floor drain", p: (9.35, 4.0), to: "E-MH", route: ((9.35, 4.0), (9.35, 6.6), (13.311, 6.6), (14.3, 13.5)), use: "daily / rare (floor drain)"),
  (fl: "GF", room: "Maid bath", fix: "WC · basin · shower", p: (9.4, 2.4), to: "E-MH", route: ((9.4, 2.4), (11.6, 2.6), (12.5, 3.0), (14.0, 6.0), (14.3, 13.5)), use: "daily"),   // V9.3: the WC and the shower on the west wall, off the breeze channel's line; the branch passes BELOW the channel's base slab
  (fl: "GF", room: "Courtyard", fix: "2 linear drains (level floor) · overflow · trough + planter", p: (8.6, 12.6), to: "RAIN", route: ((8.6, 12.6), (13.311, 12.6), (14.8, 12.6)), use: "rain / washing"),
  (fl: "GF", room: "Air tower", fix: "breeze channel sump · HRV condensate", p: (10.674, 1.25), to: "E-MH", route: ((10.674, 1.25), (11.4, 1.6), (12.0, 2.2), (14.0, 6.0), (14.3, 13.5)), use: "rare"),
  // first floor, west cluster
  (fl: "FF", room: "Bedroom 2 bath", fix: "shower channel (trap in the service wall)", p: (3.6, 9.3), to: "W-SHAFT", route: ((3.6, 9.3), (3.6, 9.2), (1.5, 9.2)), use: "daily"),
  (fl: "FF", room: "Bedroom 2 bath", fix: "wall-hung WC (service wall)", p: (2.3, 9.3), to: "W-SHAFT", route: ((2.3, 9.3), (2.3, 9.2), (1.5, 9.2)), use: "daily"),
  (fl: "FF", room: "Bedroom 2 bath", fix: "vanity basin (niche on the shaft)", p: (0.75, 10.45), to: "W-SHAFT", route: ((0.75, 10.45), (0.75, 10.4)), use: "daily"),
  (fl: "FF", room: "Family WC", fix: "wall-hung WC + basin (service wall)", p: (0.85, 9.05), to: "W-SHAFT", route: ((0.85, 9.05), (0.85, 9.2)), use: "daily"),
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
#let scen-B = wet-rows.filter(p => p.fix != "double vanity (west wall)" and p.fix != "tub (by the east window)" and p.room != "Suite court") + (vanity-B, tub-B, court-B)   // 3 Nov 2026: P1 withdrawn (owner: no ground-floor shower); the powder room's rows stay
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
  line(q((0, 0)), q((10.461, 0)), q((13.311, 5.245)), q((13.311, 24)), q((0, 24)), close: true, stroke: 1.1pt + ink)
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
  line(q((0, 0)), q((10.461, 0)), q((13.311, 5.245)), q((13.311, 24)), q((0, 24)), close: true, stroke: 1.1pt + ink)
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
  line(q((0, 0)), q((10.461, 0)), q((13.311, 5.245)), q((13.311, 24)), q((0, 24)), close: true, stroke: 1.1pt + ink)
  T((6.6, 24.8), [CONSTRAINTS · red = no drains above (habitable rooms, the kitchen's hood zone, the panel, the batteries, the lift) · blue = drop beams · beige = ribbed bays (a sunken zone possible) · 1 m = 0.5 cm], size: 3.2pt, fill: accent)
})
#let scen-plan(S, name, length: 0.36cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, body, size: 3pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, body))
  let poly(P, fill: none, stroke: none) = line(..P.map(q), close: true, fill: fill, stroke: stroke)
  for (n, P, k) in gf { poly(P, fill: if k == "wet" { wet } else if k == "kitchen" { rgb("#f3d6c4") } else { rgb("#f2efe8") }, stroke: 0.3pt + luma(150)) }
  for (n, P) in ff-wet { poly(P, fill: blue.transparentize(60%), stroke: 0.8pt + blue) }
  if name != "A" { rect(q((0, 12.9)), q((2.75, 16.1)), fill: green.transparentize(50%), stroke: 0.8pt + green); T((1.4, 14.5), [powder room], size: 2.6pt, fill: white) }
  if name == "C" { rect(q((east-duct.at(0), east-duct.at(1))), q((east-duct.at(2), east-duct.at(3))), fill: rgb("#8a5a2b"), stroke: none); T((12.4, 7.2), [E duct], size: 2.5pt, fill: rgb("#8a5a2b"), anchor: "east") }
  for p in S { line(..p.route.map(q), stroke: (paint: if p.fl == "GF" { blue } else { rgb("#8a5a2b") }, thickness: 0.7pt), mark: (end: ">", fill: if p.fl == "GF" { blue } else { rgb("#8a5a2b") }, scale: 0.35)); circle(q(p.p), radius: 0.18, fill: if p.fl == "GF" { blue } else { rgb("#8a5a2b") }, stroke: none) }
  rect(q((shaft.at(0), shaft.at(1))), q((shaft.at(2), shaft.at(3))), fill: luma(120), stroke: none)
  circle(q(east-stack), radius: 0.22, fill: rgb("#8a5a2b"), stroke: none); circle(q(mh-east), radius: 0.3, fill: white, stroke: 0.8pt + rgb("#8a5a2b")); circle(q(mh-west), radius: 0.3, fill: white, stroke: 0.8pt + rgb("#8a5a2b"))
  line(..west-run.map(q), stroke: (paint: rgb("#8a5a2b"), thickness: 0.8pt, dash: "dashed"))
  line(q((0, 0)), q((10.461, 0)), q((13.311, 5.245)), q((13.311, 24)), q((0, 24)), close: true, stroke: 1pt + ink)
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
  line(q((0.125, 7.9)), q((2.65, 7.9)), stroke: (paint: blue, thickness: 0.8pt, dash: "dashed")); T((1.4, 7.7), [the family WC (y 7.9–9.2) and bedroom 2's bath above: every fixture on the service wall y 9.2 into the shaft; the floor dry over the batteries], size: 2.5pt, fill: blue)
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
    + *Two clusters only:* west round the shaft (the utility room, the hospitality kitchen, the family powder room, the guest WC and basins; above: the family WC and bedroom 2's bath on one service wall by the shaft (3 Nov 2026), bedroom 3's bath) and east along the east wall (the kitchen, the laundry, the maid bath; above: the suite bath and its WC closet). *No third cluster* (bedroom 1 stays without a bath: decided).
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
    - *West:* the shaft (0–1.5 × 9.2–10.4) carries the west stack and vent from the family WC and bedroom 2's bath (their service wall y 9.2, 3 Nov 2026) down to the buried west run, which collects the hospitality kitchen, the family powder room (its south service wall holds bedroom 3's stack from above) and the guest WC and basins, and leaves under the west wall to the *west manhole* on the driveway. *East:* the stack outside the east wall beside the suite WC closet takes the suite bath, drops to the yard and runs south to the *east manhole* (foul only), which also takes the kitchen, the laundry and the maid bath (buried, east); the courtyard's rain goes to its own chamber (round 2, A2). Both manholes run to the *collector manhole* at the garden's south-east and the *existing septic* (site plan; the capacity, the condition and the well distance flagged).
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
    - *The courtyard's drain, overflow and basin* (#r1(L(wet-rows.find(p => p.room == "Courtyard"))) m east under the kitchen floor to its own rain chamber, never the foul one): buried, fine; anti-odour drain and the basin's own trap; a cleanout at the kitchen's west wall. Keep.
    - *V9.3 constraint for the bathrooms interior study:* the breeze channel keeps its *full 0.90 m width* under the maid bath (no throat, studies/air_system.typ): *the maid bath's WC and shower drains (and their traps and floor channel) stay off the channel's line*, x ≈ 9.75–10.65 (the WC and the shower on the west wall, the basin east of the line); a drain that must cross passes below the channel's base slab.
    - *The maid bath* (#r1(L(wet-rows.find(p => p.room == "Maid bath"))) m round the cut corner): (a) keep; (b) *align its fixtures on the cut wall* with one short branch out through the cut wall to the strip, and the breeze channel's sump and the HRV condensate into the same branch. *Chosen for C.*
    - *The ground-floor shower* (G-07; *withdrawn by the owner on 3 Nov 2026: no shower and no hidden provision on the ground floor; the family WC and basins become one powder room*; the text below is the round-1 record): *P1* (the family WC + basins as one wet room on the west run, 0.5–1.5 m branches, a level floor drain in the ground slab: easy) scores as well as any fixture here; *P2* (the hospitality kitchen, 1 m from the shaft) is the plumbing optimum but re-plans three rooms; *P1-lite* (the family WC room only) is P1 without the basins. *Chosen for B and C: P1*, for its function as much as its plumbing.
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
    + *The GF shower:* ~~P1 confirmed as the wet room of the west cluster (or P1-lite / P2)?~~ *Decided 3 Nov 2026: no ground-floor shower; the powder room instead.*
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
    #text(8pt)[#if all-ok [*Round 1 checks passed* (#checks.len())] else [*ROUND 1 CHECKS FAILED:* #checks.filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]]
    #v(2pt)
    #text(6pt, fill: gray)[Round 1 checks: #checks.map(c => c.at(0)).join([ · ]). Every size is assumed, to be designed by the plumbing engineer; nothing here changes the room CSVs or the design files. Round 2 (3 Nov 2026) follows on pages 6–11.]
  ],
)

// ---------- round 2 uses the site plan's corrected positions (site frame: the house = CSV + (0.91, 5.063); 4 Nov 2026: the house 1.238 m further south) ----------
#let S(p) = (p.at(0) + 0.91, p.at(1) + 6.0734)   // 8 Nov 2026: B1 6.00 m from M1 (a further 0.5104 m south); 6 Nov 2026: 5.563
#let septic = (-10.5, -1.9, -6.5, 0.5)
#let tank-old = (-7.5, 35.7, -4.5, 38.2)         // 5 Nov 2026 (owner): south of the old house, west of the driveway near peg R (copied from studies/site_plan.typ)
#let sep-rule = (septic-well: 30.0, septic-tank: 15.0, drain-pipe: 1.5, tank-house: 5.0)
#let inv-septic = -1.24                        // from studies/site_plan.typ (computed there; copied; 8 Nov 2026: B1 6.00 m from M1, the main 38.8 m, the inlet unchanged at −1.24; 6 Nov 2026: the house 0.50 m further south, the main 38.4 m; 5 Nov 2026: the chamber at the wall added)
#let pbox-dist(b, p) = { let dx = calc.max(b.at(0) - p.at(0), 0, p.at(0) - b.at(2)); let dy = calc.max(b.at(1) - p.at(1), 0, p.at(1) - b.at(3)); calc.sqrt(dx * dx + dy * dy) }
#let ground-gate = -0.40

// ====================================================================================== ROUND 2 (3 Nov 2026) · the owner's provisional baseline; A2 corrections; A1 the suite bath over the kitchen; A3 the east stack; A4 smells
// Baseline (owner, provisional): scenario B; the suite bathtub STAYS by the south wall / the east window; P1 and the suite court's outlets down the gym and office walls are the direction.
// EVERY SIZE IS ASSUMED, TO BE DESIGNED BY THE PLUMBING ENGINEER; nothing here is proven (no cost, length or depth is more than an estimate on the drawings' geometry).
#let ffl = 3.60                                  // the first floor's finished level (params.yaml)
#let fin = 0.08                                  // the finish build-up assumed in the house (screed + tiles)
#let slab-top = ffl - fin                        // +3.52 the ribbed slab's top (normal)
#let sunk = 0.15                                 // the suite bath's depressed zone (structure.typ, X10)
#let sunk-top = slab-top - sunk                  // +3.37
#let slab-d = 0.30                               // the ribbed slab's depth
#let soffit = sunk-top - slab-d                  // +3.07 under the depressed zone (the engineer: the depth kept)
#let k-ceil = 2.90                               // the kitchen's gypsum ceiling under the bath (assumed): the lights only, no pipe
#let tank-m = 0.003; #let prot = 0.020           // the tanking membrane on the sunken slab + its protection screed
#let pipe-floor = sunk-top + tank-m + prot       // +3.393: the lowest a pipe's bottom may lie (option a)
#let tile = 0.014; #let mem2 = 0.002; #let screed = 0.050
#let pipe-top = ffl - tile - mem2 - screed       // +3.534: the highest a pipe's crown may lie under the screed (option a)
#let zone = pipe-top - pipe-floor                // the pipe zone's height
#let g = 0.02                                    // the fall of every branch (1:50), assumed
#let stack = (13.311, 7.05)                      // the east stack, outside the wall (x 13.436 … 13.6, behind the cladding)
#let wall-in = 13.186                            // the east wall's inner face
#let sw = 0.20                                   // the service wall (option b): x 12.986 … 13.186, y 6.5 … 9.5; a 0.45 m high duct y 9.5 … 10.45 under the window
#let sw-x = wall-in - sw
#let win = ((13.311, 9.5), (13.311, 10.05))      // the bath's east window, sill +1.5 head +2.1 above the floor (params.yaml)
#let hood-y = 10.2                               // the kitchen's hood zone starts here on the east wall (y 10.2–11.2): no drain south of it
// the fixtures (studies/ff_suite.typ): WC in the closet on the east wall, the walk-in shower on the east wall, the freestanding tub on the south wall by the east window, the double vanity on the west wall
#let fx = (
  (id: "WC", name: "WC (closet)", box: (12.536, 6.95, 13.186, 7.4), out: (13.0, 7.17), od: 0.110, trap: "integral, 50 mm seal",
   a: (body: 0.07, route: ((13.0, 7.17), (13.186, 7.1))), b: (how: "wall-hung on the service wall's frame; the outlet HORIZONTAL at +0.18 straight through the wall into the stack's branch", route: ((13.0, 7.17), (13.186, 7.1)), lvl: ffl + 0.18)),
  (id: "SH", name: "shower (east wall)", box: (12.086, 8.1, 13.186, 9.5), out: (13.1, 8.2), od: 0.050, trap: "channel trap, 50 mm seal (+ membrane valve)",
   a: (body: 0.09, route: ((12.6, 8.8), (13.1, 8.2), (13.186, 7.1))), b: (how: "a wall-drain channel along the service wall; the trap body INSIDE the wall cavity; the outlet runs north inside the cavity to the stack", route: ((13.1, 8.2), (13.1, 7.1), (13.186, 7.1)), lvl: ffl - 0.09)),
  (id: "TUB", name: "tub (south wall, by the window)", box: (11.486, 9.6, 13.186, 10.35), out: (12.3, 10.0), od: 0.050, trap: "tub trap, 50 mm seal (+ AAV in option b)",
   a: (body: 0.08, route: ((12.3, 10.0), (13.1, 7.3), (13.186, 7.1))), b: (how: "the tub on a 0.12 plinth with a removable front: the trap in the plinth's void ABOVE the floor; the pipe in the plinth, then in the low duct under the window, then in the service wall to the stack", route: ((12.3, 10.0), (13.1, 10.0), (13.1, 7.1), (13.186, 7.1)), lvl: ffl + 0.04)),
  (id: "VAN", name: "double vanity (west wall)", box: (10.4, 7.75, 10.95, 9.35), out: (10.9, 8.55), od: 0.040, trap: "bottle trap under the basin, 75 mm seal (visible)",
   a: (body: 0.07, route: ((10.9, 8.55), (11.6, 7.7), (13.1, 7.3), (13.186, 7.1))), b: (how: "the Ø 40 in a chase in the north wall at +0.45 (one jointless pipe from the trap), along the closet's north wall into the service wall, down to the stack", route: ((10.9, 8.55), (10.9, 6.6), (13.0, 6.6), (13.1, 7.1), (13.186, 7.1)), lvl: ffl + 0.45)),
)
#let runlen(P) = range(P.len() - 1).map(i => dist(P.at(i), P.at(i + 1))).sum()
#let bot-a(f) = ffl - f.a.body - f.od - g * runlen(f.a.route)          // option a: the pipe's bottom (outside) where it meets the stack, if its crown starts just under the screed
#let top-a(f) = ffl - f.a.body                                          // option a: the trap's outlet crown at the fixture
#let fits-a(f) = bot-a(f) >= pipe-floor - 1e-9 and top-a(f) <= pipe-top + 1e-9
#let bot-b(f) = f.b.lvl - f.od - g * runlen(f.b.route)                  // option b: the pipe's bottom at the stack
#let a-rows = fx.map(f => (f, top-a(f), bot-a(f), fits-a(f)))
#let tub = fx.find(f => f.id == "TUB")
#let tub-branch = runlen(tub.b.route)
#let vent-top = 7.20 + 1.0                                               // the stack's vent terminal 1.0 m above the roof slab (assumed)
#let win-head = ffl + 2.1
#let hrv-intake = (8.95, 1.5)   // V9.3: the malqaf tower's intake (west face)
#let duct = (12.95, 7.0, 13.3, 7.35)                                     // A3 option (b): the internal duct in the kitchen's north-east corner
#let service-door = ((13.311, 7.2), (13.311, 8.1))                       // the kitchen's service door on the east wall
#let duct-hits-door = duct.at(3) > service-door.at(0).at(1)              // the duct's south edge passes the door's north jamb
#let condensate = (
  ([AC indoor units (fan-coils, FF ceilings / the roof zone Z2b)], [Ø 25 PVC condensate pipe at 1 %, to a *tundish with an air gap* over a trapped waste in the nearest bathroom (the suite bath's service wall; the family bath's shaft) or to the roof's rain outlet (never a foul pipe directly)], [the receiving trap is a daily-used fixture's (the vanity / the channel): never dries], [the pan and the pipe flushed each season; the tundish is visible]),
  ([the HRV unit (roof plant, its base)], [Ø 25 to a *tundish with an air gap* over the roof's rain outlet (rain system: a condensate is clean water), with a dry-season drip tray], [no trap needed on the rain side; the outlet's leaf guard kept clear], [the HRV's drain pan cleaned at the filter change]),
  ([the malqaf / tower sump (the breeze channel's base, GF)], [a *trapped gully with an anti-odour membrane and a sealed access cover* at the channel's lowest point, drained by a *trapped air-break* (the gully's water seal + a 50 mm membrane valve) into the east foul branch (the maid bath's); it takes the channel's washing water and any wind-blown rain], [the membrane valve closes when the seal dries; a *trap primer* from the nearest cold tap (the laundry) or a monthly bucket of water (the maintenance list)], [through the tower's base door: the cover lifted, the gully basket and the membrane washed]),
  ([the heaters' drip trays (utility room, laundry) and the washer's tray], [the tray's Ø 32 to a floor drain with an *anti-odour membrane* (the west shaft's / the laundry's), an air gap at the tray], [the floor drain primed by the tray's rare water: a membrane valve, not a water seal alone], [the tray and the drain visible, cleaned with the room]),
  ([the kitchen's RO unit (its reject water) and the dishwasher], [to the sink's trap through an air-gap fitting (the RO) and a standpipe or the sink trap's spigot above its seal (the dishwasher): never a direct joint to the drain], [daily use keeps the sink's trap wet], [the air-gap fitting on the counter, the standpipe behind the dishwasher]),
)
#let smells = (
  ([the foul stacks' vent terminals (the west shaft, the east stack)], [open vents to the roof ≥ 1.0 m above the roof and ≥ 0.9 m above any opening within 3 m; ≥ 3 m from the HRV intake (#r1(dist(stack, hrv-intake)) / #r1(dist((1.5, 9.8), hrv-intake)) m) and the malqaf; a bird cage; no AAV in place of the main vents]),
  ([the WCs' and basins' traps], [every fixture its own trap, 50 mm seal minimum (basins 75 mm bottle traps); no S-trap siphoning: the branches ventilated (the stacks' vents, a secondary vent or an AAV where a branch exceeds the unvented length)]),
  ([the showers' and the floors' drains], [the shower channel is the only floor drain in each bathroom (no separate floor gully to dry out); the channels' traps with a membrane valve; the rarely used floor drains (the utility room, the laundry, the shaft, the tower sump, the courtyard's step drain) get *anti-odour membrane traps* and a *trap primer* or a listed monthly fill]),
  ([the tub's trap], [a 50 mm seal in the plinth, used weekly; with the AAV it cannot siphon; the plinth panel vents to the room (no closed cavity)]),
  ([the cleanouts and the rodding eyes (the stacks, the buried runs' bends)], [sealed screw caps with gaskets, inside the shaft / behind the cladding; none in a habitable room]),
  ([the inspection chambers (the yard, the driveway, the north strip)], [sealed double-seal covers (recessed, gasketed) with the invert benched; the collector chamber by the gate the same; no open gully into the foul system outside]),
  ([the septic tank (outside the wall near C1)], [its vent ≥ 2 m high on the wall's outer side, away from the gate (#r1(dist((septic.at(2), septic.at(1)), (0, 0))) m) and the north parking bay; its lid sealed; de-sludged on a schedule; no vent at the gate post]),
  ([the kitchen's sink and the dishwasher], [a deep trap (75 mm) with the dishwasher's hose above the seal; the grease kept out (a small grease trap under the sink is optional: the engineer); the hospitality kitchen the same]),
  ([the laundry's washer standpipe], [a trapped standpipe ≥ 0.6 m high, the hose not sealed into it (an air gap)]),
  ([the maid bath and the guest WC (less used)], [their traps still used weekly; the guest WC's floor is the shower-free type: no floor drain at all]),
  ([the courtyard, the suite court (rain)], [on the separate rain system, never connected to the foul one: no sewer gas can reach their drains; their gullies with leaf baskets]),
  ([the condensate (AC, HRV), the tower sump, the drip trays], [as the table on the round-2 corrections page: air gaps over tundishes or trapped air-breaks, never a direct joint to a drain or a vent]),
  ([the pipes themselves], [acoustic (triple-layer) soil pipes with push-fit sealed joints, pressure-tested before closing; the stacks never cut by a floor's finish: a sleeve and a fire collar at each slab]),
)
#let checks2 = (
  ([option a: every drain fits the sunken zone's pipe height (#r2(zone) m from the protection screed +#r2(pipe-floor) to the screed's underside +#r2(pipe-top)); the deepest bottom at the stack #r2(calc.min(..a-rows.map(r => r.at(2))))], a-rows.all(r => r.at(3))),
  ([option b: every pipe in the service wall, the duct or the plinth stays above the depressed slab (+#r2(sunk-top)) and the tub's branch reaches the stack at about the floor level, inside the cavity (+#r2(bot-b(tub)), the tray at +#r2(sunk-top))], fx.all(f => bot-b(f) >= sunk-top) and bot-b(tub) >= ffl - 0.10),
  ([no drain south of the hood zone's start (y #r1(hood-y)) at the east wall: the tub's outlet at y #r1(tub.out.at(1))], fx.all(f => f.a.route.all(p => p.at(1) < hood-y) and f.b.route.all(p => p.at(1) < hood-y))),
  ([the east stack's vent #r1(vent-top - win-head) m above the bath window's head and #r1(dist(stack, hrv-intake)) m from the HRV intake], vent-top - win-head >= 0.9 and dist(stack, hrv-intake) >= 3.0),
  ([the tub's branch #r2(tub-branch) m ≤ 4 m (BS EN 12056 unvented 50 mm limit) but > 1.07 m (the UPC trap-arm limit): an AAV in the plinth specified], tub-branch <= 4.0 and tub-branch > 1.07),
  ([the internal east duct (A3 option b) would overlap the kitchen's service door (y 7.2–8.1): reported], duct-hits-door),
  ([the rain points never drain to a foul collector; the condensate list gives every device a method], pts.filter(p => p.use.starts-with("rain")).all(p => p.to == "RAIN") and condensate.len() == 5),
)
#let all-ok2 = checks2.all(c => c.at(1))

// ---------- drawings ----------
#let bath-plan(opt, length: 2.0cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, body, size: 3.4pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, body))
  let R(b, fill: none, stroke: none) = rect(q((b.at(0), b.at(1))), q((b.at(2), b.at(3))), fill: fill, stroke: stroke)
  R((10.3, 6.5, 13.311, 10.45), fill: rgb("#e6f0f5"))
  R((10.175, 6.375, 13.436, 10.575), fill: none, stroke: 1.2pt + ink)
  line(q((12.211, 6.5)), q((12.211, 8.0)), q((13.311, 8.0)), stroke: 0.8pt + ink)
  line(q((12.211, 6.8)), q((12.211, 7.8)), stroke: 2pt + red); T((12.15, 7.3), [sliding], size: 2.4pt, fill: red, angle: 90deg)
  line(q((10.3, 6.65)), q((10.3, 7.65)), stroke: 2pt + red); T((10.45, 7.15), [door], size: 2.4pt, fill: red, angle: 90deg)
  line(q(win.at(0)), q(win.at(1)), stroke: 2.4pt + blue); T((13.5, 9.78), [window sill +1.5], size: 2.4pt, fill: blue, anchor: "west")
  R((12.5, 10.2, 13.311, 10.45), fill: red.transparentize(55%)); T((12.9, 10.33), [hood zone below (y ≥ 10.2)], size: 2.2pt, fill: red)
  if opt == "b" { R((sw-x, 6.5, wall-in, 9.5), fill: rgb("#d9d1c0"), stroke: 0.5pt + ink); T((13.086, 8.0), [service wall 0.20], size: 2.4pt, angle: 90deg); R((sw-x, 9.5, wall-in, 10.45), fill: rgb("#e8e2d4"), stroke: (paint: ink, thickness: 0.4pt, dash: "dashed")); T((13.086, 9.98), [duct 0.45 h], size: 2.2pt, angle: 90deg); R((11.386, 9.5, 13.186, 10.45), fill: none, stroke: (paint: amber, thickness: 0.6pt, dash: "dashed")); T((11.3, 9.9), [plinth 0.12\ removable front], size: 2.3pt, fill: amber, anchor: "east") }
  for f in fx { R(f.box, fill: white, stroke: 0.5pt + ink); T(((f.box.at(0) + f.box.at(2)) / 2, (f.box.at(1) + f.box.at(3)) / 2), f.id, size: 3pt) }
  for f in fx { let P = if opt == "a" { f.a.route } else { f.b.route }; line(..P.map(q), stroke: (paint: if opt == "a" { red } else { green }, thickness: 1.2pt), mark: (end: ">", fill: if opt == "a" { red } else { green }, scale: 0.4)); circle(q(f.out), radius: 0.06, fill: ink, stroke: none) }
  circle(q((13.52, 7.05)), radius: 0.09, fill: rgb("#8a5a2b"), stroke: none); T((13.65, 7.05), [stack Ø 110\ + vent], size: 2.4pt, fill: rgb("#8a5a2b"), anchor: "west")
  R((13.436, 6.6, 13.62, 7.5), fill: none, stroke: (paint: rgb("#8a5a2b"), thickness: 0.5pt, dash: "dotted")); T((13.65, 7.55), [removable cladding], size: 2.2pt, fill: rgb("#8a5a2b"), anchor: "west")
  line(q((11.0, 10.45)), q((11.0, 6.5)), stroke: none)
  T((11.8, 6.25), [N ↑ · suite bath + WC closet · option #opt · 1 m = #length], size: 3pt, fill: accent)
  T((10.1, 10.7), [kitchen below: the slab soffit +#r2(soffit), the ceiling +#r2(k-ceil), nothing but the lights], size: 2.5pt, fill: gray, anchor: "west")
})
// section 1: along the east wall (N–S), x ≈ 13.1, looking east: y 6.5 → 10.45; the levels from the kitchen ceiling to the window head
#let sec-ns(opt, length: 2.0cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, body, size: 3.2pt, fill: ink, anchor: "center", angle: 0deg) = content((p.at(0), p.at(1)), anchor: anchor, angle: angle, text(size, fill: fill, body))
  let y0 = 6.5; let y1 = 10.45
  let sx(y) = y - y0                      // horizontal: y (south) to the right
  let z(l) = (l - 2.75) * 1.0             // vertical: 1 m = length (the window +2.75 … +4.3)
  let band(l0, l1, fill, label) = { rect((sx(y0), z(l0)), (sx(y1), z(l1)), fill: fill, stroke: 0.3pt + luma(140)); T((sx(y1) + 0.05, (z(l0) + z(l1)) / 2), label, size: 2.4pt, anchor: "west") }
  band(soffit - 0.05, soffit, luma(120), [slab soffit +#r2(soffit)])
  band(soffit, sunk-top, rgb("#cfc6b4"), [ribbed slab 0.30, depressed 0.15 → top +#r2(sunk-top)])
  band(sunk-top, pipe-floor, rgb("#7a9ab0"), [tanking + protection +#r2(pipe-floor)])
  band(pipe-floor, pipe-top, rgb("#efe7d2"), [pipe zone / fill #r2(zone)])
  band(pipe-top, ffl - tile, rgb("#ded8c8"), [screed + 2nd membrane])
  band(ffl - tile, ffl, luma(80), [tiles · FFL +#r2(ffl)])
  line((sx(y0), z(k-ceil)), (sx(y1), z(k-ceil)), stroke: (paint: gray, thickness: 0.6pt, dash: "dashed")); T((sx(y1) + 0.05, z(k-ceil)), [kitchen ceiling +#r2(k-ceil)], size: 2.4pt, anchor: "west")
  // the window and the hood zone
  line((sx(9.5), z(ffl + 0.62)), (sx(10.05), z(ffl + 0.62)), stroke: 1.6pt + blue); T((sx(9.78), z(ffl + 0.55)), [window above (sill +1.5)], size: 2.2pt, fill: blue)
  rect((sx(10.2), z(k-ceil - 0.05)), (sx(y1), z(soffit)), fill: red.transparentize(50%), stroke: none); T((sx(10.32), z(k-ceil - 0.12)), [hood zone], size: 2.2pt, fill: red)
  // the stack outside at y 7.05 (shown as a vertical line) and the branches
  line((sx(7.05), z(k-ceil - 0.1)), (sx(7.05), z(ffl + 0.62)), stroke: 1.6pt + rgb("#8a5a2b")); T((sx(7.05), z(ffl + 0.68)), [stack (outside the wall) → vent +#r2(vent-top)], size: 2.4pt, fill: rgb("#8a5a2b"))
  for f in fx {
    let (lv-fix, lv-stack, col) = if opt == "a" { (top-a(f) - f.od / 2, bot-a(f) + f.od / 2, red) } else { (f.b.lvl - f.od / 2, bot-b(f) + f.od / 2, green) }
    let yf = f.out.at(1); let ys = 7.05
    if f.id == "VAN" { yf = 6.6 }
    line((sx(yf), z(lv-fix)), (sx(ys), z(lv-stack)), stroke: (paint: col, thickness: f.od * 20pt))
    T((sx(yf) + (if yf > ys { 0.05 } else { -0.05 }), z(lv-fix) + 0.07), [#f.id Ø #str(calc.round(f.od * 1000)) · +#r2(lv-fix - f.od / 2) → +#r2(lv-stack - f.od / 2)], size: 2.2pt, fill: col, anchor: if yf > ys { "west" } else { "east" })
  }
  if opt == "b" { rect((sx(y0), z(sunk-top)), (sx(9.5), z(ffl + 0.62)), fill: rgb("#d9d1c0").transparentize(60%), stroke: (paint: ink, thickness: 0.4pt, dash: "dashed")); T((sx(8.3), z(ffl + 0.5)), [service wall cavity, down to the tray (front panels)], size: 2.2pt); rect((sx(9.5), z(ffl)), (sx(y1), z(ffl + 0.45)), fill: rgb("#e8e2d4"), stroke: (paint: ink, thickness: 0.4pt, dash: "dashed")); T((sx(9.98), z(ffl + 0.38)), [duct], size: 2.2pt); rect((sx(9.6), z(ffl)), (sx(10.35), z(ffl + 0.12)), fill: amber.transparentize(40%), stroke: none); T((sx(9.98), z(ffl + 0.2)), [plinth], size: 2.0pt, fill: amber) }
  for yy in (y0, 7.05, 8.1, 9.5, y1) { line((sx(yy), z(k-ceil - 0.15)), (sx(yy), z(k-ceil - 0.1)), stroke: 0.4pt + ink); T((sx(yy), z(k-ceil - 0.22)), [y #r2(yy)], size: 2.2pt) }
  T((sx(8.5), z(ffl + 0.8)), [SECTION 1 · N–S along the east wall, looking east · option #opt · 1 m = #length · the window above (+5.1 … +5.7) and the vent (+#r2(vent-top)) are beyond the frame], size: 3pt, fill: accent)
})
// section 2: E–W through the shower (y ≈ 8.8), looking south: x 10.3 → 13.6 (the stack outside)
#let sec-ew(opt, length: 2.0cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, body, size: 3.2pt, fill: ink, anchor: "center", angle: 0deg) = content((p.at(0), p.at(1)), anchor: anchor, angle: angle, text(size, fill: fill, body))
  let x0 = 10.3; let x1 = 13.7
  let sx(x) = x - x0
  let z(l) = (l - 2.75) * 1.0
  let ztop = ffl + 0.62
  let band(l0, l1, fill) = rect((sx(x0), z(l0)), (sx(13.311), z(l1)), fill: fill, stroke: 0.3pt + luma(140))
  band(soffit - 0.05, soffit, luma(120)); band(soffit, sunk-top, rgb("#cfc6b4")); band(sunk-top, pipe-floor, rgb("#7a9ab0")); band(pipe-floor, pipe-top, rgb("#efe7d2")); band(pipe-top, ffl - tile, rgb("#ded8c8")); band(ffl - tile, ffl, luma(80))
  rect((sx(13.186), z(k-ceil - 0.1)), (sx(13.436), z(ztop)), fill: luma(100), stroke: none); T((sx(13.31), z(ffl + 0.3)), [east wall 0.25], size: 2.2pt, fill: white, angle: 90deg)
  rect((sx(13.436), z(k-ceil - 0.1)), (sx(13.6), z(ztop)), fill: rgb("#8a5a2b").transparentize(70%), stroke: (paint: rgb("#8a5a2b"), thickness: 0.4pt, dash: "dotted")); T((sx(13.52), z(ffl + 0.3)), [stack + cladding], size: 2.1pt, fill: rgb("#8a5a2b"), angle: 90deg)
  rect((sx(10.175), z(k-ceil - 0.1)), (sx(10.3), z(ztop)), fill: luma(160), stroke: none)
  line((sx(x0), z(k-ceil)), (sx(13.186), z(k-ceil)), stroke: (paint: gray, thickness: 0.6pt, dash: "dashed")); T((sx(11.7), z(k-ceil + 0.07)), [kitchen ceiling +#r2(k-ceil) · nothing but the lights · the slab soffit +#r2(soffit)], size: 2.3pt, fill: gray)
  // the vanity (west) and the shower (east)
  rect((sx(10.4), z(ffl + 0.55)), (sx(10.95), z(ffl + 0.62)), fill: white, stroke: 0.5pt + ink); T((sx(10.68), z(ffl + 0.5)), [vanity (its trap above, out of frame)], size: 2.1pt)
  rect((sx(12.086), z(ffl)), (sx(13.186), z(ffl + 0.02)), fill: luma(60), stroke: none); T((sx(12.6), z(ffl + 0.12)), [shower floor, 2 % to the channel], size: 2.3pt)
  if opt == "a" {
    // the vanity's Ø 40 drops into the floor and runs east in the fill; the shower gully in the fill
    let v = fx.find(f => f.id == "VAN"); let s = fx.find(f => f.id == "SH")
    line((sx(10.9), z(ffl + 0.55)), (sx(10.9), z(ffl - v.a.body - v.od / 2)), (sx(13.186), z(bot-a(v) + v.od / 2)), stroke: (paint: red, thickness: 0.8pt))
    T((sx(11.9), z(ffl - 0.02)), [VAN Ø 40 in the fill, 3 m, 2 % · bottom at the stack +#r2(bot-a(v))], size: 2.2pt, fill: red)
    rect((sx(12.95), z(ffl - s.a.body)), (sx(13.15), z(ffl)), fill: red.transparentize(40%), stroke: none); T((sx(12.6), z(ffl - 0.2)), [SH gully 0.09 in the fill\ → the stack +#r2(bot-a(s))], size: 2.2pt, fill: red)
  } else {
    rect((sx(sw-x), z(ffl)), (sx(wall-in), z(ztop)), fill: rgb("#d9d1c0"), stroke: 0.5pt + ink); T((sx(13.086), z(ffl + 0.3)), [service wall 0.20], size: 2.1pt, angle: 90deg)
    rect((sx(sw-x), z(sunk-top)), (sx(wall-in), z(ffl)), fill: rgb("#d9d1c0").transparentize(40%), stroke: (paint: ink, thickness: 0.4pt, dash: "dashed")); T((sx(13.086), z(ffl - 0.11)), [cavity down to the slab], size: 2.0pt, angle: 90deg)
    let v = fx.find(f => f.id == "VAN"); let s = fx.find(f => f.id == "SH")
    line((sx(10.9), z(ffl + 0.55)), (sx(10.9), z(v.b.lvl)), stroke: (paint: green, thickness: 0.8pt)); T((sx(10.35), z(ffl + 0.38)), [VAN Ø 40 → the north wall's chase at +0.45, jointless → the service wall], size: 2.2pt, fill: green, anchor: "west")
    rect((sx(12.9), z(ffl - 0.1)), (sx(sw-x), z(ffl)), fill: green.transparentize(30%), stroke: none); rect((sx(sw-x + 0.02), z(ffl - 0.12)), (sx(wall-in - 0.02), z(ffl + 0.05)), fill: green.transparentize(50%), stroke: 0.4pt + green)
    T((sx(12.4), z(ffl - 0.22)), [SH channel body in the screed; its TRAP in the wall cavity → the stack +#r2(bot-b(s))], size: 2.2pt, fill: green)
    rect((sx(sw-x), z(ffl + 0.3)), (sx(wall-in), z(ffl + 0.6)), fill: none, stroke: (paint: green, thickness: 0.5pt, dash: "dotted")); T((sx(12.95), z(ffl + 0.5)), [front panel 0.6 × 1.0 above the channel\ (continues up, out of frame)], size: 2.1pt, fill: green, anchor: "east")
  }
  for xx in (x0, 12.086, 13.186, 13.311) { line((sx(xx), z(k-ceil - 0.15)), (sx(xx), z(k-ceil - 0.1)), stroke: 0.4pt + ink); T((sx(xx), z(k-ceil - 0.22)), [x #r2(xx)], size: 2.2pt) }
  T((sx(11.8), z(ffl + 0.8)), [SECTION 2 · E–W through the shower (y 8.8), looking south · option #opt · 1 m = #length], size: 3pt, fill: accent)
})

// ====================================================================================== PAGE 6 · round 2: the baseline and A2 (corrections)
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[Round 2 (3 Nov 2026) · the owner's provisional baseline · corrections: rain and sewage fully separate; condensate and the tower sump]
#v(2pt)
#grid(columns: (1fr, 1fr), gutter: 12pt,
  [
    #set text(6.4pt)
    #H[The baseline for round 2 (owner, provisional)]
    - *Scenario B* is the direction: ~~the ground-floor shower P1~~ (withdrawn 3 Nov 2026: no ground-floor shower; the family WC and basins are one *powder room* on the same buried run) and the *suite court's outlets down the gym's and the office's walls*; the cleanouts, the two vent stacks, the anti-odour drains, the manifold system, two heaters, the leak protection as round 1.
    - *The suite bathtub STAYS* on the south wall by the east window (round 1's "tub to the north wall" is dropped). The vanity's move "beside the stack" of round 1 clashed with the shower once the tub stays: *the vanity stays on the west wall*; how its 3 m drain is handled is the subject of A1 (page 7–9).
    - Nothing is applied: the room CSVs and the design files are unchanged; every size assumed, to be designed by the plumbing engineer.
    #v(2pt)
    #H[A2 · Rainwater and sewage fully separate (corrected)]
    - *Corrected:* round 1 and the site plan let the *courtyard's drain and overflow* reach the east manhole's "rain branch" beside the foul branches, and the site plan's manholes carried rain and foul to one collector. Now: the east yard chamber is *foul only*; the courtyard's outlet (x 13.311, y 12.1) runs to its *own rain chamber* in the strip (#r1(dist(S((13.311, 12.1)), (15.7, 15.9))) m) and the east soakaway; the *suite court's* three linear drains and box gutter leave down the *gym's and the office's walls* to the garden's south soakaway; the *roof's 11 outlets* discharge at the plinth to the driveway's channel and the two soakaways; the *site* surface water falls to the soakaways and the channel. *Nothing of the rain enters the septic*, and no foul pipe is tied to a rain pipe anywhere (the round-1 inventory: every "rain" point to RAIN, checked).
    - *The final discharge* (the engineer, with the soil report): soakaways ≥ 5 m from the house's foundations and ≥ 10 m from the well (assumed rules), sized for Taif's storms; each with a *safe surface overflow* towards the lane side / the driveway's channel to the street, never towards the house; the garden's soakaway doubles as the palms' watering sump if the owner wishes.
    - *The site plan is corrected the same way* (`studies/site_plan.typ` page 4: the rain chamber, the foul chambers, the septic now north-west near C1 and the inverts computed).
  ],
  [
    #set text(6.3pt)
    #H[A2 · Condensate and the tower sump: the connection decided for each device]
    #table(columns: (1fr, 1.6fr, 1.1fr, 1fr), inset: 1.8pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      ..([Device], [Connection (never direct into a drain or a vent)], [The trap kept wet], [Cleaning]).map(c => text(6pt, weight: "bold", fill: accent, c)),
      ..condensate.map(r => r.map(c => text(5.6pt, c))).flatten())
    #v(2pt)
    #text(6pt, fill: gray)[*The detail (A2):* a *tundish* is an open funnel with a visible air gap of ≥ 2 × the pipe's bore (≥ 50 mm) between the condensate pipe's end and the funnel's rim, draining to a trapped fixture: a blocked drain shows as a drip at the tundish, and no sewer gas can climb the condensate pipe. A *trapped air-break* is a gully whose water seal (50 mm) separates the device from the drain, with a *membrane (ball or flap) valve* that closes when the seal dries, and a *trap primer* (a small bleed from a cold tap through a vacuum breaker) or a listed monthly fill. Every size assumed, the plumbing engineer designs.]
    #v(3pt)
    #H[A2 · The site drainage corrected (summary of the site plan, page 4)]
    - *The septic* is *outside the farm wall near corner C1* (north-west, the north street), approximate; the foul drains of both clusters run *north and west*: the east main from the yard's foul chamber round the cut wall, along the north strip's north edge to the *collector chamber inside the gate*; the west branch from the driveway's west chamber (the west run now falls *north* inside the house); then under the wall west of the gate's post to the septic.
    - *Falls (assumed):* the main at 1 %, the branches 1.5 %, 0.03 m through each chamber → the septic's inlet at #r2(inv-septic) below the house floor, ≈ #r2(ground-gate - inv-septic) m below the ground at the gate: *the septic's inlet level must be surveyed*; if it is higher, a packaged pump station at the collector chamber (flagged).
    - *The tanks:* the existing one SOUTH of the old house, west of the driveway near peg R (owner, 5 Nov 2026), the reserved future tank beside it (west), the supply pipe across the driveway, ≥ #r1(sep-rule.tank-house) m from the house (#r1(pbox-dist(tank-old, S((0, 24)))) m); the water pipe ≥ #r1(sep-rule.drain-pipe) m from the foul drains on the driveway; the septic ≥ #r1(sep-rule.septic-tank) m from the tanks and ≥ #r1(sep-rule.septic-well) m from the well (rules assumed, to confirm by the engineer).
  ],
)

// ====================================================================================== PAGE 7 · A1 the suite bath: the enlarged plans (a / b)
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[A1 · The suite bathroom over the kitchen · enlarged plans: (a) every drain in the sunken tanked slab (current) · (b) the east service wall + the tub's plinth]
#v(2pt)
#grid(columns: (auto, auto, 1fr), gutter: 8pt,
  bath-plan("a"), bath-plan("b"),
  [
    #set text(6.2pt)
    #H[The room and the stack]
    - The bath x 10.3–13.311, y 6.5–10.45 (3.01 × 3.95 on axes) with the WC closet in its north-east part (12.211–13.311 × 6.5–8.0, sliding door); the *stack outside the east wall* at y 7.05 behind a removable cladding panel, its branch fittings at the first-floor level, its vent to the roof; the *east window* y 9.5–10.05 (sill +1.5); the *hood zone* of the kitchen below starts at y 10.2 on the east wall: the depressed slab reaches y 10.45 but *no drain runs south of y 10.15* (the tub's outlet at y #r1(tub.out.at(1)); checked).
    - *Fixtures* (`studies/ff_suite.typ`): the WC in the closet on the east wall (its outlet #r2(dist((13.0, 7.17), (13.186, 7.1))) m from the wall), the walk-in shower on the east wall y 8.1–9.5, the freestanding tub on the south wall by the window (its waste at x 12.3), the double vanity on the west wall (its trap #r1(runlen(fx.find(f => f.id == "VAN").a.route)) m from the stack by the floor route).
    #H[(a) all in the sunken tanked slab (current, red)]
    - The ribbed slab's top is depressed 0.15 over the whole bath (+#r2(sunk-top)); the build-up from it: the tanking membrane and its protection screed (+#r2(pipe-floor)), the *pipe zone #r2(zone) m*, a lightweight fill, the 50 mm screed, the second membrane under the tiles, the tiles (+#r2(ffl)). The four drains lie in the fill at 2 % to the east wall and pass through it into the stack's branches: all four fit (page 8), the WC's Ø 110 with #r2(bot-a(fx.at(0)) - pipe-floor) m and the tub's flat trap on its diagonal with #r2(bot-a(tub) - pipe-floor) m to spare at the stack: tight.
    - *Buried:* the WC's bend, the shower's gully and its outlet, the tub's trap and its 3.1 m outlet, the vanity's 3 m outlet and every joint of them. Reached only by lifting tiles, screed and the second membrane; the tanking under them stays.
    #H[(b) the east service wall + the tub's plinth (green)]
    - A *0.20 m service wall* inside the east wall from the closet to the shower's end (y 6.5–9.5, full height, its cavity down to the depressed slab), continued as a *0.45 m high duct* under the window to the south wall; the *WC wall-hung* on the wall's frame with its outlet *horizontal at +0.18 straight through the wall into the stack* (0 m of floor pipe); the *shower channel along the service wall with its trap body inside the wall cavity*; the *tub on a 0.12 m plinth with a removable front* (its trap in the plinth's void above the floor; the pipe in the plinth, the duct and the wall to the stack, #r2(tub-branch) m at 2 %, arriving at +#r2(bot-b(tub)), at about the floor level inside the wall cavity, #r2(bot-b(tub) - sunk-top) m above the tray); the *vanity's Ø 40 in a chase in the north wall at +0.45* (one jointless pipe from its bottle trap) into the service wall. *What still lies in the floor:* the shower channel's body only (set in the screed at the wall, its trap in the wall). Note: the door on the west wall (y 6.65–7.65) is not touched; the chase runs behind the plaster above the skirting.
    #H[(c) a raised floor with removable panels]
    - A floor on pedestals over the tanked slab with lift-out tiles is practical only where no water falls on it: it cannot be sealed and removable at once in the shower. It works for the *tub's zone* (= the plinth of (b)) and for a *dry strip along the west wall* under the vanity (0.6 wide, lift-out stone slabs over the vanity's pipe): used in (b) as the plinth; the west strip is an option if the owner prefers the vanity's pipe in the floor to a wall chase.
  ],
)

// ====================================================================================== PAGE 8 · A1 the sections
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[A1 · Dimensioned sections · the levels available in the floor build-up and the sunken slab against every drain · the kitchen ceiling below]
#v(2pt)
#grid(columns: (1fr, 1fr), gutter: 8pt, sec-ns("a"), sec-ns("b"))
#v(2pt)
#grid(columns: (1fr, 1fr), gutter: 8pt, sec-ew("a"), sec-ew("b"))
#v(3pt)
#grid(columns: (1.1fr, 1fr), gutter: 10pt,
  [
    #set text(6.2pt)
    #table(columns: (auto, 1fr, auto, auto, auto, auto, auto, auto, auto), inset: 1.6pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      ..([Drain], [Trap], [OD], [run m], [bends], [(a) crown at the fixture], [(a) bottom at the stack], [(a) fits], [(b) bottom at the stack]).map(c => text(5.8pt, weight: "bold", fill: accent, c)),
      ..fx.map(f => (text(5.5pt)[#f.id], text(5.5pt)[#f.trap], text(5.5pt)[Ø #str(calc.round(f.od * 1000))], text(5.5pt)[#r2(runlen(f.a.route)) / #r2(runlen(f.b.route))], text(5.5pt)[#(f.a.route.len() - 2) / #(f.b.route.len() - 2)], text(5.5pt)[+#r2(top-a(f))], text(5.5pt)[+#r2(bot-a(f))], text(5.5pt, fill: if fits-a(f) { green } else { red }, weight: "bold")[#if fits-a(f) [yes, #r2(bot-a(f) - pipe-floor) spare] else [NO]], text(5.5pt)[+#r2(bot-b(f)) (above +#r2(sunk-top))])).flatten())
    #text(5.6pt, fill: gray)[Levels above the ground floor ±0.00; "bottom" = the pipe's outside bottom at the stack after the fall of 2 % (1:50) over the run; the joints: at the trap, at each bend and at the stack's branch fitting. The build-up: finish 0.08 (params.yaml), the depression 0.15 (structure.typ), tanking 3 mm + protection 20 mm, screed 50 mm, membrane 2 mm, tiles 14 mm: ASSUMED. The waterproofing: (1) a liquid tanking on the depressed slab turned 0.15 up the walls (the tray, the second line against leaks), (2) a bonded membrane under the tiles turned up the walls (the first line); in (b) the service wall stands on the tray inside the tanking, its cavity drained to the stack's branch through a weep (a leak in the cavity shows at the tray's tell-tale).]
  ],
  [
    #set text(6.3pt)
    #H[What the sections show]
    - *(a):* the pipe zone is #r2(zone) m; the WC's Ø 110 (an S-trap pan, its bend 0.07 under the tiles) fits with #r2(bot-a(fx.at(0)) - pipe-floor) m to spare over its 0.19 m run; the shower gully (0.09 body) and the vanity (0.07 bend) fit with #r2(bot-a(fx.at(1)) - pipe-floor) and #r2(bot-a(fx.at(3)) - pipe-floor) m to spare; *the tub fits only with a flat 0.08 trap on the straight diagonal under the shower* (#r2(bot-a(tub) - pipe-floor) m to spare): at the limit of the build-up, with a 0.10 trap or a run along the walls it does not fit at 2 %. Nothing hangs under the slab: *the kitchen ceiling carries only the lights* (the soffit +#r2(soffit) under the depressed zone, the gypsum at +#r2(k-ceil)): also in (a). But every drain and joint is under 0.07 m of screed, membrane and tile.
    - *(b):* no pipe below the tiles except the channel's body (0.10 deep in the screed, at the wall); the WC's outlet at +0.18, the channel's trap at +#r2(ffl - 0.09) in the cavity, the tub's pipe from +#r2(ffl + 0.02) to +#r2(bot-b(tub)), the vanity's chase from +0.45 to +#r2(bot-b(fx.find(f => f.id == "VAN"))): all above the tray, reached from the room side.
    - *The kitchen ceiling under the bath:* in both options *nothing but the structure* (the ribbed slab, its depressed zone), the ceiling's lights and the HRV ducts of the kitchen itself (which run south of the hood zone). *No drain under the hood zone* (y ≥ 10.2): checked.
    - *The tub by the window (proved):* its trap sits in the plinth at +#r2(ffl + 0.02) … +#r2(ffl + 0.12); the pipe falls 2 % over #r2(tub-branch) m to +#r2(bot-b(tub)) at the stack: about the finished floor's level, inside the service wall's cavity and #r2(bot-b(tub) - sunk-top) m above the tray; *no part of it is in the floor's screed or fill*. *Access:* the plinth's front panel (clip-on stone, 1.7 × 0.12) for the trap's cleaning and replacement; the pop-up waste from inside the tub. *Ventilation:* the branch is #r2(tub-branch) m: within BS EN 12056-2's unvented 50 mm limit (4 m) but beyond the UPC's trap-arm limit, so an *air admittance valve in the plinth* (accessible, above the trap's weir) or a secondary vent up the service wall to the stack's vent: the engineer's code decides; with the AAV the trap cannot siphon.
  ],
)

// ====================================================================================== PAGE 9 · A1 the comparison and the access of every drain
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[A1 · Comparison (a) sunken slab · (b) service wall + plinth · (c) raised floor · the access of EVERY drain and joint · the recommendation]
#v(2pt)
#grid(columns: (1fr, 1fr), gutter: 10pt,
  [
    #set text(6.2pt)
    #table(columns: (1fr, 1.1fr, 1.3fr, 1fr), inset: 1.8pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      ..([Criterion], [(a) sunken slab, all buried], [(b) service wall + tub plinth], [(c) raised floor]).map(c => text(6pt, weight: "bold", fill: accent, c)),
      [Maintenance access], [none without lifting tiles, screed and the second membrane (the tanking stays); blockages rodded from the fixtures and the stack's eye], [the WC, the tub, the vanity's trap and all joints at the stack reachable without cutting anything; the channel's insert from the front; its body = the one local opening], [the panels lift where dry; in the shower the sealing defeats it],
      [Leak containment], [the tanked tray holds the leak; it shows at the tray's tell-tale (late)], [the same tray as the second line; the cavity and the plinth are dry voids with sensors (early)], [the tray; the void is inspectable],
      [Noise], [pipes in the fill: quiet], [the WC frame and the pipes in a cavity: lined with 25 mm mineral wool, the pipe acoustic; quiet], [a hollow floor drums: needs a damping fill],
      [Structure], [the depressed zone exists (X10); no change], [the same depressed zone; the service wall is light (steel frame + boards, ≈ 0.6 kN/m) on the slab; the bath loses 0.20 m in width (2.8 clear) and the closet 0.20 (0.9 clear: still a closet)], [the same slab; the floor's pedestals],
      [Relative cost], [1.0], [≈ 1.2 (the frame, the wall-drain channel, the plinth, the chase)], [≈ 1.3 and worse in the shower],
      [Function], [as designed], [a wall-hung WC and vanity (the owner's "high quality"); the tub on a plinth: a step of 0.12], [a step in the floor],
    )
    #v(3pt)
    #H[Recommendation: (b), with the honest limit]
    - *(b)*: the east service wall with the wall-hung WC, the wall-drain shower channel and the tub's plinth; the vanity's jointless chase. Every drain, trap and joint but one is reached from the room side or from the stack's cladding outside without cutting a finish; *the one exception is the shower channel's body* (its insert, strainer and seal come out from the front; the body itself, if it ever fails, needs a local opening ≈ 1.4 × 0.3 m of tiles and screed along the wall and the membrane re-made there, the tray below untouched). That is the smallest opening in the room and the best practical compromise: a channel body is a passive part with no moving element.
    - *Keep the depressed tanked slab* in (b) too: it holds the channel's depth and is the second line against any leak; the cavity's weep and a tell-tale show a leak before it spreads. The kitchen ceiling under the bath carries nothing.
    - *Also in (b):* the stack's four branch fittings and the rodding eye sit *outside, behind the cladding* (page 10): a blockage anywhere in the bath is cleared from the yard without entering the suite.
  ],
  [
    #set text(5.9pt)
    #H[Every drain and joint (option b): buried or accessible, and how it is reached]
    #table(columns: (auto, 1fr, 1fr, 1fr, auto), inset: 1.6pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      ..([Item], [(1) blockage], [(2) leak: shows first at · how reached], [(3) broken pipe: replace], [removed]).map(c => text(5.6pt, weight: "bold", fill: accent, c)),
      [WC pan + its seal], [through the pan; the stack's eye outside], [the pan's foot / the cavity sensor · the closet], [unbolt the pan (2 bolts), the outlet bend through the frame's opening], [nothing],
      [WC cistern + valve], [—], [the flush plate's opening], [through the flush plate (standard)], [the plate],
      [WC outlet bend → the wall → the stack], [the stack's rodding eye], [the cavity sensor; outside at the branch (cladding off)], [from the closet after the pan, and from outside], [the cladding panel],
      [shower channel: grating, strainer, trap insert], [lift the grating, pull the insert, rod the outlet], [—], [the insert is the wear part: swapped from the front], [nothing],
      [shower channel body (in the screed)], [as above], [the tray's tell-tale (the tanking holds it)], [*the one local opening*: ≈ 1.4 × 0.3 m of tiles + screed, the membrane re-made], [tiles + screed, locally],
      [shower outlet Ø 50 in the wall cavity → the stack], [the stack's eye; the channel's outlet], [the cavity sensor; the front panel 0.6 × 1.0 above the channel (dry zone, tiled panel on a frame)], [through the front panel], [the panel],
      [tub waste + pop-up], [from inside the tub], [the plinth void (sensor)], [from the plinth], [the plinth's front],
      [tub trap + AAV (in the plinth)], [the plinth's front panel], [the plinth void], [the plinth's front panel], [the front panel],
      [tub outlet Ø 50 in the plinth, the duct, the wall], [the stack's eye], [the duct's and the cavity's sensor; the duct's top is a lift-off stone shelf under the window], [the duct's lid, the wall's front panel], [the lid / a panel],
      [vanity bottle trap], [unscrew it (visible)], [visible], [visible], [nothing],
      [vanity Ø 40 in the north wall's chase], [rod from the trap], [the chase's foot at the wall's base above the floor; the cavity sensor], [open the chase: a 0.10 m plaster strip (dry wall zone, no waterproofing)], [plaster + tile strip],
      [the four joints at the stack + the rodding eye], [the eye], [outside at the cladding's foot (a drip)], [from outside, the panel off], [the cladding panel],
    )
    #text(5.4pt, fill: gray)[Sensors: a cable leak sensor in the service wall's cavity at the tray level, one in the plinth, one in the duct; the tray's tell-tale is a Ø 20 weep from the tanking's lowest corner through the wall into the stack's cladding zone (a drip there = a leak above). All wired to the house's automatic main shut-off valve.]
  ],
)

// ====================================================================================== PAGE 10 · A3 the east stack
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[A3 · The east stack: (a) the external stack on the east wall behind removable cladding vs (b) an internal accessible duct in the kitchen's north-east corner]
#v(2pt)
#grid(columns: (1.15fr, 1fr), gutter: 10pt,
  [
    #set text(6.2pt)
    #table(columns: (1fr, 1.4fr, 1.4fr), inset: 1.8pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      ..([Criterion], [(a) external stack behind removable cladding (current)], [(b) internal duct 0.35 × 0.35 in the kitchen's NE corner]).map(c => text(6pt, weight: "bold", fill: accent, c)),
      [Real access: where you stand, the panel, what you move], [in the *service yard*, on the ground: a 0.6 × 2.4 m cladding panel (honey-stone slats on a frame, 4 clips) off the wall; the FF branch fittings at +3.4 … +3.9 reached from a 2-step platform or a ladder in the yard; the bins (0.8 m north) rolled aside; nothing inside the house touched], [in the *kitchen*: a 0.6 × 2.1 m door in the corner; you stand in the kitchen's north-east corner, where the *service door (y 7.2–8.1) opens*: the duct's footprint (y 7.0–7.35) overlaps the door's jamb (#if duct-hits-door [reported]): the door must move 0.4 m south (and the bins and the gas pipe with it); the tall storage / fridge beside it moved; the FF panel in the WC closet's corner (0.5 × 1.2) behind the WC: the WC's frame limits it],
      [Noise], [outside the wall: nothing heard inside; the pipe acoustic and insulated anyway], [a soil stack in a kitchen wall: needs the acoustic pipe, a lined duct (mineral wool) and a heavy door; audible in the kitchen at night in the worst case],
      [Odour and fire], [the vent outside, up the wall to the roof; the branch joints outside: a leak or a smell stays outside; no fire separation needed], [the duct is a flue through the kitchen roof slab: a fire collar at the slab, the duct fire-rated (60 min) on the kitchen side (the hood zone is 3 m south); a smell from a joint enters the kitchen],
      [Weather and heat], [the pipe behind the cladding: shaded, ventilated; UV-stable pipe; the east face gets the morning sun only (the yard's screen shades the foot)], [none: inside],
      [The east facade], [the cladding panel is part of the east wall's service-yard face (the family's door, the bins, the screen): a 0.6 m stone-slat panel between the service door and the laundry's wall reads as a utility feature on the utility side; not on a show facade], [nothing outside; but the service door moves],
      [Structure], [none: the stack hangs on the wall; the branches pass through the wall in sleeves (three Ø 110 / 50 holes in the 0.25 wall; no column at y 7.05: the east wall's columns stand at y 6.0 and 10.45)], [a 0.35 × 0.35 opening through the ribbed kitchen roof slab at the corner, trimmed (the engineer); and the maid wing's solid slab is not involved],
      [Relative cost], [1.0 (the pipe, the cladding panel, the sleeves)], [≈ 1.5 (the duct, the slab opening and trimmer, the fire collar, the door moved, the kitchen corner rebuilt)],
      [What it helps], [the vertical stack AND its four branch connections (all outside)], [the vertical stack only: the branches still cross the service wall (page 9)],
    )
  ],
  [
    #set text(6.4pt)
    #H[Recommendation: (a) the external stack behind removable cladding]
    - Round 1 leaned to the internal duct; the enlarged study *reverses that*: at the kitchen's north-east corner the duct collides with the service door and brings a soil stack, a slab opening and a fire-rated flue into the kitchen for a gain that is only the vertical pipe. The external stack puts the vertical AND every branch connection of the suite bath *outside the house*, reachable from the yard with a ladder, and keeps the kitchen's ceiling and corner clean.
    - *Conditions for (a):* an acoustic, UV-stable Ø 110 pipe with a *rodding eye at the yard level and at +3.3* (under the branches); the four branch fittings at +3.4 … +3.9 behind one cladding panel 0.6 × 2.4 (clips, no tools); the cladding ventilated top and bottom; the vent carried 1.0 m above the roof (+#r2(vent-top)), #r1(vent-top - win-head) m above the bath window's head and #r1(dist(stack, hrv-intake)) m from the HRV intake; the sleeves through the wall sealed both sides (fire and water); the stack's foot into the yard's foul chamber with a bend and a cleanout. The pipe's run on the wall is *inside the service yard's screen*: unseen from the garden and the lane.
    - *The west cluster* keeps its stack inside the *shaft* (doors on both floors): the inside solution is right there because the shaft exists and is in a service room, not a kitchen.
    #v(3pt)
    #H[What a duct would need, if the owner still wants it]
    - The service door moved to y 7.6–8.5 (the bins and the gas pipe with it), the kitchen's corner unit shortened by 0.4 m, a trimmed 0.35 × 0.35 slab opening (X10's zone), a 60-minute duct with a fire collar, a 0.6 × 2.1 access door in the kitchen and a 0.5 × 1.2 panel in the closet; and the branches still cross the service wall. Cost ≈ 1.5 × (a). Not recommended.
  ],
)

// ====================================================================================== PAGE 11 · A4 smells
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[A4 · Every possible source of drain smell in the house and on the site, and how each is prevented (the owner's priority)]
#v(2pt)
#grid(columns: (1.45fr, 1fr), gutter: 10pt,
  [
    #set text(6.3pt)
    #table(columns: (1fr, 2.2fr), inset: 1.8pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      ..([Source], [Prevention (every item assumed, the plumbing engineer designs)]).map(c => text(6pt, weight: "bold", fill: accent, c)),
      ..smells.map(r => r.map(c => text(5.8pt, c))).flatten())
    #v(2pt)
    #text(6pt, fill: gray)[The rule behind the list: a smell needs an open path from the sewer to a room. The paths are a dry or siphoned trap, an unsealed cleanout or cover, a vent terminal near an opening or an intake, and a direct joint from a device to a drain. Each is closed above; the rarely used drains are the only ones that need care (a membrane valve and a primer or a listed fill), and the design keeps them few: no floor gully in any bathroom but the shower's channel.]
  ],
  [
    #set text(6.4pt)
    #H[Decided by the owner, 3 Nov 2026 (recorded in data/decisions.csv)]
    - *The east stack: EXTERNAL* on the east wall behind removable cladding (A3 option a; not the internal duct). *Rarely used drains: automatic trap primers* (the courtyard, the suite court, the utility room, the laundry, the shaft, the tower sump; no monthly duty). *Rain and sewage fully separate; condensate by tundishes / trapped air-breaks: adopted.* *The suite bathroom's approach (option b, the service wall): NOT decided, open for discussion.* *No ground-floor shower* (the family WC + basins become one powder room; P1 withdrawn). *First floor (3 Nov 2026):* the F-b bath split into bedroom 2's en-suite and a family WC on one service wall by the shaft (applied); bedroom 1's hotel-layout en-suite (B4) studied and not applied (`studies/bedroom1_bath.typ`).
    #v(3pt)
    #H[The list for the owner (round 2, as it stood)]
    + *A1:* the suite bath as *(b)* (service wall, wall-hung WC and vanity, wall-drain channel, the tub on a plinth with an AAV): accepted? The one local opening (the channel body) accepted as the compromise?
    + *A3:* the east stack *external behind removable cladding* (not the internal duct): accepted?
    + *A2:* the rain system separate with two soakaways and surface overflows; the condensate by tundishes and trapped air-breaks: noted.
    + *A0:* the septic's position near C1 (it serves the old house: its capacity for both houses) and the tanks south of the old house west of the driveway to be measured; the *septic's inlet level* decides whether a pump station is needed at the gate's collector chamber; the municipality's consent for the septic outside the wall.
    + The monthly maintenance list (the rarely used drains, the tower sump, the tundishes) accepted as a duty, or trap primers everywhere (more pipe, no duty)?
    #v(4pt)
    #text(8pt)[#if all-ok and all-ok2 [*Study checks passed* (#(checks.len() + checks2.len()): round 1 #checks.len(), round 2 #checks2.len())] else [*STUDY CHECKS FAILED:* #(checks + checks2).filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]]
    #v(2pt)
    #text(6pt, fill: gray)[Round 2 checks: #checks2.map(c => c.at(0)).join([ · ]). Every size is assumed, to be designed by the plumbing engineer; no estimate here (cost, length, depth) is proven; nothing in the room CSVs or the design files changes until the owner decides.]
  ],
)

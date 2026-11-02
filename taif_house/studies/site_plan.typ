// site_plan.typ · Taif / Palm House V8.1 (work) · SITE AND SERVICES PLAN (design review S-01 … S-08, E-04 … E-06; open item 20) · 2 Nov 2026.
// Drawn on the site base (base.typ: the plot, the M line, the gate, the palms); the old house, the old majlis, the well, the existing parking, the
// existing ground tank and the septic tank are NOT in the project files: they are drawn where the owner's brief places them, dotted, "assumed".
// EVERY SITE POSITION HERE IS PROPOSED, TO CONFIRM WITH THE OFFICIAL SURVEY AND THE ENGINEERS. No system is designed: positions, routes and rules only.
// Site frame (base.typ): origin = peg M1 = the main gate's east post; y along the M line southwards; x east. The house = the CSV frame + (0.91, 3.825).
#import "@preview/cetz:0.4.2"
#import "../base.typ": land, env, drv, lane, nwall, south, T1, T2, Ms, north, dist, seg-dist, edges, ray
#set page(paper: "a4", flipped: true, margin: 9mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 7.2pt)
#let ink = rgb("#3d4a45")
#let accent = rgb("#5a7d2a")
#let red = rgb("#b5452f")
#let blue = rgb("#2f5f8a")
#let green = rgb("#2f7a3f")
#let amber = rgb("#b58a1f")
#let stone = rgb("#c9a86a")
#let r1(v) = str(calc.round(v, digits: 1))
#let r2(v) = str(calc.round(v, digits: 2))
#let H(body) = text(9.5pt, weight: "bold", fill: accent, body)
#let OK = text(fill: green, weight: "bold")[OK]
#let NV = text(fill: amber, weight: "bold")[to confirm]
#let plen(P) = range(P.len() - 1).map(i => dist(P.at(i), P.at(i + 1))).sum()
#let box-dist(b, p) = { let dx = calc.max(b.at(0) - p.at(0), 0, p.at(0) - b.at(2)); let dy = calc.max(b.at(1) - p.at(1), 0, p.at(1) - b.at(3)); calc.sqrt(dx * dx + dy * dy) }
#let seg-box-dist(a, b, bx) = calc.min(..range(11).map(i => box-dist(bx, (a.at(0) + (b.at(0) - a.at(0)) * i / 10, a.at(1) + (b.at(1) - a.at(1)) * i / 10))))
#let inside(p, P) = ray(p, P)

// ---------- The house in the site frame ----------
#let shift = (0.91, 3.825)
#let S(p) = (p.at(0) + shift.at(0), p.at(1) + shift.at(1))
#let house = ((0, 0), (10.051, 0), (13.311, 6.0), (13.311, 24.0), (0, 24.0)).map(S)
#let court = ((5.8, 6.5), (8.95, 6.5), (8.95, 13.0), (5.8, 13.0)).map(S)
#let scourt = ((4.25, 20.55), (5.8, 20.55), (5.8, 19.25), (10.0, 19.25), (10.0, 24.0), (4.25, 24.0)).map(S)
#let d-family = (S((3.0, 0)), S((4.0, 0)))
#let d-guest = (S((0, 21.5)), S((0, 22.9)))
#let d-service = (S((13.311, 7.2)), S((13.311, 8.1)))
#let w-kitchen = (S((13.311, 8.7)), S((13.311, 10.1)))
#let hood-out = (S((13.311, 10.2)), S((13.311, 11.2)))
#let w-dining = (S((13.311, 14.5)), S((13.311, 17.5)))
#let east-face = 13.311 + 0.125 + shift.at(0)      // the east wall's outer face: 14.346
#let gate = ((-3.95, 0.73), (0, 0))                 // the existing 4 m main gate across the driveway's north end; M1 is its east post
#let gate-w = dist(..gate)
#let drv-w = 3.95

// ---------- 1 · Access, parking, paths (proposed) ----------
#let park-opt = (5.0, 0.9, 10.0, 3.4)               // one uncovered family car in the north setback strip (optional; municipality)
#let path-family = ((-1.0, 2.6), (d-family.at(0).at(0) + 0.5, 2.6), (d-family.at(0).at(0) + 0.5, 3.825))
#let path-guest = ((-1.0, 39.6), (-1.0, 26.0), (0.9, 26.0))            // from the farm parking (south) along the driveway's east band to the guest door
#let path-workers = ((-1.0, 1.5), (11.3, 1.5), (16.4, 10.2), (16.4, 17.0))   // from the gate along the north strip and the lane-side strip to the service yard, east of the screen
#let lamps = range(7).map(i => (-0.4, 27.0 + i * 2.0))               // bollard lights on the guest path
// ---------- 2 · The family garden (south) and its separation ----------
#let garden = ((0.9, 27.95), (14.35, 27.95), (14.35, 19.6), (22.5, 19.6), (26.74, 33.94), (0.9, 38.7))
#let lowwall = ((0.6, 27.95), (0.6, 38.7))                          // a 1.2 m honey-stone wall with planting between the garden and the guest path / driveway
#let hedge = ((14.35, 18.5), (22.2, 18.5))                           // a 1.8 m hedge between the service yard / workers' path and the garden
// ---------- 3 · The service yard (east) ----------
#let screen = (S((14.6, 6.5)), S((14.7, 13.0)))                      // the 1.8 m yard screen (design_gf.typ)
#let bins = (S((13.6, 6.2)), S((14.4, 7.0)))
#let gas = (S((14.85, 9.0)), S((15.35, 10.0)))                       // the ventilated LPG cabinet on the screen's EAST face (deliveries from the workers' path; the pipe through the screen base to the hob)
#let gas-box = (gas.at(0).at(0), gas.at(0).at(1), gas.at(1).at(0), gas.at(1).at(1))
#let counter = (S((13.45, 20.8)), S((14.05, 23.6)))
#let grill = (S((15.0, 27.4)), S((17.3, 28.9)))
#let manhole-e = S((14.3, 13.5))                                     // the east-yard manhole (kitchen, laundry, maid bath, the courtyard's rain branch): at the yard's south end
#let manhole-w = (-1.0, 28.5)                                         // the west run's manhole on the driveway
#let collector = (18.5, 33.5)                                         // the collector manhole at the garden's south-east, towards the septic
// ---------- 4 · Utilities (reserve positions) ----------
#let tank-old = (14.0, 44.0, 17.0, 47.0)                             // EXISTING ground tank, position assumed near the old house (the survey)
#let pipe-old = ((14.0, 45.5), (-3.3, 45.5), (-3.3, 12.9), (0.9, 12.9))   // its supply pipe to the utility room (assumed route along the driveway)
#let tank-new = (1.0, 0.3, 4.5, 2.8)                                 // RESERVE: a future underground tank 3.5 × 2.5 × 2.0 (≈ 17 m³), beside the family entrance path; the truck fills from the driveway
#let fill-pt = (-2.0, 1.5)
#let septic = (24.0, 42.0, 28.0, 45.0)                               // EXISTING septic tank, position assumed (the survey); capacity and condition for the engineer
#let well = (-7.0, 45.0)                                             // EXISTING well, position assumed (the survey): ≥ 30 m from the septic
#let sewer = ((manhole-e, (15.2, 28.5), collector), (manhole-w, (-1.0, 36.5), collector), (collector, (26.0, 42.0)))
#let pv-riser = S((0.75, 9.8))                                       // the west shaft: the PV conduits from the roof down to the utility room
#let inverter = S((2.0, 8.3))                                        // the inverter + battery cabinet on the utility room's north wall (beside the main panel)
#let rain-pts = ((S((5.0, -0.25)), [N]), ((-0.3, S((0, 12.0)).at(1)), [W]), ((-0.3, S((0, 17.5)).at(1)), [W]), (S((13.6, 12.5)), [E]), (S((11.9, 2.2)), [cut]), (S((2.0, 24.3)), [S]), (S((11.5, 24.3)), [S]))
#let soak-e = (16.5, 14.5); #let soak-s = (10.0, 31.0)
// ---------- 5 · Security ----------
#let cams = (
  ("C1", (-0.2, 0.3), [the gate (with the video intercom)], 225),
  ("C2", (0.8, 3.7), [the driveway, looking south], 180),
  ("C3", (4.4, 3.75), [the family entrance], 0),
  ("C4", (0.85, 25.0), [the guest entrance and the path], 225),
  ("C5", (14.3, 9.9), [the service yard, looking south], 180),
  ("C6", (8.0, 27.9), [the garden and the south facade], 180),
  ("C7", (14.3, 27.9), [the suite court's outside (the screen) and the east garden], 240),
)
#let intercom = (-0.3, 0.9)
#let panel = S((1.4, 9.0))                                           // the alarm panel in the utility room
#let keypads = (S((3.6, 0.3)), S((0.4, 22.2)))
// ---------- 6 · Civil Defense ----------
#let far-point = calc.max(..house.map(p => p.at(0)))                 // the east wall from the driveway's edge (x 0)
#let hose = far-point + 2.0                                           // the hose run from a vehicle on the driveway round the house to the east wall (worst case, approx.)
// ---------- 7 · Levels (assumed, to be set from the survey) ----------
#let lv = (floor: 0.0, ground: -0.30, fall: 0.02, fall-len: 2.0)

// ---------- checks of this study ----------
#let gas-rule = 1.5
#let checks = (
  ([the gas cabinet ≥ #r1(gas-rule) m from every opening of the house (service door #r2(seg-box-dist(..d-service, gas-box)), kitchen window #r2(seg-box-dist(..w-kitchen, gas-box)), hood outlet #r2(seg-box-dist(..hood-out, gas-box)), dining window #r2(seg-box-dist(..w-dining, gas-box)))], calc.min(seg-box-dist(..d-service, gas-box), seg-box-dist(..w-kitchen, gas-box), seg-box-dist(..hood-out, gas-box), seg-box-dist(..w-dining, gas-box)) >= gas-rule - 1e-9),
  ([the gas cabinet ≥ 3 m from the manhole (#r2(box-dist(gas-box, manhole-e))) and the grill (#r1(box-dist(gas-box, grill.at(0))))], box-dist(gas-box, manhole-e) >= 3.0 and box-dist(gas-box, grill.at(0)) >= 3.0),
  ([the gas cabinet ≥ 1.5 m from the lane boundary (#r1(calc.min(..range(lane.len() - 1).map(i => seg-box-dist(lane.at(i), lane.at(i + 1), gas-box)))))], calc.min(..range(lane.len() - 1).map(i => seg-box-dist(lane.at(i), lane.at(i + 1), gas-box))) >= 1.5),
  ([the optional parking bay inside the plot, 0.4 m off the house's north wall, inside the setback (so: the municipality's rule)], ((park-opt.at(0), park-opt.at(1)), (park-opt.at(2), park-opt.at(1)), (park-opt.at(2), park-opt.at(3)), (park-opt.at(0), park-opt.at(3))).all(p => inside(p, land)) and park-opt.at(3) <= 3.825 - 0.4 + 1e-9),
  ([the guest path never enters the family garden (west of its low wall) and ends at the guest door], path-guest.all(p => p.at(0) <= 0.9 + 1e-9) and dist(path-guest.last(), (0.91, 26.0)) < 0.05),
  ([the workers' path stays north of the garden's hedge and east of the house], path-workers.slice(1).all(p => p.at(1) <= 18.5) and path-workers.last().at(0) > east-face),
  ([the new tank's reserve inside the plot and ≥ 1.0 m from the house's north wall], ((tank-new.at(0), tank-new.at(1)), (tank-new.at(2), tank-new.at(1)), (tank-new.at(2), tank-new.at(3)), (tank-new.at(0), tank-new.at(3))).all(p => inside(p, land)) and 3.825 - tank-new.at(3) >= 1.0),
  ([the gate (#r2(gate-w) m) and the driveway (#r2(drv-w) m) take a fire vehicle (≥ 3.5 m); every point of the house within 45 m of hose from the driveway (≈ #r1(hose) m)], gate-w >= 3.5 and drv-w >= 3.5 and hose <= 45),
  ([the grill ≥ 3 m from the palms (#r1(calc.min(box-dist((grill.at(0).at(0), grill.at(0).at(1), grill.at(1).at(0), grill.at(1).at(1)), T1), box-dist((grill.at(0).at(0), grill.at(0).at(1), grill.at(1).at(0), grill.at(1).at(1)), T2))))) and the gas cabinet (#r1(box-dist(gas-box, grill.at(0))))], calc.min(box-dist((grill.at(0).at(0), grill.at(0).at(1), grill.at(1).at(0), grill.at(1).at(1)), T1), box-dist((grill.at(0).at(0), grill.at(0).at(1), grill.at(1).at(0), grill.at(1).at(1)), T2)) >= 3.0),
  ([the assumed septic ≥ 30 m from the assumed well (#r1(box-dist(septic, well))): both positions from the survey], box-dist(septic, well) >= 30),
)
#let all-ok = checks.all(c => c.at(1))

// ---------- drawing ----------
#let q(p) = (p.at(0), -p.at(1))
// cropped geometry for the enlarged plans (y ≤ 30): the plot, the envelope, the driveway, the lane and the garden cut at y 30
#let land-c = ((0, 0), (8.64, -1.59), (11.96, 0.17), (15.39, 6.51), (15.68, 7.37), (16.75, 7.83), (20.19, 13.91), (23.02, 20.37), (25.66, 30.0), (0, 30.0))
#let env-c = ((0, 30.0), (0, 3.05), (9.18, 1.36), (9.67, 1.22), (10.48, 1.65), (13.55, 7.3), (14.06, 8.86), (15.35, 9.4), (18.4, 14.8), (21.13, 21.04), (23.59, 30.0))
#let drv-c = ((-3.95, 0.73), (0, 0), (0, 30.0), (-3.95, 30.0))
#let lane-c = ((8.64, -1.59), (11.96, 0.17), (15.39, 6.51), (15.68, 7.37), (16.75, 7.83), (20.19, 13.91), (23.02, 20.37), (25.66, 30.0))
#let garden-c = ((0.9, 27.95), (14.35, 27.95), (14.35, 19.6), (22.5, 19.6), (25.57, 30.0), (0.9, 30.0))
#let site(layer, length: 0.29cm, full: true) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, body, size: 3.6pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, body))
  let poly(P, fill: none, stroke: none, close: true) = line(..P.map(q), close: close, fill: fill, stroke: stroke)
  let R(b, fill: none, stroke: none) = rect(q((b.at(0), b.at(1))), q((b.at(2), b.at(3))), fill: fill, stroke: stroke)
  let dotted(c) = (paint: c, thickness: 0.6pt, dash: "dotted")
  let ymax = if full { 38.7 } else { 30.0 }
  // the plot, the envelope, the driveway, the lane, the north wall
  poly(if full { land } else { land-c }, fill: rgb("#eef3e6"), stroke: 0.8pt + accent)
  poly(if full { env } else { env-c }, fill: rgb("#e6eedc"), stroke: (paint: accent, dash: "dashed", thickness: 0.5pt))
  poly(if full { drv } else { drv-c }, fill: rgb("#d6e2ee"), stroke: 0.5pt + blue); T((-2.0, 16.0), [DRIVEWAY #r2(drv-w) m (stays)], size: 3.2pt, fill: blue, angle: 90deg)
  line(..(if full { lane } else { lane-c }).map(q), stroke: 1.2pt + ink); line(..nwall.map(q), stroke: 1.2pt + ink); T((19.0, 11.0), [lane (outside the wall)], size: 3pt, angle: -60deg)
  // the main gate
  line(q(gate.at(0)), q(gate.at(1)), stroke: 3pt + red); T((-2.0, -0.9), [MAIN GATE 4 m · the only entry], size: 3.4pt, fill: red)
  T((5.5, -2.2), [NORTH STREET], size: 4pt)
  if full {
    // the farm beyond the plot (assumed: old house, its covered parking, the farm parking, the old majlis, the well, the septic, the tank)
    line(q((-9, 40.5)), q((30, 40.5)), stroke: (paint: luma(150), thickness: 0.5pt, dash: "dashed")); T((10, 41.3), [the farm beyond the plot · ASSUMED positions, from the survey], size: 3.2pt, fill: luma(110))
    R((4.0, 42.0, 12.0, 49.0), stroke: dotted(ink)); T((8.0, 45.5), [OLD HOUSE (existing)], size: 3.2pt, fill: luma(90))
    R((12.5, 42.0, 18.0, 47.0), stroke: dotted(ink)); T((15.25, 44.5), [covered family parking\ (2 cars, existing, stays)], size: 3pt, fill: luma(90))
    R((-8.0, 41.0, 2.0, 49.0), stroke: dotted(ink)); T((-3.0, 45.0), [FARM PARKING (existing)\ guests park here], size: 3.2pt, fill: luma(90))
    R((20.0, 45.5, 26.0, 49.0), stroke: dotted(ink)); T((23.0, 47.2), [old majlis (existing)], size: 3pt, fill: luma(90))
    circle(q(well), radius: 0.5, stroke: dotted(blue)); T((well.at(0), well.at(1) + 1.3), [well (existing, position?)], size: 2.8pt, fill: blue)
  }
  // the house
  poly(house, fill: rgb("#f3efe4"), stroke: 1.1pt + ink); poly(court, fill: rgb("#dbe9f4"), stroke: 0.4pt + blue); poly(scourt, fill: rgb("#dbe9f4"), stroke: 0.4pt + blue)
  T((7.5, 15.5), [HOUSE ±0.00], size: 4pt); T((8.3, 13.6), [courtyard], size: 2.8pt, fill: blue); T((8.0, 25.9), [suite court], size: 2.8pt, fill: blue)
  line(q(d-family.at(0)), q(d-family.at(1)), stroke: 2.6pt + red); line(q(d-guest.at(0)), q(d-guest.at(1)), stroke: 2.6pt + red); line(q(d-service.at(0)), q(d-service.at(1)), stroke: 2.6pt + red)
  T((4.4, 4.7), [family entrance], size: 2.8pt, fill: red); T((1.5, 24.7), [guest entrance], size: 2.8pt, fill: red, anchor: "west"); T((14.6, 10.5), [service door], size: 2.8pt, fill: red, anchor: "west")
  for (T_, n) in ((T1, [P1]), (T2, [P2])) { if T_.at(1) <= ymax { circle(q(T_), radius: 1.0, fill: rgb("#cfdfc3"), stroke: 0.5pt + accent); circle(q(T_), radius: 0.27, fill: accent, stroke: none); T((T_.at(0) + 1.4, T_.at(1)), n, size: 3pt, fill: accent) } }
  for p in Ms { if p.at(1) <= ymax { circle(q(p), radius: 0.18, fill: red, stroke: none) } }
  T((-0.6, 0.0), [M1], size: 2.6pt, fill: red, anchor: "east")
  if layer == "access" {
    line(..path-family.map(q), stroke: (paint: red, thickness: 1pt, dash: "dashed"), mark: (end: "stealth", fill: red, scale: 0.5)); T((1.8, 2.2), [family], size: 2.8pt, fill: red)
    let pg = if full { path-guest } else { ((-1.0, 30.0), (-1.0, 26.0), (0.9, 26.0)) }
    line(..pg.map(q), stroke: 1.6pt + stone, mark: (end: "stealth", fill: stone, scale: 0.5)); T((-1.7, 32.0), [GUEST PATH · honey stone · lit], size: 3pt, fill: rgb("#8a5a2b"), angle: 90deg)
    for p in lamps.filter(p => p.at(1) <= ymax) { circle(q(p), radius: 0.15, fill: amber, stroke: none) }
    line(..path-workers.map(q), stroke: (paint: luma(90), thickness: 1pt, dash: "dash-dotted"), mark: (end: "stealth", fill: luma(90), scale: 0.5)); T((13.0, 0.9), [workers: gate → lane side → yard], size: 2.8pt, fill: luma(90))
    R(park-opt, fill: rgb("#d6e2ee"), stroke: (paint: blue, thickness: 0.6pt, dash: "dashed")); T((7.5, 2.15), [optional car 5 × 2.5\ (setback: municipality?)], size: 2.8pt, fill: blue)
    arc(q((0.0, 2.6)), start: 180deg, stop: 90deg, radius: 2.5, stroke: (paint: blue, thickness: 0.5pt, dash: "dotted"), anchor: "origin")
    poly(if full { garden } else { garden-c }, fill: rgb("#dcecd2").transparentize(20%), stroke: (paint: green, thickness: 0.7pt, dash: "dashed")); T((9.0, if full { 34.0 } else { 29.2 }), [FAMILY GARDEN (south only: the palms)], size: 3.4pt, fill: green)
    line(q(lowwall.at(0)), q((0.6, calc.min(lowwall.at(1).at(1), ymax))), stroke: 2.2pt + stone); T((1.3, 29.0), [low stone wall 1.2 m + planting], size: 2.8pt, fill: rgb("#8a5a2b"), anchor: "west")
    line(q(hedge.at(0)), q(hedge.at(1)), stroke: (paint: green, thickness: 2.2pt)); T((18.3, 17.9), [hedge 1.8 m], size: 2.8pt, fill: green)
    line(q(screen.at(0)), q(screen.at(1)), stroke: 2pt + ink); R((bins.at(0).at(0), bins.at(0).at(1), bins.at(1).at(0), bins.at(1).at(1)), fill: luma(200), stroke: 0.4pt + ink)
    R(gas-box, fill: rgb("#ffe08a"), stroke: 0.6pt + red); T((17.0, 13.3), [LPG], size: 2.8pt, fill: red, anchor: "west")
    R((counter.at(0).at(0), counter.at(0).at(1), counter.at(1).at(0), counter.at(1).at(1)), fill: stone, stroke: 0.4pt + ink); T((14.6, 24.7), [counter], size: 2.6pt, anchor: "west")
    if full { R((grill.at(0).at(0), grill.at(0).at(1), grill.at(1).at(0), grill.at(1).at(1)), fill: stone, stroke: 0.4pt + ink); T((16.1, 33.6), [grill + tannour], size: 2.8pt) }
  }
  if layer == "utilities" {
    line(..pipe-old.map(q), stroke: (paint: blue, thickness: 1pt, dash: "dashed")); R(tank-old, fill: rgb("#d6e2ee"), stroke: dotted(blue)); T((15.5, 43.0), [EXISTING tank (position?)\ → the house], size: 2.8pt, fill: blue)
    R(tank-new, fill: rgb("#bcd9ea"), stroke: 0.7pt + blue); T((2.75, 1.55), [RESERVE: future tank\ 3.5 × 2.5 × 2.0 ≈ 17 m³], size: 2.6pt, fill: blue); circle(q(fill-pt), radius: 0.3, fill: blue, stroke: none); T((-2.0, 0.6), [truck fill], size: 2.6pt, fill: blue)
    for P in sewer { line(..P.map(q), stroke: (paint: rgb("#8a5a2b"), thickness: 1.1pt, dash: "dashed"), mark: (end: ">", fill: rgb("#8a5a2b"), scale: 0.45)) }
    for (p, l) in ((manhole-e, [MH east]), (manhole-w, [MH west]), (collector, [collector MH])) { circle(q(p), radius: 0.3, fill: white, stroke: 0.7pt + rgb("#8a5a2b")); T((p.at(0) + 0.5, p.at(1)), l, size: 2.6pt, fill: rgb("#8a5a2b"), anchor: "west") }
    R(septic, fill: rgb("#e9d9c4"), stroke: dotted(rgb("#8a5a2b"))); T((26.0, 46.0), [EXISTING septic (position?\ capacity? condition?)], size: 2.8pt, fill: rgb("#8a5a2b"))
    line(q((septic.at(0), septic.at(1))), q(well), stroke: (paint: red, thickness: 0.4pt, dash: "dotted")); T((9.0, 43.3), [#r1(box-dist(septic, well)) m well ↔ septic (assumed) ≥ 30], size: 2.6pt, fill: red)
    circle(q(pv-riser), radius: 0.3, fill: amber, stroke: none); T((2.0, 13.9), [PV conduits ↓ west shaft], size: 2.6pt, fill: amber, anchor: "west")
    R((inverter.at(0) - 0.6, inverter.at(1) - 0.2, inverter.at(0) + 0.6, inverter.at(1) + 0.2), fill: amber, stroke: none); T((3.6, 12.0), [inverter + batteries\ (utility room)], size: 2.6pt, fill: amber, anchor: "west")
    for (p, l) in rain-pts { circle(q(p), radius: 0.22, fill: rgb("#1f7a99"), stroke: none) }
    T((-0.9, 15.8), [rain ↓], size: 2.6pt, fill: rgb("#1f7a99"), anchor: "east")
    circle(q(soak-e), radius: 0.8, stroke: (paint: rgb("#1f7a99"), dash: "dashed", thickness: 0.6pt)); T((17.5, 14.5), [soakaway E], size: 2.6pt, fill: rgb("#1f7a99"), anchor: "west")
    circle(q(soak-s), radius: 0.8, stroke: (paint: rgb("#1f7a99"), dash: "dashed", thickness: 0.6pt)); T((11.0, 31.0), [soakaway S], size: 2.6pt, fill: rgb("#1f7a99"), anchor: "west")
    line(q(S((13.6, 12.5))), q(soak-e), stroke: (paint: rgb("#1f7a99"), thickness: 0.6pt, dash: "dotted"))
  }
  if layer == "security" {
    for (n, p, l, a) in cams {
      circle(q(p), radius: 0.35, fill: red, stroke: none); T((p.at(0), p.at(1) - 0.8), [#n], size: 3pt, fill: red)
      let a0 = a - 30; let a1 = a + 30
      let d = 6.0
      line(q(p), q((p.at(0) + d * calc.sin(a0 * 1deg), p.at(1) - d * calc.cos(a0 * 1deg))), q((p.at(0) + d * calc.sin(a1 * 1deg), p.at(1) - d * calc.cos(a1 * 1deg))), close: true, fill: red.transparentize(88%), stroke: none)
    }
    circle(q(intercom), radius: 0.3, fill: blue, stroke: none); T((-0.3, 1.8), [video intercom], size: 2.6pt, fill: blue)
    R((panel.at(0) - 0.3, panel.at(1) - 0.3, panel.at(0) + 0.3, panel.at(1) + 0.3), fill: amber, stroke: none); T((2.9, 12.8), [alarm panel], size: 2.6pt, fill: amber, anchor: "west")
    for p in keypads { R((p.at(0) - 0.2, p.at(1) - 0.2, p.at(0) + 0.2, p.at(1) + 0.2), fill: amber, stroke: none) }
    T((3.5, 5.5), [keypad], size: 2.4pt, fill: amber); T((1.5, 22.2), [keypad], size: 2.4pt, fill: amber, anchor: "west")
    line(q((-2.0, 1.0)), q((-2.0, 29.0)), stroke: (paint: rgb("#7a0000"), thickness: 2.5pt, dash: "dashed")); T((-3.0, 15.0), [fire vehicle on the driveway], size: 2.8pt, fill: rgb("#7a0000"), angle: 90deg)
    line(q((0.0, 16.0)), q((east-face, 16.0)), stroke: (paint: rgb("#7a0000"), thickness: 0.5pt, dash: "dotted")); T((7.5, 16.7), [hose ≈ #r1(hose) m (≤ 45)], size: 2.6pt, fill: rgb("#7a0000"))
  }
  // north arrow and scale
  line(q((24.0, 2.5)), q((24.0 + 3 * north.at(0), 2.5 - 3 * north.at(1))), stroke: 0.9pt + ink, mark: (end: "stealth", fill: ink, scale: 0.6)); T((24.6, 0.3), [true N], size: 3pt)
  let ys = if full { 40.0 } else { 29.3 }
  line(q((-8, ys)), q((2, ys)), stroke: 1.2pt + ink); T((-3, ys - 0.6), [10 m], size: 3pt)
})
#let yard-plan(length: 1.25cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, body, size: 3.6pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, body))
  let R(b, fill: none, stroke: none) = rect(q((b.at(0), b.at(1))), q((b.at(2), b.at(3))), fill: fill, stroke: stroke)
  // the house's east wall y 10–19 (site), the kitchen behind it, the strip, the lane boundary
  R((11.5, 9.5, east-face - 0.25, 19.5), fill: rgb("#f3efe4")); T((12.6, 14.5), [KITCHEN\ (hob + hood on\ this wall)], size: 3.4pt)
  R((east-face - 0.25, 9.5, east-face, 19.5), fill: luma(120))
  R((east-face, 9.5, 20.5, 19.5), fill: rgb("#eef3e6"))
  line(q((east-face, 9.8)), q((east-face, 9.0)), q((16.4, 9.0)), stroke: (paint: luma(120), dash: "dashed", thickness: 0.5pt))
  // the openings in the east wall
  line(q(d-service.at(0)), q(d-service.at(1)), stroke: 3pt + red); T((east-face + 0.1, 11.45), [service door 0.90 (the family's door out, east)], size: 3pt, fill: red, anchor: "west")
  line(q(w-kitchen.at(0)), q(w-kitchen.at(1)), stroke: 2.6pt + blue); T((east-face - 0.35, 13.2), [kitchen window], size: 3pt, fill: blue, anchor: "east")
  line(q(hood-out.at(0)), q(hood-out.at(1)), stroke: 2.6pt + luma(90)); T((east-face - 0.35, 14.5), [hood outlet], size: 3pt, fill: luma(90), anchor: "east")
  line(q(w-dining.at(0)), q(w-dining.at(1)), stroke: 2.6pt + blue); T((east-face - 0.35, 19.0), [dining window], size: 3pt, fill: blue, anchor: "east")
  // the screen, the bins, the gas cabinet, the manhole, the workers' path
  line(q(screen.at(0)), q(screen.at(1)), stroke: 2.4pt + ink); T((15.3, 12.5), [screen 1.8 m], size: 3pt, angle: 90deg)
  R((bins.at(0).at(0), bins.at(0).at(1), bins.at(1).at(0), bins.at(1).at(1)), fill: luma(200), stroke: 0.4pt + ink); T((15.0, 10.4), [bins], size: 3pt)
  R(gas-box, fill: rgb("#ffe08a"), stroke: 0.8pt + red); T((16.1, 13.3), [LPG cabinet 1.0 × 0.5\ ventilated, on the screen's\ outer face; the pipe through\ the screen base to the hob], size: 2.8pt, fill: red, anchor: "west")
  circle(q(manhole-e), radius: 0.3, fill: white, stroke: 0.8pt + rgb("#8a5a2b")); T((15.7, 17.3), [manhole (kitchen, laundry,\ maid bath, the courtyard's rain)], size: 2.8pt, fill: rgb("#8a5a2b"), anchor: "west")
  line(q((16.4, 9.5)), q((16.4, 19.0)), stroke: (paint: luma(90), thickness: 1pt, dash: "dash-dotted")); T((16.7, 18.6), [workers' path (deliveries, gas)], size: 2.8pt, fill: luma(90), anchor: "west")
  // distances
  for (a, b, l) in ((gas.at(0), S((13.311, 9.5)), [#r2(seg-box-dist(..w-kitchen, gas-box))]), ((gas.at(0).at(0), gas.at(1).at(1)), (gas.at(0).at(0), manhole-e.at(1)), [#r2(box-dist(gas-box, manhole-e)) to the manhole])) { line(q(a), q(b), stroke: 0.4pt + red, mark: (start: "|", end: "|", scale: 0.4)); T(((a.at(0) + b.at(0)) / 2 + 0.3, (a.at(1) + b.at(1)) / 2), l, size: 2.8pt, fill: red, anchor: "west") }
  T((15.5, 8.6), [SERVICE YARD · 1 m = 1.35 cm · north up · the hedge at y 18.5 closes the yard from the garden], size: 3.4pt, fill: accent)
})

// ====================================================================================== PAGE 1 · the whole plot: access, parking, paths, the garden
#text(14pt, weight: "bold", fill: accent)[Site and services plan · access, parking, paths, the family garden, the service yard, utilities, security, Civil Defense access, levels · Taif / Palm House V8.1 · STUDY]
#v(1pt)
#text(8pt, fill: gray)[Design review S-01 … S-08, E-04 … E-06 · open item 20 · 2 Nov 2026 · drawn on `base.typ` (the plot, the M line, the gate, the palms); the old house, the old majlis, the well, the existing parking, the existing tank and the septic are not in the project files and are drawn dotted where the owner's brief places them · *every site position is PROPOSED, to confirm with the official survey and the engineers*]
#v(3pt)
#grid(columns: (auto, 1fr), gutter: 10pt,
  site("access"),
  [
    #set text(6.5pt)
    #H[1 · Access and parking]
    - *One entry:* the farm is fully walled; the existing *4 m main gate* on the north street (peg M1 is its east post) is the only entry; no other gate (the lane-side gate of V8.0 is dropped). A *video intercom and a camera* at the gate (page 5).
    - *The driveway* (#r2(drv-w) m, west of the M line) stays: the cars' lane from the gate to the farm parking and the family's existing *covered parking for two cars south of the old house* (beyond the plot, assumed position: from the survey). No new carport.
    - *Optional: one uncovered family car* in the north setback strip, a 5 × 2.5 bay 0.4 m off the house's north wall, between the family entrance path and the house's cut corner (dashed). The turn off the driveway is tight (≈ 2.5 m radius into a 4 m deep strip: a reversing manoeuvre); *parking in the setback is for the municipality to allow* (drawn as optional, not counted on).
    - *Guests* park in the large existing *farm parking south of the building* (no new design) and walk the *guest path*: a 1.2 m *honey-stone band along the driveway's east edge* from the plot's south end north to the *guest entrance (the west foyer)*, #r1(plen(path-guest)) m, with bollard lights every 2 m; it never enters the family areas (the garden is behind its low wall, the north strip and the east yard are far). The driveway keeps 2.75 m beside it for one car.
    - *The family* enters by the north: gate → the north strip → the *family entrance* (#r1(plen(path-family)) m); *workers and deliveries*: gate → the north strip → the lane-side strip (2.5–3 m wide east of the cut wall) → the *service yard* east of the screen (#r1(plen(path-workers)) m), never through the garden or past the guest door.
    #v(2pt)
    #H[2 · The family garden and its separation]
    - *A family garden on the south side only*, round the two palms, from the south facade to the plot's south line (≈ #str(calc.round(calc.abs(range(garden.len()).map(i => { let a = garden.at(i); let b = garden.at(calc.rem(i + 1, garden.len())); a.at(0) * b.at(1) - b.at(0) * a.at(1) }).sum()) / 2)) m²); *no other garden* round the house: the north strip is the entrance and the optional car, the west strip the driveway, the east strip the service side.
    - *Separation:* on the west a *low honey-stone wall 1.2 m with planting behind it* between the garden and the guest path on the driveway (a wall, not a hedge: it also holds the garden's soil 0.3 m above the drive and carries the path's lights); on the north-east a *1.8 m hedge* from the house's east wall to the boundary at y 18.5 between the service yard / workers' path and the garden (a hedge, not a wall: the yard's air and the lane-side breeze pass). The grill and tannour and the outdoor counter are inside the garden side.
    - *No garden door from the living* (review S-04: *not needed, owner*): the *kitchen service door* is the family's door to the outside on the east; the garden is reached from it round the south-east corner (the hedge has a gate there) or from the guest entrance side.
  ],
)

// ====================================================================================== PAGE 2 · around the house (enlarged)
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[Around the house (enlarged, y ≤ 30 m) · the strips, the paths, the optional car, the garden's edges]
#v(2pt)
#grid(columns: (auto, 1fr), gutter: 10pt,
  site("access", length: 0.5cm, full: false),
  [
    #set text(6.5pt)
    #H[Around the house]
    - *North strip* (4–4.6 m to the boundary): the family entrance path from the driveway, the optional car, the reserve for the future tank (page 4), the workers' path along its north edge. *West strip* (0.785 m inside the M line) + the driveway: the guest path, the rescue ladder stand for bedrooms 2 and 3 (fire study P2: keep it open at night), the fire vehicle. *East strip* (2.5–9 m to the lane): the yard, the workers' path, the rain soakaway. *South:* the garden.
    - *Levels (page 4):* the house floor ±0.00 is assumed 0.30 m above the ground around it; every strip falls 2 % away from the walls; the driveway and the north strip fall to the gate; *to be set from the survey* (the street level at the gate, the farm's levels, the lane).
  ],
)

// ====================================================================================== PAGE 3 · the service yard
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[The service yard (enlarged): the gas cabinet, the bins, the manhole, the screen, the workers' path · the rule used for the gas cylinders]
#v(2pt)
#grid(columns: (auto, 1fr), gutter: 10pt,
  yard-plan(),
  [
    #set text(6.5pt)
    #H[3 · The service yard (east)]
    - *At the kitchen service door* (the family's door out): the *bins* north of the door against the wall, the *1.8 m screen* 1.3 m from the wall closing the yard from the lane side, the *manhole* at the yard's south end. The *outdoor kitchen* as drawn: the counter and sink against the east wall further south (y 20.8–23.6 in the CSV frame, in the house's afternoon shade; a canopy proposed), the grill and tannour apart in the garden (#r1(box-dist((grill.at(0).at(0), grill.at(0).at(1), grill.at(1).at(0), grill.at(1).at(1)), (east-face, 27.95))) m from the house's corner, #r1(calc.min(box-dist((grill.at(0).at(0), grill.at(0).at(1), grill.at(1).at(0), grill.at(1).at(1)), T1), box-dist((grill.at(0).at(0), grill.at(0).at(1), grill.at(1).at(0), grill.at(1).at(1)), T2))) m from the nearest palm).
    - *The gas cylinders:* in a *ventilated outdoor cabinet 1.0 × 0.5 on the screen's outer (east) face* (CSV x 14.85–15.35, y 9.0–10.0), so the delivery man changes cylinders from the workers' path without entering the yard; the pipe through the screen's base to the hob on the east wall (≈ 3 m). *The rule used (assumed, to confirm with the Civil Defense):* NFPA 58 as adopted in Saudi practice for small cylinders outdoors: ≥ *1.5 m* from any opening into the building below the cylinder's relief valve (doors, windows, the hood outlet), ≥ *3 m* from ignition sources, mechanical air intakes, drains and manholes (LPG is heavier than air), the cabinet ventilated top and bottom, the cylinders upright, the regulator and the shut-off outside, the gas detector and the automatic valve inside (fire study). *Measured:* the service door #r2(seg-box-dist(..d-service, gas-box)) m, the kitchen window #r2(seg-box-dist(..w-kitchen, gas-box)) m, the hood outlet #r2(seg-box-dist(..hood-out, gas-box)) m, the dining window #r2(seg-box-dist(..w-dining, gas-box)) m, the manhole #r2(box-dist(gas-box, manhole-e)) m, the grill #r1(box-dist(gas-box, grill.at(0))) m, the HRV intake on the roof > 10 m, the lane boundary #r1(calc.min(..range(lane.len() - 1).map(i => seg-box-dist(lane.at(i), lane.at(i + 1), gas-box)))) m. #if checks.at(0).at(1) and checks.at(1).at(1) [#OK] else [#text(fill: red)[NO]]
    - *Screened from the guests' path:* the yard is on the east, the guest path on the west; nothing of the yard is seen from it. The *workers' path* runs along the lane side east of the screen and ends at the yard; the *hedge* at y 18.5 stops it short of the garden.
    #v(2pt)
  ],
)

// ====================================================================================== PAGE 4 · utilities
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[Utilities · reserve positions and routes, no system design · water, sewage, power (PV only, no generator), rainwater · levels]
#v(2pt)
#grid(columns: (auto, 1fr), gutter: 10pt,
  site("utilities"),
  [
    #set text(6.5pt)
    #H[4 · Utilities]
    - *Water:* the *existing ground tank stays* (position assumed near the old house: from the survey); its supply pipe to the house is drawn along the driveway's west edge to the *utility room* (the manifold, the heater, the main valve) through the west wall: #r1(plen(pipe-old)) m assumed; the engineer checks the pump and the pipe size. *Reserve for a future new ground tank* near the house: an underground tank 3.5 × 2.5 × 2.0 m (≈ 17 m³, a 20 m³ class) under the north strip beside the family entrance path (CSV-frame x 0.1–3.6, y −3.5 … −1.0), 1.0 m off the house wall, with its *truck fill point on the driveway* 2 m away (the only vehicle access); the municipality's water truck stands inside the gate. Also the fire reserve, if the Civil Defense asks for one.
    - *Sewage:* the house connects to the *existing septic tank* (position assumed south-east beyond the plot: from the survey): the east manhole (the kitchen, the laundry, the maid bath, the suite stack) runs south along the east strip; the west manhole on the driveway (the west wash block's run) runs south and east under the garden's south edge; both meet a *collector manhole* at the garden's south-east, then ≈ #r1(plen(sewer.at(2))) m to the septic. Falls 1–2 % (≈ 0.5 m over the run): the septic's inlet must lie ≥ 1.0 m below the house's ground floor. *Flags for the engineer:* the septic's capacity for the new house (≈ 12 persons with staff), its condition and age, its distance from the well (≥ 30 m in Saudi municipal practice; drawn #r1(box-dist(septic, well)) m on assumed positions), the soakaway's soil (the soil report, open item 7).
    - *Power:* *solar PV provision only* (the roof zones reserved: Z4a / Z4b on the south wing, Z5 on the north block); the *conduits* from the roof come down the *west shaft* to the utility room, where the *inverter and the battery cabinet* go on the north wall beside the main panel (≈ 1.2 × 0.4 m wall space, ventilated; or in the store under the stair's half landing if the utility room is full: the electrical engineer). *No generator* (review E-05: *no generator, owner*). *Note:* until the PV and the batteries are installed there is *no backup during power cuts* (the lift, the HRV, the pumps and the gas valve stop; the gas valve fails closed).
    - *Rainwater:* the roof's 11 outlets reach the ground in internal downpipes and discharge at the plinth: north (1), west (2, into the driveway's channel), the cut and the east wall (2, into the *east soakaway* in the strip), south (2, into the garden); the *courtyard's drain and overflow* and the *suite court's gutter* go east to the manhole's *rain branch* and the east soakaway, *never into the septic*; a second soakaway in the garden takes the south downpipes. The soakaways are sized by the soil report.
    #v(2pt)
    #H[7 · Levels (to be set from the survey)]
    - *Assumed:* the house floor ±0.00; the ground around the house at −0.30 (the plinth 0.6 m shows 0.3 above it); the courtyard's seating −0.15 inside; every strip falls 2 % away from the walls for 2 m, then towards the soakaways; the driveway and the north strip fall gently to the gate (the street level unknown); the garden at −0.30 … −0.60 with the palms' existing ground kept; the yard at −0.30 with its manhole; the farm parking and the old house: unknown.
    - *From the survey:* the street level at the gate, the plot's levels at the pegs M1–M4, the lane's level along the east boundary, the palms' trunk bases, the old house's floor, the septic's inlet level, the well's head. Then the engineer sets the finished floor against the street and the drainage falls.
  ],
)

// ====================================================================================== PAGE 5 · security, Civil Defense, the lists
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[Security · Civil Defense access · the items for the survey, the municipality and the engineers]
#v(2pt)
#grid(columns: (auto, 1fr), gutter: 10pt,
  site("security", full: false),
  [
    #set text(6.5pt)
    #H[5 · Security]
    - *The main gate:* a video intercom (the only entry) and camera C1 on the gate post looking at the gate and the street; the gate's motor and the intercom on the house's alarm circuit.
    - *Cameras round the house* (black fittings, high on the walls under the band or the cornice, IR at night): #cams.map(((n, p, l, a)) => [*#n* #l]).join([; ]). Together they cover the gate, the driveway, the family entrance, the guest entrance, the service yard, the garden and the suite court's outside (its mashrabiya screen and the south-east garden). The recorder with the *alarm panel in the utility room*; keypads at the family entrance and the guest entrance; contacts on the three exit doors and the suite court's doors; the gas detector and the smoke alarms on the same panel (fire study). *The electrical engineer* designs it; positions proposed.
    #v(2pt)
    #H[6 · Civil Defense access]
    - *Can a fire vehicle reach the house?* The gate is #r2(gate-w) m (≥ 3.5 #OK), the driveway #r2(drv-w) m wide and straight for 39 m (≥ 3.5 #OK): a vehicle stands on the driveway along the whole west facade, 0.8 m from it, and sees the north facade from the street and the gate. *There is no turning area inside the plot*: the vehicle turns in the farm parking south of the plot (to confirm that it is reachable and large enough) or reverses out. *Hose reach:* from the driveway round the house to the east wall ≈ #r1(hose) m, the farthest point of the house (≤ 45 m #OK). The east facade is also reached from the *lane* outside the farm wall (2.5–9 m away) if the lane is drivable (to confirm), the south facade from the farm parking.
    - *The engineering office must confirm* (SBC 201 / the Civil Defense's villa checklist): the required approach distance to the facades, the hose reach, the water supply (the tank as a fire reserve, a hydrant on the street?), the gate's clear height, and the rescue ladder stand on the driveway for bedrooms 2 and 3 (fire study P2). #NV
    #v(2pt)
    #H[Items for the survey]
    + The old house, its covered parking, the farm parking, the old majlis, the well, the existing ground tank, the septic tank and the farm's walls: their positions and levels (all assumed here).
    + The street level at the gate, the levels at the pegs, the lane's level, the plot's south line, the palms' trunks.
    + The legal boundaries and the setback lines (open item 1): the north street line and the lane line against the envelope used here.
    #H[Items for the municipality]
    + Parking in the north setback strip (one uncovered car): allowed?
    + The septic tank's reuse for the new house; the rain soakaways; the discharge to the lane side.
    + The gas cabinet and the Civil Defense's villa requirements (access, water, alarms).
    #H[Items for the engineers]
    + Civil / MEP: the septic's capacity and condition, the sewer falls, the well distance; the water tank's pump and pipe; the new tank's size and the fill point; the soakaways from the soil report; the PV conduits and the inverter / battery space; the gas pipe and the cabinet's details; the levels and the drainage round the house.
    + Electrical: the cameras, the intercom, the alarm panel, the gate motor, the night lights on bedroom 1's route, the outdoor lighting of the paths.
    #v(3pt)
    #text(8pt)[#if all-ok [*Study checks passed* (#checks.len())] else [*STUDY CHECKS FAILED:* #checks.filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]]
    #v(2pt)
    #text(6pt, fill: gray)[Checks: #checks.map(c => c.at(0)).join([ · ]). Every position is proposed, to confirm with the official survey and the engineers; the items outside the plot are assumed.]
  ],
)

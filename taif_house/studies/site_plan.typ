// site_plan.typ · Taif / Palm House V8.1 (work) · SITE AND SERVICES PLAN (design review S-01 … S-08, E-04 … E-06; open item 20) · 2 Nov 2026 · 3 Nov 2026: the septic and the tanks corrected (owner).
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
#let park-opt = (5.2, 0.9, 10.2, 3.4)               // one uncovered family car in the north setback strip: KEPT (owner, 2 Nov 2026: the municipality allows parking inside the plot)
// the swept path of a standard car (4.5 × 1.8, outer turning radius 5.5 m): a forward 90° turn from the driveway into the 4–4.6 m strip does not fit, so the car
// enters in a 3-point manoeuvre: (1) in through the gate and south on the driveway to y ≈ 7, (2) reverse north-east into the strip with the wheel turned, (3) forward west
// into the bay (nose west). The bay starts 0.3 m east of the family entrance's path (x 4.9): the entrance stays clear.
#let car-R = 5.5
#let swept = (((-2.0, 0.5), (-2.0, 7.0)), ((-2.0, 7.0), (-1.2, 5.0), (0.6, 3.2), (3.0, 2.5)), ((3.0, 2.5), (5.2, 2.15), (10.2, 2.15)))   // the three moves (centre line, schematic)
#let bay-clear-of-entrance = park-opt.at(0) - d-family.at(1).at(0)
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
#let manhole-e = S((14.3, 13.5))                                     // the east-yard FOUL chamber (kitchen, laundry, maid bath, the suite stack): at the yard's south end; rain NEVER enters it (3 Nov 2026)
#let rain-ch = (15.7, 15.9)                                           // the east RAIN chamber (the courtyard's drain and overflow, the east downpipes) → the east soakaway; separate from the foul system
// ---------- 4 · Utilities (positions approximate, to be measured on site; 3 Nov 2026: the owner's information on the septic and the tank) ----------
#let C1 = (-6.5, 1.2)                                                 // corner C1: the plot's north-west corner on the north street (drawn at the north wall's west end in base.typ; exact position from the survey)
#let septic = (-10.5, -1.9, -6.5, 0.5)                               // EXISTING septic tank: OUTSIDE the farm wall near C1, under the street side (owner); approximate, to be measured on site; capacity, condition and inlet level for the engineer
#let septic-in = (-6.5, -0.7)                                         // its inlet (assumed at its east end, facing the gate)
#let wall-x = ((-5.0, 1.2 - 2.79 * (1.5 / 15.14)))                    // where the drain crosses UNDER the boundary wall (west of the gate's west post)
#let pegR = (0.0, 48.5)                                               // peg R: assumed on the M line's extension at the farm parking, south of the old house (NOT in the project files: from the survey)
#let tank-old = (0.8, 47.8, 3.8, 50.3)                               // EXISTING ground tank (in use): just EAST of peg R, south of the old house (owner); approximate, to be measured
#let tank-new = (4.3, 47.8, 7.8, 50.3)                               // RESERVE: the future tank 3.5 × 2.5 × 2.0 (≈ 17 m³) NEXT TO the existing one (not under the north strip any more)
#let fill-pt = (-2.0, 48.5)                                           // the water truck stands on the driveway's end beside the tanks
#let pipe-old = ((0.8, 48.0), (-0.6, 48.0), (-0.6, 12.9), (0.9, 12.9))   // the supply pipe from the tanks to the utility room: under the guest path band on the driveway's east edge (assumed route)
#let well = (-7.0, 45.0)                                             // EXISTING well, position assumed (the survey)
// foul drainage (3 Nov 2026): both clusters → inspection chambers → NORTH and WEST to the septic near C1, under the boundary wall west of the gate
#let ch-w = (-2.4, 14.5)                                              // the west chamber on the driveway (the west wash block's run, which now falls NORTH inside the house and leaves under the west wall at the hospitality kitchen)
#let ch-ne = (16.0, 10.2)                                             // the east strip's chamber under the workers' path (the bend round the cut wall)
#let ch-n = (11.0, 0.6)                                               // the north strip's chamber (its north edge, under the workers' path, north of the parking bay)
#let ch-gate = (-2.6, 1.6)                                            // the collector chamber on the driveway inside the gate (the pump station's place if the septic's inlet is too high)
#let sewer-e = (manhole-e, ch-ne, ch-n, ch-gate)                      // the east main
#let sewer-w = (ch-w, ch-gate)                                        // the west branch
#let sewer-out = (ch-gate, wall-x, septic-in)                         // under the wall to the septic
#let sewer = (sewer-e, sewer-w, sewer-out)
// falls (ASSUMED, to be designed by the plumbing engineer): Ø 110 branches 1.5 %, the Ø 160 main 1.0 %, 0.03 m drop through each chamber; the ground slab's underside at −0.28, the pipe crown ≥ 0.10 below it
#let inv0 = -0.50                                                     // the invert at the farthest ground-floor fixture (the laundry / maid bath on the east, the guest basins on the west)
#let g-br = 0.015; #let g-main = 0.010; #let ch-drop = 0.03
#let br-e = 13.5                                                      // the longest east branch inside the house (the laundry, plumbing study)
#let br-w = 11.0                                                      // the west run from the guest basins north to the west wall
#let inv-mh-e = inv0 - g-br * br-e - ch-drop
#let inv-ch-w = inv0 - g-br * br-w - ch-drop
#let L-e = range(sewer-e.len() - 1).map(i => dist(sewer-e.at(i), sewer-e.at(i + 1)))
#let inv-ne = inv-mh-e - g-main * L-e.at(0) - ch-drop
#let inv-n = inv-ne - g-main * L-e.at(1) - ch-drop
#let inv-gate-e = inv-n - g-main * L-e.at(2) - ch-drop
#let inv-gate-w = inv-ch-w - g-main * dist(ch-w, ch-gate) - ch-drop
#let inv-gate = calc.min(inv-gate-e, inv-gate-w)
#let L-out = plen(sewer-out)
#let inv-septic = inv-gate - g-main * L-out
#let ground-gate = -0.40                                              // the ground at the gate (assumed: the driveway falls to the gate; the street level from the survey)
#let main-len = plen(sewer-e) + L-out
#let sep-rule = (septic-well: 30.0, septic-tank: 15.0, drain-pipe: 1.5, tank-house: 5.0)   // assumed rules (to confirm by the engineer): Saudi municipal practice for the well; UPC-type table for the tank and the pipe
#let pv-riser = S((0.75, 9.8))                                       // the west shaft: the PV conduits from the roof down to the utility room
#let inverter = S((2.0, 8.3))                                        // the inverter + battery cabinet on the utility room's north wall (beside the main panel)
#let rain-pts = ((S((5.0, -0.25)), [N]), ((-0.3, S((0, 12.0)).at(1)), [W]), ((-0.3, S((0, 17.5)).at(1)), [W]), (S((13.6, 12.5)), [E]), (S((11.9, 2.2)), [cut]), (S((2.0, 24.3)), [S]), (S((11.5, 24.3)), [S]))
#let court-out = S((13.311, 12.1))                                    // the courtyard's drain + overflow branch leaves the east wall here → the rain chamber (never the foul chamber)
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
  ([the family parking bay (kept) inside the plot, 0.4 m off the house's north wall, #r2(bay-clear-of-entrance) m clear of the family entrance's path], ((park-opt.at(0), park-opt.at(1)), (park-opt.at(2), park-opt.at(1)), (park-opt.at(2), park-opt.at(3)), (park-opt.at(0), park-opt.at(3))).all(p => inside(p, land)) and park-opt.at(3) <= 3.825 - 0.4 + 1e-9 and bay-clear-of-entrance >= 0.1 - 1e-9),
  ([the guest path never enters the family garden (west of its low wall) and ends at the guest door], path-guest.all(p => p.at(0) <= 0.9 + 1e-9) and dist(path-guest.last(), (0.91, 26.0)) < 0.05),
  ([the workers' path stays north of the garden's hedge and east of the house], path-workers.slice(1).all(p => p.at(1) <= 18.5) and path-workers.last().at(0) > east-face),
  ([the tanks (existing + reserve) ≥ #r1(sep-rule.tank-house) m from the house's south-west corner and its footings (#r1(calc.min(box-dist(tank-old, S((0, 24))), box-dist(tank-new, S((0, 24))))) m, assumed positions)], calc.min(box-dist(tank-old, S((0, 24))), box-dist(tank-new, S((0, 24)))) >= sep-rule.tank-house),
  ([the septic OUTSIDE the plot's wall near C1 (every corner outside the land polygon), its inlet ≥ 1.0 m below the house floor on the computed falls (#r2(inv-septic)) and #r2(inv-septic - ground-gate) m below the assumed ground at the gate], ((septic.at(0), septic.at(1)), (septic.at(2), septic.at(1)), (septic.at(2), septic.at(3)), (septic.at(0), septic.at(3))).all(p => not inside(p, land)) and inv-septic <= -1.0),
  ([the septic ≥ #r1(sep-rule.septic-tank) m from both water tanks (#r1(calc.min(box-dist(septic, (tank-old.at(0), tank-old.at(1))), box-dist(septic, (tank-new.at(0), tank-new.at(1)))))) and the foul chambers ≥ #r1(sep-rule.septic-tank) m from them (#r1(calc.min(..(ch-w, ch-gate, ch-n, ch-ne, manhole-e).map(c => calc.min(box-dist(tank-old, c), box-dist(tank-new, c))))))], calc.min(box-dist(septic, (tank-old.at(0), tank-old.at(1))), box-dist(septic, (tank-new.at(0), tank-new.at(1)))) >= sep-rule.septic-tank and calc.min(..(ch-w, ch-gate, ch-n, ch-ne, manhole-e).map(c => calc.min(box-dist(tank-old, c), box-dist(tank-new, c)))) >= sep-rule.septic-tank),
  ([the water pipe ≥ #r1(sep-rule.drain-pipe) m from the foul drains along the driveway (#r2(calc.abs(pipe-old.at(1).at(0) - ch-w.at(0))) m) and from the rain chambers], calc.abs(pipe-old.at(1).at(0) - ch-w.at(0)) >= sep-rule.drain-pipe and calc.abs(pipe-old.at(1).at(0) - ch-gate.at(0)) >= sep-rule.drain-pipe),
  ([the rain system never joins the foul one: the courtyard's outlet reaches the rain chamber (#r1(dist(court-out, rain-ch)) m), not the foul chamber], dist(court-out, rain-ch) < dist(court-out, manhole-e)),
  ([the gate (#r2(gate-w) m) and the driveway (#r2(drv-w) m) take a fire vehicle (≥ 3.5 m); every point of the house within 45 m of hose from the driveway (≈ #r1(hose) m)], gate-w >= 3.5 and drv-w >= 3.5 and hose <= 45),
  ([the grill ≥ 3 m from the palms (#r1(calc.min(box-dist((grill.at(0).at(0), grill.at(0).at(1), grill.at(1).at(0), grill.at(1).at(1)), T1), box-dist((grill.at(0).at(0), grill.at(0).at(1), grill.at(1).at(0), grill.at(1).at(1)), T2))))) and the gas cabinet (#r1(box-dist(gas-box, grill.at(0))))], calc.min(box-dist((grill.at(0).at(0), grill.at(0).at(1), grill.at(1).at(0), grill.at(1).at(1)), T1), box-dist((grill.at(0).at(0), grill.at(0).at(1), grill.at(1).at(0), grill.at(1).at(1)), T2)) >= 3.0),
  ([the septic ≥ #r1(sep-rule.septic-well) m from the well (#r1(box-dist(septic, well)) m): both positions approximate, from the survey], box-dist(septic, well) >= sep-rule.septic-well),
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
    R(park-opt, fill: rgb("#d6e2ee"), stroke: 0.7pt + blue); T((7.7, 2.15), [family car 5 × 2.5 · KEPT\ (parking in the plot allowed)], size: 2.8pt, fill: blue)
    for (k, P) in swept.enumerate() { line(..P.map(q), stroke: (paint: blue, thickness: 1.0pt, dash: if k == 1 { "dashed" } else { "solid" }), mark: (end: "stealth", fill: blue, scale: 0.45)) }
    T((-1.4, 7.6), [1 in], size: 2.6pt, fill: blue); T((1.4, 4.6), [2 reverse], size: 2.6pt, fill: blue); T((7.0, 1.4), [3 forward into the bay], size: 2.6pt, fill: blue)
    poly(if full { garden } else { garden-c }, fill: rgb("#dcecd2").transparentize(20%), stroke: (paint: green, thickness: 0.7pt, dash: "dashed")); T((9.0, if full { 34.0 } else { 29.2 }), [FAMILY GARDEN (south only: the palms)], size: 3.4pt, fill: green)
    line(q(lowwall.at(0)), q((0.6, calc.min(lowwall.at(1).at(1), ymax))), stroke: 2.2pt + stone); T((1.3, 29.0), [low stone wall 1.2 m + planting], size: 2.8pt, fill: rgb("#8a5a2b"), anchor: "west")
    line(q(hedge.at(0)), q(hedge.at(1)), stroke: (paint: green, thickness: 2.2pt)); T((18.3, 17.9), [hedge 1.8 m], size: 2.8pt, fill: green)
    line(q(screen.at(0)), q(screen.at(1)), stroke: 2pt + ink); R((bins.at(0).at(0), bins.at(0).at(1), bins.at(1).at(0), bins.at(1).at(1)), fill: luma(200), stroke: 0.4pt + ink)
    R(gas-box, fill: rgb("#ffe08a"), stroke: 0.6pt + red); T((17.0, 13.3), [LPG], size: 2.8pt, fill: red, anchor: "west")
    R((counter.at(0).at(0), counter.at(0).at(1), counter.at(1).at(0), counter.at(1).at(1)), fill: stone, stroke: 0.4pt + ink); T((14.6, 24.7), [counter], size: 2.6pt, anchor: "west")
    if full { R((grill.at(0).at(0), grill.at(0).at(1), grill.at(1).at(0), grill.at(1).at(1)), fill: stone, stroke: 0.4pt + ink); T((16.1, 33.6), [grill + tannour], size: 2.8pt) }
  }
  if layer == "utilities" {
    line(..pipe-old.map(q), stroke: (paint: blue, thickness: 1pt, dash: "dashed")); T((-1.2, 20.0), [water pipe → utility room], size: 2.6pt, fill: blue, angle: 90deg)
    R(tank-old, fill: rgb("#d6e2ee"), stroke: dotted(blue)); T((2.3, 49.05), [EXISTING tank (in use)\ east of peg R · approx.], size: 2.6pt, fill: blue)
    R(tank-new, fill: rgb("#bcd9ea"), stroke: 0.7pt + blue); T((6.05, 49.05), [RESERVE: future tank\ 3.5 × 2.5 × 2.0 ≈ 17 m³], size: 2.6pt, fill: blue); circle(q(fill-pt), radius: 0.3, fill: blue, stroke: none); T((-2.0, 47.6), [truck fill], size: 2.6pt, fill: blue)
    circle(q(pegR), radius: 0.2, fill: red, stroke: none); T((-0.5, 48.5), [R (assumed)], size: 2.6pt, fill: red, anchor: "east")
    for P in sewer { line(..P.map(q), stroke: (paint: rgb("#8a5a2b"), thickness: 1.1pt, dash: "dashed"), mark: (end: ">", fill: rgb("#8a5a2b"), scale: 0.45)) }
    for (p, l, a) in ((manhole-e, [foul CH east #r2(inv-mh-e)], "west"), (ch-ne, [CH #r2(inv-ne)], "west"), (ch-n, [CH #r2(inv-n)], "west"), (ch-w, [CH west #r2(inv-ch-w)], "east"), (ch-gate, [collector CH #r2(inv-gate)\ (pump station if needed)], "east")) { circle(q(p), radius: 0.3, fill: white, stroke: 0.7pt + rgb("#8a5a2b")); T((p.at(0) + (if a == "west" { 0.5 } else { -0.5 }), p.at(1)), l, size: 2.5pt, fill: rgb("#8a5a2b"), anchor: a) }
    circle(q(rain-ch), radius: 0.3, fill: white, stroke: 0.7pt + rgb("#1f7a99")); T((rain-ch.at(0) + 0.5, rain-ch.at(1)), [rain CH], size: 2.5pt, fill: rgb("#1f7a99"), anchor: "west"); line(q(court-out), q(rain-ch), stroke: (paint: rgb("#1f7a99"), thickness: 0.6pt, dash: "dotted")); line(q(rain-ch), q(soak-e), stroke: (paint: rgb("#1f7a99"), thickness: 0.6pt, dash: "dotted"))
    R(septic, fill: rgb("#e9d9c4"), stroke: dotted(rgb("#8a5a2b"))); T((-8.5, -2.6), [EXISTING septic · outside the wall near C1\ approx. · inlet #r2(inv-septic) (computed) · level? capacity? condition?], size: 2.6pt, fill: rgb("#8a5a2b"))
    circle(q(C1), radius: 0.2, fill: red, stroke: none); T((-6.5, 2.0), [C1], size: 2.6pt, fill: red)
    line(q((septic.at(2), septic.at(3))), q(well), stroke: (paint: red, thickness: 0.4pt, dash: "dotted")); T((-7.5, 24.0), [#r1(box-dist(septic, well)) m septic ↔ well (approx.) ≥ #r1(sep-rule.septic-well)], size: 2.6pt, fill: red, angle: 90deg)
    circle(q(pv-riser), radius: 0.3, fill: amber, stroke: none); T((2.0, 13.9), [PV conduits ↓ west shaft], size: 2.6pt, fill: amber, anchor: "west")
    R((inverter.at(0) - 0.6, inverter.at(1) - 0.2, inverter.at(0) + 0.6, inverter.at(1) + 0.2), fill: amber, stroke: none); T((3.6, 12.0), [inverter + batteries\ (utility room)], size: 2.6pt, fill: amber, anchor: "west")
    for (p, l) in rain-pts { circle(q(p), radius: 0.22, fill: rgb("#1f7a99"), stroke: none) }
    T((-0.9, 15.8), [rain ↓], size: 2.6pt, fill: rgb("#1f7a99"), anchor: "east")
    circle(q(soak-e), radius: 0.8, stroke: (paint: rgb("#1f7a99"), dash: "dashed", thickness: 0.6pt)); T((17.5, 14.5), [soakaway E], size: 2.6pt, fill: rgb("#1f7a99"), anchor: "west")
    circle(q(soak-s), radius: 0.8, stroke: (paint: rgb("#1f7a99"), dash: "dashed", thickness: 0.6pt)); T((11.0, 31.0), [soakaway S], size: 2.6pt, fill: rgb("#1f7a99"), anchor: "west")
    line(q(S((13.6, 12.5))), q(soak-e), stroke: (paint: rgb("#1f7a99"), thickness: 0.6pt, dash: "dotted")); line(q(S((4.25, 23.6))), q(soak-s), stroke: (paint: rgb("#1f7a99"), thickness: 0.6pt, dash: "dotted")); line(q(S((10.0, 23.6))), q(soak-s), stroke: (paint: rgb("#1f7a99"), thickness: 0.6pt, dash: "dotted")); T((9.3, 29.6), [suite court ↓], size: 2.4pt, fill: rgb("#1f7a99"))
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
  circle(q(manhole-e), radius: 0.3, fill: white, stroke: 0.8pt + rgb("#8a5a2b")); T((15.7, 17.3), [foul chamber (kitchen, laundry,\ maid bath, the suite stack);\ the courtyard's rain: its own chamber], size: 2.8pt, fill: rgb("#8a5a2b"), anchor: "west")
  line(q((16.4, 9.5)), q((16.4, 19.0)), stroke: (paint: luma(90), thickness: 1pt, dash: "dash-dotted")); T((16.7, 18.6), [workers' path (deliveries, gas)], size: 2.8pt, fill: luma(90), anchor: "west")
  // distances
  for (a, b, l) in ((gas.at(0), S((13.311, 9.5)), [#r2(seg-box-dist(..w-kitchen, gas-box))]), ((gas.at(0).at(0), gas.at(1).at(1)), (gas.at(0).at(0), manhole-e.at(1)), [#r2(box-dist(gas-box, manhole-e)) to the manhole])) { line(q(a), q(b), stroke: 0.4pt + red, mark: (start: "|", end: "|", scale: 0.4)); T(((a.at(0) + b.at(0)) / 2 + 0.3, (a.at(1) + b.at(1)) / 2), l, size: 2.8pt, fill: red, anchor: "west") }
  T((15.5, 8.6), [SERVICE YARD · 1 m = 1.35 cm · north up · the hedge at y 18.5 closes the yard from the garden], size: 3.4pt, fill: accent)
})

// ====================================================================================== PAGE 1 · the whole plot: access, parking, paths, the garden
#text(14pt, weight: "bold", fill: accent)[Site and services plan · access, parking, paths, the family garden, the service yard, utilities, security, Civil Defense access, levels · Taif / Palm House V8.1 · STUDY]
#v(1pt)
#text(8pt, fill: gray)[Design review S-01 … S-08, E-04 … E-06 · open item 20 · 2 Nov 2026 · drawn on `base.typ` (the plot, the M line, the gate, the palms); the old house, the old majlis, the well, the existing parking, the existing tank (east of peg R) and the septic (outside the wall near C1) are not in the project files and are drawn dotted where the owner places them, approximate · *every site position is PROPOSED, to confirm with the official survey and the engineers*]
#v(3pt)
#grid(columns: (auto, 1fr), gutter: 10pt,
  site("access"),
  [
    #set text(6.5pt)
    #H[1 · Access and parking]
    - *One entry:* the farm is fully walled; the existing *4 m main gate* on the north street (peg M1 is its east post) is the only entry; no other gate (the lane-side gate of V8.0 is dropped). A *video intercom and a camera* at the gate (page 5).
    - *The driveway* (#r2(drv-w) m, west of the M line) stays: the cars' lane from the gate to the farm parking and the family's existing *covered parking for two cars south of the old house* (beyond the plot, assumed position: from the survey). No new carport.
    - *One uncovered family car KEPT* (owner, 2 Nov 2026: parking inside the plot is allowed by the municipality): a 5 × 2.5 bay in the north setback strip, 0.4 m off the house's north wall, #r2(bay-clear-of-entrance) m east of the family entrance's path, which stays clear. *The swept path* of a standard car (4.5 × 1.8, outer radius ≈ #r1(car-R) m) shows that a forward 90° turn from the driveway into a 4–4.6 m deep strip does not fit; the car enters in a *3-point manoeuvre* (in through the gate and 7 m south on the driveway; reverse north-east into the strip; forward west into the bay, nose west) and leaves forward onto the driveway; the parked car stays clear of the entrance, and the manoeuvre crosses the entrance path at grade (the kerb flush there), as on any driveway. *Improvement if wanted:* round the family entrance path's kerb and keep the reserve tank's lid flush, so the strip's west end (x 0–5.2) is usable as the turning pocket; a shorter car fits in one move.
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
#text(12pt, weight: "bold", fill: accent)[Around the house (enlarged, y ≤ 30 m) · the strips, the paths, the family car (kept), the garden's edges]
#v(2pt)
#grid(columns: (auto, 1fr), gutter: 10pt,
  site("access", length: 0.5cm, full: false),
  [
    #set text(6.5pt)
    #H[Around the house]
    - *North strip* (4–4.6 m to the boundary): the family entrance path from the driveway, the family car (kept), the foul drain to the septic under its north edge (page 4), the workers' path along its north edge. *West strip* (0.785 m inside the M line) + the driveway: the guest path, the rescue ladder stand for bedrooms 2 and 3 (fire study P2: keep it open at night), the fire vehicle. *East strip* (2.5–9 m to the lane): the yard, the workers' path, the rain soakaway. *South:* the garden.
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
    - *Water (owner, 3 Nov 2026):* the *existing ground tank (in use) is just EAST of peg R, south of the old house*: drawn there, *approximate, to be measured* (peg R itself is not in the project files; assumed on the M line's extension at the farm parking). Its nearest corner is #r1(box-dist(tank-old, S((0, 24)))) m from the new house's south-west corner and its footings (≥ #r1(sep-rule.tank-house) m #if checks.at(6).at(1) [#OK] else [#text(fill: red)[NO]]): no conflict with the excavation. Its supply pipe to the *utility room* (the manifold, the heater, the main valve) runs under the guest path band on the driveway's east edge through the west wall: #r1(plen(pipe-old)) m assumed (the engineer checks the pump and the pipe size). *The reserved future tank* (3.5 × 2.5 × 2.0 m, ≈ 17 m³) goes *NEXT TO the existing one* (east of it), not under the north strip any more: the *water truck* stands at the driveway's end beside the tanks, and the new tank shares the existing pipe. The north strip is freed (the turning pocket for the car, page 1). Also the fire reserve, if the Civil Defense asks for one.
    - *Sewage (owner, 3 Nov 2026):* the *existing septic tank is OUTSIDE the farm wall near corner C1* (the plot's north-west corner on the north street): drawn there, *approximate, to be measured on site*. The foul drains of both clusters run to it NORTH and WEST: the *east main* from the foul chamber in the yard (the kitchen, the laundry, the maid bath, the suite stack) north under the workers' path round the cut wall (chamber at the bend), along the north strip's north edge (chamber), to the *collector chamber on the driveway inside the gate*; the *west branch* from the west chamber on the driveway (the west wash block's run, which now falls *north* inside the house) to the same collector; then *under the boundary wall west of the gate's post* to the septic's inlet: the east main #r1(main-len) m end to end. *Falls, all ASSUMED (the plumbing engineer):* Ø 110 branches 1.5 %, the Ø 160 main 1.0 %, 0.03 m through each chamber, the invert at the farthest fixture −0.50 (the crown 0.10 under the ground slab): foul chamber east #r2(inv-mh-e) → bend #r2(inv-ne) → north strip #r2(inv-n) → collector #r2(inv-gate) (the west branch arrives at #r2(inv-gate-w)) → *the septic's inlet at #r2(inv-septic) below the house floor*, ≈ #r2(ground-gate - inv-septic) m below the assumed ground at the gate. *So the septic's inlet level must be surveyed:* if it lies higher than ≈ #r2(inv-septic) (the house floor ±0.00 is itself to be set against the street), the main cannot fall to it and a *small packaged pump station* (two pumps, an alarm) at the collector chamber would be needed: flagged. *Flags for the survey, the municipality and the engineer:* the septic's *legal position outside the wall* (under the street side: the municipality's consent to keep using it and to cross under the wall), its inlet level, its capacity for the new house (≈ 12 persons with staff), its condition and age; its vent (page 6 of the plumbing study: away from the house, the gate and the north parking).
    - *Power:* *solar PV provision only* (the roof zones reserved: Z4a / Z4b on the south wing, Z5 on the north block); the *conduits* from the roof come down the *west shaft* to the *utility room*, where the *inverter and the battery cabinet* go (owner, 2 Nov 2026: the utility room; the electrical engineer confirms the space, the ventilation and the fire safety; the room's layout with the water kept away from the batteries is in `studies/plumbing.typ`). *No generator* (review E-05: *no generator, owner*). *Note:* until the PV and the batteries are installed there is *no backup during power cuts* (the lift, the HRV, the pumps and the gas valve stop; the gas valve fails closed).
    - *Rainwater — fully separate from the sewage (3 Nov 2026, corrected):* the roof's 11 outlets reach the ground in internal downpipes and discharge at the plinth: north (1), west (2, into the driveway's channel), the cut and the east wall (2, into the *east rain chamber* and the *east soakaway* in the strip), south (2, into the garden's soakaway); the *courtyard's drain and overflow* leave the east wall to the *east rain chamber* (their own chamber #r1(dist(court-out, rain-ch)) m away, not the foul chamber: corrected); the *suite court's gutter outlets* come down the gym's and the office's walls to the *south soakaway* in the garden; the site's surface water falls to the soakaways and the driveway's channel to the gate. *Nothing of the rain ever enters the septic.* The *final discharge* is chosen with the soil report (open item 7), the levels, the well (soakaways ≥ 10 m from it, assumed rule) and the foundations (≥ 5 m from the house, assumed rule): the two soakaways as drawn, each with a *safe overflow* at the surface towards the lane side / the driveway's channel, never towards the house.
    #v(2pt)
    #H[7 · Levels (to be set from the survey)]
    - *Assumed:* the house floor ±0.00; the ground around the house at −0.30 (the plinth 0.6 m shows 0.3 above it); the courtyard's seating −0.15 inside; every strip falls 2 % away from the walls for 2 m, then towards the soakaways; the driveway and the north strip fall gently to the gate (the street level unknown); the garden at −0.30 … −0.60 with the palms' existing ground kept; the yard at −0.30 with its manhole; the farm parking and the old house: unknown.
    - *From the survey:* the street level at the gate, the plot's levels at the pegs M1–M4, corner C1 and peg R, the lane's level along the east boundary, the palms' trunk bases, the old house's floor, the septic's position and *inlet level* (outside the wall near C1), the tanks' positions and lids, the well's head. Then the engineer sets the finished floor against the street and the drainage falls.
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
    + The old house, its covered parking, the farm parking, the old majlis, the well, the existing ground tank (east of peg R), the septic tank (outside the wall near C1: its inlet level, its size) and the farm's walls: their positions and levels (all approximate here).
    + The street level at the gate, the levels at the pegs, the lane's level, the plot's south line, the palms' trunks.
    + The legal boundaries and the setback lines (open item 1): the north street line and the lane line against the envelope used here.
    #H[Items for the municipality]
    + Parking in the north setback strip (one uncovered car): allowed?
    + The septic tank's reuse for the new house and its *legal position outside the wall* (under the street side near C1), the drain crossing under the wall; the rain soakaways and their overflows; the discharge to the lane side.
    + The gas cabinet and the Civil Defense's villa requirements (access, water, alarms).
    #H[Items for the engineers]
    + Civil / MEP: the septic's capacity, condition and inlet level (a pump station at the collector if it is too high), the sewer falls as computed here, the separations (the rules assumed here), the well distance; the water tank's pump and pipe; the new tank's size and the fill point; the soakaways from the soil report; the PV conduits and the inverter / battery space; the gas pipe and the cabinet's details; the levels and the drainage round the house.
    + Electrical: the cameras, the intercom, the alarm panel, the gate motor, the night lights on bedroom 1's route, the outdoor lighting of the paths.
    #v(3pt)
    #text(8pt)[#if all-ok [*Study checks passed* (#checks.len())] else [*STUDY CHECKS FAILED:* #checks.filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]]
    #v(2pt)
    #text(6pt, fill: gray)[Checks: #checks.map(c => c.at(0)).join([ · ]). Every position is proposed, to confirm with the official survey and the engineers; the items outside the plot are approximate (the septic near C1, the tanks east of peg R: the owner's information, to be measured on site).]
  ],
)

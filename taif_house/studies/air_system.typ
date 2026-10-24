// air_system.typ · Taif / Palm House V6.2 · AIR SYSTEM STUDY: malqaf (wind tower) + underground tunnel + water channel + outlet chamber · compile THIS file
// Design-development study, not an engineering design: EVERY size, level and performance figure is ASSUMED, to be checked by the MEP and structural engineers.
// The room outlines come from ../data/rooms_gf.csv; the tower polygon and the column lines from the design and the structural study. Written up in ../docs/AIR_SYSTEM.md.
// Coordinates: the CSV frame (metres, x east, y south, origin = the building's north-west wall corner). Levels: finished ground floor ±0.00, FF +3.60, roof slab +7.20, roof finish +7.30.
// The 3D model (3d/build_3d.py) reads the `air-*` values below: change them here, never in the 3D.
#import "@preview/cetz:0.4.2"
#set page(paper: "a4", flipped: true, margin: 10mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial"), size: 7.2pt)

// ---------- the system, as data (CSV frame; levels in metres from the finished ground floor) ----------
#let air-tower = ((8.95, 0), (10.051, 0), (10.594, 1.0), (8.95, 1.0))   // the tower shaft on wall centre lines (design_gf.typ tower-pts)
#let air-head = (7.3, 9.8)              // the head: from the roof finish to the top of the shaft walls, 2.5 m above the roof (assumed)
#let air-head-opening = (8.2, 9.4)      // the louvred openings in the head (sill, head), on the north and west faces (towards the NW wind)
#let air-base = (-0.08, -3.15)          // the base chamber under the tower: from the ground slab top to the box underside (one RC box with the shaft walls)
#let air-route = ((8.95, 0.75), (7.27, 0.75), (7.27, 6.6))   // the tunnel axis from the tower's west wall: west under the women's majlis north strip → south to the outlet chamber (route A)
#let air-L1 = air-route.at(0).at(0) - air-route.at(1).at(0)   // leg 1, west
#let air-L2 = air-route.at(2).at(1) - air-route.at(1).at(1)   // leg 2, south
#let air-box = (1.4, -1.3, -3.15)       // the tunnel box: outer width, top of the roof slab, underside of the floor slab (walls 0.20, floor 0.25, roof 0.20)
#let air-clear = (1.0, 1.4)             // clear width × clear height inside the tunnel
#let air-fall = 0.015                   // the floor falls 1.5 % from the tower end to the sump in the outlet chamber
#let air-invert = (-2.80, -2.90)        // the floor at the tower end and at the outlet chamber (assumed)
#let air-channel = (3.1, 6.6)           // the water channel: the last 3.5 m of the south leg (y from, y to), 0.40 wide, 0.08 deep water
#let air-chamber = (6.5, 6.6, 8.05, 8.6)   // the outlet chamber box in the courtyard, outer (x0, y0, x1, y1); walls 0.20, clear 1.15 × 1.60; floor −2.90, sump −3.30
#let air-kerb = (6.5, 8.1, 8.05, 8.6, 0.45)   // the outlet: a louvred kerb on the chamber top, (x0, y0, x1, y1, height), closable damper inside
#let air-grating = (6.7, 6.8, 7.3, 7.7)       // the floor grating / hatch in the chamber top (clear opening), ladder below it on the west wall
#let air-length = calc.abs(air-route.at(1).at(0) - air-route.at(0).at(0)) + calc.abs(air-route.at(2).at(1) - air-route.at(1).at(1))   // axis length tower → chamber

// ---------- rooms (outlines only, from the CSV) ----------
#let parse-pts(s) = s.split(";").map(t => t.trim()).filter(t => t != "").map(t => { let v = t.split(" ").filter(u => u != ""); (float(v.at(0)), float(v.at(1))) })
#let read(path) = csv(path, row-type: dictionary).filter(r => r.name != "" and not r.name.starts-with("#")).map(r => {
  let P = if r.pts.trim() != "" { parse-pts(r.pts) } else {
    let x = float(r.x); let y = float(r.y); let w = float(r.w); let d = float(r.d)
    ((x - w / 2, y - d / 2), (x + w / 2, y - d / 2), (x + w / 2, y + d / 2), (x - w / 2, y + d / 2)) }
  (name: r.name, P: P) })
#let GF = read("../data/rooms_gf.csv")
#let outline = ((0, 0), (10.051, 0), (13.311, 6.0), (13.311, 24.0), (0, 24.0))
// the columns near the route (studies/structure.typ) with their ASSUMED 1.5 × 1.5 pad footings
#let pads = (("C15", 4.25, 0), ("C16", 4.25, 3.0), ("C17", 4.25, 6.5), ("C21", 5.6, 6.5), ("C24", 8.95, 0), ("C25", 8.95, 3.0), ("C26", 8.95, 6.5), ("C30", 10.051, 0), ("C31", 11.572, 2.8), ("C18", 4.25, 13.0), ("C27", 8.95, 13.0), ("C22", 5.6, 13.0))
#let pad = 1.5

// ---------- helpers ----------
#let q(p) = (p.at(0), -p.at(1))
#let r2(v) = str(calc.round(v, digits: 2))
#let f2(v) = { let s = str(calc.round(calc.abs(v), digits: 2)); if v < 0 { "−" + s } else { "+" + s } }
#let ink = rgb("#3d4a45")
#let green = rgb("#2f6b4f")
#let red = rgb("#b5452f")
#let blue = rgb("#1f4e79")
#let orange = rgb("#c25b00")
#let water = rgb("#4f9fcf")
#let H(t) = text(9pt, weight: "bold", fill: green, t)
#let box-outline(a, b, w) = {   // the four corners of a box of width w along the segment a–b
  let dx = b.at(0) - a.at(0); let dy = b.at(1) - a.at(1); let n = calc.sqrt(dx * dx + dy * dy)
  let ux = dx / n; let uy = dy / n
  ((a.at(0) - uy * w / 2, a.at(1) + ux * w / 2), (b.at(0) - uy * w / 2, b.at(1) + ux * w / 2), (b.at(0) + uy * w / 2, b.at(1) - ux * w / 2), (a.at(0) + uy * w / 2, a.at(1) - ux * w / 2))
}

// ================= PAGE 1 · concept, route comparison, plan =================
#text(14pt, weight: "bold", fill: green)[Air system study · malqaf, tunnel, water channel · Taif / Palm House V6.2]
#h(6pt) #text(7.5pt, fill: gray)[design-development study · every size, level and performance figure ASSUMED, to be checked by the MEP and structural engineers · CSV coordinates, north up]
#v(1pt)
#block(fill: rgb("#fbe3dd"), inset: 4pt, radius: 2pt, width: 100%)[#text(7.5pt, weight: "bold", fill: red)[Nothing here is calculated: no airflow, cooling, structural or hydraulic figure. ALL CHECKS PASSED means the drawings are consistent with the project files, not that the system was sized.]]
#v(3pt)
#grid(columns: (auto, 1fr), column-gutter: 12pt,
  cetz.canvas(length: 0.6cm, {
    import cetz.draw: *
    let poly(P, ..a) = line(..P.map(q), close: true, ..a)
    let T(p, t, size: 4.4pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, t))
    for r in GF.filter(r => r.P.map(p => p.at(1)).fold(1e9, calc.min) < 14.4) { poly(r.P.map(p => (p.at(0), calc.min(p.at(1), 14.5))), fill: rgb("#f3f1ea"), stroke: 0.3pt + luma(170)) }   // cropped at y 14.5
    line(q((0, 14.5)), q((0, 0)), q((10.051, 0)), q((13.311, 6.0)), q((13.311, 14.5)), stroke: 1.2pt + ink)
    line(q((0, 14.5)), q((13.311, 14.5)), stroke: (paint: ink, dash: "dashed", thickness: 0.6pt)); T((6.6, 14.9), [the south half of the plan is not shown], size: 3.6pt, fill: luma(120))
    // the assumed pad footings and the columns
    for (id, x, y) in pads {
      rect(q((x - pad / 2, y - pad / 2)), q((x + pad / 2, y + pad / 2)), stroke: (paint: luma(120), dash: "dashed", thickness: 0.4pt))
      rect(q((x - 0.2, y - 0.2)), q((x + 0.2, y + 0.2)), fill: ink, stroke: none); T((x + 0.3, y - 0.35), id, size: 3.6pt, anchor: "west")
    }
    // the house drains of the east block (kitchen, laundry, maid bath) go straight east to the manhole: they never cross the tunnel
    for y in (1.9, 4.5, 9.8) { line(q((10.3, y)), q((14.2, y)), stroke: (paint: blue, dash: "dashed", thickness: 0.7pt), mark: (end: "stealth", fill: blue, scale: 0.4)) }
    circle(q((14.6, 5.0)), radius: 0.35, stroke: 0.7pt + blue); T((15.1, 5.0), [east manhole], size: 4pt, fill: blue, anchor: "west"); T((12.2, 4.1), [house drains → east], size: 3.8pt, fill: blue)
    // route B (rejected): under the maid bath and the laundry, then west under the kitchen north wall to the courtyard corner
    line(q((9.75, 0.75)), q((9.75, 6.5)), q((8.95, 6.5)), q((8.3, 6.5)), stroke: (paint: luma(140), dash: "dotted", thickness: 1.4pt))
    T((10.1, 4.0), [route B (rejected)], size: 3.8pt, fill: luma(110), angle: 90deg)
    // route A (chosen): the tunnel box, the base chamber, the outlet chamber
    let (w, zt, zb) = air-box
    let leg1 = box-outline(air-route.at(0), air-route.at(1), w)
    let leg2 = box-outline(air-route.at(1), air-route.at(2), w)
    poly(((air-route.at(0).at(0) + 0.3, air-route.at(0).at(1) - w / 2), (air-route.at(1).at(0) - w / 2, air-route.at(1).at(1) - w / 2), (air-route.at(2).at(0) - w / 2, air-route.at(2).at(1)), (air-route.at(2).at(0) + w / 2, air-route.at(2).at(1)), (air-route.at(1).at(0) + w / 2, air-route.at(1).at(1) + w / 2), (air-route.at(0).at(0) + 0.3, air-route.at(0).at(1) + w / 2)), fill: rgb("#f6d7b8"), stroke: 1pt + orange)
    poly(air-tower, fill: rgb("#cfe0ee"), stroke: 1pt + blue)
    let (cx0, cy0, cx1, cy1) = air-chamber
    rect(q((cx0, cy0)), q((cx1, cy1)), fill: rgb("#f6d7b8"), stroke: 1pt + orange)
    rect(q((cx0 + 0.2, cy0 + 0.2)), q((cx1 - 0.2, cy1 - 0.2)), stroke: 0.4pt + orange)
    let (gx0, gy0, gx1, gy1) = air-grating
    rect(q((gx0, gy0)), q((gx1, gy1)), fill: white, stroke: 0.5pt + ink); T((7.0, 7.25), [grating], size: 3.4pt)
    let (kx0, ky0, kx1, ky1, kh) = air-kerb
    rect(q((kx0, ky0)), q((kx1, ky1)), fill: rgb("#e6b98a"), stroke: 0.6pt + orange); T((7.27, 8.35), [outlet kerb · louvres · damper], size: 3.3pt)
    // the water channel in the last 3.5 m
    let (c0, c1) = air-channel
    rect(q((air-route.at(1).at(0) - 0.2, c0)), q((air-route.at(1).at(0) + 0.2, c1)), fill: water, stroke: none)
    // the air path
    line(q((9.75, 0.75)), q(air-route.at(1)), q((air-route.at(2).at(0), c0 - 0.3)), stroke: (paint: orange, thickness: 1pt), mark: (end: "stealth", fill: orange, scale: 0.5))
    T((8.1, 0.3), [tunnel 1.0 × 1.4 clear · top −1.30], size: 3.6pt, fill: orange)
    T((6.4, 3.6), [route A · under the women's majlis · #r2(air-length) m], size: 3.8pt, fill: orange, angle: 90deg)
    T((7.9, 4.85), [water channel\ 3.5 m], size: 3.6pt, fill: water, anchor: "west")
    T((9.77, 0.5), [tower], size: 3.8pt, fill: blue)
    T((7.27, 9.0), [outlet chamber 1.15 × 1.60 clear\ ladder · sump · cooler place], size: 3.6pt, fill: orange)
    // the NW wind at the head
    line(q((8.3, -2.6)), q((9.7, -1.3)), stroke: 1.4pt + red, mark: (end: "stealth", fill: red, scale: 0.6)); T((7.9, -2.9), [NW wind → head openings N + W], size: 4pt, fill: red, anchor: "west")
    // the courtyard floor drain: away from the chamber, at the south end
    circle(q((6.6, 12.4)), radius: 0.2, stroke: 0.6pt + blue); T((6.6, 12.9), [courtyard drain (south end)], size: 3.6pt, fill: blue)
    T((6.6, 9.75), [courtyard], size: 4.2pt, fill: luma(110)); T((6.6, 3.3), [women's majlis], size: 4.2pt, fill: luma(110)); T((11.0, 9.75), [kitchen], size: 4.2pt, fill: luma(110)); T((9.8, 4.6), [laundry], size: 3.8pt, fill: luma(110)); T((9.8, 1.9), [maid bath], size: 3.8pt, fill: luma(110))
    content(q((6.65, -3.6)), text(7pt, weight: "bold")[Plan at foundation level · the tower, the tunnel (route A), the outlet chamber · assumed pads dashed])
    line(q((0, 15)), q((5, 15)), stroke: 1pt + ink); content(q((2.5, 15.45)), text(5pt)[5 m])
    rect(q((-0.5, -4.2)), q((15.5, 15.8)), stroke: none)
  }),
  [
    #set text(6.9pt)
    #H[The idea]
    - The *malqaf* (wind tower) in the tip of the north-east cut corner catches the north-west wind above the roof, where it is strong and clean, and sends it *down the shaft* (≈ 0.88 m² clear) into an *underground tunnel* that runs through the cool ground to the courtyard. In the last metres the air passes over a *shallow water channel* (evaporative cooling and a dust trap) and enters the courtyard through a *low, closable outlet* in the north wall. Warm air leaves through the open sky. Every opening closes: dust storms, cold nights, hot afternoons.
    - *Goal:* cools well, clean and healthy, easy to clean, and does not touch the house: a separate waterproof box, no standing water, no sprays, no route under bedrooms or wet rooms.
    #v(2pt)
    #H[Route: two candidates, one chosen]
    #table(columns: (auto, 1fr, 1fr), stroke: none, inset: 2.2pt, fill: (_, y) => if calc.even(y) { rgb("#efece4") },
      [], [*A · under the women's majlis (chosen)*], [B · under the maid wing (rejected)],
      [path], [tower base → #r2(air-L1) m west under the majlis north strip → #r2(air-L2) m south on x #r2(air-route.at(1).at(0)) → outlet chamber at the courtyard's north wall; axis #r2(air-length) m from the tower wall], [tower base → south under the maid bath and the laundry (x ≈ 9.75) → west under the kitchen north wall to the courtyard corner; ≈ 8.5 m],
      [above it], [ground floor: the women's majlis only (a sitting room, no drains); first floor: the kids' room / family living. *No bedroom, no wet room.*], [maid bath and laundry (wet rooms: drains, smells, leaks), then the kitchen north wall],
      [footings crossed], [the W3 / C24 line at the tower exit (unavoidable: the tower base box becomes their foundation, A1); the women's majlis south wall ground beam at the chamber (A3). Clear of the pads C25, C26, C21 (≥ 0.15 m, with the assumed 1.5 m pads)], [the maid bath / laundry walls y 1.0, 2.8; the RC wall W5 (y 6.5) and the pad of C26 at the corner: three crossings],
      [drains], [none: the east block drains run east, away from the route], [crosses the maid bath and laundry drains that run east],
      [cleaning], [one straight leg; the chamber gives the main access from the courtyard], [two bends, longer, under wet rooms],
    )
    #v(2pt)
    #H[Levels and sizes (assumed)]
    - *Head:* shaft walls from the roof finish +#r2(air-head.at(0)) to +#r2(air-head.at(1)) (2.5 m above the roof); louvred openings on the north and west faces, sill +#r2(air-head-opening.at(0)), head +#r2(air-head-opening.at(1)); a washable insect / dust screen inside; a closable damper (motorised with a manual override, closed in dust storms and cold weather); a cap roof with a drip; an access hatch in the south face at roof level.
    - *Shaft:* the tower's RC walls, clear ≈ 0.78 × 1.3 m; steel rungs on the east wall from the head hatch to the base; the ground-floor slab is a *grating* inside the shaft (the second access hatch, A5).
    - *Base chamber:* the shaft walls continue to #f2(air-base.at(1)) as one RC box (the foundation of the tower, of C24 / C30 and the ends of W3 / W4: engineer, A1). Floor #f2(air-invert.at(0)).
    - *Tunnel:* a separate waterproof RC box, outer #r2(air-box.at(0)) m wide, top of the roof slab #f2(air-box.at(1)), underside #f2(air-box.at(2)); clear #r2(air-clear.at(0)) × #r2(air-clear.at(1)) m (a person bent over); floor falling #str(calc.round(air-fall * 100, digits: 1)) % from #f2(air-invert.at(0)) at the tower to #f2(air-invert.at(1)) at the chamber; a flexible joint with a waterstop at each end (structurally independent of the house); not insulated from the soil (ground cooling wanted), waterproofed outside, epoxy inside with coved corners.
    - *Water channel:* the last #r2(air-channel.at(1) - air-channel.at(0)) m before the chamber, 0.40 wide, 0.08 deep water (0.12 channel), stainless steel or tiled, recirculated from a 60 L reservoir in the chamber; a timer drains and dries it every day. *No sprays, no mist: rule.*
    - *Outlet chamber:* RC box in the courtyard floor against the north wall, clear 1.15 × 1.60, floor #f2(air-invert.at(1)), sump 0.4 × 0.4 × 0.4 with a small pump; grating hatch 0.6 × 0.9 and a fixed ladder; the outlet a louvred kerb 0.45 m high on the courtyard side with a damper; a place for a removable desert cooler (socket, water point, drain to the sump).
  ],
)

// ================= PAGE 2 · long section along the air path =================
#pagebreak()
#text(12pt, weight: "bold", fill: green)[Long section along the air path · tower head → shaft → base chamber → tunnel → water channel → outlet chamber → courtyard]
#h(6pt) #text(7pt, fill: gray)[unfolded along the axis (the bend at x #r2(air-route.at(1).at(0)) is straightened) · levels from the finished ground floor ±0.00 · all assumed]
#v(2pt)
#let L1 = calc.abs(air-route.at(1).at(0) - air-route.at(0).at(0))   // leg 1 (west)
#let L2 = calc.abs(air-route.at(2).at(1) - air-route.at(1).at(1))   // leg 2 (south)
#let s-tower = 0.0                       // the tower axis
#let s-exit = 0.8                         // the tower's west wall (axis to wall)
#let s-chamber = s-exit + L1 + L2         // the chamber's north wall (the tunnel enters the chamber here)
#let ch-len = air-chamber.at(3) - air-chamber.at(1)
#grid(columns: (auto, 1fr), column-gutter: 12pt,
  cetz.canvas(length: 0.9cm, {
    import cetz.draw: *
    let T(p, t, size: 4.4pt, fill: ink, anchor: "center", angle: 0deg) = content(p, anchor: anchor, angle: angle, text(size, fill: fill, t))
    let R(x0, z0, x1, z1, ..a) = rect((x0, z0), (x1, z1), ..a)
    let (w, zt, zb) = air-box
    let (cw, ch) = air-clear
    // ground, the house slabs and levels
    line((-2.2, 0), (s-chamber + ch-len + 2.5, 0), stroke: 0.8pt + ink)
    for (z, l) in ((0, [±0.00]), (3.6, [+3.60]), (7.2, [+7.20]), (air-head.at(1), [+#r2(air-head.at(1))]), (air-box.at(1), [#f2(air-box.at(1))]), (air-invert.at(1), [#f2(air-invert.at(1))]), (air-base.at(1), [#f2(air-base.at(1))])) {
      line((-2.1, z), (-1.5, z), stroke: 0.4pt + gray); T((-2.2, z), l, size: 4pt, fill: gray, anchor: "east")
    }
    R(-1.5, -0.28, s-chamber + ch-len + 2.3, -0.08, fill: luma(150), stroke: none)         // ground slab
    R(-1.5, 3.32, 1.2, 3.52, fill: luma(150), stroke: none); R(-1.5, 7.0, 1.2, 7.2, fill: luma(150), stroke: none); R(-1.5, 7.2, 1.2, 7.3, fill: luma(200), stroke: none)   // FF slab, roof slab, roof finish (near the tower)
    T((-0.9, 1.6), [women's majlis], size: 4pt); T((-0.9, 5.2), [kids' room], size: 4pt); T((-0.9, 7.6), [roof], size: 4pt)
    // the tower: shaft walls (west wall on the house side, east wall outside), from the base to the head
    R(-0.2, air-base.at(1), 0.0, air-head.at(1), fill: luma(90), stroke: none)     // west wall (x 8.95, W3)
    R(1.0, air-base.at(1), 1.2, air-head.at(1), fill: luma(90), stroke: none)      // east side (the cut wall)
    R(-0.2, air-base.at(1), 1.2, air-base.at(1) + 0.25, fill: luma(90), stroke: none)   // base slab
    R(0.0, air-head.at(1), 1.2, air-head.at(1) + 0.15, fill: luma(90), stroke: none); R(-0.45, air-head.at(1) + 0.15, 1.45, air-head.at(1) + 0.3, fill: luma(120), stroke: none)   // cap with a drip
    T((0.5, air-head.at(1) + 0.65), [cap roof · drip], size: 3.8pt)
    // head openings (the north face is in the plane of this section: shown as the louvre band), screen and damper
    R(1.0, air-head-opening.at(0), 1.2, air-head-opening.at(1), fill: rgb("#cfe0ee"), stroke: 0.4pt + blue)
    for i in range(6) { line((1.0, air-head-opening.at(0) + 0.1 + i * 0.2), (1.2, air-head-opening.at(0) + 0.2 + i * 0.2), stroke: 0.4pt + blue) }
    line((0.85, air-head-opening.at(0)), (0.85, air-head-opening.at(1)), stroke: (paint: blue, dash: "dotted", thickness: 0.8pt)); T((0.72, air-head-opening.at(1) + 0.25), [washable screen], size: 3.6pt, fill: blue, anchor: "east")
    line((0.1, 8.0), (0.9, 8.0), stroke: 1.6pt + red); T((-0.05, 8.0), [damper (motorised, manual override)], size: 3.6pt, fill: red, anchor: "east")
    line((1.9, 8.8), (1.3, 8.8), stroke: 1.2pt + red, mark: (end: "stealth", fill: red, scale: 0.6)); T((2.0, 8.8), [NW wind], size: 4pt, fill: red, anchor: "west")
    T((0.5, 9.0), [louvres N + W], size: 3.6pt, fill: blue)
    // roof access hatch in the south face (beyond): drawn as a dashed door at roof level
    R(0.15, 7.3, 0.75, 8.5, stroke: (paint: ink, dash: "dashed", thickness: 0.5pt)); T((0.45, 7.95), [hatch\ (S face)], size: 3.3pt)
    // rungs on the east wall from the head hatch to the base
    for i in range(int((air-head.at(0) - air-base.at(1) + 1.0) / 0.3)) { line((0.75, air-base.at(1) + 0.25 + 0.3 + i * 0.3), (0.95, air-base.at(1) + 0.25 + 0.3 + i * 0.3), stroke: 0.6pt + ink) }
    T((1.35, 3.0), [rungs to the base], size: 3.6pt, anchor: "west", angle: 90deg)
    // the ground-floor grating inside the shaft (second hatch)
    line((0.0, -0.08), (1.0, -0.08), stroke: (paint: ink, dash: "dashed", thickness: 0.8pt)); T((1.3, -0.5), [grating in the shaft floor = hatch 2], size: 3.4pt, anchor: "west")
    // the air going down
    line((0.5, 7.8), (0.5, air-invert.at(0) + 0.8), stroke: 1pt + orange, mark: (end: "stealth", fill: orange, scale: 0.6))
    // the tunnel box: roof slab, floor slab with the fall
    let x0 = s-exit; let x1 = s-chamber
    let z-floor(x) = air-invert.at(0) - (x - x0) / (x1 - x0) * (air-invert.at(0) - air-invert.at(1))
    R(x0, zt - 0.2, x1, zt, fill: luma(90), stroke: none)                                   // roof slab
    line((x0, z-floor(x0)), (x1, z-floor(x1)), (x1, z-floor(x1) - 0.25), (x0, z-floor(x0) - 0.25), close: true, fill: luma(90), stroke: none)   // floor slab
    line((x0, zt - 0.2), (x0, z-floor(x0)), stroke: (paint: red, thickness: 1.2pt, dash: "dashed")); T((x0 + 0.1, zt - 0.5), [joint + waterstop], size: 3.2pt, anchor: "west")
    line((x1, zt - 0.2), (x1, z-floor(x1)), stroke: (paint: red, thickness: 1.2pt, dash: "dashed"))
    T((x0 + (x1 - x0) / 2, zt - 0.45), [tunnel · clear #r2(cw) wide × #r2(ch) high · floor falls #str(calc.round(air-fall * 100, digits: 1)) % → sump], size: 4pt, fill: orange)
    line((x0 + 0.4, zt - 0.9), (x1 - 0.4, zt - 0.9), stroke: 1pt + orange, mark: (end: "stealth", fill: orange, scale: 0.6))
    // the water channel in the last 3.5 m (in the floor)
    let xc = x1 - (air-channel.at(1) - air-channel.at(0))
    R(xc, z-floor(xc) - 0.12, x1, z-floor(x1), fill: white, stroke: 0.4pt + water); R(xc, z-floor(xc) - 0.12, x1, z-floor(x1) - 0.04, fill: water, stroke: none)
    T((xc + 1.75, z-floor(xc) - 0.55), [water channel #r2(air-channel.at(1) - air-channel.at(0)) m · 0.08 deep · drained daily], size: 3.6pt, fill: water)
    line((xc, zt - 0.2), (xc, z-floor(xc)), stroke: (paint: water, dash: "dotted", thickness: 0.5pt))
    // membrane note
    T((x0 + 1.5, zb - 0.45), [waterproof membrane + protection board outside · epoxy, coved corners inside · not insulated (ground cooling)], size: 3.4pt, fill: luma(110))
    // the outlet chamber: walls, floor, sump, ladder, grating, kerb outlet
    let c0 = x1; let c1 = x1 + ch-len
    R(c0 - 0.2, air-base.at(1), c0, air-invert.at(1) + 0.0, fill: luma(90), stroke: none)   // north wall below the tunnel mouth
    R(c1 - 0.2, air-base.at(1), c1, -0.08, fill: luma(90), stroke: none)                       // south wall
    R(c0 - 0.2, air-base.at(1), c1, air-invert.at(1) - 0.25 + 0.25, fill: luma(90), stroke: none)   // floor slab (to the invert)
    R(c0 + 0.1, air-invert.at(1) - 0.4, c0 + 0.5, air-invert.at(1), fill: white, stroke: 0.5pt + ink); T((c0 + 0.3, air-invert.at(1) - 0.6), [sump + pump], size: 3.3pt)
    R(c0, -0.28, c1 - 0.2, -0.08, fill: luma(150), stroke: none)   // chamber top = courtyard slab
    let (gx0, gy0, gx1, gy1) = air-grating
    R(c0 + (gy0 - air-chamber.at(1)), -0.28, c0 + (gy1 - air-chamber.at(1)), -0.08, fill: white, stroke: 0.6pt + ink); T((c0 + 0.65, 0.35), [grating hatch], size: 3.4pt)
    for i in range(int((-0.28 - air-invert.at(1)) / 0.3)) { line((c0 + 0.05, air-invert.at(1) + 0.3 + i * 0.3), (c0 + 0.25, air-invert.at(1) + 0.3 + i * 0.3), stroke: 0.6pt + ink) }
    T((c0 + 0.45, air-invert.at(1) + 1.3), [ladder], size: 3.4pt, anchor: "west", angle: 90deg)
    let (kx0, ky0, kx1, ky1, kh) = air-kerb
    R(c0 + (ky0 - air-chamber.at(1)), -0.08, c1, kh, fill: rgb("#e6b98a"), stroke: 0.6pt + orange)
    for i in range(3) { line((c1 - 0.05, 0.08 + i * 0.12), (c1 + 0.12, 0.14 + i * 0.12), stroke: 0.5pt + orange) }
    T((c0 + 1.1, kh + 0.35), [outlet kerb 0.45 · louvres · damper], size: 3.4pt, fill: orange)
    line((c0 + 1.0, air-invert.at(1) + 0.6), (c0 + 1.3, -0.08), (c1 + 0.9, 0.25), stroke: 1pt + orange, mark: (end: "stealth", fill: orange, scale: 0.6))
    R(c1 - 0.9, air-invert.at(1), c1 - 0.3, air-invert.at(1) + 0.9, stroke: (paint: ink, dash: "dashed", thickness: 0.5pt)); T((c1 - 0.6, air-invert.at(1) + 1.15), [cooler place\ socket · water · drain], size: 3.2pt)
    R(c0 + 0.1, air-invert.at(1) + 1.6, c0 + 0.6, air-invert.at(1) + 2.0, stroke: 0.4pt + water); T((c0 + 0.35, air-invert.at(1) + 2.25), [reservoir 60 L], size: 3.2pt, fill: water)
    // the courtyard beyond
    T((c1 + 1.3, 1.0), [courtyard\ (open sky)], size: 4.2pt, fill: blue); T((c0 + 0.9, air-invert.at(1) + 0.35), [chamber 1.15 × 1.60 clear], size: 3.6pt, fill: orange)
    // the women's majlis / courtyard wall line stands over the chamber's north wall (ground beam bridging the tunnel mouth: A3)
    R(c0 - 0.12, -0.08, c0 + 0.12, 3.32, fill: luma(200), stroke: 0.3pt + luma(120)); T((c0, 3.6), [courtyard N wall\ (ground beam over the\ tunnel mouth: A3)], size: 3.2pt)
    T((s-chamber / 2 + 0.4, -3.9), [S], size: 4pt); T((-1.9, -3.9), [N · E], size: 4pt)
  }),
  [
    #set text(6.9pt)
    #H[How it works (qualitative only)]
    - *Catch:* the head stands 2.5 m above the roof in the undisturbed north-west wind. Openings on the north and west faces; the south and the cut (north-east) faces are closed, so the head does not take air from the leeward side. Louvres keep rain out, the screen keeps insects and coarse dust out, the damper closes the system.
    - *Cool:* the air falls down the shaft (the shaft and the tunnel walls are in contact with the ground, which stays cooler than the afternoon air), runs through the tunnel, then passes slowly over the water channel: some evaporation, and the wet surfaces trap fine dust. *Not calculated:* air speed, temperature drop and the share of wind-driven versus stack-driven flow are for the MEP engineer.
    - *Deliver:* the air enters the courtyard low, through the louvred kerb at the north wall; the courtyard is enclosed and shaded, so the cool air pools there and reaches the rooms around it through their openings; warm air leaves through the open sky.
    - *Operate:* open in the evening, the night and the early morning; closed in hot afternoons, dust storms and cold weather. The channel runs only while the system is open and is *drained and dried every day.*
    #v(2pt)
    #H[Health rules (stated, not optional)]
    - *No sprays, no mist, no fogging:* warm, stagnant or sprayed water grows Legionella and other bacteria. The channel is an open, shallow, moving surface; the air passes above it, it is never atomised.
    - *No standing water:* the channel drains daily, the tunnel floor falls to the sump, the sump is pumped empty; make-up water through a float valve with a backflow preventer.
    - *Smooth, washable surfaces:* epoxy or stainless steel, coved corners, no ledges; the tunnel is dark, which limits algae; a hose point in the chamber.
    - *Separate from the house:* a waterproof box with joints; no house drain crosses it; the courtyard outlet closes.
    #v(2pt)
    #H[Levels along the path]
    #table(columns: (1.1fr, 1fr), stroke: none, inset: 2pt, fill: (_, y) => if calc.even(y) { rgb("#efece4") },
      [head top], [+#r2(air-head.at(1))], [head openings], [+#r2(air-head-opening.at(0)) … +#r2(air-head-opening.at(1))], [roof finish / roof slab], [+7.30 / +7.20],
      [ground floor finished / grating in the shaft], [±0.00 / −0.08], [tunnel roof top / underside], [#f2(air-box.at(1)) / #f2(air-box.at(1) - 0.2)],
      [tunnel floor at the tower / at the chamber], [#f2(air-invert.at(0)) / #f2(air-invert.at(1))], [box underside], [#f2(air-box.at(2))], [sump], [#f2(air-invert.at(1) - 0.4)],
      [assumed pad footing underside], [−1.50 (the tunnel top is above it: only at the tower exit and the chamber do footings and box meet, A1 / A3)], [assumed tie beams], [−0.28 … −0.90 (0.40 m above the tunnel roof)],
    )
  ],
)

// ================= PAGE 3 · cross sections and the chamber =================
#pagebreak()
#text(12pt, weight: "bold", fill: green)[Cross sections · the tunnel, the water channel, the outlet chamber and its access]
#h(6pt) #text(7pt, fill: gray)[all sizes assumed · waterproofing, joints and the box design by the structural engineer; pumps, valves, timer, cooler points by the MEP engineer]
#v(2pt)
#grid(columns: (auto, auto, auto, 1fr), column-gutter: 14pt,
  cetz.canvas(length: 1.5cm, {
    import cetz.draw: *
    let T(p, t, size: 4.4pt, fill: ink, anchor: "center", angle: 0deg) = content(p, anchor: anchor, angle: angle, text(size, fill: fill, t))
    let (w, zt, zb) = air-box; let (cw, ch) = air-clear
    let z0 = zb; let zi = zb + 0.25; let zc = zi + ch
    rect((-w / 2, z0), (w / 2, zt), fill: luma(90), stroke: none)
    rect((-cw / 2, zi), (cw / 2, zc), fill: white, stroke: none)
    // coved corners, epoxy
    for s in (-1, 1) { arc((s * cw / 2, zi + 0.08), start: if s < 0 { 0deg } else { 180deg }, stop: if s < 0 { -90deg } else { 270deg }, radius: 0.08, fill: luma(90), stroke: none) }
    // membrane outside
    rect((-w / 2 - 0.03, z0 - 0.03), (w / 2 + 0.03, zt + 0.03), stroke: (paint: red, thickness: 0.8pt))
    T((0, zt + 0.22), [membrane + protection board], size: 3.6pt, fill: red)
    // the dry section (no channel)
    T((0, zi + ch / 2 + 0.3), [clear #r2(cw) × #r2(ch)], size: 4.4pt, fill: orange)
    content((0, zi + 0.55), text(3.6pt, fill: luma(110))[a person bent over\ floor falls 1.5 %])
    // lighting conduit and a cable tray in the top corner
    circle((cw / 2 - 0.08, zc - 0.08), radius: 0.03, stroke: 0.5pt + ink); T((cw / 2 - 0.12, zc - 0.2), [light · conduit], size: 3.2pt, anchor: "east")
    // dimensions
    line((-w / 2, z0 - 0.25), (w / 2, z0 - 0.25), stroke: 0.4pt + ink, mark: (start: "|", end: "|", scale: 0.4)); T((0, z0 - 0.4), [#r2(w) outer · walls 0.20 · floor 0.25 · roof 0.20], size: 3.6pt)
    line((w / 2 + 0.3, z0), (w / 2 + 0.3, zt), stroke: 0.4pt + ink, mark: (start: "|", end: "|", scale: 0.4)); T((w / 2 + 0.45, (z0 + zt) / 2), [#r2(zt - z0)], size: 3.6pt, angle: 90deg)
    for (z, l) in ((zt, [#f2(zt)]), (zc, [#f2(zc)]), (zi, [#f2(zi)]), (z0, [#f2(z0)])) { T((-w / 2 - 0.1, z), l, size: 3.4pt, fill: gray, anchor: "east") }
    content((0, zt + 0.5), text(6pt, weight: "bold", fill: green)[Tunnel · dry section])
  }),
  cetz.canvas(length: 1.5cm, {
    import cetz.draw: *
    let T(p, t, size: 4.4pt, fill: ink, anchor: "center", angle: 0deg) = content(p, anchor: anchor, angle: angle, text(size, fill: fill, t))
    let (w, zt, zb) = air-box; let (cw, ch) = air-clear
    let z0 = zb; let zi = zb + 0.25; let zc = zi + ch
    rect((-w / 2, z0), (w / 2, zt), fill: luma(90), stroke: none)
    rect((-cw / 2, zi), (cw / 2, zc), fill: white, stroke: none)
    // the channel: 0.40 wide, 0.12 deep, water 0.08; dry walkways 0.30 each side
    rect((-0.2, zi - 0.12), (0.2, zi), fill: white, stroke: 0.6pt + water); rect((-0.2, zi - 0.12), (0.2, zi - 0.04), fill: water, stroke: none)
    T((0, zi - 0.3), [channel 0.40 × 0.12 · water 0.08 · stainless or tiled, rounded], size: 3.4pt, fill: water)
    T((-0.35, zi + 0.12), [walkway 0.30], size: 3.2pt); T((0.35, zi + 0.12), [walkway 0.30], size: 3.2pt)
    // air over the water
    line((-0.3, zi + 0.6), (0.3, zi + 0.6), stroke: 1pt + orange, mark: (end: "stealth", fill: orange, scale: 0.6)); T((0, zi + 0.8), [air passes slowly over the water\ (no spray, no mist)], size: 3.6pt, fill: orange)
    // supply, overflow, drain
    line((cw / 2 - 0.05, zc - 0.3), (0.25, zi + 0.05), stroke: 0.6pt + water); T((cw / 2 + 0.05, zc - 0.3), [feed from the\ reservoir pump], size: 3.2pt, fill: water, anchor: "west")
    line((-0.2, zi - 0.1), (-cw / 2 + 0.05, zi - 0.1), stroke: 0.6pt + water); T((-cw / 2 - 0.05, zi - 0.1), [overflow + timed\ drain → sump], size: 3.2pt, fill: water, anchor: "east")
    rect((-w / 2 - 0.03, z0 - 0.03), (w / 2 + 0.03, zt + 0.03), stroke: (paint: red, thickness: 0.8pt))
    content((0, zt + 0.5), text(6pt, weight: "bold", fill: green)[Tunnel · the last 3.5 m with the water channel])
    T((0, z0 - 0.4), [make-up water: float valve + backflow preventer (MEP)], size: 3.4pt, fill: water)
  }),
  cetz.canvas(length: 1.25cm, {
    import cetz.draw: *
    let T(p, t, size: 4.4pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, t))
    let (x0, y0, x1, y1) = air-chamber
    // plan of the chamber (looking down): walls, grating, ladder, sump, cooler place, reservoir, the tunnel mouth, the kerb
    rect(q((x0, y0)), q((x1, y1)), fill: luma(90), stroke: none)
    rect(q((x0 + 0.2, y0 + 0.2)), q((x1 - 0.2, y1 - 0.2)), fill: white, stroke: none)
    let (w, zt, zb) = air-box
    rect(q((air-route.at(2).at(0) - air-clear.at(0) / 2, y0 - 0.5)), q((air-route.at(2).at(0) + air-clear.at(0) / 2, y0 + 0.2)), fill: rgb("#f6d7b8"), stroke: 0.4pt + orange); T((air-route.at(2).at(0), y0 - 0.25), [tunnel mouth 1.0], size: 3.4pt, fill: orange)
    let (gx0, gy0, gx1, gy1) = air-grating
    rect(q((gx0, gy0)), q((gx1, gy1)), fill: white, stroke: 0.8pt + ink); for i in range(5) { line(q((gx0, gy0 + 0.15 + i * 0.18)), q((gx1, gy0 + 0.15 + i * 0.18)), stroke: 0.4pt + ink) }
    T((7.0, 7.95), [grating hatch\ 0.6 × 0.9], size: 3.3pt)
    for i in range(6) { line(q((x0 + 0.2, y0 + 0.3 + i * 0.25)), q((x0 + 0.35, y0 + 0.3 + i * 0.25)), stroke: 0.6pt + ink) }; T((x0 + 0.5, y0 + 1.0), [ladder on\ the W wall], size: 3.2pt, anchor: "west")
    rect(q((x1 - 0.65, y0 + 0.25)), q((x1 - 0.25, y0 + 0.65)), fill: white, stroke: 0.5pt + ink); T((x1 - 0.45, y0 + 0.85), [sump], size: 3.2pt)
    rect(q((x1 - 0.85, y1 - 0.85)), q((x1 - 0.25, y1 - 0.25)), stroke: (paint: ink, dash: "dashed", thickness: 0.5pt)); T((x1 - 0.55, y1 - 0.55), [cooler\ place], size: 3.2pt)
    rect(q((x1 - 0.65, y0 + 0.9)), q((x1 - 0.25, y0 + 1.2)), stroke: 0.4pt + water); T((x1 - 0.45, y0 + 1.05), [reservoir], size: 3pt, fill: water)
    let (kx0, ky0, kx1, ky1, kh) = air-kerb
    rect(q((kx0, ky0)), q((kx1, ky1)), fill: none, stroke: (paint: orange, thickness: 0.8pt, dash: "dashed")); T((7.27, ky1 + 0.25), [louvred kerb on the top slab, 0.45 high, towards the courtyard · damper], size: 3.2pt, fill: orange)
    T((7.27, y1 - 0.15), [S], size: 3.4pt, fill: luma(120))
    content(q((7.27, y0 - 0.95)), text(6pt, weight: "bold", fill: green)[Outlet chamber · plan · 1.15 × 1.60 clear])
    line(q((x0, y1 + 0.75)), q((x1, y1 + 0.75)), stroke: 0.4pt + ink, mark: (start: "|", end: "|", scale: 0.4)); T((7.27, y1 + 0.95), [#r2(x1 - x0) outer], size: 3.4pt)
    T((x0 - 0.25, 7.6), [C21 pad\ 0.15 m\ west], size: 3pt, fill: luma(110), anchor: "east"); T((x1 + 0.25, 7.6), [C26 pad\ 0.15 m\ east], size: 3pt, fill: luma(110), anchor: "west")
    rect(q((x0 - 0.9, y0 - 1.3)), q((x1 + 0.9, y1 + 1.2)), stroke: none)
  }),
  [
    #set text(6.9pt)
    #H[Outlet chamber and access]
    - *Where:* in the courtyard floor against its north wall, x #r2(air-chamber.at(0))–#r2(air-chamber.at(2)) (outer), between the assumed pads of C21 and C26 (0.15 m to each), east of the first-floor projection line (x 5.6) so it stands under the open sky; the colonnade column C21 (5.6, 6.5) is 0.9 m west of it; the courtyard floor drain goes to the south end, away from it.
    - *Access:* a grating hatch 0.6 × 0.9 in the top slab (lockable), a fixed ladder on the west wall down 2.8 m to the chamber floor (3–4 steps cannot reach #f2(air-invert.at(1)); a ladder does); from the chamber a person enters the tunnel mouth (1.0 × 1.4) and walks bent over to the tower base (the water channel has 0.30 m dry walkways on both sides). The second access is the grating in the shaft floor, reached by the rungs from the roof hatch.
    - *Outlet:* a louvred kerb 0.45 m high on the courtyard side of the top slab, with an insect screen and a closable damper (the "low closable opening" of the concept). It stands in front of the east end of the women's majlis glass (x 5.1–8.1): acceptable, or the glass is shortened to x 5.1–6.4 (A8).
    - *Services in the chamber:* the sump 0.4 × 0.4 × 0.4 with a submersible pump (discharge to the east manhole through a 50 mm pumped line laid back along the tunnel and out at the tower base, A7); the 60 L reservoir with the circulation pump and the timer valve for the channel; make-up water (float valve, backflow preventer); a hose point; a weatherproof socket and a light; the cooler place (0.6 × 0.6) with socket, water and a drain to the sump.
    #v(2pt)
    #H[Tunnel box (structure, assumed)]
    - RC box, walls 0.20, floor 0.25, roof 0.20; outer #r2(air-box.at(0)) wide, top #f2(air-box.at(1)), underside #f2(air-box.at(2)); *structurally independent*: a flexible joint with a waterstop where it meets the tower base box and the chamber; movement joints with waterstops if the engineer wants more; waterproof membrane and protection board outside; the bedding and the backfill as the soil report says (X9).
    - It passes 0.40 m under the assumed ground tie beams and keeps clear of the assumed pads, except at the two ends (A1, A3).
  ],
)

// ================= PAGE 4 · maintenance, performance, coordination, open items =================
#pagebreak()
#text(12pt, weight: "bold", fill: green)[Maintenance, performance note, coordination and open items]
#v(2pt)
#grid(columns: (1.15fr, 1fr), column-gutter: 14pt,
  [
    #H[Maintenance table (what · how often · how to reach it)]
    #table(columns: (1fr, 1.8fr, 1fr, 1.1fr), stroke: none, inset: 2.4pt, fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#efece4") },
      ..([Item], [What to do], [How often], [How to reach it]).map(c => text(7pt, weight: "bold", fill: green, c)),
      [head louvres + insect / dust screen], [brush and wash the screen; clear the louvres; check the drip], [monthly in the dust season, else every 3 months], [from the roof, through the hatch in the head's south face],
      [damper (head)], [check the motor and the manual override, grease the hinges, test closing], [every 6 months and before the dust season], [from the roof hatch],
      [shaft walls and rungs], [brush the walls, check the rungs and the lighting], [yearly], [rungs from the head hatch down to the base],
      [shaft-floor grating (hatch 2)], [lift and clean, check the lock], [yearly], [from the shaft],
      [base chamber and tunnel floor], [sweep and hose down; the water runs with the fall to the sump], [every 3 months], [from the outlet chamber (ladder), walking bent over; or from the shaft],
      [water channel], [rinse and wipe; check the feed and the overflow; the timer drains and dries it every day], [weekly in use; daily automatic drain], [from the chamber end of the tunnel],
      [reservoir, circulation pump, float valve, backflow preventer], [empty and clean the reservoir; check the pump and the valves], [monthly in use; before the season], [in the chamber],
      [sump and pump], [clean the sump, test the pump and the float switch, flush the pumped line], [every 3 months], [in the chamber],
      [outlet kerb: louvres, screen, damper], [wash the screen, clear the louvres, test the damper], [monthly in use], [from the courtyard, standing],
      [grating hatch and ladder], [check the lock, the hinges and the ladder fixings], [yearly], [from the courtyard],
      [removable desert cooler (optional)], [install for the season, clean the pads and the tray, remove and store], [start / end of the season; pads monthly], [in the chamber, through the hatch],
      [joints and waterproofing], [look for damp, cracks, salts on the walls; seepage after rain], [after every heavy rain; yearly], [walk the tunnel],
    )
    #v(4pt)
    #H[Expected performance (qualitative only; nothing calculated)]
    - On nights and mornings with a north-west breeze the courtyard receives air that has passed through the ground and over the water: cooler than the street air, cleaner than ground-level air, and low, where people sit. The effect depends on the wind, the ground temperature and the humidity; the MEP engineer estimates the flow and the temperature drop and may add a low-energy fan in the shaft if the wind alone is too weak.
    - Without wind the tower works weakly as a stack (cool, heavy air sinks); the optional desert cooler in the chamber gives a forced, cooled flow on still evenings.
    - It is not an air-conditioning system: it cools the courtyard and the rooms around it when they are open to it, and it needs the daily routine of opening, closing and draining.
  ],
  [
    #H[Coordination]
    - *Structure (studies/structure.typ):* the tower's RC walls are part of the east stiff box (W3 / W4 end); the base box replaces the pad of C24 and carries the W3 / W4 ends (A1); the tunnel keeps clear of the assumed pads of C25, C26 and C21 and passes 0.40 m under the tie beams; the women's majlis south wall sits on a ground beam that bridges the tunnel mouth at the chamber (A3); the chamber is a box in the courtyard slab between the C21 and C26 pads.
    - *Plumbing:* the kitchen, laundry and maid-bath drains run east to the east manhole and never cross the tunnel; the sump's pumped line runs back along the tunnel and out east at the tower base (A7); the courtyard floor drain at the south end of the courtyard (A6).
    - *Courtyard design:* the chamber and its kerb stand against the north wall, east of the projection line, under the open sky; the colonnade column C21 stays 0.9 m away; the kerb in front of the glass's east end (A8).
    - *Electrical:* damper motor and lighting in the head and the shaft, light and sockets in the chamber, the two pumps, the timer valve: one dedicated circuit with an RCD (MEP).
    #v(3pt)
    #H[Open items for the engineers]
    #table(columns: (auto, auto, 1fr), stroke: none, inset: 2.2pt, fill: (_, y) => if calc.even(y) { rgb("#efece4") },
      [*A1*], [structure], [The tower base box (#f2(air-base.at(0)) … #f2(air-base.at(1))) as the foundation of the tower, of C24 / C30 and of the ends of W3 / W4; the tunnel leaves it through the W3 line: design the box and the crossing.],
      [*A2*], [structure], [The tunnel box: section, reinforcement, joints with waterstops, bedding, backfill, uplift / groundwater; soil report first (X9).],
      [*A3*], [structure], [The women's majlis south wall (y 6.5) over the tunnel mouth: a ground beam bridging the box between the C21 and C26 pads, independent of the chamber.],
      [*A4*], [MEP], [Airflow: expected flow and temperature drop (wind-driven and stack); whether a low-energy fan is needed; the head opening sizes; the damper control (wind, dust, temperature sensors or manual).],
      [*A5*], [MEP / safety], [The shaft as the second access: rungs, fall protection, lighting; a confined-space rule for the tunnel (two people, ventilation open while cleaning).],
      [*A6*], [MEP], [The courtyard floor drain at the south end, away from the chamber; rainwater falling into the kerb outlet: a drained tray inside the kerb.],
      [*A7*], [MEP], [The sump's pumped line to the east manhole (50 mm, along the tunnel, out at the tower base, under the maid bath, shallow); or a gravity drain if the manhole invert allows.],
      [*A8*], [owner / design], [The outlet kerb in front of the east end of the women's majlis glass (x 5.1–8.1): accept, or shorten the glass to x 5.1–6.4.],
      [*A9*], [MEP], [Water quality: make-up through a float valve and a backflow preventer; the daily drain-and-dry cycle; a monthly reservoir clean; no sprays or mist (rule).],
      [*A10*], [structure / 3D], [The roof and first-floor openings for the shaft (framed by B15 / R9), the head above the roof (2.5 m, wind load), the cap and the hatch.],
    )
    #v(4pt)
    #text(6.5pt, fill: gray)[Sizes assumed: head 2.5 m above the roof, openings 0.8 wide × 1.2 high on the north and west faces; shaft ≈ 0.78 × 1.3 clear; tunnel clear 1.0 × 1.4 in a 1.4 m box, top −1.30, fall 1.5 %; channel 0.40 × 0.12, water 0.08, 3.5 m; chamber 1.15 × 1.60 clear, floor −2.90, sump −3.30; kerb 0.45; pads 1.5 × 1.5 with underside −1.50, tie beams to −0.90. Nothing here replaces the MEP or structural design.]
    #v(3pt)
    #text(8pt, weight: "bold", fill: green)[✓ Air system study · route A under the women's majlis · tunnel axis #r2(air-length) m · water channel #r2(air-channel.at(1) - air-channel.at(0)) m · 10 open items for the engineers]
  ],
)

// ff_gym_L.typ · Taif / Palm House · FIRST FLOOR · VARIANT STUDY: an L-shaped gym (compile THIS file) · 24 Oct 2026 · branch v5-gym-L
// Built on V5.0 (tag v5.0): the main files (data/rooms_ff.csv, studies/ff_suite.typ, design_ff.typ) are NOT changed until the owner approves.
// Owner's decision: the gym becomes an L. Long arm along the south facade as now; short arm turns north at the east end and runs up to the
// suite bedroom's south wall, holding ONLY a treadmill (0.9 × 2.0 m, ≥ 0.5 m clear behind, ≥ 0.3 m each side).
// Local coordinates = the first-floor CSV coordinates (metres, x east, y SOUTH, wall centre lines). Stand-alone: all data is in this file.
#import "@preview/cetz:0.4.2"
#set page(paper: "a4", flipped: true, margin: 10mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial"), size: 7.2pt)

#let rect-pts(x0, y0, x1, y1) = ((x0, y0), (x1, y0), (x1, y1), (x0, y1))

// ---------- V5.0 as it is (data/rooms_ff.csv and studies/ff_suite.typ, tag v5.0) ----------
#let v50 = (
  route: rect-pts(4.25, 19.25, 5.6, 21.25),           // F13 Gym route
  office: rect-pts(0, 19.25, 4.25, 24.0),             // F14 Owner's office
  gym: rect-pts(4.25, 21.25, 13.311, 24.0),           // F15 Gym
  court: rect-pts(5.6, 19.25, 13.311, 21.25),         // F16 Suite court (open to the sky)
  bedroom: ((8.95, 11.9), (10.3, 11.9), (10.3, 13.9), (13.311, 13.9), (13.311, 19.25), (8.95, 19.25)),   // F21 Suite bedroom
)

// ---------- The treadmill and the short arm ----------
#let outer-half = 0.125     // ½ of the 250 mm outer wall (east, x 13.311)
#let inner-half = 0.1       // ½ of a 200 mm wall (the arm's west wall to the court, the bedroom's south wall)
#let tm = (w: 0.9, l: 2.0)  // treadmill
#let side = 0.3             // clear each side (owner's minimum)
#let behind = 0.5           // clear behind (owner's minimum)
#let front = 0.1            // gap between the treadmill's front and the bedroom wall: no rigid contact (acoustics)
#let east = 13.311
#let arm-clear-w = tm.w + 2 * side                        // 1.5 m
#let arm-x0 = east - outer-half - arm-clear-w - inner-half // west wall axis of the arm
#let arm-w = east - arm-x0                                // on axes
#let y-bed = 19.25          // the suite bedroom's south wall (axis) = the court's north edge
#let y-gym = 21.25          // the long arm's north wall (axis) = the court's south edge
#let arm-l = y-gym - y-bed  // on axes: the court is 2.0 m deep, the arm cannot be longer without entering the bedroom
#let tm-y0 = y-bed + inner-half + front
#let treadmill = rect-pts(arm-x0 + inner-half + side, tm-y0, arm-x0 + inner-half + side + tm.w, tm-y0 + tm.l)   // faces north, the user steps off south into the long arm
#let need-l = front + tm.l + behind                      // clear length the treadmill needs from the bedroom wall face
#let rear-min = rect-pts(treadmill.at(0).at(0), tm-y0 + tm.l, treadmill.at(1).at(0), tm-y0 + tm.l + behind)
#let rear-astm = rect-pts(treadmill.at(0).at(0), tm-y0 + tm.l, treadmill.at(1).at(0), tm-y0 + tm.l + 2.0)   // ASTM F2115 / EN 957-6: 2.0 m × the belt width behind

// ---------- L variant ----------
#let L = (
  route: v50.route,
  office: v50.office,
  gym: ((4.25, y-gym), (arm-x0, y-gym), (arm-x0, y-bed), (east, y-bed), (east, 24.0), (4.25, 24.0)),
  court: rect-pts(5.6, y-bed, arm-x0, y-gym),
  bedroom: v50.bedroom,
)
#let long-arm = rect-pts(4.25, y-gym, east, 24.0)
#let short-arm = rect-pts(arm-x0, y-bed, east, y-gym)

// ---------- Context (both plans) ----------
#let void = rect-pts(5.6, 13.0, 8.95, 19.25)              // double-height living (void)
#let gallery = rect-pts(4.25, 13.0, 5.6, 19.25)
#let bed3 = rect-pts(0, 16.1, 4.25, 19.25)
#let clerestory = (((6.0, 19.25), (7.0, 19.25)), ((7.6, 19.25), (8.6, 19.25)))
#let bed-door = ((9.3, 19.25), (10.7, 19.25))            // suite bedroom → court, sliding
#let gym-door = ((4.4, 21.25), (5.45, 21.25))            // gym route → gym, sliding
#let office-door = ((4.25, 19.4), (4.25, 20.45))
#let windows-v50 = (((4.5, 24), (13.0, 24)), ((5.9, 21.25), (8.6, 21.25)), ((13.311, 15.0), (13.311, 18.6)))
#let windows-L = (((4.5, 24), (13.0, 24)), ((5.9, 21.25), (8.6, 21.25)), ((13.311, 15.0), (13.311, 18.6)))

// ---------- Furniture: V5.0 (ff_suite.typ) and the L variant ----------
#let furn-v50 = ((4.4, 22.15, 6.3, 23.8, [rack · weights]), (6.5, 22.15, 8.8, 23.8, [mats · pilates · pull-up]), (9.05, 22.0, 10.45, 23.8, [treadmill · cardio]), (10.65, 22.0, 11.6, 23.8, [bench]), (11.85, 22.0, 13.186, 23.8, [bike · rower]), (9.1, 20.3, 10.9, 21.1, [loungers]))
#let furn-L = (
  (4.45, 22.25, 6.45, 23.8, [barbell · rack]), (6.6, 23.2, 7.4, 23.8, [kettlebells]), (6.6, 22.2, 7.8, 22.8, [pull-up bar (wall)]),
  (8.0, 22.5, 10.0, 23.5, [pilates mat]), (10.2, 22.3, 10.9, 23.8, [cardio (bike)]),
  (9.1, 20.3, 10.9, 21.1, [loungers]),
)

// ---------- Helpers ----------
#let q(p) = (p.at(0), -p.at(1))
#let r2(v) = str(calc.round(v, digits: 2))
#let r3(v) = str(calc.round(v, digits: 3))
#let r0(v) = str(calc.round(v))
#let area(P) = calc.abs(range(P.len()).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, P.len())); a.at(0) * b.at(1) - b.at(0) * a.at(1) }).sum()) / 2
#let bbox(P) = (calc.min(..P.map(p => p.at(0))), calc.min(..P.map(p => p.at(1))), calc.max(..P.map(p => p.at(0))), calc.max(..P.map(p => p.at(1))))
#let fb(f) = (f.at(0), f.at(1), f.at(2), f.at(3))
#let box-overlap(a, b, eps: 0.001) = calc.min(a.at(2), b.at(2)) - calc.max(a.at(0), b.at(0)) > eps and calc.min(a.at(3), b.at(3)) - calc.max(a.at(1), b.at(1)) > eps
#let inside-box(a, b) = a.at(0) >= b.at(0) - 1e-6 and a.at(1) >= b.at(1) - 1e-6 and a.at(2) <= b.at(2) + 1e-6 and a.at(3) <= b.at(3) + 1e-6
#let green = rgb("#2f6b4f")
#let red = rgb("#b5452f")
#let blue = rgb("#1f7a99")
#let H(t) = text(9.5pt, weight: "bold", fill: green, t)

// ---------- Checks (L variant) ----------
#let arm-clear = (arm-x0 + inner-half, y-bed + inner-half, east - outer-half, y-gym)       // the arm, inside its walls (open to the long arm)
#let long-clear = (4.25 + inner-half, y-gym + inner-half, east - outer-half, 24.0 - outer-half)
#let issues = {
  let out = ()
  let tb = bbox(treadmill)
  // the treadmill and its side clearances inside the arm (north part) / the gym
  if tb.at(0) - side < arm-clear.at(0) - 1e-6 or tb.at(2) + side > arm-clear.at(2) + 1e-6 { out.push("treadmill side clearance under " + r2(side) + " m") }
  if tb.at(1) < arm-clear.at(1) - 1e-6 { out.push("treadmill hits the bedroom wall") }
  if bbox(rear-min).at(3) > long-clear.at(3) + 1e-6 { out.push("no room behind the treadmill") }
  // furniture: no overlap with the treadmill, its rear zones, each other; inside the gym (or the court for the loungers)
  for (i, f) in furn-L.enumerate() {
    if box-overlap(fb(f), tb) { out.push(repr(f.at(4)) + " overlaps the treadmill") }
    if box-overlap(fb(f), bbox(rear-astm)) { out.push(repr(f.at(4)) + " in the treadmill's 2.0 m rear zone") }
    for g in furn-L.slice(i + 1) { if box-overlap(fb(f), fb(g)) { out.push(repr(f.at(4)) + " overlaps " + repr(g.at(4))) } }
    let in-gym = inside-box(fb(f), long-clear)
    let in-court = inside-box(fb(f), bbox(L.court))
    if not (in-gym or in-court) { out.push(repr(f.at(4)) + " outside the gym and the court") }
  }
  // the door swing zones stay free: gym door (sliding) 0.9 m in front, inside the gym
  let door-zone = (gym-door.at(0).at(0), y-gym, gym-door.at(1).at(0), y-gym + 0.9)
  for f in furn-L { if box-overlap(fb(f), door-zone) { out.push(repr(f.at(4)) + " blocks the gym door") } }
  // the suite bedroom's door to the court still opens onto the court; the clerestory windows still face the court
  if bed-door.at(1).at(0) > arm-x0 - inner-half { out.push("the bedroom door hits the treadmill arm") }
  for (a, b) in clerestory { if b.at(0) > arm-x0 { out.push("a clerestory window faces the arm") } }
  // areas add up: the L takes from the court exactly what the gym gains
  if calc.abs((area(L.gym) - area(v50.gym)) - (area(v50.court) - area(L.court))) > 1e-6 { out.push("areas do not add up") }
  out
}

// ---------- Light check of the clerestory windows (same method as design_ff.typ page 4) ----------
#let tn(deg) = calc.tan(deg * 1deg)
#let w-alt = 90 - 21.4 - 23.44
#let e-alt = 90 - 21.4
#let cl-sill = 5.0
#let cl-head = 6.0
#let eye = (16.1, 1.2)
#let ang(p, q) = calc.atan((q.at(1) - p.at(1)) / (q.at(0) - p.at(0))).deg()
#let strip = 2.0            // the court's depth in front of the windows: unchanged (the arm is east of them)
#let top = 7.2              // the gym's north wall ends in a railing (solid top +7.20), as V5.0
#let sun-share(deg) = calc.clamp((cl-head - (top - strip * tn(deg))) / (cl-head - cl-sill), 0, 1)
#let sky-share = {
  let a-sill = ang(eye, (19.25, cl-sill)); let a-head = ang(eye, (19.25, cl-head)); let a-obs = ang(eye, (19.25 + strip, top))
  calc.clamp((a-head - calc.max(a-sill, a-obs)) / (a-head - a-sill), 0, 1)
}
// in plan: true north is 21.4° east of the M line, so the noon sun stands south-south-WEST of the M-line frame and the arm's shadow falls to the
// north-EAST, away from the windows (x ≤ 8.6, the arm starts at x arm-x0). Distance from the east window jamb to the arm's west wall:
#let arm-gap = arm-x0 - 8.6

// ---------- Drawing ----------
#let plan(set-name, d, furn, windows, show-tm: false) = cetz.canvas(length: 0.86cm, {
  import cetz.draw: *
  let poly(P, ..args) = line(..P.map(q), close: true, ..args)
  poly(void, fill: luma(238), stroke: (paint: luma(185), dash: "dashed")); content(q((7.27, 17.6)), text(5pt, fill: gray)[double-height living (void)])
  poly(gallery, fill: luma(238), stroke: (paint: luma(185), dash: "dashed")); content(q((4.92, 17.0)), angle: 90deg, text(5pt, fill: gray)[gallery])
  poly(bed3, fill: luma(238), stroke: (paint: luma(185), dash: "dashed")); content(q((2.1, 17.6)), text(5pt, fill: gray)[bedroom 3])
  poly(d.bedroom, fill: rgb("#efe0cf"), stroke: 0.6pt + rgb("#3d4a45")); content(q((11.1, 17.0)), text(6pt)[*F21 Suite bedroom*\ #r2(area(d.bedroom)) m²])
  poly(d.office, fill: rgb("#e3e8d4"), stroke: 0.6pt + rgb("#3d4a45")); content(q((2.1, 21.6)), text(6pt)[*F14 Owner's office*\ #r2(area(d.office)) m²])
  poly(d.route, fill: rgb("#f2efe8"), stroke: 0.6pt + rgb("#3d4a45")); content(q((4.92, 20.25)), angle: 90deg, text(5pt)[*F13* route])
  poly(d.court, fill: white, stroke: 0.6pt + rgb("#3d4a45"))
  let (cx0, cy0, cx1, cy1) = bbox(d.court)
  content(q(((cx0 + cx1) / 2, 19.75)), text(6pt)[*F16 Suite court* · open to the sky · #r2(cx1 - cx0) × 2.0 = #r2(area(d.court)) m²])
  poly(d.gym, fill: rgb("#d9e4f2"), stroke: 0.6pt + rgb("#3d4a45"))
  content(q((6.0, 21.65)), text(6pt)[*F15 Gym* #r2(area(d.gym)) m²])
  for (x0, y0, x1, y1, l) in furn {
    rect(q((x0, y0)), q((x1, y1)), fill: white.transparentize(25%), stroke: (paint: luma(110), thickness: 0.4pt, dash: "dashed"))
    content(q(((x0 + x1) / 2, (y0 + y1) / 2)), angle: if (y1 - y0) > (x1 - x0) * 1.3 { 90deg } else { 0deg }, text(4.4pt, fill: luma(80), l))
  }
  if show-tm {
    poly(rear-astm, fill: rgb("#fdf0d8"), stroke: (paint: rgb("#d08a00"), thickness: 0.4pt, dash: "dotted"))
    poly(rear-min, fill: rgb("#f8d9a8"), stroke: none)
    content(q((12.436, 22.95)), angle: 90deg, text(4.2pt, fill: rgb("#a06a00"))[keep free · 2.0 m])
    poly(treadmill, fill: white, stroke: 0.7pt + rgb("#3d4a45"))
    content(q((12.436, 20.45)), angle: 90deg, text(4.6pt)[treadmill 0.9 × 2.0 ▲])
    line(q((arm-x0 + inner-half, 20.0)), q((treadmill.at(0).at(0), 20.0)), stroke: 0.4pt + red, mark: (start: "|", end: "|", scale: 0.3))
    line(q((treadmill.at(1).at(0), 20.0)), q((east - outer-half, 20.0)), stroke: 0.4pt + red, mark: (start: "|", end: "|", scale: 0.3))
    content(q((arm-x0 + 0.25, 19.75)), text(4pt, fill: red)[0.3])
    line(q((east + 0.35, y-bed)), q((east + 0.35, y-gym)), stroke: 0.5pt + green, mark: (start: "|", end: "|", scale: 0.35))
    content(q((east + 0.5, 20.25)), anchor: "west", text(5pt, fill: green)[arm #r3(arm-w) × #r2(arm-l) axes])
    // the shared wall with the bedroom: acoustic
    line(q((arm-x0, y-bed)), q((east, y-bed)), stroke: 3pt + red)
    content(q((arm-x0 - 0.1, 19.05)), anchor: "east", text(5pt, fill: red)[acoustic wall shared with F21 ▶])
  }
  // walls drawn heavier: the outline of the L / rectangle
  for (a, b) in windows { line(q(a), q(b), stroke: 2.4pt + blue) }
  for (a, b) in clerestory { line(q(a), q(b), stroke: 2.4pt + blue) }
  line(q(bed-door.at(0)), q(bed-door.at(1)), stroke: 1.6pt + red)
  line(q(gym-door.at(0)), q(gym-door.at(1)), stroke: 1.6pt + red)
  line(q(office-door.at(0)), q(office-door.at(1)), stroke: 1.6pt + red)
  // GF men's majlis below (dotted): no inner wall
  line(..rect-pts(2.75, 19.25, 13.311, 24.0).map(q), close: true, stroke: (paint: rgb("#8a5a2b"), dash: "dotted", thickness: 0.7pt))
  content(q((0.0, 25.0)), anchor: "west", text(7pt, weight: "bold", set-name))
})

// ================= PAGE 1 · current geometry and the L =================
#text(15pt, weight: "bold", fill: green)[First floor · gym variant study · an L-shaped gym]
#h(8pt) #text(8pt, fill: gray)[Taif / Palm House · on V5.0 (tag v5.0) · 24 Oct 2026 · branch v5-gym-L · main files unchanged · CSV coordinates, wall centre lines, north up]
#v(2pt)
#grid(columns: (1fr, 1fr), column-gutter: 8pt,
  plan([V5.0 · gym a rectangle], v50, furn-v50, windows-v50),
  plan([Variant · L-shaped gym, treadmill arm], L, furn-L, windows-L, show-tm: true),
)
#v(-4pt)
#text(6pt, fill: gray)[Red = doors (all sliding here) and, right, the shared wall arm / suite bedroom · blue = windows (the two clerestory windows of the double-height living on y 19.25, the gym's high windows onto the court on y 21.25) · orange = the treadmill's rear zones (dark: the owner's 0.5 m; light dotted: 2.0 m, kept free) · brown dotted = the GF men's majlis below (no inner wall).]
#v(2pt)
#grid(columns: (1.1fr, 1fr), column-gutter: 16pt, [
  #H[1 · V5.0 geometry (data/rooms_ff.csv = studies/ff_suite.typ)]
  #table(columns: (auto, auto, auto, auto), stroke: none, inset: 2.2pt, fill: (_, y) => if calc.even(y) { rgb("#efece4") },
    [*Room*], [*Corners (x, y)*], [*Axes*], [*m²*],
    [F15 Gym], [x 4.25–13.311, y 21.25–24.0], [9.061 × 2.75], [#r2(area(v50.gym))],
    [F13 Gym route], [x 4.25–5.6, y 19.25–21.25], [1.35 × 2.0], [#r2(area(v50.route))],
    [F14 Owner's office], [x 0–4.25, y 19.25–24.0], [4.25 × 4.75], [#r2(area(v50.office))],
    [F16 Suite court], [x 5.6–13.311, y 19.25–21.25], [7.711 × 2.0], [#r2(area(v50.court))],
    [F21 Suite bedroom], [polygon to x 13.311, y 19.25], [4.361 × 7.35 (L)], [#r2(area(v50.bedroom))],
  )
  *Shared walls:* gym / office x 4.25 (y 21.25–24) · gym / gym route y 21.25 (x 4.25–5.6, gym door) · gym / suite court y 21.25 (x 5.6–13.311, high windows) · route / office x 4.25 (office door) · route / court x 5.6 · court / suite bedroom y 19.25 (x 8.95–13.311, the bedroom's sliding door) · court / double-height living y 19.25 (x 5.6–8.95, the two clerestory windows).\
  *Answer:* yes, the gym is a plain rectangle 9.061 × 2.75 m (#r2(area(v50.gym)) m²; it was an L on 18 Oct and was made a rectangle in V5.0 on 20 Oct). It does *not* touch the suite bedroom: the 2.0 m suite court lies between them.
], [
  #H[2 · The short arm, computed]
  - *Width:* treadmill 0.9 + 2 × 0.3 = *#r2(arm-clear-w) m clear* → + ½ outer wall (0.125, east) + ½ wall (0.10, to the court) = *#r3(arm-w) m on axes* (x #r3(arm-x0)–13.311).
  - *Length:* the arm can only run north up to the suite bedroom's south wall (y 19.25): *#r2(arm-l) m on axes* (y 19.25–21.25, the court's depth), #r2(arm-l - inner-half) m clear inside it. The treadmill needs #r2(need-l) m clear from the bedroom wall face (0.1 gap + 2.0 + 0.5 behind): it stands in the arm and *steps off south into the long arm*, where the 0.5 m (and the 2.0 m of the safety standards) lies. A 2.5 m arm on axes would enter the bedroom.
  - *Treadmill:* x #r3(treadmill.at(0).at(0))–#r3(treadmill.at(1).at(0)), y #r2(tm-y0)–#r2(tm-y0 + tm.l), facing north; 0.3 m each side, 0.1 m off the bedroom wall (no contact).
  - *Gym:* long arm 9.061 × 2.75 = #r2(area(long-arm)) m² + short arm #r3(arm-w) × #r2(arm-l) = #r2(area(short-arm)) m² → *#r2(area(L.gym)) m²* (V5.0 #r2(area(v50.gym))).
  #v(2pt)
  #if issues.len() == 0 { text(fill: green, weight: "bold")[✓ Treadmill clearances (0.3 each side, 0.5 and 2.0 m behind) free · furniture inside the gym, not overlapping, out of the treadmill zones and the gym door · bedroom door and clerestory windows still on the court · areas add up] } else { block(fill: rgb("#fbe3dd"), inset: 4pt, radius: 2pt)[#text(fill: red, weight: "bold")[WARNING]\ #issues.map(i => [• #i]).join(linebreak())] }
])

// ================= PAGE 2 · comparison and notes =================
#pagebreak()
#set text(size: 6.9pt)
#text(15pt, weight: "bold", fill: green)[Gym variant · rectangle (V5.0) against the L]
#v(4pt)
#grid(columns: (1fr, 1fr), column-gutter: 18pt, [
  #H[Comparison]
  #table(columns: (auto, 1fr, 1fr), stroke: none, inset: 2.6pt, fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#efece4") },
    [*Item*], [*V5.0 · rectangle*], [*Variant · L*],
    [Gym (F15)], [9.061 × 2.75 = #r2(area(v50.gym)) m²], [#r2(area(L.gym)) m² (long #r2(area(long-arm)) + arm #r2(area(short-arm)))],
    [Long arm], [–], [9.061 × 2.75 m, as now],
    [Short arm (treadmill only)], [–], [#r3(arm-w) × #r2(arm-l) m axes · #r2(arm-clear-w) × #r2(arm-l - inner-half) m clear],
    [Treadmill], [in the row of machines along the south wall (treadmill · cardio)], [in the arm, facing north; 0.3 m each side; #r2(24.0 - outer-half - (tm-y0 + tm.l)) m free behind (≥ 2.0 kept)],
    [Long-arm equipment], [rack · mats/pilates/pull-up · treadmill/cardio · bench · bike/rower], [barbell + rack · kettlebells · pull-up bar · pilates mat · one cardio (bike); no bench],
    [Suite court (F16)], [7.711 × 2.0 = #r2(area(v50.court)) m²], [#r2(bbox(L.court).at(2) - 5.6) × 2.0 = #r2(area(L.court)) m² (−#r2(area(v50.court) - area(L.court)))],
    [Court open to the sky, private], [yes · walled on 4 sides], [yes · walled on 4 sides (east side now the arm's solid wall)],
    [Clerestory windows: winter-noon sun], [#r0(sun-share(w-alt) * 100) %], [#r0(sun-share(w-alt) * 100) % (unchanged)],
    [Clerestory windows: equinox-noon sun], [#r0(sun-share(e-alt) * 100) %], [#r0(sun-share(e-alt) * 100) % (unchanged)],
    [Clerestory windows: sky seen from the living], [#r0(sky-share * 100) %], [#r0(sky-share * 100) % (unchanged)],
    [Gym touches the suite bedroom], [no (court between)], [*yes* · wall y 19.25, x #r3(arm-x0)–13.311 (#r3(arm-w) m)],
    [Suite bedroom door to the court], [x 9.3–10.7, sliding], [unchanged (#r2(arm-x0 - inner-half - 10.7) m to the arm's wall)],
    [Suite bedroom windows], [east x 13.311, y 15.0–18.6], [unchanged],
    [New walls on the men's majlis roof], [y 21.25 (x 5.6–13.311)], [y 21.25 (x 5.6–#r3(arm-x0)) + arm west wall x #r3(arm-x0) (y 19.25–21.25) + arm roof],
    [Roofed FF area], [–], [+#r2(area(short-arm)) m² (court → gym)],
  )
  #text(6pt, fill: gray)[Light: the section method of design_ff.typ page 4 (sill +5.00, head +6.00, the gym's north wall a railing with solid top +7.20, 2.0 m in front of the windows, seated eye +1.20 at y 16.1). The arm stands #r2(arm-gap) m east of the east clerestory window; with true north 21.4° east of the M line the noon sun stands south-south-west of the plan frame, so the arm's shadow falls north-east, away from the windows (it can shade them only on early mornings).]
], [
  #H[The suite court after the change]
  - #r2(bbox(L.court).at(2) - 5.6) × 2.0 m = #r2(area(L.court)) m² (was #r2(area(v50.court))): still *open to the sky* and *private*, walled on four sides: north the double-height living (clerestory) and the suite bedroom (sliding door), south the gym's north wall (high obscured windows), west the gym route, *east now the treadmill arm's solid wall* (no window onto the court, or high obscured glass).
  - The two clerestory windows (x 6.0–7.0 and 7.6–8.6) keep the full 2.0 m of open court in front of them: winter-noon sun #r0(sun-share(w-alt) * 100) %, sky #r0(sky-share * 100) %, as in V5.0.
  - *Rain:* V5.0 lets the court fall to the east; that end is now the arm. Move the floor drain to the court's new east end (x ≈ #r2(arm-x0 - 0.4)) or fall it west; the arm's roof drains outside like the gym roof.
  #v(3pt)
  #H[Acoustics · the wall between the treadmill and the suite bedroom]
  - *The problem* is mostly *structure-borne:* footfall impact and motor vibration go into the slab and the wall, then into the bedroom. Airborne noise comes second.
  - *Wall* (y 19.25, x #r3(arm-x0)–13.311, and its junctions with the outer wall and the arm wall): a *double-leaf wall* rather than one 200 mm block: e.g. the 200 mm dense block + a free-standing stud lining on the gym side (no contact, 50 mm mineral wool, 2 × 12.5 mm acoustic plasterboard), or two block leaves with a 50 mm filled cavity. Target ≈ *Rw ≥ 55 dB* (DnT,w ≥ 50 dB between gym and bedroom); seal the top, no sockets back to back, no duct through it.
  - *Floor under the arm:* a *floating floor* (resilient layer + 50–70 mm screed, perimeter isolation strip, not touching the walls) or at least 20–40 mm dense rubber gym tiles over the whole arm, plus *anti-vibration pads* under the treadmill feet. Stop the floating screed short of the bedroom wall.
  - *Treadmill:* 0.1 m off the shared wall, never fixed to it; choose a model with a cushioned deck and a quiet (AC) motor.
  - *Use:* the bedroom is the master bedroom; a house rule (no running while someone sleeps) costs nothing.
  #v(3pt)
  #H[Structure (men's majlis roof, no wall below)]
  - The GF men's majlis (x 2.75–13.311, y 19.25–24) has *no inner wall*. On its roof the variant keeps the gym's north wall y 21.25 (now x 5.6–#r3(arm-x0)) and adds the *arm's west wall x #r3(arm-x0), y 19.25–21.25*, with no wall below. Its north wall (y 19.25) is on the GF living / men's majlis wall and its east wall is the outer wall.
  - *New:* the arm's roof slab (#r2(area(short-arm)) m²) and the treadmill's dynamic load (≈ 1.5–2 kN in use) on the majlis roof slab. Engineer: a light wall or a beam on x #r3(arm-x0), the slab for the treadmill's vibration, and the floating floor's weight.
  #v(3pt)
  #H[Treadmill safety]
  - The owner's minimum (0.5 m behind, 0.3 m each side) is met. The equipment standards (ASTM F2115, EN 957-6) ask for *2.0 × 0.9 m free behind and 0.5 m each side*: the 2.0 m behind is kept free in the long arm (drawn); for 0.5 m sides the arm would be #r3(tm.w + 1.0 + outer-half + inner-half) m on axes (court #r2(arm-x0 - 0.4 - 5.6) m long).
  #v(3pt)
  #H[Questions for the owner]
  + Accept the smaller suite court (#r2(area(L.court)) m², was #r2(area(v50.court)))?
  + The bench is dropped from the long arm (not on the list); keep one?
  + Arm sides 0.3 m (owner) or 0.5 m (standard)?
])

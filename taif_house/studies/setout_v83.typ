// setout_v83.typ · Taif / Palm House · BUILDING TEST + SET-OUT SHEET · V8.3 with the owner's site decisions of 4 Nov 2026 (B1 5.00 m from M1) and 6 Nov 2026 (a further 0.50 m south: B1 5.49 m)
// Supersedes studies/site_test.typ (V6.3, building.csv). The building = design_gf.typ's outline + shift (outer wall faces); the site = base.typ.
// The STATUS comes from the tightest point on ANY wall (every edge sampled at 5 cm), not only from the corners: the lane notch bites the cut wall between B2 and B3.
// Design frame: origin = peg M1 (the gate's east post) · y = metres along the M line, southwards · x = metres square to the M line, east (towards the lane).
// Field instructions: docs/SITE_SETOUT.md. Concept only – not for permit.
#import "@preview/cetz:0.4.2"
#import "../base.typ": land, env, drv, lane, nwall, T1, T2, north, D, R, S as peg-S
#import "../design_gf.typ": shift, outline-csv-gf

#set page(paper: "a4", flipped: true, margin: 8mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 8pt)
#set par(leading: 0.4em)

// =====================================================================
// INPUT – the building from the design files (nothing to edit here: move the house in design_gf.typ)
// =====================================================================
#let S(p) = (p.at(0) + shift.at(0), p.at(1) + shift.at(1))
#let expected = ((0, 0), (10.051, 0), (13.311, 6.0), (13.311, 24.0), (0, 24.0))
#assert(outline-csv-gf.len() == expected.len() and outline-csv-gf.zip(expected).all(((a, b)) => calc.abs(a.at(0) - b.at(0)) + calc.abs(a.at(1) - b.at(1)) < 1e-6),
  message: "the ground-floor outline changed: update the outer-face corners in setout_v83.typ")
// the OUTER wall faces of the 13.311 × 24.0 m centre-line pentagon (250 mm outer walls, the cut corner mitred): B1 NW, B2 cut north, B3 cut east, B4 SE, B5 SW
#let building = ((-0.125, -0.125), (10.125, -0.125), (13.436, 5.968), (13.436, 24.125), (-0.125, 24.125)).map(S)
#let courtyards = (((4.35, 6.6), (8.85, 6.6), (8.85, 12.9), (4.35, 12.9)).map(S),)   // the open courtyard, clear opening (4.50 × 6.30)
#let spare = 0.5                 // the spare you want to keep from the setback lines until the official survey
#let lane-stop = 2.0             // field rule: less than this from the tightest point to the lane wall = stop and report

// ---------- Reference points on site (4 Nov 2026) ----------
#let M1 = (0.0, 0.0)             // the gate's east post: the origin
// D (the dakka's south corner), R and S come from base.typ: the v2 field check's least-squares fit (5 Nov 2026: R and S are reference points, no longer the +/- 2 m helpers of v1)
#let M4 = (0.0, 28.8)            // the old peg M4 on the M line, to re-establish from M1 and D (M2–M4 are gone)
#let r-palm = 0.265              // the palms' trunk radius (base.typ)
#let refs = (("M1", M1), ("D", D))
#let refs2 = (("R", R), ("S", peg-S))   // the second pair of reference points (v2 fit): checks of every corner

// ---------- Geometry helpers ----------
#let dist(a, b) = calc.sqrt(calc.pow(a.at(0) - b.at(0), 2) + calc.pow(a.at(1) - b.at(1), 2))
#let area(poly) = {
  let s = 0.0
  let n = poly.len()
  for i in range(n) {
    let a = poly.at(i)
    let b = poly.at(calc.rem(i + 1, n))
    s += a.at(0) * b.at(1) - b.at(0) * a.at(1)
  }
  calc.abs(s) / 2
}
#let pseg(p, a, b) = {
  let dx = b.at(0) - a.at(0)
  let dy = b.at(1) - a.at(1)
  let l2 = dx * dx + dy * dy
  let t = if l2 == 0 { 0 } else { calc.max(0, calc.min(1, ((p.at(0) - a.at(0)) * dx + (p.at(1) - a.at(1)) * dy) / l2)) }
  dist(p, (a.at(0) + t * dx, a.at(1) + t * dy))
}
#let edge-dist(p, poly) = {
  let n = poly.len()
  let m = 1e9
  for i in range(n) { m = calc.min(m, pseg(p, poly.at(i), poly.at(calc.rem(i + 1, n)))) }
  m
}
#let line-dist(p, pts) = calc.min(..range(pts.len() - 1).map(i => pseg(p, pts.at(i), pts.at(i + 1))))   // an open polyline (the lane wall)
#let inside(p, poly) = {
  let c = false
  let n = poly.len()
  for i in range(n) {
    let (xi, yi) = poly.at(i)
    let (xj, yj) = poly.at(calc.rem(i + n - 1, n))
    if ((yi > p.at(1)) != (yj > p.at(1))) and (p.at(0) < (xj - xi) * (p.at(1) - yi) / (yj - yi) + xi) { c = not c }
  }
  c
}
// the margin to the limits that matter: the setback lines and the south line (the M line has no setback)
#let limit-dist(p, poly) = {
  let n = poly.len()
  let m = 1e9
  for i in range(n) {
    let a = poly.at(i)
    let b = poly.at(calc.rem(i + 1, n))
    if not (calc.abs(a.at(0)) < 0.01 and calc.abs(b.at(0)) < 0.01) { m = calc.min(m, pseg(p, a, b)) }
  }
  m
}
#let margin(p, poly) = {
  let pin = (calc.max(p.at(0), 0.001), p.at(1))   // a point on the M line counts as inside
  if p.at(0) < -0.01 { -limit-dist(p, poly) } else if inside(pin, poly) { limit-dist(p, poly) } else { -limit-dist(p, poly) }
}
#let f2(v) = {
  let r = calc.round(v, digits: 2)
  let s = str(r)
  if not s.contains(".") { s + ".00" } else if s.split(".").at(1).len() == 1 { s + "0" } else { s }
}

// ---------- Results ----------
#let a-build = area(building)
#let a-court = courtyards.map(area).sum(default: 0)
#let corner-m = building.map(p => margin(p, env))
#let min-m = calc.min(..corner-m)
// every edge sampled at 5 cm: the tightest point on the walls, not only at the corners
#let edge-pts = {
  let out = ()
  let n = building.len()
  for i in range(n) {
    let a = building.at(i)
    let b = building.at(calc.rem(i + 1, n))
    let k = calc.max(1, int(calc.ceil(dist(a, b) / 0.05)))
    for j in range(k) { let t = j / k; out.push((a.at(0) + t * (b.at(0) - a.at(0)), a.at(1) + t * (b.at(1) - a.at(1)), i)) }
  }
  out
}
#let edge-best = edge-pts.sorted(key: p => margin((p.at(0), p.at(1)), env)).first()
#let edge-pt = (edge-best.at(0), edge-best.at(1))
#let edge-wall = [B#(edge-best.at(2) + 1)–B#(calc.rem(edge-best.at(2) + 1, building.len()) + 1)]
#let edge-m = margin(edge-pt, env)
#let edge-lane = line-dist(edge-pt, lane)                 // from the tightest point square to the lane wall (the field check)
#let edge-from = refs.map(((n, q0)) => (n, dist(edge-pt, q0)))
#let env-in-building = env.filter(p => inside(p, building))
#let n-out = corner-m.filter(m => m < 0).len()
#let status = if n-out > 0 or edge-m < 0 or env-in-building.len() > 0 { "ERROR" } else if edge-m < spare { "CAUTION" } else { "OK" }
#let st-col = if status == "OK" { rgb("#2f6b4f") } else if status == "CAUTION" { rgb("#c98a12") } else { rgb("#b5452f") }
#let palm-check(t) = if inside(t, building) { -1 } else { edge-dist(t, building) - r-palm }
#let b1-m1 = dist(building.at(0), M1)
#let sides = range(building.len()).map(i => ([B#(i + 1)–B#(calc.rem(i + 1, building.len()) + 1)], dist(building.at(i), building.at(calc.rem(i + 1, building.len())))))
#let diags = (([B1–B4], dist(building.at(0), building.at(3))), ([B2–B5], dist(building.at(1), building.at(4))), ([B1–B3 (the cut's check)], dist(building.at(0), building.at(2))))
#let perimeter = sides.map(e => e.at(1)).sum()

// ---------- Colours and drawing helpers ----------
#let ink = rgb("#3d4a45"); #let accent = rgb("#2f6b4f"); #let envc = rgb("#e3f0dd")
#let setb = rgb("#f4c6c6"); #let drive = rgb("#d6e2ee"); #let navy = rgb("#2f5f8a")
#let brown = rgb("#8a5a2b"); #let bld = rgb("#6a3d9a"); #let grid-c = rgb("#d9dcd6"); #let red = rgb("#b5452f")
#let q(x, y) = (x, -y)
#let poly(pts, ..args) = cetz.draw.line(..pts.map(p => q(..p)), close: true, ..args)
#let lab(p, body, size: 6.5pt, fill: ink, anchor: "center", angle: 0deg) = cetz.draw.content(q(..p), anchor: anchor, angle: angle, text(size, fill: fill, body))

#let plan = cetz.canvas(length: 0.36cm, {
  import cetz.draw: *
  let ymax = 42
  for x in range(-7, 31) { line(q(x, -3), q(x, ymax), stroke: (paint: grid-c, thickness: if calc.rem(x, 5) == 0 { 0.5pt } else { 0.2pt })) }
  for y in range(-3, ymax + 1) { line(q(-7, y), q(30, y), stroke: (paint: grid-c, thickness: if calc.rem(y, 5) == 0 { 0.5pt } else { 0.2pt })) }
  for x in range(-5, 31, step: 5) { lab((x, -3.8), str(x), size: 5.5pt, fill: gray) }
  for y in range(0, ymax + 1, step: 5) { lab((-7.9, y), str(y), size: 5.5pt, fill: gray) }
  poly(land, fill: setb, stroke: none)
  poly(env, fill: envc, stroke: 0.8pt + accent)
  poly(drv, fill: drive, stroke: 0.4pt + navy)
  line(..nwall.map(p => q(..p)), stroke: 1.5pt + black)
  line(..lane.map(p => q(..p)), stroke: 1.5pt + black)
  line(q(0, 0), q(0, 38.86), stroke: 1.2pt + accent)
  // the building
  poly(building, fill: bld.transparentize(55%), stroke: 1pt + bld)
  for c in courtyards { poly(c, fill: white, stroke: 0.6pt + bld) }
  for (i, p) in building.enumerate() {
    let m = corner-m.at(i)
    circle(q(..p), radius: 0.3, fill: if m < 0 { red } else if m < spare { rgb("#c98a12") } else { bld }, stroke: none)
    lab((p.at(0) + 0.5, p.at(1) - 0.5), text(weight: "bold")[B#(i + 1)], size: 5.8pt, fill: bld, anchor: "west")
  }
  // the tightest point on any wall
  circle(q(..edge-pt), radius: 0.35, fill: none, stroke: 1pt + red)
  lab((edge-pt.at(0) + 0.6, edge-pt.at(1) + 0.3), text(weight: "bold")[#f2(edge-m) m], size: 5.8pt, fill: red, anchor: "west")
  // the tapes B1 ← M1 and the reference points
  line(q(..M1), q(..building.at(0)), stroke: (paint: accent, thickness: 0.6pt, dash: "dashed"))
  lab((1.4, 2.0), [#f2(b1-m1) m], size: 5.6pt, fill: accent, anchor: "west")
  for (n, p) in (("M1", M1), ("M4", M4)) { rect(q(p.at(0) - 0.3, p.at(1) - 0.3), q(p.at(0) + 0.3, p.at(1) + 0.3), fill: accent, stroke: none); lab((-0.5, p.at(1)), text(weight: "bold", n), size: 5.6pt, fill: accent, anchor: "east") }
  circle(q(..D), radius: 0.3, fill: brown, stroke: none)
  lab((D.at(0) - 0.5, D.at(1)), text(weight: "bold")[D], size: 5.8pt, fill: brown, anchor: "east")
  for (n, p) in refs2 { circle(q(..p), radius: 0.3, fill: brown, stroke: none); lab((p.at(0) + 0.5, p.at(1) - 0.2), text(weight: "bold", n), size: 5.6pt, fill: brown, anchor: "west") }
  for (p, n) in ((T1, [palm 1]), (T2, [palm 2])) {
    circle(q(..p), radius: r-palm, fill: accent, stroke: none)
    lab((p.at(0) + 0.6, p.at(1)), text(weight: "bold", n), size: 5.8pt, fill: accent, anchor: "west")
  }
  line(q(24, 0.5), (24 + 2.2 * north.at(0), -0.5 + 2.2 * north.at(1)), stroke: 1pt + ink, mark: (end: "stealth", fill: ink, scale: 0.7))
  lab((24 + 2.7 * north.at(0), -0.5 + 2.7 * north.at(1)), text(weight: "bold")[N], size: 8pt)
  line(q(18, ymax - 1), q(28, ymax - 1), stroke: 1.5pt + ink)
  lab((23, ymax - 0.2), [10 m], size: 6pt)
})

#let tbl(columns: (1fr, auto), ..cells) = text(7pt, table(columns: columns, stroke: none, inset: (x: 4pt, y: 2.5pt),
  fill: (_, y) => if y == 0 { rgb("#e1e9e3") } else if calc.even(y) { rgb("#efece4") }, ..cells))
#let sub-head(t) = [#v(4pt) #text(9pt, weight: "bold", fill: accent, t) #v(1pt)]

// =====================================================================
// PAGE 1 · Test on the land
// =====================================================================
#grid(columns: (auto, 1fr), column-gutter: 12pt,
  plan,
  [
    #text(14pt, weight: "bold", fill: accent)[Taif / Palm House] \
    #text(10pt, weight: "bold")[Building test on the land · V8.3 · the house moved south (owner, 4 Nov 2026) and a further 0.50 m south (owner, 6 Nov 2026)] \
    #text(7pt, fill: gray)[Frame: origin M1 (the gate's east post) · y along the M line southwards · x east, square to it · the house = the room CSVs + (#f2(shift.at(0)), #f2(shift.at(1))) · B1 #f2(b1-m1) m from M1]
    #v(2pt) #line(length: 100%, stroke: 0.6pt + accent)

    #box(fill: st-col.lighten(85%), stroke: 1pt + st-col, inset: 6pt, radius: 3pt, width: 100%)[
      #text(11pt, weight: "bold", fill: st-col)[#status] \
      #text(7.5pt)[
        #if status == "ERROR" [Part of the building is outside the buildable envelope.]
        #if status == "CAUTION" [Inside the envelope, but a wall comes closer than #f2(spare) m to a setback line (#f2(edge-m) m on #edge-wall).]
        #if status == "OK" [Every wall inside the envelope with at least #f2(spare) m spare: the tightest point #f2(edge-m) m, on #edge-wall at the lane notch.]
      ]
    ]

    #sub-head[Areas]
    #tbl(columns: (1fr, auto),
      table.header([*Item*], [*m²*]),
      [Building outline (outer wall faces)], [#f2(a-build)],
      [Open courtyard], [#f2(a-court)],
      [Roofed ground floor (approx.)], [*#f2(a-build - a-court)*],
      [Buildable envelope], [#f2(area(env))],
      [Envelope used by the outline], [#f2(100 * a-build / area(env)) %],
    )

    #sub-head[Checks]
    #tbl(columns: (1fr, auto),
      table.header([*Check*], [*Result*]),
      [Corners outside the envelope (x < 0 = in the driveway)], [#n-out],
      [Tightest corner margin (setback or south line)], [#f2(min-m) m],
      [*Tightest point on any wall* (edges sampled at 5 cm): #edge-wall at x #f2(edge-pt.at(0)), y #f2(edge-pt.at(1))], [*#f2(edge-m) m*],
      [  the same point square to the lane wall (field check; stop below #f2(lane-stop) m)], [#f2(edge-lane) m],
      [  the same point by two tapes: M1 → #f2(edge-from.at(0).at(1)), D → #f2(edge-from.at(1).at(1))], [],
      [Envelope corners poking into the building], [#env-in-building.len()],
      [Palm 1: building to trunk face], [#if palm-check(T1) < 0 [INSIDE] else [#f2(palm-check(T1)) m]],
      [Palm 2: building to trunk face], [#if palm-check(T2) < 0 [INSIDE] else [#f2(palm-check(T2)) m]],
      [B1 from M1 (the owner's rule of 4 Nov: 5.00 m; 6 Nov 2026: + 0.50 m south = 5.49)], [#f2(b1-m1) m],
    )

    #sub-head[First, check the frame on the ground]
    #text(7.2pt)[
      *Base check:* M1 → D = *#f2(dist(M1, D)) m* (field 4 Nov 2026: 28.50 m, +0.07 m, accepted). *Re-establish M4* on the M line: from M1 *#f2(dist(M1, M4)) m*, from D *#f2(dist(D, M4)) m*. Then tape from M4 to the trunk faces: *palm 1 ≈ #f2(dist(M4, T1) - r-palm) m*, *palm 2 ≈ #f2(dist(M4, T2) - r-palm) m*. Within ± 0.3 m → the frame sits on the ground. Corner sheet on page 2; the field instructions in `docs/SITE_SETOUT.md`.
    ]
    #text(6.5pt, fill: gray)[The corner margins are for the set-out sheet; the status uses the tightest point on any wall. Every position is to be confirmed by the official survey.]
  ],
)

// =====================================================================
// PAGE 2 · Set-out sheet for tape and string
// =====================================================================
#pagebreak()
#text(14pt, weight: "bold", fill: accent)[Set-out sheet · tape and string] #h(1fr) #text(8pt, fill: gray)[corners B1… = the outer wall faces of design_gf.typ · reference points M1 and D (M2–M4 are gone)]
#v(2pt) #line(length: 100%, stroke: 0.6pt + accent)
#text(7.6pt)[
  *Method A (two tapes, no square):* from M1 and from D, swing the two tapes and draw the arcs on the ground; where they cross (on the house side, east of the driveway) is the corner. *Two arcs cross at two points and a near-tangent crossing is vague: confirm every new corner with a third distance or a diagonal before setting the next one from it.* \
  *Method B (string):* re-establish M4 (from M1 #f2(dist(M1, M4)) m, from D #f2(dist(D, M4)) m), string M1 → M4, measure *y* along the string from M1, square off with 3-4-5 (3 m along, 4 m out, 5 m diagonal), measure *x* east, drive the peg. Use B to check every corner set out with A, then check the sides and the diagonals.
]
#v(3pt)
#let rows = building.enumerate().map(((i, p)) => {
  let m = corner-m.at(i)
  ([*B#(i + 1)*], [#f2(p.at(0))], [#f2(p.at(1))],
   ..refs.map(((n, q0)) => [#n → *#f2(dist(p, q0))*]),
   text(fill: if m < 0 { red } else if m < spare { rgb("#c98a12") } else { accent }, weight: "bold")[#f2(m)],
   [], [])
}).flatten()
#text(8pt, table(
  columns: (12mm, 18mm, 18mm, 30mm, 30mm, 26mm, 1fr, 1fr), stroke: 0.4pt + rgb("#9aa39f"), inset: 4pt, align: horizon,
  fill: (_, y) => if y == 0 { rgb("#e1e9e3") },
  table.header([*Corner*], [*x east*], [*y along M*], [*Tape 1 (M1 → m)*], [*Tape 2 (D → m)*], [*Margin to limit*], [*Measured on site*], [*Notes*]),
  ..rows,
))
#v(4pt)
#grid(columns: (1fr, 1fr), column-gutter: 10pt,
  text(8pt, table(
    columns: (auto, auto, 1fr, 1fr), stroke: 0.4pt + rgb("#9aa39f"), inset: 4pt, align: horizon,
    fill: (_, y) => if y == 0 { rgb("#e1e9e3") },
    table.header([*Side / diagonal*], [*Model (m)*], [*Measured*], [*Difference*]),
    ..sides.map(((l, v)) => (l, [*#f2(v)*], [], [])).flatten(),
    ..diags.map(((l, v)) => (l, [*#f2(v)*], [], [])).flatten(),
    [Perimeter B1 → … → B1], [*#f2(perimeter)*], [], [],
  )),
  text(8pt, table(
    columns: (auto, auto, 1fr, 1fr), stroke: 0.4pt + rgb("#9aa39f"), inset: 4pt, align: horizon,
    fill: (_, y) => if y == 0 { rgb("#e1e9e3") },
    table.header([*Frame and tightest point*], [*Model (m)*], [*Measured*], [*Difference*]),
    [M1 → D], [*#f2(dist(M1, D))*], [28.50 (4 Nov 2026)], [+0.07],
    [M4 from M1 / from D], [*#f2(dist(M1, M4)) / #f2(dist(D, M4))*], [], [],
    [M4 → palm 1 trunk face], [*#f2(dist(M4, T1) - r-palm)*], [], [],
    [M4 → palm 2 trunk face], [*#f2(dist(M4, T2) - r-palm)*], [], [],
    [Tightest point on #edge-wall: M1 → / D →], [*#f2(edge-from.at(0).at(1)) / #f2(edge-from.at(1).at(1))*], [], [],
    [  from it square to the lane wall (stop below #f2(lane-stop))], [*#f2(edge-lane)*], [], [],
    [R → palm 1 / palm 2 trunk face], [*#f2(dist(R, T1) - r-palm) / #f2(dist(R, T2) - r-palm)*], [], [],
    [S → palm 1 / palm 2 trunk face], [*#f2(dist(peg-S, T1) - r-palm) / #f2(dist(peg-S, T2) - r-palm)*], [], [],
    [M1 → R / D → R · M1 → S / D → S · R → S], [#f2(dist(M1, R)) / #f2(dist(D, R)) · #f2(dist(M1, peg-S)) / #f2(dist(D, peg-S)) · #f2(dist(R, peg-S))], [], [],
  )),
)
#v(4pt)
#text(8pt, table(
  columns: (12mm, 30mm, 30mm, 1fr, 1fr), stroke: 0.4pt + rgb("#9aa39f"), inset: 4pt, align: horizon,
  fill: (_, y) => if y == 0 { rgb("#e1e9e3") },
  table.header([*Corner*], [*Tape 3 (R → m)*], [*Tape 4 (S → m)*], [*Measured on site*], [*Notes*]),
  ..building.enumerate().map(((i, p)) => ([*B#(i + 1)*], [R → *#f2(dist(p, R))*], [S → *#f2(dist(p, peg-S))*], [], [])).flatten(),
))
#v(3pt)
#text(7pt, fill: gray)[Margin = distance to the nearest setback line or the south line (the M line has no setback, so a wall on it is fine): positive = inside by that much; negative = outside. Palms: trunk radius #f2(r-palm) m. R and S are the v2 field check's fitted pegs (03 Oct 2026, rms 0.27 m): usable as reference points; the R / S tapes check every corner set from M1 and D. Tolerances: the concept accepts ± 0.1 m on a corner and ± 0.3 m on the palms; the official survey fixes the wall faces. Source: base.typ (site baseline v2, field check 3 Oct 2026), design_gf.typ (the house).]
#v(2pt)
#text(6.5pt, fill: gray)[Set-out sheet checks: status #status · tightest point #f2(edge-m) m on #edge-wall · B1 from M1 #f2(b1-m1) m · palms #f2(palm-check(T1)) / #f2(palm-check(T2)) m from the walls.]

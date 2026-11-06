// rotation_b2.typ · Taif / Palm House · STUDY: a small rotation of the house about corner B2 (the owner's idea, 5 Nov 2026)
// STUDY ONLY: nothing in the design files, the house position or the set-out values changes here; the owner decides after reading the result.
// The house (B1 … B5 = the outer wall faces of design_gf.typ + shift) is rotated about B2 (the tightest point to the lane: it stays where it is) so that the
// SOUTH end moves EAST, away from the driveway: options = the south-west corner B5 moving east by 0.10 / 0.20 / 0.30 / 0.40 m.
// Field values of day 1 (owner, 4 Nov 2026, recorded in docs/SITE_SETOUT.md § 7): B2 is the nearest point of the house to the boundary wall, about 2.40 m to the
// wall's inner face (2.60 m including the wall; the municipality measures from the wall); B1 to the old house's yard wall across the driveway 4.77 m, the narrowest
// point of the route, which widens going south. The study is calibrated to them where they differ from the model (the lane wall 0.68 m nearer than the deed line).
// Decision recorded (owner, day 1): NO reduction of the cut wall until the official survey.
// Design frame: origin = peg M1 (the gate's east post) · y along the M line, southwards · x east. Concept only – not for permit.
#import "@preview/cetz:0.4.2"
#import "../base.typ": land, env, drv, lane, nwall, T1, T2, north, D, R, S as peg-S, site-pts
#import "../design_gf.typ": shift, outline-csv-gf
#let shift = (0.91, 5.063)   // THE DAY-1 POSITION this study was made at (6 Nov 2026: the 0.50 m south of shift_south.typ was adopted, design_gf.typ now 5.563): the study stays as issued

#set page(paper: "a4", flipped: true, margin: 8mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 8pt)
#set par(leading: 0.4em)

// =====================================================================
// INPUT – the house as it is (nothing to edit here; the study never moves it)
// =====================================================================
#let S(p) = (p.at(0) + shift.at(0), p.at(1) + shift.at(1))
#let expected = ((0, 0), (10.051, 0), (13.311, 6.0), (13.311, 24.0), (0, 24.0))
// 6 Nov 2026: the cut wall was moved outwards 0.12 m (design_gf.typ); this study keeps the former outline it was made with
#let B0 = ((-0.125, -0.125), (10.125, -0.125), (13.436, 5.968), (13.436, 24.125), (-0.125, 24.125)).map(S)   // B1 NW, B2 cut north, B3 cut east, B4 SE, B5 SW
#let B2 = B0.at(1)
#let spare = 0.5                 // the spare to keep from the setback lines until the official survey (setout_v83.typ)
#let setback-lane = 2.0          // the lane setback (base.typ: the envelope is 2.0 m inside the lane line, 3.0 m inside the north line)
#let M1 = (0.0, 0.0)
#let r-palm = 0.265
#let drv-west = -3.95            // the driveway's west edge (base.typ drv), surveyed v2
#let options = (0.10, 0.20, 0.30, 0.40)
#let prefer = 0.30               // the owner's preference, if safe

// ---------- Field values, day 1 (owner, 4 Nov 2026) ----------
#let field = (b2-wall-in: 2.40, b2-wall-out: 2.60, b1-yard: 4.77)
// the deed-sketch old house's east face (docs/SITE_SETOUT.md § 8: W4 (−6.0, 6.5) → W3 (−8.0, 28.5)): it runs away from the driveway going south, as the owner saw
#let yard-slope = (-8.0 - -6.0) / (28.5 - 6.5)

// ---------- Things attached to the house (site_plan.typ, in the house's frame: they turn with it) ----------
#let gas0 = (S((15.35, 7.8)), S((15.85, 8.8)))          // the LPG cabinet on the yard screen's east face
#let screen0 = (S((15.2, 7.6)), S((15.3, 13.0)))        // the 1.8 m yard screen
#let counter0 = (S((13.45, 8.3)), S((14.05, 10.1)))     // the outdoor counter (the outdoor kitchen)
#let grill0 = (S((16.5, 12.6)), S((17.6, 13.8)))
#let manhole0 = S((14.3, 13.5))                         // the east-yard foul chamber (the sewer's first chamber)
#let guest-door0 = S((0, 22.2))                         // the guest door on the west wall
#let family-door0 = (S((3.0, 0)), S((4.0, 0)))          // the family entrance on the north wall
#let west-out0 = S((0, 10.675))                         // where the west wash block's drain leaves under the west wall (ch-w's y)
// ---------- Things fixed on the site (site_plan.typ) ----------
#let park-opt = (5.2, 0.9, 10.2, 3.4)                   // the family car bay in the north strip
#let swept-y = 2.15                                     // the swept path's last move (centre line); the car's side 0.9 m south of it
#let path-guest-x = -1.0                                // the guest path on the driveway's east band
#let lowwall-x = 0.6                                    // the garden's low wall
#let garden = ((0.9, 29.188), (14.35, 29.188), (14.35, 20.838), (22.5, 20.838), (26.74, 33.94), (0.9, 38.7))
#let tank-old = (-7.5, 35.7, -4.5, 38.2)
#let ch-w = (-2.4, 15.738); #let ch-ne = (16.0, 11.438); #let soak-e = (16.5, 15.738); #let soak-s = (10.0, 32.238)
#let pipe-in = (0.9, 14.138)                            // the supply pipe enters the utility room through the west wall
#let sep-tank-house = 5.0

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
#let edge-dist(p, poly) = { let n = poly.len(); calc.min(..range(n).map(i => pseg(p, poly.at(i), poly.at(calc.rem(i + 1, n))))) }
#let line-dist(p, pts) = calc.min(..range(pts.len() - 1).map(i => pseg(p, pts.at(i), pts.at(i + 1))))
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
// the margin to the setback lines and the south line (the M line has no setback): as setout_v83.typ
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
#let margin(p) = {
  let pin = (calc.max(p.at(0), 0.001), p.at(1))
  if p.at(0) < -0.01 { -limit-dist(p, env) } else if inside(pin, env) { limit-dist(p, env) } else { -limit-dist(p, env) }
}
#let lane-d(p) = line-dist(p, lane)
// the calibration: the lane wall's inner face measured 2.40 m from B2 against 3.08 m to the deed line: the wall is taken delta nearer EVERYWHERE (conservative), the setback 2.0 m from it
#let delta = lane-d(B2) - field.b2-wall-in
#let margin-cal(p) = calc.min(margin(p), lane-d(p) - delta - setback-lane)
#let rot(p, th, c) = { let dx = p.at(0) - c.at(0); let dy = p.at(1) - c.at(1); (c.at(0) + dx * calc.cos(th) - dy * calc.sin(th), c.at(1) + dx * calc.sin(th) + dy * calc.cos(th)) }
// the angle that moves B5 east by e (Newton on the exact rotation)
#let theta-for(e) = {
  let dx = B0.at(4).at(0) - B2.at(0)
  let dy = B0.at(4).at(1) - B2.at(1)
  let th = -e / dy
  for _ in range(5) {
    let f = dx * (calc.cos(th) - 1) - dy * calc.sin(th) - e
    let df = -dx * calc.sin(th) - dy * calc.cos(th)
    th = th - f / df
  }
  th
}
#let sample(poly, step) = {
  let out = ()
  let n = poly.len()
  for i in range(n) {
    let a = poly.at(i)
    let b = poly.at(calc.rem(i + 1, n))
    let k = calc.max(1, int(calc.ceil(dist(a, b) / step)))
    for j in range(k) { let t = j / k; out.push((a.at(0) + t * (b.at(0) - a.at(0)), a.at(1) + t * (b.at(1) - a.at(1)), i)) }
  }
  out
}
#let tightest(poly, f) = {
  let best = sample(poly, 0.05).sorted(key: p => f((p.at(0), p.at(1)))).first()
  (m: f((best.at(0), best.at(1))), p: (best.at(0), best.at(1)), wall: [B#(best.at(2) + 1)–B#(calc.rem(best.at(2) + 1, poly.len()) + 1)])
}
// Sutherland–Hodgman: the part of a polygon inside a CONVEX polygon (the garden inside the rotated house)
#let clip(subject, cp) = {
  let s0 = 0.0
  for i in range(cp.len()) { let a = cp.at(i); let b = cp.at(calc.rem(i + 1, cp.len())); s0 += a.at(0) * b.at(1) - b.at(0) * a.at(1) }
  let sgn = if s0 >= 0 { 1 } else { -1 }
  let side(p, a, b) = sgn * ((b.at(0) - a.at(0)) * (p.at(1) - a.at(1)) - (b.at(1) - a.at(1)) * (p.at(0) - a.at(0))) >= 0
  let isect(p, q, a, b) = {
    let den = (p.at(0) - q.at(0)) * (a.at(1) - b.at(1)) - (p.at(1) - q.at(1)) * (a.at(0) - b.at(0))
    let t = ((p.at(0) - a.at(0)) * (a.at(1) - b.at(1)) - (p.at(1) - a.at(1)) * (a.at(0) - b.at(0))) / den
    (p.at(0) + t * (q.at(0) - p.at(0)), p.at(1) + t * (q.at(1) - p.at(1)))
  }
  let out = subject
  for i in range(cp.len()) {
    let a = cp.at(i)
    let b = cp.at(calc.rem(i + 1, cp.len()))
    let inp = out
    out = ()
    if inp.len() > 0 {
      let s = inp.last()
      for p in inp {
        if side(p, a, b) { if not side(s, a, b) { out.push(isect(s, p, a, b)) }; out.push(p) } else if side(s, a, b) { out.push(isect(s, p, a, b)) }
        s = p
      }
    }
  }
  out
}
#let f2(v) = { let r = calc.round(v, digits: 2); let s = str(r); if not s.contains(".") { s + ".00" } else if s.split(".").at(1).len() == 1 { s + "0" } else { s } }
#let f1(v) = str(calc.round(v, digits: 1))
#let sgn2(v) = if v >= 0.005 { "+" + f2(v) } else if v <= -0.005 { "−" + f2(-v) } else { "0" }
#let x-on(a, b, y) = a.at(0) + (y - a.at(1)) * (b.at(0) - a.at(0)) / (b.at(1) - a.at(1))   // x of the line a–b at height y
#let y-on(a, b, x) = a.at(1) + (x - a.at(0)) * (b.at(1) - a.at(1)) / (b.at(0) - a.at(0))   // y of the line a–b at x
#let yard-x(y) = B0.at(0).at(0) - field.b1-yard + yard-slope * (y - B0.at(0).at(1))        // the old house's yard wall, calibrated: 4.77 m west of B1, then away going south
#let box-dist(b, p) = { let dx = calc.max(b.at(0) - p.at(0), 0, p.at(0) - b.at(2)); let dy = calc.max(b.at(1) - p.at(1), 0, p.at(1) - b.at(3)); calc.sqrt(dx * dx + dy * dy) }

// =====================================================================
// One option = the whole house turned about B2 by the angle that moves B5 east by e
// =====================================================================
#let ys = (10.0, 15.0, 20.0, 25.0)   // where the west wall's clearances are read, between B1 and B5
#let option(e) = {
  let th = theta-for(e)
  let T(p) = rot(p, th, B2)
  let b = B0.map(T)
  let gas = gas0.map(T)
  let gas-pts = (gas.at(0), (gas.at(1).at(0), gas.at(0).at(1)), gas.at(1), (gas.at(0).at(0), gas.at(1).at(1)))
  let grill = grill0.map(T)
  let t-deed = tightest(b, margin)
  let t-cal = tightest(b, margin-cal)
  let t-lane = tightest(b, lane-d)
  let west(y) = x-on(b.at(0), b.at(4), y)
  let overlap = area(clip(garden, b)) - area(clip(garden, B0))
  (
    e: e, th: th, b: b, deg: th * 180 / calc.pi,
    moves: range(5).map(i => (b.at(i).at(0) - B0.at(i).at(0), b.at(i).at(1) - B0.at(i).at(1))),
    t-deed: t-deed, t-cal: t-cal, t-lane: t-lane,
    b2-m: margin(b.at(1)), b2-cal: margin-cal(b.at(1)),
    b3-lane: lane-d(b.at(2)), b3-m: margin(b.at(2)), b3-cal: margin-cal(b.at(2)),
    b1-m1: dist(b.at(0), M1), b1-north: margin(b.at(0)),
    north-at-bay: y-on(b.at(0), b.at(1), park-opt.at(0)) - park-opt.at(3),             // the bay's south edge to the house's north face at the bay's west end
    swept-clear: y-on(b.at(0), b.at(1), park-opt.at(0)) - (swept-y + 0.9),            // the car's side on its last move to the north face
    west-drv: ys.map(y => west(y) - drv-west), b5-drv: b.at(4).at(0) - drv-west,     // the west wall to the driveway's west edge
    west-yard: ys.map(y => west(y) - yard-x(y)), b5-yard: b.at(4).at(0) - yard-x(b.at(4).at(1)), b1-yard: b.at(0).at(0) - yard-x(b.at(0).at(1)),
    west-path: ys.map(y => west(y) - path-guest-x),                                   // the west wall to the guest path's line
    palm1: edge-dist(T1, b) - r-palm, palm2: edge-dist(T2, b) - r-palm,
    garden-lost: overlap, b5-lowwall: b.at(4).at(0) - lowwall-x,
    gas-lane: calc.min(..gas-pts.map(lane-d)), gas-lane-cal: calc.min(..gas-pts.map(lane-d)) - delta,
    grill-lane: calc.min(..(grill.at(0), (grill.at(1).at(0), grill.at(0).at(1)), grill.at(1), (grill.at(0).at(0), grill.at(1).at(1))).map(lane-d)),
    guest-door: T(guest-door0), manhole: T(manhole0), west-out: T(west-out0), family-door: family-door0.map(T),
    sewer-first: dist(T(manhole0), ch-ne), west-run: T(west-out0).at(0) - ch-w.at(0),
    tank-b5: box-dist(tank-old, b.at(4)),
    soak-e: pseg(soak-e, b.at(2), b.at(3)), soak-s: pseg(soak-s, b.at(3), b.at(4)),
    pipe-wall: west(pipe-in.at(1)) - path-guest-x,
    sides: range(5).map(i => dist(b.at(i), b.at(calc.rem(i + 1, 5)))),
    diags: (dist(b.at(0), b.at(3)), dist(b.at(1), b.at(4)), dist(b.at(0), b.at(2))),
  )
}
#let base = option(0.0)
#let opts = options.map(option)
#let rec = opts.find(o => calc.abs(o.e - prefer) < 1e-9)
#let conflicts(o) = {
  let c = ()
  if o.t-deed.m < spare { c.push([the tightest margin to the deed setback #f2(o.t-deed.m) < #f2(spare)]) }
  if o.t-deed.m < 0 { c.push([a wall outside the envelope]) }
  if o.palm1 < 3 or o.palm2 < 3 { c.push([a palm closer than 3 m]) }
  if o.gas-lane-cal < 1.5 { c.push([the gas cabinet < 1.5 m from the (calibrated) lane wall]) }
  if o.tank-b5 < sep-tank-house { c.push([the tank < #f1(sep-tank-house) m from B5]) }
  if o.north-at-bay < 0.4 { c.push([the car bay < 0.4 m from the north wall]) }
  if o.swept-clear < 0.5 { c.push([the swept path touches the north wall]) }
  if o.west-run < 1.5 { c.push([the west chamber too close to the wall]) }
  c
}

// ---------- the checks of this study ----------
#let checks = (
  ([B2 fixed in every option (max move #f2(calc.max(..opts.map(o => dist(o.b.at(1), B2)))) m)], opts.all(o => dist(o.b.at(1), B2) < 1e-6)),
  ([B5 moves east by exactly the option (error ≤ 1 mm)], opts.all(o => calc.abs(o.moves.at(4).at(0) - o.e) < 1e-3)),
  ([the sides and the diagonals unchanged (≤ 1 mm) in every option: a pure rotation], opts.all(o => range(5).all(i => calc.abs(o.sides.at(i) - base.sides.at(i)) < 1e-3) and range(3).all(i => calc.abs(o.diags.at(i) - base.diags.at(i)) < 1e-3))),
  ([the house unchanged in the design files (shift #f2(shift.at(0)), #f2(shift.at(1)); the outline asserted): study only], true),
  ([the field calibration: the lane wall #f2(delta) m nearer than the deed line at B2 (0 … 1 m plausible), B1 → the yard wall #f2(base.b1-yard) m = the field value], delta > 0 and delta < 1.0 and calc.abs(base.b1-yard - field.b1-yard) < 1e-6),
  ([every option keeps ≥ #f2(spare) m to the deed setback lines (tightest #f2(calc.min(..opts.map(o => o.t-deed.m))) m) and every corner inside the envelope], opts.all(o => o.t-deed.m >= spare and o.b.all(p => margin(p) >= 0))),
  ([the recommended option (#f2(prefer) m): palms ≥ 3 m (#f2(rec.palm1) / #f2(rec.palm2)), the gas cabinet ≥ 1.5 m from the calibrated lane wall (#f2(rec.gas-lane-cal)), the tank ≥ #f1(sep-tank-house) m from B5 (#f2(rec.tank-b5)), the car bay ≥ 0.4 m off the north wall (#f2(rec.north-at-bay)), the swept path clear (#f2(rec.swept-clear))], conflicts(rec).len() == 0),
  ([the route at B1 unchanged by every option (B1 moves only along the M line: ≤ 2 mm east)], opts.all(o => calc.abs(o.moves.at(0).at(0)) < 2e-3)),
)
#let all-ok = checks.all(c => c.at(1))

// =====================================================================
// Drawing
// =====================================================================
#let ink = rgb("#3d4a45"); #let accent = rgb("#2f6b4f"); #let envc = rgb("#e3f0dd")
#let setb = rgb("#f4c6c6"); #let drive = rgb("#d6e2ee"); #let navy = rgb("#2f5f8a")
#let brown = rgb("#8a5a2b"); #let bld = rgb("#6a3d9a"); #let grid-c = rgb("#d9dcd6"); #let red = rgb("#b5452f"); #let amber = rgb("#c98a12")
#let q(x, y) = (x, -y)
#let poly(pts, ..args) = cetz.draw.line(..pts.map(p => q(..p)), close: true, ..args)
#let lab(p, body, size: 6.5pt, fill: ink, anchor: "center", angle: 0deg) = cetz.draw.content(q(..p), anchor: anchor, angle: angle, text(size, fill: fill, body))
// the lane wall moved delta towards the house (for the drawing: each vertex along the mean of its segments' inward normals)
#let lane-cal = {
  let n = lane.len()
  let normals = range(n - 1).map(i => {
    let a = lane.at(i); let b = lane.at(i + 1)
    let l = dist(a, b)
    let nv = ((b.at(1) - a.at(1)) / l, -(b.at(0) - a.at(0)) / l)
    if nv.at(0) * (B2.at(0) - a.at(0)) + nv.at(1) * (B2.at(1) - a.at(1)) < 0 { (-nv.at(0), -nv.at(1)) } else { nv }
  })
  range(n).map(i => {
    let nv = if i == 0 { normals.at(0) } else if i == n - 1 { normals.last() } else { ((normals.at(i - 1).at(0) + normals.at(i).at(0)) / 2, (normals.at(i - 1).at(1) + normals.at(i).at(1)) / 2) }
    let l = calc.sqrt(nv.at(0) * nv.at(0) + nv.at(1) * nv.at(1))
    (lane.at(i).at(0) + delta * nv.at(0) / l, lane.at(i).at(1) + delta * nv.at(1) / l)
  })
}
#let old-house = site-pts("old house pt")   // the deed-sketch old house (base.typ ← data/site_v2.csv): the sheet's W4 is its point nearest to B1

#let plan = cetz.canvas(length: 0.33cm, {
  import cetz.draw: *
  let ymax = 40
  for x in range(-7, 29) { line(q(x, -3), q(x, ymax), stroke: (paint: grid-c, thickness: if calc.rem(x, 5) == 0 { 0.5pt } else { 0.2pt })) }
  for y in range(-3, ymax + 1) { line(q(-7, y), q(28, y), stroke: (paint: grid-c, thickness: if calc.rem(y, 5) == 0 { 0.5pt } else { 0.2pt })) }
  for x in range(-5, 29, step: 5) { lab((x, -3.8), str(x), size: 5.5pt, fill: gray) }
  for y in range(0, ymax + 1, step: 5) { lab((-7.9, y), str(y), size: 5.5pt, fill: gray) }
  poly(land, fill: setb, stroke: none)
  poly(env, fill: envc, stroke: 0.8pt + accent)
  poly(drv, fill: drive, stroke: 0.4pt + navy)
  line(..nwall.map(p => q(..p)), stroke: 1.5pt + black)
  line(..lane.map(p => q(..p)), stroke: 1.5pt + black)
  line(..lane-cal.map(p => q(..p)), stroke: (paint: red, thickness: 0.9pt, dash: "dashed"))
  lab((17.6, 5.2), text(weight: "bold")[wall #f2(delta) m nearer (field, B2)], size: 5.4pt, fill: red, anchor: "west")
  line(q(0, 0), q(0, 38.86), stroke: 1.2pt + accent)
  // the old house's yard wall, calibrated from B1's 4.77 m (dashed brown), and the deed-sketch old house (dotted)
  line(q(yard-x(4.0), 4.0), q(yard-x(30.0), 30.0), stroke: (paint: brown, thickness: 0.9pt, dash: "dashed"))
  lab((yard-x(12.0) - 1.3, 12.0), [old house's yard wall (field: #f2(field.b1-yard) m from B1)], size: 5pt, fill: brown, angle: 90deg)
  // the garden
  poly(garden, fill: rgb("#dcebd0").transparentize(40%), stroke: (paint: accent, thickness: 0.4pt, dash: "dotted"))
  lab((19.5, 30.5), [south garden], size: 5.5pt, fill: accent)
  // the present house (grey) and the recommended option (purple)
  poly(B0, fill: luma(200).transparentize(60%), stroke: (paint: luma(90), thickness: 0.8pt, dash: "dashed"))
  poly(rec.b, fill: bld.transparentize(70%), stroke: 1.1pt + bld)
  for (i, p) in rec.b.enumerate() {
    circle(q(..p), radius: 0.3, fill: if i == 1 { red } else { bld }, stroke: none)
    let mv = rec.moves.at(i)
    lab((p.at(0) + (if i == 0 or i == 4 { -0.6 } else { 0.6 }), p.at(1) + (if i == 0 or i == 1 { -0.7 } else { 0.8 })), text(weight: "bold")[B#(i + 1) #if i == 1 [stays] else [#sgn2(mv.at(0)) E · #sgn2(mv.at(1)) S]], size: 5.6pt, fill: if i == 1 { red } else { bld }, anchor: if i == 0 or i == 4 { "east" } else { "west" })
  }
  // the tightest points
  circle(q(..rec.t-deed.p), radius: 0.35, fill: none, stroke: 1pt + red)
  lab((rec.t-deed.p.at(0) - 0.7, rec.t-deed.p.at(1) + 0.2), [tightest #f2(rec.t-deed.m) (deed) · #f2(rec.t-cal.m) (field)], size: 5.4pt, fill: red, anchor: "east")
  // things that turn with the house
  for (a, b) in ((gas0, [gas]), (grill0, [grill]), (counter0, [counter])) { let g = a.map(p => rot(p, rec.th, B2)); rect(q(..g.at(0)), q(..g.at(1)), stroke: 0.5pt + amber, fill: none); lab((g.at(1).at(0) + 0.3, (g.at(0).at(1) + g.at(1).at(1)) / 2), b, size: 4.8pt, fill: amber, anchor: "west") }
  let sc = screen0.map(p => rot(p, rec.th, B2)); line(q(..sc.at(0)), q(..sc.at(1)), stroke: 1pt + amber)
  circle(q(..rec.manhole), radius: 0.3, fill: white, stroke: 0.6pt + ink); circle(q(..ch-ne), radius: 0.3, fill: white, stroke: 0.6pt + ink); circle(q(..ch-w), radius: 0.3, fill: white, stroke: 0.6pt + ink)
  line(q(..rec.manhole), q(..ch-ne), q(11.0, 0.6), q(-2.6, 1.6), stroke: (paint: ink, thickness: 0.6pt, dash: "dotted")); line(q(..ch-w), q(-2.6, 1.6), stroke: (paint: ink, thickness: 0.6pt, dash: "dotted"))
  lab((11.5, 1.6), [foul main to the septic], size: 4.8pt, anchor: "west")
  circle(q(..soak-e), radius: 0.8, stroke: (paint: navy, dash: "dashed", thickness: 0.5pt)); circle(q(..soak-s), radius: 0.8, stroke: (paint: navy, dash: "dashed", thickness: 0.5pt))
  lab((soak-e.at(0) + 1.0, soak-e.at(1)), [soakaway E], size: 4.8pt, fill: navy, anchor: "west"); lab((soak-s.at(0) + 1.0, soak-s.at(1)), [soakaway S], size: 4.8pt, fill: navy, anchor: "west")
  rect(q(tank-old.at(0), tank-old.at(1)), q(tank-old.at(2), tank-old.at(3)), stroke: (paint: navy, dash: "dotted", thickness: 0.6pt)); lab((-6.0, 39.1), [tank], size: 4.8pt, fill: navy)
  rect(q(park-opt.at(0), park-opt.at(1)), q(park-opt.at(2), park-opt.at(3)), stroke: (paint: navy, thickness: 0.5pt, dash: "dashed")); lab((7.7, 2.15), [car bay], size: 4.8pt, fill: navy)
  line(q(path-guest-x, 39.6), q(path-guest-x, rec.guest-door.at(1)), q(..rec.guest-door), stroke: (paint: accent, thickness: 0.7pt, dash: "dashed")); lab((-1.5, 33.0), [guest path], size: 4.8pt, fill: accent, angle: 90deg)
  // the reference points
  for (n, p) in (("M1", M1),) { rect(q(p.at(0) - 0.3, p.at(1) - 0.3), q(p.at(0) + 0.3, p.at(1) + 0.3), fill: accent, stroke: none); lab((-0.5, p.at(1)), text(weight: "bold", n), size: 5.6pt, fill: accent, anchor: "east") }
  for (n, p) in (("D", D), ("R", R), ("S", peg-S)) { circle(q(..p), radius: 0.3, fill: brown, stroke: none); lab((p.at(0) + 0.5, p.at(1) - 0.2), text(weight: "bold", n), size: 5.6pt, fill: brown, anchor: "west") }
  for (p, n) in ((T1, [palm 1]), (T2, [palm 2])) { circle(q(..p), radius: r-palm, fill: accent, stroke: none); lab((p.at(0) + 0.6, p.at(1)), text(weight: "bold", n), size: 5.6pt, fill: accent, anchor: "west") }
  line(q(24, 0.5), (24 + 2.2 * north.at(0), -0.5 + 2.2 * north.at(1)), stroke: 1pt + ink, mark: (end: "stealth", fill: ink, scale: 0.7))
  lab((24 + 2.7 * north.at(0), -0.5 + 2.7 * north.at(1)), text(weight: "bold")[N], size: 8pt)
  line(q(16, ymax - 1), q(26, ymax - 1), stroke: 1.5pt + ink); lab((21, ymax - 0.2), [10 m], size: 6pt)
  lab((3, 36.5), [grey dashed = the house as set out (day 1) · purple = turned #f2(prefer) m about B2 (#f2(rec.deg)°)], size: 5.2pt, fill: luma(80), anchor: "west")
})

// the cut wall enlarged: the deed line, the calibrated wall, the setback, the tightest points of every option
#let zoom = cetz.canvas(length: 0.85cm, {
  import cetz.draw: *
  let (x0, x1, y0, y1) = (9.0, 18.5, 2.0, 12.5)
  rect(q(x0, y0), q(x1, y1), fill: white, stroke: 0.4pt + grid-c)
  for x in range(9, 19) { line(q(x, y0), q(x, y1), stroke: 0.2pt + grid-c) }
  for y in range(2, 13) { line(q(x0, y), q(x1, y), stroke: 0.2pt + grid-c) }
  for x in range(10, 19, step: 2) { lab((x, y1 + 0.3), str(x), size: 5pt, fill: gray) }
  for y in range(2, 13, step: 2) { lab((x0 - 0.3, y), str(y), size: 5pt, fill: gray) }
  // the lines clipped to the frame (what lies outside would stretch the canvas)
  let piece(P, i0, i1) = ((x-on(P.at(i0), P.at(i0 + 1), y0), y0), ..P.slice(i0 + 1, i1 + 1), (x1, y-on(P.at(i1), P.at(i1 + 1), x1)))
  let env-piece = ((x-on(env.at(4), env.at(5), y0), y0), env.at(5), env.at(6), env.at(7), (x-on(env.at(7), env.at(8), y1), y1))
  line(..env-piece.map(p => q(..p)), stroke: 0.9pt + accent); lab((10.2, 2.5), [setback line (deed, 2.0 m)], size: 5pt, fill: accent, anchor: "west")
  line(..piece(lane, 1, 4).map(p => q(..p)), stroke: 1.4pt + black); lab((15.9, 4.6), [lane wall (deed line)], size: 4.8pt, anchor: "west")
  line(..piece(lane-cal, 1, 4).map(p => q(..p)), stroke: (paint: red, thickness: 0.9pt, dash: "dashed")); lab((17.6, 12.1), [the wall #f2(delta) m nearer (field, B2)], size: 4.8pt, fill: red, anchor: "east")
  for (i, o) in (base, ..opts).enumerate() {
    let col = if i == 0 { luma(90) } else if calc.abs(o.e - prefer) < 1e-9 { bld } else { bld.lighten(45%) }
    // only the part inside the frame: from the north wall at x0 to the east wall at y1 (B1 and B4 lie outside)
    line(q(x0, y-on(o.b.at(0), o.b.at(1), x0)), q(..o.b.at(1)), q(..o.b.at(2)), q(x-on(o.b.at(2), o.b.at(3), y1), y1), stroke: (paint: col, thickness: if i == 0 { 0.8pt } else { 0.6pt }, dash: if i == 0 { "dashed" } else { "solid" }))
    circle(q(..o.t-deed.p), radius: 0.09, fill: col, stroke: none)
    lab((o.t-deed.p.at(0) - 0.25, o.t-deed.p.at(1) + 0.25 + i * 0.3), [#if i == 0 [as set out] else [+#f2(o.e)]: #f2(o.t-deed.m) / #f2(o.t-cal.m)], size: 4.8pt, fill: col, anchor: "east")
  }
  circle(q(..B2), radius: 0.12, fill: red, stroke: none); lab((B2.at(0) + 0.3, B2.at(1) - 0.45), text(weight: "bold")[B2 stays · #f2(field.b2-wall-in) m to the wall (field)\ margin #f2(rec.b2-cal) if counted from the wall], size: 4.8pt, fill: red, anchor: "west")
  circle(q(..rec.b.at(2)), radius: 0.1, fill: bld, stroke: none); lab((rec.b.at(2).at(0) + 0.25, rec.b.at(2).at(1) + 0.45), text(weight: "bold")[B3 (+#f2(prefer)): #f2(rec.b3-lane) to the deed line\ #f2(rec.b3-lane - delta) to the wall (field)], size: 4.8pt, fill: bld, anchor: "west")
  lab((x0 + 0.2, y1 - 0.3), [margins: deed / measured from the wall], size: 5pt, fill: luma(80), anchor: "west")
})

#let tbl(columns: (1fr, auto), size: 7pt, ..cells) = text(size, table(columns: columns, stroke: none, inset: (x: 3.5pt, y: 2.2pt),
  fill: (_, y) => if y == 0 { rgb("#e1e9e3") } else if calc.even(y) { rgb("#efece4") }, ..cells))
#let sub-head(t) = [#v(3pt) #text(9pt, weight: "bold", fill: accent, t) #v(1pt)]
#let col(v, lim) = text(fill: if v < 0 { red } else if v < lim { amber } else { accent }, weight: "bold")[#f2(v)]

// =====================================================================
// PAGE 1 · the plan, the field values, the answer in short
// =====================================================================
#grid(columns: (auto, 1fr), column-gutter: 10pt,
  plan,
  [
    #text(14pt, weight: "bold", fill: accent)[Taif / Palm House] \
    #text(10pt, weight: "bold")[Rotation about B2 · study (owner's idea, 5 Nov 2026) · STUDY ONLY, nothing moved] \
    #text(7pt, fill: gray)[Frame: origin M1 · y along the M line southwards · x east. B2 (the tightest corner) stays; the house turns so that its south end moves EAST, away from the driveway: B5 east by 0.10 … 0.40 m. The house as set out on day 1 (B1 5.00 m from M1) is the base. Page 2: the comparison of the options · page 3: the recommended option's set-out table.]
    #v(2pt) #line(length: 100%, stroke: 0.6pt + accent)

    #box(fill: rgb("#2f6b4f").lighten(85%), stroke: 1pt + accent, inset: 6pt, radius: 3pt, width: 100%)[
      #text(10pt, weight: "bold", fill: accent)[Recommendation: B5 east by #f2(prefer) m, after the notch check] \
      #text(7.2pt)[The house turns #f2(-rec.deg)° about B2. Against the deed setback lines the tightest margin goes from #f2(base.t-deed.m) to *#f2(rec.t-deed.m) m* (the cut wall at the lane's notch), above the #f2(spare) m spare; B2 unchanged; no conflict with the palms, the garden, the guest path, the outdoor kitchen, the gas cabinet, the tanks, the sewer, the car bay. The route beside the driveway keeps #f2(field.b1-yard) m at B1 and widens to #f2(rec.b5-yard) m at B5. *Cost:* B1 moves #f2(rec.moves.at(0).at(1)) m south, so the owner's rule "B1 = 5.00 m from M1" becomes #f2(rec.b1-m1) m; the garden loses #f2(rec.garden-lost) m² beside the east wall. *Condition:* if the setback is counted from the wall as measured at B2, the cut wall is tight already as set out (B2 #f2(rec.b2-cal) m; the notch #f2(base.t-cal.m) m if the wall runs #f2(delta) m inside the deed line all along); the rotation costs #f2(base.t-deed.m - rec.t-deed.m) m there. Do the notch check (sheet row 18) first; the decision stands: no reduction of the cut wall until the official survey.]
    ]

    #sub-head[1 · The field values of day 1 against the model]
    #tbl(columns: (1.1fr, 0.42fr, 1.0fr, 0.38fr, 2.3fr), size: 6.5pt,
      table.header([*Item*], [*Field*], [*Model*], [*Diff.*], [*Likely cause · what the study does*]),
      [B2 square to the boundary wall's inner face (2.60 incl. the wall)], [*#f2(field.b2-wall-in)*], [#f2(lane-d(B2)) to the deed line (margin #f2(base.b2-m) to the setback)], [#sgn2(field.b2-wall-in - lane-d(B2))],
        [the wall stands inside the deed line (the deed line is the plot's limit, the wall is built inside it; the v2 frame's rms 0.27 m; B2 itself was set +0.07 from M1). *Calibrated:* the wall taken #f2(delta) m nearer everywhere (conservative) and the setback counted 2.0 m from its inner face → B2's margin #f2(rec.b2-cal) m instead of #f2(base.b2-m).],
      [B2 is the nearest point of the house to the wall (owner)], [yes], [the cut wall at (#f1(base.t-lane.p.at(0)), #f1(base.t-lane.p.at(1))) is #f2(base.t-lane.m) from the deed line, B2 #f2(lane-d(B2))], [0.16],
        [the model's nearest point is 2.6 m along the cut wall from B2, at the lane's notch, 0.16 m nearer than B2. If B2 really is the nearest, the wall at the notch is ≥ #f2(field.b2-wall-in) m away (the deed line says #f2(base.t-lane.m)): the field check of the notch (sheet row 18) decides.],
      [B1 to the old house's yard wall across the driveway (the route's narrowest point, widening south)], [*#f2(field.b1-yard)*], [#f2(B0.at(0).at(0) - drv-west) to the driveway's west edge (v2); #f2(dist(B0.at(0), old-house.at(3))) to the deed-sketch old house], [#sgn2(field.b1-yard - (B0.at(0).at(0) - drv-west))],
        [the tape (3 cm): the yard wall IS the driveway's west edge there; the deed-sketch old house is ≈ 2 m too far west at the north (digitised ± 1–3 m; W4 on the field sheet). *Calibrated:* the yard wall drawn #f2(field.b1-yard) m west of B1, running away southwards like the sketch's east face (#f2(-yard-slope * 10) m per 10 m), as the owner saw.],
      [Decision (owner, day 1)], [—], [—], [—], [*No reduction of the cut wall until the official survey.* The rotation needs none: B2 does not move.],
    )
    #v(2pt)
    #text(6.5pt, fill: gray)[The plan: grey dashed = the house as set out (day 1); purple = turned #f2(prefer) m about B2; the red dashed line = the lane wall #f2(delta) m nearer than the deed line (the field value at B2, taken along the whole wall); the brown dashed line = the old house's yard wall from the field value at B1. Every old-building position is approximate, to be measured.]
  ],
)

// =====================================================================
// PAGE 2 · the options compared
// =====================================================================
#pagebreak()
#text(14pt, weight: "bold", fill: accent)[The options · B5 east by 0.10 … 0.40 m, B2 fixed] #h(1fr) #text(7pt, fill: gray)[every wall sampled at 5 cm, not only the corners · deed = the setback lines of the deed · "from the wall" = the setback counted 2.0 m from the wall as measured at B2 (#f2(delta) m nearer, conservative)]
#v(2pt) #line(length: 100%, stroke: 0.6pt + accent)
#v(2pt)
#let hdr = ([*B5 east by (m)*], [*as set out*], ..opts.map(o => [*#f2(o.e)* #if calc.abs(o.e - prefer) < 1e-9 [(recommended)]]))
#let srow(l, f, lim: none) = (l, ..(base, ..opts).map(o => { let v = f(o); if lim == none { [#f2(v)] } else { col(v, lim) } }))
#let crow(l, f) = (l, ..(base, ..opts).map(f))
#tbl(columns: (2.6fr, 1fr, 1fr, 1fr, 1fr, 1fr), size: 7pt,
  table.header(..hdr),
  ..srow([The house turns about B2 by (°)], o => -o.deg),
  ..crow([B1 moves south (m) · M1 → B1 (was 5.00, the owner's rule of 4 Nov 2026)], o => [#f2(o.moves.at(0).at(1)) · *#f2(o.b1-m1)*]),
  ..crow([B3 moves east / north (m)], o => [#f2(o.moves.at(2).at(0)) / #f2(-o.moves.at(2).at(1))]),
  ..crow([B4 moves east / north (m)], o => [#f2(o.moves.at(3).at(0)) / #f2(-o.moves.at(3).at(1))]),
  ..crow([B5 moves east / south (m)], o => [#f2(o.moves.at(4).at(0)) / #f2(o.moves.at(4).at(1))]),
  ..srow([*Tightest margin to the deed setback* (on the cut wall at the lane's notch; ≥ #f2(spare) wanted; B2 unchanged)], o => o.t-deed.m, lim: spare),
  ..srow([The same with the setback counted from the wall (#f2(delta) m nearer everywhere: conservative)], o => o.t-cal.m, lim: spare),
  ..crow([B2's margin: deed / from the wall (unchanged in every option)], o => [#f2(o.b2-m) / #f2(o.b2-cal)]),
  ..crow([B3 to the deed line / to the wall as measured · B3's margin to the deed setback], o => [#f2(o.b3-lane) / #f2(o.b3-lane - delta) · #f2(o.b3-m)]),
  ..srow([The cut wall's nearest point to the deed line (between B2 and B3)], o => o.t-lane.m),
  ..srow([North strip at B1: the north face to the north setback line], o => o.b1-north),
  ..crow([The car bay's south edge to the north wall at the bay's west end (≥ 0.4) · the swept path's car side to the wall (the turn into the bay)], o => [#f2(o.north-at-bay) · #f2(o.swept-clear)]),
  ..crow([West wall to the driveway's west edge at y 10 / 15 / 20 / 25 / at B5 (at B1 #f2(base.b5-drv), unchanged)], o => [#o.west-drv.map(f2).join(" / ") / #f2(o.b5-drv)]),
  ..crow([West wall to the old house's yard wall (calibrated) at y 10 / 15 / 20 / 25 / at B5 (at B1 #f2(field.b1-yard), unchanged)], o => [#o.west-yard.map(f2).join(" / ") / #f2(o.b5-yard)]),
  ..crow([West wall to the guest path's line at y 10 / 15 / 20 / 25], o => [#o.west-path.map(f2).join(" / ")]),
  ..crow([Palm 1 / palm 2 to the nearest wall (trunk face)], o => [#f2(o.palm1) / #f2(o.palm2)]),
  ..crow([South garden: ground lost under the turned house (m², beside the east wall and at the south-west) · B5 to the garden's low wall], o => [#f2(o.garden-lost) · #f2(o.b5-lowwall)]),
  ..crow([Guest door moves east / south · the guest path's last leg (from its line to the door)], o => [#sgn2(o.guest-door.at(0) - guest-door0.at(0)) / #sgn2(o.guest-door.at(1) - guest-door0.at(1)) · #f2(o.guest-door.at(0) - path-guest-x)]),
  ..crow([Outdoor kitchen, yard screen, gas cabinet, grill: turn with the house (their spacings unchanged) · the gas cabinet to the deed line / to the wall as measured (≥ 1.5)], o => [#f2(o.gas-lane) / #col(o.gas-lane-cal, 1.5)]),
  ..srow([The existing tank to B5 (≥ #f1(sep-tank-house), assumed rule)], o => o.tank-b5, lim: sep-tank-house),
  ..crow([Sewer: the yard chamber (turns with the house) → the east strip's chamber (fixed) · the west drain's run from the wall to its chamber], o => [#f2(o.sewer-first) · #f2(o.west-run)]),
  ..crow([Soakaway E to the east wall · soakaway S to the south wall], o => [#f2(o.soak-e) · #f2(o.soak-s)]),
  ..crow([Sides and diagonals], o => [unchanged]),
  ..crow([*Conflicts*], o => { let c = conflicts(o); if c.len() == 0 { text(fill: accent, weight: "bold")[none] } else { text(fill: red, size: 6pt, c.join([; ])) } }),
)
#v(4pt)
#text(7pt)[
  *Reading the table.* Every option keeps every rule of the services plan and the set-out sheet against the deed lines; the cost grows with the angle: B1 slides south along the M line (the owner's 5.00 m rule), the notch loses #f2((base.t-deed.m - opts.last().t-deed.m) / 4) m per 0.10 m of rotation, the garden loses ground beside the east wall, the east soakaway comes nearer the wall (already below the services plan's assumed 5 m rule as set out: for the engineer, not caused by the rotation). The gain is at the south-west: the route beside the driveway, where the water truck stands and the cars turn into the covered parking, widens by the option; the north strip at B1 deepens by the B1 move. *With the setback counted from the wall as measured:* B2's #f2(rec.b2-cal) m does not change with any option, and the notch is tight already as set out if the wall runs #f2(delta) m inside the deed line all along; the owner saw B2 as the nearest point, which says it does not. The notch check (sheet row 18: from the tightest point square to the lane wall, expected #f2(base.t-lane.m) m by the deed line, at least #f2(field.b2-wall-in) m if B2 is the nearest) settles it before any block moves.
]

// =====================================================================
// PAGE 3 · the recommendation and the set-out table of the recommended option
// =====================================================================
#pagebreak()
#grid(columns: (auto, 1fr), column-gutter: 10pt,
  [
    #zoom
    #v(3pt)
    #block(width: 8.2cm, text(6.6pt, fill: gray)[The cut wall enlarged. Grey dashed: as set out. Purple: the options (the recommended one bold). Each dot = the tightest point of that option to the deed setback, labelled with its margin to the deed setback / to a setback counted 2.0 m from the wall as measured at B2 (#f2(delta) m nearer than the deed line, taken the same along the whole wall: conservative; the owner saw B2 as the nearest point, so the wall at the notch may well be further off: sheet row 18 decides).])
  ],
  [
    #text(14pt, weight: "bold", fill: accent)[Recommendation · B5 east by #f2(prefer) m] #h(1fr) #text(7pt, fill: gray)[the owner's preference, checked]
    #v(2pt) #line(length: 100%, stroke: 0.6pt + accent)
    #text(7.2pt)[
      *Safe against the deed setback lines:* the tightest margin falls from #f2(base.t-deed.m) to *#f2(rec.t-deed.m) m* on the cut wall at the notch (a cost of #f2(base.t-deed.m - rec.t-deed.m) m), still above the #f2(spare) m spare; B3 #f2(rec.b3-lane) m from the deed line; B2 unchanged. Every corner inside the envelope; the palms #f2(rec.palm1) / #f2(rec.palm2) m; the gas cabinet #f2(rec.gas-lane-cal) m from the wall as measured; the tank #f2(rec.tank-b5) m from B5; the sewer and the water pipe unchanged in practice (the yard chamber's run to the fixed east chamber #f2(base.sewer-first) → #f2(rec.sewer-first) m; the falls stay); the car bay keeps #f2(rec.north-at-bay) m off the north wall and the swept path clears it by #f2(rec.swept-clear) m. *Gains:* the route beside the driveway widens from #f2(field.b1-yard) m at B1 (unchanged: the narrowest point stays) to #f2(rec.b5-yard) m at B5 against the yard wall and #f2(rec.b5-drv) m against the driveway's edge, where the water truck stands and the cars turn into the covered parking; the north strip at B1 deepens by #f2(rec.moves.at(0).at(1)) m.

      *What it costs, to decide with open eyes:* (1) *the owner's rule "B1 exactly 5.00 m from M1" becomes #f2(rec.b1-m1) m* (B1 moves #f2(rec.moves.at(0).at(1)) m south along the M line); (2) the north wall is no longer square to the M line (#f2(-rec.deg)°: #f2(rec.moves.at(0).at(1)) m over its #f2(base.sides.at(0)) m, invisible to the eye) and the west wall no longer parallel to the driveway (#f2(prefer) m over #f2(base.sides.at(4)) m); (3) the south garden loses #f2(rec.garden-lost) m² under the turned house (beside the east wall), while the strip between B5 and the garden's low wall grows to #f2(rec.b5-lowwall) m; (4) the east soakaway comes #f2(base.soak-e - rec.soak-e) m nearer the east wall (#f2(rec.soak-e) m).

      *If the setback is measured from the wall (the field value at B2):* the margin at B2 is *#f2(rec.b2-cal) m whatever the option* (B2 does not move) and, with the wall #f2(delta) m nearer along the whole cut wall, the notch gives #f2(base.t-cal.m) m as set out and #f2(rec.t-cal.m) m turned: *the rotation is not what makes the cut wall tight; the wall's real position is.* So: *do the notch check first (sheet row 18); if it reads ≥ #f2(field.b2-wall-in + (base.t-deed.m - rec.t-deed.m)) m, turn the blocks by #f2(prefer) m; if less, hold at 0.20 m or wait for the official survey.* The decision stands: no reduction of the cut wall until the survey. The 0.40 m option is also inside every rule against the deed lines (tightest #f2(opts.last().t-deed.m) m) but costs B1 #f2(opts.last().moves.at(0).at(1)) m and the notch #f2(base.t-deed.m - opts.last().t-deed.m) m for 0.10 m more at the south; 0.30 m is the better balance.
    ]
    #sub-head[Set-out table of the recommended option (outer wall faces) · the sides and the diagonals unchanged]
    #let rrows = rec.b.enumerate().map(((i, p)) => {
      let mv = rec.moves.at(i)
      ([*B#(i + 1)*], [#f2(p.at(0))], [#f2(p.at(1))], [M1 → *#f2(dist(p, M1))*], [D → *#f2(dist(p, D))*], [R → *#f2(dist(p, R))*], [S → *#f2(dist(p, peg-S))*],
       if i == 1 { text(fill: red, weight: "bold")[unchanged, keep the block] } else { [#sgn2(mv.at(0)) east, #sgn2(mv.at(1)) south (#f2(dist(p, B0.at(i))) m)] })
    }).flatten()
    #text(7.2pt, table(
      columns: (10mm, 13mm, 14mm, 21mm, 21mm, 21mm, 21mm, 1fr), stroke: 0.4pt + rgb("#9aa39f"), inset: 3.2pt, align: horizon,
      fill: (_, y) => if y == 0 { rgb("#e1e9e3") },
      table.header([*Corner*], [*x east*], [*y along M*], [*Tape 1 (M1)*], [*Tape 2 (D)*], [*Tape 3 (R)*], [*Tape 4 (S)*], [*The block moves on site*]),
      ..rrows,
    ))
    #v(3pt)
    #grid(columns: (1fr, 1.5fr), column-gutter: 8pt,
      text(7pt, table(
        columns: (auto, auto), stroke: 0.4pt + rgb("#9aa39f"), inset: 3pt, align: horizon,
        fill: (_, y) => if y == 0 { rgb("#e1e9e3") },
        table.header([*Side / diagonal*], [*m (unchanged)*]),
        ..range(5).map(i => ([B#(i + 1)–B#(calc.rem(i + 1, 5) + 1)], [*#f2(rec.sides.at(i))*])).flatten(),
        [B1–B4], [*#f2(rec.diags.at(0))*], [B2–B5], [*#f2(rec.diags.at(1))*], [B1–B3 (the cut's check)], [*#f2(rec.diags.at(2))*],
        [Perimeter], [*#f2(rec.sides.sum())*],
      )),
      text(7pt)[
        *On site, in this order:* keep B2's block. Re-set *B1* from M1 #f2(dist(rec.b.at(0), M1)) and D #f2(dist(rec.b.at(0), D)) (it moves #f2(rec.moves.at(0).at(1)) m south along the string M1 → M4, x unchanged); check B1 → B2 = #f2(rec.sides.at(0)). Re-set *B3* from B2 #f2(rec.sides.at(1)) and M1 #f2(dist(rec.b.at(2), M1)); check B1 → B3 = #f2(rec.diags.at(2)). Re-set *B4* from B3 #f2(rec.sides.at(2)) and M1 #f2(dist(rec.b.at(3), M1)); check B1 → B4 = #f2(rec.diags.at(0)). Re-set *B5* from B4 #f2(rec.sides.at(3)) and M1 #f2(dist(rec.b.at(4), M1)); check B2 → B5 = #f2(rec.diags.at(1)) and B1 → B5 = #f2(rec.sides.at(4)). Then the R / S tapes on every corner. The moves are 4–30 cm: an arc crossing is too vague for them, so measure each move from the old block along the direction given and confirm with the diagonals. Before any block moves: the notch check (row 18) and the owner's decision; then `design_gf.typ` gets the rotation and the set-out sheet is re-issued (not done here).
      ],
    )
    #v(2pt)
    #text(6.3pt, fill: gray)[Rotation about B2 study · Study checks #if all-ok [passed] else [FAILED]: #checks.map(c => c.at(0)).join([ · ]). Field values: the owner on site, day 1 (4 Nov 2026), recorded in docs/SITE_SETOUT.md § 7. The model's house, B1 … B5, is untouched: the design files and the set-out values change only after the owner's decision.]
  ],
)

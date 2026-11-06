// shift_south.typ · Taif / Palm House · STUDY: the whole house shifted SOUTH (no rotation, no west shift; the house unchanged) · 0.40 / 0.50 / 0.60 m (owner, 6 Nov 2026)
// STUDY ONLY: nothing in the design files, the house position or the set-out values changes here; the owner decides after reading the result.
// Field calibration (day 1): B2 2.40 m to the boundary wall's inner face (2.60 incl. the wall); the tightest point of the cut wall (sheet row 18, about 1 m before B3) 2.20–2.30 m
// to the wall's inner face (the model gives 2.92 to the deed line): the wall stands ≈ 0.6–0.7 m inside the deed line along the cut. B1 4.77 m to the old house's yard wall across the driveway.
// Every setback margin is given TWICE: from the deed line and from the wall as built (the municipality may count from the wall). Target: ≥ 0.40 m from the wall as built.
// Baseline rule: the current position (day 1, B1 5.00 m from M1) is the owner's preferred one; a move is recommended only if it is clearly better.
// Design frame: origin M1 (the gate's east post) · y along the M line southwards · x east. Concept only – not for permit.
#import "@preview/cetz:0.4.2"
#import "../base.typ": land, env, drv, lane, nwall, T1, T2, north, D, R, S as peg-S
#import "../design_gf.typ": shift, outline-csv-gf
#let shift = (0.91, 5.063)   // THE DAY-1 POSITION this study was made at (6 Nov 2026: the 0.50 m south of shift_south.typ was adopted, design_gf.typ now 5.563): the study stays as issued

#set page(paper: "a4", flipped: true, margin: 8mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 8pt)
#set par(leading: 0.4em)

// =====================================================================
// INPUT – the house as set out (nothing to edit here; the study never moves it)
// =====================================================================
#let S(p) = (p.at(0) + shift.at(0), p.at(1) + shift.at(1))
#let expected = ((0, 0), (10.051, 0), (13.311, 6.0), (13.311, 24.0), (0, 24.0))
// 6 Nov 2026: the cut wall was moved outwards 0.12 m (design_gf.typ); this study keeps the former outline it was made with
#let B0 = ((-0.125, -0.125), (10.125, -0.125), (13.436, 5.968), (13.436, 24.125), (-0.125, 24.125)).map(S)   // B1 NW, B2 cut north, B3 cut east, B4 SE, B5 SW (outer faces)
#let spare = 0.5                 // the spare wanted from the deed setback lines (setout_v83.typ)
#let target = 0.40               // the owner's target from the wall as built
#let setback-lane = 2.0
#let M1 = (0.0, 0.0)
#let r-palm = 0.265
#let drv-west = -3.95
#let drv-w = 3.95
#let cornice = 0.30              // the main cornice's projection (studies/roof.typ)
#let guest-band = 1.2            // the guest path: a 1.2 m honey-stone band on the driveway's east edge (site_plan.typ)
#let options = (0.40, 0.50, 0.60)
#let ground-ok = 0.50            // the owner checked on site: the ground allows up to about 0.50 m, possibly 0.60

// ---------- Field values, day 1 ----------
#let field = (b2-wall-in: 2.40, b2-wall-out: 2.60, notch-lo: 2.20, notch-hi: 2.30, b1-yard: 4.77)
#let yard-slope = (-8.0 - -6.0) / (28.5 - 6.5)

// ---------- Things attached to the house (site_plan.typ; they move with it) ----------
#let gas0 = (S((15.35, 7.8)), S((15.85, 8.8)))
#let screen0 = (S((15.2, 7.6)), S((15.3, 13.0)))
#let grill0 = (S((16.5, 12.6)), S((17.6, 13.8)))
#let manhole0 = S((14.3, 13.5))
#let guest-door0 = S((0, 22.2))
#let family-path-x = S((3.0, 0)).at(0) + 0.5
#let west-out0 = S((0, 10.675))
// ---------- Things fixed on the site ----------
#let park-opt = (5.2, 0.9, 10.2, 3.4)
#let swept-y = 2.15
#let swept-rev = ((-1.2, 5.0), (0.6, 3.2))
#let path-guest-x = -1.0
#let path-family-start = (-1.0, 2.6)
#let lowwall-x = 0.6
#let garden = ((0.9, 29.188), (14.35, 29.188), (14.35, 20.838), (22.5, 20.838), (26.74, 33.94), (0.9, 38.7))
#let tank-old = (-7.5, 35.7, -4.5, 38.2)
#let ch-w = (-2.4, 15.738); #let ch-ne = (16.0, 11.438); #let ch-n = (11.0, 0.6); #let ch-gate = (-2.6, 1.6); #let ch-wall = (-4.8, 1.7); #let septic-in = (-6.5, -0.7)
#let soak-e = (16.5, 15.738); #let soak-s = (10.0, 32.238)
#let sep-tank-house = 5.0
#let inv0 = -0.50; #let g-br = 0.015; #let g-main = 0.010; #let ch-drop = 0.03; #let br-e = 13.5   // the services plan's assumed falls
#let ground-gate = -0.40
// ---------- The rooms along the cut wall (CSV frame; data/rooms_gf.csv, rooms_ff.csv) ----------
#let tower-c = ((8.95, 0), (10.051, 0), (10.594, 1.0), (8.95, 1.0)).map(S)
#let maidbath-c = ((8.95, 1), (10.594, 1), (11.572, 2.8), (8.95, 2.8)).map(S)
#let maidroom-c = ((10.65, 2.8), (11.572, 2.8), (13.311, 6), (13.311, 7.0), (10.65, 7.0)).map(S)
#let bed1-c = ((8.95, 1), (10.594, 1), (13.311, 6), (13.311, 6.5), (10.15, 6.5), (10.15, 5.3), (8.95, 5.3))
#let b4-need = 3.84 + 1.9 + 10.0   // bedroom 1's hotel en-suite B4 (studies/bedroom1_bath.typ): clear area needed, and a rectangular bedroom

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
#let plen(P) = range(P.len() - 1).map(i => dist(P.at(i), P.at(i + 1))).sum()
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
// the calibration: the wall as built this much inside the deed line, from the two readings (B2 and the notch), the LOWER notch reading governing (conservative)
#let notch0 = tightest(B0, lane-d).p                       // the model's nearest point of the house to the lane line (the cut wall, 2.1 m before B3)
#let delta-b2 = lane-d(B0.at(1)) - field.b2-wall-in
#let delta-lo = lane-d(notch0) - field.notch-lo             // from the 2.20 reading (the wall furthest in)
#let delta-hi = lane-d(notch0) - field.notch-hi             // from the 2.30 reading
#let delta = calc.max(delta-b2, delta-lo)
#let margin-cal(p) = calc.min(margin(p), lane-d(p) - delta - setback-lane)
#let margin-cal-hi(p) = calc.min(margin(p), lane-d(p) - delta-hi - setback-lane)
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
#let f0(v) = str(calc.round(v))
#let sgn2(v) = if v >= 0.005 { "+" + f2(v) } else if v <= -0.005 { "−" + f2(-v) } else { "0" }
#let x-on(a, b, y) = a.at(0) + (y - a.at(1)) * (b.at(0) - a.at(0)) / (b.at(1) - a.at(1))
#let y-on(a, b, x) = a.at(1) + (x - a.at(0)) * (b.at(1) - a.at(1)) / (b.at(0) - a.at(0))
#let yard-x(y) = B0.at(0).at(0) - field.b1-yard + yard-slope * (y - B0.at(0).at(1))
#let nwall-y(x) = y-on(nwall.at(0), nwall.at(1), x)           // the farm's north boundary wall
#let box-dist(b, p) = { let dx = calc.max(b.at(0) - p.at(0), 0, p.at(0) - b.at(2)); let dy = calc.max(b.at(1) - p.at(1), 0, p.at(1) - b.at(3)); calc.sqrt(dx * dx + dy * dy) }
#let garden-area0 = area(garden) - area(clip(garden, B0))

// =====================================================================
// The measures of a position shifted s m south
// =====================================================================
#let ys = (10.0, 15.0, 20.0, 25.0)
#let cut-rooms = (tower: dist(S((10.051, 0)), S((10.594, 1.0))), bath: dist(S((10.594, 1.0)), S((11.572, 2.8))), maid: dist(S((11.572, 2.8)), S((13.311, 6.0))), bed1: dist(S((10.594, 1.0)), S((13.311, 6.0))))
#let bed1-clear0 = area(bed1-c) - 0.1 * (range(bed1-c.len()).map(i => dist(bed1-c.at(i), bed1-c.at(calc.rem(i + 1, bed1-c.len())))).sum())
#let cut-n = { let u = (B0.at(2).at(0) - B0.at(1).at(0), B0.at(2).at(1) - B0.at(1).at(1)); let l = calc.sqrt(u.at(0) * u.at(0) + u.at(1) * u.at(1)); (u.at(1) / l, -u.at(0) / l) }   // the cut wall's outward normal
#let cut-moved(b, d) = {   // the cut wall moved outwards by d: B2 slides east along the north wall, B3 north along the east wall
  let t2 = d / cut-n.at(0)
  let t3 = d / cut-n.at(1)
  (b.at(0), (b.at(1).at(0) + t2, b.at(1).at(1)), (b.at(2).at(0), b.at(2).at(1) + t3), b.at(3), b.at(4))
}
#let measure(s) = {
  let T(p) = (p.at(0), p.at(1) + s)
  let b = B0.map(T)
  let gas = gas0.map(T)
  let gas-pts = (gas.at(0), (gas.at(1).at(0), gas.at(0).at(1)), gas.at(1), (gas.at(0).at(0), gas.at(1).at(1)))
  let west(y) = x-on(b.at(0), b.at(4), y)
  let t-cal = tightest(b, margin-cal)
  let door = T(guest-door0)
  let mh = T(manhole0)
  // the sewer's east main: yard chamber → east strip chamber → north strip chamber → collector → wall chamber → the septic's inlet (site_plan.typ)
  let L = (dist(mh, ch-ne), dist(ch-ne, ch-n), dist(ch-n, ch-gate), dist(ch-gate, ch-wall), dist(ch-wall, septic-in))
  let inv-septic = (inv0 - g-br * br-e - ch-drop) - g-main * L.sum() - 4 * ch-drop
  // the cut wall's later shortening: the largest parallel move keeping the target from the wall as built (both readings)
  let d-lo = calc.max(0.0, t-cal.m - target)
  let d-hi = calc.max(0.0, tightest(b, margin-cal-hi).m - target)
  (
    s: s, b: b, T: T, t-deed: tightest(b, margin), t-cal: t-cal, t-cal-hi: tightest(b, margin-cal-hi), t-lane: tightest(b, lane-d),
    b2-m: margin(b.at(1)), b2-cal: margin-cal(b.at(1)), b3-lane: lane-d(b.at(2)),
    b1-m1: dist(b.at(0), M1), b1-north: margin(b.at(0)), north-depth: b.at(0).at(1) - nwall-y(b.at(0).at(0)),
    north-at-bay: y-on(b.at(0), b.at(1), park-opt.at(0)) - park-opt.at(3), swept-clear: y-on(b.at(0), b.at(1), park-opt.at(0)) - (swept-y + 0.9), swept-b1: pseg(b.at(0), ..swept-rev) - 0.9,
    fam-path: (family-path-x - path-family-start.at(0)) + (b.at(0).at(1) - path-family-start.at(1)),
    b1-drv: b.at(0).at(0) - drv-west, b5-drv: b.at(4).at(0) - drv-west, b1-yard: b.at(0).at(0) - yard-x(b.at(0).at(1)), b5-yard: b.at(4).at(0) - yard-x(b.at(4).at(1)), west-yard: ys.map(y => west(y) - yard-x(y)),
    strip: b.at(0).at(0), cornice-clear: b.at(0).at(0) - cornice,
    guest-door: door, guest-path: (39.6 - door.at(1)) + (door.at(0) - path-guest-x),
    palm1: edge-dist(T1, b) - r-palm, palm2: edge-dist(T2, b) - r-palm,
    garden: area(garden) - area(clip(garden, b)), garden-lost: area(clip(garden, b)) - area(clip(garden, B0)),
    gas-lane: calc.min(..gas-pts.map(lane-d)), gas-lane-cal: calc.min(..gas-pts.map(lane-d)) - delta,
    tank-b5: box-dist(tank-old, b.at(4)), sewer-L: L, sewer-len: L.sum(), inv-septic: inv-septic, west-run: dist(T(west-out0), ch-w),
    soak-e: pseg(soak-e, b.at(2), b.at(3)), soak-s: pseg(soak-s, b.at(3), b.at(4)),
    d-lo: d-lo, d-hi: d-hi, gain-lo: area(cut-moved(b, d-lo)) - area(b), gain-hi: area(cut-moved(b, d-hi)) - area(b),
    bed1-clear-hi: bed1-clear0 + d-hi * cut-rooms.bed1,
    sides: range(5).map(i => dist(b.at(i), b.at(calc.rem(i + 1, 5)))), diags: (dist(b.at(0), b.at(3)), dist(b.at(1), b.at(4)), dist(b.at(0), b.at(2))),
  )
}
#let conflicts(o) = {
  let c = ()
  if o.t-deed.m < spare { c.push([the tightest margin to the deed setback #f2(o.t-deed.m) < #f2(spare)]) }
  if o.b.any(p => margin(p) < 0) { c.push([a corner outside the envelope]) }
  if o.cornice-clear < 0 { c.push([the cornice over the driveway]) }
  if o.palm1 < 3 or o.palm2 < 3 { c.push([a palm closer than 3 m]) }
  if o.gas-lane-cal < 1.5 { c.push([the gas cabinet < 1.5 m from the wall as built]) }
  if o.tank-b5 < sep-tank-house { c.push([the tank < #f1(sep-tank-house) m from B5]) }
  if o.north-at-bay < 0.4 or o.swept-clear < 0.5 or o.swept-b1 < 0.2 { c.push([the car bay or the swept path touches the house]) }
  if o.inv-septic > -1.0 { c.push([the septic's inlet too high for the falls]) }
  if o.soak-s < 2.0 { c.push([the south soakaway < 2 m from the south wall]) }
  c
}
#let base = measure(0.0)
#let opts = options.map(measure)
#let rec = opts.find(o => o.t-cal.m >= target)                  // the smallest shift that reaches the target from the wall as built (the lower reading)
#let rec-ok = rec != none and rec.s <= ground-ok + 1e-9 and conflicts(rec).len() == 0

// ---------- the checks of this study ----------
#let checks = (
  ([the house unchanged in the design files (shift #f2(shift.at(0)), #f2(shift.at(1)); the outline asserted): study only], true),
  ([the calibration: the wall as built #f2(delta) m inside the deed line (B2's reading gives #f2(delta-b2), the notch's 2.20 / 2.30 give #f2(delta-lo) / #f2(delta-hi): consistent within 0.10)], calc.abs(delta-lo - delta-b2) <= 0.10 and delta > 0 and delta < 1.0),
  ([the current position measured as on site: the notch #f2(lane-d(notch0) - delta) m from the wall as built (= the 2.20 reading), B1 → the yard wall #f2(base.b1-yard) (= the field value)], calc.abs(lane-d(notch0) - delta - field.notch-lo) < 1e-6 and calc.abs(base.b1-yard - field.b1-yard) < 1e-6),
  ([every option: a pure shift south (x unchanged, the sides and the diagonals unchanged), the driveway's #f2(drv-w) m untouched (the cornice #f2(base.cornice-clear) m clear), every corner inside the envelope], opts.all(o => o.b.all(p => margin(p) >= 0) and range(5).all(i => calc.abs(o.b.at(i).at(0) - B0.at(i).at(0)) < 1e-9 and calc.abs(o.sides.at(i) - base.sides.at(i)) < 1e-6) and o.cornice-clear >= 0)),
  ([the recommended option (#if rec == none [none] else [#f2(rec.s) m]) reaches ≥ #f2(target) m from the wall as built at the lower reading (#if rec != none [#f2(rec.t-cal.m)]), lies within the ground the owner checked (≤ #f2(ground-ok)) and has no conflict], rec-ok),
  ([no option conflicts with the palms, the garden's low wall, the guest path, the car bay, the gas cabinet, the tanks, the sewer's falls or the soakaways], opts.all(o => conflicts(o).len() == 0)),
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
#let lane-cal = {
  let n = lane.len()
  let normals = range(n - 1).map(i => {
    let a = lane.at(i); let b = lane.at(i + 1)
    let l = dist(a, b)
    let nv = ((b.at(1) - a.at(1)) / l, -(b.at(0) - a.at(0)) / l)
    if nv.at(0) * (B0.at(1).at(0) - a.at(0)) + nv.at(1) * (B0.at(1).at(1) - a.at(1)) < 0 { (-nv.at(0), -nv.at(1)) } else { nv }
  })
  range(n).map(i => {
    let nv = if i == 0 { normals.at(0) } else if i == n - 1 { normals.last() } else { ((normals.at(i - 1).at(0) + normals.at(i).at(0)) / 2, (normals.at(i - 1).at(1) + normals.at(i).at(1)) / 2) }
    let l = calc.sqrt(nv.at(0) * nv.at(0) + nv.at(1) * nv.at(1))
    (lane.at(i).at(0) + delta * nv.at(0) / l, lane.at(i).at(1) + delta * nv.at(1) / l)
  })
}
#let plan(after, length: 0.235cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let ymax = 40
  for x in range(-7, 29) { line(q(x, -3), q(x, ymax), stroke: (paint: grid-c, thickness: if calc.rem(x, 5) == 0 { 0.5pt } else { 0.2pt })) }
  for y in range(-3, ymax + 1) { line(q(-7, y), q(28, y), stroke: (paint: grid-c, thickness: if calc.rem(y, 5) == 0 { 0.5pt } else { 0.2pt })) }
  for x in range(-5, 29, step: 5) { lab((x, -3.8), str(x), size: 5pt, fill: gray) }
  for y in range(0, ymax + 1, step: 5) { lab((-7.9, y), str(y), size: 5pt, fill: gray) }
  poly(land, fill: setb, stroke: none)
  poly(env, fill: envc, stroke: 0.8pt + accent)
  poly(drv, fill: drive, stroke: 0.4pt + navy)
  line(..nwall.map(p => q(..p)), stroke: 1.5pt + black)
  line(..lane.map(p => q(..p)), stroke: 1.5pt + black)
  line(..lane-cal.map(p => q(..p)), stroke: (paint: red, thickness: 0.9pt, dash: "dashed"))
  lab((17.6, 5.2), text(weight: "bold")[wall as built: #f2(delta) m inside the deed line (rows 18, 23)], size: 5pt, fill: red, anchor: "west")
  line(q(0, 0), q(0, 38.86), stroke: 1.2pt + accent)
  line(q(yard-x(4.0), 4.0), q(yard-x(30.0), 30.0), stroke: (paint: brown, thickness: 0.9pt, dash: "dashed"))
  lab((yard-x(12.0) - 1.3, 12.0), [old house's yard wall (field: #f2(field.b1-yard) m from B1)], size: 4.8pt, fill: brown, angle: 90deg)
  poly(garden, fill: rgb("#dcebd0").transparentize(40%), stroke: (paint: accent, thickness: 0.4pt, dash: "dotted"))
  poly(B0, fill: luma(200).transparentize(60%), stroke: (paint: luma(90), thickness: 0.8pt, dash: "dashed"))
  poly(after.b, fill: bld.transparentize(70%), stroke: 1.1pt + bld)
  for (i, p) in after.b.enumerate() {
    circle(q(..p), radius: 0.3, fill: bld, stroke: none)
    lab((p.at(0) + (if i == 0 or i == 4 { -0.6 } else { 0.6 }), p.at(1) + (if i == 0 or i == 1 { -0.7 } else { 0.8 })), text(weight: "bold")[B#(i + 1) +#f2(after.s) S], size: 5.4pt, fill: bld, anchor: if i == 0 or i == 4 { "east" } else { "west" })
  }
  circle(q(..after.t-cal.p), radius: 0.35, fill: none, stroke: 1pt + red)
  lab((after.t-cal.p.at(0) - 0.7, after.t-cal.p.at(1) + 0.2), [tightest: #f2(after.t-deed.m) deed · #f2(after.t-cal.m) wall], size: 5pt, fill: red, anchor: "east")
  let g = gas0.map(after.T); rect(q(..g.at(0)), q(..g.at(1)), stroke: 0.5pt + amber); lab((g.at(1).at(0) + 0.3, (g.at(0).at(1) + g.at(1).at(1)) / 2), [gas], size: 4.5pt, fill: amber, anchor: "west")
  let sc = screen0.map(after.T); line(q(..sc.at(0)), q(..sc.at(1)), stroke: 1pt + amber)
  let mh = (after.T)(manhole0)
  for c in (mh, ch-ne, ch-n, ch-gate, ch-w) { circle(q(..c), radius: 0.3, fill: white, stroke: 0.6pt + ink) }
  line(q(..mh), q(..ch-ne), q(..ch-n), q(..ch-gate), q(..ch-wall), q(..septic-in), stroke: (paint: ink, thickness: 0.6pt, dash: "dotted")); line(q(..ch-w), q(..ch-gate), stroke: (paint: ink, thickness: 0.6pt, dash: "dotted"))
  lab((11.5, 1.6), [foul main #f1(after.sewer-len) m · inlet #f2(after.inv-septic)], size: 4.5pt, anchor: "west")
  circle(q(..soak-e), radius: 0.8, stroke: (paint: navy, dash: "dashed", thickness: 0.5pt)); circle(q(..soak-s), radius: 0.8, stroke: (paint: navy, dash: "dashed", thickness: 0.5pt)); lab((soak-s.at(0) + 1.0, soak-s.at(1)), [soakaway S], size: 4.5pt, fill: navy, anchor: "west")
  rect(q(tank-old.at(0), tank-old.at(1)), q(tank-old.at(2), tank-old.at(3)), stroke: (paint: navy, dash: "dotted", thickness: 0.6pt)); lab((-6.0, 39.1), [tank], size: 4.5pt, fill: navy)
  rect(q(park-opt.at(0), park-opt.at(1)), q(park-opt.at(2), park-opt.at(3)), stroke: (paint: navy, thickness: 0.5pt, dash: "dashed")); lab((7.7, 2.15), [car bay], size: 4.5pt, fill: navy)
  line(q(..path-family-start), q(family-path-x, path-family-start.at(1)), q(family-path-x, after.b.at(0).at(1)), stroke: (paint: accent, thickness: 0.7pt, dash: "dashed"))
  line(q(path-guest-x, 39.6), q(path-guest-x, after.guest-door.at(1)), q(..after.guest-door), stroke: (paint: accent, thickness: 0.7pt, dash: "dashed")); lab((-1.9, 33.0), [guest band 1.2], size: 4.5pt, fill: accent, angle: 90deg)
  rect(q(-0.3, -0.3), q(0.3, 0.3), fill: accent, stroke: none); lab((-0.5, 0), text(weight: "bold")[M1], size: 5.4pt, fill: accent, anchor: "east")
  for (n, p) in (("D", D), ("R", R), ("S", peg-S)) { circle(q(..p), radius: 0.3, fill: brown, stroke: none); lab((p.at(0) + 0.5, p.at(1) - 0.2), text(weight: "bold", n), size: 5.4pt, fill: brown, anchor: "west") }
  for (p, n) in ((T1, [palm 1]), (T2, [palm 2])) { circle(q(..p), radius: r-palm, fill: accent, stroke: none); lab((p.at(0) + 0.6, p.at(1)), text(weight: "bold", n), size: 5.4pt, fill: accent, anchor: "west") }
  line(q(24, 0.5), (24 + 2.2 * north.at(0), -0.5 + 2.2 * north.at(1)), stroke: 1pt + ink, mark: (end: "stealth", fill: ink, scale: 0.7))
  lab((24 + 2.7 * north.at(0), -0.5 + 2.7 * north.at(1)), text(weight: "bold")[N], size: 8pt)
  line(q(16, ymax - 1), q(26, ymax - 1), stroke: 1.5pt + ink); lab((21, ymax - 0.2), [10 m], size: 6pt)
  lab((3, 36.5), [grey dashed = the current position (day 1) · purple = #f2(after.s) m south (recommended)], size: 5pt, fill: luma(80), anchor: "west")
})
#let zoom(length: 0.78cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let (x0, x1, y0, y1) = (8.5, 18.5, 2.0, 12.5)
  rect(q(x0, y0), q(x1, y1), fill: white, stroke: 0.4pt + grid-c)
  for x in range(9, 19) { line(q(x, y0), q(x, y1), stroke: 0.2pt + grid-c) }
  for y in range(2, 13) { line(q(x0, y), q(x1, y), stroke: 0.2pt + grid-c) }
  for x in range(10, 19, step: 2) { lab((x, y1 + 0.3), str(x), size: 5pt, fill: gray) }
  for y in range(2, 13, step: 2) { lab((x0 - 0.3, y), str(y), size: 5pt, fill: gray) }
  let piece(P, i0, i1) = ((x-on(P.at(i0), P.at(i0 + 1), y0), y0), ..P.slice(i0 + 1, i1 + 1), (x1, y-on(P.at(i1), P.at(i1 + 1), x1)))
  let env-piece = ((x-on(env.at(4), env.at(5), y0), y0), env.at(5), env.at(6), env.at(7), (x-on(env.at(7), env.at(8), y1), y1))
  line(..env-piece.map(p => q(..p)), stroke: 0.9pt + accent); lab((9.8, 2.5), [setback line (deed, 2.0 m)], size: 5pt, fill: accent, anchor: "west")
  line(..piece(lane, 1, 4).map(p => q(..p)), stroke: 1.4pt + black); lab((15.9, 4.6), [lane wall (deed line)], size: 4.8pt, anchor: "west")
  line(..piece(lane-cal, 1, 4).map(p => q(..p)), stroke: (paint: red, thickness: 0.9pt, dash: "dashed")); lab((17.6, 12.1), [the wall as built (#f2(delta) m inside)], size: 4.8pt, fill: red, anchor: "east")
  for (P, l) in ((tower-c, [air tower]), (maidbath-c, [maid bath]), (maidroom-c, [maid room])) { poly(P, stroke: (paint: luma(140), thickness: 0.4pt, dash: "dotted")) }
  let all = ((base, luma(90), "dashed", [current (day 1)]), ..opts.map(o => (o, if rec != none and o.s == rec.s { bld } else { bld.lighten(45%) }, "solid", [+#f2(o.s) m south])))
  for (i, (o, col, dash, l)) in all.enumerate() {
    let b = o.b
    line(q(x0, y-on(b.at(0), b.at(1), x0)), q(..b.at(1)), q(..b.at(2)), q(x-on(b.at(2), b.at(3), y1), y1), stroke: (paint: col, thickness: if i == 0 { 0.8pt } else { 0.7pt }, dash: dash))
    lab((x0 + 0.2, y1 - 0.4 - (all.len() - 1 - i) * 0.38), [#l: #f2(o.t-deed.m) deed · #f2(o.t-cal.m) wall], size: 4.6pt, fill: col, anchor: "west")
    circle(q(..o.t-cal.p), radius: 0.09, fill: col, stroke: none)
  }
  circle(q(..notch0), radius: 0.12, fill: none, stroke: 0.8pt + red); lab((notch0.at(0) - 0.3, notch0.at(1) - 0.2), [row 18: #f2(field.notch-lo)–#f2(field.notch-hi) m to the wall here], size: 4.6pt, fill: red, anchor: "east")
})

#let tbl(columns: (1fr, auto), size: 7pt, ..cells) = text(size, table(columns: columns, stroke: none, inset: (x: 3.5pt, y: 2.1pt),
  fill: (_, y) => if y == 0 { rgb("#e1e9e3") } else if calc.even(y) { rgb("#efece4") }, ..cells))
#let sub-head(t) = [#v(3pt) #text(9pt, weight: "bold", fill: accent, t) #v(1pt)]
#let col(v, lim) = text(fill: if v < 0 { red } else if v < lim { amber } else { accent }, weight: "bold")[#f2(v)]
#let colw(v) = text(fill: if v < target { red } else { accent }, weight: "bold")[#f2(v)]
#let title(t, sub) = [#text(14pt, weight: "bold", fill: accent, t) #h(1fr) #text(7pt, fill: gray, sub) #v(2pt) #line(length: 100%, stroke: 0.6pt + accent)]
#let all-cols = (base, ..opts)
#let srow(l, f, lim: none) = (l, ..all-cols.map(o => { let v = f(o); if lim == none { [#f2(v)] } else { col(v, lim) } }))
#let crow(l, f) = (l, ..all-cols.map(f))

// =====================================================================
// PAGE 1 · the comparison
// =====================================================================
#grid(columns: (auto, 1fr), column-gutter: 9pt,
  plan(if rec != none { rec } else { opts.at(1) }),
  [
    #title([Shift SOUTH 0.40 / 0.50 / 0.60 m · study · 0.50 m ADOPTED (owner, 6 Nov 2026)], [made at the day-1 position · page 1 of 3 · the house unchanged, no rotation, no west shift · the owner decides])
    #text(7pt, fill: gray)[Start: the current position (day 1: B1 5.00 m from M1, the west face #f2(B0.at(0).at(0)) m east of the M line). Calibration: B2 #f2(field.b2-wall-in) m and the cut wall's tightest point #f2(field.notch-lo)–#f2(field.notch-hi) m to the wall's inner face (rows 23 and 18) → the wall as built #f2(delta) m inside the deed line (the lower reading; the 2.30 reading gives #f2(delta-hi)); B1 #f2(field.b1-yard) m to the yard wall. Every wall sampled at 5 cm. Target: ≥ #f2(target) m from the wall as built.]
    #v(2pt)
    #tbl(columns: (2.5fr, 1fr, 1fr, 1fr, 1fr), size: 6.4pt,
      table.header([*South by (m)*], [*current*], ..opts.map(o => [*#f2(o.s)* #if rec != none and o.s == rec.s [(rec.)]])),
      ..srow([*Tightest margin on any wall, from the deed line* (the cut wall at the lane's notch; ≥ #f2(spare) wanted)], o => o.t-deed.m, lim: spare),
      ..crow([*Tightest margin from the wall as built*: the 2.20 reading / the 2.30 reading (target ≥ #f2(target))], o => [#colw(o.t-cal.m) / #colw(o.t-cal-hi.m)]),
      ..crow([Where: on the cut wall at (x, y) · its distance to the deed line there], o => [(#f1(o.t-cal.p.at(0)), #f1(o.t-cal.p.at(1))) · #f2(o.t-lane.m)]),
      ..crow([B2's margin: deed / from the wall · B3 to the deed line / to the wall], o => [#f2(o.b2-m) / #colw(o.b2-cal) · #f2(o.b3-lane) / #f2(o.b3-lane - delta)]),
      ..crow([M1 → B1 (the owner's 5.00 rule) · north strip: boundary wall to the house at B1 · to the north setback line], o => [*#f2(o.b1-m1)* · #f2(o.north-depth) · #f2(o.b1-north)]),
      ..crow([Car bay (kept where it is): gap to the north wall · the swept path's last move clear of the wall · the reverse move past B1], o => [#f2(o.north-at-bay) · #f2(o.swept-clear) · #f2(o.swept-b1)]),
      ..crow([Family entrance path from the driveway (m) · guest path from the driveway's south end (m)], o => [#f2(o.fam-path) · #f2(o.guest-path)]),
      ..crow([West wall to the driveway's west edge (unchanged) · to the yard wall at B1 / y 15 / y 25 / B5], o => [#f2(o.b1-drv) · #f2(o.b1-yard) / #f2(o.west-yard.at(1)) / #f2(o.west-yard.at(3)) / #f2(o.b5-yard)]),
      ..crow([Driveway clear width · the cornice's edge east of the M line · guest band 1.2 + strip #f2(base.strip)], o => [#f2(drv-w) · #col(o.cornice-clear, 0) · #f2(guest-band + o.strip)]),
      ..crow([Palm 1 / palm 2 to the nearest wall], o => [#f2(o.palm1) / #f2(o.palm2)]),
      ..crow([*South family garden* (m²) · lost against the current], o => [*#f0(o.garden)* · #sgn2(-o.garden-lost)]),
      ..crow([Outdoor kitchen, screen, gas, grill move with the house (spacings unchanged) · gas to the wall as built (≥ 1.5)], o => [#col(o.gas-lane-cal, 1.5)]),
      ..crow([Existing tank to B5 (≥ 5) · B5 to the garden's low wall], o => [#col(o.tank-b5, sep-tank-house) · #f2(o.b5-drv - drv-w - lowwall-x)]),
      ..crow([Sewer: the east main's length (m) · the inlet at the septic on the assumed falls (was #f2(base.inv-septic)) · the west run to its chamber], o => [#f1(o.sewer-len) · #f2(o.inv-septic) · #f2(o.west-run)]),
      ..crow([Soakaway E to the east wall · soakaway S to the south wall], o => [#f2(o.soak-e) · #f2(o.soak-s)]),
      ..crow([*Cut wall: how much it could later move outwards* keeping #f2(target) from the wall (2.20 / 2.30 reading)], o => [#f2(o.d-lo) / #f2(o.d-hi)]),
      ..crow([… and the floor area gained per floor (m², 2.20 / 2.30 reading)], o => [#f2(o.gain-lo) / #f2(o.gain-hi)]),
      ..crow([*Conflicts*], o => { let c = conflicts(o); if c.len() == 0 { text(fill: accent, weight: "bold")[none] } else { text(fill: red, size: 6pt, c.join([; ])) } }),
    )
    #text(6.4pt, fill: gray)[Moving south adds #f2((opts.last().t-cal.m - base.t-cal.m) / opts.last().s * 0.10) m of margin at the cut wall per 0.10 m (the cut runs at 61° to the M line); nothing moves in x, so the driveway, the west strip and the route's width are untouched. The cut-wall rows: a parallel outward move of d shortens the cut wall and adds ≈ 6.9 d m² per floor: the air tower ≈ #f2(cut-rooms.tower) d, the maid bath #f2(cut-rooms.bath) d, the maid room #f2(cut-rooms.maid) d (ground floor); the tower base #f2(cut-rooms.tower) d and bedroom 1 #f2(cut-rooms.bed1) d (first floor). Bedroom 1's hotel en-suite B4 needs #f2(b4-need) m² clear (now #f2(bed1-clear0)) and a rectangular room: it never fits with these moves.]
  ],
)

// =====================================================================
// PAGE 2 · gains and costs, in plain words
// =====================================================================
#pagebreak()
#title([Gains and costs · what each option gives and takes, against the current position], [page 2 of 3 · the owner's main question · baseline: the current position is the preferred one; a move only if clearly better])
#let verdict(o) = if o.t-cal.m < target { (amber, [not enough: #f2(o.t-cal.m) m from the wall at the lower reading (#f2(o.t-cal-hi.m) at 2.30) — the target is missed unless the 2.30 reading holds]) } else if rec != none and o.s == rec.s { (accent, [RECOMMENDED: the target met at both readings (#f2(o.t-cal.m) / #f2(o.t-cal-hi.m)) within the ground the owner checked, for #f0(o.garden-lost) m² of garden]) } else if o.s > ground-ok { (amber, [only if the ground really allows #f2(o.s): +#f2(o.t-cal.m - rec.t-cal.m) m more margin and a #f2(o.d-lo)–#f2(o.d-hi) m cut-wall option, for another #f0(o.garden-lost - rec.garden-lost) m² of garden]) } else { (accent, [acceptable]) }
#let gcard(o, prev) = block(width: 100%, fill: rgb("#f3f1ea"), stroke: 0.5pt + luma(170), inset: 6pt, radius: 3pt)[
  #text(10pt, weight: "bold", fill: accent)[#f2(o.s) m south] #h(1fr) #text(7pt, fill: gray)[B1 #f2(o.b1-m1) m from M1 · north strip #f2(o.north-depth) m deep at B1]
  #v(2pt)
  #text(7pt)[
    *I GAIN:* a margin of *#f2(o.t-cal.m) m from the wall as built* at the cut wall (#f2(o.t-cal-hi.m) if the 2.30 reading holds; today #f2(base.t-cal.m)–#f2(base.t-cal-hi.m)), #f2(o.t-deed.m) m from the deed line (today #f2(base.t-deed.m)) — #if o.t-cal.m >= target [*the #f2(target) m target is met at both readings, without waiting for the engineering office*] else [the target is met only at the 2.30 reading]; B2 #f2(o.b2-cal) m from the wall (today #f2(base.b2-cal)). Room to shorten the cut wall later: *#f2(o.d-lo)–#f2(o.d-hi) m* (#f2(o.gain-lo)–#f2(o.gain-hi) m² per floor: the maid room, the maid bath and the air tower below, bedroom 1 and the tower base above; the en-suite still does not fit). The north strip #f2(o.north-depth) m deep at B1 (today #f2(base.north-depth)): the car bay keeps #f2(o.north-at-bay) m to the wall (today #f2(base.north-at-bay)) and the reverse move past B1 clears #f2(o.swept-b1) m (today #f2(base.swept-b1)): the 3-point turn stays, with #f2(o.s) m more room; the bay could itself move #f2(o.s) m south if the owner wishes. The route beside the driveway: unchanged in width (#f2(o.b1-yard) m at B1).
    *I LOSE:* *#f0(o.garden-lost) m² of the south garden* (#f0(base.garden) → #f0(o.garden) m², #f1(100 * o.garden-lost / base.garden) %), the strip between the house and the palms: palm 2 #f2(base.palm2) → #f2(o.palm2) m (palm 1 unchanged, #f2(o.palm1)); the family walk from the gate #f2(base.fam-path) → #f2(o.fam-path) m (+#f2(o.s)); the guest walk #f2(base.guest-path) → #f2(o.guest-path) m (−#f2(o.s)); the south soakaway #f2(base.soak-s) → #f2(o.soak-s) m from the south wall; the tank #f2(base.tank-b5) → #f2(o.tank-b5) m from B5 (still ≥ 5); the foul main #f1(base.sewer-len) → #f1(o.sewer-len) m and the inlet #f2(base.inv-septic) → #f2(o.inv-septic) (nothing in practice); the owner's rule "B1 = 5.00 m" becomes #f2(o.b1-m1); all five blocks re-set.
    *The extra 0.10 m (#if prev == none [from the current position] else [from #f2(prev.s)]):* #if prev == none [+#f2(o.t-cal.m - base.t-cal.m) m of margin for #f0(o.garden-lost) m² of garden] else [+#f2(o.t-cal.m - prev.t-cal.m) m of margin for #f0(o.garden-lost - prev.garden-lost) m² of garden#if prev.t-cal.m < target and o.t-cal.m >= target [: *this is the step that reaches the target*] else if o.d-lo > prev.d-lo [: only the cut-wall option grows (#f2(prev.d-lo) → #f2(o.d-lo) m), the margin is already met] else [: a real gain only if the 2.20 reading is the true one]].
    *Verdict:* #text(fill: verdict(o).at(0), weight: "bold", verdict(o).at(1)).
  ]
]
#grid(columns: (1fr, 1fr, 1fr), column-gutter: 6pt, ..opts.enumerate().map(((i, o)) => gcard(o, if i == 0 { none } else { opts.at(i - 1) })))
#v(4pt)
#grid(columns: (1.15fr, 1fr), column-gutter: 10pt,
  box(fill: rgb("#2f6b4f").lighten(85%), stroke: 1pt + accent, inset: 6pt, radius: 3pt, width: 100%)[
    #text(10pt, weight: "bold", fill: accent)[Recommendation: #if rec-ok [move #f2(rec.s) m south] else [stay]] \
    #text(7.2pt)[#if rec-ok [The current position keeps only #f2(base.t-cal.m)–#f2(base.t-cal-hi.m) m from the wall as built at the cut wall (row 18), below the owner's #f2(target) m target; #f2(rec.s) m south is the smallest step that meets it at both readings (#f2(rec.t-cal.m) / #f2(rec.t-cal-hi.m)) and it lies within the ground the owner checked. It costs #f0(rec.garden-lost) m² of garden (#f1(100 * rec.garden-lost / base.garden) %) and nothing else of substance: the driveway, the west strip, the route, the guest band, the car bay, the yard, the gas cabinet, the tanks, the sewer and the soakaways all keep their rules. 0.40 m misses the target at the lower reading (#f2(opts.first().t-cal.m)); 0.60 m adds #f2(opts.last().t-cal.m - rec.t-cal.m) m and a #f2(opts.last().d-lo)–#f2(opts.last().d-hi) m cut-wall option for #f0(opts.last().garden-lost - rec.garden-lost) m² more garden and ground the owner is not sure of. *So #f2(rec.s) m south is clearly better than staying; more is not.* The cut wall stays 6.93 m for now (decision, row 18); the official survey has the last word.] else [No option meets the target within the owner's ground limit without a conflict: stay.]]
  ],
  [
    #set text(lang: "ar", size: 8pt)
    #set par(leading: 0.65em)
    #block(fill: rgb("#f3f1ea"), stroke: 0.5pt + luma(170), inset: 6pt, radius: 3pt, width: 100%)[
      *الخلاصة بالعربية · إزاحة البيت جنوبًا:* الموضع الحالي يترك عند جدار القطع #f2(base.t-cal.m)–#f2(base.t-cal-hi.m) م فقط من جدار الحد كما هو مبني (قياس الموقع، الصف ١٨)، أي أقل من الهدف #f2(target) م. الإزاحة #f2(rec.s) م جنوبًا هي أصغر خطوة تحقق الهدف بالقراءتين (#f2(rec.t-cal.m) / #f2(rec.t-cal-hi.m) م) وضمن الأرض التي فحصها المالك؛ ثمنها #f0(rec.garden-lost) م² من الحديقة الجنوبية (#f1(100 * rec.garden-lost / base.garden) ٪) وزيادة #f2(rec.s) م في مشي العائلة من البوابة؛ لا يتغير الممر ولا الشريط الغربي ولا موقف السيارة ولا الخزانات ولا الصرف. الخيار ٠٫٤٠ م لا يبلغ الهدف بالقراءة الأدنى (#f2(opts.first().t-cal.m) م)، والخيار ٠٫٦٠ م يزيد الهامش #f2(opts.last().t-cal.m - rec.t-cal.m) م فقط ويفتح تقصير جدار القطع #f2(opts.last().d-lo)–#f2(opts.last().d-hi) م مقابل #f0(opts.last().garden-lost - rec.garden-lost) م² أخرى من الحديقة وأرض غير مؤكدة. *التوصية: #f2(rec.s) م جنوبًا.* جدار القطع يبقى ٦٫٩٣ م الآن، والمساحة الرسمية هي الكلمة الأخيرة.
    ]
  ],
)

// =====================================================================
// PAGE 3 · the set-out table of the recommended option, the cut wall enlarged
// =====================================================================
#pagebreak()
#let R0 = if rec != none { rec } else { opts.at(1) }
#grid(columns: (auto, 1fr), column-gutter: 9pt,
  [
    #zoom()
    #v(3pt)
    #block(width: 7.8cm, text(6.6pt, fill: gray)[The cut wall enlarged. Grey dashed: the current position; purple: the options (the recommended one bold). The red circle: the model's nearest point to the lane line, where row 18 read #f2(field.notch-lo)–#f2(field.notch-hi) m to the wall (about 1 m before B3 by the owner; 2.1 m by the sheet: tape it from M1 16.25 / D 26.53 next time). Each dot = the tightest point of that option. Dotted: the rooms along the cut (the air tower, the maid bath, the maid room).])
  ],
  [
    #title([Set-out table of the recommended option · #f2(R0.s) m south], [page 3 of 3 · the sides and the diagonals unchanged · every block moves straight south along the M line])
    #let rows = R0.b.enumerate().map(((i, p)) => ([*B#(i + 1)*], [#f2(p.at(0))], [#f2(p.at(1))], [M1 → *#f2(dist(p, M1))*], [D → *#f2(dist(p, D))*], [R → *#f2(dist(p, R))*], [S → *#f2(dist(p, peg-S))*], [#f2(R0.s) m south, x unchanged])).flatten()
    #text(7.2pt, table(
      columns: (10mm, 13mm, 14mm, 21mm, 21mm, 21mm, 21mm, 1fr), stroke: 0.4pt + rgb("#9aa39f"), inset: 3.2pt, align: horizon,
      fill: (_, y) => if y == 0 { rgb("#e1e9e3") },
      table.header([*Corner*], [*x east*], [*y along M*], [*Tape 1 (M1)*], [*Tape 2 (D)*], [*Tape 3 (R)*], [*Tape 4 (S)*], [*The block moves from the day-1 position*]),
      ..rows,
    ))
    #v(3pt)
    #grid(columns: (1fr, 1.6fr), column-gutter: 8pt,
      text(7pt, table(
        columns: (auto, auto), stroke: 0.4pt + rgb("#9aa39f"), inset: 3pt, align: horizon,
        fill: (_, y) => if y == 0 { rgb("#e1e9e3") },
        table.header([*Side / diagonal*], [*m (unchanged)*]),
        ..range(5).map(i => ([B#(i + 1)–B#(calc.rem(i + 1, 5) + 1)], [*#f2(R0.sides.at(i))*])).flatten(),
        [B1–B4], [*#f2(R0.diags.at(0))*], [B2–B5], [*#f2(R0.diags.at(1))*], [B1–B3 (the cut's check)], [*#f2(R0.diags.at(2))*],
        [Perimeter], [*#f2(R0.sides.sum())*],
      )),
      text(7pt)[
        *On site:* string M1 → M4 as on day 1. Every block moves *#f2(R0.s) m straight south* along the string direction, x unchanged: from each present block measure #f2(R0.s) m parallel to the string (square off with 3-4-5 if the block is away from the string) and drive the new peg; then check the sides and the diagonals (unchanged: a move of all five by the same vector keeps every one) and the tapes above from M1, D, R and S. B1 is then #f2(R0.b1-m1) m from M1 (the owner's 5.00 rule becomes #f2(R0.b1-m1)); M1 → D, M4 and the palms are unchanged.
        *Then:* `design_gf.typ` gets the shift (0.91, #f2(shift.at(1) + R0.s)) and the set-out sheet and the services plan are re-issued; the garden, the yard, the hedge and the chambers attached to the house move with it, the gate, the driveway, the car bay, the tanks and the septic stay (not done here: the owner decides first).
        *Cut wall after this move:* #f2(R0.t-cal.m)–#f2(R0.t-cal-hi.m) m from the wall as built; it stays 6.93 m (decision, row 18); a later outward move of #f2(R0.d-lo)–#f2(R0.d-hi) m would keep the #f2(target) m and gain #f2(R0.gain-lo)–#f2(R0.gain-hi) m² per floor, after the official survey.
      ],
    )
    #v(3pt)
    #text(6.3pt, fill: gray)[Shift south study · Study checks #if all-ok [passed] else [FAILED]: #checks.map(c => c.at(0)).join([ · ]). Field values: the owner on site, day 1 (docs/SITE_SETOUT.md § 7 rows 18, 23, 24). Sources: base.typ (the site v2), design_gf.typ (the house), site_plan.typ (the services and the falls), roof.typ, bedroom1_bath.typ (B4), rotation_b2.typ and placement_steps.typ (the calibration method).]
  ],
)

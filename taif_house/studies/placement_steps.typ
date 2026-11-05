// placement_steps.typ · Taif / Palm House · STUDY: placing the house in THREE SEPARATE, SEQUENTIAL STEPS (the owner's method, 5 Nov 2026: one step at a time)
// STUDY ONLY: nothing in the design files, the house position or the set-out values changes here; the owner decides step by step after reading the result.
// Step 1: the whole house shifted WEST (towards the M line), no rotation: 0.10 / 0.15 / 0.20 m.
// Step 2: from the step-1 result, a small rotation about B2 (fixed), the south end moving EAST: B5 east by 0.10 / 0.20 / 0.30 m. STOP rule: the tightest margin from the wall as built < 0.40 m = not acceptable.
// Step 3: from the step-2 result, the cut wall B2–B3 moved outwards (parallel) keeping ≥ 0.40 m from the wall as built: for the owner's information, to apply only after the official survey.
// Field calibration (studies/rotation_b2.typ, day 1): B2 is 2.40 m from the boundary wall's inner face (2.60 incl. the wall): the wall stands ≈ 0.68 m inside the deed line, taken the same along the
// whole lane wall; B1 is 4.77 m from the old house's yard wall across the driveway (the route's narrowest point, widening south). Every setback margin is given TWICE: from the deed line and
// from the wall as built (the municipality may count from the wall). Design frame: origin M1 (the gate's east post) · y along the M line southwards · x east. Concept only – not for permit.
#import "@preview/cetz:0.4.2"
#import "../base.typ": land, env, drv, lane, nwall, T1, T2, north, D, R, S as peg-S
#import "../design_gf.typ": shift, outline-csv-gf

#set page(paper: "a4", flipped: true, margin: 8mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 8pt)
#set par(leading: 0.4em)

// =====================================================================
// INPUT – the house as set out (nothing to edit here; the study never moves it)
// =====================================================================
#let S(p) = (p.at(0) + shift.at(0), p.at(1) + shift.at(1))
#let expected = ((0, 0), (10.051, 0), (13.311, 6.0), (13.311, 24.0), (0, 24.0))
#assert(outline-csv-gf.len() == expected.len() and outline-csv-gf.zip(expected).all(((a, b)) => calc.abs(a.at(0) - b.at(0)) + calc.abs(a.at(1) - b.at(1)) < 1e-6),
  message: "the ground-floor outline changed: update placement_steps.typ")
#assert(calc.abs(shift.at(0) - 0.91) < 1e-9 and calc.abs(shift.at(1) - 5.063) < 1e-9, message: "the house moved (design_gf.typ shift): re-read this study")
#let B0 = ((-0.125, -0.125), (10.125, -0.125), (13.436, 5.968), (13.436, 24.125), (-0.125, 24.125)).map(S)   // B1 NW, B2 cut north, B3 cut east, B4 SE, B5 SW (outer faces)
#let spare = 0.5                 // the spare wanted from the deed setback lines (setout_v83.typ)
#let stop-rule = 0.40            // the owner's STOP rule (step 2) and the minimum kept from the wall as built (step 3)
#let setback-lane = 2.0
#let M1 = (0.0, 0.0)
#let r-palm = 0.265
#let drv-west = -3.95            // the driveway's west edge (base.typ drv, v2)
#let drv-w = 3.95
#let cornice = 0.30              // the main cornice's projection (studies/roof.typ); the band 0.08; the plinth flush (assumed)
#let guest-band = 1.2            // the guest path: a 1.2 m honey-stone band on the driveway's east edge (site_plan.typ), flush
#let step1-opts = (0.10, 0.15, 0.20)
#let step2-opts = (0.10, 0.20, 0.30)

// ---------- Field values, day 1 ----------
#let field = (b2-wall-in: 2.40, b2-wall-out: 2.60, b1-yard: 4.77)
#let yard-slope = (-8.0 - -6.0) / (28.5 - 6.5)   // the deed-sketch old house's east face runs away from the driveway going south (SITE_SETOUT.md § 8: W4 → W3)

// ---------- Things attached to the house (site_plan.typ; they move with it) ----------
#let gas0 = (S((15.35, 7.8)), S((15.85, 8.8)))
#let screen0 = (S((15.2, 7.6)), S((15.3, 13.0)))
#let counter0 = (S((13.45, 8.3)), S((14.05, 10.1)))
#let grill0 = (S((16.5, 12.6)), S((17.6, 13.8)))
#let manhole0 = S((14.3, 13.5))
#let guest-door0 = S((0, 22.2))
#let family-path-x0 = S((3.0, 0)).at(0) + 0.5    // the family entrance path's line (site_plan.typ path-family)
#let west-out0 = S((0, 10.675))
// ---------- Things fixed on the site ----------
#let park-opt = (5.2, 0.9, 10.2, 3.4)
#let swept-y = 2.15
#let swept-rev = ((-1.2, 5.0), (0.6, 3.2))        // the swept path's reverse move past the north-west corner (centre line, schematic; the car's half width 0.9)
#let path-guest-x = -1.0
#let lowwall-x = 0.6
#let garden = ((0.9, 29.188), (14.35, 29.188), (14.35, 20.838), (22.5, 20.838), (26.74, 33.94), (0.9, 38.7))
#let tank-old = (-7.5, 35.7, -4.5, 38.2)
#let ch-w = (-2.4, 15.738); #let ch-ne = (16.0, 11.438); #let soak-e = (16.5, 15.738); #let soak-s = (10.0, 32.238)
#let sep-tank-house = 5.0
// ---------- The rooms along the cut wall (CSV frame, centre lines; data/rooms_gf.csv, rooms_ff.csv, design_gf.typ) ----------
#let tower-c = ((8.95, 0), (10.051, 0), (10.594, 1.0), (8.95, 1.0)).map(S)
#let maidbath-c = ((8.95, 1), (10.594, 1), (11.572, 2.8), (8.95, 2.8)).map(S)
#let maidroom-c = ((10.65, 2.8), (11.572, 2.8), (13.311, 6), (13.311, 7.0), (10.65, 7.0)).map(S)
#let laundry-c = ((8.95, 2.8), (10.65, 2.8), (10.65, 7.0), (8.95, 7.0)).map(S)
#let bed1-c = ((8.95, 1), (10.594, 1), (13.311, 6), (13.311, 6.5), (10.15, 6.5), (10.15, 5.3), (8.95, 5.3))
#let cut-cols = ((10.051, 0), (11.572, 2.8), (13.311, 6.0)).map(S)   // the three columns on the cut line (STRUCTURE_STUDY.md), spans 3.2 · 3.6

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
#let delta = lane-d(B0.at(1)) - field.b2-wall-in            // the wall as built: this much inside the deed line (0.68)
#let margin-cal(p) = calc.min(margin(p), lane-d(p) - delta - setback-lane)
#let rot(p, th, c) = { let dx = p.at(0) - c.at(0); let dy = p.at(1) - c.at(1); (c.at(0) + dx * calc.cos(th) - dy * calc.sin(th), c.at(1) + dx * calc.sin(th) + dy * calc.cos(th)) }
#let theta-for(b, e) = {
  let dx = b.at(4).at(0) - b.at(1).at(0)
  let dy = b.at(4).at(1) - b.at(1).at(1)
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
#let f3(v) = { let r = calc.round(v, digits: 3); let s = str(r); let parts = s.split("."); if parts.len() == 1 { s + ".000" } else { s + "0" * (3 - parts.at(1).len()) } }
#let f1(v) = str(calc.round(v, digits: 1))
#let sgn2(v) = if v >= 0.005 { "+" + f2(v) } else if v <= -0.005 { "−" + f2(-v) } else { "0" }
#let x-on(a, b, y) = a.at(0) + (y - a.at(1)) * (b.at(0) - a.at(0)) / (b.at(1) - a.at(1))
#let y-on(a, b, x) = a.at(1) + (x - a.at(0)) * (b.at(1) - a.at(1)) / (b.at(0) - a.at(0))
#let yard-x(y) = B0.at(0).at(0) - field.b1-yard + yard-slope * (y - B0.at(0).at(1))
#let box-dist(b, p) = { let dx = calc.max(b.at(0) - p.at(0), 0, p.at(0) - b.at(2)); let dy = calc.max(b.at(1) - p.at(1), 0, p.at(1) - b.at(3)); calc.sqrt(dx * dx + dy * dy) }

// =====================================================================
// The measures of any house position: b = the five outer corners, T = the map that carries the attached things
// =====================================================================
#let ys = (10.0, 15.0, 20.0, 25.0)
#let measure(b, T) = {
  let gas = gas0.map(T)
  let gas-pts = (gas.at(0), (gas.at(1).at(0), gas.at(0).at(1)), gas.at(1), (gas.at(0).at(0), gas.at(1).at(1)))
  let west(y) = x-on(b.at(0), b.at(4), y)
  let t-deed = tightest(b, margin)
  let t-cal = tightest(b, margin-cal)
  (
    b: b, t-deed: t-deed, t-cal: t-cal, t-lane: tightest(b, lane-d),
    b2-m: margin(b.at(1)), b2-cal: margin-cal(b.at(1)), b3-lane: lane-d(b.at(2)), b3-m: margin(b.at(2)),
    b1-m1: dist(b.at(0), M1), b1-north: margin(b.at(0)),
    b1-drv: b.at(0).at(0) - drv-west, b5-drv: b.at(4).at(0) - drv-west, west-drv: ys.map(y => west(y) - drv-west),
    b1-yard: b.at(0).at(0) - yard-x(b.at(0).at(1)), b5-yard: b.at(4).at(0) - yard-x(b.at(4).at(1)), west-yard: ys.map(y => west(y) - yard-x(y)),
    strip-b1: b.at(0).at(0), strip-b5: b.at(4).at(0),                                  // the strip between the west wall and the driveway (the M line)
    cornice-clear: calc.min(b.at(0).at(0), b.at(4).at(0)) - cornice,                    // the cornice's edge to the M line (≥ 0: nothing over the driveway)
    north-at-bay: y-on(b.at(0), b.at(1), park-opt.at(0)) - park-opt.at(3),
    swept-clear: y-on(b.at(0), b.at(1), park-opt.at(0)) - (swept-y + 0.9),
    swept-b1: pseg(b.at(0), ..swept-rev) - 0.9,                                          // the reverse move's car side past B1
    bay-entrance: park-opt.at(0) - (T((family-path-x0, 0)).at(0) + 0.5),               // the bay east of the family entrance path (≥ 0.1 in site_plan.typ)
    palm1: edge-dist(T1, b) - r-palm, palm2: edge-dist(T2, b) - r-palm,
    garden-lost: calc.max(0.0, area(clip(garden, b)) - area(clip(garden, B0))), b5-lowwall: b.at(4).at(0) - lowwall-x,
    gas-lane: calc.min(..gas-pts.map(lane-d)), gas-lane-cal: calc.min(..gas-pts.map(lane-d)) - delta,
    guest-door: T(guest-door0), sewer-first: dist(T(manhole0), ch-ne), west-run: T(west-out0).at(0) - ch-w.at(0),
    tank-b5: box-dist(tank-old, b.at(4)), soak-e: pseg(soak-e, b.at(2), b.at(3)), soak-s: pseg(soak-s, b.at(3), b.at(4)),
    sides: range(5).map(i => dist(b.at(i), b.at(calc.rem(i + 1, 5)))),
    diags: (dist(b.at(0), b.at(3)), dist(b.at(1), b.at(4)), dist(b.at(0), b.at(2))),
    area: area(b),
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
  if o.north-at-bay < 0.4 { c.push([the car bay < 0.4 m from the north wall]) }
  if o.swept-clear < 0.5 or o.swept-b1 < 0.2 { c.push([the swept path touches the house]) }
  if o.bay-entrance < 0.1 { c.push([the car bay on the family entrance path]) }
  if o.west-run < 1.5 { c.push([the west chamber too close to the wall]) }
  c
}
#let ident(p) = p
#let base = measure(B0, ident)

// ---------- STEP 1 · the shift west ----------
#let step1(s) = { let T(p) = (p.at(0) - s, p.at(1)); let m = measure(B0.map(T), T); m + (s: s, T: T) }
#let s1 = step1-opts.map(step1)
#let s1-rec = s1.last()                                     // the largest shift: the most margin at the cut wall, every rule kept (see the checks)
// ---------- STEP 2 · the rotation about B2 from the step-1 result ----------
#let step2(e) = {
  let b1 = s1-rec.b
  let th = theta-for(b1, e)
  let T(p) = rot((s1-rec.T)(p), th, b1.at(1))
  let m = measure(b1.map(p => rot(p, th, b1.at(1))), T)
  m + (e: e, th: th, deg: th * 180 / calc.pi, ok: m.t-cal.m >= stop-rule, T: T, moves: range(5).map(i => (m.b.at(i).at(0) - b1.at(i).at(0), m.b.at(i).at(1) - b1.at(i).at(1))))
}
#let s2 = step2-opts.map(step2)
#let s2-ok = s2.filter(o => o.ok)
#let s2-rec = if s2-ok.len() > 0 { s2-ok.last() } else { none }   // the largest acceptable rotation, or none
#let s2-base = if s2-rec == none { s1-rec + (e: 0.0, deg: 0.0, moves: range(5).map(i => (0.0, 0.0))) } else { s2-rec }
// ---------- STEP 3 · the cut wall moved outwards from the step-2 result ----------
#let cut-dir = { let u = (s2-base.b.at(2).at(0) - s2-base.b.at(1).at(0), s2-base.b.at(2).at(1) - s2-base.b.at(1).at(1)); let l = calc.sqrt(u.at(0) * u.at(0) + u.at(1) * u.at(1)); (u.at(0) / l, u.at(1) / l) }
#let cut-n = (cut-dir.at(1), -cut-dir.at(0))                 // the cut wall's outward normal (towards the lane)
#let d-max-wall = s2-base.t-cal.m - stop-rule                 // the largest move keeping 0.40 from the wall as built
#let d-max-deed = s2-base.t-deed.m - stop-rule                // … and from the deed line (for information)
#let step3(d) = {
  let b = s2-base.b
  let un = { let u = (b.at(1).at(0) - b.at(0).at(0), b.at(1).at(1) - b.at(0).at(1)); let l = calc.sqrt(u.at(0) * u.at(0) + u.at(1) * u.at(1)); (u.at(0) / l, u.at(1) / l) }   // along the north wall
  let ue = { let u = (b.at(3).at(0) - b.at(2).at(0), b.at(3).at(1) - b.at(2).at(1)); let l = calc.sqrt(u.at(0) * u.at(0) + u.at(1) * u.at(1)); (u.at(0) / l, u.at(1) / l) }   // along the east wall
  let t2 = d / (un.at(0) * cut-n.at(0) + un.at(1) * cut-n.at(1))
  let t3 = d / (ue.at(0) * cut-n.at(0) + ue.at(1) * cut-n.at(1))
  let b2 = (b.at(1).at(0) + t2 * un.at(0), b.at(1).at(1) + t2 * un.at(1))
  let b3 = (b.at(2).at(0) + t3 * ue.at(0), b.at(2).at(1) + t3 * ue.at(1))
  let nb = (b.at(0), b2, b3, b.at(3), b.at(4))
  let m = measure(nb, s2-base.T)
  // the rooms along the cut (centre-line lengths along the cut; each gains ≈ d × its length, the thickness of the wall unchanged)
  let L(a, c) = dist(a, c)
  let l-tower = L(S((10.051, 0)), S((10.594, 1.0))); let l-bath = L(S((10.594, 1.0)), S((11.572, 2.8))); let l-maid = L(S((11.572, 2.8)), S((13.311, 6.0))); let l-bed1 = L(S((10.594, 1.0)), S((13.311, 6.0)))
  m + (d: d, b2-move: t2, b3-move: -t3, gross: area(nb) - area(b),
       gf: (tower: d * l-tower, bath: d * l-bath, maid: d * l-maid), ff: (tower: d * l-tower, bed1: d * l-bed1),
       bed1-clear: (area(bed1-c) - 0.1 * (range(bed1-c.len()).map(i => dist(bed1-c.at(i), bed1-c.at(calc.rem(i + 1, bed1-c.len())))).sum())) + d * l-bed1,
       cut-length: dist(b2, b3), col-moves: (t2, d, -t3),
       need-notch: base.t-cal.m + setback-lane + calc.max(0.0, stop-rule - m.t-cal.m))   // what the notch check must read (from the present tightest point square to the wall) for this move to keep 0.40: the wall-as-built distance assumed there + the shortfall
}
#let b4-need = 3.84 + 1.9 + 10.0                                // bedroom 1's hotel en-suite B4: the shower room + the vestibule + the bedroom proper, clear (studies/bedroom1_bath.typ)
#let step3-opts = (calc.max(d-max-wall, 0.0), 0.20, 0.40, d-max-deed)
#let s3 = step3-opts.map(step3)
#let s3-labels = ([largest safe from the wall as built], [0.20 (information)], [0.40 (information)], [largest from the deed line])

// ---------- the checks of this study ----------
#let checks = (
  ([the house unchanged in the design files (shift #f2(shift.at(0)), #f2(shift.at(1)); the outline asserted): study only], true),
  ([the calibration: the wall as built #f2(delta) m inside the deed line (0 … 1 m plausible); B1 → the yard wall #f2(base.b1-yard) = the field value], delta > 0 and delta < 1.0 and calc.abs(base.b1-yard - field.b1-yard) < 1e-6),
  ([step 1: every option keeps the house east of the M line with the cornice clear of the driveway (min #f2(calc.min(..s1.map(o => o.cornice-clear))) m), every corner inside the envelope, no conflict], s1.all(o => o.cornice-clear >= 0 and conflicts(o).len() == 0)),
  ([step 1: the recommended shift (#f2(s1-rec.s) m) gives the largest margin from the wall as built (#f2(s1-rec.t-cal.m))], s1.all(o => o.t-cal.m <= s1-rec.t-cal.m + 1e-9)),
  ([step 2: B2 fixed, the sides and the diagonals unchanged in every option; the STOP rule applied (acceptable = tightest margin from the wall ≥ #f2(stop-rule))], s2.all(o => dist(o.b.at(1), s1-rec.b.at(1)) < 1e-6 and range(5).all(i => calc.abs(o.sides.at(i) - base.sides.at(i)) < 1e-3) and o.ok == (o.t-cal.m >= stop-rule))),
  ([step 2: the recommendation is the largest acceptable rotation or "no rotation" (#if s2-rec == none [none acceptable] else [#f2(s2-rec.e) m])], s2-rec == none or s2.filter(o => o.ok).all(o => o.e <= s2-rec.e)),
  ([step 3: the largest safe move keeps exactly #f2(stop-rule) m from the wall as built (#f3(s3.first().t-cal.m)) and the options never pass the deed line's #f2(stop-rule) m], calc.abs(s3.first().t-cal.m - stop-rule) < 2e-3 and s3.all(o => o.t-deed.m >= stop-rule - 2e-3)),
  ([step 3: B2 and B3 slide along the north and east walls (B1, B4, B5 fixed; the cut stays parallel)], s3.all(o => dist(o.b.at(0), s2-base.b.at(0)) < 1e-9 and dist(o.b.at(3), s2-base.b.at(3)) < 1e-9 and calc.abs((o.b.at(2).at(0) - o.b.at(1).at(0)) * cut-dir.at(1) - (o.b.at(2).at(1) - o.b.at(1).at(1)) * cut-dir.at(0)) < 1e-6)),
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
// the whole plot with the house as set out (grey dashed), the step's starting position (grey) and its recommended result (purple)
#let plan(before, after, note, length: 0.235cm) = cetz.canvas(length: length, {
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
  lab((17.6, 5.2), text(weight: "bold")[wall as built: #f2(delta) m inside the deed line], size: 5pt, fill: red, anchor: "west")
  line(q(0, 0), q(0, 38.86), stroke: 1.2pt + accent)
  line(q(yard-x(4.0), 4.0), q(yard-x(30.0), 30.0), stroke: (paint: brown, thickness: 0.9pt, dash: "dashed"))
  lab((yard-x(12.0) - 1.3, 12.0), [old house's yard wall (field: #f2(field.b1-yard) m from B1)], size: 4.8pt, fill: brown, angle: 90deg)
  poly(garden, fill: rgb("#dcebd0").transparentize(40%), stroke: (paint: accent, thickness: 0.4pt, dash: "dotted"))
  poly(B0, fill: none, stroke: (paint: luma(120), thickness: 0.7pt, dash: "dashed"))
  if before != none { poly(before, fill: luma(200).transparentize(60%), stroke: (paint: luma(90), thickness: 0.8pt)) }
  poly(after.b, fill: bld.transparentize(70%), stroke: 1.1pt + bld)
  for (i, p) in after.b.enumerate() {
    circle(q(..p), radius: 0.3, fill: bld, stroke: none)
    lab((p.at(0) + (if i == 0 or i == 4 { -0.6 } else { 0.6 }), p.at(1) + (if i == 0 or i == 1 { -0.7 } else { 0.8 })), text(weight: "bold")[B#(i + 1)], size: 5.4pt, fill: bld, anchor: if i == 0 or i == 4 { "east" } else { "west" })
  }
  circle(q(..after.t-cal.p), radius: 0.35, fill: none, stroke: 1pt + red)
  lab((after.t-cal.p.at(0) - 0.7, after.t-cal.p.at(1) + 0.2), [tightest: #f2(after.t-deed.m) deed · #f2(after.t-cal.m) wall], size: 5pt, fill: red, anchor: "east")
  let g = gas0.map(after.T); rect(q(..g.at(0)), q(..g.at(1)), stroke: 0.5pt + amber); lab((g.at(1).at(0) + 0.3, (g.at(0).at(1) + g.at(1).at(1)) / 2), [gas], size: 4.5pt, fill: amber, anchor: "west")
  let sc = screen0.map(after.T); line(q(..sc.at(0)), q(..sc.at(1)), stroke: 1pt + amber)
  circle(q(..(after.T)(manhole0)), radius: 0.3, fill: white, stroke: 0.6pt + ink); circle(q(..ch-ne), radius: 0.3, fill: white, stroke: 0.6pt + ink); circle(q(..ch-w), radius: 0.3, fill: white, stroke: 0.6pt + ink)
  line(q(..(after.T)(manhole0)), q(..ch-ne), q(11.0, 0.6), q(-2.6, 1.6), stroke: (paint: ink, thickness: 0.6pt, dash: "dotted")); line(q(..ch-w), q(-2.6, 1.6), stroke: (paint: ink, thickness: 0.6pt, dash: "dotted"))
  circle(q(..soak-e), radius: 0.8, stroke: (paint: navy, dash: "dashed", thickness: 0.5pt)); circle(q(..soak-s), radius: 0.8, stroke: (paint: navy, dash: "dashed", thickness: 0.5pt))
  rect(q(tank-old.at(0), tank-old.at(1)), q(tank-old.at(2), tank-old.at(3)), stroke: (paint: navy, dash: "dotted", thickness: 0.6pt)); lab((-6.0, 39.1), [tank], size: 4.5pt, fill: navy)
  rect(q(park-opt.at(0), park-opt.at(1)), q(park-opt.at(2), park-opt.at(3)), stroke: (paint: navy, thickness: 0.5pt, dash: "dashed")); lab((7.7, 2.15), [car bay], size: 4.5pt, fill: navy)
  line(q(-guest-band, 39.6), q(-guest-band, after.guest-door.at(1)), stroke: (paint: accent, thickness: 0.5pt, dash: "dashed")); line(q(path-guest-x, 39.6), q(path-guest-x, after.guest-door.at(1)), q(..after.guest-door), stroke: (paint: accent, thickness: 0.7pt, dash: "dashed")); lab((-1.9, 33.0), [guest band 1.2], size: 4.5pt, fill: accent, angle: 90deg)
  rect(q(-0.3, -0.3), q(0.3, 0.3), fill: accent, stroke: none); lab((-0.5, 0), text(weight: "bold")[M1], size: 5.4pt, fill: accent, anchor: "east")
  for (n, p) in (("D", D), ("R", R), ("S", peg-S)) { circle(q(..p), radius: 0.3, fill: brown, stroke: none); lab((p.at(0) + 0.5, p.at(1) - 0.2), text(weight: "bold", n), size: 5.4pt, fill: brown, anchor: "west") }
  for (p, n) in ((T1, [palm 1]), (T2, [palm 2])) { circle(q(..p), radius: r-palm, fill: accent, stroke: none); lab((p.at(0) + 0.6, p.at(1)), text(weight: "bold", n), size: 5.4pt, fill: accent, anchor: "west") }
  line(q(24, 0.5), (24 + 2.2 * north.at(0), -0.5 + 2.2 * north.at(1)), stroke: 1pt + ink, mark: (end: "stealth", fill: ink, scale: 0.7))
  lab((24 + 2.7 * north.at(0), -0.5 + 2.7 * north.at(1)), text(weight: "bold")[N], size: 8pt)
  line(q(16, ymax - 1), q(26, ymax - 1), stroke: 1.5pt + ink); lab((21, ymax - 0.2), [10 m], size: 6pt)
  lab((3, 36.5), note, size: 5pt, fill: luma(80), anchor: "west")
})
// the cut wall enlarged: the deed line, the wall as built, the setback, the positions compared
#let zoom(lines, dots, note, length: 0.78cm) = cetz.canvas(length: length, {
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
  // the rooms along the cut (centre lines, as set out)
  for (P, l) in ((tower-c, [air tower]), (maidbath-c, [maid bath]), (maidroom-c, [maid room]), (laundry-c, [laundry])) { poly(P, stroke: (paint: luma(140), thickness: 0.4pt, dash: "dotted")) }
  for (i, (b, col, dash, l)) in lines.enumerate() {
    line(q(x0, y-on(b.at(0), b.at(1), x0)), q(..b.at(1)), q(..b.at(2)), q(x-on(b.at(2), b.at(3), y1), y1), stroke: (paint: col, thickness: if i == 0 { 0.8pt } else { 0.7pt }, dash: dash))
    lab((x0 + 0.2, y1 - 0.4 - (lines.len() - 1 - i) * 0.38), l, size: 4.6pt, fill: col, anchor: "west")   // the legend, bottom left
  }
  // the tightest points cluster: their labels stacked to the left with leaders
  for (i, (p, col, l)) in dots.enumerate() {
    let lp = (12.4, 8.2 + i * 0.38)
    circle(q(..p), radius: 0.09, fill: col, stroke: none)
    line(q(..p), q(lp.at(0) + 0.1, lp.at(1)), stroke: 0.3pt + luma(170))
    lab(lp, l, size: 4.4pt, fill: col, anchor: "east")
  }
})

#let tbl(columns: (1fr, auto), size: 7pt, ..cells) = text(size, table(columns: columns, stroke: none, inset: (x: 3.5pt, y: 2.1pt),
  fill: (_, y) => if y == 0 { rgb("#e1e9e3") } else if calc.even(y) { rgb("#efece4") }, ..cells))
#let sub-head(t) = [#v(3pt) #text(9pt, weight: "bold", fill: accent, t) #v(1pt)]
#let col(v, lim) = text(fill: if v < 0 { red } else if v < lim { amber } else { accent }, weight: "bold")[#f2(v)]
#let colw(v) = text(fill: if v < stop-rule { red } else { accent }, weight: "bold")[#f2(v)]   // from the wall as built: the STOP rule
#let title(t, sub) = [#text(14pt, weight: "bold", fill: accent, t) #h(1fr) #text(7pt, fill: gray, sub) #v(2pt) #line(length: 100%, stroke: 0.6pt + accent)]
// the set-out tape table of a position, with the moves from the house as set out
#let tape-table(m, moves-note) = {
  let rows = m.b.enumerate().map(((i, p)) => {
    let mv = (p.at(0) - B0.at(i).at(0), p.at(1) - B0.at(i).at(1))
    ([*B#(i + 1)*], [#f2(p.at(0))], [#f2(p.at(1))], [M1 → *#f2(dist(p, M1))*], [D → *#f2(dist(p, D))*], [R → *#f2(dist(p, R))*], [S → *#f2(dist(p, peg-S))*],
     if dist(p, B0.at(i)) < 1e-6 { text(fill: red, weight: "bold")[unchanged, keep the block] } else { [#sgn2(mv.at(0)) east, #sgn2(mv.at(1)) south (#f2(dist(p, B0.at(i))) m)] })
  }).flatten()
  text(6.8pt, table(
    columns: (9mm, 12mm, 13mm, 20mm, 20mm, 20mm, 20mm, 1fr), stroke: 0.4pt + rgb("#9aa39f"), inset: 2.8pt, align: horizon,
    fill: (_, y) => if y == 0 { rgb("#e1e9e3") },
    table.header([*Corner*], [*x east*], [*y along M*], [*Tape 1 (M1)*], [*Tape 2 (D)*], [*Tape 3 (R)*], [*Tape 4 (S)*], [*The block moves from the day-1 position*]),
    ..rows,
  ))
  v(2pt)
  text(6.6pt)[Sides B1–B2 #f2(m.sides.at(0)) · B2–B3 #f2(m.sides.at(1)) · B3–B4 #f2(m.sides.at(2)) · B4–B5 #f2(m.sides.at(3)) · B5–B1 #f2(m.sides.at(4)) · diagonals B1–B4 #f2(m.diags.at(0)) · B2–B5 #f2(m.diags.at(1)) · B1–B3 #f2(m.diags.at(2)) · perimeter #f2(m.sides.sum()). #moves-note]
}

// =====================================================================
// STEP 1 · the shift west
// =====================================================================
#let s1-cols = (2.4fr, 1fr, 1fr, 1fr, 1fr)
#let srow1(l, f, lim: none) = (l, ..(base, ..s1).map(o => { let v = f(o); if lim == none { [#f2(v)] } else { col(v, lim) } }))
#let crow1(l, f) = (l, ..(base, ..s1).map(f))
#grid(columns: (auto, 1fr), column-gutter: 9pt,
  [
    #plan(none, s1-rec, [grey dashed = as set out (day 1) · purple = step 1, #f2(s1-rec.s) m west (recommended)])
  ],
  [
    #title([Step 1 · the whole house WEST, no rotation], [placement in three steps · STUDY ONLY · page 1 of 4])
    #text(7pt, fill: gray)[Start: the house as set out on day 1 (B1 5.00 m from M1, the west outer face #f2(B0.at(0).at(0)) m east of the M line). Options: the house unchanged, shifted 0.10 / 0.15 / 0.20 m west. Margins from the deed line and from the wall as built (#f2(delta) m inside the deed line, the field value at B2). Every wall sampled at 5 cm.]
    #v(2pt)
    #tbl(columns: s1-cols, size: 6.5pt,
      table.header([*Shift west (m)*], [*as set out*], ..s1.map(o => [*#f2(o.s)* #if o.s == s1-rec.s [(rec.)]])),
      ..crow1([West outer face east of the M line = the strip to the driveway (m)], o => [#f2(o.strip-b1)]),
      ..srow1([*Tightest margin on any wall, deed* (the cut wall at the lane's notch; ≥ #f2(spare) wanted)], o => o.t-deed.m, lim: spare),
      ..crow1([*Tightest margin, from the wall as built*], o => colw(o.t-cal.m)),
      ..crow1([B2's margin: deed / from the wall], o => [#f2(o.b2-m) / #colw(o.b2-cal)]),
      ..crow1([B3 to the deed line / to the wall as built], o => [#f2(o.b3-lane) / #f2(o.b3-lane - delta)]),
      ..crow1([B1 (and the west wall) to the driveway's west edge · to the old house's yard wall (4.77 as set out)], o => [#f2(o.b1-drv) · #f2(o.b1-yard)]),
      ..crow1([Driveway clear width (3.95 m): the cornice's edge (#f2(cornice) m) east of the M line; the band 0.08; the plinth flush; the guest door opens in], o => [#f2(drv-w) · #col(o.cornice-clear, 0)]),
      ..crow1([Guest path: the 1.2 m stone band on the driveway's edge (unchanged) + the strip to the wall = walking width], o => [#f2(guest-band) + #f2(o.strip-b1) = #f2(guest-band + o.strip-b1)]),
      ..crow1([North strip: B1 to the north setback line · M1 → B1], o => [#f2(o.b1-north) · #f2(o.b1-m1)]),
      ..crow1([Car bay: gap to the north wall (≥ 0.4) · east of the entrance path (≥ 0.1) · the reverse move's car side past B1], o => [#f2(o.north-at-bay) · #f2(o.bay-entrance) · #f2(o.swept-b1)]),
      ..crow1([Palm 1 / palm 2 to the nearest wall], o => [#f2(o.palm1) / #f2(o.palm2)]),
      ..crow1([Gas cabinet to the wall as built (≥ 1.5) · tank to B5 (≥ 5) · the west drain to its chamber · soakaway E to the east wall], o => [#col(o.gas-lane-cal, 1.5) · #f2(o.tank-b5) · #f2(o.west-run) · #f2(o.soak-e)]),
      ..crow1([Garden lost (m²) · B5 to the garden's low wall], o => [#f2(o.garden-lost) · #f2(o.b5-lowwall)]),
      ..crow1([*Conflicts*], o => { let c = conflicts(o); if c.len() == 0 { text(fill: accent, weight: "bold")[none] } else { text(fill: red, size: 6pt, c.join([; ])) } }),
    )
    #box(fill: rgb("#2f6b4f").lighten(85%), stroke: 1pt + accent, inset: 5pt, radius: 3pt, width: 100%)[
      #text(9.5pt, weight: "bold", fill: accent)[Recommendation · step 1: #f2(s1-rec.s) m west] \
      #text(7pt)[The shift is pure gain at the cut wall: every 0.10 m west adds #f2((s1.last().t-cal.m - base.t-cal.m) / 2) m of margin at the notch (the cut wall runs at 61° to the M line). From the wall as built the tightest margin goes #f2(base.t-cal.m) → *#f2(s1-rec.t-cal.m) m* (the only option that reaches the owner's 0.40), B2 #f2(base.b2-cal) → #f2(s1-rec.b2-cal); from the deed line #f2(base.t-deed.m) → #f2(s1-rec.t-deed.m). *The west side takes it:* the house stays #f2(s1-rec.strip-b1) m east of the M line, the cornice #f2(s1-rec.cornice-clear) m clear of the driveway's edge, so the driveway keeps its #f2(drv-w) m at ground level and at cornice height; the guest band (1.2 m, on the driveway's edge) is untouched and the walking width wall-to-band-edge is #f2(guest-band + s1-rec.strip-b1) m; the north strip and the car bay are unchanged (the entrance path moves #f2(s1-rec.s) m west with the house, the bay gains that clearance); the palms gain #f2(s1-rec.s) m. *The costs:* the route across the driveway narrows from #f2(field.b1-yard) to #f2(s1-rec.b1-yard) m at B1 (still > the 3.95 m lane + the 0.585 strip; the water truck and the carport turn are at the south, unchanged); the strip beside the west wall is #f2(s1-rec.strip-b1) m: keep it as the gravel / plinth drainage margin and the rescue-ladder stand, not as a path (the path is the band); the first-floor escape casements of bedrooms 2 and 3 on the west wall swing over the M line when open (they already do as set out: an open leaf reaches ≈ 0.3–0.5 m beyond the strip at +4.8 m above the ground, above any vehicle) — if the municipality objects, make them inward-opening or top-hung (the fire study allows either). The owner's rule B1 = 5.00 from M1 becomes #f2(s1-rec.b1-m1) (B1 keeps its y).]
    ]
  ],
)
#v(2pt)
#sub-head[Step 1 · set-out table of the recommended option (#f2(s1-rec.s) m west)]
#tape-table(s1-rec, [Every block moves #f2(s1-rec.s) m straight west (the sides and the diagonals unchanged): tape the move from each block square to the string M1 → M4, then confirm with the diagonals.])

// =====================================================================
// STEP 2 · the rotation about B2 from the step-1 result
// =====================================================================
#pagebreak()
#let srow2(l, f, lim: none) = (l, ..(s1-rec, ..s2).map(o => { let v = f(o); if lim == none { [#f2(v)] } else { col(v, lim) } }))
#let crow2(l, f) = (l, ..(s1-rec, ..s2).map(f))
#let s2-lines = ((s1-rec.b, luma(90), "dashed", [after step 1 (B5 #f2(s1-rec.b.at(4).at(0)) m from the M line)]), ..s2.map(o => (o.b, if o.ok { bld } else { red }, "solid", [+#f2(o.e): #if o.ok [acceptable] else [not acceptable]])))
#let s2-dots = ((s1-rec.t-cal.p, luma(90), [after step 1: #f2(s1-rec.t-deed.m) / #f2(s1-rec.t-cal.m)]), ..s2.map(o => (o.t-cal.p, if o.ok { bld } else { red }, [+#f2(o.e): #f2(o.t-deed.m) / #f2(o.t-cal.m)])))
#grid(columns: (auto, 1fr), column-gutter: 9pt,
  [
    #plan(s1-rec.b, s2-base, [grey = after step 1 · purple = step 2 result: #if s2-rec == none [no rotation (none acceptable)] else [B5 east #f2(s2-rec.e) m]])
  ],
  [
    #title([Step 2 · a small rotation about B2, from the step-1 result], [page 2 of 4 · B2 fixed · the south end moves EAST · STOP rule: tightest margin from the wall as built < #f2(stop-rule) m = not acceptable])
    #text(7pt, fill: gray)[Start: the step-1 result (#f2(s1-rec.s) m west). Options: B5 east by 0.10 / 0.20 / 0.30 m about B2 (B2 #f2(s1-rec.b.at(1).at(0)), #f2(s1-rec.b.at(1).at(1))). The sides and the diagonals unchanged; the attached things (the yard, the gas, the chambers) turn with the house.]
    #v(2pt)
    #tbl(columns: s1-cols, size: 6.5pt,
      table.header([*B5 east by (m)*], [*after step 1*], ..s2.map(o => [*#f2(o.e)*])),
      ..crow2([The house turns about B2 (°) · B1 moves south · M1 → B1], o => if "deg" in o { [#f2(-o.deg) · #f2(o.moves.at(0).at(1)) · #f2(o.b1-m1)] } else { [0 · 0 · #f2(o.b1-m1)] }),
      ..srow2([*Tightest margin on any wall, deed* (≥ #f2(spare) wanted)], o => o.t-deed.m, lim: spare),
      ..crow2([*Tightest margin, from the wall as built* (STOP rule #f2(stop-rule); three decimals, the 0.10 option is 5 mm short)], o => [#text(fill: if o.t-cal.m < stop-rule { red } else { accent }, weight: "bold")[#f3(o.t-cal.m)] #if "ok" in o [#if o.ok [acceptable] else [#text(fill: red, weight: "bold")[not acceptable]]]]),
      ..crow2([B2's margin: deed / from the wall (unchanged)], o => [#f2(o.b2-m) / #colw(o.b2-cal)]),
      ..crow2([B3 to the deed line / to the wall as built], o => [#f2(o.b3-lane) / #f2(o.b3-lane - delta)]),
      ..crow2([Route along the west wall: to the yard wall at B1 / y 15 / y 25 / B5 · to the driveway's edge at B5], o => [#f2(o.b1-yard) / #f2(o.west-yard.at(1)) / #f2(o.west-yard.at(3)) / #f2(o.b5-yard) · #f2(o.b5-drv)]),
      ..crow2([Driveway clear width · the cornice's edge east of the M line (min along the wall)], o => [#f2(drv-w) · #col(o.cornice-clear, 0)]),
      ..crow2([Guest path: band 1.2 + strip at B1 / at B5 · the guest door moves east], o => [#f2(guest-band) + #f2(o.strip-b1) / #f2(o.strip-b5) · #sgn2(o.guest-door.at(0) - s1-rec.guest-door.at(0))]),
      ..crow2([Car bay: gap to the north wall · east of the entrance path · the reverse move past B1], o => [#f2(o.north-at-bay) · #f2(o.bay-entrance) · #f2(o.swept-b1)]),
      ..crow2([Palm 1 / palm 2 · garden lost (m²)], o => [#f2(o.palm1) / #f2(o.palm2) · #f2(o.garden-lost)]),
      ..crow2([Outdoor kitchen, screen, gas, grill turn with the house (spacings unchanged) · gas to the wall as built (≥ 1.5)], o => [#col(o.gas-lane-cal, 1.5)]),
      ..crow2([Tank to B5 (≥ 5) · sewer: yard chamber → east chamber · the west drain to its chamber · soakaway E], o => [#f2(o.tank-b5) · #f2(o.sewer-first) · #f2(o.west-run) · #f2(o.soak-e)]),
      ..crow2([*Conflicts*], o => { let c = conflicts(o); if "ok" in o and not o.ok { c.insert(0, [STOP rule: #f2(o.t-cal.m) < #f2(stop-rule) from the wall as built]) }; if c.len() == 0 { text(fill: accent, weight: "bold")[none] } else { text(fill: red, size: 6pt, c.join([; ])) } }),
    )
    #box(fill: rgb("#2f6b4f").lighten(85%), stroke: 1pt + accent, inset: 5pt, radius: 3pt, width: 100%)[
      #text(9.5pt, weight: "bold", fill: accent)[Recommendation · step 2: #if s2-rec == none [NO rotation] else [B5 east #f2(s2-rec.e) m]] \
      #text(7pt)[#if s2-rec == none [Every rotation turns the cut wall's far part towards the lane: the margin from the wall as built falls from #f2(s1-rec.t-cal.m) m (after step 1) to #s2.map(o => f3(o.t-cal.m)).join(" / ") m for 0.10 / 0.20 / 0.30 — all below the owner's #f2(stop-rule) m STOP rule (the 0.10 m option by #f3(stop-rule - s2.first().t-cal.m) m only). Against the deed line every option is fine (#s2.map(o => f2(o.t-deed.m)).join(" / ") m, above the #f2(spare) spare), and nothing else conflicts (the palms, the garden, the guest path, the car bay, the yard, the gas, the tanks, the sewer all keep their rules). The rotation's gain (the route at the south: +0.10 … +0.30 m at B5, where the water truck and the carport turn are; the north strip at B1 +0.04 … +0.13 m) is not worth breaking the rule for. *So: no rotation; the step-1 position stands.* If the notch check (sheet row 18) finds the wall at the notch further off than the #f2(delta) m assumed here (the owner saw B2, not the notch, as the nearest point), the 0.10 m option becomes acceptable at a reading of ≥ #f2(base.t-cal.m + setback-lane + (stop-rule - s2.first().t-cal.m)) m from the present tightest point square to the wall (this study assumes #f2(base.t-cal.m + setback-lane) m there).] else [The largest acceptable rotation: the margin from the wall as built #f2(s2-rec.t-cal.m) m ≥ #f2(stop-rule); from the deed line #f2(s2-rec.t-deed.m) m; no conflict.]]
    ]
  ],
)
#v(2pt)
#sub-head[Step 2 · set-out table of the result (#if s2-rec == none [no rotation: the step-1 position stands] else [B5 east #f2(s2-rec.e) m])]
#tape-table(s2-base, if s2-rec == none [No block moves in step 2: the position is step 1's (the table repeats step 1's values).] else [B2's block stays; the others move as given.])

// =====================================================================
// STEP 3 · the cut wall moved outwards, from the step-2 result
// =====================================================================
#pagebreak()
#let s3-lines = ((s2-base.b, luma(90), "dashed", [after step 2 (the cut wall as designed)]), ..s3.enumerate().map(((i, o)) => (o.b, if i == 0 { bld } else if i == 3 { red } else { amber }, "solid", [#s3-labels.at(i): +#f2(o.d) m])))
#let r3(l, f) = (l, ..s3.map(f))
#let s3-dots = s3.enumerate().map(((i, o)) => (o.t-cal.p, if i == 0 { bld } else if i == 3 { red } else { amber }, [+#f2(o.d): #f2(o.t-deed.m) / #f2(o.t-cal.m)]))
#grid(columns: (auto, 1fr), column-gutter: 9pt,
  [
    #zoom(s3-lines, s3-dots, [])
    #v(3pt)
    #block(width: 8.0cm, text(6.6pt, fill: gray)[The cut wall enlarged. Grey dashed: after step 2. Purple: the largest move that keeps #f2(stop-rule) m from the wall as built. Amber: 0.20 and 0.40 m, for information. Red: the largest move that keeps #f2(stop-rule) m from the deed line. Each dot = the tightest point of that option with its margin deed / from the wall. The lane's notch (the deed vertex at 14.06, 8.86 and the wall vertex at 15.68, 7.37) governs: every move outward costs the same at the notch.])
  ],
  [
    #title([Step 3 · reducing the cut wall (the north-east slope), from the step-2 result], [page 3 of 4 · the cut wall B2–B3 moved outwards, parallel · keeping ≥ #f2(stop-rule) m from the wall as built · TO APPLY ONLY AFTER THE OFFICIAL SURVEY])
    #text(7pt, fill: gray)[Start: the step-2 result (#if s2-rec == none [no rotation: the house #f2(s1-rec.s) m west of the day-1 position] else [B5 east #f2(s2-rec.e) m]). The cut wall moves outwards by d; B2 slides east along the north wall (#f2(s3.at(1).b2-move / s3.at(1).d) d) and B3 north along the east wall (#f2(s3.at(1).b3-move / s3.at(1).d) d); the cut wall gets shorter. Each room along the cut gains ≈ d × its length along the cut.]
    #v(2pt)
    #tbl(columns: (2.3fr, 1.1fr, 1fr, 1fr, 1.1fr), size: 6.5pt,
      table.header([*Move outwards d (m)*], ..s3.enumerate().map(((i, o)) => [*#f2(o.d)* #text(size: 5.5pt)[#s3-labels.at(i)]])),
      ..r3([*Tightest margin from the wall as built* (≥ #f2(stop-rule))], o => colw(o.t-cal.m)),
      ..r3([Tightest margin from the deed line], o => col(o.t-deed.m, spare)),
      ..r3([B2 moves east · B3 moves north (m) · the cut wall's length (was #f2(s2-base.sides.at(1)))], o => [#f2(o.b2-move) · #f2(o.b3-move) · #f2(o.cut-length)]),
      ..r3([*Gross floor area gained per floor* (m²; the same on the roof)], o => [*#f2(o.gross)*]),
      ..r3([Ground floor: the air tower (y 0–1 on the cut) · the maid bath (y 1–2.8) · the maid room (y 2.8–6)], o => [#f2(o.gf.tower) · #f2(o.gf.bath) · #f2(o.gf.maid)]),
      ..r3([Laundry · kitchen: they do not touch the cut wall (the maid room and the maid bath lie between): no gain unless the partitions are re-planned], o => [0 · 0]),
      ..r3([First floor: the tower / HRV base (y 0–1) · bedroom 1 (y 1–6)], o => [#f2(o.ff.tower) · #f2(o.ff.bed1)]),
      ..r3([Bedroom 1 clear area (now #f2(s3.first().bed1-clear - s3.first().ff.bed1) m²; the hotel en-suite B4 needs #f2(b4-need) m² clear AND a rectangular bedroom)], o => [#f2(o.bed1-clear) · #if o.bed1-clear >= b4-need [area OK, shape still a wedge] else [#text(fill: red)[no: short by #f2(b4-need - o.bed1-clear) m², and a wedge]]]),
      ..r3([The notch check (row 18, from the present tightest point square to the wall) must read at least this for the move to keep #f2(stop-rule) from the wall as built], o => [#f2(o.need-notch)]),
    )
    #text(7pt)[
      *The columns and beams on the cut line* (`docs/STRUCTURE_STUDY.md`: three columns at the cut's ends and at the maid bath / maid room partition, spans 3.2 · 3.6 m; the cut wall proposed as an RC wall W4): the corner column at B2 slides east along the north wall by the B2 move, the middle one outwards by d, the column at B3 north along the east wall by the B3 move; the north wall's last span grows by the B2 move (4.36 → 4.36 + #f2(s3.at(1).b2-move / s3.at(1).d) d), the east wall's first span shrinks by the B3 move (4.45 → 4.45 − #f2(s3.at(1).b3-move / s3.at(1).d) d); the cut-wall beams get shorter; the pads and the strip footing under W4 move with it. Nothing changes in the stiffness idea (the east box keeps its three RC walls).
      *The malqaf tower and the roof:* the air tower stands in the cut tip (x 8.95–10.59, y 0–1) with its east side on the cut line and the HRV base under it on the same line (`studies/roof.typ` Z2a): both grow outwards by d over 1.14 m of the cut (≈ #f2(s3.at(1).gf.tower / s3.at(1).d) d m²); the tower's louvred head keeps its size; the roof's cut edge, the main cornice and the attic's set-back follow the wall (the attic stays 1.40 m inside the cornice); the roof gains the same gross area; the sight-line checks of the roof study are not affected by a move of this size.
      *What it means:* with the wall as built taken #f2(delta) m inside the deed line all along, the cut wall after steps 1–2 keeps #f2(s2-base.t-cal.m) m: *the largest safe move is #f2(s3.first().d) m — nothing worth building.* The 0.20 and 0.40 m moves (#f2(s3.at(1).gross) and #f2(s3.at(2).gross) m² per floor, bedroom 1 +#f2(s3.at(1).ff.bed1) / +#f2(s3.at(2).ff.bed1) m²) keep the deed line's margin but fall to #f2(s3.at(1).t-cal.m) / #f2(s3.at(2).t-cal.m) m from the wall as built; the largest move from the deed line (#f2(s3.last().d) m, +#f2(s3.last().gross) m² per floor) would stand #f2(-s3.last().t-cal.m) m *inside* the setback counted from the wall. Bedroom 1's hotel en-suite B4 does not fit with any of them: it fails on shape (the room is a wedge) and, below ≈ 0.31 m, on area. *To apply only after the official survey* fixes the wall and the notch: the survey's reading at the notch (row 18) says which column applies.
    ]
  ],
)

#v(2pt)
#sub-head[Step 3 · set-out table of the largest safe move (+#f2(s3.first().d) m) · information only, to apply only after the official survey]
#tape-table(s3.first(), [B2 slides #f2(s3.first().b2-move) m east along the north wall, B3 #f2(s3.first().b3-move) m north along the east wall; B1, B4, B5 as step 2. The cut wall B2–B3 shortens to #f2(s3.first().cut-length). *To apply only after the official survey.*])

// =====================================================================
// SUMMARY · the three steps side by side
// =====================================================================
#pagebreak()
#title([Summary · the three steps side by side and the recommended path], [page 4 of 4 · STUDY ONLY: the house as set out on day 1 is unchanged in the design files and on the set-out sheet; the owner decides step by step])
#let path = ((([as set out (day 1)], base)), (([Step 1 · #f2(s1-rec.s) m west], s1-rec)), (([Step 2 · #if s2-rec == none [no rotation] else [B5 east #f2(s2-rec.e)]], s2-base)), (([Step 3 · cut wall +#f2(s3.first().d) m (after the survey)], s3.first())))
#tbl(columns: (2.6fr, 1fr, 1fr, 1fr, 1fr), size: 7pt,
  table.header([*Measure*], ..path.map(((l, o)) => [*#l*])),
  ..([Tightest margin on any wall: from the deed line / *from the wall as built*], ..path.map(((l, o)) => [#col(o.t-deed.m, spare) / #colw(o.t-cal.m)])),
  ..([B2's margin: deed / from the wall], ..path.map(((l, o)) => [#f2(o.b2-m) / #colw(o.b2-cal)])),
  ..([B3 to the deed line / to the wall as built], ..path.map(((l, o)) => [#f2(o.b3-lane) / #f2(o.b3-lane - delta)])),
  ..([Route beside the driveway: B1 to the yard wall · B5 to the yard wall · B5 to the driveway's edge], ..path.map(((l, o)) => [#f2(o.b1-yard) · #f2(o.b5-yard) · #f2(o.b5-drv)])),
  ..([West wall east of the M line at B1 / B5 (the strip) · the cornice's edge clear of the driveway], ..path.map(((l, o)) => [#f2(o.strip-b1) / #f2(o.strip-b5) · #col(o.cornice-clear, 0)])),
  ..([Guest path: band 1.2 on the driveway + the strip = walking width at B1], ..path.map(((l, o)) => [#f2(guest-band + o.strip-b1)])),
  ..([M1 → B1 (the owner's 5.00 rule) · B1 to the north setback line], ..path.map(((l, o)) => [#f2(o.b1-m1) · #f2(o.b1-north)])),
  ..([Car bay: gap to the north wall · east of the entrance path · the reverse move past B1], ..path.map(((l, o)) => [#f2(o.north-at-bay) · #f2(o.bay-entrance) · #f2(o.swept-b1)])),
  ..([Palm 1 / palm 2 to the nearest wall], ..path.map(((l, o)) => [#f2(o.palm1) / #f2(o.palm2)])),
  ..([Gas cabinet to the wall as built (≥ 1.5) · tank to B5 (≥ 5) · soakaway E to the east wall], ..path.map(((l, o)) => [#col(o.gas-lane-cal, 1.5) · #f2(o.tank-b5) · #f2(o.soak-e)])),
  ..([Gross floor area of the outline (m²) · gained per floor], ..path.map(((l, o)) => [#f2(o.area) · #sgn2(o.area - base.area)])),
  ..([Garden lost (m²)], ..path.map(((l, o)) => [#f2(o.garden-lost)])),
  ..([What is gained], [—], [+#f2(s1-rec.t-cal.m - base.t-cal.m) m at the cut wall (from the wall); the palms +#f2(s1-rec.s)], [#if s2-rec == none [nothing (no option passes the STOP rule)] else [the route at the south +#f2(s2-rec.e)]], [+#f2(s3.first().gross) m² per floor: nothing worth building]),
  ..([What is lost], [—], [the route at B1 #f2(field.b1-yard) → #f2(s1-rec.b1-yard); the strip beside the west wall #f2(base.strip-b1) → #f2(s1-rec.strip-b1); B1 = #f2(s1-rec.b1-m1) from M1], [—], [—]),
  ..([Blocks to move on site], [—], [all five, #f2(s1-rec.s) m west], [#if s2-rec == none [none] else [four (B2 stays)]], [B2 and B3 only, after the survey]),
)
#v(4pt)
#grid(columns: (1.3fr, 1fr), column-gutter: 10pt,
  box(fill: rgb("#2f6b4f").lighten(85%), stroke: 1pt + accent, inset: 6pt, radius: 3pt, width: 100%)[
    #text(10pt, weight: "bold", fill: accent)[The recommended path] \
    #text(7.2pt)[
      *1 · Shift the house #f2(s1-rec.s) m west* (all five blocks, the house unchanged): the only step that buys margin at the cut wall — from the wall as built #f2(base.t-cal.m) → #f2(s1-rec.t-cal.m) m (the owner's 0.40 reached), from the deed line #f2(base.t-deed.m) → #f2(s1-rec.t-deed.m) m — at the price of a #f2(s1-rec.strip-b1) m strip beside the west wall (the guest path stays the 1.2 m band on the driveway's edge; the cornice #f2(s1-rec.cornice-clear) m clear of the driveway) and a route of #f2(s1-rec.b1-yard) m at B1. Tape table on page 1.

      *2 · No rotation:* every option breaks the owner's STOP rule by 0.005–0.04 m from the wall as built (#s2.map(o => f2(o.t-cal.m)).join(" / ")) for a gain of 0.10–0.30 m at the south end only. The position after step 1 stands (page 2).

      *3 · The cut wall stays as designed* until the official survey: the largest safe move from the wall as built is #f2(s3.first().d) m. If the survey (or the notch check, sheet row 18) shows the wall at the notch further off than the #f2(delta) m assumed here, page 3 says what 0.20 / 0.40 m would gain (#f2(s3.at(1).gross) / #f2(s3.at(2).gross) m² per floor, bedroom 1 +#f2(s3.at(1).ff.bed1) / +#f2(s3.at(2).ff.bed1) m²; the hotel en-suite B4 still does not fit). Decision kept: no reduction of the cut wall until the official survey.

      *Before any block moves:* the notch check (row 18: from the tightest point square to the lane wall; the deed says #f2(base.t-lane.m), the wall as built would give #f2(base.t-lane.m - delta)); then the owner's decision on step 1; then `design_gf.typ` gets the shift and the set-out sheet is re-issued (not done here).
    ]
  ],
  [
    #text(7pt)[
      *How the two margins are read.* The deed line is the plot's legal limit; the setback lines of the envelope (`base.typ`) are 2.0 m from the lane line and 3.0 m from the north line. The field value at B2 (2.40 m to the wall's inner face against 3.08 m to the deed line) says the wall stands #f2(delta) m inside the deed line; this study takes the same offset along the whole lane wall, which is the conservative reading (the owner saw B2 as the nearest point of the house to the wall, so the wall at the notch is probably further off than that). A setback counted from the wall as built is therefore the strict case; the deed-line margin the lenient one. The official survey replaces both.

      *What does not change in any step:* the house itself (its sides, diagonals, rooms and the yard); the driveway's #f2(drv-w) m; the guest band; the car bay; the tanks, the septic and the sewer's falls; the palms' protection; the garden's low wall. *What changes:* the set-out tapes (page 1), the owner's rule B1 = 5.00 m (→ #f2(s1-rec.b1-m1)), the strip beside the west wall, the route's width at B1.
    ]
    #v(4pt)
    #text(6.3pt, fill: gray)[Placement in three steps · Study checks #if all-ok [passed] else [FAILED]: #checks.map(c => c.at(0)).join([ · ]). Field values: the owner on site, day 1 (4 Nov 2026; docs/SITE_SETOUT.md § 7 rows 23–24). Sources: base.typ (the site v2), design_gf.typ (the house), site_plan.typ (the services), roof.typ, STRUCTURE_STUDY.md, bedroom1_bath.typ (B4), rotation_b2.typ (the calibration).]
  ],
)

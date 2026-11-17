// whole_farm.typ · Taif / Palm House · THE WHOLE FARM on the site baseline v2 (field check 03 Oct 2026) with the old buildings · 5 Nov 2026 · STUDY
// Sources: data/site_v2.csv (tools/site_frame.py from site/inputs/taif_north_zone_final_v2.csv, UTM deed coordinates → the design frame) and
// data/deed_sketch.csv (the old house and its annex digitised from the scanned deed site/inputs/Scanned_20190818-1737.pdf, georeferenced on 7 deed corners).
// Design frame: origin M1 = the gate's east post G′ · y along the M line southwards · x east, square to it. The new house = the room CSVs + shift (design_gf.typ).
// EVERY OLD BUILDING IS APPROXIMATE (the deed sketch ± 1–3 m; the v3 survey where it says MEASURED); the official survey has the last word.
// 5 Nov 2026, THE OWNER'S ANSWERS: the old house WEST of the driveway as on the sketch (confirmed); the old majlis is PART OF it; the covered parking (2 cars) and the
// existing ground tank are SOUTH of the old house, west of the driveway near peg R, the reserved tank next to the existing one; the septic outside the north wall near C1
// serves the old house; NOTHING of the farm lies south of the build land (the brief's south boxes removed).
#import "@preview/cetz:0.4.2"
#import "../design_gf.typ": shift, outline-csv-gf
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 7.6pt)
#set par(leading: 0.42em)

// ---------- the data ----------
#let rows = csv("../data/site_v2.csv", row-type: dictionary)
#let pts(prefix) = rows.filter(r => r.item.starts-with(prefix)).map(r => (float(r.x), float(r.y)))
#let pt(name) = { let r = rows.find(r => r.item == name); assert(r != none, message: "site_v2.csv: missing " + name); (float(r.x), float(r.y)) }
#let plot = pts("plot corner ")
#assert(plot.len() == 20, message: "the deed has 20 corners")
#let drv = pts("driveway pt")
#let land = pts("build land pt")
#let env = pts("buildable envelope pt")
#let marks = pts("lane wall mark E")
#let T1 = pt("palm 1 trunk centre (r 0.26 m)")
#let T2 = pt("palm 2 trunk centre (r 0.26 m)")
#let well = pt("water well centre (ring 5.0 m)")
#let R = pt("reference peg R")
#let S = pt("reference peg S")
#let D = pt("dakka corner D (south corner of the dakka)")
#let G = pt("gate west post G")
#let M1 = pt("gate east post G' = M1")
#let Ms = (M1, pt("M line peg M2 (6.36 m from M1)"), pt("M line peg M3 (18.52 m from M1)"), pt("M line peg M4 (28.80 m from M1)"))
#let south-line = (pt("south line end (driveway side)"), pt("south line end (lane side)"))
#let barn = pts("sheep barn pt")
#let workers = pts("workers house pt")
#let shade = pts("shade house pt")
#let sgate = pt("service gate (east wall)")
#let old-house = pts("old house pt")
#let annex = pts("old house annex pt")
#let well-sk = pt("well from the deed sketch (check only)")
#assert(old-house.len() == 4 and annex.len() == 4, message: "deed_sketch.csv: the old house and the annex need 4 corners each")
// the new house (outer wall faces) at the current position
#let P(p) = (p.at(0) + shift.at(0), p.at(1) + shift.at(1))
#let house = ((-0.125, -0.125), (10.535, -0.125), (13.436, 5.214), (13.436, 24.125), (-0.125, 24.125)).map(P)
#let court = ((4.35, 6.6), (8.85, 6.6), (8.85, 12.9), (4.35, 12.9)).map(P)
#let scourt = ((4.25, 20.55), (5.8, 20.55), (5.8, 19.25), (10.0, 19.25), (10.0, 24.0), (4.25, 24.0)).map(P)
#let west-wall = (house.at(0), house.at(4))
// without data: drawn dotted, "to be measured" (the owner's answers of 5 Nov 2026 placed; the boxes as in studies/site_plan.typ)
#let carport = (-10.0, 29.2, -4.5, 34.7)      // covered parking, 2 cars, SOUTH of the old house, west of the driveway, open to the driveway
#let tank-old = (-7.5, 35.7, -4.5, 38.2)      // the existing ground tank, SOUTH of the old house, west of the driveway, near peg R
#let tank-new = (-11.0, 35.7, -7.5, 38.2)     // the reserved tank next to it, west
#let septic-box = (-10.5, -1.9, -6.5, 0.5)    // the septic outside the north wall near C1 (it serves the old house)
#let assumed = (
  ([covered parking (2 cars, owner 5 Nov 2026)], carport),
  ([existing tank], tank-old),
  ([reserved tank], tank-new),
  ([existing septic (outside the wall)], septic-box),
)
#let drv-w = 3.95

// ---------- geometry ----------
#let dist(a, b) = calc.sqrt(calc.pow(a.at(0) - b.at(0), 2) + calc.pow(a.at(1) - b.at(1), 2))
#let area(poly) = {
  let s = 0.0
  for i in range(poly.len()) { let a = poly.at(i); let b = poly.at(calc.rem(i + 1, poly.len())); s += a.at(0) * b.at(1) - b.at(0) * a.at(1) }
  calc.abs(s) / 2
}
#let pseg(p, a, b) = {
  let dx = b.at(0) - a.at(0)
  let dy = b.at(1) - a.at(1)
  let l2 = dx * dx + dy * dy
  let t = if l2 == 0 { 0 } else { calc.max(0, calc.min(1, ((p.at(0) - a.at(0)) * dx + (p.at(1) - a.at(1)) * dy) / l2)) }
  dist(p, (a.at(0) + t * dx, a.at(1) + t * dy))
}
#let edges(poly) = range(poly.len()).map(i => (poly.at(i), poly.at(calc.rem(i + 1, poly.len()))))
#let sample(poly, step: 0.25) = {
  let out = ()
  for (a, b) in edges(poly) {
    let k = calc.max(1, int(calc.ceil(dist(a, b) / step)))
    for j in range(k) { let t = j / k; out.push((a.at(0) + t * (b.at(0) - a.at(0)), a.at(1) + t * (b.at(1) - a.at(1)))) }
  }
  out
}
#let poly-dist(A, B) = calc.min(..sample(A).map(p => calc.min(..edges(B).map(((a, b)) => pseg(p, a, b)))))   // polygon edges to polygon edges
#let seg-poly-dist(s, B) = calc.min(..sample(B).map(p => pseg(p, ..s)))
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
#let r1(v) = str(calc.round(v, digits: 1))
#let r2(v) = str(calc.round(v, digits: 2))
#let box-poly(b) = ((b.at(0), b.at(1)), (b.at(2), b.at(1)), (b.at(2), b.at(3)), (b.at(0), b.at(3)))

// ---------- the numbers ----------
#let deed-area = 7737.85
#let a-plot = area(plot)
#let old-all = (old-house, annex)
#let d-old-west = calc.min(..old-all.map(A => seg-poly-dist(west-wall, A)))             // the old buildings to the new house's west wall
#let d-old-M = -calc.max(..(old-house + annex).map(p => p.at(0)))                          // to the M line (x = 0): positive = west of it
#let drv-west = (drv.at(0), drv.at(3))                                                     // the driveway's west edge (G → pt4)
#let d-old-drv = calc.min(..old-all.map(A => seg-poly-dist(drv-west, A)))
#let annex-in-drv = (old-house + annex).filter(p => inside(p, drv)).len()
#let route-width = d-old-west                                                              // the corridor between the old buildings and the new house's west wall (the driveway + the west strip)
#let box-pt-dist(b, p) = { let dx = calc.max(b.at(0) - p.at(0), 0, p.at(0) - b.at(2)); let dy = calc.max(b.at(1) - p.at(1), 0, p.at(1) - b.at(3)); calc.sqrt(dx * dx + dy * dy) }
#let old-south = calc.max(..(old-house + annex).map(p => p.at(1)))
#let d-tank-R = box-pt-dist(tank-old, R)
#let d-tank-house = calc.min(..(tank-old, tank-new).map(b => calc.min(..sample(house).map(p => box-pt-dist(b, p)))))
#let d-annex-D = calc.min(..annex.map(p => dist(p, D)))
#let d-well = dist(well, well-sk)
#let d-old-house-house = poly-dist(old-house, house)
#let palms-house = (dist-poly: (seg-poly-dist((T1, T1), house) - 0.265, seg-poly-dist((T2, T2), house) - 0.265))
#let house-in-env = sample(house, step: 0.1).all(p => inside(p, env))
#let d-well-house = seg-poly-dist((well, well), house) - 2.5
#let d-sgate-house = seg-poly-dist((sgate, sgate), house)
#let checks = (
  ([the 20 deed corners close to the deed area 7 737.85 m² (#r1(a-plot) m², rigid transform from UTM)], calc.abs(a-plot - deed-area) < 10),
  ([M1 is the origin and M4 lies on the M line 28.80 m south (#r2(dist(M1, Ms.at(3))))], dist(M1, (0, 0)) < 0.01 and calc.abs(Ms.at(3).at(0)) < 0.01 and calc.abs(dist(M1, Ms.at(3)) - 28.80) < 0.01),
  ([the well digitised from the deed sketch lies within 2 m of the v2 well (#r2(d-well) m): the georeferencing check], d-well < 2.0),
  ([the annex's south corner lies within 2 m of the fitted dakka corner D (#r2(d-annex-D) m): the sketch and the field agree], d-annex-D < 2.0),
  ([the new house's walls lie inside the buildable envelope], house-in-env),
  ([the old house (deed sketch) is clear of the new house (#r1(d-old-house-house) m), the M line (#r1(d-old-M) m) and the driveway's east edge; its annex touches the driveway's west edge (#r2(d-old-drv) m)], d-old-house-house > 5 and d-old-M > 0),
  ([the covered parking and the tanks (owner, 5 Nov 2026) lie west of the driveway and south of the old house (y ≥ #r1(old-south)), #r1(tank-old.at(1) - carport.at(3)) m apart, the existing tank #r1(d-tank-R) m from peg R and the tanks #r1(d-tank-house) m from the new house (≥ 5)], (carport, tank-old, tank-new).all(b => b.at(2) <= -drv-w + 1e-9 and b.at(1) >= old-south) and tank-old.at(1) - carport.at(3) >= 0.5 and d-tank-R <= 6 and d-tank-house >= 5),
)
#let all-ok = checks.all(c => c.at(1))

// ---------- PREVIEW (17 Nov 2026): the house 1.3 m further SOUTH along the M line + the ONE-STEP north-east corner (studies/step_corner.typ option 6: the step at x 11.275 / y 3.2) ----------
// A preview page only (page 3): pages 1–2 and every number above use the current position. pv-s = 0 would draw the house where it stands today.
#let pv-s = 1.3; #let pv-step = (11.275, 3.2)
#let Pv(p) = (p.at(0) + shift.at(0), p.at(1) + shift.at(1) + pv-s)
#let house-pv = ((-0.125, -0.125), (pv-step.at(0) + 0.125, -0.125), (pv-step.at(0) + 0.125, pv-step.at(1) - 0.125), (13.436, pv-step.at(1) - 0.125), (13.436, 24.125), (-0.125, 24.125)).map(Pv)
#let court-pv = court.map(p => (p.at(0), p.at(1) + pv-s)); #let scourt-pv = scourt.map(p => (p.at(0), p.at(1) + pv-s))
#let house-pv-long = house-pv.map(p => if p.at(1) > house-pv.at(0).at(1) + 20 { (p.at(0), p.at(1) + 0.95) } else { p })   // the future lengthening (+0.95 m, the twins' 4.0 m rooms)
#let closest-on(pt, segs) = segs.map(((a, b)) => { let dx = b.at(0) - a.at(0); let dy = b.at(1) - a.at(1); let l2 = dx * dx + dy * dy
  let u = if l2 == 0 { 0 } else { calc.max(0, calc.min(1, ((pt.at(0) - a.at(0)) * dx + (pt.at(1) - a.at(1)) * dy) / l2)) }; (a.at(0) + u * dx, a.at(1) + u * dy) }).sorted(key: c => dist(pt, c)).first()
#let env-segs = edges(env).filter(((a, b)) => not (calc.abs(a.at(0)) < 0.01 and calc.abs(b.at(0)) < 0.01))   // the setback lines (the M line has no setback)
#let lane-segs = range(1, 8).map(i => (plot.at(i), plot.at(i + 1)))                                           // the lane boundary, corners 2 → 9 (the model's lane line)
#let built-offset = 0.62; #let setback-built = 2.0                 // SITE_SETOUT.md § 5: the wall as built ≈ 0.62 m inside the model's lane line; the rule 2.0 m from it
#let deed-d(pt) = calc.min(..env-segs.map(((a, b)) => pseg(pt, a, b))); #let lane-d(pt) = calc.min(..lane-segs.map(((a, b)) => pseg(pt, a, b)))
#let pv-faces = sample(house-pv, step: 0.05); #let td-faces = sample(house, step: 0.05)
#let pv-deed-pt = pv-faces.sorted(key: p => deed-d(p)).first(); #let pv-deed = deed-d(pv-deed-pt); #let pv-deed-to = closest-on(pv-deed-pt, env-segs)
#let pv-lane-pt = pv-faces.sorted(key: p => lane-d(p)).first(); #let pv-lane = lane-d(pv-lane-pt); #let pv-built = pv-lane - built-offset - setback-built; #let pv-lane-to = closest-on(pv-lane-pt, lane-segs)
#let td-deed = deed-d(td-faces.sorted(key: p => deed-d(p)).first()); #let td-built = lane-d(td-faces.sorted(key: p => lane-d(p)).first()) - built-offset - setback-built
#let B1 = house-pv.at(0); #let pv-b1 = dist(B1, M1); #let td-b1 = dist(house.at(0), M1)
#let north-y(x) = -x * 1.595 / 8.634                                 // the plot's north boundary between M1 and corner 2
#let strip-at(x, H) = H.at(0).at(1) - north-y(x)                      // the north strip's depth: the north wall face to the boundary
#let pv-strip = strip-at(B1.at(0), house-pv); #let td-strip = strip-at(house.at(0).at(0), house)
#let pv-strip-mid = strip-at(6.0, house-pv)
#let pv-palm = (T1, T2).map(Tp => (closest-on(Tp, edges(house-pv)), seg-poly-dist((Tp, Tp), house-pv) - 0.265)); #let td-palm = (T1, T2).map(Tp => seg-poly-dist((Tp, Tp), house) - 0.265)
#let long-palm = (T1, T2).map(Tp => seg-poly-dist((Tp, Tp), house-pv-long) - 0.265)
#let SE = house-pv.at(4); #let SW = house-pv.at(5)
#let pv-south = (closest-on(SE, (south-line,)), pseg(SE, ..south-line), closest-on(SW, (south-line,)), pseg(SW, ..south-line))   // the south wall's corners to the illustrative south line
#let td-south = (pseg(house.at(3), ..south-line), pseg(house.at(4), ..south-line))
#let long-south = (pseg(house-pv-long.at(4), ..south-line), pseg(house-pv-long.at(5), ..south-line))
#let pv-S = (closest-on(S, edges(house-pv)), seg-poly-dist((S, S), house-pv)); #let td-S = seg-poly-dist((S, S), house)
#let pv-R = (closest-on(R, edges(house-pv)), seg-poly-dist((R, R), house-pv)); #let td-R = seg-poly-dist((R, R), house)
#let pv-D = (closest-on(D, edges(house-pv)), seg-poly-dist((D, D), house-pv)); #let td-D = seg-poly-dist((D, D), house)
#let box-poly-dist(b, H) = calc.min(..sample(H, step: 0.05).map(p => box-pt-dist(b, p)))
#let pv-carport = box-poly-dist(carport, house-pv); #let td-carport = box-poly-dist(carport, house)
#let pv-tank = box-poly-dist(tank-old, house-pv); #let td-tank = box-poly-dist(tank-old, house)
#let pv-old = poly-dist(old-house, house-pv); #let td-old = poly-dist(old-house, house); #let pv-annex = poly-dist(annex, house-pv); #let td-annex = poly-dist(annex, house)
#let pv-in-env = sample(house-pv, step: 0.1).all(p => inside(p, env))

// ---------- drawing ----------
#let ink = rgb("#3d4a45"); #let accent = rgb("#5a7d2a"); #let red = rgb("#b5452f"); #let blue = rgb("#2f5f8a"); #let brown = rgb("#8a5a2b"); #let amber = rgb("#b58a1f"); #let violet = rgb("#6a3d9a")
#let q(p) = (p.at(0), -p.at(1))
#let north = (0.364, 0.931)
#let farm(length: 2.2mm, box: (-28, -6, 62, 134), zone: false, preview: false) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, body, size: 5pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, body))
  let poly(P, fill: none, stroke: none, close: true) = line(..P.map(q), close: close, fill: fill, stroke: stroke)
  let Rb(b, fill: none, stroke: none) = rect(q((b.at(0), b.at(1))), q((b.at(2), b.at(3))), fill: fill, stroke: stroke)
  let dotted(c) = (paint: c, thickness: 0.6pt, dash: "dotted")
  let dashed(c) = (paint: c, thickness: 0.7pt, dash: "dashed")
  // the world extent (fixed, so the canvas size is known and the view can be clipped to `box`)
  rect(q((-60, -20)), q((80, 140)), stroke: none, fill: none)
  rect(q((box.at(0), box.at(1))), q((box.at(2), box.at(3))), stroke: 0.4pt + luma(150), fill: none)
  // the plot (deed), the build land, the setbacks, the envelope, the driveway
  poly(plot, fill: rgb("#f4f1e6"), stroke: 1.3pt + ink)
  poly(land, fill: rgb("#f4c6c6"), stroke: none)
  poly(env, fill: rgb("#e3f0dd"), stroke: 0.7pt + accent)
  poly(drv, fill: rgb("#d6e2ee"), stroke: 0.5pt + blue)
  line(q(south-line.at(0)), q(south-line.at(1)), stroke: (paint: accent, thickness: 0.9pt, dash: "dashed"))
  line(q(M1), q(Ms.at(3)), stroke: 1pt + accent)
  // the gates
  line(q(G), q(M1), stroke: 3pt + red)
  let gdir = (plot.at(14).at(0) - plot.at(13).at(0), plot.at(14).at(1) - plot.at(13).at(1))
  let gl = calc.sqrt(gdir.at(0) * gdir.at(0) + gdir.at(1) * gdir.at(1))
  let gu = (gdir.at(0) / gl * 2.28, gdir.at(1) / gl * 2.28)
  line(q((sgate.at(0) - gu.at(0), sgate.at(1) - gu.at(1))), q((sgate.at(0) + gu.at(0), sgate.at(1) + gu.at(1))), stroke: 3pt + red)
  // the measured old buildings (v3 survey)
  for (Pp, l) in ((barn, [sheep barn (measured)]), (shade, [shade house (measured)])) { poly(Pp, fill: rgb("#e6dccb"), stroke: 0.8pt + brown) }
  poly(workers, fill: rgb("#e6dccb"), stroke: (paint: brown, thickness: 0.8pt, dash: "dashed"))
  // the deed-sketch buildings (approximate)
  poly(old-house, fill: rgb("#f3dcc0"), stroke: (paint: brown, thickness: 1pt, dash: "dashed"))
  poly(annex, fill: rgb("#f3dcc0").transparentize(40%), stroke: (paint: brown, thickness: 0.8pt, dash: "dashed"))
  // the assumed items (no data)
  for (l, b) in assumed { Rb(b, stroke: dotted(luma(110))) }
  // the well
  circle(q(well), radius: 2.5, fill: rgb("#cfe3f5"), stroke: 0.7pt + blue)
  circle(q(well-sk), radius: 0.4, fill: none, stroke: 0.6pt + red)
  // the palms
  for Tp in (T1, T2) { circle(q(Tp), radius: 1.0, fill: rgb("#cfdfc3"), stroke: 0.4pt + accent); circle(q(Tp), radius: 0.265, fill: accent, stroke: none) }
  // the new house (the preview page: today's outline dashed underneath, the house 1.3 m south with the one-step corner solid, the dimensions)
  if preview {
    poly(house, fill: none, stroke: (paint: violet, thickness: 0.8pt, dash: "dashed"))
    poly(house-pv-long, fill: none, stroke: (paint: amber, thickness: 0.6pt, dash: "dotted"))
    poly(house-pv, fill: rgb("#ddd3ea").transparentize(20%), stroke: 1.2pt + violet)
    poly(court-pv, fill: white, stroke: 0.5pt + violet)
    poly(scourt-pv, fill: white, stroke: 0.5pt + violet)
    let dim(a, b, l, c: red, off: (0, 0), size: 4.6pt, angle: 0deg, anchor: "center") = { line(q(a), q(b), stroke: (paint: c, thickness: 0.7pt), mark: (start: "|", end: "|", scale: 0.5)); T(((a.at(0) + b.at(0)) / 2 + off.at(0), (a.at(1) + b.at(1)) / 2 + off.at(1)), l, size: size, fill: c, angle: angle, anchor: anchor) }
    dim(M1, B1, [B1 from M1 #r2(pv-b1) (today #r2(td-b1))], c: red, off: (-0.6, 0), angle: -83deg)
    dim(B1, (B1.at(0), north-y(B1.at(0))), [north strip #r2(pv-strip) at B1 (today #r2(td-strip))], c: blue, off: (3.6, -0.4), angle: 0deg)
    dim((6.0, house-pv.at(0).at(1)), (6.0, north-y(6.0)), [#r2(pv-strip-mid) at x 6], c: blue, off: (1.6, 0), angle: -90deg)
    dim(pv-deed-pt, pv-deed-to, [deed line #r2(pv-deed) (today #r2(td-deed))], c: accent, off: (1.4, -0.8), angle: 0deg, anchor: "west")
    dim(pv-lane-pt, pv-lane-to, [lane line #r2(pv-lane) = wall as built #r2(pv-lane - built-offset): #r2(pv-built) beyond the 2.0 m (today #r2(td-built))], c: accent, off: (1.2, 1.2), angle: 0deg, anchor: "west")
    dim(T1, pv-palm.at(0).at(0), [T1 #r2(pv-palm.at(0).at(1)) to the east wall], c: accent, off: (0, -0.9))
    dim(T2, pv-palm.at(1).at(0), [T2 #r2(pv-palm.at(1).at(1)) to the SE corner (today #r2(td-palm.at(1)))], c: accent, off: (0.4, 1.2))
    dim(SE, pv-south.at(0), [SE corner → south line #r2(pv-south.at(1)) (today #r2(td-south.at(0))); after +0.95: #r2(long-south.at(0))], c: brown, off: (3.2, 0.8), angle: -80deg)
    dim(SW, pv-south.at(2), [SW corner → south line #r2(pv-south.at(3)) (today #r2(td-south.at(1)))], c: brown, off: (-1.2, 0), angle: -90deg, anchor: "center")
    dim(S, pv-S.at(0), [peg S #r2(pv-S.at(1))], c: brown, off: (1.2, 0.8))
    dim(R, pv-R.at(0), [peg R #r2(pv-R.at(1)) (today #r2(td-R))], c: brown, off: (-2.4, 1.0))
    dim(D, pv-D.at(0), [dakka corner D #r2(pv-D.at(1)) (unchanged)], c: brown, off: (0, -0.8))
    dim((carport.at(2), SW.at(1)), SW, [carport #r2(pv-carport) (unchanged)], c: luma(90), off: (0, -0.8))
    dim((tank-old.at(2), tank-old.at(1)), SW, [tanks #r2(pv-tank) (today #r2(td-tank))], c: luma(90), off: (0.8, 1.0))
    T((B1.at(0) - 0.6, B1.at(1) - 0.5), [B1], size: 5.5pt, fill: violet, anchor: "east")
    T((house-pv.at(1).at(0) + 0.3, house-pv.at(1).at(1) - 0.5), [the step: x #r2(pv-step.at(0)) / y #r2(pv-step.at(1))], size: 4.6pt, fill: violet, anchor: "west")
    T((7.0, house-pv.at(0).at(1) + 13.5), [NEW HOUSE\ 1.3 m south + one step (preview)], size: 6pt, fill: violet)
    T((7.0, house.at(0).at(1) + 1.4), [today's outline (dashed)], size: 4.6pt, fill: violet)
    T((7.0, house-pv.at(5).at(1) + 1.5), [+0.95 m lengthening (dotted): the twins' 4.0 m rooms], size: 4.4pt, fill: amber)
  } else {
    poly(house, fill: rgb("#ddd3ea"), stroke: 1pt + violet)
    poly(court, fill: white, stroke: 0.5pt + violet)
    poly(scourt, fill: white, stroke: 0.5pt + violet)
  }
  // the pegs
  for p in Ms { rect(q((p.at(0) - 0.35, p.at(1) - 0.35)), q((p.at(0) + 0.35, p.at(1) + 0.35)), fill: accent, stroke: none) }
  for (p, n) in ((D, [D]), (R, [R]), (S, [S])) { circle(q(p), radius: 0.45, fill: brown, stroke: none) }
  if zone {
    // enlarged north zone: full labels
    for (i, p) in plot.enumerate() { if p.at(0) >= box.at(0) and p.at(0) <= box.at(2) and p.at(1) >= box.at(1) and p.at(1) <= box.at(3) { circle(q(p), radius: 0.3, fill: ink, stroke: none); T((p.at(0) + 0.9, p.at(1) - 0.9), text(weight: "bold")[#(i + 1)], size: 6pt) } }
    for (p, m) in marks.zip(("E2", "E3", "E4", "E5", "E6")) { line(q((p.at(0) - 0.3, p.at(1) - 0.3)), q((p.at(0) + 0.3, p.at(1) + 0.3)), stroke: 0.8pt + red); line(q((p.at(0) - 0.3, p.at(1) + 0.3)), q((p.at(0) + 0.3, p.at(1) - 0.3)), stroke: 0.8pt + red); T((p.at(0) + 1.1, p.at(1)), m, size: 5pt, fill: red) }
    for (p, n) in (("M1", M1), ("M2", Ms.at(1)), ("M3", Ms.at(2)), ("M4", Ms.at(3))) { T((n.at(0) - 1.0, n.at(1)), text(weight: "bold", p), size: 6pt, fill: accent, anchor: "east") }
    T((G.at(0) - 0.8, G.at(1) + 0.6), [G], size: 6pt, fill: red)
    T((D.at(0) - 1.0, D.at(1)), text(weight: "bold")[D], size: 6.5pt, fill: brown, anchor: "east")
    T((R.at(0) - 1.0, R.at(1) + 0.6), text(weight: "bold")[R], size: 6.5pt, fill: brown, anchor: "east")
    T((S.at(0) + 1.0, S.at(1)), text(weight: "bold")[S], size: 6.5pt, fill: brown, anchor: "west")
    T((T1.at(0) + 1.4, T1.at(1)), [palm 1], size: 5.5pt, fill: accent, anchor: "west"); T((T2.at(0) + 1.4, T2.at(1)), [palm 2], size: 5.5pt, fill: accent, anchor: "west")
    T((-2.0, 12.0), [DRIVEWAY 4.00 m], size: 5.5pt, fill: blue, angle: 90deg)
    T((-2.0, 0.6), [MAIN GATE 4 m], size: 5.5pt, fill: red, anchor: "west", angle: 0deg)
    if not preview { T((7.5, 17.0), [NEW HOUSE ±0.00\ (V8.3, moved south 4 Nov 2026)], size: 6pt, fill: violet) }
    T((-12.0, 17.0), [OLD HOUSE\ one-storey RC (deed sketch)\ ± 1–3 m, to be measured\ the old majlis INSIDE it (owner)], size: 5.5pt, fill: brown, angle: -85deg)
    T((-7.3, 22.5), [annex / dakka\ (deed sketch)], size: 5pt, fill: brown, angle: -85deg)
    for (l, b) in assumed { if b.at(3) <= box.at(3) and b.at(1) >= box.at(1) { T(((b.at(0) + b.at(2)) / 2, (b.at(1) + b.at(3)) / 2), [#l\ to be measured], size: if b.at(2) - b.at(0) < 4 { 3.4pt } else { 4.5pt }, fill: luma(90)) } }
    T((-7.75, 39.3), [tanks: owner 5 Nov 2026, south of the old house near R], size: 4pt, fill: luma(90))
    T((12.0, 36.8), [illustrative south line (open)], size: 5pt, fill: accent, angle: -10deg)
    T((10.0, 44.0), [no farm building south of the build land (owner, 5 Nov 2026) · where guests park: to be asked], size: 5pt, fill: luma(110))
    T((19.5, 3.0), [LANE (outside the wall)], size: 5.5pt, angle: -60deg)
    T((-10.0, -1.5), [NORTH STREET], size: 6pt)
    T((-22.0, 10.0), [neighbour (west)], size: 5pt, fill: luma(120), angle: -85deg)
  } else {
    for (i, p) in plot.enumerate() { circle(q(p), radius: 0.4, fill: ink, stroke: none); T((p.at(0) + 1.6, p.at(1) - 1.4), text(weight: "bold")[#(i + 1)], size: 5.5pt) }
    T((-3.0, -3.5), [MAIN GATE 4 m · M1 = the gate's east post], size: 5.5pt, fill: red, anchor: "west")
    T((sgate.at(0) + 2.0, sgate.at(1)), [service gate 4.56 m (east wall, position estimated)], size: 5.5pt, fill: red, anchor: "west", angle: -60deg)
    T((7.0, 17.0), [NEW HOUSE], size: 6pt, fill: violet)
    T((-12.5, 17.0), [OLD HOUSE\ (deed sketch, ± 1–3 m)], size: 5.5pt, fill: brown, angle: -85deg)
    T((-20.5, 96.0), [sheep barn (measured)], size: 5.5pt, fill: brown, angle: -85deg)
    T((-23.0, 116.5), [workers' house\ (size measured, position estimated)], size: 4.8pt, fill: brown, angle: -85deg)
    T((8.5, 121.5), [shade house (measured)], size: 6pt, fill: brown)
    T((well.at(0) + 3.5, well.at(1)), [well (v3; the red ring: from the deed sketch, #r2(d-well) m off)], size: 5pt, fill: blue, anchor: "west")
    T((-2.0, 20.0), [DRIVEWAY], size: 5pt, fill: blue, angle: 90deg)
    T((20.0, 29.0), [palms], size: 5pt, fill: accent, anchor: "west")
    T((D.at(0) - 1.2, D.at(1)), [D], size: 5.5pt, fill: brown, anchor: "east"); T((R.at(0) - 1.2, R.at(1) + 1.0), [R], size: 5.5pt, fill: brown, anchor: "east"); T((S.at(0) + 1.2, S.at(1)), [S], size: 5.5pt, fill: brown, anchor: "west")
    for (l, b) in assumed.filter(((l, b)) => b.at(2) - b.at(0) >= 4) { T(((b.at(0) + b.at(2)) / 2, (b.at(1) + b.at(3)) / 2), [#l\ (to be measured)], size: 4.2pt, fill: luma(90)) }
    T((-7.75, 39.5), [tanks (to be measured)], size: 4.2pt, fill: luma(90))
    T((40.0, 60.0), [FARM PLOT (deed) #r1(a-plot) m²], size: 7pt, fill: ink)
    T((-6.0, 80.0), [south gate: not in the inputs (to be measured)], size: 5pt, fill: luma(90), angle: -85deg)
    T((10.0, -4.5), [NORTH STREET], size: 6pt); T((40.0, 20.0), [LANE], size: 6pt, angle: -55deg); T((-30.0, 70.0), [MAIN ROAD (west)], size: 6pt, angle: -85deg)
  }
  // north arrow and scale bar
  let (ax, ay) = (box.at(2) - 6, box.at(1) + 6)
  line(q((ax, ay)), (ax + 6 * north.at(0), -ay + 6 * north.at(1)), stroke: 1pt + ink, mark: (end: "stealth", fill: ink, scale: 0.7))
  T((ax + 7.5 * north.at(0), ay - 7.5 * north.at(1)), text(weight: "bold")[N], size: 8pt)
  let sb = if zone { 10 } else { 20 }
  line(q((box.at(2) - 6 - sb, box.at(3) - 3)), q((box.at(2) - 6, box.at(3) - 3)), stroke: 1.5pt + ink)
  T((box.at(2) - 6 - sb / 2, box.at(3) - 1.6), [#sb m], size: 6pt)
})

// the view: the canvas clipped to `box` (the world extent is -60 … 80 × -20 … 140 m)
#let view(length: 2.2mm, box: (-28, -6, 62, 134), zone: false, preview: false) = std.box(width: (box.at(2) - box.at(0)) * length, height: (box.at(3) - box.at(1)) * length, clip: true,
  move(dx: -(box.at(0) + 60) * length, dy: -(box.at(1) + 20) * length, farm(length: length, box: box, zone: zone, preview: preview)))

// ====================================================================================== PAGE 1 · the whole farm
#set page(paper: "a3", flipped: false, margin: 9mm, fill: rgb("#fbfaf6"))
#text(13pt, weight: "bold", fill: accent)[The whole farm · site baseline v2 (03 Oct 2026) with the old buildings · Taif / Palm House · STUDY] \
#text(7pt, fill: gray)[Design frame: origin M1 (the gate's east post), y along the M line southwards, x east. The deed (licence 798, 15/11/1440 H) gives the 20 corners; the field check of 03 Oct 2026 (44 tapes, rms 0.27 m) the gate, the M line, D, R, S, the palms, the lane wall; the v3 survey the well, the sheep barn, the shade house (measured), the workers' house and the service gate (estimated); the scanned deed sketch the old house and its annex (digitised, ± 1–3 m). Dotted boxes: no data, to be measured. Scale 1:450 on A3.]
#v(2pt)
#grid(columns: (auto, 1fr), column-gutter: 8pt,
  view(),
  [
    #text(9pt, weight: "bold", fill: accent)[Legend] \
    #text(7pt)[
      #box(width: 9pt, height: 6pt, fill: rgb("#f4f1e6"), stroke: 1pt + ink) the farm plot (deed, 20 corners) \
      #box(width: 9pt, height: 6pt, fill: rgb("#f4c6c6")) the setbacks (3 m north street, 2 m lane) inside the build land \
      #box(width: 9pt, height: 6pt, fill: rgb("#e3f0dd"), stroke: 0.7pt + accent) the buildable envelope (to the illustrative south line) \
      #box(width: 9pt, height: 6pt, fill: rgb("#d6e2ee"), stroke: 0.5pt + blue) the driveway 4.00 m on the M line (decided) \
      #box(width: 9pt, height: 6pt, fill: rgb("#ddd3ea"), stroke: 1pt + violet) the new house (V8.3, shift #r2(shift.at(0)) / #r2(shift.at(1))) \
      #box(width: 9pt, height: 6pt, fill: rgb("#e6dccb"), stroke: 0.8pt + brown) old buildings measured (v3) \
      #box(width: 9pt, height: 6pt, fill: rgb("#f3dcc0"), stroke: (paint: brown, dash: "dashed")) the old house and its annex from the deed sketch (± 1–3 m) \
      #box(width: 9pt, height: 6pt, stroke: (paint: luma(110), dash: "dotted")) no data: to be measured \
      #text(fill: red)[▬] gates (the north 4 m main gate; the east service gate 4.56 m)
    ]
    #v(4pt)
    #text(9pt, weight: "bold", fill: accent)[Numbers] \
    #text(7pt)[
      - Plot: #r1(a-plot) m² from the 20 corners (deed 7 737.85). Build land to the illustrative south line #r1(area(land)) m²; envelope #r1(area(env)) m².
      - The old house (deed sketch): a one-storey reinforced-concrete building ≈ #r1(dist(old-house.at(0), old-house.at(1))) × #r1(dist(old-house.at(0), old-house.at(3))) m (its envelope; the sketch shows an L) along the west boundary, #r1(d-old-west) m from the new house's west wall, #r1(d-old-M) m from the M line, #r1(d-old-house-house) m from the nearest wall of the new house. Its annex ≈ #r1(dist(annex.at(0), annex.at(1))) × #r1(dist(annex.at(1), annex.at(2))) m touches the driveway's west edge (#r2(d-old-drv) m; the field check puts the dakka 1.5 m clear: the sketch is ± 1–3 m); its south corner #r2(d-annex-D) m from D.
      - The old majlis is PART OF the old house (owner, 5 Nov 2026): the guests' route to it is the driveway from the gate to the old house, #r2(drv-w) m wide, #r1(route-width) m from the annex to the new house's west wall; the new house's paths are not touched.
      - The covered parking (2 cars) and the existing ground tank are SOUTH of the old house, west of the driveway, near peg R (owner, 5 Nov 2026; the tank #r1(d-tank-R) m from R, the reserved tank west of it, #r1(tank-old.at(1) - carport.at(3)) m between the parking and the tanks, the tanks #r1(d-tank-house) m from the new house); the septic outside the north wall near C1 serves the old house. Nothing of the farm lies south of the build land: the brief's south boxes are withdrawn.
      - The palms #r1(palms-house.dist-poly.at(0)) / #r1(palms-house.dist-poly.at(1)) m from the new house; the well #r1(d-well-house) m (ring edge); the service gate #r1(d-sgate-house) m.
    ]
    #v(4pt)
    #text(9pt, weight: "bold", fill: accent)[To be measured on site] \
    #text(7pt)[the old house's and the annex's corners (W1–W4, A1–A4), the covered parking's corners (P1–P4) and the tank's lid / fill point (K0, K1): the field sheet in `docs/SITE_SETOUT.md` § 8; the reserved tank's place; the septic (position, lids, inlet level, capacity for both houses, the old house's connection); where guests park; the south gate; the workers' house position; the service gate position. Peg S lies #r1(dist(S, T2) - 0.265) m from palm 2's trunk: check it on site.]
  ],
)

// ====================================================================================== PAGE 2 · the north zone
#pagebreak()
#set page(paper: "a3", flipped: true, margin: 9mm, fill: rgb("#fbfaf6"))
#text(13pt, weight: "bold", fill: accent)[The north zone enlarged · the new house at the current position (shift #r2(shift.at(0)), #r2(shift.at(1))) and the old house] #h(1fr) #text(7pt, fill: gray)[1:220 on A3 · y −6 … 52 m]
#v(2pt)
#grid(columns: (auto, 1fr), column-gutter: 8pt,
  view(length: 4.4mm, box: (-27, -6, 30, 52), zone: true),
  [
    #text(9pt, weight: "bold", fill: accent)[What the sketch says] \
    #text(7pt)[
      The scanned deed carries a plan sketch of the plot with two hatched buildings near corner 1 on the west boundary: the larger one labelled *بناء دور مسلح* (a one-storey reinforced-concrete building: the old house) and a thin-line *ملحق* (annex) on its north-east side towards the driveway, plus the stores (*مستودعات*: the shade house, measured in v3) in the south. The sketch was georeferenced on seven deed corners (1, 2, 3, 12, 13, 14, 15; rms #r2(1.36) m) and checked on the well (#r2(d-well) m from the v3 well) and on the dakka corner D (the annex's south corner #r2(d-annex-D) m from it): the sketch sits within about 1 m of the field. The buildings' corners are read from a 300 dpi scan at ≈ 7.3 px per metre: ± 1–3 m.
    ]
    #v(3pt)
    #text(9pt, weight: "bold", fill: accent)[Position of the old house in the design frame] \
    #text(7pt, table(columns: (auto, auto, auto), stroke: 0.4pt + luma(150), inset: 3pt,
      table.header([*Corner*], [*x east*], [*y along M*]),
      ..old-house.enumerate().map(((i, p)) => ([W#(i + 1)], [#r2(p.at(0))], [#r2(p.at(1))])).flatten(),
      ..annex.enumerate().map(((i, p)) => ([A#(i + 1)], [#r2(p.at(0))], [#r2(p.at(1))])).flatten(),
    ))
    #v(3pt)
    #text(9pt, weight: "bold", fill: accent)[Does anything conflict?] \
    #text(7pt)[
      - *The new house, the driveway and the paths:* no. The old house is #r1(d-old-west) m west of the new house's west wall and #r1(d-old-M) m west of the M line; the driveway (x −3.95 … 0) runs between them and keeps its 3.95 m; the guest path on the driveway's east edge and the fire vehicle's stand are unaffected. The annex's east edge sits on the driveway's west edge (#r2(d-old-drv) m): within the sketch's tolerance; the field check gives the dakka 1.5 m clear.
      - *The service yard, the garden, the outdoor kitchen:* all on the east and south; nothing of the old house reaches them.
      - *The owner's answers (5 Nov 2026):* the old house is WEST of the driveway as on the deed sketch (confirmed; its corners still to be measured); the old majlis is PART OF it (no separate building); the covered parking for two cars and the existing ground tank are SOUTH of the old house, west of the driveway near peg R (the tank is NOT in the new house's garden; the reserved tank goes next to it, west); the septic outside the north wall near C1 serves the old house and takes the new house's drains (site plan page 4: the route, #r1(37.9) m from the yard's chamber, the falls, a chamber at every bend, the driveway crossed once; its capacity for both houses, its inlet level and a pump are flagged for the engineer and the survey). Nothing of the farm lies south of the build land: the brief's south boxes (old house, parking, tank, farm parking) are withdrawn. *Where guests park is to be asked.*
      - *The carport and the tanks against each other and the new house:* #r1(tank-old.at(1) - carport.at(3)) m between the carport and the tanks (no clash); the car route gate → driveway → a right turn into the carport (open to the east) is the owner's existing one; the water truck stands on the driveway beside the tanks; the tanks #r1(d-tank-house) m from the new house; the supply pipe crosses the driveway once (y 36.5) to the guest path band and the utility room.
      - *Corner C1:* the deed puts the plot's north-west corner at x #r2(plot.at(0).at(0)), 10 m further west than the site plan's old C1 (−6.5); the septic "near C1" stays approximate: to be measured (its lids, its inlet level).
    ]
    #v(3pt)
    #text(7pt, fill: gray)[Whole-farm study #if all-ok [checks passed] else [CHECKS FAILED] (#checks.len()): #checks.map(c => c.at(0)).join([ · ]).]
  ],
)

// ====================================================================================== PAGE 3 · PREVIEW: 1.3 m south + one step (17 Nov 2026)
#pagebreak()
#text(13pt, weight: "bold", fill: accent)[Preview: 1.3 m south + one step (17 Nov 2026) · the whole farm with the house moved #r2(pv-s) m straight south along the M line and the NE corner as ONE step] #h(1fr) #text(7pt, fill: gray)[1:220 on A3 · y −6 … 52 m · preview only: nothing in the design files moved · `studies/step_corner.typ` option 6 (d097e62)]
#v(2pt)
#grid(columns: (auto, 1fr), column-gutter: 8pt,
  view(length: 4.4mm, box: (-27, -6, 30, 52), zone: true, preview: true),
  [
    #text(9pt, weight: "bold", fill: accent)[What moved] \
    #text(7pt)[The whole house (its outer faces) #r2(pv-s) m south: every corner the same x, y + #r2(pv-s). The slanted cut wall (10.461, 0) → (13.311, 5.245) replaced by one orthogonal step: the north wall ends at x #r2(pv-step.at(0)), the east wall starts at y #r2(pv-step.at(1)) (CSV frame); the corner given up 2.04 × 3.2 = 6.52 m² per floor against the slant's 7.47. Today's outline dashed underneath; the dotted outline is the future lengthening of 0.95 m (the twin bedrooms' 4.0 m main rooms, `studies/west_wing_ff.typ`). Outline only, no room detail.]
    #v(3pt)
    #text(9pt, weight: "bold", fill: accent)[Dimensions (m)] \
    #text(7pt, table(columns: (1.6fr, auto, auto, auto), stroke: 0.4pt + luma(150), inset: 2.8pt, align: (left, right, right, right), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      table.header([*From … to*], [*today*], [*preview*], [*after +0.95*]),
      [B1 (the north-west corner) from M1 (the gate's east post)], [#r2(td-b1)], [*#r2(pv-b1)*], [#r2(pv-b1)],
      [The north strip for the car: the north wall face to the plot's north line, at B1], [#r2(td-strip)], [*#r2(pv-strip)*], [#r2(pv-strip)],
      [The north strip at x 6 (the middle of the north wall)], [#r2(strip-at(6.0, house))], [#r2(pv-strip-mid)], [#r2(pv-strip-mid)],
      [Tightest margin to the deed setback line (at the step's north corner)], [#r2(td-deed)], [*#r2(pv-deed)*], [#r2(pv-deed)],
      [Tightest margin to 2.0 m from the wall as built (the lane line #r2(pv-lane) − 0.62 − 2.0)], [#r2(td-built)], [*#r2(pv-built)*], [#r2(pv-built)],
      [Palm T1 (trunk face) to the east wall], [#r2(td-palm.at(0))], [*#r2(pv-palm.at(0).at(1))*], [#r2(long-palm.at(0))],
      [Palm T2 (trunk face) to the nearest wall (the south-east corner)], [#r2(td-palm.at(1))], [*#r2(pv-palm.at(1).at(1))*], [#r2(long-palm.at(1))],
      [The south wall's SE corner to the illustrative south line (the plot's south edge of the build land)], [#r2(td-south.at(0))], [*#r2(pv-south.at(1))*], [#r2(long-south.at(0))],
      [The south wall's SW corner to the illustrative south line], [#r2(td-south.at(1))], [*#r2(pv-south.at(3))*], [#r2(long-south.at(1))],
      [Peg S (east of the south wall, in the build land) to the house], [#r2(td-S)], [#r2(pv-S.at(1))], [—],
      [Peg R (on the driveway) to the house], [#r2(td-R)], [#r2(pv-R.at(1))], [—],
      [The dakka corner D (the annex's south corner) to the west wall], [#r2(td-D)], [#r2(pv-D.at(1))], [—],
      [The old house (deed sketch, ± 1–3 m) to the house · its annex], [#r1(td-old) · #r1(td-annex)], [#r1(pv-old) · #r1(pv-annex)], [—],
      [The covered parking (owner, to be measured) to the SW corner], [#r2(td-carport)], [#r2(pv-carport)], [—],
      [The existing tank (to be measured) to the SW corner], [#r2(td-tank)], [#r2(pv-tank)], [—],
      [The driveway's east edge (the M line) to the west wall face], [#r2(house.at(0).at(0))], [#r2(B1.at(0))], [—],
    ))
    #v(3pt)
    #text(9pt, weight: "bold", fill: accent)[Reading it] \
    #text(7pt)[
      - *The gate and the north strip:* the house moves #r2(pv-s) m away from the gate (B1 #r2(pv-b1) m from M1); the car's strip deepens by the same #r2(pv-s) m (#r2(pv-strip) m at B1, #r2(pv-strip-mid) m at the middle). Nothing north of the house comes closer.
      - *The setback:* both readings improve (deed #r2(pv-deed) m, wall as built #r2(pv-built) m beyond the 2.0 m; today #r2(td-deed) / #r2(td-built)); the house stays inside the buildable envelope: #if pv-in-env [yes] else [NO].
      - *South of the house:* the illustrative south line is #r2(pv-south.at(1)) m from the SE corner and #r2(pv-south.at(3)) m from the SW corner (the line runs south-west); after the 0.95 m lengthening #r2(long-south.at(0)) / #r2(long-south.at(1)) m remain. Palm T2's trunk is #r2(pv-palm.at(1).at(1)) m from the SE corner (#r2(long-palm.at(1)) m after the lengthening: the palm then stands beside the east wall, not past the south wall); T1 keeps #r2(pv-palm.at(0).at(1)) m to the east wall. Peg S is #r2(pv-S.at(1)) m from the SE corner, peg R #r2(pv-R.at(1)) m from the SW corner: both are pegs, not features.
      - *The old house, the driveway, the carport, the tanks:* the west wall stays #r2(B1.at(0)) m east of the M line (the driveway untouched); the old house and its annex are #r1(pv-old) / #r1(pv-annex) m away (today #r1(td-old) / #r1(td-annex)), the dakka corner D #r2(pv-D.at(1)) m (unchanged); the carport is level with the SW corner (#r2(pv-carport) m, unchanged); the existing tank comes #r2(td-tank - pv-tank) m closer (#r2(pv-tank) m). Nothing else of the farm lies south of the build land (owner, 5 Nov 2026); the south line, the carport, the tanks and the old house are still to be measured.
    ]
  ],
)

// whole_farm.typ · Taif / Palm House · THE WHOLE FARM on the site baseline v2 (field check 03 Oct 2026) with the old buildings · 5 Nov 2026 · STUDY
// Sources: data/site_v2.csv (tools/site_frame.py from site/inputs/taif_north_zone_final_v2.csv, UTM deed coordinates → the design frame) and
// data/deed_sketch.csv (the old house and its annex digitised from the scanned deed site/inputs/Scanned_20190818-1737.pdf, georeferenced on 7 deed corners).
// Design frame: origin M1 = the gate's east post G′ · y along the M line southwards · x east, square to it. The new house = the room CSVs + shift (design_gf.typ).
// EVERY OLD BUILDING IS APPROXIMATE (the deed sketch ± 1–3 m; the v3 survey where it says MEASURED); the official survey has the last word.
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
#let house = ((-0.125, -0.125), (10.125, -0.125), (13.436, 5.968), (13.436, 24.125), (-0.125, 24.125)).map(P)
#let court = ((4.35, 6.6), (8.85, 6.6), (8.85, 12.9), (4.35, 12.9)).map(P)
#let scourt = ((4.25, 20.55), (5.8, 20.55), (5.8, 19.25), (10.0, 19.25), (10.0, 24.0), (4.25, 24.0)).map(P)
#let west-wall = (house.at(0), house.at(4))
// without data: drawn dashed, "to be measured" (the approximate positions of studies/site_plan.typ, V8.2–V8.3, where they exist)
#let assumed = (
  ([old majlis], (20.0, 45.5, 26.0, 49.0)),
  ([covered parking (2 cars)], (12.5, 42.0, 18.0, 47.0)),
  ([farm parking (guests)], (-8.0, 41.0, 2.0, 49.0)),
  ([existing water tank], (0.8, 47.8, 3.8, 50.3)),
  ([reserved tank], (4.3, 47.8, 7.8, 50.3)),
  ([existing septic (outside the wall)], (-10.5, -1.9, -6.5, 0.5)),
)

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
)
#let all-ok = checks.all(c => c.at(1))

// ---------- drawing ----------
#let ink = rgb("#3d4a45"); #let accent = rgb("#5a7d2a"); #let red = rgb("#b5452f"); #let blue = rgb("#2f5f8a"); #let brown = rgb("#8a5a2b"); #let amber = rgb("#b58a1f"); #let violet = rgb("#6a3d9a")
#let q(p) = (p.at(0), -p.at(1))
#let north = (0.364, 0.931)
#let farm(length: 2.2mm, box: (-28, -6, 62, 134), zone: false) = cetz.canvas(length: length, {
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
  // the new house
  poly(house, fill: rgb("#ddd3ea"), stroke: 1pt + violet)
  poly(court, fill: white, stroke: 0.5pt + violet)
  poly(scourt, fill: white, stroke: 0.5pt + violet)
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
    T((7.5, 17.0), [NEW HOUSE ±0.00\ (V8.3, moved south 4 Nov 2026)], size: 6pt, fill: violet)
    T((-12.0, 17.0), [OLD HOUSE\ one-storey RC (deed sketch)\ ± 1–3 m, to be measured], size: 5.5pt, fill: brown, angle: -85deg)
    T((-7.3, 22.5), [annex / dakka\ (deed sketch)], size: 5pt, fill: brown, angle: -85deg)
    for (l, b) in assumed { if b.at(3) <= box.at(3) and b.at(1) >= box.at(1) { T(((b.at(0) + b.at(2)) / 2, (b.at(1) + b.at(3)) / 2), [#l\ to be measured], size: 4.5pt, fill: luma(90)) } }
    T((12.0, 36.8), [illustrative south line (open)], size: 5pt, fill: accent, angle: -10deg)
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
    for (l, b) in assumed { T(((b.at(0) + b.at(2)) / 2, (b.at(1) + b.at(3)) / 2), [#l\ (to be measured)], size: 4.2pt, fill: luma(90)) }
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
#let view(length: 2.2mm, box: (-28, -6, 62, 134), zone: false) = std.box(width: (box.at(2) - box.at(0)) * length, height: (box.at(3) - box.at(1)) * length, clip: true,
  move(dx: -(box.at(0) + 60) * length, dy: -(box.at(1) + 20) * length, farm(length: length, box: box, zone: zone)))

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
      - The route to the old majlis (assumed position) passes between the old buildings and the new house: the narrowest clear width is the driveway's #r2(3.95) m plus the west strip, #r1(route-width) m from the annex to the new house's west wall.
      - The palms #r1(palms-house.dist-poly.at(0)) / #r1(palms-house.dist-poly.at(1)) m from the new house; the well #r1(d-well-house) m (ring edge); the service gate #r1(d-sgate-house) m.
    ]
    #v(4pt)
    #text(9pt, weight: "bold", fill: accent)[To be measured on site] \
    #text(7pt)[the old house's and the annex's corners (W1–W4, A1–A4: the field sheet in `docs/SITE_SETOUT.md` § 8); the old majlis; the covered parking; the farm parking; the existing water tank and the reserved tank's place; the septic (position, inlet, capacity); the south gate; the workers' house position; the service gate position. Peg S lies #r1(dist(S, T2) - 0.265) m from palm 2's trunk: check it on site.]
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
      - *The site plan's "farm beyond the plot" (V8.2):* it placed the old house SOUTH of the build land (y 42–49) with the covered parking, the farm parking and the tank beside it. The deed sketch puts the old house WEST of the driveway (y 5.6–28.5). Either the sketch's building is the "old house" of the brief, or there is a second building in the south: *the owner must say which*; until then the south items stay dotted ("to be measured") and the old-house box of the site plan follows the deed sketch.
      - *Peg R (v2: least-squares fitted at x #r2(R.at(0)), y #r2(R.at(1))):* the site plan assumed R at y 48.5 and drew the existing tank "just east of peg R". East of the fitted R is the south garden (y 34–36), 5 m from the new house's south-west corner: the tank's real position must be measured before the garden and the soakaways are fixed.
      - *Corner C1:* the deed puts the plot's north-west corner at x #r2(plot.at(0).at(0)), 10 m further west than the site plan's C1 (−6.5); the septic "near C1" is therefore approximate: to be measured.
    ]
    #v(3pt)
    #text(7pt, fill: gray)[Whole-farm study #if all-ok [checks passed] else [CHECKS FAILED] (#checks.len()): #checks.map(c => c.at(0)).join([ · ]).]
  ],
)

// step_corner.typ · Taif / Palm House · STUDY (owner, 17 Nov 2026): ONE orthogonal STEP instead of the slanted north-east cut wall, with the WHOLE HOUSE moved SOUTH along the M line.
// Round 1 (fe5612d): the step at today's position (B1 6.00 m from M1) costs the kitchen 7.2 m², bedroom 1 5.2 m² and the suite's WC closet. Round 2 (this file): the house 0.5 m south
// (B1 ≈ 6.50 m), then the smallest shift that lets the step take nothing from the kitchen, bedroom 1 (≈ 15.7 m² clear, its bath F20 in place) or the suite's WC closet: 0.75 and 1.0 m tested.
// Today the cut runs on axes from (10.461, 0) to (13.311, 5.245). The step: the north wall ends at x = XS, the east wall starts at y = YS; the rectangle x XS–13.311 × y 0–YS is given up.
// The limits (SITE_SETOUT.md § 5, both readings, every outer face sampled at 5 cm): (A) the deed setback line (base.typ `env`): today 0.91 m at the lane notch; (B) 2.0 m from the lane wall
// AS BUILT: the model's lane line (base.typ `lane`) less the 0.62 m the sheet uses for the wall as built (3.09 model / 2.47 as built), less 2.0: today 0.42 m. Both must stay ≥ today's.
// The north corner is limited by reading B, the east corner by the notch; moving the house south relaxes both ≈ 0.26 m per 0.5 m. Nothing in the design files is changed.
// CSV frame: x east, y south, wall centre lines; the outer walls 0.25, the inner walls 0.20, the 100 mm partitions of the maid bath 0.10.
#import "@preview/cetz:0.4.2"
#import "../base.typ": env, lane, T1, T2

#set page(paper: "a4", flipped: true, margin: 7mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 7.2pt)
#set par(leading: 0.42em)
#let ink = rgb("#3d4a45"); #let accent = rgb("#2f6b4f"); #let red = rgb("#b5452f"); #let blue = rgb("#2f5f8a"); #let gray = rgb("#6d736f"); #let brown = rgb("#8a5a2b"); #let amber = rgb("#c98a12")
#let r2(v) = { let s = str(calc.round(v, digits: 2)); if not s.contains(".") { s + ".00" } else if s.split(".").at(1).len() == 1 { s + "0" } else { s } }
#let ah(t) = text(font: ("Segoe UI", "Arial", "Tahoma"), lang: "ar", dir: rtl, t)
#let rect-pts(x0, y0, x1, y1) = ((x0, y0), (x1, y0), (x1, y1), (x0, y1))
#let XE = 13.311; #let XW = 8.95

// ---------- the site readings ----------
#let shift0 = (0.91, 6.0734)                                     // design frame → site frame today (design_gf.typ, 8 Nov 2026: B1 6.00 m from M1)
#let built-offset = 0.62; #let setback-built = 2.0
#let dist(a, b) = calc.sqrt(calc.pow(a.at(0) - b.at(0), 2) + calc.pow(a.at(1) - b.at(1), 2))
#let pseg(p, a, b) = { let dx = b.at(0) - a.at(0); let dy = b.at(1) - a.at(1); let l2 = dx * dx + dy * dy
  let t = if l2 == 0 { 0 } else { calc.max(0, calc.min(1, ((p.at(0) - a.at(0)) * dx + (p.at(1) - a.at(1)) * dy) / l2)) }; dist(p, (a.at(0) + t * dx, a.at(1) + t * dy)) }
#let deed-dist(p) = calc.min(..range(env.len()).filter(i => { let a = env.at(i); let b = env.at(calc.rem(i + 1, env.len())); not (calc.abs(a.at(0)) < 0.01 and calc.abs(b.at(0)) < 0.01) }).map(i => pseg(p, env.at(i), env.at(calc.rem(i + 1, env.len())))))
#let lane-dist(p) = calc.min(..range(lane.len() - 1).map(i => pseg(p, lane.at(i), lane.at(i + 1))))
#let face-pts(P) = { let out = (); let n = P.len()
  for i in range(n) { let a = P.at(i); let b = P.at(calc.rem(i + 1, n)); let k = calc.max(1, int(calc.ceil(dist(a, b) / 0.05)))
    for j in range(k) { let t = j / k; out.push((a.at(0) + t * (b.at(0) - a.at(0)), a.at(1) + t * (b.at(1) - a.at(1)))) } }
  out }
#let faces-of(XS, YS) = if XS == none { ((-0.125, -0.125), (10.535, -0.125), (13.436, 5.214), (13.436, 24.125), (-0.125, 24.125)) } else { ((-0.125, -0.125), (XS + 0.125, -0.125), (XS + 0.125, YS - 0.125), (XE + 0.125, YS - 0.125), (XE + 0.125, 24.125), (-0.125, 24.125)) }
#let site(XS, YS, s) = {   // the readings of a house with the step (XS, YS) (none = today's slant) moved s metres south
  let sh = (shift0.at(0), shift0.at(1) + s); let S(p) = (p.at(0) + sh.at(0), p.at(1) + sh.at(1)); let P = faces-of(XS, YS); let pts = face-pts(P)
  let a = pts.sorted(key: p => deed-dist(S(p))).first(); let b = pts.sorted(key: p => lane-dist(S(p))).first()
  let palm(T) = calc.min(..range(P.len()).map(i => pseg(T, S(P.at(i)), S(P.at(calc.rem(i + 1, P.len())))))) - 0.265
  let b1 = S(P.first())
  (deed: deed-dist(S(a)), deed-at: a, built: lane-dist(S(b)) - built-offset - setback-built, built-at: b, b1: dist(b1, (0, 0)), palm1: palm(T1), palm2: palm(T2),
   strip: (b1.at(1) + b1.at(0) * 1.59 / 8.64))   // the north strip's depth at B1: from the wall face to the plot's north line ((0, 0) → (8.64, −1.59))
}
#let today = site(none, none, 0)
#let lost-today = 2.85 * 5.245 / 2

// ---------- the scenarios ----------
// walls: outer 0.125 where the edge lies on the building's outline; `light` (100 mm partitions) 0.05; else 0.10
#let on-outline(a, b, XS, YS) = {
  let v(x) = calc.abs(a.at(0) - x) < 1e-6 and calc.abs(b.at(0) - x) < 1e-6; let h(y) = calc.abs(a.at(1) - y) < 1e-6 and calc.abs(b.at(1) - y) < 1e-6
  (h(0) and calc.max(a.at(0), b.at(0)) <= XS + 1e-6) or (v(XS) and calc.max(a.at(1), b.at(1)) <= YS + 1e-6) or (h(YS) and calc.min(a.at(0), b.at(0)) >= XS - 1e-6) or v(XE)
}
#let on-seg(p, a, b) = calc.abs(dist(a, p) + dist(p, b) - dist(a, b)) < 1e-6
#let is-cw(P) = range(P.len()).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, P.len())); a.at(0) * b.at(1) - b.at(0) * a.at(1) }).sum() > 0
#let area(P) = calc.abs(range(P.len()).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, P.len())); a.at(0) * b.at(1) - b.at(0) * a.at(1) }).sum()) / 2
#let inset(P, d) = {
  let n = P.len()
  let lines = range(n).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, n)); let (dx, dy) = (b.at(0) - a.at(0), b.at(1) - a.at(1)); let L = calc.sqrt(dx * dx + dy * dy); ((a.at(0) - dy / L * d.at(i), a.at(1) + dx / L * d.at(i)), (dx, dy)) })
  range(n).map(i => { let (p1, v1) = lines.at(calc.rem(i + n - 1, n)); let (p2, v2) = lines.at(i); let den = v1.at(0) * v2.at(1) - v1.at(1) * v2.at(0); let t = ((p2.at(0) - p1.at(0)) * v2.at(1) - (p2.at(1) - p1.at(1)) * v2.at(0)) / den; (p1.at(0) + v1.at(0) * t, p1.at(1) + v1.at(1) * t) })
}
#let clear-poly(P, XS, YS, light) = { let Q = if is-cw(P) { P } else { P.rev() }
  inset(Q, range(Q.len()).map(i => { let a = Q.at(i); let b = Q.at(calc.rem(i + 1, Q.len()))
    if light.any(((c, d)) => on-seg(a, c, d) and on-seg(b, c, d)) { 0.05 } else if on-outline(a, b, XS, YS) { 0.125 } else { 0.10 } })) }
#let bbox(P) = (calc.min(..P.map(p => p.at(0))), calc.min(..P.map(p => p.at(1))), calc.max(..P.map(p => p.at(0))), calc.max(..P.map(p => p.at(1))))
#let inside(p, P) = { let c = false; let n = P.len(); for i in range(n) { let (xi, yi) = P.at(i); let (xj, yj) = P.at(calc.rem(i + n - 1, n)); if ((yi > p.at(1)) != (yj > p.at(1))) and (p.at(0) < (xj - xi) * (p.at(1) - yi) / (yj - yi) + xi) { c = not c } }; c }
#let bed1-poly(XS, YS) = ((XW, 0), (XS, 0), (XS, YS), (XE, YS), (XE, 5.6), (11.5, 5.6), (11.5, 6.5), (10.15, 6.5), (10.15, 5.3), (XW, 5.3))
#let ff-fixed(XS, YS) = (
  ("Bedroom 1", bed1-poly(XS, YS), "bed"), ("Bedroom 1 bath F20", rect-pts(11.5, 5.6, XE, 8.0), "wet"), ("Family link", rect-pts(XW, 5.3, 10.15, 6.5), "circ"),
  ("Suite WC (closet)", rect-pts(10.3, 6.5, 11.5, 8.0), "wet"), ("Suite bath", rect-pts(10.3, 8.0, XE, 10.45), "suiteg"), ("Suite lobby", rect-pts(XW, 6.5, 10.3, 11.9), "circg"),
)
#let ff-furn-common = (   // (x0, y0, x1, y1, label, room): as today (studies/ff_family.typ, ff_suite.typ)
  (9.05, 0.35, 10.45, 2.35, [bed 1.4 × 2.0], "Bedroom 1"), (11.6, 4.9, 12.95, 5.5, [built-in wardrobe W1], "Bedroom 1"), (9.05, 2.6, 9.65, 5.2, [built-in wardrobe W2 2.4 × 0.6], "Bedroom 1"),
  (11.6, 6.5, 12.05, 7.1, [basin], "Bedroom 1 bath F20"), (12.6, 6.0, 13.186, 6.4, [WC], "Bedroom 1 bath F20"), (11.6, 7.1, 13.186, 7.9, [shower 1.6 × 0.8 · floor drain], "Bedroom 1 bath F20"),
  (10.7, 6.6, 11.1, 7.15, [WC · wall-hung], "Suite WC (closet)"),
  (11.9, 8.1, 13.186, 9.0, [shower], "Suite bath"), (12.586, 9.1, 13.186, 10.05, [2 basins], "Suite bath"), (10.4, 9.6, 12.1, 10.35, [tub], "Suite bath"),
)
#let ff-doors = (((10.15, 5.4), (10.15, 6.4), (1, 0)), ((11.5, 5.7), (11.5, 6.4), (1, 0)), ((10.5, 8.0), (11.2, 8.0), (0, 1)), ((9.0, 6.5), (10.1, 6.5), (0, 1)), ((10.3, 8.8), (10.3, 9.6), (1, 0)))
#let scen-A = (   // 0.5 m south: XS ≤ 10.85 (reading B at the north corner), YS ≥ 3.7 (the notch)
  name: [the house 0.5 m south · the step (10.85, 3.70)], s: 0.5, XS: 10.85, YS: 3.7, col: "A",
  gf: (("Maid room", rect-pts(XW, 0, 10.85, 4.7), "maid"), ("Maid bath", rect-pts(10.85, 3.7, XE, 5.2), "wet"), ("Laundry", rect-pts(XW, 5.2, XE, 6.5), "laundry"), ("Kitchen", rect-pts(XW, 6.5, XE, 13.0), "kitchen")),
  gf-light: (((10.85, 3.7), (10.85, 5.2)),),
  gf-furn: ((9.05, 0.125, 9.95, 2.125, [bed 0.9 × 2.0], "Maid room"), (9.05, 2.3, 9.65, 3.65, [wardrobe], "Maid room"), (10.125, 1.0, 10.725, 2.0, [desk], "Maid room"),
    (12.3, 3.825, 13.186, 4.7, [shower · floor drain], "Maid bath"), (11.65, 3.825, 12.05, 4.425, [WC], "Maid bath"), (11.6, 4.7, 12.0, 5.1, [basin], "Maid bath"),
    (9.05, 5.3, 9.65, 6.4, [table], "Laundry"), (9.9, 5.8, 10.5, 6.4, [washer 1], "Laundry"), (10.55, 5.8, 11.15, 6.4, [washer 2 + dryer], "Laundry"), (11.2, 5.8, 11.8, 6.4, [cupboards], "Laundry"), (11.85, 5.8, 12.4, 6.4, [steam], "Laundry")),
  gf-doors: (((9.3, 4.7), (10.2, 4.7), (0, -1)), ((10.85, 3.8), (10.85, 4.5), (1, 0)), ((12.45, 6.5), (13.186, 6.5), (0, 0))),
  gf-windows: (((10.85, 1.2), (10.85, 2.3)), ((12.0, 3.7), (12.5, 3.7)), ((XE, 5.4), (XE, 6.2))),
  ff-furn: ((11.0, 3.9, 12.1, 4.5, [desk], "Bedroom 1"), (11.0, 4.6, 11.45, 5.0, [], "Bedroom 1")),
  ff-windows: (((10.85, 1.4), (10.85, 2.4)), ((9.2, 0), (10.2, 0)), ((XE, 6.5), (XE, 6.95))),
  cols: (((10.85, 0), "C30′"), ((10.85, 3.7), "C31′"), ((XE, 3.7), "C32′"), ((XE, 6.5), "C33′ new")),
  verdict: [FAILS the goal: the maid bath needs the laundry's depth (the laundry 1.10 m clear, its passage 0.50 m), and bedroom 1 loses 1.9 m² clear.],
)
#let scen-B = (   // 1.0 m south: XS ≤ 11.1, YS ≥ 3.2 (the maid bath's partition line)
  name: [the house 1.0 m south · the step (11.10, 3.20)], s: 1.0, XS: 11.1, YS: 3.2, col: "B",
  gf: (("Maid room", rect-pts(XW, 0, 11.1, 4.7), "maid"), ("Maid bath", rect-pts(11.1, 3.2, XE, 4.7), "wet"), ("Laundry", rect-pts(XW, 4.7, XE, 6.5), "laundry"), ("Kitchen", rect-pts(XW, 6.5, XE, 13.0), "kitchen")),
  gf-light: (((11.1, 3.2), (11.1, 4.7)),),
  gf-furn: ((9.05, 0.125, 9.95, 2.125, [bed 0.9 × 2.0], "Maid room"), (9.05, 2.3, 9.65, 3.65, [wardrobe 1.35 × 0.6], "Maid room"), (10.375, 1.2, 10.975, 2.3, [desk], "Maid room"), (9.97, 1.5, 10.32, 1.85, [], "Maid room"),
    (12.4, 3.325, 13.186, 4.1, [shower · floor drain], "Maid bath"), (11.85, 3.325, 12.25, 3.925, [WC], "Maid bath"), (11.85, 4.2, 12.25, 4.6, [basin], "Maid bath"),
    (9.05, 4.8, 9.65, 6.3, [folding · ironing table], "Laundry"), (10.7, 5.75, 11.3, 6.4, [washer 1], "Laundry"), (11.35, 5.75, 11.95, 6.4, [washer 2 + dryer], "Laundry"), (12.0, 5.8, 12.6, 6.4, [cupboards], "Laundry"), (12.65, 5.8, 13.18, 6.4, [steam station], "Laundry")),
  gf-doors: (((9.7, 4.7), (10.6, 4.7), (0, -1)), ((11.1, 3.7), (11.1, 4.4), (1, 0)), ((9.7, 6.5), (10.6, 6.5), (0, 0))),
  gf-windows: (((11.1, 1.2), (11.1, 2.3)), ((12.5, 3.2), (13.0, 3.2)), ((XE, 5.35), (XE, 6.25))),
  ff-furn: ((10.5, 1.95, 10.9, 2.35, [], "Bedroom 1"), (10.9, 3.9, 12.0, 4.5, [desk], "Bedroom 1"), (11.2, 3.35, 11.65, 3.8, [], "Bedroom 1")),
  ff-windows: (((11.1, 1.4), (11.1, 2.4)), ((9.2, 0), (10.2, 0)), ((XE, 6.5), (XE, 6.95))),
  cols: (((11.1, 0), "C30′"), ((11.1, 3.2), "C31′"), ((XE, 3.2), "C32′"), ((XE, 6.5), "C33′ new")),
  verdict: [MEETS the goal: the kitchen, bedroom 1 (its bath F20 and both wardrobes in place), the laundry and the suite's WC closet untouched; the maid room and bath clean rectangles; +#r2(lost-today - (XE - 11.1) * 3.2) m² per floor against the slant.],
)
#let rooms-ff(sc) = ff-fixed(sc.XS, sc.YS)
#let clear-of(sc, r, gf: true) = clear-poly(r.at(1), sc.XS, sc.YS, if gf { sc.gf-light } else { () })
#let cw(c) = { let b = bbox(c); b.at(2) - b.at(0) }; #let cd(c) = { let b = bbox(c); b.at(3) - b.at(1) }
#let lost(sc) = (XE - sc.XS) * sc.YS
#let st(sc) = site(sc.XS, sc.YS, sc.s)
// checks per scenario: furniture inside the clear rooms, no overlaps, the door swings clear, both margins ≥ today's
#let overlap(a, b) = not (a.at(2) <= b.at(0) + 1e-9 or b.at(2) <= a.at(0) + 1e-9 or a.at(3) <= b.at(1) + 1e-9 or b.at(3) <= a.at(1) + 1e-9)
#let bx(f) = (f.at(0), f.at(1), f.at(2), f.at(3))
#let in-poly(b, P) = { let e = 0.001; ((b.at(0) + e, b.at(1) + e), (b.at(2) - e, b.at(1) + e), (b.at(2) - e, b.at(3) - e), (b.at(0) + e, b.at(3) - e)).all(p => inside(p, P)) }
#let no-overlaps(L) = range(L.len()).all(i => range(L.len()).all(j => i == j or not overlap(L.at(i), L.at(j))))
#let swing(d) = { let (a, b, dir) = d; let w = dist(a, b); let (x0, x1, y0, y1) = (calc.min(a.at(0), b.at(0)), calc.max(a.at(0), b.at(0)), calc.min(a.at(1), b.at(1)), calc.max(a.at(1), b.at(1)))
  if dir.at(1) < 0 { (x0, y0 - w, x1, y0) } else if dir.at(1) > 0 { (x0, y0, x1, y0 + w) } else if dir.at(0) > 0 { (x0, y0, x0 + w, y1) } else if dir.at(0) < 0 { (x0 - w, y0, x0, y1) } else { (x0, y0, x1, y1) } }
#let checks(sc) = { let ff = rooms-ff(sc); let ffn = ff-furn-common + sc.ff-furn
  (sc.gf-furn.all(f => in-poly(bx(f), clear-of(sc, sc.gf.find(r => r.at(0) == f.at(5))))) and no-overlaps(sc.gf-furn.map(bx)),
   ffn.all(f => in-poly(bx(f), clear-of(sc, ff.find(r => r.at(0) == f.at(5)), gf: false))) and no-overlaps(ffn.map(bx)),
   sc.gf-doors.map(swing).all(s => sc.gf-furn.map(bx).all(b => not overlap(s, b))) and ff-doors.map(swing).all(s => ffn.map(bx).all(b => not overlap(s, b))),
   st(sc).deed >= today.deed - 1e-6 and st(sc).built >= today.built - 1e-6) }
#let ok-A = checks(scen-A); #let ok-B = checks(scen-B)
#let all-ok = (ok-A + ok-B).all(v => v)
// the third shift tested, 0.75 m (numbers only): XS ≤ 10.95 (11.0 gives 0.420 < 0.422), YS ≥ 3.45
#let C = (XS: 10.95, YS: 3.45, s: 0.75); #let st-C = site(C.XS, C.YS, C.s); #let lost-C = (XE - C.XS) * C.YS
#let bed1-C = area(clear-poly(bed1-poly(C.XS, C.YS), C.XS, C.YS, ()))

// ---------- the plan ----------
#let q(p) = (p.at(0), -p.at(1))
#let hatch = tiling(size: (3pt, 3pt))[#place(line(start: (0pt, 3pt), end: (3pt, 0pt), stroke: 0.3pt + red))]
#let cut-today = ((10.461, 0), (13.311, 5.245))
#let today-walls-gf = (((10.65, 3.2), (12.1996, 3.2)), ((10.65, 3.2), (10.65, 4.7)), ((XW, 4.7), (13.0148, 4.7)))
#let today-walls-ff = (((11.5, 5.6), (13.311, 5.6)), ((11.5, 5.6), (11.5, 8.0)), ((10.15, 5.3), (10.15, 6.5)), ((XW, 5.3), (10.15, 5.3)), ((10.3, 6.5), (11.5, 6.5)), ((10.3, 6.5), (10.3, 8.0)))
#let cols-today = ((10.461, 0, "C30"), (11.982, 2.8, "C31"), (13.311, 5.245, "C32"))
#let plan(sc, gf: true) = cetz.canvas(length: 2.0cm, {
  import cetz.draw: *
  let (XS, YS, s) = (sc.XS, sc.YS, sc.s); let sh = (shift0.at(0), shift0.at(1) + s)
  let rooms = if gf { sc.gf } else { rooms-ff(sc) }; let furn = if gf { sc.gf-furn } else { ff-furn-common + sc.ff-furn }; let doors = if gf { sc.gf-doors } else { ff-doors }; let windows = if gf { sc.gf-windows } else { sc.ff-windows }
  let (x0, y0, x1, y1) = (8.5, -0.3, 13.75, 8.5)
  let T(p, body, size: 4.2pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, body))
  let R(b, fill: none, stroke: none) = { let c = (calc.max(b.at(0), x0), calc.max(b.at(1), y0), calc.min(b.at(2), x1), calc.min(b.at(3), y1)); if c.at(2) > c.at(0) and c.at(3) > c.at(1) { rect(q((c.at(0), c.at(1))), q((c.at(2), c.at(3))), fill: fill, stroke: stroke) } }
  rect(q((x0, y0)), q((x1, y1)), fill: rgb("#f3efe6"), stroke: none)
  for x in range(9, 14) { line(q((x, y0)), q((x, y1)), stroke: 0.2pt + luma(222)); T((x, y0 + 0.12), str(x), size: 3.6pt, fill: gray) }
  for y in range(0, 9) { line(q((x0, y)), q((x1, y)), stroke: 0.2pt + luma(222)); T((x0 + 0.12, y), str(y), size: 3.6pt, fill: gray) }
  R((XS, 0, XE, YS), fill: hatch, stroke: none)
  // the deed setback line in the design frame of this scenario, each segment clipped to the window
  let envd = env.map(p => (p.at(0) - sh.at(0), p.at(1) - sh.at(1)))
  for i in range(envd.len() - 1) { let a = envd.at(i); let b = envd.at(i + 1); let (dx, dy) = (b.at(0) - a.at(0), b.at(1) - a.at(1)); let (t0, t1) = (0.0, 1.0); let bad = false
    for (pp, qq) in ((-dx, a.at(0) - x0), (dx, x1 - a.at(0)), (-dy, a.at(1) - y0), (dy, y1 - a.at(1))) { if pp == 0 { if qq < 0 { bad = true } } else { let r = qq / pp; if pp < 0 { t0 = calc.max(t0, r) } else { t1 = calc.min(t1, r) } } }
    if not bad and t0 < t1 { line(q((a.at(0) + t0 * dx, a.at(1) + t0 * dy)), q((a.at(0) + t1 * dx, a.at(1) + t1 * dy)), stroke: (paint: accent, thickness: 0.8pt, dash: "dashed")) } }
  T((13.45, 0.6), [deed setback line], size: 3.6pt, fill: accent, angle: -62deg)
  if gf { R((x0, 0, XW, 6.5), fill: luma(236), stroke: 0.5pt + luma(170)); T((8.72, 3.3), [women's majlis], size: 4pt, fill: gray, angle: 90deg) }
  else { R((x0, 3.0, XW, 6.5), fill: luma(236), stroke: 0.5pt + luma(170)); T((8.72, 4.75), [family living], size: 4pt, fill: gray, angle: 90deg); R((x0, 0, XW, 3.0), fill: luma(236), stroke: 0.5pt + luma(170)); T((8.72, 1.5), [kids' room], size: 4pt, fill: gray, angle: 90deg) }
  let col(k) = if k == "wet" { rgb("#cfe6ef") } else if k == "maid" { rgb("#e4e9d6") } else if k == "laundry" { rgb("#dfe3e6") } else if k == "kitchen" { rgb("#d9e6ec") } else if k == "bed" { rgb("#f6e3c0") } else if k == "circ" { rgb("#f2efe8") } else { luma(236) }
  for (n, P, k) in rooms { let b = bbox(P); let strokec = if k.ends-with("g") { (paint: luma(170), thickness: 0.5pt) } else { 0.9pt + ink }
    if P.len() == 4 { R(b, fill: col(k), stroke: strokec) } else { line(..P.map(q), close: true, fill: col(k), stroke: strokec) } }
  line(q((XW, 0)), q((XS, 0)), q((XS, YS)), q((XE, YS)), q((XE, 8.5)), stroke: 2.2pt + ink)
  line(q(cut-today.at(0)), q(cut-today.at(1)), stroke: (paint: red, thickness: 1.2pt, dash: "dashed")); T((12.3, 1.9), [today's cut wall], size: 3.8pt, fill: red, angle: -61deg)
  for (a, b) in (if gf { today-walls-gf } else { today-walls-ff }) { line(q(a), q(b), stroke: (paint: red, thickness: 0.5pt, dash: "dashed")) }
  for (fx0, fy0, fx1, fy1, l, rm) in furn.filter(f => f.at(1) < y1) { R((fx0, fy0, fx1, fy1), fill: rgb("#fbf6ea"), stroke: 0.45pt + rgb("#8a7a5a")); if fy1 <= y1 { T(((fx0 + fx1) / 2, (fy0 + fy1) / 2), l, size: 3.3pt, angle: if (fy1 - fy0) > (fx1 - fx0) * 1.4 { 90deg } else { 0deg }) } }
  if not gf { line(q((XW, 5.3)), q((XW, 6.5)), stroke: 2pt + rgb("#f2efe8")) }
  for d in doors.filter(d => d.at(0).at(1) <= y1) { line(q(d.at(0)), q(d.at(1)), stroke: 2.6pt + red); if d.at(2) != (0, 0) { R(swing(d), stroke: (paint: red, thickness: 0.35pt, dash: "dashed")) } }
  for (a, b) in windows { line(q(a), q(b), stroke: (paint: blue, thickness: 2pt, dash: "dashed")) }
  for (x, y, id) in cols-today { rect(q((x - 0.13, y - 0.13)), q((x + 0.13, y + 0.13)), stroke: (paint: red, thickness: 0.6pt, dash: "dashed")) }
  for (p, id) in sc.cols { rect(q((p.at(0) - 0.125, p.at(1) - 0.125)), q((p.at(0) + 0.125, p.at(1) + 0.125)), fill: ink, stroke: none); T((p.at(0) + 0.2, p.at(1) - 0.2), id, size: 3.8pt, fill: ink, anchor: "west") }
  for (n, P, k) in rooms {
    let c = clear-of(sc, (n, P, k), gf: gf)
    let at = if n == "Maid room" { (9.9, 4.1) } else if n == "Bedroom 1" { (12.2, 4.75) } else if n == "Laundry" { (11.6, if sc.col == "A" { 5.55 } else { 5.2 }) } else if n == "Kitchen" { (11.1, 7.2) } else if n == "Maid bath" { (12.5, if sc.col == "A" { 4.9 } else { 4.5 }) } else if n == "Bedroom 1 bath F20" { (12.4, 6.75) } else if n == "Family link" { (9.55, 5.9) } else if n == "Suite WC (closet)" { (10.9, 7.6) } else if n == "Suite lobby" { (9.6, 8.0) } else { (11.7, 8.35) }
    if k.ends-with("g") { T(at, [#n], size: 3.8pt, fill: gray) } else if P.len() == 4 { T(at, [*#n*\ #r2(cw(c)) × #r2(cd(c)) · #r2(area(c)) m²], size: 4.0pt) } else { T(at, [*#n*\ #r2(area(c)) m² clear], size: 4.0pt) }
  }
  let r = st(sc)
  T((XS + 0.3, -0.25), [north corner: deed #r2(deed-dist((XS + 0.125 + sh.at(0), -0.125 + sh.at(1)))) · built #r2(lane-dist((XS + 0.125 + sh.at(0), -0.125 + sh.at(1))) - built-offset - setback-built)], size: 3.4pt, fill: accent, anchor: "west")
  T((13.3, YS - 0.45), [east corner: deed #r2(deed-dist((XE + 0.125 + sh.at(0), YS - 0.125 + sh.at(1)))) · built #r2(lane-dist((XE + 0.125 + sh.at(0), YS - 0.125 + sh.at(1))) - built-offset - setback-built)], size: 3.4pt, fill: accent, anchor: "east")
  T((XS - 0.1, YS / 2), [step face x #r2(XS)], size: 3.6pt, fill: ink, angle: 90deg); T((XS + (XE - XS) / 2, YS + 0.15), [step face y #r2(YS)], size: 3.6pt, fill: ink)
  T((x0 + 0.15, y0 + 0.5), if gf { [GROUND FLOOR · the maid's wing, the laundry, the kitchen] } else { [FIRST FLOOR · bedroom 1, F20, the link, the suite's closet] }, size: 5.6pt, fill: accent, anchor: "west")
  line(q((x0 + 0.2, 8.3)), q((x0 + 1.2, 8.3)), stroke: 1pt + ink); T((x0 + 0.7, 8.15), [1 m], size: 3.6pt)
})
#let page-of(sc, oks) = {
  let r = st(sc); let ff = rooms-ff(sc)
  text(11.5pt, weight: "bold", fill: accent)[The NE step with #sc.name · B1 #r2(r.b1) m from M1] + h(1fr) + text(6.4pt, fill: gray)[study · design files unchanged · 1 : 50 · CSV frame, north up · today's slant and walls dashed red · the corner given up hatched]
  v(1pt); line(length: 100%, stroke: 0.6pt + accent)
  grid(columns: (auto, auto, 1fr), column-gutter: 8pt, plan(sc, gf: true), plan(sc, gf: false), [
    #set text(6.6pt)
    *The limits with the house #r2(sc.s) m south.* Every outer face sampled at 5 cm: the north corner may go to x #r2(if sc.col == "A" { 10.85 } else { 11.1 }) (the wall-as-built reading), the east corner must stay south of y #r2(if sc.col == "A" { 3.7 } else { 3.2 }) (the lane notch). Chosen: *x #r2(sc.XS), y #r2(sc.YS)* #if sc.col == "B" [(y 3.2 is the maid bath's partition line today; x 11.1 becomes the bath's west wall)] else [(no existing line fits: the bath line y 3.2 fails by 0.4 m)]. The corner given up #r2(XE - sc.XS) × #r2(sc.YS) = #r2(lost(sc)) m² per floor against the slant's #r2(lost-today): *#if lost(sc) > lost-today [−#r2(lost(sc) - lost-today)] else [+#r2(lost-today - lost(sc))] m² per floor.* Margins: deed #r2(r.deed) m (today #r2(today.deed)), wall as built #r2(r.built) m (today #r2(today.built)).

    *Ground floor.* #if sc.col == "A" [The maid room x 8.95–10.85 (#r2(area(clear-of(sc, sc.gf.at(0)))) m² clear, 1.68 m wide); the maid bath east of it must be 1.5 m deep (y 3.7–5.2), so *the laundry is squeezed to 1.3 m on axes (1.10 m clear, the passage in front of the machines 0.50 m)*: not workable; the alternative is the laundry in the kitchen's north band, which is what the owner refused.] else [The maid room a clean rectangle x 8.95–11.1 (#r2(area(clear-of(sc, sc.gf.at(0)))) m² clear ≥ 7.28: the bed on the north wall, the wardrobe on the majlis wall, the desk at the escape casement on the step's face); the maid bath a clean rectangle x 11.1–13.311 × y 3.2–4.7 (#r2(area(clear-of(sc, sc.gf.at(1)))) m² clear: the shower in the east corner, the WC on the north wall, the basin by the door from her room); *the laundry and the kitchen exactly as today.*]

    *First floor.* Bedroom 1 keeps its footprint with the slant replaced by the step (orthogonal walls, one re-entrant corner; its bath F20, both built-in wardrobes, the bed and its door from the link in place): *#r2(area(clear-of(sc, ff.at(0), gf: false))) m² clear* (today 15.70); #if sc.col == "A" [the desk moves 0.1 m east and loses its chair's place; the nightstand goes.] else [the desk, its chair and the nightstand as today.] The escape casement moves from the cut to the step's east face (x #r2(sc.XS), y 1.4–2.4). F20, the link, the suite's WC closet and the suite bath untouched (M3 as adopted).

    *Structure.* Three corner columns replace the three on the cut: C30′ (#r2(sc.XS), 0), C31′ (#r2(sc.XS), #r2(sc.YS)) at the re-entrant corner, C32′ (13.311, #r2(sc.YS)); *C33′ new* at (13.311, 6.5) on the structural line y 6.5 keeps the east wall's spans at #r2(6.5 - sc.YS) + 3.95 m; the RC cut wall W4 becomes two orthogonal RC walls #r2(sc.YS) + #r2(XE - sc.XS) m with beams on the step's lines at each slab; the maid bath's walls are 100 mm partitions on the slab.

    *The site.* B1 #r2(r.b1) m from M1 (today 6.00); the north strip for the car #r2(r.strip) m deep at B1 (today #r2(today.strip): *+#r2(sc.s) m*); the palms: T1 #r2(r.palm1) m from the east wall (unchanged), T2 #r2(r.palm2) m from the south-east corner (today #r2(today.palm2)).

    #block(fill: if sc.col == "A" { rgb("#fbe3dd") } else { rgb("#e4eedf") }, inset: 4pt, radius: 2pt, width: 100%, text(6.6pt, weight: "bold")[#sc.verdict])
    #text(6.2pt, fill: gray)[Quick checks: #if oks.all(v => v) [passed (4): furniture inside the clear rooms, no overlaps; the door swings clear; both margins ≥ today's.] else [FAILED: #oks.enumerate().filter(((i, v)) => not v).map(((i, v)) => str(i + 1)).join(", ")]]
  ])
}
#page-of(scen-A, ok-A)
#pagebreak()
#page-of(scen-B, ok-B)

// ======================= PAGE 3 · the table =======================
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[Today · the step at today's position (fe5612d) · the step at 0.5 m south · the step at 1.0 m south (the smallest sufficient shift)] #h(1fr) #text(6.4pt, fill: gray)[m² *clear* inside the walls as drawn (0.125 outer, 0.10 inner, 0.05 partitions) · today = the schedule of 17 Nov 2026]
#v(1pt) #line(length: 100%, stroke: 0.6pt + accent)
#v(3pt)
#let cA(n, gf: true) = area(clear-of(scen-A, (if gf { scen-A.gf } else { rooms-ff(scen-A) }).find(r => r.at(0) == n), gf: gf))
#let cB(n, gf: true) = area(clear-of(scen-B, (if gf { scen-B.gf } else { rooms-ff(scen-B) }).find(r => r.at(0) == n), gf: gf))
#let wd(sc, n, gf: true) = { let c = clear-of(sc, (if gf { sc.gf } else { rooms-ff(sc) }).find(r => r.at(0) == n), gf: gf); r2(cw(c)) + " × " + r2(cd(c)) }
#let rA = st(scen-A); #let rB = st(scen-B)
#set text(6.9pt)
#table(columns: (1.25fr, 1.15fr, 1.3fr, 1.3fr, 1.3fr), stroke: 0.3pt + luma(190), inset: 3pt, align: left, fill: (_, y) => if y == 0 { rgb("#e1e9e3") } else if calc.even(y) { rgb("#efece4") },
  table.header([], [*Today (the slant)*], [*Step at today's position* (fe5612d: 10.55, 4.20)], [*Step at 0.5 m south* (10.85, 3.70)], [*Step at 1.0 m south* (11.10, 3.20)]),
  table.cell(colspan: 5, fill: rgb("#dfe8e1"))[*Ground floor · clear*],
  [Maid room], [8.85 (L-shaped, to the cut)], [8.58 (4.14 × 2.08, the band)], [*#r2(cA("Maid room"))* (#wd(scen-A, "Maid room"))], [*#r2(cB("Maid room"))* (#wd(scen-B, "Maid room"))],
  [Maid bath], [2.50 (sloped)], [2.41 (1.38 × 1.75, in the strip)], [#r2(cA("Maid bath")) (#wd(scen-A, "Maid bath"))], [#r2(cB("Maid bath")) (#wd(scen-B, "Maid bath"))],
  [Laundry], [6.75 (4.14 × 1.60)], [6.82 (moved to y 6.5–8.3)], [#text(fill: red)[*#r2(cA("Laundry"))* (#wd(scen-A, "Laundry")): squeezed, the passage 0.50 m]], [#r2(cB("Laundry")) (#wd(scen-B, "Laundry")), as today],
  [Kitchen], [26.06 (4.14 × 6.28)], [#text(fill: red)[18.82 (−7.24): 1.8 m shorter]], [26.06, untouched], [26.06, untouched],
  [GF: the corner given up (axes)], [the triangle 7.47], [11.60 (−4.12)], [#r2(lost(scen-A)) (−#r2(lost(scen-A) - lost-today))], [#r2(lost(scen-B)) (*+#r2(lost-today - lost(scen-B))*)],
  table.cell(colspan: 5, fill: rgb("#dfe8e1"))[*First floor · clear*],
  [Bedroom 1], [15.70 (9-point polygon)], [#text(fill: red)[10.50 (2.94 × 3.58), −5.20]], [#text(fill: red)[*#r2(cA("Bedroom 1", gf: false))* (−#r2(15.70 - cA("Bedroom 1", gf: false)))]], [*#r2(cB("Bedroom 1", gf: false))* (+#r2(cB("Bedroom 1", gf: false) - 15.70))],
  [Bedroom 1 bath F20], [3.49 (1.6 × 2.2), en-suite], [5.47 in the strip, from the link (not en-suite)], [3.49, in place, en-suite], [3.49, in place, en-suite],
  [Family link], [1.10 (1.0 × 1.0)], [2.10 (1.0 × 2.1)], [1.10, as today], [1.10, as today],
  [Suite WC (closet)], [1.30 (M3)], [#text(fill: red)[gone (the WC back in the bath)]], [1.30, as today], [1.30, as today],
  [FF: the corner given up (axes)], [7.47], [11.60 (−4.12)], [#r2(lost(scen-A)) (−#r2(lost(scen-A) - lost-today))], [#r2(lost(scen-B)) (*+#r2(lost-today - lost(scen-B))*)],
  table.cell(colspan: 5, fill: rgb("#dfe8e1"))[*Structure at the corner*],
  [Columns], [C30 (10.461, 0) · C31 (11.982, 2.8) · C32 (13.311, 5.245); the RC cut wall W4 (6.0 m)], [C30′ (10.55, 0) · C31′ (10.55, 4.2) · C32′ (13.311, 4.2) · C33′ new (13.311, 6.5); RC walls 4.2 + 2.76], [C30′ (10.85, 0) · C31′ (10.85, 3.7) · C32′ (13.311, 3.7) · C33′ new (13.311, 6.5); RC walls 3.7 + 2.46], [C30′ (11.1, 0) · C31′ (11.1, 3.2) · C32′ (13.311, 3.2) · C33′ new (13.311, 6.5); RC walls 3.2 + 2.21; beams on the step's lines at each slab],
  [Spans], [north 1.5; the cut 3.2 + 3.6; east 5.2], [north 1.6; the step 4.2 / 2.76; east 2.3 + 3.95], [north 1.9; the step 3.7 / 2.46; east 2.8 + 3.95], [north 2.15; the step 3.2 / 2.21; east 3.3 + 3.95],
  table.cell(colspan: 5, fill: rgb("#dfe8e1"))[*The site*],
  [B1 from M1], [6.00 m], [6.00 m], [#r2(rA.b1) m], [#r2(rB.b1) m],
  [Tightest margin · deed setback line], [#r2(today.deed) m (the cut, at the notch)], [1.08 m], [#r2(rA.deed) m (the north corner)], [#r2(rB.deed) m (the north corner)],
  [Tightest margin · 2.0 m from the wall as built], [#r2(today.built) m], [0.46 m], [#r2(rA.built) m], [#r2(rB.built) m],
  [The palms: T1 from the east wall · T2 from the SE corner], [#r2(today.palm1) · #r2(today.palm2) m], [#r2(today.palm1) · #r2(today.palm2) m], [#r2(rA.palm1) · #r2(rA.palm2) m], [#r2(rB.palm1) · #r2(rB.palm2) m],
  [The north strip for the car (depth at B1)], [#r2(today.strip) m], [#r2(today.strip) m], [#r2(rA.strip) m (*+0.50*)], [#r2(rB.strip) m (*+1.00*)],
  [Verdict], [—], [buildable; costs the kitchen, bedroom 1, the closet], [#text(fill: red)[fails: the laundry squeezed or moved, bedroom 1 −#r2(15.70 - cA("Bedroom 1", gf: false))]], [*meets the goal: nothing taken; +#r2(lost-today - lost(scen-B)) m² per floor*],
)
#v(3pt)
#text(6.9pt)[*0.75 m south (tested, numbers only):* the limits give x ≤ 10.95 and y ≥ 3.45 (margins #r2(st-C.deed) / #r2(st-C.built) m, B1 #r2(st-C.b1) m): the corner given up #r2(lost-C) m² (−#r2(lost-C - lost-today) per floor), bedroom 1 #r2(bed1-C) m² clear (−#r2(15.70 - bed1-C)), and the maid bath east of the room is only 1.25 m deep on axes (1.03 clear) unless the laundry gives up 0.25 m: not sufficient. *The smallest sufficient shift is 1.0 m.*]
#v(3pt)
#ah[#text(7.8pt)[الدرجة بدل الجدار المائل مع إزاحة البيت جنوبًا: عند 0.5 م لا تكفي (الغسيل يُضغط إلى 1.10 م صافٍ أو ينتقل إلى حزام المطبخ، وغرفة النوم 1 تخسر #r2(15.70 - cA("Bedroom 1", gf: false)) م²)، وعند 0.75 م لا تكفي أيضًا؛ أما عند *1.0 م جنوبًا* (B1 على #r2(rB.b1) م من البوابة) فالدرجة عند x 11.10 و y 3.20 لا تأخذ شيئًا من المطبخ ولا من غرفة النوم 1 (#r2(cB("Bedroom 1", gf: false)) م² مع حمامها F20 ودولابيها) ولا من غرفة مرحاض الجناح، وغرفة الخادمة وحمامها مستطيلان نظيفان، ويكسب كل دور #r2(lost-today - lost(scen-B)) م² على القطع المائل؛ الهامشان #r2(rB.deed) / #r2(rB.built) م (اليوم #r2(today.deed) / #r2(today.built))، والشريط الشمالي للسيارة أعمق بمتر، والنخلتان على #r2(rB.palm1) و#r2(rB.palm2) م.]]

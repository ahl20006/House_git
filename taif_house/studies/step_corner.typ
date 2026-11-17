// step_corner.typ · Taif / Palm House · STUDY (owner, 17 Nov 2026): orthogonal STEPS instead of the slanted north-east cut wall, with the house moved SOUTH along the M line.
// Round 1 (fe5612d): ONE step at today's position (B1 6.00 m from M1): costs the kitchen 7.2 m², bedroom 1 5.2 m² and the suite's WC closet.
// Round 2 (d34b736): one step with the house 0.5 / 0.75 / 1.0 m south: 1.0 m meets the goal (nothing taken from the kitchen, bedroom 1 ≈ 15.7 clear with F20 in place, the closet).
// Round 3 (this file): TWO steps (a staircase hugging the slant) at today's position, 0.5 and 0.75 m south; the new municipal check on every option: the maid room ≥ 2.10 m clear wide and
// ≥ 6.5 m² clear (decision V6.4); the middle piece the two steps create must be useful (a wardrobe, a store, part of a bath). The one step at 1.0 m (maid room 1.95 wide) corrected.
// Today the cut runs on axes from (10.461, 0) to (13.311, 5.245). A staircase of steps ((x1, y1), (x2, y2), …): the north wall ends at x1, the face x1 runs to y1, the face y1 to x2, … , the
// east wall starts at the last y. The limits (SITE_SETOUT.md § 5, both readings, every outer face sampled at 5 cm): (A) the deed setback line (base.typ `env`): today 0.91 m at the lane notch;
// (B) 2.0 m from the lane wall AS BUILT: the model's lane line (base.typ `lane`) less the 0.62 m the sheet uses for the wall as built, less 2.0: today 0.42 m. Both must stay ≥ today's.
// Nothing in the design files is changed. CSV frame: x east, y south, wall centre lines; the outer walls 0.25, the inner walls 0.20, the 100 mm partitions 0.10.
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
// the outer faces of a house with the steps (none = today's slant)
#let faces-of(steps) = if steps == none { ((-0.125, -0.125), (10.535, -0.125), (13.436, 5.214), (13.436, 24.125), (-0.125, 24.125)) } else {
  let out = ((-0.125, -0.125),); let yprev = 0
  for (x, y) in steps { out.push((x + 0.125, yprev - 0.125)); out.push((x + 0.125, y - 0.125)); yprev = y }
  out + ((XE + 0.125, yprev - 0.125), (XE + 0.125, 24.125), (-0.125, 24.125)) }
#let site(steps, s) = {   // the readings of a house with the steps, moved s metres south
  let sh = (shift0.at(0), shift0.at(1) + s); let S(p) = (p.at(0) + sh.at(0), p.at(1) + sh.at(1)); let P = faces-of(steps); let pts = face-pts(P)
  let a = pts.sorted(key: p => deed-dist(S(p))).first(); let b = pts.sorted(key: p => lane-dist(S(p))).first()
  let palm(T) = calc.min(..range(P.len()).map(i => pseg(T, S(P.at(i)), S(P.at(calc.rem(i + 1, P.len())))))) - 0.265
  let b1 = S(P.first())
  (deed: deed-dist(S(a)), deed-at: a, built: lane-dist(S(b)) - built-offset - setback-built, built-at: b, b1: dist(b1, (0, 0)), palm1: palm(T1), palm2: palm(T2),
   strip: (b1.at(1) + b1.at(0) * 1.59 / 8.64))   // the north strip's depth at B1: from the wall face to the plot's north line ((0, 0) → (8.64, −1.59))
}
#let today = site(none, 0)
#let lost-today = 2.85 * 5.245 / 2
#let lost(steps) = { let yprev = 0; let a = 0; for (x, y) in steps { a += (XE - x) * (y - yprev); yprev = y }; a }

// ---------- rooms, clear areas ----------
// walls: outer 0.125 where the edge lies on the building's outline; `light` (100 mm partitions) 0.05; else 0.10
#let on-outline(a, b, steps) = {
  let v(x) = calc.abs(a.at(0) - x) < 1e-6 and calc.abs(b.at(0) - x) < 1e-6; let h(y) = calc.abs(a.at(1) - y) < 1e-6 and calc.abs(b.at(1) - y) < 1e-6
  let lo-x = calc.min(a.at(0), b.at(0)); let hi-x = calc.max(a.at(0), b.at(0)); let lo-y = calc.min(a.at(1), b.at(1)); let hi-y = calc.max(a.at(1), b.at(1))
  let yes = v(XE) or (h(0) and hi-x <= steps.first().at(0) + 1e-6); let yprev = 0; let xprev = none
  for (x, y) in steps { if xprev != none and h(yprev) and lo-x >= xprev - 1e-6 and hi-x <= x + 1e-6 { yes = true }; if v(x) and lo-y >= yprev - 1e-6 and hi-y <= y + 1e-6 { yes = true }; xprev = x; yprev = y }
  if h(yprev) and lo-x >= xprev - 1e-6 { yes = true }
  yes
}
#let on-seg(p, a, b) = calc.abs(dist(a, p) + dist(p, b) - dist(a, b)) < 1e-6
#let is-cw(P) = range(P.len()).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, P.len())); a.at(0) * b.at(1) - b.at(0) * a.at(1) }).sum() > 0
#let area(P) = calc.abs(range(P.len()).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, P.len())); a.at(0) * b.at(1) - b.at(0) * a.at(1) }).sum()) / 2
#let inset(P, d) = {
  let n = P.len()
  let lines = range(n).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, n)); let (dx, dy) = (b.at(0) - a.at(0), b.at(1) - a.at(1)); let L = calc.sqrt(dx * dx + dy * dy); ((a.at(0) - dy / L * d.at(i), a.at(1) + dx / L * d.at(i)), (dx, dy)) })
  range(n).map(i => { let (p1, v1) = lines.at(calc.rem(i + n - 1, n)); let (p2, v2) = lines.at(i); let den = v1.at(0) * v2.at(1) - v1.at(1) * v2.at(0); let t = ((p2.at(0) - p1.at(0)) * v2.at(1) - (p2.at(1) - p1.at(1)) * v2.at(0)) / den; (p1.at(0) + v1.at(0) * t, p1.at(1) + v1.at(1) * t) })
}
#let clear-poly(P, steps, light) = { let Q = if is-cw(P) { P } else { P.rev() }
  inset(Q, range(Q.len()).map(i => { let a = Q.at(i); let b = Q.at(calc.rem(i + 1, Q.len()))
    if light.any(((c, d)) => on-seg(a, c, d) and on-seg(b, c, d)) { 0.05 } else if on-outline(a, b, steps) { 0.125 } else { 0.10 } })) }
#let bbox(P) = (calc.min(..P.map(p => p.at(0))), calc.min(..P.map(p => p.at(1))), calc.max(..P.map(p => p.at(0))), calc.max(..P.map(p => p.at(1))))
#let inside(p, P) = { let c = false; let n = P.len(); for i in range(n) { let (xi, yi) = P.at(i); let (xj, yj) = P.at(calc.rem(i + n - 1, n)); if ((yi > p.at(1)) != (yj > p.at(1))) and (p.at(0) < (xj - xi) * (p.at(1) - yi) / (yj - yi) + xi) { c = not c } }; c }
#let cw(c) = { let b = bbox(c); b.at(2) - b.at(0) }; #let cd(c) = { let b = bbox(c); b.at(3) - b.at(1) }
#let bed1-poly(steps) = { let out = ((XW, 0),); let yprev = 0; for (x, y) in steps { out.push((x, yprev)); out.push((x, y)); yprev = y }; out + ((XE, yprev), (XE, 5.6), (11.5, 5.6), (11.5, 6.5), (10.15, 6.5), (10.15, 5.3), (XW, 5.3)) }
#let ff-fixed(steps) = (
  ("Bedroom 1", bed1-poly(steps), "bed"), ("Bedroom 1 bath F20", rect-pts(11.5, 5.6, XE, 8.0), "wet"), ("Family link", rect-pts(XW, 5.3, 10.15, 6.5), "circ"),
  ("Suite WC (closet)", rect-pts(10.3, 6.5, 11.5, 8.0), "wet"), ("Suite bath", rect-pts(10.3, 8.0, XE, 10.45), "suiteg"), ("Suite lobby", rect-pts(XW, 6.5, 10.3, 11.9), "circg"),
)
#let ff-furn-common = (   // (x0, y0, x1, y1, label, room): as today (studies/ff_family.typ, ff_suite.typ)
  (9.05, 0.35, 10.45, 2.35, [bed 1.4 × 2.0], "Bedroom 1"), (11.6, 4.9, 12.95, 5.5, [built-in wardrobe W1], "Bedroom 1"), (9.05, 2.6, 9.65, 5.2, [built-in wardrobe W2 2.4 × 0.6], "Bedroom 1"),
  (11.6, 6.5, 12.05, 7.1, [basin], "Bedroom 1 bath F20"), (12.6, 6.0, 13.186, 6.4, [WC], "Bedroom 1 bath F20"), (11.6, 7.1, 13.186, 7.9, [shower 1.6 × 0.8 · floor drain], "Bedroom 1 bath F20"),
  (10.7, 6.6, 11.1, 7.15, [WC · wall-hung], "Suite WC (closet)"),
  (11.9, 8.1, 13.186, 9.0, [shower], "Suite bath"), (12.586, 9.1, 13.186, 10.05, [2 basins], "Suite bath"), (10.4, 9.6, 12.1, 10.35, [tub], "Suite bath"),
)
#let ff-doors = (((10.15, 5.4), (10.15, 6.4), (1, 0)), ((11.5, 5.7), (11.5, 6.4), (1, 0)), ((10.5, 8.0), (11.2, 8.0), (0, 1)), ((9.0, 6.5), (10.1, 6.5), (0, 1)), ((10.3, 8.8), (10.3, 9.6), (1, 0)))
#let kitchen = ("Kitchen", rect-pts(XW, 6.5, XE, 13.0), "kitchen")
#let laundry = ("Laundry", rect-pts(XW, 4.7, XE, 6.5), "laundry")
#let laundry-furn = ((9.05, 4.8, 9.65, 6.3, [folding · ironing table], "Laundry"), (10.7, 5.75, 11.3, 6.4, [washer 1], "Laundry"), (11.35, 5.75, 11.95, 6.4, [washer 2 + dryer], "Laundry"), (12.0, 5.8, 12.6, 6.4, [cupboards], "Laundry"), (12.65, 5.8, 13.18, 6.4, [steam station], "Laundry"))

// ---------- the drawn scenarios ----------
#let scen-A = (   // ONE step, 0.5 m south: x ≤ 10.85 (reading B at the north corner), y ≥ 3.7 (the notch)
  name: [ONE step · the house 0.5 m south · the step (10.85, 3.70)], s: 0.5, steps: ((10.85, 3.7),), col: "A",
  gf: (("Maid room", rect-pts(XW, 0, 10.85, 4.7), "maid"), ("Maid bath", rect-pts(10.85, 3.7, XE, 5.2), "wet"), ("Laundry", rect-pts(XW, 5.2, XE, 6.5), "laundry"), kitchen),
  gf-light: (((10.85, 3.7), (10.85, 5.2)),),
  gf-furn: ((9.05, 0.125, 9.95, 2.125, [bed 0.9 × 2.0], "Maid room"), (9.05, 2.3, 9.65, 3.65, [wardrobe], "Maid room"), (10.125, 1.0, 10.725, 2.0, [desk], "Maid room"),
    (12.3, 3.825, 13.186, 4.7, [shower · floor drain], "Maid bath"), (11.65, 3.825, 12.05, 4.425, [WC], "Maid bath"), (11.6, 4.7, 12.0, 5.1, [basin], "Maid bath"),
    (9.05, 5.3, 9.65, 6.4, [table], "Laundry"), (9.9, 5.8, 10.5, 6.4, [washer 1], "Laundry"), (10.55, 5.8, 11.15, 6.4, [washer 2 + dryer], "Laundry"), (11.2, 5.8, 11.8, 6.4, [cupboards], "Laundry"), (11.85, 5.8, 12.4, 6.4, [steam], "Laundry")),
  gf-doors: (((9.3, 4.7), (10.2, 4.7), (0, -1)), ((10.85, 3.8), (10.85, 4.5), (1, 0)), ((12.45, 6.5), (13.186, 6.5), (0, 0))),
  gf-windows: (((10.85, 1.2), (10.85, 2.3)), ((12.0, 3.7), (12.5, 3.7)), ((XE, 5.4), (XE, 6.2))),
  ff-furn: ((11.0, 3.9, 12.1, 4.5, [desk], "Bedroom 1"), (11.0, 4.6, 11.45, 5.0, [], "Bedroom 1")),
  ff-windows: (((10.85, 1.4), (10.85, 2.4)), ((9.2, 0), (10.2, 0)), ((XE, 6.5), (XE, 6.95))),
  cols: (((10.85, 0), "C30′"), ((10.85, 3.7), "C31′"), ((XE, 3.7), "C32′"), ((XE, 6.5), "C33′ new")),
  verdict: [FAILS the goal: the maid bath needs the laundry's depth (the laundry 1.10 m clear, its passage 0.50 m), bedroom 1 loses 1.9 m² clear, and the maid room is 1.68 m wide (< 2.10).],
)
#let scen-B = (   // ONE step, 1.0 m south: x ≤ 11.1, y ≥ 3.2 (the maid bath's partition line)
  name: [ONE step · the house 1.0 m south · the step (11.10, 3.20)], s: 1.0, steps: ((11.1, 3.2),), col: "B",
  gf: (("Maid room", rect-pts(XW, 0, 11.1, 4.7), "maid"), ("Maid bath", rect-pts(11.1, 3.2, XE, 4.7), "wet"), laundry, kitchen),
  gf-light: (((11.1, 3.2), (11.1, 4.7)),),
  gf-furn: ((9.05, 0.125, 9.95, 2.125, [bed 0.9 × 2.0], "Maid room"), (9.05, 2.3, 9.65, 3.65, [wardrobe 1.35 × 0.6], "Maid room"), (10.375, 1.2, 10.975, 2.3, [desk], "Maid room"), (9.97, 1.5, 10.32, 1.85, [], "Maid room"),
    (12.4, 3.325, 13.186, 4.1, [shower · floor drain], "Maid bath"), (11.85, 3.325, 12.25, 3.925, [WC], "Maid bath"), (11.85, 4.2, 12.25, 4.6, [basin], "Maid bath")) + laundry-furn,
  gf-doors: (((9.7, 4.7), (10.6, 4.7), (0, -1)), ((11.1, 3.7), (11.1, 4.4), (1, 0)), ((9.7, 6.5), (10.6, 6.5), (0, 0))),
  gf-windows: (((11.1, 1.2), (11.1, 2.3)), ((12.5, 3.2), (13.0, 3.2)), ((XE, 5.35), (XE, 6.25))),
  ff-furn: ((10.5, 1.95, 10.9, 2.35, [], "Bedroom 1"), (10.9, 3.9, 12.0, 4.5, [desk], "Bedroom 1"), (11.2, 3.35, 11.65, 3.8, [], "Bedroom 1")),
  ff-windows: (((11.1, 1.4), (11.1, 2.4)), ((9.2, 0), (10.2, 0)), ((XE, 6.5), (XE, 6.95))),
  cols: (((11.1, 0), "C30′"), ((11.1, 3.2), "C31′"), ((XE, 3.2), "C32′"), ((XE, 6.5), "C33′ new")),
  verdict: [Meets the owner's goal (the kitchen, bedroom 1 with F20, the laundry, the closet untouched; +0.40 m² per floor) but FAILS the municipal check: the maid room 1.95 m clear wide (< 2.10). The corrections are in the table (rows 5 and 6).],
)
#let scen-T = (   // TWO steps, 0.5 m south: x1 ≤ 10.86, x2 ≤ 11.71 at y1 1.75, y2 ≥ 3.66
  name: [TWO steps · the house 0.5 m south · the steps (10.85, 1.75) and (11.70, 3.70)], s: 0.5, steps: ((10.85, 1.75), (11.7, 3.7)), col: "T",
  gf: (("Maid bath", rect-pts(XW, 0, 10.85, 1.75), "wet"), ("Maid room", rect-pts(XW, 1.75, 11.7, 4.7), "maid"), ("Maid's built-in wardrobe", rect-pts(11.7, 3.7, XE, 4.7), "store"), laundry, kitchen),
  gf-light: (((XW, 1.75), (10.85, 1.75)), ((11.7, 3.7), (11.7, 4.7))),
  gf-furn: ((9.05, 0.55, 9.65, 0.95, [WC], "Maid bath"), (10.3, 0.125, 10.7, 0.525, [basin], "Maid bath"), (10.0, 0.9, 10.725, 1.7, [shower · floor drain], "Maid bath"),
    (9.05, 2.4, 9.95, 4.4, [bed 0.9 × 2.0], "Maid room"), (10.975, 1.85, 11.575, 2.95, [desk], "Maid room"), (10.5, 2.1, 10.9, 2.5, [], "Maid room"), (10.975, 3.1, 11.575, 3.6, [chest], "Maid room"),
    (11.8, 3.825, 13.186, 4.6, [wardrobe 1.4 × 0.78 · sliding doors], "Maid's built-in wardrobe")) + laundry-furn,
  gf-doors: (((9.3, 1.75), (10.0, 1.75), (0, -1)), ((10.2, 4.7), (11.1, 4.7), (0, -1)), ((11.7, 3.8), (11.7, 4.6), (0, 0)), ((9.7, 6.5), (10.6, 6.5), (0, 0))),
  gf-windows: (((11.7, 2.0), (11.7, 3.0)), ((10.85, 0.6), (10.85, 1.1)), ((XE, 5.35), (XE, 6.25))),
  ff-furn: ((10.5, 2.0, 10.9, 2.4, [], "Bedroom 1"), (10.9, 3.9, 12.0, 4.5, [desk], "Bedroom 1"), (11.0, 3.35, 11.45, 3.8, [], "Bedroom 1")),
  ff-windows: (((11.7, 2.2), (11.7, 3.2)), ((9.2, 0), (10.2, 0)), ((XE, 6.5), (XE, 6.95))),
  cols: (((10.85, 0), "C30′"), ((10.85, 1.75), "C31′"), ((11.7, 1.75), "C32′"), ((11.7, 3.7), "C33′"), ((XE, 3.7), "C34′"), ((XE, 6.5), "C35′ new")),
  verdict: [MEETS the goal and the municipal check: the kitchen, the laundry, bedroom 1 (F20 and both wardrobes in place), the closet untouched; the maid room ≥ 2.5 m wide, ≈ 7.0 m²; the middle piece is the maid's built-in wardrobe; bedroom 1 within 0.25 m² of today; the corner given up ≈ the slant's.],
)
#let rooms-ff(sc) = ff-fixed(sc.steps)
#let clear-of(sc, r, gf: true) = clear-poly(r.at(1), sc.steps, if gf { sc.gf-light } else { () })
#let st(sc) = site(sc.steps, sc.s)
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
#let ok-A = checks(scen-A); #let ok-B = checks(scen-B); #let ok-T = checks(scen-T)

// ---------- the numbers-only options (the table) ----------
#let maid-clear(rect, steps, light) = clear-poly(rect, steps, light)
#let opt(id, label, s, steps, maid, bath, laun, kit, extra, light, cols, note) = {
  let r = site(steps, s); let mc = maid-clear(maid, steps, light); let bc = if bath == none { none } else { clear-poly(bath, steps, light) }
  let lc = clear-poly(laun, steps, light); let kc = clear-poly(kit, steps, light); let b1 = area(clear-poly(bed1-poly(steps), steps, ()))
  (id: id, label: label, s: s, steps: steps, r: r, maid: mc, bath: bc, laun: lc, kit: kc, extra: extra, bed1: b1, lost: lost(steps), cols: cols, note: note)
}
#let O = (
  opt([2], [ONE step · today's position (fe5612d)], 0, ((10.55, 4.2),), rect-pts(XW, 4.2, XE, 6.5), rect-pts(XW, 2.3, 10.55, 4.2), rect-pts(XW, 6.5, XE, 8.3), rect-pts(XW, 8.3, XE, 13.0), [plus an outdoor store 2.92], (((XW, 2.3), (10.55, 2.3)),),
    [C30′ (10.55, 0) · C31′ (10.55, 4.2) · C32′ (13.311, 4.2) · C33′ new (13.311, 6.5); RC walls 4.2 + 2.76], [bedroom 1 10.50 (F20 to the strip, not en-suite); the closet gone; the kitchen 1.8 m shorter]),
  opt([3], [ONE step · 0.5 m south (page 1)], 0.5, scen-A.steps, scen-A.gf.at(0).at(1), scen-A.gf.at(1).at(1), scen-A.gf.at(2).at(1), kitchen.at(1), [], scen-A.gf-light,
    [C30′ (10.85, 0) · C31′ (10.85, 3.7) · C32′ (13.311, 3.7) · C33′ new (13.311, 6.5); RC walls 3.7 + 2.46], [the laundry squeezed to 1.10 m clear; bedroom 1 −1.9; the maid room 1.68 wide]),
  opt([4], [ONE step · 1.0 m south, as drawn (page 2)], 1.0, scen-B.steps, scen-B.gf.at(0).at(1), scen-B.gf.at(1).at(1), laundry.at(1), kitchen.at(1), [], scen-B.gf-light,
    [C30′ (11.1, 0) · C31′ (11.1, 3.2) · C32′ (13.311, 3.2) · C33′ new (13.311, 6.5); RC walls 3.2 + 2.21], [the maid room 1.95 wide: fails the municipal check]),
  opt([5], [ONE step · 1.0 m south, CORRECTED in the corner: the maid room in the band y 3.2–5.55, the bath + a store in the strip, the laundry y 5.55–7.05], 1.0, ((11.1, 3.2),), rect-pts(XW, 3.2, XE, 5.55), rect-pts(XW, 1.5, 11.1, 3.2), rect-pts(XW, 5.55, XE, 7.05), rect-pts(XW, 7.05, XE, 13.0), [plus a store 2.55 in the strip's north], (((XW, 1.5), (11.1, 1.5)),),
    [as row 4], [the maid room 2.13 deep ✓, but the laundry takes 0.55 m from the KITCHEN (−2.4 m²): breaks the goal]),
  opt([6], [ONE step · 1.3 m south, the clean fix: the north face at x 11.275 (the maid room 2.10 clear)], 1.3, ((11.275, 3.2),), rect-pts(XW, 0, 11.275, 4.7), rect-pts(11.275, 3.2, XE, 4.7), laundry.at(1), kitchen.at(1), [], (((11.275, 3.2), (11.275, 4.7)),),
    [C30′ (11.275, 0) · C31′ (11.275, 3.2) · C32′ (13.311, 3.2) · C33′ new (13.311, 6.5); RC walls 3.2 + 2.04], [meets the goal and the check, but needs 1.3 m south]),
  opt([7], [TWO steps · today's position], 0, ((10.55, 1.7), (11.5, 4.2)), rect-pts(XW, 1.7, 11.5, 4.7), rect-pts(XW, 0, 10.55, 1.7), laundry.at(1), kitchen.at(1), [the middle piece x 11.5–13.311 × y 4.2–4.7: 0.28 m clear deep, a SLIVER], (((XW, 1.7), (10.55, 1.7)), ((11.5, 4.2), (11.5, 4.7))),
    [C30′ (10.55, 0) · C31′ (10.55, 1.7) · C32′ (11.5, 1.7) · C33′ (11.5, 4.2) · C34′ (13.311, 4.2) · C35′ new (13.311, 6.5)], [fails: bedroom 1 −1.4, the middle piece a sliver, the maid bath 1.38 × 1.48]),
  opt([8], [TWO steps · 0.5 m south (page 3)], 0.5, scen-T.steps, scen-T.gf.at(1).at(1), scen-T.gf.at(0).at(1), laundry.at(1), kitchen.at(1), [plus the maid's built-in wardrobe 1.39 × 0.78 (the middle piece)], scen-T.gf-light,
    [C30′ (10.85, 0) · C31′ (10.85, 1.75) · C32′ (11.7, 1.75) · C33′ (11.7, 3.7) · C34′ (13.311, 3.7) · C35′ new (13.311, 6.5); RC walls 1.75 + 0.85 + 1.95 + 1.61], [meets the goal and the check: the smallest sufficient shift]),
  opt([9], [TWO steps · 0.75 m south], 0.75, ((10.95, 1.75), (11.8, 3.45)), rect-pts(XW, 1.75, 11.8, 4.7), rect-pts(XW, 0, 10.95, 1.75), laundry.at(1), kitchen.at(1), [plus the maid's wardrobe / store 1.29 × 1.03 (the middle piece)], (((XW, 1.75), (10.95, 1.75)), ((11.8, 3.45), (11.8, 4.7))),
    [C30′ (10.95, 0) · C31′ (10.95, 1.75) · C32′ (11.8, 1.75) · C33′ (11.8, 3.45) · C34′ (13.311, 3.45) · C35′ new (13.311, 6.5)], [meets the goal and the check with more margin; not needed]),
)

// ---------- the plan ----------
#let q(p) = (p.at(0), -p.at(1))
#let hatch = tiling(size: (3pt, 3pt))[#place(line(start: (0pt, 3pt), end: (3pt, 0pt), stroke: 0.3pt + red))]
#let cut-today = ((10.461, 0), (13.311, 5.245))
#let today-walls-gf = (((10.65, 3.2), (12.1996, 3.2)), ((10.65, 3.2), (10.65, 4.7)), ((XW, 4.7), (13.0148, 4.7)))
#let today-walls-ff = (((11.5, 5.6), (13.311, 5.6)), ((11.5, 5.6), (11.5, 8.0)), ((10.15, 5.3), (10.15, 6.5)), ((XW, 5.3), (10.15, 5.3)), ((10.3, 6.5), (11.5, 6.5)), ((10.3, 6.5), (10.3, 8.0)))
#let cols-today = ((10.461, 0, "C30"), (11.982, 2.8, "C31"), (13.311, 5.245, "C32"))
#let plan(sc, gf: true) = cetz.canvas(length: 2.0cm, {
  import cetz.draw: *
  let s = sc.s; let sh = (shift0.at(0), shift0.at(1) + s); let steps = sc.steps
  let rooms = if gf { sc.gf } else { rooms-ff(sc) }; let furn = if gf { sc.gf-furn } else { ff-furn-common + sc.ff-furn }; let doors = if gf { sc.gf-doors } else { ff-doors }; let windows = if gf { sc.gf-windows } else { sc.ff-windows }
  let (x0, y0, x1, y1) = (8.5, -0.3, 13.75, 8.5)
  let T(p, body, size: 4.2pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, body))
  let R(b, fill: none, stroke: none) = { let c = (calc.max(b.at(0), x0), calc.max(b.at(1), y0), calc.min(b.at(2), x1), calc.min(b.at(3), y1)); if c.at(2) > c.at(0) and c.at(3) > c.at(1) { rect(q((c.at(0), c.at(1))), q((c.at(2), c.at(3))), fill: fill, stroke: stroke) } }
  rect(q((x0, y0)), q((x1, y1)), fill: rgb("#f3efe6"), stroke: none)
  for x in range(9, 14) { line(q((x, y0)), q((x, y1)), stroke: 0.2pt + luma(222)); T((x, y0 + 0.12), str(x), size: 3.6pt, fill: gray) }
  for y in range(0, 9) { line(q((x0, y)), q((x1, y)), stroke: 0.2pt + luma(222)); T((x0 + 0.12, y), str(y), size: 3.6pt, fill: gray) }
  let yprev = 0; for (x, y) in steps { R((x, yprev, XE, y), fill: hatch, stroke: none); yprev = y }
  let envd = env.map(p => (p.at(0) - sh.at(0), p.at(1) - sh.at(1)))
  for i in range(envd.len() - 1) { let a = envd.at(i); let b = envd.at(i + 1); let (dx, dy) = (b.at(0) - a.at(0), b.at(1) - a.at(1)); let (t0, t1) = (0.0, 1.0); let bad = false
    for (pp, qq) in ((-dx, a.at(0) - x0), (dx, x1 - a.at(0)), (-dy, a.at(1) - y0), (dy, y1 - a.at(1))) { if pp == 0 { if qq < 0 { bad = true } } else { let r = qq / pp; if pp < 0 { t0 = calc.max(t0, r) } else { t1 = calc.min(t1, r) } } }
    if not bad and t0 < t1 { line(q((a.at(0) + t0 * dx, a.at(1) + t0 * dy)), q((a.at(0) + t1 * dx, a.at(1) + t1 * dy)), stroke: (paint: accent, thickness: 0.8pt, dash: "dashed")) } }
  T((13.45, 0.6), [deed setback line], size: 3.6pt, fill: accent, angle: -62deg)
  if gf { R((x0, 0, XW, 6.5), fill: luma(236), stroke: 0.5pt + luma(170)); T((8.72, 3.3), [women's majlis], size: 4pt, fill: gray, angle: 90deg) }
  else { R((x0, 3.0, XW, 6.5), fill: luma(236), stroke: 0.5pt + luma(170)); T((8.72, 4.75), [family living], size: 4pt, fill: gray, angle: 90deg); R((x0, 0, XW, 3.0), fill: luma(236), stroke: 0.5pt + luma(170)); T((8.72, 1.5), [kids' room], size: 4pt, fill: gray, angle: 90deg) }
  let col(k) = if k == "wet" { rgb("#cfe6ef") } else if k == "maid" { rgb("#e4e9d6") } else if k == "laundry" { rgb("#dfe3e6") } else if k == "kitchen" { rgb("#d9e6ec") } else if k == "store" { rgb("#e6e1d6") } else if k == "bed" { rgb("#f6e3c0") } else if k == "circ" { rgb("#f2efe8") } else { luma(236) }
  for (n, P, k) in rooms { let b = bbox(P); let strokec = if k.ends-with("g") { (paint: luma(170), thickness: 0.5pt) } else { 0.9pt + ink }
    if P.len() == 4 { R(b, fill: col(k), stroke: strokec) } else { line(..P.map(q), close: true, fill: col(k), stroke: strokec) } }
  let outline = ((XW, 0),); yprev = 0; for (x, y) in steps { outline.push((x, yprev)); outline.push((x, y)); yprev = y }; outline += ((XE, yprev), (XE, 8.5))
  line(..outline.map(q), stroke: 2.2pt + ink)
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
    let at = if n == "Maid room" { if sc.col == "T" { (10.3, 3.3) } else { (9.9, 4.1) } } else if n == "Bedroom 1" { (12.2, 4.75) } else if n == "Laundry" { (11.6, if sc.col == "A" { 5.55 } else { 5.2 }) } else if n == "Kitchen" { (11.1, 7.2) } else if n == "Maid bath" { if sc.col == "T" { (9.75, 1.35) } else { (12.5, if sc.col == "A" { 4.9 } else { 4.5 }) } } else if n == "Maid's built-in wardrobe" { (12.5, 4.1) } else if n == "Bedroom 1 bath F20" { (12.4, 6.75) } else if n == "Family link" { (9.55, 5.9) } else if n == "Suite WC (closet)" { (10.9, 7.6) } else if n == "Suite lobby" { (9.6, 8.0) } else { (11.7, 8.35) }
    if k.ends-with("g") { T(at, [#n], size: 3.8pt, fill: gray) } else if P.len() == 4 { T(at, [*#n*\ #r2(cw(c)) × #r2(cd(c)) · #r2(area(c)) m²], size: if n.contains("wardrobe") { 3.4pt } else { 4.0pt }) } else { T(at, [*#n*\ #r2(area(c)) m² clear], size: 4.0pt) }
  }
  let r = st(sc); let xa = steps.first().at(0); let last = steps.last()
  T((xa + 0.3, -0.25), [north corner: deed #r2(deed-dist((xa + 0.125 + sh.at(0), -0.125 + sh.at(1)))) · built #r2(lane-dist((xa + 0.125 + sh.at(0), -0.125 + sh.at(1))) - built-offset - setback-built)], size: 3.4pt, fill: accent, anchor: "west")
  if steps.len() > 1 { let (xb, yb) = steps.at(1); let ya = steps.first().at(1); T((xb + 0.3, ya - 0.25), [middle corner: deed #r2(deed-dist((xb + 0.125 + sh.at(0), ya - 0.125 + sh.at(1)))) · built #r2(lane-dist((xb + 0.125 + sh.at(0), ya - 0.125 + sh.at(1))) - built-offset - setback-built)], size: 3.4pt, fill: accent, anchor: "west") }
  T((13.3, last.at(1) - 0.45), [east corner: deed #r2(deed-dist((XE + 0.125 + sh.at(0), last.at(1) - 0.125 + sh.at(1)))) · built #r2(lane-dist((XE + 0.125 + sh.at(0), last.at(1) - 0.125 + sh.at(1))) - built-offset - setback-built)], size: 3.4pt, fill: accent, anchor: "east")
  yprev = 0; for (x, y) in steps { T((x - 0.1, (yprev + y) / 2), [x #r2(x)], size: 3.5pt, fill: ink, angle: 90deg); T((x + (XE - x) / 2, y + 0.15), [y #r2(y)], size: 3.5pt, fill: ink); yprev = y }
  T((x0 + 0.15, y0 + 0.5), if gf { [GROUND FLOOR · the maid's wing, the laundry, the kitchen] } else { [FIRST FLOOR · bedroom 1, F20, the link, the suite's closet] }, size: 5.6pt, fill: accent, anchor: "west")
  line(q((x0 + 0.2, 8.3)), q((x0 + 1.2, 8.3)), stroke: 1pt + ink); T((x0 + 0.7, 8.15), [1 m], size: 3.6pt)
})
#let page-of(sc, oks, body) = {
  let r = st(sc)
  text(11.5pt, weight: "bold", fill: accent)[#sc.name · B1 #r2(r.b1) m from M1] + h(1fr) + text(6.2pt, fill: gray)[study · 1 : 50 · CSV frame, north up · today's slant dashed red · the corner given up hatched]
  v(1pt); line(length: 100%, stroke: 0.6pt + accent)
  grid(columns: (auto, auto, 1fr), column-gutter: 8pt, plan(sc, gf: true), plan(sc, gf: false), [
    #set text(6.6pt)
    #body
    #block(fill: if sc.col == "A" { rgb("#fbe3dd") } else if sc.col == "B" { rgb("#fdf0d8") } else { rgb("#e4eedf") }, inset: 4pt, radius: 2pt, width: 100%, text(6.6pt, weight: "bold")[#sc.verdict])
    #text(6.2pt, fill: gray)[Quick checks: #if oks.all(v => v) [passed (4): furniture inside the clear rooms, no overlaps; the door swings clear; both margins ≥ today's.] else [FAILED: #oks.enumerate().filter(((i, v)) => not v).map(((i, v)) => str(i + 1)).join(", ")]]
  ])
}
#let one-step-body(sc) = { let r = st(sc); let ff = rooms-ff(sc); let (XS, YS) = sc.steps.first(); [
    *The limits with the house #r2(sc.s) m south.* Every outer face sampled at 5 cm: the north corner may go to x #r2(if sc.col == "A" { 10.85 } else { 11.1 }) (the wall-as-built reading), the east corner must stay south of y #r2(if sc.col == "A" { 3.7 } else { 3.2 }) (the lane notch). Chosen: *x #r2(XS), y #r2(YS)* #if sc.col == "B" [(y 3.2 is the maid bath's partition line today; x 11.1 becomes the bath's west wall)] else [(no existing line fits: the bath line y 3.2 fails by 0.4 m)]. The corner given up #r2(XE - XS) × #r2(YS) = #r2(lost(sc.steps)) m² per floor against the slant's #r2(lost-today): *#if lost(sc.steps) > lost-today [−#r2(lost(sc.steps) - lost-today)] else [+#r2(lost-today - lost(sc.steps))] m² per floor.* Margins: deed #r2(r.deed) m (today #r2(today.deed)), wall as built #r2(r.built) m (today #r2(today.built)).

    *Ground floor.* #if sc.col == "A" [The maid room x 8.95–10.85 (#r2(area(clear-of(sc, sc.gf.at(0)))) m² clear, 1.68 m wide); the maid bath east of it must be 1.5 m deep (y 3.7–5.2), so *the laundry is squeezed to 1.3 m on axes (1.10 m clear, the passage in front of the machines 0.50 m)*: not workable; the alternative is the laundry in the kitchen's north band, which is what the owner refused.] else [The maid room a clean rectangle x 8.95–11.1 (#r2(area(clear-of(sc, sc.gf.at(0)))) m² clear, *1.95 m wide: under the 2.10 m rule*; the bed on the north wall, the wardrobe on the majlis wall, the desk at the escape casement on the step's face); the maid bath a clean rectangle x 11.1–13.311 × y 3.2–4.7 (#r2(area(clear-of(sc, sc.gf.at(1)))) m² clear); *the laundry and the kitchen exactly as today.*]

    *First floor.* Bedroom 1 keeps its footprint with the slant replaced by the step (orthogonal walls, one re-entrant corner; its bath F20, both built-in wardrobes, the bed and its door from the link in place): *#r2(area(clear-of(sc, ff.at(0), gf: false))) m² clear* (today 15.70); #if sc.col == "A" [the desk moves 0.1 m east and loses its chair's place; the nightstand goes.] else [the desk, its chair and the nightstand as today.] The escape casement moves from the cut to the step's east face (x #r2(XS), y 1.4–2.4). F20, the link, the suite's WC closet and the suite bath untouched (M3 as adopted).

    *Structure.* Three corner columns replace the three on the cut: C30′ (#r2(XS), 0), C31′ (#r2(XS), #r2(YS)) at the re-entrant corner, C32′ (13.311, #r2(YS)); *C33′ new* at (13.311, 6.5) on the structural line y 6.5 keeps the east wall's spans at #r2(6.5 - YS) + 3.95 m; the RC cut wall W4 becomes two orthogonal RC walls #r2(YS) + #r2(XE - XS) m with beams on the step's lines at each slab; the maid bath's walls are 100 mm partitions on the slab.

    *The site.* B1 #r2(r.b1) m from M1 (today 6.00); the north strip for the car #r2(r.strip) m deep at B1 (today #r2(today.strip): *+#r2(sc.s) m*); the palms: T1 #r2(r.palm1) m from the east wall (unchanged), T2 #r2(r.palm2) m from the south-east corner (today #r2(today.palm2)).
] }
#let two-step-body(sc) = { let r = st(sc); let ff = rooms-ff(sc); let ((xa, ya), (xb, yb)) = sc.steps; [
    *Two steps hug the slant.* With the house #r2(sc.s) m south the limits are: the north corner x ≤ 10.86, the middle corner x ≤ 11.71 at y 1.75 (the lane line runs south-east, so the second face may stand 0.85 m further east), the east corner y ≥ 3.66. Chosen: *(#r2(xa), #r2(ya)) and (#r2(xb), #r2(yb))*. The corner given up #r2(XE - xa) × #r2(ya) + #r2(XE - xb) × #r2(yb - ya) = #r2(lost(sc.steps)) m² per floor against the slant's #r2(lost-today): *#if lost(sc.steps) > lost-today [−#r2(lost(sc.steps) - lost-today)] else [+#r2(lost-today - lost(sc.steps))] m² per floor* (the one step at 0.5 m lost 1.63). Margins: deed #r2(r.deed) m (today #r2(today.deed)), wall as built #r2(r.built) m (today #r2(today.built)). None of the four lines is an existing wall: the bath partition y 3.2 is 0.5 m short of the notch's limit and no first-floor wall lies in the corner.

    *Ground floor.* The north strip x 8.95–#r2(xa) × y 0–#r2(ya) is the *maid bath* (#r2(area(clear-of(sc, sc.gf.at(0)))) m² clear, #r2(cw(clear-of(sc, sc.gf.at(0)))) × #r2(cd(clear-of(sc, sc.gf.at(0)))): the WC on the majlis wall, the basin under a high window on the north wall, the wall shower over a floor drain in the east corner, its 0.70 door from her room); the *maid room* a clean rectangle x 8.95–#r2(xb) × y #r2(ya)–4.7 (*#r2(area(clear-of(sc, sc.gf.at(1)))) m² clear, #r2(cw(clear-of(sc, sc.gf.at(1)))) m wide*: ≥ 2.10 and ≥ 6.5 ✓; the bed on the majlis wall, the desk at the escape casement on the second step's face, its 0.90 door from the laundry); the *middle piece* x #r2(xb)–13.311 × y #r2(yb)–4.7 is the *maid's built-in wardrobe* (#r2(cw(clear-of(sc, sc.gf.at(2)))) × #r2(cd(clear-of(sc, sc.gf.at(2)))) clear, sliding doors on the room's east wall): useful, no sliver. *The laundry and the kitchen exactly as today.*

    *First floor.* Bedroom 1 keeps its footprint with the slant replaced by the two steps (orthogonal walls, two re-entrant corners; F20, both built-in wardrobes, the bed, the desk and its door from the link in place; the chair 0.2 m west): *#r2(area(clear-of(sc, ff.at(0), gf: false))) m² clear* (today 15.70). The escape casement on the second step's face (x #r2(xb), y 2.2–3.2). F20, the link, the suite's WC closet and the suite bath untouched (M3 as adopted).

    *Structure.* Five corner columns replace the three on the cut (C30′ (#r2(xa), 0), C31′ (#r2(xa), #r2(ya)), C32′ (#r2(xb), #r2(ya)), C33′ (#r2(xb), #r2(yb)), C34′ (13.311, #r2(yb))) and *C35′ new* at (13.311, 6.5) keeps the east wall's spans at #r2(6.5 - yb) + 3.95 m; the RC cut wall W4 becomes four short orthogonal RC walls (#r2(ya) + #r2(xb - xa) + #r2(yb - ya) + #r2(XE - xb) = #r2(ya + xb - xa + yb - ya + XE - xb) m) with beams on the steps' lines at each slab; two more columns and two more corners than the one step, all short spans; the maid bath's and the wardrobe's walls 100 mm partitions on the slab.

    *The site.* B1 #r2(r.b1) m from M1 (today 6.00); the north strip for the car #r2(r.strip) m deep at B1 (today #r2(today.strip): *+#r2(sc.s) m*); the palms: T1 #r2(r.palm1) m from the east wall (unchanged), T2 #r2(r.palm2) m from the south-east corner (today #r2(today.palm2)).
] }
#page-of(scen-A, ok-A, one-step-body(scen-A))
#pagebreak()
#page-of(scen-B, ok-B, one-step-body(scen-B))
#pagebreak()
#page-of(scen-T, ok-T, two-step-body(scen-T))

// ======================= PAGE 4 · the tables =======================
#pagebreak()
#text(11.5pt, weight: "bold", fill: accent)[Every option · the rooms (clear m²), the corner, the structure, the site · the municipal check on the maid room (≥ 2.10 m clear wide, ≥ 6.5 m²)] #h(1fr) #text(6.4pt, fill: gray)[clear = inside the walls as drawn (0.125 outer, 0.10 inner, 0.05 partitions) · today = the schedule of 17 Nov 2026 · the goal: nothing from the kitchen, bedroom 1 (≈ 15.7 with F20), the closet]
#v(1pt) #line(length: 100%, stroke: 0.6pt + accent)
#v(2pt)
#set text(6.3pt)
#let wdc(c) = r2(cw(c)) + " × " + r2(cd(c))
#let maid-ok(c) = calc.min(cw(c), cd(c)) >= 2.10 - 1e-6 and area(c) >= 6.5 - 1e-6
#let chk(v) = if v { text(fill: accent)[✓] } else { text(fill: red)[✗] }
#table(columns: (0.35fr, 2.1fr, 1.25fr, 0.95fr, 0.9fr, 0.9fr, 1.05fr, 1.0fr, 1.6fr), stroke: 0.3pt + luma(190), inset: 2.6pt, align: left, fill: (_, y) => if y == 0 { rgb("#e1e9e3") } else if calc.even(y) { rgb("#efece4") },
  table.header([*No.*], [*Option*], [*Maid room* (w × d) · check], [*Maid bath*], [*Laundry*], [*Kitchen*], [*Bedroom 1* · F20 · closet], [*Corner given up* / floor (Δ vs the slant)], [*Verdict*]),
  [1], [Today: the slant (B1 6.00 m)], [8.85 (L-shaped) · 2.49 at the bed #chk(true)], [2.50 (sloped)], [6.75], [26.06], [15.70 · 3.49 en-suite · 1.30], [7.47 (—)], [—],
  [2], [ONE step · today's position (fe5612d: 10.55, 4.20; its own layout)], [*8.58* (4.14 × 2.08) #chk(false)], [2.41 (1.38 × 1.75) plus an outdoor store 2.92], [6.82 (moved to y 6.5–8.3)], [#text(fill: red)[18.82 (−7.24)]], [#text(fill: red)[*10.50*] (−5.20) · 5.47 from the link · gone], [11.60 (−4.12)], [bedroom 1 a rectangle without its en-suite; the closet gone; the kitchen 1.8 m shorter; the maid room 2.08 deep (< 2.10)],
  ..O.slice(1).map(o => ([#o.id], [#o.label], [*#r2(area(o.maid))* (#wdc(o.maid)) #chk(maid-ok(o.maid))], [#if o.bath == none [—] else [#r2(area(o.bath)) (#wdc(o.bath))] #o.extra], [#if area(o.laun) < 6.5 { text(fill: red)[#r2(area(o.laun)) (#wdc(o.laun))] } else [#r2(area(o.laun))]], [#if area(o.kit) < 26.0 { text(fill: red)[#r2(area(o.kit)) (−#r2(26.06 - area(o.kit)))] } else [26.06]],
    [#if o.bed1 < 15.4 { text(fill: red)[*#r2(o.bed1)*] } else [*#r2(o.bed1)*] (#if o.bed1 >= 15.70 [+]#r2(o.bed1 - 15.70)) · 3.49 · 1.30], [#r2(o.lost) (#if o.lost > lost-today [−#r2(o.lost - lost-today)] else [+#r2(lost-today - o.lost)])], [#o.note])).flatten(),
)
#v(3pt)
#table(columns: (0.35fr, 1.5fr, 2.6fr, 0.8fr, 0.8fr, 0.6fr, 0.95fr, 0.95fr), stroke: 0.3pt + luma(190), inset: 2.6pt, align: left, fill: (_, y) => if y == 0 { rgb("#e1e9e3") } else if calc.even(y) { rgb("#efece4") },
  table.header([*No.*], [*Option*], [*Columns at the corner · RC walls*], [*Margin · deed line*], [*Margin · wall as built*], [*B1 from M1*], [*Palms T1 · T2*], [*North strip at B1*]),
  [1], [Today: the slant], [C30 (10.461, 0) · C31 (11.982, 2.8) · C32 (13.311, 5.245); the RC cut wall W4 6.0 m], [#r2(today.deed) m (the notch)], [#r2(today.built) m], [6.00 m], [#r2(today.palm1) · #r2(today.palm2)], [#r2(today.strip) m],
  ..O.map(o => ([#o.id], [#o.label], [#o.cols], [#r2(o.r.deed) m], [#r2(o.r.built) m], [#r2(o.r.b1) m], [#r2(o.r.palm1) · #r2(o.r.palm2)], [#r2(o.r.strip) m (+#r2(o.s))])).flatten(),
)
#v(3pt)
#text(6.6pt)[*Reading the tables.* Bedroom 1 is counted within ≈ 0.3 m² of today's 15.70 (the two steps add two wall corners: −0.24). The one step needs 1.0 m south for the goal and 1.3 m south for the maid-room rule (row 6; at 1.0 m the room can only reach 2.10 m by pushing the laundry 0.55 m into the kitchen, row 5). *Two steps need only 0.5 m south* (row 8, page 3): the middle corner stands 0.85 m further east than the north one, so the corner given up equals the slant's, bedroom 1 keeps its area with F20 and the closet in place, the maid room is 2.53 m wide, and the middle piece is the maid's built-in wardrobe. At today's position (row 7) two steps still cost bedroom 1 1.4 m² and leave a 0.28 m sliver; 0.75 m south (row 9) gives more margin but is not needed. The price of two steps: two more columns and two more corners at the facade, all short spans.]
#v(2pt)
#ah[#text(7.6pt)[درجتان بدل الدرجة الواحدة: تحتضنان الحد المائل، فتكفي إزاحة *0.5 م جنوبًا* (B1 على #r2(O.at(6).r.b1) م من البوابة) بدل 1.0 م: الدرجتان عند (10.85، 1.75) و(11.70، 3.70) لا تأخذان شيئًا من المطبخ ولا من غرفة النوم 1 (#r2(O.at(6).bed1) م² مع حمامها F20 ودولابيها) ولا من غرفة مرحاض الجناح، والمساحة المفقودة في كل دور تساوي مساحة القطع المائل (#r2(O.at(6).lost) م²)؛ غرفة الخادمة مستطيل نظيف بعرض #r2(cw(O.at(6).maid)) م ومساحة #r2(area(O.at(6).maid)) م² (الشرط البلدي 2.10 م و6.5 م²)، وحمامها في الشريط الشمالي، والقطعة الوسطى دولاب مدمج لها لا فضلة؛ الهامشان #r2(O.at(6).r.deed) / #r2(O.at(6).r.built) م (اليوم #r2(today.deed) / #r2(today.built))، والشريط الشمالي للسيارة أعمق بنصف متر. الثمن: عمودان وزاويتان أكثر في الواجهة. أما الدرجة الواحدة فتحتاج 1.0 م للهدف و1.3 م لشرط غرفة الخادمة (2.10 م)، وعند 1.0 م لا يتحقق الشرط إلا بأخذ 0.55 م من المطبخ.]]

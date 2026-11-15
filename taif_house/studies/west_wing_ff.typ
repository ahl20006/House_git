// west_wing_ff.typ · Taif / Palm House · STUDY (reset, 15 Nov 2026, the owner's base): the first-floor WEST BAND, bedrooms 2 and 3 with their baths BACK TO BACK, ONE option.
// The gym exactly as today (its wall on y 19.25 on the beams B22 + B8, its nib, its doors; nothing in the gym, the gallery's end or the suite court changes).
// X3: the two baths back to back between the bedrooms (the pair 1.4 m deep; bath 2 west with a window, bath 3 east with a fan; one shared wet wall x 2.10; both WCs at its south end so the
// stack lands in the GF powder room's WC compartment), re-centred so the two bedrooms are equal. Bedroom 2's entry: the strip beside the shaft (x 1.5–4.25, y 9.2–10.4), its door on the gallery
// facing the shaft; no store. Bedroom 3's door on the gallery, simple. Straight walls, no jogs. The earlier revisions (W, X, G, N, L, R) are in the git history only.
// Nothing in the design files is changed. Fixed (studies/ff_family.typ, studies/ff_suite.typ): the band x 0–4.25 (axes), y 9.2–19.25; the west shaft x 0–1.5 × y 9.2–10.4; the family WC
// north of y 9.2; the gallery east of x 4.25; the west outer wall. CSV frame: x east, y south, wall centre lines; the outer wall 0.25, every other wall 0.20.
#import "@preview/cetz:0.4.2"
#import "../base.typ": dist

#set page(paper: "a4", flipped: true, margin: 8mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 7.4pt)
#set par(leading: 0.42em)
#let ink = rgb("#3d4a45"); #let accent = rgb("#2f6b4f"); #let red = rgb("#b5452f"); #let blue = rgb("#2f5f8a"); #let gray = rgb("#6d736f"); #let brown = rgb("#8a5a2b")
#let r2(v) = { let s = str(calc.round(v, digits: 2)); if not s.contains(".") { s + ".00" } else if s.split(".").at(1).len() == 1 { s + "0" } else { s } }
#let ah(t) = text(font: ("Segoe UI", "Arial", "Tahoma"), lang: "ar", dir: rtl, t)
#let rect-pts(x0, y0, x1, y1) = ((x0, y0), (x1, y0), (x1, y1), (x0, y1))

// ---------- geometry ----------
#let X1 = 4.25; #let Y0 = 9.2; #let YG = 19.25; #let xw = 2.1; #let D = 1.4
#let yb = 13.75; #let ys = yb + D                         // the bath pair y 13.75–15.15: bedroom 2 = 4.025 (yb − 10.6) + 3.06 and bedroom 3 = 4.025 (19.05 − ys) match within 0.05 m²
#let shaft = rect-pts(0, 9.2, 1.5, 10.4)
#let strip = rect-pts(1.5, 9.2, X1, 10.4)                 // bedroom 2's entry (kept clear)
#let rooms = (
  ("Bedroom 2", ((1.5, 9.2), (X1, 9.2), (X1, yb), (0, yb), (0, 10.4), (1.5, 10.4)), "bed"),
  ("Bedroom 2 bath", rect-pts(0, yb, xw, ys), "wet"), ("Bedroom 3 bath", rect-pts(xw, yb, X1, ys), "wet"),
  ("Bedroom 3", rect-pts(0, ys, X1, YG), "bed"),
)
#let furniture = (   // (x0, y0, x1, y1, label, room)
  (0.125, 10.55, 2.125, 11.95, [bed 1.4 × 2.0], "Bedroom 2"), (0.125, 12.0, 0.525, 12.4, [], "Bedroom 2"), (2.15, 10.55, 2.55, 10.95, [], "Bedroom 2"),
  (0.125, yb - 1.0, 0.725, yb - 0.1, [desk 0.9 × 0.6], "Bedroom 2"), (0.8, yb - 0.85, 1.25, yb - 0.4, [], "Bedroom 2"), (2.0, yb - 0.7, 3.8, yb - 0.1, [wardrobe 1.8 × 0.6], "Bedroom 2"),
  (0.125, ys + 0.6, 2.125, ys + 2.0, [bed 1.4 × 2.0], "Bedroom 3"), (0.125, ys + 0.15, 0.525, ys + 0.55, [], "Bedroom 3"), (0.125, ys + 2.05, 0.525, ys + 2.45, [], "Bedroom 3"),
  (0.125, 18.0, 0.725, 19.1, [desk 1.1 × 0.6], "Bedroom 3"), (0.8, 18.3, 1.25, 18.75, [], "Bedroom 3"), (3.55, 17.3, 4.15, 19.1, [wardrobe 1.8 × 0.6], "Bedroom 3"),
)
#let fixtures = (
  (0.125, yb + 0.1, 0.925, yb + 0.9, [shower 0.8 × 0.8 · screen], "Bedroom 2 bath"), (0.125, ys - 0.5, 0.475, ys - 0.1, [basin], "Bedroom 2 bath"), (1.4, ys - 0.5, 2.0, ys - 0.1, [WC], "Bedroom 2 bath"),
  (2.2, yb + 0.1, 3.0, yb + 0.9, [shower 0.8 × 0.8 · screen], "Bedroom 3 bath"), (2.2, ys - 0.5, 2.8, ys - 0.1, [WC], "Bedroom 3 bath"), (3.8, yb + 0.3, 4.15, yb + 0.7, [basin], "Bedroom 3 bath"),
)
#let doors = (   // (a, b, into, label, room)
  ((X1, 9.35), (X1, 10.25), (-1, 0), [bedroom 2 door 0.90, from the gallery, in the entry strip facing the shaft], "Bedroom 2"),
  ((1.2, yb), (1.9, yb), (0, 1), [bath 2 door 0.70, from bedroom 2], "Bedroom 2 bath"),
  ((3.0, ys), (3.7, ys), (0, -1), [bath 3 door 0.70, from bedroom 3], "Bedroom 3 bath"),
  ((X1, ys + 0.3), (X1, ys + 1.2), (-1, 0), [bedroom 3 door 0.90, from the gallery], "Bedroom 3"),
)
#let windows = (((0, 10.7), (0, 11.8)), ((0, yb - 1.0), (0, yb - 0.2)), ((0, yb + 0.15), (0, yb + 0.85)), ((0, ys + 0.7), (0, ys + 1.9)), ((0, 18.1), (0, 19.0)))   // provisional marks
#let stack = (xw, ys - 0.3)
#let gf-compartment = rect-pts(0, 14.55, 2.75, 16.1)      // the GF powder room's WC compartment (its 100 mm partition on y 14.55)
#let gf-lines-y = (10.4, 12.9, 16.1, 17.5)                // the GF walls across the band
#let today = (("Bedroom 2 bath", ((1.5, 9.2), (4.25, 9.2), (4.25, 11.0), (0, 11.0), (0, 10.4), (1.5, 10.4))), ("Bedroom 2", rect-pts(0, 11.0, 4.25, 14.4)), ("Bedroom 3 bath", rect-pts(0, 14.4, 2.2, 16.1)), ("Bedroom 3", ((2.2, 14.4), (4.25, 14.4), (4.25, 19.25), (0, 19.25), (0, 16.1), (2.2, 16.1))))
#let today-obs = ("Bedroom 2": ((3.55, 12.2, 4.15, 14.2), (3.25, 11.1, 4.25, 12.1)), "Bedroom 3": ((2.2, 14.4, 4.25, 16.1), (2.3, 14.5, 3.35, 15.1), (3.55, 16.3, 4.15, 17.9), (3.25, 15.2, 4.25, 16.2)))   // today's wardrobes, door swings and bedroom 3's entry part

// ---------- helpers ----------
#let area(P) = calc.abs(range(P.len()).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, P.len())); a.at(0) * b.at(1) - b.at(0) * a.at(1) }).sum()) / 2
#let inset(P, d) = {
  let n = P.len()
  let lines = range(n).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, n)); let (dx, dy) = (b.at(0) - a.at(0), b.at(1) - a.at(1)); let L = calc.sqrt(dx * dx + dy * dy); ((a.at(0) - dy / L * d.at(i), a.at(1) + dx / L * d.at(i)), (dx, dy)) })
  range(n).map(i => { let (p1, v1) = lines.at(calc.rem(i + n - 1, n)); let (p2, v2) = lines.at(i); let den = v1.at(0) * v2.at(1) - v1.at(1) * v2.at(0); let t = ((p2.at(0) - p1.at(0)) * v2.at(1) - (p2.at(1) - p1.at(1)) * v2.at(0)) / den; (p1.at(0) + v1.at(0) * t, p1.at(1) + v1.at(1) * t) })
}
#let is-cw(P) = range(P.len()).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, P.len())); a.at(0) * b.at(1) - b.at(0) * a.at(1) }).sum() > 0
#let cw(P) = if is-cw(P) { P } else { P.rev() }
#let half(a, b) = if calc.abs(a.at(0)) < 1e-6 and calc.abs(b.at(0)) < 1e-6 { 0.125 } else { 0.10 }
#let clear-poly(P) = { let Q = cw(P); inset(Q, range(Q.len()).map(i => half(Q.at(i), Q.at(calc.rem(i + 1, Q.len()))))) }
#let clear(P) = area(clear-poly(P))
#let bbox(P) = (calc.min(..P.map(p => p.at(0))), calc.min(..P.map(p => p.at(1))), calc.max(..P.map(p => p.at(0))), calc.max(..P.map(p => p.at(1))))
#let inside(p, P) = { let c = false; let n = P.len(); for i in range(n) { let (xi, yi) = P.at(i); let (xj, yj) = P.at(calc.rem(i + n - 1, n)); if ((yi > p.at(1)) != (yj > p.at(1))) and (p.at(0) < (xj - xi) * (p.at(1) - yi) / (yj - yi) + xi) { c = not c } }; c }
#let overlap(a, b) = not (a.at(2) <= b.at(0) + 1e-9 or b.at(2) <= a.at(0) + 1e-9 or a.at(3) <= b.at(1) + 1e-9 or b.at(3) <= a.at(1) + 1e-9)
#let bx(f) = (f.at(0), f.at(1), f.at(2), f.at(3))
#let swing-box(d) = { let (a, b, dir) = (d.at(0), d.at(1), d.at(2)); let w = dist(a, b); let (x0, x1, y0, y1) = (calc.min(a.at(0), b.at(0)), calc.max(a.at(0), b.at(0)), calc.min(a.at(1), b.at(1)), calc.max(a.at(1), b.at(1)))
  if dir.at(1) < 0 { (x0, y0 - w, x1, y0) } else if dir.at(1) > 0 { (x0, y0, x1, y0 + w) } else if dir.at(0) > 0 { (x0, y0, x0 + w, y1) } else { (x0 - w, y0, x0, y1) } }
#let uniq(v) = { let out = (); for x in v.sorted() { if out.len() == 0 or x - out.last() > 1e-6 { out.push(x) } }; out }
#let rect-in(r, Q) = { let e = 0.002; ((r.at(0) + e, r.at(1) + e), (r.at(2) - e, r.at(1) + e), (r.at(2) - e, r.at(3) - e), (r.at(0) + e, r.at(3) - e), ((r.at(0) + r.at(2)) / 2, (r.at(1) + r.at(3)) / 2)).all(p => inside(p, Q)) and Q.all(v => not (v.at(0) > r.at(0) + e and v.at(0) < r.at(2) - e and v.at(1) > r.at(1) + e and v.at(1) < r.at(3) - e)) }
// the PURE CLEAR RECTANGLE: the largest axis-aligned rectangle inside the room's clear outline that avoids the obstacles (the entry strip, the door's swing square, the shaft / steps = the outline, the wardrobe)
#let pure-rect(P, obs) = {
  let Q = clear-poly(P); let b = bbox(Q)
  let xs = uniq((Q.map(p => p.at(0)) + obs.map(o => o.at(0)) + obs.map(o => o.at(2))).filter(x => x >= b.at(0) - 1e-6 and x <= b.at(2) + 1e-6))
  let ys = uniq((Q.map(p => p.at(1)) + obs.map(o => o.at(1)) + obs.map(o => o.at(3))).filter(y => y >= b.at(1) - 1e-6 and y <= b.at(3) + 1e-6))
  let best = (0.0, none)
  for i in range(xs.len()) { for j in range(i + 1, xs.len()) { for k in range(ys.len()) { for l in range(k + 1, ys.len()) {
    let r = (xs.at(i), ys.at(k), xs.at(j), ys.at(l)); let a = (r.at(2) - r.at(0)) * (r.at(3) - r.at(1))
    if a > best.at(0) + 1e-9 and obs.all(o => not overlap(r, o)) and rect-in(r, Q) { best = (a, r) }
  } } } }
  best
}
#let P-of(n) = rooms.find(r => r.at(0) == n).at(1)
#let T-of(n) = today.find(r => r.at(0) == n).at(1)
#let obs-of(n) = (if n == "Bedroom 2" { (bbox(strip),) } else { () }) + doors.filter(d => d.at(4) == n).map(swing-box) + furniture.filter(f => f.at(5) == n and repr(f.at(4)).contains("wardrobe")).map(bx)
#let pure = ("Bedroom 2": pure-rect(P-of("Bedroom 2"), obs-of("Bedroom 2")), "Bedroom 3": pure-rect(P-of("Bedroom 3"), obs-of("Bedroom 3")))
#let pure-today = ("Bedroom 2": pure-rect(T-of("Bedroom 2"), today-obs.at("Bedroom 2")), "Bedroom 3": pure-rect(T-of("Bedroom 3"), today-obs.at("Bedroom 3")))
#let ptxt(p) = { let (a, r) = p; [#r2(r.at(2) - r.at(0)) × #r2(r.at(3) - r.at(1)) = *#r2(a)*] }
#let hatch = tiling(size: (3pt, 3pt))[#place(line(start: (0pt, 3pt), end: (3pt, 0pt), stroke: 0.35pt + accent))]
// quick checks: the rooms tile the band with the shaft; fixtures and furniture inside, no overlaps; the door swings clear; the bedrooms equal; the stack in the GF compartment
#let box-in(b, P) = { let e = 0.001; ((b.at(0) + e, b.at(1) + e), (b.at(2) - e, b.at(1) + e), (b.at(2) - e, b.at(3) - e), (b.at(0) + e, b.at(3) - e)).all(p => inside(p, P)) }
#let no-overlaps(L) = range(L.len()).all(i => range(L.len()).all(j => i == j or not overlap(L.at(i), L.at(j))))
#let ok = (
  calc.abs(area(rect-pts(0, Y0, X1, YG)) - area(shaft) - rooms.map(r => area(r.at(1))).sum()) < 0.01,
  (furniture + fixtures).all(f => box-in(bx(f), P-of(f.at(5)))) and no-overlaps(furniture.map(bx)) and no-overlaps(fixtures.map(bx)) and furniture.map(bx).all(b => not overlap(b, bbox(strip))),
  doors.map(swing-box).all(s => (furniture + fixtures).map(bx).all(b => not overlap(s, b))),
  calc.abs(clear(P-of("Bedroom 2")) - clear(P-of("Bedroom 3"))) <= 0.3,
  inside(stack, gf-compartment),
)
#let all-ok = ok.all(v => v)

// ======================= PAGE 1 · the plan =======================
#text(13pt, weight: "bold", fill: accent)[First-floor west band · bedrooms 2 and 3 with their baths back to back · the owner's base (15 Nov 2026)] #h(1fr) #text(6.8pt, fill: gray)[study · nothing in the design files changed · 1 : 100 (1.0 cm / m, as sheet 04) · CSV frame, north up · m² on axes · ≈ clear]
#v(1pt) #line(length: 100%, stroke: 0.6pt + accent)
#let q(p) = (p.at(0), -p.at(1))
#grid(columns: (auto, 1fr), column-gutter: 16pt,
  cetz.canvas(length: 1.0cm, {
    import cetz.draw: *
    let T(p, body, size: 4.4pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, body))
    let poly(P, fill: none, stroke: none) = line(..P.map(q), close: true, fill: fill, stroke: stroke)
    let R(b, fill: none, stroke: none) = rect(q((b.at(0), b.at(1))), q((b.at(2), b.at(3))), fill: fill, stroke: stroke)
    rect(q((-0.7, 7.5)), q((6.2, 20.9)), fill: rgb("#f3efe6"), stroke: none)
    for x in range(0, 6) { line(q((x, 7.7)), q((x, 20.7)), stroke: 0.2pt + luma(220)); T((x, 7.55), str(x), size: 3.6pt, fill: gray) }
    for y in range(8, 21) { line(q((-0.3, y)), q((6.0, y)), stroke: 0.2pt + luma(220)); T((-0.45, y), str(y), size: 3.6pt, fill: gray, anchor: "east") }
    poly(gf-compartment, fill: rgb("#f0d9c0").transparentize(60%), stroke: (paint: brown, dash: "dotted", thickness: 0.5pt)); T((1.4, 14.42), [GF powder room's WC compartment below (y 14.55–16.1)], size: 3pt, fill: brown)
    for y in gf-lines-y { line(q((-0.6, y)), q((-0.35, y)), stroke: 1pt + brown); T((-0.62, y), [GF], size: 3pt, fill: brown, anchor: "east") }
    rect(q((0, 7.9)), q((2.75, 9.2)), fill: luma(236), stroke: 0.8pt + ink); T((1.4, 8.55), [family WC], size: 4pt, fill: gray)
    rect(q((2.75, 7.9)), q((4.25, 9.2)), fill: rgb("#f2efe8"), stroke: 0.8pt + ink)
    rect(q((4.25, 7.9)), q((5.8, 19.25)), fill: rgb("#f2efe8"), stroke: 0.8pt + ink); T((5.02, 13.5), [gallery (on the projection) · 1.55 · as today], size: 4pt, fill: gray, angle: 90deg)
    rect(q((0, 19.25)), q((4.25, 20.9)), fill: rgb("#d9e4f2"), stroke: 0.8pt + ink); rect(q((4.25, 19.25)), q((5.8, 20.55)), fill: rgb("#d9e4f2"), stroke: 0.8pt + ink)
    T((2.1, 19.85), [GYM exactly as today], size: 4.4pt, fill: gray); T((2.1, 20.2), [its wall on y 19.25 (the beams B22 + B8), its nib, its doors], size: 3.4pt, fill: gray); T((5.02, 19.9), [nib], size: 3.6pt, fill: gray)
    line(q((4.35, 19.25)), q((5.45, 19.25)), stroke: 1.6pt + red)
    for (n, P, k) in rooms { poly(P, fill: if k == "wet" { rgb("#cfe6ef") } else { rgb("#f6e3c0") }, stroke: 0.9pt + ink) }
    R(bbox(strip), fill: none, stroke: (paint: accent, thickness: 0.4pt, dash: "dotted")); T((2.9, 9.45), [entry strip · kept clear], size: 3.4pt, fill: accent)
    poly(shaft, fill: luma(205), stroke: 0.9pt + ink); T((0.75, 9.8), [west shaft], size: 4pt)
    line(q((0, 7.9)), q((0, 20.9)), stroke: 2pt + ink)
    line(q((xw, yb)), q((xw, ys)), stroke: 2.4pt + blue)
    for (x0, y0, x1, y1, l, rm) in furniture { R((x0, y0, x1, y1), fill: rgb("#fbf6ea"), stroke: 0.45pt + rgb("#8a7a5a")); T(((x0 + x1) / 2, (y0 + y1) / 2), l, size: 3.4pt, angle: if (y1 - y0) > (x1 - x0) * 1.4 { 90deg } else { 0deg }) }
    for (x0, y0, x1, y1, l, rm) in fixtures { R((x0, y0, x1, y1), fill: white, stroke: 0.45pt + blue); T(((x0 + x1) / 2, (y0 + y1) / 2), l, size: 3.1pt, fill: blue, angle: if (y1 - y0) > (x1 - x0) * 1.4 { 90deg } else { 0deg }) }
    for d in doors { line(q(d.at(0)), q(d.at(1)), stroke: 3pt + red); R(swing-box(d), stroke: (paint: red, thickness: 0.35pt, dash: "dashed")) }
    for (a, b) in windows { line(q(a), q(b), stroke: (paint: blue, thickness: 2.2pt, dash: "dashed")) }
    circle(q(stack), radius: 0.14, fill: brown, stroke: none); T((stack.at(0) + 0.2, stack.at(1) + 0.22), [stack], size: 3.6pt, fill: brown, anchor: "west")
    for n in ("Bedroom 2", "Bedroom 3") { let (a, r) = pure.at(n); R(r, fill: hatch, stroke: (paint: accent, thickness: 0.7pt)); T((r.at(0) + 0.1, r.at(1) + 0.2), [PURE #r2(r.at(2) - r.at(0)) × #r2(r.at(3) - r.at(1)) = #r2(a) m²], size: 3.8pt, fill: accent, anchor: "west") }
    for (n, P, k) in rooms { let c = if n == "Bedroom 2" { (2.9, 12.5) } else if n == "Bedroom 3" { (2.5, 17.3) } else if n == "Bedroom 2 bath" { (1.35, yb + 1.0) } else { (3.3, ys - 0.85) }
      T(c, [*#n*\ #r2(area(P)) · ≈ #r2(clear(P))], size: if k == "wet" { 3.4pt } else { 4.6pt }) }
    line(q((0, 21.2)), q((1, 21.2)), stroke: 1pt + ink); T((0.5, 21.45), [1 m], size: 4pt)
  }),
  [
    #set text(7.4pt)
    *The option.* The gym exactly as today: its wall on y 19.25 on the beams B22 + B8, its entrance nib, its sliding door from the gallery's end and its court door; nothing in the gym, the gallery's end or the suite court changes. Between the two bedrooms the *X3 bath pair*, 1.4 m deep on axes (y #r2(yb)–#r2(ys)): bath 2 on the west with a small high window above its shower, bath 3 on the east by the gallery with an exhaust fan; one shared wet wall on x #r2(xw); both wall-hung WCs at its south end, the *stack* between them at (#r2(stack.at(0)), #r2(stack.at(1))), dropping straight into the GF powder room's WC compartment (#r2(stack.at(1) - 14.55) m south of its partition) and on to the buried west run; the showers' floor drains and the basins' wastes in the floor build-up, ≤ 2 m each. The pair is placed so that the two bedrooms are equal (#r2(clear(P-of("Bedroom 2"))) and #r2(clear(P-of("Bedroom 3"))) m² clear).

    *Bedroom 2:* its entry is the strip beside the shaft (x 1.5–4.25, y 9.2–10.4), the door 0.90 on the gallery inside it, facing the shaft's wall; no store. The bed's head on the west wall under its window, the desk at the second west window, the 1.8 m wardrobe on the bath wall east of the bath door; the bath door at the east end of the bath's north wall.

    *Bedroom 3:* its door 0.90 on the gallery, simple, beside the bath pair (y #r2(ys + 0.3)–#r2(ys + 1.2)); the bed's head on the west wall under its window, away from the gym's double wall; the desk at the south-west window; the 1.8 m wardrobe on the gallery wall south of the door; the bath door at the east part of the bath's south wall. No door faces a bed's head.

    *Walls.* Straight and orthogonal, no jogs: the pair's two cross walls (y #r2(yb), #r2(ys)) and the wet wall x #r2(xw) are 0.20 block partitions on the solid west slab, none on a GF wall (the GF walls across the band are y 10.4, 12.9, 16.1, 17.5); the wet wall carries the stack and the two WC frames mid-bay between the GF riwaq wall x 2.75 and the outer wall, for the engineer's list. Removed from today: bath 2's niche walls (y 11.0, x 1.5 south of the shaft) and bath 3's walls (y 14.4, x 2.2). The windows are provisional marks: the owner sets them with the facades.

    *The pure clear rectangle* (hatched): the largest clean rectangle in each bedroom after removing the entry strip, the door's swing, the shaft and the wardrobe. Bedroom 2 #ptxt(pure.at("Bedroom 2")) m², bedroom 3 #ptxt(pure.at("Bedroom 3")) m².

    #text(6.6pt, fill: gray)[Quick checks: #if all-ok [passed (5): the rooms and the shaft tile the band; fixtures and furniture inside their rooms, no overlaps, the entry strip clear; every door leaf clear; the bedrooms within 0.3 m²; the stack inside the GF WC compartment.] else [FAILED: #ok.enumerate().filter(((i, v)) => not v).map(((i, v)) => str(i + 1)).join(", ")]]
  ],
)

// ======================= PAGE 2 · the table and the Arabic lines =======================
#pagebreak()
#text(13pt, weight: "bold", fill: accent)[Today vs the option] #h(1fr) #text(6.8pt, fill: gray)[m² on axes · *clear* inside the walls (the outer wall 0.125, every other wall 0.10 a side) · today = `studies/ff_family.typ`, 14 Nov 2026]
#v(1pt) #line(length: 100%, stroke: 0.6pt + accent)
#grid(columns: (1.1fr, 1fr), column-gutter: 16pt,
  [
    #table(columns: (1.6fr, 1fr, 1fr), stroke: 0.3pt + luma(190), inset: 3pt, align: (left, right, right), fill: (_, y) => if y == 0 { rgb("#e1e9e3") } else if calc.even(y) { rgb("#efece4") },
      table.header([], [*Today*], [*The option*]),
      [Bedroom 2 · total clear], [#r2(clear(T-of("Bedroom 2")))], [*#r2(clear(P-of("Bedroom 2")))*],
      [Bedroom 2 · pure clear rectangle], ptxt(pure-today.at("Bedroom 2")), ptxt(pure.at("Bedroom 2")),
      [Bedroom 3 · total clear], [#r2(clear(T-of("Bedroom 3")))], [*#r2(clear(P-of("Bedroom 3")))*],
      [Bedroom 3 · pure clear rectangle], ptxt(pure-today.at("Bedroom 3")), ptxt(pure.at("Bedroom 3")),
      [Bath 2 · clear], [#r2(clear(T-of("Bedroom 2 bath")))], [#r2(clear(P-of("Bedroom 2 bath")))],
      [Bath 3 · clear], [#r2(clear(T-of("Bedroom 3 bath")))], [#r2(clear(P-of("Bedroom 3 bath")))],
      [Gym], [as is], [unchanged],
      [The stack lands on the GF in], [two stacks (the shaft; the FWC stack)], [one: the powder room's WC compartment, (#r2(stack.at(0)), #r2(stack.at(1)))],
      [Light partitions on the slab], [y 11.0, x 1.5 (bath 2); y 14.4, x 2.2 (bath 3)], [y #r2(yb), y #r2(ys), x #r2(xw) (the wet wall, mid-bay)],
      [Walls on beams / GF walls], [the gym wall on B22 + B8], [the same, unchanged],
    )
  ],
  [
    #ah[
      #text(7.8pt)[
        الخيار: النادي كما هو تمامًا (جداره على y 19.25 فوق الجسرين B22 وB8، عتبته وأبوابه)، وحمّاما غرفتي النوم 2 و3 ظهرًا لظهر بينهما بعمق 1.4 م (الحمّام 2 غربًا بنافذة، والحمّام 3 شرقًا بشفّاط)، بجدار رطب واحد وماسورة واحدة تنزل في حجرة مرحاض دورة المياه الأرضية. \
          غرفة النوم 2: مدخلها الشريط بجانب الشفت وبابها من الممر يواجه جدار الشفت؛ #r2(clear(P-of("Bedroom 2"))) م² صافية (اليوم #r2(clear(T-of("Bedroom 2")))) والمستطيل النقي #ptxt(pure.at("Bedroom 2")) م² (اليوم #ptxt(pure-today.at("Bedroom 2"))). \
          غرفة النوم 3: بابها من الممر بسيط؛ #r2(clear(P-of("Bedroom 3"))) م² صافية (اليوم #r2(clear(T-of("Bedroom 3")))) والمستطيل النقي #ptxt(pure.at("Bedroom 3")) م² (اليوم #ptxt(pure-today.at("Bedroom 3"))). \
          الحمّامان #r2(clear(P-of("Bedroom 2 bath"))) و#r2(clear(P-of("Bedroom 3 bath"))) م² صافية (دُش 0.8 × 0.8 بحاجز زجاجي ثابت، مرحاض معلق، مغسلة صغيرة)؛ الماسورة عند (#r2(stack.at(0)), #r2(stack.at(1))) داخل حجرة المرحاض الأرضية. \
          الجدران مستقيمة بلا كسرات: جدارا الحمّامين والجدار الرطب قواطع خفيفة على البلاطة، لا عمود ولا جسر يتحرك؛ النوافذ علامات مؤقتة يحددها المالك مع الواجهات.
      ]
    ]
  ],
)

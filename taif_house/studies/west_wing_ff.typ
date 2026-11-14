// west_wing_ff.typ · Taif / Palm House · STUDY, rev 2 (14 Nov 2026, owner): the first-floor WEST BAND, bedrooms 2 and 3 with their baths BACK TO BACK between
// the two bedrooms (one shared wet wall, one stack). Rev 2 after W1–W3 (the appendix): no store and no wardrobe in the strip beside the shaft: the strip is bedroom 2's
// ENTRY with its gallery door inside y 9.2–10.4 (entering, one faces the shaft box); the priority is two big equal bedrooms, the baths may shrink (X1 1.8 m deep, X2 1.6, X3
// the smallest workable); both WCs at the SOUTH end of the shared wet wall so the stack lands inside the GF powder room's WC compartment (south of its partition y 14.55).
// Nothing in the design files is changed. Fixed (studies/ff_family.typ, 14 Nov 2026): the band x 0–4.25 (axes), y 9.2–19.25; the gym south of y 19.25 behind the acoustic
// double wall; the gallery east of x 4.25; the west shaft x 0–1.5 × y 9.2–10.4; the family WC north of y 9.2; the west outer wall for the windows. CSV frame: x east, y south, wall centre lines.
#import "@preview/cetz:0.4.2"
#import "../base.typ": dist

#set page(paper: "a4", flipped: true, margin: 8mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 7.2pt)
#set par(leading: 0.4em)
#let ink = rgb("#3d4a45"); #let accent = rgb("#2f6b4f"); #let red = rgb("#b5452f"); #let blue = rgb("#2f5f8a"); #let amber = rgb("#c98a12"); #let gray = rgb("#6d736f"); #let brown = rgb("#8a5a2b")
#let H(t) = block(above: 5pt, below: 2.5pt, text(9pt, weight: "bold", fill: accent, t))
#let r2(v) = { let s = str(calc.round(v, digits: 2)); if not s.contains(".") { s + ".00" } else if s.split(".").at(1).len() == 1 { s + "0" } else { s } }
#let r1(v) = str(calc.round(v, digits: 1))
#let ah(t) = text(font: ("Segoe UI", "Arial", "Tahoma"), lang: "ar", dir: rtl, t)
#let rect-pts(x0, y0, x1, y1) = ((x0, y0), (x1, y0), (x1, y1), (x0, y1))

// ---------- fixed geometry ----------
#let X1 = 4.25; #let Y0 = 9.2; #let Y1 = 19.25
#let band = rect-pts(0, Y0, X1, Y1)
#let shaft = rect-pts(0, 9.2, 1.5, 10.4)
#let strip = rect-pts(1.5, 9.2, X1, 10.4)                 // bedroom 2's entry (kept clear of furniture)
#let gf-below = (   // data/rooms_gf.csv (V10.0 + 10–11 Nov 2026): what stands under the band; wet / service = true
  (rect-pts(0, 7.9, 2.75, 10.4), [GF utility · shaft], true), (rect-pts(0, 10.4, 2.75, 12.9), [GF hospitality kitchen], true),
  (rect-pts(0, 12.9, 2.75, 16.1), [GF powder room], true), (rect-pts(0, 16.1, 2.75, 17.5), [GF serving passage], true),
  (rect-pts(1.25, 17.5, 2.75, 19.4), [GF guest WC], true), (rect-pts(0, 17.5, 1.25, 20.3), [GF guest passage (to y 21.4)], false), (rect-pts(2.75, 7.9, 4.25, 19.25), [GF riwaq (from y 0)], false),
)
#let gf-compartment = rect-pts(0, 14.55, 2.75, 16.1)      // the GF powder room's WC compartment (its 100 mm partition on y 14.55; the wall-hung WC on y 16.1 with the FWC stack)
#let gf-lines-y = (10.4, 12.9, 16.1, 17.5)                // GF walls across the band (E–W); 14.55 is a 100 mm partition, not a wall
#let west-run-x = 0.5                                     // the GF buried west run (studies/plumbing.typ)
#let xw = 2.1                                             // the shared wet wall between the two baths

// ---------- today (studies/ff_family.typ, 14 Nov 2026) ----------
#let today = (rooms: (("Bedroom 2 bath", ((1.5, 9.2), (4.25, 9.2), (4.25, 11.0), (0, 11.0), (0, 10.4), (1.5, 10.4)), "wet"), ("Bedroom 2", rect-pts(0, 11.0, 4.25, 14.4), "bed"), ("Bedroom 3 bath", rect-pts(0, 14.4, 2.2, 16.1), "wet"), ("Bedroom 3", ((2.2, 14.4), (4.25, 14.4), (4.25, 19.25), (0, 19.25), (0, 16.1), (2.2, 16.1)), "bed")))

// ---------- helpers ----------
#let area(P) = calc.abs(range(P.len()).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, P.len())); a.at(0) * b.at(1) - b.at(0) * a.at(1) }).sum()) / 2
#let inset(P, d) = {
  let n = P.len()
  let lines = range(n).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, n)); let (dx, dy) = (b.at(0) - a.at(0), b.at(1) - a.at(1)); let L = calc.sqrt(dx * dx + dy * dy); ((a.at(0) - dy / L * d.at(i), a.at(1) + dx / L * d.at(i)), (dx, dy)) })
  range(n).map(i => { let (p1, v1) = lines.at(calc.rem(i + n - 1, n)); let (p2, v2) = lines.at(i); let den = v1.at(0) * v2.at(1) - v1.at(1) * v2.at(0); let t = ((p2.at(0) - p1.at(0)) * v2.at(1) - (p2.at(1) - p1.at(1)) * v2.at(0)) / den; (p1.at(0) + v1.at(0) * t, p1.at(1) + v1.at(1) * t) })
}
#let is-cw(P) = range(P.len()).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, P.len())); a.at(0) * b.at(1) - b.at(0) * a.at(1) }).sum() > 0
#let cw(P) = if is-cw(P) { P } else { P.rev() }
#let half(a, b) = if calc.abs(a.at(0)) < 1e-6 and calc.abs(b.at(0)) < 1e-6 { 0.125 } else { 0.10 }   // the west outer wall 0.25; every other wall 0.20
#let clear(P) = { let Q = cw(P); area(inset(Q, range(Q.len()).map(i => half(Q.at(i), Q.at(calc.rem(i + 1, Q.len())))))) }
#let bbox(P) = (calc.min(..P.map(p => p.at(0))), calc.min(..P.map(p => p.at(1))), calc.max(..P.map(p => p.at(0))), calc.max(..P.map(p => p.at(1))))
#let inside(p, P) = { let c = false; let n = P.len(); for i in range(n) { let (xi, yi) = P.at(i); let (xj, yj) = P.at(calc.rem(i + n - 1, n)); if ((yi > p.at(1)) != (yj > p.at(1))) and (p.at(0) < (xj - xi) * (p.at(1) - yi) / (yj - yi) + xi) { c = not c } }; c }
#let box-in(b, P) = { let e = 0.001; ((b.at(0) + e, b.at(1) + e), (b.at(2) - e, b.at(1) + e), (b.at(2) - e, b.at(3) - e), (b.at(0) + e, b.at(3) - e)).all(p => inside(p, P)) }
#let overlap(a, b) = not (a.at(2) <= b.at(0) + 1e-9 or b.at(2) <= a.at(0) + 1e-9 or a.at(3) <= b.at(1) + 1e-9 or b.at(3) <= a.at(1) + 1e-9)
#let no-overlaps(L) = range(L.len()).all(i => range(L.len()).all(j => i == j or not overlap(L.at(i), L.at(j))))
#let swing-box(d) = { let (a, b, dir) = (d.at(0), d.at(1), d.at(2)); let w = dist(a, b); let (x0, x1, y0, y1) = (calc.min(a.at(0), b.at(0)), calc.max(a.at(0), b.at(0)), calc.min(a.at(1), b.at(1)), calc.max(a.at(1), b.at(1)))
  if dir == (0, 0) { none } else if dir.at(1) < 0 { (x0, y0 - w, x1, y0) } else if dir.at(1) > 0 { (x0, y0, x1, y0 + w) } else if dir.at(0) > 0 { (x0, y0, x0 + w, y1) } else { (x0 - w, y0, x0, y1) } }
#let jog(P) = { let Q = cw(P); let n = Q.len(); range(n).any(i => { let a = Q.at(calc.rem(i + n - 1, n)); let b = Q.at(i); let c = Q.at(calc.rem(i + 1, n)); ((b.at(0) - a.at(0)) * (c.at(1) - b.at(1)) - (b.at(1) - a.at(1)) * (c.at(0) - b.at(0)) < -1e-6) and calc.min(dist(a, b), dist(b, c)) < 1.0 - 1e-6 }) }
#let P-of(L, n) = { let r = L.rooms.find(r => r.at(0) == n); if r == none { none } else { r.at(1) } }
#let Cz(L, n) = { let P = P-of(L, n); if P == none { 0 } else { clear(P) } }
#let Az(L, n) = { let P = P-of(L, n); if P == none { 0 } else { area(P) } }
#let bx(b) = (b.at(0), b.at(1), b.at(2), b.at(3))

// ---------- the option builder: D = the bath pair's depth on axes; yb = the pair's north wall (solved so that the two bedrooms' clear areas match); sh = the shower (w × d), bw = the basin's width ----------
// clear areas: bedroom 2 = 4.025 (yb − 10.6) + 2.55 × 1.2 (the entry strip); bedroom 3 = 4.025 (19.05 − yb − D)  →  yb = (29.65 − D) / 2 − 0.38
#let option(short, name, D, sh, bw, note) = {
  let yb = calc.round(((29.65 - D) / 2 - 0.38) * 20) / 20   // to 0.05
  let ys = yb + D
  let rooms = (("Bedroom 2", ((1.5, 9.2), (X1, 9.2), (X1, yb), (0, yb), (0, 10.4), (1.5, 10.4)), "bed"), ("Bedroom 2 bath", rect-pts(0, yb, xw, ys), "wet"), ("Bedroom 3 bath", rect-pts(xw, yb, X1, ys), "wet"), ("Bedroom 3", rect-pts(0, ys, X1, Y1), "bed"))
  let (sw, sd) = sh
  let furniture = (
    // bedroom 2: the bed's head on the west wall (its foot towards the room), the desk at the west window south of it, the wardrobe on the south (bath) wall east of the bath door; the entry strip by the shaft kept clear
    (0.125, 10.55, 2.125, 11.95, [bed 1.4 × 2.0], "Bedroom 2"), (0.125, 12.0, 0.525, 12.4, [], "Bedroom 2"), (2.15, 10.55, 2.55, 10.95, [], "Bedroom 2"),
    (0.125, yb - 1.0, 0.725, yb - 0.1, [desk 0.9 × 0.6], "Bedroom 2"), (0.8, yb - 0.85, 1.25, yb - 0.4, [], "Bedroom 2"), (2.0, yb - 0.7, 3.8, yb - 0.1, [wardrobe 1.8 × 0.6], "Bedroom 2"),
    // bedroom 3: the bed's head on the west wall (away from the gym's double wall), the desk at the west window south of it, the wardrobe on the gallery wall south of the door
    (0.125, ys + 0.6, 2.125, ys + 2.0, [bed 1.4 × 2.0], "Bedroom 3"), (0.125, ys + 0.15, 0.525, ys + 0.55, [], "Bedroom 3"), (0.125, ys + 2.05, 0.525, ys + 2.45, [], "Bedroom 3"),
    (0.125, 18.0, 0.725, 19.1, [desk 1.1 × 0.6], "Bedroom 3"), (0.8, 18.3, 1.25, 18.75, [], "Bedroom 3"), (3.55, 17.3, 4.15, 19.1, [wardrobe 1.8 × 0.6], "Bedroom 3"),
  )
  // bath 2 (west, x 0.125–2.0 clear): the shower in the north-west corner, the basin on the west wall at the south end, the WC on the shared wet wall at its SOUTH end facing west, the door at the east end of the north wall
  // bath 3 (east, x 2.2–4.15 clear): the shower on the wet wall's north part, the WC on the wet wall at its SOUTH end facing east, the basin on the gallery wall's north part, the door at the east part of the south wall
  let fixtures = (
    (0.125, yb + 0.1, 0.125 + sw, yb + 0.1 + sd, [shower #r1(sw) × #r1(sd) · screen], "Bedroom 2 bath"), (0.125, ys - 0.1 - bw, 0.475, ys - 0.1, [basin], "Bedroom 2 bath"), (1.4, ys - 0.5, 2.0, ys - 0.1, [WC], "Bedroom 2 bath"),
    (2.2, yb + 0.1, 2.2 + sw, yb + 0.1 + sd, [shower #r1(sw) × #r1(sd) · screen], "Bedroom 3 bath"), (2.2, ys - 0.5, 2.8, ys - 0.1, [WC], "Bedroom 3 bath"), (3.8, yb + 0.3, 4.15, yb + 0.3 + bw, [basin], "Bedroom 3 bath"),
  )
  let fronts = (   // ≥ 0.60 clear in front of each WC and basin: (box, the fixture index it belongs to)
    ((0.8, ys - 0.5, 1.4, ys - 0.1), 2), ((0.475, ys - 0.1 - bw, 1.075, ys - 0.1), 1), ((2.8, ys - 0.5, 3.4, ys - 0.1), 4), ((3.2, yb + 0.3, 3.8, yb + 0.3 + bw), 5),
  )
  let doors = (
    ((X1, 9.35), (X1, 10.25), (-1, 0), [bedroom 2 door 0.90, from the gallery, in the entry strip], "Bedroom 2"),
    ((1.2, yb), (1.9, yb), (0, 1), [bath 2 door 0.70, from bedroom 2, opens into the bath], "Bedroom 2 bath"),
    ((3.0, ys), (3.7, ys), (0, -1), [bath 3 door 0.70, from bedroom 3, opens into the bath], "Bedroom 3 bath"),
    ((X1, ys + 0.3), (X1, ys + 1.2), (-1, 0), [bedroom 3 door 0.90, from the gallery], "Bedroom 3"),
  )
  let windows = (((0, 10.7), (0, 11.8), [bedroom 2 escape window, at the bed]), ((0, yb - 1.0), (0, yb - 0.2), [bedroom 2, at the desk]), ((0, yb + 0.15), (0, yb + 0.1 + sd - 0.05), [bath 2 · small, high, obscure]), ((0, ys + 0.7), (0, ys + 1.9), [bedroom 3 escape window, at the bed]), ((0, 18.1), (0, 19.0), [bedroom 3, at the desk]))
  let stack = (xw, ys - 0.3)   // in the shared wet wall between the two WCs, at its south end
  (short: short, name: name, yb: yb, D: D, sh: sh, bw: bw, note: note, rooms: rooms, furniture: furniture, fixtures: fixtures, fronts: fronts, doors: doors, windows: windows, stack: stack)
}
#let X1o = option("X1", [X1 · the bath pair 1.8 m deep (the W2 baths, ≈ 3.0 m² clear): showers 0.9 × 0.9], 1.8, (0.9, 0.9), 0.5, [the pair at y 13.55–15.35])
#let X2o = option("X2", [X2 · the pair 1.6 m deep (≈ 2.5 m² clear): showers 0.8 × 0.9, compact basins 0.35 deep], 1.6, (0.8, 0.9), 0.4, [the pair at y 13.65–15.25])
#let X3o = option("X3", [X3 · the smallest workable pair, 1.4 m deep (1.2 clear): showers 0.8 × 0.8, basins 0.35 deep, hinged inward doors still fit], 1.4, (0.8, 0.8), 0.4, [the pair at y 13.75–15.15])
#let options = (X1o, X2o, X3o)

// ---------- checks ----------
#let tile-ok(L) = calc.abs(area(band) - area(shaft) - L.rooms.map(r => area(r.at(1))).sum()) < 0.01 and no-overlaps(L.rooms.map(r => bbox(r.at(1))))
#let in-rooms(L, items) = items.all(f => { let P = P-of(L, f.at(5)); P != none and box-in(bx(f), P) })
#let fix-ok(L) = in-rooms(L, L.fixtures) and no-overlaps(L.fixtures.map(bx))
#let furn-ok(L) = in-rooms(L, L.furniture) and no-overlaps(L.furniture.map(bx))
#let swings-ok(L) = L.doors.map(swing-box).all(s => (L.furniture + L.fixtures).map(bx).all(b => not overlap(s, b)))
#let fronts-ok(L) = L.fronts.all(((b, i)) => { let P = P-of(L, L.fixtures.at(i).at(5)); box-in(b, P) and L.fixtures.enumerate().all(((j, f)) => j == i or not overlap(b, bx(f))) })
#let shower-ok(L) = L.sh.at(0) >= 0.8 - 1e-6 and L.sh.at(1) >= 0.8 - 1e-6
#let equal-ok(L) = calc.abs(Cz(L, "Bedroom 2") - Cz(L, "Bedroom 3")) <= 0.3 + 1e-6
#let stack-ok(L) = inside(L.stack, gf-compartment)
#let strip-ok(L) = L.furniture.map(bx).all(b => not overlap(b, bbox(strip)))
#let jog-ok(L) = L.rooms.all(r => not jog(r.at(1)))
#let checks(L) = (
  ([the rooms and the shaft tile the band, no overlaps; no small jog in any room], tile-ok(L) and jog-ok(L)),
  ([fixtures inside their baths, no overlaps; ≥ 0.60 clear in front of each WC and basin; showers ≥ 0.8 × 0.8], fix-ok(L) and fronts-ok(L) and shower-ok(L)),
  ([furniture inside its rooms, no overlaps; bedroom 2's entry strip clear], furn-ok(L) and strip-ok(L)),
  ([every door leaf swings clear of furniture and fixtures], swings-ok(L)),
  ([the two bedrooms within 0.3 m² clear (#r2(Cz(L, "Bedroom 2")) / #r2(Cz(L, "Bedroom 3")))], equal-ok(L)),
  ([the stack lands inside the GF powder room's WC compartment (y > 14.55)], stack-ok(L)),
)
#let all-ok(L) = checks(L).all(c => c.at(1))
#let walls-on-gf(L) = (L.yb, L.yb + L.D).filter(y => gf-lines-y.any(g => calc.abs(g - y) < 1e-6))
#let walls-off-gf(L) = (L.yb, L.yb + L.D).filter(y => not gf-lines-y.any(g => calc.abs(g - y) < 1e-6))

// ---------- drawing (1.0 cm / m, as the presentation's sheet 04) ----------
#let q(p) = (p.at(0), -p.at(1))
#let fillc = (bed: rgb("#f6e3c0"), wet: rgb("#cfe6ef"))
#let plan(L, length: 1.0cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, body, size: 4.4pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, body))
  let poly(P, fill: none, stroke: none) = line(..P.map(q), close: true, fill: fill, stroke: stroke)
  let R(b, fill: none, stroke: none) = rect(q((b.at(0), b.at(1))), q((b.at(2), b.at(3))), fill: fill, stroke: stroke)
  rect(q((-0.7, 7.5)), q((6.2, 20.3)), fill: rgb("#f3efe6"), stroke: none)
  for x in range(0, 6) { line(q((x, 7.7)), q((x, 20.1)), stroke: 0.2pt + luma(220)); T((x, 7.55), str(x), size: 3.6pt, fill: gray) }
  for y in range(8, 21) { line(q((-0.3, y)), q((6.0, y)), stroke: 0.2pt + luma(220)); T((-0.45, y), str(y), size: 3.6pt, fill: gray, anchor: "east") }
  for (P, l, wet) in gf-below { poly(P, stroke: (paint: brown, dash: "dotted", thickness: 0.5pt)) }
  poly(gf-compartment, fill: rgb("#f0d9c0").transparentize(60%), stroke: (paint: brown, dash: "dotted", thickness: 0.5pt)); T((1.4, 14.45), [GF WC compartment y 14.55–16.1 (below)], size: 3pt, fill: brown)
  rect(q((0, 7.9)), q((2.75, 9.2)), fill: luma(236), stroke: 0.8pt + ink); T((1.4, 8.55), [family WC], size: 4pt, fill: gray)
  rect(q((2.75, 7.9)), q((4.25, 9.2)), fill: rgb("#f2efe8"), stroke: 0.8pt + ink)
  rect(q((4.25, 7.9)), q((5.8, 20.3)), fill: rgb("#f2efe8"), stroke: 0.8pt + ink); T((5.02, 14.0), [gallery (on the projection) · 1.55], size: 4pt, fill: gray, angle: 90deg)
  rect(q((0, 19.25)), q((4.25, 20.3)), fill: rgb("#d9e4f2"), stroke: 0.8pt + ink); T((2.1, 19.8), [gym · the acoustic double wall on y 19.25], size: 4pt, fill: gray)
  for (n, P, k) in L.rooms { poly(P, fill: fillc.at(k), stroke: 0.9pt + ink) }
  R(bbox(strip), fill: none, stroke: (paint: accent, thickness: 0.4pt, dash: "dotted")); T((2.9, 9.45), [entry · kept clear], size: 3.4pt, fill: accent)
  poly(shaft, fill: luma(205), stroke: 0.9pt + ink); T((0.75, 9.8), [west shaft], size: 4pt)
  line(q((0, 7.9)), q((0, 20.3)), stroke: 2pt + ink)
  line(q((xw, L.yb)), q((xw, L.yb + L.D)), stroke: 2.4pt + blue)
  for (x0, y0, x1, y1, l, rm) in L.furniture { R((x0, y0, x1, y1), fill: rgb("#fbf6ea"), stroke: 0.45pt + rgb("#8a7a5a")); T(((x0 + x1) / 2, (y0 + y1) / 2), l, size: 3.4pt, angle: if (y1 - y0) > (x1 - x0) * 1.4 { 90deg } else { 0deg }) }
  for (b, i) in L.fronts { R(b, fill: none, stroke: (paint: blue, thickness: 0.3pt, dash: "dotted")) }
  for (x0, y0, x1, y1, l, rm) in L.fixtures { R((x0, y0, x1, y1), fill: white, stroke: 0.45pt + blue); T(((x0 + x1) / 2, (y0 + y1) / 2), l, size: 3.1pt, fill: blue, angle: if (y1 - y0) > (x1 - x0) * 1.4 { 90deg } else { 0deg }) }
  for d in L.doors { line(q(d.at(0)), q(d.at(1)), stroke: 3pt + red); let s = swing-box(d); if s != none { R(s, stroke: (paint: red, thickness: 0.35pt, dash: "dashed")) } }
  for (a, b, l) in L.windows { line(q(a), q(b), stroke: (paint: blue, thickness: 2.2pt, dash: "dashed")) }
  circle(q(L.stack), radius: 0.14, fill: brown, stroke: none); T((L.stack.at(0) + 0.2, L.stack.at(1) + 0.22), [stack], size: 3.6pt, fill: brown, anchor: "west")
  for y in gf-lines-y { line(q((-0.6, y)), q((-0.35, y)), stroke: 1pt + brown); T((-0.62, y), [GF], size: 3pt, fill: brown, anchor: "east") }
  for (n, P, k) in L.rooms { let c = if n == "Bedroom 2" { (2.9, 12.3) } else if n == "Bedroom 3" { (2.5, L.yb + L.D + 2.2) } else if n == "Bedroom 2 bath" { (1.35, L.yb + 0.95) } else { (3.3, L.yb + L.D - 0.85) }
    T(c, [*#n*\ #r2(area(P)) · ≈ #r2(clear(P))], size: if k == "wet" { 3.4pt } else { 4.4pt }) }
  line(q((0, 20.6)), q((1, 20.6)), stroke: 1pt + ink); T((0.5, 20.85), [1 m], size: 4pt)
})

// ======================= PAGE 1 · comparison and the study's view =======================
#text(13pt, weight: "bold", fill: accent)[First-floor west band, rev 2 · bedrooms 2 and 3 with back-to-back baths · X1 / X2 / X3 by bath size] #h(1fr) #text(6.6pt, fill: gray)[study · 14 Nov 2026 · nothing in the design files changed · m² on axes · *clear* inside the walls (west wall 0.125, others 0.10 a side)]
#v(1pt) #line(length: 100%, stroke: 0.6pt + accent)
#let AC(L, n) = { let P = P-of(L, n); if P == none { [—] } else { [#r2(area(P)) · *#r2(clear(P))*] } }
#let gain(L, n) = { let v = Cz(L, n) - Cz(today, n); [#if v >= 0 [+] #r2(v)] }
#grid(columns: (1.15fr, 1fr), column-gutter: 12pt,
  [
    #table(columns: (1.5fr, 1fr, 1fr, 1fr, 1fr), stroke: 0.3pt + luma(190), inset: 2.6pt, align: (left, right, right, right, right), fill: (_, y) => if y == 0 { rgb("#e1e9e3") } else if calc.even(y) { rgb("#efece4") },
      table.header([*axes · clear m²*], [*Today*], [*X1*], [*X2*], [*X3*]),
      [Bedroom 2 (with its entry strip)], AC(today, "Bedroom 2"), AC(X1o, "Bedroom 2"), AC(X2o, "Bedroom 2"), AC(X3o, "Bedroom 2"),
      [… gain over today (clear)], [—], gain(X1o, "Bedroom 2"), gain(X2o, "Bedroom 2"), gain(X3o, "Bedroom 2"),
      [Bedroom 3], AC(today, "Bedroom 3"), AC(X1o, "Bedroom 3"), AC(X2o, "Bedroom 3"), AC(X3o, "Bedroom 3"),
      [… gain over today (clear)], [—], gain(X1o, "Bedroom 3"), gain(X2o, "Bedroom 3"), gain(X3o, "Bedroom 3"),
      [the two bedrooms differ by (clear)], [#r2(calc.abs(Cz(today, "Bedroom 2") - Cz(today, "Bedroom 3")))], [#r2(calc.abs(Cz(X1o, "Bedroom 2") - Cz(X1o, "Bedroom 3")))], [#r2(calc.abs(Cz(X2o, "Bedroom 2") - Cz(X2o, "Bedroom 3")))], [#r2(calc.abs(Cz(X3o, "Bedroom 2") - Cz(X3o, "Bedroom 3")))],
      [Bath 2 (west, window)], AC(today, "Bedroom 2 bath"), AC(X1o, "Bedroom 2 bath"), AC(X2o, "Bedroom 2 bath"), AC(X3o, "Bedroom 2 bath"),
      [Bath 3 (east, fan)], AC(today, "Bedroom 3 bath"), AC(X1o, "Bedroom 3 bath"), AC(X2o, "Bedroom 3 bath"), AC(X3o, "Bedroom 3 bath"),
      [Bath pair: axes y · clear depth], [—], [#r2(X1o.yb)–#r2(X1o.yb + X1o.D) · #r2(X1o.D - 0.2)], [#r2(X2o.yb)–#r2(X2o.yb + X2o.D) · #r2(X2o.D - 0.2)], [#r2(X3o.yb)–#r2(X3o.yb + X3o.D) · #r2(X3o.D - 0.2)],
      [Shower · basin depth], [—], [#r1(X1o.sh.at(0)) × #r1(X1o.sh.at(1)) · 0.35], [#r1(X2o.sh.at(0)) × #r1(X2o.sh.at(1)) · 0.35], [#r1(X3o.sh.at(0)) × #r1(X3o.sh.at(1)) · 0.35],
      [Bath doors], [—], [0.70 hinged, in], [0.70 hinged, in], [0.70 hinged, in],
      [The stack (x #r2(xw)) lands at y], [—], [#r2(X1o.stack.at(1)) · in the GF WC compartment], [#r2(X2o.stack.at(1)) · in the compartment], [#r2(X3o.stack.at(1)) · in the compartment (0.30 inside)],
      [New E–W walls on GF walls], [—], [#if walls-on-gf(X1o).len() == 0 [none] else [#walls-on-gf(X1o).map(r2).join(", ")]], [#if walls-on-gf(X2o).len() == 0 [none] else [#walls-on-gf(X2o).map(r2).join(", ")]], [#if walls-on-gf(X3o).len() == 0 [none] else [#walls-on-gf(X3o).map(r2).join(", ")]],
      [Checks (6)], [—], [#if all-ok(X1o) [passed] else [#checks(X1o).filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]], [#if all-ok(X2o) [passed] else [#checks(X2o).filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]], [#if all-ok(X3o) [passed] else [#checks(X3o).filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]],
    )
    #v(2pt)
    #text(6.4pt, fill: gray)[Today = `studies/ff_family.typ` (14 Nov 2026). The six checks: the rooms tile the band with no small jog; fixtures inside with ≥ 0.60 clear in front of every WC and basin and showers ≥ 0.8 × 0.8; furniture inside and the entry strip clear; door swings clear; the bedrooms within 0.3 m² clear; the stack inside the GF WC compartment. Bedroom 2's clear area includes its entry strip (2.55 × 1.2 = 3.06 m²).]
    #v(3pt)
    #H[Common to the three]
    #text(6.8pt)[
      - *Bedroom 2's entry:* the strip x 1.5–4.25 × y 9.2–10.4 beside the shaft, its 0.90 door from the gallery inside it (x 4.25, y 9.35–10.25, opening in); entering, one faces the shaft's box 2.65 m ahead; nothing stored there. The bed's head on the west wall, the desk at the west window south of it, the 1.8 m wardrobe on the bath wall east of the bath door.
      - *The pair:* bath 2 west (its window above the shower, the basin on the west wall, the WC on the shared wall), bath 3 east by the gallery (the shower on the shared wall's north part, the WC at its south end, the basin on the gallery wall; a fan to the roof). *Both WCs at the south end of the shared wet wall x #r2(xw)*, the stack between them 0.3 m north of the pair's south wall: in all three it drops straight into the *GF powder room's WC compartment* (y 14.55–16.1), boxed 0.30 × 0.30 at the compartment's partition, then ≈ #r1(xw - west-run-x) m in the GF floor build-up to the buried west run (x #r2(west-run-x)); one stack instead of today's two.
      - *Bedroom 3:* the bed's head on the west wall away from the gym's double wall, the desk at the west window south of it, the wardrobe on the gallery wall south of its door; the bath door in its north wall east part, out of the bed's line.
      - *Structure:* the pair's two cross walls and the wet wall are 0.20 block partitions on the solid 0.20 west slab (none on a GF wall: the GF walls are y 10.4, 12.9, 16.1, 17.5); the wet wall carries the stack and two WC frames mid-bay between the GF riwaq wall x 2.75 and the outer wall (for the engineer's list). Removed: bath 2's niche walls (y 11.0, x 1.5 south of the shaft) and bath 3's walls (y 14.4, x 2.2).
    ]
  ],
  [
    #box(fill: accent.lighten(86%), stroke: 1pt + accent, inset: 6pt, radius: 3pt, width: 100%)[
      #text(9.5pt, weight: "bold", fill: accent)[The study's view (the owner decides): X2] \
      #text(7pt)[
        The owner's priority is the two bedrooms. Each 0.2 m taken from the pair's depth gives each bedroom 0.1 m, about 0.4 m² clear: X1 → X2 → X3 is #r2(Cz(X1o, "Bedroom 2")) → #r2(Cz(X2o, "Bedroom 2")) → #r2(Cz(X3o, "Bedroom 2")) m² for bedroom 2 (today #r2(Cz(today, "Bedroom 2"))) and #r2(Cz(X1o, "Bedroom 3")) → #r2(Cz(X2o, "Bedroom 3")) → #r2(Cz(X3o, "Bedroom 3")) for bedroom 3 (today #r2(Cz(today, "Bedroom 3"))). *X2* (1.6 m deep, 1.4 clear) is where the bath still feels like a room: a 0.8 × 0.9 shower, a 0.6 m walk between the shower screen and the basin, the door's leaf short of everything. *X3* (1.4 m deep, 1.2 clear) passes every rule with nothing to spare: the shower, the WC and the basin touch in a row, the door leaf stops 0.1 m from the shower screen, and it buys only #r2(Cz(X3o, "Bedroom 2") - Cz(X2o, "Bedroom 2")) m² more per bedroom than X2. *X1* keeps the W2 baths (3.0 m²) for #r2(Cz(X2o, "Bedroom 2") - Cz(X1o, "Bedroom 2")) m² less per bedroom than X2.
        \ *All three* land the stack in the GF WC compartment (X3 by 0.30 m only), stand on no GF wall, and keep bedroom 2's entry strip clear with the gallery door inside it.
      ]
    ]
    #v(4pt)
    #box(fill: rgb("#f4efe3"), stroke: 0.6pt + luma(170), inset: 6pt, radius: 3pt, width: 100%)[
      #ah[
        #text(9pt, weight: "bold", fill: accent)[الخلاصة بالعربية] \
        #text(7.4pt)[
          قرار المالك (14 نوفمبر 2026): لا مخزن ولا دولاب في الشريط بجانب الشفت؛ الشريط مدخل غرفة النوم 2 وبابها من الممر فيه؛ الأولوية غرفتان كبيرتان متساويتان، والحمّامان ظهرًا لظهر بينهما بماسورة واحدة تنزل في حجرة مرحاض دورة المياه الأرضية. \
          *X1:* الحمّامان بعمق 1.8 م (#r2(Cz(X1o, "Bedroom 2 bath")) و#r2(Cz(X1o, "Bedroom 3 bath")) م² صافية)؛ الغرفتان #r2(Cz(X1o, "Bedroom 2")) و#r2(Cz(X1o, "Bedroom 3")) م². \
          *X2 (رأي الدراسة):* الحمّامان بعمق 1.6 م (#r2(Cz(X2o, "Bedroom 2 bath")) و#r2(Cz(X2o, "Bedroom 3 bath")) م²) بدُش 0.8 × 0.9 ومغسلة صغيرة؛ الغرفتان #r2(Cz(X2o, "Bedroom 2")) و#r2(Cz(X2o, "Bedroom 3")) م². \
          *X3:* أصغر زوج يعمل: 1.4 م (#r2(Cz(X3o, "Bedroom 2 bath")) و#r2(Cz(X3o, "Bedroom 3 bath")) م²) بدُش 0.8 × 0.8 وبلا فائض؛ الغرفتان #r2(Cz(X3o, "Bedroom 2")) و#r2(Cz(X3o, "Bedroom 3")) م².
        ]
      ]
    ]
  ],
)

// ======================= PAGES 2–4 · the options =======================
#for L in options [
  #pagebreak()
  #text(12pt, weight: "bold", fill: accent)[#L.name] #h(1fr) #text(6.6pt, fill: gray)[1 : 100 (1.0 cm / m, as sheet 04) · CSV frame, north up · #L.note]
  #v(1pt) #line(length: 100%, stroke: 0.6pt + accent)
  #grid(columns: (auto, 1fr), column-gutter: 14pt,
    plan(L),
    [
      #let ys = L.yb + L.D
      #H[Clear sizes and areas]
      #table(columns: (1.4fr, 1fr, 1fr, 1fr, 1fr), stroke: 0.3pt + luma(190), inset: 2.4pt, align: (left, right, right, right, right), fill: (_, y) => if y == 0 { rgb("#e1e9e3") } else if calc.even(y) { rgb("#efece4") },
        table.header([*Room*], [*axes w × d*], [*clear w × d*], [*axes m²*], [*clear m²*]),
        [Bedroom 2 (+ the entry strip 2.55 × 1.20 clear)], [4.25 × #r2(L.yb - 10.4) (L)], [#r2(X1 - 0.225) × #r2(L.yb - 10.6)], [#r2(Az(L, "Bedroom 2"))], [*#r2(Cz(L, "Bedroom 2"))* (today #r2(Cz(today, "Bedroom 2")): #gain(L, "Bedroom 2"))],
        [Bedroom 3], [4.25 × #r2(Y1 - ys)], [#r2(X1 - 0.225) × #r2(Y1 - ys - 0.2)], [#r2(Az(L, "Bedroom 3"))], [*#r2(Cz(L, "Bedroom 3"))* (today #r2(Cz(today, "Bedroom 3")): #gain(L, "Bedroom 3"))],
        [Bath 2], [#r2(xw) × #r2(L.D)], [#r2(xw - 0.225) × #r2(L.D - 0.2)], [#r2(Az(L, "Bedroom 2 bath"))], [*#r2(Cz(L, "Bedroom 2 bath"))*],
        [Bath 3], [#r2(X1 - xw) × #r2(L.D)], [#r2(X1 - xw - 0.2) × #r2(L.D - 0.2)], [#r2(Az(L, "Bedroom 3 bath"))], [*#r2(Cz(L, "Bedroom 3 bath"))*],
      )
      #text(6.4pt)[*Checks:* #if all-ok(L) [passed (#checks(L).len())] else [FAILED: #checks(L).filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]. The bath pair y #r2(L.yb)–#r2(ys); the shower #r1(L.sh.at(0)) × #r1(L.sh.at(1)) behind a fixed glass screen, a wall mixer and a floor drain; the basin #r1(L.bw) wide × 0.35 deep; ≥ 0.60 in front of each WC and basin (the dotted boxes); the two bath doors 0.70 hinged, opening into the baths, their leaves clear of every fixture.]
      #H[Furniture and doors]
      #text(6.8pt)[
        - *Bedroom 2:* the door 0.90 from the gallery in the entry strip (x 4.25, y 9.35–10.25, opening in: the leaf stays inside the strip); entering, the shaft's box is straight ahead and the room opens to the left. The bed 1.4 × 2.0 with its head on the west wall (y 10.55–11.95) under the escape window, the desk 0.9 × 0.6 at the second west window south of it, the wardrobe 1.8 × 0.6 on the bath wall east of the bath door (x 2.0–3.8). The bath door (y #r2(L.yb), x 1.2–1.9) is out of the bed's line.
        - *Bedroom 3:* the door 0.90 from the gallery (x 4.25, y #r2(ys + 0.3)–#r2(ys + 1.2), opening in); the bed's head on the west wall (y #r2(ys + 0.6)–#r2(ys + 2.0)) under its escape window, away from the gym's double wall; the desk 1.1 × 0.6 at the south-west window; the wardrobe 1.8 × 0.6 on the gallery wall south of the door (y 17.3–19.1). The bath door (y #r2(ys), x 3.0–3.7) beside the entry, not facing the bed.
        - *Bath 2 (from bedroom 2):* the shower in the north-west corner under the high window, the basin on the west wall at the south end, the WC on the shared wall facing west; the door at the east end of the north wall, its leaf against the shared wall. *Bath 3 (from bedroom 3):* the shower on the shared wall's north part, the WC at its south end facing east, the basin on the gallery wall; the door at the east part of the south wall, its leaf against the gallery wall; an exhaust fan.
      ]
      #H[Drainage and structure]
      #text(6.8pt)[
        - *The stack* in the shared wet wall x #r2(xw) at y #r2(L.stack.at(1)), between the two wall-hung pans (0.4 m from each); the showers' floor drains ≈ #r1(dist((0.5, L.yb + 0.5), L.stack)) m (bath 2) and ≈ #r1(dist((2.6, L.yb + 0.5), L.stack)) m (bath 3), the basins ≈ #r1(dist((0.3, ys - 0.3), L.stack)) m and ≈ #r1(dist((4.0, L.yb + 0.5), L.stack)) m, in the floor build-up or the wet wall's chase, 100 mm waste, falls ≥ 1 : 60.
        - *On the ground floor* it lands at (#r2(L.stack.at(0)), #r2(L.stack.at(1))): #if stack-ok(L) [*inside the powder room's WC compartment* (y 14.55–16.1, #r2(L.stack.at(1) - 14.55) m south of its partition), boxed 0.30 × 0.30 against that partition's south face] else [*NOT inside the WC compartment* (it would land in the basin zone north of y 14.55)], then ≈ #r1(xw - west-run-x) m in the GF floor build-up to the buried west run (x #r2(west-run-x)); a cleanout at the foot; the vent up through the pair's ceiling to the roof. Today's two stacks (the shaft's for bath 2, the FWC stack for bath 3) become one.
        - *Structure:* #if walls-on-gf(L).len() == 0 [none of the new E–W walls (y #walls-off-gf(L).map(r2).join(", ")) stands on a GF wall (the nearest: y 12.9 and 16.1)] else [the wall(s) on y #walls-on-gf(L).map(r2).join(", ") stand on GF walls; y #walls-off-gf(L).map(r2).join(", ") not]; they and the wet wall x #r2(xw) (y #r2(L.yb)–#r2(ys)) are 0.20 block partitions on the solid 0.20 west slab; the wet wall carries the stack and the two WC frames mid-bay (the GF riwaq wall x 2.75 and the outer wall carry the slab): for the engineer's list. The band's long walls, the shaft, the family WC's south wall y 9.2 and the gym's double wall are untouched.
      ]
    ],
  )
]

// ======================= PAGE 5 · appendix: W1–W3 (the first round, superseded) =======================
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[Appendix · the first round W1–W3 (14 Nov 2026, superseded by the owner's decisions above)] #h(1fr) #text(6.6pt, fill: gray)[the summary table only; the plans are in the git history (commit "Study: FF west band, back-to-back baths (W1–W3)")]
#v(1pt) #line(length: 100%, stroke: 0.6pt + accent)
#grid(columns: (1.2fr, 1fr), column-gutter: 14pt,
  [
    #table(columns: (1.5fr, 1fr, 1fr, 1fr, 1fr), stroke: 0.3pt + luma(190), inset: 2.6pt, align: (left, right, right, right, right), fill: (_, y) => if y == 0 { rgb("#e1e9e3") } else if calc.even(y) { rgb("#efece4") },
      table.header([*axes · clear m²*], [*Today*], [*W1*], [*W2*], [*W3*]),
      [Bedroom 2], [14.45 · 12.88], [14.98 · 13.38], [16.69 · 14.93], [20.30 · 18.36],
      [Bedroom 3], [16.87 · 15.02], [14.98 · 13.38], [16.57 · 14.89], [13.39 · 11.87],
      [the two bedrooms differ by (clear)], [2.14], [0.00], [0.04], [6.48],
      [Bath 2], [5.85 · 4.67], [3.78 · 3.00], [3.78 · 3.00], [3.57 · 2.81],
      [Bath 3], [3.74 · 2.96], [3.87 · 3.12], [3.87 · 3.12], [3.66 · 2.93],
      [Store off the gallery], [—], [3.30 · 2.55], [—], [—],
      [Bath pair (axes y)], [—], [13.93–15.73], [13.55–15.35], [14.40–16.10],
      [New E–W walls on GF walls], [—], [y 10.4], [none], [y 16.1],
      [The stack landed in (the WCs then mid-wall)], [—], [the GF WC compartment], [the GF basin zone], [the GF WC compartment],
      [Checks (9)], [—], [passed], [passed], [baths < 3.0; rooms unequal],
    )
  ],
  [
    #text(6.8pt)[
      - *W1:* the bath pair 1.8 m deep side by side across the band, bedroom 2's north wall straight on y 10.4 (the shaft's south face, a GF wall), the strip x 1.5–4.25 × y 9.2–10.4 a store off the gallery.
      - *W2 (the owner's idea then):* as W1, the strip given to bedroom 2 with a deep wardrobe beside the shaft, its face flush with the shaft's face.
      - *W3:* as W2 with the pair's walls on y 14.4–16.1: y 14.4 is no longer a GF wall (the GF powder room runs 12.9–16.1, its compartment partition is at 14.55), the baths fell under 3.0 m² and the rooms differed by 6.5 m².
      - *What the owner kept for rev 2:* the pair back to back between the bedrooms on one wet wall and one stack, bath 2 west with a window, bath 3 east with a fan, straight walls, equal rooms. *What changed:* no store and no wardrobe in the strip (it is bedroom 2's entry, the gallery door inside it); the bedrooms first, the baths may shrink; both WCs at the south end of the wet wall so the stack lands in the GF WC compartment.
    ]
  ],
)

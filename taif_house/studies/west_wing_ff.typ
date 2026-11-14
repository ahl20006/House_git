// west_wing_ff.typ · Taif / Palm House · STUDY (14 Nov 2026, owner): the first-floor WEST BAND, bedrooms 2 and 3 with their baths BACK TO BACK between the two
// bedrooms (one shared wet wall, one stack), so that both bedrooms become clean rectangles. Three options W1–W3; nothing in the design files is changed.
// Fixed (studies/ff_family.typ, 14 Nov 2026): the band x 0–4.25 (axes), y 9.2–19.25; the gym south of y 19.25 behind the acoustic double wall; the gallery east of x 4.25;
// the west shaft x 0–1.5 × y 9.2–10.4; the family WC north of y 9.2; the west outer wall for the windows. CSV frame: x east, y south, wall centre lines.
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
#let gf-below = (   // data/rooms_gf.csv (V10.0 + 10–11 Nov 2026): what stands under the band; wet / service = true
  (rect-pts(0, 7.9, 2.75, 10.4), [GF utility · shaft], true), (rect-pts(0, 10.4, 2.75, 12.9), [GF hospitality kitchen], true),
  (rect-pts(0, 12.9, 2.75, 16.1), [GF powder room (the WC compartment y 14.55–16.1)], true), (rect-pts(0, 16.1, 2.75, 17.5), [GF serving passage], true),
  (rect-pts(1.25, 17.5, 2.75, 19.4), [GF guest WC], true), (rect-pts(0, 17.5, 1.25, 20.3), [GF guest passage (to y 21.4)], false), (rect-pts(2.75, 7.9, 4.25, 19.25), [GF riwaq (from y 0)], false),
)
#let gf-lines-y = (10.4, 12.9, 16.1, 17.5)       // GF walls across the band (E–W); 14.55 is the powder room's 100 mm compartment partition, not a wall
#let gf-lines-x = (1.5, 2.75)                    // the shaft's east wall (y 9.2–10.4 only) and the riwaq wall x 2.75 (the full length; it carries the floor)
#let west-run-x = 0.5                            // the GF buried west run (studies/plumbing.typ)
#let xw = 2.1                                    // the shared wet wall between the two baths

// ---------- today (studies/ff_family.typ, 14 Nov 2026) ----------
#let today = (
  rooms: (("Bedroom 2 bath", ((1.5, 9.2), (4.25, 9.2), (4.25, 11.0), (0, 11.0), (0, 10.4), (1.5, 10.4)), "wet"), ("Bedroom 2", rect-pts(0, 11.0, 4.25, 14.4), "bed"), ("Bedroom 3 bath", rect-pts(0, 14.4, 2.2, 16.1), "wet"), ("Bedroom 3", ((2.2, 14.4), (4.25, 14.4), (4.25, 19.25), (0, 19.25), (0, 16.1), (2.2, 16.1)), "bed")),
)

// ---------- helpers ----------
#let area(P) = calc.abs(range(P.len()).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, P.len())); a.at(0) * b.at(1) - b.at(0) * a.at(1) }).sum()) / 2
#let inset(P, d) = {
  let n = P.len()
  let lines = range(n).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, n)); let (dx, dy) = (b.at(0) - a.at(0), b.at(1) - a.at(1)); let L = calc.sqrt(dx * dx + dy * dy); ((a.at(0) - dy / L * d.at(i), a.at(1) + dx / L * d.at(i)), (dx, dy)) })
  range(n).map(i => { let (p1, v1) = lines.at(calc.rem(i + n - 1, n)); let (p2, v2) = lines.at(i); let den = v1.at(0) * v2.at(1) - v1.at(1) * v2.at(0); let t = ((p2.at(0) - p1.at(0)) * v2.at(1) - (p2.at(1) - p1.at(1)) * v2.at(0)) / den; (p1.at(0) + v1.at(0) * t, p1.at(1) + v1.at(1) * t) })
}
#let is-cw(P) = range(P.len()).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, P.len())); a.at(0) * b.at(1) - b.at(0) * a.at(1) }).sum() > 0
#let cw(P) = if is-cw(P) { P } else { P.rev() }
#let half(a, b) = if calc.abs(a.at(0)) < 1e-6 and calc.abs(b.at(0)) < 1e-6 { 0.125 } else { 0.10 }   // the west outer wall 0.25; every other wall 0.20 (the 100 mm partitions counted 0.20 too: on the safe side)
#let clear(P) = { let Q = cw(P); area(inset(Q, range(Q.len()).map(i => half(Q.at(i), Q.at(calc.rem(i + 1, Q.len())))))) }
#let shrink(P, d) = inset(cw(P), P.map(_ => d))
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

// ---------- the option builder: yb = the bath pair's north wall; D = the pair's depth; strip = "store" (W1) or "bedroom" (W2, W3) ----------
#let option(short, name, yb, D, strip, note) = {
  let ys = yb + D   // the pair's south wall = bedroom 3's north wall
  let bed2 = if strip == "store" { rect-pts(0, 10.4, X1, yb) } else { ((1.5, 9.2), (X1, 9.2), (X1, yb), (0, yb), (0, 10.4), (1.5, 10.4)) }
  let rooms = (if strip == "store" { (("Store (off the gallery)", rect-pts(1.5, 9.2, X1, 10.4), "store"),) } else { () }) + (
    ("Bedroom 2", bed2, "bed"), ("Bedroom 2 bath", rect-pts(0, yb, xw, ys), "wet"), ("Bedroom 3 bath", rect-pts(xw, yb, X1, ys), "wet"), ("Bedroom 3", rect-pts(0, ys, X1, Y1), "bed"))
  let sh = calc.min(0.9, D - 0.9)   // the shower's depth along y
  let furniture = (
    // bedroom 2: the bed's head on the north wall (its foot towards the bath wall), the desk under the west window, the wardrobe on the south wall (W1) or in the strip beside the shaft, its face flush with the shaft's face y 10.4 (W2, W3)
    (1.3, 10.5, 2.7, 12.5, [bed 1.4 × 2.0], "Bedroom 2"), (0.8, 10.5, 1.2, 10.95, [], "Bedroom 2"), (2.8, 10.5, 3.2, 10.95, [], "Bedroom 2"),
    (0.125, yb - 1.35, 0.725, yb - 0.15, [desk 1.2 × 0.6], "Bedroom 2"), (0.8, yb - 1.1, 1.25, yb - 0.65, [], "Bedroom 2"),
  ) + (if strip == "store" { ((2.3, yb - 0.7, 4.1, yb - 0.1, [wardrobe 1.8 × 0.6], "Bedroom 2"), (1.6, 9.3, 3.3, 9.9, [shelves], "Store (off the gallery)")) } else { ((1.6, 9.3, 4.15, 10.4, [wardrobe 2.55 × 1.0 · its face flush with the shaft's face], "Bedroom 2"),) }) + (
    // bedroom 3: the bed's head on the west wall (away from the gym's double wall), the wardrobe on the south wall, the desk on the gallery wall south of the door
    (0.125, ys + 0.6, 2.125, ys + 2.0, [bed 1.4 × 2.0], "Bedroom 3"), (0.125, ys + 0.15, 0.525, ys + 0.55, [], "Bedroom 3"), (0.125, ys + 2.05, 0.525, ys + 2.45, [], "Bedroom 3"),
    (1.0, 18.55, 2.8, 19.15, [wardrobe 1.8 × 0.6], "Bedroom 3"), (3.55, 17.4, 4.15, 18.6, [desk 1.2 × 0.6], "Bedroom 3"), (3.0, 17.75, 3.45, 18.2, [], "Bedroom 3"),
  )
  let fixtures = (
    // bath 2 (west): the basin on the west wall under the window, the shower in the south-west corner behind a fixed glass screen, the WC on the shared wet wall facing west
    (0.125, yb + 0.15, 0.55, yb + 0.7, [basin], "Bedroom 2 bath"), (0.125, ys - 0.1 - sh, 1.025, ys - 0.1, [shower 0.9 × #r1(sh) · screen], "Bedroom 2 bath"), (1.4, yb + 0.95, 2.0, yb + 1.35, [WC], "Bedroom 2 bath"),
    // bath 3 (east, by the gallery): the WC on the shared wet wall facing east, the shower in the north-east corner, the basin on the gallery wall; no window: an exhaust fan
    (2.2, yb + 0.3, 2.8, yb + 0.7, [WC], "Bedroom 3 bath"), (3.25, yb + 0.1, 4.15, yb + 0.1 + sh, [shower 0.9 × #r1(sh) · screen], "Bedroom 3 bath"), (3.7, ys - 0.6, 4.15, ys - 0.15, [basin], "Bedroom 3 bath"),
  )
  let doors = (
    ((X1, 10.6), (X1, 11.5), (-1, 0), [bedroom 2 door 0.90, from the gallery], "Bedroom 2"),
    ((1.2, yb), (1.95, yb), (0, 1), [bath 2 door 0.75, from bedroom 2, opens into the bath], "Bedroom 2 bath"),
    ((2.3, ys), (3.05, ys), (0, -1), [bath 3 door 0.75, from bedroom 3, opens into the bath], "Bedroom 3 bath"),
    ((X1, ys + 0.3), (X1, ys + 1.2), (-1, 0), [bedroom 3 door 0.90, from the gallery], "Bedroom 3"),
  ) + (if strip == "store" { (((X1, 9.4), (X1, 10.2), (-1, 0), [store door 0.80, from the gallery], "Store (off the gallery)"),) } else { () })
  let windows = (((0, 11.3), (0, 12.6), [bedroom 2 escape window]), ((0, yb + 0.15), (0, yb + 0.7), [bath 2 · small, high, obscure]), ((0, ys + 0.7), (0, ys + 1.9), [bedroom 3 escape window]))
  let stack = (xw, yb + 0.85)   // in the shared wet wall between the two WCs
  (short: short, name: name, yb: yb, D: D, strip: strip, note: note, rooms: rooms, furniture: furniture, fixtures: fixtures, doors: doors, windows: windows, stack: stack)
}
#let W1 = option("W1", [W1 · the pair side by side; bedroom 2's north wall straight on y 10.4; the strip by the shaft a store off the gallery], 13.925, 1.8, "store", [the pair shifted south until the two bedrooms match])
#let W2 = option("W2", [W2 (the owner's idea) · as W1, the strip belongs to bedroom 2: a deep wardrobe beside the shaft, its face flush with the shaft's face], 13.55, 1.8, "bedroom", [the strip's 3.3 m² go to bedroom 2, so the pair shifts 0.375 m north to keep the rooms equal])
#let W3 = option("W3", [W3 · as W2, the pair's walls on the ground-floor lines y 14.4–16.1 (the owner's brief; only y 16.1 is a GF wall today)], 14.4, 1.7, "bedroom", [the pair where the old bath 3 was: on the GF wall y 16.1 and the old line y 14.4; the rooms unequal])
#let options = (W1, W2, W3)

// ---------- checks ----------
#let tile-ok(L) = calc.abs(area(band) - area(shaft) - L.rooms.map(r => area(r.at(1))).sum()) < 0.01 and no-overlaps(L.rooms.map(r => bbox(r.at(1))))
#let in-rooms(L, items) = items.all(f => { let P = P-of(L, f.at(5)); P != none and box-in(bx(f), P) })
#let fix-ok(L) = in-rooms(L, L.fixtures) and no-overlaps(L.fixtures.map(bx))
#let furn-ok(L) = in-rooms(L, L.furniture) and no-overlaps(L.furniture.map(bx))
#let swings-ok(L) = L.doors.map(swing-box).all(s => (L.furniture + L.fixtures).map(bx).all(b => not overlap(s, b)))
#let baths-ok(L) = Cz(L, "Bedroom 2 bath") >= 3.0 - 1e-6 and Cz(L, "Bedroom 3 bath") >= 3.0 - 1e-6
#let equal-ok(L) = calc.abs(Cz(L, "Bedroom 2") - Cz(L, "Bedroom 3")) <= 0.5 + 1e-6
#let stack-ok(L) = gf-below.any(g => g.at(2) and inside(L.stack, g.at(0)))
#let jog-ok(L) = L.rooms.all(r => not jog(r.at(1)))
#let bed-head-ok(L) = {   // no bath door facing a bed head: bath 2's door is on bedroom 2's south wall (the bed's head north); bath 3's door on bedroom 3's north wall (the bed's head west)
  let d2 = L.doors.at(1); let d3 = L.doors.at(2); d2.at(0).at(1) > 12.5 and d3.at(0).at(0) > 2.125 }
#let checks(L) = (
  ([the rooms and the shaft tile the band, no overlaps], tile-ok(L)),
  ([fixtures inside their baths, no overlaps], fix-ok(L)),
  ([furniture inside its rooms, no overlaps], furn-ok(L)),
  ([every door leaf swings clear of furniture and fixtures], swings-ok(L)),
  ([each bath ≥ 3.0 m² clear (bath 2 #r2(Cz(L, "Bedroom 2 bath")), bath 3 #r2(Cz(L, "Bedroom 3 bath")))], baths-ok(L)),
  ([the two bedrooms within 0.5 m² clear (#r2(Cz(L, "Bedroom 2")) / #r2(Cz(L, "Bedroom 3")))], equal-ok(L)),
  ([the stack lands in a wet / service room below], stack-ok(L)),
  ([no jog: no small step (a return under 1.0 m) in any room], jog-ok(L)),
  ([no bath door faces a bed head], bed-head-ok(L)),
)
#let all-ok(L) = checks(L).all(c => c.at(1))
#let walls-on-gf(L) = { let ys = L.yb + L.D; ((if L.strip == "store" { (10.4,) } else { () }) + (L.yb, ys)).filter(y => gf-lines-y.any(g => calc.abs(g - y) < 1e-6)) }
#let walls-off-gf(L) = { let ys = L.yb + L.D; ((if L.strip == "store" { (10.4,) } else { () }) + (L.yb, ys)).filter(y => not gf-lines-y.any(g => calc.abs(g - y) < 1e-6)) }
#let gf-under(p) = { let g = gf-below.find(g => inside(p, g.at(0))); if g == none { [—] } else { g.at(1) } }

// ---------- drawing (1.0 cm / m, as the presentation's sheet 04) ----------
#let q(p) = (p.at(0), -p.at(1))
#let fillc = (bed: rgb("#f6e3c0"), wet: rgb("#cfe6ef"), store: rgb("#e4ded2"))
#let plan(L, length: 1.0cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, body, size: 4.4pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, body))
  let poly(P, fill: none, stroke: none) = line(..P.map(q), close: true, fill: fill, stroke: stroke)
  let R(b, fill: none, stroke: none) = rect(q((b.at(0), b.at(1))), q((b.at(2), b.at(3))), fill: fill, stroke: stroke)
  rect(q((-0.7, 7.5)), q((6.2, 20.3)), fill: rgb("#f3efe6"), stroke: none)
  for x in range(0, 6) { line(q((x, 7.7)), q((x, 20.1)), stroke: 0.2pt + luma(220)); T((x, 7.55), str(x), size: 3.6pt, fill: gray) }
  for y in range(8, 21) { line(q((-0.3, y)), q((6.0, y)), stroke: 0.2pt + luma(220)); T((-0.45, y), str(y), size: 3.6pt, fill: gray, anchor: "east") }
  for (P, l, wet) in gf-below { poly(P, stroke: (paint: brown, dash: "dotted", thickness: 0.5pt)) }
  line(q((0, 14.55)), q((2.75, 14.55)), stroke: (paint: brown, dash: "dotted", thickness: 0.5pt)); T((1.4, 14.42), [GF compartment partition y 14.55], size: 3pt, fill: brown)
  // neighbours
  rect(q((0, 7.9)), q((2.75, 9.2)), fill: luma(236), stroke: 0.8pt + ink); T((1.4, 8.55), [family WC], size: 4pt, fill: gray)
  rect(q((2.75, 7.9)), q((4.25, 9.2)), fill: rgb("#f2efe8"), stroke: 0.8pt + ink)
  rect(q((4.25, 7.9)), q((5.8, 20.3)), fill: rgb("#f2efe8"), stroke: 0.8pt + ink); T((5.02, 14.0), [gallery (on the projection) · 1.55], size: 4pt, fill: gray, angle: 90deg)
  rect(q((0, 19.25)), q((4.25, 20.3)), fill: rgb("#d9e4f2"), stroke: 0.8pt + ink); T((2.1, 19.8), [gym · the acoustic double wall on y 19.25], size: 4pt, fill: gray)
  for (n, P, k) in L.rooms { poly(P, fill: fillc.at(k), stroke: 0.9pt + ink) }
  poly(shaft, fill: luma(205), stroke: 0.9pt + ink); T((0.75, 9.8), [west shaft], size: 4pt)
  line(q((0, 7.9)), q((0, 20.3)), stroke: 2pt + ink)
  line(q((xw, L.yb)), q((xw, L.yb + L.D)), stroke: 2.4pt + blue)
  for (x0, y0, x1, y1, l, rm) in L.furniture { R((x0, y0, x1, y1), fill: rgb("#fbf6ea"), stroke: 0.45pt + rgb("#8a7a5a")); T(((x0 + x1) / 2, (y0 + y1) / 2), l, size: 3.4pt, angle: if (y1 - y0) > (x1 - x0) * 1.4 { 90deg } else { 0deg }) }
  for (x0, y0, x1, y1, l, rm) in L.fixtures { R((x0, y0, x1, y1), fill: white, stroke: 0.45pt + blue); T(((x0 + x1) / 2, (y0 + y1) / 2), l, size: 3.2pt, fill: blue, angle: if (y1 - y0) > (x1 - x0) * 1.4 { 90deg } else { 0deg }) }
  for d in L.doors { line(q(d.at(0)), q(d.at(1)), stroke: 3pt + red); let s = swing-box(d); if s != none { R(s, stroke: (paint: red, thickness: 0.35pt, dash: "dashed")) } }
  for (a, b, l) in L.windows { line(q(a), q(b), stroke: (paint: blue, thickness: 2.2pt, dash: "dashed")) }
  circle(q(L.stack), radius: 0.14, fill: brown, stroke: none); T((L.stack.at(0) + 0.2, L.stack.at(1)), [stack], size: 3.6pt, fill: brown, anchor: "west")
  for y in gf-lines-y { line(q((-0.6, y)), q((-0.35, y)), stroke: 1pt + brown); T((-0.62, y), [GF], size: 3pt, fill: brown, anchor: "east") }
  for (n, P, k) in L.rooms { let b = bbox(P); let c = if n == "Bedroom 2" { (2.9, 12.0) } else if n == "Bedroom 3" { (2.9, L.yb + L.D + 1.3) } else if n == "Bedroom 2 bath" { (1.45, L.yb + 0.42) } else if n == "Bedroom 3 bath" { (2.9, L.yb + 1.3) } else { (3.75, 9.6) }
    T(c, [*#n*\ #r2(area(P)) · ≈ #r2(clear(P))], size: if k == "wet" or k == "store" { 3.6pt } else { 4.4pt }) }
  line(q((0, 20.6)), q((1, 20.6)), stroke: 1pt + ink); T((0.5, 20.85), [1 m], size: 4pt)
})

// ======================= PAGE 1 · comparison and recommendation =======================
#text(13pt, weight: "bold", fill: accent)[First-floor west band · bedrooms 2 and 3 with their baths back to back (W1–W3)] #h(1fr) #text(6.6pt, fill: gray)[study · 14 Nov 2026 · nothing in the design files changed · m² on axes · *clear* inside the walls (west wall 0.125, others 0.10 a side)]
#v(1pt) #line(length: 100%, stroke: 0.6pt + accent)
#let AC(L, n) = { let P = P-of(L, n); if P == none { [—] } else { [#r2(area(P)) · *#r2(clear(P))*] } }
#grid(columns: (1.15fr, 1fr), column-gutter: 12pt,
  [
    #table(columns: (1.5fr, 1fr, 1fr, 1fr, 1fr), stroke: 0.3pt + luma(190), inset: 2.6pt, align: (left, right, right, right, right), fill: (_, y) => if y == 0 { rgb("#e1e9e3") } else if calc.even(y) { rgb("#efece4") },
      table.header([*axes · clear m²*], [*Today*], [*W1*], [*W2*], [*W3*]),
      [Bedroom 2], AC(today, "Bedroom 2"), AC(W1, "Bedroom 2"), AC(W2, "Bedroom 2"), AC(W3, "Bedroom 2"),
      [Bedroom 3], AC(today, "Bedroom 3"), AC(W1, "Bedroom 3"), AC(W2, "Bedroom 3"), AC(W3, "Bedroom 3"),
      [the two bedrooms differ by (clear)], [#r2(calc.abs(Cz(today, "Bedroom 2") - Cz(today, "Bedroom 3")))], [#r2(calc.abs(Cz(W1, "Bedroom 2") - Cz(W1, "Bedroom 3")))], [#r2(calc.abs(Cz(W2, "Bedroom 2") - Cz(W2, "Bedroom 3")))], [#r2(calc.abs(Cz(W3, "Bedroom 2") - Cz(W3, "Bedroom 3")))],
      [Bath 2], AC(today, "Bedroom 2 bath"), AC(W1, "Bedroom 2 bath"), AC(W2, "Bedroom 2 bath"), AC(W3, "Bedroom 2 bath"),
      [Bath 3], AC(today, "Bedroom 3 bath"), AC(W1, "Bedroom 3 bath"), AC(W2, "Bedroom 3 bath"), AC(W3, "Bedroom 3 bath"),
      [Store off the gallery], [—], AC(W1, "Store (off the gallery)"), [—], [—],
      [Bath pair (axes y)], [—], [#r2(W1.yb)–#r2(W1.yb + W1.D)], [#r2(W2.yb)–#r2(W2.yb + W2.D)], [#r2(W3.yb)–#r2(W3.yb + W3.D)],
      [New E–W walls on GF walls], [—], [#walls-on-gf(W1).map(r2).join(", ")], [#if walls-on-gf(W2).len() == 0 [none] else [#walls-on-gf(W2).map(r2).join(", ")]], [#walls-on-gf(W3).map(r2).join(", ")],
      [… light partitions on the slab], [—], [#walls-off-gf(W1).map(r2).join(", ")], [#walls-off-gf(W2).map(r2).join(", ")], [#walls-off-gf(W3).map(r2).join(", ")],
      [The stack lands on the GF in], [—], [#gf-under(W1.stack)], [#gf-under(W2.stack)], [#gf-under(W3.stack)],
      [Checks (9)], [—], [#if all-ok(W1) [passed] else [#checks(W1).filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]], [#if all-ok(W2) [passed] else [#checks(W2).filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]], [#if all-ok(W3) [passed] else [#checks(W3).filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]],
    )
    #v(2pt)
    #text(6.4pt, fill: gray)[Today = `studies/ff_family.typ` (14 Nov 2026): bedroom 2 14.45 and bedroom 3 16.87 on axes, bath 2 5.85, bath 3 3.74 (≈ 3.0 clear). The nine checks: the rooms tile the band; fixtures and furniture inside, no overlaps; door swings clear; each bath ≥ 3.0 clear; the bedrooms within 0.5 m²; the stack over a wet / service room; no small jog; no bath door facing a bed head. The two bath walls across the band and the shared wet wall x #r2(xw) are the only new walls; the shaft, the family WC, the gallery, the gym wall and the west outer wall do not move.]
    #v(3pt)
    #H[Common to the three]
    #text(6.8pt)[
      - *The pair:* bath 2 on the west (x 0–#r2(xw), its window in the west wall: the basin under it, the shower in the south-west corner behind a fixed glass screen, the WC on the shared wall), bath 3 on the east (x #r2(xw)–4.25, by the gallery: the WC on the shared wall, the shower in the north-east corner, the basin on the gallery wall; no window, an exhaust fan). *One stack in the shared wet wall* between the two WCs (0.5 m from each pan; the showers ≤ 1.5 m, the basins ≤ 2.2 m), dropping straight into the GF powder room (wet over wet) and on to the buried west run at x #r2(west-run-x) (≈ 1.7 m in the GF floor build-up).
      - *Doors:* bath 2 from bedroom 2 in the pair's north wall, bath 3 from bedroom 3 in its south wall, both 0.75 opening into the bath; the bedroom doors 0.90 from the gallery, opening into the rooms. Bedroom 2's bed has its head on the north wall, bedroom 3's on the west wall (away from the gym's double wall): no bath door faces a bed head; from each gallery door one sees the bed's side (a 4.25 m room: unavoidable) and the desk, never a bath.
      - *Structure:* the band's slab is the solid 0.20 west slab on the GF riwaq wall x 2.75 and the outer wall; the pair's two cross walls and the wet wall are 0.20 block partitions on the slab (the wet wall carries the stack and two wall-hung frames: a line load mid-bay, for the engineer); W1's y 10.4 wall and W3's y 16.1 wall stand on GF walls.
    ]
  ],
  [
    #box(fill: accent.lighten(86%), stroke: 1pt + accent, inset: 6pt, radius: 3pt, width: 100%)[
      #text(9.5pt, weight: "bold", fill: accent)[The study's view (the owner decides): W2] \
      #text(7pt)[
        *W2*, the owner's idea, gives two equal bedrooms (#r2(Cz(W2, "Bedroom 2")) and #r2(Cz(W2, "Bedroom 3")) m² clear, both clean rectangles once the deep wardrobe fills the strip beside the shaft and its face runs flush with the shaft's face on y 10.4), two baths of #r2(Cz(W2, "Bedroom 2 bath")) m² clear back to back on one stack, and the shaft swallowed inside bedroom 2's wardrobe wall. Its price: the two cross walls and the wet wall are light partitions on the slab (none on a GF wall), and the stack lands in the GF powder room's basin zone, where it must be boxed against the compartment partition.
        \ *W1* is the simplest build (bedroom 2's north wall on the GF wall y 10.4, a store off the gallery for linen and cleaning), with the same baths and the stack landing inside the GF WC compartment; the rooms are #r2(Cz(W1, "Bedroom 2")) / #r2(Cz(W1, "Bedroom 3")) m², #r2(Cz(W2, "Bedroom 2") - Cz(W1, "Bedroom 2")) less each than W2.
        \ *W3* keeps the pair where the old bath 3 was: its south wall on the GF wall y 16.1, but y 14.4 is no longer a GF wall (the GF powder room runs 12.9–16.1; its compartment partition is at 14.55), the baths fall to #r2(Cz(W3, "Bedroom 2 bath")) m² clear and the rooms differ by #r2(calc.abs(Cz(W3, "Bedroom 2") - Cz(W3, "Bedroom 3"))) m²: it fails two of the nine checks.
        \ *Compared with today:* bedroom 2 gains #r2(Cz(W2, "Bedroom 2") - Cz(today, "Bedroom 2")) m² clear and loses its niche bath (5.85 → #r2(Az(W2, "Bedroom 2 bath")) on axes, still ≥ 3 clear); bedroom 3 loses #r2(Cz(today, "Bedroom 3") - Cz(W2, "Bedroom 3")) m² and its L-shaped entry; both baths get a window-or-fan, a screen shower and one stack instead of two.
      ]
    ]
    #v(4pt)
    #box(fill: rgb("#f4efe3"), stroke: 0.6pt + luma(170), inset: 6pt, radius: 3pt, width: 100%)[
      #ah[
        #text(9pt, weight: "bold", fill: accent)[الخلاصة بالعربية] \
        #text(7.4pt)[
          فكرة المالك (14 نوفمبر 2026): حمّاما غرفتي النوم 2 و3 ظهرًا لظهر بين الغرفتين (جدار رطب واحد وماسورة واحدة) فتصير الغرفتان مستطيلين نظيفين. \
          *W1:* الحمّامان جنبًا إلى جنب عبر الشريط، جدار الغرفة 2 الشمالي مستقيم على y 10.4 فوق جدار أرضي، والشريط بجانب الشفت مخزن من الممر؛ الغرفتان #r2(Cz(W1, "Bedroom 2")) و#r2(Cz(W1, "Bedroom 3")) م² صافية. \
          *W2 (فكرة المالك، رأي الدراسة):* كما W1 لكن الشريط لغرفة النوم 2 بدولاب عميق بجانب الشفت واجهته على خط الشفت y 10.4 فيختفي الصندوق؛ الغرفتان #r2(Cz(W2, "Bedroom 2")) و#r2(Cz(W2, "Bedroom 3")) م²، والحمّامان #r2(Cz(W2, "Bedroom 2 bath")) م² لكل منهما. \
          *W3:* كما W2 لكن جدارا الحمّامين على الخطين y 14.4–16.1؛ خط 14.4 لم يعد جدارًا أرضيًا، والحمّامان أصغر (#r2(Cz(W3, "Bedroom 2 bath")) م²) والغرفتان غير متساويتين (فرق #r2(calc.abs(Cz(W3, "Bedroom 2") - Cz(W3, "Bedroom 3"))) م²).
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
      #table(columns: (1.4fr, 1fr, 1fr, 1fr), stroke: 0.3pt + luma(190), inset: 2.4pt, align: (left, right, right, right), fill: (_, y) => if y == 0 { rgb("#e1e9e3") } else if calc.even(y) { rgb("#efece4") },
        table.header([*Room*], [*axes w × d*], [*axes m²*], [*clear m²*]),
        ..L.rooms.map(r => { let b = bbox(r.at(1)); ([#r.at(0)], [#r2(b.at(2) - b.at(0)) × #r2(b.at(3) - b.at(1))#if r.at(1).len() > 4 [ (L)]], [#r2(area(r.at(1)))], [*#r2(clear(r.at(1)))*]) }).join(),
        [today: bedroom 2 · bedroom 3], [4.25 × 3.40 · L], [#r2(Az(today, "Bedroom 2")) · #r2(Az(today, "Bedroom 3"))], [#r2(Cz(today, "Bedroom 2")) · #r2(Cz(today, "Bedroom 3"))],
        [today: bath 2 · bath 3], [L · 2.20 × 1.70], [#r2(Az(today, "Bedroom 2 bath")) · #r2(Az(today, "Bedroom 3 bath"))], [#r2(Cz(today, "Bedroom 2 bath")) · #r2(Cz(today, "Bedroom 3 bath"))],
      )
      #text(6.4pt)[*Checks:* #if all-ok(L) [passed (#checks(L).len())] else [FAILED: #checks(L).filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]. Bath pair y #r2(L.yb)–#r2(ys) (#r2(L.D) deep on axes, #r2(L.D - 0.2) clear); the baths #r2(xw - 0.125 - 0.1) and #r2(X1 - xw - 0.2) wide clear; the bedrooms #r2(X1 - 0.225) wide clear, bedroom 2 #r2(L.yb - 10.4 - 0.2) deep#if L.strip != "store" [ (+ the 1.0 m wardrobe strip)], bedroom 3 #r2(Y1 - ys - 0.2) deep.]
      #H[Drainage]
      #text(6.8pt)[
        - *The stack* in the shared wet wall x #r2(xw) at y #r2(L.stack.at(1)), between the two wall-hung pans (0.5 m from each); the showers' floor drains ≈ #r1(dist((0.6, ys - 0.5), L.stack)) m (bath 2) and ≈ #r1(dist((3.7, L.yb + 0.5), L.stack)) m (bath 3); the basins ≈ #r1(dist((0.35, L.yb + 0.4), L.stack)) m and ≈ #r1(dist((3.9, ys - 0.4), L.stack)) m, all in the floor build-up or the wet wall's chase, 100 mm waste, falls ≥ 1 : 60.
        - *On the ground floor* it lands in the *#gf-under(L.stack)* (wet over wet), #if L.stack.at(1) > 14.55 [inside the WC compartment, boxed 0.30 × 0.30 in the corner with the compartment's north partition] else [in the basin zone north of the compartment partition, boxed 0.30 × 0.30 against that partition], then ≈ #r1(L.stack.at(0) - west-run-x) m in the GF floor build-up to the buried west run (x #r2(west-run-x)); a cleanout at the foot, a vent up through the bath pair to the roof (or an air-admittance valve, the engineer's choice).
        - *Today's two stacks* (the shaft's for bath 2, the family WC's FWC stack at (1.5, 14.9) for bath 3) become one; the family WC keeps its own waste to the shaft (14 Nov 2026).
      ]
      #H[Structure]
      #text(6.8pt)[
        - *On GF walls:* #if walls-on-gf(L).len() == 0 [none of the new E–W walls] else [the E–W wall(s) on y #walls-on-gf(L).map(r2).join(", ")]; the band's long walls (x 0, x 4.25) and the gym wall y 19.25 are as today. *Light partitions on the slab* (0.20 block, ≤ 3.2 m high): the E–W wall(s) on y #walls-off-gf(L).map(r2).join(", ") and the wet wall x #r2(xw) (y #r2(L.yb)–#r2(ys)), which carries the stack and the two WC frames: a line load mid-way between the GF riwaq wall x 2.75 and the outer wall on the solid 0.20 slab (2.75 m bay): for the engineer's list. #if L.strip == "store" [The store's partition x 1.5 continues the shaft's east wall.] else [The shaft's box stays; the wardrobe in front of it is joinery, not a wall.]
        - *Removed from today:* bath 2's niche walls (y 11.0, x 1.5 south of the shaft) and bath 3's walls (y 14.4, x 2.2); the GF walls below (y 10.4, 12.9, 16.1, 17.5; x 2.75) are untouched.
      ]
      #H[Doors and what you see]
      #text(6.8pt)[
        - *Bedroom 2* (x 4.25, y 10.6–11.5, opening in): the bed's side and the desk under the west window; the bath door in the south wall is out of the line of the bed's head. #if L.strip == "store" [The store (x 1.5–4.25 × 9.2–10.4, #r2(Cz(L, "Store (off the gallery)")) m² clear) has its own 0.80 door from the gallery.] else [The deep wardrobe (2.55 × 1.0, double rail) fills the strip: from the door the north wall reads as one line.]
        - *Bath 2* (y #r2(L.yb), x 1.2–1.95, opening in): the basin and its window first, the WC on the right behind the leaf, the shower screen ahead.
        - *Bath 3* (y #r2(ys), x 2.3–3.05, opening in): the WC on the left behind the leaf, the shower screen ahead, the basin on the right; no window: the fan to the roof through the pair's ceiling void.
        - *Bedroom 3* (x 4.25, y #r2(ys + 0.3)–#r2(ys + 1.2), opening in): the bed's foot end and the wardrobe on the gym wall; the bath door in the north wall beside the entry, not facing the bed.
      ]
    ],
  )
]

// west_wing_ff.typ · Taif / Palm House · STUDY (reset, 15 Nov 2026, the owner's option): the first-floor WEST BAND, bedrooms 2 and 3 with their baths BACK TO BACK, ONE option.
// 1 · X3 baths: the pair 1.4 m deep between the bedrooms; bath 2 west with a window, bath 3 east with a fan; one shared wet wall x 2.10; both WCs at its south end so the stack lands in the
//     GF powder room's WC compartment.  2 · Bedroom 2's entry: the strip beside the shaft (x 1.5–4.25, y 9.2–10.4), its door on the gallery facing the shaft; no store.
// 3 · Bedroom 3: a FULL clean rectangle from the bath pair to y 19.25 (its south wall on the beams B22 + B8); its entrance a small NOOK taken from the gym at the room's south-east corner
//     (x 3.05–4.25 × y 19.25–20.55; 1.0 × 1.2 clear), the door on x 4.25 into the nook; entering, one faces the nook's west wall (the gym's), like the shaft in bedroom 2, then turns north
//     into the room through the nook's full-width opening.  4 · The GALLERY extends south over today's nib footprint only (x 4.25–5.8, y 19.25–20.55): nothing new east of x 4.25, the clerestory's
//     sun unchanged.  5 · The gym: everything else as today; it loses the nook and the nib; its door from the court beside the gallery's end (the gallery's west wall at the end is bedroom 3's door).
// 6 · Straight orthogonal walls; the only steps are the nook's; light double gypsum walls for the nook.  THE METRIC: each bedroom's NET area = its clear area minus ONLY its entrance; the pair placed
//     so the two net areas are equal.  Nothing in the design files is changed; the earlier revisions are in the git history only. CSV frame: x east, y south, wall centre lines; the outer wall 0.25, others 0.20.
#import "@preview/cetz:0.4.2"
#import "../base.typ": dist

#set page(paper: "a4", flipped: true, margin: 8mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 7.4pt)
#set par(leading: 0.42em)
#let ink = rgb("#3d4a45"); #let accent = rgb("#2f6b4f"); #let red = rgb("#b5452f"); #let blue = rgb("#2f5f8a"); #let gray = rgb("#6d736f"); #let brown = rgb("#8a5a2b"); #let amber = rgb("#c98a12")
#let r2(v) = { let s = str(calc.round(v, digits: 2)); if not s.contains(".") { s + ".00" } else if s.split(".").at(1).len() == 1 { s + "0" } else { s } }
#let ah(t) = text(font: ("Segoe UI", "Arial", "Tahoma"), lang: "ar", dir: rtl, t)
#let rect-pts(x0, y0, x1, y1) = ((x0, y0), (x1, y0), (x1, y1), (x0, y1))

// ---------- geometry ----------
#let X1 = 4.25; #let Y0 = 9.2; #let YG = 19.25; #let YS = 24.0; #let XN = 5.8; #let YN = 20.55   // the band, the beam line, the gym's south wall, the nib's east wall and south wall (today)
#let xw = 2.1; #let D = 1.4; #let XK = 3.05               // the wet wall; the pair's depth; the nook's west wall
#let yb = 14.1; #let ys = yb + D                         // the pair y 14.10–15.50: net 2 = 4.025 (yb − 10.6) + 0.255 and net 3 = 4.025 (19.05 − ys) match within 0.05 m²
#let shaft = rect-pts(0, 9.2, 1.5, 10.4)
#let strip = rect-pts(1.5, 9.2, X1, 10.4)                 // bedroom 2's entrance
#let nook = rect-pts(XK, YG, X1, YN)                      // bedroom 3's entrance, taken from the gym
#let rooms = (
  ("Bedroom 2", ((1.5, 9.2), (X1, 9.2), (X1, yb), (0, yb), (0, 10.4), (1.5, 10.4)), "bed"),
  ("Bedroom 2 bath", rect-pts(0, yb, xw, ys), "wet"), ("Bedroom 3 bath", rect-pts(xw, yb, X1, ys), "wet"),
  ("Bedroom 3", rect-pts(0, ys, X1, YG), "bed"), ("Nook", nook, "nook"),
  ("Gym", ((0, YG), (XK, YG), (XK, YN), (X1, YN), (X1, YS), (0, YS)), "gym"),
)
#let gallery-ext = rect-pts(X1, YG, XN, YN)               // today's nib, now gallery
#let furniture = (   // (x0, y0, x1, y1, label, room)
  (0.125, 10.55, 2.125, 11.95, [bed 1.4 × 2.0], "Bedroom 2"), (0.125, 12.0, 0.525, 12.4, [], "Bedroom 2"), (2.15, 10.55, 2.55, 10.95, [], "Bedroom 2"),
  (0.125, yb - 1.0, 0.725, yb - 0.1, [desk 0.9 × 0.6], "Bedroom 2"), (0.8, yb - 0.85, 1.25, yb - 0.4, [], "Bedroom 2"), (2.0, yb - 0.7, 3.8, yb - 0.1, [wardrobe 1.8 × 0.6], "Bedroom 2"),
  (0.125, ys + 0.6, 2.125, ys + 2.0, [bed 1.4 × 2.0], "Bedroom 3"), (0.125, ys + 0.15, 0.525, ys + 0.55, [], "Bedroom 3"), (0.125, ys + 2.05, 0.525, ys + 2.45, [], "Bedroom 3"),
  (0.125, 18.0, 0.725, 19.1, [desk 1.1 × 0.6], "Bedroom 3"), (0.8, 18.3, 1.25, 18.75, [], "Bedroom 3"), (3.55, ys + 1.1, 4.15, ys + 2.9, [wardrobe 1.8 × 0.6], "Bedroom 3"),
)
#let gym-furn = ((0.6, 21.675, 1.4, 23.675, [treadmill 2.0 × 0.8 → S]), (1.6, 21.65, 2.6, 23.65, [mat 1.0 × 2.0]), (2.8, 21.65, 3.4, 22.85, [bike]), (2.8, 22.95, 4.1, 23.85, [weights rack 1.3 × 0.9]), (0.45, 23.775, 1.65, 23.875, [TV]))
#let zone = (0.6, 21.175, 1.4, 21.675)                    // the 0.5 m safety zone behind the treadmill
#let path = (1.5, 20.65, X1 - 0.1, 21.55)                 // the 0.9 m path from the gym door west into the gym
#let fixtures = (
  (0.125, yb + 0.1, 0.925, yb + 0.9, [shower 0.8 × 0.8 · screen], "Bedroom 2 bath"), (0.125, ys - 0.5, 0.475, ys - 0.1, [basin], "Bedroom 2 bath"), (1.4, ys - 0.5, 2.0, ys - 0.1, [WC], "Bedroom 2 bath"),
  (2.2, yb + 0.1, 3.0, yb + 0.9, [shower 0.8 × 0.8 · screen], "Bedroom 3 bath"), (2.2, ys - 0.5, 2.8, ys - 0.1, [WC], "Bedroom 3 bath"), (3.8, yb + 0.3, 4.15, yb + 0.7, [basin], "Bedroom 3 bath"),
)
#let doors = (   // (a, b, into, label, room)
  ((X1, 9.35), (X1, 10.25), (-1, 0), [bedroom 2 door 0.90, from the gallery, in the entry strip facing the shaft], "Bedroom 2"),
  ((1.2, yb), (1.9, yb), (0, 1), [bath 2 door 0.70, from bedroom 2], "Bedroom 2 bath"),
  ((3.0, ys), (3.7, ys), (0, -1), [bath 3 door 0.70, from bedroom 3], "Bedroom 3 bath"),
  ((X1, 19.4), (X1, 20.3), (-1, 0), [bedroom 3 door 0.90, from the gallery's end, into the nook, facing the nook's west wall], "Nook"),
  ((X1, 20.65), (X1, 21.55), (-1, 0), [gym door 0.90, from the court, beside the gallery's end], "Gym"),
)
#let opening = ((XK + 0.1, YG), (X1 - 0.1, YG))           // the nook's full-width opening into bedroom 3 (no leaf)
#let glass-door = ((4.4, YN), (5.5, YN))                  // the gallery's end: a glass door onto the court
#let windows = (((0, 10.7), (0, 11.8)), ((0, yb - 1.0), (0, yb - 0.2)), ((0, yb + 0.15), (0, yb + 0.85)), ((0, ys + 0.7), (0, ys + 1.9)), ((0, 18.1), (0, 19.0)), ((0, 19.6), (0, 20.9)), ((0, 22.0), (0, 23.5)), ((2.0, YS), (3.9, YS)))   // provisional marks; the gym's as today
#let stack = (xw, ys - 0.3)
#let ladder = (4.35, 21.65, 4.70, 22.95)                  // the roof ladder's recess on the gym's east wall, 0.1 m south of the gym door (today 20.65–21.95: it slides 1.0 m)
#let gf-compartment = rect-pts(0, 14.55, 2.75, 16.1)
#let gf-lines-y = (10.4, 12.9, 16.1, 17.5, 19.25, 21.4)
#let court-furn = ((5.0, 21.7, 5.75, 22.45, [armchair]), (7.1, 20.6, 7.85, 21.35, [winter armchair]), (4.4, 23.2, 5.0, 23.8, [tree pot]))
// today (studies/ff_family.typ, studies/ff_suite.typ, 14 Nov 2026)
#let today = (("Bedroom 2 bath", ((1.5, 9.2), (4.25, 9.2), (4.25, 11.0), (0, 11.0), (0, 10.4), (1.5, 10.4))), ("Bedroom 2", rect-pts(0, 11.0, 4.25, 14.4)), ("Bedroom 3 bath", rect-pts(0, 14.4, 2.2, 16.1)), ("Bedroom 3", ((2.2, 14.4), (4.25, 14.4), (4.25, 19.25), (0, 19.25), (0, 16.1), (2.2, 16.1))), ("Gym", ((0, 19.25), (5.8, 19.25), (5.8, 20.55), (4.25, 20.55), (4.25, 24), (0, 24))))
#let today-entry3 = 1.85 * 1.6                            // today's bedroom 3 entry = its notch x 2.2–4.25 × y 14.4–16.1, clear 1.85 × 1.6
#let today-gym-clear = 19.70

// ---------- helpers ----------
#let area(P) = calc.abs(range(P.len()).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, P.len())); a.at(0) * b.at(1) - b.at(0) * a.at(1) }).sum()) / 2
#let inset(P, d) = {
  let n = P.len()
  let lines = range(n).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, n)); let (dx, dy) = (b.at(0) - a.at(0), b.at(1) - a.at(1)); let L = calc.sqrt(dx * dx + dy * dy); ((a.at(0) - dy / L * d.at(i), a.at(1) + dx / L * d.at(i)), (dx, dy)) })
  range(n).map(i => { let (p1, v1) = lines.at(calc.rem(i + n - 1, n)); let (p2, v2) = lines.at(i); let den = v1.at(0) * v2.at(1) - v1.at(1) * v2.at(0); let t = ((p2.at(0) - p1.at(0)) * v2.at(1) - (p2.at(1) - p1.at(1)) * v2.at(0)) / den; (p1.at(0) + v1.at(0) * t, p1.at(1) + v1.at(1) * t) })
}
#let is-cw(P) = range(P.len()).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, P.len())); a.at(0) * b.at(1) - b.at(0) * a.at(1) }).sum() > 0
#let cw(P) = if is-cw(P) { P } else { P.rev() }
#let half(a, b) = if (calc.abs(a.at(0)) < 1e-6 and calc.abs(b.at(0)) < 1e-6) or (calc.abs(a.at(1) - YS) < 1e-6 and calc.abs(b.at(1) - YS) < 1e-6) { 0.125 } else { 0.10 }
#let clear-poly(P) = { let Q = cw(P); inset(Q, range(Q.len()).map(i => half(Q.at(i), Q.at(calc.rem(i + 1, Q.len()))))) }
#let clear(P) = area(clear-poly(P))
#let bbox(P) = (calc.min(..P.map(p => p.at(0))), calc.min(..P.map(p => p.at(1))), calc.max(..P.map(p => p.at(0))), calc.max(..P.map(p => p.at(1))))
#let inside(p, P) = { let c = false; let n = P.len(); for i in range(n) { let (xi, yi) = P.at(i); let (xj, yj) = P.at(calc.rem(i + n - 1, n)); if ((yi > p.at(1)) != (yj > p.at(1))) and (p.at(0) < (xj - xi) * (p.at(1) - yi) / (yj - yi) + xi) { c = not c } }; c }
#let overlap(a, b) = not (a.at(2) <= b.at(0) + 1e-9 or b.at(2) <= a.at(0) + 1e-9 or a.at(3) <= b.at(1) + 1e-9 or b.at(3) <= a.at(1) + 1e-9)
#let bx(f) = (f.at(0), f.at(1), f.at(2), f.at(3))
#let box-in(b, P) = { let e = 0.001; ((b.at(0) + e, b.at(1) + e), (b.at(2) - e, b.at(1) + e), (b.at(2) - e, b.at(3) - e), (b.at(0) + e, b.at(3) - e)).all(p => inside(p, P)) }
#let no-overlaps(L) = range(L.len()).all(i => range(L.len()).all(j => i == j or not overlap(L.at(i), L.at(j))))
#let swing-box(d) = { let (a, b, dir) = (d.at(0), d.at(1), d.at(2)); let w = dist(a, b); let (x0, x1, y0, y1) = (calc.min(a.at(0), b.at(0)), calc.max(a.at(0), b.at(0)), calc.min(a.at(1), b.at(1)), calc.max(a.at(1), b.at(1)))
  if dir.at(1) < 0 { (x0, y0 - w, x1, y0) } else if dir.at(1) > 0 { (x0, y0, x1, y0 + w) } else if dir.at(0) > 0 { (x0, y0, x0 + w, y1) } else { (x0 - w, y0, x0, y1) } }
#let P-of(n) = rooms.find(r => r.at(0) == n).at(1)
#let T-of(n) = today.find(r => r.at(0) == n).at(1)
#let hatch = tiling(size: (3pt, 3pt))[#place(line(start: (0pt, 3pt), end: (3pt, 0pt), stroke: 0.35pt + accent))]
// the NET areas: bedroom 2 = its clear area minus the entry strip (x 1.6–4.15 × y 9.3–10.4, open to the room on its south side); bedroom 3 = its clear rectangle (the nook is a room of its own)
#let strip-clear = (X1 - 0.1 - 1.6) * (10.4 - 9.3)
#let net2-poly = ((0.125, 10.5), (1.6, 10.5), (1.6, 10.4), (X1 - 0.1, 10.4), (X1 - 0.1, yb - 0.1), (0.125, yb - 0.1))
#let clear2 = clear(P-of("Bedroom 2")); #let net2 = clear2 - strip-clear
#let clear3 = clear(P-of("Bedroom 3")); #let nook-clear = clear(nook) + (X1 - XK - 0.2) * 0.1   // the nook's north side is open: no wall there
#let net3 = clear3
#let gym-clear = clear(P-of("Gym"))
// quick checks
#let gym-P = clear-poly(P-of("Gym"))
#let ok = (
  calc.abs(area(rect-pts(0, Y0, X1, YS)) - area(shaft) - rooms.map(r => area(r.at(1))).sum()) < 0.01,
  (furniture + fixtures).all(f => box-in(bx(f), P-of(f.at(5)))) and no-overlaps(furniture.map(bx)) and no-overlaps(fixtures.map(bx)) and furniture.map(bx).all(b => not overlap(b, bbox(strip))),
  doors.map(swing-box).all(s => (furniture + fixtures + gym-furn).map(bx).all(b => not overlap(s, b))),
  calc.abs(net2 - net3) <= 0.3,
  inside(stack, gf-compartment),
  gym-furn.map(bx).all(b => box-in(b, P-of("Gym"))) and no-overlaps(gym-furn.map(bx)) and gym-furn.map(bx).all(b => not overlap(b, zone) and not overlap(b, path)),
  (court-furn.map(bx) + (ladder,)).all(b => not overlap(b, (4.4, YN, 5.5, YN + 1.1))),   // the glass door's swing in the court
)
#let all-ok = ok.all(v => v)

// ======================= PAGE 1 · the plan =======================
#text(13pt, weight: "bold", fill: accent)[First-floor west band · bedrooms 2 and 3 with their baths back to back · bedroom 3's entry nook in the gym · the owner's option (15 Nov 2026)] #h(1fr) #text(6.8pt, fill: gray)[study · nothing in the design files changed · 1 : 100 (1.0 cm / m, as sheet 04) · CSV frame, north up]
#v(1pt) #line(length: 100%, stroke: 0.6pt + accent)
#let q(p) = (p.at(0), -p.at(1))
#grid(columns: (auto, 1fr), column-gutter: 14pt,
  cetz.canvas(length: 1.0cm, {
    import cetz.draw: *
    let T(p, body, size: 4.4pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, body))
    let poly(P, fill: none, stroke: none) = line(..P.map(q), close: true, fill: fill, stroke: stroke)
    let R(b, fill: none, stroke: none) = rect(q((b.at(0), b.at(1))), q((b.at(2), b.at(3))), fill: fill, stroke: stroke)
    rect(q((-0.7, 7.5)), q((7.8, 24.4)), fill: rgb("#f3efe6"), stroke: none)
    for x in range(0, 8) { line(q((x, 7.7)), q((x, 24.2)), stroke: 0.2pt + luma(220)); T((x, 7.55), str(x), size: 3.6pt, fill: gray) }
    for y in range(8, 25) { line(q((-0.3, y)), q((7.6, y)), stroke: 0.2pt + luma(220)); T((-0.45, y), str(y), size: 3.6pt, fill: gray, anchor: "east") }
    poly(gf-compartment, fill: rgb("#f0d9c0").transparentize(60%), stroke: (paint: brown, dash: "dotted", thickness: 0.5pt)); T((1.4, 14.42), [GF powder room's WC compartment below (y 14.55–16.1)], size: 3pt, fill: brown)
    for y in gf-lines-y { line(q((-0.6, y)), q((-0.35, y)), stroke: 1pt + brown); T((-0.62, y), [GF], size: 3pt, fill: brown, anchor: "east") }
    rect(q((0, 7.9)), q((2.75, 9.2)), fill: luma(236), stroke: 0.8pt + ink); T((1.4, 8.55), [family WC], size: 4pt, fill: gray)
    rect(q((2.75, 7.9)), q((4.25, 9.2)), fill: rgb("#f2efe8"), stroke: 0.8pt + ink)
    rect(q((4.25, 7.9)), q((5.8, YG)), fill: rgb("#f2efe8"), stroke: 0.8pt + ink); T((5.02, 13.5), [gallery (on the projection) · 1.55], size: 4pt, fill: gray, angle: 90deg)
    poly(gallery-ext, fill: rgb("#f2efe8"), stroke: 0.8pt + ink); T((5.02, 19.9), [gallery · the nib's place], size: 3.0pt, fill: gray, angle: 90deg)
    line(q((4.25, YG)), q((5.8, YG)), stroke: (paint: luma(150), thickness: 0.6pt, dash: "dashed"))
    rect(q((5.8, YG)), q((7.6, YS)), fill: rgb("#eef5e8"), stroke: 0.8pt + ink); T((6.9, 23.3), [suite court (to x 10)], size: 4pt, fill: gray)
    R((5.9, 19.35, 7.6, 20.55), fill: none, stroke: (paint: accent, thickness: 0.4pt, dash: "dotted")); T((6.7, 19.5), [the court's 1.2 m door strip], size: 3pt, fill: accent)
    for (x0, y0, x1, y1, l) in court-furn { R((x0, y0, x1, y1), fill: white, stroke: (paint: luma(140), thickness: 0.4pt, dash: "dashed")); T(((x0 + x1) / 2, (y0 + y1) / 2), l, size: 3pt, fill: gray) }
    for (n, P, k) in rooms { poly(P, fill: if k == "wet" { rgb("#cfe6ef") } else if k == "gym" { rgb("#d9e4f2") } else if k == "nook" { rgb("#efe8d6") } else { rgb("#f6e3c0") }, stroke: 0.9pt + ink) }
    R(bbox(strip), fill: none, stroke: (paint: accent, thickness: 0.4pt, dash: "dotted")); T((2.9, 9.45), [entry strip · kept clear], size: 3.4pt, fill: accent)
    poly(shaft, fill: luma(205), stroke: 0.9pt + ink); T((0.75, 9.8), [west shaft], size: 4pt)
    line(q((0, 7.9)), q((0, YS)), stroke: 2pt + ink); line(q((0, YS)), q((7.6, YS)), stroke: 2pt + ink)
    line(q((xw, yb)), q((xw, ys)), stroke: 2.4pt + blue)
    line(q((0, YG)), q((XK, YG)), stroke: 3.2pt + red); T((1.5, YG - 0.18), [the double wall on B22 + B8, as today], size: 3.4pt, fill: red)
    line(q(opening.at(0)), q(opening.at(1)), stroke: 2.2pt + rgb("#efe8d6")); line(q(opening.at(0)), q(opening.at(1)), stroke: (paint: red, thickness: 1.2pt, dash: "dashed"))
    R(zone, fill: none, stroke: (paint: amber, thickness: 0.4pt, dash: "dotted")); T((1.0, 21.42), [0.5 zone], size: 3pt, fill: amber)
    R(path, fill: none, stroke: (paint: accent, thickness: 0.4pt, dash: "dotted")); T((2.8, 21.1), [0.9 m path], size: 3.2pt, fill: accent)
    for (x0, y0, x1, y1, l) in gym-furn { R((x0, y0, x1, y1), fill: rgb("#fbf6ea"), stroke: 0.45pt + rgb("#8a7a5a")); T(((x0 + x1) / 2, (y0 + y1) / 2), l, size: 3.3pt, angle: if (y1 - y0) > (x1 - x0) * 1.4 { 90deg } else { 0deg }) }
    R(ladder, fill: rgb("#c9a86a"), stroke: 0.5pt + ink); T((ladder.at(2) + 0.08, (ladder.at(1) + ladder.at(3)) / 2), [ladder recess], size: 3pt, fill: brown, anchor: "west", angle: 90deg)
    for (x0, y0, x1, y1, l, rm) in furniture { R((x0, y0, x1, y1), fill: rgb("#fbf6ea"), stroke: 0.45pt + rgb("#8a7a5a")); T(((x0 + x1) / 2, (y0 + y1) / 2), l, size: 3.4pt, angle: if (y1 - y0) > (x1 - x0) * 1.4 { 90deg } else { 0deg }) }
    for (x0, y0, x1, y1, l, rm) in fixtures { R((x0, y0, x1, y1), fill: white, stroke: 0.45pt + blue); T(((x0 + x1) / 2, (y0 + y1) / 2), l, size: 3.1pt, fill: blue, angle: if (y1 - y0) > (x1 - x0) * 1.4 { 90deg } else { 0deg }) }
    for d in doors { line(q(d.at(0)), q(d.at(1)), stroke: 3pt + red); R(swing-box(d), stroke: (paint: red, thickness: 0.35pt, dash: "dashed")) }
    line(q(glass-door.at(0)), q(glass-door.at(1)), stroke: 3pt + blue); R((4.4, YN, 5.5, YN + 1.1), stroke: (paint: blue, thickness: 0.35pt, dash: "dashed")); T((5.6, YN + 1.25), [glass door → court], size: 3.2pt, fill: blue, anchor: "west")
    for (a, b) in windows { line(q(a), q(b), stroke: (paint: blue, thickness: 2.2pt, dash: "dashed")) }
    circle(q(stack), radius: 0.14, fill: brown, stroke: none); T((stack.at(0) + 0.2, stack.at(1) + 0.22), [stack], size: 3.6pt, fill: brown, anchor: "west")
    // the NET areas, hatched; the entrances unhatched
    poly(net2-poly, fill: hatch, stroke: (paint: accent, thickness: 0.7pt)); T((0.25, 10.7), [NET 4.03 × #r2(yb - 10.7) (+ 2.55 × 0.10) = #r2(net2) m²], size: 3.8pt, fill: accent, anchor: "west")
    R((0.125, ys + 0.1, X1 - 0.1, YG - 0.1), fill: hatch, stroke: (paint: accent, thickness: 0.7pt)); T((0.25, ys + 0.3), [NET 4.03 × #r2(YG - ys - 0.2) = #r2(net3) m²], size: 3.8pt, fill: accent, anchor: "west")
    T((3.65, 19.5), [entrance], size: 3.2pt, fill: accent); T((2.9, 9.75), [entrance #r2(strip-clear) m²], size: 3.2pt, fill: accent)
    T((3.65, 20.15), [1.0 × 1.2 · #r2(nook-clear) m²], size: 3.0pt, fill: accent)
    for (n, P, k) in rooms.filter(r => r.at(2) != "nook") { let c = if n == "Bedroom 2" { (2.9, 12.5) } else if n == "Bedroom 3" { (2.5, 17.8) } else if n == "Bedroom 2 bath" { (1.35, yb + 1.0) } else if n == "Bedroom 3 bath" { (3.3, ys - 0.85) } else { (1.5, 20.2) }
      T(c, [*#n*\ #r2(area(P)) · ≈ #r2(clear(P))], size: if k == "wet" { 3.4pt } else { 4.6pt }) }
    line(q((0, 24.6)), q((1, 24.6)), stroke: 1pt + ink); T((0.5, 24.85), [1 m], size: 4pt)
  }),
  [
    #set text(7.2pt)
    *The option.* Between the two bedrooms the *X3 bath pair*, 1.4 m deep on axes (y #r2(yb)–#r2(ys)): bath 2 west with a small high window above its shower, bath 3 east by the gallery with an exhaust fan; one shared wet wall on x #r2(xw); both wall-hung WCs at its south end, the *stack* between them at (#r2(stack.at(0)), #r2(stack.at(1))), straight down into the GF powder room's WC compartment (#r2(stack.at(1) - 14.55) m south of its partition) and on to the buried west run; every other waste in the floor build-up, ≤ 2 m.

    *Bedroom 2:* its entrance is the strip beside the shaft (x 1.5–4.25 × y 9.2–10.4), the door 0.90 on the gallery inside it, facing the shaft's wall; no store. The bed's head on the west wall under its window, the desk at the second west window, the 1.8 m wardrobe on the bath wall east of the bath door.

    *Bedroom 3:* a full clean rectangle 4.25 × #r2(YG - ys) on axes (4.03 × #r2(YG - ys - 0.2) clear) from the bath pair to y 19.25, its south wall the double wall on the beams B22 + B8 as today. Its entrance is a *nook taken from the gym* at the room's south-east corner (x 3.05–4.25 × y 19.25–20.55, 1.0 × 1.2 clear): the door 0.90 on x 4.25 into the nook; entering, one faces the nook's west wall (the gym's), like the shaft in bedroom 2, then turns north into the room through the nook's full-width opening (1.0 m, no leaf). The bed's head on the west wall under its window, the desk at the south-west window, the 1.8 m wardrobe on the gallery wall north of the opening; the opening's approach (x 3.05–4.25, y 18.4–19.25) free. No door faces a bed's head.

    *The gallery* extends south over today's nib footprint only (x 4.25–5.8 × y 19.25–20.55): it ends at y 20.55 with a glass door 1.10 onto the court; nothing new east of x 4.25, the clerestory's sun unchanged.

    *The gym:* everything else as today; it loses the nook and the nib (#r2(today-gym-clear - gym-clear) m² clear). Its door cannot come from the extended gallery (the gallery's 1.3 m of west wall there is bedroom 3's door), so it is from the court on x 4.25 beside the gallery's end (y 20.65–21.55, into the gym), one step from the glass door; today's nib court door is not needed and not kept (the glass door is the gallery's door to the court). The equipment: the treadmill with its 0.5 m zone against the west wall, the mat, the bike and the rack east of it, the 0.9 m path from the door; the ladder recess slides 1.0 m south to y 21.65–22.95. No slivers: the nook's south wall and the gallery's end wall are one line on y 20.55 (today's nib wall).

    *Walls.* Straight and orthogonal; the only steps are the nook's (x 3.05, y 20.55). The pair's two cross walls (y #r2(yb), #r2(ys)) and the wet wall x #r2(xw): 0.20 block partitions on the solid west slab, none on a GF wall; the wet wall carries the stack and the two WC frames mid-bay (the engineer's list). The nook's two walls: light double gypsum on the men's majlis roof slab. The double wall on y 19.25 keeps its beams B22 + B8 (shortened by the opening); the gallery's end wall y 20.55 is today's nib wall line. Removed: bath 2's niche walls (y 11.0, x 1.5), bath 3's walls (y 14.4, x 2.2), the nib's north wall with its sliding door and the nib's court door. No column or beam moved; R21 (the nib's roof edge) unchanged. The windows are provisional marks.

    *The net areas* (hatched): bedroom 2 #r2(clear2) clear − the strip #r2(strip-clear) = *#r2(net2)*; bedroom 3 #r2(clear3) (the nook #r2(nook-clear) is apart) = *#r2(net3)*.

    #text(6.6pt, fill: gray)[Quick checks: #if all-ok [passed (7): the rooms and the shaft tile the band to y 24; fixtures and furniture inside their rooms, no overlaps, the entry strip clear; every door leaf clear; the net areas within 0.3 m²; the stack inside the GF WC compartment; the gym's equipment inside the gym with the zone and the path free; the glass door's swing clear of the court's furniture and the ladder.] else [FAILED: #ok.enumerate().filter(((i, v)) => not v).map(((i, v)) => str(i + 1)).join(", ")]]
  ],
)

// ======================= PAGE 2 · the table and the Arabic lines =======================
#pagebreak()
#text(13pt, weight: "bold", fill: accent)[Today vs the option] #h(1fr) #text(6.8pt, fill: gray)[m² on axes · *clear* inside the walls (the outer walls 0.125, every other wall 0.10 a side) · today = `studies/ff_family.typ`, `studies/ff_suite.typ`, 14 Nov 2026]
#v(1pt) #line(length: 100%, stroke: 0.6pt + accent)
#grid(columns: (1.15fr, 1fr), column-gutter: 16pt,
  [
    #table(columns: (1.5fr, 1fr, 1.1fr), stroke: 0.3pt + luma(190), inset: 3pt, align: (left, right, right), fill: (_, y) => if y == 0 { rgb("#e1e9e3") } else if calc.even(y) { rgb("#efece4") },
      table.header([], [*Today*], [*The option*]),
      [Bedroom 2 · clear · entrance · *net*], [#r2(clear(T-of("Bedroom 2"))) · 0 · *#r2(clear(T-of("Bedroom 2")))*], [#r2(clear2) · #r2(strip-clear) · *#r2(net2)*],
      [Bedroom 3 · clear · entrance · *net*], [#r2(clear(T-of("Bedroom 3"))) · #r2(today-entry3) · *#r2(clear(T-of("Bedroom 3")) - today-entry3)*], [#r2(clear3) + the nook #r2(nook-clear) · #r2(nook-clear) · *#r2(net3)*],
      [Bath 2 · bath 3 · clear], [#r2(clear(T-of("Bedroom 2 bath"))) · #r2(clear(T-of("Bedroom 3 bath")))], [#r2(clear(P-of("Bedroom 2 bath"))) · #r2(clear(P-of("Bedroom 3 bath")))],
      [Gym · clear · the equipment], [#r2(today-gym-clear) · fits], [#r2(gym-clear) · #if ok.at(5) [fits] else [does not fit]],
      [The gallery ends at y · its length from y 0.7], [19.25 · 18.55], [20.55 · 19.85],
      [Bedroom 3's door], [x 4.25, y 15.2–16.2, from the gallery], [x 4.25, y 19.4–20.3, into the nook; the opening 1.0 into the room],
      [Gym door · court doors], [sliding, from the gallery's end (the nib) · the nib's court door], [from the court, x 4.25 y 20.65–21.55 · the gallery's glass door 1.10 on y 20.55],
      [The stack lands on the GF in], [two stacks (the shaft; the FWC stack)], [one: the powder room's WC compartment, (#r2(stack.at(0)), #r2(stack.at(1)))],
      [On beams], [the double wall y 19.25 on B22 + B8], [the same (with the nook's opening); nothing else],
      [Light partitions on the slab], [y 11.0, x 1.5; y 14.4, x 2.2; the nib's walls], [y #r2(yb), y #r2(ys), x #r2(xw) (the wet wall, mid-bay); the nook's x 3.05 and y 20.55; the gallery's end wall y 20.55],
      [Columns · beams moved], [—], [none],
    )
  ],
  [
    #ah[
      #text(7.8pt)[
        الخيار: حمّاما غرفتي النوم 2 و3 ظهرًا لظهر بينهما بعمق 1.4 م، بجدار رطب واحد وماسورة واحدة تنزل في حجرة مرحاض دورة المياه الأرضية؛ غرفة النوم 2 مدخلها الشريط بجانب الشفت وبابها من الممر يواجه الشفت. \
          غرفة النوم 3 مستطيل كامل نظيف 4.03 × #r2(YG - ys - 0.2) م صافية حتى الخط y 19.25 (جدارها الجنوبي على الجسرين B22 وB8 كما هو)، ومدخلها كوّة صغيرة مأخوذة من النادي في ركنها الجنوبي الشرقي (1.0 × 1.2 م): الباب على x 4.25 إليها، تواجه جدار النادي ثم تدخل شمالًا عبر فتحة بعرض الكوّة. \
          الممر يمتد جنوبًا فوق موضع عتبة النادي اليوم فقط (x 4.25–5.8، إلى y 20.55) وينتهي بباب زجاجي على الفناء؛ لا بناء جديد شرق x 4.25 وشمس نوافذ الصالة كما هي؛ باب النادي من الفناء بجانب نهاية الممر. \
          الصافي: غرفة 2 #r2(net2) م² (الصافي الكلي #r2(clear2) ناقص شريط المدخل #r2(strip-clear))، وغرفة 3 #r2(net3) م² (الكوّة #r2(nook-clear) م² خارجه)؛ اليوم #r2(clear(T-of("Bedroom 2"))) و#r2(clear(T-of("Bedroom 3")) - today-entry3). الحمّامان #r2(clear(P-of("Bedroom 2 bath"))) و#r2(clear(P-of("Bedroom 3 bath"))) م²، والنادي #r2(gym-clear) م² بأجهزته. \
          الجدران مستقيمة والخطوتان الوحيدتان خطوتا الكوّة؛ جدارا الحمّامين والجدار الرطب وجدارا الكوّة قواطع خفيفة على البلاطة، والجدار المزدوج على الجسرين كما هو؛ لا عمود ولا جسر يتحرك؛ النوافذ علامات مؤقتة.
      ]
    ]
  ],
)

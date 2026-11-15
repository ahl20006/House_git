// west_wing_ff.typ · Taif / Palm House · STUDY (reset, 15 Nov 2026, the owner's option): the first-floor WEST BAND, bedrooms 2 and 3 as TWINS, ONE option.
// Each bedroom is entered through the same entry strip (≈ 2.55 × 1.0–1.2 clear) with a wall straight ahead, then the main room.
// 1 · X3 baths: the pair 1.4 m deep between the bedrooms; bath 2 west with a window, bath 3 east with a fan; one shared wet wall x 2.10; both WCs at its south end so the stack lands in the
//     GF powder room's WC compartment.  2 · Bedroom 2: its entry strip beside the shaft (x 1.5–4.25, y 9.2–10.4), its door on the gallery facing the shaft; no store.
// 3 · Bedroom 3: a FULL clean rectangle from the bath pair to y 19.25 (its south wall on the beams B22 + B8); its entrance an entry strip taken from the gym south of y 19.25 against x 4.25
//     (x 1.5–4.25 × y 19.25–20.55: the same width as bedroom 2's, its south wall on today's nib wall line so no sliver is left), the door on x 4.25 into the strip; entering, one faces the strip's
//     west end wall (the gym's), then turns north into the room through the opening on y 19.25.  4 · The GALLERY extends south over today's nib footprint only (x 4.25–5.8, y 19.25–20.55).
// 5 · The gym: everything else as today; west of the strip a POCKET (x 0–1.5, by the west window) takes the dumbbell rack; the main gym the treadmill + 0.5 zone, the bike, the 2.0 × 1.0 mat, a 0.9 path.
// 6 · Straight orthogonal walls; the only steps are the strip's; light double gypsum walls.  7 · The two main rooms (each bedroom minus its strip) EQUAL: the pair at y 14.125–15.525.
// Nothing in the design files is changed; the earlier revisions are in the git history only. CSV frame: x east, y south, wall centre lines; the outer walls 0.25, every other wall 0.20.
#import "@preview/cetz:0.4.2"
#import "../base.typ": dist

#set page(paper: "a4", flipped: true, margin: 8mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 7.4pt)
#set par(leading: 0.42em)
#let ink = rgb("#3d4a45"); #let accent = rgb("#2f6b4f"); #let red = rgb("#b5452f"); #let blue = rgb("#2f5f8a"); #let gray = rgb("#6d736f"); #let brown = rgb("#8a5a2b"); #let amber = rgb("#c98a12")
#let r2(v) = { let s = str(calc.round(v, digits: 2)); if not s.contains(".") { s + ".00" } else if s.split(".").at(1).len() == 1 { s + "0" } else { s } }
#let r3(v) = str(calc.round(v, digits: 3))
#let ah(t) = text(font: ("Segoe UI", "Arial", "Tahoma"), lang: "ar", dir: rtl, t)
#let rect-pts(x0, y0, x1, y1) = ((x0, y0), (x1, y0), (x1, y1), (x0, y1))

// ---------- geometry ----------
#let X1 = 4.25; #let Y0 = 9.2; #let YG = 19.25; #let YS = 24.0; #let XN = 5.8; #let YN = 20.55   // the band, the beam line, the gym's south wall, the nib's east and south walls (today)
#let xw = 2.1; #let D = 1.4; #let XS = 1.5                 // the wet wall; the pair's depth; the strips' west line (the shaft's east wall; the gym pocket's east wall)
#let yb = 14.125; #let ys = yb + D                        // the pair y 14.125–15.525: main room 2 = 4.025 (yb − 10.6) + 0.255 = main room 3 = 4.025 (19.05 − ys) + 0.255
#let shaft = rect-pts(0, 9.2, XS, 10.4)
#let strip2 = rect-pts(XS, 9.2, X1, 10.4)                 // bedroom 2's entry strip (open on its south side)
#let strip3 = rect-pts(XS, YG, X1, YN)                    // bedroom 3's entry strip (open on its north side), taken from the gym
#let pocket = rect-pts(0, YG, XS, YN)                     // the gym's pocket by the west window (open to the gym on its south side)
#let rooms = (
  ("Bedroom 2", ((XS, 9.2), (X1, 9.2), (X1, yb), (0, yb), (0, 10.4), (XS, 10.4)), "bed"),
  ("Bedroom 2 bath", rect-pts(0, yb, xw, ys), "wet"), ("Bedroom 3 bath", rect-pts(xw, yb, X1, ys), "wet"),
  ("Bedroom 3", ((0, ys), (X1, ys), (X1, YN), (XS, YN), (XS, YG), (0, YG)), "bed"),
  ("Gym", ((0, YG), (XS, YG), (XS, YN), (X1, YN), (X1, YS), (0, YS)), "gym"),
)
#let gallery-ext = rect-pts(X1, YG, XN, YN)               // today's nib, now gallery
#let furniture = (   // (x0, y0, x1, y1, label, room)
  (0.125, 10.55, 2.125, 11.95, [bed 1.4 × 2.0], "Bedroom 2"), (0.125, 12.0, 0.525, 12.4, [], "Bedroom 2"), (2.15, 10.55, 2.55, 10.95, [], "Bedroom 2"),
  (0.125, yb - 1.0, 0.725, yb - 0.1, [desk 0.9 × 0.6], "Bedroom 2"), (0.8, yb - 0.85, 1.25, yb - 0.4, [], "Bedroom 2"), (2.0, yb - 0.7, 3.8, yb - 0.1, [wardrobe 1.8 × 0.6], "Bedroom 2"),
  (0.125, ys + 0.6, 2.125, ys + 2.0, [bed 1.4 × 2.0], "Bedroom 3"), (0.125, ys + 0.15, 0.525, ys + 0.55, [], "Bedroom 3"), (0.125, ys + 2.05, 0.525, ys + 2.45, [], "Bedroom 3"),
  (0.125, 18.05, 0.725, 19.15, [desk 1.1 × 0.6], "Bedroom 3"), (0.8, 18.35, 1.25, 18.8, [], "Bedroom 3"), (3.55, ys + 1.1, 4.15, ys + 2.9, [wardrobe 1.8 × 0.6], "Bedroom 3"),
)
#let gym-furn = ((0.6, 21.675, 1.4, 23.675, [treadmill 2.0 × 0.8 → S]), (1.6, 21.65, 2.6, 23.65, [mat 1.0 × 2.0]), (2.8, 21.65, 3.4, 22.85, [bike]), (0.45, 23.775, 1.65, 23.875, [TV]), (0.15, 19.4, 1.35, 19.9, [dumbbell rack 1.2 × 0.5]))
#let zone = (0.6, 21.175, 1.4, 21.675)                    // the 0.5 m safety zone behind the treadmill
#let path = (XS, 20.65, X1 - 0.1, 21.55)                  // the 0.9 m path from the gym door west into the gym
#let fixtures = (
  (0.125, yb + 0.1, 0.925, yb + 0.9, [shower 0.8 × 0.8 · screen], "Bedroom 2 bath"), (0.125, ys - 0.5, 0.475, ys - 0.1, [basin], "Bedroom 2 bath"), (1.4, ys - 0.5, 2.0, ys - 0.1, [WC], "Bedroom 2 bath"),
  (2.2, yb + 0.1, 3.0, yb + 0.9, [shower 0.8 × 0.8 · screen], "Bedroom 3 bath"), (2.2, ys - 0.5, 2.8, ys - 0.1, [WC], "Bedroom 3 bath"), (3.8, yb + 0.3, 4.15, yb + 0.7, [basin], "Bedroom 3 bath"),
)
#let doors = (   // (a, b, into, label, room)
  ((X1, 9.35), (X1, 10.25), (-1, 0), [bedroom 2 door 0.90, from the gallery, in its strip, facing the shaft], "Bedroom 2"),
  ((1.2, yb), (1.9, yb), (0, 1), [bath 2 door 0.70, from bedroom 2], "Bedroom 2 bath"),
  ((3.0, ys), (3.7, ys), (0, -1), [bath 3 door 0.70, from bedroom 3], "Bedroom 3 bath"),
  ((X1, 19.4), (X1, 20.3), (-1, 0), [bedroom 3 door 0.90, from the gallery's end, in its strip, facing the gym's wall], "Bedroom 3"),
  ((X1, 20.65), (X1, 21.55), (-1, 0), [gym door 0.90, from the court, beside the gallery's end], "Gym"),
)
#let opening = ((XS + 0.1, YG), (X1 - 0.1, YG))           // the strip's full-width opening into bedroom 3 (no leaf), like bedroom 2's open strip
#let glass-door = ((4.4, YN), (5.5, YN))                  // the gallery's end: a glass door onto the court
#let windows = (((0, 10.7), (0, 11.8)), ((0, yb - 1.0), (0, yb - 0.2)), ((0, yb + 0.15), (0, yb + 0.85)), ((0, ys + 0.7), (0, ys + 1.9)), ((0, 18.0), (0, 18.9)), ((0, 19.6), (0, 20.4)), ((0, 22.0), (0, 23.5)), ((2.0, YS), (3.9, YS)))   // provisional marks; the gym's as today (its west one now the pocket's)
#let stack = (xw, ys - 0.3)
#let ladder = (4.35, 21.65, 4.70, 22.95)                  // the roof ladder's recess on the gym's east wall, 0.1 m south of the gym door (today 20.65–21.95: it slides 1.0 m)
#let gf-compartment = rect-pts(0, 14.55, 2.75, 16.1)
#let gf-lines-y = (10.4, 12.9, 16.1, 17.5, 19.25, 21.4)
#let court-furn = ((5.0, 21.7, 5.75, 22.45, [armchair]), (7.1, 20.6, 7.85, 21.35, [winter armchair]), (4.4, 23.2, 5.0, 23.8, [tree pot]))
// today (studies/ff_family.typ, studies/ff_suite.typ, 14 Nov 2026)
#let today = (("Bedroom 2 bath", ((1.5, 9.2), (4.25, 9.2), (4.25, 11.0), (0, 11.0), (0, 10.4), (1.5, 10.4))), ("Bedroom 2", rect-pts(0, 11.0, 4.25, 14.4)), ("Bedroom 3 bath", rect-pts(0, 14.4, 2.2, 16.1)), ("Bedroom 3", ((2.2, 14.4), (4.25, 14.4), (4.25, 19.25), (0, 19.25), (0, 16.1), (2.2, 16.1))))
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
// the entry strips (clear) and the main rooms = each bedroom's clear area minus its strip
#let strip2-clear = (X1 - 0.1 - (XS + 0.1)) * (10.4 - 9.3)          // 2.55 × 1.10: open to the room on its south side
#let strip3-clear = (X1 - 0.1 - (XS + 0.1)) * (YN - 0.1 - YG)       // 2.55 × 1.20: open to the room on its north side; its south wall on today's nib line
#let clear2 = clear(P-of("Bedroom 2")); #let main2 = clear2 - strip2-clear
#let clear3 = clear(P-of("Bedroom 3")); #let main3 = clear3 - strip3-clear
#let main2-poly = ((0.125, 10.5), (XS + 0.1, 10.5), (XS + 0.1, 10.4), (X1 - 0.1, 10.4), (X1 - 0.1, yb - 0.1), (0.125, yb - 0.1))
#let main3-poly = ((0.125, ys + 0.1), (X1 - 0.1, ys + 0.1), (X1 - 0.1, YG), (XS + 0.1, YG), (XS + 0.1, YG - 0.1), (0.125, YG - 0.1))
#let d2 = yb - 0.1 - 10.5; #let d3 = YG - 0.1 - (ys + 0.1)            // the main rooms' clear depths (the 0.10 band beside the shaft / the strip apart)
#let gym-clear = clear(P-of("Gym"))
#let grow = (4.0 - d2) + (4.0 - d3)                                  // how much the band must lengthen for both main rooms to reach 4.0 m clear
// quick checks
#let ok = (
  calc.abs(area(rect-pts(0, Y0, X1, YS)) - area(shaft) - rooms.map(r => area(r.at(1))).sum()) < 0.01,
  (furniture + fixtures).all(f => box-in(bx(f), P-of(f.at(5)))) and no-overlaps(furniture.map(bx)) and no-overlaps(fixtures.map(bx)) and furniture.map(bx).all(b => not overlap(b, bbox(strip2)) and not overlap(b, bbox(strip3))),
  doors.map(swing-box).all(s => (furniture + fixtures + gym-furn).map(bx).all(b => not overlap(s, b))),
  calc.abs(main2 - main3) <= 0.3,
  inside(stack, gf-compartment),
  gym-furn.map(bx).all(b => box-in(b, P-of("Gym"))) and no-overlaps(gym-furn.map(bx)) and gym-furn.map(bx).all(b => not overlap(b, zone) and not overlap(b, path)),
  (court-furn.map(bx) + (ladder,)).all(b => not overlap(b, (4.4, YN, 5.5, YN + 1.1))),
)
#let all-ok = ok.all(v => v)

// ======================= PAGE 1 · the plan =======================
#text(13pt, weight: "bold", fill: accent)[First-floor west band · bedrooms 2 and 3 as twins: an entry strip each, the baths back to back · the owner's option (15 Nov 2026)] #h(1fr) #text(6.8pt, fill: gray)[study · nothing in the design files changed · 1 : 100 (1.0 cm / m, as sheet 04) · CSV frame, north up]
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
    for (n, P, k) in rooms { poly(P, fill: if k == "wet" { rgb("#cfe6ef") } else if k == "gym" { rgb("#d9e4f2") } else { rgb("#f6e3c0") }, stroke: 0.9pt + ink) }
    poly(strip2, fill: rgb("#efe8d6"), stroke: none); poly(strip3, fill: rgb("#efe8d6"), stroke: none)
    poly(shaft, fill: luma(205), stroke: 0.9pt + ink); T((0.75, 9.8), [west shaft], size: 4pt)
    line(q((0, 7.9)), q((0, YS)), stroke: 2pt + ink); line(q((0, YS)), q((7.6, YS)), stroke: 2pt + ink)
    line(q((xw, yb)), q((xw, ys)), stroke: 2.4pt + blue)
    line(q((0, YG)), q((XS, YG)), stroke: 3.2pt + red); T((0.75, YG - 0.18), [double wall on B22], size: 3.2pt, fill: red)
    line(q((XS, YG)), q((XS, YN)), stroke: 0.9pt + ink); line(q((XS, YN)), q((X1, YN)), stroke: 0.9pt + ink)
    line(q(opening.at(0)), q(opening.at(1)), stroke: 2.2pt + rgb("#efe8d6")); line(q(opening.at(0)), q(opening.at(1)), stroke: (paint: red, thickness: 1.2pt, dash: "dashed")); T((2.9, YG + 0.17), [opening 2.55 · no leaf · over the beams B22 + B8], size: 3pt, fill: red)
    R(zone, fill: none, stroke: (paint: amber, thickness: 0.4pt, dash: "dotted")); T((1.0, 21.42), [0.5 zone], size: 3pt, fill: amber)
    R(path, fill: none, stroke: (paint: accent, thickness: 0.4pt, dash: "dotted")); T((2.8, 21.1), [0.9 m path], size: 3.2pt, fill: accent)
    for (x0, y0, x1, y1, l) in gym-furn { R((x0, y0, x1, y1), fill: rgb("#fbf6ea"), stroke: 0.45pt + rgb("#8a7a5a")); T(((x0 + x1) / 2, (y0 + y1) / 2), l, size: 3.3pt, angle: if (y1 - y0) > (x1 - x0) * 1.4 { 90deg } else { 0deg }) }
    T((0.75, 20.2), [gym pocket 1.28 × 1.2], size: 3.0pt, fill: gray)
    R(ladder, fill: rgb("#c9a86a"), stroke: 0.5pt + ink); T((ladder.at(2) + 0.08, (ladder.at(1) + ladder.at(3)) / 2), [ladder recess], size: 3pt, fill: brown, anchor: "west", angle: 90deg)
    for (x0, y0, x1, y1, l, rm) in furniture { R((x0, y0, x1, y1), fill: rgb("#fbf6ea"), stroke: 0.45pt + rgb("#8a7a5a")); T(((x0 + x1) / 2, (y0 + y1) / 2), l, size: 3.4pt, angle: if (y1 - y0) > (x1 - x0) * 1.4 { 90deg } else { 0deg }) }
    for (x0, y0, x1, y1, l, rm) in fixtures { R((x0, y0, x1, y1), fill: white, stroke: 0.45pt + blue); T(((x0 + x1) / 2, (y0 + y1) / 2), l, size: 3.1pt, fill: blue, angle: if (y1 - y0) > (x1 - x0) * 1.4 { 90deg } else { 0deg }) }
    for d in doors { line(q(d.at(0)), q(d.at(1)), stroke: 3pt + red); R(swing-box(d), stroke: (paint: red, thickness: 0.35pt, dash: "dashed")) }
    line(q(glass-door.at(0)), q(glass-door.at(1)), stroke: 3pt + blue); R((4.4, YN, 5.5, YN + 1.1), stroke: (paint: blue, thickness: 0.35pt, dash: "dashed")); T((5.6, YN + 1.25), [glass door → court], size: 3.2pt, fill: blue, anchor: "west")
    for (a, b) in windows { line(q(a), q(b), stroke: (paint: blue, thickness: 2.2pt, dash: "dashed")) }
    circle(q(stack), radius: 0.14, fill: brown, stroke: none); T((stack.at(0) + 0.2, stack.at(1) + 0.22), [stack], size: 3.6pt, fill: brown, anchor: "west")
    // the MAIN rooms, hatched; the entry strips unhatched
    poly(main2-poly, fill: hatch, stroke: (paint: accent, thickness: 0.7pt)); T((0.25, 10.7), [MAIN 4.03 × #r2(d2) (+ 2.55 × 0.10) = #r2(main2) m²], size: 3.8pt, fill: accent, anchor: "west")
    poly(main3-poly, fill: hatch, stroke: (paint: accent, thickness: 0.7pt)); T((0.25, ys + 0.3), [MAIN 4.03 × #r2(d3) (+ 2.55 × 0.10) = #r2(main3) m²], size: 3.8pt, fill: accent, anchor: "west")
    T((2.9, 9.45), [entry strip 2.55 × 1.10 · #r2(strip2-clear) m²], size: 3.2pt, fill: accent); T((2.9, 20.3), [entry strip 2.55 × 1.20 · #r2(strip3-clear) m²], size: 3.2pt, fill: accent)
    for (n, P, k) in rooms { let c = if n == "Bedroom 2" { (2.9, 12.5) } else if n == "Bedroom 3" { (2.5, 17.5) } else if n == "Bedroom 2 bath" { (1.5, yb + 0.45) } else if n == "Bedroom 3 bath" { (3.5, ys - 0.3) } else { (2.9, 22.9) }
      T(c, [*#n*\ #r2(area(P)) · ≈ #r2(clear(P))], size: if k == "wet" { 3.4pt } else { 4.6pt }) }
    line(q((0, 24.6)), q((1, 24.6)), stroke: 1pt + ink); T((0.5, 24.85), [1 m], size: 4pt)
  }),
  [
    #set text(7.2pt)
    *Twins.* Each bedroom is entered through the same entry strip, 2.55 m clear wide and about 1.1 m deep, with a wall straight ahead, then the main room: bedroom 2 through the strip beside the shaft (x 1.5–4.25 × y 9.2–10.4, its door 0.90 on the gallery inside it, facing the shaft's wall; no store); bedroom 3 through a strip of the same width taken from the gym south of y 19.25 (x 1.5–4.25 × y 19.25–20.55; its door 0.90 on x 4.25 from the gallery's end, facing the strip's west end wall, the gym's), then north into the room through the strip's full-width opening on y 19.25, no leaf, as bedroom 2's strip opens into its room. Bedroom 3's strip is 1.2 m deep, 0.1 m more than bedroom 2's, because its south wall is put on today's nib wall line (y 20.55) so that no sliver of the nib is left.

    *The main rooms* (hatched): bedroom 2 4.03 × #r2(d2) and bedroom 3 4.03 × #r2(d3) clear, each #r2(main2) m² with the 0.10 m band beside the shaft / the strip; bedroom 3 a full clean rectangle from the bath pair to y 19.25. The bath pair sits at y #r2(yb)–#r2(ys) to make them equal (on the 2.5 cm, not the 5 cm, grid). In each: the bed's head on the west wall under its window, the desk at the second west window, the 1.8 m wardrobe (bedroom 2 on the bath wall east of the bath door, bedroom 3 on the gallery wall north of the bath door's approach). No door faces a bed's head.

    *X3 baths* between the rooms, 1.4 m deep on axes: bath 2 west with a small high window above its shower, bath 3 east by the gallery with a fan; one shared wet wall x #r2(xw), both wall-hung WCs at its south end, the stack at (#r2(stack.at(0)), #r2(stack.at(1))) straight down into the GF powder room's WC compartment (#r2(stack.at(1) - 14.55) m south of its partition) and on to the buried west run; the other wastes in the floor build-up, ≤ 2 m.

    *The gallery* extends south over today's nib footprint only (x 4.25–5.8 × y 19.25–20.55), ending at y 20.55 with a glass door 1.10 onto the court; nothing new east of x 4.25, the clerestory's sun unchanged.

    *The gym:* everything else as today; it loses bedroom 3's strip and the nib (#r2(today-gym-clear - gym-clear) m² clear). West of the strip the *pocket* by the west window (x 0–1.5, 1.28 × 1.2 clear, open to the gym on its south side) takes the dumbbell rack 1.2 × 0.5 under the window. Its door cannot come from the extended gallery (the gallery's west wall at its end is bedroom 3's door), so it is from the court on x 4.25 beside the gallery's end (y 20.65–21.55, into the gym), one step from the glass door; today's nib court door is not needed and not kept (the glass door is the gallery's door to the court). The treadmill with its 0.5 m zone against the west wall, the 2.0 × 1.0 mat and the bike east of it, the 0.9 m path from the door; the ladder recess slides 1.0 m south to y 21.65–22.95.

    *Walls.* Straight and orthogonal; the only steps are the strip's (x 1.5, y 20.55). The pair's two cross walls (y #r2(yb), #r2(ys)) and the wet wall x #r2(xw): 0.20 block partitions on the solid west slab, none on a GF wall; the wet wall carries the stack and the two WC frames mid-bay (the engineer's list). The strip's west wall x 1.5 and south wall y 20.55 (today's nib line, continued east as the gallery's end wall): light double gypsum on the men's majlis roof slab. On the beam line y 19.25 the double wall remains only for x 0–1.5 (on B22); over x 1.5–4.25 the opening replaces it, the beams B22 (east part) and B8 carrying the slab as before: for the engineer's list. Removed: bath 2's niche walls (y 11.0, x 1.5), bath 3's walls (y 14.4, x 2.2), the nib's north wall with its sliding door and the nib's court door. No column or beam moved; R21 unchanged. The windows are provisional marks.

    #text(6.6pt, fill: gray)[Quick checks: #if all-ok [passed (7): the rooms and the shaft tile the band to y 24; fixtures and furniture inside their rooms, no overlaps, both strips clear; every door leaf clear; the main rooms within 0.3 m²; the stack inside the GF WC compartment; the gym's equipment inside the gym with the zone and the path free; the glass door's swing clear of the court's furniture and the ladder.] else [FAILED: #ok.enumerate().filter(((i, v)) => not v).map(((i, v)) => str(i + 1)).join(", ")]]
  ],
)

// ======================= PAGE 2 · the table and the Arabic lines =======================
#pagebreak()
#text(13pt, weight: "bold", fill: accent)[Today vs the option] #h(1fr) #text(6.8pt, fill: gray)[m² on axes · *clear* inside the walls (the outer walls 0.125, every other wall 0.10 a side) · today = `studies/ff_family.typ`, `studies/ff_suite.typ`, 14 Nov 2026]
#v(1pt) #line(length: 100%, stroke: 0.6pt + accent)
#grid(columns: (1.15fr, 1fr), column-gutter: 16pt,
  [
    #table(columns: (1.5fr, 1fr, 1.15fr), stroke: 0.3pt + luma(190), inset: 3pt, align: (left, right, right), fill: (_, y) => if y == 0 { rgb("#e1e9e3") } else if calc.even(y) { rgb("#efece4") },
      table.header([], [*Today*], [*The option*]),
      [Bedroom 2 · total clear · entry strip · *main room*], [#r2(clear(T-of("Bedroom 2"))) · 0 · *4.03 × 3.20 = #r2(clear(T-of("Bedroom 2")))*], [#r2(clear2) · 2.55 × 1.10 = #r2(strip2-clear) · *4.03 × #r2(d2) = #r2(main2)*],
      [Bedroom 3 · total clear · entry strip · *main room*], [#r2(clear(T-of("Bedroom 3"))) · #r2(today-entry3) (the notch) · *4.03 × 2.95 = #r2(clear(T-of("Bedroom 3")) - today-entry3)*], [#r2(clear3) · 2.55 × 1.20 = #r2(strip3-clear) · *4.03 × #r2(d3) = #r2(main3)*],
      [Bath 2 · bath 3 · clear], [#r2(clear(T-of("Bedroom 2 bath"))) · #r2(clear(T-of("Bedroom 3 bath")))], [#r2(clear(P-of("Bedroom 2 bath"))) · #r2(clear(P-of("Bedroom 3 bath")))],
      [Gym · clear · the equipment], [#r2(today-gym-clear) · fits], [#r2(gym-clear) · #if ok.at(5) [fits; the dumbbell rack in the pocket] else [does not fit]],
      [The gallery ends at y · its length from y 0.7], [19.25 · 18.55], [20.55 · 19.85],
      [Bedroom 3's door], [x 4.25, y 15.2–16.2, from the gallery], [x 4.25, y 19.4–20.3, into its strip; the opening 2.55 into the room],
      [Gym door · court doors], [sliding, from the gallery's end (the nib) · the nib's court door], [from the court, x 4.25 y 20.65–21.55 · the gallery's glass door 1.10 on y 20.55],
      [The stack lands on the GF in], [two stacks (the shaft; the FWC stack)], [one: the powder room's WC compartment, (#r2(stack.at(0)), #r2(stack.at(1)))],
      [On beams], [the double wall y 19.25 on B22 + B8], [the double wall x 0–1.5 on B22; the opening over the rest (B22, B8 carry the slab)],
      [Light partitions on the slab], [y 11.0, x 1.5; y 14.4, x 2.2; the nib's walls], [y #r2(yb), y #r2(ys), x #r2(xw) (the wet wall, mid-bay); the strip's x 1.5 and y 20.55; the gallery's end wall y 20.55],
      [Columns · beams moved], [—], [none],
    )
    #v(4pt)
    #text(7.4pt)[*For both main rooms to reach 4.0 m clear depth* (#r2(d2) and #r2(d3) today in this option) the band must grow by #r2(4.0 - d2) + #r2(4.0 - d3) = *#r2(grow) m in length (y)*, with the baths, the strips and the gym as drawn.]
  ],
  [
    #ah[
      #text(7.8pt)[
        الخيار: الغرفتان توأم؛ تُدخل كلٌّ منهما عبر شريط مدخل واحد الشكل (2.55 × نحو 1.1 م صافية) وأمامه جدار ثم الغرفة: غرفة 2 عبر الشريط بجانب الشفت، وغرفة 3 عبر شريط مأخوذ من النادي جنوب الخط y 19.25 بابه على x 4.25 ثم فتحة بعرض الشريط إلى الغرفة. \
          الحمّامان ظهرًا لظهر بينهما بعمق 1.4 م، بجدار رطب واحد وماسورة واحدة تنزل في حجرة مرحاض دورة المياه الأرضية؛ الغرفتان الرئيسيتان متساويتان: 4.03 × #r2(d2) و4.03 × #r2(d3) م، #r2(main2) و#r2(main3) م² (اليوم #r2(clear(T-of("Bedroom 2"))) و#r2(clear(T-of("Bedroom 3")) - today-entry3)). \
          الممر يمتد جنوبًا فوق موضع عتبة النادي اليوم فقط (إلى y 20.55) وينتهي بباب زجاجي على الفناء؛ لا بناء جديد شرق x 4.25 وشمس نوافذ الصالة كما هي؛ باب النادي من الفناء بجانب نهاية الممر. \
          النادي #r2(gym-clear) م² بأجهزته، وجيبه عند النافذة الغربية (1.28 × 1.2 م) لرف الدمبل؛ الحمّامان #r2(clear(P-of("Bedroom 2 bath"))) و#r2(clear(P-of("Bedroom 3 bath"))) م². \
          الجدران مستقيمة والخطوتان الوحيدتان خطوتا الشريط؛ جدارا الحمّامين والجدار الرطب وجدارا الشريط قواطع خفيفة على البلاطة؛ الجدار المزدوج يبقى على الجسر B22 غرب الشريط والفتحة فوق الجسرين؛ لا عمود ولا جسر يتحرك؛ ولتبلغ الغرفتان عمق 4.0 م يلزم تطويل المبنى #r2(grow) م.
      ]
    ]
  ],
)

// kids_room.typ · Taif / Palm House · SHORT STUDY (11 Nov 2026, owner): bedroom 1 (the young children's room, the north-east corner, free of the old tower)
// takes the whole corner and gets its OWN BATHROOM (WC, basin, a simple shower: a mixer on the wall over a floor drain, no tray, no cubicle), BESIDE the master
// suite's bathroom: a common wet wall and the same stack; it may take space from the master bath if needed, but NO column or beam moves.
// Nothing in the design files is changed by this study. Two layouts, their sizes, the columns, the stack, a recommendation and an Arabic summary.
// CSV frame (data/rooms_ff.csv): x east, y south, wall centre lines; interior walls 0.20 (0.10 each side), the outer walls 0.25 (0.125 inside).
#import "@preview/cetz:0.4.2"
#import "../base.typ": dist

#set page(paper: "a4", flipped: true, margin: 8mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 7.4pt)
#set par(leading: 0.4em)
#let ink = rgb("#3d4a45"); #let accent = rgb("#2f6b4f"); #let red = rgb("#b5452f"); #let blue = rgb("#2f5f8a"); #let amber = rgb("#c98a12"); #let gray = rgb("#6d736f")
#let H(t) = block(above: 5pt, below: 2.5pt, text(9pt, weight: "bold", fill: accent, t))
#let r2(v) = { let s = str(calc.round(v, digits: 2)); if not s.contains(".") { s + ".00" } else if s.split(".").at(1).len() == 1 { s + "0" } else { s } }
#let r1(v) = str(calc.round(v, digits: 1))
#let ah(t) = text(font: ("Segoe UI", "Arial", "Tahoma"), lang: "ar", dir: rtl, t)

// ---------- as drawn today (data/rooms_ff.csv, V10.0 + the straight-walls rule of 11 Nov 2026) ----------
#let rooms-ff = csv("/data/rooms_ff.csv", row-type: dictionary)
#let pts-of(name) = { let r = rooms-ff.find(r => r.name == name); assert(r != none, message: "rooms_ff.csv: missing " + name); r.pts.split(";").map(p => { let v = p.trim().split(" ").map(float); (v.at(0), v.at(1)) }) }
#let bed1-now = pts-of("Bedroom 1")
#let sbath-now = pts-of("Suite bath"); #let swc-now = pts-of("Suite WC (closet)")
#let link-now = pts-of("Family link")
#assert(bed1-now.len() == 7 and calc.abs(bed1-now.at(2).at(1) - 5.245) < 1e-6 and calc.abs(bed1-now.at(4).at(0) - 10.15) < 1e-6, message: "bedroom 1 changed: re-read kids_room.typ")
#let W = 13.311                                                      // the east wall
#let cut-a = (10.461, 0); #let cut-b = (13.311, 5.245)               // the cut wall (an RC wall, columns C30, C31, C32 in it)
#let cut-x(y) = cut-a.at(0) + y * (cut-b.at(0) - cut-a.at(0)) / cut-b.at(1)
#let cut-cos = cut-b.at(1) / dist(cut-a, cut-b)
#let cut-in(y) = cut-x(y) - 0.125 / cut-cos                          // the cut's inner face, measured in x
#let columns = (("C24", (8.95, 0)), ("C25", (8.95, 3.0)), ("C26", (8.95, 6.5)), ("C30", (10.461, 0)), ("C31", (11.982, 2.8)), ("C32", (13.311, 5.245)), ("C33", (13.311, 10.45)))   // studies/structure.typ (assumed sizes)
#let beams = ((("B6", (8.95, 6.5), (13.311, 6.5)), [B6 · the bedroom 1 / suite wall, over the laundry / kitchen line]), (("B1", (8.3, 3.0), (8.95, 3.0)), [B1]))
#let east-stack = (13.311, 7.05)                                     // the suite bath's stack outside the east wall (studies/plumbing.typ), beside the suite WC closet
#let gf-below = ((((8.95, 0), (10.461, 0), (12.1996, 3.2), (10.65, 3.2), (10.65, 4.7), (8.95, 4.7)), [GF maid room (habitable)], false), (((10.65, 3.2), (12.1996, 3.2), (13.0148, 4.7), (10.65, 4.7)), [GF maid bath], true), (((8.95, 4.7), (13.0148, 4.7), (13.311, 5.245), (13.311, 6.5), (8.95, 6.5)), [GF laundry], true), (((8.95, 6.5), (13.311, 6.5), (13.311, 13.0), (8.95, 13.0)), [GF kitchen], true))
#let windows-now = (((11.33, 1.6), (12.2, 3.2), [escape window]), ((12.442, 3.645), (13.039, 4.745), [2nd window]), ((9.2, 0), (10.2, 0), [north window]))

// ---------- helpers ----------
#let area(P) = calc.abs(range(P.len()).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, P.len())); a.at(0) * b.at(1) - b.at(0) * a.at(1) }).sum()) / 2
#let inset(P, d) = {
  let n = P.len()
  let lines = range(n).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, n)); let (dx, dy) = (b.at(0) - a.at(0), b.at(1) - a.at(1)); let L = calc.sqrt(dx * dx + dy * dy); ((a.at(0) - dy / L * d.at(i), a.at(1) + dx / L * d.at(i)), (dx, dy)) })
  range(n).map(i => { let (p1, v1) = lines.at(calc.rem(i + n - 1, n)); let (p2, v2) = lines.at(i); let den = v1.at(0) * v2.at(1) - v1.at(1) * v2.at(0); let t = ((p2.at(0) - p1.at(0)) * v2.at(1) - (p2.at(1) - p1.at(1)) * v2.at(0)) / den; (p1.at(0) + v1.at(0) * t, p1.at(1) + v1.at(1) * t) })
}
#let is-cw(P) = range(P.len()).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, P.len())); a.at(0) * b.at(1) - b.at(0) * a.at(1) }).sum() > 0   // screen sense (y down): positive = clockwise on screen
#let half(a, b) = {   // the half wall thickness of an edge from where it lies: the outer walls (north, east, the cut) 0.125, every other wall 0.10
  let outer = (calc.abs(a.at(1)) < 1e-6 and calc.abs(b.at(1)) < 1e-6) or (calc.abs(a.at(0) - W) < 1e-6 and calc.abs(b.at(0) - W) < 1e-6) or (calc.abs(a.at(0) - cut-x(a.at(1))) < 0.02 and calc.abs(b.at(0) - cut-x(b.at(1))) < 0.02)
  if outer { 0.125 } else { 0.10 }
}
#let clear(P) = { let Q = if is-cw(P) { P } else { P.rev() }; area(inset(Q, range(Q.len()).map(i => half(Q.at(i), Q.at(calc.rem(i + 1, Q.len())))))) }
#let rect-pts(x0, y0, x1, y1) = ((x0, y0), (x1, y0), (x1, y1), (x0, y1))
#let inside(p, P) = { let c = false; let n = P.len(); for i in range(n) { let (xi, yi) = P.at(i); let (xj, yj) = P.at(calc.rem(i + n - 1, n)); if ((yi > p.at(1)) != (yj > p.at(1))) and (p.at(0) < (xj - xi) * (p.at(1) - yi) / (yj - yi) + xi) { c = not c } }; c }
#let bbox(P) = (calc.min(..P.map(p => p.at(0))), calc.min(..P.map(p => p.at(1))), calc.max(..P.map(p => p.at(0))), calc.max(..P.map(p => p.at(1))))
#let shrink(P, d) = inset(if is-cw(P) { P } else { P.rev() }, P.map(_ => d))
#let poly-in(S, P) = shrink(S, 0.002).all(p => inside(p, P))
#let box-in(b, P) = { let (x0, y0, x1, y1) = (b.at(0), b.at(1), b.at(2), b.at(3)); let e = 0.001; ((x0 + e, y0 + e), (x1 - e, y0 + e), (x1 - e, y1 - e), (x0 + e, y1 - e)).all(p => inside(p, P)) }
#let overlap(a, b) = not (a.at(2) <= b.at(0) + 1e-9 or b.at(2) <= a.at(0) + 1e-9 or a.at(3) <= b.at(1) + 1e-9 or b.at(3) <= a.at(1) + 1e-9)
#let no-overlaps(L) = range(L.len()).all(i => range(L.len()).all(j => i == j or not overlap(L.at(i), L.at(j))))
#let swing-box(d) = { let (a, b, dir) = (d.at(0), d.at(1), d.at(2)); let w = dist(a, b); let (x0, x1) = (calc.min(a.at(0), b.at(0)), calc.max(a.at(0), b.at(0))); if dir.at(1) < 0 { (x0, a.at(1) - w, x1, a.at(1)) } else { (x0, a.at(1), x1, a.at(1) + w) } }   // the leaf's swing as a box (doors in E–W walls)
#let col-inside(P) = columns.filter(c => inside(c.at(1), shrink(P, 0.13)))   // a column standing INSIDE a room's clear area (not in its walls)

// ======================= LAYOUT A · the bath over the laundry, north of the common wall y 6.5 =======================
// the bedroom's south wall ONE straight line on y 4.7 (over the GF maid-wing / laundry wall): the family link 1.2 × 1.8 west of x 10.15, the bath east of it to the cut
#let A = (
  name: [A · the bath over the laundry (y 4.7–6.5), the bedroom shorter],
  bed: ((8.95, 0), (10.461, 0), (cut-x(4.7), 4.7), (8.95, 4.7)),
  bath: ((10.15, 4.7), (cut-x(4.7), 4.7), (13.311, 5.245), (13.311, 6.5), (10.15, 6.5)),
  link: rect-pts(8.95, 4.7, 10.15, 6.5),
  sbath: sbath-now, swc: swc-now,
  doors: (((9.05, 4.7), (10.05, 4.7), (0, -1), [bedroom door 1.00, from the link, opens in]), ((10.25, 4.7), (11.05, 4.7), (0, 1), [bath door 0.80, from the bedroom, opens into the bath])),
  furniture: ((9.05, 0.15, 10.25, 2.15, [bed 1.2 × 2.0]), (9.05, 2.25, 9.65, 3.65, [wardrobe 1.4 × 0.6]), (11.15, 4.0, 12.35, 4.6, [desk 1.2 × 0.6])),
  shower: (((12.286, 4.8), (cut-in(4.8), 4.8), (13.186, 5.276), (13.186, 6.4), (12.286, 6.4)), [shower zone 0.9 × 1.6\ mixer on the east wall\ floor drain]),
  fixtures: ((11.3, 5.8, 11.7, 6.4, [WC]), (10.25, 5.7, 10.7, 6.3, [basin])),
  windows: (((11.33, 1.6), (12.2, 3.2), [escape]), ((12.442, 3.645), (cut-x(4.5), 4.5), [2nd, shortened to y 4.5]), ((9.2, 0), (10.2, 0), [north]), ((W, 5.6), (W, 6.2), [bath 0.6])),
  branches: (((12.9, 6.2), (13.186, 6.42), (13.311, 6.6), east-stack), ((11.5, 6.42), (13.186, 6.42)), ((10.5, 6.35), (10.5, 6.42), (11.5, 6.42))),
  master: [nothing],
  note: [the link grows to 1.2 × 1.8; the 2nd window on the cut ends at y 4.5; the bath gets a 0.6 window on the east wall and a fan],
)
// ======================= LAYOUT B · the bath INSIDE the master bath's north strip (y 6.5–8.0), the bedroom whole =======================
// the strip x 10.3–13.311 × y 6.5–8.0 = the suite WC closet + the suite bath's north band (its path to the closet); the door through the B6 wall (a door under a beam: normal)
#let B = (
  name: [B · the bath in the master bath's north strip (y 6.5–8.0), the bedroom whole],
  bed: bed1-now,
  bath: rect-pts(10.3, 6.5, 13.311, 8.0),
  link: link-now,
  sbath: rect-pts(10.3, 8.0, 13.311, 10.45), swc: (),
  doors: (((9.05, 5.3), (10.05, 5.3), (0, -1), [bedroom door 1.00, as now]), ((10.45, 6.5), (11.25, 6.5), (0, -1), [bath door 0.80, from the bedroom's entry strip, opens into the bedroom]), ((10.3, 8.1), (10.3, 9.1), (1, 0), [the suite bath's door moved south])),
  furniture: ((9.05, 0.15, 10.25, 2.15, [bed 1.2 × 2.0]), (11.4, 5.9, 13.186, 6.5, [wardrobe 1.8 × 0.6]), (9.05, 2.3, 9.65, 3.5, [desk 1.2 × 0.6])),
  shower: (rect-pts(12.286, 6.6, 13.186, 7.9), [shower zone 0.9 × 1.3\ over the stack]),
  fixtures: ((11.6, 7.3, 12.0, 7.9, [WC]), (10.4, 6.9, 10.85, 7.5, [basin])),
  windows: windows-now + (((W, 7.3), (W, 7.8), [bath 0.5]),),
  branches: (((12.9, 7.6), east-stack), ((11.8, 7.9), (13.186, 7.3), east-stack), ((10.85, 7.2), (12.2, 7.0), (13.186, 7.2), east-stack)),
  master: [its WC closet (#r2(area(swc-now)) m²) and the north band of the bath: #r2(area(sbath-now) + area(swc-now)) → #r2(area(rect-pts(10.3, 8.0, 13.311, 10.45))) m² on axes; the WC comes back inside the bath (the tub's place, or a single vanity); the bath door moves to y 8.1–9.1],
  note: [the suite bath keeps its stack, its shower and its east window; the kids' bath lies over the kitchen's north band (a service room; the suite bath's sunken tanked slab is already there)],
)
#let AA = (bed: ((8.95, 0), (10.461, 0), (cut-x(5.0), 5.0), (8.95, 5.0)), bath: ((10.15, 5.0), (cut-x(5.0), 5.0), (13.311, 5.245), (13.311, 6.5), (10.15, 6.5)))   // A′ · numbers only: the bath 1.5 deep (y 5.0–6.5)

// ---------- checks ----------
#let wet(L) = L.fixtures + (bbox(L.shower.at(0)),)
#let bath-ok(L) = L.fixtures.all(b => box-in(b, L.bath)) and poly-in(L.shower.at(0), L.bath) and no-overlaps(wet(L))
#let furn-ok(L) = L.furniture.all(b => box-in(b, L.bed)) and no-overlaps(L.furniture) and L.furniture.all(b => b.at(2) <= cut-in(b.at(1)) + 1e-9 and b.at(2) <= cut-in(b.at(3)) + 1e-9)
#let swings-ok(L) = { let sw = L.doors.filter(d => d.at(2).at(0) == 0).map(swing-box); sw.all(s => (L.furniture + wet(L)).all(b => not overlap(s, b))) }
#let over-service(L) = { let P = shrink(L.bath, 0.05); let samples = range(P.len()).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, P.len())); range(6).map(k => (a.at(0) + (b.at(0) - a.at(0)) * k / 6, a.at(1) + (b.at(1) - a.at(1)) * k / 6)) }).join(); samples.all(p => gf-below.any(g => g.at(2) and inside(p, g.at(0)))) }   // the bath's floor (0.05 inside its walls) sampled: every point over a service room
#let shares-wall(L) = L.bath.any(p => calc.abs(p.at(1) - 6.5) < 1e-6 or calc.abs(p.at(1) - 8.0) < 1e-6) and L.bath.any(p => calc.abs(p.at(0) - W) < 1e-6)
#let stack-dist(L) = calc.min(..L.fixtures.map(f => dist(((f.at(0) + f.at(2)) / 2, (f.at(1) + f.at(3)) / 2), east-stack)))
#let no-jog(L) = { let P = L.bed; P.len() == 4 or P == bed1-now }   // the bedroom a 4-sided room (three straight walls + the cut), or as drawn today
#let checks(L) = (
  ([the bath's fixtures fit inside it without overlap], bath-ok(L)),
  ([the bed, the wardrobe and the desk fit inside the bedroom, inside the cut's inner face, without overlap], furn-ok(L)),
  ([no door leaf swings onto a piece of furniture or a fixture], swings-ok(L)),
  ([the bath lies over service rooms only (the laundry · the maid bath · the kitchen), never over a habitable room], over-service(L)),
  ([the bath shares a wall with the master bath and stands on the east wall beside its stack (nearest fixture #r2(stack-dist(L)) m from the stack)], shares-wall(L) and stack-dist(L) < 3.0),
  ([no column stands inside the bedroom or the bath (every column in a wall); no column or beam moves], col-inside(L.bed).len() == 0 and col-inside(L.bath).len() == 0),
  ([the bedroom has straight walls and no jog], no-jog(L)),
)
#let all-ok(L) = checks(L).all(c => c.at(1))

// ---------- drawing ----------
#let q(p) = (p.at(0), -p.at(1))
#let plan(L, length: 1.06cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, body, size: 4.4pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, body))
  let poly(P, fill: none, stroke: none) = line(..P.map(q), close: true, fill: fill, stroke: stroke)
  let R(b, fill: none, stroke: none) = rect(q((b.at(0), b.at(1))), q((b.at(2), b.at(3))), fill: fill, stroke: stroke)
  rect(q((8.3, -0.5)), q((14.2, 11.0)), fill: rgb("#f3efe6"), stroke: none)
  for x in range(9, 14) { line(q((x, -0.2)), q((x, 10.8)), stroke: 0.2pt + luma(218)); T((x, -0.35), str(x), size: 3.8pt, fill: gray) }
  for y in range(0, 11) { line(q((8.5, y)), q((13.9, y)), stroke: 0.2pt + luma(218)); T((8.4, y), str(y), size: 3.8pt, fill: gray, anchor: "east") }
  for (P, l, wet) in gf-below { poly(P, stroke: (paint: rgb("#8a5a2b"), dash: "dotted", thickness: 0.5pt)) }
  // rooms
  poly(L.bed, fill: rgb("#efe3c8"), stroke: 0.9pt + ink)
  poly(L.bath, fill: rgb("#cfe6ef"), stroke: 0.9pt + ink)
  poly(L.link, fill: rgb("#e9e4d8"), stroke: 0.9pt + ink)
  poly(L.sbath, fill: rgb("#e3eef3"), stroke: 0.9pt + ink)
  if L.swc.len() > 0 { poly(L.swc, fill: rgb("#e3eef3"), stroke: 0.9pt + ink) }
  poly(rect-pts(8.95, 6.5, 10.3, 11.9), fill: rgb("#e9e4d8"), stroke: 0.9pt + ink); T((9.62, 9.3), [suite lobby], size: 3.6pt, fill: gray, angle: 90deg)
  poly(rect-pts(10.3, 10.45, 13.311, 11.9), fill: luma(236), stroke: 0.9pt + ink); T((11.8, 11.2), [suite dressing], size: 3.6pt, fill: gray)
  rect(q((8.3, 0)), q((8.95, 6.5)), fill: luma(236), stroke: 0.9pt + ink); T((8.62, 3.0), [kids' study · family living], size: 3.4pt, fill: gray, angle: 90deg)
  // outer walls, the cut
  line(q((8.95, 0)), q(cut-a), q(cut-b), q((W, 11.9)), stroke: 2pt + ink)
  // furniture, fixtures
  for (x0, y0, x1, y1, l) in L.furniture { R((x0, y0, x1, y1), fill: rgb("#fbf6ea"), stroke: 0.45pt + rgb("#8a7a5a")); T(((x0 + x1) / 2, (y0 + y1) / 2), l, size: 3.1pt, angle: if (y1 - y0) > (x1 - x0) * 1.3 { 90deg } else { 0deg }) }
  poly(L.shower.at(0), fill: white, stroke: 0.45pt + blue); let sb = bbox(L.shower.at(0)); T(((sb.at(0) + sb.at(2)) / 2, (sb.at(1) + sb.at(3)) / 2 + 0.15), L.shower.at(1), size: 2.9pt, fill: blue, angle: 90deg)
  for (x0, y0, x1, y1, l) in L.fixtures { R((x0, y0, x1, y1), fill: white, stroke: 0.45pt + blue); T(((x0 + x1) / 2, (y0 + y1) / 2), l, size: 2.9pt, fill: blue, angle: if (y1 - y0) > (x1 - x0) * 1.3 { 90deg } else { 0deg }) }
  // the master bath's fixtures today (B: shown faded in their old places)
  if L.swc.len() > 0 { for (x0, y0, x1, y1, l) in ((12.536, 6.95, 13.186, 7.4, [WC]), (12.086, 8.1, 13.186, 9.5, [shower]), (11.486, 9.6, 13.186, 10.35, [tub]), (10.4, 8.3, 11.0, 9.9, [2 basins])) { R((x0, y0, x1, y1), fill: none, stroke: (paint: blue, thickness: 0.35pt, dash: "dashed")); T(((x0 + x1) / 2, (y0 + y1) / 2), l, size: 2.8pt, fill: blue) } }
  // doors, windows, swings
  for d in L.doors { let (a, b, dir, l) = d; line(q(a), q(b), stroke: 3pt + red); if dir.at(0) == 0 { let s = swing-box(d); R(s, stroke: (paint: red, thickness: 0.3pt, dash: "dashed")) } }
  for (a, b, l) in L.windows { line(q(a), q(b), stroke: 2.6pt + blue) }
  // beams, columns, the stack, the branches
  for (b, l) in beams { line(q(b.at(1)), q(b.at(2)), stroke: (paint: amber, thickness: 1.2pt, dash: "dashed")); T(((b.at(1).at(0) + b.at(2).at(0)) / 2, b.at(1).at(1) - 0.16), b.at(0), size: 3.4pt, fill: amber) }
  for (id, p) in columns { rect(q((p.at(0) - 0.14, p.at(1) - 0.14)), q((p.at(0) + 0.14, p.at(1) + 0.14)), fill: ink, stroke: none); T((p.at(0) + 0.2, p.at(1) - 0.2), id, size: 3.2pt, fill: ink, anchor: "west") }
  circle(q(east-stack), radius: 0.2, fill: rgb("#8a5a2b"), stroke: none); T((13.55, 7.05), [E stack], size: 3.2pt, fill: rgb("#8a5a2b"), anchor: "west")
  for br in L.branches { line(..br.map(q), stroke: (paint: rgb("#8a5a2b"), thickness: 0.8pt)) }
  // labels
  T((10.75, 2.9), [*Bedroom 1*\ #r2(area(L.bed)) m² axes\ ≈ #r2(clear(L.bed)) clear], size: 3.6pt)
  T(if L.swc.len() > 0 { (11.7, 5.15) } else { (11.75, 6.95) }, [*kids' bath* #r2(area(L.bath)) · ≈ #r2(clear(L.bath)) clear], size: 3.3pt, fill: blue)
  T((9.55, if L.swc.len() > 0 { 5.65 } else { 5.95 }), [link], size: 3.4pt, fill: gray)
  T((11.55, if L.swc.len() > 0 { 8.8 } else { 9.9 }), [*suite bath*\ #r2(area(L.sbath) + (if L.swc.len() > 0 { area(L.swc) } else { 0 })) m² axes], size: 3.4pt, fill: blue)
  line(q((8.6, 10.5)), q((9.6, 10.5)), stroke: 1pt + ink); T((9.1, 10.72), [1 m], size: 3.4pt)
})

// ======================= PAGE 1 =======================
#text(13pt, weight: "bold", fill: accent)[Bedroom 1 (the young children's room) with its own bathroom · short study] #h(1fr) #text(6.8pt, fill: gray)[11 Nov 2026 · the owner's brief · nothing in the design files changed · CSV frame, north up]
#v(1pt) #line(length: 100%, stroke: 0.6pt + accent)
#text(7pt)[*The brief:* the whole north-east corner for bedroom 1 and a bath of its own (WC, basin, a wall-mixer shower over a floor drain), *beside the master bath on a common wet wall and the same stack*; the master bath may give space, but *no column or beam moves*; the bedroom rectangular (straight walls, no jogs) with a bed, a wardrobe and a desk, the bath door from inside the room; the drains over service rooms only. *Fixed:* the cut wall (RC, C30–C32), the east wall (C32, C33), the x 8.95 wall (C24–C26), *beam B6 on y 6.5* (the bedroom 1 / suite wall), the suite's stack outside the east wall at y 7.05.]
#v(2pt)
#grid(columns: (auto, auto, 1fr), column-gutter: 8pt,
  [#text(7.5pt, weight: "bold", fill: accent)[#A.name] \ #plan(A)],
  [#text(7.5pt, weight: "bold", fill: accent)[#B.name] \ #plan(B)],
  [
    #let tbl(..cells) = table(columns: (1.5fr, 1fr, 1fr), stroke: 0.3pt + luma(190), inset: 2.6pt, align: (left, right, right), fill: (_, y) => if y == 0 { rgb("#e1e9e3") } else if calc.even(y) { rgb("#efece4") }, ..cells)
    #text(7pt, weight: "bold", fill: accent)[Sizes (m², on axes · clear inside the walls)]
    #tbl(
      table.header([*Item*], [*A*], [*B*]),
      [Bedroom 1 today, axes · clear], [#r2(area(bed1-now)) · #r2(clear(bed1-now))], [#r2(area(bed1-now)) · #r2(clear(bed1-now))],
      [*Bedroom 1, clear*], [*#r2(clear(A.bed))*], [*#r2(clear(B.bed))*],
      [… on axes], [#r2(area(A.bed))], [#r2(area(B.bed))],
      [*Kids' bath, clear*], [*#r2(clear(A.bath))*], [*#r2(clear(B.bath))*],
      [… on axes · clear width], [#r2(area(A.bath)) · 1.60], [#r2(area(B.bath)) · 1.30],
      [Shower zone], [0.9 × 1.6], [0.9 × 1.3],
      [Master bath + WC closet, axes], [#r2(area(sbath-now) + area(swc-now)) (as now)], [#r2(area(B.sbath))],
      [Master bath loses], [nothing], [the WC closet and its north band (#r2(area(sbath-now) + area(swc-now) - area(B.sbath)) m²), the tub or a basin, its door moves],
      [Family link], [1.2 × 1.8], [1.2 × 1.2 (as now)],
      [Nearest fixture → the stack], [#r2(stack-dist(A)) m], [#r2(stack-dist(B)) m],
      [Below the bath], [the laundry (service)], [the kitchen's north band (service)],
      [Columns inside a room], [none (C32 in the shower's corner wall)], [none],
    )
    #v(2pt)
    #text(6.6pt)[*A′ (numbers only):* the bath 1.5 deep (y 5.0–6.5, clear width 1.3): bedroom #r2(clear(AA.bed)) m² clear (#r2(area(AA.bed)) axes), bath #r2(clear(AA.bath)) clear; the bath's north wall then stands 0.3 m off the laundry wall below (allowed on a slab, but one more line to set out).]
    #v(2pt)
    #text(6.8pt)[*Checks A:* #if all-ok(A) [*passed* (#checks(A).len())] else [*FAILED:* #checks(A).filter(c => not c.at(1)).map(c => c.at(0)).join([; ])] \ *Checks B:* #if all-ok(B) [*passed* (#checks(B).len())] else [*FAILED:* #checks(B).filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]]
    #v(2pt)
    #text(6.1pt, fill: gray)[Ochre: the bedroom; blue: the baths, fixtures, windows; red: the doors, the leaf's swing dashed; amber dashed: beams B6, B1; black squares: the columns (`studies/structure.typ`); brown dot: the suite's stack; brown lines: the new branches; brown dotted: the ground floor below. Clear = inside the walls (0.10 a side, outer 0.125). Checks: fixtures and furniture inside their rooms and the cut's inner face, no overlaps, no leaf on a piece, the bath over service rooms, the common wall and the stack, no column inside a room, no jog.]
  ],
)

// ======================= PAGE 2 =======================
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[What each layout does · recommendation · #ah[الخلاصة]]
#v(1pt) #line(length: 100%, stroke: 0.6pt + accent)
#grid(columns: (1fr, 1fr), column-gutter: 14pt,
  [
    #H[Layout A · the bath over the laundry, north of the common wall]
    - *The walls:* the bedroom's south wall becomes *one straight line on y 4.7* from the x 8.95 wall to the cut, directly over the ground-floor laundry / maid-wing wall; the family link's north wall moves with it (the link 1.2 × 1.8) and the link's east wall x 10.15 runs on to y 4.7 as the bath's west wall. The bedroom is a clean four-sided room (three straight walls + the cut), *#r2(clear(A.bed)) m² clear* (today #r2(clear(bed1-now))): the bed 1.2 × 2.0 under the north window, a 1.4 m wardrobe on the west wall, a 1.2 m desk on the south wall under the shortened second window; the escape window on the cut unchanged.
    - *The bath* #r2(clear(A.bath)) m² clear, 1.6 m wide: the *shower zone 0.9 × 1.6 in the east end* with the mixer on the east wall and the floor drain by it, *the clipped corner of the cut and column C32 in the shower's corner* (the owner's rule: a column in a bath is used, not fought); the WC on the common wall y 6.5 (B6 below it: the pipes run in the floor screed and the wall above the beam, never through it); the basin on the west wall by the door. Its door 0.80 at the west end of the y 4.7 wall, from inside the bedroom, opening into the bath. A 0.6 m window on the east wall (over the laundry's) and an extract fan.
    - *Plumbing:* every branch over the *laundry* (a service room with its own floor drain below), the longest #r1(dist((10.5, 6.3), (13.186, 6.45)) + 0.6) m along the common wall to the east wall and out to the *suite's stack* 0.55 m south of the wall: the same stack, one more cleanout at the wall. The wet wall y 6.5 serves both baths (the suite's WC closet on its other side).
    - *Structure:* nothing moves. The y 4.7 wall and the x 10.15 wall are light partitions on the slab (the GF wall below y 4.7 makes the first a wall over a wall).
    - *Cost to the master suite:* none.
    #H[Layout B · the bath in the master bath's north strip]
    - *The walls:* the bedroom keeps its whole shape (#r2(clear(B.bed)) m² clear); the kids' bath takes the suite WC closet and the north band of the suite bath (x 10.3–13.311, y 6.5–8.0): #r2(clear(B.bath)) m² clear, 1.3 m wide, the shower directly over the stack, the WC on the new common wall y 8.0, the basin on the west wall; its door through the B6 wall (a door under a beam is normal), opening into the bedroom's entry strip, the wardrobe moved east of it.
    - *The master bath:* from #r2(area(sbath-now) + area(swc-now)) to #r2(area(B.sbath)) m² on axes; it *loses its WC closet*, so the WC comes back into the bath (in the tub's place, or the double vanity becomes single), and *its door moves* south to y 8.1–9.1 (the door today is where the kids' bath sits). The suite's shower, tub drain and vanity branches then cross under the kids' bath to the stack (they already run there).
    - *Structure and plumbing:* nothing moves; over the kitchen's north band (a service room) inside the suite bath's sunken tanked slab (X10).
    - *Cost to the master suite:* real: a smaller bath, no WC closet, a re-planned door and vanity.
  ],
  [
    #box(fill: accent.lighten(86%), stroke: 1pt + accent, inset: 6pt, radius: 3pt, width: 100%)[
      #text(9.5pt, weight: "bold", fill: accent)[Recommendation: Layout A] \
      #text(7.2pt)[
        It gives the children a real bath (#r2(clear(A.bath)) m² clear, a 0.9 × 1.6 shower) *on the common wall and the same stack* without touching the master bath, keeps every column and beam where it is, and leaves bedroom 1 a *clean rectangle-with-the-cut of #r2(clear(A.bed)) m² clear*, enough for a bed, a wardrobe and a desk for young children, with its escape window unchanged. The only loss is #r2(clear(bed1-now) - clear(A.bed)) m² of the bedroom, most of it the entry strip along the suite wall that held only the wardrobe. Layout B keeps the room but costs the master suite its WC closet, its door and a vanity, for a narrower kids' bath (1.3 m): the trade the owner allowed "if needed", and it is not needed. \
        *If the owner wants the bedroom bigger:* A′ (the bath 1.5 deep) gives back #r2(clear(AA.bed) - clear(A.bed)) m² for a 1.3 m wide bath. \
        *To apply (next round, LEAN):* `data/rooms_ff.csv` (bedroom 1 → the y 4.7 trapezoid; a new row "Bedroom 1 bath"; the family link 1.2 × 1.8), `studies/ff_family.typ` (the rooms, the doors, the shortened second window, the bath window, the fixtures), `studies/plumbing.typ` (three branches to the east stack), the presentation's sheet 03 and its note, sheet 05 (the family first floor) and sheet 08; the 3D and the DXFs at the release.
      ]
    ]
    #v(4pt)
    #box(fill: rgb("#f4efe3"), stroke: 0.6pt + luma(170), inset: 6pt, radius: 3pt, width: 100%)[
      #ah[
        #text(9pt, weight: "bold", fill: accent)[الخلاصة بالعربية] \
        #text(7.6pt)[
          غرفة النوم 1 (غرفة الأطفال الصغار، الركن الشمالي الشرقي) تأخذ الركن كله وتحصل على حمّام خاص: مرحاض ومغسلة ودُش بسيط (خلاط على الجدار فوق مصرف أرضي، بلا حوض ولا كابينة). \
          *التصميم A (الموصى به):* الحمّام فوق غرفة الغسيل، شمال الجدار المشترك مع حمّام الجناح الرئيسي (خط الجسر B6 على y 6.5)، على الجدار الشرقي بجانب ماسورة الصرف نفسها (0.55 م جنوب الجدار). جدار الغرفة الجنوبي خط واحد مستقيم على y 4.7 فوق جدار جناح الخادمة؛ الغرفة #r2(clear(A.bed)) م² صافية (اليوم #r2(clear(bed1-now))) بسرير 1.2 × 2.0 وخزانة 1.4 م ومكتب 1.2 م؛ الحمّام #r2(clear(A.bath)) م² صافية بعرض 1.6 م، منطقة الدُش 0.9 × 1.6 في الطرف الشرقي حيث زاوية الجدار المائل والعمود C32 داخل جدار الزاوية. لا يتحرك أي عمود أو جسر، وحمّام الجناح الرئيسي لا يخسر شيئًا. \
          *التصميم B:* الحمّام داخل الشريط الشمالي لحمّام الجناح (y 6.5–8.0) فتبقى الغرفة كاملة (#r2(clear(B.bed)) م²)، لكن حمّام الجناح يخسر غرفة المرحاض وبابه ومغسلة، ويضيق حمّام الأطفال إلى 1.3 م. \
          *التوصية:* A. وإن أراد المالك غرفة أكبر: A′ بحمّام عمقه 1.5 م يعيد #r2(clear(AA.bed) - clear(A.bed)) م² للغرفة.
        ]
      ]
    ]
    #v(4pt)
    #text(6.2pt, fill: gray)[Kids' room study · bedroom 1, the suite rooms and the link from `data/rooms_ff.csv`; the columns and B6 from `studies/structure.typ` (sizes assumed, the engineer's); the stack from `studies/plumbing.typ`; the ground-floor rooms from `data/rooms_gf.csv` (the maid wing D, 11 Nov 2026). The shower is a wet zone: tanked floor with falls to the drain, a fixed glass panel at its edge if the owner wants one. Door swings drawn as boxes (the leaf's reach); the bedroom door opens into the room, the bath door into the bath (A). Not a code check.]
  ],
)

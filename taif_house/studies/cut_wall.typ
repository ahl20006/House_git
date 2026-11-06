// cut_wall.typ · Taif / Palm House · SHORT STUDY: shortening the cut wall B2–B3 (now 6.93 m) to gain area in the maid room (ground floor) and bedroom 1 above · 6 Nov 2026
// STUDY ONLY: the design files are not changed. Start: the position of 6 Nov 2026 (the house 0.50 m further south, design_gf.typ shift (0.91, 5.563)).
// Field calibration: the boundary wall stands 0.62–0.72 m inside the deed line along the cut (the tightest-point readings 2.20–2.30 m before the shift, sheet row 18;
// the owner will re-measure precisely at the day-1 point M1 16.25 / D 26.53). The cut wall is moved OUTWARDS, parallel: B2 slides east along the north wall, B3 north along the east wall.
// Options: A · exactly 0.40 m from the wall as built (for a true reading of 2.20 / 2.25 / 2.30) · B · 0.20 m from the wall as built · C · 0.40 m from the deed line.
// Design frame: origin M1 (the gate's east post) · y along the M line southwards · x east. Concept only – not for permit.
#import "@preview/cetz:0.4.2"
#import "../base.typ": env, lane, dist
#import "../design_gf.typ": shift, outline-csv-gf

#set page(paper: "a4", flipped: true, margin: 8mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 8pt)
#set par(leading: 0.4em)

#assert(calc.abs(shift.at(0) - 0.91) < 1e-9 and calc.abs(shift.at(1) - 5.563) < 1e-9, message: "the house moved (design_gf.typ shift): re-read cut_wall.typ")
#let expected = ((0, 0), (10.051, 0), (13.311, 6.0), (13.311, 24.0), (0, 24.0))
#assert(outline-csv-gf.zip(expected).all(((a, b)) => calc.abs(a.at(0) - b.at(0)) + calc.abs(a.at(1) - b.at(1)) < 1e-6), message: "the ground-floor outline changed")
#let S(p) = (p.at(0) + shift.at(0), p.at(1) + shift.at(1))
#let S0(p) = (p.at(0) + 0.91, p.at(1) + 5.063)                                            // the day-1 position (where row 18 was read)
#let faces = ((-0.125, -0.125), (10.125, -0.125), (13.436, 5.968), (13.436, 24.125), (-0.125, 24.125))   // B1 … B5, outer faces
#let B = faces.map(S)
#let B-day1 = faces.map(S0)
#let M1 = (0.0, 0.0); #let D = (-5.49, 27.89)
#let setback-lane = 2.0
#let readings = (2.20, 2.25, 2.30)
#let target = 0.40
#let cut-rooms = (tower: dist(S((10.051, 0)), S((10.594, 1.0))), bath: dist(S((10.594, 1.0)), S((11.572, 2.8))), maid: dist(S((11.572, 2.8)), S((13.311, 6.0))), bed1: dist(S((10.594, 1.0)), S((13.311, 6.0))))
#let bed1-c = ((8.95, 1), (10.594, 1), (13.311, 6), (13.311, 6.5), (10.15, 6.5), (10.15, 5.3), (8.95, 5.3))
#let maid-c = ((10.65, 2.8), (11.572, 2.8), (13.311, 6), (13.311, 7.0), (10.65, 7.0))
#let ensuite-need = 3.84 + 0.5 + 10.0     // a simple shower room 1.6 × 2.4 + its partition, the bedroom ≥ 10 m² clear (studies/bedroom1_bath.typ, option B rules)
#let b4-need = 3.84 + 1.9 + 10.0          // the hotel layout B4 (with its vestibule): never fits, the room is a wedge

// ---------- helpers ----------
#let area(poly) = { let s = 0.0; let n = poly.len(); for i in range(n) { let a = poly.at(i); let b = poly.at(calc.rem(i + 1, n)); s += a.at(0) * b.at(1) - b.at(0) * a.at(1) }; calc.abs(s) / 2 }
#let pseg(p, a, b) = { let dx = b.at(0) - a.at(0); let dy = b.at(1) - a.at(1); let l2 = dx * dx + dy * dy; let t = if l2 == 0 { 0 } else { calc.max(0, calc.min(1, ((p.at(0) - a.at(0)) * dx + (p.at(1) - a.at(1)) * dy) / l2)) }; dist(p, (a.at(0) + t * dx, a.at(1) + t * dy)) }
#let line-dist(p, pts) = calc.min(..range(pts.len() - 1).map(i => pseg(p, pts.at(i), pts.at(i + 1))))
#let limit-dist(p) = { let n = env.len(); let m = 1e9; for i in range(n) { let a = env.at(i); let b = env.at(calc.rem(i + 1, n)); if not (calc.abs(a.at(0)) < 0.01 and calc.abs(b.at(0)) < 0.01) { m = calc.min(m, pseg(p, a, b)) } }; m }
#let lane-d(p) = line-dist(p, lane)
#let sample(poly, step) = { let out = (); let n = poly.len(); for i in range(n) { let a = poly.at(i); let b = poly.at(calc.rem(i + 1, n)); let k = calc.max(1, int(calc.ceil(dist(a, b) / step))); for j in range(k) { let t = j / k; out.push((a.at(0) + t * (b.at(0) - a.at(0)), a.at(1) + t * (b.at(1) - a.at(1)))) } }; out }
#let tightest(poly, f) = { let best = sample(poly, 0.05).sorted(key: f).first(); (m: f(best), p: best) }
#let f2(v) = { let r = calc.round(v, digits: 2); let s = str(r); if not s.contains(".") { s + ".00" } else if s.split(".").at(1).len() == 1 { s + "0" } else { s } }
#let clear(P) = area(P) - 0.1 * (range(P.len()).map(i => dist(P.at(i), P.at(calc.rem(i + 1, P.len())))).sum())   // ≈ half a 0.20 wall off every edge (bedroom1_bath.typ)

// ---------- the calibration ----------
#let notch0 = tightest(B-day1, lane-d)                                 // the day-1 nearest point to the lane line: lane-d = the model's 2.92 where row 18 was read
#let delta(r) = notch0.m - r                                           // the wall as built this much inside the deed line, for a true reading r
#let m-deed(poly) = tightest(poly, limit-dist).m                        // the tightest margin from the deed setback line (every wall sampled at 5 cm)
#let m-wall(poly, r) = tightest(poly, p => lane-d(p) - delta(r) - setback-lane).m   // … from a setback counted 2.0 m from the wall as built
// the cut wall moved outwards by d (parallel): B2 east along the north wall, B3 north along the east wall
#let cut-n = { let u = (B.at(2).at(0) - B.at(1).at(0), B.at(2).at(1) - B.at(1).at(1)); let l = calc.sqrt(u.at(0) * u.at(0) + u.at(1) * u.at(1)); (u.at(1) / l, -u.at(0) / l) }
#let moved(d) = (B.at(0), (B.at(1).at(0) + d / cut-n.at(0), B.at(1).at(1)), (B.at(2).at(0), B.at(2).at(1) + d / cut-n.at(1)), B.at(3), B.at(4))
// the move d that leaves exactly the wanted margin (bisection on the edge-sampled margin)
#let solve(f, want) = { let lo = 0.0; let hi = 2.0; for _ in range(22) { let mid = (lo + hi) / 2; if f(moved(mid)) > want { lo = mid } else { hi = mid } }; (lo + hi) / 2 }
#let option(name, d, note) = {
  let P = moved(d)
  let gross = area(P) - area(B)
  let maid = clear(maid-c) + d * cut-rooms.maid
  let bed1 = clear(bed1-c) + d * cut-rooms.bed1
  (name: name, d: d, P: P, cut: dist(P.at(1), P.at(2)), b2-east: d / cut-n.at(0), b3-north: -d / cut-n.at(1), gross: gross,
   deed: m-deed(P), wall: readings.map(r => m-wall(P, r)), maid: maid, maid-gain: d * cut-rooms.maid, bed1: bed1, bed1-gain: d * cut-rooms.bed1,
   ensuite: bed1 >= ensuite-need, note: note)
}
#let A = readings.map(r => option([A · 0.40 from the wall, reading #f2(r)], solve(P => m-wall(P, r), target), [the margin used right down to the target]))
#let Bopt = option([B · 0.20 from the wall (reading 2.20)], solve(P => m-wall(P, 2.20), 0.20), [reduced margin])
#let Copt = option([C · 0.40 from the deed line], solve(m-deed, target), [only if the office confirms the deed line])
#let all = (option([as designed (6.93 m)], 0.0, []), ..A, Bopt, Copt)
#let checks = (
  ([the house at the 6 Nov 2026 position (shift 5.563); the day-1 nearest point to the lane line #f2(notch0.m) m from it (row 18 read 2.20–2.30 there)], calc.abs(notch0.m - 2.92) < 0.02),
  ([every option leaves exactly its wanted margin (within 2 mm): A #A.map(o => f2(o.wall.at(readings.position(r => calc.abs(o.d - solve(P => m-wall(P, r), target)) < 1e-6)))).join(" / "), B #f2(Bopt.wall.first()), C #f2(Copt.deed)], A.enumerate().all(((i, o)) => calc.abs(o.wall.at(i) - target) < 2e-3) and calc.abs(Bopt.wall.first() - 0.20) < 2e-3 and calc.abs(Copt.deed - target) < 2e-3),
  ([the cut stays parallel; B1, B4, B5 fixed; the move grows with the reading (A) and with the smaller margin (B, C)], A.at(0).d < A.at(1).d and A.at(1).d < A.at(2).d and A.at(0).d < Bopt.d and Bopt.d < Copt.d),
  ([C stands inside a setback counted from the wall as built (#f2(Copt.wall.first()) m at the 2.20 reading): flagged], Copt.wall.first() < 0),
)
#let all-ok = checks.all(c => c.at(1))

// ---------- drawing: the cut wall enlarged ----------
#let ink = rgb("#3d4a45"); #let accent = rgb("#2f6b4f"); #let bld = rgb("#6a3d9a"); #let grid-c = rgb("#d9dcd6"); #let red = rgb("#b5452f"); #let amber = rgb("#c98a12")
#let q(x, y) = (x, -y)
#let lab(p, body, size: 6pt, fill: ink, anchor: "center") = cetz.draw.content(q(..p), anchor: anchor, text(size, fill: fill, body))
#let x-on(a, b, y) = a.at(0) + (y - a.at(1)) * (b.at(0) - a.at(0)) / (b.at(1) - a.at(1))
#let y-on(a, b, x) = a.at(1) + (x - a.at(0)) * (b.at(1) - a.at(1)) / (b.at(0) - a.at(0))
#let tower-s = ((8.95, 0), (10.051, 0), (10.594, 1.0), (8.95, 1.0)).map(S)
#let bath-s = ((8.95, 1), (10.594, 1), (11.572, 2.8), (8.95, 2.8)).map(S)
#let maid-s = maid-c.map(S)
#let zoom = cetz.canvas(length: 0.78cm, {
  import cetz.draw: *
  let (x0, x1, y0, y1) = (8.5, 18.5, 2.5, 13.0)
  rect(q(x0, y0), q(x1, y1), fill: white, stroke: 0.4pt + grid-c)
  for x in range(9, 19) { line(q(x, y0), q(x, y1), stroke: 0.2pt + grid-c) }
  for y in range(3, 14) { line(q(x0, y), q(x1, y), stroke: 0.2pt + grid-c) }
  for x in range(10, 19, step: 2) { lab((x, y1 + 0.3), str(x), size: 5pt, fill: gray) }
  for y in range(4, 14, step: 2) { lab((x0 - 0.3, y), str(y), size: 5pt, fill: gray) }
  let piece(P, i0, i1) = ((x-on(P.at(i0), P.at(i0 + 1), y0), y0), ..P.slice(i0 + 1, i1 + 1), (x1, y-on(P.at(i1), P.at(i1 + 1), x1)))
  let env-piece = ((x-on(env.at(4), env.at(5), y0), y0), env.at(5), env.at(6), env.at(7), (x-on(env.at(7), env.at(8), y1), y1))
  line(..env-piece.map(p => q(..p)), stroke: 0.9pt + accent); lab((9.6, 3.0), [setback line (deed, 2.0 m)], size: 5pt, fill: accent, anchor: "west")
  line(..piece(lane, 1, 4).map(p => q(..p)), stroke: 1.4pt + black); lab((15.9, 5.0), [lane wall (deed line)], size: 5pt, anchor: "west")
  // the wall as built for the 2.20 and 2.30 readings: the lane polyline shifted (each vertex along the mean inward normal)
  let shifted(dl) = { let n = lane.len(); let nv(i) = { let a = lane.at(i); let b = lane.at(i + 1); let l = dist(a, b); let v = ((b.at(1) - a.at(1)) / l, -(b.at(0) - a.at(0)) / l); if v.at(0) * (B.at(1).at(0) - a.at(0)) + v.at(1) * (B.at(1).at(1) - a.at(1)) < 0 { (-v.at(0), -v.at(1)) } else { v } }
    range(n).map(i => { let v = if i == 0 { nv(0) } else if i == n - 1 { nv(n - 2) } else { ((nv(i - 1).at(0) + nv(i).at(0)) / 2, (nv(i - 1).at(1) + nv(i).at(1)) / 2) }; let l = calc.sqrt(v.at(0) * v.at(0) + v.at(1) * v.at(1)); (lane.at(i).at(0) + dl * v.at(0) / l, lane.at(i).at(1) + dl * v.at(1) / l) }) }
  for (r, col) in ((2.20, red), (2.30, red.lighten(40%))) { line(..piece(shifted(delta(r)), 1, 4).map(p => q(..p)), stroke: (paint: col, thickness: 0.8pt, dash: "dashed")) }
  lab((18.2, 3.2), [the wall as built: readings 2.20 (dark) / 2.30 (light),\ #f2(delta(2.20)) / #f2(delta(2.30)) m inside the deed line], size: 4.6pt, fill: red, anchor: "east")
  for P in (tower-s, bath-s, maid-s) { line(..P.map(p => q(..p)), close: true, stroke: (paint: luma(140), thickness: 0.4pt, dash: "dotted")) }
  let rows = ((B, luma(90), "dashed", [as designed · 6.93 m]), (A.at(0).P, bld, "solid", [A 2.20 · +#f2(A.at(0).d)]), (A.at(1).P, bld, "solid", [A 2.25 · +#f2(A.at(1).d)]), (A.at(2).P, bld, "solid", [A 2.30 · +#f2(A.at(2).d)]), (Bopt.P, amber, "solid", [B · +#f2(Bopt.d)]), (Copt.P, red, "solid", [C · +#f2(Copt.d)]))
  for (i, (P, col, dash, l)) in rows.enumerate() {
    line(q(x0, y-on(P.at(0), P.at(1), x0)), q(..P.at(1)), q(..P.at(2)), q(x-on(P.at(2), P.at(3), y1), y1), stroke: (paint: col, thickness: if i == 0 { 0.8pt } else { 0.6pt }, dash: dash))
    lab((x0 + 0.2, y1 - 0.4 - (rows.len() - 1 - i) * 0.36), l, size: 4.6pt, fill: col, anchor: "west")
  }
  circle(q(..B.at(1)), radius: 0.1, fill: luma(90), stroke: none); lab((B.at(1).at(0) - 0.2, B.at(1).at(1) - 0.3), [B2], size: 5pt, fill: luma(90), anchor: "east")
  circle(q(..B.at(2)), radius: 0.1, fill: luma(90), stroke: none); lab((B.at(2).at(0) + 0.25, B.at(2).at(1)), [B3], size: 5pt, fill: luma(90), anchor: "west")
})

#let tbl(columns: (1fr, auto), size: 7pt, ..cells) = text(size, table(columns: columns, stroke: none, inset: (x: 3.5pt, y: 2.2pt),
  fill: (_, y) => if y == 0 { rgb("#e1e9e3") } else if calc.even(y) { rgb("#efece4") }, ..cells))
#let col(v, lim) = text(fill: if v < 0 { red } else if v < lim { amber } else { accent }, weight: "bold")[#f2(v)]
#let row(l, f) = (l, ..all.map(f))

#grid(columns: (auto, 1fr), column-gutter: 10pt,
  [
    #zoom
    #v(3pt)
    #block(width: 7.8cm, text(6.5pt, fill: gray)[The cut wall enlarged, at the 6 Nov 2026 position. Grey dashed: as designed. Purple: option A for the three possible true readings; amber: B; red: C. Dotted: the rooms along the cut. Where the wall as built really stands is what the owner's precise re-measure at M1 16.25 / D 26.53 (the day-1 point) will fix; the move of A then follows from the table.])
  ],
  [
    #text(14pt, weight: "bold", fill: accent)[Cut wall · shortening it to gain area · short study] #h(1fr) #text(7pt, fill: gray)[STUDY ONLY · 6 Nov 2026 · start: the house 0.50 m further south (B1 5.49 from M1) · the cut wall 6.93 m]
    #v(2pt) #line(length: 100%, stroke: 0.6pt + accent)
    #text(7pt, fill: gray)[The cut wall B2–B3 is moved outwards, parallel; B2 slides east along the north wall (#f2(1 / cut-n.at(0)) d), B3 north along the east wall (#f2(-1 / cut-n.at(1)) d); every wall sampled at 5 cm. The wall as built: #f2(delta(2.20))–#f2(delta(2.30)) m inside the deed line (readings 2.20–2.30 at the day-1 tightest point, where the model gives #f2(notch0.m) to the deed line). At the new position the cut wall keeps #f2(m-wall(B, 2.20))–#f2(m-wall(B, 2.30)) m from the wall as built and #f2(m-deed(B)) m from the deed line as designed.]
    #v(2pt)
    #tbl(columns: (2.2fr, 0.9fr, 1fr, 1fr, 1fr, 1fr, 1fr), size: 6.4pt,
      table.header([*Option*], [*as designed*], [*A · 2.20*], [*A · 2.25*], [*A · 2.30*], [*B · 0.20 from the wall*], [*C · 0.40 from the deed*]),
      ..row([The cut wall's move outwards d (m)], o => [*#f2(o.d)*]),
      ..row([New cut length (m) · B2 slides east · B3 slides north], o => [#f2(o.cut) · #f2(o.b2-east) · #f2(o.b3-north)]),
      ..row([Margin from the deed line (m)], o => col(o.deed, target)),
      ..row([Margin from the wall as built, for a true reading of 2.20 / 2.25 / 2.30 (m)], o => [#col(o.wall.at(0), target) / #col(o.wall.at(1), target) / #col(o.wall.at(2), target)]),
      ..row([*Gross floor area gained per floor* (m²; the roof the same)], o => [*#f2(o.gross)*]),
      ..row([Ground floor: the maid room clear (m², now #f2(clear(maid-c))) · gain · the maid bath · the air tower], o => [#f2(o.maid) · +#f2(o.maid-gain) · +#f2(o.d * cut-rooms.bath) · +#f2(o.d * cut-rooms.tower)]),
      ..row([First floor: bedroom 1 clear (m², now #f2(clear(bed1-c))) · gain], o => [#f2(o.bed1) · +#f2(o.bed1-gain)]),
      ..row([Bedroom 1: a simple en-suite shower room 1.6 × 2.4 with ≥ 10 m² left (needs #f2(ensuite-need) clear)], o => if o.ensuite { text(fill: accent, weight: "bold")[yes, by area] } else { text(fill: red)[no (short by #f2(ensuite-need - o.bed1))] }),
      ..row([… the hotel layout B4 with its vestibule (needs #f2(b4-need) and a rectangle)], o => [no: a wedge]),
    )
    #text(7pt)[
      *What else moves (every option):* the three columns on the cut line slide with it (the corner column at B2 east along the north wall by the B2 move, the middle one outwards by d, the column at B3 north along the east wall by the B3 move), the two cut-wall beams and the RC wall W4 shorten, the air tower and the HRV base under the malqaf grow outwards by d over 1.14 m of the cut, the roof's cut edge, the main cornice and the attic's set-back follow the wall; nothing changes in the rooms' doors, windows (the maid's escape casement stays in the cut wall) or the stiffness idea. *B's risk in one line:* 0.20 m leaves nothing for the survey's own tolerance (± 0.10) or the wall's irregularity: one low reading puts the house inside a setback counted from the wall. *C:* valid only if the engineering office confirms in writing that the setback is measured from the deed line; from the wall as built it stands #f2(-Copt.wall.first()) m inside the setback.
    ]
    #box(fill: rgb("#2f6b4f").lighten(85%), stroke: 1pt + accent, inset: 6pt, radius: 3pt, width: 100%)[
      #text(9.5pt, weight: "bold", fill: accent)[Verdict and recommendation] \
      #text(7.2pt)[
        1 · With the margin used down to the owner's 0.40 m target (A), the cut wall can move only *#f2(A.at(0).d)–#f2(A.at(2).d) m*, depending on the precise reading: #f2(A.at(0).gross)–#f2(A.at(2).gross) m² per floor, of which the maid room gains #f2(A.at(0).maid-gain)–#f2(A.at(2).maid-gain) m² and bedroom 1 #f2(A.at(0).bed1-gain)–#f2(A.at(2).bed1-gain) m²; bedroom 1's simple shower room fits by area only from the #f2(readings.at(A.position(o => o.ensuite))) m reading upwards (the hotel layout never). \
        2 · B (0.20 m) gains #f2(Bopt.gross) m² per floor but spends the whole safety margin; C (the deed line) gains #f2(Copt.gross) m² per floor but stands #f2(-Copt.wall.first()) m inside a wall-measured setback: neither is a safe decision before the official survey and the office's written answer on where the setback is counted from. \
        3 · *Recommendation:* re-measure the day-1 point precisely (M1 16.25 / D 26.53, square to the wall's inner face); if it reads ≥ 2.25 m, option A with its move from the table (≈ #f2(A.at(1).d)–#f2(A.at(2).d) m, under 1 m² per floor) can go into the drawings after the official survey; if it reads 2.20, keep the cut wall at 6.93 m: #f2(A.at(0).gross) m² is not worth re-drawing the cut, the columns and the tower. The gain is small in every case; the house's room is in the shift already made.
      ]
      #block(width: 100%)[
        #set text(lang: "ar", size: 7.6pt)
        #set par(leading: 0.6em)
        *الخلاصة:* بعد إزاحة البيت ٠٫٥٠ م جنوبًا يمكن تحريك جدار القطع للخارج #f2(A.at(0).d)–#f2(A.at(2).d) م فقط مع إبقاء ٠٫٤٠ م من الجدار كما هو مبني (بحسب القراءة الدقيقة ٢٫٢٠–٢٫٣٠ م)، أي #f2(A.at(0).gross)–#f2(A.at(2).gross) م² لكل طابق: غرفة الخادمة +#f2(A.at(0).maid-gain)–#f2(A.at(2).maid-gain) م² وغرفة النوم ١ +#f2(A.at(0).bed1-gain)–#f2(A.at(2).bed1-gain) م²؛ حمام بسيط لغرفة النوم ١ يتسع بالمساحة من القراءة ٢٫٢٥ فأعلى. الخيار B (٠٫٢٠ م) يستهلك هامش الأمان كله، والخيار C (من خط الصك) يقع داخل الارتداد إن قيس من الجدار. *التوصية:* إعادة القياس الدقيق عند النقطة M1 16.25 / D 26.53؛ إن كانت القراءة ≥ ٢٫٢٥ م فالخيار A بعد المساحة الرسمية، وإلا يبقى جدار القطع ٦٫٩٣ م.
      ]
    ]
    #v(2pt)
    #text(6.2pt, fill: gray)[Cut wall study · Study checks #if all-ok [passed] else [FAILED]: #checks.map(c => c.at(0)).join([ · ]). Sources: base.typ, design_gf.typ (shift 5.563), data/rooms_gf.csv and rooms_ff.csv (the rooms), STRUCTURE_STUDY.md (the cut-line columns), roof.typ (the tower and the cornice), bedroom1_bath.typ (the en-suite rules), SITE_SETOUT.md rows 18 and 23 (the calibration).]
  ],
)

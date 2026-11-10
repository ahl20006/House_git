// maid_wing.typ · Taif / Palm House V10.0 · STUDY ONLY (the owner's brief of 10 Nov 2026): the maid's wing re-planned (compile THIS file → output/maid_wing.pdf)
// The north part of the east service block (CSV x 8.95–13.311, y 0–7.0; the cut wall from (10.461, 0) to (13.311, 5.245)): ONE roof span, no columns, the inner walls light
// partitions (100 mm block or aluminium) placed freely. Order along the kitchen wall: kitchen → LAUNDRY → MAID BATH → MAID ROOM (the north-east corner); no store; the slanted
// corner of her room becomes her built-in wardrobe; one door to her room (not from the kitchen); the bath private, door only from her room; the escape window kept.
// The LAUNDRY has priority: two washers, a dryer (stacked), a steam ironing station, a folding / ironing table, cupboards, a ceiling drying rack near the window, optionally a sink;
// a window onto the east yard (insect screen), a strong extract fan with a humidity sensor, a floor drain with an anti-odour trap, water-resistant finishes; a yard door if it fits.
// Local coordinates: x = CSV x − 8.95 (east), y = CSV y (south). Nothing here changes data/rooms_gf.csv, design_gf.typ, studies/east_wing.typ or the presentation.
#import "@preview/cetz:0.4.2"
#set page(paper: "a4", flipped: true, margin: 9mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 7.3pt)
#set par(leading: 0.42em)
#let green = rgb("#2f6b4f"); #let ink = rgb("#26302b"); #let gray = rgb("#6d736f"); #let red = rgb("#b5452f"); #let amber = rgb("#b07a1f"); #let blue = rgb("#1f7a99")
#let H(t) = block(above: 5pt, below: 3pt, text(9pt, weight: "bold", fill: green, t))
#let r2(v) = str(calc.round(v, digits: 2)); #let r1(v) = str(calc.round(v, digits: 1))
#let area(P) = calc.abs(range(P.len()).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, P.len())); a.at(0) * b.at(1) - b.at(0) * a.at(1) }).sum()) / 2
#let q(p) = (p.at(0), -p.at(1))

// ---------- the block and the cut ----------
#let W = 4.361; #let D = 7.0
#let cut(y) = 1.511 + y * 3.26 / 6.0            // the cut wall: x at a given y (y 0–5.245)
#let blk = ((0, 0), (1.511, 0), (W, 5.245), (W, D), (0, D))
#let esc = ((3.358, 3.4), (3.902, 4.4))         // the maid room's escape casement in the cut wall today (CSV (12.308, 3.4)–(12.852, 4.4)), kept in C, moved north in A
#let min-clear = 7.28                           // the maid room's clear area the house adopted as the municipal minimum (V7.0, PROJECT §4.26)
// clear area: the outer walls 0.25 (the north wall, the cut, the east wall), the courtyard / majlis wall x 0 and the kitchen wall y 7.0 0.20, the partitions 0.10: an inset of the polygon
#let inset(P, d) = {
  // offset every edge inwards by d.at(i) (per edge), convex polygons only (our rooms are convex or split below)
  let n = P.len()
  let lines = range(n).map(i => {
    let a = P.at(i); let b = P.at(calc.rem(i + 1, n))
    let (dx, dy) = (b.at(0) - a.at(0), b.at(1) - a.at(1)); let L = calc.sqrt(dx * dx + dy * dy)
    let nx = -dy / L; let ny = dx / L   // the inward normal for a clockwise (screen) polygon
    ((a.at(0) + nx * d.at(i), a.at(1) + ny * d.at(i)), (dx, dy))
  })
  range(n).map(i => {
    let (p1, v1) = lines.at(calc.rem(i + n - 1, n)); let (p2, v2) = lines.at(i)
    let den = v1.at(0) * v2.at(1) - v1.at(1) * v2.at(0)
    let t = ((p2.at(0) - p1.at(0)) * v2.at(1) - (p2.at(1) - p1.at(1)) * v2.at(0)) / den
    (p1.at(0) + v1.at(0) * t, p1.at(1) + v1.at(1) * t)
  })
}
#let half(a, b) = {   // the half wall thickness on an edge, from its position
  let outer = (calc.abs(a.at(1)) < 1e-6 and calc.abs(b.at(1)) < 1e-6) or (calc.abs(a.at(0) - W) < 1e-6 and calc.abs(b.at(0) - W) < 1e-6) or (calc.abs(a.at(0) - cut(a.at(1))) < 0.02 and calc.abs(b.at(0) - cut(b.at(1))) < 0.02)
  let heavy = (calc.abs(a.at(0)) < 1e-6 and calc.abs(b.at(0)) < 1e-6) or (calc.abs(a.at(1) - D) < 1e-6 and calc.abs(b.at(1) - D) < 1e-6)
  if outer { 0.125 } else if heavy { 0.10 } else { 0.05 }
}
#let clear(P) = area(inset(P, range(P.len()).map(i => half(P.at(i), P.at(calc.rem(i + 1, P.len()))))))

// ---------- the three layouts: rooms (name, polygon, colour), fixtures (x0, y0, x1, y1, label), doors ((a, b), label), windows, notes ----------
#let col = (laundry: rgb("#d9e6ec"), bath: rgb("#cfe6ef"), room: rgb("#efe3c8"))
#let laundry-fix(y0, sink: true) = (
  (0.1, y0 + 0.15, 0.75, y0 + 0.75, [washer 1]), (0.1, y0 + 0.8, 0.75, y0 + 1.4, [washer 2 + dryer stacked]),
  (0.85, 6.3, 2.65, 6.9, [folding · ironing table 1.8 × 0.6]), (2.7, 6.3, 3.3, 6.9, [steam station]),
  (3.0, y0 + 0.1, 4.0, y0 + 0.7, [cupboards (tall, 0.6)]),
) + (if sink { ((3.6, 5.3, 4.1, 5.75, [small sink]),) } else { () }) + ((2.9, 5.5, 4.2, 6.2, [ceiling drying rack]),)
#let A = (
  name: "A · the bath in the tip, the room a true rectangle",
  rooms: (
    ("Maid bath", ((0, 0), (1.511, 0), (cut(2.0), 2.0), (0, 2.0)), "bath"),
    ("Maid room", ((0, 2.0), (cut(2.0), 2.0), (cut(4.6), 4.6), (0, 4.6)), "room"),
    ("Laundry", ((0, 4.6), (cut(4.6), 4.6), (W, 5.245), (W, D), (0, D)), "laundry"),
  ),
  fixtures: (
    (0.1, 0.1, 1.0, 1.0, [shower 0.9]), (1.55, 1.0, 2.0, 1.7, [WC]), (1.05, 1.5, 1.45, 1.9, [basin]),
    (0.1, 2.6, 1.0, 4.6, [bed 0.9 × 2.0]), (1.3, 2.1, 2.5, 2.6, [desk 1.2 × 0.5]), (2.6, 3.3, cut(3.3), 3.3, []),
  ) + laundry-fix(4.6),
  wardrobe: ((2.6, 3.3), (cut(3.3), 3.3), (cut(4.6), 4.6), (2.6, 4.6)),
  niche: ((2.6, 2.0), (cut(2.0), 2.0), (cut(3.3), 3.3), (2.6, 3.3)),
  doors: (((0.3, 2.0), (1.0, 2.0), [bath 0.70]), ((1.55, 4.6), (2.45, 4.6), [room 0.90, from the laundry]), ((0.75, 7.0), (1.65, 7.0), [laundry door 0.90 from the kitchen])),
  windows: (((cut(2.2), 2.2), (cut(3.2), 3.2), [escape casement 1.14 × 1.0, moved 1.2 m north on the cut]), ((cut(0.5), 0.5), (cut(1.1), 1.1), [bath vent window]), ((W, 5.4), (W, 6.4), [laundry window 1.0 (insect screen)])),
  esc-moved: true,
)
#let B = (
  name: "B · the laundry 2.8 m deep (the limit test)",
  rooms: (
    ("Maid bath", ((0, 0), (1.511, 0), (cut(2.0), 2.0), (0, 2.0)), "bath"),
    ("Maid room", ((0, 2.0), (cut(2.0), 2.0), (cut(4.2), 4.2), (0, 4.2)), "room"),
    ("Laundry", ((0, 4.2), (cut(4.2), 4.2), (W, 5.245), (W, D), (0, D)), "laundry"),
  ),
  fixtures: (
    (0.1, 0.1, 1.0, 1.0, [shower 0.9]), (1.55, 1.0, 2.0, 1.7, [WC]), (1.05, 1.5, 1.45, 1.9, [basin]),
    (0.1, 2.2, 1.0, 4.2, [bed 0.9 × 2.0]), (1.3, 2.1, 2.5, 2.6, [desk]),
  ) + laundry-fix(4.2) + ((1.0, 4.35, 2.2, 4.95, [second table / sorting]),),
  wardrobe: ((2.6, 3.3), (cut(3.3), 3.3), (cut(4.2), 4.2), (2.6, 4.2)),
  niche: ((2.6, 2.0), (cut(2.0), 2.0), (cut(3.3), 3.3), (2.6, 3.3)),
  doors: (((0.3, 2.0), (1.0, 2.0), [bath 0.70]), ((1.55, 4.2), (2.45, 4.2), [room 0.90]), ((0.75, 7.0), (1.65, 7.0), [laundry door 0.90])),
  windows: (((cut(2.2), 2.2), (cut(3.2), 3.2), [escape casement, moved]), ((cut(0.5), 0.5), (cut(1.1), 1.1), [vent]), ((W, 5.4), (W, 6.4), [laundry window])),
  esc-moved: true,
)
#let C = (
  name: "C · the owner's order, the escape window kept (RECOMMENDED)",
  rooms: (
    ("Maid room", ((0, 0), (1.511, 0), (cut(4.7), 4.7), (1.8, 4.7), (1.8, 3.0), (0, 3.0)), "room"),
    ("Maid bath", ((0, 3.0), (1.8, 3.0), (1.8, 4.7), (0, 4.7)), "bath"),
    ("Laundry", ((0, 4.7), (cut(4.7), 4.7), (W, 5.245), (W, D), (0, D)), "laundry"),
  ),
  fixtures: (
    (0.1, 0.8, 1.0, 2.8, [bed 0.9 × 2.0]), (0.1, 0.1, 1.45, 0.7, [wardrobe 1.35 × 0.6]), (2.4, 3.3, 3.4, 3.8, [desk 1.0 × 0.5, under the window]),
    (0.1, 3.1, 0.95, 3.95, [shower 0.85]), (0.1, 4.05, 0.55, 4.6, [WC]), (1.25, 4.15, 1.7, 4.55, [basin]),
  ) + laundry-fix(4.7, sink: false),
  wardrobe: ((2.6, 0.0), (1.511, 0.0), (cut(2.0), 2.0), (2.6, 2.0)),
  niche: (),
  doors: (((1.0, 3.0), (1.7, 3.0), [bath 0.70, from the room]), ((2.0, 4.7), (2.9, 4.7), [room 0.90, from the laundry]), ((0.75, 7.0), (1.65, 7.0), [laundry door 0.90 from the kitchen])),
  windows: ((esc.at(0), esc.at(1), [escape casement 1.14 × 1.0, kept where it is]), ((W, 5.4), (W, 6.4), [laundry window 1.0 (insect screen)])),
  esc-moved: false,
)
#let layouts = (A, B, C)

// ---------- checks: inside the block, no overlaps (sampled), the three rooms tile the block ----------
#let sample(P, step: 0.2) = range(P.len()).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, P.len())); let n = calc.max(1, int(calc.ceil(calc.sqrt(calc.pow(b.at(0) - a.at(0), 2) + calc.pow(b.at(1) - a.at(1), 2)) / step))); range(n + 1).map(k => (a.at(0) + (b.at(0) - a.at(0)) * k / n, a.at(1) + (b.at(1) - a.at(1)) * k / n)) }).join()
#let ray(p, P) = { let c = false; for i in range(P.len()) { let (xi, yi) = P.at(i); let (xj, yj) = P.at(calc.rem(i + 1, P.len())); if (yi > p.at(1)) != (yj > p.at(1)) and p.at(0) < (xj - xi) * (p.at(1) - yi) / (yj - yi) + xi { c = not c } }; c }
#let segd(p, a, b) = { let (dx, dy) = (b.at(0) - a.at(0), b.at(1) - a.at(1)); let L = dx * dx + dy * dy; let t = if L == 0 { 0 } else { calc.max(0, calc.min(1, ((p.at(0) - a.at(0)) * dx + (p.at(1) - a.at(1)) * dy) / L)) }; calc.sqrt(calc.pow(p.at(0) - a.at(0) - t * dx, 2) + calc.pow(p.at(1) - a.at(1) - t * dy, 2)) }
#let bd(p, P) = calc.min(..range(P.len()).map(i => segd(p, P.at(i), P.at(calc.rem(i + 1, P.len())))))
#let strict(p, P) = ray(p, P) and bd(p, P) > 0.01
#let issues(L) = {
  let out = ()
  for (n, P, c) in L.rooms { if not sample(P).all(p => ray(p, blk) or bd(p, blk) < 0.001) { out.push(n + " leaves the block") } }
  for i in range(L.rooms.len()) { for j in range(i + 1, L.rooms.len()) { let (na, A, _) = L.rooms.at(i); let (nb, B, _) = L.rooms.at(j); if sample(A).any(p => strict(p, B)) or sample(B).any(p => strict(p, A)) { out.push(na + " overlaps " + nb) } } }
  let tot = L.rooms.map(r => area(r.at(1))).sum()
  if calc.abs(tot - area(blk)) > 0.02 { out.push("the rooms do not tile the block: " + r2(tot) + " ≠ " + r2(area(blk))) }
  out
}
#let all-issues = layouts.map(issues).join()
#let room-clear(L) = clear(L.rooms.find(r => r.at(0) == "Maid room").at(1))
#let fits(L) = room-clear(L) >= min-clear

// ---------- drawing ----------
#let plan(L, length: 1.12cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, t, size: 4pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, t))
  rect(q((-0.4, -0.3)), q((W + 0.9, D + 0.5)), fill: rgb("#f3efe6"), stroke: none)
  rect(q((0, D)), q((W, D + 0.5)), fill: luma(232), stroke: none); T((W / 2, D + 0.25), [kitchen (y 7.0–13.0)], size: 3.6pt, fill: gray)
  rect(q((-0.4, 0)), q((0, D)), fill: luma(232), stroke: none); T((-0.2, 3.5), [women's majlis · courtyard], size: 3.4pt, fill: gray, angle: 90deg)
  for (n, P, c) in L.rooms {
    line(..P.map(q), close: true, fill: col.at(c), stroke: 0.9pt + ink)
  }
  if L.wardrobe.len() > 0 { line(..L.wardrobe.map(q), close: true, fill: rgb("#d8c39a"), stroke: 0.4pt + ink); let cxy = (L.wardrobe.map(p => p.at(0)).sum() / 4, L.wardrobe.map(p => p.at(1)).sum() / 4); T(cxy, [built-in\ wardrobe], size: 3.3pt) }
  if L.niche.len() > 0 { line(..L.niche.map(q), close: true, fill: rgb("#f7f1e2"), stroke: (paint: gray, thickness: 0.3pt, dash: "dashed")); T((2.95, 2.75), [window\ niche], size: 3.2pt, fill: gray) }
  for (x0, y0, x1, y1, l) in L.fixtures {
    if x1 - x0 < 0.01 or y1 - y0 < 0.01 { continue }
    let t = repr(l)
    let wet = t.contains("WC") or t.contains("basin") or t.contains("shower") or t.contains("sink") or t.contains("washer")
    rect(q((x0, y0)), q((x1, y1)), fill: if wet { white } else { rgb("#fbf6ea") }, stroke: 0.4pt + (if wet { blue } else { rgb("#8a7a5a") }))
    if t.contains("rack") { rect(q((x0, y0)), q((x1, y1)), fill: none, stroke: (paint: amber, thickness: 0.5pt, dash: "dashed")) }
    T(((x0 + x1) / 2, (y0 + y1) / 2), l, size: 3.1pt, angle: if (y1 - y0) > (x1 - x0) * 1.4 { 90deg } else { 0deg })
  }
  line(..blk.map(q), close: true, stroke: 2pt + ink)
  for ((a, b), l) in L.doors.map(((a, b, l)) => ((a, b), l)) { line(q(a), q(b), stroke: 3.2pt + red) }
  for (a, b, l) in L.windows { line(q(a), q(b), stroke: 3pt + blue) }
  // the escape window today (dashed) when moved
  if L.esc-moved { line(q(esc.at(0)), q(esc.at(1)), stroke: (paint: blue, thickness: 0.8pt, dash: "dashed")); T((3.95, 3.95), [today], size: 3pt, fill: blue, anchor: "west") }
  // the door and window labels at the side
  let k = 0
  for (a, b, l) in L.doors { T((W + 0.95, 0.35 + k * 0.42), text(fill: red)[door: #l], size: 3.2pt, anchor: "west"); k += 1 }
  for (a, b, l) in L.windows { T((W + 0.95, 0.35 + k * 0.42), text(fill: blue)[window: #l], size: 3.2pt, anchor: "west"); k += 1 }
  for (n, P, c) in L.rooms { let cx = P.map(p => p.at(0)).sum() / P.len(); let cy = P.map(p => p.at(1)).sum() / P.len(); let at = if n == "Laundry" { (1.9, 5.85) } else if n == "Maid room" and L.esc-moved { (1.3, 3.1) } else if n == "Maid room" { (1.6, 1.4) } else if L.esc-moved { (0.9, 1.25) } else { (1.35, 3.62) }; T(at, [*#n*\ #r2(area(P)) m² axes · ≈ #r2(clear(P)) clear], size: if n == "Maid bath" and not L.esc-moved { 2.9pt } else { 3.4pt }) }
  line(q((0, D + 0.75)), q((1, D + 0.75)), stroke: 1pt + ink); T((0.5, D + 0.95), [1 m], size: 3.4pt)
  T((W / 2 + 0.3, -0.18), [#L.name], size: 4.6pt, fill: green)
})

// ====================================================================================== PAGE 1
#text(14pt, weight: "bold", fill: green)[The maid's wing re-planned · laundry first · a study · Taif / Palm House V10.0]
#v(1pt)
#text(8pt, fill: gray)[The owner's brief (10 Nov 2026): one roof span, no columns, the inner walls light partitions placed freely; the order along the kitchen wall *kitchen → laundry → maid bath → maid room* (the north-east corner); no store; the slanted corner of her room her built-in wardrobe; her room one door (not from the kitchen), bed, wardrobe, small desk, the escape window kept; her bath private, door only from her room; the laundry the priority. STUDY ONLY: the design files and the presentation are unchanged. Block #r2(W) × #r2(D) m, #r2(area(blk)) m² on axes (the cut wall from (1.511, 0) to (#r2(W), 5.245)); local x = CSV x − 8.95.]
#v(3pt)
#grid(columns: (1fr, 1fr, 1fr), column-gutter: 4pt, ..layouts.map(L => plan(L)))
#v(2pt)
#table(columns: (auto, 1fr, 1fr, 1fr), inset: 2.4pt, stroke: 0.4pt + luma(175), fill: (_, y) => if y == 0 { rgb("#e4eedf") },
  [*Layout*], ..layouts.map(L => text(weight: "bold")[#L.name]),
  [Laundry (axes · ≈ clear)], ..layouts.map(L => { let P = L.rooms.find(r => r.at(0) == "Laundry").at(1); [#r2(area(P)) · #r2(clear(P)) m²] }),
  [Maid room (axes · ≈ clear, built-ins inside)], ..layouts.map(L => { let P = L.rooms.find(r => r.at(0) == "Maid room").at(1); [#r2(area(P)) · #r2(clear(P)) m² #if fits(L) [✓ ≥ #r2(min-clear)] else [#text(fill: red)[✗ < #r2(min-clear): does not fit]]] }),
  [Maid bath (axes · ≈ clear)], ..layouts.map(L => { let P = L.rooms.find(r => r.at(0) == "Maid bath").at(1); [#r2(area(P)) · #r2(clear(P)) m²] }),
  [The room reads as], [a 2.6 × 2.6 rectangle (≈ 2.45 × 2.5 clear) with the deep wedge wardrobe on its east side (front 1.3 m, 0.7–1.4 deep) and a small window niche], [the same, 0.4 m shorter: too small], [a 2.6 × 3.0 rectangle (≈ 2.45 × 2.9 clear) with the shallow wedge wardrobe in its north-east corner (shelves; the hanging wardrobe 1.35 on the north wall) and a desk alcove under the kept escape window],
  [Escape window], [moved 1.2 m north along the cut (y 2.2–3.2)], [moved], [kept at y 3.4–4.4 (today's position)],
  [Bath], [in the tip: a window on the cut, the shower in the obtuse corner], [as A], [internal (no window): an extract fan; the drains under the laundry to the east wall],
  [Yard door], [no (see page 2)], [no], [no],
)
#v(2pt)
#text(7.5pt)[#if all-issues.len() == 0 [*Maid wing study checks passed* (3 layouts: inside the block, no overlaps, the rooms tile the block)] else [*CHECKS FAILED:* #all-issues.join([; ])]]

// ====================================================================================== PAGE 2
#pagebreak()
#text(12pt, weight: "bold", fill: green)[The laundry in detail · what does not fit · the recommendation]
#v(3pt)
#grid(columns: (1.1fr, 1fr), gutter: 12pt,
  [
    #H[1 · The laundry (A and C alike; 2.3–2.4 m deep, the whole width)]
    - *Machines* on the west wall (the women's majlis wall, 0.20): *washer 1* and *washer 2 with the dryer stacked on it*, 0.65 deep, in one 1.25 m run from the north partition; the water and drain points behind them, the floor drain (an anti-odour membrane trap, a trap primer) under the stacked column; a tap and a hose point beside it.
    - *The folding / ironing table* 1.8 × 0.6 along the kitchen wall with the *steam ironing station* at its east end (0.6 × 0.6: the generator on a shelf below, the board stored folded against the wall) and a socket group above the table; the passage between the machines and the table ≈ 1.0 m.
    - *Cupboards* 1.0 m tall-and-deep (0.6) on the room's north partition between the door and the slant: detergents, the iron, baskets; open shelves above the table.
    - *The ceiling drying rack* (a pulley rack 1.3 × 0.7) over the east end in front of the window, out of the passage; the *window* 1.0 × 1.0 on the straight east wall (sill +1.1) onto the yard with an insect screen; above it the *extract fan* (≈ 150–200 m³/h, a humidity sensor and a timer, a backdraught shutter outside); *finishes:* porcelain floor to a drain, tiled or painted (washable) walls to the ceiling, a moisture-resistant ceiling, the machines on a drip tray.
    - *Doors:* the laundry's door 0.90 from the kitchen (today an open entrance: a door keeps the humidity and the noise out of the kitchen; it is the maid's route); the maid room's door 0.90 from the laundry (her only door; not from the kitchen).
    - *Sink:* A has a small sink 0.5 in the slant's corner; C has none (the kitchen's sink is 2 m away): optional in both.
    #H[2 · What does not fit (plainly)]
    - *A door to the yard:* the straight east wall is only 1.75 m long (y 5.245–7.0) and the window takes it; the bins stand outside it (y 5.3–6.1) and the kitchen's service door is 0.3 m round the corner. Not drawn; if the owner insists, a 0.8 door replaces the window and the window moves onto the slant (0.7 wide).
    - *A bath window in C:* the bath sits between the laundry and the room on the courtyard side, with no outer wall: an extract fan only. A keeps a window (the tip).
    - *The room as a true rectangle AND the escape window where it is:* the window is in the slanted wall, so either the slant stays visible beside the desk (C) or the window moves north so the wardrobe can fill the slant (A). Both keep an escape casement 1.14 × 1.0 on the cut wall (sill +1.10, no screen).
    - *B (the laundry 2.8 m deep)* leaves the room ≈ #r2(room-clear(B)) m² clear: below the #r2(min-clear) m² the house adopted as the municipal minimum (V7.0): rejected. The laundry cannot be deeper than ≈ 2.4 m.
    - *The wardrobe in the slant* is a wedge: only its deep end hangs clothes (A: 1.3 m of front, 0.7–1.4 deep; C: 0.9 m of front). C adds a 1.35 m wardrobe on the north wall.
  ],
  [
    #H[3 · Recommendation: layout C]
    - It follows the owner's order literally (kitchen → laundry → bath → room), keeps the escape window where it is (no facade change, the first-floor window above untouched), gives the largest room (#r2(room-clear(C)) m² clear, built-ins inside: the bed along the west wall, the hanging wardrobe on the north wall, the shelf wedge in the slanted corner, the desk under the window in a small alcove) and a laundry of #r2(clear(C.rooms.find(r => r.at(0) == "Laundry").at(1))) m² clear.
    - *Its price:* the bath (≈ #r2(clear(C.rooms.find(r => r.at(0) == "Maid bath").at(1))) m² clear: a 0.85 shower, a WC, a basin) has no window: a strong extract fan and a 0.70 door from the room; its WC and shower stand against the women's majlis wall (a 0.20 wall: add an acoustic lining); its drains run under the laundry floor ≈ 3 m to the east wall branch (one slope, no chamber).
    - *If the owner wants the bath window,* layout A: the bath in the tip (#r2(clear(A.rooms.find(r => r.at(0) == "Maid bath").at(1))) m² clear, the shower in the obtuse corner, a vent window on the cut), the room a clean 2.6 × 2.6 rectangle with the deep wedge wardrobe and a window niche; the escape window moves 1.2 m north along the cut (a change to the design files, the facade study and the 3D at the next release).
    - *Both:* the laundry's floor drain and the machines on the majlis wall (noise: the machines on anti-vibration feet, the wall lined), the extract through the east wall, the maid's route kitchen → laundry → her room unchanged.
    #H[4 · If adopted (the next release, not this study)]
    `data/rooms_gf.csv` (the three polygons; the store row removed), `design_gf.typ` and `studies/east_wing.typ` (the doors, the windows, the fixtures), `studies/plumbing.typ` (the bath's branch, the laundry's drain), the presentation (sheets 02, 06, 08), the 3D and the DXFs, `PROJECT_V10.md` §3 / §4; the laundry's extract and the bath's fan to the MEP engineer (open item 9).
    #v(4pt)
    #block(fill: rgb("#f1efe8"), inset: 5pt, radius: 2pt, width: 100%)[
      #set text(lang: "ar", dir: rtl, size: 7.2pt)
      *جناح الخادمة (دراسة، 10 نوفمبر 2026):* سقف واحد بلا أعمدة، والجدران الداخلية قواطع خفيفة. الترتيب على جدار المطبخ: المطبخ ثم الغسيل ثم حمام الخادمة ثم غرفتها في الركن الشمالي الشرقي، بلا مخزن. *الغسيل أولا:* غسالتان ومجفف فوق إحداهما، محطة كي بالبخار، طاولة طي وكي 1.8 م، دواليب، رف تجفيف في السقف قرب النافذة، نافذة على الحوش الشرقي بشبك، مروحة شفط قوية بحساس رطوبة، مصرف أرضي بمصيدة، تشطيبات مقاومة للماء؛ باب على الحوش لا يتسع (الجدار الشرقي المستقيم 1.75 م فقط والحاويات خلفه، وباب خدمة المطبخ على بعد خطوة).
      *التوصية: التخطيط C:* يتبع ترتيب المالك حرفيا، ويبقي نافذة الهروب مكانها، ويعطي أكبر غرفة (نحو #r2(room-clear(C)) م² صافيا مع السرير والدولاب والمكتب تحت النافذة) وغسيلا نحو #r2(clear(C.rooms.find(r => r.at(0) == "Laundry").at(1))) م² صافيا؛ ثمنه حمام داخلي بلا نافذة (مروحة شفط). *البديل A:* الحمام في الزاوية الحادة بنافذة، والغرفة مستطيل 2.6 × 2.6 مع دولاب عميق في الزاوية المائلة، وتُنقل نافذة الهروب 1.2 م شمالا. *B مرفوض:* غسيل بعمق 2.8 م يترك الغرفة دون الحد الأدنى.
    ]
    #v(3pt)
    #text(6.2pt, fill: gray)[Every size is on axes unless "clear"; the clear areas take 0.25 for the outer walls and the cut, 0.20 for the majlis and kitchen walls, 0.10 for the partitions; the fixtures are concept sizes. The drains, the extract and the electrical points are for the engineers.]
  ],
)

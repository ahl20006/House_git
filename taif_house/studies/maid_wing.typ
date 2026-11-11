// maid_wing.typ · Taif / Palm House V10.0 · the maid's wing re-planned (the owner's brief of 10 Nov 2026) · LAYOUT D ADOPTED by the owner on 10 Nov 2026 and applied to
// data/rooms_gf.csv, design_gf.typ, studies/east_wing.typ and the presentation (sheets 02 and 08); the 3D, the DXFs, the plumbing and structure not
// 11 Nov 2026 (owner, the straight-walls rule): the laundry / kitchen wall moved from y 7.0 onto the structural line y 6.5 (one line with the women's majlis wall): the laundry 1.8 m deep, re-fitted; the maid room and bath unchangedes follow at the next release.
// The north part of the east service block (CSV x 8.95–13.311, y 0–7.0; the cut wall from (10.461, 0) to (13.311, 5.245)): ONE roof span, no columns, the inner walls light
// partitions (100 mm block or aluminium) placed freely. Order along the kitchen wall: kitchen → LAUNDRY → MAID BATH → MAID ROOM; no store; her room one door (not from the kitchen);
// the bath private, door only from her room; the escape window kept (its size); the LAUNDRY has priority: two washers, a dryer (stacked), a steam ironing station, a folding / ironing
// table, cupboards, a ceiling drying rack near the window, optionally a sink; a window onto the east yard (insect screen), a strong extract fan with a humidity sensor, a floor drain.
// Local coordinates: x = CSV x − 8.95 (east), y = CSV y (south). Layouts A–C are the study's first round (10 Nov 2026, C recommended); D is the owner's decision.
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
#let esc = ((3.358, 3.4), (3.902, 4.4))         // the maid room's escape casement in the cut wall before D (CSV (12.308, 3.4)–(12.852, 4.4))
#let min-clear = 7.28                           // the maid room's clear area the house adopted as the municipal minimum (V7.0, PROJECT §4.26)
// clear area: an inset of the polygon by half the wall on each edge: the outer walls 0.25 (the north wall, the cut, the east wall), the majlis / courtyard wall x 0 and the kitchen wall y 7.0 0.20, the partitions 0.10
#let inset(P, d) = {
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

// ---------- the layouts: rooms (name, polygon, colour), fixtures (x0, y0, x1, y1, label), the wedge (built-in shelves / wardrobe, INSIDE the cut), doors, windows, label positions ----------
#let col = (laundry: rgb("#d9e6ec"), bath: rgb("#cfe6ef"), room: rgb("#efe3c8"))
#let laundry-fix(m, c, sink: false) = (   // m: the machines' first y on the west wall; c: the cupboards' y on the north partition
  (0.1, m, 0.75, m + 0.6, [washer 1]), (0.1, m + 0.65, 0.75, m + 1.25, [washer 2 + dryer stacked]),
  (0.85, 6.3, 2.65, 6.9, [folding · ironing table 1.8 × 0.6]), (2.7, 6.3, 3.3, 6.9, [steam station]),
  (2.6, c, 3.6, c + 0.6, [cupboards (tall, 0.6)]),
) + (if sink { ((3.6, 5.3, 4.1, 5.75, [small sink]),) } else { () }) + ((2.9, 5.5, 4.2, 6.2, [ceiling drying rack]),)
#let bath-tip = ((0.1, 0.1, 1.0, 1.0, [shower 0.9]), (1.55, 1.0, 2.0, 1.7, [WC]), (1.05, 1.5, 1.45, 1.9, [basin]))
#let A = (
  name: "A · the bath in the tip, the room a true rectangle",
  rooms: (
    ("Maid bath", ((0, 0), (1.511, 0), (cut(2.0), 2.0), (0, 2.0)), "bath"),
    ("Maid room", ((0, 2.0), (cut(2.0), 2.0), (cut(4.6), 4.6), (0, 4.6)), "room"),
    ("Laundry", ((0, 4.6), (cut(4.6), 4.6), (W, 5.245), (W, D), (0, D)), "laundry"),
  ),
  fixtures: bath-tip + ((0.1, 2.6, 1.0, 4.6, [bed 0.9 × 2.0]), (1.3, 2.1, 2.5, 2.6, [desk 1.2 × 0.5])) + laundry-fix(4.75, 4.7, sink: true),
  wedge: ((2.6, 3.3), (cut(3.3), 3.3), (cut(4.6), 4.6), (2.6, 4.6)), wedge-label: [built-in\ wardrobe],
  niche: ((2.6, 2.0), (cut(2.0), 2.0), (cut(3.3), 3.3), (2.6, 3.3)),
  doors: (((0.3, 2.0), (1.0, 2.0), [bath 0.70, from the room]), ((1.55, 4.6), (2.45, 4.6), [room 0.90, from the laundry]), ((0.75, 7.0), (1.65, 7.0), [laundry 0.90 from the kitchen])),
  windows: (((cut(2.2), 2.2), (cut(3.2), 3.2), [escape casement 1.14 × 1.0, moved 1.2 m north on the cut]), ((cut(0.5), 0.5), (cut(1.1), 1.1), [bath vent window]), ((W, 5.4), (W, 6.4), [laundry window 1.0 (insect screen)])),
  esc-moved: true, labels: ("Maid bath": (0.9, 1.25), "Maid room": (1.3, 3.1), "Laundry": (1.9, 5.85)),
)
#let B = (
  name: "B · the laundry 2.8 m deep (the limit test)",
  rooms: (
    ("Maid bath", ((0, 0), (1.511, 0), (cut(2.0), 2.0), (0, 2.0)), "bath"),
    ("Maid room", ((0, 2.0), (cut(2.0), 2.0), (cut(4.2), 4.2), (0, 4.2)), "room"),
    ("Laundry", ((0, 4.2), (cut(4.2), 4.2), (W, 5.245), (W, D), (0, D)), "laundry"),
  ),
  fixtures: bath-tip + ((0.1, 2.2, 1.0, 4.2, [bed 0.9 × 2.0]), (1.3, 2.1, 2.5, 2.6, [desk])) + laundry-fix(4.35, 4.3, sink: true) + ((1.0, 4.35, 2.2, 4.95, [second table / sorting]),),
  wedge: ((2.6, 3.3), (cut(3.3), 3.3), (cut(4.2), 4.2), (2.6, 4.2)), wedge-label: [wardrobe],
  niche: ((2.6, 2.0), (cut(2.0), 2.0), (cut(3.3), 3.3), (2.6, 3.3)),
  doors: (((0.3, 2.0), (1.0, 2.0), [bath 0.70]), ((1.55, 4.2), (2.45, 4.2), [room 0.90]), ((0.75, 7.0), (1.65, 7.0), [laundry 0.90])),
  windows: (((cut(2.2), 2.2), (cut(3.2), 3.2), [escape casement, moved]), ((cut(0.5), 0.5), (cut(1.1), 1.1), [vent]), ((W, 5.4), (W, 6.4), [laundry window])),
  esc-moved: true, labels: ("Maid bath": (0.9, 1.25), "Maid room": (1.3, 3.05), "Laundry": (1.9, 5.85)),
)
#let C = (
  name: "C · the owner's order, the bath on the courtyard side (round 1's recommendation)",
  rooms: (
    ("Maid room", ((0, 0), (1.511, 0), (cut(4.7), 4.7), (1.8, 4.7), (1.8, 3.0), (0, 3.0)), "room"),
    ("Maid bath", ((0, 3.0), (1.8, 3.0), (1.8, 4.7), (0, 4.7)), "bath"),
    ("Laundry", ((0, 4.7), (cut(4.7), 4.7), (W, 5.245), (W, D), (0, D)), "laundry"),
  ),
  fixtures: (
    (0.1, 0.8, 1.0, 2.8, [bed 0.9 × 2.0]), (0.1, 0.1, 1.45, 0.7, [wardrobe 1.35 × 0.6]), (2.3, 3.3, 3.2, 3.8, [desk 0.9 × 0.5, under the window]),
    (0.1, 3.1, 0.95, 3.95, [shower 0.85]), (0.1, 4.05, 0.55, 4.6, [WC]), (1.25, 4.15, 1.7, 4.55, [basin]),
  ) + laundry-fix(4.85, 4.8),
  wedge: ((1.7, 0.35), (cut(2.0), 2.0), (1.7, 2.0)), wedge-label: [shelves],   // INSIDE the cut (round 1 drew this wedge outside the wall: corrected)
  niche: (),
  doors: (((1.0, 3.0), (1.7, 3.0), [bath 0.70, from the room]), ((2.0, 4.7), (2.9, 4.7), [room 0.90, from the laundry]), ((0.75, 7.0), (1.65, 7.0), [laundry 0.90 from the kitchen])),
  windows: ((esc.at(0), esc.at(1), [escape casement 1.14 × 1.0, kept]), ((W, 5.4), (W, 6.4), [laundry window 1.0 (insect screen)])),
  esc-moved: false, labels: ("Maid bath": (1.35, 3.62), "Maid room": (1.6, 1.4), "Laundry": (1.9, 5.85)),
)
// ---------- D (the owner, 10 Nov 2026): the bath against the SOUTH part of the cut wall next to the laundry (its drains straight out, its own window), the room north of it ----------
#let Dl = (
  name: "D · ADOPTED (owner, 10 Nov 2026), refined the same day; 11 Nov 2026: the laundry 1.8 m deep, the kitchen wall on the structural line y 6.5",
  depth: 6.5,
  rooms: (
    ("Maid room", ((0, 0), (1.511, 0), (cut(3.2), 3.2), (1.7, 3.2), (1.7, 4.7), (0, 4.7)), "room"),
    ("Maid bath", ((1.7, 3.2), (cut(3.2), 3.2), (cut(4.7), 4.7), (1.7, 4.7)), "bath"),
    ("Laundry", ((0, 4.7), (cut(4.7), 4.7), (W, 5.245), (W, 6.5), (0, 6.5)), "laundry"),   // 11 Nov 2026 (owner): the kitchen wall on the structural line y 6.5, in line with the women's majlis wall (no jog): 1.8 m deep
  ),
  fixtures: (
    (0.1, 0.1, 1.0, 2.1, [bed 0.9 × 2.0, head north]), (0.1, 2.3, 0.7, 3.65, [wardrobe 1.35 × 0.6]), (1.75, 2.3, 2.55, 2.8, [desk 0.8 × 0.5]),
    (2.75, 3.3, 3.2, 3.9, [WC]), (1.8, 4.0, 2.2, 4.4, [basin]), (2.7, 3.9, 3.6, 4.6, [shower · wet room, no tray]),
    // the 1.8 m laundry (11 Nov 2026): one 0.65 run on the kitchen wall (solid, under beam B6), the table on the majlis wall, a 1.0 m passage
    (1.75, 5.75, 2.35, 6.4, [washer 1]), (2.4, 5.75, 3.0, 6.4, [washer 2 + dryer stacked]), (3.05, 5.8, 3.65, 6.4, [cupboards (tall, 0.6)]), (3.7, 5.8, 4.23, 6.4, [steam station]),
    (0.1, 4.8, 0.7, 6.3, [folding · ironing table 1.5 × 0.6]), (2.9, 5.0, 4.2, 5.6, [ceiling drying rack]),
  ),
  wedge: ((1.7, 0.35), (cut(1.4), 1.4), (1.7, 1.4)), wedge-label: [shelves],   // the narrow north tip inside the room, as built-in shelves
  niche: (),
  doors: (((1.8, 3.2), (2.5, 3.2), [bath 0.70, from the room only]), ((0.75, 4.7), (1.65, 4.7), [room 0.90, from the laundry (moved 0.35 east: the table's end clear)]), ((0.75, 6.5), (1.65, 6.5), [laundry 0.90 from the kitchen, on y 6.5])),
  windows: (((cut(1.5), 1.5), (cut(2.5), 2.5), [escape casement 1.14 × 1.0 on the cut's north part, sill +1.10]), ((cut(3.35), 3.35), (cut(3.95), 3.95), [bath window on the cut above the WC (obscured, sill +1.5)]), ((W, 5.35), (W, 6.25), [laundry window 0.9 (insect screen)])),
  esc-moved: true, labels: ("Maid bath": (2.15, 3.62), "Maid room": (1.0, 4.1), "Laundry": (2.0, 5.3)),
)
#let layouts = (A, B, C, Dl)
#let blk-of(L) = { let d = L.at("depth", default: D); ((0, 0), (1.511, 0), (W, 5.245), (W, d), (0, d)) }   // 11 Nov 2026: D's block ends at the kitchen wall y 6.5 (the structural line); A–C keep y 7.0

// ---------- checks: inside the block, no overlaps (sampled), the three rooms tile the block, every fixture and wedge inside the walls ----------
#let sample(P, step: 0.2) = range(P.len()).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, P.len())); let n = calc.max(1, int(calc.ceil(calc.sqrt(calc.pow(b.at(0) - a.at(0), 2) + calc.pow(b.at(1) - a.at(1), 2)) / step))); range(n + 1).map(k => (a.at(0) + (b.at(0) - a.at(0)) * k / n, a.at(1) + (b.at(1) - a.at(1)) * k / n)) }).join()
#let ray(p, P) = { let c = false; for i in range(P.len()) { let (xi, yi) = P.at(i); let (xj, yj) = P.at(calc.rem(i + 1, P.len())); if (yi > p.at(1)) != (yj > p.at(1)) and p.at(0) < (xj - xi) * (p.at(1) - yi) / (yj - yi) + xi { c = not c } }; c }
#let segd(p, a, b) = { let (dx, dy) = (b.at(0) - a.at(0), b.at(1) - a.at(1)); let L = dx * dx + dy * dy; let t = if L == 0 { 0 } else { calc.max(0, calc.min(1, ((p.at(0) - a.at(0)) * dx + (p.at(1) - a.at(1)) * dy) / L)) }; calc.sqrt(calc.pow(p.at(0) - a.at(0) - t * dx, 2) + calc.pow(p.at(1) - a.at(1) - t * dy, 2)) }
#let bd(p, P) = calc.min(..range(P.len()).map(i => segd(p, P.at(i), P.at(calc.rem(i + 1, P.len())))))
#let strict(p, P) = ray(p, P) and bd(p, P) > 0.01
#let within(p, P) = ray(p, P) or bd(p, P) < 0.002
#let issues(L) = {
  let out = ()
  let blk = blk-of(L)
  for (n, P, c) in L.rooms { if not sample(P).all(p => within(p, blk)) { out.push(n + " leaves the block") } }
  for i in range(L.rooms.len()) { for j in range(i + 1, L.rooms.len()) { let (na, A, _) = L.rooms.at(i); let (nb, B, _) = L.rooms.at(j); if sample(A).any(p => strict(p, B)) or sample(B).any(p => strict(p, A)) { out.push(na + " overlaps " + nb) } } }
  let tot = L.rooms.map(r => area(r.at(1))).sum()
  if calc.abs(tot - area(blk)) > 0.02 { out.push("the rooms do not tile the block: " + r2(tot) + " ≠ " + r2(area(blk))) }
  if L.wedge.len() > 0 and not L.wedge.all(p => within(p, blk)) { out.push("the built-in wedge is drawn outside the walls") }
  for (x0, y0, x1, y1, l) in L.fixtures { let R = ((x0, y0), (x1, y0), (x1, y1), (x0, y1)); if not R.all(p => L.rooms.any(r => within(p, r.at(1)))) { out.push("fixture " + repr(l) + " outside the rooms") } }
  out
}
#let all-issues = layouts.map(issues).join()
#let room-of(L, n) = L.rooms.find(r => r.at(0) == n).at(1)
#let room-clear(L) = clear(room-of(L, "Maid room"))
#let fits(L) = room-clear(L) >= min-clear

// ---------- drawing ----------
#let plan(L, length: 1.0cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, t, size: 4pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, t))
  let D = L.at("depth", default: D); let blk = blk-of(L)
  rect(q((-0.4, -0.3)), q((W + 0.3, 7.5)), fill: rgb("#f3efe6"), stroke: none)
  rect(q((0, D)), q((W, 7.5)), fill: luma(232), stroke: none); T((W / 2, D + 0.25), [kitchen (y #r1(D)–13.0)], size: 3.6pt, fill: gray)
  rect(q((-0.4, 0)), q((0, D)), fill: luma(232), stroke: none); T((-0.2, 3.5), [women's majlis · courtyard], size: 3.4pt, fill: gray, angle: 90deg)
  for (n, P, c) in L.rooms { line(..P.map(q), close: true, fill: col.at(c), stroke: 0.9pt + ink) }
  if L.wedge.len() > 0 { line(..L.wedge.map(q), close: true, fill: rgb("#d8c39a"), stroke: 0.4pt + ink); let cxy = (L.wedge.map(p => p.at(0)).sum() / L.wedge.len() + 0.1, L.wedge.map(p => p.at(1)).sum() / L.wedge.len()); T(cxy, L.wedge-label, size: 3.1pt) }
  if L.niche.len() > 0 { line(..L.niche.map(q), close: true, fill: rgb("#f7f1e2"), stroke: (paint: gray, thickness: 0.3pt, dash: "dashed")); T((2.95, 2.75), [window\ niche], size: 3.2pt, fill: gray) }
  for (x0, y0, x1, y1, l) in L.fixtures {
    let t = repr(l)
    let wet = t.contains("WC") or t.contains("basin") or t.contains("shower") or t.contains("sink") or t.contains("washer")
    rect(q((x0, y0)), q((x1, y1)), fill: if wet { white } else { rgb("#fbf6ea") }, stroke: 0.4pt + (if wet { blue } else { rgb("#8a7a5a") }))
    if t.contains("rack") { rect(q((x0, y0)), q((x1, y1)), fill: none, stroke: (paint: amber, thickness: 0.5pt, dash: "dashed")) }
    T(((x0 + x1) / 2, (y0 + y1) / 2), l, size: 3.0pt, angle: if (y1 - y0) > (x1 - x0) * 1.4 { 90deg } else { 0deg })
  }
  line(..blk.map(q), close: true, stroke: 2pt + ink)
  for (a, b, l) in L.doors { line(q(a), q(b), stroke: 3.2pt + red) }
  for (a, b, l) in L.windows { line(q(a), q(b), stroke: 3pt + blue) }
  if L.esc-moved { line(q(esc.at(0)), q(esc.at(1)), stroke: (paint: blue, thickness: 0.8pt, dash: "dashed")) }
  for (n, P, c) in L.rooms { T(L.labels.at(n), [*#n*\ #r2(area(P)) m² axes · ≈ #r2(clear(P)) clear], size: if n == "Maid bath" { 2.9pt } else { 3.3pt }) }
  line(q((0, 7.75)), q((1, 7.75)), stroke: 1pt + ink); T((0.5, 7.95), [1 m], size: 3.4pt)
})
#let list-of(items) = items.map(((a, b, l)) => l).join([ · ])

// ====================================================================================== PAGE 1
#text(14pt, weight: "bold", fill: green)[The maid's wing re-planned · laundry first · Taif / Palm House V10.0]
#v(1pt)
#block(fill: rgb("#e4eedf"), inset: 4pt, radius: 2pt, width: 100%)[#text(8.5pt, weight: "bold", fill: green)[LAYOUT D ADOPTED (owner, 10 Nov 2026)] #text(7pt, weight: "bold")[· 11 Nov 2026 (owner, the straight-walls rule): the laundry 1.8 m deep (y 4.7–6.5), its kitchen wall on the structural line y 6.5 in line with the women's majlis wall; the maid room and bath unchanged ·] #text(7pt)[· the bath against the south part of the cut wall next to the laundry (its drains straight out through the cut wall to the east branch, its own window), the room north of it with the shelf wedge in the north tip, the bed, the wardrobe and a small desk, the escape casement on the cut's north part; no store (G21 removed). *Refined the same day (owner):* the bath a simple 1.5 m deep wet room like the guest WC (a wall-mounted shower and mixer over a floor drain with falls, tanked and tiled, no tray, no cubicle), shrunk in one direction (y 3.2–4.7); the gained strip to the room: the bed in the north corner with its head on the north wall, the wardrobe on the majlis wall south of it. Applied to `data/rooms_gf.csv`, `design_gf.typ`, `studies/east_wing.typ` and the presentation (sheets 02 and 08). Round 1 (A–C, C recommended) is kept below as the record; C's wedge, drawn outside the cut wall in round 1, is corrected.]]
#v(2pt)
#text(7.4pt, fill: gray)[The owner's brief (10 Nov 2026): one roof span, no columns, light partitions placed freely; the order along the kitchen wall *kitchen → laundry → maid bath → maid room*; no store; her room one door (not from the kitchen), bed, wardrobe, small desk, the escape window kept; her bath private, door only from her room; the laundry the priority. Block #r2(W) × #r2(D) m, #r2(area(blk)) m² on axes (the cut wall from (1.511, 0) to (#r2(W), 5.245)); local x = CSV x − 8.95; the dashed blue line = the escape window's place before D.]
#v(2pt)
#grid(columns: (1fr, 1fr, 1fr, 1fr), column-gutter: 3pt, ..layouts.map(L => plan(L)))
#v(2pt)
#table(columns: (auto, 1fr, 1fr, 1fr, 1.15fr), inset: 2.2pt, stroke: 0.4pt + luma(175), fill: (_, y) => if y == 0 { rgb("#e4eedf") },
  [*Layout*], ..layouts.map(L => text(weight: "bold", size: 6.6pt)[#L.name]),
  [Laundry (axes · ≈ clear)], ..layouts.map(L => { let P = room-of(L, "Laundry"); [#r2(area(P)) · *#r2(clear(P)) m²*] }),
  [Maid room (axes · ≈ clear, built-ins inside)], ..layouts.map(L => { let P = room-of(L, "Maid room"); [#r2(area(P)) · *#r2(clear(P)) m²* #if fits(L) [✓ ≥ #r2(min-clear)] else [#text(fill: red)[✗ < #r2(min-clear): does not fit]]] }),
  [Maid bath (axes · ≈ clear)], ..layouts.map(L => { let P = room-of(L, "Maid bath"); [#r2(area(P)) · *#r2(clear(P)) m²*] }),
  [The room], [a 2.6 × 2.6 rectangle with the deep wedge wardrobe on its east side and a window niche], [the same, 0.4 m shorter: too small], [a 2.6 × 3.0 rectangle with a shelf wedge in the north tip, the wardrobe on the north wall, a desk alcove under the kept window], [the bed in the north corner (its head on the north wall), the wardrobe on the majlis wall south of it, the shelf wedge in the tip, the desk under the escape window, the door end beside the bath: no slanted wall meets the floor except the window's (refined 10 Nov 2026: the bath 1.5 m deep, the room 0.4 m longer east of x 1.7)],
  [Escape window], [moved 1.2 m north on the cut], [moved], [kept at y 3.4–4.4], [on the cut's north part (y 1.5–2.5), 1.14 × 1.0, sill +1.10, no screen],
  [Bath], [in the tip, a window on the cut], [as A], [internal, an extract fan; the drains ≈ 3 m under the laundry], [on the cut wall's south part, 1.5 m deep: a simple wet room like the guest WC (a wall-mounted shower over a floor drain, no tray, no cubicle), the WC under its own window, a basin; the drains straight out through the cut wall (≈ 1 m)],
  [Doors], ..layouts.map(L => text(size: 6.2pt)[#list-of(L.doors)]),
  [Windows], ..layouts.map(L => text(size: 6.2pt)[#list-of(L.windows)]),
)
#v(2pt)
#text(7.5pt)[#if all-issues.len() == 0 [*Maid wing study checks passed* (4 layouts: inside the block, no overlaps, the rooms tile the block, every fixture and wedge inside the walls; D's room #r2(room-clear(Dl)) m² clear ≥ #r2(min-clear))] else [*CHECKS FAILED:* #all-issues.join([; ])]]

// ====================================================================================== PAGE 2
#pagebreak()
#text(12pt, weight: "bold", fill: green)[Layout D in detail · the laundry · what was decided]
#v(3pt)
#grid(columns: (1.1fr, 1fr), gutter: 12pt,
  [
    #H[1 · The laundry (D, 11 Nov 2026: 1.8 m deep, the whole width, y 4.7–6.5; ≈ #r2(clear(room-of(Dl, "Laundry"))) m² clear)]
    - *The kitchen wall on the structural line y 6.5* (the owner's straight-walls rule, 11 Nov 2026): one line with the women's majlis wall across the courtyard's corner, under beam B6; the laundry a 1.8 m galley (≈ 1.65 clear) with *one 0.65 m run on the kitchen wall* (solid, 0.20: anti-vibration feet, the wall lined) and a *1.0 m passage* in front of it.
    - *Machines* east of the kitchen entrance: *washer 1* and *washer 2 with the dryer stacked on it* (x 1.75–3.0), then the *tall cupboards* 0.6 and the *steam ironing station* 0.55 × 0.6 at the east end (the generator on a shelf below, the board stored folded); the water and drain points behind the machines, the floor drain (an anti-odour membrane trap, a trap primer) under the stacked column; a tap and a hose point beside it; a socket group above the run.
    - *The folding / ironing table* 1.5 × 0.6 across the west end on the women's majlis wall (its end 0.05 m from the maid door's jamb), open shelves above it; the ironing board folds out from the cupboard.
    - *The ceiling drying rack* (a pulley rack 1.3 × 0.6) over the passage's east end in front of the *window* 0.9 × 1.0 on the straight east wall (y 5.35–6.25, sill +1.1, an insect screen); above it the *extract fan* (≈ 150–200 m³/h, a humidity sensor and a timer, a backdraught shutter outside); *finishes:* porcelain floor to a drain, washable walls to the ceiling, a moisture-resistant ceiling, the machines on a drip tray.
    - *Doors:* the laundry's door 0.90 from the kitchen on y 6.5 (x 0.75–1.65; today an open entrance: a door keeps the humidity and the noise out of the kitchen); the maid room's door 0.90 moved 0.35 m east to the same x (x 0.75–1.65, its east jamb at the bath's partition), from the laundry (her only door; not from the kitchen); the 0.6 m in front of both doors kept free. *The maid room and bath unchanged.* *No sink* (the kitchen's sink is 2 m away; optional); *no yard door* (the straight east wall is 1.75 m and the window takes it; the kitchen's service door is a step away round the corner).
    #H[2 · The maid bath (D refined; 1.5 m deep, ≈ #r2(clear(room-of(Dl, "Maid bath"))) m² clear)]
    - Against the south part of the cut wall, x 1.7 to the cut, y 3.2–4.7 (≈ 1.4 m clear deep, 1.3–2.2 m wide): *a simple wet room like the guest WC:* a *wall-mounted shower and mixer* in the wide south-east corner (the obtuse corner against the cut) over a *floor drain with falls*, the whole floor and the walls *tanked and tiled*, *no shower tray, no cubicle wall* (a short 10 cm block wall of 0.6 m between the shower and the WC only if the owner wants the WC kept dry); the *WC* against the cut wall under its *window* (y 3.35–3.95 on the cut, obscured, sill +1.5); the *basin* on the west partition beside the door; the door 0.70 on its north wall, *from her room only*, opening in. The drains leave straight through the cut wall (≈ 1 m) to the east branch and the yard manhole: short, one slope; the extract fan beside the window.
    #H[3 · The maid room (D; #r2(area(room-of(Dl, "Maid room"))) m² on axes, ≈ #r2(room-clear(Dl)) m² clear ≥ #r2(min-clear))]
    - North of the bath, 0.4 m longer than before east of x 1.7 (the bath's strip y 2.8–3.2 gained): the *bed* 0.9 × 2.0 *in the north corner, its head on the north wall* (the majlis wall at its side), the *wardrobe* 1.35 × 0.6 on the majlis wall south of the bed (the best remaining wall: solid, no window, 1.0 m passage to the door), the *shelf wedge* in the north tip inside the room (its front on x 1.7, 0–0.6 deep, beside the bed's head), the *small desk* under the *escape casement* on the cut's north part (y 1.5–2.5, 1.14 × 1.0, sill +1.10, obscured below +1.60, no screen: the same opening), the door 0.90 from the laundry at the room's south-west, the 1.7 × 1.5 m part beside the bath as the entry. No slanted wall meets the floor except the window's.
  ],
  [
    #H[4 · Round 1 (A–C) and why D]
    - *A* put the bath in the tip (a window, but the bath far from the laundry) and made the room a 2.6 × 2.6 rectangle by moving the window; *B* showed the limit (a laundry deeper than ≈ 2.4 m starves the room); *C* followed the order but left the bath internal, with no window and ≈ 3 m of drain under the laundry.
    - *D* keeps the order, gives the bath the cut wall (its own window, the shortest drain, the east cluster) and the room the north wall and the majlis wall (the bed and the wardrobe on solid walls, the shelf wedge using the tip); it is the owner's decision.
    #H[5 · Applied now (lean) · for the next release]
    - *Now:* `data/rooms_gf.csv` (G05 maid bath, G06 maid room, G07 laundry as polygons; G21 the store removed), `design_gf.typ` (the doors, the windows, the note), `studies/east_wing.typ` (the rooms, the fixtures, the doors and windows: the presentation's ground-floor sheet reads them), the presentation (sheet 02 and sheet 08's note).
    - *Next release:* the 3D and the DXFs, `studies/plumbing.typ` (the bath's branch through the cut wall, the laundry's drain and its machines' points), the structure notes (the partitions on the slab), `studies/fire_escape.typ` (the casement's new place), the presentation's sheet 06 text, `PROJECT_V10.md` §3 / §4, `OPEN_ITEMS.md` (the laundry's extract and the bath's fan to the MEP engineer, item 9), `tools/check.py` (this study's job; the east wing's room total unchanged at 49.22 m²).
    #v(4pt)
    #block(fill: rgb("#f1efe8"), inset: 5pt, radius: 2pt, width: 100%)[
      #set text(lang: "ar", dir: rtl, size: 7.2pt)
      *جناح الخادمة، التخطيط D (قرار المالك، 10 نوفمبر 2026):* الترتيب من المطبخ: الغسيل ثم حمام الخادمة ثم غرفتها. *الحمام* على الجزء الجنوبي من الجدار المائل بجوار الغسيل، بعمق 1.5 م، بسيط كدورة مياه الضيوف: دش ومخلاط معلقان على الجدار فوق مصرف أرضي بميول، معزول ومبلط، بلا حوض ولا كابينة (جدار قصير 10 سم فقط إن أراد المالك إبقاء المرحاض جافا)؛ صرفه يخرج مباشرة عبر الجدار المائل، وله نافذته فوق المرحاض؛ مرحاض ومغسلة؛ بابه من غرفتها فقط. *الغرفة* شمال الحمام وقد كسبت شريط الحمام: السرير في الزاوية الشمالية ورأسه على الجدار الشمالي، الدولاب على جدار المجلس جنوب السرير، الرفوف المدمجة في الزاوية الضيقة عند الطرف الشمالي داخل الغرفة، مكتب صغير تحت نافذة الهروب على الجزء الشمالي من الجدار المائل (بالمقاس نفسه)، وباب واحد من الغسيل لا من المطبخ؛ نحو #r2(room-clear(Dl)) م² صافيا (الحد الأدنى #r2(min-clear)). *الغسيل* كما في C: غسالتان ومجفف فوق إحداهما، طاولة طي وكي، محطة كي بالبخار، دواليب، رف تجفيف في السقف عند النافذة الشرقية، مروحة شفط بحساس رطوبة، مصرف أرضي؛ نحو #r2(clear(room-of(Dl, "Laundry"))) م² صافيا. لا مخزن. طُبّق على مخطط الدور الأرضي ولوحة الدور الأرضي وجدول المساحات في العرض؛ وتتبع المجسّم ومخططات الكاد ودراسة السباكة في الإصدار القادم.
    ]
    #v(3pt)
    #text(6.2pt, fill: gray)[Every size is on axes unless "clear"; the clear areas take 0.25 for the outer walls and the cut, 0.20 for the majlis and kitchen walls, 0.10 for the partitions; the fixtures are concept sizes. The drains, the extract and the electrical points are for the engineers.]
  ],
)

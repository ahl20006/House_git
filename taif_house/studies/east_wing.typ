// east_wing.typ · Taif / Palm House · layout study of the EAST SERVICE BLOCK: kitchen + laundry + maid room + maid bath + air tower (compile THIS file)
// Ground floor V6.3. Stand-alone: all data is in this file.
// Main CSV coordinates (../data/rooms_gf.csv) = local + (8.95, 0); block = CSV x 8.95–13.311, y 0–13.0. Keep both in step when you change a room here.
#import "@preview/cetz:0.4.2"
#set page(paper: "a4", margin: 12mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 8pt)

// ---------- The block (local metres: origin = NW corner, x east, y SOUTH) · NOT a rectangle: NE corner cut by the lane wall ----------
#let block = ((0, 0), (1.511, 0), (4.361, 5.245), (4.361, 13.0), (0, 13.0))   // wall centre lines; one slope to y 6.0, then straight
#let scale = 1.15cm

// ---------- V10.0: the malqaf moved to the courtyard's north-west corner (L5): no air tower in this block; the cut tip is the maid's store ----------

// ---------- Rooms: (name, x, y, w, d, colour) · x, y = centre ----------
// put // in front of a line to switch a room off
#let rooms-data = (
  ("Kitchen",   2.1805, 10.0,  4.361, 6.0,   "kitchen"),   // y 7.0–13.0 (V6.4: the north wall 0.5 m south of the structural line y 6.5, a non-load-bearing partition)
)

// ---------- Rooms along the cut wall: polygons (name, corner points, colour) so they run up to the sloped wall ----------
// cut wall (8 Nov 2026: a further 0.24 m out; 6 Nov 2026: 0.12 m): x = 1.511 + y × 3.26 / 6.0 (y 0–5.245) · at y 1.0 → 2.054, at y 2.8 → 3.032, at y 5.245 → 4.361
#let poly-rooms = (
  // 10 Nov 2026 (owner): the maid's wing LAYOUT D (studies/maid_wing.typ, adopted): kitchen → laundry (y 4.7–7.0, the whole width) → maid bath (the cut wall's south part) → maid room (north); no store
  ("Maid bath", ((1.7, 2.8), (3.032, 2.8), (4.0648, 4.7), (1.7, 4.7)), "wc"),
  ("Maid room", ((0, 0), (1.511, 0), (3.032, 2.8), (1.7, 2.8), (1.7, 4.7), (0, 4.7)), "maid"),
  ("Laundry", ((0, 4.7), (4.0648, 4.7), (4.361, 5.245), (4.361, 7.0), (0, 7.0)), "laundry"),
)

// ---------- Fixtures inside rooms (drawn thin, not counted, on finished wall faces): (x0, y0, x1, y1, label) ----------
#let fixtures = (
  (0.1, 7.5, 0.7, 8.9, [sink]),   // the sink moved north with its window (owner, 1 Nov 2026): the window y 7.3–8.9 looks at the fountain and the tree
  (0.1, 8.9, 0.7, 9.5, [d/w]),
  (0.1, 9.5, 0.7, 12.9, [counter 0.6]),   // the outdoor TV on the courtyard face of this wall
  (3.636, 8.2, 4.236, 10.2, [cooking counter 0.6]),   // starts 0.1 south of the service door (V6.4)
  (3.636, 10.2, 4.236, 11.2, [hob + hood · extract through the east wall]),   // the hood south of the east window (y 8.7–10.1), 2.1 m from the service door, 4.2 m from C32
  (3.636, 11.2, 4.236, 12.9, [fridge + tall storage]),
  // layout D (10 Nov 2026): the laundry
  (0.1, 5.3, 0.75, 5.9, [washer 1]),
  (0.1, 5.95, 0.75, 6.55, [washer 2 + dryer]),
  (0.85, 6.3, 2.65, 6.9, [folding · ironing table]),
  (2.7, 6.3, 3.3, 6.9, [steam station]),
  (3.0, 4.8, 4.0, 5.4, [cupboards]),
  (2.9, 5.5, 4.2, 6.2, [ceiling drying rack]),
  // the maid bath on the cut wall's south part
  (2.6, 3.75, 3.45, 4.6, [shower]),
  (2.55, 3.0, 3.0, 3.6, [WC]),
  (1.8, 3.9, 2.2, 4.3, [basin]),
  // the maid room north of it
  (0.1, 0.1, 1.45, 0.7, [wardrobe]),
  (0.1, 0.8, 1.0, 2.8, [bed 0.9 × 2.0]),
  (1.7, 0.9, 2.0, 1.4, [shelves]),   // the shelf wedge in the north tip (drawn as its rectangular core)
  (1.75, 2.25, 2.55, 2.75, [desk]),
)

// ---------- Doors and windows: ((x1, y1), (x2, y2), label) ----------
#let doors = (
  ((0.45, 13.0), (1.55, 13.0), [kitchen ↔ dining]),
  ((4.361, 7.2), (4.361, 8.1), [service door 0.90 · east yard · lockable]),   // owner decision: north end of the kitchen's east wall, near the laundry (V6.4: moved 0.5 with the wall)
  ((0.75, 7.0), (1.6, 7.0), [open entrance kitchen ↔ laundry (no door)]),
  ((0.4, 4.7), (1.3, 4.7), [laundry ↔ maid room 0.90 (D)]),
  ((1.8, 2.8), (2.5, 2.8), [maid room ↔ maid bath · 0.70, from her room only (D)]),
)
#let windows = (
  ((0.0, 7.3), (0.0, 8.9), [sink window (courtyard)]),   // moved north over the sink (owner, 1 Nov 2026)
  ((4.361, 8.7), (4.361, 10.1), [kitchen window (east)]),
  ((2.326, 1.5), (2.869, 2.5), [maid room escape window\ 1.14 × 1.00, sill +1.10 (D: the cut's north part)]),   // one casement, obscured glass below +1.60, no screen (fire safety, owner 1 Nov 2026)
  ((3.141, 3.0), (3.467, 3.6), [maid bath window (D)]),
  ((4.361, 5.4), (4.361, 6.4), [laundry window (east yard)]),
)

// ---------- Walls that must stay solid ----------
#let solid = (
  ((0.0, 0.0), (0.0, 6.5), [solid wall to the women's majlis (no door, no window)]),
)

// ---------- Neighbours (grey) ----------
#let neighbours = (
  ((-2.2, 0), (0, 6.5), [Women's majlis]),
  ((-2.2, 6.5), (0, 13.0), [Courtyard]),
  ((0, 13.0), (4.361, 14.7), [Living (normal height) · dining]),
)

// ---------- Helpers ----------
#let colours = (wc: rgb("#d9e6ec"), maid: rgb("#e4e9d6"), laundry: rgb("#dfe3e6"), kitchen: rgb("#d9e6ec"))
#let rows = rooms-data.map(((n, x, y, w, d, c)) => (name: n, x: x, y: y, w: w, d: d, colour: c))
#let box(r) = (r.x - r.w / 2, r.y - r.d / 2, r.x + r.w / 2, r.y + r.d / 2)
#let corners(r) = { let (a, b, c, d) = box(r); ((a, b), (c, b), (c, d), (a, d)) }
#let q(x, y) = (x, -y)
#let r2(v) = str(calc.round(v, digits: 2))
#let area(P) = calc.abs(range(P.len()).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, P.len())); a.at(0) * b.at(1) - b.at(0) * a.at(1) }).sum()) / 2
// inside a convex polygon (the block is convex), boundary counts as inside
#let inside(p, P) = range(P.len()).all(i => {
  let a = P.at(i); let b = P.at(calc.rem(i + 1, P.len()))
  (b.at(0) - a.at(0)) * (p.at(1) - a.at(1)) - (b.at(1) - a.at(1)) * (p.at(0) - a.at(0)) >= -0.001
})
// overlap of two convex polygons (separating-axis test); touching edges do not count
#let proj(P, u) = { let v = P.map(p => p.at(0) * u.at(0) + p.at(1) * u.at(1)); (calc.min(..v), calc.max(..v)) }
#let overlap(P, Q, eps: 0.001) = {
  for S in (P, Q) {
    for i in range(S.len()) {
      let a = S.at(i); let b = S.at(calc.rem(i + 1, S.len()))
      let n = (b.at(1) - a.at(1), a.at(0) - b.at(0))
      let L = calc.sqrt(n.at(0) * n.at(0) + n.at(1) * n.at(1))
      if L > 1e-9 {
        let (p0, p1) = proj(P, (n.at(0) / L, n.at(1) / L)); let (q0, q1) = proj(Q, (n.at(0) / L, n.at(1) / L))
        if p1 <= q0 + eps or q1 <= p0 + eps { return false }
      }
    }
  }
  true
}
#let centroid(P) = (P.map(p => p.at(0)).sum() / P.len(), P.map(p => p.at(1)).sum() / P.len())

// ---------- Checks (polygon-aware: rectangles and the sloped rooms) ----------
#let issues = ()
#let convex-parts = ("Maid room": (((0, 0), (1.511, 0), (3.032, 2.8), (1.7, 2.8), (0, 2.8)), ((0, 2.8), (1.7, 2.8), (1.7, 4.7), (0, 4.7))))   // D: the maid room is an L: tested as two convex parts
#let shapes = rows.map(r => (r.name, corners(r))) + poly-rooms.map(((n, P, c)) => convex-parts.at(n, default: (P,)).map(Q => (n, Q))).join()
#for (n, P) in shapes { if not P.all(p => inside(p, block)) { issues.push(n + " leaves the block") } }
#for i in range(shapes.len()) {
  for j in range(i + 1, shapes.len()) {
    if shapes.at(i).at(0) != shapes.at(j).at(0) and overlap(shapes.at(i).at(1), shapes.at(j).at(1)) { issues.push(shapes.at(i).at(0) + " overlaps " + shapes.at(j).at(0)) }
  }
}
#let used = rows.map(r => r.w * r.d).sum(default: 0) + poly-rooms.map(((n, P, c)) => area(P)).sum(default: 0)
#let leftover = area(block) - used

// ---------- Page ----------
#text(16pt, weight: "bold", fill: rgb("#2f6b4f"))[East service block · kitchen, laundry, maid wing · layout study (V10.0; the maid's wing layout D, 10 Nov 2026)]\
#text(8pt, fill: gray)[Taif / Palm House · Ground floor V7.1 · block = CSV x 8.95–13.311, y 0–13.0 (NE corner cut) · #r2(area(block)) m² · scale 1 m = 1.15 cm · north up]
#v(6pt)
#grid(columns: (auto, 1fr), column-gutter: 20pt,
  cetz.canvas(length: scale, {
    import cetz.draw: *
    for ((a, b), (c, d), l) in neighbours {
      rect(q(a, b), q(c, d), fill: luma(240), stroke: (paint: luma(190), dash: "dashed"))
      content(q((a + c) / 2, (b + d) / 2), text(6.5pt, fill: gray, l))
    }
    line(..block.map(p => q(..p)), close: true, fill: rgb("#f3efe6"), stroke: none)   // leftover slivers would show in this tone
    for r in rows {
      let (x0, y0, x1, y1) = box(r)
      rect(q(x0, y0), q(x1, y1), fill: colours.at(r.colour, default: luma(230)), stroke: 0.6pt + rgb("#3d4a45"))
      content(q((x0 + x1) / 2, (y0 + y1) / 2 - 0.35), align(center, text(6.5pt)[*#r.name*\ #r2(r.w) × #r2(r.d) · #r2(r.w * r.d) m²]))
    }
    for (n, P, c) in poly-rooms {
      line(..P.map(p => q(..p)), close: true, fill: colours.at(c, default: luma(230)), stroke: 0.6pt + rgb("#3d4a45"))
      let m = if n == "Maid room" { (0.85, 3.6) } else if n == "Maid bath" { (2.1, 3.4) } else { let c = centroid(P); (c.at(0) + 0.2, c.at(1)) }
      content(q(..m), align(center, text(6.5pt)[*#n*\ sloped · #r2(area(P)) m²]))
    }
    for (x0, y0, x1, y1, l) in fixtures {
      rect(q(x0, y0), q(x1, y1), fill: white.transparentize(30%), stroke: 0.4pt + gray)
      content(q((x0 + x1) / 2, (y0 + y1) / 2), angle: if (y1 - y0) > (x1 - x0) { 90deg } else { 0deg }, text(5pt, fill: gray, l))
    }
    line(..block.map(p => q(..p)), close: true, stroke: 2pt + rgb("#3d4a45"))
    for ((a, b), (c, d), l) in solid {
      line(q(a, b), q(c, d), stroke: 3pt + rgb("#3d4a45"))
      content(q(a - 0.1, (b + d) / 2), anchor: "east", angle: 90deg, text(5.5pt, l))
    }
    for ((a, b), (c, d), l) in windows {
      line(q(a, b), q(c, d), stroke: 3pt + rgb("#1f7a99"))
      let x = if a < 0.01 { a - 0.12 } else { a + 0.12 }
      content(q(x, (b + d) / 2), anchor: if a < 0.01 { "east" } else { "west" }, text(6pt, fill: rgb("#1f7a99"), l))
    }
    for ((a, b), (c, d), l) in doors {
      line(q(a, b), q(c, d), stroke: 4pt + rgb("#b5452f"))
      content(q(c + 0.1, b), anchor: "west", text(6pt, fill: rgb("#b5452f"), l))
    }
    line(q(0, 15.3), q(1, 15.3), stroke: 1.2pt)
    content(q(0.5, 15.55), text(6pt)[1 m])
  }),
  [
    #set text(6.4pt)
    #text(10pt, weight: "bold", fill: rgb("#2f6b4f"))[Rooms]
    #table(columns: (auto, auto, auto), stroke: none, inset: 3pt,
      [*Room*], [*w × d (m)*], [*m²*],
      ..poly-rooms.map(((n, P, c)) => ([#n], [sloped (to the cut wall)], [#r2(area(P))])).flatten(),
      ..rows.map(r => ([#r.name], [#r2(r.w) × #r2(r.d)], [#r2(r.w * r.d)])).flatten(),
      [Leftover slivers along the cut], [], [#r2(leftover)],
      [*Block*], [], [*#r2(area(block))*],
    )
    #v(6pt)
    #if issues.len() == 0 { text(fill: rgb("#2f6b4f"), weight: "bold")[✓ All rooms inside the block, no overlaps] } else { std.block(fill: rgb("#fbe3dd"), inset: 5pt, radius: 2pt)[#text(fill: rgb("#b5452f"), weight: "bold")[WARNING]\ #issues.map(i => [• #i]).join(linebreak())] }
    #v(8pt)
    #text(10pt, weight: "bold", fill: rgb("#2f6b4f"))[Route]
    *Family:* living (normal height) · dining → kitchen (south door).\
    *Maid (D):* kitchen → laundry → her room → her bath. No external door and no other door: all her movement passes through the kitchen and the laundry.\
    *Cooking:* sink on the courtyard wall under its window (y 7.3–8.9, looking at the courtyard's fountain and tree; the outdoor TV on the courtyard face of the wall further south), hob and hood on the east (outside) wall, so heat and smoke leave the house; fridge and tall storage at the south-east, next to the dining door; the east duct in the north-east corner.
    #v(6pt)
    #text(10pt, weight: "bold", fill: rgb("#2f6b4f"))[Rules]
    - Kitchen isolated: doors only to the dining area (south) and the laundry (north). No door to the courtyard, riwaq or women's majlis.
    - Kitchen 4.361 × 6.0 m on axes (26.17 m², ≈ 24.0 m² clear, ≈ 4.136 m clear wide), y 7.0–13.0 (V6.4: its north wall is a non-load-bearing partition 0.5 m south of the structural line y 6.5, so the maid room reaches the municipal minimum). No island: two parallel counter runs, the sink run 5.4 m on the courtyard wall and the cooking run 3.0 m (y 8.2–11.2, the hob and hood at y 10.2–11.2 south of the east window) plus the fridge and tall storage on the east outside wall; ≈ 2.94 m between the counter fronts. The heavy (dirty) kitchen; the hospitality kitchen in the west block is the light one.
    - *Laundry (layout D, 10 Nov 2026; `studies/maid_wing.typ` adopted):* across the whole width from the kitchen, y 4.7–7.0 (≈ 8.8 m² clear): two washers and a stacked dryer on the majlis wall (y 5.3–6.55), the folding / ironing table 1.8 × 0.6 and the steam station on the kitchen wall, tall cupboards on the north partition, the ceiling drying rack at the east window (y 5.4–6.4, insect screen) with the extract fan (humidity sensor) above it, a floor drain; the door 0.90 from the kitchen (was an open entrance); no sink, no yard door.
    - *Maid room (D):* north of the bath, the north tip and the majlis wall: the bed 0.9 × 2.0 on the majlis wall, the main wardrobe 1.35 × 0.6 on the north wall, the shelf wedge in the north tip (front on x 1.7), the small desk under the escape casement on the cut's north part (y 1.5–2.5: 1.14 × 1.00, sill +1.10, obscured below +1.60, no screen); its one door 0.90 from the laundry at the south-west; ≈ 9.6 m² on axes, ≈ 8.3 m² clear (≥ the 7.28 the house adopted as the municipal minimum).
    - *Maid bath (D):* against the south part of the cut wall next to the laundry (x 1.7 to the cut, y 2.8–4.7; ≈ 3.5 m² on axes, ≈ 3.0 m² clear): the shower 0.85 in the obtuse south-east corner, the WC under the window on the cut (y 3.0–3.6, obscured), the basin on the west partition; the door 0.70 from her room only; the drains straight out through the cut wall (≈ 1 m) to the east branch; an extract fan.
    - Main cross walls: y 7.0 (kitchen / laundry, V6.4: a straight non-load-bearing block partition on a thickened slab or ground beam; the structural line y 6.5 keeps its beam B6 inside the laundry / maid room ceiling, hidden by the gypsum ceiling, carrying the first-floor wall above) and y 13.0 (dining). Exterior walls and the air tower fixed; all interior walls straight and square. Walls: the maid bath block with waterproofing (wet room); 100 mm for the dry laundry / maid partition; 150–200 mm for walls carrying pipes (maid bath, laundry sink wall).
    - Solid wall (no door, no window) between the maid wing and the women's majlis.
    - The malqaf (V10.0, L5) is at the courtyard's north-west corner: nothing of the air system in this block; no breeze channel under the maid wing.
    - No store (D): the cut tip is inside the maid room (the shelf wedge).
    - Plumbing: kitchen, laundry and maid bath drain under the slab straight out to the east, to a manhole in the east service yard; no east duct; the vent stack runs up the outside face of the east wall and the kitchen extract leaves straight through the east wall at the hood. Coordinate drain depths with the air tunnel (also under the east side).
    - Service door (owner decision): a lockable 0.90 m door in the kitchen's east wall at its north end (y 7.2–8.1, V6.4), near the laundry, to the east service yard (rubbish, deliveries, gas); the cooking counter starts 0.1 m south of it (y 8.2); the stack outside the east wall sits between the door and the kitchen window (y 8.1–8.7, 0.6 m: MEP to confirm); the hood (y 10.2–11.2) is clear of the door and of column C32 (y 5.7–6.3). Gas (if used): cylinder cabinet outside the east wall in the service yard.
  ],
)

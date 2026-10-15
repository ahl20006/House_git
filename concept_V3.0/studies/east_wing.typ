// east_wing.typ · Taif / Palm House · layout study of the EAST SERVICE BLOCK: kitchen + laundry + maid room + maid bath + air tower (compile THIS file)
// Stand-alone: all data is in this file. Main CSV coordinates = local + (9, 0)  (block = CSV x 9–13, y 0–12.5).
// Integrated in ../design_v3.typ + ../data/rooms_v3.csv (V3.1, 15 Oct 2026): keep both in step when you change a room here.
#import "@preview/cetz:0.4.2"
#set page(paper: "a4", margin: 12mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 8pt)

// ---------- The block (local metres: origin = NW corner, x east, y SOUTH) · NOT a rectangle: NE corner cut by the lane wall ----------
#let block = ((0, 0), (1.051, 0), (4, 5.427), (4, 12.5), (0, 12.5))   // wall centre lines
#let scale = 1.3cm

// ---------- Air tower: polygon in the tip of the cut corner ----------
#let tower = ((0, 0), (1.051, 0), (1.703, 1.2), (0, 1.2))

// ---------- Rooms: (name, x, y, w, d, colour) · x, y = centre ----------
// put // in front of a line to switch a room off
#let rooms-data = (
  ("Laundry",   0.75,  4.4,    1.5,  3.2,   "laundry"),   // vertical, on the west wall (women's majlis side): x 0–1.5, y 2.8–6.0, up to the maid bath
  ("Kitchen",   2.0,   9.25,   4.0,  6.5,   "kitchen"),   // y 6.0–12.5, exactly on the courtyard lines
)

// ---------- Rooms along the cut wall: polygons (name, corner points, colour) so they run up to the sloped wall ----------
// cut wall: x = 1.051 + y × 2.949 / 5.427 (y 0–5.427) · at y 1.2 → 1.703, at y 2.8 → 2.572
#let poly-rooms = (
  ("Maid bath", ((0, 1.2), (1.703, 1.2), (2.572, 2.8), (0, 2.8)), "wc"),           // 1.6 m deep on the women's majlis wall
  ("Maid room", ((1.5, 2.8), (2.572, 2.8), (4, 5.427), (4, 6.0), (1.5, 6.0)), "maid"),   // east of the laundry, down to y 6.0
)
// convex parts for the overlap check (only needed for a room that is not convex)
#let convex-parts = (:)

// ---------- Fixtures inside rooms (drawn thin, not counted): (x0, y0, x1, y1, label) ----------
#let fixtures = (
  (0.0, 7.0, 0.6, 12.2, [sink counter 0.6 · window to courtyard]),
  (3.4, 6.1, 4.0, 10.6, [cooking counter 0.6 · hob + hood]),
  (3.4, 10.6, 4.0, 12.3, [fridge + tall storage]),
  (0.0, 2.9, 0.6, 5.9, [washer · dryer · sink · folding]),
  (1.6, 5.0, 3.6, 5.9, [single bed 0.9 × 2.0]),
  (1.6, 3.9, 2.2, 4.9, [ward-\ robe]),
  (0.0, 1.2, 0.9, 1.9, [shower]),
)

// ---------- Doors and windows: ((x1, y1), (x2, y2), label) ----------
#let doors = (
  ((0.4, 12.5), (1.5, 12.5), [kitchen ↔ dining]),
  ((0.65, 6.0), (1.45, 6.0), [open entrance kitchen ↔ laundry (no door)]),
  ((1.5, 2.95), (1.5, 3.75), [laundry ↔ maid room]),   // at the north end: keeps the wide south part free for the bed
  ((1.7, 2.8), (2.4, 2.8), [maid room ↔ maid bath]),
)
#let windows = (
  ((0.0, 8.6), (0.0, 10.6), [sink window (courtyard)]),
  ((4.0, 8.2), (4.0, 9.6), [kitchen window (east)]),
  ((3.170, 3.9), (3.714, 4.9), [maid room window (cut wall, high sill)]),
  ((2.138, 2.0), (2.464, 2.6), [maid bath vent window]),
)

// ---------- Walls that must stay solid ----------
#let solid = (
  ((0.0, 0.0), (0.0, 6.0), [solid wall to the women's majlis (no door, no window)]),
)

// ---------- Neighbours (grey) ----------
#let neighbours = (
  ((-2.2, 0), (0, 6.0), [Women's majlis]),
  ((-2.2, 6.0), (0, 12.5), [Courtyard]),
  ((0, 12.5), (4, 14.2), [Living (normal height) · dining]),
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

// ---------- Checks (polygon-aware: rectangles, sloped rooms and the air tower) ----------
#let issues = ()
#let shapes = rows.map(r => (r.name, corners(r))) + poly-rooms.map(((n, P, c)) => convex-parts.at(n, default: (P,)).map(Q => (n, Q))).fold((), (acc, x) => acc + x) + (("Air tower", tower),)
#for (n, P) in shapes { if not P.all(p => inside(p, block)) { issues.push(n + " leaves the block") } }
#for i in range(shapes.len()) {
  for j in range(i + 1, shapes.len()) {
    if shapes.at(i).at(0) != shapes.at(j).at(0) and overlap(shapes.at(i).at(1), shapes.at(j).at(1)) { issues.push(shapes.at(i).at(0) + " overlaps " + shapes.at(j).at(0)) }
  }
}
#let used = rows.map(r => r.w * r.d).sum(default: 0) + poly-rooms.map(((n, P, c)) => area(P)).sum(default: 0)
#let leftover = area(block) - used - area(tower)

// ---------- Page ----------
#text(16pt, weight: "bold", fill: rgb("#2f6b4f"))[East service block · kitchen, laundry, maid wing, air tower · layout study]\
#text(8pt, fill: gray)[Taif / Palm House · Design V3 (Z4) · block = CSV x 9–13, y 0–12.5 (NE corner cut) · #r2(area(block)) m² · scale 1 m = 1.3 cm · north up]
#v(6pt)
#grid(columns: (auto, 1fr), column-gutter: 20pt,
  cetz.canvas(length: scale, {
    import cetz.draw: *
    for ((a, b), (c, d), l) in neighbours {
      rect(q(a, b), q(c, d), fill: luma(240), stroke: (paint: luma(190), dash: "dashed"))
      content(q((a + c) / 2, (b + d) / 2), text(6.5pt, fill: gray, l))
    }
    line(..block.map(p => q(..p)), close: true, fill: rgb("#f3efe6"), stroke: none)   // leftover slivers show in this tone
    line(..tower.map(p => q(..p)), close: true, fill: rgb("#8ccbe0"), stroke: 0.6pt + rgb("#1f7a99"))
    content(q(0.75, 0.6), text(6.5pt)[*Air tower*\ #r2(area(tower)) m²])
    for r in rows {
      let (x0, y0, x1, y1) = box(r)
      rect(q(x0, y0), q(x1, y1), fill: colours.at(r.colour, default: luma(230)), stroke: 0.6pt + rgb("#3d4a45"))
      content(q((x0 + x1) / 2, (y0 + y1) / 2 - 0.35), align(center, text(6.5pt)[*#r.name*\ #r2(r.w) × #r2(r.d) · #r2(r.w * r.d) m²]))
    }
    for (n, P, c) in poly-rooms {
      line(..P.map(p => q(..p)), close: true, fill: colours.at(c, default: luma(230)), stroke: 0.6pt + rgb("#3d4a45"))
      let m = centroid(P)
      let m = if n == "Kitchen" { (2.0, 11.0) } else if n == "Maid room" { (2.75, 5.05) } else { (m.at(0), m.at(1) + 0.2) }
      content(q(..m), align(center, text(6.5pt)[*#n*\ #if n == "Kitchen" [L-shape] else [sloped] · #r2(area(P)) m²]))
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
    line(q(0, 14.8), q(1, 14.8), stroke: 1.2pt)
    content(q(0.5, 15.05), text(6pt)[1 m])
  }),
  [
    #set text(7.4pt)
    #text(10pt, weight: "bold", fill: rgb("#2f6b4f"))[Rooms]
    #table(columns: (auto, auto, auto), stroke: none, inset: 3pt,
      [*Room*], [*w × d (m)*], [*m²*],
      ..poly-rooms.map(((n, P, c)) => ([#n], if n == "Kitchen" [L-shape (4 × 6.5 minus laundry)] else [sloped (to the cut wall)], [#r2(area(P))])).flatten(),
      ..rows.map(r => ([#r.name], [#r2(r.w) × #r2(r.d)], [#r2(r.w * r.d)])).flatten(),
      [Air tower (polygon)], [4 corners], [#r2(area(tower))],
      [Leftover slivers along the cut], [], [#r2(leftover)],
      [*Block*], [], [*#r2(area(block))*],
    )
    #v(6pt)
    #if issues.len() == 0 { text(fill: rgb("#2f6b4f"), weight: "bold")[✓ All rooms inside the block, no overlaps] } else { std.block(fill: rgb("#fbe3dd"), inset: 5pt, radius: 2pt)[#text(fill: rgb("#b5452f"), weight: "bold")[WARNING]\ #issues.map(i => [• #i]).join(linebreak())] }
    #v(8pt)
    #text(10pt, weight: "bold", fill: rgb("#2f6b4f"))[Route]
    *Family:* living (normal height) · dining → kitchen (south door).\
    *Maid:* kitchen → laundry → maid room → maid bath. No external door and no other door: all her movement passes through the kitchen.\
    *Cooking:* sink on the courtyard wall, hob and hood on the east (outside) wall, so heat and smoke leave the house; fridge and tall storage at the south-east, next to the dining door.
    #v(6pt)
    #text(10pt, weight: "bold", fill: rgb("#2f6b4f"))[Rules]
    - Kitchen isolated: doors only to the dining area (south) and the laundry (north). No door to the courtyard, riwaq or women's majlis.
    - Kitchen 4 × 6.5 m (26 m²), y 6.0–12.5, exactly on the courtyard lines. Sink run on the courtyard wall, hob and hood on the east wall (4.5 m), fridge and tall storage at the south-east; aisle ≈ 2.6 m. No island (only 0.6 m deep would fit); room for a small breakfast table.
    - Laundry vertical on the west wall (women's majlis side), 1.5 × 3.2 m (x 0–1.5, y 2.8–6.0), from the kitchen up to the maid bath: open entrance from the kitchen in its south wall (no door); washer, dryer, utility sink and folding counter in one line on the west wall (solid, no opening); 0.9 m walkway; maid room door at the north end of its east wall. The maid's only route. No outside wall: needs a mechanical extract fan to the roof.
    - Maid room east of the laundry, from y 2.8 down to y 6.0 and up to the sloped cut wall (≈ 6.1 m² on centre lines, ≈ 5.3 m² clear, under the 6.5 m² target): door from the laundry at the north end of its west wall and door to the maid bath in its north wall, both in the narrow north part; single bed 0.9 × 2.0 along the south wall (the widest part, 2.5 m) and a wardrobe on the west wall; window in the cut wall with a high sill (lane side, privacy).
    - Main cross walls on the house lines: y 6.0 (women's majlis / courtyard) and y 12.5 (dining).
    - Maid bath 1.6 m deep, running up to the cut wall (≈ 3.42 m²): WC, basin, compact shower; vent window in the cut wall; door only from the maid room.
    - Solid wall (no door, no window) between the maid wing and the women's majlis.
    - Air tower in the tip of the cut corner, ≈ 1.1 m² clear, takes no room space; cleaning from a roof hatch.
    - One east wet stack: maid bath, laundry sink and kitchen sink on one drain line down the block; cleanout access in the laundry.
    #v(6pt)
    #text(7pt, fill: gray)[Edit the lists at the top: rooms-data, fixtures, doors, windows, solid, neighbours. Main CSV = local + (9, 0).]
  ],
)
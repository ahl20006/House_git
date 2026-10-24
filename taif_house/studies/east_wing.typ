// east_wing.typ · Taif / Palm House · layout study of the EAST SERVICE BLOCK: kitchen + laundry + maid room + maid bath + air tower (compile THIS file)
// Ground floor V6.2. Stand-alone: all data is in this file.
// Main CSV coordinates (../data/rooms_gf.csv) = local + (8.95, 0); block = CSV x 8.95–13.311, y 0–13.0. Keep both in step when you change a room here.
#import "@preview/cetz:0.4.2"
#set page(paper: "a4", margin: 12mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 8pt)

// ---------- The block (local metres: origin = NW corner, x east, y SOUTH) · NOT a rectangle: NE corner cut by the lane wall ----------
#let block = ((0, 0), (1.101, 0), (4.361, 6.0), (4.361, 13.0), (0, 13.0))   // wall centre lines; one slope to y 6.0, then straight
#let scale = 1.15cm

// ---------- Air tower: polygon in the tip of the cut corner, 1.0 m deep ----------
#let tower = ((0, 0), (1.101, 0), (1.644, 1.0), (0, 1.0))

// ---------- Rooms: (name, x, y, w, d, colour) · x, y = centre ----------
// put // in front of a line to switch a room off
#let rooms-data = (
  ("Laundry",   0.85,   4.65,  1.70,  3.7,   "laundry"),   // vertical, on the west wall (women's majlis side): x 0–1.70, y 2.8–6.5
  ("Kitchen",   2.1805, 9.75,  4.361, 6.5,   "kitchen"),   // y 6.5–13.0, exactly on the courtyard lines
)

// ---------- Rooms along the cut wall: polygons (name, corner points, colour) so they run up to the sloped wall ----------
// cut wall: x = 1.101 + y × 2.949 / 5.427 (y 0–6.0) · at y 1.0 → 1.644, at y 2.8 → 2.622, at y 6.0 → 4.361
#let poly-rooms = (
  ("Maid bath", ((0, 1.0), (1.644, 1.0), (2.622, 2.8), (0, 2.8)), "wc"),                       // 1.8 m deep: from the tower to y 2.8
  ("Maid room", ((1.7, 2.8), (2.622, 2.8), (4.361, 6.0), (4.361, 6.5), (1.7, 6.5)), "maid"),   // the slope ends at y 6.0, then 0.5 m of straight east wall
)

// ---------- Fixtures inside rooms (drawn thin, not counted, on finished wall faces): (x0, y0, x1, y1, label) ----------
#let fixtures = (
  (0.1, 7.5, 0.7, 12.9, [sink counter 0.6 · window to courtyard]),
  (3.636, 7.2, 4.236, 11.1, [cooking counter 0.6 · hob + hood]),
  (3.636, 11.1, 4.236, 12.9, [fridge + tall storage]),
  (0.1, 2.9, 0.7, 3.5, [washer]),
  (0.1, 3.5, 0.7, 4.1, [dryer]),
  (0.1, 4.1, 0.7, 4.7, [utility sink]),
  (0.1, 4.7, 0.7, 5.7, [folding · shelves]),
  (1.75, 5.5, 3.75, 6.4, [single bed 0.9 × 2.0]),
  (1.75, 4.1, 2.35, 5.3, [ward-\ robe]),
  (0.1, 1.1, 0.9, 1.9, [shower]),
  (1.0, 1.1, 1.5, 1.7, [WC]),
  (0.1, 2.1, 0.6, 2.7, [basin]),
)

// ---------- Doors and windows: ((x1, y1), (x2, y2), label) ----------
#let doors = (
  ((0.45, 13.0), (1.55, 13.0), [kitchen ↔ dining]),
  ((0.75, 6.5), (1.6, 6.5), [open entrance kitchen ↔ laundry (no door)]),
  ((1.7, 2.95), (1.7, 3.75), [laundry ↔ maid room]),          // at the north end: keeps the wide south part free for the bed
  ((1.765, 2.8), (2.465, 2.8), [maid room ↔ maid bath · 0.70]),
)
#let windows = (
  ((0.0, 9.1), (0.0, 11.1), [sink window (courtyard)]),
  ((4.361, 8.7), (4.361, 10.1), [kitchen window (east)]),
  ((3.220, 3.9), (3.764, 4.9), [maid room window (cut wall, sill ≥ 1.5 m)]),
  ((2.188, 2.0), (2.514, 2.6), [maid bath vent window]),
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

// ---------- Checks (polygon-aware: rectangles, sloped rooms and the air tower) ----------
#let issues = ()
#let shapes = rows.map(r => (r.name, corners(r))) + poly-rooms.map(((n, P, c)) => (n, P)) + (("Air tower", tower),)
#for (n, P) in shapes { if not P.all(p => inside(p, block)) { issues.push(n + " leaves the block") } }
#for i in range(shapes.len()) {
  for j in range(i + 1, shapes.len()) {
    if overlap(shapes.at(i).at(1), shapes.at(j).at(1)) { issues.push(shapes.at(i).at(0) + " overlaps " + shapes.at(j).at(0)) }
  }
}
#let used = rows.map(r => r.w * r.d).sum(default: 0) + poly-rooms.map(((n, P, c)) => area(P)).sum(default: 0)
#let leftover = area(block) - used - area(tower)

// ---------- Page ----------
#text(16pt, weight: "bold", fill: rgb("#2f6b4f"))[East service block · kitchen, laundry, maid wing, air tower · layout study]\
#text(8pt, fill: gray)[Taif / Palm House · Ground floor V6.2 · block = CSV x 8.95–13.311, y 0–13.0 (NE corner cut) · #r2(area(block)) m² · scale 1 m = 1.15 cm · north up]
#v(6pt)
#grid(columns: (auto, 1fr), column-gutter: 20pt,
  cetz.canvas(length: scale, {
    import cetz.draw: *
    for ((a, b), (c, d), l) in neighbours {
      rect(q(a, b), q(c, d), fill: luma(240), stroke: (paint: luma(190), dash: "dashed"))
      content(q((a + c) / 2, (b + d) / 2), text(6.5pt, fill: gray, l))
    }
    line(..block.map(p => q(..p)), close: true, fill: rgb("#f3efe6"), stroke: none)   // leftover slivers would show in this tone
    line(..tower.map(p => q(..p)), close: true, fill: rgb("#8ccbe0"), stroke: 0.6pt + rgb("#1f7a99"))
    content(q(0.7, 0.5), text(6.5pt)[*Air tower*\ #r2(area(tower)) m²])
    for r in rows {
      let (x0, y0, x1, y1) = box(r)
      rect(q(x0, y0), q(x1, y1), fill: colours.at(r.colour, default: luma(230)), stroke: 0.6pt + rgb("#3d4a45"))
      content(q((x0 + x1) / 2, (y0 + y1) / 2 - 0.35), align(center, text(6.5pt)[*#r.name*\ #r2(r.w) × #r2(r.d) · #r2(r.w * r.d) m²]))
    }
    for (n, P, c) in poly-rooms {
      line(..P.map(p => q(..p)), close: true, fill: colours.at(c, default: luma(230)), stroke: 0.6pt + rgb("#3d4a45"))
      let m = if n == "Maid room" { (2.9, 4.6) } else { let c = centroid(P); (c.at(0) + 0.2, c.at(1)) }
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
    *Cooking:* sink on the courtyard wall, hob and hood on the east (outside) wall, so heat and smoke leave the house; fridge and tall storage at the south-east, next to the dining door; the east duct in the north-east corner.
    #v(6pt)
    #text(10pt, weight: "bold", fill: rgb("#2f6b4f"))[Rules]
    - Kitchen isolated: doors only to the dining area (south) and the laundry (north). No door to the courtyard, riwaq or women's majlis.
    - Kitchen 4.361 × 6.5 m on axes (28.35 m², ≈ 26.1 m² clear, ≈ 4.136 m clear wide), y 6.5–13.0, exactly on the courtyard lines. No island: two parallel counter runs, the sink run on the courtyard wall and the hob, hood and fridge run on the east outside wall; ≈ 2.94 m between the counter fronts. The heavy (dirty) kitchen; the hospitality kitchen in the west block is the light one.
    - Laundry vertical on the west wall (women's majlis side), 1.70 × 3.7 m (x 0–1.70, y 2.8–6.5), from the kitchen up to the maid bath: open entrance from the kitchen in its south wall (no door); washer, dryer, utility sink and folding shelves in one line on the west wall (solid, no opening, the wet wall 200 mm); ≈ 0.95 m clear beside the 0.6 m machines; maid room door at the north end of its east wall. The maid's only route. No outside wall: a mechanical extract fan to the roof.
    - Maid room east of the laundry behind a 100 mm dry block partition, y 2.8–6.5; the slope ends at y 6.0, then 0.5 m of straight east wall (≈ 7.06 m² on centre lines, ≈ 6.04 m² clear; the earlier 6.5 m² target is dropped: the sloped cut wall makes the north part too narrow). Doors from the laundry and to the maid bath both in the north part; single bed 0.9 × 2.0 along the south wall and a wardrobe on the west wall; window in the cut wall with a sill ≥ 1.5 m (privacy from the lane).
    - Maid bath 1.8 m deep (y 1.0–2.8, from the air tower to the maid room), running up to the cut wall (≈ 3.84 m², ≈ 3.03 m² clear): WC, basin, compact shower; vent window in the cut wall; door only from the maid room, 0.70 m clear (sliding or opening out; the wall there is only ≈ 0.73 m long).
    - Main cross walls on the house lines: y 6.5 (women's majlis / courtyard) and y 13.0 (dining). Exterior walls and the air tower fixed; all interior walls straight and square. Walls: 100 mm blocks for dry partitions, 150–200 mm for walls carrying pipes (maid bath, laundry sink wall).
    - Solid wall (no door, no window) between the maid wing and the women's majlis.
    - Air tower in the tip of the cut corner, 1.0 m deep (≈ 1.37 m² on centre lines, ≈ 0.88 m² clear, at least ≈ 0.93 m wide): one person can step in to clean; main cleaning from a roof hatch. Takes no room space.
    - Plumbing: kitchen, laundry and maid bath drain under the slab straight out to the east, to a manhole in the east service yard; no east duct; the vent stack runs up the outside face of the east wall and the kitchen extract leaves straight through the east wall at the hood. Coordinate drain depths with the air tunnel (also under the east side).
    - Open decision (not drawn): a small service door from the laundry to the east service yard, locked with the owner's key only. Gas (if used): cylinder cabinet outside the east wall in the service yard.
  ],
)

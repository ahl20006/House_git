// east_wing.typ · Taif / Palm House · layout study of the EAST SERVICE BLOCK (compile THIS file) · 23 Nov 2026 IDEA (branch idea-ne-corner): the north-east corner (the maid room, the maid bath
// and the laundry) taken OUT of the ground floor: open ground under the first floor on the corner columns; the block is the kitchen alone
// Ground floor V6.3. Stand-alone: all data is in this file.
// Main CSV coordinates (../data/rooms_gf.csv) = local + (8.95, 0); block = CSV x 8.95–13.311, y 0–13.0. Keep both in step when you change a room here.
#import "@preview/cetz:0.4.2"
#set page(paper: "a4", margin: 12mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 8pt)

// ---------- The block (local metres: origin = NW corner, x east, y SOUTH) · NOT a rectangle: the NE corner stepped (17 Nov 2026, studies/step_corner.typ option 6: the slant replaced by ONE orthogonal step) ----------
#let block = ((0, 6.5), (4.361, 6.5), (4.361, 13.0), (0, 13.0))   // idea-ne-corner: the kitchen alone; the corner north of y 6.5 is open ground (the first floor above it)
#let scale = 1.15cm

// ---------- V10.0: the malqaf moved to the courtyard's north-west corner (L5): no air tower in this block; the cut tip is the maid's store ----------

// ---------- Rooms: (name, x, y, w, d, colour) · x, y = centre ----------
// put // in front of a line to switch a room off
#let rooms-data = (
  ("Kitchen",   2.1805, 9.75,  4.361, 6.5,   "kitchen"),   // y 6.5–13.0 (11 Nov 2026, owner: the north wall ON the structural line y 6.5, in line with the women's majlis wall; was y 7.0, V6.4)
)

// ---------- Rooms at the stepped corner: polygons (name, corner points, colour) · 17 Nov 2026: every room a clean rectangle (the maid room and bath as option 6) ----------
#let poly-rooms = (
  // idea-ne-corner: no room north of the kitchen: the corner is outside the ground floor
)

// ---------- Fixtures inside rooms (drawn thin, not counted, on finished wall faces): (x0, y0, x1, y1, label) ----------
#let fixtures = (
  (0.1, 7.5, 0.7, 8.9, [sink]),   // the sink moved north with its window (owner, 1 Nov 2026): the window y 7.3–8.9 looks at the fountain and the tree
  (0.1, 8.9, 0.7, 9.5, [d/w]),
  (0.1, 9.5, 0.7, 12.9, [counter 0.6]),   // the outdoor TV on the courtyard face of this wall
  (3.636, 8.2, 4.236, 10.2, [cooking counter 0.6]),   // starts 0.1 south of the service door (V6.4)
  (3.636, 10.2, 4.236, 11.2, [hob + hood · extract through the east wall]),   // the hood south of the east window (y 8.7–10.1), 2.1 m from the service door, 4.2 m from C32
  (3.636, 11.2, 4.236, 12.9, [fridge + tall storage]),
  // idea-ne-corner: the laundry's, the maid bath's and the maid room's fixtures and furniture removed with the rooms
)

// ---------- Doors and windows: ((x1, y1), (x2, y2), label) ----------
#let doors = (
  ((0.45, 13.0), (1.55, 13.0), [kitchen ↔ dining]),
  ((4.361, 7.2), (4.361, 8.1), [service door 0.90 · east yard · lockable]),   // owner decision: north end of the kitchen's east wall, near the laundry (V6.4: moved 0.5 with the wall)
  ((0.75, 6.5), (1.65, 6.5), [kitchen north door 0.90 · closed · to the open ground]),   // idea-ne-corner: was the open entrance to the laundry; now an outside door
  // idea-ne-corner: laundry ↔ maid room and maid room ↔ maid bath removed with the rooms
)
#let windows = (
  ((0.0, 7.3), (0.0, 8.9), [sink window (courtyard)]),   // moved north over the sink (owner, 1 Nov 2026)
  ((4.361, 8.7), (4.361, 10.1), [kitchen window (east)]),
  // idea-ne-corner: the maid room's escape casement, the maid bath's window and the laundry's window removed with the rooms
)

// ---------- Walls that must stay solid ----------
#let solid = (
  ((0.0, 0.0), (0.0, 6.5), [solid wall to the women's majlis (no door, no window)]),
)

// ---------- Neighbours (grey) ----------
#let neighbours = (
  ((-2.2, 0), (0, 6.5), [Women's majlis]),
  ((0, 0), (4.361, 6.5), [OPEN GROUND · first floor above on columns]),   // idea-ne-corner: the corner outside the ground floor (the step at (2.325, 3.2) belongs to the first floor's outline)
  ((-2.2, 6.5), (0, 13.0), [Courtyard]),
  ((0, 13.0), (4.361, 14.7), [Living (normal height) · dining]),
)

// ---------- Helpers ----------
#let colours = (wc: rgb("#d9e6ec"), maid: rgb("#e4e9d6"), laundry: rgb("#dfe3e6"), kitchen: rgb("#d9e6ec"), empty: rgb("#f3efe6"))
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
#let convex-parts = (:)
#let shapes = rows.map(r => (r.name, corners(r))) + poly-rooms.map(((n, P, c)) => convex-parts.at(n, default: (P,)).map(Q => (n, Q))).join()
#let block-parts = (block,)   // idea-ne-corner: the kitchen block is a rectangle   // 17 Nov 2026: the stepped block is not convex: its two convex parts for the half-plane test
#for (n, P) in shapes { if not P.all(p => block-parts.any(B => inside(p, B))) { issues.push(n + " leaves the block") } }
#for i in range(shapes.len()) {
  for j in range(i + 1, shapes.len()) {
    if shapes.at(i).at(0) != shapes.at(j).at(0) and overlap(shapes.at(i).at(1), shapes.at(j).at(1)) { issues.push(shapes.at(i).at(0) + " overlaps " + shapes.at(j).at(0)) }
  }
}
#let used = rows.map(r => r.w * r.d).sum(default: 0) + poly-rooms.map(((n, P, c)) => area(P)).sum(default: 0)
#let leftover = area(block) - used

// ---------- Page ----------
#text(16pt, weight: "bold", fill: rgb("#2f6b4f"))[East service block · V11-idea · NE corner out: the corner outside the ground floor, the first floor above it on columns; the kitchen alone]\
#text(8pt, fill: gray)[Taif / Palm House · Ground floor · IDEA on the branch idea-ne-corner (23 Nov 2026) · block = CSV x 8.95–13.311, y 6.5–13.0 (the kitchen; the corner y 0–6.5 is open ground) · #r2(area(block)) m² · scale 1 m = 1.15 cm · north up]
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
      let m = centroid(P)
      content(q(..m), align(center, text(6.5pt)[*#n*\ #r2(area(P)) m²]))
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
      ..poly-rooms.map(((n, P, c)) => ([#n], [rectangle (the stepped corner)], [#r2(area(P))])).flatten(),
      ..rows.map(r => ([#r.name], [#r2(r.w) × #r2(r.d)], [#r2(r.w * r.d)])).flatten(),
      [Leftover slivers at the corner], [], [#r2(leftover)],
      [*Block*], [], [*#r2(area(block))*],
    )
    #v(6pt)
    #if issues.len() == 0 { text(fill: rgb("#2f6b4f"), weight: "bold")[✓ All rooms inside the block, no overlaps] } else { std.block(fill: rgb("#fbe3dd"), inset: 5pt, radius: 2pt)[#text(fill: rgb("#b5452f"), weight: "bold")[WARNING]\ #issues.map(i => [• #i]).join(linebreak())] }
    #v(8pt)
    #text(10pt, weight: "bold", fill: rgb("#2f6b4f"))[The idea (23 Nov 2026, branch idea-ne-corner)]
    - The north-east corner, x 8.95–13.311 × y 0–6.5 with the step (the maid room G06, the maid bath G05 and the laundry G07 of V11.0), is *outside the ground floor*: open ground, 21.83 m² on axes. Its outer walls (the north wall east of x 8.95, the step's two walls, the east wall from the step to y 6.5) and every inner wall, door, window, fixture and piece of furniture are gone.
    - *The ground-floor outline* now runs (0, 0) → (8.95, 0) → (8.95, 6.5) → (13.311, 6.5) → (13.311, 24) → (0, 24): the women's majlis east wall (x 8.95, y 0–6.5) and the kitchen's north wall (y 6.5, x 8.95–13.311) are outside walls. Straight lines, nothing else changes.
    - *The first floor is unchanged:* bedroom 1, its bath F20, the link and the suite's WC closet stand over the open ground on the existing corner columns; the slab's underside insulated; its outline is drawn dashed over the open ground on the ground-floor plan.
    - *Doors that changed:* the kitchen's open entrance on y 6.5 (x 9.7–10.6) is now a normal closed door 0.90 to the open ground. Nothing else in the kitchen changes (its east service door, its east window, its sink window on the courtyard, its dining door).
    - *Not in this idea:* the fire study, the plumbing study, the 3D, the DXFs, `tools/check.py` (the block's total is the kitchen's 28.35 m² now).
  ],
)

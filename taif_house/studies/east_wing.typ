// east_wing.typ · Taif / Palm House · layout study of the EAST SERVICE BLOCK (compile THIS file) · 23 Nov 2026 IDEA (branch idea-ne-corner): the north-east corner (the maid room, the maid bath
// and the laundry) taken OUT of the ground floor: open ground under the first floor on the corner columns; the block is the kitchen alone
// Ground floor V6.3. Stand-alone: all data is in this file.
// Main CSV coordinates (../data/rooms_gf.csv) = local + (8.95, 0); block = CSV x 8.95–13.311, y 0–13.0. Keep both in step when you change a room here.
#import "@preview/cetz:0.4.2"
#set page(paper: "a4", margin: 12mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 8pt)

// ---------- The block (local metres: origin = NW corner, x east, y SOUTH) · NOT a rectangle: the NE corner stepped (17 Nov 2026, studies/step_corner.typ option 6: the slant replaced by ONE orthogonal step) ----------
#let block = ((-1.7, 0), (2.325, 0), (2.325, 6.5), (4.361, 6.5), (4.361, 13.0), (0, 13.0), (0, 6.5), (-1.7, 6.5))   // GF step 6: the malqaf chamber inside the block's SW corner (local x −1.7–0 × y 4.3–6.5) · GF step 5: the open space (from the majlis wall, CSV x 7.25 = local −1.7, to the east wall, north of the kitchen and the courtyard) and the kitchen
#let scale = 1.15cm

// ---------- V10.0: the malqaf moved to the courtyard's north-west corner (L5): no air tower in this block; the cut tip is the maid's store ----------

// ---------- Rooms: (name, x, y, w, d, colour) · x, y = centre ----------
// put // in front of a line to switch a room off
#let rooms-data = (
  ("Kitchen",   2.1805, 10.65,  4.361, 4.7,   "kitchen"),   // GF step 4: an exact rectangle x 8.95–13.311 × y 8.3–13.0 (20.50 m² on axes); the lobby / kitchen wall y 8.3 runs to the east wall
)

// ---------- Rooms at the stepped corner: polygons (name, corner points, colour) · 17 Nov 2026: every room a clean rectangle (the maid room and bath as option 6) ----------
#let poly-rooms = (
  ("Open space: to be planned", ((-1.7, 0), (2.325, 0), (2.325, 6.5), (4.361, 6.5), (4.361, 8.3), (0, 8.3), (0, 4.3), (-1.7, 4.3)), "lobby"),   // GF step 6: minus the malqaf chamber: 30.27 m² on axes · GF step 5: one open space, no inner partitions
  ("Malqaf chamber", ((-1.7, 4.3), (0, 4.3), (0, 6.5), (-1.7, 6.5)), "tower"),   // GF step 6 (draft): the foot chamber 1.7 × 2.2 on axes (≈ 1.5 × 1.95 clear), its courtyard wall 0.30, the outlet in it
)

// ---------- Fixtures inside rooms (drawn thin, not counted, on finished wall faces): (x0, y0, x1, y1, label) ----------
#let fixtures = (
  (0.1, 8.4, 0.7, 9.9, [sink · d/w]),   // GF step 6: on the blind courtyard wall (the sink window removed: the liwan's back wall)
  (0.1, 9.9, 0.7, 12.9, [counter 0.6]),
  (3.636, 8.4, 4.236, 10.2, [cooking counter 0.6]),
  (3.636, 10.2, 4.236, 11.2, [hob + hood · extract through the east wall]),
  (3.636, 11.2, 4.236, 12.9, [fridge + tall storage]),
  (1.5, 8.4, 3.5, 9.0, [counter 0.6 on the north wall]),
  // GF step 5: nothing inside the open space
)

// ---------- Doors and windows: ((x1, y1), (x2, y2), label) ----------
#let doors = (
  ((0.45, 13.0), (1.55, 13.0), [kitchen ↔ dining]),
  ((0.65, 8.3), (1.55, 8.3), [kitchen back door 0.90 → the open space]),
  ((0.0, 6.9), (0.0, 7.8), [open space ← courtyard 0.90]),
  ((2.85, 6.5), (3.75, 6.5), [open space → back garden 0.90 · the only outside door]),
  ((-1.35, 4.3), (-0.45, 4.3), [malqaf chamber: maintenance door 0.90 from the open space]),
)
#let windows = (
  ((-1.55, 6.5), (-0.15, 6.5), [outlet 1.4 × 1.0 · raised]),   // GF step 6: into the courtyard, +0.60…+1.60, louvres as L5
  ((4.361, 8.7), (4.361, 10.1), [kitchen window (east)]),
  ((4.361, 7.0), (4.361, 7.9), [window (east)]),
  ((0.55, 0.0), (1.69, 0.0), [escape casement 1.14 × 1.00 (north facade)]),
  ((-1.25, 0.0), (-0.65, 0.0), [small window (north facade)]),
)

// ---------- Walls that must stay solid ----------
#let solid = (
  ((0.0, 0.0), (0.0, 6.5), [solid wall to the women's majlis (no door, no window)]),
)

// ---------- Neighbours (grey) ----------
#let neighbours = (
  ((-4.7, 0), (-1.7, 6.5), [Women's majlis]),
  ((2.325, 0), (4.361, 3.2), [open: the step notch (outside both floors)]),   // the first floor's north wall also ends at x 11.275 and steps at y 3.2
  ((2.325, 3.2), (4.361, 6.5), [BACK GARDEN · first floor above]),

  ((-4.7, 6.5), (0, 13.0), [Courtyard]),
  ((0, 13.0), (4.361, 14.7), [Living (normal height) · dining]),
)

// ---------- Helpers ----------
#let colours = (wc: rgb("#d9e6ec"), maid: rgb("#e4e9d6"), laundry: rgb("#dfe3e6"), kitchen: rgb("#d9e6ec"), empty: rgb("#f3efe6"), lobby: rgb("#f2efe8"), tower: rgb("#8ccbe0"))
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
#let convex-parts = ("Open space: to be planned": (((-1.7, 0), (2.325, 0), (2.325, 4.3), (-1.7, 4.3)), ((0, 4.3), (2.325, 4.3), (2.325, 6.5), (0, 6.5)), ((0, 6.5), (4.361, 6.5), (4.361, 8.3), (0, 8.3))))   // GF step 6: the open space's three convex parts (round the chamber)
#let shapes = rows.map(r => (r.name, corners(r))) + poly-rooms.map(((n, P, c)) => convex-parts.at(n, default: (P,)).map(Q => (n, Q))).join()
#let block-parts = (((-1.7, 0), (2.325, 0), (2.325, 6.5), (-1.7, 6.5)), ((0, 6.5), (4.361, 6.5), (4.361, 13.0), (0, 13.0)))   // GF step 5: the block's two convex parts   // 17 Nov 2026: the stepped block is not convex: its two convex parts for the half-plane test
#for (n, P) in shapes { if not P.all(p => block-parts.any(B => inside(p, B))) { issues.push(n + " leaves the block") } }
#for i in range(shapes.len()) {
  for j in range(i + 1, shapes.len()) {
    if shapes.at(i).at(0) != shapes.at(j).at(0) and overlap(shapes.at(i).at(1), shapes.at(j).at(1)) { issues.push(shapes.at(i).at(0) + " overlaps " + shapes.at(j).at(0)) }
  }
}
#let used = rows.map(r => r.w * r.d).sum(default: 0) + poly-rooms.map(((n, P, c)) => area(P)).sum(default: 0)
#let leftover = area(block) - used

// ---------- Page ----------
#text(16pt, weight: "bold", fill: rgb("#2f6b4f"))[East service block · V11-idea · NE corner out, GF step 6 (draft): the malqaf chamber inside the open space, against the courtyard wall; the sink window gone (the liwan's back wall)]\
#text(8pt, fill: gray)[Taif / Palm House · Ground floor · IDEA on the branch idea-ne-corner (23 Nov 2026) · block = the open space (CSV x 7.25–11.275 × y 0–6.5 + x 8.95–13.311 × y 6.5–8.3) and the kitchen; the corner x 11.275–13.311 × y 0–6.5 is open ground · #r2(area(block)) m² · scale 1 m = 1.15 cm · north up]
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
    #text(10pt, weight: "bold", fill: rgb("#2f6b4f"))[GF step 6 (24 Nov 2026, branch idea-ne-corner, DRAFT)]
    - *The malqaf chamber moved from the courtyard's north-west corner to its north-EAST:* inside the open space, against the courtyard's north wall at its east end, CSV x 7.25–8.95 × y 4.3–6.5 (1.7 × 2.2 on axes, ≈ 1.5 × 1.95 clear; L5 was 1.2 × 1.97): its *maintenance door 0.90 in its north wall (y 4.3, x 7.6–8.5) from the open space*, not from the courtyard; its *breeze outlet 1.4 × 1.0 in its courtyard wall (y 6.5, x 7.4–8.8), raised +0.60…+1.60, louvres as L5*, blowing south over the olive onto the liwan. The open space keeps its boundary and its three doors; it loses the chamber's 3.74 m²: #r2(area(poly-rooms.at(0).at(1))) m² on axes (≈ 27.4 m² clear).
    - *The kitchen's sink window on x 8.95 removed:* that wall is the liwan's back wall now (the liwan x 7.25–8.85 × y 8.0–12.9, bench +0.40, on the courtyard side); the sink stays on the blind wall, the kitchen keeps its east window (y 8.7–10.1). The courtyard door (x 8.95, y 6.9–7.8) stays. *The malqaf core rises at its new place: FF and roof to follow.*
    #text(10pt, weight: "bold", fill: rgb("#2f6b4f"))[GF step 5 (24 Nov 2026, branch idea-ne-corner)]
    - *One open space, no inner partitions, to be planned later:* the maid bath, the laundry, the maid room and the distribution lobby of steps 3–4 together, from the women's majlis's east wall (x 7.25) to the east outside wall, north of the kitchen (y 8.3) and the courtyard (y 6.5): 34.01 m² on axes; inside the wall faces *3.80 × 6.28 m (x 7.35–11.15, y 0.125–6.4) plus 4.14 × 1.80 m (x 9.05–13.19, y 6.4–8.2) ≈ 31.3 m²*. Every inner wall, inner door, fixture and piece of furniture removed.
    - *Its boundary kept exactly:* the outside walls with their windows (the escape casement x 9.5–10.64 and the small window x 7.7–8.3 on the north facade; the east window y 7.0–7.9), the majlis wall x 7.25 (no door in it), the courtyard wall, the kitchen's north wall y 8.3. *Doors kept in the boundary:* from the courtyard (x 8.95, y 6.9–7.8), the kitchen's back door (y 8.3, x 9.6–10.5), the only outside door to the back garden (y 6.5, x 11.8–12.7).
    - Nothing else changes; one step in the outside wall at (11.275, 6.5); the first floor unchanged.
    #text(10pt, weight: "bold", fill: rgb("#2f6b4f"))[GF step 4 (24 Nov 2026, branch idea-ne-corner)]
    - *The lobby / kitchen wall y 8.3 runs east to the outside wall x 13.311:* the kitchen's north-east part (x 11.275–13.311 × y 6.5–8.3) joins the lobby.
    - *Kitchen:* an exact rectangle x 8.95–13.311 × y 8.3–13.0, #r2(rows.at(0).w) × #r2(rows.at(0).d) on axes = #r2(rows.at(0).w * rows.at(0).d) m² (≈ 4.14 × 4.5 = 18.6 m² clear; V11.0 28.35 / 26.06): the sink and its courtyard window (y 8.5–10.1), the cooking run on the east wall with the east window (y 8.7–10.1), the fridge and tall storage, a counter on the north wall; its doors: the dining (south) and the lobby (north, x 9.6–10.5).
    - *Lobby:* an L reaching the east wall, 15.17 m² on axes (≈ 13.3 m² clear: the west arm 2.1 × 4.75, the east arm 1.84 × 1.6): a *window on the east outside wall* (y 7.0–7.9) for light; *the only outside door to the back garden moved to the north wall of its east arm* (y 6.5, x 11.8–12.7): the west arm, the corridor past the maid room, the laundry, the courtyard and the kitchen doors, stays free of a door swing, and the entry bay from the garden sits beside the window; the wall x 11.275 (y 3.35–6.5) is solid.
    - Nothing else changes (steps 1–3 below stand); one step in the outside wall at (11.275, 6.5); the first floor unchanged.
    #text(10pt, weight: "bold", fill: rgb("#2f6b4f"))[GF step 3 (24 Nov 2026, branch idea-ne-corner)]
    - *Lobby to the north facade, widened to x 8.95–11.275* (one line with the first floor's north wall above): the *maid room* in its north end, y 0–3.35 (2.325 × 3.35 on axes = 7.79 m², 2.10 × 3.125 = 6.56 m² clear: ≥ 2.10 wide, ≥ 6.5 m², V6.4), her escape casement on the north facade (x 9.5–10.64), her only door into the lobby (y 3.35); the *distribution lobby* y 3.35–8.3 (2.325 × 4.95 = 11.51 m² on axes, ≈ 2.1 × 4.75 = 10.0 clear) with its doors: the courtyard (x 8.95, y 6.9–7.8), the kitchen (y 8.3), the laundry (x 8.95, y 5.3–6.2), the maid room (y 3.35) and the ONLY outside door to the back garden (x 11.275, y 4.5–5.4, under the first floor).
    - *The strip from the majlis as narrow as possible*, x 7.25–8.95 (1.7 on axes, 1.5 m clear), the full depth from the north facade to the courtyard wall: the *maid bath* at its north end, y 0–1.9 (1.7 × 1.9 = 3.23 m², 1.5 × 1.675 = 2.51 m² clear: WC, basin, a simple shower; its small window on the facade x 7.7–8.3; its door from her room only, x 8.95, y 0.6–1.3), the *laundry* in the rest, y 1.9–6.5 (1.7 × 4.6 = 7.82 m², 1.5 × 4.4 = 6.6 m² clear): the washer and the dryer on its east wall (away from the majlis), the sink and the folding counter on the west wall, no window, an exhaust fan; its door into the lobby; its wall to the majlis (x 7.25) acoustic.
    - *Women's majlis a clean rectangle* x 4.25–7.25 × y 0–6.5 (3.0 × 6.5 = 19.5 m² on axes, 2.8 × 6.275 = 17.6 m² clear): its riwaq door and its north window (x 4.4–6.5) unchanged; of its courtyard window x 6.0–7.15 fits (1.15 m; the rest is behind the laundry).
    - *Kitchen:* its north-east part back (x 11.275–13.311 × y 6.5–8.3): 24.16 m² on axes (≈ 21.9 clear; V11.0 28.35 / 26.06); the lobby keeps x 8.95–11.275 × y 6.5–8.3 of it.
    - *Outside wall:* ONE re-entrant step, at (11.275, 6.5) → (13.311, 6.5): the outline (0, 0) → (11.275, 0) → (11.275, 6.5) → (13.311, 6.5) → (13.311, 24) → (0, 24). The back garden under the first floor is x 11.275–13.311 × y 3.2–6.5 = 6.72 m² on axes (the notch north of it, x 11.275–13.311 × y 0–3.2, is outside both floors, as in V11.0).
  ],
)

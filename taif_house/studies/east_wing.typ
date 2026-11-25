// east_wing.typ · Taif / Palm House · layout study of the EAST SERVICE BLOCK (compile THIS file) · 23 Nov 2026 IDEA (branch idea-ne-corner): the north-east corner (the maid room, the maid bath
// and the laundry) taken OUT of the ground floor: open ground under the first floor on the corner columns; the block is the kitchen alone
// Ground floor V6.3. Stand-alone: all data is in this file.
// Main CSV coordinates (../data/rooms_gf.csv) = local + (8.95, 0); block = CSV x 8.95–13.311, y 0–13.0. Keep both in step when you change a room here.
#import "@preview/cetz:0.4.2"
#set page(paper: "a4", margin: 12mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 8pt)

// ---------- The block (local metres: origin = NW corner, x east, y SOUTH) · NOT a rectangle: the NE corner stepped (17 Nov 2026, studies/step_corner.typ option 6: the slant replaced by ONE orthogonal step) ----------
#let block = ((-1.4, 0), (2.325, 0), (2.325, 6.5), (4.361, 6.5), (4.361, 14.25), (1.6, 14.25), (1.6, 13.0), (0, 13.0), (0, 6.5), (-1.4, 6.5))   // GF step 10: the majlis wall at local −1.4 (CSV 7.55), the laundry x 1.6–4.361 × y 11.75–14.25   // GF step 9: + the laundry south of the kitchen (local x 1.6–4.361 × y 13–15.5)   // GF step 6: the malqaf chamber inside the block's SW corner (local x −1.7–0 × y 4.3–6.5) · GF step 5: the open space (from the majlis wall, CSV x 7.25 = local −1.7, to the east wall, north of the kitchen and the courtyard) and the kitchen
#let scale = 1.15cm

// ---------- V10.0: the malqaf moved to the courtyard's north-west corner (L5): no air tower in this block; the cut tip is the maid's store ----------

// ---------- Rooms: (name, x, y, w, d, colour) · x, y = centre ----------
// put // in front of a line to switch a room off
#let rooms-data = (
  // GF step 8: the kitchen is an L (poly-rooms below): the main room x 8.95–13.311 × y 8.3–13 + the strip x 10.55–13.311 × y 6.5–8.3   // GF step 4: an exact rectangle x 8.95–13.311 × y 8.3–13.0 (20.50 m² on axes); the lobby / kitchen wall y 8.3 runs to the east wall
)

// ---------- Rooms at the stepped corner: polygons (name, corner points, colour) · 17 Nov 2026: every room a clean rectangle (the maid room and bath as option 6) ----------
#let poly-rooms = (
  // GF step 10 (25 Nov 2026, draft): local = CSV − 8.95; the majlis wall at −1.4 (CSV 7.55)
  ("Small entry", ((0.3, 5.5), (2.325, 5.5), (2.325, 6.5), (1.6, 6.5), (1.6, 7.9), (0, 7.9), (0, 6.5), (0.3, 6.5)), "lobby"),   // the old niche joined: the garden door in its east wall (y 5.5–6.4); the courtyard-door bay x 0–1.6 × y 6.5–7.9 (1.4 × 1.2 clear) with the kitchen door in its south wall; open to the corridor
  ("Corridor", ((0.3, 4.3), (2.325, 4.3), (2.325, 5.5), (0.3, 5.5)), "lobby"),   // from the chamber's east wall to the east wall: 1.8 × 1.0 clear, the maid room's door only
  ("Maid room", ((0, 0), (2.325, 0), (2.325, 4.3), (0, 4.3)), "maid"),   // GF step 10: east, on the facade and the east wall: 2.325 × 4.3 on axes = 2.10 × 4.075 clear (the V6.4 minimum); her door from the corridor, her escape casement on the facade
  ("Maid bath", ((-1.4, 0), (0, 0), (0, 4.3), (-1.4, 4.3)), "wc"),   // GF step 10: the old bath + store joined, on the majlis wall: 1.4 × 4.3 on axes = 1.2 × 4.075 clear; WC under its facade window, basin, shower 1.2 × 0.9 at the south end; from her room only
  ("Kitchen", ((0, 7.9), (1.6, 7.9), (1.6, 6.5), (4.361, 6.5), (4.361, 11.75), (1.6, 11.75), (1.6, 13.0), (0, 13.0)), "kitchen"),   // GF step 10: the main room x 10.55–13.311 × y 6.5–11.75 + the arm x 8.95–10.55 × y 7.9–13 (the circulation spine entry → dining)
  ("Laundry", ((1.6, 11.75), (4.361, 11.75), (4.361, 14.25), (1.6, 14.25)), "laundry"),   // GF step 10: half in the kitchen, half in the dining, centred on y 13: 2.761 × 2.5 on axes (≈ 2.54 × 2.3 clear): door from the kitchen's arm only, east window
  ("Malqaf chamber", ((-1.4, 4.3), (0.3, 4.3), (0.3, 6.5), (-1.4, 6.5)), "tower"),   // GF step 10: 0.30 east with the majlis wall, lengthwise (1.7 × 2.2 on axes, ≈ 1.5 × 1.95 clear), its courtyard wall 0.30
)

// ---------- Fixtures inside rooms (drawn thin, not counted, on finished wall faces): (x0, y0, x1, y1, label) ----------
#let fixtures = (
  (0.1, 8.4, 0.7, 9.9, [sink · d/w]),   // GF step 6: on the blind courtyard wall (the sink window removed: the liwan's back wall)
  (0.1, 9.9, 0.7, 12.9, [counter 0.6]),
  (3.636, 8.4, 4.236, 10.2, [cooking counter 0.6]),
  (3.636, 10.2, 4.236, 11.2, [hob + hood · extract through the east wall]),
  // GF step 10: the fridge at the west end of the north counter, the pantry on the west wall by the entry door, tall storage on the laundry's wall
  (1.7, 6.625, 2.4, 7.325, [fridge]), (2.4, 6.625, 4.236, 7.225, [counter 0.6 on the north wall]), (1.7, 7.35, 2.3, 7.8, [pantry]),
  (1.7, 11.05, 4.236, 11.65, [tall storage 0.6 on the laundry wall]),
  // GF step 10: the maid room east, her bath west (on the majlis wall)
  (0.8, 0.2, 2.2, 2.2, [bed 1.4 × 2.0]), (0.1, 0.2, 0.7, 1.0, [desk]), (0.1, 2.4, 0.7, 3.6, [wardrobe 0.6 × 1.2]),
  (-0.95, 0.15, -0.45, 0.85, [WC]), (-1.3, 1.1, -0.9, 1.6, [basin]), (-1.3, 3.3, -0.1, 4.2, [shower 1.2 × 0.9 · floor drain]),
  // GF step 10: the laundry half-half: the machines and the sink on its north (kitchen) wall east of the door swing, the folding counter under the east window
  (2.55, 11.85, 3.15, 12.45, [washer]), (3.15, 11.85, 3.75, 12.45, [dryer]), (3.75, 11.85, 4.236, 12.45, [sink]), (3.636, 12.6, 4.236, 14.15, [folding counter 0.6])
)

// ---------- Doors and windows: ((x1, y1), (x2, y2), label) ----------
#let doors = (
  ((0.45, 13.0), (1.55, 13.0), [kitchen ↔ dining]),
  ((0.6, 7.9), (1.5, 7.9), [entry → kitchen 0.90 on the kitchen's north wall (step 10, option a)]),
  ((0.0, 6.8), (0.0, 7.7), [entry ← courtyard 0.90]),
  ((0.3, 5.6), (0.3, 6.3), [malqaf chamber: maintenance door 0.70 from the entry (south end of its east wall)]),
  ((0.3, 5.5), (2.325, 5.5), [entry → corridor: open, no door]),
  ((2.325, 5.5), (2.325, 6.4), [entry → back garden 0.90 · the only outside door, under the first floor]),
  ((0.75, 4.3), (1.55, 4.3), [maid room 0.80 from the corridor]),
  ((0.0, 1.1), (0.0, 1.8), [maid bath 0.70 from her room only]),
  ((1.6, 11.95), (1.6, 12.75), [laundry 0.80 from the kitchen's arm only]),
)
#let windows = (
  ((-1.25, 6.5), (0.15, 6.5), [outlet 1.4 × 1.0 · raised]),   // GF step 6: into the courtyard, +0.60…+1.60, louvres as L5
  ((4.361, 8.7), (4.361, 10.1), [kitchen window (east)]),
  ((4.361, 7.0), (4.361, 7.9), [kitchen strip window (east)]),
  ((0.65, 0.0), (1.79, 0.0), [escape casement 1.14 × 1.00 (north facade)]),
  ((-1.0, 0.0), (-0.4, 0.0), [bath window (north facade)]),
  ((4.361, 12.5), (4.361, 13.5), [laundry window (east)]),
)

// ---------- Walls that must stay solid ----------
#let solid = (
  ((-1.4, 0.0), (-1.4, 6.5), [solid wall to the women's majlis (no door, no window)]),
  ((-1.4, 4.3), (0.3, 4.3), [chamber north wall: solid]),
  ((1.6, 13.0), (1.6, 14.25), [acoustic wall to the dining]), ((1.6, 14.25), (4.361, 14.25), []),
)

// ---------- Neighbours (grey) ----------
#let neighbours = (
  ((-4.7, 0), (-1.4, 6.5), [Women's majlis]),
  ((2.325, 0), (4.361, 3.2), [open: the step notch (outside both floors)]),   // the first floor's north wall also ends at x 11.275 and steps at y 3.2
  ((2.325, 3.2), (4.361, 6.5), [BACK GARDEN · first floor above]),

  ((-4.7, 6.5), (0, 13.0), [Courtyard]),
  ((0, 13.0), (1.6, 14.25), [dining (arm)]),
  ((0, 14.25), (4.361, 16.0), [Living (normal height) · dining]),
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
#let convex-parts = ("Kitchen": (((0, 7.9), (4.361, 7.9), (4.361, 11.75), (0, 11.75)), ((1.6, 6.5), (4.361, 6.5), (4.361, 7.9), (1.6, 7.9)), ((0, 11.75), (1.6, 11.75), (1.6, 13.0), (0, 13.0))),
  "Small entry": (((0.3, 5.5), (2.325, 5.5), (2.325, 6.5), (0.3, 6.5)), ((0, 6.5), (1.6, 6.5), (1.6, 7.9), (0, 7.9))))   // GF step 10: the kitchen's and the entry's convex parts   // GF step 8: the kitchen's two convex parts (the main room, the strip)
#let shapes = rows.map(r => (r.name, corners(r))) + poly-rooms.map(((n, P, c)) => convex-parts.at(n, default: (P,)).map(Q => (n, Q))).join()
#let block-parts = (((-1.4, 0), (2.325, 0), (2.325, 6.5), (-1.4, 6.5)), ((0, 6.5), (4.361, 6.5), (4.361, 13.0), (0, 13.0)), ((1.6, 13.0), (4.361, 13.0), (4.361, 14.25), (1.6, 14.25)))   // GF step 5: the block's two convex parts   // 17 Nov 2026: the stepped block is not convex: its two convex parts for the half-plane test
#for (n, P) in shapes { if not P.all(p => block-parts.any(B => inside(p, B))) { issues.push(n + " leaves the block") } }
#for i in range(shapes.len()) {
  for j in range(i + 1, shapes.len()) {
    if shapes.at(i).at(0) != shapes.at(j).at(0) and overlap(shapes.at(i).at(1), shapes.at(j).at(1)) { issues.push(shapes.at(i).at(0) + " overlaps " + shapes.at(j).at(0)) }
  }
}
#let used = rows.map(r => r.w * r.d).sum(default: 0) + poly-rooms.map(((n, P, c)) => area(P)).sum(default: 0)
#let leftover = area(block) - used

// ---------- Page ----------
#text(16pt, weight: "bold", fill: rgb("#2f6b4f"))[East service block · V11-idea · NE corner out, GF step 10 (draft): the niche joins the entry (the garden door there), the store joins the maid bath, the maid room 2.10 clear and the majlis +0.30, the kitchen door on y 7.9, the laundry half-half on y 13]\
#text(8pt, fill: gray)[Taif / Palm House · Ground floor · IDEA on the branch idea-ne-corner (23 Nov 2026) · block = the service rooms (CSV x 7.55–11.275 × y 0–6.5 + x 8.95–13.311 × y 6.5–8.3) and the kitchen with the laundry half in the dining (x 10.55–13.311 × y 11.75–14.25); the corner x 11.275–13.311 × y 0–6.5 is open ground · #r2(area(block)) m² · scale 1 m = 1.15 cm · north up]
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
    #text(10pt, weight: "bold", fill: rgb("#2f6b4f"))[GF step 10 (25 Nov 2026, branch idea-ne-corner, DRAFT)]
    - *Dead niche gone:* x 10.55–11.275 × y 5.5–6.5 joins the *entry* (#r2(area(poly-rooms.at(0).at(1))) m² on axes: the courtyard-door bay 1.4 × 1.2 clear + the arm 1.8 × 0.9 clear) and the house's *only outside door* is in its east wall (x 11.275, y 5.5–6.4), straight from the entry; the kitchen's north wall one line on y 6.5. The *corridor* (#r2(area(poly-rooms.at(1).at(1))) m², 1.8 × 1.0 clear) serves the maid room only; it cannot be shorter: its length is the span from the chamber's east wall to the east wall, its 1.0 the minimum; the 0.30 it lost went to the majlis.
    - *Maid bath = bath + store*, on the majlis wall x 7.55–8.95 × y 0–4.3 (#r2(area(poly-rooms.at(3).at(1))) m², 1.2 × 4.075 clear): the WC under its facade window, the basin opposite the door (x 8.95, y 1.1–1.8, from her room only), the shower 1.2 × 0.9 at the south end. *Maid room* east of it x 8.95–11.275 × y 0–4.3 (#r2(area(poly-rooms.at(2).at(1))) m², *2.10 × 4.075 clear*, the V6.4 minimum): the bed on the east wall, the desk under the escape casement, the wardrobe on the bath wall; her door from the corridor (y 4.3, x 9.7–10.5). Why the swap: with the bath east, the maid door would have had only 0.4 m of wall between the chamber (x 9.25) and the bath (x 9.85).
    - *Majlis +0.30:* x 4.25–7.55, 3.1 × 6.275 clear, a clean rectangle; its east wall one line y 0–6.5, the chamber on it. *Chamber tested both ways:* LENGTHWISE x 7.55–9.25 × y 4.3–6.5 (1.5 × 1.95 clear, as now) keeps the y 4.3 line (maid wall + chamber north wall), the door at y 5.6–6.3 from the entry, the corridor 1.8 clear: *chosen*. WIDTHWISE x 7.55–9.70 × y 4.75–6.5 (1.95 × 1.5 clear) leaves the corridor only 0.55 clear between its east wall and the east wall (y 4.75–5.5) or pushes the entry south past the garden door's y 5.5–6.5 and the y 6.5 kitchen line, and a 0.45 strip y 4.3–4.75 east of it: more circulation, a jog: *rejected*.
    - *Kitchen door tested both ways:* (a) on the kitchen's NORTH wall y 7.9 (x 9.55–10.45, swinging south): the arm x 8.95–10.55 becomes the circulation spine straight to the dining door, the main room off it undisturbed, the north counter keeps its 2.5 m, the fridge + pantry at the door: *chosen*. (b) on x 10.55 opposite the courtyard door (as before): a straight axis courtyard → kitchen, but the path then crosses the work zone to the dining door, the door swing cuts the north counter to 1.6 m and the west wall is lost: *rejected*. Entry size equal in both. *Kitchen* #r2(area(poly-rooms.at(4).at(1))) m² on axes.
    - *Laundry half-half*, x 10.55–13.311 × y 11.75–14.25 centred on y 13 (#r2(area(poly-rooms.at(5).at(1))) m², ≈ 2.54 × 2.3 = 5.8 m² clear): its only door from the kitchen's arm (x 10.55, y 11.95–12.75), the machines and the sink on its north wall east of the swing, the folding counter under the *east window* (y 12.5–13.5), its south wall y 14.25 and its west wall y 13–14.25 acoustic to the dining. The kitchen keeps its sink run, hob and hood; the fridge and the tall storage move (north-west corner, laundry wall). *Dining:* a clean rectangle x 8.95–13.311 × y 14.25–19.25 (4.14 × 4.8 clear = 19.9 m²: table for 8 + 0.9 path) plus its arm x 8.95–10.55 × y 13–14.25 at the kitchen door.
    #text(10pt, weight: "bold", fill: rgb("#2f6b4f"))[GF step 9 (25 Nov 2026, branch idea-ne-corner, DRAFT)]
    - *Laundry south of the kitchen*, in the dining's north-east corner x 10.55–13.311 × y 13–15.5 (6.90 m² on axes, ≈ 2.54 × 2.3 = 5.8 m² clear): its only door from the kitchen (y 13, x 11.4–12.2), the washer, the dryer and the sink on the kitchen wall east of it, the folding counter under the *east window* (y 13.6–14.6); its walls to the dining (x 10.55, y 15.5) acoustic; drying by the dryer, no outside door. *The dining* keeps a clean rectangle x 8.95–13.311 × y 15.5–19.25 (4.14 × 3.55 clear = 14.7 m²: a table for 8 of 2.2 × 1.0 with its chairs 3.2 × 2.0 and a 0.9 path along it fit) plus its arm x 8.95–10.55 × y 13–15.5 at the kitchen door; 20.36 m² on axes (≈ 18.0 clear).
    - *Maid area cleaned:* the old laundry place freed; *her bath* x 9.85–11.275 × y 0–2.8 (3.99 m², 1.2 × 2.575 = 3.1 m² clear: WC and basin at the facade end, the shower 1.2 × 0.9 at the south end; from her room only), the *linen store* x 9.85–11.275 × y 2.8–4.3 (2.14 m², 1.2 × 1.3 = 1.56 m² clear, shelves 0.5) off the corridor; the *maid room* unchanged (2.4 × 4.075 clear). No slivers: the cupboard of step 8 gone, its place a *pantry niche of the kitchen* (x 10.55–11.275 × y 5.5–6.5, a tall cupboard).
    - *Entry compact:* x 8.95–10.55 × y 5.5–7.9 (3.84 m², 1.4 × 2.2 clear): the courtyard door y 6.8–7.7, the kitchen door opposite, the malqaf door y 5.6–6.3, open to the corridor; the kitchen takes x 8.95–10.55 × y 7.9–8.3. The *corridor* as before (2.79 m², 1.0 clear): the maid room, the store and the garden door. *Kitchen* 26.83 m² on axes (≈ 24.2 clear). Wall lines: y 4.3 one line from the majlis wall to x 11.275 (the chamber's north wall in it), x 9.85 one line y 0–4.3, x 10.55 one line y 5.5–7.9 and y 13–15.5, y 5.5 one line x 8.95–11.275.
    #text(10pt, weight: "bold", fill: rgb("#2f6b4f"))[GF step 8 (25 Nov 2026, branch idea-ne-corner, DRAFT)]
    - *Small entry* x 8.95–10.55 × y 5.5–8.3 (4.48 m² on axes, *1.4 × 2.6 clear*; longer than the 1.6 asked so that the *malqaf door* at the south end of the chamber's east wall (x 8.95, y 5.6–6.3) opens from it next to the *courtyard door* (kept, x 8.95, y 6.9–7.8); the *kitchen's back door* opposite on x 10.55 (y 6.9–7.8). It opens north, without a door, into the *corridor* y 4.3–5.5 (2.79 m², 1.0 clear) that ends at the house's *only outside door* to the back garden on x 11.275 (y 4.4–5.3, under the first floor; the y 6.5 door removed); a cleaning cupboard off its east end (x 10.55–11.275 × y 5.5–6.5).
    - *Maid room* x 7.25–9.85 × y 0–4.3 (11.18 m², *2.4 × 4.075 clear*), her escape casement on the facade (x 7.9–9.04), her door from the corridor (y 4.3, x 9.0–9.8); *her bath* x 9.85–11.275 × y 0–1.9 (2.71 m², 1.2 × 1.675 clear: WC, basin, a shower over a floor drain; from her room only; a small facade window); *laundry* x 9.85–11.275 × y 1.9–4.3 (3.42 m², 1.2 × 2.2 clear: the washer and the dryer side by side on its north wall, a sink, away from the majlis wall; a window and an exhaust fan on the east wall; door from the corridor). The laundry is narrow (1.2 clear): the better alternative, if the owner wants a full laundry, is a room under the first floor in the back garden (x 11.275–13.311 × y 3.2–6.5, entered from the corridor's garden door).
    - *Kitchen* an L: the main room + the strip x 10.55–13.311 × y 6.5–8.3: 25.47 m² on axes (≈ 23.1 clear): the sink on the courtyard wall, the hob on the east wall, the fridge as before; the north counter moved into the strip under its north wall; the strip's east window kept. *The malqaf chamber* unchanged (its north wall and the rest of its east wall solid). The women's majlis, the courtyard and the liwan unchanged; FF and roof unchanged.
    #text(10pt, weight: "bold", fill: rgb("#2f6b4f"))[GF step 6 (24 Nov 2026, branch idea-ne-corner, DRAFT)]
    - *The malqaf chamber moved from the courtyard's north-west corner to its north-EAST:* inside the open space, against the courtyard's north wall at its east end, CSV x 7.25–8.95 × y 4.3–6.5 (1.7 × 2.2 on axes, ≈ 1.5 × 1.95 clear; L5 was 1.2 × 1.97): its *maintenance door 0.90 in its north wall (y 4.3, x 7.6–8.5) from the open space*, not from the courtyard; its *breeze outlet 1.4 × 1.0 in its courtyard wall (y 6.5, x 7.4–8.8), raised +0.60…+1.60, louvres as L5*, blowing south over the olive onto the liwan. The open space keeps its boundary and its three doors; it loses the chamber's 3.74 m²: 30.27 m² on axes (≈ 27.3 m² clear).
    - *The kitchen's sink window on x 8.95 removed:* that wall is the liwan's back wall now (the liwan x 7.25–8.85 × y 8.0–12.9, bench +0.40, on the courtyard side); the sink stays on the blind wall, the kitchen keeps its east window (y 8.7–10.1). The courtyard door (x 8.95, y 6.9–7.8) stays. *The malqaf core rises at its new place: FF and roof to follow.*
    #text(10pt, weight: "bold", fill: rgb("#2f6b4f"))[GF step 5 (24 Nov 2026, branch idea-ne-corner)]
    - *One open space, no inner partitions, to be planned later:* the maid bath, the laundry, the maid room and the distribution lobby of steps 3–4 together, from the women's majlis's east wall (x 7.25) to the east outside wall, north of the kitchen (y 8.3) and the courtyard (y 6.5): 34.01 m² on axes; inside the wall faces *3.80 × 6.28 m (x 7.35–11.15, y 0.125–6.4) plus 4.14 × 1.80 m (x 9.05–13.19, y 6.4–8.2) ≈ 31.3 m²*. Every inner wall, inner door, fixture and piece of furniture removed.
    - *Its boundary kept exactly:* the outside walls with their windows (the escape casement x 9.5–10.64 and the small window x 7.7–8.3 on the north facade; the east window y 7.0–7.9), the majlis wall x 7.25 (no door in it), the courtyard wall, the kitchen's north wall y 8.3. *Doors kept in the boundary:* from the courtyard (x 8.95, y 6.9–7.8), the kitchen's back door (y 8.3, x 9.6–10.5), the only outside door to the back garden (y 6.5, x 11.8–12.7).
    - Nothing else changes; one step in the outside wall at (11.275, 6.5); the first floor unchanged.
    #text(10pt, weight: "bold", fill: rgb("#2f6b4f"))[GF step 4 (24 Nov 2026, branch idea-ne-corner)]
    - *The lobby / kitchen wall y 8.3 runs east to the outside wall x 13.311:* the kitchen's north-east part (x 11.275–13.311 × y 6.5–8.3) joins the lobby.
    - *Kitchen:* an exact rectangle x 8.95–13.311 × y 8.3–13.0, 4.36 × 4.7 on axes = 20.50 m² (≈ 4.14 × 4.5 = 18.6 m² clear; V11.0 28.35 / 26.06): the sink and its courtyard window (y 8.5–10.1), the cooking run on the east wall with the east window (y 8.7–10.1), the fridge and tall storage, a counter on the north wall; its doors: the dining (south) and the lobby (north, x 9.6–10.5).
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

// guest_wing.typ · Taif / Palm House · layout study of the WEST WASH BLOCK: hospitality kitchen + family basins + family WC + guest wing as one design (compile THIS file)
// Ground floor V6.2. Stand-alone: all data is in this file. Source of truth for the block;
// ../design_gf.typ + ../data/rooms_gf.csv carry the same rooms and doors (main CSV y = local y + 10.4). Keep both in step.
#import "@preview/cetz:0.4.2"
#set page(paper: "a4", margin: 12mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 8pt)

// ---------- The block (local coordinates, metres: origin = NW corner, x east, y SOUTH) ----------
#let W = 2.75            // block width  (main CSV: x 0–2.75)
#let D = 13.6            // block depth  (main CSV: y 10.4–24.0)
#let scale = 1.35cm      // 1 m on paper

// ---------- Doors and openings: ((x1, y1), (x2, y2), label) on the walls ----------
#let doors = (
  ((2.75, 0.2), (2.75, 2.3), [open to the riwaq]),
  ((2.75, 2.6), (2.75, 3.9), [open to the riwaq]),
  ((1.6, 4.0), (2.4, 4.0), [family WC door]),
  ((2.75, 5.85), (2.75, 6.75), [door 1 · 0.90 (to the riwaq)]),
  ((0.1, 7.1), (1.15, 7.1), [door 2 · 1.05]),
  ((1.3, 8.85), (2.05, 8.85), [WC door (south, opens in)]),
  ((0.0, 11.1), (0.0, 12.5), [guest door 1.40 (2 leaves)]),
  ((2.75, 11.75), (2.75, 13.55), [open 1.80 to majlis]),
)

// ---------- Extra walls and screens: ((x1, y1), (x2, y2), label) ----------
#let walls = (
  ((0.0, 2.5), (2.75, 2.5), [hospitality kitchen / basins wall (full height)]),   // each side opens only to the riwaq
  ((1.25, 8.85), (1.25, 9.45), [WC screen wall]),   // guest WC west wall carried 0.6 m into the basin room: hides the WC door from the passage
)

// ---------- Fixtures (drawn thin, not counted): (x0, y0, x1, y1, label) ----------
#let fixtures = (
  (0.1, 0.1, 2.5, 0.7, [counter · sink · fridge · microwave]),     // hospitality kitchen: L-counter, north wall …
  (0.1, 0.7, 0.7, 2.4, [counter · trays]),                          // … and the west wall (the wall shared with the basins stays plain)
  (0.1, 2.6, 1.8, 3.1, [basin counter (2)]),                        // family basins: straight counter, no cupboards opposite
  (2.15, 9.0, 2.65, 10.8, [trough 1.8 · 3 taps]),                   // guest basins: one long trough on the east wall
  (2.25, 11.05, 2.65, 11.7, [shoes · hooks]),                       // foyer: shoe cabinet + bisht / shemagh hooks, wall facing the entrance
)

// ---------- Neighbours (context only, drawn grey) ----------
#let neighbours = (
  ((0, -1.2), (2.75, 0), [Utility room (shaft)]),
  ((2.75, -1.2), (4.25, 8.85), [Riwaq]),
  ((2.75, 8.85), (5.0, 13.6), [Men's majlis]),
)

// ---------- Rooms: (name, x, y, w, d, colour) · x, y = centre, local metres from the block's NW corner, y south ----------
// put // in front of a line to switch a room off
#let rooms-data = (
  ("Hospitality kitchen",       1.375, 1.25,  2.75, 2.5,  "pantry"),   // light kitchen, the serving base; open to the riwaq, no door
  ("Family basins (2)",         1.375, 3.25,  2.75, 1.5,  "basin"),
  ("Family WC + basin",         1.375, 4.85,  2.75, 1.7,  "wc"),
  ("Serving passage (2 doors)", 1.375, 6.4,   2.75, 1.4,  "pantry"),   // 1.20 m clear, no shelf, no fixed equipment
  ("Guest WC",                  2.0,   7.975, 1.5,  1.75, "wc"),       // south wall on the men's majlis north wall line
  ("Guest basins (trough · 3 taps)", 2.0, 9.925, 1.5, 2.15, "basin"),
  ("Guest passage",             0.625, 9.05,  1.25, 3.9,  "circ"),
  ("Foyer + entry",             1.375, 12.3,  2.75, 2.6,  "foyer"),
)
#let colours = (pantry: rgb("#efe3c8"), wc: rgb("#d9e6ec"), basin: rgb("#cfe6ef"), circ: rgb("#f2efe8"), foyer: rgb("#e9d9c4"))
#let rows = rooms-data.map(((n, x, y, w, d, c)) => (name: n, x: str(x), y: str(y), w: str(w), d: str(d), colour: c))
#let box(r) = {
  let x = float(r.x); let y = float(r.y); let w = float(r.w); let d = float(r.d)
  (x - w / 2, y - d / 2, x + w / 2, y + d / 2)
}
#let q(x, y) = (x, -y)
#let r2(v) = str(calc.round(v, digits: 2))

// ---------- Checks ----------
#let eps = 0.001
#let issues = ()
#for r in rows {
  let (x0, y0, x1, y1) = box(r)
  if x0 < -eps or y0 < -eps or x1 > W + eps or y1 > D + eps { issues.push(r.name + " leaves the block") }
}
#for i in range(rows.len()) {
  for j in range(i + 1, rows.len()) {
    let (a0, b0, a1, b1) = box(rows.at(i))
    let (c0, d0, c1, d1) = box(rows.at(j))
    if calc.min(a1, c1) - calc.max(a0, c0) > eps and calc.min(b1, d1) - calc.max(b0, d0) > eps {
      issues.push(rows.at(i).name + " overlaps " + rows.at(j).name)
    }
  }
}
#let used = rows.map(r => float(r.w) * float(r.d)).sum(default: 0)
#let free = W * D - used
#if calc.abs(free) > 0.01 { issues.push("unassigned area inside the block: " + r2(free) + " m²") }

// ---------- Page ----------
#text(16pt, weight: "bold", fill: rgb("#2f6b4f"))[West wash block · family + guest · layout study]\
#text(8pt, fill: gray)[Taif / Palm House · Ground floor V6.2 · block #r2(W) × #r2(D) m = #r2(W * D) m² · scale 1 m = 1.35 cm · north up]
#v(6pt)
#grid(columns: (auto, 1fr), column-gutter: 14pt,
  cetz.canvas(length: scale, {
    import cetz.draw: *
    for ((a, b), (c, d), l) in neighbours {
      rect(q(a, b), q(c, d), fill: luma(240), stroke: (paint: luma(190), dash: "dashed"))
      content(q((a + c) / 2, (b + d) / 2), text(6.5pt, fill: gray, l))
    }
    for r in rows {
      let (x0, y0, x1, y1) = box(r)
      rect(q(x0, y0), q(x1, y1), fill: colours.at(r.colour, default: luma(230)), stroke: 0.6pt + rgb("#3d4a45"))
      content(q((x0 + x1) / 2, (y0 + y1) / 2), align(center, text(6pt)[*#r.name*\ #r2(float(r.w)) × #r2(float(r.d))\ #r2(float(r.w) * float(r.d)) m²]))
    }
    for (x0, y0, x1, y1, l) in fixtures {
      rect(q(x0, y0), q(x1, y1), fill: white.transparentize(30%), stroke: (paint: gray, thickness: 0.4pt, dash: "dashed"))
      content(q((x0 + x1) / 2, (y0 + y1) / 2), angle: if (y1 - y0) > (x1 - x0) { 90deg } else { 0deg }, text(4.6pt, fill: gray, l))
    }
    rect(q(0, 0), q(W, D), stroke: 2pt + rgb("#3d4a45"))
    // family / guest line: one wall across the block, crossed only through the serving passage
    line(q(0, 7.1), q(W, 7.1), stroke: 1.4pt + rgb("#3d4a45"))
    for ((a, b), (c, d), l) in walls {
      line(q(a, b), q(c, d), stroke: 2pt + rgb("#3d4a45"))
      content(q(c - 0.08, d + 0.12), anchor: "north-east", text(5.5pt, fill: rgb("#3d4a45"), l))
    }
    for ((a, b), (c, d), l) in doors {
      line(q(a, b), q(c, d), stroke: 4pt + rgb("#b5452f"))
      let vertical = calc.abs(a - c) < 0.01
      if vertical and a > W - 0.01 { content(q(a + 0.15, (b + d) / 2), anchor: "west", text(6pt, fill: rgb("#b5452f"), l)) }
      else if vertical and a < 0.01 { content(q(a - 0.15, (b + d) / 2), anchor: "east", text(6pt, fill: rgb("#b5452f"), l)) }
      else if vertical { content(q(a - 0.1, (b + d) / 2), anchor: "east", text(6pt, fill: rgb("#b5452f"), l)) }
      else { content(q((a + c) / 2, b - 0.12), anchor: "south-west", text(6pt, fill: rgb("#b5452f"), l)) }
    }
    // scale bar
    line(q(0, D + 0.6), q(1, D + 0.6), stroke: 1.2pt)
    content(q(0.5, D + 0.85), text(6pt)[1 m])
  }),
  [
    #set text(6.8pt)
    #text(10pt, weight: "bold", fill: rgb("#2f6b4f"))[Rooms]
    #table(columns: (auto, auto, auto), stroke: none, inset: 2.5pt,
      [*Room*], [*w × d (m)*], [*m²*],
      ..rows.map(r => ([#r.name], [#r2(float(r.w)) × #r2(float(r.d))], [#r2(float(r.w) * float(r.d))])).flatten(),
      [*Block*], [#r2(W) × #r2(D)], [*#r2(W * D)*],
    )
    #v(4pt)
    #if issues.len() == 0 { text(fill: rgb("#2f6b4f"), weight: "bold")[✓ All rooms inside the block, no overlaps, no gaps] } else { block(fill: rgb("#fbe3dd"), inset: 5pt, radius: 2pt)[#text(fill: rgb("#b5452f"), weight: "bold")[WARNING]\ #issues.map(i => [• #i]).join(linebreak())] }
    #v(6pt)
    #text(10pt, weight: "bold", fill: rgb("#2f6b4f"))[Route]
    *Guests:* double door (north end of the foyer's west wall) → foyer: shoes and bisht on the wall opposite → turn south → 1.80 m opening into the men's majlis (south end of the east wall). For washing: foyer → guest passage → trough basin and WC.\
    *Family:* riwaq → hospitality kitchen (open, no door) · family basins (open, no door) → family WC (door off the basins).\
    *Serving:* hospitality kitchen or main kitchen → riwaq → door 1 → *serving passage* → door 2 → guest passage → foyer → majlis. The two doors are never open together: the family leaves the tray, closes door 1 and calls the host; the host opens door 2 and collects. Door 1 locks from the riwaq side, door 2 from inside the passage, so the family controls both. The guest side has no door onto the riwaq.
    #v(4pt)
    #text(10pt, weight: "bold", fill: rgb("#2f6b4f"))[Rules]
    - Hospitality kitchen 2.75 × 2.5 (≈ 5.8 m² clear): light (clean) kitchen for coffee, tea, dates, desserts and reheating; the serving base for the men's majlis. Open to the riwaq, no door, no hob. L-counter on the north and west walls with a small sink, under-counter fridge, microwave, kettle and coffee things; cups and trays stored there; small extract fan. The main east kitchen is the heavy (dirty) kitchen.
    - A full-height wall separates the hospitality kitchen from the family basins; each opens only to the riwaq.
    - Family basins (2): a straight counter, no cupboards opposite (≈ 0.75–0.8 m in front, plus the open riwaq).
    - Family WC 2.75 × 1.7: WC and basin, no shower (showers are on the first floor). Door off the basin niche.
    - Serving passage 2.75 × 1.4 on axes, 1.20 m clear, no shelf and no fixed equipment; door 1 0.90 m to the riwaq, door 2 1.05 m to the guest passage. Opposite door 1 the living room has only a 1.20 m low partition, so privacy rests on the two doors.
    - Guest WC 1.5 × 1.75 (≈ 1.3 × 1.55 clear), its south wall on the same line as the men's majlis north wall. WC and hand spray only; door in the south wall, opening in, hidden from the passage by a 0.6 m screen wall.
    - Guest basins: one trough ≈ 1.8 m with three taps on the east wall, open to the guest passage (≈ 1.025 m clear).
    - Foyer 2.75 × 2.6: double door 1.40 m (two leaves, opening in) at the north end of the west wall; 1.80 m opening, no door, at the south end of the east wall (≈ 0.65 m of wall left at its north end for the shoe cabinet and hooks). The two openings overlap by ≈ 0.75 m along the foyer, so the bent entry is only partial: from the door a guest sees a strip of the majlis; a curtain or a short screen in front of the opening would close it.
    - One strip of wet rooms on one drain run (hospitality kitchen sink, family basins, family WC, guest WC, trough), cleanout under the serving passage. First-floor bathrooms stack over the north part of the block, near the shaft.
  ],
)

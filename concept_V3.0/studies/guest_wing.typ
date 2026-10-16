// guest_wing.typ · Taif / Palm House · layout study of the WEST WASH BLOCK: family basins + family WC + guest wing as one design (compile THIS file)
// Stand-alone: all data is in this file. Source of truth for the block; ../design_v3.typ + ../data/rooms_v3.csv carry the same rooms and doors (main y = local y + 10.4). V3.2: Revision 02 of 16 Oct 2026.
#import "@preview/cetz:0.4.2"
#set page(paper: "a4", margin: 12mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 8pt)

// ---------- The block (local coordinates, metres: origin = NW corner, x east, y SOUTH) ----------
#let W = 2.75            // block width  (main CSV: x 0–2.75)
#let D = 13.1            // block depth  (main CSV: y 10.4–23.5)
#let scale = 1.7cm       // 1 m on paper

// ---------- Doors and openings: ((x1, y1), (x2, y2), label) on the walls ----------
#let doors = (
  ((2.75, 0.2), (2.75, 1.85), [open to the riwaq]),
  ((2.75, 2.1), (2.75, 3.4), [open to the riwaq]),
  ((1.6, 3.5), (2.4, 3.5), [family WC door]),
  ((2.75, 5.35), (2.75, 6.25), [door 1 · 0.90 (to the riwaq)]),
  ((0.1, 6.8), (1.15, 6.8), [door 2 · 1.05]),
  ((1.3, 8.5), (2.05, 8.5), [WC door (south, opens in)]),
  ((0.0, 11.1), (0.0, 12.3), [guest entrance]),
  ((2.75, 11.0), (2.75, 12.2), [door to men's majlis]),
)

// ---------- Extra walls and screens: ((x1, y1), (x2, y2), label) ----------
#let walls = (
  ((0.0, 2.0), (2.75, 2.0), [coffee / basins wall (full height)]),   // V3.2: the coffee corner and the family basins each open only to the riwaq
  ((1.0, 5.3), (1.7, 5.3), [shelf 0.70 × 0.20]),                     // serving shelf on the passage's north wall; 1.20 m clear in front of it
  ((1.25, 8.5), (1.25, 9.1), [WC screen wall]),   // guest WC west wall carried 0.6 m into the basin area: hides the WC door from the passage
)

// ---------- Neighbours (context only, drawn grey) ----------
#let neighbours = (
  ((0, -1.2), (2.75, 0), [Utility room (shaft)]),
  ((2.75, -1.2), (4.25, 8.35), [Riwaq]),
  ((2.75, 8.35), (5.0, 13.1), [Men's majlis]),
)

// ---------- Rooms: (name, x, y, w, d, colour) · x, y = centre, local metres from the block's NW corner, y south ----------
// put // in front of a line to switch a room off
#let rooms-data = (
  ("Coffee corner (open use)", 1.375, 1.0,  2.75, 2.0, "pantry"),
  ("Family basins (2)",       1.375, 2.75,  2.75, 1.5, "basin"),
  ("Family WC + basin",       1.375, 4.35,  2.75, 1.7, "wc"),
  ("Serving passage (2 doors)", 1.375, 6.0, 2.75, 1.6, "pantry"),   // V3.2: 1.6 on axes = 1.40 between walls = 0.20 shelf + 1.20 clear
  ("Guest WC",           2.0,   7.65,  1.5,  1.7, "wc"),             // V3.2: the whole guest block moved 0.50 m south
  ("Basins (3)",         2.0,   9.5,   1.5,  2.0, "basin"),
  ("Guest passage",      0.625, 8.65,  1.25, 3.7, "circ"),
  ("Foyer + entry",      1.375, 11.8,  2.75, 2.6, "foyer"),
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
#text(8pt, fill: gray)[Taif / Palm House · Design V3.2 (Z4, Revision 02) · block #r2(W) × #r2(D) m = #r2(W * D) m² · scale 1 m = 1.7 cm · north up]
#v(6pt)
#grid(columns: (auto, 1fr), column-gutter: 22pt,
  cetz.canvas(length: scale, {
    import cetz.draw: *
    for ((a, b), (c, d), l) in neighbours {
      rect(q(a, b), q(c, d), fill: luma(240), stroke: (paint: luma(190), dash: "dashed"))
      content(q((a + c) / 2, (b + d) / 2), text(6.5pt, fill: gray, l))
    }
    for r in rows {
      let (x0, y0, x1, y1) = box(r)
      rect(q(x0, y0), q(x1, y1), fill: colours.at(r.colour, default: luma(230)), stroke: 0.6pt + rgb("#3d4a45"))
      content(q((x0 + x1) / 2, (y0 + y1) / 2), align(center, text(6.5pt)[*#r.name*\ #r2(float(r.w)) × #r2(float(r.d))\ #r2(float(r.w) * float(r.d)) m²]))
    }
    rect(q(0, 0), q(W, D), stroke: 2pt + rgb("#3d4a45"))
    // family / guest line: one wall across the block, with the one family / guest door in it
    line(q(0, 6.8), q(W, 6.8), stroke: 1.4pt + rgb("#3d4a45"))
    for ((a, b), (c, d), l) in walls {
      line(q(a, b), q(c, d), stroke: 2pt + rgb("#3d4a45"))
      content(q(c - 0.08, d + 0.12), anchor: "north-east", text(6pt, fill: rgb("#3d4a45"), l))
    }
    for ((a, b), (c, d), l) in doors {
      line(q(a, b), q(c, d), stroke: 4pt + rgb("#b5452f"))
      let vertical = calc.abs(a - c) < 0.01
      if vertical and a > W - 0.01 { content(q(a + 0.15, (b + d) / 2), anchor: "west", text(6.5pt, fill: rgb("#b5452f"), l)) }
      else if vertical and a < 0.01 { content(q(a - 0.15, (b + d) / 2), anchor: "east", text(6.5pt, fill: rgb("#b5452f"), l)) }
      else if vertical { content(q(a - 0.1, (b + d) / 2), anchor: "east", text(6pt, fill: rgb("#b5452f"), l)) }
      else { content(q((a + c) / 2, b - 0.12), anchor: "south-west", text(6pt, fill: rgb("#b5452f"), l)) }
    }
    // scale bar
    line(q(0, D + 0.6), q(1, D + 0.6), stroke: 1.2pt)
    content(q(0.5, D + 0.85), text(6pt)[1 m])
  }),
  [
    #set text(7.2pt)
    #text(10pt, weight: "bold", fill: rgb("#2f6b4f"))[Rooms]
    #table(columns: (auto, auto, auto), stroke: none, inset: 3pt,
      [*Room*], [*w × d (m)*], [*m²*],
      ..rows.map(r => ([#r.name], [#r2(float(r.w)) × #r2(float(r.d))], [#r2(float(r.w) * float(r.d))])).flatten(),
      [*Block*], [#r2(W) × #r2(D)], [*#r2(W * D)*],
    )
    #v(6pt)
    #if issues.len() == 0 { text(fill: rgb("#2f6b4f"), weight: "bold")[✓ All rooms inside the block, no overlaps, no gaps] } else { block(fill: rgb("#fbe3dd"), inset: 5pt, radius: 2pt)[#text(fill: rgb("#b5452f"), weight: "bold")[WARNING]\ #issues.map(i => [• #i]).join(linebreak())] }
    #v(8pt)
    #text(10pt, weight: "bold", fill: rgb("#2f6b4f"))[Route]
    *Guests:* entrance → foyer → majlis; for washing, foyer → guest passage (west) → basins and WC (east).\
    *Family:* riwaq → family basins (open, no door) → family WC (door off the basins) · coffee corner (open to the riwaq only; a full-height wall separates it from the basins).\
    *Serving:* coffee corner or kitchen → riwaq → *serving passage* (door 1, shelf, door 2) → guest passage → foyer → majlis.\
    The serving passage is the ONLY link between the family and guest sides, with only two doors: the family opens door 1 from the riwaq, puts coffee, trays or food on the shelf, closes door 1 and calls the host; the host opens door 2 from the guest passage, collects and closes it. The two doors are never open together. Bent entry (majaz): an open door 2 shows only the passage, the blank south wall of the family WC and the closed door 1 at the far end. The guest side has no door onto the riwaq.\
    Doors in the whole block: family WC, serving doors 1 and 2, guest WC, guest entrance, majlis door. No corridor doors.
    #v(6pt)
    #text(10pt, weight: "bold", fill: rgb("#2f6b4f"))[Rules]
    - One strip of wet rooms on one drain run: coffee-corner sink, family basins, family WC, guest WC, guest basins. Family WC and guest WC sit 1.1 m apart; the drain crosses under the serving passage floor (1.6 m deep), with a cleanout access point there. First-floor bathrooms should stack over the north part of the block, near the shaft.
    - Family / guest line at y = 6.8: crossed only through the serving passage (2.75 × 1.6 on axes, 1.40 m between walls): a shelf 0.70 × 0.20 on its north wall and 1.20 m clear in front of it. Door 1 0.90 m, door 2 1.05 m. Door 1 locks from the riwaq side and door 2 from inside the passage, so the family controls both.
    - Door 1 is at the passage's east end, on the riwaq. Opposite it the living room now has a 1.20 m low partition (open above), so it is no full screen for someone standing: family privacy relies on the two doors never being open together.
    - Family WC full width (2.75 × 1.7 = 4.68 m²): WC and basin; a small shower (≈ 0.9 × 0.9) still fits at one end. Its door is off the basin niche, so the open family door never faces it.
    - Family basins (2): an open niche on the riwaq (2.75 × 1.5), no door; a full-height wall separates it from the coffee corner.
    - Coffee corner (2.75 × 2.0, open use, still to decide): one counter along the north wall with a small sink, kettle and coffee things, and an under-counter fridge. Open to the riwaq on its east side only.
    - The guest WC holds a WC only (and a hand spray). Its door is in the south wall at the west end, opening inwards, clear of the basin counter on the east wall (≈ 0.55 m deep).
    - The guest WC west wall continues 0.6 m south as a screen: from the passage the WC door is out of sight, but the basins stay open.
    - Three guest basins in one row (≈ 0.6 m each) along the east wall, open to the passage (≈ 1.025 m clear).
    - V3.2: the guest WC, basins, guest passage and foyer moved 0.50 m south as one block (sizes unchanged); the south facade is 0.50 m further south.
  ],
)

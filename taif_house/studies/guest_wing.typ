// guest_wing.typ · Taif / Palm House · layout study of the WEST WASH BLOCK: hospitality kitchen + family basins + family WC + guest wing as one design (compile THIS file)
// Ground floor V10.0 (the owner's review of 10 Nov 2026, redrawn: the powder room's WC compartment across the full width; the guest WC and the three basins two rectangles side by side onto the guest passage). Stand-alone: all data is in this file. Source of truth for the block;
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
  ((2.75, 2.65), (2.75, 3.65), [powder room door 1.00 (from the riwaq)]),
  ((2.75, 5.85), (2.75, 6.75), [door 1 · 0.90 (to the riwaq)]),
  ((0.1, 7.1), (1.15, 7.1), [door 2 · 1.05]),
  ((1.25, 8.0), (1.25, 8.9), [WC door 0.90 (west, onto the passage, opens in)]),   // 10 Nov 2026 (redrawn)
  ((1.6, 4.15), (2.3, 4.15), [WC compartment door 0.70 (opens in)]),   // 10 Nov 2026 (owner): the powder room's WC compartment across the full width
  ((1.25, 9.1), (1.25, 10.9), [wide opening 1.8 to the basins]),
  ((0.0, 11.1), (0.0, 12.5), [guest door 1.40 (2 leaves)]),
  ((2.75, 11.75), (2.75, 13.55), [open 1.80 to majlis]),
)

// ---------- Extra walls and screens: ((x1, y1), (x2, y2), label) ----------
#let walls = (
  ((0.0, 2.5), (2.75, 2.5), [hospitality kitchen / powder room wall (full height)]),   // the hospitality kitchen opens only to the riwaq; the powder room has its door
  ((0.0, 5.45), (2.75, 5.45), [service wall 0.25 (the WC's frame, bath 3's stack)]),   // 3 Nov 2026: a service wall on the powder room's south side, accessible from the serving passage
  ((0.0, 4.15), (2.75, 4.15), [WC compartment · 100 mm, the full width]),   // 10 Nov 2026 (redrawn): the powder room's WC compartment y 4.15–5.7, the full 2.75 m
)

// ---------- Fixtures (drawn thin, not counted): (x0, y0, x1, y1, label) ----------
#let fixtures = (
  (0.1, 0.1, 2.5, 0.7, [counter · sink · fridge · microwave]),     // hospitality kitchen: L-counter, north wall …
  (0.1, 0.7, 0.7, 2.4, [counter · trays]),                          // … and the west wall (the wall shared with the basins stays plain)
  (0.1, 2.6, 0.65, 4.05, [vanity · 2 basins · mirror]),             // 10 Nov 2026 (owner): the two basins under a large mirror on the west wall, in the open zone in front of the entrance (the door at y 2.65–3.65)
  (1.95, 4.95, 2.5, 5.45, [wall-hung WC]),                          // in its compartment, on the south service wall (the frame and bath 3's stack inside it)
  (0.1, 4.45, 0.5, 4.95, [basin]),                              // the small basin inside the WC compartment
  (1.35, 7.2, 2.65, 8.0, [shower zone · wall-mounted · floor drain]),   // 10 Nov 2026 (owner): a wet room, no cubicle wall, no tray; the shower on the north wall
  (2.2, 8.2, 2.65, 8.9, [WC · hand spray]),                       // the guest WC pan, clear of the door's swing
  (2.2, 9.1, 2.65, 10.9, [3 basins in a row · mirror]),                   // guest basins: three basins (or one trough with three taps) in one straight line on the east wall, 1.45 m
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
  ("Family powder room (WC · 2 basins)", 1.375, 4.1, 2.75, 3.2, "basin"),   // 3 Nov 2026 (owner): the basins and the WC as one luxurious powder room; no shower on the ground floor
  ("Serving passage (2 doors)", 1.375, 6.4,   2.75, 1.4,  "pantry"),   // 1.20 m clear, no shelf, no fixed equipment
  ("Guest WC",                  2.0,   8.05,  1.5,  1.9,  "wc"),         // 10 Nov 2026 (owner): 0.5 m deeper; a wet room: only the WC and a wall-mounted shower (y 7.1–9.35 local)
  ("Guest basins (trough · 3 taps)", 2.0, 10.0, 1.5, 2.0, "basin"),     // 10 Nov 2026: 0.5 m shallower, keeps the trough with three taps
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
#text(8pt, fill: gray)[Taif / Palm House · Ground floor V10.0 (the owner's review, 10 Nov 2026) · block #r2(W) × #r2(D) m = #r2(W * D) m² · scale 1 m = 1.35 cm · north up]
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
    *Guests:* double door (north end of the foyer's west wall) → foyer: shoes and bisht on the wall opposite → turn south → 1.80 m opening into the men's majlis (south end of the east wall). For washing: foyer → guest passage → the three basins (a wide opening) and the WC (its own door, next to them).\
    *Family:* riwaq → hospitality kitchen (open, no door) · the family *powder room* (one door from the riwaq; the two basins under the mirror in the open zone facing the door, the WC compartment across the far end with its own door, a WC and one basin).\
    *Serving:* hospitality kitchen or main kitchen → riwaq → door 1 → *serving passage* → door 2 → guest passage → foyer → majlis. The two doors are never open together: the family leaves the tray, closes door 1 and calls the host; the host opens door 2 and collects. Door 1 locks from the riwaq side, door 2 from inside the passage, so the family controls both. The guest side has no door onto the riwaq.
    #v(4pt)
    #text(10pt, weight: "bold", fill: rgb("#2f6b4f"))[Rules]
    - Hospitality kitchen 2.75 × 2.5 (≈ 5.8 m² clear): light (clean) kitchen for coffee, tea, dates, desserts and reheating; the serving base for the men's majlis. Open to the riwaq, no door, no hob. L-counter on the north and west walls with a small sink, under-counter fridge, microwave, kettle and coffee things; cups and trays stored there; small extract fan. The main east kitchen is the heavy (dirty) kitchen.
    - A full-height wall separates the hospitality kitchen from the powder room; the kitchen opens only to the riwaq, the powder room has its own door.
    - *Family powder room 2.75 × 3.2 (≈ 7.6 m² clear; 10 Nov 2026, owner: redrawn simple and rectangular):* the *WC compartment across the full width* at the south end (y 14.55–16.1 CSV, 2.75 × 1.55 on axes, ≈ 2.55 × 1.38 clear; a 100 mm partition; its own 0.70 door at x 1.6–2.3, opening in) with *only the WC* (wall-hung, on the south 0.25 service wall at the east end: its frame and bedroom 3's stack inside the wall, an access panel from the serving passage) *and one basin* on the west wall; *outside, the open zone in front of the entrance* (y 12.9–14.55, 2.75 × 1.65, ≈ 2.55 × 1.5 clear; the door 1.00 from the riwaq, x 2.75, y 13.05–14.05) with *exactly two basins under a large mirror* on the west wall (a 1.45 m vanity), cove lighting; *no shower*. Swings: the entrance door sweeps x 1.75–2.75, the compartment door x 1.6–2.3 inside the compartment: both clear of the basins and the WC; a person at the two basins (x 0.65–1.2) does not stand in front of the compartment door. The drains 0.5 m into the west buried run; the hidden beam B14 (y 14.4) becomes a drop beam or the slab spans 3.2 m (the engineer).
    - Serving passage 2.75 × 1.4 on axes, 1.20 m clear, no shelf and no fixed equipment; door 1 0.90 m to the riwaq, door 2 1.05 m to the guest passage. Opposite door 1 the living's west wall is solid and full height (the TV wall, V6.3); privacy rests on the two doors.20 m low partition, so privacy rests on the two doors.
    - *Guest WC 1.5 × 1.9 (≈ 1.3 × 1.7 clear; 10 Nov 2026, owner: redrawn):* a clean rectangle east of the guest passage (x 1.25–2.75, y 17.5–19.4 CSV) with *its own 0.90 door on the passage* (the west wall, y 18.4–19.3, opening in); inside *only the WC* (with its hand spray, in the south-east corner, facing west) *and a wall-mounted shower with mixer* on the north wall over a floor drain with falls (the wet zone 1.3 × 0.8 at the north end), the whole room tanked and tiled; *no basin, no cubicle wall, no tray, nothing diagonal*. The door's swing (x 1.25–2.15, y 18.4–19.3) clears the WC (x 2.2–2.65).
    - *Guest basins 1.5 × 2.0 (≈ 1.3 × 1.8 clear; 10 Nov 2026, redrawn):* the rectangle right next to the WC (x 1.25–2.75, y 19.4–21.4 CSV), open to the guest passage through a *1.8 m wide opening* (y 19.5–21.3); *three basins in one straight row* on the east wall (1.8 m: three bowls at 0.6 m) under a mirror. A guest at the basins stands inside this room (x 1.6–2.2), not in the passage and not in front of the WC's door, which is 0.1 m north of the opening.
    - Foyer 2.75 × 2.6: double door 1.40 m (two leaves, opening in) at the north end of the west wall; 1.80 m opening, no door, at the south end of the east wall (≈ 0.65 m of wall left at its north end for the shoe cabinet and hooks). The two openings overlap by ≈ 0.75 m along the foyer, so the bent entry is only partial: from the door a guest sees a strip of the majlis; a curtain or a short screen in front of the opening would close it.
    - One strip of wet rooms on one drain run, the west buried run (hospitality kitchen sink, the powder room's three basins and WC, the guest WC's floor drain and WC, the three guest basins), cleanout under the serving passage. First-floor bathrooms stack over the north part of the block, near the shaft.
  ],
)

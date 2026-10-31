// courtyard_layout.typ · Taif / Palm House V7.1 · COURTYARD LAYOUT STUDY (design review: courtyard usability and drainage, major) · owner decisions 1 Nov 2026
// The courtyard as a room: the level colonnade walkway, a seating area one step down with built-in benches and a low table, the outdoor TV on the
// kitchen wall with a semicircular stone frame and the malqaf grille below it, one stone enclosure at the north end with a water basin and a planting
// basin for one tree, no pergola, and the drainage shown in section. CLEAR dimensions between finished faces everywhere.
// Reads: data/rooms_gf.csv (the courtyard and its neighbours), 3d/params.yaml (the windows), 3d/character.yaml (`courtyard_layout`), studies/air_system.typ (the grille).
// CSV frame: x east, y south, wall centre lines; levels above the finished ground floor ±0.00.
#import "@preview/cetz:0.4.2"
#import "air_system.typ": air-grille, air-grille-x, air-chamber, air-cover, air-route
#set page(paper: "a4", flipped: true, margin: 9mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 7.3pt)
#let ink = rgb("#3d4a45")
#let accent = rgb("#5a7d2a")
#let red = rgb("#b5452f")
#let amber = rgb("#b58a1f")
#let blue = rgb("#2f5f8a")
#let stone = rgb("#c9a86a")
#let stone-l = rgb("#e4d6b8")
#let water = rgb("#bcd9ea")
#let green = rgb("#7fa25a")
#let r2(v) = str(calc.round(v, digits: 2))
#let r3(v) = str(calc.round(v, digits: 3))
#let f2(v) = { let s = str(calc.round(calc.abs(v), digits: 2)); if not s.contains(".") { s + ".00" } else if s.split(".").at(1).len() == 1 { s + "0" } else { s } }
#let lv(v) = if v < 0 { "−" + f2(v) } else { "+" + f2(v) }
#let H(body) = text(9.5pt, weight: "bold", fill: accent, body)

// ---------- the courtyard between finished faces (data/rooms_gf.csv: Courtyard x 4.25–8.95, y 6.5–13.0 on axes; walls 200 mm) ----------
#let C = yaml("../3d/character.yaml").courtyard_layout
#let cx0 = 4.25 + 0.10          // the riwaq glass face
#let cx1 = 8.95 - 0.10          // the kitchen wall's courtyard face
#let cy0 = 6.5 + 0.10           // the women's majlis glass face
#let cy1 = 13.0 - 0.10          // the living's glass face
#let col-x = 5.8                // the colonnade line (B3, C21–C23, the arcade columns)
#let edge = col-x + 0.125       // the soffit's outer edge line = the upturned beam's outer face (the projection's edge seen from below)
#let sleeve = 0.40              // C21 / C22 stone sleeves
#let arc-col = 0.25             // the two arcade columns
#let arc-y = (8.6667, 10.8333)
#let walk-min = col-x - sleeve / 2 - cx0        // the colonnade walkway at C21 / C22
#let walk-arc = col-x - arc-col / 2 - cx0       // at the arcade columns
#let walk-free = edge - cx0                     // between the columns, to the soffit edge
#let open-w = cx1 - edge                        // the open strip east of the colonnade line (the soffit edge to the kitchen wall)
#let open-w-col = cx1 - (col-x + sleeve / 2)    // at C21 / C22
#let court-area = (cx1 - cx0) * (cy1 - cy0)
// the layout (3d/character.yaml courtyard_layout)
#let S = C.step
#let (px0, py0, px1, py1) = S.box
#let pit-w = px1 - px0
#let pit-l = py1 - py0
#let bench-d = C.bench_depth
#let benches = C.benches        // (x0, y0, x1, y1, name)
#let tb = C.table.box
#let gap-north = py0 - C.enclosure.box.at(3)
#let gap-south = cy1 - py1
#let gap-majlis = C.enclosure.box.at(1) - cy0
#let (ex0, ey0, ex1, ey1) = C.enclosure.box
#let wall-t = C.enclosure.wall
#let wb = C.enclosure.water.inside
#let pb = C.enclosure.planter.inside
#let seat-len = benches.map(b => if b.at(4) == "west" { b.at(3) - b.at(1) } else { b.at(2) - b.at(0) }).sum()
#let seats-comfortable = calc.floor(seat-len / 0.9)
#let seats-max = calc.floor(seat-len / 0.6)
#let legroom-ew = (tb.at(0) - benches.find(b => b.at(4) == "west").at(2), cx1 - tb.at(2))
#let legroom-ns = (tb.at(1) - benches.find(b => b.at(4) == "north").at(3), benches.find(b => b.at(4) == "south").at(1) - tb.at(3))
// the TV wall
#let tv = C.tv
#let fr = C.tv_frame
#let tv-c = (tv.y.at(0) + tv.y.at(1)) / 2
#let fr-crown = fr.jamb_z.at(1) + fr.radius
#let sink = (y: (9.1, 11.1), sill: 1.1, head: 2.1)          // the kitchen sink window as drawn (3d/params.yaml)
#let sink-move = C.sink_window_proposal                      // the proposal: y 7.3–8.9 (owner decision, not applied)
#let tv-hits-sink = tv.y.at(0) < sink.y.at(1) and tv.y.at(1) > sink.y.at(0) and tv.z.at(1) > sink.sill
#let frame-hits-sink = fr-crown > sink.sill and tv-c + fr.inner_width / 2 + fr.band > sink.y.at(0)
#let seat-z = S.floor + C.seat_height
#let eye-z = seat-z + 0.70
// the grille (studies/air_system.typ)
#let (gy0, gz0, gy1, gz1) = air-grille
#let grille-ok = gy1 <= tv.y.at(1) and gy0 >= tv.y.at(0) and gz1 <= tv.z.at(0) - 0.1 and gz0 >= S.floor + 0.15 and gy0 >= ey1 + 1.0
// the tree and the light
#let tree = C.enclosure.tree
#let crown-c = ((pb.at(0) + pb.at(2)) / 2, (pb.at(1) + pb.at(3)) / 2)
#let majlis-glass = ((5.1, 5.6), (6.0, 8.1))               // the women's majlis south glass, x ranges (params.yaml), head +2.9
#let crown-x = (crown-c.at(0) - tree.crown_radius, crown-c.at(0) + tree.crown_radius)
#let covered-w = majlis-glass.map(((a, b)) => calc.max(0, calc.min(b, crown-x.at(1)) - calc.max(a, crown-x.at(0)))).sum()
#let glass-w = majlis-glass.map(((a, b)) => b - a).sum()
#let crown-z0 = tree.stem                                   // the crown starts above the clear stem
#let covered-share = covered-w * calc.max(0, 2.9 - crown-z0) / (glass-w * 2.9)
// drainage levels
#let D = C.drainage
// checks
#let checks = (
  ([the seating pit runs from the colonnade edge to the kitchen wall], calc.abs(px0 - edge) < 1e-6 and calc.abs(px1 - cx1) < 1e-6),
  ([4 people comfortable (≥ 0.9 m of bench each)], seats-comfortable >= 4),
  ([leg room ≥ 0.40 m between every bench and the table], calc.min(..legroom-ew, ..legroom-ns) >= 0.40),
  ([a cleaning strip at the living glass (south) ≥ 0.6 m and at the women's majlis glass (north) ≥ 0.5 m], gap-south >= 0.6 - 1e-6 and gap-majlis >= 0.5 - 1e-6),
  ([the grille below the TV, clear of the benches, ≥ 1.0 m from the fountain enclosure, ≥ 0.15 above the pit floor], grille-ok),
  ([the TV's arched frame crown below the sink window's head line and under the first-floor soffit? (the crown must stay below +3.3)], fr-crown < 3.3),
  ([the planting basin ≥ 1.0 × 1.0 inside, 0.65–0.75 deep], pb.at(2) - pb.at(0) >= 1.0 - 1e-6 and pb.at(3) - pb.at(1) >= 1.0 - 1e-6 and 0.65 <= C.enclosure.planter.depth and C.enclosure.planter.depth <= 0.75),
  ([the pit floor falls to its drain and the overflow rim sits above the drain (an independent route)], D.pit_drain < D.pit_edge and D.overflow_rim > D.pit_drain),
  ([the door thresholds ≤ 15 mm (R-08)], D.court_at_glass >= -0.015),
)
#let all-ok = checks.all(c => c.at(1))

// ====================================================================================== PAGE 1 · plan with furniture, dimensions
#text(14pt, weight: "bold", fill: accent)[Courtyard layout · the room open to the sky · Taif / Palm House V7.1]
#v(1pt)
#text(8pt, fill: gray)[Owner decisions 1 Nov 2026 (design review Y-02 / Y-03 / Y-04 / E-03) · clear dimensions between finished faces · the data in `3d/character.yaml` `courtyard_layout` and `studies/air_system.typ` (the grille) · nothing here is for construction]
#v(3pt)
#let plan(length: 1.35cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let q(p) = (p.at(0), -p.at(1))
  let T(p, body, size: 4.6pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, body))
  let R(b, fill: none, stroke: none) = rect(q((b.at(0), b.at(1))), q((b.at(2), b.at(3))), fill: fill, stroke: stroke)
  // the courtyard between its faces, the walls round it
  R((cx0 - 0.2, cy0 - 0.2, cx1 + 0.2, cy1 + 0.2), fill: luma(200))
  R((cx0, cy0, cx1, cy1), fill: stone-l)
  line(q((cx0, cy0)), q((cx0, cy1)), stroke: 2.4pt + blue); line(q((cx0, cy0)), q((cx1, cy0)), stroke: 2.4pt + blue); line(q((cx0, cy1)), q((cx1, cy1)), stroke: 2.4pt + blue)   // glass on three sides
  line(q((cx1, cy0)), q((cx1, cy1)), stroke: 4pt + ink)   // the kitchen wall
  // the sink window as drawn (dashed) and proposed
  line(q((cx1, sink.y.at(0))), q((cx1, sink.y.at(1))), stroke: (paint: red, thickness: 3pt, dash: "dashed")); T((cx1 + 0.12, (sink.y.at(0) + sink.y.at(1)) / 2), [sink window as drawn\ (conflict)], size: 3.8pt, fill: red, anchor: "west")
  line(q((cx1, sink-move.y.at(0))), q((cx1, sink-move.y.at(1))), stroke: 3pt + blue); T((cx1 + 0.12, (sink-move.y.at(0) + sink-move.y.at(1)) / 2), [sink window\ moved north\ (proposal)], size: 3.8pt, fill: blue, anchor: "west")
  // the riwaq door
  line(q((cx0, 9.1)), q((cx0, 10.5)), stroke: 4pt + red); T((cx0 - 0.12, 9.8), [riwaq door 1.40\ (sliding)], size: 3.8pt, fill: red, anchor: "east")
  // the projection's soffit edge and the columns
  line(q((edge, cy0)), q((edge, cy1)), stroke: (paint: ink, thickness: 0.8pt, dash: "dashed"))
  R((cx0, cy0, edge, cy1), fill: rgb("#ece4cf"))
  for y in (6.5, 13.0) { circle(q((col-x, y)), radius: sleeve / 2, fill: stone, stroke: 0.4pt + ink) }
  for y in arc-y { circle(q((col-x, y)), radius: arc-col / 2, fill: stone, stroke: 0.4pt + ink) }
  T((col-x, 7.55), [arcade], size: 3.8pt, angle: 90deg); T(((cx0 + col-x) / 2, 11.6), [colonnade walkway\ level · #r3(walk-free) clear\ (#r3(walk-min) at C21 / C22)], size: 4pt, angle: 90deg)
  // the seating pit
  R(S.box, fill: rgb("#dcd2bb"), stroke: 0.6pt + ink)
  line(q((px0, py0)), q((px0, py1)), stroke: 2.6pt + stone); T((px0 + 0.1, py0 - 0.12), [step −0.15 · stone nosing · riser light], size: 3.8pt, fill: stone.darken(30%), anchor: "west")
  for b in benches { R(b, fill: rgb("#b48a5a"), stroke: 0.4pt + ink); T(((b.at(0) + b.at(2)) / 2, (b.at(1) + b.at(3)) / 2), [bench #b.at(4)\ #r2(bench-d) deep], size: 3.6pt, fill: white, angle: if b.at(4) == "west" { 90deg } else { 0deg }) }
  R(tb, fill: rgb("#fbf4e6"), stroke: 0.5pt + ink); T(((tb.at(0) + tb.at(2)) / 2, (tb.at(1) + tb.at(3)) / 2), [table\ #r2(tb.at(2) - tb.at(0)) × #r2(tb.at(3) - tb.at(1))\ h #r2(C.table.height)], size: 3.8pt)
  // the TV and the grille on the kitchen wall
  R((cx1 - 0.08, tv.y.at(0), cx1, tv.y.at(1)), fill: ink); T((cx1 - 0.3, tv-c), [TV #r2(tv.y.at(1) - tv.y.at(0)) wide · #lv(tv.z.at(0)) … #lv(tv.z.at(1))], size: 3.8pt, fill: ink, angle: 90deg)
  R((cx1 - 0.14, tv-c - fr.inner_width / 2 - fr.band, cx1 - 0.08, tv-c + fr.inner_width / 2 + fr.band), fill: stone)
  R((cx1 - 0.05, gy0, cx1, gy1), fill: rgb("#c8a77e")); T((cx1 + 0.12, (gy0 + gy1) / 2), [malqaf grille\ #lv(gz0) … #lv(gz1)], size: 3.8pt, fill: amber, anchor: "west")
  // the drain and the overflow
  circle(q(D.pit_drain_at), radius: 0.08, fill: white, stroke: 0.6pt + blue); T((D.pit_drain_at.at(0) - 0.15, D.pit_drain_at.at(1)), [drain #lv(D.pit_drain)], size: 3.6pt, fill: blue, anchor: "east")
  circle(q(D.overflow_at), radius: 0.08, fill: white, stroke: 0.6pt + red); T((D.overflow_at.at(0) - 0.15, D.overflow_at.at(1)), [overflow #lv(D.overflow_rim)], size: 3.6pt, fill: red, anchor: "east")
  // the north enclosure: water basin + planter
  R(C.enclosure.box, fill: stone, stroke: 0.5pt + ink)
  R(wb, fill: water, stroke: 0.4pt + ink); T(((wb.at(0) + wb.at(2)) / 2, (wb.at(1) + wb.at(3)) / 2), [water basin\ #r2(wb.at(2) - wb.at(0)) × #r2(wb.at(3) - wb.at(1)) · #r2(C.enclosure.water.depth) deep], size: 3.8pt)
  R(pb, fill: rgb("#8d7a58"), stroke: 0.4pt + ink); circle(q(crown-c), radius: tree.crown_radius, fill: green.transparentize(55%), stroke: (paint: green.darken(20%), dash: "dashed", thickness: 0.5pt))
  T(((pb.at(0) + pb.at(2)) / 2, (pb.at(1) + pb.at(3)) / 2), [tree\ #r2(pb.at(2) - pb.at(0)) × #r2(pb.at(3) - pb.at(1))\ #r2(C.enclosure.planter.depth) deep], size: 3.6pt, fill: white)
  R(C.enclosure.pump_cover, fill: white, stroke: 0.4pt + ink); T(((C.enclosure.pump_cover.at(0) + C.enclosure.pump_cover.at(2)) / 2, C.enclosure.pump_cover.at(1) - 0.12), [pump + filter cover], size: 3.2pt)
  // gaps and dimensions
  let dim(a, b, off, l, col: ink, vert: false) = {
    let p0 = if vert { (a.at(0) + off, a.at(1)) } else { (a.at(0), a.at(1) + off) }; let p1 = if vert { (b.at(0) + off, b.at(1)) } else { (b.at(0), b.at(1) + off) }
    line(q(p0), q(p1), stroke: 0.45pt + col, mark: (start: "|", end: "|", scale: 0.35)); T(((p0.at(0) + p1.at(0)) / 2 + (if vert { 0.14 } else { 0 }), (p0.at(1) + p1.at(1)) / 2 - (if vert { 0 } else { 0.14 })), l, size: 3.8pt, fill: col, angle: if vert { 90deg } else { 0deg })
  }
  dim((cx0, cy0), (cx1, cy0), -0.5, [courtyard #r2(cx1 - cx0) clear])
  dim((edge, cy0), (cx1, cy0), -0.28, [open strip #r3(open-w) clear], col: red)
  dim((cx0, cy1), (edge, cy1), 0.3, [colonnade #r3(walk-free)])
  dim((edge, cy1), (cx1, cy1), 0.3, [pit #r3(pit-w)])
  dim((cx1, cy0), (cx1, cy1), 0.95, [#r2(cy1 - cy0) clear], vert: true)
  dim((cx1, py0), (cx1, py1), 0.7, [pit #r2(pit-l)], vert: true)
  dim((cx1, ey0), (cx1, ey1), 0.7, [enclosure #r2(ey1 - ey0)], vert: true)
  dim((cx1, cy0), (cx1, ey0), 0.7, [#r2(gap-majlis)], vert: true); dim((cx1, ey1), (cx1, py0), 0.7, [#r2(gap-north)], vert: true); dim((cx1, py1), (cx1, cy1), 0.7, [#r2(gap-south)], vert: true)
  T((cx0 - 0.3, cy0 - 0.35), [N ↑ up the page · 1 m = 1.35 cm], size: 4pt, fill: gray, anchor: "west")
})
#grid(columns: (auto, 1fr), gutter: 14pt,
  plan(),
  [
    #H[1 · Circulation and the real clear widths]
    - *Courtyard:* #r2(cx1 - cx0) × #r2(cy1 - cy0) m between the finished faces (#r2(court-area) m²): the riwaq glass face x #r2(cx0), the kitchen wall face x #r2(cx1), the women's majlis glass y #r2(cy0), the living glass y #r2(cy1).
    - *Colonnade walkway* under the projection, level, kept clear: #r3(walk-free) m from the riwaq glass to the soffit edge (x #r3(edge)); #r3(walk-arc) m at the two arcade columns (Ø#r2(arc-col)), #r3(walk-min) m at C21 / C22 (sleeves Ø#r2(sleeve)). The riwaq door (sliding, 1.40) opens onto it; it links the living's glass, the women's majlis glass and the riwaq.
    - *Open strip east of the colonnade:* *#r3(open-w) m* clear from the soffit edge to the kitchen wall (not 3.15 on axes; #r3(open-w-col) m at the C21 / C22 sleeves).
    #v(2pt)
    #H[2 · Seating one step down]
    - *The pit:* from the colonnade edge to the kitchen wall, #r3(pit-w) × #r2(pit-l) m (#r2(pit-w * pit-l) m²), floor #lv(S.floor), *one step* of #r2(-S.floor) (the owner's choice); no walkway round it: the north and south strips are the cleaning strips at the glass (#r2(gap-south) m at the living, #r2(gap-majlis) m at the women's majlis behind the enclosure) and the #r2(gap-north) m between the enclosure and the step.
    - *Benches:* built-in, #r2(bench-d) deep (seat #r2(C.seat_height) above the pit floor = #lv(seat-z), back to #lv(C.bench_back)), stone bases with cushions: west bench #r2(benches.find(b => b.at(4) == "west").at(3) - benches.find(b => b.at(4) == "west").at(1)) m on the step edge facing the TV, with #r2(benches.find(b => b.at(4) == "west").at(1) - py0) m gaps at both ends to step down; north and south benches #r2(benches.find(b => b.at(4) == "north").at(2) - benches.find(b => b.at(4) == "north").at(0)) m from the kitchen wall. Seat length #r2(seat-len) m: *4 comfortable with room to spare (#seats-comfortable places at 0.9 m each, #seats-max at 0.6 m)*; the east side stays free for the TV, the grille and cleaning (#r2(legroom-ew.at(1)) m).
    - *Table:* #r2(tb.at(2) - tb.at(0)) × #r2(tb.at(3) - tb.at(1)) m, #r2(C.table.height) high (meals), leg room #r2(legroom-ew.at(0)) m west, #r2(legroom-ns.at(0)) / #r2(legroom-ns.at(1)) m north / south.
    - *Step safety:* a contrasting honey-stone nosing #r2(S.nosing * 100) cm wide along the whole step edge, a continuous linear light (IP67 LED, warm) in the riser, no loose rugs on the edge; the bench backs (#lv(C.bench_back)) edge the pit on three sides.
    #v(2pt)
    #text(7.5pt)[#if all-ok [*Study checks passed* (#checks.len())] else [*STUDY CHECKS FAILED:* #checks.filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]]
  ],
)

// ====================================================================================== PAGE 2 · the TV wall, the north enclosure
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[3 · The TV wall (the kitchen wall, seen from the seating) · 4 · The north enclosure: water and tree]
#v(2pt)
#let tv-elev(length: 1.1cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, t, size: 4.4pt, fill: ink, anchor: "center", angle: 0deg) = content(p, anchor: anchor, angle: angle, text(size, fill: fill, t))
  // horizontal = y (north left), vertical = level; the wall from the pit floor to the soffit of the projection? no: the kitchen wall rises to the roof; show 0 … +3.4
  rect((cy0, -0.3), (cy1, 3.4), fill: rgb("#f3ece0"), stroke: 0.6pt + ink)
  rect((cy0, S.floor - 0.3), (cy1, S.floor), fill: luma(120), stroke: none)
  rect((py0, S.floor), (py1, 0.0), fill: rgb("#dcd2bb"), stroke: none)   // the pit against the wall
  line((cy0, 0), (py0, 0), stroke: 0.6pt + ink); line((py1, 0), (cy1, 0), stroke: 0.6pt + ink)
  // the enclosure at the north end
  rect((ey0, 0), (ey1, C.enclosure.rim), fill: stone, stroke: 0.4pt + ink); T(((ey0 + ey1) / 2, C.enclosure.rim + 0.15), [enclosure rim #lv(C.enclosure.rim)], size: 3.8pt)
  circle((crown-c.at(1), tree.crown_centre), radius: tree.crown_radius, fill: green.transparentize(50%), stroke: 0.4pt + green.darken(20%)); line((crown-c.at(1), C.enclosure.rim), (crown-c.at(1), tree.crown_centre - tree.crown_radius), stroke: 2pt + rgb("#7a5a3a"))
  T((crown-c.at(1), tree.crown_centre + tree.crown_radius + 0.2), [tree crown Ø#r2(2 * tree.crown_radius)], size: 3.8pt, fill: green.darken(30%))
  // the benches in section (north and south) and the west bench beyond (dashed)
  for b in benches.filter(b => b.at(4) != "west") { rect((b.at(1), S.floor), (b.at(3), seat-z), fill: rgb("#b48a5a"), stroke: 0.3pt + ink); rect((b.at(1), seat-z), (b.at(3), C.bench_back), fill: rgb("#c9a079"), stroke: 0.3pt + ink) }
  // the sink window as drawn (dashed red) and the proposal (blue)
  rect((sink.y.at(0), sink.sill), (sink.y.at(1), sink.head), fill: none, stroke: (paint: red, thickness: 1.2pt, dash: "dashed")); T((sink.y.at(1) - 0.05, sink.head + 0.15), [sink window as drawn: conflict], size: 3.8pt, fill: red, anchor: "east")
  rect((sink-move.y.at(0), sink.sill), (sink-move.y.at(1), sink.head), fill: rgb("#9fcbe0"), stroke: 0.8pt + blue); T(((sink-move.y.at(0) + sink-move.y.at(1)) / 2, sink.head + 0.15), [sink window moved north (proposal)], size: 3.8pt, fill: blue)
  // the TV, its frame, the grille
  let fx0 = tv-c - fr.inner_width / 2
  let fx1 = tv-c + fr.inner_width / 2
  rect((fx0 - fr.band, fr.jamb_z.at(0)), (fx0, fr.jamb_z.at(1)), fill: stone, stroke: 0.3pt + ink); rect((fx1, fr.jamb_z.at(0)), (fx1 + fr.band, fr.jamb_z.at(1)), fill: stone, stroke: 0.3pt + ink)
  rect((fx0 - fr.band, fr.jamb_z.at(0) - fr.band), (fx1 + fr.band, fr.jamb_z.at(0)), fill: stone, stroke: 0.3pt + ink)
  let ro = fr.radius + fr.band
  line(..range(0, 25).map(k => { let a = k / 24 * 180deg; (tv-c + ro * calc.cos(a), fr.jamb_z.at(1) + ro * calc.sin(a)) }), ..range(0, 25).map(k => { let a = 180deg - k / 24 * 180deg; (tv-c + fr.radius * calc.cos(a), fr.jamb_z.at(1) + fr.radius * calc.sin(a)) }), close: true, fill: stone, stroke: 0.3pt + ink)
  rect((tv.y.at(0), tv.z.at(0)), (tv.y.at(1), tv.z.at(1)), fill: ink, stroke: none); T((tv-c, (tv.z.at(0) + tv.z.at(1)) / 2), [outdoor TV #r2(tv.y.at(1) - tv.y.at(0)) × #r2(tv.z.at(1) - tv.z.at(0))], size: 4pt, fill: white)
  rect((gy0, gz0), (gy1, gz1), fill: rgb("#c8a77e"), stroke: 0.4pt + ink); T((tv-c, (gz0 + gz1) / 2), [malqaf grille · louvres down], size: 3.6pt)
  // levels and labels
  for (z, l) in ((S.floor, [pit #lv(S.floor)]), (0, [±0.00]), (seat-z, [seat #lv(seat-z)]), (eye-z, [eye #lv(eye-z)]), (tv.z.at(0), [#lv(tv.z.at(0))]), (tv.z.at(1), [#lv(tv.z.at(1))]), (fr-crown, [crown #lv(fr-crown)])) { T((cy1 + 0.1, z), l, size: 3.6pt, fill: gray, anchor: "west") }
  line((py0 - 0.4, eye-z), (cy1 + 0.0, eye-z), stroke: (paint: gray, thickness: 0.4pt, dash: "dotted"))
  T((cy0, -0.55), [N], size: 4.4pt, anchor: "west"); T((cy1, -0.55), [S], size: 4.4pt, anchor: "east")
  T(((cy0 + cy1) / 2, 3.65), [the kitchen wall from the seating (looking east) · 1 m = 1.1 cm · the frame is a visual surround, no cavity], size: 4.4pt, fill: accent)
})
#tv-elev()
#v(4pt)
#grid(columns: (1fr, 1fr), gutter: 12pt,
  [
    #H[3 · The TV, its frame and the grille]
    - *The TV:* an *outdoor-rated* set (sun, rain and dust: an IP55 / IP56 "partial-sun" outdoor model, 65″ class, ≈ #r2(tv.y.at(1) - tv.y.at(0)) × #r2(tv.z.at(1) - tv.z.at(0)) m; the final size, bracket, ventilation and installation clearances *per the chosen model*), centred on the seating at y #r2(tv-c), bottom #lv(tv.z.at(0)) (#r2(tv.z.at(0) - S.floor) above the pit floor), centre #lv((tv.z.at(0) + tv.z.at(1)) / 2) against a seated eye at #lv(eye-z): the screen sits a little below eye level at #r2(cx1 - benches.find(b => b.at(4) == "west").at(2)) m from the west bench. Power and signal in a sleeved conduit from the kitchen; the fountain switch beside it.
    - *The frame:* honey stone, a visual surround only: two jambs and a semicircular head, band #r2(fr.band) wide, projecting #r2(fr.proj) from the wall, inner width #r2(fr.inner_width) (#r2((fr.inner_width - (tv.y.at(1) - tv.y.at(0))) / 2) each side of the TV), springing #lv(fr.jamb_z.at(1)), crown #lv(fr-crown); no tight cavity: the TV hangs on its bracket #r2(fr.proj) m proud of the wall with the clearances the model asks (air behind and above it).
    - *The grille* (`studies/air_system.typ`): below the TV, y #r2(gy0)–#r2(gy1), #lv(gz0) … #lv(gz1) (#r2(gz0 - S.floor) above the pit floor), low and decorative, removable for cleaning, its louvres turned down so the night air runs along the floor and not into the faces on the benches; #r2(gy0 - ey1) m from the fountain enclosure; no bench or cushion in front of it (the east side of the pit stays free). The chamber under the kitchen floor moves with it to y #r2(air-chamber.at(1))–#r2(air-chamber.at(3)), the duct #r2(air-route.at(1).at(1) - air-route.at(0).at(1)) m long.
    - *The conflict:* the *kitchen sink window* as drawn (y #r2(sink.y.at(0))–#r2(sink.y.at(1)), +#f2(sink.sill) … +#f2(sink.head)) sits exactly where the TV and its frame go: #if tv-hits-sink [the TV overlaps it] else [the TV clears it], #if frame-hits-sink [the arched frame covers it] else [the frame clears it]. *Proposal (owner decision, not applied):* move the sink window north to y #r2(sink-move.y.at(0))–#r2(sink-move.y.at(1)) (#r2(sink-move.y.at(1) - sink-move.y.at(0)) m wide, same sill +#f2(sink.sill)), over the north part of the sink counter (which runs y 7.5–12.9): the sink looks at the fountain and the tree, the solid wall y #r2(sink-move.y.at(1))–#r2(cy1) takes the TV and its frame. The alternative, a smaller TV below the sill without the frame, loses the arch.
  ],
  [
    #H[4 · The north enclosure: one stone box, two basins]
    - *The box:* honey stone, x #r2(ex0)–#r2(ex1), y #r2(ey0)–#r2(ey1) (#r2(ex1 - ex0) × #r2(ey1 - ey0) outside, walls #r2(wall-t), rim at #lv(C.enclosure.rim) = a seat-height ledge), #r2(gap-majlis) m off the women's majlis glass (cleaning), #r2(gap-north) m from the step.
    - *Water basin* (west part): #r2(wb.at(2) - wb.at(0)) × #r2(wb.at(3) - wb.at(1)) inside, #r2(C.enclosure.water.depth) deep, water at #lv(C.enclosure.water.level); a *laminar lip* in honey stone on the divider wall at #lv(C.enclosure.water.spout_z), the water sheeting over stone into the basin (no spray, no mist); its own drain (bottom) and an overflow standpipe at the water level; the pump and the filter in a dry chamber under the access cover (#r2(C.enclosure.pump_cover.at(2) - C.enclosure.pump_cover.at(0)) × #r2(C.enclosure.pump_cover.at(3) - C.enclosure.pump_cover.at(1))) at the west end; a *switch by the TV* turns the fountain off for watching; a GFCI / RCD circuit.
    - *Planting basin* (east part, by the kitchen wall): #r2(pb.at(2) - pb.at(0)) × #r2(pb.at(3) - pb.at(1)) inside, #r2(C.enclosure.planter.depth) m of soil over a drainage layer and its own drain (adjust the depth to the chosen specimen); the basin tanked and separated from the water basin by the #r2(wall-t) divider; drip irrigation on a timer.
    - *The tree:* medium, light canopy, bought at a good size, *fixed*: *Laurus nobilis* trained as a standard, or a clipped *Ficus nitida*; the final choice by a Taif nursery (climate, the winter cold, the irrigation water). Assumed: clear stem #r2(tree.stem) m, crown Ø#r2(2 * tree.crown_radius) centred #r2(tree.crown_centre) m up, kept clipped off the kitchen wall and the glass.
    - *Light check (simple):* the crown stands #r2(crown-c.at(1) - cy0) m from the women's majlis glass and covers #r2(covered-w) m of its #r2(glass-w) m width above +#f2(crown-z0): ≈ #str(calc.round(covered-share * 100)) % of that glass area in shade, the rest and the glass below +#f2(crown-z0) clear; the living's glass is #r2(cy1 - crown-c.at(1)) m away: no shade. *To verify on the V7 3D model* (the sun paths) once the tree's size is chosen.
  ],
)

// ====================================================================================== PAGE 3 · the drainage section, the dimensions table
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[6 · Drainage: the courtyard floor, the seating floor, the thresholds, the overflow and the discharge · section east–west through the seating (y ≈ #r2((py0 + py1) / 2))]
#v(2pt)
#let drain-section(length: 1.3cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, t, size: 4.4pt, fill: ink, anchor: "center", angle: 0deg) = content(p, anchor: anchor, angle: angle, text(size, fill: fill, t))
  let vx = 3.0   // vertical exaggeration
  let Z(z) = z * vx
  let x-a = cx0 - 1.2; let x-b = 13.6
  // the slabs: inside floors ±0.00, the riwaq (west) and the kitchen (east)
  rect((x-a, Z(-0.28)), (cx0 - 0.1, Z(-0.08)), fill: luma(130), stroke: none); rect((x-a, Z(-0.08)), (cx0 - 0.1, Z(0)), fill: luma(200), stroke: none); T((x-a + 0.5, Z(0.12)), [riwaq ±0.00], size: 4pt)
  rect((cx1 + 0.1, Z(-0.28)), (x-b, Z(-0.08)), fill: luma(130), stroke: none); rect((cx1 + 0.1, Z(-0.08)), (x-b, Z(0)), fill: luma(200), stroke: none); T((cx1 + 2.2, Z(0.12)), [kitchen ±0.00], size: 4pt)
  // the walls: the riwaq glass (west) on its plinth, the kitchen wall (east)
  rect((cx0 - 0.1, Z(-0.28)), (cx0, Z(0.8)), fill: luma(170), stroke: none); line((cx0 - 0.05, Z(0.8)), (cx0 - 0.05, Z(1.3)), stroke: 2pt + blue); T((cx0 - 0.2, Z(1.1)), [riwaq glass · plinth to +0.60 · sill frame ±0.00], size: 3.6pt, angle: 90deg, anchor: "south")
  rect((cx1, Z(-0.28)), (cx1 + 0.1, Z(1.3)), fill: luma(170), stroke: none)
  // the courtyard slab (structural) and the finish: the level part (colonnade) and the pit
  rect((cx0, Z(-0.33)), (px0, Z(-0.13)), fill: luma(130), stroke: none)                                    // slab under the colonnade strip (lowered 0.05 for the outdoor build-up)
  rect((px0, Z(S.floor - 0.20 - 0.05)), (cx1, Z(S.floor - 0.05)), fill: luma(130), stroke: none)       // slab under the pit
  rect((px0 - 0.15, Z(S.floor - 0.25)), (px0, Z(D.court_at_edge)), fill: luma(130), stroke: none)       // the step's riser (concrete)
  // the finish, falling: the colonnade from the glass (court_at_glass) to the step edge (court_at_edge); the pit from the edge (pit_edge) to the drain (pit_drain)
  line((cx0, Z(D.court_at_glass)), (px0, Z(D.court_at_edge)), (px0, Z(D.pit_edge)), (D.pit_drain_at.at(0), Z(D.pit_drain)), (cx1, Z(D.pit_drain + 0.005)), stroke: 1.6pt + stone.darken(20%))
  T(((cx0 + px0) / 2, Z(D.court_at_glass) + 0.35), [falls #str(calc.round(D.fall * 100, digits: 1)) % away from the glass], size: 3.6pt)
  T(((px0 + cx1) / 2, Z(D.pit_edge) + 0.35), [pit floor falls #str(calc.round(D.fall * 100, digits: 1)) % to the drain], size: 3.6pt)
  // waterproofing (blue dashed) under the finish, up behind the plinth and the step and the kitchen wall base
  line((cx0 - 0.05, Z(0.15)), (cx0 - 0.05, Z(-0.08)), (cx0, Z(-0.08)), (px0, Z(-0.10)), (px0 - 0.1, Z(-0.10)), (px0 - 0.1, Z(S.floor - 0.05)), (cx1, Z(S.floor - 0.07)), (cx1 + 0.05, Z(S.floor - 0.07)), (cx1 + 0.05, Z(0.15)), stroke: (paint: blue, thickness: 0.9pt, dash: "dashed"))
  T((px0 + 1.0, Z(S.floor - 0.09) - 0.3), [waterproofing membrane under the finish, over the pit as a tray, turned up 0.15 behind the plinths and the wall base], size: 3.4pt, fill: blue)
  // the nosing and the riser light
  rect((px0 - S.nosing, Z(D.court_at_edge)), (px0, Z(D.court_at_edge) + 0.12), fill: stone, stroke: 0.3pt + ink); T((px0 - 0.5, Z(D.court_at_edge) + 0.45), [stone nosing #r2(S.nosing)], size: 3.4pt)
  circle((px0 - 0.03, Z((D.court_at_edge + D.pit_edge) / 2)), radius: 0.06, fill: rgb("#ffe08a"), stroke: 0.3pt + ink); T((px0 - 0.4, Z((D.court_at_edge + D.pit_edge) / 2) - 0.1), [riser light], size: 3.4pt, anchor: "east")
  // the benches in section (the west bench on the step edge, the east strip free)
  let wb_ = benches.find(b => b.at(4) == "west")
  rect((wb_.at(0), Z(S.floor)), (wb_.at(2), Z(seat-z)), fill: rgb("#b48a5a"), stroke: 0.3pt + ink); rect((wb_.at(0) - 0.05, Z(seat-z)), (wb_.at(0) + 0.1, Z(C.bench_back)), fill: rgb("#c9a079"), stroke: 0.3pt + ink)
  T(((wb_.at(0) + wb_.at(2)) / 2, Z(seat-z) + 0.3), [west bench], size: 3.4pt)
  rect((tb.at(0), Z(S.floor)), (tb.at(2), Z(S.floor + C.table.height)), fill: rgb("#fbf4e6"), stroke: 0.3pt + ink); T(((tb.at(0) + tb.at(2)) / 2, Z(S.floor + C.table.height) + 0.3), [table], size: 3.4pt)
  // the drain, the overflow (beyond, at the NE corner: shown dashed) and the pipes to the east
  rect((D.pit_drain_at.at(0) - 0.08, Z(D.pit_drain - 0.12)), (D.pit_drain_at.at(0) + 0.08, Z(D.pit_drain)), fill: white, stroke: 0.6pt + blue)
  line((D.pit_drain_at.at(0), Z(D.pit_drain - 0.12)), (D.pit_drain_at.at(0), Z(D.pipe_z)), (x-b, Z(D.pipe_z - 0.06)), stroke: 1.4pt + blue)
  T((cx1 + 1.6, Z(D.pipe_z) - 0.35), [Ø100 drain, silt bucket, falls 1 % east under the kitchen floor → east yard manhole → the site storm drainage], size: 3.4pt, fill: blue)
  line((D.overflow_at.at(0), Z(D.overflow_rim)), (D.overflow_at.at(0), Z(D.pipe_z + 0.12)), (x-b, Z(D.pipe_z + 0.06)), stroke: (paint: red, thickness: 1.2pt, dash: "dashed"))
  rect((D.overflow_at.at(0) - 0.08, Z(D.overflow_rim - 0.1)), (D.overflow_at.at(0) + 0.08, Z(D.overflow_rim)), fill: white, stroke: 0.6pt + red)
  T((cx1 + 1.6, Z(D.pipe_z) + 0.75), [overflow gully (NE corner, beyond) rim #lv(D.overflow_rim): a separate Ø100 pipe east, never towards the house], size: 3.4pt, fill: red)
  // levels
  for (z, l) in ((0, [±0.00 inside]), (D.court_at_glass, [#lv(D.court_at_glass) at the glass]), (D.court_at_edge, [#lv(D.court_at_edge) step edge]), (D.pit_edge, [#lv(D.pit_edge) pit edge]), (D.pit_drain, [#lv(D.pit_drain) drain]), (D.pipe_z, [#lv(D.pipe_z) pipe invert])) { T((x-a - 0.15, Z(z)), l, size: 3.5pt, fill: gray, anchor: "east") }
  T((x-a, Z(-0.6)), [W · riwaq], size: 4.4pt, anchor: "west"); T((x-b, Z(-0.6)), [E · kitchen → the east yard], size: 4.4pt, anchor: "east")
  T(((x-a + x-b) / 2, Z(1.55)), [section east–west through the seating, looking north · heights × #vx · 1 m = 1.3 cm], size: 4.4pt, fill: accent)
})
#drain-section()
#v(4pt)
#grid(columns: (1.1fr, 1fr), gutter: 12pt,
  [
    #H[The drainage, point by point]
    - *Thresholds:* the inside floors at ±0.00; the courtyard finish at the three glass lines and the riwaq door at *#lv(D.court_at_glass)* (a #r2(-D.court_at_glass * 1000) mm step, within the 15 mm of R-08); the glass sills on a plinth with the membrane turned up 0.15 behind it; a slot drain is not needed: the floor falls away from every door.
    - *Falls:* the colonnade and the north / south strips fall #str(calc.round(D.fall * 100, digits: 1)) % away from the glass to the step edge (#lv(D.court_at_edge)) and to the pit; the pit floor falls #str(calc.round(D.fall * 100, digits: 1)) % from its west edge (#lv(D.pit_edge)) to the *floor drain* at the south-east corner (#lv(D.pit_drain), x #r2(D.pit_drain_at.at(0)), y #r2(D.pit_drain_at.at(1))): a Ø100 gully with a removable grating and a silt bucket, cleanable from the pit.
    - *Overflow, independent:* a second gully at the north-east corner (x #r2(D.overflow_at.at(0)), y #r2(D.overflow_at.at(1))) with its rim at *#lv(D.overflow_rim)*, #r2((D.overflow_rim - D.pit_drain) * 100) cm above the drain and below the step edge (#lv(D.court_at_edge)): if the drain blocks, the pit fills to the overflow and the water leaves by a separate pipe east; it can never reach the glass lines, which stand #r2((D.court_at_glass - D.overflow_rim) * 100) cm higher.
    - *Pipes:* both run east under the kitchen floor (invert #lv(D.pipe_z) at the drain, 1 % fall) across the kitchen (north of the dining door, south of the malqaf chamber) to the east wall and the *east yard manhole*, then to the *site storm drainage* (the plumbing strategy: everything east drains to the east yard; the plumbing study, open item 9, sets the manhole and the outfall). The kitchen's sealed malqaf cover is at y #r2(air-cover.at(1))–#r2(air-cover.at(3)): the pipes pass north and south of the chamber, not through it.
    - *The fountain:* the water basin's bottom drain (#lv(-C.enclosure.water.depth)) and its overflow standpipe (at the water level #lv(C.enclosure.water.level)) join the overflow pipe; the planter's drain (bottom #lv(-C.enclosure.planter.depth)) joins it too, through a gravel layer and a geotextile; the pump chamber has its own small drain. The water basin is filled from a tap in the pump chamber; the fountain runs on a timer and the switch by the TV.
    - *Waterproofing:* one membrane over the whole courtyard slab (lowered 0.05 for the outdoor build-up), over the pit as a tray with the step as an upstand, up 0.15 behind the glass plinths and the kitchen wall base; the enclosure's two basins tanked separately; the finish honey-light stone (slip-resistant outdoors), the step nosing honey stone.
    - *Engineer / MEP to confirm:* the slab recess for the pit (0.15) and the planter (0.75), the gully and pipe sizes, the east yard manhole and the outfall.
  ],
  [
    #H[Dimensions (clear, between finished faces)]
    #table(columns: (1.6fr, auto, 1.6fr), inset: 2.4pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      [*Item*], [*m*], [*Note*],
      [Courtyard clear], [#r2(cx1 - cx0) × #r2(cy1 - cy0)], [#r2(court-area) m²; axes 4.70 × 6.50],
      [Colonnade walkway (level)], [#r3(walk-free) / #r3(walk-arc) / #r3(walk-min)], [to the soffit edge / at the arcade columns / at C21–C22],
      [Open strip east of the colonnade], [*#r3(open-w)*], [the soffit edge x #r3(edge) → the kitchen wall face x #r2(cx1); #r3(open-w-col) at the sleeves],
      [Seating pit], [#r3(pit-w) × #r2(pit-l)], [#r2(pit-w * pit-l) m², floor #lv(S.floor), one step #r2(-S.floor)],
      [Benches], [#r2(bench-d) deep, #r2(seat-len) long], [seat #lv(seat-z), back #lv(C.bench_back); #seats-comfortable comfortable, #seats-max max],
      [Table], [#r2(tb.at(2) - tb.at(0)) × #r2(tb.at(3) - tb.at(1)) × #r2(C.table.height)], [leg room #r2(legroom-ew.at(0)) W, #r2(legroom-ns.at(0)) N, #r2(legroom-ns.at(1)) S; #r2(legroom-ew.at(1)) free to the wall],
      [Cleaning strips], [#r2(gap-south) S · #r2(gap-majlis) N], [at the living glass / behind the enclosure at the women's majlis glass; #r2(gap-north) enclosure → step],
      [Step], [#r2(-S.floor)], [nosing #r2(S.nosing) honey stone, riser light, no rugs],
      [TV], [#r2(tv.y.at(1) - tv.y.at(0)) × #r2(tv.z.at(1) - tv.z.at(0))], [y #r2(tv.y.at(0))–#r2(tv.y.at(1)), #lv(tv.z.at(0)) … #lv(tv.z.at(1)); per the chosen model],
      [TV frame], [#r2(fr.inner_width) inside, band #r2(fr.band)], [springing #lv(fr.jamb_z.at(1)), crown #lv(fr-crown), proud #r2(fr.proj)],
      [Grille], [#r2(gy1 - gy0) × #r2(gz1 - gz0)], [y #r2(gy0)–#r2(gy1), #lv(gz0) … #lv(gz1); #r2(tv.z.at(0) - gz1) below the TV],
      [Enclosure], [#r2(ex1 - ex0) × #r2(ey1 - ey0)], [walls #r2(wall-t), rim #lv(C.enclosure.rim)],
      [Water basin], [#r2(wb.at(2) - wb.at(0)) × #r2(wb.at(3) - wb.at(1)) × #r2(C.enclosure.water.depth)], [water #lv(C.enclosure.water.level), lip #lv(C.enclosure.water.spout_z)],
      [Planting basin], [#r2(pb.at(2) - pb.at(0)) × #r2(pb.at(3) - pb.at(1)) × #r2(C.enclosure.planter.depth)], [tree crown Ø#r2(2 * tree.crown_radius) at #r2(tree.crown_centre) m],
      [Levels], [#lv(D.court_at_glass) / #lv(D.court_at_edge) / #lv(D.pit_edge) / #lv(D.pit_drain)], [glass line / step edge / pit edge / drain; overflow rim #lv(D.overflow_rim); pipe invert #lv(D.pipe_z)],
    )
    #v(2pt)
    #H[Conflicts and decisions]
    - *The kitchen sink window* (page 2): it sits where the TV goes. *Owner decision:* move it north to y #r2(sink-move.y.at(0))–#r2(sink-move.y.at(1)) (recommended) or take a smaller TV below the sill without the frame. Not applied.
    - *The 3D character data* now carry the new layout (`courtyard_layout`); the builder (`character_3d.py`) still draws the old sunken seating, fountain and pergola until it is updated at the next 3D build.
    - *The pergola* is removed from the design (owner): the courtyard enclosure study's note and the character data; the roof keeps its guards.
    - *Children's play* moves to the garden (R-23 / R-30 updated); the courtyard is for sitting, meals and the TV.
  ],
)

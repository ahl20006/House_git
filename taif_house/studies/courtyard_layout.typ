// courtyard_layout.typ · Taif / Palm House V8.2 (work) · COURTYARD LAYOUT STUDY · REVISED 3 Nov 2026 (owner): the whole floor LEVEL (no step anywhere), the built-in benches
// replaced by modern MOVABLE furniture for 4–6 with a low table, the fountain + tree enclosure moved from the north side to the NORTH END OF THE EAST (KITCHEN) WALL in front
// of the kitchen sink window (the view from the sink: two separate basins, the tree in the sunny north part, the raised water rim and the tree visible from the window, sill +1.10),
// the TV and its stone surround on the east wall south of the enclosure with the malqaf grille below it, the north side in front of the women's majlis glass freed, the paths kept,
// linear drains to the SEPARATE rain system. Open to the sky, no pergola. CLEAR dimensions between finished faces. Every size assumed.
// Reads: data/rooms_gf.csv (the courtyard), 3d/character.yaml (`courtyard_layout`: the data the 3D builds), studies/air_system.typ (the grille).
// CSV frame: x east, y south, wall centre lines; levels above the finished ground floor ±0.00.
#import "@preview/cetz:0.4.2"
#import "air_system.typ": air-grille, air-grille-x
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
#let box-overlap(a, b) = a.at(0) < b.at(2) and b.at(0) < a.at(2) and a.at(1) < b.at(3) and b.at(1) < a.at(3)

// ---------- the courtyard between finished faces (data/rooms_gf.csv: x 4.25–8.95, y 6.5–13.0 on axes; walls 200 mm) ----------
#let C = yaml("../3d/character.yaml").courtyard_layout
#let cx0 = 4.25 + 0.10          // the riwaq glass face
#let cx1 = 8.95 - 0.10          // the kitchen wall's courtyard face
#let cy0 = 6.5 + 0.10           // the women's majlis glass face
#let cy1 = 13.0 - 0.10          // the living's glass face
#let col-x = 5.8                // the colonnade line (B3, C21–C23, the arcade columns)
#let edge = col-x + 0.125       // the soffit's outer edge line
#let sleeve = 0.40
#let arc-col = 0.25
#let arc-y = (8.6667, 10.8333)
#let walk-free = edge - cx0
#let walk-min = col-x - sleeve / 2 - cx0
#let court-area = (cx1 - cx0) * (cy1 - cy0)
#let (sx0, sy0, sx1, sy1) = C.seating_zone
#let (ex0, ey0, ex1, ey1) = C.enclosure.box
#let furn = C.furniture
#let seats = furn.map(f => if f.at(4) == "sofa" { 3 } else if f.at(4) == "armchair" { 1 } else { 0 }).sum()
#let zone-area = (sx1 - sx0) * (sy1 - sy0) - (ex1 - ex0) * (ey1 - ey0)       // the level seating zone less the enclosure
#let old-pit = (8.85 - 5.925) * (12.3 - 8.7)                                   // the former sunken seating (V8.0): 2.925 × 3.6
#let gained = zone-area - old-pit
#let tv = C.tv
#let fr = C.tv_frame
#let tv-c = (tv.y.at(0) + tv.y.at(1)) / 2
#let fr-crown = fr.jamb_z.at(1) + fr.radius + fr.band
#let fr-y0 = tv-c - fr.inner_width / 2 - fr.band
#let sink = C.sink_window
#let wb = C.enclosure.water.inside
#let pb = C.enclosure.planter.inside
#let wrim = C.enclosure.water.rim
#let tree = C.enclosure.tree
#let crown-c = ((pb.at(0) + pb.at(2)) / 2, (pb.at(1) + pb.at(3)) / 2)
#let (gy0, gz0, gy1, gz1) = air-grille
#let D = C.drainage
#let eye = (9.55, 1.60)                 // a person at the kitchen sink: 0.6 m behind the wall face, eye +1.60
#let sight(d) = sink.sill - (eye.at(1) - sink.sill) / (eye.at(0) - cx1) * d     // the sight line over the sill, d metres beyond the wall face
#let trough-far = cx1 - wb.at(0)        // the trough's far rim from the wall face
#let gap-majlis = ey0 - cy0
#let gap-south = cy1 - sy1
#let gap-wall = cx1 - calc.max(..furn.map(f => f.at(2)))
// checks
#let fb(f) = (f.at(0), f.at(1), f.at(2), f.at(3))
#let checks = (
  ([the whole floor level: no step (floor #lv(C.floor)); the seating zone runs from the soffit edge to the kitchen wall], C.floor == 0.0 and C.level and calc.abs(sx0 - edge) < 1e-6 and calc.abs(sx1 - cx1) < 1e-6),
  ([movable seating for 4–6 (#seats seats: a sofa, two armchairs) with a low table, every piece inside the seating zone and clear of the enclosure, not overlapping], seats >= 4 and seats <= 6 and furn.all(f => f.at(0) >= sx0 - 1e-6 and f.at(2) <= sx1 + 1e-6 and f.at(1) >= sy0 - 1e-6 and f.at(3) <= sy1 + 1e-6 and not box-overlap(fb(f), C.enclosure.box)) and range(furn.len()).all(i => range(i + 1, furn.len()).all(j => not box-overlap(fb(furn.at(i)), fb(furn.at(j)))))),
  ([the paths free: the colonnade walkway (#r3(walk-free) m, nothing west of the soffit edge), the cleaning strips at the living glass ≥ 0.6 (#r2(gap-south)) and at the women's majlis glass ≥ 0.5 (#r2(gap-majlis)), ≥ 0.6 at the kitchen wall in front of the grille (#r2(gap-wall))], furn.all(f => f.at(0) >= edge - 1e-6) and gap-south >= 0.6 - 1e-6 and gap-majlis >= 0.5 - 1e-6 and gap-wall >= 0.6 - 1e-6),
  ([the enclosure on the kitchen wall in front of the sink window (y #r2(sink.y.at(0))–#r2(sink.y.at(1)) inside y #r2(ey0)–#r2(ey1)); the tree in its north part], calc.abs(ex1 - cx1) < 1e-6 and ey0 <= sink.y.at(0) + 1e-6 and ey1 >= sink.y.at(1) - 1e-6 and pb.at(3) <= wb.at(1)),
  ([the water rim #lv(wrim) below the sill #lv(sink.sill) and above the sight line from the sink at its far edge (#lv(sight(trough-far)) at #r2(trough-far) m): the rim and the water seen from the sink; the tree crown in the window's view (crown centre #lv(tree.crown_centre) above the head #lv(sink.head))], wrim < sink.sill and wrim > sight(trough-far) and tree.crown_centre + tree.crown_radius > sink.head),
  ([the planting basin ≥ 1.0 × 1.0 inside, 0.65–0.75 deep], pb.at(2) - pb.at(0) >= 1.0 - 1e-6 and pb.at(3) - pb.at(1) >= 1.0 - 1e-6 and 0.65 <= C.enclosure.planter.depth and C.enclosure.planter.depth <= 0.75),
  ([the TV south of the enclosure (#r2(tv.y.at(0) - ey1) m), its frame ≥ 0.5 m from the sink window (#r2(fr-y0 - sink.y.at(1))), its crown under the soffit (+3.3)], tv.y.at(0) >= ey1 and fr-y0 - sink.y.at(1) >= 0.5 - 1e-6 and fr-crown < 3.3),
  ([the grille below the TV, inside its width, its bottom #lv(gz0) ≥ 0.10 above the level floor, clear of the furniture (#r2(gap-wall) m in front)], gz1 <= tv.z.at(0) - 0.1 + 1e-6 and gy0 >= tv.y.at(0) and gy1 <= tv.y.at(1) and gz0 >= 0.10 - 1e-6 and gap-wall >= 0.6 - 1e-6),
  ([drainage: the floor #lv(D.court_at_glass) at the glass (≤ 15 mm, R-08) falling to #lv(D.court_at_wall) at the kitchen wall foot; two linear drains; the overflow rim #lv(D.overflow_rim) between the drain level and the glass level; everything to the separate rain system], D.court_at_glass >= -0.015 and D.court_at_wall < D.court_at_glass and D.linear_drains.len() >= 2 and D.overflow_rim > D.court_at_wall and D.overflow_rim < D.court_at_glass),
)
#let all-ok = checks.all(c => c.at(1))

// ====================================================================== PAGE 1 · plan, the furniture, the enclosure, the area gained
#text(14pt, weight: "bold", fill: accent)[Courtyard layout · REVISED 3 Nov 2026 · a level floor, movable furniture, the enclosure on the kitchen wall in front of the sink window · Taif / Palm House V8.2]
#v(1pt)
#text(8pt, fill: gray)[Owner decisions 3 Nov 2026 (the V8.0 layout of 1 Nov 2026 revised: no step, no built-in benches, the enclosure moved east, the TV moved south) · clear dimensions between finished faces · the data in `3d/character.yaml` `courtyard_layout` (built in the 3D) and `studies/air_system.typ` (the grille) · every size assumed; nothing here is for construction]
#v(3pt)
#let plan(length: 1.35cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let q(p) = (p.at(0), -p.at(1))
  let T(p, body, size: 4.6pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, body))
  let R(b, fill: none, stroke: none) = rect(q((b.at(0), b.at(1))), q((b.at(2), b.at(3))), fill: fill, stroke: stroke)
  R((cx0 - 0.2, cy0 - 0.2, cx1 + 0.2, cy1 + 0.2), fill: luma(200))
  R((cx0, cy0, cx1, cy1), fill: stone-l)
  line(q((cx0, cy0)), q((cx0, cy1)), stroke: 2.4pt + blue); line(q((cx0, cy0)), q((cx1, cy0)), stroke: 2.4pt + blue); line(q((cx0, cy1)), q((cx1, cy1)), stroke: 2.4pt + blue)
  line(q((cx1, cy0)), q((cx1, cy1)), stroke: 4pt + ink)
  line(q((cx1, sink.y.at(0))), q((cx1, sink.y.at(1))), stroke: 3pt + blue); T((cx1 + 0.12, (sink.y.at(0) + sink.y.at(1)) / 2), [sink window\ y #r2(sink.y.at(0))–#r2(sink.y.at(1))\ sill +#f2(sink.sill)\ (the sink behind it)], size: 3.8pt, fill: blue, anchor: "west")
  line(q((cx0, 9.1)), q((cx0, 10.5)), stroke: 4pt + red); T((cx0 - 0.12, 9.8), [riwaq door 1.40\ (sliding)], size: 3.8pt, fill: red, anchor: "east")
  line(q((edge, cy0)), q((edge, cy1)), stroke: (paint: ink, thickness: 0.8pt, dash: "dashed"))
  R((cx0, cy0, edge, cy1), fill: rgb("#ece4cf"))
  for y in (6.5, 13.0) { circle(q((col-x, y)), radius: sleeve / 2, fill: stone, stroke: 0.4pt + ink) }
  for y in arc-y { circle(q((col-x, y)), radius: arc-col / 2, fill: stone, stroke: 0.4pt + ink) }
  T((col-x, 7.55), [arcade], size: 3.8pt, angle: 90deg); T(((cx0 + col-x) / 2, 11.6), [colonnade walkway\ #r3(walk-free) clear (#r3(walk-min) at C21 / C22)\ LEVEL with the whole floor], size: 4pt, angle: 90deg)
  // the seating zone (level) and the movable furniture
  R(C.seating_zone, fill: rgb("#e9dfc8"), stroke: (paint: amber, thickness: 0.6pt, dash: "dashed")); T((sx0 + 0.1, sy1 - 0.12), [seating zone · level · #r2(zone-area) m² free (the enclosure deducted)], size: 3.6pt, fill: amber, anchor: "west")
  for f in furn { R(fb(f), fill: if f.at(4) == "table" { rgb("#fbf4e6") } else { rgb("#b48a5a") }, stroke: 0.4pt + ink); T(((f.at(0) + f.at(2)) / 2, (f.at(1) + f.at(3)) / 2), [#f.at(4)], size: 3.6pt, fill: if f.at(4) == "table" { ink } else { white }, angle: if f.at(4) == "sofa" { 90deg } else { 0deg }) }
  T((6.4, 9.3), [movable: faces the TV], size: 3.4pt, fill: luma(90))
  // the TV and the grille on the kitchen wall
  R((cx1 - 0.08, tv.y.at(0), cx1, tv.y.at(1)), fill: ink); T((cx1 - 0.3, tv-c), [TV #r2(tv.y.at(1) - tv.y.at(0)) wide · #lv(tv.z.at(0)) … #lv(tv.z.at(1))], size: 3.8pt, fill: ink, angle: 90deg)
  R((cx1 - 0.14, fr-y0, cx1 - 0.08, tv-c + fr.inner_width / 2 + fr.band), fill: stone)
  R((cx1 - 0.05, gy0, cx1, gy1), fill: rgb("#c8a77e")); T((cx1 + 0.12, (gy0 + gy1) / 2), [malqaf grille\ #lv(gz0) … #lv(gz1)], size: 3.8pt, fill: amber, anchor: "west")
  // the enclosure on the kitchen wall
  R(C.enclosure.box, fill: stone, stroke: 0.5pt + ink)
  R(pb, fill: rgb("#8d7a58"), stroke: 0.4pt + ink); circle(q(crown-c), radius: tree.crown_radius, fill: green.transparentize(55%), stroke: (paint: green.darken(20%), dash: "dashed", thickness: 0.5pt))
  T(((pb.at(0) + pb.at(2)) / 2, (pb.at(1) + pb.at(3)) / 2), [tree (north, sunny)\ #r2(pb.at(2) - pb.at(0)) × #r2(pb.at(3) - pb.at(1)) · #r2(C.enclosure.planter.depth) deep\ rim #lv(C.enclosure.rim)], size: 3.5pt, fill: white)
  R(wb, fill: water, stroke: 0.4pt + ink); T(((wb.at(0) + wb.at(2)) / 2, (wb.at(1) + wb.at(3)) / 2), [raised water trough\ #r2(wb.at(2) - wb.at(0)) × #r2(wb.at(3) - wb.at(1)) · rim #lv(wrim)\ water #lv(C.enclosure.water.level)], size: 3.5pt)
  R(C.enclosure.pump_cover, fill: white, stroke: 0.4pt + ink); T((C.enclosure.pump_cover.at(0) - 0.1, (C.enclosure.pump_cover.at(1) + C.enclosure.pump_cover.at(3)) / 2), [pump], size: 3.2pt, anchor: "east")
  // the drains
  for d in D.linear_drains { R(d, fill: rgb("#8a9aa8"), stroke: 0.3pt + ink) }
  T((cx1 - 0.3, 12.55), [linear drain #lv(D.court_at_wall)], size: 3.4pt, fill: blue, anchor: "east"); T((cx0 + 0.2, 10.75), [slot drain at the door], size: 3.2pt, fill: blue, anchor: "west")
  circle(q(D.overflow_at), radius: 0.08, fill: white, stroke: 0.6pt + red); T((D.overflow_at.at(0) - 0.15, D.overflow_at.at(1) + 0.18), [overflow #lv(D.overflow_rim)], size: 3.4pt, fill: red, anchor: "east")
  // dimensions
  let dim(a, b, off, l, col: ink, vert: false) = {
    let p0 = if vert { (a.at(0) + off, a.at(1)) } else { (a.at(0), a.at(1) + off) }; let p1 = if vert { (b.at(0) + off, b.at(1)) } else { (b.at(0), b.at(1) + off) }
    line(q(p0), q(p1), stroke: 0.45pt + col, mark: (start: "|", end: "|", scale: 0.35)); T(((p0.at(0) + p1.at(0)) / 2 + (if vert { 0.14 } else { 0 }), (p0.at(1) + p1.at(1)) / 2 - (if vert { 0 } else { 0.14 })), l, size: 3.8pt, fill: col, angle: if vert { 90deg } else { 0deg })
  }
  dim((cx0, cy0), (cx1, cy0), -0.5, [courtyard #r2(cx1 - cx0) clear · level])
  dim((edge, cy1), (cx1, cy1), 0.3, [seating zone #r3(sx1 - sx0)])
  dim((cx1, cy0), (cx1, ey0), 0.95, [#r2(gap-majlis)], vert: true); dim((cx1, ey0), (cx1, ey1), 0.95, [enclosure #r2(ey1 - ey0)], vert: true); dim((cx1, ey1), (cx1, sy1), 0.95, [seating #r2(sy1 - ey1)], vert: true); dim((cx1, sy1), (cx1, cy1), 0.95, [#r2(gap-south)], vert: true)
  T((cx0 - 0.3, cy0 - 0.35), [N ↑ up the page · 1 m = 1.35 cm], size: 4pt, fill: gray, anchor: "west")
})
#grid(columns: (auto, 1fr), gutter: 14pt,
  plan(),
  [
    #H[1 · The level floor and the paths]
    - *Courtyard:* #r2(cx1 - cx0) × #r2(cy1 - cy0) m between the finished faces (#r2(court-area) m²), *the whole floor LEVEL* (owner, 3 Nov 2026: no step anywhere; the V8.0 sunken seating is withdrawn): the colonnade walkway (#r3(walk-free) m clear to the soffit edge, #r3(walk-min) at C21 / C22), the seating zone and the three cleaning strips at the glass are one surface with gentle falls (page 2). Honey-light stone, slip-resistant, no nosing, no riser light.
    - *Paths kept free:* the colonnade walkway (nothing west of the soffit edge x #r3(edge)); the riwaq door (sliding 1.40) and the living's glass (a #r2(gap-south) m strip); the women's majlis glass (a #r2(gap-majlis) m strip, *the north side freed*: nothing stands in front of the majlis glass any more); cleaning access along the kitchen wall between the enclosure and the chairs (#r2(gap-wall) m in front of the grille).
    #v(2pt)
    #H[2 · Movable furniture for 4–6, facing the TV]
    - *Modern movable pieces* (the owner chooses them): a *3-seat sofa* #r2(furn.at(0).at(3) - furn.at(0).at(1)) × #r2(furn.at(0).at(2) - furn.at(0).at(0)) with its back to the colonnade edge facing the TV on the east wall, *two armchairs* beside the low *table* #r2(furn.at(3).at(2) - furn.at(3).at(0)) × #r2(furn.at(3).at(3) - furn.at(3).at(1)) (meals, coffee): *#seats seats*, 6 with two stools; everything can be moved for a big meal or cleaning. Outdoor-rated fabrics, cushions stored in the hospitality kitchen's cupboard.
    - *Seating area gained:* the level zone east of the soffit edge from the north strip to the south strip is #r2((sx1 - sx0) * (sy1 - sy0)) m²; less the enclosure (#r2((ex1 - ex0) * (ey1 - ey0)) m²) *#r2(zone-area) m² free*, against #r2(old-pit) m² in the sunken pit: *+#r2(gained) m² (+#str(calc.round(gained / old-pit * 100)) %)*; and the colonnade strip (#r2(walk-free * (cy1 - cy0)) m²) is now at the same level, so the whole #r2(court-area) m² floor is one usable surface.
    #v(2pt)
    #H[3 · The enclosure on the kitchen wall: the view from the sink]
    - *One honey-stone box against the kitchen wall* x #r2(ex0)–#r2(ex1), y #r2(ey0)–#r2(ey1) (#r2(ex1 - ex0) × #r2(ey1 - ey0) outside, walls #r2(C.enclosure.wall)), *directly in front of the sink window* (y #r2(sink.y.at(0))–#r2(sink.y.at(1)), sill +#f2(sink.sill)); #r2(gap-majlis) m off the women's majlis glass.
    - *The planting basin (north, sunny part):* #r2(pb.at(2) - pb.at(0)) × #r2(pb.at(3) - pb.at(1)) inside, #r2(C.enclosure.planter.depth) deep, rim #lv(C.enclosure.rim) (a ledge); the tree (*Laurus nobilis* standard or clipped *Ficus nitida*, a Taif nursery decides), stem #r2(tree.stem), crown Ø#r2(2 * tree.crown_radius) centred #r2(tree.crown_centre) m: its crown fills the window's view (head +#f2(sink.head)) and shades the north part of the wall.
    - *The water (south part): a RAISED trough* #r2(wb.at(2) - wb.at(0)) × #r2(wb.at(3) - wb.at(1)) inside, rim *#lv(wrim)* (below the sill +#f2(sink.sill)), water #lv(C.enclosure.water.level), a laminar lip in honey stone on the wall side at #lv(C.enclosure.water.spout_z) (no spray); *seen from the sink:* the sight line of a person at the sink (eye +1.60, 0.6 m behind the wall) passes the sill and reaches #lv(sight(trough-far)) at the trough's far rim (#r2(trough-far) m out): the rim, the water and the lip are in view, the tree beside them. The pump and filter chamber in the divider between the two basins (cover at the rim); both basins tanked separately, each with its own drain to the rain system.
    #v(2pt)
    #text(7.5pt)[#if all-ok [*Study checks passed* (#checks.len())] else [*STUDY CHECKS FAILED:* #checks.filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]]
  ],
)

// ====================================================================== PAGE 2 · the kitchen wall from the seating, the drainage, the dimensions
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[4 · The kitchen wall from the seating (the enclosure, the TV, the grille) · 5 · Drainage on a level floor · 6 · Dimensions]
#v(2pt)
#let tv-elev(length: 1.1cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, t, size: 4.4pt, fill: ink, anchor: "center", angle: 0deg) = content(p, anchor: anchor, angle: angle, text(size, fill: fill, t))
  rect((cy0, -0.3), (cy1, 3.4), fill: rgb("#f3ece0"), stroke: 0.6pt + ink)
  rect((cy0, -0.3), (cy1, 0.0), fill: luma(120), stroke: none)
  line((cy0, 0), (cy1, 0), stroke: 0.6pt + ink); T((cy1 + 0.1, 0), [±0.00 level floor], size: 3.6pt, fill: gray, anchor: "west")
  // the enclosure: the planter (north) rim +0.45, the raised trough (south) rim +0.95; the tree
  rect((ey0, 0), (pb.at(3) + C.enclosure.wall, C.enclosure.rim), fill: stone, stroke: 0.4pt + ink); T(((ey0 + pb.at(3)) / 2, C.enclosure.rim + 0.15), [planter rim #lv(C.enclosure.rim)], size: 3.6pt)
  rect((wb.at(1) - C.enclosure.wall, 0), (ey1, wrim), fill: stone, stroke: 0.4pt + ink); rect((wb.at(1), wrim - 0.1), (wb.at(3), C.enclosure.water.level), fill: water, stroke: none); T(((wb.at(1) + wb.at(3)) / 2, wrim + 0.15), [trough rim #lv(wrim) · water #lv(C.enclosure.water.level)], size: 3.6pt)
  circle((crown-c.at(1), tree.crown_centre), radius: tree.crown_radius, fill: green.transparentize(50%), stroke: 0.4pt + green.darken(20%)); line((crown-c.at(1), C.enclosure.rim), (crown-c.at(1), tree.crown_centre - tree.crown_radius), stroke: 2pt + rgb("#7a5a3a"))
  // the sink window behind the enclosure (on the wall)
  rect((sink.y.at(0), sink.sill), (sink.y.at(1), sink.head), fill: rgb("#9fcbe0").transparentize(30%), stroke: 0.8pt + blue); T(((sink.y.at(0) + sink.y.at(1)) / 2, sink.head + 0.15), [sink window y #r2(sink.y.at(0))–#r2(sink.y.at(1)) · +#f2(sink.sill) … +#f2(sink.head) · the tree and the trough in its view], size: 3.8pt, fill: blue)
  // the TV, its frame, the grille
  let fx0 = tv-c - fr.inner_width / 2; let fx1 = tv-c + fr.inner_width / 2
  rect((fx0 - fr.band, fr.jamb_z.at(0)), (fx0, fr.jamb_z.at(1)), fill: stone, stroke: 0.3pt + ink); rect((fx1, fr.jamb_z.at(0)), (fx1 + fr.band, fr.jamb_z.at(1)), fill: stone, stroke: 0.3pt + ink)
  rect((fx0 - fr.band, fr.jamb_z.at(0) - fr.band), (fx1 + fr.band, fr.jamb_z.at(0)), fill: stone, stroke: 0.3pt + ink)
  let ro = fr.radius + fr.band
  line(..range(0, 25).map(k => { let a = k / 24 * 180deg; (tv-c + ro * calc.cos(a), fr.jamb_z.at(1) + ro * calc.sin(a)) }), ..range(0, 25).map(k => { let a = 180deg - k / 24 * 180deg; (tv-c + fr.radius * calc.cos(a), fr.jamb_z.at(1) + fr.radius * calc.sin(a)) }), close: true, fill: stone, stroke: 0.3pt + ink)
  rect((tv.y.at(0), tv.z.at(0)), (tv.y.at(1), tv.z.at(1)), fill: ink, stroke: none); T((tv-c, (tv.z.at(0) + tv.z.at(1)) / 2), [outdoor TV #r2(tv.y.at(1) - tv.y.at(0)) × #r2(tv.z.at(1) - tv.z.at(0))], size: 4pt, fill: white)
  rect((gy0, gz0), (gy1, gz1), fill: rgb("#c8a77e"), stroke: 0.4pt + ink); T((tv-c, (gz0 + gz1) / 2), [malqaf grille · louvres down · bottom #lv(gz0)], size: 3.4pt)
  // the sofa in section (beyond), the seated eye
  rect((furn.at(0).at(1), 0), (furn.at(0).at(3), 0.42), fill: rgb("#b48a5a").transparentize(40%), stroke: (paint: ink, thickness: 0.3pt, dash: "dashed")); T(((furn.at(0).at(1) + furn.at(0).at(3)) / 2, 0.6), [sofa (beyond) · seat +0.42 · eye ≈ +1.15], size: 3.4pt, fill: luma(90))
  line((cy0, 1.15), (cy1, 1.15), stroke: (paint: gray, thickness: 0.4pt, dash: "dotted"))
  for (z, l) in ((tv.z.at(0), [#lv(tv.z.at(0))]), (tv.z.at(1), [#lv(tv.z.at(1))]), (fr-crown, [crown #lv(fr-crown)]), (1.15, [eye #lv(1.15)])) { T((cy1 + 0.1, z), l, size: 3.6pt, fill: gray, anchor: "west") }
  T((cy0, -0.55), [N], size: 4.4pt, anchor: "west"); T((cy1, -0.55), [S], size: 4.4pt, anchor: "east")
  T(((cy0 + cy1) / 2, 3.65), [the kitchen wall from the seating (looking east) · 1 m = 1.1 cm · the frame is a visual surround, no cavity], size: 4.4pt, fill: accent)
})
#tv-elev()
#v(4pt)
#grid(columns: (1.1fr, 1fr), gutter: 12pt,
  [
    #H[4 · The TV, its frame and the grille]
    - *The TV:* an *outdoor-rated* set (65″ class, ≈ #r2(tv.y.at(1) - tv.y.at(0)) × #r2(tv.z.at(1) - tv.z.at(0)) m; the final size, bracket, ventilation and clearances *per the chosen model*), *moved south along the kitchen wall* to y #r2(tv.y.at(0))–#r2(tv.y.at(1)) (centre y #r2(tv-c), #r2(tv.y.at(0) - ey1) m south of the enclosure), bottom #lv(tv.z.at(0)), top #lv(tv.z.at(1)): the centre at +#f2((tv.z.at(0) + tv.z.at(1)) / 2) for a seated eye ≈ +1.15 on a sofa at 2.0–2.5 m.
    - *The frame:* honey stone, a visual surround only (jambs and a semicircular head, band #r2(fr.band), proud #r2(fr.proj), inner width #r2(fr.inner_width), springing #lv(fr.jamb_z.at(1)), crown #lv(fr-crown)); #r2(fr-y0 - sink.y.at(1)) m of solid wall between the sink window and the frame.
    - *The grille* (`studies/air_system.typ`): below the TV, y #r2(gy0)–#r2(gy1), #lv(gz0) … #lv(gz1): its *bottom #r2(gz0) m above the level floor* (not in a pit any more), #r2(tv.z.at(0) - gz1) m under the TV, #r2(gap-wall) m of free floor in front of it (the chairs stand west of x #r2(calc.max(..furn.map(f => f.at(2))))), the louvre sending the breeze along the floor to the seating; removable for cleaning.
    #v(2pt)
    #H[5 · Drainage on a level floor]
    - *Falls:* the inside floors ±0.00; the courtyard finish at the three glass lines and the riwaq door at *#lv(D.court_at_glass)* (a #r2(-D.court_at_glass * 1000) mm threshold, R-08), falling *#str(calc.round(D.fall * 100, digits: 1)) % away from the glass* across the floor to the kitchen wall foot at *#lv(D.court_at_wall)*: no step, a 45 mm difference over the width that nobody feels.
    - *Linear drains:* a slot drain with a silt basket *along the kitchen wall foot* south of the enclosure (y #r2(D.linear_drains.at(0).at(1))–#r2(D.linear_drains.at(0).at(3)), under the TV) takes the whole floor; a short slot drain *at the riwaq door's threshold* (wind-driven rain at the door); the enclosure's two basins drain into the wall-foot drain's pipe. *Overflow route:* a second gully at the south-east corner with its rim at *#lv(D.overflow_rim)* (#r2((D.overflow_rim - D.court_at_wall) * 100) cm above the drain level, #r2((D.court_at_glass - D.overflow_rim) * 100) cm below the glass level) on its own pipe: if the drains block, the water leaves before it reaches the glass. *Trap primers* on the drains (rarely used in a dry season).
    - *Pipes:* east under the kitchen floor (invert #lv(D.pipe_z) at the drains, 1 % fall) to the *east RAIN chamber* in the yard and the soakaway (`studies/site_plan.typ`, `studies/plumbing.typ`): *never into the foul system*. *Waterproofing:* one membrane over the whole courtyard slab (lowered 0.05 for the outdoor build-up), up 0.15 behind the glass plinths and the kitchen wall base; the enclosure's two basins tanked separately.
    - *Engineer / MEP to confirm:* the slab recess for the planter (0.75), the drain and pipe sizes, the rain chamber and the soakaway.
  ],
  [
    #H[6 · Dimensions (clear, between finished faces)]
    #table(columns: (1.6fr, auto, 1.6fr), inset: 2.4pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      [*Item*], [*m*], [*Note*],
      [Courtyard clear, level], [#r2(cx1 - cx0) × #r2(cy1 - cy0)], [#r2(court-area) m²; axes 4.70 × 6.50; no step],
      [Colonnade walkway], [#r3(walk-free) / #r3(walk-min)], [to the soffit edge / at C21–C22; kept free],
      [Seating zone (level)], [#r3(sx1 - sx0) × #r2(sy1 - sy0)], [#r2(zone-area) m² free of the enclosure; was #r2(old-pit) m² in the pit: *+#r2(gained) m²*],
      [Furniture], [#seats seats], [a 3-seat sofa, two armchairs, a low table #r2(furn.at(3).at(2) - furn.at(3).at(0)) × #r2(furn.at(3).at(3) - furn.at(3).at(1)); all movable],
      [Cleaning strips], [#r2(gap-south) S · #r2(gap-majlis) N · #r2(gap-wall) E], [at the living glass / the women's majlis glass / the kitchen wall in front of the grille],
      [Enclosure], [#r2(ex1 - ex0) × #r2(ey1 - ey0)], [on the kitchen wall, y #r2(ey0)–#r2(ey1), in front of the sink window; walls #r2(C.enclosure.wall)],
      [Planting basin (north)], [#r2(pb.at(2) - pb.at(0)) × #r2(pb.at(3) - pb.at(1)) × #r2(C.enclosure.planter.depth)], [rim #lv(C.enclosure.rim); tree crown Ø#r2(2 * tree.crown_radius) at #r2(tree.crown_centre) m],
      [Water trough (south, raised)], [#r2(wb.at(2) - wb.at(0)) × #r2(wb.at(3) - wb.at(1)) × #r2(C.enclosure.water.depth)], [rim #lv(wrim), water #lv(C.enclosure.water.level), lip #lv(C.enclosure.water.spout_z); seen from the sink (sill +#f2(sink.sill))],
      [TV], [#r2(tv.y.at(1) - tv.y.at(0)) × #r2(tv.z.at(1) - tv.z.at(0))], [y #r2(tv.y.at(0))–#r2(tv.y.at(1)), #lv(tv.z.at(0)) … #lv(tv.z.at(1)); per the chosen model],
      [TV frame], [#r2(fr.inner_width) inside, band #r2(fr.band)], [springing #lv(fr.jamb_z.at(1)), crown #lv(fr-crown), proud #r2(fr.proj); #r2(fr-y0 - sink.y.at(1)) from the window],
      [Grille], [#r2(gy1 - gy0) × #r2(gz1 - gz0)], [y #r2(gy0)–#r2(gy1), #lv(gz0) … #lv(gz1); bottom #r2(gz0) above the floor; #r2(tv.z.at(0) - gz1) below the TV],
      [Levels], [#lv(D.court_at_glass) / #lv(D.court_at_wall)], [the glass lines / the kitchen wall foot; overflow rim #lv(D.overflow_rim); pipe invert #lv(D.pipe_z)],
    )
    #v(2pt)
    #H[What changed on 3 Nov 2026 (owner) and where]
    - The step, the nosing, the riser light and the three built-in benches are *removed*; the floor is level; the furniture is movable. The enclosure left the north side (the women's majlis glass is free) for the kitchen wall in front of the sink window; the TV and its surround moved #r2(tv.y.at(0) - 9.77) m south, the grille with them (`studies/air_system.typ`). The data: `3d/character.yaml` `courtyard_layout` (built in the 3D: `character_3d.py`, checked in `check_3d.py`); the plan marks in `design_gf.typ`; the drains in `studies/plumbing.typ` (the rain system).
    #text(6pt, fill: gray)[The #checks.len() checks are listed with their pass line on page 1. Every size assumed; the owner chooses the furniture; the engineer and the MEP engineer confirm the recess, the drains and the pipes.]
  ],
)

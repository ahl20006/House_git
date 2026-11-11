// courtyard_layout.typ · Taif / Palm House V10.0 · COURTYARD LAYOUT · H2 ADOPTED (the owner, 10 Nov 2026, from studies/courtyard_haven.typ Phase 4): the breeze over the water:
// the malqaf outlet raised to +0.60…+1.60, centred in the first arcade bay (y 6.9–8.3) with its louvres fixed 35° to the south-east (studies/malqaf_outlet_B.typ adopted at 30°; turned to 35° by the owner on 11 Nov 2026 so that almost the whole jet crosses the trough);
// the olive in a fixed Ø 1.0 pot IN FRONT OF THE KITCHEN SINK WINDOW (the owner's change on apply, 10 Nov 2026: seen from the sink); the water a trough 2.1 × 0.95 along the kitchen
// wall south of it, as far from the olive's crown as the jet's path allows, its spout at the seats' end and its skimmer at the olive's end; five seats with backs (a 3-seat sofa facing
// the water, two armchairs facing the olive, a low table); no TV; the living's glass fixed (the riwaq's sliding door the only door);
// a curtain inside the women's majlis; the lighting and the floor pattern. The whole floor LEVEL, movable furniture, linear drains to the SEPARATE rain system; open to the sky.
// History: V8.0 (1 Nov 2026) the sunken seating; REVISED 3 Nov 2026 (the level floor, the enclosure on the kitchen wall); 10 Nov 2026 no TV, the core's face straight; H2 the same day.
// Reads: data/rooms_gf.csv (the courtyard), 3d/character.yaml (`courtyard_layout`: the seating zone, the sink window, the drainage; its enclosure / furniture / tv data are
// SUPERSEDED by this file until the next release), studies/air_system.typ (the outlet). CSV frame: x east, y south, wall centre lines; levels above the finished ground floor ±0.00.
#import "@preview/cetz:0.4.2"
#import "air_system.typ": air-outlet, louvre-free, outlet-free, mean-eve, v-out
#set page(paper: "a4", flipped: true, margin: 9mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 7.3pt)
#let ink = rgb("#3d4a45"); #let accent = rgb("#5a7d2a"); #let red = rgb("#b5452f"); #let amber = rgb("#b58a1f"); #let blue = rgb("#2f5f8a")
#let stone = rgb("#c9a86a"); #let stone-l = rgb("#e4d6b8"); #let water = rgb("#bcd9ea"); #let green = rgb("#7fa25a")
#let r2(v) = str(calc.round(v, digits: 2)); #let r3(v) = str(calc.round(v, digits: 3)); #let r1(v) = str(calc.round(v, digits: 1))
#let f2(v) = { let s = str(calc.round(calc.abs(v), digits: 2)); if not s.contains(".") { s + ".00" } else if s.split(".").at(1).len() == 1 { s + "0" } else { s } }
#let lv(v) = if v < 0 { "−" + f2(v) } else { "+" + f2(v) }
#let H(body) = text(9.5pt, weight: "bold", fill: accent, body)
#let box-overlap(a, b) = a.at(0) < b.at(2) and b.at(0) < a.at(2) and a.at(1) < b.at(3) and b.at(1) < a.at(3)

// ---------- the courtyard between finished faces (data/rooms_gf.csv: the L round the malqaf core; walls 200 mm, the core's east wall 0.30) ----------
#let C = yaml("../3d/character.yaml").courtyard_layout
#let cx0 = 4.25 + 0.10; #let cx1 = 8.95 - 0.10; #let cy0 = 6.5 + 0.10; #let cy1 = 13.0 - 0.10
#let col-x = 5.8; #let edge = col-x + 0.125; #let core-face = 5.95       // the colonnade line, the soffit edge, the core's courtyard face (10 Nov 2026)
#let core = (col-x - 0.15, cy0 - 0.1, core-face, 8.767)
#let sleeve = 0.40; #let arc-col = 0.25; #let arc-y = (10.8333,)       // the second arcade column (the first is absorbed in the core)
#let walk-free = edge - cx0; #let walk-min = col-x - sleeve / 2 - cx0
#let court-rect = (cx1 - cx0) * (cy1 - cy0)
#let court-area = court-rect - (core-face - cx0) * (core.at(3) - cy0)   // the L between the finished faces
#let (sx0, sy0, sx1, sy1) = C.seating_zone
// ---------- H2: the water trough on the kitchen wall (outside faces; walls 0.15), the spout, the skimmer, the pump ----------
#let trough = (7.9, 9.1, 8.85, 11.2)                                     // 2.1 along the wall × 0.95 out, SOUTH of the olive's crown (its edge y 9.1); the jet's axis crosses its north part
#let twall = 0.15
#let wb = (trough.at(0) + twall, trough.at(1) + twall, trough.at(2) - 0.05, trough.at(3) - twall)   // the water inside: 0.75 × 1.8
#let trim = 0.80; #let wlevel = 0.65; #let spout-z = 1.05; #let wdepth = 0.35   // the rim, the water, the spout (the fall 0.40), the depth
#let spout-y = 10.95                                                     // the wall spout at the trough's SOUTH end (the seats' end); the water flows north to the skimmer
#let skimmer = (8.45, 9.2, 8.7, 9.45)                                    // the skimmer basket at the NORTH end, under the olive's crown edge: the leaves
#let pump = (8.0, 10.75, 8.5, 11.15)                                     // the dry pump chamber under the spout, inside the trough's south wall
// ---------- the olive in its fixed pot (Phase 2 of the haven study) ----------
#let olive = (cx: 8.25, cy: 8.1, r: 0.5, crown: 1.0, head: (2.0, 4.0))   // in front of the sink window (owner, on apply): the pot 0.1 off the wall, centred on the window; the crown lifted to +2.0, pruned flat on the wall side
// ---------- the seating H2: 5 seats with backs ----------
#let furn = (
  (6.0, 9.4, 6.85, 11.05, "sofa 3", "E"),        // the 3-seat sofa at the colonnade edge facing EAST: the trough 1.05 m ahead, the olive at its left
  (6.0, 11.5, 6.75, 12.25, "armchair", "N"),     // the south pair facing NORTH along the trough to the olive and the sink window
  (7.0, 11.5, 7.75, 12.25, "armchair", "N"),
  (6.9, 9.95, 7.3, 10.55, "table", ""),          // the side table between the sofa and the trough
)
#let seats = furn.map(f => if f.at(4) == "sofa 3" { 3 } else if f.at(4) == "armchair" { 1 } else { 0 }).sum()
#let backs = furn.all(f => f.at(4) in ("sofa 3", "armchair", "table"))
#let fb(f) = (f.at(0), f.at(1), f.at(2), f.at(3))
#let pot-box = (olive.cx - olive.r, olive.cy - olive.r, olive.cx + olive.r, olive.cy + olive.r)
#let zone-area = (sx1 - sx0) * (sy1 - sy0) - (trough.at(2) - trough.at(0)) * (trough.at(3) - trough.at(1))
#let sink = C.sink_window
#let (gx, gy0, gy1, gz0, gz1) = air-outlet
#let aim = 35deg                                                         // the louvres' fixed angle south of east (owner, 11 Nov 2026: 35°, from 30°)
#let D = C.drainage
#let eye = (9.55, 1.60)
#let sight(d) = sink.sill - (eye.at(1) - sink.sill) / (eye.at(0) - cx1) * d
#let trough-far = cx1 - trough.at(0)
#let gap-majlis = calc.min(..(furn.map(f => f.at(1)) + (pot-box.at(1), trough.at(1)))) - cy0
#let gap-south = cy1 - calc.max(..(furn.map(f => f.at(3)) + (pot-box.at(3),)))
#let gap-wall = cx1 - calc.max(..furn.map(f => f.at(2)))   // the furniture off the kitchen wall (the pot and the trough stand at it)
#let gap-trough = calc.min(..furn.filter(f => f.at(3) > trough.at(1) and f.at(1) < trough.at(3)).map(f => trough.at(0) - f.at(2)))   // the pieces beside the trough to its west rim
#let crown-to-water = trough.at(1) - (olive.cy + olive.crown)              // the crown's south edge to the trough's north end
#let axis-wall-y = (gy0 + gy1) / 2 + (cx1 - core-face) * calc.tan(aim)     // where the jet's axis meets the kitchen wall
#let axis-off-olive = calc.abs((olive.cx - core-face) * calc.sin(aim) - (olive.cy - (gy0 + gy1) / 2) * calc.cos(aim))   // the axis's distance from the olive's trunk in plan
#let pot-in-window = pot-box.at(1) >= sink.y.at(0) - 1e-6 and pot-box.at(3) <= sink.y.at(1) + 1e-6
// the jet's plan footprint at the kitchen wall (its edges at aim ± 10°) and the share of it over the trough
#let jet-wall = ((gy0 + gy1) / 2 + (cx1 - core-face) * calc.tan(aim - 10deg), (gy0 + gy1) / 2 + (cx1 - core-face) * calc.tan(aim + 10deg))
#let plan-over = (calc.min(jet-wall.at(1), trough.at(3)) - calc.max(jet-wall.at(0), trough.at(1))) / (jet-wall.at(1) - jet-wall.at(0))
// the jet at the trough's near rim (studies/malqaf_outlet_B.typ): the outlet's centre (core-face, (gy0+gy1)/2), `aim` south of east, ±10° spread
#let s-trough = { let c = (core-face, (gy0 + gy1) / 2); calc.sqrt(calc.pow(trough.at(0) - c.at(0), 2) + calc.pow(wb.at(1) - c.at(1), 2)) }
#let jet-bot = gz0 - s-trough * calc.tan(10deg); #let jet-top = gz1 + s-trough * calc.tan(10deg)
#let over-water = (jet-top - calc.max(jet-bot, trim)) / (jet-top - jet-bot)
#let v0 = mean-eve.q / outlet-free
// ---------- checks ----------
#let pieces = furn.map(fb) + (pot-box,)
#let checks = (
  ([the whole floor level: no step (floor #lv(C.floor)); the seating zone runs from the soffit edge to the kitchen wall], C.floor == 0.0 and C.level and calc.abs(sx0 - edge) < 1e-6 and calc.abs(sx1 - cx1) < 1e-6),
  ([movable seating for 5 (#seats seats: a 3-seat sofa, two armchairs, every seat with a back, no stools) with a side table; every piece, the olive's pot and the trough inside the seating zone, not overlapping], seats == 5 and backs and (pieces + (trough,)).all(p => p.at(0) >= sx0 - 1e-6 and p.at(2) <= sx1 + 1e-6 and p.at(1) >= sy0 - 1e-6 and p.at(3) <= sy1 + 1e-6) and range(pieces.len()).all(i => range(i + 1, pieces.len()).all(j => not box-overlap(pieces.at(i), pieces.at(j)))) and pieces.all(p => not box-overlap(p, trough))),
  ([the paths free: the colonnade walkway (#r3(walk-free) m, nothing west of the soffit edge), ≥ 0.6 at the living glass (#r2(gap-south)), ≥ 0.5 at the women's majlis glass (#r2(gap-majlis)), ≥ 0.6 from the furniture to the kitchen wall (#r2(gap-wall)), ≥ 0.6 between the side table and the trough's rim (#r2(gap-trough)) to clean it], gap-south >= 0.6 - 1e-6 and gap-majlis >= 0.5 - 1e-6 and gap-wall >= 0.6 - 1e-6 and gap-trough >= 0.6 - 1e-6),
  ([the olive's fixed pot (Ø #r2(2 * olive.r)) in front of the sink window (y #r2(pot-box.at(1))–#r2(pot-box.at(3)) within the window's y #r2(sink.y.at(0))–#r2(sink.y.at(1))), east of the soffit edge; its crown from +#f2(olive.head.at(0)): above the sill +#f2(sink.sill) and the eye at the sink (+1.60), the window not blocked], pot-in-window and pot-box.at(0) >= edge - 1e-6 and olive.head.at(0) >= 1.6 and pot-box.at(2) <= cx1 - 0.05),
  ([the trough on the kitchen wall south of the olive, its north end at the crown's edge (#r2(crown-to-water) m, ≥ 0: no crown over the water) and the skimmer at that end; its rim #lv(trim) above the sight line from the sink at its far rim (#lv(sight(trough-far))): the water seen from the sink], calc.abs(trough.at(2) - cx1) < 1e-6 and crown-to-water >= -1e-6 and skimmer.at(1) < (trough.at(1) + trough.at(3)) / 2 and trim > sight(trough-far)),
  ([the water moves and is heard: the spout #lv(spout-z) at the seats' end falls #r2(spout-z - wlevel) m into the water (≥ 0.30 for an audible fall), the surface flow toward the skimmer; the water #r2(wdepth) deep behind a rim #lv(trim): a child cannot fall in], spout-z - wlevel >= 0.3 - 1e-6 and trim >= 0.75 and wdepth <= 0.4 and spout-y > skimmer.at(3)),
  ([the malqaf outlet raised and turned (H2 / option B): y #r2(gy0)–#r2(gy1) centred in the first bay, #lv(gz0)…#lv(gz1), the louvres fixed 35° south-east: the jet's axis passes #r2(axis-off-olive) m from the trunk, under the crown (bottom +#f2(olive.head.at(0)) ≥ the jet's top #lv(gz1)), and meets the wall at y #r2(axis-wall-y), over the trough (y #r2(trough.at(1))–#r2(trough.at(3))); at the wall the jet's footprint spans y #r2(jet-wall.at(0))–#r2(jet-wall.at(1)): #str(calc.round(plan-over * 100)) % of its width over the water (≥ 80 %); at the trough's near corner (#r1(s-trough) m) it spans #lv(jet-bot)…#lv(jet-top): #str(calc.round(over-water * 100)) % of its depth over the water], gy0 >= 6.65 and gy1 <= 8.52 and axis-off-olive < olive.crown and olive.head.at(0) >= gz1 and axis-wall-y > trough.at(1) and axis-wall-y < trough.at(3) and plan-over >= 0.8 and over-water >= 0.5),
  ([every seat sees the water and the tree: the sofa faces east onto the trough (#r2(trough.at(0) - furn.at(0).at(2)) m) with the olive at its left; the armchairs face north along the trough to the olive and the window; no seat faces the outlet within 3 m (the sofa's centre #r2(calc.sqrt(calc.pow((furn.at(0).at(0) + furn.at(0).at(2)) / 2 - core-face, 2) + calc.pow((furn.at(0).at(1) + furn.at(0).at(3)) / 2 - (gy0 + gy1) / 2, 2))) m away, facing across the jet)], furn.at(0).at(5) == "E" and furn.at(1).at(5) == "N" and furn.at(2).at(5) == "N" and furn.at(1).at(1) > trough.at(1) and furn.at(2).at(1) > trough.at(1)),
  ([no TV on the kitchen wall (owner, 10 Nov 2026); the living's glass fixed, the riwaq's sliding door the only door; a curtain inside the women's majlis], true),
  ([drainage: the floor #lv(D.court_at_glass) at the glass (≤ 15 mm, R-08) falling to #lv(D.court_at_wall) at the kitchen wall foot; two linear drains; the overflow rim #lv(D.overflow_rim) between the drain level and the glass level; the pot's saucer and the trough piped to the kitchen-wall drain; everything to the separate rain system], D.court_at_glass >= -0.015 and D.court_at_wall < D.court_at_glass and D.linear_drains.len() >= 2 and D.overflow_rim > D.court_at_wall and D.overflow_rim < D.court_at_glass),
)
#let all-ok = checks.all(c => c.at(1))

// ====================================================================== PAGE 1 · the plan, the seats, the water, the olive, the checks
#text(14pt, weight: "bold", fill: accent)[Courtyard layout · H2 ADOPTED 10 Nov 2026 · the breeze over the water: the outlet raised and turned, the trough, the olive, five seats, no TV · Taif / Palm House V10.0]
#v(1pt)
#text(8pt, fill: gray)[The owner's choice from `studies/courtyard_haven.typ` (Phase 4) with the outlet of `studies/malqaf_outlet_B.typ` (adopted). The level floor and the drains of 3 Nov 2026 kept; the TV gone and the core's face straight (10 Nov 2026). Clear dimensions between finished faces; the data in `3d/character.yaml` `courtyard_layout` follows at the next release (the seating zone, the sink window and the drainage read from it now). Every size assumed; nothing here is for construction; the MEP engineer confirms the jet, the pump and the drains.]
#v(3pt)
#let plan(length: 1.7cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let q(p) = (p.at(0), -p.at(1))
  let T(p, body, size: 4.6pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, body))
  let R(b, fill: none, stroke: none) = rect(q((b.at(0), b.at(1))), q((b.at(2), b.at(3))), fill: fill, stroke: stroke)
  R((cx0 - 0.2, cy0 - 0.2, cx1 + 0.2, cy1 + 0.2), fill: luma(200))
  R((cx0, cy0, cx1, cy1), fill: stone-l)
  // the floor pattern: a 0.6 m honey-tone border round the seating zone, the field sand
  R((sx0, sy0, sx1, sy1), fill: rgb("#d8c39a").transparentize(55%)); R((sx0 + 0.6, sy0 + 0.6, sx1 - 0.6, sy1 - 0.6), fill: stone-l)
  line(q((cx0, cy0)), q((cx0, cy1)), stroke: 2.4pt + blue); line(q((cx0, cy0)), q((cx1, cy0)), stroke: 2.4pt + blue); line(q((cx0, cy1)), q((cx1, cy1)), stroke: 2.4pt + blue)
  line(q((cx1, cy0)), q((cx1, cy1)), stroke: 4pt + ink)
  line(q((cx1, sink.y.at(0))), q((cx1, sink.y.at(1))), stroke: 3pt + blue); T((cx1 + 0.12, (sink.y.at(0) + sink.y.at(1)) / 2), [sink window\ y #r2(sink.y.at(0))–#r2(sink.y.at(1))\ sill +#f2(sink.sill)], size: 3.8pt, fill: blue, anchor: "west")
  line(q((cx0, 9.1)), q((cx0, 10.5)), stroke: 4pt + red); T((cx0 - 0.12, 9.8), [riwaq door 1.40\ (sliding): the only door], size: 3.8pt, fill: red, anchor: "east")
  T(((cx0 + cx1) / 2, cy0 - 0.22), [women's majlis glass · fixed · a curtain inside], size: 3.6pt, fill: blue); T(((cx0 + cx1) / 2, cy1 + 0.22), [living glass · fixed (no door)], size: 3.6pt, fill: blue)
  line(q((edge, cy0)), q((edge, cy1)), stroke: (paint: ink, thickness: 0.8pt, dash: "dashed"))
  R((cx0, cy0, edge, cy1), fill: rgb("#ece4cf"))
  for y in (6.5, 13.0) { circle(q((col-x, y)), radius: sleeve / 2, fill: stone, stroke: 0.4pt + ink) }
  for y in arc-y { circle(q((col-x, y)), radius: arc-col / 2, fill: stone, stroke: 0.4pt + ink) }
  T(((cx0 + col-x) / 2, 11.6), [colonnade walkway\ #r3(walk-free) clear (#r3(walk-min) at C21 / C22)\ LEVEL with the whole floor], size: 4pt, angle: 90deg)
  // the malqaf core and the raised, turned outlet; the jet
  R(core, fill: luma(60)); T((col-x - 0.02, 7.0), [malqaf core · wall 0.30\ face x #r2(core-face)], size: 3.2pt, fill: white, angle: 90deg)
  line(q((core-face, gy0)), q((core-face, gy1)), stroke: 4pt + rgb("#9c6b3c")); T((core-face + 0.12, (gy0 + gy1) / 2), [outlet 1.4 × 1.0\ #lv(gz0) … #lv(gz1)\ louvres fixed 35° SE], size: 3.6pt, fill: amber, anchor: "west", angle: 90deg)
  let c = (core-face, (gy0 + gy1) / 2); let s1 = 3.3; let e1 = (c.at(0) + s1 * calc.cos(aim), c.at(1) + s1 * calc.sin(aim)); let wl = 0.7 + s1 * calc.tan(10deg); let n = (-calc.sin(aim), calc.cos(aim))
  line(q((c.at(0), c.at(1) - 0.7)), q((e1.at(0) - n.at(0) * wl, e1.at(1) - n.at(1) * wl)), q((e1.at(0) + n.at(0) * wl, e1.at(1) + n.at(1) * wl)), q((c.at(0), c.at(1) + 0.7)), close: true, fill: blue.transparentize(82%), stroke: none)
  line(q(c), q(e1), stroke: (paint: blue, thickness: 0.8pt, dash: "dashed"), mark: (end: "stealth", fill: blue, scale: 0.5)); T((6.9, 8.0), [the jet: under the olive's crown, over the trough's north part, off the wall onto the seats], size: 3.0pt, fill: blue, angle: -30deg)
  // the trough
  R(trough, fill: stone, stroke: 0.5pt + ink); R(wb, fill: water, stroke: 0.4pt + ink)
  T(((wb.at(0) + wb.at(2)) / 2, (wb.at(1) + wb.at(3)) / 2 + 0.1), [water trough\ #r2(wb.at(2) - wb.at(0)) × #r2(wb.at(3) - wb.at(1)) · rim #lv(trim)\ water #lv(wlevel) · #r2(wdepth) deep], size: 3.4pt)
  circle(q((cx1 - 0.08, spout-y)), radius: 0.07, fill: amber, stroke: none); T((cx1 - 0.2, spout-y - 0.2), [spout #lv(spout-z) · falls #r2(spout-z - wlevel)], size: 3.2pt, fill: amber, anchor: "east")
  R(skimmer, fill: white, stroke: 0.4pt + ink); T((skimmer.at(0) - 0.08, (skimmer.at(1) + skimmer.at(3)) / 2), [skimmer], size: 3pt, anchor: "east")
  R(pump, fill: white, stroke: 0.4pt + ink); T(((pump.at(0) + pump.at(2)) / 2, (pump.at(1) + pump.at(3)) / 2), [pump · dry], size: 3pt)
  // the olive, the seats
  circle(q((olive.cx, olive.cy)), radius: olive.crown, fill: green.transparentize(60%), stroke: (paint: green.darken(20%), dash: "dashed", thickness: 0.5pt))
  circle(q((olive.cx, olive.cy)), radius: olive.r, fill: rgb("#b48a5a"), stroke: 0.5pt + ink); T((olive.cx, olive.cy), [olive\ fixed pot Ø #r2(2 * olive.r)\ head +#f2(olive.head.at(0))…+#f2(olive.head.at(1))], size: 3.2pt, fill: white)
  for f in furn { R(fb(f), fill: if f.at(4) == "table" { rgb("#fbf4e6") } else { rgb("#b48a5a") }, stroke: 0.4pt + ink); T(((f.at(0) + f.at(2)) / 2, (f.at(1) + f.at(3)) / 2), [#f.at(4)#if f.at(5) != "" [\ faces #f.at(5)]], size: 3.4pt, fill: if f.at(4) == "table" { ink } else { white }) }
  // the jasmine wire and the wall light strip on the kitchen wall's south part; the lanterns
  line(q((cx1 - 0.04, 11.3)), q((cx1 - 0.04, 12.6)), stroke: (paint: green.darken(20%), thickness: 1.2pt, dash: "dotted")); T((cx1 + 0.12, 11.95), [jasmine on a wire · a light strip behind it], size: 3.2pt, fill: green.darken(20%), anchor: "west", angle: 90deg)
  for p in ((5.6, 9.75), (5.6, 12.4)) { circle(q(p), radius: 0.1, fill: amber, stroke: none) }; T((5.6, 9.45), [lantern], size: 3pt, fill: amber)
  circle(q((olive.cx - 0.7, olive.cy + 0.5)), radius: 0.07, fill: amber, stroke: none); T((olive.cx - 0.82, olive.cy + 0.5), [up-light], size: 2.9pt, fill: amber, anchor: "east")
  // the drains
  for d in D.linear_drains { R(d, fill: rgb("#8a9aa8"), stroke: 0.3pt + ink) }
  T((cx1 - 0.3, 12.55), [linear drain #lv(D.court_at_wall)], size: 3.4pt, fill: blue, anchor: "east"); T((cx0 + 0.2, 10.75), [slot drain at the door], size: 3.2pt, fill: blue, anchor: "west")
  circle(q(D.overflow_at), radius: 0.08, fill: white, stroke: 0.6pt + red); T((D.overflow_at.at(0) - 0.15, D.overflow_at.at(1) + 0.18), [overflow #lv(D.overflow_rim)], size: 3.4pt, fill: red, anchor: "east")
  // dimensions
  let dim(a, b, off, l, col: ink, vert: false) = {
    let p0 = if vert { (a.at(0) + off, a.at(1)) } else { (a.at(0), a.at(1) + off) }; let p1 = if vert { (b.at(0) + off, b.at(1)) } else { (b.at(0), b.at(1) + off) }
    line(q(p0), q(p1), stroke: 0.45pt + col, mark: (start: "|", end: "|", scale: 0.35)); T(((p0.at(0) + p1.at(0)) / 2 + (if vert { 0.14 } else { 0 }), (p0.at(1) + p1.at(1)) / 2 - (if vert { 0 } else { 0.14 })), l, size: 3.8pt, fill: col, angle: if vert { 90deg } else { 0deg })
  }
  dim((cx0, cy0), (cx1, cy0), -0.55, [courtyard #r2(cx1 - cx0) clear · level · the L ≈ #r2(court-area) m²])
  dim((edge, cy1), (cx1, cy1), 0.5, [seating zone #r3(sx1 - sx0)])
  dim((cx1, cy0), (cx1, pot-box.at(1)), 1.5, [#r2(pot-box.at(1) - cy0)], vert: true); dim((cx1, pot-box.at(1)), (cx1, trough.at(1)), 1.5, [olive #r2(trough.at(1) - pot-box.at(1))], vert: true); dim((cx1, trough.at(1)), (cx1, trough.at(3)), 1.5, [trough #r2(trough.at(3) - trough.at(1))], vert: true); dim((cx1, trough.at(3)), (cx1, cy1), 1.5, [#r2(cy1 - trough.at(3))], vert: true)
  T((cx0 - 0.3, cy0 - 0.35), [N ↑ up the page · 1 m = 1.7 cm], size: 4pt, fill: gray, anchor: "west")
})
#grid(columns: (auto, 1fr), gutter: 14pt,
  plan(),
  [
    #H[1 · The level floor and the paths]
    - *Courtyard:* #r2(cx1 - cx0) × #r2(cy1 - cy0) m between the finished faces, an L of ≈ #r2(court-area) m² (the rectangle #r2(court-rect) less the malqaf core's #r2((core-face - cx0) * (core.at(3) - cy0)) m²), *the whole floor LEVEL* (owner, 3 Nov 2026): the colonnade walkway (#r3(walk-free) m to the soffit edge), the seating zone and the cleaning strips at the glass one surface with gentle falls (page 2); outdoor anti-slip porcelain (R11), the field sand, a 0.6 m honey-tone border round the seating zone, the olive's circle in the border tone; no nosing, no step.
    - *Paths kept free:* the colonnade walkway (nothing west of the soffit edge x #r3(edge)); the riwaq door (sliding 1.40, *the only door*: the living's glass stays fixed) and the living's glass (#r2(gap-south) m); the women's majlis glass (#r2(gap-majlis) m to the olive's pot, a *curtain inside the majlis*); #r2(gap-wall) m from the armchairs to the kitchen wall; #r2(gap-trough) m between the side table and the trough's rim to clean it.
    #v(2pt)
    #H[2 · Five seats with backs, facing the water (H2)]
    - *Modern movable pieces* (the owner chooses them), *every seat with a back, no poufs or stools*: a *3-seat sofa* #r2(furn.at(0).at(3) - furn.at(0).at(1)) × #r2(furn.at(0).at(2) - furn.at(0).at(0)) with its back at the colonnade edge *facing east: the water trough #r2(trough.at(0) - furn.at(0).at(2)) m ahead, the olive and the sink window at its left*; *two armchairs* side by side on the south strip *facing north along the trough to the olive*; the *side table* #r2(furn.at(3).at(2) - furn.at(3).at(0)) × #r2(furn.at(3).at(3) - furn.at(3).at(1)) between the sofa and the water: *#seats seats*, every seat seeing the water and the tree; the farthest seat-to-seat ≈ 2.6 m. Outdoor-rated fabrics, cushions stored in the hospitality kitchen's cupboard.
    - *The olive* (owner, on apply): a 2–3 m standard in a *fixed pot Ø #r2(2 * olive.r) × 0.8 m* on pot feet *in front of the kitchen sink window*, 0.1 m off the wall and centred on it (x #r2(pot-box.at(0))–#r2(pot-box.at(2)), y #r2(pot-box.at(1))–#r2(pot-box.at(3))): from the sink the trunk rises in the window's middle and the *crown (+#f2(olive.head.at(0))…+#f2(olive.head.at(1)), pruned flat on the wall side) stands above the sill +#f2(sink.sill) and the eye at the sink*, the courtyard seen either side of the trunk; ≈ 1.2 t beside the kitchen wall (a note for the engineer, close to a support); the saucer piped to the kitchen-wall drain; a drip ring on a timer; the crown's south edge #r2(crown-to-water) m from the trough: the leaves fall on the floor and at the trough's skimmer end.
    - *The seating zone:* #r3(sx1 - sx0) × #r2(sy1 - sy0) = #r2((sx1 - sx0) * (sy1 - sy0)) m², less the trough #r2((trough.at(2) - trough.at(0)) * (trough.at(3) - trough.at(1))) m²: *#r2(zone-area) m² free*.
    #v(2pt)
    #H[3 · The breeze over the water · the trough on the kitchen wall]
    - *The outlet* (option B, adopted): 1.4 × 1.0, raised to *#lv(gz0)…#lv(gz1)* and centred in the first arcade bay (y #r2(gy0)–#r2(gy1)), the reveals splayed and the *timber louvres fixed 35° to the south-east* (owner, 11 Nov 2026, from 30°; the damper D2 behind them unchanged): at the summer-evening mean wind ≈ #r2(mean-eve.q) m³/s leave at ≈ #r1(v0) m/s; the jet's axis passes #r2(axis-off-olive) m from the olive's trunk, *under its crown* (the crown bottom +#f2(olive.head.at(0)) over the jet's top), and meets the kitchen wall at y #r2(axis-wall-y): *#str(calc.round(plan-over * 100)) % of the jet's width at the wall is over the water* (y #r2(jet-wall.at(0))–#r2(jet-wall.at(1)) against the trough's #r2(trough.at(1))–#r2(trough.at(3))); at the trough's near corner (#r1(s-trough) m) the jet spans #lv(jet-bot)…#lv(jet-top): #str(calc.round(over-water * 100)) % of its depth over the water; off the wall it spreads south along the trough and settles on the sofa and the armchairs at ≈ 0.6 m/s on the whole body (±30 %, the MEP engineer confirms), a little cooler for the water; nobody faces the jet within 3 m.
    - *The trough:* #r2(trough.at(2) - trough.at(0)) × #r2(trough.at(3) - trough.at(1)) outside (walls #r2(twall)) *along the kitchen wall south of the olive* (y #r2(trough.at(1))–#r2(trough.at(3)), its north end at the crown's edge: as far from the olive as the jet's path allows), the water #r2(wb.at(2) - wb.at(0)) × #r2(wb.at(3) - wb.at(1)) and #r2(wdepth) deep, *rim #lv(trim)* (seen obliquely from the sink over the sill +#f2(sink.sill)), a *wall spout at #lv(spout-z) falling #r2(spout-z - wlevel) m* at its *south end by the armchairs*: a calm, audible fall; the surface flow runs north to the *skimmer basket at the olive's end*, where the leaves fall; the pump in a dry chamber under the spout (a hatch in the rim); tanked, its drain and overflow to the rain system; the planter and the tree of 3 Nov 2026 are gone.
    - *Light:* the two lanterns under the soffit edge, a warm light under the spout, the olive up-lit from the floor, a 2700 K strip behind the jasmine on the kitchen wall south of the trough; one switch by the riwaq door and one dimmer; nothing shining into the majlis or the living. *Planting:* the olive, the jasmine on a wire (y 11.3–12.6), a laurel in a smaller pot where the family likes it, out of the jet.
    #v(2pt)
    #text(7.5pt)[#if all-ok [*Study checks passed* (#checks.len())] else [*STUDY CHECKS FAILED:* #checks.filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]]
  ],
)

// ====================================================================== PAGE 2 · the kitchen wall from the seating, the drainage, the dimensions
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[4 · The kitchen wall from the seating (the trough, the spout, the jasmine; no TV) · 5 · Drainage on a level floor · 6 · Dimensions]
#v(2pt)
#let elev(length: 1.0cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, t, size: 4.4pt, fill: ink, anchor: "center", angle: 0deg) = content(p, anchor: anchor, angle: angle, text(size, fill: fill, t))
  rect((cy0, -0.3), (cy1, 4.3), fill: rgb("#f3ece0"), stroke: 0.6pt + ink)
  rect((cy0, -0.3), (cy1, 0.0), fill: luma(120), stroke: none)
  line((cy0, 0), (cy1, 0), stroke: 0.6pt + ink); T((cy1 + 0.1, 0), [±0.00 level floor], size: 3.6pt, fill: gray, anchor: "west")
  // the trough and the spout
  rect((trough.at(1), 0), (trough.at(3), trim), fill: stone, stroke: 0.4pt + ink); rect((wb.at(1), trim - 0.12), (wb.at(3), wlevel), fill: water, stroke: none)
  rect((spout-y - 0.08, spout-z - 0.04), (spout-y + 0.08, spout-z + 0.04), fill: rgb("#9c6b3c"), stroke: none); line((spout-y, spout-z - 0.04), (spout-y, wlevel + 0.02), stroke: 1.2pt + blue)
  T(((trough.at(1) + trough.at(3)) / 2, trim + 0.15), [the trough · rim #lv(trim) · water #lv(wlevel) · the spout #lv(spout-z) falls #r2(spout-z - wlevel)], size: 3.6pt)
  T((skimmer.at(1) + 0.1, 0.3), [skimmer], size: 3pt); T((pump.at(1) + 0.2, 0.3), [pump (dry)], size: 3pt)
  // the sink window
  rect((sink.y.at(0), sink.sill), (sink.y.at(1), sink.head), fill: rgb("#9fcbe0").transparentize(30%), stroke: 0.8pt + blue); T(((sink.y.at(0) + sink.y.at(1)) / 2, sink.head + 0.15), [sink window y #r2(sink.y.at(0))–#r2(sink.y.at(1)) · +#f2(sink.sill) … +#f2(sink.head) · the trough in its view], size: 3.8pt, fill: blue)
  // the olive in front of the window: the pot, the trunk, the crown above the sill
  rect((olive.cy - olive.r, 0), (olive.cy + olive.r, 0.8), fill: rgb("#b48a5a"), stroke: 0.4pt + ink); line((olive.cy, 0.8), (olive.cy, olive.head.at(0) + 0.4), stroke: 2.2pt + rgb("#6b4a2a"))
  circle((olive.cy, (olive.head.at(0) + olive.head.at(1)) / 2), radius: olive.crown, fill: green.transparentize(45%), stroke: 0.5pt + green.darken(20%)); T((olive.cy, (olive.head.at(0) + olive.head.at(1)) / 2), [olive · crown +#f2(olive.head.at(0))…+#f2(olive.head.at(1))\ above the sill and the eye at the sink], size: 3.4pt, fill: white)
  T((olive.cy, 0.4), [fixed pot Ø #r2(2 * olive.r)], size: 3.2pt, fill: white)
  // the jasmine wire and the light strip; the wall otherwise plain render (no TV)
  for k in range(3) { line((11.3 + k * 0.5, 0.3), (11.3 + k * 0.5, 2.6), stroke: (paint: green.darken(20%), thickness: 0.5pt, dash: "dotted")) }; T((11.8, 2.8), [jasmine · a light strip behind], size: 3.2pt, fill: green.darken(20%))
  T((10.15, 2.2), [plain rendered wall: no TV], size: 3.4pt, fill: amber)
  // the sofa beyond, the eye line
  rect((furn.at(0).at(1), 0), (furn.at(0).at(3), 0.42), fill: rgb("#b48a5a").transparentize(40%), stroke: (paint: ink, thickness: 0.3pt, dash: "dashed")); T(((furn.at(0).at(1) + furn.at(0).at(3)) / 2, 0.6), [the sofa (beyond, at the colonnade edge) · seat +0.42 · eye ≈ +1.15 · faces the trough], size: 3.4pt, fill: luma(90))
  line((cy0, 1.15), (cy1, 1.15), stroke: (paint: gray, thickness: 0.4pt, dash: "dotted"))
  for (z, l) in ((trim, [#lv(trim)]), (spout-z, [#lv(spout-z)]), (1.15, [eye #lv(1.15)])) { T((cy1 + 0.1, z), l, size: 3.6pt, fill: gray, anchor: "west") }
  T((cy0, -0.55), [N], size: 4.4pt, anchor: "west"); T((cy1, -0.55), [S], size: 4.4pt, anchor: "east")
  T(((cy0 + cy1) / 2, 4.55), [the kitchen wall from the seating (looking east) · 1 m = 1.0 cm], size: 4.4pt, fill: accent)
})
#elev()
#v(4pt)
#grid(columns: (1.1fr, 1fr), gutter: 12pt,
  [
    #H[4 · The kitchen wall: the trough, the spout, the jasmine]
    - *The trough* #r2(trough.at(2) - trough.at(0)) × #r2(trough.at(3) - trough.at(1)) against the wall face south of the olive (y #r2(trough.at(1))–#r2(trough.at(3))), rim #lv(trim): a *spout* (a short copper or bronze lip, Ø 25) at #lv(spout-z) at the *south end, by the armchairs*, gives a calm fall of #r2(spout-z - wlevel) m heard from every seat (≈ 45–50 dB(A) at 2 m, assumed) and keeps the surface moving (no mosquitoes); the flow runs north to the *skimmer basket at the olive's end* (lifted and emptied by hand: the leaves and the dust); the pump (≈ 40 W, a float switch) in a dry chamber under the spout with a hatch in the rim; the trough tanked, its drain and overflow into the kitchen-wall slot drain's pipe (the rain system).
    - *The sink's view:* the olive's trunk in the window's middle, its crown from +#f2(olive.head.at(0)) above the sill +#f2(sink.sill) and the eye at the sink (≈ +1.6), so the window is not blocked: the courtyard either side of the trunk, the trough's rim and water obliquely to the south (the sight line over the sill reaches #lv(sight(trough-far)) at the trough's far rim: the water seen).
    - *The wall* south of the trough plain render: the *jasmine* on stainless wires (y 11.3–12.6) with a warm light strip behind it at +0.3; the armchairs 1.1 m off the wall.
    #H[5 · Drainage on a level floor]
    - *Falls:* the inside floors ±0.00; the courtyard finish at the three glass lines and the riwaq door at *#lv(D.court_at_glass)* (a #r2(-D.court_at_glass * 1000) mm threshold, R-08), falling *#str(calc.round(D.fall * 100, digits: 1)) % away from the glass* across the floor to the kitchen wall foot at *#lv(D.court_at_wall)*: no step, a 45 mm difference over the width that nobody feels.
    - *Linear drains:* a slot drain with a silt basket *along the kitchen wall foot* south of the trough (y #r2(D.linear_drains.at(0).at(1))–#r2(D.linear_drains.at(0).at(3)); the trough's and the pot's pipes join it) takes the whole floor; a short slot drain *at the riwaq door's threshold* (wind-driven rain at the door); the trough's drain and the olive's saucer pipe (Ø 32 in the build-up) join the wall-foot drain's pipe. *Overflow route:* a second gully at the south-east corner (rim #lv(D.overflow_rim)), its own pipe east, so a blocked drain floods the courtyard 3 cm, never the rooms.
    - *Pipes:* east under the kitchen floor (invert #lv(D.pipe_z) at the drains, 1 % fall) to the *east RAIN chamber* in the yard and the soakaway (`studies/site_plan.typ`, `studies/plumbing.typ`): *never into the foul system*. *Waterproofing:* one membrane over the whole courtyard slab (lowered 0.05 for the outdoor build-up), up 0.15 behind the glass plinths and the kitchen wall base; the trough tanked separately.
    - *Engineer / MEP to confirm:* the drain and pipe sizes, the rain chamber and the soakaway, the pump's circuit, the pot's point load (≈ 1.2 t), the lighting circuit and two sockets.
  ],
  [
    #H[6 · Dimensions (clear, between finished faces)]
    #table(columns: (1.6fr, auto, 1.6fr), inset: 2.4pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      [*Item*], [*m*], [*Note*],
      [Courtyard clear, level], [#r2(cx1 - cx0) × #r2(cy1 - cy0)], [the L ≈ #r2(court-area) m² clear (27.19 on axes); no step],
      [Colonnade walkway], [#r3(walk-free) / #r3(walk-min)], [to the soffit edge / at C21–C22; kept free],
      [Seating zone (level)], [#r3(sx1 - sx0) × #r2(sy1 - sy0)], [#r2(zone-area) m² free of the trough],
      [Furniture], [#seats seats], [a 3-seat sofa facing the water, two armchairs, a low table; movable],
      [The olive's pot], [Ø #r2(2 * olive.r) × 0.8], [x #r2(pot-box.at(0))–#r2(pot-box.at(2)), y #r2(pot-box.at(1))–#r2(pot-box.at(3)); head +#f2(olive.head.at(0))…+#f2(olive.head.at(1)); ≈ 1.2 t],
      [Cleaning strips], [#r2(gap-south) S · #r2(gap-majlis) N · #r2(gap-wall) E · #r2(gap-trough) at the trough], [living glass / majlis glass / kitchen wall / the trough's rim],
      [Trough], [#r2(trough.at(2) - trough.at(0)) × #r2(trough.at(3) - trough.at(1)) × #r2(wdepth)], [kitchen wall, y #r2(trough.at(1))–#r2(trough.at(3)); rim #lv(trim), water #lv(wlevel), spout #lv(spout-z); walls #r2(twall)],
      [Malqaf outlet (H2 / B)], [#r2(gy1 - gy0) × #r2(gz1 - gz0)], [y #r2(gy0)–#r2(gy1), #lv(gz0)…#lv(gz1); louvres fixed 35° SE; #str(calc.round(plan-over * 100)) % of the jet's width over the water at the wall],
      [TV], [none], [removed with its surround (owner, 10 Nov 2026)],
      [Levels], [#lv(D.court_at_glass) / #lv(D.court_at_wall)], [glass lines / wall foot; overflow #lv(D.overflow_rim); invert #lv(D.pipe_z)],
    )
    #v(2pt)
    #H[What changed and where]
    - *3 Nov 2026:* the level floor, the enclosure on the kitchen wall. *10 Nov 2026:* no TV; the core's face straight. *H2 (adopted 10 Nov 2026):* the outlet raised and turned (`studies/malqaf_outlet_B.typ`, `studies/air_system.typ`), the trough and the olive's pot in place of the planter and the tree, five seats facing the water, the lighting and the floor pattern; *on apply (owner):* the olive in front of the sink window, the trough south of it; *11 Nov 2026:* the louvres turned to 35°; the winter sun-seat is the suite court (the first-floor plan).
    - *Next release:* `3d/character.yaml` `courtyard_layout`, the 3D and its checks, `3d/params.yaml` (the outlet window), the DXFs, `studies/plumbing.typ`, `PROJECT_V10.md`, `DESIGN_LANGUAGE.md`.
  ],
)

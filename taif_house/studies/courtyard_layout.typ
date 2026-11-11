// courtyard_layout.typ · Taif / Palm House V10.0 · COURTYARD LAYOUT · H2 ADOPTED (the owner, 10 Nov 2026, from studies/courtyard_haven.typ Phase 4), REVISED 11 Nov 2026 (owner):
// the ORDER ALONG THE BREEZE: the malqaf outlet (+0.60…+1.60, y 6.9–8.3, its louvres fixed 15° south-east) → the OLIVE in its fixed Ø 1.0 pot standing in the jet's path →
// the WATER TROUGH 2.1 × 0.95 in front of the kitchen sink window (under it, on the kitchen wall): the breeze passes under the olive's crown and then over the water.
// The riwaq's courtyard line x 4.25 ONE straight line (the malqaf chamber's west wall on it; its courtyard face flush with the colonnade line x 5.80).
// BIGGER SEATING: the zone extended into the covered strip under the first-floor projection (x 4.35–5.925), keeping a 1.1 m path from the riwaq's sliding door into the courtyard;
// six seats with backs (a 3-seat sofa, a 2-seat sofa, an armchair, a low table) facing the olive and the water; no TV; the living's glass fixed (the riwaq's sliding door the only door);
// a curtain inside the women's majlis; the lighting and the floor pattern. The whole floor LEVEL, movable furniture, linear drains to the SEPARATE rain system; open to the sky.
// History: V8.0 (1 Nov 2026) the sunken seating; 3 Nov 2026 the level floor; 10 Nov 2026 no TV, the core's face straight, H2 (the trough, the olive, the raised outlet); 11 Nov 2026 this order.
// Reads: data/rooms_gf.csv (the courtyard), 3d/character.yaml (`courtyard_layout`: the sink window, the drainage; its seating_zone / enclosure / furniture / tv data are
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
#let inside(p, z) = p.at(0) >= z.at(0) - 1e-6 and p.at(2) <= z.at(2) + 1e-6 and p.at(1) >= z.at(1) - 1e-6 and p.at(3) <= z.at(3) + 1e-6
#let barea(b) = (b.at(2) - b.at(0)) * (b.at(3) - b.at(1))

// ---------- the courtyard between finished faces (data/rooms_gf.csv: the L round the malqaf core; walls 200 mm, the core's east wall 0.30) ----------
#let C = yaml("../3d/character.yaml").courtyard_layout
#let cx0 = 4.25 + 0.10; #let cx1 = 8.95 - 0.10; #let cy0 = 6.5 + 0.10; #let cy1 = 13.0 - 0.10
#let col-x = 5.8; #let edge = col-x + 0.125; #let core-face = 5.95       // the colonnade line, the soffit edge, the core's courtyard face (10 Nov 2026)
#let core = (cx0, cy0 - 0.1, core-face, 8.767)                            // 11 Nov 2026: the chamber's west wall ON the riwaq's line x 4.25 (no jog), its east face on the column line
#let sleeve = 0.40; #let arc-col = 0.25; #let arc-y = (10.8333,)       // the second arcade column (the first is absorbed in the core)
#let court-rect = (cx1 - cx0) * (cy1 - cy0)
#let court-area = court-rect - (core-face - cx0) * (core.at(3) - cy0)   // the L between the finished faces
// ---------- the seating zone (11 Nov 2026, owner: extended under the projection) and the door path ----------
#let zone-open = (edge, 7.1, cx1, 12.3)                                  // the open part: from the soffit edge to the kitchen wall, between the cleaning strips at the glass
#let zone-cov = (cx0, 10.3, edge, 12.3)                                  // the covered pocket under the first-floor projection, south of the door path
#let door = (9.1, 10.5)                                                  // the riwaq's sliding door 1.40 on x 4.25
#let path = (cx0, 9.2, 6.3, 10.3)                                        // the clear path from the door into the courtyard's open part: 1.1 m wide (≥ 0.9)
// ---------- the water trough in front of the kitchen sink window (outside faces; walls 0.15), the spout, the skimmer, the pump ----------
#let trough = (7.9, 7.3, 8.85, 9.4)                                      // 2.1 along the wall × 0.95 out, UNDER the sink window (y 7.3–8.9) and 0.5 m south of it
#let twall = 0.15
#let wb = (trough.at(0) + twall, trough.at(1) + twall, trough.at(2) - 0.05, trough.at(3) - twall)   // the water inside: 0.75 × 1.8
#let trim = 0.80; #let wlevel = 0.65; #let spout-z = 1.05; #let wdepth = 0.35   // the rim, the water, the spout (the fall 0.40), the depth
#let spout-y = 7.55                                                      // the wall spout at the trough's north end, under the window: the fall seen from the sink
#let skimmer = (8.45, 9.0, 8.7, 9.25)                                    // the skimmer basket at the south end, where the surface flow ends (the olive's leaves)
#let pump = (8.0, 7.35, 8.5, 7.75)                                       // the dry pump chamber under the spout, inside the trough's north wall
// ---------- the outlet and the jet ----------
#let (gx, gy0, gy1, gz0, gz1) = air-outlet
#let aim = 15deg                                                         // the louvres' fixed angle south of east (owner, 11 Nov 2026: 15°, so the jet runs outlet → olive → trough; 35° / 30° before)
#let oc = (core-face, (gy0 + gy1) / 2)                                   // the jet's origin: the outlet's centre on the core's face
#let axis-y(x) = oc.at(1) + (x - oc.at(0)) * calc.tan(aim)
// ---------- the olive in its fixed pot, IN THE JET'S PATH between the outlet and the water (owner, 11 Nov 2026) ----------
#let olive = (cx: 6.9, cy: 7.85, r: 0.5, crown: 1.0, head: (2.0, 4.0))   // its trunk on the jet's axis 0.95 m from the core's face, 0.5 m before the trough's rim; the crown lifted to +2.0
#let pot-box = (olive.cx - olive.r, olive.cy - olive.r, olive.cx + olive.r, olive.cy + olive.r)
// ---------- the seating: 6 seats with backs ----------
#let furn = (
  (6.5, 11.3, 8.15, 12.15, "sofa 3", "N"),       // the 3-seat sofa on the south strip facing NORTH: the olive ahead-left, the trough ahead-right
  (4.45, 10.5, 5.3, 12.1, "sofa 2", "E"),        // the 2-seat sofa in the covered pocket, its back at the riwaq's glass, facing EAST: the olive and the water beyond
  (7.65, 10.1, 8.4, 10.85, "armchair", "N"),     // by the kitchen wall facing NORTH: the trough 0.7 m ahead, the olive at its left
  (6.9, 10.4, 7.4, 11.0, "table", ""),           // the low table in the middle
)
#let seats = furn.map(f => if f.at(4) == "sofa 3" { 3 } else if f.at(4) == "sofa 2" { 2 } else if f.at(4) == "armchair" { 1 } else { 0 }).sum()
#let backs = furn.all(f => f.at(4) in ("sofa 3", "sofa 2", "armchair", "table"))
#let fb(f) = (f.at(0), f.at(1), f.at(2), f.at(3))
#let zone-area = barea(zone-open) - barea(trough) + barea(zone-cov)
#let sink = C.sink_window
#let D = C.drainage
#let eye = (9.55, 1.60)
#let sight(d) = sink.sill - (eye.at(1) - sink.sill) / (eye.at(0) - cx1) * d
#let trough-far = cx1 - trough.at(0)
#let gap-majlis = calc.min(..(furn.map(f => f.at(1)) + (pot-box.at(1), trough.at(1)))) - cy0
#let gap-south = cy1 - calc.max(..(furn.map(f => f.at(3)) + (pot-box.at(3),)))
#let gap-wall = cx1 - calc.max(..furn.map(f => f.at(2)))   // the furniture off the kitchen wall (the trough stands at it)
#let gap-trough = calc.min(..furn.filter(f => f.at(2) > trough.at(0) and f.at(0) < trough.at(2)).map(f => f.at(1) - trough.at(3)))   // the pieces south of the trough to its rim
#let crown-to-water = trough.at(0) - (olive.cx + olive.crown)             // the crown's east edge to the trough's west rim
#let axis-wall-y = axis-y(cx1)                                           // where the jet's axis meets the kitchen wall
#let axis-off-olive = calc.abs((olive.cx - oc.at(0)) * calc.sin(aim) - (olive.cy - oc.at(1)) * calc.cos(aim))   // the axis's distance from the olive's trunk in plan
#let trough-under-window = trough.at(1) <= sink.y.at(0) + 1e-6 and trough.at(3) >= sink.y.at(1) - 1e-6
// the jet's plan footprint at the kitchen wall (its edges at aim ± 10°) and the share of it over the trough
#let jet-wall = (oc.at(1) + (cx1 - oc.at(0)) * calc.tan(aim - 10deg), oc.at(1) + (cx1 - oc.at(0)) * calc.tan(aim + 10deg))
#let plan-over = (calc.min(jet-wall.at(1), trough.at(3)) - calc.max(jet-wall.at(0), trough.at(1))) / (jet-wall.at(1) - jet-wall.at(0))
// the jet's depth at the olive's trunk and at the trough's near rim (±10° spread)
#let s-olive = olive.cx - oc.at(0)
#let jet-top-olive = gz1 + s-olive * calc.tan(10deg); #let jet-bot-olive = gz0 - s-olive * calc.tan(10deg)
#let s-trough = { calc.sqrt(calc.pow(trough.at(0) - oc.at(0), 2) + calc.pow(axis-y(trough.at(0)) - oc.at(1), 2)) }
#let jet-bot = gz0 - s-trough * calc.tan(10deg); #let jet-top = gz1 + s-trough * calc.tan(10deg)
#let over-water = (jet-top - calc.max(jet-bot, trim)) / (jet-top - jet-bot)
#let v0 = mean-eve.q / outlet-free
// ---------- checks ----------
#let pieces = furn.map(fb) + (pot-box,)
#let checks = (
  ([the whole floor level: no step (floor #lv(C.floor)); the seating zone = the open part (x #r3(zone-open.at(0))–#r2(zone-open.at(2)), y #r2(zone-open.at(1))–#r2(zone-open.at(3))) + the covered pocket under the projection (x #r2(zone-cov.at(0))–#r3(zone-cov.at(2)), y #r2(zone-cov.at(1))–#r2(zone-cov.at(3))); the riwaq's line x 4.25 straight (the chamber's west wall on it) and the core's courtyard face on the column line], C.floor == 0.0 and C.level and calc.abs(core.at(0) - cx0) < 1e-6 and calc.abs(core.at(2) - core-face) < 1e-6 and calc.abs(zone-cov.at(2) - zone-open.at(0)) < 1e-6),
  ([movable seating for 6 (#seats seats: a 3-seat sofa, a 2-seat sofa, an armchair, every seat with a back, no stools) with a low table; every piece and the olive's pot inside the zone, the trough inside the open part, nothing overlapping], seats == 6 and backs and pieces.all(p => inside(p, zone-open) or inside(p, zone-cov)) and inside(trough, zone-open) and range(pieces.len()).all(i => range(i + 1, pieces.len()).all(j => not box-overlap(pieces.at(i), pieces.at(j)))) and pieces.all(p => not box-overlap(p, trough))),
  ([the paths free: the door path #r2(path.at(3) - path.at(1)) m wide (≥ 0.9) from the riwaq's sliding door (y #r2(door.at(0))–#r2(door.at(1))) east to x #r2(path.at(2)), nothing in it; ≥ 0.6 at the living glass (#r2(gap-south)), ≥ 0.5 at the women's majlis glass (#r2(gap-majlis)), ≥ 0.3 behind the armchair at the kitchen wall (#r2(gap-wall)), ≥ 0.6 between the armchair and the trough's rim (#r2(gap-trough)) to clean it], path.at(3) - path.at(1) >= 0.9 and path.at(1) >= door.at(0) - 1e-6 and path.at(3) <= door.at(1) + 1e-6 and pieces.all(p => not box-overlap(p, path)) and not box-overlap(trough, path) and gap-south >= 0.6 - 1e-6 and gap-majlis >= 0.5 - 1e-6 and gap-wall >= 0.3 - 1e-6 and gap-trough >= 0.6 - 1e-6),
  ([the order along the breeze: the outlet (x #r2(core-face)) → the olive (x #r2(pot-box.at(0))–#r2(pot-box.at(2)), its trunk #r2(axis-off-olive) m off the jet's axis) → the trough (x #r2(trough.at(0))–#r2(trough.at(2))); at the trunk the jet spans #lv(jet-bot-olive)…#lv(jet-top-olive): under the crown (bottom +#f2(olive.head.at(0))), the pot's rim +0.80 and the trunk take its lowest part; the crown's east edge #r2(crown-to-water) m from the trough's rim], core-face < pot-box.at(0) and pot-box.at(2) <= trough.at(0) + 1e-6 and axis-off-olive <= 0.1 and jet-top-olive <= olive.head.at(0) and crown-to-water >= -1e-6),
  ([the trough in front of the sink window: y #r2(trough.at(1))–#r2(trough.at(3)) covers the window's y #r2(sink.y.at(0))–#r2(sink.y.at(1)); its rim #lv(trim) below the sill +#f2(sink.sill) and above the sight line from the sink at its far rim (#lv(sight(trough-far))): the water seen from the sink; the spout under the window, the skimmer at the far end], calc.abs(trough.at(2) - cx1) < 1e-6 and trough-under-window and trim < sink.sill and trim > sight(trough-far) and spout-y > sink.y.at(0) and spout-y < sink.y.at(1) and skimmer.at(1) > (trough.at(1) + trough.at(3)) / 2),
  ([the water moves and is heard: the spout #lv(spout-z) falls #r2(spout-z - wlevel) m into the water (≥ 0.30 for an audible fall), the surface flow south to the skimmer; the water #r2(wdepth) deep behind a rim #lv(trim): a child cannot fall in], spout-z - wlevel >= 0.3 - 1e-6 and trim >= 0.75 and wdepth <= 0.4 and spout-y < skimmer.at(1)),
  ([the malqaf outlet raised (H2 / option B): y #r2(gy0)–#r2(gy1) centred in the first bay, #lv(gz0)…#lv(gz1), the louvres fixed 15° south-east: the axis meets the kitchen wall at y #r2(axis-wall-y), the trough's middle; at the wall the jet's footprint spans y #r2(jet-wall.at(0))–#r2(jet-wall.at(1)): #str(calc.round(plan-over * 100)) % of its width over the water (≥ 80 %); at the trough's near rim (#r1(s-trough) m) it spans #lv(jet-bot)…#lv(jet-top): #str(calc.round(over-water * 100)) % of its depth over the water], gy0 >= 6.65 and gy1 <= 8.52 and axis-wall-y > trough.at(1) and axis-wall-y < trough.at(3) and plan-over >= 0.8 and over-water >= 0.5),
  ([every seat sees the olive and the water: the 3-seat sofa faces north (the olive ahead-left, the trough ahead-right), the 2-seat sofa under the projection faces east (the olive, the water beyond), the armchair faces north onto the trough with the olive at its left; no seat faces the outlet within 3 m (the 2-seat sofa's centre #r2(calc.sqrt(calc.pow((furn.at(1).at(0) + furn.at(1).at(2)) / 2 - oc.at(0), 2) + calc.pow((furn.at(1).at(1) + furn.at(1).at(3)) / 2 - oc.at(1), 2))) m away, facing across the jet)], furn.at(0).at(5) == "N" and furn.at(1).at(5) == "E" and furn.at(2).at(5) == "N" and furn.at(0).at(1) > pot-box.at(3) and furn.at(2).at(1) > trough.at(3)),
  ([no TV on the kitchen wall (owner, 10 Nov 2026); the living's glass fixed, the riwaq's sliding door the only door; a curtain inside the women's majlis], true),
  ([drainage: the floor #lv(D.court_at_glass) at the glass (≤ 15 mm, R-08) falling to #lv(D.court_at_wall) at the kitchen wall foot; two linear drains; the overflow rim #lv(D.overflow_rim) between the drain level and the glass level; the pot's saucer and the trough piped to the kitchen-wall drain; everything to the separate rain system], D.court_at_glass >= -0.015 and D.court_at_wall < D.court_at_glass and D.linear_drains.len() >= 2 and D.overflow_rim > D.court_at_wall and D.overflow_rim < D.court_at_glass),
)
#let all-ok = checks.all(c => c.at(1))

// ====================================================================== PAGE 1 · the plan, the seats, the water, the olive, the checks
#text(14pt, weight: "bold", fill: accent)[Courtyard layout · H2 revised 11 Nov 2026 · malqaf → olive → water · the straight riwaq · the bigger seating (6 seats) · no TV · Taif / Palm House V10.0]
#v(1pt)
#text(8pt, fill: gray)[The owner's H2 (`studies/courtyard_haven.typ`, the outlet of `studies/malqaf_outlet_B.typ`) with the owner's three corrections of 11 Nov 2026: the riwaq's line straight, the order outlet → olive → water, the seating extended under the projection. The level floor and the drains of 3 Nov 2026 kept; the TV gone and the core's face straight (10 Nov 2026). Clear dimensions between finished faces; `3d/character.yaml` `courtyard_layout` follows at the next release (the sink window and the drainage read from it now). Every size assumed; nothing here is for construction; the MEP engineer confirms the jet, the pump and the drains.]
#v(3pt)
#let plan(length: 1.7cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let q(p) = (p.at(0), -p.at(1))
  let T(p, body, size: 4.6pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, body))
  let R(b, fill: none, stroke: none) = rect(q((b.at(0), b.at(1))), q((b.at(2), b.at(3))), fill: fill, stroke: stroke)
  R((cx0 - 0.2, cy0 - 0.2, cx1 + 0.2, cy1 + 0.2), fill: luma(200))
  R((cx0, cy0, cx1, cy1), fill: stone-l)
  R((cx0, cy0, edge, cy1), fill: rgb("#ece4cf"))
  // the floor pattern: a 0.6 m honey-tone border round the seating zone (both parts), the field sand
  R(zone-open, fill: rgb("#d8c39a").transparentize(55%)); R(zone-cov, fill: rgb("#d8c39a").transparentize(55%))
  R((zone-open.at(0) + 0.6, zone-open.at(1) + 0.6, zone-open.at(2) - 0.6, zone-open.at(3) - 0.6), fill: stone-l)
  R(path, fill: rgb("#f3ece0"), stroke: (paint: red, thickness: 0.5pt, dash: "dotted")); T((5.3, 9.75), [door path #r2(path.at(3) - path.at(1)) clear], size: 3.4pt, fill: red)
  line(q((cx0, cy0)), q((cx0, cy1)), stroke: 2.4pt + blue); line(q((cx0, cy0)), q((cx1, cy0)), stroke: 2.4pt + blue); line(q((cx0, cy1)), q((cx1, cy1)), stroke: 2.4pt + blue)
  line(q((cx1, cy0)), q((cx1, cy1)), stroke: 4pt + ink)
  line(q((cx1, sink.y.at(0))), q((cx1, sink.y.at(1))), stroke: 3pt + blue); T((cx1 + 0.12, (sink.y.at(0) + sink.y.at(1)) / 2), [sink window\ y #r2(sink.y.at(0))–#r2(sink.y.at(1))\ sill +#f2(sink.sill)], size: 3.8pt, fill: blue, anchor: "west")
  line(q((cx0, door.at(0))), q((cx0, door.at(1))), stroke: 4pt + red); T((cx0 - 0.12, 9.8), [riwaq door 1.40\ (sliding): the only door], size: 3.8pt, fill: red, anchor: "east")
  T((cx0 - 0.12, 7.6), [riwaq line x 4.25\ ONE straight line], size: 3.6pt, fill: ink, anchor: "east")
  T(((cx0 + cx1) / 2, cy0 - 0.22), [women's majlis glass · fixed · a curtain inside], size: 3.6pt, fill: blue); T(((cx0 + cx1) / 2, cy1 + 0.22), [living glass · fixed (no door)], size: 3.6pt, fill: blue)
  line(q((edge, cy0)), q((edge, cy1)), stroke: (paint: ink, thickness: 0.8pt, dash: "dashed"))
  for y in (6.5, 13.0) { circle(q((col-x, y)), radius: sleeve / 2, fill: stone, stroke: 0.4pt + ink) }
  for y in arc-y { circle(q((col-x, y)), radius: arc-col / 2, fill: stone, stroke: 0.4pt + ink) }
  T((5.6, 11.3), [covered pocket\ under the projection], size: 3.4pt, angle: 90deg)
  // the malqaf core (x 4.25–5.80 on axes, no jog) and the raised outlet; the jet
  R(core, fill: luma(60)); T(((core.at(0) + core.at(2)) / 2, 7.6), [malqaf chamber\ west wall on the riwaq's line · east wall 0.30 on the column line], size: 3.2pt, fill: white, angle: 90deg)
  line(q((core-face, gy0)), q((core-face, gy1)), stroke: 4pt + rgb("#9c6b3c")); T((core-face + 0.1, 6.95), [outlet 1.4 × 1.0 · #lv(gz0) … #lv(gz1) · louvres fixed 15° SE], size: 3.3pt, fill: amber, anchor: "west")
  let s1 = 2.95; let e1 = (oc.at(0) + s1 * calc.cos(aim), oc.at(1) + s1 * calc.sin(aim)); let wl = 0.7 + s1 * calc.tan(10deg); let n = (-calc.sin(aim), calc.cos(aim))
  line(q((oc.at(0), oc.at(1) - 0.7)), q((e1.at(0) - n.at(0) * wl, e1.at(1) - n.at(1) * wl)), q((e1.at(0) + n.at(0) * wl, e1.at(1) + n.at(1) * wl)), q((oc.at(0), oc.at(1) + 0.7)), close: true, fill: blue.transparentize(82%), stroke: none)
  line(q(oc), q(e1), stroke: (paint: blue, thickness: 0.8pt, dash: "dashed"), mark: (end: "stealth", fill: blue, scale: 0.5)); T((6.95, 9.05), [the jet: outlet → under the olive's crown → over the trough → off the wall onto the seats], size: 3.0pt, fill: blue, angle: -15deg)
  // the trough
  R(trough, fill: stone, stroke: 0.5pt + ink); R(wb, fill: water, stroke: 0.4pt + ink)
  T(((wb.at(0) + wb.at(2)) / 2, (wb.at(1) + wb.at(3)) / 2 + 0.1), [water trough\ #r2(wb.at(2) - wb.at(0)) × #r2(wb.at(3) - wb.at(1)) · rim #lv(trim)\ water #lv(wlevel) · #r2(wdepth) deep], size: 3.4pt)
  circle(q((cx1 - 0.08, spout-y)), radius: 0.07, fill: amber, stroke: none); T((cx1 - 0.2, spout-y - 0.2), [spout #lv(spout-z) · falls #r2(spout-z - wlevel)], size: 3.2pt, fill: amber, anchor: "east")
  R(skimmer, fill: white, stroke: 0.4pt + ink); T((skimmer.at(0) - 0.08, (skimmer.at(1) + skimmer.at(3)) / 2), [skimmer], size: 3pt, anchor: "east")
  R(pump, fill: white, stroke: 0.4pt + ink); T(((pump.at(0) + pump.at(2)) / 2, (pump.at(1) + pump.at(3)) / 2), [pump · dry], size: 3pt)
  // the olive, the seats
  circle(q((olive.cx, olive.cy)), radius: olive.crown, fill: green.transparentize(60%), stroke: (paint: green.darken(20%), dash: "dashed", thickness: 0.5pt))
  circle(q((olive.cx, olive.cy)), radius: olive.r, fill: rgb("#b48a5a"), stroke: 0.5pt + ink); T((olive.cx, olive.cy), [olive\ fixed pot Ø #r2(2 * olive.r)\ head +#f2(olive.head.at(0))…+#f2(olive.head.at(1))], size: 3.2pt, fill: white)
  for f in furn { R(fb(f), fill: if f.at(4) == "table" { rgb("#fbf4e6") } else { rgb("#b48a5a") }, stroke: 0.4pt + ink); T(((f.at(0) + f.at(2)) / 2, (f.at(1) + f.at(3)) / 2), [#f.at(4)#if f.at(5) != "" [\ faces #f.at(5)]], size: 3.4pt, fill: if f.at(4) == "table" { ink } else { white }, angle: if f.at(4) == "sofa 2" { 90deg } else { 0deg }) }
  // the jasmine wire and the wall light strip on the kitchen wall south of the trough; the lanterns
  line(q((cx1 - 0.04, 10.0)), q((cx1 - 0.04, 12.6)), stroke: (paint: green.darken(20%), thickness: 1.2pt, dash: "dotted")); T((cx1 + 0.12, 11.3), [jasmine on a wire · a light strip behind it], size: 3.2pt, fill: green.darken(20%), anchor: "west", angle: 90deg)
  for p in ((5.6, 9.0), (5.6, 12.5)) { circle(q(p), radius: 0.1, fill: amber, stroke: none) }; T((5.6, 8.75), [lantern], size: 3pt, fill: amber)
  circle(q((olive.cx - 0.3, olive.cy + 0.75)), radius: 0.07, fill: amber, stroke: none); T((olive.cx - 0.42, olive.cy + 0.75), [up-light], size: 2.9pt, fill: amber, anchor: "east")
  // the drains
  for d in D.linear_drains { R(d, fill: rgb("#8a9aa8"), stroke: 0.3pt + ink) }
  T((cx1 - 0.3, 12.55), [linear drain #lv(D.court_at_wall)], size: 3.4pt, fill: blue, anchor: "east"); T((cx0 + 0.15, 8.95), [slot drain at the door], size: 3.2pt, fill: blue, anchor: "west")
  circle(q(D.overflow_at), radius: 0.08, fill: white, stroke: 0.6pt + red); T((D.overflow_at.at(0) - 0.15, D.overflow_at.at(1) + 0.18), [overflow #lv(D.overflow_rim)], size: 3.4pt, fill: red, anchor: "east")
  // dimensions
  let dim(a, b, off, l, col: ink, vert: false) = {
    let p0 = if vert { (a.at(0) + off, a.at(1)) } else { (a.at(0), a.at(1) + off) }; let p1 = if vert { (b.at(0) + off, b.at(1)) } else { (b.at(0), b.at(1) + off) }
    line(q(p0), q(p1), stroke: 0.45pt + col, mark: (start: "|", end: "|", scale: 0.35)); T(((p0.at(0) + p1.at(0)) / 2 + (if vert { 0.14 } else { 0 }), (p0.at(1) + p1.at(1)) / 2 - (if vert { 0 } else { 0.14 })), l, size: 3.8pt, fill: col, angle: if vert { 90deg } else { 0deg })
  }
  dim((cx0, cy0), (cx1, cy0), -0.55, [courtyard #r2(cx1 - cx0) clear · level · the L ≈ #r2(court-area) m²])
  dim((cx0, cy1), (edge, cy1), 0.5, [covered #r3(edge - cx0)]); dim((edge, cy1), (cx1, cy1), 0.5, [open #r3(cx1 - edge) · the seating zone #r2(zone-area) m² free])
  dim((cx1, cy0), (cx1, trough.at(1)), 1.5, [#r2(trough.at(1) - cy0)], vert: true); dim((cx1, trough.at(1)), (cx1, trough.at(3)), 1.5, [trough #r2(trough.at(3) - trough.at(1))], vert: true); dim((cx1, trough.at(3)), (cx1, zone-open.at(3)), 1.5, [seating #r2(zone-open.at(3) - trough.at(3))], vert: true); dim((cx1, zone-open.at(3)), (cx1, cy1), 1.5, [#r2(cy1 - zone-open.at(3))], vert: true)
  T((cx0 - 0.3, cy0 - 0.35), [N ↑ up the page · 1 m = 1.7 cm], size: 4pt, fill: gray, anchor: "west")
})
#grid(columns: (auto, 1fr), gutter: 14pt,
  plan(),
  [
    #H[1 · The straight riwaq, the level floor and the paths]
    - *The riwaq's line:* the wall / glass line on x 4.25 runs *straight along its whole length*; the malqaf chamber's west wall stands ON it (the 0.15 jog removed: the chamber 1.55 wide on axes, like the projection above) and its courtyard face is flush with the colonnade line x 5.80 (the east wall 0.30 under the edge beam).
    - *Courtyard:* #r2(cx1 - cx0) × #r2(cy1 - cy0) m between the finished faces, an L of ≈ #r2(court-area) m², *the whole floor LEVEL* (owner, 3 Nov 2026): the covered strip, the open part and the cleaning strips one surface with gentle falls (page 2); anti-slip porcelain (R11), the field sand, a 0.6 m honey-tone border round the seating zone; no step.
    - *Paths kept free:* the *door path* #r2(path.at(3) - path.at(1)) m wide (≥ 0.9) from the riwaq's sliding door (1.40, *the only door*: the living's glass stays fixed) straight east into the open part (to x #r2(path.at(2))); the living's glass (#r2(gap-south) m); the women's majlis glass (#r2(gap-majlis) m to the trough and the pot, a *curtain inside the majlis*); #r2(gap-wall) m behind the armchair at the kitchen wall; #r2(gap-trough) m between the armchair and the trough's rim to clean it.
    #v(2pt)
    #H[2 · Six seats with backs, facing the olive and the water · the bigger zone]
    - *The seating zone* (owner, 11 Nov 2026): the open part #r3(zone-open.at(2) - zone-open.at(0)) × #r2(zone-open.at(3) - zone-open.at(1)) = #r2(barea(zone-open)) m² less the trough #r2(barea(trough)) m², *plus the covered pocket under the first-floor projection* #r3(zone-cov.at(2) - zone-cov.at(0)) × #r2(zone-cov.at(3) - zone-cov.at(1)) = #r2(barea(zone-cov)) m² (x #r2(zone-cov.at(0))–#r3(zone-cov.at(2)), south of the door path): *#r2(zone-area) m² free* (13.2 before); the pocket the shaded summer seat.
    - *Modern movable pieces* (the owner chooses them), *every seat with a back, no poufs or stools*: a *3-seat sofa* #r2(furn.at(0).at(2) - furn.at(0).at(0)) × #r2(furn.at(0).at(3) - furn.at(0).at(1)) on the south strip *facing north: the olive ahead-left, the trough ahead-right*; a *2-seat sofa* #r2(furn.at(1).at(3) - furn.at(1).at(1)) × #r2(furn.at(1).at(2) - furn.at(1).at(0)) in the covered pocket with its back at the riwaq's glass *facing east: the olive, the water beyond it*; an *armchair* by the kitchen wall *facing north onto the trough* with the olive at its left; the low *table* #r2(furn.at(3).at(2) - furn.at(3).at(0)) × #r2(furn.at(3).at(3) - furn.at(3).at(1)) in the middle: *#seats seats*, every seat seeing the olive and the water; the farthest seat-to-seat ≈ 3.2 m. Outdoor fabrics; the cushions stored in the hospitality kitchen.
    - *The olive* (owner, 11 Nov 2026): a 2–3 m standard in a *fixed pot Ø #r2(2 * olive.r) × 0.8 m* on pot feet *in the jet's path between the outlet and the water* (x #r2(pot-box.at(0))–#r2(pot-box.at(2)), y #r2(pot-box.at(1))–#r2(pot-box.at(3)); its trunk on the jet's axis #r2(s-olive) m from the core's face, #r2(crown-to-water) m from the trough's rim): the *crown +#f2(olive.head.at(0))…+#f2(olive.head.at(1))* above the jet's top (#lv(jet-top-olive) at the trunk) and above the sink's eye line, pruned off the core's face; from the sink the trunk stands #r2(cx1 - olive.cx) m beyond the trough, the crown's underside in the window's top; ≈ 1.2 t at one spot (a note for the engineer); the saucer piped to the kitchen-wall drain; a drip ring on a timer; the leaves blow east onto the water, to the skimmer.
    #v(2pt)
    #H[3 · The breeze: outlet → olive → water · the trough under the sink window]
    - *The outlet* (option B, adopted): 1.4 × 1.0, raised to *#lv(gz0)…#lv(gz1)* and centred in the first arcade bay (y #r2(gy0)–#r2(gy1)), the reveals splayed and the *timber louvres fixed 15° to the south-east* (owner, 11 Nov 2026: re-aimed from 35° so that the jet runs over the olive's pot onto the trough; the damper D2 behind them unchanged): at the summer-evening mean wind ≈ #r2(mean-eve.q) m³/s leave at ≈ #r1(v0) m/s; the jet's axis passes through the olive's trunk *under its crown* (the pot's rim and the trunk take the jet's lowest 0.35 m) and meets the kitchen wall at y #r2(axis-wall-y), the trough's middle: *#str(calc.round(plan-over * 100)) % of the jet's width at the wall is over the water* (y #r2(jet-wall.at(0))–#r2(jet-wall.at(1)) within the trough's #r2(trough.at(1))–#r2(trough.at(3))); at the trough's near rim the jet spans #lv(jet-bot)…#lv(jet-top) (#str(calc.round(over-water * 100)) % of its depth over the water); off the wall it spreads south and settles on the three seats at ≈ 0.6 m/s (±30 %, the MEP engineer confirms), a little cooler for the water; nobody faces the jet within 3 m.
    - *The trough:* #r2(trough.at(2) - trough.at(0)) × #r2(trough.at(3) - trough.at(1)) outside (walls #r2(twall)) *on the kitchen wall in front of the sink window* (y #r2(trough.at(1))–#r2(trough.at(3)) over the window's #r2(sink.y.at(0))–#r2(sink.y.at(1))), the water #r2(wb.at(2) - wb.at(0)) × #r2(wb.at(3) - wb.at(1)) and #r2(wdepth) deep, *rim #lv(trim)* (below the sill +#f2(sink.sill): the water and the fall seen from the sink; the sight line reaches #lv(sight(trough-far)) at the far rim), a *wall spout at #lv(spout-z) falling #r2(spout-z - wlevel) m* at its north end under the window: a calm, audible fall; the surface flow runs south to the *skimmer basket* (the olive's leaves); the pump dry under the spout; tanked, its drain and overflow to the rain system.
    - *Light:* two lanterns under the soffit edge, a light under the spout, the olive up-lit, a 2700 K strip behind the jasmine; one switch by the riwaq door and a dimmer; nothing shining into the rooms. *Planting:* the olive, the jasmine on a wire (y 10.0–12.6), a laurel in a smaller pot out of the jet.
    #v(2pt)
    #text(7.5pt)[#if all-ok [*Study checks passed* (#checks.len())] else [*STUDY CHECKS FAILED:* #checks.filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]]
  ],
)

// ====================================================================== PAGE 2 · the kitchen wall from the seating, the drainage, the dimensions
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[4 · The kitchen wall from the seating (the trough under the window, the olive before it, the jasmine; no TV) · 5 · Drainage on a level floor · 6 · Dimensions]
#v(2pt)
#let elev(length: 0.85cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, t, size: 4.4pt, fill: ink, anchor: "center", angle: 0deg) = content(p, anchor: anchor, angle: angle, text(size, fill: fill, t))
  rect((cy0, -0.3), (cy1, 4.3), fill: rgb("#f3ece0"), stroke: 0.6pt + ink)
  rect((cy0, -0.3), (cy1, 0.0), fill: luma(120), stroke: none)
  line((cy0, 0), (cy1, 0), stroke: 0.6pt + ink); T((cy1 + 0.1, 0), [±0.00 level floor], size: 3.6pt, fill: gray, anchor: "west")
  // the sink window, the trough under it and the spout
  rect((sink.y.at(0), sink.sill), (sink.y.at(1), sink.head), fill: rgb("#9fcbe0").transparentize(30%), stroke: 0.8pt + blue); T(((sink.y.at(0) + sink.y.at(1)) / 2, sink.head + 0.15), [sink window y #r2(sink.y.at(0))–#r2(sink.y.at(1)) · +#f2(sink.sill) … +#f2(sink.head) · the trough and the fall in its view], size: 3.8pt, fill: blue)
  rect((trough.at(1), 0), (trough.at(3), trim), fill: stone, stroke: 0.4pt + ink); rect((wb.at(1), trim - 0.12), (wb.at(3), wlevel), fill: water, stroke: none)
  rect((spout-y - 0.08, spout-z - 0.04), (spout-y + 0.08, spout-z + 0.04), fill: rgb("#9c6b3c"), stroke: none); line((spout-y, spout-z - 0.04), (spout-y, wlevel + 0.02), stroke: 1.2pt + blue)
  T(((trough.at(1) + trough.at(3)) / 2, trim + 0.15), [the trough · rim #lv(trim) · water #lv(wlevel) · the spout #lv(spout-z) falls #r2(spout-z - wlevel)], size: 3.6pt)
  T((skimmer.at(1) + 0.1, 0.3), [skimmer], size: 3pt); T((pump.at(1) + 0.2, 0.3), [pump (dry)], size: 3pt)
  // the olive in front of the trough (1.95 m before the wall): the pot, the trunk, the crown over the jet
  rect((olive.cy - olive.r, 0), (olive.cy + olive.r, 0.8), fill: rgb("#b48a5a").transparentize(25%), stroke: 0.4pt + ink); line((olive.cy, 0.8), (olive.cy, olive.head.at(0) + 0.4), stroke: 2.2pt + rgb("#6b4a2a"))
  circle((olive.cy, (olive.head.at(0) + olive.head.at(1)) / 2), radius: olive.crown, fill: green.transparentize(45%), stroke: 0.5pt + green.darken(20%)); T((olive.cy, (olive.head.at(0) + olive.head.at(1)) / 2), [olive · crown +#f2(olive.head.at(0))…+#f2(olive.head.at(1))\ #r2(cx1 - olive.cx) m before the wall, in the jet's path], size: 3.4pt, fill: white)
  T((olive.cy, 0.4), [fixed pot Ø #r2(2 * olive.r)], size: 3.2pt, fill: white)
  // the jet's band at the olive (height), from the outlet behind the viewer's left
  rect((olive.cy - 0.9, jet-bot-olive), (olive.cy + 0.9, jet-top-olive), fill: blue.transparentize(85%), stroke: (paint: blue, thickness: 0.4pt, dash: "dashed")); T((olive.cy + 1.35, (jet-bot-olive + jet-top-olive) / 2), [the jet at the trunk\ #lv(jet-bot-olive)…#lv(jet-top-olive)], size: 3.2pt, fill: blue)
  // the jasmine wire and the light strip; the wall otherwise plain render (no TV)
  for k in range(6) { line((10.0 + k * 0.5, 0.3), (10.0 + k * 0.5, 2.6), stroke: (paint: green.darken(20%), thickness: 0.5pt, dash: "dotted")) }; T((11.3, 2.8), [jasmine on wires · a warm light strip at +0.3 behind it], size: 3.4pt, fill: green.darken(20%))
  T((11.3, 1.5), [plain rendered wall: no TV], size: 3.4pt, fill: amber)
  // the 3-seat sofa in front (the south strip), the eye line
  rect((furn.at(0).at(1), 0), (furn.at(0).at(3), 0.42), fill: rgb("#b48a5a").transparentize(40%), stroke: (paint: ink, thickness: 0.3pt, dash: "dashed")); T(((furn.at(0).at(1) + furn.at(0).at(3)) / 2, 0.6), [the 3-seat sofa (in front, on the south strip) · seat +0.42 · eye ≈ +1.15 · faces the olive and the trough], size: 3.4pt, fill: luma(90))
  line((cy0, 1.15), (cy1, 1.15), stroke: (paint: gray, thickness: 0.4pt, dash: "dotted"))
  for (z, l) in ((trim, [#lv(trim)]), (spout-z, [#lv(spout-z)]), (1.15, [eye #lv(1.15)])) { T((cy1 + 0.1, z), l, size: 3.6pt, fill: gray, anchor: "west") }
  T((cy0, -0.55), [N], size: 4.4pt, anchor: "west"); T((cy1, -0.55), [S], size: 4.4pt, anchor: "east")
  T(((cy0 + cy1) / 2, 4.55), [the kitchen wall from the seating (looking east) · 1 m = 0.85 cm], size: 4.4pt, fill: accent)
})
#elev()
#v(4pt)
#grid(columns: (0.95fr, 1.2fr), gutter: 12pt,
  [
    #H[4 · The kitchen wall: the trough under the window, the spout, the jasmine]
    - *The trough* #r2(trough.at(2) - trough.at(0)) × #r2(trough.at(3) - trough.at(1)) against the wall face in front of the sink window (y #r2(trough.at(1))–#r2(trough.at(3))), rim #lv(trim): a *spout* (a short copper or bronze lip, Ø 25) at #lv(spout-z) at the north end, under the window, gives a calm fall of #r2(spout-z - wlevel) m heard from every seat (≈ 45–50 dB(A) at 2 m, assumed) and keeps the surface moving; the flow runs south to the *skimmer basket* (emptied by hand: the olive's leaves); the pump (≈ 40 W, a float switch) dry under the spout, a hatch in the rim; the trough tanked, its drain and overflow into the wall-foot drain's pipe (the rain system).
    - *The sink's view:* the rim and the water right under the sill (+#f2(sink.sill)), the fall at the window's north end; the olive's trunk #r2(cx1 - olive.cx) m beyond, its crown from +#f2(olive.head.at(0)) in the window's top (above the eye at the sink, ≈ +1.6): the window not blocked, the seating and the riwaq seen past the trunk.
    - *The wall* south of the trough plain render: the *jasmine* on stainless wires (y 10.0–12.6) with a warm light strip behind it at +0.3; the armchair #r2(gap-wall) m off the wall.
    #H[5 · Drainage on a level floor]
    - *Falls:* the inside floors ±0.00; the courtyard finish at the three glass lines and the riwaq door at *#lv(D.court_at_glass)* (a #r2(-D.court_at_glass * 1000) mm threshold, R-08), falling *#str(calc.round(D.fall * 100, digits: 1)) % away from the glass* across the floor to the kitchen wall foot at *#lv(D.court_at_wall)*: no step, a 45 mm difference over the width that nobody feels; the covered pocket falls the same way.
    - *Linear drains:* a slot drain with a silt basket *along the kitchen wall foot* south of the trough (y #r2(D.linear_drains.at(0).at(1))–#r2(D.linear_drains.at(0).at(3)); the trough's and the pot's pipes join it) takes the whole floor; a short slot drain *at the riwaq door's threshold* (wind-driven rain at the door, under the door path); the olive's saucer pipe (Ø 32 in the build-up) runs east to the wall-foot drain's pipe. *Overflow route:* a second gully at the south-east corner (rim #lv(D.overflow_rim)), its own pipe east, so a blocked drain floods the courtyard 3 cm, never the rooms.
    - *Pipes:* east under the kitchen floor (invert #lv(D.pipe_z), 1 % fall) to the *east RAIN chamber* and the soakaway (`studies/plumbing.typ`): *never into the foul system*. *Waterproofing:* one membrane over the courtyard slab (lowered 0.05 for the build-up), up 0.15 behind the glass plinths and the kitchen wall base; the trough tanked separately.
    - *Engineer / MEP to confirm:* the drains and pipes, the rain chamber, the pump's circuit, the pot's point load (≈ 1.2 t, mid-slab), the lighting and two sockets.
  ],
  [
    #H[6 · Dimensions (clear, between finished faces)]
    #table(columns: (1.6fr, auto, 1.6fr), inset: 2.4pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      [*Item*], [*m*], [*Note*],
      [Courtyard clear, level], [#r2(cx1 - cx0) × #r2(cy1 - cy0)], [the L ≈ #r2(court-area) m² clear (27.19 on axes); no step],
      [Malqaf chamber], [#r2(core.at(2) - core.at(0)) × #r2(core.at(3) - core.at(1))], [x 4.25–5.80 on axes: the west wall on the riwaq's line, the east wall 0.30 on the column line],
      [Seating zone (level)], [#r2(zone-area) m² free], [open #r2(barea(zone-open)) − trough #r2(barea(trough)) + covered pocket #r2(barea(zone-cov))],
      [Door path], [#r2(path.at(3) - path.at(1)) wide], [from the sliding door east to x #r2(path.at(2)); kept free (≥ 0.9)],
      [Furniture], [#seats seats], [a 3-seat sofa, a 2-seat sofa, an armchair (every seat with a back), a low table; movable],
      [The olive's pot], [Ø #r2(2 * olive.r) × 0.8], [x #r2(pot-box.at(0))–#r2(pot-box.at(2)), y #r2(pot-box.at(1))–#r2(pot-box.at(3)), on the jet's axis; head +#f2(olive.head.at(0))…+#f2(olive.head.at(1)); ≈ 1.2 t],
      [Cleaning strips], [#r2(gap-south) S · #r2(gap-majlis) N · #r2(gap-wall) E · #r2(gap-trough) at the trough], [living glass / majlis glass / kitchen wall / the trough's rim],
      [Trough], [#r2(trough.at(2) - trough.at(0)) × #r2(trough.at(3) - trough.at(1)) × #r2(wdepth)], [under the sink window, y #r2(trough.at(1))–#r2(trough.at(3)); rim #lv(trim), water #lv(wlevel), spout #lv(spout-z); walls #r2(twall)],
      [Malqaf outlet (H2 / B)], [#r2(gy1 - gy0) × #r2(gz1 - gz0)], [y #r2(gy0)–#r2(gy1), #lv(gz0)…#lv(gz1); louvres fixed 15° SE; #str(calc.round(plan-over * 100)) % of the jet's width over the water at the wall],
      [TV], [none], [removed with its surround (owner, 10 Nov 2026)],
      [Levels], [#lv(D.court_at_glass) / #lv(D.court_at_wall)], [glass lines / wall foot; overflow #lv(D.overflow_rim); invert #lv(D.pipe_z)],
    )
    #v(2pt)
    #H[What changed and where]
    - *3 Nov 2026:* the level floor. *10 Nov 2026:* no TV; the core's face straight; *H2* (`studies/malqaf_outlet_B.typ`, `studies/air_system.typ`): the outlet raised, the trough and the olive's pot in place of the planter and the tree. *11 Nov 2026 (owner):* the riwaq's line straight (the chamber's west wall on x 4.25); the order outlet → olive → water (the trough under the window, the olive in the jet, the louvres 15°); the seating extended under the projection (six seats, a 1.1 m door path).
    - *Next release:* `3d/character.yaml`, the 3D, `3d/params.yaml`, the DXFs, `studies/plumbing.typ`, `PROJECT_V10.md`, `DESIGN_LANGUAGE.md`.
  ],
)

// malqaf_outlet_B.typ · Taif / Palm House V10.0 · OPTION B · ADOPTED by the owner on 10 Nov 2026 as part of the courtyard layout H2 (studies/courtyard_haven.typ Phase 4; applied in studies/air_system.typ `air-outlet`, studies/courtyard_layout.typ, design_gf.typ and the presentation's sheet 02). Was the study option B:
// re-orient the malqaf outlet toward the tree and water enclosure so the breeze passes OVER the water and UNDER the tree before it reaches the seating,
// against the layout of 10 Nov 2026 (option A: the outlet low on the core's east face, louvres aimed south-east, six seats facing the outlet arch and the enclosure).
// Reads studies/air_system.typ (the outlet, the breeze estimate), 3d/character.yaml (the enclosure), studies/courtyard_layout.typ's furniture of 10 Nov 2026 (copied here).
// CSV frame: x east, y south, wall centre lines; levels above the finished ground floor. Every figure assumed; the MEP engineer confirms.
#import "@preview/cetz:0.4.2"
#import "air_system.typ": air-outlet, mean-eve, outlet-free, louvre-free, gentle
#set page(paper: "a4", flipped: true, margin: 9mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 7.3pt)
#set par(leading: 0.42em)
#let green = rgb("#2f6b4f"); #let ink = rgb("#26302b"); #let gray = rgb("#6d736f"); #let red = rgb("#b5452f"); #let amber = rgb("#b07a1f"); #let blue = rgb("#1f7a99"); #let water = rgb("#bcd9ea"); #let leaf = rgb("#7fa25a")
#let H(t) = block(above: 5pt, below: 3pt, text(9pt, weight: "bold", fill: green, t))
#let r1(v) = str(calc.round(v, digits: 1)); #let r2(v) = str(calc.round(v, digits: 2))
#let q(p) = (p.at(0), -p.at(1))

// ---------- the courtyard (clear faces), the core, the enclosure ----------
#let C = yaml("../3d/character.yaml").courtyard_layout
#let cx0 = 4.35; #let cx1 = 8.85; #let cy0 = 6.6; #let cy1 = 12.9          // the finished faces
#let edge = 5.925                                                           // the soffit edge; the core's east face 5.95 (10 Nov 2026)
#let core = (4.3, 6.4, 5.95, 8.767)                                         // the malqaf core's outer faces
#let (ex0, ey0, ex1, ey1) = C.enclosure.box
#let pb = C.enclosure.planter.inside; #let wb = C.enclosure.water.inside
#let tree = C.enclosure.tree; #let crown-c = ((pb.at(0) + pb.at(2)) / 2, (pb.at(1) + pb.at(3)) / 2)
#let wrim = C.enclosure.water.rim; #let crown-bottom = tree.crown_centre - tree.crown_radius
#let zone = (5.925, 7.1, 8.85, 12.3)
// ---------- option A (10 Nov 2026, the committed layout) ----------
#let out-A = (y0: 7.1, y1: 8.5, z0: 0.10, z1: 1.10, aim: 35deg, label: [low on the east face, louvres aimed south-east])
#let furn-A = (
  (7.4, 9.8, 8.25, 11.3, "sofa", "W", [sofa A · 2 seats · faces W: the outlet arch]),
  (6.85, 11.45, 8.25, 12.3, "sofa", "N", [sofa B · 2 seats · faces N: the tree and the water]),
  (6.0, 9.6, 6.75, 10.35, "armchair", "E", [armchair 1 · faces E]),
  (6.0, 11.0, 6.75, 11.75, "armchair", "E", [armchair 2 · faces E]),
  (6.6, 10.4, 7.3, 10.9, "table", "", [table]),
)
// ---------- option B (this study): the outlet raised and turned, the seating downstream of the water ----------
#let out-B = (y0: 6.9, y1: 8.3, z0: 0.60, z1: 1.60, aim: 30deg, label: [raised, centred in the bay, the reveals splayed and the louvres fixed 30° to the south-east: at the trough])
#let furn-B = (
  (6.4, 10.3, 8.2, 11.15, "sofa", "N", [sofa · 3 seats · faces N: the water 0.8 m ahead, the tree, the outlet beyond]),
  (6.0, 11.4, 6.75, 12.15, "armchair", "E", [armchair 1 · faces E, across the table]),
  (7.5, 11.4, 8.25, 12.15, "armchair", "W", [armchair 2 · faces W]),
  (6.85, 11.45, 7.45, 11.95, "table", "", [table]),
)
#let seats(F) = F.map(f => if f.at(4) == "sofa" { if f.at(2) - f.at(0) >= 1.6 { 3 } else { 2 } } else if f.at(4) == "armchair" { 1 } else { 0 }).sum()
// the jet: axis from the outlet's centre at the aim angle (south of east); the half-angle of spread 10°; velocity at the louvres from the air study (the mean summer-evening wind)
#let v0 = mean-eve.q / outlet-free
#let jet-axis(o, s) = { let c = (5.95, (o.y0 + o.y1) / 2); (c.at(0) + s * calc.cos(o.aim), c.at(1) + s * calc.sin(o.aim)) }
#let d0 = calc.sqrt(4 * outlet-free / calc.pi)                               // the equivalent diameter of the free area
#let v-at(s) = v0 * calc.min(1, 6.2 * d0 / calc.max(s, 0.01)) * 0.75           // a louvred jet: the core ≈ 6 d0, then 1/s decay; 0.75 for the louvres' losses (assumed)
#let dist-to(o, f) = { let c = (5.95, (o.y0 + o.y1) / 2); let fc = ((f.at(0) + f.at(2)) / 2, (f.at(1) + f.at(3)) / 2); calc.sqrt(calc.pow(fc.at(0) - c.at(0), 2) + calc.pow(fc.at(1) - c.at(1), 2)) }
#let off-axis(o, f) = { let c = (5.95, (o.y0 + o.y1) / 2); let fc = ((f.at(0) + f.at(2)) / 2, (f.at(1) + f.at(3)) / 2); let dx = fc.at(0) - c.at(0); let dy = fc.at(1) - c.at(1); calc.abs(-dx * calc.sin(o.aim) + dy * calc.cos(o.aim)) }
#let v-seat(o, f) = { let s = dist-to(o, f); let w = 0.6 + s * calc.tan(10deg) + 0.35; let k = calc.max(0, 1 - off-axis(o, f) / w); v-at(s) * (0.35 + 0.65 * k) }   // the jet's velocity at the seat, falling off across the jet (assumed)
// clearances
#let gap-wall(F) = cx1 - calc.max(..F.map(f => f.at(2)))
#let gap-south(F) = cy1 - calc.max(..F.map(f => f.at(3)))
#let gap-majlis(F) = calc.min(..F.map(f => f.at(1))) - cy0
#let walk(F) = calc.min(..F.map(f => f.at(0))) - edge
#let ok-clear(F) = gap-wall(F) >= 0.6 - 1e-6 and gap-south(F) >= 0.6 - 1e-6 and gap-majlis(F) >= 0.5 - 1e-6 and walk(F) >= -1e-6 and F.all(f => f.at(0) >= zone.at(0) - 1e-6 and f.at(2) <= zone.at(2) + 1e-6 and f.at(1) >= zone.at(1) - 1e-6 and f.at(3) <= zone.at(3) + 1e-6) and F.all(f => f.at(2) <= ex0 or f.at(1) >= ey1)
#let overlap(a, b) = a.at(0) < b.at(2) and b.at(0) < a.at(2) and a.at(1) < b.at(3) and b.at(1) < a.at(3)
#let no-overlap(F) = range(F.len()).all(i => range(i + 1, F.len()).all(j => not overlap(F.at(i), F.at(j))))
// the jet's vertical passage over the trough and under the crown (B): the jet's bottom and top at the trough (s to the trough's near rim) with ±10° spread
#let s-trough = { let c = (5.95, (out-B.y0 + out-B.y1) / 2); calc.sqrt(calc.pow(wb.at(0) - c.at(0), 2) + calc.pow(wb.at(1) - c.at(1), 2)) }
#let jet-bot = out-B.z0 - s-trough * calc.tan(10deg); #let jet-top = out-B.z1 + s-trough * calc.tan(10deg)
#let over-water = (jet-top - calc.max(jet-bot, wrim)) / (jet-top - jet-bot)   // the share of the jet's depth that clears the trough's rim
#let checks = (
  ([option A: six seats, every seat with a back, the clearances kept (walkway #r2(walk(furn-A)) east of the soffit edge, #r2(gap-south(furn-A)) at the living glass, #r2(gap-majlis(furn-A)) at the majlis glass, #r2(gap-wall(furn-A)) at the kitchen wall), no overlap], seats(furn-A) == 6 and ok-clear(furn-A) and no-overlap(furn-A)),
  ([option B: #seats(furn-B) seats with backs downstream of the water (all south of y #r2(ey1)), the same clearances (#r2(walk(furn-B)) · #r2(gap-south(furn-B)) · #r2(gap-majlis(furn-B)) · #r2(gap-wall(furn-B))), no overlap], seats(furn-B) == 5 and ok-clear(furn-B) and no-overlap(furn-B) and furn-B.all(f => f.at(1) >= ey1)),
  ([option B's outlet 1.4 × 1.0 fits the first bay (y #r2(out-B.y0)–#r2(out-B.y1) between the column faces 6.65–8.52) on the core's east face; the jet's top (#r2(jet-top) at the trough) stays under the crown (#r2(crown-bottom)); #str(calc.round(over-water * 100)) % of its depth clears the rim #r2(wrim)], out-B.y0 >= 6.65 and out-B.y1 <= 8.52 and jet-top <= crown-bottom and over-water >= 0.5),
)
#let all-ok = checks.all(c => c.at(1))

// ---------- drawing ----------
#let plan(o, F, title, length: 1.12cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, t, size: 3.6pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, t))
  let R(b, fill: none, stroke: none) = rect(q((b.at(0), b.at(1))), q((b.at(2), b.at(3))), fill: fill, stroke: stroke)
  R((cx0 - 0.25, cy0 - 0.25, cx1 + 0.25, cy1 + 0.25), fill: luma(200))
  R((cx0, cy0, cx1, cy1), fill: rgb("#e4d6b8"))
  R((cx0, cy0, edge, cy1), fill: rgb("#ece4cf")); line(q((edge, cy0)), q((edge, cy1)), stroke: (paint: ink, thickness: 0.6pt, dash: "dashed"))
  R(core, fill: luma(60)); T((5.1, 7.6), [malqaf\ core], size: 3.6pt, fill: white)
  for y in (6.5, 13.0) { circle(q((5.8, y)), radius: 0.2, fill: luma(60), stroke: none) }
  circle(q((5.8, 10.8333)), radius: 0.125, fill: luma(120), stroke: 0.3pt + ink)
  // the enclosure
  R(C.enclosure.box, fill: rgb("#c9a86a"), stroke: 0.4pt + ink); R(pb, fill: rgb("#8d7a58")); R(wb, fill: water, stroke: 0.3pt + ink)
  circle(q(crown-c), radius: tree.crown_radius, fill: leaf.transparentize(55%), stroke: (paint: leaf.darken(20%), dash: "dashed", thickness: 0.5pt))
  T(((wb.at(0) + wb.at(2)) / 2, (wb.at(1) + wb.at(3)) / 2), [water · rim #r2(wrim)], size: 3pt); T(crown-c, [tree · crown\ #r1(crown-bottom)–#r1(tree.crown_centre + tree.crown_radius)], size: 3pt, fill: white)
  // the outlet and the jet
  line(q((5.95, o.y0)), q((5.95, o.y1)), stroke: 3.5pt + rgb("#9c6b3c")); T((6.1, (o.y0 + o.y1) / 2), [outlet 1.4 × 1.0\ #r2(o.z0)…#r2(o.z1)], size: 3pt, fill: rgb("#9c6b3c"), anchor: "west", angle: 90deg)
  let c = (5.95, (o.y0 + o.y1) / 2)
  let s1 = 3.6
  let e1 = jet-axis(o, s1)
  let wl = 0.7 + s1 * calc.tan(10deg)
  let n = (-calc.sin(o.aim), calc.cos(o.aim))
  line(q((c.at(0), c.at(1) - 0.7)), q((e1.at(0) + n.at(0) * wl * -1, e1.at(1) + n.at(1) * wl * -1)), q((e1.at(0) + n.at(0) * wl, e1.at(1) + n.at(1) * wl)), q((c.at(0), c.at(1) + 0.7)), close: true, fill: blue.transparentize(80%), stroke: none)
  line(q(c), q(e1), stroke: (paint: blue, thickness: 0.8pt, dash: "dashed"), mark: (end: "stealth", fill: blue, scale: 0.5))
  // the seating zone and the furniture
  R(zone, stroke: (paint: amber, thickness: 0.5pt, dash: "dashed"))
  for f in F {
    R((f.at(0), f.at(1), f.at(2), f.at(3)), fill: if f.at(4) == "table" { rgb("#fbf4e6") } else { rgb("#b48a5a") }, stroke: 0.4pt + ink)
    if f.at(4) != "table" {
      let fc = ((f.at(0) + f.at(2)) / 2, (f.at(1) + f.at(3)) / 2)
      let d = if f.at(5) == "N" { (0, -0.3) } else if f.at(5) == "W" { (-0.3, 0) } else { (0.3, 0) }
      line(q(fc), q((fc.at(0) + d.at(0), fc.at(1) + d.at(1))), stroke: 0.6pt + white, mark: (end: "stealth", fill: white, scale: 0.4))
      T(fc, [#f.at(4)\ #r1(v-seat(o, f)) m/s], size: 2.9pt, fill: white)
    }
  }
  // the glass lines and the riwaq door
  line(q((cx0, 9.1)), q((cx0, 10.5)), stroke: 3pt + red); T((cx0 - 0.1, 9.8), [riwaq door], size: 3pt, fill: red, anchor: "east", angle: 90deg)
  T(((cx0 + cx1) / 2, cy0 - 0.4), [women's majlis glass], size: 3pt, fill: gray); T(((cx0 + cx1) / 2, cy1 + 0.4), [living glass], size: 3pt, fill: gray); T((cx1 + 0.4, 11.0), [kitchen wall], size: 3pt, fill: gray, angle: 90deg)
  T(((cx0 + cx1) / 2, cy0 - 0.9), title, size: 4.6pt, fill: green)
})
#let seat-rows(o, F) = F.filter(f => f.at(4) != "table").map(f => ([#f.at(6)], [#r1(dist-to(o, f)) m], [#r1(v-seat(o, f))])).flatten()

// ====================================================================================== THE COMPARISON SHEET
#text(13pt, weight: "bold", fill: green)[The malqaf outlet turned toward the water · option B against the layout of 10 Nov 2026 (A) · ADOPTED (H2, 10 Nov 2026)]
#v(1pt)
#block(fill: rgb("#e4eedf"), inset: 3pt, radius: 2pt, width: 100%)[#text(8pt, weight: "bold", fill: green)[ADOPTED (owner, 10 Nov 2026, with the courtyard layout H2 of studies/courtyard_haven.typ):] #text(7pt)[the outlet 1.4 × 1.0 at y 6.9–8.3, +0.60…+1.60, the louvres fixed 30° south-east; the final seating (a 3-seat sofa facing the water, two armchairs, the olive in its fixed pot) and the water trough are in `studies/courtyard_layout.typ`; the tree and the enclosure drawn here are the earlier ones.]]
#v(1pt)
#text(7.4pt, fill: gray)[The owner's question (10 Nov 2026): re-orient the outlet toward the tree and water enclosure so the air passes over the water and under the tree before the seating; the seats downstream of the water, every seat with a back, the same clearances; the old outlet face a plain rendered wall flush with the columns. *Where the outlet can go:* the core's north face is the women's majlis wall (nothing can open there); its west face is the riwaq; its south face the covered strip and the door: the courtyard outlet can only be on the *east face*, in the first arcade bay (y 6.65–8.52 between the column faces), as a *turned* outlet: the opening kept at 1.4 × 1.0, *raised* to +#r2(out-B.z0)…+#r2(out-B.z1) so the jet clears the trough's rim (+#r2(wrim)) and the louvres *fixed* 30° to the south-east toward the trough, the reveals splayed the same way. Velocities at the louvres #r1(v0) m/s at the summer-evening mean wind (`studies/air_system.typ`; #r1(gentle.q / outlet-free) m/s in a gentle wind); the figures at the seats are a free-jet estimate (±30 %), the MEP engineer confirms.]
#v(3pt)
#grid(columns: (auto, auto, 1fr), column-gutter: 8pt,
  plan(out-A, furn-A, [A · 10 Nov 2026: the outlet low (+0.10…+1.10), aimed south-east; 6 seats]),
  plan(out-B, furn-B, [B · the outlet raised (+0.60…+1.60) and turned 30° at the trough; 5 seats downstream]),
  [
    #H[Air at the seats (m/s at the summer-evening mean wind; the jet's axis dashed, its spread shaded)]
    #table(columns: (1fr, auto, auto), inset: 2pt, stroke: 0.4pt + luma(175), fill: (_, y) => if y == 0 { rgb("#e4eedf") },
      [*A · seat*], [*from the outlet*], [*≈ m/s*], ..seat-rows(out-A, furn-A))
    #v(2pt)
    #table(columns: (1fr, auto, auto), inset: 2pt, stroke: 0.4pt + luma(175), fill: (_, y) => if y == 0 { rgb("#e4eedf") },
      [*B · seat*], [*from the outlet*], [*≈ m/s*], ..seat-rows(out-B, furn-B))
    #v(2pt)
    #H[Clearances (both keep them)]
    #table(columns: (1fr, auto, auto), inset: 2pt, stroke: 0.4pt + luma(175), fill: (_, y) => if y == 0 { rgb("#e4eedf") },
      [*Path*], [*A*], [*B*],
      [colonnade walkway: nothing west of the soffit edge (x #r2(edge))], [#r2(walk(furn-A)) east ✓], [#r2(walk(furn-B)) east ✓],
      [at the living glass ≥ 0.60], [#r2(gap-south(furn-A))], [#r2(gap-south(furn-B))],
      [at the women's majlis glass ≥ 0.50], [#r2(gap-majlis(furn-A))], [#r2(gap-majlis(furn-B))],
      [at the kitchen wall (cleaning) ≥ 0.60], [#r2(gap-wall(furn-A))], [#r2(gap-wall(furn-B))],
      [seats · every one with a back], [#seats(furn-A) (2 + 2 + 1 + 1)], [#seats(furn-B) (3 + 1 + 1)],
    )
  ],
)
#v(3pt)
#grid(columns: (1fr, 1fr, 1fr), gutter: 10pt,
  [
    #H[The view from each sofa]
    - *A · sofa A* (faces west): the outlet arch, the core's rendered face and, above, the blind arch and the malqaf head against the sky; the tree at its right shoulder. *A · sofa B* (faces north): the tree and the water straight ahead, the women's majlis glass beyond, the outlet arch at its left. *The armchairs* (face east): the enclosure and the kitchen wall.
    - *B · the sofa* (faces north, 0.8 m from the trough): the water and the lip straight ahead, the tree's crown over it, the outlet arch at the left; nobody looks at the core's face. *The armchairs* face each other across the table, the water in the corner of the eye; the second sofa of A does not fit downstream without looking at the first one's back, so B seats *five*.
  ],
  [
    #H[The air path in B (the section on page 2)]
    - From the raised outlet (+#r2(out-B.z0)…+#r2(out-B.z1)) the jet runs 30° south of east: at the trough's near rim (#r1(s-trough) m) it spans +#r2(jet-bot)…+#r2(jet-top): *#str(calc.round(over-water * 100)) % of its depth passes over the water* (rim +#r2(wrim), water +#r2(C.enclosure.water.level)), the rest meets the trough's side; its top stays *under the tree's crown* (bottom +#r2(crown-bottom)) and through the crown's south-west edge; it reaches the kitchen wall beside the trough, spreads along the wall and settles on the sofa 0.8 m south of the water: ≈ #r1(v-seat(out-B, furn-B.at(0))) m/s there, a little cooler and moister for the 1 m of water (≈ −0.5 K, assumed) and with the tree's scent.
    - In A the jet leaves low (+0.10…+1.10) and runs south-east over the floor straight to sofa A and the armchairs (≈ #r1(v-seat(out-A, furn-A.at(0))) m/s at sofa A); it misses the water and the tree.
  ],
  [
    #H[What B costs · verdict for the owner]
    - *The outlet:* raised 0.5 m and centred in the bay (the air study, the 3D, the DXF, the facade of the core: the arch reads better with the opening centred); the dust trap and the louvres' reach unchanged. *The old low opening* closed: the face a plain rendered wall flush with the columns.
    - *Seats:* 5 instead of 6, every one with a back, all downstream of the water; a sixth seat only as a stool or a second sofa behind the first.
    - *Air:* A gives the stronger breeze at the seats (direct); B gives a gentler, cooler, scented breeze over the water, the family facing the water and the tree. Both keep the clearances.
    - *Recommendation:* if the owner values the water and the tree in front of the seats more than the sixth seat and the stronger direct jet, take B; otherwise keep A. Either way the outlet should be centred in the bay.
    #v(2pt)
    #text(7.5pt)[#if all-ok [*Option B study checks passed* (#checks.len())] else [*CHECKS FAILED:* #checks.filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]]
  ],
)

// ====================================================================================== PAGE 2 · the air path in section
#pagebreak()
#text(12pt, weight: "bold", fill: green)[Option B · the air path from the outlet over the water and under the tree to the sofa · section along the jet's axis]
#v(3pt)
#let sec(length: 1.3cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, t, size: 3.8pt, fill: ink, anchor: "center", angle: 0deg) = content(p, anchor: anchor, angle: angle, text(size, fill: fill, t))
  let L = 4.2   // the axis length drawn: the outlet face (s 0) to the kitchen wall (s ≈ 3.35) and a little beyond
  rect((0, -0.3), (L, 3.6), fill: rgb("#f3ece0"), stroke: 0.6pt + ink)
  rect((0, -0.3), (L, 0), fill: luma(120), stroke: none); line((0, 0), (L, 0), stroke: 0.6pt + ink); T((L + 0.1, 0), [±0.00], size: 3.4pt, fill: gray, anchor: "west")
  // the core's east wall (left) with the raised outlet, the kitchen wall (right)
  rect((-0.3, 0), (0, 3.52), fill: luma(60), stroke: none); T((-0.15, 1.9), [malqaf core · east wall], size: 3.4pt, fill: white, angle: 90deg)
  rect((-0.3, out-B.z0), (0, out-B.z1), fill: rgb("#9c6b3c"), stroke: none); T((0.1, out-B.z1 + 0.12), [outlet +#r2(out-B.z0)…+#r2(out-B.z1), louvres 30° SE], size: 3.4pt, anchor: "west")
  let sw = 3.35
  rect((sw, 0), (sw + 0.25, 3.52), fill: luma(60), stroke: none); T((sw + 0.125, 2.2), [kitchen wall], size: 3.4pt, fill: white, angle: 90deg)
  // the trough (s ≈ 2.2–3.35 along the axis: the trough's near rim to the wall), the water, the tree's crown over the planter corner
  rect((s-trough, 0), (sw, wrim), fill: rgb("#c9a86a"), stroke: 0.4pt + ink); rect((s-trough + 0.15, wrim - 0.1), (sw - 0.15, C.enclosure.water.level), fill: water, stroke: none)
  T(((s-trough + sw) / 2, wrim + 0.1), [raised trough · rim +#r2(wrim) · water +#r2(C.enclosure.water.level)], size: 3.3pt)
  circle((s-trough + 0.4, tree.crown_centre), radius: tree.crown_radius, fill: leaf.transparentize(50%), stroke: 0.4pt + leaf.darken(20%)); T((s-trough + 0.4, tree.crown_centre), [tree crown\ +#r2(crown-bottom)…+#r2(tree.crown_centre + tree.crown_radius)], size: 3.3pt)
  // the jet: ±10° from the outlet's sill and head
  line((0, out-B.z0), (s-trough, jet-bot), (sw, out-B.z0 - sw * calc.tan(10deg)), (sw, out-B.z1 + sw * calc.tan(10deg)), (s-trough, jet-top), (0, out-B.z1), close: true, fill: blue.transparentize(80%), stroke: none)
  line((0, (out-B.z0 + out-B.z1) / 2), (sw, (out-B.z0 + out-B.z1) / 2), stroke: (paint: blue, thickness: 0.8pt, dash: "dashed"), mark: (end: "stealth", fill: blue, scale: 0.5))
  T((1.1, (out-B.z0 + out-B.z1) / 2 + 0.15), [the jet · #r1(v0) m/s at the louvres · ±10°], size: 3.4pt, fill: blue)
  T((s-trough + 0.05, jet-bot - 0.12), [bottom +#r2(jet-bot) at the rim], size: 3.1pt, fill: blue, anchor: "west"); T((s-trough + 0.05, jet-top + 0.12), [top +#r2(jet-top) under the crown], size: 3.1pt, fill: blue, anchor: "west")
  // the sofa beyond the trough (south of it, drawn in projection) and the seated eye
  rect((sw - 0.9, 0), (sw - 0.05, 0.42), fill: rgb("#b48a5a").transparentize(40%), stroke: (paint: ink, thickness: 0.3pt, dash: "dashed")); T((sw - 0.47, 0.6), [the sofa (0.8 m south of the trough, beyond this section) · eye +1.15 · ≈ #r1(v-seat(out-B, furn-B.at(0))) m/s], size: 3.2pt, fill: luma(90))
  line((0, 1.15), (sw, 1.15), stroke: (paint: gray, thickness: 0.4pt, dash: "dotted"))
  line((0, 3.8), (1, 3.8), stroke: 1pt + ink); T((0.5, 3.95), [1 m · the section runs 30° south of east from the outlet's centre], size: 3.4pt)
})
#grid(columns: (auto, 1fr), gutter: 12pt,
  sec(),
  [
    #H[What the section shows]
    - The raised outlet puts the jet's *lower edge* at +#r2(jet-bot) and its *upper edge* at +#r2(jet-top) where it meets the trough's near rim (#r1(s-trough) m from the louvres): the water (+#r2(C.enclosure.water.level)) lies under the jet's upper #str(calc.round(over-water * 100)) %; the lower part strikes the trough's side and curls over it. The crown's bottom (+#r2(crown-bottom)) stays above the jet: *the air goes under the tree and over the water, then the kitchen wall turns it down and south* onto the sofa 0.8 m beyond.
    - The louvres fixed at 30° (the owner can still close them with the switch; the damper D2 behind them is unchanged); the splayed reveals keep the opening's 1.4 m width square to the arch and give the jet its direction without a visible duct.
    - *If A is kept:* only the raising / centring is worth taking (the opening centred in the bay, +0.60…+1.60 or +0.10…+1.10 as the owner prefers: the lower outlet gives the stronger breeze at ankle-to-knee height, the higher one at the body).
    #H[If B is adopted (the next release)]
    `studies/air_system.typ` (`air-outlet` → (5.8, #r2(out-B.y0), #r2(out-B.y1), #r2(out-B.z0), #r2(out-B.z1)), the louvres fixed 30° SE, the splayed reveals), `studies/courtyard_layout.typ` (the furniture B, 5 seats), `design_gf.typ` and the presentation's sheet 02 (the outlet line, the seating), `3d/params.yaml` (the outlet window), the 3D and the DXFs, `PROJECT_V10.md`; the MEP engineer confirms the jet. Nothing of this is applied now.
    #v(4pt)
    #block(fill: rgb("#f1efe8"), inset: 5pt, radius: 2pt, width: 100%)[
      #set text(lang: "ar", dir: rtl, size: 7.2pt)
      *الخيار B (دراسة، غير معتمد):* لا يمكن فتح مخرج الملقف في وجه النواة الشمالي (جدار مجلس النساء) ولا الغربي (الرواق) ولا الجنوبي (الممر والباب)؛ المخرج يبقى في الوجه الشرقي في أول قوس، لكنه *يُرفع* إلى +#r2(out-B.z0)…+#r2(out-B.z1) ويُوجَّه بشيش ثابت وعضادات مائلة 30° نحو حوض الماء، فيمر الهواء فوق الماء (نحو #str(calc.round(over-water * 100)) % من عمق التيار فوق حافة الحوض) وتحت تاج الشجرة ثم يرتد عن جدار المطبخ إلى الجلسة. *الجلسة* تصبح خلف الماء: كنبة بثلاثة مقاعد تواجه الماء والشجرة وكرسيان متقابلان حول الطاولة: خمسة مقاعد كلها بظهر (السادس لا يتسع إلا خلف الكنبة)؛ المسافات الخالية نفسها. الفتحة القديمة المنخفضة تُغلق ويصبح الوجه لياسة ملساء على خط الأعمدة. *المقارنة:* A نسيم أقوى ومباشر وستة مقاعد؛ B نسيم ألطف وأبرد قليلا فوق الماء والعائلة تواجه الماء والشجرة بخمسة مقاعد. لا يُطبّق شيء قبل موافقة المالك.
    ]
  ],
)

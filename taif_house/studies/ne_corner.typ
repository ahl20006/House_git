// ne_corner.typ · Taif / Palm House · SHORT STUDY (8 Nov 2026): the north-east corner simplified (owner's rule). STUDY ONLY: the design files are NOT changed.
// The rule: (1) bedroom 1 upstairs (the young children's room) a clean RECTANGLE of a good size, no slanted wall inside; (2) the malqaf shaft may take ANY shape that
// fills the corner (acute corners ≥ 60°), the leftover becomes a cupboard or shelves; above the roof the tower stays as adopted (V9.3); (3) the ground floor:
// (A) the present arrangement with straight walls, (B) the owner's swap (the maid ROOM takes the corner, the maid BATH along the kitchen wall).
// CSV frame (x east, y south, wall centre lines). Clear areas: the walls' half thicknesses edge by edge (0.125 outer, 0.10 for 200 mm, 0.05 for 100 mm partitions).
#import "@preview/cetz:0.4.2"
#set page(paper: "a4", flipped: true, margin: 8mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 7.4pt)
#set par(leading: 0.42em)
#let green = rgb("#2f6b4f"); #let ink = rgb("#26302b"); #let gray = rgb("#6d736f"); #let red = rgb("#b5452f"); #let amber = rgb("#b07a1f"); #let sky = rgb("#d4e9f1"); #let blue = rgb("#1f7a99")
#let H(t) = block(above: 5pt, below: 3pt, text(9pt, weight: "bold", fill: green, t))
#let r2(v) = str(calc.round(v, digits: 2))
#let sarea(P) = range(P.len()).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, P.len())); a.at(0) * b.at(1) - b.at(0) * a.at(1) }).sum() / 2
#let area(P) = calc.abs(sarea(P))
#let d2(a, b) = calc.sqrt(calc.pow(a.at(0) - b.at(0), 2) + calc.pow(a.at(1) - b.at(1), 2))
#let offset-poly(P, ds) = {
  let n = P.len(); let sg = if sarea(P) > 0 { 1 } else { -1 }
  let lines = range(n).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, n)); let L = d2(a, b)
    let d = ((b.at(0) - a.at(0)) / L, (b.at(1) - a.at(1)) / L); let nn = (-sg * d.at(1), sg * d.at(0))
    ((a.at(0) + nn.at(0) * ds.at(i), a.at(1) + nn.at(1) * ds.at(i)), d) })
  range(n).map(i => { let (p1, v1) = lines.at(calc.rem(i - 1 + n, n)); let (p2, v2) = lines.at(i)
    let cr = v1.at(0) * v2.at(1) - v1.at(1) * v2.at(0)
    if calc.abs(cr) < 1e-9 { p2 } else { let t = ((p2.at(0) - p1.at(0)) * v2.at(1) - (p2.at(1) - p1.at(1)) * v2.at(0)) / cr; (p1.at(0) + v1.at(0) * t, p1.at(1) + v1.at(1) * t) } }) }
#let angles(P) = { let n = P.len(); let sg = if sarea(P) > 0 { 1 } else { -1 }
  range(n).map(i => { let a = P.at(calc.rem(i - 1 + n, n)); let b = P.at(i); let c = P.at(calc.rem(i + 1, n))
    let u = (a.at(0) - b.at(0), a.at(1) - b.at(1)); let w = (c.at(0) - b.at(0), c.at(1) - b.at(1))
    let g = calc.atan2(u.at(0) * w.at(0) + u.at(1) * w.at(1), u.at(0) * w.at(1) - u.at(1) * w.at(0)).deg(); let a2 = if sg > 0 { 360 - g } else { g }
    if a2 < 0 { a2 + 360 } else if a2 >= 360 { a2 - 360 } else { a2 } }) }
#let rect4(x0, y0, x1, y1) = ((x0, y0), (x1, y0), (x1, y1), (x0, y1))
#let R(pts, ds, name) = (pts: pts, ds: ds, name: name)
#let clear(r) = area(offset-poly(r.pts, r.ds))
#let cx(y) = 10.461 + 2.85 / 5.245 * y                       // the cut wall's centre line

// ---------------------------------------------------------------- the geometry
// the shaft: the corner trapezoid north of y 1.0 (the cut tip): its west wall on x xs, its south wall on y 1.0; the angle at the cut 61.5° (≥ 60°)
#let xs-54 = 9.775                                            // breeze only (0.54 m² clear; the ground floor's HRV risers down the west shaft)
#let xs-90 = 9.336                                            // breeze + the HRV compartment (0.90 m² clear, as V9.3)
#let shaft(xs) = R(((xs, 0), (10.461, 0), (11.004, 1.0), (xs, 1.0)), (0.125, 0.125, 0.10, 0.10), "shaft")
#let shelf(xs) = R(rect4(8.95, 0, xs, 1.0), (0.125, 0.10, 0.05, 0.10), "cupboard")
// the ground floor
#let laundry = R(rect4(8.95, 2.8, 10.65, 7.0), (0.10, 0.05, 0.10, 0.10), "laundry")
#let A-bath = R(((8.95, 1.0), (11.004, 1.0), (11.982, 2.8), (8.95, 2.8)), (0.10, 0.125, 0.10, 0.10), "maid bath")
#let A-room = R(((10.65, 2.8), (11.982, 2.8), (13.311, 5.245), (13.311, 7.0), (10.65, 7.0)), (0.10, 0.125, 0.125, 0.10, 0.05), "maid room")
#let B-room = R(((8.95, 1.0), (11.004, 1.0), (13.311, 5.245), (13.311, 5.3), (10.65, 5.3), (10.65, 2.8), (8.95, 2.8)), (0.10, 0.125, 0.125, 0.10, 0.05, 0.05, 0.10), "maid room")
#let B-bath = R(rect4(10.65, 5.3, 13.311, 7.0), (0.10, 0.125, 0.10, 0.05), "maid bath")
// the first floor
#let ne-room = R(((8.95, 1.0), (11.004, 1.0), (13.311, 5.245), (13.311, 6.5), (10.15, 6.5), (10.15, 5.3), (8.95, 5.3)), (0.10, 0.125, 0.125, 0.10, 0.10, 0.10, 0.10), "corner room")
#let R1 = R(rect4(8.95, 1.0, 11.0, 5.3), (0.10, 0.10, 0.10, 0.10), "bedroom 1 (rectangle)")
#let R1-rest = R(((11.0, 1.0), (11.004, 1.0), (13.311, 5.245), (13.311, 6.5), (10.15, 6.5), (10.15, 5.3), (11.0, 5.3)), (0.10, 0.125, 0.125, 0.10, 0.10, 0.10, 0.10), "leftover")
#let kids = R(rect4(4.25, 0, 8.95, 3.0), (0.125, 0.10, 0.10, 0.10), "kids' room")
// the largest rectangle that fits the first-floor corner zone (x 8.95 → the cut, y → 5.3, the family link below): (1.511 + 0.5434 y0)(5.3 − y0), best at y0 ≈ 1.26
#let best-rect = range(0, 531).map(i => { let y0 = i / 100; ((cx(y0) - 8.95) * (5.3 - y0), y0) }).sorted(key: v => v.at(0)).last()

// ---------------------------------------------------------------- checks
#let checks = (
  ([the shaft's acute corner at the cut is ≥ 60° (#str(calc.round(calc.min(..angles(shaft(xs-54).pts)), digits: 1))°)], calc.min(..angles(shaft(xs-54).pts)) >= 60),
  ([the breeze-only shaft ≥ 0.54 m² clear (#r2(clear(shaft(xs-54)))), the full one ≈ 0.90 (#r2(clear(shaft(xs-90))))], clear(shaft(xs-54)) >= 0.54 and calc.abs(clear(shaft(xs-90)) - 0.90) < 0.03),
  ([the ground-floor rooms tile the corner (A and B: the same total on axes)], calc.abs(area(A-bath.pts) + area(A-room.pts) - area(B-room.pts) - area(B-bath.pts)) < 0.01),
  ([the largest rectangle in the first-floor corner is #r2(best-rect.at(0)) m² on axes (≤ 9): too small for "a good size"], best-rect.at(0) < 9.0),
  ([option B's maid bath is a rectangle; every room's corners are 90° (270° at the laundry's corner) or the cut's own 61.5° / 118.5° / 151.5°], angles(B-bath.pts).all(a => calc.abs(a - 90) < 0.1) and (A-bath, A-room, B-room).all(r => angles(r.pts).all(a => calc.abs(a - 90) < 0.5 or calc.abs(a - 118.5) < 1 or calc.abs(a - 61.5) < 1 or calc.abs(a - 151.5) < 1 or calc.abs(a - 270) < 0.5))),
)
#let all-ok = checks.all(c => c.at(1))

// ---------------------------------------------------------------- the plans
#let plan(rooms, labels, extra: none, title: []) = cetz.canvas(length: 0.62cm, {
  import cetz.draw: *
  let Q(p) = (p.at(0), -p.at(1))
  line(..((4.1, -0.125), (10.53, -0.125), (13.436, 5.22), (13.436, 7.2), (4.1, 7.2)).map(Q), close: true, fill: rgb("#3a3f3b"), stroke: none)
  for (r, c) in rooms { line(..offset-poly(r.pts, r.ds).map(Q), close: true, fill: c, stroke: none) }
  for (p, t) in labels { content(Q(p), text(4.6pt, t)) }
  if extra != none { extra }
  content(Q((4.2, 7.75)), anchor: "west", text(5.4pt, weight: "bold", fill: green, title))
})
#let sh-col = sky; #let cup-col = rgb("#e6e1d6"); #let wet = rgb("#d3e6ee"); #let srv = rgb("#dbe7ec"); #let fam = rgb("#f1e3c8"); #let grey = rgb("#ece8df")
#let channel = { import cetz.draw: *; line((10.4, -0.6), (10.2, -1.2), (10.2, -7.2), stroke: (paint: amber, thickness: 1.2pt, dash: "dashed")) }
#let panel(p0, p1) = { import cetz.draw: *; line((p0.at(0), -p0.at(1)), (p1.at(0), -p1.at(1)), stroke: 2.8pt + red) }

#text(13pt, weight: "bold", fill: green)[The north-east corner, simplified · a short study (the owner decides once) · Taif / Palm House]
#v(1pt)
#text(7.4pt, fill: gray)[STUDY ONLY, the design files unchanged (V9.3 stays until the owner decides). Above the roof the tower stays as adopted (the 1.25 m square, head (c), 3.5 m). The shaft here is *the corner trapezoid at the cut's tip* north of y 1.0 (its acute corner 61.5°, smooth-rendered); the leftover west of it a shelf cupboard. Clear areas as in the presentation's schedule.]
#v(3pt)
#grid(columns: (1fr, 1fr, 1fr), gutter: 6pt,
  plan(((shaft(xs-54), sh-col), (shelf(xs-54), cup-col), (A-bath, wet), (A-room, srv), (laundry, srv)),
    (((10.3, 0.5), [shaft #r2(clear(shaft(xs-54)))]), ((9.35, 0.5), [shelf]), ((9.9, 1.95), [maid bath\ #r2(clear(A-bath)) m²]), ((12.1, 5.4), [maid room\ #r2(clear(A-room)) m²]), ((9.8, 4.9), [laundry])),
    extra: { channel; panel((9.9, 1.0), (10.4, 1.0)) }, title: [GF (A) · the present arrangement, straight walls]),
  plan(((shaft(xs-54), sh-col), (shelf(xs-54), cup-col), (B-room, srv), (B-bath, wet), (laundry, srv)),
    (((10.3, 0.5), [shaft #r2(clear(shaft(xs-54)))]), ((9.35, 0.5), [cupb.]), ((11.2, 2.6), [maid room\ #r2(clear(B-room)) m²]), ((12.0, 6.15), [maid bath #r2(clear(B-bath)) m²]), ((9.8, 4.9), [laundry])),
    extra: { channel; panel((9.775, 0.3), (9.775, 0.75)) }, title: [GF (B) · the owner's swap: the maid room in the corner]),
  plan(((shaft(xs-54), sh-col), (shelf(xs-54), cup-col), (ne-room, grey), (kids, fam)),
    (((10.3, 0.5), [shaft]), ((9.35, 0.5), [shelves]), ((7.75, 1.45), [*young children's\ bedroom*\ (rectangle)\ #r2(clear(kids)) m² clear]), ((11.4, 3.9), [corner room:\ the kids' study\ + gaming\ #r2(clear(ne-room)) m²])),
    extra: { import cetz.draw: *
      for (x0, y0, x1, y1, l) in ((4.4, 0.95, 6.4, 2.35, [bed 1.4 × 2.0]), (7.0, 2.25, 8.8, 2.85, [wardrobe 1.8]), (6.6, 0.15, 7.9, 0.75, [desk])) { rect((x0, -y0), (x1, -y1), fill: white, stroke: 0.4pt + gray); content(((x0 + x1) / 2, -(y0 + y1) / 2), text(3.6pt, l)) }
      line((5.3, 0.06), (8.7, 0.06), stroke: 2pt + blue); content((7.0, 0.35), text(3.6pt, fill: blue)[escape window 3.4 m (kept)]) },
    title: [FF (recommended) · the young children's bedroom in the rectangle]),
)
#v(2pt)
#grid(columns: (1.15fr, 1fr), gutter: 10pt,
  [
    #H[1 · Upstairs: why a good rectangle does not fit the corner]
    - The cut wall runs *6.1 m*, the full depth of bedroom 1 (y 0 → 5.2), not a small corner. Any square-cornered room in the zone (x 8.95 → the cut, the family link below) touches the cut with one corner only; the largest is *#r2(best-rect.at(0)) m² on axes* (≈ 2.2 × 4.0, at y #r2(best-rect.at(1))). Drawn below with the corner shaft: *R1 #r2(clear(R1)) m² clear, 1.85 m wide*, and *no outer wall: no window at all* (its walls face the shaft, the kids' room, the family link and a ≈ #r2(clear(R1-rest)) m² leftover along the cut). It fails the rule's "good size" and the escape window.
    - *The way to keep the rule:* give the young children *the kids' room's rectangle* (4.7 × 3.0 on axes, *#r2(clear(kids)) m² clear*, its 3.4 m north window the escape window: a bed 1.4 × 2.0, a 1.8 m wardrobe, a desk), and turn the corner room into *the older children's study + gaming room* (#r2(clear(ne-room)) m² clear, its two windows on the cut; the slanted outer wall is no problem for a study). *The price:* the young children sleep ≈ 9 m from the suite's lobby instead of ≈ 1 m (along the family living); the master suite is unchanged.
    - *If the owner keeps the young children in the corner:* the corner room as above (#r2(clear(ne-room)) m², square inner walls, the cut its window wall) or V9.3's room; neither is a rectangle.
  ],
  [
    #cetz.canvas(length: 0.5cm, {
      import cetz.draw: *
      let Q(p) = (p.at(0), -p.at(1))
      line(..((8.5, -0.125), (10.53, -0.125), (13.436, 5.22), (13.436, 6.7), (8.5, 6.7)).map(Q), close: true, fill: rgb("#3a3f3b"), stroke: none)
      for (r, c) in ((shaft(xs-54), sky), (shelf(xs-54), cup-col), (R1, rgb("#f6d9c9")), (R1-rest, grey)) { line(..offset-poly(r.pts, r.ds).map(Q), close: true, fill: c, stroke: none) }
      content(Q((9.97, 3.2)), text(4.4pt)[R1\ #r2(clear(R1)) m²\ no window])
      content(Q((12.2, 5.0)), text(4.4pt)[leftover\ #r2(clear(R1-rest)) m²])
      content(Q((8.6, 7.3)), anchor: "west", text(5pt, weight: "bold", fill: red)[FF · R1: the rectangle in the corner (rejected)])
    })
  ],
)

// ======================================================================= PAGE 2
#pagebreak()
#text(12pt, weight: "bold", fill: green)[The comparison and the recommendation]
#v(3pt)
#let ok(b) = if b == 2 { text(fill: green)[●] } else if b == 1 { text(fill: amber)[◐] } else { text(fill: red)[○] }
#table(columns: (1.6fr, 1.1fr, 1fr, 1fr, 1.25fr, 1.25fr, 1.2fr), inset: 2.8pt, stroke: 0.4pt + luma(175), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f3f1ea") },
  [*Option*], [*Young children's bedroom*], [*Maid room*], [*Maid bath*], [*Shaft (clear) · cleaning*], [*Plumbing · breeze channel*], [*Reading*],
  [*V9.3 (today)*], [#ok(0) 15.10 m², a wall parallel to the cut inside (not a rectangle)], [8.41 m²], [3.04 m² + a store 0.56], [0.90 m² slim shaft · the panel from the maid bath], [the bath's drains must keep off the channel], [what the owner wants to replace],
  [*FF R1* (the rectangle in the corner)], [#ok(0) #r2(clear(R1)) m², 1.85 m wide, *no window*], [–], [–], [the corner trapezoid], [–], [rejected: too small, no window],
  [*GF (A) + FF recommended*], [#ok(2) #r2(clear(kids)) m² rectangle (the kids' room), escape window kept], [#r2(clear(A-room)) m² (unchanged)], [#r2(clear(A-bath)) m² on the cut (its vent window kept) + a shelf #r2(clear(shelf(xs-54)))], [#ok(2) #r2(clear(shaft(xs-54))) m² · the panel from the maid bath (a service room)], [#ok(1) east cluster; the bath *over* the channel: its WC / shower drains off the line], [simple; the constraint stays],
  [*GF (B) + FF recommended*], [#ok(2) #r2(clear(kids)) m² rectangle (the kids' room), escape window kept], [#r2(clear(B-room)) m² (in the corner, the escape window on the cut kept)], [#r2(clear(B-bath)) m² *rectangle* on the kitchen wall, a window in the east wall], [#ok(1) #r2(clear(shaft(xs-54))) m² · the panel through the room's cupboard], [#ok(2) the bath beside the east stack, *off the channel*; the channel under the maid room's floor (no cover in the room)], [*the cleanest plumbing and a straight bath*],
)
#text(6.4pt, fill: gray)[● good · ◐ acceptable with a condition · ○ fails the rule. The shaft in every new option is the corner trapezoid (#r2(area(shaft(xs-54).pts)) m² on axes, #r2(clear(shaft(xs-54))) m² clear, the acute corner #str(calc.round(calc.min(..angles(shaft(xs-54).pts)), digits: 1))°); with the HRV compartment kept it grows west to x #xs-90 (#r2(clear(shaft(xs-90))) m² clear) and the shelf shrinks to #r2(clear(shelf(xs-90))) m². Cleaning as adopted: the bird-mesh frames and the top damper from the 0.50 m roof hatch in the tower's south face; the sump from the 0.40 × 0.40 panel at the shaft's foot.]
#v(4pt)
#grid(columns: (1.2fr, 1fr), gutter: 12pt,
  [
    #H[Recommendation]
    - *Upstairs:* the young children's bedroom in *the kids' room's rectangle* (#r2(clear(kids)) m² clear, square corners, the 3.4 m north escape window; a bed 1.4 × 2.0, a 1.8 m wardrobe, a desk); the corner room becomes *the older children's study + gaming room* (#r2(clear(ne-room)) m² clear, its two cut windows kept, square inner walls, the shelf cupboard in the leftover). The only arrangement that gives the young children a clean rectangle of a good size; the corner itself cannot.
    - *The shaft:* *0.54 m², breeze only* (the corner trapezoid, x #xs-54 → the cut, y 0–1.0), the ground floor's two HRV risers *down the west shaft* (it serves the ground floor's middle better; ≈ 10 m of insulated duct inside the attic from the plant room, the west shaft's space to confirm with the MEP engineer). Better than 0.90: a smaller, purely aerodynamic shaft and a real 0.6 m shelf cupboard; the intake stays in the tower's head.
    - *Downstairs: (B), the owner's swap.* The maid bath becomes a plain rectangle on the kitchen wall beside the east stack, clear of the breeze channel (no drain constraint any more); the maid room keeps the corner, its escape window on the cut and the same size; the laundry unchanged. Its only weak point: the shaft's access panel opens inside the maid room's cupboard (no service room touches the shaft in (B)); a lockable panel, used twice a year.
    - *If the owner wants the young children next to the suite:* keep the corner room for them with square inner walls (#r2(clear(ne-room)) m²) and accept the cut as its window wall; it is not a rectangle.
  ],
  [
    #H[ملخص]
    #block(width: 100%)[#set text(lang: "ar", dir: rtl, font: ("Segoe UI", "Arial"), size: 8.6pt)
      #set par(leading: 0.62em)
      *النتيجة:* جدار القطع طوله نحو 6.1 م ويمتد بطول غرفة النوم 1 كلها، فأكبر غرفة مستطيلة تتسع في الركن نحو 8.9 م² على المحاور (عرضها 1.85 م صافيا) وبلا أي نافذة؛ فلا تصلح.
      #v(2pt)
      *التوصية:* غرفة الأطفال الصغار في غرفة الأطفال الحالية المستطيلة (12.5 م² صافيا، بنافذة هروب شمالية بعرض 3.4 م)، والركن يصبح غرفة دراسة وألعاب للأولاد الأكبر (15.7 م²). مجرى الملقف شبه منحرف في رأس الركن بمساحة 0.54 م² للنسيم فقط، وأنابيب التهوية للدور الأرضي تنزل في الشفت الغربي، والباقي رف خزانة.
      #v(2pt)
      *الدور الأرضي:* الخيار (ب) فكرة المالك: غرفة الخادمة في الركن بنافذة الهروب، وحمامها مستطيل على جدار المطبخ بجوار المجرى الشرقي وبعيدا عن مجرى النسيم. الثمن الوحيد: فتحة صيانة المجرى من داخل خزانة غرفة الخادمة.
    ]
  ],
)
#v(3pt)
#text(6.4pt, fill: gray)[Study checks #if all-ok [*passed* (#checks.len())] else [*FAILED*: #checks.filter(c => not c.at(1)).map(c => c.at(0)).join([; ])] · sources: data/rooms_gf.csv / rooms_ff.csv (V9.3), studies/malqaf_tower.typ, studies/air_system.typ. Concept only; every size assumed.]

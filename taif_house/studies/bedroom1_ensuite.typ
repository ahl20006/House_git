// bedroom1_ensuite.typ · Taif / Palm House · SHORT STUDY: bedroom 1 with a simple en-suite shower room (shower, WC, basin wall-hung on a service wall,
// over the laundry / maid wing below, within the east cluster) · 6 Nov 2026, after the cut wall moved outwards 0.12 m (B2 10.188, B3 y 5.749).
// NOT APPLIED: the owner decides. The best layout found is drawn; the numbers say plainly whether it works.
// CSV frame (design_gf.typ / rooms_ff.csv): x east, y south, wall centre lines; the walls 0.20 (0.10 each side) except the outer walls (0.125 inside).
#import "@preview/cetz:0.4.2"
#import "../base.typ": dist

#set page(paper: "a4", flipped: true, margin: 8mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 8pt)
#set par(leading: 0.4em)

// ---------- the room as now drawn (data/rooms_ff.csv, 6 Nov 2026) ----------
#let rooms-ff = csv("/data/rooms_ff.csv", row-type: dictionary)
#let pts-of(name) = { let r = rooms-ff.find(r => r.name == name); assert(r != none, message: "rooms_ff.csv: missing " + name); r.pts.split(";").map(p => { let v = p.trim().split(" ").map(float); (v.at(0), v.at(1)) }) }
#let bed1 = pts-of("Bedroom 1")
#assert(bed1.len() == 7 and calc.abs(bed1.at(1).at(0) - 10.731) < 1e-6 and calc.abs(bed1.at(2).at(1) - 5.749) < 1e-6, message: "bedroom 1 changed: re-read bedroom1_ensuite.typ")
#let cut-a = bed1.at(1); #let cut-b = bed1.at(2)                       // the cut wall between (10.731, 1) and (13.311, 5.749)
#let cut-x(y) = cut-a.at(0) + (y - cut-a.at(1)) * (cut-b.at(0) - cut-a.at(0)) / (cut-b.at(1) - cut-a.at(1))
#let in-off = 0.125 / (6.0 / calc.sqrt(3.26 * 3.26 + 36.0))        // the cut's inner face, measured in x: 0.125 / cos
#let cut-in(y) = cut-x(y) - in-off
#let link = ((8.95, 5.3), (10.15, 5.3), (10.15, 6.5), (8.95, 6.5))  // the family link: the room's door is on its north wall (y 5.3, x 9.05–10.05, ff_family.typ)
#let door-room = ((9.05, 5.3), (10.05, 5.3))
#let w-escape = ((cut-x(1.6), 1.6), (cut-x(3.2), 3.2))               // bedroom 1's escape window on the cut (ff_family.typ escape-windows)
#let w-2 = ((cut-x(4.15), 4.15), (cut-x(5.25), 5.25))                // its second window on the cut
#let gf-below = ((((8.95, 1), (10.731, 1), (11.709, 2.8), (8.95, 2.8)), [GF maid bath]), (((8.95, 2.8), (10.65, 2.8), (10.65, 7.0), (8.95, 7.0)), [GF laundry]), (((10.65, 2.8), (11.709, 2.8), (13.311, 5.749), (13.311, 7.0), (10.65, 7.0)), [GF maid room (a bedroom)]))
#let wet-x = 10.65                                                   // wet / service rooms below only WEST of the laundry / maid room partition

// ---------- the layout studied: the shower room in the north-west corner, the entry zone south of it, the bedroom east ----------
#let sr = (8.95, 1.0, 10.55, 3.4)                                    // the shower room 1.6 × 2.4 on centre lines (over the maid bath y 1–2.8 and the laundry 2.8–3.4)
#let rect-pts(x0, y0, x1, y1) = ((x0, y0), (x1, y0), (x1, y1), (x0, y1))
#let sr-pts = rect-pts(..sr)
#let vest = rect-pts(8.95, 3.4, 10.55, 5.3)                          // the entry zone inside the room's door (1.6 × 1.9): a wardrobe wall on its east side is NOT built; it opens east
#let sr-door = ((9.0, 3.4), (9.8, 3.4))                              // 0.80 m, in the shower room's south wall, from the entry zone
#let fixtures = ((9.05, 1.1, 10.45, 2.0, [walk-in shower 1.4 × 0.9]), (10.1, 2.1, 10.45, 2.7, [WC, wall-hung]), (9.95, 2.8, 10.45, 3.3, [basin]))   // all on the east (service) wall x 10.55: the stack drops into the laundry / maid bath below
#let furniture = ((10.65, 4.4, 12.05, 6.4, [bed 1.4 × 2.0, head south]), (10.55, 2.3, 11.15, 4.1, [wardrobe 1.8 × 0.6]), (12.15, 5.8, 13.18, 6.4, [desk 1.03 × 0.6]))
// the bedroom proper = the room minus the shower room (the entry zone stays part of it)
#let bedroom = ((10.55, 1.0), cut-a, cut-b, (13.311, 6.5), (10.15, 6.5), (10.15, 5.3), (8.95, 5.3), (8.95, 3.4), (10.55, 3.4))

// ---------- helpers ----------
#let area(P) = { let s = 0.0; let n = P.len(); for i in range(n) { let a = P.at(i); let b = P.at(calc.rem(i + 1, n)); s += a.at(0) * b.at(1) - b.at(0) * a.at(1) }; calc.abs(s) / 2 }
#let plen(P) = range(P.len()).map(i => dist(P.at(i), P.at(calc.rem(i + 1, P.len())))).sum()
#let clear(P) = area(P) - 0.1 * plen(P)                                // ≈ half a 0.20 wall off every edge (bedroom1_bath.typ's measure)
#let inside(p, P) = { let c = false; let n = P.len(); for i in range(n) { let (xi, yi) = P.at(i); let (xj, yj) = P.at(calc.rem(i + n - 1, n)); if ((yi > p.at(1)) != (yj > p.at(1))) and (p.at(0) < (xj - xi) * (p.at(1) - yi) / (yj - yi) + xi) { c = not c } }; c }
#let box-in(b, P) = { let (x0, y0, x1, y1) = (b.at(0), b.at(1), b.at(2), b.at(3)); let e = 0.001; ((x0 + e, y0 + e), (x1 - e, y0 + e), (x1 - e, y1 - e), (x0 + e, y1 - e), ((x0 + x1) / 2, (y0 + y1) / 2)).all(p => inside(p, P)) }
#let overlap(a, b) = not (a.at(2) <= b.at(0) + 1e-9 or b.at(2) <= a.at(0) + 1e-9 or a.at(3) <= b.at(1) + 1e-9 or b.at(3) <= a.at(1) + 1e-9)
#let f2(v) = { let r = calc.round(v, digits: 2); let s = str(r); if not s.contains(".") { s + ".00" } else if s.split(".").at(1).len() == 1 { s + "0" } else { s } }
#let r2(v) = str(calc.round(v, digits: 2))
#let bed-clear = clear(bedroom)
#let sr-clear = clear(sr-pts)
#let rect-clean = (10.65, 3.4, cut-in(3.4), 6.4)                      // the largest clean rectangle of the bedroom proper (east of the entry zone, south of the cut's narrow part)
#let rect-clean-area = (rect-clean.at(2) - rect-clean.at(0)) * (rect-clean.at(3) - rect-clean.at(1))
#let bed = furniture.at(0)
#let pass-east = calc.min(cut-in(bed.at(1)) - bed.at(2), 13.311 - 0.125 - bed.at(2))   // beside the bed on the east: the cut's inner face at the bed's head end
#let pass-foot = bed.at(1) - 3.4                                     // between the bed's foot and the wardrobe line / the entry zone
#let sr-over-wet = sr.at(2) <= wet-x + 1e-9 and sr.at(1) >= 1.0 - 1e-9 and sr.at(3) <= 7.0 + 1e-9
#let furn-ok = furniture.all(b => box-in(b, bedroom)) and range(furniture.len()).all(i => range(furniture.len()).all(j => i == j or not overlap(furniture.at(i), furniture.at(j))))
#let furn-vs-cut = furniture.all(b => b.at(2) <= cut-in(b.at(1)) + 1e-9)   // every piece's north-east corner inside the cut's inner face
#let fix-ok = fixtures.all(b => box-in(b, sr-pts)) and range(fixtures.len()).all(i => range(fixtures.len()).all(j => i == j or not overlap(fixtures.at(i), fixtures.at(j))))
#let checks = (
  ([the shower room lies over wet / service rooms only (the maid bath y 1–2.8, the laundry 2.8–#f2(sr.at(3)); west of the maid room's partition x #f2(wet-x)): its stack joins the east cluster], sr-over-wet),
  ([the shower room 1.6 × 2.4 holds the walk-in shower, the wall-hung WC and the basin on one service wall (x 10.55) without overlap], fix-ok),
  ([the bedroom proper keeps ≥ 10 m² clear (#f2(bed-clear) m²) with the bed 1.4 × 2.0, a 1.8 m wardrobe and a desk placed without overlap and inside the cut's inner face], bed-clear >= 10.0 and furn-ok and furn-vs-cut),
  ([the room's door (y 5.3, 1.00 m) and the escape window on the cut stay as drawn; the shower-room door 0.80 opens off the entry zone, not into the bed's space], sr-door.at(1).at(0) - sr-door.at(0).at(0) >= 0.8 - 1e-9 and sr-door.at(0).at(1) == sr.at(3)),
  ([the clean rectangle of the bedroom proper (#f2(rect-clean.at(2) - rect-clean.at(0)) × #f2(rect-clean.at(3) - rect-clean.at(1)) = #f2(rect-clean-area) m²) is SMALLER than the 10 m² the owner's brief asked for: the room works on paper, not as a clean room], rect-clean-area < 10.0),
)
#let all-ok = checks.all(c => c.at(1))

// ---------- drawing ----------
#let ink = rgb("#3d4a45"); #let accent = rgb("#2f6b4f"); #let red = rgb("#b5452f"); #let blue = rgb("#2f5f8a"); #let amber = rgb("#c98a12"); #let stone = rgb("#c9a86a")
#let q(p) = (p.at(0), -p.at(1))
#let plan = cetz.canvas(length: 1.55cm, {
  import cetz.draw: *
  let T(p, body, size: 5pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, body))
  let poly(P, fill: none, stroke: none) = line(..P.map(q), close: true, fill: fill, stroke: stroke)
  let R(b, fill: none, stroke: none) = rect(q((b.at(0), b.at(1))), q((b.at(2), b.at(3))), fill: fill, stroke: stroke)
  for x in range(8, 15) { line(q((x, 0.5)), q((x, 7.5)), stroke: 0.2pt + luma(215)) }
  for y in range(1, 8) { line(q((8.5, y)), q((14, y)), stroke: 0.2pt + luma(215)) }
  for x in range(9, 14) { T((x, 0.3), str(x), size: 4.5pt, fill: gray) }
  for y in range(1, 8) { T((8.3, y), str(y), size: 4.5pt, fill: gray) }
  for (P, l) in gf-below { poly(P, stroke: (paint: rgb("#8a5a2b"), dash: "dotted", thickness: 0.5pt)) }
  T((9.6, 6.9), [GF laundry below], size: 4pt, fill: rgb("#8a5a2b")); T((12.3, 6.9), [GF maid room below], size: 4pt, fill: rgb("#8a5a2b")); T((9.8, 0.75), [GF maid bath below], size: 4pt, fill: rgb("#8a5a2b"))
  poly(link, fill: rgb("#f2efe8"), stroke: 0.5pt + ink); T((9.55, 5.9), [family link], size: 4pt)
  poly(bedroom, fill: rgb("#f6e3c0"), stroke: 0.9pt + ink)
  poly(sr-pts, fill: rgb("#cfe6ef"), stroke: 0.9pt + ink)
  poly(vest, fill: rgb("#ece8dc"), stroke: (paint: ink, thickness: 0.4pt, dash: "dotted")); T((9.75, 4.9), [entry zone\ 1.6 × 1.9], size: 4pt)
  for (x0, y0, x1, y1, l) in fixtures { R((x0, y0, x1, y1), fill: white, stroke: 0.5pt + blue); T(((x0 + x1) / 2 - 0.25, (y0 + y1) / 2), l, size: 3.6pt, fill: blue, anchor: "center") }
  T((9.75, 2.4), [shower room\ 1.6 × 2.4\ #r2(sr-clear) m² clear], size: 4.2pt, fill: blue, anchor: "center")
  for (x0, y0, x1, y1, l) in furniture { R((x0, y0, x1, y1), fill: stone.lighten(50%), stroke: 0.5pt + ink); T(((x0 + x1) / 2, (y0 + y1) / 2), l, size: 3.8pt) }
  line(q(door-room.at(0)), q(door-room.at(1)), stroke: 2.4pt + red); T((9.55, 5.15), [door 1.00 (as drawn)], size: 3.8pt, fill: red)
  line(q(sr-door.at(0)), q(sr-door.at(1)), stroke: 2.4pt + red); T((9.4, 3.6), [door 0.80], size: 3.8pt, fill: red)
  line(q(w-escape.at(0)), q(w-escape.at(1)), stroke: 2.4pt + blue); T((11.9, 2.1), [escape window], size: 3.8pt, fill: blue, anchor: "west")
  line(q(w-2.at(0)), q(w-2.at(1)), stroke: 2.4pt + blue); T((13.1, 4.5), [window], size: 3.8pt, fill: blue, anchor: "west")
  R(rect-clean, stroke: (paint: accent, thickness: 0.7pt, dash: "dashed")); T((11.5, 3.55), [clean rectangle #r2(rect-clean-area) m²], size: 3.8pt, fill: accent)
  T((12.4, 1.4), [bedroom 1\ #r2(bed-clear) m² clear], size: 4.6pt, fill: ink, anchor: "west")
  T((13.6, 4.2), [cut wall ↗ lane], size: 4pt, fill: gray, angle: -61deg)
  line(q((8.6, 7.3)), q((9.6, 7.3)), stroke: 1.2pt + ink); T((9.1, 7.5), [1 m], size: 4.5pt)
})

#let tbl(columns: (1fr, auto), size: 7pt, ..cells) = text(size, table(columns: columns, stroke: none, inset: (x: 3.5pt, y: 2.2pt),
  fill: (_, y) => if y == 0 { rgb("#e1e9e3") } else if calc.even(y) { rgb("#efece4") }, ..cells))

#grid(columns: (auto, 1fr), column-gutter: 10pt,
  [
    #plan
    #v(3pt)
    #block(width: 8.6cm, text(6.5pt, fill: gray)[First floor, CSV frame. Blue: the shower room and its fixtures; stone: the furniture; red: the doors; blue bars: the windows on the cut wall; dotted: the ground-floor rooms below; green dashed: the bedroom's clean rectangle (east of the entry zone, south of the cut's narrow part). The cut wall at its 6 Nov 2026 position (0.12 m further out).])
  ],
  [
    #text(14pt, weight: "bold", fill: accent)[Bedroom 1 with a simple en-suite shower room · short study] #h(1fr) #text(7pt, fill: gray)[NOT APPLIED · 6 Nov 2026 · the owner decides]
    #v(2pt) #line(length: 100%, stroke: 0.6pt + accent)
    #text(7.2pt)[*The brief:* a shower, a WC and a basin, wall-hung on one service wall, over the laundry / maid wing below, in the east cluster; the bedroom keeps its bed 1.4 × 2.0, a wardrobe ≥ 1.8 m, a desk, its door and its escape window. *The best layout found (of the positions tried in `studies/bedroom1_bath.typ`, now with the cut wall 0.12 m further out):* the shower room in the room's north-west corner (1.6 × 2.4 over the maid bath and the laundry), its service wall on the bedroom side; the room's existing door (y 5.3) then opens into an entry zone of 1.6 × 1.9 m between the shower room and the bed; the bedroom proper lies east of it, under the cut wall.]
    #v(2pt)
    #tbl(columns: (1.6fr, 1fr, 2fr), size: 6.8pt,
      table.header([*Item*], [*m²*], [*Note*]),
      [Bedroom 1 as drawn today (no bath), clear], [#f2(clear(bed1))], [on axes #f2(area(bed1)); the cut wall's move added 0.79],
      [Shower room 1.6 × 2.4, clear], [#f2(sr-clear)], [walk-in shower 1.4 × 0.9 at the north end, WC and basin on the service wall x 10.55; the stack drops into the laundry / maid bath, east cluster; mechanical extract (no window)],
      [*Bedroom proper, clear* (the room minus the shower room, the entry zone included)], [*#f2(bed-clear)*], [#if bed-clear >= 10 [≥ 10 m²: the brief's area is met] else [< 10 m²: the brief's area is NOT met]],
      [… of which the clean rectangle (x #f2(rect-clean.at(0))–#f2(rect-clean.at(2)), y 3.4–6.4)], [#f2(rect-clean-area)], [#f2(rect-clean.at(2) - rect-clean.at(0)) × #f2(rect-clean.at(3) - rect-clean.at(1)) m: the rest is the wedge under the cut wall and the entry zone],
      [Bed 1.4 × 2.0, head on the south wall (x 10.65–12.05, y 4.4–6.4)], [2.80], [against the shower-room wall on its west side; on its east side #f2(pass-east) m to the cut's inner face at the head end, widening to #f2(13.311 - 0.125 - bed.at(2)) m at the foot; #f2(pass-foot) m between the foot and the wardrobe line],
      [Wardrobe 1.8 × 0.6 (x 10.55–11.15, y 2.3–4.1)], [1.08], [in the wedge, backing onto the shower-room wall; its north end #f2(cut-in(2.3) - 11.15) m inside the cut's inner face],
      [Desk 1.03 × 0.6 (x 12.15–13.18, y 5.8–6.4)], [0.62], [on the south wall east of the bed, under the second window's light; shorter than the usual 1.2 m],
      [Doors · window], [—], [the room's door 1.00 m at y 5.3 unchanged; the shower-room door 0.80 m in its south wall, off the entry zone; the escape window (#f2(dist(..w-escape)) m on the cut, sill 0.9) stays, now facing the wardrobe's end and the wedge; the second window lights the bed],
    )
    #v(2pt)
    #text(7pt)[#if all-ok [*Study checks passed* (#checks.len())] else [*STUDY CHECKS FAILED:* #checks.filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]]
    #v(2pt)
    #box(fill: rgb("#2f6b4f").lighten(85%), stroke: 1pt + accent, inset: 6pt, radius: 3pt, width: 100%)[
      #text(9.5pt, weight: "bold", fill: accent)[Does it work? Plainly:] \
      #text(7.2pt)[
        *By the numbers, yes:* the shower room fits over wet rooms with its stack in the east cluster, and the bedroom keeps #f2(bed-clear) m² clear with the bed, a 1.8 m wardrobe and a desk, the door and the escape window unchanged. *As a room, barely:* the clean rectangle left for living in is only #f2(rect-clean.at(2) - rect-clean.at(0)) × #f2(rect-clean.at(3) - rect-clean.at(1)) m (#f2(rect-clean-area) m²), the bed stands against the shower-room wall with #f2(pass-east) m beside its head on the other side, the wardrobe and the entry zone sit in the wedge, and the desk shrinks to 1.03 m. It is a hotel-style small room, not the clean 10 m² room the earlier brief asked for; the cut wall's extra 0.12 m helped (+0.79 m²) but did not change the shape. \
        *Recommendation:* keep option A of 2 Nov 2026 (no private bath: the family bath is 3.5 m from the door, night lights on the route) unless the owner values the en-suite more than the room's shape; if the en-suite is wanted, this is the layout to build, and a further cut-wall move (0.14 m) does not change the picture. Not applied.
      ]
    ]
    #v(2pt)
    #text(6.2pt, fill: gray)[Bedroom 1 en-suite study · the room from data/rooms_ff.csv (6 Nov 2026), the link and the door from studies/ff_family.typ, the ground-floor rooms from data/rooms_gf.csv; the brief and the measures from studies/bedroom1_bath.typ (clear ≈ area − 0.1 × perimeter). Checks: #checks.map(c => c.at(0)).join([ · ]).]
  ],
)

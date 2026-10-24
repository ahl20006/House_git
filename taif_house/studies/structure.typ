// structure.typ · Taif / Palm House V6.2 · PRELIMINARY STRUCTURAL STUDY (architectural coordination, not a structural design) · compile THIS file
// Every size here is ASSUMED, to be calculated by the structural engineer. The room outlines come from ../data/rooms_gf.csv and
// ../data/rooms_ff.csv; the column grid, beams and slab types are this study's proposal. Written up in ../docs/STRUCTURE_STUDY.md.
// Coordinates: the CSV frame (metres, x east, y south, origin = the building's north-west wall corner). Levels: GF ±0.00 · FF +3.60 · roof +7.20.
#import "@preview/cetz:0.4.2"
#set page(paper: "a4", flipped: true, margin: 10mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial"), size: 7.2pt)

// ---------- rooms (outlines only, from the CSVs) ----------
#let parse-pts(s) = s.split(";").map(t => t.trim()).filter(t => t != "").map(t => { let v = t.split(" ").filter(u => u != ""); (float(v.at(0)), float(v.at(1))) })
#let read(path) = csv(path, row-type: dictionary).filter(r => r.name != "" and not r.name.starts-with("#")).map(r => {
  let P = if r.pts.trim() != "" { parse-pts(r.pts) } else {
    let x = float(r.x); let y = float(r.y); let w = float(r.w); let d = float(r.d)
    ((x - w / 2, y - d / 2), (x + w / 2, y - d / 2), (x + w / 2, y + d / 2), (x - w / 2, y + d / 2)) }
  (name: r.name, P: P) })
#let GF = read("../data/rooms_gf.csv")
#let FF = read("../data/rooms_ff.csv")
#let outline = ((0, 0), (10.051, 0), (13.311, 6.0), (13.311, 24.0), (0, 24.0))
#let lvl = (gf: 0.0, ff: 3.6, roof: 7.2, slab: 0.2)

// ---------- the proposal: columns (all continuous footing → roof unless "to" says FF) ----------
// (id, x, y, line it sits in, size assumed, to, note)
#let columns = (
  ("C1", 0, 0, "west wall · north wall", "0.25×0.60", "roof", "corner; lift shaft RC walls"),
  ("C2", 0, 2.2, "west wall", "0.25×0.60", "roof", "lift / stair wall"),
  ("C3", 0, 7.9, "west wall", "0.25×0.60", "roof", "stair / utility wall"),
  ("C4", 0, 10.4, "west wall", "0.25×0.60", "roof", "utility / hospitality kitchen wall; shaft RC box"),
  ("C5", 0, 14.4, "west wall", "0.25×0.60", "roof", "basins / family WC wall · FF bedroom 2 / bath 3"),
  ("C6", 0, 19.25, "west wall", "0.25×0.60", "roof", "guest WC / basins wall · FF bedroom 3 / office"),
  ("C7", 0, 24, "west wall · south wall", "0.25×0.60", "roof", "corner"),
  ("C8", 2.75, 0, "riwaq line · north wall", "0.25×0.50", "roof", "in the north wall beside the family entry"),
  ("C9", 2.75, 2.2, "riwaq line", "0.25×0.50", "roof", "lift / stair corner (entry cupboard)"),
  ("C10", 2.75, 7.9, "riwaq line", "0.25×0.50", "roof", "stair / utility corner · FF landing"),
  ("C11", 2.75, 10.4, "riwaq line", "0.25×0.50", "roof", "utility / hospitality kitchen · FF shaft corner"),
  ("C12", 2.75, 14.4, "riwaq line", "0.25×0.50", "roof", "basins / family WC · FF bedroom 2 / bath 3"),
  ("C13", 2.75, 19.25, "riwaq line · majlis north wall", "0.25×0.50", "roof", "men's majlis NW corner"),
  ("C14", 2.75, 24, "riwaq line · south wall", "0.25×0.50", "roof", "foyer / majlis corner"),
  ("C15", 4.25, 0, "courtyard line · north wall", "0.25×0.50", "roof", "women's majlis NW corner"),
  ("C16", 4.25, 3.0, "courtyard line", "0.25×0.50", "roof", "in the women's majlis west wall; carries beam B1 (FF y 3.0 wall)"),
  ("C17", 4.25, 6.5, "courtyard line", "0.25×0.50", "roof", "women's majlis / courtyard corner"),
  ("C18", 4.25, 13.0, "courtyard line", "0.25×0.50", "roof", "courtyard / living corner (riwaq side)"),
  ("C19", 4.25, 19.25, "courtyard line · majlis north wall", "0.25×0.50", "roof", "living SW corner · FF office / bedroom 3"),
  ("C20", 4.25, 24, "courtyard line · south wall", "0.25×0.50", "roof", "in the south wall; FF office / gym wall above"),
  ("C21", 5.6, 6.5, "colonnade", "Ø0.30", "FF (roof: option)", "in the women's majlis south wall"),
  ("C22", 5.6, 13.0, "colonnade", "Ø0.30", "FF (roof: option)", "a pier in the courtyard / living glass (accepted)"),
  ("C23", 5.6, 19.25, "colonnade", "Ø0.30", "FF (roof: option)", "in the living's south wall"),
  ("C24", 8.95, 0, "east line · north wall", "0.25×0.50", "roof", "women's majlis / air tower corner"),
  ("C25", 8.95, 3.0, "east line", "0.25×0.50", "roof", "in the solid laundry wall; carries beam B1"),
  ("C26", 8.95, 6.5, "east line", "0.25×0.50", "roof", "courtyard / kitchen NW corner"),
  ("C27", 8.95, 13.0, "east line", "0.25×0.50", "roof", "courtyard / kitchen / living / dining corner"),
  ("C28", 8.95, 19.25, "east line · majlis north wall", "0.25×0.50", "roof", "living / dining / majlis corner"),
  ("C29", 8.95, 24, "east line · south wall", "0.25×0.50", "roof", "in the south wall"),
  ("C30", 10.051, 0, "north wall · cut wall", "0.25×0.60", "roof", "cut corner (air tower)"),
  ("C31", 11.572, 2.8, "cut wall", "0.25×0.60", "roof", "maid bath / maid room wall meets the cut"),
  ("C32", 13.311, 6.0, "cut wall · east wall", "0.25×0.60", "roof", "end of the cut"),
  ("C33", 13.311, 10.45, "east wall", "0.25×0.60", "roof", "FF suite bath / dressing wall; conflicts with the FF bath window, see X3"),
  ("C34", 13.311, 13.0, "east wall", "0.25×0.60", "roof", "kitchen / dining wall"),
  ("C35", 13.311, 19.25, "east wall · majlis north wall", "0.25×0.60", "roof", "dining / majlis corner · FF suite bedroom / arm"),
  ("C36", 13.311, 24, "east wall · south wall", "0.25×0.60", "roof", "corner"),
)
// RC walls (stiff boxes): (name, polygon)
#let rc-walls = (
  ("W1 lift shaft", ((0, 0), (2.25, 0), (2.25, 2.2), (0, 2.2))),
  ("W2 west shaft", ((0, 9.2), (1.5, 9.2), (1.5, 10.4), (0, 10.4))),
  ("W3 laundry / maid wall x 8.95", ((8.95, 0), (8.95, 6.5))),
  ("W4 cut wall", ((10.051, 0), (13.311, 6.0))),
  ("W5 kitchen north wall y 6.5", ((8.95, 6.5), (13.311, 6.5))),
)

// ---------- beams: (id, level, a, b, spans, size assumed, kind, carries / note) · kind: drop · hidden · upturned · edge · trimmer ----------
#let beams-ff = (
  ("B1", (4.25, 3.0), (8.95, 3.0), "4.70", "0.25×0.40 drop (or hidden in a 0.30 ribbed slab)", "drop", "FF kids' room / family living wall (y 3.0, nothing below) + the women's majlis roof"),
  ("B2", (4.25, 6.5), (8.95, 6.5), "1.35 + 3.35", "0.25×0.40 hidden / drop", "edge", "FF slab edge on the courtyard (family living balustrade); over the women's majlis south glazing"),
  ("B3", (5.6, 6.5), (5.6, 19.25), "6.50 + 6.25", "0.25×0.50 · drop, UPTURNED or 0.35 slab edge (§ options)", "edge", "the 1.35 m projection and the gallery, on C21–C23"),
  ("B4", (4.25, 6.5), (4.25, 19.25), "6.50 + 6.25", "0.25×0.50 drop", "drop", "FF west rooms' east wall (over the riwaq glazing and the low wall) + the projection back span"),
  ("B5", (8.95, 13.0), (8.95, 19.25), "6.25", "0.25×0.55 drop (or 0.60×0.40 wide-shallow)", "drop", "FF suite bedroom west wall + half the dining roof; over the open ceiling-height change"),
  ("B6", (8.95, 6.5), (13.311, 6.5), "4.36", "hidden 0.30", "hidden", "on the kitchen north wall; FF bedroom 1 / suite wall above"),
  ("B7", (8.95, 13.0), (13.311, 13.0), "4.36", "hidden 0.30", "hidden", "on the kitchen / dining wall; the suite dressing floor spans over it"),
  ("B8", (2.75, 19.25), (13.311, 19.25), "1.5 + 1.35 + 3.35 + 4.36", "0.25×0.45 drop above the wall", "drop", "on the men's majlis north wall; carries the FF bedroom 3 / office wall, the suite court north wall, the 7 m living south wall and the treadmill arm"),
  ("B9", (0, 24), (13.311, 24), "2.75 + 1.5 + 4.7 + 4.36", "hidden in the 0.25 wall / 0.25×0.45", "hidden", "south wall; men's majlis roof support"),
  ("B10", (2.75, 0), (2.75, 24), "2.2 + 5.7 + 2.5 + 4.0 + 4.85 + 4.75", "hidden 0.20–0.30; 0.25×0.40 at the 5.7 m stair bay", "hidden", "riwaq line: west band slabs and the riwaq slab"),
  ("B11", (0, 2.2), (2.75, 2.2), "2.75", "hidden 0.20", "hidden", "lift / stair wall"),
  ("B12", (0, 7.9), (2.75, 7.9), "2.75", "hidden 0.20", "hidden", "stair / utility wall · FF landing"),
  ("B13", (0, 10.4), (2.75, 10.4), "2.75", "hidden 0.20", "hidden", "utility / hospitality kitchen wall"),
  ("B14", (0, 14.4), (2.75, 14.4), "2.75", "hidden 0.20", "hidden", "basins / family WC wall · FF bedroom 2 / bath 3 wall"),
  ("B15", (8.95, 1.0), (10.594, 1.0), "1.64", "0.20×0.35 edge", "edge", "air tower opening (the tower rises through both slabs)"),
  ("B16", (0, 3.95), (1.375, 3.95), "1.375", "0.20×0.40 trimmer", "trimmer", "stair opening; spans to the x 1.375 trimmer (a beam on a beam: unavoidable at a stair well)"),
  ("B17", (1.375, 3.95), (1.375, 6.2), "2.25", "0.20×0.40 trimmer", "trimmer", "stair opening, between the two flights"),
  ("B18", (1.375, 6.2), (2.75, 6.2), "1.375", "0.20×0.40 trimmer", "trimmer", "stair opening, arrival edge"),
  ("B19", (4.25, 19.25), (4.25, 24), "4.75", "hidden rib 0.30 (in the ribbed majlis roof)", "hidden", "FF office / gym route wall, nothing below; a thickened rib spanning y 19.25 → 24"),
  ("B20", (5.6, 19.25), (5.6, 21.25), "2.0 (+ rib to y 24)", "hidden rib 0.30", "hidden", "FF gym route / suite court wall, nothing below"),
  ("B21", (11.586, 19.25), (11.586, 21.25), "2.0 (+ rib to y 24)", "hidden rib 0.30", "hidden", "the treadmill arm's west wall, nothing below; treadmill live + dynamic load"),
)
#let beams-roof = (
  ("R1", (4.25, 6.5), (8.95, 6.5), "4.70", "0.25×0.45 drop", "edge", "courtyard sky hole, north edge (over the FF family living balustrade line)"),
  ("R2", (4.25, 13.0), (8.95, 13.0), "4.70", "0.25×0.45 drop", "edge", "courtyard sky hole, south edge = the clean double-height roof's north edge"),
  ("R3", (4.25, 0), (4.25, 24), "3.0 + 3.5 + 6.5 + 6.25 + 4.75", "0.25×0.50 drop above the FF wall", "drop", "on the FF west rooms' east wall / office wall; the roof over the gallery strip cantilevers 1.35 m from it (or C21–C23 to the roof)"),
  ("R4", (8.95, 0), (8.95, 24), "3.0 + 3.5 + 6.5 + 6.25 + 4.75", "0.25×0.50 drop above the FF wall", "drop", "on the FF suite west wall; the double-height roof spans to it"),
  ("R5", (4.25, 19.25), (13.311, 19.25), "1.35 + 3.35 + 4.36", "0.25×0.50 drop", "drop", "over the living's south wall (clerestory head +6.00, soffit ≥ +6.50) and the suite court north wall"),
  ("R6", (5.6, 21.25), (11.586, 21.25), "6.0", "0.25×0.50 DROP (not upturned: winter light, X4)", "drop", "suite court hole, south edge = gym roof north edge; on the FF walls x 5.6 and x 11.586 (a transfer, X5)"),
  ("R7", (0, 0), (13.311, 0), "2.75 + 1.5 + 4.7 + 1.1", "hidden in the 0.25 wall", "hidden", "north wall"),
  ("R8", (0, 24), (13.311, 24), "2.75 + 1.5 + 4.7 + 4.36", "hidden in the 0.25 wall", "hidden", "south wall"),
  ("R9", (8.95, 1.0), (10.594, 1.0), "1.64", "0.20×0.35 edge", "edge", "air tower head opening"),
  ("R10", (2.75, 0), (2.75, 24), "as B10", "hidden 0.20–0.30", "hidden", "riwaq line"),
)
// slab bays: (level, rect x0 y0 x1 y1, type, thickness, direction "EW" | "NS" | "cant W", note)
#let slabs-ff = (
  ((0, 0, 2.75, 2.2), "lift: FF slab panel, removable later", "0.20 solid", "NS", "future lift"),
  ((0, 2.2, 2.75, 7.9), "stair: L-shaped opening + flight slabs", "0.15 flights", "NS", "opening x 0–2.75 y 2.2–3.95 + x 1.375–2.75 y 3.95–6.2"),
  ((0, 7.9, 2.75, 10.4), "solid", "0.20", "EW", "utility; shaft opening 1.5×1.2 framed"),
  ((0, 10.4, 2.75, 24), "solid", "0.20", "EW", "west wash block, 2.75 m bays"),
  ((2.75, 0, 4.25, 19.25), "solid", "0.20", "EW", "riwaq, 1.5 m"),
  ((4.25, 0, 8.95, 6.5), "solid", "0.20", "NS", "women's majlis roof: 3.0 + 3.5 m to beam B1"),
  ((4.25, 6.5, 5.6, 19.25), "solid, the projection", "0.20 (0.35 if option c)", "EW", "1.35 m between B4 and the edge beam B3"),
  ((8.95, 0, 13.311, 6.5), "solid", "0.20", "EW", "maid wing, 4.36 m to the cut wall"),
  ((8.95, 6.5, 13.311, 13.0), "ribbed (hollow block)", "0.30 (25+5)", "EW", "kitchen roof; suite bath sunken 0.15 (depressed zone x 10.3–13.311 y 6.5–10.45)"),
  ((8.95, 13.0, 13.311, 19.25), "ribbed", "0.30", "EW", "dining roof; half on beam B5"),
  ((2.75, 19.25, 13.311, 24), "ribbed", "0.30", "NS", "men's majlis roof, 4.75 m; thickened ribs B19–B21 under the FF walls; gym live load"),
)
#let slabs-roof = (
  ((0, 0, 2.75, 24), "solid", "0.20", "EW", "west band and lift / shaft heads"),
  ((2.75, 0, 4.25, 24), "solid", "0.20", "EW", "riwaq / gallery line"),
  ((4.25, 0, 8.95, 6.5), "solid", "0.20", "EW", "kids' room / family living: 4.7 m, no beam on y 3.0 (light partition)"),
  ((4.25, 6.5, 5.6, 13.0), "solid, cantilever", "0.20", "cant W", "over the gallery strip: 1.35 m cantilever from R3 (or on C21–C22 extended)"),
  ((4.25, 13.0, 8.95, 19.25), "solid, flat, no beams in the void", "0.22", "EW", "the double-height living roof: 4.7 m R3 → R4, clean soffit"),
  ((8.95, 0, 13.311, 19.25), "ribbed", "0.30", "EW", "bedroom 1 / suite: 4.36 m"),
  ((0, 19.25, 4.25, 24), "ribbed", "0.30", "NS", "office roof: 4.75 m"),
  ((4.25, 19.25, 5.6, 21.25), "solid", "0.20", "NS", "gym route"),
  ((4.25, 21.25, 13.311, 24), "solid", "0.20", "NS", "gym roof: 2.75 m; its north edge R6 over the court"),
  ((11.586, 19.25, 13.311, 21.25), "solid", "0.20", "EW", "treadmill arm roof"),
)
// the voids (no slab): FF courtyard sky + double-height; roof courtyard sky + suite court
#let voids-ff = (((5.6, 6.5, 8.95, 13.0), "courtyard sky"), ((5.6, 13.0, 8.95, 19.25), "double-height void"))
#let voids-roof = (((5.6, 6.5, 8.95, 13.0), "courtyard sky"), ((5.6, 19.25, 11.586, 21.25), "suite court"))

// ---------- helpers ----------
#let q(p) = (p.at(0), -p.at(1))
#let r2(v) = str(calc.round(v, digits: 2))
#let ink = rgb("#3d4a45")
#let green = rgb("#2f6b4f")
#let red = rgb("#b5452f")
#let blue = rgb("#1f4e79")
#let orange = rgb("#c25b00")
#let kind-stroke(k) = if k == "drop" { 2.4pt + blue } else if k == "hidden" { (paint: blue, thickness: 1.2pt, dash: "dashed") } else if k == "edge" { 2pt + orange } else if k == "trimmer" { 1.6pt + red } else { 2pt + blue }
#let H(t) = text(9pt, weight: "bold", fill: green, t)

#let plan(title, rooms, cols, beams, slabs, voids, scale: 0.5cm, cores: false, show-cols: true) = cetz.canvas(length: scale, {
  import cetz.draw: *
  let poly(P, ..a) = line(..P.map(q), close: true, ..a)
  for r in rooms { poly(r.P, fill: rgb("#f3f1ea"), stroke: 0.3pt + luma(170)) }
  for (b, n) in voids { rect(q((b.at(0), b.at(1))), q((b.at(2), b.at(3))), fill: white, stroke: 0.4pt + luma(150)); content(q(((b.at(0) + b.at(2)) / 2, (b.at(1) + b.at(3)) / 2)), text(4.4pt, fill: luma(110), n)) }
  poly(outline, stroke: 1.2pt + ink)
  // slab directions
  for (b, t, th, dir, n) in slabs {
    let cx = (b.at(0) + b.at(2)) / 2; let cy = (b.at(1) + b.at(3)) / 2
    let w = b.at(2) - b.at(0); let h = b.at(3) - b.at(1)
    if dir == "EW" { line(q((b.at(0) + 0.25, cy)), q((b.at(2) - 0.25, cy)), stroke: 0.6pt + green, mark: (start: "stealth", end: "stealth", fill: green, scale: 0.4)) }
    else if dir == "NS" { line(q((cx, b.at(1) + 0.25)), q((cx, b.at(3) - 0.25)), stroke: 0.6pt + green, mark: (start: "stealth", end: "stealth", fill: green, scale: 0.4)) }
    else { line(q((b.at(2), cy)), q((b.at(0) + 0.15, cy)), stroke: 0.6pt + green, mark: (end: "stealth", fill: green, scale: 0.4)) }
    content(q((cx, cy + 0.42)), text(3.9pt, fill: green)[#th #if dir == "cant W" [cant.] else if t.starts-with("ribbed") [rib] else [solid]])
  }
  // beams
  for (id, a, b, sp, sz, k, n) in beams {
    line(q(a), q(b), stroke: kind-stroke(k))
    let m = ((a.at(0) + b.at(0)) / 2, (a.at(1) + b.at(1)) / 2)
    let vertical = calc.abs(a.at(0) - b.at(0)) < 1e-6
    content(q(if vertical { (m.at(0) + 0.3, m.at(1)) } else { (m.at(0), m.at(1) - 0.3) }), angle: if vertical { 90deg } else { 0deg }, text(4pt, weight: "bold", fill: if k == "trimmer" { red } else if k == "edge" { orange } else { blue })[#id · #sp])
  }
  if cores { for (n, P) in rc-walls { if P.len() > 2 { poly(P, fill: luma(90), stroke: none) } else { line(q(P.at(0)), q(P.at(1)), stroke: 4pt + luma(90)) } } }
  if show-cols {
    for (id, x, y, l, s, to, n) in cols {
      if to.starts-with("FF") { circle(q((x, y)), radius: 0.22, fill: orange, stroke: none) } else { rect(q((x - 0.2, y - 0.2)), q((x + 0.2, y + 0.2)), fill: ink, stroke: none) }
      content(q((x + 0.32, y - 0.32)), anchor: "west", text(3.7pt, fill: ink, id))
    }
  }
  content(q((6.65, -0.9)), text(7pt, weight: "bold", title))
  line(q((0, 25)), q((5, 25)), stroke: 1pt + ink); content(q((2.5, 25.45)), text(5pt)[5 m])
})

// ================= PAGE 1 · approach + ground floor (columns, cores, footings) =================
#text(14pt, weight: "bold", fill: green)[Preliminary structural study · Taif / Palm House V6.2]
#h(6pt) #text(7.5pt, fill: gray)[architectural coordination study · every size ASSUMED, to be calculated by the structural engineer · CSV coordinates, north up]
#v(2pt)
#grid(columns: (auto, 1fr), column-gutter: 12pt,
  plan([Ground floor · columns (■ to the roof, ● colonnade to the FF), RC boxes (dark), tie beams on the column lines], GF, columns, (), (), (), cores: true),
  [
    #H[The idea: a simple RC skeleton, walls on walls]
    - A *reinforced-concrete frame* (columns, beams, slabs) with *block infill*, as Saudi contractors build every villa. Columns stand on the existing wall lines, hidden in the walls; *every column runs from its footing to the roof* (the three colonnade columns end at the first floor, nothing starts on them except the edge beam). No transfer beam carries a column.
    - *Spans 2.2–6.5 m.* The only spans above 6 m are on the courtyard lines (x 4.25, 5.6, 8.95: 6.5 and 6.25 m), because the courtyard and the double-height living must stay free of columns; they get drop beams ≈ 0.50–0.55 deep.
    - *Slabs:* solid 0.20 m where spans are small (west band, riwaq, projection, roofs of 4.7 m), hollow-block *ribbed 0.30 m* (25+5) for the 4.36–4.75 m bays of the east band and the men's majlis roof. The double-height living's roof is a *flat solid slab 0.22 m spanning 4.7 m east–west* between the two long walls: *no beam crosses the void* (§ options).
    - *Foundations (assumed):* isolated pad footings ≈ 1.5 × 1.5 m under the columns, strip footings under the RC boxes, RC tie beams on the column lines at ground level; the lift pit 1.2 m deep; the air tunnel under the east band crosses the tie beams (depth to coordinate). *No soil report yet* (X9).
    #v(3pt)
    #H[Balanced stiffness (no twist)]
    - *West:* the lift shaft (W1, RC walls on 3 sides), the west shaft (W2) and the stair walls make a stiff core at x 0–2.75.
    - *East, to match it:* the solid laundry / maid wall on x 8.95 (W3, no openings, 6.5 m), the cut wall (W4) and the kitchen's north wall (W5) are built as RC walls 0.20 m: an east box of the same order of stiffness, at a similar distance from the centre. With the long north and south walls (block infill in the frame) the centre of stiffness stays near the centre of mass.
    - *Why:* the house is a long pentagon (13.3 × 24 m); with stiff elements only on the west, wind and earthquake (Taif is a low seismic zone, but the SBC still asks for it) would twist it about the west core.
    #v(3pt)
    #H[Column lines and spans]
    #table(columns: (auto, 1fr, auto), stroke: none, inset: 2pt, fill: (_, y) => if calc.even(y) { rgb("#efece4") },
      [*Line*], [*Columns at y (or x)*], [*Spans (m)*],
      [x 0 and x 2.75], [y 0 · 2.2 · 7.9 · 10.4 · 14.4 · 19.25 · 24], [2.2 · 5.7 · 2.5 · 4.0 · 4.85 · 4.75],
      [x 4.25 and x 8.95], [y 0 · 3.0 · 6.5 · 13.0 · 19.25 · 24], [3.0 · 3.5 · 6.5 · 6.25 · 4.75],
      [x 5.6 (colonnade, to the FF)], [y 6.5 · 13.0 · 19.25], [6.5 · 6.25],
      [cut wall], [(10.051, 0) · (11.572, 2.8) · (13.311, 6.0)], [3.2 · 3.6],
      [x 13.311], [y 6.0 · 10.45 · 13.0 · 19.25 · 24], [4.45 · 2.55 · 6.25 · 4.75],
      [y 0 / y 24 (cross)], [x 0 · 2.75 · 4.25 · 8.95 · 13.311 (cut corner at 10.051)], [2.75 · 1.5 · 4.7 · 4.36 (1.1)],
      [y 6.5 · 13.0 · 19.25 (cross)], [x 4.25 · 5.6 · 8.95 · 13.311 (+ 2.75 at y 19.25)], [1.35 · 3.35 · 4.36],
    )
  ],
)

// ================= PAGE 2 · first-floor slab and beams =================
#pagebreak()
#text(12pt, weight: "bold", fill: green)[First-floor slab (+3.40 … +3.60) · beams and slab directions]
#h(6pt) #text(7pt, fill: gray)[blue = drop beams · dashed = hidden beams (slab depth) · orange = edge beams of the openings · red = stair trimmers · green arrows = slab span · sizes width × depth, assumed]
#v(2pt)
#grid(columns: (auto, 1fr), column-gutter: 12pt,
  plan([First-floor slab · beams B1–B21], FF, columns, beams-ff, slabs-ff, voids-ff),
  [
    #set text(6.4pt)
    #table(columns: (auto, auto, auto, 1fr), stroke: none, inset: 1.8pt, fill: (_, y) => if calc.even(y) { rgb("#efece4") },
      [*Beam*], [*Span (m)*], [*Size, assumed*], [*Carries / note*],
      ..beams-ff.map(((id, a, b, sp, sz, k, n)) => ([*#id*], [#sp], [#sz], [#n])).flatten())
    #v(2pt)
    #H[First-floor walls and what carries them]
    #table(columns: (1fr, 1fr), stroke: none, inset: 1.8pt, fill: (_, y) => if calc.even(y) { rgb("#efece4") },
      [*On a wall below (block infill under a hidden beam)*], [*Nothing below → beam or light partition*],
      [x 0, x 13.311, y 0, y 24, the cut wall (outer walls); x 2.75 at the lift and landing; x 2.25 lift; y 2.2, 7.9, 10.4 (shaft), 14.4, 16.1 (bath 3 = GF family WC), 19.25 (majlis north wall), x 1.5 shaft; x 8.95 y 6.5–13 (kitchen west wall); y 6.5 x 8.95–13.311 (kitchen north wall); y 13.0 line inside the suite (kitchen / dining wall)],
      [*y 3.0* kids' / family living → *B1*; *x 4.25 y 13–19.25* bedrooms' east wall over the low wall / opening → *B4*; *x 8.95 y 13–19.25* suite bedroom west wall over the open ceiling change → *B5*; *x 4.25 y 19.25–24* office → *B19* rib; *x 5.6* gym route → *B20*; *x 11.586* treadmill arm → *B21*; *y 21.25* gym north wall (7.7 m, east–west across the ribs) → *light partition on the slab* (X6); suite walls x 10.3, y 10.45, x 12.211, y 8.0, y 11.9, y 13.9 over the kitchen → light partitions (100 mm block or dry wall) on the ribbed slab, or hidden beams under the bath walls; y 11.0 (bath / niche / bedroom 2) and y 9.2 x 1.5–4.25 (family bath north) → light partitions; x 2.2 bath 3 / bedroom 3 entry → light; y 5.3 and x 10.15 (bedroom 1 / family link) → light; linen front y 0.7 → joinery],
    )
  ],
)

// ================= PAGE 3 · roof =================
#pagebreak()
#text(12pt, weight: "bold", fill: green)[Roof slab (+7.00 … +7.20) · beams and slab directions]
#h(6pt) #text(7pt, fill: gray)[the courtyard sky and the suite court are holes; the double-height living is roofed by a flat slab with no beam in the void; the gallery strip cantilevers (or C21–C22 continue to the roof)]
#v(2pt)
#grid(columns: (auto, 1fr), column-gutter: 12pt,
  plan([Roof slab · beams R1–R10], FF, columns.filter(c => not c.at(5).starts-with("FF")), beams-roof, slabs-roof, voids-roof),
  [
    #set text(6.6pt)
    #table(columns: (auto, auto, auto, 1fr), stroke: none, inset: 1.8pt, fill: (_, y) => if calc.even(y) { rgb("#efece4") },
      [*Beam*], [*Span (m)*], [*Size, assumed*], [*Carries / note*],
      ..beams-roof.map(((id, a, b, sp, sz, k, n)) => ([*#id*], [#sp], [#sz], [#n])).flatten())
    #v(3pt)
    #H[Slab bays (first floor and roof)]
    #table(columns: (auto, 1fr, auto, auto, 1.3fr), stroke: none, inset: 1.6pt, fill: (_, y) => if calc.even(y) { rgb("#efece4") },
      [*Level*], [*Bay (x0 y0 – x1 y1)*], [*Type*], [*Span*], [*Note*],
      ..slabs-ff.map(((b, t, th, d, n)) => ([FF], [#r2(b.at(0)) #r2(b.at(1)) – #r2(b.at(2)) #r2(b.at(3))], [#t #th], [#d], [#n])).flatten(),
      ..slabs-roof.map(((b, t, th, d, n)) => ([roof], [#r2(b.at(0)) #r2(b.at(1)) – #r2(b.at(2)) #r2(b.at(3))], [#t #th], [#d], [#n])).flatten())
  ],
)

// ================= PAGE 4 · sections =================
#pagebreak()
#text(12pt, weight: "bold", fill: green)[Sections · schematic, levels to confirm]
#h(6pt) #text(7pt, fill: gray)[A east–west through the riwaq, the courtyard and the colonnade (y 10) · B east–west through the living, the double-height void and the dining (y 16.5) · C north–south through the middle band (x 7.3)]
#let sec(length: 0.62cm, cut, body) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, t, size: 4.6pt, fill: ink, anchor: "center") = content(p, anchor: anchor, text(size, fill: fill, t))
  let slab(x0, x1, z) = rect((x0, z - lvl.slab), (x1, z), fill: luma(120), stroke: none)
  let beam(x, z, w, d, col: blue) = rect((x - w / 2, z - lvl.slab - d), (x + w / 2, z - lvl.slab), fill: col, stroke: none)
  let col(x, z0, z1) = rect((x - 0.15, z0), (x + 0.15, z1), fill: ink, stroke: none)
  let wall(x, z0, z1, t: 0.2) = rect((x - t / 2, z0), (x + t / 2, z1), fill: luma(200), stroke: 0.3pt + luma(120))
  let up(x, z, w, h) = rect((x - w / 2, z), (x + w / 2, z + h), fill: orange, stroke: none)   // an upturned beam on the slab
  line((-1, 0), (14.5, 0), stroke: 0.8pt + ink)
  for (z, l) in ((0, [±0.00]), (3.6, [+3.60]), (7.2, [+7.20])) { line((-0.9, z), (-0.3, z), stroke: 0.4pt + gray); T((-1.0, z), l, size: 4.2pt, fill: gray, anchor: "east") }
  body(slab, beam, col, wall, T, up)
  T((-1, -0.6), [W], anchor: "west"); T((14.5, -0.6), [E], anchor: "east")
  T((6.6, 8.6), cut, size: 6pt)
})
#grid(columns: (1fr, 1fr), column-gutter: 8pt, row-gutter: 4pt,
  sec([A · y 10: riwaq · courtyard · colonnade · kitchen], (slab, beam, col, wall, T, up) => {
    // GF slab, walls / columns on the cut
    slab(-0.125, 13.436, 0)
    for x in (0, 2.75, 4.25, 8.95, 13.311) { wall(x, 0, 3.4, t: if x == 0 or x == 13.311 { 0.25 } else { 0.2 }) }
    col(0, 0, 7.0); col(2.75, 0, 7.0); col(4.25, 0, 7.0); col(8.95, 0, 7.0); col(13.311, 0, 7.0)
    col(5.6, 0, 3.1); T((5.6, -0.4), [C21–C23 Ø0.30], size: 4pt, fill: orange)
    // FF slab: west band to x 5.6 (projection), east from 8.95
    slab(-0.125, 5.6, 3.6); slab(8.95, 13.436, 3.6)
    beam(4.25, 3.6, 0.25, 0.3); T((4.25, 2.85), [B4 0.25×0.50], size: 3.8pt, fill: blue, anchor: "east")
    up(5.6, 3.6, 0.25, 0.5); T((5.75, 4.3), [B3 upturned 0.50 = railing base], size: 3.8pt, fill: orange, anchor: "west")
    beam(8.95, 3.6, 0.25, 0.1)
    for x in (0, 2.75, 4.25, 8.95, 13.311) { wall(x, 3.6, 7.0, t: if x == 0 or x == 13.311 { 0.25 } else { 0.2 }) }
    T((1.375, 1.7), [utility · shaft], size: 4pt); T((3.5, 1.7), [riwaq], size: 4pt); T((7.27, 1.0), [courtyard · open], size: 4.2pt, fill: blue); T((11.1, 1.7), [kitchen], size: 4pt)
    T((1.375, 5.3), [family bath], size: 4pt); T((3.5, 5.3), [gallery], size: 4pt); T((4.9, 5.0), [proj.], size: 3.6pt); T((11.1, 5.3), [suite lobby · bath], size: 4pt)
    T((7.27, 5.0), [sky 3.35], size: 4.2pt, fill: blue)
    // roof: west to 5.6 (cantilever), east from 8.95
    slab(-0.125, 5.6, 7.2); slab(8.95, 13.436, 7.2)
    beam(4.25, 7.2, 0.25, 0.3); T((4.25, 6.45), [R3], size: 3.8pt, fill: blue, anchor: "east"); beam(8.95, 7.2, 0.25, 0.3); T((9.2, 6.45), [R4], size: 3.8pt, fill: blue, anchor: "west")
    T((5.0, 7.5), [cant. 1.35], size: 3.6pt)
  }),
  sec([B · y 16.5: living (low wall) · double-height void · dining · suite], (slab, beam, col, wall, T, up) => {
    slab(-0.125, 13.436, 0)
    for x in (0, 2.75, 13.311) { wall(x, 0, 3.4, t: if x == 0 or x == 13.311 { 0.25 } else { 0.2 }) }
    wall(4.25, 0, 1.2); T((4.4, 1.4), [low wall 1.20], size: 3.6pt, anchor: "west")
    col(0, 0, 7.0); col(2.75, 0, 7.0); col(4.25, 0, 7.0); col(8.95, 0, 7.0); col(13.311, 0, 7.0)
    T((4.25, -0.4), [C18–C19 beyond], size: 3.6pt); T((8.95, -0.4), [C27–C28 beyond], size: 3.6pt)
    slab(-0.125, 5.6, 3.6); slab(8.95, 13.436, 3.6)
    beam(4.25, 3.6, 0.25, 0.3); beam(5.6, 3.6, 0.25, 0.3, col: orange)
    beam(8.95, 3.6, 0.25, 0.35); T((9.2, 2.9), [B5 0.25×0.55 on the ceiling-height change · clear ≈ 2.85], size: 3.8pt, fill: blue, anchor: "west")
    for x in (0, 2.75, 4.25, 8.95, 13.311) { wall(x, 3.6, 7.0, t: if x == 0 or x == 13.311 { 0.25 } else { 0.2 }) }
    T((1.375, 1.7), [serving], size: 4pt); T((3.5, 1.7), [riwaq], size: 4pt); T((6.6, 2.4), [living · double height], size: 4.4pt); T((11.1, 1.7), [dining · ceiling +3.40], size: 4pt)
    T((1.375, 5.3), [bedroom 3], size: 4pt); T((3.5, 5.3), [gallery], size: 4pt); T((11.1, 5.3), [suite bedroom], size: 4pt)
    slab(-0.125, 13.436, 7.2)
    beam(4.25, 7.2, 0.25, 0.3); beam(8.95, 7.2, 0.25, 0.3); T((6.6, 6.55), [roof: flat solid 0.22, 4.7 m, no beam in the void], size: 3.8pt, fill: green)
  }),
)
#v(4pt)
#cetz.canvas(length: 0.52cm, {
  import cetz.draw: *
  let T(p, t, size: 4.6pt, fill: ink, anchor: "center") = content(p, anchor: anchor, text(size, fill: fill, t))
  let slab(y0, y1, z) = rect((y0, z - lvl.slab), (y1, z), fill: luma(120), stroke: none)
  let beam(y, z, w, d, col: blue) = rect((y - w / 2, z - lvl.slab - d), (y + w / 2, z - lvl.slab), fill: col, stroke: none)
  let wall(y, z0, z1, t: 0.2) = rect((y - t / 2, z0), (y + t / 2, z1), fill: luma(200), stroke: 0.3pt + luma(120))
  line((-1, 0), (25, 0), stroke: 0.8pt + ink)
  for (z, l) in ((0, [±0.00]), (3.6, [+3.60]), (7.2, [+7.20])) { T((-1.0, z), l, size: 4.2pt, fill: gray, anchor: "east") }
  slab(-0.125, 24.125, 0)
  for y in (0, 6.5, 13.0, 19.25, 24) { wall(y, 0, 3.4, t: if y == 0 or y == 24 { 0.25 } else { 0.2 }) }
  T((3.25, 1.7), [women's majlis]); T((9.75, 1.0), [courtyard · open], fill: blue); T((16.1, 2.4), [living · double height]); T((21.6, 1.7), [men's majlis])
  slab(-0.125, 6.5, 3.6); slab(19.25, 24.125, 3.6)
  beam(3.0, 3.6, 0.25, 0.2); T((3.0, 2.95), [B1 0.25×0.40 (or hidden in 0.30 rib)], size: 3.8pt, fill: blue)
  beam(6.5, 3.6, 0.25, 0.2); T((6.75, 2.95), [B2], size: 3.8pt, fill: orange, anchor: "west")
  beam(19.25, 3.6, 0.25, 0.25); T((19.0, 2.95), [B8], size: 3.8pt, fill: blue, anchor: "east")
  T((21.6, 3.95), [majlis roof: ribbed 0.30, ribs N–S 4.75], size: 3.8pt, fill: green)
  wall(3.0, 3.6, 7.0, t: 0.1); T((3.0, 5.3), [kids' · living · y 3.0 light], size: 3.8pt)
  wall(19.25, 3.6, 7.0); line((19.25, 5.0), (19.25, 6.0), stroke: 2.5pt + rgb("#1f7a99")); T((19.0, 5.5), [clerestory +5.00–6.00], size: 3.6pt, fill: rgb("#1f7a99"), anchor: "east")
  wall(21.25, 3.6, 7.0, t: 0.1); T((21.25, 5.3), [gym N wall · light], size: 3.6pt); wall(24, 3.6, 7.0, t: 0.25)
  T((20.25, 4.6), [suite court · open], size: 3.6pt, fill: blue)
  slab(-0.125, 6.5, 7.2); slab(13.0, 19.25, 7.2); slab(21.25, 24.125, 7.2)
  beam(6.5, 7.2, 0.25, 0.25); T((6.5, 6.45), [R1], size: 3.8pt, fill: orange); beam(13.0, 7.2, 0.25, 0.25); T((13.0, 6.45), [R2], size: 3.8pt, fill: orange)
  beam(19.25, 7.2, 0.25, 0.3); T((19.0, 6.75), [R5 soffit +6.50 ≥ head +6.00], size: 3.6pt, fill: blue, anchor: "east")
  beam(21.25, 7.2, 0.25, 0.3); T((21.5, 6.75), [R6 drop, not upturned], size: 3.6pt, fill: blue, anchor: "west")
  T((9.75, 6.4), [sky], fill: blue); T((16.1, 6.6), [DH roof flat, clean], size: 3.8pt, fill: green)
  T((-1, -0.6), [N], anchor: "west"); T((24, -0.6), [S], anchor: "east"); T((12, 8.4), [C · x 7.3: women's majlis · courtyard · double-height living · men's majlis roof · gym], size: 6pt)
})

// ================= PAGE 5 · special zones =================
#pagebreak()
#text(12pt, weight: "bold", fill: green)[Special zones · options compared (none imposed)]
#v(2pt)
#set text(6.7pt)
#grid(columns: (1fr, 1fr), column-gutter: 14pt,
  [
    #H[1 · The west projection: edge beam B3 on C21–C23 (spans 6.5 and 6.25 m)]
    #table(columns: (auto, 1fr, 1fr, 1fr), stroke: none, inset: 2pt, fill: (_, y) => if calc.even(y) { rgb("#efece4") },
      [], [*(a) drop beam*], [*(b) upturned beam*], [*(c) deeper slab edge*],
      [size], [0.25 × 0.50 below the slab], [0.25 × 0.50 above the slab, top at +4.10], [slab 0.35 over the 1.35 m strip, no beam],
      [what you see], [a 0.30 m downstand along the colonnade, clear 2.90 under it; the courtyard reads as a riwaq with a beam], [a flush soffit at +3.40 over the colonnade; the upstand is the solid base of the gallery railing (0.50 + 0.60 railing = 1.10)], [flush soffit, a thicker slab edge 0.35 seen from the courtyard],
      [structure], [standard; the stiffest], [standard; the slab hangs from the beam's bottom (stirrups) – routine], [a 1.35 m wide, 0.35 deep band over 6.5 m: depth/span ≈ 1/18, deflection-sensitive, heavy],
      [cost], [lowest], [≈ same formwork; saves the railing base], [more concrete and steel],
      [note], [—], [preferred by this study: cleanest colonnade soffit, railing base included], [only if a flush soffit AND an open railing are wanted],
    )
    #v(3pt)
    #H[2 · The double-height living: a clean ceiling (preferred, not a rule)]
    - *Option 1 · flat solid roof slab 0.22 m spanning 4.7 m east–west* from the FF west rooms' wall (R3) to the suite wall (R4): no beam in the void, the two beams sit on the walls (invisible). Routine span; cost ≈ a normal solid slab. *This study's preference.*
    - *Option 2 · ribbed 0.30 slab, ribs east–west:* lighter and cheaper for the contractor, but a ribbed soffit (or a false ceiling) over the void; still no cross beam.
    - *Option 3 · a cross beam on y 16.1 (mid-void) + 0.18 slab:* the cheapest in material, but a 0.45 m beam across the void, 7 m up, in the family's main room. Not recommended unless the engineer finds option 1 too deep.
    - The void's walls: x 4.25 and x 8.95 are 7 m high but tied by the FF slab on their outer sides (the gallery / projection on the west, the suite floor on the east). The south wall (y 19.25, x 5.6–8.95, with the clerestory) is tied at +3.6 only by the men's majlis roof slab on its south face, and at +7.0 by the roof: *one tall wall, 7 m, tied on one side at mid-height* (X7).
    #v(3pt)
    #H[3 · Living ↔ dining opening (x 8.95, 6.25 m) under the suite wall: beam B5]
    - A drop beam 0.25 × 0.55 between C27 (8.95, 13.0) and C28 (8.95, 19.25); it carries the suite bedroom's west wall (3.4 m block), half the dining roof (ribbed, 4.36 m) and the roof beam R4 above the wall. Soffit ≈ +2.85.
    - *It can sit exactly on the ceiling-height change line:* the dining ceiling is at +3.40, the living has no ceiling, so the beam's 0.35 m below the dining ceiling becomes the step itself: one face of the double height. Headroom under it 2.85 m (≥ 2.40 required).
    - *Alternative:* a wide-shallow beam 0.60 × 0.40 (soffit +3.00) if the step should be thinner; or make the suite wall a light partition so the beam carries only the slab (0.25 × 0.45).
  ],
  [
    #H[4 · Men's majlis roof (10.56 × 4.75 m) carrying the gym, the arm and the office]
    - *Span direction north–south, 4.75 m:* a ribbed (hollow-block) slab 0.30 m (25+5), ribs from the majlis north wall (B8) to the south wall (B9). *No column inside the majlis* (the room must stay free: 10.56 m long, seating at the east end).
    - The first-floor walls *parallel to the ribs* (office wall x 4.25, gym route x 5.6, treadmill arm x 11.586) each stand on a *thickened rib / hidden beam* B19–B21 spanning the 4.75 m: direct and cheap.
    - The gym's north wall *y 21.25 runs across the ribs* for 7.7 m with nothing below: (i) *a light partition* (100 mm block or dry wall, high windows onto the court) on the slab, designed for a partition load: *recommended*; (ii) a 200 mm block wall on a solid band 1.0 m wide in the ribbed slab; (iii) a drop beam the full 10.56 m (≈ 0.90 m deep, visible in the majlis): rejected.
    - *Loads:* gym live load 5 kN/m² (SBC 301 / ASCE 7: gymnasia), the treadmill ≈ 1.5–2 kN dynamic; office 2.5–3 kN/m². *Vibration:* a 4.75 m ribbed slab is stiff (natural frequency well above 8 Hz expected), the treadmill arm gets a floating floor and pads (DETAILS.md); the engineer to check the frequency and the slab's response under the treadmill (X6).
    #v(3pt)
    #H[5 · The stair (x 0–2.75, y 2.2–7.9)]
    - Two flights side by side, 1.375 m wide each (assumed), 22 risers × 0.164 = 3.60 m, goings 0.28: flight 1 rises from y 7.9 north to a half landing (+1.80, y 2.2–3.4, the store below it, ≈ 1.6 m headroom); flight 2 comes back south and *arrives at y ≈ 6.2 at the south end*, onto the FF landing (y 7.9–9.2) through the stair box's arrival strip.
    - *Opening in the FF slab (L-shaped):* over the half landing and the top of flight 1 (x 0–2.75, y 2.2–3.95: headroom ≥ 2.10 is lost where the floor is above +1.30) and over flight 2 (x 1.375–2.75, y 3.95–6.2). ≈ 8.0 m².
    - *Framing:* trimmers B16 (y 3.95), B17 (x 1.375, between the flights) and B18 (y 6.2), 0.20 × 0.40, on the stair walls x 0 / x 2.75 (columns C2, C3, C9, C10); B16 and B18 bear on B17: the one beam-on-beam of the house, normal at a stair well. Flights: solid slabs 0.15 spanning landing to landing (2.8 m).
    - *Headroom:* under the FF slab over flight 1's lower part ≥ 2.10 (checked by the opening's extent); under the roof over flight 2 ≥ 3.0.
    #v(3pt)
    #H[6 · Glazing and the grid]
    - *Courtyard glazing* (x 4.25 y 6.8–8.9 and 10.7–12.7; x 8.95 y 9.1–11.1): no column in the openings (C17, C18, C26, C27 at the corners); beams B4 / B6 above the heads. *Women's majlis south glazing* (y 6.5, x 5.1–8.1): C21 at x 5.6 sits in it → the glazing is 5.1–5.4 + 5.8–8.1 (accepted with the colonnade). *Living glazing* (y 13.0, x 4.45–8.75): C22 at x 5.6 is the pier (the columns solution, tag v5.0). *Clerestory* (y 19.25, x 6.0–7.0 and 7.6–8.6, +5.00–6.00): C23 at x 5.6 and C28 at x 8.95 are clear of it; the roof beam R5 soffit +6.50 is above the head. *Suite bath east window* (y 9.6–10.35): C33 at y 10.45 clashes (X3).
    #v(3pt)
    #H[7 · Lift shaft, air tower, roof openings]
    - *Lift (future, two stops):* RC walls W1 on x 0, y 0 (outer) and y 2.2, 0.20 m; the east wall x 2.25 blockwork with the future door reveal. The FF slab and the roof over the shaft (2.25 × 2.2) are *framed as openings now and closed with removable precast / lightweight panels* on hidden beams (B11 and the x 2.25 line), so the shaft opens later without cutting. Pit 1.2 m, isolated from the air tunnel.
    - *Air tower* (8.95–10.594 × 0–1.0): rises through both slabs; the openings framed by B15 / R9 (y 1.0) and the walls x 8.95 (W3) and the cut wall (W4); the head above the roof a light RC frame.
    - *Roof openings:* courtyard sky framed by R1, R2, R3 (west, cantilever strip) and R4; suite court by R5, R6 and the FF walls x 5.6 / x 11.586 below the roof. West shaft (1.5 × 1.2) framed in B13 / R10.
  ],
)

// ================= PAGE 6 · conflicts and open questions =================
#pagebreak()
#text(12pt, weight: "bold", fill: green)[Conflicts and open questions for the structural engineer]
#v(2pt)
#set text(7pt)
#let X = (
  ("X1", "accepted", [Column *C22* (5.6, 13.0) stands in the courtyard / living glazing (x 4.45–8.75): the glass is split 4.45–5.45 + 5.75–8.75. A decision of the columns solution (tag v5.0); keep the column round Ø0.30 and detail the glazing around it.]),
  ("X2", "accepted", [Beam *B5* (x 8.95, 6.25 m, 0.25 × 0.55) shows 0.35 m below the dining ceiling, on the ceiling-height change line, soffit ≈ +2.85. Acceptable: it is the step between the two heights. Alternative 0.60 × 0.40 (soffit +3.00).]),
  ("X3", "to fix", [Column *C33* (13.311, 10.45) clashes with the first-floor suite bath east window (y 9.6–10.35): move the column to y 10.6 (the FF bath / dressing wall is on y 10.45, a 0.15 m offset is hidden in the wall) or shorten the window to y 9.6–10.2. The GF kitchen window (y 8.7–10.1) is clear.]),
  ("X4", "rule", [The gym roof's north edge *R6* (y 21.25) must be a *drop* beam, not upturned: the gym roof edge is a railing, not a parapet (solid top +7.20). An upstand of 0.40 would raise the solid top to +7.60 and cut the winter noon sun on the clerestory windows from ≈ 81 % to ≈ 40 %.]),
  ("X5", "flag", [*R6* (6.0 m) is carried by the first-floor walls x 5.6 and x 11.586, which stand on thickened ribs of the men's majlis roof (B20, B21), not on columns: a transfer (wall on a beam). Reason: no column may stand inside the men's majlis. Build those two walls as RC walls 0.20 m (2 m long, from the slab to the roof) so the path roof → wall → rib → GF walls is explicit; the engineer sizes B20 / B21 for it.]),
  ("X6", "flag", [The gym's north wall *y 21.25* (7.7 m) runs across the majlis roof ribs with nothing below: a *light partition* is recommended (100 mm block or dry wall; high obscured windows onto the court). If the owner wants a 200 mm wall, a solid band in the ribbed slab. Gym live load 5 kN/m² and the treadmill's vibration: natural frequency of the 4.75 m ribbed slab to check; floating floor and pads in the arm (DETAILS.md).]),
  ("X7", "flag", [The living's south wall (y 19.25, x 5.6–8.95) is 7 m tall with the clerestory windows, tied at +3.6 only on its south face (men's majlis roof slab) and at +7.0 by the roof: fine for a block wall between columns C23 and C28 (3.35 m), but the engineer confirms the slenderness; RC stiffeners at the window jambs if needed.]),
  ("X8", "flag", [*Colonnade columns C21–C23* end at the first floor (they carry only the edge beam B3). The roof over the gallery strip (1.35 m, y 6.5–13.0) then cantilevers from R3. Option: continue C21 and C22 to the roof inside the gallery railing line (two columns in the gallery, a two-storey colonnade) with a roof edge beam on x 5.6; cleaner structure, two more columns in the upper gallery. Owner / engineer.]),
  ("X9", "missing", [*No soil report:* footing type and depth (pads ≈ 1.5 × 1.5 assumed; Taif granite / weathered rock is usually good), the lift pit (1.2 m), and the *air tunnel under the east band* crossing the ground beams: tunnel depth and the footings of C24–C27 / W3 to coordinate.]),
  ("X10", "flag", [*Suite walls over the kitchen* (x 10.3, y 10.45, x 12.211, y 8.0, y 11.9, y 13.9): light partitions on the ribbed slab, or hidden beams under the bath walls that carry pipes; the *suite bath floor is sunken* (depressed slab ≈ 0.15 over x 10.3–13.311, y 6.5–10.45) with nothing in the kitchen ceiling: a depressed-slab detail inside a ribbed bay.]),
  ("X11", "flag", [*Floor-to-floor 3.60* with a 0.20 slab and 0.50–0.55 drop beams gives 2.85–2.90 m clear under the beams (B4 over the riwaq glazing, B5 at the dining step, B1 in the women's majlis if dropped). Acceptable (≥ 2.40), but the owner should see the women's majlis option (B1 hidden in a 0.30 ribbed slab keeps a flat 3.30 m ceiling).]),
  ("X12", "open", [*Beam B4* (x 4.25, 6.5 + 6.25 m) carries the first-floor bedrooms' east wall over the riwaq glazing (y 6.8–8.9, 10.7–12.7) and the low wall: with 0.25 × 0.50 the glazing heads are at ≤ +2.90; confirm the riwaq window heights with the architect.]),
  ("X13", "open", [*Which walls are RC:* this study proposes W1–W5 (lift, shaft, laundry wall, cut wall, kitchen north wall) as RC 0.20 m for stiffness, plus the two gym walls of X5. The engineer confirms the lateral system (frame + walls) under SBC 301 and the wind / seismic case for Taif.]),
  ("X14", "open", [*Slab types:* ribbed 0.30 (hollow block) for the 4.36–4.75 m bays and the men's majlis roof; solid 0.20 elsewhere and 0.22 flat over the double-height living. The engineer may unify (all ribbed, or all solid 0.20–0.25) for buildability; the clean soffit over the void is the only architectural wish.]),
  ("X15", "open", [*Stair:* flight widths (1.375 m assumed in a 2.75 m well), the L-shaped opening and the trimmers B16–B18, the store under the half landing (≈ 1.6 m headroom), handrails; confirm the arrival strip y 6.2–7.9 at the first floor.]),
)
#table(columns: (auto, auto, 1fr), stroke: none, inset: 2.4pt, fill: (_, y) => if calc.even(y) { rgb("#efece4") },
  [*No.*], [*State*], [*Conflict / question*],
  ..X.map(((n, s, t)) => ([*#n*], [#s], [#t])).flatten())
#v(4pt)
#text(6.5pt, fill: gray)[Rules of thumb used (all assumed): drop beams depth ≈ span / 12, hidden beams = slab depth, solid one-way slabs ≈ span / 24–28 (0.20 for ≤ 5 m), hollow-block ribbed slabs 0.30 (25 + 5) for 4–6 m, flat solid roof 0.22 for 4.7 m, columns 0.25 × 0.50–0.60 in the walls (two storeys, light loads), colonnade Ø0.30, pad footings 1.5 × 1.5 m. Loads: SBC 301 (residential 2 kN/m², gym 5 kN/m², roof 1 kN/m² + plant). Nothing here replaces the structural design.]
#v(2pt)
#text(7pt, weight: "bold", fill: green)[✓ Preliminary structural study · #columns.len() columns · #beams-ff.len() first-floor beams · #beams-roof.len() roof beams · #X.len() items for the engineer]

// structure.typ · Taif / Palm House V6.3 · PRELIMINARY STRUCTURAL STUDY (architectural coordination, not a structural design) · compile THIS file
// Every size here is ASSUMED, to be calculated by the structural engineer. Beam depth = TOTAL depth including the slab (a 0.50 beam under a 0.20 slab drops 0.30). The room outlines come from ../data/rooms_gf.csv and
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
  ("C6", 0, 19.25, "west wall", "0.25×0.60", "roof", "guest WC / basins wall · FF bedroom 3 / gym"),
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
  ("C19", 4.25, 19.25, "courtyard line · majlis north wall", "0.25×0.50", "roof", "living SW corner · FF gym / bedroom 3"),
  ("C20", 4.25, 24, "courtyard line · south wall", "0.25×0.50", "roof", "in the south wall; no FF wall on x 4.25 south of y 19.25 since 1 Nov 2026 (the gym spans it)"),
  ("C21", 5.8, 6.5, "colonnade", "Ø0.30", "roof (X8, owner)", "in the women's majlis south wall; carries B3 and the roof edge beam R11"),
  ("C22", 5.8, 13.0, "colonnade", "Ø0.30", "roof (X8, owner)", "a pier in the courtyard / living glass (accepted); carries B3, R11 and R2's west end"),
  ("C23", 5.8, 19.25, "colonnade", "Ø0.30", "roof (X8, owner)", "in the living's south wall; carries B3 and R5"),
  ("C24", 8.95, 0, "east line · north wall", "0.25×0.50", "roof", "women's majlis / air tower corner"),
  ("C25", 8.95, 3.0, "east line", "0.25×0.50", "roof", "in the solid laundry wall; carries beam B1"),
  ("C26", 8.95, 6.5, "east line", "0.25×0.50", "roof", "courtyard / laundry corner (V6.4: the kitchen's north wall is a partition at y 7.0; B6 on the y 6.5 line)"),
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
)

// ---------- beams: (id, level, a, b, spans, size assumed, kind, carries / note) · kind: drop · hidden · upturned · edge · trimmer ----------
#let beams-ff = (
  ("B1", (4.25, 3.0), (8.95, 3.0), "4.70", "0.25×0.40 total = 0.20 below the slab, soffit +3.20; hidden by the women's majlis gypsum ceiling (≈ +3.05, owner decision)", "drop", "FF kids' room / family living wall (y 3.0, nothing below) + the women's majlis roof"),
  ("B2", (4.25, 6.5), (8.95, 6.5), "1.55 + 3.15", "0.25×0.40 hidden / drop", "edge", "FF slab edge on the courtyard (the family living's steel window W2 stands on it, V6.4); over the women's majlis south glazing"),
  ("B3", (5.8, 6.5), (5.8, 19.25), "6.50 + 6.25", "0.25×0.50 total · UPTURNED (owner's preference: 0.30 above the slab = the sill of the gallery window W1, V6.4) or drop (0.30 below; the engineer decides) · § options", "edge", "the 1.35 m projection and the gallery, on C21–C23"),
  ("B4", (4.25, 6.5), (4.25, 19.25), "6.50 + 6.25", "0.25×0.50 total = 0.30 below the slab, soffit +3.10", "drop", "FF west rooms' east wall (over the riwaq glazing and the living's entrance arch; on the solid TV wall from y 14.5, V6.3) + the projection back span"),
  ("B5", (8.95, 13.0), (8.95, 19.25), "6.25", "0.25×0.55 total = 0.35 below the slab, soffit +3.05 (or 0.60×0.40 wide-shallow, soffit +3.20)", "drop", "FF suite bedroom west wall + half the dining roof; over the open ceiling-height change"),
  ("B6", (8.95, 6.5), (13.311, 6.5), "4.36", "0.25×0.45 total = 0.25 below the slab, soffit +3.15 (V6.4; was hidden 0.30 in the wall)", "drop", "V6.4: no wall below any more (the kitchen's north wall moved to y 7.0 as a non-load-bearing partition): a drop beam from C26 to the east wall inside the laundry / maid room ceiling, hidden by the gypsum ceiling (≈ +3.0); carries the FF bedroom 1 / suite wall above"),
  ("B7", (8.95, 13.0), (13.311, 13.0), "4.36", "hidden 0.30", "hidden", "on the kitchen / dining wall; the suite dressing floor spans over it"),
  ("B8", (2.75, 19.25), (13.311, 19.25), "1.5 + 1.55 + 3.15 + 4.36", "0.25×0.45 total, 0.25 above the wall", "drop", "on the men's majlis north wall; carries the FF bedroom 3 / gym double wall, the suite court north wall, the 7 m living south wall and the office (1 Nov 2026)"),
  ("B9", (0, 24), (13.311, 24), "2.75 + 1.5 + 4.7 + 4.36", "hidden in the 0.25 wall / 0.25×0.45", "hidden", "south wall; men's majlis roof support"),
  ("B10", (2.75, 0), (2.75, 24), "2.2 + 5.7 + 2.5 + 4.0 + 4.85 + 4.75", "hidden 0.20–0.30; 0.25×0.40 at the 5.7 m stair bay", "hidden", "riwaq line: west band slabs and the riwaq slab"),
  ("B11", (0, 2.2), (2.75, 2.2), "2.75", "hidden 0.20", "hidden", "lift / stair wall"),
  ("B12", (0, 7.9), (2.75, 7.9), "2.75", "hidden 0.20", "hidden", "stair / utility wall · FF landing"),
  ("B13", (0, 10.4), (2.75, 10.4), "2.75", "hidden 0.20", "hidden", "utility / hospitality kitchen wall"),
  ("B14", (0, 14.4), (2.75, 14.4), "2.75", "hidden 0.20", "hidden", "basins / family WC wall · FF bedroom 2 / bath 3 wall"),
  ("B15", (8.95, 1.0), (10.594, 1.0), "1.64", "0.20×0.35 edge", "edge", "air tower opening (the tower rises through both slabs)"),
  ("B16", (0, 4.85), (1.3875, 4.85), "1.39", "0.20×0.40 total, soffit +3.20", "trimmer", "stair opening edge over flight 1 (headroom 2.22 m at tread 6, to the beam soffit); its east end on B17 (beam on beam: normal at a stair well)"),
  ("B17", (1.2875, 4.85), (1.2875, 6.45), "1.60", "0.20×0.40 total, soffit +3.20", "trimmer", "stair opening, on flight 1's side of the split (x 1.19–1.39), never over flight 2; ends on B16 and B18"),
  ("B18", (1.2875, 6.45), (2.75, 6.45), "1.46", "0.20×0.40 total, soffit +3.20", "trimmer", "stair opening, the arrival edge (top riser line y 6.35); to the riwaq line beam B10"),
  ("B19", (1.05, 19.25), (1.05, 24), "4.75", "hidden rib 0.30 (in the ribbed majlis roof)", "hidden", "1 Nov 2026: a thickened rib UNDER THE TREADMILL (gym west part, x 0.625–1.465), beside the stiff west edge over the foyer's load-bearing wall; no wall on x 4.25 any more"),
  ("B20", (5.6, 19.25), (5.6, 21.9), "2.65 (+ rib to y 24)", "hidden rib 0.30", "hidden", "FF gym (west part) / suite court wall, nothing below; carries R6's west end"),
  ("B21", (10.0, 19.25), (10.0, 24), "4.75", "hidden rib 0.30", "hidden", "1 Nov 2026: the court / office and gym / office wall x 10.0 for the full 4.75 m (was x 11.586 over 2.0 m under the treadmill arm); carries R6's east end"),
)
#let beams-roof = (
  ("R1", (4.25, 6.5), (8.95, 6.5), "4.70", "0.25×0.45 drop", "edge", "courtyard sky hole, north edge (over the FF family living balustrade line)"),
  ("R2", (4.25, 13.0), (8.95, 13.0), "4.70", "0.25×0.45 drop", "edge", "courtyard sky hole, south edge = the clean double-height roof's north edge"),
  ("R3", (4.25, 0), (4.25, 19.25), "3.0 + 3.5 + 6.5 + 6.25", "0.25×0.50 total, 0.30 above the FF wall", "drop", "on the FF west rooms' east wall; the gallery strip roof spans 1.35 m from it to R11 on the colonnade (X8); 1 Nov 2026: it ends at R5 (no wall on x 4.25 in the south wing: the gym spans it, its roof ribbed N–S from R5 to R8)"),
  ("R11", (5.8, 6.5), (5.8, 13.0), "6.50", "0.25×0.45 total, soffit +6.75", "edge", "roof edge of the courtyard sky over the gallery strip, on C21–C22 (X8, owner: the colonnade continues to the roof, no cantilever)"),
  ("R4", (8.95, 0), (8.95, 24), "3.0 + 3.5 + 6.5 + 6.25 + 4.75", "0.25×0.50 total, 0.30 above the FF wall", "drop", "on the FF suite west wall; the double-height roof spans to it"),
  ("R5", (4.25, 19.25), (13.311, 19.25), "1.55 + 3.15 + 4.36", "0.25×0.50 total, soffit +6.70", "drop", "over the living's south wall (clerestory head +6.00, 0.70 m below the soffit) and the suite court north wall"),
  ("R6", (5.6, 21.9), (10.0, 21.9), "4.4", "0.25×0.50 total, soffit +6.70, DROP (not upturned: winter light, X4)", "drop", "suite court hole, south edge = the gym's south arm roof north edge; on the FF walls x 5.6 and x 10.0 (ribs B20 / B21): load path revised 1 Nov 2026, NOT verified (X5)"),
  ("R7", (0, 0), (13.311, 0), "2.75 + 1.5 + 4.7 + 1.1", "hidden in the 0.25 wall", "hidden", "north wall"),
  ("R8", (0, 24), (13.311, 24), "2.75 + 1.5 + 4.7 + 4.36", "hidden in the 0.25 wall", "hidden", "south wall"),
  ("R9", (8.95, 1.0), (10.594, 1.0), "1.64", "0.20×0.35 edge", "edge", "air tower head opening"),
  ("R10", (2.75, 0), (2.75, 24), "as B10", "hidden 0.20–0.30", "hidden", "riwaq line"),
)
// slab bays: (level, rect x0 y0 x1 y1, type, thickness, direction "EW" | "NS" | "cant W", note)
#let slabs-ff = (
  ((0, 0, 2.75, 2.2), "lift: FF slab opening (the lift is installed at construction, V6.3)", "0.20 solid", "NS", "lift"),
  ((0, 2.2, 2.75, 7.9), "stair: L-shaped opening + flight slabs", "0.15 flights", "NS", "opening x 0.125–1.39 y 2.30–4.75 + x 1.39–2.65 y 2.30–6.35 (about 8.2 m2), see the stair page"),
  ((0, 7.9, 2.75, 10.4), "solid", "0.20", "EW", "utility; shaft opening 1.5×1.2 framed"),
  ((0, 10.4, 2.75, 24), "solid", "0.20", "EW", "west wash block, 2.75 m bays"),
  ((2.75, 0, 4.25, 19.25), "solid", "0.20", "EW", "riwaq, 1.5 m"),
  ((4.25, 0, 8.95, 6.5), "solid", "0.20", "NS", "women's majlis roof: 3.0 + 3.5 m to beam B1"),
  ((4.25, 6.5, 5.8, 19.25), "solid, the projection", "0.20 (0.35 if option c)", "EW", "1.55 m between B4 and the edge beam B3 (V6.4)"),
  ((8.95, 0, 13.311, 6.5), "solid", "0.20", "EW", "maid wing, 4.36 m to the cut wall"),
  ((8.95, 6.5, 13.311, 13.0), "ribbed (hollow block)", "0.30 (25+5)", "EW", "kitchen roof; suite bath sunken 0.15 (depressed zone x 10.3–13.311 y 6.5–10.45)"),
  ((8.95, 13.0, 13.311, 19.25), "ribbed", "0.30", "EW", "dining roof; half on beam B5"),
  ((2.75, 19.25, 13.311, 24), "ribbed", "0.30", "NS", "men's majlis roof, 4.75 m; thickened ribs B19–B21 under the FF walls; gym live load"),
)
#let slabs-roof = (
  ((0, 0, 2.75, 24), "solid", "0.20", "EW", "west band and lift / shaft heads"),
  ((2.75, 0, 4.25, 24), "solid", "0.20", "EW", "riwaq / gallery line"),
  ((4.25, 0, 8.95, 6.5), "solid", "0.20", "EW", "kids' room / family living: 4.7 m, no beam on y 3.0 (light partition)"),
  ((4.25, 6.5, 5.8, 13.0), "solid", "0.20", "EW", "over the gallery strip: 1.55 m from R3 to the roof edge beam R11 on C21–C22 (X8; V6.4)"),
  ((4.25, 13.0, 8.95, 19.25), "solid, flat, no beams in the void", "0.22", "EW", "the double-height living roof: 4.7 m R3 → R4, clean soffit"),
  ((8.95, 0, 13.311, 19.25), "ribbed", "0.30", "EW", "bedroom 1 / suite: 4.36 m"),
  ((0, 19.25, 5.6, 24), "ribbed", "0.30", "NS", "1 Nov 2026: the gym's west part roof, 4.75 m from R5 to R8 (light-roof option: an insulated steel deck on steel beams, to decide)"),
  ((5.6, 21.9, 10.0, 24), "solid", "0.20", "NS", "the gym's south arm roof: 2.1 m; its north edge R6 over the court"),
  ((10.0, 19.25, 13.311, 24), "solid", "0.20", "EW", "the office roof: 3.3 m between the x 10.0 wall (rib B21 below) and the east outer wall (light-roof option)"),
)
// the voids (no slab): FF courtyard sky + double-height; roof courtyard sky + suite court
#let voids-ff = (((5.8, 6.5, 8.95, 13.0), "courtyard sky"), ((5.8, 13.0, 8.95, 19.25), "double-height void"))
#let voids-roof = (((5.8, 6.5, 8.95, 13.0), "courtyard sky"), ((5.6, 19.25, 10.0, 21.9), "suite court"))   // 1 Nov 2026: the roof slab over the stair well is closed (the roof is reached from the external stair tower, studies/south_wing.typ); R16–R18 dropped

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
#text(14pt, weight: "bold", fill: green)[Preliminary structural study · Taif / Palm House V6.3]
#h(6pt) #text(7.5pt, fill: gray)[architectural coordination study · every size ASSUMED, to be calculated by the structural engineer · beam depths are TOTAL depths including the slab · CSV coordinates, north up]
#v(1pt)
#block(fill: rgb("#fbe3dd"), inset: 4pt, radius: 2pt, width: 100%)[#text(7.5pt, weight: "bold", fill: red)[ALL CHECKS PASSED means the drawings are consistent; it does not mean strength, deflection or vibration were calculated.]]
#v(2pt)
#grid(columns: (auto, 1fr), column-gutter: 12pt,
  plan([Ground floor · columns (■ in the walls, ● colonnade, all to the roof: X8), RC boxes (dark), tie beams on the column lines], GF, columns, (), (), (), cores: true),
  [
    #H[The idea: a simple RC skeleton, walls on walls]
    - A *reinforced-concrete frame* (columns, beams, slabs) with *block infill*, as Saudi contractors build every villa. Columns stand on the existing wall lines, hidden in the walls; *every column runs from its footing to the roof* (the three colonnade columns too, since X8: they carry the edge beam B3 and the roof edge beam R11). No transfer beam carries a column.
    - *Spans 2.2–6.5 m.* The only spans above 6 m are on the courtyard lines (x 4.25, 5.8, 8.95: 6.5 and 6.25 m), because the courtyard and the double-height living must stay free of columns; they get drop beams ≈ 0.50–0.55 total depth (0.30–0.35 below the slab).
    - *Slabs:* solid 0.20 m where spans are small (west band, riwaq, projection, roofs of 4.7 m), hollow-block *ribbed 0.30 m* (25+5) for the 4.36–4.75 m bays of the east band and the men's majlis roof. The double-height living's roof is a *flat solid slab 0.22 m spanning 4.7 m east–west* between the two long walls: *no beam crosses the void* (§ options; a common span for a 0.22 solid slab, not calculated).
    - *Foundations (assumed):* isolated pad footings ≈ 1.5 × 1.5 m under the columns, strip footings under the RC boxes, RC tie beams on the column lines at ground level; the lift pit 1.2 m deep; the air duct (studies/air_system.typ v2, route A): a small dry sealed box 0.9 × 0.9 (0.6 × 0.6 clear, assumed) leaving the tower base pit westward and running under the women's majlis to a chamber under the courtyard floor: top −1.00, just under the tie beams, clear of the pads except at its two ends. *No soil report yet* (X9).
    #v(3pt)
    #H[Balanced stiffness · a proposal, NOT calculated]
    - *West:* the lift shaft (W1, RC walls on 3 sides), the west shaft (W2) and the stair walls make a stiff core at x 0–2.75 (its stiffness is not calculated here).
    - *East, to match it:* the solid laundry / maid wall on x 8.95 (W3, no openings, 6.5 m) and the cut wall (W4) are proposed as RC walls 0.20 m (W5, the kitchen's north wall, is dropped in V6.4: that wall is now a partition at y 7.0 and the y 6.5 line is the beam B6), intended as an east box of a similar order of stiffness at a similar distance from the centre, so that the centre of stiffness stays near the centre of mass. *Not calculated:* the engineer models the lateral system (frame + walls) and confirms it.
    - *Why:* the house is a long pentagon (13.3 × 24 m); with stiff elements only on the west, wind and earthquake would tend to twist it about the west core. The seismic design category for Taif and the wind case are to be taken from SBC 301 by the engineer; not assessed here.
    #v(3pt)
    #H[Column lines and spans]
    #table(columns: (auto, 1fr, auto), stroke: none, inset: 2pt, fill: (_, y) => if calc.even(y) { rgb("#efece4") },
      [*Line*], [*Columns at y (or x)*], [*Spans (m)*],
      [x 0 and x 2.75], [y 0 · 2.2 · 7.9 · 10.4 · 14.4 · 19.25 · 24], [2.2 · 5.7 · 2.5 · 4.0 · 4.85 · 4.75],
      [x 4.25 and x 8.95], [y 0 · 3.0 · 6.5 · 13.0 · 19.25 · 24], [3.0 · 3.5 · 6.5 · 6.25 · 4.75],
      [x 5.8 (colonnade, to the FF)], [y 6.5 · 13.0 · 19.25], [6.5 · 6.25],
      [cut wall], [(10.051, 0) · (11.572, 2.8) · (13.311, 6.0)], [3.2 · 3.6],
      [x 13.311], [y 6.0 · 10.45 · 13.0 · 19.25 · 24], [4.45 · 2.55 · 6.25 · 4.75],
      [y 0 / y 24 (cross)], [x 0 · 2.75 · 4.25 · 8.95 · 13.311 (cut corner at 10.051)], [2.75 · 1.5 · 4.7 · 4.36 (1.1)],
      [y 6.5 · 13.0 · 19.25 (cross)], [x 4.25 · 5.8 · 8.95 · 13.311 (+ 2.75 at y 19.25)], [1.55 · 3.15 · 4.36],
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
    #table(columns: (auto, auto, 1fr, 1.3fr), stroke: none, inset: 1.8pt, fill: (_, y) => if calc.even(y) { rgb("#efece4") },
      [*Beam*], [*Span (m)*], [*Size, assumed*], [*Carries / note*],
      ..beams-ff.map(((id, a, b, sp, sz, k, n)) => ([*#id*], [#sp], [#sz], [#n])).flatten())
    #v(2pt)
    #H[First-floor walls and what carries them]
    #table(columns: (1fr, 1fr), stroke: none, inset: 1.8pt, fill: (_, y) => if calc.even(y) { rgb("#efece4") },
      [*On a wall below (block infill under a hidden beam)*], [*Nothing below → beam or light partition*],
      [x 0, x 13.311, y 0, y 24, the cut wall (outer walls); x 2.75 at the lift and landing; x 2.25 lift; y 2.2, 7.9, 10.4 (shaft), 14.4, 16.1 (bath 3 = GF family WC), 19.25 (majlis north wall), x 1.5 shaft; x 8.95 y 6.5–13 (courtyard east wall); y 13.0 line inside the suite (kitchen / dining wall)],
      [*y 3.0* kids' / family living → *B1*; *x 4.25 y 13–19.25* bedrooms' east wall over the riwaq glazing and the entrance arch (on the solid TV wall from y 14.5) → *B4*; *x 8.95 y 13–19.25* suite bedroom west wall over the open ceiling change → *B5*; *y 6.5 x 8.95–13.311* bedroom 1 / suite wall over the maid wing (the kitchen's north wall moved to y 7.0, V6.4) → *B6* drop beam; *x 4.25 y 19.25–24* office → *B19* rib; *x 5.6* gym route → *B20*; *x 11.586* treadmill arm → *B21*; *y 21.25* gym north wall (7.7 m, east–west across the ribs) → *light partition on the slab* (X6); suite walls x 10.3, y 10.45, x 12.211, y 8.0, y 11.9, y 13.9 over the kitchen → light partitions (100 mm block or dry wall) on the ribbed slab, or hidden beams under the bath walls; y 11.0 (bath / niche / bedroom 2) and y 9.2 x 1.5–4.25 (family bath north) → light partitions; x 2.2 bath 3 / bedroom 3 entry → light; y 5.3 and x 10.15 (bedroom 1 / family link) → light; linen front y 0.7 → joinery],
    )
  ],
)

// ================= PAGE 3 · roof =================
#pagebreak()
#text(12pt, weight: "bold", fill: green)[Roof slab (+7.00 … +7.20) · beams and slab directions]
#h(6pt) #text(7pt, fill: gray)[the courtyard sky and the suite court are holes; the double-height living is roofed by a flat slab with no beam in the void; the colonnade C21–C23 continues to the roof (X8), the gallery strip roof on R11]
#v(2pt)
#grid(columns: (auto, 1fr), column-gutter: 12pt,
  plan([Roof slab · beams R1–R10], FF, columns.filter(c => not c.at(5).starts-with("FF")), beams-roof, slabs-roof, voids-roof),
  [
    #set text(6.6pt)
    #table(columns: (auto, auto, 1fr, 1.3fr), stroke: none, inset: 1.8pt, fill: (_, y) => if calc.even(y) { rgb("#efece4") },
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
  let beam(x, z, w, d, col: blue) = rect((x - w / 2, z - d), (x + w / 2, z - lvl.slab), fill: col, stroke: none)   // d = TOTAL depth incl. the slab
  let col(x, z0, z1) = rect((x - 0.15, z0), (x + 0.15, z1), fill: ink, stroke: none)
  let wall(x, z0, z1, t: 0.2) = rect((x - t / 2, z0), (x + t / 2, z1), fill: luma(200), stroke: 0.3pt + luma(120))
  let up(x, z, w, d) = rect((x - w / 2, z - lvl.slab), (x + w / 2, z - lvl.slab + d), fill: orange, stroke: none)   // an upturned beam: d = TOTAL depth from the slab underside
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
    col(5.8, 0, 7.0); T((5.8, -0.4), [C21–C23 Ø0.30 to the roof (X8)], size: 4pt, fill: orange)
    // FF slab: west band to x 5.8 (projection, V6.4), east from 8.95
    slab(-0.125, 5.8, 3.6); slab(8.95, 13.436, 3.6)
    beam(4.25, 3.6, 0.25, 0.5); T((4.25, 2.95), [B4 0.50 total · soffit +3.10], size: 3.8pt, fill: blue, anchor: "east")
    up(5.8, 3.6, 0.25, 0.5); T((5.95, 4.05), [B3 upturned: 0.50 total = 0.30 above the slab, the sill of the gallery window W1], size: 3.8pt, fill: orange, anchor: "west")
    beam(8.95, 3.6, 0.25, 0.3)
    for x in (0, 2.75, 4.25, 8.95, 13.311) { wall(x, 3.6, 7.0, t: if x == 0 or x == 13.311 { 0.25 } else { 0.2 }) }
    T((1.375, 1.7), [utility · shaft], size: 4pt); T((3.5, 1.7), [riwaq], size: 4pt); T((7.27, 1.0), [courtyard · open], size: 4.2pt, fill: blue); T((11.1, 1.7), [kitchen], size: 4pt)
    T((1.375, 5.3), [family bath], size: 4pt); T((3.5, 5.3), [gallery], size: 4pt); T((4.9, 5.0), [proj.], size: 3.6pt); T((11.1, 5.3), [suite lobby · bath], size: 4pt)
    T((7.37, 5.0), [sky 3.15], size: 4.2pt, fill: blue)
    // roof: west to 5.8 (on R11 and the colonnade), east from 8.95
    slab(-0.125, 5.8, 7.2); slab(8.95, 13.436, 7.2)
    beam(4.25, 7.2, 0.25, 0.5); T((4.25, 6.55), [R3], size: 3.8pt, fill: blue, anchor: "east"); beam(8.95, 7.2, 0.25, 0.5); T((9.2, 6.55), [R4], size: 3.8pt, fill: blue, anchor: "west")
    beam(5.8, 7.2, 0.25, 0.45); T((5.2, 7.5), [R11 on C21–C22], size: 3.6pt)
  }),
  sec([B · y 16.5: living (TV wall) · double-height void · dining · suite], (slab, beam, col, wall, T, up) => {
    slab(-0.125, 13.436, 0)
    for x in (0, 2.75, 13.311) { wall(x, 0, 3.4, t: if x == 0 or x == 13.311 { 0.25 } else { 0.2 }) }
    wall(4.25, 0, 1.2); T((4.4, 1.4), [low wall 1.20], size: 3.6pt, anchor: "west")
    col(0, 0, 7.0); col(2.75, 0, 7.0); col(4.25, 0, 7.0); col(8.95, 0, 7.0); col(13.311, 0, 7.0)
    T((4.25, -0.4), [C18–C19 beyond], size: 3.6pt); T((8.95, -0.4), [C27–C28 beyond], size: 3.6pt)
    slab(-0.125, 5.8, 3.6); slab(8.95, 13.436, 3.6)
    beam(4.25, 3.6, 0.25, 0.5); up(5.8, 3.6, 0.25, 0.5)
    beam(8.95, 3.6, 0.25, 0.55); T((9.2, 2.9), [B5 0.55 total = 0.35 below the dining ceiling · soffit +3.05], size: 3.8pt, fill: blue, anchor: "west")
    for x in (0, 2.75, 4.25, 8.95, 13.311) { wall(x, 3.6, 7.0, t: if x == 0 or x == 13.311 { 0.25 } else { 0.2 }) }
    T((1.375, 1.7), [serving], size: 4pt); T((3.5, 1.7), [riwaq], size: 4pt); T((6.6, 2.4), [living · double height], size: 4.4pt); T((11.1, 1.7), [dining · ceiling +3.40], size: 4pt)
    T((1.375, 5.3), [bedroom 3], size: 4pt); T((3.5, 5.3), [gallery], size: 4pt); T((11.1, 5.3), [suite bedroom], size: 4pt)
    slab(-0.125, 13.436, 7.2)
    beam(4.25, 7.2, 0.25, 0.5); beam(8.95, 7.2, 0.25, 0.5); T((6.6, 6.55), [roof: flat solid 0.22, 4.7 m, no beam in the void], size: 3.8pt, fill: green)
  }),
)
#v(4pt)
#cetz.canvas(length: 0.52cm, {
  import cetz.draw: *
  let T(p, t, size: 4.6pt, fill: ink, anchor: "center") = content(p, anchor: anchor, text(size, fill: fill, t))
  let slab(y0, y1, z) = rect((y0, z - lvl.slab), (y1, z), fill: luma(120), stroke: none)
  let beam(y, z, w, d, col: blue) = rect((y - w / 2, z - d), (y + w / 2, z - lvl.slab), fill: col, stroke: none)   // d = TOTAL depth
  let wall(y, z0, z1, t: 0.2) = rect((y - t / 2, z0), (y + t / 2, z1), fill: luma(200), stroke: 0.3pt + luma(120))
  line((-1, 0), (25, 0), stroke: 0.8pt + ink)
  for (z, l) in ((0, [±0.00]), (3.6, [+3.60]), (7.2, [+7.20])) { T((-1.0, z), l, size: 4.2pt, fill: gray, anchor: "east") }
  slab(-0.125, 24.125, 0)
  for y in (0, 6.5, 13.0, 19.25, 24) { wall(y, 0, 3.4, t: if y == 0 or y == 24 { 0.25 } else { 0.2 }) }
  T((3.25, 1.7), [women's majlis]); T((9.75, 1.0), [courtyard · open], fill: blue); T((16.1, 2.4), [living · double height]); T((21.6, 1.7), [men's majlis])
  slab(-0.125, 6.5, 3.6); slab(19.25, 24.125, 3.6)
  beam(3.0, 3.6, 0.25, 0.4); T((3.0, 2.95), [B1 0.40 total · soffit +3.20 (or hidden in 0.30 rib)], size: 3.8pt, fill: blue)
  beam(6.5, 3.6, 0.25, 0.4); T((6.75, 2.95), [B2], size: 3.8pt, fill: orange, anchor: "west")
  beam(19.25, 3.6, 0.25, 0.45); T((19.0, 2.95), [B8], size: 3.8pt, fill: blue, anchor: "east")
  T((21.6, 3.95), [majlis roof: ribbed 0.30, ribs N–S 4.75], size: 3.8pt, fill: green)
  wall(3.0, 3.6, 7.0, t: 0.1); T((3.0, 5.3), [kids' · living · y 3.0 light], size: 3.8pt)
  wall(19.25, 3.6, 7.0); line((19.25, 5.0), (19.25, 6.0), stroke: 2.5pt + rgb("#1f7a99")); T((19.0, 5.5), [clerestory +5.00–6.00], size: 3.6pt, fill: rgb("#1f7a99"), anchor: "east")
  wall(21.25, 3.6, 7.0, t: 0.1); T((21.25, 5.3), [gym N wall · light], size: 3.6pt); wall(24, 3.6, 7.0, t: 0.25)
  T((20.25, 4.6), [suite court · open], size: 3.6pt, fill: blue)
  slab(-0.125, 6.5, 7.2); slab(13.0, 19.25, 7.2); slab(21.25, 24.125, 7.2)
  beam(6.5, 7.2, 0.25, 0.45); T((6.5, 6.55), [R1], size: 3.8pt, fill: orange); beam(13.0, 7.2, 0.25, 0.45); T((13.0, 6.55), [R2], size: 3.8pt, fill: orange)
  beam(19.25, 7.2, 0.25, 0.5); T((19.0, 6.35), [R5 soffit +6.70 ≥ head +6.00], size: 3.6pt, fill: blue, anchor: "east")
  beam(21.25, 7.2, 0.25, 0.5); T((21.5, 6.85), [R6 drop, not upturned · path not verified], size: 3.6pt, fill: blue, anchor: "west")
  T((9.75, 6.4), [sky], fill: blue); T((16.1, 6.6), [DH roof flat, clean], size: 3.8pt, fill: green)
  T((-1, -0.6), [N], anchor: "west"); T((24, -0.6), [S], anchor: "east"); T((12, 8.4), [C · x 7.3: women's majlis · courtyard · double-height living · men's majlis roof · gym], size: 6pt)
})


// ================= PAGE 5 · the stair =================
#pagebreak()
#text(12pt, weight: "bold", fill: green)[The stair · plan at the first-floor opening and section · all sizes assumed]
#h(6pt) #text(7pt, fill: gray)[well x 0–2.75 · y 2.2–7.9 (wall centre lines) · 22 risers × 0.164 = 3.60 m · goings 0.28 · two flights side by side · headroom measured to the beam soffits]
#v(2pt)
#let st = (x0: 0.125, x1: 2.65, y0: 2.30, y1: 7.80, land: 3.55, top: 6.35, split: 1.3875, gap: 0.10, r: 3.6 / 22, g: 0.28, b16: 4.85, b17: 1.2875, b18: 6.45)
#grid(columns: (auto, auto, 1fr), column-gutter: 14pt,
  cetz.canvas(length: 1.5cm, {
    import cetz.draw: *
    let T(p, t, size: 4.4pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, t))
    // walls (centre lines x 0, 2.75; y 2.2, 7.9) and the clear well
    rect(q((-0.125, 2.1)), q((0.125, 8.0)), fill: luma(190), stroke: none)
    rect(q((-0.125, 2.1)), q((2.85, 2.3)), fill: luma(190), stroke: none); rect(q((-0.125, 7.8)), q((2.85, 8.0)), fill: luma(190), stroke: none)
    rect(q((2.65, 2.1)), q((2.85, 2.4)), fill: luma(190), stroke: none); rect(q((2.65, 6.8)), q((2.85, 8.0)), fill: luma(190), stroke: none)
    line(q((2.75, 2.4)), q((2.75, 6.8)), stroke: (paint: luma(120), dash: "dashed", thickness: 0.6pt)); T((2.9, 4.6), [open to the riwaq (GF) · railing (FF)], size: 3.6pt, angle: 90deg, anchor: "center")
    // FF slab (hatched grey) and the opening (white)
    rect(q((st.x0, st.y0)), q((st.x1, st.y1)), fill: luma(225), stroke: none)
    rect(q((st.x0, st.y0)), q((st.split, st.b16 - 0.1)), fill: white, stroke: 0.4pt + ink)
    rect(q((st.split, st.y0)), q((st.x1, st.top)), fill: white, stroke: 0.4pt + ink)
    // half landing
    rect(q((st.x0, st.y0)), q((st.x1, st.land)), fill: rgb("#f3dfb8"), stroke: 0.3pt + ink); T((1.39, 2.92), [half landing +1.80\ 1.25 deep · store below], size: 4pt)
    // flight 1 (west, up to the north) and flight 2 (east, up to the south)
    for i in range(10) {
      let y = st.top - i * st.g
      line(q((st.x0, y)), q((st.split - st.gap / 2, y)), stroke: 0.4pt + ink)
      line(q((st.split + st.gap / 2, st.land + i * st.g)), q((st.x1, st.land + i * st.g)), stroke: 0.4pt + ink)
      T((st.x0 + 0.18, y - 0.14), [#(i + 1)], size: 3.2pt); T((st.x1 - 0.18, st.land + i * st.g + 0.14), [#(i + 12)], size: 3.2pt)
    }
    line(q((st.x0, st.land)), q((st.split - st.gap / 2, st.land)), stroke: 0.4pt + ink); line(q((st.split + st.gap / 2, st.top)), q((st.x1, st.top)), stroke: 0.4pt + ink)
    line(q((0.75, st.top + 0.6)), q((0.75, st.land + 0.35)), stroke: 0.8pt + red, mark: (end: "stealth", fill: red, scale: 0.5)); T((0.42, 5.0), [UP · flight 1], size: 3.8pt, fill: red, angle: 90deg)
    line(q((2.02, st.land + 0.35)), q((2.02, st.top - 0.35)), stroke: 0.8pt + red, mark: (end: "stealth", fill: red, scale: 0.5)); T((2.34, 5.0), [flight 2 · UP], size: 3.8pt, fill: red, angle: 90deg)
    rect(q((st.split - st.gap / 2, st.land)), q((st.split + st.gap / 2, st.top)), fill: luma(120), stroke: none); T((st.split, 5.0), [gap 0.10 · handrail], size: 3.2pt, angle: 90deg)
    T((2.02, 7.05), [arrival at +3.60\ y 6.35–7.80], size: 3.8pt); T((0.75, 7.05), [GF: start of flight 1\ FF: slab], size: 3.8pt)
    // trimmers
    line(q((st.x0, st.b16)), q((st.split, st.b16)), stroke: 2.2pt + red); T((0.7, st.b16 + 0.22), [B16 0.20×0.40 · soffit +3.20], size: 3.4pt, fill: red)
    line(q((st.b17, st.b16)), q((st.b17, st.b18)), stroke: 2.2pt + red); T((st.b17 - 0.12, 5.65), [B17], size: 3.4pt, fill: red, angle: 90deg)
    line(q((st.b17, st.b18)), q((2.75, st.b18)), stroke: 2.2pt + red); T((2.1, st.b18 + 0.22), [B18], size: 3.4pt, fill: red)
    T((0.75, 3.9), [opening], size: 4pt, fill: luma(100)); T((2.02, 4.7), [opening], size: 4pt, fill: luma(100))
    // dimensions
    line(q((st.x0, 1.75)), q((st.x1, 1.75)), stroke: 0.4pt + ink, mark: (start: "|", end: "|", scale: 0.4)); T((1.39, 1.55), [2.525 clear], size: 3.6pt)
    line(q((st.x0, 1.95)), q((st.split - st.gap / 2, 1.95)), stroke: 0.4pt + ink, mark: (start: "|", end: "|", scale: 0.4)); T((0.72, 2.12), [1.21], size: 3.4pt)
    line(q((st.split + st.gap / 2, 1.95)), q((st.x1, 1.95)), stroke: 0.4pt + ink, mark: (start: "|", end: "|", scale: 0.4)); T((2.05, 2.12), [1.21], size: 3.4pt)
    line(q((3.25, st.y0)), q((3.25, st.y1)), stroke: 0.4pt + ink, mark: (start: "|", end: "|", scale: 0.4)); T((3.45, 5.05), [5.50 clear = 1.25 + 2.80 + 1.45], size: 3.6pt, angle: 90deg)
    T((1.39, 1.2), [stair plan at the first-floor slab · white = opening · grey = slab · north up], size: 4.4pt, fill: green)
  }),
  cetz.canvas(length: 1.5cm, {
    import cetz.draw: *
    let T(p, t, size: 4.4pt, fill: ink, anchor: "center", angle: 0deg) = content(p, anchor: anchor, angle: angle, text(size, fill: fill, t))
    // section along flight 1 (x ≈ 0.75), looking east: horizontal = y (north left), vertical = level
    let Y(y) = y - st.y0
    line((Y(1.9), 0), (Y(8.3), 0), stroke: 0.8pt + ink)
    rect((Y(2.1), 0), (Y(2.3), 7.2), fill: luma(190), stroke: none); rect((Y(7.8), 0), (Y(8.0), 7.2), fill: luma(190), stroke: none)
    // flight 1 steps
    for i in range(11) {
      let y = st.top - i * st.g; let z = i * st.r
      line((Y(y), z), (Y(y), z + st.r), stroke: 0.6pt + ink); line((Y(y), z + st.r), (Y(y - st.g), z + st.r), stroke: 0.6pt + ink)
    }
    line((Y(5.88), 0), (Y(st.land), 1.5), (Y(st.land), 1.65), stroke: 0.4pt + luma(120))   // flight 1 soffit, 0.15 slab + waist
    // half landing slab and the store below
    rect((Y(st.y0), 1.8 - 0.15), (Y(st.land), 1.8), fill: luma(120), stroke: none); T((Y(2.9), 0.8), [store\ ≈ 1.65 headroom], size: 3.6pt)
    // flight 2 behind (dashed): from the landing up to the south
    line(..range(11).map(i => (Y(st.land + i * st.g), 1.8 + i * st.r)), stroke: (paint: luma(120), dash: "dashed", thickness: 0.6pt)); T((Y(6.0), 2.35), [flight 2 beyond (east)], size: 3.6pt, fill: luma(110), anchor: "west")
    // FF slab over flight 1 lower treads (y 4.75–7.80) + B16 trimmer; B18 beyond
    rect((Y(4.75), 3.4), (Y(7.8), 3.6), fill: luma(120), stroke: none)
    rect((Y(4.75), 3.2), (Y(4.95), 3.4), fill: red, stroke: none); T((Y(4.85), 3.05), [B16 soffit +3.20], size: 3.4pt, fill: red)
    rect((Y(6.35), 3.2), (Y(6.55), 3.4), fill: red.transparentize(50%), stroke: none); T((Y(6.45), 3.05), [B18 beyond], size: 3.2pt, fill: red)
    // roof
    rect((Y(4.75), 7.0), (Y(7.8), 7.2), fill: luma(120), stroke: none); rect((Y(4.75), 6.8), (Y(4.95), 7.0), fill: red, stroke: none); T((Y(3.5), 7.45), [1 Nov 2026: the roof slab over the well is closed (no R16–R18): the roof is reached from the external stair tower], size: 3.4pt, fill: red)
    // headroom at tread 6
    let z6 = 6 * st.r
    line((Y(4.67), z6), (Y(4.67), 3.2), stroke: (paint: green, thickness: 0.6pt), mark: (start: "|", end: "|", scale: 0.4)); T((Y(4.55), 2.1), [2.22 ≥ 2.10\ tread 6 → B16], size: 3.4pt, fill: green, anchor: "east")
    line((Y(5.5), 3 * st.r), (Y(5.5), 3.4), stroke: (paint: green, thickness: 0.5pt, dash: "dotted"), mark: (start: "|", end: "|", scale: 0.4)); T((Y(5.6), 2.4), [2.91 to the slab], size: 3.2pt, fill: green, anchor: "west")
    for (z, l) in ((0, [±0.00]), (1.8, [+1.80]), (3.6, [+3.60]), (7.2, [+7.20])) { T((Y(1.85), z), l, size: 3.6pt, fill: gray, anchor: "east") }
    T((Y(2.2), -0.4), [N], size: 4pt); T((Y(7.9), -0.4), [S], size: 4pt)
    T((Y(5.0), 7.7), [section along flight 1 (x ≈ 0.75), looking east], size: 4.4pt, fill: green)
  }),
  [
    #set text(6.6pt)
    #H[Numbers (assumed)]
    - *Well:* 2.75 × 5.70 m on wall centre lines = *2.525 × 5.50 m clear* (0.25 outer wall west, 0.20 walls north and south; the east side is open to the riwaq on the ground floor and a railing on the first floor).
    - *Rise:* 3.60 m = *22 risers × 0.164 m*, 11 per flight; *goings 0.28 m*, 10 per flight = 2.80 m.
    - *Plan:* half landing 1.25 m (y 2.30–3.55) at the north end, flights y 3.55–6.35, arrival 1.45 m (y 6.35–7.80) at the south end: *1.25 + 2.80 + 1.45 = 5.50 = the clear length. It fits.*
    - *Flight clear width:* (2.525 − 0.10 gap) / 2 = *1.21 m each*, ≈ 1.13 m between a wall handrail (0.08) and the central handrail; ≥ 0.90 m (residential). Flight 1 west, up to the north; flight 2 east, up to the south.
    - *Flight slabs:* 0.15 m solid, spanning landing to landing (2.80 m); the half landing on the stair walls (store under it, ≈ 1.65 m headroom: a store, not a room).
    #v(2pt)
    #H[Opening in the first-floor slab (L-shaped, ≈ 8.2 m²)]
    - *Over flight 1 only beyond tread 6:* the slab above a tread must leave ≥ 2.10 m to the *beam* soffit (+3.20 with 0.40 total trimmers), so treads with a level ≤ 1.10 m may stay under the slab: treads 1–6 (tread 6 at +0.98 → 2.22 m). The opening edge B16 is at y 4.85 (beam 4.75–4.95), north of tread 6 (y 4.67–4.95) — tread 7 (y 4.39–4.67, +1.15) is under open sky.
    - *Over flight 2 and the half landing:* fully open (x 1.39–2.65, y 2.30–6.35 and x 0.125–1.39, y 2.30–4.75).
    - *Trimmers, 0.20 × 0.40 total, soffit +3.20:* B16 (y 4.85, from the west wall to B17), B17 (x 1.29, on flight 1's side of the split so it is never over flight 2, from B16 to B18), B18 (y 6.45, the arrival edge, from B17 to the riwaq line beam B10). B16 and B18 bear on B17: one beam-on-beam zigzag, normal at a stair well; the engineer takes the torsion.
    - *Headroom:* 2.22 m at tread 6 to B16; 2.91 m at tread 3 to the slab; under B17 (over flight 1 treads 1–5, level ≤ 0.82) ≥ 2.38 m; flight 2 and the half landing are under flight 4 and the upper half landing (≥ 3.4 m, the same geometry one storey up; V6.4: the stair continues to the roof, studies/roof.typ). *No conflict with the reservation.*
    - *Arrival:* flight 2 lands at +3.60 on the arrival strip y 6.35–7.80 inside the stair box, then the landing room (y 7.9–9.2) and the gallery.
  ],
)

// ================= PAGE 6 · special zones =================
#pagebreak()
#text(12pt, weight: "bold", fill: green)[Special zones · options compared (none imposed)]
#v(2pt)
#set text(6.7pt)
#grid(columns: (1fr, 1fr), column-gutter: 14pt,
  [
    #H[1 · The west projection: edge beam B3 on C21–C23 (spans 6.5 and 6.25 m)]
    #table(columns: (auto, 1fr, 1fr, 1fr), stroke: none, inset: 2pt, fill: (_, y) => if calc.even(y) { rgb("#efece4") },
      [], [*(a) drop beam*], [*(b) upturned beam*], [*(c) deeper slab edge*],
      [size (total, incl. the 0.20 slab)], [0.25 × 0.50: 0.30 below the slab, soffit +3.10], [0.25 × 0.50: 0.30 above the structural slab (top +3.90), i.e. ≈ 0.22–0.25 visible above a finished floor of 0.05–0.08; if the engineer needs 0.60 total, 0.40 above the slab], [slab 0.35 over the 1.35 m strip, no beam],
      [what you see], [a 0.30 m downstand along the colonnade, 3.10 clear under it; the courtyard reads as a riwaq with a beam], [a flush soffit at +3.40 over the colonnade; the upstand is the solid base of the gallery railing, the railing on it up to 1.10], [flush soffit, a thicker slab edge 0.35 seen from the courtyard],
      [structure], [standard; the stiffest], [standard; the slab hangs from the beam's bottom (stirrups) – routine], [a 1.35 m wide, 0.35 deep band over 6.5 m: depth/span ≈ 1/18, deflection-sensitive, heavy],
      [cost], [lowest], [≈ same formwork; saves the railing base], [more concrete and steel],
      [note], [an acceptable alternative], [*the owner's architectural preference*: flush colonnade soffit, railing base included; the engineer decides between (a) and (b)], [only if a flush soffit AND an open railing are wanted],
    )
    #v(3pt)
    #H[2 · The double-height living: a clean ceiling (preferred, not a rule)]
    - *Option 1 · flat solid roof slab 0.22 m spanning 4.7 m east–west* from the FF west rooms' wall (R3) to the suite wall (R4): no beam in the void, the two beams sit on the walls (invisible). A common span for a 0.22 solid slab (not calculated); cost ≈ a normal solid slab. *This study's preference.*
    - *Option 2 · ribbed 0.30 slab, ribs east–west:* lighter and cheaper for the contractor, but a ribbed soffit (or a false ceiling) over the void; still no cross beam.
    - *Option 3 · a cross beam on y 16.1 (mid-void) + 0.18 slab:* the cheapest in material, but a 0.45 m beam across the void, 7 m up, in the family's main room. Not recommended unless the engineer finds option 1 too deep.
    - The void's walls: x 4.25 and x 8.95 are 7 m high but tied by the FF slab on their outer sides (the gallery / projection on the west, the suite floor on the east). The south wall (y 19.25, x 5.6–8.95, with the clerestory) is tied at +3.6 only by the men's majlis roof slab on its south face, and at +7.0 by the roof: *one tall wall, 7 m, tied on one side at mid-height* (X7).
    #v(3pt)
    #H[3 · Living ↔ dining opening (x 8.95, 6.25 m) under the suite wall: beam B5]
    - A drop beam 0.25 × 0.55 total between C27 (8.95, 13.0) and C28 (8.95, 19.25); it carries the suite bedroom's west wall (3.4 m block), half the dining roof (ribbed, 4.36 m) and the roof beam R4 above the wall. 0.35 below the 0.20 slab: soffit +3.05 before finishes.
    - *It can sit exactly on the ceiling-height change line:* the dining ceiling is at +3.40, the living has no ceiling, so the beam's 0.35 m below the dining ceiling becomes the step itself: one face of the double height. Headroom under it 3.05 m (≥ 2.40 required).
    - *Alternative:* a wide-shallow beam 0.60 × 0.40 total (soffit +3.20) if the step should be thinner; or make the suite wall a light partition so the beam carries only the slab (0.25 × 0.45 total, soffit +3.15).
  ],
  [
    #H[4 · Men's majlis roof (10.56 × 4.75 m) carrying the gym, the arm and the office]
    - *Span direction north–south, 4.75 m:* a ribbed (hollow-block) slab 0.30 m (25+5), ribs from the majlis north wall (B8) to the south wall (B9). *No column inside the majlis* (the room must stay free: 10.56 m long, seating at the east end).
    - *The swapped wing (1 Nov 2026):* the first-floor walls *parallel to the ribs* each stand on a *thickened rib / hidden beam*: x 5.6 (gym west part / court, B20, 2.65 m) and x 10.0 (court / office and gym / office, B21, the full 4.75 m): direct and cheap; the *treadmill* on the slab's west edge strip over the foyer's load-bearing west wall, with its own thickened rib B19 (x 1.05) under it. No wall on x 4.25 any more.
    - The court's south wall *y 21.9 runs across the ribs* for 4.4 m with nothing below: *a light partition* (100 mm block or dry wall, high windows onto the court) on the slab, designed for a partition load: *recommended* (X6). The court's roof edge R6 (4.4 m, drop) bears on the two walls: the transfer of X5, lighter than before, *not verified*.
    - *Roof over the wing:* the gym's west part ribbed 0.30 N–S (4.75 m, R5 → R8), the south arm solid 0.20 (2.1 m), the office solid 0.20 spanning east–west (3.3 m, on the x 10.0 wall and the east outer wall). *Light-roof option* (owner to decide): an insulated steel deck on steel beams over the gym's west part and the office, ≈ 2–3 kN/m² less on the majlis ribs; the PV zone Z4 and the parapet detail to design with it.
    - *Loads:* it is a *home gym* (light equipment, no dropped heavy weights, one treadmill): the engineer chooses a normal residential-gym live load as they judge (SBC 301 gives 5 kN/m² for gymnasia; what applies to a home gym is the engineer's call); the treadmill ≈ 1.5–2 kN dynamic (manufacturer's data); office 2.5–3 kN/m². *Vibration: not calculated here.* The natural frequency of the 4.75 m ribbed slab and its response under the treadmill (now beside the stiff west edge, on B19) must be checked by the engineer; the treadmill gets a floating floor and pads (DETAILS.md) in any case (X6).
    #v(3pt)
    #H[5 · The stair (x 0–2.75, y 2.2–7.9)]
    - Drawn on the stair page: two flights of 1.21 m clear, 22 risers of 0.164 m, goings 0.28, a half landing 1.25 m deep at the north end, the arrival at the south end; the L-shaped opening of about 8.2 m² and the trimmers B16–B18 (0.40 total, soffit +3.20); headroom 2.22 m at the opening edge, measured to the trimmer soffit. *It fits the reservation.*
    #H[6 · Glazing and the grid]
    - *Courtyard glazing* (x 4.25 y 6.8–8.9 and 10.7–12.7; x 8.95 y 9.1–11.1): no column in the openings (C17, C18, C26, C27 at the corners); beams B4 / B6 above the heads. *Women's majlis south glazing* (y 6.5, x 5.1–8.1): C21 at x 5.8 sits in it → the glazing is 5.1–5.6 + 6.0–8.1 (accepted with the colonnade; V6.4). *Living glazing* (y 13.0, x 4.45–8.75): C22 at x 5.8 is the pier (the columns solution, tag v5.0). *Clerestory* (y 19.25, x 6.0–7.0 and 7.6–8.6, +5.00–6.00): C23 at x 5.6 and C28 at x 8.95 are clear of it; the roof beam R5 soffit +6.70 is 0.70 above the head. *Suite bath east window*, shortened by the owner to y 9.6–10.2: the clearance to C33 depends on the column's length along the wall, see X3.
    #v(3pt)
    #H[7 · Lift shaft, air tower, roof openings]
    - *Lift (future, two stops):* RC walls W1 on x 0, y 0 (outer) and y 2.2, 0.20 m; the east wall x 2.25 blockwork with the future door reveal. The FF slab and the roof over the shaft (2.25 × 2.2) are *framed as openings now and closed with removable precast / lightweight panels* on hidden beams (B11 and the x 2.25 line), so the shaft opens later without cutting. Pit 1.2 m, isolated from the air tunnel.
    - *Air tower* (8.95–10.594 × 0–1.0): rises through both slabs; the openings framed by B15 / R9 (y 1.0) and the walls x 8.95 (W3) and the cut wall (W4); the head 2.5 m above the roof in the same RC walls (studies/air_system.typ). *Below the slab the shaft walls continue to −1.95 as a dry base pit*, from which the small air duct (a sealed box 0.9 × 0.9, top −1.00, underside −1.90) leaves westward through the W3 line and runs south under the women's majlis on x 7.27 to the outlet chamber under the courtyard floor (x 6.75–7.95, y 6.6–7.6, floor −2.10, between the C21 and C26 pads); the outlet is a grille in the wall base at +0.2 … +0.8 through a plenum in the wall. The pit is the foundation of C24 / C30 and of the W3 / W4 ends; the women's majlis south wall bridges the duct mouth on a ground beam (air study items A1–A3). No water anywhere in the system.
    - *Roof openings:* courtyard sky framed by R1, R2, R11 (west, on the colonnade, X8) and R4, the gallery strip roof between R3 and R11; suite court by R5, R6 and the FF walls x 5.6 / x 11.586 below the roof. West shaft (1.5 × 1.2) framed in B13 / R10.
  ],
)

// ================= PAGE 7 · conflicts and open questions =================
#pagebreak()
#text(12pt, weight: "bold", fill: green)[Conflicts and open questions for the structural engineer]
#v(2pt)
#set text(7pt)
#let X = (
  ("X1", "accepted", [Column *C22* (5.8, 13.0; V6.4, was 5.6) stands in the courtyard / living glazing (x 4.45–8.75): the glass is split 4.45–5.55 + 6.05–8.75 (the Ø0.40 stone sleeve); above the glass head the steel window W3 (+2.90 … +6.75) closes the void to the courtyard (V6.4, enclosure A). A decision of the columns solution (tag v5.0); keep the column round Ø0.30 and detail the glazing around it.]),
  ("X2", "accepted", [Beam *B5* (x 8.95, 6.25 m, 0.25 × 0.55 total) shows 0.35 m below the dining ceiling, on the ceiling-height change line, soffit +3.05 before finishes. Acceptable: it is the step between the two heights. Alternative 0.60 × 0.40 total (soffit +3.20).]),
  ("X3", "owner decided · resolved (V6.3)", [*C33 stays at (13.311, 10.45); the suite bath east window is 0.55 m, y 9.50–10.05 (V6.3).* Its frame (0.05) clears the assumed 0.25 × 0.60 column lying along the wall (y 10.15–10.75) by 0.05 m, and any smaller column by more: no clash for any column ≤ 0.60 along the wall. The GF kitchen window (y 8.7–10.1) is clear.]),
  ("X4", "rule", [The gym roof's north edge *R6* (y 21.9) must be a *drop* beam, not upturned: the gym roof edge is a railing, not a parapet (solid top +7.20). An upstand of 0.40 would raise the solid top to +7.60 and cut the winter noon sun on the clerestory windows from ≈ 81 % to ≈ 40 %.]),
  ("X5", "load path revised (1 Nov 2026), NOT verified", [*Load path revised, not verified:* with the south wing swapped (studies/south_wing.typ) the court's roof edge *R6 is 4.4 m* (was 6.0) between the walls x 5.6 and x 10.0, which stand on thickened ribs of the men's majlis roof (B20 2.65 m long, B21 now the full 4.75 m), not on columns: still a transfer (wall on a rib), no column inside the majlis. *Traced: it improved.* R6's span and the load it brings to each wall fall ≈ 27 %; the x 10.0 wall is 4.75 m long on a full-length rib (a deep-beam action over the rib, instead of a 2 m wall at x 11.586); the treadmill moves from the arm over the bedroom-side rib to the slab's west edge over the foyer's load-bearing wall, with its own rib B19 (x 1.05): the vibration source sits on the stiffest strip. New: the office roof spans 3.3 m east–west onto the east outer wall (small), the gym's west part roof is a 5.6 m wide ribbed bay (as the old office roof, 1.35 m wider). *The engineer must confirm:* B20 / B21 sizes and deflection under the walls and R6; R6's bearings (and the lintel over the office door at y 22.95 on the same wall); the majlis roof's vibration under the treadmill (B19, the floating floor, X6); the light-roof option (steel deck over the gym west part and the office: ≈ 2–3 kN/m² less on the ribs; the PV fixings and the parapet detail); the east wall taking the office roof. In the 3D model R6 and the two walls stay *unconfirmed* (red) until then. Loads: a home gym, see § 4.]),
  ("X6", "flag", [The court's south wall *y 21.9* (the gym's south arm north wall, 4.4 m, x 5.6–10.0; 1 Nov 2026) runs across the majlis roof ribs with nothing below: a *light partition* (100 mm block or dry wall; high windows onto the court, sill +1.8) on the slab, designed for a partition load. The treadmill gets a floating floor and anti-vibration pads in any case; the slab's response under it is the engineer's (B19).]),
  ("X7", "flag", [The living's south wall (y 19.25, x 5.6–8.95) is 7 m tall with the clerestory windows, tied at +3.6 only on its south face (men's majlis roof slab) and at +7.0 by the roof: its slenderness between columns C23 and C28 (3.35 m) is *not checked here*; the engineer confirms it, with RC stiffeners at the window jambs if needed.]),
  ("X8", "owner decided", [*Colonnade columns C21–C23 continue to the roof* inside the gallery railing line (a two-storey colonnade, slender round columns ≈ Ø0.30 assumed). The roof over the gallery strip (1.55 m, y 6.5–13.0; V6.4) rests on a roof edge beam *R11* (x 5.8, 0.25 × 0.45 total) between C21 and C22: no roof cantilever. C22 also takes the west end of R2, C23 stands under R5. The engineer sizes the columns for two storeys and the two roof beams.]),
  ("X9", "missing", [*No soil report, no soil data:* footing type and depth (pads ≈ 1.5 × 1.5 assumed, underside ≈ −1.50), the lift pit (1.2 m), and the *air duct* (studies/air_system.typ v2): a small sealed box 0.9 × 0.9, top −1.00 / underside −1.90, leaving the tower base pit (to −1.95) through the W3 / C24 line and running under the women's majlis to the outlet chamber under the courtyard floor (floor −2.10) between the C21 and C26 pads; the pit as the foundation of C24 / C30 and the W3 / W4 ends, the ground beam of the majlis south wall over the duct mouth: engineer (air items A1–A3).]),
  ("X10", "flag", [*Suite walls over the kitchen* (x 10.3, y 10.45, x 12.211, y 8.0, y 11.9, y 13.9): light partitions on the ribbed slab, or hidden beams under the bath walls that carry pipes; the *suite bath floor is sunken* (depressed slab ≈ 0.15 over x 10.3–13.311, y 6.5–10.45) with nothing in the kitchen ceiling: a depressed-slab detail inside a ribbed bay.]),
  ("X11", "flag", [*Floor-to-floor 3.60* with a 0.20 slab and beams of 0.40–0.55 total depth gives 3.05–3.20 m clear under the beams before finishes (B4 soffit +3.10 over the riwaq glazing, B5 +3.05 at the dining step, B1 +3.20 in the women's majlis). Acceptable (≥ 2.40). *Owner decision:* B1 is a drop beam hidden by a gypsum ceiling (≈ +3.05); the general rule is that drop beams in finished rooms are hidden by gypsum ceilings, which also carry the hidden AC and lighting.]),
  ("X12", "open", [*Beam B4* (x 4.25, 6.5 + 6.25 m) carries the first-floor bedrooms' east wall over the riwaq glazing (y 6.8–8.9, 10.7–12.7) and the low wall: with 0.25 × 0.50 total (soffit +3.10) the riwaq glazing heads are at ≤ +3.10 before finishes, and the dining-side heads under B5 at ≤ +3.05; confirm the window heights with the architect.]),
  ("X14", "owner decided (V6.4)", [*The kitchen's north wall moves to y 7.0* (maid room to the municipal minimum): a *non-load-bearing block partition* on a thickened slab / ground beam (it crosses the malqaf duct at x 10.25 on a ground beam, air study A3). The structural grid is unchanged: the y 6.5 line keeps *B6* as a *drop beam* (0.25 × 0.45 total assumed) from C26 to the east wall, inside the laundry / maid room ceiling behind the gypsum ceiling, carrying the first-floor bedroom 1 / suite wall; the FF slab bays stay on the grid. W5 is dropped from the RC-wall proposal (X13).]),
  ("X15", "owner decided (V6.4)", [*Courtyard enclosure, option A* (studies/courtyard_enclosure.typ): the west projection is *1.55 m* (edge x 5.8); B3, R11 and C21–C23 move 0.20 m east, spans and X8 unchanged. The gallery edge, the family living's edge and the living's upper courtyard side (y 13.0, +2.90 … +6.75) are closed with black steel windows W1 / W2 / W3; W1 sits on the B3 upstand (its sill), heads at the R1 / R2 / R11 soffit +6.75; a 0.25 m fascia keeps the head line under the roof slab over the void. W3 needs a steel transom at +3.82 tied to C22 and the kitchen wall; the window loads are small. The gym route wall (B20) stays on x 5.6: a 0.20 m nib at y 19.25 (to follow to x 5.8 in the L study if the owner wants one line).]),
  ("X16", "superseded (1 Nov 2026)", [*The main stair STOPS at the first floor* (owner, studies/south_wing.typ): flights 3–4, the roof stair room and the roof opening over the well are dropped, the roof slab over the well is an ordinary bay (no R16–R18); the roof is reached from the *external stair tower* at the south-east (x 13.436–16.036, y 18.22–24.0, top +9.60: two dog-leg flights to the office landing +3.60 and two to the roof +7.30, on its own footings beside the east strip footing, tied or jointed to the house: the engineer). The 3D model still shows the V7.0 roof stair until the next build (PENDING_CHANGES.md).]),
  ("X17", "owner decided (V6.4)", [*Roofline (studies/roof.typ):* flat roof, no tiles. A *main honey-stone cornice* 0.45 × 0.30 projection at +6.90 … +7.35 all round on the slab edge (≈ 2.5 kN/m, anchored); on the north block (y 0–19.25) a 0.30 upstand with coping to +7.65 and an *attic screen wall* (200 block, 1.8 m, coping +9.10) set back 1.0 m from the facade face, i.e. 0.875 m inside the outer-wall beams: a line load ≈ 4.5 kN/m on the slab near its supports (thicken the slab edge or a small hidden beam); its south wall on R5 / B8. The *south wing* (y 19.25–24) a plain parapet to +8.40 (≈ 2.8 kN/m). *Plant loads* (reserve): AC units ≈ 1.0 kN each + ERV 1.5 kN on pads over the maid wing / suite bath roof; tank(s) up to 30 kN on ≈ 3.3 m² in the R10–R3 bay (x 2.85–4.15, y 1.0–3.5); PV ≈ 0.25 kN/m² + wind uplift on the south wing (y ≥ 22.0) and the north block east roof; maintenance live load 1.0–1.5 kN/m². All assumed.]),
  ("X18", "owner decided (V7.1)", [*Courtyard arcade and arched enclosure windows* (studies/courtyard_enclosure.typ): two slender stone columns Ø0.25 on the colonnade line x 5.80 at y 8.667 and 10.833 (courtyard bay only) with three semicircular arch plates under the projection's soffit (+3.27; springing ≥ +2.31): *decorative, carrying nothing in this study*; the engineer may use them as intermediate supports of B3 (spans 2.17 m instead of 6.5 m) if that helps, in which case they get footings. The enclosure windows W1 / W2 / W3 get semicircular heads with their crowns at +6.60, 0.15 m below the R11 / R2 soffit: the wall between the windows and above the arches is 200 mm block on the B3 upstand (W1) or on B2 (W2); W3's head band 0.15 m under R2. No change to the beams or the columns.]),
  ("X19", "owner decided (air v3, 1 Nov 2026)", [*Air system v3 (studies/air_system.typ), notes and loads only, all assumed:* (1) the *breeze channel* in the ground slab, 0.9 wide × 0.20 clear within the slab depth (−0.08 … −0.28) on x 10.2 from the tower to y 10.5 then west to the kitchen's west wall, with its own 0.10 base slab and removable covers flush with the floor in the laundry and kitchen walkways; through the walls y 1.0 (the tower's south wall), y 2.8 and y 7.0 a 0.9 × 0.2 slot in the wall foot *above* the ground beams' top (−0.28): no beam or footing notched; the throat under the maid bath 0.5 wide; a sump 0.4 deep at the tower's foot, no pit. (2) The *tower*: an airtight partition (100 mm) along its length, the head divided by a thin + divider over 1.2 m, a roof hatch 0.6 × 0.8 in its south face; two Ø250 risers and a Ø315 duct through its south wall at the roof. (3) The *HRV base under the tower* (v3.1, owner): the tower rises from a base y 1.0–3.4 on the tower's west line and the cut facade line (≈ 5.5 m² gross), its walls (0.25 on the cut, 0.20 elsewhere) 1.8 m high to the top +9.10 ≈ 5 kN/m on the roof slab over the maid bath / bedroom 1 bay and on the cut wall line, a 0.15 slab, the unit ≈ 1.1 kN on a plinth (≈ 1.5 kN/m² local), roof penetrations for the risers inside the tower's compartment; doors on its west face, the exhaust louvre in its cut face. (4) The chamber, the pit and the walk-in tunnel of v1 / v2 are withdrawn: no excavation below the slab except the channel's base and the sump.]),
  ("X13", "open", [*Which walls are RC:* this study proposes W1–W4 (lift, shaft, laundry wall, cut wall) as RC 0.20 m for stiffness (W5, the kitchen north wall, dropped in V6.4), plus the two gym walls of X5. The engineer confirms the lateral system (frame + walls) under SBC 301 and the wind / seismic case for Taif.]),
  ("X14", "open", [*Slab types:* ribbed 0.30 (hollow block) for the 4.36–4.75 m bays and the men's majlis roof; solid 0.20 elsewhere and 0.22 flat over the double-height living. The engineer may unify (all ribbed, or all solid 0.20–0.25) for buildability; the clean soffit over the void is the only architectural wish.]),
  ("X15", "open", [*Stair* (drawn on the stair page): flight widths 1.21 m clear, 22 risers × 0.164, the L-shaped opening and the trimmers B16–B18 with their torsion, the store under the half landing (≈ 1.65 m headroom), handrails; the arrival strip y 6.35–7.80 at the first floor.]),
)
#table(columns: (auto, auto, 1fr), stroke: none, inset: 2.4pt, fill: (_, y) => if calc.even(y) { rgb("#efece4") },
  [*No.*], [*State*], [*Conflict / question*],
  ..X.map(((n, s, t)) => ([*#n*], [#s], [#t])).flatten())
#v(4pt)
#text(6.5pt, fill: gray)[Rules of thumb used (all assumed): beam depth = TOTAL depth incl. the slab, drop beams ≈ span / 12, hidden beams = slab depth, solid one-way slabs ≈ span / 24–28 (0.20 for ≤ 5 m), hollow-block ribbed slabs 0.30 (25 + 5) for 4–6 m, flat solid roof 0.22 for 4.7 m, columns 0.25 × 0.50–0.60 in the walls (two storeys, light loads), colonnade Ø0.30, pad footings 1.5 × 1.5 m. Loads: SBC 301 (residential 2 kN/m², gym: a home-gym live load as the engineer judges, roof 1 kN/m² + plant). Nothing here replaces the structural design.]
#v(2pt)
#text(7pt, weight: "bold", fill: green)[✓ Preliminary structural study · #columns.len() columns · #beams-ff.len() first-floor beams · #beams-roof.len() roof beams · #X.len() items for the engineer]

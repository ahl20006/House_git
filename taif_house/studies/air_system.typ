// air_system.typ · Taif / Palm House V6.3 · AIR SYSTEM STUDY v2 (air-p2): a dry malqaf for night ventilation, a small dry duct, a wall outlet in the courtyard;
// the house's MAIN ventilation is a calculated system (ERV, exhausts, AC) designed by the MEP engineer · compile THIS file
// v2.1 (3d-char2, owner decision): the outlet moved from the courtyard's north wall to the north end of its EAST wall (the kitchen's west wall), over the
// sunken seating of the character study; the duct runs south from the tower base under the maid bath and the laundry to a chamber under the kitchen floor.
// The women's majlis glass stays complete (A7 resolved).
// Design-development study, not an engineering design: EVERY size and performance statement is ASSUMED / NOT CALCULATED, to be designed by the MEP engineer
// (and the structural engineer for the duct, the tower base and the chamber). v1 (air-p1: an 8 m walk-in tunnel with a water channel) was withdrawn: water in a dark
// underground duct (condensation, mould, bacteria), little ground cooling from a short tunnel, a walk-in box too complex for a house, no filtration, no supply to closed rooms.
// The room outlines come from ../data/rooms_gf.csv; the tower polygon and the column lines from the design and the structural study. Written up in ../docs/AIR_SYSTEM.md.
// Coordinates: the CSV frame (metres, x east, y south, origin = the building's north-west wall corner). Levels: finished ground floor ±0.00, FF +3.60, roof slab +7.20, roof finish +7.30.
// The 3D model (3d/build_3d.py) reads the `air-*` values below: change them here, never in the 3D.
#import "@preview/cetz:0.4.2"
#set page(paper: "a4", flipped: true, margin: 10mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial"), size: 7.2pt)

// ---------- the system, as data (CSV frame; levels in metres from the finished ground floor; ALL ASSUMED) ----------
#let air-tower = ((8.95, 0), (10.051, 0), (10.594, 1.0), (8.95, 1.0))   // the tower shaft on wall centre lines (design_gf.typ tower-pts)
#let air-head = (7.3, 9.8)              // the head: from the roof finish to the top of the shaft walls, 2.5 m above the roof
#let air-head-opening = (8.2, 9.4)      // the louvred openings in the head (sill, head), on the north and west faces (towards the NW wind)
#let air-base = (-0.08, -1.95)          // the tower base pit: from the ground slab top to the pit floor (dry; a drain point; the duct's sealed access hatch)
#let air-route = ((10.25, 1.0), (10.25, 9.5))   // the duct axis from the tower's south wall: one leg south on x 10.25 under the maid bath, the laundry and the kitchen's north part to the outlet chamber under the kitchen floor (route E, owner 3d-char2; V7.1 courtyard layout: the chamber moved south under the outdoor TV)
#let air-L1 = air-route.at(1).at(1) - air-route.at(0).at(1)   // the one leg, south
#let air-L2 = 0.0                       // (no second leg)
#let air-duct = (0.9, -1.0, -1.9)       // the duct: outer size (square), top at the tower end, underside at the tower end (walls 0.15); it passes just under the assumed tie beams (−0.90)
#let air-clear = (0.6, 0.6)             // clear width × clear height inside the duct (ASSUMED; the MEP engineer sizes it)
#let air-fall = 0.015                   // the duct floor falls 1.5 % from the tower end to the drain point in the outlet chamber
#let air-invert = (-1.75, -1.85)        // the duct floor (clear) at the tower end and at the chamber end
#let air-chamber = (9.05, 9.5, 10.7, 10.5)   // the outlet chamber under the kitchen floor against the kitchen's west wall (x 8.95), outer (x0, y0, x1, y1); walls 0.15, clear 1.35 × 0.7; floor −2.10; the duct enters its north wall; V7.1: under the outdoor TV (studies/courtyard_layout.typ)
#let air-cover = (10.0, 9.7, 10.6, 10.3)    // the sealed, gas-tight floor cover in the kitchen floor east of the sink counter (clear opening), opened only for cleaning: NOT an air opening
#let air-grille-x = 8.95                    // the wall the grille is in: the courtyard's east wall = the kitchen's west wall; the grille on its courtyard face (x 8.85)
#let air-grille = (10.0, 0.05, 11.0, 0.40)  // the outlet grille (y0, z0, y1, z1): 1.0 m wide below the outdoor TV, centred on the seating (V7.1 courtyard layout), decorative, removable, louvres turned down; +0.05 … +0.40 = 0.20 … 0.55 above the seating floor (−0.15)
#let air-sunken = (-0.15, 5.925, 8.7, 8.85, 12.3)   // the seating one step down (V7.1, studies/courtyard_layout.typ): floor level, x0, y0, x1, y1; the grille on the east wall below the TV, no bench in front of it; the pit's drain and overflow in the layout study
#let air-length = air-L1 + air-L2       // axis length tower wall → chamber

// ---------- rooms (outlines only, from the CSV) ----------
#let parse-pts(s) = s.split(";").map(t => t.trim()).filter(t => t != "").map(t => { let v = t.split(" ").filter(u => u != ""); (float(v.at(0)), float(v.at(1))) })
#let read(path) = csv(path, row-type: dictionary).filter(r => r.name != "" and not r.name.starts-with("#")).map(r => {
  let P = if r.pts.trim() != "" { parse-pts(r.pts) } else {
    let x = float(r.x); let y = float(r.y); let w = float(r.w); let d = float(r.d)
    ((x - w / 2, y - d / 2), (x + w / 2, y - d / 2), (x + w / 2, y + d / 2), (x - w / 2, y + d / 2)) }
  (name: r.name, P: P) })
#let GF = read("../data/rooms_gf.csv")
#let outline = ((0, 0), (10.051, 0), (13.311, 6.0), (13.311, 24.0), (0, 24.0))
// the columns near the route (studies/structure.typ) with their ASSUMED 1.5 × 1.5 pad footings
#let pads = (("C15", 4.25, 0), ("C16", 4.25, 3.0), ("C17", 4.25, 6.5), ("C21", 5.8, 6.5), ("C24", 8.95, 0), ("C25", 8.95, 3.0), ("C26", 8.95, 6.5), ("C30", 10.051, 0), ("C31", 11.572, 2.8), ("C18", 4.25, 13.0), ("C27", 8.95, 13.0), ("C22", 5.8, 13.0))
#let pad = 1.5
#let plant = (9.6, 2.6, 13.0, 6.0)      // reserved plant area on the roof over the maid wing (ERV / AC outdoor units), ASSUMED, not designed

// ---------- helpers ----------
#let q(p) = (p.at(0), -p.at(1))
#let r2(v) = str(calc.round(v, digits: 2))
#let f2(v) = { let s = str(calc.round(calc.abs(v), digits: 2)); if v < 0 { "−" + s } else { "+" + s } }
#let ink = rgb("#3d4a45")
#let green = rgb("#2f6b4f")
#let red = rgb("#b5452f")
#let blue = rgb("#1f4e79")
#let orange = rgb("#c25b00")
#let H(t) = text(9pt, weight: "bold", fill: green, t)

// ================= PAGE 1 · the main system, the malqaf's role, the route, the plan =================
#text(14pt, weight: "bold", fill: green)[Air system study v2 · dry malqaf for night ventilation, small dry duct, wall outlet · Taif / Palm House V6.3]
#h(6pt) #text(7.5pt, fill: gray)[design-development study · every size and performance statement ASSUMED / NOT CALCULATED, to be designed by the MEP engineer · CSV coordinates, north up]
#v(1pt)
#block(fill: rgb("#fbe3dd"), inset: 4pt, radius: 2pt, width: 100%)[#text(7.5pt, weight: "bold", fill: red)[Nothing here is calculated: no airflow, cooling, filtration, structural or hydraulic figure. The study proves the performance of no option. ALL CHECKS PASSED means the drawings are consistent with the project files, not that the system was sized. v1 (air-p1, walk-in tunnel with a water channel) is withdrawn.]]
#v(3pt)
#grid(columns: (auto, 1fr), column-gutter: 12pt,
  cetz.canvas(length: 0.6cm, {
    import cetz.draw: *
    let poly(P, ..a) = line(..P.map(q), close: true, ..a)
    let T(p, t, size: 4.4pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, t))
    for r in GF.filter(r => r.P.map(p => p.at(1)).fold(1e9, calc.min) < 14.4) { poly(r.P.map(p => (p.at(0), calc.min(p.at(1), 14.5))), fill: rgb("#f3f1ea"), stroke: 0.3pt + luma(170)) }   // cropped at y 14.5
    line(q((0, 14.5)), q((0, 0)), q((10.051, 0)), q((13.311, 6.0)), q((13.311, 14.5)), stroke: 1.2pt + ink)
    line(q((0, 14.5)), q((13.311, 14.5)), stroke: (paint: ink, dash: "dashed", thickness: 0.6pt)); T((6.6, 14.9), [the south half of the plan is not shown], size: 3.6pt, fill: luma(120))
    for (id, x, y) in pads {
      rect(q((x - pad / 2, y - pad / 2)), q((x + pad / 2, y + pad / 2)), stroke: (paint: luma(120), dash: "dashed", thickness: 0.4pt))
      rect(q((x - 0.2, y - 0.2)), q((x + 0.2, y + 0.2)), fill: ink, stroke: none); T((x + 0.3, y - 0.35), id, size: 3.6pt, anchor: "west")
    }
    // the house drains of the east block go straight east to the manhole: the maid bath and laundry drains cross ABOVE the duct (top −1.00): A6
    for y in (1.9, 4.5, 9.8) { line(q((9.2, y)), q((14.2, y)), stroke: (paint: blue, dash: "dashed", thickness: 0.7pt), mark: (end: "stealth", fill: blue, scale: 0.4)) }
    circle(q((14.6, 5.0)), radius: 0.35, stroke: 0.7pt + blue); T((15.1, 5.0), [east manhole], size: 4pt, fill: blue, anchor: "west"); T((12.6, 4.1), [house drains → east\ (cross above the duct: A6)], size: 3.6pt, fill: blue)
    // the reserved roof plant area (dashed, above this plan)
    let (px0, py0, px1, py1) = plant
    rect(q((px0, py0)), q((px1, py1)), stroke: (paint: green, dash: "dashed", thickness: 0.8pt)); T((11.9, 5.2), [roof plant area reserved\ (ERV · AC units) · not designed], size: 3.3pt, fill: green)
    // the duct (route E: one leg south on x 10.25), the tower, the outlet chamber under the kitchen floor, the grille in the kitchen's west wall
    let (w, zt, zb) = air-duct
    let ax = air-route.at(0).at(0)
    rect(q((ax - w / 2, air-route.at(0).at(1) - 0.3)), q((ax + w / 2, air-route.at(1).at(1))), fill: rgb("#f6d7b8"), stroke: 1pt + orange)
    poly(air-tower, fill: rgb("#cfe0ee"), stroke: 1pt + blue)
    let (cx0, cy0, cx1, cy1) = air-chamber
    rect(q((cx0, cy0)), q((cx1, cy1)), fill: rgb("#f6d7b8"), stroke: 1pt + orange)
    let (vx0, vy0, vx1, vy1) = air-cover
    rect(q((vx0, vy0)), q((vx1, vy1)), fill: white, stroke: 0.5pt + ink); T((10.3, 7.9), [sealed\ cover], size: 3.0pt)
    let (gy0, gz0, gy1, gz1) = air-grille
    line(q((air-grille-x - 0.1, gy0)), q((air-grille-x - 0.1, gy1)), stroke: 2.4pt + orange); T((8.6, 7.25), [grille, courtyard side\ +#r2(gz0) … +#r2(gz1)], size: 3.1pt, fill: orange, anchor: "east")
    rect(q((air-grille-x - 0.1, gy0)), q((air-grille-x + 0.1, gy1)), fill: white, stroke: 0.4pt + orange)   // the plenum in the wall base
    line(q((ax, 0.75)), q((ax, 7.9)), q((9.3, 7.9)), q((9.3, 8.2)), q((8.4, 8.2)), stroke: (paint: orange, thickness: 1pt), mark: (end: "stealth", fill: orange, scale: 0.5))
    T((10.85, 0.9), [dry duct 0.6 × 0.6 clear · top −1.00], size: 3.3pt, fill: orange, anchor: "west")
    T((10.95, 6.3), [route E · #r2(air-length) m south], size: 3.4pt, fill: orange, angle: 90deg)
    T((9.77, 0.5), [tower], size: 3.8pt, fill: blue)
    T((9.9, 9.0), [outlet chamber under the kitchen floor\ 1.35 × 0.7 clear · pad frame + fan (optional)], size: 3.1pt, fill: orange)
    // the sunken seating of the character study (style study, provisional): the grille discharges over its bench
    let (sz, sx0, sy0, sx1, sy1) = air-sunken
    rect(q((sx0, sy0)), q((sx1, sy1)), stroke: (paint: luma(90), dash: "dashed", thickness: 0.6pt)); for i in range(1, 3) { line(q((sx0 + 0.3 * i, sy0)), q((sx0 + 0.3 * i, sy1)), stroke: 0.3pt + luma(140)) }
    rect(q((sx1 - 0.45, 7.7)), q((sx1, 9.1)), fill: luma(225), stroke: 0.3pt + luma(120)); T((8.2, 8.4), [bench], size: 3.0pt, fill: luma(90))
    T((7.75, 9.9), [sunken seating #f2(sz)\ 3 steps × 0.15\ (style study)], size: 3.1pt, fill: luma(90))
    line(q((8.85, 9.3)), q((8.85, 10.9)), stroke: 1.2pt + blue); T((8.65, 10.75), [fountain under\ the sink window], size: 2.9pt, fill: blue, anchor: "east")
    circle(q((8.3, 11.7)), radius: 0.12, stroke: 0.6pt + blue); T((8.1, 11.5), [drain + overflow], size: 2.9pt, fill: blue, anchor: "east")
    // the NW wind at the head
    line(q((8.3, -2.6)), q((9.7, -1.3)), stroke: 1.4pt + red, mark: (end: "stealth", fill: red, scale: 0.6)); T((7.9, -2.9), [NW wind → head openings N + W (night)], size: 4pt, fill: red, anchor: "west")
    T((6.2, 12.5), [courtyard], size: 4.2pt, fill: luma(110)); T((6.6, 3.3), [women's majlis], size: 4.2pt, fill: luma(110)); T((11.6, 11.0), [kitchen], size: 4.2pt, fill: luma(110)); T((9.6, 1.7), [maid bath], size: 3.6pt, fill: luma(110)); T((9.6, 3.8), [laundry], size: 3.6pt, fill: luma(110))
    // the west shaft: a riser reserved for the main system's ducts (not designed)
    rect(q((0, 9.2)), q((1.5, 10.4)), stroke: (paint: green, dash: "dashed", thickness: 0.8pt)); T((0.75, 9.8), [west shaft:\ ERV riser?], size: 3.2pt, fill: green)
    content(q((6.65, -3.6)), text(7pt, weight: "bold")[Plan at foundation level · tower, duct (route E), chamber, grille · pads dashed · reserves green])
    line(q((0, 15)), q((5, 15)), stroke: 1pt + ink); content(q((2.5, 15.45)), text(5pt)[5 m])
    rect(q((-0.5, -4.2)), q((15.5, 15.8)), stroke: none)
  }),
  [
    #set text(6.9pt)
    #H[1 · The main ventilation system (the base, independent of the malqaf)]
    - The house needs a *calculated main system, designed by the MEP engineer*: *filtered fresh air to the closed rooms*, above all the bedrooms, through an ERV / heat-recovery unit; *exhaust* from the bathrooms, the WCs and the kitchen (hood and extract through the east wall); *air-conditioning sized separately*, with the ducts and the AC in the gypsum ceilings (the owner's rule: drop beams, ducts and lighting hidden by gypsum ceilings).
    - *The malqaf is a natural supplement, not the main system.* An outlet into the open courtyard does not ventilate the closed rooms; only the ducted system does.
    - *Reserved, not designed* (open items M1–M3): a *plant area on the roof* over the maid wing (dashed green, ≈ #r2((plant.at(2) - plant.at(0)) * (plant.at(3) - plant.at(1))) m², screened, beside the tower, away from the suite court and the bedrooms' windows) for the ERV and the AC outdoor units; *duct routes in the gypsum ceilings* of both floors; a *riser* (the west shaft, 1.5 × 1.2, dashed green, or a second one beside the east kitchen stack) between the floors and the roof plant.
    #v(2pt)
    #H[2 · The malqaf, simplified: dry, for night ventilation]
    - *Why v1 was withdrawn:* water inside a dark underground duct adds condensation, mould and bacteria risks; a short, shallow tunnel gives little ground cooling; a walk-in tunnel (deep excavation, waterproofing, pumps, footings) is too complex for a house; passing air over water does not clean it, and a screen is not a rated filter.
    - *Now:* the tower stays *dry*; a washable insect / dust screen *plus a slot for a proper rated filter* (MEP: class and pressure drop); a *closable damper* (closed in dust storms, cold weather and the hot daytime hours; motorised with a manual override); a roof access hatch. *Main use: night ventilation* — Taif's cool nights: open at night to cool the thermal mass of the courtyard walls and floors, closed by day. *No water anywhere inside the tower or the duct.*
    - *Duct:* a short, small, *dry* duct from the tower base *south under the maid bath and the laundry* (route E, #r2(air-length) m on x #r2(air-route.at(0).at(0))) to a chamber under the kitchen floor, assumed *#r2(air-clear.at(0)) × #r2(air-clear.at(1)) m clear* (to be sized), smooth, sloped #str(calc.round(air-fall * 100, digits: 1)) % to a drain point, *sealed against soil gas and ground water*; just under the assumed tie beams (top #f2(air-duct.at(1))), 0.10 m from the assumed pads; the maid bath and laundry drains cross *above* it (A6); *not walk-in*: cleaned from both ends through *sealed hatches* at the tower base and at the chamber.
    - *Outlet in the wall, not in the floor (owner, 3d-char2):* a low grille at the *north end of the courtyard's east wall* (the kitchen's west wall, courtyard side; V6.4: the wall's first 0.5 m, y 6.5–7.0, belongs to the laundry, the grille at y #r2(air-grille.at(0))–#r2(air-grille.at(2)) stays in the kitchen part over the chamber; +#r2(air-grille.at(1)) … +#r2(air-grille.at(3))), mashrabiya-type, *discharging into the courtyard just above the bench of the sunken seating* (floor #f2(air-sunken.at(0)), style study): the cool air settles there; the plenum stays below counter level on the kitchen side; the women's majlis glass stays complete (A7 resolved). *No air opening in the courtyard floor*; the cleaning access is a *sealed cover in the kitchen floor*.
    #v(2pt)
  ],
)

// ================= PAGE 2 · long section =================
#pagebreak()
#text(12pt, weight: "bold", fill: green)[Long section along the air path · tower head → shaft → base pit → dry duct (south, x #r2(air-route.at(0).at(0))) → outlet chamber under the kitchen floor → (west) plenum → grille → sunken seating]
#h(6pt) #text(7pt, fill: gray)[along the duct axis, north → south; at the chamber the path turns west into the kitchen's west wall (the section looking north on the next page) · levels from the finished ground floor ±0.00 · all assumed / not calculated]
#v(2pt)
#let L1 = air-L1
#let L2 = air-L2
#let s-exit = 1.0                         // the tower's south wall (the shaft runs s 0 … 1.0, north → south; s = the plans' y)
#let s-chamber = s-exit + L1 + L2         // the chamber's north wall
#let ch-len = air-chamber.at(3) - air-chamber.at(1)
#grid(columns: (auto, 1fr), column-gutter: 12pt,
  cetz.canvas(length: 0.9cm, {
    import cetz.draw: *
    let T(p, t, size: 4.4pt, fill: ink, anchor: "center", angle: 0deg) = content(p, anchor: anchor, angle: angle, text(size, fill: fill, t))
    let R(x0, z0, x1, z1, ..a) = rect((x0, z0), (x1, z1), ..a)
    let (w, zt, zb) = air-duct
    let (cw, ch) = air-clear
    line((-2.2, 0), (s-chamber + ch-len + 2.5, 0), stroke: 0.8pt + ink)
    for (z, l) in ((0, [±0.00]), (3.6, [+3.60]), (7.2, [+7.20]), (air-head.at(1), [+#r2(air-head.at(1))]), (zt, [#f2(zt)]), (zb, [#f2(zb)]), (air-base.at(1), [#f2(air-base.at(1))])) {
      line((-2.1, z), (-1.5, z), stroke: 0.4pt + gray); T((-2.2, z), l, size: 4pt, fill: gray, anchor: "east")
    }
    R(-0.2, -0.28, s-chamber + ch-len + 2.3, -0.08, fill: luma(150), stroke: none)         // ground slab (the house starts at the tower's north wall)
    R(1.2, 3.32, s-chamber + ch-len + 2.3, 3.52, fill: luma(150), stroke: none); R(1.2, 7.0, s-chamber + ch-len + 2.3, 7.2, fill: luma(150), stroke: none); R(1.2, 7.2, s-chamber + ch-len + 2.3, 7.3, fill: luma(200), stroke: none)
    T((-1.2, 1.6), [north street], size: 4pt, fill: luma(120)); T((1.9, 1.6), [maid bath], size: 3.8pt); T((4.6, 1.6), [laundry], size: 4pt); T((8.4, 1.6), [kitchen], size: 4pt); T((3.8, 5.2), [bedroom 1], size: 4pt); T((8.4, 5.2), [suite lobby], size: 4pt); T((5.0, 7.6), [roof], size: 4pt)
    // assumed ground beams under the walls y 2.8 (maid bath / laundry) and y 6.5 (laundry / kitchen): the duct passes under them (A3)
    for (s, l) in ((2.8, [wall y 2.8 · ground beam (A3)]), (7.0, [wall y 7.0 · ground beam (A3)])) { R(s - 0.15, -0.9, s + 0.15, -0.28, fill: luma(120), stroke: none); T((s, 0.25), l, size: 3.0pt) }
    // the maid bath and laundry drains run east to the manhole, crossing ABOVE the duct (A6)
    for s in (1.9, 4.5) { circle((s, -0.55), radius: 0.08, stroke: 0.6pt + blue, fill: white) }
    T((3.2, 0.7), [house drains (to the east) cross above the duct: A6], size: 3.1pt, fill: blue)
    // the tower: shaft walls from the base pit to the head
    R(-0.2, air-base.at(1), 0.0, air-head.at(1), fill: luma(90), stroke: none)
    R(1.0, air-base.at(1), 1.2, air-head.at(1), fill: luma(90), stroke: none)
    R(-0.2, air-base.at(1) - 0.2, 1.2, air-base.at(1), fill: luma(90), stroke: none)
    R(0.0, air-head.at(1), 1.2, air-head.at(1) + 0.15, fill: luma(90), stroke: none); R(-0.45, air-head.at(1) + 0.15, 1.45, air-head.at(1) + 0.3, fill: luma(120), stroke: none)
    T((0.5, air-head.at(1) + 0.65), [cap roof · drip], size: 3.8pt)
    R(1.0, air-head-opening.at(0), 1.2, air-head-opening.at(1), fill: rgb("#cfe0ee"), stroke: 0.4pt + blue)
    for i in range(6) { line((1.0, air-head-opening.at(0) + 0.1 + i * 0.2), (1.2, air-head-opening.at(0) + 0.2 + i * 0.2), stroke: 0.4pt + blue) }
    line((0.85, air-head-opening.at(0)), (0.85, air-head-opening.at(1)), stroke: (paint: blue, dash: "dotted", thickness: 0.8pt)); T((0.72, air-head-opening.at(1) + 0.25), [washable screen], size: 3.6pt, fill: blue, anchor: "east")
    R(0.55, air-head-opening.at(0), 0.65, air-head-opening.at(1), stroke: 0.6pt + green); T((0.45, air-head-opening.at(0) - 0.25), [slot for a rated filter (MEP)], size: 3.4pt, fill: green, anchor: "east")
    line((0.1, 7.9), (0.9, 7.9), stroke: 1.6pt + red); T((-0.05, 7.9), [damper: closed by day, in dust and cold], size: 3.6pt, fill: red, anchor: "east")
    line((1.9, 8.8), (1.3, 8.8), stroke: 1.2pt + red, mark: (end: "stealth", fill: red, scale: 0.6)); T((2.0, 8.8), [NW wind · night], size: 4pt, fill: red, anchor: "west")
    T((0.5, 9.0), [louvres N + W], size: 3.6pt, fill: blue)
    R(0.15, 7.3, 0.75, 8.5, stroke: (paint: ink, dash: "dashed", thickness: 0.5pt)); T((0.45, 7.95), [hatch\ (S face)], size: 3.3pt)
    for i in range(int((air-head.at(0) - air-base.at(1) + 1.0) / 0.3)) { line((0.75, air-base.at(1) + 0.3 + i * 0.3), (0.95, air-base.at(1) + 0.3 + i * 0.3), stroke: 0.6pt + ink) }
    T((1.35, 3.0), [rungs to the base pit], size: 3.6pt, anchor: "west", angle: 90deg)
    line((0.0, -0.08), (1.0, -0.08), stroke: (paint: ink, dash: "dashed", thickness: 0.8pt)); T((1.3, -0.5), [grating in the shaft floor · the base pit is dry, with a drain point], size: 3.4pt, anchor: "west")
    line((0.5, 7.7), (0.5, air-base.at(1) + 0.9), stroke: 1pt + orange, mark: (end: "stealth", fill: orange, scale: 0.6))
    // the duct: a square box with the fall
    let x0 = s-exit; let x1 = s-chamber
    let fall(x) = (x - x0) / (x1 - x0) * (air-invert.at(0) - air-invert.at(1))
    let top(x) = zt - fall(x); let bot(x) = zb - fall(x)
    line((x0, top(x0)), (x1, top(x1)), (x1, bot(x1)), (x0, bot(x0)), close: true, fill: luma(90), stroke: none)
    line((x0, top(x0) - 0.15), (x1, top(x1) - 0.15), (x1, bot(x1) + 0.15), (x0, bot(x0) + 0.15), close: true, fill: white, stroke: none)
    R(x0 - 0.02, air-invert.at(0) - 0.05, x0 + 0.1, air-invert.at(0) + cw + 0.05, fill: white, stroke: 0.8pt + red); T((x0 + 0.15, bot(x0) - 0.5), [sealed access hatch 1], size: 3.3pt, fill: red, anchor: "west")
    R(x1 - 0.1, air-invert.at(1) - 0.05, x1 + 0.02, air-invert.at(1) + cw + 0.05, fill: white, stroke: 0.8pt + red); T((x1 - 0.15, bot(x1) - 0.5), [sealed access hatch 2], size: 3.3pt, fill: red, anchor: "east")
    T((x0 + (x1 - x0) / 2, bot(x1) - 0.25), [dry duct · clear #r2(cw) × #r2(ch) (assumed) · smooth · sealed · falls #str(calc.round(air-fall * 100, digits: 1)) % → drain point], size: 4pt, fill: orange)
    line((x0 + 0.5, (top(x0) + bot(x0)) / 2), (x1 - 0.5, (top(x1) + bot(x1)) / 2), stroke: 1pt + orange, mark: (end: "stealth", fill: orange, scale: 0.6))
    T((x0 + (x1 - x0) / 2, bot(x1) - 0.8), [not walk-in · cleaned from both ends (brush · camera · robot) · no water inside], size: 3.4pt, fill: luma(110))
    // the outlet chamber under the kitchen floor (the path turns west here: plenum and grille on the next page)
    let c0 = x1; let c1 = x1 + ch-len
    let zc = -2.1
    R(c0 - 0.15, zc - 0.15, c1, zc, fill: luma(90), stroke: none)                       // floor
    R(c0 - 0.15, zc, c0, air-invert.at(1) - 0.0, fill: luma(90), stroke: none)         // north wall below the duct mouth
    R(c1 - 0.15, zc, c1, -0.28, fill: luma(90), stroke: none)                           // south wall
    R(c0, -0.28, c1, -0.08, fill: luma(150), stroke: none)                              // chamber top = kitchen slab
    let (vx0, vy0, vx1, vy1) = air-cover
    R(c0 + (vy0 - air-chamber.at(1)), -0.3, c0 + (vy1 - air-chamber.at(1)), -0.06, fill: white, stroke: 0.8pt + red); T((c0 + 0.5, 0.3), [sealed cover in the kitchen floor (cleaning only)], size: 3.3pt, fill: red)
    R(c0 + 0.15, zc, c0 + 0.5, zc + 0.08, fill: white, stroke: 0.5pt + blue); T((c0 + 0.35, zc - 0.3), [drain point\ (non-return)], size: 3.1pt, fill: blue)
    R(c0 + 0.2, zc + 0.3, c0 + 0.8, zc + 0.9, stroke: (paint: green, dash: "dashed", thickness: 0.6pt)); T((c0 + 0.5, zc + 1.1), [removable pad frame\ + quiet fan (optional)\ water · drain · power], size: 3.1pt, fill: green)
    circle((c0 + 0.5, zc + 1.55), radius: 0.12, stroke: 0.8pt + orange); circle((c0 + 0.5, zc + 1.55), radius: 0.03, fill: orange, stroke: none)
    T((c0 + 0.7, zc + 1.55), [→ west, out of the page: opening in the west wall → plenum → grille (next page)], size: 3.1pt, fill: orange, anchor: "west")
    T((c0 + 0.5, 3.7), [kitchen's west wall (x #r2(air-grille-x)) over the chamber: ground beam C26 – C27 (A3)], size: 3.1pt)
    line((c0 + 0.5, zc + 0.5), (c0 + 0.5, zc + 1.35), stroke: 1pt + orange, mark: (end: "stealth", fill: orange, scale: 0.6))
    T((c0 + 0.5, zc + 1.95), [chamber 1.35 × 0.7 clear], size: 3.4pt, fill: orange)
    T((s-chamber / 2 + 0.4, -2.9), [S], size: 4pt); T((-1.9, -2.9), [N], size: 4pt)
  }),
  [
    #set text(6.9pt)
    #H[How it works (qualitative only; nothing calculated)]
    - *Night ventilation:* in the evening the damper opens; the head catches the north-west breeze above the roof (or the cool, heavy night air simply sinks down the shaft); the air passes the screen and the filter, falls down the shaft, runs through the short dry duct and leaves slowly through the low grille in the kitchen's west wall, just above the bench of the sunken seating, and settles into the sunken area, cooling the courtyard's walls and floor. In the morning the damper closes and the cooled mass keeps the courtyard pleasant longer. *How much:* not calculated; the MEP engineer estimates the flow (wind-driven and stack) and decides whether a small fan is needed (option B).
    - *Hot daytime hours:* the damper is closed. If the owner wants cooled supply by day, the *optional pad frame and quiet fan* in the outlet chamber are installed for the season (option B): the fan draws through the pads; the pads are *drained and dried daily*; the tower and the duct stay dry.
    - *The closed rooms* (bedrooms, baths, kitchen) are ventilated and cooled by the *main system* (ERV, exhausts, AC), not by the malqaf.
    #v(2pt)
    #H[Health and dryness rules (stated, not optional)]
    - *No water inside the tower or the duct:* no channel, no sprays, no mist, no fogging. The only water is in the optional pad frame in the outlet chamber, drained and dried daily; make-up water through a float valve and a backflow preventer.
    - *Filtered:* a rated filter in the head's slot (class and pressure drop by the MEP engineer); the screen only keeps insects and coarse dust out.
    - *Sealed and drained:* the duct is sealed against soil gas and ground water, falls to a drain point with a non-return trap; the base pit and the chamber have drain points; condensation, if any, runs to them.
    - *Separate from the house and closable:* a separate element; no house drain crosses it; the damper closes it; the floor cover is gas-tight and opened only for cleaning.
    #v(2pt)
    #H[Levels along the path (assumed)]
    #table(columns: (1.1fr, 1fr), stroke: none, inset: 2pt, fill: (_, y) => if calc.even(y) { rgb("#efece4") },
      [head top / head openings], [+#r2(air-head.at(1)) / +#r2(air-head-opening.at(0)) … +#r2(air-head-opening.at(1))],
      [roof finish / roof slab], [+7.30 / +7.20],
      [ground floor finished / grating in the shaft], [±0.00 / −0.08],
      [tower base pit floor], [#f2(air-base.at(1))],
      [duct top / underside at the tower], [#f2(air-duct.at(1)) / #f2(air-duct.at(2))],
      [duct floor (clear) at the tower / at the chamber], [#f2(air-invert.at(0)) / #f2(air-invert.at(1))],
      [outlet chamber floor], [−2.10],
      [grille in the kitchen's west wall, courtyard side], [+#r2(air-grille.at(1)) … +#r2(air-grille.at(3))],
      [sunken seating floor / bench seat (style study)], [#f2(air-sunken.at(0)) / −0.05 (the grille 0.60 / 0.20 above them)],
      [assumed tie beams / pad footing underside], [−0.28 … −0.90 (the duct passes 0.10 m under them) / −1.50 (only the tower pit and the chamber reach it: A1, A3)],
    )
  ],
)

// ================= PAGE 3 · cross section, the outlet chamber and grille, the three options =================
#pagebreak()
#text(12pt, weight: "bold", fill: green)[Duct cross section · outlet chamber and grille · the three options for the MEP engineer]
#h(6pt) #text(7pt, fill: gray)[all sizes assumed · the duct, the tower base pit and the chamber by the structural engineer; filter, fan, pads, water, drain and power points by the MEP engineer]
#v(2pt)
#grid(columns: (auto, auto, 1fr), column-gutter: 14pt,
  cetz.canvas(length: 1.6cm, {
    import cetz.draw: *
    let T(p, t, size: 4.4pt, fill: ink, anchor: "center", angle: 0deg) = content(p, anchor: anchor, angle: angle, text(size, fill: fill, t))
    let (w, zt, zb) = air-duct; let (cw, ch) = air-clear
    rect((-w / 2, zb), (w / 2, zt), fill: luma(90), stroke: none)
    rect((-cw / 2, zb + 0.15), (cw / 2, zb + 0.15 + ch), fill: white, stroke: none)
    for s in (-1, 1) { arc((s * cw / 2, zb + 0.15 + 0.06), start: if s < 0 { 0deg } else { 180deg }, stop: if s < 0 { -90deg } else { 270deg }, radius: 0.06, fill: luma(90), stroke: none) }
    rect((-w / 2 - 0.03, zb - 0.03), (w / 2 + 0.03, zt + 0.03), stroke: (paint: red, thickness: 0.8pt))
    T((0, zt + 0.22), [sealed outside: membrane or a factory-sealed box (precast RC / GRP, MEP + engineer)], size: 3.4pt, fill: red)
    T((0, zb + 0.15 + ch / 2 + 0.1), [clear #r2(cw) × #r2(ch)\ (assumed; to be sized)], size: 4.2pt, fill: orange)
    T((0, zb + 0.3), [smooth · coved · dry · falls 1.5 %], size: 3.3pt, fill: luma(110))
    line((-w / 2, zb - 0.3), (w / 2, zb - 0.3), stroke: 0.4pt + ink, mark: (start: "|", end: "|", scale: 0.4)); T((0, zb - 0.45), [#r2(w) outer · walls 0.15], size: 3.6pt)
    for (z, l) in ((zt, [#f2(zt)]), (zb, [#f2(zb)])) { T((-w / 2 - 0.1, z), l, size: 3.4pt, fill: gray, anchor: "east") }
    rect((-1.2, -0.9), (1.2, -0.28), fill: luma(150), stroke: none); T((0, -0.6), [tie beam (assumed) · 0.10 m above the duct], size: 3.2pt, fill: white)
    rect((-1.4, -0.28), (1.4, -0.08), fill: luma(150), stroke: none); T((0, 0.15), [ground slab · women's majlis floor], size: 3.4pt)
    content((0, 0.55), text(6pt, weight: "bold", fill: green)[Duct cross section (at a tie-beam crossing)])
  }),
  cetz.canvas(length: 0.85cm, {
    import cetz.draw: *
    let T(p, t, size: 4.4pt, fill: ink, anchor: "center", angle: 0deg) = content(p, anchor: anchor, angle: angle, text(size, fill: fill, t))
    let R(x0, z0, x1, z1, ..a) = rect((x0, z0), (x1, z1), ..a)
    // section through the sunken seating, the grille, the plenum and the outlet chamber, looking north: horizontal = x (west left), vertical = level
    let (sz, sx0, sy0, sx1, sy1) = air-sunken
    let (cx0, cy0, cx1, cy1) = air-chamber
    let (gy0, gz0, gy1, gz1) = air-grille
    let wx = air-grille-x
    let zc = -2.1
    let X(x) = x - 5.4
    line((X(5.4), 0), (X(sx0), 0), stroke: 0.8pt + ink)
    // the courtyard slab with the sunken pit: three steps from the west, the floor at −0.45, the bench against the east wall
    R(X(5.4), -0.28, X(sx0), -0.08, fill: luma(150), stroke: none)
    R(X(sx0), sz - 0.2, X(sx0 + 0.3), -0.15, fill: luma(150), stroke: none); R(X(sx0 + 0.3), sz - 0.2, X(sx0 + 0.6), -0.30, fill: luma(150), stroke: none); R(X(sx0 + 0.6), sz - 0.2, X(sx1), sz, fill: luma(150), stroke: none)
    R(X(sx1 - 0.45), sz, X(sx1), -0.05, fill: luma(225), stroke: 0.3pt + luma(120)); T((X(sx1 - 0.22), -0.25), [bench], size: 3.2pt)
    R(X(sx1 - 0.75), sz, X(sx1 - 0.6), sz + 0.03, fill: white, stroke: 0.5pt + blue); T((X(sx1 - 0.68), sz - 0.35), [drain +\ overflow (A6)], size: 3.0pt, fill: blue)
    T((X(sx0 + 0.9), sz + 0.25), [sunken seating #f2(sz) · 3 steps × 0.15\ (style study, provisional)], size: 3.3pt, anchor: "west")
    T((X(6.0), 0.3), [courtyard level], size: 3.4pt, fill: luma(110))
    // the kitchen's west wall with the plenum in its base and the grille on the courtyard face (with an upstand lip)
    R(X(wx - 0.1), -0.28, X(wx + 0.1), 3.32, fill: luma(200), stroke: 0.3pt + luma(120))
    R(X(wx - 0.1), 1.1, X(wx + 0.1), 2.1, fill: rgb("#cfe0ee"), stroke: 0.4pt + blue); T((X(wx), 2.35), [sink\ window], size: 3.0pt, fill: blue)
    R(X(wx - 0.08), -1.0, X(wx + 0.08), gz1, fill: white, stroke: 0.4pt + orange)
    R(X(wx + 0.08), -1.0, X(cx0 + 0.15), -0.28, fill: white, stroke: 0.4pt + orange)     // the opening from the chamber into the plenum
    line((X(wx - 0.1), gz0), (X(wx - 0.1), gz1), stroke: 2.4pt + orange); R(X(wx - 0.16), gz0 - 0.05, X(wx - 0.1), gz0 + 0.02, fill: luma(120), stroke: none)
    T((X(wx - 0.2), gz1 + 0.3), [grille +#r2(gz0) … +#r2(gz1) · courtyard side\ 0.20 above the seat · upstand lip], size: 3.2pt, fill: orange, anchor: "east")
    T((X(wx + 0.2), gz1 + 1.0), [plenum in the\ wall base 0.2 × 1.0\ below counter level], size: 3.0pt, fill: orange, anchor: "west")
    // the kitchen floor, the sink counter, the chamber below with its cover, drain point and pad frame; the duct mouth behind the section plane
    R(X(wx + 0.1), -0.28, X(cx1 + 0.8), -0.08, fill: luma(150), stroke: none)
    R(X(wx + 0.2), -0.08, X(wx + 0.8), 0.82, stroke: (paint: luma(110), dash: "dashed", thickness: 0.5pt)); T((X(wx + 0.5), 0.95), [sink counter], size: 3.0pt, fill: luma(110))
    R(X(cx0), zc - 0.15, X(cx1), zc, fill: luma(90), stroke: none); R(X(cx0), zc, X(cx0 + 0.15), -1.0, fill: luma(90), stroke: none); R(X(cx1 - 0.15), zc, X(cx1), -0.28, fill: luma(90), stroke: none)
    R(X(9.8), air-invert.at(1), X(10.7), air-invert.at(1) + air-clear.at(1), stroke: (paint: orange, dash: "dashed", thickness: 0.6pt)); T((X(10.25), air-invert.at(1) + 0.3), [duct mouth\ (north wall, behind)], size: 3.0pt, fill: orange)
    let (vx0, vy0, vx1, vy1) = air-cover
    R(X(vx0), -0.3, X(vx1), -0.06, fill: white, stroke: 0.8pt + red); T((X((vx0 + vx1) / 2), 0.3), [sealed, gas-tight cover 0.6 × 0.6\ in the kitchen floor (cleaning only)], size: 3.1pt, fill: red)
    R(X(cx0 + 0.3), zc, X(cx0 + 0.6), zc + 0.08, fill: white, stroke: 0.5pt + blue); T((X(cx0 + 0.45), zc - 0.3), [drain point], size: 3.1pt, fill: blue)
    R(X(cx0 + 0.8), zc + 0.3, X(cx0 + 1.4), zc + 0.9, stroke: (paint: green, dash: "dashed", thickness: 0.6pt)); T((X(cx0 + 1.1), zc + 1.15), [pad frame + fan\ (optional, seasonal)], size: 3.1pt, fill: green)
    line((X(cx0 + 0.5), zc + 0.7), (X(wx), -0.6), (X(wx), gz0 + 0.3), (X(wx - 0.5), gz0 + 0.3), (X(wx - 1.3), sz + 0.5), stroke: 1pt + orange, mark: (end: "stealth", fill: orange, scale: 0.6))
    T((X(6.3), 1.4), [courtyard], size: 4pt, fill: luma(110)); T((X(10.0), 1.4), [kitchen], size: 4pt, fill: luma(110))
    T((X(5.4), -0.5), [W], size: 4pt); T((X(cx1 + 0.8), -0.5), [E], size: 4pt)
    content((X(8.4), 3.7), text(6pt, weight: "bold", fill: green)[Outlet · section, looking north])
  }),
  [
    #set text(6.9pt)
    #H[Outlet chamber and grille (assumed)]
    - *Chamber (owner, 3d-char2):* under the kitchen floor against the kitchen's west wall (x #r2(air-grille-x)), outer x #r2(air-chamber.at(0))–#r2(air-chamber.at(2)), y #r2(air-chamber.at(1))–#r2(air-chamber.at(3)); clear 1.35 × 0.7, floor −2.10, walls 0.15, sealed like the duct; 0.15 m from the assumed C26 pad, under the sink counter. The duct enters through its north wall; a *sealed access hatch* there for cleaning the duct from this end.
    - *Air path:* chamber → an opening in its west wall → a *plenum in the wall base* (0.2 × 1.0, y #r2(air-grille.at(0))–#r2(air-grille.at(2)), from the slab to the grille head, below counter level on the kitchen side) → the *grille* on the courtyard face, +#r2(air-grille.at(1)) … +#r2(air-grille.at(3)), 1.0 m wide, decorative (mashrabiya-type), with an upstand lip, an insect screen and a closable shutter behind it; *the air discharges into the courtyard, never into the kitchen*.
    - *Sunken seating (style study, 3d/character.yaml):* the grille discharges just above the built-in bench (seat −0.05) of a sunken area #f2(air-sunken.at(0)) deep (3 steps × 0.15 from the west) against the east wall, x #r2(air-sunken.at(1))–#r2(air-sunken.at(3)), y #r2(air-sunken.at(2))–#r2(air-sunken.at(4)); level edges ≥ 1.0 m at every door and glass wall; a *floor drain at its lowest point plus an overflow* (A6); a wall fountain under the sink window, decorative (A8 / A6).
    - *Optional, installed only for the hot season:* a removable evaporative pad frame (≈ 0.6 × 0.6) and a small quiet fan in the chamber, with water, drain and power points. Rules: no sprays or mist; pads drained and dried daily; the duct and the tower stay dry.
    - *Access:* a sealed, gas-tight cover 0.6 × 0.6 in the kitchen floor east of the sink counter (x #r2(air-cover.at(0))–#r2(air-cover.at(2))), opened only for cleaning and for the seasonal pad frame; *not an air opening*. The chamber is 2 m deep: a short ladder stored nearby, two people, lid open (A5).
    - *The glass:* the women's majlis glass (x 5.1–8.1) on the north wall stays complete: A7 is resolved by moving the outlet to the east wall.
    #v(2pt)
    #H[The three options the MEP engineer compares before anything goes into the foundations]
    #table(columns: (auto, 1fr, 1fr, 1fr), stroke: none, inset: 2.2pt, fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#efece4") },
      ..([], [*A · direct dry malqaf*], [*B · malqaf + fan + filter*], [*C · dry earth-air heat exchanger*]).map(c => text(7pt, weight: "bold", fill: green, c)),
      [what], [tower, screen + filter, damper, the short dry duct, the wall grille; wind and stack only], [as A, plus a small quiet fan (in the chamber or the shaft) and a rated filter; the pad frame optional at the outlet], [a longer, deeper dry pipe run (proper depth and length, several parallel pipes), condensate drainage, a fan; the courtyard grille or ducted supply],
      [gives], [night ventilation of the courtyard when the breeze blows; nothing by day], [controlled night ventilation whatever the wind; filtered; optional evaporative supply by day], [cooled (and in winter tempered) supply by day and night; the only option with real ground cooling],
      [costs / risks], [lowest; depends on the wind; the courtyard only], [fan power, filter changes; the pads need the daily drain-and-dry routine], [excavation outside the house, length, condensate and hygiene management, fan power; must be designed, not assumed],
      [to compare], [annual performance (hours of useful supply, temperatures), capital and running cost, maintenance], [idem], [idem],
    )
    #text(6.5pt, fill: gray)[The study proves the performance of none of them. The plan and the sections show option A (the drawings also fit B); C would change the route and the depth and is not drawn.]
    #v(2pt)
    #H[Route: the owner's choice (3d-char2) against the two candidates of v1 / v2]
    #table(columns: (auto, 1fr, 1fr, 1fr), stroke: none, inset: 2pt, fill: (_, y) => if calc.even(y) { rgb("#efece4") },
      [], [*E · to the kitchen's west wall (chosen, owner)*], [A · under the women's majlis (v2, superseded)], [B · under the maid wing to the kitchen north wall (v1, rejected)],
      [path], [tower base → #r2(air-L1) m south on x #r2(air-route.at(0).at(0)) → chamber under the kitchen floor → west into the kitchen's west wall → grille over the sunken seating], [tower base → 1.68 m west → 5.85 m south on x 7.27 → chamber at the courtyard's north wall], [south under the maid bath and the laundry, west under the kitchen north wall; ≈ 8.5 m],
      [above], [maid bath, laundry, kitchen], [the women's majlis only], [maid bath, laundry, kitchen wall],
      [footings], [the tower base pit (A1); ground beams under the walls y 2.8, y 7.0 (V6.4) and the kitchen's west wall (A3); 0.10 m from the C25 / C26 / C31 pads], [the majlis south wall ground beam; 0.48 m from C25, 0.4 / 0.25 m from C21 / C26], [walls y 1.0 and 2.8, the RC wall W5, the C26 pad],
      [drains], [the maid bath and laundry drains cross *above* the duct: clearance and protection (A6)], [none cross it], [crosses the maid bath and laundry drains],
      [why], [the cool air settles where people sit; the women's majlis glass stays complete (A7 resolved)], [the grille cut the women's majlis glass (A7)], [—],
    )

  ],
)

// ================= PAGE 4 · maintenance, reserves, open items =================
#pagebreak()
#text(12pt, weight: "bold", fill: green)[Maintenance, reserved spaces for the main system, open items]
#v(2pt)
#grid(columns: (1.15fr, 1fr), column-gutter: 14pt,
  [
    #H[Maintenance table (what · how often · how to reach it)]
    #table(columns: (1fr, 1.8fr, 1fr, 1.1fr), stroke: none, inset: 2.4pt, fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#efece4") },
      ..([Item], [What to do], [How often], [How to reach it]).map(c => text(7pt, weight: "bold", fill: green, c)),
      [head louvres + insect / dust screen], [brush and wash the screen; clear the louvres; check the drip], [monthly in the dust season, else every 3 months], [from the roof, through the hatch in the head's south face],
      [rated filter (head slot)], [check the pressure drop / the indicator; replace or wash as its class allows], [per the MEP engineer; before and after the dust season], [from the roof hatch],
      [damper (head)], [check the motor, the manual override and the control; grease, test closing], [every 6 months and before the dust season], [from the roof hatch],
      [shaft walls, rungs, grating], [brush, check the rungs, the lighting and the grating lock], [yearly], [rungs from the head hatch],
      [tower base pit + drain point], [sweep, check the drain and its trap, look for damp], [every 6 months], [down the shaft (two people, lid open)],
      [dry duct], [brush / camera inspection / cleaning robot from both ends; check that it is dry and sealed], [yearly; after any smell or damp], [sealed hatch 1 (base pit), sealed hatch 2 (chamber)],
      [outlet chamber + drain point], [sweep, check the drain and the trap, the water and power points], [every 6 months], [sealed cover in the kitchen floor (cleaning only)],
      [grille, screen and shutter], [wash the screen, clear the grille and its upstand, test the shutter], [monthly in use], [from the sunken seating, standing on the bench],
      [sunken seating drain + overflow], [clear the grate and the overflow; check after rain], [monthly; after every rain], [in the courtyard],
      [pad frame + fan (optional, seasonal)], [install for the season; pads drained and dried daily; clean the pads, the tray and the fan], [daily drain (automatic); pads monthly; in / out of the season], [through the floor cover],
      [sealing, joints], [look for damp, cracks, salts, smells (soil gas)], [after every heavy rain; yearly], [hatches and cover],
      [main system (ERV, exhausts, AC)], [filters, coils, condensate, fans, controls], [per the MEP engineer's schedule], [roof plant area; ceiling access panels],
    )
    #v(4pt)
    #H[Reserved for the main system (not designed, open items M1–M3)]
    - *Roof plant area* over the maid wing, x #r2(plant.at(0))–#r2(plant.at(2)), y #r2(plant.at(1))–#r2(plant.at(3)) (≈ #r2((plant.at(2) - plant.at(0)) * (plant.at(3) - plant.at(1))) m²): ERV unit, AC outdoor units, screened from the street and the suite court; a roof hatch or stair for service; structure to allow for the loads (engineer).
    - *Risers:* the west shaft (1.5 × 1.2, x 0–1.5, y 9.2–10.4) rises from the utility room to the roof beside the bedrooms; a second riser beside the east kitchen stack if the MEP engineer needs it.
    - *Duct routes in the gypsum ceilings* of both floors (the owner's rule), with access panels; the first-floor rooms over the kitchen and the men's majlis have ribbed slabs: the ducts run below them in the ceilings, not through them.
  ],
  [
    #H[Open items for the engineers]
    #table(columns: (auto, auto, 1fr), stroke: none, inset: 2.2pt, fill: (_, y) => if calc.even(y) { rgb("#efece4") },
      [*M1*], [MEP], [*The main ventilation system:* filtered fresh air to the closed rooms (ERV / heat recovery, the bedrooms first), exhausts for the baths, WCs and the kitchen, the AC sized separately; the design, the plant location (the reserved roof area) and the duct routes in the gypsum ceilings.],
      [*M2*], [MEP / structure], [The roof plant area: equipment loads, screening, vibration and noise to the bedrooms and the suite court, service access.],
      [*M3*], [MEP], [The risers (the west shaft; a second one if needed) and the ceiling heights with the ducts (the gypsum ceilings at ≈ +3.05 … +3.20 under the drop beams).],
      [*A1*], [structure], [The tower base pit (#f2(air-base.at(0)) … #f2(air-base.at(1))) with the shaft walls as the foundation of the tower and the ends of W3 / W4; the duct leaves it through the W3 line: design the pit and the crossing.],
      [*A2*], [structure / MEP], [The duct: a factory-sealed box (precast RC or GRP) or an in-situ sealed box; its size (#r2(air-clear.at(0)) × #r2(air-clear.at(1)) assumed), joints, bedding, soil gas and ground-water sealing; soil report first (X9).],
      [*A3*], [structure], [The walls over the duct: the maid bath / laundry wall (y 2.8) and the laundry / kitchen partition (y 7.0, V6.4) on ground beams bridging it; the kitchen's west wall (x #r2(air-grille-x)) over the chamber on a ground beam between the C26 and C27 pads, with the plenum in its base.],
      [*A4*], [MEP], [Option study A / B / C: annual performance, cost and maintenance; the head opening sizes, the filter class, the fan, the damper control (night / day, dust, cold).],
      [*A5*], [MEP / safety], [Access: the shaft rungs and fall protection; the base pit and the chamber as confined spaces (two people, lid open); the sealed hatches and the floor cover gas-tight and lockable.],
      [*A6*], [MEP], [The drain points of the pit, the duct and the chamber (traps, non-return, where they discharge); the maid bath and laundry drains crossing above the duct (vertical clearance, protection); the sunken seating's floor drain and overflow at its lowest point (open to the sky: size them for the rain), and the fountain's drain.],
      [*A7*], [owner / design], [*Resolved (3d-char2):* the outlet moved to the courtyard's east wall; the women's majlis glass (x 5.1–8.1) stays complete.],
      [*A8*], [MEP], [The optional pad frame and fan at the outlet: water quality (float valve, backflow preventer, daily drain-and-dry), noise, power; no sprays or mist (rule).],
    )
    #v(4pt)
    #text(6.5pt, fill: gray)[Sizes assumed: head 2.5 m above the roof, openings 0.8 × 1.2 on the north and west faces; shaft ≈ 0.78 × 1.3 clear; base pit to −1.95; duct clear 0.6 × 0.6 in a 0.9 box, top −1.00, fall 1.5 %; chamber 1.35 × 0.7 clear under the kitchen floor, floor −2.10; grille 1.0 wide in the kitchen's west wall, +0.15 … +0.75 (sunken seating −0.45, bench seat −0.05: style study); roof plant area ≈ 11.6 m²; pads 1.5 × 1.5 with underside −1.50, tie beams to −0.90. Nothing here replaces the MEP or structural design.]
    #v(3pt)
    #text(8pt, weight: "bold", fill: green)[✓ Air system study v2.1 · dry malqaf · route E · duct #r2(air-length) m · outlet in the kitchen's west wall over the sunken seating · main system by the MEP engineer · 10 open items (A7 resolved)]
  ],
)

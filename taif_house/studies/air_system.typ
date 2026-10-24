// air_system.typ · Taif / Palm House V6.2 · AIR SYSTEM STUDY v2 (air-p2): a dry malqaf for night ventilation, a small dry duct, a wall outlet in the courtyard;
// the house's MAIN ventilation is a calculated system (ERV, exhausts, AC) designed by the MEP engineer · compile THIS file
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
#let air-route = ((8.95, 0.75), (7.27, 0.75), (7.27, 6.6))   // the duct axis from the tower's west wall: west under the women's majlis north strip → south to the outlet chamber (route A)
#let air-L1 = air-route.at(0).at(0) - air-route.at(1).at(0)   // leg 1, west
#let air-L2 = air-route.at(2).at(1) - air-route.at(1).at(1)   // leg 2, south
#let air-duct = (0.9, -1.0, -1.9)       // the duct: outer size (square), top at the tower end, underside at the tower end (walls 0.15); it passes just under the assumed tie beams (−0.90)
#let air-clear = (0.6, 0.6)             // clear width × clear height inside the duct (ASSUMED; the MEP engineer sizes it)
#let air-fall = 0.015                   // the duct floor falls 1.5 % from the tower end to the drain point in the outlet chamber
#let air-invert = (-1.75, -1.86)        // the duct floor (clear) at the tower end and at the chamber end
#let air-chamber = (6.75, 6.6, 7.95, 7.6)   // the outlet chamber under the courtyard floor against the north wall, outer (x0, y0, x1, y1); walls 0.15, clear 0.9 × 0.7; floor −2.10
#let air-cover = (7.0, 6.8, 7.6, 7.4)       // the sealed, gas-tight floor cover in the courtyard slab (clear opening), opened only for cleaning: NOT an air opening
#let air-grille = (6.85, 0.2, 7.85, 0.8)    // the outlet grille in the courtyard's north wall (x0, z0, x1, z1), decorative (mashrabiya-type), bottom 0.2 above the floor
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
#let pads = (("C15", 4.25, 0), ("C16", 4.25, 3.0), ("C17", 4.25, 6.5), ("C21", 5.6, 6.5), ("C24", 8.95, 0), ("C25", 8.95, 3.0), ("C26", 8.95, 6.5), ("C30", 10.051, 0), ("C31", 11.572, 2.8), ("C18", 4.25, 13.0), ("C27", 8.95, 13.0), ("C22", 5.6, 13.0))
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
#text(14pt, weight: "bold", fill: green)[Air system study v2 · dry malqaf for night ventilation, small dry duct, wall outlet · Taif / Palm House V6.2]
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
    // the house drains of the east block go straight east to the manhole: they never cross the duct
    for y in (1.9, 4.5, 9.8) { line(q((10.3, y)), q((14.2, y)), stroke: (paint: blue, dash: "dashed", thickness: 0.7pt), mark: (end: "stealth", fill: blue, scale: 0.4)) }
    circle(q((14.6, 5.0)), radius: 0.35, stroke: 0.7pt + blue); T((15.1, 5.0), [east manhole], size: 4pt, fill: blue, anchor: "west"); T((12.2, 4.1), [house drains → east], size: 3.8pt, fill: blue)
    // the reserved roof plant area (dashed, above this plan)
    let (px0, py0, px1, py1) = plant
    rect(q((px0, py0)), q((px1, py1)), stroke: (paint: green, dash: "dashed", thickness: 0.8pt)); T((11.3, 4.9), [roof plant area reserved\ (ERV · AC units) · not designed], size: 3.5pt, fill: green)
    // the duct (route A), the tower, the outlet chamber, the grille
    let (w, zt, zb) = air-duct
    poly(((air-route.at(0).at(0) + 0.3, air-route.at(0).at(1) - w / 2), (air-route.at(1).at(0) - w / 2, air-route.at(1).at(1) - w / 2), (air-route.at(2).at(0) - w / 2, air-route.at(2).at(1)), (air-route.at(2).at(0) + w / 2, air-route.at(2).at(1)), (air-route.at(1).at(0) + w / 2, air-route.at(1).at(1) + w / 2), (air-route.at(0).at(0) + 0.3, air-route.at(0).at(1) + w / 2)), fill: rgb("#f6d7b8"), stroke: 1pt + orange)
    poly(air-tower, fill: rgb("#cfe0ee"), stroke: 1pt + blue)
    let (cx0, cy0, cx1, cy1) = air-chamber
    rect(q((cx0, cy0)), q((cx1, cy1)), fill: rgb("#f6d7b8"), stroke: 1pt + orange)
    let (vx0, vy0, vx1, vy1) = air-cover
    rect(q((vx0, vy0)), q((vx1, vy1)), fill: white, stroke: 0.5pt + ink); T((7.3, 7.1), [sealed\ cover], size: 3.2pt)
    let (gx0, gz0, gx1, gz1) = air-grille
    line(q((gx0, 6.5)), q((gx1, 6.5)), stroke: 2.4pt + orange); T((7.35, 6.15), [grille in the wall, +0.2 … +0.8], size: 3.4pt, fill: orange)
    line(q((9.75, 0.75)), q(air-route.at(1)), q((air-route.at(2).at(0), 6.3)), stroke: (paint: orange, thickness: 1pt), mark: (end: "stealth", fill: orange, scale: 0.5))
    T((8.1, 0.25), [dry duct 0.6 × 0.6 clear · top −1.00], size: 3.6pt, fill: orange)
    T((6.45, 3.6), [route A · under the women's majlis · #r2(air-length) m], size: 3.8pt, fill: orange, angle: 90deg)
    T((9.77, 0.5), [tower], size: 3.8pt, fill: blue)
    T((7.35, 8.2), [outlet chamber under the floor\ 0.9 × 0.7 clear · pad frame + fan (optional)], size: 3.5pt, fill: orange)
    // the NW wind at the head
    line(q((8.3, -2.6)), q((9.7, -1.3)), stroke: 1.4pt + red, mark: (end: "stealth", fill: red, scale: 0.6)); T((7.9, -2.9), [NW wind → head openings N + W (night)], size: 4pt, fill: red, anchor: "west")
    circle(q((6.6, 12.4)), radius: 0.2, stroke: 0.6pt + blue); T((6.6, 12.9), [courtyard drain (south end)], size: 3.6pt, fill: blue)
    T((6.6, 9.75), [courtyard], size: 4.2pt, fill: luma(110)); T((6.6, 3.3), [women's majlis], size: 4.2pt, fill: luma(110)); T((11.0, 9.75), [kitchen], size: 4.2pt, fill: luma(110)); T((9.8, 1.9), [maid bath], size: 3.8pt, fill: luma(110))
    // the west shaft: a riser reserved for the main system's ducts (not designed)
    rect(q((0, 9.2)), q((1.5, 10.4)), stroke: (paint: green, dash: "dashed", thickness: 0.8pt)); T((0.75, 9.8), [west shaft:\ ERV riser?], size: 3.2pt, fill: green)
    content(q((6.65, -3.6)), text(7pt, weight: "bold")[Plan at foundation level · the tower, the dry duct (route A), the outlet chamber and the wall grille · assumed pads dashed · reserves dashed green])
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
    - *Duct:* a short, small, *dry* duct from the tower base to the courtyard's north wall, assumed *#r2(air-clear.at(0)) × #r2(air-clear.at(1)) m clear* (size to be calculated), smooth inside, sloped #str(calc.round(air-fall * 100, digits: 1)) % to a drain point, *sealed against soil gas and ground water*; a separate element just under the assumed tie beams (top #f2(air-duct.at(1))), clear of the footings; *not walk-in*: cleaned from both ends (brush, camera, cleaning robot) through *sealed access hatches* at the tower base and at the outlet chamber.
    - *Outlet in the wall, not in the floor:* a low grille in the courtyard's north wall (bottom +#r2(air-grille.at(1)), top +#r2(air-grille.at(3))), decorative (mashrabiya-type), for a slow low-level, displacement-type supply across the courtyard floor. *No air opening in the courtyard floor* (rain, dust, leaves, washing water, a trip hazard); the cleaning access is a *sealed floor cover* next to the wall, opened only for cleaning.
    #v(2pt)
  ],
)

// ================= PAGE 2 · long section =================
#pagebreak()
#text(12pt, weight: "bold", fill: green)[Long section along the air path · tower head → shaft → base pit → dry duct → outlet chamber → wall grille → courtyard]
#h(6pt) #text(7pt, fill: gray)[unfolded along the axis (the bend at x #r2(air-route.at(1).at(0)) is straightened) · levels from the finished ground floor ±0.00 · all assumed / not calculated]
#v(2pt)
#let L1 = air-L1
#let L2 = air-L2
#let s-exit = 0.8                         // the tower's west wall (axis to wall)
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
    R(-1.5, -0.28, s-chamber + ch-len + 2.3, -0.08, fill: luma(150), stroke: none)         // ground slab
    R(-1.5, 3.32, 1.2, 3.52, fill: luma(150), stroke: none); R(-1.5, 7.0, 1.2, 7.2, fill: luma(150), stroke: none); R(-1.5, 7.2, 1.2, 7.3, fill: luma(200), stroke: none)
    T((-0.9, 1.6), [women's majlis], size: 4pt); T((-0.9, 5.2), [kids' room], size: 4pt); T((-0.9, 7.6), [roof], size: 4pt)
    // assumed tie beam under the majlis floor (on the column lines), the duct passes under it
    R(s-exit + 0.6, -0.9, s-exit + 0.9, -0.28, fill: luma(120), stroke: none); T((s-exit + 1.3, -0.6), [tie beam (assumed −0.90)], size: 3.3pt, anchor: "west")
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
    R(x0 - 0.02, air-invert.at(0) - 0.05, x0 + 0.1, air-invert.at(0) + cw + 0.05, fill: white, stroke: 0.8pt + red); T((x0 + 0.15, top(x0) + 0.3), [sealed access hatch 1], size: 3.3pt, fill: red, anchor: "west")
    R(x1 - 0.1, air-invert.at(1) - 0.05, x1 + 0.02, air-invert.at(1) + cw + 0.05, fill: white, stroke: 0.8pt + red); T((x1 - 0.15, top(x1) + 0.3), [sealed access hatch 2], size: 3.3pt, fill: red, anchor: "east")
    T((x0 + (x1 - x0) / 2, top(x0) + 0.3), [dry duct · clear #r2(cw) × #r2(ch) (assumed) · smooth · sealed · falls #str(calc.round(air-fall * 100, digits: 1)) % → drain point], size: 4pt, fill: orange)
    line((x0 + 0.5, (top(x0) + bot(x0)) / 2), (x1 - 0.5, (top(x1) + bot(x1)) / 2), stroke: 1pt + orange, mark: (end: "stealth", fill: orange, scale: 0.6))
    T((x0 + (x1 - x0) / 2, bot(x1) - 0.3), [not walk-in · cleaned from both ends (brush · camera · robot) · no water inside], size: 3.4pt, fill: luma(110))
    // the outlet chamber under the courtyard floor, the plenum in the wall base, the grille
    let c0 = x1; let c1 = x1 + ch-len
    let zc = -2.1
    R(c0 - 0.15, zc - 0.15, c1, zc, fill: luma(90), stroke: none)                       // floor
    R(c0 - 0.15, zc, c0, air-invert.at(1) - 0.0, fill: luma(90), stroke: none)         // north wall below the duct mouth
    R(c1 - 0.15, zc, c1, -0.28, fill: luma(90), stroke: none)                           // south wall
    R(c0, -0.28, c1, -0.08, fill: luma(150), stroke: none)                              // chamber top = courtyard slab
    let (vx0, vy0, vx1, vy1) = air-cover
    R(c0 + (vy0 - air-chamber.at(1)), -0.3, c0 + (vy1 - air-chamber.at(1)), -0.06, fill: white, stroke: 0.8pt + red); T((c0 + 0.5, 0.3), [sealed floor cover (cleaning only)], size: 3.3pt, fill: red)
    R(c0 + 0.15, zc, c0 + 0.5, zc + 0.08, fill: white, stroke: 0.5pt + blue); T((c0 + 0.35, zc - 0.3), [drain point\ (non-return)], size: 3.1pt, fill: blue)
    R(c0 + 0.2, zc + 0.3, c0 + 0.8, zc + 0.9, stroke: (paint: green, dash: "dashed", thickness: 0.6pt)); T((c0 + 0.5, zc + 1.1), [removable pad frame\ + quiet fan (optional)\ water · drain · power], size: 3.1pt, fill: green)
    // the plenum rising in the wall base (the courtyard north wall stands on the chamber's north wall line: y 6.5 ± 0.1)
    R(c0 - 0.12, -0.28, c0 + 0.12, 3.32, fill: luma(200), stroke: 0.3pt + luma(120))
    R(c0 - 0.1, -0.28, c0 + 0.1, air-grille.at(3), fill: white, stroke: 0.4pt + orange)
    line((c0 + 0.1, air-grille.at(1)), (c0 + 0.1, air-grille.at(3)), stroke: 2.4pt + orange); T((c0 + 0.2, air-grille.at(3) + 0.3), [grille +#r2(air-grille.at(1)) … +#r2(air-grille.at(3)) in the wall base, courtyard side (mashrabiya-type)], size: 3.4pt, fill: orange, anchor: "west")
    T((c0, 3.7), [courtyard N wall (women's majlis glass above the grille zone: A7) · ground beam over the duct mouth (A3)], size: 3.1pt)
    line((c0 + 0.5, zc + 0.5), (c0 + 0.05, -0.2), (c0 + 0.05, 0.5), (c0 + 0.9, 0.5), stroke: 1pt + orange, mark: (end: "stealth", fill: orange, scale: 0.6))
    T((c1 + 1.3, 1.0), [courtyard\ (open sky)], size: 4.2pt, fill: blue); T((c0 + 0.5, zc + 1.75), [chamber 0.9 × 0.7 clear], size: 3.4pt, fill: orange)
    T((s-chamber / 2 + 0.4, -2.9), [S], size: 4pt); T((-1.9, -2.9), [N · E], size: 4pt)
  }),
  [
    #set text(6.9pt)
    #H[How it works (qualitative only; nothing calculated)]
    - *Night ventilation:* in the evening the damper opens; the head catches the north-west breeze above the roof (or the cool, heavy night air simply sinks down the shaft); the air passes the screen and the filter, falls down the shaft, runs through the short dry duct and leaves slowly through the low wall grille across the courtyard floor, cooling the courtyard's walls and floor. In the morning the damper closes and the cooled mass keeps the courtyard pleasant longer. *How much:* not calculated; the MEP engineer estimates the flow (wind-driven and stack) and decides whether a small fan is needed (option B).
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
      [grille in the wall], [+#r2(air-grille.at(1)) … +#r2(air-grille.at(3))],
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
  cetz.canvas(length: 1.35cm, {
    import cetz.draw: *
    let T(p, t, size: 4.4pt, fill: ink, anchor: "center", angle: 0deg) = content(p, anchor: anchor, angle: angle, text(size, fill: fill, t))
    let R(x0, z0, x1, z1, ..a) = rect((x0, z0), (x1, z1), ..a)
    // section through the outlet chamber, looking west: horizontal = y (north left), vertical = level
    let y0 = air-chamber.at(1); let y1 = air-chamber.at(3); let Y(y) = y - y0
    let zc = -2.1
    line((Y(5.6), 0), (Y(9.2), 0), stroke: 0.8pt + ink)
    R(Y(5.6), -0.28, Y(y0), -0.08, fill: luma(150), stroke: none); R(Y(y0), -0.28, Y(9.2), -0.08, fill: luma(150), stroke: none)
    R(Y(y0 - 0.15), zc - 0.15, Y(y1), zc, fill: luma(90), stroke: none); R(Y(y0 - 0.15), zc, Y(y0), air-invert.at(1), fill: luma(90), stroke: none); R(Y(y1 - 0.15), zc, Y(y1), -0.28, fill: luma(90), stroke: none)
    R(Y(y0 - 0.9), air-invert.at(1) - 0.15, Y(y0 - 0.15), air-invert.at(1) + air-clear.at(1) + 0.15, fill: luma(90), stroke: none); R(Y(y0 - 0.9), air-invert.at(1), Y(y0), air-invert.at(1) + air-clear.at(1), fill: white, stroke: none)
    T((Y(y0 - 0.5), air-invert.at(1) + 0.3), [duct], size: 3.4pt, fill: orange)
    let (vx0, vy0, vx1, vy1) = air-cover
    R(Y(vy0), -0.3, Y(vy1), -0.06, fill: white, stroke: 0.8pt + red); T((Y((vy0 + vy1) / 2), 0.3), [sealed, gas-tight floor cover 0.6 × 0.6\ (cleaning only · NOT an air opening)], size: 3.2pt, fill: red)
    R(Y(y0 + 0.2), zc + 0.3, Y(y0 + 0.8), zc + 0.9, stroke: (paint: green, dash: "dashed", thickness: 0.6pt)); T((Y(y0 + 0.5), zc + 1.15), [pad frame + fan\ (optional, seasonal)], size: 3.1pt, fill: green)
    R(Y(y0 + 0.15), zc, Y(y0 + 0.45), zc + 0.08, fill: white, stroke: 0.5pt + blue); T((Y(y0 + 0.3), zc - 0.3), [drain point], size: 3.1pt, fill: blue)
    T((Y(y0 + 0.85), zc + 0.4), [water · power\ points], size: 3pt, fill: blue, anchor: "west")
    // the wall with the plenum and the grille
    R(Y(6.38), -0.28, Y(6.62), 3.32, fill: luma(200), stroke: 0.3pt + luma(120))
    R(Y(6.4), -0.28, Y(6.6), air-grille.at(3), fill: white, stroke: 0.4pt + orange)
    line((Y(6.6), air-grille.at(1)), (Y(6.6), air-grille.at(3)), stroke: 2.4pt + orange)
    T((Y(6.75), air-grille.at(3) + 0.25), [grille, courtyard side], size: 3.4pt, fill: orange, anchor: "west")
    T((Y(6.4), air-grille.at(3) + 0.9), [plenum in the\ wall base\ 0.2 × 1.0], size: 3.1pt, fill: orange, anchor: "east")
    line((Y(y0 + 0.5), zc + 0.6), (Y(6.5), -0.1), (Y(6.5), 0.5), (Y(7.3), 0.5), stroke: 1pt + orange, mark: (end: "stealth", fill: orange, scale: 0.6))
    T((Y(5.9), 1.2), [women's\ majlis], size: 4pt, fill: luma(110)); T((Y(8.3), 1.2), [courtyard], size: 4pt, fill: luma(110))
    T((Y(5.6), -0.5), [N], size: 4pt); T((Y(9.2), -0.5), [S], size: 4pt)
    content((Y(7.4), 3.7), text(6pt, weight: "bold", fill: green)[Outlet chamber and grille · section, looking west])
  }),
  [
    #set text(6.9pt)
    #H[Outlet chamber and grille (assumed)]
    - *Chamber:* under the courtyard floor against the north wall, outer x #r2(air-chamber.at(0))–#r2(air-chamber.at(2)), y #r2(air-chamber.at(1))–#r2(air-chamber.at(3)); clear 0.9 × 0.7, floor −2.10, walls 0.15, sealed like the duct; 0.40 m from the assumed C21 pad, 0.25 m from the C26 pad, east of the projection line (x 5.6). The duct enters through its north wall; a *sealed access hatch* there for cleaning the duct from this end.
    - *Air path:* chamber → a *plenum in the wall base* (0.2 × 1.0, the wall's thickness, from the slab to the grille head) → the *grille* on the courtyard face, +#r2(air-grille.at(1)) … +#r2(air-grille.at(3)), 1.0 m wide, decorative (mashrabiya-type), with an insect screen and a closable shutter behind it.
    - *Optional, installed only for the hot season:* a removable evaporative pad frame (≈ 0.6 × 0.6) and a small quiet fan in the chamber, with water, drain and power points. Rules: no sprays or mist; pads drained and dried daily; the duct and the tower stay dry.
    - *Access:* a sealed, gas-tight floor cover 0.6 × 0.6 in the courtyard slab beside the wall, opened only for cleaning and for the seasonal pad frame; *not an air opening*. The chamber is 2 m deep: a short ladder stored nearby, two people, lid open (A5).
    - *The glass:* the women's majlis glass (x 5.1–8.1) stands on this wall; the grille zone x #r2(air-grille.at(0))–#r2(air-grille.at(2)) needs a solid wall base 0.9 m high there (raise the glass sill over 1.0 m) or the glass shortened to x 5.1–6.4: owner (A7).
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
    #H[Route: the same two candidates as v1]
    #table(columns: (auto, 1fr, 1fr), stroke: none, inset: 2pt, fill: (_, y) => if calc.even(y) { rgb("#efece4") },
      [], [*A · under the women's majlis (chosen)*], [B · under the maid wing (rejected)],
      [path], [tower base → #r2(air-L1) m west → #r2(air-L2) m south on x #r2(air-route.at(1).at(0)) → chamber at the courtyard's north wall; #r2(air-length) m], [south under the maid bath and the laundry, west under the kitchen north wall; ≈ 8.5 m],
      [above], [the women's majlis only (no drains); no bedroom, no wet room], [maid bath, laundry (drains, leaks), kitchen wall],
      [footings], [the W3 / C24 line at the tower (the tower base pit, A1); the majlis south wall ground beam at the chamber (A3); 0.48 m from the C25 pad, 0.4 / 0.25 m from C21 / C26], [walls y 1.0 and 2.8, the RC wall W5, the C26 pad: three crossings],
      [drains], [none cross it], [crosses the maid bath and laundry drains],
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
      [outlet chamber + drain point], [sweep, check the drain and the trap, the water and power points], [every 6 months], [sealed floor cover beside the wall (cleaning only)],
      [grille, screen and shutter], [wash the screen, clear the grille, test the shutter], [monthly in use], [from the courtyard, standing],
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
      [*A3*], [structure], [The women's majlis south wall (y 6.5) over the duct mouth: a ground beam bridging it between the C21 and C26 pads; the plenum in the wall base.],
      [*A4*], [MEP], [Option study A / B / C: annual performance, cost and maintenance; the head opening sizes, the filter class, the fan, the damper control (night / day, dust, cold).],
      [*A5*], [MEP / safety], [Access: the shaft rungs and fall protection; the base pit and the chamber as confined spaces (two people, lid open); the sealed hatches and the floor cover gas-tight and lockable.],
      [*A6*], [MEP], [The drain points of the pit, the duct and the chamber (traps, non-return, where they discharge); the courtyard floor drain at the south end, away from the chamber.],
      [*A7*], [owner / design], [The grille zone in the women's majlis glass wall (x #r2(air-grille.at(0))–#r2(air-grille.at(2))): a solid 0.9 m wall base there, or the glass shortened to x 5.1–6.4.],
      [*A8*], [MEP], [The optional pad frame and fan at the outlet: water quality (float valve, backflow preventer, daily drain-and-dry), noise, power; no sprays or mist (rule).],
    )
    #v(4pt)
    #text(6.5pt, fill: gray)[Sizes assumed: head 2.5 m above the roof, openings 0.8 × 1.2 on the north and west faces; shaft ≈ 0.78 × 1.3 clear; base pit to −1.95; duct clear 0.6 × 0.6 in a 0.9 box, top −1.00, fall 1.5 %; chamber 0.9 × 0.7 clear, floor −2.10; grille 1.0 wide, +0.20 … +0.80; roof plant area ≈ 11.6 m²; pads 1.5 × 1.5 with underside −1.50, tie beams to −0.90. Nothing here replaces the MEP or structural design.]
    #v(3pt)
    #text(8pt, weight: "bold", fill: green)[✓ Air system study v2 · dry malqaf · route A · duct #r2(air-length) m · wall outlet · main system by the MEP engineer · 11 open items]
  ],
)

// air_system.typ · Taif / Palm House V7.1 · AIR SYSTEM · FINAL CONCEPT (v3, owner goals 1 Nov 2026; design review E-01)
// ONE tower, the symbol of the house, with TWO completely separate air paths: (a) a gentle natural breeze for the courtyard seating in pleasant
// weather, (b) the fresh-air intake of the house's ventilation unit, all year. Low maintenance. NO water in the air system, no evaporative pads,
// no buried earth pipes, no human entry anywhere (no pit, no walk-in tunnel, no chamber with entry: v1 and v2 withdrawn).
// v3.1 (owner decisions on the open items, 1 Nov 2026): the assist fan YES (in the plenum behind the grille, its own switch); bird mesh only on the breeze path;
// the HRV in a BASE under the tower (one mass, top +9.10 = the attic coping); the AC condensers south of the tower with a clear distance; the make-up inlet's position proposed.
// EVERY size and performance figure here is ASSUMED, TO BE DESIGNED BY THE MEP ENGINEER; compiling this study is not engineering approval.
// Reads: data/rooms_gf.csv, data/rooms_ff.csv; the `#let air-*` tuples are read by 3d/build_3d.py (to be rewritten for v3 at the next 3D build).
// CSV frame: x east, y south, wall centre lines; levels above the finished ground floor ±0.00.
#import "@preview/cetz:0.4.2"
#set page(paper: "a4", flipped: true, margin: 9mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 7.3pt)
#let ink = rgb("#3d4a45")
#let green = rgb("#2f6b4f")
#let red = rgb("#b5452f")
#let blue = rgb("#1f4e79")
#let orange = rgb("#c25b00")
#let amber = rgb("#b58a1f")
#let sky = rgb("#8ccbe0")
#let r1(v) = str(calc.round(v, digits: 1))
#let r2(v) = str(calc.round(v, digits: 2))
#let r3(v) = str(calc.round(v, digits: 3))
#let f2(v) = { let s = str(calc.round(calc.abs(v), digits: 2)); if v < 0 { "−" + s } else { "+" + s } }
#let H(t) = text(9.2pt, weight: "bold", fill: green, t)
#let A(body) = text(fill: amber, weight: "bold", body)   // assumed, to be designed by the MEP engineer
#let dist(a, b) = calc.sqrt(calc.pow(a.at(0) - b.at(0), 2) + calc.pow(a.at(1) - b.at(1), 2))
#let plen(P) = range(P.len() - 1).map(i => dist(P.at(i), P.at(i + 1))).sum()
#let area(P) = calc.abs(range(P.len()).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, P.len())); a.at(0) * b.at(1) - b.at(0) * a.at(1) }).sum()) / 2

// ---------- the system, as data (CSV frame; levels from the finished ground floor; ALL ASSUMED) · the `air-*` names are read by 3d/build_3d.py ----------
#let air-tower = ((8.95, 0), (10.051, 0), (10.594, 1.0), (8.95, 1.0))   // the tower on wall centre lines (design_gf.typ tower-pts), the tip of the cut corner
#let air-head = (7.3, 9.8)              // the head: from the roof finish to the top of the shaft walls, 2.5 m above the roof (the one element above the attic, studies/roof.typ)
#let air-head-opening = (8.2, 9.4)      // the louvred openings in the head (sill, head), on all FOUR faces (v3: Yazd type)
#let air-base = (-0.08, -0.40)          // the breeze shaft's base: from the ground slab top to its shallow sump floor (a drain with a dry trap; NO pit, no entry)
#let air-route = ((10.2, 1.0), (10.2, 10.5), (9.2, 10.5))   // the breeze channel axis: straight south on x 10.2 under the maid bath, the laundry and the kitchen walkway, then west under the sink counter to the plenum
#let air-duct = (0.9, -0.08, -0.28)     // the channel: 0.9 wide, from the ground-slab top (the covers flush with the floor) to the slab underside: inside the slab depth, no beam or footing notched
#let air-clear = (0.9, 0.20)            // clear width × clear depth of the channel (0.18 m²); under the maid bath a throat 0.5 wide between the shower and the WC (0.10 m²)
#let air-fall = 0.005                   // the channel floor falls 0.5 % back to the tower's sump
#let air-invert = (-0.28, -0.32)        // the channel floor at the plenum end and at the tower end
#let air-chamber = (9.05, 10.0, 9.7, 11.0)   // v3: the fixed plenum box under the sink counter, 0.65 × 1.0, from the channel to the wall-base plenum; cleaned from the grille side (no entry)
#let air-cover = (9.7, 2.9, 10.6, 3.7)  // the first of the removable sealed covers in the laundry floor (0.9 × 0.8 each, gasketed, flush)
#let air-grille-x = 8.95                // the wall the grille is in: the courtyard's east wall = the kitchen's west wall; the grille on its courtyard face (x 8.85)
#let air-grille = (10.0, 0.05, 11.0, 0.40)   // the outlet grille (y0, z0, y1, z1): 1.0 × 0.35 below the outdoor TV, a manually adjustable louvre directing the air along the floor, removable
#let air-fan = (9.05, 10.1, 9.65, 10.9, -0.05, 0.30)   // v3.1 (owner): the assist fan box in the plenum directly behind the grille (x0, y0, x1, y1, z0, z1), slid out through the grille opening for service
#let air-sunken = (-0.15, 5.925, 8.7, 8.85, 12.3)   // the seating one step down (studies/courtyard_layout.typ): floor level, x0, y0, x1, y1
#let air-length = plen(air-route)       // the channel axis length, tower wall → plenum
#let air-throat = (0.5, 0.20)           // under the maid bath, between the shower and the WC
#let air-covers = 8                     // five in the laundry (y 2.9–6.9), three in the kitchen walkway (y 7.1–9.5)
// the tower's clear section and its split (v3): the breeze shaft and the airtight service compartment (ERV intake box at the top, the two risers below)
#let tower-clear = ((9.075, 0.125), (9.95, 0.125), (10.42, 0.875), (9.075, 0.875))   // inside the 250 outer walls and the 200 inner walls (assumed)
#let tower-area = area(tower-clear)
#let split-wall = 0.10                  // the airtight partition (block or a steel sheet on a frame), along y, at x ≈ 9.80
#let breeze-area = (9.80 - 9.075) * 0.75
#let service-area = tower-area - breeze-area - split-wall * 0.75
#let head-faces = 4
#let head-opening-area = head-faces * 0.8 * (air-head-opening.at(1) - air-head-opening.at(0))   // 4 × 0.8 × 1.2 gross
#let louvre-free = 0.5
#let screen-free = 0.9                  // a wide 20 mm bird mesh only (owner, 1 Nov 2026): ≈ 90 % open; no insect mesh on the breeze path (more breeze, less cleaning)
// the plant room (studies/roof.typ zone Z2a) and the roof points for the intake / exhaust distances
#let base = ((8.95, 1.0), (10.594, 1.0), (11.898, 3.4), (8.95, 3.4))   // v3.1 (owner): the HRV BASE under the tower, one mass with it: on the tower's west line and the cut facade line, y 1.0–3.4
#let base-top = 9.10                    // its roof top = the attic coping: nothing stands above the attic except the tower itself
#let base-slab = 0.15
#let base-clear-h = base-top - base-slab - 7.30   // 1.65 m from the roof finish to its slab underside: a low service compartment, not a room
#let base-clear = ((9.075, 1.1), (10.45, 1.1), (11.55, 3.2), (9.075, 3.2))   // inside its walls (0.25 on the cut, 0.20 elsewhere; the tower's south wall is its north wall)
#let base-doors = (1.3, 2.8, 1.5)       // a pair of doors on the west face, y 1.3–2.8, 1.5 m high: the unit right behind them, filters and the core pulled through them
#let fan = (q: (0.15, 0.25), dba: 30, w: (40, 60), box: (0.9, 0.3, 0.3))   // the assist fan (owner): two Ø250 EC axial fans at low speed in a flat box, ASSUMED
#let intake = (9.75, 0.45, 8.9)         // the ERV intake louvre: the tower's head level, north face (x, y, z)
#let exhaust = (11.55, 2.9, 7.9)        // the exhaust louvre: the base's cut (north-east) face, low, blowing east over the lane side
#let hood-out = (13.311, 10.7, 2.2)     // the kitchen hood outlet through the east wall
#let vent-stack = (13.2, 8.4, 8.0)      // the east-wall plumbing vent stack, terminating above the roof
#let gas-cab = (13.7, 8.6, 0.0)         // the LPG cabinet in the east service yard (site plan)
#let generator = (14.5, 12.0, 0.0)      // the generator point (site plan, proposal)
#let condensers = (9.6, 5.6, 12.4, 9.0) // the AC outdoor units' zone Z2b (studies/roof.typ): SOUTH of the tower and its base (owner)
#let ac-clear = condensers.at(1) - base.at(2).at(1)   // the clear distance from the base's south wall to the condenser zone: 2.2 m
#let d3(a, b) = calc.sqrt(calc.pow(a.at(0) - b.at(0), 2) + calc.pow(a.at(1) - b.at(1), 2) + calc.pow(a.at(2) - b.at(2), 2))
#let sep = (
  ([ERV intake ↔ ERV exhaust], d3(intake, exhaust), 3.0, [ASHRAE 62.1-2022 Table 5-1: class 2 exhaust (toilets) → intake ≥ 3 m (10 ft); the exhaust blows east, the intake faces north]),
  ([ERV intake ↔ kitchen hood outlet (east wall)], d3(intake, hood-out), 4.6, [class 3 (cooking) → ≥ 4.6 m (15 ft); the hood outlet is 6.6 m below the intake]),
  ([ERV intake ↔ plumbing vent stack], d3(intake, vent-stack), 3.0, [vents → ≥ 3 m (10 ft), and the intake 0.9 m above the vent top]),
  ([ERV intake ↔ LPG cabinet (yard)], d3(intake, gas-cab), 4.6, [a leak source at ground level: class 3 allowance]),
  ([ERV intake ↔ generator point (yard)], d3(intake, generator), 9.0, [class 4 (engine exhaust) → ≥ 9 m (30 ft); the generator's exhaust pipe led away from the house]),
  ([ERV intake ↔ nearest AC condenser (Z2b)], calc.sqrt(calc.pow(calc.max(0, condensers.at(1) - intake.at(1)), 2) + calc.pow(calc.max(0, condensers.at(0) - intake.at(0)), 2) + calc.pow(7.9 - intake.at(2), 2)), 2.0, [not an exhaust: 2 m from the hot plume (manufacturer); the intake is 1 m above the units]),
  ([ERV exhaust ↔ nearest AC condenser], calc.max(0, condensers.at(1) - exhaust.at(1)), 1.0, [stale air into a condenser is harmless; keep 1 m for service]),
)
// ---------- the breeze estimate (ASSUMED; the MEP engineer models it) ----------
#let rho = 1.15                         // Taif, 1 700 m: thinner air
#let dCp = 0.8                          // windward face +0.7 against the courtyard well ≈ −0.1 (assumed; the well's pressure is uncertain)
#let zeta-throat = (
  ("head louvres + bird mesh (4 faces, 3.84 m² gross, 45 % free → 1.73 m²)", 3.0 * calc.pow(air-throat.at(0) * air-throat.at(1) / (head-opening-area * louvre-free * screen-free), 2)),
  ("back-draught flaps and the shaft (0.54 m²)", 1.0 * calc.pow(0.10 / breeze-area, 2)),
  ("damper, open (in the shaft)", 0.5 * calc.pow(0.10 / breeze-area, 2)),
  ("the throat under the maid bath (contraction + expansion)", 1.5),
  ("channel friction, 10 m, 0.18 m²", 0.02 * air-length / 0.33 * calc.pow(0.10 / 0.18, 2)),
  ("the bend and the plenum", 0.8 * calc.pow(0.10 / 0.18, 2)),
  ("the grille (0.35 m², 50 % free)", 2.5 * calc.pow(0.10 / (0.35 * 0.5), 2)),
)
#let zeta = zeta-throat.map(z => z.at(1)).sum()
#let flow(v-wind) = { let dp = 0.5 * rho * v-wind * v-wind * dCp; let v = calc.sqrt(2 * dp / (rho * zeta)); (dp: dp, v: v, q: v * air-throat.at(0) * air-throat.at(1)) }
#let weak = flow(3.0)
#let moderate = flow(6.0)
#let grille-v(q) = q / (0.35 * 0.5)
#let felt(q) = grille-v(q) * 0.28       // a floor jet decays to ≈ 1/3–1/4 of the outlet speed 2 m away (assumed)
#let stack-dp = rho * 9.81 * 8.0 * 3 / 300
#let still = { let v = calc.sqrt(2 * stack-dp / (rho * zeta)); (dp: stack-dp, v: v, q: v * air-throat.at(0) * air-throat.at(1)) }
// ---------- the house ventilation (ASHRAE 62.2-2022 §4.1: Qtot = 0.15 L/s·m² × A + 3.5 L/s × (bedrooms + 1); guests: ASHRAE 62.1 assembly) ----------
#let parse-pts(s) = s.split(";").map(t => t.trim()).filter(t => t != "").map(t => { let v = t.split(" ").filter(u => u != ""); (float(v.at(0)), float(v.at(1))) })
#let read(path) = csv(path, row-type: dictionary).filter(r => r.name != "" and not r.name.starts-with("#")).map(r => {
  let P = if r.pts.trim() != "" { parse-pts(r.pts) } else {
    let x = float(r.x); let y = float(r.y); let w = float(r.w); let d = float(r.d)
    ((x - w / 2, y - d / 2), (x + w / 2, y - d / 2), (x + w / 2, y + d / 2), (x - w / 2, y + d / 2)) }
  (name: r.name, colour: r.colour, P: P, area: area(P)) })
#let GF = read("../data/rooms_gf.csv")
#let FF = read("../data/rooms_ff.csv")
#let conditioned = GF.filter(r => r.colour != "court" and r.colour != "tower").map(r => r.area).sum() + FF.filter(r => r.colour != "open").map(r => r.area).sum()
#let cond-clear = conditioned * 0.92    // ≈ clear floor area (walls off)
#let bedrooms = 5                       // bedrooms 1–3, the kids' room, the suite (the maid room ventilated with the house too)
#let q-normal = 0.15 * cond-clear + 3.5 * (bedrooms + 1)      // L/s
#let guests = 24
#let majlis = GF.find(r => r.name == "Men's majlis").area * 0.93
#let q-majlis = 3.8 * guests + 0.3 * majlis                   // ASHRAE 62.1-2022 Table 6-1 "lecture / assembly" class (3.8 L/s·person + 0.3 L/s·m²): L/s
#let q-boost = q-normal + q-majlis
#let unit = (flow: 750, size: (1.2, 0.7, 0.7), weight: 110, power: (90, 350), note: "a 750 m³/h class counterflow HRV / ERV (sensible core; enthalpy core optional), on a 0.1 plinth in the tower's base, its front at the doors")
#let hood = 750                         // m³/h, the kitchen hood (600–900), separate, with make-up air
// ceiling zones (studies/structure.typ: slab undersides +3.32 under 0.20 slabs, +3.22 under the 0.30 ribbed bays; beams B1 +3.20, B4 +3.10, B5 +3.05; roof underside +7.00 / +6.90)
#let ceilings = (
  ([GF rooms under the 0.20 slabs (women's majlis, riwaq, the wash block, the maid wing)], 3.32, 0.10, 3.17),
  ([GF rooms under the 0.30 ribbed bays (kitchen, dining, men's majlis)], 3.22, 0.10, 3.07),
  ([under beam B1 (women's majlis / kids' wall, soffit +3.20): a 0.3 m band], 3.20, 0.0, 3.05),
  ([under beam B4 (the riwaq's east wall line, soffit +3.10): a band over the riwaq], 3.10, 0.0, 2.95),
  ([under beam B5 (the living / dining ceiling step, soffit +3.05): a 0.3 m band at the dining's west edge], 3.05, 0.0, 2.90),
  ([kitchen (the hood duct 0.25 + the extract duct in the same zone)], 3.22, 0.25, 2.92),
  ([FF rooms under the 0.20 roof slab (bedrooms 2 / 3, the kids' room, the family living, the gallery)], 7.00, 0.10, 6.85),
  ([FF rooms under the 0.30 roof bays (the suite, the office, the gym)], 6.90, 0.10, 6.75),
)
// ---------- checks ----------
#let checks = (
  ([the tower's clear section holds the breeze shaft (≥ 0.5 m²) and the service compartment (≥ 0.18 m², the two Ø250 risers and the intake box) with the partition], breeze-area >= 0.5 - 1e-6 and service-area >= 0.18),
  ([the channel stays inside the ground-slab depth (no beam or footing notched): top −0.08, underside −0.28], calc.abs(air-duct.at(1) + 0.08) < 1e-6 and calc.abs(air-duct.at(2) + 0.28) < 1e-6),
  ([the channel is straight with one bend, ≤ 11 m], air-route.len() == 3 and air-length <= 11.0),
  ([the grille is below the TV (+0.52) and ≥ 0.15 above the seating floor], air-grille.at(3) <= 0.52 - 0.1 and air-grille.at(1) >= -0.15 + 0.15),
  ([every intake separation meets its allowance], sep.all(((l, d, need, b)) => d >= need)),
  ([the base's top does not rise above the attic coping (+9.10) and its clear height takes the unit on its plinth with 0.5 m spare], base-top <= 9.10 + 1e-6 and base-clear-h >= unit.size.at(2) + 0.1 + 0.5),
  ([the condensers stay south of the base with ≥ 2 m clear and ≥ 5 m from the intake in plan], ac-clear >= 2.0 and condensers.at(1) - intake.at(1) >= 5.0),
  ([no finished ceiling below +2.90 on the ground floor or +6.75 on the first floor], ceilings.all(((n, s, d, c)) => c >= 2.90)),
  ([the unit covers the guest boost (≥ #r1(q-boost * 3.6) m³/h)], unit.flow >= q-boost * 3.6),
)
#let all-ok = checks.all(c => c.at(1))

// ====================================================================================== PAGE 1 · the concept and the tower
#text(14pt, weight: "bold", fill: green)[Air system study v3 · one tower, two separate air paths · Taif / Palm House V7.1]
#v(1pt)
#text(8pt, fill: gray)[Owner goals 1 Nov 2026 (design review E-01) and the owner's decisions on the open items (v3.1: assist fan, bird mesh, the HRV base under the tower, the condensers south, the make-up inlet) · a gentle natural breeze for the courtyard seating in pleasant weather, and the fresh-air intake of the house's ventilation unit all year · no water in the air system, no pads, no earth pipes, no human entry · #A[every size and performance figure is ASSUMED, to be designed by the MEP engineer]; compiling this study is not engineering approval]
#v(3pt)
#let tower-plan(length: 2.4cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let q(p) = (p.at(0), -p.at(1))
  let T(p, t, size: 4.4pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, t))
  line(..air-tower.map(q), close: true, fill: luma(170), stroke: 0.6pt + ink)
  line(..tower-clear.map(q), close: true, fill: white, stroke: 0.4pt + ink)
  // the partition and the two parts
  line(q((9.80, 0.125)), q((9.80, 0.875)), stroke: 2.4pt + ink)
  rect(q((9.075, 0.125)), q((9.80, 0.875)), fill: sky.transparentize(50%), stroke: none); T((9.44, 0.5), [breeze shaft\ #r2(breeze-area) m²], size: 4pt)
  rect(q((9.85, 0.125)), q((10.42, 0.875)), fill: rgb("#dfe8d0"), stroke: none); T((10.1, 0.38), [service\ #r2(service-area) m²], size: 3.6pt)
  circle(q((10.0, 0.64)), radius: 0.11, fill: white, stroke: 0.4pt + ink); circle(q((10.26, 0.64)), radius: 0.11, fill: white, stroke: 0.4pt + ink); T((10.13, 0.88), [Ø250 risers], size: 3pt)
  // the head's + divider over the breeze shaft (dashed) and the four faces
  line(q((9.44, 0.125)), q((9.44, 0.875)), stroke: (paint: blue, thickness: 0.6pt, dash: "dashed")); line(q((9.075, 0.5)), q((9.80, 0.5)), stroke: (paint: blue, thickness: 0.6pt, dash: "dashed"))
  T((9.44, -0.12), [N face · louvre + screen], size: 3.4pt, fill: blue); T((9.44, 1.12), [S face (over the plant side)], size: 3.4pt, fill: blue); T((8.85, 0.5), [W], size: 3.4pt, fill: blue, angle: 90deg); T((10.75, 0.6), [NE (cut) face], size: 3.4pt, fill: blue, angle: -61deg)
  T((9.44, 1.35), [tower plan at the head · the + divider (dashed) only in the head, each quarter with a back-draught flap · 1 m = 2.4 cm], size: 3.8pt, fill: green)
})
#grid(columns: (1fr, 1.35fr), gutter: 12pt,
  [
    #H[1 · The concept]
    - *One tower* in the tip of the cut corner (#r2(area(air-tower)) m² on walls, *#r2(tower-area) m² clear*, assumed), the symbol of the house, rising #r2(air-head.at(1) - 7.3) m above the roof finish (head #f2(air-head.at(0)) … #f2(air-head.at(1))), the one element above the attic (`studies/roof.typ`).
    - *Path (a), the courtyard breeze:* a four-sided head → a breeze shaft → a damper → a shallow channel in the ground slab → the grille under the outdoor TV: a gentle natural breeze for the seating in pleasant weather; not cooling (if it is too hot the family does not sit there); no water, no pads, no earth pipe; a quiet *assist fan* in the plenum behind the grille, on its own switch (owner, 1 Nov 2026; § 4).
    - *Path (b), the house's fresh air:* an airtight service compartment in the same tower with its own louvre and an accessible pre-filter, feeding the ventilation unit in the tower's *base* on the roof (one architectural mass with the tower, § 2); its supply and extract risers run down the same compartment to both floors' ceilings. The two paths and the base are airtight from each other.
    - *Low maintenance, no entry:* every routine task is done from the roof (the head, the flaps, the damper, the pre-filter), from the roof at the base's doors (the unit, the filters, the core), from the laundry and kitchen floors (the channel's covers) or from the courtyard (the grille and the fan box). No shaft, pit or buried space is entered (§ 7).
    #v(2pt)
    #tower-plan()
  ],
  [
    #H[2 · The tower]
    - *Clear section #r2(tower-area) m²* (assumed, inside the walls), split by an airtight partition (#r2(split-wall) m, block or a sealed steel sheet on a frame) into the *breeze shaft #r2(breeze-area) m²* (west) and the *service compartment #r2(service-area) m²* (east): it holds both, #A[to confirm with the real wall thicknesses]; if the engineer thickens the walls, the smallest enlargement is 0.25 m on the cut side (a proposal only, not applied).
    - *Head (Yazd badgir type), four faces, in the house's style:* louvred openings #f2(air-head-opening.at(0)) … #f2(air-head-opening.at(1)) on all four faces (#r2(head-opening-area) m² gross), honey-stone surrounds, timber louvres. *The problem checked:* an undivided head open on four sides short-circuits (the wind enters windward and leaves leeward without reaching the courtyard). *The simplest arrangement that works:* the head only is divided into four quarters by a thin + divider (1.2 m high); at the foot of each quarter a *lightweight back-draught flap* (a gravity-hinged aluminium or fabric flap) closes under the leeward suction and opens under the windward pressure, so only the windward quarter(s) feed the single shaft below; no X dividers in the shaft, no wind sensor, no motor. #A[The flaps' free opening and their damping are the MEP engineer's.]
    - *Louvres and screens, cleanable from the roof:* on each face a weather louvre (≈ #str(calc.round(louvre-free * 100)) % free) and a *wide 20 mm bird mesh only* (≈ #str(calc.round(screen-free * 100)) % free; no insect mesh on the breeze path: owner, 1 Nov 2026, for more breeze and less cleaning; the HRV intake keeps its own pre-filter and fine filter), each on a hinged frame opened from the roof strip beside the tower (a 2 m step ladder) and brushed / vacuumed. *Their pressure loss counts for little* because the head's open area (#r2(head-opening-area * louvre-free * screen-free) m² net) is ten times the channel's throat: the losses sit in the channel and the grille (§ 4). No fine filter on the breeze path: natural wind cannot push through one, and the air goes outdoors.
    - *Damper:* a motorised blade damper across the breeze shaft near the TOP (just under the flaps, inside the tower at ≈ +8.0), a standard *spring-return HVAC actuator* (closes on power loss; ≈ 5 W holding, 24 V), on a wall switch beside the seating (by the TV) with an "open" light; the actuator inside the tower behind a hinged panel, reached from the *roof hatch* in the tower's south face (+7.6 … +8.4) by a hand from the roof: no entry.
    - *ERV intake compartment:* the service compartment's top 1.5 m (#f2(7.3) … #f2(8.8)) is an airtight box with its own louvre on the north face (0.8 × 0.5 at #f2(8.4) … #f2(8.9), a bird mesh, no fine screen) and a slide-in *pre-filter* (ISO Coarse 60 %, 500 × 500) behind it, pulled out through the same roof hatch (a second panel); below the box the two Ø250 risers; the Ø315 intake duct drops inside the compartment and passes through the tower's south wall straight into the base: no external duct.
    - *The base (owner, 1 Nov 2026): the tower rises from a base that houses the HRV, one mass.* Footprint on the tower's west line (x 8.95) and the cut facade line, y 1.0–3.4: #r2(area(base)) m² gross (1.64 m wide at the tower, 2.95 at its south wall), its top at #f2(base-top) = the attic coping, so nothing but the tower (#f2(air-head.at(1))) stands above the attic; inside ≈ #r2(area(base-clear)) m² and *#r2(base-clear-h) m clear* (roof finish #f2(7.30) to the slab underside): a *low service compartment, not a room*. The unit sits on a 0.1 plinth right behind a pair of doors (#r2(base-doors.at(2)) m high, y #r2(base-doors.at(0))–#r2(base-doors.at(1))) in its west face, which opens onto the roof terrace inside the attic: filters and the core are pulled out through the doors standing on the roof, nobody enters. The base is airtight from the tower's two paths (its own walls; the risers and the intake duct sealed where they cross the tower's south wall); the exhaust louvre on its cut face. *Composition:* the malqaf becomes a two-stage mass at the north-east corner (base to #f2(base-top), tower to #f2(air-head.at(1))), answering the stair room (+9.70) at the north-west; it stands on the facade lines like the stair room and shows 1.45 m above the cornice coping from the lane. `studies/roof.typ` updated (Z2a = the base).
  ],
)
#v(2pt)
#text(7.5pt)[#if all-ok [*Air system study v3 · checks passed* (#checks.len())] else [*CHECKS FAILED:* #checks.filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]]

// ====================================================================================== PAGE 2 · the breeze path: plan and long section
#pagebreak()
#text(12pt, weight: "bold", fill: green)[3 · The courtyard breeze path: the channel in the slab, its covers, the plenum and the grille · plan and long section]
#v(2pt)
#let path-plan(length: 0.62cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let q(p) = (p.at(0), -p.at(1))
  let T(p, t, size: 4.2pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, t))
  let fills = (family: rgb("#f6e3c0"), guest: rgb("#e9d9c4"), service: rgb("#dbe7ec"), core: rgb("#e4ded2"), circ: rgb("#f2efe8"), court: rgb("#dbe9f4"), tower: rgb("#cfe0d8"))
  for r in GF.filter(r => calc.min(..r.P.map(p => p.at(1))) < 14 and calc.max(..r.P.map(p => p.at(0))) > 4.0) { line(..r.P.map(q), close: true, fill: fills.at(r.colour, default: luma(235)), stroke: 0.5pt + ink); let c = (r.P.map(p => p.at(0)).sum() / r.P.len(), r.P.map(p => p.at(1)).sum() / r.P.len()); T((c.at(0), c.at(1) - 0.3), text(3.4pt, fill: luma(110), r.name.split(" (").at(0))) }
  line(..air-tower.map(q), close: true, fill: sky, stroke: 0.6pt + blue); T((9.75, 0.5), [tower], size: 3.8pt)
  // the channel, the throat, the covers, the plenum, the grille
  let (x0, y0) = air-route.at(0); let (x1, y1) = air-route.at(1)
  rect(q((x0 - 0.45, 1.0)), q((x0 + 0.45, 2.8)), fill: white, stroke: (paint: orange, dash: "dashed", thickness: 0.6pt))
  rect(q((x0 - 0.25, 1.0)), q((x0 + 0.25, 2.8)), fill: rgb("#fde4c8"), stroke: 0.6pt + orange); T((x0 + 0.65, 1.9), [throat 0.5 × 0.20\ under the maid bath\ (no cover)], size: 3.2pt, fill: orange, anchor: "west")
  rect(q((x0 - 0.45, 2.8)), q((x0 + 0.45, y1)), fill: rgb("#fde4c8"), stroke: 0.6pt + orange)
  for k in range(air-covers) { let ya = 2.9 + k * 0.82; if k >= 5 { ya = 7.1 + (k - 5) * 0.82 }; rect(q((x0 - 0.45, ya)), q((x0 + 0.45, ya + 0.8)), fill: white, stroke: 0.4pt + orange) }
  T((x0 + 0.65, 4.9), [channel 0.9 × 0.20 in the slab\ 5 covers in the laundry walkway], size: 3.2pt, fill: orange, anchor: "west"); T((x0 + 0.65, 8.3), [3 covers in the kitchen walkway\ (between the counters)], size: 3.2pt, fill: orange, anchor: "west")
  rect(q((air-chamber.at(0), air-chamber.at(1))), q((air-chamber.at(2), air-chamber.at(3))), fill: rgb("#fbd3a8"), stroke: 0.6pt + orange); T((9.37, 11.35), [plenum under\ the sink counter], size: 3.2pt, fill: orange)
  line(q((air-grille-x - 0.1, air-grille.at(0))), q((air-grille-x - 0.1, air-grille.at(2))), stroke: 2.6pt + orange); T((8.3, 10.5), [grille under the TV\ #f2(air-grille.at(1)) … #f2(air-grille.at(3))], size: 3.4pt, fill: orange, anchor: "east")
  rect(q((5.925, 8.7)), q((8.85, 12.3)), fill: none, stroke: (paint: luma(120), dash: "dotted", thickness: 0.5pt)); T((7.4, 12.6), [seating −0.15], size: 3.4pt, fill: luma(110))
  rect(q((9.05, 7.5)), q((9.65, 12.9)), fill: none, stroke: (paint: luma(140), thickness: 0.4pt)); T((9.35, 8.2), [sink\ counter], size: 3pt, fill: luma(110))
  line(q((8.95, 7.3)), q((8.95, 8.9)), stroke: 2pt + blue); T((8.3, 8.1), [sink window\ (moved north)], size: 3.2pt, fill: blue, anchor: "east")
  line(q((x0, 1.0)), q((x0, y1)), q((air-route.at(2).at(0), y1)), stroke: (paint: red, thickness: 0.9pt), mark: (end: "stealth", fill: red, scale: 0.5))
  T((10.75, 6.3), [the walls y 2.8 and y 7.0 cross the channel on their ground beams:\ a 0.9 × 0.2 slot in the wall foot above the beam top (−0.28)], size: 3.2pt, fill: luma(90), anchor: "west")
  T((8.6, -0.5), [plan at the ground floor · the breeze path · 1 m = 0.62 cm · north up], size: 4pt, fill: green)
})
#let path-section(length: 0.62cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, t, size: 4.2pt, fill: ink, anchor: "center", angle: 0deg) = content(p, anchor: anchor, angle: angle, text(size, fill: fill, t))
  let vx = 2.5
  let Z(z) = z * vx
  let Y(y) = y - 0.0
  // ground slab top −0.08 and underside −0.28, the floor finish to 0, the walls crossed (y 1.0 tower south wall, 2.8, 7.0) and the kitchen west wall at the end
  rect((Y(0.0), Z(-0.28)), (Y(11.6), Z(-0.08)), fill: luma(150), stroke: none); rect((Y(0.0), Z(-0.08)), (Y(11.6), Z(0)), fill: luma(205), stroke: none)
  rect((Y(0.0), Z(-0.9)), (Y(1.0), Z(0)), fill: luma(225), stroke: none)
  // the channel (clear) and its base slab
  rect((Y(1.0), Z(-0.28)), (Y(10.5), Z(-0.08)), fill: rgb("#fde4c8"), stroke: 0.5pt + orange); rect((Y(1.0), Z(-0.38)), (Y(10.5), Z(-0.28)), fill: luma(120), stroke: none)
  rect((Y(1.0), Z(-0.28)), (Y(2.8), Z(-0.08)), fill: rgb("#f6c99a"), stroke: 0.5pt + orange); T((Y(1.9), Z(-0.18)), [throat 0.5 wide], size: 3pt)
  // the covers (flush) and the fixed section
  for k in range(air-covers) { let ya = 2.9 + k * 0.82; if k >= 5 { ya = 7.1 + (k - 5) * 0.82 }; rect((Y(ya), Z(-0.08)), (Y(ya + 0.8), Z(0)), fill: white, stroke: 0.5pt + orange) }
  T((Y(4.9), Z(0.25)), [removable gasketed covers, flush with the floor · lifted while standing], size: 3.4pt, fill: orange)
  // the walls crossed: ground beams (assumed 0.3 × 0.6 under the walls, top −0.28) and the slots
  for (y, l) in ((1.0, [tower S wall]), (2.8, [maid bath / laundry]), (7.0, [laundry / kitchen])) { rect((Y(y - 0.15), Z(-0.88)), (Y(y + 0.15), Z(-0.28)), fill: luma(120), stroke: none); rect((Y(y - 0.125), Z(0)), (Y(y + 0.125), Z(1.0)), fill: luma(170), stroke: none); T((Y(y), Z(1.15)), l, size: 3.2pt) ; T((Y(y), Z(-0.6)), [ground beam (A3)\ top −0.28: not notched], size: 2.8pt, fill: white) }
  // the tower base: the shaft above, the sump
  rect((Y(0.1), Z(-0.40)), (Y(0.9), Z(-0.08)), fill: sky, stroke: 0.5pt + blue); T((Y(0.5), Z(-0.24)), [sump\ −0.40], size: 3pt)
  rect((Y(0.1), Z(0)), (Y(0.9), Z(1.4)), fill: sky.transparentize(60%), stroke: none); T((Y(0.5), Z(0.7)), [breeze shaft\ ↓], size: 3.4pt, fill: blue)
  circle((Y(0.5), Z(-0.40)), radius: 0.08, fill: white, stroke: 0.5pt + blue); T((Y(0.5), Z(-0.55)), [drain · dry trap], size: 3pt, fill: blue)
  // the plenum and the grille at the end
  rect((Y(10.5), Z(-0.28)), (Y(11.15), Z(0.45)), fill: rgb("#fbd3a8"), stroke: 0.5pt + orange); T((Y(10.8), Z(0.6)), [plenum (west leg, beyond)], size: 3pt, fill: orange)
  rect((Y(11.15), Z(air-grille.at(1))), (Y(11.3), Z(air-grille.at(3))), fill: orange, stroke: none); T((Y(11.45), Z(0.25)), [grille\ courtyard], size: 3pt, fill: orange, anchor: "west")
  // levels
  for (z, l) in ((0, [±0.00 floor]), (-0.08, [−0.08 slab top = the covers]), (-0.28, [−0.28 slab underside = the channel floor (−0.32 at the tower)]), (-0.40, [−0.40 sump])) { T((Y(-0.2), Z(z)), l, size: 3.2pt, fill: gray, anchor: "east") }
  T((Y(5.8), Z(-1.1)), [long section along the channel (x 10.2), looking east, heights × #vx · 1 m = 0.62 cm · the channel never leaves the slab depth], size: 4pt, fill: green)
})
#grid(columns: (auto, 1fr), gutter: 10pt, path-plan(),
  [
    #path-section()
    #v(3pt)
    #set text(6.9pt)
    - *Route:* from the breeze shaft's foot (the tower's south wall, y 1.0) *straight south on x #r2(air-route.at(0).at(0))* under the maid bath (y 1.0–2.8), the laundry walkway (2.8–7.0) and the kitchen walkway between the counters (7.0–10.5), then *one 90° bend west* under the sink counter (y 10.0–11.0) into the plenum in the wall base and the grille: axis #r2(air-length) m, one bend. The slot through each of the three walls (y 1.0, 2.8, 7.0) is 0.9 × 0.20 in the wall foot *above the ground beam's top (−0.28)*: no beam, footing or floor is cut or lowered.
    - *Size and levels:* clear #r2(air-clear.at(0)) × #r2(air-clear.at(1)) m (#r2(air-clear.at(0) * air-clear.at(1)) m²) from the slab top (−0.08, the covers flush with the finished floor) to the slab underside (−0.28), its own base slab 0.10 below; under the maid bath a *throat #r2(air-throat.at(0)) × #r2(air-throat.at(1))* between the shower and the WC (the WC moved to the cut-wall corner, `studies/east_wing.typ`): #r2(air-throat.at(0) * air-throat.at(1)) m², the controlling section. The floor falls #str(calc.round(air-fall * 100, digits: 1)) % back to the tower's *sump* (−0.40, a Ø75 drain with a waterless dry trap against odours, to the east yard): rain that passes the louvres and any condensation leave at the tower, never towards the courtyard.
    - *Access without entry:* #air-covers removable sealed covers (0.9 × 0.8, stainless trays stone-faced like the floor, gasketed against wash-water and insects, lifted with two suction cups) in the laundry and kitchen walkways; the throat section (1.8 m) and the sump are reached with a flat brush and a vacuum rod from the first cover and from the shaft's foot; the plenum and the west leg (0.65 m) from the courtyard with the grille removed. The channel's surfaces smooth (a sealed epoxy render), the corners coved.
    - *Outlet:* the decorative grille under the TV, #r2(air-grille.at(2) - air-grille.at(0)) × #r2(air-grille.at(3) - air-grille.at(1)) m at #f2(air-grille.at(1)) … #f2(air-grille.at(3)) (#r2(air-grille.at(1) + 0.15) above the seating floor), with a *manually adjustable louvre* that directs the air along the floor to the benches, clear of the cushions (no bench on the east side) and #r2(air-grille.at(0) - 8.4) m from the fountain enclosure's splash; the grille lifts off for cleaning.
  ],
)

// ====================================================================================== PAGE 3 · the breeze estimate, the house ventilation
#pagebreak()
#set text(6.85pt)
#text(12pt, weight: "bold", fill: green)[4 · The breeze, estimated honestly · 5 · The house ventilation (the sealed house)]
#v(2pt)
#grid(columns: (1fr, 1.15fr), gutter: 12pt,
  [
    #H[4 · What the courtyard will feel]
    The path's resistance, referred to the throat's velocity (#A[assumed loss coefficients, ASHRAE Fundamentals ch. 21 orders of magnitude]):
    #table(columns: (2.6fr, auto), inset: 2pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      [*Element*], [*ζ at the throat*],
      ..zeta-throat.map(((n, z)) => ([#n], [#r2(z)])).flatten(),
      [*Total*], [*#r2(zeta)*])
    Driving pressure: wind at the head ½ρv²·ΔCp with ρ #r2(rho) kg/m³ (Taif, 1 700 m) and ΔCp #r2(dCp) (windward face against the courtyard well, assumed); in still air the stack of an 8 m tower with 3 K difference: #r2(stack-dp) Pa.
    #table(columns: (1.4fr, auto, auto, auto, auto, 1.6fr), inset: 2pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      [*Wind at the head*], [*Δp*], [*flow*], [*grille*], [*felt at the benches*], [*What it is*],
      [weak, 3 m/s], [#r1(weak.dp) Pa], [#r2(weak.q) m³/s (#str(calc.round(weak.q * 3600)) m³/h)], [#r2(grille-v(weak.q)) m/s], [≈ #r2(felt(weak.q)) m/s], [barely perceptible: a faint stirring at the floor],
      [moderate, 6 m/s], [#r1(moderate.dp) Pa], [#r2(moderate.q) m³/s (#str(calc.round(moderate.q * 3600)) m³/h)], [#r2(grille-v(moderate.q)) m/s], [≈ #r2(felt(moderate.q)) m/s], [a gentle, pleasant breeze on the legs and hands],
      [still (stack only)], [#r2(still.dp) Pa], [#r2(still.q) m³/s], [#r2(grille-v(still.q)) m/s], [≈ #r2(felt(still.q)) m/s], [nothing felt],
    )
    - *Honest conclusion:* the breeze is perceptible only with a *moderate wind at the head* (≈ 5 m/s and more at 9 m above the ground); Taif's spring and summer afternoons often have it, calm evenings do not. In still weather the tower gives nothing the family will notice. The path is as short and open as the house allows (the throat under the maid bath halves what a 0.18 m² channel would pass); the head's screens are not the limit.
    - *Assist fan (owner decision, 1 Nov 2026):* a quiet *EC extract-type fan* in the breeze path, pulling the air down from the tower to the grille: a flat fan box (two Ø250 EC axial fans at low speed, ≈ #r2(fan.box.at(0)) × #r2(fan.box.at(1)) × #r2(fan.box.at(2))) in the *plenum directly behind the grille*, #r2(fan.q.at(0))–#r2(fan.q.at(1)) m³/s, ≤ #str(fan.dba) dB(A) at the benches, #str(fan.w.at(0))–#str(fan.w.at(1)) W, on its *own switch* beside the seating (separate from the damper switch; the fan runs only with the damper open: an interlock): it gives the moderate-wind breeze on any evening. *Service without any confined space:* the grille lifts off and the box slides out through the grille opening (1.0 × 0.35) into the courtyard. #A[The MEP engineer sizes it and its sound.] Wind data for Taif (the airport station) to be checked; the figures above are a concept estimate, not a design.
  ],
  [
    #H[5 · The house's ventilation]
    - *One unit* for the whole house in the *tower's base* on the roof (§ 2; `studies/roof.typ` Z2a): y 1.0–3.4 on the tower's lines, ≈ #r2(area(base-clear)) m² inside, #r2(base-clear-h) m clear, the unit right behind the base's west doors with its front at the doors (filters and the core pulled out from the roof terrace). *Unit (assumed):* #unit.note: #str(unit.flow) m³/h class, ≈ #r2(unit.size.at(0)) × #r2(unit.size.at(1)) × #r2(unit.size.at(2)) m, ≈ #str(unit.weight) kg, #str(unit.power.at(0)) W at the normal rate and ≈ #str(unit.power.at(1)) W at boost. #A[Footprint, weight and power per the chosen unit.]
    - *ERV or HRV:* Taif is dry and high (summer 30–35 °C by day with low humidity, winter nights near 5 °C). Moisture recovery gives little here: in summer the outdoor air is dry anyway, in winter it only slows the drying of the indoor air. A *sensible-only HRV* (or a unit whose enthalpy core can be swapped for a sensible one) is the better fit: simpler core, no condensate in summer, the winter heat recovery is what matters. #A[The MEP engineer decides with the unit's data.]
    - *Preliminary airflow* (ASHRAE 62.2-2022 §4.1.1: 0.15 L/s·m² of floor + 3.5 L/s per bedroom + 1): conditioned floor ≈ #str(calc.round(cond-clear)) m² clear (#str(calc.round(conditioned)) m² on axes), #bedrooms bedrooms → *#str(calc.round(q-normal)) L/s = #str(calc.round(q-normal * 3.6)) m³/h* continuous. *Guest gatherings:* #guests men in the majlis (#str(calc.round(majlis)) m²) at the ASHRAE 62.1 assembly rate (3.8 L/s·person + 0.3 L/s·m²) add #str(calc.round(q-majlis)) L/s → *boost #str(calc.round(q-boost)) L/s = #str(calc.round(q-boost * 3.6)) m³/h*. The unit above covers it #if unit.flow >= q-boost * 3.6 [✓] else [✗]. #A[Rates to be confirmed against SBC 501 / 1101 and the owner's occupancy.]
    - *Intake and exhaust:* the intake from the tower's service compartment (north face at the head); the exhaust on the base's *cut (north-east) face*, low, blowing east over the lane side. *The AC condensers stay SOUTH of the tower* (owner; zone Z2b from y 5.6): #r2(ac-clear) m clear of the base's south wall and #r2(condensers.at(1) - intake.at(1)) m south of the intake louvre in plan, the intake 1 m higher than the units and facing north: the tower never takes their hot air. Distances below.
    - *Filters:* a coarse pre-filter (ISO Coarse 60 %) in the tower compartment and *one fine filter* at the unit's supply, *provisionally ISO ePM1 ≥ 50 %* (#A[to confirm with the equipment]); a differential-pressure switch or the unit's own filter timer as the service indicator, shown at the plant room door and on the panel.
    - *Supply and extract:* supply to every bedroom (1–3, the kids' room, the suite), the living, the family living, the office and the men's majlis (with the boost); extract from every bathroom and WC (the family bath, bath 3, the suite bath and WC, the family WC, the guest WC, the maid bath) and the laundry; transfer air from the rooms to the extract points through *door undercuts of 15–20 mm* or transfer grilles over the bathroom doors, so the system works with the bedroom doors closed.
    - *The kitchen hood stays separate:* #str(hood) m³/h out through the east wall; *make-up air* through a filtered, motorised inlet (≈ 300 × 300); *proposed position (the owner wants it discreet):* on the kitchen's east wall at y 12.2–12.5, just under the first-floor stone band (+3.0 … +3.3, in the band's shadow line, a louvre painted the wall colour; inside, the fridge and tall storage stand below it), ducted in the ceiling zone to a diffuser 1.5 m from the hood; interlocked with the hood, so the heavy daily cooking never depressurises the sealed house (a 0.9 m³/h gap would otherwise pull dust through every crack). #A[The MEP engineer sizes it.]
  ],
)
#v(3pt)
#grid(columns: (1fr, 1fr), gutter: 12pt,
  [
    #H[Intake / exhaust separations (from the plan; the basis in the last column)]
    #table(columns: (2fr, auto, auto, 2.6fr), inset: 2pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      [*Pair*], [*distance*], [*allowance*], [*basis*],
      ..sep.map(((l, d, need, b)) => ([#l], [#r1(d) m], [#r1(need) m], text(6.2pt, b))).flatten())
    #text(6.2pt, fill: gray)[ASHRAE 62.1-2022 §5.5.1 and Table 5-1 (the 3 m / 4.6 m / 9 m figures are the IFC-era "starting allowances" the SBC 501 follows, #A[not verified]); the gas cabinet and the generator point are site-plan proposals and may move; proposal: keep the condenser zone south of y 5.6 so the intake stays upwind of their plumes in the north-west wind.]
  ],
  [
    #H[Ducts and ceiling heights]
    - *Vertical route:* from the plant room through the duct box into the tower's service compartment: two Ø250 risers (supply, extract) down to the first-floor ceiling zone (+6.85) through the tower's south wall into bedroom 1's ceiling and on to the gallery, and to the ground-floor zone (+3.0 … +3.3) into the maid bath / laundry ceiling and on to the kitchen, the dining, the riwaq and the two majlises. Flat ovals 100 × 300 where the zone is thin, Ø160 branches, acoustic attenuators at the plant room. #A[Sizes assumed.]
    #table(columns: (2.6fr, auto, auto, auto), inset: 2pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      [*Zone*], [*soffit*], [*duct*], [*ceiling*],
      ..ceilings.map(((n, s, d, c)) => (text(6.4pt, n), [#f2(s)], [#if d > 0 [#r2(d)] else [—]], [*#f2(c)*])).flatten())
    - *Finished clear heights:* ≥ +3.07 in the ground-floor rooms, +2.90 only in the 0.3 m band under B5 at the dining's west edge (the living has no ceiling); the first floor ≥ +6.75 (3.15 m clear). *No room gets too low*; the lowest band is at the ceiling step the living already has.
  ],
)

// ====================================================================================== PAGE 4 · controls, maintenance, decisions
#pagebreak()
#text(12pt, weight: "bold", fill: green)[6 · Controls · 7 · Maintenance (no routine task enters a shaft, pit or buried space) · 8 · Decisions and engineering checks still open]
#v(2pt)
#grid(columns: (1fr, 1.3fr), gutter: 12pt,
  [
    #H[6 · Controls]
    - *Continuous quiet running* at the normal rate (#str(calc.round(q-normal * 3.6)) m³/h), *boost* (#str(calc.round(q-boost * 3.6))) from the kitchen and bathroom switches (timed) and a "guests" button in the hospitality kitchen for the majlis evenings; the fan speeds set at commissioning.
    - *The courtyard damper is independent:* its own switch by the seating; spring-return, so it *closes on power loss* and when the switch is off; the *assist fan on its own switch* beside it (interlocked: it runs only with the damper open).
    - *Dust-event mode* (a switch at the family entrance or a weather-station input): the unit drops to its *minimum balanced* rate (supply = extract) so the house is never depressurised, the kitchen hood's make-up inlet stays interlocked, the courtyard damper closes; the unit is *not* assumed to recirculate: indoor air cleaning during a storm is *separate equipment* (portable HEPA units in the bedrooms and the living, a proposal).
    - *Power failure:* the unit stops, the damper springs shut, the sealed house stays sealed; the alarms keep running on their batteries (`studies/fire_escape.typ`); on restoration the unit restarts at its last setting. The unit may sit on the essentials circuit if the electrical designer agrees (≈ 100–350 W).
    - *Indicators:* the filter-service light at the plant room door and on the panel; the damper "open" light at the seating switch.
    #v(2pt)
    #H[8 · Decisions (owner) and engineering checks still open]
    - *Owner (decided 1 Nov 2026):* the assist fan yes; bird mesh only; the HRV in the tower's base (one mass, nothing else above the attic); the condensers south of the tower; the make-up inlet discreet (position proposed above). *Still open:* the fan's sound in practice (hear a demonstration unit); the base's doors on the roof terrace (their look).
    - *MEP engineer:* every rate, size and pressure drop above; the flaps and the damper; the HRV / ERV choice and the unit; the duct sizes and the attenuators; the make-up air; the sump drain and its trap; the controls; the Taif wind data for the breeze.
    - *Structural engineer:* the channel in the slab (0.9 × 0.2 within the slab depth, its base slab, the three wall slots above the ground beams), the tower's partition and the roof penetrations, the base's walls on the roof slab and the unit's load (`studies/structure.typ` X19).
    - *3D and other files:* `3d/build_3d.py` / `check_3d.py` still build and check the v2 pit, chamber and duct: to be rewritten for v3 at the next 3D build (`docs/PENDING_CHANGES.md`).
  ],
  [
    #H[7 · Maintenance (initial intervals; adjust to the manufacturer and the dust)]
    #table(columns: (1.3fr, 2fr, 1.4fr, auto, 2fr), inset: 2pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      [*Component*], [*Task*], [*Reached from*], [*Interval*], [*If neglected*],
      [Head louvres and bird mesh (4 faces)], [brush / vacuum the dust; check the mesh], [the roof strip beside the tower, hinged frames, a 2 m step ladder], [6 months; after a dust storm (no fine mesh: little to clog)], [the breeze drops; birds enter the shaft],
      [Back-draught flaps (4)], [check they swing free, clean the seats], [the roof hatch in the tower's south face, by hand], [12 months], [a leeward quarter stays open: the head short-circuits, no breeze],
      [Courtyard damper and its actuator], [cycle it, check the spring return and the switch], [the roof hatch, a hinged panel], [12 months], [the damper sticks open (dust and cold air into the courtyard) or closed],
      [ERV pre-filter (tower compartment)], [slide out, replace], [the roof hatch, a second panel], [3 months], [the unit's fine filter clogs early; less fresh air],
      [Unit filters (tower base)], [replace the fine supply filter and the extract filter], [the roof terrace: the base's doors, no entry], [3–6 months (the indicator)], [less air, more fan power, dust bypass],
      [Heat-recovery core], [pull, wash, dry], [the roof terrace: through the base's doors], [12 months], [lost recovery, odours],
      [Exhaust louvre and the make-up air inlet], [clean the mesh; test the motorised inlet with the hood], [the roof (the base's cut face) / the kitchen wall], [6 months], [the hood depressurises the house; dust in],
      [Channel covers and channel], [lift the trays, vacuum the channel, check the gaskets], [the laundry and kitchen walkways, standing], [6 months; after a storm], [dust blown into the courtyard; wash-water into the channel],
      [Throat section and sump], [brush with a rod; check the dry trap, pour water once a year], [the first laundry cover and the shaft's foot (no entry)], [6 months], [odours from the drain; a blocked sump],
      [Plenum and grille], [lift off the grille, vacuum the plenum, set the louvre], [the courtyard], [1 month (dust)], [dust on the seating; a blocked grille],
      [Assist fan box (behind the grille)], [vacuum the blades, check the bearings and the damper interlock], [the courtyard: lift the grille, slide the box out], [12 months], [noise; less breeze],
      [Supply and extract grilles in the rooms], [vacuum], [the rooms, a step ladder], [6 months], [noise, less air],
    )
    #text(6.2pt, fill: gray)[Every task is done from the roof terrace, a room's floor or the courtyard. Nothing requires entering the tower, the channel or any pit: the sump is 0.32 m deep and reached by hand and rod.]
  ],
)

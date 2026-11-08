// air_system.typ · Taif / Palm House V7.1 · AIR SYSTEM · FINAL CONCEPT (v3, owner goals 1 Nov 2026; design review E-01)
// ONE tower, the symbol of the house, with TWO completely separate air paths: (a) a gentle natural breeze for the courtyard seating in pleasant
// weather, (b) the fresh-air intake of the house's ventilation unit, all year. Low maintenance. NO water in the air system, no evaporative pads,
// no buried earth pipes, no human entry anywhere (no pit, no walk-in tunnel, no chamber with entry: v1 and v2 withdrawn).
// v3.1 (owner decisions on the open items, 1 Nov 2026): the assist fan YES (in the plenum behind the grille, its own switch); bird mesh only on the breeze path;
// the HRV in a BASE under the tower (v3.1) · V9.3 (owner, studies/malqaf_tower.typ): the slim shaft along the cut wall, the malqaf tower (head (c), 3.5 m above the attic) on the attic's corner, the HRV in a plant room behind the attic, the channel at its full width (no throat).
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
#let air-tower = ((9.551, 0), (10.461, 0), (11.303, 1.551), (10.601, 1.933))   // V9.3: the slim shaft along the cut wall on the wall centre lines (design_gf.typ tower-pts): the cut wall, the new 200 mm wall parallel to it, the square end wall; the tip a solid corner pier
#let air-head = (7.3, 12.18)            // V9.3: the malqaf tower from the roof finish to its crown, 3.5 m above the attic coping (+8.68): the one element above the attic (studies/roof.typ)
#let air-head-opening = (10.35, 11.73)   // V9.3: the head's slender openings (sill, top of their semicircular heads), on all FOUR faces
#let air-base = (-0.08, -0.40)          // the breeze shaft's base: from the ground slab top to its shallow sump floor (a drain with a dry trap; NO pit, no entry)
#let air-route = ((10.674, 1.25), (10.2, 2.35), (10.2, 10.5), (9.2, 10.5))   // V9.3: from the breeze shaft's foot (in the slim shaft) south-west under the maid bath, then straight south on x 10.2 under the laundry and the kitchen walkway, then west under the sink counter to the plenum
#let air-duct = (0.9, -0.08, -0.28)     // the channel: 0.9 wide, from the ground-slab top (the covers flush with the floor) to the slab underside: inside the slab depth, no beam or footing notched
#let air-clear = (0.9, 0.20)            // clear width × clear depth of the channel (0.18 m²); V9.3: the FULL width under the maid bath too (no throat: its WC and shower drains stay off the line)
#let air-fall = 0.005                   // the channel floor falls 0.5 % back to the tower's sump
#let air-invert = (-0.28, -0.32)        // the channel floor at the plenum end and at the tower end
#let air-chamber = (9.05, 10.0, 9.7, 11.0)   // v3: the fixed plenum box under the sink counter, 0.65 × 1.0, from the channel to the wall-base plenum; cleaned from the grille side (no entry)
#let air-cover = (9.7, 2.9, 10.6, 3.7)  // the first of the removable sealed covers in the laundry floor (0.9 × 0.8 each, gasketed, flush)
#let air-grille-x = 8.95                // the wall the grille is in: the courtyard's east wall = the kitchen's west wall; the grille on its courtyard face (x 8.85)
#let air-grille = (10.05, 0.10, 11.05, 0.45)   // the outlet grille (y0, z0, y1, z1): 1.0 × 0.35 below the outdoor TV (3 Nov 2026: the TV at y 9.82–11.28, +0.60 … +1.46; the courtyard floor LEVEL), its bottom 0.10 above the floor, a manually adjustable louvre directing the air along the floor, removable
#let air-fan = (9.05, 10.1, 9.65, 10.9, -0.05, 0.30)   // v3.1 (owner): the assist fan box in the plenum directly behind the grille (x0, y0, x1, y1, z0, z1), slid out through the grille opening for service
#let air-sunken = (0.0, 5.925, 7.1, 8.85, 12.3)   // 3 Nov 2026: the seating zone on the LEVEL courtyard floor (studies/courtyard_layout.typ; no step): floor level, x0, y0, x1, y1
#let air-length = plen(air-route)       // the channel axis length, tower wall → plenum
#let air-throat = (0.9, 0.20)           // V9.3: no throat (was 0.5 × 0.20 between the shower and the WC)
#let a-ref = 0.10                       // the loss coefficients' reference section (the former throat, kept so the figures compare with V9.2)
#let air-covers = 8                     // five in the laundry (y 2.9–6.9), three in the kitchen walkway (y 7.1–9.5)
// the shaft's clear section and its split (V9.3): a slim rectangle along the cut wall, s along the cut from B2 (its centre line), t inwards
#let cut-L = calc.sqrt(2.85 * 2.85 + 5.245 * 5.245)
#let Pc(s, t) = (10.461 + 2.85 / cut-L * s - 5.245 / cut-L * t, 5.245 / cut-L * s + 2.85 / cut-L * t)
#let sh = (s0: 0.10, s1: 1.665, t0: 0.125, t1: 0.70, part: 0.626)   // clear s 0.10–1.665 (1.565 long) × t 0.125–0.70 (0.575 deep); the partition s 0.626–0.726
#let tower-clear = (Pc(sh.s0, sh.t0), Pc(sh.s1, sh.t0), Pc(sh.s1, sh.t1), Pc(sh.s0, sh.t1))
#let tower-area = area(tower-clear)
#let split-wall = 0.10                  // the airtight partition (block or a sealed steel sheet on a frame), square to the cut
#let breeze-area = (sh.s1 - sh.part - split-wall) * (sh.t1 - sh.t0)
#let service-area = (sh.part - sh.s0) * (sh.t1 - sh.t0)
#let sh-breeze = (Pc(sh.part + split-wall, sh.t0), Pc(sh.s1, sh.t0), Pc(sh.s1, sh.t1), Pc(sh.part + split-wall, sh.t1))
#let sh-service = (Pc(sh.s0, sh.t0), Pc(sh.part, sh.t0), Pc(sh.part, sh.t1), Pc(sh.s0, sh.t1))
// the malqaf tower above the roof (V9.3: head (c) at 3.5 m, the flat Hijazi cornice; studies/malqaf_tower.typ) · read by 3d/build_3d.py
#let air-tw = (8.95, 0.875, 1.25, 0.15)          // x0, y0, the side, the walls: a 1.25 m square on the attic's corner (1.0 m behind the north facade, 0.77 m behind the cut facade)
#let air-tw-z = (10.08, 10.20, 11.88, 12.18)    // the plain shaft to the band, the band, the head to the crowning cornice, the crown's top
#let air-tw-slots = (4, 0.14, 0.09, 0.15)       // per face: slots, their width, the ribs, the head's margin (each slot with a small semicircular top)
#let air-plenum = ((9.40, 0.95), (10.15, 0.88), (10.62, 0.60), (11.15, 1.55), (10.65, 1.90), (10.10, 2.05), (9.40, 2.05))   // the low plenum behind the coping: the shaft's top → the tower's foot
#let air-plenum-top = 7.65
#let air-plant = (8.7, 2.9, 10.3, 4.3)          // the HRV plant room behind the attic (outside), its doors on the south face
#let air-plant-top = 8.60
#let head-faces = 4
#let slot-free = air-tw-slots.at(0) * (air-tw-slots.at(1) * (air-head-opening.at(1) - air-head-opening.at(0) - air-tw-slots.at(1) / 2) + calc.pi * calc.pow(air-tw-slots.at(1) / 2, 2) / 2)   // one face's slots
#let head-opening-area = head-faces * slot-free   // V9.3: 4 faces × 4 slots
#let louvre-free = 1.0                   // V9.3: no louvres: the slender slots are the openings, the bird mesh behind them
#let screen-free = 0.9                  // a wide 20 mm bird mesh only (owner, 1 Nov 2026): ≈ 90 % open; no insect mesh on the breeze path (more breeze, less cleaning)
// the plant room (studies/roof.typ zone Z2a, V9.3) and the roof points for the intake / exhaust distances
#let base = ((air-plant.at(0), air-plant.at(1)), (air-plant.at(2), air-plant.at(1)), (air-plant.at(2), air-plant.at(3)), (air-plant.at(0), air-plant.at(3)))   // V9.3: the HRV plant room behind the attic (was the wide base under the tower)
#let base-top = air-plant-top           // below the attic coping (+8.68): never seen
#let base-slab = 0.12
#let base-clear-h = base-top - base-slab - 7.30   // 1.18 m from the roof finish to its slab underside: a low service compartment, not a room
#let base-clear = ((air-plant.at(0) + 0.1, air-plant.at(1) + 0.1), (air-plant.at(2) - 0.1, air-plant.at(1) + 0.1), (air-plant.at(2) - 0.1, air-plant.at(3) - 0.1), (air-plant.at(0) + 0.1, air-plant.at(3) - 0.1))   // inside its 100 mm insulated walls
#let base-doors = (air-plant.at(0) + 0.2, air-plant.at(0) + 1.4, 1.0)   // V9.3: a pair of doors on its south face (x0, x1, height): the unit's front at them
#let fan = (q: (0.15, 0.25), dba: 30, w: (40, 60), box: (0.9, 0.3, 0.3))   // the assist fan (owner): two Ø250 EC axial fans at low speed in a flat box, ASSUMED
#let intake = (8.95, 1.5, 9.83)         // V9.3: the ERV intake louvre on the tower's west face just below the band (x, y, z)
#let exhaust = (11.8, 4.5, 7.7)         // V9.3: the exhaust grille low in the attic's cut wall, blowing east over the lane side, hidden behind the coping
#let hood-out = (13.311, 10.7, 2.2)     // the kitchen hood outlet through the east wall
#let vent-stack = (13.2, 8.4, 8.0)      // the east-wall plumbing vent stack, terminating above the roof
#let gas-cab = (13.7, 8.6, 0.0)         // the LPG cabinet in the east service yard (site plan)
#let generator = (14.5, 12.0, 0.0)      // the generator point (site plan, proposal)
#let condensers = (9.6, 5.6, 12.4, 9.0) // the AC outdoor units' zone Z2b (studies/roof.typ): SOUTH of the tower and the plant room (owner)
#let ac-clear = condensers.at(1) - base.at(2).at(1)   // V9.3: the clear distance from the plant room's south face to the condenser zone (service)
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
  ("the head: " + str(air-tw-slots.at(0)) + " slots per face, bird mesh (4 faces, " + str(calc.round(head-opening-area, digits: 2)) + " m² free)", 3.0 * calc.pow(a-ref / (head-opening-area * louvre-free * screen-free), 2)),
  ("back-draught flaps and the shaft (" + str(calc.round(breeze-area, digits: 2)) + " m²)", 1.0 * calc.pow(a-ref / breeze-area, 2)),
  ("damper, open (in the tower's foot)", 0.5 * calc.pow(a-ref / breeze-area, 2)),
  ("the plenum's two bends at the roof (0.60 m²)", 1.2 * calc.pow(a-ref / 0.60, 2)),
  ("the turn from the shaft's foot into the channel", 0.5 * calc.pow(a-ref / 0.18, 2)),
  ("channel friction, " + str(calc.round(air-length, digits: 1)) + " m, 0.18 m² (full width, no throat)", 0.02 * air-length / 0.33 * calc.pow(a-ref / 0.18, 2)),
  ("the bend and the plenum", 0.8 * calc.pow(a-ref / 0.18, 2)),
  ("the grille (0.35 m², 50 % free)", 2.5 * calc.pow(a-ref / (0.35 * 0.5), 2)),
)
#let zeta-v92 = 2.8204                  // RECORD: the V9.2 chain (with the 0.10 m² throat under the maid bath), for the comparison
#let zeta = zeta-throat.map(z => z.at(1)).sum()
#let flow(v-wind) = { let dp = 0.5 * rho * v-wind * v-wind * dCp; let v = calc.sqrt(2 * dp / (rho * zeta)); (dp: dp, v: v, q: v * a-ref) }
#let gain-v92 = calc.sqrt(zeta-v92 / zeta)   // V9.3 the courtyard flow against V9.2's in the same wind
#let weak = flow(3.0)
#let moderate = flow(6.0)
#let grille-v(q) = q / (0.35 * 0.5)
#let felt(q) = grille-v(q) * 0.28       // a floor jet decays to ≈ 1/3–1/4 of the outlet speed 2 m away (assumed)
#let stack-dp = rho * 9.81 * 12.0 * 3 / 300   // V9.3: the head at ≈ +11, the grille at +0.3
#let still = { let v = calc.sqrt(2 * stack-dp / (rho * zeta)); (dp: stack-dp, v: v, q: v * a-ref) }
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
  ([the slim shaft (#r2(tower-area) m² clear, 0.575 deep along the cut wall) holds the breeze shaft (≥ 0.54 m²) and the HRV compartment (≥ 0.21 m², the two Ø250 risers) with the partition], breeze-area >= 0.535 and service-area >= 0.21 and calc.abs(tower-area - 0.90) < 0.02),
  ([the channel stays inside the ground-slab depth (no beam or footing notched): top −0.08, underside −0.28], calc.abs(air-duct.at(1) + 0.08) < 1e-6 and calc.abs(air-duct.at(2) + 0.28) < 1e-6),
  ([the channel has two bends, ≤ 11 m, and its full 0.90 × 0.20 section all along (no throat)], air-route.len() <= 4 and air-length <= 11.0 and air-throat.at(0) >= air-clear.at(0)),
  ([the grille is below the TV (+0.60) and ≥ 0.10 above the level courtyard floor], air-grille.at(3) <= 0.60 - 0.1 and air-grille.at(1) >= air-sunken.at(0) + 0.10 - 1e-9),
  ([every intake separation meets its allowance], sep.all(((l, d, need, b)) => d >= need)),
  ([the plant room's top (#f2(base-top)) stays below the attic coping (+8.68): never seen; its clear height takes the unit on its plinth with 0.3 m spare], base-top <= 8.68 - 1e-6 and base-clear-h >= unit.size.at(2) + 0.1 + 0.3),
  ([the condensers stay south of the plant room with ≥ 1 m clear (service) and ≥ 4 m from the intake in plan], ac-clear >= 1.0 and condensers.at(1) - intake.at(1) >= 4.0),
  ([no finished ceiling below +2.90 on the ground floor or +6.75 on the first floor], ceilings.all(((n, s, d, c)) => c >= 2.90)),
  ([the unit covers the guest boost (≥ #r1(q-boost * 3.6) m³/h)], unit.flow >= q-boost * 3.6),
)
#let all-ok = checks.all(c => c.at(1))

// ====================================================================================== PAGE 1 · the concept and the tower
#text(14pt, weight: "bold", fill: green)[Air system study v3 · one tower, two separate air paths · Taif / Palm House V7.1]
#v(1pt)
#text(8pt, fill: gray)[Owner goals 1 Nov 2026 (design review E-01) and the owner's decisions on the open items (v3.1: assist fan, bird mesh, the HRV base under the tower, the condensers south, the make-up inlet) · a gentle natural breeze for the courtyard seating in pleasant weather, and the fresh-air intake of the house's ventilation unit all year · no water in the air system, no pads, no earth pipes, no human entry · #A[every size and performance figure is ASSUMED, to be designed by the MEP engineer]; compiling this study is not engineering approval]
#v(3pt)
#let tower-plan(length: 2.0cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let q(p) = (p.at(0), -p.at(1))
  let T(p, t, size: 4.4pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, t))
  line(q((8.95, -0.125)), q((10.53, -0.125)), q((11.75, 2.12)), stroke: 2.2pt + luma(120))
  line(..air-tower.map(q), close: true, fill: luma(170), stroke: 0.6pt + ink)
  line(..sh-service.map(q), close: true, fill: rgb("#dfe8d0"), stroke: none); line(..sh-breeze.map(q), close: true, fill: sky.transparentize(40%), stroke: none)
  line(q(Pc(sh.part + 0.05, sh.t0)), q(Pc(sh.part + 0.05, sh.t1)), stroke: 2.4pt + ink)
  T(Pc((sh.part + 0.1 + sh.s1) / 2, 0.41), [breeze #r2(breeze-area) m²], size: 3.6pt, angle: -61.5deg); T(Pc((sh.s0 + sh.part) / 2, 0.41), [HRV #r2(service-area)], size: 3.2pt, angle: -61.5deg)
  line(q((air-tw.at(0), air-tw.at(1))), q((air-tw.at(0) + air-tw.at(2), air-tw.at(1))), q((air-tw.at(0) + air-tw.at(2), air-tw.at(1) + air-tw.at(2))), q((air-tw.at(0), air-tw.at(1) + air-tw.at(2))), close: true, stroke: (paint: blue, thickness: 0.7pt, dash: "dashed"))
  T((air-tw.at(0) + 0.62, air-tw.at(1) + 0.75), [the tower above\ the roof 1.25 × 1.25], size: 3.4pt, fill: blue)
  line(q(Pc(1.0, 0.9)), q(Pc(1.4, 0.9)), stroke: 2.6pt + red); T(Pc(1.2, 1.15), [panel 0.40], size: 3.2pt, fill: red)
  T((9.2, 0.45), [store / cupboard], size: 3.2pt)
  T((9.4, 2.15), [shaft plan (the floors) · the slim shaft along the cut wall · 1 m = 2.0 cm], size: 3.6pt, fill: green)
})
#grid(columns: (1fr, 1.35fr), gutter: 12pt,
  [
    #H[1 · The concept]
    - *One tower* (V9.3, owner): *a slim shaft hugging the cut wall* (#r2(area(air-tower)) m² on walls, *#r2(tower-area) m² clear*, 0.575 × 1.565 m, assumed) rising to *the malqaf tower* set back on the attic's corner, the symbol of the house: a 1.25 m square in honey stone, a plain shaft, a cornice band, a head of #air-tw-slots.at(0) slender openings per face each with a small semicircular top, a flat Hijazi crowning cornice, #r2(air-head.at(1) - 7.3) m above the roof finish (crown #f2(air-head.at(1)), 3.5 m above the attic coping); the one element above the attic (`studies/roof.typ`, `studies/malqaf_tower.typ`).
    - *Path (a), the courtyard breeze:* a four-sided head → a breeze shaft → a damper → a shallow channel in the ground slab → the grille under the outdoor TV: a gentle natural breeze for the seating in pleasant weather; not cooling (if it is too hot the family does not sit there); no water, no pads, no earth pipe; a quiet *assist fan* in the plenum behind the grille, on its own switch (owner, 1 Nov 2026; § 4).
    - *Path (b), the house's fresh air:* an airtight intake compartment in the tower with its own louvre (the west face, just below the band) and an accessible pre-filter, feeding the ventilation unit in its *plant room behind the attic* (§ 2, never seen); the supply and extract risers to the ground floor run down the slim shaft's HRV compartment, the first floor is fed straight through the roof slab. The two paths are airtight from each other.
    - *Low maintenance, no entry:* every routine task is done from the roof (the bird-mesh frames lowered on cords to the *roof hatch* 0.50 m in the tower's south face behind the attic, the flaps, the top damper, the pre-filter), at the plant room's doors (the unit, the filters, the core), from the *access panel 0.40 × 0.40 at the shaft's foot in the maid bath* (the sump), from the laundry and kitchen floors (the channel's covers) or from the courtyard (the grille and the fan box). Nothing opens into bedroom 1; no shaft, pit or buried space is entered; the shaft is smooth-rendered inside (§ 7).
    #v(2pt)
    #tower-plan()
  ],
  [
    #H[2 · The tower]
    - *The slim shaft, #r2(tower-area) m² clear* (assumed, inside the walls): 0.575 m deep between the cut wall and one new 200 mm wall parallel to it, 1.565 m long, a square end wall, the tip a solid corner pier; split by an airtight partition (#r2(split-wall) m, square to the cut) into the *breeze shaft #r2(breeze-area) m²* (south part) and the *HRV compartment #r2(service-area) m²* (north part: the two Ø250 risers); the maid bath and bedroom 1 each get *one straight wall parallel to the cut* and a square return, the store and the cupboard north of the y 1.0 partition.
    - *Head (V9.3, head (c)), four faces, in the house's style:* #air-tw-slots.at(0) slender openings per face (#f2(air-head-opening.at(0)) … #f2(air-head-opening.at(1)), each #air-tw-slots.at(1) m wide with a small semicircular top, honey-stone ribs; #r2(head-opening-area) m² free in all). *The problem checked:* an undivided head open on four sides short-circuits (the wind enters windward and leaves leeward without reaching the courtyard). *The simplest arrangement that works:* the head only is divided into four quarters by a thin + divider; at the foot of each quarter a *lightweight back-draught flap* closes under the leeward suction and opens under the windward pressure, so only the windward quarter(s) feed the single shaft below. #A[Its sizing and the damping are the MEP engineer's.]
    - *No louvres; a bird mesh, cleanable from the roof:* the slender slots are the openings (rain falls to the shaft's sump); behind them a *wide 20 mm bird mesh only* (≈ #str(calc.round(screen-free * 100)) % free; no insect mesh on the breeze path: owner, 1 Nov 2026) in *frames lowered on cords* inside each quarter to the roof hatch and brushed / vacuumed there; no ladder on the tower, no entry.
    - *Damper:* a motorised blade damper across the breeze path at the tower's foot (just above the plenum, ≈ +7.9), a standard *spring-return HVAC actuator* (closes on power loss; ≈ 5 W holding, 24 V), on a wall switch beside the seating (by the TV) with an "open" light; reached from the *roof hatch 0.50 m in the tower's south face* (behind the attic, +7.6 … +8.1): no entry.
    - *ERV intake compartment:* a strip of the tower's section (#r2((air-tw.at(2) - 2 * air-tw.at(3)) * 0.28) m², the west side) from the head down to the roof, with its own louvre on the tower's west face just below the band (#f2(intake.at(2) - 0.2) … #f2(intake.at(2) + 0.2), a bird mesh) and a slide-in *pre-filter* (ISO Coarse 60 %) at its foot, pulled out through the roof hatch; the Ø315 intake duct leaves the tower's foot to the plant room (0.6 m, a low duct box on the roof behind the attic).
    - *The plant room (V9.3; the wide base under the tower removed):* behind the attic, x #air-plant.at(0)–#air-plant.at(2), y #air-plant.at(1)–#air-plant.at(3) (#r2(air-plant.at(2) - air-plant.at(0)) × #r2(air-plant.at(3) - air-plant.at(1)) m outside), its top #f2(base-top) below the attic coping (+8.68): *never seen*; inside ≈ #r2(area(base-clear)) m² and #r2(base-clear-h) m clear: a *low service compartment*, not a room (the unit on a 0.10 plinth, its front at a pair of doors on the south face, filters and the core pulled out on the roof walkway); the exhaust led along the attic to a low grille in its cut wall (#f2(exhaust.at(2))), #r1(d3(intake, exhaust)) m from the intake.
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
  T((x0 + 0.65, 1.9), [V9.3: the full 0.90 m width\ under the maid bath (no throat)], size: 3.2pt, fill: orange, anchor: "west")
  rect(q((x0 - 0.45, 2.8)), q((x0 + 0.45, y1)), fill: rgb("#fde4c8"), stroke: 0.6pt + orange)
  for k in range(air-covers) { let ya = 2.9 + k * 0.82; if k >= 5 { ya = 7.1 + (k - 5) * 0.82 }; rect(q((x0 - 0.45, ya)), q((x0 + 0.45, ya + 0.8)), fill: white, stroke: 0.4pt + orange) }
  T((x0 + 0.65, 4.9), [channel 0.9 × 0.20 in the slab\ 5 covers in the laundry walkway], size: 3.2pt, fill: orange, anchor: "west"); T((x0 + 0.65, 8.3), [3 covers in the kitchen walkway\ (between the counters)], size: 3.2pt, fill: orange, anchor: "west")
  rect(q((air-chamber.at(0), air-chamber.at(1))), q((air-chamber.at(2), air-chamber.at(3))), fill: rgb("#fbd3a8"), stroke: 0.6pt + orange); T((9.37, 11.35), [plenum under\ the sink counter], size: 3.2pt, fill: orange)
  line(q((air-grille-x - 0.1, air-grille.at(0))), q((air-grille-x - 0.1, air-grille.at(2))), stroke: 2.6pt + orange); T((8.3, 10.5), [grille under the TV\ #f2(air-grille.at(1)) … #f2(air-grille.at(3))], size: 3.4pt, fill: orange, anchor: "east")
  rect(q((air-sunken.at(1), air-sunken.at(2))), q((air-sunken.at(3), air-sunken.at(4))), fill: none, stroke: (paint: luma(120), dash: "dotted", thickness: 0.5pt)); T((7.4, 12.6), [seating zone (level, movable furniture)], size: 3.6pt, fill: luma(110))
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
  T((Y(1.9), Z(-0.18)), [full width (V9.3)], size: 3pt)
  // the covers (flush) and the fixed section
  for k in range(air-covers) { let ya = 2.9 + k * 0.82; if k >= 5 { ya = 7.1 + (k - 5) * 0.82 }; rect((Y(ya), Z(-0.08)), (Y(ya + 0.8), Z(0)), fill: white, stroke: 0.5pt + orange) }
  T((Y(4.9), Z(0.25)), [removable gasketed covers, flush with the floor · lifted while standing], size: 3.4pt, fill: orange)
  // the walls crossed: ground beams (assumed 0.3 × 0.6 under the walls, top −0.28) and the slots
  for (y, l) in ((1.25, [the shaft's wall]), (2.8, [maid bath / laundry]), (7.0, [laundry / kitchen])) { rect((Y(y - 0.15), Z(-0.88)), (Y(y + 0.15), Z(-0.28)), fill: luma(120), stroke: none); rect((Y(y - 0.125), Z(0)), (Y(y + 0.125), Z(1.0)), fill: luma(170), stroke: none); T((Y(y), Z(1.15)), l, size: 3.2pt) ; T((Y(y), Z(-0.6)), [ground beam (A3)\ top −0.28: not notched], size: 2.8pt, fill: white) }
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
    - *Size and levels:* clear #r2(air-clear.at(0)) × #r2(air-clear.at(1)) m (#r2(air-clear.at(0) * air-clear.at(1)) m²) from the slab top (−0.08, the covers flush with the finished floor) to the slab underside (−0.28), its own base slab 0.10 below; V9.3: *the full width under the maid bath too* (no throat; the bath's WC and shower drains stay off the line: the bathrooms interior study): #r2(air-throat.at(0) * air-throat.at(1)) m², the controlling section. The floor falls #str(calc.round(air-fall * 100, digits: 1)) % back to the tower's *sump* (−0.40, a Ø75 drain with a waterless dry trap against odours, to the east yard): rain that passes the louvres and any condensation leave at the tower, never towards the courtyard.
    - *Access without entry:* #air-covers removable sealed covers (0.9 × 0.8, stainless trays stone-faced like the floor, gasketed against wash-water and insects, lifted with two suction cups) in the laundry and kitchen walkways; the section under the maid bath and the sump are reached with a flat brush and a vacuum rod from the first cover and from the shaft's foot; the plenum and the west leg (0.65 m) from the courtyard with the grille removed. The channel's surfaces smooth (a sealed epoxy render), the corners coved.
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
    The path's resistance, referred to a 0.10 m² section (the V9.2 throat, so the figures compare; V9.3 the courtyard flow ≈ #r2(gain-v92) × V9.2's) (#A[assumed loss coefficients, ASHRAE Fundamentals ch. 21 orders of magnitude]):
    #table(columns: (2.6fr, auto), inset: 2pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      [*Element*], [*ζ (0.10 m²)*],
      ..zeta-throat.map(((n, z)) => ([#n], [#r2(z)])).flatten(),
      [*Total*], [*#r2(zeta)*])
    Driving pressure: wind at the head ½ρv²·ΔCp with ρ #r2(rho) kg/m³ (Taif, 1 700 m) and ΔCp #r2(dCp) (windward face against the courtyard well, assumed); in still air the stack of the 12 m path with 3 K difference: #r2(stack-dp) Pa.
    #table(columns: (1.4fr, auto, auto, auto, auto, 1.6fr), inset: 2pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      [*Wind at the head*], [*Δp*], [*flow*], [*grille*], [*felt at the benches*], [*What it is*],
      [weak, 3 m/s], [#r1(weak.dp) Pa], [#r2(weak.q) m³/s (#str(calc.round(weak.q * 3600)) m³/h)], [#r2(grille-v(weak.q)) m/s], [≈ #r2(felt(weak.q)) m/s], [barely perceptible: a faint stirring at the floor],
      [moderate, 6 m/s], [#r1(moderate.dp) Pa], [#r2(moderate.q) m³/s (#str(calc.round(moderate.q * 3600)) m³/h)], [#r2(grille-v(moderate.q)) m/s], [≈ #r2(felt(moderate.q)) m/s], [a gentle, pleasant breeze on the legs and hands],
      [still (stack only)], [#r2(still.dp) Pa], [#r2(still.q) m³/s], [#r2(grille-v(still.q)) m/s], [≈ #r2(felt(still.q)) m/s], [nothing felt],
    )
    - *Honest conclusion:* the breeze is perceptible only with a *moderate wind at the head* (≈ 5 m/s and more at 9 m above the ground); Taif's spring and summer afternoons often have it, calm evenings do not. In still weather the tower gives nothing the family will notice. The path is as short and open as the house allows (V9.3: the throat under the maid bath removed, the channel at its full width: ≈ #r2(gain-v92) × the V9.2 flow); the head's screens are not the limit.
    - *Assist fan (owner decision, 1 Nov 2026):* a quiet *EC extract-type fan* in the breeze path, pulling the air down from the tower to the grille: a flat fan box (two Ø250 EC axial fans at low speed, ≈ #r2(fan.box.at(0)) × #r2(fan.box.at(1)) × #r2(fan.box.at(2))) in the *plenum directly behind the grille*, #r2(fan.q.at(0))–#r2(fan.q.at(1)) m³/s, ≤ #str(fan.dba) dB(A) at the benches, #str(fan.w.at(0))–#str(fan.w.at(1)) W, on its *own switch* beside the seating (separate from the damper switch; the fan runs only with the damper open: an interlock): it gives the moderate-wind breeze on any evening. *Service without any confined space:* the grille lifts off and the box slides out through the grille opening (1.0 × 0.35) into the courtyard. #A[The MEP engineer sizes it and its sound.] Wind data for Taif (the airport station) to be checked; the figures above are a concept estimate, not a design.
  ],
  [
    #H[5 · The house's ventilation]
    - *One unit* for the whole house in the *plant room behind the attic* (§ 2; `studies/roof.typ` Z2a, V9.3): x #air-plant.at(0)–#air-plant.at(2), y #air-plant.at(1)–#air-plant.at(3), ≈ #r2(area(base-clear)) m² inside, #r2(base-clear-h) m clear, the unit right behind the south doors with its front at them (filters and the core pulled out on the roof walkway). *Unit (assumed):* #unit.note: #str(unit.flow) m³/h class, ≈ #r2(unit.size.at(0)) × #r2(unit.size.at(1)) × #r2(unit.size.at(2)) m, ≈ #str(unit.weight) kg, #str(unit.power.at(0))–#str(unit.power.at(1)) W.
    - *ERV or HRV:* Taif is dry and high (summer 30–35 °C by day with low humidity, winter nights near 5 °C). Moisture recovery gives little here: in summer the outdoor air is dry anyway, in winter it only slows the drying of the indoor air. A *sensible-only HRV* (or a unit whose enthalpy core can be swapped for a sensible one) is the better fit: simpler core, no condensate in summer, the winter heat recovery is what matters. #A[The MEP engineer decides with the unit's data.]
    - *Preliminary airflow* (ASHRAE 62.2-2022 §4.1.1: 0.15 L/s·m² of floor + 3.5 L/s per bedroom + 1): conditioned floor ≈ #str(calc.round(cond-clear)) m² clear (#str(calc.round(conditioned)) m² on axes), #bedrooms bedrooms → *#str(calc.round(q-normal)) L/s = #str(calc.round(q-normal * 3.6)) m³/h* continuous. *Guest gatherings:* #guests men in the majlis (#str(calc.round(majlis)) m²) at the ASHRAE 62.1 assembly rate (3.8 L/s·person + 0.3 L/s·m²) add #str(calc.round(q-majlis)) L/s → *boost #str(calc.round(q-boost)) L/s = #str(calc.round(q-boost * 3.6)) m³/h*. The unit above covers it #if unit.flow >= q-boost * 3.6 [✓] else [✗]. #A[Rates to be confirmed against SBC 501 / 1101 and the owner's occupancy.]
    - *Intake and exhaust:* the intake from the tower's intake compartment (its louvre on the west face below the band, #f2(intake.at(2))); the exhaust led from the plant room along the attic to a low grille in the attic's cut wall (#f2(exhaust.at(2))), blowing east over the lane side, hidden behind the coping. *The AC condensers stay SOUTH* (owner; zone Z2b from y 5.6): #r2(ac-clear) m clear of the plant room and #r2(condensers.at(1) - intake.at(1)) m south of the intake in plan, the intake ≈ 2 m higher than their tops.
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
    - *Vertical route (V9.3):* the first floor's supply and extract straight down from the plant room through the roof slab into the ceiling zone (+6.85) of bedroom 1 and the family part and on to the gallery; the ground floor's through the slim shaft's HRV compartment (two Ø250 risers) into the maid bath / laundry ceiling (+3.0 … +3.3) and on to the kitchen, the dining, the riwaq and the two majlises. Flat ducts in the ceiling zones (assumed); fire dampers where they cross the floor (MEP).
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
    - *Owner (decided 1 Nov 2026; V9.3 8 Nov 2026):* the assist fan yes; bird mesh only; the condensers south of the tower; the make-up inlet discreet (position proposed above); *V9.3: the malqaf tower at the north-east corner (head (c), 3.5 m above the attic, the Hijazi cornice), the slim shaft along the cut wall, the HRV in a plant room behind the attic, the channel at its full width.* *Still open:* the fan's sound in practice (hear a demonstration unit).
    - *MEP engineer:* every rate, size and pressure drop above; the flaps and the damper; the HRV / ERV choice and the unit; the duct sizes and the attenuators; the make-up air; the sump drain and its trap; the controls; the Taif wind data for the breeze.
    - *Structural engineer:* the channel in the slab (0.9 × 0.2 within the slab depth, its base slab, the three wall slots above the ground beams), the slim shaft's walls and openings, the tower on the roof slab (≈ 71 kN, the wind moment ≈ 21 kN·m, assumed), the plenum box and the plant room's load (`studies/structure.typ`).
    - *3D and other files:* `3d/build_3d.py` / `check_3d.py` still build and check the v2 pit, chamber and duct: to be rewritten for v3 at the next 3D build (`docs/PENDING_CHANGES.md`).
  ],
  [
    #H[7 · Maintenance (initial intervals; adjust to the manufacturer and the dust)]
    #table(columns: (1.3fr, 2fr, 1.4fr, auto, 2fr), inset: 2pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      [*Component*], [*Task*], [*Reached from*], [*Interval*], [*If neglected*],
      [The head's bird mesh (4 quarters)], [lower the frames on their cords, brush / vacuum, raise them], [the roof hatch in the tower's south face (behind the attic)], [6 months; after a dust storm (no fine mesh: little to clog)], [the breeze drops; birds enter the shaft],
      [Back-draught flaps (4)], [check they swing free, clean the seats], [the roof hatch in the tower's south face, by hand], [12 months], [a leeward quarter stays open: the head short-circuits, no breeze],
      [Courtyard damper and its actuator], [cycle it, check the spring return and the switch], [the roof hatch, a hinged panel], [12 months], [the damper sticks open (dust and cold air into the courtyard) or closed],
      [ERV pre-filter (the tower's intake compartment)], [slide out, replace], [the roof hatch, a second panel], [3 months], [the unit's fine filter clogs early; less fresh air],
      [Unit filters (the plant room)], [replace the fine supply filter and the extract filter], [the roof walkway: the plant room's south doors, no entry], [3–6 months (the indicator)], [less air, more fan power, dust bypass],
      [Heat-recovery core], [pull, wash, dry], [the roof walkway: through the plant room's doors], [12 months], [lost recovery, odours],
      [Exhaust louvre and the make-up air inlet], [clean the mesh; test the motorised inlet with the hood], [the attic's cut wall (behind the attic) / the kitchen wall], [6 months], [the hood depressurises the house; dust in],
      [Channel covers and channel], [lift the trays, vacuum the channel, check the gaskets], [the laundry and kitchen walkways, standing], [6 months; after a storm], [dust blown into the courtyard; wash-water into the channel],
      [Throat section and sump], [brush with a rod; check the dry trap, pour water once a year], [the first laundry cover and the shaft's foot (no entry)], [6 months], [odours from the drain; a blocked sump],
      [Plenum and grille], [lift off the grille, vacuum the plenum, set the louvre], [the courtyard], [1 month (dust)], [dust on the seating; a blocked grille],
      [Assist fan box (behind the grille)], [vacuum the blades, check the bearings and the damper interlock], [the courtyard: lift the grille, slide the box out], [12 months], [noise; less breeze],
      [Supply and extract grilles in the rooms], [vacuum], [the rooms, a step ladder], [6 months], [noise, less air],
    )
    #text(6.2pt, fill: gray)[Every task is done from the roof terrace, a room's floor or the courtyard. Nothing requires entering the tower, the channel or any pit: the sump is 0.32 m deep and reached by hand and rod.]
  ],
)

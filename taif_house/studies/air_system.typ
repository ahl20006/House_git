// air_system.typ · Taif / Palm House V10.0 · AIR SYSTEM v4 · THE MALQAF AT L5 (owner's decisions D1–D11 of 9 Nov 2026; adopted from studies/malqaf_L5.typ)
// ONE tower at the courtyard's NORTH-WEST corner (inside the covered strip under the first-floor west projection, against the women's majlis's wall),
// with TWO separate air paths after the head: (a) a LARGE unfiltered natural breeze (bird mesh only) down the shaft, through a dust trap in the foot
// chamber and out of a louvred outlet in the first arch of the courtyard arcade, onto the seating; (b) a small FILTERED path (a never-closing inlet under
// the head's south overhang, a washable pre-filter + a fine filter, a quiet EC fan with a silencer) supplying the house at a slight positive pressure.
// NO HRV (D2); no water in the air system (a mobile evaporative cooler is an OPTION, D9: its space, power and drain only); no human entry anywhere.
// Controls (owner): two wall switches (MALQAF open / closed, HOUSE FAN normal / boost) and one dust-sensor relay; every damper spring-return.
// v3 (V8.0 – V9.3, the tower at the north-east cut corner with the breeze channel in the slab) is superseded: studies/malqaf_tower.typ, studies/malqaf_L5.typ.
// EVERY size and performance figure here is ASSUMED, TO BE DESIGNED BY THE MEP ENGINEER; compiling this study is not engineering approval.
// Reads: data/rooms_gf.csv, data/rooms_ff.csv; the `#let air-*` tuples are read by 3d/build_3d.py. CSV frame: x east, y south, wall centre lines; levels above the finished ground floor.
#import "@preview/cetz:0.4.2"
#set page(paper: "a4", flipped: true, margin: 9mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 7.3pt)
#set par(leading: 0.42em)
#let green = rgb("#2f6b4f"); #let ink = rgb("#26302b"); #let gray = rgb("#6d736f"); #let orange = rgb("#c9741f"); #let blue = rgb("#1f7a99"); #let sky = rgb("#d4e9f1"); #let red = rgb("#b5452f"); #let amber = rgb("#b07a1f")
#let sand = rgb("#efe3c8"); #let honey = rgb("#d8b47a"); #let timber = rgb("#9c6b3c")
#let H(t) = block(above: 5pt, below: 3pt, text(9pt, weight: "bold", fill: green, t))
#let A(t) = text(fill: amber, weight: "bold", t)
#let r2(v) = str(calc.round(v, digits: 2)); #let r1(v) = str(calc.round(v, digits: 1))
#let f2(v) = { let s = str(calc.round(calc.abs(v), digits: 2)); if v < 0 { "−" + s } else { "+" + s } }
#let area(P) = calc.abs(range(P.len()).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, P.len())); a.at(0) * b.at(1) - b.at(0) * a.at(1) }).sum()) / 2
#let d3(a, b) = calc.sqrt(calc.pow(a.at(0) - b.at(0), 2) + calc.pow(a.at(1) - b.at(1), 2) + calc.pow(a.at(2) - b.at(2), 2))

// ---------- the system, as data (CSV frame; levels from the finished ground floor; ALL ASSUMED) · the `air-*` names are read by 3d/build_3d.py ----------
#let air-core = ((4.4, 6.5), (5.8, 6.5), (5.8, 8.667), (4.4, 8.667))   // the GF foot chamber on the wall centre lines (outer faces x 4.30–5.90, y 6.4–8.767): RC walls 0.20; its north wall is the majlis's wall rebuilt in RC
#let air-shaft = ((4.4, 6.5), (5.8, 6.5), (5.8, 7.5), (4.4, 7.5))      // the FF shaft (1.2 × 0.8 clear) and the opening through the FF and roof slabs; the gallery's turn past bedroom 2's bath keeps 1.5 m
#let air-head = (4.3, 6.4, 5.9, 8.8)            // the head above the roof, OUTER faces: F3, 1.6 × 2.4, the overhang south over the gallery roof (its walls on R3 widened and R11, a new beam R-L5 under the south wall)
#let air-head-z = (7.3, 10.6, 10.75, 11.2, 12.6, 12.9, 13.2)   // the roof finish · the band (bottom, top) · the openings (sill, top) · the crown's base · the top (+13.20 = 4.52 above the attic coping)
#let air-slots = (3, 5, 0.2, 0.2, 0.3)          // slots per short / long face, their width, the ribs, the corner piers: 1.6 = 0.3 + 3 × 0.2 + 2 × 0.2 + 0.3; 2.4 = 0.3 + 5 × 0.2 + 4 × 0.2 + 0.3 (the 20 cm module)
#let air-outlet = (5.8, 7.1, 8.5, 0.10, 1.10)   // the courtyard outlet on the core's east face (x, y0, y1, z0, z1): 1.4 × 1.0 in the first arcade arch, adjustable timber louvres, the damper D2 behind
#let air-door = (8.667, 4.6, 5.6, 2.4)          // the carved timber door in the core's south face (y, x0, x1, height), onto the covered strip: the cooler and all cleaning pass here
#let air-trap = (4.5, 6.6, 5.3, 7.3, 0.30)      // the dust trap under the shaft: a GRP floor basin (x0, y0, x1, y1, depth), a lift-out stainless grating, a trapped gully
#let air-fan = (4.5, 7.55, 4.95, 8.15, 0.0, 1.6)   // the filter cabinet + the EC fan + the silencer, the chamber's west side (x0, y0, x1, y1, z0, z1)
#let air-cooler = (4.9, 7.55, 5.7, 8.25, 0.0, 1.6)   // the space for a MOBILE evaporative cooler (option, D9): 0.8 × 0.7 × ≤ 1.6, its outlet against the grille; a power point, a floor drain, a capped water point
#let air-inlet = (4.6, 8.5, 7.6)                // the filtered path's inlet: a downward-facing hood under the head's south overhang (x, y, z), a bird mesh, NEVER closes
#let air-damper-top = 7.75                      // D1 at the shaft's head (1.2 × 0.8): insulated blades, low-leakage, spring-return (closes on power loss)
#let air-sunken = (0.0, 5.925, 7.1, 8.85, 12.3) // the seating zone on the LEVEL courtyard floor (studies/courtyard_layout.typ): floor level, x0, y0, x1, y1
#let air-grilles = ((4.4, 6.5, 6.4), (5.1, 7.5, 6.4), (4.4, 7.6, 2.7), (5.1, 6.5, 2.7))   // the filtered-air grilles (x, y, z): the family living (the core's N face, FF), the gallery (S face, FF), the riwaq (W face, GF), the women's majlis (N face, GF)
#let air-gallery-grille = (4.7, 5.5, 7.5, 4.2, 5.8)   // the carved arched timber grille on the shaft's south face (x0, x1, y, z0, z1): a sealed PROVISION (owner, 9 Nov 2026), no damper now
#let air-base = (-0.08, -0.38)                  // the dust trap's basin: from the ground-slab top to its floor (a gully with a trap and a trap primer; NO pit, no entry)
#let riser = 0.12                               // the filtered path's sealed riser (Ø250) in the shaft's west side: taken from the breeze section
// ---------- derived sections and areas ----------
#let core-clear = (air-core.at(1).at(0) - air-core.at(0).at(0) - 0.2) * (air-core.at(2).at(1) - air-core.at(0).at(1) - 0.2)   // 1.2 × 1.967
#let shaft-clear = (air-shaft.at(1).at(0) - air-shaft.at(0).at(0) - 0.2) * (air-shaft.at(2).at(1) - air-shaft.at(0).at(1) - 0.2)   // 1.2 × 0.8
#let breeze-area = shaft-clear - riser
#let slot-h = air-head-z.at(4) - air-head-z.at(3)
#let slot-free = air-slots.at(2) * (slot-h - air-slots.at(2) / 2) + calc.pi * calc.pow(air-slots.at(2) / 2, 2) / 2
#let free-short = air-slots.at(0) * slot-free; #let free-long = air-slots.at(1) * slot-free
#let screen-free = 0.9                          // a wide 20 mm bird mesh only (owner): ≈ 90 % open; no insect mesh on the breeze path
#let louvre-free = 0.6                          // the outlet's adjustable timber louvres
#let outlet-free = (air-outlet.at(2) - air-outlet.at(1)) * (air-outlet.at(4) - air-outlet.at(3)) * louvre-free
#let door-w = air-door.at(2) - air-door.at(1)
// the breeze (ASSUMED; the MEP engineer models it): the loss chain referred to a 0.10 m² reference section (as v3, so the figures compare)
#let rho = 1.15                                 // Taif, 1 700 m
#let dCp = 0.8                                  // windward face against the courtyard well (assumed)
#let a-ref = 0.10
#let zeta-list = (
  ("the head: the windward long face, " + str(air-slots.at(1)) + " slots + bird mesh (" + r2(free-long * screen-free) + " m² free)", 3.0 * calc.pow(a-ref / (free-long * screen-free), 2)),
  ("the back-draught flaps and D1 (" + r2(breeze-area) + " m²)", 1.0 * calc.pow(a-ref / breeze-area, 2)),
  ("the shaft, 3.8 m, smooth render", 0.02 * 3.8 / 0.95 * calc.pow(a-ref / breeze-area, 2)),
  ("the turn into the chamber over the dust trap", 1.5 * calc.pow(a-ref / breeze-area, 2)),
  ("the outlet louvres (" + r2(outlet-free) + " m² free) and D2", 2.5 * calc.pow(a-ref / outlet-free, 2)),
)
#let zeta = zeta-list.map(z => z.at(1)).sum()
#let zeta-v93 = 1.5026                          // RECORD: the V9.3 chain (L1 at the north-east corner, the 10.6 m channel at full width), for the comparison
#let flow(v-wind) = { let v = v-wind * 1.04; let dp = 0.5 * rho * v * v * dCp; let vr = calc.sqrt(2 * dp / (rho * zeta)); (dp: dp, v: vr, q: vr * a-ref) }   // the head at ≈ +12: ≈ 4 % more wind than the 10 m mast
#let gentle = flow(10.0 / 3.6); #let mean-eve = flow(21.0 / 3.6); #let strong = flow(30.0 / 3.6)
#let gain-v93 = calc.sqrt(zeta-v93 / zeta)
#let v-out(q) = q / outlet-free
#let stack-dp = rho * 9.81 * 11.0 * 3 / 300     // still air: the stack of the 11 m path with 3 K
#let still = { let v = calc.sqrt(2 * stack-dp / (rho * zeta)); (dp: stack-dp, v: v, q: v * a-ref) }
// the house ventilation (ASHRAE 62.2-2022 §4.1: Qtot = 0.15 L/s·m² × A + 3.5 L/s × (bedrooms + 1); guests: ASHRAE 62.1 assembly)
#let parse-pts(s) = s.split(";").map(t => t.trim()).filter(t => t != "").map(t => { let v = t.split(" ").filter(u => u != ""); (float(v.at(0)), float(v.at(1))) })
#let read(path) = csv(path, row-type: dictionary).filter(r => r.name != "" and not r.name.starts-with("#")).map(r => {
  let P = if r.pts.trim() != "" { parse-pts(r.pts) } else {
    let x = float(r.x); let y = float(r.y); let w = float(r.w); let d = float(r.d)
    ((x - w / 2, y - d / 2), (x + w / 2, y - d / 2), (x + w / 2, y + d / 2), (x - w / 2, y + d / 2)) }
  (name: r.name, colour: r.colour, P: P, area: area(P)) })
#let GF = read("../data/rooms_gf.csv")
#let FF = read("../data/rooms_ff.csv")
#let conditioned = GF.filter(r => r.colour != "court" and r.colour != "tower").map(r => r.area).sum() + FF.filter(r => r.colour != "open").map(r => r.area).sum()
#let cond-clear = conditioned * 0.92
#let bedrooms = 5
#let q-normal = 0.15 * cond-clear + 3.5 * (bedrooms + 1)      // L/s
#let guests = 24
#let majlis = GF.find(r => r.name == "Men's majlis").area * 0.93
#let q-majlis = 3.8 * guests + 0.3 * majlis
#let q-boost = q-normal + q-majlis
#let fan = (q: 750, dp: 250, w: 160, dba: 38, filters: "ISO Coarse 60 % (G4) washable 500 × 500 × 48 + ISO ePM1 ≥ 50 % (F7 class) 500 × 500 × 292", dp-service: 200)
#let q-hood = 300                               // the kitchen hood's make-up air through its own interlocked inlet (MANDATORY, owner)
#let heat-loss(q, dT) = 0.34 * q * dT / 1000    // kW for q m³/h
// the intake and the exhausts (ASHRAE 62.1-2022 Table 5-1 separations; the brief's allowances)
#let intake = (air-inlet.at(0), air-inlet.at(1), air-inlet.at(2))
#let head-c = ((air-head.at(0) + air-head.at(2)) / 2, (air-head.at(1) + air-head.at(3)) / 2, air-head-z.at(3))
#let hood-out = (13.311, 10.7, 2.2)             // the kitchen hood outlet through the east wall
#let vent-east = (13.2, 8.4, 8.0)               // the east stack's vent above the roof
#let vent-west = (11.5, 15.0, 8.8)              // the west stack's vent, RE-ROUTED in the attic to the south-east strip (owner, 9 Nov 2026; was x 0.75, y 9.8: upwind of the head in the W wind)
#let gas-cab = (13.7, 8.6, 0.0)
#let generator = (14.5, 12.0, 0.0)
#let condensers = (9.6, 5.6, 12.4, 9.0)         // the AC outdoor units' zone Z2b (studies/roof.typ), tops ≈ +8.6
#let d-cond(p) = d3(p, (calc.max(condensers.at(0), calc.min(p.at(0), condensers.at(2))), calc.max(condensers.at(1), calc.min(p.at(1), condensers.at(3))), 8.6))
#let sep = (
  ([breeze head ↔ kitchen hood outlet], d3(head-c, hood-out), 4.6, [class 3 (cooking) → ≥ 4.6 m; downwind, 9 m below]),
  ([breeze head ↔ east stack's vent], d3(head-c, vent-east), 3.0, [vents → ≥ 3 m; downwind]),
  ([breeze head ↔ west stack's vent (re-routed SE)], d3(head-c, vent-west), 3.0, [vents → ≥ 3 m; no longer upwind]),
  ([breeze head ↔ AC condensers (Z2b)], d-cond(head-c), 2.0, [their hot plume rises leeward in a W wind; 3.7 m in plan, 2.6 m below the openings]),
  ([filtered inlet ↔ hood outlet], d3(intake, hood-out), 4.6, [class 3]),
  ([filtered inlet ↔ the two vents], calc.min(d3(intake, vent-east), d3(intake, vent-west)), 3.0, [≥ 3 m]),
  ([filtered inlet ↔ LPG cabinet / generator point (the yard)], calc.min(d3(intake, gas-cab), d3(intake, generator)), 4.6, [class 3 / 4 allowances; the generator point ≥ 9 m]),
)
#let ok-sep = sep.all(((l, d, need, b)) => d >= need)
#let checks = (
  ([the foot chamber #r2(core-clear) m² clear takes the dust trap, the filter cabinet + fan + silencer, the cooler's space 0.8 × 0.7 and a standing place at the door], core-clear >= 2.3),
  ([the shaft #r2(shaft-clear) m² clear; the breeze part #r2(breeze-area) m² ≥ 0.54 beside the sealed riser], breeze-area >= 0.54 - 1e-9),
  ([the outlet 1.4 × 1.0 (#r2(outlet-free) m² free) and the door ≥ 0.9 m clear (#r2(door-w))], outlet-free >= 0.6 and door-w >= 0.9),
  ([the head's openings (#f2(air-head-z.at(3)) … #f2(air-head-z.at(4))) start above the roof's recirculation bubble (≈ +11.4, studies/malqaf_L5.typ § 1.3) less 0.25 m], air-head-z.at(3) >= 11.42 - 0.25),
  ([the head on the 20 cm module: 1.6 = 2 × 0.3 + 3 × 0.2 + 2 × 0.2; 2.4 = 2 × 0.3 + 5 × 0.2 + 4 × 0.2], calc.abs(2 * air-slots.at(4) + air-slots.at(0) * air-slots.at(2) + (air-slots.at(0) - 1) * air-slots.at(3) - 1.6) < 1e-6 and calc.abs(2 * air-slots.at(4) + air-slots.at(1) * air-slots.at(2) + (air-slots.at(1) - 1) * air-slots.at(3) - 2.4) < 1e-6),
  ([every separation of the head and the filtered inlet from the exhausts meets its allowance], ok-sep),
  ([the fan covers the boost (≥ #r1(q-boost * 3.6) m³/h) with the filters loaded], fan.q >= q-boost * 3.6),
  ([the breeze at the summer-evening mean wind (21 km/h) ≈ #r2(mean-eve.q) m³/s, ≈ #r1(gain-v93) × the V9.3 L1 system; the outlet's air speed ≤ 2.5 m/s (#r1(v-out(mean-eve.q)))], gain-v93 >= 3.0 and v-out(mean-eve.q) <= 2.5),
  ([the dust trap's basin inside the slab's depth plus 0.30 (floor #f2(air-base.at(1))): no pit, no entry], air-base.at(1) >= -0.40),
)
#let all-ok = checks.all(c => c.at(1))

// ====================================================================================== PAGE 1 · the concept, the core, the chamber
#text(14pt, weight: "bold", fill: green)[Air system study v4 · the malqaf at L5: a large courtyard breeze and a filtered supply · Taif / Palm House V10.0]
#v(1pt)
#text(8pt, fill: gray)[The owner's decisions of 9 Nov 2026 (D1–D11, `studies/malqaf_L5.typ`, adopted): the breeze at the seating is the goal · no HRV: a filtered supply fan · one tower, two paths after the head · no water tank on the tower · a dust-tight house, the courtyard an open outdoor room · the tower touches no bedroom · render and paint, no stone · simple controls. #A[Every size and performance figure is ASSUMED, to be designed by the MEP engineer]; compiling this study is not engineering approval.]
#v(3pt)
#let core-plan(length: 2.0cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let q(p) = (p.at(0), -p.at(1))
  let T(p, t, size: 4.2pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, t))
  let R(b, f, s) = rect(q((b.at(0), b.at(1))), q((b.at(2), b.at(3))), fill: f, stroke: s)
  R((3.9, 6.0, 6.4, 9.4), rgb("#f3efe6"), none)
  R((3.9, 6.0, 6.4, 6.4), rgb("#e9e2d2"), none); T((5.15, 6.2), [women's majlis], size: 3.8pt, fill: gray)
  R((5.9, 6.4, 6.4, 9.4), rgb("#dfe9d3"), none); T((6.15, 8.2), [courtyard], size: 3.6pt, fill: gray, angle: 90deg)
  R((4.25, 8.767, 5.9, 9.4), rgb("#e8eadf"), none); T((5.1, 9.1), [the covered strip], size: 3.6pt, fill: gray)
  R((3.9, 6.4, 4.3, 9.4), rgb("#f1ebdd"), none); T((4.1, 8.0), [riwaq], size: 3.6pt, fill: gray, angle: 90deg)
  R((4.3, 6.4, 5.9, 8.767), rgb("#3a3f3b"), none); R((4.5, 6.6, 5.7, 8.567), rgb("#f4f1ea"), none)
  R((air-shaft.at(0).at(0) + 0.1, air-shaft.at(0).at(1) + 0.1, air-shaft.at(1).at(0) - 0.1, air-shaft.at(2).at(1) - 0.1), sky.transparentize(40%), (paint: blue, thickness: 0.5pt, dash: "dashed")); T((5.45, 6.72), [the shaft above], size: 3.4pt, fill: blue)
  R((air-trap.at(0), air-trap.at(1), air-trap.at(2), air-trap.at(3)), none, 0.5pt + gray); T((4.9, 7.15), [dust trap\ (grating, gully)], size: 3.4pt)
  R((air-fan.at(0), air-fan.at(1), air-fan.at(2), air-fan.at(3)), rgb("#dfe8d0"), 0.6pt + green); T((4.725, 7.85), [filters\ + fan\ + silencer], size: 3.2pt)
  R((air-cooler.at(0), air-cooler.at(1), air-cooler.at(2), air-cooler.at(3)), rgb("#e8f1f6"), (paint: blue, thickness: 0.5pt, dash: "dashed")); T((5.3, 7.9), [cooler space\ (option)], size: 3.4pt)
  line(q((air-outlet.at(0), air-outlet.at(1))), q((air-outlet.at(0), air-outlet.at(2))), stroke: 4pt + green); T((6.05, 7.8), [outlet 1.4 × 1.0\ in the first arch], size: 3.6pt, fill: green, angle: 90deg)
  line(q((air-door.at(1), 8.767)), q((air-door.at(2), 8.767)), stroke: 4pt + timber); T((5.1, 8.98), [carved door 1.0], size: 3.6pt, fill: timber)
  circle(q((5.8, 6.5)), radius: 0.12, fill: luma(90), stroke: none); T((6.0, 6.4), [C21 → the core], size: 3.2pt, anchor: "west")
  circle(q((5.8, 8.667)), radius: 0.1, fill: luma(90), stroke: none); T((6.0, 8.667), [arcade column → the core], size: 3.2pt, anchor: "west")
  circle(q((4.25, 6.5)), radius: 0.12, fill: luma(90), stroke: none); T((4.05, 6.45), [C17], size: 3.2pt, anchor: "east")
  R((4.5, 8.3, 4.6, 8.5), rgb("#dfe8d0"), 0.3pt + green); T((4.4, 8.45), [(b) riser], size: 3pt, anchor: "east")
  T((5.1, 9.65), [the GF foot chamber · plan · 1 m = 2.0 cm], size: 4pt, fill: green)
})
#grid(columns: (auto, 1fr), gutter: 12pt,
  core-plan(),
  [
    #H[1 · The concept]
    - *One tower at the courtyard's north-west corner* (L5: `studies/malqaf_L5.typ`, the owner's decision after a location study): an *independent RC core* from its own pad to the head, inside the covered strip under the first-floor projection, against the women's majlis's wall (nothing taken from the majlis or the family living); *no bedroom touches it* (D10). It catches Taif's warm-season evening wind (W ≈ 50 %, NW ≈ 30 %, ≈ 21 km/h; the climate basis in `studies/malqaf_L5.typ` Phase 0) above the roof's own wake.
    - *Path (a), the courtyard breeze (D1, the goal):* the head's four faces → the + divider and the back-draught flaps → *D1* → the shaft (#r2(breeze-area) m²) → the *dust trap* at its foot → the chamber → the *outlet 1.4 × 1.0* with its timber louvres and *D2*, in the *first arch of the arcade*, ≈ 1 m from the seating: *no channel*. Unfiltered by design (a bird mesh only).
    - *Path (b), the house's fresh air (no HRV, D2):* a *never-closing* downward inlet under the head's south overhang → a washable pre-filter + a fine filter → a quiet *EC fan* (#fan.q m³/h) → a silencer → a sealed riser → high grilles into the *family living*, the *gallery*, the *riwaq* and the *women's majlis*; the house runs at a slight *positive pressure*, dust stays out (D5). *The kitchen hood keeps its own interlocked make-up inlet (mandatory).*
    - *Simple controls (owner):* two wall switches, one dust-sensor relay, spring-return dampers (§ 5). *The cooler (D9):* an option: its space, a power point and a floor drain in the chamber; the water point capped; the malqaf is a *dry system*.
    #H[2 · The core: the shaft, the foot chamber, the door]
    - *The shaft* (FF and above): outer 1.6 × 1.2 m, *#r2(shaft-clear) m² clear*; the sealed Ø250 riser of path (b) in its west side, the breeze part *#r2(breeze-area) m²*; smooth-rendered inside; the gallery's turn past bedroom 2's bath stays *1.5 m clear*. On its south face at the FF a carved arched timber grille 0.8 × 1.6 (sill +#r2(air-gallery-grille.at(3))): *a sealed provision* (owner), no damper now.
    - *The foot chamber* (GF): outer 1.6 × 2.37 m to the first arcade column, *#r2(core-clear) m² clear*, ≈ 3.1 m high, open above into the shaft: the dust trap (a 0.8 × 0.7 GRP basin #r2(air-trap.at(4)) m deep under the shaft, a lift-out grating, a trapped gully with a trap primer); the filter cabinet, the fan and the silencer on the west wall; the cooler's space at the outlet; a floor fall to the gully, the walls tanked to +0.30, IP44 sockets on their own circuit, a capped water point. *The door:* a carved timber door *#r2(door-w) × #r2(air-door.at(3))* with a semicircular head, on the south face onto the covered strip: the cooler rolls in, every cleaning task passes here.
    - *Absorbed in the core:* the columns C17 (4.25, 6.5) and C21 (5.8, 6.5) and the first arcade column (5.8, 8.667): the core is the *fourth support* of the west projection (B3 / B4 first spans 6.50 → 4.33 m; `studies/structure.typ`).
  ],
)
#v(2pt)
#text(7.5pt)[#if all-ok [*Air system study v4 · checks passed* (#checks.len())] else [*CHECKS FAILED:* #checks.filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]]

// ====================================================================================== PAGE 2 · the section, the head, the dampers
#pagebreak()
#text(12pt, weight: "bold", fill: green)[3 · The two paths in section · the head · the dampers · the intake and the exhausts]
#v(3pt)
#grid(columns: (auto, 1fr), gutter: 12pt,
  cetz.canvas(length: 0.56cm, {
    import cetz.draw: *
    let Y(y) = (y - 5.8) * 2.2; let Z(z) = z
    let box4(y0, z0, y1, z1, f, s) = rect((Y(y0), Z(z0)), (Y(y1), Z(z1)), fill: f, stroke: s)
    box4(5.8, -1.2, 9.6, -0.6, luma(150), none)
    box4(6.4, -0.6, 6.6, 7.3, rgb("#3a3f3b"), none); box4(7.4, 3.52, 7.6, 7.3, rgb("#3a3f3b"), none); box4(8.567, -0.6, 8.767, 3.52, rgb("#3a3f3b"), none)
    box4(5.8, 3.44, 9.6, 3.72, luma(175), none); box4(5.8, 7.2, 9.6, 7.4, luma(175), none)
    box4(6.4, 7.3, 8.8, air-head-z.at(6), sand, 0.5pt + ink); box4(6.2, air-head-z.at(1), 9.0, air-head-z.at(2), honey, none); box4(6.1, air-head-z.at(5), 9.1, air-head-z.at(6), honey, none)
    box4(6.6, air-head-z.at(3), 8.6, air-head-z.at(4), rgb("#2b2b2d"), none); content((Y(7.6), 11.9), text(3.6pt, fill: white)[the head: 4 faces of slender\ arched slots · bird mesh\ + divider + flaps])
    box4(7.6, 7.3, 8.8, 7.6, luma(175), none); content((Y(8.2), 7.0), text(3.2pt)[the south overhang (F3) on R3 / R11 / R-L5])
    box4(6.6, 3.72, 7.4, 7.2, sky, none); content((Y(7.0), 5.5), text(3.6pt)[(a) breeze\ shaft\ #r2(breeze-area) m²])
    box4(6.6, 3.9, 6.95, 7.2, rgb("#dfe8d0"), 0.3pt + green); content((Y(6.78), 5.5), angle: 90deg, text(3.2pt)[(b) riser Ø250])
    box4(6.6, -0.6, 8.567, 3.44, rgb("#f4f1ea"), none)
    box4(6.6, air-base.at(1), 7.3, air-base.at(0), sky, 0.3pt + blue); content((Y(6.95), -0.23), text(3pt)[dust trap])
    box4(7.6, 0.1, 8.5, 1.7, rgb("#e8f1f6"), (paint: blue, thickness: 0.4pt, dash: "dashed")); content((Y(8.05), 0.9), text(3.2pt)[cooler\ (option)])
    box4(6.6, 0.0, 7.1, 1.6, rgb("#dfe8d0"), 0.4pt + green); content((Y(6.85), 0.8), text(3pt)[filters\ + fan\ + silencer])
    line((Y(6.6), air-damper-top), (Y(7.4), air-damper-top), stroke: 2.4pt + red); content((Y(7.0), 8.1), text(3.2pt, fill: red)[D1 (#f2(air-damper-top))])
    line((Y(8.567), air-outlet.at(3)), (Y(8.567), air-outlet.at(4)), stroke: 2.4pt + green); content((Y(9.1), 0.6), text(3.2pt, fill: green)[outlet 1.4 × 1.0\ + D2 behind])
    line((Y(7.5), air-gallery-grille.at(3)), (Y(7.5), air-gallery-grille.at(4)), stroke: 2.4pt + timber); content((Y(8.1), 5.0), text(3.2pt, fill: timber)[gallery grille\ (sealed provision)])
    circle((Y(8.4), 7.55), radius: 0.12, fill: green, stroke: none); content((Y(9.0), 7.75), text(3.2pt, fill: green)[(b) inlet: a hood under the\ overhang, #f2(air-inlet.at(2)), never closes])
    line((Y(8.4), 7.45), (Y(8.4), 3.9), stroke: (paint: green, thickness: 0.8pt, dash: "dashed")); content((Y(8.75), 5.0), angle: 90deg, text(3pt, fill: green)[the intake duct in the chamber's SE corner])
    for (z, l) in ((6.4, [→ family living (N), gallery (S)]), (2.7, [→ riwaq (W), women's majlis (N)])) { line((Y(6.4), z), (Y(6.1), z), stroke: 1.2pt + green); content((Y(6.05), z), anchor: "east", text(3pt, fill: green, l)) }
    content((Y(5.9), 13.8), anchor: "west", text(4.4pt, weight: "bold", fill: green)[SECTION N–S through the core (y 5.8–9.6, stretched × 2.2) · levels from the GF floor])
  }),
  [
    #H[3.1 · The head (F3; render and paint, no stone)]
    - Outer *1.6 × 2.4 m* on the shaft and the gallery roof, an *RC frame* (0.30 corner piers, ring beams at the band and the crown), the slender ribs in rendered block; a light sand render, the band (#f2(air-head-z.at(1))), the two-step Hijazi crown (#f2(air-head-z.at(5)) … #f2(air-head-z.at(6))) and the slot surrounds in the calm honey tone, every projection with a drip. *Openings #f2(air-head-z.at(3)) … #f2(air-head-z.at(4))* on all four faces: #air-slots.at(0) slots on the short faces, #air-slots.at(1) on the long (W / E), each #r2(air-slots.at(2)) m wide with a small semicircular top; free ≈ #r2(free-short) / #r2(free-long) m² per face. The W and N faces are the catchers (Phase 0); the openings start above the roof's recirculation bubble. Inside: a 20 mm bird mesh in frames lowered on cords to a 0.5 m hatch in the west face (+7.6 … +8.1), the + divider and four back-draught flaps (the windward quarter feeds, the leeward shut). *Crown #f2(air-head-z.at(6))*: 4.5 m above the attic coping; seen whole from the courtyard seating, 1.9 m from the street at 14 m, *not* from the gate (accepted by the owner).
    #H[3.2 · The dampers (two; insulated, low-leakage, spring-return)]
    - *D1* at the shaft's head (#f2(air-damper-top), 1.2 × 0.8) and *D2* behind the outlet's louvres: both close on power loss; driven together by the one switch MALQAF and closed by the dust relay. *No D3:* the gallery grille is a sealed provision. *D4:* a passive gravity louvre Ø160 from the chamber to the outlet (no motor), so the chamber never stays damp. The hood's make-up damper: its own, interlocked with the hood (*mandatory*).
    #H[3.3 · The intake and the exhausts (ASHRAE 62.1-2022 Table 5-1 allowances)]
    #table(columns: (1.6fr, auto, auto, 2fr), inset: 2pt, stroke: 0.4pt + luma(180), fill: (_, y) => if y == 0 { rgb("#e4eedf") },
      [*Pair*], [*Distance*], [*Need*], [*Basis*],
      ..sep.map(((l, d, need, b)) => ([#l], [#r1(d) m], [≥ #r1(need)], [#b])).flatten())
    - The west stack's vent *re-routed in the attic to the south-east strip* (owner, 9 Nov 2026): no exhaust stands upwind of the head in the summer-evening west wind. The AC condensers stay in Z2b, east of the head and below its openings.
  ],
)

// ====================================================================================== PAGE 3 · the breeze estimate · the house ventilation
#pagebreak()
#text(12pt, weight: "bold", fill: green)[4 · The breeze, estimated honestly · 5 · The house ventilation (the filtered supply)]
#v(3pt)
#grid(columns: (1fr, 1fr), gutter: 12pt,
  [
    #H[4 · What the courtyard will feel]
    The path's resistance, referred to a 0.10 m² reference section (#A[assumed loss coefficients, ASHRAE Fundamentals ch. 21 orders of magnitude]); the V9.3 chain (L1 at the north-east corner, 10.6 m of channel) scored #r2(zeta-v93): the L5 path is *≈ #r1(gain-v93) ×* its flow in the same wind.
    #table(columns: (1fr, auto), inset: 2pt, stroke: 0.4pt + luma(180), fill: (_, y) => if y == 0 { rgb("#e4eedf") },
      [*Element*], [*ζ (0.10 m²)*],
      ..zeta-list.map(((n, z)) => ([#n], [#r2(z)])).flatten(), [*total*], [*#r2(zeta)*])
    Driving pressure: wind at the head ½ρv²·ΔCp with ρ #r2(rho) kg/m³ (Taif, 1 700 m) and ΔCp #r2(dCp) (windward face against the courtyard well, assumed), the head at ≈ +12 (≈ 4 % more than the 10 m mast); in still air the stack of the 11 m path with 3 K: #r2(stack-dp) Pa.
    #table(columns: (1fr, auto, auto, auto), inset: 2pt, stroke: 0.4pt + luma(180), fill: (_, y) => if y == 0 { rgb("#e4eedf") },
      [*Wind at 10 m*], [*Δp (Pa)*], [*flow (m³/s)*], [*at the louvres (m/s)*],
      [calm (stack only)], [#r2(still.dp)], [#r2(still.q)], [#r1(v-out(still.q))],
      [gentle, 10 km/h], [#r2(gentle.dp)], [#r2(gentle.q)], [#r1(v-out(gentle.q))],
      [*the summer-evening mean, 21 km/h*], [#r2(mean-eve.dp)], [*#r2(mean-eve.q)*], [#r1(v-out(mean-eve.q))],
      [a strong evening, 30 km/h], [#r2(strong.dp)], [#r2(strong.q)], [#r1(v-out(strong.q))])
    - *Honest conclusion:* at the typical summer evening (21 km/h at the mast, Phase 0: ≈ 50 % W, 30 % NW) the outlet delivers ≈ #r2(mean-eve.q) m³/s, ≈ #r1(v-out(mean-eve.q)) m/s at the louvres and ≈ 0.5–0.8 m/s at the seating 2 m away: *a clearly felt breeze*, ≈ #r1(gain-v93) × the L1 system; a gentle 10 km/h wind still gives #r2(gentle.q) m³/s; a calm evening gives little (the stack #r2(still.q) m³/s). About 1 800 pleasant, dust-free seating hours a year (`studies/malqaf_L5.typ` Phase 0). The louvres aim the jet along the seating; the family closes the switch when it is too much.
    - *If a cooler is added later (D9, option):* a 90–150 L portable evaporative cooler in the chamber moves ≈ 0.8–1.4 m³/s and cools the dry afternoon air from ≈ 35 to ≈ 20–22 °C (RH 12–20 %); its water ≈ 15–25 L/h; it cools *the people in the jet*, not the open courtyard. Provided now: the space, a power point, the floor drain; the water point capped.
  ],
  [
    #H[5 · The house's ventilation (no HRV: a filtered supply fan, D2)]
    - *Preliminary airflow* (ASHRAE 62.2-2022 § 4.1.1: 0.15 L/s·m² of floor + 3.5 L/s per bedroom + 1): conditioned floor ≈ #str(calc.round(cond-clear)) m² clear (#str(calc.round(conditioned)) m² on axes), #bedrooms bedrooms → *#str(calc.round(q-normal * 3.6)) m³/h normal*; the men's majlis full (#guests guests, ASHRAE 62.1 assembly) → *#str(calc.round(q-boost * 3.6)) m³/h boost*. #A[The MEP engineer sizes it with the final rooms.]
    - *The fan:* an EC plug / centrifugal fan *#fan.q m³/h at #fan.dp Pa* external, ≈ #fan.w W, in its cabinet in the foot chamber on anti-vibration mounts, a *0.9 m lined silencer* after it (≈ −15 dB), ≈ #fan.dba dB(A) in the chamber: the courtyard hears nothing through the 200 RC wall and the lined cabinet. Two speeds from the switch (normal / boost), set once at commissioning.
    - *The filters:* #fan.filters; a mechanical gauge on the cabinet: change the fine filter at #fan.dp-service Pa (≈ 6 months); the pre-filter washed monthly. The fine filter holds ≥ 50 % of PM1 (≈ 80 % of PM2.5): during a 150 µg/m³ dust event the house stays at roughly a quarter of the outdoor level (the house tight, D5).
    - *Positive pressure:* the fan supplies #str(calc.round(q-normal * 3.6)) m³/h into a tight envelope; the extracts (the bathrooms ≈ 150–250 m³/h continuous, the dryer) are smaller: the house runs at ≈ *+5–10 Pa*; every door undercut 15 mm or with a transfer grille. #text(fill: red, weight: "bold")[The kitchen hood] (600–1 000 m³/h) exceeds the fan: without its make-up inlet the house would go negative and pull dust through every crack and the malqaf's grille: *the interlocked make-up inlet (≈ #q-hood m³/h, filtered, motorised, opens with the hood) is mandatory* (owner, 9 Nov 2026).
    - *The supply route:* the inlet hood under the overhang (+7.6) → a Ø315 duct down the chamber's south-east corner → the filters and the fan → the silencer → a sealed Ø250 riser in the shaft's west side → high grilles (+6.4) into the *family living* (through the core's north wall) and the *gallery* (south face), and at the GF (+2.7) into the *riwaq* (west face) and the *women's majlis* (north wall); the other rooms through the riwaq's open plan and the door undercuts. *No bedroom is ducted from the core.*
    - *Winter:* the breeze closed (switch 1 off), the fan at normal: ≈ #r2(heat-loss(q-normal * 3.6, 10)) kW of heat at a 10 K difference (no heat recovery): small; the family sets boost when the house is full.
  ],
)

// ====================================================================================== PAGE 4 · controls · maintenance · decisions
#pagebreak()
#text(12pt, weight: "bold", fill: green)[6 · Controls (simple, the owner's rule) · 7 · Maintenance · 8 · Decisions and what the engineers check]
#v(3pt)
#grid(columns: (1fr, 1.3fr), gutter: 12pt,
  [
    #H[6 · Controls: two switches, one relay]
    #table(columns: (auto, 1fr, 1fr), inset: 2.4pt, stroke: 0.4pt + luma(175), fill: (_, y) => if y == 0 { rgb("#e4eedf") },
      [*Switch*], [*ON*], [*OFF*],
      [*1 · MALQAF*], [D1 + D2 open: the courtyard breeze, whenever the family finds the evening pleasant], [D1 + D2 shut: winter, dust, away. *The dust relay forces OFF* while the air is dirty],
      [*2 · HOUSE FAN*], [boost (#str(calc.round(q-boost * 3.6)) m³/h): guests, after a dust day, a full house], [normal (#str(calc.round(q-normal * 3.6)) m³/h): always on; the filtered path never stops])
    - *The dust relay:* an outdoor PM2.5 sensor in a weather hood on the head's north face: above *50 µg/m³ for 10 min* D1 and D2 close by themselves and the switch's lamp shows "dust"; they reopen when the air has been below 25 µg/m³ for 30 min and the switch is on. *Every damper spring-return:* closed on power loss. *No controller, no modes* (owner, 9 Nov 2026). A manual override on each damper's actuator for the technician.
    #H[8 · Decisions (owner) and the engineers' checks]
    - *Owner (9 Nov 2026):* L5 adopted (V-c + F3; the fall-back F2 if the engineer refuses the beam additions); no HRV; two paths; no tank on the tower; the gallery grille a sealed provision; the cooler an option; render and paint; the two switches and the dust relay; the west vent re-routed; the hood's make-up inlet mandatory.
    - *Structural engineer:* the core's walls and pad, the ties to the slabs, B3 / B4 for 4.33 m, R3 widened to 0.40 over y 6.5–8.8, the new beam R-L5 (1.55 m) under the head's south wall, the head frame for wind and *earthquake* (`studies/structure.typ`).
    - *MEP engineer:* the fan, the filters, the silencer, D1 / D2 and the dust relay, the louvres and grilles, the hood's make-up inlet, the vent re-route, the chamber's gully and electrics; the breeze estimate confirmed (a CFD or a wind-tunnel check if wanted).
    - *Owner's site work:* the on-site weather station (≥ 6 m, 4–6 weeks) confirms the wind faces before the head is detailed.
  ],
  [
    #H[7 · Maintenance (all from the carved door at ground level; no routine task enters a shaft or climbs a ladder)]
    #table(columns: (1.2fr, 1.4fr, auto, 1.2fr), inset: 2.2pt, stroke: 0.4pt + luma(175), fill: (_, y) => if y == 0 { rgb("#e4eedf") },
      [*Item*], [*What · how*], [*Every*], [*If neglected*],
      [the dust trap], [lift the grating, sweep / vacuum the basin, hose to the gully], [month; week in Mar–Apr], [dust blows back into the courtyard],
      [the pre-filter], [slide out, wash, dry, back], [month (the gauge)], [the fine filter clogs early],
      [the fine filter], [replace], [≈ 6 months (#fan.dp-service Pa)], [less fresh air, more fan power],
      [the gully trap], [fill / flush (the trap primer)], [month], [odours from the drain],
      [the outlet louvres, the grilles], [brush, vacuum], [3 months], [dust on the louvres],
      [D1, D2, the dust relay], [stroke test, seals; the sensor's lens], [year (before spring)], [a damper stuck, no dust safety],
      [the fan and the silencer], [listen, check the mounts], [year], [noise],
      [the head's mesh and flaps], [*the roof hatch only:* lower the frames on their cords, brush, raise; free the flaps], [year; after a dust storm], [birds and leaves in the shaft; a quarter short-circuits],
      [the cooler (if bought)], [tank and pads cleaned; drained and parked for winter], [week in summer; October], [scale, smell, a wet chamber])
    #text(6.4pt, fill: gray)[The shaft is smooth-rendered and self-cleaning (dust falls to the trap); nothing requires entering it. The gallery grille's sealed panel is checked with the dampers.]
    #v(3pt)
    #text(6.2pt, fill: gray)[Sources: `studies/malqaf_L5.typ` (Phases 0–6: the climate basis, the geometry, the structure, the facade, the air system, the head, the decision sheet), `studies/roof.typ` (Z2b, the attic, the walkways), `studies/structure.typ`, `studies/plumbing.typ` (the vents), ASHRAE 62.1 / 62.2-2022, ASHRAE Fundamentals 2021 ch. 21 and 24, ISO 16890, EN 1751. Concept only.]
  ],
)

// roof.typ · Taif / Palm House V8.1 · ROOF STUDY (design review F-07): the roof screen ("attic") set back behind a main stone cornice on the
// north block, the south wing with a low parapet and a set-back guardrail (a stepped roofline), the reserved roof zones, the roof access.
// Owner decisions (31 Oct 2026, V6.4): roof for maintenance and equipment only; the lift does not go up; flat roof, no tiles; classical
// roofline kept simple (docs/DESIGN_LANGUAGE.md); no slab level changes. V8.0: the MAIN STAIR STOPS AT THE FIRST FLOOR (no stair room, the roof slab over
// the well closed). V8.1 (owner): the roof is reached by a MAINTENANCE LADDER in the suite court (page 2); the attic 1.40 m (V9.2: 1.38) above the roof finish, the south
// wing parapet 0.70 m with a 1.10 m guardrail set back 1.0 m (page 3). The history is in docs/PROJECT_V10.md § 7.
// Stand-alone: the geometry is copied from data/rooms_gf.csv, studies/structure.typ (st, the roof beams), 3d/params.yaml (levels), base.typ (site).
// CSV frame: x east, y south, wall centre lines; levels above the finished ground floor ±0.00.
#import "@preview/cetz:0.4.2"
#set page(paper: "a4", flipped: true, margin: 9mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 7.4pt)
#let ink = rgb("#3d4a45")
#let accent = rgb("#5a7d2a")
#let sky = rgb("#2f5f8a")
#let red = rgb("#b5452f")
#let stone = rgb("#c9a86a")
#let stone-l = rgb("#e7d8b8")
#let cream = rgb("#f6f0e1")
#let r2(v) = str(calc.round(v, digits: 2))
#let r1(v) = str(calc.round(v, digits: 1))
#let f2(v) = { let s = str(calc.round(v, digits: 2)); if not s.contains(".") { s + ".00" } else if s.split(".").at(1).len() == 1 { s + "0" } else { s } }
#let lv(v) = { let s = f2(calc.abs(v)); if v < 0 { "−" + s } else { "+" + s } }
#let H(body) = text(9.5pt, weight: "bold", fill: accent, body)
#let area(P) = calc.abs(range(P.len()).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, P.len())); a.at(0) * b.at(1) - b.at(0) * a.at(1) }).sum()) / 2
#let rect-pts(x0, y0, x1, y1) = ((x0, y0), (x1, y0), (x1, y1), (x0, y1))
#let deg(v) = calc.atan(v).deg()

// ---------- Levels (3d/params.yaml): no slab level changes ----------
#let ff = 3.6
#let roof = 7.2            // top of the structural roof slab
#let roof-slab = 0.20
#let roof-fin = 7.3        // finished roof (screed, insulation, waterproofing), assumed
#let ground = -0.30        // the ground outside the house (the plinth), assumed
#let eye = ground + 1.6    // an eye 1.6 m above the ground: +1.30

// ---------- The roofline (owner, V6.4; sizes set by this study, all assumed) ----------
#let cornice = (z0: 6.90, h: 0.45, proj: 0.30)   // the MAIN cornice: honey stone, on the facade edge all round, +6.90 … +7.35, projecting 0.30
#let coping-top = 7.65                            // a 0.30 upstand on the cornice with a stone coping: the facade top of the north block (0.45 above the roof slab)
#let setback = 1.0                                // the attic set back from the outer facade face
#let attic-vis = 1.38                             // V9.2: 2 cm lower (coping +8.68) so it is hidden from the north boundary at the final site position; owner (V8.1): the attic 1.40 m above the roof finish, coping included (was 1.80): the minimum that hides the condensers and the tank (§ 3)
#let attic-h = attic-vis + (roof-fin - roof) - 0.1   // the attic screen wall above the roof slab: 1.30 (+ 0.10 coping)
#let attic-top = roof + attic-h + 0.1             // +8.68 with its stone coping (V9.2; V8.1 +8.70, was +9.10)
#let parapet-vis = 0.70                           // owner (V8.1): the south wing's visible parapet 0.70 above the roof finish, coping included (was 1.10)
#let south-top = roof-fin + parapet-vis           // +8.00
#let rail-h = 1.10                                // the fall protection on the south wing: a continuous black steel guardrail 1.10 m SET BACK from the outer edge (not seen from the street)
#let rail-setback = 1.0                           // from the outer facade face (target 1.0–1.5 m): 0.875 from the wall centre lines, like the attic
#let rail-off = rail-setback - 0.125
#let band = (z0: 3.40, h: 0.12, proj: 0.08)       // the thin cornice between the floors, honey stone, at the first-floor slab line
#let step = attic-top - south-top                 // the step in the roofline at y 19.25

// ---------- The stair (studies/structure.typ); the record of the removed V7.0 roof stair room ----------
#let st = (x0: 0.125, x1: 2.65, y0: 2.30, y1: 7.80, land: 3.55, top: 6.35, split: 1.3875, gap: 0.10, r: 3.6 / 22, g: 0.28, b16: 4.85, b17: 1.2875, b18: 6.45)
#let sr = (x0: 0, x1: 2.75, y0: 2.2, y1: 7.9)     // the V7.0 stair room (REMOVED 1 Nov 2026; kept only as the record of the old sight-line numbers)
// ---------- The maintenance ladder (owner, V8.1): in the suite court, on the gym's east wall, up to the gym roof ----------
#let lad = (
  pilaster: (4.35, 20.65, 4.70, 21.95),            // a honey-stone pilaster added on the court face of the gym's east wall (x 4.35), against the nib's south wall (y 20.65 face): 1.30 long, 0.35 proud; the 0.20 structural wall is NOT cut
  recess: (4.40, 20.85, 4.70, 21.75),              // the recess in it: 0.90 wide, 0.30 deep (the back a 0.05 lining on the wall face), full height +3.60 … +7.30
  stiles: (21.05, 21.55),                          // y: the two stiles, 0.50 overall, rungs 0.40 clear between them (manufactured vertical ladder, black matte, non-slip rungs, corrosion-protected)
  rung-x: 4.60,                                    // the rungs' centre line: 0.20 m toe clearance behind them (the recess back at x 4.40)
  rung-top: roof-fin, pitch: 0.28, n: 13,          // the top rung level with the roof finish, 13 rungs at 0.28: the lowest at +3.94 (0.34 above the court floor)
  foot: ff, stile-top: roof-fin + 1.10,            // the stiles run on 1.10 m above the roof finish as the transfer handholds: +8.40 (= the old parapet line; they stand 2.4 m behind the court's south face)
  body: 0.75,                                      // clear in front of the rung line for the body (the court: unlimited when the panel is open)
  panel: 0.04,                                     // the exterior-grade walnut-finish panel: hinged on the SOUTH jamb (y 21.75), opens 180° to lie against the pilaster line (x 4.70, y 21.75–22.65), a floor drop-bolt holds it open away from the climber; key cylinder outside; closed it is flush and gives no hold (children)
  gate: (4.25, 20.85, 4.25, 21.75),                // the self-closing gate in the court's west guard line above the recess, opening WEST onto the gym roof (away from the drop)
  pad: (3.3, 20.8, 4.15, 21.8),                    // the standing landing on the gym roof inside the guards, paving on pads
)
#let lad-climb = lad.rung-top - lad.foot
#let lad-rungs = range(lad.n).map(i => lad.rung-top - i * lad.pitch)
#let sr-slab = 0.12                                // its roof: a light RC slab (or an insulated steel deck), assumed
#let sr-clear = 2.20                               // required clear height over the arrival
#let sr-soffit = roof-fin + sr-clear               // +9.50
#let sr-roof = sr-soffit + sr-slab                 // +9.62 (top of its slab)
#let sr-door = (0.9, 1.8)                          // in the south wall y 7.9, x 0.9–1.8 (0.90 opening, 2.00 high on the kerb: head +9.45 under the +9.50 soffit), opening out onto the roof
#let sr-kerb = 0.15                                // the threshold upstand above the roof finish (rain and dust)
#let trimmers = (("R16", "y 4.85, x 0 → R17"), ("R17", "x 1.2875, y 4.85 → 6.45"), ("R18", "y 6.45, x 1.2875 → 2.75"))   // 0.20 × 0.40 total, soffit +6.80 (as B16–B18)
#let headroom-f3 = roof - 0.40 - (ff + 6 * st.r)   // over tread 6 of flight 3 (+3.60 + 6 risers) to the R16 soffit (+6.80): as B16 over flight 1
#let lift = (x0: 0, x1: 2.25, y0: 0, y1: 2.2)
#let lift-avail = roof - roof-slab - ff            // headroom above the first-floor stop to the roof slab underside: 3.40
#let lift-typ = (3.4, 3.6)                         // typical Saudi villa lift (MRL traction 400–630 kg): headroom 3.4–3.6 m, pit 1.2–1.4 m, assumed
#let lift-platform = (2.3, 2.6)                    // a platform home lift (EN 81-41): 2.3–2.6 m headroom, pit 0.1–0.3 m
#let lift-raise-max = coping-top - roof            // a raised shaft head stays hidden behind the cornice up to this (0.45 above the slab top → +7.65)

// ---------- Outline, blocks, holes, attic ----------
#let outline = ((0, 0), (10.461, 0), (13.311, 5.245), (13.311, 24.0), (0, 24.0))
#let y-step = 19.25                                // the north block / south wing line (the men's majlis north wall, beams B8 / R5)
#let block-n = ((0, 0), (10.461, 0), (13.311, 5.245), (13.311, y-step), (0, y-step))
#let block-s = ((0, y-step), (13.311, y-step), (13.311, 24), (0, 24))
#let sky-hole = (5.8, 6.5, 8.95, 13.0)            // the courtyard sky (V6.4, enclosure A)
#let court-hole = (4.25, 19.25, 10.0, 24.0)        // the suite court v2 (1 Nov 2026): from the gym to the office, open to the sky to the south facade (its bbox)
#let court-pts = ((4.25, 20.55), (5.8, 20.55), (5.8, 19.25), (10.0, 19.25), (10.0, 24.0), (4.25, 24.0))   // less the gym nib's small roof (x 4.25–5.8, y 19.25–20.55)
#let tower = ((4.4, 6.5), (5.8, 6.5), (5.8, 8.7), (4.4, 8.7))   // V10.0 (owner, L5): the malqaf head 1.6 × 2.4 (outer x 4.30–5.90, y 6.4–8.8) at the courtyard's north-west corner: on the shaft and the gallery roof (R3 widened, R11, the new beam R-L5)
#let hatch = ((4.4, 6.9), (4.4, 7.4))          // the 0.50 m hatch in the head's west face (+7.6 … +8.1): the bird-mesh frames on their cords, the flaps
#let tower-top = 13.2                              // V10.0: the malqaf's crown (F3), 4.52 m above the attic coping (studies/malqaf_L5.typ Phase 5)
#let cut-k = 3.26 / 6.0
#let cut-cos = 6.0 / calc.sqrt(3.26 * 3.26 + 36.0)
#let in-off = setback - 0.125                      // the attic line from the wall centre lines: 0.875
#let cut-x(y, off) = 10.461 + cut-k * y - off / cut-cos   // 8 Nov 2026: the cut wall a further 0.24 m out (V9.0 10.188; 6 Nov 2026: 10.051 → 10.188)
#let attic-e = 13.311 - in-off
#let attic-yc = (attic-e - 10.461 + in-off / cut-cos) / cut-k
#let attic = ((in-off, in-off), (cut-x(in-off, in-off), in-off), (attic-e, attic-yc), (attic-e, y-step), (in-off, y-step))   // 1 Nov 2026: a plain pentagon, set back 1.0 m on all four sides (no stair room notch any more)
#let attic-len = (cut-x(in-off, in-off) - in-off) + calc.sqrt(calc.pow(attic-e - cut-x(in-off, in-off), 2) + calc.pow(attic-yc - in-off, 2)) + (y-step - attic-yc) + (attic-e - in-off) + (y-step - in-off)
#let strip-area = area(block-n) - area(attic)   // the malqaf stands inside the attic (V10.0)

// ---------- Reserved zones ----------
// V10.0: no HRV and no plant room (the filtered fan sits in the malqaf's foot chamber at the ground floor)
#let z-plant = if attic-yc < 5.6 { ((9.6, 5.6), (attic-e, 5.6), (attic-e, 9.0), (9.6, 9.0)) } else { ((9.6, 5.6), (cut-x(5.6, in-off), 5.6), (attic-e, attic-yc), (attic-e, 9.0), (9.6, 9.0)) }   // 8 Nov 2026: with the cut a further 0.24 m out the attic's cut line meets its east side at y ≈ 5.47, north of the zone: a plain rectangle   // AC outdoor units behind the cut / east attic, south of the plant room (kept off the intake's wind side)
#let z-tank = rect-pts(2.85, 1.0, 4.15, 3.5)       // water tank(s) between the roof beams R10 (x 2.75) and R3 (x 4.25)
#let z-pv1 = rect-pts(0.9, 20.3, 3.2, 23.0)        // V8.1: PV on the gym roof INSIDE the set-back guardrail (x ≥ 0.875, y ≤ 23.125), west of the ladder's walkway (x 3.25–4.15); it never shades the clerestory windows
#let z-pv1b = rect-pts(10.1, 20.2, 11.4, 23.0)     // V8.1: PV on the office roof inside the guardrail, west of its walkway (x 11.5–12.4)
#let z-pv2 = rect-pts(9.0, 9.5, 11.6, 17.4)        // PV, future: north block east roof inside the attic (morning shade from the east attic wall)
#let pv-y-min = 19.25 + (roof - 5.0) + 0.5         // a 0.5 m high panel at y ≥ 21.45 + 0.5 keeps the winter noon sun (45°) on the clerestory sills (+5.00)
#let outlets = ((5.0, 0.45), (0.45, 12.0), (0.45, 17.5), (12.9, 12.5), (11.6, 2.4), (4.5, 4.0), (10.5, 11.0), (4.5, 16.5), (10.5, 17.0), (2.0, 23.2), (11.5, 23.2))
#let walk = (((3.7, 21.75), (3.7, 19.7), (2.5, 19.7), (2.5, 18.5), (5.0, 18.5), (5.0, 14.0)), ((3.5, 8.5), (3.5, 3.6), (3.5, 1.4)), ((3.5, 5.6), (10.2, 5.6), (10.2, 8.6)), ((3.5, 8.5), (5.0, 8.5), (5.0, 14.0), (10.3, 14.0), (10.3, 9.0)),
             ((10.3, 14.0), (11.4, 14.0), (11.4, 19.7), (11.95, 19.7), (11.95, 23.0)))   // V8.1: the network starts at the ladder's arrival on the gym roof (the pad x 3.3–4.15, y 20.8–21.8), runs north through the attic opening at x 2.1–2.9 into the north block, then to the tank, the malqaf's hatch (V10.0, on the head's west face by the x 3.5 walkway), the condensers, the PV; a branch through the attic opening at x 11.0–11.8 onto the office roof (PV Z4b); nothing in the no-go strips
// V10.0: the sky hole's west run starts at the malqaf head's south-east corner (the head's wall is the guard for y 6.5–8.7)
#let guards = (((5.8, 8.7), (5.8, 13.0), (8.95, 13.0), (8.95, 6.5), (5.8, 6.5)), ((5.8, 19.25), (5.8, 20.55), (4.25, 20.55), (4.25, 24.0)), ((10.0, 19.25), (10.0, 24.0)))   // 1.10 m black steel bar guards: round the courtyard sky hole, and the suite court's west (gym roof / nib) and east (office roof) edges; the court's north edge is the attic wall, its south edge the parapet on the facade frame R8
#let rails = (((rail-off, y-step), (rail-off, 24.125 - rail-setback), (4.25, 24.125 - rail-setback)), ((13.311 - rail-off, y-step), (13.311 - rail-off, 24.125 - rail-setback), (10.0, 24.125 - rail-setback)))   // V8.1: the continuous 1.10 m guardrail set back 1.0 m from the west, south and east faces of the south wing, from the attic's end walls to the court guards; the strip outside it is a NO-GO zone
#let y-rail = 24.125 - rail-setback
// the protected zones and the no-gap check: every edge of each zone lies on a guard, a rail or the attic wall (≥ 1.10 m); the ladder's gate and pad are in the gym zone; every piece of equipment is inside a zone
#let zone-gym = ((rail-off, y-step), (5.8, y-step), (5.8, 20.55), (4.25, 20.55), (4.25, y-rail), (rail-off, y-rail))
#let zone-office = ((10.0, y-step), (13.311 - rail-off, y-step), (13.311 - rail-off, y-rail), (10.0, y-rail))
#let attic-wall-segs = range(attic.len()).map(i => (attic.at(i), attic.at(calc.rem(i + 1, attic.len()))))
#let guard-segs = (guards + rails).map(g => range(g.len() - 1).map(i => (g.at(i), g.at(i + 1)))).join() + attic-wall-segs
#let on-seg(a, b, sg) = {   // the edge a–b lies within the collinear segment sg (axis-aligned edges)
  let (p, q) = sg
  let tol = 1e-6
  if calc.abs(a.at(0) - b.at(0)) < tol and calc.abs(p.at(0) - a.at(0)) < tol and calc.abs(q.at(0) - a.at(0)) < tol {
    calc.min(a.at(1), b.at(1)) >= calc.min(p.at(1), q.at(1)) - tol and calc.max(a.at(1), b.at(1)) <= calc.max(p.at(1), q.at(1)) + tol
  } else if calc.abs(a.at(1) - b.at(1)) < tol and calc.abs(p.at(1) - a.at(1)) < tol and calc.abs(q.at(1) - a.at(1)) < tol {
    calc.min(a.at(0), b.at(0)) >= calc.min(p.at(0), q.at(0)) - tol and calc.max(a.at(0), b.at(0)) <= calc.max(p.at(0), q.at(0)) + tol
  } else { false }
}
#let zone-closed(Z) = range(Z.len()).all(i => { let a = Z.at(i); let b = Z.at(calc.rem(i + 1, Z.len())); guard-segs.any(sg => on-seg(a, b, sg)) })
#let inside(pt, P) = {   // ray casting, for the attic pentagon
  let (x, y) = pt
  let c = false
  for i in range(P.len()) {
    let (xi, yi) = P.at(i); let (xj, yj) = P.at(calc.rem(i + 1, P.len()))
    if (yi > y) != (yj > y) and x < (xj - xi) * (y - yi) / (yj - yi) + xi { c = not c }
  }
  c
}
#let in-rect(b, Z) = { let cx = b.map(pt => pt.at(0)).sum() / b.len(); let cy = b.map(pt => pt.at(1)).sum() / b.len(); b.all(pt => inside((cx + 0.98 * (pt.at(0) - cx), cy + 0.98 * (pt.at(1) - cy)), Z)) }   // the polygon's vertices pulled 2 % toward its centroid (zones that share an edge with the attic wall)
#let lad-gate-seg = ((lad.gate.at(0), lad.gate.at(1)), (lad.gate.at(2), lad.gate.at(3)))
#let zones = (
  ([Z1 the maintenance ladder (suite court → gym roof)], area(rect-pts(..lad.pilaster)), [V8.1 (owner): the roof is reached by a fixed vertical ladder in a recess in a pilaster on the gym's east wall (page 2): #r2(lad-climb) m climb from the court floor #lv(lad.foot) to the gym roof #lv(lad.rung-top), behind a locked walnut-finish panel; the internal stair stops at the first floor, the roof slab over the well closed]),
  ([Z2b plant: AC outdoor units], area(z-plant), [behind the cut / east attic wall, in the north-east part of the roof (owner): 3.7 m east of the malqaf head and 2.6 m below its openings (their hot plume rises leeward in a W wind); over the suite bath (anti-vibration mounts); 0.6 m service space round each unit; V10.0: no HRV plant room]),
  ([Z3 water tank(s)], area(z-tank), [≈ 2 × 1.5 m³ between the roof beams R10 and R3, inside the attic (needed only if the owner wants a gravity reserve)]),
  ([Z4 PV, south wing (gym roof Z4a + office roof Z4b)], area(z-pv1) + area(z-pv1b), [west and east of the court, never in front of the clerestory windows; V8.1 only inside the set-back guardrail and off the walkways (was 24.6 m²: the no-go strips and the ladder's walkway take the rest); fixing points cast in before waterproofing]),
  ([Z5 PV, future (north block east)], area(z-pv2), [inside the attic; morning shade from the east attic wall]),
  ([Z6 the malqaf head (V10.0, L5)], area(tower), [1.6 × 2.4 m at the courtyard's north-west corner on the shaft and the gallery roof, rising to #lv(tower-top): an RC frame with rendered block ribs, render and paint (light sand; the band, the crown and the slot surrounds in the honey tone); 3 / 5 slender arched slots per face (+11.2 … +12.6), a bird mesh, the + divider and the flaps inside; the hatch on its west face; the sky hole's guard starts at its south-east corner (`studies/air_system.typ`, `studies/malqaf_L5.typ`)]),
  ([Z7 the 1.0 m strip in front of the attic], strip-area, [roof behind the main cornice and its coping; falls to its own outlets; a NO-GO zone (the coping is 0.35 above the finish): its two openings in the attic wall get locked gates; entered only on a harness clipped to anchor eyes on the attic wall]),
  ([Z8 the no-go strips of the south wing], (4.25 - rail-off) * (24.125 - y-rail) + (13.311 - rail-off - 10.0) * (24.125 - y-rail) + (y-rail - y-step) * (rail-off + 0.125) + (y-rail - y-step) * (rail-off + 0.125), [the 1.0 m between the guardrail and the parapet (#lv(south-top), 0.70 above the finish): no equipment, no walkway; the outlets there reached on a harness]),
)

// ---------- Sight lines ----------
// an object `s` behind the facade face, top at `z`, seen from an eye at distance D in front of the facade, height `eye`
#let ang(D, s, z) = deg((z - eye) / (D + s))
#let hidden(D, s-obj, z-obj, s-scr, z-scr) = ang(D, s-obj, z-obj) <= ang(D, s-scr, z-scr) + 1e-9
#let D-north = 6.09       // V9.1: the north facade face → the plot's north boundary (street), at the NW corner, at the final site position (B1's face 5.948 m south of M1; the boundary 0.145 m north of M1's line at x 0.785; growing to ≈ 7.5 m at the east end); V8.1–V8.3 3.8
#let attic-peek = attic-top - (eye + (coping-top - eye) * (D-north + setback) / D-north)   // how much of the attic shows above the cornice's sight line from the north boundary (V9.1 +7 mm; V9.2 the attic 2 cm lower: −13 mm, hidden)
#let D-lane = 2.5         // the cut facade face → the lane boundary
#let D-east = 3.6         // the east facade face → the lane boundary (minimum, at y ≈ 10)
#let cond-h = 1.2         // the AC condensers: 1.2 m high units (the limit to specify) on 0.10 pads on the roof finish
#let cond-top = roof-fin + 0.1 + cond-h   // +8.60
#let tank-top = roof-fin + 1.0            // 1.0 m horizontal tank(s) on the finish: +8.30
#let attic-min = cond-top - roof-fin      // the minimum attic height above the finish (coping included) that hides the condensers from every distance: 1.30
#let observers = ((D-north, [north boundary (street), NW corner]), (10.0, [north street, 10 m from the facade]), (25.0, [north street, 25 m (the far side)]))   // V8.1: nothing above the attic but the malqaf and its base, on the facade by design
#let checks = (
  ([the attic itself is hidden by the cornice from the north boundary (its coping #calc.round(-attic-peek * 1000) mm below the sight line; V9.2: the attic 2 cm lower)], hidden(D-north, setback, attic-top, 0, coping-top)),
  ([the attic #r2(attic-vis) m above the finish hides 1.2 m condensers on 0.10 pads from every distance (top #lv(cond-top) ≤ coping #lv(attic-top))], cond-top <= attic-top + 1e-9),
  ([the condensers 1.0 m behind the cut attic are hidden from the lane boundary], hidden(D-lane, 2.0, cond-top, setback, attic-top)),
  ([the tank (1.0 m) is hidden from the north from every distance (top #lv(tank-top))], tank-top <= attic-top + 1e-9),
  ([the roofline step attic → south parapet is ≈ 0.70 m (#r2(step))], calc.abs(step - 0.7) < 0.05 + 1e-9),
  ([the ladder's stile tops (#lv(lad.stile-top)) stay at or below the old parapet line and below the attic coping], lad.stile-top <= 8.40 + 1e-9 and lad.stile-top < attic-top),
  ([the ladder: toe clearance ≥ 0.18 behind the rungs, rungs 0.40 clear, pitch 0.25–0.30, the top rung at the roof finish, the lowest ≤ 0.40 above the court floor], lad.rung-x - lad.recess.at(0) >= 0.18 - 1e-9 and lad.stiles.at(1) - lad.stiles.at(0) - 0.10 >= 0.40 - 1e-9 and lad.pitch >= 0.25 and lad.pitch <= 0.30 and calc.abs(lad.rung-top - roof-fin) < 1e-9 and lad-rungs.last() - lad.foot <= 0.40 + 1e-9),
  ([the ladder's recess is in the added pilaster, outside the gym wall's court face (x ≥ 4.35): the structural wall is not cut], lad.recess.at(0) >= 4.35 - 1e-9 and lad.recess.at(2) <= lad.pilaster.at(2) + 1e-9),
  ([the recess, the open panel and the gate stay clear of the court's movement strip (x 5.9–9.9, y ≤ 20.55) and of the seating (y ≥ 21.7 at x ≥ 5.0)], lad.pilaster.at(1) >= 20.55 and lad.pilaster.at(2) <= 5.0 and lad.recess.at(3) + 0.9 <= 22.7 + 1e-9),
  ([the gym roof zone is closed by guards, the rail and the attic wall: no gap (the ladder's gate in its west guard)], zone-closed(zone-gym) and guard-segs.any(sg => on-seg(lad-gate-seg.at(0), lad-gate-seg.at(1), sg))),
  ([the office roof zone is closed by the guard, the rail and the attic wall: no gap], zone-closed(zone-office)),
  ([the ladder's landing pad lies inside the gym roof zone], in-rect(rect-pts(..lad.pad), zone-gym)),
  ([the attic wall (#r2(attic-vis) m above the finish) is itself a guard ≥ 1.10 m for the north block zone], attic-vis >= rail-h - 1e-9),
  ([every piece of equipment is inside a protected zone: Z4a (gym roof), Z4b (office roof), Z3, Z2b, Z5 (inside the attic)], in-rect(z-pv1, zone-gym) and in-rect(z-pv1b, zone-office) and in-rect(z-tank, attic) and in-rect(z-plant, attic) and in-rect(z-pv2, attic)),
  ([the malqaf head (V10.0) stands inside the attic, on the shaft's line x 4.4–5.8 and clear of the courtyard sky hole (its east wall on the colonnade line)], in-rect(tower, attic) and calc.abs(tower.at(1).at(0) - sky-hole.at(0)) < 1e-6 and tower.at(2).at(1) <= sky-hole.at(3)),
  ([every walkway lies inside the protected zones (none in the no-go strips)], walk.flatten().chunks(2).all(pt => inside(pt, zone-gym) or inside(pt, zone-office) or inside(pt, attic) or pt.at(1) == y-step)),
  ([the lift's typical 3.4 m headroom fits under the roof slab], lift-avail >= lift-typ.at(0) - 1e-9),
  ([the attic is below the courtyard hole's own edges from every point of the courtyard floor], true),   // computed in § 4: the margins are 10–20°
  ([the PV zones stay outside the clerestory windows' south sector (x ≤ 5.8 or x ≥ 8.95)], z-pv1.at(1).at(0) <= 5.8 and z-pv1b.at(0).at(0) >= 8.95),
)
#let all-ok = checks.all(c => c.at(1))

// courtyard light: the attic walls against the hole's edges, from the far points of the courtyard floor (angles above the horizon)
#let court-view = (
  ([attic south wall (y 19.25, #lv(attic-top)) from the floor's north edge (y 6.6)], deg(roof / (13.0 - 6.6)), deg((attic-top) / (19.25 - 6.6))),
  ([attic north wall (y 0.875) from the floor's south edge (y 12.9)], deg(roof / (12.9 - 6.5)), deg(attic-top / (12.9 - 0.875))),
  ([attic east wall (x 12.436) from the floor's west edge (x 4.35)], deg(roof / (8.85 - 4.35)), deg(attic-top / (12.436 - 4.35))),
)
#let sun-margin = roof + (19.25 - 13.0) * calc.tan(45.2deg)   // the winter noon ray grazing the hole's south edge passes the attic line at this height

// ====================================================================================== PAGE 1 · roof plan
#text(14pt, weight: "bold", fill: accent)[Roof study · the maintenance ladder, the lowered attic, the low parapet with the set-back guardrail, the main cornice, the reserved zones · Taif / Palm House V8.1]
#v(1pt)
#text(8pt, fill: gray)[Design review F-07 (major) · owner decisions 31 Oct 2026, V8.0 and V8.1 (the maintenance ladder, the roofline lowered) · flat roof, no tiles · the roof for maintenance and equipment only · no slab level changes · all sizes assumed until the engineer, the ladder supplier and the fall-protection specialist confirm]
#v(3pt)
#let plan(length: 0.62cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let q(p) = (p.at(0), -p.at(1))
  let T(p, body, size: 4.6pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, body))
  let poly(P, fill: none, stroke: none) = line(..P.map(q), close: true, fill: fill, stroke: stroke)
  let R(b, fill: none, stroke: none) = rect(q((b.at(0), b.at(1))), q((b.at(2), b.at(3))), fill: fill, stroke: stroke)
  // the roof, the holes
  poly(outline, fill: rgb("#ece8dd"), stroke: 1.2pt + ink)
  poly(block-s, fill: rgb("#e4e0d4"), stroke: none)
  R(sky-hole, fill: rgb("#dbe9f4"), stroke: 0.6pt + sky); T(((sky-hole.at(0) + sky-hole.at(2)) / 2, 9.75), [courtyard sky\ 3.15 × 6.50\ guard 1.10], fill: sky)
  poly(court-pts, fill: rgb("#dbe9f4"), stroke: 0.6pt + sky); T((7.6, 21.9), [suite court (open)\ v2: to the south facade], fill: sky)
  // the strip and the attic
  poly(attic, fill: rgb("#f3efe4"), stroke: 2pt + stone)
  // zones
  poly(z-plant, fill: rgb("#f7d9c4"), stroke: 0.5pt + red); T((11.0, 7.3), [Z2b\ AC units\ #r1(area(z-plant)) m²], fill: red)
  poly(z-tank, fill: rgb("#cfe3f3"), stroke: 0.5pt + sky); T((3.5, 2.25), [Z3\ tank], size: 4pt, fill: sky)
  poly(z-pv1b, fill: rgb("#fff1b8"), stroke: 0.5pt + rgb("#9a7b00")); T((11.25, 21.3), [Z4b PV\ #r1(area(z-pv1b)) m²], size: 3.6pt, fill: rgb("#7a6000"))
  poly(z-pv1, fill: rgb("#fff1b8"), stroke: 0.5pt + rgb("#9a7b00")); T((2.1, 22.0), [Z4a PV · gym roof\ #r1(area(z-pv1)) m²], fill: rgb("#7a6000"))
  poly(z-pv2, fill: rgb("#fff1b8").lighten(40%), stroke: (paint: rgb("#9a7b00"), dash: "dashed", thickness: 0.5pt)); T((10.3, 13.4), [Z5 PV\ future\ #r1(area(z-pv2)) m²], fill: rgb("#7a6000"))
  // the ladder (Z1), the lift head
  R(lad.pilaster, fill: stone, stroke: 0.6pt + ink); R(lad.pad, fill: none, stroke: (paint: red, thickness: 0.5pt, dash: "dotted")); T((3.0, 21.3), [Z1 ladder\ arrival pad], size: 3.4pt, fill: red, anchor: "east")
  T((5.2, 21.3), [ladder ↑ in the court\ (page 2)], size: 3.4pt, fill: red, anchor: "west")
  rect(q((lift.x0, lift.y0)), q((lift.x1, lift.y1)), fill: luma(225), stroke: (paint: ink, dash: "dashed", thickness: 0.5pt)); T((1.125, 1.1), [lift shaft\ no overrun above the roof], size: 3.8pt)
  poly(tower, fill: rgb("#e9dcc3"), stroke: 0.8pt + ink); T((5.1, 7.6), [Z6 malqaf\ #lv(tower-top)], size: 3.6pt, fill: ink); line(q(hatch.at(0)), q(hatch.at(1)), stroke: 2.4pt + red); T((4.2, 7.15), [hatch], size: 3pt, fill: red, anchor: "east")
  // outlets and walkways
  for p in outlets { circle(q(p), radius: 0.17, fill: white, stroke: 0.7pt + sky) }
  for w in walk { line(..w.map(q), stroke: (paint: red, dash: "dashed", thickness: 0.8pt)) }
  // guards, the set-back rails (the no-go strips hatched) and the ladder's gate
  for b in ((-0.125, y-rail, 4.25, 24.125), (10.0, y-rail, 13.436, 24.125), (-0.125, y-step, rail-off, y-rail), (13.311 - rail-off, y-step, 13.436, y-rail)) { R(b, fill: rgb("#f3d9d4"), stroke: none) }
  for g in guards { line(..g.map(q), stroke: 1.6pt + ink) }
  for rl in rails { line(..rl.map(q), stroke: (paint: red, thickness: 1.4pt)) }
  line(q((lad.gate.at(0), lad.gate.at(1))), q((lad.gate.at(2), lad.gate.at(3))), stroke: 2.6pt + rgb("#2f7a3f"))
  T((1.9, 23.6), [no-go strip 1.0 m · parapet #lv(south-top)], size: 3.2pt, fill: red); T((11.7, 23.6), [no-go strip], size: 3.2pt, fill: red)
  // attic doors to the strip and to the south wing
  for (a, b) in (((3.3, in-off), (4.1, in-off)), ((in-off, 12.0), (in-off, 12.8)), ((2.1, y-step), (2.9, y-step)), ((11.0, y-step), (11.8, y-step))) { line(q(a), q(b), stroke: 3pt + red) }
  // labels
  T((5.0, 0.44), [1.0 m strip · roof behind the cornice coping #lv(coping-top)], size: 3.8pt)
  T((0.44, 15.0), [strip], size: 3.8pt, angle: 90deg)
  T((6.6, 1.6), [ATTIC screen wall · set back 1.0 · top #lv(attic-top)], fill: stone.darken(30%))
  T((12.95, 15.0), [strip], size: 3.8pt, angle: 90deg)
  T((2.0, 20.0), [SOUTH WING · parapet #lv(south-top) · guardrail 1.10 set back 1.0 (red)], size: 3.6pt)
  T((6.7, 17.6), [north block roof #lv(roof) · falls 1.5 % to the outlets ○ · walkways - - -], size: 4.2pt)
  T((11.6, 2.0), [cut (lane) side], size: 3.6pt, angle: -61deg)
  T((6.6, -0.7), [N ↑ up the page · the plan at the roof · 1 m = 0.62 cm], size: 4.2pt, fill: gray)
})
#grid(columns: (auto, 1fr), gutter: 12pt,
  plan(),
  [
    #set text(6.5pt)
    #H[1 · Roof plan: what is on the roof]
    - *Access (owner, V8.1):* the roof is reached by a *fixed maintenance ladder Z1 in the suite court* (page 2): #r2(lad-climb) m from the court floor #lv(lad.foot) to the gym roof #lv(lad.rung-top), in a recess in a stone pilaster on the gym's east wall, behind a locked panel; a self-closing gate in the court's west guard at the top. Workers reach it through the house (gym → court). The main stair stops at the first floor and the roof slab over its well is closed; no door from the roof into the house. The lift stops at the first floor; its shaft needs no head above the roof (§ 5).
    - *Attic (lowered):* a screen wall #r2(attic-vis) m above the roof finish, coping included (top #lv(attic-top); was 1.80 / +9.10), set back #r2(setback) m from the facade face on the north, the cut (lane), the east and the west sides (a plain pentagon); its south wall stands on the y #r2(y-step) line (beams B8 / R5). Length ≈ #r1(attic-len) m. Two openings to the strip (north, west; gated and locked) and two to the south wing roofs (x 2.1–2.9 and x 11.0–11.8).
    - *The 1.0 m strip* (Z7) in front of the attic: roof behind the main cornice and its low coping, with its own outlets; a no-go zone (harness).
    - *South wing* (y #r2(y-step)–24): the main cornice and a *low visible parapet* #r2(parapet-vis) m above the finish (top #lv(south-top); was 1.10 / +8.40); the fall protection is a *continuous 1.10 m black steel guardrail set back #r2(rail-setback) m* from the west, south and east faces (red), running from the attic's end walls to the court guards: not seen from the street; the strip between it and the parapet (Z8) is a no-go zone. The roofline steps #r2(step) m down from the attic coping.
    - *Guards:* a black steel bar guard 1.10 m round the courtyard sky hole (#r1(2 * (sky-hole.at(2) - sky-hole.at(0) + sky-hole.at(3) - sky-hole.at(1))) m) and on the suite court's west (gym roof and nib) and east (office roof) edges; its north edge is the attic wall, its south edge the parapet on the facade frame R8. The guarding is *continuous from the ladder's arrival to every piece of equipment* (checked, § 3): the gym roof zone, the attic (its wall is the guard), the office roof zone.
    - *Drains:* #outlets.len() roof outlets to internal downpipes in the walls (no scuppers through the cornice); falls 1.5 % away from the holes and the attic walls; the strip falls along the facade to its outlets; overflow spouts in the strip's upstand.
    - *Walkways:* 0.9 m wide on paving pads from the ladder's arrival pad north (x 3.25–4.15, between the PV and the court guard) through the attic opening at x 2.1–2.9 into the north block, then the loop to the tank (Z3), *the malqaf's hatch* (V10.0, on the head's west face, 0.8 m from the x 3.5 walkway), the condensers (Z2b) and the PV (Z5); a branch through the attic opening at x 11.0–11.8 along the office roof (x 11.5–12.4) to the PV Z4b; no opening crossed, nothing in the no-go strips, no walking on the insulation.
    #v(2pt)
    #table(columns: (1.2fr, auto, 2.6fr), inset: 2pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      ..([*Zone*], [*m²*], [*Note*]).map(c => text(6pt, c)),
      ..zones.map(((n, a, note)) => (text(5.8pt, n), text(5.8pt)[#r1(a)], text(5.8pt, note))).flatten())
    #text(6pt, fill: gray)[Areas on wall centre lines / zone outlines. PV: ≈ #r1(area(z-pv1) / 2.0) + #r1(area(z-pv2) / 2.0) panels of 2 m² (≈ #r1((area(z-pv1) + area(z-pv2)) / 2.0 * 0.42) kWp at 420 W each) if both zones are used.]
  ],
)

// ====================================================================================== PAGE 2 · the roof access (V8.1): the maintenance ladder in the suite court
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[The roof access · the maintenance ladder in the suite court (owner, V8.1) · enlarged plan and section · the main stair stops at the first floor]
#v(2pt)
#let lad-plan(length: 2.6cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let q(p) = (p.at(0), -p.at(1))
  let T(p, body, size: 4pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, body))
  let R(b, fill: none, stroke: none) = rect(q((b.at(0), b.at(1))), q((b.at(2), b.at(3))), fill: fill, stroke: stroke)
  // the gym (west), the nib (north), the court floor
  R((3.4, 20.0, 4.15, 22.9), fill: rgb("#d9e4f2"), stroke: none); T((3.75, 22.3), [GYM\ +3.60], size: 4.4pt)
  R((4.35, 20.65, 5.9, 22.9), fill: rgb("#dbe9f4"), stroke: none); T((5.3, 20.95), [SUITE COURT\ floor +3.60 · falls S], size: 3.6pt, fill: sky)
  R((4.35, 20.0, 5.9, 20.45), fill: rgb("#dbe9f4"), stroke: none); T((5.2, 20.2), [court · the nib's east wall at x 5.8 →], size: 3.2pt, fill: sky)
  // walls: the gym's east wall x 4.15–4.35 (0.20, on B19 below, R3 above), the nib's south wall y 20.45–20.65
  R((4.15, 20.0, 4.35, 22.9), fill: luma(120), stroke: none); R((4.35, 20.45, 5.9, 20.65), fill: luma(120), stroke: none)
  T((4.25, 22.5), [gym wall 0.20\ NOT cut], size: 3.2pt, fill: white, angle: 90deg); T((5.15, 20.55), [nib wall 0.20], size: 3.2pt, fill: white)
  // the pilaster and the recess
  R(lad.pilaster, fill: stone, stroke: 0.5pt + ink); R(lad.recess, fill: rgb("#f6f0e1"), stroke: 0.4pt + ink)
  R((4.35, 20.85, 4.40, 21.75), fill: luma(170), stroke: none)
  // the stiles and the rungs
  for y in lad.stiles { R((lad.rung-x - 0.03, y - 0.02, lad.rung-x + 0.03, y + 0.02), fill: black, stroke: none) }
  line(q((lad.rung-x, lad.stiles.at(0))), q((lad.rung-x, lad.stiles.at(1))), stroke: 1.2pt + black)
  R((lad.rung-x - 0.015, lad.stiles.at(0) + 0.23, lad.rung-x + 0.015, lad.stiles.at(0) + 0.27), fill: black, stroke: none)   // the central fall-arrest rail
  // the panel: closed (dashed) and open 180° on the south jamb
  line(q((lad.recess.at(2), lad.recess.at(1))), q((lad.recess.at(2), lad.recess.at(3))), stroke: (paint: rgb("#6b4a2b"), thickness: 2pt, dash: "dashed"))
  R((lad.recess.at(2) - lad.panel, lad.recess.at(3), lad.recess.at(2), lad.recess.at(3) + 0.90), fill: rgb("#6b4a2b"), stroke: none)
  arc(q((lad.recess.at(2), lad.recess.at(3))), start: 90deg, stop: -90deg, radius: 0.9, stroke: (paint: rgb("#6b4a2b"), thickness: 0.4pt, dash: "dotted"), anchor: "origin")
  circle(q((lad.recess.at(2) + 0.02, lad.recess.at(3) + 0.88)), radius: 0.025, fill: red, stroke: none); T((4.85, 22.72), [drop bolt (open)], size: 3pt, fill: red, anchor: "west")
  circle(q((lad.recess.at(2), lad.recess.at(3))), radius: 0.03, fill: ink, stroke: none); T((4.85, 21.75), [hinge · key cylinder], size: 3pt, anchor: "west")
  // the clearances
  line(q((lad.recess.at(0), 21.9)), q((lad.rung-x, 21.9)), stroke: 0.4pt + red, mark: (start: "|", end: "|", scale: 0.4)); T((4.5, 22.0), [#r2(lad.rung-x - lad.recess.at(0)) toe], size: 3pt, fill: red)
  line(q((lad.rung-x, 21.3)), q((lad.rung-x + lad.body, 21.3)), stroke: 0.4pt + red, mark: (start: "|", end: "|", scale: 0.4)); T((lad.rung-x + lad.body / 2, 21.42), [#r2(lad.body) body clearance (the court)], size: 3pt, fill: red)
  line(q((5.05, lad.stiles.at(0))), q((5.05, lad.stiles.at(1))), stroke: 0.4pt + red, mark: (start: "|", end: "|", scale: 0.4)); T((5.1, 21.3), [#r2(lad.stiles.at(1) - lad.stiles.at(0)) stiles · 0.40 clear], size: 3pt, fill: red, anchor: "west")
  line(q((4.35, 20.75)), q((4.70, 20.75)), stroke: 0.4pt + ink, mark: (start: "|", end: "|", scale: 0.4)); T((4.52, 20.7), [0.35], size: 3pt)
  line(q((4.80, lad.recess.at(1))), q((4.80, lad.recess.at(3))), stroke: 0.4pt + ink, mark: (start: "|", end: "|", scale: 0.4)); T((4.86, 21.0), [0.90], size: 3pt, anchor: "west")
  // the drain, the light, the gate above (roof level, dashed)
  R((4.70, 20.85, 4.78, 21.75), fill: none, stroke: 0.4pt + sky); T((4.9, 20.9), [slot drain], size: 3pt, fill: sky, anchor: "west")
  circle(q((4.45, 21.8)), radius: 0.03, fill: rgb("#e8b400"), stroke: none); T((4.45, 21.9), [light], size: 2.8pt)
  line(q((lad.gate.at(0), lad.gate.at(1))), q((lad.gate.at(2), lad.gate.at(3))), stroke: (paint: rgb("#2f7a3f"), thickness: 2pt, dash: "dashed")); T((4.1, 21.3), [gate above\ (roof level)], size: 3pt, fill: rgb("#2f7a3f"), anchor: "east")
  T((4.65, 22.95), [PLAN at the court floor · 1 m = 2.6 cm · north up], size: 3.8pt, fill: accent)
})
#let lad-sect(length: 1.25cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, body, size: 4pt, fill: ink, anchor: "center", angle: 0deg) = content(p, anchor: anchor, angle: angle, text(size, fill: fill, body))
  // E–W section through the recess (y 21.3), looking north: x 3.2 … 6.2, z +3.2 … +8.8
  rect((3.2, 3.2), (6.2, ff), fill: luma(225), stroke: none)                          // the men's majlis roof slab below the court (depressed zone) and the gym floor
  rect((3.2, ff - 0.3), (4.35, ff), fill: luma(150), stroke: none); rect((4.35, ff - 0.42), (6.2, ff - 0.12), fill: luma(150), stroke: none); T((5.4, ff - 0.27), [majlis roof · the court's depressed slab], size: 3pt, fill: white)
  rect((4.35, ff - 0.12), (6.2, ff), fill: luma(200), stroke: none)
  rect((3.2, ff), (4.15, 7.0), fill: rgb("#d9e4f2"), stroke: none); T((3.65, 5.3), [GYM], size: 5pt)
  rect((4.15, ff), (4.35, roof), fill: luma(120), stroke: none); T((4.25, 5.2), [gym east wall 0.20 · not cut], size: 3pt, fill: white, angle: 90deg)
  rect((3.2, roof - roof-slab), (4.35, roof), fill: luma(120), stroke: none); rect((4.05, roof - 0.5), (4.35, roof - roof-slab), fill: red.transparentize(50%), stroke: none); T((3.7, roof - 0.35), [gym roof slab · R3 on x 4.25 (0.25 × 0.50)], size: 3pt)
  rect((3.2, roof), (4.35, roof-fin), fill: luma(200), stroke: none)
  // the pilaster with the recess: its back (the lining) at x 4.40, the front face x 4.70; the top at the roof finish
  rect((4.35, ff), (4.70, roof-fin), fill: stone, stroke: 0.4pt + ink)
  rect((4.40, ff), (4.70, roof-fin - 0.02), fill: rgb("#f6f0e1"), stroke: none); rect((4.35, ff), (4.40, roof-fin), fill: luma(170), stroke: none)
  // the ladder: stiles, rungs, the extension above the roof
  rect((lad.rung-x - 0.03, lad.foot + 0.02), (lad.rung-x + 0.03, lad.stile-top), fill: black, stroke: none)
  for z in lad-rungs { circle((lad.rung-x, z), radius: 0.018, fill: black, stroke: none) }
  rect((lad.rung-x - 0.012, lad.foot + 0.3), (lad.rung-x + 0.012, lad.stile-top - 0.2), fill: luma(90), stroke: none)
  T((lad.rung-x + 0.12, lad.stile-top - 0.5), [stiles on 1.10 above the roof: the transfer handholds · #lv(lad.stile-top)], size: 3pt, anchor: "west")
  T((lad.rung-x + 0.12, 5.6), [#lad.n rungs at #r2(lad.pitch)\ the top rung at #lv(lad.rung-top)\ the lowest at #lv(lad-rungs.last())\ central fall-arrest rail], size: 3pt, anchor: "west")
  // the panel closed (dashed) at the recess front
  line((4.68, ff + 0.05), (4.68, roof-fin - 0.05), stroke: (paint: rgb("#6b4a2b"), thickness: 2pt, dash: "dashed")); T((4.75, 4.2), [panel (closed) 0.04\ walnut finish, exterior grade\ flush, no hold, locked], size: 3pt, fill: rgb("#6b4a2b"), anchor: "west")
  // the gate at the top in the guard line x 4.25, the guard on the court edge, the pad on the roof
  rect((4.23, roof-fin), (4.27, roof-fin + rail-h), fill: rgb("#2f7a3f"), stroke: none); T((4.2, roof-fin + 1.25), [self-closing gate 0.90 in the court guard (1.10)\ opens WEST onto the roof], size: 3pt, fill: rgb("#2f7a3f"), anchor: "east")
  rect((3.3, roof-fin), (4.15, roof-fin + 0.04), fill: luma(90), stroke: none); T((3.7, roof-fin + 0.2), [landing pad 0.85 × 1.0 on pads], size: 3pt)
  line((4.35, roof-fin + 0.6), (4.70, roof-fin + 0.6), stroke: 0.4pt + ink, mark: (start: "|", end: "|", scale: 0.4)); T((4.52, roof-fin + 0.72), [0.35 step-through], size: 3pt)
  // the court floor, the drain, the light
  rect((4.70, ff - 0.08), (4.78, ff), fill: none, stroke: 0.4pt + sky); T((4.9, ff - 0.2), [slot drain at the foot → the court's drain line], size: 3pt, fill: sky, anchor: "west")
  circle((4.45, roof-fin - 0.25), radius: 0.04, fill: rgb("#e8b400"), stroke: none); T((4.9, roof-fin - 0.25), [IP65 light in the recess head · switch at the gym's court door], size: 3pt, anchor: "west")
  // the climb dimension and the clearances
  line((5.9, lad.foot), (5.9, lad.rung-top), stroke: 0.5pt + red, mark: (start: "|", end: "|", scale: 0.4)); T((5.95, 5.4), [climb #r2(lad-climb)], size: 3.4pt, fill: red, anchor: "west", angle: 90deg)
  line((lad.recess.at(0), 6.4), (lad.rung-x, 6.4), stroke: 0.4pt + red, mark: (start: "|", end: "|", scale: 0.4)); T((4.5, 6.52), [0.20 toe], size: 3pt, fill: red)
  line((lad.rung-x, 6.9), (lad.rung-x + lad.body, 6.9), stroke: 0.4pt + red, mark: (start: "|", end: "|", scale: 0.4)); T((lad.rung-x + lad.body / 2, 7.02), [#r2(lad.body) body], size: 3pt, fill: red)
  for (z, l) in ((ff, [court floor #lv(ff)]), (roof, [slab #lv(roof)]), (roof-fin, [roof #lv(roof-fin)]), (lad.stile-top, [#lv(lad.stile-top)])) { T((3.15, z), l, size: 3.2pt, fill: gray, anchor: "east") }
  T((4.7, 3.0), [SECTION E–W through the recess (y 21.3), looking north · 1 m = 1.25 cm · W ← → E], size: 3.8pt, fill: accent)
})
#grid(columns: (auto, auto, 1fr), gutter: 9pt, lad-plan(), lad-sect(),
  [
    #set text(6.6pt)
    #H[2 · The roof access: the maintenance ladder]
    - *Owner's decision (V8.1):* a simple roof access (cost and appearance); office visitors are met in the men's majlis, the office is the owner's only, reached from the suite court. The roof is reached by a *manufactured vertical fixed ladder* (not site-made; black matte, non-slip rungs, corrosion-protected, aluminium or hot-dip galvanised and powder-coated steel) in the suite court, on the *gym's east wall*, at the north end of the wall against the nib: away from the seating (y ≥ 21.7) and off the door strip (y ≤ 20.55, x ≥ 5.9).
    - *The recess:* #r2(lad.recess.at(3) - lad.recess.at(1)) wide × #r2(lad.recess.at(2) - lad.recess.at(0)) deep, full height from the court floor #lv(ff) to the gym roof #lv(roof-fin), formed in a *honey-stone pilaster added on the court face of the wall* (#r2(lad.pilaster.at(3) - lad.pilaster.at(1)) × #r2(lad.pilaster.at(2) - lad.pilaster.at(0)) m, cheeks 0.20): the 0.20 m structural wall on B19 (under R3) is *not cut*. If the engineer confirms that wall as non-load-bearing infill between B19 and R3, the recess may instead be cut into a locally rebuilt 0.50 wall and the pilaster disappears (structural coordination, X20). The pilaster's own weight (≈ 1.7 m³ block ≈ 20 kN) stands on the court's depressed slab: the engineer.
    - *The ladder:* stiles #r2(lad.stiles.at(1) - lad.stiles.at(0)) overall, rungs 0.40 clear, pitch #r2(lad.pitch), #lad.n rungs, the *top rung level with the roof finish* (#lv(lad.rung-top)), the lowest #r2(lad-rungs.last() - lad.foot) above the floor; *toe clearance #r2(lad.rung-x - lad.recess.at(0)) m* behind the rung line (≥ 0.18), *body clearance ≥ #r2(lad.body) m* in front of it (the court, with the panel open); climb *#r2(lad-climb) m*. The stiles run on *1.10 m above the roof* (#lv(lad.stile-top)) as the transfer handholds (fixed, so no retractable grab post; if one is preferred it is mechanically fixed, never friction-held). Tools go up in a bag: both hands on the ladder.
    - *The panel:* exterior-grade walnut-finish (marine ply or aluminium composite with a walnut veneer, #r2(lad.panel) thick), hinged on the south jamb, *opens 180°* to lie flat along the pilaster line (x #r2(lad.recess.at(2)), y #r2(lad.recess.at(3))–#r2(lad.recess.at(3) + 0.9)), held open by a *floor drop-bolt* away from the climber; a key cylinder outside (the key with the parents / the maintenance key); *closed it is flush with the pilaster face and offers no hold*: not climbable (children). With the panel closed the court reads a walnut panel in a stone pilaster, in the design language.
    - *The arrival on the roof:* the climber steps from the top rung over the pilaster's top (0.35) through a *self-closing gate 0.90 in the court's west guard* (1.10 m, on x 4.25, directly above the recess), opening *west onto the gym roof*, onto a *standing landing pad* (x 3.3–4.15, y 20.8–21.8) inside the protected zone; from it the walkway north to the attic opening. The guarding is continuous from the pad to every piece of equipment (§ 3 check); the strip outside the set-back guardrail is a no-go zone.
    - *Fall protection:* the climb (#r2(lad-climb) m) is over the 3.0 m threshold of EN ISO 14122-4: the ladder is specified with a *central fall-arrest rail* (EN 353-1 glider) rather than a cage, which would not fit the recess; the specialist confirms the arrangement under the Saudi requirements (SBC / Civil Defense / the labour safety rules) — *not verified here*. Anchor eyes on the attic wall for the no-go strips.
    - *Services:* an IP65 light in the recess head with the switch at the gym's court door (and the court's lights); the recess floor falls 1 % out to a *slot drain* at the pilaster's foot tied into the court's drain line (`studies/ff_suite.typ`); no dust pocket, no standing water.
    - *The internal stair stops at the first floor* (V8.0): the roof slab over the well is an ordinary bay (no R16–R18), no stair room; the attic a plain pentagon. The lift: no change (§ 5). *3D (V8.1):* the pilaster, the closed panel, the stiles, the gate and the set-back guardrail are built from `3d/params.yaml` `roof_design.ladder` / `guardrail_setback`.
  ],
)

// ====================================================================================== PAGE 3 · the sight lines and the roofline
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[Sight lines · north–south section at x ≈ 1.4, looking west · the attic #r2(attic-vis) m above the finish, set back #r2(setback) m · the parapet #r2(parapet-vis) m and the set-back guardrail · eye 1.6 m above the ground]
#v(2pt)
#let sight(length: 0.5cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, t, size: 4.4pt, fill: ink, anchor: "center", angle: 0deg) = content(p, anchor: anchor, angle: angle, text(size, fill: fill, t))
  let y-far = -0.125 - 25.0
  line((y-far - 1, ground), (25.5, ground), stroke: 0.8pt + ink)
  // the house in section (x ≈ 1.4): walls, slabs, the stair room, the attic, the cornice, the south wing
  rect((-0.125, ground), (24.125, roof), fill: cream, stroke: 0.6pt + ink)
  rect((-0.125, ff - 0.2), (24.125, ff), fill: luma(200), stroke: none); rect((-0.125, roof - roof-slab), (24.125, roof), fill: luma(150), stroke: none)
  rect((-0.125, ground), (24.125, 0.6), fill: stone-l, stroke: none)   // the plinth
  for y in (-0.125, 24.125) { rect((y - band.proj * (if y < 0 { 1 } else { -1 }), band.z0), (y, band.z0 + band.h), fill: stone, stroke: none) }
  // the main cornice (both ends), the north coping and the south parapet
  rect((-0.125 - cornice.proj, cornice.z0), (0.125, cornice.z0 + cornice.h), fill: stone, stroke: 0.3pt + ink)
  rect((24.125 + cornice.proj, cornice.z0), (23.875, cornice.z0 + cornice.h), fill: stone, stroke: 0.3pt + ink)
  rect((-0.125, cornice.z0 + cornice.h), (0.125, coping-top), fill: stone-l, stroke: 0.3pt + ink)
  rect((23.875, cornice.z0 + cornice.h), (24.125, south-top), fill: stone-l, stroke: 0.3pt + ink)
  // the attic walls and the stair room
  rect((in-off - 0.1, roof), (in-off + 0.1, attic-top), fill: stone-l, stroke: 0.3pt + ink)
  rect((y-step - 0.1, roof), (y-step + 0.1, attic-top), fill: stone-l, stroke: 0.3pt + ink)
  rect((y-rail - 0.03, roof-fin), (y-rail + 0.03, roof-fin + rail-h), fill: black, stroke: none); T((y-rail - 0.2, roof-fin + 1.35), [guardrail 1.10 set back #r2(rail-setback)], size: 3.4pt, anchor: "east")
  rect((lad.recess.at(1), roof-fin), (lad.recess.at(3), lad.stile-top), fill: none, stroke: (paint: ink, thickness: 0.5pt, dash: "dashed")); T((21.3, lad.stile-top + 0.3), [ladder stiles beyond (in the court, x 4.6) #lv(lad.stile-top)], size: 3.2pt)
  rect((2.0, roof-fin), (3.2, roof-fin + 0.1 + cond-h), fill: none, stroke: (paint: red, thickness: 0.5pt, dash: "dotted")); T((2.6, roof-fin + 0.1 + cond-h + 0.3), [condenser 1.2 on pads (behind the cut attic) #lv(cond-top)], size: 3.2pt, fill: red)
  T((in-off + 0.9, roof + 0.7), [attic\ #lv(attic-top)], size: 3.6pt, anchor: "west"); T((y-step - 0.3, roof + 0.7), [attic\ #lv(attic-top)], size: 3.6pt, anchor: "east")
  T((23.6, roof + 0.4), [parapet\ #lv(south-top)], size: 3.6pt, anchor: "east"); T((-0.55, cornice.z0 - 0.5), [main cornice\ #lv(cornice.z0) … #lv(cornice.z0 + cornice.h)\ coping #lv(coping-top)], size: 3.4pt, anchor: "east")
  T((12.0, 1.8), [GF], size: 5pt); T((12.0, 5.4), [FF (bedroom 2 / bedroom 3 at x ≈ 1.4)], size: 5pt); T((12.0, roof + 0.45), [roof #lv(roof) · the courtyard sky hole lies beyond, x 5.8–8.95], size: 4pt, fill: sky)
  T((21.5, 1.8), [men's majlis], size: 4.4pt); T((21.5, 5.4), [office (south wing)], size: 4.4pt)
  // the observers and the sight lines
  for (D, col, lab) in ((D-north, red, [eye at the north boundary · D = #r1(D-north) m]), (10.0, sky, [eye at 10 m (the street's far side)]), (25.0, luma(110), [eye at 25 m])) {
    let y0 = -0.125 - D
    circle((y0, eye), radius: 0.12, fill: col, stroke: none); T((y0, eye + 0.5), lab, size: 3.6pt, fill: col)
    let ray(yt, zt, yend) = line((y0, eye), (yend, eye + (zt - eye) / (yt - y0) * (yend - y0)), stroke: (paint: col, thickness: 0.5pt, dash: if col == red { "solid" } else { "dashed" }))
    ray(-0.125 - cornice.proj, coping-top, calc.min(y0 + (11.5 - eye) / ((coping-top - eye) / (-0.125 - cornice.proj - y0)), 24))   // over the cornice coping
    ray(in-off - 0.1, attic-top, calc.min(y0 + (11.5 - eye) / ((attic-top - eye) / (in-off - 0.1 - y0)), 24))                        // over the attic
  }
  for (z, l) in ((0, [±0.00]), (ff, [+3.60]), (roof, [+7.20]), (south-top, [#lv(south-top)]), (attic-top, [#lv(attic-top)])) { T((25.2, z), l, size: 3.6pt, fill: gray, anchor: "west") }
  T((y-far, ground - 0.6), [N · street], size: 4.4pt, anchor: "west"); T((25, ground - 0.6), [S], size: 4.4pt, anchor: "east")
  T((-0.125 - D-north / 2, ground + 0.3), [#r1(D-north)], size: 3.4pt, fill: red)
})
#sight()
#v(3pt)
#grid(columns: (1fr, 1fr), gutter: 12pt,
  [
    #H[3 · What the attic hides, and from where]
    The eye is 1.6 m above the ground outside (#lv(eye) against the house's ±0.00; the ground assumed at #lv(ground)). An object behind the facade is hidden when its top lies below the line from the eye over the screen in front of it (the cornice coping #lv(coping-top) on the facade, or the attic coping #lv(attic-top) #r2(setback) m behind it).
    #table(columns: (1.6fr, auto, auto, auto), inset: 2.4pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      [*Observer (north street)*], [*cornice*], [*attic*], [*condensers (1.2 m, 2.0 m behind the facade)*],
      ..observers.map(((D, l)) => (l, [#r1(ang(D, 0, coping-top))°], [#r1(ang(D, setback, attic-top))°#if ang(D, setback, attic-top) <= ang(D, 0, coping-top) [ (hidden)]], [#r1(ang(D, 2.0, cond-top))°#if ang(D, 2.0, cond-top) <= calc.max(ang(D, setback, attic-top), ang(D, 0, coping-top)) [ hidden] else [ *shows*]])).flatten())
    #text(6.4pt, fill: gray)[Angles above the horizon from the eye. From the lane boundary (D = #r1(D-lane) m) the condensers (1.2 m on 0.10 pads, 2.0 m behind the cut facade: top #lv(cond-top)) are seen at #r1(ang(D-lane, 2.0, cond-top))° against the attic's #r1(ang(D-lane, setback, attic-top))°: hidden; and from every distance, since #lv(cond-top) ≤ #lv(attic-top). The tank (top #lv(tank-top)) likewise. From the east boundary (D = #r1(D-east) m) the plant zone is likewise hidden. The malqaf head (#lv(tower-top)) at the courtyard's north-west corner is the one element above the attic, by design (V10.0): hidden from the gate and the north boundary by the north facade, seen whole from the courtyard.]
    - *Attic height (owner, V8.1): #r2(attic-vis) m above the roof finish, coping included* (top #lv(attic-top); was 1.80 / +9.10). *Re-run:* the minimum that hides the condensers from the street and the lane at eye level from every distance is #r2(attic-min) m (1.2 m units on 0.10 pads: top #lv(cond-top)); #r2(attic-vis) m leaves 0.10 m of margin, so *1.40 m works* on the condition that the outdoor units are *≤ 1.2 m high* (most 2–7 kW split and VRF condensers are 0.6–1.0 m; a tall unit laid on its side is not allowed: specify the height to the MEP engineer). The tank 1.0 m: hidden with 0.40 m of margin.
    - *The malqaf head (V10.0, L5):* 4.5 m above the attic coping (#lv(tower-top)), 1.6 × 2.4 m at the courtyard's north-west corner, 6.4 m behind the north facade: *not seen from the gate or the north boundary*, 1.9 m above the roofline from the street at 14 m, the whole 5.8 m from the courtyard seating (`studies/malqaf_L5.typ` Phase 5, accepted by the owner). The ladder's stiles (#lv(lad.stile-top), in the court 2.4 m behind the court's south face) stay below the attic coping and are hidden from the south garden by the parapet up to ≈ 40 m; black matte.
  ],
  [
    #H[4 · The courtyard's sky and sun with the attic]
    From every point of the courtyard floor the attic walls lie *below the hole's own edges* (the roof edge beams at #lv(roof)), so they take nothing from the sky the courtyard sees today (enclosure study: #r1(7.2) % of the hemisphere from the floor's middle, unchanged):
    #table(columns: (2fr, auto, auto), inset: 2.4pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      [*From the far edge of the floor*], [*hole edge*], [*attic*],
      ..court-view.map(((l, a, b)) => (l, [#r1(a)°], [#r1(b)° #if b < a [✓] else [✗]])).flatten())
    - *Winter noon sun* (45.2°, the light check): the ray that just clears the hole's south edge (#lv(roof) at y 13.0) passes the attic's south wall line (y #r2(y-step)) at #lv(sun-margin), far above its coping #lv(attic-top): the attic never shades the courtyard, in any season. The clerestory windows sit in the y #r2(y-step) wall itself, below the attic wall: unchanged; their sun comes over the court's south frame, whose parapet is now #lv(south-top) (0.40 lower: a little more winter sun, `studies/sections.typ`).
    - *The suite court* gets the attic's south wall on its north side (its shaded side): no loss of sun, a little less sky.
    #v(3pt)
    #H[5 · The lift]
    - Top stop at the first floor (#lv(ff)); the roof slab underside at #lv(roof - roof-slab): *#r2(lift-avail) m headroom available*. A typical Saudi villa lift (machine-room-less traction, 400–630 kg, 2 stops) asks #r2(lift-typ.at(0))–#r2(lift-typ.at(1)) m headroom above the top floor and a 1.2–1.4 m pit (assumed from supplier catalogues; open item 14 asks for the drawings); a platform home lift (EN 81-41) asks #r2(lift-platform.at(0))–#r2(lift-platform.at(1)) m.
    - *So:* choose a lift with headroom ≤ #r2(lift-avail) m: no shaft head above the roof. If the chosen lift needs up to #r2(lift-avail + lift-raise-max) m, a raised shaft head of ≤ #r2(lift-raise-max) m (top #lv(coping-top)) stays hidden behind the main cornice coping; more than that is not possible: the shaft (x 0–2.25, y 0–2.2) lies in the 1.0 m strip in front of the attic, not inside it. Added to open item 15 as a requirement for the supplier.
  ],
)

// ====================================================================================== PAGE 4 · elevations
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[North and west elevations · simple line drawings · the main cornice, the thin cornice between the floors, the lowered attic, the low parapet, the stepped roofline · openings indicative]
#v(2pt)
#let elev-common(T, x0, x1, blockN: none) = {
  import cetz.draw: *
  // ground, plinth, body, bands, cornice
  line((x0 - 0.8, ground), (x1 + 0.8, ground), stroke: 0.8pt + ink)
  rect((x0, ground), (x1, cornice.z0), fill: cream, stroke: 0.6pt + ink)
  rect((x0, ground), (x1, 0.6), fill: stone-l, stroke: 0.3pt + ink)
  rect((x0 - band.proj, band.z0), (x1 + band.proj, band.z0 + band.h), fill: stone, stroke: 0.3pt + ink)
  rect((x0 - cornice.proj, cornice.z0), (x1 + cornice.proj, cornice.z0 + cornice.h), fill: stone, stroke: 0.4pt + ink)
  for x in (x0, x1) { rect((if x == x0 { x } else { x - 0.6 }, 0.6), (if x == x0 { x + 0.6 } else { x }, cornice.z0), fill: none, stroke: (paint: stone.darken(20%), thickness: 0.4pt, dash: "dotted")) }   // stone quoins
}
#let north-elev(length: 0.5cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, t, size: 4.2pt, fill: ink, anchor: "center", angle: 0deg) = content(p, anchor: anchor, angle: angle, text(size, fill: fill, t))
  let x0 = -0.125; let x1 = 13.436
  elev-common(T, x0, x1)
  line((10.16, ground), (10.16, cornice.z0), stroke: (paint: ink, thickness: 0.4pt, dash: "dotted")); T((11.8, 1.8), [cut wall\ (seen obliquely)], size: 3.6pt, fill: gray)
  // the coping of the north block (all of it: the south wing is behind)
  rect((x0, cornice.z0 + cornice.h), (x1, coping-top), fill: stone-l, stroke: 0.4pt + ink)
  // the attic behind (north wall x 0.875–9.53, then the cut-offset line to x 12.436 at y 6.22 — all seen above the coping)
  rect((in-off, coping-top), (attic-e, attic-top), fill: cream.darken(6%), stroke: 0.6pt + ink); T((6.5, roof + 0.85), [attic screen · set back 1.0 · #lv(attic-top) (#r2(attic-vis) above the finish)], size: 4pt)
  // V10.0: the malqaf head (L5) at the courtyard's north-west corner, seen above the attic: render and paint (sand; the band and the crown in the honey tone)
  rect((4.30, attic-top), (5.90, 10.6), fill: rgb("#efe3c8"), stroke: 0.6pt + ink); rect((4.24, 10.6), (5.96, 10.75), fill: rgb("#d8b47a"), stroke: 0.5pt + ink); rect((4.30, 10.75), (5.90, 12.9), fill: rgb("#efe3c8"), stroke: 0.6pt + ink)
  for k in range(3) { let cx = 4.30 + 0.3 + 0.1 + k * 0.4; rect((cx - 0.1, 11.2), (cx + 0.1, 12.5), fill: rgb("#2b2b2d"), stroke: none); circle((cx, 12.5), radius: 0.1, fill: rgb("#2b2b2d"), stroke: none) }
  rect((4.25, 12.9), (5.95, 13.02), fill: rgb("#d8b47a"), stroke: 0.5pt + ink); rect((4.20, 13.02), (6.00, tower-top), fill: rgb("#d8b47a"), stroke: 0.5pt + ink)
  T((5.1, tower-top + 0.35), [malqaf #lv(tower-top)], size: 3.6pt)
  // openings (indicative): women's majlis window, family entrance, kids' room window, maid bath vent
  rect((5.4, 0.9), (7.8, 2.4), fill: rgb("#9fcbe0"), stroke: 0.4pt + ink); rect((5.3, ff + 0.9), (8.7, ff + 2.4), fill: rgb("#9fcbe0"), stroke: 0.4pt + ink)
  rect((3.0, 0), (4.2, 2.4), fill: rgb("#6b4a2b"), stroke: 0.4pt + ink); T((3.6, -0.55), [family door], size: 3.2pt)
  rect((11.3, 1.6), (11.6, 2.1), fill: rgb("#9fcbe0"), stroke: 0.4pt + ink); rect((12.2, ff + 1.5), (12.75, ff + 2.1), fill: rgb("#9fcbe0"), stroke: 0.4pt + ink)
  for (z, l) in ((0, [±0.00]), (band.z0, [band #lv(band.z0)]), (cornice.z0, [cornice #lv(cornice.z0)]), (coping-top, [coping #lv(coping-top)]), (attic-top, [attic #lv(attic-top)])) { T((x1 + 0.5, z), l, size: 3.4pt, fill: gray, anchor: "west") }
  T((6.6, ground - 0.8), [NORTH ELEVATION (from the street) · W ← → E · 1 m = 0.5 cm], size: 4.4pt, fill: accent)
})
#let west-elev(length: 0.5cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, t, size: 4.2pt, fill: ink, anchor: "center", angle: 0deg) = content(p, anchor: anchor, angle: angle, text(size, fill: fill, t))
  let y0 = -0.125; let y1 = 24.125   // horizontal = y, north on the left (looking east from the M line side)
  elev-common(T, y0, y1)
  // the north block coping and the south wing parapet (the step)
  rect((y0, cornice.z0 + cornice.h), (y-step, coping-top), fill: stone-l, stroke: 0.4pt + ink)
  rect((y-step, cornice.z0 + cornice.h), (y1, south-top), fill: stone-l, stroke: 0.4pt + ink); T((21.7, south-top + 0.3), [south wing parapet #lv(south-top) (0.70 above the finish)], size: 3.6pt)
  // the attic behind (y 0.875–19.25), the set-back guardrail behind the south wing parapet (dashed: not seen at eye level)
  rect((in-off, coping-top), (y-step, attic-top), fill: cream.darken(6%), stroke: 0.6pt + ink); T((13.0, roof + 0.85), [attic screen (set back 1.0) #lv(attic-top)], size: 4pt)
  line((y-step, roof-fin + rail-h), (y-rail, roof-fin + rail-h), stroke: (paint: ink, thickness: 0.5pt, dash: "dashed")); T((21.0, roof-fin + rail-h + 0.3), [guardrail 1.10 behind, set back 1.0 (hidden at eye level)], size: 3.2pt)
  rect((lad.recess.at(1), south-top), (lad.recess.at(3), lad.stile-top), fill: none, stroke: (paint: ink, thickness: 0.5pt, dash: "dashed")); T((lad.recess.at(1) - 0.2, lad.stile-top + 0.25), [ladder stiles in the court #lv(lad.stile-top)], size: 3pt, anchor: "east")
  // openings (indicative): first-floor west windows (bedroom 2, bath 3, bedroom 3), the guest entrance
  for (a, b) in ((11.3, 12.6), (14.6, 15.2), (17.2, 18.2)) { rect((a, ff + 0.9), (b, ff + 2.4), fill: rgb("#9fcbe0"), stroke: 0.4pt + ink) }
  rect((21.5, 0), (22.9, 2.4), fill: rgb("#6b4a2b"), stroke: 0.4pt + ink); T((22.2, -0.55), [guest door], size: 3.2pt)
  line((y-step, ground - 0.3), (y-step, attic-top + 0.4), stroke: (paint: red, thickness: 0.5pt, dash: "dashed")); T((y-step, attic-top + 0.7), [the step: attic #lv(attic-top) → parapet #lv(south-top) (#r2(step) m) at y #r2(y-step)], size: 3.6pt, fill: red)
  for (z, l) in ((0, [±0.00]), (ff, [+3.60]), (roof, [+7.20]), (coping-top, [#lv(coping-top)]), (south-top, [#lv(south-top)]), (attic-top, [#lv(attic-top)])) { T((y1 + 0.5, z), l, size: 3.4pt, fill: gray, anchor: "west") }
  T((12.0, ground - 0.8), [WEST ELEVATION (from the M line / the neighbour) · N ← → S · 1 m = 0.5 cm], size: 4.4pt, fill: accent)
})
#let east-elev(length: 0.42cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, t, size: 3.6pt, fill: ink, anchor: "center", angle: 0deg) = content(p, anchor: anchor, angle: angle, text(size, fill: fill, t))
  let X(y) = 24.125 - y          // seen from the east (the lane side): north on the right
  // behind: the attic (set back 1.0), the malqaf head (V10.0) at the courtyard's north-west corner, the set-back guardrail on the south wing (dashed)
  rect((X(y-step), coping-top), (X(attic-yc), attic-top), fill: cream.darken(6%), stroke: 0.5pt + ink); T((X(12.5), attic-top + 0.3), [attic #lv(attic-top) (set back 1.0)], size: 3.2pt)
  rect((X(8.8), attic-top), (X(6.4), 10.6), fill: rgb("#efe3c8"), stroke: 0.5pt + ink); rect((X(8.8) - 0.06, 10.6), (X(6.4) + 0.06, 10.75), fill: rgb("#d8b47a"), stroke: 0.4pt + ink); rect((X(8.8), 10.75), (X(6.4), 12.9), fill: rgb("#efe3c8"), stroke: 0.5pt + ink); for k in range(5) { let cx = X(8.8) + 0.3 + 0.1 + k * 0.4; rect((cx - 0.1, 11.2), (cx + 0.1, 12.5), fill: rgb("#2b2b2d"), stroke: none); circle((cx, 12.5), radius: 0.1, fill: rgb("#2b2b2d"), stroke: none) }; rect((X(8.8) - 0.1, 12.9), (X(6.4) + 0.1, tower-top), fill: rgb("#d8b47a"), stroke: 0.4pt + ink); T((X(7.6), tower-top + 0.35), [malqaf #lv(tower-top) (L5, behind the attic's line)], size: 3.2pt)
  line((X(y-step), roof-fin + rail-h), (X(y-rail), roof-fin + rail-h), stroke: (paint: ink, thickness: 0.5pt, dash: "dashed")); T((X(21.2), roof-fin + rail-h + 0.3), [guardrail 1.10 set back 1.0 (hidden at eye level)], size: 3pt)
  // the facade: the straight east wall y 6–24 and the cut y 0–6 (oblique)
  line((X(-0.125) - 0.8, ground), (X(24.125) + 0.8, ground), stroke: 0.8pt + ink)
  rect((X(24.125), ground), (X(6.0), cornice.z0), fill: cream, stroke: 0.6pt + ink)
  rect((X(6.0), ground), (X(-0.125), cornice.z0), fill: cream.darken(4%), stroke: 0.6pt + ink); T((X(3.0), 1.8), [cut wall (oblique)], size: 3pt, fill: gray)
  rect((X(24.125), ground), (X(-0.125), 0.6), fill: stone-l, stroke: 0.3pt + ink)
  rect((X(24.125) - band.proj, band.z0), (X(-0.125) + band.proj, band.z0 + band.h), fill: stone, stroke: 0.3pt + ink)
  rect((X(24.125) - cornice.proj, cornice.z0), (X(-0.125) + cornice.proj, cornice.z0 + cornice.h), fill: stone, stroke: 0.4pt + ink)
  rect((X(y-step), cornice.z0 + cornice.h), (X(-0.125), coping-top), fill: stone-l, stroke: 0.4pt + ink)
  rect((X(24.125), cornice.z0 + cornice.h), (X(y-step), south-top), fill: stone-l, stroke: 0.4pt + ink)
  T((X(21.7), south-top + 0.3), [south wing parapet #lv(south-top)], size: 3.2pt); T((X(12.5), coping-top + 0.25), [coping #lv(coping-top)], size: 3.2pt)
  // openings (indicative, from the plans): the kitchen service door and window, the suite bath vent, the suite bedroom's escape window, the office's east window
  rect((X(8.1), 0.0), (X(7.2), 2.1), fill: rgb("#6b4a2b"), stroke: 0.4pt + ink); T((X(7.65), -0.5), [service door], size: 2.8pt)
  rect((X(10.1), 1.1), (X(8.7), 2.1), fill: rgb("#9fcbe0"), stroke: 0.4pt + ink); T((X(9.4), 0.75), [kitchen], size: 2.8pt)
  rect((X(10.05), ff + 1.5), (X(9.5), ff + 2.1), fill: rgb("#9fcbe0"), stroke: 0.4pt + ink)
  rect((X(18.6), ff + 0.9), (X(15.0), ff + 2.4), fill: rgb("#9fcbe0"), stroke: 0.4pt + ink); T((X(16.8), ff + 0.6), [suite bedroom (escape)], size: 2.8pt)
  rect((X(23.7), ff + 0.9), (X(22.8), ff + 2.1), fill: rgb("#9fcbe0"), stroke: 0.4pt + ink); T((X(23.25), ff + 0.6), [office], size: 2.8pt)
  // the outdoor kitchen's counter against the wall (V8.1)
  rect((X(23.6), ground), (X(20.8), 0.6), fill: stone, stroke: 0.5pt + ink); T((X(22.2), 0.9), [outdoor kitchen counter + sink], size: 2.8pt)
  for (z, l) in ((0, [±0.00]), (ff, [+3.60]), (cornice.z0, [#lv(cornice.z0)]), (south-top, [#lv(south-top)]), (attic-top, [#lv(attic-top)])) { T((X(-0.125) + 1.0, z), l, size: 3.2pt, fill: gray, anchor: "west") }
  T((X(12.0), ground - 0.8), [EAST ELEVATION (from the lane) · S ← → N · 1 m = 0.42 cm (V8.1: no stair tower)], size: 4pt, fill: accent)
})
#north-elev()
#v(6pt)
#west-elev()
#v(4pt)
#text(6.8pt)[Cream plaster, honey stone at the plinth (to +0.60), the corners (quoins, dotted), the thin band at the first-floor slab (#r2(band.h) m, projecting #r2(band.proj)) and the main cornice (#r2(cornice.h) m high, projecting #r2(cornice.proj), #lv(cornice.z0) … #lv(cornice.z0 + cornice.h)); the attic plastered cream with a stone coping. The south elevation repeats the west one's south part (parapet #lv(south-top), the court's screened opening under the frame); the east elevation the north block's coping and attic (set back 1.0) over the kitchen / suite windows, then the parapet (the east elevation is drawn below). Openings are indicative here: the real ones are in the plans and the studies.]

// ====================================================================================== PAGE 5 · the cornice, the loads, the records
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[The cornice and the attic in section · loads for the engineer · what changes in the files]
#v(2pt)
#let cornice-detail(length: 2.2cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, t, size: 4.2pt, fill: ink, anchor: "center", angle: 0deg) = content(p, anchor: anchor, angle: angle, text(size, fill: fill, t))
  // section through the north facade at the roof: x = distance from the facade face (outside negative), z = level
  let f = 0.0
  rect((f, 5.6), (f + 0.25, roof - roof-slab), fill: luma(170), stroke: none); T((f + 0.125, 6.2), [outer wall\ 250], size: 3.4pt, angle: 90deg)
  rect((f + 0.25, roof - roof-slab), (f + 2.4, roof), fill: luma(120), stroke: none); rect((f, roof - roof-slab), (f + 0.25, roof), fill: luma(120), stroke: none)
  rect((f + 0.25, roof), (f + 2.4, roof-fin), fill: luma(200), stroke: none)
  rect((f - cornice.proj, cornice.z0), (f + 0.25, cornice.z0 + cornice.h), fill: stone, stroke: 0.4pt + ink)
  line((f - cornice.proj, cornice.z0 + 0.1), (f - cornice.proj + 0.03, cornice.z0), stroke: 0.4pt + ink)   // drip
  rect((f, cornice.z0 + cornice.h), (f + 0.2, coping-top - 0.08), fill: luma(170), stroke: 0.3pt + ink)
  rect((f - 0.03, coping-top - 0.08), (f + 0.23, coping-top), fill: stone, stroke: 0.4pt + ink)
  rect((f + 0.25 + setback - 0.25 - 0.0, roof), (f + 0.25 + setback - 0.25 + 0.2, attic-top - 0.1), fill: luma(170), stroke: 0.3pt + ink)
  rect((f + setback - 0.03, attic-top - 0.1), (f + setback + 0.23, attic-top), fill: stone, stroke: 0.4pt + ink)
  T((f + setback + 0.1, roof + 0.9), [attic\ 200 block\ #r2(attic-h)], size: 3.4pt, angle: 90deg)
  T((f + 0.55, roof + 0.12), [strip → outlet], size: 3.2pt)
  circle((f + 0.7, roof + 0.05), radius: 0.05, fill: white, stroke: 0.4pt + sky)
  T((f - 0.15, cornice.z0 + 0.22), [cornice\ stone], size: 3.2pt, fill: white)
  T((f - 0.6, coping-top), [coping #lv(coping-top)], size: 3.4pt, anchor: "east"); T((f - 0.6, cornice.z0), [#lv(cornice.z0)], size: 3.4pt, anchor: "east"); T((f - 0.6, roof), [slab #lv(roof)], size: 3.4pt, anchor: "east")
  T((f + 1.6, attic-top), [#lv(attic-top)], size: 3.4pt); T((f + 1.9, roof - 0.35), [roof slab 0.20 (0.22 / 0.30 bays)], size: 3.2pt)
  line((f, roof - 0.5), (f + setback, roof - 0.5), stroke: 0.4pt + ink, mark: (start: "|", end: "|", scale: 0.4)); T((f + 0.5, roof - 0.62), [#r2(setback) set-back], size: 3.2pt)
  line((f - cornice.proj, cornice.z0 - 0.25), (f, cornice.z0 - 0.25), stroke: 0.4pt + ink, mark: (start: "|", end: "|", scale: 0.4)); T((f - 0.15, cornice.z0 - 0.38), [#r2(cornice.proj)], size: 3.2pt)
  T((f + 1.2, 5.75), [section at the north facade · 1 m = 2.2 cm], size: 3.8pt, fill: accent)
})
#grid(columns: (auto, 1fr, 1fr), gutter: 12pt, cornice-detail(),
  [
    #H[6 · Sizes (assumed, by this study)]
    - *Main cornice:* honey stone, #r2(cornice.h) m high (#lv(cornice.z0) … #lv(cornice.z0 + cornice.h)), projecting #r2(cornice.proj) m with a drip, on the facade edge all round the house; above it a 0.30 m upstand with a stone coping to *#lv(coping-top)* on the north block (the strip's parapet) and the plain parapet to *#lv(south-top)* on the south wing. The thin cornice between the floors: a stone band #r2(band.h) m high at #lv(band.z0), projecting #r2(band.proj).
    - *Attic (lowered V8.1):* 200 mm block, plastered cream, stone coping; #r2(attic-h) m above the roof slab + 0.10 coping = #r2(attic-vis) m above the finish (coping #lv(attic-top)); set back #r2(setback) m from the facade face (#r2(in-off) m from the wall centre lines); ≈ #r1(attic-len) m long; on the south on the y #r2(y-step) line (B8 / R5). Four openings 0.80 (two to the strip, gated and locked; two to the south wing roofs).
    - *South wing parapet:* #r2(parapet-vis) m above the finish, coping included (top #lv(south-top)); the *guardrail* 1.10 m black steel bars (posts at 1.5 m) set back #r2(rail-setback) m from the outer faces, continuous from the attic's end walls to the court guards; the no-go strips 1.0 m.
    - *Roofline step:* #r2(step) m at y #r2(y-step) (attic coping #lv(attic-top) → parapet #lv(south-top)), plus the 1.0 m plan set-back. *Final heights:* cornice #lv(cornice.z0) … #lv(cornice.z0 + cornice.h), north coping #lv(coping-top), south parapet #lv(south-top), attic coping #lv(attic-top), the malqaf head #lv(tower-top) (V10.0, L5), ladder stiles #lv(lad.stile-top) (inside the court). Targets, to confirm at the facade design stage.
    - *Maintenance ladder* (page 2): recess #r2(lad.recess.at(3) - lad.recess.at(1)) × #r2(lad.recess.at(2) - lad.recess.at(0)) in a stone pilaster #r2(lad.pilaster.at(3) - lad.pilaster.at(1)) × #r2(lad.pilaster.at(2) - lad.pilaster.at(0)) on the gym's east wall; climb #r2(lad-climb); stiles to #lv(lad.stile-top); the gate 0.90 and the pad on the gym roof.
    #v(2pt)
    #H[7 · Loads for the engineer (assumed)]
    - *Attic walls:* 200 block #r2(attic-h) m + coping ≈ #r1(attic-h * 2.5 + 0.3) kN/m (was 4.5), standing on the roof slab #r2(in-off) m inside the outer-wall beams (R7 / R8, the cut and east wall beams): near the supports, but a line load on the slab: thicken the slab edge or add a small hidden beam under it; the south attic wall on R5 / B8.
    - *Parapet and guardrail (south wing):* the 0.70 parapet ≈ 1.8 kN/m on the facade beams (was 2.8); the 1.10 m guardrail on the slab 1.0 m in: posts at 1.5 m on base plates bolted to the slab through the waterproofing (or on a 0.20 kerb), designed for a 0.74 kN/m horizontal load at the top rail and 0.9 kN point load (SBC 301 / ASCE 7 guards): small, but the anchors and the upstand detail are the engineer's.
    - *Ladder and pilaster:* the pilaster ≈ 20 kN on the court's depressed slab (the men's majlis roof); the ladder's fixings into the pilaster (resin anchors into solid block or a cast-in steel sub-frame): the supplier's loads (≈ 1.5 kN per fixing); the gate posts on the roof edge beam R3.
    - *Cornice:* stone ≈ 2.5 kN/m hung on the slab edge (anchored precast or cut stone); the thin band 0.3 kN/m.
    - *Plant:* 3–4 AC outdoor units ≈ 1.0 kN each on pads with anti-vibration mounts (local ≈ 1.5 kN/m²; V10.0: no ERV on the roof); *tank(s):* up to 3 m³ = 30 kN on ≈ 3.3 m² (≈ 9 kN/m²) on the R10–R3 bay (1.5 m span): to be checked; *PV:* ≈ 0.25 kN/m² plus wind uplift (ballast or cast-in fixing points, 24 m² now, 20 m² future); *malqaf head* as the air study; walkway pads 0.5 kN/m².
    - *Roof live load* for maintenance only: 1.0–1.5 kN/m² (SBC 301, the engineer).
  ],
  [
    #H[8 · Conflicts and open points]
    - *The malqaf (V10.0, owner):* L5 adopted (`studies/malqaf_L5.typ`): the head 1.6 × 2.4 at the courtyard's north-west corner on the shaft and the gallery roof (R3 widened to 0.40 over y 6.5–8.8, the new beam R-L5 under its south wall; the fall-back F2 if the engineer refuses); the L1 tower, its plant room and plenum at the north-east corner removed; the attic's corner back to a plain pentagon.
    - *Workers through the house:* roof maintenance enters by the gym and the suite court (the family's private side); the ladder's key is a household key. Accepted by the decision (V8.1). The site has one entry: the farm's 4 m main gate (no gate on the lane).
    - *PV:* the no-go strips and the ladder's walkway cut the south wing PV to #r1(area(z-pv1) + area(z-pv1b)) m² (was 24.6); Z5 on the north block (#r1(area(z-pv2)) m²) is unchanged: R-31 to revisit with the site plan.
    - *Lift* (§ 5): no overrun if the supplier's headroom is ≤ #r2(lift-avail) m (≤ #r2(lift-avail + lift-raise-max) m with a 0.30 m raised head behind the cornice): a requirement for open item 15.
    - *Courtyard light* (§ 4): none lost. *First-floor layout:* the office has one door (from the court) and an east window; the suite bedroom's escape window runs y 15.0–18.6 (`studies/ff_suite.typ`).
    - *3D, DXF and the presentation (V8.1):* the ladder, the attic (1.40; V9.2 1.38), the 0.70 parapet and the set-back guardrail are built and drawn.
    #v(2pt)
    #H[9 · What this study changes in the files]
    - `studies/structure.typ`: R16–R18 and the stair-well voids dropped (V8.0), X16 superseded; X20 the ladder recess / pilaster, X17 the lowered attic, the 0.70 parapet and the guardrail loads; `studies/fire_escape.typ`: the first floor's exits are the main stair and the escape windows, the court a fresh-air area, not an exit; `3d/params.yaml`: the attic / parapet / ladder / guardrail data (V8.1).
    - `docs/DESIGN_LANGUAGE.md`, `docs/OPEN_ITEMS.md`, `PROJECT_V10.md` (V8.1).
    - `data/decisions.csv`: the roof by a maintenance ladder, the roofline lowered (V8.1).
    #v(2pt)
    #text(8pt)[#if all-ok [*Study checks passed* (#checks.len())] else [*STUDY CHECKS FAILED:* #checks.filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]]
  ],
)

// ---------- Data for tools/make_dxf_roof.py and the presentation (typst eval --in studies/roof.typ "query(<roof-data>).first().value") · CSV frame ----------
#metadata((outline: outline, block_s: block-s, sky: rect-pts(..sky-hole), court: court-pts, tower: tower, attic: attic, ladder: (pilaster: rect-pts(..lad.pilaster), recess: rect-pts(..lad.recess), gate: lad.gate, pad: rect-pts(..lad.pad)), rails: rails,   // V8.1: the ladder and the set-back guardrails
  lift: rect-pts(lift.x0, lift.y0, lift.x1, lift.y1), zones: (("Z2b plant: AC units", z-plant), ("Z3 water tank", z-tank), ("Z4a PV gym roof", z-pv1), ("Z4b PV office roof", z-pv1b), ("Z5 PV future", z-pv2)).map(((n, P)) => (name: n, pts: P, area: area(P))),
  outlets: outlets, walkways: walk, guards: guards, attic_doors: (((3.3, in-off), (4.1, in-off)), ((in-off, 12.0), (in-off, 12.8)), ((2.1, y-step), (2.9, y-step)), ((11.0, y-step), (11.8, y-step))),
  levels: (roof: roof, attic_top: attic-top, coping: coping-top, south: south-top, malqaf: tower-top, stile_top: lad.stile-top, cornice: (cornice.z0, cornice.z0 + cornice.h), setback: setback))) <roof-data>

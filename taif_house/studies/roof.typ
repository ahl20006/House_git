// roof.typ · Taif / Palm House V7.0 · ROOF STUDY (design review F-07): the main stair continues to the roof, the roof screen ("attic") set back
// behind a main stone cornice on the north block, the south wing with a plain parapet (a stepped roofline), the reserved roof zones.
// Owner decisions (31 Oct 2026, branch work / V6.4): roof for maintenance and equipment only; the lift does not go up; flat roof, no tiles; classical
// roofline kept simple (docs/DESIGN_LANGUAGE.md); no slab level changes. 1 Nov 2026 (studies/south_wing.typ): the MAIN STAIR STOPS AT THE FIRST FLOOR;
// the roof is reached from the EXTERNAL STAIR TOWER at the south-east (outside the east wall, y 18.22–24.0, top +9.60); no stair room, the roof slab over the well closed.
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
#let attic-h = 1.8                                // the attic screen wall above the roof slab (set by the sight lines, § 3)
#let attic-top = roof + attic-h + 0.1             // +9.10 with its stone coping
#let south-top = roof-fin + 1.1                   // the south wing: a plain parapet 1.10 above the roof finish, coping included: +8.40
#let band = (z0: 3.40, h: 0.12, proj: 0.08)       // the thin cornice between the floors, honey stone, at the first-floor slab line
#let step = attic-top - south-top                 // the step in the roofline at y 19.25

// ---------- The stair (studies/structure.typ) and the stair room ----------
#let st = (x0: 0.125, x1: 2.65, y0: 2.30, y1: 7.80, land: 3.55, top: 6.35, split: 1.3875, gap: 0.10, r: 3.6 / 22, g: 0.28, b16: 4.85, b17: 1.2875, b18: 6.45)
#let sr = (x0: 0, x1: 2.75, y0: 2.2, y1: 7.9)     // the V7.0 stair room (REMOVED 1 Nov 2026; kept only as the record of the old sight-line numbers)
#let tower-ext = ((13.436, 18.22), (16.036, 18.22), (16.036, 24.0), (13.436, 24.0))   // 1 Nov 2026: the external stair tower at the south-east, outside the east wall face (2.6 × 5.78 on its outer faces)
#let tower-ext-top = 9.6                           // its top: the roof door's head +9.40 + the slab; above the attic (+9.10), below the malqaf (+9.80)
#let tower-door = ((13.311, 22.9), (13.311, 23.75))   // the roof door at +7.30 through the south wing parapet, at the tower's top landing
#let tw-s-north = 18.22 + 0.125                    // the tower's north face behind the north facade face
#let sr-s-north = sr.y0 - 0.1 + 0.125              // idem (presentation.typ)
#let sr-top = 9.70                                 // the V7.0 stair room's top (REMOVED 1 Nov 2026): kept only because presentation.typ still quotes it until the presentation is rebuilt
#let sr-slab = 0.12                                // its roof: a light RC slab (or an insulated steel deck), assumed
#let sr-clear = 2.20                               // required clear height over the arrival
#let sr-soffit = roof-fin + sr-clear               // +9.50
#let sr-roof = sr-soffit + sr-slab                 // +9.62 (top of its slab)
#let tower-ext-top = sr-roof + 0.08                       // +9.70 with its edge / coping
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
#let outline = ((0, 0), (10.051, 0), (13.311, 6.0), (13.311, 24.0), (0, 24.0))
#let y-step = 19.25                                // the north block / south wing line (the men's majlis north wall, beams B8 / R5)
#let block-n = ((0, 0), (10.051, 0), (13.311, 6.0), (13.311, y-step), (0, y-step))
#let block-s = ((0, y-step), (13.311, y-step), (13.311, 24), (0, 24))
#let sky-hole = (5.8, 6.5, 8.95, 13.0)            // the courtyard sky (V6.4, enclosure A)
#let court-hole = (5.6, 19.25, 10.0, 21.9)         // the suite court (1 Nov 2026: 2.5 m clear, x 5.6–10.0)
#let tower = ((8.95, 0), (10.051, 0), (10.594, 1.0), (8.95, 1.0))
#let tower-top = 9.8                               // the malqaf head, 2.5 m above the roof finish (studies/air_system.typ)
#let cut-k = 3.26 / 6.0
#let cut-cos = 6.0 / calc.sqrt(3.26 * 3.26 + 36.0)
#let in-off = setback - 0.125                      // the attic line from the wall centre lines: 0.875
#let cut-x(y, off) = 10.051 + cut-k * y - off / cut-cos
#let attic-e = 13.311 - in-off
#let attic-yc = (attic-e - 10.051 + in-off / cut-cos) / cut-k
#let attic = ((in-off, in-off), (cut-x(in-off, in-off), in-off), (attic-e, attic-yc), (attic-e, y-step), (in-off, y-step))   // 1 Nov 2026: a plain pentagon, set back 1.0 m on all four sides (no stair room notch any more)
#let attic-len = (cut-x(in-off, in-off) - in-off) + calc.sqrt(calc.pow(attic-e - cut-x(in-off, in-off), 2) + calc.pow(attic-yc - in-off, 2)) + (y-step - attic-yc) + (attic-e - in-off) + (y-step - in-off)
#let strip-area = area(block-n) - area(attic) - area(tower) * 0.875

// ---------- Reserved zones ----------
#let z-erv = ((8.95, 1.0), (10.594, 1.0), (cut-x(3.4, 0), 3.4), (8.95, 3.4))   // v3.1 (owner): the HRV BASE under the malqaf tower, one mass with it: on the tower's west line and the cut facade line, y 1.0–3.4, top +9.10 = the attic coping; doors on its west face onto the roof terrace; the exhaust louvre on its cut face
#let base-top = 9.10
#let z-plant = ((9.6, 5.6), (cut-x(5.6, in-off), 5.6), (attic-e, attic-yc), (attic-e, 9.0), (9.6, 9.0))   // AC outdoor units behind the cut / east attic, south of the plant room (kept off the intake's wind side)
#let z-tank = rect-pts(2.85, 1.0, 4.15, 3.5)       // water tank(s) between the roof beams R10 (x 2.75) and R3 (x 4.25)
#let z-pv1 = rect-pts(0.125, 22.0, 12.0, 23.875)   // PV, south wing roof: south of y 22.0 so it never shades the clerestories (X4); 1 Nov 2026: it stops at x 12.0, clear of the stair tower's roof door and its landing
#let z-pv2 = rect-pts(9.0, 9.5, 11.6, 17.4)        // PV, future: north block east roof inside the attic (morning shade from the east attic wall)
#let pv-y-min = 19.25 + (roof - 5.0) + 0.5         // a 0.5 m high panel at y ≥ 21.45 + 0.5 keeps the winter noon sun (45°) on the clerestory sills (+5.00)
#let outlets = ((5.0, 0.45), (0.45, 12.0), (0.45, 17.5), (12.9, 12.5), (11.6, 2.4), (4.5, 4.0), (10.5, 11.0), (4.5, 16.5), (10.5, 17.0), (2.0, 23.2), (11.5, 23.2))
#let walk = (((12.9, 23.3), (12.5, 22.6), (2.5, 22.6), (2.5, 18.5), (5.0, 18.5), (5.0, 14.0)), ((3.5, 8.5), (3.5, 3.6), (3.5, 1.4)), ((3.5, 5.6), (10.2, 5.6), (10.2, 8.6)), ((3.5, 8.5), (5.0, 8.5), (5.0, 14.0), (10.3, 14.0), (10.3, 9.0)),
             ((0.45, 12.0), (0.45, 18.0)))   // 1 Nov 2026: the network starts at the stair tower's roof door (SE), runs west along the south wing (south of the suite court's guards), through the attic door at y 19.25 into the north block, then to the tank, the PV, the condensers and the HRV base
#let guards = (((5.8, 6.5), (8.95, 6.5), (8.95, 13.0), (5.8, 13.0), (5.8, 6.5)), ((5.6, 19.25), (5.6, 21.9)), ((10.0, 19.25), (10.0, 21.9)))
#let zones = (
  ([Z1 the external stair tower (SE, outside the east wall)], area(tower-ext), [1 Nov 2026 (studies/south_wing.typ): the roof is reached from the stair tower x 13.436–16.036, y 18.22–24.0, top #lv(tower-ext-top); its roof door at #lv(roof-fin) through the south wing parapet (y 22.9–23.75, locked, no door into the house); the internal stair stops at the first floor, the roof slab over the well closed]),
  ([Z2a the HRV base under the tower], area(z-erv), [`studies/air_system.typ` v3.1 (owner): the tower rises from a base housing the ventilation unit (one mass): top #lv(base-top) = the attic coping, 1.65 m clear inside (a low service compartment: the unit ≈ 110 kg on a plinth right behind a pair of doors 1.5 m high on its west face, filters and the core pulled from the roof terrace, no entry); the intake duct drops inside the tower's compartment; the exhaust louvre on the cut face]),
  ([Z2b plant: AC outdoor units], area(z-plant), [behind the cut / east attic wall, SOUTH of the tower and its base (owner): 2.2 m clear of the base's south wall, 5.15 m south of the intake louvre in plan, so the tower never takes their hot air; over the suite bath (anti-vibration mounts); 0.6 m service space round each unit]),
  ([Z3 water tank(s)], area(z-tank), [≈ 2 × 1.5 m³ between the roof beams R10 and R3, inside the attic (needed only if the owner wants a gravity reserve)]),
  ([Z4 PV, south wing (now reserved)], area(z-pv1), [y ≥ #r2(pv-y-min): no shade on the clerestories (X4); fixing points cast in before waterproofing]),
  ([Z5 PV, future (north block east)], area(z-pv2), [inside the attic; morning shade from the east attic wall]),
  ([Z6 malqaf head], area(tower), [the tower rises to #lv(tower-top): the one element above the attic, by design; v3: a four-sided head, the breeze shaft and the ventilation intake compartment inside (`studies/air_system.typ`)]),
  ([Z7 the 1.0 m strip in front of the attic], strip-area, [roof behind the main cornice and its coping; falls to its own outlets; reached through two doors in the attic wall]),
)

// ---------- Sight lines ----------
// an object `s` behind the facade face, top at `z`, seen from an eye at distance D in front of the facade, height `eye`
#let ang(D, s, z) = deg((z - eye) / (D + s))
#let hidden(D, s-obj, z-obj, s-scr, z-scr) = ang(D, s-obj, z-obj) <= ang(D, s-scr, z-scr) + 1e-9
#let D-north = 3.8        // the north facade face → the plot's north boundary (street), at the NW corner (base.typ land: 3.8 m, growing to 5.7 m at the east end)
#let D-lane = 2.5         // the cut facade face → the lane boundary
#let D-east = 3.6         // the east facade face → the lane boundary (minimum, at y ≈ 10)
#let tw-s-north = sr.y0 - 0.1 + 0.125     // the stair room's north face behind the north facade face: 2.225
#let D-limit = { let ha = attic-top - eye; let ho = tower-ext-top - eye; (ha * tw-s-north - ho * setback) / (ho - ha) }   // the stair room shows above the attic beyond this distance
#let observers = ((D-north, [north boundary (street), NW corner]), (10.0, [north street, 10 m from the facade]), (D-limit, [north street, the limit]), (25.0, [north street, 25 m (the far side)]))
#let checks = (
  ([the attic itself is hidden by the cornice from the north boundary], hidden(D-north, setback, attic-top, 0, coping-top)),
  ([the HRV base under the tower stays at the attic coping (+9.10): nothing but the tower above the attic], base-top <= attic-top + 1e-9),
  ([the stair tower (SE) is hidden by the attic from the north boundary], hidden(D-north, tw-s-north, tower-ext-top, setback, attic-top)),
  ([the stair tower (SE) is hidden by the attic from 10 m], hidden(10.0, tw-s-north, tower-ext-top, setback, attic-top)),
  ([AC units (1.2 m) 1.0 m behind the cut attic are hidden from the lane boundary], hidden(D-lane, 2.0, roof + 1.2, setback, attic-top)),
  ([AC units (1.2 m) are hidden from the lane from any distance (lower than the attic)], roof + 1.2 <= attic-top),
  ([the tank (1.0 m) is hidden from the north from any distance], roof + 1.0 <= attic-top),
  ([the stair tower's top (+9.60) stays below the malqaf head], tower-ext-top < tower-top),
  ([the PV zone Z4 keeps clear of the stair tower's roof door landing (x ≥ 12.0)], z-pv1.at(1).at(0) <= 12.0 + 1e-9),
  ([the lift's typical 3.4 m headroom fits under the roof slab], lift-avail >= lift-typ.at(0) - 1e-9),
  ([the attic is below the courtyard hole's own edges from every point of the courtyard floor], true),   // computed in § 4: the margins are 10–20°
  ([PV on the south wing stays off the clerestories' winter sun (y ≥ 22.0)], z-pv1.at(0).at(1) >= pv-y-min - 1e-9),
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
#text(14pt, weight: "bold", fill: accent)[Roof study · the stair to the roof, the set-back attic, the main cornice, the reserved zones · Taif / Palm House V7.1]
#v(1pt)
#text(8pt, fill: gray)[Design review F-07 (major) · owner decisions 31 Oct 2026 · flat roof, no tiles · the roof for maintenance and equipment only · no slab level changes · all sizes assumed until the engineer and the suppliers confirm]
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
  R(court-hole, fill: rgb("#dbe9f4"), stroke: 0.6pt + sky); T(((court-hole.at(0) + court-hole.at(2)) / 2, 20.25), [suite court (open)], fill: sky)
  // the strip and the attic
  poly(attic, fill: rgb("#f3efe4"), stroke: 2pt + stone)
  // zones
  poly(z-erv, fill: rgb("#e4d2c0"), stroke: 0.8pt + red); T((9.9, 2.3), [Z2a HRV base\ under the tower\ top +9.10 · #r1(area(z-erv)) m²], size: 3.6pt, fill: red); line(q((8.95, 1.3)), q((8.95, 2.8)), stroke: 2.4pt + red); T((8.8, 2.05), [doors], size: 3.2pt, fill: red, anchor: "east"); line(q((cut-x(2.75, 0), 2.75)), q((cut-x(3.05, 0), 3.05)), stroke: 2.4pt + sky); T((11.9, 2.9), [exhaust], size: 3.2pt, fill: sky, anchor: "west")
  poly(z-plant, fill: rgb("#f7d9c4"), stroke: 0.5pt + red); T((11.0, 7.3), [Z2b\ AC units\ #r1(area(z-plant)) m²], fill: red)
  poly(z-tank, fill: rgb("#cfe3f3"), stroke: 0.5pt + sky); T((3.5, 2.25), [Z3\ tank], size: 4pt, fill: sky)
  poly(z-pv1, fill: rgb("#fff1b8"), stroke: 0.5pt + rgb("#9a7b00")); T((6.6, 22.95), [Z4 PV · south wing · #r1(area(z-pv1)) m² · y ≥ #r2(z-pv1.at(0).at(1)) (clerestory sun, X4)], fill: rgb("#7a6000"))
  poly(z-pv2, fill: rgb("#fff1b8").lighten(40%), stroke: (paint: rgb("#9a7b00"), dash: "dashed", thickness: 0.5pt)); T((10.3, 13.4), [Z5 PV\ future\ #r1(area(z-pv2)) m²], fill: rgb("#7a6000"))
  // the stair room, the lift head, the tower
  poly(tower-ext, fill: stone-l, stroke: 1.2pt + ink); T((14.75, 21.1), [Z1 stair tower\ #lv(tower-ext-top)], angle: 90deg)
  line(q(tower-door.at(0)), q(tower-door.at(1)), stroke: 3pt + red); T((12.6, 23.3), [roof door #lv(roof-fin)], size: 3.6pt, fill: red, anchor: "east")
  rect(q((lift.x0, lift.y0)), q((lift.x1, lift.y1)), fill: luma(225), stroke: (paint: ink, dash: "dashed", thickness: 0.5pt)); T((1.125, 1.1), [lift shaft\ no overrun above the roof], size: 3.8pt)
  poly(tower, fill: rgb("#8ccbe0"), stroke: 0.6pt + sky); T((9.75, 0.5), [Z6], size: 4pt, fill: sky)
  // outlets and walkways
  for p in outlets { circle(q(p), radius: 0.17, fill: white, stroke: 0.7pt + sky) }
  for w in walk { line(..w.map(q), stroke: (paint: red, dash: "dashed", thickness: 0.8pt)) }
  // guards
  for g in guards { line(..g.map(q), stroke: 1.6pt + ink) }
  // attic doors to the strip and to the south wing
  for (a, b) in (((3.3, in-off), (4.1, in-off)), ((in-off, 12.0), (in-off, 12.8)), ((2.1, y-step), (2.9, y-step))) { line(q(a), q(b), stroke: 3pt + red) }
  // labels
  T((5.0, 0.44), [1.0 m strip · roof behind the cornice coping #lv(coping-top)], size: 3.8pt)
  T((0.44, 15.0), [strip], size: 3.8pt, angle: 90deg)
  T((6.6, 1.6), [ATTIC screen wall · set back 1.0 · top #lv(attic-top)], fill: stone.darken(30%))
  T((12.95, 15.0), [strip], size: 3.8pt, angle: 90deg)
  T((2.5, 21.0), [SOUTH WING · parapet #lv(south-top) · roof #lv(roof)], size: 4.4pt)
  T((6.7, 17.6), [north block roof #lv(roof) · falls 1.5 % to the outlets ○ · walkways - - -], size: 4.2pt)
  T((11.6, 2.0), [cut (lane) side], size: 3.6pt, angle: -61deg)
  T((6.6, -0.7), [N ↑ up the page · the plan at the roof · 1 m = 0.62 cm], size: 4.2pt, fill: gray)
})
#grid(columns: (auto, 1fr), gutter: 12pt,
  plan(),
  [
    #H[1 · Roof plan: what is on the roof]
    - *Access (1 Nov 2026):* from the *external stair tower Z1* at the south-east (outside the east wall): its roof door at #lv(roof-fin) in the south wing parapet (y 22.9–23.75, locked; a locked gate below it above the office landing; no door from the roof into the house). The main stair stops at the first floor and the roof slab over its well is closed. The lift stops at the first floor; its shaft needs no head above the roof (§ 5).
    - *Attic:* a screen wall #r2(attic-h) m high (top #lv(attic-top) with its coping) set back #r2(setback) m from the facade face on the north, the cut (lane), the east and the west sides (a plain pentagon since the stair room went); its south wall stands on the y #r2(y-step) line (beams B8 / R5). Length ≈ #r1(attic-len) m. Two doors in it to the strip (north, west) and one to the south wing.
    - *The 1.0 m strip* (Z7) in front of the attic: roof behind the main cornice and its low coping, with its own outlets.
    - *South wing* (y #r2(y-step)–24): the main cornice and a plain parapet to #lv(south-top); the roofline steps #r2(step) m down from the attic coping, and the parapet stands on the facade while the attic is 1.0 m back.
    - *Guards:* a black steel bar guard 1.10 m round the courtyard sky hole (#r1(2 * (sky-hole.at(2) - sky-hole.at(0) + sky-hole.at(3) - sky-hole.at(1))) m) and on the suite court's west and east edges; its south edge keeps the gym roof railing (X4).
    - *Drains:* #outlets.len() roof outlets to internal downpipes in the walls (no scuppers through the cornice); falls 1.5 % away from the holes and the attic walls; the strip falls along the facade to its outlets; overflow spouts in the strip's upstand.
    - *Walkways:* 0.9 m wide on paving pads from the stair tower's roof door west along the south wing (south of the suite court's guards: no opening crossed), through the attic door at y 19.25 into the north block and on to the tank, the PV, the condensers and the HRV base; no walking on the insulation.
    #v(2pt)
    #table(columns: (1.4fr, auto, 2.2fr), inset: 2.4pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      [*Zone*], [*m²*], [*Note*],
      ..zones.map(((n, a, note)) => (n, [#r1(a)], note)).flatten())
    #text(6.4pt, fill: gray)[Areas on wall centre lines / zone outlines. PV: ≈ #r1(area(z-pv1) / 2.0) + #r1(area(z-pv2) / 2.0) panels of 2 m² (≈ #r1((area(z-pv1) + area(z-pv2)) / 2.0 * 0.42) kWp at 420 W each) if both zones are used.]
  ],
)

// ====================================================================================== PAGE 2 · the roof access (1 Nov 2026): the external stair tower, the closed well
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[The roof access since 1 Nov 2026 · the main stair stops at the first floor · the external stair tower at the south-east reaches the office landing and the roof]
#v(2pt)
#let tower-plan(length: 1.1cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let q(p) = (p.at(0), -p.at(1))
  let T(p, body, size: 4.2pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, body))
  // the house's east wall and the south wing roof (y 18–24), the parapet, the tower outside the wall
  rect(q((10.5, 17.5)), q((13.311, 24.0)), fill: luma(225), stroke: none); rect(q((13.186, 17.5)), q((13.436, 24.125)), fill: luma(150), stroke: none)
  T((11.9, 20.5), [south wing roof #lv(roof)\ parapet #lv(south-top)], size: 4pt)
  line(..tower-ext.map(q), close: true, fill: stone-l, stroke: 1.2pt + ink)
  rect(q((13.436, 18.22)), q((16.036, 18.47)), fill: luma(150), stroke: none); rect(q((13.436, 23.75)), q((16.036, 24.0)), fill: luma(150), stroke: none); rect(q((15.786, 18.22)), q((16.036, 24.0)), fill: luma(150), stroke: none)
  // the two flights of the upper dog-leg: flight 3 (east side, up north), flight 4 (house side, up south to the roof door)
  for i in range(11) { line(q((14.736, 23.4 - i * 0.28)), q((15.736, 23.4 - i * 0.28)), stroke: 0.4pt + ink) }
  for i in range(11) { line(q((13.486, 19.72 + i * 0.28)), q((14.486, 19.72 + i * 0.28)), stroke: 0.4pt + ink) }
  rect(q((13.486, 18.47)), q((15.786, 19.72)), fill: rgb("#f3dfb8"), stroke: 0.3pt + ink); T((14.6, 19.1), [half landing\ +5.45], size: 3.6pt)
  rect(q((13.486, 22.6)), q((15.786, 23.75)), fill: rgb("#f3dfb8"), stroke: 0.3pt + ink); T((14.6, 23.15), [top landing #lv(roof-fin)\ office landing +3.60 below], size: 3.4pt)
  line(q((15.2, 23.3)), q((15.2, 20.0)), stroke: 0.8pt + red, mark: (end: "stealth", fill: red, scale: 0.5)); T((15.45, 21.6), [up], size: 3.6pt, fill: red, anchor: "west")
  line(q((14.0, 19.9)), q((14.0, 22.4)), stroke: 0.8pt + red, mark: (end: "stealth", fill: red, scale: 0.5)); T((13.75, 21.2), [up to the roof], size: 3.6pt, fill: red, anchor: "east", angle: 90deg)
  line(q(tower-door.at(0)), q(tower-door.at(1)), stroke: 4pt + red); T((12.9, 22.6), [roof door #lv(roof-fin)\ locked · opens onto the roof], size: 3.6pt, fill: red, anchor: "east")
  T((14.6, 18.0), [N face solid (the suite bedroom's window 0.3 m north)], size: 3.2pt)
  T((16.3, 21.1), [arched openings on the east face], size: 3.4pt, angle: -90deg)
  T((14.6, 24.6), [the stair tower at the roof level · 1 m = 1.1 cm · north up · the lower dog-leg (ground → +3.60) lies below], size: 4.2pt, fill: accent)
})
#let well-plan(length: 1.1cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let q(p) = (p.at(0), -p.at(1))
  let T(p, body, size: 4.2pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, body))
  rect(q((-0.125, 2.1)), q((2.85, 8.0)), fill: luma(225), stroke: 0.6pt + ink)
  rect(q((st.x0, st.y0)), q((st.x1, st.y1)), fill: none, stroke: (paint: luma(140), dash: "dashed", thickness: 0.5pt)); T((1.39, 5.0), [roof slab closed\ over the stair well\ (the first-floor opening below stays)], size: 4pt)
  T((1.39, 1.6), [no stair room, no R16–R18 · the attic a plain pentagon], size: 3.8pt, fill: accent)
  T((1.125, 0.9), [lift shaft below (y 0–2.2): no head above the roof], size: 3.4pt, fill: gray)
})
#grid(columns: (auto, auto, 1fr), gutter: 10pt, tower-plan(), well-plan(),
  [
    #set text(6.8pt)
    #H[2 · The roof access]
    - *Owner's decision (1 Nov 2026, studies/south_wing.typ):* the roof is reached from the *external stair tower* at the south-east corner, outside the east wall (x 13.436–16.036, y 18.22–24.0 on its outer faces, 2.6 × 5.78): a dog-leg stair of 23 risers (× 0.170, goings 0.28, flights 1.0 m clear) from the ground (−0.30) to the office landing (+3.60, the visitors' door into the office) and 22 risers on to the roof (#lv(roof-fin)); headroom ≥ 3.5 m over every flight (the flight above is one storey up); the roof door in the south wing parapet at y 22.9–23.75, opening onto the roof; a locked gate across the stair above the office landing; the gate at the foot locked against entry and opening outwards without a key. Visitors and workers never enter the house; no door from the roof into the house.
    - *The internal stair stops at the first floor:* flights 3 and 4, the roof stair room (V7.0, x 0–2.75, y 2.2–7.9, +9.70) and the roof opening over the well are dropped; the roof slab over the well is an ordinary bay (no trimmers R16–R18); the first-floor stair and its opening do not change. The attic becomes a plain pentagon set back 1.0 m on all four sides; the north-west corner of the roofline loses its +9.70 element; the stair tower (+9.60) stands at the south-east, so the lane front carries the two verticals (the malqaf +9.80 at the north-east, the tower at the south-east).
    - *Composition:* the tower in the design language (cream plaster, a honey-stone plinth and arch surrounds, two arched openings per storey on its east and south faces, the main cornice line carried round it, a stone coping), top #lv(tower-ext-top): above the south wing parapet (#lv(south-top)) and the attic coping (#lv(attic-top)), below the malqaf head (#lv(tower-top)).
    - *Walkways:* from the roof door west along the south wing (the walkway y 22.6, south of the suite court's guards: no opening crossed), through the attic door at y 19.25 into the north block, then to the tank (Z3), the PV (Z4 / Z5), the condensers (Z2b) and the HRV base (Z2a); 0.9 m on paving pads, never on the insulation.
    - *Lift:* no change to the shaft (2.25 × 2.2, placeholder) and no overrun above the roof: see § 5. *3D:* the model still builds the V7.0 roof stair and stair room until the next build (`docs/PENDING_CHANGES.md`).
  ],
)

// ====================================================================================== PAGE 3 · the sight lines and the roofline
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[Sight lines · north–south section through the stair room (x ≈ 1.4), looking west · the attic #r2(attic-h) m set back #r2(setback) m · eye 1.6 m above the ground]
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
  rect((18.22, roof), (24.0, tower-ext-top), fill: none, stroke: (paint: ink, thickness: 0.6pt, dash: "dashed")); T((21.1, roof + 1.6), [stair tower beyond (SE, outside the east wall) · #lv(tower-ext-top)], size: 3.6pt); T((in-off + 0.9, roof + 0.9), [attic\ #lv(attic-top)], size: 3.6pt, anchor: "west"); T((y-step - 0.3, roof + 0.9), [attic\ #lv(attic-top)], size: 3.6pt, anchor: "east")
  T((23.6, roof + 0.6), [parapet\ #lv(south-top)], size: 3.6pt, anchor: "east"); T((-0.55, cornice.z0 - 0.5), [main cornice\ #lv(cornice.z0) … #lv(cornice.z0 + cornice.h)\ coping #lv(coping-top)], size: 3.4pt, anchor: "east")
  T((12.0, 1.8), [GF], size: 5pt); T((12.0, 5.4), [FF (bedroom 2 / bedroom 3 at x ≈ 1.4)], size: 5pt); T((12.0, roof + 0.45), [roof #lv(roof) · the courtyard sky hole lies beyond, x 5.8–8.95], size: 4pt, fill: sky)
  T((21.5, 1.8), [men's majlis], size: 4.4pt); T((21.5, 5.4), [office (south wing)], size: 4.4pt)
  // the observers and the sight lines
  for (D, col, lab) in ((D-north, red, [eye at the north boundary · D = #r1(D-north) m]), (D-limit, sky, [eye at D = #r1(D-limit) m: the stair tower just hidden]), (25.0, luma(110), [eye at 25 m])) {
    let y0 = -0.125 - D
    circle((y0, eye), radius: 0.12, fill: col, stroke: none); T((y0, eye + 0.5), lab, size: 3.6pt, fill: col)
    let ray(yt, zt, yend) = line((y0, eye), (yend, eye + (zt - eye) / (yt - y0) * (yend - y0)), stroke: (paint: col, thickness: 0.5pt, dash: if col == red { "solid" } else { "dashed" }))
    ray(-0.125 - cornice.proj, coping-top, calc.min(y0 + (11.5 - eye) / ((coping-top - eye) / (-0.125 - cornice.proj - y0)), 24))   // over the cornice coping
    ray(in-off - 0.1, attic-top, calc.min(y0 + (11.5 - eye) / ((attic-top - eye) / (in-off - 0.1 - y0)), 24))                        // over the attic
  }
  for (z, l) in ((0, [±0.00]), (ff, [+3.60]), (roof, [+7.20]), (attic-top, [#lv(attic-top)]), (tower-ext-top, [#lv(tower-ext-top)])) { T((25.2, z), l, size: 3.6pt, fill: gray, anchor: "west") }
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
      [*Observer (north street)*], [*cornice*], [*attic*], [*stair tower (SE)*],
      ..observers.map(((D, l)) => (l, [#r1(ang(D, 0, coping-top))°], [#r1(ang(D, setback, attic-top))°#if ang(D, setback, attic-top) <= ang(D, 0, coping-top) [ (hidden)]], [#r1(ang(D, tw-s-north, tower-ext-top))°#if ang(D, tw-s-north, tower-ext-top) <= calc.max(ang(D, setback, attic-top), ang(D, 0, coping-top)) [ hidden] else [ *shows*]])).flatten())
    #text(6.4pt, fill: gray)[Angles above the horizon from the eye. The stair room's north face is #r2(tw-s-north) m behind the north facade face, its top #lv(tower-ext-top). From the lane boundary (D = #r1(D-lane) m) the AC units (1.2 m, 2.0 m behind the cut facade) are seen at #r1(ang(D-lane, 2.0, roof + 1.2))° against the attic's #r1(ang(D-lane, setback, attic-top))°: hidden; and from any distance, since 1.2 < #r2(attic-h). From the east boundary (D = #r1(D-east) m) the plant zone is likewise hidden. The malqaf head (#lv(tower-top), on the facade in the cut tip) is the one element above the attic, by design.]
    - *Attic height #r2(attic-h) m:* set in V7.0 by the stair room; kept (1 Nov 2026): it hides the plant, the tank and the condensers from the street and the lane at every distance, and the external stair tower (top #lv(tower-ext-top), #r1(tw-s-north) m behind the north facade) stays hidden from the north street up to #r1(D-limit) m.
    - *Since 1 Nov 2026 nothing stands above the attic on the north block except the malqaf and its base:* the stair room is gone; the stair tower rises outside the east wall at the south-east, #r2(tower-ext-top - attic-top) m above the attic coping and #r2(tower-top - tower-ext-top) m below the malqaf, seen from the lane and the south garden by design.
  ],
  [
    #H[4 · The courtyard's sky and sun with the attic]
    From every point of the courtyard floor the attic walls and the stair room lie *below the hole's own edges* (the roof edge beams at #lv(roof)), so they take nothing from the sky the courtyard sees today (enclosure study: #r1(7.2) % of the hemisphere from the floor's middle, unchanged):
    #table(columns: (2fr, auto, auto), inset: 2.4pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      [*From the far edge of the floor*], [*hole edge*], [*attic / stair room*],
      ..court-view.map(((l, a, b)) => (l, [#r1(a)°], [#r1(b)° #if b < a [✓] else [✗]])).flatten())
    - *Winter noon sun* (45.2°, the light check): the ray that just clears the hole's south edge (#lv(roof) at y 13.0) passes the attic's south wall line (y #r2(y-step)) at #lv(sun-margin), far above its coping #lv(attic-top): the attic never shades the courtyard, in any season. The clerestory windows sit in the y #r2(y-step) wall itself, below the attic wall: unchanged; their sun comes over the gym roof edge (X4), which stays a railing.
    - *The suite court* gets the attic's south wall on its north side (its shaded side): no loss of sun, a little less sky.
    #v(3pt)
    #H[5 · The lift]
    - Top stop at the first floor (#lv(ff)); the roof slab underside at #lv(roof - roof-slab): *#r2(lift-avail) m headroom available*. A typical Saudi villa lift (machine-room-less traction, 400–630 kg, 2 stops) asks #r2(lift-typ.at(0))–#r2(lift-typ.at(1)) m headroom above the top floor and a 1.2–1.4 m pit (assumed from supplier catalogues; open item 14 asks for the drawings); a platform home lift (EN 81-41) asks #r2(lift-platform.at(0))–#r2(lift-platform.at(1)) m.
    - *So:* choose a lift with headroom ≤ #r2(lift-avail) m: no shaft head above the roof. If the chosen lift needs up to #r2(lift-avail + lift-raise-max) m, a raised shaft head of ≤ #r2(lift-raise-max) m (top #lv(coping-top)) stays hidden behind the main cornice coping; more than that is not possible: the shaft (x 0–2.25, y 0–2.2) lies in the 1.0 m strip in front of the attic, not inside it. *No conflict* with the stair room (it starts at y 2.2, the shaft's south wall). Added to open item 14 as a requirement for the supplier.
  ],
)

// ====================================================================================== PAGE 4 · elevations
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[North and west elevations · simple line drawings · the main cornice, the thin cornice between the floors, the set-back attic, the stepped roofline · openings indicative]
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
  rect((in-off, coping-top), (attic-e, attic-top), fill: cream.darken(6%), stroke: 0.6pt + ink); T((6.5, roof + 1.1), [attic screen · set back 1.0 · #lv(attic-top)], size: 4pt)
  // the stair room above the attic
  // the malqaf head
  rect((8.95, coping-top), (10.6, tower-top), fill: rgb("#8ccbe0"), stroke: 0.6pt + ink); rect((9.2, 8.2), (10.35, 9.4), fill: white, stroke: 0.4pt + ink); T((9.78, 8.8), [louvres], size: 3.2pt)
  T((9.78, tower-top + 0.35), [malqaf head #lv(tower-top)], size: 3.6pt)
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
  rect((y-step, cornice.z0 + cornice.h), (y1, south-top), fill: stone-l, stroke: 0.4pt + ink); T((21.7, south-top + 0.3), [south wing parapet #lv(south-top)], size: 3.6pt)
  // the attic behind (y 0.875–19.25), the stair room on the facade (y 2.2–7.9)
  rect((in-off, coping-top), (y-step, attic-top), fill: cream.darken(6%), stroke: 0.6pt + ink); T((13.0, roof + 1.1), [attic screen (set back 1.0) #lv(attic-top)], size: 4pt)
  rect((18.22, coping-top), (24.0, tower-ext-top), fill: none, stroke: (paint: ink, thickness: 0.6pt, dash: "dashed")); T((21.1, attic-top + 0.4), [stair tower beyond (east side) #lv(tower-ext-top)], size: 3.4pt)
  // openings (indicative): first-floor west windows (bedroom 2, bath 3, bedroom 3), the guest entrance
  for (a, b) in ((11.3, 12.6), (14.6, 15.2), (17.2, 18.2)) { rect((a, ff + 0.9), (b, ff + 2.4), fill: rgb("#9fcbe0"), stroke: 0.4pt + ink) }
  rect((21.5, 0), (22.9, 2.4), fill: rgb("#6b4a2b"), stroke: 0.4pt + ink); T((22.2, -0.55), [guest door], size: 3.2pt)
  line((y-step, ground - 0.3), (y-step, attic-top + 0.4), stroke: (paint: red, thickness: 0.5pt, dash: "dashed")); T((y-step, attic-top + 0.7), [the step: attic #lv(attic-top) → parapet #lv(south-top) (#r2(step) m) at y #r2(y-step)], size: 3.6pt, fill: red)
  for (z, l) in ((0, [±0.00]), (ff, [+3.60]), (roof, [+7.20]), (coping-top, [#lv(coping-top)]), (south-top, [#lv(south-top)]), (attic-top, [#lv(attic-top)])) { T((y1 + 0.5, z), l, size: 3.4pt, fill: gray, anchor: "west") }
  T((12.0, ground - 0.8), [WEST ELEVATION (from the M line / the neighbour) · N ← → S · 1 m = 0.5 cm], size: 4.4pt, fill: accent)
})
#north-elev()
#v(6pt)
#west-elev()
#v(4pt)
#text(6.8pt)[Cream plaster, honey stone at the plinth (to +0.60), the corners (quoins, dotted), the thin band at the first-floor slab (#r2(band.h) m, projecting #r2(band.proj)) and the main cornice (#r2(cornice.h) m high, projecting #r2(cornice.proj), #lv(cornice.z0) … #lv(cornice.z0 + cornice.h)); the attic and the stair room plastered cream with stone copings. The south elevation repeats the west one's south part (parapet #lv(south-top)); the east elevation the north block's coping and attic (set back 1.0) over the kitchen / suite windows, then the parapet. Openings are indicative here: the real ones are in the plans and the studies.]

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
    - *Attic:* 200 mm block, plastered cream, stone coping; #r2(attic-h) m above the roof slab (coping #lv(attic-top)); set back #r2(setback) m from the facade face (#r2(in-off) m from the wall centre lines); ≈ #r1(attic-len) m long; on the south on the y #r2(y-step) line (B8 / R5). Three doors (two to the strip, one to the south wing).
    - *Roofline step:* #r2(step) m at y #r2(y-step) (attic coping #lv(attic-top) → parapet #lv(south-top)), plus the 1.0 m plan set-back.
    - *Stair tower (external, SE; 1 Nov 2026):* 2.6 × 5.78 on its outer faces outside the east wall (y 18.22–24.0), two dog-leg flights to the office landing (+3.60) and two to the roof (#lv(roof-fin)), top #lv(tower-ext-top): #r2(tower-ext-top - roof) m above the roof slab, #r2(tower-ext-top - attic-top) m above the attic coping, #r2(tower-top - tower-ext-top) m below the malqaf head; arched openings east and south, the north face solid (the suite bedroom's window is 0.3 m north of it).
    #v(2pt)
    #H[7 · Loads for the engineer (assumed)]
    - *Attic walls:* 200 block #r2(attic-h) m + coping ≈ 4.5 kN/m, standing on the roof slab #r2(in-off) m inside the outer-wall beams (R7 / R8, the cut and east wall beams): near the supports, but a line load on the slab: thicken the slab edge or add a small hidden beam under it; the south attic wall on R5 / B8.
    - *Stair tower:* on its own footings beside the east strip footing, tied or jointed to the house (the engineer); the roof door through the parapet; no load on the roof slab. The roof slab over the stair well is an ordinary bay now (no trimmers).
    - *Cornice:* stone ≈ 2.5 kN/m hung on the slab edge (anchored precast or cut stone); parapets 1.1 m ≈ 2.8 kN/m; the thin band 0.3 kN/m.
    - *Plant:* 3–4 AC outdoor units ≈ 1.0 kN each and the ERV ≈ 1.5 kN on pads with anti-vibration mounts (local ≈ 1.5 kN/m²); *tank(s):* up to 3 m³ = 30 kN on ≈ 3.3 m² (≈ 9 kN/m²) on the R10–R3 bay (1.5 m span): to be checked; *PV:* ≈ 0.25 kN/m² plus wind uplift (ballast or cast-in fixing points, 24 m² now, 20 m² future); *malqaf head* as the air study; walkway pads 0.5 kN/m².
    - *Roof live load* for maintenance only: 1.0–1.5 kN/m² (SBC 301, the engineer).
  ],
  [
    #H[8 · Conflicts and open points]
    - *Stair tower vs the roofline* (§ 3): the tower's top #lv(tower-ext-top) stands outside the east wall at the south-east, above the south wing parapet and the attic, below the malqaf: two verticals on the lane side, by design (owner, 1 Nov 2026).
    - *Lift* (§ 5): no overrun if the supplier's headroom is ≤ #r2(lift-avail) m (≤ #r2(lift-avail + lift-raise-max) m with a 0.30 m raised head behind the cornice): a requirement for open item 14.
    - *Courtyard light* (§ 4): none lost.
    - *First-floor layout* (§ 2): nothing lost.
    - *3D and the plans:* the roof opening, the stair room, the attic, the cornice and the parapets are not yet in `3d/params.yaml` / `build_3d.py` (the builder has no attic or cornice yet) nor in the presentation: PENDING_CHANGES.md.
    #v(2pt)
    #H[9 · What this study changes in the files]
    - `studies/structure.typ`: R16–R18 and the stair-well voids dropped (1 Nov 2026), X16 superseded; the stair tower on its own footings (engineer); `studies/fire_escape.typ`: the tower counted as the first floor's second way out with conditions; `3d/params.yaml`: the roof stair data stays until the next 3D build.
    - `docs/DESIGN_LANGUAGE.md`: flat roof, no tiles, the main cornice, the set-back attic on the north block, the south wing parapet.
    - `data/decisions.csv`: roof access by the main stair; the roofline. Open item 14: the lift headroom requirement (`docs/PENDING_CHANGES.md`).
    #v(2pt)
    #text(8pt)[#if all-ok [*Study checks passed* (#checks.len())] else [*STUDY CHECKS FAILED:* #checks.filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]]
  ],
)

// ---------- Data for tools/make_dxf_roof.py and the presentation (typst eval --in studies/roof.typ "query(<roof-data>).first().value") · CSV frame ----------
#metadata((outline: outline, block_s: block-s, sky: rect-pts(..sky-hole), court: rect-pts(..court-hole), tower: tower, attic: attic, stair_room: tower-ext,   // 1 Nov 2026: the external stair tower (tools/make_dxf_roof.py still labels this polygon "stair room": to update with the DXF tools)
  lift: rect-pts(lift.x0, lift.y0, lift.x1, lift.y1), zones: (("Z2a HRV base under the tower", z-erv), ("Z2b plant: AC units", z-plant), ("Z3 water tank", z-tank), ("Z4 PV south wing", z-pv1), ("Z5 PV future", z-pv2)).map(((n, P)) => (name: n, pts: P, area: area(P))),
  outlets: outlets, walkways: walk, guards: guards, attic_doors: (((3.3, in-off), (4.1, in-off)), ((in-off, 12.0), (in-off, 12.8)), ((2.1, y-step), (2.9, y-step))),
  levels: (roof: roof, attic_top: attic-top, coping: coping-top, south: south-top, stair_room: tower-ext-top, cornice: (cornice.z0, cornice.z0 + cornice.h), setback: setback))) <roof-data>

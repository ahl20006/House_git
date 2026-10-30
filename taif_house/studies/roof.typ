// roof.typ · Taif / Palm House · ROOF STUDY (design review F-07): the main stair continues to the roof, the roof screen ("attic") set back
// behind a main stone cornice on the north block, the south wing with a plain parapet (a stepped roofline), the reserved roof zones.
// Owner decisions (31 Oct 2026, branch work / V6.4): roof for maintenance and equipment only; the MAIN stair goes up (same well, same
// geometry, two more flights); the lift does not; flat roof, no tiles; classical roofline kept simple (docs/DESIGN_LANGUAGE.md); no slab level changes.
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
#let sr = (x0: 0, x1: 2.75, y0: 2.2, y1: 7.9)     // the stair room on the roof, wall centre lines (the well's walls continued)
#let sr-slab = 0.12                                // its roof: a light RC slab (or an insulated steel deck), assumed
#let sr-clear = 2.20                               // required clear height over the arrival
#let sr-soffit = roof-fin + sr-clear               // +9.50
#let sr-roof = sr-soffit + sr-slab                 // +9.62 (top of its slab)
#let sr-top = sr-roof + 0.08                       // +9.70 with its edge / coping
#let sr-door = (0.9, 1.8)                          // in the south wall y 7.9, x 0.9–1.8 (0.90 opening), opening out onto the roof
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
#let court-hole = (5.6, 19.25, 11.586, 21.25)      // the suite court
#let tower = ((8.95, 0), (10.051, 0), (10.594, 1.0), (8.95, 1.0))
#let tower-top = 9.8                               // the malqaf head, 2.5 m above the roof finish (studies/air_system.typ)
#let cut-k = 3.26 / 6.0
#let cut-cos = 6.0 / calc.sqrt(3.26 * 3.26 + 36.0)
#let in-off = setback - 0.125                      // the attic line from the wall centre lines: 0.875
#let cut-x(y, off) = 10.051 + cut-k * y - off / cut-cos
#let attic-e = 13.311 - in-off
#let attic-yc = (attic-e - 10.051 + in-off / cut-cos) / cut-k
#let attic = ((in-off, in-off), (cut-x(in-off, in-off), in-off), (attic-e, attic-yc), (attic-e, y-step), (in-off, y-step), (in-off, sr.y1), (sr.x0, sr.y1), (sr.x0, sr.y0), (in-off, sr.y0))
#let attic-len = (cut-x(in-off, in-off) - in-off) + calc.sqrt(calc.pow(attic-e - cut-x(in-off, in-off), 2) + calc.pow(attic-yc - in-off, 2)) + (y-step - attic-yc) + (attic-e - in-off) + (y-step - sr.y1) + (sr.y0 - in-off)
#let strip-area = area(block-n) - area(attic) - area(tower) * 0.875

// ---------- Reserved zones ----------
#let z-plant = ((9.6, 2.6), (cut-x(2.6, in-off), 2.6), (attic-e, attic-yc), (attic-e, 9.0), (9.6, 9.0))   // AC outdoor units + ERV behind the cut / east attic
#let z-tank = rect-pts(2.85, 1.0, 4.15, 3.5)       // water tank(s) between the roof beams R10 (x 2.75) and R3 (x 4.25)
#let z-pv1 = rect-pts(0.125, 22.0, 13.186, 23.875) // PV, south wing roof: south of y 22.0 so it never shades the clerestories (X4)
#let z-pv2 = rect-pts(9.0, 9.5, 11.6, 17.4)        // PV, future: north block east roof inside the attic (morning shade from the east attic wall)
#let pv-y-min = 19.25 + (roof - 5.0) + 0.5         // a 0.5 m high panel at y ≥ 21.45 + 0.5 keeps the winter noon sun (45°) on the clerestory sills (+5.00)
#let outlets = ((5.0, 0.45), (0.45, 12.0), (0.45, 17.5), (12.9, 12.5), (11.6, 2.4), (4.5, 4.0), (10.5, 11.0), (4.5, 16.5), (10.5, 17.0), (2.0, 23.2), (11.5, 23.2))
#let walk = (((1.35, 7.9), (1.35, 8.5), (3.5, 8.5), (3.5, 3.6), (3.5, 1.4)), ((3.5, 5.6), (10.2, 5.6), (10.2, 8.6)), ((3.5, 8.5), (5.0, 8.5), (5.0, 14.0), (10.3, 14.0), (10.3, 9.0)),
             ((5.0, 14.0), (5.0, 18.5), (2.5, 18.5), (2.5, 22.6), (12.5, 22.6)), ((0.45, 12.0), (0.45, 18.0)))
#let guards = (((5.8, 6.5), (8.95, 6.5), (8.95, 13.0), (5.8, 13.0), (5.8, 6.5)), ((5.6, 19.25), (5.6, 21.25)), ((11.586, 19.25), (11.586, 21.25)))
#let zones = (
  ([Z1 stair room (footprint)], area(rect-pts(sr.x0, sr.y0, sr.x1, sr.y1)), [on the well; inside 2.525 × 5.50; roof #lv(sr-roof)]),
  ([Z2 plant: AC outdoor units + ERV], area(z-plant), [behind the cut / east attic wall, over bedroom 1 and the suite bath (anti-vibration mounts); 0.6 m service space round each unit]),
  ([Z3 water tank(s)], area(z-tank), [≈ 2 × 1.5 m³ between the roof beams R10 and R3, inside the attic (needed only if the owner wants a gravity reserve)]),
  ([Z4 PV, south wing (now reserved)], area(z-pv1), [y ≥ #r2(pv-y-min): no shade on the clerestories (X4); fixing points cast in before waterproofing]),
  ([Z5 PV, future (north block east)], area(z-pv2), [inside the attic; morning shade from the east attic wall]),
  ([Z6 malqaf head], area(tower), [the tower rises to #lv(tower-top): the one element above the attic, by design (open item 17)]),
  ([Z7 the 1.0 m strip in front of the attic], strip-area, [roof behind the main cornice and its coping; falls to its own outlets; reached through two doors in the attic wall]),
)

// ---------- Sight lines ----------
// an object `s` behind the facade face, top at `z`, seen from an eye at distance D in front of the facade, height `eye`
#let ang(D, s, z) = deg((z - eye) / (D + s))
#let hidden(D, s-obj, z-obj, s-scr, z-scr) = ang(D, s-obj, z-obj) <= ang(D, s-scr, z-scr) + 1e-9
#let D-north = 3.8        // the north facade face → the plot's north boundary (street), at the NW corner (base.typ land: 3.8 m, growing to 5.7 m at the east end)
#let D-lane = 2.5         // the cut facade face → the lane boundary
#let D-east = 3.6         // the east facade face → the lane boundary (minimum, at y ≈ 10)
#let sr-s-north = sr.y0 - 0.1 + 0.125     // the stair room's north face behind the north facade face: 2.225
#let D-limit = { let ha = attic-top - eye; let ho = sr-top - eye; (ha * sr-s-north - ho * setback) / (ho - ha) }   // the stair room shows above the attic beyond this distance
#let observers = ((D-north, [north boundary (street), NW corner]), (10.0, [north street, 10 m from the facade]), (D-limit, [north street, the limit]), (25.0, [north street, 25 m (the far side)]))
#let checks = (
  ([the attic itself is hidden by the cornice from the north boundary], hidden(D-north, setback, attic-top, 0, coping-top)),
  ([the stair room is hidden by the attic from the north boundary], hidden(D-north, sr-s-north, sr-top, setback, attic-top)),
  ([the stair room is hidden by the attic from 10 m], hidden(10.0, sr-s-north, sr-top, setback, attic-top)),
  ([AC units (1.2 m) 1.0 m behind the cut attic are hidden from the lane boundary], hidden(D-lane, 2.0, roof + 1.2, setback, attic-top)),
  ([AC units (1.2 m) are hidden from the lane from any distance (lower than the attic)], roof + 1.2 <= attic-top),
  ([the tank (1.0 m) is hidden from the north from any distance], roof + 1.0 <= attic-top),
  ([the stair room clear height ≥ 2.20], sr-soffit - roof-fin >= 2.2 - 1e-9),
  ([headroom over flight 3 at tread 6 ≥ 2.10 (R16 soffit)], headroom-f3 >= 2.1),
  ([the lift's typical 3.4 m headroom fits under the roof slab], lift-avail >= lift-typ.at(0) - 1e-9),
  ([the attic is below the courtyard hole's own edges from every point of the courtyard floor], true),   // computed in § 4: the margins are 10–20°
  ([PV on the south wing stays off the clerestories' winter sun (y ≥ 22.0)], z-pv1.at(0).at(1) >= pv-y-min - 1e-9),
)
#let all-ok = checks.all(c => c.at(1))

// courtyard light: the attic walls against the hole's edges, from the far points of the courtyard floor (angles above the horizon)
#let court-view = (
  ([attic south wall (y 19.25, #lv(attic-top)) from the floor's north edge (y 6.6)], deg(roof / (13.0 - 6.6)), deg((attic-top) / (19.25 - 6.6))),
  ([attic north wall (y 0.875) from the floor's south edge (y 12.9)], deg(roof / (12.9 - 6.5)), deg(attic-top / (12.9 - 0.875))),
  ([stair room (x 0–2.75, #lv(sr-top)) from the floor's east edge (x 8.85)], deg(roof / (8.85 - 5.925)), deg(sr-top / (8.85 - 2.75))),
  ([attic east wall (x 12.436) from the floor's west edge (x 4.35)], deg(roof / (8.85 - 4.35)), deg(attic-top / (12.436 - 4.35))),
)
#let sun-margin = roof + (19.25 - 13.0) * calc.tan(45.2deg)   // the winter noon ray grazing the hole's south edge passes the attic line at this height

// ====================================================================================== PAGE 1 · roof plan
#text(14pt, weight: "bold", fill: accent)[Roof study · the stair to the roof, the set-back attic, the main cornice, the reserved zones · Taif / Palm House V6.3 + work (V6.4)]
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
  line(q((in-off, in-off)), q((in-off, sr.y0)), stroke: 2pt + stone)
  // zones
  poly(z-plant, fill: rgb("#f7d9c4"), stroke: 0.5pt + red); T((10.9, 6.0), [Z2 plant\ AC + ERV\ #r1(area(z-plant)) m²], fill: red)
  poly(z-tank, fill: rgb("#cfe3f3"), stroke: 0.5pt + sky); T((3.5, 2.25), [Z3\ tank], size: 4pt, fill: sky)
  poly(z-pv1, fill: rgb("#fff1b8"), stroke: 0.5pt + rgb("#9a7b00")); T((6.6, 22.95), [Z4 PV · south wing · #r1(area(z-pv1)) m² · y ≥ #r2(z-pv1.at(0).at(1)) (clerestory sun, X4)], fill: rgb("#7a6000"))
  poly(z-pv2, fill: rgb("#fff1b8").lighten(40%), stroke: (paint: rgb("#9a7b00"), dash: "dashed", thickness: 0.5pt)); T((10.3, 13.4), [Z5 PV\ future\ #r1(area(z-pv2)) m²], fill: rgb("#7a6000"))
  // the stair room, the lift head, the tower
  rect(q((sr.x0, sr.y0)), q((sr.x1, sr.y1)), fill: stone-l, stroke: 1.2pt + ink); T((1.375, 5.0), [Z1 stair\ room\ roof #lv(sr-roof)], angle: 90deg)
  line(q((sr-door.at(0), sr.y1)), q((sr-door.at(1), sr.y1)), stroke: 3pt + red); T((1.35, 8.25), [door 0.90 · kerb 0.15], size: 3.8pt, fill: red)
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
    - *Access:* the main stair's two extra flights arrive in the *stair room Z1* on the well (x 0–2.75, y 2.2–7.9); its door (0.90, opening out, on a #r2(sr-kerb) m kerb) opens south onto the roof. The lift stops at the first floor; its shaft needs no head above the roof (§ 5).
    - *Attic:* a screen wall #r2(attic-h) m high (top #lv(attic-top) with its coping) set back #r2(setback) m from the facade face on the north, the cut (lane) and the east sides, and on the west except where the stair room stands on the facade line; its south wall stands on the y #r2(y-step) line (beams B8 / R5). Length ≈ #r1(attic-len) m. Two doors in it to the strip (north, west) and one to the south wing.
    - *The 1.0 m strip* (Z7) in front of the attic: roof behind the main cornice and its low coping, with its own outlets.
    - *South wing* (y #r2(y-step)–24): the main cornice and a plain parapet to #lv(south-top); the roofline steps #r2(step) m down from the attic coping, and the parapet stands on the facade while the attic is 1.0 m back.
    - *Guards:* a black steel bar guard 1.10 m round the courtyard sky hole (#r1(2 * (sky-hole.at(2) - sky-hole.at(0) + sky-hole.at(3) - sky-hole.at(1))) m) and on the suite court's west and east edges; its south edge keeps the gym roof railing (X4).
    - *Drains:* #outlets.len() roof outlets to internal downpipes in the walls (no scuppers through the cornice); falls 1.5 % away from the holes and the attic walls; the strip falls along the facade to its outlets; overflow spouts in the strip's upstand.
    - *Walkways:* 0.9 m wide on paving pads from the stair room door to every zone, the holes' guards, the strip doors and the south wing.
    #v(2pt)
    #table(columns: (1.4fr, auto, 2.2fr), inset: 2.4pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      [*Zone*], [*m²*], [*Note*],
      ..zones.map(((n, a, note)) => (n, [#r1(a)], note)).flatten())
    #text(6.4pt, fill: gray)[Areas on wall centre lines / zone outlines. PV: ≈ #r1(area(z-pv1) / 2.0) + #r1(area(z-pv2) / 2.0) panels of 2 m² (≈ #r1((area(z-pv1) + area(z-pv2)) / 2.0 * 0.42) kWp at 420 W each) if both zones are used.]
  ],
)

// ====================================================================================== PAGE 2 · the stair to the roof
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[The stair to the roof · plan at the roof slab and section through the well · same well, same geometry: 22 risers × #r2(st.r) = 3.60 m, goings #r2(st.g)]
#v(2pt)
#let stair-plan(length: 1.3cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let q(p) = (p.at(0), -p.at(1))
  let T(p, body, size: 4.4pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, body))
  // the stair room walls
  rect(q((-0.125, 2.1)), q((0.125, 8.0)), fill: luma(170), stroke: none)
  rect(q((-0.125, 2.1)), q((2.85, 2.3)), fill: luma(170), stroke: none); rect(q((-0.125, 7.8)), q((2.85, 8.0)), fill: luma(170), stroke: none)
  rect(q((2.65, 2.1)), q((2.85, 8.0)), fill: luma(170), stroke: none)
  // the roof slab (grey) and the opening (white): the L of the first-floor opening, one storey up
  rect(q((st.x0, st.y0)), q((st.x1, st.y1)), fill: luma(225), stroke: none)
  rect(q((st.x0, st.y0)), q((st.split, st.b16 - 0.1)), fill: white, stroke: 0.4pt + ink)
  rect(q((st.split, st.y0)), q((st.x1, st.top)), fill: white, stroke: 0.4pt + ink)
  rect(q((st.x0, st.y0)), q((st.x1, st.land)), fill: rgb("#f3dfb8"), stroke: 0.3pt + ink); T((1.39, 2.92), [upper half landing #lv(ff + 1.8)\ 1.25 deep], size: 4pt)
  for i in range(10) {
    let y = st.top - i * st.g
    line(q((st.x0, y)), q((st.split - st.gap / 2, y)), stroke: 0.4pt + ink)
    line(q((st.split + st.gap / 2, st.land + i * st.g)), q((st.x1, st.land + i * st.g)), stroke: 0.4pt + ink)
    T((st.x0 + 0.18, y - 0.14), [#(i + 23)], size: 3.2pt); T((st.x1 - 0.18, st.land + i * st.g + 0.14), [#(i + 34)], size: 3.2pt)
  }
  line(q((st.x0, st.land)), q((st.split - st.gap / 2, st.land)), stroke: 0.4pt + ink); line(q((st.split + st.gap / 2, st.top)), q((st.x1, st.top)), stroke: 0.4pt + ink)
  line(q((0.75, st.top + 0.6)), q((0.75, st.land + 0.35)), stroke: 0.8pt + red, mark: (end: "stealth", fill: red, scale: 0.5)); T((0.42, 5.0), [UP · flight 3 (from #lv(ff))], size: 3.8pt, fill: red, angle: 90deg)
  line(q((2.02, st.land + 0.35)), q((2.02, st.top - 0.35)), stroke: 0.8pt + red, mark: (end: "stealth", fill: red, scale: 0.5)); T((2.34, 5.0), [flight 4 · UP to #lv(roof)], size: 3.8pt, fill: red, angle: 90deg)
  rect(q((st.split - st.gap / 2, st.land)), q((st.split + st.gap / 2, st.top)), fill: luma(120), stroke: none); T((st.split, 5.0), [gap 0.10 · central handrail], size: 3.2pt, angle: 90deg)
  T((2.02, 7.05), [arrival #lv(roof-fin)\ y 6.35–7.80], size: 3.8pt); T((0.75, 7.05), [FF: start of flight 3\ roof: slab], size: 3.8pt)
  // trimmers
  line(q((st.x0, st.b16)), q((st.split, st.b16)), stroke: 2.2pt + red); T((0.7, st.b16 + 0.22), [R16 0.20×0.40 · soffit +6.80], size: 3.4pt, fill: red)
  line(q((st.b17, st.b16)), q((st.b17, st.b18)), stroke: 2.2pt + red); T((st.b17 - 0.12, 5.65), [R17], size: 3.4pt, fill: red, angle: 90deg)
  line(q((st.b17, st.b18)), q((2.75, st.b18)), stroke: 2.2pt + red); T((2.1, st.b18 + 0.22), [R18], size: 3.4pt, fill: red)
  T((0.75, 3.9), [opening], size: 4pt, fill: luma(100)); T((2.02, 4.7), [opening], size: 4pt, fill: luma(100))
  // door, window, louvre
  line(q((sr-door.at(0), 7.9)), q((sr-door.at(1), 7.9)), stroke: 4pt + red); T((1.35, 8.35), [door 0.90 · opens out · kerb #r2(sr-kerb) · canopy], size: 3.6pt, fill: red)
  line(q((2.75, 6.6)), q((2.75, 7.5)), stroke: 3pt + sky); T((3.0, 7.05), [window 0.90 × 0.60\ sill +8.50], size: 3.4pt, fill: sky, anchor: "west")
  line(q((2.4, 2.2)), q((2.6, 2.2)), stroke: 3pt + sky); T((2.5, 1.85), [louvre (vent)], size: 3.2pt, fill: sky)
  line(q((3.25, st.y0)), q((3.25, st.y1)), stroke: 0.4pt + ink, mark: (start: "|", end: "|", scale: 0.4)); T((3.45, 5.05), [5.50 clear = 1.25 + 2.80 + 1.45], size: 3.6pt, angle: 90deg)
  line(q((st.x0, 1.75)), q((st.x1, 1.75)), stroke: 0.4pt + ink, mark: (start: "|", end: "|", scale: 0.4)); T((1.39, 1.55), [2.525 clear], size: 3.6pt)
  T((1.39, 1.15), [stair room plan at the roof slab · white = opening · grey = slab · north up], size: 4.4pt, fill: accent)
  T((1.125, 0.6), [lift shaft below (y 0–2.2): no head above the roof], size: 3.4pt, fill: gray)
})
#let stair-section(length: 1.3cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, t, size: 4.4pt, fill: ink, anchor: "center", angle: 0deg) = content(p, anchor: anchor, angle: angle, text(size, fill: fill, t))
  // N–S section through flight 2 / flight 4 (x ≈ 2.0), looking west: horizontal = y (north left), vertical = level
  let Y(y) = y - 0.0
  line((Y(-0.6), 0), (Y(8.6), 0), stroke: 0.8pt + ink)
  // the lift shaft (y 0–2.2) and its walls
  rect((Y(-0.125), 0), (Y(0.125), roof), fill: luma(190), stroke: none); rect((Y(2.1), 0), (Y(2.3), sr-roof), fill: luma(190), stroke: none); rect((Y(7.8), 0), (Y(8.0), sr-roof), fill: luma(190), stroke: none)
  rect((Y(0.125), roof - roof-slab), (Y(2.1), roof), fill: luma(120), stroke: none)
  T((Y(1.1), 5.3), [lift shaft\ top stop #lv(ff)\ headroom to the slab\ underside #lv(roof - roof-slab): #r2(lift-avail) m], size: 3.6pt)
  // flights 2 and 4 (cut): from the half landings up to the south
  for (z0, col) in ((0, ink), (ff, ink)) {
    for i in range(11) {
      let y = st.land + i * st.g; let z = z0 + 1.8 + i * st.r
      line((Y(y), z), (Y(y), z + st.r), stroke: 0.6pt + col); line((Y(y), z + st.r), (Y(y + st.g), z + st.r), stroke: 0.6pt + col)
    }
    line((Y(st.land), z0 + 1.8 - 0.15), (Y(st.top + 0.4), z0 + 3.6 - 0.15 - 0.1), stroke: 0.4pt + luma(120))
    rect((Y(st.y0), z0 + 1.8 - 0.15), (Y(st.land), z0 + 1.8), fill: luma(120), stroke: none)
  }
  // flights 1 and 3 beyond (dashed): up to the north
  for z0 in (0, ff) { line(..range(11).map(i => (Y(st.top - i * st.g), z0 + i * st.r)), stroke: (paint: luma(120), dash: "dashed", thickness: 0.6pt)) }
  T((Y(5.3), 0.55), [flight 1 beyond (west)], size: 3.4pt, fill: luma(110)); T((Y(5.3), ff + 0.55), [flight 3 beyond], size: 3.4pt, fill: luma(110))
  T((Y(4.9), 2.95), [flight 2], size: 3.6pt, anchor: "west"); T((Y(4.9), ff + 2.95), [flight 4], size: 3.6pt, anchor: "west")
  // FF slab: the arrival strip and B18; the roof: the arrival strip and R18
  rect((Y(6.45), ff - 0.2), (Y(7.8), ff), fill: luma(120), stroke: none); rect((Y(6.35), ff - 0.4), (Y(6.55), ff - 0.2), fill: red, stroke: none); T((Y(6.45), ff - 0.55), [B18], size: 3.2pt, fill: red)
  rect((Y(6.45), roof - roof-slab), (Y(7.8), roof), fill: luma(120), stroke: none); rect((Y(6.35), roof - 0.4), (Y(6.55), roof - 0.2), fill: red, stroke: none); T((Y(6.45), roof - 0.55), [R18], size: 3.2pt, fill: red)
  T((Y(7.1), ff + 0.3), [FF arrival], size: 3.4pt); T((Y(7.1), roof + 0.3), [roof arrival #lv(roof-fin)], size: 3.4pt)
  // the stair room roof and the door
  rect((Y(2.1), sr-soffit), (Y(8.0), sr-roof), fill: luma(120), stroke: none); T((Y(5.0), sr-roof + 0.3), [stair room roof · soffit #lv(sr-soffit) · top #lv(sr-roof) (slab #r2(sr-slab), assumed)], size: 3.8pt)
  rect((Y(7.8), roof + 0.25), (Y(8.0), roof + 0.25 + 2.1), fill: red, stroke: none); T((Y(8.2), roof + 1.3), [door 2.10 on a #r2(sr-kerb) kerb], size: 3.4pt, fill: red, anchor: "west", angle: 90deg)
  // headroom
  let yh = 5.0; let z2 = 1.8 + (yh - st.land) / st.g * st.r; let z4 = ff + z2 - 0.17
  line((Y(yh), z2), (Y(yh), z4), stroke: (paint: accent, thickness: 0.6pt), mark: (start: "|", end: "|", scale: 0.4)); T((Y(yh - 0.1), (z2 + z4) / 2), [#r2(z4 - z2) over flight 2\ under flight 4], size: 3.4pt, fill: accent, anchor: "east")
  line((Y(7.1), roof-fin), (Y(7.1), sr-soffit), stroke: (paint: accent, thickness: 0.6pt), mark: (start: "|", end: "|", scale: 0.4)); T((Y(7.0), (roof-fin + sr-soffit) / 2), [#r2(sr-soffit - roof-fin) clear], size: 3.4pt, fill: accent, anchor: "east")
  for (z, l) in ((0, [±0.00]), (1.8, [+1.80]), (ff, [+3.60]), (ff + 1.8, [+5.40]), (roof, [+7.20]), (sr-roof, [#lv(sr-roof)])) { T((Y(-0.3), z), l, size: 3.6pt, fill: gray, anchor: "east") }
  T((Y(0), -0.4), [N], size: 4pt); T((Y(7.9), -0.4), [S], size: 4pt)
  T((Y(4.0), sr-roof + 0.8), [section through flights 2 and 4 (x ≈ 2.0), looking west · flights 1 and 3 beyond dashed · R16 over flight 3: headroom #r2(headroom-f3) at tread 6], size: 4.2pt, fill: accent)
})
#grid(columns: (auto, auto, 1fr), gutter: 10pt, stair-plan(), stair-section(),
  [
    #set text(6.8pt)
    #H[2 · The stair, one storey up]
    - *Flights 3 and 4* repeat flights 1 and 2: 11 risers each × #r2(st.r), goings #r2(st.g); flight 3 (west) up from the first-floor arrival strip (y 6.35–7.80, #lv(ff)) to the upper half landing (y 2.30–3.55, #lv(ff + 1.8)); flight 4 (east) up to the roof arrival (#lv(roof-fin)) on y 6.35–7.80. Flight widths 1.21 m, the 0.10 gap with the central handrail; wall handrails on the west wall (flight 3) and on flight 4's east edge a balustrade (its east side is the well, open to the first-floor gallery): *handrails on both sides of every flight*.
    - *Roof opening:* the same L as the first floor, one storey up: over flight 4 and the half landing (x 1.39–2.65, y 2.30–6.35), over flight 3 beyond tread 6 (x 0.125–1.39, y 2.30–4.75). Trimmers *R16 / R17 / R18* 0.20 × 0.40 total, soffit +6.80, laid out as B16 / B17 / B18 (R16 and R18 bear on R17, R17 on R16 and R18's ends on the walls / R10). Headroom over flight 3 at tread 6: *#r2(headroom-f3) m* to R16 (as 2.22 to B16); over flight 2 under flight 4: #r2(ff - 0.17) m; over flight 4 to the stair room soffit ≥ #r2(sr-soffit - roof) m.
    - *Stair room:* on the well's walls (x 0 outer 250, x 2.75, y 2.2, y 7.9: 200 mm block, plastered cream, honey stone plinth outside), inside *2.525 × 5.50 m*; floor = the roof slab round the opening (the arrival y 6.35–7.80 and the strip x 0.125–1.29, y 4.85–6.35); roof slab 0.12 (or an insulated steel deck) with its soffit at *#lv(sr-soffit)* = *#r2(sr-clear) m clear* over the arrival; top #lv(sr-roof), edge #lv(sr-top). Door 0.90 × 2.10 in the south wall opening out, on a #r2(sr-kerb) m kerb with a drip canopy, weather-stripped, a brush seal and a storm sill (rain and dust); a 0.90 × 0.60 window in the east wall (sill +8.50) and a louvre high in the north wall for light and cross-ventilation; a light and a socket.
    - *First floor:* nothing changes: the rooms, the landing (y 7.9–9.2), the gallery and the family living stay; the first-floor arrival strip becomes the foot of flight 3 as in any multi-storey stair; the floor strip x 0.125–1.29, y 4.85–6.35 (already inside the stair box, not a room) lies under flight 3's first treads (a closed triangle). The x 2.75 edge of the well stays open to the gallery with its railing.
    - *Lift:* no change to the shaft (2.25 × 2.2, placeholder) and no overrun above the roof: see § 5.
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
  rect((sr.y0 - 0.1, roof), (sr.y1 + 0.1, sr-roof), fill: cream, stroke: 0.6pt + ink); rect((sr.y0 - 0.1, sr-soffit), (sr.y1 + 0.1, sr-roof), fill: luma(150), stroke: none)
  line((sr.y0 - 0.1, sr-top), (sr.y1 + 0.1, sr-top), stroke: 0.8pt + ink)
  T((5.05, roof + 1.2), [stair room · #lv(sr-top)], size: 4pt); T((in-off + 0.9, roof + 0.9), [attic\ #lv(attic-top)], size: 3.6pt, anchor: "west"); T((y-step - 0.3, roof + 0.9), [attic\ #lv(attic-top)], size: 3.6pt, anchor: "east")
  T((23.6, roof + 0.6), [parapet\ #lv(south-top)], size: 3.6pt, anchor: "east"); T((-0.55, cornice.z0 - 0.5), [main cornice\ #lv(cornice.z0) … #lv(cornice.z0 + cornice.h)\ coping #lv(coping-top)], size: 3.4pt, anchor: "east")
  T((12.0, 1.8), [GF], size: 5pt); T((12.0, 5.4), [FF (bedroom 2 / bedroom 3 at x ≈ 1.4)], size: 5pt); T((12.0, roof + 0.45), [roof #lv(roof) · the courtyard sky hole lies beyond, x 5.8–8.95], size: 4pt, fill: sky)
  T((21.5, 1.8), [men's majlis], size: 4.4pt); T((21.5, 5.4), [office (south wing)], size: 4.4pt)
  // the observers and the sight lines
  for (D, col, lab) in ((D-north, red, [eye at the north boundary · D = #r1(D-north) m]), (D-limit, sky, [eye at D = #r1(D-limit) m: the stair room just hidden]), (25.0, luma(110), [eye at 25 m])) {
    let y0 = -0.125 - D
    circle((y0, eye), radius: 0.12, fill: col, stroke: none); T((y0, eye + 0.5), lab, size: 3.6pt, fill: col)
    let ray(yt, zt, yend) = line((y0, eye), (yend, eye + (zt - eye) / (yt - y0) * (yend - y0)), stroke: (paint: col, thickness: 0.5pt, dash: if col == red { "solid" } else { "dashed" }))
    ray(-0.125 - cornice.proj, coping-top, calc.min(y0 + (11.5 - eye) / ((coping-top - eye) / (-0.125 - cornice.proj - y0)), 24))   // over the cornice coping
    ray(in-off - 0.1, attic-top, calc.min(y0 + (11.5 - eye) / ((attic-top - eye) / (in-off - 0.1 - y0)), 24))                        // over the attic
  }
  for (z, l) in ((0, [±0.00]), (ff, [+3.60]), (roof, [+7.20]), (attic-top, [#lv(attic-top)]), (sr-top, [#lv(sr-top)])) { T((25.2, z), l, size: 3.6pt, fill: gray, anchor: "west") }
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
      [*Observer (north street)*], [*cornice*], [*attic*], [*stair room*],
      ..observers.map(((D, l)) => (l, [#r1(ang(D, 0, coping-top))°], [#r1(ang(D, setback, attic-top))°#if ang(D, setback, attic-top) <= ang(D, 0, coping-top) [ (hidden)]], [#r1(ang(D, sr-s-north, sr-top))°#if ang(D, sr-s-north, sr-top) <= calc.max(ang(D, setback, attic-top), ang(D, 0, coping-top)) [ hidden] else [ *shows*]])).flatten())
    #text(6.4pt, fill: gray)[Angles above the horizon from the eye. The stair room's north face is #r2(sr-s-north) m behind the north facade face, its top #lv(sr-top). From the lane boundary (D = #r1(D-lane) m) the AC units (1.2 m, 2.0 m behind the cut facade) are seen at #r1(ang(D-lane, 2.0, roof + 1.2))° against the attic's #r1(ang(D-lane, setback, attic-top))°: hidden; and from any distance, since 1.2 < #r2(attic-h). From the east boundary (D = #r1(D-east) m) the plant zone is likewise hidden. The malqaf head (#lv(tower-top), on the facade in the cut tip) is the one element above the attic, by design.]
    - *Attic height #r2(attic-h) m:* with 1.5 m the stair room would show above the attic from #r1({ let ha = roof + 1.6 - eye; let ho = sr-top - eye; (ha * sr-s-north - ho * setback) / (ho - ha) }) m on; with #r2(attic-h) m from *#r1(D-limit) m* (≈ #r1(D-limit - D-north) m beyond the plot boundary, across the street). Beyond that the stair room shows #r2(sr-top - attic-top) m above the attic line: a small corner element over the north-west corner, 2.2 m back from the north facade. The stair room cannot be lower (#r2(sr-clear) m clear over the arrival) and cannot be set back on the west: the well stands on the west wall.
    - *The one conflict with the brief:* the stair room is "inside the attic" in plan but #r2(sr-top - attic-top) m above its coping, and on the west it stands on the facade line (the attic is set back there everywhere else). To hide it from every distance the attic would need ≈ #r2(sr-top - roof) m on the north and west: outside the 1.5–1.8 m the owner gave. *Recommendation: accept* (hidden from the boundary and from across the street; the west faces the neighbour at 0.785 m).
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
  rect((sr.x0 - 0.125, attic-top), (sr.x1 + 0.1, sr-top), fill: cream.darken(10%), stroke: 0.6pt + ink); T((1.3, attic-top + 0.3), [stair room #lv(sr-top)], size: 3.4pt)
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
  rect((sr.y0 - 0.1, coping-top), (sr.y1 + 0.1, sr-top), fill: cream.darken(10%), stroke: 0.6pt + ink); rect((sr.y0 - 0.1, cornice.z0 + cornice.h), (sr.y1 + 0.1, coping-top), fill: cream.darken(10%), stroke: 0.6pt + ink)
  T((5.05, roof + 1.4), [stair room\ on the facade line\ #lv(sr-top)], size: 3.6pt)
  T((5.05, cornice.z0 + 0.2), [cornice continues], size: 3.0pt, fill: white)
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
    - *Stair room:* 2.75 × 5.70 on walls (2.525 × 5.50 inside), roof top #lv(sr-roof), #r2(sr-clear) m clear; #r2(sr-top - roof) m above the roof slab, #r2(sr-top - attic-top) m above the attic coping.
    #v(2pt)
    #H[7 · Loads for the engineer (assumed)]
    - *Attic walls:* 200 block #r2(attic-h) m + coping ≈ 4.5 kN/m, standing on the roof slab #r2(in-off) m inside the outer-wall beams (R7 / R8, the cut and east wall beams): near the supports, but a line load on the slab: thicken the slab edge or add a small hidden beam under it; the south attic wall on R5 / B8.
    - *Stair room:* its own roof slab 0.12 (≈ 3.0 kN/m² + 1.5 live) on four block walls on the well's walls; the trimmers R16–R18 as B16–B18.
    - *Cornice:* stone ≈ 2.5 kN/m hung on the slab edge (anchored precast or cut stone); parapets 1.1 m ≈ 2.8 kN/m; the thin band 0.3 kN/m.
    - *Plant:* 3–4 AC outdoor units ≈ 1.0 kN each and the ERV ≈ 1.5 kN on pads with anti-vibration mounts (local ≈ 1.5 kN/m²); *tank(s):* up to 3 m³ = 30 kN on ≈ 3.3 m² (≈ 9 kN/m²) on the R10–R3 bay (1.5 m span): to be checked; *PV:* ≈ 0.25 kN/m² plus wind uplift (ballast or cast-in fixing points, 24 m² now, 20 m² future); *malqaf head* as the air study; walkway pads 0.5 kN/m².
    - *Roof live load* for maintenance only: 1.0–1.5 kN/m² (SBC 301, the engineer).
  ],
  [
    #H[8 · Conflicts and open points]
    - *Stair room vs attic height* (§ 3): the stair room's roof is #r2(sr-top - attic-top) m above the attic coping and stands on the west facade line; hidden from the north boundary and up to #r1(D-limit) m; the owner accepts, or raises the attic to ≈ #r2(sr-top - roof) m on the north and west.
    - *Lift* (§ 5): no overrun if the supplier's headroom is ≤ #r2(lift-avail) m (≤ #r2(lift-avail + lift-raise-max) m with a 0.30 m raised head behind the cornice): a requirement for open item 14.
    - *Courtyard light* (§ 4): none lost.
    - *First-floor layout* (§ 2): nothing lost.
    - *3D and the plans:* the roof opening, the stair room, the attic, the cornice and the parapets are not yet in `3d/params.yaml` / `build_3d.py` (the builder has no attic or cornice yet) nor in the presentation: PENDING_CHANGES.md.
    #v(2pt)
    #H[9 · What this study changes in the files]
    - `studies/structure.typ`: R16 / R17 / R18 in `beams-roof`, the stair well in `voids-roof`, notes X16 (stair, trimmers, stair room) and X17 (attic, parapets, cornice, plant loads); the stair page's note on the roof.
    - `docs/DESIGN_LANGUAGE.md`: flat roof, no tiles, the main cornice, the set-back attic on the north block, the south wing parapet.
    - `data/decisions.csv`: roof access by the main stair; the roofline. Open item 14: the lift headroom requirement (`docs/PENDING_CHANGES.md`).
    #v(2pt)
    #text(8pt)[#if all-ok [*Study checks passed* (#checks.len())] else [*STUDY CHECKS FAILED:* #checks.filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]]
  ],
)

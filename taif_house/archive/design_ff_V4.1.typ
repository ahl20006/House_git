// design_ff.typ · Taif / Palm House · FIRST FLOOR V4.1 (baseline, 17 Oct 2026, on ground floor V4.0) · compile THIS file
// Zoning: master suite east · children west around the shared bath · family living north at the stair top · bedroom 1 at the east duct ·
// men's majlis roof used: bedroom 3 (west), gym (middle) behind a 2.0 m open light strip, the suite terrace (east).
// Same framework as design_gf.typ (same CSV coordinates, shift and rotation). Rooms: data/rooms_ff.csv. Earlier zoning options: data/zones_ff.csv.
// Pages: 1 plan in the site with checks · 2 schedules · 3 furnished plan · 4 rooms, circulation, distances, walls, problems · 5 light-strip check
// Brief: docs/FIRST_FLOOR_BRIEF.md
#import "base.typ": *
#import "@preview/cetz:0.4.2"
#show: setup

// ---------- Same placement as the ground floor ----------
#let shift = (0.91, 3.525)
#let rot = 0deg
#let court-csv = (6.6, 9.75)            // courtyard centre (CSV): the rotation pivot, as on the ground floor
#let pivot = addv(court-csv, 1, shift)
#let rotv(v) = (v.at(0) * calc.cos(rot) - v.at(1) * calc.sin(rot), v.at(0) * calc.sin(rot) + v.at(1) * calc.cos(rot))
#let rotp(p) = addv(pivot, 1, rotv((p.at(0) - pivot.at(0), p.at(1) - pivot.at(1))))
#let place(p) = rotp(addv(p, 1, shift))
#let rect-csv(x0, y0, x1, y1) = ((x0, y0), (x1, y0), (x1, y1), (x0, y1))
#let parse-pts(s) = s.split(";").map(t => t.trim()).filter(t => t != "").map(t => { let v = t.split(" ").filter(u => u != ""); (float(v.at(0)), float(v.at(1))) })

// ---------- Ground-floor outline, voids and fixed elements (CSV) ----------
#let outline-csv = ((0, 0), (10.051, 0), (13.311, 6.0), (13.311, 24.0), (0, 24.0))
#let court-pts = rect-csv(4.25, 6.5, 8.95, 13.0)          // courtyard, open to the sky
#let living-void = rect-csv(4.25, 13.0, 8.95, 19.25)      // double-height living, no floor
#let fixed-csv = (
  ("Stair (arrives at its south end)", rect-csv(0, 2.2, 2.75, 7.9)),
  ("Lift shaft (future, 2 stops)", rect-csv(0, 0, 2.25, 2.2)),
  ("Service shaft (west)", rect-csv(0, 9.2, 1.5, 10.4)),
  ("East duct", rect-csv(12.711, 6.5, 13.311, 7.1)),
)
#let tower-csv = ((8.95, 0), (10.051, 0), (10.594, 1.0), (8.95, 1.0))   // air tower rises to the roof
#let as-row(n, P, colour) = {
  let xs = P.map(p => p.at(0)); let ys = P.map(p => p.at(1))
  (name: n, x: str((calc.min(..xs) + calc.max(..xs)) / 2), y: str((calc.min(..ys) + calc.max(..ys)) / 2),
   w: str(calc.round(calc.max(..xs) - calc.min(..xs), digits: 3)), d: str(calc.round(calc.max(..ys) - calc.min(..ys), digits: 3)),
   angle: "0", frame: "M", colour: colour, pts: P.map(place).map(p => str(p.at(0)) + " " + str(p.at(1))).join(";"))
}
#let fixed = fixed-csv.map(((n, P)) => as-row(n, P, "core"))

// ---------- First-floor rooms (data/rooms_ff.csv) ----------
#let open-kinds = ("terrace", "open")
#let ff-csv = csv("data/rooms_ff.csv", row-type: dictionary).filter(r => r.name != "" and not r.name.starts-with("#")).map(r => (name: r.name, colour: r.colour, P: parse-pts(r.pts)))
#let ff-rooms = ff-csv.filter(r => r.colour not in open-kinds)
#let ff-open = ff-csv.filter(r => r.colour in open-kinds)
#let circ-names = ("Landing (stair top)", "Upper gallery", "Gym route (end of gallery)", "Family link", "Suite lobby")
#let room(n) = ff-csv.find(r => r.name == n)

// ---------- Areas: available, used, circulation, approximate clear ----------
#let available = area(outline-csv) - area(court-pts) - area(living-void) - fixed-csv.map(((n, P)) => area(P)).sum() - area(tower-csv)
#let used-in = ff-rooms.map(r => area(r.P)).sum(default: 0)
#let used-out = ff-open.map(r => area(r.P)).sum(default: 0)
#let circulation = ff-rooms.filter(r => r.name in circ-names).map(r => area(r.P)).sum(default: 0)
#let living-route = 4.7 * 0.9                               // 0.9 m walking route along the family living's courtyard edge (y 5.6–6.5)
#let living-seating = 4.7 * (5.6 - 2.25)                    // seating area of the family living, outside that route
#let outline-edges = range(outline-csv.len()).map(i => (outline-csv.at(i), outline-csv.at(calc.rem(i + 1, outline-csv.len()))))
#let on-seg(p, a, b) = {
  let ax = b.at(0) - a.at(0); let ay = b.at(1) - a.at(1); let L = calc.sqrt(ax * ax + ay * ay)
  let cr = calc.abs((p.at(0) - a.at(0)) * ay - (p.at(1) - a.at(1)) * ax) / L
  let t = ((p.at(0) - a.at(0)) * ax + (p.at(1) - a.at(1)) * ay) / (L * L)
  cr < 0.002 and t > -0.002 and t < 1.002
}
#let wall-t(a, b) = if outline-edges.any(e => on-seg(a, ..e) and on-seg(b, ..e)) { 0.25 } else { 0.2 }
// clear ≈ axis area minus half a wall along every edge (250 mm outer, 200 mm inner; corners ignored, so slightly low)
#let clear-approx(P) = area(P) - range(P.len()).map(i => {
  let a = P.at(i); let b = P.at(calc.rem(i + 1, P.len()))
  calc.sqrt(calc.pow(b.at(0) - a.at(0), 2) + calc.pow(b.at(1) - a.at(1), 2)) * wall-t(a, b) / 2
}).sum()
#let is-rect(P) = P.len() == 4 and calc.abs(P.at(0).at(1) - P.at(1).at(1)) < 1e-6 and calc.abs(P.at(1).at(0) - P.at(2).at(0)) < 1e-6
#let size-of(P) = if is-rect(P) { num(calc.abs(P.at(1).at(0) - P.at(0).at(0))) + " × " + num(calc.abs(P.at(2).at(1) - P.at(1).at(1))) } else { "polygon" }

// ---------- Doors and openings (CSV): (a, b, label) ----------
#let doors = (
  ((2.25, 0.9), (2.25, 1.9), [lift]),
  ((4.25, 0.7), (4.25, 1.6), [office]),
  ((4.25, 2.4), (4.25, 6.4), [living open to gallery]),
  ((1.6, 9.2), (2.4, 9.2), [WC]),
  ((2.75, 14.6), (2.75, 15.5), [bed 2]),
  ((2.75, 15.8), (2.75, 16.6), [bath]),
  ((2.75, 17.8), (2.75, 18.6), [study]),
  ((3.05, 19.5), (3.05, 20.4), [bed 3]),
  ((3.15, 21.25), (4.05, 21.25), [gym]),
  ((9.1, 5.3), (10.0, 5.3), [bed 1]),
  ((11.2, 5.9), (11.2, 6.7), [bath]),
  ((9.0, 6.5), (10.1, 6.5), [suite door]),
  ((10.55, 8.2), (10.55, 9.0), [bath]),
  ((10.55, 11.05), (10.55, 11.8), [dressing]),
  ((9.05, 11.9), (9.95, 11.9), [bedroom]),
  ((10.9, 19.25), (12.3, 19.25), [terrace]),
)
// clerestory: two small windows in the south wall of the double-height living (y 19.25), CSV x
#let clerestory = (((5.3, 19.25), (6.3, 19.25)), ((6.9, 19.25), (7.9, 19.25)))
#let cl-sill = 5.0
#let cl-head = 6.0

// ---------- Furniture and fixtures (thin outlines, not counted): (x0, y0, x1, y1, label), CSV ----------
#let furniture = (
  // master suite
  (10.9, 14.0, 12.7, 16.0, [king bed 1.8 × 2.0]), (10.4, 14.0, 10.9, 14.45, []), (12.7, 14.0, 13.186, 14.45, []),
  (9.05, 17.6, 10.6, 19.1, [sitting]),
  (12.586, 11.1, 13.186, 13.8, [wardrobes]), (11.5, 11.1, 12.5, 11.7, [ward-\ robe]), (10.65, 13.2, 11.85, 13.8, [make-up · mirror]),
  (11.0, 7.8, 12.6, 8.35, [2 basins]), (12.3, 8.5, 13.186, 10.2, [walk-in shower]), (10.65, 9.9, 11.9, 10.9, [WC (own door)]),
  // bedroom 1 + bath
  (9.05, 1.1, 10.45, 3.1, [bed 1.4 × 2]), (9.05, 4.6, 10.05, 5.2, [wardrobe]), (10.25, 6.4, 11.1, 7.0, [desk]),
  (11.3, 6.8, 12.1, 7.6, [shower]), (12.1, 6.9, 12.65, 7.6, [WC]), (11.6, 4.9, 12.3, 5.3, [basin]),
  // bedroom 2
  (1.4, 11.3, 2.6, 13.3, [bed 1.2 × 2]), (0.125, 13.6, 0.725, 15.5, [wardrobe]), (0.125, 10.5, 0.725, 11.7, [desk]),
  // shared bath
  (0.125, 15.7, 0.7, 16.3, [basin]), (0.125, 16.7, 1.0, 17.5, [shower]), (1.3, 16.95, 1.9, 17.5, [WC]),
  // children's study
  (0.125, 17.7, 0.725, 19.15, [desk]),
  // bedroom 3
  (1.6, 21.85, 2.8, 23.85, [bed 1.2 × 2]), (0.125, 19.35, 0.725, 20.95, [wardrobe]), (0.125, 22.6, 0.725, 23.8, [desk]),
  // gym
  (4.3, 21.9, 8.7, 23.8, [gym equipment · mats]),
  // visitors' WC
  (1.95, 10.55, 2.6, 11.1, [WC]), (1.6, 10.2, 2.0, 10.55, [basin]),
  // office
  (6.6, 0.15, 8.0, 0.85, [desk]), (7.0, 1.3, 7.6, 1.9, [visitor]), (4.35, 0.15, 6.2, 0.55, [shelves]),
  // family living
  (5.3, 2.35, 7.9, 2.6, [TV wall]), (5.0, 3.4, 8.2, 5.4, [sofa set]), (4.3, 5.65, 8.9, 6.45, [route 0.9 m]),
  // linen cupboards along the gallery (built-in, against the stair wall)
  (2.8, 2.4, 3.25, 7.6, [linen cupboards]),
)

// ---------- Drain runs (CSV polylines): (points, label) ----------
#let drains = (
  (((2.2, 10.8), (1.5, 10.1)), [visitors' WC: ≈ 1 m to the west shaft]),
  (((1.2, 17.1), (1.2, 16.3)), [shared bath: directly over the GF family WC / serving passage, short drop into the GF west wash block run]),
  (((11.7, 7.2), (12.711, 6.8)), [bedroom 1 bath: ≈ 1 m to the east duct (west face), in the floor build-up]),
  (((11.2, 10.4), (12.5, 10.4), (13.0, 7.1)), [suite bath: ≈ 3 m in a sunken bath floor to the duct (south face), not in the kitchen ceiling (hood zone)]),
)
// gym access route (CSV polyline): stair top → gallery → end of gallery → gym door
#let gym-route = ((1.4, 8.55), (3.5, 8.55), (3.5, 19.25), (3.6, 21.25))

// ---------- PAGE 1–2: plan in the site, with the framework checks ----------
#let gradient = ((1.4, 8.55), (3.5, 3.0), (6.6, 4.0), (11.1, 15.0)).map(place)
#render(
  title: [First floor V4.1 · baseline · zoning and first room layout],
  subtitle: [17 Oct 2026 · First floor V4.1 on ground floor V4.0 · rooms in data/rooms_ff.csv · details to follow · furnished plan, table and light-strip check on the next pages],
  court: court-pts.map(place),
  extras: (("Void · double-height living", living-void.map(place)),) + ff-open.map(r => (r.name, r.P.map(place))),
  rooms: fixed + ff-rooms.map(r => as-row(r.name, r.P, r.colour)),
  air: (("Air tower", tower-csv.map(place)),),
  arrows: ((gradient.at(0), gradient.at(1), [1 public]), (gradient.at(1), gradient.at(2), [2 family]), (gradient.at(2), gradient.at(3), [3 suite])),
  marks: doors.map(((a, b, l)) => ((place(a), place(b)), [])) + clerestory.map(((a, b)) => ((place(a), place(b)), [])),
  limit: outline-csv.map(place),
  note: [*First floor V4.1 (baseline).* The men's majlis roof is used: bedroom 3 (west), the gym (middle) behind a 2.0 m open light strip in front of the double-height living, the suite's private terrace (east). The suite lobby now opens to the bedroom, dressing and bathroom. Bedroom 1 grew round the east duct; the office became a 2.25 m strip. Colours: master suite (beige) · family (yellow) · office and visitors' WC (blue-grey) · gym (blue) · circulation (light) · fixed ground-floor elements (grey) · voids, terrace and light strip (white). Blue marks: doors and the two clerestory windows. Areas: available #num(available) m² · rooms #num(used-in) m² (circulation #num(circulation) m² + #num(living-route) m² route inside the family living) · terrace + light strip #num(used-out) m².],
)

// ---------- PAGE 3: furnished plan ----------
#pagebreak()
#let qq(p) = (p.at(0), -p.at(1))
#let pal(c) = palette.at(c, default: luma(235))
#text(15pt, fill: accent, weight: "bold")[First floor V4.1 · furnished plan]
#h(8pt) #text(8pt, fill: gray)[CSV coordinates (x east, y south) · wall centre lines · furniture as thin outlines · red = doors · blue = clerestory windows · blue dashed = drains · green dotted = gym route · north up]
#v(2pt)
#grid(columns: (auto, 1fr), column-gutter: 14pt,
  cetz.canvas(length: 0.68cm, {
    import cetz.draw: *
    let poly(P, ..args) = line(..P.map(qq), close: true, ..args)
    for (P, l) in ((court-pts, [COURTYARD · open to the sky]), (living-void, [VOID · double-height living])) {
      poly(P, fill: rgb("#eef5f8"), stroke: (paint: luma(160), dash: "dashed"))
      content(qq(centroid(P)), text(6pt, fill: gray, l))
    }
    for r in ff-open {
      poly(r.P, fill: white, stroke: (paint: luma(150), dash: "dotted"))
      content(qq(centroid(r.P)), align(center, text(5.6pt, fill: gray)[#r.name\ #num(area(r.P)) m²]))
    }
    for r in ff-rooms { poly(r.P, fill: pal(r.colour), stroke: 0.6pt + ink) }
    for (n, P) in fixed-csv {
      poly(P, fill: luma(205), stroke: 0.6pt + ink)
      content(qq(centroid(P)), align(center, text(5.5pt)[#n]))
    }
    poly(tower-csv, fill: rgb("#cfe8f0"), stroke: 0.6pt + rgb("#1f7a99"))
    for (x0, y0, x1, y1, l) in furniture {
      rect(qq((x0, y0)), qq((x1, y1)), fill: white.transparentize(30%), stroke: (paint: luma(110), thickness: 0.4pt, dash: "dashed"))
      if l != [] { content(qq(((x0 + x1) / 2, (y0 + y1) / 2)), angle: if (y1 - y0) > (x1 - x0) * 1.3 { 90deg } else { 0deg }, text(4.3pt, fill: luma(90), l)) }
    }
    for r in ff-rooms {
      let c = centroid(r.P)
      let c = if r.name == "Upper gallery" { (3.5, 12.5) } else if r.name == "Bedroom 1" { (9.7, 3.6) } else if r.name == "Suite bedroom" { (11.8, 17.3) } else if r.name == "Bedroom 2" { (1.0, 14.2) } else if r.name == "Bedroom 3" { (1.6, 20.6) } else if r.name == "Family living" { (6.6, 2.95) } else if r.name == "Office" { (5.4, 1.3) } else if r.name == "Suite lobby" { (9.7, 9.6) } else if r.name == "Gym" { (6.0, 21.6) } else if r.name.starts-with("Gym route") { (3.65, 20.6) } else { c }
      content(qq(c), align(center, text(5.4pt)[*#r.name*\ #num(area(r.P)) m²]))
    }
    line(..outline-csv.map(qq), close: true, stroke: 1.8pt + ink)
    for (a, b, l) in doors { line(qq(a), qq(b), stroke: 3pt + warn) }
    for (a, b) in clerestory { line(qq(a), qq(b), stroke: 3pt + rgb("#1f7a99")) }
    for (pts, l) in drains {
      line(..pts.map(qq), stroke: (paint: rgb("#1f7a99"), thickness: 0.9pt, dash: "dashed"), mark: (end: ">", fill: rgb("#1f7a99"), scale: 0.4))
    }
    line(..gym-route.map(qq), stroke: (paint: rgb("#2f8a3f"), thickness: 1.1pt, dash: "dotted"), mark: (end: ">", fill: rgb("#2f8a3f"), scale: 0.5))
    line(qq((0, 25.0)), qq((2, 25.0)), stroke: 1.2pt)
    content(qq((1, 25.4)), text(6pt)[2 m])
  }),
  [
    #set text(7pt)
    #text(10pt, weight: "bold", fill: accent)[Furnished test]
    - *Master suite:* the suite door opens into the lobby, the distributor: the bathroom (2 basins, walk-in shower, WC in its own compartment), the dressing (wardrobes for two, make-up table and full mirror) and the bedroom each open from it. The bedroom door is at the lobby's south end; the king bed (1.8 × 2.0, two bedside tables) stands against the bedroom's north wall, east of the door line, facing south to the terrace and the palms, so it is not seen from the suite door. Sitting corner by the solid west wall (the double-height void is behind it: no window there). Terrace from the bedroom only.
    - *Bedroom 1* (≈ #num(area(room("Bedroom 1").P)) m²) now wraps round the east duct; its bath (≈ #num(area(room("Bedroom 1 bath").P)) m²) sits on the duct's west face, the suite bath on its south face.
    - *Children:* bedroom 2 and bedroom 3 with bed 1.2 × 2.0, wardrobe and desk; door swings clear of the furniture; the shared bath between them; a small children's study opens from the gallery.
    - *Family living:* seating #num(living-seating) m² (sofa set + TV wall) outside a 0.9 m route along the courtyard edge to bedroom 1 and the suite.
    - *Office:* desk + one visitor seat + shelves, door from the gallery near the stair top. *Visitors' WC* from the landing (kept).
    - *Gym:* reached from the end of the upper gallery by a 1.2 m route (green), past no bedroom and not the suite, beside (not across) the light strip.
    #v(2pt)
    #text(10pt, weight: "bold", fill: accent)[Drain runs (blue dashed)]
    #for (pts, l) in drains [- #l\ ]
    No drain over the master bedroom or in the ground-floor kitchen ceiling.
  ],
)

// ---------- PAGE 4: rooms, circulation, distances, walls, problems ----------
#pagebreak()
#text(15pt, fill: accent, weight: "bold")[First floor V4.1 · rooms, circulation, distances, walls, problems]
#v(4pt)
#grid(columns: (1fr, 1.1fr), column-gutter: 16pt, [
  #set text(7.2pt)
  #table(columns: (auto, auto, auto, auto), stroke: none, inset: 2.2pt, fill: (_, y) => if calc.even(y) { rgb("#efece4") },
    [*Room*], [*Axes w × d (m)*], [*Axes m²*], [*≈ clear m²*],
    ..ff-rooms.map(r => ([#r.name], [#size-of(r.P)], [#num(area(r.P))], [#num(clear-approx(r.P))])).flatten(),
    [*Rooms*], [], [*#num(used-in)*], [],
    ..ff-open.map(r => ([#r.name], [#size-of(r.P)], [#num(area(r.P))], [—])).flatten(),
    [*Available first-floor area*], [], [*#num(available)*], [],
    [*Used (rooms + terrace + light strip)*], [], [*#num(used-in + used-out)*], [],
  )
  #text(6.3pt, fill: gray)[Clear ≈ axis area minus half a wall along every edge (250 mm outer, 200 mm inner), corners ignored; open edges (landing, family living to the gallery) are counted as walls.]
  #v(3pt)
  *Family living:* #num(area(room("Family living").P)) m² = seating #num(living-seating) m² + route #num(living-route) m² (0.9 m along the courtyard edge).\
  *Circulation:* landing + gallery + gym route + family link + suite lobby = *#num(circulation) m²*, + #num(living-route) m² route inside the family living = *#num(circulation + living-route) m²*.\
  *Bedroom door → its bathroom door:* bedroom 2 ≈ 1.3 m · bedroom 3 ≈ 4 m (via the gym route and the gallery) · bedroom 1: en-suite, door inside · master: bedroom door → lobby → bath door ≈ 3.5 m.\
  *Men's majlis roof (x 2.75–13.311, y 19.25–24):* bedroom 3 strip x 2.75–3.05 · gym route 2.4 m² · gym #num(area(room("Gym").P)) m² · light strip #num(area(room("Open light strip").P)) m² · terrace #num(area(room("Private terrace (suite only)").P)) m².
], [
  #set text(7.1pt)
  #text(10pt, weight: "bold", fill: accent)[Walls off the ground-floor wall lines (for the engineer)]
  Ground-floor lines: x 0, 2.75, 4.25, 8.95, 13.311 · y 0, 6.5, 13.0, 19.25, 24 (and in the west band y 7.9, 10.4, 12.9, 14.4, 16.1, 17.5). Off those lines:
  - *North band (over the women's majlis):* y 2.25 (office / family living).
  - *West band:* x 1.5 and y 11.2 (visitors' WC), y 15.6 and 17.6 (shared bath).
  - *Over the men's majlis* (on its roof slab, no wall below): x 3.05 (bedroom 3 / gym route), y 21.25 (gym and gym route / light strip), x 8.95 between the gym and the terrace (a parapet / screen).
  - *East band:* the family link (x 10.15), bedroom 1 and its bath (x 11.2, y 4.8, y 7.7, x 12.711), the suite (x 10.15–10.55, y 7.7, 11.0, 11.9, 13.9).
  - *Load and vibration check by the engineer:* the gym and bedroom 3 over the men's majlis (and the walls they need there).
  #v(4pt)
  #text(10pt, weight: "bold", fill: accent)[Problems still open]
  + *Bedroom 3 is 3.05 m wide, not 4.25 m:* the gym can only be reached from the gallery end along the 1.5 m strip of majlis roof west of the light strip; a 1.2 m route takes it. Bedroom 3 is now a normal proportion (3.05 × 4.75 = 14.5 m²). A 4.25 m bedroom 3 would mean reaching the gym through bedroom 3, or across the light strip.
  + *Family seating #num(living-seating) m²* (target ≥ 16): the band over the women's majlis is 6.5 m deep for the office (2.25 m), the seating and the 0.9 m route.
  + *Office ≈ #num(clear-approx(room("Office").P)) m² clear*, a 2.25 m deep strip (desk + one visitor seat fit).
  + *Suite lobby* is ≈ #num(area(room("Suite lobby").P)) m² (a 1.6 m wide distributor 4.2 m long plus the 1.2 m entry: the price of three doors off it and the bent entry); the suite bedroom is ≈ #num(area(room("Suite bedroom").P)) m².
  + *The gym blocks the winter sun on the clerestory* (page 5): fix options are a railing instead of a parapet on the gym roof, or a lower gym roof.
  + *Children's rooms* stay 2.75 m (bedroom 2) and 3.05 m (bedroom 3) wide; furniture fits, beds along the length.
])

// ---------- PAGE 5: light-strip check ----------
#pagebreak()
#text(15pt, fill: accent, weight: "bold")[First floor V4.1 · light-strip check · the double-height living's south windows]
#h(8pt) #text(8pt, fill: gray)[section north → south through the middle band (CSV x ≈ 6.6) · levels to confirm: GF ±0.00 · FF +3.60 · roof +7.20 · parapets 1.10 · a full daylight simulation comes at a later stage]
#v(3pt)
#let tn(deg) = calc.tan(deg * 1deg)
#let w-alt = 90 - 21.4 - 23.44     // winter solstice noon, from the south
#let e-alt = 90 - 21.4             // equinox noon
#let s-alt = 90 - 21.4 + 23.44     // summer solstice noon (> 90: slightly to the NORTH)
#let eye = (16.1, 1.2)             // seated eye in the middle of the double-height living (y, h)
#let ang(p, q) = calc.atan((q.at(1) - p.at(1)) / (q.at(0) - p.at(0))).deg()
#let strip = 2.0
// a window point gets the sun where the ray going up and south from it clears the top of the gym's north wall at y 19.25 + strip
#let sun-share(top, deg) = calc.clamp((cl-head - (top - strip * tn(deg))) / (cl-head - cl-sill), 0, 1)
#let sky-share(top) = {
  let a-sill = ang(eye, (19.25, cl-sill)); let a-head = ang(eye, (19.25, cl-head)); let a-obs = ang(eye, (19.25 + strip, top))
  calc.clamp((a-head - calc.max(a-sill, a-obs)) / (a-head - a-sill), 0, 1)
}
#let cases = (
  (label: [gym with a 1.10 m parapet (top +8.30)], top: 8.3),
  (label: [gym with a railing only (solid top +7.20)], top: 7.2),
  (label: [no gym: full roof open (parapet +4.70 at y 24)], top: none),
)
#cetz.canvas(length: 0.6cm, {
  import cetz.draw: *
  let S(y, h) = (y, h)
  line(S(-1.5, 0), S(30, 0), stroke: 1pt + ink)
  rect(S(0, 0), S(6.5, 3.6), fill: rgb("#f6e3c0"), stroke: 0.6pt + ink)
  content(S(3.25, 1.8), text(6pt)[Women's majlis (GF)])
  rect(S(0, 3.6), S(6.5, 7.2), fill: rgb("#fbf2e2"), stroke: 0.6pt + ink)
  content(S(3.25, 5.4), text(6pt)[Office / family living (FF)])
  line(S(0, 7.2), S(0, 8.3), stroke: 0.6pt + ink); line(S(6.5, 7.2), S(6.5, 8.3), stroke: 0.6pt + ink)
  content(S(9.75, 1.5), text(6pt, fill: rgb("#2f5f8a"))[COURTYARD · open to the sky])
  rect(S(13, 0), S(19.25, 7.2), fill: rgb("#fbf2e2"), stroke: 0.6pt + ink)
  line(S(13, 0.9), S(13, 6.6), stroke: 3pt + rgb("#7fb8d0"))
  content(S(13.3, 0.6), anchor: "west", text(5.3pt, fill: rgb("#2f5f8a"))[main light: courtyard glazing])
  content(S(16.1, 4.4), text(6pt)[Living (double height)])
  line(S(13, 7.2), S(13, 8.3), stroke: 0.6pt + ink); line(S(19.25, 7.2), S(19.25, 8.3), stroke: 0.6pt + ink)
  line(S(19.25, cl-sill), S(19.25, cl-head), stroke: 3pt + rgb("#1f7a99"))
  content(S(19.1, 6.6), anchor: "east", text(5.3pt, fill: rgb("#1f7a99"))[2 windows 1.0 × 1.0 · sill +5.00 · head +6.00])
  rect(S(19.25, 0), S(24, 3.6), fill: rgb("#e9d9c4"), stroke: 0.6pt + ink)
  content(S(21.6, 1.8), text(6pt)[Men's majlis (GF)])
  line(S(19.25, 3.6), S(21.25, 3.6), stroke: 2pt + rgb("#e0c060"))
  content(S(20.25, 3.95), text(5pt)[light strip 2.0 m])
  rect(S(21.25, 3.6), S(24, 7.2), fill: rgb("#cfe3f3"), stroke: 0.6pt + ink)
  content(S(22.6, 5.4), text(6pt)[Gym (FF)])
  line(S(21.25, 7.2), S(21.25, 8.3), stroke: (paint: warn, thickness: 0.8pt)); line(S(24, 7.2), S(24, 8.3), stroke: (paint: warn, thickness: 0.8pt))
  content(S(22.6, 8.6), text(5pt, fill: warn)[parapet +8.30 (or railing)])
  circle(S(..eye), radius: 0.12, fill: ink)
  content(S(eye.at(0), eye.at(1) - 0.4), text(5pt)[eye +1.20])
  for h in (cl-sill, cl-head) { line(S(..eye), S(eye.at(0) + (19.25 - eye.at(0)) * 2.0, eye.at(1) + (h - eye.at(1)) * 2.0), stroke: (paint: luma(150), thickness: 0.5pt, dash: "dotted")) }
  let ray(y0, h0, deg, len, col, dash) = line(S(y0, h0), S(y0 + len * calc.cos(deg * 1deg), h0 + len * calc.sin(deg * 1deg)), stroke: (paint: col, thickness: 0.9pt, dash: dash))
  ray(19.25, cl-sill, w-alt, 6, rgb("#d08a00"), "solid"); ray(19.25, cl-head, w-alt, 6, rgb("#d08a00"), "solid")
  content(S(25.6, 11.0), text(6pt, fill: rgb("#d08a00"))[winter noon #calc.round(w-alt, digits: 1)°])
  ray(19.25, cl-sill, e-alt, 6, rgb("#c25b00"), "dashed")
  content(S(20.6, 11.4), text(6pt, fill: rgb("#c25b00"))[equinox #calc.round(e-alt, digits: 1)°])
  line(S(9.75, 0.2), S(9.45, 9.5), stroke: (paint: rgb("#e0b000"), thickness: 0.9pt))
  content(S(9.5, 9.9), text(6pt, fill: rgb("#b08a00"))[summer noon: almost overhead (#calc.round(180 - s-alt, digits: 1)° from the north)])
  for (h, l) in ((0, [±0.00 GF]), (3.6, [+3.60 FF]), (7.2, [+7.20 roof])) {
    line(S(-1.2, h), S(-0.2, h), stroke: 0.5pt + gray)
    content(S(-1.3, h), anchor: "east", text(5.5pt, fill: gray, l))
  }
  content(S(0, -0.6), anchor: "north-west", text(6pt)[N])
  content(S(24, -0.6), anchor: "north-east", text(6pt)[S])
})
#v(2pt)
#set text(7.5pt)
#grid(columns: (1.15fr, 1fr), column-gutter: 16pt, [
  #table(columns: (auto, auto, auto, auto), stroke: none, inset: 3pt, fill: (_, y) => if calc.even(y) { rgb("#efece4") },
    [*Behind the 2.0 m light strip*], [*Winter noon sun on the windows*], [*Equinox noon sun*], [*Sky seen through the windows from the eye*],
    ..cases.map(c => if c.top == none { ([#c.label], [100 %], [100 %], [100 %]) } else {
      ([#c.label], [#calc.round(sun-share(c.top, w-alt) * 100) %], [#calc.round(sun-share(c.top, e-alt) * 100) %], [#calc.round(sky-share(c.top) * 100) %])
    }).flatten(),
  )
  #text(6.3pt, fill: gray)[*How the percentages are defined.* "Sun on the windows": the share of the window height (sill +5.00 to head +6.00) that receives direct sun at solar noon on 21 Dec (winter) or 21 Mar / 23 Sep (equinox), measured in this section through the windows; the ray from each point of the window must pass over the top of the gym's north wall 2.0 m away. "Sky seen": from a seated eye 1.20 m high in the middle of the double-height living floor (CSV y 16.1), the share of the vertical angle under which the windows are seen that shows sky rather than the gym. Pure geometry: no reflections, no sky model. A daylight simulation comes later.]
], [
  - *The main light of the double-height living comes from the courtyard* (its north glazing, on the courtyard side). The south windows are small: two of 1.0 × 1.0 m (sill +5.00, head +6.00), for extra light and cross ventilation (warm air out high on the south).
  - *With the gym and a 1.10 m parapet,* the 2.0 m strip still gives sky light and the equinox sun, but no winter noon sun on the windows.
  - *With a railing on the gym roof* (no solid parapet), most of the window gets the winter sun again.
  - *Summer:* the sun is almost overhead; the windows get sky light and light reflected from the strip, so give the strip and the gym's north wall a light colour; a small hood (≈ 0.4 m) over each window.
  - *Proposal:* the 2.0 m strip, two small windows, and a railing (not a parapet) on the north edge of the gym roof. Confirm with a daylight simulation later.
])

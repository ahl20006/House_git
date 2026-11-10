// courtyard_haven.typ · Taif / Palm House V10.0 · THE COURTYARD AS THE FAMILY'S HAVEN · a study in phases (the owner's brief of 10 Nov 2026) · STUDY ONLY:
// nothing in the design files changes until the owner chooses an option after Phase 4. PHASE 0: the facts, cited file by file, every assumption marked. PHASE 1: the 22 checks + the owner's two notes (the doors, the deep well). PHASE 2: the mistakes ranked; the olive in a fixed pot. PHASE 3: three layouts within the open items and the ideas for the owner. PHASE 4: H2 chosen and scored; the suite court the winter room; the Arabic summary.
// LOCKED: the site and the outline, the structure (except the courtyard's own openings), the stair and the lift, every settled room, the malqaf L5 (position, core, shaft, head).
// OPEN: the seating, the water and the tree, the outlet (height, direction, louvres: A as built or B), the sink window, the courtyard doors and windows, the arch infill,
// the lighting, the floor pattern, the planting, the drainage. Bigger ideas go to a separate "ideas for the owner" list (Phase 3).
// CSV frame: x east, y south, wall centre lines; levels above the finished ground floor ±0.00. Local time UTC+3; Taif ≈ 21.3° N, 40.4° E, 1 700 m.
#import "@preview/cetz:0.4.2"
#import "air_system.typ": air-core, air-shaft, air-head, air-head-z, air-outlet, air-door, air-trap, air-fan, air-cooler, air-damper-top, louvre-free, outlet-free, mean-eve, gentle, still, v-out
#set page(paper: "a4", flipped: true, margin: 9mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 7.2pt)
#set par(leading: 0.42em)
#let green = rgb("#2f6b4f"); #let ink = rgb("#26302b"); #let gray = rgb("#6d736f"); #let red = rgb("#b5452f"); #let amber = rgb("#b07a1f"); #let blue = rgb("#1f7a99"); #let water = rgb("#bcd9ea"); #let leaf = rgb("#7fa25a")
#let H(t) = block(above: 5pt, below: 3pt, text(9pt, weight: "bold", fill: green, t))
#let A(t) = text(fill: amber, weight: "bold", t)   // an ASSUMPTION
#let r1(v) = str(calc.round(v, digits: 1)); #let r2(v) = str(calc.round(v, digits: 2))
#let f2(v) = { let s = str(calc.round(calc.abs(v), digits: 2)); if v < 0 { "−" + s } else { "+" + s } }
#let q(p) = (p.at(0), -p.at(1))
#let area(P) = calc.abs(range(P.len()).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, P.len())); a.at(0) * b.at(1) - b.at(0) * a.at(1) }).sum()) / 2

// ====================================================================== DATA (every item cited; the file and line in the table on page 1)
#let C = yaml("../3d/character.yaml").courtyard_layout
#let court-axes = ((4.25, 8.667), (5.8, 8.667), (5.8, 6.5), (8.95, 6.5), (8.95, 13.0), (4.25, 13.0))   // data/rooms_gf.csv line 2 (V10.0: the L round the malqaf core)
#let cx0 = 4.35; #let cx1 = 8.85; #let cy0 = 6.6; #let cy1 = 12.9           // the finished faces: the riwaq glass, the kitchen wall, the majlis glass, the living glass
#let col-x = 5.8; #let edge = 5.925                                          // the colonnade line (C21–C23, the edge beam) and the soffit edge
#let core-face = 5.95                                                        // the malqaf core's courtyard face (10 Nov 2026: its east wall 0.30 on the column line)
#let core = (4.3, 6.4, core-face, 8.767)                                     // the core's outer faces
#let sky = (5.8, 6.5, 8.95, 13.0)                                            // the sky opening on axes (3.15 × 6.5) between the edge beam and the kitchen wall
#let pj-soffit = 3.27; #let gf-glass-head = 2.9; #let ff-floor = 3.6; #let roof = 7.3; #let guard = 1.1   // the arcade soffit, the GF glass heads, the levels
#let clear-area = (cx1 - cx0) * (cy1 - cy0) - (core-face - cx0) * (core.at(3) - cy0)   // the L-shape between the finished faces
#let zone = C.seating_zone; #let enc = C.enclosure.box; #let pb = C.enclosure.planter.inside; #let wb = C.enclosure.water.inside
#let tree = C.enclosure.tree; #let crown-c = ((pb.at(0) + pb.at(2)) / 2, (pb.at(1) + pb.at(3)) / 2)
#let zone-free = (zone.at(2) - zone.at(0)) * (zone.at(3) - zone.at(1)) - (enc.at(2) - enc.at(0)) * (enc.at(3) - enc.at(1))
#let sink = C.sink_window
#let D = C.drainage
// the seating of 10 Nov 2026 (studies/courtyard_layout.typ lines 46–52): x0 y0 x1 y1 kind faces
#let furn = ((7.4, 9.8, 8.25, 11.3, "sofa A · 2", "W"), (6.85, 11.45, 8.25, 12.3, "sofa B · 2", "N"), (6.0, 9.6, 6.75, 10.35, "armchair 1", "E"), (6.0, 11.0, 6.75, 11.75, "armchair 2", "E"), (6.6, 10.4, 7.3, 10.9, "table", ""))
// the openings onto the courtyard (presentation.typ gf-doors / gf-windows, 3d/params.yaml, studies/ff_family.typ)
#let openings = (
  ([women's majlis glass (north, y 6.5)], [x 6.0–8.1, floor to +2.9, fixed (no door)], [presentation.typ 194 · params.yaml 47]),
  ([riwaq glass door (west, x 4.25)], [y 9.1–10.5, sliding 1.40: the only door into the courtyard], [presentation.typ 173]),
  ([riwaq glass (west, x 4.25)], [y 10.7–12.7, floor to +2.9, fixed], [params.yaml 50]),
  ([riwaq's first panel (x 4.25, y 6.8–8.9)], [the malqaf core's solid rendered face with a built-in bench (no glass since V10.0)], [design_gf.typ 100 · PROJECT_V10 §4.63]),
  ([living glass (south, y 13.0)], [x 4.45–5.55 and 6.05–8.75, floor to the slab (+3.32), fixed (no door); W3 above it to the crown +6.60], [params.yaml 48–49, 78]),
  ([kitchen sink window (east, x 8.95)], [y 7.3–8.9, sill +1.10, head +2.10; the enclosure in front of it], [design_gf.typ 127 · character.yaml 144]),
  ([malqaf outlet (west, the core's east face x 5.95)], [y 7.1–8.5, +0.10…+1.10, timber louvres (free 60 %), the damper D2 behind], [air_system.typ 30, 50, 203]),
  ([malqaf door (the core's south face, y 8.767)], [x 4.6–5.6, 1.0 × 2.4, carved timber, onto the covered strip (not the courtyard)], [design_gf.typ 100 · air_system.typ 31]),
  ([gallery windows above (west, x 5.8)], [W1-2 y 8.95–10.55 and W1-3 y 11.117–12.717 (1.60 wide, sill +3.82, springing +5.80, crown +6.60); W1-1 (y 6.783–8.383) a blind arch], [params.yaml 71–72 · ff_family.typ 124]),
  ([family living windows above (north, y 6.5)], [W2 × 2: x 6.0–7.3 and 7.55–8.85, floor +3.60 to the crown +6.60], [params.yaml 76 · ff_family.typ 125]),
  ([living's upper side (south, y 13.0)], [W3: x 6.0–8.8 from +3.32 to the crown +6.60 over the living glass], [params.yaml 78]),
  ([kitchen wall above (east, x 8.95)], [the suite lobby's wall, no window to the courtyard (the suite lobby F15 is blind to the court)], [rooms_ff.csv, params.yaml windows]),
)
#let facts = (
  ([Courtyard on axes], [an L: x 4.25–8.95 × y 6.5–13.0 less the malqaf core (x 4.4–5.8, y 6.5–8.667): *27.19 m²*], [data/rooms_gf.csv 2]),
  ([Courtyard clear (finished faces)], [4.50 × 6.30 = 28.35 m² less the core's footprint (1.6 × 2.17 = 3.47): *≈ #r2(clear-area) m²*; the colonnade under the projection 1.575 wide (x 4.35–5.925), the open sky 3.15 × 6.5 on axes], [courtyard_layout.typ 30–38 · sections.typ pj (depth 1.55, sky 3.15)]),
  ([Walls round it], [north: the women's majlis glass (+2.9 head) under the family living's W2; south: the living glass to +3.32 under W3; east: the kitchen wall two storeys to the roof (+7.3) and the 1.10 guard; west: the projection's soffit +3.27 on the colonnade, the gallery's W1 above (crown +6.60), the roof +7.3], [params.yaml 11, 130 · structure.typ (soffit +3.27)]),
  ([Malqaf chamber], [the core x 4.4–5.8 × y 6.5–8.667 on axes (faces x 4.3–#r2(core-face), y 6.4–8.767; the east wall 0.30 on the column line since 10 Nov 2026); inside: the dust trap, the filter cabinet + EC fan + silencer, the cooler's space; the door 1.0 × 2.4 south onto the covered strip], [air_system.typ 25, 31–34 · design_gf.typ 80, 138]),
  ([Outlet A (as built)], [1.4 × 1.0 on the east face, y #r2(air-outlet.at(1))–#r2(air-outlet.at(2)), #f2(air-outlet.at(3))…#f2(air-outlet.at(4)), adjustable timber louvres aimed south-east (the air study: "the louvres aim the jet along the seating"); free area #r2(outlet-free) m²; ≈ #r2(mean-eve.q) m³/s and #r1(v-out(mean-eve.q)) m/s at the louvres at the summer-evening mean wind, #r2(gentle.q) m³/s in a gentle wind, #r2(still.q) m³/s in calm (stack)], [air_system.typ 30, 50–51, 67, 228]),
  ([Outlet B (studied, not adopted)], [the same 1.4 × 1.0, raised to +0.60…+1.60, centred in the bay y 6.9–8.3, the louvres fixed 30° south-east with splayed reveals: over the trough's rim and under the crown], [malqaf_outlet_B.typ 36]),
  ([Malqaf head], [1.6 × 2.4 on the roof, x 4.3–5.9 / y 6.4–8.8, openings +11.2…+12.6 on all four faces (3 / 5 slots), the crown +13.2; the W and N faces the catchers; D1 at the shaft's head +7.75, D2 behind the outlet, spring-return, one switch], [air_system.typ 27–28, 36, 203]),
  ([Water + tree enclosure], [one box on the kitchen wall x 7.55–8.85 × y 7.1–9.5 (walls 0.15): the planter 1.0 × 1.05 inside, 0.70 deep, rim +0.45 (north, in front of the sink window); the raised trough 1.0 × 0.6 inside, 0.35 deep, rim +0.95, water +0.85, a laminar lip at +1.05 (south); the pump chamber in the divider; both basins tanked, each to the rain system], [character.yaml 145–152 · courtyard_layout.typ §3]),
  ([The tree], [#A[ASSUMED]: *Laurus nobilis* standard or clipped *Ficus nitida*, "a Taif nursery decides"; drawn stem 2.0, crown centre +3.0, radius 0.9 (bottom +2.1, top +3.9); drip irrigation; no root barrier noted], [character.yaml 152]),
  ([Seating (10 Nov 2026)], [the level zone x 5.925–8.85 × y 7.1–12.3 (#r2(zone-free) m² free of the enclosure): sofa A 1.5 × 0.85 facing W, sofa B 1.4 × 0.85 facing N, two armchairs 0.75 at the colonnade edge facing E, a 0.7 × 0.5 table; 6 seats, every seat with a back; no TV], [courtyard_layout.typ 46–52 · design_gf.typ 79]),
  ([Colonnade and arches], [the edge beam on x 5.8 (C21 at y 6.5, C22 at 13.0; the first arcade column at 8.667 absorbed in the core, the second at 10.833, Ø0.25 rendered); three semicircular arch plates under the soffit +3.27, springing ≥ +2.31; the bays 2.167 on axes; the first bay filled by the core (the outlet in it)], [character.yaml 79–81 · structure.typ X18 · design_gf.typ 74–80]),
  ([Projection and gallery], [the first-floor projection 1.55 m over the colonnade (B3 / B4 on 4.33 + 6.25 m spans); the gallery behind W1 (sill +3.82), the family living behind W2, the living's upper side W3; the sky opening 3.15 wide between the edge beam and the kitchen wall], [sections.typ 38–53 · structure.typ 73–74]),
  ([Drains], [the floor −0.015 at the three glass lines and the riwaq door, 1 % falls to −0.06 at the kitchen wall foot; two slot drains (along the kitchen wall foot y 9.6–12.8; at the riwaq door y 9.0–10.6), silt baskets, trap primers; the overflow gully at (8.6, 12.6) rim −0.03; the invert −0.55, 1 % east under the kitchen to the rain chamber (never foul)], [character.yaml 153–162 · plumbing.typ 79, 328]),
  ([Lighting], [two hanging lanterns under the soffit edge between the columns (at y 9.75 and 16.125, 0.6 m drops); the warm room lights seen through the glass (the night view); nothing else designed], [character.yaml 170–173, 202–205]),
  ([Power and water points], [the pump in the enclosure's divider (its circuit not drawn); the TV's power / data removed (10 Nov 2026); no sockets or lighting circuit for the courtyard designed yet; the malqaf chamber: IP44 sockets, a capped water point, the gully], [courtyard_layout.typ 187 · air_system.typ § 2]),
  ([Floor], [outdoor anti-slip porcelain (R11) in a sand / honey tone, no pattern designed; level, no step; the thresholds 15 mm at the glass], [DESIGN_LANGUAGE.md · character.yaml 153]),
  ([Wind], [#A[ASSUMED from the public station]: the warm-season evening wind W ≈ 50 %, NW ≈ 30 %, mean ≈ 21 km/h at 10 m; the house's own wake and the old house west of it estimated, the on-site station still to confirm], [malqaf_L5.typ 23–30, 147]),
  ([Heat and the seating hours], [#A[ASSUMED]: the seating hours 16–23: pleasant and dust-free ≈ 1 800 h / year; > 32 °C in 14–36 % of the hours May–Sep; dust ≈ 60 days / year], [malqaf_L5.typ 44–48]),
  ([Sun], [#A[ASSUMED]: Taif 21.3° N; solar noon ≈ 12:25 local; the sun's altitude at the summer solstice noon 92° − 21.3° ≈ 89° (overhead), at the winter solstice ≈ 45°; Phase 1 computes the shadows], [geometry]),
)

// ====================================================================== PAGE 1 · the facts
#text(14pt, weight: "bold", fill: green)[The courtyard as the family's haven · a study in phases · Phase 0: the facts · Taif / Palm House V10.0]
#v(1pt)
#text(7.4pt, fill: gray)[The owner's brief (10 Nov 2026): breeze, water, tree, shade, winter sun, views, privacy, calm, beauty, easy upkeep, all working together; find every mistake. *Locked:* the site and the outline, the structure, the stair and the lift, the settled rooms, the malqaf L5. *Open:* the seating, the water and the tree, the outlet (A or B), the sink window, the courtyard's doors and windows, the arch infill, the lighting, the floor, the planting, the drainage. *Owner's preferences:* no TV; every seat with a back, 5–6 seats; open to the sky; level floor, movable furniture; render and paint, porcelain floors; simple switches; privacy only from the guest route and the majlis side. #A[Amber = an assumption.] Phase 0 cites the files; Phase 1 checks them.]
#v(3pt)
#grid(columns: (1fr, 1fr), column-gutter: 10pt,
  [
    #H[The courtyard as designed (V10.0 + the owner's review of 10 Nov 2026)]
    #table(columns: (auto, 1fr, auto), inset: 2.1pt, stroke: 0.4pt + luma(178), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      [*Item*], [*Fact*], [*Where*],
      ..facts.slice(0, 9).map(((a, b, c)) => ([#a], [#b], [#text(6.3pt, fill: gray, c)])).flatten())
  ],
  [
    #table(columns: (auto, 1fr, auto), inset: 2.1pt, stroke: 0.4pt + luma(178), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      [*Item*], [*Fact*], [*Where*],
      ..facts.slice(9).map(((a, b, c)) => ([#a], [#b], [#text(6.3pt, fill: gray, c)])).flatten())
    #v(3pt)
    #H[Every opening onto the courtyard]
    #table(columns: (auto, 1fr, auto), inset: 2.1pt, stroke: 0.4pt + luma(178), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      [*Opening*], [*What*], [*Where*],
      ..openings.map(((a, b, c)) => ([#a], [#b], [#text(6.3pt, fill: gray, c)])).flatten())
  ],
)

// ====================================================================== PAGE 2 · the plan and the section as designed
#pagebreak()
#text(12pt, weight: "bold", fill: green)[Phase 0 · the courtyard as designed: plan (clear faces) and the east–west section through the seating · the summary]
#v(3pt)
#let plan(length: 1.25cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, t, size: 3.6pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, t))
  let R(b, fill: none, stroke: none) = rect(q((b.at(0), b.at(1))), q((b.at(2), b.at(3))), fill: fill, stroke: stroke)
  R((cx0 - 0.3, cy0 - 0.3, cx1 + 0.3, cy1 + 0.3), fill: luma(205))
  R((cx0, cy0, cx1, cy1), fill: rgb("#e4d6b8"))
  R((cx0, cy0, edge, cy1), fill: rgb("#ece4cf")); line(q((edge, cy0)), q((edge, cy1)), stroke: (paint: ink, thickness: 0.6pt, dash: "dashed")); T((5.1, 11.0), [colonnade walkway\ 1.575 under the projection], size: 3.3pt, angle: 90deg)
  R(core, fill: luma(60)); T((5.1, 7.6), [malqaf\ core], size: 3.6pt, fill: white)
  for y in (6.5, 13.0) { circle(q((col-x, y)), radius: 0.2, fill: luma(60), stroke: none) }
  circle(q((col-x, 10.8333)), radius: 0.125, fill: luma(120), stroke: 0.3pt + ink); T((col-x + 0.2, 10.8333), [arcade column], size: 3pt, anchor: "west")
  line(q((core-face, air-outlet.at(1))), q((core-face, air-outlet.at(2))), stroke: 3.5pt + rgb("#9c6b3c")); T((core-face + 0.12, 7.8), [outlet 1.4 × 1.0 · +0.10…+1.10 · louvres → SE], size: 3.1pt, fill: rgb("#9c6b3c"), anchor: "west", angle: 90deg)
  R(enc, fill: rgb("#c9a86a"), stroke: 0.4pt + ink); R(pb, fill: rgb("#8d7a58")); R(wb, fill: water, stroke: 0.3pt + ink)
  circle(q(crown-c), radius: tree.crown_radius, fill: leaf.transparentize(55%), stroke: (paint: leaf.darken(20%), dash: "dashed", thickness: 0.5pt))
  T(((wb.at(0) + wb.at(2)) / 2, (wb.at(1) + wb.at(3)) / 2), [trough · rim +0.95], size: 3pt); T(crown-c, [tree · crown\ +2.1…+3.9], size: 3pt, fill: white)
  line(q((cx1, sink.y.at(0))), q((cx1, sink.y.at(1))), stroke: 3pt + blue); T((cx1 + 0.15, 8.1), [sink window · sill +1.10], size: 3pt, fill: blue, anchor: "west", angle: 90deg)
  R(zone, stroke: (paint: amber, thickness: 0.5pt, dash: "dashed")); T((6.0, 12.2), [seating zone · level], size: 3pt, fill: amber, anchor: "west")
  for f in furn { R((f.at(0), f.at(1), f.at(2), f.at(3)), fill: if f.at(4) == "table" { rgb("#fbf4e6") } else { rgb("#b48a5a") }, stroke: 0.4pt + ink); T(((f.at(0) + f.at(2)) / 2, (f.at(1) + f.at(3)) / 2), [#f.at(4)#if f.at(5) != "" [ · faces #f.at(5)]], size: 2.9pt, fill: if f.at(4) == "table" { ink } else { white }) }
  line(q((cx0, 9.1)), q((cx0, 10.5)), stroke: 3pt + red); T((cx0 - 0.12, 9.8), [riwaq door · sliding 1.40\ (the only door)], size: 3pt, fill: red, anchor: "east", angle: 90deg)
  line(q((cx0, 10.7)), q((cx0, 12.7)), stroke: 2pt + blue); line(q((6.0, cy0)), q((8.1, cy0)), stroke: 2pt + blue); T((7.05, cy0 - 0.2), [women's majlis glass · fixed · head +2.9], size: 3pt, fill: blue)
  line(q((4.45, cy1)), q((5.55, cy1)), stroke: 2pt + blue); line(q((6.05, cy1)), q((8.75, cy1)), stroke: 2pt + blue); T((6.6, cy1 + 0.2), [living glass · fixed · to +3.32 · W3 above], size: 3pt, fill: blue)
  for d in D.linear_drains { R(d, fill: rgb("#8a9aa8")) }; circle(q(D.overflow_at), radius: 0.08, fill: white, stroke: 0.6pt + red)
  for p in C.at("lanterns", default: ()) { }
  circle(q((5.6, 9.75)), radius: 0.12, fill: amber, stroke: none); T((5.6, 9.45), [lantern], size: 2.8pt, fill: amber)
  T(((cx0 + cx1) / 2, cy0 - 0.75), [the courtyard as designed · 1 m = 1.25 cm · N up], size: 4.2pt, fill: green)
})
#let section(length: 1.05cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, t, size: 3.6pt, fill: ink, anchor: "center", angle: 0deg) = content(p, anchor: anchor, angle: angle, text(size, fill: fill, t))
  // x along the section (east is right), z up · the section at y ≈ 10.5 (through sofa A and the second arcade bay)
  let X(x) = x - 4.25
  rect((X(3.0), -0.5), (X(10.5), 8.6), fill: rgb("#f3ece0"), stroke: none)
  rect((X(3.0), -0.5), (X(10.5), 0), fill: luma(120)); line((X(3.0), 0), (X(10.5), 0), stroke: 0.6pt + ink)
  // the riwaq (left) with its glass, the projection over the colonnade, the gallery W1, the roof
  rect((X(3.0), 0), (X(4.25), ff-floor), fill: rgb("#f2efe8"), stroke: 0.4pt + luma(150)); T((X(3.6), 1.6), [riwaq], size: 3.4pt)
  rect((X(4.2), 0), (X(4.3), gf-glass-head), fill: blue, stroke: none); T((X(4.25), gf-glass-head + 0.2), [riwaq glass +2.9], size: 3pt, fill: blue)
  rect((X(4.25), pj-soffit), (X(5.925), ff-floor), fill: luma(170), stroke: 0.4pt + ink); T((X(5.1), (pj-soffit + ff-floor) / 2), [projection · soffit +3.27], size: 3pt)
  rect((X(5.925) - 0.25, 0), (X(5.925), pj-soffit), fill: luma(120), stroke: none); T((X(5.925) - 0.125, 1.5), [arcade column · arch above], size: 2.9pt, fill: white, angle: 90deg)
  rect((X(4.25), ff-floor), (X(5.8), roof), fill: rgb("#f2efe8"), stroke: 0.4pt + luma(150)); T((X(5.0), 5.5), [gallery], size: 3.4pt)
  rect((X(5.8) - 0.1, ff-floor + 0.22), (X(5.8), 6.6), fill: blue, stroke: none); T((X(5.8) - 0.3, 5.2), [W1 · sill +3.82 · crown +6.60], size: 3pt, fill: blue, angle: 90deg)
  rect((X(4.25), roof), (X(5.8), roof + 0.3), fill: luma(120), stroke: none); rect((X(5.8), roof), (X(5.8) + 0.05, roof + guard), fill: none, stroke: 0.8pt + ink); T((X(5.5), roof + 1.4), [roof +7.3 · guard 1.10], size: 3pt)
  // the sky
  T((X(7.4), 7.9), [open sky · 3.15 m wide between the edge beam and the kitchen wall], size: 3.4pt, fill: blue)
  // the kitchen wall (right) two storeys, the sink window (y 7.3–8.9 is north of this section: shown dashed)
  rect((X(8.85), 0), (X(9.05), roof + 0.3), fill: luma(60), stroke: none); T((X(8.95), 5.0), [kitchen wall · the suite lobby above · no window], size: 3pt, fill: white, angle: 90deg)
  rect((X(8.85) - 0.02, sink.sill), (X(8.85), sink.head), fill: none, stroke: (paint: blue, thickness: 0.6pt, dash: "dashed")); T((X(8.6), sink.head + 0.2), [sink window (north of the section)], size: 2.8pt, fill: blue, anchor: "east")
  // the enclosure (north of the section: dashed), the tree
  rect((X(7.55), 0), (X(8.85), wb.at(0) * 0 + 0.95), fill: none, stroke: (paint: ink, thickness: 0.4pt, dash: "dashed")); T((X(8.2), 1.1), [enclosure beyond · trough rim +0.95], size: 2.8pt)
  circle((X(8.2), tree.crown_centre), radius: tree.crown_radius, fill: leaf.transparentize(55%), stroke: (paint: leaf.darken(20%), dash: "dashed", thickness: 0.5pt)); line((X(8.2), 0.45), (X(8.2), tree.crown_centre - tree.crown_radius), stroke: 1.5pt + rgb("#7a5a3a")); T((X(8.2), tree.crown_centre), [tree\ +2.1…+3.9], size: 3pt)
  // the outlet (in the first bay, north of the section: dashed) and the seating in this section
  rect((X(5.95), air-outlet.at(3)), (X(5.95) + 0.08, air-outlet.at(4)), fill: rgb("#9c6b3c"), stroke: none); T((X(6.1), 1.3), [outlet +0.10…+1.10 (in the first bay, beyond)], size: 2.8pt, fill: rgb("#9c6b3c"), anchor: "west")
  rect((X(7.4), 0), (X(8.25), 0.85), fill: rgb("#b48a5a"), stroke: 0.3pt + ink); T((X(7.82), 1.05), [sofa A · seat +0.42 · eye +1.15], size: 3pt)
  rect((X(6.0), 0), (X(6.75), 0.75), fill: rgb("#b48a5a"), stroke: 0.3pt + ink); T((X(6.37), 0.95), [armchair], size: 3pt)
  line((X(3.0), 1.15), (X(10.5), 1.15), stroke: (paint: gray, thickness: 0.4pt, dash: "dotted"))
  T((X(6.6), -0.3), [E–W section at y ≈ 10.5 (looking north) · 1 m = 1.05 cm · the walls round the open sky: W 3.27 (the soffit) / 7.3, E 7.3, N and S 7.3 (+ the guard)], size: 3.4pt, fill: green)
})
#grid(columns: (auto, auto, 1fr), column-gutter: 8pt,
  plan(), section(),
  [
    #H[Phase 0 · summary]
    - *The courtyard:* an L of 27.19 m² on axes, ≈ #r2(clear-area) m² clear, 4.50 wide between the riwaq glass and the kitchen wall, 6.30 long; the open sky 3.15 × 6.5 m between the projection's edge beam and the kitchen wall, 7.3 m deep (the roof) on three sides and 3.27 m (the soffit) on the colonnade side. The floor level, the porcelain finish, falls of 1 % to the kitchen wall foot.
    - *Who opens onto it:* the women's majlis (fixed glass, north), the living (fixed glass to +3.32, south, W3 above), the riwaq (the sliding door 1.40 and fixed glass, west), the kitchen's sink window (east, +1.10…+2.10, behind the enclosure), the gallery's W1-2 and W1-3 (west, above the colonnade), the family living's W2 × 2 (north, above the majlis glass); the suite lobby above the kitchen wall is blind. *One door only* (the riwaq); the malqaf door opens onto the covered strip, not the courtyard.
    - *Air:* the malqaf core fills the arcade's first bay; the outlet A low on its east face, 1.4 × 1.0, louvres to the south-east, ≈ #r2(mean-eve.q) m³/s at #r1(v-out(mean-eve.q)) m/s in the mean summer-evening wind (W / NW); B would raise and turn it toward the trough. D1 / D2 spring-return on one switch.
    - *Water and tree:* one box on the kitchen wall in front of the sink window; the tree north (planter 1.0 × 1.05 × 0.7, rim +0.45), the raised trough south (1.0 × 0.6 × 0.35, rim +0.95, water +0.85, a laminar lip +1.05), a pump in the divider, both basins to the rain system. The species #A[not decided] (laurel or clipped ficus), the canopy drawn Ø1.8 at +2.1…+3.9.
    - *Seating:* six seats with backs (two 2-seat sofas, two armchairs, a table) in the level zone 2.925 × 5.2 (#r2(zone-free) m² free), facing the outlet arch and the enclosure; no TV.
    - *Services:* two slot drains and an overflow to the rain chamber; two lanterns under the soffit; the pump's circuit, sockets and a lighting circuit *not designed*; the chamber's maintenance door on the covered strip.
    - *Assumptions to carry:* the wind (station data, the on-site station pending), the tree's size and species, the sun geometry (computed in Phase 1), every air figure (the MEP engineer).
    #v(2pt)
    #text(7.5pt)[*Phase 0 checks passed* (the facts read from the files: the courtyard polygon #r2(area(court-axes)) m², the zone #r2(zone-free) m², the outlet #r2(air-outlet.at(2) - air-outlet.at(1)) × #r2(air-outlet.at(4) - air-outlet.at(3)), the enclosure #r2(enc.at(2) - enc.at(0)) × #r2(enc.at(3) - enc.at(1)))]
  ],
)

// ====================================================================== PHASE 1 · THE CHECKS (22 + the owner's two notes: the doors, the "deep well")
// the sun (NOAA formulas, Taif 21.3° N, 40.4° E, UTC+3; computed 10 Nov 2026): (month, day, hour local, altitude °, azimuth ° from N clockwise)
#let suns = (("Jul 15", 12, 84.4, 85.2), ("Jul 15", 14, 67.7, 275.3), ("Jul 15", 16, 40.1, 280.9), ("Jul 15", 18, 13.0, 288.4), ("Jan 15", 10, 34.3, 137.5), ("Jan 15", 12, 46.9, 170.8), ("Jan 15", 14, 41.8, 209.5), ("Jan 15", 15, 33.4, 223.7), ("Mar 21", 12, 67.7, 162.5), ("Oct 15", 15, 37.7, 240.3))
// a point (x, y, z) is sunlit when the ray to the sun passes the sky opening (x 5.8–8.95, y 6.5–13.0) at +7.3; the colonnade (x < 5.8) is under the soffit +3.27
#let lit(p, alt, az) = {
  if alt <= 0 { false } else {
    let d = (7.3 - p.at(2)) / calc.tan(alt * 1deg)
    let sx = p.at(0) + d * calc.sin(az * 1deg); let sy = p.at(1) - d * calc.cos(az * 1deg)
    sx >= 5.8 and sx <= 8.95 and sy >= 6.5 and sy <= 13.0 }
}
#let frac(b, alt, az, z, step: 0.15) = {
  let n = 0; let t = 0; let x = b.at(0) + step / 2
  while x < b.at(2) { let y = b.at(1) + step / 2; while y < b.at(3) { t += 1; if lit((x, y, z), alt, az) { n += 1 }; y += step }; x += step }
  if t == 0 { 0 } else { n / t }
}
#let seat-boxes = furn.filter(f => f.at(4) != "table").map(f => (f.at(0), f.at(1), f.at(2), f.at(3)))
#let seats-lit(alt, az) = seat-boxes.map(b => frac(b, alt, az, 0.45)).sum() / seat-boxes.len()
#let zone-lit(alt, az) = frac(zone, alt, az, 0.45)
#let wall-sun-z(alt, az, y) = 7.3 - (13.0 - y) * calc.tan(alt * 1deg) * calc.cos((az - 180) * 1deg)   // the height above which a face at y (looking south) is sunlit through the south edge
#let svf = 0.07   // the sky view factor from the seats (the solid angle of the 3.15 × 6.5 opening at +6.15 over the eye): 0.066–0.074, computed 10 Nov 2026
#let PASS = text(fill: green, weight: "bold")[PASS]; #let FAIL = text(fill: red, weight: "bold")[FAIL]; #let PART = text(fill: amber, weight: "bold")[PARTIAL]; #let UNK = text(fill: gray, weight: "bold")[UNKNOWN]
#let checks1 = (
  ([*Air*], [], []),
  ([1 · the breeze passes over the water and / or under the tree before the seats], [A: the outlet +0.10…+1.10, louvres to the south-east: the jet runs over the floor to sofa A and the armchairs; the trough's rim is +0.95 and the crown's bottom +2.1: it crosses neither. B (studied): 59 % of the jet's depth over the water, its top under the crown.], [A: #FAIL · B: #PASS]),
  ([2 · the seats downstream at seated head height, no jet in anyone's face], [A: sofa A faces the outlet 1.95 m away: the jet's top there is +1.44 with ±10° spread, the seated eye +1.15: *the jet is in the face*; armchair 1 at 0.45 m likewise. B: the sofa is 2.0 m off the jet's axis (half-width 1.2): the spill from the kitchen wall only.], [A: #FAIL · B: #PASS]),
  ([3 · the head faces the summer evening wind], [the head's W and N faces catch the W (≈ 50 %) / NW (≈ 30 %) evening wind; the house's own roof wake and the old house to the west #A[assumed] until the on-site station.], [#PASS (#A[wind assumed])]),
  ([4 · hot air can rise out], [the sky opening 3.15 × 6.5 = 20.5 m² over a 24.9 m² floor; the colonnade and the living's double height feed it; the stack ≈ 0.49 m³/s in calm.], [#PASS]),
  ([*Sun and shade*], [], []),
  ([5 · shadow on the seating at 16:00 and 18:00 in July, at 10:00 in January], [July 16:00 (sun 40° high, WNW): the seats *#str(calc.round(100 * (1 - seats-lit(40.1, 280.9))))% shaded*; 18:00 (13°): 100 % shaded; July 14:00: #str(calc.round(100 * (1 - seats-lit(67.7, 275.3))))% shaded; July noon (84°): #str(calc.round(100 * seats-lit(84.4, 85.2)))% of the seats in sun. January 10:00 (34°, SE): 100 % shaded; January noon (47°): 100 % shaded.], [summer #PASS · winter #FAIL (no sun)]),
  ([6 · the tree's canopy shades in summer, lets winter sun in], [the crown Ø1.8 at +2.1…+3.9 over the planter in the north-east corner: it shades 2.5 m² of the enclosure and the wall, none of the seats (they are 0.3–3 m south-west of it); in winter no sun reaches the floor anyway (5): the canopy is irrelevant to both.], [#FAIL (no effect)]),
  ([*Water*], [], []),
  ([7 · moving water, no mosquitoes; heard from the seats; safe for children], [a laminar lip +1.05 into the trough (water +0.85): a 0.2 m fall, moving while the pump runs (it must run daily: no standing water). Heard: a laminar sheet is nearly silent (≈ 35–40 dB(A) at 1 m, #A[assumed]): not heard from the seats 2.5–4 m away. Safe: a raised trough (rim +0.95) 0.35 deep: a small child cannot fall in; the planter 0.7 deep is soil.], [moving #PASS · heard #FAIL · safe #PASS]),
  ([8 · leaves in the water and their cleaning], [the crown's edge (y 8.675) is 0.08 m from the trough (y 8.75): the leaves fall straight into the water; a laurel sheds a little all year, a ficus a lot (and fruit). The trough 1.0 × 0.6 is skimmed by hand; no skimmer or cover.], [#FAIL]),
  ([9 · roots vs the water, the drains and the waterproofing], [the planter 1.0 × 1.05 × 0.7 (≈ 0.7 m³) sits in a 0.75 recess on the tanked courtyard slab beside the trough and the main drain; a *Ficus nitida* (aggressive, invasive roots) would fill it in 3–5 years, crack it and block its drain: *unsuitable*; a laurel (fibrous roots) stays, but a standard tree in 0.7 m³ stays small (≈ 3–4 m) and needs irrigation every day in summer. No root barrier is drawn.], [ficus #FAIL · laurel #PART]),
  ([*Use*], [], []),
  ([10 · every seat sees the tree or the water, not a wall or a service door], [sofa A faces west: the core's rendered face and the outlet arch (a wall, 1.5 m away), the enclosure only over its right shoulder; sofa B faces north: the tree and the water ✓; armchair 1 faces east: the enclosure ✓; armchair 2 faces east: the kitchen's plain wall, the enclosure obliquely.], [#PART (2 of 4)]),
  ([11 · conversation: the farthest seat-to-seat < 3.5 m, nobody's back to the group], [farthest 2.23 m (sofa B ↔ armchair 1); every piece faces the table; sofa B's back to the living glass, sofa A's to the kitchen wall: the group is a square round the table.], [#PASS]),
  ([12 · clearances: the walkway, the doors, the glass cleaning, behind the sofas], [the colonnade walkway 1.575 clear (nothing west of the soffit edge); 0.6 at the living glass, 0.5 at the majlis glass, 0.6 behind sofa A at the kitchen wall; the riwaq door's 1.40 opening free; 0.3 only between sofa A and the enclosure (the trough's rim to clean).], [#PASS (0.3 at the trough: tight)]),
  ([13 · privacy from the guest route and the majlis door], [the men's guest route (foyer → majlis) has no view of the courtyard ✓; the *women's majlis* looks straight into the courtyard through 2.1 m of fixed glass (x 6.0–8.1, floor to +2.9): women guests see the family's seating 0.6–6 m away, and the family sees them; no curtain or screen is designed.], [guests #PASS · women's majlis #FAIL]),
  ([14 · the guest route never crosses the family seating], [the courtyard has one door, from the riwaq (family side); the guests never reach the riwaq.], [#PASS]),
  ([15 · the views into the courtyard from the living, the women's majlis, the kitchen sink, the gallery], [the living (south glass to +3.32): the whole courtyard, sofa B's back in front; the women's majlis (north glass): the sofas' fronts and the core; the sink (window +1.1…+2.1): the trough's rim and the tree, as designed ✓; the gallery (W1-2 / W1-3, sill +3.82): down onto the seating and the enclosure ✓; the family living (W2): down onto the enclosure ✓; the suite lobby: blind.], [#PASS (the living sees a sofa's back)]),
)
#let checks2 = (
  ([*Comfort and calm*], [], []),
  ([16 · winter afternoons: sun on the seats, shelter from the cold wind], [*no direct sun on any seat on any winter day* (5): the south wall (the living, 7.3 m) shades the whole floor from October to February; at January noon only the north wall's face above +#r2(wall-sun-z(46.9, 170.8, 6.6)) is sunlit (the women's majlis glass), at 14:00 above +#r2(wall-sun-z(41.8, 209.5, 6.6)); a seat with its back to the north glass would have its body in the sun for ≈ 2 h round noon. Shelter: the breeze shut by the switch; the well is still air ✓.], [sun #FAIL · shelter #PASS]),
  ([17 · night use: soft lighting, no glare into the rooms], [two hanging lanterns under the soffit, the room lights through the glass; no lighting circuit, no sockets, no fittings in the enclosure or the water designed: unresolved.], [#UNK (not designed)]),
  ([18 · acoustics: the water's sound, the fan's noise, echo], [the lip is nearly silent (7); the malqaf's fan behind the core's 0.30 RC wall with its silencer (≈ 38 dB(A) in the chamber): inaudible ✓; the well: 7.3 m of render and glass on four sides over a porcelain floor, ≈ 20 m² of soft surfaces only (the sofas, the tree): a hard, reverberant room (#A[RT ≈ 1.5–2 s]): voices ring, the street's sounds are shut out.], [fan #PASS · water #FAIL · echo #PART]),
  ([19 · scent and planting without mess], [one tree only; a laurel gives scent (its leaves) and little mess; a ficus gives none and much mess; no other planting, no climbers on the 7.3 m walls, no pots.], [laurel #PART · ficus #FAIL]),
  ([*Proportion and beauty*], [], []),
  ([20 · the proportions (width : height, the sky view), the rhythm, the view from each doorway], [the sky slot 3.15 wide between walls 7.3 high: *1 : 2.3* (the courtyard floor 4.5 wide: 1 : 1.6); the traditional comfortable range 1 : 1 to 1 : 1.5. From a seat (eye +1.15) the sky is a patch 29° × 55° (the sky view factor ≈ #svf; a good courtyard 0.2–0.4): *a deep well*. The rhythm: three arches of 2.17 on the west (the first filled by the core), W1 above them aligned, W2 × 2 north, W3 south: coherent ✓. From the riwaq door you face the kitchen's plain wall 4.5 m away with the enclosure in the corner; from the living's glass you face the majlis glass and the back of sofa B.], [#FAIL (the well) · rhythm #PASS]),
  ([*Build and upkeep*], [], []),
  ([21 · drainage; power only where needed; the malqaf's maintenance door clear; cleaning the floor, the water and the leaves], [the falls, two slot drains, the overflow and the rain chamber ✓; the malqaf door on the covered strip, 1.0 m clear ✓; the level porcelain floor hosed to the drains ✓; the water and the leaves: by hand, daily in autumn (8); power: nothing designed (17).], [drains #PASS · leaves #FAIL · power #UNK]),
  ([22 · the evaporative cooler option], [the space 0.8 × 0.7 × 1.6 in the chamber, its outlet against the louvres, a socket, the floor drain, the water point capped ✓; it would blow through the same louvres (A: into sofa A's face at 1.5–2 m).], [#PASS (A: the same face problem)]),
  ([*The owner's two notes*], [], []),
  ([23 · one door only: would a door from the living and / or the women's majlis make the courtyard far better used?], [today the living's 3.8 m of glass (x 4.45–5.55, 6.05–8.75) and the majlis's 2.1 m are fixed: from the living's centre the seating is reached in 9.5 m via the riwaq door, 4.9 m through a door in the living's glass. *The living:* the family's main room, double height on this side, the glass to +3.32 under W3: a sliding door 1.40 at x 6.05–7.45 is simple (the frame only; the beam R2 above is untouched), the threshold 15 mm, and the courtyard becomes the living's outdoor room — the strongest single gain found. *The women's majlis:* a door would hand the courtyard to the women's guests and remove the family's privacy (13): keep the fixed glass with a curtain.], [living door: #FAIL today, a clear gain · majlis door: no]),
  ([24 · the "deep well": the sky 3.15 × 6.5 inside 7.3 m walls], [proportion 1 : 2.3 and the sky view ≈ #svf (20); no winter sun on the floor from October to February (5, 16); summer shade from 13:30 (good); the slot runs north–south, so the only sun that reaches the floor comes near noon. Within the open items the well stays: the walls are rooms (the projection, the family living, the kitchen and the suite lobby above); what can change is how it is lived with: the light colour and the lanterns, a taller tree reaching into the slot, a bright floor, the seating against the north wall for the winter noon, the living's door. Bolder ideas go to Phase 3's "ideas for the owner".], [#FAIL (inherent) · mitigations in Phase 3]),
)
#let tally(rows) = (
  pass: rows.map(r => repr(r.at(2))).filter(s => s.contains("PASS")).len(),
  fail: rows.map(r => repr(r.at(2))).filter(s => s.contains("FAIL")).len(),
)

#pagebreak()
#text(14pt, weight: "bold", fill: green)[Phase 1 · the 22 checks (and the owner's two notes) · pass / fail / unknown, with the numbers]
#v(1pt)
#text(7.2pt, fill: gray)[Sun: NOAA solar position for Taif (21.3° N, 40.4° E, UTC+3); a point is in sun when its ray to the sun passes the 3.15 × 6.5 sky opening at +7.3; the seats tested at +0.45 (the cushion), the eye at +1.15. Air: the free-jet estimate of `studies/malqaf_outlet_B.typ` (±30 %). #A[Amber = assumed.] A = the layout of 10 Nov 2026; B = the outlet study.]
#v(3pt)
#let tbl(rows) = table(columns: (1.05fr, 2.3fr, auto), inset: 2.1pt, stroke: 0.4pt + luma(178), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
  [*Check*], [*The numbers*], [*Verdict*],
  ..rows.map(((a, b, c)) => if repr(b) == "[]" { (table.cell(colspan: 3, fill: rgb("#dfe9d3"), text(weight: "bold", fill: green, a)),) } else { (text(6.6pt, a), text(6.5pt, b), text(6.6pt, c)) }).flatten())
#grid(columns: (1fr, 1fr), column-gutter: 8pt, tbl(checks1), tbl(checks2))

// ====================================================================== PHASE 1 · the sun on the courtyard, drawn · the summary
#pagebreak()
#text(12pt, weight: "bold", fill: green)[Phase 1 · the sun: where the floor and the seats are lit (the sky opening's shadow) · the N–S section at winter noon · the summary]
#v(3pt)
#let sunplan(label, alt, az, length: 0.62cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, t, size: 3.3pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, t))
  let R(b, fill: none, stroke: none) = rect(q((b.at(0), b.at(1))), q((b.at(2), b.at(3))), fill: fill, stroke: stroke)
  R((cx0 - 0.2, cy0 - 0.2, cx1 + 0.2, cy1 + 0.2), fill: luma(205))
  R((cx0, cy0, cx1, cy1), fill: rgb("#bfb9ad"))
  let step = 0.15; let x = cx0 + step / 2
  while x < cx1 { let y = cy0 + step / 2; while y < cy1 { if lit((x, y, 0.0), alt, az) and not (x < core-face and y < core.at(3)) { rect(q((x - step / 2, y - step / 2)), q((x + step / 2, y + step / 2)), fill: rgb("#f7e7a6"), stroke: none) }; y += step }; x += step }
  R(core, fill: luma(60))
  line(q((edge, cy0)), q((edge, cy1)), stroke: (paint: ink, thickness: 0.4pt, dash: "dashed"))
  R(enc, fill: rgb("#c9a86a").transparentize(30%), stroke: 0.3pt + ink); circle(q(crown-c), radius: tree.crown_radius, fill: none, stroke: (paint: leaf.darken(20%), dash: "dashed", thickness: 0.4pt))
  for f in furn { R((f.at(0), f.at(1), f.at(2), f.at(3)), fill: if f.at(4) == "table" { rgb("#fbf4e6") } else { rgb("#b48a5a").transparentize(20%) }, stroke: 0.3pt + ink) }
  T(((cx0 + cx1) / 2, cy0 - 0.55), label, size: 3.6pt, fill: green)
  T(((cx0 + cx1) / 2, cy1 + 0.5), [sun #r1(alt)° high, az #r1(az)° · floor #str(calc.round(100 * frac((cx0, cy0, cx1, cy1), alt, az, 0.0)))% lit · seats #str(calc.round(100 * seats-lit(alt, az)))%], size: 3.2pt)
})
#grid(columns: (1fr,) * 5, column-gutter: 4pt,
  sunplan([July 15 · 12:00], 84.4, 85.2), sunplan([July 15 · 14:00], 67.7, 275.3), sunplan([July 15 · 16:00], 40.1, 280.9), sunplan([Jan 15 · 10:00], 34.3, 137.5), sunplan([Jan 15 · 12:00], 46.9, 170.8))
#v(4pt)
#let nssec(length: 0.78cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, t, size: 3.6pt, fill: ink, anchor: "center", angle: 0deg) = content(p, anchor: anchor, angle: angle, text(size, fill: fill, t))
  let Y(y) = y - 6.5   // north at the left
  rect((Y(5.0), -0.5), (Y(14.6), 8.6), fill: rgb("#f3ece0"), stroke: none); rect((Y(5.0), -0.5), (Y(14.6), 0), fill: luma(120)); line((Y(5.0), 0), (Y(14.6), 0), stroke: 0.6pt + ink)
  rect((Y(6.3), 0), (Y(6.5), 7.3), fill: luma(60), stroke: none); rect((Y(6.4), 0), (Y(6.5), gf-glass-head), fill: blue, stroke: none); T((Y(5.9), 3.6), [women's majlis (GF) · family living (FF, W2) · north wall +7.3], size: 3pt, angle: 90deg)
  rect((Y(13.0), 0), (Y(13.2), 7.3), fill: luma(60), stroke: none); rect((Y(13.0), 0), (Y(13.1), 3.32), fill: blue, stroke: none); T((Y(13.6), 3.6), [living (GF, glass to +3.32) · W3 (FF) · south wall +7.3], size: 3pt, angle: 90deg)
  // the winter noon sun ray grazing the south wall's top
  let alt = 46.9; let k = calc.tan(alt * 1deg)
  line((Y(13.0), 7.3), (Y(13.0) - 7.3 / k, 0), stroke: (paint: amber, thickness: 1pt, dash: "dashed"))
  line((Y(13.0), 7.3), (Y(13.0) - 7.3 / k - 0.4, 0 - 0.4 * k + 0.4 * k), stroke: none)
  let shade = 7.3 / k
  rect((Y(13.0) - shade, 0), (Y(13.0), 0.08), fill: amber.transparentize(20%), stroke: none); T((Y(9.75), 0.3), [January noon (sun 46.9°): the south wall's shadow reaches #r1(shade) m, past the north wall (6.5 m): the whole floor in shade], size: 3.2pt, fill: amber)
  // the sunlit band on the north wall
  let z0 = wall-sun-z(46.9, 170.8, 6.5)
  rect((Y(6.3) - 0.08, z0), (Y(6.3), 7.3), fill: amber, stroke: none); T((Y(6.1), (z0 + 7.3) / 2), [the north wall sunlit above +#r2(z0) at noon (+#r2(wall-sun-z(41.8, 209.5, 6.5)) at 14:00)], size: 3pt, fill: amber, angle: 90deg, anchor: "center")
  // the seats
  for (y0, y1, l) in ((9.8, 11.3, [sofa A]), (11.45, 12.3, [sofa B])) { rect((Y(y0), 0), (Y(y1), 0.85), fill: rgb("#b48a5a").transparentize(40%), stroke: 0.3pt + ink); T((Y((y0 + y1) / 2), 1.05), l, size: 3pt) }
  rect((Y(7.1), 0), (Y(9.5), 0.95), fill: rgb("#c9a86a").transparentize(30%), stroke: 0.3pt + ink); T((Y(8.3), 1.15), [enclosure (east side, beyond)], size: 3pt)
  circle((Y(7.775), tree.crown_centre), radius: tree.crown_radius, fill: leaf.transparentize(60%), stroke: (paint: leaf.darken(20%), dash: "dashed", thickness: 0.4pt))
  T((Y(9.75), 8.2), [the sky slot 6.5 m long, 7.3 m deep · N–S section through the seating (looking west) · 1 m = 0.78 cm], size: 3.4pt, fill: green)
  T((Y(5.2), -0.3), [N], size: 4pt, anchor: "west"); T((Y(14.4), -0.3), [S], size: 4pt, anchor: "east")
})
#grid(columns: (auto, 1fr), column-gutter: 10pt,
  nssec(),
  [
    #H[Phase 1 · summary (#tally(checks1 + checks2).fail verdicts fail, #tally(checks1 + checks2).pass pass, 2 unknown)]
    - *The biggest finding is the well.* The sky slot is 3.15 m wide between 7.3 m walls (1 : 2.3; the sky view from a seat ≈ 7 %): *no direct sun reaches the floor or any seat from October to February*; in summer the floor is shaded from about 13:30 (good). The walls are rooms, so the well stays; what the open items can do is live with it: the north wall's face is in the winter noon sun above +0.5, so a seat with its back to the women's majlis glass gets the sun on the body for ≈ 2 h; the light render, the lanterns, a taller tree in the slot, the living's door.
    - *The air works but hits the faces (A):* the low outlet aimed at the seats puts the jet's top at +1.44 on sofa A's sitters (eye +1.15) and misses the water and the tree. The raised, turned outlet (B) fixes both: the air over the trough and under the crown, the seats in the spill.
    - *The water and the tree are in the wrong relation:* the crown hangs 0.08 m from the trough (leaves in the water), the laminar lip is inaudible, the planter (0.7 m³) is too small for a ficus (roots, the drains) and small for a laurel; no skimmer, no root barrier.
    - *Use:* the conversation square and the clearances are right (11, 12); two of the four seats look at a wall (10); the women's majlis's fixed glass gives no privacy from women guests (13); *the living has no door* onto its own courtyard (23): 9.5 m round by the riwaq against 4.9 m through the glass; a sliding door at x 6.05–7.45 is the clearest single gain; no door from the majlis.
    - *Not designed yet:* the lighting and the power (17, 21); the acoustics are hard (18); the planting is one tree (19).
    - *Phase 2* ranks these; *Phase 3* draws 2–3 layouts within the open items (the outlet B, the seating turned to the water and the north wall, the enclosure re-made with the tree away from the water, a skimmer, the living's door, the lighting, the floor pattern, the planting) and lists the bolder ideas (the well) for the owner.
    #v(2pt)
    #text(7.5pt)[*Phase 1 checks computed* (the sun at #suns.len() moments; the seats' lit shares; the jet geometry; the paths).]
  ],
)

// ====================================================================== PHASE 2 · THE MISTAKES, RANKED · the tree in a pot (the owner, 10 Nov 2026) and the re-checks
#let mistakes = (
  ([1], [*No winter sun on any seat, October to February* (checks 5, 16)], [The haven's best season in Taif is the cool half of the year (the pleasant seating hours peak Oct–Apr, `malqaf_L5.typ` 44–46); a courtyard without winter sun is a cold, grey room for five months.], [100 % of the seats shaded at 10:00, 12:00, 14:00 and 15:00 on 15 Jan; the only sun on the north wall's face above +0.46 at noon], [*not within the open items* (the walls are rooms): Phase 3 gives the mitigation (the north-wall seat) and the bold ideas for the owner]),
  ([2], [*The deep well* (checks 20, 24)], [A sky slot 3.15 m wide between 7.3 m walls (1 : 2.3) and a sky view of ≈ 7 % from the seats: the courtyard reads as a shaft, not a garden; it also makes 1 inevitable and the echo (18) worse.], [proportion 1 : 2.3 (the good range 1 : 1–1 : 1.5); sky view factor 0.07 (0.2–0.4 in a good courtyard); the sky a 29° × 55° patch], [*not within the open items*: mitigations only (the colour, the lanterns, a taller tree, the living's door); the bold ideas in Phase 3]),
  ([3], [*The breeze blows into the faces and misses the water and the tree* (checks 1, 2)], [The malqaf is the courtyard's reason: a 2 m/s jet at +0.1…+1.4 on the people facing it 2 m away is a draught, not a breeze; and the water and the tree, the two things that cool and scent the air, are beside the jet, not in it.], [sofa A's eye +1.15 inside the jet (top +1.44 at 1.95 m); 0 % of the jet over the water or under the crown], [*within the open items*: the outlet raised and turned (B), the seats in the spill, 0.6 m/s instead of 0.8–1.0 but on the whole body]),
  ([4], [*The living has no door onto its own courtyard* (check 23)], [The family's main room looks at the haven through 3.8 m of fixed glass and reaches it round two corners; the courtyard is used less than it could be and the living never spills out.], [9.5 m via the riwaq door against 4.9 m through the glass; 1 door today, 2 with it], [*within the open items*: a sliding door 1.40 in the living's glass (frame only)]),
  ([5], [*Leaves in the water; the tree's roots beside the water, the drain and the waterproofing* (checks 8, 9)], [A trough skimmed by hand every day in autumn is a chore the family will drop; a ficus in a 0.7 m³ built-in planter breaks it within years.], [the crown's edge 0.08 m from the trough; the planter 0.7 m³ against 2–3 m³ for a tree; no barrier, no skimmer], [*within the open items*, and *settled by the owner's olive in a fixed pot* (below), away from the water; the enclosure re-made]),
  ([6], [*The women's majlis looks straight into the family's seating* (check 13)], [Whenever women guests sit in the majlis, the family's courtyard is on view through 2.1 m of clear glass 0.6–6 m away, and the guests are on view from the courtyard: the haven stops being private on every reception day.], [glass x 6.0–8.1, floor to +2.9, fixed, no screen], [*within the open items*: a curtain or a timber lattice on the majlis side (the design language's mashrabiya), or obscured glass below +1.6]),
  ([7], [*The water is silent* (checks 7, 18)], [The sound of water is half of what a courtyard's water gives; a laminar lip over a 0.2 m fall is inaudible from 3 m.], [≈ 35–40 dB(A) at 1 m, assumed; the seats 2.5–4 m away], [*within the open items*: a higher fall (0.4–0.5 m) into a deeper basin or a small spout; the pump sized for it]),
  ([8], [*Two of the four seats look at a wall* (check 10)], [Sofa A faces the core's rendered face 1.5 m away; armchair 2 faces the kitchen's plain wall: the two things worth looking at (the tree and the water) are behind or beside them.], [2 of 4 seats; sofa A's view 1.5 m of wall], [*within the open items*: the seating turned to the water and the tree (B's arrangement or the north-wall seat)]),
  ([9], [*The hard well: echo* (check 18)], [Four hard faces 7.3 m high over porcelain: voices ring; the water's sound (7) would help, and so do the sofas, the tree and a soft wall.], [≈ 20 m² of soft surfaces in a 24.9 m² room 7.3 m deep; RT ≈ 1.5–2 s (assumed)], [*within the open items*: planting on a wall, fabric, the water's sound; the colour]),
  ([10], [*Lighting and power not designed* (checks 17, 21)], [Two lanterns and the room lights are not a night courtyard; the pump, the sockets, the lighting circuit and its switch exist nowhere.], [0 fittings designed, 0 circuits], [*within the open items*: a lighting plan (soft, low, no glare into the rooms), a socket pair, the pump's circuit; the MEP engineer]),
  ([11], [*One tree, nothing else* (check 19)], [A single tree beside the water is a token; scent, softness and the sense of a garden need more than one plant, without mess.], [1 tree; 0 m² of other planting], [*within the open items*: pots and a climber on one wall (Phase 3)]),
  ([12], [*The trough's rim 0.3 m from sofa A* (check 12)], [Too tight to clean the rim or to walk round the sofa.], [0.3 m], [*within the open items*: the seating moved (3, 8)]),
)
#pagebreak()
#text(14pt, weight: "bold", fill: green)[Phase 2 · the mistakes, ranked · why each matters and how big it is · what the open items can fix]
#v(1pt)
#text(7.2pt, fill: gray)[Ranked as the owner asked: the winter sun and the deep well first, with the air in the face; then by how much each spoils the haven. "Within the open items" means Phase 3 can fix it without touching the locked structure and rooms; the first two cannot be fixed that way, only softened, and their bold answers go to the owner in Phase 3.]
#v(3pt)
#table(columns: (auto, 1.3fr, 1.7fr, 1.2fr, 1.3fr), inset: 2.2pt, stroke: 0.4pt + luma(178), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
  [*#sym.numero*], [*The mistake*], [*Why it matters*], [*Its size*], [*Fixable within the open items?*],
  ..mistakes.map(((n, a, b, c, d)) => (text(weight: "bold", n), text(6.6pt, a), text(6.5pt, b), text(6.5pt, c), text(6.5pt, d))).flatten())

// ---------- the tree in a pot (the owner, 10 Nov 2026) ----------
#let pots = (
  ([*Olive* · _Olea europaea_ (a fruitless or a table cultivar; a 2–3 m standard)], [the right tree for a pot in Taif: hardy to −8 °C (the winters), drought-tolerant, evergreen with small silver leaves (little litter, light under it), slow and happy in a pot for decades, the classic Hijaz / Mediterranean courtyard tree; no scent (a laurel or a lemon beside it for that); a clipped head 2–2.5 m across at +1.8…+3.9], [Ø 100 × 80 cm (≈ 0.55 m³ of soil)], [≈ 1.2 t wet (soil 0.9 + pot 0.15 + tree 0.1)], [*the owner's tree*]),
  ([*Bay laurel* · _Laurus nobilis_ (a clipped standard or cone)], [hardy to −5 °C, evergreen, dense, the leaves' scent when brushed, little litter; slower, wants a little shade from the July sun on its pot; the second tree or the alternative], [Ø 80 × 70 cm (≈ 0.3 m³)], [≈ 0.7 t], [a second pot (scent)]),
  ([*Lemon* · _Citrus limon_ (a dwarf or a Meyer on a dwarfing rootstock)], [the scent of the blossom and the fruit are the courtyard's pleasure, but it is frost-tender (Taif can touch 0 °C in January: a fleece on the coldest nights), drops leaves and fruit, wants feeding and steady water; keep it as a *third, smaller pot* in the sunniest spot (the north wall's foot at noon), not as the main tree], [Ø 60 × 55 cm (≈ 0.15 m³)], [≈ 0.35 t], [optional, winter cover]),
)
#let recheck = (
  ([6 · the canopy shades in summer, lets winter sun in], [the olive fixed at the seating group's south-west corner, 2.5–3 m high with a 2 m head: at July noon (the sun 84° high) it shades ≈ 3 m² of the seats under its head, the table and the sofas' near ends, in the only sunlit hours (11:00–13:30; the walls shade everything after); in winter the floor gets no sun whatever the tree does (1), and the olive's thin evergreen head takes nothing away.], [summer #PASS · winter n/a]),
  ([8 · leaves in the water], [the pot stands ≈ 3 m from the water: the olive's small leaves fall on the floor by the colonnade and are swept; nothing hangs over the trough.], [#PASS]),
  ([9 · roots vs the water, the drains, the waterproofing], [the roots are inside the pot; the pot stands on the finished floor (no recess, the membrane untouched); its drain holes over a tray or a saucer piped to the nearest slot drain (the kitchen-wall drain, y 9.6–12.8); *the weight:* ≈ 1.2 t on a Ø 1.0 m base (≈ 1.5 t/m²) at one fixed spot: the ground-bearing courtyard slab takes it; the engineer notes the spot (the slab is lowered 0.05 there for the build-up, `plumbing.typ`) and, if the courtyard ever becomes a suspended slab, designs for the point load.], [#PASS (engineer's note)]),
  ([19 · scent and planting without mess], [the olive gives no scent and little mess; the laurel gives scent when brushed; the lemon gives the scent and some mess; a jasmine on a wire on one wall (the kitchen wall's plain part) gives the evening scent with little litter. The olive fixed, a laurel and a lemon as smaller pots where they fit (Phase 3), a jasmine on a wire: a garden, not a token.], [#PASS with the pots]),
)
#pagebreak()
#text(12pt, weight: "bold", fill: green)[Phase 2 · the olive in a large, free-standing, fixed pot (the owner's choice) · the pot, its best position, the weight, the water · the four checks re-run]
#v(3pt)
#text(7.2pt, fill: gray)[The owner (10 Nov 2026): the tree is an *olive* in a large, free-standing, *fixed* pot (not in the ground, not a built-in planter): the roots contained; its pot, its one best position (summer shade on the seats, away from the water), its weight, its drainage and watering. Taif: 1 700 m, winter nights 2–5 °C with rare frost, summer days 32–36 °C, dry air, hard water (#A[station data; the nursery confirms the hardiness on site]).]
#v(3pt)
#table(columns: (1.1fr, 2.4fr, auto, auto, auto), inset: 2.2pt, stroke: 0.4pt + luma(178), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
  [*Species*], [*Why / why not in a pot in Taif*], [*Pot*], [*Weight*], [*Verdict*],
  ..pots.map(((a, b, c, d, e)) => (text(6.7pt, a), text(6.5pt, b), text(6.5pt, c), text(6.5pt, d), text(6.6pt, weight: "bold", e))).flatten())
#v(4pt)
#grid(columns: (1fr, 1fr), column-gutter: 10pt,
  [
    #H[The olive's pot, its fixed position and its services]
    - *The pot:* Ø 100 cm, 80 cm deep (≈ 0.55 m³ of soil), glazed terracotta or GRC in the sand / honey tone (the render-and-paint language), *fixed* on pot feet 5 cm high so the base dries; 4–6 drain holes over a *saucer with an overflow spout* led by a Ø 32 pipe in the floor build-up to the nearest slot drain; the soil a free-draining olive mix (loam, sand, 30 % perlite) over 10 cm of gravel.
    - *Its one best position:* *inside the seating group at its south-west corner, against the colonnade's soffit edge* (the pot's centre ≈ x 6.5, y 11.8: east of the soffit edge x 5.925 so the walkway stays clear, north of the living's cleaning strip y 12.3–12.9, ≥ 2 m from the water): near the summer noon the sun stands almost overhead (84° in July), so a tree shades only what is *under its head*: from this corner the 2 m head (+1.8…+3.9) covers the table and the near ends of both sofas, ≈ 3 m² of the seats, at the only hours the walls do not shade them (11:00–13:30); its leaves fall on the floor by the colonnade, never in the trough (3 m away); it is the first thing seen from the riwaq door and from the living's glass, and it reads with the arcade behind it. In winter it stands in the shade like everything else (1). Phase 3 draws the seats round it.
    - *Water:* a drip ring on a timer from the enclosure's supply (the pump chamber's water point, a buried Ø 16 line to the pot): ≈ 15–25 L twice a week in summer, every 10 days in winter (#A[assumed; the nursery sets it]); the saucer never standing; a yearly feed; the head clipped once a year.
    - *Weight (a note for the engineer):* ≈ 1.2 t wet on a Ø 1.0 m base ≈ 1.5 t/m²; the courtyard slab is ground-bearing (the house's ground slab, lowered 0.05 for the outdoor build-up, `studies/plumbing.typ`): fine; if the engineer makes the courtyard a suspended slab over a drainage void, the pot's spot is a point load to note.
    - *Fixed:* no castors; the pot's circle marked in the floor pattern (Phase 3); the saucer's pipe permanent (to the riwaq-door slot drain 1.6 m west or the kitchen-wall drain 2.2 m east, Phase 3 chooses); if the pot must ever move, a pallet trolley and two people.
    - *Size:* buy it at 2.0–2.5 m with a 1.5 m head (a 15–20-year tree from a Taif or Hijaz nursery); it reaches 3 m in a few years and stays there with the clip; the head starts at +1.8 so the seated people sit under it, not in it; the pot's top at +0.85, no climbing edge for a child.
  ],
  [
    #H[The four checks re-run with the pot]
    #table(columns: (1fr, 2.2fr, auto), inset: 2.2pt, stroke: 0.4pt + luma(178), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      [*Check*], [*With the pot*], [*Verdict*],
      ..recheck.map(((a, b, c)) => (text(6.6pt, a), text(6.5pt, b), text(6.6pt, c))).flatten())
    #v(3pt)
    #H[What the pot changes in the design]
    - The built-in planter in the enclosure goes: the enclosure becomes *the water only* (Phase 3 re-draws it: a trough or a basin with an audible fall, a skimmer, the pump), 0.8–1.0 m shorter along the kitchen wall; the sink's view becomes the water and, beside it, the olive's pot.
    - The floor pattern marks the pot's circle and the furniture line; the pot's drain pipe and the drip line are small items for the plumbing study; a socket pair and the lighting (Phase 3) near it.
    - Mistake 5 is settled; mistakes 7, 8 and 11 are opened for Phase 3's layouts.
    #v(2pt)
    #text(7.5pt)[*Phase 2 complete:* #mistakes.len() mistakes ranked; the pot re-checks 6, 8, 9 and 19 → pass. Phase 3 next: the layouts and the ideas for the owner.]
  ],
)

// ====================================================================== PHASE 3 · THE OPTIONS (within the open items) and the IDEAS FOR THE OWNER
// the owner's answers (10 Nov 2026) applied in every option: the living's glass stays fixed (the riwaq's sliding door is the courtyard's door); the women's majlis glass gets a
// curtain inside the majlis; the water a calm, audible fall with a skimmer; the olive in its fixed pot at the seating group's south-west corner; the built-in planter removed.
#let olive = (cx: 6.5, cy: 11.8, r: 0.5, crown: 1.0)     // the fixed pot Ø 1.0 (x 6.0–7.0, y 11.3–12.3), the head Ø 2.0 at +1.8…+3.9
#let H1 = (
  id: "H1", name: [H1 · fixes in place], sub: [the outlet A kept (its louvres set low, along the floor); the water re-made where it is; the olive; the seats turned to the water],
  outlet: (y0: 7.1, y1: 8.5, z0: 0.10, z1: 1.10, aim: 40deg, note: [A as built: low; the louvres fixed 40° south-east and 10° down so the jet runs along the floor to the kitchen wall, not at the faces]),
  water: (box: (7.55, 7.4, 8.85, 8.7), kind: [a basin 1.3 × 1.3 on the kitchen wall under the sink window: a wall spout at +1.00 falls 0.45 into water at +0.55, rim +0.70; a skimmer basket at the overflow; the pump in a dry chamber under the spout], rim: 0.70, level: 0.55, fall: 0.45),
  furn: ((6.6, 10.4, 8.25, 11.25, "sofa · 3", "N"), (6.0, 9.5, 6.75, 10.25, "armchair", "E"), (7.5, 11.5, 8.25, 12.25, "armchair", "W"), (7.05, 11.45, 7.45, 12.0, "table", "")),
  pots: ((7.9, 8.85, 8.7, 9.65, [laurel pot Ø 0.8]),),
  light: [the two lanterns (soffit) + a submerged warm light in the basin + two low wall lights on the kitchen wall's plain part (a 2700 K strip behind the jasmine wire); one switch by the riwaq door, one dimmer],
  floor: [plain sand porcelain, a darker 0.3 m border on the three glass lines and the colonnade line; the olive's circle and the furniture line in the darker tone],
  plants: [the olive; a laurel pot by the basin (scent); a jasmine on a wire on the kitchen wall south of the basin],
  outside: [`studies/air_system.typ` (the louvres' fixed angle only), the courtyard study and `3d/character.yaml` (the enclosure re-made, the furniture, the pot), the plumbing (the basin's pump chamber, the skimmer, the pot's drain and drip line), the lighting circuit and two sockets (MEP), the 3D, sheet 02],
  sec-note: [E–W through the seating: the low jet runs under the seated eye to the wall; the basin's fall 0.45; the olive's head over the table],
)
#let H2 = (
  id: "H2", name: [H2 · the breeze over the water (outlet B)], sub: [the outlet raised and turned at the water; the water a long trough along the kitchen wall in the jet's path; the seats in the spill facing the water],
  outlet: (y0: 6.9, y1: 8.3, z0: 0.60, z1: 1.60, aim: 30deg, note: [B: raised, centred in the bay, the louvres fixed 30° south-east with splayed reveals: over the trough's rim and under the olive's head]),
  water: (box: (7.9, 7.3, 8.85, 9.4), kind: [a trough 2.1 × 0.95 along the kitchen wall under and south of the sink window: a wall spout at +1.05 at its north end falls 0.40 into water at +0.65, rim +0.80 (the sill +1.10 above it); the skimmer at the south end where the flow ends; the pump in a dry chamber], rim: 0.80, level: 0.65, fall: 0.40),
  furn: ((6.6, 10.4, 8.25, 11.25, "sofa · 3", "N"), (6.0, 9.5, 6.75, 10.25, "armchair", "E"), (7.5, 11.5, 8.25, 12.25, "armchair", "W"), (7.05, 11.45, 7.45, 12.0, "table", "")),
  pots: ((6.05, 7.2, 6.85, 8.0, [laurel pot Ø 0.8 · beside the outlet, below its sill]),),
  light: [as H1, plus a light under the trough's spout; the olive up-lit from the floor],
  floor: [a porcelain "carpet": a 0.6 m border in the honey tone round the seating zone, the field sand; the olive's circle in the border tone],
  plants: [the olive; a laurel pot in the north-west corner (its head below the raised outlet's sill +0.6: it does not block the jet); a jasmine on the kitchen wall's south part],
  outside: [`studies/air_system.typ` (`air-outlet` → y 6.9–8.3, +0.60…+1.60, fixed louvres), `3d/params.yaml` (the outlet window), the courtyard study and `character.yaml` (the trough, the furniture, the pot), the plumbing, the lighting and sockets, the 3D, the DXF, sheet 02],
  sec-note: [E–W through the outlet's axis: the jet +0.6…+1.6 over the trough's rim +0.80 and under the olive's head +1.8; the spill down the kitchen wall onto the sofa],
)
#let H3 = (
  id: "H3", name: [H3 · the water in the middle, a winter seat on the north wall], sub: [the water a low basin in the courtyard's north-east quarter; a 2-seat sofa with its back to the women's majlis glass for the winter noon; the outlet A re-aimed at the basin],
  outlet: (y0: 7.1, y1: 8.5, z0: 0.10, z1: 1.10, aim: 35deg, note: [A as built, the louvres fixed 35° south-east at the basin (the jet skims the water: cooled a little) and clear of the winter sofa]),
  water: (box: (7.4, 8.2, 8.6, 9.4), kind: [a low square basin 1.2 × 1.2, 0.25 m off the kitchen wall, rim +0.45, water +0.30 (a mesh 5 cm under the surface for the children), a central calm bubbler 0.25 high: audible from every seat; the skimmer basket in a corner; the pump below the basin], rim: 0.45, level: 0.30, fall: 0.25),
  furn: ((7.1, 6.7, 8.6, 7.55, "winter sofa · 2", "S"), (6.6, 10.4, 8.25, 11.25, "sofa · 3", "N"), (6.0, 9.5, 6.75, 10.25, "armchair", "E"), (7.3, 11.5, 7.9, 12.0, "table", "")),
  pots: ((7.5, 12.0, 8.3, 12.8, [laurel pot Ø 0.8]),),
  light: [as H1, with the bubbler lit from below and a low light at the winter sofa; the lanterns dimmed; nothing shining into the majlis or the living],
  floor: [the field sand; a honey-tone square frames the basin (0.4 m) and a band marks the winter sofa's place at the north glass; the olive's circle],
  plants: [the olive; a laurel pot in the south-east corner by the living glass (moved for cleaning); a jasmine on the kitchen wall's south part; the basin's margin a single potted papyrus or none],
  outside: [`studies/air_system.typ` (the louvres' fixed angle), the courtyard study and `character.yaml` (the basin, the winter sofa, the furniture, the pot; the north cleaning strip given up for a movable sofa), the plumbing (the basin, the pump, the skimmer, the pot), the lighting and sockets, the 3D, sheet 02; the majlis curtain (the interiors)],
  sec-note: [N–S through the basin: the winter sofa's back on the north glass (its body in the January noon sun above +0.46), the basin 0.8 m in front, the main sofa opposite; the olive's head at the right],
)
#let opts = (H1, H2, H3)
#let seats-of(F) = F.map(f => if f.at(4).contains("sofa") { int(f.at(4).slice(-1)) } else if f.at(4) == "armchair" { 1 } else { 0 }).sum()

#let oplan(o, length: 1.1cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, t, size: 3.3pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, t))
  let R(b, fill: none, stroke: none) = rect(q((b.at(0), b.at(1))), q((b.at(2), b.at(3))), fill: fill, stroke: stroke)
  R((cx0 - 0.3, cy0 - 0.3, cx1 + 0.3, cy1 + 0.3), fill: luma(205))
  R((cx0, cy0, cx1, cy1), fill: rgb("#e4d6b8"))
  R((cx0, cy0, edge, cy1), fill: rgb("#ece4cf")); line(q((edge, cy0)), q((edge, cy1)), stroke: (paint: ink, thickness: 0.5pt, dash: "dashed"))
  // the floor pattern: a darker border on the glass lines and the colonnade line
  for b in ((cx0, cy0, cx1, cy0 + 0.3), (cx0, cy1 - 0.3, cx1, cy1), (edge, cy0, edge + 0.3, cy1)) { R(b, fill: rgb("#d8c39a").transparentize(50%)) }
  R(core, fill: luma(60)); T((5.1, 7.6), [malqaf\ core], size: 3.4pt, fill: white)
  for y in (6.5, 13.0) { circle(q((col-x, y)), radius: 0.2, fill: luma(60), stroke: none) }
  circle(q((col-x, 10.8333)), radius: 0.125, fill: luma(120), stroke: 0.3pt + ink)
  // the outlet and its jet
  let ot = o.outlet
  line(q((core-face, ot.y0)), q((core-face, ot.y1)), stroke: 3.5pt + rgb("#9c6b3c")); T((core-face + 0.12, (ot.y0 + ot.y1) / 2), [outlet · #f2(ot.z0)…#f2(ot.z1)], size: 2.9pt, fill: rgb("#9c6b3c"), anchor: "west", angle: 90deg)
  let c = (core-face, (ot.y0 + ot.y1) / 2); let s1 = 3.2; let e1 = (c.at(0) + s1 * calc.cos(ot.aim), c.at(1) + s1 * calc.sin(ot.aim)); let wl = 0.7 + s1 * calc.tan(10deg); let n = (-calc.sin(ot.aim), calc.cos(ot.aim))
  line(q((c.at(0), c.at(1) - 0.7)), q((e1.at(0) - n.at(0) * wl, e1.at(1) - n.at(1) * wl)), q((e1.at(0) + n.at(0) * wl, e1.at(1) + n.at(1) * wl)), q((c.at(0), c.at(1) + 0.7)), close: true, fill: blue.transparentize(82%), stroke: none)
  line(q(c), q(e1), stroke: (paint: blue, thickness: 0.7pt, dash: "dashed"), mark: (end: "stealth", fill: blue, scale: 0.45))
  // the water
  let w = o.water.box
  R(w, fill: rgb("#c9a86a"), stroke: 0.4pt + ink); R((w.at(0) + 0.15, w.at(1) + 0.15, w.at(2) - 0.15, w.at(3) - 0.15), fill: water, stroke: 0.3pt + ink)
  T(((w.at(0) + w.at(2)) / 2, (w.at(1) + w.at(3)) / 2), [water · rim #f2(o.water.rim)\ fall #r2(o.water.fall)], size: 2.9pt)
  line(q((cx1, sink.y.at(0))), q((cx1, sink.y.at(1))), stroke: 3pt + blue); T((cx1 + 0.12, 8.1), [sink window], size: 2.8pt, fill: blue, anchor: "west", angle: 90deg)
  // the olive, the pots
  circle(q((olive.cx, olive.cy)), radius: olive.crown, fill: leaf.transparentize(60%), stroke: (paint: leaf.darken(20%), dash: "dashed", thickness: 0.5pt))
  circle(q((olive.cx, olive.cy)), radius: olive.r, fill: rgb("#b48a5a"), stroke: 0.5pt + ink); T((olive.cx, olive.cy), [olive\ pot Ø1.0], size: 2.9pt, fill: white)
  for (x0, y0, x1, y1, l) in o.pots { circle(q(((x0 + x1) / 2, (y0 + y1) / 2)), radius: (x1 - x0) / 2, fill: leaf.transparentize(40%), stroke: 0.4pt + ink); T(((x0 + x1) / 2, (y0 + y1) / 2), l, size: 2.6pt) }
  // the seats
  for f in o.furn {
    R((f.at(0), f.at(1), f.at(2), f.at(3)), fill: if f.at(4) == "table" { rgb("#fbf4e6") } else { rgb("#b48a5a") }, stroke: 0.4pt + ink)
    if f.at(4) != "table" { let fc = ((f.at(0) + f.at(2)) / 2, (f.at(1) + f.at(3)) / 2); let d = if f.at(5) == "N" { (0, -0.3) } else if f.at(5) == "S" { (0, 0.3) } else if f.at(5) == "W" { (-0.3, 0) } else { (0.3, 0) }
      line(q(fc), q((fc.at(0) + d.at(0), fc.at(1) + d.at(1))), stroke: 0.6pt + white, mark: (end: "stealth", fill: white, scale: 0.4)); T(fc, [#f.at(4)], size: 2.8pt, fill: white) }
  }
  // the lights (lanterns, wall lights)
  for p in ((5.6, 9.75), (5.6, 12.4)) { circle(q(p), radius: 0.1, fill: amber, stroke: none) }
  // the doors and glass
  line(q((cx0, 9.1)), q((cx0, 10.5)), stroke: 3pt + red); T((cx0 - 0.12, 9.8), [riwaq door], size: 2.8pt, fill: red, anchor: "east", angle: 90deg)
  line(q((6.0, cy0)), q((8.1, cy0)), stroke: 2pt + blue); T((7.05, cy0 - 0.22), [majlis glass · curtain inside], size: 2.8pt, fill: blue)
  line(q((4.45, cy1)), q((5.55, cy1)), stroke: 2pt + blue); line(q((6.05, cy1)), q((8.75, cy1)), stroke: 2pt + blue); T((6.6, cy1 + 0.22), [living glass · fixed], size: 2.8pt, fill: blue)
  T(((cx0 + cx1) / 2, cy0 - 0.7), o.name, size: 4.4pt, fill: green)
  T(((cx0 + cx1) / 2, cy1 + 0.65), [#seats-of(o.furn) seats with backs · 1 m = 1.1 cm], size: 3.2pt, fill: gray)
})
#let osec(o, length: 0.72cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, t, size: 3.3pt, fill: ink, anchor: "center", angle: 0deg) = content(p, anchor: anchor, angle: angle, text(size, fill: fill, t))
  let ot = o.outlet; let w = o.water
  if o.id != "H3" {
    // E–W: x along, z up; the core's face at 5.95 (left), the kitchen wall at 8.85 (right)
    let X(x) = x - 5.5
    rect((X(5.3), -0.4), (X(9.4), 4.6), fill: rgb("#f3ece0"), stroke: none); rect((X(5.3), -0.4), (X(9.4), 0), fill: luma(120)); line((X(5.3), 0), (X(9.4), 0), stroke: 0.6pt + ink)
    rect((X(5.65), 0), (X(5.95), 3.6), fill: luma(60), stroke: none); rect((X(5.65), ot.z0), (X(5.95), ot.z1), fill: rgb("#9c6b3c"), stroke: none); T((X(5.8), 2.3), [core · east wall], size: 2.8pt, fill: white, angle: 90deg)
    rect((X(8.85), 0), (X(9.05), 4.6), fill: luma(60), stroke: none); T((X(8.95), 3.2), [kitchen wall], size: 2.8pt, fill: white, angle: 90deg)
    rect((X(8.85) - 0.02, sink.sill), (X(8.85), sink.head), fill: none, stroke: (paint: blue, thickness: 0.6pt, dash: "dashed")); T((X(8.6), sink.head + 0.15), [sink window +1.10…+2.10], size: 2.7pt, fill: blue, anchor: "east")
    // the jet
    let k = calc.tan(10deg); let L = 2.9
    line((X(5.95), ot.z0), (X(5.95) + L, ot.z0 - L * k), (X(5.95) + L, ot.z1 + L * k), (X(5.95), ot.z1), close: true, fill: blue.transparentize(80%), stroke: none)
    line((X(5.95), (ot.z0 + ot.z1) / 2), (X(5.95) + L, (ot.z0 + ot.z1) / 2 - (if o.id == "H1" { 0.5 } else { 0 })), stroke: (paint: blue, thickness: 0.7pt, dash: "dashed"), mark: (end: "stealth", fill: blue, scale: 0.45))
    // the water on the wall
    rect((X(w.box.at(0)), 0), (X(8.85), w.rim), fill: rgb("#c9a86a"), stroke: 0.4pt + ink); rect((X(w.box.at(0)) + 0.15, w.rim - 0.12), (X(8.85) - 0.1, w.level), fill: water, stroke: none)
    rect((X(8.85) - 0.12, w.level + w.fall - 0.05), (X(8.85), w.level + w.fall + 0.05), fill: rgb("#9c6b3c"), stroke: none); line((X(8.85) - 0.15, w.level + w.fall), (X(8.85) - 0.2, w.level + 0.02), stroke: 1pt + blue)
    T((X((w.box.at(0) + 8.85) / 2), w.rim + 0.15), [water · rim #f2(w.rim) · the spout falls #r2(w.fall)], size: 2.8pt)
    // the olive and the seats
    circle((X(olive.cx), 2.85), radius: 1.0, fill: leaf.transparentize(60%), stroke: (paint: leaf.darken(20%), dash: "dashed", thickness: 0.4pt)); line((X(olive.cx), 0.85), (X(olive.cx), 1.85), stroke: 2pt + rgb("#7a5a3a")); rect((X(olive.cx) - 0.5, 0), (X(olive.cx) + 0.5, 0.85), fill: rgb("#b48a5a"), stroke: 0.3pt + ink); T((X(olive.cx), 0.42), [pot], size: 2.8pt, fill: white)
    for f in o.furn { if f.at(4).contains("sofa") { rect((X(f.at(0)), 0), (X(f.at(2)), 0.85), fill: rgb("#b48a5a").transparentize(30%), stroke: (paint: ink, thickness: 0.3pt, dash: "dashed")); T((X((f.at(0) + f.at(2)) / 2), 1.0), [#f.at(4) (beyond) · eye +1.15], size: 2.8pt) } }
    line((X(5.3), 1.15), (X(9.4), 1.15), stroke: (paint: gray, thickness: 0.4pt, dash: "dotted"))
    T((X(7.3), 4.3), [#o.id · E–W section (looking north) · 1 m = 0.72 cm], size: 3.2pt, fill: green)
  } else {
    // N–S: y along (north left), z up; the majlis glass at 6.6, the living glass at 12.9
    let Y(y) = y - 6.2
    rect((Y(6.0), -0.4), (Y(13.5), 4.6), fill: rgb("#f3ece0"), stroke: none); rect((Y(6.0), -0.4), (Y(13.5), 0), fill: luma(120)); line((Y(6.0), 0), (Y(13.5), 0), stroke: 0.6pt + ink)
    rect((Y(6.4), 0), (Y(6.6), 4.6), fill: luma(60), stroke: none); rect((Y(6.5), 0), (Y(6.6), gf-glass-head), fill: blue, stroke: none); T((Y(6.3), 2.5), [women's majlis glass · curtain inside · sunlit above +0.46 at the January noon], size: 2.7pt, fill: white, angle: 90deg)
    rect((Y(12.9), 0), (Y(13.1), 4.6), fill: luma(60), stroke: none); rect((Y(12.9), 0), (Y(13.0), 3.32), fill: blue, stroke: none); T((Y(13.3), 2.5), [living glass · fixed], size: 2.7pt, fill: white, angle: 90deg)
    rect((Y(w.box.at(1)), 0), (Y(w.box.at(3)), w.rim), fill: rgb("#c9a86a"), stroke: 0.4pt + ink); rect((Y(w.box.at(1)) + 0.15, w.rim - 0.1), (Y(w.box.at(3)) - 0.15, w.level), fill: water, stroke: none); line((Y(8.8), w.level), (Y(8.8), w.level + w.fall), stroke: 1.2pt + blue); T((Y(8.8), w.rim + 0.5), [basin · rim #f2(w.rim) · water #f2(w.level) · a bubbler #r2(w.fall)], size: 2.8pt)
    for f in o.furn { if f.at(4).contains("sofa") { rect((Y(f.at(1)), 0), (Y(f.at(3)), 0.85), fill: rgb("#b48a5a"), stroke: 0.3pt + ink); T((Y((f.at(1) + f.at(3)) / 2), 1.05), [#f.at(4)], size: 2.8pt) } }
    // the winter noon sun on the winter sofa's sitter
    let k = calc.tan(46.9deg)
    line((Y(13.0), 7.3 - 2.7), (Y(13.0) - (7.3 - 2.7) / k * 0 - 7.0, 7.3 - 2.7 - 7.0 * k * 0), stroke: none)
    line((Y(12.9) + 0.0, 4.6), (Y(6.6) + 0.2, 4.6 - (12.9 - 6.6 - 0.2) * k), stroke: (paint: amber, thickness: 0.9pt, dash: "dashed")); T((Y(9.0), 3.0), [January noon ray (46.9°) over the living's roof: lights the north wall above +0.46 and the winter sofa's sitters], size: 2.7pt, fill: amber, angle: -32deg)
    circle((Y(olive.cy), 2.85), radius: 1.0, fill: leaf.transparentize(60%), stroke: (paint: leaf.darken(20%), dash: "dashed", thickness: 0.4pt)); T((Y(olive.cy), 2.85), [olive (beyond)], size: 2.7pt)
    line((Y(6.0), 1.15), (Y(13.5), 1.15), stroke: (paint: gray, thickness: 0.4pt, dash: "dotted"))
    T((Y(9.75), 4.3), [H3 · N–S section through the basin (looking west) · 1 m = 0.72 cm], size: 3.2pt, fill: green)
  }
})

#pagebreak()
#text(14pt, weight: "bold", fill: green)[Phase 3 · three layouts within the open items · the owner's answers built in]
#v(1pt)
#text(7.2pt, fill: gray)[In every option: the living's glass fixed and the riwaq's sliding door the only door; a curtain inside the women's majlis; the water a calm, audible fall with a skimmer; the olive in its fixed Ø 1.0 pot at the seating group's south-west corner (x 6.0–7.0, y 11.3–12.3), the built-in planter gone; every seat with a back; the walkway, 0.6 at the living glass, 0.5 at the majlis glass (H3: a movable sofa stands there), 0.6 at the kitchen wall. The jet's axis dashed, its spread shaded; the lanterns amber; the darker floor bands on the glass lines and the colonnade line.]
#v(3pt)
#grid(columns: (1fr, 1fr, 1fr), column-gutter: 5pt, ..opts.map(o => oplan(o)))
#v(3pt)
#grid(columns: (1fr, 1fr, 1fr), column-gutter: 8pt, ..opts.map(o => [
  #text(8.5pt, weight: "bold", fill: green)[#o.name] #text(6.6pt, fill: gray)[#o.sub]
  #set text(6.5pt)
  - *Outlet:* #o.outlet.note
  - *Water:* #o.water.kind
  - *Seats (#seats-of(o.furn)):* #o.furn.filter(f => f.at(4) != "table").map(f => [#f.at(4) facing #f.at(5)]).join([, ]); the table #r2(o.furn.last().at(2) - o.furn.last().at(0)) × #r2(o.furn.last().at(3) - o.furn.last().at(1)) under the olive's head.
  - *Light:* #o.light
  - *Floor:* #o.floor
  - *Planting:* #o.plants
  - *Changes outside the courtyard:* #o.outside
]))

#pagebreak()
#text(12pt, weight: "bold", fill: green)[Phase 3 · the sections · the ideas for the owner (winter sun and more sky: bold, touching locked items)]
#v(3pt)
#grid(columns: (1fr, 1fr, 1fr), column-gutter: 5pt, ..opts.map(o => [#osec(o) #v(1pt) #text(6.3pt, fill: gray, o.sec-note)]))
#v(4pt)
#let ideas = (
  ([I1 · a sun reflector on the living's roof edge], [a polished aluminium "sun shelf" ≈ 3.0 × 0.8 m on the south roof edge (y 13, +7.4), tilted ≈ 23°: it throws the January noon sun (46.9°) down onto the courtyard's floor and the seats as a soft reflected patch (≈ 25–35 % of direct sun, #A[assumed]); summer: tilted flat or removed], [none of the locked items; the roof's guard and parapet detail; glare checked from the gallery; cleaned yearly], [cheap; the only idea that puts winter light on the seats without opening a roof; it does not widen the sky]),
  ([I2 · open the living's double-height bay to the sky (a second court)], [the roof over the living's double-height half (x 4.25–8.95, y 13.0–16.1, 14.6 m²) removed: the courtyard becomes 4.7 × 9.6 m on axes with the south wall at y 16.1; the January noon shadow (0.936 × 7.3 = 6.8 m) then ends at y 9.3: *every seat south of y 9.3 is in the winter noon sun*, the sky slot 3.15 × 9.6], [LOCKED: the living loses its double height and its clerestories (R-24's "one living room, two heights" since V3), W3, the roof edge R2 and the slab bay over the void (structure), the TV wall's upper part, the suite court above? (no: the suite court is over the men's majlis); the living's glass becomes an outer wall; drainage of a second open floor], [the biggest gain for the winter and the sky, the biggest loss for the house; a different house]),
  ([I3 · drop the south wall's top to +3.6 only over the courtyard's width (a roof terrace over the living's void)], [the living's double-height roof stays over the living, but its north edge is pulled back 2.0 m (y 13 → 15): the strip y 13–15 over the void becomes an open terrace of the suite court's level… no: the void has no first floor; the strip would be a roofless slot inside the living], [LOCKED: the living's void and roof; a slot open to the sky inside a room is not a room], [not workable: struck]),
  ([I4 · lower the gallery projection (the west side) to the first floor], [the gallery's roof over the projection removed, the gallery open to the sky as a first-floor loggia: the west wall of the slot drops from +7.3 to +3.6 (the guard); the afternoon sun from the south-west (January 15:00, 33°) still falls on the kitchen wall, not the floor (the shadow of +3.6 reaches 5.5 m east); the sky slot's west side opens: sky view ≈ 12 % instead of 7 %], [LOCKED: the gallery (the family's corridor) loses its roof and its W1 windows: it becomes an open walkway in a Taif winter and dust; the roof slab over the projection (R1 / R3 / B3 upstand), the bedrooms' doors onto an open gallery], [more sky, no winter sun; the gallery's loss is severe: not recommended]),
  ([I5 · the family living above the women's majlis pulled back], [the north wall (the family living's W2 wall, +7.3) could not help: the sun never comes from the north; only the slot's width matters, and it is fixed by the projection (west) and the kitchen wall (east)], [—], [no gain: struck]),
  ([I6 · the winter haven elsewhere; the courtyard the summer haven], [accept the well: the courtyard is the breeze, water and shade room for March–October; the *suite court* (first floor, open to the sky, 25 m², the parapet frame on its south) or the *roof terrace inside the attic* is the family's winter sun room (the suite court faces south over the men's majlis roof; the January noon sun stands 47° above it: fully sunlit), with its own simple seating], [none of the locked items (the suite court's furniture and the attic terrace already exist in the plan); the family's habit, two places instead of one], [honest and free; with I1 for the courtyard's winter light]),
)
#grid(columns: (1.2fr, 1fr), column-gutter: 10pt,
  [
    #H[Ideas for the owner · winter sun and more sky (touching locked items: listed, not drawn)]
    #table(columns: (0.9fr, 1.7fr, 1.5fr, 0.8fr), inset: 2.1pt, stroke: 0.4pt + luma(178), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      [*Idea*], [*What*], [*Knock-on effects (the locked items)*], [*Verdict*],
      ..ideas.map(((a, b, c, d)) => (text(6.4pt, weight: "bold", a), text(6.2pt, b), text(6.2pt, c), text(6.2pt, d))).flatten())
    #v(2pt)
    #text(6.4pt, fill: gray)[The geometry behind it: the January noon sun stands 46.9° high in the south; a wall H high throws a shadow 0.936 H long northwards. The seats are 1.65–2.5 m north of the living's wall (7.3 m): only a wall ≤ 2.3 m high there would let the noon sun on them — that is the living's roof. The slot's width (3.15 m) is set by the projection and the kitchen wall. So within the house as decided, the winter sun on the courtyard's floor is impossible; the reflector (I1) borrows it, the suite court (I6) has it.]
  ],
  [
    #H[What the three options do with the three big mistakes]
    - *The winter sun (1):* none of the layouts brings direct sun to the floor; *H3 alone* seats two people in it (the winter sofa with its back to the majlis glass: the body in the sun ≈ 11:30–13:30 from November to February, the curtain behind them). With I1 (the reflector) H1 and H2 get a reflected patch too.
    - *The deep well (2):* all three lighten it the same way: the light sand render, the olive's head in the slot, the darker floor bands that pull the eye down, the lanterns at night, the water's sound; H3's basin in the middle makes the floor the room's centre instead of the walls.
    - *The air in the faces (3):* H1 keeps the low outlet and sends the jet along the floor (the breeze at the legs, ≈ 0.5 m/s at the sofa, #A[assumed]); H2 raises and turns it over the water (≈ 0.6 m/s on the whole body, cooler); H3 skims the basin with the low jet (≈ 0.5 m/s, a little cooler) and keeps it off the winter sofa.
    - *Seats:* H1 5 · H2 5 · H3 6 (the owner asked for 5–6, every one with a back).
    - *The water's sound:* H1 a 0.45 fall, H2 0.40, H3 a bubbler: all audible from the seats (a fall ≥ 0.3 m into open water ≈ 45–50 dB(A) at 2 m, #A[assumed]).
    - *Phase 4* scores all three against the 22 checks, the clear area, the seats, the relative cost and the files, and recommends.
    #v(2pt)
    #text(7.5pt)[*Phase 3 complete:* three layouts drawn (plans and sections), six ideas for the owner listed (two struck).]
  ],
)

// ====================================================================== PHASE 4 · THE COMPARISON SHEET (H2 chosen by the owner; H1 and H3 as reference) · the suite court as the winter sun room · the Arabic summary
#let P4 = text(fill: green, weight: "bold")[✓]; #let F4 = text(fill: red, weight: "bold")[✗]; #let M4 = text(fill: amber, weight: "bold")[~]
#let score = (
  ([*Air*], [], [], []),
  ([1 · the breeze over the water / under the tree before the seats], [#P4 59 % of the jet's depth over the trough, under the olive's head], [#F4 along the floor, beside the water], [#M4 skims the basin]),
  ([2 · seats downstream, no jet in the face], [#P4 the sofa 2.0 m off the axis, in the spill ≈ 0.6 m/s], [#M4 the jet below the seated eye, at the legs], [#P4 clear of the winter sofa]),
  ([3 · the head faces the summer evening wind], [#P4 (wind assumed)], [#P4], [#P4]),
  ([4 · hot air can rise out], [#P4 20.5 m² of sky], [#P4], [#P4]),
  ([*Sun and shade*], [], [], []),
  ([5 · summer shade at 16:00 / 18:00 · winter sun at 10:00], [#P4 100 % shaded from 13:30 · #F4 no winter sun (the well)], [#P4 · #F4], [#P4 · #F4]),
  ([6 · the olive shades in summer, lets winter sun in], [#P4 ≈ 3 m² of the seats at the summer noon; winter n/a], [#P4], [#P4]),
  ([*Water*], [], [], []),
  ([7 · moving, heard, safe], [#P4 a 0.40 fall into the trough (≈ 45–50 dB(A) at 2 m, assumed); rim +0.80, 0.35 deep], [#P4 fall 0.45, rim +0.70], [#M4 a bubbler; the low basin +0.45 needs the child mesh]),
  ([8 · leaves in the water], [#P4 the olive 3 m away; a skimmer at the trough's end], [#P4], [#P4]),
  ([9 · roots vs the water, drains, waterproofing], [#P4 the pot; the engineer's note on the 1.2 t], [#P4], [#P4]),
  ([*Use*], [], [], []),
  ([10 · every seat sees the tree or the water], [#P4 the sofa faces the water and the outlet beyond, the armchairs the trough and the olive], [#P4], [#P4]),
  ([11 · conversation < 3.5 m, no back to the group], [#P4 farthest 2.4 m], [#P4], [#M4 the winter sofa 3.6 m from the armchair]),
  ([12 · clearances], [#P4 walkway 0.08 east of the soffit edge · 0.65 living · 2.9 majlis · 0.6 kitchen wall], [#P4], [#M4 the majlis strip given to a movable sofa]),
  ([13 · privacy from the guest route and the majlis], [#P4 the curtain inside the majlis (owner)], [#P4], [#M4 the winter sofa against the majlis glass]),
  ([14 · the guest route never crosses the seating], [#P4], [#P4], [#P4]),
  ([15 · the views in from the living, the majlis, the sink, the gallery], [#P4 the sink sees the trough's rim and the olive beyond; the living sees the sofa's back], [#P4], [#P4]),
  ([*Comfort and calm*], [], [], []),
  ([16 · winter afternoons: sun, shelter], [#F4 no sun (the suite court is the winter room, I6) · #P4 shelter], [#F4 · #P4], [#M4 two seats in the noon sun · #P4]),
  ([17 · night: soft light, no glare], [#P4 the lanterns, the trough's light, the olive up-lit, the wall strip; one dimmer], [#P4], [#P4]),
  ([18 · acoustics: water, fan, echo], [#P4 the fall heard · #P4 the fan inaudible · #M4 the hard well], [#P4 · #P4 · #M4], [#P4 · #P4 · #M4]),
  ([19 · scent and planting without mess], [#P4 the olive, a laurel pot by the outlet, the jasmine], [#P4], [#P4]),
  ([*Proportion and beauty*], [], [], []),
  ([20 · the proportions, the rhythm, the doorways], [#F4 the well (inherent) · #P4 the rhythm · #P4 the olive first from the riwaq door], [#F4 · #P4 · #P4], [#F4 · #P4 · #P4]),
  ([*Build and upkeep*], [], [], []),
  ([21 · drains, power, the malqaf door, cleaning], [#P4 the drains as designed + the pot's saucer pipe; a lighting circuit and two sockets to add; the door clear; the trough skimmed, the floor hosed], [#P4], [#M4 the basin in the floor's middle]),
  ([22 · the cooler option], [#P4 the chamber as designed; through the raised louvres at body height], [#P4 at the legs], [#P4]),
  ([*Totals*], [], [], []),
  ([checks passed · partial · failed], [*18 · 1 · 3* (the three fails are the well and the winter sun: inherent)], [16 · 3 · 3], [15 · 6 · 1]),
  ([clear area · seating zone free], [24.9 m² · 12.1 m² (the trough 2.0 m² deducted → 10.1 free)], [24.9 · 10.4], [24.9 · 10.6]),
  ([seats with backs], [*5* (3 + 1 + 1)], [5], [6]),
  ([relative cost (courtyard works only)], [*1.1*: the outlet raised and turned (the core's wall opening re-formed, the reveals, the fixed louvres), the trough and its pump, the lighting, the pot], [1.0], [1.3 (the basin in the floor, the mesh, the second sofa)]),
  ([files to change], [`air_system.typ` (`air-outlet`), `malqaf_outlet_B.typ` (adopted), the courtyard study, `design_gf.typ`, sheet 02, PENDING; next release: `params.yaml`, the 3D, the DXFs, `plumbing.typ`, `character.yaml`], [the louvres' angle + the yaml, plumbing, 3D], [as H1 + the basin, the north strip, the yaml]),
)
#pagebreak()
#text(14pt, weight: "bold", fill: green)[Phase 4 · H2 chosen by the owner, scored against the 22 checks · H1 and H3 as reference · the suite court as the winter sun room]
#v(1pt)
#text(7.2pt, fill: gray)[The owner (10 Nov 2026): *H2* (the outlet B, the breeze over the water, 5 seats) is the courtyard layout; *no sun reflector* (I1 dropped); *the winter sun-seat is the suite court* (I6): the courtyard the March–October haven, the suite court the family's winter sun room. ✓ pass · ~ partial · ✗ fail.]
#v(3pt)
#grid(columns: (1.55fr, 1fr), column-gutter: 10pt,
  table(columns: (1.1fr, 1.5fr, 0.75fr, 0.75fr), inset: 1.9pt, stroke: 0.4pt + luma(178), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
    [*Check*], [*H2 · chosen*], [*H1 (ref.)*], [*H3 (ref.)*],
    ..score.map(((a, b, c, d)) => if repr(b) == "[]" { (table.cell(colspan: 4, fill: rgb("#dfe9d3"), text(6.4pt, weight: "bold", fill: green, a)),) } else { (text(6.1pt, a), text(6.0pt, b), text(6.0pt, c), text(6.0pt, d)) }).flatten()),
  [
    #H[The suite court as the family's winter sun room (I6) · what it needs]
    - *Where:* the first-floor court between the gym and the office (x 4.25–10.0, y 19.25–24.0, 25.3 m² on axes, floor +3.60, open to the sky), reached from the suite bedroom, the gym and the office; its south side the facade frame on a 1.10 base with the mashrabiya screen (+4.7 … +6.7, ≈ 40 % open) under the frame's top (≈ +7.35); the gym (west) and the office (east) walls 3.7 m above its floor.
    - *The January sun* (NOAA, Taif; the same geometry as Phase 1): at noon (46.9°) the frame's top shades 3.5 m from the south edge, so the *north strip y 19.25–20.5* (the doors' movement strip) is in *direct* sun ≈ 11:30–13:00, and the *middle band y 21.1–23.0* gets the sun *through the screen* (≈ 40 %) ≈ 11:00–14:00; the band at the south base (y 23–24, where the V8.0 sofa stands) is in the base's shadow; before 10:30 the office wall shades the court, after 14:30 the gym wall. *Say ≈ 2 h of direct sun on the north strip and ≈ 3 h of filtered sun on the middle band in January* (#A[the screen's openness and the frame's top height as drawn]).
    - *Seating for the parents:* two armchairs with backs and a small table *in the middle band's north part* (y 20.6–21.4, east of the gym's door line, x 7.0–9.5: out of the doors' strip, in the filtered sun from 11:00 and the direct sun's edge at noon), cushions stored inside; the V8.0 sofa at the south base stays for the summer evenings (shaded). *Nothing structural.*
    - *One small, non-structural improvement to consider:* the screen's middle panels made to *open in winter* (hinged or sliding lattice panels within the same frame): the middle band then gets the direct noon sun (46.9° clears the 1.10 base from y 22.8 northwards) and closes again for the summer and the palms' view; the design language's mashrabiya unchanged.
    - *Also:* a tap and a drain exist (the box gutter); a socket pair and a wall light by the office door (MEP); the guards as designed.
    #H[Verdict]
    - *H2* fixes everything the open items can fix: the breeze over the water and under the olive on the whole body (no jet in the face), the audible fall, the leaves and the roots settled, five seats with backs facing the water, the clearances kept, the lighting and the floor designed. Its three fails are the well and the winter sun, which the house's form sets; the owner answers them with the suite court in winter.
    - *Phase 4 complete; waiting for the owner's "apply".* Then LEAN: the ground-floor plan, the courtyard study, the air study's outlet values, `studies/malqaf_outlet_B.typ` committed as adopted, the presentation's sheet 02 and its note, `PENDING_CHANGES.md`; the 3D, the DXFs, `params.yaml` and `plumbing.typ` listed for the next release.
  ],
)

#pagebreak()
#text(14pt, weight: "bold", fill: green)[الفناء ملاذ العائلة · خلاصة الدراسة للمالك وزوجته]
#v(4pt)
#block(fill: rgb("#f1efe8"), inset: 8pt, radius: 3pt, width: 100%)[
  #set text(lang: "ar", dir: rtl, size: 8.4pt)
  #set par(leading: 0.6em)
  *ما وجدناه (المرحلتان 0 و1):* الفناء اليوم على شكل L بمساحة 27.19 م² على المحاور ونحو 24.9 م² صافيا، مفتوح للسماء بفتحة 3.15 × 6.5 م بين جدران ارتفاعها 7.3 م: *بئر عميق* (النسبة 1 : 2.3، وما يُرى من السماء من المقعد نحو 7 % فقط)، ولذلك *لا تصل شمس الشتاء إلى أي مقعد من أكتوبر إلى فبراير*، بينما تُظلَّل الجلسة في الصيف من الساعة 1:30 ظهرا، وهذا جيد. مخرج الملقف المنخفض كان يرمي الهواء *في وجوه الجالسين* ولا يمر فوق الماء ولا تحت الشجرة. الشجرة كانت ملاصقة للماء (ورقها يسقط فيه) وحوضها المبني صغير وخطر على الصرف والعزل. مجلس النساء يطل على الجلسة بزجاج ثابت بلا ستارة. الماء صامت. الإضاءة والكهرباء لم تُصمَّما بعد. الصالة لا باب لها على الفناء.
  #v(3pt)
  *قرارات المالك:* زجاج الصالة يبقى ثابتا وباب الرواق المنزلق هو باب الفناء؛ ستارة داخل مجلس النساء؛ الماء يسقط سقوطا هادئا مسموعا مع مصفاة لورق الشجر؛ *شجرة زيتون في أصيص كبير ثابت* (قطر 1.0 م وعمق 0.8 م، وزنه نحو 1.2 طن: ملاحظة للمهندس) في الركن الجنوبي الغربي للجلسة عند حافة الرواق، بعيدا عن الماء بثلاثة أمتار، ورأسها يظلل الطاولة وأطراف الكنب في ظهيرة الصيف؛ لا عاكس للشمس؛ *فناء الجناح في الدور الأول هو غرفة شمس الشتاء للعائلة*، والفناء ملاذ الصيف من مارس إلى أكتوبر.
  #v(3pt)
  *التخطيط المختار H2 · النسيم فوق الماء:* يُرفع مخرج الملقف إلى +0.60…+1.60 ويُوجَّه بشيش ثابت وعضادات مائلة 30° نحو الماء، فيمر الهواء *فوق حوض الماء وتحت رأس الزيتونة* ثم يرتد عن جدار المطبخ على الجلسة بنحو 0.6 م/ث على الجسم كله، لا في الوجه، وأبرد قليلا. *الماء* حوض طويل 2.1 × 0.95 م على جدار المطبخ تحت نافذة المغسلة، فيه مسقط هادئ مسموع بارتفاع 0.40 م ومصفاة في طرفه ومضخة في حجرة جافة. *الجلسة:* كنبة بثلاثة مقاعد تواجه الماء والزيتونة ومخرج الملقف، وكرسيان بظهر، وطاولة منخفضة تحت رأس الزيتونة: خمسة مقاعد كلها بظهر؛ ممر الأعمدة وشرائط التنظيف عند الزجاج (0.6 م عند الصالة، 0.5 م عند المجلس، 0.6 م عند جدار المطبخ) خالية. *الإضاءة:* الفانوسان تحت السقف، ضوء دافئ تحت مسقط الماء، إضاءة من الأرض على الزيتونة، شريط ضوء خلف الياسمين على جدار المطبخ؛ مفتاح واحد عند باب الرواق ومخفّت. *الأرضية:* بورسلان رملي مع إطار بلون العسل حول الجلسة ودائرة الأصيص. *النبات:* الزيتونة، وأصيص غار قرب المخرج (رائحة)، وياسمين على سلك على جدار المطبخ.
  #v(3pt)
  *النتيجة على الفحوص الاثنين والعشرين:* H2 ينجح في 18، وجزئي في 1 (صدى البئر)، ويرسب في 3 هي البئر وشمس الشتاء، وهذه من شكل البيت نفسه (الجدران غرف)، وقد أجاب عنها المالك بفناء الجناح شتاءً. الكلفة النسبية 1.1 (رفع المخرج وتوجيهه، الحوض ومضخته، الإضاءة، الأصيص).
  #v(3pt)
  *فناء الجناح غرفة الشتاء:* في يناير تصل الشمس المباشرة إلى شريطه الشمالي نحو ساعتين حول الظهر، وتمر عبر المشربية الجنوبية (نحو 40 % منها) على وسطه نحو ثلاث ساعات؛ يُقترح كرسيان بظهر وطاولة صغيرة للوالدين في وسطه الشمالي، ولا شيء إنشائي؛ ويمكن جعل ألواح المشربية الوسطى تُفتح شتاءً لتدخل شمس الظهر كاملة.
  #v(3pt)
  *أفكار جريئة عُرضت ولم تُعتمد:* عاكس شمس على حافة سقف الصالة (أُسقط)، فتح جزء الصالة ذي الارتفاع المزدوج على السماء (بيت آخر)، إزالة سقف بروز الممر العلوي (خسارة الممر)؛ والخلاصة أن شمس الشتاء على أرض الفناء مستحيلة في البيت كما تقرر، وغرفة الشتاء في فناء الجناح.
  #v(3pt)
  *بعد موافقة المالك ("apply"):* يُطبَّق H2 على مخطط الدور الأرضي ودراسة الفناء وقيم مخرج الملقف في دراسة الهواء ولوحة الدور الأرضي في العرض؛ ويُدرج المجسّم ومخططات الكاد والسباكة للإصدار القادم.
]

// courtyard_haven.typ · Taif / Palm House V10.0 · THE COURTYARD AS THE FAMILY'S HAVEN · a study in phases (the owner's brief of 10 Nov 2026) · STUDY ONLY:
// nothing in the design files changes until the owner chooses an option after Phase 4. PHASE 0: the facts, cited file by file, every assumption marked.
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

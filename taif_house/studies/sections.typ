// sections.typ · Taif / Palm House V7.0 · levels, the west projection, the light check and the two sections (imported, not compiled on its own)
// Used by design_ff.typ and presentation.typ. Geometry is read from ../data/rooms_ff.csv, ../design_gf.typ (placement, outline), ff_family.typ
// (the projection edge and the columns) and ff_suite.typ (windows); the only fixed numbers are the levels below (to confirm with the engineer)
// and the record of the split projection studied in V5.1–V6.0 and reverted in V6.1 (git tag v6.0, branch v5-split-projection).
// CSV coordinates (metres): x east, square to the M line, origin = the ground floor's west wall centre line; y south.
#import "@preview/cetz:0.4.2"
#import "../design_gf.typ": shift, outline-csv-gf
#import "ff_family.typ" as fam
#import "ff_suite.typ" as suite

// ---------- Levels and walls (concept, to confirm) ----------
#let ff-level = 3.6          // floor-to-floor height
#let roof-level = 7.2
#let slab = 0.25
#let parapet = 1.1
#let outer-half = 0.125      // ½ of the 250 mm outer wall
#let inner-half = 0.1        // ½ of a 200 mm wall
#let rail-half = 0.025       // ½ of a ≈ 50 mm railing on the void edge (the reverted split projection)
#let frame-half = 0.03       // ½ of the steel window frame W1 on the gallery edge (V7.0, enclosure A)
#let coping-top = 7.65       // V7.0 roofline (studies/roof.typ): the north block's facade top (the main cornice +6.90 … +7.35 and its coped upstand)
#let attic-top = 9.1         // the attic screen's coping, set back 1.0 m from the facade face (0.875 from the wall centre lines)
#let attic-in = 0.875
#let south-parapet = 8.4     // the south wing's parapet top
#let guard = 1.1             // the bar guards round the roof holes
#let w1 = (sill: 3.82, head: 6.60)   // W1 on the gallery edge, on the upstand of B3; V7.1: arched windows 1.60 wide, springing +5.80, crown +6.60
#let col-half = 0.15         // ½ of a column (drawing only; size by the engineer)
#let m-line = -shift.at(0)   // the M line in CSV x

// ---------- The west projection, read from the room data and the family study ----------
#let parse-pts(s) = s.split(";").map(t => t.trim()).filter(t => t != "").map(t => { let v = t.split(" ").filter(u => u != ""); (float(v.at(0)), float(v.at(1))) })
#let area(P) = calc.abs(range(P.len()).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, P.len())); a.at(0) * b.at(1) - b.at(0) * a.at(1) }).sum()) / 2
#let ff = csv("../data/rooms_ff.csv", row-type: dictionary).filter(r => r.name != "" and not r.name.starts-with("#")).map(r => (name: r.name, colour: r.colour, P: parse-pts(r.pts)))
#let P-of(n) = ff.find(r => r.name == n).P
#let xs(n) = P-of(n).map(p => p.at(0))
#let ys(n) = P-of(n).map(p => p.at(1))
#let x-court = 4.25                                                            // GF courtyard / living west edge (riwaq east wall)
#let x-east = 8.95                                                             // GF courtyard / living east edge
#let pj-edge = calc.max(..xs("Upper gallery (on the west projection)"))        // the projection's edge (edge beam)
#assert(calc.abs(pj-edge - fam.proj-x) < 1e-6, message: "ERROR: the gallery edge in data/rooms_ff.csv and proj-x in studies/ff_family.typ differ.")
#let ff-west = calc.min(..ff.map(r => calc.min(..r.P.map(p => p.at(0)))))      // FF west wall
#let pj-wall = calc.max(..xs("Bedroom 2"))                                      // rooms / gallery wall
#let y-court = calc.min(..ys("Upper gallery (on the west projection)").filter(y => y > 3))   // the courtyard's north edge (projection start)
#let y-living = calc.max(..ys("Upper gallery (on the west projection)"))        // the living's south wall (projection end)
#let y-gym = calc.max(..ys("Suite court (open to the sky)"))                  // the gym's south arm north wall = the suite court's south edge (y 21.9 since 1 Nov 2026)
#let arm-x = calc.max(..xs("Suite court (open to the sky)"))                    // the office's west wall = the court's east edge (x 10.0 since 1 Nov 2026)
#let columns = fam.columns
#let ff-outline = outline-csv-gf                                                // the first floor stands on the ground-floor walls
#let pj-void = (x-east - pj-edge) * (y-living - y-court)
#let spans = range(columns.len() - 1).map(i => columns.at(i + 1).at(1) - columns.at(i).at(1))
#let pj = (
  depth: pj-edge - x-court, sky: x-east - pj-edge, sky-clear: x-east - pj-edge - 2 * inner-half,
  room: pj-wall - ff-west, room-clear: pj-wall - ff-west - outer-half - inner-half, gallery: pj-edge - pj-wall, gallery-clear: pj-edge - pj-wall - inner-half - frame-half,
  m-gap: ff-west - m-line - outer-half, columns: columns.len(), col-x: pj-edge, spans: spans,
  outline: area(ff-outline), void: pj-void, floor: area(ff-outline) - pj-void,
  indoor: ff.filter(r => r.colour not in ("open", "terrace")).map(r => area(r.P)).sum(), court: ff.filter(r => r.colour in ("open", "terrace")).map(r => area(r.P)).sum(),
  circ: ff.filter(r => r.colour == "circ").map(r => area(r.P)).sum(), bath: area(P-of("Family bath")), bath-w: calc.max(..xs("Family bath")) - calc.min(..xs("Family bath")),
  gym: area(P-of("Gym")), niche: area(P-of("Wardrobe niche (bedroom 2)")),
)

// ---------- Record: the split projection studied in V5.1–V6.0 and reverted in V6.1 (git tag v6.0) ----------
#let split = (
  inward: 0.675, outward: 0.675, sky: 4.025, room: 4.25, gallery: 1.35, m-gap: 0.11, outline: 318.86, void: 51.32, floor: 318.86 - 51.32,
  indoor: 226.97, court: 16.77, circ: 43.90, bath: 3.74, bath-w: 2.075, gym: 26.77, niche: 1.31, cant-wall: 14.95,
)

// ---------- Comparison table: the projection on columns against the reverted split projection (gym and suite court left out: the V6.2 L-shaped gym changes them) ----------
#let r2(v) = str(calc.round(v, digits: 2))
#let r3(v) = str(calc.round(v, digits: 3))
#let f2(v) = { let s = str(calc.round(v, digits: 2)); if not s.contains(".") { s + ".00" } else if s.split(".").at(1).len() == 1 { s + "0" } else { s } }   // levels: +3.60
#let dv(a, b, unit: "") = { let d = b - a; if calc.abs(d) < 0.005 { [=] } else { [#if d > 0 [+] else [−]#r3(calc.abs(d))#unit] } }
#let rows = (
  ([Courtyard sky opening, axes (≈ clear)], [#r3(split.sky) (#r3(split.sky - 2 * inner-half)) m], [#r3(pj.sky) (#r3(pj.sky-clear)) m], dv(split.sky, pj.sky)),
  ([Double-height void width, axes], [#r3(split.sky) m], [#r3(pj.sky) m], dv(split.sky, pj.sky)),
  ([West room width, axes (≈ clear)], [#r2(split.room) (#r3(split.room - outer-half - inner-half)) m], [#r2(pj.room) (#r3(pj.room-clear)) m], dv(split.room, pj.room)),
  ([Gallery width, axes (≈ clear)], [#r2(split.gallery) (#r3(split.gallery - inner-half - rail-half)) m], [#r2(pj.gallery) (#r3(pj.gallery-clear)) m], dv(split.gallery, pj.gallery)),
  ([Columns in the courtyard / living], [none · #r3(split.inward) m cantilever], [*#pj.columns* on x #r2(pj.col-x) + edge beam], [+#pj.columns]),
  ([FF west face → M line], [#r2(split.m-gap) m (approval needed)], [*#r3(pj.m-gap) m* (on the GF wall)], dv(split.m-gap, pj.m-gap, unit: " m")),
  ([Walls on cantilever beams], [FF west wall, #r2(split.cant-wall) m], [none], [−]),
  ([FF outline (axes)], [#r2(split.outline) m²], [#r2(pj.outline) m²], dv(split.outline, pj.outline, unit: " m²")),
  ([Courtyard sky + double-height void], [#r2(split.void) m²], [#r2(pj.void) m²], dv(split.void, pj.void, unit: " m²")),
  ([FF floor (outline − voids)], [#r2(split.floor) m²], [#r2(pj.floor) m²], dv(split.floor, pj.floor, unit: " m²")),
  ([· family bath], [#r2(split.bath) m² (#r3(split.bath-w) wide)], [#r2(pj.bath) m² (#r2(pj.bath-w) wide)], dv(split.bath, pj.bath, unit: " m²")),
)
#let compare-table(size: 7.4pt, head-fill: rgb("#e4eedf"), band: rgb("#f1efe8")) = {
  set text(size)
  table(columns: (auto, 1fr, 1fr, auto), stroke: none, inset: 3pt, fill: (_, y) => if y == 0 { head-fill } else if calc.even(y) { band },
    [*Item*], [*Split projection (V5.1–V6.0, reverted)*], [*V6.2 · 1.35 m inward on columns*], [*Change*],
    ..rows.flatten())
}

// ---------- Light check of the double-height living's clerestory windows (section through the middle band) ----------
#let latitude = 21.4                                  // Taif, degrees north
#let w-alt = 90 - latitude - 23.44                    // winter solstice noon sun altitude (from the south)
#let e-alt = 90 - latitude                            // equinox noon
#let s-alt = 90 - latitude + 23.44                    // summer solstice noon (> 90: slightly to the north)
#let clerestory = suite.windows.filter(((a, b)) => calc.abs(a.at(1) - y-living) < 1e-6 and calc.abs(b.at(1) - y-living) < 1e-6 and a.at(0) > pj-edge and b.at(0) < x-east)
#let cl-sill = 5.0
#let cl-head = 6.0
#let cl-size = (clerestory.first().at(1).at(0) - clerestory.first().at(0).at(0), cl-head - cl-sill)
#let strip = y-gym - y-living                         // the suite court's depth in front of the windows
#let eye = (16.1, 1.2)                                // seated eye in the middle of the double-height living (y, height)
#let ang(p, q) = calc.atan((q.at(1) - p.at(1)) / (q.at(0) - p.at(0))).deg()
#let sun-share(top, deg) = calc.clamp((cl-head - (top - strip * calc.tan(deg * 1deg))) / (cl-head - cl-sill), 0, 1)
#let sky-share(top) = {
  let a-sill = ang(eye, (y-living, cl-sill)); let a-head = ang(eye, (y-living, cl-head)); let a-obs = ang(eye, (y-living + strip, top))
  calc.clamp((a-head - calc.max(a-sill, a-obs)) / (a-head - a-sill), 0, 1)
}
#let pc(v) = str(calc.round(v * 100)) + " %"
#let cases = (
  (label: [gym roof edge with a #r2(parapet) m parapet (top +#f2(roof-level + parapet))], top: roof-level + parapet, chosen: false),
  (label: [gym roof edge with a railing only (solid top +#f2(roof-level)) · *V6.2*], top: roof-level, chosen: true),
)
#let arm-gap = arm-x - calc.max(..clerestory.map(((a, b)) => b.at(0)))   // the office wall stands this far east of the east clerestory window
#let light = (winter: sun-share(roof-level, w-alt), equinox: sun-share(roof-level, e-alt), sky: sky-share(roof-level),
  winter-parapet: sun-share(roof-level + parapet, w-alt), sky-parapet: sky-share(roof-level + parapet))
#let light-table(size: 7.5pt) = {
  set text(size)
  table(columns: (auto, auto, auto, auto), stroke: none, inset: 3pt, fill: (_, y) => if calc.even(y) { rgb("#efece4") },
    [*Behind the #r2(strip) m suite court*], [*Winter noon sun on the windows*], [*Equinox noon sun*], [*Sky seen from the eye*],
    ..cases.map(c => ([#c.label], [#pc(sun-share(c.top, w-alt))], [#pc(sun-share(c.top, e-alt))], [#pc(sky-share(c.top))])).flatten())
}
#let light-note = [*How the percentages are defined.* "Sun on the windows": the share of the window height (sill +#f2(cl-sill) to head +#f2(cl-head)) that receives direct sun at solar noon on 21 Dec (winter) or 21 Mar / 23 Sep (equinox) in this section; the ray from each point of the window must pass over the top of the gym's north wall #r2(strip) m away. "Sky seen": from a seated eye #r2(eye.at(1)) m high in the double-height living (CSV y #r2(eye.at(0))), the share of the windows' vertical angle that shows sky rather than the gym. Pure geometry: no reflections, no sky model; a daylight simulation comes later.]

// north–south section through the middle band (x ≈ 7.3), looking west
#let ns-section(length: 0.6cm, ink: rgb("#3d4a45"), warn: rgb("#b5452f")) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, body, size: 6pt, fill: ink, anchor: "center") = content(p, anchor: anchor, text(size, fill: fill, body))
  let wall-top = coping-top
  line((-1.5, 0), (30, 0), stroke: 1pt + ink)
  rect((0, 0), (y-court, ff-level), fill: rgb("#f6e3c0"), stroke: 0.6pt + ink); T((y-court / 2, ff-level / 2), [Women's majlis (GF)])
  rect((0, ff-level), (y-court, roof-level), fill: rgb("#fbf2e2"), stroke: 0.6pt + ink); T((y-court / 2, (ff-level + roof-level) / 2), [Kids' room / family living (FF)])
  line((0, roof-level), (0, wall-top), stroke: 0.6pt + ink); line((y-court, roof-level), (y-court, roof-level + guard), stroke: (paint: ink, thickness: 0.6pt, dash: "dotted"))
  rect((attic-in - 0.1, roof-level), (attic-in + 0.1, attic-top), fill: ink, stroke: none); T((attic-in + 0.25, roof-level + 1.2), [attic +#f2(attic-top)], size: 4.6pt, anchor: "west")
  rect((y-living - 0.1, roof-level), (y-living + 0.1, attic-top), fill: ink, stroke: none); T((y-living - 0.25, roof-level + 1.2), [attic +#f2(attic-top)], size: 4.6pt, anchor: "east")
  let y-dh = 13.0
  T(((y-court + y-dh) / 2, 1.5), [COURTYARD · open to the sky], fill: rgb("#2f5f8a"))
  rect((y-dh, 0), (y-living, roof-level), fill: rgb("#fbf2e2"), stroke: 0.6pt + ink)
  line((y-dh, 0.9), (y-dh, 6.6), stroke: 3pt + rgb("#7fb8d0"))
  T((y-dh + 0.3, 0.6), [main light: courtyard glazing], size: 5.3pt, fill: rgb("#2f5f8a"), anchor: "west")
  T((eye.at(0), 4.4), [Living (double height)])
  line((y-dh, roof-level), (y-dh, roof-level + guard), stroke: (paint: ink, thickness: 0.6pt, dash: "dotted"))
  line((y-living, cl-sill), (y-living, cl-head), stroke: 3pt + rgb("#1f7a99"))
  T((y-living - 0.15, cl-head + 0.6), [#clerestory.len() windows #r2(cl-size.at(0)) × #r2(cl-size.at(1)) · sill +#f2(cl-sill) · head +#f2(cl-head)], size: 5.3pt, fill: rgb("#1f7a99"), anchor: "east")
  rect((y-living, 0), (24, ff-level), fill: rgb("#e9d9c4"), stroke: 0.6pt + ink); T(((y-living + 24) / 2, ff-level / 2), [Men's majlis (GF)])
  line((y-living, ff-level), (y-gym, ff-level), stroke: 2pt + rgb("#e0c060")); T(((y-living + y-gym) / 2, ff-level + 0.35), [suite court #r2(strip) m], size: 5pt)
  rect((y-gym, ff-level), (24, roof-level), fill: rgb("#cfe3f3"), stroke: 0.6pt + ink); T(((y-gym + 24) / 2, (ff-level + roof-level) / 2), [Gym (FF)])
  line((y-gym, roof-level), (y-gym, roof-level + guard), stroke: (paint: warn, thickness: 0.8pt, dash: "dotted")); line((24, roof-level), (24, south-parapet), stroke: 0.6pt + ink); T((23.8, south-parapet + 0.3), [parapet +#f2(south-parapet)], size: 4.6pt, anchor: "east")
  T(((y-gym + 24) / 2, wall-top + 0.3), [railing (not a parapet)], size: 5pt, fill: warn)
  circle(eye, radius: 0.12, fill: ink); T((eye.at(0), eye.at(1) - 0.4), [eye +#f2(eye.at(1))], size: 5pt)
  for h in (cl-sill, cl-head) { line(eye, (eye.at(0) + (y-living - eye.at(0)) * 2.0, eye.at(1) + (h - eye.at(1)) * 2.0), stroke: (paint: luma(150), thickness: 0.5pt, dash: "dotted")) }
  let ray(y0, h0, deg, len, col, dash) = line((y0, h0), (y0 + len * calc.cos(deg * 1deg), h0 + len * calc.sin(deg * 1deg)), stroke: (paint: col, thickness: 0.9pt, dash: dash))
  ray(y-living, cl-sill, w-alt, 6, rgb("#d08a00"), "solid"); ray(y-living, cl-head, w-alt, 6, rgb("#d08a00"), "solid")
  T((y-living + 6.3, cl-head + 4.6), [winter noon #calc.round(w-alt, digits: 1)° · #pc(light.winter) sun], fill: rgb("#d08a00"), anchor: "west")
  ray(y-living, cl-sill, e-alt, 6, rgb("#c25b00"), "dashed")
  T((y-living + 1.4, cl-sill + 6.2), [equinox #calc.round(e-alt, digits: 1)°], fill: rgb("#c25b00"), anchor: "west")
  line(((y-court + y-dh) / 2, 0.2), ((y-court + y-dh) / 2 - 0.3, 9.5), stroke: (paint: rgb("#e0b000"), thickness: 0.9pt))
  T(((y-court + y-dh) / 2, 9.9), [summer noon: almost overhead (#calc.round(180 - s-alt, digits: 1)° from the north)], fill: rgb("#b08a00"))
  for (h, l) in ((0, [±0.00 GF]), (ff-level, [+#f2(ff-level) FF]), (roof-level, [+#f2(roof-level) roof])) {
    line((-1.2, h), (-0.2, h), stroke: 0.5pt + gray); T((-1.3, h), l, size: 5.5pt, fill: gray, anchor: "east")
  }
  T((0, -0.6), [N], anchor: "north-west"); T((24, -0.6), [S], anchor: "north-east")
})

// ---------- East–west sections (looking north) ----------
// cut: "court" (y 12.0: bedroom 2 / gallery / courtyard / suite) or "living" (y 16.5: bedroom 3 / gallery / double-height living / suite bedroom)
#let section(cut, length: 0.5cm, ink: rgb("#3d4a45"), sky: rgb("#2f5f8a"), red: rgb("#b5452f")) = cetz.canvas(length: length, {
  import cetz.draw: *
  let court = cut == "court"
  let wall(x, y0, y1, t) = rect((x - t / 2, y0), (x + t / 2, y1), fill: ink, stroke: none)
  let fillc = rgb("#f6e3c0")
  let T(p, body, size: 5pt, fill: ink, anchor: "center") = content(p, anchor: anchor, text(size, fill: fill, body))
  // ground, M line
  line((-2.4, 0), (14.4, 0), stroke: 1pt + ink)
  line((m-line, -0.6), (m-line, 9.2), stroke: (paint: red, thickness: 0.7pt, dash: "dash-dotted"))
  T((m-line - 0.1, 9.45), [M line], fill: red, anchor: "east")
  // GF rooms
  rect((0, 0), (2.75, ff-level - slab), fill: rgb("#d9e6ec"), stroke: none)
  rect((2.75, 0), (x-court, ff-level - slab), fill: rgb("#f2efe8"), stroke: none)
  rect((x-east, 0), (13.311, ff-level - slab), fill: if court { rgb("#d9e6ec") } else { fillc }, stroke: none)
  if court { rect((x-court, 0), (x-east, 0.05), fill: sky, stroke: none) } else { rect((x-court, 0), (x-east, roof-level - slab), fill: fillc.lighten(40%), stroke: none) }
  rect((x-court, 0), (pj-edge, ff-level - slab), fill: rgb("#f2efe8").transparentize(30%), stroke: none)
  T((1.375, 1.9), if court [hospitality\ kitchen (GF)] else [serving\ passage (GF)])
  T(((2.75 + x-court) / 2, 1.9), [riwaq])
  T(((x-court + pj-edge) / 2, 2.6), [colonnade], size: 4.2pt)
  T(((pj-edge + x-east) / 2, if court { 1.2 } else { 2.4 }), if court [COURTYARD (GF)] else [living · double height], fill: if court { sky } else { ink })
  T((11.1, 1.9), if court [kitchen (GF)] else [living · dining (GF)])
  // GF walls
  wall(0, 0, coping-top, 2 * outer-half); wall(2.75, 0, ff-level - slab, 2 * inner-half); wall(13.311, 0, coping-top, 2 * outer-half); wall(x-east, 0, roof-level, 2 * inner-half)
  wall(attic-in, roof-level, attic-top, 0.2); wall(13.311 - attic-in, roof-level, attic-top, 0.2)   // V7.0: the attic screen, set back 1.0 m from the facade face
  T((attic-in + 0.2, roof-level + 1.0), [attic\ +#f2(attic-top)], size: 4pt, anchor: "west"); T((13.311 - attic-in - 0.2, roof-level + 1.0), [attic\ +#f2(attic-top)], size: 4pt, anchor: "east")
  if court { line((x-court, 0), (x-court, ff-level - slab), stroke: 1.6pt + rgb("#7fb8d0")) } else { wall(x-court, 0, ff-level - slab, 2 * inner-half); T((x-court + 0.15, 2.0), [TV wall · solid (V6.3)], size: 4.2pt, anchor: "west") }
  // the column beyond the cut (on the beam line) and the edge beam
  rect((pj-edge - col-half, 0), (pj-edge + col-half, ff-level - slab - 0.45), fill: luma(170), stroke: 0.5pt + ink)
  rect((pj-edge - col-half, ff-level - slab - 0.45), (pj-edge + col-half, ff-level), fill: ink, stroke: none)
  T((pj-edge, -0.35), [column (beyond) · edge beam], size: 4.2pt, fill: red)
  // FF slab: west band to the projection edge, and the east part
  rect((ff-west - outer-half, ff-level - slab), (pj-edge, ff-level), fill: ink, stroke: none)
  rect((x-east, ff-level - slab), (13.311, ff-level), fill: ink, stroke: none)
  // FF rooms and walls
  rect((ff-west, ff-level), (pj-wall, roof-level - slab), fill: fillc, stroke: none)
  rect((pj-wall, ff-level), (pj-edge, roof-level - slab), fill: rgb("#f2efe8"), stroke: none)
  rect((x-east, ff-level), (13.311, roof-level - slab), fill: rgb("#efe0cf"), stroke: none)
  T(((ff-west + pj-wall) / 2, 5.6), if court [bedroom 2] else [bedroom 3])
  T(((ff-west + pj-wall) / 2, 5.15), [#r2(pj.room) axes · ≈ #r3(pj.room-clear) clear], size: 4.2pt)
  T(((pj-wall + pj-edge) / 2, 5.6), [gallery], size: 4.6pt)
  T(((pj-wall + pj-edge) / 2, 5.2), [#r2(pj.gallery)], size: 4.2pt)
  T((11.1, 5.4), if court [suite lobby · dressing] else [suite bedroom])
  wall(pj-wall, ff-level, roof-level - slab, 2 * inner-half); wall(x-east, ff-level, roof-level, 2 * inner-half)
  if court { line((x-east, roof-level), (x-east, roof-level + guard), stroke: (paint: ink, thickness: 0.8pt, dash: "dotted")) }
  // V7.0 (enclosure A): the gallery edge is a wall with the steel window W1 on the B3 upstand, head at the R11 / R2 soffit
  wall(pj-edge, ff-level, w1.sill, 0.25); wall(pj-edge, w1.head, roof-level - slab, 0.25)
  line((pj-edge, w1.sill), (pj-edge, w1.head), stroke: 2.4pt + rgb("#1f2a30"))
  T((pj-edge + 0.12, w1.head + 0.2), [W1 arched · +#f2(w1.sill) … crown +#f2(w1.head)], size: 4.2pt, anchor: "west")
  // roof
  rect((ff-west - outer-half, roof-level - slab), (pj-edge, roof-level), fill: ink, stroke: none)
  rect((x-east, roof-level - slab), (13.311, roof-level), fill: ink, stroke: none)
  if not court { rect((pj-edge, roof-level - slab), (x-east, roof-level), fill: ink, stroke: none) }
  // dimensions
  let dimh(x0, x1, y, l, col: ink) = {
    line((x0, y), (x1, y), stroke: 0.5pt + col, mark: (start: "|", end: "|", scale: 0.4))
    T(((x0 + x1) / 2, y + 0.28), l, size: 4.6pt, fill: col)
  }
  dimh(pj-edge, x-east, roof-level + 0.6, [#if court [sky] else [void] #r3(pj.sky) m axes · ≈ #r3(pj.sky-clear) clear], col: sky)
  dimh(x-court, pj-edge, ff-level + 0.35, [#r2(pj.depth)], col: red)
  dimh(m-line, ff-west - outer-half, -0.85, [#r3(pj.m-gap)], col: red)
  // levels
  for (h, l) in ((0, [±0.00]), (ff-level, [+#f2(ff-level)]), (roof-level, [+#f2(roof-level)])) { T((14.3, h), l, size: 4.4pt, fill: gray, anchor: "west") }
  T((-2.4, -0.5), [W], size: 5.5pt, anchor: "west"); T((14.4, -0.5), [E], size: 5.5pt, anchor: "east")
})

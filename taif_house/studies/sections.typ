// sections.typ · Taif / Palm House V6.0 · levels, the split west projection, the light check and the two sections (imported, not compiled on its own)
// Used by design_ff.typ and presentation.typ. Geometry is read from ../data/rooms_ff.csv, ../design_gf.typ (placement) and ff_suite.typ (windows);
// the only fixed numbers are the levels below (to confirm with the engineer) and the fallback, the V5.0 solution (git tag v5.0).
// CSV coordinates (metres): x east, square to the M line, origin = the ground floor's west wall centre line; y south.
#import "@preview/cetz:0.4.2"
#import "../design_gf.typ": shift, outline-csv-gf
#import "ff_suite.typ" as suite

// ---------- Levels and walls (concept, to confirm) ----------
#let ff-level = 3.6          // floor-to-floor height
#let roof-level = 7.2
#let slab = 0.25
#let parapet = 1.1
#let low-wall = 1.2          // the living room's low partition to the riwaq
#let outer-half = 0.125      // ½ of the 250 mm outer wall
#let inner-half = 0.1        // ½ of a 200 mm wall
#let rail-half = 0.025       // ½ of a ≈ 50 mm railing on the void edge
#let m-line = -shift.at(0)   // the M line in CSV x

// ---------- The split projection, read from the room data ----------
#let parse-pts(s) = s.split(";").map(t => t.trim()).filter(t => t != "").map(t => { let v = t.split(" ").filter(u => u != ""); (float(v.at(0)), float(v.at(1))) })
#let area(P) = calc.abs(range(P.len()).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, P.len())); a.at(0) * b.at(1) - b.at(0) * a.at(1) }).sum()) / 2
#let ff = csv("../data/rooms_ff.csv", row-type: dictionary).filter(r => r.name != "" and not r.name.starts-with("#")).map(r => (name: r.name, colour: r.colour, P: parse-pts(r.pts)))
#let P-of(n) = ff.find(r => r.name == n).P
#let xs(n) = P-of(n).map(p => p.at(0))
#let ys(n) = P-of(n).map(p => p.at(1))
#let x-court = 4.25                                                            // GF courtyard / living west edge (riwaq east wall)
#let x-east = 8.95                                                             // GF courtyard / living east edge
#let sp-in = calc.max(..xs("Upper gallery (on the west projection)"))          // inward cantilever edge
#let sp-out = calc.min(..ff.map(r => calc.min(..r.P.map(p => p.at(0)))))       // FF west wall
#let sp-wall = calc.max(..xs("Bedroom 2"))                                      // rooms / gallery wall
#let sp-step-y = calc.min(..ys("Wardrobe niche (bedroom 2)"))                   // the west face steps out south of the shaft
#let y-court = calc.min(..ys("Upper gallery (on the west projection)").filter(y => y > 3))   // the courtyard's north edge (projection start)
#let y-living = calc.max(..ys("Upper gallery (on the west projection)"))        // the living's south wall (projection end)
#let y-gym = calc.min(..ys("Gym"))                                              // the gym's north wall
#let sp-outline = outline-csv-gf.slice(0, 4) + ((sp-out, 24.0), (sp-out, sp-step-y), (0, sp-step-y))
#let sp-void = (x-east - sp-in) * (y-living - y-court)
#let sp = (
  inward: sp-in - x-court, outward: -sp-out, sky: x-east - sp-in, sky-clear: x-east - sp-in - 2 * inner-half,
  room: sp-wall - sp-out, room-clear: sp-wall - sp-out - outer-half - inner-half, gallery: sp-in - sp-wall, gallery-clear: sp-in - sp-wall - inner-half - rail-half,
  m-gap: sp-out - m-line - outer-half, gf-m-gap: -m-line - outer-half, cant-wall: (24.0 - sp-step-y) + 2 * (0 - sp-out), step-y: sp-step-y,
  outline: area(sp-outline), void: sp-void, floor: area(sp-outline) - sp-void,
  indoor: ff.filter(r => r.colour not in ("open", "terrace")).map(r => area(r.P)).sum(), court: ff.filter(r => r.colour in ("open", "terrace")).map(r => area(r.P)).sum(),
  circ: ff.filter(r => r.colour == "circ").map(r => area(r.P)).sum(), bath: area(P-of("Family bath")), bath-w: calc.max(..xs("Family bath")) - calc.min(..xs("Family bath")),
  gym: area(P-of("Gym")), niche: area(P-of("Wardrobe niche (bedroom 2)")),
)

// ---------- The fallback: the V5.0 solution (git tag v5.0), full 1.35 m inward on three columns at x 5.6 ----------
#let v50 = (
  sky: 3.35, room: 4.25, gallery: 1.35, m-gap: 0.785, outline: 309.68, void: 42.71, floor: 309.68 - 42.71,
  indoor: 227.75, court: 15.42, circ: 45.72, bath: 4.95, bath-w: 2.75, gym: 24.92, niche: 0.9, col-x: 5.6,
)

// ---------- Comparison table: the split projection against the fallback ----------
#let r2(v) = str(calc.round(v, digits: 2))
#let r3(v) = str(calc.round(v, digits: 3))
#let f2(v) = { let s = str(calc.round(v, digits: 2)); if not s.contains(".") { s + ".00" } else if s.split(".").at(1).len() == 1 { s + "0" } else { s } }   // levels: +3.60
#let dv(a, b, unit: "") = { let d = b - a; if calc.abs(d) < 0.005 { [=] } else { [#if d > 0 [+] else [−]#r3(calc.abs(d))#unit] } }
#let rows = (
  ([Courtyard sky opening, axes (≈ clear)], [#r3(v50.sky) (#r3(v50.sky - 2 * inner-half)) m], [#r3(sp.sky) (#r3(sp.sky-clear)) m], dv(v50.sky, sp.sky)),
  ([Double-height void width, axes], [#r3(v50.sky) m], [#r3(sp.sky) m], dv(v50.sky, sp.sky)),
  ([West room width, axes (≈ clear)], [#r2(v50.room) (#r3(v50.room - outer-half - inner-half)) m], [#r2(sp.room) (#r3(sp.room-clear)) m], dv(v50.room, sp.room)),
  ([Gallery width, axes (≈ clear)], [#r2(v50.gallery) (#r3(v50.gallery - inner-half - rail-half)) m], [#r2(sp.gallery) (#r3(sp.gallery-clear)) m], dv(v50.gallery, sp.gallery)),
  ([Columns in the courtyard / living], [3 on x #r2(v50.col-x) + edge beam], [*none* · plain #r3(sp.inward) m cantilever], [−3]),
  ([FF west face → M line], [#r3(v50.m-gap) m], [*#r2(sp.m-gap) m*], dv(v50.m-gap, sp.m-gap, unit: " m")),
  ([Walls on cantilever], [none], [FF west wall y #r2(sp.step-y)–24 + returns: #r2(sp.cant-wall) m], [new]),
  ([FF outline (axes)], [#r2(v50.outline) m²], [#r2(sp.outline) m²], dv(v50.outline, sp.outline, unit: " m²")),
  ([Courtyard sky + double-height void], [#r2(v50.void) m²], [#r2(sp.void) m²], dv(v50.void, sp.void, unit: " m²")),
  ([FF floor (outline − voids)], [#r2(v50.floor) m²], [#r2(sp.floor) m²], dv(v50.floor, sp.floor, unit: " m²")),
  ([FF rooms indoor (incl. circulation)], [#r2(v50.indoor) m²], [#r2(sp.indoor) m²], dv(v50.indoor, sp.indoor, unit: " m²")),
  ([· family bath], [#r2(v50.bath) m² (#r2(v50.bath-w) wide)], [#r2(sp.bath) m² (#r3(sp.bath-w) wide)], dv(v50.bath, sp.bath, unit: " m²")),
  ([· gym], [#r2(v50.gym) m²], [#r2(sp.gym) m²], dv(v50.gym, sp.gym, unit: " m²")),
  ([Suite court (open to the sky)], [#r2(v50.court) m²], [#r2(sp.court) m²], dv(v50.court, sp.court, unit: " m²")),
)
#let compare-table(size: 7.4pt, head-fill: rgb("#e4eedf"), band: rgb("#f1efe8")) = {
  set text(size)
  table(columns: (auto, 1fr, 1fr, auto), stroke: none, inset: 3pt, fill: (_, y) => if y == 0 { head-fill } else if calc.even(y) { band },
    [*Item*], [*Fallback · full inward on columns (tag v5.0)*], [*V6.0 · split projection*], [*Change*],
    ..rows.flatten())
}

// ---------- Light check of the double-height living's clerestory windows (section through the middle band) ----------
#let latitude = 21.4                                  // Taif, degrees north
#let w-alt = 90 - latitude - 23.44                    // winter solstice noon sun altitude (from the south)
#let e-alt = 90 - latitude                            // equinox noon
#let s-alt = 90 - latitude + 23.44                    // summer solstice noon (> 90: slightly to the north)
#let clerestory = suite.windows.filter(((a, b)) => calc.abs(a.at(1) - y-living) < 1e-6 and calc.abs(b.at(1) - y-living) < 1e-6 and a.at(0) > sp-in and b.at(0) < x-east)
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
  (label: [gym roof edge with a railing only (solid top +#f2(roof-level)) · *V6.0*], top: roof-level, chosen: true),
)
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
  let wall-top = roof-level + parapet
  line((-1.5, 0), (30, 0), stroke: 1pt + ink)
  rect((0, 0), (y-court, ff-level), fill: rgb("#f6e3c0"), stroke: 0.6pt + ink); T((y-court / 2, ff-level / 2), [Women's majlis (GF)])
  rect((0, ff-level), (y-court, roof-level), fill: rgb("#fbf2e2"), stroke: 0.6pt + ink); T((y-court / 2, (ff-level + roof-level) / 2), [Kids' room / family living (FF)])
  line((0, roof-level), (0, wall-top), stroke: 0.6pt + ink); line((y-court, roof-level), (y-court, wall-top), stroke: 0.6pt + ink)
  let y-dh = 13.0
  T(((y-court + y-dh) / 2, 1.5), [COURTYARD · open to the sky], fill: rgb("#2f5f8a"))
  rect((y-dh, 0), (y-living, roof-level), fill: rgb("#fbf2e2"), stroke: 0.6pt + ink)
  line((y-dh, 0.9), (y-dh, 6.6), stroke: 3pt + rgb("#7fb8d0"))
  T((y-dh + 0.3, 0.6), [main light: courtyard glazing], size: 5.3pt, fill: rgb("#2f5f8a"), anchor: "west")
  T((eye.at(0), 4.4), [Living (double height)])
  line((y-dh, roof-level), (y-dh, wall-top), stroke: 0.6pt + ink); line((y-living, roof-level), (y-living, wall-top), stroke: 0.6pt + ink)
  line((y-living, cl-sill), (y-living, cl-head), stroke: 3pt + rgb("#1f7a99"))
  T((y-living - 0.15, cl-head + 0.6), [#clerestory.len() windows #r2(cl-size.at(0)) × #r2(cl-size.at(1)) · sill +#f2(cl-sill) · head +#f2(cl-head)], size: 5.3pt, fill: rgb("#1f7a99"), anchor: "east")
  rect((y-living, 0), (24, ff-level), fill: rgb("#e9d9c4"), stroke: 0.6pt + ink); T(((y-living + 24) / 2, ff-level / 2), [Men's majlis (GF)])
  line((y-living, ff-level), (y-gym, ff-level), stroke: 2pt + rgb("#e0c060")); T(((y-living + y-gym) / 2, ff-level + 0.35), [suite court #r2(strip) m], size: 5pt)
  rect((y-gym, ff-level), (24, roof-level), fill: rgb("#cfe3f3"), stroke: 0.6pt + ink); T(((y-gym + 24) / 2, (ff-level + roof-level) / 2), [Gym (FF)])
  line((y-gym, roof-level), (y-gym, wall-top), stroke: (paint: warn, thickness: 0.8pt, dash: "dotted")); line((24, roof-level), (24, wall-top), stroke: (paint: warn, thickness: 0.8pt, dash: "dotted"))
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
#let section(cut, length: 0.5cm, ink: rgb("#3d4a45"), ghost: luma(150), sky: rgb("#2f5f8a"), sun: rgb("#d08a00"), red: rgb("#b5452f"), fallback: true) = cetz.canvas(length: length, {
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
  T((1.375, 1.9), if court [hospitality\ kitchen (GF)] else [serving\ passage (GF)])
  T(((2.75 + x-court) / 2, 1.9), [riwaq])
  T(((x-court + x-east) / 2, if court { 1.2 } else { 2.4 }), if court [COURTYARD (GF)] else [living · double height], fill: if court { sky } else { ink })
  T((11.1, 1.9), if court [kitchen (GF)] else [living · dining (GF)])
  // GF walls
  wall(0, 0, ff-level, 2 * outer-half); wall(2.75, 0, ff-level - slab, 2 * inner-half); wall(13.311, 0, roof-level + parapet, 2 * outer-half); wall(x-east, 0, roof-level, 2 * inner-half)
  if court { line((x-court, 0), (x-court, ff-level - slab), stroke: 1.6pt + rgb("#7fb8d0")) } else { wall(x-court, 0, low-wall, 2 * inner-half); T((x-court + 0.15, low-wall + 0.15), [low wall #r2(low-wall)], size: 4.2pt, anchor: "west") }
  // FF slab: west band (from the FF west wall to the inward cantilever edge) and the east part
  rect((sp-out - outer-half, ff-level - slab), (sp-in, ff-level), fill: ink, stroke: none)
  rect((x-east, ff-level - slab), (13.311, ff-level), fill: ink, stroke: none)
  // FF rooms and walls
  rect((sp-out, ff-level), (sp-wall, roof-level - slab), fill: fillc, stroke: none)
  rect((sp-wall, ff-level), (sp-in, roof-level - slab), fill: rgb("#f2efe8"), stroke: none)
  rect((x-east, ff-level), (13.311, roof-level - slab), fill: rgb("#efe0cf"), stroke: none)
  T(((sp-out + sp-wall) / 2, 5.6), if court [bedroom 2] else [bedroom 3])
  T(((sp-out + sp-wall) / 2, 5.15), [#r2(sp.room) axes · ≈ #r2(sp.room-clear) clear], size: 4.2pt)
  T(((sp-wall + sp-in) / 2, 5.6), [gallery], size: 4.6pt)
  T(((sp-wall + sp-in) / 2, 5.2), [#r2(sp.gallery)], size: 4.2pt)
  T((11.1, 5.4), if court [suite lobby · dressing] else [suite bedroom])
  wall(sp-out, ff-level, roof-level + parapet, 2 * outer-half); wall(sp-wall, ff-level, roof-level - slab, 2 * inner-half); wall(x-east, ff-level, roof-level + if court { parapet } else { 0 }, 2 * inner-half)
  line((sp-in, ff-level), (sp-in, ff-level + parapet), stroke: 1.2pt + ink)
  T((sp-in + 0.1, ff-level + parapet + 0.15), [railing], size: 4.2pt, anchor: "west")
  // roof
  rect((sp-out - outer-half, roof-level - slab), (sp-in, roof-level), fill: ink, stroke: none)
  rect((x-east, roof-level - slab), (13.311, roof-level), fill: ink, stroke: none)
  if not court { rect((sp-in, roof-level - slab), (x-east, roof-level), fill: ink, stroke: none) }
  // the fallback (V5.0 solution) in grey dashes: FF west wall on x 0, gallery edge beam and column on x 5.6
  if fallback {
    line((0, ff-level), (0, roof-level + parapet), stroke: (paint: ghost, thickness: 0.8pt, dash: "dashed"))
    line((sp-in, ff-level - slab / 2), (v50.col-x, ff-level - slab / 2), stroke: (paint: ghost, thickness: 0.8pt, dash: "dashed"))
    line((v50.col-x, ff-level - 0.55), (v50.col-x, roof-level), stroke: (paint: ghost, thickness: 0.8pt, dash: "dashed"))
    rect((v50.col-x - 0.15, 0), (v50.col-x + 0.15, ff-level - 0.55), stroke: (paint: ghost, thickness: 0.6pt, dash: "dashed"))
    T((v50.col-x, -0.35), [fallback column (not built)], size: 4pt, fill: ghost)
  }
  // the two cantilevers
  T((sp-out - 0.2, ff-level - 0.55), [wall on cantilever beams], size: 4.3pt, fill: red, anchor: "east")
  line((sp-out - 0.2, ff-level - 0.5), (sp-out + 0.2, ff-level - 0.2), stroke: 0.5pt + red, mark: (end: ">", fill: red, scale: 0.3))
  T((sp-in + 0.15, ff-level - 0.55), [#r3(sp.inward) cantilever · no column], size: 4.3pt, fill: red, anchor: "west")
  // dimensions
  let dimh(x0, x1, y, l, col: ink) = {
    line((x0, y), (x1, y), stroke: 0.5pt + col, mark: (start: "|", end: "|", scale: 0.4))
    T(((x0 + x1) / 2, y + 0.28), l, size: 4.6pt, fill: col)
  }
  dimh(sp-in, x-east, roof-level + 0.6, [#if court [sky] else [void] #r3(sp.sky) m axes · ≈ #r3(sp.sky-clear) clear], col: sky)
  dimh(sp-out, 0, ff-level + 0.35, [#r3(sp.outward)], col: red)
  dimh(x-court, sp-in, ff-level + 0.35, [#r3(sp.inward)], col: red)
  dimh(m-line, sp-out - outer-half, -0.85, [#r2(sp.m-gap)], col: red)
  // afternoon sun from the west: the outward cantilever shades the top of the GF west wall by outward · tan(profile angle)
  for deg in (45, 60) {
    let hit = (-outer-half, ff-level - slab - sp.outward * calc.tan(deg * 1deg))
    let len = if deg == 45 { 2.6 } else { 1.8 }
    let start = (hit.at(0) - len * calc.cos(deg * 1deg), hit.at(1) + len * calc.sin(deg * 1deg))
    line(start, hit, stroke: (paint: sun, thickness: 0.7pt), mark: (end: ">", fill: sun, scale: 0.3))
    T((start.at(0) - 0.05, start.at(1)), [#deg°], size: 4.3pt, fill: sun, anchor: "east")
  }
  line((-outer-half, ff-level - slab), (-outer-half, ff-level - slab - sp.outward * calc.tan(60deg)), stroke: 2pt + sun.transparentize(40%))
  T((-1.6, 1.0), [afternoon sun · shade on the GF west wall], size: 4.2pt, fill: sun, anchor: "east")
  // levels
  for (h, l) in ((0, [±0.00]), (ff-level, [+#f2(ff-level)]), (roof-level, [+#f2(roof-level)])) { T((14.3, h), l, size: 4.4pt, fill: gray, anchor: "west") }
  T((-2.4, -0.5), [W], size: 5.5pt, anchor: "west"); T((14.4, -0.5), [E], size: 5.5pt, anchor: "east")
})
#let shade(deg) = sp.outward * calc.tan(deg * 1deg)    // shaded height on the GF west wall below the FF slab

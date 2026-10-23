// sp_compare.typ · Taif / Palm House · V5.1 split projection (variant SP, accepted 24 Oct 2026) · comparison with V5.0 (record of the decision) and the east–west sections
// Imported by design_ff.typ and presentation.typ (not compiled on its own). The variant numbers are read live from ../data/rooms_ff.csv;
// the V5.0 numbers are fixed below, taken from git tag v5.0 (data/rooms_ff.csv and design_ff.typ of that version).
// CSV coordinates (metres): x east, square to the M line, origin = the ground floor's west wall centre line; the M line is at x = -0.91.
#import "@preview/cetz:0.4.2"

// ---------- Fixed ----------
#let m-line = -0.91          // the M line in CSV x (building shift 0.91)
#let outer-half = 0.125      // half the 250 mm outer wall
#let ff-level = 3.6
#let roof-level = 7.2
#let slab = 0.25
#let parapet = 1.1

// ---------- Variant SP, read from the room data ----------
#let parse-pts(s) = s.split(";").map(t => t.trim()).filter(t => t != "").map(t => { let v = t.split(" ").filter(u => u != ""); (float(v.at(0)), float(v.at(1))) })
#let area(P) = calc.abs(range(P.len()).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, P.len())); a.at(0) * b.at(1) - b.at(0) * a.at(1) }).sum()) / 2
#let ff = csv("../data/rooms_ff.csv", row-type: dictionary).filter(r => r.name != "" and not r.name.starts-with("#")).map(r => (name: r.name, colour: r.colour, P: parse-pts(r.pts)))
#let P-of(n) = ff.find(r => r.name == n).P
#let xs(n) = P-of(n).map(p => p.at(0))
#let sp-in = calc.max(..xs("Upper gallery (on the west projection)"))                 // inward cantilever edge
#let sp-out = calc.min(..ff.map(r => calc.min(..r.P.map(p => p.at(0)))))              // FF west wall
#let sp-wall = calc.max(..xs("Bedroom 2"))                                             // rooms / gallery wall
#let sp-step-y = 10.4                                                                   // the west face steps out south of the shaft
#let sp-outline = ((0, 0), (10.051, 0), (13.311, 6.0), (13.311, 24.0), (sp-out, 24.0), (sp-out, sp-step-y), (0, sp-step-y))
#let sp-void = (8.95 - sp-in) * (19.25 - 6.5)
#let sp-indoor = ff.filter(r => r.colour not in ("open", "terrace")).map(r => area(r.P)).sum()
#let sp-court = ff.filter(r => r.colour in ("open", "terrace")).map(r => area(r.P)).sum()
#let sp-circ = ff.filter(r => r.colour == "circ").map(r => area(r.P)).sum()
#let sp = (
  sky: 8.95 - sp-in, room: sp-wall - sp-out, gallery: sp-in - sp-wall, columns: 0, m-gap: -m-line + sp-out - outer-half,
  cant-wall: (24.0 - sp-step-y) + 2 * (0 - sp-out), outline: area(sp-outline), void: sp-void, floor: area(sp-outline) - sp-void,
  indoor: sp-indoor, court: sp-court, circ: sp-circ, bath: area(P-of("Family bath")), gym: area(P-of("Gym")), office: area(P-of("Owner's office")),
  gallery-area: area(P-of("Upper gallery (on the west projection)")), niche: area(P-of("Wardrobe niche (bedroom 2)")),
)

// ---------- V5.0 (git tag v5.0) ----------
#let v50 = (
  sky: 3.35, room: 4.25, gallery: 1.35, columns: 3, m-gap: 0.785, cant-wall: 0.0, outline: 309.68, void: 42.71, floor: 309.68 - 42.71,
  indoor: 227.75, court: 15.42, circ: 45.72, bath: 4.95, gym: 24.92, office: 20.19, gallery-area: 30.71, niche: 0.9,
)

// ---------- Comparison table ----------
#let r2(v) = str(calc.round(v, digits: 2))
#let r3(v) = str(calc.round(v, digits: 3))
#let dv(a, b, unit: "") = { let d = b - a; if calc.abs(d) < 0.005 { [=] } else { [#if d > 0 [+] else [−]#r3(calc.abs(d))#unit] } }
// clear widths: walls 250 mm outer / 200 mm inner; ½ wall each side; railing on the void edge ≈ 50 mm; the sky opening: ½ of the 200 mm east wall + 100 mm for the slab edge with its railing
#let rows = (
  ([Courtyard sky opening, axes], [#r3(v50.sky) m], [#r3(sp.sky) m], dv(v50.sky, sp.sky)),
  ([Courtyard sky opening, ≈ clear], [#r3(v50.sky - 0.2) m], [#r3(sp.sky - 0.2) m], dv(v50.sky, sp.sky)),
  ([Double-height void width, axes (≈ clear)], [#r3(v50.sky) (#r3(v50.sky - 0.2)) m], [#r3(sp.sky) (#r3(sp.sky - 0.2)) m], dv(v50.sky, sp.sky)),
  ([West room width, axes (≈ clear)], [#r2(v50.room) (#r3(v50.room - 0.225)) m], [#r2(sp.room) (#r3(sp.room - 0.225)) m], dv(v50.room, sp.room)),
  ([Gallery width, axes (≈ clear)], [#r2(v50.gallery) (#r3(v50.gallery - 0.125)) m], [#r2(sp.gallery) (#r3(sp.gallery - 0.125)) m], dv(v50.gallery, sp.gallery)),
  ([Columns in the courtyard / living], [yes · 3 on x 5.6 + edge beam], [*no* · plain 0.675 m cantilever], [−3]),
  ([FF west face → M line], [#r3(v50.m-gap) m (on the GF wall)], [*#r2(sp.m-gap) m*], dv(v50.m-gap, sp.m-gap, unit: " m")),
  ([Walls on cantilever], [none (gallery railing on the edge beam)], [FF west wall y 10.4–24 + returns: #r2(sp.cant-wall) m], [new]),
  ([FF outline (axes)], [#r2(v50.outline) m²], [#r2(sp.outline) m²], dv(v50.outline, sp.outline, unit: " m²")),
  ([Courtyard sky + double-height void], [#r2(v50.void) m²], [#r2(sp.void) m²], dv(v50.void, sp.void, unit: " m²")),
  ([FF floor (outline − voids)], [#r2(v50.floor) m²], [#r2(sp.floor) m²], dv(v50.floor, sp.floor, unit: " m²")),
  ([FF rooms indoor (incl. circulation)], [#r2(v50.indoor) m²], [#r2(sp.indoor) m²], dv(v50.indoor, sp.indoor, unit: " m²")),
  ([· circulation], [#r2(v50.circ) m²], [#r2(sp.circ) m²], dv(v50.circ, sp.circ, unit: " m²")),
  ([· family bath], [#r2(v50.bath) m² (2.75 wide)], [#r2(sp.bath) m² (2.075 wide)], dv(v50.bath, sp.bath, unit: " m²")),
  ([· gym], [#r2(v50.gym) m²], [#r2(sp.gym) m²], dv(v50.gym, sp.gym, unit: " m²")),
  ([· wardrobe niche (bedroom 2)], [#r2(v50.niche) m²], [#r2(sp.niche) m²], dv(v50.niche, sp.niche, unit: " m²")),
  ([Suite court (open to the sky)], [#r2(v50.court) m²], [#r2(sp.court) m²], dv(v50.court, sp.court, unit: " m²")),
)
#let compare-table(size: 7.4pt, head-fill: rgb("#e4eedf"), band: rgb("#f1efe8")) = {
  set text(size)
  table(columns: (auto, 1fr, 1fr, auto), stroke: none, inset: 3pt, fill: (_, y) => if y == 0 { head-fill } else if calc.even(y) { band },
    [*Item*], [*V5.0*], [*V5.1 · split*], [*Change*],
    ..rows.flatten())
}

// ---------- East–west sections (looking north) ----------
// cut: "court" (y 12.0: bedroom 2 / gallery / courtyard / suite) or "living" (y 16.5: bedroom 3 / gallery / double-height living / suite bedroom)
#let section(cut, length: 0.5cm, ink: rgb("#3d4a45"), ghost: luma(150), sky: rgb("#2f5f8a"), sun: rgb("#d08a00"), red: rgb("#b5452f")) = cetz.canvas(length: length, {
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
  rect((2.75, 0), (4.25, ff-level - slab), fill: rgb("#f2efe8"), stroke: none)
  rect((8.95, 0), (13.311, ff-level - slab), fill: if court { rgb("#d9e6ec") } else { fillc }, stroke: none)
  if court { rect((4.25, 0), (8.95, 0.05), fill: sky, stroke: none) } else { rect((4.25, 0), (8.95, roof-level - slab), fill: fillc.lighten(40%), stroke: none) }
  T((1.375, 1.9), if court [hospitality\ kitchen (GF)] else [serving\ passage (GF)])
  T((3.5, 1.9), [riwaq])
  T((6.6, if court { 1.2 } else { 2.4 }), if court [COURTYARD (GF)] else [living · double height], fill: if court { sky } else { ink })
  T((11.1, 1.9), if court [kitchen (GF)] else [living · dining (GF)])
  // GF walls
  wall(0, 0, ff-level, 0.25); wall(2.75, 0, ff-level - slab, 0.2); wall(13.311, 0, roof-level + parapet, 0.25); wall(8.95, 0, roof-level, 0.2)
  if court { line((4.25, 0), (4.25, ff-level - slab), stroke: 1.6pt + rgb("#7fb8d0")) } else { wall(4.25, 0, 1.2, 0.2); T((4.4, 1.35), [low wall 1.20], size: 4.2pt, anchor: "west") }
  // FF slab: west band (from the FF west wall to the inward cantilever edge) and east part
  rect((sp-out - 0.125, ff-level - slab), (sp-in, ff-level), fill: ink, stroke: none)
  rect((8.95, ff-level - slab), (13.311, ff-level), fill: ink, stroke: none)
  // FF rooms and walls
  rect((sp-out, ff-level), (sp-wall, roof-level - slab), fill: fillc, stroke: none)
  rect((sp-wall, ff-level), (sp-in, roof-level - slab), fill: rgb("#f2efe8"), stroke: none)
  rect((8.95, ff-level), (13.311, roof-level - slab), fill: rgb("#efe0cf"), stroke: none)
  T(((sp-out + sp-wall) / 2, 5.6), if court [bedroom 2] else [bedroom 3])
  T(((sp-out + sp-wall) / 2, 5.15), [4.25 axes · ≈ 4.03 clear], size: 4.2pt)
  T(((sp-wall + sp-in) / 2, 5.6), [gallery], size: 4.6pt)
  T(((sp-wall + sp-in) / 2, 5.2), [1.35], size: 4.2pt)
  T((11.1, 5.4), if court [suite lobby · dressing] else [suite bedroom])
  wall(sp-out, ff-level, roof-level + parapet, 0.25); wall(sp-wall, ff-level, roof-level - slab, 0.2); wall(8.95, ff-level, roof-level + if court { parapet } else { 0 }, 0.2)
  line((sp-in, ff-level), (sp-in, ff-level + 1.1), stroke: 1.2pt + ink)
  T((sp-in + 0.1, ff-level + 1.25), [railing], size: 4.2pt, anchor: "west")
  // roof
  rect((sp-out - 0.125, roof-level - slab), (sp-in, roof-level), fill: ink, stroke: none)
  rect((8.95, roof-level - slab), (13.311, roof-level), fill: ink, stroke: none)
  if not court { rect((sp-in, roof-level - slab), (8.95, roof-level), fill: ink, stroke: none) }
  // V5.0 ghost: FF west wall on x 0, gallery edge (edge beam) on x 5.6 and the column under it
  line((0, ff-level), (0, roof-level + parapet), stroke: (paint: ghost, thickness: 0.8pt, dash: "dashed"))
  line((sp-in, ff-level - slab / 2), (5.6, ff-level - slab / 2), stroke: (paint: ghost, thickness: 0.8pt, dash: "dashed"))
  line((5.6, ff-level - 0.55), (5.6, roof-level), stroke: (paint: ghost, thickness: 0.8pt, dash: "dashed"))
  rect((5.45, 0), (5.75, ff-level - 0.55), stroke: (paint: ghost, thickness: 0.6pt, dash: "dashed"))
  T((5.6, -0.35), [V5.0 col. (removed)], size: 4pt, fill: ghost)
  // the two cantilevers
  T((sp-out - 0.2, ff-level - 0.55), [wall on cantilever beams], size: 4.3pt, fill: red, anchor: "east")
  line((sp-out - 0.2, ff-level - 0.5), (sp-out + 0.2, ff-level - 0.2), stroke: 0.5pt + red, mark: (end: ">", fill: red, scale: 0.3))
  T((sp-in + 0.15, ff-level - 0.55), [0.675 cantilever · no column], size: 4.3pt, fill: red, anchor: "west")
  // dimensions
  let dimh(x0, x1, y, l, col: ink) = {
    line((x0, y), (x1, y), stroke: 0.5pt + col, mark: (start: "|", end: "|", scale: 0.4))
    T(((x0 + x1) / 2, y + 0.28), l, size: 4.6pt, fill: col)
  }
  dimh(sp-in, 8.95, roof-level + 0.6, if court [sky #r3(8.95 - sp-in) m axes (V5.0 #r2(v50.sky))] else [void #r3(8.95 - sp-in) m axes (V5.0 #r2(v50.sky))], col: sky)
  dimh(sp-out, 0, ff-level + 0.35, [0.675], col: red)
  dimh(4.25, sp-in, ff-level + 0.35, [0.675], col: red)
  dimh(m-line, sp-out - 0.125, -0.85, [#r2(sp.m-gap)], col: red)
  // afternoon sun from the west: the outward cantilever shades the top of the GF west wall by 0.675 · tan(profile angle)
  for (deg, l) in ((45, [45°]), (60, [60°])) {
    let tip = (sp-out - 0.125, ff-level - slab)
    let hit = (-0.125, ff-level - slab - calc.abs(sp-out) * calc.tan(deg * 1deg))
    let start = (hit.at(0) - (if deg == 45 { 2.6 } else { 1.8 }) * calc.cos(deg * 1deg), hit.at(1) + (if deg == 45 { 2.6 } else { 1.8 }) * calc.sin(deg * 1deg))
    line(start, hit, stroke: (paint: sun, thickness: 0.7pt), mark: (end: ">", fill: sun, scale: 0.3))
    T((start.at(0) - 0.05, start.at(1)), l, size: 4.3pt, fill: sun, anchor: "east")
  }
  line((-0.125, ff-level - slab), (-0.125, ff-level - slab - 0.675 * calc.tan(60deg)), stroke: 2pt + sun.transparentize(40%))
  T((-1.6, 1.0), [afternoon sun · shade on the GF west wall], size: 4.2pt, fill: sun, anchor: "east")
  // levels
  for (h, l) in ((0, [±0.00]), (ff-level, [+3.60]), (roof-level, [+7.20])) { T((14.3, h), l, size: 4.4pt, fill: gray, anchor: "west") }
  T((-2.4, -0.5), [W], size: 5.5pt, anchor: "west"); T((14.4, -0.5), [E], size: 5.5pt, anchor: "east")
})

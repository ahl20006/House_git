// malqaf_tower.typ · Taif / Palm House · STUDY (8 Nov 2026) · ADOPTED V9.3: L1, head (c), 3.5 m, the flat Hijazi cornice · a new, elegant malqaf tower (owner: the present tower looks like a box on a box at
// the corner, and its shaft makes awkward corners inside). The design files are NOT changed; the owner chooses after this study.
// 1 · inside: a slim shaft hugging the cut wall, the rooms' walls straight · 2 · above the roof: the HRV unit in a plant room behind the attic, a slim
// square stone tower set back on the attic's corner; six variants (two heights, three heads, a flat Hijazi top or a small dome) · 3 · the comparison.
// Pages 6–7 (8 Nov 2026): where the tower stands, four positions compared.
// The renders: 3d/malqaf_variants.py (the gate camera of char_gate.png) reads `tw`, `variants`, `plenum` and `plant` from THIS file.
// CSV frame (x east, y south, the wall centre lines) · levels from the finished ground floor · every size ASSUMED (concept only).
#import "@preview/cetz:0.4.2"
// RECORD (V9.3): the study was made against the V9.2 air system; since V9.3 studies/air_system.typ carries the ADOPTED tower, so the V9.2 values the study compares with are kept here
#let air-tower = ((8.95, 0), (10.375, 0), (10.375, 1.0), (8.95, 1.0))
#let tower-clear = ((9.075, 0.125), (10.275, 0.125), (10.275, 0.875), (9.075, 0.875))
#let breeze-area = 0.54375
#let service-area = 0.28125
#let zeta-throat = (("head louvres + bird mesh", 0.0100), ("back-draught flaps and the shaft", 0.0338), ("damper, open", 0.0169), ("the throat under the maid bath", 1.5), ("channel friction, 10.5 m", 0.1964), ("the bend and the plenum", 0.2469), ("the grille", 0.8163))
#let zeta = zeta-throat.map(z => z.at(1)).sum()
#let rho = 1.15
#let dCp = 0.8
#let air-throat = (0.5, 0.20)
#let head-opening-area = 3.84
#let louvre-free = 0.5
#let screen-free = 0.9
#let air-head-opening = (8.2, 9.4)
#let condensers = (9.6, 5.6, 12.4, 9.0)
#import "roof.typ": attic, attic-top, coping-top, cornice, D-north, eye, setback, hidden, roof-fin

#set page(paper: "a4", flipped: true, margin: 8mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 7.4pt)
#set par(leading: 0.42em)
#let green = rgb("#2f6b4f"); #let ink = rgb("#26302b"); #let gray = rgb("#6d736f"); #let red = rgb("#b5452f"); #let amber = rgb("#b07a1f")
#let sky = rgb("#d4e9f1"); #let blue = rgb("#1f7a99"); #let stone = rgb("#d2b27a"); #let stone-d = rgb("#b48f55"); #let cream = rgb("#f3ead6"); #let wallc = rgb("#3a3f3b")
#let H(t) = block(above: 5pt, below: 3pt, text(9pt, weight: "bold", fill: green, t))
#let r2(v) = str(calc.round(v, digits: 2)); #let r1(v) = str(calc.round(v, digits: 1)); #let lv(v) = "+" + str(calc.round(v, digits: 2))
#let sarea(P) = range(P.len()).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, P.len())); a.at(0) * b.at(1) - b.at(0) * a.at(1) }).sum() / 2
#let area(P) = calc.abs(sarea(P))
#let d2(a, b) = calc.sqrt(calc.pow(a.at(0) - b.at(0), 2) + calc.pow(a.at(1) - b.at(1), 2))
#let d3(a, b) = calc.sqrt(calc.pow(a.at(0) - b.at(0), 2) + calc.pow(a.at(1) - b.at(1), 2) + calc.pow(a.at(2) - b.at(2), 2))
// a polygon pulled inwards by a distance per edge (the walls' half thicknesses): the clear outline
#let offset-poly(P, ds) = {
  let n = P.len(); let sg = if sarea(P) > 0 { 1 } else { -1 }
  let lines = range(n).map(i => {
    let a = P.at(i); let b = P.at(calc.rem(i + 1, n)); let L = d2(a, b)
    let d = ((b.at(0) - a.at(0)) / L, (b.at(1) - a.at(1)) / L); let nn = (-sg * d.at(1), sg * d.at(0))
    ((a.at(0) + nn.at(0) * ds.at(i), a.at(1) + nn.at(1) * ds.at(i)), d)
  })
  range(n).map(i => {
    let (p1, v1) = lines.at(calc.rem(i - 1 + n, n)); let (p2, v2) = lines.at(i)
    let cr = v1.at(0) * v2.at(1) - v1.at(1) * v2.at(0)
    if calc.abs(cr) < 1e-9 { p2 } else {
      let t = ((p2.at(0) - p1.at(0)) * v2.at(1) - (p2.at(1) - p1.at(1)) * v2.at(0)) / cr
      (p1.at(0) + v1.at(0) * t, p1.at(1) + v1.at(1) * t) }
  })
}
// the interior angles of a polygon (degrees)
#let angles(P) = { let n = P.len(); let sg = if sarea(P) > 0 { 1 } else { -1 }
  range(n).map(i => { let a = P.at(calc.rem(i - 1 + n, n)); let b = P.at(i); let c = P.at(calc.rem(i + 1, n))
    let u = (a.at(0) - b.at(0), a.at(1) - b.at(1)); let w = (c.at(0) - b.at(0), c.at(1) - b.at(1))
    let ang = calc.atan2(u.at(0) * w.at(0) + u.at(1) * w.at(1), u.at(0) * w.at(1) - u.at(1) * w.at(0)).deg()
    let a2 = if sg > 0 { 360 - ang } else { ang }
    if a2 < 0 { a2 + 360 } else if a2 >= 360 { a2 - 360 } else { a2 } }) }
#let inside(p, P) = { let n = P.len(); let c = false
  for i in range(n) { let a = P.at(i); let b = P.at(calc.rem(i + 1, n))
    if ((a.at(1) > p.at(1)) != (b.at(1) > p.at(1))) and (p.at(0) < (b.at(0) - a.at(0)) * (p.at(1) - a.at(1)) / (b.at(1) - a.at(1)) + a.at(0)) { c = not c } }
  c }

// ======================================================================= 1 · THE SHAFT INSIDE THE HOUSE
// the cut wall's frame: s along the cut from B2 (wall centre line), t inwards from the cut's centre line
#let B2 = (10.461, 0.0)
#let cut-L = calc.sqrt(2.85 * 2.85 + 5.245 * 5.245)
#let cu = (2.85 / cut-L, 5.245 / cut-L)                     // along the cut, south-east
#let cn = (-cu.at(1), cu.at(0))                               // inwards (west-south-west)
#let Pc(s, t) = (B2.at(0) + cu.at(0) * s + cn.at(0) * t, B2.at(1) + cu.at(1) * s + cn.at(1) * t)
#let rp(p) = (calc.round(p.at(0), digits: 3), calc.round(p.at(1), digits: 3))
// the proposed slim shaft: clear 0.575 deep (inside the 250 cut wall and a new 200 wall parallel to it), 1.565 long; a solid corner pier in the tip
#let sh = (t0: 0.125, t1: 0.70, s0: 0.10, s1: 1.665, w: 0.20)   // clear: t 0.125–0.70 (0.575 deep), s 0.10–1.665 · the new walls 0.20 (centre t 0.80 and s 1.765)
#let sh-depth = sh.t1 - sh.t0
#let sh-clear = (Pc(sh.s0, sh.t0), Pc(sh.s1, sh.t0), Pc(sh.s1, sh.t1), Pc(sh.s0, sh.t1))
#let s-part = 0.626                                           // the airtight partition s 0.626–0.726: the service compartment north (s 0.10–0.626), the breeze shaft south (s 0.726–1.665)
#let sh-service = (Pc(sh.s0, sh.t0), Pc(s-part, sh.t0), Pc(s-part, sh.t1), Pc(sh.s0, sh.t1))
#let sh-breeze = (Pc(s-part + 0.10, sh.t0), Pc(sh.s1, sh.t0), Pc(sh.s1, sh.t1), Pc(s-part + 0.10, sh.t1))
#let tc = sh.t1 + sh.w / 2                                    // the new wall's centre line: t 0.80
#let se = sh.s1 + sh.w / 2                                    // the end wall's centre line: s 1.765
#let A0 = rp(Pc(-0.4775 * tc / 0.8787, tc))                   // the new wall meets the north wall (y 0)
#let D0 = rp(Pc((1.0 - 0.4775 * tc) / 0.8787, tc))            // … and the line y 1.0 (the store / bath wall)
#let B0 = rp(Pc(se, tc)); #let C0 = rp(Pc(se, 0))             // the end wall, square to the cut
#let sh-axes = (A0, B2, C0, B0)
// the rooms (wall centre lines) and their walls' half thicknesses edge by edge (0.125 outer, 0.10 for 200 mm, 0.05 for the 100 mm store partition)
#let bath = (pts: ((8.95, 1.0), D0, B0, C0, (11.982, 2.8), (8.95, 2.8)), ds: (0.05, 0.10, 0.10, 0.125, 0.10, 0.10))
#let store = (pts: ((8.95, 0.0), A0, D0, (8.95, 1.0)), ds: (0.125, 0.10, 0.05, 0.10))
#let bed1 = (pts: ((8.95, 1.0), D0, B0, C0, (13.311, 5.245), (13.311, 6.5), (10.15, 6.5), (10.15, 5.3), (8.95, 5.3)), ds: (0.05, 0.10, 0.10, 0.125, 0.125, 0.10, 0.10, 0.10, 0.10))
#let cup = store
#let clear(r) = area(offset-poly(r.pts, r.ds))
// the present (V9.2) figures, for the comparison (presentation schedule V9.2; studies/air_system.typ)
#let now = (bath: 3.85, bed1: 15.91, maid: 8.41, tower-axes: area(air-tower), tower-clear: area(tower-clear), w: tower-clear.at(1).at(0) - tower-clear.at(0).at(0), d: tower-clear.at(2).at(1) - tower-clear.at(1).at(1))
#let maid-room = ((10.65, 2.8), (11.982, 2.8), (13.311, 5.245), (13.311, 7.0), (10.65, 7.0))
#let panel = (s0: 1.0, s1: 1.4, sill: 0.10, h: 0.40)          // the shaft-foot access panel 0.40 × 0.40, from the maid bath, at the breeze shaft's foot
#let win1 = ((11.412, 1.75), (12.2, 3.2))                     // bedroom 1's first cut window slid 0.15 south, clear of the end wall (was y 1.6)
#let endwall-y = Pc(se + sh.w / 2, 0.125).at(1)               // where the end wall meets the cut wall's inner face (its south face)

// ======================================================================= 2 · THE TOWER ABOVE THE ROOF
// the tower: a square stone tower 1.25 m outside, square to the house, its north face on the attic's north line (1.0 m behind the north facade), its west face on W3 (x 8.95)
#let tw = (x0: 8.95, y0: 0.875, w: 1.25, wall: 0.15, attic-top: 8.68, crown: 0.30, head-25: 1.48, head-35: 1.68, band: 0.12, band-proj: 0.06, margin: 0.15, a-w: 0.70, b-n: 5, b-w: 0.11, b-rib: 0.075, c-n: 4, c-w: 0.14, c-rib: 0.09, dome-r: 0.5, plenum-top: 7.65, plant-top: 8.60)   // read by 3d/malqaf_variants.py
#let tw-in = tw.w - 2 * tw.wall                                // 0.95 clear: the breeze part 0.57 (east), the partition, the HRV intake 0.28 (west)
#let tw-breeze = tw-in * 0.57; #let tw-intake = tw-in * 0.28
#let plenum = ((9.40, 0.95), (10.15, 0.88), (10.62, 0.60), (11.15, 1.55), (10.65, 1.90), (10.10, 2.05), (9.40, 2.05))   // the breeze plenum: the shaft's top → the tower's foot, +7.00 … +7.65, hidden behind the coping (read by 3d/malqaf_variants.py)
#let plant = (8.7, 2.4, 10.3, 3.8)                            // the HRV plant room behind the attic: x0, y0, x1, y1 (outside), top +8.60 (read by 3d/malqaf_variants.py)
#let unit = (l: 1.2, d: 0.7, h: 0.7)                          // the 750 m³/h HRV (studies/air_system.typ)
#let exhaust = (11.8, 4.5, 7.70)                              // the exhaust grille low in the attic's cut wall, blowing east over the lane side, hidden behind the coping
#let variants = (
  (id: "b25", head: "b", h: 2.5, top: "flat", name: [(b) Yazd slots · 2.5 m · flat]),
  (id: "b35", head: "b", h: 3.5, top: "flat", name: [(b) Yazd slots · 3.5 m · flat]),
  (id: "c25", head: "c", h: 2.5, top: "flat", name: [(c) arched slots · 2.5 m · flat]),
  (id: "c35", head: "c", h: 3.5, top: "flat", name: [(c) arched slots · 3.5 m · flat]),
  (id: "c25d", head: "c", h: 2.5, top: "dome", name: [(c) arched slots · 2.5 m · dome]),
  (id: "a25", head: "a", h: 2.5, top: "flat", name: [(a) one Roman arch · 2.5 m · flat]),
)
#let lev(v) = { let top = tw.attic-top + v.h; let c0 = top - tw.crown; let hb = c0 - (if v.h < 3 { tw.head-25 } else { tw.head-35 }); (top: top, c0: c0, hb: hb, band0: hb - tw.band) }
#let ho(v) = { let L = lev(v); L.c0 - L.hb - 2 * tw.margin }
#let face-free(v) = { let h = ho(v)
  if v.head == "a" { tw.a-w * (h - tw.a-w / 2) + calc.pi * calc.pow(tw.a-w / 2, 2) / 2 }
  else if v.head == "b" { tw.b-n * tw.b-w * h }
  else { tw.c-n * (tw.c-w * (h - tw.c-w / 2) + calc.pi * calc.pow(tw.c-w / 2, 2) / 2) } }
#let slots(v) = if v.head == "a" { 1 } else if v.head == "b" { tw.b-n } else { tw.c-n }
#let total-top(v) = lev(v).top + (if v.top == "dome" { 0.06 + tw.dome-r } else { 0 })
// the breeze: the air study's loss chain (referred to its 0.10 m² throat) with the head term replaced; the wind grows with height (power law 0.20)
#let z-now = (air-head-opening.at(0) + air-head-opening.at(1)) / 2 + 0.30          // the present head's centre above the ground (+8.80, the ground −0.30)
#let throat = air-throat.at(0) * air-throat.at(1)
#let zeta-head-now = zeta-throat.at(0).at(1)
#let zeta-of(v) = zeta - zeta-head-now + 3.0 * calc.pow(throat / (4 * face-free(v) * screen-free), 2) + 1.2 * calc.pow(throat / 0.60, 2)   // + the plenum's two bends
#let z-head(v) = { let L = lev(v); (L.hb + L.c0) / 2 + 0.30 }
#let breeze-index(v) = calc.pow(z-head(v) / z-now, 0.20) * calc.sqrt(zeta / zeta-of(v))
// the structure (ASSUMED): 0.15 walls (RC / block with the stone facing) at 24 kN/m³; the wind q 1.1 kN/m² at the tower (to be taken from SBC 301 by the engineer), Cf 1.3 for a square
#let gamma = 24.0; #let q-wind = 1.1; #let cf = 1.3
#let weight(v) = { let L = lev(v); let ring = tw.w * tw.w - tw-in * tw-in
  let body = ring * (L.c0 - roof-fin) * gamma - 4 * face-free(v) * tw.wall * gamma
  let band = (calc.pow(tw.w + 2 * tw.band-proj, 2) - tw.w * tw.w) * tw.band * gamma
  let crown = ((calc.pow(tw.w + 0.10, 2) - tw.w * tw.w) * 0.12 + (calc.pow(tw.w + 0.20, 2) - tw.w * tw.w) * 0.18 + tw.w * tw.w * 0.15) * gamma
  let dome = if v.top == "dome" { 2 * calc.pi * tw.dome-r * tw.dome-r * 0.08 * gamma } else { 0 }
  body + band + crown + dome }
#let h-exp(v) = total-top(v) - roof-fin
#let wind-F(v) = q-wind * cf * tw.w * h-exp(v)
#let wind-M(v) = wind-F(v) * h-exp(v) / 2
#let stab(v) = weight(v) * tw.w / 2 / wind-M(v)
#let cost(v) = (if v.head == "a" { 1.0 } else if v.head == "b" { 1.2 } else { 1.3 }) * (1 + 0.18 * (v.h - 2.5)) + (if v.top == "dome" { 0.15 } else { 0 })
// what is seen: from the gate (the char_gate.png camera, character.yaml `gate`: the eye −3.9 / −4.9, +1.70) over the north coping; from the courtyard's south edge over the roof edge
#let gate-eye = (-3.9, -4.9, 1.70)
#let z-hide-gate = gate-eye.at(2) + (coping-top - gate-eye.at(2)) * (tw.y0 - gate-eye.at(1)) / (-0.125 - gate-eye.at(1))
#let court-eye = (7.4, 13.0, 1.60); #let court-edge = (6.5, 7.30)
#let z-hide-court = court-eye.at(2) + (court-edge.at(1) - court-eye.at(2)) * (court-eye.at(1) - (tw.y0 + tw.w)) / (court-eye.at(1) - court-edge.at(0))
#let intake(v) = (tw.x0, tw.y0 + tw.w / 2, lev(v).band0 - 0.25)    // the HRV intake louvre on the tower's west face, just below the band
// the attic's inner face (0.20 wall)
#let attic-in = offset-poly(attic, (0.2,) * attic.len())
#let plant-pts = ((plant.at(0), plant.at(1)), (plant.at(2), plant.at(1)), (plant.at(2), plant.at(3)), (plant.at(0), plant.at(3)))
#let t-of(p) = cn.at(0) * (p.at(0) - B2.at(0)) + cn.at(1) * (p.at(1) - B2.at(1))      // the inward distance from the cut's centre line

// ======================================================================= CHECKS
#let checks = (
  ([the shaft ≈ 0.90 m² clear (#r2(area(sh-clear))), 0.55–0.60 deep (#r2(sh-depth)), along the cut wall], calc.abs(area(sh-clear) - 0.90) < 0.05 and sh-depth >= 0.55 and sh-depth <= 0.60),
  ([its breeze shaft ≥ 0.54 m² (#r2(area(sh-breeze))) and its service compartment ≥ 0.21 m² (#r2(area(sh-service)))], area(sh-breeze) >= 0.535 and area(sh-service) >= 0.21),
  ([the maid bath, its store and bedroom 1: straight walls, no corner sharper than the cut's own 61.5° where it meets a cross wall (the smallest #r1(calc.min(..angles(bath.pts), ..angles(store.pts), ..angles(bed1.pts)))°)], calc.min(..angles(bath.pts), ..angles(store.pts), ..angles(bed1.pts)) >= 60),
  ([each of the two rooms has one straight wall parallel to the cut (the shaft's new wall, #r2(d2(D0, B0)) m)], calc.abs((B0.at(0) - D0.at(0)) * cu.at(1) - (B0.at(1) - D0.at(1)) * cu.at(0)) < 0.005),
  ([the access panel opens into the maid bath (ground floor), none into bedroom 1], inside(Pc((panel.s0 + panel.s1) / 2, tc + 0.15), bath.pts)),
  ([bedroom 1's first cut window clear of the shaft's end wall (from y #r2(win1.at(0).at(1)) ≥ #r2(endwall-y + 0.03))], win1.at(0).at(1) >= endwall-y + 0.03),
  ([the tower set back 1.0 m from the north facade and ≥ 0.7 m from the cut facade (#r2(t-of((tw.x0 + tw.w, tw.y0)) + 0.125) m at its corner)], tw.y0 + 0.125 >= 1.0 - 1e-6 and t-of((tw.x0 + tw.w, tw.y0)) + 0.125 >= 0.7),
  ([the tower's clear section (#r2(tw-in * tw-in) m²) holds the breeze part #r2(tw-breeze) m² ≥ the shaft's 0.54 and the intake #r2(tw-intake) m²], tw-breeze >= 0.535 and tw-intake >= 0.21),
  ([the plenum hidden behind the north coping (top #lv(tw.plenum-top) ≤ #lv(coping-top))], tw.plenum-top <= coping-top + 1e-9),
  ([the plant room inside the attic (#r2((plant.at(2) - plant.at(0)) * (plant.at(3) - plant.at(1))) m² outside), its top #lv(tw.plant-top) ≤ the attic coping #lv(attic-top): hidden], plant-pts.all(p => inside(p, attic-in)) and tw.plant-top <= attic-top + 1e-9),
  ([the HRV intake ≥ 3 m from the exhaust for every variant (the least #r2(calc.min(..variants.map(v => d3(intake(v), exhaust)))) m)], variants.all(v => d3(intake(v), exhaust) >= 3.0)),
  ([the exhaust ≥ 1 m from the condensers (Z2b), the intake ≥ 2 m], condensers.at(1) - exhaust.at(1) >= 1.0 and variants.all(v => d3(intake(v), (calc.max(condensers.at(0), intake(v).at(0)), condensers.at(1), 7.9)) >= 2.0)),
  ([every head's windward face lets through ≥ the breeze shaft (free with the bird mesh ≥ 0.54 m²)], variants.all(v => face-free(v) * screen-free >= 0.54)),
  ([every variant stands on its own weight against the assumed wind (stability ≥ 1.5 before anchoring)], variants.all(v => stab(v) >= 1.5)),
)
#let all-ok = checks.all(c => c.at(1))

// ======================================================================= DRAWING HELPERS
#let plan(Pts, ds: none, fill: white, stroke: none) = { let (f, s) = (fill, stroke); import cetz.draw: *; line(..(if ds == none { Pts } else { offset-poly(Pts, ds) }).map(p => (p.at(0), -p.at(1))), close: true, fill: f, stroke: s) }
#let T(p, t, size: 5pt, fill: ink, anchor: "center", angle: 0deg) = { let (c, a, g) = (fill, anchor, angle); import cetz.draw: *; content((p.at(0), -p.at(1)), anchor: a, angle: g, text(size, fill: c, t)) }
#let corner-plan(floor) = cetz.canvas(length: 1.22cm, {
  import cetz.draw: *
  let outline = ((8.45, -0.125), (10.586, -0.125), (13.436, 5.12), (13.436, 7.2), (8.45, 7.2))
  // the wall mass, then the clear rooms on it
  plan(((8.45, -0.125), (10.53, -0.125), (13.436, 5.22), (13.436, 7.1), (8.45, 7.1)), fill: wallc)
  plan(sh-axes.map(p => p), ds: (0.10, 0.125, 0.10, 0.10), fill: wallc)
  let rooms = if floor == "GF" { ((bath, rgb("#d3e6ee"), [maid bath]), (store, rgb("#e6e1d6"), [store])) } else { ((bed1, rgb("#f1e3c8"), [bedroom 1]), (cup, rgb("#e6e1d6"), [cupboard])) }
  for (r, c, n) in rooms { plan(r.pts, ds: r.ds, fill: c) }
  if floor == "GF" {
    plan(maid-room, ds: (0.10, 0.125, 0.125, 0.10, 0.05), fill: rgb("#dbe7ec")); T((12.0, 5.6), [maid room\ #r2(now.maid) m²\ (unchanged)], size: 4.2pt)
    plan(((8.95, 2.8), (10.65, 2.8), (10.65, 7.0), (8.95, 7.0)), ds: (0.10, 0.05, 0.10, 0.10), fill: rgb("#dbe7ec")); T((9.8, 4.9), [laundry], size: 4.6pt)
  } else {
    plan(((8.45, -0.0), (8.95, 0), (8.95, 3.0), (8.45, 3.0)), ds: (0.125, 0.10, 0.10, 0.0), fill: rgb("#f1e3c8")); T((8.6, 2.0), [kids'], size: 4pt, angle: 90deg)
  }
  // the shaft: service (north), the partition, the breeze shaft (south)
  plan(sh-service, fill: rgb("#dfe8d0")); plan(sh-breeze, fill: sky)
  let pc = Pc((sh.s0 + s-part) / 2, (sh.t0 + sh.t1) / 2); T(pc, [service\ #r2(area(sh-service))], size: 3.8pt, angle: -61.5deg)
  let bc = Pc((s-part + 0.1 + sh.s1) / 2, (sh.t0 + sh.t1) / 2); T(bc, [breeze shaft #r2(area(sh-breeze)) m²], size: 3.8pt, angle: -61.5deg)
  // the present tower (V9.2), dashed
  line(..air-tower.map(p => (p.at(0), -p.at(1))), close: true, stroke: (paint: red, thickness: 0.6pt, dash: "dashed"))
  T((9.66, -0.32), [V9.2 tower (dashed)], size: 3.8pt, fill: red)
  // the rooms' names and clear areas
  if floor == "GF" {
    T((11.05, 2.42), [*maid bath*\ *#r2(clear(bath)) m²*\ clear], size: 4.2pt)
    T((9.3, 0.55), [store], size: 4pt)
    // indicative fixtures
    for (x0, y0, x1, y1, l) in ((9.05, 1.10, 9.85, 1.90, [shower]), (9.05, 2.15, 9.55, 2.70, [basin]), (9.95, 2.10, 10.45, 2.70, [WC])) { rect((x0, -y0), (x1, -y1), stroke: 0.4pt + blue, fill: white); T(((x0 + x1) / 2, (y0 + y1) / 2), l, size: 3.4pt, fill: blue) }
    line((9.15, -1.0), (9.75, -1.0), stroke: 1.6pt + rgb("#9c6b3c")); T((9.45, 0.88), [door 0.60], size: 3pt)
    // the access panel at the breeze shaft's foot
    line((Pc(panel.s0, tc + 0.10).at(0), -Pc(panel.s0, tc + 0.10).at(1)), (Pc(panel.s1, tc + 0.10).at(0), -Pc(panel.s1, tc + 0.10).at(1)), stroke: 3pt + red)
    T((10.05, 1.42), [panel], size: 3.6pt, fill: red, anchor: "west")
    // the breeze channel from the shaft's foot (in the slab)
    line((Pc(1.2, 0.41).at(0), -Pc(1.2, 0.41).at(1)), (10.45, -2.0), (10.2, -2.8), (10.2, -7.1), stroke: (paint: amber, thickness: 1.2pt, dash: "dashed")); T((10.05, 3.6), [breeze channel (slab)], size: 3.6pt, fill: amber, angle: 90deg)
    line((11.548, -2.0), (11.874, -2.6), stroke: 2pt + blue)
  } else {
    T((10.9, 4.2), [*bedroom 1*\ *#r2(clear(bed1)) m² clear*\ (V9.2 #r2(now.bed1))], size: 4.4pt)
    T((9.3, 0.55), [cupb.], size: 4pt)
    line((9.15, -1.0), (9.75, -1.0), stroke: 1.6pt + rgb("#9c6b3c"))
    line(win1.at(0).map(v => v) .enumerate().map(((i, v)) => if i == 1 { -v } else { v }), win1.at(1).enumerate().map(((i, v)) => if i == 1 { -v } else { v }), stroke: 2pt + blue)
    line((12.442, -3.645), (13.039, -4.745), stroke: 2pt + blue)
    T((12.3, 2.0), [window slid to y 1.75], size: 3.4pt, fill: blue, angle: -61.5deg)
    T(Pc(1.0, 1.1), [no opening\ into the bedroom], size: 3.4pt, fill: red)
  }
  // the straight wall parallel to the cut
  line((D0.at(0), -D0.at(1)), (B0.at(0), -B0.at(1)), stroke: (paint: green, thickness: 0.8pt, dash: "dotted"))
  T((8.7, -0.45), [#if floor == "GF" [GROUND FLOOR] else [FIRST FLOOR] · 1 m = 1.22 cm], size: 4.6pt, anchor: "west", fill: green)
})

// the elevations of one variant: north (looking south) and east (from the lane, looking west)
#let head-openings(v, x0, w, hb, flip: false) = {
  import cetz.draw: *
  let h = ho(v); let z0 = hb + tw.margin
  let arch(cx, sw, hh) = { let r = sw / 2; let pts = ((cx - r, z0), (cx + r, z0), (cx + r, z0 + hh - r)) + range(1, 16).map(k => { let t = k * calc.pi / 16; (cx + r * calc.cos(t), z0 + hh - r + r * calc.sin(t)) }) + ((cx - r, z0 + hh - r),); line(..pts, close: true, fill: rgb("#2b2b2d"), stroke: none) }
  if v.head == "a" { arch(x0 + w / 2, tw.a-w, h) } else {
    let (n, sw, rib) = if v.head == "b" { (tw.b-n, tw.b-w, tw.b-rib) } else { (tw.c-n, tw.c-w, tw.c-rib) }
    let total = n * sw + (n - 1) * rib
    for k in range(int(n)) { let cx = x0 + (w - total) / 2 + k * (sw + rib) + sw / 2
      if v.head == "b" { rect((cx - sw / 2, z0), (cx + sw / 2, z0 + h), fill: rgb("#2b2b2d"), stroke: none) } else { arch(cx, sw, h) } }
  }
}
#let tower-elev(v, x0) = {
  import cetz.draw: *
  let L = lev(v); let w = tw.w
  rect((x0, coping-top), (x0 + w, L.band0), fill: stone, stroke: 0.4pt + ink)
  rect((x0 - tw.band-proj, L.band0), (x0 + w + tw.band-proj, L.hb), fill: stone-d, stroke: 0.4pt + ink)
  rect((x0, L.hb), (x0 + w, L.c0), fill: stone, stroke: 0.4pt + ink)
  head-openings(v, x0, w, L.hb)
  rect((x0 - 0.05, L.c0), (x0 + w + 0.05, L.c0 + 0.12), fill: stone-d, stroke: 0.4pt + ink)
  rect((x0 - 0.10, L.c0 + 0.12), (x0 + w + 0.10, L.top), fill: stone-d, stroke: 0.4pt + ink)
  if v.top == "dome" {
    let cx = x0 + w / 2; let r = tw.dome-r
    rect((cx - r, L.top), (cx + r, L.top + 0.06), fill: stone, stroke: 0.4pt + ink)
    line(..range(0, 17).map(k => { let t = k * calc.pi / 16; (cx + r * calc.cos(t), L.top + 0.06 + r * calc.sin(t)) }), close: true, fill: stone, stroke: 0.4pt + ink)
  }
}
#let elevations(v) = cetz.canvas(length: 0.58cm, {
  import cetz.draw: *
  let z-ground = 6.3
  // NORTH: the north facade's top, the attic set back, the tower
  let N(x) = x
  rect((5.6, z-ground), (10.586, cornice.z0), fill: cream, stroke: 0.4pt + ink)
  rect((10.586, z-ground), (11.6, cornice.z0), fill: cream.darken(8%), stroke: 0.3pt + ink)
  rect((5.45, cornice.z0), (10.9, cornice.z0 + cornice.h), fill: stone-d, stroke: 0.4pt + ink)
  rect((5.6, cornice.z0 + cornice.h), (10.7, coping-top), fill: stone, stroke: 0.4pt + ink)
  line((10.7, coping-top), (11.6, 7.35), stroke: 0.3pt + gray)
  rect((5.6, coping-top), (tw.x0, attic-top), fill: cream.darken(4%), stroke: 0.4pt + ink)
  rect((tw.x0 + tw.w, coping-top), (9.94 + 0.5, attic-top), fill: cream.darken(10%), stroke: 0.3pt + ink)
  tower-elev(v, tw.x0)
  line((tw.x0 - 0.35, z-hide-gate), (tw.x0 - 0.05, z-hide-gate), stroke: 0.6pt + red); content((tw.x0 - 0.4, z-hide-gate), anchor: "east", text(3.6pt, fill: red)[gate: seen above #lv(z-hide-gate)])
  content((8.0, 6.0), text(4pt, fill: green)[NORTH (from the street)])
  // EAST: seen from the lane, north on the right: X(y) = 16.2 − y
  let X(y) = 16.4 - y
  rect((X(5.3), z-ground), (X(-0.125), cornice.z0), fill: cream.darken(8%), stroke: 0.4pt + ink)
  rect((X(5.3) - 0.1, cornice.z0), (X(-0.125) + 0.2, cornice.z0 + cornice.h), fill: stone-d, stroke: 0.4pt + ink)
  rect((X(5.3), cornice.z0 + cornice.h), (X(-0.125), coping-top), fill: stone, stroke: 0.4pt + ink)
  rect((X(5.468), coping-top), (X(0.875), attic-top), fill: cream.darken(4%), stroke: 0.4pt + ink)
  rect((X(plant.at(3)), coping-top), (X(plant.at(1)), tw.plant-top), stroke: (paint: gray, thickness: 0.4pt, dash: "dashed"))
  content(((X(plant.at(3)) + X(plant.at(1))) / 2, 8.2), text(3.2pt, fill: gray)[plant room\ (hidden)])
  tower-elev(v, X(tw.y0 + tw.w))
  content((X(2.6), 6.0), text(4pt, fill: green)[EAST (from the lane)])
  content((X(2.6), total-top(v) + 0.45), text(4.4pt, weight: "bold")[#lv(total-top(v))])
})

// ======================================================================= PAGE 1 · inside the house
#text(14pt, weight: "bold", fill: green)[Malqaf tower study · a slim shaft along the cut wall, a tall stone tower set back on the roof · Taif / Palm House]
#v(1pt)
#block(fill: rgb("#e4eedf"), inset: 4pt, radius: 2pt)[#text(8.5pt, weight: "bold", fill: green)[ADOPTED (V9.3, owner, 8 Nov 2026): L1 (the north-east cut corner), head (c), 3.5 m above the attic coping, the flat Hijazi cornice] #text(7pt)[· the slim shaft along the cut wall with the store and the cupboard, the HRV in the plant room behind the attic (moved 0.5 m south, y 2.9–4.3, so the roof hatch in the tower's south face is reached), the breeze channel at its full width; applied in the design files. This study stays the record of the comparison.]]
#v(1pt)
#text(7.6pt, fill: gray)[STUDY ONLY (8 Nov 2026): the design files are not changed; the owner chooses after this study. Owner's intent: a real, elegant malqaf, the symbol of the house, taller and slimmer, in honey stone, cream plaster and black steel with simple cornices; no awkward corners inside. All sizes assumed: the MEP and structural engineers confirm.]
#v(3pt)
#grid(columns: (auto, auto, 1fr), gutter: 8pt,
  [#corner-plan("GF")],
  [#corner-plan("FF")],
  [
    #H[1 · The shaft today (V9.2)]
    - A rectangle at the tip of the cut corner, *#r2(now.w) m wide × #r2(now.d) m deep clear = #r2(now.tower-clear) m²* (#r2(now.tower-axes) m² on the wall centre lines; the breeze shaft #r2(breeze-area), the service compartment #r2(service-area)); the slab openings ≈ 0.98 m². Its east wall leaves a *wedge* against the cut wall in the maid bath (the shelf niche) and in bedroom 1 (the cupboard): the awkward corners the owner objects to. Above the roof it rises from the 5.84 m² HRV base: the "box on a box".
    #H[2 · The proposal: a slim shaft hugging the cut wall]
    - *Clear #r2(sh-depth) m deep × #r2(sh.s1 - sh.s0) m long along the cut = #r2(area(sh-clear)) m²*, between the cut wall's inner face and *one new 200 mm wall parallel to the cut*, closed by a short end wall square to the cut; the tip beyond it a *solid corner pier* (it stiffens the corner). Split by an airtight partition (0.10): the *breeze shaft #r2(area(sh-breeze)) m²* (south part) and the *service compartment #r2(area(sh-service)) m²* (north part: the HRV's two Ø250 supply / extract risers to the ground floor; the HRV's intake is now taken at the tower's head, § 3).
    - *The rooms (straight walls):* north of the line y 1.0 a 100 mm partition closes a *store* off the maid bath (#r2(clear(store)) m² clear, door 0.60) and, upstairs, a *cupboard* in bedroom 1 (#r2(clear(cup)) m²); south of it each room gets *one straight wall parallel to the cut* (#r2(d2(D0, B0)) m, dotted green) and a square return; its corners 90°, 118.5° or, where the cut meets a cross wall, the cut's own 61.5° (8 Nov 2026 correction: an earlier angle test missed it).
    #table(columns: (1.6fr, auto, auto, auto), inset: 2.2pt, stroke: 0.4pt + luma(175), fill: (_, y) => if y == 0 { rgb("#e4eedf") },
      [*Room*], [*axes m²*], [*clear m²*], [*V9.2 clear*],
      [Maid bath (G05)], [#r2(area(bath.pts))], [*#r2(clear(bath))*], [#r2(now.bath)],
      [Its store (new)], [#r2(area(store.pts))], [#r2(clear(store))], [–],
      [Maid room (G06)], [9.55], [#r2(now.maid)], [#r2(now.maid)],
      [Bedroom 1 (F11)], [#r2(area(bed1.pts))], [*#r2(clear(bed1))*], [#r2(now.bed1)],
      [Its cupboard (new)], [#r2(area(cup.pts))], [#r2(clear(cup))], [–],
      [Shaft (axes / clear)], [#r2(area(sh-axes))], [#r2(area(sh-clear))], [#r2(now.tower-clear)],
    )
    - *The price of the straight walls:* the maid bath #r2(clear(bath) - now.bath) m² and bedroom 1 #r2(clear(bed1) - now.bed1) m² clear, against a usable store and cupboard of #r2(clear(store)) m² each (net #r2(clear(bath) + clear(store) - now.bath) / #r2(clear(bed1) + clear(cup) - now.bed1)). *Option:* if the ground floor's HRV risers go down the west service shaft instead, the slim shaft is the breeze shaft alone (≈ 0.94 m long) and both rooms win back ≈ 0.35 m².
    #H[3 · Cleaning without entry]
    - *From the roof:* the head's bird mesh in slide-down cassettes, one per quarter, lowered on cords to a *small roof hatch* (0.50 × 0.50) in the tower's south face inside the attic; the *top damper* just above the plenum, reached through the same hatch; the plenum's lid is a second hatch. *From the ground floor:* one *access panel 0.40 × 0.40* (red) at the breeze shaft's foot, opening from the *maid bath* (sill +0.10, gasketed, screw-fixed): the sump, the channel's mouth. *No opening into bedroom 1.* The shaft's inside *smooth-rendered* (sealed), so dust does not cling.
  ],
)
#v(2pt)
#text(6.4pt, fill: gray)[Study checks #if all-ok [*passed* (#checks.len())] else [*FAILED*: #checks.filter(c => not c.at(1)).map(c => c.at(0)).join([; ])] · the clear areas: the walls' half thicknesses edge by edge (0.125 outer, 0.10 for 200 mm, 0.05 for the store partition), the same allowances as the presentation's schedule · the bath's fixtures indicative (the interior study re-plans them) · bedroom 1's first cut window slides 0.15 m south (y 1.75) to clear the end wall.]

// ======================================================================= PAGE 2 · above the roof
#pagebreak()
#text(12pt, weight: "bold", fill: green)[Above the roof · the HRV plant room behind the attic, the hidden plenum, the tower set back on the attic's corner]
#v(3pt)
#grid(columns: (1.05fr, 1fr), gutter: 10pt,
  cetz.canvas(length: 1.3cm, {
    import cetz.draw: *
    plan(((-0.125 + 6.0, -0.125), (10.586, -0.125), (13.436, 5.12), (13.436, 8.2), (6.0, 8.2)), fill: rgb("#ece6d8"), stroke: 0.6pt + ink)
    line((6.0, -attic.at(1).at(1)), (attic.at(1).at(0), -attic.at(1).at(1)), (attic.at(2).at(0), -attic.at(2).at(1)), (attic.at(2).at(0), -8.2), stroke: 2.6pt + rgb("#c9bfa8"))
    T((6.1, 0.65), [attic (set back 1.0, #lv(attic-top))], size: 4pt, anchor: "west")
    T((7.0, 0.25), [1.0 m strip (no-go) · north coping #lv(coping-top)], size: 4pt, anchor: "west", fill: gray)
    // the shaft's top and the plenum
    plan(plenum, fill: sky.transparentize(40%), stroke: (paint: blue, thickness: 0.5pt, dash: "dashed"))
    plan(sh-clear, fill: none, stroke: 0.5pt + blue)
    T((10.75, 1.3), [plenum\ (hidden,\ #lv(tw.plenum-top))], size: 3.8pt, fill: blue)
    // the tower
    rect((tw.x0, -tw.y0), (tw.x0 + tw.w, -(tw.y0 + tw.w)), fill: stone, stroke: 0.7pt + ink)
    rect((tw.x0 + tw.wall, -(tw.y0 + tw.wall)), (tw.x0 + tw.w - tw.wall, -(tw.y0 + tw.w - tw.wall)), fill: white, stroke: 0.4pt + ink)
    rect((tw.x0 + tw.wall + tw-in * 0.38, -(tw.y0 + tw.wall)), (tw.x0 + tw.w - tw.wall, -(tw.y0 + tw.w - tw.wall)), fill: sky, stroke: none)
    rect((tw.x0 + tw.wall, -(tw.y0 + tw.wall)), (tw.x0 + tw.wall + tw-in * 0.28, -(tw.y0 + tw.w - tw.wall)), fill: rgb("#dfe8d0"), stroke: none)
    T((tw.x0 + 0.85, tw.y0 + 0.62), [breeze\ #r2(tw-breeze)], size: 3.6pt)
    T((tw.x0 + 0.29, tw.y0 + 0.62), [intake\ #r2(tw-intake)], size: 3.2pt, angle: 90deg)
    T((tw.x0 + tw.w / 2, tw.y0 - 0.25), [TOWER #tw.w × #tw.w], size: 4.4pt, fill: ink)
    line((tw.x0 + 0.35, -(tw.y0 + tw.w)), (tw.x0 + 0.85, -(tw.y0 + tw.w)), stroke: 2pt + red); T((tw.x0 + 0.6, tw.y0 + tw.w + 0.13), [roof hatch], size: 3.4pt, fill: red)
    line((tw.x0, -(tw.y0 + 0.2)), (tw.x0, -(tw.y0 + 1.05)), stroke: 2pt + green); T((tw.x0 - 0.15, tw.y0 + 0.6), [intake louvre], size: 3.4pt, fill: green, angle: 90deg)
    // the plant room
    rect((plant.at(0), -plant.at(1)), (plant.at(2), -plant.at(3)), fill: cream.darken(6%), stroke: 0.7pt + ink)
    rect((plant.at(0) + 0.2, -(plant.at(1) + 0.15)), (plant.at(0) + 0.2 + unit.l, -(plant.at(1) + 0.15 + unit.d)), fill: white, stroke: 0.4pt + gray)
    T(((plant.at(0) + plant.at(2)) / 2, plant.at(1) + 0.5), [HRV #unit.l × #unit.d], size: 3.6pt)
    line((plant.at(0) + 0.2, -plant.at(3)), (plant.at(0) + 1.4, -plant.at(3)), stroke: 2pt + rgb("#9c6b3c")); T(((plant.at(0) + plant.at(2)) / 2, plant.at(3) + 0.15), [doors (service front)], size: 3.4pt)
    T((plant.at(2) + 0.1, plant.at(1) + 0.9), [PLANT ROOM\ #r2(plant.at(2) - plant.at(0)) × #r2(plant.at(3) - plant.at(1)) out,\ top #lv(tw.plant-top)], size: 3.8pt, anchor: "west")
    line((tw.x0 + 0.25, -(tw.y0 + tw.w)), (tw.x0 + 0.25, -plant.at(1)), stroke: 1.4pt + green)
    line((plant.at(2), -3.4), (11.0, -3.4), (exhaust.at(0), -exhaust.at(1)), stroke: (paint: amber, thickness: 1pt, dash: "dashed"))
    circle((exhaust.at(0), -exhaust.at(1)), radius: 0.09, fill: amber, stroke: none); T((exhaust.at(0) - 0.15, exhaust.at(1) + 0.2), [exhaust (attic wall, low)], size: 3.4pt, fill: amber, anchor: "east")
    rect((condensers.at(0), -condensers.at(1)), (12.3, -8.2), fill: rgb("#f6d9c9"), stroke: 0.4pt + red); T((11.0, 6.4), [Z2b AC units], size: 3.8pt, fill: red)
    line((6.6, -4.4), (8.6, -4.4), (8.6, -3.8), stroke: (paint: gray, thickness: 0.6pt, dash: "dash-dotted")); T((6.7, 4.25), [walkway from the ladder (attic opening x 2.1–2.9)], size: 3.4pt, fill: gray, anchor: "west")
    T((6.1, 7.95), [ROOF, the north-east corner · 1 m = 1.3 cm], size: 4.4pt, anchor: "west", fill: green)
  }),
  [
    #H[4 · The HRV unit off the tower: a plant room hidden behind the attic]
    - *Where and how big:* inside the attic, south of the tower, x #plant.at(0)–#plant.at(2), y #plant.at(1)–#plant.at(3) (#r2(plant.at(2) - plant.at(0)) × #r2(plant.at(3) - plant.at(1)) m outside, #r2((plant.at(2) - plant.at(0)) * (plant.at(3) - plant.at(1))) m²), light insulated walls, a slab at #lv(tw.plant-top): *below the attic coping (#lv(attic-top)), so hidden from the street, the lane and the courtyard*; ≈ 1.15 m clear inside: a service compartment, not a room (the 1.2 × 0.7 × 0.7 unit on a 0.10 plinth, its front at the doors).
    - *Service access:* a pair of doors on its south face (filters and the core pulled out), reached on the roof walkway from the maintenance ladder through the attic opening (the strip in front of the attic stays a no-go zone).
    - *Air:* the *intake* from the tower's own intake compartment (#r2(tw-intake) m²; its louvre on the tower's west face just below the band, high above the roof: the cleanest air), dropping to the roof and through a 0.3 m duct into the plant room; the *exhaust* led along the attic to a low grille in the attic's cut wall (#lv(exhaust.at(2))), blowing east over the lane side, hidden behind the coping. Separations: intake ↔ exhaust #r2(calc.min(..variants.map(v => d3(intake(v), exhaust)))) m or more (ASHRAE 62.1 ≥ 3 m), the exhaust #r2(condensers.at(1) - exhaust.at(1)) m from the condensers (≥ 1 m). The first floor fed straight through the roof slab; the ground floor through the shaft's service compartment.
    #H[5 · The tower above the roof: slim, square, set back]
    - *Section #tw.w × #tw.w m outside* (#tw.wall walls, #r2(tw-in) × #r2(tw-in) clear = #r2(tw-in * tw-in) m²: the breeze part #r2(tw-breeze), the partition, the intake #r2(tw-intake)), square to the house like the attic and the courtyard. *Set back:* its north face on the attic's north line (1.0 m behind the north facade), its west face over the wall W3 (x 8.95), its north-east corner #r2(t-of((tw.x0 + tw.w, tw.y0)) + 0.125) m behind the cut facade: it reads as *the attic's corner rising*, not a box perched on the facade's edge. The attic's coping line wraps round it as its plinth.
    - *The transition hidden:* the slim shaft rises inside the cut wall to the roof; a low *plenum* (the roof slab omitted over it, +7.00 … #lv(tw.plenum-top), smooth-rendered, partitioned) turns the breeze from the shaft's top into the tower's foot, *below the north coping (#lv(coping-top)): never seen*. Its two gentle bends cost little (included in § 7).
    - *Bird mesh and damper as decided (air v3.1):* a wide 20 mm bird mesh only, the + divider and the back-draught flaps in the head, the motorised spring-return damper at the tower's foot (the roof hatch).
    - *Structure (note for the engineer):* the tower stands on the roof slab over the W3 line and the new 100 / 200 wall y 1.0 (to be RC under the tower), with an RC ring beam at the roof and the plenum box tying it to the shaft's walls; self-weight #r1(calc.min(..variants.map(weight))) – #r1(calc.max(..variants.map(weight))) kN; the wind (assumed q #q-wind kN/m², Cf #cf) gives #r1(calc.min(..variants.map(wind-F))) – #r1(calc.max(..variants.map(wind-F))) kN and #r1(calc.min(..variants.map(wind-M))) – #r1(calc.max(..variants.map(wind-M))) kN·m at the roof: modest, but the slender variants need starter bars from the slab and a check of the slab's local bending. #text(fill: amber)[To confirm with SBC 301 wind data.]
  ],
)

// ======================================================================= PAGE 3 · the variants, elevations
#pagebreak()
#text(12pt, weight: "bold", fill: green)[The variants · north and east elevations (the roof zone, 1 m = 0.58 cm) · heights above the attic coping #lv(attic-top)]
#v(2pt)
#text(7pt, fill: gray)[References (owner): the Yazd badgirs, e.g. the "father's home" windcatcher in Ashkezar: a tall slim tower with a plain stone shaft, a cornice band, a head with many slender vertical openings (ribs) on each face and a simple crowning cornice. Heads: *(a)* one semicircular (Roman) arch per face; *(b)* the Yazd type, #tw.b-n slender slots #tw.b-w m wide per face between ribs; *(c)* #tw.c-n slots #tw.c-w m wide, each with a small semicircular top, linking them to the house's arches (the courtyard arcade, the enclosure windows). Tops: a flat Hijazi cornice (two plain steps) or a small dome. The red tick: what is seen from the gate begins above it.]
#v(3pt)
#grid(columns: (1fr, 1fr, 1fr), gutter: 6pt, row-gutter: 8pt,
  ..variants.map(v => block(stroke: 0.4pt + luma(190), inset: 4pt, radius: 2pt, width: 100%)[
    #text(7.6pt, weight: "bold", fill: green)[#v.name] \
    #align(center, elevations(v))
    #text(6.2pt)[top #lv(total-top(v)) (#r2(total-top(v) + 0.3) m above the ground) · #r2(h-exp(v)) m above the roof, proportion #r1(h-exp(v) / tw.w) : 1 (#r1((total-top(v) - attic-top) / tw.w) : 1 above the attic) · #slots(v) opening#if slots(v) > 1 [s] per face, #r2(face-free(v)) m² free · seen from the gate #r2(total-top(v) - z-hide-gate) m · from the courtyard #if total-top(v) > z-hide-court [its top #r2(total-top(v) - z-hide-court) m] else [not seen]]
  ])
)

// ======================================================================= PAGE 4 · the renders
#pagebreak()
#text(12pt, weight: "bold", fill: green)[From the gate · the same camera as char_gate.png (the north facade from just inside the farm's main gate)]
#v(2pt)
#text(7pt, fill: gray)[3D: `3d/malqaf_variants.py` (the current model with the present head and its HRV base taken out, the roofline rebuilt, the variant added; the plant room and the plenum built but hidden behind the attic and the coping). Style study, provisional; the stone colours of the character palette.]
#v(3pt)
#grid(columns: (1fr, 1fr, 1fr), gutter: 6pt, row-gutter: 6pt,
  ..variants.map(v => [
    #box(stroke: 0.4pt + luma(190), image("../3d/output/malqaf_gate_" + v.id + ".png", width: 8.9cm))   // the renders are cropped to the tower and the north facade by 3d/malqaf_variants.py
    #std.v(1pt) #text(7.2pt, weight: "bold", fill: green)[#v.name] #text(6.4pt, fill: gray)[ · top #lv(total-top(v))]
  ])
)

// ======================================================================= PAGE 5 · the comparison
#pagebreak()
#text(12pt, weight: "bold", fill: green)[The comparison and the recommendation]
#v(3pt)
#table(columns: (1.5fr, auto, auto, auto, auto, auto, auto, auto, auto, auto, 2.2fr), inset: 2.4pt, stroke: 0.4pt + luma(175), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f3f1ea") },
  [*Variant*], [*Top*], [*Prop.*], [*Free / face*], [*Breeze*], [*Seen: gate*], [*Seen: court*], [*Weight*], [*Wind M*], [*Cost*], [*Reading*],
  ..variants.map(v => (
    [#v.name], [#lv(total-top(v))], [#r1(h-exp(v) / tw.w) : 1], [#r2(face-free(v)) m²], [#r2(breeze-index(v))], [#r2(total-top(v) - z-hide-gate) m], [#if total-top(v) > z-hide-court [#r2(total-top(v) - z-hide-court) m] else [–]], [#r1(weight(v)) kN], [#r1(wind-M(v)) kN·m], [#r2(cost(v) / cost(variants.at(5)))],
    [#if v.id == "b25" [true Yazd language; compact: a lantern on the attic] else if v.id == "b35" [the closest to the Ashkezar reference: a real tower; the many dark slots read strongly] else if v.id == "c25" [the house's arches in miniature; a little short for the slots] else if v.id == "c35" [*slim, tall, tied to the house's arches: the symbol of the house*] else if v.id == "c25d" [the dome reads as a minaret / a shrine: foreign to a Hijazi house] else [one arch per face: a lookout or a belfry, not a windcatcher]],
  )).flatten()
)
#text(6.4pt, fill: gray)[*Top:* the highest point (the dome's crown). *Prop.:* the height above the roof finish to the width. *Free / face:* the openings of one face (the bird mesh lets 90 % through). *Breeze:* the courtyard breeze in the same wind relative to the present head (1.00): the head's higher, freer wind (a power law 0.20 with height) and its entry loss in the air study's loss chain (the 0.10 m² throat under the maid bath dominates, so the head changes the breeze only by a few per cent); the stack in still air grows with the height about as much. *Seen:* the visible height from the gate (above #lv(z-hide-gate), over the north coping) and from the courtyard's south edge (above #lv(z-hide-court), over the roof's edge). *Weight:* the tower above the roof finish. *Wind M:* the overturning moment at the roof (assumed wind). *Cost:* relative to (a) at 2.5 m (stone, the ribs and the arched tops, the height); the plant room and the plenum are common to all.]
#v(4pt)
#grid(columns: (1.25fr, 1fr), gutter: 12pt,
  [
    #H[6 · Recommendation]
    - *Inside: the slim shaft along the cut wall* (§ 2): the walls of the maid bath and bedroom 1 straight, one wall parallel to the cut, the tip a solid pier, the store and the cupboard north of y 1.0; cleaned from the roof and from one panel in the maid bath; the HRV unit in its plant room behind the attic.
    - *Above the roof: (c) at 3.5 m above the attic coping with the flat Hijazi cornice* (top #lv(total-top(variants.at(3)))): slim (#r1(h-exp(variants.at(3)) / tw.w) : 1 above the roof), set back on the attic's corner, a plain honey-stone shaft, a cornice band, #tw.c-n slender openings per face each with a small semicircular top (the house's arches in small), the bird mesh behind them, a two-step crowning cornice. It is the one that reads as *a real malqaf and the symbol of the house*: from the gate #r2(total-top(variants.at(3)) - z-hide-gate) m of it stands above the coping, and from the courtyard its crown just shows over the north roof (#r2(total-top(variants.at(3)) - z-hide-court) m). Breeze ≈ #r2(breeze-index(variants.at(3))) of today's; cost ≈ #r2(cost(variants.at(3)) / cost(variants.at(5))) × the simplest.
    - *If the owner prefers the pure Yazd language:* (b) at 3.5 m, the same tower with straight slots. *If a lower tower is wanted:* (c) at 2.5 m. *Not recommended:* the dome (it reads as a minaret or a shrine, foreign to a Hijazi house) and the single arch (a lookout, not a windcatcher; its one big opening per face is the least "malqaf").
    - *Next:* the owner chooses; then the design files (the shaft and the rooms in the CSVs and the studies, the plant room, the roof, the structure, the 3D) in one work round, the MEP engineer's check of the breeze and the HRV ducts, the structural engineer's of the tower on the slab.
  ],
  [
    #H[ملخص]
    #block(width: 100%)[#set text(lang: "ar", dir: rtl, font: ("Segoe UI", "Arial"), size: 8.6pt)
      #set par(leading: 0.62em)
      *في الداخل:* مجرى رفيع بعمق 0.575 م يحاذي جدار القطع (≈ 0.90 م² صافيا: مجرى النسيم 0.54 م² وحجرة الخدمة 0.30 م² بينهما فاصل محكم)، فيصبح لكل من حمام الخادمة وغرفة النوم 1 جدار مستقيم واحد موازٍ للقطع بلا زوايا غريبة، ويُستفاد من الطرف الشمالي مخزنا للحمام ودولابا لغرفة النوم. التنظيف دون دخول: من السطح (شبك الطيور على أدراج تُنزَل إلى فتحة صغيرة، والمخمد العلوي من الفتحة نفسها) ومن فتحة صيانة 0.40 × 0.40 م عند قاعدة المجرى من حمام الخادمة، ولا فتحة في غرفة النوم.
      #v(2pt)
      *فوق السطح:* تُنقل وحدة التهوية إلى غرفة معدات صغيرة خلف العلّية لا تُرى، ويرتفع البرج نحيلا مربعا 1.25 × 1.25 م من الحجر العسلي، مرتدا عن حافة الواجهة على زاوية العلّية. *التوصية:* الرأس (ج) بفتحات رأسية نحيلة لكل منها قوس نصف دائري صغير، بارتفاع 3.5 م فوق غطاء العلّية مع كورنيش حجازي مسطح: ملقف حقيقي ورمز للبيت. البديل: (ب) فتحات يزدية مستقيمة. لا يُنصح بالقبة ولا بالقوس الواحد.
    ]
  ],
)
#v(3pt)
#text(6.2pt, fill: gray)[Sources: studies/air_system.typ (the present tower, its sections and the breeze loss chain), studies/roof.typ (the attic, the copings, the sight lines), data/rooms_gf.csv / rooms_ff.csv (V9.2), 3d/character.yaml (the gate camera). Concept only: every size assumed; nothing here is for construction.]

// ======================================================================= PAGES 6–7 · WHERE THE TOWER STANDS (location study, 8 Nov 2026; study only)
// Four candidate positions, each with the same slim shaft (≈ 0.90 m² clear, rectangular, straight walls) and the recommended tower (c) at 3.5 m:
// L1 the north-east cut corner (pages 1–5) · L2 the courtyard's north-east corner (in the women's majlis's south-east corner, against its solid east wall W3)
// L3 the west band, beside the west service shaft (in the utility room) · L4 over the kitchen, against its north wall (the east band).
// The kitchen-side and riwaq-side spots at the courtyard were looked at and dropped: the kitchen's west wall carries the sink window, the water + tree
// enclosure and the outdoor TV, and its first floor is the suite lobby (1.35 m wide); the riwaq is the family's circulation under the gallery.
#let plen(P) = range(P.len() - 1).map(i => d2(P.at(i), P.at(i + 1))).sum()
#let rect4(x0, y0, x1, y1) = ((x0, y0), (x1, y0), (x1, y1), (x0, y1))
#let rec-v = variants.at(3)                                   // the recommended tower (c) at 3.5 m
#let L-top = total-top(rec-v)
#let vents = ((0.75, 9.8, 8.0), (13.2, 8.4, 8.0), (1.5, 14.9, 8.0))   // the plumbing vents above the roof: the west shaft's stack, the east stack, the family WC's stack (studies/plumbing.typ)
#let z2b = (condensers.at(0), condensers.at(1), condensers.at(2), condensers.at(3), 7.9)
#let d-box(p, b) = { let q = (calc.max(b.at(0), calc.min(p.at(0), b.at(2))), calc.max(b.at(1), calc.min(p.at(1), b.at(3))), b.at(4)); d3(p, q) }
#let locs = (
  (id: "L1", name: [L1 · the north-east cut corner (today; pages 1–5)], short: [L1 · NE cut corner],
   shaft: sh-clear, encl: sh-axes, tower: (tw.x0, tw.y0), plenum: true, throat: true,
   route: ((10.674, 1.25), (10.45, 2.0), (10.2, 2.8), (10.2, 10.5), (9.2, 10.5), (8.95, 10.5)), grille: (8.95, 10.05, 8.95, 11.05),
   rooms: [GF maid bath #r2(clear(bath) - now.bath) m² (+ a store #r2(clear(store))) · FF bedroom 1 #r2(clear(bed1) - now.bed1) m² (+ a cupboard #r2(clear(cup)))], walls: [straight: one wall parallel to the cut per room + a square return],
   structure: [on the roof slab over W3 and a new RC wall y 1.0; a plenum box ties it to the shaft (offset 0.3–1.0 m)], roof: [the attic's NE corner; the plant room behind it; Z2b, the tank, the PV untouched], cost: 1.00),
  (id: "L2", name: [L2 · the courtyard's north-east corner (the women's majlis's SE corner)], short: [L2 · courtyard NE corner],
   shaft: rect4(8.275, 4.835, 8.85, 6.40), encl: rect4(8.075, 4.635, 8.95, 6.5), tower: (7.70, 5.25), plenum: false, throat: false,
   route: ((8.56, 6.10), (6.90, 6.10), (6.90, 6.5)), grille: (6.40, 6.5, 7.40, 6.5),
   rooms: [GF women's majlis −1.37 m² (a nib in its SE corner; its courtyard glass ends 0.1 m sooner) · FF family living −1.37 m² (a nib in its SE corner by the courtyard glass)], walls: [straight: a rectangular nib against W3 in each room],
   structure: [*the best:* on the crossing of W3 (x 8.95) and the courtyard's north wall line (y 6.5), straight over its shaft, no plenum, no transfer], roof: [the sky hole's NE corner, inside the attic; the guard meets the tower; Z2b 1.9 m east (an intake ≥ 2 m away)], cost: 0.85),
  (id: "L3", name: [L3 · the west band, beside the west service shaft (the utility room)], short: [L3 · west band],
   shaft: rect4(1.60, 9.30, 2.65, 10.30), encl: rect4(1.5, 9.2, 2.75, 10.4), tower: (0.875, 9.175), plenum: true, throat: false,
   route: ((2.10, 9.80), (4.25, 9.80)), grille: (4.25, 9.3, 4.25, 10.3),
   rooms: [GF utility room −1.2 m² (5.81 → ≈ 4.6) · FF *bedroom 2's en-suite −1.2 m²* (5.85 → ≈ 4.4 on axes): its fixtures stand on that very service wall], walls: [straight (the bay between the west shaft, the riwaq wall and the utility's south wall)],
   structure: [on the west outer wall and the shaft's walls: good], roof: [the west strip; *the west stack's vent beside the intake: re-route it ≥ 3 m away*], cost: 0.95),
  (id: "L4", name: [L4 · over the kitchen, against its north wall (the east band)], short: [L4 · kitchen, east band],
   shaft: rect4(10.75, 7.10, 12.315, 7.675), encl: rect4(10.65, 7.0, 12.415, 7.775), tower: (11.0, 7.0), plenum: false, throat: false,
   route: ((11.50, 7.40), (10.2, 7.40), (10.2, 10.5), (9.2, 10.5), (8.95, 10.5)), grille: (8.95, 10.05, 8.95, 11.05),
   rooms: [GF kitchen −1.4 m² *and the route from the laundry to the service door closed (0.3 m left)* · FF *a box standing in the middle of the master suite's bath*], walls: [straight in the kitchen; not in the suite bath],
   structure: [the kitchen's north wall is a non-load-bearing partition: a new RC wall and footing], roof: [*inside Z2b (the condensers move) and 3 m from the east vent*; the future PV], cost: 1.15),
)
#let zeta-loc(l) = { let z = zeta-throat
  z.at(0).at(1) + z.at(1).at(1) + z.at(2).at(1) + z.at(5).at(1) + z.at(6).at(1) + (if l.throat { z.at(3).at(1) } else { 0 }) + 0.02 * plen(l.route) / 0.33 * calc.pow(0.10 / 0.18, 2) + (if l.plenum { 1.2 * calc.pow(0.10 / 0.60, 2) } else { 0 }) }
#let breeze-loc(l) = calc.sqrt(zeta / zeta-loc(l))
#let L1-better = calc.sqrt(zeta / (zeta-loc(locs.at(0)) - zeta-throat.at(3).at(1)))   // L1 with the channel at its full 0.9 × 0.2 under the re-planned maid bath (no throat)
#let tsq(l) = rect4(l.tower.at(0), l.tower.at(1), l.tower.at(0) + tw.w, l.tower.at(1) + tw.w)
#let intake-l(l) = (l.tower.at(0), l.tower.at(1) + tw.w / 2, lev(rec-v).band0 - 0.25)
#let vent-d(l) = calc.min(..vents.map(v => d3(intake-l(l), v)))
#let z2b-d(l) = d-box(intake-l(l), z2b)
// what is seen: the tower's nearest point to an eye, the obstacles crossed on the way (copings, attic, the courtyard's roof edges)
#let near(e, l) = (calc.max(l.tower.at(0), calc.min(e.at(0), l.tower.at(0) + tw.w)), calc.max(l.tower.at(1), calc.min(e.at(1), l.tower.at(1) + tw.w)))
#let obst-out = (("y", -0.125, -0.125, 10.6, coping-top), ("x", -0.125, -0.125, 19.25, coping-top), ("y", 0.875, 0.875, 9.94, attic-top), ("x", 0.875, 0.875, 19.25, attic-top), ("x", 13.436, 5.2, 24.1, coping-top))
#let obst-court = (("y", 6.5, 5.8, 8.95, 7.30), ("x", 8.95, 6.5, 13.0, 7.30), ("x", 5.8, 6.5, 13.0, 7.30))
#let z-hide(e, l, obst) = { let t0 = near(e, l); let zs = (roof-fin,)
  for (ax, c, lo, hi, z) in obst {
    let (ei, ti, ej, tj) = if ax == "y" { (e.at(1), t0.at(1), e.at(0), t0.at(0)) } else { (e.at(0), t0.at(0), e.at(1), t0.at(1)) }
    if calc.abs(ti - ei) > 1e-9 { let t = (c - ei) / (ti - ei)
      if t > 1e-6 and t < 1 - 1e-6 { let w = ej + t * (tj - ej); if w >= lo and w <= hi { zs.push(e.at(2) + (z - e.at(2)) / t) } } } }
  calc.max(..zs) }
#let seen(e, l, obst) = calc.max(0, L-top - z-hide(e, l, obst))
#let eye-street = (6.5, -14.0, 1.6)                           // the north street's far side, 14 m off the north facade
#let eye-court = (7.4, 13.0, 1.6)                             // the courtyard's south edge (the living's glass), looking north
#let loc-checks = (
  ([every position's shaft ≥ 0.90 m² clear, a rectangle in straight walls], locs.all(l => area(l.shaft) >= 0.895)),
  ([the breeze routes measured from the shaft's foot to the grille (L1 the longest, #r1(plen(locs.at(0).route)) m)], plen(locs.at(0).route) == calc.max(..locs.map(l => plen(l.route)))),
  ([the recommended position keeps the HRV intake ≥ 3 m from every vent and ≥ 2 m from the condensers], vent-d(locs.at(0)) >= 3.0 and z2b-d(locs.at(0)) >= 2.0),
  ([the recommended tower is seen from the gate and from the street], seen(gate-eye, locs.at(0), obst-out) > 2.0 and seen(eye-street, locs.at(0), obst-out) > 2.0),
)
#let loc-ok = loc-checks.all(c => c.at(1))
// the key plans
#let parse-pts(s) = s.split(";").map(t => t.trim()).filter(t => t != "").map(t => { let w = t.split(" ").filter(u => u != ""); (float(w.at(0)), float(w.at(1))) })
#let rooms-of(path) = csv(path, row-type: dictionary).filter(r => r.name != "" and not r.name.starts-with("#")).map(r => if r.pts.trim() != "" { parse-pts(r.pts) } else {
  let x = float(r.x); let y = float(r.y); let w = float(r.w); let d = float(r.d); rect4(x - w / 2, y - d / 2, x + w / 2, y + d / 2) })
#let loc-col = (L1: rgb("#1f7a99"), L2: rgb("#2f7a3f"), L3: rgb("#8a5a2b"), L4: rgb("#b5452f"))
#let key-plan(kind) = cetz.canvas(length: 0.43cm, {
  import cetz.draw: *
  let Q(p) = (p.at(0), -p.at(1))
  line(..((0, 0), (10.461, 0), (13.311, 5.245), (13.311, 24.0), (0, 24.0)).map(Q), close: true, fill: rgb("#f3efe6"), stroke: 1.2pt + ink)
  if kind == "GF" {
    for P in rooms-of("../data/rooms_gf.csv") { line(..P.map(Q), close: true, stroke: 0.3pt + gray) }
    rect(Q((4.25, 6.5)), Q((8.95, 13.0)), fill: rgb("#dfe9d3"), stroke: 0.4pt + gray); content(Q((6.6, 9.9)), text(4.4pt, fill: green)[COURTYARD])
    rect(Q((5.925, 7.1)), Q((8.85, 12.3)), stroke: (paint: amber, thickness: 0.4pt, dash: "dashed")); content(Q((6.7, 11.9)), text(3.4pt, fill: amber)[seating])
    for l in locs { let c = loc-col.at(l.id)
      line(..l.encl.map(Q), close: true, fill: c.transparentize(55%), stroke: 0.6pt + c)
      line(..l.route.map(Q), stroke: (paint: c, thickness: 1pt, dash: "dashed"))
      line(Q((l.grille.at(0), l.grille.at(1))), Q((l.grille.at(2), l.grille.at(3))), stroke: 2.6pt + c)
      content(Q((l.encl.at(0).at(0) - 0.15, l.encl.at(0).at(1) + 0.4)), anchor: "east", text(6pt, weight: "bold", fill: c)[#l.id]) }
    content(Q((0.0, 24.9)), anchor: "west", text(4.6pt, fill: green)[GROUND FLOOR · shafts, breeze routes (dashed), grilles (bold)])
  } else {
    line(..((0.875, 0.875), (attic.at(1).at(0), 0.875), (attic.at(2).at(0), attic.at(2).at(1)), (attic.at(2).at(0), 19.25), (0.875, 19.25)).map(Q), close: true, stroke: 1.4pt + rgb("#c9bfa8"))
    rect(Q((5.8, 6.5)), Q((8.95, 13.0)), fill: white, stroke: 0.5pt + gray); content(Q((7.4, 9.75)), text(4pt, fill: gray)[sky])
    rect(Q((4.25, 19.25)), Q((10.0, 24.0)), fill: white, stroke: 0.4pt + gray); content(Q((7.1, 21.6)), text(4pt, fill: gray)[suite court])
    rect(Q((condensers.at(0), condensers.at(1))), Q((condensers.at(2), condensers.at(3))), fill: rgb("#f6d9c9"), stroke: 0.4pt + red); content(Q((11.0, 8.6)), text(3.6pt, fill: red)[Z2b AC])
    rect(Q((2.85, 1.0)), Q((4.15, 3.5)), fill: rgb("#dbe7ec"), stroke: 0.3pt + gray); content(Q((3.5, 2.25)), text(3.4pt)[tank])
    rect(Q((9.0, 9.5)), Q((11.6, 17.4)), fill: rgb("#fff4c9"), stroke: 0.3pt + gray); content(Q((10.3, 13.4)), text(3.4pt)[PV])
    for vt in vents { circle(Q(vt), radius: 3.0, stroke: (paint: luma(150), thickness: 0.4pt, dash: "dotted")); circle(Q(vt), radius: 0.12, fill: luma(90), stroke: none) }
    content(Q((0.5, 13.3)), anchor: "west", text(3.4pt, fill: luma(110))[vents: 3 m rings])
    for l in locs { let c = loc-col.at(l.id)
      line(..tsq(l).map(Q), close: true, fill: stone, stroke: 0.8pt + c)
      content(Q((l.tower.at(0) + tw.w / 2, l.tower.at(1) + tw.w / 2)), text(5.6pt, weight: "bold", fill: c)[#l.id]) }
    content(Q((0.0, 24.9)), anchor: "west", text(4.6pt, fill: green)[ROOF · towers 1.25 × 1.25, attic, Z2b, vents])
  }
})

#pagebreak()
#text(12pt, weight: "bold", fill: green)[Where the tower stands · four positions compared (the same slim shaft, the recommended tower (c) at 3.5 m, top #lv(L-top))]
#v(2pt)
#text(7pt, fill: gray)[STUDY ONLY, the design files unchanged. Looked at and dropped before the four: *the courtyard's kitchen side* (the kitchen's west wall carries the sink window, the water + tree enclosure and the outdoor TV; upstairs the suite lobby is only 1.35 m wide) and *the riwaq side* (the family's circulation under the gallery). Prevailing wind: north-west. Both key plans: 1 m = 0.43 cm.]
#v(3pt)
#grid(columns: (auto, auto, 1fr), gutter: 10pt,
  key-plan("GF"), key-plan("ROOF"),
  [
    #for l in locs [
      #text(8pt, weight: "bold", fill: loc-col.at(l.id))[#l.name] \
      #text(6.6pt)[*Breeze:* #r1(plen(l.route)) m from the shaft's foot to the grille#if l.throat [ (through the 0.10 m² throat under the maid bath)], ≈ #r2(breeze-loc(l)) × today's flow. *Intake:* #r1(vent-d(l)) m to the nearest vent (≥ 3), #r1(z2b-d(l)) m to the condensers (≥ 2). *Rooms:* #l.rooms. *Walls:* #l.walls. *Structure:* #l.structure. *Roof:* #l.roof. *Seen:* from the gate #r2(seen(gate-eye, l, obst-out)) m, from the street #r2(seen(eye-street, l, obst-out)) m, from the courtyard #r2(seen(eye-court, l, obst-court)) m. *Cost:* ≈ #r2(l.cost).]
      #std.v(3pt)
    ]
  ],
)
#v(1pt)
#text(6.2pt, fill: gray)[Location checks #if loc-ok [*passed* (#loc-checks.len())] else [*FAILED*: #loc-checks.filter(c => not c.at(1)).map(c => c.at(0)).join([; ])] · *Breeze:* the air study's loss chain (the head, the flaps, the damper, the bend and the plenum, the grille, the channel's friction by its length, the throat where there is one, the extra plenum where the tower is offset), the same head and wind for all: relative flows. *Seen:* the height of the tower (top #lv(L-top)) above the sight line from the gate (the char_gate camera), from the north street 14 m off the facade and from the courtyard's south edge, over the copings, the attic and the courtyard's roof edges. *Cost:* relative to L1 (the shaft, the channel, the plenum, the structure, the knock-on moves), the tower itself the same.]

#pagebreak()
#text(12pt, weight: "bold", fill: green)[The location comparison and the recommendation]
#v(3pt)
#let mark(ok) = if ok == 2 { text(fill: green)[●] } else if ok == 1 { text(fill: amber)[◐] } else { text(fill: red)[○] }
#table(columns: (1.35fr, auto, auto, auto, auto, auto, auto, auto, auto, auto), inset: 2.6pt, stroke: 0.4pt + luma(175), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f3f1ea") },
  [*Position*], [*Breeze route*], [*Breeze*], [*Intake*], [*Rooms / walls*], [*Structure*], [*Roof*], [*Gate · street*], [*Courtyard*], [*Cost*],
  ..locs.map(l => (
    text(weight: "bold", fill: loc-col.at(l.id))[#l.short],
    [#r1(plen(l.route)) m], [#mark(if breeze-loc(l) >= 1.4 { 2 } else { 1 }) #r2(breeze-loc(l))#if l.throat [ (#r2(L1-better) without the throat)]],
    [#mark(if vent-d(l) >= 3 and z2b-d(l) >= 2 { 2 } else { 0 }) #r1(vent-d(l)) / #r1(z2b-d(l)) m],
    [#mark(if l.id == "L1" { 2 } else if l.id == "L2" { 1 } else { 0 }) #if l.id == "L1" [service rooms] else if l.id == "L2" [two family rooms] else if l.id == "L3" [an en-suite bath] else [suite bath, service route]],
    [#mark(if l.id == "L2" or l.id == "L3" { 2 } else if l.id == "L1" { 1 } else { 0 })],
    [#mark(if l.id == "L1" or l.id == "L2" { 2 } else if l.id == "L3" { 1 } else { 0 })],
    [#mark(if seen(gate-eye, l, obst-out) > 2 { 2 } else if seen(eye-street, l, obst-out) > 2 { 1 } else { 0 }) #r1(seen(gate-eye, l, obst-out)) · #r1(seen(eye-street, l, obst-out)) m],
    [#mark(if seen(eye-court, l, obst-court) > 2 { 2 } else if seen(eye-court, l, obst-court) > 0.5 { 1 } else { 0 }) #r1(seen(eye-court, l, obst-court)) m],
    [#r2(l.cost)],
  )).flatten()
)
#text(6.2pt, fill: gray)[● good · ◐ acceptable / with a price · ○ poor or blocking. Breeze: the relative courtyard flow (today = 1.00). Intake: the distance to the nearest plumbing vent / to the condensers. Gate · street, courtyard: the visible height of the tower (m).]
#v(5pt)
#grid(columns: (1.25fr, 1fr), gutter: 12pt,
  [
    #H[7 · Recommendation: keep the tower at the north-east cut corner (L1)]
    - *L1 is the best all round:* it takes only service space (the maid bath and bedroom 1 each lose ≈ 0.8 m², each gains a store or a cupboard), keeps every family and guest room whole, gives the cleanest HRV intake (#r1(vent-d(locs.at(0))) m from the nearest vent, #r1(z2b-d(locs.at(0))) m from the condensers), leaves the roof's zones in place and is *the one seen as the symbol of the house from outside*: #r1(seen(gate-eye, locs.at(0), obst-out)) m of the tower above the coping from the gate, #r1(seen(eye-street, locs.at(0), obst-out)) m from the street, its crown from the courtyard (#r1(seen(eye-court, locs.at(0), obst-court)) m).
    - *Its one weakness, the long breeze route (#r1(plen(locs.at(0).route)) m), is mostly the throat, not the length:* with the channel kept at its full 0.9 × 0.2 under the re-planned maid bath (the WC and the shower drains off its line, in the interior study), the flow rises from #r2(breeze-loc(locs.at(0))) to *#r2(L1-better)* × today's, close to the #r2(breeze-loc(locs.at(1))) of the courtyard corner.
    - *L2, the courtyard corner, is the strong alternative* and the true Yazd position (the badgir over the hall, facing the courtyard): the shortest route (#r1(plen(locs.at(1).route)) m) straight onto the seating, the best structure (on W3 and the courtyard wall, no plenum), the cheapest, and #r1(seen(eye-court, locs.at(1), obst-court)) m of the tower rising over the courtyard's corner; *but* it takes ≈ 1.4 m² as a nib from the women's majlis and from the family living, and it is *not seen from the gate* (#r1(seen(gate-eye, locs.at(1), obst-out)) m), only from the street (#r1(seen(eye-street, locs.at(1), obst-out)) m). Choose it if the tower is to be the symbol of the courtyard rather than of the house's face.
    - *Not recommended:* L3 (it costs bedroom 2's en-suite its service wall and sits on the west stack's vent) and L4 (it closes the kitchen's route to the service door, stands in the master suite's bath and lands in the condensers' zone).
    - *So:* the tower of pages 1–5 at L1, with the channel at its full width; the plan, the elevations and the gate render of pages 1–4 stand, and no new renders are needed for the position.
  ],
  [
    #H[ملخص الموقع]
    #block(width: 100%)[#set text(lang: "ar", dir: rtl, font: ("Segoe UI", "Arial"), size: 8.6pt)
      #set par(leading: 0.62em)
      قورنت أربعة مواقع للملقف: الركن الشمالي الشرقي عند جدار القطع (الحالي)، وركن الفناء الشمالي الشرقي داخل مجلس النساء، والشريط الغربي بجوار شفت الخدمات، وفوق المطبخ في الشريط الشرقي.
      #v(2pt)
      *التوصية:* إبقاء البرج في الركن الشمالي الشرقي: لا يأخذ إلا من غرف الخدمة، ومدخل هواء التهوية فيه الأنظف، ويُرى من البوابة والشارع رمزا للبيت. ضعفه الوحيد طول مجرى النسيم (≈ 10.6 م)، وأكثر خسارته من الاختناق تحت حمام الخادمة؛ فإذا بقي المجرى بعرضه الكامل ارتفع التدفق إلى ما يقارب موقع الفناء.
      #v(2pt)
      *البديل القوي:* ركن الفناء (موقع الملقف اليزدي الأصيل): أقصر مجرى، وأفضل إنشائيا وأرخص، ويظهر البرج فوق ركن الفناء؛ لكنه يأخذ نحو 1.4 م² من مجلس النساء ومن جلسة العائلة ولا يُرى من البوابة. لا يُنصح بالشريط الغربي ولا بالمطبخ.
    ]
  ],
)

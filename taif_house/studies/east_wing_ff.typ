// east_wing_ff.typ · Taif / Palm House · STUDY (11 Nov 2026, owner): the WHOLE first-floor east wing re-designed as one · the master suite (lobby, bedroom, bath,
// WC, dressing, the court access), bedroom 1 (the young children's room) with its own compact en-suite, and the family link between them.
// 11 Nov 2026 (later): pages 5–6 add the owner's kids'-bath options K1 / K2 / K3 (bedroom 1 keeps its size; the relaxed hood rule).
// FIXED: every column and beam (studies/structure.typ), the outer walls (north, east, the cut), the stair / lift / gallery / family living / bedrooms 2–3 / office,
// the suite court with its mashrabiya and winter seat; every wet room over wet / service rooms below (the maid's wing, the laundry, the kitchen) and never over the
// kitchen's hood zone or a habitable room; straight walls, no jogs. FREE: every partition and door. WINDOWS: provisional marks only (the owner sets them with the facades).
// Nothing in the design files is changed by this study. CSV frame (data/rooms_ff.csv): x east, y south, wall centre lines; interior walls 0.20, the outer walls 0.25.
#import "@preview/cetz:0.4.2"
#import "../base.typ": dist

#set page(paper: "a4", flipped: true, margin: 8mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 7.2pt)
#set par(leading: 0.4em)
#let ink = rgb("#3d4a45"); #let accent = rgb("#2f6b4f"); #let red = rgb("#b5452f"); #let blue = rgb("#2f5f8a"); #let amber = rgb("#c98a12"); #let gray = rgb("#6d736f"); #let brown = rgb("#8a5a2b")
#let H(t) = block(above: 5pt, below: 2.5pt, text(8.8pt, weight: "bold", fill: accent, t))
#let r2(v) = { let s = str(calc.round(v, digits: 2)); if not s.contains(".") { s + ".00" } else if s.split(".").at(1).len() == 1 { s + "0" } else { s } }
#let r1(v) = str(calc.round(v, digits: 1))
#let ah(t) = text(font: ("Segoe UI", "Arial", "Tahoma"), lang: "ar", dir: rtl, t)

// ---------- fixed geometry ----------
#let W = 13.311                                                      // the east wall
#let cut-a = (10.461, 0); #let cut-b = (13.311, 5.245)               // the cut wall (RC; C30, C31, C32)
#let cut-x(y) = cut-a.at(0) + y * (cut-b.at(0) - cut-a.at(0)) / cut-b.at(1)
#let cut-cos = cut-b.at(1) / dist(cut-a, cut-b)
#let cut-in(y) = cut-x(y) - 0.125 / cut-cos                          // the cut's inner face in x
#let columns = (("C24", (8.95, 0)), ("C25", (8.95, 3.0)), ("C26", (8.95, 6.5)), ("C27", (8.95, 13.0)), ("C28", (8.95, 19.25)), ("C30", (10.461, 0)), ("C31", (11.982, 2.8)), ("C32", (13.311, 5.245)), ("C33", (13.311, 10.45)), ("C34", (13.311, 13.0)), ("C35", (13.311, 19.25)))
#let beams = (("B6", (8.95, 6.5), (13.311, 6.5), "drop 0.25×0.45"), ("B7", (8.95, 13.0), (13.311, 13.0), "hidden 0.30"), ("B8", (8.95, 19.25), (13.311, 19.25), "drop 0.25×0.45"), ("B5", (8.95, 13.0), (8.95, 19.25), "drop 0.25×0.55"))
#let struct-lines-x = (8.95, 13.311)                                 // wall lines that ARE structure (plus the cut)
#let struct-lines-y = (0, 6.5, 13.0, 19.25)                          // beam lines; the column-only lines 3.0 (C25), 5.245 (C32), 10.45 (C33) count as "close"
#let column-lines-y = (3.0, 5.245, 10.45)
#let east-stack = (13.311, 7.05)                                     // the suite's stack outside the east wall (studies/plumbing.typ)
#let hood = (12.4, 10.1, 13.311, 11.3)                               // the kitchen's hob + hood on the east wall (studies/east_wing.typ: y 10.2–11.2) + 0.1
#let gf-below = (
  (((8.95, 0), (10.461, 0), (12.1996, 3.2), (10.65, 3.2), (10.65, 4.7), (8.95, 4.7)), [GF maid room · habitable], false),
  (((10.65, 3.2), (12.1996, 3.2), (13.0148, 4.7), (10.65, 4.7)), [GF maid bath · wet], true),
  (((8.95, 4.7), (13.0148, 4.7), (13.311, 5.245), (13.311, 6.5), (8.95, 6.5)), [GF laundry · wet], true),
  (((8.95, 6.5), (13.311, 6.5), (13.311, 13.0), (8.95, 13.0)), [GF kitchen · service], true),
  (((8.95, 13.0), (13.311, 13.0), (13.311, 19.25), (8.95, 19.25)), [GF living · dining · HABITABLE], false),
)
#let rect-pts(x0, y0, x1, y1) = ((x0, y0), (x1, y0), (x1, y1), (x0, y1))

// ---------- helpers ----------
#let area(P) = calc.abs(range(P.len()).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, P.len())); a.at(0) * b.at(1) - b.at(0) * a.at(1) }).sum()) / 2
#let inset(P, d) = {
  let n = P.len()
  let lines = range(n).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, n)); let (dx, dy) = (b.at(0) - a.at(0), b.at(1) - a.at(1)); let L = calc.sqrt(dx * dx + dy * dy); ((a.at(0) - dy / L * d.at(i), a.at(1) + dx / L * d.at(i)), (dx, dy)) })
  range(n).map(i => { let (p1, v1) = lines.at(calc.rem(i + n - 1, n)); let (p2, v2) = lines.at(i); let den = v1.at(0) * v2.at(1) - v1.at(1) * v2.at(0); let t = ((p2.at(0) - p1.at(0)) * v2.at(1) - (p2.at(1) - p1.at(1)) * v2.at(0)) / den; (p1.at(0) + v1.at(0) * t, p1.at(1) + v1.at(1) * t) })
}
#let is-cw(P) = range(P.len()).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, P.len())); a.at(0) * b.at(1) - b.at(0) * a.at(1) }).sum() > 0
#let cw(P) = if is-cw(P) { P } else { P.rev() }
#let on-cut(a, b) = calc.abs(a.at(0) - cut-x(a.at(1))) < 0.02 and calc.abs(b.at(0) - cut-x(b.at(1))) < 0.02 and a.at(1) <= 5.245 + 1e-6 and b.at(1) <= 5.245 + 1e-6
#let half(a, b) = { let outer = (calc.abs(a.at(1)) < 1e-6 and calc.abs(b.at(1)) < 1e-6) or (calc.abs(a.at(0) - W) < 1e-6 and calc.abs(b.at(0) - W) < 1e-6) or on-cut(a, b); if outer { 0.125 } else { 0.10 } }
#let clear(P) = { let Q = cw(P); area(inset(Q, range(Q.len()).map(i => half(Q.at(i), Q.at(calc.rem(i + 1, Q.len())))))) }
#let shrink(P, d) = inset(cw(P), P.map(_ => d))
#let inside(p, P) = { let c = false; let n = P.len(); for i in range(n) { let (xi, yi) = P.at(i); let (xj, yj) = P.at(calc.rem(i + n - 1, n)); if ((yi > p.at(1)) != (yj > p.at(1))) and (p.at(0) < (xj - xi) * (p.at(1) - yi) / (yj - yi) + xi) { c = not c } }; c }
#let box-in(b, P) = { let (x0, y0, x1, y1) = (b.at(0), b.at(1), b.at(2), b.at(3)); let e = 0.001; ((x0 + e, y0 + e), (x1 - e, y0 + e), (x1 - e, y1 - e), (x0 + e, y1 - e)).all(p => inside(p, P)) }
#let poly-in(S, P) = shrink(S, 0.002).all(p => inside(p, P))
#let bbox(P) = (calc.min(..P.map(p => p.at(0))), calc.min(..P.map(p => p.at(1))), calc.max(..P.map(p => p.at(0))), calc.max(..P.map(p => p.at(1))))
#let overlap(a, b) = not (a.at(2) <= b.at(0) + 1e-9 or b.at(2) <= a.at(0) + 1e-9 or a.at(3) <= b.at(1) + 1e-9 or b.at(3) <= a.at(1) + 1e-9)
#let no-overlaps(L) = range(L.len()).all(i => range(L.len()).all(j => i == j or not overlap(L.at(i), L.at(j))))
#let swing-box(d) = { let (a, b, dir) = (d.at(0), d.at(1), d.at(2)); let w = dist(a, b); let (x0, x1, y0, y1) = (calc.min(a.at(0), b.at(0)), calc.max(a.at(0), b.at(0)), calc.min(a.at(1), b.at(1)), calc.max(a.at(1), b.at(1)))
  if dir == (0, 0) { none } else if dir.at(1) < 0 { (x0, y0 - w, x1, y0) } else if dir.at(1) > 0 { (x0, y0, x1, y0 + w) } else if dir.at(0) > 0 { (x0, y0, x0 + w, y1) } else { (x0 - w, y0, x0, y1) } }
#let reflex(P) = { let Q = cw(P); let n = Q.len(); range(n).any(i => { let a = Q.at(calc.rem(i + n - 1, n)); let b = Q.at(i); let c = Q.at(calc.rem(i + 1, n)); (b.at(0) - a.at(0)) * (c.at(1) - b.at(1)) - (b.at(1) - a.at(1)) * (c.at(0) - b.at(0)) < -1e-6 }) }   // a concave corner (an L-shaped room)
#let jog(P) = { let Q = cw(P); let n = Q.len(); range(n).any(i => { let a = Q.at(calc.rem(i + n - 1, n)); let b = Q.at(i); let c = Q.at(calc.rem(i + 1, n)); ((b.at(0) - a.at(0)) * (c.at(1) - b.at(1)) - (b.at(1) - a.at(1)) * (c.at(0) - b.at(0)) < -1e-6) and calc.min(dist(a, b), dist(b, c)) < 1.0 - 1e-6 }) }   // a jog = a concave corner whose return is under 1.0 m (a small step in a wall)
#let room(L, n) = L.rooms.find(r => r.at(0) == n)
#let P-of(L, n) = { let r = room(L, n); if r == none { none } else { r.at(1) } }
#let has-outer-edge(P) = { let n = P.len(); range(n).any(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, n)); half(a, b) > 0.12 }) }

// ---------- the common pieces ----------
#let shower-cut(x0, y0) = ((x0, y0), (cut-in(y0), y0), (13.186, (13.186 + 0.125 / cut-cos - cut-a.at(0)) * cut-b.at(1) / (cut-b.at(0) - cut-a.at(0))), (13.186, 6.4), (x0, 6.4))   // the kids' shower zone in the cut's clipped corner at C32
#let bedroom-S(y0) = (   // the suite bedroom from y0 to 19.25: the king bed on the dressing wall facing south, the entry wardrobe east of the court door (privacy: ff_suite.typ), the sitting corner by the east wall
  (10.7, y0 + 0.15, 12.5, y0 + 2.15, [king bed 1.8 × 2.0], "Suite bedroom"), (10.2, y0 + 0.15, 10.65, y0 + 0.65, [], "Suite bedroom"), (12.55, y0 + 0.15, 13.0, y0 + 0.65, [], "Suite bedroom"),
  (10.0, 16.85, 10.6, 19.15, [entry wardrobe], "Suite bedroom"), (12.45, 16.3, 13.05, 16.9, [chair], "Suite bedroom"), (12.45, 17.5, 13.05, 18.1, [chair], "Suite bedroom"), (11.75, 16.85, 12.2, 17.55, [table], "Suite bedroom"), (9.05, 14.3, 9.55, 16.3, [dresser · TV], "Suite bedroom"),
)
#let kids-N(yw) = ((9.05, 0.15, 10.25, 2.15, [bed 1.2 × 2.0], "Bedroom 1"), (9.05, 2.25, 9.65, 3.65, [wardrobe 1.4], "Bedroom 1"), (11.15, yw - 0.7, 12.35, yw - 0.1, [desk 1.2 × 0.6], "Bedroom 1"))
#let kids-bath-16 = ((11.1, 5.75, 11.55, 6.35, [basin], "Bedroom 1 bath"), (11.75, 5.8, 12.15, 6.4, [WC], "Bedroom 1 bath"))   // the compact bath x 11.0–13.311 × y 4.7–6.5 (1.6 clear wide)
#let suite-bath-L1 = ((12.536, 6.95, 13.186, 7.4, [WC], "Suite WC (closet)"), (12.1, 8.1, 13.186, 9.3, [shower 1.1 × 1.2], "Suite bath"), (10.4, 9.15, 12.05, 9.9, [tub 1.65 × 0.75], "Suite bath"), (10.4, 6.7, 11.0, 8.3, [2 basins], "Suite bath"))
#let suite-bath-L2 = ((12.536, 6.95, 13.186, 7.4, [WC], "Suite WC (closet)"), (12.1, 8.1, 13.186, 9.3, [shower 1.1 × 1.2], "Suite bath"), (10.4, 8.1, 11.15, 9.8, [tub 0.75 × 1.7], "Suite bath"), (10.4, 6.6, 12.1, 7.2, [2 basins], "Suite bath"))
#let kids-bath-rooms(yw, xb) = (   // the north bay: bedroom 1 to the wall yw; the link, the linen cupboard and the bath along it
  ("Bedroom 1", ((8.95, 0), (10.461, 0), (cut-x(yw), yw), (8.95, yw)), "bed"),
  ("Family link", rect-pts(8.95, yw, 10.3, 6.5), "circ"),
  ("Bedroom 1 bath", ((xb, yw), (cut-x(yw), yw), (13.311, 5.245), (13.311, 6.5), (xb, 6.5)), "wet"),
)
#let kids-doors(yw, xb) = (((9.05, yw), (10.05, yw), (0, -1), [bedroom 1 door 1.00, opens in]), ((xb + 0.1, yw), (xb + 0.9, yw), (0, 1), [bath door 0.80, from the bedroom, opens into the bath]))
#let windows-common = (((11.33, 1.6), (12.2, 3.2), [bedroom 1 escape (the cut)]), ((9.2, 0), (10.2, 0), [bedroom 1 north]), ((W, 5.6), (W, 6.2), [kids' bath · or a fan]), ((W, 8.4), (W, 9.1), [suite bath]), ((W, 16.2), (W, 18.2), [suite bedroom escape]))

// ======================= TODAY (data/rooms_ff.csv) =======================
#let rooms-ff = csv("/data/rooms_ff.csv", row-type: dictionary)
#let pts-of(name) = { let r = rooms-ff.find(r => r.name == name); assert(r != none, message: "rooms_ff.csv: missing " + name); r.pts.split(";").map(p => { let v = p.trim().split(" ").map(float); (v.at(0), v.at(1)) }) }
#let T = (
  name: [Today (V10.0)], short: "today",
  rooms: (("Bedroom 1", pts-of("Bedroom 1"), "bed"), ("Family link", pts-of("Family link"), "circ"), ("Suite lobby", pts-of("Suite lobby"), "circ"), ("Suite bath", pts-of("Suite bath"), "wet"), ("Suite WC (closet)", pts-of("Suite WC (closet)"), "wet"), ("Suite dressing", pts-of("Suite dressing"), "dry"), ("Suite bedroom", pts-of("Suite bedroom"), "bed")),
  furniture: (), fixtures: ((12.536, 6.95, 13.186, 7.4, [WC], "Suite WC (closet)"), (12.086, 8.1, 13.186, 9.5, [shower], "Suite bath"), (11.486, 9.6, 13.186, 10.35, [tub], "Suite bath"), (10.4, 8.3, 11.0, 9.9, [2 basins], "Suite bath")), showers: (), cupboards: (),
  doors: (((9.05, 5.3), (10.05, 5.3), (0, -1), [bedroom 1]), ((9.0, 6.5), (10.1, 6.5), (0, 1), [suite]), ((10.3, 6.65), (10.3, 7.65), (1, 0), [bath]), ((12.211, 6.8), (12.211, 7.8), (0, 0), [WC sliding]), ((10.3, 10.6), (10.3, 11.6), (1, 0), [dressing]), ((9.05, 11.9), (10.05, 11.9), (0, 1), [bedroom]), ((9.05, 19.25), (9.95, 19.25), (0, 0), [court, sliding])),
  windows: windows-common,
  labels: ("Bedroom 1": (9.9, 2.6), "Family link": (9.55, 5.9), "Suite lobby": (9.62, 9.2), "Suite bath": (11.4, 8.9), "Suite WC (closet)": (12.76, 7.75), "Suite dressing": (11.8, 12.2), "Suite bedroom": (11.0, 15.8)),
  walls-off: ("x 10.15 (link)", "x 10.3 (lobby, to y 11.9)", "y 5.3", "y 8.0 / x 12.211 (closet)", "y 10.45 (C33 line)", "y 11.9 / 13.9 (bedroom's two steps)"),
  note: [the bedroom with a 1.35 × 2.0 step (the lobby's end), bedroom 1 L-shaped round the link, the bath with the closet's notch],
)

// ======================= L1 · TIDY: the corridor the whole middle bay, the bath and the dressing stacked on the east, the bedroom the whole south bay =======================
#let L1 = (
  name: [L1 · Tidy: corridor · bath + dressing east · the bedroom the south bay], short: "L1",
  rooms: kids-bath-rooms(4.7, 11.0) + (
    ("Suite lobby", rect-pts(8.95, 6.5, 10.3, 13.0), "circ"),
    ("Suite bath", ((10.3, 6.5), (12.211, 6.5), (12.211, 8.0), (13.311, 8.0), (13.311, 10.0), (10.3, 10.0)), "wet"),
    ("Suite WC (closet)", rect-pts(12.211, 6.5, 13.311, 8.0), "wet"),
    ("Suite dressing", rect-pts(10.3, 10.0, 13.311, 13.0), "dry"),
    ("Suite bedroom", rect-pts(8.95, 13.0, 13.311, 19.25), "bed"),
  ),
  furniture: kids-N(4.7) + bedroom-S(13.0) + ((10.4, 10.1, 13.186, 10.7, [wardrobes 2.8], "Suite dressing"), (10.4, 12.3, 13.186, 12.9, [wardrobes 2.8], "Suite dressing")),
  fixtures: kids-bath-16 + suite-bath-L1, showers: ((shower-cut(12.3, 4.8), [shower 0.9 × 1.6], "Bedroom 1 bath"),),
  cupboards: ((10.3, 4.7, 11.0, 6.5, [linen · to the link]),),
  doors: kids-doors(4.7, 11.0) + (((9.0, 6.5), (10.1, 6.5), (0, 1), [suite door 1.10]), ((10.3, 8.35), (10.3, 9.15), (1, 0), [bath 0.80, from the corridor]), ((12.211, 6.8), (12.211, 7.8), (0, 0), [WC sliding]), ((10.3, 11.1), (10.3, 11.9), (1, 0), [dressing 0.80]), ((9.05, 13.0), (10.05, 13.0), (0, 1), [bedroom 1.00, under B7]), ((9.05, 19.25), (9.95, 19.25), (0, 0), [court, sliding])),
  windows: windows-common,
  labels: ("Bedroom 1": (10.75, 2.9), "Family link": (9.62, 5.55), "Bedroom 1 bath": (12.0, 5.3), "Suite lobby": (9.62, 10.0), "Suite bath": (11.4, 8.75), "Suite WC (closet)": (12.76, 7.75), "Suite dressing": (11.8, 11.5), "Suite bedroom": (11.2, 15.6)),
  walls-off: ("y 4.7 (over the GF wall)", "x 10.3 (y 4.7–13)", "x 11.0 (kids' bath)", "y 8.0 / x 12.211 (closet)", "y 10.0 (bath / dressing, 0.45 off C33)"),
  note: [today's order kept and tidied: the bedroom a clean 4.36 × 6.25 rectangle, the dressing 3.0 m deep, the bath to y 10.0 (off the hood)],
)
// ======================= L2 · WALK-THROUGH: a short lobby, the bath with its door from the dressing, the dressing the full width, the bedroom through it =======================
#let L2 = (
  name: [L2 · Walk-through: short lobby · bath · full-width dressing · bedroom], short: "L2",
  rooms: kids-bath-rooms(4.7, 11.0) + (
    ("Suite lobby", rect-pts(8.95, 6.5, 10.3, 10.0), "circ"),
    ("Suite bath", ((10.3, 6.5), (12.211, 6.5), (12.211, 8.0), (13.311, 8.0), (13.311, 10.0), (10.3, 10.0)), "wet"),
    ("Suite WC (closet)", rect-pts(12.211, 6.5, 13.311, 8.0), "wet"),
    ("Suite dressing", rect-pts(8.95, 10.0, 13.311, 13.0), "dry"),
    ("Suite bedroom", rect-pts(8.95, 13.0, 13.311, 19.25), "bed"),
  ),
  furniture: kids-N(4.7) + bedroom-S(13.0) + ((10.2, 10.1, 12.2, 10.7, [wardrobes 2.0], "Suite dressing"), (10.2, 12.3, 13.186, 12.9, [wardrobes 3.0], "Suite dressing"), (9.05, 11.2, 9.65, 12.2, [chest · mirror], "Suite dressing")),
  fixtures: kids-bath-16 + suite-bath-L2, showers: ((shower-cut(12.3, 4.8), [shower 0.9 × 1.6], "Bedroom 1 bath"),),
  cupboards: ((10.3, 4.7, 11.0, 6.5, [linen · to the link]), (10.4, 6.6, 10.4, 6.6, [])),
  doors: kids-doors(4.7, 11.0) + (((9.0, 6.5), (10.1, 6.5), (0, 1), [suite door 1.10]), ((9.05, 10.0), (10.05, 10.0), (0, 1), [dressing 1.00, from the lobby]), ((12.3, 10.0), (13.1, 10.0), (0, 1), [bath 0.80, from the dressing, opens into the dressing]), ((12.211, 6.8), (12.211, 7.8), (0, 0), [WC sliding]), ((9.05, 13.0), (10.05, 13.0), (0, 1), [bedroom 1.00, from the dressing, under B7]), ((9.05, 19.25), (9.95, 19.25), (0, 0), [court, sliding])),
  windows: windows-common,
  labels: ("Bedroom 1": (10.75, 2.9), "Family link": (9.62, 5.55), "Bedroom 1 bath": (12.0, 5.3), "Suite lobby": (9.62, 8.3), "Suite bath": (11.6, 8.9), "Suite WC (closet)": (12.76, 7.75), "Suite dressing": (11.2, 11.5), "Suite bedroom": (11.2, 15.6)),
  walls-off: ("y 4.7 (over the GF wall)", "x 10.3 (y 4.7–10)", "x 11.0 (kids' bath)", "y 8.0 / x 12.211 (closet)", "y 10.0 (bath / dressing, 0.45 off C33)"),
  note: [the private sequence lobby → dressing → bedroom, the bath off the dressing; the dressing 4.36 × 3.0; the lobby half as long],
)
// ======================= L3 · FROM THE MASTER (owner's addition): the kids' bath takes the master's north strip (the WC closet + the path), bedroom 1 keeps its whole size; the master's bath and dressing become one room =======================
#let L3 = (
  name: [L3 · From the master: the kids' bath in the suite's north strip · bedroom 1 whole · the master's bath + dressing one room], short: "L3",
  rooms: (
    ("Bedroom 1", ((8.95, 0), (10.461, 0), (13.311, 5.245), (13.311, 6.5), (10.3, 6.5), (10.3, 5.3), (8.95, 5.3)), "bed"),
    ("Family link", rect-pts(8.95, 5.3, 10.3, 6.5), "circ"),
    ("Bedroom 1 bath", rect-pts(10.3, 6.5, 13.311, 8.0), "wet"),
    ("Suite lobby", rect-pts(8.95, 6.5, 10.3, 13.0), "circ"),
    ("Suite bath · dressing", rect-pts(10.3, 8.0, 13.311, 13.0), "wet"),
    ("Suite bedroom", rect-pts(8.95, 13.0, 13.311, 19.25), "bed"),
  ),
  furniture: ((9.05, 0.15, 10.25, 2.15, [bed 1.2 × 2.0], "Bedroom 1"), (9.05, 2.5, 9.65, 3.7, [desk 1.2 × 0.6], "Bedroom 1"), (11.4, 5.9, 13.186, 6.5, [wardrobe 1.8 × 0.6], "Bedroom 1"), (9.05, 3.9, 9.65, 4.2, [shelves], "Bedroom 1"))
    + bedroom-S(13.0) + ((12.586, 9.3, 13.186, 12.9, [wardrobes 3.6], "Suite bath · dressing"), (11.2, 12.3, 12.4, 12.9, [wardrobes 1.2], "Suite bath · dressing")),
  fixtures: ((10.4, 6.9, 10.85, 7.5, [basin], "Bedroom 1 bath"), (11.6, 7.3, 12.0, 7.9, [WC], "Bedroom 1 bath"), (12.286, 6.6, 13.186, 7.9, [shower 0.9 × 1.3], "Bedroom 1 bath"),
    (12.7, 8.1, 13.186, 8.75, [WC · screened], "Suite bath · dressing"), (11.6, 8.1, 12.6, 9.1, [shower 1.0 × 1.0], "Suite bath · dressing"), (10.4, 8.1, 11.15, 9.8, [tub 0.75 × 1.7], "Suite bath · dressing"), (10.4, 10.0, 11.0, 11.6, [2 basins], "Suite bath · dressing")),
  showers: (), cupboards: (),
  doors: (((9.05, 5.3), (10.05, 5.3), (0, -1), [bedroom 1 door 1.00, opens in]), ((10.45, 6.5), (11.25, 6.5), (0, -1), [kids' bath 0.80, from the bedroom's entry strip, opens into the bedroom, under B6]), ((9.0, 6.5), (10.1, 6.5), (0, 1), [suite door 1.10]), ((10.3, 11.8), (10.3, 12.6), (1, 0), [bath · dressing 0.80, from the corridor]), ((9.05, 13.0), (10.05, 13.0), (0, 1), [bedroom 1.00, under B7]), ((9.05, 19.25), (9.95, 19.25), (0, 0), [court, sliding])),
  windows: (((11.33, 1.6), (12.2, 3.2), [bedroom 1 escape (the cut)]), ((9.2, 0), (10.2, 0), [bedroom 1 north]), ((W, 7.3), (W, 7.8), [kids' bath · or a fan]), ((W, 8.9), (W, 9.4), [suite bath · or a fan]), ((W, 16.2), (W, 18.2), [suite bedroom escape])),
  labels: ("Bedroom 1": (10.75, 3.0), "Family link": (9.62, 5.9), "Bedroom 1 bath": (11.6, 6.85), "Suite lobby": (9.62, 10.0), "Suite bath · dressing": (11.65, 11.2), "Suite bedroom": (11.2, 15.6)),
  walls-off: ("y 5.3 (link / bedroom 1)", "x 10.3 (y 5.3–13)", "y 8.0 (kids' bath / suite, 1.5 off B6)"),
  note: [the owner's addition: the kids' bath takes the suite's north strip (the WC closet and the path to it); bedroom 1 keeps today's size; the master's wet band left is 2.0 m deep, so its bath and dressing become one room, the drains in its north band and its dry part over the hood],
)
#let layouts = (L1, L2, L3)

// ---------- checks ----------
#let fix-ok(L) = L.fixtures.all(f => { let P = P-of(L, f.at(5)); P != none and box-in((f.at(0), f.at(1), f.at(2), f.at(3)), P) }) and L.showers.all(s => poly-in(s.at(0), P-of(L, s.at(2)))) and no-overlaps(L.fixtures.map(f => (f.at(0), f.at(1), f.at(2), f.at(3))) + L.showers.map(s => bbox(s.at(0))))
#let furn-boxes(L) = L.furniture.map(f => (f.at(0), f.at(1), f.at(2), f.at(3)))
#let furn-ok(L) = L.furniture.all(f => { let P = P-of(L, f.at(5)); P != none and box-in((f.at(0), f.at(1), f.at(2), f.at(3)), P) }) and no-overlaps(furn-boxes(L))
#let all-boxes(L) = furn-boxes(L) + L.fixtures.map(f => (f.at(0), f.at(1), f.at(2), f.at(3))) + L.showers.map(s => bbox(s.at(0))) + L.cupboards.map(c => (c.at(0), c.at(1), c.at(2), c.at(3)))
#let swings-ok(L) = L.doors.map(swing-box).filter(s => s != none).all(s => all-boxes(L).all(b => not overlap(s, b)))
#let wet-rooms(L) = L.rooms.filter(r => r.at(2) == "wet")
#let over-service(P) = { let Q = shrink(P, 0.05); let samples = range(Q.len()).map(i => { let a = Q.at(i); let b = Q.at(calc.rem(i + 1, Q.len())); range(8).map(k => (a.at(0) + (b.at(0) - a.at(0)) * k / 8, a.at(1) + (b.at(1) - a.at(1)) * k / 8)) }).join(); samples.all(p => gf-below.any(g => g.at(2) and inside(p, g.at(0)))) }
#let drains(L) = L.fixtures.map(f => rect-pts(f.at(0), f.at(1), f.at(2), f.at(3))) + L.showers.map(s => s.at(0))   // every fixture with a drain (WC, basin, shower, tub), as polygons
#let wet-ok(L) = wet-rooms(L).all(r => over-service(r.at(1))) and drains(L).all(P => not overlap(bbox(P), hood) and over-service(P))
#let cols-ok(L) = L.rooms.all(r => columns.all(c => not inside(c.at(1), shrink(r.at(1), 0.13))))
#let jog-ok(L) = L.rooms.all(r => not jog(r.at(1)))
#let L-rooms(L) = L.rooms.filter(r => reflex(r.at(1))).map(r => r.at(0))
#let bath-rect-ok(L) = { let P = P-of(L, "Suite bath"); let C = P-of(L, "Suite WC (closet)"); C == none or not reflex(P + ()) or (bbox(P) == bbox(P + C) and calc.abs(area(P) + area(C) - (bbox(P).at(2) - bbox(P).at(0)) * (bbox(P).at(3) - bbox(P).at(1))) < 1e-6) }
#let escape-ok(L) = L.rooms.filter(r => r.at(2) == "bed").all(r => has-outer-edge(r.at(1)))
#let vent-ok(L) = wet-rooms(L).all(r => has-outer-edge(r.at(1)))   // every wet room touches an outer wall (a window or an extract fan through it)
#let stack-d(L) = calc.min(..L.fixtures.filter(f => f.at(5).contains("bath") or f.at(5).contains("WC")).map(f => dist(((f.at(0) + f.at(2)) / 2, (f.at(1) + f.at(3)) / 2), east-stack)))
#let stack-max(L) = calc.max(..(L.fixtures.filter(f => f.at(5).contains("bath") or f.at(5).contains("WC")).map(f => dist(((f.at(0) + f.at(2)) / 2, (f.at(1) + f.at(3)) / 2), east-stack)) + L.showers.map(s => { let b = bbox(s.at(0)); dist(((b.at(0) + b.at(2)) / 2, (b.at(1) + b.at(3)) / 2), east-stack) })))
#let checks(L) = (
  ([fixtures inside their rooms, no overlaps], fix-ok(L)),
  ([furniture inside its rooms, no overlaps], furn-ok(L)),
  ([every door leaf swings clear of furniture, fixtures and cupboards], swings-ok(L)),
  ([every wet room over wet / service rooms below; every drain off the kitchen's hood zone], wet-ok(L)),
  ([no column inside a room's clear area (none moved: all in walls)], cols-ok(L)),
  ([no jog: no small step (a return under 1.0 m) in any room's walls; L-shaped rooms listed, not failed], jog-ok(L)),
  ([each bedroom on an outer wall (an escape window); each wet room on an outer wall (a window or a fan)], escape-ok(L) and vent-ok(L)),
)
#let all-ok(L) = checks(L).all(c => c.at(1))
#let A(L, n) = area(P-of(L, n))
#let C(L, n) = clear(P-of(L, n))
#let AC(L, n) = { let P = P-of(L, n); if P == none { [—] } else { [#r2(area(P)) · *#r2(clear(P))*] } }
#let Cz(L, n) = { let P = P-of(L, n); if P == none { 0 } else { clear(P) } }

// ---------- drawing ----------
#let q(p) = (p.at(0), -p.at(1))
#let fillc = (bed: rgb("#efe3c8"), wet: rgb("#cfe6ef"), dry: rgb("#e6e0d0"), circ: rgb("#ebe7dd"))
#let plan(L, length: 0.72cm, full: true) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, body, size: 3.6pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, body))
  let poly(P, fill: none, stroke: none) = line(..P.map(q), close: true, fill: fill, stroke: stroke)
  let R(b, fill: none, stroke: none) = rect(q((b.at(0), b.at(1))), q((b.at(2), b.at(3))), fill: fill, stroke: stroke)
  rect(q((8.3, -0.45)), q((14.3, 19.9)), fill: rgb("#f3efe6"), stroke: none)
  for x in range(9, 14) { line(q((x, -0.2)), q((x, 19.6)), stroke: 0.2pt + luma(220)); T((x, -0.3), str(x), size: 3pt, fill: gray) }
  for y in range(0, 20) { line(q((8.5, y)), q((13.9, y)), stroke: 0.2pt + luma(220)); if full { T((8.4, y), str(y), size: 3pt, fill: gray, anchor: "east") } }
  for (P, l, wet) in gf-below { poly(P, stroke: (paint: brown, dash: "dotted", thickness: 0.45pt)) }
  R(hood, fill: rgb("#f0d9c0"), stroke: (paint: red, thickness: 0.3pt, dash: "dotted")); T((12.85, 10.7), [hood\ below], size: 2.6pt, fill: red)
  for (n, P, k) in L.rooms { poly(P, fill: fillc.at(k), stroke: 0.8pt + ink) }
  rect(q((8.3, 0)), q((8.95, 6.5)), fill: luma(236), stroke: 0.8pt + ink); T((8.62, 3.2), [kids' study · family living], size: 3pt, fill: gray, angle: 90deg)
  rect(q((8.3, 6.5)), q((8.95, 19.25)), fill: luma(243), stroke: 0.8pt + ink); T((8.62, 12.9), [courtyard sky · living void], size: 3pt, fill: gray, angle: 90deg)
  rect(q((8.3, 19.25)), q((10.0, 19.9)), fill: rgb("#e4ecdc"), stroke: 0.8pt + ink); T((9.15, 19.6), [suite court], size: 2.8pt, fill: gray)
  rect(q((10.0, 19.25)), q((13.311, 19.9)), fill: luma(236), stroke: 0.8pt + ink); T((11.65, 19.6), [office], size: 2.8pt, fill: gray)
  line(q((8.95, 0)), q(cut-a), q(cut-b), q((W, 19.9)), stroke: 1.8pt + ink)
  for (x0, y0, x1, y1, l) in L.cupboards { if x1 > x0 { R((x0, y0, x1, y1), fill: rgb("#d8c39a"), stroke: 0.4pt + ink); T(((x0 + x1) / 2, (y0 + y1) / 2), l, size: 2.5pt, angle: 90deg) } }
  for (x0, y0, x1, y1, l, rm) in L.furniture { R((x0, y0, x1, y1), fill: rgb("#fbf6ea"), stroke: 0.4pt + rgb("#8a7a5a")); T(((x0 + x1) / 2, (y0 + y1) / 2), l, size: 2.5pt, angle: if (y1 - y0) > (x1 - x0) * 1.4 { 90deg } else { 0deg }) }
  for (S, l, rm) in L.showers { poly(S, fill: white, stroke: 0.4pt + blue); let b = bbox(S); T(((b.at(0) + b.at(2)) / 2, (b.at(1) + b.at(3)) / 2 + 0.1), l, size: 2.5pt, fill: blue, angle: 90deg) }
  for (x0, y0, x1, y1, l, rm) in L.fixtures { R((x0, y0, x1, y1), fill: white, stroke: 0.4pt + blue); T(((x0 + x1) / 2, (y0 + y1) / 2), l, size: 2.5pt, fill: blue, angle: if (y1 - y0) > (x1 - x0) * 1.4 { 90deg } else { 0deg }) }
  for d in L.doors { let (a, b, dir, l) = (d.at(0), d.at(1), d.at(2), d.at(3)); line(q(a), q(b), stroke: (paint: red, thickness: if dir == (0, 0) { 1.6pt } else { 2.6pt })); let s = swing-box(d); if s != none { R(s, stroke: (paint: red, thickness: 0.3pt, dash: "dashed")) } }
  for (a, b, l) in L.windows { line(q(a), q(b), stroke: (paint: blue, thickness: 2pt, dash: "dashed")) }
  for (id, a, b, sz) in beams { line(q(a), q(b), stroke: (paint: amber, thickness: 1.1pt, dash: "dashed")); T(((a.at(0) + b.at(0)) / 2 + (if id == "B5" { -0.18 } else { 0 }), (a.at(1) + b.at(1)) / 2 - (if id == "B5" { 0 } else { 0.16 })), id, size: 2.8pt, fill: amber, angle: if id == "B5" { 90deg } else { 0deg }) }
  for (id, p) in columns { rect(q((p.at(0) - 0.13, p.at(1) - 0.13)), q((p.at(0) + 0.13, p.at(1) + 0.13)), fill: ink, stroke: none); if full { T((p.at(0) + (if p.at(0) > 13 { 0.18 } else { -0.18 }), p.at(1) - 0.2), id, size: 2.6pt, fill: ink, anchor: if p.at(0) > 13 { "west" } else { "east" }) } }
  circle(q(east-stack), radius: 0.17, fill: brown, stroke: none); T((13.55, 7.05), [stack], size: 2.8pt, fill: brown, anchor: "west")
  for (n, P, k) in L.rooms { let lb = L.labels.at(n); T(lb, [*#(if n == "Suite WC (closet)" { "WC" } else { n })*\ #r2(area(P)) · ≈ #r2(clear(P))], size: if n.contains("WC") or n.contains("link") { 2.5pt } else { 3.0pt }) }
})

// ======================= PAGE 1 · the three layouts =======================
#text(12pt, weight: "bold", fill: accent)[First-floor east wing as one · the master suite · bedroom 1 + en-suite · the link] #h(1fr) #text(6.4pt, fill: gray)[study · 11 Nov 2026 · nothing in the design files changed · CSV frame, north up · m² on axes · ≈ clear]
#v(1pt) #line(length: 100%, stroke: 0.6pt + accent)
#grid(columns: (4.9cm, 4.9cm, 4.9cm, 3.4cm, 1fr), column-gutter: 5pt,
  ..layouts.map(L => [#block(height: 2.6em, text(6.4pt, weight: "bold", fill: accent)[#L.name]) #plan(L, length: 0.8cm)]),
  [#block(height: 2.6em, text(6.4pt, weight: "bold", fill: gray)[#T.name]) #plan(T, length: 0.55cm, full: false)],
  [
    #text(6.4pt)[
      *Fixed (drawn):* the columns C24–C35 (black), the beams B5–B8 (amber dashed), the cut (RC), the east wall, the stack outside the east wall at y 7.05 (brown), the kitchen's hood below (red dotted box: no wet room over it), the ground floor below (brown dotted: the maid room and the living / dining are habitable, the rest wet or service). *Colours:* ochre bedrooms, blue wet rooms, grey-beige the dressing and the circulation; white boxes fixtures and furniture; red doors with the leaf's reach dashed (thin red = sliding); blue dashed = *provisional* window marks only (the owner sets the windows with the facades): the kids' escape window on the cut, the suite bedroom's on the east wall, one per bath or a fan.
      \ \ *Common to L1–L3:* the wing entered only from the family living through the link (the opening in the x 8.95 wall at y 5.3–6.5 unchanged); the suite door on y 6.5 under B6 as today; *the suite bedroom the whole south bay* (4.36 × 6.25 between B7 and B8 in all three) with the court door and the entry wardrobe of `ff_suite.typ`; *the kids' compact en-suite* at the stack: L1, L2 north of the common wall y 6.5 over the laundry (its shower in the cut's corner round C32, a linen cupboard off the link in the leftover 0.7 m); *L3 south of it, in the master's north strip* (the owner's addition), bedroom 1 whole. In L1, L2 the suite's WC closet stays at the stack and *the suite bath ends at y 10.0*, 0.45 short of C33, to stay off the hood; in L3 the master's bath and dressing are one room whose drains stay in the north band y 8.0–10.0.
    ]
  ],
)

// ======================= PAGE 2 · numbers, checks, what lies below =======================
#pagebreak()
#text(11.5pt, weight: "bold", fill: accent)[Sizes · checks · the structure under each room] #h(1fr) #text(6.6pt, fill: gray)[m² on axes · *clear* inside the walls (0.10 a side, outer 0.125) · A′ = `studies/kids_room.typ` (the kids' bath 1.5 deep, the suite as today)]
#v(1pt) #line(length: 100%, stroke: 0.6pt + accent)
#let Ap = (rooms: (("Bedroom 1", ((8.95, 0), (10.461, 0), (cut-x(5.0), 5.0), (8.95, 5.0)), "bed"), ("Bedroom 1 bath", ((10.15, 5.0), (cut-x(5.0), 5.0), (13.311, 5.245), (13.311, 6.5), (10.15, 6.5)), "wet"), ("Family link", rect-pts(8.95, 5.0, 10.15, 6.5), "circ")) + T.rooms.filter(r => r.at(0).starts-with("Suite")))
#let names = ("Bedroom 1", "Bedroom 1 bath", "Family link", "Suite lobby", "Suite bath", "Suite WC (closet)", "Suite dressing", "Suite bath · dressing", "Suite bedroom")
#let wing-total(L) = L.rooms.map(r => area(r.at(1))).sum()
#grid(columns: (1.15fr, 1fr), column-gutter: 10pt,
  [
    #table(columns: (1.4fr, 1fr, 1fr, 1fr, 1fr, 1fr), stroke: 0.3pt + luma(190), inset: 2.4pt, align: (left, right, right, right, right, right), fill: (_, y) => if y == 0 { rgb("#e1e9e3") } else if calc.even(y) { rgb("#efece4") },
      table.header([*Room · axes · clear*], [*Today*], [*A′*], [*L1*], [*L2*], [*L3*]),
      ..names.map(n => ([#n], AC(T, n), AC(Ap, n), AC(L1, n), AC(L2, n), AC(L3, n))).join(),
      [*Master bath + WC + dressing, clear*], [#r2(C(T, "Suite bath") + C(T, "Suite WC (closet)") + C(T, "Suite dressing"))], [#r2(C(T, "Suite bath") + C(T, "Suite WC (closet)") + C(T, "Suite dressing"))], [#r2(C(L1, "Suite bath") + C(L1, "Suite WC (closet)") + C(L1, "Suite dressing"))], [#r2(C(L2, "Suite bath") + C(L2, "Suite WC (closet)") + C(L2, "Suite dressing"))], [#r2(C(L3, "Suite bath · dressing"))],
      [*Master suite total (lobby + wet + dressing + bedroom), axes*], [#r2(wing-total(T) - A(T, "Bedroom 1") - A(T, "Family link"))], [#r2(wing-total(Ap) - A(Ap, "Bedroom 1") - A(Ap, "Family link") - A(Ap, "Bedroom 1 bath"))], [#r2(wing-total(L1) - A(L1, "Bedroom 1") - A(L1, "Family link") - A(L1, "Bedroom 1 bath"))], [#r2(wing-total(L2) - A(L2, "Bedroom 1") - A(L2, "Family link") - A(L2, "Bedroom 1 bath"))], [#r2(wing-total(L3) - A(L3, "Bedroom 1") - A(L3, "Family link") - A(L3, "Bedroom 1 bath"))],
      [L-shaped rooms (no small jog in any)], [#T.rooms.filter(r => reflex(r.at(1))).len()], [#Ap.rooms.filter(r => reflex(r.at(1))).len()], [#L-rooms(L1).len()], [#L-rooms(L2).len()], [#L-rooms(L3).len()],
      [Wing total, axes], [#r2(wing-total(T))], [#r2(wing-total(Ap))], [#r2(wing-total(L1))], [#r2(wing-total(L2))], [#r2(wing-total(L3))],
      [Bedroom → bath door, walked], [≈ 5.5 m], [≈ 5.5 m], [≈ 5.5 m], [≈ 3.5 m (through the dressing)], [≈ 2.5 m],
      [Suite entry → bedroom door], [5.4 m], [5.4 m], [6.5 m], [6.5 m (through the dressing)], [6.5 m],
      [Fixture farthest from the stack], [≈ 3.7 m], [≈ 3.7 m], [#r1(stack-max(L1)) m], [#r1(stack-max(L2)) m], [#r1(stack-max(L3)) m],
      [Wall lines off the beam / column lines (light partitions)], [#T.walls-off.len()], [#T.walls-off.len()], [#L1.walls-off.len()], [#L2.walls-off.len()], [#L3.walls-off.len()],
    )
    #v(3pt)
    #text(6.6pt)[*Checks* (quick, geometric; not a code check): #for L in layouts [*#L.short:* #if all-ok(L) [passed (#checks(L).len())] else [FAILED: #checks(L).filter(c => not c.at(1)).map(c => c.at(0)).join([; ])] · ] \ The seven: #checks(L1).map(c => c.at(0)).join([; ]).]
    #v(3pt)
    #text(6.6pt)[*Partitions off the structural lines* (all 0.10–0.20 light block on the slab, none load-bearing): #for L in layouts [*#L.short:* #L.walls-off.join(", "). ] *Today:* #T.walls-off.join(", "). *L-shaped rooms:* L1, L2 the suite bath round its WC closet (the two together one rectangle); L3 bedroom 1 round the link (as today; the x 10.3 wall runs straight from y 5.3 to 13). *L3 and the hood:* the master's bath · dressing room lies over the hood with its *dry* part (the wardrobes, x 12.4–13.311, y 10.1–11.3); every drain is in its north band y 8.0–10.0: the owner's rule read as "no drain over the hood" — to accept or refuse.]
  ],
  [
    #H[What lies under each wet room · the stack]
    #text(6.8pt)[
      - *The kids' bath* (L1, L2) over the *laundry* (y 4.7–6.5, a service room with a floor drain); its branches run in the floor screed to the east wall and out to the suite's stack 0.55 m south of the common wall: the WC ≈ 1.6 m, the shower ≈ 1.0 m, the basin ≈ 2.4 m. *In L3* it lies over the *kitchen's north band* (y 6.5–8.0) inside the suite's sunken tanked zone, its shower right over the stack.
      - *The suite bath and its WC closet* (L1, L2) over the *kitchen's north part* (y 6.5–10.0): the sunken tanked slab of X10 (x 10.3–13.311, y 6.5–10.45) already exists there; the bath now stops at y 10.0, so the slab's last 0.45 m lies under the dressing (fill it or shorten the depression: the engineer). The hob + hood at the east wall (y 10.2–11.2) stays under the *dressing* (dry). *In L3* the master's wet fixtures (tub, shower, WC) sit in y 8.0–10.0 of the same sunken zone and the basins on the west wall at y 10.0–11.6 (x < 12.4, off the hood); only the wardrobes stand over the hood.
      - *Nothing wet over the living / dining* (y 13–19.25) nor over the maid room (y 0–4.7): the bedrooms are there.
      - *One stack* for the wing, outside the east wall at y 7.05 behind its cladding, as today; the kids' bath adds three short branches to it and one cleanout at the wall. The tub's branch is the longest: L1 #r1(dist((11.2, 9.5), east-stack)) m, L2 #r1(dist((10.8, 9.0), east-stack)) m (plumbing.typ scenario B had moved the tub to the north wall for this reason: in L2 the vanity takes the north wall instead and the tub's branch runs under the west side).
    ]
    #H[The link, the lobby, the doors]
    #text(6.8pt)[
      - The family living's opening into the link (y 5.3–6.5 in the x 8.95 wall) is in a structural wall and does not move; the link grows north to the kids' partition (y 4.7, or 5.0 in L3), where bedroom 1's door is. The suite door 1.10 on y 6.5 as today.
      - *L1:* corridor 1.35 × 6.5 from the suite door to the bedroom door under B7; the bath and the dressing open off it on x 10.3. *L2:* the lobby ends at the dressing's door (y 10.0); the dressing is the hub: the bedroom (y 13) and the bath (y 10.0, east end) open off it; the bath's leaf opens into the dressing's free corner. *L3:* the corridor as L1; the kids' bath door in the y 6.5 wall under B6 (a door under a beam: normal) from bedroom 1's entry strip, its leaf opening into the strip west of the wardrobe; the master's bath · dressing off the corridor at y 11.8–12.6.
      - Every leaf's reach is drawn dashed and checked against the furniture and the fixtures; the WC closet keeps its sliding door; the court door stays the sliding glass of `ff_suite.typ` with the entry wardrobe east of it (the privacy fix).
    ]
  ],
)

// ======================= PAGE 3 · the three layouts in words · recommendation · Arabic =======================
#pagebreak()
#text(11.5pt, weight: "bold", fill: accent)[The three layouts · recommendation · #ah[الخلاصة]]
#v(1pt) #line(length: 100%, stroke: 0.6pt + accent)
#grid(columns: (1fr, 1fr), column-gutter: 12pt,
  [
    #H[L1 · Tidy (today's order, made orderly)]
    #text(6.8pt)[
      Bedroom 1 #r2(C(L1, "Bedroom 1")) m² clear with its compact bath #r2(C(L1, "Bedroom 1 bath")) (1.6 wide: basin by the door, WC on the common wall, the 0.9 × 1.6 shower in the cut's corner round C32); the linen cupboard off the link. The corridor runs the whole middle bay to the bedroom door *under B7*; the bath (#r2(C(L1, "Suite bath")) + the closet #r2(C(L1, "Suite WC (closet)"))) and the dressing (#r2(C(L1, "Suite dressing")), wardrobes on two sides, 1.6 m between) open off it. The bedroom *#r2(C(L1, "Suite bedroom")) m² clear, a clean 4.36 × 6.25* between B7 and B8 (today #r2(C(T, "Suite bedroom")) with a step). Every wall either on a structural line or a light partition parallel to the ribs (x 10.3, x 11.0) or crossing them at y 4.7 / 10.0. *Costs:* 8.8 m² of corridor; the bath is reached from the corridor, not from the bedroom (≈ 5.5 m walked).
    ]
    #H[L2 · Walk-through dressing]
    #text(6.8pt)[
      The same north bay and bath footprint, but the lobby stops at y 10.0 and *the dressing takes the full width 4.36 × 3.0 (#r2(C(L2, "Suite dressing")) m² clear, 5 m of wardrobes)* as the suite's hub: the bedroom opens off it under B7 and the bath off its north-east corner. The sequence lobby → dressing → bedroom is the private one; the bath is 3.5 m from the bed, the lobby 5.3 m² instead of 8.8. The bath re-planned for its south door: the two basins on the north wall, the tub on the west wall, the shower on the east wall, the closet at the stack. *Costs:* the bath is entered only through the dressing; the tub's branch #r1(dist((10.8, 9.0), east-stack)) m to the stack (the slab is sunken there).
    ]
    #H[L3 · From the master (the owner's addition)]
    #text(6.8pt)[
      Bedroom 1 keeps today's whole shape and size, *#r2(C(L3, "Bedroom 1")) m² clear* (the link's notch as today, the wardrobe in the entry strip, a desk and shelves on the west wall), and its *compact bath #r2(C(L3, "Bedroom 1 bath")) m² clear (2.8 × 1.3)* is the master's former north strip: the shower over the stack, the door in the y 6.5 wall under B6. The master keeps the corridor and the whole south bay for the bedroom (#r2(C(L3, "Suite bedroom")) m²), but its wet band is now only y 8.0–10.0, so *the bath and the dressing become one room* 3.0 × 5.0 (#r2(C(L3, "Suite bath · dressing")) m² clear): tub, shower and a screened WC in the north band, the two basins on the west wall, 4.8 m of wardrobes south and east. *Costs:* no WC closet; the bath and the dressing not separable (a glass screen at most); the room's dry part over the hood (to accept); the kids' bath the narrowest (1.3 m); the master's wet + dressing area #r2(C(T, "Suite bath") + C(T, "Suite WC (closet)") + C(T, "Suite dressing") - C(L3, "Suite bath · dressing")) m² less than today.
    ]
  ],
  [
    #box(fill: accent.lighten(86%), stroke: 1pt + accent, inset: 6pt, radius: 3pt, width: 100%)[
      #text(9.5pt, weight: "bold", fill: accent)[Recommendation: L2 · or L3 if the owner holds to bedroom 1 whole] \
      #text(7pt)[
        All three keep what the brief fixes: every column and beam in place, every drain over the laundry or the kitchen and off the hood, no small jog in any wall, the kids' bath at the one stack, the suite bedroom a clean 4.36 × 6.25 between B7 and B8 (#r2(C(L1, "Suite bedroom")) m² clear, #r2(C(L1, "Suite bedroom") - C(T, "Suite bedroom")) more than today). *L2* is the most orderly suite: the two walls that matter (y 6.5, y 13) are the beams B6 and B7, one light cross partition at y 10.0, a short lobby, the largest dressing (#r2(C(L2, "Suite dressing")) m²), the bath with its WC closet kept at #r2(C(L2, "Suite bath") + C(L2, "Suite WC (closet)")) m²; its price is bedroom 1 at #r2(C(L2, "Bedroom 1")) m² clear (a four-sided room with the cut) and the bath reached through the dressing. *L3* answers the owner's addition: bedroom 1 stays whole (#r2(C(L3, "Bedroom 1")) m²), the kids' bath costs the master nothing in the bedroom and nothing in the corridor, but the master's bath and dressing merge into one room of #r2(C(L3, "Suite bath · dressing")) m² without a WC closet, its wardrobes over the hood: priorities 2 and 3 pay for the children's room. *L1* is today's order tidied, for owners who want the bath off the corridor.
        \ *Not decided here:* the windows (provisional marks only), the suite court (unchanged, lowest priority), the structure (page 4 lists what the engineer reviews after the plan is final).
        \ *To apply the chosen one (LEAN, next round):* `data/rooms_ff.csv` (the rooms of the wing), `studies/ff_family.typ` and `studies/ff_suite.typ` (rooms, doors, fixtures), `studies/plumbing.typ` (the kids' branches), then the presentation's sheets 03, 05, 08 and their notes; the 3D and the DXFs at the release.
      ]
    ]
    #v(4pt)
    #box(fill: rgb("#f4efe3"), stroke: 0.6pt + luma(170), inset: 6pt, radius: 3pt, width: 100%)[
      #ah[
        #text(9pt, weight: "bold", fill: accent)[الخلاصة بالعربية] \
        #text(7.4pt)[
          إعادة تصميم الجناح الشرقي في الطابق الأول كاملًا: جناح الوالدين (الردهة، غرفة النوم، الحمّام، المرحاض، غرفة الملابس، الباب إلى الفناء) وغرفة النوم 1 (غرفة الأطفال الصغار) بحمّام خاص مدمج، والممر بينهما. الثابت: كل الأعمدة والجسور والجدران الخارجية؛ كل حمّام فوق الغسيل أو المطبخ لا فوق غرفة سكنية ولا فوق شفّاط المطبخ؛ جدران مستقيمة بلا كسرات. النوافذ علامات مؤقتة فقط. \
          *L1 (مرتّب):* ممر بطول الجناح الأوسط، الحمّام وغرفة الملابس شرقه، غرفة النوم كامل الجناح الجنوبي (4.36 × 6.25، #r2(C(L1, "Suite bedroom")) م² صافية)؛ حمّام الأطفال فوق الغسيل شمال الجدار المشترك y 6.5، وغرفة الأطفال #r2(C(L1, "Bedroom 1")) م². \
          *L2 (الموصى به):* ردهة قصيرة، ثم غرفة الملابس بكامل العرض (#r2(C(L2, "Suite dressing")) م²) مركزًا للجناح: منها إلى غرفة النوم (على الجسر B7) وإلى الحمّام (#r2(C(L2, "Suite bath") + C(L2, "Suite WC (closet)")) م² مع غرفة المرحاض)؛ الجدران الرئيسية على الجسرين B6 وB7 وقاطع خفيف واحد عند y 10.0؛ غرفة الأطفال كما في L1. \
          *L3 (إضافة المالك: حمّام الأطفال من جناح الوالدين):* تبقى غرفة الأطفال كاملة (#r2(C(L3, "Bedroom 1")) م²) ويأخذ حمّامها (#r2(C(L3, "Bedroom 1 bath")) م²) الشريط الشمالي من حمّام الوالدين؛ فيصير حمّام الوالدين وغرفة الملابس غرفة واحدة (#r2(C(L3, "Suite bath · dressing")) م²) بلا غرفة مرحاض، مصارفها في الشريط y 8.0–10.0 وخزائنها فوق شفّاط المطبخ (يقبله المالك أو يرفضه)؛ غرفة النوم كما في L1. \
          *التوصية:* L2، أو L3 إن تمسّك المالك بغرفة الأطفال كاملة.
        ]
      ]
    ]
  ],
)

// ======================= PAGE 4 · structural observations for the later review =======================
#pagebreak()
#text(11.5pt, weight: "bold", fill: accent)[Structural observations in the wing · for the engineer's review AFTER the plan is final (nothing changed now)] #h(1fr) #text(6.6pt, fill: gray)[every size in `studies/structure.typ` is assumed; the slabs of the wing span east–west x 8.95 → 13.311 (solid 0.20 over the maid wing, ribbed 0.30 over the kitchen and the dining)]
#v(1pt) #line(length: 100%, stroke: 0.6pt + accent)
#grid(columns: (1fr, 1fr), column-gutter: 12pt,
  [
    #H[Walls not on beams (all light partitions, none load-bearing)]
    #text(6.8pt)[
      - *x 10.3* (the lobby / corridor's east wall, y 4.7–13 in L1, 4.7–10 in L2, 5.3–13 in L3) and *x 11.0* (the kids' bath's west wall): parallel to the ribs / the span: set each on a rib (the ribbed bay) or anywhere on the solid 0.20 slab (the maid-wing bay); 0.10 block, ≤ 3.2 m high.
      - *y 4.7* (bedroom 1 / bath / link): crosses the solid 0.20 slab mid-span, over the ground-floor laundry partition (a wall over a wall, but neither carries the other). *L3: y 5.3* as today.
      - *y 10.0* (bath / dressing): crosses the ribbed slab 0.45 m from the column line C33: a light 0.10 partition (a thickened rib if the engineer wants it), at the edge of the sunken bath zone.
      - *y 8.0 and x 12.211* (the WC closet, as today) inside the sunken zone.
      - *L3 only: y 8.0* (the kids' bath / the master's room), 1.5 m off B6, across the ribs inside the sunken zone; y 5.3 (the link / bedroom 1) on the solid slab as today.
      - *On the beams:* y 6.5 on B6 (the drop beam over the laundry / kitchen line: the two baths back to back on it; the suite door's lintel is the beam), y 13 on B7 (hidden), y 19.25 on B8, x 8.95 on the RC wall W3 (y 0–6.5) and on B5 (y 13–19.25).
    ]
    #H[Spans, the cut, the columns]
    #text(6.8pt)[
      - *Regular spans:* the three bays are 4.36 m wide (x 8.95–13.311) and 6.5 / 6.5 / 6.25 long on the beam lines y 0, 6.5, 13, 19.25; the rib direction east–west in all three. No span above 6.5 m, none irregular except the north bay's triangle at the cut (the slab there spans 1.5 → 4.36 m from the north wall to y 5.245).
      - *The cut wall* (RC 0.20, C30 at its top, C31 at y 2.8, C32 at its foot): the kids' escape window (y 1.6–3.2) and the shower's corner are in or against it; openings in an RC wall are set with the engineer; the shower's floor drain and its branch stay in the screed, clear of the wall's foot.
      - *C25* (8.95, 3.0) and *C31* (11.982, 2.8) stand in walls with no first-floor partition on their line (bedroom 1 is open across them): fine; the column line y 3.0 carries nothing above the ground floor's laundry wall. *C33* (13.311, 10.45) is in the east wall 0.45 m south of the bath / dressing partition in L1–L3.
      - *No column stands inside any room* in the three layouts (checked); none moves.
    ]
  ],
  [
    #H[Point loads, wet zones, openings]
    #text(6.8pt)[
      - *The tub* (≈ 0.35 t full + a person): L1 on the south edge of the bath zone (x 10.4–12.05, y 9.15–9.9), mid-span of the ribbed bay; L2 and L3 on the west side (x 10.4–11.15) next to the x 10.3 partition, which is not a beam: a line load on two ribs. The engineer checks the ribs under it (the sunken slab zone X10 is solid there, not ribbed: to confirm).
      - *The sunken tanked zone* (x 10.3–13.311, y 6.5–10.45, 0.15 deep, X10): the new bath footprint ends at y 10.0; the last 0.45 m under the dressing's wardrobes: fill it, or shorten the depression to y 10.0 in the structural drawings.
      - *The kids' bath* (L1, L2) on the solid 0.20 maid-wing slab: a shallow screed with falls (no depression), the floor drain by the east wall, tanked; its three branches cross no beam (they run east, not south across B6). *L3:* inside the suite's sunken zone, over the stack.
      - *The hood's duct* through the east wall at y 10.2–11.2 (ground floor) and the stack outside the east wall at y 7.05: both in the east wall's outer face, no slab opening in the wing.
      - *Openings in the structural walls:* the link's opening in the x 8.95 RC wall (y 5.3–6.5, as today); the suite door under B6 (as today); the bedroom door under B7 (L1, L2: a hidden beam 0.30 in the slab depth, a door below is normal); the court door under B8 (as today).
      - *Heavy things in the middle of spans:* none proposed; the wardrobes (0.6 deep) along the partitions, the king bed anywhere.
    ]
    #H[For the later structural review (a list, not a change)]
    #text(6.8pt)[
      + Confirm the light partitions y 4.7, y 10.0 and x 10.3 / 11.0 on the two slab types, and L3's y 8.0 across the sunken zone if chosen.
      + Confirm the ribs under the tub and the sunken zone's extent after the bath's new footprint.
      + The RC cut wall's openings (the escape window, the provisional bath window) with the engineer.
      + The east wall's two penetrations (the hood's duct, the stack's branches) and C32 / C33 positions against the final partitions.
      + The suite bedroom bay's 6.25 m ribbed span (B7 → B8) with the entry wardrobe and the bed: ordinary.
      + Nothing in this list moves a column or a beam; the grid of the wing is the grid of the ground floor.
    ]
  ],
)

// ======================= PAGES 5–6 · the owner's new direction (11 Nov 2026, later): bedroom 1 keeps its size; the kids' bath K1 whole in the suite · K2 half in the suite · K3 whole in bedroom 1 (A′) =======================
// the relaxed hood rule: NO DRAIN over the kitchen's hood zone; dry fittings may stand over it (so the suite bath may run to the C33 line y 10.45 again, its tub's drain west of x 12.4)
#let suite-K(bath-y0, bath-fix, bath-door, bath-pts: none, closet: false) = (   // the suite common to K1–K3: lobby x 8.95–10.3 to y 10.45; the bath on the east from bath-y0 to 10.45; the dressing the full width 10.45–13 (the hub); the bedroom the south bay
  rooms: (
    ("Suite lobby", rect-pts(8.95, 6.5, 10.3, 10.45), "circ"),
    ("Suite bath", if bath-pts == none { rect-pts(10.3, bath-y0, 13.311, 10.45) } else { bath-pts }, "wet"),
  ) + (if closet { (("Suite WC (closet)", rect-pts(12.211, 6.5, 13.311, 8.0), "wet"),) } else { () }) + (
    ("Suite dressing", rect-pts(8.95, 10.45, 13.311, 13.0), "dry"),
    ("Suite bedroom", rect-pts(8.95, 13.0, 13.311, 19.25), "bed"),
  ),
  furniture: bedroom-S(13.0) + ((10.2, 10.55, 13.186, 11.15, [wardrobes 3.0 (dry, over the hood)], "Suite dressing"), (10.2, 12.3, 13.186, 12.9, [wardrobes 3.0], "Suite dressing"), (9.05, 11.7, 9.65, 12.6, [chest · mirror], "Suite dressing")),
  fixtures: bath-fix,
  doors: (((9.0, 6.5), (10.1, 6.5), (0, 1), [suite door 1.10]), bath-door, ((9.05, 10.45), (10.05, 10.45), (0, 1), [dressing 1.00, from the lobby]), ((9.05, 13.0), (10.05, 13.0), (0, 1), [bedroom 1.00, from the dressing, under B7]), ((9.05, 19.25), (9.95, 19.25), (0, 0), [court, sliding])),
)
#let K-fix-1 = ((10.4, 8.1, 12.0, 8.7, [2 basins], "Suite bath"), (12.6, 8.1, 13.186, 8.75, [WC · screened], "Suite bath"), (12.286, 8.9, 13.186, 9.9, [shower 0.9 × 1.0], "Suite bath"), (10.4, 9.6, 12.1, 10.35, [tub 1.7 × 0.75], "Suite bath"))
#let K-fix-2 = ((10.4, 7.5, 12.0, 8.1, [2 basins], "Suite bath"), (12.6, 7.5, 13.186, 8.15, [WC · screened], "Suite bath"), (12.286, 8.5, 13.186, 9.5, [shower 0.9 × 1.0], "Suite bath"), (10.4, 9.6, 12.1, 10.35, [tub 1.7 × 0.75], "Suite bath"))
#let K-fix-3 = ((12.536, 6.95, 13.186, 7.4, [WC], "Suite WC (closet)"), (12.086, 8.1, 13.186, 9.5, [shower 1.1 × 1.4], "Suite bath"), (10.4, 9.6, 12.1, 10.35, [tub 1.7 × 0.75], "Suite bath"), (10.4, 8.3, 11.0, 9.5, [2 basins], "Suite bath"))
#let SK1 = suite-K(8.0, K-fix-1, ((10.3, 8.8), (10.3, 9.6), (1, 0), [bath 0.80, from the lobby]))
#let SK2 = suite-K(7.4, K-fix-2, ((10.3, 8.3), (10.3, 9.1), (1, 0), [bath 0.80, from the lobby]))
#let SK3 = suite-K(6.5, K-fix-3, ((10.3, 6.65), (10.3, 7.65), (1, 0), [bath 1.00, from the lobby, as today]), bath-pts: ((10.3, 6.5), (12.211, 6.5), (12.211, 8.0), (13.311, 8.0), (13.311, 10.45), (10.3, 10.45)), closet: true)
#let K1 = (
  name: [K1 · the whole kids' bath in the suite (its north strip y 6.5–8.0) · bedroom 1 as today], short: "K1",
  rooms: (("Bedroom 1", ((8.95, 0), (10.461, 0), (13.311, 5.245), (13.311, 6.5), (10.3, 6.5), (10.3, 5.3), (8.95, 5.3)), "bed"), ("Family link", rect-pts(8.95, 5.3, 10.3, 6.5), "circ"), ("Bedroom 1 bath", rect-pts(10.3, 6.5, 13.311, 8.0), "wet")) + SK1.rooms,
  furniture: ((9.05, 0.15, 10.25, 2.15, [bed 1.2 × 2.0], "Bedroom 1"), (9.05, 2.5, 9.65, 3.7, [desk 1.2 × 0.6], "Bedroom 1"), (11.4, 5.9, 13.186, 6.5, [wardrobe 1.8 × 0.6], "Bedroom 1"), (9.05, 3.9, 9.65, 4.2, [shelves], "Bedroom 1")) + SK1.furniture,
  fixtures: ((10.4, 6.9, 10.85, 7.5, [basin], "Bedroom 1 bath"), (11.6, 7.3, 12.0, 7.9, [WC], "Bedroom 1 bath"), (12.286, 6.6, 13.186, 7.9, [shower 0.9 × 1.3], "Bedroom 1 bath")) + SK1.fixtures,
  showers: (), cupboards: (),
  doors: (((9.05, 5.3), (10.05, 5.3), (0, -1), [bedroom 1 door 1.00, opens in]), ((10.45, 6.5), (11.25, 6.5), (0, -1), [kids' bath 0.80, from the entry strip, opens into the bedroom, under B6])) + SK1.doors,
  windows: (((11.33, 1.6), (12.2, 3.2), [bedroom 1 escape (the cut)]), ((9.2, 0), (10.2, 0), [bedroom 1 north]), ((W, 7.3), (W, 7.8), [kids' bath · or a fan]), ((W, 9.0), (W, 9.5), [suite bath · or a fan]), ((W, 16.2), (W, 18.2), [suite bedroom escape])),
  labels: ("Bedroom 1": (10.75, 3.0), "Family link": (9.62, 5.9), "Bedroom 1 bath": (11.6, 6.85), "Suite lobby": (9.62, 8.3), "Suite bath": (11.5, 9.2), "Suite dressing": (11.3, 11.75), "Suite bedroom": (11.2, 15.6)),
  walls-off: ("y 5.3 (link / bedroom 1)", "x 10.3 (y 5.3–10.45)", "y 8.0 (kids' bath / suite bath, 1.5 off B6)"),
)
#let K2 = (
  name: [K2 · half and half: the kids' bath across the y 6.5 line (y 5.3–7.4) · bedroom 1 four-sided to y 5.3 · two cupboards in the leftovers], short: "K2",
  rooms: (("Bedroom 1", ((8.95, 0), (10.461, 0), (13.311, 5.245), (13.311, 5.3), (8.95, 5.3)), "bed"), ("Family link", rect-pts(8.95, 5.3, 10.3, 6.5), "circ"), ("Bedroom 1 bath", rect-pts(11.3, 5.3, 13.311, 7.4), "wet"))
    + SK2.rooms.map(r => if r.at(0) == "Suite bath" { ("Suite bath", rect-pts(10.3, 7.4, 13.311, 10.45), "wet") } else { r }),
  furniture: ((9.05, 0.15, 10.25, 2.15, [bed 1.2 × 2.0], "Bedroom 1"), (9.05, 2.5, 9.65, 3.7, [desk 1.2 × 0.6], "Bedroom 1"), (9.05, 3.9, 9.65, 4.2, [shelves], "Bedroom 1")) + SK2.furniture,
  fixtures: ((11.4, 6.5, 11.85, 7.1, [basin], "Bedroom 1 bath"), (12.586, 5.5, 13.186, 5.9, [WC], "Bedroom 1 bath"), (12.186, 6.4, 13.186, 7.3, [shower 1.0 × 0.9], "Bedroom 1 bath")) + SK2.fixtures,
  showers: (), cupboards: ((10.3, 5.3, 11.3, 6.5, [kids' closet 1.0 × 1.2]), (10.3, 6.5, 11.3, 7.4, [suite linen])),
  doors: (((9.05, 5.3), (10.05, 5.3), (0, -1), [bedroom 1 door 1.00, opens in]), ((11.5, 5.3), (12.3, 5.3), (0, 1), [kids' bath 0.80, from the bedroom, opens into the bath]), ((10.4, 5.3), (11.2, 5.3), (0, 0), [closet, bi-fold])) + SK2.doors,
  windows: (((11.33, 1.6), (12.2, 3.2), [bedroom 1 escape (the cut)]), ((9.2, 0), (10.2, 0), [bedroom 1 north]), ((W, 5.6), (W, 6.2), [kids' bath · or a fan]), ((W, 8.9), (W, 9.4), [suite bath · or a fan]), ((W, 16.2), (W, 18.2), [suite bedroom escape])),
  labels: ("Bedroom 1": (10.75, 3.0), "Family link": (9.62, 5.9), "Bedroom 1 bath": (12.3, 6.15), "Suite lobby": (9.62, 8.3), "Suite bath": (11.5, 8.9), "Suite dressing": (11.3, 11.75), "Suite bedroom": (11.2, 15.6)),
  walls-off: ("y 5.3 (bedroom 1 / link / bath, one line x 8.95–13.311)", "x 10.3 (y 5.3–10.45)", "x 11.3 (y 5.3–7.4)", "y 7.4 (kids' bath / suite bath, 0.9 off B6)"),
)
#let K3 = (
  name: [K3 · reference (A′): the whole kids' bath in bedroom 1 (y 5.0–6.5) · the suite with its WC closet as today, to the C33 line], short: "K3",
  rooms: (("Bedroom 1", ((8.95, 0), (10.461, 0), (cut-x(5.0), 5.0), (8.95, 5.0)), "bed"), ("Family link", rect-pts(8.95, 5.0, 10.3, 6.5), "circ"), ("Bedroom 1 bath", ((10.3, 5.0), (cut-x(5.0), 5.0), (13.311, 5.245), (13.311, 6.5), (10.3, 6.5)), "wet")) + SK3.rooms,
  furniture: kids-N(5.0) + SK3.furniture,
  fixtures: ((10.4, 5.95, 10.85, 6.35, [basin], "Bedroom 1 bath"), (11.5, 5.8, 11.9, 6.4, [WC], "Bedroom 1 bath")) + SK3.fixtures, showers: ((shower-cut(12.3, 5.1), [shower 0.9 × 1.3], "Bedroom 1 bath"),),
  cupboards: (),
  doors: (((9.05, 5.0), (10.05, 5.0), (0, -1), [bedroom 1 door 1.00, opens in]), ((10.4, 5.0), (11.2, 5.0), (0, 1), [kids' bath 0.80, from the bedroom]), ((12.211, 6.8), (12.211, 7.8), (0, 0), [WC sliding])) + SK3.doors,
  windows: (((11.33, 1.6), (12.2, 3.2), [bedroom 1 escape (the cut)]), ((9.2, 0), (10.2, 0), [bedroom 1 north]), ((W, 5.6), (W, 6.2), [kids' bath · or a fan]), ((W, 8.4), (W, 9.1), [suite bath]), ((W, 16.2), (W, 18.2), [suite bedroom escape])),
  labels: ("Bedroom 1": (10.75, 2.9), "Family link": (9.62, 5.75), "Bedroom 1 bath": (11.6, 5.45), "Suite lobby": (9.62, 8.3), "Suite bath": (11.4, 8.9), "Suite WC (closet)": (12.76, 7.75), "Suite dressing": (11.3, 11.75), "Suite bedroom": (11.2, 15.6)),
  walls-off: ("y 5.0 (0.3 off the GF wall)", "x 10.3 (y 5.0–10.45)", "y 8.0 / x 12.211 (closet)"),
)
#let K-layouts = (K1, K2, K3)
#let all7 = (T, L1, L2, L3, K1, K2, K3)
#let MW(L) = Cz(L, "Suite bath") + Cz(L, "Suite WC (closet)") + Cz(L, "Suite bath · dressing")   // the master's wet rooms, clear
#let MD(L) = Cz(L, "Suite dressing")
#let lbl(L) = if L.short == "today" { [Today] } else { [#L.short] }

#pagebreak()
#text(12pt, weight: "bold", fill: accent)[The kids' bath: K1 in the suite · K2 half and half · K3 in bedroom 1 (A′)] #h(1fr) #text(6.4pt, fill: gray)[the owner's direction, 11 Nov 2026 · bedroom 1 keeps its size as far as possible · relaxed hood rule: no drain over the hood · m² on axes · ≈ clear]
#v(1pt) #line(length: 100%, stroke: 0.6pt + accent)
#grid(columns: (4.9cm, 4.9cm, 4.9cm, 1fr), column-gutter: 5pt,
  ..K-layouts.map(L => [#block(height: 2.6em, text(6.4pt, weight: "bold", fill: accent)[#L.name]) #plan(L, length: 0.8cm)]),
  [
    #text(6.4pt)[
      *The suite in K1–K3* (the same frame for the three, so that only the kids' bath differs): the lobby x 8.95–10.3 to y 10.45; the bath on the east wall up to *the column line C33 (y 10.45)*, allowed again by the relaxed rule (the tub's drain at x 10.4–12.1, west of the hood; the wardrobes over it are dry); the dressing the full width y 10.45–13 as the hub (L2's idea), the bedroom the whole south bay with the court door. *Checks:* #for L in K-layouts [*#L.short:* #if all-ok(L) [passed (#checks(L).len())] else [FAILED: #checks(L).filter(c => not c.at(1)).map(c => c.at(0)).join([; ])] · ]
      \ \ *K1 · whole in the suite.* Bedroom 1 exactly as today (*#r2(C(K1, "Bedroom 1")) m²*, the link's notch, the wardrobe in the entry strip). The kids' bath takes the suite's north strip x 10.3–13.311 × y 6.5–8.0 (*#r2(C(K1, "Bedroom 1 bath")) m²*, 1.3 wide: the shower over the stack, the basin on the west wall, the WC on the new wall y 8.0), its door in the y 6.5 wall under B6 from the entry strip. *The suite:* the bath shrinks to y 8.0–10.45 (*#r2(C(K1, "Suite bath")) m²* clear, 2.25 deep): two basins on the shared wall, the WC screened in the stack corner, the shower on the east wall, the tub along the south; *the WC closet is lost*; the bath door from the lobby. The dressing #r2(C(K1, "Suite dressing")), the bedroom #r2(C(K1, "Suite bedroom")). *Moves inside the suite:* the bath door south by 2.2 m, the vanity from the west wall to the north wall, the closet gone.
      \ \ *K2 · half and half.* The kids' bath x 11.3–13.311 × y 5.3–7.4 (*#r2(C(K2, "Bedroom 1 bath")) m²*, 1.8 × 1.9 clear): 1.2 m of it is bedroom 1's former entry strip, 0.9 m the suite's. *Bedroom 1 becomes four-sided* with one straight south wall on y 5.3 (the link's wall continued to the east wall): *#r2(C(K2, "Bedroom 1")) m²*; the leftover x 10.3–11.3 × 5.3–6.5 is its built-in closet (bi-fold doors on the y 5.3 line). The bath's door in the y 5.3 wall from the bedroom; the WC on the east wall, the basin on the west, the shower at the south end over the stack. *The suite:* the leftover x 10.3–11.3 × 6.5–7.4 is its linen cupboard off the lobby; the bath y 7.4–10.45 (*#r2(C(K2, "Suite bath")) m²*, 2.85 deep: basins on the shared wall, the WC screened at the stack corner, the shower east, the tub south); the WC closet lost; the dressing and the bedroom as K1. *The y 6.5 wall* is interrupted for 2.0 m over B6 (a wall off a beam, not a beam off a wall: B6 carries the slab; the engineer notes it).
      \ \ *K3 · reference (A′).* The whole kids' bath in bedroom 1's south band y 5.0–6.5 (*#r2(C(K3, "Bedroom 1 bath")) m²*, 1.3 wide, the shower in the cut's corner at C32): bedroom 1 *#r2(C(K3, "Bedroom 1")) m²*, the link 1.5 deep. *The suite untouched in its wet rooms:* the bath with its WC closet to the C33 line (*#r2(C(K3, "Suite bath") + C(K3, "Suite WC (closet)")) m²*), its door from the lobby as today, the tub moved west of the hood; the dressing and the bedroom as K1.
      \ \ *No better variant found:* the wet band of the suite is y 6.5–10.45 (3.95 m) and the kids' bath needs 1.3–1.5 m of it or 1.5 m of bedroom 1; every other cut either jogs a wall (a shower niche through the y 6.5 wall), narrows the lobby below 1.0 m, or puts a drain over the hood or the living. K2 is the found compromise: half the depth from each side, every wall straight.
    ]
  ],
)

#pagebreak()
#text(12pt, weight: "bold", fill: accent)[Comparison of the seven · privacy and noise · recommendation · #ah[الخلاصة]]
#v(1pt) #line(length: 100%, stroke: 0.6pt + accent)
#grid(columns: (1.25fr, 1fr), column-gutter: 10pt,
  [
    #table(columns: (1.5fr, ..range(7).map(_ => 1fr)), stroke: 0.3pt + luma(190), inset: 2.2pt, align: (left, ..range(7).map(_ => right)), fill: (_, y) => if y == 0 { rgb("#e1e9e3") } else if calc.even(y) { rgb("#efece4") },
      table.header([*Clear m² (axes in page 2)*], ..all7.map(L => [*#lbl(L)*])),
      [*1 · Suite bedroom*], ..all7.map(L => [#r2(C(L, "Suite bedroom"))]),
      [*2 · Suite bath + WC*], ..all7.map(L => [#r2(MW(L))]),
      [… of which a WC closet], ..all7.map(L => if P-of(L, "Suite WC (closet)") == none { [—] } else { [#r2(C(L, "Suite WC (closet)"))] }),
      [*3 · Suite dressing*], ..all7.map(L => if P-of(L, "Suite dressing") == none { [in the bath] } else { [#r2(MD(L))] }),
      [Suite lobby], ..all7.map(L => [#r2(C(L, "Suite lobby"))]),
      [4 · Suite court], ..all7.map(L => [as is]),
      [*Bedroom 1*], ..all7.map(L => [#r2(C(L, "Bedroom 1"))]),
      [*Kids' bath*], ..all7.map(L => if P-of(L, "Bedroom 1 bath") == none { [—] } else { [#r2(C(L, "Bedroom 1 bath"))] }),
      [Family link], ..all7.map(L => [#r2(C(L, "Family link"))]),
      [Rooms with an L (no small jog)], ..all7.map(L => [#L.rooms.filter(r => reflex(r.at(1))).len()]),
      [Wall lines off the beam / column lines], ..all7.map(L => [#L.walls-off.len()]),
      [Farthest drain from the stack], ..all7.map(L => if L.short == "today" { [≈ 3.7 m] } else { [#r1(stack-max(L)) m] }),
      [Kids' bath over], [—], [laundry], [laundry], [kitchen N], [kitchen N], [laundry + kitchen], [laundry],
      [Suite bath reaches the C33 line], [yes], [no (10.0)], [no (10.0)], [no], [yes], [yes], [yes],
    )
    #v(2pt)
    #text(6.2pt, fill: gray)[Today = `data/rooms_ff.csv` V10.0. L1–L3 = pages 1–3 (the suite bath stopped at y 10.0 under the strict hood rule; with the relaxed rule it may run to 10.45 as in K1–K3, + ≈ 1.3 m²). The master's priorities: 1 the bedroom (the same 25.02 in every re-design, +1.42 on today), 2 the bath, 3 the dressing, 4 the court (untouched everywhere). K3's bedroom 1 and bath are A′ of `studies/kids_room.typ` with the bath's west wall on x 10.3 (the straight lobby line) instead of 10.15.]
    #v(3pt)
    #H[Privacy and noise between the two]
    #text(6.6pt)[
      - *No layout puts a kids' wall against the master bedroom:* the suite bedroom (y 13–19.25) is three rooms away from bedroom 1 in every one; its only shared walls are with the dressing (y 13, on B7) and the court / office.
      - *K1:* the kids' bath's walls are the lobby's (x 10.3) and the suite bath's (y 8.0): wet against wet, the best pairing; the kids' bath door opens into bedroom 1, so its noise stays on the children's side. Build the y 8.0 wall as a 0.20 block wall (or two leaves with 50 mm wool) with the pipes in the kids' side; no door between the two baths.
      - *K2:* the kids' bath's south wall (y 7.4) is the suite bath's, its west wall the suite's linen cupboard and the link: again wet against wet / cupboard; the 2.0 m gap in the y 6.5 wall is closed by the bath's own walls.
      - *K3:* the kids' bath and the suite bath are back to back on the y 6.5 wall over B6, the stack common: wet against wet.
      - *All:* the link and the lobby are the buffer between bedroom 1's door and the suite door (two doors, 1.2 m apart on the y 6.5 line); acoustic door seals on both; the kids' bath's fan ducted to the east wall, not into the suite.
    ]
  ],
  [
    #box(fill: accent.lighten(86%), stroke: 1pt + accent, inset: 6pt, radius: 3pt, width: 100%)[
      #text(9.5pt, weight: "bold", fill: accent)[Recommendation: K2 · with K1 if bedroom 1 must stay exactly as today] \
      #text(7pt)[
        *K2* answers the owner's direction with every wall straight: bedroom 1 keeps #r2(C(K2, "Bedroom 1")) m² clear as a four-sided room (today's L of #r2(C(T, "Bedroom 1")) held the wardrobe in its 1.2 m entry strip; the strip is now the bath and a built-in closet), the kids' bath #r2(C(K2, "Bedroom 1 bath")) m² has its shower over the stack, and the master keeps a separate bath of #r2(C(K2, "Suite bath")) m² (today's #r2(MW(T)) with the closet) and the full dressing #r2(C(K2, "Suite dressing")) m² (today #r2(MD(T))), the bedroom #r2(C(K2, "Suite bedroom")) m². Its price: the WC closet, and a 2.0 m break in the y 6.5 wall over B6 for the engineer to note.
        \ *K1* keeps bedroom 1 to the centimetre but takes the whole depth from the master: its bath falls to #r2(C(K1, "Suite bath")) m², 2.25 m deep with the tub, the shower and a screened WC in a row: workable, not generous, for priority 2. *K3* costs the master nothing and bedroom 1 #r2(C(T, "Bedroom 1") - C(K3, "Bedroom 1")) m²: the owner's earlier choice, kept as the reference.
        \ *Either way the suite keeps:* the bedroom the whole south bay, the dressing the full width as the hub, the one stack, the court untouched, every column and beam in place, the windows still to be set with the facades.
      ]
    ]
    #v(4pt)
    #box(fill: rgb("#f4efe3"), stroke: 0.6pt + luma(170), inset: 6pt, radius: 3pt, width: 100%)[
      #ah[
        #text(9pt, weight: "bold", fill: accent)[الخلاصة بالعربية · خيارات حمّام الأطفال] \
        #text(7.4pt)[
          توجيه المالك: تحتفظ غرفة الأطفال (غرفة النوم 1) بحجمها قدر الإمكان، ويوضع حمّامها المدمج (مرحاض ومغسلة ودُش بخلاط على الجدار، ≈ 3.3 م²) بأحد ثلاثة أشكال؛ قاعدة الشفّاط المخففة: لا مصرف فوق شفّاط المطبخ، والتجهيزات الجافة مسموحة. \
          *K1 (كله داخل الجناح):* غرفة الأطفال كما هي (#r2(C(K1, "Bedroom 1")) م²)، والحمّام في الشريط الشمالي من الجناح (#r2(C(K1, "Bedroom 1 bath")) م²) وبابه من الغرفة تحت الجسر B6؛ يصغر حمّام الوالدين إلى #r2(C(K1, "Suite bath")) م² ويفقد غرفة المرحاض؛ غرفة الملابس #r2(C(K1, "Suite dressing")) م² وغرفة النوم #r2(C(K1, "Suite bedroom")) م². \
          *K2 (نصف ونصف، الموصى به):* الحمّام عبر خط y 6.5 (#r2(C(K2, "Bedroom 1 bath")) م²)، نصفه من شريط مدخل غرفة الأطفال ونصفه من الجناح؛ تصير غرفة الأطفال بأربعة جدران مستقيمة (#r2(C(K2, "Bedroom 1")) م²) مع خزانة مدمجة، ويبقى لحمّام الوالدين #r2(C(K2, "Suite bath")) م² منفصلًا وغرفة الملابس كاملة #r2(C(K2, "Suite dressing")) م². \
          *K3 (المرجع A′):* الحمّام كله داخل غرفة الأطفال (#r2(C(K3, "Bedroom 1")) م² للغرفة)، والجناح بغرفة مرحاضه كما هو (#r2(MW(K3)) م²). \
          لا جدار مشترك بين غرفة الأطفال وغرفة نوم الوالدين في أي خيار؛ الجدران المشتركة بين الحمّامين رطب إلى رطب. *التوصية: K2*، وK1 إن وجب بقاء غرفة الأطفال كما هي تمامًا.
        ]
      ]
    ]
  ],
)

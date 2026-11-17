// step_corner.typ · Taif / Palm House · STUDY (owner, 17 Nov 2026): ONE orthogonal STEP instead of the slanted north-east cut wall, on TODAY's site position (B1 6.00 m from M1, no shift).
// Today the cut runs on axes from (10.461, 0) to (13.311, 5.245). The step: the north wall ends at x = XS, the east wall starts at y = YS; the rectangle x XS–13.311 × y 0–YS is given up.
// The limits (SITE_SETOUT.md § 5, both readings, every outer face sampled at 5 cm): (A) the deed setback line (base.typ `env`): today 0.91 m at the lane notch; (B) a setback of 2.0 m from the
// lane wall AS BUILT: the model's lane line (base.typ `lane`) less the 0.62 m the sheet uses for the wall as built (3.09 model / 2.47 as built at the tightest point), less 2.0: today 0.42 m.
// The north corner is limited by reading B (x ≤ 10.59: the maid partition line x 10.65 fails it by 5 cm), the east corner by the notch (y ≥ 4.16). Chosen: XS 10.55, YS 4.2 (the 5 cm grid).
// Nothing in the design files is changed. CSV frame: x east, y south, wall centre lines; the outer walls 0.25, the inner walls 0.20, partitions 0.10.
#import "@preview/cetz:0.4.2"
#import "../base.typ": env, lane

#set page(paper: "a4", flipped: true, margin: 7mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 7.2pt)
#set par(leading: 0.42em)
#let ink = rgb("#3d4a45"); #let accent = rgb("#2f6b4f"); #let red = rgb("#b5452f"); #let blue = rgb("#2f5f8a"); #let gray = rgb("#6d736f"); #let brown = rgb("#8a5a2b"); #let amber = rgb("#c98a12")
#let r2(v) = { let s = str(calc.round(v, digits: 2)); if not s.contains(".") { s + ".00" } else if s.split(".").at(1).len() == 1 { s + "0" } else { s } }
#let r3(v) = str(calc.round(v, digits: 3))
#let ah(t) = text(font: ("Segoe UI", "Arial", "Tahoma"), lang: "ar", dir: rtl, t)
#let rect-pts(x0, y0, x1, y1) = ((x0, y0), (x1, y0), (x1, y1), (x0, y1))

// ---------- the step and the site readings ----------
#let XS = 10.55; #let YS = 4.2                                    // the step's corner on axes
#let XE = 13.311; #let XW = 8.95                                 // the east wall; the women's majlis / maid wing wall
#let shift = (0.91, 6.0734)                                      // design frame → site frame (design_gf.typ, 8 Nov 2026: B1 6.00 m from M1)
#let built-offset = 0.62                                         // the lane wall as built lies ≈ 0.62 m inside the model's lane line (SITE_SETOUT.md § 5: 3.09 model, 2.47 as built)
#let setback-built = 2.0                                         // the field rule: 2.0 m from the wall as built
#let faces-today = ((-0.125, -0.125), (10.535, -0.125), (13.436, 5.214), (13.436, 24.125), (-0.125, 24.125))   // the outer faces (studies/setout.typ)
#let faces-step = ((-0.125, -0.125), (XS + 0.125, -0.125), (XS + 0.125, YS - 0.125), (XE + 0.125, YS - 0.125), (XE + 0.125, 24.125), (-0.125, 24.125))
#let dist(a, b) = calc.sqrt(calc.pow(a.at(0) - b.at(0), 2) + calc.pow(a.at(1) - b.at(1), 2))
#let pseg(p, a, b) = { let dx = b.at(0) - a.at(0); let dy = b.at(1) - a.at(1); let l2 = dx * dx + dy * dy
  let t = if l2 == 0 { 0 } else { calc.max(0, calc.min(1, ((p.at(0) - a.at(0)) * dx + (p.at(1) - a.at(1)) * dy) / l2)) }; dist(p, (a.at(0) + t * dx, a.at(1) + t * dy)) }
#let deed-dist(p) = calc.min(..range(env.len()).filter(i => { let a = env.at(i); let b = env.at(calc.rem(i + 1, env.len())); not (calc.abs(a.at(0)) < 0.01 and calc.abs(b.at(0)) < 0.01) }).map(i => pseg(p, env.at(i), env.at(calc.rem(i + 1, env.len())))))
#let lane-dist(p) = calc.min(..range(lane.len() - 1).map(i => pseg(p, lane.at(i), lane.at(i + 1))))
#let S(p) = (p.at(0) + shift.at(0), p.at(1) + shift.at(1))
#let face-pts(P) = { let out = (); let n = P.len()
  for i in range(n) { let a = P.at(i); let b = P.at(calc.rem(i + 1, n)); let k = calc.max(1, int(calc.ceil(dist(a, b) / 0.05)))
    for j in range(k) { let t = j / k; out.push((a.at(0) + t * (b.at(0) - a.at(0)), a.at(1) + t * (b.at(1) - a.at(1)))) } }
  out }
#let readings(P) = { let pts = face-pts(P)
  let a = pts.sorted(key: p => deed-dist(S(p))).first(); let b = pts.sorted(key: p => lane-dist(S(p))).first()
  (deed: deed-dist(S(a)), deed-at: a, built: lane-dist(S(b)) - built-offset - setback-built, built-at: b) }
#let today = readings(faces-today); #let step = readings(faces-step)
#let env-design = env.map(p => (p.at(0) - shift.at(0), p.at(1) - shift.at(1)))   // the deed setback line in the design frame (drawn)
#let lost-today = 2.85 * 5.245 / 2; #let lost-step = (XE - XS) * YS           // the corner given up, per floor, on axes

// ---------- the rooms (name, rect, kind) · clear = inside the walls (0.125 on the outer walls x 8.95? no: x 8.95 is an inner wall; outer: y 0, x XS (y 0–YS), y YS (x XS–XE), x XE) ----------
#let outer-x(x) = calc.abs(x - XE) < 1e-6 or calc.abs(x - XS) < 1e-6
#let outer-y(y) = calc.abs(y) < 1e-6 or calc.abs(y - YS) < 1e-6
#let clear-box(b, light: ()) = {   // (x0, y0, x1, y1) on axes → inside the walls; `light` = sides with a 0.10 partition (0.05 off)
  let h(v, outer, side) = if side in light { 0.05 } else if outer { 0.125 } else { 0.10 }
  (b.at(0) + h(b.at(0), outer-x(b.at(0)) and b.at(1) < YS + 1e-6 and b.at(0) > XS - 1e-6 or calc.abs(b.at(0) - XE) < 1e-6, "w"),
   b.at(1) + h(b.at(1), outer-y(b.at(1)) and (calc.abs(b.at(1)) < 1e-6 or b.at(2) > XS + 1e-6), "n"),   // a room whose north wall is the step face (even partly) takes the outer 0.125
   b.at(2) - h(b.at(2), (calc.abs(b.at(2) - XS) < 1e-6 and b.at(1) < YS - 1e-6) or calc.abs(b.at(2) - XE) < 1e-6, "e"),
   b.at(3) - h(b.at(3), false, "s")) }
#let cw(c) = c.at(2) - c.at(0); #let cd(c) = c.at(3) - c.at(1); #let carea(c) = cw(c) * cd(c)
#let gf-rooms = (
  ("Outdoor store", (XW, 0, XS, 2.3), "store", ("s",)),       // from the north strip outside (the family's parking strip); shelves
  ("Maid bath", (XW, 2.3, XS, YS), "wet", ("n",)),            // a simple wet room: a wall shower over a floor drain, the WC, the basin; its door from her room only; a high window on the step's face
  ("Maid room", (XW, YS, XE, 6.5), "maid", ()),              // the whole band, 4.14 × 2.08 clear; the bed on the laundry wall, the wardrobe on the north wall, the desk at the east window (escape casement)
  ("Laundry", (XW, 6.5, XE, 8.3), "laundry", ("s",)),         // moved into the kitchen's north band, 1.8 m deep as today: the machines on the kitchen wall, the folding table on the majlis wall
  ("Kitchen (north part)", (XW, 8.3, XE, 13.0), "kitchen", ("n",)),   // 4.7 m deep (today 6.5): the sink window, the service door and the counters shift 1.8 m south (not drawn)
)
#let ff-rooms = (
  ("Bedroom 1 bath (F20)", (XW, 0, XS, YS), "wet", ()),       // the whole strip, 1.38 × 3.98 clear: the shower at the north end, the WC over the maid bath, the basin by the door; its door from the link
  ("Family link", (XW, YS, 10.15, 6.5), "circ", ()),          // 1.0 × 2.2 clear: the suite door (y 6.5), bedroom 1's door (x 10.15), the kids' bath door (y 4.2); open to the family living
  ("Bedroom 1", (10.15, YS, XE, 8.0), "bed", ()),             // a clean rectangle 2.94 × 3.58 clear; the suite's WC closet (x 10.3–11.5 × y 6.5–8.0) is inside it: the WC goes back into the suite bath
  ("Suite bath (WC inside)", (10.3, 8.0, XE, 10.45), "suiteg", ()),
  ("Suite lobby", (XW, 6.5, 10.3, 11.9), "circg", ()),
)
#let clear-of(r) = clear-box(r.at(1), light: r.at(3))
// today (data/rooms_gf.csv, studies/ff_family.typ, the presentation's schedule of 17 Nov 2026: axes / clear)
#let today-gf = (("Maid room", 10.17, 8.85, "L-shaped, to the cut"), ("Maid bath", 2.94, 2.50, "sloped, to the cut"), ("Laundry", 7.77, 6.75, "4.36 × 1.8 (+ the cut's end)"), ("Kitchen", 28.35, 26.06, "4.36 × 6.5"))
#let today-ff = (("Bedroom 1", 17.80, 15.70, "9-point polygon, to the cut"), ("Bedroom 1 bath (F20)", 4.35, 3.49, "1.81 × 2.4"), ("Family link", 1.44, 1.10, "1.2 × 1.2"), ("Suite WC (closet)", 1.80, 1.30, "1.2 × 1.5"), ("Suite bath", 7.38, 6.27, "3.01 × 2.45"))
#let cut-today = ((10.461, 0), (13.311, 5.245))
#let today-walls-gf = (((10.65, 3.2), (12.1996, 3.2)), ((10.65, 3.2), (10.65, 4.7)), ((XW, 4.7), (13.0148, 4.7)))   // the maid bath's and the laundry's walls today (dashed)
#let today-walls-ff = (((11.5, 5.6), (13.311, 5.6)), ((11.5, 5.6), (11.5, 8.0)), ((10.15, 5.3), (10.15, 6.5)), ((XW, 5.3), (10.15, 5.3)), ((10.3, 6.5), (11.5, 6.5)), ((10.3, 6.5), (10.3, 8.0)))

// ---------- furniture, fixtures, doors, windows ----------
#let gf-furn = (   // (x0, y0, x1, y1, label, room)
  (9.05, 0.125, 9.45, 2.2, [shelves], "Outdoor store"), (9.5, 1.5, 10.425, 2.2, [shelves], "Outdoor store"),
  (9.05, 2.425, 9.8, 3.225, [shower · floor drain], "Maid bath"), (9.825, 2.45, 10.425, 2.85, [WC], "Maid bath"), (10.025, 3.35, 10.425, 3.75, [basin], "Maid bath"),
  (9.05, 5.5, 11.05, 6.4, [bed 0.9 × 2.0], "Maid room"), (11.3, 4.325, 12.65, 4.925, [wardrobe 1.35 × 0.6], "Maid room"), (12.686, 5.1, 13.186, 5.9, [desk], "Maid room"), (12.15, 5.15, 12.55, 5.55, [], "Maid room"),
  (9.05, 6.6, 9.65, 8.1, [folding · ironing table], "Laundry"), (9.9, 7.6, 10.5, 8.2, [washer 1], "Laundry"), (10.55, 7.6, 11.15, 8.2, [washer 2 + dryer], "Laundry"), (11.2, 7.6, 11.8, 8.2, [cupboards], "Laundry"), (11.85, 7.6, 12.4, 8.2, [steam station], "Laundry"),
)
#let ff-furn = (
  (9.05, 0.125, 9.95, 1.025, [shower 0.9 × 0.9], "Bedroom 1 bath (F20)"), (9.05, 2.5, 9.65, 2.9, [WC · wall-hung], "Bedroom 1 bath (F20)"), (10.025, 3.3, 10.425, 3.7, [basin], "Bedroom 1 bath (F20)"),
  (11.7, 4.325, 13.1, 6.325, [bed 1.4 × 2.0], "Bedroom 1"), (11.25, 4.325, 11.65, 4.725, [], "Bedroom 1"), (10.25, 6.6, 10.85, 7.7, [desk 1.1 × 0.6], "Bedroom 1"), (10.95, 6.85, 11.35, 7.25, [], "Bedroom 1"), (11.3, 7.3, 13.1, 7.9, [wardrobe 1.8 × 0.6], "Bedroom 1"),
  (10.7, 8.1, 11.1, 8.65, [WC (screened)], "Suite bath (WC inside)"), (11.9, 8.1, 13.186, 9.0, [shower], "Suite bath (WC inside)"), (12.586, 9.1, 13.186, 10.05, [2 basins], "Suite bath (WC inside)"), (10.4, 9.6, 12.1, 10.35, [tub], "Suite bath (WC inside)"),
)
#let gf-doors = (   // (a, b, into, label)
  ((9.55, 0), (10.35, 0), (0, 1), [store 0.80, from outside (the north strip)]),
  ((9.1, YS), (9.8, YS), (0, -1), [maid bath 0.70, from her room, opening in]),
  ((11.5, 6.5), (12.4, 6.5), (0, -1), [maid room 0.90, from the laundry]),
  ((12.45, 8.3), (13.186, 8.3), (0, 0), [kitchen ↔ laundry: an open entrance 0.74 (no leaf)]),
)
#let ff-doors = (
  ((9.1, YS), (9.8, YS), (0, -1), [kids' bath 0.70, from the link, opening in]),
  ((10.15, 5.4), (10.15, 6.4), (1, 0), [bedroom 1 0.90, from the link (a right angle to the suite door)]),
  ((9.0, 6.5), (10.1, 6.5), (0, 1), [suite door]),
  ((10.3, 8.8), (10.3, 9.6), (1, 0), [suite bath, from the lobby]),
)
#let gf-windows = (((XE, 4.9), (XE, 6.0), [maid room: the escape casement 1.1 × 1.0, sill +1.10]), ((XS, 2.5), (XS, 3.0), [maid bath: high, obscure]), ((XE, 6.9), (XE, 7.8), [laundry]))
#let ff-windows = (((XE, 6.4), (XE, 7.2), [bedroom 1: the escape casement]), ((12.0, YS), (13.0, YS), [bedroom 1: north window]), ((9.2, 0), (9.9, 0), [F20: high window]))
#let open-edges = (((XW, 5.3), (XW, 6.5)),)   // the link open to the family living, as today
// structure at the corner: today's and the step's columns (x, y, id, note)
#let cols-today = ((10.461, 0, "C30"), (11.982, 2.8, "C31"), (13.311, 5.245, "C32"))
#let cols-step = ((XS, 0, "C30′", [the north wall / step corner: C30 moved 0.09 m east]), (XS, YS, "C31′", [the re-entrant corner: C31 moved from the cut's middle]), (XE, YS, "C32′", [the step / east wall corner: C32 moved 1.05 m north]), (XE, 6.5, "C33′", [NEW on the y 6.5 line: the east wall's span 2.3 + 3.95 m instead of 6.25 (to C33 at y 10.45)]))

// ---------- checks ----------
#let box-in(b, c) = b.at(0) >= c.at(0) - 1e-6 and b.at(1) >= c.at(1) - 1e-6 and b.at(2) <= c.at(2) + 1e-6 and b.at(3) <= c.at(3) + 1e-6
#let overlap(a, b) = not (a.at(2) <= b.at(0) + 1e-9 or b.at(2) <= a.at(0) + 1e-9 or a.at(3) <= b.at(1) + 1e-9 or b.at(3) <= a.at(1) + 1e-9)
#let bx(f) = (f.at(0), f.at(1), f.at(2), f.at(3))
#let no-overlaps(L) = range(L.len()).all(i => range(L.len()).all(j => i == j or not overlap(L.at(i), L.at(j))))
#let swing(d) = { let (a, b, dir) = (d.at(0), d.at(1), d.at(2)); let w = dist(a, b); let (x0, x1, y0, y1) = (calc.min(a.at(0), b.at(0)), calc.max(a.at(0), b.at(0)), calc.min(a.at(1), b.at(1)), calc.max(a.at(1), b.at(1)))
  if dir.at(1) < 0 { (x0, y0 - w, x1, y0) } else if dir.at(1) > 0 { (x0, y0, x1, y0 + w) } else if dir.at(0) > 0 { (x0, y0, x0 + w, y1) } else if dir.at(0) < 0 { (x0 - w, y0, x0, y1) } else { (x0, y0, x1, y1) } }
#let room-of(rooms, n) = rooms.find(r => r.at(0) == n)
#let ok = (
  (gf-furn.all(f => box-in(bx(f), clear-of(room-of(gf-rooms, f.at(5))))) and no-overlaps(gf-furn.map(bx))),
  (ff-furn.all(f => box-in(bx(f), clear-of(room-of(ff-rooms, f.at(5))))) and no-overlaps(ff-furn.map(bx))),
  gf-doors.map(swing).all(s => gf-furn.map(bx).all(b => not overlap(s, b))) and ff-doors.map(swing).all(s => ff-furn.map(bx).all(b => not overlap(s, b))),
  step.deed >= today.deed - 1e-6 and step.built >= today.built - 1e-6,
  carea(clear-of(room-of(gf-rooms, "Maid room"))) >= 7.28,
  calc.abs(gf-rooms.slice(0, 4).map(r => { let b = r.at(1); (b.at(2) - b.at(0)) * (b.at(3) - b.at(1)) }).sum() - ((XE - XW) * 8.3 - lost-step)) < 0.01,   // the GF rooms tile the corner to y 8.3
)
#let all-ok = ok.all(v => v)

// ======================= PAGE 1 · the two plans =======================
#text(12.5pt, weight: "bold", fill: accent)[One step instead of the slanted north-east wall · today's site position · the corner on both floors] #h(1fr) #text(6.6pt, fill: gray)[study · design files unchanged · 1 : 50 · CSV frame, north up · the step: the north wall to x #r2(XS), the east wall from y #r2(YS)]
#v(1pt) #line(length: 100%, stroke: 0.6pt + accent)
#let q(p) = (p.at(0), -p.at(1))
#let hatch = tiling(size: (3pt, 3pt))[#place(line(start: (0pt, 3pt), end: (3pt, 0pt), stroke: 0.3pt + red))]
#let plan(rooms, furn, doors, windows, today-walls, title, gf: true) = cetz.canvas(length: 2.0cm, {
  import cetz.draw: *
  let T(p, body, size: 4.2pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, body))
  let (x0, y0, x1, y1) = (8.5, -0.3, 13.75, 8.5)
  let R(b, fill: none, stroke: none) = { let c = (calc.max(b.at(0), x0), calc.max(b.at(1), y0), calc.min(b.at(2), x1), calc.min(b.at(3), y1))   // clipped to the window
    if c.at(2) > c.at(0) and c.at(3) > c.at(1) { rect(q((c.at(0), c.at(1))), q((c.at(2), c.at(3))), fill: fill, stroke: stroke) } }
  rect(q((x0, y0)), q((x1, y1)), fill: rgb("#f3efe6"), stroke: none)
  for x in range(9, 14) { line(q((x, y0)), q((x, y1)), stroke: 0.2pt + luma(222)); T((x, y0 + 0.12), str(x), size: 3.6pt, fill: gray) }
  for y in range(0, 9) { line(q((x0, y)), q((x1, y)), stroke: 0.2pt + luma(222)); T((x0 + 0.12, y), str(y), size: 3.6pt, fill: gray) }
  // the corner given up (hatched) and the deed setback line
  R((XS, 0, XE, YS), fill: hatch, stroke: none)
  for i in range(env-design.len() - 1) {   // the deed setback line, each segment clipped to the window (Liang–Barsky)
    let a = env-design.at(i); let b = env-design.at(i + 1); let (dx, dy) = (b.at(0) - a.at(0), b.at(1) - a.at(1))
    let (t0, t1) = (0.0, 1.0); let bad = false
    for (pp, qq) in ((-dx, a.at(0) - x0), (dx, x1 - a.at(0)), (-dy, a.at(1) - y0), (dy, y1 - a.at(1))) {
      if pp == 0 { if qq < 0 { bad = true } } else { let r = qq / pp; if pp < 0 { t0 = calc.max(t0, r) } else { t1 = calc.min(t1, r) } } }
    if not bad and t0 < t1 { line(q((a.at(0) + t0 * dx, a.at(1) + t0 * dy)), q((a.at(0) + t1 * dx, a.at(1) + t1 * dy)), stroke: (paint: accent, thickness: 0.8pt, dash: "dashed")) }
  }
  T((13.3, 1.7), [deed setback line], size: 3.6pt, fill: accent, angle: -62deg)
  // the neighbours (grey)
  if gf { R((x0, 0, XW, 6.5), fill: luma(236), stroke: 0.5pt + luma(170)); T((8.72, 3.5), [women's majlis], size: 4pt, fill: gray, angle: 90deg) }
  else { R((x0, 3.0, XW, 6.5), fill: luma(236), stroke: 0.5pt + luma(170)); T((8.72, 4.75), [family living], size: 4pt, fill: gray, angle: 90deg); R((x0, 0, XW, 3.0), fill: luma(236), stroke: 0.5pt + luma(170)); T((8.72, 1.5), [kids' room], size: 4pt, fill: gray, angle: 90deg) }
  let col(k) = if k == "wet" { rgb("#cfe6ef") } else if k == "maid" { rgb("#e4e9d6") } else if k == "laundry" { rgb("#dfe3e6") } else if k == "kitchen" { rgb("#d9e6ec") } else if k == "store" { rgb("#e6e1d6") } else if k == "bed" { rgb("#f6e3c0") } else if k == "circ" { rgb("#f2efe8") } else { luma(236) }
  for (n, b, k, l) in rooms { R(b, fill: col(k), stroke: if k.ends-with("g") { (paint: luma(170), thickness: 0.5pt) } else { 0.9pt + ink }) }
  // the outer walls of the step, thick; today's cut and today's walls dashed
  line(q((XW, 0)), q((XS, 0)), q((XS, YS)), q((XE, YS)), q((XE, 8.5)), stroke: 2.2pt + ink)
  line(q(cut-today.at(0)), q(cut-today.at(1)), stroke: (paint: red, thickness: 1.2pt, dash: "dashed")); T((12.2, 2.0), [today's cut wall], size: 3.8pt, fill: red, angle: -61deg)
  for (a, b) in today-walls { line(q(a), q(b), stroke: (paint: red, thickness: 0.5pt, dash: "dashed")) }
  for (fx0, fy0, fx1, fy1, l, rm) in furn.filter(f => f.at(1) < y1) { R((fx0, fy0, fx1, fy1), fill: rgb("#fbf6ea"), stroke: 0.45pt + rgb("#8a7a5a")); if fy1 <= y1 { T(((fx0 + fx1) / 2, (fy0 + fy1) / 2), l, size: 3.4pt, angle: if (fy1 - fy0) > (fx1 - fx0) * 1.4 { 90deg } else { 0deg }) } }
  for (a, b) in open-edges { line(q(a), q(b), stroke: 2pt + rgb("#f2efe8")) }
  for d in doors.filter(d => d.at(0).at(1) <= y1) { line(q(d.at(0)), q(d.at(1)), stroke: 2.6pt + red); if d.at(2) != (0, 0) { R(swing(d), stroke: (paint: red, thickness: 0.35pt, dash: "dashed")) } }
  for (a, b, l) in windows { line(q(a), q(b), stroke: (paint: blue, thickness: 2pt, dash: "dashed")) }
  // columns: today's (hollow red) and the step's (filled)
  for (x, y, id) in cols-today { rect(q((x - 0.13, y - 0.13)), q((x + 0.13, y + 0.13)), stroke: (paint: red, thickness: 0.6pt, dash: "dashed")) }
  for (x, y, id, note) in cols-step { rect(q((x - 0.125, y - 0.125)), q((x + 0.125, y + 0.125)), fill: ink, stroke: none); T((x + 0.2, y - 0.2), id, size: 3.8pt, fill: ink, anchor: "west") }
  // labels: name, clear w × d, m²
  for (n, b, k, l) in rooms {
    let c = clear-box(b, light: l); let mid = ((b.at(0) + b.at(2)) / 2, (b.at(1) + b.at(3)) / 2)
    let at = if n == "Maid room" { (11.9, 6.1) } else if n == "Bedroom 1" { (12.4, 6.9) } else if n == "Laundry" { (11.2, 7.0) } else if n == "Kitchen (north part)" { (11.1, 8.42) } else if n == "Outdoor store" { (9.75, 1.0) } else if n == "Maid bath" { (9.75, 3.15) } else if n == "Bedroom 1 bath (F20)" { (9.75, 2.0) } else if n == "Family link" { (9.55, 4.8) } else if n == "Suite lobby" { (9.6, 7.5) } else { (11.7, 8.35) }
    if k.ends-with("g") { T(at, [#n], size: 3.8pt, fill: gray) } else { T(at, [*#n*\ #r2(cw(c)) × #r2(cd(c)) · #r2(carea(c)) m²], size: if n.contains("Kitchen") { 3.6pt } else { 4.2pt }) }
  }
  // the margins at the two critical corners
  T((XS + 0.3, -0.25), [north corner: deed #r2(deed-dist(S((XS + 0.125, -0.125)))) · built #r2(lane-dist(S((XS + 0.125, -0.125))) - built-offset - setback-built)], size: 3.4pt, fill: accent, anchor: "west")
  T((13.2, 3.55), [east corner: deed #r2(deed-dist(S((XE + 0.125, YS - 0.125)))) · built #r2(lane-dist(S((XE + 0.125, YS - 0.125))) - built-offset - setback-built)], size: 3.4pt, fill: accent, anchor: "east")
  T((XS - 0.1, YS / 2), [step face x #r2(XS)], size: 3.6pt, fill: ink, angle: 90deg, anchor: "center")
  T((XS + (XE - XS) / 2, YS + 0.15), [step face y #r2(YS)], size: 3.6pt, fill: ink)
  T((x0 + 0.15, y0 + 0.4), title, size: 6pt, fill: accent, anchor: "west")
  line(q((x0 + 0.2, 8.3)), q((x0 + 1.2, 8.3)), stroke: 1pt + ink); T((x0 + 0.7, 8.15), [1 m], size: 3.6pt)
})
#grid(columns: (auto, auto, 1fr), column-gutter: 8pt,
  plan(gf-rooms, gf-furn, gf-doors, gf-windows, today-walls-gf, [GROUND FLOOR · the maid's wing and the laundry], gf: true),
  plan(ff-rooms, ff-furn, ff-doors, ff-windows, today-walls-ff, [FIRST FLOOR · bedroom 1, its bath, the link, the suite], gf: false),
  [
    #set text(6.6pt)
    *The step.* The north wall ends at x #r2(XS), the east wall starts at y #r2(YS): orthogonal walls only, every room a clean rectangle; the hatched corner (#r2(XE - XS) × #r2(YS) = #r2(lost-step) m² per floor) is given up against the slant's #r2(lost-today) m²: *#r2(lost-step - lost-today) m² more lost per floor.*

    *Why here.* Both readings of the setback must stay at least as good as today's (deed #r2(today.deed) m at the lane notch; wall as built #r2(today.built) m). The north corner is limited by the wall-as-built reading: x ≤ 10.59, so the maid partition line x 10.65 fails by 5 cm and the step face sits 0.10 m west of it; the east corner is limited by the notch: y ≥ 4.16. The step keeps C30 within 9 cm; no existing line fits y 4.2 (the laundry's wall y 4.7 would cost 1.4 m² more per floor and leave the band 1.8 m deep, too shallow for a room).

    *Ground floor.* The strip x 8.95–#r2(XS) (#r2(cw(clear-of(gf-rooms.at(1)))) m clear) takes the maid bath (its door from her room) and, in the north, an outdoor store opened from the parking strip; the maid room takes the whole band y #r2(YS)–6.5 (#r2(carea(clear-of(room-of(gf-rooms, "Maid room")))) m² clear, ≥ 7.28: the bed on the laundry wall, the wardrobe, the desk at the east escape casement); the laundry moves into the kitchen's north band (y 6.5–8.3, 1.8 m deep as today, the machines on the kitchen wall, the table on the majlis wall; the maid's route kitchen → laundry → her room → her bath kept); *the kitchen loses 1.8 m* (4.7 m deep, #r2(carea(clear-of(room-of(gf-rooms, "Kitchen (north part)")))) m² clear): its sink window, the service door and the counters shift south, and the courtyard's water trough in front of the sink window with them.

    *First floor.* Bedroom 1 a clean rectangle x 10.15–13.311 × y #r2(YS)–8.0 (#r2(carea(clear-of(room-of(ff-rooms, "Bedroom 1")))) m² clear; the bed's head on the step's north wall, the desk, the 1.8 m wardrobe, its door from the link at a right angle to the suite door); its bath F20 moves to the strip (#r2(carea(clear-of(room-of(ff-rooms, "Bedroom 1 bath (F20)")))) m² clear, the shower north, the WC over the maid bath) and is entered *from the link*, no longer en-suite (the link is 2.2 m long now); *the suite's WC closet goes back into the suite bath* (screened, as option K1): bedroom 1 covers its place.

    *Structure.* Three corner columns replace the three on the cut (C30 moved 0.09 m, C31 from the cut's middle to the re-entrant corner, C32 1.05 m north) and one new column C33′ at (13.311, 6.5) keeps the east wall's spans at 2.3 + 3.95 m; the RC cut wall W4 becomes two orthogonal RC walls (#r2(YS) + #r2(XE - XS) m); the step's two lines take beams at each slab; the maid wing's and the laundry's walls are light partitions on the slab; nothing else moves.

    #text(6.2pt, fill: gray)[Quick checks: #if all-ok [passed (6): furniture inside the clear rooms, no overlaps; the door swings clear; both margins ≥ today's; the maid room ≥ 7.28 m² clear; the rooms tile the corner.] else [FAILED: #ok.enumerate().filter(((i, v)) => not v).map(((i, v)) => str(i + 1)).join(", ")]]
  ],
)

// ======================= PAGE 2 · the table =======================
#pagebreak()
#text(12.5pt, weight: "bold", fill: accent)[Today's slant vs the step (#r2(XS), #r2(YS)) · the corner rooms, the areas, the structure, the margins] #h(1fr) #text(6.6pt, fill: gray)[m² on axes · *clear* inside the walls as drawn (0.125 on the outer walls, 0.10 on the inner walls, 0.05 on partitions) · today = the schedule of 17 Nov 2026]
#v(1pt) #line(length: 100%, stroke: 0.6pt + accent)
#v(3pt)
#let row(n, b, k, l, t) = { let c = clear-box(b, light: l); ([#n], [#t.at(3) · *#r2(t.at(1))* · #r2(t.at(2)) clear], [#r2(b.at(2) - b.at(0)) × #r2(b.at(3) - b.at(1)) · *#r2((b.at(2) - b.at(0)) * (b.at(3) - b.at(1)))* · #r2(carea(c)) clear (#r2(cw(c)) × #r2(cd(c)))], [#r2(carea(c) - t.at(2))]) }
#table(columns: (1.3fr, 1.6fr, 2.0fr, 0.6fr), stroke: 0.3pt + luma(190), inset: 3.2pt, align: (left, left, left, right), fill: (_, y) => if y == 0 { rgb("#e1e9e3") } else if calc.even(y) { rgb("#efece4") },
  table.header([], [*Today (the slant)*], [*The step: x #r2(XS), y #r2(YS)*], [*Δ clear*]),
  table.cell(colspan: 4, fill: rgb("#dfe8e1"))[*Ground floor*],
  ..row([Maid room], room-of(gf-rooms, "Maid room").at(1), "maid", (), today-gf.at(0)),
  ..row([Maid bath], room-of(gf-rooms, "Maid bath").at(1), "wet", ("n",), today-gf.at(1)),
  ..row([Laundry (moved to y 6.5–8.3)], room-of(gf-rooms, "Laundry").at(1), "laundry", ("s",), today-gf.at(2)),
  ..row([Kitchen (y 8.3–13.0)], room-of(gf-rooms, "Kitchen (north part)").at(1), "kitchen", ("n",), today-gf.at(3)),
  [Outdoor store (new, from the parking strip)], [—], [#r2(XS - XW) × 2.30 · *#r2((XS - XW) * 2.3)* · #r2(carea(clear-of(gf-rooms.at(0)))) clear], [+#r2(carea(clear-of(gf-rooms.at(0))))],
  [GF: the corner given up (axes)], [the triangle *#r2(lost-today)*], [the rectangle *#r2(lost-step)*], [−#r2(lost-step - lost-today)],
  table.cell(colspan: 4, fill: rgb("#dfe8e1"))[*First floor*],
  ..row([Bedroom 1], room-of(ff-rooms, "Bedroom 1").at(1), "bed", (), today-ff.at(0)),
  ..row([Bedroom 1 bath F20 (to the strip, from the link)], room-of(ff-rooms, "Bedroom 1 bath (F20)").at(1), "wet", (), today-ff.at(1)),
  ..row([Family link], room-of(ff-rooms, "Family link").at(1), "circ", (), today-ff.at(2)),
  [Suite WC (closet)], [1.2 × 1.5 · *1.80* · 1.30 clear], [gone: the WC back inside the suite bath (screened); its place is bedroom 1's], [−1.30],
  [Suite bath], [3.01 × 2.45 · *7.38* · 6.27 clear], [unchanged, with the WC inside], [0],
  [FF: the corner given up (axes)], [the triangle *#r2(lost-today)*], [the rectangle *#r2(lost-step)*], [−#r2(lost-step - lost-today)],
  table.cell(colspan: 4, fill: rgb("#dfe8e1"))[*Structure and the site*],
  [Columns at the corner], [C30 (10.461, 0) · C31 (11.982, 2.8) · C32 (13.311, 5.245); the RC cut wall W4 (6.0 m)], [C30′ (#r2(XS), 0) · C31′ (#r2(XS), #r2(YS)) · C32′ (13.311, #r2(YS)) · *C33′ new* (13.311, 6.5); two orthogonal RC walls #r2(YS) + #r2(XE - XS) m; beams on the step's lines at each slab], [—],
  [Spans], [north wall 8.95–10.461 (1.5); the cut 3.2 + 3.6; the east wall 5.245–10.45 (5.2)], [north wall 8.95–#r2(XS) (#r2(XS - XW)); the step's two walls #r2(YS) and #r2(XE - XS); the east wall #r2(YS)–6.5–10.45 (#r2(6.5 - YS) + 3.95)], [—],
  [Light partitions on the slab], [the maid bath's (y 3.2, x 10.65), the laundry's y 4.7], [the store / bath y 2.3, the bath / room y #r2(YS) is the step (outer), the room / laundry y 6.5 (under B6), the laundry / kitchen y 8.3], [—],
  [Tightest margin · deed setback line], [*#r2(today.deed)* m at (#r2(today.deed-at.at(0)), #r2(today.deed-at.at(1))) on the cut, the lane notch], [*#r2(step.deed)* m at (#r2(step.deed-at.at(0)), #r2(step.deed-at.at(1)))], [+#r2(step.deed - today.deed)],
  [Tightest margin · 2.0 m from the wall as built], [*#r2(today.built)* m at (#r2(today.built-at.at(0)), #r2(today.built-at.at(1))) (the field's 0.42 at the 2.30 reading)], [*#r2(step.built)* m at (#r2(step.built-at.at(0)), #r2(step.built-at.at(1))), the north corner], [+#r2(step.built - today.built)],
)
#v(4pt)
#text(7pt)[*In one line:* the step is buildable with both margins kept, but it costs #r2(lost-step - lost-today) m² per floor more than the slant and re-plans the whole corner: the kitchen 1.8 m shorter, bedroom 1 #r2(today-ff.at(0).at(2) - carea(clear-of(room-of(ff-rooms, "Bedroom 1")))) m² smaller and without its en-suite, the suite's WC closet gone; the maid's wing and the laundry come out clean and the maid room keeps its size.]
#v(3pt)
#ah[#text(8pt)[درجة واحدة بدل الجدار المائل في الموضع الحالي: ممكنة مع الحفاظ على هامشي الارتداد (الصك والجدار المبني)، لكنها تُفقد نحو #r2(lost-step - lost-today) م² في كل دور زيادة على القطع المائل وتعيد تخطيط الركن كله: المطبخ أقصر بـ1.8 م، وغرفة النوم 1 أصغر بـ#r2(today-ff.at(0).at(2) - carea(clear-of(room-of(ff-rooms, "Bedroom 1")))) م² وبلا حمام ملحق (حمامها من الوصلة)، وغرفة مرحاض الجناح تعود داخل الحمام؛ أما جناح الخادمة والغسيل فيخرجان مستقيمين وغرفة الخادمة تحتفظ بمساحتها (#r2(carea(clear-of(room-of(gf-rooms, "Maid room")))) م²). الأعمدة الثلاثة على الركن بدل أعمدة القطع وعمود جديد على الجدار الشرقي عند y 6.5.]]

// base.typ · Taif / Palm House · site, outline, helpers, checks, rendering
// Changes only if the land changes. Compile design.typ, not this file.
// Shows the site and the buildable envelope only; the design draws everything inside it.
#import "@preview/cetz:0.4.2"

#let setup(body) = {
  set page(paper: "a4", flipped: true, margin: 9mm, fill: rgb("#fbfaf6"))
  set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 8pt)
  set par(leading: 0.4em)
  body
}

// ---------- Colours ----------
#let ink     = rgb("#3d4a45")
#let accent  = rgb("#2f6b4f")
#let envc    = rgb("#e3f0dd")
#let setb    = rgb("#f4c6c6")
#let drive   = rgb("#d6e2ee")
#let navy    = rgb("#2f5f8a")
#let brown   = rgb("#8a5a2b")
#let warn    = rgb("#b5452f")
#let grid-c  = rgb("#d9dcd6")
#let courtc  = rgb("#cfe6ef")
#let airc    = rgb("#f3dfb8")
#let palette = (
  family:  rgb("#f6e3c0"),
  guest:   rgb("#e9d9c4"),
  service: rgb("#d9e6ec"),
  circ:    rgb("#f2efe8"),
  core:    rgb("#cfd3d0"),
  tower:   rgb("#8ccbe0"),
)

// ---------- Site geometry (design frame, metres) ----------
// Origin = peg M1 (gate east post G′) · y along the M line, southwards · x square to it, east positive
#let q(x, y) = (x, -y)
#let land  = ((0.0, 0.0), (8.64, -1.59), (11.96, 0.17), (15.39, 6.51), (15.68, 7.37), (16.75, 7.83), (20.19, 13.91), (23.02, 20.37), (26.74, 33.94), (0.0, 38.86))
#let env   = ((0.0, 38.86), (0.0, 3.05), (9.18, 1.36), (9.67, 1.22), (10.48, 1.65), (13.55, 7.3), (14.06, 8.86), (15.35, 9.4), (18.4, 14.8), (21.13, 21.04), (24.77, 34.3))
#let drv   = ((-3.95, 0.73), (0, 0), (0, 38.86), (-3.95, 39.59))
#let lane  = ((8.64, -1.59), (11.96, 0.17), (15.39, 6.51), (15.68, 7.37), (16.75, 7.83), (20.19, 13.91), (23.02, 20.37), (27.07, 35.15))
#let nwall = ((-6.5, 1.2), (8.64, -1.59))
#let south = ((0, 38.86), (26.75, 33.93))
#let T1 = (20.6, 28.09)
#let T2 = (21.39, 31.87)
#let Ms = ((0, 0), (0, 6.36), (0, 18.52), (0, 28.8))
#let north = (0.365, 0.931)   // true north on the drawing (canvas coordinates)
#let spare = 0.5              // required spare to the north and lane setback lines

// Ground-floor outline: west on the M line, north and lane walls 0.5 m inside the setbacks, south at y = 26.80
#let outline = ((0.0, 3.57), (9.3, 1.86), (9.61, 1.77), (10.11, 2.03), (13.08, 7.5), (13.65, 9.24), (14.99, 9.8), (17.94, 15.03), (20.65, 21.21), (22.18, 26.8), (0.0, 26.8))

// ---------- Geometry helpers ----------
#let area(pts) = {
  let s = 0.0
  for i in range(pts.len()) {
    let a = pts.at(i)
    let b = pts.at(calc.rem(i + 1, pts.len()))
    s += a.at(0) * b.at(1) - b.at(0) * a.at(1)
  }
  calc.abs(s) / 2
}
#let dist(a, b) = calc.sqrt(calc.pow(a.at(0) - b.at(0), 2) + calc.pow(a.at(1) - b.at(1), 2))
#let closest(p, a, b) = {
  let dx = b.at(0) - a.at(0)
  let dy = b.at(1) - a.at(1)
  let t = calc.clamp(((p.at(0) - a.at(0)) * dx + (p.at(1) - a.at(1)) * dy) / (dx * dx + dy * dy), 0, 1)
  (a.at(0) + t * dx, a.at(1) + t * dy)
}
#let seg-dist(p, a, b) = dist(p, closest(p, a, b))
#let edges(pts) = range(pts.len()).map(i => (pts.at(i), pts.at(calc.rem(i + 1, pts.len()))))
#let boundary-dist(p, pts) = calc.min(..edges(pts).map(e => seg-dist(p, ..e)))
#let ray(p, pts) = {
  let yes = false
  for (a, b) in edges(pts) {
    if (a.at(1) > p.at(1)) != (b.at(1) > p.at(1)) {
      if p.at(0) < (b.at(0) - a.at(0)) * (p.at(1) - a.at(1)) / (b.at(1) - a.at(1)) + a.at(0) { yes = not yes }
    }
  }
  yes
}
#let inside(p, pts) = ray(p, pts) or boundary-dist(p, pts) < 0.00001          // boundary counts as inside
#let strict-inside(p, pts) = ray(p, pts) and boundary-dist(p, pts) > 0.01     // shared walls allowed
#let centroid(pts) = {
  let a = 0.0
  let cx = 0.0
  let cy = 0.0
  for (p, r) in edges(pts) {
    let c = p.at(0) * r.at(1) - r.at(0) * p.at(1)
    a += c
    cx += (p.at(0) + r.at(0)) * c
    cy += (p.at(1) + r.at(1)) * c
  }
  (cx / (3 * a), cy / (3 * a))
}
#let sample(pts, step: 0.05) = edges(pts).map(e => {
  let steps = calc.max(1, int(calc.ceil(dist(..e) / step)))
  range(steps + 1).map(i => (
    e.at(0).at(0) + (e.at(1).at(0) - e.at(0).at(0)) * i / steps,
    e.at(0).at(1) + (e.at(1).at(1) - e.at(0).at(1)) * i / steps))
}).fold((), (acc, ps) => acc + ps)
#let addv(p, s, d) = (p.at(0) + s * d.at(0), p.at(1) + s * d.at(1))
#let num(n) = str(calc.round(n, digits: 2))
#let east-x(y) = calc.max(..edges(outline).filter(e => (e.at(0).at(1) - y) * (e.at(1).at(1) - y) <= 0 and e.at(0).at(1) != e.at(1).at(1)).map(e => e.at(0).at(0) + (y - e.at(0).at(1)) * (e.at(1).at(0) - e.at(0).at(0)) / (e.at(1).at(1) - e.at(0).at(1))))

// ---------- Outline checks (stop compiling if the base is wrong) ----------
#let checked = sample(outline)
#assert(checked.all(p => inside(p, env)), message: "ERROR: outline crosses the envelope.")
#let lane-env  = env.slice(2)
#let north-gap = calc.min(..checked.map(p => seg-dist(p, env.at(1), env.at(2))))
#let lane-gap  = calc.min(..checked.map(p => calc.min(..range(lane-env.len() - 1).map(i => seg-dist(p, lane-env.at(i), lane-env.at(i + 1))))))
#let south-gap = calc.min(..checked.map(p => seg-dist(p, env.last(), env.first())))
#assert(north-gap >= spare - 0.001 and lane-gap >= spare - 0.001, message: "ERROR: less than the required spare to the north or lane setback line.")
#let env-area     = area(env)
#let outline-area = area(outline)
#let free-area    = env-area - outline-area
#let palm-gap(T) = calc.min(..edges(outline).map(e => seg-dist(T, ..e))) - 0.265

// ---------- True compass in the design frame (y points south, so rotations flip) ----------
#let tn = (north.at(0), -north.at(1))   // true north
#let te = (-tn.at(1), tn.at(0))          // true east
#let r2 = calc.sqrt(2)
#let nwf = ((tn.at(0) - te.at(0)) / r2, (tn.at(1) - te.at(1)) / r2)   // towards NW (wind comes from here)
#let wind = (-nwf.at(0), -nwf.at(1))
#let rot      = calc.atan(tn.at(0) / -tn.at(1))              // true compass vs the M line
#let wind-off = calc.atan(calc.abs(nwf.at(0) / nwf.at(1)))   // NW wind vs the M line

// ---------- Rooms from CSV ----------
// frame "M": w across the M line (x), d along it (y) · frame "N": w true E–W, d true N–S · angle in degrees
// optional "pts" column: corner points "x y; x y; …" for a room that is not a rectangle (then x, y, w, d are for reference only)
#let pts-of(r) = r.at("pts", default: "").split(";").map(s => s.trim()).filter(s => s != "").map(s => {
  let v = s.split(" ").filter(t => t != "")
  (float(v.at(0)), float(v.at(1)))
})
#let room-poly(r) = {
  let P = pts-of(r)
  if P.len() >= 3 { return P }
  let x = float(r.x)
  let y = float(r.y)
  let w = float(r.w)
  let d = float(r.d)
  let t = float(r.at("angle", default: "0")) * 1deg
  let (u0, v0) = if r.at("frame", default: "M") == "N" { (te, (-tn.at(0), -tn.at(1))) } else { ((1.0, 0.0), (0.0, 1.0)) }
  let u = (u0.at(0) * calc.cos(t) + v0.at(0) * calc.sin(t), u0.at(1) * calc.cos(t) + v0.at(1) * calc.sin(t))
  let v = (-u0.at(0) * calc.sin(t) + v0.at(0) * calc.cos(t), -u0.at(1) * calc.sin(t) + v0.at(1) * calc.cos(t))
  ((-w / 2, -d / 2), (w / 2, -d / 2), (w / 2, d / 2), (-w / 2, d / 2)).map(((a, b)) => (x + a * u.at(0) + b * v.at(0), y + a * u.at(1) + b * v.at(1)))
}

// warnings: anything outside the building limit, or overlapping anything else
#let check(items, limit: env) = {
  let w = ()
  for (n, P) in items {
    if not sample(P, step: 0.25).all(p => inside(p, limit)) { w.push(n + " leaves the building limit") }
  }
  for i in range(items.len()) {
    for j in range(i + 1, items.len()) {
      let (na, A) = items.at(i)
      let (nb, B) = items.at(j)
      if sample(A, step: 0.25).any(p => strict-inside(p, B)) or sample(B, step: 0.25).any(p => strict-inside(p, A)) {
        w.push(na + " overlaps " + nb)
      }
    }
  }
  w
}

// ---------- Drawing helpers ----------
#let poly(pts, ..args) = cetz.draw.line(..pts.map(p => q(..p)), close: true, ..args)
#let lab(p, body, size: 6pt, fill: ink, anchor: "center", angle: 0deg) = cetz.draw.content(q(..p), anchor: anchor, angle: angle, text(size, fill: fill, body))
#let metric(a, b) = ([#a], [*#b*])

// ---------- Render: plan + panel + schedules ----------
// limit: the area rooms must stay inside (default: the buildable envelope) · extras: open voids as (name, polygon)
// air: air channels / ducts as (name, polygon), blue, checked against the envelope only
// marks: highlighted openings as ((a, b), label) · arrows: entries as (from, to, label)
#let render(title: [], subtitle: [], court: (), opening: none, opening-label: [NW wind → malqaf head (roof)], shaft: (), rooms: (), extras: (), air: (), marks: (), arrows: (), limit: env, note: []) = {
  let items  = rooms.map(r => (r.name, room-poly(r)))
  let solids = (("Courtyard", court), ("Malqaf shaft", shaft)).filter(s => s.at(1).len() > 0) + extras + items
  let warnings   = check(solids, limit: limit)
  let limit-area = area(limit)
  let extras-area = extras.map(e => area(e.at(1))).sum(default: 0)
  let court-area = if court.len() > 0 { area(court) } else { 0 }
  let rooms-area = items.map(it => area(it.at(1))).sum(default: 0)
  let air-area = air.map(a => area(a.at(1))).sum(default: 0)
  let warnings = warnings + air.filter(a => not sample(a.at(1), step: 0.25).all(p => inside(p, env))).map(a => a.at(0) + " leaves the envelope")

  let plan = cetz.canvas(length: 0.39cm, {
    import cetz.draw: *
    for x in range(-5, 29) { line(q(x, -2), q(x, 40), stroke: (paint: grid-c, thickness: 0.2pt)) }
    for y in range(-2, 41) { line(q(-5, y), q(28, y), stroke: (paint: grid-c, thickness: 0.2pt)) }
    poly(land, fill: setb, stroke: none)
    poly(env, fill: envc, stroke: 1pt + accent)
    poly(drv, fill: drive, stroke: 0.6pt + navy)
    line(..lane.map(p => q(..p)), stroke: 1.2pt + ink)
    line(..nwall.map(p => q(..p)), stroke: 1.2pt + ink)
    line(..south.map(p => q(..p)), stroke: (paint: accent, dash: "dashed", thickness: 1pt))
    if limit != env { poly(limit, fill: white.transparentize(35%), stroke: 1.4pt + brown) }
    for (n, P) in extras {
      poly(P, fill: white, stroke: 0.6pt + ink)
      lab(centroid(P), [#n], size: 5pt)
    }

    if shaft.len() > 0 {
      poly(shaft, fill: airc, stroke: 0.8pt + brown)
      lab(centroid(shaft), [Malqaf], size: 5pt, fill: brown)
    }
    if court.len() > 0 {
      poly(court, fill: courtc, stroke: 1pt + navy)
      lab(centroid(court), [*COURTYARD*\ #num(court-area) m²], size: 6.5pt, fill: navy)
    }
    for (r, it) in rooms.zip(items) {
      let P = it.at(1)
      poly(P, fill: palette.at(r.at("colour", default: ""), default: luma(225)), stroke: 0.6pt + ink)
      lab(centroid(P), [#r.name\ #num(area(P)) m²], size: 5.5pt)
    }
    if opening != none {
      line(q(..opening.at(0)), q(..opening.at(1)), stroke: (paint: warn, thickness: 1.6pt, dash: "dashed"))
      let m = ((opening.at(0).at(0) + opening.at(1).at(0)) / 2, (opening.at(0).at(1) + opening.at(1).at(1)) / 2)
      let a = addv(m, 5.5, nwf)
      line(q(..a), q(..addv(m, 1.5, nwf)), stroke: 1.4pt + warn, mark: (end: "stealth", fill: warn, scale: 0.6))
      lab((a.at(0) + 0.4, a.at(1) - 0.2), opening-label, size: 5.5pt, fill: warn, anchor: "west")
    }
    for (n, P) in air {
      poly(P, fill: rgb("#cfe8f0"), stroke: 0.8pt + rgb("#1f7a99"))
    }
    for ((a, b), l) in marks {
      line(q(..a), q(..b), stroke: 2.4pt + rgb("#1f7a99"))
      lab((b.at(0) + 0.5, b.at(1) + 0.6), l, size: 5.2pt, fill: rgb("#1f7a99"), anchor: "west")
    }
    for (a, b, l) in arrows {
      line(q(..a), q(..b), stroke: 0.9pt + brown, mark: (end: "stealth", fill: brown, scale: 0.5))
      lab(a, l, size: 5.2pt, fill: brown, anchor: "south")
    }

    let w0 = (16.5, -1.6)
    line(q(..w0), q(..addv(w0, 3.5, wind)), stroke: 1.4pt + warn, mark: (end: "stealth", fill: warn, scale: 0.6))
    lab((w0.at(0) + 0.5, w0.at(1) - 0.6), [Prevailing wind NW], size: 5.5pt, fill: warn, anchor: "west")
    for (T, n) in ((T1, [Palm 1]), (T2, [Palm 2])) {
      circle(q(..T), radius: 0.265, fill: accent, stroke: none)
      circle(q(..T), radius: 1, stroke: (paint: accent, thickness: 0.5pt, dash: "dotted"))
      lab((T.at(0) + 1.3, T.at(1)), n, fill: accent, anchor: "west")
    }
    for (p, n) in Ms.zip(([M1], [M2], [M3], [M4])) {
      circle(q(..p), radius: 0.18, fill: accent, stroke: none)
      lab((-0.6, p.at(1)), n, fill: accent, anchor: "east")
    }
    lab((-2.5, 9), [Driveway], size: 6pt, fill: navy, angle: 90deg)
    lab((4, -1.7), [North street], size: 6pt)
    for y in range(0, 41, step: 5) { lab((-4.7, y), str(y), size: 5pt, fill: gray) }
    for x in range(0, 26, step: 5) { lab((x, 40.5), str(x), size: 5pt, fill: gray) }
    line(q(24, 2), (24 + 2.2 * north.at(0), -2 + 2.2 * north.at(1)), stroke: 1pt + ink, mark: (end: "stealth", fill: ink, scale: 0.7))
    lab((25.2, -1), [*N*], size: 8pt)
    line(q(18, 42), q(28, 42), stroke: 1.5pt + ink)
    lab((23, 42.8), [10 m · drawing scale 1:256], size: 5.5pt)
  })

  grid(columns: (auto, 1fr), column-gutter: 13pt, plan, [
    #text(17pt, fill: accent, weight: "bold")[Taif / Palm House]\
    #text(11pt, weight: "bold")[#title]\
    #text(7pt, fill: gray)[#subtitle]
    #v(5pt)
    #line(length: 100%, stroke: 0.7pt + accent)
    #v(4pt)
    #note
    #v(6pt)
    #if warnings.len() == 0 {
      text(fill: accent, weight: "bold")[✓ All checks passed]
    } else {
      block(fill: rgb("#fbe3dd"), inset: 5pt, radius: 2pt, width: 100%)[
        #text(fill: warn, weight: "bold")[WARNING · #warnings.len() issue(s)]\
        #warnings.map(w => text(fill: warn)[• #w]).join(linebreak())
      ]
    }
    #v(6pt)
    #text(10pt, weight: "bold", fill: accent)[Areas]
    #table(columns: (1fr, auto), stroke: none, inset: 3.5pt, fill: (_, y) => if calc.even(y) { rgb("#efece4") },
      ..metric([Envelope], [#num(env-area) m²]),
      ..metric([Building limit (envelope unless set)], [#num(limit-area) m²]),
      ..metric([Other open voids], [#num(extras-area) m²]),
      ..metric([Courtyard (open to sky)], [#num(court-area) m²]),
      ..metric([Rooms placed (#rooms.len())], [#num(rooms-area) m²]),
      ..metric([Limit minus courtyard and voids], [#num(limit-area - court-area - extras-area) m²]),
      ..metric([Air channel + duct], [#num(air-area) m²]),
      ..metric([Not yet assigned], [#num(limit-area - court-area - extras-area - rooms-area) m²]),
    )
    #v(5pt)
    #text(10pt, weight: "bold", fill: accent)[Orientation]
    #table(columns: (1fr, auto), stroke: none, inset: 3pt,
      ..metric([True compass vs the M line], [#str(calc.round(rot.deg(), digits: 1))°]),
      ..metric([NW wind vs the M line], [#str(calc.round(wind-off.deg(), digits: 1))°]),
    )
    #v(4pt)
    #text(6.5pt, fill: gray)[Concept only. Wind: Global Wind Atlas (area data, 10 m), NW ≈ 15–20 %, SE ≈ 7–8 %. Confirm on site with a ribbon test.]
  ])

  pagebreak()
  text(17pt, fill: accent, weight: "bold")[Schedules]
  v(5pt)
  [All coordinates in metres from M1: x east (square to the M line), y along the M line southwards.]
  v(8pt)
  grid(columns: (1fr, 1.4fr), column-gutter: 16pt, [
    *Envelope corners*
    #v(4pt)
    #table(columns: (auto, auto, auto), inset: 4pt, stroke: 0.4pt + grid-c,
      table.header([Corner], [x], [y]),
      ..env.enumerate().map(((i, p)) => ([V#(i + 1)], [#num(p.at(0))], [#num(p.at(1))])).flatten())
  ], [
    *Rooms*
    #v(4pt)
    #if rooms.len() == 0 [_No rooms yet. Add rows to data/rooms.csv._] else {
      table(columns: (1fr, auto, auto, auto), inset: 4pt, stroke: 0.4pt + grid-c,
        table.header([Name], [Frame], [w × d (m)], [Area]),
        ..rooms.zip(items).map(((r, it)) => ([#r.name], [#r.at("frame", default: "M")], [#r.w × #r.d], [#num(area(it.at(1))) m²])).flatten())
    }
  ])
}

// presentation.typ · Taif / Palm House · V5.0 presentation set (ground floor + first floor) · compile THIS file
//   typst compile --root taif_house taif_house/presentation.typ taif_house/output/Taif_House_V5.0_presentation.pdf
// Reads the V5.0 data: data/rooms_gf.csv, data/rooms_ff.csv, the ground-floor studies (fixtures) and the first-floor studies
// (doors, windows, furniture). Walls are drawn with thickness from the room outlines (250 mm outer, 200 mm inner,
// 100 mm dry partitions, thin balustrades on the voids). Ground-floor doors and windows that no study fixes are indicative.
#import "@preview/cetz:0.4.2"
#import "base.typ": land, env, drv, lane, nwall, south, T1, T2, Ms, north, accent
#import "studies/ff_family.typ" as fam
#import "studies/ff_suite.typ" as suite
#import "studies/east_wing.typ" as ew
#import "studies/guest_wing.typ" as gw

// ================= sheet look =================
#let dark = rgb("#22352e")
#let paper = rgb("#f9f8f4")
#let soft = luma(120)
#let sheets-total = 8
#set page(paper: "a4", flipped: true, margin: (x: 12mm, top: 11mm, bottom: 14mm), fill: paper,
  footer: context {
    line(length: 100%, stroke: 0.4pt + luma(200))
    v(-4pt)
    grid(columns: (1fr, auto),
      text(6.5pt, fill: soft)[DESIGN DEVELOPMENT STUDY | NOT FOR CONSTRUCTION | All dimensions in metres unless stated | wall centre lines (axes) unless "clear"],
      text(7pt, weight: "bold", fill: accent)[#numbering("01", counter(page).get().first()) / #numbering("01", sheets-total)])
  })
#set text(font: ("Segoe UI", "Arial"), size: 8pt, fill: dark)

#let sheet-head(title, subtitle) = {
  grid(columns: (1fr, auto), text(9pt, weight: "bold", fill: accent)[TAIF / PALM HOUSE], text(7pt, fill: soft)[V5.0 / 20 OCT 2026])
  v(1pt)
  text(18pt, weight: "bold")[#title]
  linebreak()
  text(7.2pt, fill: soft)[#subtitle]
  v(-3pt)
  line(length: 100%, stroke: 0.4pt + luma(200))
  v(2pt)
}
// Arabic notes column (right to left)
#let ar(body) = block(width: 100%, {
  set text(lang: "ar", dir: rtl, font: ("Segoe UI", "Arial"), size: 8.3pt)
  set par(leading: 0.7em, justify: false, spacing: 0.9em)
  set align(right)
  body
})
#let ah(t) = block(above: 9pt, below: 3pt, text(10pt, weight: "bold", fill: accent, t))

// ================= geometry helpers (CSV frame: x east, y south, metres) =================
#let q(p) = (p.at(0), -p.at(1))
#let rect-pts(x0, y0, x1, y1) = ((x0, y0), (x1, y0), (x1, y1), (x0, y1))
#let dist(a, b) = calc.sqrt(calc.pow(b.at(0) - a.at(0), 2) + calc.pow(b.at(1) - a.at(1), 2))
#let on-seg(p, a, b) = calc.abs(dist(a, p) + dist(p, b) - dist(a, b)) < 1e-5
#let sarea(P) = range(P.len()).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, P.len())); a.at(0) * b.at(1) - b.at(0) * a.at(1) }).sum() / 2
#let area(P) = calc.abs(sarea(P))
#let pcentroid(P) = {
  let A = sarea(P); let n = P.len()
  let cx = range(n).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, n)); (a.at(0) + b.at(0)) * (a.at(0) * b.at(1) - b.at(0) * a.at(1)) }).sum()
  let cy = range(n).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, n)); (a.at(1) + b.at(1)) * (a.at(0) * b.at(1) - b.at(0) * a.at(1)) }).sum()
  (cx / (6 * A), cy / (6 * A))
}
#let bbox(P) = (calc.min(..P.map(p => p.at(0))), calc.min(..P.map(p => p.at(1))), calc.max(..P.map(p => p.at(0))), calc.max(..P.map(p => p.at(1))))
#let is-rect(P) = P.len() == 4 and calc.abs(P.at(0).at(1) - P.at(1).at(1)) < 1e-6 and calc.abs(P.at(1).at(0) - P.at(2).at(0)) < 1e-6
#let n2(v) = str(calc.round(v, digits: 2))
// offset a polygon edge by edge: ds.at(i) > 0 moves edge i (P[i] → P[i+1]) inwards, < 0 outwards
#let offset-poly(P, ds) = {
  let n = P.len(); let s = if sarea(P) > 0 { 1 } else { -1 }
  let L(i) = {
    let a = P.at(i); let b = P.at(calc.rem(i + 1, n))
    let dx = b.at(0) - a.at(0); let dy = b.at(1) - a.at(1); let l = calc.sqrt(dx * dx + dy * dy)
    let nx = -dy / l * s; let ny = dx / l * s
    ((a.at(0) + nx * ds.at(i), a.at(1) + ny * ds.at(i)), (dx, dy), (nx, ny))
  }
  let out = ()
  for i in range(n) {
    let j = calc.rem(i - 1 + n, n)
    let (p1, d1, n1) = L(j)
    let (p2, d2, n2) = L(i)
    let cr = d1.at(0) * d2.at(1) - d1.at(1) * d2.at(0)
    let v = P.at(i)
    if calc.abs(cr) < 1e-9 {
      out.push((v.at(0) + n1.at(0) * ds.at(j), v.at(1) + n1.at(1) * ds.at(j)))
      if calc.abs(ds.at(j) - ds.at(i)) > 1e-9 { out.push((v.at(0) + n2.at(0) * ds.at(i), v.at(1) + n2.at(1) * ds.at(i))) }
    } else {
      let w = (p2.at(0) - p1.at(0), p2.at(1) - p1.at(1))
      let t = (w.at(0) * d2.at(1) - w.at(1) * d2.at(0)) / cr
      out.push((p1.at(0) + d1.at(0) * t, p1.at(1) + d1.at(1) * t))
    }
  }
  out
}
#let parse-pts(s) = s.split(";").map(t => t.trim()).filter(t => t != "").map(t => { let v = t.split(" ").filter(u => u != ""); (float(v.at(0)), float(v.at(1))) })
#let poly-of(r) = if r.pts.trim() != "" { parse-pts(r.pts) } else {
  let x = float(r.x); let y = float(r.y); let w = float(r.w); let d = float(r.d)
  rect-pts(x - w / 2, y - d / 2, x + w / 2, y + d / 2)
}
#let outline-csv = ((0, 0), (10.051, 0), (13.311, 6.0), (13.311, 24.0), (0, 24.0))
#let outer-segs = range(5).map(i => (outline-csv.at(i), outline-csv.at(calc.rem(i + 1, 5))))
#let tower = ((8.95, 0), (10.051, 0), (10.594, 1.0), (8.95, 1.0))

// ================= colours by use =================
#let fills = (
  court: rgb("#dfe9d3"), family: rgb("#f1e3c8"), guest: rgb("#e6d3b6"), service: rgb("#dbe7ec"), wet: rgb("#d3e6ee"),
  core: rgb("#dfe0db"), circ: rgb("#f3efe6"), suite: rgb("#efdcc3"), gym: rgb("#d6e4f1"), office: rgb("#e2e8d2"),
  store: rgb("#e6e1d6"), void: rgb("#ffffff"), open: rgb("#e4eedb"), tower: rgb("#d4e9f1"),
)
#let kind-of(name, col) = {
  let n = lower(name)
  if col == "court" { "court" } else if col == "open" or col == "terrace" { "open" }
  else if n.contains("void") or n.contains("sky") { "void" }
  else if n.contains("bath") or n.contains("wc") or n.contains("basins") { "wet" }
  else if n.contains("office") { "office" } else if n.contains("linen") or n.contains("niche") or n.contains("cupboard") { "store" }
  else if col == "tower" { "gym" } else if n.contains("air tower") { "tower" }
  else if col == "guest" and n.starts-with("suite") { "suite" }
  else { col }
}

// ================= the two floors as data =================
#let gf-csv = csv("data/rooms_gf.csv", row-type: dictionary).filter(r => r.name != "" and not r.name.starts-with("#"))
#let ff-csv = csv("data/rooms_ff.csv", row-type: dictionary).filter(r => r.name != "" and not r.name.starts-with("#"))
#let short = (
  "Lift (future · shaft placeholder)": "Lift (future)", "Utility room (shaft inside)": "Utility · shaft", "Family lobby + riwaq": "Riwaq",
  "Living (normal height) · dining": "Dining", "Living (double height)": "Living (double height)", "Guest basins (trough · 3 taps)": "Basins (3)",
  "Serving passage (2 doors)": "Serving", "Family WC + basin": "Family WC", "Upper gallery (on the west projection)": "Gallery",
  "Kids' room (study + gaming)": "Kids' room", "Suite court (open to the sky)": "Suite court", "Wardrobe niche (bedroom 2)": "niche",
  "Suite WC (closet)": "WC", "Hospitality kitchen": "Hospitality kitchen",
)
#let mk(prefix, rows, extra) = {
  let out = ()
  let i = 0
  for r in rows { i += 1; out.push((id: prefix + (if i < 10 { "0" } else { "" }) + str(i), name: r.name, kind: kind-of(r.name, r.colour), P: poly-of(r))) }
  out + extra
}
#let gf-rooms = mk("G", gf-csv, ((id: "", name: "Air tower", kind: "tower", P: tower),))
#let ff-rooms = mk("F", ff-csv, (
  (id: "", name: "Stair", kind: "core", P: rect-pts(0, 2.2, 2.75, 7.9)),
  (id: "", name: "Lift shaft (future)", kind: "core", P: rect-pts(0, 0, 2.25, 2.2)),
  (id: "", name: "West shaft", kind: "core", P: rect-pts(0, 9.2, 1.5, 10.4)),
  (id: "", name: "Air tower", kind: "tower", P: tower),
  (id: "", name: "Courtyard (open to the sky)", kind: "void", P: rect-pts(5.6, 6.5, 8.95, 13.0)),
  (id: "", name: "Double-height living (void)", kind: "void", P: rect-pts(5.6, 13.0, 8.95, 19.25)),
))
// wall types along the room outlines: open (no wall), balustrade, light partition; everything else 200 mm, outline 250 mm
#let gf-walls = (
  open: (((8.95, 13.0), (8.95, 19.25)),),                              // living ↔ dining: one room, ceiling change only
  rail: (),
  light: (((10.65, 2.8), (10.65, 6.5)),),                             // 100 mm dry block, laundry / maid room
)
#let ff-walls = (
  open: (((2.75, 7.9), (2.75, 9.2)), ((0, 7.9), (2.75, 7.9)), ((4.25, 19.25), (5.6, 19.25)), ((8.95, 5.3), (8.95, 6.5)), ((5.6, 13.0), (8.95, 13.0))),
  rail: (((5.6, 6.5), (5.6, 19.25)), ((4.25, 6.5), (8.95, 6.5))),       // the projection's balustrade, the living's courtyard edge
  light: (((2.25, 0.7), (4.25, 0.7)),),                               // linen cupboard front
)
#let wall-t(a, b, spec) = {
  let hit(list) = list.any(s => on-seg(a, ..s) and on-seg(b, ..s))
  if hit(spec.open) { 0.0 } else if hit(outer-segs) { 0.25 } else if hit(spec.rail) { 0.06 } else if hit(spec.light) { 0.1 } else { 0.2 }
}
#let half-ts(P, spec) = range(P.len()).map(i => wall-t(P.at(i), P.at(calc.rem(i + 1, P.len())), spec) / 2)
#let clear-poly(r, spec) = offset-poly(r.P, half-ts(r.P, spec))

// ground-floor doors (the studies fix the wash block and the east block; the others are indicative)
#let G(a, b, into, kind) = (a: a, b: b, into: into, kind: kind)
#let gf-doors = (
  G((3.0, 0), (4.0, 0), (0, 1), "hinged"),               // family entry
  G((2.25, 0.9), (2.25, 1.9), (-1, 0), "open"),          // future lift
  G((2.75, 0.2), (2.75, 2.0), (-1, 0), "open"),          // entry cupboard
  G((4.25, 0.6), (4.25, 1.6), (1, 0), "hinged"),         // women's majlis (indicative)
  G((2.75, 2.4), (2.75, 6.8), (-1, 0), "open"),          // open stair
  G((2.75, 8.2), (2.75, 9.0), (-1, 0), "hinged"),        // utility room (indicative)
  G((4.25, 9.1), (4.25, 10.5), (1, 0), "sliding"),       // courtyard glass door (indicative)
  G((2.75, 10.6), (2.75, 12.7), (-1, 0), "open"),        // hospitality kitchen
  G((2.75, 13.0), (2.75, 14.3), (-1, 0), "open"),        // family basins
  G((1.6, 14.4), (2.4, 14.4), (0, 1), "hinged"),         // family WC
  G((2.75, 16.25), (2.75, 17.15), (-1, 0), "hinged"),    // serving door 1
  G((0.1, 17.5), (1.15, 17.5), (0, -1), "hinged"),       // serving door 2
  G((1.3, 19.25), (2.05, 19.25), (0, -1), "hinged"),     // guest WC
  G((1.25, 19.85), (1.25, 21.4), (1, 0), "open"),        // guest passage ↔ basins
  G((0.1, 21.4), (1.15, 21.4), (0, 1), "open"),          // guest passage ↔ foyer
  G((0, 21.5), (0, 22.9), (1, 0), "double"),             // guest entrance 1.40, two leaves
  G((2.75, 22.15), (2.75, 23.95), (1, 0), "open"),       // foyer → men's majlis 1.80
  G((4.25, 13.1), (4.25, 14.5), (1, 0), "open"),         // living entrance 1.40
  G((9.4, 13.0), (10.5, 13.0), (0, -1), "hinged"),       // kitchen ↔ dining
  G((9.7, 6.5), (10.55, 6.5), (0, -1), "open"),          // kitchen ↔ laundry
  G((10.65, 2.95), (10.65, 3.75), (1, 0), "hinged"),     // laundry ↔ maid room
  G((10.715, 2.8), (11.415, 2.8), (0, -1), "sliding"),   // maid room ↔ maid bath
)
#let gf-windows = (
  ((8.95, 9.1), (8.95, 11.1)), ((13.311, 8.7), (13.311, 10.1)), ((12.170, 3.9), (12.714, 4.9)), ((11.138, 2.0), (11.464, 2.6)),   // studied
  ((5.1, 6.5), (8.1, 6.5)), ((4.45, 13.0), (5.4, 13.0)), ((5.8, 13.0), (8.75, 13.0)), ((4.25, 6.8), (4.25, 8.9)), ((4.25, 10.7), (4.25, 12.7)),   // courtyard glass (indicative)
  ((5.4, 0), (7.8, 0)), ((3.6, 24), (6.2, 24)), ((7.2, 24), (9.8, 24)), ((10.8, 24), (12.6, 24)), ((13.311, 14.5), (13.311, 17.5)),          // outer (indicative)
)
#let gf-lowwalls = (((4.25, 14.5), (4.25, 19.25)),)                 // living: 1.20 m low partition to the riwaq
#let gf-furniture = (
  ew.fixtures.map(((a, b, c, d, l)) => (a + 8.95, b, c + 8.95, d, l))
  + gw.fixtures.map(((a, b, c, d, l)) => (a, b + 10.4, c, d + 10.4, l))
  + (
    (5.2, 0.12, 8.1, 0.8, [majlis seating]), (8.15, 0.6, 8.85, 6.0, [majlis seating]), (5.9, 2.4, 7.3, 3.6, [table]),                 // women's majlis
    (3.3, 23.2, 12.9, 23.88, [majlis seating]), (3.6, 19.37, 12.9, 20.05, [majlis seating]), (6.0, 21.15, 10.0, 22.0, [table]),       // men's majlis
    (4.45, 15.0, 5.25, 18.0, [sofa]), (5.9, 15.6, 6.9, 17.2, [table]), (7.6, 15.1, 8.4, 15.8, [chair]), (7.6, 17.0, 8.4, 17.7, [chair]),   // living
    (10.4, 15.1, 12.0, 17.1, [dining table]), (9.85, 15.35, 10.3, 15.8, []), (9.85, 16.4, 10.3, 16.85, []), (12.1, 15.35, 12.55, 15.8, []), (12.1, 16.4, 12.55, 16.85, []),
  )
)
#let gf-columns = ((5.6, 6.5), (5.6, 13.0), (5.6, 19.25))
#let ff-doors = (fam.doors + suite.doors).map(d => (a: d.a, b: d.b, into: d.into,
  kind: if not d.open { "hinged" } else if lower(repr(d.label)).contains("sliding") { "sliding" } else { "open" }))
#let ff-windows = fam.windows + suite.windows
#let ff-furniture = fam.furniture + suite.furniture

// ================= drawing =================
#let floor-c = rgb("#f7f2e8")
#let furn-fill = rgb("#fbf4e6")
#let furn-line = rgb("#b48a5a")
#let fix-line = rgb("#5f8fa3")
// a door / opening / window cut across the wall line a–b
#let cut(a, b, half: 0.14) = {
  let l = dist(a, b); let u = ((b.at(0) - a.at(0)) / l, (b.at(1) - a.at(1)) / l); let n = (-u.at(1), u.at(0))
  ((a.at(0) + n.at(0) * half, a.at(1) + n.at(1) * half), (b.at(0) + n.at(0) * half, b.at(1) + n.at(1) * half),
   (b.at(0) - n.at(0) * half, b.at(1) - n.at(1) * half), (a.at(0) - n.at(0) * half, a.at(1) - n.at(1) * half))
}
#let lbl-of(l) = lower(repr(l))
#let draw-floor(rooms, spec, doors, windows, furniture, lowwalls: (), columns: (), beam: none, focus: none, labels: true, label-at: (:), shift: (0, 0), mini: false) = {
  import cetz.draw: *
  let S(p) = q((p.at(0) + shift.at(0), p.at(1) + shift.at(1)))
  let poly(P, ..args) = line(..P.map(S), close: true, ..args)
  let infocus(r) = focus == none or focus.contains(r.name)
  // walls: every room pushed out by half its wall thickness, in wall colour; then the rooms pulled in, in their colour
  for r in rooms { poly(offset-poly(r.P, half-ts(r.P, spec).map(d => -d)), fill: if infocus(r) { dark } else { luma(150) }, stroke: none) }
  for r in rooms {
    let c = fills.at(r.kind, default: luma(235))
    poly(clear-poly(r, spec), fill: if infocus(r) { c } else { c.mix((luma(235), 70%)) }, stroke: none)
    if r.kind == "void" and not mini {
      let (x0, y0, x1, y1) = bbox(clear-poly(r, spec))
      let k = 0.0
      while k < (x1 - x0) + (y1 - y0) {
        let p0 = (calc.min(x0 + k, x1), y0 + calc.max(0, k - (x1 - x0)))
        let p1 = (x0 + calc.max(0, k - (y1 - y0)), calc.min(y0 + k, y1))
        line(S(p0), S(p1), stroke: 0.25pt + rgb("#b9cfd8"))
        k += 0.6
      }
    }
  }
  for (a, b) in lowwalls { poly(cut(a, b, half: 0.1), fill: rgb("#c8a77e"), stroke: none) }
  if mini { return }
  // furniture and fixtures
  for (x0, y0, x1, y1, l) in furniture {
    let t = lbl-of(l)
    let wet = t.contains("wc") or t.contains("basin") or t.contains("shower") or t.contains("tub") or t.contains("vanity") or t.contains("trough") or t.contains("sink") or t.contains("washer") or t.contains("dryer")
    let st = 0.45pt + (if wet { fix-line } else { furn-line })
    rect(S((x0, y0)), S((x1, y1)), fill: if wet { white } else { furn-fill }, stroke: st)
    let w = x1 - x0; let h = y1 - y0; let cx = (x0 + x1) / 2; let cy = (y0 + y1) / 2
    if t.contains("wc") {
      let r = calc.min(w, h) * 0.36
      if h >= w { rect(S((x0 + 0.05, y0)), S((x1 - 0.05, y0 + 0.16)), stroke: st); circle(S((cx, y1 - r - 0.05)), radius: r, stroke: st) }
      else { rect(S((x0, y0 + 0.05)), S((x0 + 0.16, y1 - 0.05)), stroke: st); circle(S((x1 - r - 0.05, cy)), radius: r, stroke: st) }
    } else if t.contains("tub") {
      rect(S((x0 + 0.07, y0 + 0.07)), S((x1 - 0.07, y1 - 0.07)), stroke: st)
    } else if t.contains("shower") {
      line(S((x0, y0)), S((x1, y1)), stroke: 0.3pt + fix-line); line(S((x0, y1)), S((x1, y0)), stroke: 0.3pt + fix-line)
      circle(S((cx, cy)), radius: 0.05, fill: fix-line, stroke: none)
    } else if t.contains("basin") or t.contains("vanity") or t.contains("trough") or (t.contains("sink") and not t.contains("counter")) {
      let n = calc.max(1, calc.min(3, calc.round(calc.max(w, h) / 0.7)))
      for k in range(int(n)) {
        let p = if w >= h { (x0 + w * (k + 0.5) / n, cy) } else { (cx, y0 + h * (k + 0.5) / n) }
        circle(S(p), radius: calc.min(w, h) * 0.3, stroke: st)
      }
    } else if t.contains("washer") or t.contains("dryer") {
      circle(S((cx, cy)), radius: calc.min(w, h) * 0.36, stroke: st)
    } else if t.contains("bed") {
      if w >= h { rect(S((x0 + 0.05, y0 + 0.07)), S((x0 + 0.3, y1 - 0.07)), stroke: 0.35pt + furn-line) }
      else { rect(S((x0 + 0.07, y0 + 0.05)), S((x1 - 0.07, y0 + 0.3)), stroke: 0.35pt + furn-line) }
    }
  }
  // doors and openings, windows
  for d in doors {
    poly(cut(d.a, d.b), fill: floor-c, stroke: none)
    let w = dist(d.a, d.b); let (ix, iy) = d.into
    let u = ((d.b.at(0) - d.a.at(0)) / w, (d.b.at(1) - d.a.at(1)) / w)
    let leaf(h, uu, ww) = {
      let tip = (h.at(0) + ix * ww, h.at(1) + iy * ww)
      line(S(h), S(tip), stroke: 0.8pt + furn-line)
      line(..range(0, 11).map(k => { let th = k * 9deg; S((h.at(0) + ww * (calc.cos(th) * uu.at(0) + calc.sin(th) * ix), h.at(1) + ww * (calc.cos(th) * uu.at(1) + calc.sin(th) * iy))) }), stroke: 0.35pt + furn-line)
    }
    if d.kind == "hinged" { leaf(d.a, u, w) }
    else if d.kind == "double" { leaf(d.a, u, w / 2); leaf(d.b, (-u.at(0), -u.at(1)), w / 2) }
    else if d.kind == "sliding" {
      let o(p, s) = (p.at(0) + ix * s, p.at(1) + iy * s)
      line(S(o(d.a, 0.03)), S(o((d.a.at(0) + u.at(0) * w * 0.6, d.a.at(1) + u.at(1) * w * 0.6), 0.03)), stroke: 1pt + furn-line)
      line(S(o((d.a.at(0) + u.at(0) * w * 0.4, d.a.at(1) + u.at(1) * w * 0.4), -0.03)), S(o(d.b, -0.03)), stroke: 1pt + furn-line)
    }
  }
  for (a, b) in windows {
    poly(cut(a, b, half: 0.13), fill: white, stroke: 0.35pt + fix-line)
    line(S(a), S(b), stroke: 0.35pt + fix-line)
  }
  for c in columns { rect(S((c.at(0) - 0.16, c.at(1) - 0.16)), S((c.at(0) + 0.16, c.at(1) + 0.16)), fill: dark, stroke: none) }
  if beam != none { line(S(beam.at(0)), S(beam.at(1)), stroke: (paint: rgb("#c25b00"), thickness: 0.8pt, dash: "dashed")) }
  if labels {
    for r in rooms.filter(r => infocus(r) and r.kind != "core" or (infocus(r) and r.name.starts-with("Stair"))) {
      let cp = clear-poly(r, spec)
      let c = label-at.at(r.name, default: pcentroid(cp))
      let small = area(r.P) < 4
      let nm = short.at(r.name, default: r.name)
      content(S(c), box(align(center, text(if small { 4.3pt } else { 5.4pt }, fill: dark)[#if r.id != "" [*#r.id*\ ]#nm#if not small and r.kind != "void" [\ #text(fill: soft)[#n2(area(r.P)) m²]]])))
    }
  }
}
// dimension line between a and b (CSV), drawn off by the vector o
#let dim(a, b, o, label, shift: (0, 0)) = {
  import cetz.draw: *
  let S(p) = q((p.at(0) + shift.at(0), p.at(1) + shift.at(1)))
  let A = (a.at(0) + o.at(0), a.at(1) + o.at(1)); let B = (b.at(0) + o.at(0), b.at(1) + o.at(1))
  line(S(a), S(A), stroke: 0.3pt + soft); line(S(b), S(B), stroke: 0.3pt + soft)
  line(S(A), S(B), stroke: 0.5pt + dark)
  for p in (A, B) { line(S((p.at(0) - 0.18, p.at(1) + 0.18)), S((p.at(0) + 0.18, p.at(1) - 0.18)), stroke: 0.6pt + dark) }
  let m = ((A.at(0) + B.at(0)) / 2, (A.at(1) + B.at(1)) / 2)
  let vertical = calc.abs(a.at(0) - b.at(0)) < 1e-6
  content(S(m), angle: if vertical { 90deg } else { 0deg }, anchor: "south", padding: 0.08, text(5.6pt, fill: dark, label))
}
#let north-arrow(p) = {
  import cetz.draw: *
  line(q(p), (p.at(0) + 1.6 * north.at(0), -p.at(1) + 1.6 * north.at(1)), stroke: 0.9pt + accent, mark: (end: "stealth", fill: accent, scale: 0.6))
  content((p.at(0) + 2.05 * north.at(0), -p.at(1) + 2.05 * north.at(1)), text(6pt, weight: "bold", fill: accent)[TRUE N])
}
#let scale-bar(p, m: 5) = {
  import cetz.draw: *
  for k in range(m) { rect(q((p.at(0) + k, p.at(1))), q((p.at(0) + k + 1, p.at(1) + 0.18)), fill: if calc.even(k) { dark } else { white }, stroke: 0.4pt + dark) }
  content(q((p.at(0), p.at(1) + 0.55)), text(5.5pt)[0]); content(q((p.at(0) + m, p.at(1) + 0.55)), text(5.5pt)[#m m])
}
#let kpi(v, l) = box(fill: rgb("#e4eedf"), inset: 7pt, radius: 2pt, width: 100%)[#text(13pt, weight: "bold", fill: accent)[#v]\ #text(6.6pt, fill: soft)[#l]]

// ================= numbers =================
#let footprint = area(offset-poly(outline-csv, (-0.125,) * 5))
#let gf-real = gf-rooms.filter(r => r.kind != "court" and r.name != "Air tower")
#let ff-real = ff-rooms.filter(r => r.id != "" and r.kind != "open")
#let gf-area = gf-real.map(r => area(r.P)).sum()
#let ff-area = ff-real.map(r => area(r.P)).sum()
#let suite-names = ("Suite lobby", "Suite bath", "Suite WC (closet)", "Suite dressing", "Suite bedroom")
#let suite-area = ff-rooms.filter(r => r.name in suite-names).map(r => area(r.P)).sum()
#let court-r = gf-rooms.find(r => r.kind == "court")
#let ff-label-at = (
  "Upper gallery (on the west projection)": (4.92, 12.2), "Bedroom 3": (2.4, 17.6), "Suite bedroom": (11.4, 16.6), "Suite bath": (11.3, 8.9),
  "Bedroom 1": (11.0, 4.6), "Family bath": (3.3, 9.7), "Owner's office": (2.1, 20.6), "Gym": (8.5, 22.6), "Suite court (open to the sky)": (8.3, 20.25),
  "Kids' room (study + gaming)": (5.6, 2.2), "Family living": (5.3, 5.9), "Courtyard (open to the sky)": (7.3, 9.75), "Double-height living (void)": (7.3, 16.0),
)
#let gf-label-at = ("Family lobby + riwaq": (3.5, 4.0), "Maid room": (11.9, 5.6), "Maid bath": (9.6, 1.9), "Living (double height)": (6.6, 14.2), "Living (normal height) · dining": (11.1, 14.0), "Men's majlis": (8.0, 22.6), "Women's majlis": (6.6, 4.6), "Kitchen": (11.1, 12.2))

// ===================================================================================== SHEET 01 · site
#sheet-head([V5.0 · the house on its site], [Ground floor V5.0 (coordinated) + first floor V5.0 (designed) | site-test option Z4 | shift (0.91, 3.525) m, rotation 0° | 250 mm outer / 200 mm inner walls])
#grid(columns: (auto, 1fr), column-gutter: 16pt,
  cetz.canvas(length: 0.37cm, {
    import cetz.draw: *
    line(..land.map(q), close: true, fill: rgb("#eef3e6"), stroke: 0.6pt + accent)
    line(..env.map(q), close: true, fill: rgb("#e3eedb"), stroke: (paint: accent, dash: "dashed", thickness: 0.6pt))
    line(..drv.map(q), close: true, fill: rgb("#d6e2ea"), stroke: 0.5pt + rgb("#2f5f8a"))
    line(..lane.map(q), stroke: 1.2pt + dark); line(..nwall.map(q), stroke: 1.2pt + dark)
    draw-floor(gf-rooms, gf-walls, (), (), (), shift: (0.91, 3.525), labels: false, mini: true)
    for (T, n) in ((T1, [P1]), (T2, [P2])) {
      circle(q(T), radius: 1.0, fill: rgb("#cfdfc3"), stroke: 0.5pt + accent)
      circle(q(T), radius: 0.27, fill: accent, stroke: none)
      content(q((T.at(0) + 1.5, T.at(1))), anchor: "west", text(6pt, fill: accent, n))
    }
    for (p, n) in Ms.zip(([M1], [M2], [M3], [M4])) { circle(q(p), radius: 0.2, fill: accent, stroke: none); content(q((p.at(0) - 0.7, p.at(1))), anchor: "east", text(5.5pt, fill: rgb("#b5452f"), n)) }
    content(q((-2.0, 18)), angle: 90deg, text(6pt, fill: rgb("#2f5f8a"))[DRIVEWAY])
    content(q((3.5, -2.2)), text(6.5pt, weight: "bold")[NORTH STREET / GATE])
    content(q((7.6, 15.7)), text(6.5pt, weight: "bold", fill: white)[HOUSE])
    north-arrow((22.0, 2.0))
    scale-bar((0, 41.0), m: 10)
  }),
  [
    #ar[
      #ah[ما هو V5.0؟]
      نسخة V5.0 تجمع الدورين: الدور الأرضي V4.0 بعد تنسيقه مع الدور الأول، والدور الأول مصمم غرفة غرفة مع الأثاث والأبواب والتصريف. كل الأرقام في هذه اللوحات مأخوذة مباشرة من ملفات المشروع (data/rooms_gf.csv و data/rooms_ff.csv والدراسات)، فلا يوجد رقم مكتوب يدويا.

      #ah[المبنى في الموقع]
      مخمس على خيار Z4 بأبعاد 13.311 × 24.0 م على المحاور (13.561 × 24.25 م من الخارج)، مع قطع الركن الشمالي الشرقي موازيا للزقاق حتى عمق 6 م. الإزاحة عن المرجع (0.91، 3.525) م بلا دوران. النخلتان P1 و P2 خارج الواجهة الجنوبية.

      #ah[الفكرة]
      فناء في الوسط، ومجلس النساء شماله، والصالة بارتفاع مزدوج جنوبه. شريط خدمات غربي (المصعد المستقبلي، الدرج المفتوح، الشفت، كتلة المغاسل) وكتلة خدمات شرقية (المطبخ، الغسيل، غرفة الخادمة، برج الهواء). مجلس الرجال على كامل العرض جنوبا بمدخل مستقل.

      #ah[الجديد في V5.0]
      في الدور الأول بروز غربي بعرض 1.35 م فوق الفناء والصالة يحمل الممر العلوي، فاتسعت غرف الشريط الغربي إلى 4.25 م. وفي الدور الأرضي ألغي الشفت الشرقي، وأضيفت ثلاثة أعمدة على خط x 5.6 تحمل البروز.
    ]
    #v(6pt)
    #grid(columns: (1fr, 1fr, 1fr), column-gutter: 6pt, row-gutter: 6pt,
      kpi[#n2(footprint) m²][outside footprint (incl. courtyard)], kpi[#n2(gf-area) m²][ground floor rooms (axes)], kpi[#n2(ff-area) m²][first floor rooms (axes)],
      kpi[4.50 × 6.30 m][courtyard, clear], kpi[#n2(suite-area) m²][master suite (indoors)], kpi[0.785 m][west wall face to the M line],
    )
  ],
)

// ===================================================================================== SHEET 02 · ground floor
#pagebreak()
#sheet-head([Ground floor V5.0], [V4.0 + first-floor coordination: no east duct, three columns at x 5.6 under the first-floor projection | brown = 1.20 m low partition | doors and windows outside the two studied blocks are indicative])
#grid(columns: (auto, 1fr), column-gutter: 14pt,
  cetz.canvas(length: 0.555cm, {
    import cetz.draw: *
    draw-floor(gf-rooms, gf-walls, gf-doors, gf-windows, gf-furniture, lowwalls: gf-lowwalls, columns: gf-columns, beam: ((5.6, 6.5), (5.6, 19.25)), label-at: gf-label-at)
    dim((-0.125, 0), (13.436, 0), (0, -1.0), [13.561 m outside])
    dim((0, -0.125), (0, 24.125), (-1.0, 0), [24.25 m outside])
    dim((4.35, 7.2), (8.85, 7.2), (0, 0), [4.50 m clear])
    north-arrow((14.6, 1.0))
    scale-bar((0, 25.6))
  }),
  [
    #ar[
      #ah[الوسط: مجلس النساء، الفناء، الصالة]
      عرض الوسط 4.70 م على المحاور و4.50 م صافيا. الفناء 4.50 × 6.30 م صافي ومفتوح للسماء. الصالة بارتفاع مزدوج تفتح على الرواق بفتحة 1.40 م بلا باب، ثم جدار منخفض بارتفاع 1.20 م (بني فاتح). الطعام مع الصالة غرفة واحدة بسقفين.

      #ah[الشريط الغربي والرواق]
      المصعد المستقبلي، والدرج مفتوح بلا باب، وغرفة الخدمات مع الشفت الغربي، ثم كتلة المغاسل: مطبخ الضيافة، مغاسل العائلة، دورة العائلة، وممر التقديم ببابين لا يفتحان معا. الرواق 1.50 م على طول الواجهة الغربية للفناء.

      #ah[جهة الضيوف]
      بهو الضيوف بباب مزدوج 1.40 م في الجدار الغربي، وحمام الضيوف ومغسلة بثلاثة صنابير، ثم فتحة 1.80 م إلى مجلس الرجال 10.56 × 4.75 م. لا يوجد باب من الرواق إلى المجلس.

      #ah[الكتلة الشرقية]
      المطبخ 4.361 × 6.5 م بخطي خزائن، والغسيل، وغرفة الخادمة وحمامها حتى الجدار المائل، وبرج الهواء في الطرف الشمالي. الوصول للخادمة من المطبخ فقط.

      #ah[تغييرات V5.0]
      ألغي الشفت الشرقي في ركن المطبخ: الشفاط يخرج مباشرة من الجدار الشرقي، وماسورة التهوية على الوجه الخارجي للجدار. ثلاثة أعمدة على x 5.6 (في جدار مجلس النساء، وبين زجاج الفناء والصالة، وفي جدار الصالة الجنوبي) تحمل جسر حافة البروز في الدور الأول (الخط البرتقالي المتقطع).
    ]
  ],
)

// ===================================================================================== SHEET 03 · first floor
#pagebreak()
#sheet-head([First floor V5.0], [Gallery on a 1.35 m west projection over the courtyard and the double-height void | hatched = open below / to the sky | furniture from the two first-floor studies])
#grid(columns: (auto, 1fr), column-gutter: 14pt,
  cetz.canvas(length: 0.555cm, {
    import cetz.draw: *
    draw-floor(ff-rooms, ff-walls, ff-doors, ff-windows, ff-furniture, beam: ((5.6, 6.5), (5.6, 19.25)), label-at: ff-label-at)
    dim((-0.125, 0), (13.436, 0), (0, -1.0), [13.561 m outside])
    dim((0, -0.125), (0, 24.125), (-1.0, 0), [24.25 m outside])
    dim((5.6, 11.6), (8.95, 11.6), (0, 0), [3.35 m sky])
    dim((4.25, 18.6), (5.6, 18.6), (0, 0), [1.35])
    north-arrow((14.6, 1.0))
    scale-bar((0, 25.6))
  }),
  [
    #ar[
      #ah[البروز الغربي والممر العلوي]
      بروز بعرض 1.35 م على طول الحافة الغربية للفناء والصالة (من y 6.5 إلى y 19.25) يحمل الممر العلوي، وصافيه نحو 1.23 م مع درابزين على جهة الفراغ. بذلك أخذت غرف الشريط الغربي العرض كاملا 4.25 م (نحو 4.0 م صافي). عرض السماء فوق الفناء وفراغ الصالة صار 3.35 م على المحاور.

      #ah[الشريط الشمالي]
      غرفة الأطفال (دراسة وألعاب) 4.7 × 3.0 م، وجلسة العائلة 4.7 × 3.5 م على حافة الفناء: إطلالة لا ممر، والطريق إلى جناح الوالدين خلف الكنبة.

      #ah[الشريط الغربي]
      حمام العائلة بجوار الشفت، وغرفة النوم 2 بعرض 4.25 م، وغرفة النوم 3 مع حمامها الخاص فوق دورة العائلة في الأرضي تماما. كل الأبواب من الممر، ولا باب على بسطة الدرج.

      #ah[غرفة النوم 1]
      غرفة واحدة بلا حمام، جدارها الجنوبي مستقيم على خط الفناء الشمالي (فوق جدار المطبخ).

      #ah[الجنوب والشرق]
      مكتب المالك في الركن الجنوبي الغربي، ثم ممر النادي، والنادي على طول الواجهة الجنوبية، وفناء الجناح المفتوح للسماء أمام نوافذ الصالة العلوية، وجناح النوم الرئيسي على الجهة الشرقية بمدخل من وصلة العائلة.
    ]
  ],
)

// ===================================================================================== SHEET 04 · first floor family part
#pagebreak()
#sheet-head([First floor / the family part], [Kids' room, family living, bedrooms 1–3, family bath, gallery on the projection | furnished test from studies/ff_family.typ])
#let fam-focus = ("Landing (stair top)", "Upper gallery (on the west projection)", "Linen cupboard", "Family bath", "Wardrobe niche (bedroom 2)", "Bedroom 2", "Bedroom 3 bath", "Bedroom 3", "Kids' room (study + gaming)", "Family living", "Family link", "Bedroom 1", "Stair", "Lift shaft (future)", "West shaft", "Air tower", "Courtyard (open to the sky)", "Double-height living (void)")
#grid(columns: (auto, 1fr), column-gutter: 14pt,
  cetz.canvas(length: 0.7cm, {
    import cetz.draw: *
    draw-floor(ff-rooms.filter(r => bbox(r.P).at(1) < 19.2), ff-walls, ff-doors.filter(d => d.a.at(1) < 19.2), ff-windows.filter(w => w.at(0).at(1) < 19.2), ff-furniture.filter(f => f.at(1) < 19.2), focus: fam-focus, label-at: ff-label-at)
    dim((0, 11.0), (4.25, 11.0), (0, 0.45), [4.25 m axes · ≈ 4.0 m clear])
    dim((0, 0), (0, 19.25), (-0.8, 0), [19.25 m])
    scale-bar((0, 20.0))
  }),
  [
    #ar[
      #ah[غرفة الأطفال: دراسة وألعاب]
      4.7 × 3.0 م: مكتبا دراسة ومكتب كمبيوتر تحت النافذة الشمالية، وركن ألعاب (شاشة حتى 50 بوصة على الجدار الشرقي وكنبة صغيرة بمسافة نحو 1.3 م)، وباب مصمت من الممر لعزل الصوت. يمكن أن تصبح غرفة نوم رابعة لاحقا.

      #ah[جلسة العائلة]
      4.7 × 3.5 م = 16.45 م² على حافة الفناء. الشاشة على الجدار الغربي، وكنبة تقابلها والفناء على يسارها، وكنبة صغيرة تطل على الفناء. لا أحد يمشي بين الجلسة والفناء.

      #ah[غرف النوم]
      النوم 2: 4.25 × 3.4 م، سرير 1.4 × 2.0 بطاولتين جانبيتين، دولاب في التجويف بجانب الشفت وآخر على الجدار الشرقي، ومكتب تحت النافذة. النوم 3: مدخل بدولاب ثم غرفة 4.25 × 3.15 م وحمام خاص 2.2 × 1.7 م (دش، مرحاض، مغسلة). النوم 1: 15.75 م² غرفة واحدة بلا حمام.

      #ah[حمام العائلة]
      2.75 × 1.8 م بجوار الشفت الغربي: مرحاض على جدار الشفت، ودش، ومغسلة عند الباب، والباب من الممر بعيدا عن نظر الدرج. يخدم النوم 1 و2 والجلسة وغرفة الأطفال.

      #ah[التخزين]
      دولاب البياضات في نهاية الممر الشمالية (2.0 × 0.7 م). الدواليب المدمجة تنفذ كصندوق نجارة بجوانب 18 مم، أو بجدار بلوك 10 سم عند الحاجة فقط (DETAILS.md).
    ]
  ],
)

// ===================================================================================== SHEET 05 · the L and the master suite
#pagebreak()
#sheet-head([First floor / office, gym, suite court and master suite], [The L from the gallery end to the family link | furnished test from studies/ff_suite.typ | sliding doors to the office, gym, WC closet and court])
#let l-focus = ("Gym route", "Owner's office", "Gym", "Suite court (open to the sky)", "Suite lobby", "Suite bath", "Suite WC (closet)", "Suite dressing", "Suite bedroom")
#grid(columns: (auto, 1fr), column-gutter: 14pt,
  cetz.canvas(length: 0.62cm, {
    import cetz.draw: *
    draw-floor(ff-rooms.filter(r => bbox(r.P).at(3) > 6.4), ff-walls, ff-doors.filter(d => d.a.at(1) >= 6.4), ff-windows.filter(w => w.at(0).at(1) >= 6.4), ff-furniture.filter(f => f.at(3) > 6.5), focus: l-focus, label-at: ff-label-at)
    dim((8.95, 6.5), (13.311, 6.5), (0, -0.7), [4.361 m axes])
    dim((13.311, 6.5), (13.311, 19.25), (0.8, 0), [12.75 m · master suite 55.6 m²])
    scale-bar((0, 25.0))
  }),
  [
    #ar[
      #ah[جناح النوم الرئيسي · 55.6 م²]
      المدخل من وصلة العائلة إلى ردهة 1.35 م تتوزع منها الأبواب: الحمام والملابس والنوم، ولا يمر أحد عبر غرفة الملابس. باب الحمام وباب الملابس في أقصى الشمال من جداريهما.

      #ah[الحمام الفاخر · 3.01 × 3.95 م]
      بانيو مستقل 1.7 م على الجدار الجنوبي بجانب نافذة، ودش زجاجي 1.1 × 1.4 م على الجدار الشرقي، ومغسلتان على الجدار الغربي بمرآة تواجه ضوء النافذة، ومرحاض في حجرة مستقلة بباب منزلق مع شطاف بجانب ماسورة التصريف. التصريف في أرضية منخفضة إلى ماسورة على الوجه الخارجي للجدار الشرقي، ولا شيء معلق في سقف المطبخ.

      #ah[غرفة الملابس · 3.01 × 3.45 م]
      دواليب للرجل 3.25 م على الجدار الشرقي، وللسيدة 2.1 م على الجنوبي، بأبواب منزلقة، ورف للأحذية والحقائب، وطاولة مكياج بمرآة كاملة، وكرسي في الوسط.

      #ah[غرفة النوم · 26.0 م²]
      سرير كبير 1.8 × 2.0 م على جدار الملابس يطل جنوبا على فناء الجناح، وجلسة على الجدار الغربي المصمت (لا نافذة على فراغ الصالة)، وباب منزلق إلى الفناء.

      #ah[فناء الجناح · 7.71 × 2.0 م]
      مغلق من الجهات الأربع ومفتوح للسماء أمام نافذتي الصالة العلويتين؛ على حافة سطح النادي درابزين لا دروة حتى تصل شمس الشتاء للنوافذ.

      #ah[المكتب والنادي]
      مكتب المالك 4.25 × 4.75 م = 20.2 م² (جلسة ومكتبة في الشمال، ومكتب بكرسيين للزوار في الجنوب). النادي 9.06 × 2.75 م على طول الواجهة الجنوبية. البابان منزلقان من ممر النادي.
    ]
  ],
)

// ===================================================================================== SHEET 06 · sections
#pagebreak()
#sheet-head([Sections / light and the west projection], [Schematic sections, levels to confirm: GF ±0.00 · FF +3.60 · roof +7.20 | the light figures are geometry only, a daylight simulation comes later])
#let lvl(y) = y
#grid(columns: (1fr, 1fr), column-gutter: 14pt,
  [
    #text(8pt, weight: "bold", fill: accent)[A · east–west through the courtyard (y ≈ 9.75)]
    #cetz.canvas(length: 0.55cm, {
      import cetz.draw: *
      let B(x0, h0, x1, h1, c, l) = { rect((x0, h0), (x1, h1), fill: c, stroke: 0.5pt + dark); if l != none { content(((x0 + x1) / 2, (h0 + h1) / 2), text(5pt, l)) } }
      line((-0.8, 0), (14.2, 0), stroke: 1pt + dark)
      B(0, 0, 2.75, 3.6, fills.core, [utility · shaft]); B(2.75, 0, 4.25, 3.6, fills.circ, [riwaq]); B(8.95, 0, 13.311, 3.6, fills.service, [kitchen])
      B(0, 3.6, 4.25, 7.2, fills.wet, [family bath · bedroom 2]); B(8.95, 3.6, 13.311, 7.2, fills.suite, [suite lobby · bath])
      rect((4.25, 3.4), (5.6, 3.6), fill: dark, stroke: none)
      content((4.92, 3.95), text(5pt)[gallery])
      line((5.6, 3.6), (5.6, 4.7), stroke: 0.8pt + rgb("#1f7a99"))
      rect((5.45, 0), (5.75, 3.4), stroke: (paint: dark, dash: "dashed", thickness: 0.5pt))
      content((5.6, -0.45), text(5pt)[column (beyond)])
      content((7.27, 1.6), text(5.5pt, fill: rgb("#2f5f8a"))[COURTYARD])
      content((7.27, 6.0), text(5.5pt, fill: rgb("#2f5f8a"))[sky 3.35 m])
      line((4.25, 3.4), (4.25, 0), stroke: (paint: rgb("#1f7a99"), thickness: 1.6pt))
      for (h, l) in ((0, [±0.00]), (3.6, [+3.60]), (7.2, [+7.20])) { content((-1.0, h), anchor: "east", text(5pt, fill: soft, l)) }
      content((0, -0.45), anchor: "north-west", text(5.5pt)[W]); content((13.311, -0.45), anchor: "north-east", text(5.5pt)[E])
      line((4.25, 7.9), (5.6, 7.9), stroke: 0.5pt + dark); content((4.92, 8.25), text(5pt)[1.35])
    })
    #v(4pt)
    #text(8pt, weight: "bold", fill: accent)[B · north–south through the middle band (x ≈ 7.3)]
    #cetz.canvas(length: 0.42cm, {
      import cetz.draw: *
      let B(y0, h0, y1, h1, c, l) = { rect((y0, h0), (y1, h1), fill: c, stroke: 0.5pt + dark); if l != none { content(((y0 + y1) / 2, (h0 + h1) / 2), text(4.6pt, l)) } }
      line((-0.8, 0), (25, 0), stroke: 1pt + dark)
      B(0, 0, 6.5, 3.6, fills.family, [women's majlis]); B(0, 3.6, 6.5, 7.2, fills.family, [kids' room · living])
      B(13, 0, 19.25, 7.2, rgb("#fbf2e2"), [living (double height)]); B(19.25, 0, 24, 3.6, fills.guest, [men's majlis])
      B(21.25, 3.6, 24, 7.2, fills.gym, [gym]); content((20.25, 4.0), text(4.6pt)[suite court])
      content((9.75, 1.5), text(5pt, fill: rgb("#2f5f8a"))[COURTYARD])
      line((19.25, 5.0), (19.25, 6.0), stroke: 2.4pt + rgb("#1f7a99"))
      line((19.25, 5.0), (19.25 + 7 * calc.cos(45.2deg), 5.0 + 7 * calc.sin(45.2deg)), stroke: 0.8pt + rgb("#d08a00"))
      content((24.6, 10.4), text(5pt, fill: rgb("#d08a00"))[winter noon 45°])
      content((0, -0.5), anchor: "north-west", text(5.5pt)[N]); content((24, -0.5), anchor: "north-east", text(5.5pt)[S])
    })
  ],
  [
    #ar[
      #ah[البروز الغربي (المقطع A)]
      بلاطة الدور الأول تبرز 1.35 م بعد خط الفناء x 4.25 وتحمل الممر العلوي مع درابزين. الحل الأول: جسر حافة على x 5.6 فوق ثلاثة أعمدة في خطوط جدران أو زجاج قائمة، فيصبح في الأرضي رواق بأعمدة على حافة الفناء. الحل البديل: كابولي بسيط بلا أعمدة. يختار المهندس الإنشائي ويحدد المقاسات والأساسات.

      #ah[ماذا يتغير في الأرضي]
      أرضية الفناء والصالة كاملة كما هي؛ يصبح السقف تحت البروز (x 4.25 إلى 5.6) بارتفاع عادي بدل المزدوج، ويظهر خط الجسر.

      #ah[الضوء (المقطع B)]
      الضوء الرئيسي للصالة من زجاج الفناء. نافذتا الصالة الجنوبيتان العلويتان (1.0 × 1.0 م، جلسة +5.00) تطلان على فناء الجناح بعرض 2.0 م. مع درابزين على حافة سطح النادي تصل شمس ظهر الشتاء إلى نحو 80٪ من ارتفاع النافذة، ومع دروة صلبة 1.10 م تنعدم تقريبا.

      #ah[الخصوصية]
      النافذتان تطلان على فناء الجناح الخاص، لذا تكون جلستهما فوق مستوى النظر من أرضية الفناء أو بزجاج معتم؛ يتأكد ذلك عند تثبيت المناسيب.
    ]
  ],
)

// ===================================================================================== SHEET 07 · area schedules
#pagebreak()
#sheet-head([Areas / room schedules V5.0], [Axes = wall centre lines | clear = inside the walls as drawn (250 mm outer, 200 mm inner, 100 mm partitions, thin balustrades), furniture and thresholds not deducted])
#let sched(rooms, spec) = table(columns: (auto, 1fr, auto, auto, auto), stroke: none, inset: 2.2pt, fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
  text(6.4pt, weight: "bold", fill: accent)[ID], text(6.4pt, weight: "bold", fill: accent)[Space], text(6.4pt, weight: "bold", fill: accent)[Axis size], text(6.4pt, weight: "bold", fill: accent)[Axis area], text(6.4pt, weight: "bold", fill: accent)[≈ Clear],
  ..rooms.map(r => {
    let (x0, y0, x1, y1) = bbox(r.P)
    (text(6.3pt)[#r.id], text(6.3pt)[#r.name], text(6.3pt)[#if is-rect(r.P) [#n2(x1 - x0) × #n2(y1 - y0) m] else [polygon]], text(6.3pt)[#n2(area(r.P)) m²], text(6.3pt)[#if r.kind in ("open", "court") [–] else [#n2(area(clear-poly(r, spec))) m²]])
  }).flatten())
#grid(columns: (1fr, 1fr), column-gutter: 14pt,
  [#text(9pt, weight: "bold")[Ground floor] #sched(gf-rooms.filter(r => r.id != ""), gf-walls)],
  [#text(9pt, weight: "bold")[First floor] #sched(ff-rooms.filter(r => r.id != ""), ff-walls)
    #v(4pt)
    #grid(columns: (1fr, 1fr), column-gutter: 6pt, row-gutter: 6pt,
      kpi[#n2(footprint) m²][outside footprint, incl. courtyard], kpi[#n2(area(court-r.P)) m²][courtyard on axes (4.50 × 6.30 clear)],
      kpi[#n2(gf-area) m²][ground floor rooms (axes)], kpi[#n2(ff-area) m²][first floor rooms (axes), + suite court #n2(area(ff-rooms.find(r => r.kind == "open").P)) m²],
    )
  ],
)

// ===================================================================================== SHEET 08 · for the engineer
#pagebreak()
#sheet-head([For the engineers / open items V5.0], [Full notes in docs/DETAILS.md | drawings: design_gf, design_ff and the four studies | CAD: output/taif_ground_floor_V5.dxf])
#grid(columns: (auto, 1fr), column-gutter: 16pt,
  cetz.canvas(length: 0.42cm, {
    import cetz.draw: *
    draw-floor(ff-rooms, ff-walls, (), (), (), labels: false, mini: true)
    for c in gf-columns { circle(q(c), radius: 0.35, fill: rgb("#c25b00"), stroke: none) }
    line(q((5.6, 6.5)), q((5.6, 19.25)), stroke: (paint: rgb("#c25b00"), thickness: 1.2pt, dash: "dashed"))
    let tag(p, n) = { circle(q(p), radius: 0.55, fill: white, stroke: 0.8pt + accent); content(q(p), text(6.5pt, weight: "bold", fill: accent, n)) }
    tag((6.9, 10.0), [1]); tag((8.0, 22.6), [2]); tag((6.6, 3.0), [3]); tag((14.0, 7.0), [4]); tag((11.3, 8.6), [5]); tag((8.3, 20.25), [6]); tag((2.1, 21.8), [7])
  }),
  [
    #ar[
      #ah[1 · البروز الغربي]
      جسر حافة على x 5.6 فوق ثلاثة أعمدة بأساسات مستقلة، أو كابولي 1.35 م بلا أعمدة. تحديد عمق الجسر (بحر نحو 6.5 م) ومقاسات الأعمدة والأساسات.

      #ah[2 · النادي فوق مجلس الرجال]
      الأحمال والاهتزاز للنادي وجدرانه ولجدران المكتب فوق سقف المجلس؛ جدران لا تحتها جدران (y 21.25، x 4.25، x 5.6).

      #ah[3 · جدار غرفة الأطفال]
      جدار y 3.0 فوق مجلس النساء بلا جدار تحته: قاطع خفيف على البلاطة أو جسر، مع عزل صوتي.

      #ah[4 · ماسورة الجدار الشرقي (ميكانيكا)]
      لا شفت شرقي: الشفاط يخرج من الجدار الشرقي عند الموقد، وماسورة التهوية وتصريف حمام الجناح على الوجه الخارجي للجدار حتى غرفة التفتيش الشرقية؛ يكون الموقد جنوب y 7.5 تقريبا.

      #ah[5 · أرضيات الحمامات المنخفضة]
      حمام الجناح فوق المطبخ وحمام العائلة جزئيا فوق مطبخ الضيافة: كل المواسير في أرضية الحمام المنخفضة، ولا شيء في سقف المطبخ. لا تصريف فوق غرفة النوم الرئيسية. حمام النوم 3 فوق دورة العائلة تماما.

      #ah[6 · فناء الجناح]
      مفتوح للسماء: صفاية وعزل مائي على سقف المجلس، ودرابزين لا دروة على حافة سطح النادي، وجلسة النوافذ العلوية أو زجاج معتم.

      #ah[7 · الأبواب والدواليب]
      أبواب منزلقة للمكتب والنادي وحجرة المرحاض وفناء الجناح. الدواليب المدمجة صندوق نجارة، أو بلوك 10 سم مع توسيع التجويف 20 سم.
    ]
  ],
)

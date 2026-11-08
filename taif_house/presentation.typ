// presentation.typ · Taif / Palm House V9.3 (the new malqaf tower) · presentation set, A3, 12 sheets (ground floor, first floor, roof, elevations) · compile THIS file
//   typst compile --root taif_house taif_house/presentation.typ taif_house/output/Taif_House_V9.3_presentation.pdf
// Every number comes from the project files: data/rooms_gf.csv, data/rooms_ff.csv, data/decisions.csv, data/open_items.csv, the design files
// (placement, gaps) and the studies (doors, windows, furniture, fixtures, the treadmill, the sections and the light check). Walls are drawn with
// thickness from the room outlines (250 mm outer, 200 mm inner, 100 mm dry partitions, the steel windows W1 / W2 on the courtyard edges since V7.0). Ground-floor doors and
// windows outside the two studied blocks are indicative.
#import "@preview/cetz:0.4.2"
#import "base.typ": land, env, drv, lane, nwall, south, T1, T2, Ms, north, accent, edges, seg-dist
#import "design_gf.typ": shift, env-gap, outline-csv-gf, outline-gf
#import "studies/ff_family.typ" as fam
#import "studies/ff_suite.typ" as suite
#import "studies/east_wing.typ" as ew
#import "studies/guest_wing.typ" as gw
#import "studies/sections.typ" as sec
#import "studies/roof.typ" as rf
#import "studies/site_plan.typ" as sp   // V8.2: the site and services plan (study: every position proposed, to confirm with the survey and the engineers)

// ================= sheet look (A3 landscape) =================
#let dark = rgb("#22352e")
#let paper = rgb("#f9f8f4")
#let soft = luma(120)
#let orange = rgb("#c25b00")
#let sheets-total = 12
#set page(paper: "a3", flipped: true, margin: (x: 16mm, top: 14mm, bottom: 18mm), fill: paper,
  footer: context {
    line(length: 100%, stroke: 0.5pt + luma(200))
    v(-4pt)
    grid(columns: (1fr, auto),
      text(8pt, fill: soft)[DESIGN DEVELOPMENT STUDY | NOT FOR CONSTRUCTION | All dimensions in metres unless stated | wall centre lines (axes) unless "clear"],
      text(9pt, weight: "bold", fill: accent)[#{ let pad(n) = (if n < 10 { "0" } else { "" }) + str(n); pad(counter(page).get().first()) + " / " + pad(sheets-total) }])
  })
#set text(font: ("Segoe UI", "Arial"), size: 10pt, fill: dark)

#let sheet-head(title, subtitle) = {
  grid(columns: (1fr, auto), text(11pt, weight: "bold", fill: accent)[TAIF / PALM HOUSE], text(9pt, fill: soft)[V9.3 · layout freeze · the new malqaf tower])
  v(1pt)
  text(24pt, weight: "bold")[#title]
  linebreak()
  text(9pt, fill: soft)[#subtitle]
  v(-3pt)
  line(length: 100%, stroke: 0.5pt + luma(200))
  v(2pt)
}
#let ah(t) = block(above: 10pt, below: 4pt, text(12pt, weight: "bold", fill: accent, t))
// English notes, then the Arabic notes (right to left)
#let en(body) = block(width: 100%, fill: rgb("#eef2ea"), inset: 8pt, radius: 2pt, { set text(9.5pt); set par(leading: 0.55em, spacing: 0.75em); body })
#let ar(body) = block(width: 100%, {
  set text(lang: "ar", dir: rtl, font: ("Segoe UI", "Arial"), size: 10.5pt)
  set par(leading: 0.7em, justify: false, spacing: 0.9em)
  set align(right)
  body
})

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
#let n3(v) = str(calc.round(v, digits: 3))
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
#let poly-of(r) = if r.pts.trim() != "" { sec.parse-pts(r.pts) } else {
  let x = float(r.x); let y = float(r.y); let w = float(r.w); let d = float(r.d)
  rect-pts(x - w / 2, y - d / 2, x + w / 2, y + d / 2)
}
#let segs(P) = range(P.len()).map(i => (P.at(i), P.at(calc.rem(i + 1, P.len()))))
#let outer-segs = segs(outline-csv-gf)   // the first floor stands on the ground-floor outline

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

// ================= the two floors as data (room numbers G.. and F.. in CSV order) =================
#let gf-csv = csv("data/rooms_gf.csv", row-type: dictionary).filter(r => r.name != "" and not r.name.starts-with("#"))
#let ff-csv = csv("data/rooms_ff.csv", row-type: dictionary).filter(r => r.name != "" and not r.name.starts-with("#"))
#let short = (
  "Lift (shaft placeholder)": "Lift", "Utility room (shaft inside)": "Utility · shaft", "Family lobby + riwaq": "Riwaq",
  "Living (normal height) · dining": "Dining", "Guest basins (trough · 3 taps)": "Basins (3)",
  "Serving passage (2 doors)": "Serving", "Family powder room (WC · 2 basins)": "Powder room", "Upper gallery (on the west projection)": "Gallery",
  "Kids' room (study + gaming)": "Kids' room", "Suite court (open to the sky)": "Suite court", "Wardrobe niche (bedroom 2)": "niche",
  "Suite WC (closet)": "WC", "Maid store": "store", "Bedroom 1 cupboard": "cupb.", "Air tower": "shaft",
)
#let mk(prefix, rows, extra) = rows.enumerate().map(((i, r)) => (id: prefix + (if i < 9 { "0" } else { "" }) + str(i + 1), name: r.name, kind: kind-of(r.name, r.colour), P: poly-of(r))) + extra
#let tower = fam.fixed.find(f => f.name == "Air tower").pts
#let gf-rooms = mk("G", gf-csv, ((id: "", name: "Air tower", kind: "tower", P: tower),))
#let ff-rooms = mk("F", ff-csv, fam.fixed.map(f => (id: "", name: f.name, kind: if f.name == "Air tower" { "tower" } else { "core" }, P: f.pts)) + (
  (id: "", name: "Courtyard (open to the sky)", kind: "void", P: rect-pts(sec.pj-edge, sec.y-court, sec.x-east, 13.0)),
  (id: "", name: "Double-height living (void)", kind: "void", P: rect-pts(sec.pj-edge, 13.0, sec.x-east, sec.y-living)),
))
#let room-of(rooms, n) = rooms.find(r => r.name == n)
// wall types along the room outlines: open (no wall), balustrade, light partition; everything else 200 mm, outline 250 mm
#let gf-walls = (
  open: (((sec.x-east, 13.0), (sec.x-east, sec.y-living)),),          // living ↔ dining: one room, ceiling change only
  rail: (),
  light: (((10.65, 2.8), (10.65, 7.0)), ((8.95, 1.0), (10.094, 1.0))),   // 100 mm dry block, laundry / maid room; V9.3 the maid bath / store
)
#let ff-walls = (
  open: (((2.75, 7.9), (2.75, 9.2)), ((0, 7.9), (2.75, 7.9)), ((sec.pj-wall, sec.y-living), (sec.pj-edge, sec.y-living)), ((8.95, 5.3), (8.95, 6.5)), ((sec.pj-edge, 13.0), (sec.x-east, 13.0)), ((sec.x-court, sec.y-court), (sec.pj-edge, sec.y-court))),   // V7.1: the family living open to the gallery's north end
  rail: (),   // V7.0: the gallery edge and the family living edge are walls with the steel windows W1 / W2 (enclosure A)ard edge
  light: (((2.25, 0.7), (4.25, 0.7)), ((8.95, 1.0), (10.094, 1.0))),   // linen cupboard front; V9.3 bedroom 1's cupboard
)
#let wall-t(a, b, spec) = {
  let hit(list) = list.any(s => on-seg(a, ..s) and on-seg(b, ..s))
  if hit(spec.open) { 0.0 } else if hit(outer-segs) { 0.25 } else if hit(spec.rail) { 0.06 } else if hit(spec.light) { 0.1 } else { 0.2 }
}
#let half-ts(P, spec) = range(P.len()).map(i => wall-t(P.at(i), P.at(calc.rem(i + 1, P.len())), spec) / 2)
#let clear-poly(r, spec) = offset-poly(r.P, half-ts(r.P, spec))
#let wd(rooms, n) = { let (x0, y0, x1, y1) = bbox(room-of(rooms, n).P); n2(x1 - x0) + " × " + n2(y1 - y0) }
#let clear-wd(rooms, spec, n) = { let (x0, y0, x1, y1) = bbox(clear-poly(room-of(rooms, n), spec)); n2(x1 - x0) + " × " + n2(y1 - y0) }
#let gfa(n) = n2(area(room-of(gf-rooms, n).P))
#let ffa(n) = n2(area(room-of(ff-rooms, n).P))

// ground-floor doors (the studies fix the wash block and the east block; the others are indicative)
#let G(a, b, into, kind) = (a: a, b: b, into: into, kind: kind)
#let gf-doors = (
  G((3.0, 0), (4.0, 0), (0, 1), "hinged"),               // family entry
  G((2.25, 0.9), (2.25, 1.9), (-1, 0), "sliding"),       // lift landing door (the lift is installed at construction, V6.3)
  G((4.25, 0.6), (4.25, 1.6), (1, 0), "hinged"),         // women's majlis (indicative)
  G((2.75, 2.3), (2.75, 6.55), (-1, 0), "open"),         // open stair (flipped 2 Nov 2026): the start strip and the lower flight's balustrade on the riwaq
  G((2.75, 6.7), (2.75, 7.6), (-1, 0), "hinged"),        // the store under the half landing: a low door (head 1.55) onto the riwaq
  G((2.75, 8.2), (2.75, 9.0), (-1, 0), "hinged"),        // utility room (indicative)
  G((4.25, 9.1), (4.25, 10.5), (1, 0), "sliding"),       // courtyard glass door (indicative)
  G((2.75, 10.6), (2.75, 12.7), (-1, 0), "open"),        // hospitality kitchen
  G((2.75, 13.05), (2.75, 14.05), (-1, 0), "hinged"),    // the family powder room (3 Nov 2026: the basins + the WC as one room, a 1.00 m door from the riwaq)
  G((2.75, 16.25), (2.75, 17.15), (-1, 0), "hinged"),    // serving door 1
  G((0.1, 17.5), (1.15, 17.5), (0, -1), "hinged"),       // serving door 2
  G((1.45, 19.25), (2.35, 19.25), (0, -1), "hinged"),    // guest WC, 0.90 m opening (V6.3)
  G((1.25, 19.85), (1.25, 21.4), (1, 0), "open"),        // guest passage ↔ basins
  G((0.1, 21.4), (1.15, 21.4), (0, 1), "open"),          // guest passage ↔ foyer
  G((0, 21.5), (0, 22.9), (1, 0), "double"),             // guest entrance, two leaves
  G((2.75, 22.15), (2.75, 23.95), (1, 0), "open"),       // foyer → men's majlis
  G((4.25, 13.1), (4.25, 14.5), (1, 0), "open"),         // living entrance
  G((9.4, 13.0), (10.5, 13.0), (0, -1), "hinged"),       // kitchen ↔ dining
  G((13.311, 7.2), (13.311, 8.1), (1, 0), "hinged"),     // kitchen service door to the east yard, lockable (owner decision)
  G((9.7, 7.0), (10.55, 7.0), (0, -1), "open"),          // kitchen ↔ laundry
  G((10.65, 2.9), (10.65, 3.9), (1, 0), "hinged"),       // laundry ↔ maid room, 1.00 m opening (V6.3)
  G((10.715, 2.8), (11.415, 2.8), (0, -1), "sliding"),   // maid room ↔ maid bath
  G((9.15, 1.0), (9.75, 1.0), (0, -1), "hinged"),     // V9.3: the maid bath's store
)
#let dw(p) = { let d = gf-doors.find(d => dist(d.a, p) < 1e-6); n2(dist(d.a, d.b)) }   // door width, by its first point
#let gf-windows = (
  ((8.95, 7.3), (8.95, 8.9)), ((13.311, 8.7), (13.311, 10.1)), ((12.308, 3.4), (12.852, 4.4)), ((11.548, 2.0), (11.874, 2.6)),   // studied
  ((5.1, 6.5), (5.6, 6.5)), ((6.0, 6.5), (8.1, 6.5)), ((4.45, 13.0), (5.55, 13.0)), ((6.05, 13.0), (8.75, 13.0)), ((4.25, 6.8), (4.25, 8.9)), ((4.25, 10.7), (4.25, 12.7)),   // courtyard glass (indicative)
  ((0, 6.7), (0, 7.6)), ((2.4, 0), (2.9, 0)),   // the stair's half-landing window (west, small, obscured) and the entrance side light (obscured), flip 2 Nov 2026
  ((5.4, 0), (7.8, 0)), ((3.6, 24), (6.2, 24)), ((7.2, 24), (9.8, 24)), ((10.8, 24), (12.6, 24)), ((13.311, 14.5), (13.311, 17.5)),          // outer (indicative)
)
#let gf-lowwalls = ()   // V6.3: the living's west wall is solid and full height (the TV wall); no low partition
#let gf-furniture = (
  ew.fixtures.map(((a, b, c, d, l)) => (a + 8.95, b, c + 8.95, d, l))
  + gw.fixtures.map(((a, b, c, d, l)) => (a, b + 10.4, c, d + 10.4, l))
  + (
    (5.2, 0.12, 8.1, 0.8, [majlis seating]), (8.15, 0.6, 8.85, 6.0, [majlis seating]), (5.9, 2.4, 7.3, 3.6, [table]),                 // women's majlis (indicative)
    (3.3, 23.2, 12.9, 23.88, [majlis seating]), (3.6, 19.37, 12.9, 20.05, [majlis seating]), (6.0, 21.15, 10.0, 22.0, [table]),       // men's majlis (indicative)
    (7.55, 15.0, 8.45, 18.8, [sofa 3.8 · faces the TV]), (6.4, 16.1, 7.2, 17.7, [table]), (4.35, 14.5, 5.05, 14.75, [pier]), (4.35, 15.05, 4.85, 18.85, [TV cabinet 3.8 × 0.5]), (4.35, 15.95, 4.45, 17.85, [TV 85″]), (4.35, 14.75, 4.75, 15.05, [shelves]), (4.35, 18.85, 4.75, 19.15, [shelves]),   // living (V6.3: the arched TV niche 4.40 × 0.70 on the solid west wall; eye-to-screen ≈ 3.45 m)
    (10.4, 15.1, 12.0, 17.1, [dining table]), (9.85, 15.35, 10.3, 15.8, []), (9.85, 16.4, 10.3, 16.85, []), (12.1, 15.35, 12.55, 15.8, []), (12.1, 16.4, 12.55, 16.85, []),
  )
)
#let ff-doors = (fam.doors + suite.doors).map(d => (a: d.a, b: d.b, into: d.into,
  kind: if not d.open { "hinged" } else if lower(repr(d.label)).contains("sliding") { "sliding" } else { "open" }))
#let ff-windows = fam.windows + suite.windows
#let ff-furniture = fam.furniture + suite.furniture
// the projection's edge beam (orange dashed) on the three columns (dark squares, drawn on the ground floor)
#let beam = (((sec.pj-edge, sec.y-court), (sec.pj-edge, sec.y-living)),)

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
#let draw-floor(rooms, spec, doors, windows, furniture, lowwalls: (), dashed: (), columns: (), acoustic: (), focus: none, labels: true, label-at: (:), shift: (0, 0), mini: false, lsize: 6.8pt) = {
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
    let st = 0.5pt + (if wet { fix-line } else { furn-line })
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
    } else if t.contains("treadmill") {
      rect(S((x0 + 0.12, y0 + 0.12)), S((x1 - 0.35, y1 - 0.12)), stroke: 0.35pt + furn-line)
    }
  }
  // doors and openings, windows
  for d in doors {
    poly(cut(d.a, d.b), fill: floor-c, stroke: none)
    let w = dist(d.a, d.b); let (ix, iy) = d.into
    let u = ((d.b.at(0) - d.a.at(0)) / w, (d.b.at(1) - d.a.at(1)) / w)
    let leaf(h, uu, ww) = {
      let tip = (h.at(0) + ix * ww, h.at(1) + iy * ww)
      line(S(h), S(tip), stroke: 0.9pt + furn-line)
      line(..range(0, 11).map(k => { let th = k * 9deg; S((h.at(0) + ww * (calc.cos(th) * uu.at(0) + calc.sin(th) * ix), h.at(1) + ww * (calc.cos(th) * uu.at(1) + calc.sin(th) * iy))) }), stroke: 0.4pt + furn-line)
    }
    if d.kind == "hinged" { leaf(d.a, u, w) }
    else if d.kind == "double" { leaf(d.a, u, w / 2); leaf(d.b, (-u.at(0), -u.at(1)), w / 2) }
    else if d.kind == "sliding" {
      let o(p, s) = (p.at(0) + ix * s, p.at(1) + iy * s)
      line(S(o(d.a, 0.03)), S(o((d.a.at(0) + u.at(0) * w * 0.6, d.a.at(1) + u.at(1) * w * 0.6), 0.03)), stroke: 1.1pt + furn-line)
      line(S(o((d.a.at(0) + u.at(0) * w * 0.4, d.a.at(1) + u.at(1) * w * 0.4), -0.03)), S(o(d.b, -0.03)), stroke: 1.1pt + furn-line)
    }
  }
  for (a, b) in windows {
    poly(cut(a, b, half: 0.13), fill: white, stroke: 0.4pt + fix-line)
    line(S(a), S(b), stroke: 0.4pt + fix-line)
  }
  for (a, b) in dashed { line(S(a), S(b), stroke: (paint: orange, thickness: 1pt, dash: "dashed")) }
  for (a, b) in acoustic { line(S(a), S(b), stroke: 2.6pt + rgb("#b5452f")) }
  for c in columns { rect(S((c.at(0) - sec.col-half, c.at(1) - sec.col-half)), S((c.at(0) + sec.col-half, c.at(1) + sec.col-half)), fill: dark, stroke: none) }
  if labels {
    for r in rooms.filter(r => infocus(r) and (r.kind != "core" or r.name.starts-with("Stair") or r.name.starts-with("Utility"))) {
      let cp = clear-poly(r, spec)
      let c = label-at.at(r.name, default: pcentroid(cp))
      let small = area(r.P) < 4
      let nm = short.at(r.name, default: r.name)
      content(S(c), box(align(center, text(if small { lsize * 0.8 } else { lsize }, fill: dark)[#if r.id != "" [*#r.id*\ ]#nm#if not small and r.kind != "void" [\ #text(fill: soft)[#n2(area(r.P)) m²]]])))
    }
  }
}
// dimension line between a and b (CSV), drawn off by the vector o
#let dim(a, b, o, label) = {
  import cetz.draw: *
  let A = (a.at(0) + o.at(0), a.at(1) + o.at(1)); let B = (b.at(0) + o.at(0), b.at(1) + o.at(1))
  line(q(a), q(A), stroke: 0.3pt + soft); line(q(b), q(B), stroke: 0.3pt + soft)
  line(q(A), q(B), stroke: 0.6pt + dark)
  for p in (A, B) { line(q((p.at(0) - 0.18, p.at(1) + 0.18)), q((p.at(0) + 0.18, p.at(1) - 0.18)), stroke: 0.7pt + dark) }
  let m = ((A.at(0) + B.at(0)) / 2, (A.at(1) + B.at(1)) / 2)
  let vertical = calc.abs(a.at(0) - b.at(0)) < 1e-6
  content(q(m), angle: if vertical { 90deg } else { 0deg }, anchor: "south", padding: 0.08, text(7pt, fill: dark, label))
}
#let north-arrow(p) = {
  import cetz.draw: *
  line(q(p), (p.at(0) + 1.6 * north.at(0), -p.at(1) + 1.6 * north.at(1)), stroke: 1pt + accent, mark: (end: "stealth", fill: accent, scale: 0.7))
  content((p.at(0) + 2.05 * north.at(0), -p.at(1) + 2.05 * north.at(1)), text(8pt, weight: "bold", fill: accent)[TRUE N])
}
#let scale-bar(p, m: 5) = {
  import cetz.draw: *
  for k in range(m) { rect(q((p.at(0) + k, p.at(1))), q((p.at(0) + k + 1, p.at(1) + 0.18)), fill: if calc.even(k) { dark } else { white }, stroke: 0.4pt + dark) }
  content(q((p.at(0), p.at(1) + 0.55)), text(7pt)[0]); content(q((p.at(0) + m, p.at(1) + 0.55)), text(7pt)[#m m])
}
#let kpi(v, l) = box(fill: rgb("#e4eedf"), inset: 9pt, radius: 2pt, width: 100%)[#text(16pt, weight: "bold", fill: accent)[#v]\ #text(8pt, fill: soft)[#l]]

// ================= numbers =================
#let footprint = area(offset-poly(outline-csv-gf, (-sec.outer-half,) * outline-csv-gf.len()))
#let gf-real = gf-rooms.filter(r => r.kind != "court" and r.name != "Air tower")
#let ff-real = ff-rooms.filter(r => r.id != "" and r.kind != "open")
#let gf-area = gf-real.map(r => area(r.P)).sum()
#let ff-area = ff-real.map(r => area(r.P)).sum()
#let suite-names = ("Suite lobby", "Suite bath", "Suite WC (closet)", "Suite dressing", "Suite bedroom")
#let suite-area = ff-rooms.filter(r => r.name in suite-names).map(r => area(r.P)).sum()
#let suite-bath = area(room-of(ff-rooms, "Suite bath").P) + area(room-of(ff-rooms, "Suite WC (closet)").P)
#let court-r = gf-rooms.find(r => r.kind == "court")
#let trunk = 0.265                                                       // palm trunk radius (base.typ draws the same)
#let palm-gap(T) = calc.min(..edges(outline-gf).map(e => seg-dist(T, ..e))) - sec.outer-half - trunk   // outer wall face to the trunk face
#let court-clear = clear-wd(gf-rooms, gf-walls, court-r.name)
#let (gx0, gy0, gx1, gy1) = bbox(outline-csv-gf)
// the values the decisions log and the open items quote ({key} in data/decisions.csv and data/open_items.csv)
#let vals = (
  "m-gap": n3(sec.pj.m-gap), "env-gap": n2(env-gap), "depth": n2(sec.pj.depth), "col-x": n2(sec.pj.col-x), "spans": sec.pj.spans.map(n2).join(" and "),
  "sky": n3(sec.pj.sky), "ff-level": sec.f2(sec.ff-level), "cant-wall": n2(sec.split.cant-wall), "split-m-gap": n2(sec.split.m-gap),
  "tm-clear": n2(suite.tm-clear), "tm-side": n2(suite.tm-side), "arm-x": n3(suite.arm-x0), "court": n2(area(room-of(ff-rooms, "Suite court (open to the sky)").P)), "winter": sec.pc(sec.light.winter), "maid-clear": n2(area(clear-poly(room-of(gf-rooms, "Maid room"), gf-walls))),
)
#let fill-in(s) = { let t = s; for (k, v) in vals { t = t.replace("{" + k + "}", v) }; t }
#let ff-label-at = (
  "Upper gallery (on the west projection)": (sec.pj-edge - 0.68, 12.2), "Bedroom 3": (1.725, 17.6), "Suite bedroom": (11.4, 16.6), "Suite bath": (11.3, 8.9),
  "Bedroom 1": (11.0, 4.6), "Bedroom 2 bath (en-suite)": (2.9, 10.1), "Family WC (gallery)": (1.4, 8.55), "Owner's office": (11.65, 22.4), "Gym": (2.1, 21.4), "Suite court (open to the sky)": (7.4, 22.1),
  "Kids' room (study + gaming)": (5.6, 2.2), "Family living": (5.3, 5.9), "Courtyard (open to the sky)": (7.3, 9.75), "Double-height living (void)": (7.3, 16.0),
)
#let gf-label-at = ("Family lobby + riwaq": (3.5, 4.0), "Maid room": (11.9, 5.6), "Maid bath": (10.25, 2.35), "Maid store": (9.3, 0.55), "Living (double height)": (6.6, 14.2), "Living (normal height) · dining": (11.1, 14.0), "Men's majlis": (8.0, 22.6), "Women's majlis": (6.6, 4.6), "Kitchen": (11.1, 12.2))
#let plan-len = 0.8cm
#let okit = yaml("3d/params.yaml").outdoor_kitchen   // V8.1: the outdoor kitchen (the counter at the east wall, the grill and tannour apart), drawn on the site and the ground floor
#let draw-okit(shift: (0, 0), label: true) = {
  import cetz.draw: *
  for (b, l) in ((okit.counter, [outdoor counter + sink]), (okit.grill, [grill + tannour])) {
    rect(q((b.at(0) + shift.at(0), b.at(1) + shift.at(1))), q((b.at(2) + shift.at(0), b.at(3) + shift.at(1))), fill: rgb("#ead9b8"), stroke: 0.6pt + dark)
    if label { content(q((b.at(2) + shift.at(0) + 0.3, (b.at(1) + b.at(3)) / 2 + shift.at(1))), anchor: "west", text(6.5pt, fill: dark, l)) }
  }
}

// ===================================================================================== SHEET 01 · site
#sheet-head([The house on its site · the site and services plan], [Site option Z4 | shift (#n2(shift.at(0)), #n3(shift.at(1))) m, rotation 0° | the first floor stands on the same outline | 250 mm outer / 200 mm inner walls | V9.1: the final site position, B1 6.00 m from M1 (the owner's car test); the site plan `studies/site_plan.typ` and the whole farm `studies/whole_farm.typ` (the existing buildings approximate, to be measured)])
#grid(columns: (auto, 1fr), column-gutter: 20pt,
  cetz.canvas(length: 0.52cm, {
    import cetz.draw: *
    line(..land.map(q), close: true, fill: rgb("#eef3e6"), stroke: 0.7pt + accent)
    line(..env.map(q), close: true, fill: rgb("#e3eedb"), stroke: (paint: accent, dash: "dashed", thickness: 0.7pt))
    line(..drv.map(q), close: true, fill: rgb("#d6e2ea"), stroke: 0.6pt + rgb("#2f5f8a"))
    line(..lane.map(q), stroke: 1.4pt + dark); line(..nwall.map(q), stroke: 1.4pt + dark)
    // V8.2 · the site plan (study): the garden, the parking bay, the paths, the garden wall, the hedge, the yard screen and the gas cabinet, the foul chambers and the rain chamber
    line(..sp.garden.map(q), close: true, fill: rgb("#d5e8c8"), stroke: (paint: rgb("#2f7a3f"), thickness: 0.6pt, dash: "dashed"))
    rect(q((sp.park-opt.at(0), sp.park-opt.at(1))), q((sp.park-opt.at(2), sp.park-opt.at(3))), fill: rgb("#d6e2ee"), stroke: 0.6pt + rgb("#2f5f8a"))
    line(..sp.path-family.map(q), stroke: (paint: rgb("#b5452f"), thickness: 1.2pt, dash: "dashed"), mark: (end: "stealth", fill: rgb("#b5452f"), scale: 0.5))
    line(..sp.path-guest.map(q), stroke: 2.2pt + rgb("#c9a86a"), mark: (end: "stealth", fill: rgb("#c9a86a"), scale: 0.5))
    line(..sp.path-workers.map(q), stroke: (paint: luma(110), thickness: 1pt, dash: "dash-dotted"), mark: (end: "stealth", fill: luma(110), scale: 0.5))
    line(q(sp.lowwall.at(0)), q(sp.lowwall.at(1)), stroke: 2.6pt + rgb("#c9a86a"))
    line(q(sp.hedge.at(0)), q(sp.hedge.at(1)), stroke: 2.6pt + rgb("#2f7a3f"))
    line(q(sp.screen.at(0)), q(sp.screen.at(1)), stroke: 2pt + dark)
    rect(q((sp.gas-box.at(0), sp.gas-box.at(1))), q((sp.gas-box.at(2), sp.gas-box.at(3))), fill: rgb("#ffe08a"), stroke: 0.6pt + rgb("#b5452f"))
    for P in sp.sewer { line(..P.map(q), stroke: (paint: rgb("#8a5a2b"), thickness: 0.9pt, dash: "dashed")) }
    for c in (sp.manhole-e, sp.ch-ne, sp.ch-n, sp.ch-w, sp.ch-gate) { circle(q(c), radius: 0.3, fill: white, stroke: 0.7pt + rgb("#8a5a2b")) }
    circle(q(sp.rain-ch), radius: 0.3, fill: white, stroke: 0.7pt + rgb("#1f7a99"))
    content(q((7.7, 3.0)), text(5.5pt, fill: rgb("#2f5f8a"))[family car (kept)])
    content(q((9.0, 34.0)), text(7pt, fill: rgb("#2f7a3f"))[FAMILY GARDEN])
    content(q((-2.0, 30.0)), angle: 90deg, text(6pt, fill: rgb("#8a5a2b"))[guest path])
    content(q((18.5, 18.4)), text(5.5pt, fill: rgb("#2f7a3f"))[hedge 1.8 m])
    content(q((17.0, 13.8)), anchor: "west", text(5.5pt, fill: rgb("#b5452f"))[LPG])
    content(q((-2.6, 2.4)), anchor: "east", text(5.5pt, fill: rgb("#8a5a2b"))[→ septic (outside the wall near C1)])
    draw-floor(gf-rooms, gf-walls, (), (), (), shift: shift, labels: false, mini: true)
    for (T, n) in ((T1, [P1]), (T2, [P2])) {
      circle(q(T), radius: 1.0, fill: rgb("#cfdfc3"), stroke: 0.5pt + accent)
      circle(q(T), radius: 0.27, fill: accent, stroke: none)
      content(q((T.at(0) + 1.5, T.at(1))), anchor: "west", text(8pt, fill: accent, n))
    }
    for (p, n) in Ms.zip(([M1], [M2], [M3], [M4])) { circle(q(p), radius: 0.2, fill: accent, stroke: none); content(q((p.at(0) - 0.7, p.at(1))), anchor: "east", text(7pt, fill: rgb("#b5452f"), n)) }
    content(q((-2.0, 18)), angle: 90deg, text(8pt, fill: rgb("#2f5f8a"))[DRIVEWAY])
    content(q((3.5, -2.2)), text(8pt, weight: "bold")[NORTH STREET / GATE])
    content(q((7.6, 15.7)), text(8pt, weight: "bold", fill: white)[HOUSE])
    draw-okit(shift: shift, label: false)
    content(q((17.6 + shift.at(0), 24.9 + shift.at(1))), anchor: "west", text(7pt, fill: dark)[outdoor kitchen])
    north-arrow((22.0, 2.0))
    scale-bar((0, 41.0), m: 10)
  }),
  [
    #grid(columns: (1fr, 1fr, 1fr), column-gutter: 8pt, row-gutter: 8pt,
      kpi[#n2(footprint) m²][outside footprint (incl. courtyard)], kpi[#n2(gf-area) m²][ground floor rooms (axes)], kpi[#n2(ff-area) m²][first floor rooms (axes)],
      kpi[#court-clear m][courtyard, clear · sky #n3(sec.pj.sky) m axes above], kpi[#n2(suite-area) m²][master suite (indoors)], kpi[#n3(sec.pj.m-gap) m][west face to the M line (both floors)],
      kpi[#n2(env-gap) / 0.42 m][nearest wall face to the setback: deed line / wall as built (field 2.30 m)], kpi[#n2(palm-gap(T1)) / #n2(palm-gap(T2)) m][palms P1 / P2 to the outer walls], kpi[#n2(sec.ff-level) m][floor to floor (to confirm)],
    )
    #v(6pt)
    #en[
      *The house.* A compact courtyard house on site option Z4: a pentagon #n3(gx1 - gx0) × #n2(gy1 - gy0) m on wall centre lines, its north-east corner cut parallel to the lane, square to the M line and pushed as far north as the setbacks allow. The courtyard is the cool heart; the rooms look in, not out. A west service band and an east service block frame the middle band (women's majlis, courtyard, double-height living); the men's majlis takes the full width on the south.

      *First floor.* The family part on the north and west around the courtyard; the south wing (V8.0): the gym on the west, a large suite court open to the sky, the owner's office on the east (reached from the court only), and the master suite. The gallery runs on a #n2(sec.pj.depth) m projection over the courtyard and the double-height void, on an edge beam and #sec.pj.columns columns.

      *Roof access (V8.1):* a maintenance ladder in a recess of the gym's east wall in the suite court, behind a locked walnut panel; the internal stair stops at the first floor; office visitors are met in the men's majlis. One entry to the site: the farm's 4 m main gate.

      *Site position (V9.1, final):* set out on site (day 1, the diagonals exact); then, after the owner's car test (a full forward turn from the gate into the north strip), B1 exactly 6.00 m from M1; the cut wall shortened again (6.08 m): 0.91 m from the deed setback, 0.42 m from the wall as built (field 2.30 m; the official survey confirms). The levels (the floor, the plinth, the entrance steps or ramps, the garden, the sewer falls) are set from the survey. *The farm (owner; approximate, to be measured):* the old house with its majlis west of the driveway, its covered parking and the ground tank south of it near peg R, the septic outside the north wall near C1 serving both houses.

      *Site plan (a study):* one 4 m gate; one family car in the north strip (one forward turn from the gate, drawn on the site plan); the guest stone path along the driveway; the service yard reached along the farm's wall; the family garden on the south only; rain separate; PV without a generator.
    ]
    #ar[
      #ah[المنزل]
      منزل فناء مدمج على خيار الموقع Z4: مخمس #n3(gx1 - gx0) × #n2(gy1 - gy0) م على محاور الجدران، ركنه الشمالي الشرقي مقطوع موازيا للزقاق، متعامد مع خط M ومدفوع شمالا قدر ما تسمح الارتدادات. الفناء هو القلب البارد، والغرف تطل إلى الداخل لا إلى الخارج.
      #ah[الدور الأول]
      جزء العائلة شمالا وغربا حول الفناء، والجناح الجنوبي (V8.0): النادي غربا وفناء الجناح الكبير المفتوح للسماء ومكتب المالك شرقا، ثم جناح النوم الرئيسي. الممر العلوي على بروز #n2(sec.pj.depth) م فوق الفناء والصالة، على جسر حافة و#sec.pj.columns أعمدة.
      #ah[الوصول إلى السطح (V8.1)]
      سلم صيانة في تجويف بجدار النادي داخل فناء الجناح خلف لوح خشبي مقفل؛ الدرج الداخلي يتوقف عند الدور الأول؛ زوار المكتب يُستقبلون في مجلس الرجال. مدخل واحد للموقع: البوابة الرئيسية للمزرعة بعرض 4 م.
      #ah[موضع البيت والمزرعة (V9.1)]
      وُقّع البيت في الموقع ثم أُزيح جنوبا حتى صار الركن B1 على 6.00 م من M1 (تجربة سيارة المالك: دوران كامل إلى الشريط الشمالي دون مناورة) وقُصّر جدار القطع مرة أخرى: الهامش 0.91 م من خط الصك و0.42 م من الجدار القائم. المناسيب تُحدَّد من الرفع المساحي الرسمي. البيت القديم غرب الممر، ومظلته والخزان جنوبه، وخزان الصرف قرب C1 للبيتين (تقريبي، يقاس). بوابة واحدة؛ ممر الضيوف؛ حديقة العائلة جنوبا.
    ]
  ],
)

// ===================================================================================== SHEET 02 · ground floor
#pagebreak()
#sheet-head([Ground floor], [Room numbers G.. | dark squares = the #sec.pj.columns columns, orange dashed = the first-floor edge beam above (a colonnade along the courtyard) | doors and windows outside the two studied blocks are indicative])
#grid(columns: (auto, 1fr), column-gutter: 18pt,
  cetz.canvas(length: plan-len, {
    import cetz.draw: *
    draw-floor(gf-rooms, gf-walls, gf-doors, gf-windows, gf-furniture, lowwalls: gf-lowwalls, dashed: beam, columns: sec.columns, label-at: gf-label-at)
    content(q((2.3, 7.15)), text(5.5pt, fill: soft)[store])   // V9.2: the low store door under the stair's half landing
    dim((gx0 - sec.outer-half, 0), (gx1 + sec.outer-half, 0), (0, -1.0), [#n3(gx1 - gx0 + 2 * sec.outer-half) m outside])
    dim((0, gy0 - sec.outer-half), (0, gy1 + sec.outer-half), (-1.6, 0), [#n2(gy1 - gy0 + 2 * sec.outer-half) m outside])
    let cc = bbox(clear-poly(court-r, gf-walls))
    dim((cc.at(0), 7.2), (cc.at(2), 7.2), (0, 0), [#n2(cc.at(2) - cc.at(0)) m clear])
    rect(q((5.925, 7.1)), q((8.85, 12.3)), stroke: (paint: orange, thickness: 0.7pt, dash: "dashed")); content(q((6.9, 12.0)), text(6.5pt, fill: orange)[seating · level])
    rect(q((7.55, 7.1)), q((8.85, 9.5)), fill: rgb("#cfe3ee"), stroke: 0.5pt + dark); content(q((8.2, 8.3)), text(6pt)[water\ tree])
    line(q((8.8, 9.77)), q((8.8, 11.23)), stroke: 2.4pt + dark); content(q((8.55, 10.5)), angle: 90deg, text(5.5pt)[TV])
    north-arrow((17.4, 1.0))
    scale-bar((0, 25.6))
  }),
  [
    #en[
      *Middle band:* the women's majlis #wd(gf-rooms, "Women's majlis") m, the courtyard #wd(gf-rooms, "Courtyard") m (#court-clear m clear, open to the sky) and the living room in two heights: double height on the courtyard, normal height with the dining to the east. The living is entered from the riwaq through a #dw((4.25, 13.1)) m arched opening; its west wall is solid and full height with the arched TV niche (V6.3).

      *West band:* the lift (installed at construction, V6.3), the open stair (flipped, V8.2: the lower flight rises south off the lobby behind a black-bar balustrade; a full-height coat cupboard in the west half of its start strip, the store under the half landing at the south end), the utility room with the shaft, then the west wash block (sheet 06). The riwaq #wd(gf-rooms, "Family lobby + riwaq") m runs along the courtyard.

      *East block* (sheet 06): kitchen, laundry, maid room and maid bath, the air tower in the cut corner. *Men's majlis* #wd(gf-rooms, "Men's majlis") m, entered only from the guest foyer. No east duct. *Colonnade:* #sec.pj.columns columns on x #n2(sec.pj.col-x) under the first-floor edge beam, in the women's majlis south wall, the courtyard / living glass and the living's south wall, with a three-arch arcade in the courtyard bay (V7.1).

      *Courtyard (revised V8.3):* the whole floor level (no step), modern movable sofas and armchairs for 4–6 with a low table facing the outdoor TV in its semicircular honey-stone surround on the kitchen wall (the malqaf grille below it); the water + tree enclosure on the kitchen wall in front of the sink window (y 7.3–8.9): the tree north, a raised water trough south, the view from the sink; gentle falls to linear drains on the rain system; the north side in front of the women's majlis glass free; no pergola. *Outside (V8.3):* the outdoor counter and sink next to the kitchen service door (canopy optional), the grill and tannour a little apart in the yard's south part (≥ 3 m from every opening, downwind); the yard screen, the gas cabinet at its north end, the bins north of the door.
    ]
    #ar[
      #ah[الوسط: مجلس النساء والفناء والصالة]
      الفناء #wd(gf-rooms, "Courtyard") م على المحاور و#court-clear م صافيا مفتوح للسماء. الصالة بسقفين: ارتفاع مزدوج على الفناء وارتفاع عادي مع الطعام شرقا، وتُدخل من الرواق عبر فتحة مقوسة #dw((4.25, 13.1)) م؛ جدارها الغربي مصمت كامل الارتفاع مع كوة التلفاز المقوسة (V6.3).
      #ah[الشريط الغربي والرواق]
      المصعد والدرج المفتوح (معكوس الاتجاه في V8.2: الجزء السفلي يصعد جنوبا من الردهة خلف درابزين أسود، ودولاب المعاطف في النصف الغربي من شريط البداية) وغرفة الخدمات مع الشفت ثم كتلة المغاسل (اللوحة 06). الرواق #wd(gf-rooms, "Family lobby + riwaq") م على طول الفناء.
      #ah[الكتلة الشرقية ومجلس الرجال]
      المطبخ والغسيل وغرفة الخادمة وحمامها وبرج الهواء (اللوحة 06). مجلس الرجال #wd(gf-rooms, "Men's majlis") م لا يدخل إلا من بهو الضيوف. لا شفت شرقي.
      #ah[الأعمدة والرواق]
      #sec.pj.columns أعمدة على x #n2(sec.pj.col-x) (في جدار مجلس النساء الجنوبي، وبين زجاج الفناء والصالة، وفي جدار الصالة الجنوبي) تحمل جسر حافة البروز في الدور الأول (الخط البرتقالي المتقطع)، فيصبح على حافة الفناء رواق بأعمدة وثلاثة أقواس.
      #ah[الفناء (معدل V8.3)]
      أرضية مستوية بلا درجة، أثاث متحرك عصري لأربعة إلى ستة مع طاولة منخفضة أمام التلفاز الخارجي في إطاره الحجري على جدار المطبخ وتحته فتحة الملقف، والنافورة والشجرة على جدار المطبخ أمام نافذة المغسلة، ومصارف خطية إلى نظام الأمطار؛ والمطبخ الخارجي بجوار باب الخدمة والشواية على بعد ≥ 3 م من الفتحات. وض ماء وشجرة في الطرف الشمالي، بلا عريشة. نافذة حوض المطبخ عند y 7.3–8.9.
    ]
  ],
)

// ===================================================================================== SHEET 03 · first floor
#pagebreak()
#sheet-head([First floor], [Room numbers F.. | west projection #n2(sec.pj.depth) m over the courtyard and the void, edge beam (orange dashed) on #sec.pj.columns columns | hatched = open below / to the sky | furniture from the two first-floor studies])
#grid(columns: (auto, 1fr), column-gutter: 18pt,
  cetz.canvas(length: plan-len, {
    import cetz.draw: *
    draw-floor(ff-rooms, ff-walls, ff-doors, ff-windows, ff-furniture, dashed: beam, label-at: ff-label-at)
    dim((gx0 - sec.outer-half, 0), (gx1 + sec.outer-half, 0), (0, -1.0), [#n3(gx1 - gx0 + 2 * sec.outer-half) m outside])
    dim((0, gy0 - sec.outer-half), (0, gy1 + sec.outer-half), (-1.6, 0), [#n2(gy1 - gy0 + 2 * sec.outer-half) m outside])
    dim((sec.pj-edge, 11.6), (sec.x-east, 11.6), (0, 0), [#n3(sec.pj.sky) m sky])
    dim((sec.pj-wall, 18.6), (sec.pj-edge, 18.6), (0, 0), [#n2(sec.pj.gallery)])
    dim((sec.x-court, 6.0), (sec.pj-edge, 6.0), (0, 0), [#n2(sec.pj.depth)])
    north-arrow((17.4, 1.0))
    scale-bar((0, 25.6))
  }),
  [
    #en[
      *West projection:* #n2(sec.pj.depth) m over the courtyard and the double-height void, on an edge beam on x #n2(sec.pj.col-x) and #sec.pj.columns columns; the first-floor west wall stands on the GF west wall. Gallery #n2(sec.pj.gallery) m (≈ #n3(sec.pj.gallery-clear) m clear), west rooms #n2(sec.pj.room) m (≈ #n3(sec.pj.room-clear) m clear), courtyard sky #n3(sec.pj.sky) m (≈ #n3(sec.pj.sky-clear) m clear).

      *North band:* kids' room #ffa("Kids' room (study + gaming)") m² and family living #ffa("Family living") m² on the courtyard edge; bedroom 1 #ffa("Bedroom 1") m², the young children's room next to the master suite (no en-suite: they are bathed in the suite's bathroom; owner, V9.0).

      *West band:* the family WC (WC + basin) off the gallery, bedroom 2 with its en-suite, bedroom 3 with its own bath; every door from the gallery.

      *South wing v2 (V8.0):* the gym on the west band #ffa("Gym") m² (the treadmill with its manufacturer zone), the suite court #ffa("Suite court (open to the sky)") m² open to the sky from the gym to the office, the owner's office #ffa("Owner's office") m² on the east (no door to the bedroom; reached from the court only); master suite #n2(suite-area) m².
    ]
    #ar[
      #ah[البروز الغربي والممر العلوي]
      بروز #n2(sec.pj.depth) م فوق الفناء وفراغ الصالة على جسر حافة على x #n2(sec.pj.col-x) و#sec.pj.columns أعمدة، والجدار الغربي للدور الأول فوق الجدار الغربي للأرضي. الممر #n2(sec.pj.gallery) م (نحو #n3(sec.pj.gallery-clear) م صافي)، والغرف #n2(sec.pj.room) م (نحو #n3(sec.pj.room-clear) م صافي)، والسماء فوق الفناء #n3(sec.pj.sky) م.
      #ah[الشريط الشمالي]
      غرفة الأطفال #ffa("Kids' room (study + gaming)") م² وجلسة العائلة #ffa("Family living") م² على حافة الفناء، وغرفة النوم 1 #ffa("Bedroom 1") م² للأطفال الصغار بجوار الجناح (بلا حمام خاص: يستحمون في حمام الجناح).
      #ah[الشريط الغربي]
      دورة مياه العائلة (مرحاض ومغسلة) من الممر، وغرفة النوم 2 مع حمامها، وغرفة النوم 3 مع حمامها؛ كل الأبواب من الممر ولا باب على بسطة الدرج.
      #ah[الجنوب والشرق]
      النادي غربا #ffa("Gym") م²، وفناء الجناح #ffa("Suite court (open to the sky)") م² المفتوح للسماء من النادي إلى المكتب، ومكتب المالك شرقا #ffa("Owner's office") م² بلا باب إلى غرفة النوم (يُدخل إليه من فناء الجناح فقط)، وجناح النوم الرئيسي #n2(suite-area) م² بمدخل من وصلة العائلة.
    ]
  ],
)

// ===================================================================================== SHEET 04 · first floor family part
#pagebreak()
#sheet-head([First floor / the family part], [Kids' room, family living, bedrooms 1–3, family bath, gallery on the west projection | furnished test from studies/ff_family.typ])
#let fam-focus = ("Upper gallery (on the west projection)", "Linen cupboard", "Bedroom 1 cupboard", "Bedroom 2 bath (en-suite)", "Family WC (gallery)", "Bedroom 2", "Bedroom 3 bath", "Bedroom 3", "Kids' room (study + gaming)", "Family living", "Family link", "Bedroom 1", "Stair (arrives at its south end)", "Lift shaft", "West shaft", "Air tower", "Courtyard (open to the sky)", "Double-height living (void)")
#grid(columns: (auto, 1fr), column-gutter: 18pt,
  cetz.canvas(length: 1.0cm, {
    import cetz.draw: *
    draw-floor(ff-rooms.filter(r => bbox(r.P).at(1) < 19.2), ff-walls, ff-doors.filter(d => d.a.at(1) < 19.2), ff-windows.filter(w => w.at(0).at(1) < 19.2), ff-furniture.filter(f => f.at(1) < 19.2), dashed: beam, focus: fam-focus, label-at: ff-label-at)
    let b2 = bbox(room-of(ff-rooms, "Bedroom 2").P)
    dim((b2.at(0), 11.0), (b2.at(2), 11.0), (0, 0.45), [#n2(b2.at(2) - b2.at(0)) m axes · ≈ #n3(sec.pj.room-clear) m clear])
    dim((0, 0), (0, sec.y-living), (-0.8, 0), [#n2(sec.y-living) m])
    scale-bar((0, 20.0))
  }),
  [
    #en[
      *Kids' room* #wd(ff-rooms, "Kids' room (study + gaming)") m: two study desks and a PC desk under the north window, a gaming corner; solid door from the gallery. *Family living* #wd(ff-rooms, "Family living") m on the courtyard edge: a view, not a path.

      *Bedroom 2* #wd(ff-rooms, "Bedroom 2") m with its own bath beside the shaft (3 Nov 2026; the family WC next to it, from the gallery); *bedroom 3* #ffa("Bedroom 3") m² with its own bath #wd(ff-rooms, "Bedroom 3 bath") m over the GF family WC; *bedroom 1* #ffa("Bedroom 1") m², one room without a bath.

      *Bedroom 2's bath* #wd(ff-rooms, "Bedroom 2 bath (en-suite)") m and the *family WC* #wd(ff-rooms, "Family WC (gallery)") m by the west shaft (3 Nov 2026: the F-b bath split; every fixture on one service wall into the shaft), the family WC's door from the gallery, for bedroom 1, the family living and the kids' room.
    ]
    #ar[
      #ah[غرفة الأطفال: دراسة وألعاب]
      #wd(ff-rooms, "Kids' room (study + gaming)") م: مكتبا دراسة ومكتب كمبيوتر تحت النافذة الشمالية وركن ألعاب، وباب مصمت من الممر. يمكن أن تصبح غرفة نوم رابعة لاحقا.
      #ah[جلسة العائلة]
      #wd(ff-rooms, "Family living") م = #ffa("Family living") م² على حافة الفناء: إطلالة لا ممر، والطريق إلى جناح الوالدين خلف الكنبة.
      #ah[غرف النوم]
      النوم 2: #wd(ff-rooms, "Bedroom 2") م بتجويف دولاب بجانب الشفت. النوم 3: #ffa("Bedroom 3") م² مع حمام خاص #wd(ff-rooms, "Bedroom 3 bath") م فوق دورة العائلة. النوم 1: #ffa("Bedroom 1") م² غرفة واحدة بلا حمام.
      #ah[حمام العائلة]
      حمام غرفة النوم 2 #wd(ff-rooms, "Bedroom 2 bath (en-suite)") م ودورة المياه العائلية #wd(ff-rooms, "Family WC (gallery)") م بجوار الشفت الغربي (3 نوفمبر 2026)، وباب دورة المياه من الممر.
      #ah[التخزين]
      دولاب البياضات في نهاية الممر الشمالية (#wd(ff-rooms, "Linen cupboard") م). الدواليب المدمجة صناديق نجارة مثبتة بين الجدارين.
    ]
  ],
)

// ===================================================================================== SHEET 05 · the south wing v2 and the master suite (V8.0)
#pagebreak()
#sheet-head([First floor / the south wing and the master suite], [South wing v2 (owner, V8.0): the gym on the west band, the suite court from the gym to the office, the office on the east | furnished test from studies/ff_suite.typ | orange = the treadmill's clear zones, red = the double wall to bedroom 3 | the three court doors on a 1.2 m strip])
#let l-focus = ("Owner's office", "Gym", "Suite court (open to the sky)", "Suite lobby", "Suite bath", "Suite WC (closet)", "Suite dressing", "Suite bedroom")
#grid(columns: (auto, 1fr), column-gutter: 18pt,
  cetz.canvas(length: 0.82cm, {
    import cetz.draw: *
    draw-floor(ff-rooms.filter(r => bbox(r.P).at(3) > 6.4), ff-walls, ff-doors.filter(d => d.a.at(1) >= 6.4), ff-windows.filter(w => w.at(0).at(1) >= 6.4), ff-furniture.filter(f => f.at(3) > 6.5), acoustic: (suite.acoustic-wall,), focus: l-focus, label-at: ff-label-at)
    for (n, z, w) in suite.tm-zones { rect(q((z.at(0), z.at(1))), q((z.at(2), z.at(3))), fill: orange.transparentize(80%), stroke: (paint: orange, thickness: 0.5pt, dash: "dotted")) }
    rect(q((suite.court-strip.at(0), suite.court-strip.at(1))), q((suite.court-strip.at(2), suite.court-strip.at(3))), stroke: (paint: accent, thickness: 0.6pt, dash: "dotted"))
    line(q((4.25, 24.3)), q((10.0, 24.3)), stroke: (paint: rgb("#8a5a2b"), thickness: 1pt, dash: "dashed")); content(q((7.1, 24.75)), text(7pt, fill: rgb("#8a5a2b"))[south side: mashrabiya PROPOSED (owner's choice)])
    rect(q((4.35, 20.65)), q((4.70, 21.95)), fill: rgb("#c9a86a"), stroke: 0.5pt + dark); content(q((4.1, 21.3)), anchor: "east", text(6pt, fill: rgb("#8a5a2b"))[ladder ↑])
    dim((4.25, 24.0), (10.0, 24.0), (0, 1.6), [#n2(10.0 - 4.25) m · the suite court])
    dim((13.311, 6.5), (13.311, sec.y-living), (3.4, 0), [#n2(sec.y-living - 6.5) m · master suite #n2(suite-area) m²])
    scale-bar((0, 26.6))
  }),
  [
    #en[
      *Master suite* #n2(suite-area) m² (unchanged): a lobby from the family link opens to the bath, the dressing and the bedroom (the bed is not seen from the suite door). Luxury bath #n2(suite-bath) m²; walk-in dressing #wd(ff-rooms, "Suite dressing") m; bedroom #ffa("Suite bedroom") m². *No door to the office.* Its court door (sliding glass) opens onto an entry zone formed by a full-height wardrobe: the sight-line test (doors open, from the gym and office doors and from the court seating) keeps the bed out of view.

      *Suite court* #ffa("Suite court (open to the sky)") m² on axes (≈ #n2(suite.court-clear-area) m² clear), open to the sky, from the gym to the office: the three court doors (bedroom, gym, office) on a 1.2 m strip along its north edge, the seating (a sofa, two armchairs, a table, plants) in the south part; the floor falls south to a box gutter with an overflow, linear drains at the near-flush doors. Its south side is the facade frame: a 1.10 m base under R8, the cornice and the parapet; the infill is the owner's choice (a mashrabiya screen recommended). The clerestory windows of the living get the winter noon sun on #sec.pc(sec.light.winter) of their height.

      *Gym* #ffa("Gym") m² on the west band (inside the column frame), with an entrance nib at the gallery end: the treadmill along the length on the stiff 2.75 m bay (#n2(suite.tm-side) m clear each side, #n2(suite.tm-clear) m behind), a power rack, kettlebells, a bike, the pilates mat, a fixed TV; windows west and south; a double wall to bedroom 3 (Rw ≈ 55 dB).

      *Owner's office* #wd(ff-rooms, "Owner's office") m (east): for the owner only, reached from the suite court (bedroom → court → office; the family gym → court → office); visitors are met in the men's majlis; a simple door, an east window, a fixed TV.

      *Roof ladder (V8.1):* a manufactured vertical ladder in a 0.90 × 0.30 recess of a honey-stone pilaster on the gym's east wall (north end, off the door strip and the seating), behind a locked walnut-finish panel; 3.70 m to the gym roof, the stiles 1.10 m above it, a self-closing gate in the court guard (`studies/roof.typ` page 2).
    ]
    #ar[
      #ah[جناح النوم الرئيسي · #n2(suite-area) م²]
      كما هو: ردهة من وصلة العائلة إلى الحمام والملابس والنوم. لا باب بين غرفة النوم والمكتب. باب الفناء الزجاجي المنزلق يفتح على منطقة دخول يكوّنها دولاب كامل الارتفاع، فلا يُرى السرير من باب النادي أو المكتب أو من جلسة الفناء والأبواب مفتوحة.
      #ah[فناء الجناح]
      #ffa("Suite court (open to the sky)") م² مفتوح للسماء من النادي إلى المكتب: الأبواب الثلاثة على ممر بعرض 1.2 م في طرفه الشمالي والجلسة في الجنوب، والأرضية تميل جنوبا إلى مزراب مع فائض، ومصارف خطية أمام الأبواب شبه المستوية. جهته الجنوبية إطار الواجهة بجدار سفلي 1.10 م، والحشوة اختيار المالك (المشربية مقترحة).
      #ah[النادي]
      #ffa("Gym") م² في الشريط الغربي ضمن إطار الأعمدة، بمدخل من نهاية الممر: جهاز المشي بطول الغرفة على البلاطة الصلبة، ورف الأثقال والكيتل بل والدراجة وبساط البيلاتس وتلفاز ثابت؛ جدار مزدوج مع غرفة النوم 3.
      #ah[مكتب المالك]
      شرقا للمالك فقط، يُدخل إليه من فناء الجناح؛ الزوار في مجلس الرجال؛ باب بسيط ونافذة شرقية وتلفاز ثابت. سلم الصيانة إلى السطح في تجويف بجدار النادي خلف لوح خشبي مقفل.
    ]
  ],
)

// ===================================================================================== SHEET 06 · ground-floor blocks
#pagebreak()
#sheet-head([Ground floor / the west wash block and the east service block], [Room studies studies/guest_wing.typ and studies/east_wing.typ | doors, fixtures and walls as studied])
#let in-west(P) = { let (x0, y0, x1, y1) = bbox(P); x1 <= 2.75 + 1e-6 and y0 >= 10.4 - 1e-6 }
#let in-east(P) = { let (x0, y0, x1, y1) = bbox(P); x0 >= 8.95 - 1e-6 and y1 <= 13.0 + 1e-6 }
#let blk(test) = (
  rooms: gf-rooms.filter(r => test(r.P)), doors: gf-doors.filter(d => test((d.a, d.b))), windows: gf-windows.filter(w => test(w)),
  furniture: gf-furniture.filter(f => test(((f.at(0), f.at(1)), (f.at(2), f.at(3))))))
#let wb = blk(in-west)
#let eb = blk(in-east)
#grid(columns: (auto, auto, 1fr), column-gutter: 18pt,
  cetz.canvas(length: 1.35cm, {
    import cetz.draw: *
    draw-floor(wb.rooms, gf-walls, wb.doors, wb.windows, wb.furniture, lsize: 7.5pt)
    let (x0, y0, x1, y1) = bbox(wb.rooms.map(r => r.P).join())
    dim((x0, y0), (x0, y1), (-0.6, 0), [#n2(y1 - y0) m])
    dim((x0, y0), (x1, y0), (0, -0.5), [#n2(x1 - x0) m])
    scale-bar((0, y1 + 0.8), m: 2)
  }),
  cetz.canvas(length: 1.35cm, {
    import cetz.draw: *
    draw-floor(eb.rooms, gf-walls, eb.doors, eb.windows, eb.furniture, lsize: 7.5pt)
    let (x0, y0, x1, y1) = bbox(eb.rooms.map(r => r.P).join())
    dim((x0, y1), (x1, y1), (0, 0.5), [#n3(x1 - x0) m])
    scale-bar((x0, y1 + 0.9), m: 2)
  }),
  [
    #let (wx0, wy0, wx1, wy1) = bbox(wb.rooms.map(r => r.P).join())
    #en[
      *West wash block* (#n2(wx1 - wx0) × #n2(wy1 - wy0) m): one strip of wet rooms on one drain run. Family side, open to the riwaq: hospitality kitchen #wd(gf-rooms, "Hospitality kitchen") m (a light kitchen for coffee, tea, dates and desserts); the family powder room #wd(gf-rooms, "Family powder room (WC · 2 basins)") m (3 Nov 2026: the basins and the WC as one luxurious room with a door from the riwaq; no shower on the ground floor).

      The *serving passage* #wd(gf-rooms, "Serving passage (2 doors)") m (#clear-wd(gf-rooms, gf-walls, "Serving passage (2 doors)") m clear) is the only family / guest link: door 1 (#dw((2.75, 16.25)) m) from the riwaq and door 2 (#dw((0.1, 17.5)) m) from the guest side are never open together and both lock from the family side.

      Guest side: guest WC behind a screen wall, one trough with three taps, the guest passage and the foyer with a #dw((0, 21.5)) m double door and a #dw((2.75, 22.15)) m opening into the men's majlis (a bent entry, partial).

      *East service block:* kitchen #wd(gf-rooms, "Kitchen") m on the courtyard lines (two parallel runs, no island, door to the dining only); the sink under its courtyard window (y 7.3–8.9, V8.0) with the dishwasher south of it, the outdoor TV on the other face of the wall further south; laundry #wd(gf-rooms, "Laundry") m on the solid wall of the women's majlis; maid room #gfa("Maid room") m² (an escape casement, sill +1.10) and maid bath #gfa("Maid bath") m² (V9.3: one straight wall parallel to the cut, the WC and the shower on its west wall off the breeze channel's line, a store #gfa("Maid store") m² north of it) reached only through the kitchen and the laundry; the slim air shaft along the cut wall (V9.3: 0.90 m² clear; the access panel from the maid bath) rising to the malqaf tower on the attic's corner: two separate paths (the courtyard breeze in a full-width channel in the slab; the HRV's intake, the unit in a plant room hidden behind the attic).
    ]
    #ar[
      #ah[كتلة المغاسل الغربية]
      خط واحد من الغرف الرطبة على خط صرف واحد. جهة العائلة مفتوحة على الرواق: مطبخ الضيافة #wd(gf-rooms, "Hospitality kitchen") م للقهوة والشاي والتمر والحلى، ومغاسل العائلة، ودورة العائلة.
      #ah[ممر التقديم]
      #wd(gf-rooms, "Serving passage (2 doors)") م (#clear-wd(gf-rooms, gf-walls, "Serving passage (2 doors)") م صافي) هو الصلة الوحيدة بين العائلة والضيوف: الباب 1 (#dw((2.75, 16.25)) م) من الرواق والباب 2 (#dw((0.1, 17.5)) م) من جهة الضيوف لا يفتحان معا ويقفلان من جهة العائلة.
      #ah[جهة الضيوف]
      دورة الضيوف خلف جدار ساتر، ومغسلة حوضية بثلاثة صنابير، وممر الضيوف، والبهو بباب مزدوج #dw((0, 21.5)) م وفتحة #dw((2.75, 22.15)) م إلى المجلس (مدخل منكسر جزئي).
      #ah[الكتلة الشرقية]
      المطبخ #wd(gf-rooms, "Kitchen") م على خطوط الفناء بخطي خزائن وبلا جزيرة وبابه إلى الطعام فقط، والحوض تحت نافذته على الفناء (y 7.3–8.9) وغسالة الصحون جنوبه؛ والغسيل #wd(gf-rooms, "Laundry") م على جدار مجلس النساء المصمت، وغرفة الخادمة #gfa("Maid room") م² بنافذة هروب وحمامها #gfa("Maid bath") م² في الركن المائل؛ ومجرى الهواء الرفيع على جدار القطع يصعد إلى برج الملقف على ركن العلّية: مساران منفصلان (نسيم الفناء في مجرى بعرضه الكامل، ومدخل هواء وحدة التهوية في غرفة معدات مخفية خلف العلّية).
    ]
  ],
)

// ===================================================================================== SHEET 07 · sections
#pagebreak()
#sheet-head([Sections / the west projection and the light], [Schematic sections, levels to confirm: GF ±0.00 · FF +#sec.f2(sec.ff-level) · roof +#sec.f2(sec.roof-level) | the column on x #n2(sec.pj.col-x) is beyond the cut | the light figures are geometry only])
#grid(columns: (1.35fr, 1fr), column-gutter: 18pt,
  [
    #text(10pt, weight: "bold", fill: accent)[A · east–west through the courtyard (y 12.0), looking north]
    #sec.section("court", length: 0.82cm)
    #v(4pt)
    #text(10pt, weight: "bold", fill: accent)[B · north–south through the middle band (x ≈ 7.3), looking west · the light check]
    #sec.ns-section(length: 0.5cm)
    #v(2pt)
    #sec.light-table(size: 8.5pt)
  ],
  [
    #en[
      *A · west projection:* the gallery stands on a #n2(sec.pj.depth) m slab over the courtyard, carried by an edge beam on x #n2(sec.pj.col-x) (spans #sec.pj.spans.map(n2).join(" and ") m) on #sec.pj.columns columns: on the ground floor a colonnade along the courtyard, with a normal-height ceiling under the projection. The first-floor west wall stands on the ground-floor west wall, #n3(sec.pj.m-gap) m from the M line. Courtyard sky #n3(sec.pj.sky) m on axes (≈ #n3(sec.pj.sky-clear) m clear).

      *B · light:* the main light of the double-height living comes from the courtyard; its #sec.clerestory.len() clerestory windows face the suite court, which since V8.0 (south wing v2) runs #n2(sec.strip) m to the south facade. Over the facade's parapet the winter noon sun reaches #sec.pc(sec.light.winter) of the window height and the sky shows on #sec.pc(sec.light.sky) (V7.1, behind the 2.0 m court: 81 %).
    ]
    #ar[
      #ah[المقطع A · البروز الغربي]
      يقوم الممر على بلاطة #n2(sec.pj.depth) م فوق الفناء يحملها جسر حافة على x #n2(sec.pj.col-x) فوق #sec.pj.columns أعمدة، فيصبح في الأرضي رواق بأعمدة على حافة الفناء بسقف عادي تحت البروز. الجدار الغربي للدور الأول فوق الجدار الغربي للأرضي على بعد #n3(sec.pj.m-gap) م من خط M. السماء فوق الفناء #n3(sec.pj.sky) م على المحاور.
      #ah[المقطع B · الضوء]
      الضوء الرئيسي للصالة من زجاج الفناء. النوافذ العلوية (#sec.clerestory.len()) تطل على فناء الجناح الممتد #n2(sec.strip) م حتى الواجهة الجنوبية (V8.0)، فتصل شمس ظهر الشتاء إلى #sec.pc(sec.light.winter) من ارتفاع النافذة.
      #ah[الخصوصية]
      جلسة النوافذ فوق مستوى النظر من أرضية فناء الجناح أو زجاج معتم.
    ]
  ],
)

// ===================================================================================== SHEET 08 · area schedules
#pagebreak()
#sheet-head([Areas / room schedules], [Axes = wall centre lines | clear = inside the walls as drawn (250 mm outer, 200 mm inner, 100 mm partitions, the steel windows on the courtyard edges), furniture and thresholds not deducted])
#let sched(rooms, spec) = table(columns: (auto, 1fr, auto, auto, auto), stroke: none, inset: 2.8pt, fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
  ..([No.], [Space], [Axis size], [Axis area], [≈ Clear]).map(c => text(8pt, weight: "bold", fill: accent, c)),
  ..rooms.map(r => {
    let (x0, y0, x1, y1) = bbox(r.P)
    (text(8pt)[#r.id], text(8pt)[#r.name], text(8pt)[#if is-rect(r.P) [#n2(x1 - x0) × #n2(y1 - y0) m] else [polygon]], text(8pt)[#n2(area(r.P)) m²], text(8pt)[#if r.kind in ("open", "court") [–] else [#n2(area(clear-poly(r, spec))) m²]])
  }).flatten())
#grid(columns: (1fr, 1fr), column-gutter: 18pt,
  [#text(12pt, weight: "bold")[Ground floor] #sched(gf-rooms.filter(r => r.id != ""), gf-walls)],
  [#text(12pt, weight: "bold")[First floor] #sched(ff-rooms.filter(r => r.id != ""), ff-walls)
    #v(6pt)
    #grid(columns: (1fr, 1fr), column-gutter: 8pt, row-gutter: 8pt,
      kpi[#n2(footprint) m²][outside footprint, incl. courtyard], kpi[#n2(area(court-r.P)) m²][courtyard on axes (#court-clear clear)],
      kpi[#n2(gf-area) m²][ground floor rooms (axes)], kpi[#n2(ff-area) m²][first floor rooms (axes), + suite court #n2(area(ff-rooms.find(r => r.kind == "open").P)) m²],
    )
  ],
)

// ===================================================================================== SHEET 09 · decisions log
#pagebreak()
#sheet-head([Decisions log], [One line per key decision with its reason | from data/decisions.csv | the version is the one in which the decision was made])
#let decisions = csv("data/decisions.csv", row-type: dictionary)
#{ set par(leading: 0.28em) }
#show table: set par(leading: 0.28em)   // V9.0: tighter lines so the 12 sheets hold every decision
#table(columns: (auto, auto, 1.3fr, 1fr, 1.15fr), stroke: none, inset: 0.45pt, fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
  ..([Ver.], [Topic], [Decision], [Reason], align(right, text(lang: "ar", dir: rtl)[القرار والسبب])).map(c => text(8.5pt, weight: "bold", fill: accent, c)),
  ..decisions.map(d => (text(4.0pt)[#d.version], text(4.0pt, weight: "bold")[#d.topic], text(4.0pt)[#fill-in(d.decision)], text(4.0pt)[#fill-in(d.reason)], align(right, text(4.4pt, lang: "ar", dir: rtl)[#fill-in(d.ar)]))).flatten())   // 3 Nov 2026: 4.0 / 4.4 pt so the 12 sheets hold the 57 rows

// ===================================================================================== SHEET 10 · open items
#pagebreak()
#sheet-head([Open items / for the owner and the engineers], [From data/open_items.csv (the same list as docs/OPEN_ITEMS.md) | orange = the edge beam and the #sec.pj.columns columns, red = the acoustic wall gym ↔ bedroom 3 | the roof ladder in the suite court])
#let items = csv("data/open_items.csv", row-type: dictionary)
#let item-no(key) = items.position(o => o.key == key) + 1
#grid(columns: (auto, 1fr), column-gutter: 18pt,
  cetz.canvas(length: 0.55cm, {
    import cetz.draw: *
    draw-floor(ff-rooms, ff-walls, (), (), (), labels: false, mini: true)
    line(q((sec.pj-edge, sec.y-court)), q((sec.pj-edge, sec.y-living)), stroke: (paint: orange, thickness: 1.6pt, dash: "dashed"))
    for c in sec.columns { rect(q((c.at(0) - 0.25, c.at(1) - 0.25)), q((c.at(0) + 0.25, c.at(1) + 0.25)), fill: orange, stroke: none) }
    line(q(suite.acoustic-wall.at(0)), q(suite.acoustic-wall.at(1)), stroke: 3pt + rgb("#b5452f"))
    line(q((sec.m-line, -0.5)), q((sec.m-line, gy1 + 0.5)), stroke: (paint: rgb("#b5452f"), thickness: 0.8pt, dash: "dash-dotted"))
    content(q((sec.m-line - 0.25, 6.0)), angle: 90deg, text(7pt, fill: rgb("#b5452f"))[M line · #n3(sec.pj.m-gap) m])
    let tag(p, key) = { circle(q(p), radius: 0.6, fill: white, stroke: 0.9pt + accent); content(q(p), text(8pt, weight: "bold", fill: accent)[#item-no(key)]) }
    tag((6.9, 10.0), "edge beam and columns"); tag((7.1, 22.6), "men's majlis"); tag((7.1, 24.9), "suite court south side")
    tag((6.6, 3.0), "off ground-floor lines"); tag((14.3, 7.0), "east-wall stack"); tag((7.3, 19.9), "clerestory privacy"); tag((2.1, 18.6), "acoustic wall"); tag((3.6, 21.3), "roof ladder"); tag((1.1, 1.1), "lift shaft size"); tag((9.8, 2.2), "main ventilation system")
  }),
  table(columns: (auto, auto, 1.1fr, 1fr, 1fr), stroke: none, inset: 2.4pt, fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
    ..([No.], [For], [Item], [Action], align(right, text(lang: "ar", dir: rtl)[البند])).map(c => text(8.5pt, weight: "bold", fill: accent, c)),
    ..items.enumerate().map(((i, o)) => (text(7.2pt, weight: "bold")[#(i + 1)], text(7.2pt)[#o.group], text(7.2pt)[#fill-in(o.item)], text(7.2pt)[#fill-in(o.action)], align(right, text(7.6pt, lang: "ar", dir: rtl)[#fill-in(o.ar)]))).flatten()),
)

// ===================================================================================== SHEET 11 · roof plan (V7.0)
#pagebreak()
#sheet-head([Roof plan / the roof ladder, the set-back attic, the set-back guardrail and the reserved zones], [studies/roof.typ (V8.1: the roof by a maintenance ladder in the suite court; the internal stair stops at the first floor; V9.3: the malqaf tower on the attic's corner, the HRV in a hidden plant room) | flat roof, no tiles | the attic 1.38 m above the finish, set back 1.0 m | the south parapet 0.70 m with a 1.10 m guardrail set back 1.0 m | zones reserved, not designed | all sizes assumed])
#grid(columns: (auto, 1fr), column-gutter: 18pt,
  rf.plan(length: 0.86cm),
  [
    #en[
      *Access (V8.1):* by a *maintenance ladder in the suite court*: a manufactured vertical ladder in a 0.90 × 0.30 recess of a honey-stone pilaster on the gym's east wall, behind a locked walnut-finish panel (not climbable when closed); #n2(rf.lad-climb) m from the court floor to the gym roof, the stiles 1.10 m above the roof as the transfer handholds (+#rf.f2(rf.lad.stile-top)), a self-closing gate in the court's west guard, a landing pad inside the guarded zone; a fall-arrest rail, to be confirmed by the specialist. The internal stair stops at the first floor; the roof slab over the well is closed; no door from the roof into the house. The lift stops at the first floor: headroom to the roof slab underside #n2(rf.lift-avail) m (a lift with ≤ 3.40 m, or ≤ 3.70 m with a 0.30 m raised head hidden behind the cornice; open item 15).

      *Roofline (V8.1, lower and balanced):* a honey-stone *main cornice* #n2(rf.cornice.h) × #n2(rf.cornice.proj) m at +#rf.f2(rf.cornice.z0) … +#rf.f2(rf.cornice.z0 + rf.cornice.h) all round; on the north block a coped upstand to +#rf.f2(rf.coping-top) and the *attic screen* #n2(rf.attic-vis) m above the roof finish (coping +#rf.f2(rf.attic-top)) set back #n2(rf.setback) m on all four sides; the *south wing* a low parapet #n2(rf.parapet-vis) m above the finish (+#rf.f2(rf.south-top)) and a *continuous 1.10 m black steel guardrail set back #n2(rf.rail-setback) m* (not seen from the street; the strip outside it a no-go zone): the roofline steps #n2(rf.step) m. Above the attic only the *malqaf tower* (V9.3, +#rf.f2(rf.tower-top)) on the attic's north-east corner; the HRV plant room (+#rf.f2(rf.base-top)) stays below the attic coping, hidden. The attic hides 1.2 m condensers on pads and the tank from every distance (§ 3 of the study). The attic never cuts the courtyard's sky or sun.

      *Zones (reserved):* the HRV in a plant room hidden behind the attic (V9.3); the AC units behind the cut / east attic wall; water tank(s) between the roof beams R10 and R3; PV on the gym roof and the office roof inside the guardrail and, later, on the north block's east roof; the 1.0 m strip in front of the attic (a no-go zone) with its own outlets; #rf.outlets.len() roof outlets to internal downpipes, falls 1.5 %; 0.9 m walkways from the ladder's landing pad through the attic opening at x 2.1–2.9 to every zone, with a branch to the office roof; the guarding continuous from the ladder to every piece of equipment (checked).
    ]
    #table(columns: (1.4fr, auto, 2.4fr), inset: 3pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      ..([Zone], [m²], [Note]).map(c => text(8.5pt, weight: "bold", fill: accent, c)),
      ..rf.zones.map(((n, a, note)) => (text(8pt, n), text(8pt)[#rf.r1(a)], text(8pt, note))).flatten())
    #ar[
      #ah[السطح]
      الوصول إلى السطح بسلم صيانة ثابت في فناء الجناح خلف لوح مقفل (V8.1)، والدرج الداخلي يتوقف عند الدور الأول وبلاطة السطح فوق البئر مغلقة؛ المصعد يقف في الدور الأول. كورنيش رئيسي من الحجر العسلي حول البيت، وعلى الكتلة الشمالية حاجز سطح بارتفاع #n2(rf.attic-h) م مرتدّ #n2(rf.setback) م خلف الكورنيش يخفي المعدات؛ برج الملقف على ركن العلّية ووحدة التهوية في غرفة مخفية؛ الجناح الجنوبي بدروة منخفضة 0.70 م ودرابزين مرتد 1.10 م فيتدرّج خط السطح #n2(rf.step) م. مناطق محجوزة: وحدات التكييف خلف العلية، الخزان، الألواح الشمسية، الممرات والمصارف والحواجز.
    ]
  ],
)

// ===================================================================================== SHEET 12 · elevations and the sight lines (V7.0)
#pagebreak()
#sheet-head([Elevations / the lowered roofline and the sight lines], [studies/roof.typ (V8.1) | cream plaster, honey stone at the plinth, the corners, the band between the floors and the main cornice | black steel divided-lite windows | the attic set back 1.0 m | openings indicative])
#grid(columns: (auto, auto, auto), column-gutter: 14pt, rf.north-elev(length: 0.5cm), rf.east-elev(length: 0.42cm), rf.west-elev(length: 0.42cm))
#v(6pt)
#grid(columns: (auto, 1fr), column-gutter: 18pt,
  rf.sight(length: 0.5cm),
  [
    #en[
      *Sight lines* (eye 1.6 m above the ground, +#rf.f2(rf.eye) against the house): from the north boundary (D = #n2(rf.D-north) m) the cornice coping (+#rf.f2(rf.coping-top)) is seen at #rf.r1(rf.ang(rf.D-north, 0, rf.coping-top))° and the attic coping at #rf.r1(rf.ang(rf.D-north, rf.setback, rf.attic-top))°: the attic hidden behind the cornice (its coping #calc.round(-rf.attic-peek * 1000) mm below the line; V9.2: the attic 2 cm lower). Nothing stands above the attic but the malqaf tower (by design, V9.3). The attic (V9.2: #n2(rf.attic-vis) m above the finish; V8.1 1.40) hides 1.2 m condensers on 0.10 pads (+#rf.f2(rf.cond-top)) and the tank from the street and the lane at every distance: the minimum height is #n2(rf.attic-min) m; the units are specified ≤ 1.2 m high.

      *Elevations:* the main cornice (#n2(rf.cornice.h) m, projecting #n2(rf.cornice.proj)) at +#rf.f2(rf.cornice.z0); the thin stone band at +#rf.f2(rf.band.z0); the plinth to +0.60 and the quoins in honey stone; the north block's coping +#rf.f2(rf.coping-top) with the attic (+#rf.f2(rf.attic-top)) 1.0 m behind it; the south wing's low parapet +#rf.f2(rf.south-top) with the guardrail set back behind it; the malqaf tower +#rf.f2(rf.tower-top) on the attic's north-east corner (V9.3: head (c), the Hijazi cornice); on the east the office's window and the outdoor kitchen's counter at the south end (V8.1). No element above the attic on the west.
    ]
    #ar[
      #ah[الواجهات وخطوط النظر]
      من حدّ الأرض الشمالي تختفي العِلّية خلف الكورنيش (خُفّضت 2 سم)، ولا شيء فوقها إلا برج الملقف؛ العلية بارتفاع 1.38 م تخفي المعدات، والدروة الجنوبية 0.70 م مع درابزين مرتد لا يُرى من الشارع. الواجهات: لياسة كريمية، حجر عسلي في القاعدة والزوايا والشريط بين الدورين والكورنيش الرئيسي، نوافذ فولاذية سوداء مقسّمة.
    ]
  ],
)

// ---------- the two room schedules as data (typst eval --in presentation.typ "query(<schedules>).first().value"; used for docs/PROJECT_V9.md) ----------
#let sched-data(rooms, spec) = rooms.filter(r => r.id != "").map(r => { let (x0, y0, x1, y1) = bbox(r.P); (id: r.id, name: r.name, size: if is-rect(r.P) { n2(x1 - x0) + " × " + n2(y1 - y0) } else { "polygon" }, axes: n2(area(r.P)), clear: if r.kind in ("open", "court") { "–" } else { n2(area(clear-poly(r, spec))) }) })
#metadata((gf: sched-data(gf-rooms, gf-walls), ff: sched-data(ff-rooms, ff-walls), vals: vals, footprint: n2(footprint), gf-area: n2(gf-area), ff-area: n2(ff-area), suite: n2(suite-area), court-clear: court-clear, palms: (n2(palm-gap(T1)), n2(palm-gap(T2))))) <schedules>

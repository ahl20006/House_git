// presentation.typ · Taif / Palm House V11.0 (17 Nov 2026: the north-east corner as one step and the house 1.3 m south, the twin bedrooms, the 3D rebuilt) · presentation set, A3, 12 sheets (ground floor, first floor, roof, elevations) · compile THIS file
//   typst compile --root taif_house taif_house/presentation.typ taif_house/output/Taif_House_V11.0_presentation.pdf
// Every number comes from the project files: data/rooms_gf.csv, data/rooms_ff.csv, data/decisions.csv, data/open_items.csv, the design files
// (placement, gaps) and the studies (doors, windows, furniture, fixtures, the treadmill, the sections and the light check). Walls are drawn with
// thickness from the room outlines (250 mm outer, 200 mm inner, 100 mm dry partitions, the steel windows W1 / W2 on the courtyard edges since V7.0). Ground-floor doors and
// windows outside the two studied blocks are indicative.
#import "@preview/cetz:0.4.2"
#import "base.typ": land, env, drv, lane, nwall, south, T1, T2, Ms, north, accent, edges, seg-dist, sample
#import "design_gf.typ": shift, env-gap, outline-csv-gf, outline-csv-gf-floor, outline-gf, tower-csv, shaft-csv
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
  grid(columns: (1fr, auto), text(11pt, weight: "bold", fill: accent)[TAIF / PALM HOUSE], text(9pt, fill: soft)[V11-idea · NE corner out])
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
// 17 Nov 2026: the two setback readings of SITE_SETOUT.md § 5 from the OUTER FACES (the centre line offset 0.125 outward, every face sampled at 5 cm): (A) to the deed setback line, (B) to the lane wall as built (the model's lane line less 0.62) less the 2.0 m rule
#let faces-gf = offset-poly(outline-gf, range(outline-gf.len()).map(i => -0.125))
#let deed-gap = calc.min(..sample(faces-gf, step: 0.05).map(p => calc.min(..edges(env).filter(e => not (calc.abs(e.at(0).at(0)) < 0.01 and calc.abs(e.at(1).at(0)) < 0.01)).map(e => seg-dist(p, ..e)))))
#let built-gap = calc.min(..sample(faces-gf, step: 0.05).map(p => calc.min(..range(lane.len() - 1).map(i => seg-dist(p, lane.at(i), lane.at(i + 1)))))) - 0.62 - 2.0
#let poly-of(r) = if r.pts.trim() != "" { sec.parse-pts(r.pts) } else {
  let x = float(r.x); let y = float(r.y); let w = float(r.w); let d = float(r.d)
  rect-pts(x - w / 2, y - d / 2, x + w / 2, y + d / 2)
}
#let segs(P) = range(P.len()).map(i => (P.at(i), P.at(calc.rem(i + 1, P.len()))))
#let outer-segs = segs(outline-csv-gf)   // the first floor's outline (unchanged)
#let outer-segs-gf = outer-segs + segs(outline-csv-gf-floor)   // idea-ne-corner: the ground floor's outside walls (the corner out: x 8.95 and y 6.5 are outside walls now)

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
  "Suite WC (closet)": "WC", "Bedroom 1 bath": "Bath 1", "Air tower": "malqaf", "Malqaf chamber": "malqaf chamber",
)
#let mk(prefix, rows, extra) = rows.enumerate().map(((i, r)) => (id: prefix + (if i < 9 { "0" } else { "" }) + str(i + 1), name: r.name, kind: kind-of(r.name, r.colour), P: poly-of(r))) + extra
#let tower = fam.fixed.find(f => f.name == "Air tower").pts
#let gf-rooms = mk("G", gf-csv, ((id: "", name: "Malqaf chamber", kind: "tower", P: tower-csv),))   // 10 Nov 2026: the GF chamber from design_gf.typ (the FF shaft is `tower`)
#let ff-rooms = mk("F", ff-csv, fam.fixed.map(f => (id: "", name: f.name, kind: if f.name == "Air tower" { "tower" } else { "core" }, P: f.pts)) + (
  (id: "", name: "Courtyard (open to the sky)", kind: "void", P: rect-pts(sec.pj-edge, sec.y-court, sec.x-east, 13.0)),
  (id: "", name: "Double-height living (void)", kind: "void", P: rect-pts(sec.pj-edge, 13.0, sec.x-east, sec.y-living)),
))
#let room-of(rooms, n) = rooms.find(r => r.name == n)
// wall types along the room outlines: open (no wall), balustrade, light partition; everything else 200 mm, outline 250 mm
#let gf-walls = (
  open: (((sec.x-east, 13.0), (sec.x-east, sec.y-living)),),          // living ↔ dining: one room, ceiling change only
  rail: (),
  outer: outer-segs-gf,
  light: (((1.25, 19.4), (2.75, 19.4)), ((1.5, 9.2), (1.5, 10.4)), ((0, 9.2), (1.5, 9.2)), ((0, 10.4), (1.5, 10.4))),   // 100 mm partitions: the maid's wing (layout D, 10 Nov 2026; 17 Nov 2026: the bath's west wall x 11.275 at the step); the shaft's own walls
)
#let ff-walls = (
  open: (((2.75, 7.9), (2.75, 9.2)), ((0, 7.9), (2.75, 7.9)), ((sec.pj-wall, sec.y-living), (sec.pj-edge, sec.y-living)), ((8.95, 5.3), (8.95, 6.5)), ((sec.pj-edge, 13.0), (sec.x-east, 13.0)), ((sec.x-court, sec.y-court), (sec.pj-edge, sec.y-court))),   // V7.1: the family living open to the gallery's north end
  rail: (),   // V7.0: the gallery edge and the family living edge are walls with the steel windows W1 / W2 (enclosure A)ard edge
  light: (((2.25, 0.7), (4.25, 0.7)),),                               // linen cupboard front
)
#let wall-t(a, b, spec) = {
  let hit(list) = list.any(s => on-seg(a, ..s) and on-seg(b, ..s))
  if hit(spec.open) { 0.0 } else if hit(spec.at("outer", default: outer-segs)) { 0.25 } else if hit(spec.rail) { 0.06 } else if hit(spec.light) { 0.1 } else { 0.2 }
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
  G((0.1, 7.9), (2.65, 7.9), (0, 1), "open"),            // 10 Nov 2026 (owner): the store under the half landing and the utility room are ONE room: the wall between them opened (the engineer), the store's door onto the riwaq removed
  G((2.75, 8.2), (2.75, 9.0), (-1, 0), "hinged"),        // the utility room's ONE door from the riwaq
  G((1.5, 9.4), (1.5, 10.2), (-1, 0), "hinged"),         // the shaft's maintenance door (0.9 m clear in front)
  G((1.6, 14.55), (2.3, 14.55), (0, 1), "hinged"),       // 10 Nov 2026 (redrawn): the powder room's WC compartment door 0.70, opening into the compartment
  G((4.25, 9.1), (4.25, 10.5), (1, 0), "sliding"),       // courtyard glass door (indicative)
  G((2.75, 10.6), (2.75, 12.7), (-1, 0), "open"),        // hospitality kitchen
  G((2.75, 13.05), (2.75, 14.4), (-1, 0), "open"),       // 10 Nov 2026 (owner): the family powder room has no outer door: a 1.35 m opening onto the riwaq (was a 1.00 door; 3 Nov 2026: the basins + the WC as one room, a 1.00 m door from the riwaq)
  G((2.75, 16.25), (2.75, 17.15), (-1, 0), "hinged"),    // serving door 1
  G((0.1, 17.5), (1.15, 17.5), (0, -1), "hinged"),       // serving door 2
  G((1.35, 19.4), (2.25, 19.4), (0, -1), "hinged"),      // guest WC, 0.90 door from the basins room (11 Nov 2026, owner: back on the south wall; hinged west, opens in; only the WC and a shower mixer inside)
  G((1.25, 19.5), (1.25, 21.3), (1, 0), "open"),         // guest passage ↔ the three basins, a 1.8 m opening
  G((0.1, 21.4), (1.15, 21.4), (0, 1), "open"),          // guest passage ↔ foyer
  G((0, 21.5), (0, 22.9), (1, 0), "double"),             // guest entrance, two leaves
  G((2.75, 22.15), (2.75, 23.95), (1, 0), "open"),       // foyer → men's majlis
  G((4.25, 13.1), (4.25, 14.5), (1, 0), "open"),         // living entrance
  G((9.4, 13.0), (10.5, 13.0), (0, -1), "hinged"),       // kitchen ↔ dining
  G((13.311, 7.2), (13.311, 8.1), (1, 0), "hinged"),     // kitchen service door to the east yard, lockable (owner decision)
  G((9.7, 6.5), (10.55, 6.5), (0, -1), "open"),          // kitchen ↔ laundry (11 Nov 2026: the wall on the structural line y 6.5)
  // (idea-ne-corner) G((9.7, 4.7), (10.55, 4.7), (0, -1), "hinged"),       // laundry ↔ maid room 0.90 (layout D; 11 Nov 2026: 0.35 m east; her only door, from the laundry)  → removed with the rooms
  // (idea-ne-corner) G((11.275, 3.7), (11.275, 4.4), (1, 0), "hinged"),   // maid room ↔ maid bath 0.70 on the bath's west wall (17 Nov 2026, the step; from her room only)  → removed with the rooms
  G((4.6, 8.667), (5.6, 8.667), (0, 1), "hinged"),     // V10.0 (L5): the malqaf foot chamber's carved door onto the covered strip
)
#let dw(p) = { let d = gf-doors.find(d => dist(d.a, p) < 1e-6); n2(dist(d.a, d.b)) }   // door width, by its first point
#let gf-windows = (
  ((8.95, 7.3), (8.95, 8.9)), ((13.311, 8.7), (13.311, 10.1)), ((11.275, 1.2), (11.275, 2.3)), ((12.5, 3.2), (13.0, 3.2)), ((13.311, 5.35), (13.311, 6.25)),   // studied (17 Nov 2026, the step: the escape casement on the step's east face, the bath window on the step's north face, the laundry window)
  ((6.0, 6.5), (8.1, 6.5)),   // V10.0: the majlis's small west panel (x 5.1–5.6) is inside the malqaf core's north wall ((4.45, 13.0), (5.55, 13.0)), ((6.05, 13.0), (8.75, 13.0)), ((4.25, 10.7), (4.25, 12.7)), ((5.8, 7.1), (5.8, 8.5)),   // courtyard glass (indicative); V10.0: the riwaq's first panel (y 6.8–8.9) is the malqaf core's solid face with the bench; the malqaf outlet 1.4 × 1.0 in the first arch
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
#let gf-real = gf-rooms.filter(r => r.kind != "court" and r.name != "Malqaf chamber")
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
  "tm-clear": n2(suite.tm-clear), "tm-side": n2(suite.tm-side), "arm-x": n3(suite.arm-x0), "court": n2(area(room-of(ff-rooms, "Suite court (open to the sky)").P)), "winter": sec.pc(sec.light.winter), "maid-clear": "removed (idea-ne-corner)",
)
#let fill-in(s) = { let t = s; for (k, v) in vals { t = t.replace("{" + k + "}", v) }; t }
#let ff-label-at = (
  "Upper gallery (on the west projection)": (sec.pj-edge - 0.68, 12.2), "Bedroom 3": (2.7, 18.6), "Bedroom 2": (3.2, 12.3), "Bedroom 3 bath": (3.3, 15.25), "Suite bedroom": (11.4, 16.6), "Suite bath": (11.2, 9.35), "Suite WC (closet)": (10.9, 7.6), "Bedroom 1 bath": (12.4, 6.75),
  "Bedroom 1": (10.6, 3.0), "Bedroom 2 bath (en-suite)": (1.1, 14.55), "Family WC (gallery)": (2.15, 8.8), "Owner's office": (11.65, 22.4), "Gym": (2.9, 21.15), "Suite court (open to the sky)": (7.4, 22.1),
  "Kids' room (study + gaming)": (5.6, 2.2), "Family living": (5.3, 5.9), "Courtyard (open to the sky)": (7.3, 9.75), "Double-height living (void)": (7.3, 16.0),
)
#let gf-label-at = ("Family lobby + riwaq": (3.5, 4.0), "Living (double height)": (6.6, 14.2), "Living (normal height) · dining": (11.1, 14.0), "Men's majlis": (8.0, 22.6), "Women's majlis": (6.6, 4.6), "Kitchen": (11.1, 12.2), "Utility room (shaft inside)": (2.1, 8.5), "Malqaf chamber": (5.1, 8.0), "Family powder room (WC · 2 basins)": (1.75, 13.75), "Guest WC": (1.75, 18.75), "Courtyard": (7.2, 9.55))
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
#sheet-head([The house on its site · the site and services plan], [Site option Z4 | shift (#n2(shift.at(0)), #n3(shift.at(1))) m, rotation 0° | the first floor stands on the same outline | 250 mm outer / 200 mm inner walls | 17 Nov 2026: the house 1.3 m further south (B1 7.29 m from M1) and the north-east corner as one orthogonal step; V9.1: B1 6.00 m (the owner's car test); the site plan `studies/site_plan.typ` and the whole farm `studies/whole_farm.typ` (the existing buildings approximate, to be measured)])
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
      kpi[#n2(deed-gap) / #n2(built-gap) m][nearest wall face to the setback: deed line / beyond the 2.0 m from the wall as built (17 Nov 2026: the step)], kpi[#n2(palm-gap(T1)) / #n2(palm-gap(T2)) m][palms P1 / P2 to the outer walls], kpi[#n2(sec.ff-level) m][floor to floor (to confirm)],
    )
    #v(6pt)
    #en[
      *The house.* A compact courtyard house on site option Z4: a #n3(gx1 - gx0) × #n2(gy1 - gy0) m outline on wall centre lines, its north-east corner stepped back once, square (17 Nov 2026: one orthogonal step at x 11.275 / y 3.2 instead of the slanted cut wall, `studies/step_corner.typ` option 6), square to the M line and as far north as the setbacks allow. The courtyard is the cool heart; the rooms look in, not out. A west service band and an east service block frame the middle band (women's majlis, courtyard, double-height living); the men's majlis takes the full width on the south.

      *First floor.* The family part on the north and west around the courtyard; the south wing (V8.0): the gym on the west, a large suite court open to the sky, the owner's office on the east (reached from the court only), and the master suite. The gallery runs on a #n2(sec.pj.depth) m projection over the courtyard and the double-height void, on an edge beam and #sec.pj.columns columns.

      *Roof access (V8.1):* a maintenance ladder in a recess of the gym's east wall in the suite court, behind a locked walnut panel; the internal stair stops at the first floor; office visitors are met in the men's majlis. One entry to the site: the farm's 4 m main gate.

      *Site position (17 Nov 2026):* the house 1.3 m further south along the M line, B1 #n2(calc.sqrt(calc.pow(shift.at(0) - 0.125, 2) + calc.pow(shift.at(1) - 0.125, 2))) m from M1 (V9.1: 6.00 m after the owner's car test), and the north-east corner as one orthogonal step: #n2(deed-gap) m from the deed setback line, #n2(built-gap) m beyond the 2.0 m from the wall as built (the slant had 0.91 / 0.42; the official survey confirms); the car's north strip 1.3 m deeper. Set out again from M1 and D with the six corners of the set-out sheet. The levels (the floor, the plinth, the entrance steps or ramps, the garden, the sewer falls) are set from the survey. *The farm (owner; approximate, to be measured):* the old house with its majlis west of the driveway, its covered parking and the ground tank south of it near peg R, the septic outside the north wall near C1 serving both houses.

      *Site plan (a study):* one 4 m gate; one family car in the north strip (one forward turn from the gate, drawn on the site plan); the guest path (porcelain, V10.0) along the driveway; the service yard reached along the farm's wall; the family garden on the south only; rain separate; PV without a generator.
    ]
    #ar[
      #ah[المنزل]
      منزل فناء مدمج على خيار الموقع Z4: مخمس #n3(gx1 - gx0) × #n2(gy1 - gy0) م على محاور الجدران، ركنه الشمالي الشرقي مُدرَّج بدرجة واحدة متعامدة (17 نوفمبر 2026) بدل القطع المائل، متعامد مع خط M ومدفوع شمالا قدر ما تسمح الارتدادات. الفناء هو القلب البارد، والغرف تطل إلى الداخل لا إلى الخارج.
      #ah[الدور الأول]
      جزء العائلة شمالا وغربا حول الفناء، والجناح الجنوبي (V8.0): النادي غربا وفناء الجناح الكبير المفتوح للسماء ومكتب المالك شرقا، ثم جناح النوم الرئيسي. الممر العلوي على بروز #n2(sec.pj.depth) م فوق الفناء والصالة، على جسر حافة و#sec.pj.columns أعمدة.
      #ah[الوصول إلى السطح (V8.1)]
      سلم صيانة في تجويف بجدار النادي داخل فناء الجناح خلف لوح خشبي مقفل؛ الدرج الداخلي يتوقف عند الدور الأول؛ زوار المكتب يُستقبلون في مجلس الرجال. مدخل واحد للموقع: البوابة الرئيسية للمزرعة بعرض 4 م.
      #ah[موضع البيت والمزرعة (17 نوفمبر 2026)]
      أُزيح البيت 1.3 م أخرى جنوبًا على خط M (الركن B1 على #n2(calc.sqrt(calc.pow(shift.at(0) - 0.125, 2) + calc.pow(shift.at(1) - 0.125, 2))) م من M1) وصار الركن الشمالي الشرقي درجة واحدة متعامدة بدل جدار القطع المائل: الهامش #n2(deed-gap) م من خط الصك و#n2(built-gap) م زيادة على 2.0 م من الجدار القائم (كانا 0.91 / 0.42)؛ الشريط الشمالي للسيارة أعمق بـ1.3 م. المناسيب تُحدَّد من الرفع المساحي الرسمي. البيت القديم غرب الممر، ومظلته والخزان جنوبه، وخزان الصرف قرب C1 للبيتين (تقريبي، يقاس). بوابة واحدة؛ ممر الضيوف؛ حديقة العائلة جنوبا.
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
    // 10 Nov 2026 (the owner's review): the utility room's low part under the half landing, the shaft drawn black, the malqaf chamber and its courtyard outlet labelled
    content(q((1.4, 7.2)), text(5pt, fill: soft)[utility · low part\ batteries + inverter])
    rect(q((shaft-csv.at(0))), q((shaft-csv.at(2))), fill: luma(225), stroke: 1.2pt + black); for k in range(1, 6) { line(q((0 + k * 0.25, 9.2)), q((0, 9.2 + k * 0.25)), stroke: 0.3pt + luma(90)); line(q((1.5 - k * 0.25 + 0.25, 10.4)), q((1.5, 10.4 - k * 0.25 + 0.25)), stroke: 0.3pt + luma(90)) }; content(q((0.75, 9.8)), text(5.5pt, weight: "bold")[shaft])
    // 10 Nov 2026 (owner): the core's east wall 0.30 on the column line (faces x 5.65–5.95, flush with the columns under the edge beam): drawn over the 0.20 wall and the window cut; the outlet opening inside it
    rect(q((5.65, 6.35)), q((5.95, 8.767)), fill: dark, stroke: none); rect(q((5.68, 6.9)), q((5.92, 8.3)), fill: white, stroke: none)
    line(q((5.8, 6.9)), q((5.8, 8.3)), stroke: 2.2pt + rgb("#9c6b3c")); content(q((6.13, 7.6)), angle: 90deg, text(4.2pt, fill: rgb("#9c6b3c"))[outlet 1.4 × 1.0\ +0.60…+1.60 · 15° SE])
    content(q((1.05, 15.75)), text(4.6pt, fill: soft)[WC compartment]); content(q((2.0, 17.8)), text(4.2pt, fill: soft)[shower mixer])
    for (a, b) in (((0.0, 14.55), (2.75, 14.55)),) { line(..cut(a, b, half: 0.05).map(q), close: true, fill: dark, stroke: none) }   // the WC compartment's partitions, the shower wall, the WC screen wall (100 mm)
    dim((gx0 - sec.outer-half, 0), (gx1 + sec.outer-half, 0), (0, -1.0), [#n3(gx1 - gx0 + 2 * sec.outer-half) m outside])
    dim((0, gy0 - sec.outer-half), (0, gy1 + sec.outer-half), (-1.6, 0), [#n2(gy1 - gy0 + 2 * sec.outer-half) m outside])
    rect(q((5.925, 7.1)), q((8.85, 12.3)), stroke: (paint: orange, thickness: 0.7pt, dash: "dashed")); rect(q((4.35, 10.3)), q((5.925, 12.3)), stroke: (paint: orange, thickness: 0.7pt, dash: "dashed")); content(q((6.6, 12.62)), text(4.4pt, fill: orange)[seating zone · level · 6 seats · no TV · a 1.1 m door path])
    // H2 (the courtyard haven study, adopted 10 Nov 2026): the water trough on the kitchen wall, the olive in its fixed pot, five seats facing the water (studies/courtyard_layout.typ)
    // 11 Nov 2026 (owner): the order outlet → olive → water: the trough under the sink window, the olive in the jet's path; six seats, the zone extended under the projection
    rect(q((7.9, 7.3)), q((8.85, 9.4)), fill: rgb("#c9a86a"), stroke: 0.5pt + dark); rect(q((8.05, 7.45)), q((8.8, 9.25)), fill: rgb("#bcd9ea"), stroke: none); content(q((8.4, 8.35)), angle: 90deg, text(5pt)[water trough])
    circle(q((6.9, 7.85)), radius: 1.0, fill: rgb("#7fa25a").transparentize(70%), stroke: (paint: rgb("#5a7d2a"), thickness: 0.4pt, dash: "dashed")); circle(q((6.9, 7.85)), radius: 0.5, fill: rgb("#e9d6b8"), stroke: 0.5pt + rgb("#9c6b3c")); content(q((6.9, 7.85)), text(4.4pt)[olive])
    for (x0, y0, x1, y1, k) in ((6.5, 11.3, 8.15, 12.15, "sofa"), (4.45, 10.5, 5.3, 12.1, "sofa"), (7.65, 10.1, 8.4, 10.85, "armchair"), (6.9, 10.4, 7.4, 11.0, "table")) { rect(q((x0, y0)), q((x1, y1)), fill: if k == "table" { rgb("#fbf4e6") } else { rgb("#e9d6b8") }, stroke: 0.5pt + rgb("#9c6b3c")) }
    // idea-ne-corner: the first floor's outline dashed over the open ground of the north-east corner, with the note
    line(q((8.95, 0)), q((11.275, 0)), q((11.275, 3.2)), q((13.311, 3.2)), q((13.311, 6.5)), stroke: (paint: dark, thickness: 0.9pt, dash: "dashed"))
    content(q((11.1, 2.0)), align(center, text(5.2pt, fill: dark)[OPEN GROUND\ first floor above, on columns;\ the slab's underside insulated]))
    north-arrow((17.4, 1.0))
    scale-bar((0, 25.6))
  }),
  [
    #en[
      *Middle band:* the women's majlis #wd(gf-rooms, "Women's majlis") m, the courtyard (an L-shape round the malqaf chamber, #n2(area(court-r.P)) m² on axes, its wide part #court-clear m clear, open to the sky) and the living room in two heights: double height on the courtyard, normal height with the dining to the east. The living is entered from the riwaq through a #dw((4.25, 13.1)) m arched opening; its west wall is solid and full height with the arched TV niche (V6.3).

      *Straight walls (owner, 11 Nov 2026):* no jogs between rooms unless structural; the riwaq's line and the laundry / kitchen wall straightened. *West band (the owner's review, 10 Nov 2026):* the lift (installed at construction), the open stair (flipped, V8.2, the coat cupboard in its start strip); *one utility room with one door from the riwaq*: the west service *shaft* (x 0–1.5, y 9.2–10.4, unchanged; its maintenance door with 0.9 m clear in front), the panel, the heater and the manifold on the walls, and the *low part under the stair's half landing* (1.65 m) for the future batteries and inverter (the wall between them opened: a note for the engineer; the store's door removed); then the west wash block (sheet 06): the *family powder room* redrawn, *open to the riwaq (a 1.35 m opening, no door)*: *two basins under a large mirror* straight ahead, the *WC compartment across the full width* at the far end (only the WC and one basin, the only door, seen from the riwaq only obliquely); the guest side two rectangles side by side onto the guest passage: the *guest WC* (1.5 × 1.9, its door from the basins room as before; only the WC and a shower mixer on the wall) and next to it the *three guest basins in one straight row* with a mirror (1.5 × 2.0, a 1.8 m opening); all drains into the west run. The riwaq #wd(gf-rooms, "Family lobby + riwaq") m runs along the courtyard.

      *East block · V11-idea · NE corner out, 23 Nov 2026 (branch `idea-ne-corner`):* the north-east corner, x 8.95–13.311 × y 0–6.5 with the step (the maid room, the maid bath and the laundry of V11.0), is *outside the ground floor*: open ground, 21.83 m² on axes, 2.10 × 6.28 + 2.04 × 3.08 = 19.44 m² inside the former wall faces. Its outer walls (the north wall east of x 8.95, the step's two walls, the east wall from the step to y 6.5) are gone; the ground-floor outline runs (0, 0) → (8.95, 0) → (8.95, 6.5) → (13.311, 6.5) → (13.311, 24) → (0, 24): the women's majlis east wall and the kitchen's north wall are outside walls, straight lines. *The first floor does not change:* bedroom 1, its bath F20, the link and the suite's WC closet stand over the open ground on the existing corner columns (its outline dashed on the plan; the slab's underside insulated). *The one door that changed:* the kitchen's open entrance on y 6.5 (x 9.7–10.6) is a normal closed door 0.90 to the open ground; nothing else in the kitchen changes.

      *Courtyard (H2, owner 11 Nov 2026):* level, *no TV*; *outlet → olive → water:* the malqaf outlet raised (+0.60…+1.60, louvres fixed 15° SE), the *olive in a fixed pot in the jet's path*, the *trough* under the sink window; *6 seats with backs* facing the olive and the water, the zone extended under the projection with a 1.1 m path from the riwaq door. *Winter sun-seat: the suite court (sheet 03).* *Outside (V8.3):* the outdoor counter and sink next to the kitchen service door (canopy optional), the grill and tannour a little apart in the yard's south part (≥ 3 m from every opening, downwind); the yard screen, the gas cabinet at its north end, the bins north of the door.
    ]
    #ar[
      #ah[الوسط: مجلس النساء والفناء والصالة]
      الفناء على شكل L حول غرفة الملقف (#n2(area(court-r.P)) م² على المحاور، وجزؤه الواسع #court-clear م صافيا) مفتوح للسماء. الصالة بسقفين: ارتفاع مزدوج على الفناء وارتفاع عادي مع الطعام شرقا، وتُدخل من الرواق عبر فتحة مقوسة #dw((4.25, 13.1)) م؛ جدارها الغربي مصمت كامل الارتفاع مع كوة التلفاز المقوسة (V6.3).
      #ah[الشريط الغربي والرواق]
      المصعد والدرج المفتوح (معكوس الاتجاه في V8.2: الجزء السفلي يصعد جنوبا من الردهة خلف درابزين أسود، ودولاب المعاطف في النصف الغربي من شريط البداية)، ثم (مراجعة المالك 10 نوفمبر 2026) غرفة خدمات واحدة بباب واحد من الرواق: الشفت الغربي بحجمه ومكانه (بابه وأمامه 0.9 م)، واللوحة والسخان والمجمّع على الجدران، والجزء المنخفض تحت بسطة الدرج للبطاريات والعاكس مستقبلا (يُفتح الجدار بينهما، ملاحظة للمهندس، ويُلغى باب المخزن). وفي كتلة المغاسل (أعيد رسمها): مغاسل العائلة مفتوحة على الرواق بفتحة 1.35 م بلا باب، وحجرة المرحاض بكامل العرض (مرحاض ومغسلة واحدة، بابها الوحيد لا يُرى من الرواق إلا بزاوية) ومغسلتان بمرآة أمام المدخل؛ وللضيوف مستطيلان متجاوران على الممر: دورة مياه (مرحاض وخلاط دش على الجدار، بابها من المغاسل) وبجوارها ثلاث مغاسل في صف مستقيم خلف فتحة واسعة. الرواق #wd(gf-rooms, "Family lobby + riwaq") م على طول الفناء.
      #ah[الكتلة الشرقية ومجلس الرجال]
      فكرة 23 نوفمبر 2026 (الفرع idea-ne-corner): الركن الشمالي الشرقي x 8.95–13.311 × y 0–6.5 بدرجته (غرفة الخادمة وحمامها والغسيل) خارج الدور الأرضي: أرض مكشوفة 21.83 م² على المحاور (19.44 م² صافية) تحت الدور الأول القائم على أعمدة الركن (عزل أسفل البلاطة). تُزال جدرانه الخارجية؛ ويصير حد الدور الأرضي: جدار مجلس النساء الشرقي (x 8.95) وجدار المطبخ الشمالي (y 6.5) جدارين خارجيين بخطوط مستقيمة. الدور الأول لا يتغير. الباب الوحيد المتغير: مدخل المطبخ على y 6.5 يصبح بابًا مغلقًا 0.90 م إلى الأرض المكشوفة. مجلس الرجال بكامل العرض جنوبًا.
      #ah[الأعمدة والرواق]
      #sec.pj.columns أعمدة على x #n2(sec.pj.col-x) (في جدار مجلس النساء الجنوبي، وبين زجاج الفناء والصالة، وفي جدار الصالة الجنوبي) تحمل جسر حافة البروز في الدور الأول (الخط البرتقالي المتقطع)، فيصبح على حافة الفناء رواق بأعمدة وثلاثة أقواس.
      #ah[الفناء (معدل V8.3)]
أرضية مستوية بلا تلفاز؛ *H2 (قرار المالك 11 نوفمبر 2026): الملقف ← الزيتونة ← الماء:* المخرج مرفوع (+0.60…+1.60، شيش ثابت 15° نحو الجنوب الشرقي)، والزيتونة في أصيص ثابت في مسار النسيم، والحوض تحت نافذة المغسلة؛ ستة مقاعد بظهر تواجه الزيتونة والماء، والجلسة ممتدة تحت البروز مع ممر 1.1 م من باب الرواق؛ زجاج الصالة ثابت؛ مقعد شمس الشتاء في فناء الجناح (اللوحة 03).
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

      *North band:* kids' room #ffa("Kids' room (study + gaming)") m² and family living #ffa("Family living") m² on the courtyard edge; bedroom 1 #ffa("Bedroom 1") m², the young children's room next to the master suite, *with its own compact bath F20* #ffa("Bedroom 1 bath") m² (14 Nov 2026, the east wing's M3 adopted with the owner's adjustments: the bath in the corner beside the suite's wet rooms, its shower over the east stack back to back with the suite's; bedroom 1's door on the link's east wall at a right angle to the suite door; two built-in wardrobes; the suite's WC closet re-made 1.0 × 1.3 clear on the shared wall with a glass door into the bath, the suite's shower on its north wall, the basins east, the tub south).

      *West band:* the family WC (14 Nov 2026, as the GF powder room: a basin zone open to the gallery through a 0.90 opening with no door, then a 0.70 door into a WC-only compartment behind a partition on x 1.5; a high window above the WC); *bedrooms 2 and 3 as twins* (owner, 15 Nov 2026, `studies/west_wing_ff.typ` adopted): each through an entry strip 2.55 m wide (bedroom 2's beside the shaft, bedroom 3's taken from the gym south of y 19.25), the main rooms equal (4.03 × 3.5 clear, 14.44 m² each), their baths back to back between them (y 14.13–15.53) on one stack into the GF powder room's WC compartment; the gallery extended to y 20.55 over the old nib, a glass door onto the court at its end.

      *South wing v2 (V8.0):* the gym on the west band #ffa("Gym") m² (15 Nov 2026: bedroom 3's entry strip and a pocket for the dumbbell rack taken from its north end, its door from the court beside the gallery's end), the suite court #ffa("Suite court (open to the sky)") m² open to the sky from the gym to the office — *the family's winter sun room (owner, 10 Nov 2026, the courtyard haven study): two armchairs with backs and a small table in the court's middle band north part (x 7.0–9.5, y 20.6–21.4, out of the doors' strip: ≈ 2 h of direct January sun on the north strip and ≈ 3 h through the mashrabiya), a socket pair and a wall light by the office door; the mashrabiya's middle panels made to open in winter (hinged or sliding, closing tight in dust; non-structural)* — the owner's office #ffa("Owner's office") m² on the east (no door to the bedroom; reached from the court only); master suite #n2(suite-area) m².
    ]
    #ar[
      #ah[البروز الغربي والممر العلوي]
      بروز #n2(sec.pj.depth) م فوق الفناء وفراغ الصالة على جسر حافة على x #n2(sec.pj.col-x) و#sec.pj.columns أعمدة، والجدار الغربي للدور الأول فوق الجدار الغربي للأرضي. الممر #n2(sec.pj.gallery) م (نحو #n3(sec.pj.gallery-clear) م صافي)، والغرف #n2(sec.pj.room) م (نحو #n3(sec.pj.room-clear) م صافي)، والسماء فوق الفناء #n3(sec.pj.sky) م.
      #ah[الشريط الشمالي]
      غرفة الأطفال #ffa("Kids' room (study + gaming)") م² وجلسة العائلة #ffa("Family living") م² على حافة الفناء، وغرفة النوم 1 #ffa("Bedroom 1") م² للأطفال الصغار بجوار الجناح مع حمامها المدمج F20 (#ffa("Bedroom 1 bath") م²؛ قرار المالك 14 نوفمبر 2026: الحمام في الزاوية بجانب حمامات الجناح ودُشّه فوق ماسورة الصرف ظهرًا لظهر مع دُش الجناح، وبابها على الجدار الشرقي للممر بزاوية قائمة مع باب الجناح، وخزانتان مدمجتان؛ وغرفة مرحاض الجناح أعيدت 1.0 × 1.3 م على الجدار المشترك بباب زجاجي إلى الحمام).
      #ah[الشريط الغربي]
      دورة مياه العائلة (مرحاض ومغسلة) من الممر؛ وغرفتا النوم 2 و3 توأم (قرار المالك 15 نوفمبر 2026): لكلٍّ شريط مدخل بعرض 2.55 م، والغرفتان الرئيسيتان متساويتان (14.44 م² صافية)، وحمامهما ظهرًا لظهر بينهما بماسورة واحدة تنزل في حجرة مرحاض دورة المياه الأرضية؛ والممر يمتد إلى y 20.55 فوق موضع العتبة القديمة بباب زجاجي على الفناء.
      #ah[الجنوب والشرق]
      النادي غربا #ffa("Gym") م² (بابه من الفناء بجانب نهاية الممر، 15 نوفمبر 2026)، وفناء الجناح #ffa("Suite court (open to the sky)") م² المفتوح للسماء من النادي إلى المكتب (غرفة شمس الشتاء للعائلة، قرار المالك 10 نوفمبر 2026: كرسيان بظهر وطاولة صغيرة في وسطه الشمالي خارج شريط الأبواب، مقبس وإضاءة جدارية عند باب المكتب، وألواح المشربية الوسطى تُفتح شتاءً وتُغلق بإحكام في الغبار)، ومكتب المالك شرقا #ffa("Owner's office") م² بلا باب إلى غرفة النوم (يُدخل إليه من فناء الجناح فقط)، وجناح النوم الرئيسي #n2(suite-area) م² بمدخل من وصلة العائلة.
    ]
  ],
)

// ===================================================================================== SHEET 04 · first floor family part
#pagebreak()
#sheet-head([First floor / the family part], [Kids' room, family living, bedrooms 1–3, family bath, gallery on the west projection | furnished test from studies/ff_family.typ])
#let fam-focus = ("Upper gallery (on the west projection)", "Linen cupboard", "Bedroom 2 bath (en-suite)", "Family WC (gallery)", "Bedroom 2", "Bedroom 3 bath", "Bedroom 3", "Kids' room (study + gaming)", "Family living", "Family link", "Bedroom 1", "Bedroom 1 bath", "Stair (arrives at its south end)", "Lift shaft", "West shaft", "Air tower", "Courtyard (open to the sky)", "Double-height living (void)")
#grid(columns: (auto, 1fr), column-gutter: 18pt,
  cetz.canvas(length: 1.0cm, {
    import cetz.draw: *
    draw-floor(ff-rooms.filter(r => bbox(r.P).at(1) < 19.2), ff-walls, ff-doors.filter(d => d.a.at(1) < 20.6), ff-windows.filter(w => w.at(0).at(1) < 19.2), ff-furniture.filter(f => f.at(1) < 19.2), dashed: beam, focus: fam-focus, label-at: ff-label-at)
    let b2 = bbox(room-of(ff-rooms, "Bedroom 2").P)
    dim((b2.at(0), 11.0), (b2.at(2), 11.0), (0, 0.45), [#n2(b2.at(2) - b2.at(0)) m axes · ≈ #n3(sec.pj.room-clear) m clear])
    dim((0, 0), (0, sec.y-living), (-0.8, 0), [#n2(sec.y-living) m])
    scale-bar((0, 20.0))
  }),
  [
    #en[
      *Kids' room* #wd(ff-rooms, "Kids' room (study + gaming)") m: two study desks and a PC desk under the north window, a gaming corner; solid door from the gallery. *Family living* #wd(ff-rooms, "Family living") m on the courtyard edge: a view, not a path.

      *Bedrooms 2 and 3 as twins* (owner, 15 Nov 2026, `studies/west_wing_ff.typ` adopted as drawn): each entered through an entry strip 2.55 m wide with a wall straight ahead, then a main room *4.03 × 3.5 clear = 14.44 m²*; bedroom 2 #ffa("Bedroom 2") m² (its strip beside the shaft, its door on the gallery facing the shaft), bedroom 3 #ffa("Bedroom 3") m² (a full rectangle to y 19.25, its strip taken from the gym, its door on x 4.25 from the gallery's end, a 2.55 opening with no leaf on y 19.25); in each the bed's head on the west wall, a desk at the west window, a 1.8 m wardrobe; *bedroom 1* #ffa("Bedroom 1") m² with its own compact bath F20 #ffa("Bedroom 1 bath") m² in the corner beside the suite's wet rooms (14 Nov 2026; its door on the link's east wall; two built-in wardrobes).

      *The bath pair (X3)* between the two bedrooms, y 14.13–15.53: bath 2 #wd(ff-rooms, "Bedroom 2 bath (en-suite)") m west with a small high window, bath 3 #wd(ff-rooms, "Bedroom 3 bath") m east with a fan, one wet wall x 2.10, both wall-hung WCs at its south end over *one stack* (2.10, 15.23) into the GF powder room's WC compartment, the showers and basins in the floor build-up; the gallery extended to y 20.55 over the old nib with a glass door onto the court. The *family WC* #wd(ff-rooms, "Family WC (gallery)") m by the west shaft (14 Nov 2026, as the GF powder room: a basin zone open to the gallery, one basin on the stair wall, no door; a 100 mm partition on x 1.5 with a 0.70 door opening out into the basin zone; a WC-only compartment ≈ 1.33 × 1.10 clear, the wall-hung WC on the west outer wall, its waste to the west shaft, a fan, a high obscure window), for the family living and the kids' room.
    ]
    #ar[
      #ah[غرفة الأطفال: دراسة وألعاب]
      #wd(ff-rooms, "Kids' room (study + gaming)") م: مكتبا دراسة ومكتب كمبيوتر تحت النافذة الشمالية وركن ألعاب، وباب مصمت من الممر. يمكن أن تصبح غرفة نوم رابعة لاحقا.
      #ah[جلسة العائلة]
      #wd(ff-rooms, "Family living") م = #ffa("Family living") م² على حافة الفناء: إطلالة لا ممر، والطريق إلى جناح الوالدين خلف الكنبة.
      #ah[غرف النوم]
      النوم 2 و3 توأم (قرار المالك 15 نوفمبر 2026): تُدخل كلٌّ منهما عبر شريط مدخل بعرض 2.55 م وأمامه جدار ثم الغرفة الرئيسية 4.03 × 3.5 م صافية (14.44 م²)؛ النوم 2 #ffa("Bedroom 2") م² وشريطها بجانب الشفت، والنوم 3 #ffa("Bedroom 3") م² وشريطها مأخوذ من النادي وبابها من نهاية الممر؛ والحمامان ظهرًا لظهر بينهما (#wd(ff-rooms, "Bedroom 2 bath (en-suite)") و#wd(ff-rooms, "Bedroom 3 bath") م) بماسورة واحدة تنزل في حجرة مرحاض دورة المياه الأرضية. النوم 1: #ffa("Bedroom 1") م² مع حمامها المدمج F20 (#ffa("Bedroom 1 bath") م²) في الزاوية بجانب حمامات الجناح (14 نوفمبر 2026).
      #ah[حمام العائلة]
      دورة المياه العائلية #wd(ff-rooms, "Family WC (gallery)") م بجوار الشفت الغربي (14 نوفمبر 2026، مثل دورة المياه الأرضية: منطقة مغسلة مفتوحة على الممر بلا باب، ثم باب 0.70 يفتح إلى الخارج إلى حجرة المرحاض وحده خلف قاطع على x 1.5؛ المرحاض معلق على الجدار الغربي، ونافذة صغيرة عالية فوقه).
      #ah[التخزين]
      دولاب البياضات في نهاية الممر الشمالية (#wd(ff-rooms, "Linen cupboard") م). الدواليب المدمجة صناديق نجارة مثبتة بين الجدارين.
    ]
  ],
)

// ===================================================================================== SHEET 05 · the south wing v2 and the master suite (V8.0)
#pagebreak()
#sheet-head([First floor / the south wing and the master suite], [South wing v2 (owner, V8.0): the gym on the west band, the suite court from the gym to the office, the office on the east | furnished test from studies/ff_suite.typ | orange = the treadmill's clear zones, red = the double wall to bedroom 3 | the three court doors on a 1.2 m strip])
#let l-focus = ("Owner's office", "Gym", "Suite court (open to the sky)", "Suite lobby", "Suite bath", "Suite WC (closet)", "Suite dressing", "Suite bedroom", "Bedroom 1 bath")
#grid(columns: (auto, 1fr), column-gutter: 18pt,
  cetz.canvas(length: 0.82cm, {
    import cetz.draw: *
    draw-floor(ff-rooms.filter(r => bbox(r.P).at(3) > 6.4), ff-walls, ff-doors.filter(d => d.a.at(1) >= 6.4), ff-windows.filter(w => w.at(0).at(1) >= 6.4), ff-furniture.filter(f => f.at(3) > 6.5), acoustic: (suite.acoustic-wall,), focus: l-focus, label-at: ff-label-at)
    for (n, z, w) in suite.tm-zones { rect(q((z.at(0), z.at(1))), q((z.at(2), z.at(3))), fill: orange.transparentize(80%), stroke: (paint: orange, thickness: 0.5pt, dash: "dotted")) }
    rect(q((suite.court-strip.at(0), suite.court-strip.at(1))), q((suite.court-strip.at(2), suite.court-strip.at(3))), stroke: (paint: accent, thickness: 0.6pt, dash: "dotted"))
    line(q((4.25, 24.3)), q((10.0, 24.3)), stroke: (paint: rgb("#8a5a2b"), thickness: 1pt, dash: "dashed")); content(q((7.1, 24.75)), text(7pt, fill: rgb("#8a5a2b"))[south side: mashrabiya PROPOSED (owner's choice)])
    rect(q((4.35, 21.65)), q((4.70, 22.95)), fill: rgb("#c9a86a"), stroke: 0.5pt + dark); content(q((4.1, 22.3)), anchor: "east", text(6pt, fill: rgb("#8a5a2b"))[ladder ↑])   // 15 Nov 2026: 1.0 m south of the gym's court door
    dim((4.25, 24.0), (10.0, 24.0), (0, 1.6), [#n2(10.0 - 4.25) m · the suite court])
    dim((13.311, 6.5), (13.311, sec.y-living), (3.4, 0), [#n2(sec.y-living - 6.5) m · master suite #n2(suite-area) m²])
    scale-bar((0, 26.6))
  }),
  [
    #en[
      *Master suite* #n2(suite-area) m² (14 Nov 2026, the east wing's M3 adopted with the owner's adjustments): the lobby, the dressing #wd(ff-rooms, "Suite dressing") m and the bedroom #ffa("Suite bedroom") m² as before (the bed is not seen from the suite door); *the wet rooms re-planned:* the bath #wd(ff-rooms, "Suite bath") m (#n2(suite-bath) m² with the closet) with the shower on its north wall back to back with bedroom 1's shower over the one stack, the two basins on the east wall (wastes north of the hood), the tub south, its door from the lobby moved 2.2 m south; the *WC closet* 1.0 × 1.3 clear on the shared wall to bedroom 1 (a wall-hung WC on its north wall, a hinged fluted-glass door opening out into the bath, a ducted fan, an acoustic north wall); the corner x 11.5–13.311 × y 6.5–8.0 given to *bedroom 1's bath F20* #ffa("Bedroom 1 bath") m². *No door to the office.* Its court door (sliding glass) opens onto an entry zone formed by a full-height wardrobe: the sight-line test (doors open, from the gym and office doors and from the court seating) keeps the bed out of view.

      *Suite court* #ffa("Suite court (open to the sky)") m² on axes (≈ #n2(suite.court-clear-area) m² clear), open to the sky, from the gym to the office: the three court doors (bedroom, gym, office) on a 1.2 m strip along its north edge, the seating (a sofa, two armchairs, a table, plants) in the south part; the floor falls south to a box gutter with an overflow, linear drains at the near-flush doors. Its south side is the facade frame: a 1.10 m base under R8, the cornice and the parapet; the infill is the owner's choice (a mashrabiya screen recommended). The clerestory windows of the living get the winter noon sun on #sec.pc(sec.light.winter) of their height.

      *Gym* #ffa("Gym") m² on the west band (inside the column frame; 15 Nov 2026: bedroom 3's entry strip x 1.5–4.25 × y 19.25–20.55 taken from it, the old nib now the gallery's end with a glass door onto the court): its door from the court on x 4.25 beside the gallery's end; a pocket x 0–1.5 by the west window for the dumbbell rack; the treadmill 2.0 × 0.8 on the stiff 2.75 m bay (#n2(suite.tm-side) m clear each side, #n2(suite.tm-behind) m behind), a 2.0 × 1.0 mat, a bike, a fixed TV; windows west and south; the double wall to bedroom 3 (Rw ≈ 55 dB) on B22 for x 0–1.5, the strip's light walls beyond.

      *Owner's office* #wd(ff-rooms, "Owner's office") m (east): for the owner only, reached from the suite court (bedroom → court → office; the family gym → court → office); visitors are met in the men's majlis; a simple door, an east window, a fixed TV.

      *Roof ladder (V8.1):* a manufactured vertical ladder in a 0.90 × 0.30 recess of a rendered pilaster on the gym's east wall (north end, off the door strip and the seating), behind a locked walnut-finish panel; 3.70 m to the gym roof, the stiles 1.10 m above it, a self-closing gate in the court guard (`studies/roof.typ` page 2).
    ]
    #ar[
      #ah[جناح النوم الرئيسي · #n2(suite-area) م²]
      الردهة وغرفة الملابس وغرفة النوم كما هي؛ حمامات الجناح أعيد تخطيطها (قرار المالك 14 نوفمبر 2026، M3): الدُش على الجدار الشمالي للحمام ظهرًا لظهر مع دُش غرفة الأطفال فوق ماسورة واحدة، والمغسلتان على الجدار الشرقي، وحوض الاستحمام جنوبًا؛ وغرفة المرحاض 1.0 × 1.3 م على الجدار المشترك مع غرفة الأطفال بمرحاض معلق وباب زجاجي مخطط يفتح إلى الحمام وشفّاط؛ والزاوية x 11.5–13.311 أُعطيت لحمام غرفة الأطفال F20. لا باب بين غرفة النوم والمكتب. باب الفناء الزجاجي المنزلق يفتح على منطقة دخول يكوّنها دولاب كامل الارتفاع، فلا يُرى السرير من باب النادي أو المكتب أو من جلسة الفناء والأبواب مفتوحة.
      #ah[فناء الجناح]
      #ffa("Suite court (open to the sky)") م² مفتوح للسماء من النادي إلى المكتب: الأبواب الثلاثة على ممر بعرض 1.2 م في طرفه الشمالي والجلسة في الجنوب، والأرضية تميل جنوبا إلى مزراب مع فائض، ومصارف خطية أمام الأبواب شبه المستوية. جهته الجنوبية إطار الواجهة بجدار سفلي 1.10 م، والحشوة اختيار المالك (المشربية مقترحة).
      #ah[النادي]
      #ffa("Gym") م² في الشريط الغربي ضمن إطار الأعمدة (15 نوفمبر 2026: شريط مدخل غرفة النوم 3 مأخوذ من طرفه الشمالي، والعتبة القديمة صارت نهاية الممر بباب زجاجي على الفناء)، بابه من الفناء بجانب نهاية الممر: جهاز المشي على البلاطة الصلبة، وبساط ودراجة وتلفاز ثابت، وجيب عند النافذة الغربية لرف الدمبل؛ جدار مزدوج مع غرفة النوم 3.
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

      Guest side (owner, 11 Nov 2026): the guest WC with its 0.90 door from the basins room, back on its south wall as before the redraw (inside only the WC and a shower mixer on the wall: no shower zone, no floor marking), and next to it the three basins in one row, open to the guest passage through a 1.8 m opening; the guest passage and the foyer with a #dw((0, 21.5)) m double door and a #dw((2.75, 22.15)) m opening into the men's majlis (a bent entry, partial).

      *East service block:* kitchen #wd(gf-rooms, "Kitchen") m on the courtyard lines (two parallel runs, no island, door to the dining only); the sink under its courtyard window (y 7.3–8.9, V8.0) with the dishwasher south of it, the outdoor TV on the other face of the wall further south; *V11-idea · NE corner out, 23 Nov 2026: the north-east corner (the maid room, the maid bath and the laundry) is outside the ground floor: open ground 21.83 m² on axes under the first floor, which stands on the corner columns (the slab's underside insulated); the kitchen's north wall and the women's majlis east wall are outside walls; the kitchen's open entrance on y 6.5 is a closed 0.90 door to the open ground.* *The malqaf (V10.0, L5)* is no longer in this block: its core stands at the courtyard's north-west corner (the breeze outlet in the first arch, the filtered supply fan in the foot chamber, the head 1.6 × 2.4 on the roof).
    ]
    #ar[
      #ah[كتلة المغاسل الغربية]
      خط واحد من الغرف الرطبة على خط صرف واحد. جهة العائلة مفتوحة على الرواق: مطبخ الضيافة #wd(gf-rooms, "Hospitality kitchen") م للقهوة والشاي والتمر والحلى، ومغاسل العائلة، ودورة العائلة.
      #ah[ممر التقديم]
      #wd(gf-rooms, "Serving passage (2 doors)") م (#clear-wd(gf-rooms, gf-walls, "Serving passage (2 doors)") م صافي) هو الصلة الوحيدة بين العائلة والضيوف: الباب 1 (#dw((2.75, 16.25)) م) من الرواق والباب 2 (#dw((0.1, 17.5)) م) من جهة الضيوف لا يفتحان معا ويقفلان من جهة العائلة.
      #ah[جهة الضيوف]
      دورة الضيوف بابها من غرفة المغاسل كما كان (قرار المالك 11 نوفمبر 2026؛ داخلها المرحاض وخلاط دش على الجدار فقط، بلا منطقة دش)، وبجوارها ثلاث مغاسل في صف مفتوحة على الممر بفتحة 1.8 م، وممر الضيوف، والبهو بباب مزدوج #dw((0, 21.5)) م وفتحة #dw((2.75, 22.15)) م إلى المجلس (مدخل منكسر جزئي).
      #ah[الكتلة الشرقية]
      المطبخ #wd(gf-rooms, "Kitchen") م على خطوط الفناء بخطي خزائن وبلا جزيرة وبابه إلى الطعام فقط، والحوض تحت نافذته على الفناء (y 7.3–8.9) وغسالة الصحون جنوبه؛ وفكرة 23 نوفمبر 2026: الركن الشمالي الشرقي (غرفة الخادمة وحمامها والغسيل) خارج الدور الأرضي: أرض مكشوفة 21.83 م² تحت الدور الأول القائم على أعمدة الركن، وجدار المطبخ الشمالي وجدار مجلس النساء الشرقي جداران خارجيان، ومدخل المطبخ على y 6.5 باب مغلق 0.90 م؛ والملقف (V10.0) انتقل إلى الركن الشمالي الغربي للفناء: غرفة قاعدته داخل الممر المسقوف، وفتحة النسيم في أول قوس من الرواق مقابل الجلسة، ورأسه 1.6 × 2.4 م فوق السطح.
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
  [#text(12pt, weight: "bold")[Ground floor] #sched(gf-rooms.filter(r => r.id != ""), gf-walls)
    #v(3pt)
    #text(6.8pt, fill: soft)[The owner's review, 10 Nov 2026: G13 is one room with the low part under the stair's half landing (≈ 3.7 m² at 1.65 m headroom, counted in the stair's footprint G12) and one door; its polygon wraps round the west shaft (1.5 × 1.2 m, not counted). G15 redrawn (10 Nov 2026): the WC compartment across the full width (2.75 × 1.55) with only the WC and one basin; two basins outside. G17 1.5 × 1.9 with only the WC and a shower mixer on the wall, its door from the basins room (11 Nov 2026); G18 1.5 × 2.0 next to it, the three basins in one straight row behind a 1.8 m opening. *The maid's wing, layout D (`studies/maid_wing.typ`, adopted):* G07 the laundry across the whole width (y 4.7–6.5, 1.8 m deep since 11 Nov 2026: its kitchen wall on the structural line y 6.5, no jog with the majlis wall; the machines on the kitchen wall, the table on the majlis wall), G05 the maid bath east of the maid room under the step's wall (2.036 × 1.5 on axes, 1.86 × 1.28 clear), G06 the maid room a clean rectangle 2.325 × 4.7 (2.13 × 4.48 clear, ≥ 2.10 wide, V6.4); G21 the store removed. *17 Nov 2026:* the slanted cut wall replaced by one orthogonal step at x 11.275 / y 3.2 and the house 1.3 m further south (`studies/step_corner.typ` option 6): F11 bedroom 1 16.39 m² clear with its bath F20 and the suite's closet untouched. The malqaf chamber (#n2(area(tower-csv)) m² on axes) is not a room.]],
  [#text(12pt, weight: "bold")[First floor] #sched(ff-rooms.filter(r => r.id != ""), ff-walls)
    #v(3pt)
    #text(6.8pt, fill: soft)[*The east wing, 14 Nov 2026 (M3 adopted with the owner's adjustments, `studies/east_wing_ff.typ` page 7):* F20 bedroom 1's own compact bath (1.811 × 2.40 on axes, ≈ 1.6 × 2.2 clear) in the corner x 11.5–13.311 × y 5.6–8.0, half from F11's entry strip and half from the suite's old WC closet; F11 keeps its shape otherwise, its door on the link's east wall, two built-in wardrobes (1.15 × 0.60 and 2.40 × 0.60 clear). F17 the suite's WC closet re-made 1.2 × 1.5 on axes (1.0 × 1.3 clear) on the shared wall; F16 the suite bath 3.011 × 2.45 (shower north, basins east, tub south). F15, F18, F20 unchanged. *The west band, 15 Nov 2026 (twins, `studies/west_wing_ff.typ` adopted as drawn):* F05 bedroom 2 and F07 bedroom 3 each with an entry strip (2.55 clear wide; F05's beside the shaft, F07's taken from the gym) and an equal main room (4.03 × 3.5 clear, 14.44 m²); F04 / F06 the bath pair back to back at y 14.13–15.53 on one stack into the GF powder room's WC compartment; F13 the gym without the strip and the nib (a pocket for the dumbbell rack), its door from the court; F01 the gallery to y 20.55 with a glass door onto the court.]
    #v(3pt)
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
#table(columns: (auto, auto, 1.3fr, 1fr, 1.15fr), stroke: none, inset: 0.4pt, fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
  ..([Ver.], [Topic], [Decision], [Reason], align(right, text(lang: "ar", dir: rtl)[القرار والسبب])).map(c => text(8.5pt, weight: "bold", fill: accent, c)),
  ..decisions.map(d => (text(3.9pt)[#d.version], text(3.9pt, weight: "bold")[#d.topic], text(3.9pt)[#fill-in(d.decision)], text(3.9pt)[#fill-in(d.reason)], align(right, text(4.3pt, lang: "ar", dir: rtl)[#fill-in(d.ar)]))).flatten())   // 17 Nov 2026: 3.9 / 4.3 pt, inset 0.4 so the 12 sheets hold the 71 rows (3 Nov 2026: 4.0 / 4.4 pt for 57)

// ===================================================================================== SHEET 10 · open items
#pagebreak()
#sheet-head([Open items / for the owner and the engineers], [From data/open_items.csv (the same list as docs/OPEN_LIST.md) | orange = the edge beam and the #sec.pj.columns columns, red = the acoustic wall gym ↔ bedroom 3 | the roof ladder in the suite court])
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
  table(columns: (auto, auto, 1.1fr, 1fr, 1fr), stroke: none, inset: 2.1pt, fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
    ..([No.], [For], [Item], [Action], align(right, text(lang: "ar", dir: rtl)[البند])).map(c => text(8.5pt, weight: "bold", fill: accent, c)),
    ..items.enumerate().map(((i, o)) => (text(6.6pt, weight: "bold")[#(i + 1)], text(6.6pt)[#o.group], text(6.6pt)[#fill-in(o.item)], text(6.6pt)[#fill-in(o.action)], align(right, text(7.0pt, lang: "ar", dir: rtl)[#fill-in(o.ar)]))).flatten()),   // V10.0: 22 items
)

// ===================================================================================== SHEET 11 · roof plan (V7.0)
#pagebreak()
#sheet-head([Roof plan / the roof ladder, the set-back attic, the set-back guardrail and the reserved zones], [studies/roof.typ (V8.1: the roof by a maintenance ladder in the suite court; the internal stair stops at the first floor; V10.0: the malqaf head at the courtyard's north-west corner, L5; no HRV, no plant room) | flat roof, no tiles | the attic 1.38 m above the finish, set back 1.0 m | the south parapet 0.70 m with a 1.10 m guardrail set back 1.0 m | zones reserved, not designed | all sizes assumed])
#grid(columns: (auto, 1fr), column-gutter: 18pt,
  rf.plan(length: 0.86cm),
  [
    #en[
      *Access (V8.1):* by a *maintenance ladder in the suite court*: a manufactured vertical ladder in a 0.90 × 0.30 recess of a rendered pilaster on the gym's east wall, behind a locked walnut-finish panel (not climbable when closed); #n2(rf.lad-climb) m from the court floor to the gym roof, the stiles 1.10 m above the roof as the transfer handholds (+#rf.f2(rf.lad.stile-top)), a self-closing gate in the court's west guard, a landing pad inside the guarded zone; a fall-arrest rail, to be confirmed by the specialist. The internal stair stops at the first floor; the roof slab over the well is closed; no door from the roof into the house. The lift stops at the first floor: headroom to the roof slab underside #n2(rf.lift-avail) m (a lift with ≤ 3.40 m, or ≤ 3.70 m with a 0.30 m raised head hidden behind the cornice; open item 15).

      *Roofline (V8.1, lower and balanced; V10.0 render, no stone):* a rendered *main cornice* #n2(rf.cornice.h) × #n2(rf.cornice.proj) m at +#rf.f2(rf.cornice.z0) … +#rf.f2(rf.cornice.z0 + rf.cornice.h) all round; on the north block a coped upstand to +#rf.f2(rf.coping-top) and the *attic screen* #n2(rf.attic-vis) m above the roof finish (coping +#rf.f2(rf.attic-top)) set back #n2(rf.setback) m on all four sides; the *south wing* a low parapet #n2(rf.parapet-vis) m above the finish (+#rf.f2(rf.south-top)) and a *continuous 1.10 m black steel guardrail set back #n2(rf.rail-setback) m* (not seen from the street; the strip outside it a no-go zone): the roofline steps #n2(rf.step) m. Above the attic only the *malqaf head* (V10.0, L5: 1.6 × 2.4, +#rf.f2(rf.tower-top)) at the courtyard's north-west corner, on the shaft and the gallery roof; no plant room (the filtered fan is in the malqaf's foot chamber). The attic hides 1.2 m condensers on pads and the tank from every distance (§ 3 of the study). The attic never cuts the courtyard's sky or sun.

      *Zones (reserved):* no plant room (V10.0: the filtered fan sits in the malqaf's foot chamber); the AC units behind the cut / east attic wall; water tank(s) between the roof beams R10 and R3; PV on the gym roof and the office roof inside the guardrail and, later, on the north block's east roof; the 1.0 m strip in front of the attic (a no-go zone) with its own outlets; #rf.outlets.len() roof outlets to internal downpipes, falls 1.5 %; 0.9 m walkways from the ladder's landing pad through the attic opening at x 2.1–2.9 to every zone, with a branch to the office roof; the guarding continuous from the ladder to every piece of equipment (checked).
    ]
    #table(columns: (1.4fr, auto, 2.4fr), inset: 3pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      ..([Zone], [m²], [Note]).map(c => text(8.5pt, weight: "bold", fill: accent, c)),
      ..rf.zones.map(((n, a, note)) => (text(8pt, n), text(8pt)[#rf.r1(a)], text(8pt, note))).flatten())
    #ar[
      #ah[السطح]
      الوصول إلى السطح بسلم صيانة ثابت في فناء الجناح خلف لوح مقفل (V8.1)، والدرج الداخلي يتوقف عند الدور الأول وبلاطة السطح فوق البئر مغلقة؛ المصعد يقف في الدور الأول. كورنيش رئيسي من الحجر العسلي حول البيت، وعلى الكتلة الشمالية حاجز سطح بارتفاع #n2(rf.attic-h) م مرتدّ #n2(rf.setback) م خلف الكورنيش يخفي المعدات؛ رأس الملقف (L5) في الركن الشمالي الغربي للفناء فوق المجرى وسقف الممر، ولا غرفة معدات على السطح؛ الجناح الجنوبي بدروة منخفضة 0.70 م ودرابزين مرتد 1.10 م فيتدرّج خط السطح #n2(rf.step) م. مناطق محجوزة: وحدات التكييف خلف العلية، الخزان، الألواح الشمسية، الممرات والمصارف والحواجز.
    ]
  ],
)

// ===================================================================================== SHEET 12 · elevations and the sight lines (V7.0)
#pagebreak()
#sheet-head([Elevations / the lowered roofline and the sight lines], [studies/roof.typ (V8.1; V10.0 render and paint, no stone) | light sand render; the plinth, the corners, the band between the floors and the main cornice formed in the structure, in a calm honey tone | black steel divided-lite windows | the attic set back 1.0 m | openings indicative])
#grid(columns: (auto, auto, auto), column-gutter: 14pt, rf.north-elev(length: 0.5cm), rf.east-elev(length: 0.42cm), rf.west-elev(length: 0.42cm))
#v(6pt)
#grid(columns: (auto, 1fr), column-gutter: 18pt,
  rf.sight(length: 0.5cm),
  [
    #en[
      *Sight lines* (eye 1.6 m above the ground, +#rf.f2(rf.eye) against the house): from the north boundary (D = #n2(rf.D-north) m) the cornice coping (+#rf.f2(rf.coping-top)) is seen at #rf.r1(rf.ang(rf.D-north, 0, rf.coping-top))° and the attic coping at #rf.r1(rf.ang(rf.D-north, rf.setback, rf.attic-top))°: the attic hidden behind the cornice (its coping #calc.round(-rf.attic-peek * 1000) mm below the line; V9.2: the attic 2 cm lower). Nothing stands above the attic but the malqaf head (V10.0, L5: at the courtyard's north-west corner, hidden from the gate by the north facade, seen whole from the courtyard). The attic (V9.2: #n2(rf.attic-vis) m above the finish; V8.1 1.40) hides 1.2 m condensers on 0.10 pads (+#rf.f2(rf.cond-top)) and the tank from the street and the lane at every distance: the minimum height is #n2(rf.attic-min) m; the units are specified ≤ 1.2 m high.

      *Elevations:* the main cornice (#n2(rf.cornice.h) m, projecting #n2(rf.cornice.proj)) at +#rf.f2(rf.cornice.z0); the thin band at +#rf.f2(rf.band.z0); the plinth to +0.60 and the quoins formed in the structure, rendered in the honey tone (V10.0: no stone anywhere); the north block's coping +#rf.f2(rf.coping-top) with the attic (+#rf.f2(rf.attic-top)) 1.0 m behind it; the south wing's low parapet +#rf.f2(rf.south-top) with the guardrail set back behind it; the malqaf head +#rf.f2(rf.tower-top) at the courtyard's north-west corner (V10.0, L5: 3 / 5 slender arched slots per face, the Hijazi cornice, render and paint); on the east the office's window and the outdoor kitchen's counter at the south end (V8.1). No element above the attic on the west.
    ]
    #ar[
      #ah[الواجهات وخطوط النظر]
      من حدّ الأرض الشمالي تختفي العِلّية خلف الكورنيش (خُفّضت 2 سم)، ولا شيء فوقها إلا رأس الملقف في ركن الفناء الشمالي الغربي؛ العلية بارتفاع 1.38 م تخفي المعدات، والدروة الجنوبية 0.70 م مع درابزين مرتد لا يُرى من الشارع. الواجهات: لياسة كريمية، حجر عسلي في القاعدة والزوايا والشريط بين الدورين والكورنيش الرئيسي، نوافذ فولاذية سوداء مقسّمة.
    ]
  ],
)

// ---------- the two room schedules as data (typst eval --in presentation.typ "query(<schedules>).first().value"; used for docs/PROJECT_V9.md) ----------
#let sched-data(rooms, spec) = rooms.filter(r => r.id != "").map(r => { let (x0, y0, x1, y1) = bbox(r.P); (id: r.id, name: r.name, size: if is-rect(r.P) { n2(x1 - x0) + " × " + n2(y1 - y0) } else { "polygon" }, axes: n2(area(r.P)), clear: if r.kind in ("open", "court") { "–" } else { n2(area(clear-poly(r, spec))) }) })
#metadata((gf: sched-data(gf-rooms, gf-walls), ff: sched-data(ff-rooms, ff-walls), vals: vals, footprint: n2(footprint), gf-area: n2(gf-area), ff-area: n2(ff-area), suite: n2(suite-area), court-clear: court-clear, palms: (n2(palm-gap(T1)), n2(palm-gap(T2))))) <schedules>

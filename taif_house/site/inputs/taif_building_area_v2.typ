// Taif / Palm House · Building area for ground-floor design
// Site baseline v2 · field check 03 Oct 2026 · concept baseline, not for permit
// Design frame: origin = peg M1 (gate east post G′) · y = metres along the M line, southwards
//               x = metres square to the M line, east positive (towards the lane)
#import "@preview/cetz:0.4.2"

#set page(paper: "a4", flipped: true, margin: 9mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 8pt)
#set par(leading: 0.4em)

// ---------- Colours ----------
#let ink    = rgb("#3d4a45")
#let accent = rgb("#2f6b4f")
#let envc   = rgb("#e3f0dd")
#let setb   = rgb("#f4c6c6")
#let drive  = rgb("#d6e2ee")
#let navy   = rgb("#2f5f8a")
#let brown  = rgb("#8a5a2b")
#let warn   = rgb("#b5452f")
#let grid-c = rgb("#d9dcd6")

// ---------- Geometry (design frame, metres) ----------
#let q(x, y) = (x, -y)
#let land  = ((0.0, 0.0), (8.64, -1.59), (11.96, 0.17), (15.39, 6.51), (15.68, 7.37), (16.75, 7.83), (20.19, 13.91), (23.02, 20.37), (26.74, 33.94), (0.0, 38.86))     // build land: north wall · lane (deed) · illustrative south line · M line
#let env   = ((0.0, 38.86), (0.0, 3.05), (9.18, 1.36), (9.67, 1.22), (10.48, 1.65), (13.55, 7.3), (14.06, 8.86), (15.35, 9.4), (18.4, 14.8), (21.13, 21.04), (24.77, 34.3))     // buildable envelope after setbacks (3 m north, 2 m lane)
#let drv   = ((-3.95, 0.73), (0, 0), (0, 38.86), (-3.95, 39.59))
#let lane  = ((8.64, -1.59), (11.96, 0.17), (15.39, 6.51), (15.68, 7.37), (16.75, 7.83), (20.19, 13.91), (23.02, 20.37), (27.07, 35.15))
#let nwall = ((-6.5, 1.2), (8.64, -1.59))
#let south = ((0, 38.86), (26.75, 33.93))
#let T1 = (20.6, 28.09)
#let T2 = (21.39, 31.87)
#let D  = (-5.49, 27.89)
#let Ms = ((0, 0), (0, 6.36), (0, 18.52), (0, 28.8))
#let north = (0.365, 0.931)

#let poly(pts, ..args) = cetz.draw.line(..pts.map(p => q(..p)), close: true, ..args)
#let lab(p, body, size: 6.5pt, fill: ink, anchor: "center", angle: 0deg) = cetz.draw.content(q(..p), anchor: anchor, angle: angle, text(size, fill: fill, body))
#let dim(y, x2, label) = {
  cetz.draw.line(q(0, y), q(x2, y), stroke: (paint: accent, thickness: 0.6pt, dash: "dashed"),
    mark: (start: "stealth", end: "stealth", fill: accent, scale: 0.45))
  cetz.draw.content(q(x2 / 2, y - 0.6), box(fill: envc, inset: 1pt, text(6.5pt, weight: "bold", fill: accent, label)))
}

#let plan = cetz.canvas(length: 0.4cm, {
  import cetz.draw: *
  // 1 m grid, 5 m labels
  for x in range(-6, 29) { line(q(x, -2), q(x, 40), stroke: (paint: grid-c, thickness: if calc.rem(x, 5) == 0 { 0.5pt } else { 0.2pt })) }
  for y in range(-2, 41) { line(q(-6, y), q(28, y), stroke: (paint: grid-c, thickness: if calc.rem(y, 5) == 0 { 0.5pt } else { 0.2pt })) }
  for x in range(-5, 29, step: 5) { lab((x, -2.8), str(x), size: 5.5pt, fill: gray) }
  for y in range(0, 41, step: 5) { lab((-6.9, y), str(y), size: 5.5pt, fill: gray) }
  lab((11, -3.8), [x (m) → east], size: 6pt, fill: gray)
  lab((-8.2, 20), [y (m) ↓ along the M line], size: 6pt, fill: gray, angle: 90deg)

  poly(land, fill: setb, stroke: none)
  poly(env, fill: envc, stroke: 0.9pt + accent)
  poly(drv, fill: drive, stroke: 0.4pt + navy)
  line(..nwall.map(p => q(..p)), stroke: 1.6pt + black)
  line(..lane.map(p => q(..p)), stroke: 1.6pt + black)
  line(..south.map(p => q(..p)), stroke: (paint: accent, thickness: 1.2pt, dash: "dashed"))
  line(q(0, 0), q(0, 38.86), stroke: 1.4pt + accent)

  for p in Ms { rect(q(p.at(0) - 0.35, p.at(1) - 0.35), q(p.at(0) + 0.35, p.at(1) + 0.35), fill: accent, stroke: none) }
  lab((0.6, 0.9), [*M1 = G′* (0, 0)], size: 6pt, fill: accent, anchor: "west")
  lab((0.6, 6.36), [*M2* 6.36], size: 6pt, fill: accent, anchor: "west")
  lab((0.6, 18.52), [*M3* 18.52], size: 6pt, fill: accent, anchor: "west")
  lab((0.6, 28.8), [*M4* 28.80], size: 6pt, fill: accent, anchor: "west")
  circle(q(..D), radius: 0.35, fill: brown, stroke: none)
  lab((D.at(0) - 0.6, D.at(1)), [*D* dakka corner], size: 5.8pt, fill: brown, anchor: "east")
  for (p, n) in ((T1, [palm 1]), (T2, [palm 2])) {
    circle(q(..p), radius: 0.26, fill: accent, stroke: none)
    circle(q(..p), radius: 1.0, stroke: (paint: accent, thickness: 0.4pt, dash: "dotted"))
    lab((p.at(0) - 1.3, p.at(1)), text(weight: "bold", n), size: 6pt, fill: accent, anchor: "east")
  }
  dim(10, 15.69, [15.69 m])
  dim(20, 20.68, [20.68 m])
  dim(30, 23.59, [23.59 m])
  lab((9, 15), text(weight: "bold")[BUILDABLE\ ENVELOPE\ ≈ 668 m²], size: 9pt, fill: accent)
  lab((-2, 14), [DRIVEWAY 4.00 m], size: 6pt, fill: navy, angle: 90deg)
  lab((3, -1.9), [NORTH STREET WALL], size: 6pt, fill: gray, angle: 10.4deg)
  lab((19.5, 9.5), [LANE WALL = deed line], size: 6pt, fill: gray, angle: -61deg)
  lab((13, 37.6), [south line: illustrative only], size: 6pt, fill: accent, angle: 10.4deg)
  // north arrow
  line(q(24, 1.5), (24 + 2.2 * north.at(0), -1.5 + 2.2 * north.at(1)), stroke: 1pt + ink, mark: (end: "stealth", fill: ink, scale: 0.7))
  lab((24 + 2.6 * north.at(0), -1.5 + 2.6 * north.at(1) - 0.0 * 1), text(weight: "bold")[N], size: 8pt)
  line(q(16, 41.5), q(26, 41.5), stroke: 1.5pt + ink)
  lab((21, 42.4), [10 m], size: 6pt)
})

#let head(title, sub) = [
  #set par(leading: 0.55em)
  #text(15pt, weight: "bold", fill: accent)[Taif / Palm House] \
  #text(10pt, weight: "bold")[#title] #h(1fr) #text(8pt, fill: gray)[03 Oct 2026] \
  #text(7.5pt, fill: gray, sub)
  #v(3pt) #line(length: 100%, stroke: 0.6pt + accent) #v(4pt)
]
#let sub-head(t) = [#v(5pt) #text(9pt, weight: "bold", fill: accent, t) #v(1pt)]
#let tbl(columns: (1fr, auto), ..cells) = text(7pt, table(
  columns: columns, stroke: none, inset: (x: 4pt, y: 2.6pt),
  fill: (_, y) => if y == 0 { rgb("#e1e9e3") } else if calc.even(y) { rgb("#efece4") },
  ..cells))

// =====================================================================
// PAGE 1 · The building area
// =====================================================================
#grid(columns: (auto, 1fr), column-gutter: 14pt,
  plan,
  [
    #head([Building area for the ground floor], [Site baseline v2 · design frame tied to the M pegs on the ground])

    #sub-head[The design frame]
    #text(7.4pt)[
      *Origin* = peg M1, the inner face of the gate east post (G′). \
      *y* = metres along the straight M line, southwards (pegs M2 6.36 · M3 18.52 · M4 28.80). \
      *x* = metres square to the M line, east (towards the lane). \
      The M line is the driveway's east edge and the build land's west edge: no setback on this side. \
      The north wall is not square to the M line: it meets it at ≈ 100°, so the north setback line rises ≈ 0.18 m for every metre east.
    ]

    #sub-head[Key numbers]
    #tbl(columns: (1fr, auto),
      table.header([*Item*], [*Value*]),
      [Build land (to the illustrative south line)], [≈ 774 m²],
      [Setback strips inside it (pink)], [≈ 106 m²],
      [Buildable envelope (green)], [*≈ 668 m²*],
      [Envelope depth along the M line], [≈ 3.0 → 38.9 m],
      [Envelope width at y = 10 / 20 / 30 m], [15.69 / 20.68 / 23.59 m],
      [Setbacks], [3 m north street · 2 m lane],
      [Driveway (west of the M line)], [4.00 m gate · ≈ 3.95 m clear],
    )

    #sub-head[Palms (trunk Ø 0.53 m, drawn to scale; dotted = 1 m ring)]
    #tbl(columns: (auto, auto, auto, 1fr),
      table.header([*Palm*], [*x*], [*y*], [*Trunk centre to lane line*]),
      [Palm 1 (north)], [20.60], [28.09], [4.38 m (face ≈ 2.1 m inside the setback line)],
      [Palm 2 (south)], [21.39], [31.87], [4.61 m (face ≈ 2.35 m inside the setback line)],
    )

    #sub-head[Rules for designing on this sheet]
    #text(7.2pt)[
      1. Keep every wall inside the green envelope. \
      2. Leave ≥ 0.5 m spare to the north and lane setback lines until the outline is strung on the ground. \
      3. The south line is your choice: moving it south adds envelope; the table on page 2 runs to y = 38. \
      4. Before the design is final: string the outline on site from pegs M1–M4, square off the M line.
    ]

    #sub-head[Tolerances]
    #text(6.8pt, fill: gray)[
      Fit of 44 tapes, rms 0.27 m. Driveway angle ±2.5° (≈ ±1.5 m at the south end, relative to the lane wall; the M pegs themselves are on the ground). Palms ±0.3 m. Lane wall within 0.1–0.4 m of the deed line. Old house not measured, not shown. Concept baseline – not for permit.
    ]
  ],
)

// =====================================================================
// PAGE 2 · Tables
// =====================================================================
#pagebreak()
#head([Building area · coordinate tables], [All values in metres in the design frame (origin M1, y along the M line southwards, x east)])

#grid(columns: (1fr, 1fr, 1.15fr), column-gutter: 16pt,
  [
    #sub-head[Envelope width along the M line]
    #tbl(columns: (auto, auto, auto, auto),
      table.header([*y*], [*x from*], [*x to*], [*Width*]),
      [2], [5.70], [10.67], [*4.97*],
      [4], [0.00], [11.76], [*11.76*],
      [6], [0.00], [12.84], [*12.84*],
      [8], [0.00], [13.78], [*13.78*],
      [10], [0.00], [15.69], [*15.69*],
      [12], [0.00], [16.82], [*16.82*],
      [14], [0.00], [17.95], [*17.95*],
      [16], [0.00], [18.92], [*18.92*],
      [18], [0.00], [19.80], [*19.80*],
      [20], [0.00], [20.68], [*20.68*],
      [22], [0.00], [21.39], [*21.39*],
      [24], [0.00], [21.94], [*21.94*],
      [26], [0.00], [22.49], [*22.49*],
      [28], [0.00], [23.04], [*23.04*],
      [30], [0.00], [23.59], [*23.59*],
      [32], [0.00], [24.14], [*24.14*],
      [34], [0.00], [24.69], [*24.69*],
      [36], [0.00], [15.54], [*15.54*],
      [38], [0.00], [4.67], [*4.67*],
    )
    #text(6.5pt, fill: gray)[Rows near y = 2 and y ≥ 36 are cut by the north setback and the illustrative south line.]
  ],
  [
    #sub-head[Buildable envelope corners]
    #tbl(columns: (auto, auto, auto),
      table.header([*Pt*], [*x*], [*y*]),
      [V1], [0.00], [38.86],
      [V2], [0.00], [3.05],
      [V3], [9.18], [1.36],
      [V4], [9.67], [1.22],
      [V5], [10.48], [1.65],
      [V6], [13.55], [7.30],
      [V7], [14.06], [8.86],
      [V8], [15.35], [9.40],
      [V9], [18.40], [14.80],
      [V10], [21.13], [21.04],
      [V11], [24.77], [34.30],
    )
    #sub-head[Build land corners (before setbacks)]
    #tbl(columns: (auto, auto, auto),
      table.header([*Pt*], [*x*], [*y*]),
      [L1], [0.00], [0.00],
      [L2], [8.64], [-1.59],
      [L3], [11.96], [0.17],
      [L4], [15.39], [6.51],
      [L5], [15.68], [7.37],
      [L6], [16.75], [7.83],
      [L7], [20.19], [13.91],
      [L8], [23.02], [20.37],
      [L9], [26.74], [33.94],
      [L10], [0.00], [38.86],
    )
  ],
  [
    #sub-head[Fixed points]
    #tbl(columns: (1fr, auto, auto),
      table.header([*Point*], [*x*], [*y*]),
      [M1 = G′, gate east post], [0.00], [0.00],
      [M2 peg], [0.00], [6.36],
      [M3 peg (front of the majlis door)], [0.00], [18.52],
      [M4 peg], [0.00], [28.80],
      [G, gate west post], [-3.95], [0.73],
      [D, dakka south corner], [-5.49], [27.89],
      [C2, north-east corner], [8.64], [-1.59],
      [Palm 1 centre], [20.60], [28.09],
      [Palm 2 centre], [21.39], [31.87],
      [South line, M-line end], [0.00], [38.86],
      [South line, lane end], [26.75], [33.93],
    )
    #sub-head[How to set a point out on site]
    #text(7.2pt)[
      For a corner at (x, y): measure *y* along the M line from M1 and drive a nail; then measure *x* square to the M line from that nail (3-4-5 triangle). Check it with a second tape from the nearest M peg: distance = √((y − y#sub[peg])² + x²).
    ]
    #sub-head[Source]
    #text(6.8pt, fill: gray)[taif_north_zone_final_v2 (CSV, PDF, DXF, PNG) · field check 03 Oct 2026 · deed 1440 H. Converted to this frame by rotation about M1; no scaling.]
  ],
)

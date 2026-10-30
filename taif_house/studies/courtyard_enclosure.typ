// courtyard_enclosure.typ · Taif / Palm House V6.3 · STUDY: closing the conditioned house around the courtyard (design review Y-01, critical)
// The courtyard stays OPEN TO THE SKY; the three places where the house is open to the courtyard air are closed with black steel windows
// (docs/DESIGN_LANGUAGE.md) on one continuous air / thermal line. Two options for the gallery (≥ 1.20 m clear): A widen the projection,
// B keep it and set the columns outside the window line. DECIDED: option A (owner, 30 Oct 2026, branch work / V6.4): applied to the room CSVs, the studies,
// the structural study and the 3D data. This file stays as the record of the comparison; its "now" column is the V6.3 state (edge x 5.60).
// Stand-alone: the geometry below is copied from data/rooms_gf.csv, data/rooms_ff.csv, studies/structure.typ, studies/sections.typ and 3d/params.yaml
// (CSV frame: x east, y south, wall centre lines; levels above the ground floor's finished level ±0.00).
#import "@preview/cetz:0.4.2"
#set page(paper: "a4", flipped: true, margin: 9mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 7.4pt)
#let ink = rgb("#3d4a45")
#let accent = rgb("#5a7d2a")
#let sky = rgb("#2f5f8a")
#let red = rgb("#b5452f")
#let steel = rgb("#1f2a30")
#let glass = rgb("#9fcbe0")
#let r2(v) = str(calc.round(v, digits: 2))
#let r3(v) = str(calc.round(v, digits: 3))
#let f2(v) = { let s = str(calc.round(v, digits: 2)); if not s.contains(".") { s + ".00" } else if s.split(".").at(1).len() == 1 { s + "0" } else { s } }
#let pc(v) = str(calc.round(v * 100, digits: 1)) + " %"
#let H(body) = text(9.5pt, weight: "bold", fill: accent, body)

// ---------- Geometry as built in V6.3 ----------
#let x-wall = 4.25        // the first-floor rooms' east wall = the ground-floor courtyard / living west line (riwaq east wall), 200 mm
#let x-east = 8.95        // the courtyard's east wall (kitchen below, suite lobby above), 200 mm
#let y0 = 6.5             // the courtyard's north edge (women's majlis glass below, the family living's edge above)
#let y1 = 13.0            // the courtyard / living line (the living's courtyard glass below; the void above)
#let y2 = 19.25           // the living's south wall (men's majlis wall)
#let edge-now = 5.6       // the projection edge: edge beam B3 (0.25 × 0.50 total, upturned 0.30) on the colonnade columns C21–C23
#let wall-half = 0.10
#let plaster = 0.015
#let beam-w = 0.25
#let frame = 0.06
#let sleeve = 0.40
#let col-d = 0.30
#let ff = 3.6
#let slab-top = 3.52
#let slab = 0.20
#let upstand = 0.30
#let roof = 7.2
#let roof-slab = 0.20
#let r11-d = 0.45
#let railing = 1.1
#let sill-gal = slab-top + upstand         // +3.82: the glass sits on the upstand of B3 (0.22 above the finished gallery floor)
#let head = roof - r11-d                    // +6.75: the soffit of the roof edge beams R1 / R2 / R11 = one head line round the courtyard
#let guard = ff + 1.1                       // +4.70: the guarding transom, 1.10 above the gallery floor (laminated glass below it)
#let gf-glass-head = 2.9                    // the living's courtyard glass head (3d/params.yaml)
#let sky-depth = y1 - y0                    // 6.5 m: the sky opening, north–south
#let void-depth = y2 - y1                   // 6.25 m: the double-height void, north–south
#let doors = ((9.3, 10.3, "family bath"), (11.1, 12.1, "bedroom 2"), (15.2, 16.2, "bedroom 3"))   // gallery doors (studies/ff_family.typ, V6.3)
#let col-ys = (y0, y1, y2)

// ---------- The three options: now (railing only), A, B ----------
#let opts = (
  (key: "now", name: [Now (V6.3): railings, open], edge: edge-now, win: none, col: edge-now, note: [railing on the upstand of B3; the columns Ø0.30 (stone sleeve Ø0.40) on the edge line]),
  (key: "A", name: [A · widen the projection by 0.20 m], edge: edge-now + 0.20, win: edge-now + 0.20, col: edge-now + 0.20, note: [B3, R11 and C21–C23 move 0.20 m east to x 5.80; the window on the upstand, the columns in the window line]),
  (key: "B", name: [B · keep 1.35, columns outside the window line], edge: edge-now + 0.35, win: edge-now, col: edge-now + 0.35, note: [the window stays on x 5.60; the columns (and B3, R11) move 0.35 m east to x 5.95 and stand in the courtyard; a 0.35 m ledge outside the glass]),
)
#let inner-face = x-wall + wall-half + plaster                                  // 4.365: the finished face of the rooms' wall on the gallery
#let gal-at-window(o) = if o.win == none { o.edge - beam-w / 2 - inner-face } else { o.win - frame / 2 - inner-face }
#let gal-at-columns(o) = if o.key == "B" { gal-at-window(o) } else { o.col - sleeve / 2 - inner-face }
#let gal-at-doors(o) = gal-at-window(o)                                         // the doors are 0.7–2.2 m from the nearest column (y 9.3–16.2 against y 13.0)
#let sky-axes(o) = x-east - o.edge
#let sky-clear(o) = x-east - wall-half - (o.edge + beam-w / 2)
#let sky-at-col(o) = x-east - wall-half - (o.col + sleeve / 2)
#let sky-area(o) = sky-axes(o) * sky-depth
#let well-ratio(o) = (roof + railing) / sky-axes(o)                             // depth of the well (to the railing top) over its width

// ---------- Daylight: the sky seen as a solid angle (the share of the hemisphere) from two points ----------
// Ω of the rectangle [x0,x1]×[y0,y1] at height z seen from (ex, ey, ez): the signed corner formula (exact for a plane rectangle)
#let Fc(ex, ey, d, x, y) = { let a = x - ex; let b = y - ey; calc.atan(a * b / (d * calc.sqrt(a * a + b * b + d * d))).rad() }
#let omega(e, x0, ya, x1, yb, z) = { let d = z - e.at(2); Fc(e.at(0), e.at(1), d, x1, yb) - Fc(e.at(0), e.at(1), d, x0, yb) - Fc(e.at(0), e.at(1), d, x1, ya) + Fc(e.at(0), e.at(1), d, x0, ya) }
#let hemi(om) = om / (2 * calc.pi)
#let eye-court(o) = ((o.edge + x-east) / 2, (y0 + y1) / 2, 1.2)                 // a seated eye in the middle of the courtyard floor under the sky
#let eye-living = (7.3, 16.1, 1.2)                                              // the seated eye of the light check (sections.typ), middle band
#let sky-from-court(o) = hemi(omega(eye-court(o), o.edge + beam-w / 2, y0, x-east - wall-half, y1, roof))
#let sky-from-living(o) = hemi(omega(eye-living, o.edge + beam-w / 2, y0, x-east - wall-half, y1, roof))   // through the y 13.0 line; the opening is bounded by the roof edge beam R11 on the edge line
#let glazing-factor = 0.75 * 0.85                                               // double low-e glass ≈ 0.75 × frames and divided lites ≈ 0.85: applies to A and B alike (the living's upper window)

// ---------- New glass (approximate areas, between finished faces) ----------
#let gal-glass(o) = if o.key == "B" { ((y2 - wall-half) - (y0 + wall-half)) * (head - sill-gal) } else { ((y1 - y0 - sleeve) + (y2 - y1 - sleeve)) * (head - sill-gal) }
#let fam-glass = (x-east - x-wall - 2 * wall-half) * (head - ff)                // the family living's edge, floor to head
#let liv-glass(o) = (x-east - wall-half - (if o.key == "B" { o.win + frame / 2 } else { o.col + sleeve / 2 })) * (head - gf-glass-head)   // the living's upper window: east of C22 (A), continuous behind it (B)
#let liv-glass-full(o) = (x-east - wall-half - (o.col + sleeve / 2)) * head      // if the ground-floor glass is replaced too (one steel wall ±0.00 … +6.75)
#let new-glass(o) = gal-glass(o) + fam-glass + liv-glass(o)

// ---------- Checks ----------
#let A = opts.at(1)
#let B = opts.at(2)
#let NOW = opts.at(0)
#let checks = (
  ([A: gallery ≥ 1.20 m clear at the columns], gal-at-columns(A) >= 1.2),
  ([A: gallery ≥ 1.20 m clear at the window], gal-at-window(A) >= 1.2),
  ([B: gallery ≥ 1.20 m clear], gal-at-window(B) >= 1.2),
  ([Now: gallery < 1.20 m (the problem the study starts from)], gal-at-columns(NOW) < 1.2),
  ([A: the sky opening stays ≥ 3.0 m on axes], sky-axes(A) >= 3.0),
  ([B: the sky opening stays ≥ 3.0 m on axes], sky-axes(B) >= 3.0),
  ([the columns' structural core (Ø0.30) stays inside the stone sleeve (Ø0.40)], col-d <= sleeve),
)
#let all-ok = checks.all(c => c.at(1))

// ====================================================================================== PAGE 1
#text(14pt, weight: "bold", fill: accent)[Courtyard enclosure study · closing the conditioned house around the open courtyard · Taif / Palm House V7.1]
#v(1pt)
#text(8pt, fill: gray)[Design review Y-01 (critical) · 30 Oct 2026 · the windows follow `docs/DESIGN_LANGUAGE.md` (black steel, divided lites)]
#v(2pt)
#block(fill: rgb("#e4eedf"), inset: 5pt, radius: 2pt, width: 100%)[#text(9pt, weight: "bold", fill: accent)[DECIDED: option A] (owner, 30 Oct 2026, applied in V7.0): the projection 1.55 m, B3 / R11 / C21–C23 at x 5.80, W1 / W2 / W3 as in § 2. The "now" column below is the V6.3 state (edge x 5.60), kept as the record of the comparison.
#v(2pt)
#text(9pt, weight: "bold", fill: accent)[V7.1 (owner, 31 Oct 2026): semicircular heads and the courtyard arcade.] Every enclosure window gets a semicircular (Roman) arched head in black steel with divided lites, the arched head fixed, the rectangular part below with the operable lites; the sill and the guarding transom (+4.70) as in § 2. *W1:* six arched windows 1.60 m wide on the gallery edge, three per column bay, sill +3.82, springing +5.80, crown +6.60, 0.15 m of wall below the R11 / R2 soffit (+6.75): in the courtyard bay they stand over the three bays of the new arcade (y 6.783–8.383, 8.950–10.550, 11.117–12.717), in the void bay on three equal bays (13.242–14.842, 15.325–16.925, 17.408–19.008); the four casements sit in the lower parts. *W2:* two arched windows 1.30 m wide east of C21 (x 6.00–7.30 and 7.55–8.85), floor to the crown +6.60, springing +5.95; the strip x 4.25–5.80 of that edge is the family living's opening to the gallery's north end, no window. *W3:* one arched window 2.80 m wide (the whole space between C22's stone sleeve and the east wall; the brief said ≈ 3.0) over the living's courtyard glass, +3.32 to the crown +6.60, springing +5.20, the two motorised tilt lites in its lower part; 0.15 m of wall to the R2 soffit. *The arcade:* in the courtyard bay only, two slender honey-stone columns Ø0.25 on x 5.80 at y 8.667 and 10.833 (three equal bays of 2.167 m on axes) with three semicircular arch plates under the projection's soffit (+3.27): spans 1.84 / 1.92 / 1.84 m between the sleeves, springing +2.35 / +2.31 / +2.35, crown +3.27; decorative unless the engineer uses the columns (`studies/structure.typ` X18); the living bay keeps no arches. The columns stand 0.78 m clear of the sunken seating's west edge, 1.36 m clear of the riwaq door's swing line, 1.33 m from the riwaq glass face; the malqaf outlet is on the east wall. The courtyard reads as a two-tier arcade: three arches below, three arched windows above.]
#v(4pt)
    #H[1 · What is open today]
The courtyard (#r2(x-east - x-wall) × #r2(sky-depth) m on axes, the sky opening #r2(sky-axes(NOW)) × #r2(sky-depth) m east of the projection) is outdoors, as the owner wants. But three edges of the *conditioned* house are open to its air, so the "closed, filtered house" (R-25) cannot be closed:
- *the gallery's edge* on x #r2(edge-now), y #r2(y0)–#r2(y2) (#r2(y2 - y0) m): a railing on the upturned beam B3, over the sky (y #r2(y0)–#r2(y1)) and over the double-height void (y #r2(y1)–#r2(y2));
- *the family living's edge* on y #r2(y0), x #r2(x-wall)–#r2(x-east) (#r2(x-east - x-wall) m): a railing on the edge beam B2;
- *the living's courtyard side above its glass*: the line y #r2(y1) between C22 and the kitchen wall is open from the glass head +#f2(gf-glass-head) to the roof.

#H[2 · The proposal: one continuous line, three steel windows]
The air / thermal line runs *on the structure that is already there*: along the gallery on the upstand of B3 (the glass sits on the upstand top at +#f2(sill-gal), #r2(sill-gal - ff) above the gallery floor: the splash and dust line of a courtyard), along the family living's edge on B2 from the floor, and on y #r2(y1) over the living's glass up to the roof edge beam R2. All three heads meet the one soffit line of the roof edge beams R1 / R2 / R11 at *+#f2(head)*, so the courtyard reads as one room with one cornice.
#table(columns: (0.75fr, 1.05fr, 1.25fr, 0.35fr, 2.6fr), inset: 2.6pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") },
  [*Window*], [*Line*], [*Sill*], [*Head*], [*Lites and operation*],
  [W1 gallery edge], [x #r2(A.edge) (A) / #r2(B.win) (B), y #r2(y0)–#r2(y2)], [+#f2(sill-gal) (upstand)], [+#f2(head)], [guarding transom at +#f2(guard) (1.10 above the floor), laminated glass below it; above it lites ≈ 0.75 wide; one inward side-hung casement per bay (two bays, four casements) for calm nights and cleaning],
  [W2 family living edge], [y #r2(y0), x #r2(x-wall)–#r2(x-east)], [+#f2(ff) (floor)], [+#f2(head)], [same transom at +#f2(guard), laminated below; two inward casements; no door (the courtyard is reached from the ground floor)],
  [W3 living, upper courtyard side], [y #r2(y1), C22 → x #r2(x-east)], [+#f2(gf-glass-head) (the glass head) or ±0.00 if the ground-floor glass is remade as one steel wall], [+#f2(head)], [transoms at +#f2(gf-glass-head) and +#f2(sill-gal) (the gallery's sill line), lites ≈ 0.75 wide; two motorised bottom-hung tilt lites at +#f2(sill-gal)–+5.40 for the night mode],
)
*Cleaning from inside.* W1: both faces from the gallery: the inside directly, the outside through the open casements (every lite within an arm's reach of a casement, the glass height #r2(head - sill-gal) m). W2: as W1 from the family living. W3: the inside from the living floor with a water-fed pole (top +#f2(head)); the outside from the courtyard floor with the same pole (#r2(head) m) or from the gallery's casement at its west end. The courtyard floor's hose point (Y-04) serves the pole.
*Frames.* Black steel, thermally broken, divided lites, double low-e glass, dust seals, insect screens on the casements. Depth ≈ #r2(frame) m on the line; the stone column sleeves stop at the frame with a sealed joint (A) or stand free (B).
#v(3pt)
#H[3 · The gallery: ≥ 1.20 m clear is the constraint]
Today the gallery is #r3(gal-at-window(NOW)) m clear between the rooms' finished wall face (x #r3(inner-face)) and the upstand of B3, and #r3(gal-at-columns(NOW)) m at the three stone column sleeves (Ø#r2(sleeve)). A window on the line changes little by itself; the columns are the problem. Two ways to reach 1.20 m:
#table(columns: (1.3fr, 1fr, 1fr, 1fr), inset: 2.6pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
  [*Item*], ..opts.map(o => [*#o.name*]),
  [Projection on axes (x #r2(x-wall) → edge beam)], ..opts.map(o => [#f2(o.edge - x-wall) m (edge x #f2(o.edge))]),
  [Window line], ..opts.map(o => if o.win == none [—] else [x #r2(o.win)]),
  [Columns C21–C23 (stone sleeve Ø#r2(sleeve))], ..opts.map(o => [x #r2(o.col)#if o.key == "B" [, 0.35 m outside the glass, free-standing] else [, in the line]]),
  [*Gallery clear · minimum*], ..opts.map(o => [*#r3(calc.min(gal-at-window(o), gal-at-columns(o))) m* #if calc.min(gal-at-window(o), gal-at-columns(o)) >= 1.2 [✓] else [✗ (< 1.20)]]),
  [Gallery clear · at the columns], ..opts.map(o => [#r3(gal-at-columns(o)) m]),
  [Gallery clear · at the window / railing], ..opts.map(o => [#r3(gal-at-window(o)) m]),
  [Gallery clear · at the bedroom doors], ..opts.map(o => [#r3(gal-at-doors(o)) m]),
  [Sky opening, axes (clear · at the columns)], ..opts.map(o => [#f2(sky-axes(o)) (#r3(sky-clear(o)) · #r3(sky-at-col(o))) m]),
  [Sky opening area, axes], ..opts.map(o => [#r2(sky-area(o)) m² (#if o.key == "now" [—] else [−#pc(1 - sky-area(o) / sky-area(NOW))])]),
  [Double-height void, axes (clear)], ..opts.map(o => [#f2(sky-axes(o)) (#r3(sky-clear(o))) m]),
  [Well: depth to the roof railing / width], ..opts.map(o => [#r2(well-ratio(o))]),
  [Sky from a seated eye in the courtyard (share of the hemisphere)], ..opts.map(o => [#pc(sky-from-court(o))]),
  [Sky from the living's seated eye (light check point), through W3], ..opts.map(o => [#pc(sky-from-living(o))#if o.key != "now" [ × #r2(glazing-factor) glass]]),
  [New glass, about (W1 + W2 + W3)], ..opts.map(o => if o.key == "now" [—] else [#r2(new-glass(o)) m² (#r2(gal-glass(o)) + #r2(fam-glass) + #r2(liv-glass(o)))]),
  [Extra slab (first floor + roof strip)], ..opts.map(o => if o.key == "now" [—] else [#r2((o.edge - edge-now) * (y2 - y0)) + #r2((o.edge - edge-now) * sky-depth) m²]),
)
#text(6.6pt, fill: gray)[Clear widths between finished faces: the rooms' wall #r2(2 * wall-half) m + #r2(plaster) plaster; the window frame #r2(frame) m centred on its line; the column sleeve Ø#r2(sleeve) centred on the column. The doors (family bath y 9.3–10.3, bedroom 2 y 11.1–12.1, bedroom 3 y 15.2–16.2) are 0.7–2.2 m from the nearest column. "Sky from …": the solid angle of the sky opening (x from the beam's or the sleeve's face to the kitchen wall face, y #r2(y0)–#r2(y1), at +#f2(roof)) as a share of the hemisphere, the same measure for all three; × #r2(glazing-factor) for the glass of W3 (A and B alike), which today is open.]
#v(2pt)
#H[4 · Recommendation: A]
*A* keeps everything on one line: the beam, the columns, the window and the railing base are the same element, the gallery is #r3(gal-at-window(A)) m clear and #r3(gal-at-columns(A)) m at the columns, the sky loses #pc(1 - sky-area(A) / sky-area(NOW)) of its area and stays #r2(sky-axes(A)) m wide on axes. *B* reaches 1.20 m with no margin (#r3(gal-at-window(B)) m), narrows the sky more (#r2(sky-axes(B)) m: the beam and the roof edge must follow the columns), and adds a #r2(B.edge - B.win) m ledge outside the glass that must be waterproofed, capped and kept clean; its one real gain, free-standing columns in front of a glass wall, is a stronger colonnade image. If the owner wants that image, B is buildable; otherwise A. In both, the two-storey columns, the upturned B3 and R11 stay as decided (X8); only their x changes.
#text(7pt)[#if all-ok [*Study checks passed* (#checks.len())] else [*STUDY CHECKS FAILED:* #checks.filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]]

// ====================================================================================== PAGE 2 · plans
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[Plans of the gallery strip, first floor · now / A / B · the sky opening and the void · about 1:115 on A4]
#v(2pt)
#let plan(o, length: 0.88cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, body, size: 5pt, fill: ink, anchor: "center", angle: 0deg) = content(p, anchor: anchor, angle: angle, text(size, fill: fill, body))
  let q(p) = (p.at(0), -p.at(1))   // CSV y south → canvas down
  let R(x0, ya, x1, yb, fill: none, stroke: none) = rect(q((x0, ya)), q((x1, yb)), fill: fill, stroke: stroke)
  let ya = 5.4; let yb = 20.3; let xa = 3.3; let xb = 9.8
  // rooms west of the wall, the gallery, the sky, the void, the suite
  R(xa, ya, x-wall - wall-half, yb, fill: rgb("#f6e3c0"))
  R(x-wall + wall-half, y0, o.edge + beam-w / 2, y2, fill: rgb("#f2efe8"))
  R(x-wall + wall-half, 3.0, x-east - wall-half, y0 - wall-half, fill: rgb("#fbf2e2"))   // family living (north)
  R(o.edge + beam-w / 2, y0, x-east - wall-half, y1, fill: rgb("#dbe9f4"))               // sky
  R(o.edge + beam-w / 2, y1, x-east - wall-half, y2, fill: rgb("#fbf2e2"))               // void
  R(x-east + wall-half, ya, xb, yb, fill: rgb("#efe0cf"))
  R(xa, y2 + wall-half, x-east + wall-half, yb, fill: rgb("#e9d9c4"))                      // suite court / gym route side
  // walls
  R(x-wall - wall-half, ya, x-wall + wall-half, yb, fill: ink)
  for (d0, d1, n) in doors { R(x-wall - wall-half - 0.01, d0, x-wall + wall-half + 0.01, d1, fill: rgb("#f2efe8")); T(q((x-wall - 0.25, (d0 + d1) / 2)), [#n], size: 3.6pt, anchor: "east") }
  R(x-east - wall-half, ya, x-east + wall-half, yb, fill: ink)
  R(xa, y2 - wall-half, x-east + wall-half, y2 + wall-half, fill: ink)
  R(x-wall - wall-half, y0 - wall-half, x-wall + wall-half, y0 + wall-half, fill: ink)
  // the edge beam B3 (upturned) and, for B, the ledge
  R(o.edge - beam-w / 2, y0, o.edge + beam-w / 2, y2, fill: luma(110))
  if o.key == "B" { R(o.win + frame / 2, y0, o.edge - beam-w / 2, y2, fill: rgb("#d6cfbf")); T(q((o.win + 0.17, 11.2)), [ledge #r2(o.edge - beam-w / 2 - o.win - frame / 2)], size: 3.4pt, angle: 90deg) }
  // windows
  if o.win != none {
    line(q((o.win, y0 + wall-half)), q((o.win, y2 - wall-half)), stroke: 1.6pt + sky)
    line(q((x-wall + wall-half, y0)), q((x-east - wall-half, y0)), stroke: 1.6pt + sky)
    line(q((o.col + sleeve / 2, y1)), q((x-east - wall-half, y1)), stroke: 1.6pt + sky)
    T(q(((x-wall + x-east) / 2, y0 - 0.3)), [W2 family living edge], size: 3.6pt, fill: sky)
    T(q(((o.col + x-east) / 2, y1 + 0.32)), [W3 above the living's glass], size: 3.6pt, fill: sky)
  } else {
    line(q((o.edge, y0)), q((o.edge, y2)), stroke: (paint: red, thickness: 1pt, dash: "dashed"))
    line(q((x-wall + wall-half, y0)), q((x-east - wall-half, y0)), stroke: (paint: red, thickness: 1pt, dash: "dashed"))
    T(q(((o.edge + x-east) / 2, y1 + 0.32)), [open +#f2(gf-glass-head) → roof], size: 3.6pt, fill: red)
  }
  // columns
  for y in col-ys { circle(q((o.col, y)), radius: sleeve / 2, fill: rgb("#d8c4a0"), stroke: 0.5pt + ink); circle(q((o.col, y)), radius: col-d / 2, fill: none, stroke: 0.3pt + ink) }
  T(q((o.col + 0.35, y0 - 0.05)), [C21], size: 3.6pt, anchor: "west"); T(q((o.col + 0.35, y1 - 0.3)), [C22], size: 3.6pt, anchor: "west"); T(q((o.col - 0.35, y2 + 0.45)), [C23], size: 3.6pt, anchor: "east")
  // labels
  T(q((3.7, 12.7)), [bedroom 2], size: 4.2pt); T(q((3.7, 17.6)), [bedroom 3], size: 4.2pt); T(q((3.7, 8.0)), [family\ bath], size: 4.2pt)
  T(q(((x-wall + o.edge) / 2, 14.0)), [gallery], size: 4.2pt, angle: 90deg)
  T(q(((o.edge + x-east) / 2, 9.6)), [SKY\ #f2(sky-axes(o)) × #f2(sky-depth)\ #if o.win == none [railing on the edge: open] else [W1 on x #f2(o.win), west edge]], size: 4.2pt, fill: if o.win == none { red } else { sky })
  T(q(((o.edge + x-east) / 2, 16.0)), [VOID over\ the living\ #f2(sky-axes(o)) × #f2(void-depth)], size: 4.4pt)
  T(q((9.4, 9.0)), [suite\ lobby], size: 4pt); T(q((9.4, 16.0)), [suite\ bedroom], size: 4pt); T(q((6.6, 4.3)), [family living], size: 4.2pt)
  T(q((6.6, 19.9)), [suite court · gym route], size: 3.8pt)
  // dimensions
  let dim(xa0, xb0, y, l, col: ink) = { line(q((xa0, y)), q((xb0, y)), stroke: 0.45pt + col, mark: (start: "|", end: "|", scale: 0.35)); T(q(((xa0 + xb0) / 2, y - 0.22)), l, size: 3.8pt, fill: col) }
  dim(inner-face, if o.win == none { o.edge - beam-w / 2 } else { o.win - frame / 2 }, 11.5, [#r3(gal-at-window(o)) clear], col: red)
  if o.key != "B" { dim(inner-face, o.col - sleeve / 2, y1 - 0.0, [#r3(gal-at-columns(o))], col: red) }
  dim(o.edge + beam-w / 2, x-east - wall-half, 7.0, [sky #r3(sky-clear(o)) clear], col: sky)
  dim(x-wall, o.edge, 5.85, [#f2(o.edge - x-wall)], col: ink)
  T(q(((xa + xb) / 2, ya - 0.35)), [#o.name], size: 5.2pt, fill: accent)
  T(q((xa, yb + 0.35)), [N ↑ is up the page · x east → · CSV frame], size: 3.6pt, fill: gray, anchor: "west")
})
#grid(columns: 3, gutter: 14pt, ..opts.map(o => plan(o)))
#v(2pt)
#text(6.8pt)[Dark: walls and the edge beam B3 (0.25 wide, upturned 0.30 above the slab). Blue lines: the new steel windows W1 / W2 / W3; red dashed: the open railings of today. Columns: the stone sleeve Ø#r2(sleeve) round the Ø#r2(col-d) core. In B the beam and the columns leave the window line and a #r2(B.edge - beam-w / 2 - B.win - frame / 2) m ledge lies between the glass and the beam (capped in stone, falling to the courtyard). The gallery doors are the V6.3 1.00 m openings.]

// ====================================================================================== PAGE 3 · sections and elevation
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[Sections through the courtyard (y ≈ 10, looking north) · A and B · about 1:105 on A4]
#v(2pt)
#let section(o, length: 0.95cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, body, size: 5pt, fill: ink, anchor: "center", angle: 0deg) = content(p, anchor: anchor, angle: angle, text(size, fill: fill, body))
  let R(x0, z0, x1, z1, fill: none, stroke: none) = rect((x0, z0), (x1, z1), fill: fill, stroke: stroke)
  let xa = 3.3; let xb = 9.9; let top = roof + railing + 0.4
  line((xa - 0.2, 0), (xb + 0.2, 0), stroke: 1pt + ink)
  // rooms
  R(xa, 0, x-wall - wall-half, ff - slab - 0.08 + slab, fill: rgb("#f2efe8"))       // riwaq (GF)
  R(x-wall + wall-half, 0, x-east - wall-half, slab-top, fill: rgb("#dbe9f4"))   // courtyard (GF), sky above
  R(x-east + wall-half, 0, xb, slab-top, fill: rgb("#f6e3c0"))                   // kitchen
  R(xa, ff, x-wall - wall-half, roof - roof-slab, fill: rgb("#f6e3c0"))           // bedroom 2
  R(x-wall + wall-half, ff, o.edge - beam-w / 2, roof - roof-slab, fill: rgb("#f2efe8"))   // gallery
  R(x-east + wall-half, ff, xb, roof - roof-slab, fill: rgb("#efe0cf"))         // suite lobby / dressing
  // GF walls, the riwaq glass line, the kitchen wall
  R(x-wall - wall-half, 0, x-wall + wall-half, slab-top, fill: ink)
  R(x-east - wall-half, 0, x-east + wall-half, roof, fill: ink)
  // the column beyond the cut (C22 at y 13.0): dashed sleeve to the roof
  R(o.col - sleeve / 2, 0, o.col + sleeve / 2, roof, fill: rgb("#e7d8b8"), stroke: (paint: ink, thickness: 0.4pt, dash: "dashed"))
  T((o.col, -0.45), [C22 beyond (Ø#r2(sleeve) sleeve)], size: 3.6pt, fill: red)
  // first-floor slab: west band to the beam; B3 upturned at the edge
  R(xa, slab-top - slab, o.edge + beam-w / 2, slab-top, fill: ink)
  R(o.edge - beam-w / 2, slab-top - slab, o.edge + beam-w / 2, slab-top + upstand, fill: luma(90))
  R(x-east - wall-half, slab-top - slab, xb, slab-top, fill: ink)
  R(xa, slab-top, o.edge - beam-w / 2, ff, fill: luma(200))                     // floor finish
  // first-floor walls
  R(x-wall - wall-half, ff, x-wall + wall-half, roof - roof-slab, fill: ink)
  // roof: the gallery strip to R11 on the edge, the east roof; the sky hole between, with railings
  R(xa, roof - roof-slab, o.edge + beam-w / 2, roof, fill: ink)
  R(o.edge - beam-w / 2, roof - r11-d, o.edge + beam-w / 2, roof, fill: luma(90))
  R(x-east - wall-half, roof - roof-slab, xb, roof, fill: ink)
  line((o.edge, roof), (o.edge, roof + railing), stroke: 1pt + ink); line((x-east, roof), (x-east, roof + railing), stroke: 1pt + ink)
  T(((o.edge + x-east) / 2, roof + railing + 0.1), [roof railings round the sky opening], size: 3.8pt)
  // the window W1 on the upstand (or the railing of today)
  if o.key == "B" {
    R(o.win - frame / 2, slab-top, o.win + frame / 2, slab-top + 0.10, fill: luma(90))                      // kerb
    R(o.win + frame / 2, slab-top, o.edge - beam-w / 2, slab-top + 0.05, fill: rgb("#d8c4a0"))               // ledge: stone cap falling out
    line((o.win, slab-top + 0.10), (o.win, head), stroke: 2.2pt + steel)
    line((o.win - 0.25, guard), (o.win + 0.25, guard), stroke: 0.8pt + steel)
    T((o.win - 0.1, (guard + head) / 2), [W1 on a kerb · sill +#f2(slab-top + 0.10)], size: 3.8pt, fill: sky, angle: 90deg)
    T(((o.win + o.edge) / 2 + 0.05, slab-top + upstand + 0.25), [ledge #r2(o.edge - beam-w / 2 - o.win - frame / 2)], size: 3.4pt, fill: red)
  } else {
    line((o.edge, slab-top + upstand), (o.edge, head), stroke: 2.2pt + steel)
    line((o.edge - 0.25, guard), (o.edge + 0.25, guard), stroke: 0.8pt + steel)
    T((o.edge - 0.1, (guard + head) / 2), [W1 on the upstand · sill +#f2(sill-gal)], size: 3.8pt, fill: sky, angle: 90deg)
  }
  // the roof-edge head line and the soffit line
  line((o.edge + beam-w / 2, head), (x-east - wall-half, head), stroke: (paint: sky, thickness: 0.5pt, dash: "dotted"))
  T((x-east - 0.25, head - 0.2), [head +#f2(head) (R11 / R2 soffit)], size: 3.6pt, fill: sky, anchor: "east")
  // dims
  let dimh(x0, x1, z, l, col: ink) = { line((x0, z), (x1, z), stroke: 0.45pt + col, mark: (start: "|", end: "|", scale: 0.35)); T(((x0 + x1) / 2, z + 0.2), l, size: 3.8pt, fill: col) }
  dimh(inner-face, if o.key == "B" { o.win - frame / 2 } else { o.edge - frame / 2 }, ff + 2.45, [#r3(gal-at-window(o)) clear], col: red)
  if o.key != "B" { dimh(inner-face, o.col - sleeve / 2, ff + 1.85, [#r3(gal-at-columns(o)) at C21–C23], col: red) }
  dimh(o.edge + beam-w / 2, x-east - wall-half, 1.6, [sky #r3(sky-clear(o)) clear · #r2(sky-axes(o)) axes], col: sky)
  dimh(x-wall, o.edge, slab-top - slab - 0.45, [projection #r2(o.edge - x-wall)], col: ink)
  for (h, l) in ((0, [±0.00]), (sill-gal, [+#f2(sill-gal) sill]), (guard, [+#f2(guard)]), (head, [+#f2(head)]), (roof, [+#f2(roof) roof])) { T((xb + 0.15, h), l, size: 3.8pt, fill: gray, anchor: "west") }
  T((xa - 0.15, ff), [+#f2(ff) FF], size: 3.8pt, fill: gray, anchor: "east"); T((xa - 0.15, slab-top - slab), [+#f2(slab-top - slab) soffit], size: 3.8pt, fill: gray, anchor: "east")
  T((xa + 0.1, 1.5), [riwaq], size: 4pt, anchor: "west"); T((xa + 0.1, 4.3), [bedroom 2], size: 4pt, anchor: "west"); T(((o.edge + x-east) / 2, 0.6), [COURTYARD · open sky above], size: 4.2pt, fill: sky)
  T((xb - 0.1, 1.5), [kitchen], size: 4pt, anchor: "east"); T((xb - 0.1, 4.3), [suite lobby], size: 4pt, anchor: "east"); T(((x-wall + o.edge) / 2, 4.2), [gallery], size: 4pt)
  T(((xa + xb) / 2, -1.1), [#o.name · section at y ≈ 10 looking north], size: 5.2pt, fill: accent)
})
#grid(columns: 2, gutter: 16pt, section(A), section(B))
#v(2pt)
#text(6.8pt)[Dark: walls, slabs, the roof; grey: the upturned edge beam B3 (0.25 × 0.50 total, 0.30 above the slab) and the roof edge beam R11 above it; the dashed column is C22 (y 13.0) beyond the cut. W1 (heavy black line) sits on the upstand (A) or on a 0.10 m kerb inboard of it with a stone-capped ledge outside (B); its guarding transom at +#f2(guard), its head at +#f2(head) under R11.]
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[W1 · the gallery line seen from the courtyard and the void (looking west) · option A · 1:70 on A4]
#v(2pt)
#let elevation(o, length: 0.95cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, body, size: 5pt, fill: ink, anchor: "center", angle: 0deg) = content(p, anchor: anchor, angle: angle, text(size, fill: fill, body))
  let R(y0a, z0, y1a, z1, fill: none, stroke: none) = rect((y0a, z0), (y1a, z1), fill: fill, stroke: stroke)
  let soffit = slab-top - slab   // +3.32
  line((y0 - 0.5, 0), (y2 + 0.5, 0), stroke: 1pt + ink)
  R(y0, 0, y2, soffit, fill: rgb("#f2efe8"))                                     // the colonnade (open) with the riwaq beyond
  R(y0, soffit, y2, slab-top + upstand, fill: rgb("#6b4a2b"))                      // timber fascia on the slab edge and the upstand
  R(y0, slab-top + upstand, y2, head, fill: glass)                               // W1
  R(y0, head, y1, roof, fill: luma(90)); R(y1, roof - roof-slab, y2, roof, fill: ink)   // R11 over bay 1; the roof slab edge over the void
  R(y1, head, y2, roof - roof-slab, fill: rgb("#6b4a2b"))                        // a fascia keeps one head line over bay 2
  line((y0, roof), (y1, roof), stroke: 1pt + ink); for y in range(0, 5) { line((y0 + y * 1.5 + 0.1, roof), (y0 + y * 1.5 + 0.1, roof + railing), stroke: 0.6pt + ink) }
  line((y0, roof + railing), (y1, roof + railing), stroke: 0.8pt + ink); T(((y0 + y1) / 2, roof + railing + 0.3), [roof railing (sky opening)], size: 3.6pt)
  // lites: transom at +4.70, mullions ≈ 0.75
  let bays = if o.key == "B" { ((y0 + wall-half, y2 - wall-half),) } else { ((y0 + sleeve / 2, y1 - sleeve / 2), (y1 + sleeve / 2, y2 - sleeve / 2)) }
  for (a, b) in bays {
    let n = calc.ceil((b - a) / 0.78); let w = (b - a) / n
    for i in range(0, n + 1) { line((a + i * w, slab-top + upstand), (a + i * w, head), stroke: 0.7pt + steel) }
    line((a, guard), (b, guard), stroke: 1pt + steel); line((a, 5.75), (b, 5.75), stroke: 0.7pt + steel)
    line((a, slab-top + upstand), (b, slab-top + upstand), stroke: 1pt + steel); line((a, head), (b, head), stroke: 1pt + steel)
    // two casements per bay (inward side-hung) between the guarding transom and +5.75
    for k in (1, n - 2) { let x0 = a + k * w; line((x0, guard), (x0 + w, 5.75), stroke: 0.5pt + red); line((x0 + w, guard), (x0, 5.75), stroke: 0.5pt + red) }
  }
  // columns: in the line (A) or in front (B, drawn the same in elevation)
  for y in col-ys { R(y - sleeve / 2, 0, y + sleeve / 2, if y == y2 { roof } else { roof }, fill: rgb("#d8c4a0"), stroke: 0.5pt + ink) }
  T((y0, -0.5), [C21 · y #r2(y0)], size: 3.8pt); T((y1, -0.5), [C22 · y #r2(y1)], size: 3.8pt); T((y2, -0.5), [C23 · y #r2(y2)], size: 3.8pt)
  T(((y0 + y1) / 2, 1.6), [colonnade · open · the courtyard], size: 4.2pt); T(((y1 + y2) / 2, 1.6), [colonnade · open · the living (TV wall beyond)], size: 4.2pt)
  T(((y0 + y1) / 2, soffit + 0.25), [timber fascia · slab edge + upstand], size: 3.6pt, fill: white)
  T(((y0 + y2) / 2, slab-top - slab - 0.35), [laminated guarding glass above the fascia: sill +#f2(sill-gal) → transom +#f2(guard)], size: 3.8pt, fill: steel)
  for (h, l) in ((0, [±0.00]), (ff, [+#f2(ff)]), (sill-gal, [+#f2(sill-gal)]), (guard, [+#f2(guard)]), (head, [+#f2(head)]), (roof, [+#f2(roof)])) { T((y2 + 0.6, h), l, size: 3.6pt, fill: gray, anchor: "west") }
  T(((y0 + y2) / 2, -1.2), [black steel, divided lites ≈ 0.75 wide · transoms at +#f2(guard) (guarding) and +5.75 · red X = inward side-hung casements, two per bay (night mode, cleaning) · about #r2(gal-glass(o)) m² of glass · #o.name], size: 5pt, fill: accent)
})
#elevation(A)

// ====================================================================================== PAGE 4 · structure, light, cost, knock-on effects
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[Structure, daylight, cost, and what else changes]
#v(2pt)
#grid(columns: (1fr, 1fr), gutter: 10pt,
  [
    #H[5 · Structure (studies/structure.typ)]
    *Both options.* W1 bears on the upstand of B3 (the window's dead load is small; the upstand becomes its sill and its anchor, 0.25 wide); W2 on B2 (floor-level sill, the frame anchored to the slab edge and R1); W3 spans +#f2(gf-glass-head) → +#f2(head) between C22 and the kitchen wall, held top and bottom (R2 above; a steel transom at +#f2(sill-gal) tied to C22 and the wall takes the wind of the 3.85 m height; the courtyard well has little wind). The head line is the soffit of R1 / R2 / R11 at +#f2(head); over the void (y #r2(y1)–#r2(y2)) a #r2(roof - roof-slab - head) m fascia keeps the same line under the roof slab. Nothing new for the engineer except the window anchors and, in B, the ledge.
    - *A:* B3, R11 and C21–C23 move 0.20 m east to x #r2(A.edge); the projection slab bay becomes #r2(A.edge - x-wall) m (slabs-ff row "the projection"), the roof strip over the gallery #r2(A.edge - x-wall) m (slabs-roof); C22 stays the pier in the living's courtyard glass (now at x #r2(A.col)), C21 in the women's majlis glass, C23 in the living's south wall; the spans (#r2(y1 - y0) / #r2(y2 - y1)) are unchanged, R2's west end lands on C22 at x #r2(A.col). The sky opening is #r2(sky-axes(A)) × #r2(sky-depth) m.
    - *B:* B3, R11 and C21–C23 move 0.35 m east to x #r2(B.edge); the slab bay becomes #r2(B.edge - x-wall) m with the window line #r2(B.edge - B.win) m inboard of the beam on a 0.10 m kerb; the ledge between the kerb and the upstand is waterproofed and capped (stone, falling out). The columns stand free in the courtyard and in the void: C22 is a free column in the living's courtyard glass line, 0.35 m in front of the upper window W3 (W3 then runs behind it, from the W1 line at x #r2(B.win) to the kitchen wall, #r2(x-east - wall-half - B.win) m). Alternative B2 (not recommended): B3 stays at x #r2(edge-now) and reaches the columns at x #r2(B.edge) on short corbels; two lines of concrete for one edge.
    - The courtyard colonnade below: in A the columns move with the slab edge (the covered strip #r2(A.edge - x-wall) m on axes); in B the columns stand #r2(B.edge - B.win) m further into the courtyard than the glass above, and the covered strip is #r2(B.edge - x-wall) m.

    #H[6 · Daylight (simple, as in the light check)]
    The courtyard well is #r2(roof + railing) m deep to the roof railing. Today it is #r2(sky-axes(NOW)) m wide (ratio #r2(well-ratio(NOW))); A #r2(sky-axes(A)) m (#r2(well-ratio(A))); B #r2(sky-axes(B)) m (#r2(well-ratio(B))). The sky seen from a seated eye in the middle of the courtyard floor is #pc(sky-from-court(NOW)) of the hemisphere today, #pc(sky-from-court(A)) in A and #pc(sky-from-court(B)) in B. From the living's seated eye (the light check point, through the y #r2(y1) line) it is #pc(sky-from-living(NOW)) today; A #pc(sky-from-living(A)) and B #pc(sky-from-living(B)) *through the new glass* (× #r2(glazing-factor) for the glass and its frames, A and B alike: the living's upper light comes through W3 in both). In short: A costs the living about #pc(1 - sky-from-living(A) / sky-from-living(NOW)) of its sky view by geometry and ≈ #pc(1 - glazing-factor) by the glass; B #pc(1 - sky-from-living(B) / sky-from-living(NOW)) and the same glass. The clerestory light (sections.typ: winter noon sun on the clerestories, the suite court) is untouched by either. The courtyard's own light drops a little in both (the well narrows by #r2(A.edge - edge-now) / #r2(B.edge - edge-now) m); the pergola (character study, over y #r2(y0)–9.5) takes more than either option and should be reconsidered when the enclosure is decided.
  ],
  [
    #H[7 · Cost and buildability]
    - *Glass:* about #r2(new-glass(A)) m² (A) / #r2(new-glass(B)) m² (B) of thermally broken black steel windows with divided lites and double low-e glass, laminated below the guarding transom; six casements and two motorised tilt lites. If the ground-floor living glass (y #r2(y1)) is remade as part of one steel wall ±0.00 → +#f2(head), add ≈ #r2(liv-glass-full(A) - liv-glass(A)) m². This is the main cost and is the same in A and B.
    - *Concrete:* A adds #r2((A.edge - edge-now) * (y2 - y0)) m² of first-floor slab and #r2((A.edge - edge-now) * sky-depth) m² of roof strip; B adds #r2((B.edge - edge-now) * (y2 - y0)) + #r2((B.edge - edge-now) * sky-depth) m² plus the kerb, the ledge waterproofing and #r2(y2 - y0) m of stone capping. Both are small.
    - *Build:* A is one line: the formwork of B3 is also the sill, the columns meet the frames with one sealed joint each (six joints), and the soffit, the fascia and the railing base are as decided. B has two lines to coordinate (beam and kerb), a ledge that collects dust and water and is reached only through the casements, and columns that must be cast free-standing to the roof with the frames passing behind them (the frames are then continuous, #r2(y2 - y0 - 2 * wall-half) m, with no column joints).
    - *Guarding:* the window itself guards the gallery and the family living (laminated glass to +#f2(guard), the transom at 1.10 above the floor): the bar railing of the design language is then the stair's, not the gallery's. If the owner wants a bar railing on the gallery as well, it stands inside the glass and takes ≈ 0.05 m of the clear width (A still ≥ 1.20; B does not).

    #H[8 · Knock-on effects]
    - *The malqaf and the courtyard air.* The courtyard stays outside and the house is sealed round it, so the malqaf's grille at the foot of the kitchen wall serves only the courtyard: in the closed (dust) mode nothing of it reaches the rooms, and the courtyard well behaves as a chimney, cool air at the bottom, warm air out at the top. In the night mode the casements of W1 / W2 and the tilt lites of W3 open and the courtyard's tempered air enters the gallery, the family living and the living: the malqaf keeps a use, but only with the windows open (insect screens, a damper interlock with the ERV). The review's E-01 stands: decide the malqaf's role with this item (feature only; the ERV's intake; or an atrium). The sunken seating, the fountain and the pergola stay outdoor elements.
    - *The clerestory windows* (y #r2(y2), +5.00 … +6.00, onto the suite court) are not on the courtyard and do not change; after the enclosure they and W3's tilt lites are the living's only openings: keep them fixed in the closed mode or make two of them operable with the night mode, and plan their cleaning from the suite court.
    - *The AC and ERV:* the living, the gallery and the family living become conditioned volumes (the double-height living #r2(x-east - x-wall) × #r2(void-depth) × #r2(head) m): the MEP engineer sizes for them; the glass faces a shaded well, so the solar gain is modest.
    - *The character study* (3d/character.yaml): the colonnade's arches are gone (V6.3); the gallery railing variants (parapet / glass) are replaced by W1 on the upstand; the lanterns hang under the soffit as before; the roof railings round the sky opening stay.
    - *Other review items* that this decides or touches: F-01 (gallery width: solved by A or B), F-06 (family living edge: W2), G-02 (the living's light: W3's glass, § 6), Y-04 (cleaning: the hose point and the pole), E-01 (malqaf).

    #H[9 · Decision needed]
    A or B (or the atrium, which this study does not draw). On the decision the next step changes `data/rooms_ff.csv` (the gallery polygon), `studies/ff_family.typ` (proj-x, columns), `studies/structure.typ` (C21–C23, B3, R11, the slab bays), `presentation.typ` (ff-walls: windows instead of rails), `3d/open_edges.csv` and `3d/params.yaml` (W1–W3 as windows), the light check and the character study.
  ],
)

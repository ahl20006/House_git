// malqaf_L5.typ · Taif / Palm House · L5 MALQAF: FULL DESIGN STUDY (decision-grade), in PHASES · STUDY ONLY (the design files are not changed)
// L5: the malqaf at the courtyard's NORTH-WEST corner, inside the covered strip under the FF west projection, against the y 6.5 wall.
// The brief's WARNINGs are printed as "⚠ CAUTION" (tools/check.py reserves the word WARNING for failed checks).
// Finishes (owner, 9 Nov 2026): NO stone anywhere: the core and the head in render and paint, the projections formed in the structure (light sand; an optional honey tone).
// Owner decisions 9 Nov 2026 (D1–D11, not reopened): a LARGE natural breeze for the courtyard (D1); no HRV, a filtered supply fan (D2); one tower,
// two paths after the head (D3); no water tank on the tower (D4); a dust-tight house, the courtyard an open outdoor room (D5); the covered strip may be
// taken (D6); the shaft as large as needed, the head ≥ the shaft (D7); the gallery's arched windows may be redesigned (D8); prepare an evaporative cooler
// in the shaft's foot (D9); the tower touches no bedroom (D10); the D11 facade module (20 cm; GF / FF windows on one axis) as a constraint.
// PHASE 0: the geometry check and the climate basis · PHASE 1: the L5 geometry and variants · PHASE 2: the structure · PHASE 3: the facade (colonnade, gallery, windows, arches) · PHASE 4: the air system and the controls (simplified by the owner) · PHASE 5: the tower head · PHASE 6: the decision sheet. Data: tools/climate_taif.py (Meteostat 41036 2011–2025, NOAA ISD 2015–2024).
// CSV frame (x east, y south, wall centre lines); levels from the finished ground floor. Every figure ASSUMED until the engineers confirm.
#import "@preview/cetz:0.4.2"
#set page(paper: "a4", flipped: true, margin: 8mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 7.3pt)
#set par(leading: 0.42em)
#let green = rgb("#2f6b4f"); #let ink = rgb("#26302b"); #let gray = rgb("#6d736f"); #let red = rgb("#b5452f"); #let amber = rgb("#b07a1f"); #let blue = rgb("#1f7a99")
#let H(t) = block(above: 5pt, below: 3pt, text(9pt, weight: "bold", fill: green, t))
#let WARN(t) = box(fill: rgb("#fbe3dc"), inset: 2.5pt, radius: 2pt, text(fill: red, weight: "bold")[⚠ CAUTION · ] + t)   // "WARNING" is reserved for failed checks (tools/check.py)
#let ASSUMED = text(fill: amber, weight: "bold")[ASSUMED]
#let r1(v) = str(calc.round(v, digits: 1))

// ======================================================================= DATA (tools/climate_taif.py; Taif station WMO 41036, local time UTC+3)
#let SECT = ("N", "NE", "E", "SE", "S", "SW", "W", "NW")
// direction share (% of non-calm hours; calm < 2 km/h), the mean speed (km/h) and the calm share, by month (Meteostat 2011–2025, 128 500 hourly records)
#let by-month = (
  (7.1, 5.9, 10.1, 12.9, 21.0, 16.1, 16.3, 10.6, 11.7, 14.2), (6.3, 6.3, 11.3, 12.4, 17.9, 18.2, 17.7, 9.8, 13.9, 10.9),
  (4.2, 4.1, 7.8, 11.0, 19.1, 17.4, 24.9, 11.4, 15.0, 8.5), (3.2, 4.0, 7.1, 11.3, 18.2, 19.4, 26.5, 10.2, 14.9, 6.7),
  (4.5, 5.2, 6.2, 7.1, 13.0, 16.9, 33.2, 13.9, 13.8, 6.8), (8.0, 8.4, 6.4, 3.9, 4.4, 8.0, 35.7, 25.3, 16.8, 3.8),
  (7.2, 3.8, 1.4, 0.6, 1.1, 4.2, 44.0, 37.6, 21.7, 1.4), (8.9, 6.2, 2.9, 1.4, 2.1, 5.0, 40.7, 32.8, 19.6, 2.3),
  (7.2, 10.6, 10.8, 7.2, 8.0, 10.6, 25.0, 20.7, 13.8, 7.4), (3.4, 6.8, 14.3, 19.1, 18.9, 10.8, 15.9, 10.7, 11.5, 12.1),
  (4.6, 4.5, 10.3, 15.2, 22.1, 14.1, 17.6, 11.7, 10.7, 13.9), (5.6, 4.7, 12.0, 15.8, 21.2, 14.1, 15.1, 11.3, 10.9, 14.5))
// by time of day: (season, band) → sector shares, mean speed, calm
#let by-band = (
  ("May–Sep", "night 00–06", (2.5, 1.1, 1.2, 1.9, 7.8, 14.5, 46.0, 24.9), 12.6, 9.2), ("May–Sep", "morning 06–12", (11.8, 8.0, 6.2, 7.6, 9.5, 10.5, 22.6, 23.9), 14.0, 6.4),
  ("May–Sep", "afternoon 12–18", (11.1, 13.6, 11.1, 5.0, 2.9, 4.2, 25.6, 26.4), 21.3, 0.6), ("May–Sep", "evening 18–24", (3.2, 3.9, 2.9, 1.2, 2.5, 6.6, 49.7, 30.0), 20.7, 1.2),
  ("Nov–Feb", "night 00–06", (2.7, 3.3, 7.8, 20.9, 29.7, 18.3, 11.7, 5.6), 6.9, 26.6), ("Nov–Feb", "morning 06–12", (2.9, 3.1, 9.6, 23.5, 33.0, 18.3, 5.9, 3.7), 9.8, 16.1),
  ("Nov–Feb", "afternoon 12–18", (10.7, 6.9, 13.8, 8.0, 12.5, 14.6, 17.9, 15.5), 18.4, 1.7), ("Nov–Feb", "evening 18–24", (6.1, 7.6, 11.4, 6.5, 10.6, 12.2, 29.1, 16.5), 12.2, 9.2))
// the evening (18–24) mean speed by month (km/h)
#let eve-speed = (12.0, 14.7, 16.4, 16.9, 17.5, 21.1, 24.6, 22.9, 17.5, 13.3, 11.0, 11.0)
// temperature and humidity: Tmax, Tmin (means of the daily extremes), Tmin p10, 15h T, 15h RH, 15h wet bulb, 21h T, 21h RH
#let temps = ((23.0, 10.2, 7.0, 22.2, 36), (25.0, 11.7, 8.0, 24.3, 30), (27.6, 14.6, 11.0, 26.9, 25), (30.0, 17.2, 14.0, 28.9, 26), (33.5, 20.4, 18.0, 32.4, 19), (36.2, 24.0, 21.0, 35.6, 12),
  (35.5, 25.3, 23.0, 34.9, 15), (35.5, 24.9, 23.0, 34.7, 20), (35.0, 22.6, 20.0, 34.2, 15), (31.0, 17.9, 15.0, 30.2, 19), (26.6, 14.1, 12.0, 25.6, 34), (23.9, 11.3, 8.0, 23.3, 36))
#let temps21 = ((16.3, 57), (18.2, 50), (20.8, 45), (22.7, 46), (26.2, 36), (29.3, 24), (29.0, 26), (28.5, 37), (28.0, 35), (24.0, 45), (19.8, 59), (17.3, 57))
#let wet15 = (none, none, none, 16.0, 16.7, 16.5, 17.3, 18.6, 16.7, 15.3, none, none)
// the seating hours 16–23 (ISD synoptic 2015–2024): the dust share, the pleasant (20–32 °C, 7–35 km/h at 10 m) AND dust-free share, hours / month
#let seat = ((4.7, 21, 53), (8.5, 43, 96), (17.3, 65, 162), (10.8, 70, 169), (6.4, 76, 188), (12.1, 47, 113), (8.4, 53, 132), (11.4, 62, 154), (4.8, 71, 170), (1.3, 89, 221), (0.7, 65, 157), (2.9, 34, 84))
#let too-hot = (0, 0, 0, 1, 14, 36, 29, 25, 22, 2, 0, 0)        // % of the seating hours above 32 °C (Meteostat)
#let too-cool = (46, 24, 8, 5, 1, 0, 0, 0, 0, 1, 11, 35)        // % below 18 °C
#let dust-days = (3.1, 6.3, 11.0, 8.3, 5.0, 8.0, 5.5, 7.8, 3.7, 1.2, 0.5, 1.8)   // days / year with a dust report (ISD present weather 06–09, 30–35)
#let MON = ("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
#let year-hours = seat.map(s => s.at(2)).sum()

// ======================================================================= the geometry check (the brief's coordinates against the repo, V9.3)
#let geo = (
  ([Courtyard x 4.25–8.95, y 6.5–13.0], [rooms_gf.csv: 4.7 × 6.5 centred 6.6 / 9.75], true),
  ([Seating zone x 5.925–8.85, y 7.1–12.3], [air_system.typ `air-sunken`], true),
  ([GF covered strip x 4.25–5.80, y 6.5–13.0], [the FF projection 1.55 m (B4 x 4.25 → B3 x 5.80); clear ≈ 1.35–1.45 (the riwaq's glazing line and the colonnade)], true),
  ([Women's majlis x 4.25–8.95, y 0–6.5 · FF family living x 4.25–8.95, y 3.0–6.5], [rooms_gf.csv, rooms_ff.csv], true),
  ([Family lobby + riwaq x 2.25–4.25], [*partly:* x 2.25–4.25 only for y 0–2.2 (the lobby); *along the courtyard x 2.75–4.25 (1.5 m)*], false),
  ([Riwaq glazing on x 4.25], [glass y 6.8–8.9 and 10.7–12.7, the courtyard glass door y 9.1–10.5 (presentation.typ)], true),
  ([FF gallery x 4.25–5.80 (y 6.5–19.25) + x 2.75–4.25 (y 2.2–9.2), ≈ 3.05 m wide at y 6.5–9.2], [rooms_ff.csv (also x 2.25–4.25 for y 0.7–2.2)], true),
  ([W1 × 6 on x 5.80: y 6.783–8.383 … 17.408–19.008; sill +3.82, springing +5.80, crown +6.60], [ff_family.typ, 3d/params.yaml], true),
  ([C21 (5.8, 6.5), C22 (5.8, 13.0), C23 (5.8, 19.25), Ø 0.30 · and C17 at (4.25, 6.5)], [structure.typ (C17: 0.25 × 0.50, to the roof)], true),
  ([B3 on x 5.80, 6.50 + 6.25, upturned or drop · B4 on x 4.25, drop, soffit +3.10 · R11 on C21–C22, soffit +6.75 · the projection slab 0.20 E–W 1.55 m], [structure.typ], true),
  ([Levels GF ±0.00, FF +3.60, roof finish +7.30, attic coping +8.68 · Z3 x 2.85–4.15, y 1.0–3.5], [roof.typ (V9.2 attic)], true),
  ([Baseline L1 (V9.3): NE corner, shaft 0.90 m², crown +12.18], [air_system.typ, roof.typ (V9.3)], true),
)

// ======================================================================= checks (data sanity)
#let checks = (
  ([every month's sector shares add to 100 % (± 0.5)], by-month.all(m => calc.abs(m.slice(0, 8).sum() - 100) < 0.6)),
  ([every band's sector shares add to 100 % (± 0.5)], by-band.all(b => calc.abs(b.at(2).sum() - 100) < 0.6)),
  ([the pleasant and dust-free seating hours add up (#year-hours h / year)], year-hours > 1500 and year-hours < 2000),
  ([the brief's coordinates checked against the repo (#geo.filter(g => not g.at(2)).len() partial mismatch)], geo.len() == 12),
)
#let all-ok = checks.all(c => c.at(1))

// ======================================================================= drawings
#let rose(shares, title, speed, calm, size: 1.15cm) = cetz.canvas(length: size, {
  import cetz.draw: *
  let mx = 50.0
  for r in (0.25, 0.5, 0.75, 1.0) { circle((0, 0), radius: r, stroke: (paint: luma(200), thickness: 0.3pt)) }
  for (i, s) in shares.enumerate() {
    let a = 90deg - i * 45deg; let r = calc.min(1.0, s / mx)
    let a0 = a - 18deg; let a1 = a + 18deg
    line((0, 0), (r * calc.cos(a0), r * calc.sin(a0)), (r * calc.cos(a1), r * calc.sin(a1)), close: true, fill: if SECT.at(i) in ("W", "NW") { blue } else { blue.lighten(55%) }, stroke: 0.3pt + ink)
    content((1.18 * calc.cos(a), 1.18 * calc.sin(a)), text(4.6pt, SECT.at(i)))
  }
  content((0, -1.5), text(5pt, weight: "bold", title))
  content((0, -1.78), text(4.4pt, fill: gray)[#r1(speed) km/h · calm #r1(calm) %])
})

// ======================================================================= PAGE 1 · the check and the wind
#text(14pt, weight: "bold", fill: green)[Malqaf L5 · the courtyard's north-west corner · a decision-grade study in phases]
#v(1pt)
#text(7.6pt, fill: gray)[STUDY ONLY: no design file is changed until the owner adopts L5 · the owner's decisions D1–D11 (9 Nov 2026) are the brief · *PHASE 0: the geometry check and the climate basis* (the next phases follow the owner's reply) · every figure #ASSUMED unless measured; final sizes by the structural and MEP engineers.]
#v(3pt)
#grid(columns: (1.05fr, 1fr), gutter: 10pt,
  [
    #H[0.1 · The brief's coordinates against the repo (V9.3)]
    #table(columns: (1.5fr, 1.4fr, auto), inset: 2pt, stroke: 0.4pt + luma(180), fill: (_, y) => if y == 0 { rgb("#e4eedf") },
      [*The brief*], [*The repo*], [],
      ..geo.map(((a, b, ok)) => ([#a], [#b], if ok { text(fill: green)[✓] } else { text(fill: amber, weight: "bold")[≠] })).flatten())
    #text(6.4pt)[*Mismatches:* (1) the riwaq is 1.5 m wide along the courtyard (x 2.75–4.25), 2.0 m only at the lobby (y 0–2.2); (2) the covered strip's clear width ≈ 1.35–1.45 m depending on the glazing build-up (to fix in Phase 1). *Also noted:* a column C17 already stands at (4.25, 6.5), the corner the L5 core starts from (Phase 2); at y 6.5–9.2 the FF gallery is 3.05 m wide only because its west half (x 2.75–4.25) is the stair's arrival zone: a core across the whole strip (V-b) leaves 1.5 m on axes, ≈ 1.3 clear, *below the brief's 1.5 m clear* (#text(fill: red)[⚠ caution for Phase 1]).]
  ],
  [
    #H[0.2 · The wind (Taif station, 10 m mast, 2011–2025)]
    #grid(columns: (1fr, 1fr, 1fr), gutter: 2pt,
      rose(by-band.at(3).at(2), [May–Sep · evening], by-band.at(3).at(3), by-band.at(3).at(4)),
      rose(by-band.at(2).at(2), [May–Sep · afternoon], by-band.at(2).at(3), by-band.at(2).at(4)),
      rose(by-band.at(4).at(2), [Nov–Feb · night], by-band.at(4).at(3), by-band.at(4).at(4)),
    )
    #v(2pt)
    #table(columns: (auto,) * 11, inset: 1.6pt, stroke: 0.3pt + luma(190), fill: (_, y) => if y == 0 { rgb("#e4eedf") },
      text(5.4pt)[*Mon*], ..SECT.map(s => text(5.4pt)[*#s*]), text(5.4pt)[*km/h*], text(5.4pt)[*calm*],
      ..by-month.enumerate().map(((i, m)) => (text(5.4pt, MON.at(i)), ..m.slice(0, 8).map(v => text(5.4pt, fill: if v >= 25 { blue } else { ink })[#r1(v)]), text(5.4pt)[#r1(m.at(8))], text(5.4pt)[#r1(m.at(9))])).flatten())
    #text(6.2pt, fill: gray)[% of the non-calm hours by the direction the wind blows FROM; calm < 2 km/h. Bold blue: ≥ 25 %. Station at the airport (21.48 N 40.54 E, 1 478 m), *#ASSUMED representative of the farm* (its terrain and obstacles to be checked on site).]
  ],
)

// ======================================================================= PAGE 2 · temperature, dust, the breeze hours, the cooler
#pagebreak()
#text(12pt, weight: "bold", fill: green)[Phase 0 · when the malqaf works · dust · summer cooling · winter closing]
#v(3pt)
#table(columns: (auto,) + (1fr,) * 12, inset: 2pt, stroke: 0.3pt + luma(185), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f3f1ea") },
  [*Month*], ..MON.map(m => [*#m*]),
  [Tmax / Tmin (°C)], ..temps.map(t => [#r1(t.at(0)) / #r1(t.at(1))]),
  [the coldest nights (p10, °C)], ..temps.map(t => [#r1(t.at(2))]),
  [15 h: T · RH], ..temps.map(t => [#r1(t.at(3)) · #t.at(4)%]),
  [21 h: T · RH], ..temps21.map(t => [#r1(t.at(0)) · #t.at(1)%]),
  [evening wind (km/h)], ..eve-speed.map(v => [#r1(v)]),
  [dust days / year], ..dust-days.map(v => [#r1(v)]),
  [seating 16–23: dust hours], ..seat.map(s => [#r1(s.at(0)) %]),
  [*pleasant & dust-free*], ..seat.map(s => text(fill: if s.at(1) >= 60 { green } else { ink }, weight: "bold")[#s.at(1) %]),
  [ ≈ hours / month], ..seat.map(s => [#s.at(2)]),
  [too hot > 32 °C], ..too-hot.map(v => text(fill: if v >= 20 { red } else { ink })[#v %]),
  [too cool < 18 °C], ..too-cool.map(v => text(fill: if v >= 20 { blue } else { ink })[#v %]),
  [cooler outlet at 15 h (°C)], ..wet15.enumerate().map(((i, w)) => if w == none { [–] } else { [#r1(temps.at(i).at(3) - 0.8 * (temps.at(i).at(3) - w))] }),
)
#text(6.2pt, fill: gray)[Pleasant = 20–32 °C with 7–35 km/h at the 10 m mast (the head at ≈ +12 m: ≈ 4 % more), the family's seating hours 16:00–23:00 (#ASSUMED); dust = an ISD synoptic report with dust or sand in the present weather (06–09, 30–35). Cooler = a direct evaporative cooler at 80 % saturation efficiency on the 15 h mean (wet bulb by Stull 2011), #ASSUMED.]
#v(4pt)
#grid(columns: (1.25fr, 1fr), gutter: 12pt,
  [
    #H[0.3 · What the climate says]
    - *When the malqaf works:* ≈ *#year-hours h a year* of pleasant, dust-free seating hours (#calc.round(100 * year-hours / 2920) % of 16:00–23:00): the best months *October (89 %)*, May (76 %), April, September, March and November (65–71 %); the summer evenings 47–62 % (the rest too hot → the cooler, D9); December–January 21–34 % (too cool → closed).
    - *The faces that matter:* the warm-season evening wind comes *from the west (≈ 50 %) and the north-west (≈ 30 %)*, at ≈ 21 km/h (≈ 6 m/s, calm 1 %); the afternoons add the north and north-east (≈ 25 %). *Priority: the W face, then the N face* (a NW wind strikes both at 45°); E and S faces matter only in the cool season's light night winds (S / SE, calm 27 %), when the malqaf is closed anyway.
    - *Dust:* ≈ *62 dust days a year* (mostly dust in suspension; a dust-storm code or a visibility below 1 km on less than 1 day a year), the most in *March (11)* and June–August (8); ≈ 5–17 % of the seating hours. The dust arrives as often from the east and south-east (≈ 35 %) as from the west: *a dust trap at the foot and a PM2.5 sensor are essential*; the filtered path must never depend on the breeze path.
    - *Summer cooling (D9):* the afternoon air is very dry (RH 12–20 %, the wet bulb 16–19 °C): a direct evaporative cooler would deliver *≈ 20–22 °C air* from 35 °C, June–September: an excellent potential for a mobile cooler in the shaft's foot.
    - *Winter:* the evenings below 18 °C on ≈ 35–46 % of December–January seating hours, the coldest nights ≈ 7–8 °C: the breeze path must close tight and insulated (D5).
    - #WARN[the station is the airport's 10 m mast; the farm's own exposure (terrain, trees, the old house to the west) is unknown: a simple anemometer on the roof for a few weeks would confirm the faces before Phase 5.]
  ],
  [
    #H[0.4 · Thresholds for the control modes (to finalise in Phase 4)]
    #table(columns: (auto, 1fr), inset: 2.2pt, stroke: 0.4pt + luma(180), fill: (_, y) => if y == 0 { rgb("#e4eedf") },
      [*Mode*], [*Switching (outdoor sensors; #ASSUMED)*],
      [Normal], [breeze damper open: 20 ≤ T ≤ 32 °C and PM2.5 ≤ 35 µg/m³; the filtered fan always on],
      [Clear day], [also the gallery window: 18 ≤ T ≤ 30 °C, PM2.5 ≤ 15, wind ≤ 30 km/h],
      [Dust], [all breeze openings shut: PM2.5 > 50 for 10 min (reopen < 25 for 30 min); the fan up for positive pressure],
      [Cold], [breeze shut: T < 18 °C (or < 20 °C after sunset, Nov–Mar); the fan at its minimum],
      [Summer], [T > 32 °C: the cooler on in the foot, the breeze damper open to feed it, the gallery window shut],
      [High wind], [gusts > 45 km/h: the damper half-closed (dust and noise)],
    )
    #H[Open questions for the owner]
    + Where exactly is the farm (distance and height from the airport; hills or trees to the west and north-west)? Can a small roof anemometer run for a few weeks?
    + Are 16:00–23:00 and 20–32 °C the right seating hours and comfort band for the family?
    + Accept the PM2.5 thresholds (35 / 50 µg/m³) and the winter closing at 18 °C?
    + L5 frees the north-east corner: the corner study's bedroom swap (`studies/ne_corner.typ`) is then not needed. Confirm Phase 1 can assume the corner returns to its V9.1 rooms?
  ],
)
#v(3pt)
#block(width: 100%, inset: 4pt, fill: rgb("#eef4ec"), radius: 2pt)[#set text(lang: "ar", dir: rtl, font: ("Segoe UI", "Arial"), size: 8.6pt)
  #set par(leading: 0.62em)
  *ملخص المرحلة 0:* الرياح في الطائف صيفا مساءً غربية (نحو 50٪) وشمالية غربية (نحو 30٪) بسرعة نحو 21 كم/س، فالأولوية لوجهي البرج الغربي ثم الشمالي. في السنة نحو #year-hours ساعة جلوس (من 4 عصرا إلى 11 ليلا) لطيفة وخالية من الغبار، وأفضلها أكتوبر ومايو والربيع والخريف؛ صيفا تكون الحرارة عالية في ثلث الوقت تقريبا فيعمل المبرد الصحراوي (الهواء جاف جدا فيخرج المبرد هواءً بنحو 20–22°م)، وشتاءً يُغلق الملقف حين تقل الحرارة عن 18°م. الغبار نحو 62 يوما في السنة وأكثره في مارس والصيف، فلا بد من مصيدة غبار وحساس للغبار. البيانات من محطة مطار الطائف وتحتاج تأكيدا في موقع المزرعة.
]
#v(2pt)
#text(6.2pt, fill: gray)[Phase 0 checks #if all-ok [*passed* (#checks.len())] else [*FAILED*: #checks.filter(c => not c.at(1)).map(c => c.at(0)).join([; ])] · *Sources:* Meteostat bulk hourly data, station 41036 Taif (bulk.meteostat.net), 2011–2025, 128 500 records; NOAA NCEI Integrated Surface Database (ISD) global-hourly, station 41036099999, 2015–2024, synoptic reports (noaa-global-hourly-pds); Windfinder, Taif Regional Airport statistics (prevailing W, 259°, 2011–2026); weatherandclimate.eu, Climate of Taif (monthly normals, which agree with the station means above); "Spatial and temporal variations in the incidence of dust storms in Saudi Arabia revealed from in situ observations" (Geosciences 2019; Cranfield and Exeter repositories: the west 5–15 dust-storm events a year, the spring peak). Reproduce: `python tools/climate_taif.py`.]


// ======================================================================= PHASE 1 · L5 GEOMETRY AND VARIANTS (9 Nov 2026, after the owner's Phase 0 answers)
// The owner's answers: the seating hours 16–23 and 20–32 °C accepted; the PM2.5 thresholds 35 / 50 and the winter closing at 18 °C accepted, always with a
// manual override; the north-east corner returns to its V9.1 rooms (the corner study not needed); an on-site weather station for a few weeks; the old house
// (one storey, ≈ 4–5 m) west of the new house: check its wind shadow (Phase 1 first estimate here, Phase 5 confirms).
// Every core below is given by its OUTER faces (RC walls 0.20, ASSUMED); its north wall is the y 6.5 wall rebuilt in RC (faces 6.4–6.6): nothing taken from
// the women's majlis or the family living. Its west face on x 4.30 (5 cm east of the riwaq's glazing line) keeps the FF gallery's west passage 1.52 m clear.
#let p1-wall = 0.20
#let sky-l5 = rgb("#d4e9f1")
#let attic-top-l5 = 8.68
#let lv-l5(v) = "+" + str(calc.round(v, digits: 2))
#let rect-c(o) = ((o.at(0), o.at(1)), (o.at(2), o.at(1)), (o.at(2), o.at(3)), (o.at(0), o.at(3)))
#let inner(o) = (o.at(0) + p1-wall, o.at(1) + p1-wall, o.at(2) - p1-wall, o.at(3) - p1-wall)
#let ar(o) = (o.at(2) - o.at(0)) * (o.at(3) - o.at(1))
#let riser = 0.12                       // the filtered path's riser (a Ø315 duct in its sealed corner compartment, ≈ 0.35 × 0.35 with its lining), ASSUMED
#let bath2-face = (4.35, 9.10)          // the FF bedroom 2 bath's north-east corner (its wall faces): the gallery's turn from the west arm into the strip
#let bal-face = 2.78                    // the stair well's balustrade face on x 2.75 (FF)
#let mesh = 0.9; #let louvre = 0.6       // the bird / insect mesh and the outlet louvres' free ratios, ASSUMED
#let VARS = (
  (id: "V-a", name: [V-a · corner core (west half of the strip)], shaft: (4.30, 6.4, 5.10, 7.6), foot: (4.30, 6.4, 5.10, 7.6), outlet: 0.70, door: 0.50, w1: false,
   fit: [no: 0.40 m clear wide, no cooler, no door ≥ 0.9], glass: 0.8),
  (id: "V-b", name: [V-b · full-strip core], shaft: (4.30, 6.4, 5.90, 7.6), foot: (4.30, 6.4, 5.90, 7.6), outlet: 0.80, door: 1.00, w1: true,
   fit: [tight: the cooler OR the filter cabinet, no standing room, the door must slide], glass: 0.8),
  (id: "V-c", name: [V-c · full-strip core, the foot chamber in the first arcade bay], shaft: (4.30, 6.4, 5.90, 7.6), foot: (4.30, 6.4, 5.90, 8.767), outlet: 1.40, door: 1.00, w1: true,
   fit: [yes: the cooler at the outlet, the filter cabinet + EC fan, the dust trap, a standing space at the door], glass: 2.1),
)
// the breeze loss chain (as studies/air_system.typ, referred to its 0.10 m² section): the head (≥ the shaft; ≈ 1.0 m² free on the windward face ASSUMED, Phase 5),
// the flaps and the shaft, the damper, the dust trap and the turn into the foot chamber, the outlet grille (0.9 m high, 60 % free); no channel (the outlet IS the core's face)
#let zeta-l1 = 2.8204 / calc.pow(1.37, 2)      // L1 (V9.3) with the channel at full width (studies/air_system.typ: V9.2 2.82, the V9.3 gain 1.37)
#let zeta-v(v) = { let b = (inner(v.shaft).at(2) - inner(v.shaft).at(0)) * (inner(v.shaft).at(3) - inner(v.shaft).at(1)) - riser; let og = v.outlet * 0.9 * louvre
  3.0 * calc.pow(0.10 / (1.0 * mesh), 2) + 1.5 * calc.pow(0.10 / b, 2) + 1.5 * calc.pow(0.10 / b, 2) + 2.5 * calc.pow(0.10 / og, 2) }
#let b-area(v) = (inner(v.shaft).at(2) - inner(v.shaft).at(0)) * (inner(v.shaft).at(3) - inner(v.shaft).at(1)) - riser
#let index(v) = calc.sqrt(zeta-l1 / zeta-v(v))
#let q-at(z, v-wind: 5.8) = 0.10 * calc.sqrt(2 * 0.5 * 1.15 * v-wind * v-wind * 0.8 / (1.15 * z))   // m³/s at the 10 m mast's summer-evening mean (≈ 21 km/h), ΔCp 0.8 ASSUMED
#let turn(v) = calc.sqrt(calc.pow(bath2-face.at(0) - v.shaft.at(0), 2) + calc.pow(bath2-face.at(1) - v.shaft.at(3), 2))
// the wind shadows (ASHRAE Fundamentals 2021 ch. 24, the roof and wake recirculation scales): R = Bs^0.67 · BL^0.33, Hc = 0.22 R, Xc = 0.5 R, Lc = 0.9 R; the wake behind a building ≈ R long
#let R-of(h, w) = calc.pow(calc.min(h, w), 0.67) * calc.pow(calc.max(h, w), 0.33)
#let old = (h: 4.5, w: 22.0, dist: 13.0)          // the old house: one storey ≈ 4–5 m (owner), ≈ 22 m long N–S facing the west wind, its east face 13.0 m upwind of L5 (deed sketch, true W; 12.6 m WSW; no obstacle WNW–NW)
#let R-old = R-of(old.h, old.w)
#let new = (h: 8.98, w: 24.25, x5: 5.1, edge: 7.65)   // the new house to the attic coping (+8.68 = 8.98 above the ground), 24.25 m long facing the west wind; L5's centre 5.1 m from its west face
#let R-new = R-of(new.h, new.w)
#let Hc = 0.22 * R-new; #let Xc = 0.5 * R-new; #let Lc = 0.9 * R-new
#let bubble-top = attic-top-l5 + Hc
#let checks1 = (
  ([the FF gallery's west passage ≥ 1.5 m clear beside every core (#r1(VARS.at(0).shaft.at(0) - bal-face) m)], VARS.all(v => v.shaft.at(0) - bal-face >= 1.5 - 1e-6)),
  ([the gallery's turn from its west arm into the strip ≥ 1.5 m clear past every core (#str(calc.round(turn(VARS.at(1)), digits: 2)) m)], VARS.all(v => turn(v) >= 1.5 - 1e-6)),
  ([no core enters the women's majlis or the family living (north outer face ≥ y 6.4, the y 6.5 wall's own face)], VARS.all(v => v.shaft.at(1) >= 6.4 - 1e-9 and v.foot.at(1) >= 6.4 - 1e-9)),
  ([V-c's foot chamber takes the cooler envelope 0.8 × 0.7 (#ASSUMED) beside a 0.45 × 0.60 filter cabinet with 0.6 m to stand at the door], (inner(VARS.at(2).foot).at(2) - inner(VARS.at(2).foot).at(0)) >= 0.8 + 0.4 - 1e-6 and (inner(VARS.at(2).foot).at(3) - inner(VARS.at(2).foot).at(1)) >= 0.7 + 0.6 + 0.6 - 1e-6),
  ([the old house's wake (≈ #r1(R-old) m) ends before L5 (#r1(old.dist) m downwind)], R-old < old.dist),
)
#let ok1 = checks1.all(c => c.at(1))

// the key plans of the north-west corner (GF, FF, roof) for one variant
#let corner(v, floor) = cetz.canvas(length: 0.415cm, {
  import cetz.draw: *
  let Q(p) = (p.at(0), -p.at(1))
  let box4(o, f, s) = line(..rect-c(o).map(Q), close: true, fill: f, stroke: s)
  let lbl(p, t, c) = content(Q(p), text(4pt, fill: c, t))
  box4((2.0, 5.2, 9.2, 13.4), rgb("#f3efe6"), none)
  if floor == "GF" {
    box4((4.25, 6.5, 8.95, 13.0), rgb("#dfe9d3"), none); lbl((7.2, 12.85), [courtyard], green)
    box4((5.925, 7.1, 8.85, 12.3), none, (paint: amber, thickness: 0.4pt, dash: "dashed")); lbl((7.4, 11.9), [seating], amber)
    box4((4.25, 6.5, 5.8, 13.0), rgb("#e8eadf"), none); lbl((5.0, 12.4), [covered strip], gray)
    box4((2.0, 5.2, 9.2, 6.4), rgb("#e9e2d2"), none); lbl((6.6, 5.8), [women's majlis], gray)
    box4((2.75, 6.5, 4.25, 13.0), rgb("#f1ebdd"), none); lbl((3.5, 11.6), [riwaq], gray)
    line(Q((4.25, 6.8)), Q((4.25, 8.9)), stroke: 1.6pt + blue); line(Q((4.25, 10.7)), Q((4.25, 12.7)), stroke: 1.6pt + blue); line(Q((4.25, 9.1)), Q((4.25, 10.5)), stroke: 1.0pt + blue)
    for c in ((5.8, 6.5), (5.8, 8.667), (5.8, 10.833), (5.8, 13.0)) { circle(Q(c), radius: 0.15, fill: ink, stroke: none) }
    box4(v.foot, rgb("#3a3f3b"), none); box4(inner(v.foot), sky-l5, none)
    if v.id == "V-c" { line(Q((5.9, 7.1)), Q((5.9, 8.5)), stroke: 3pt + green); line(Q((4.6, 8.767)), Q((5.6, 8.767)), stroke: 3pt + rgb("#9c6b3c")) }
    else { line(Q((v.foot.at(2), v.foot.at(1) + 0.3)), Q((v.foot.at(2), v.foot.at(1) + 0.3 + v.outlet * 0.8)), stroke: 3pt + green); line(Q((v.foot.at(0) + 0.15, v.foot.at(3))), Q((v.foot.at(0) + 0.15 + v.door, v.foot.at(3))), stroke: 3pt + rgb("#9c6b3c")) }
  } else if floor == "FF" {
    box4((2.0, 5.2, 9.2, 6.4), rgb("#f1e3c8"), none); lbl((6.6, 5.8), [family living], gray)
    box4((2.0, 7.9, 2.75, 9.2), rgb("#d3e6ee"), none); box4((2.0, 9.2, 4.25, 11.0), rgb("#d3e6ee"), none); lbl((3.0, 10.1), [bath 2], gray)
    box4((2.0, 5.2, 2.75, 7.9), rgb("#e4e0d6"), none); lbl((2.35, 7.0), [stair], gray)
    box4((2.75, 6.5, 4.25, 9.2), rgb("#f6f3ec"), none); box4((4.25, 6.5, 5.8, 13.4), rgb("#f6f3ec"), none); lbl((3.5, 8.6), [gallery], gray)
    box4((2.0, 11.0, 4.25, 13.4), rgb("#f1e3c8"), none); lbl((3.1, 12.3), [bedroom 2], gray)
    box4((5.8, 6.5, 9.2, 13.4), white, none); lbl((7.4, 9.9), [courtyard sky], gray)
    for (a, b) in ((6.783, 8.383), (8.95, 10.55), (11.117, 12.717)) { line(Q((5.8, a)), Q((5.8, b)), stroke: 1.6pt + blue) }
    box4(v.shaft, rgb("#3a3f3b"), none); box4(inner(v.shaft), sky-l5, none)
    line(Q((v.shaft.at(0), v.shaft.at(3))), Q(bath2-face), stroke: (paint: red, thickness: 0.6pt, dash: "dashed")); lbl((3.9, 8.3), [#str(calc.round(turn(v), digits: 2))], red)
    line(Q((bal-face, 7.0)), Q((v.shaft.at(0), 7.0)), stroke: (paint: red, thickness: 0.6pt)); lbl((3.55, 6.85), [1.52], red)
  } else {
    box4((2.0, 5.2, 9.2, 13.4), rgb("#ece6d8"), none)
    box4((5.8, 6.5, 8.95, 13.0), white, (paint: gray, thickness: 0.5pt)); lbl((7.4, 9.9), [sky (guard)], gray)
    box4((2.85, 5.2, 4.15, 5.6), rgb("#dbe7ec"), none); lbl((3.5, 5.45), [Z3 tank ↑], gray)
    line(Q((3.5, 5.2)), Q((3.5, 13.4)), stroke: (paint: gray, thickness: 0.5pt, dash: "dash-dotted")); lbl((3.2, 12.0), [walkway], gray)
    box4((v.shaft.at(0), 5.6, v.shaft.at(2), v.shaft.at(3)), rgb("#d2b27a"), 0.6pt + ink); lbl(((v.shaft.at(0) + v.shaft.at(2)) / 2, 6.6), [head ≥\ shaft], ink)
  }
  content(Q((2.1, 13.95)), anchor: "west", text(4.6pt, weight: "bold", fill: green)[#v.id · #floor])
})

#pagebreak()
#text(12pt, weight: "bold", fill: green)[Phase 1 · L5 geometry and variants · the north-west corner of the courtyard, inside the covered strip]
#v(1pt)
#text(7pt, fill: gray)[The owner's answers to Phase 0 (9 Nov 2026) applied. Every core by its *outer faces* (RC walls 0.20, #ASSUMED); its north wall is the y 6.5 wall rebuilt in RC (nothing taken from the women's majlis or the family living); its west face on x 4.30 keeps the gallery's west passage *1.52 m clear*. GF: the outlet (green) and the door (brown). FF: the passage widths (red). Roof: the head may grow north over the family living's roof (D7: ≥ the shaft, a funnel). 1 m = 0.415 cm.]
#v(2pt)
#grid(columns: (auto, auto, auto, auto, auto, auto, auto, auto, auto), column-gutter: 1pt, row-gutter: 2pt,
  ..VARS.map(v => ("GF", "FF", "ROOF").map(f => corner(v, f))).flatten())
#v(3pt)
#table(columns: (1.5fr, auto, auto, auto, auto, auto, 1.5fr, 1.4fr, auto), inset: 2.2pt, stroke: 0.4pt + luma(175), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f3f1ea") },
  [*Variant*], [*Shaft clear*], [*Breeze area*], [*Foot chamber*], [*Outlet (free)*], [*Door*], [*Fits (cooler / filters / dust trap)*], [*What is lost*], [*Breeze (L1 V9.3 = 1)*],
  ..VARS.map(v => (
    [*#v.name*],
    [#r1(inner(v.shaft).at(2) - inner(v.shaft).at(0)) × #r1(inner(v.shaft).at(3) - inner(v.shaft).at(1)) = #str(calc.round(ar(inner(v.shaft)), digits: 2)) m²],
    [#str(calc.round(b-area(v), digits: 2)) m²],
    [#r1(inner(v.foot).at(2) - inner(v.foot).at(0)) × #str(calc.round(inner(v.foot).at(3) - inner(v.foot).at(1), digits: 2)) = #str(calc.round(ar(inner(v.foot)), digits: 2)) m²],
    [#r1(v.outlet) × 0.9 (#str(calc.round(v.outlet * 0.9 * louvre, digits: 2)) m²)],
    [#str(calc.round(v.door, digits: 2)) m],
    [#v.fit],
    [strip #str(calc.round((calc.min(v.foot.at(2), 5.8) - 4.25) * (v.foot.at(3) - 6.5), digits: 1)) m² · gallery #str(calc.round((calc.min(v.shaft.at(2), 5.8) - 4.25) * (v.shaft.at(3) - 6.5), digits: 1)) m² · riwaq glass #r1(v.glass) m solid#if v.w1 [ · W1-1 covered (Phase 3)] else [ · W1-1 untouched (a 0.7 m dead pocket beside the core)]],
    [*#str(calc.round(index(v), digits: 1))* (≈ #str(calc.round(q-at(zeta-v(v)), digits: 2)) m³/s)],
  )).flatten()
)
#v(4pt)
#block(width: 100%, inset: 4pt, fill: rgb("#f6efe2"), radius: 2pt)[#text(8pt, weight: "bold", fill: green)[Finishes (owner, 9 Nov 2026): render and paint, no stone.] #text(7pt)[The L5 core and its head are designed in *render and paint*: a light sand render; the projections (the cornice band below the head, the crowning Hijazi cornice, the arch surrounds of the head's openings and of the courtyard outlet) in the optional calm honey tone. Every projection, arch and cornice is *formed in the RC core and block* (not applied), with a drip and a fall on its top; plaster mesh over every block / concrete junction before rendering. No stone anywhere on the tower (this replaces the "honey stone" of `studies/malqaf_tower.typ` and of the V9.3 tower). Phase 5 designs the head on this basis.]]
#v(3pt)
#text(6.2pt, fill: gray)[Breeze: the air study's loss chain referred to its 0.10 m² section, with the same head pressure for all (ΔCp 0.8, the summer-evening mean wind 21 km/h): L1 (V9.3, the channel at full width) #str(calc.round(q-at(zeta-l1), digits: 2)) m³/s. The L5 head's pressure is *not yet* the same (§ 1.3). Riser = the filtered path's Ø315 duct compartment (#riser m²) inside the core. All #ASSUMED.]

#pagebreak()
#text(12pt, weight: "bold", fill: green)[Phase 1 · the foot chamber (V-c), the outlet, the door · the passage limit · the wind shadows]
#v(3pt)
#grid(columns: (auto, 1fr), gutter: 12pt,
  cetz.canvas(length: 2.3cm, {
    import cetz.draw: *
    let Q(p) = (p.at(0), -p.at(1))
    let o = VARS.at(2).foot; let i = inner(o)
    line(..rect-c(o).map(Q), close: true, fill: rgb("#3a3f3b"), stroke: none); line(..rect-c(i).map(Q), close: true, fill: rgb("#f4f1ea"), stroke: none)
    line(..rect-c((4.5, 6.6, 5.7, 7.4)).map(Q), close: true, fill: sky-l5.transparentize(30%), stroke: (paint: blue, thickness: 0.4pt, dash: "dashed")); content(Q((5.35, 6.72)), text(3.6pt, fill: blue)[shaft above])
    line(..rect-c((4.55, 6.65, 5.35, 7.35)).map(Q), close: true, fill: none, stroke: 0.5pt + gray); content(Q((4.95, 7.15)), text(3.8pt)[dust trap (floor basin,\ grating, drain)])
    line(..rect-c((4.5, 6.6, 4.85, 6.95)).map(Q), close: true, fill: rgb("#dfe8d0"), stroke: 0.4pt + green); content(Q((4.675, 6.78)), text(3.2pt)[riser (b)])
    line(..rect-c((4.9, 7.55, 5.7, 8.25)).map(Q), close: true, fill: rgb("#e8f1f6"), stroke: 0.6pt + blue); content(Q((5.3, 7.9)), text(4pt)[mobile cooler\ 0.8 × 0.7 × ≤ 1.6])
    line(..rect-c((4.5, 7.55, 4.95, 8.15)).map(Q), close: true, fill: rgb("#dfe8d0"), stroke: 0.6pt + green); content(Q((4.725, 7.85)), text(3.4pt)[filters\ + EC fan])
    line(Q((5.9, 7.1)), Q((5.9, 8.5)), stroke: 4pt + green); content(Q((6.25, 7.8)), angle: 90deg, text(4.2pt, fill: green)[outlet 1.4 × 0.9 (louvres)])
    line(Q((4.6, 8.767)), Q((5.6, 8.767)), stroke: 4pt + rgb("#9c6b3c")); content(Q((5.1, 9.0)), text(4.2pt, fill: rgb("#9c6b3c"))[carved door 1.0 m → the covered strip])
    circle(Q((4.6, 8.45)), radius: 0.05, fill: blue, stroke: none); content(Q((4.7, 8.48)), anchor: "west", text(3.2pt)[water · drain · IP44])
    circle(Q((5.8, 6.5)), radius: 0.15, fill: luma(90), stroke: none); content(Q((6.0, 6.35)), anchor: "west", text(3.4pt)[C21 inside the wall])
    circle(Q((5.8, 8.667)), radius: 0.12, fill: luma(90), stroke: none)
    content(Q((4.3, 9.35)), anchor: "west", text(4.4pt, weight: "bold", fill: green)[V-c · the GF foot chamber · 1 m = 2.3 cm])
  }),
  [
    #H[1.1 · The passage limit sets the shaft (a finding)]
    - At the first floor the gallery's north arm (x 2.75–4.25, beside the stair) turns into the strip (x 4.25–5.80) *between the core's south face and bedroom 2's bath* (its north-east corner at (4.35, 9.10)). For ≥ 1.5 m there the core's south face must stay at *y ≤ 7.6*: the shaft is at most *1.2 × 0.8 m clear (0.96 m²)*, the same order as L1. It is enough aerodynamically (its loss is ≈ 2 % of the chain: the head and the outlet govern), but it is *not* the "large" shaft of D7. *Options:* accept a 1.2 m turn (the shaft 1.2 × 1.1 = 1.32 m²), or move bath 2's north-east corner (a room change).
    - *The foot chamber is free of that limit:* under the gallery floor it may run south; V-c ends it at the *first arcade column (y 8.667)*, so the outlet fills *the first arch* of the courtyard arcade, facing the seating along the colonnade line (no channel, the route ≈ 1 m).
    #H[1.2 · The foot chamber (V-c), the outlet, the door]
    - *Clear 1.20 × 1.97 m (2.36 m²), ≈ 3.1 m high (to the FF slab) and open above into the shaft.* The dust trap: a 0.8 × 0.7 floor basin under the shaft (a lift-out stainless grating, a 0.25 m deep sump, a drain to the courtyard drainage); the filtered path's riser in the north-west corner, its filter cabinet + EC fan (0.45 × 0.60) at the west wall; the cooler's place at the outlet; a water point (capped until a cooler is bought: the malqaf is a *dry system*, owner 9 Nov 2026), a floor drain, a dedicated circuit and IP44 sockets.
    - *The cooler (D9):* the common portable desert coolers sold in the Kingdom run from ≈ 45 L tanks (≈ 0.4 × 0.35 × 1.0 m) to 90–150 L (≈ 0.6–0.8 × 0.5–0.7 × 1.3–1.6 m); the chamber is laid out for the larger envelope *0.8 × 0.7 × 1.6 m* (#ASSUMED: the owner's shortlist to confirm), rolled in through the door, its outlet against the grille.
    - *The outlet:* *1.4 × 0.9 m* in the first arch, sill +0.10, adjustable timber louvres or a pierced precast-concrete grille, rendered and painted (≈ 60 % free, 0.76 m²) aiming the air along the seating; a motorised insulated damper behind it (Phase 4).
    - *The door:* *1.0 m clear, full height (≈ 2.4 m)*, a carved timber door on the chamber's south face, opening onto the covered strip (the strip south of the core, 1.55 × 4.2 m, stays the riwaq's courtyard edge).
  ],
)
#v(3pt)
#grid(columns: (1fr, 1fr), gutter: 12pt,
  [
    #H[1.3 · The wind shadows (first estimate; Phase 5 confirms)]
    - *The old house* (one storey, ≈ 4–5 m, the owner): for a due-west wind its east face is *#r1(old.dist) m upwind* of L5 (12.6 m for WSW; *nothing upwind for WNW–NW*). Its recirculating wake is ≈ R = #r1(R-old) m long and ≈ 1.5–2 H (≈ 7–9 m) high near it: *L5 is beyond it*, and a head above ≈ +10 is above its decaying wake. ✓
    - #WARN[*the new house's own roof matters more:* L5 stands #r1(new.x5) m behind the west facade, where the flow separating over the parapet and the attic is at its highest: R = #r1(R-new) m, the recirculation bubble ≈ #r1(Hc) m high at #r1(Xc) m from the west edge (L1 sits near its tail, ≈ #r1(Lc) m). With the L1 head's openings (+10.35 … +11.73) the L5 west face would breathe partly *inside* the bubble (top ≈ #lv-l5(bubble-top)). *Phase 5 to set the L5 openings from ≈ +11.0 up to ≈ +12.6, the crown ≈ +13.2 (≈ 4.5 m above the attic)*, or accept a weaker west face in a pure west wind (the north face still catches NW).]
  ],
  [
    #H[1.4 · The on-site weather station (the owner's question)]
    - *Where:* on the build land at the L5 spot or as close as possible (≈ 6 m east of the M line, ≈ 14 m south of the gate), in the open, *not* on the old house's roof (its own disturbance).
    - *Height:* the anemometer *≥ 6 m above the ground, ideally 10 m* (the airport's standard, and the tower head's ≈ +12 m), on a guyed telescopic mast; a second, cheap sensor at ≈ 4 m would show the old house's shadow.
    - *What:* an ultrasonic anemometer (no moving parts) or a cup + vane, temperature / humidity, a PM2.5 sensor if possible; *1-minute averages*, logged; *≥ 4–6 weeks*, the evenings with a west wind included. We compare it with the airport for the same days.
  ],
)
#v(2pt)
#text(6.4pt)[*Open questions for the owner (Phase 1):* (1) V-c (recommended) with the shaft limited to 0.96 m² by the gallery's 1.5 m turn, or accept a 1.2 m turn for a 1.32 m² shaft? (2) The riwaq's first glass panel (y 6.8–8.9, 2.1 m) becomes solid in V-c (the glass door and the 2.0 m south panel stay): OK? (3) The carved door on the chamber's south face into the covered strip: OK? (4) The Phase 0 answer had blanks: the farm's distance and direction from the airport, the trees or hills to the west; and whether to add the winter late mornings (Dec–Jan 10:00–13:00 average ≈ 20–23 °C) to the seating hours.]
#v(2pt)
#block(width: 100%, inset: 4pt, fill: rgb("#eef4ec"), radius: 2pt)[#set text(lang: "ar", dir: rtl, font: ("Segoe UI", "Arial"), size: 8.4pt)
  #set par(leading: 0.6em)
  *ملخص المرحلة 1:* قُورنت ثلاثة بدائل للملقف في الركن الشمالي الغربي للفناء. الممر العلوي يفرض حدا: ليبقى عرض الالتفاف 1.5 م عند حمام غرفة النوم 2 لا يتجاوز المجرى في الدور الأول 1.2 × 0.8 م صافيا (0.96 م²)، وهذا يكفي هوائيا لأن الخسارة الكبرى في الرأس والفتحة. *التوصية: البديل (ج)*: غرفة القاعدة في الدور الأرضي تمتد إلى أول عمود في الرواق المقوّس (1.2 × 1.97 م صافيا) وفيها مصيدة الغبار وخزانة المرشحات والمروحة ومكان المبرد الصحراوي المتنقل، وفتحة الهواء 1.4 × 0.9 م داخل أول قوس مقابل الجلسة مباشرة، وباب خشبي منحوت بعرض 1 م. النسيم المقدّر نحو 3.5 أضعاف الموقع الحالي. البيت القديم على بعد 13 م غربا فلا يحجب الرأس، لكن سقف البيت الجديد نفسه يحدث دوامة فوقه فيجب رفع فتحات الرأس إلى نحو +11 حتى +12.6 م (المرحلة 5). محطة الطقس: على أرض البناء في موضع البرج، بارتفاع 6 م على الأقل والأفضل 10 م، لمدة 4–6 أسابيع.
]
#v(2pt)
#text(6.2pt, fill: gray)[Phase 1 checks #if ok1 [*passed* (#checks1.len())] else [*FAILED*: #checks1.filter(c => not c.at(1)).map(c => c.at(0)).join([; ])] · sources: data/rooms_gf.csv / rooms_ff.csv (V9.3), studies/structure.typ (C17, C21, B3, B4, R11), 3d/character.yaml (the arcade columns at y 8.667 / 10.833), data/deed_sketch.csv (the old house), ASHRAE Handbook — Fundamentals 2021, ch. 24 (Airflow around buildings: R, Hc, Xc, Lc); cooler sizes from Saudi and Gulf retail listings (Carrefour KSA 90 L, Aftron / Alhayyat / ALM 150 L).]


// ======================================================================= PHASE 2 · STRUCTURE (9 Nov 2026, after the owner's Phase 1 answers)
// The owner's answers: V-c with the 0.96 m² shaft, the gallery's turn kept at 1.5 m; the riwaq's first glass panel solid; the carved door on the chamber's
// south face; the winter late mornings (Dec–Jan 10:00–13:00) added to the seating hours; no stone (render and paint). Every figure ASSUMED (no soil report,
// no SBC 301 data yet): concept values for the structural engineer.
#let g-c = 25.0                          // kN/m³ reinforced concrete
#let tw2 = 0.20                          // the core's RC walls
// the V-c core on its wall centre lines: the shaft x 4.40–5.80, y 6.5–7.5 (outer 4.30–5.90 × 6.4–7.6); the foot chamber to the arcade column line y 8.667
#let cx0 = 4.40; #let cx1 = 5.80; #let cy0 = 6.5; #let cy1 = 7.5; #let cy2 = 8.667
#let z-fdn = -0.6; #let z-ff = 3.52; #let z-roof = 7.2; #let z-crown = 13.2
#let perim = 2 * ((cx1 - cx0) + (cy1 - cy0))
#let w-shaft = perim * tw2 * g-c * (z-roof - z-fdn) - (cx1 - cx0 - tw2) * tw2 * g-c * (z-ff - z-fdn)   // the shaft's south wall starts at the FF slab (a 1.2 m lintel over the chamber)
#let w-chamber = (2 * (cy2 - cy1) + (cx1 - cx0)) * tw2 * g-c * (z-ff - z-fdn) - (1.4 * 0.9 + 1.0 * 2.4) * tw2 * g-c
#let head = (side-x: 1.6, side-y: 1.6, t: 0.20, open: 1.4)   // the head 1.6 × 1.6 outside (the core 1.6 × 1.2 + a 0.4 m funnel cantilever north over the family living's roof, D7), 4 faces × ≈ 1.4 m² gross openings
#let w-head = 2 * ((head.side-x - head.t) + (head.side-y - head.t)) * head.t * g-c * (z-crown - 7.3) - 4 * head.open * head.t * g-c + 25.0   // + the band, the crowning cornice and the top slab ≈ 25 kN
// the beams that the core now carries (line loads ASSUMED, service): B3 the edge beam (x 5.80), B4 (x 4.25), R11 the roof edge (x 5.80), B2 / R1 (y 6.5)
#let beams = (
  (id: "B3", line: [x 5.80, FF], q: 12.0, was: 6.50, now: 13.0 - cy2, on-core: cy2 - cy0, note: [bears on the chamber's east wall to the arcade column line]),
  (id: "B4", line: [x 4.25, FF, drop], q: 25.0, was: 6.50, now: 13.0 - cy2, on-core: cy2 - cy0, note: [cast with the chamber's west wall (it overlaps the wall's outer 0.075 m: a local widening or a nib)]),
  (id: "R11", line: [x 5.80, roof], q: 10.0, was: 6.50, now: 13.0 - cy1, on-core: cy1 - cy0, note: [bears on the shaft's east wall]),
  (id: "B2 / R1", line: [y 6.5, FF / roof], q: 10.0, was: 1.55, now: 0.0, on-core: cx1 - cx0, note: [their first span (C17 → C21) is the core's north wall]),
)
#let reac(b) = b.q * b.on-core + (if b.now > 0 { b.q * b.now / 2 } else { 0 })
#let w-floors = beams.map(reac).sum()
#let w-total = w-shaft + w-chamber + w-head + w-floors
#let q-soil = 150.0                      // kPa allowable, ASSUMED (no soil report)
#let pad = (bx: 2.4, by: 3.0, t: 0.6)    // one pad under the core and the chamber (replaces the pads of C17, C21 and the arcade column)
#let q-pad = (w-total + pad.bx * pad.by * pad.t * g-c) / (pad.bx * pad.by)
// lateral, the head above the roof (a cantilever 5.9 m): wind (q 1.1 kPa, Cf 1.3, ASSUMED) and seismic as a rooftop appendage (SBC 301 / ASCE 7 § 13.3: Fp = 0.4 ap Sds Wp (1 + 2 z/h) / (Rp / Ip), ap 2.5, Rp 2.5, Ip 1.0, z = h)
#let h-head = z-crown - 7.3
#let F-wind = 1.1 * 1.3 * head.side-x * h-head
#let M-wind = F-wind * h-head / 2
#let Fp(sds) = calc.min(0.4 * 2.5 * sds * w-head * 3 / 2.5, 1.6 * sds * w-head)
#let M-seis(sds) = Fp(sds) * h-head / 2
#let S-head = (calc.pow(head.side-x, 4) - calc.pow(head.side-x - 2 * head.t, 4)) / 12 / (head.side-x / 2)   // the head's RC tube, its section modulus (m³), openings ignored
#let checks2 = (
  ([the pad's bearing #r1(q-pad) kPa ≤ the assumed #r1(q-soil) kPa], q-pad <= q-soil),
  ([B3's and B4's first spans drop from 6.50 to #r1(13.0 - cy2) m (moments ≈ #str(calc.round(100 * (1 - calc.pow((13.0 - cy2) / 6.5, 2)))) % less)], 13.0 - cy2 < 6.5),
  ([the head's stress at the roof under the seismic case (Sds 0.25) #str(calc.round(M-seis(0.25) / S-head / 1000, digits: 2)) MPa, far below the concrete's capacity (openings halve the section: still ≤ 1 MPa)], M-seis(0.25) / S-head / 1000 * 2 <= 1.0),
)
#let ok2 = checks2.all(c => c.at(1))

#pagebreak()
#text(12pt, weight: "bold", fill: green)[Phase 2 · structure · the L5 core as an independent RC core, the fourth support of the west projection]
#v(1pt)
#text(7pt, fill: gray)[The owner's Phase 1 answers applied: *V-c*, the shaft 1.2 × 0.8 m clear (the gallery's turn kept at 1.5 m); the riwaq's first glass panel solid; the carved door on the chamber's south face; *the winter late mornings added* (Dec–Jan 10:00–13:00: ≈ 61 % pleasant, ≈ 113 h a year more, ≈ #(year-hours + 113) h in all); *no stone* (render and paint). Every figure #ASSUMED (no soil report, no SBC 301 site data): concept values for the structural engineer.]
#v(3pt)
#grid(columns: (auto, auto, 1fr), gutter: 10pt,
  cetz.canvas(length: 0.95cm, {
    import cetz.draw: *
    let Q(p) = (p.at(0), -p.at(1))
    let wall(a, b, c) = line(Q(a), Q(b), stroke: 5pt + c)
    rect(Q((3.6, 5.7)), Q((6.6, 13.4)), fill: rgb("#f6f3ec"), stroke: none)
    rect(Q((4.3 - 0.4, 6.4 - 0.4)), Q((5.9 + 0.1, 8.767 + 0.23)), fill: none, stroke: (paint: amber, thickness: 0.6pt, dash: "dashed")); content(Q((3.82, 9.15)), anchor: "west", text(4pt, fill: amber)[pad #pad.bx × #pad.by × #pad.t])
    for (a, b) in (((cx0, cy0), (cx1, cy0)), ((cx1, cy0), (cx1, cy2)), ((cx0, cy0), (cx0, cy2)), ((cx0, cy2), (cx1, cy2))) { wall(a, b, rgb("#3a3f3b")) }
    line(Q((cx0, cy1)), Q((cx1, cy1)), stroke: (paint: rgb("#3a3f3b"), thickness: 2pt, dash: "dashed")); content(Q((5.1, 7.35)), text(3.6pt)[shaft's S wall from the FF slab (lintel)])
    line(Q((4.25, 6.5)), Q((4.25, 13.0)), stroke: 1.2pt + blue); content(Q((4.05, 11.0)), angle: 90deg, text(4.2pt, fill: blue)[B4 #r1(13.0 - cy2) m (was 6.50)])
    line(Q((5.8, 6.5)), Q((5.8, 13.0)), stroke: 1.2pt + red); content(Q((6.0, 11.0)), angle: 90deg, text(4.2pt, fill: red)[B3 #r1(13.0 - cy2) m · R11 #r1(13.0 - cy1) m])
    line(Q((4.25, 6.5)), Q((6.6, 6.5)), stroke: 1pt + gray); content(Q((6.3, 6.3)), text(3.6pt, fill: gray)[B2 / R1 →])
    for (p, n, done) in (((4.25, 6.5), [C17], true), ((5.8, 6.5), [C21], true), ((5.8, 8.667), [arcade col.], true), ((5.8, 10.833), [arcade col.], false), ((5.8, 13.0), [C22], false)) {
      circle(Q(p), radius: 0.13, fill: if done { amber } else { ink }, stroke: none); content(Q((p.at(0) + 0.25, p.at(1) - 0.18)), anchor: "west", text(3.6pt, fill: if done { amber } else { ink })[#n#if done [ → core]]) }
    line(Q((5.8, 7.1)), Q((5.8, 8.5)), stroke: 3pt + green); content(Q((6.25, 7.8)), text(3.4pt, fill: green)[outlet])
    line(Q((4.5, 8.667)), Q((5.7, 8.667)), stroke: 3pt + rgb("#9c6b3c")); content(Q((5.1, 8.95)), text(3.6pt, fill: rgb("#9c6b3c"))[door 1.0])
    content(Q((3.65, 13.25)), anchor: "west", text(4.6pt, weight: "bold", fill: green)[PLAN (structure) · 1 m = 0.95 cm])
  }),
  cetz.canvas(length: 0.42cm, {
    import cetz.draw: *
    let P(y, z) = (y, z)
    rect(P(5.0, -1.2), P(9.6, 14.2), fill: rgb("#fbfaf6"), stroke: none)
    rect(P(6.0, z-fdn - 0.6), P(9.0, z-fdn), fill: luma(150), stroke: none); content(P(7.5, -1.55), text(3.8pt)[pad −0.60 … −1.20])
    rect(P(6.4, z-fdn), P(6.6, z-roof), fill: rgb("#3a3f3b"), stroke: none)
    rect(P(7.4, z-ff), P(7.6, z-roof), fill: rgb("#3a3f3b"), stroke: none)
    rect(P(8.567, z-fdn), P(8.767, z-ff), fill: rgb("#3a3f3b"), stroke: none)
    rect(P(5.2, z-ff - 0.08), P(9.6, z-ff + 0.2), fill: luma(170), stroke: none); content(P(9.0, z-ff + 0.55), text(3.6pt)[FF +3.52])
    rect(P(5.2, z-roof), P(9.6, z-roof + 0.2), fill: luma(170), stroke: none); content(P(9.0, z-roof + 0.55), text(3.6pt)[roof +7.20])
    rect(P(6.6, z-fdn), P(8.567, z-fdn + 0.25), fill: sky-l5, stroke: none); content(P(7.6, 0.1), text(3.4pt)[dust trap])
    rect(P(7.6, 0.1), P(8.567, 1.0), fill: rgb("#e8f1f6"), stroke: 0.3pt + blue); content(P(8.08, 0.55), text(3.2pt)[cooler])
    rect(P(6.0, 7.4), P(7.6, z-crown), fill: rgb("#e9dcc3"), stroke: 0.5pt + ink)
    rect(P(6.0, 10.6), P(7.6, 10.75), fill: rgb("#cfae78"), stroke: 0.4pt + ink)
    for k in range(3) { rect(P(6.25 + k * 0.45, 11.0), P(6.45 + k * 0.45, 12.4), fill: rgb("#2b2b2d"), stroke: none) }
    rect(P(5.9, z-crown - 0.3), P(7.7, z-crown), fill: rgb("#cfae78"), stroke: 0.4pt + ink)
    content(P(8.6, 11.8), text(3.8pt)[openings\ +11.0 … +12.6])
    content(P(8.6, 13.2), text(3.8pt)[crown +13.20])
    line(P(5.2, 8.68), P(6.0, 8.68), stroke: 0.4pt + gray); content(P(5.25, 9.0), anchor: "west", text(3.4pt, fill: gray)[attic +8.68])
    content(P(5.1, 14.0), anchor: "west", text(4.6pt, weight: "bold", fill: green)[SECTION N–S at x ≈ 5.1 · y 5.0–9.6])
    content(P(6.5, -0.9), text(3.4pt)[y 6.5]); content(P(8.67, -0.9), text(3.4pt)[8.67])
  }),
  [
    #H[2.1 · The core]
    - *An independent RC core* (walls 0.20) from its own pad (−0.60) to the head: the shaft on the wall centre lines x #cx0–#cx1, y #cy0–#cy1 (outer 1.6 × 1.2), the foot chamber's walls to the arcade column line y #cy2 at the ground floor. Its north wall *is* the y 6.5 wall rebuilt in RC (the majlis's face unchanged); the riwaq's glazing on x 4.25 is not load-bearing and stays a glazing line south of the chamber.
    - *Absorbed:* *C17* (4.25, 6.5) into the core's north-west corner, *C21* (5.8, 6.5) into its north-east corner, the decorative *arcade column at y 8.667* into the chamber's south-east corner (it becomes structural). *Kept:* C22, C23 and the second arcade column (y 10.833).
    - *One pad* #pad.bx × #pad.by × #pad.t m under the core and the chamber (it replaces three pads), with a 0.35 m recess for the dust trap's sump.
    #H[2.2 · The fourth support (the owner's question)]
    + *B4* (x 4.25): its first span *6.50 → #r1(13.0 - cy2) m* (cast with the chamber's west wall).
    + *B3* (the edge, x 5.80): *6.50 → #r1(13.0 - cy2) m* on the chamber's east wall; *R11* (the roof edge) 6.50 → #r1(13.0 - cy1) m on the shaft.
    + *Reduced:* the first-span moments ≈ #str(calc.round(100 * (1 - calc.pow((13.0 - cy2) / 6.5, 2)))) % less, the deflections ≈ #str(calc.round(100 * (1 - calc.pow((13.0 - cy2) / 6.5, 4)))) % less: B3 and B4 could drop from 0.25 × 0.50 to ≈ 0.25 × 0.40 there (B3's upturn stays: it is W1's sill); C21 is no longer a separate column; the core also stiffens the west projection sideways (the slender C22 / C23 sway less).
    + *C21 and C17* disappear as separate members; B2's and R1's first span (C17 → C21, 1.55 m) becomes the core's north wall.
  ],
)
#v(3pt)
#grid(columns: (1fr, 1fr), gutter: 12pt,
  [
    #table(columns: (auto, 1fr, auto, auto, auto), inset: 2.2pt, stroke: 0.4pt + luma(180), fill: (_, y) => if y == 0 { rgb("#e4eedf") },
      [*Beam*], [*Line · how*], [*Span was → now (m)*], [*q kN/m*], [*On the core kN*],
      ..beams.map(b => ([*#b.id*], [#b.line · #b.note], [#str(calc.round(b.was, digits: 2)) → #if b.now > 0 [#str(calc.round(b.now, digits: 2))] else [–]], [#r1(b.q)], [#r1(reac(b))])).flatten())
    #table(columns: (1fr, auto), inset: 2.2pt, stroke: 0.4pt + luma(180), fill: (_, y) => if y == 0 { rgb("#e4eedf") },
      [*Vertical loads (service, #ASSUMED)*], [*kN*],
      [the shaft's walls (−0.60 → +7.20)], [#r1(w-shaft)],
      [the foot chamber's walls (less the outlet and the door)], [#r1(w-chamber)],
      [the head above the roof (#head.side-x × #head.side-y, to +13.20, the cornices, the top slab)], [#r1(w-head)],
      [the beams and slabs above (the table on the left)], [#r1(w-floors)],
      [*total on the pad*], [*#r1(w-total)*],
      [the pad's bearing (with its weight) vs #r1(q-soil) kPa assumed], [#r1(q-pad) kPa],
    )
  ],
  [
    #H[2.3 · The tower above the roof: wind and earthquake]
    - *The head* is a cantilever #r1(h-head) m above the roof finish, #head.side-x × #head.side-y m (the shaft 1.6 × 1.2 plus a 0.4 m funnel overhang north on the head's base slab, D7), its self-weight ≈ #r1(w-head) kN.
    - *Wind* (q 1.1 kPa, Cf 1.3, #ASSUMED; SBC 301 for Taif to the engineer): #r1(F-wind) kN, *#r1(M-wind) kN·m* at the roof.
    - *Earthquake* as a rooftop appendage (SBC 301 / ASCE 7 § 13.3, ap 2.5, Rp 2.5): with Sds 0.15 / 0.25 / 0.35 (#ASSUMED range for Taif) Fp = #r1(Fp(0.15)) / #r1(Fp(0.25)) / #r1(Fp(0.35)) kN, *#r1(M-seis(0.15)) / #r1(M-seis(0.25)) / #r1(M-seis(0.35)) kN·m* at the roof: *the earthquake governs*, not the wind. The RC tube takes it easily (≈ #str(calc.round(M-seis(0.25) / S-head / 1000, digits: 2)) MPa, the openings ignored): the head is *an RC frame* (four corner piers ≥ 0.30 × 0.30, a ring beam at the band, one at the crown) with the slender ribs between the openings as *non-structural* block or precast infill, rendered.
    - *Connections:* the FF slab and the roof slab cast into the core (starter bars), so the core is tied at both levels; the shaft's openings in the slabs are framed by its own walls (no trimmers); the head's base slab cantilevers 0.4 m north over the family living's roof.
    #H[2.4 · Openings in the core: lintels and limits]
    - *Ground floor:* the outlet 1.4 × 0.9 in the east wall (sill +0.10; a lintel at +1.00, the wall above deep); the south wall is the door: a 1.0 m door in 1.2 m clear, i.e. the wall becomes a 1.4 m lintel at +2.40 over it on the east and west walls; the shaft's south wall starts at the FF slab on a 1.2 m lintel across the chamber.
    - *First floor and above* (Phase 3 / 4): the gallery window into the shaft and the filtered-air grilles ≤ 50 % of a wall's length, ≥ 0.25 m from the corners, lintels ≥ 0.30 deep.
  ],
)
#v(2pt)
#text(6.4pt)[*Open questions for the owner (Phase 2):* (1) The head 1.6 × 1.6 with a 0.4 m funnel overhang north, or the head = the core (1.6 × 1.2) with only the cornices projecting? (2) Agree that the head is an RC frame with block / precast ribs between its openings (rendered)? (3) The Phase 0 / 1 blanks are still open: the farm's distance and direction from the airport, what lies to the west. *For the engineer:* the soil report (q allowable), SBC 301 wind and Sds for the site, B3 / B4 sections after the shorter spans, the pad and the slabs' ties to the core.]
#v(2pt)
#block(width: 100%, inset: 4pt, fill: rgb("#eef4ec"), radius: 2pt)[#set text(lang: "ar", dir: rtl, font: ("Segoe UI", "Arial"), size: 8.4pt)
  #set par(leading: 0.6em)
  *ملخص المرحلة 2:* الملقف نواة خرسانية مستقلة بجدران 20 سم على قاعدة واحدة (2.4 × 3.0 م) من الأساس إلى الرأس، وجدارها الشمالي هو جدار المجلس نفسه بعد صبه خرسانة. تبتلع النواة العمودين C17 وC21 وعمود الرواق الأول (فيصير إنشائيا)، فتصبح الدعامة الرابعة للبروز الغربي: يقصر بحر الجسرين B3 وB4 من 6.5 م إلى نحو 4.3 م (العزوم أقل بنحو 55٪ والترخيم بنحو 80٪)، ويمكن تخفيف مقطعيهما، وتزيد صلابة البروز جانبيا. الحمل الكلي نحو #str(calc.round(w-total)) كيلونيوتن، والضغط على التربة نحو #str(calc.round(q-pad)) كيلوباسكال (مفترض). الرأس فوق السطح يحكمه الزلزال لا الرياح، ويُبنى إطارا خرسانيا بأعمدة في أركانه والأضلاع بين الفتحات حشوة غير إنشائية مليّسة. كل الأرقام تقديرية للمهندس الإنشائي.
]
#v(2pt)
#text(6.2pt, fill: gray)[Phase 2 checks #if ok2 [*passed* (#checks2.len())] else [*FAILED*: #checks2.filter(c => not c.at(1)).map(c => c.at(0)).join([; ])] · sources: studies/structure.typ (C17, C21, C22, B2, B3, B4, R1, R11, the projection slab), 3d/character.yaml (the arcade columns), SBC 301 / ASCE 7-16 § 13.3 (the appendage formula), the climate script for the winter mornings. Concept only.]


// ======================================================================= PHASE 3 · FACADE: COLONNADE, GALLERY, WINDOWS, ARCHES (9 Nov 2026, after the Phase 2 answers)
// The owner's answers: the head 1.6 × 1.6 with a 0.4 m funnel overhang north (D7); the head an RC frame with corner piers and ring beams, the ribs in rendered block;
// no stone and no marble anywhere, floors included (porcelain); the farm's location still blank. Render and paint only: projections in the calm honey tone.
#let M20(x) = calc.abs(calc.round(x / 0.2) - x / 0.2) < 1e-6        // on the 20 cm module (D11)
#let bay-ax = (7.5833, 9.75, 11.9167)                              // the courtyard arcade's three bay axes (bays of 2.1667 between C21 / the core, the arcade columns and C22)
#let arch-w = 1.84; #let arch-spring = 2.40; #let arch-crown = 3.32  // the GF arcade's arches (clear between the Ø0.33 sleeves; the crown at the projection's soffit)
#let w1 = (w: 1.6, sill: 3.80, spring: 5.80, crown: 6.60)          // W1 (the sill proposed at +3.80 instead of +3.82: 2.80 m high = 14 modules)
#let outlet3 = (w: 1.4, h: 1.0, sill: 0.10)                        // the courtyard outlet, on the module (was 1.4 × 0.9)
#let door3 = (w: 1.0, h: 2.4)
#let gwin = (w: 0.8, sill: 4.20, spring: 5.40)                     // the gallery's arched grille into the shaft (0.8 × 1.6)
#let OPTS = (
  (id: "F1", name: [F1 · five windows + the tower], head: (6.0, 7.6), ff1: "narrow", note: [the minimum: W1-1 replaced by a 0.6 m arched window beside the core (off the bay axis); the head as decided (north overhang)]),
  (id: "F2", name: [F2 · the tower bay], head: (6.0, 7.6), ff1: "blind", note: [the whole first bay is the malqaf's: the outlet in the first arch, a blind arched recess above it on the same axis; the head as decided (north overhang)]),
  (id: "F3", name: [F3 · the tower begins the colonnade], head: (6.4, 8.8), ff1: "blind", note: [as F2, and the head 1.6 × 2.4 m over the whole first bay (overhang 1.2 m south over the gallery roof, on R11 / R3): one vertical from the arch to the crown]),
)
#let head-ax(o) = (o.head.at(0) + o.head.at(1)) / 2
#let archpoly(c, w, z0, zs) = ((c - w / 2, z0), (c + w / 2, z0), (c + w / 2, zs)) + range(1, 16).map(k => { let t = k * calc.pi / 16; (c + w / 2 * calc.cos(t), zs + w / 2 * calc.sin(t)) }) + ((c - w / 2, zs),)
#let sand = rgb("#efe3c8"); #let honey = rgb("#d8b47a"); #let shade = rgb("#6b665c"); #let glass = rgb("#9fc6dc"); #let timber = rgb("#9c6b3c")
// the courtyard's west face (on x 5.80), seen from the seating looking west: north on the right
#let elev-west(o, len) = cetz.canvas(length: len, {
  import cetz.draw: *
  let X(y) = 14.2 - y
  let poly(pts, f, s) = line(..pts.map(p => (X(p.at(0)), p.at(1))), close: true, fill: f, stroke: s)
  rect((X(13.3), -0.3), (X(5.6), 0), fill: rgb("#d9cdb4"), stroke: none)
  rect((X(13.1), 0), (X(6.4), 7.35), fill: sand, stroke: 0.4pt + ink)
  for c in (bay-ax.at(1), bay-ax.at(2)) { poly(archpoly(c, arch-w, 0, arch-spring), shade, none) }
  poly(archpoly(bay-ax.at(0), arch-w, 0, arch-spring), sand.darken(8%), 0.4pt + ink)
  rect((X(bay-ax.at(0) + outlet3.w / 2), outlet3.sill), (X(bay-ax.at(0) - outlet3.w / 2), outlet3.sill + outlet3.h), fill: timber.lighten(30%), stroke: 0.4pt + timber)
  for k in range(7) { let yy = bay-ax.at(0) - outlet3.w / 2 + 0.1 + k * 0.2; line((X(yy), outlet3.sill + 0.05), (X(yy), outlet3.sill + outlet3.h - 0.05), stroke: 0.4pt + timber) }
  rect((X(13.1), 3.40), (X(6.4), 3.52), fill: honey, stroke: none)
  for c in (bay-ax.at(1), bay-ax.at(2)) { poly(archpoly(c, w1.w, w1.sill, w1.spring), glass, 0.5pt + ink); line((X(c), w1.sill), (X(c), w1.crown), stroke: 0.5pt + ink) }
  if o.ff1 == "narrow" { poly(archpoly(8.15, 0.6, w1.sill, 6.3), glass, 0.5pt + ink) } else { poly(archpoly(bay-ax.at(0), w1.w, w1.sill, w1.spring), sand.darken(10%), 0.4pt + ink) }
  rect((X(13.2), 6.90), (X(6.3), 7.35), fill: honey, stroke: 0.3pt + ink)
  let (h0, h1) = o.head
  rect((X(h1), 7.35), (X(h0), 10.6), fill: sand, stroke: 0.4pt + ink)
  rect((X(h1) - 0.06, 10.6), (X(h0) + 0.06, 10.75), fill: honey, stroke: 0.3pt + ink)
  rect((X(h1), 10.75), (X(h0), 12.9), fill: sand, stroke: 0.4pt + ink)
  let n = calc.floor((h1 - h0 - 0.3 + 0.09) / 0.23); let tot = n * 0.14 + (n - 1) * 0.09
  for k in range(int(n)) { let c = h0 + (h1 - h0 - tot) / 2 + k * 0.23 + 0.07; poly(archpoly(c, 0.14, 11.0, 12.53), rgb("#2b2b2d"), none) }
  rect((X(h1) - 0.05, 12.9), (X(h0) + 0.05, 13.02), fill: honey, stroke: 0.3pt + ink); rect((X(h1) - 0.1, 13.02), (X(h0) + 0.1, 13.2), fill: honey, stroke: 0.3pt + ink)
  for c in bay-ax { line((X(c), -0.25), (X(c), 7.0), stroke: (paint: red, thickness: 0.3pt, dash: "dotted")) }
  line((X(head-ax(o)), 7.4), (X(head-ax(o)), 13.4), stroke: (paint: red, thickness: 0.3pt, dash: "dotted"))
  content((X(9.5), -0.65), text(4.4pt, weight: "bold", fill: green)[#o.id · west face from the seating (N →)])
})
#let checks3 = (
  ([W1 1.6 × 2.80 (the sill at +3.80), the outlet 1.4 × 1.0, the door 1.0 × 2.4, the gallery grille 0.8 × 1.6, the core 1.6 × 1.2, the heads 1.6 × 1.6 / 1.6 × 2.4: all on the 20 cm module], M20(w1.w) and M20(w1.crown - w1.sill) and M20(outlet3.w) and M20(outlet3.h) and M20(door3.w) and M20(door3.h) and M20(gwin.w) and M20(1.6) and M20(1.2) and M20(2.4)),
  ([the GF arches and the FF windows share their axes in bays 2–3 (W1-2, W1-3 centres = the arcade bay axes)], calc.abs((8.95 + 10.55) / 2 - bay-ax.at(1)) < 0.01 and calc.abs((11.117 + 12.717) / 2 - bay-ax.at(2)) < 0.01),
  ([F3's head covers the whole shaft (y 6.4–7.6) and stands on the first bay's axis (± 0.05)], OPTS.at(2).head.at(0) <= 6.4 and OPTS.at(2).head.at(1) >= 7.6 and calc.abs(head-ax(OPTS.at(2)) - bay-ax.at(0)) <= 0.05),
)
#let ok3 = checks3.all(c => c.at(1))

#pagebreak()
#text(12pt, weight: "bold", fill: green)[Phase 3 · the courtyard's west face · the malqaf as the head of the colonnade · three options]
#v(1pt)
#text(7pt, fill: gray)[The owner's Phase 2 answers applied: the head 1.6 × 1.6 with a 0.4 m funnel overhang north; an RC frame with corner piers and ring beams, the ribs in rendered block; *no stone and no marble anywhere, floors included* (marble-look porcelain inside, anti-slip R11 porcelain outside, recorded). Render and paint: a light sand render, the projections (the band, the cornices, the arch surrounds) in the calm honey tone. Red dotted: the bay axes (GF arches = FF windows) and the head's axis. 1 m = 0.5 cm.]
#v(3pt)
#grid(columns: (auto, auto, auto, 1fr), gutter: 8pt,
  ..OPTS.map(o => elev-west(o, 0.5cm)),
  [
    #H[3.1 · The three options]
    #table(columns: (auto, 1fr), inset: 2.2pt, stroke: 0.4pt + luma(180),
      ..OPTS.map(o => ([*#o.id*], [#o.note · the head's axis #str(calc.round(head-ax(o) - bay-ax.at(0), digits: 2)) m from the first bay's axis])).flatten())
    - *Kept in all:* W1-2 and W1-3 (bays 2–3) and the three living-bay windows W1-4…6 on their axes; their sill / springing / crown logic (the sill proposed at *+3.80*, 2.80 m high, on the module); the GF arcade's bays 2–3 open; the band at +3.40 and the main cornice in the honey tone.
    - *The first bay* (y 6.5–8.667) becomes the malqaf's: at the GF the outlet (1.4 × 1.0, timber louvres) fills the first arch, the rest of the arch a rendered infill of the core; at the FF the core covers the north 0.8 m of W1-1, so W1-1 goes: F1 puts a narrow 0.6 m window beside the core (off the bay axis: #text(fill: red)[⚠ D11]); F2 and F3 make *a blind arched recess* (1.6 × 2.80, 0.10 deep, render) on the bay axis: the arch, the recess and the tower read as one.
    - *The head:* F1 / F2 keep the decided north overhang: the head stands *#str(calc.round(bay-ax.at(0) - head-ax(OPTS.at(1)), digits: 2)) m north of the first bay's axis*, half of it beyond the colonnade's end; F3 lengthens the head south over the gallery roof (1.6 × 2.4 m, its walls on R11 and R3) so it rises *exactly on the first bay's axis*: the tower begins the colonnade.
    #H[Recommendation: F3]
    The arch with the outlet, the blind arch and the head on one vertical axis make the malqaf *the head of the row* without touching bays 2–3 and the living bay; the head grows to 3.84 m² (a bigger funnel, D7). It changes one Phase 2 answer: the funnel overhang goes *south over the gallery roof (1.2 m)* instead of north (0.4 m). If the owner keeps the north overhang: F2.
  ],
)

#pagebreak()
#text(12pt, weight: "bold", fill: green)[Phase 3 · from the courtyard looking north · from the riwaq · the gallery's grille into the shaft · the filtered-air grilles · D11]
#v(3pt)
#grid(columns: (auto, auto, auto, 1fr), gutter: 8pt,
  cetz.canvas(length: 0.5cm, {
    import cetz.draw: *
    let poly(pts, f, s) = line(..pts, close: true, fill: f, stroke: s)
    rect((3.9, -0.3), (9.3, 0), fill: rgb("#d9cdb4"), stroke: none)
    rect((4.25, 0), (8.95, 3.52), fill: sand, stroke: 0.4pt + ink)
    rect((6.0, 0.1), (8.1, 2.6), fill: glass, stroke: 0.4pt + ink)
    rect((5.1, 0.1), (5.6, 2.6), fill: none, stroke: (paint: red, thickness: 0.6pt, dash: "dashed")); content((5.35, 2.9), text(3.4pt, fill: red)[lost])
    rect((4.30, 0), (5.90, 3.52), fill: sand.darken(6%), stroke: 0.5pt + ink)
    poly(archpoly(5.1, door3.w, 0, door3.h - 0.5), timber, 0.4pt + ink); content((5.1, 1.0), text(3.4pt, fill: white)[carved\ door])
    rect((4.25, 3.40), (8.95, 3.52), fill: honey, stroke: none)
    rect((5.8, 3.52), (8.95, 7.35), fill: sand, stroke: 0.4pt + ink)
    for (a, b) in ((6.0, 7.3), (7.55, 8.85)) { poly(archpoly((a + b) / 2, b - a, 3.6, 5.95), glass, 0.4pt + ink) }
    rect((4.25, 3.52), (5.8, 7.35), fill: sand.darken(4%), stroke: 0.4pt + ink); content((5.0, 5.4), text(3.4pt)[gallery\ (end-on)])
    rect((4.1, 6.90), (9.1, 7.35), fill: honey, stroke: 0.3pt + ink)
    rect((4.30, 7.35), (5.90, 10.6), fill: sand, stroke: 0.4pt + ink); rect((4.24, 10.6), (5.96, 10.75), fill: honey, stroke: none); rect((4.30, 10.75), (5.90, 12.9), fill: sand, stroke: 0.4pt + ink)
    for k in range(4) { poly(archpoly(4.685 + k * 0.23 + 0.07, 0.14, 11.0, 12.53), rgb("#2b2b2d"), none) }
    rect((4.2, 12.9), (6.0, 13.2), fill: honey, stroke: 0.3pt + ink)
    content((6.6, -0.65), text(4.4pt, weight: "bold", fill: green)[looking NORTH from the seating (W ←)])
  }),
  cetz.canvas(length: 0.5cm, {
    import cetz.draw: *
    let X(y) = y - 5.0
    rect((X(6.3), -0.3), (X(13.2), 0), fill: rgb("#d9cdb4"), stroke: none)
    rect((X(6.5), 0), (X(13.0), 3.10), fill: rgb("#f4efe4"), stroke: 0.4pt + ink)
    rect((X(6.5), 0), (X(8.9), 3.10), fill: sand.darken(5%), stroke: 0.5pt + ink); content((X(7.7), 1.9), text(3.4pt)[the core's west face\ (was glass 6.8–8.9)])
    rect((X(6.7), 0), (X(8.7), 0.45), fill: timber.lighten(40%), stroke: 0.3pt + timber); content((X(7.7), 0.22), text(3.2pt)[bench])
    rect((X(7.2), 2.6), (X(8.0), 2.8), fill: white, stroke: 0.4pt + green); content((X(7.6), 2.95), text(3pt, fill: green)[filtered air])
    rect((X(9.1), 0), (X(10.5), 2.6), fill: glass, stroke: 0.4pt + ink); content((X(9.8), 1.3), text(3.2pt)[glass door])
    rect((X(10.7), 0.1), (X(12.7), 2.6), fill: glass, stroke: 0.4pt + ink)
    rect((X(6.5), 3.10), (X(13.0), 3.52), fill: luma(200), stroke: none); content((X(9.8), 3.3), text(3.2pt)[B4 (soffit +3.10)])
    content((X(9.6), -0.65), text(4.4pt, weight: "bold", fill: green)[the RIWAQ looking east (N ←)])
  }),
  cetz.canvas(length: 1.0cm, {
    import cetz.draw: *
    let Q(p) = (p.at(0), -p.at(1))
    rect(Q((2.6, 5.9)), Q((6.1, 9.6)), fill: rgb("#f6f3ec"), stroke: none)
    rect(Q((2.6, 5.9)), Q((6.1, 6.4)), fill: rgb("#f1e3c8"), stroke: none); content(Q((3.4, 6.15)), text(3.6pt)[family living])
    rect(Q((2.6, 9.2)), Q((4.25, 9.6)), fill: rgb("#d3e6ee"), stroke: none); content(Q((3.4, 9.4)), text(3.4pt)[bath 2])
    rect(Q((4.30, 6.4)), Q((5.90, 7.6)), fill: rgb("#3a3f3b"), stroke: none); rect(Q((4.50, 6.6)), Q((5.70, 7.4)), fill: sky-l5, stroke: none)
    line(Q((4.70, 7.5)), Q((5.50, 7.5)), stroke: 3pt + timber); content(Q((5.1, 7.85)), text(3.6pt, fill: timber)[arched grille 0.8 × 1.6\ + insulated damper])
    line(Q((4.6, 6.5)), Q((5.4, 6.5)), stroke: 2pt + green); content(Q((5.0, 6.2)), text(3.2pt, fill: green)[filtered → living])
    circle(Q((5.75, 7.75)), radius: 0.07, fill: green, stroke: none); content(Q((5.95, 8.05)), text(3.2pt, fill: green)[filtered → gallery (high)])
    line(Q((5.8, 7.6)), Q((5.8, 9.6)), stroke: 1.4pt + ink); content(Q((6.0, 9.0)), angle: 90deg, text(3.4pt)[W1-2 →])
    line(Q((4.30, 7.6)), Q((4.35, 9.10)), stroke: (paint: red, thickness: 0.5pt, dash: "dashed")); content(Q((4.0, 8.4)), text(3.4pt, fill: red)[1.50])
    content(Q((2.7, 9.95)), anchor: "west", text(4.4pt, weight: "bold", fill: green)[FF plan of the core · 1 m = 1 cm])
  }),
  [
    #H[3.2 · The gallery's window into the shaft (path a, clear days)]
    - On the shaft's *south face* at the FF (facing the gallery's turn): an *arched carved-timber grille 0.8 × 1.6* (sill +4.20, springing +5.40, a semicircular head; the W1 language in small) with an *insulated, low-leakage motorised damper* behind it in the wall: nothing swings into the 1.5 m passage or into the 0.8 m shaft. *Owner (9 Nov 2026): a provision only*: the opening formed and the grille fitted with a sealed removable panel behind it, no damper now; it reads as a carved panel.
    #H[3.3 · The filtered-air grilles (path b)]
    - From the fan in the foot chamber up the sealed riser: a high linear grille (0.8 × 0.2) through the core's *north wall into the family living* (+6.4, acoustically lined), one on its *south face into the gallery* (+6.4, above the timber grille); at the GF high grilles into the *riwaq* (the core's west face, +2.7) and the *women's majlis* (its north wall, +2.7). D10 kept: no bedroom touches the core.
    #H[3.4 · What else changes]
    - #WARN[the women's majlis loses its small courtyard glass panel at x 5.1–5.6 (0.5 m, inside the core's north wall); its main courtyard glass x 6.0–8.1 stays.]
    - The riwaq's first panel (y 6.8–8.9) becomes the core's rendered west face: a built-in timber *bench* along it (the riwaq's resting place) and the high filtered-air grille.
    - The carved door (1.0 × 2.4, a semicircular head) faces the covered strip, seen from the seating beside the first arch.
    #H[3.5 · D11 compatibility (not designed here)]
    - *On the module:* every new size above (checks below); W1's sill at +3.80 (not +3.82) makes it 2.80 m high.
    - #WARN[*D11 bands around each W1* (1.6 + 2 × 0.30 = 2.20 m) are wider than the arcade's bay (2.1667 m): the bands of neighbouring windows would overlap. The facade study should read D11 on this face as *shared pilaster bands on the column axes* (0.30, 1.87 m clear between them, W1 1.6 inside): the GF columns and the FF pilasters on the same axes.]
    - #WARN[the arcade's bays (6.50 / 3 = 2.1667 m) are *not* on the 20 cm module (the structure's grid): keep them, or adjust at the facade study.]
  ],
)
#v(2pt)
#text(6.4pt)[*Open questions for the owner (Phase 3):* (1) *F3* (the head 1.6 × 2.4 over the first bay, its overhang south over the gallery roof, on the colonnade's axis) or *F2* (keep the decided 1.6 × 1.6 with the north overhang)? (2) The gallery's "window" into the shaft as a carved arched grille with an insulated damper behind it (not an opening casement): OK? (3) W1's sill at +3.80 (on the module): OK? (4) The bench along the riwaq's new solid wall: OK? (5) The farm's location and what lies to the west are still blank.]
#v(2pt)
#block(width: 100%, inset: 4pt, fill: rgb("#eef4ec"), radius: 2pt)[#set text(lang: "ar", dir: rtl, font: ("Segoe UI", "Arial"), size: 8.4pt)
  #set par(leading: 0.6em)
  *ملخص المرحلة 3:* يصبح الباكية الأولى من الرواق المقوّس باكية الملقف: في الأرضي فتحة الهواء بشيش خشبي داخل القوس الأول، وفي العلوي قوس أعمى غائر بنفس محور القوس (بدل النافذة الأولى التي تغطيها النواة)، وتبقى النوافذ الأخرى على محاورها فوق أقواس الأرضي. *التوصية F3:* يمتد رأس البرج جنوبا فوق سقف الممر (1.6 × 2.4 م) ليقوم تماما على محور الباكية الأولى، فيبدأ البرج صف الأعمدة بخط رأسي واحد من القوس إلى التاج؛ وإن بقي البروز شمالا كما تقرر فالخيار F2. نافذة الممر إلى المجرى شبكة خشبية منحوتة مقوّسة خلفها خانق معزول، ومخارج الهواء المرشح عالية إلى الممر وجلسة العائلة والرواق والمجلس. يفقد المجلس لوح زجاج صغيرا (0.5 م)، وفي الرواق كنبة خشبية على الجدار الجديد. ملاحظة لدراسة الواجهات: أشرطة D11 حول كل نافذة أعرض من الباكية، فالأفضل أن تكون أكتافا مشتركة على محاور الأعمدة.
]
#v(2pt)
#text(6.2pt, fill: gray)[Phase 3 checks #if ok3 [*passed* (#checks3.len())] else [*FAILED*: #checks3.filter(c => not c.at(1)).map(c => c.at(0)).join([; ])] · sources: 3d/params.yaml (W1, W2), 3d/character.yaml (the arcade), presentation.typ (the courtyard glass), studies/roof.typ (the cornice, the band). Render and paint only (owner, 9 Nov 2026).]



// ======================================================================= PHASE 3 · ADDENDUM (the owner, 9 Nov 2026): the riwaq and the covered strip at eye level, the chamber door open
// A one-point perspective: the eye 1.6 m above the floor, looking NORTH (y decreasing); east to the right. f = the focal scale (cm per unit of x/d).
#let persp(eye, f) = p => { let d = eye.at(1) - p.at(1); (f * (p.at(0) - eye.at(0)) / d, f * (p.at(2) - eye.at(2)) / d) }
#let quad(P, pts, f, s) = { import cetz.draw: *; line(..pts.map(P), close: true, fill: f, stroke: s) }
#let eye-view(eye, f, body, title) = cetz.canvas(length: 1.75cm, {
  import cetz.draw: *
  let P = persp(eye, f)
  rect((-3.0, -1.6), (3.0, 2.2), fill: rgb("#fbfaf6"), stroke: 0.4pt + luma(170))
  body(P)
  content((0, -1.9), text(5pt, weight: "bold", fill: green, title))
})
#let wallc = rgb("#efe3c8"); #let wall-d = rgb("#e1d3b4"); #let floor-c = rgb("#d9cdb4"); #let glass-c = rgb("#9fc6dc").transparentize(45%); #let dark-c = rgb("#4a463f"); #let timber-c = rgb("#9c6b3c"); #let ceil-c = rgb("#f4f1ea")
// VIEW A · from the covered strip (x 5.0, y 11.6) looking north at the chamber's south face, the door open
#let view-a = eye-view((5.0, 11.6, 1.6), 1.6, P => {
  quad(P, ((4.25, 10.1, 0), (5.8, 10.1, 0), (5.8, 8.767, 0), (4.25, 8.767, 0)), floor-c, none)                       // the strip's floor (porcelain)
  quad(P, ((4.25, 10.1, 3.52), (5.8, 10.1, 3.52), (5.8, 8.767, 3.52), (4.25, 8.767, 3.52)), ceil-c, none)           // the projection's soffit
  quad(P, ((4.3, 8.767, 0), (5.9, 8.767, 0), (5.9, 8.767, 3.52), (4.3, 8.767, 3.52)), wallc, 0.4pt + ink)           // the chamber's south face (render)
  quad(P, ((4.6, 8.767, 0), (5.6, 8.767, 0), (5.6, 8.767, 2.4), (4.6, 8.767, 2.4)), dark-c, none)                   // the door opening (into the chamber)
  quad(P, ((4.65, 8.567, 0.0), (5.45, 8.567, 0.0), (5.45, 8.567, 0.9), (4.65, 8.567, 0.9)), rgb("#dfe8d0"), 0.3pt + green)   // inside: the filter cabinet
  quad(P, ((4.6, 8.767, 0), (4.6, 9.767, 0), (4.6, 9.767, 2.4), (4.6, 8.767, 2.4)), timber-c, 0.4pt + ink)          // the carved door, open 90°
  quad(P, ((4.25, 10.1, 0), (4.25, 9.1, 0), (4.25, 9.1, 2.6), (4.25, 10.1, 2.6)), glass-c, 0.4pt + ink)             // the courtyard glass door (riwaq side)
  quad(P, ((4.25, 10.1, 2.6), (4.25, 8.767, 2.6), (4.25, 8.767, 3.52), (4.25, 10.1, 3.52)), wall-d, none)           // over the glass: B4's soffit band
  quad(P, ((5.675, 8.667, 0), (5.925, 8.667, 0), (5.925, 8.667, 3.3), (5.675, 8.667, 3.3)), wall-d, 0.4pt + ink)    // the first arcade column (rendered)
  import cetz.draw: *
  content(P((5.1, 8.767, 2.75)), text(3.6pt)[the chamber's south face · render])
  content(P((5.1, 8.767, 1.3)), text(3.4pt, fill: white)[dust trap · filters\ + fan · cooler space])
  content(P((4.25, 9.8, 1.3)), text(3.2pt)[glass door\ to the riwaq])
  content(P((5.8, 8.667, 3.45)), text(3pt)[arcade column])
}, [A · in the covered strip, 2.8 m from the chamber, looking north (the door open)])
// VIEW B · from the riwaq (x 3.5, y 12.3) looking north: the glass, the glass door, the core's new solid face with the bench, the majlis wall
#let view-b = eye-view((3.5, 12.3, 1.6), 1.6, P => {
  quad(P, ((2.75, 10.8, 0), (4.25, 10.8, 0), (4.25, 0, 0), (2.75, 0, 0)), floor-c, none)
  quad(P, ((2.75, 10.8, 3.52), (4.25, 10.8, 3.52), (4.25, 0, 3.52), (2.75, 0, 3.52)), ceil-c, none)
  quad(P, ((2.75, 0, 0), (4.25, 0, 0), (4.25, 0, 3.52), (2.75, 0, 3.52)), wall-d, 0.3pt + ink)                      // the north wall
  quad(P, ((3.0, 0, 0), (4.0, 0, 0), (4.0, 0, 2.2), (3.0, 0, 2.2)), timber-c, none)                                 // the family entrance door
  quad(P, ((2.75, 10.8, 0), (2.75, 0, 0), (2.75, 0, 3.52), (2.75, 10.8, 3.52)), wallc, 0.3pt + ink)                 // the west side (the stair, the store, the utility)
  quad(P, ((2.75, 7.6, 0), (2.75, 6.7, 0), (2.75, 6.7, 1.55), (2.75, 7.6, 1.55)), timber-c, none)                   // the store's low door
  quad(P, ((4.25, 6.4, 0), (4.25, 0, 0), (4.25, 0, 3.52), (4.25, 6.4, 3.52)), wallc, 0.3pt + ink)                   // the women's majlis wall
  quad(P, ((4.3, 8.767, 0), (5.9, 8.767, 0), (5.9, 8.767, 3.52), (4.3, 8.767, 3.52)), wall-d, none)                 // the chamber's south face, seen through the glass
  quad(P, ((4.6, 8.767, 0), (5.6, 8.767, 0), (5.6, 8.767, 2.4), (4.6, 8.767, 2.4)), dark-c, none)
  quad(P, ((4.25, 8.767, 0), (4.25, 6.4, 0), (4.25, 6.4, 3.1), (4.25, 8.767, 3.1)), wallc, 0.4pt + ink)             // the core's new solid west face (render)
  quad(P, ((4.25, 8.6, 0), (4.25, 6.6, 0), (4.25, 6.6, 0.45), (4.25, 8.6, 0.45)), timber-c, 0.3pt + ink)            // the bench
  quad(P, ((4.25, 8.0, 2.6), (4.25, 7.2, 2.6), (4.25, 7.2, 2.8), (4.25, 8.0, 2.8)), white, 0.3pt + green)           // the filtered-air grille
  quad(P, ((4.25, 10.5, 0), (4.25, 9.1, 0), (4.25, 9.1, 2.6), (4.25, 10.5, 2.6)), glass-c, 0.4pt + ink)             // the glass door
  quad(P, ((4.25, 10.8, 2.6), (4.25, 6.4, 2.6), (4.25, 6.4, 3.52), (4.25, 10.8, 3.52)), wall-d, none)               // B4's soffit band over the glass and the core
  quad(P, ((4.25, 10.8, 0.1), (4.25, 10.7, 0.1), (4.25, 10.7, 2.6), (4.25, 10.8, 2.6)), glass-c, 0.4pt + ink)       // the edge of the south glass panel beside the viewer
  import cetz.draw: *
  content(P((4.25, 7.5, 1.6)), anchor: "west", text(3.4pt)[ the core's solid face\ (was glass)\ + the bench])
  content(P((4.25, 9.8, 1.9)), anchor: "west", text(3.2pt)[ glass door])
  content(P((4.25, 3.2, 1.8)), anchor: "west", text(3.2pt)[ women's majlis wall])
  content(P((3.5, 0, 3.0)), text(3pt)[family entrance])
}, [B · in the riwaq, 3.5 m before the glass door, looking north])

#pagebreak()
#text(12pt, weight: "bold", fill: green)[Phase 3 · addendum (owner, 9 Nov 2026) · the riwaq and the strip at eye level, the chamber door open]
#v(3pt)
#grid(columns: (auto, auto, 1fr), gutter: 10pt,
  view-a, view-b,
  [
    #H[What the eye sees]
    - *A · from the covered strip:* the strip's north end is now *the chamber's rendered south face* with the carved door (1.0 × 2.4, a semicircular head) opening onto the strip; the glass door to the riwaq on the left, the first arcade column on the right and, beyond it, the courtyard. The door open shows the dust trap's grating, the filter cabinet and the free space for a cooler. Nothing is seen of the outlet from here (it faces the courtyard, on the chamber's east face).
    - *B · from the riwaq:* the riwaq's courtyard side reads, from near to far, the glass panel, the glass door, then *2.4 m of solid rendered wall* (the core's west face, the bench along it at +0.45, the small high grille of filtered air), then the women's majlis wall. The riwaq keeps its light from the glass door and the south panel; the solid piece ends the glass where the majlis wall begins, so it reads as *one wall from the majlis to the glass door*, not as a lost window.
    #H[Before fixing the riwaq's solid wall]
    - The strip's first panel (y 6.8–8.9) was glass only because the enclosure study glazed the whole riwaq edge; with the chamber behind it, glass would show a plant room. *Recommendation: the solid face with the bench*, as drawn; the alternative, a high clerestory strip of obscured glass (+2.2 … +2.6) above the bench, would light the chamber a little and keep a line of glass: the owner's call, both work.
    #text(6.4pt, fill: gray)[Both views: one-point perspectives, the eye 1.6 m above the floor; the finishes render and paint (the walls light sand), porcelain floors (owner, 9 Nov 2026); the furniture omitted. The 3D renders of Phase 5 show the same corner from the courtyard.]
  ],
)
#v(2pt)
#block(width: 100%, inset: 4pt, fill: rgb("#eef4ec"), radius: 2pt)[#set text(lang: "ar", dir: rtl, font: ("Segoe UI", "Arial"), size: 8.4pt)
  #set par(leading: 0.6em)
  *ملحق المرحلة 3:* منظوران بمستوى العين: (أ) من الممر المسقوف نحو الشمال: نهاية الممر صارت واجهة غرفة القاعدة المليّسة وفيها الباب الخشبي المنحوت مفتوحا يكشف مصيدة الغبار وخزانة المرشحات ومكان المبرد؛ باب الفناء الزجاجي يسارا وعمود الرواق يمينا. (ب) من الرواق نحو الشمال: لوح الزجاج ثم الباب الزجاجي ثم 2.4 م من جدار مصمت مليّس (وجه النواة الغربي) عليه الكنبة الخشبية ومخرج الهواء المرشح عاليا، ثم جدار مجلس النساء؛ فيُقرأ جدارا واحدا من المجلس إلى الباب الزجاجي لا نافذة ضائعة. التوصية: الجدار المصمت مع الكنبة، والبديل شريط زجاج معتم عالٍ فوقها.
]

// ======================================================================= PHASE 4 · AIR SYSTEM AND CONTROLS (9 Nov 2026, after the Phase 3 answers)
// The owner's answers: F3 (the head 1.6 × 2.4 over the first bay, the overhang SOUTH over the gallery roof; this replaces the Phase 2 north overhang);
// the carved arched grille with its insulated damper; W1's sill +3.80; the bench; the women's majlis's 0.5 m panel lost, accepted; D11 as shared pilasters
// (for the facade study); the farm's location: the on-site weather station answers it (no more questions). Every figure ASSUMED: the MEP engineer designs it.
#let q-normal4 = 325.0; #let q-boost4 = 704.0; #let q-hood = 300.0     // m³/h: the house's normal / boost ventilation (studies/air_system.typ, ASHRAE 62.2 / 62.1), the hood's make-up (its own interlocked inlet)
#let fan4 = (q: 750, dp: 250, w: 160, dba: 38, size: (0.6, 0.6, 0.45))   // an EC plug / centrifugal fan in its cabinet (ASSUMED): 750 m³/h at 250 Pa external, ≈ 160 W, ≈ 38 dB(A) at 1 m in the chamber
#let filt4 = (pre: "ISO Coarse 60 % (G4), washable synthetic, 500 × 500 × 48", fine: "ISO ePM1 ≥ 50 % (F7 class), 500 × 500 × 292 bag or compact; ePM2.5 ≥ 65 % if the PM2.5 log asks for more", dp0: 60, dp1: 200)
#let head4 = (x: 4.30, y0: 6.4, y1: 8.8, z0: 11.0, z1: 12.6, free: 1.8)   // the F3 head: openings +11.0 … +12.6 on the four faces; ≈ 1.8 m² free on the long (W / E) faces, ≈ 1.1 on the short (N / S), ASSUMED (Phase 5 details)
#let inlet-b = (x: 4.6, y: 8.5, z: 7.6)                  // the filtered path's inlet: a downward-facing hood UNDER the head's south overhang (F3), +7.6, a bird mesh, never closes
#let out4 = (w: 1.4, h: 1.0, free: 0.6)
#let exh = (("bathrooms' extract (the west stack's vent)", (0.75, 9.8, 8.0), [⚠ UPWIND in a W wind: *re-routed in the attic to the south-east strip (owner, 9 Nov 2026)*]),
            ("kitchen hood outlet (east wall)", (13.311, 10.7, 2.2), [downwind, 7.5 m, 8.8 m below the openings]),
            ("east stack's vent", (13.2, 8.4, 8.0), [downwind, 7.3 m]),
            ("AC condensers Z2b (hot air)", (9.6, 5.6, 7.9), [east, 3.7 m in plan from the head's east face, 3.1 m below the openings; their hot plume rises leeward in a W wind]),
            ("the plumbing's drain vents (the east stack, the family WC's stack)", (1.5, 14.9, 8.0), [south-west, 6.4 m; terminals ≥ 1.5 m above the roof]),
            ("the LPG cabinet, the generator point (the yard)", (13.7, 8.6, 0.0), [downwind, ≥ 8 m, 11 m below]))
#let d3-4(a, b) = calc.sqrt(calc.pow(a.at(0) - b.at(0), 2) + calc.pow(a.at(1) - b.at(1), 2) + calc.pow(a.at(2) - b.at(2), 2))
#let head-pt = (head4.x + 0.8, head4.y0 + 1.2, head4.z0)
#let modes = (
  ([*Normal*], [20 ≤ T ≤ 32 °C · PM2.5 ≤ 35 µg/m³ · wind ≤ 45 km/h], [open], [open], [closed], [off], [normal #str(calc.round(q-normal4)) m³/h], [the courtyard breeze; the house ventilated by the fan at a slight positive pressure]),
  ([*Clear day*], [18 ≤ T ≤ 30 · PM2.5 ≤ 15 · wind ≤ 30], [open], [open], [*open*], [off], [minimum], [the gallery and the family living get the natural breeze through the grille (path a into the house; the fan idles)]),
  ([*Dust*], [PM2.5 > 50 for 10 min (back to Normal below 25 for 30 min)], [*closed*], [*closed*], [closed], [off], [*boost* #str(calc.round(q-boost4)) m³/h], [every breeze opening shut; the filtered fan at boost keeps the house at +10 Pa: dust stays out]),
  ([*Cold*], [T < 18 °C (Nov–Mar: < 20 after sunset); frost: < 5 °C], [closed], [closed], [closed], [off], [minimum (≈ 150)], [the shaft and the chamber closed and insulated; the cooler drained in winter]),
  ([*Summer*], [T > 32 °C (Jun–Sep afternoons)], [open], [open], [closed], [*on*], [normal], [the cooler draws the malqaf air, blows ≈ 20–22 °C air through the outlet onto the seating; the gallery grille shut (humid air out of the house)]),
  ([*High wind*], [gusts > 45 km/h], [*half*], [open], [closed], [–], [normal], [less dust and noise; the flaps and the damper modulate]),
  ([*Hood*], [the kitchen hood on (any mode)], [–], [–], [–], [–], [also the make-up], [the hood's own interlocked make-up inlet opens (≈ #str(calc.round(q-hood)) m³/h); the fan does not try to feed the hood]),
)
#let breeze-q(v10) = { let v = v10 / 3.6 * 1.04; let dp = 0.5 * 1.15 * v * v * 0.8; let z = 3.0 * calc.pow(0.10 / (head4.free * 0.9), 2) + 1.5 * calc.pow(0.10 / 0.84, 2) + 1.5 * calc.pow(0.10 / 0.84, 2) + 2.5 * calc.pow(0.10 / (out4.w * out4.h * out4.free), 2); 0.10 * calc.sqrt(2 * dp / (1.15 * z)) }
#let v-out(q) = q / (out4.w * out4.h * out4.free)
#let heat-loss(q, dT) = 0.34 * q * dT / 1000   // kW for q m³/h
#let checks4 = (
  ([every exhaust and plume source ≥ 3 m from the head's openings (the nearest #str(calc.round(calc.min(..exh.map(e => d3-4(e.at(1), head-pt))), digits: 1)) m)], exh.all(e => d3-4(e.at(1), head-pt) >= 3.0)),
  ([the fan covers the boost (#str(calc.round(q-boost4)) m³/h) with the filters loaded (≤ #fan4.q)], fan4.q >= q-boost4),
  ([the outlet's air speed at the summer-evening mean wind stays ≤ 2.5 m/s (#str(calc.round(v-out(breeze-q(21.0)), digits: 1)) m/s)], v-out(breeze-q(21.0)) <= 2.5),
  ([the winter minimum ventilation's heat loss ≤ 1.5 kW at 10 K (#str(calc.round(heat-loss(150, 10), digits: 2)) kW)], heat-loss(150, 10) <= 1.5),
)
#let ok4 = checks4.all(c => c.at(1))

#pagebreak()
#text(12pt, weight: "bold", fill: green)[Phase 4 · the air system · two paths after the head · dampers · positive pressure · exhausts]
#v(1pt)
#text(7pt, fill: gray)[The owner's Phase 3 answers applied: *F3* (the head 1.6 × 2.4 over the first bay, the overhang south over the gallery roof), the carved grille (a sealed provision), W1's sill +3.80, the bench, the majlis's 0.5 m panel lost, D11 as shared pilasters later. *Owner, 9 Nov 2026: keep it simple: a family home, not a smart building* (§ 4.6). Every figure #ASSUMED: the MEP engineer designs and sizes it.]
#v(3pt)
#grid(columns: (auto, 1fr), gutter: 12pt,
  cetz.canvas(length: 0.56cm, {
    import cetz.draw: *
    let Y(y) = (y - 5.8) * 2.2; let Z(z) = z
    let box4(y0, z0, y1, z1, f, s) = rect((Y(y0), Z(z0)), (Y(y1), Z(z1)), fill: f, stroke: s)
    box4(5.8, -1.2, 9.6, -0.6, luma(150), none)
    box4(6.4, -0.6, 6.6, 7.3, rgb("#3a3f3b"), none); box4(7.4, 3.52, 7.6, 7.3, rgb("#3a3f3b"), none); box4(8.567, -0.6, 8.767, 3.52, rgb("#3a3f3b"), none)
    box4(5.8, 3.44, 9.6, 3.72, luma(175), none); box4(5.8, 7.2, 9.6, 7.4, luma(175), none)
    box4(6.4, 7.3, 8.8, 13.2, sand, 0.5pt + ink); box4(6.2, 10.6, 9.0, 10.75, honey, none); box4(6.1, 12.9, 9.1, 13.2, honey, none)
    box4(6.6, 11.0, 8.6, 12.6, rgb("#2b2b2d"), none); content((Y(7.6), 11.8), text(3.6pt, fill: white)[head: 4 faces\ bird mesh\ + divider + flaps])
    box4(7.6, 7.3, 8.8, 7.6, luma(175), none); content((Y(8.2), 7.0), text(3.2pt)[the south overhang (F3)])
    box4(6.6, 3.72, 7.4, 7.2, sky-l5, none); content((Y(7.0), 5.5), text(3.6pt)[(a) breeze\ shaft\ 0.84 m²])
    box4(6.6, 3.9, 6.95, 7.2, rgb("#dfe8d0"), 0.3pt + green); content((Y(6.78), 5.5), angle: 90deg, text(3.2pt)[(b) riser Ø315])
    box4(6.6, -0.6, 8.567, 3.44, rgb("#f4f1ea"), none)
    box4(6.6, -0.6, 7.4, -0.3, sky-l5, 0.3pt + blue); content((Y(7.0), -0.45), text(3pt)[dust trap])
    box4(7.6, 0.1, 8.5, 1.7, rgb("#e8f1f6"), 0.4pt + blue); content((Y(8.05), 0.9), text(3.2pt)[cooler\ (option)])
    box4(6.6, 0.0, 7.1, 1.6, rgb("#dfe8d0"), 0.4pt + green); content((Y(6.85), 0.8), text(3pt)[filters\ + fan])
    line((Y(6.6), 7.75), (Y(7.4), 7.75), stroke: 2.4pt + red); content((Y(7.0), 8.1), text(3.2pt, fill: red)[D1 top damper (+7.75)])
    line((Y(8.567), 0.1), (Y(8.567), 1.1), stroke: 2.4pt + green); content((Y(9.1), 0.6), text(3.2pt, fill: green)[outlet 1.4 × 1.0\ + D2 damper])
    line((Y(7.5), 4.2), (Y(7.5), 5.8), stroke: 2.4pt + timber); content((Y(8.1), 5.0), text(3.2pt, fill: timber)[gallery grille\ + D3 damper])
    circle((Y(8.4), 7.55), radius: 0.12, fill: green, stroke: none); content((Y(9.0), 7.75), text(3.2pt, fill: green)[(b) inlet: a hood under the\ overhang, +7.6, never closes])
    line((Y(8.4), 7.45), (Y(8.4), 3.9), stroke: (paint: green, thickness: 0.8pt, dash: "dashed")); content((Y(8.75), 5.0), angle: 90deg, text(3pt, fill: green)[intake duct in the chamber's SE corner])
    for (z, l) in ((6.4, [→ family living (N), gallery (S)]), (2.7, [→ riwaq (W), women's majlis (N)])) { line((Y(6.4), z), (Y(6.1), z), stroke: 1.2pt + green); content((Y(6.05), z), anchor: "east", text(3pt, fill: green, l)) }
    content((Y(5.9), 13.8), anchor: "west", text(4.4pt, weight: "bold", fill: green)[SECTION N–S through the core (y 5.8–9.6, stretched ×2.2)])
  }),
  [
    #H[4.1 · The two paths after the head]
    - *The head* (Phase 5): four faces of slender openings +#str(head4.z0) … +#str(head4.z1) behind a 20 mm *bird / leaf mesh*; inside, the + divider and the four *back-draught flaps* (the windward quarter feeds, the leeward quarters shut).
    - *(a) The breeze path:* the head → *D1*, the top damper at the shaft's head (+7.75, 1.2 × 0.8) → the shaft (0.84 m²) → the *dust trap* (a 0.8 × 0.7 × 0.3 basin under the shaft, a lift-out grating, a drain) → the foot chamber → the *courtyard outlet* 1.4 × 1.0 with its louvres and *D2* behind them → the seating. *Provision only (owner):* the gallery's carved grille, closed and sealed behind a removable panel, no damper now. *No filter:* mesh only, by design (D3 of the owner).
    - *(b) The filtered path:* its *inlet never closes:* a downward-facing hood (0.6 × 0.6, a bird mesh) *under the head's south overhang* (+7.6; rain- and dust-shadowed, 3.4 m below the breeze openings), a Ø315 duct down the chamber's south-east corner → the *filter cabinet* (#filt4.pre → #filt4.fine) → the *EC fan* (#fan4.q m³/h at #fan4.dp Pa, ≈ #fan4.w W) → a *silencer* (a 0.9 m lined attenuator, ≈ −15 dB) → a sealed Ø250 riser in the shaft's west side → high grilles into the *family living* and the *gallery* (+6.4), and at the GF the *riwaq* and the *women's majlis* (+2.7); the other GF rooms through the riwaq (door undercuts / transfer grilles, as the house's air moves anyway). *The kitchen hood's interlocked make-up inlet is mandatory* (owner; ≈ #str(calc.round(q-hood)) m³/h, `studies/air_system.typ`).
    #H[4.2 · The dampers (two, insulated, low-leakage, spring-return)]
    - *D1* at the shaft's head and *D2* behind the outlet's louvres: both insulated, low-leakage, *spring-return (they close on power loss)*, driven together by the one wall switch *MALQAF open / closed* and closed by the dust relay. *No D3* (the gallery grille is a sealed provision). *D4:* a passive gravity louvre Ø160 from the chamber to the outlet (no motor). The hood's make-up damper: its own, interlocked with the hood (*mandatory*).
    #H[4.3 · Positive pressure and the hood]
    - The fan supplies #str(calc.round(q-normal4)) m³/h (normal) / #str(calc.round(q-boost4)) (boost) into a *tight envelope (D5)*; the extracts (the bathrooms, ≈ 150–250 m³/h continuous, the dryer) are smaller: the house runs at ≈ *+5–10 Pa* (the fan's speeds set once at commissioning; no sensor). Every door is undercut 15 mm or has a transfer grille so the pressure is one.
    - #WARN[the kitchen hood (600–1 000 m³/h) exceeds the supply fan: without its make-up inlet the house would go *negative* and pull dust through every crack and the malqaf's grille. The *interlocked make-up inlet* (filtered, motorised, opens with the hood) is *mandatory* (owner, 9 Nov 2026); the fan does not replace it.]
  ],
)
#v(3pt)
#H[4.4 · Exhausts and plumes relative to the head (openings +#str(head4.z0) … +#str(head4.z1))]
#table(columns: (1.3fr, auto, 1.6fr), inset: 2pt, stroke: 0.4pt + luma(180), fill: (_, y) => if y == 0 { rgb("#e4eedf") },
  [*Source*], [*Distance*], [*Position*],
  ..exh.map(e => ([#e.at(0)], [#str(calc.round(d3-4(e.at(1), head-pt), digits: 1)) m], [#e.at(2)])).flatten())
#WARN[the bathrooms' vent in the west shaft is the one source *upwind* in the summer-evening west wind: its terminal must end ≥ 1.5 m above the roof (+8.8), 2.2 m below the head's openings and 3.6 m away, or, *decided by the owner (9 Nov 2026): re-routed in the attic to the south-east strip* (Phase 6 checklist).]

#pagebreak()
#text(12pt, weight: "bold", fill: green)[Phase 4 · insulation and moisture · sensors · the control modes · maintenance · performance]
#v(3pt)
#grid(columns: (1fr, 1fr), gutter: 10pt,
  [
    #H[4.5 · Insulation, acoustics, moisture]
    - *The core's walls facing the gallery and the family living:* 200 RC (Rw ≈ 55 dB) + 50 mm mineral wool and a 2 × 12.5 board lining *on the room side* (the breeze shaft stays smooth render inside); the fan's cabinet acoustically lined, on anti-vibration mounts; the filtered-air grilles with 0.6 m lined duct before them.
    - *Thermal:* D1 and D3 insulated blades; the shaft's walls facing rooms with 50 mm insulation inside the lining (the shaft is outdoor air in winter).
    - *The foot chamber (wet):* tanked to +0.30 and a fall to a *trapped gully* (a trap primer), the dust trap in GRP, the cooler's space with a drip tray (*an option only*, D9: the malqaf is a *dry system*), the water point *capped*, IP44 sockets at +1.2 on their own RCD circuit, a lockable isolator; the passive *D4 louvre* so the chamber never stays damp.
  ],
  [
    #H[4.6 · Controls (owner, 9 Nov 2026: a family home, not a smart building)]
    - *Two wall switches* by the courtyard door: (1) *MALQAF open / closed* (D1 + D2 together, a lamp); (2) *HOUSE FAN normal / boost*. *One automatic safety:* an outdoor *dust sensor relay* (PM2.5 > 50 µg/m³ for 10 min → D1 and D2 close by themselves, the lamp shows "dust"; they reopen when the air is clean for 30 min if the switch is on). *Every damper spring-return:* closed on power loss. *No controller, no modes.* A mechanical *filter gauge* on the cabinet (change the fine filter at #filt4.dp1 Pa). Winter nights, dust seasons, holidays: the family turns switch 1 off.
    #H[4.8 · Maintenance (all from the carved door at ground level)]
    #table(columns: (1.2fr, 1fr, auto), inset: 2pt, stroke: 0.4pt + luma(180), fill: (_, y) => if y == 0 { rgb("#e4eedf") },
      [*What*], [*How*], [*When*],
      [the dust trap], [lift the grating, sweep / vacuum the basin, hose to the drain], [monthly; weekly in Mar–Apr],
      [the pre-filter], [slide out, wash, dry, back], [monthly (the dP light)],
      [the fine filter], [replace], [≈ 6 months (dP #filt4.dp1 Pa)],
      [the cooler], [tank and pads cleaned; drained and parked for winter], [weekly in summer; Oct],
      [the dampers D1–D4], [stroke test, seals], [yearly (before spring)],
      [the gully trap, the drain], [fill / flush], [monthly],
      [the outlet louvres, the grilles], [brush], [3 months],
      [the head's mesh and flaps], [*the roof hatch only*: brush the mesh, free the flaps], [yearly; after a dust storm],
    )
  ],
)
#v(3pt)
#H[4.7 · What the two switches do]
#table(columns: (auto, 1fr, 1fr), inset: 2.4pt, stroke: 0.4pt + luma(175), fill: (_, y) => if y == 0 { rgb("#e4eedf") },
  [*Switch*], [*ON*], [*OFF*],
  [*1 · MALQAF*], [D1 + D2 open: the courtyard breeze, whenever the family finds the evening pleasant (Phase 0: ≈ 1 800 such hours a year)], [D1 + D2 shut: winter, dust, away. *The dust relay forces OFF* while the air is dirty],
  [*2 · HOUSE FAN*], [boost (#str(calc.round(q-boost4)) m³/h): guests, after a dust day, a full house], [normal (#str(calc.round(q-normal4)) m³/h): always on; the filtered path never stops; the hood's own make-up inlet opens with the hood],
)
#v(3pt)
#H[4.9 · Rough performance (ASSUMED, for the MEP engineer)]
- *The breeze (Normal):* at the summer-evening mean wind (21 km/h at 10 m) ≈ *#str(calc.round(breeze-q(21.0), digits: 2)) m³/s* through the outlet (≈ #str(calc.round(v-out(breeze-q(21.0)), digits: 1)) m/s at the louvres, ≈ 0.5–0.8 m/s at the seating 2 m away: a clearly felt breeze); at 10 km/h ≈ #str(calc.round(breeze-q(10.0), digits: 2)) m³/s (gentle); in a calm the stack alone ≈ 0.15 m³/s. L1 (V9.3) at 21 km/h ≈ 0.42 m³/s: *≈ #str(calc.round(breeze-q(21.0) / 0.42, digits: 1)) ×* (Phase 1 said 3.5 with the smaller head; F3's head is larger).
- *If a cooler is added later (an option, D9):* a 90–150 L portable cooler moves ≈ 0.8–1.4 m³/s and cools the dry afternoon air from ≈ 35 to ≈ *20–22 °C* (Phase 0: RH 12–20 %); its water ≈ 15–25 L/h; the jet along the seating ≈ 1 m/s. The courtyard is open to the sky: it cools *the people in the jet*, not the courtyard.
- *Winter:* the breeze closed; the fan at its minimum ≈ 150 m³/h costs ≈ *#str(calc.round(heat-loss(150, 10), digits: 2)) kW* at 10 K (≈ #str(calc.round(heat-loss(325, 10), digits: 2)) kW at the normal rate): small; no heat recovery (D2 of the owner), so the family leaves the fan at normal and sets boost when the house is full.
- *Dust:* the relay has shut the breeze; the fan (boost if the family sets it) with the fine filter (≥ 50 % of PM1, ≈ 80 % of PM2.5) holds the indoor PM2.5 at roughly a quarter of the outdoor level during a 150 µg/m³ event (the house tight, D5).
#v(2pt)
#text(6.4pt)[*Answered by the owner (9 Nov 2026):* the filters and the fan in the foot chamber with a silencer; the gallery grille a sealed provision; the cooler an option (the malqaf a dry system); the bathrooms' vent re-routed to the south-east; the hood's make-up inlet mandatory; wall switches only, one dust relay, spring-return dampers; F3 provisional on one section (Phase 5); the riwaq at eye level (Phase 3 addendum).]
#v(2pt)
#block(width: 100%, inset: 4pt, fill: rgb("#eef4ec"), radius: 2pt)[#set text(lang: "ar", dir: rtl, font: ("Segoe UI", "Arial"), size: 8.4pt)
  #set par(leading: 0.6em)
  *ملخص المرحلة 4:* بعد رأس البرج مساران: (أ) مسار النسيم الكبير بلا مرشح (شبك طيور فقط): خانق علوي D1، ثم المجرى، ثم مصيدة الغبار في القاعدة، ثم فتحة الفناء 1.4 × 1.0 م بخانق D2 خلف الشيش؛ وشبكة الممر العلوي تجهيز فقط مغلق ومحكم. (ب) المسار المرشح الصغير: مدخل لا يُغلق أبدا تحت بروز الرأس الجنوبي، ثم مرشح خشن قابل للغسل ومرشح ناعم ومروحة هادئة 750 م³/س مع كاتم صوت في غرفة القاعدة، تدفع هواءً مرشحا إلى الممر وجلسة العائلة والرواق والمجلس فيبقى البيت تحت ضغط موجب. *التحكم بسيط كما قرر المالك:* مفتاحان على الجدار (الملقف مفتوح/مغلق، والمروحة عادي/قوي) وأمان آلي واحد: حساس غبار يغلق الخانقين بنفسه في الغبار، وكل الخوانق تُغلق عند انقطاع الكهرباء. لا وحدة تحكم ولا أنماط. المبرد الصحراوي خيار فقط (مكان ومقبس وتصريف، والماء مسدود)؛ تهوية الصرف الغربية تُحوَّل إلى الجنوب الشرقي؛ مدخل الهواء التعويضي لشفاط المطبخ إلزامي. الصيانة كلها من الباب المنحوت في الدور الأرضي. النسيم المقدّر نحو 1.8 م³/ث في مساء صيفي عادي.
]
#v(2pt)
#text(6.2pt, fill: gray)[Phase 4 checks #if ok4 [*passed* (#checks4.len())] else [*FAILED*: #checks4.filter(c => not c.at(1)).map(c => c.at(0)).join([; ])] · sources: studies/air_system.typ (the ventilation rates 325 / 704 m³/h, the hood's make-up, the loss chain), studies/plumbing.typ (the vents), studies/roof.typ (Z2b), ASHRAE 62.1 / 62.2-2022, ASHRAE 62.1 Table 5-1 (separations), ISO 16890 (the filter classes), EN 1751 (damper leakage classes). Concept only.]


// ======================================================================= PHASE 5 · THE TOWER HEAD (9 Nov 2026; short, as the owner asked)
// The head (F3): 1.6 x 2.4 outside on the shaft + the gallery roof, an RC frame (0.30 corner piers, ring beams at the band and the crown), rendered block ribs;
// render and paint (light sand; the band, the crown and the arch surrounds in the calm honey tone); its openings above the roof's recirculation bubble (Phase 1 § 1.3).
#let h5 = (x0: 4.30, y0: 6.4, x1: 5.90, y1: 8.8, z-roof: 7.3, z-band: 10.6, z-open0: 11.2, z-open1: 12.6, z-crown: 12.9, z-top: 13.2, pier: 0.30, slot: 0.20, rib: 0.20)
#let n-short = 3; #let n-long = 5                                 // slots per face: the N / S faces (1.6: 0.30 pier + 3 × 0.20 slots + 2 × 0.20 ribs + 0.30), the W / E faces (2.4: 5 slots, 4 ribs)
#let slot-free = h5.slot * (h5.z-open1 - h5.z-open0 - h5.slot / 2) + calc.pi * calc.pow(h5.slot / 2, 2) / 2
#let free-w = n-long * slot-free; #let free-n = n-short * slot-free
#let z-hide5(eye, oy, oz, fy) = eye.at(2) + (oz - eye.at(2)) * (fy - eye.at(1)) / (oy - eye.at(1))
#let seen5(eye) = calc.max(0, h5.z-top - calc.max(z-hide5(eye, -0.125, 7.65, h5.y0), z-hide5(eye, 0.875, 8.68, h5.y0)))   // over the north coping and the attic's north line, to the head's north face
#let views5 = (([the gate (the char_gate camera)], (-3.9, -4.9, 1.7)), ([the north boundary, 6.1 m off the facade], (5.1, -6.215, 1.6)), ([the north street, 14 m off the facade], (5.1, -14.125, 1.6)), ([the far side of the street, 25 m], (5.1, -25.125, 1.6)))
#let court-seen = h5.z-top - 7.4                                 // from the seating: the head rises straight from the sky hole's west edge (R11, +7.2 + the slab finish)
#let suns = (([winter noon], 45.2, 180), ([winter 15:30], 27, 228), ([summer noon], 88, 180), ([summer 15:00], 50, 272), ([summer 17:30], 20, 290))   // altitude, azimuth (from N, clockwise): Taif 21.3° N, ASSUMED from the solar geometry
#let shadow(alt, az) = { let L = 13.2 / calc.tan(alt * 1deg); let a = (az + 180) * 1deg; (L: L, dir: (calc.sin(a), -calc.cos(a))) }   // the shadow's length and plan direction (north = −y)
#let on-court(sh) = { let d = sh.dir; if d.at(0) <= 0.05 { none } else { let y = 7.6 + (8.95 - 5.1) * d.at(1) / d.at(0); if y >= 6.5 and y <= 13.0 and sh.L >= 3.85 / d.at(0) { y } else { none } } }
#let checks5 = (
  ([every head face on the 20 cm module: piers 0.30, slots 0.20, ribs 0.20 (1.6 = 0.3 + 3 × 0.2 + 2 × 0.2 + 0.3; 2.4 = 0.3 + 5 × 0.2 + 4 × 0.2 + 0.3)], calc.abs(2 * h5.pier + n-short * h5.slot + (n-short - 1) * h5.rib - 1.6) < 1e-6 and calc.abs(2 * h5.pier + n-long * h5.slot + (n-long - 1) * h5.rib - 2.4) < 1e-6),
  ([the openings start at or above the roof bubble's estimated top (+#str(calc.round(bubble-top, digits: 2)), Phase 1) less 0.25 m], h5.z-open0 >= bubble-top - 0.25),
  ([the head is seen from the courtyard seating (#str(calc.round(court-seen, digits: 1)) m) and from the street at 14 m, not from the gate], court-seen > 5 and seen5(views5.at(2).at(1)) > 1.0 and seen5(views5.at(0).at(1)) == 0),
  ([the summer afternoon shadows fall across the courtyard's north part, the winter ones off it], on-court(shadow(50, 272)) != none and on-court(shadow(27, 228)) == none),
)
#let ok5 = checks5.all(c => c.at(1))
#let head-elev(n, w, title) = cetz.canvas(length: 0.5cm, {
  import cetz.draw: *
  let poly(pts, f, s) = line(..pts, close: true, fill: f, stroke: s)
  rect((0, 7.3), (w, h5.z-band), fill: sand, stroke: 0.4pt + ink)
  rect((-0.06, h5.z-band), (w + 0.06, h5.z-band + 0.15), fill: honey, stroke: 0.3pt + ink)
  rect((0, h5.z-band + 0.15), (w, h5.z-crown), fill: sand, stroke: 0.4pt + ink)
  for k in range(n) { let c = h5.pier + h5.slot / 2 + k * (h5.slot + h5.rib); poly(archpoly(c, h5.slot, h5.z-open0, h5.z-open1 - h5.slot / 2), rgb("#2b2b2d"), none); poly(archpoly(c, h5.slot + 0.08, h5.z-open0 - 0.04, h5.z-open1 - h5.slot / 2), none, 0.4pt + honey.darken(20%)) }
  rect((-0.05, h5.z-crown), (w + 0.05, h5.z-crown + 0.12), fill: honey, stroke: 0.3pt + ink); rect((-0.10, h5.z-crown + 0.12), (w + 0.10, h5.z-top), fill: honey, stroke: 0.3pt + ink)
  line((-0.6, 8.68), (w + 0.6, 8.68), stroke: (paint: gray, thickness: 0.3pt, dash: "dashed")); content((w + 0.65, 8.68), anchor: "west", text(3.2pt, fill: gray)[attic +8.68])
  line((-0.6, bubble-top), (w + 0.6, bubble-top), stroke: (paint: red, thickness: 0.3pt, dash: "dashed")); content((w + 0.65, bubble-top), anchor: "west", text(3.2pt, fill: red)[bubble ≈ +#str(calc.round(bubble-top, digits: 1))])
  content((w / 2, 13.75), text(4.4pt, weight: "bold", fill: green, title)); content((w / 2, 6.85), text(3.4pt)[+7.30 roof finish])
})

#pagebreak()
#text(12pt, weight: "bold", fill: green)[Phase 5 · the tower head · F3 on the roof beams · visibility · shadows · roof access]
#v(1pt)
#text(7pt, fill: gray)[Short, as the owner asked. The head 1.6 × 2.4 (F3): an RC frame with 0.30 corner piers and ring beams at the band (+#str(h5.z-band)) and the crown (+#str(h5.z-crown)), the slender ribs in rendered block; *render and paint*: light sand, the band, the crown and the slot surrounds in the calm honey tone, every projection formed in the structure with a drip. The openings +#str(h5.z-open0) … +#str(h5.z-open1) on all four faces (the W and N faces matter, Phase 0); the crown +#str(h5.z-top) (4.5 m above the attic coping, 5.9 above the roof finish).]
#v(3pt)
#grid(columns: (auto, auto, auto, 1fr), gutter: 8pt,
  head-elev(n-short, 1.6, [N face (1.6)]), head-elev(n-long, 2.4, [W face (2.4)]),
  cetz.canvas(length: 0.62cm, {
    import cetz.draw: *
    // E–W section at y ≈ 8.2 through the head's south part over the gallery roof: R3 widened, R11, the slab between
    let X(x) = (x - 3.6) * 2.0
    rect((X(3.6), 6.0), (X(6.6), 6.3), fill: luma(205), stroke: none)
    rect((X(4.125), 6.2), (X(4.525), 7.2), fill: luma(120), stroke: 0.4pt + ink); content((X(4.325), 5.75), text(3.2pt)[R3 widened\ 0.25 → 0.40])
    rect((X(5.675), 6.3), (X(5.925), 7.2), fill: luma(120), stroke: 0.4pt + ink); content((X(5.8), 5.75), text(3.2pt)[R11\ (as is)])
    rect((X(3.6), 7.0), (X(6.6), 7.3), fill: luma(170), stroke: none); content((X(6.3), 7.5), text(3pt)[gallery roof +7.30])
    rect((X(4.30), 7.3), (X(4.50), 13.2), fill: sand, stroke: 0.4pt + ink); rect((X(5.70), 7.3), (X(5.90), 13.2), fill: sand, stroke: 0.4pt + ink)
    rect((X(4.24), 10.6), (X(5.96), 10.75), fill: honey, stroke: none); rect((X(4.2), 12.9), (X(6.0), 13.2), fill: honey, stroke: none)
    content((X(5.1), 9.0), text(3.4pt)[the head's W and E walls\ on R3 and R11])
    line((X(4.4), 7.3), (X(4.4), 6.9), stroke: 0.5pt + red); line((X(5.8), 7.3), (X(5.8), 6.9), stroke: 0.5pt + red)
    content((X(5.1), 13.75), text(4.4pt, weight: "bold", fill: green)[E–W section · y ≈ 8.2 · 1 m = 1.24 cm])
    content((X(5.1), 5.1), text(3pt)[the south wall (y 8.7) on a new 1.55 m beam R-L5\ (0.25 × 0.45) between R3 and R11])
  }),
  [
    #H[5.1 · F3 on the existing roof beams (the owner's condition)]
    - *East wall* (centre x 5.80): on *R11* as it is (0.25 × 0.45, C21 → C22). *West wall* (centre x 4.40): on *R3* (x 4.25, 0.25 wide) *widened to 0.40* (faces 4.125–4.525) over y 6.5–8.8, cast with the roof slab: the wall (4.30–4.50) then bears fully. *South wall* (y 8.6–8.8): on a *new short beam R-L5* (1.55 m, 0.25 × 0.45) between R3 and R11 under the slab. *North part* (y 6.4–7.6): the core's own walls from the foundation.
    - *Verdict:* F3 stands on the existing beams with *two small additions* (0.15 m more on R3 over 2.3 m, one 1.55 m beam). If the engineer refuses them, *F2* (the head 1.6 × 1.6 on the core alone, the north overhang) is the fall-back; nothing else changes.
    #H[5.2 · Openings and mesh]
    - #n-short slots on the short faces, #n-long on the long: free ≈ #str(calc.round(free-n, digits: 2)) / #str(calc.round(free-w, digits: 2)) m² per face (the W face the main catcher); 20 mm bird mesh in galvanised frames behind the slots, the + divider and the four back-draught flaps inside; a 0.5 m hatch in the head's west face (+7.6 … +8.1) from the roof for the mesh, once a year.
    #H[5.3 · Visibility (the method of `studies/malqaf_tower.typ`)]
    #table(columns: (1fr, auto), inset: 2pt, stroke: 0.4pt + luma(180), fill: (_, y) => if y == 0 { rgb("#e4eedf") },
      [*From*], [*Seen above the roofline*],
      ..views5.map(((n, e)) => ([#n], [#if seen5(e) > 0 [#str(calc.round(seen5(e), digits: 1)) m] else [*hidden*]])).flatten(),
      [the courtyard seating], [*#str(calc.round(court-seen, digits: 1)) m*: the whole tower rises from the sky hole's west edge])
    - #WARN[unlike L1, *L5 is not seen from the gate or the north boundary* (it stands 6.4 m behind the north facade): the symbol reads from *inside the house* (the courtyard, the gallery) and from the street beyond ≈ 10 m; from the gate the house shows its plain roofline.]
  ],
)
#v(3pt)
#grid(columns: (1fr, 1fr), gutter: 10pt,
  [
    #H[5.4 · Shadows on the courtyard (the head's top 13.2 m above the courtyard floor; sun positions #ASSUMED)]
    #table(columns: (auto, auto, auto, 1fr), inset: 2pt, stroke: 0.4pt + luma(180), fill: (_, y) => if y == 0 { rgb("#e4eedf") },
      [*Sun*], [*alt / az*], [*shadow*], [*Where*],
      ..suns.map(((n, alt, az)) => { let sh = shadow(alt, az); let y = on-court(sh); ([#n], [#str(alt)° / #str(az)°], [#str(calc.round(sh.L, digits: 1)) m], [#if y == none [off the courtyard (north / west: the family living's and the gallery's roofs)] else [*across the courtyard's north part* to y ≈ #str(calc.round(y, digits: 1)) at the east wall: welcome shade on the seating's north end]]) }).flatten())
    - *Winter:* the tower shades nothing in the courtyard (its shadow goes north). *Summer afternoons and evenings:* a moving band of shade across the seating's north half, 1.6–2.4 m wide: welcome. Mornings: the shadow falls west, outside the courtyard.
  ],
  [
    #H[5.5 · The roof]
    - The head stands *inside the attic* (x ≥ 0.875 ✓); the courtyard sky hole's *guard* (1.10, black steel) now starts at the head's south-east corner (y 8.8) instead of C21: the head's wall is the guard for y 6.5–8.8. The north-block *walkway* (x 3.5) passes 0.8 m west of the head: the mesh hatch opens onto it. Distances: the tank *Z3* (x 2.85–4.15, y 1.0–3.5) ≈ 2.9 m north-west, the condensers *Z2b* (x ≥ 9.6) 3.7 m east, the west stack's vent re-routed away (Phase 4).
    - *Removed with L5:* the L1 tower, its plant room and plenum at the north-east corner; the attic's north-east corner returns to its V9.1 pentagon.
    #H[5.6 · 3D]
    - Rendered on a *copy* of the adopted model (`3d/malqaf_L5_views.py`: the L1 tower, plant room and plenum taken out, the roofline rings rebuilt, the L5 core and head added in render colours; the adopted files untouched): the next page, from the courtyard seating and from the gate. The L1 shaft's interior walls at the north-east corner stay in the copy (not visible from these cameras).
  ],
)
#v(2pt)
#block(width: 100%, inset: 4pt, fill: rgb("#eef4ec"), radius: 2pt)[#set text(lang: "ar", dir: rtl, font: ("Segoe UI", "Arial"), size: 8.4pt)
  #set par(leading: 0.6em)
  *ملخص المرحلة 5:* رأس البرج 1.6 × 2.4 م إطار خرساني بأعمدة في الأركان وجسور ربط عند الحزام والتاج، والأضلاع بين الفتحات بلك مليّس؛ لياسة ودهان: رملي فاتح، والحزام والتاج وإطارات الفتحات بلون عسلي هادئ، وكل بروز مصبوب مع الهيكل. الفتحات من +11.2 إلى +12.6 فوق دوامة السطح، والتاج +13.2. يقوم F3 على الجسور الحالية بإضافتين صغيرتين: توسيع R3 بمقدار 15 سم على 2.3 م، وجسر قصير 1.55 م تحت الجدار الجنوبي؛ وإلا فالبديل F2. البرج يُرى كاملا من جلسة الفناء (نحو 5.8 م) ومن الشارع على بعد 14 م فأكثر (نحو 1.9 م)، ولا يُرى من البوابة ولا من الحد الشمالي لأنه خلف الواجهة بنحو 6.4 م: رمز البيت من الداخل لا من البوابة. ظلاله صيفا بعد العصر تعبر شمال الفناء على الجلسة (مرغوب)، وشتاءً تقع شمالا خارج الفناء. الصور ثلاثية الأبعاد في الصفحة التالية على نسخة من النموذج.
]
#v(2pt)
#text(6.2pt, fill: gray)[Phase 5 checks #if ok5 [*passed* (#checks5.len())] else [*FAILED*: #checks5.filter(c => not c.at(1)).map(c => c.at(0)).join([; ])] · sources: studies/structure.typ (R3, R11), studies/roof.typ (the attic, the guard, the walkways, Z2b, Z3), 3d/character.yaml (the gate camera), studies/sections.typ (the noon sun), studies/malqaf_tower.typ (the visibility method). Concept only.]

#pagebreak()
#text(12pt, weight: "bold", fill: green)[Phase 5 · L5 in 3D (a copy of the model; render and paint; style study, provisional)]
#v(4pt)
#grid(columns: (1fr, 1fr), gutter: 10pt,
  [#image("../3d/output/malqaf_L5_court.png", width: 100%) #text(7pt, weight: "bold", fill: green)[From the courtyard seating] #text(6.4pt, fill: gray)[ · the eye at (7.0, 12.4), 1.6 m, looking north: the first arch with the outlet, the blind arch above it, the head on the same axis]],
  [#image("../3d/output/malqaf_L5_gate.png", width: 100%) #text(7pt, weight: "bold", fill: green)[From the gate (the char_gate camera)] #text(6.4pt, fill: gray)[ · the L5 head is hidden behind the north facade (§ 5.3); the adopted L1 tower is removed in this copy]],
)


// ======================================================================= PHASE 6 · DECISION SHEET (9 Nov 2026; short, as the owner asked)
// The owner's Phase 5 answers: the gate visibility does not change his view (the tower is the symbol from the courtyard; the breeze at the seating is the goal, D1);
// the riwaq's solid wall with the bench (no glass strip); F3 with the two beam additions (R3 widened to 0.40 over 2.3 m; one 1.55 m beam), F2 the fall-back.
#let G(t) = text(fill: green, weight: "bold", t); #let A(t) = text(fill: amber, weight: "bold", t); #let Rd(t) = text(fill: red, weight: "bold", t)
#let cmp = (
  ([Breeze at the seating (L1 = 1.00; the same wind, assumed)], [#G[≈ 4.3] (≈ 1.8 m³/s at 21 km/h: the outlet in the first arch, no channel)], [1.00 (≈ 0.42 m³/s: 10.6 m of channel, the outlet under the TV)], [≈ 1.1]),
  ([Breeze route, shaft foot → the seating], [#G[≈ 1 m]], [≈ 10.6 m], [≈ 2 m]),
  ([Filtered-air intake (cleanliness)], [#G[good]: a never-closing hood under the overhang, every exhaust ≥ 5.7 m, the west vent re-routed], [#G[best]: the NE corner, the vents 8.3 m, the condensers 4.6 m], [#A[fair]: 2.7 m to the condensers]),
  ([Rooms taken], [#A[the covered strip 3.5 m² (a by-product, D6), the gallery 1.7 m², the riwaq's 2.1 m glass panel, the majlis's 0.5 m panel]], [#A[the maid bath −0.8 m², bedroom 1 −0.8 m² (+ a store and a cupboard)]], [#Rd[the women's majlis −1.4 m², the family living −1.4 m²]]),
  ([Bedrooms touched (noise, fear)], [#G[none] (D10: GF the courtyard, FF the gallery)], [#Rd[bedroom 1] shares the shaft's wall; the maid bath below], [#G[none]]),
  ([Structure], [an independent RC core from its own pad; the head an RC frame (earthquake governs)], [a slim shaft in the cut wall, the tower on W3 with a ring beam, a plenum box], [#G[best]: on W3 and the courtyard wall]),
  ([Help to the west projection], [#G[yes]: the fourth support, B3 / B4 first spans 6.50 → 4.33 m, C17 and C21 absorbed], [none], [none]),
  ([Maintenance access], [#G[all from the carved door at ground level]; the roof hatch once a year for the mesh], [a 0.4 m panel in the maid bath + the roof hatch; the channel's 8 floor covers], [a panel in the majlis]),
  ([Cooler readiness (option, D9)], [#G[yes]: the space, a power point, a drain in the foot chamber], [#Rd[no]: a 0.9 × 0.2 channel in the slab, no room], [#A[cramped]]),
  ([Winter closing], [D1 + D2 shut by the switch; the house unaffected], [the top damper; the channel's covers in the laundry and kitchen floors], [a damper]),
  ([Facade / character], [#G[the tower begins the colonnade]: the outlet arch, the blind arch and the head on one axis; W1-1 lost], [a tower on the attic's north-east corner, apart from the courtyard], [a tower over the majlis corner]),
  ([Seen from the gate · the street (14 m)], [#Rd[hidden] · 1.9 m], [#G[3.3 m] · 4.1 m], [hidden · 1.4 m]),
  ([Seen from the courtyard seating], [#G[5.8 m, the whole tower]], [≈ 1 m of the crown], [4.9 m]),
  ([Shadows on the courtyard], [#G[summer afternoons: a band of shade on the seating's north half]; winter: none], [none (far corner)], [summer afternoons on the north part]),
  ([Cost index (assumed; the HRV dropped in all, D2)], [#A[≈ 1.2]: the core and pad, the head frame, the door, the beam additions; minus the slab channel, the covers, the plenum, the NE shaft and tower; B3 / B4 lighter], [1.00 (V9.3)], [≈ 0.9]),
)
#let checklist = (
  ([*Data*], [`data/rooms_gf.csv`: the maid bath and the maid room back to their *V9.1* polygons, the *maid store removed*; the *courtyard* polygon less the core (x 4.25–5.80, y 6.5–8.767); `data/rooms_ff.csv`: bedroom 1 back to its *V9.1* polygon (no slanted inner wall), the *cupboard removed*; the *upper gallery* less the shaft (x 4.25–5.80, y 6.5–7.6); `data/decisions.csv`: the adoption row (L5 · V-c · F3 · D1–D11 · the simple controls)]),
  ([*Plans*], [`design_gf.typ`: `tower-pts` → the L5 shaft; the women's majlis's 0.5 m courtyard glass panel removed; the riwaq's glass y 6.8–8.9 → the core's solid face with the *bench*; the chamber's carved door; the outlet in the first arch; the maid bath's fixtures free again (no channel); `design_ff.typ` (via `ff_family.typ`): the shaft in the gallery, *W1-1 replaced by the blind arch*, bedroom 1 V9.1 with its first cut window back at y 1.6–3.2]),
  ([*Air*], [`studies/air_system.typ`: v3 → *L5*: the shaft, the head (+11.2 … +12.6, crown +13.2), the foot chamber, the dust trap, the outlet 1.4 × 1.0 + D2, D1, the filtered path (the inlet under the overhang, the filters, the 750 m³/h fan, the silencer, the grilles), the *two switches and the dust relay*, the cooler space (option); *removed:* the HRV, the plant room, the plenum, the breeze channel under the maid bath and its covers; *kept:* the hood's make-up inlet (mandatory); `docs/AIR_SYSTEM.md` rewritten]),
  ([*Roof*], [`studies/roof.typ`: the head polygon and levels, the plant room zone removed, the attic's north-east corner back to V9.1, the sky hole's guard from the head's SE corner, the walkway and the mesh hatch, the sight lines; *the west stack's vent re-routed to the south-east* (with `studies/plumbing.typ`)]),
  ([*Structure*], [`studies/structure.typ`: the RC core and its pad, C17 and C21 absorbed, the first arcade column structural, B3 / B4 spans 6.50 → 4.33 (sections to re-check), *R3 widened to 0.40 over y 6.5–8.8*, the *new beam R-L5* (1.55 m), the head frame (ring beams at the band and the crown), the slab ties; *removed:* B15 / R9 and the slim shaft's wall at the north-east corner (the slabs close)]),
  ([*Other studies*], [`east_wing.typ` (the V9.1 maid wing, the tower polygon removed, the expected total in `tools/check.py`), `ff_family.typ`, `ff_suite.typ`, `plumbing.typ` (the maid bath, the chamber's gully, the hrv-intake point, the constraint text removed), `gf_shower.typ`, `site_plan.typ` (the intake point), `courtyard_enclosure.typ` / `courtyard_layout.typ` (the first bay's outlet, the blind arch, the riwaq's solid face), `sections.typ` (check the tower); `malqaf_tower.typ`, `ne_corner.typ`, `malqaf_L5.typ` marked *record / adopted*]),
  ([*3D*], [`3d/params.yaml` (the plant room removed, W1-1 and the riwaq panel removed, the majlis panel), `3d/build_3d.py` (the L5 core, chamber and head; the L1 tower, plant room and plenum code removed; the roofline cuts), `3d/check_3d.py` (the shaft, the head, the attic corner), `3d/character.yaml` (*no stone: every exterior material plaster / render, the projections in the honey tone; the floors porcelain*; the arcade's first bay; the bookmarks and captions), the viewer's notes; the renders (the courtyard, the gate, an aerial)]),
  ([*Presentation*], [`presentation.typ`: sheets 02, 03, 04, 06 (the plans), 05 (the courtyard enclosure: W1-1 → the blind arch), 08 (the schedules), 09 (the decisions), 10 (the open items), 11 (the roof), 12 (the elevations and sight lines); *every "honey stone" and "marble" → render / porcelain* (owner, 9 Nov 2026); the DXFs regenerated]),
  ([*Docs*], [`PROJECT_V9.md` → V10.0 (§1, §2, §3, §4 the new decisions, §5 *the layout-freeze exception: the courtyard's covered strip and the gallery changed by the owner's L5 decision*, §7), `OPEN_ITEMS.md` (item 9 rewritten, the new engineer items below), `DESIGN_LANGUAGE.md` (the malqaf row), `NEXT_SESSION.md`, the READMEs, `PENDING_CHANGES.md` cleared]),
)
#let eng = (
  ([Structural], [the soil report (the pad's bearing, assumed 150 kPa); the core's walls and pad, the ties to the FF and roof slabs; B3 / B4 re-sized for 4.33 m spans; R3 widened, the new R-L5; the head frame for wind and *earthquake (Sds for the site)*; the first arcade column as a structural member; the slab openings closed at the north-east corner]),
  ([MEP], [the fan (750 m³/h, 250 Pa) and its silencer; the filters (ISO Coarse 60 % + ePM1 ≥ 50 %); D1 / D2 insulated spring-return dampers and the dust relay (PM2.5 50 / 25 µg/m³); the outlet louvres and the gallery / living / riwaq / majlis grilles; the hood's make-up inlet (mandatory); the west vent re-routed to the south-east; the chamber's gully, the capped water point, the IP44 circuit; the breeze estimate (≈ 1.8 m³/s) confirmed]),
  ([Owner], [the on-site weather station (≥ 6 m, 4–6 weeks); a cooler shortlist (the 0.8 × 0.7 × 1.6 m envelope); the carved door and the outlet grille as joinery]),
  ([Already recorded], [the facade study (open item 20) and *D11* (open item 21) for the facades phase after the plan freeze; no stone, render and paint; porcelain floors]),
)
#let checks6 = (
  ([the comparison covers the brief's 14 criteria plus the gate visibility (#cmp.len() rows)], cmp.len() == 15),
  ([the adoption checklist names the data, the plans, the air, the roof, the structure, the other studies, the 3D, the presentation and the docs (#checklist.len() groups)], checklist.len() == 9),
)
#let ok6 = checks6.all(c => c.at(1))

#pagebreak()
#text(12pt, weight: "bold", fill: green)[Phase 6 · the decision sheet · L5 (V-c + F3) against L1 (V9.3), L2 for reference]
#v(1pt)
#text(7pt, fill: gray)[The owner's Phase 5 answers: the gate visibility does not change his view (the tower is the symbol from the courtyard, where the family lives; the breeze at the seating is the goal, D1); the riwaq's solid wall with the bench; F3 with the two beam additions (R3 widened to 0.40 over 2.3 m, one 1.55 m beam), F2 the fall-back. Every figure #ASSUMED; the engineers confirm.]
#v(3pt)
#table(columns: (1.15fr, 1.6fr, 1.35fr, 1fr), inset: 2.4pt, stroke: 0.4pt + luma(175), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f3f1ea") },
  [*Criterion*], [*L5 · the courtyard's north-west corner (V-c + F3)*], [*L1 · the north-east cut corner (V9.3, adopted)*], [*L2 · reference*],
  ..cmp.flatten())
#text(6.4pt, fill: gray)[Green = better, amber = a price, red = a drawback. L2 from `studies/malqaf_tower.typ` pages 6–7 (the courtyard's north-east corner in the women's majlis), re-based on L1 V9.3 = 1.00.]
#v(4pt)
#H[Recommendation]
*L5.* It serves the owner's goal (D1) about four times better than L1 at the seating, touches no bedroom, is cleaned from a door at ground level, holds a cooler, strengthens the west projection and puts the symbol where the family lives. Its prices are the covered strip's north end and 1.7 m² of the gallery, one gallery window turned into a blind arch, two glass panels, a cost index of ≈ 1.2 and a tower that the gate does not see. L1 stays the cleanest intake and the one seen from the gate; it remains the adopted design until the owner adopts L5.
#v(3pt)
#H[Open items for the engineers (on adoption)]
#table(columns: (auto, 1fr), inset: 2.2pt, stroke: 0.4pt + luma(175), fill: (_, y) => if y == 0 { rgb("#e4eedf") }, [*Who*], [*What*], ..eng.flatten())

#pagebreak()
#text(12pt, weight: "bold", fill: green)[Phase 6 · the adoption checklist (the commit "L5 adopted", then the release V10.0)]
#v(3pt)
#table(columns: (auto, 1fr), inset: 2.6pt, stroke: 0.4pt + luma(175), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f3f1ea") }, [*Where*], [*What changes if L5 is adopted*], ..checklist.flatten())
#v(3pt)
#text(6.6pt)[*Order of work:* the data and the plans first (the room polygons, the courtyard and the gallery, the maid wing and bedroom 1 back to V9.1), then the air, roof and structure studies, then the 3D and the presentation, then the docs and the release; `tools/check.py` and `3d/check_3d.py` must pass at every step (their expected totals and tower checks change with the data). *Not changed by L5:* the site position, the cut wall, the set-out, the south wing, the suite, the kitchen, the stair, the lift.]
#v(2pt)
#text(6.2pt, fill: gray)[Phase 6 checks #if ok6 [*passed* (#checks6.len())] else [*FAILED*: #checks6.filter(c => not c.at(1)).map(c => c.at(0)).join([; ])] · The study ends here; the owner decides and sends the adoption + release V10.0 prompt.]

#pagebreak()
#block(width: 100%, inset: 8pt)[#set text(lang: "ar", dir: rtl, font: ("Segoe UI", "Arial"), size: 10pt)
  #set par(leading: 0.7em, justify: true)
  #text(15pt, weight: "bold", fill: green)[الملقف: ملخص القرار للمالك وزوجته]
  #v(6pt)
  *ما هو الملقف ولماذا؟* برج يلتقط ريح الطائف المسائية (غربية وشمالية غربية صيفا) وينزلها إلى جلسة الفناء نسيما طبيعيا قويا، وهو أيضا مدخل الهواء المرشح للبيت. هو الفكرة التي تجعل العائلة تستمتع بجو الطائف في فنائها، ورمز البيت من الداخل.
  #v(4pt)
  *أين يقف؟* في الركن الشمالي الغربي للفناء، داخل الممر المسقوف تحت بروز الدور الأول، ملاصقا لجدار مجلس النساء دون أن يأخذ منه شيئا. في الدور الأرضي غرفة صغيرة (1.2 × 2 م) بباب خشبي منحوت على الممر المسقوف، فيها مصيدة الغبار والمرشحات والمروحة ومكان لمبرد صحراوي متنقل إن أردتم لاحقا. فتحة الهواء داخل أول قوس من الرواق المقوّس، مقابل الجلسة مباشرة. في الدور الأول مجرى 1.2 × 0.8 م في طرف الممر العلوي، والممر يبقى بعرض 1.5 م. فوق السطح برج 1.6 × 2.4 م بلياسة رملية فاتحة وحزام وتاج بلون عسلي، فتحاته رأسية نحيلة مقوّسة، يبدأ به صف أقواس الفناء بخط واحد من القوس إلى التاج.
  #v(4pt)
  *ماذا نكسب؟* نسيم في الجلسة نحو أربعة أضعاف الموقع الحالي في الركن الشمالي الشرقي؛ لا يلامس البرج أي غرفة نوم (لا ضوضاء ولا خوف للأطفال)؛ الصيانة كلها من باب في الدور الأرضي بلا سلالم؛ مكان جاهز لمبرد صحراوي؛ النواة الخرسانية تصير دعامة رابعة لبروز الدور الأول فيقوى الهيكل؛ ظل لطيف على شمال الجلسة في أمسيات الصيف؛ ويختفي البرج القديم وغرفة المعدات من سطح الركن الشمالي الشرقي، وتعود غرفة الأطفال وحمام الخادمة وغرفتها إلى أشكالها المستقيمة.
  #v(4pt)
  *ماذا ندفع؟* نهاية الممر المسقوف (نحو 3.5 م²) ونحو 1.7 م² من الممر العلوي؛ أول نافذة مقوّسة في الممر العلوي تصير قوسا أعمى غائرا؛ لوح زجاج الرواق الأول يصير جدارا مصمتا عليه كنبة خشبية، ويفقد المجلس لوحا صغيرا (نصف متر)؛ التكلفة نحو 1.2 من البديل الحالي (تقدير)؛ والبرج لا يُرى من البوابة، بل من الفناء ومن الشارع البعيد.
  #v(4pt)
  *كيف يُستعمل؟* مفتاحان على الجدار: الملقف مفتوح أو مغلق، والمروحة عادي أو قوي. حساس غبار واحد يغلق الملقف بنفسه في الغبار، وكل الخوانق تُغلق تلقائيا عند انقطاع الكهرباء. شتاءً تغلقون الملقف بالمفتاح، والبيت يبقى مهوّى بالمروحة المرشحة. لا مبرد الآن؛ الملقف نظام جاف، والمبرد خيار للصيف القادم.
  #v(4pt)
  *ماذا يحتاج بعد؟* المهندس الإنشائي (التربة، النواة وقاعدتها، تقصير الجسرين B3 وB4، توسيع الجسر R3 وجسر قصير جديد، إطار الرأس للزلازل)، ومهندس الميكانيكا (المروحة والمرشحات والكاتم، الخانقان وحساس الغبار، مدخل الهواء التعويضي لشفاط المطبخ، تحويل تهوية الصرف الغربية إلى الجنوب الشرقي)، ومحطة طقس صغيرة في الموقع لبضعة أسابيع لتأكيد اتجاه الريح.
  #v(6pt)
  #block(fill: rgb("#e4eedf"), inset: 6pt, radius: 3pt, width: 100%)[*التوصية: اعتماد الموقع L5 (البديل ج مع الرأس F3).* البديل الحالي L1 يبقى الأنظف لمدخل الهواء والوحيد الذي يُرى من البوابة، لكنه يعطي ربع النسيم ويلامس غرفة نوم وتُصان مصيدته من حمام الخادمة. القرار للمالك؛ وبعده يُرسَل أمر الاعتماد والإصدار V10.0.]
]

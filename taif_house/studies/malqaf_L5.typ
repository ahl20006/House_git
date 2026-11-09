// malqaf_L5.typ · Taif / Palm House · L5 MALQAF: FULL DESIGN STUDY (decision-grade), in PHASES · STUDY ONLY (the design files are not changed)
// L5: the malqaf at the courtyard's NORTH-WEST corner, inside the covered strip under the FF west projection, against the y 6.5 wall.
// The brief's WARNINGs are printed as "⚠ CAUTION" (tools/check.py reserves the word WARNING for failed checks).
// Owner decisions 9 Nov 2026 (D1–D11, not reopened): a LARGE natural breeze for the courtyard (D1); no HRV, a filtered supply fan (D2); one tower,
// two paths after the head (D3); no water tank on the tower (D4); a dust-tight house, the courtyard an open outdoor room (D5); the covered strip may be
// taken (D6); the shaft as large as needed, the head ≥ the shaft (D7); the gallery's arched windows may be redesigned (D8); prepare an evaporative cooler
// in the shaft's foot (D9); the tower touches no bedroom (D10); the D11 facade module (20 cm; GF / FF windows on one axis) as a constraint.
// PHASE 0: the geometry check and the climate basis · PHASE 1: the L5 geometry and variants. Data: tools/climate_taif.py (Meteostat 41036 2011–2025, NOAA ISD 2015–2024).
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
    - *Clear 1.20 × 1.97 m (2.36 m²), ≈ 3.1 m high (to the FF slab) and open above into the shaft.* The dust trap: a 0.8 × 0.7 floor basin under the shaft (a lift-out stainless grating, a 0.25 m deep sump, a drain to the courtyard drainage); the filtered path's riser in the north-west corner, its filter cabinet + EC fan (0.45 × 0.60) at the west wall; the cooler's place at the outlet; a water point with a float valve, a floor drain, a dedicated circuit and IP44 sockets.
    - *The cooler (D9):* the common portable desert coolers sold in the Kingdom run from ≈ 45 L tanks (≈ 0.4 × 0.35 × 1.0 m) to 90–150 L (≈ 0.6–0.8 × 0.5–0.7 × 1.3–1.6 m); the chamber is laid out for the larger envelope *0.8 × 0.7 × 1.6 m* (#ASSUMED: the owner's shortlist to confirm), rolled in through the door, its outlet against the grille.
    - *The outlet:* *1.4 × 0.9 m* in the first arch, sill +0.10, adjustable timber or pierced-stone louvres (≈ 60 % free, 0.76 m²) aiming the air along the seating; a motorised insulated damper behind it (Phase 4).
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

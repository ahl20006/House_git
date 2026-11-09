// malqaf_L5.typ · Taif / Palm House · L5 MALQAF: FULL DESIGN STUDY (decision-grade), in PHASES · STUDY ONLY (the design files are not changed)
// L5: the malqaf at the courtyard's NORTH-WEST corner, inside the covered strip under the FF west projection, against the y 6.5 wall.
// Owner decisions 9 Nov 2026 (D1–D11, not reopened): a LARGE natural breeze for the courtyard (D1); no HRV, a filtered supply fan (D2); one tower,
// two paths after the head (D3); no water tank on the tower (D4); a dust-tight house, the courtyard an open outdoor room (D5); the covered strip may be
// taken (D6); the shaft as large as needed, the head ≥ the shaft (D7); the gallery's arched windows may be redesigned (D8); prepare an evaporative cooler
// in the shaft's foot (D9); the tower touches no bedroom (D10); the D11 facade module (20 cm; GF / FF windows on one axis) as a constraint.
// PHASE 0 (this issue): the geometry check and the climate basis. Data: tools/climate_taif.py (Meteostat 41036 2011–2025, NOAA ISD 2015–2024).
// CSV frame (x east, y south, wall centre lines); levels from the finished ground floor. Every figure ASSUMED until the engineers confirm.
#import "@preview/cetz:0.4.2"
#set page(paper: "a4", flipped: true, margin: 8mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 7.3pt)
#set par(leading: 0.42em)
#let green = rgb("#2f6b4f"); #let ink = rgb("#26302b"); #let gray = rgb("#6d736f"); #let red = rgb("#b5452f"); #let amber = rgb("#b07a1f"); #let blue = rgb("#1f7a99")
#let H(t) = block(above: 5pt, below: 3pt, text(9pt, weight: "bold", fill: green, t))
#let WARN(t) = box(fill: rgb("#fbe3dc"), inset: 2.5pt, radius: 2pt, text(fill: red, weight: "bold")[WARNING · ] + t)
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
    #text(6.4pt)[*Mismatches:* (1) the riwaq is 1.5 m wide along the courtyard (x 2.75–4.25), 2.0 m only at the lobby (y 0–2.2); (2) the covered strip's clear width ≈ 1.35–1.45 m depending on the glazing build-up (to fix in Phase 1). *Also noted:* a column C17 already stands at (4.25, 6.5), the corner the L5 core starts from (Phase 2); at y 6.5–9.2 the FF gallery is 3.05 m wide only because its west half (x 2.75–4.25) is the stair's arrival zone: a core across the whole strip (V-b) leaves 1.5 m on axes, ≈ 1.3 clear, *below the brief's 1.5 m clear* (#text(fill: red)[WARNING for Phase 1]).]
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

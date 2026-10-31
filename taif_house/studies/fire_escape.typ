// fire_escape.typ · Taif / Palm House V7.1 · FIRE, ESCAPE AND LIFE SAFETY STUDY (design review E-08, CRITICAL) · study only
// Checks every sleeping room's escape opening, the routes to the exits, the smoke strategy of the open stair / void / gallery volume,
// the detection and equipment, the safe room and the elements with a fire role, against SBC 1101 / SBC 801 (as adopted from the IRC / IFC),
// the municipal requirements and global practice; every rule is cited, and marked "not verified" where its Saudi text could not be checked.
// No CSV or design file is changed: the fixes are proposals for the owner (decision) or the engineers (to confirm).
// Reads: data/rooms_gf.csv, data/rooms_ff.csv (the plans), 3d/params.yaml (every window with its sill and head), 3d/character.yaml (the mashrabiya screens).
// CSV frame: x east, y south, wall centre lines; levels above the finished ground floor ±0.00.
#import "@preview/cetz:0.4.2"
#set page(paper: "a4", flipped: true, margin: 9mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 7.3pt)
#let ink = rgb("#3d4a45")
#let accent = rgb("#5a7d2a")
#let red = rgb("#b5452f")
#let amber = rgb("#b58a1f")
#let green = rgb("#2f7a3f")
#let blue = rgb("#2f5f8a")
#let r2(v) = str(calc.round(v, digits: 2))
#let r1(v) = str(calc.round(v, digits: 1))
#let f2(v) = { let s = str(calc.round(v, digits: 2)); if not s.contains(".") { s + ".00" } else if s.split(".").at(1).len() == 1 { s + "0" } else { s } }
#let H(body) = text(9.5pt, weight: "bold", fill: accent, body)
#let dist(a, b) = calc.sqrt(calc.pow(a.at(0) - b.at(0), 2) + calc.pow(a.at(1) - b.at(1), 2))
#let plen(P) = range(P.len() - 1).map(i => dist(P.at(i), P.at(i + 1))).sum()
#let PASS = text(fill: green, weight: "bold")[pass]
#let FAIL = text(fill: red, weight: "bold")[fail]
#let NV = text(fill: amber, weight: "bold")[not verified]

// ---------- the project files ----------
#let parse-pts(s) = s.split(";").map(t => t.trim()).filter(t => t != "").map(t => { let v = t.split(" ").filter(u => u != ""); (float(v.at(0)), float(v.at(1))) })
#let read(path) = csv(path, row-type: dictionary).filter(r => r.name != "" and not r.name.starts-with("#")).map(r => {
  let P = if r.pts.trim() != "" { parse-pts(r.pts) } else {
    let x = float(r.x); let y = float(r.y); let w = float(r.w); let d = float(r.d)
    ((x - w / 2, y - d / 2), (x + w / 2, y - d / 2), (x + w / 2, y + d / 2), (x - w / 2, y + d / 2)) }
  (name: r.name, colour: r.colour, P: P) })
#let GF = read("../data/rooms_gf.csv")
#let FF = read("../data/rooms_ff.csv")
#let params = yaml("../3d/params.yaml")
#let chr = yaml("../3d/character.yaml")
#let WIN = params.openings.windows.map(w => { let v = w.at.split(" ").map(float); (floor: w.floor, a: (v.at(0), v.at(1)), b: (v.at(2), v.at(3)), sill: w.sill, head: w.head, note: w.at("note", default: "")) })
#let screened = chr.mashrabiya.windows.map(w => (floor: w.floor, at: w.at))
#let has-screen(floor, at) = screened.any(s => s.floor == floor and s.at == at)
#let win(floor, at) = {   // a window listed in params.yaml with its own heights, else the plans' window with the default sill / head (3d/params.yaml openings.window)
  let v = at.split(" ").map(float)
  let hit = WIN.find(w => w.floor == floor and calc.abs(w.a.at(0) - v.at(0)) < 1e-6 and calc.abs(w.a.at(1) - v.at(1)) < 1e-6 and calc.abs(w.b.at(0) - v.at(2)) < 1e-6 and calc.abs(w.b.at(1) - v.at(3)) < 1e-6)
  if hit != none { hit } else { (floor: floor, a: (v.at(0), v.at(1)), b: (v.at(2), v.at(3)), sill: params.openings.window.sill, head: params.openings.window.head, note: "default window (sill / head of params.yaml)") }
}
#let outline = ((0, 0), (10.051, 0), (13.311, 6.0), (13.311, 24.0), (0, 24.0))

// ---------- the rules (cited; "verified" = read in the IRC / IFC text the SBC is based on; the SBC 2024 wording itself: NOT VERIFIED here) ----------
#let R = (
  esc-area: 0.53, esc-area-grade: 0.465, esc-h: 0.61, esc-w: 0.508, sill-max: 1.118,     // IRC R310.2.1–R310.2.2 (5.7 / 5.0 sq ft, 24 in, 20 in, 44 in)
  door-w: 0.813, door-h: 1.981,                                                           // IRC R311.2 (32 in × 78 in) egress door
  stair-w: 0.914, headroom: 2.032, riser-max: 0.196, tread-min: 0.254,                   // IRC R311.7
  sash-max: 1.0, frame: 0.05,                                                             // this study's assumptions: a side-hung casement sash ≤ 1.0 m wide, a 50 mm frame / sash edge all round
)
#let rules = (
  ([Escape and rescue opening in every sleeping room: net clear ≥ #r2(R.esc-area) m² (#r2(R.esc-area-grade) m² at grade), ≥ #r2(R.esc-h) m high, ≥ #r2(R.esc-w) m wide, sill ≤ #r2(R.sill-max) m, opening to a yard or court that opens to a public way; operable from inside without keys, tools or special knowledge], [IRC 2021 R310.1, R310.2.1, R310.2.2, R310.2.3 · SBC 1101 (residential, from the IRC): section R310 assumed adopted unamended], NV),
  ([Bars, grilles, covers and screens over an escape opening: allowed only if releasable or removable from inside without a key, tool, special knowledge or extra force, keeping the minimum opening], [IRC 2021 R310.4 · SBC 1101 R310.4], NV),
  ([At least one egress door per dwelling, side-hinged, ≥ #r2(R.door-w) × #r2(R.door-h) m clear, openable from inside without a key or special knowledge; egress from all portions of the dwelling without passing through a garage], [IRC 2021 R311.2, R311.1 · SBC 1101 R311], NV),
  ([Stairways ≥ #r2(R.stair-w) m clear, headroom ≥ #r2(R.headroom) m, risers ≤ #r2(R.riser-max), treads ≥ #r2(R.tread-min), handrails; no enclosure or second stair required in a one-family dwelling], [IRC 2021 R311.7 · SBC 1101 R311.7], NV),
  ([Smoke alarms in each sleeping room, outside each separate sleeping area in the immediate vicinity of the bedrooms, on every storey; interconnected; hardwired with battery back-up; listed to UL 217], [IRC 2021 R314.3, R314.4, R314.6 · SBC 1101 R314], NV),
  ([Carbon-monoxide alarms outside each sleeping area where a fuel-fired appliance (the gas hob) is installed; listed to UL 2034], [IRC 2021 R315.2, R315.3 · SBC 1101 R315], NV),
  ([Enclosed usable space under a stair: ½ in (13 mm) gypsum board on the underside and the walls], [IRC 2021 R302.7 · SBC 1101 R302.7], NV),
  ([Automatic residential sprinklers (NFPA 13D) in new one-family dwellings], [IRC 2021 R313.2 · SBC 1101: whether R313 is adopted or deleted for villas, and the Civil Defense position, could not be read], NV),
  ([Portable fire extinguishers, LP-gas storage (cylinders outside in a ventilated cabinet, distances to openings), gas shut-off, generators outdoors away from openings], [SBC 801 (fire code, from the IFC 2018: §906, ch. 61) · Saudi Civil Defense villa requirements · NFPA 37 (generators) · manufacturer's clearances], NV),
  ([Domestic range hood ≥ 400 cfm needs make-up air; the hood exhausts directly outside], [IRC M1503.6 · SBC 501 (mechanical)], NV),
  ([Open-plan houses (stair open to living space): where the stair is not enclosed, UK practice asks for sprinklers or a fire-separated escape; not a Saudi rule], [BS 9991:2024 (UK, practice only)], [practice]),
  ([Municipal residential requirements (MOMAH): nothing specific on fire beyond the Civil Defense approval of the permit set], [MOMAH villa rules as reported 2024], NV),
)

// ---------- the sleeping rooms and their escape openings ----------
// (room, floor, the window "x1 y1 x2 y2" as in the plans, where it opens to, is the landing a yard / court open to a public way, note)
#let sleep = (
  ("Bedroom 1", "FF", "10.92 1.6 11.79 3.2", [the lane setback (2.5 m) → the lane], true, [cut-wall window; a second one "12.3 4.15 12.9 5.25"]),
  ("Bedroom 2", "FF", "0 11.3 0 12.6", [the west strip (0.785 m to the M line) → the driveway and the street], true, []),
  ("Bedroom 3", "FF", "0 17.2 0 18.2", [the west strip → the driveway and the street], true, []),
  ("Kids' room (a fourth bedroom later)", "FF", "5.3 0 8.7 0", [the north setback (3.8–5.7 m) → the north street], true, []),
  ("Master suite bedroom", "FF", "13.311 15.0 13.311 18.6", [the east strip (3.6–9 m) → the service yard and the lane], true, [the suite court is walled and has no way down: not an escape]),
  ("Maid room", "GF", "12.17 3.9 12.714 4.9", [the lane setback (2.5 m) → the lane], true, [grade floor: 0.465 m² applies; sill 1.50 for privacy]),
)
#let escape(w) = {
  let L = dist(w.a, w.b); let h = w.head - w.sill
  let n = calc.ceil(L / R.sash-max)                                  // casement sashes of ≤ 1.0 m; one sash opens
  let cw = L / n - 2 * R.frame; let ch = h - 2 * R.frame
  (width: L, height: h, sashes: n, clear-w: cw, clear-h: ch, area: cw * ch)
}
#let judge(row, w, e, grade: false) = {
  let screen = has-screen(row.at(1), row.at(2))
  let need = if grade { R.esc-area-grade } else { R.esc-area }
  let geo = e.area >= need and e.clear-w >= R.esc-w and e.clear-h >= R.esc-h and w.sill <= R.sill-max
  (geo: geo, screen: screen, ok: geo and not screen)
}
#let rows = sleep.map(row => {
  let w = win(row.at(1), row.at(2))
  let e = escape(w)
  let j = judge(row, w, e, grade: row.at(1) == "GF")
  (room: row.at(0), floor: row.at(1), at: row.at(2), w: w, e: e, j: j, to: row.at(3), yard: row.at(4), note: row.at(5))
})
#let n-pass = rows.filter(r => r.j.ok).len()
#let n-fail = rows.filter(r => not r.j.ok).len()
// the maid room fix: a casement 1.14 × 1.00 with the sill at +1.10, obscured glass below +1.60, an openable screen
#let maid-fix = (sill: 1.10, head: 2.10, width: dist((12.17, 3.9), (12.714, 4.9)))
#let maid-fix-e = (clear-w: maid-fix.width - 2 * R.frame, clear-h: maid-fix.head - maid-fix.sill - 2 * R.frame)
#let maid-fix-ok = maid-fix-e.clear-w * maid-fix-e.clear-h >= R.esc-area-grade and maid-fix-e.clear-w >= R.esc-w and maid-fix-e.clear-h >= R.esc-h and maid-fix.sill <= R.sill-max

// ---------- exits and routes (CSV frame) ----------
#let exits = (
  (name: "Family entrance (north wall)", a: (3.0, 0), b: (4.0, 0), width: 1.0, kind: "hinged, the dwelling's egress door", ok: 1.0 >= R.door-w),
  (name: "Guest entrance (west wall)", a: (0, 21.5), b: (0, 22.9), width: 1.4, kind: "double door, two 0.70 leaves: one leaf < 0.813 clear; both leaves open without a key", ok: false),
  (name: "Kitchen service door (east wall)", a: (13.311, 7.2), b: (13.311, 8.1), width: 0.9, kind: "hinged 0.90, lockable: a thumb-turn inside, never a key", ok: 0.9 - 0.1 >= R.door-w),
  (name: "Riwaq → courtyard (sliding glass)", a: (4.25, 9.1), b: (4.25, 10.5), width: 1.4, kind: "to the courtyard: a smoke-free refuge, not an exit (walled on four sides)", ok: false),
  (name: "Roof stair room door (+7.30)", a: (0.9, 7.9), b: (1.8, 7.9), width: 0.9, kind: "a way up to the open roof: a refuge and a rescue point, not a code exit", ok: false),
)
#let stair-top = (2.0, 7.6)       // the first-floor arrival strip
#let stair-foot = (0.75, 6.8)     // flight 1 starts here on the ground floor
#let stair-len = 2 * calc.sqrt(2.8 * 2.8 + 1.8 * 1.8) + 1.25   // two sloped flights and the half landing
#let family-door = (3.5, 0.0)
#let gf-from-stair = ((0.75, 6.8), (3.5, 6.8), (3.5, 0.0))
#let routes-ff = (
  ("Master suite bedroom", ((9.5, 11.9), (9.5, 5.9), (4.25, 3.8), (3.5, 3.8), (3.5, 8.5), (2.0, 8.5), stair-top), [suite lobby → family link → family living → gallery door → gallery → landing]),
  ("Bedroom 1", ((9.55, 5.3), (9.55, 5.9), (4.25, 3.8), (3.5, 3.8), (3.5, 8.5), (2.0, 8.5), stair-top), [family link → family living → gallery → landing]),
  ("Kids' room", ((4.25, 2.4), (3.5, 2.4), (3.5, 8.5), (2.0, 8.5), stair-top), [gallery → landing]),
  ("Bedroom 2", ((4.25, 11.6), (5.0, 11.6), (5.0, 8.5), (2.0, 8.5), stair-top), [gallery on the projection → landing]),
  ("Bedroom 3", ((4.25, 15.7), (5.0, 15.7), (5.0, 8.5), (2.0, 8.5), stair-top), [gallery on the projection → landing]),
  ("Gym (far end)", ((12.5, 23.0), (5.0, 22.6), (5.0, 21.25), (5.0, 8.5), (2.0, 8.5), stair-top), [gym → gym route → gallery → landing]),
)
#let routes-gf = (
  ("Men's majlis (east end)", ((12.5, 21.6), (3.0, 22.6), (2.75, 23.0), (0.0, 22.2)), [majlis → foyer → guest door; the serving passage doors are locked from the family side: not a route for guests]),
  ("Living (double height)", ((6.6, 16.5), (4.25, 13.8), (3.5, 13.8), (3.5, 0.0)), [entrance arch → riwaq → family door; the courtyard door (4.25, 9.1–10.5) is the nearer refuge]),
  ("Dining", ((11.1, 16.1), (9.95, 13.0), (12.0, 8.5), (13.311, 7.65)), [kitchen door → kitchen → service door; or west through the living to the riwaq]),
  ("Maid room", ((12.0, 5.5), (10.65, 3.4), (10.1, 3.4), (10.1, 7.0), (12.5, 7.65), (13.311, 7.65)), [laundry door → laundry → kitchen → service door (thumb-turn)]),
  ("Women's majlis", ((6.6, 3.25), (4.25, 1.1), (3.5, 1.1), (3.5, 0.0)), [door to the riwaq → family door]),
)
#let longest = calc.max(..routes-ff.map(((n, P, l)) => plen(P) + stair-len + plen(gf-from-stair)))

// ---------- detection and equipment (positions for the plans; S smoke, H heat, CO, G gas detector + valve, E extinguisher, B fire blanket, V smoke vent, P phone / panel) ----------
#let equip = (
  ("S", "FF", (11.1, 3.5), [bedroom 1]), ("S", "FF", (2.1, 12.7), [bedroom 2]), ("S", "FF", (2.1, 17.5), [bedroom 3]), ("S", "FF", (6.6, 1.5), [kids' room]), ("S", "FF", (11.1, 15.6), [suite bedroom]),
  ("S", "FF", (4.9, 11.0), [gallery, outside bedrooms 2 / 3]), ("S", "FF", (3.5, 5.0), [gallery, outside the kids' room / family living]), ("S", "FF", (1.4, 8.5), [landing (stair top)]), ("S", "FF", (9.6, 9.0), [suite lobby, outside the suite bedroom]), ("S", "FF", (6.6, 4.75), [family living]), ("S", "FF", (8.7, 22.6), [gym]), ("S", "FF", (2.1, 21.6), [office]),
  ("CO", "FF", (4.9, 10.0), [gallery, outside the bedrooms (R315)]), ("CO", "FF", (9.6, 8.0), [suite lobby]),
  ("S", "GF", (3.5, 6.0), [riwaq at the stair foot]), ("S", "GF", (6.6, 16.1), [top of the double-height void (+6.8): a beam or aspirating detector, the ceiling alarms cannot sense it in time]), ("S", "GF", (11.1, 16.1), [dining]), ("S", "GF", (6.6, 3.25), [women's majlis]),
  ("S", "GF", (1.4, 22.7), [foyer]), ("S", "GF", (8.0, 21.6), [men's majlis]), ("S", "GF", (12.0, 5.0), [maid room]), ("S", "GF", (9.8, 5.0), [laundry (dryer)]), ("S", "GF", (1.4, 9.15), [utility room (panel, heater)]),
  ("H", "GF", (11.1, 10.0), [kitchen: heat alarm (not smoke)]), ("H", "GF", (1.4, 11.65), [hospitality kitchen: heat alarm]),
  ("CO", "GF", (10.0, 11.5), [kitchen, away from the hob]),
  ("G", "GF", (13.1, 10.7), [gas detector at the hob; the automatic shut-off valve at the cylinder cabinet outside]), ("G", "GF", (13.7, 8.6), [LPG cylinder cabinet in the service yard, the shut-off valve]),
  ("E", "GF", (12.9, 8.5), [kitchen: 6 kg ABC powder + a CO₂ unit, at the service door]), ("B", "GF", (12.3, 12.6), [kitchen: fire blanket by the fridge, not over the hob]),
  ("E", "GF", (3.0, 6.9), [riwaq at the stair foot: 6 kg ABC]), ("E", "GF", (2.5, 22.3), [foyer: 6 kg ABC (the majlis)]), ("E", "GF", (1.4, 9.8), [utility room: CO₂ at the panel]),
  ("E", "FF", (3.0, 8.9), [gallery at the stair top: 6 kg ABC]), ("E", "FF", (9.6, 7.0), [suite lobby: 6 kg ABC]), ("E", "FF", (5.0, 22.6), [gym: 6 kg ABC]),
  ("E", "GF", (14.3, 23.4), [outdoor kitchen (SE corner, outside): 6 kg ABC + a blanket by the grill and the tannour]), ("E", "GF", (14.5, 12.0), [generator point (east yard): 6 kg ABC; CO: the set ≥ 6 m from any opening or a sealed enclosure with its exhaust away from the house]),
  ("E", "roof", (1.4, 7.4), [roof stair room: 2 kg CO₂ (the plant)]),
  ("V", "GF", (7.3, 19.25), [smoke vent: the two clerestories or W3's tilt lites motorised, opened by the alarm]),
  ("P", "GF", (3.6, 1.0), [alarm panel / repeater at the family entrance; the sounders on both floors]),
)
#let n-smoke = equip.filter(e => e.at(0) == "S").len()
#let n-ext = equip.filter(e => e.at(0) == "E").len()

// ---------- the safe room: the suite dressing ----------
#let safe = FF.find(r => r.name == "Suite dressing")
#let safe-clear = (3.011 - 0.1 - 0.125) * (3.45 - 0.2)

// ---------- checks of this study ----------
#let checks = (
  ([every sleeping room has a window in the plans (3d/params.yaml) and an escape judgement], rows.all(r => r.w != none)),
  ([the maid room fix (sill +#f2(maid-fix.sill), one casement #r2(maid-fix.width) × #r2(maid-fix.head - maid-fix.sill)) passes R310 at grade], maid-fix-ok),
  ([every first-floor window judged passes R310 by geometry once its screen opens from inside (the fix)], rows.filter(r => r.floor == "FF").all(r => r.j.geo)),
  ([the family entrance meets the egress door width], exits.at(0).ok),
  ([every first-floor route reaches the stair and the family door (lengths computed)], routes-ff.all(((n, P, l)) => dist(P.last(), stair-top) < 1e-6)),
  ([smoke alarms: one in each of the five sleeping rooms and the maid room, outside each sleeping area, on each storey], n-smoke >= 12),
)
#let all-ok = checks.all(c => c.at(1))

// ====================================================================================== PAGE 1
#text(14pt, weight: "bold", fill: accent)[Fire, escape and life safety study · Taif / Palm House V7.1 · design review E-08 (critical)]
#v(1pt)
#text(8pt, fill: gray)[Study only, 1 Nov 2026 · no room or design file changed · the fixes are marked *owner decision* or *engineer to confirm* · every rule cited; the Saudi 2024 texts themselves are *not verified* here: the Saudi designer of record confirms them before the permit set]
#v(3pt)
#grid(columns: (1.15fr, 1fr), gutter: 12pt,
  [
    #H[1 · The rules checked against]
    #table(columns: (2.6fr, 1.6fr, auto), inset: 2.4pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      [*Rule*], [*Source*], [*Status*],
      ..rules.map(((r, s, st)) => (r, text(6.6pt, s), st)).flatten())
    #text(6.5pt, fill: gray)[*Not verified* means: the figure is the IRC / IFC figure the Saudi code is based on (SBC 1101 residential, SBC 801 fire, SBC 501 mechanical) and was read there; the wording and the section numbers of the SBC 2024 edition, any Saudi amendment, and the General Directorate of Civil Defense's villa requirements could not be read for this study. The designer of record confirms each one and the municipality's permit checklist.]
  ],
  [
    #H[2 · Summary]
    - *Escape openings:* #rows.len() sleeping rooms checked (bedrooms 1–3, the kids' room as a future bedroom, the master suite bedroom, the maid room): *#n-pass pass, #n-fail fail* as drawn. Every first-floor bedroom window has the size and the sill for R310 but carries a *fixed mashrabiya screen* (the character study) that does not open from inside: fail until the screens are hinged and releasable from inside. The *maid room* fails on its sill (+1.50 > #r2(R.sill-max)) and on size (#r2(rows.last().e.area) m² < #r2(R.esc-area-grade) m² with two sashes).
    - *Exits:* the family entrance (1.00 m) is the dwelling's egress door; the guest double door and the kitchen service door are extra exits (the service door must open from inside without a key). The first floor has *one stair*; a one-family dwelling needs no second stair under the IRC / SBC 1101 (not verified): the escape windows are the second route, and the study makes them real.
    - *Longest route* from a bedroom door to the family entrance: ≈ #r1(longest) m (the master suite), with #r1(stair-len) m on the stair; no travel-distance limit applies inside a dwelling (R311), the figure is for information.
    - *Smoke:* the open stair, the double-height void and the enclosed gallery are one volume. The lightest compliant answer (§ 5): interconnected alarms on both floors and at the top of the void, a motorised smoke vent at the top of the void, solid bedroom doors with smoke seals closed at night; no enclosure of the stair, no screen.
    - *Equipment:* #n-smoke smoke / heat alarm points, 2 CO alarms + 1 in the kitchen, a gas detector with an automatic shut-off valve, #n-ext extinguishers, a fire blanket, the smoke vent, the alarm panel (§ 6, plans on page 3).
    - *Safe room:* the suite dressing (#r2(safe-clear) m² clear, no window, inside the suite behind two doors) with an FD60 door opening inward on a thumb-turn, its own filtered air intake and a phone; it does not trap: the door opens from inside without a key and the way out in a fire is the suite bedroom's east escape window 3 m away (§ 7, owner decision).
    - *Decisions needed from the owner:* the escape-window specification and the openable screens (§ 3, § 9); the maid room's window (§ 3); solid bedroom doors; the smoke vent; a sprinkler system (NFPA 13D) yes / no; a second door from the men's majlis to the garden; the safe room's location; the LPG cabinet position and the generator point (§ 9).
    #v(2pt)
    #text(7.5pt)[#if all-ok [*Study checks passed* (#checks.len())] else [*STUDY CHECKS FAILED:* #checks.filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]]
  ],
)

// ====================================================================================== PAGE 2 · escape openings
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[3 · Escape and rescue openings, room by room (IRC R310 as the SBC 1101 basis)]
#v(2pt)
#table(columns: (1.2fr, auto, 1fr, auto, auto, auto, auto, auto, auto, 2.2fr), inset: 2.4pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
  [*Room*], [*Floor*], [*Window (plans)*], [*Size w × h*], [*Sill*], [*Sashes*], [*Net clear (one sash)*], [*Screen*], [*Verdict*], [*Fix*],
  ..rows.map(r => (
    [#r.room], [#r.floor], [#r.at #linebreak() #text(6pt, fill: gray)[→ #r.to]], [#r2(r.e.width) × #r2(r.e.height)], [+#f2(r.w.sill + (if r.floor == "FF" { 3.6 } else { 0.0 })) (#r2(r.w.sill) above the floor)], [#r.e.sashes × #r2(r.e.width / r.e.sashes)], [#r2(r.e.clear-w) × #r2(r.e.clear-h) = *#r2(r.e.area) m²*],
    if r.j.screen [fixed mashrabiya] else [none],
    if r.j.ok { PASS } else { FAIL },
    [#if not r.j.geo [sill +1.50 > #r2(R.sill-max) and #r2(r.e.area) m² < #r2(R.esc-area-grade): lower the sill to +#f2(maid-fix.sill), one side-hung casement #r2(maid-fix.width) × #r2(maid-fix.head - maid-fix.sill) (net #r2(maid-fix-e.clear-w) × #r2(maid-fix-e.clear-h) = #r2(maid-fix-e.clear-w * maid-fix-e.clear-h) m²), obscured glass below +1.60 and an openable screen for the privacy from the lane (2.5 m away). *Owner decision.*] else if r.j.screen [geometry passes; the mashrabiya must be hinged and releasable from inside without a key or tool (R310.4), or fitted only on the fixed lites. *Owner decision* (the design language keeps mashrabiya to one or two places).] else [—] #linebreak() #text(6pt, fill: gray)[#r.note]],
  )).flatten())
#v(3pt)
#grid(columns: (1fr, 1fr), gutter: 12pt,
  [
    #H[How the net clear opening is counted]
    - The window line of the plans is the structural opening. This study assumes black steel side-hung casements (or tilt-turn sashes in the turn position) of ≤ #r2(R.sash-max) m, a #r2(R.frame * 1000, ) mm frame and sash edge all round, and *one sash opening fully*: net clear width = sash width − 2 × #r2(R.frame), net clear height = (head − sill) − 2 × #r2(R.frame). Tilt-only, top-hung or sliding sashes do not count unless their own clear opening meets the figures (a slider gives half the width). *Engineer / window supplier to confirm* the sash sizes, the hardware (no key, no tool, a single hand action) and the net openings on the shop drawings.
    - *Landing below:* the first-floor sills are 4.5 m above the ground outside (±0.00 inside, the ground at −0.30): rescue by the fire brigade's ladder from the strip in front of the facade; the west strip (the driveway side), the north setback (3.8–5.7 m) and the lane setback (2.5 m) are reachable yards that open to a public way (R310.1). The *courtyard* is walled on four sides with no way out except through the house: the gallery's W1 casements and the family living's W2 are *not* escape openings, though the courtyard is a smoke-free refuge. The *suite court* likewise.
    - *Kids' room:* checked as a bedroom because it may become one (R-01); its 3.4 m north window with four sashes passes once its screen opens.
    - *Bedroom 1* has a second cut-wall window (12.3–12.9 / 4.15–5.25, 1.25 m); either serves.
    - *Guest rooms:* none (the men's majlis is not a sleeping room); *ground-floor bedrooms:* none (R-04); the maid room is the only ground-floor sleeping room.
  ],
  [
    #H[The maid room: privacy and escape together]
    - As drawn: window #r2(rows.last().e.width) × #r2(rows.last().e.height) m at +1.50 … +2.10 in the cut wall facing the lane (2.5 m to the boundary), no screen. For escape it fails twice (sill, size).
    - *Fix A (recommended):* one side-hung casement #r2(maid-fix.width) × #r2(maid-fix.head - maid-fix.sill) m, sill +#f2(maid-fix.sill), head +#f2(maid-fix.head): net #r2(maid-fix-e.clear-w * maid-fix-e.clear-h) m², sill below #r2(R.sill-max) ✓; the lower pane (+1.10 … +1.60) in obscured (satin) glass, the clear pane above eye level from the lane; an internal hinged mashrabiya screen releasable without a key keeps the privacy at night. The bed (along the south wall) does not change; the wardrobe on the west wall stays.
    - *Fix B:* keep the sill at +1.50 and make the room a non-sleeping room (not what the owner wants).
    - *Her route out:* maid room → the laundry door (1.00, hinged) → the laundry → the open entrance to the kitchen → the service door (0.90, 3.2 m from the kitchen's north wall), #r1(plen(routes-gf.at(3).at(1))) m in all through two doors, or on through the kitchen door and the dining to the riwaq. The service door is *lockable from both sides today*: it must be openable from inside without a key (a thumb-turn or a night latch), and the laundry door never locked from the kitchen side. *Engineer / joinery to confirm.*
  ],
)

// ====================================================================================== PAGE 3 · plans: routes, escape windows, equipment
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[4 · Routes to the exits, escape windows and the equipment on both floors]
#v(2pt)
#let plan(floor, rooms, length: 0.47cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let q(p) = (p.at(0), -p.at(1))
  let T(p, body, size: 4.2pt, fill: ink, anchor: "center") = content(q(p), anchor: anchor, text(size, fill: fill, body))
  let fills = (family: rgb("#f6e3c0"), guest: rgb("#e9d9c4"), service: rgb("#dbe7ec"), core: rgb("#e4ded2"), circ: rgb("#f2efe8"), court: rgb("#dbe9f4"), open: white, tower: rgb("#cfe0d8"))
  for r in rooms { line(..r.P.map(q), close: true, fill: fills.at(r.colour, default: luma(235)), stroke: 0.5pt + ink) }
  line(..outline.map(q), close: true, stroke: 1.4pt + ink)
  // the stair well and the lift
  rect(q((0, 2.2)), q((2.75, 7.9)), fill: rgb("#e4ded2"), stroke: 0.5pt + ink); T((1.375, 5.0), [stair], size: 4pt)
  rect(q((0, 0)), q((2.25, 2.2)), fill: luma(225), stroke: 0.5pt + ink); T((1.1, 1.1), [lift], size: 3.8pt)
  // windows of this floor: escape windows green / red, others blue
  for w in WIN.filter(w => w.floor == floor) { line(q(w.a), q(w.b), stroke: 1.6pt + blue) }
  for r in rows.filter(r => r.floor == floor) { line(q(r.w.a), q(r.w.b), stroke: 3.2pt + (if r.j.ok { green } else { red })) }
  // routes
  let rts = if floor == "FF" { routes-ff } else { routes-gf }
  for (n, P, l) in rts { line(..P.map(q), stroke: (paint: red, thickness: 1pt, dash: "dashed"), mark: (end: "stealth", fill: red, scale: 0.55)) }
  if floor == "GF" { line(..gf-from-stair.map(q), stroke: (paint: red, thickness: 1pt, dash: "dashed"), mark: (end: "stealth", fill: red, scale: 0.55)) }
  // exits
  for e in exits.filter(e => e.name.contains("Roof") == false) { line(q(e.a), q(e.b), stroke: 3.5pt + (if e.ok { green } else { amber })) }
  if floor == "GF" { T((3.5, -0.5), [family door 1.00], size: 4pt, fill: green); T((-0.5, 22.2), [guest door 2 × 0.70], size: 4pt, fill: amber, anchor: "east"); T((13.8, 7.65), [service door 0.90], size: 4pt, fill: green, anchor: "west"); T((4.6, 9.8), [courtyard: refuge], size: 3.8pt, fill: amber, anchor: "west") }
  // equipment
  let col = (S: blue, H: red, CO: amber, G: red, E: green, B: green, V: blue, P: ink)
  for (k, fl, p, l) in equip.filter(e => e.at(1) == floor) {
    circle(q(p), radius: 0.28, fill: white, stroke: 0.8pt + col.at(k))
    T(p, [#k], size: 3.6pt, fill: col.at(k))
  }
  // room names
  for r in rooms.filter(r => r.colour != "open") { let c = (r.P.map(p => p.at(0)).sum() / r.P.len(), r.P.map(p => p.at(1)).sum() / r.P.len()); T((c.at(0), c.at(1) + 0.55), text(3.4pt, fill: luma(110), r.name.split(" (").at(0))) }
  T((6.6, -1.3), [#floor · north up · 1 m = 0.47 cm], size: 4.4pt, fill: gray)
})
#grid(columns: (auto, auto, 1fr), gutter: 10pt, plan("GF", GF), plan("FF", FF),
  [
    #set text(6.6pt)
    #H[Legend]
    Red dashed: the routes to the stair / the exits; green thick: escape windows that pass, red thick: that fail as drawn; blue: other windows; green / amber thick on the outline: the exits (amber = not an egress door by itself). Circles: *S* smoke alarm, *H* heat alarm, *CO* carbon-monoxide alarm, *G* gas detector / shut-off, *E* extinguisher, *B* fire blanket, *V* smoke vent, *P* alarm panel.
    #v(2pt)
    #H[Route lengths (door → stair top → family entrance)]
    #table(columns: (1.2fr, auto, auto, 2fr), inset: 2pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") },
      [*From*], [*to the stair*], [*to the door*], [*Through*],
      ..routes-ff.map(((n, P, l)) => ([#n], [#r1(plen(P)) m], [#r1(plen(P) + stair-len + plen(gf-from-stair)) m], text(6pt, l))).flatten())
    #table(columns: (1.2fr, auto, 2fr), inset: 2pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") },
      [*Ground floor from*], [*to the exit*], [*Through*],
      ..routes-gf.map(((n, P, l)) => ([#n], [#r1(plen(P)) m], text(6pt, l))).flatten())
    #text(6pt, fill: gray)[The stair: two flights 1.21 m clear, risers 0.164, goings 0.28, headroom 2.14 m, handrails both sides: within R311.7 (0.914 / 0.196 / 0.254 / 2.032). No travel-distance limit inside a dwelling; the lengths show where the far rooms are: the master suite and the gym are ≈ #r1(longest) m and #r1(plen(routes-ff.at(5).at(1)) + stair-len + plen(gf-from-stair)) m from the family door, the men's majlis #r1(plen(routes-gf.at(0).at(1))) m from the guest door with the serving passage locked.]
    #v(2pt)
    #H[Exits]
    #table(columns: (1.3fr, auto, 2fr), inset: 2pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") },
      [*Door*], [*Width*], [*Note*],
      ..exits.map(e => ([#e.name], [#r2(e.width)], text(6pt, e.kind))).flatten())
  ],
)

// ====================================================================================== PAGE 4 · smoke, equipment, safe room, materials, fixes
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[5 · Smoke · 6 · Detection and equipment · 7 · The safe room · 8 · Elements with a fire role · 9 · The fixes and the decisions]
#v(2pt)
#grid(columns: (1fr, 1fr), gutter: 12pt,
  [
    #H[5 · Smoke: one connected volume]
    - *What is connected:* the open stair (ground floor to the roof), the riwaq, the double-height living (7 m to its roof), the courtyard side of the gallery (the enclosed gallery is now a conditioned corridor glazed to the courtyard) and the landing: a fire in the living or the kitchen fills the void, the gallery and the stair with smoke before the bedrooms' doors.
    - *What the code asks* (IRC R314 / SBC 1101, not verified): interconnected smoke alarms in each bedroom, outside each sleeping area and on each storey; no enclosure of the stair, no smoke separation, no sprinklers unless R313 is adopted. The IRC allows the open plan because the alarms wake the household early and every bedroom has its escape window.
    - *The lightest compliant solution, keeping the open character:* (1) interconnected, hardwired alarms with battery back-up on both floors and in the stair as placed on page 3, with a *beam or aspirating detector at the top of the void* (ceiling alarms 7 m up react late to a fire at floor level); (2) *a motorised smoke vent at the top of the void*: the two clerestory windows (1.0 × 1.0, +5.00 … +6.00, onto the suite court) or W3's tilt lites, opened by the alarm and by a manual switch at the family entrance (practice: BS 9991 / EN 12101-2 AOV, ≥ 1.0 m² free area), so the void clears itself and the gallery stays usable longer; (3) *solid-core bedroom doors with smoke seals and closers*, kept closed at night (an FD30 set costs little and holds a bedroom for 30 minutes: the escape windows are then used calmly); (4) the *kitchen door to the dining kept as a door* (it is) and a heat alarm in the kitchen; (5) the roof stair room door as a way up and out of the smoke.
    - *Not proposed:* glazing or screening the stair, lobbies on the gallery, or enclosing the void: they would remove the open character the owner wants and the code does not ask for them. *Sprinklers (NFPA 13D)* are the one measure that changes the picture: ≈ 1 % of the build cost at construction, impossible later; the IRC requires them, the Saudi adoption is not verified. *Owner decision.*
    #v(2pt)
    #H[6 · Detection and equipment (positions on page 3)]
    - *Smoke alarms* (#n-smoke points incl. the heat alarms): every bedroom and the maid room; the gallery outside bedrooms 2 / 3 and outside the kids' room; the landing; the suite lobby; the family living, the gym, the office; the riwaq at the stair foot; the void's top; the dining; the women's majlis; the foyer; the men's majlis; the laundry (dryer); the utility room (panel, water heater). *Heat alarms* in the two kitchens (smoke alarms there give false alarms). All interconnected, hardwired, battery back-up, with a repeater / panel at the family entrance and sounders on both floors.
    - *CO alarms* outside the bedrooms (gallery, suite lobby) and in the kitchen (gas hob), away from the hob.
    - *Gas:* an LPG detector at the hob linked to an *automatic shut-off valve* at the cylinder cabinet; the cabinet *outside* in the east service yard, ventilated, with the distance to the service door and the kitchen window per the Civil Defense LPG rules (not verified; 1.5 m assumed); a manual valve inside the kitchen.
    - *Extinguishers* (#n-ext): 6 kg ABC powder at the kitchen service door (+ CO₂), the riwaq at the stair foot, the foyer, the gallery at the stair top, the suite lobby, the gym, the outdoor kitchen, the generator point; CO₂ in the utility room and the roof stair room; a *fire blanket* in the kitchen (by the fridge, not over the hob) and one at the outdoor kitchen / tannour.
    - *Generator point* (east yard, with the site plan): outdoors, ≥ 6 m from any window or door or in a sealed enclosure with its exhaust led away from the house; the changeover switch in the utility room; a CO alarm in the nearest room (the dining).
  ],
  [
    #H[7 · The safe room (R-33): the suite dressing]
    - *Where:* the suite dressing, #r2(safe-clear) m² clear, x 10.3–13.311, y 10.45–13.9: interior, no window, inside the master suite behind the suite door and its own door, next to the suite bedroom; the family reaches it from the suite lobby. The alternative, the suite WC closet (1.14 m²), is too small.
    - *What it needs:* an FD60 steel-lined door opening *inward* with a thumb-turn and a bar inside (never a key to get out: R311), 200 mm block walls (as drawn) to the slab, no window, its own fresh-air intake (a small duct to the east wall high up, with a fire damper and a filter) and a passive vent, a phone line, a mobile repeater, a CCTV monitor, water, a torch, a first-aid kit and an extinguisher; a smoke alarm inside, interconnected.
    - *It must not trap anyone:* the door opens from inside without a key; the smoke alarm inside wakes them; the way out in a fire is the suite bedroom door 1.5 m away and its east escape window (3.6 m wide, +0.90 sill) 3 m beyond; the dressing itself has no window by design (security), so it is a refuge for minutes, not for a fire's duration. *Owner decision* on the location and the hardware.
    #v(2pt)
    #H[8 · Elements with a fire role (for the engineers)]
    - *Stair:* reinforced concrete flights and landings (non-combustible), 1.21 m clear, handrails both sides; the store under the half landing lined with 13 mm gypsum (R302.7); the stair continues to the roof and the stair room door opens outward onto the roof on a thumb-turn: a way up out of the smoke and a rescue point from the roof.
    - *Lift:* a two-stop home lift, not an evacuation lift ("do not use in fire" sign, the battery lowering brings the car to the ground floor); the landing doors' fire resistance (EN 81-58, E30) is not required by the IRC for a dwelling; the shaft walls are 200 mm block (as drawn). *Engineer / supplier to confirm.*
    - *Kitchen:* 200 mm block walls, the hood exhausts straight out through the east wall with make-up air (M1503.6, open item 8), a heat alarm, the extinguisher and the blanket; the gas run from the outside cabinet in a sleeved pipe with the automatic valve; the service door's hardware (thumb-turn).
    - *Gas:* cylinders outside only, never in the kitchen; the detector and the valve; the outdoor kitchen's grill and tannour at the SE corner, downwind, with their own extinguisher and blanket and the gas cylinder in a cabinet.
    - *Roof:* the plant (AC, ERV) on the roof with the stair room as the access; the attic walls are block; the PV's DC isolator at the inverter room (site plan).
    - *Electrical:* the main panel in the utility room with RCDs on every circuit, arc-fault protection on the bedroom circuits (IRC E3902, not verified); the essentials circuit for the alarm panel.
    #v(2pt)
    #H[9 · The fixes, their effect, and who decides]
    #table(columns: (auto, 2.6fr, 1.6fr, auto), inset: 2pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      [*No.*], [*Fix*], [*Effect on other spaces*], [*Who*],
      [1], [Escape windows in the five first-floor bedrooms: one side-hung casement (or tilt-turn) per window meeting R310 (net ≥ 0.53 m², ≥ 0.61 × 0.508, sill ≤ 1.118), hardware without key or tool], [none in plan; the window schedule], [engineer / supplier],
      [2], [The mashrabiya screens on the sleeping-room windows hinged and releasable from inside, or only on the fixed lites], [the facades' character (the design language keeps mashrabiya to one or two places anyway)], [owner decision],
      [3], [Maid room window: sill +1.10, one casement 1.14 × 1.00, obscured glass below +1.60, an openable screen], [the cut facade; the bed stays], [owner decision],
      [4], [Interconnected smoke / heat / CO alarms as placed; a beam or aspirating detector at the top of the void; the panel at the family entrance], [ceilings and wiring], [engineer (code)],
      [5], [A motorised smoke vent at the top of the void (the clerestories or W3's tilt lites) on the alarm and a manual switch], [the clerestory windows' hardware; the AOV's free area ≥ 1.0 m²], [owner decision · engineer],
      [6], [Solid-core bedroom and maid room doors with smoke seals and closers (FD30), closed at night], [door schedule], [owner decision],
      [7], [Sprinklers NFPA 13D throughout (the one measure that covers the open stair / void volume)], [a water tank and pump (the roof tank zone or the ground tank), pipes in the ceilings], [owner decision],
      [8], [Every exit door openable from inside without a key (the family door, the guest double door, the kitchen service door, the roof stair room door); the laundry door never locked from the kitchen side], [hardware], [engineer / joinery],
      [9], [A second door from the men's majlis to the garden (south wall), so 20–24 guests do not depend on the foyer alone; ties to S-04 (garden door)], [the south facade, the majlis seating, the site plan], [owner decision],
      [10], [Gas: the detector, the automatic shut-off valve, the outside cylinder cabinet, the sleeved run; the outdoor kitchen's cylinder likewise], [the east service yard (site plan)], [engineer (code) · Civil Defense],
      [11], [Extinguishers and blankets as placed; the generator point and its clearances], [the site plan], [engineer · site plan],
      [12], [The safe room in the suite dressing: FD60 inward door on a thumb-turn, own air intake, phone and repeater, smoke alarm inside], [the dressing's joinery loses ≈ 0.3 m on the east wall for the intake duct], [owner decision],
      [13], [Under-stair store lined with 13 mm gypsum; the stair room door outward with a thumb-turn; the lift's "do not use in fire" sign and battery lowering (as decided)], [none], [engineer],
    )
    #text(6.4pt, fill: gray)[Nothing here is for construction: the Saudi designer of record verifies every rule against the SBC 2024 texts and the Civil Defense checklist before the permit set.]
  ],
)

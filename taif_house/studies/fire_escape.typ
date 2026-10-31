// fire_escape.typ · Taif / Palm House V7.1 · FIRE SAFETY AT A FAMILY-HOME LEVEL: early warning and safe exit (owner decision, 1 Nov 2026)
// The design review's critical item E-08, first studied on 1 Nov 2026 (13 fixes proposed); the owner chose a home-level strategy and this file
// now records the adopted scheme, verifies its points (§ 5) and adds the family escape plan (§ 6). Rules are cited; the Saudi 2024 texts are
// marked "not verified" where their wording could not be read: the designer of record confirms them before the permit set.
// Reads: data/rooms_gf.csv, data/rooms_ff.csv (the plans), 3d/params.yaml (every window with its sill and head), 3d/character.yaml (the
// mashrabiya list), studies/ff_family.typ and ff_suite.typ (the escape windows), design_gf.typ and design_ff.typ (the alarm and extinguisher marks).
// CSV frame: x east, y south, wall centre lines; levels above the finished ground floor ±0.00.
#import "@preview/cetz:0.4.2"
#import "ff_family.typ": escape-windows as fam-esc
#import "ff_suite.typ": escape-windows as suite-esc
#import "../design_gf.typ": safety as gf-safety
#import "../design_ff.typ": safety as ff-safety
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
#let OK = text(fill: green, weight: "bold")[OK]
#let PROBLEM = text(fill: red, weight: "bold")[problem]
#let NV = text(fill: amber, weight: "bold")[not verified]
#let PASS = text(fill: green, weight: "bold")[pass]
#let FAIL = text(fill: red, weight: "bold")[fail]

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
#let same(p, q) = calc.abs(p.at(0) - q.at(0)) < 1e-6 and calc.abs(p.at(1) - q.at(1)) < 1e-6
#let has-screen(floor, a, b) = chr.mashrabiya.windows.any(w => { let v = w.at.split(" ").map(float); w.floor == floor and same((v.at(0), v.at(1)), a) and same((v.at(2), v.at(3)), b) })
#let win(floor, a, b) = {   // the window's heights: 3d/params.yaml if listed, else the default sill / head
  let hit = WIN.find(w => w.floor == floor and same(w.a, a) and same(w.b, b))
  if hit != none { hit } else { (floor: floor, a: a, b: b, sill: params.openings.window.sill, head: params.openings.window.head, note: "default window (params.yaml)") }
}
#let outline = ((0, 0), (10.051, 0), (13.311, 6.0), (13.311, 24.0), (0, 24.0))

// ---------- rules (figures read in the IRC / NFPA texts the SBC is based on; the SBC 2024 wording itself: not verified) ----------
#let R = (esc-area: 0.53, esc-area-grade: 0.465, esc-h: 0.61, esc-w: 0.508, sill-max: 1.118, door-w: 0.813, sash-max: 1.2, frame: 0.05,
          cook-dist: 3.0, bath-dist: 0.9, wall-gap: 0.1, pillow-dba: 75)
#let rules = (
  ([Escape and rescue opening in every sleeping room: net clear ≥ #r2(R.esc-area) m² (#r2(R.esc-area-grade) at grade), ≥ #r2(R.esc-h) high × #r2(R.esc-w) wide, sill ≤ #r2(R.sill-max); operable from inside without keys, tools or special knowledge; grilles and screens only if releasable from inside], [IRC 2021 R310.1–R310.4 · SBC 1101 R310], NV),
  ([One egress door ≥ #r2(R.door-w) m clear, openable from inside without a key; egress from every part of the dwelling], [IRC 2021 R311.1–R311.2 · SBC 1101 R311], NV),
  ([Smoke alarms in each sleeping room, outside each sleeping area, on every storey; interconnected; mains with battery back-up (UL 217); ≥ #r1(R.cook-dist) m from a cooking appliance (photoelectric), ≥ #r2(R.bath-dist) m from a bathroom door with a shower], [IRC 2021 R314.3–R314.6 · NFPA 72-2022 29.8.3, 29.11 · SBC 1101 R314], NV),
  ([Ceiling-mounted alarms ≥ #r2(R.wall-gap) m from any wall; wall-mounted 0.10–0.30 m below the ceiling; not in dead air], [NFPA 72-2022 29.11.3 · manufacturer's instructions], NV),
  ([Alarm audibility ≥ #R.pillow-dba dBA at the pillow in every sleeping room (an alarm inside the room meets it)], [NFPA 72-2022 29.5.2 (practice; the IRC asks only for interconnection)], NV),
  ([Carbon-monoxide alarm outside the sleeping areas where a fuel-fired appliance is installed (the gas hob)], [IRC 2021 R315 · SBC 1101 R315], NV),
  ([LP-gas cylinders outside in a ventilated cabinet; extinguishers; a gas shut-off], [SBC 801 (from the IFC) · Civil Defense villa rules], NV),
)

// ---------- the adopted scheme (owner, 1 Nov 2026) ----------
#let adopted = (
  ([*Early warning:* mains-powered (hardwired) smoke alarms with a built-in sealed 10-year lithium battery back-up, interconnected by wire, working without internet, all from one compatible range; fed from the essentials circuit if the electrical designer agrees (the battery back-up remains essential in a power cut; the generator is not needed for the alarms). A heat alarm of the same range in the kitchen; a gas detector near the hob with an automatic shut-off valve if the gas installer offers it; one CO alarm on the gas / generator side. Maintenance: monthly test, cleaning per the manufacturer, every alarm replaced after ≈ 10 years.]),
  ([*Safe exit:* alarm → the stair → one of the three ground-floor exits (the family entrance, the kitchen service door, the guest entrance through the foyer); every exit door opens from inside without a key (thumb-turn). Backup if the open stair fills with smoke: the master suite uses the suite court (open to the sky) as a fresh-air refuge; the other bedrooms open their escape casements for air, call for help and wait for rescue from outside.]),
  ([*Escape windows:* the master bedroom, bedrooms 1–3 and the kids' room have hinged glass casements opening fully from inside, with no grilles, bars or fixed mashrabiya (the five screens removed; mashrabiya only on non-escape windows). Child restrictors with an adult release may be added after occupation (note only). The maid room: one casement ≈ 1.14 × 1.00 m, sill +1.10, obscured glass below +1.60, no screen.]),
  ([*Living ventilation:* the high windows of the double-height living open outward (top-hung, rain-safe): W3's lower lites and the two south clerestories, worked from the floor by a wall switch with small chain actuators (or a pole): a normal ventilation feature, useful to clear smoke. Bedroom doors: normal solid timber doors.]),
  ([*Equipment:* a fire blanket and an extinguisher in the kitchen; one extinguisher on each floor near the stair.]),
)
#let not-adopted = ([sprinklers (NFPA 13D)], [fire-rated doors with closers], [a central alarm panel], [beam / aspirating detectors in the void], [a second door from the men's majlis], [a safe room (security = CCTV, alarm and video intercom; R-33 updated)])

// ---------- the sleeping rooms and their escape windows ----------
#let esc-list = fam-esc.map(((n, a, b)) => (room: n, floor: "FF", a: a, b: b)) + suite-esc.map(((n, a, b)) => (room: n, floor: "FF", a: a, b: b)) + ((room: "Maid room", floor: "GF", a: (12.17, 3.9), b: (12.714, 4.9)),)
#let outside = ("Bedroom 1": [the lane setback strip (2.5 m to the boundary) → the lane; a ladder stands in the strip, a vehicle on the lane], "Bedroom 2": [the west strip (0.785 m to the M line) + the driveway beyond it → the street; a ladder from the driveway (base ≈ 1.2 m for a 4.8 m rise), a vehicle on the driveway: confirm the driveway stays open (site plan)], "Bedroom 3": [as bedroom 2], "Kids' room (a bedroom later)": [the north setback (3.8–5.7 m) → the north street and the parking: ladder and vehicle], "Suite bedroom": [the east strip (3.6–9 m) → the service yard: a ladder in the strip, a vehicle from the north (site plan)], "Maid room": [the lane setback strip at ground level, 2.5 m wide, open at both ends (to the north front and the east yard): the sill 1.40 m above the outside ground, no trapped corner])
#let escape(w) = {
  let L = dist(w.a, w.b); let h = w.head - w.sill
  let n = calc.ceil(L / R.sash-max - 1e-9)                          // side-hung casements ≤ 1.0 m; one sash opens fully with one movement
  let cw = L / n - 2 * R.frame; let ch = h - 2 * R.frame
  (width: L, height: h, sashes: n, clear-w: cw, clear-h: ch, area: cw * ch)
}
#let rows = esc-list.map(r => {
  let w = win(r.floor, r.a, r.b); let e = escape(w)
  let need = if r.floor == "GF" { R.esc-area-grade } else { R.esc-area }
  let screen = has-screen(r.floor, r.a, r.b)
  let geo = e.area >= need and e.clear-w >= R.esc-w and e.clear-h >= R.esc-h and w.sill <= R.sill-max
  (room: r.room, floor: r.floor, w: w, e: e, geo: geo, screen: screen, ok: geo and not screen, out: outside.at(r.room, default: []))
})
#let n-pass = rows.filter(r => r.ok).len()
#let n-fail = rows.len() - n-pass

// ---------- exits and routes ----------
#let exits = (
  (name: "Family entrance (north wall)", a: (3.0, 0), b: (4.0, 0), width: 1.0, swing: "inward, single leaf", clear: 1.0 - 2 * R.frame, egress: true),
  (name: "Kitchen service door (east wall)", a: (13.311, 7.2), b: (13.311, 8.1), width: 0.9, swing: "outward to the yard, single leaf", clear: 0.9 - 2 * R.frame, egress: false),
  (name: "Guest entrance (west wall)", a: (0, 21.5), b: (0, 22.9), width: 1.4, swing: "inward, two 0.70 leaves", clear: 1.4 - 2 * R.frame, egress: false),
)
#let stair-top = (2.0, 7.6)
#let stair-len = 2 * calc.sqrt(2.8 * 2.8 + 1.8 * 1.8) + 1.25
#let gf-from-stair = ((0.75, 6.8), (3.5, 6.8), (3.5, 0.0))
#let routes-ff = (
  ("Master suite bedroom", ((9.5, 11.9), (9.5, 5.9), (4.25, 3.8), (3.5, 3.8), (3.5, 8.5), (2.0, 8.5), stair-top), [suite lobby → family link → family living → gallery → landing · refuge: the suite court]),
  ("Bedroom 1", ((9.55, 5.3), (9.55, 5.9), (4.25, 3.8), (3.5, 3.8), (3.5, 8.5), (2.0, 8.5), stair-top), [family link → family living → gallery → landing · refuge: its cut-wall window]),
  ("Kids' room", ((4.25, 2.4), (3.5, 2.4), (3.5, 8.5), (2.0, 8.5), stair-top), [gallery → landing · refuge: its north window]),
  ("Bedroom 2", ((4.25, 11.6), (5.0, 11.6), (5.0, 8.5), (2.0, 8.5), stair-top), [gallery on the projection → landing · refuge: its west window]),
  ("Bedroom 3", ((4.25, 15.7), (5.0, 15.7), (5.0, 8.5), (2.0, 8.5), stair-top), [gallery on the projection → landing · refuge: its west window]),
)
#let routes-gf = (
  ("Maid room", ((12.0, 5.5), (10.65, 3.4), (10.1, 3.4), (10.1, 7.0), (12.5, 7.65), (13.311, 7.65)), [laundry → kitchen → service door · refuge: her window]),
  ("Living", ((6.6, 16.5), (4.25, 13.8), (3.5, 13.8), (3.5, 0.0)), [entrance arch → riwaq → family door]),
  ("Men's majlis", ((12.5, 21.6), (3.0, 22.6), (2.75, 23.0), (0.0, 22.2)), [foyer → guest door]),
)

// ---------- the alarms and the equipment (from design_gf.typ / design_ff.typ `safety`) ----------
#let kind(l) = { let t = repr(l); if t.contains("CO") { "CO" } else if t.contains("[S") { "S" } else if t.contains("[H") { "H" } else if t.contains("[G") { "G" } else if t.contains("[E") { "E" } else { "B" } }
#let gf-items = gf-safety.map(((p, l)) => (floor: "GF", p: p, l: l, k: kind(l)))
#let ff-items = ff-safety.map(((p, l)) => (floor: "FF", p: p, l: l, k: kind(l)))
#let items = gf-items + ff-items
#let smoke = items.filter(i => i.k == "S")
#let n-smoke = smoke.len()
#let n-ext = items.filter(i => i.k == "E").len()
// the checks of the alarm positions: distance to the hob (photoelectric alarms ≥ 3.0 m), to the shower bathrooms' doors (≥ 0.9 m), inside every bedroom
#let hob = (13.1, 10.7)
#let bath-doors = (("family bath", (4.25, 9.8), "FF"), ("bedroom 3 bath", (2.2, 15.5), "FF"), ("suite bath", (10.3, 7.15), "FF"), ("maid bath", (11.065, 2.8), "GF"))
#let near-hob = smoke.filter(i => i.floor == "GF").map(i => (i, dist(i.p, hob)))
#let near-bath = smoke.map(i => (i, calc.min(..bath-doors.filter(b => b.at(2) == i.floor).map(b => dist(i.p, b.at(1))))))
#let hob-ok = near-hob.all(((i, d)) => d >= R.cook-dist)
#let bath-ok = near-bath.all(((i, d)) => d >= R.bath-dist)
#let bedrooms-ff = ("Bedroom 1", "Bedroom 2", "Bedroom 3", "Kids' room (study + gaming)", "Suite bedroom")
#let inside(p, P) = {   // ray casting
  let n = P.len(); let c = false
  for i in range(n) { let a = P.at(i); let b = P.at(calc.rem(i + 1, n)); if ((a.at(1) > p.at(1)) != (b.at(1) > p.at(1))) and (p.at(0) < (b.at(0) - a.at(0)) * (p.at(1) - a.at(1)) / (b.at(1) - a.at(1)) + a.at(0)) { c = not c } }
  c
}
#let room-has-alarm(rooms, name, floor) = { let r = rooms.find(r => r.name == name); smoke.any(i => i.floor == floor and inside(i.p, r.P)) }
#let bed-ok = bedrooms-ff.all(n => room-has-alarm(FF, n, "FF")) and room-has-alarm(GF, "Maid room", "GF")

// ---------- checks of this study ----------
#let checks = (
  ([every sleeping room's escape window passes R310 as now drawn (no screen; the maid window at +1.10)], rows.all(r => r.ok)),
  ([a smoke alarm inside every bedroom and the maid room], bed-ok),
  ([every ground-floor smoke alarm ≥ #r1(R.cook-dist) m from the hob], hob-ok),
  ([every smoke alarm ≥ #r2(R.bath-dist) m from a shower bathroom's door], bath-ok),
  ([an extinguisher on each floor at the stair and one in the kitchen], n-ext >= 3),
  ([the family entrance is the egress door (≥ #r2(R.door-w) clear)], exits.at(0).clear >= R.door-w),
)
#let all-ok = checks.all(c => c.at(1))

// ====================================================================================== PAGE 1 · the scheme
#text(14pt, weight: "bold", fill: accent)[Fire safety for a family home · early warning and safe exit · Taif / Palm House V7.1]
#v(1pt)
#text(8pt, fill: gray)[Owner decision 1 Nov 2026 (design review E-08, critical) · the adopted scheme, its verification (§ 5) and the family escape plan (§ 6) · the rules cited; the Saudi 2024 texts are *not verified* here: the designer of record confirms them before the permit set]
#v(3pt)
#grid(columns: (1.2fr, 1fr), gutter: 12pt,
  [
    #H[1 · The strategy, as adopted]
    #for a in adopted [- #a]
    #v(2pt)
    #H[4 · Not adopted (reason: home-level strategy, early warning and safe exit)]
    #not-adopted.join([ · ]). The gas cabinet and the generator point come with the site plan.
    #v(2pt)
    #H[Summary of the verification (§ 5)]
    - *Escape windows:* #rows.len() sleeping rooms, *#n-pass pass, #n-fail fail* with the screens removed and the maid window at +1.10 (table, page 2).
    - *Alarms:* #n-smoke smoke alarms + 1 heat alarm + 1 CO alarm + the gas detector, placed on both plans (page 3); one inside every bedroom and the maid room #if bed-ok { OK } else { PROBLEM }; the ground-floor alarms #if hob-ok [≥ #r1(R.cook-dist) m from the hob #OK] else [too close to the hob #PROBLEM]; #if bath-ok [all ≥ #r2(R.bath-dist) m from the shower bathrooms' doors #OK] else [one closer than #r2(R.bath-dist) m to a bathroom door #PROBLEM]; audibility: an alarm inside each bedroom meets the 75 dBA-at-the-pillow practice, to be tested on site (#NV until tested).
    - *Kitchen:* the dining door is a solid door; the kitchen walls are 200 mm block to the slab; but the *kitchen ↔ laundry entrance has no door*, so smoke reaches the laundry and the maid room's door: #PROBLEM → proposal P1 (page 4).
    - *Maid window:* net #r2(rows.last().e.clear-w) × #r2(rows.last().e.clear-h) = #r2(rows.last().e.area) m², one movement, no screen, the strip outside open at both ends: #OK.
    - *Bedroom windows and rescue from outside:* all pass; the west strip is 0.785 m wide and a ladder needs the driveway beyond the M line: #NV → note for the site plan (page 2).
    - *Exit doors:* the family entrance 0.90 m clear (egress door #OK); the service door 0.80 and the guest double door 1.30 clear with both leaves (secondary exits); thumb-turns on all three: a hardware specification (#OK once specified).
    #v(2pt)
    #text(7.5pt)[#if all-ok [*Study checks passed* (#checks.len())] else [*STUDY CHECKS FAILED:* #checks.filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]]
  ],
  [
    #H[The rules checked against]
    #table(columns: (2.6fr, 1.5fr, auto), inset: 2.3pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      [*Rule*], [*Source*], [*Status*],
      ..rules.map(((r, s, st)) => (r, text(6.4pt, s), st)).flatten())
    #text(6.4pt, fill: gray)[*Not verified* = the figure was read in the IRC / NFPA text the Saudi code adopts; the SBC 2024 wording, section numbers, Saudi amendments and the Civil Defense villa checklist could not be read for this study.]
    #v(3pt)
    #H[2 · Safe exit: the routes (lengths for information; no limit applies inside a dwelling)]
    #table(columns: (1.2fr, auto, auto, 2fr), inset: 2pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") },
      [*From*], [*to the stair*], [*to the family door*], [*Through · backup refuge*],
      ..routes-ff.map(((n, P, l)) => ([#n], [#r1(plen(P)) m], [#r1(plen(P) + stair-len + plen(gf-from-stair)) m], text(6.2pt, l))).flatten())
    #table(columns: (1.2fr, auto, 2fr), inset: 2pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") },
      [*Ground floor from*], [*to the exit*], [*Through*],
      ..routes-gf.map(((n, P, l)) => ([#n], [#r1(plen(P)) m], text(6.2pt, l))).flatten())
    #text(6.2pt, fill: gray)[The stair: two flights 1.21 m clear, risers 0.164, goings 0.28, headroom 2.14 m, handrails both sides; #r1(stair-len) m walked on it; it continues to the roof (a way up out of smoke).]
  ],
)

// ====================================================================================== PAGE 2 · escape windows
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[5 · Verification: the escape windows (IRC R310 as the SBC 1101 basis) and what is outside each]
#v(2pt)
#table(columns: (1.1fr, auto, 1fr, auto, auto, auto, auto, auto, auto, 2.4fr), inset: 2.3pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
  [*Room*], [*Floor*], [*Window (plans)*], [*Size w × h*], [*Sill above the floor*], [*Sashes*], [*Net clear (one sash)*], [*Screen*], [*Verdict*], [*Outside: landing, rescue access*],
  ..rows.map(r => (
    [#r.room], [#r.floor], [#r2(r.w.a.at(0)) #r2(r.w.a.at(1)) → #r2(r.w.b.at(0)) #r2(r.w.b.at(1))], [#r2(r.e.width) × #r2(r.e.height)], [#r2(r.w.sill) (+#f2(r.w.sill + (if r.floor == "FF" { 3.6 } else { 0.0 })))], [#r.e.sashes × #r2(r.e.width / r.e.sashes)], [#r2(r.e.clear-w) × #r2(r.e.clear-h) = *#r2(r.e.area) m²*],
    if r.screen [fixed mashrabiya] else [none], if r.ok { PASS } else { FAIL }, text(6.3pt, r.out),
  )).flatten())
#v(3pt)
#grid(columns: (1fr, 1fr), gutter: 12pt,
  [
    #H[How the net clear opening is counted]
    - The window line of the plans is the structural opening; black steel side-hung casements of ≤ #r2(R.sash-max) m, a #r2(R.frame * 1000) mm frame and sash edge all round, *one sash opening fully with one movement* (a single handle, no key, no restrictor). Net clear width = sash width − 2 × #r2(R.frame); height = (head − sill) − 2 × #r2(R.frame). Tilt-only, top-hung or sliding sashes do not count. *Engineer / window supplier to confirm* the sash sizes and the hardware on the shop drawings (#NV until then).
    - The heights come from `3d/params.yaml` (the maid window listed at sill +1.10; the bedroom windows at the default sill 0.90 / head 2.10). The bedroom windows in the plans are 1.0–3.6 m wide: every one passes with one sash of ≤ 1.0 m, the maid window with its single 1.14 m sash.
    - *Child restrictors* (note only): if fitted after occupation, with an adult release that needs no key and does not reduce the opening when released.
  ],
  [
    #H[Rescue from outside: notes for the site plan]
    - *North* (kids' room): the setback is 3.8–5.7 m wide and opens onto the north street and the parking: a ladder or a vehicle reaches the facade. #OK
    - *Cut wall / lane* (bedroom 1, the maid room): the strip to the lane boundary is 2.5 m: a ladder (base ≈ 1.2 m for the 4.8 m rise) stands in it; a vehicle on the lane outside the wall. #OK
    - *West* (bedrooms 2 and 3): the strip inside the M line is 0.785 m: a ladder must stand on the driveway beyond the M line (3.95 m wide in `base.typ`). #NV: the site plan must confirm the driveway stays open and reachable at night (not fenced, not parked over); if it cannot, a ladder from the north corner reaches bedroom 2 only. The first-floor sills are 4.8 m above the ground outside (−0.30).
    - *East* (the suite): the strip is 3.6–9 m wide: a ladder in the strip; the vehicle access to the east yard from the north (site plan). #OK
    - *The suite court* is the suite's fresh-air refuge, open to the sky, walled: no way down, but air and a place to call from; a rescue ladder cannot reach it (inside the roof). #OK as a refuge, not as an exit.
    - *The courtyard* (the gallery's W1 casements and the family living's W2) is likewise a refuge for whoever is in the gallery, not an exit.
  ],
)

// ====================================================================================== PAGE 3 · plans: alarms, equipment, routes
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[5 · Verification: the alarms and the equipment on both floors (positions from design_gf.typ / design_ff.typ)]
#v(2pt)
#let plan(floor, rooms, length: 0.47cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let q(p) = (p.at(0), -p.at(1))
  let T(p, body, size: 4.2pt, fill: ink, anchor: "center") = content(q(p), anchor: anchor, text(size, fill: fill, body))
  let fills = (family: rgb("#f6e3c0"), guest: rgb("#e9d9c4"), service: rgb("#dbe7ec"), core: rgb("#e4ded2"), circ: rgb("#f2efe8"), court: rgb("#dbe9f4"), open: white, tower: rgb("#cfe0d8"))
  for r in rooms { line(..r.P.map(q), close: true, fill: fills.at(r.colour, default: luma(235)), stroke: 0.5pt + ink) }
  line(..outline.map(q), close: true, stroke: 1.4pt + ink)
  rect(q((0, 2.2)), q((2.75, 7.9)), fill: rgb("#e4ded2"), stroke: 0.5pt + ink); T((1.375, 5.0), [stair], size: 4pt)
  rect(q((0, 0)), q((2.25, 2.2)), fill: luma(225), stroke: 0.5pt + ink); T((1.1, 1.1), [lift], size: 3.8pt)
  for w in WIN.filter(w => w.floor == floor) { line(q(w.a), q(w.b), stroke: 1.6pt + blue) }
  for r in rows.filter(r => r.floor == floor) { line(q(r.w.a), q(r.w.b), stroke: 3.2pt + (if r.ok { green } else { red })) }
  let rts = if floor == "FF" { routes-ff } else { routes-gf }
  for (n, P, l) in rts { line(..P.map(q), stroke: (paint: red, thickness: 1pt, dash: "dashed"), mark: (end: "stealth", fill: red, scale: 0.55)) }
  if floor == "GF" { line(..gf-from-stair.map(q), stroke: (paint: red, thickness: 1pt, dash: "dashed"), mark: (end: "stealth", fill: red, scale: 0.55)) }
  for e in exits { line(q(e.a), q(e.b), stroke: 3.5pt + (if e.egress { green } else { amber })) }
  if floor == "GF" { T((3.5, -0.5), [family door · egress], size: 4pt, fill: green); T((-0.5, 22.2), [guest door], size: 4pt, fill: amber, anchor: "east"); T((13.8, 7.65), [service door], size: 4pt, fill: green, anchor: "west"); T((4.6, 9.8), [courtyard: refuge], size: 3.8pt, fill: amber, anchor: "west") }
  if floor == "FF" { T((8.6, 20.25), [suite court: the suite's refuge], size: 3.8pt, fill: amber) }
  let col = (S: blue, H: red, CO: amber, G: red, E: green, B: green)
  for i in items.filter(i => i.floor == floor) { circle(q(i.p), radius: 0.3, fill: white, stroke: 0.8pt + col.at(i.k)); T(i.p, [#i.k], size: 3.6pt, fill: col.at(i.k)) }
  for r in rooms.filter(r => r.colour != "open") { let c = (r.P.map(p => p.at(0)).sum() / r.P.len(), r.P.map(p => p.at(1)).sum() / r.P.len()); T((c.at(0), c.at(1) + 0.6), text(3.3pt, fill: luma(110), r.name.split(" (").at(0))) }
  T((6.6, -1.3), [#floor · north up · 1 m = 0.47 cm], size: 4.4pt, fill: gray)
})
#grid(columns: (auto, auto, 1fr), gutter: 10pt, plan("GF", GF), plan("FF", FF),
  [
    #set text(6.5pt)
    #H[Legend] Circles: *S* smoke alarm (photoelectric, mains + sealed battery, interconnected), *H* heat alarm, *CO* carbon-monoxide alarm, *G* gas detector (the shut-off valve at the cylinder cabinet), *E* extinguisher, *B* fire blanket. Red dashed: the routes; green thick: escape windows (pass); blue: other windows; green / amber on the outline: the exits.
    #v(2pt)
    #H[The alarm layout, checked]
    #table(columns: (auto, 1.3fr, auto, auto), inset: 2pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      [*Floor*], [*Alarm*], [*to the hob*], [*to a shower door*],
      ..smoke.map(i => ([#i.floor], text(6.2pt, i.l), [#if i.floor == "GF" [#r1(dist(i.p, hob)) m] else [—]], [#r1(calc.min(..bath-doors.filter(b => b.at(2) == i.floor).map(b => dist(i.p, b.at(1))))) m])).flatten())
    - *Types and positions:* photoelectric alarms (fewer kitchen false alarms; ≥ #r1(R.cook-dist) m from the hob: the nearest is the dining alarm at #r1(calc.min(..near-hob.map(((i, d)) => d))) m #if hob-ok { OK } else { PROBLEM }); ≥ #r2(R.bath-dist) m from the shower doors (nearest #r1(calc.min(..near-bath.map(((i, d)) => d))) m #if bath-ok { OK } else { PROBLEM }); ceiling-mounted ≥ #r2(R.wall-gap) m from the walls (a specification; the gypsum ceilings at ≈ +3.0 / +3.05). *The void:* one alarm on the void's ceiling (+6.98) over the living and one on the gallery's ceiling beside it; the void's alarm reacts later than a low ceiling's (smoke cools and stratifies in a 7 m space, NFPA 72 A.29.11.3.3), the gallery's and the stair foot's alarms are the early ones: the manufacturer's maximum mounting height for the void alarm is #NV (most ranges allow it; an outdoor-rated or high-ceiling model if the range has one).
    - *Count:* #n-smoke smoke + 1 heat (kitchen) + 1 CO (kitchen side, away from the hob) + the gas detector; #n-ext extinguishers (kitchen, stair foot, stair top) and the blanket.
    - *Audibility:* an alarm inside every bedroom and the maid room #if bed-ok { OK } else { PROBLEM }; interconnected, all sound together: ≥ 75 dBA at the pillow is met by the in-room alarm (85 dBA at 3 m per UL 217) — #NV until tested on site with the doors closed (a sound-level meter at the pillow, every bedroom, with the alarm in the gallery triggered).
    - *Power:* the alarm circuit on the essentials circuit if the electrical designer agrees; the sealed battery keeps every alarm working in a cut; no panel, no internet.
  ],
)

// ====================================================================================== PAGE 4 · the kitchen, the doors, the proposals · PAGE 5 · the family plan
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[5 · Verification: the kitchen, the exit doors · the proposals the verification produced]
#v(2pt)
#grid(columns: (1fr, 1fr), gutter: 12pt,
  [
    #H[The kitchen as the room that slows smoke]
    - *Walls:* 200 mm block on all sides to the structural slab (the west wall to the courtyard, the east outer wall, the dining wall y 13.0 and the new north partition y 7.0, which the maid-wing decision specified as a partition on a ground beam: *it must run to the slab, not stop at the gypsum ceiling* → a note for the engineer, no change in plan). The kitchen ceiling is the ribbed slab's gypsum ceiling (+3.0–3.05) with the hood duct through the east wall.
    - *Door to the dining:* a solid timber door 1.10 m (9.4–10.5, y 13.0) with seals and no vent: with the door closed at night the kitchen is a separate smoke compartment at household level; what it achieves: smoke from a cooking fire stays in the kitchen until the heat alarm has sounded and the family is on its way out; no time is claimed. #OK (specification: solid, sealed, no vent, kept closed at night).
    - *The laundry entrance:* the kitchen ↔ laundry opening (9.7–10.55, y 7.0) *has no door*: kitchen smoke goes straight into the laundry and reaches the maid room's door (1.00, hinged, 3.5 m away). #PROBLEM → *P1 (proposal, not applied): a solid door in that opening* (0.85 m, the laundry side; the maid's route stays open from inside) — owner decision. Her second way is her escape window.
    - *Hood and make-up air* (open item 8): the extract through the east wall straight out; no claim here.
    #v(2pt)
    #H[The exit doors]
    #table(columns: (1.3fr, auto, auto, 1.5fr, auto), inset: 2pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") },
      [*Door*], [*Width*], [*Clear*], [*Swing*], [*Role*],
      ..exits.map(e => ([#e.name], [#r2(e.width)], [#r2(e.clear)], text(6.2pt, e.swing), if e.egress [egress door #OK] else [secondary exit])).flatten())
    - *Hardware:* every exit door with a thumb-turn or a night latch inside (no key to get out), the guest double door's second leaf on flush bolts that a child can reach; the roof stair room door outward on a thumb-turn; the laundry and the maid room doors never locked from outside while she is in. #OK as a specification; #NV until the door schedule exists.
    - *Clear widths:* the family entrance 0.90 m ≥ 0.813 (the dwelling's egress door); the service door 0.80 and the guest door's single leaf 0.60 are below the egress figure, which the code asks of one door only; both leaves of the guest door give 1.30. #OK
  ],
  [
    #H[Proposals from the verification (not applied; owner decision)]
    - *P1 · A door at the kitchen ↔ laundry entrance* (solid, 0.85 m, swinging into the laundry, never locked): closes the smoke path kitchen → laundry → maid room; effect: the laundry loses the open view into the kitchen; the maid's route to the service door stays (she opens the door).
    - *P2 · The driveway for rescue:* keep the strip west of the M line open and unobstructed at night and show it on the site plan as the ladder stand for bedrooms 2 and 3; if the driveway cannot be guaranteed, consider making bedroom 2's and 3's windows reachable from the north corner (a wider strip is not available: the house is 0.785 m from the M line).
    - *P3 · The void alarm's model:* choose a range whose specification allows the 7 m mounting height (or a high-ceiling model of the same range); otherwise rely on the gallery and stair alarms and omit the void alarm.
    #v(2pt)
    #H[Verification results in one list]
    #table(columns: (1.6fr, auto, 2.4fr), inset: 2pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      [*Point*], [*Result*], [*Evidence*],
      [Alarm layout: every bedroom, the gallery, the family living, the stair foot and top, the living, the void, the kitchen heat alarm], if bed-ok and hob-ok and bath-ok { OK } else { PROBLEM }, [#n-smoke smoke + 1 heat on the plans; in-room alarms in all 6 sleeping rooms; hob ≥ #r1(R.cook-dist) m; shower doors ≥ #r2(R.bath-dist) m (table, page 3)],
      [Alarm types and mounting (wall gap, the void's height)], NV, [a specification; the void alarm's height per the manufacturer (P3)],
      [Audibility in every bedroom with the door closed], NV, [an alarm inside each room (method); test at the pillow on site],
      [Kitchen door and walls], OK, [solid sealed door to the dining; block walls to the slab (note: the y 7.0 partition to the slab)],
      [Kitchen ↔ laundry opening], PROBLEM, [no door: smoke path to the maid room → P1],
      [Maid window], OK, [net #r2(rows.last().e.area) m², one casement, sill +1.10, no screen, the strip outside 2.5 m and open at both ends],
      [First-floor bedroom windows], OK, [all pass (page 2); rescue access north, lane and east OK; west via the driveway: #NV → P2],
      [Exit doors: thumb-turns, swing, clear widths], OK, [family door 0.90 clear; thumb-turns a specification (#NV until the schedule)],
    )
  ],
)

// ====================================================================================== PAGE 5 · the family escape plan
#pagebreak()
#text(14pt, weight: "bold", fill: accent)[6 · The family escape plan · Taif / Palm House]
#v(2pt)
#grid(columns: (1.1fr, 1fr), gutter: 14pt,
  [
    #set text(8.4pt)
    #H[When an alarm sounds]
    1. *Everyone out by the stair* and through the nearest door: the family entrance (north), the kitchen service door (east), or the guest entrance through the foyer (west). Close the doors behind you. Do not use the lift. Do not stop for anything.
    2. *If the stair or the gallery is full of smoke:* stay in your room with the door closed, open your window wide for air, call 998 (Civil Defense) and the family, and show yourself at the window. *The master suite* goes out to the suite court (open to the sky) and waits there. The rescue comes from outside: the north street side, the lane side, the east yard, the driveway on the west.
    3. *Meet at the assembly point:* the north parking by the gate (proposed; set with the site plan). Count everyone. Nobody goes back in.
    #v(3pt)
    #H[The routes]
    #table(columns: (1fr, 2fr, 1.4fr), inset: 2.6pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      [*From*], [*Main route*], [*Backup refuge*],
      [Master suite], [suite lobby → family link → family living → gallery → stair → family door], [the suite court (open to the sky); the east window],
      [Bedroom 1], [family link → family living → gallery → stair → family door], [the cut-wall window (lane side)],
      [Kids' room], [gallery → stair → family door], [the north window],
      [Bedroom 2 / bedroom 3], [gallery on the projection → stair → family door], [the west window (driveway side)],
      [Maid room], [laundry → kitchen → service door (east yard)], [her window (lane side), 1.10 m sill],
      [Guests in the majlis], [foyer → guest door (west)], [—],
    )
  ],
  [
    #set text(8.4pt)
    #H[Household rules]
    - *Test the alarms monthly* (the test button on one alarm sounds them all); clean them as the manufacturer says; replace every alarm after about 10 years (the date is printed on it).
    - *Keep the kitchen door closed at night*, and the bedroom doors too: a closed door keeps smoke out of a room for the minutes that matter.
    - *Practise the plan with the children* twice a year: the alarm sound, the two ways out of each room, the window opening, the meeting point. The children must know how to open their window and that they never hide.
    - *Gas:* the cylinders stay outside in their cabinet; the shut-off valve closes by itself when the detector sounds, and by hand at the valve; the hob is never left on unattended.
    - *The kitchen:* the fire blanket and the extinguisher by the service door; a pan fire is covered, never carried, never watered.
    - *The roof:* the stair room door opens from inside; the roof is a way up and out of the smoke if the way down is cut, and the fire brigade can reach it from the street side.
    - *Phone numbers* at the family entrance and in the kitchen: Civil Defense 998, ambulance 997, police 999 (Saudi Arabia).
    #v(3pt)
    #text(7pt, fill: gray)[Drawn from `studies/fire_escape.typ` §5; the assembly point and the rescue access are confirmed with the site plan; nothing here replaces the Civil Defense's requirements for the permit.]
  ],
)

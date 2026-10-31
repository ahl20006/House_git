// south_wing.typ · Taif / Palm House V7.1 · STUDY ONLY (owner's ideas, 1 Nov 2026): the south wing re-planned (gym west + south, office east,
// the suite court in the middle) and an external stair at the south-east corner (the office entrance for visitors, the maintenance access to the roof).
// The owner decided on 1 Nov 2026 and the decisions were applied to the design files the same day (studies/ff_suite.typ, roof.typ, structure.typ, fire_escape.typ, data/rooms_ff.csv);
// this study keeps its original comparison (court 2.0 m) as the record.
// Stand-alone: the current first floor is read from ../data/rooms_ff.csv; the site from ../base.typ (land, envelope, lane, drive, palms);
// levels from 3d/params.yaml and studies/roof.typ; the structure from studies/structure.typ (copied). CSV frame: x east, y south, wall centre lines.
// Site frame (base.typ): the house is placed at CSV + (0.91, 3.825), square to the M line. Every size is a study assumption.
#import "@preview/cetz:0.4.2"
#import "../base.typ": land, env, lane, drv, T1, T2, north, seg-dist, edges, dist, inside
#set page(paper: "a4", flipped: true, margin: 9mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 7.2pt)
#let ink = rgb("#3d4a45")
#let green = rgb("#2f6b4f")
#let red = rgb("#b5452f")
#let blue = rgb("#1f4e79")
#let orange = rgb("#c25b00")
#let stone = rgb("#c9a86a")
#let sky = rgb("#8ccbe0")
#let r1(v) = str(calc.round(v, digits: 1))
#let r2(v) = str(calc.round(v, digits: 2))
#let f2(v) = { let s = str(calc.round(calc.abs(v), digits: 2)); if v < 0 { "−" + s } else { "+" + s } }
#let H(t) = text(9.2pt, weight: "bold", fill: green, t)
#let area(P) = calc.abs(range(P.len()).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, P.len())); a.at(0) * b.at(1) - b.at(0) * a.at(1) }).sum()) / 2
#let rp(x0, y0, x1, y1) = ((x0, y0), (x1, y0), (x1, y1), (x0, y1))
#let shift = (0.91, 3.825)
#let site(p) = (p.at(0) + shift.at(0), p.at(1) + shift.at(1))
#let bdist(p, P) = calc.min(..edges(P).map(e => seg-dist(p, ..e)))
#let ldist(p, L) = calc.min(..range(L.len() - 1).map(i => seg-dist(p, L.at(i), L.at(i + 1))))
#let plen(P) = range(P.len() - 1).map(i => dist(P.at(i), P.at(i + 1))).sum()

// ---------- levels (3d/params.yaml, studies/roof.typ) ----------
#let L = (ground: -0.30, gf: 0.0, ff: 3.60, roof: 7.20, roof-fin: 7.30, band: 3.40, cornice: (6.90, 7.35), coping-n: 7.65, parapet-s: 8.40, attic: 9.10, stair-room: 9.70, malqaf: 9.80, base: 9.10)
#let cl = (sill: 5.0, head: 6.0, windows: ((6.0, 7.0), (7.6, 8.6)))   // the double-height living's clerestory windows on y 19.25 (studies/sections.typ)

// ---------- the current first floor (../data/rooms_ff.csv) and the current south wing ----------
#let parse-pts(s) = s.split(";").map(t => t.trim()).filter(t => t != "").map(t => { let v = t.split(" ").filter(u => u != ""); (float(v.at(0)), float(v.at(1))) })
#let FF = csv("../data/rooms_ff.csv", row-type: dictionary).filter(r => r.name != "" and not r.name.starts-with("#")).map(r => {
  let P = if r.pts.trim() != "" { parse-pts(r.pts) } else { let x = float(r.x); let y = float(r.y); let w = float(r.w); let d = float(r.d); rp(x - w / 2, y - d / 2, x + w / 2, y + d / 2) }
  (name: r.name, colour: r.colour, P: P) })
#let south-names = ("Gym route", "Owner's office", "Gym", "Suite court (open to the sky)")
// the V7.1 south wing BEFORE the decision (the record; data/rooms_ff.csv now holds the swapped wing)
#let now-gym = ((4.25, 21.25), (11.586, 21.25), (11.586, 19.25), (13.311, 19.25), (13.311, 24.0), (4.25, 24.0))
#let now-office = rp(0, 19.25, 4.25, 24.0)
#let now-court = rp(5.6, 19.25, 11.586, 21.25)
#let now-route = rp(4.25, 19.25, 5.6, 21.25)
#let now-tm = (11.686 + 0.3, 19.35 + 0.1, 11.686 + 0.3 + 0.9, 19.35 + 0.1 + 2.0)   // the treadmill in the arm (studies/ff_suite.typ): 0.9 × 2.0, 0.3 m each side (owner's old allowance)
#let now-arm-clear = 13.311 - 0.125 - (11.586 + 0.1)                                // the treadmill arm's clear width

// ---------- the swapped south wing (owner's idea): gym west + south (an L), court in the middle, office east ----------
#let xc = 5.6          // the court's west wall (the gym's west part ends here; today the gym route / court wall, on rib B20)
#let xo = 10.0         // the court's east wall = the office's west wall (new; a thickened rib B21′ on this line, full 4.75 m)
#let yc = 21.25        // the court's south wall = the gym's south strip north wall (light partition, as today's gym north wall)
#let gym-w = rp(0, 19.25, xc, 24.0)
#let gym-s = rp(xc, yc, xo, 24.0)
#let gym2 = ((0, 19.25), (xc, 19.25), (xc, yc), (xo, yc), (xo, 24.0), (0, 24.0))
#let court2 = rp(xc, 19.25, xo, yc)
#let office2 = rp(xo, 19.25, 13.311, 24.0)
#let gym2-clear = (0.125, 19.35, 13.186 - (13.311 - xo) - 0.1, 23.875)             // x 0.125 … 9.9, y 19.35 … 23.875 (the court box x 5.6–10 y 19.25–21.25 cut out)
#let gym2-clear-area = (xc - 0.1 - 0.125) * (23.875 - 19.35) + (xo - 0.1 - (xc + 0.1)) * (23.875 - (yc + 0.1))
#let office2-clear = (xo + 0.1, 19.35, 13.186, 23.875)
#let office2-clear-area = (office2-clear.at(2) - office2-clear.at(0)) * (office2-clear.at(3) - office2-clear.at(1))
#let court2-clear = (xc + 0.1, 19.35, xo - 0.1, yc - 0.05)
#let now-gym-clear = (13.186 - 4.35) * (23.875 - 21.35) + now-arm-clear * (21.35 - 19.35)
#let now-office-clear = (4.15 - 0.125) * (23.875 - 19.35)
#let now-court-clear = (11.586 - 0.1 - 5.7) * (21.15 - 19.35)
#let court2-clear-area = (court2-clear.at(2) - court2-clear.at(0)) * (court2-clear.at(3) - court2-clear.at(1))
// the treadmill: a full-size home treadmill, assumed Life Fitness T5 class: footprint 2.03 × 0.84 m, belt 1.52 × 0.56; the manufacturer's clearance
// (ASTM F2115 / the Life Fitness manual): 2.0 m clear BEHIND the belt, 0.5 m each side (assumed; to confirm with the chosen model)
#let tm = (model: "Life Fitness T5 class (assumed)", len: 2.03, wid: 0.84, behind: 2.0, side: 0.5)
#let tm2 = (0.125 + tm.side, 23.875 - 0.25 - tm.len, 0.125 + tm.side + tm.wid, 23.875 - 0.25)   // facing south (the window band), against the west outer wall line
#let tm2-zone = (tm2.at(0) - tm.side, tm2.at(1) - tm.behind, tm2.at(2) + tm.side, tm2.at(3))
#let tm2-fits = tm2-zone.at(0) >= gym2-clear.at(0) - 1e-6 and tm2-zone.at(1) >= gym2-clear.at(1) - 1e-6 and tm2-zone.at(3) <= gym2-clear.at(3) + 1e-6
#let now-tm-zone-w = tm.wid + 2 * tm.side                                            // 1.84 needed; the arm gives now-arm-clear
#let gym2-doors = (
  ((4.3, 19.25), (5.55, 19.25), [from the gallery end (sliding) · today's gym route opening]),
  ((xo, 23.05), (xo, 23.9), [office ← gym (0.85, lockable from the office side)]),
)
#let court2-door = ((9.05, 19.25), (9.95, 19.25), [court ← suite bedroom only (sliding 0.9)])
#let pivot = (y0: 21.55, y1: 23.0, sill: 0.95, head: 2.0, t: 0.18)                   // the pivoting TV panel in the shared wall x 10.0, 0.3 m south of R6's bearing
#let gym2-windows = (((0, 19.6), (0, 20.9)), ((0, 22.0), (0, 23.5)), ((0.5, 24), (3.9, 24)), ((4.5, 24), (9.5, 24)), ((xc, 19.6), (xc, 20.9)), ((6.0, yc), (9.6, yc)))   // the last two: HIGH LEVEL only (sill +1.8) onto the court
#let office2-windows = (((10.5, 24), (12.8, 24)),)
#let office2-ext-door = (east: ((13.311, 21.0), (13.311, 21.9)), south: ((12.0, 24), (12.9, 24)))
#let gym2-eq = (
  (tm2.at(0), tm2.at(1), tm2.at(2), tm2.at(3), [treadmill\ 2.03 × 0.84\ facing S]),
  (2.4, 19.35, 3.6, 19.9, [pull-up bar (N wall)]), (2.3, 22.4, 4.1, 23.75, [barbell · rack]), (4.4, 23.1, 5.3, 23.75, [kettlebells]), (4.5, 21.0, 5.2, 22.3, [cardio (bike)]),
  (6.2, 22.6, 8.2, 23.6, [pilates mat 2.0 × 1.0]), (8.5, 22.2, 9.6, 23.6, [bench · mats]),
)
#let office2-eq = ((10.4, 20.6, 12.0, 21.4, [desk 1.6 × 0.8 (faces S)]), (12.5, 19.5, 13.1, 23.0, [bookshelves]), (10.4, 22.3, 11.0, 22.8, []), (11.4, 22.3, 12.0, 22.8, []), (10.3, 19.45, 11.9, 20.05, [sofa]))
// walls on the men's majlis roof (studies/structure.typ): which stand on what
#let walls2 = (
  ([x 5.6, y 19.25–21.25 (gym west ↔ court)], [thickened rib *B20* (exists today under the same wall)], [as today], true),
  ([x 10.0, y 19.25–24.0 (court ↔ office, gym ↔ office)], [a thickened rib *B21′* on x 10.0 for the full 4.75 m (today B21 sits on x 11.586 over 2.0 m): parallel to the ribs, direct and cheap], [moved rib], true),
  ([y 21.25, x 5.6–10.0 (court ↔ gym south strip)], [crosses the ribs, 4.4 m, nothing below: a *light partition* (100 mm, high windows) as recommended today for the 7.7 m gym north wall], [partition], true),
  ([y 19.25, x 0–13.311 (bedroom 3 / living / suite bedroom south walls)], [beam *B8* on the men's majlis north wall], [as today], true),
  ([x 0, y 24, x 13.311], [outer walls on the ground-floor outer walls (foyer west wall, majlis south and east walls)], [as today], true),
  ([x 4.25 (today's office / gym route wall on B19)], [no wall any more: B19 not needed, or kept as a stiffening rib under the treadmill if the treadmill moves to x 4.25], [dropped], true),
)
// the pivoting TV panel: composite sound reduction of the shared wall (ASSUMED Rw values)
#let Rw-wall = 50          // 200 mm dense block, plastered both sides (≈ 220 kg/m²)
#let Rw-panel = 36         // the sealed panel: steel frame, two 12.5 mm skins, 100 mm mineral wool, compression gaskets on four edges, cam-locked
#let Rw-leaky = 30         // the same panel with worn gaskets
#let wall-area = (24.0 - yc) * (L.roof - L.ff - 0.1)   // the shared wall between the gym's south strip and the office: 2.75 × 3.5
#let panel-area = (pivot.y1 - pivot.y0) * (pivot.head - pivot.sill)
#let composite(Rp) = 10 * calc.log((wall-area) / ((wall-area - panel-area) * calc.pow(10, -Rw-wall / 10) + panel-area * calc.pow(10, -Rp / 10)), base: 10)
// the sun on the east clerestory window: blocked by the court's east wall before the hour the ray clears the wall's north end (winter day)
#let lat = 21.4
#let plan-north-off = 21.4   // the plan's north is 21.4° west of true north (base.typ)
#let sunpos(decl, hour) = {
  let H = 15 * (hour - 12)
  let el = calc.asin(calc.sin(lat * 1deg) * calc.sin(decl * 1deg) + calc.cos(lat * 1deg) * calc.cos(decl * 1deg) * calc.cos(H * 1deg))
  let caz = (calc.sin(decl * 1deg) - calc.sin(lat * 1deg) * calc.sin(el)) / (calc.cos(lat * 1deg) * calc.cos(el))
  let az = calc.acos(calc.clamp(caz, -1, 1)).deg()
  (el: el.deg(), az: if hour > 12 { 360 - az } else { az })
}
#let east-of-plan-south(az) = (180 - az) + plan-north-off      // degrees east of the plan's south (positive = morning side)
#let blocked(wall-x, hour) = {
  let s = sunpos(-23.44, hour)
  let th = east-of-plan-south(s.az)
  if th <= 0 { false } else {
    let dx = wall-x - cl.windows.at(1).at(1)                     // from the east window's east jamb to the court's east wall
    let t = dx / calc.sin(th * 1deg)                              // the ray's run to that wall line
    let y = 19.25 + dx / calc.tan(th * 1deg)                      // where it crosses the wall line
    if y > yc { false } else { s.el < calc.atan((L.roof - cl.sill) / t).deg() }   // the wall (top +7.20) is 2 m long at most; blocked when the sun is below the wall top seen from the sill
  }
}
#let sun-hours = (9, 10, 11, 12)

// ---------- the external stair (study): two directions, two forms ----------
#let risers-ff = calc.ceil((L.ff - L.ground) / 0.17)            // ground −0.30 → the office landing +3.60: 3.90 m
#let riser-ff = (L.ff - L.ground) / risers-ff
#let risers-roof = calc.ceil((L.roof-fin - L.ff) / 0.17)         // the office landing → the roof +7.30
#let riser-roof = (L.roof-fin - L.ff) / risers-roof
#let going = 0.28
#let flight-w = 1.0                                              // clear
#let dogleg = (w: 2 * flight-w + 0.2 + 2 * 0.25, d: 1.2 + (risers-ff / 2 - 1) * going + 1.2 + 2 * 0.25)   // the enclosed tower's outer footprint (two flights side by side, two landings)
#let tower-top = L.roof-fin + 2.1 + 0.2                          // the roof door's head + the slab: the stair tower's top
#let open-south = (x0: 13.311 - 0.125 - 1.5 - 2 * ((risers-ff / 2 - 1) * going) - 1.2, x1: 13.311 - 0.125, y0: 24.125, y1: 24.125 + flight-w + 0.3)   // a straight stair with one mid landing, along the south wall, rising east to the SE corner landing
#let open-east = (y0: 24.0 - 0.125 - 1.5 - 2 * ((risers-ff / 2 - 1) * going) - 1.2, y1: 24.0 - 0.125, x0: 13.436, x1: 13.436 + flight-w + 0.3)      // the same along the east wall, rising south to the SE corner landing
#let tower-east = rp(13.436, 24.0 - dogleg.d, 13.436 + dogleg.w, 24.0)
#let tower-south = rp(13.311 - dogleg.d, 24.125, 13.311, 24.125 + dogleg.w)
// site distances (site frame)
#let house-site = ((0, 0), (10.051, 0), (13.311, 6.0), (13.311, 24.0), (0, 24.0)).map(site)
#let env-gap(P) = calc.min(..P.map(p => bdist(p, env)))
#let lane-gap(P) = calc.min(..P.map(p => ldist(p, lane)))
#let south-line = (env.last(), env.first())   // the envelope's south edge (= the land's south boundary: no south setback)
#let south-gap(P) = calc.min(..P.map(p => seg-dist(p, ..south-line)))
#let palm-gap(P) = calc.min(..P.map(p => calc.min(dist(p, T1), dist(p, T2)))) - 0.265
#let east-face = (13.311 + 0.125, 24.0)
#let d-east = (env: env-gap((site(east-face), site((13.436, 19.0)))), lane: lane-gap((site(east-face), site((13.436, 19.0)))))
#let d-south = (bound: south-gap((site((13.311, 24.125)), site((5.0, 24.125)))), palm: palm-gap((site((13.311, 24.125)),)))
#let ds = ((tower-east, [enclosed tower, EAST]), (tower-south, [enclosed tower, SOUTH]), (rp(open-east.x0, open-east.y0, open-east.x1, open-east.y1), [open stair, EAST]), (rp(open-south.x0, open-south.y0, open-south.x1, open-south.y1), [open stair, SOUTH]))
#let foot = (east: (13.436 + 0.5, 19.0), south: (open-south.x0, 24.8))
#let gate = (0.0, 0.0)                                            // peg M1 = the gate's east post (base.typ)
#let route-south = (gate, (-1.5, 1.0), (-1.5, 29.0), site((2.0, 25.2)), site(foot.south))                 // down the drive, round the SW corner, along the south garden
#let route-east = route-south.slice(0, 4) + (site((13.6, 25.2)), site(foot.east))
#let service-gate = (16.5, 12.0)                                   // ASSUMED: a service gate on the lane near the east yard (not in the project files)
#let route-service = (service-gate, site((14.2, 10.0)), site(foot.east))
#let yard = rp(13.436, 6.5, 15.5, 13.0)                            // the east service yard (rubbish, deliveries, gas) outside the kitchen's service door
// ---------- checks ----------
#let checks = (
  ([the swapped wing fills the south wing exactly (gym + court + office = 13.311 × 4.75)], calc.abs(area(gym2) + area(court2) + area(office2) - 13.311 * 4.75) < 1e-3),
  ([the treadmill with its manufacturer zone fits the gym's west part], tm2-fits),
  ([the court door from the suite bedroom lies within the bedroom's south wall (x 8.95–13.311) and the court (x ≤ 10.0)], court2-door.at(0).at(0) >= 8.95 and court2-door.at(1).at(0) <= xo),
  ([the pivot panel opening starts ≥ 0.3 m south of R6's bearing (y 21.25)], pivot.y0 >= yc + 0.3 - 1e-6),
  ([the office door and the panel do not overlap on the x 10 wall], gym2-doors.at(1).at(0).at(1) >= pivot.y1),
  ([every stair footprint stays inside the envelope with ≥ 0.5 m spare and ≥ 1.0 m from the palms], ds.all(((P, l)) => env-gap(P.map(site)) >= 0.5 and palm-gap(P.map(site)) >= 1.0)),
  ([the stair tower's top stays below the malqaf head], tower-top < L.malqaf),
)
#let all-ok = checks.all(c => c.at(1))

// ====================================================================================== PAGE 1 · the two plans
#text(14pt, weight: "bold", fill: green)[South wing study · gym west + south, office east, the court in the middle · and an external stair at the south-east · Taif / Palm House V7.1]
#v(1pt)
#text(8pt, fill: gray)[Owner's decisions 1 Nov 2026, APPLIED the same day (docs/PENDING_CHANGES.md): the swap with the suite court 2.5 m clear (y 19.25–21.9), the east enclosed stair tower continuing to the roof, the internal roof stair dropped; the pivoting TV panel NOT applied (it does not fit beside the office door in the 2.1 m shared wall: see the report) · this study keeps its original comparison · every size is a study assumption; the structure is a re-trace of the load paths, not a calculation (X5 stays open)]
#v(3pt)
#let plan(swapped, length: 0.74cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let q(p) = (p.at(0), -p.at(1))
  let T(p, t, size: 4.2pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, t))
  let poly(P, fill: none, stroke: 0.5pt + ink) = line(..P.map(q), close: true, fill: fill, stroke: stroke)
  let R(b, fill: none, stroke: 0.3pt + ink) = rect(q((b.at(0), b.at(1))), q((b.at(2), b.at(3))), fill: fill, stroke: stroke)
  // neighbours
  for (n, P) in (("Bedroom 3", rp(0, 16.6, 4.25, 19.25)), ("gallery", rp(4.25, 16.6, 5.6, 19.25)), ("double-height living (void)", rp(5.6, 16.6, 8.95, 19.25)), ("Suite bedroom", rp(8.95, 16.6, 13.311, 19.25))) { poly(P, fill: luma(238), stroke: 0.3pt + luma(170)); T(((P.at(0).at(0) + P.at(2).at(0)) / 2, 17.6), text(3.6pt, fill: luma(120), n)) }
  if not swapped {
    poly(now-office, fill: rgb("#e3e8d4")); poly(now-gym, fill: rgb("#d9e4f2")); poly(now-court, fill: white, stroke: 0.6pt + sky); poly(now-route, fill: rgb("#f2efe8"))
    T((2.1, 21.6), [Owner's office\ #r1(area(now-office)) m² · clear #r1(now-office-clear)], size: 4.4pt); T((8.0, 22.6), [Gym (L) #r1(area(now-gym)) m² · clear #r1(now-gym-clear)], size: 4.4pt); T((8.6, 20.25), [suite court #r1(area(now-court)) m²\ open to the sky], size: 4pt, fill: sky); T((4.9, 20.25), [gym\ route], size: 3.6pt)
    R(now-tm, fill: rgb("#fde4c8"), stroke: 0.4pt + orange); T((12.4, 20.4), [treadmill\ 0.9 × 2.0], size: 3.2pt, fill: orange)
    R((now-tm.at(0) - tm.side, now-tm.at(1), now-tm.at(2) + tm.side, now-tm.at(3) + tm.behind), fill: none, stroke: (paint: red, dash: "dashed", thickness: 0.6pt)); T((12.45, 23.0), [manufacturer zone\ 1.84 wide: the arm\ gives #r2(now-arm-clear)], size: 3.2pt, fill: red)
    for (a, b) in (((4.3, 19.25), (5.55, 19.25)), ((4.4, 21.25), (5.45, 21.25)), ((4.25, 19.4), (4.25, 20.45)), ((9.3, 19.25), (10.7, 19.25))) { line(q(a), q(b), stroke: 2.4pt + red) }
    line(q((11.586, 19.25)), q((13.311, 19.25)), stroke: 2.2pt + red); T((12.45, 18.9), [double wall 55 dB · treadmill arm ↔ suite bedroom], size: 3.2pt, fill: red)
    for (a, b) in (((4.5, 24), (13.0, 24)), ((0.5, 24), (2.3, 24)), ((2.9, 24), (3.9, 24)), ((0, 19.6), (0, 20.9)), ((0, 22.0), (0, 23.5)), ((5.9, 21.25), (8.6, 21.25))) { line(q(a), q(b), stroke: 1.6pt + blue) }
    T((6.6, 24.5), [CURRENT V7.1 · north up · 1 m = 0.74 cm], size: 4.4pt, fill: green)
  } else {
    poly(gym2, fill: rgb("#d9e4f2")); poly(court2, fill: white, stroke: 0.6pt + sky); poly(office2, fill: rgb("#e3e8d4"))
    T((3.5, 20.55), [GYM (L) #r1(area(gym2)) m² on axes\ clear ≈ #r1(gym2-clear-area)], size: 4.2pt); T((7.8, 20.25), [suite court #r1(area(court2)) m²\ clear #r2(court2-clear.at(2) - court2-clear.at(0)) × #r2(court2-clear.at(3) - court2-clear.at(1)) · open to the sky], size: 3.8pt, fill: sky)
    T((11.65, 22.0), [OWNER'S OFFICE\ #r1(area(office2)) m² · clear #r1(office2-clear-area)\ (#r2(office2-clear.at(2) - office2-clear.at(0)) × #r2(office2-clear.at(3) - office2-clear.at(1)))], size: 4pt)
    for e in gym2-eq { R((e.at(0), e.at(1), e.at(2), e.at(3)), fill: rgb("#fde4c8"), stroke: 0.4pt + orange); T(((e.at(0) + e.at(2)) / 2, (e.at(1) + e.at(3)) / 2), e.at(4), size: 3pt, fill: orange) }
    for e in office2-eq { R((e.at(0), e.at(1), e.at(2), e.at(3)), fill: rgb("#efe6cf"), stroke: 0.4pt + ink); T(((e.at(0) + e.at(2)) / 2, (e.at(1) + e.at(3)) / 2), e.at(4), size: 3pt) }
    R(tm2-zone, fill: none, stroke: (paint: red, dash: "dashed", thickness: 0.6pt)); T((1.0, 20.5), [2.0 m clear\ behind · 0.5 sides], size: 3pt, fill: red)
    for (a, b, l) in gym2-doors { line(q(a), q(b), stroke: 2.4pt + red) }
    line(q(court2-door.at(0)), q(court2-door.at(1)), stroke: 2.4pt + sky); T((9.5, 18.95), [court door (bedroom only)], size: 3.2pt, fill: sky)
    for (a, b) in gym2-windows { line(q(a), q(b), stroke: 1.6pt + blue) }
    for (a, b) in office2-windows { line(q(a), q(b), stroke: 1.6pt + blue) }
    T((7.8, 21.55), [high windows only (sill +1.8)], size: 3pt, fill: blue); T((5.95, 20.25), [high], size: 3pt, fill: blue, angle: 90deg)
    line(q((xo, pivot.y0)), q((xo, pivot.y1)), stroke: 3.2pt + orange); T((xo + 0.15, 22.3), [pivoting TV panel\ #r2(pivot.y1 - pivot.y0) × #r2(pivot.head - pivot.sill)], size: 3.2pt, fill: orange, anchor: "west")
    line(q(office2-ext-door.east.at(0)), q(office2-ext-door.east.at(1)), stroke: 2.4pt + green); T((13.5, 21.45), [visitors' door\ (east stair)], size: 3pt, fill: green, anchor: "west")
    line(q(office2-ext-door.south.at(0)), q(office2-ext-door.south.at(1)), stroke: (paint: green, thickness: 2.4pt, dash: "dotted")); T((12.45, 24.4), [or south], size: 3pt, fill: green)
    line(q((0, 19.25)), q((4.25, 19.25)), stroke: 2.2pt + red); T((2.1, 18.9), [double wall 55 dB moves here: gym ↔ bedroom 3], size: 3.2pt, fill: red)
    line(q((xo, 19.25)), q((xo, 24.0)), stroke: (paint: green, thickness: 1.2pt, dash: "dashed")); T((xo - 0.2, 23.5), [B21′ rib], size: 3pt, fill: green, anchor: "east", angle: 90deg)
    T((6.6, 24.5), [SWAPPED (owner's idea) · north up · 1 m = 0.74 cm], size: 4.4pt, fill: green)
  }
  // the clerestory windows and the living void edge
  for (a, b) in cl.windows { line(q((a, 19.25)), q((b, 19.25)), stroke: 2pt + rgb("#1f7a99")) }
  T((7.3, 18.85), [clerestory +5.00 … +6.00], size: 3.2pt, fill: rgb("#1f7a99"))
})
#grid(columns: (1fr, 1fr), gutter: 10pt, plan(false), plan(true))
#v(2pt)
#grid(columns: (1fr, 1fr), gutter: 12pt,
  [
    #H[1 · The swapped wing: what it gives]
    - *Gym, an L:* the whole west part (x 0–#r2(xc), #r2(xc) × 4.75 on axes) plus the south strip (x #r2(xc)–#r2(xo), 2.75 deep): *#r1(area(gym2)) m² on axes, ≈ #r1(gym2-clear-area) m² clear* (today #r1(area(now-gym)) / #r1(now-gym-clear)). Entered as today from the gallery end (x 4.3–5.55, y 19.25, sliding); windows west (two) and the south band x 0.5–9.5; onto the court *high-level windows only* (sill +1.8): the court stays private.
    - *The treadmill fits with its manufacturer zone:* #tm.model, #r2(tm.len) × #r2(tm.wid) m, #r2(tm.behind) m clear behind and #r2(tm.side) m each side (ASTM F2115 / the manual, assumed) → a zone #r2(tm2-zone.at(2) - tm2-zone.at(0)) × #r2(tm2-zone.at(3) - tm2-zone.at(1)) m; placed along the *west outer wall line* (the slab edge over the foyer's load-bearing west wall: the stiffest strip), facing south to the window band; #if tm2-fits [it fits] else [it does NOT fit]. Today's arm is #r2(now-arm-clear) m clear: the owner's 0.3 m sides fit, the manufacturer's #r2(now-tm-zone-w) m does not.
    - *Also in the gym:* pull-up bar on the north wall, barbell + rack and kettlebells at the south-west, one cardio bike by the gallery door, the pilates mat and a bench in the south strip; doors open; the walkway from the gallery door to the office door runs along the court's walls (≥ 1.1 m).
    - *Suite court:* x #r2(xc)–#r2(xo), 2.0 deep: *#r1(area(court2)) m² on axes, #r2(court2-clear.at(2) - court2-clear.at(0)) × #r2(court2-clear.at(3) - court2-clear.at(1)) clear* (today #r1(area(now-court)) m²); enclosed on four sides: the living's clerestory wall and the suite bedroom north, the gym west (x #r2(xc)) and south (y #r2(yc)), the office east (x #r2(xo)); reached from the suite bedroom only (a 0.9 m sliding door at x 9.05–9.95, the only part of the bedroom's south wall that touches the court). Its floor drain west as today.
    - *Owner's office, east:* x #r2(xo)–13.311 × 4.75: *#r1(area(office2)) m² on axes, #r2(office2-clear.at(2) - office2-clear.at(0)) × #r2(office2-clear.at(3) - office2-clear.at(1)) = #r1(office2-clear-area) m² clear* (today #r1(area(now-office)) / #r1(now-office-clear)): a desk facing the south window, a sofa on the suite wall, shelves east. Doors: from the gym's south strip (0.85, lockable from the office side) and the visitors' door to the external stair (east wall, or south). The office window south only (x 10.5–12.8); an east window only if the stair is not on the east.
  ],
  [
    #H[2 · The pivoting TV panel in the shared gym / office wall (x #r2(xo), y #r2(pivot.y0)–#r2(pivot.y1))]
    - *Opening:* #r2(pivot.y1 - pivot.y0) wide × #r2(pivot.head - pivot.sill) high (sill +#r2(pivot.sill), head +#r2(pivot.head)), #r2(pivot.y0 - yc) m south of R6's bearing on this wall, a lintel over it; the office door south of it (y 23.05–23.9).
    - *Panel:* #r2(pivot.t) m thick on a vertical centre pivot (the wall is 0.20: the panel's faces stand 0.01 proud each side, trimmed by a 15 mm stone architrave both sides). A welded steel frame, two 12.5 mm skins (fibre-cement or MDF), 100 mm mineral wool, a 55″ TV (≈ 1.23 × 0.71) recessed flush in one face with a soundbar below it, the other face finished as the wall (or a second screen later). ≈ 75 kg incl. the TV; a floor pivot bearing + a top guide; cables through the hollow pivot post (slip ring or a service loop for 180°).
    - *Sealed in both positions:* the panel turns 180° and fills the opening in either position; compression gaskets on all four edges are pressed by two cam locks (top / bottom) so there is no open gap — while turning, the half-width (#r2((pivot.y1 - pivot.y0) / 2)) swings into both rooms: keep 0.8 m free of furniture each side.
    - *Expected sound reduction (assumed Rw):* the solid 200 mm plastered block wall ≈ #str(Rw-wall) dB; the sealed panel ≈ #str(Rw-panel) dB; the wall with the panel (#r2(panel-area) m² in #r2(wall-area) m²) ≈ *#r1(composite(Rw-panel)) dB*, i.e. #r1(Rw-wall - composite(Rw-panel)) dB less than the solid wall; with worn gaskets (panel #str(Rw-leaky) dB) ≈ #r1(composite(Rw-leaky)) dB. Enough between a gym and an office (normal speech inaudible, loud music audible); nothing like the 55 dB double wall a bedroom needs. The acoustic engineer confirms.
    #v(2pt)
    #H[3 · Noise and privacy next to the master bedroom]
    - *Today* the treadmill arm shares 1.725 m of wall (y 19.25) with the suite bedroom (double wall, 55 dB) and the gym's high windows look onto the court outside the bedroom's door. *Swapped:* the *office* shares that wall (quiet: a single 200 mm wall suffices); the gym is #r2(8.95 - xc) m away across the court; the gym now touches *bedroom 3* (y 19.25, x 0–4.25): the double wall moves there (same length, same cost). Gym noise still reaches the court and, through the clerestory windows, the double-height living (as today).
    #text(7.5pt)[#if all-ok [*South wing study · checks passed* (#checks.len())] else [*CHECKS FAILED:* #checks.filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]]
  ],
)

// ====================================================================================== PAGE 2 · structure, light, comparison
#pagebreak()
#text(12pt, weight: "bold", fill: green)[4 · Structure re-traced (X5 stays open) · 5 · The clerestory light · 6 · Comparison with the current V7.1 south wing]
#v(2pt)
#let ribs(length: 0.52cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let q(p) = (p.at(0), -p.at(1))
  let T(p, t, size: 3.8pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, t))
  rect(q((2.75, 19.25)), q((13.311, 24.0)), fill: rgb("#f1efe8"), stroke: 0.6pt + ink); rect(q((0, 19.25)), q((2.75, 24.0)), fill: luma(235), stroke: 0.4pt + ink); T((1.4, 21.6), [foyer / guest\ block (walls)], size: 3.4pt)
  for k in range(1, 19) { let x = 2.75 + k * 0.55; line(q((x, 19.35)), q((x, 23.9)), stroke: 0.3pt + luma(160)) }
  T((8.0, 23.6), [men's majlis roof: ribbed 0.30, ribs N–S 4.75 m, no column inside the majlis], size: 3.4pt, fill: luma(100))
  line(q((2.75, 19.25)), q((13.311, 19.25)), stroke: 2.4pt + ink); T((8.0, 18.9), [B8 (majlis north wall)], size: 3.4pt); line(q((0, 24)), q((13.311, 24)), stroke: 2.4pt + ink); T((8.0, 24.35), [B9 (south wall)], size: 3.4pt)
  line(q((xc, 19.25)), q((xc, yc)), stroke: 2.2pt + green); T((xc - 0.15, 20.25), [B20 (exists)], size: 3.2pt, fill: green, anchor: "east", angle: 90deg)
  line(q((xo, 19.25)), q((xo, 24.0)), stroke: 2.2pt + green); T((xo + 0.15, 21.6), [B21′ new, 4.75 m], size: 3.2pt, fill: green, anchor: "west", angle: -90deg)
  line(q((11.586, 19.25)), q((11.586, yc)), stroke: (paint: luma(140), dash: "dashed", thickness: 1.2pt)); T((11.75, 20.25), [B21 today\ (dropped)], size: 3pt, fill: luma(120), anchor: "west")
  line(q((4.25, 19.25)), q((4.25, 24)), stroke: (paint: luma(140), dash: "dashed", thickness: 1.2pt)); T((4.4, 22.6), [B19 today (dropped)], size: 3pt, fill: luma(120), anchor: "west", angle: -90deg)
  line(q((xc, yc)), q((xo, yc)), stroke: 1.6pt + orange); T((7.8, yc + 0.3), [R6′ 4.4 m (court edge, roof) on the two walls → ribs: the transfer (X5)], size: 3.2pt, fill: orange)
  rect(q((tm2.at(0), tm2.at(1))), q((tm2.at(2), tm2.at(3))), fill: rgb("#fde4c8"), stroke: 0.4pt + orange); T((1.05, 21.0), [treadmill on the\ west edge strip], size: 3pt, fill: orange)
  T((6.6, 25.0), [the men's majlis roof and the swapped walls · 1 m = 0.52 cm], size: 3.8pt, fill: green)
})
#let light-section(length: 0.5cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, t, size: 3.8pt, fill: ink, anchor: "center", angle: 0deg) = content(p, anchor: anchor, angle: angle, text(size, fill: fill, t))
  let vx = 1.0
  let Y(y) = y - 13.0
  let Z(z) = z * vx
  // the double-height living (y 13–19.25), the court (19.25–21.25), the gym south strip (21.25–24), the parapet
  rect((Y(13.0), Z(0)), (Y(19.25), Z(L.roof)), fill: rgb("#fbf2e2"), stroke: 0.5pt + ink); T((Y(16.1), Z(3.5)), [double-height living], size: 4pt)
  rect((Y(19.25), Z(0)), (Y(24.0), Z(L.ff - 0.08)), fill: rgb("#f6e3c0"), stroke: 0.5pt + ink); T((Y(21.6), Z(1.7)), [men's majlis (GF)], size: 4pt)
  rect((Y(19.25), Z(L.ff)), (Y(yc), Z(L.ff + 0.05)), fill: sky, stroke: none); T((Y(20.25), Z(L.ff + 0.5)), [suite court\ 2.0 deep · open], size: 3.4pt, fill: sky)
  rect((Y(yc), Z(L.ff)), (Y(24.0), Z(L.roof)), fill: rgb("#d9e4f2"), stroke: 0.5pt + ink); T((Y(22.6), Z(5.4)), [gym south strip\ (today: the gym's long arm)\ roof slab top +7.20], size: 3.4pt)
  line((Y(yc), Z(L.ff)), (Y(yc), Z(L.roof)), stroke: 1.4pt + ink); T((Y(yc) + 0.15, Z(L.roof) + 0.3), [wall top +7.20 (R6 drop beam, X4)], size: 3.2pt, anchor: "west")
  line((Y(24.0), Z(L.roof)), (Y(24.0), Z(L.parapet-s)), stroke: 1.4pt + ink); T((Y(24.0) + 0.1, Z(L.parapet-s)), [parapet +8.40], size: 3.2pt, anchor: "west")
  line((Y(19.25), Z(cl.sill)), (Y(19.25), Z(cl.head)), stroke: 3pt + rgb("#1f7a99")); T((Y(19.25) - 0.15, Z(5.5)), [clerestory\ +5.00 … +6.00], size: 3.4pt, fill: rgb("#1f7a99"), anchor: "east")
  // the winter noon ray grazing the wall top
  let w = 90 - lat - 23.44
  line((Y(yc), Z(L.roof)), (Y(19.25), Z(L.roof - (yc - 19.25) * calc.tan(w * 1deg))), stroke: (paint: orange, thickness: 0.8pt, dash: "dashed")); T((Y(20.2), Z(6.75)), [winter noon #r1(w)°], size: 3.2pt, fill: orange)
  let e = 90 - lat
  line((Y(yc), Z(L.roof)), (Y(19.25), Z(L.roof - (yc - 19.25) * calc.tan(e * 1deg))), stroke: (paint: orange, thickness: 0.5pt, dash: "dotted")); T((Y(19.9), Z(3.1)), [equinox #r1(e)°], size: 3pt, fill: orange)
  T((Y(18.5), Z(-0.9)), [N–S section at x ≈ 7.3 through the clerestory and the court, looking west · IDENTICAL in both layouts · 1 m = 0.5 cm], size: 3.8pt, fill: green)
})
#let w-alt = 90 - lat - 23.44
#let sun-share(top) = calc.clamp((cl.head - (top - (yc - 19.25) * calc.tan(w-alt * 1deg))) / (cl.head - cl.sill), 0, 1)
#grid(columns: (1fr, 1.3fr), gutter: 12pt,
  [
    #ribs()
    #v(2pt)
    #H[4 · The load paths of the swapped wing]
    #table(columns: (1.3fr, 2fr, auto), inset: 2pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      [*Wall*], [*Stands on*], [*Change*],
      ..walls2.map(((w, s, c, ok)) => ([#w], [#s], [#c])).flatten())
    - *Roof over the wing:* the gym's west part (x 0–#r2(xc), 4.75 span) ribbed 0.30 N–S like today's office roof; the south strip (2.75 span) solid 0.20 as today; the office (3.3 wide) solid 0.20 spanning *east–west* between the x #r2(xo) wall and the east outer wall. *R6′*, the court's south roof edge, shrinks from 6.0 to #r2(xo - xc) m (≈ −27 % load) but is still a wall-on-rib transfer: *X5 is lighter, not closed.*
    - *Treadmill:* on the slab's west edge strip over the foyer's load-bearing west wall (0.5 m off the wall face) — the stiffest place in the wing; alternative: keep a thickened rib under it (B19 moved to x ≈ 1.05). Floating floor and pads in any case (X6).
    - *Light roof option:* an insulated steel deck on steel beams over the gym's west part and the office (the south strip stays concrete under the PV zone Z4): ≈ 2–3 kN/m² less on the majlis ribs, easier for X5; PV fixings and the parapet detail to design. The owner decides whether the roof may look lighter from the roof terrace.
    - *The engineer must confirm:* the ribs B20 / B21′ carrying the walls and R6′ (sizes, deflection); the majlis roof's vibration under the treadmill (home gym live load, SBC 301); the lintel over the pivot opening; the roof option; the east outer wall taking the office roof.
  ],
  [
    #light-section()
    #v(2pt)
    #H[5 · The clerestory light]
    - *North–south (the section):* both layouts keep the court 2.0 m deep in front of the clerestory windows and a wall top at +7.20 behind it (the gym's south strip = today's long arm). The winter noon sun (#r1(w-alt)°) reaches *#str(calc.round(sun-share(L.roof) * 100)) %* of the window height in both; the equinox sun 100 %; the sky seen from a seated eye in the living 100 %. *No change.*
    - *East–west (the difference):* the court's east wall moves from x 11.586 (the treadmill arm) to x #r2(xo) (the office), #r2(xo - cl.windows.at(1).at(1)) m east of the east clerestory window instead of #r2(11.586 - cl.windows.at(1).at(1)); the morning sun from the south-east reaches that window a little later in winter:
    #table(columns: (auto, auto, auto, auto, auto), inset: 2pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      [*21 Dec, solar hour*], [*altitude*], [*east of the plan's south*], [*today (wall x 11.586)*], [*swapped (wall x #r2(xo))*],
      ..sun-hours.map(h => { let s = sunpos(-23.44, h); ([#str(h):00], [#r1(s.el)°], [#r1(east-of-plan-south(s.az))°], [#if blocked(11.586, h) [shaded] else [sun]], [#if blocked(xo, h) [shaded] else [sun]]) }).flatten())
    - The west clerestory window (x 6.0–7.0) is #r2(xo - 7.0) m from the office wall: as today's distance to the arm, no change. The office's own light does not depend on the court (south window); the gym's south part has the south band. *Conclusion: the office reduces the east window's early winter sun by about an hour; noon and afternoon light are unchanged.*
    #v(2pt)
    #H[6 · Comparison with the current V7.1 south wing]
    #table(columns: (1.1fr, 1.6fr, 1.6fr), inset: 2pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      [*Item*], [*Current V7.1*], [*Swapped (owner's idea)*],
      [Gym size, treadmill fit], [#r1(area(now-gym)) m² on axes (≈ #r1(now-gym-clear) clear); the treadmill arm #r2(now-arm-clear) clear: 0.3 m sides only, the manufacturer's #r2(now-tm-zone-w) m does not fit], [#r1(area(gym2)) m² (≈ #r1(gym2-clear-area) clear); the treadmill with 2.0 m behind and 0.5 m sides fits on the stiff west edge; everything else fits with doors open],
      [Suite court size, privacy], [#r1(area(now-court)) m²; overlooked by the gym's north high windows and the arm's wall; the gym route door beside it], [#r1(area(court2)) m² (#r2(court2-clear.at(2) - court2-clear.at(0)) × #r2(court2-clear.at(3) - court2-clear.at(1)) clear): smaller; four walls, high windows only, one door from the bedroom: more private],
      [Noise next to the master bedroom], [the treadmill arm on the bedroom wall (double wall 55 dB)], [the office on the bedroom wall (quiet); the gym #r2(8.95 - xc) m away; the double wall moves to bedroom 3],
      [Structure / X5], [R6 6.0 m on two walls on ribs B20 / B21 (NOT verified)], [R6′ #r2(xo - xc) m on B20 / a new full-length B21′: the same transfer, ≈ 27 % less load; the office roof spans E–W; a light roof possible. X5 open],
      [Clerestory light], [winter noon #str(calc.round(sun-share(L.roof) * 100)) %, east window sun from ≈ 10:00], [the same at noon; the east window's winter sun from ≈ 11:00],
      [Office access], [from the gallery end (family only); 20.2 m² with west and south windows], [from the gym (family) and the external stair (visitors, Part 2); #r1(area(office2)) m², south window (east window only without the east stair)],
    )
  ],
)

// ====================================================================================== PAGE 3 · the external stair: site, directions, forms
#pagebreak()
#text(12pt, weight: "bold", fill: green)[7 · The external stair at the south-east: east or south, open or enclosed · the site, the setbacks, the route from the gate]
#v(2pt)
#let siteplan(length: 0.33cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let q(p) = (p.at(0), -p.at(1))
  let T(p, t, size: 3.8pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, t))
  let poly(P, fill: none, stroke: 0.5pt + ink) = line(..P.map(q), close: true, fill: fill, stroke: stroke)
  poly(land, fill: rgb("#f3f1ea"), stroke: 1pt + ink)
  poly(env, fill: rgb("#e3f0dd"), stroke: (paint: green, dash: "dashed", thickness: 0.6pt))
  poly(drv, fill: rgb("#d6e2ee"), stroke: 0.4pt + ink); T((-2.0, 20.0), [drive · parking], size: 3.6pt, angle: 90deg)
  line(..lane.map(q), stroke: 1.2pt + ink); T((21.5, 11.0), [lane], size: 4pt, angle: -60deg)
  poly(house-site, fill: rgb("#ece8dd"), stroke: 1.2pt + ink); T(site((6.6, 12.0)), [house (GF outline)], size: 4pt)
  poly(yard.map(site), fill: rgb("#dbe7ec"), stroke: 0.3pt + ink); T(site((14.5, 9.75)), [service\ yard], size: 3.2pt, angle: -90deg)
  for (P, l) in ds { poly(P.map(site), fill: rgb("#fde4c8").transparentize(30%), stroke: 0.7pt + orange) }
  T(site((15.5, 17.3)), [EAST: tower\ #r2(dogleg.w) × #r2(dogleg.d)], size: 3.2pt, fill: orange, anchor: "west"); T(site((9.0, 26.8)), [SOUTH: tower #r2(dogleg.d) × #r2(dogleg.w) / open stair], size: 3.2pt, fill: orange)
  T(site((14.7, 14.5)), [open stair E], size: 3pt, fill: orange, anchor: "west")
  for (Tp, n) in ((T1, [palm 1]), (T2, [palm 2])) { circle(q(Tp), radius: 0.9, fill: rgb("#cfe0c3"), stroke: 0.4pt + green); T((Tp.at(0), Tp.at(1) + 1.6), n, size: 3.2pt, fill: green) }
  circle(q(gate), radius: 0.4, fill: red, stroke: none); T((0.8, -0.9), [gate M1], size: 3.6pt, fill: red)
  circle(q(service-gate), radius: 0.35, fill: red.transparentize(40%), stroke: none); T((17.4, 12.2), [service gate\ (assumed)], size: 3.2pt, fill: red, anchor: "west")
  line(..route-south.map(q), stroke: (paint: red, thickness: 0.9pt, dash: "dashed")); line(..route-east.slice(3).map(q), stroke: (paint: red, thickness: 0.9pt, dash: "dotted"))
  line(..route-service.map(q), stroke: (paint: blue, thickness: 0.8pt, dash: "dashed"))
  T((-0.6, 33.0), [visitors: gate → drive → south garden → the stair foot\ south #r1(plen(route-south)) m · east #r1(plen(route-east)) m], size: 3.2pt, fill: red, anchor: "west")
  T((14.0, 32.5), [south garden (free, the palms)], size: 3.6pt, fill: green)
  T(site((5.0, 25.0)), [outdoor kitchen: not fixed in the project files], size: 3pt, fill: luma(110))
  line(q((0, 0)), q((0, 38.86)), stroke: 0.8pt + ink); T((-0.5, 5.0), [M line], size: 3.2pt, angle: 90deg)
  T((13.0, 40.5), [site plan (base.typ frame: origin M1, y along the M line) · 1 m = 0.33 cm · true north 21.4° off the page's up], size: 3.8pt, fill: green)
})
#grid(columns: (auto, 1fr), gutter: 10pt, siteplan(),
  [
    #H[Space, setbacks and envelope at the south-east corner (real distances, site frame)]
    #table(columns: (1.3fr, auto, auto, 2fr), inset: 2pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      [*Side*], [*to the envelope (setback line)*], [*to the boundary*], [*room for the stair*],
      [EAST wall face at the SE corner (y 19–24)], [#r1(d-east.env) m], [#r1(d-east.lane) m to the lane], [wide: the lane setback is tight only at the north cut (0.5 m spare); here the envelope is #r1(d-east.env) m away. The enclosed tower (#r2(dogleg.w) deep) leaves #r1(d-east.env - dogleg.w) m],
      [SOUTH wall face (x 5–13.3)], [#r1(d-south.bound) m (no south setback: the envelope is the boundary)], [#r1(d-south.bound) m to the south boundary], [the whole south garden; the nearest palm trunk #r1(d-south.palm) m from the SE corner],
    )
    #table(columns: (1.3fr, auto, auto, auto), inset: 2pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      [*Stair footprint*], [*spare to the envelope*], [*to the nearest palm trunk face*], [*ok*],
      ..ds.map(((P, l)) => ([#l], [#r1(env-gap(P.map(site))) m], [#r1(palm-gap(P.map(site))) m], [#if env-gap(P.map(site)) >= 0.5 and palm-gap(P.map(site)) >= 1.0 [✓] else [✗]])).flatten())
    - *Route from the site gate (M1, north-west):* visitors walk down the drive on the west (where the cars park), round the south-west corner past the guest foyer, and along the south garden: ≈ #r1(plen(route-south)) m to a south stair, ≈ #r1(plen(route-east)) m round the corner to an east stair. They never enter the house. *Workers* come best through a *service gate on the lane* (assumed near the east yard, not yet in the project files): ≈ #r1(plen(route-service)) m along the east side to an east stair, past the service yard (rubbish, deliveries, gas) and well clear of the courtyard windows.
    - *Relations:* the *east* stair sits on the service side, next to the yard and the lane: workers' side, the south garden and the palms untouched; the *south* stair sits on the garden side, closer to the drive / parking (≈ 5 m shorter walk) but it crosses the men's majlis south facade in front of its high windows (sill +1.8 at the ground floor: a stair user looks straight in) and takes the garden strip where the *outdoor kitchen* would go (its position is not fixed in the project files).
    - *The office's door:* on the east wall (y 21.0–21.9) for an east stair, on the south wall (x 12.0–12.9) for a south stair.
  ],
)

// ====================================================================================== PAGE 4 · elevations, roof access, security, fire, maintenance, cost, recommendation
#pagebreak()
#text(12pt, weight: "bold", fill: green)[8 · The two forms in elevation · 9 · Roof access · 10 · Security, fire, maintenance route, weather, cost · 11 · Recommendation and the decisions needed]
#v(2pt)
#let south-elev(length: 0.42cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, t, size: 3.6pt, fill: ink, anchor: "center", angle: 0deg) = content(p, anchor: anchor, angle: angle, text(size, fill: fill, t))
  let X(x) = x
  let Z(z) = z - L.ground
  // the south facade (x 0–13.311): plinth, band, cornice, parapet; behind it the attic (y 19.25, set back) and the stair room (NW) and the malqaf (NE)
  rect((X(0.875), Z(L.roof)), (X(12.436), Z(L.attic)), fill: luma(225), stroke: 0.4pt + luma(140)); T((6.6, Z(8.75)), [attic screen behind (y 19.25) +9.10], size: 3.2pt, fill: luma(110))
  rect((X(0), Z(L.roof)), (X(2.75), Z(L.stair-room)), fill: luma(215), stroke: 0.4pt + luma(140)); T((1.4, Z(9.4)), [stair room +9.70], size: 3pt, fill: luma(110))
  rect((X(8.95), Z(L.roof)), (X(10.6), Z(L.malqaf)), fill: luma(200), stroke: 0.4pt + luma(120)); T((9.75, Z(9.5)), [malqaf +9.80], size: 3pt, fill: luma(110))
  rect((X(-0.125), Z(L.ground)), (X(13.436), Z(L.parapet-s)), fill: rgb("#f6f0e1"), stroke: 0.7pt + ink)
  rect((X(-0.125), Z(L.ground)), (X(13.436), Z(0.6)), fill: stone, stroke: none)
  rect((X(-0.2), Z(L.band)), (X(13.5), Z(L.band + 0.12)), fill: stone, stroke: none)
  rect((X(-0.4), Z(L.cornice.at(0))), (X(13.7), Z(L.cornice.at(1))), fill: stone, stroke: none); T((6.6, Z(7.12)), [main cornice +6.90 … +7.35 · parapet +8.40], size: 3.2pt, fill: white)
  for (a, b) in ((3.6, 6.2), (7.2, 9.8), (10.8, 12.6)) { rect((X(a), Z(1.8)), (X(b), Z(2.9)), fill: sky, stroke: 0.4pt + ink) }
  T((6.6, Z(2.35)), [men's majlis high windows +1.80 … +2.90], size: 3pt)
  for (a, b) in ((0.5, 3.9), (4.5, 9.5)) { rect((X(a), Z(L.ff + 1.2)), (X(b), Z(L.ff + 2.4)), fill: sky, stroke: 0.4pt + ink) }
  rect((X(10.5), Z(L.ff + 0.9)), (X(12.8), Z(L.ff + 2.4)), fill: sky, stroke: 0.4pt + ink); T((11.65, Z(5.0)), [office S window], size: 3pt)
  T((6.0, Z(5.4)), [gym south band (swapped) +4.80 … +6.00], size: 3pt)
  // form (a): the open stone stair along the south wall, rising east: flight 1, mid landing, flight 2, the top landing at the SE corner (+3.60), a canopy
  let f = (risers-ff / 2 - 1) * going
  let x0 = open-south.x0
  let seg(xa, za, xb, zb) = line((X(xa), Z(za)), (X(xb), Z(zb)), stroke: 1.1pt + orange)
  let xa = x0; let xb = xa + 1.2; let xc1 = xb + f; let xd = xc1 + 1.2; let xe = xd + f; let xf = 13.311 - 0.125
  seg(xa, L.ground, xb, L.ground); seg(xb, L.ground, xc1, L.ground + (risers-ff / 2) * riser-ff); seg(xc1, L.ground + (risers-ff / 2) * riser-ff, xd, L.ground + (risers-ff / 2) * riser-ff); seg(xd, L.ground + (risers-ff / 2) * riser-ff, xe, L.ff); seg(xe, L.ff, xf, L.ff)
  line((X(xa), Z(L.ground)), (X(xa), Z(L.ground + 1.1)), stroke: 0.5pt + ink); line((X(xa), Z(L.ground + 1.1)), (X(xb), Z(L.ground + 1.1)), (X(xc1), Z(L.ground + (risers-ff / 2) * riser-ff + 1.1)), (X(xd), Z(L.ground + (risers-ff / 2) * riser-ff + 1.1)), (X(xe), Z(L.ff + 1.1)), (X(xf), Z(L.ff + 1.1)), stroke: 0.6pt + ink)
  rect((X(xe - 0.3), Z(L.ff + 2.5)), (X(xf + 0.3), Z(L.ff + 2.7)), fill: stone, stroke: none); T((xe + 0.9, Z(L.ff + 3.0)), [stone canopy over the landing], size: 3pt)
  T((xa + 3.0, Z(0.35)), [form (a): open honey-stone stair, black bar railing · #str(risers-ff) risers × #r2(riser-ff) · two flights + mid landing · to the office landing +3.60 only], size: 3.2pt, fill: orange)
  rect((X(open-south.x0 - 2.2), Z(L.ff)), (X(open-south.x0 - 0.2), Z(L.ff + 1.1)), fill: none, stroke: (paint: red, dash: "dotted", thickness: 0.6pt)); T((open-south.x0 - 1.2, Z(L.ff + 1.4)), [gate at the foot · gate above the landing], size: 2.8pt, fill: red)
  T((6.6, Z(-1.0)), [SOUTH elevation (seen from the garden), form (a) on the south · 1 m = 0.42 cm · ground −0.30], size: 3.8pt, fill: green)
})
#let east-elev(length: 0.42cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, t, size: 3.6pt, fill: ink, anchor: "center", angle: 0deg) = content(p, anchor: anchor, angle: angle, text(size, fill: fill, t))
  let X(y) = 24.0 - y            // seen from the east: north on the right
  let Z(z) = z - L.ground
  // behind: the attic (set back), the stair room (NW, far), the malqaf and its base at the NE (right)
  rect((X(19.25), Z(L.roof)), (X(0.875), Z(L.attic)), fill: luma(225), stroke: 0.4pt + luma(140)); T((X(10.0), Z(8.75)), [attic screen behind (x 12.436) +9.10], size: 3.2pt, fill: luma(110))
  rect((X(3.4), Z(L.roof)), (X(0.0), Z(L.base)), fill: luma(205), stroke: 0.4pt + luma(120)); T((X(1.7), Z(8.6)), [HRV base +9.10], size: 3pt, fill: luma(110))
  rect((X(1.0), Z(L.roof)), (X(0.0), Z(L.malqaf)), fill: luma(190), stroke: 0.4pt + luma(120)); T((X(0.5), Z(9.5)), [malqaf], size: 3pt, fill: luma(110))
  // the east facade: the straight part y 6–24 (coping +7.65 on the north block to y 19.25, the parapet +8.40 on the south wing) and the cut y 0–6 (seen obliquely, drawn narrower)
  rect((X(19.25), Z(L.ground)), (X(6.0), Z(L.coping-n)), fill: rgb("#f6f0e1"), stroke: 0.7pt + ink)
  rect((X(24.0), Z(L.ground)), (X(19.25), Z(L.parapet-s)), fill: rgb("#f6f0e1"), stroke: 0.7pt + ink)
  line((X(6.0), Z(L.ground)), (X(2.9), Z(L.ground)), (X(2.9), Z(L.coping-n)), (X(6.0), Z(L.coping-n)), stroke: 0.7pt + ink); T((X(4.4), Z(4.6)), [cut wall\ (oblique)], size: 3pt, fill: luma(110))
  rect((X(24.0), Z(L.ground)), (X(2.9), Z(0.6)), fill: stone, stroke: none)
  rect((X(24.1), Z(L.band)), (X(2.9), Z(L.band + 0.12)), fill: stone, stroke: none)
  rect((X(24.4), Z(L.cornice.at(0))), (X(2.9), Z(L.cornice.at(1))), fill: stone, stroke: none)
  T((X(12.5), Z(7.12)), [main cornice · coping +7.65 (north block) · parapet +8.40 (south wing)], size: 3.2pt, fill: white)
  rect((X(8.1), Z(0.0)), (X(7.2), Z(2.1)), fill: rgb("#e0d2b8"), stroke: 0.4pt + ink); T((X(7.65), Z(-0.6)), [service door], size: 2.8pt)
  rect((X(10.1), Z(1.1)), (X(8.7), Z(2.1)), fill: sky, stroke: 0.4pt + ink); T((X(9.4), Z(0.75)), [kitchen W], size: 2.8pt)
  rect((X(10.05), Z(L.ff + 1.5)), (X(9.5), Z(L.ff + 2.1)), fill: sky, stroke: 0.4pt + ink)
  rect((X(18.6), Z(L.ff + 0.9)), (X(15.0), Z(L.ff + 2.4)), fill: sky, stroke: 0.4pt + ink); T((X(16.8), Z(4.1)), [suite bedroom window (escape)], size: 2.8pt)
  // form (b): the enclosed stair tower at the SE corner (left), arched openings, to the roof: top +9.60
  let d = dogleg.d
  rect((X(24.0) - 0.0, Z(L.ground)), (X(24.0 - d), Z(tower-top)), fill: rgb("#f6f0e1"), stroke: 0.9pt + ink)
  rect((X(24.0), Z(L.ground)), (X(24.0 - d), Z(0.6)), fill: stone, stroke: none)
  rect((X(24.0) - 0.1, Z(tower-top - 0.45)), (X(24.0 - d) + 0.1, Z(tower-top)), fill: stone, stroke: none)
  for (z0, z1) in ((1.2, 3.0), (4.9, 6.7)) { for yy in (24.0 - 1.0, 24.0 - d + 1.0) { arc((X(yy) - 0.45, Z(z1 - 0.45)), start: 0deg, stop: 180deg, radius: 0.45, fill: rgb("#dfe8f0"), stroke: 0.4pt + ink); rect((X(yy) - 0.9, Z(z0)), (X(yy), Z(z1 - 0.45)), fill: rgb("#dfe8f0"), stroke: 0.4pt + ink) } }
  rect((X(24.0) - 1.9, Z(7.8)), (X(24.0) - 1.0, Z(9.1)), fill: rgb("#dfe8f0"), stroke: 0.4pt + ink)
  T((X(24.0 - d / 2), Z(tower-top + 0.35)), [form (b): enclosed stair tower, arched openings (the enclosure windows' language), top +#r2(tower-top): below the malqaf +9.80, above the attic +9.10], size: 3pt, fill: orange)
  T((X(24.0 - d / 2), Z(0.9)), [gate (out-opening, panic bar)], size: 2.8pt, fill: red); T((X(24.0 - d / 2), Z(L.ff + 0.3)), [office landing +3.60 · locked gate above it], size: 2.8pt, fill: red); T((X(24.0 - d / 2), Z(L.roof-fin + 0.3)), [roof door +7.30 (locked)], size: 2.8pt, fill: red)
  T((X(12.0), Z(-1.0)), [EAST elevation (seen from the lane; north on the right), form (b) on the east · 1 m = 0.42 cm], size: 3.8pt, fill: green)
})
#grid(columns: (1fr, 1fr), gutter: 10pt, south-elev(), east-elev())
#v(2pt)
#grid(columns: (1fr, 1fr, 1fr), gutter: 10pt,
  [
    #H[8 · Which looks better]
    - *(a) the open stone stair* reads as a garden stair of the Hejaz houses: honest, light, cheap; but it draws a long diagonal across a facade whose language is horizontal (the band, the cornice, the parapet) and it can only reach the office landing (a second run to the roof stacked over it has no headroom). On the south it crosses the men's majlis windows; on the east it runs under the suite bedroom's escape window. *It looks added on unless it is short and tucked into the corner.*
    - *(b) the enclosed tower* with two arched openings per storey in the enclosure windows' language, a stone plinth and the main cornice line carried round it, top +#r2(tower-top): a designed mass. On the *east* it pairs with the malqaf tower (+9.80) at the other end of the lane facade: two vertical elements on the service side, the attic screen between them, the garden facade untouched. On the *south* it would stand alone in the middle of the quiet garden front. *The east tower looks designed; it works best if it also replaces the internal roof stair (§ 9), so the stair room at the north-west disappears and the roofline keeps exactly two verticals.*
    #v(2pt)
    #H[9 · Roof access]
    - *(i) the tower continues to the roof:* a locked steel gate across the stair above the office landing; the roof door at +7.30 opens onto the south wing roof (parapet +8.40). The internal roof flights and the stair room become unnecessary: *proposal* for `studies/roof.typ` (not applied): no stair room Z1 (−#r1(2.75 * 5.7) m² footprint, the attic's west leg straightened), no flights 3–4 (the first-floor arrival stays), the roof slab opening closed (R16–R18 become ordinary slab, the lift headroom unchanged), the walkway network starts at the south-east, the owner's "roof for maintenance only" rule is kept without any door from the roof into the house.
    - *(ii) the stair serves the office only; the roof by a fixed ladder:* a caged steel ladder from the office landing (+3.60) to the roof (3.7 m) inside the tower's upper part, with a locked hatch at the top; shorter tower (+6.9, under the cornice), cheaper, less comfortable for workers with equipment (filters, PV panels). The internal roof stair then stays.
  ],
  [
    #H[10 · Security, fire, the maintenance route, weather, cost]
    - *Security:* a steel gate at the foot, locked against entry (key / code outside) and opening *outwards without a key* (panic bar); a second locked gate across the stair above the office landing (visitors stop there); the office's door to the gym with a thumb-turn on the office side only; *no door from the roof into the house* (with (i) the stair room goes; the attic strip doors lead only to roof areas); cameras at the foot gate, on the office landing (the door) and at the roof arrival, plus one on the roof looking along the south wing. *The courtyard from the roof:* the sky hole's 1.10 guard stops falls, not a person with a rope: the W1 / W2 casements get key locks and the alarm's roof contacts (the roof door, the gate); nothing physical short of a grille over the sky hole, which would spoil the courtyard — not proposed.
    - *Fire (second way out of the first floor):* the family reaches the stair only through the gym and the office; the office door is locked from the office side and the tower's openings sit within 1.8 m of the office window and (east) under the suite bedroom's window: *not counted* as an escape. It can be counted if the office door gets a thumb-turn on both sides and the openings near the stair are fire-rated or 1.8 m away.
    - *Roof maintenance route:* from the roof door (SE) west along the south wing on paving pads (the walkway y 22.6, south of the suite court's guards: no opening crossed), through the attic door at (2.1–2.9, y 19.25) into the north block, then the existing walkway network to the water tank, the PV, the condensers (Z2b) and the HRV base with the tower (NE); no walking on the insulation; the court hole and the sky hole stay guarded.
    - *Weather and dust:* the tower's arched openings unglazed with a bird mesh (rain and dust enter a little: a drained stone floor, the landing door sheltered); an open stair gets a stone canopy over the landing only. Finishes: honey-stone treads and plinth, cream plaster, black steel gates and rails.
    - *Rough relative cost (orders, not quotes):* open stair (a) to the office ≈ 0.8–1.0 × the internal roof flights + stair room it does not replace; the enclosed tower (b) to the roof ≈ 1.5–2 × that, but with (i) it *replaces* the two internal flights, the stair room and the roof opening (≈ 0.6–0.8 × back), so the net extra is ≈ 0.7–1.2 ×. The QS prices it.
  ],
  [
    #H[11 · Recommendation]
    - *South wing:* *adopt the swap.* The gym gets its real treadmill zone on the stiffest part of the slab, the office moves to the quiet wall beside the suite, the court keeps its light and gains privacy; the structural transfer (X5) gets lighter. The price: a smaller office (#r1(office2-clear-area) m² clear) and a smaller court (#r1(area(court2)) m²); the east clerestory window loses about an hour of early winter sun. Keep the court 2.0 m deep (the clerestory light); a 2.4 m court is possible at the cost of the pilates strip.
    - *External stair:* *east, enclosed tower (b), continuing to the roof (i)* with the locked gate above the office landing, and the internal roof stair and stair room dropped as a consequence (a cleaner roofline: the malqaf and the stair tower only). Visitors come down the drive and along the south garden (≈ #r1(plen(route-east)) m); workers through a service gate on the lane (to be added to the site plan).
    #v(2pt)
    #H[Decisions needed from the owner]
    - The swap: yes / no; the court's depth (2.0 / 2.4); the pivoting TV panel (yes / no; one screen or two).
    - The stair: east / south; open (a) / enclosed (b); roof by the stair (i) or by a ladder (ii); if (i): drop the internal roof flights and the stair room (then `studies/roof.typ`, `studies/structure.typ` and the 3D change).
    - The service gate on the lane (position); the outdoor kitchen's position; cameras and locks as listed.
    #v(2pt)
    #H[What the engineers confirm]
    - Structural: everything in § 4; the stair tower's foundation beside the east footings and its tie to the house; the roof slab opening (closed or kept).
    - Acoustic: the pivot panel's real Rw and the gaskets; the bedroom 3 double wall.
    - Fire / security consultant: the escape count, the gate hardware, the cameras.
  ],
)

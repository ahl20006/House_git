// gf_shower.typ · Taif / Palm House V8.2 · the ground-floor shower study (design review G-07, ageing in place; 2 Nov 2026) · OWNER'S DECISION 3 Nov 2026: NOT NEEDED (owner):
// NO shower and no hidden provision on the ground floor; G-07 closed; the family WC and basins become one luxurious powder room (studies/guest_wing.typ). This file is the record of the study.
// The ground floor has WCs but no shower; with the lift the showers upstairs are reachable, but a ground-floor shower helps an injured or elderly
// person and a guest staying over. Three positions are studied (the family WC enlarged, the hospitality kitchen, the maid wing's laundry): size,
// a level walk-in shower ≥ 0.9 × 1.2, a turning circle where possible, access from the family side, the drain to a stack, ventilation, privacy,
// the effect on the rooms around, the structure. Recommend one; wait for the owner's decision. Nothing here changes the design files.
// Geometry copied from data/rooms_gf.csv, studies/guest_wing.typ (fixtures), studies/east_wing.typ (fixtures), studies/structure.typ (B14, the drain runs).
// CSV frame: x east, y south, wall centre lines; levels above the finished ground floor ±0.00.
#import "@preview/cetz:0.4.2"
#set page(paper: "a4", flipped: true, margin: 9mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 7.2pt)
#let ink = rgb("#3d4a45")
#let accent = rgb("#5a7d2a")
#let red = rgb("#b5452f")
#let blue = rgb("#2f5f8a")
#let green = rgb("#2f7a3f")
#let amber = rgb("#b58a1f")
#let r1(v) = str(calc.round(v, digits: 1))
#let r2(v) = str(calc.round(v, digits: 2))
#let H(body) = text(9.5pt, weight: "bold", fill: accent, body)
#let OK = text(fill: green, weight: "bold")[OK]
#let NO = text(fill: red, weight: "bold")[NO]
#let box-overlap(a, b) = a.at(0) < b.at(2) and b.at(0) < a.at(2) and a.at(1) < b.at(3) and b.at(1) < a.at(3)
#let circle-box-clear(c, r, b) = { let dx = calc.max(b.at(0) - c.at(0), 0, c.at(0) - b.at(2)); let dy = calc.max(b.at(1) - c.at(1), 0, c.at(1) - b.at(3)); calc.sqrt(dx * dx + dy * dy) >= r - 1e-9 }

// ---------- The west wash block today (data/rooms_gf.csv; fixtures from studies/guest_wing.typ, local y + 10.4) ----------
#let utility = (0, 7.9, 2.75, 10.4); #let shaft = (0, 9.2, 1.5, 10.4)
#let hosp = (0, 10.4, 2.75, 12.9); #let basins = (0, 12.9, 2.75, 14.4); #let fwc = (0, 14.4, 2.75, 16.1); #let serving = (0, 16.1, 2.75, 17.5)
#let hosp-fix = ((0.1, 10.5, 2.5, 11.1, [counter · sink · fridge · microwave]), (0.1, 11.1, 0.7, 12.8, [counter · trays]))
#let basins-fix = ((0.1, 13.0, 1.8, 13.5, [basin counter (2) · wudu]),)
#let fwc-fix = ((0.2, 15.4, 0.85, 16.0, [WC]), (1.9, 15.5, 2.5, 16.0, [basin]))     // assumed layout of the family WC + basin today (not in the files)
#let openings = (((2.75, 8.2), (2.75, 9.0), [utility door]), ((2.75, 10.6), (2.75, 12.7), [open to the riwaq]), ((2.75, 13.0), (2.75, 14.3), [open to the riwaq]), ((1.5, 14.4), (2.5, 14.4), [WC door 1.0]), ((2.75, 16.25), (2.75, 17.15), [serving door 1]), ((0.1, 17.5), (1.15, 17.5), [serving door 2]))
#let t-out = 0.25; #let t-in = 0.20
#let turn = 1.5                       // the wheelchair turning circle
#let shower-min = (0.9, 1.2)

// ---------- P1 · the family WC + the family basins → one accessible wet room (x 0–2.75, y 12.9–16.1) ----------
#let p1 = (0, 12.9, 2.75, 16.1)
#let p1-clear = (t-out / 2, 12.9 + t-in / 2, 2.75 - t-in / 2, 16.1 - t-in / 2)        // 2.525 × 3.0
#let p1-fix = ((0.125, 13.0, 1.3, 13.5, [basin counter (2) kept]), (0.125, 14.8, 1.325, 16.0, [level shower 1.2 × 1.2 · seat · rails]), (1.9, 15.3, 2.5, 16.0, [WC · grab rails]))
#let p1-door = ((2.75, 13.2), (2.75, 14.2))                                            // 1.0 sliding, on the riwaq side (parks south on the wall)
#let p1-turn = (1.6, 14.3)
#let p1-win = ((0, 14.6), (0, 15.2))                                                   // a west vent window, sill +1.8 (under the FF bath 3's window)
#let p1-drain = ((0.9, 15.4), (0.4, 15.6), (0.3, 16.0))                                // the shower outlet into the west drain run / the WC stack
#let p1-net = (p1-clear.at(2) - p1-clear.at(0)) * (p1-clear.at(3) - p1-clear.at(1))
// ---------- P2 · the hospitality kitchen → the wet room; the light kitchen moves into the basins' room ----------
#let p2 = hosp
#let p2-clear = (t-out / 2, 10.4 + t-in / 2, 2.75 - t-in / 2, 12.9 - t-in / 2)        // 2.525 × 2.3
#let p2-fix = ((0.125, 10.5, 0.65, 11.1, [basin]), (0.125, 11.6, 1.325, 12.8, [level shower 1.2 × 1.2]), (1.9, 12.1, 2.5, 12.8, [WC]))
#let p2-door = ((2.75, 10.7), (2.75, 11.7))
#let p2-turn = (1.45, 11.4)
#let p2-kitchen = ((0.125, 13.0, 2.4, 13.6, [light kitchen: counter · sink · fridge · microwave]),)   // into the basins' room (the wudu basins → the family WC room)
#let p2-drain = ((0.8, 12.2), (0.75, 10.4), (0.75, 10.0))                              // north into the utility shaft
#let p2-net = (p2-clear.at(2) - p2-clear.at(0)) * (p2-clear.at(3) - p2-clear.at(1))
// ---------- P3 · the laundry's south end (maid wing; fixtures from studies/east_wing.typ, local + (8.95, 0)) ----------
#let laundry = (8.95, 2.8, 10.65, 7.0)
#let laundry-fix = ((9.05, 2.9, 9.65, 3.5, [washer]), (9.05, 3.5, 9.65, 4.1, [dryer]), (9.05, 4.1, 9.65, 4.7, [utility sink]), (9.05, 4.7, 9.65, 5.7, [folding · shelves]), (9.05, 5.7, 9.65, 6.9, [drying rail · ironing]))
#let p3 = (8.95, 5.4, 10.65, 7.0)
#let p3-clear = (8.95 + t-in / 2, 5.4 + t-in / 2, 10.65 - t-in / 2, 7.0 - t-in / 2)   // 1.5 × 1.4
#let p3-fix = ((9.05, 5.6, 9.95, 6.8, [shower 0.9 × 1.2]), (10.1, 5.6, 10.5, 6.0, [basin]))
#let p3-door = ((10.0, 5.4), (10.5, 5.4))                                              // 0.5?? no: the partition is only 1.5 clear: a 0.8 door from the laundry
#let p3-net = (p3-clear.at(2) - p3-clear.at(0)) * (p3-clear.at(3) - p3-clear.at(1))

// ---------- checks of this study ----------
#let fits-turn(c, fixes) = fixes.all(f => circle-box-clear(c, turn / 2, (f.at(0), f.at(1), f.at(2), f.at(3))))
#let in-box(f, b) = f.at(0) >= b.at(0) - 1e-9 and f.at(2) <= b.at(2) + 1e-9 and f.at(1) >= b.at(1) - 1e-9 and f.at(3) <= b.at(3) + 1e-9
#let checks = (
  ([P1: a level shower ≥ 0.9 × 1.2 (#r2(p1-fix.at(1).at(2) - p1-fix.at(1).at(0)) × #r2(p1-fix.at(1).at(3) - p1-fix.at(1).at(1)))], p1-fix.at(1).at(2) - p1-fix.at(1).at(0) >= shower-min.at(0) - 1e-9 and p1-fix.at(1).at(3) - p1-fix.at(1).at(1) >= shower-min.at(1) - 1e-9),
  ([P1: a #r1(turn) m turning circle clear of the basins and the WC (the level shower zone may be part of it)], fits-turn(p1-turn, (p1-fix.at(0), p1-fix.at(2))) and circle-box-clear(p1-turn, turn / 2, (p1-clear.at(0) - 10, p1-clear.at(1) - 10, p1-clear.at(0), p1-clear.at(3) + 10)) and circle-box-clear(p1-turn, turn / 2, (p1-clear.at(2), p1-clear.at(1) - 10, p1-clear.at(2) + 10, p1-clear.at(3) + 10))),
  ([P1: every fixture inside the clear room, none overlapping], p1-fix.all(f => in-box(f, p1-clear)) and range(p1-fix.len()).all(i => range(i + 1, p1-fix.len()).all(j => not box-overlap((p1-fix.at(i).at(0), p1-fix.at(i).at(1), p1-fix.at(i).at(2), p1-fix.at(i).at(3)), (p1-fix.at(j).at(0), p1-fix.at(j).at(1), p1-fix.at(j).at(2), p1-fix.at(j).at(3)))))),
  ([P1: the door (1.0, sliding) on the riwaq side, parking on the wall south of it (#r2(16.1 - p1-door.at(1).at(1)) m of wall)], p1-door.at(1).at(1) - p1-door.at(0).at(1) >= 1.0 - 1e-9 and 16.1 - p1-door.at(1).at(1) >= 1.0),
  ([P2: a #r1(turn) m turning circle and the shower ≥ 0.9 × 1.2 inside the clear room], fits-turn(p2-turn, (p2-fix.at(0), p2-fix.at(2))) and p2-fix.all(f => in-box(f, p2-clear)) and p2-fix.at(1).at(2) - p2-fix.at(1).at(0) >= 0.9 - 1e-9 and p2-fix.at(1).at(3) - p2-fix.at(1).at(1) >= 1.2 - 1e-9),
  ([P3: the shower ≥ 0.9 × 1.2 fits, but no turning circle (#r2(p3-clear.at(2) - p3-clear.at(0)) × #r2(p3-clear.at(3) - p3-clear.at(1)) clear) and no WC: reported], p3-fix.at(0).at(2) - p3-fix.at(0).at(0) >= 0.9 - 1e-9 and p3-fix.at(0).at(3) - p3-fix.at(0).at(1) >= 1.2 - 1e-9 and calc.min(p3-clear.at(2) - p3-clear.at(0), p3-clear.at(3) - p3-clear.at(1)) < turn),
  ([P1 and P2 are entered from the riwaq (the family side), P3 only through the kitchen and the laundry (the service side)], p1-door.at(0).at(0) == 2.75 and p2-door.at(0).at(0) == 2.75 and p3-door.at(0).at(1) == 5.4),
)
#let all-ok = checks.all(c => c.at(1))

// ---------- drawing ----------
#let q(p) = (p.at(0), -p.at(1))
#let west-plan(variant, length: 1.05cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, body, size: 3.6pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, body))
  let R(b, fill: none, stroke: none) = rect(q((b.at(0), b.at(1))), q((b.at(2), b.at(3))), fill: fill, stroke: stroke)
  let fix(F, col) = { for (x0, y0, x1, y1, l) in F { R((x0, y0, x1, y1), fill: col, stroke: 0.4pt + ink); T(((x0 + x1) / 2, (y0 + y1) / 2), l, size: 2.9pt, angle: if (y1 - y0) > (x1 - x0) * 1.4 { 90deg } else { 0deg }) } }
  // the riwaq and the courtyard glass
  R((2.75, 7.5, 4.25, 18.0), fill: rgb("#f6f2e6")); T((3.5, 12.0), [riwaq · 1.30 clear], size: 3.4pt, angle: 90deg)
  R((4.25, 7.5, 4.8, 13.0), fill: rgb("#dbe9f4")); T((4.5, 10.2), [courtyard], size: 3.2pt, angle: 90deg, fill: blue); R((4.25, 13.0, 4.8, 18.0), fill: rgb("#f6e3c0")); T((4.5, 15.5), [living], size: 3.2pt, angle: 90deg)
  // the rooms
  R(utility, fill: rgb("#e4ded2"), stroke: 0.5pt + ink); T((1.9, 8.5), [utility room], size: 3.2pt); R(shaft, fill: luma(200), stroke: (paint: ink, dash: "dashed", thickness: 0.4pt)); T((0.75, 9.8), [shaft], size: 3pt)
  R(serving, fill: rgb("#dbe7ec"), stroke: 0.5pt + ink); T((1.4, 16.8), [serving passage (2 doors)], size: 3.2pt)
  if variant == "today" {
    R(hosp, fill: rgb("#dbe7ec"), stroke: 0.5pt + ink); fix(hosp-fix, white); T((1.6, 12.0), [hospitality kitchen], size: 3.2pt)
    R(basins, fill: rgb("#dbe7ec"), stroke: 0.5pt + ink); fix(basins-fix, white); T((1.9, 13.9), [family basins (open to the riwaq)], size: 3pt)
    R(fwc, fill: rgb("#dbe7ec"), stroke: 0.5pt + ink); fix(fwc-fix, white); T((1.4, 14.95), [family WC + basin · no shower], size: 3pt)
    for (a, b, l) in openings { line(q(a), q(b), stroke: 2pt + red) }
    T((1.4, 7.1), [TODAY · the west wash block · 1 m = 1.05 cm], size: 3.6pt, fill: accent)
  }
  if variant == "P1" {
    R(hosp, fill: rgb("#dbe7ec"), stroke: 0.5pt + ink); fix(hosp-fix, white); T((1.6, 12.0), [hospitality kitchen (unchanged)], size: 3.2pt)
    R(p1, fill: rgb("#cfe6ef"), stroke: 0.8pt + ink); fix(p1-fix, white)
    line(q((0.125, 14.4)), q((2.65, 14.4)), stroke: (paint: red, thickness: 0.6pt, dash: "dotted")); T((2.0, 14.25), [wall y 14.4 removed · B14 a drop beam], size: 2.6pt, fill: red)
    circle(q(p1-turn), radius: turn / 2, fill: none, stroke: (paint: green, thickness: 0.6pt, dash: "dashed")); T(p1-turn, [Ø #r1(turn)], size: 3pt, fill: green)
    line(q(p1-door.at(0)), q(p1-door.at(1)), stroke: 2pt + red); T((2.95, 13.7), [sliding 1.0], size: 2.8pt, fill: red, angle: 90deg)
    line(q(p1-win.at(0)), q(p1-win.at(1)), stroke: 2.4pt + blue); T((-0.2, 14.9), [vent window\ sill +1.8], size: 2.6pt, fill: blue, anchor: "east")
    line(..p1-drain.map(q), stroke: (paint: rgb("#1f7a99"), thickness: 0.8pt, dash: "dashed"), mark: (end: ">", fill: rgb("#1f7a99"), scale: 0.4)); T((0.9, 16.3), [→ the west drain run / the WC stack], size: 2.6pt, fill: rgb("#1f7a99"))
    for (a, b, l) in openings.slice(0, 2) + openings.slice(4) { line(q(a), q(b), stroke: 2pt + red) }
    T((1.4, 7.1), [P1 · the family WC + basins → one accessible wet room #r2(p1-net) m² clear], size: 3.6pt, fill: accent)
  }
  if variant == "P2" {
    R(p2, fill: rgb("#cfe6ef"), stroke: 0.8pt + ink); fix(p2-fix, white)
    circle(q(p2-turn), radius: turn / 2, fill: none, stroke: (paint: green, thickness: 0.6pt, dash: "dashed")); T(p2-turn, [Ø #r1(turn)], size: 3pt, fill: green)
    line(q(p2-door.at(0)), q(p2-door.at(1)), stroke: 2pt + red); T((2.95, 11.2), [sliding 1.0], size: 2.8pt, fill: red, angle: 90deg)
    line(q((0, 11.0)), q((0, 11.6)), stroke: 2.4pt + blue); T((-0.2, 11.3), [vent window], size: 2.6pt, fill: blue, anchor: "east")
    line(..p2-drain.map(q), stroke: (paint: rgb("#1f7a99"), thickness: 0.8pt, dash: "dashed"), mark: (end: ">", fill: rgb("#1f7a99"), scale: 0.4)); T((1.5, 10.2), [→ the utility shaft], size: 2.6pt, fill: rgb("#1f7a99"))
    R(basins, fill: rgb("#dbe7ec"), stroke: 0.5pt + ink); fix(p2-kitchen, white); T((1.6, 14.0), [the light kitchen moved here (the wudu basins → the family WC)], size: 2.8pt)
    R(fwc, fill: rgb("#dbe7ec"), stroke: 0.5pt + ink); fix(((0.2, 15.4, 0.85, 16.0, [WC]), (1.5, 15.5, 2.5, 16.0, [2 basins]),), white); T((1.4, 14.95), [family WC + the wudu basins], size: 3pt)
    for (a, b, l) in openings.slice(0, 1) + openings.slice(2) { line(q(a), q(b), stroke: 2pt + red) }
    T((1.4, 7.1), [P2 · the hospitality kitchen → the wet room #r2(p2-net) m² clear; two rooms re-planned], size: 3.6pt, fill: accent)
  }
})
#let maid-plan(length: 1.05cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, body, size: 3.6pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, body))
  let R(b, fill: none, stroke: none) = rect(q((b.at(0), b.at(1))), q((b.at(2), b.at(3))), fill: fill, stroke: stroke)
  R((4.25, 0, 8.95, 6.5), fill: rgb("#f6e3c0")); T((6.6, 3.3), [women's majlis], size: 3.2pt)
  line(q((8.95, 1)), q((10.094, 1)), q((10.601, 1.933)), q((11.303, 1.551)), q((11.982, 2.8)), q((8.95, 2.8)), close: true, fill: rgb("#dbe7ec"), stroke: 0.5pt + ink); T((9.8, 1.9), [maid bath], size: 3pt)
  line(q((10.65, 2.8)), q((11.982, 2.8)), q((13.311, 5.245)), q((13.311, 7.0)), q((10.65, 7.0)), close: true, fill: rgb("#dbe7ec"), stroke: 0.5pt + ink); T((12.0, 5.0), [maid room], size: 3.2pt)
  R((8.95, 7.0, 13.311, 9.0), fill: rgb("#dbe7ec")); T((11.1, 8.0), [kitchen (the way in: kitchen → laundry)], size: 3.2pt)
  R(laundry, fill: rgb("#dbe7ec"), stroke: 0.5pt + ink)
  for (x0, y0, x1, y1, l) in laundry-fix.slice(0, 3) { R((x0, y0, x1, y1), fill: white, stroke: 0.4pt + ink); T(((x0 + x1) / 2, (y0 + y1) / 2), l, size: 2.8pt) }
  R((9.05, 4.7, 9.65, 5.3), fill: white, stroke: (paint: red, dash: "dotted", thickness: 0.5pt)); T((9.35, 5.0), [folding ✗ (lost)], size: 2.6pt, fill: red)
  R(p3, fill: rgb("#cfe6ef"), stroke: 0.8pt + ink)
  for (x0, y0, x1, y1, l) in p3-fix { R((x0, y0, x1, y1), fill: white, stroke: 0.4pt + ink); T(((x0 + x1) / 2, (y0 + y1) / 2), l, size: 2.8pt) }
  line(q((9.9, 5.4)), q((10.55, 5.4)), stroke: 2pt + red); T((10.75, 5.4), [door 0.65 from the laundry], size: 2.6pt, fill: red, anchor: "west")
  line(q((9.7, 7.0)), q((10.55, 7.0)), stroke: 2pt + red); T((10.1, 7.25), [kitchen ↔ laundry opening], size: 2.6pt, fill: red)
  T((10.6, -0.4), [P3 · the laundry's south end #r2(p3-net) m² clear (no WC, no turning circle) · 1 m = 1.05 cm], size: 3.4pt, fill: accent)
})

// ====================================================================================== PAGE 1
#text(14pt, weight: "bold", fill: accent)[A ground-floor shower · design review G-07, ageing in place · three positions compared · Taif / Palm House V8.1 · STUDY ONLY]
#v(1pt)
#text(8pt, fill: gray)[*DEFERRED to the plumbing study by the owner (2 Nov 2026): P1 preferred, P1-lite the fallback.* 2 Nov 2026 · today the ground floor has the family WC, the guest WC and the maid bath (the only shower, the maid's) · a level walk-in shower ≥ #r2(shower-min.at(0)) × #r2(shower-min.at(1)) m, a #r1(turn) m turning circle where possible, access from the family side, a drain to a stack, ventilation, privacy · nothing in the design files changes until the owner decides · all sizes assumed]
#v(3pt)
#grid(columns: (auto, auto, auto, 1fr), gutter: 7pt,
  west-plan("today"), west-plan("P1"), west-plan("P2"),
  [
    #set text(6.4pt)
    #H[P1 · the family WC and the family basins become one accessible wet room (recommended)]
    - *Where:* the west wash block, x 0–2.75, y 12.9–16.1: the two rooms merged by removing the wall on y 14.4; *#r2(p1-clear.at(2) - p1-clear.at(0)) × #r2(p1-clear.at(3) - p1-clear.at(1)) = #r2(p1-net) m² clear*.
    - *Layout:* the *wudu basin counter kept* on the north wall (two basins, 1.2 m); a *level walk-in shower 1.2 × 1.2* at the south-west corner (a fold-down seat, grab rails, a curtain or a half screen, the floor falling to its outlet: the ground slab is on grade, so the floor is lowered locally with no beam in the way); the *WC* at the south-east corner with grab rails both sides; a *#r1(turn) m turning circle* in the middle (the level shower zone may be part of it); a *1.0 m sliding door* on the riwaq side (no swing in the 1.30 m riwaq), parking on the 1.9 m of wall south of it. Non-slip tiles, a hand shower, lever taps, a night light.
    - *Access:* from the riwaq (the family side), 3 m from the lift, never through the guest side. *Drain:* the shower outlet into the west drain run under the wash block beside the existing WC stack (one run, as decided). *Ventilation:* a small west window (sill +1.8, under the first-floor bath 3's window) plus an extract fan. *Privacy:* its own door; the shower and the WC at the south end, out of the door's sight line; the basins by the door.
    - *Effect on the rooms around:* the *open wudu basins* (open to the riwaq today) are now *behind a sliding door that stays open by day*: the one real loss; the hospitality kitchen, the serving passage, the utility room and the riwaq are untouched. *Structure:* the GF wall on y 14.4 carries the hidden beam *B14* under the first-floor wall between bedroom 2 and bath 3: without the wall, B14 becomes a *drop beam 0.25 × 0.45* spanning 2.75 m from the west wall to B10, hidden in the wet room's gypsum ceiling (the house rule): the engineer.
    #v(2pt)
    #H[P2 · the hospitality kitchen becomes the wet room; the light kitchen moves]
    - *Where:* x 0–2.75, y 10.4–12.9: *#r2(p2-net) m² clear*, the roomiest; the turning circle, the shower, a WC and a basin fit; the *utility shaft is next door* (the shortest drain, 1.5 m north); a west vent window; a sliding door on the riwaq.
    - *But:* the hospitality kitchen (decision 5: the light kitchen beside the serving passage) must move into the basins' room (a 2.3 m counter, cramped), and the wudu basins then move into the family WC room: *three rooms re-planned*, the open wudu place lost all the same. No structural change (the walls y 10.4 and 12.9 stay).
    #v(2pt)
    #H[P3 · the laundry's south end (maid wing)]
    - *Where:* x 8.95–10.65, y 5.4–7.0: *#r2(p3-net) m² clear*: a shower 0.9 × 1.2 and a basin fit, *no WC, no turning circle*; the drain into the maid wing's east run (short). *But:* reached only *through the kitchen and the laundry* (the service side: wrong for a guest or an elderly parent, and in the maid's way); no window (the laundry is internal: mechanical vent only); the laundry loses its folding and drying space (2.6 m left for the washer, the dryer and the sink). Rejected.
  ],
)

// ====================================================================================== PAGE 2
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[P3 for the record · the comparison · recommendation · the decision needed]
#v(2pt)
#grid(columns: (auto, 1fr), gutter: 10pt,
  maid-plan(),
  [
    #set text(6.5pt)
    #H[Comparison]
    #table(columns: (1fr, 1.3fr, 1.3fr, 1.1fr), inset: 2.2pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      [*Criterion*], [*P1 · family WC + basins → wet room*], [*P2 · hospitality kitchen → wet room*], [*P3 · laundry's south end*],
      [Size, clear], [#r2(p1-net) m² (2.53 × 3.0)], [#r2(p2-net) m² (2.53 × 2.3)], [#r2(p3-net) m² (1.5 × 1.4)],
      [Level shower ≥ 0.9 × 1.2 · turning circle], [1.2 × 1.2 #OK · Ø 1.5 #OK], [1.2 × 1.2 #OK · Ø 1.5 #OK], [0.9 × 1.2 #OK · none #NO],
      [WC and basin inside], [WC + the two wudu basins], [WC + basin], [basin only #NO],
      [Access from the family side], [the riwaq, 3 m from the lift #OK], [the riwaq, 1 m from the lift #OK], [kitchen → laundry (service side) #NO],
      [Drain to a stack], [the west drain run / the WC stack, in place #OK], [the utility shaft, 1.5 m #OK], [the maid wing's east run #OK],
      [Ventilation], [a west window + a fan], [a west window + a fan], [mechanical only #NO],
      [Privacy], [own door; the wet end out of sight], [own door], [through the laundry #NO],
      [Rooms around], [the open wudu basins go behind a door; the rest untouched], [the hospitality kitchen and the wudu basins move: three rooms re-planned], [the laundry loses its folding and drying space],
      [Structure], [B14 becomes a drop beam over the removed wall (the engineer)], [none], [none],
      [Cost], [one wet room re-fitted, a wall out, a beam, a window], [a wet room + a kitchen moved + the WC room re-fitted], [a small shower room, a partition],
    )
    #v(2pt)
    #H[Recommendation: P1]
    - P1 gives a real accessible wet room (a level shower, a turning circle, a WC with rails, two basins) *on the family side, 3 m from the lift, on the existing drain run*, for one wall removed and one beam. Its cost is that the family's wudu basins stand behind a sliding door that is open by day. P2 does the same for three rooms re-planned; P3 is a service-side shower without a WC.
    - *P1-lite (the fallback):* keep the basins' room as it is and re-fit only the family WC room (2.53 × 1.5 clear) as a *shower + WC* (a level shower 0.9 × 1.2 at the west end, the WC at the east end, no basin inside, no turning circle): an injured person can shower on the ground floor, a wheelchair cannot turn. No structure, no window, the basins stay open.
    - *Conditions for P1:* the engineer confirms B14 as a drop beam (or a lintel) over the removed wall; the MEP engineer the floor drain's fall in the ground slab and the fan; a lever-handle sliding door; the wet room finished to the ageing-in-place list (seat, rails, non-slip floor, a night light).
    #v(2pt)
    #H[Decision needed from the owner]
    + *P1* (the family WC + basins as one accessible wet room; the basins behind a door by day, recommended), *P1-lite* (the family WC room only: shower + WC, no turning circle), or *P2* (the hospitality kitchen as the wet room, three rooms re-planned)?
    #v(3pt)
    #text(8pt)[*CLOSED 3 Nov 2026 (owner): not needed; no ground-floor shower.* #if all-ok [*Study checks passed* (#checks.len())] else [*STUDY CHECKS FAILED:* #checks.filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]]
    #v(2pt)
    #text(6pt, fill: gray)[Checks: #checks.map(c => c.at(0)).join([ · ]). The family WC's fixtures today are assumed (they are not in the files). Nothing here changes the room CSVs, the design files or the structure; every size is assumed.]
  ],
)

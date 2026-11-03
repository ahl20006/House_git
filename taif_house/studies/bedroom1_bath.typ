// bedroom1_bath.typ · Taif / Palm House V8.2 · the bedroom 1 bathroom study (design review F-05, 2 Nov 2026) · OWNER'S DECISION 2 Nov 2026: OPTION A ADOPTED
// 3 Nov 2026 (owner's brief): OPTION B4, an en-suite shower room in a "hotel layout", studied on page 3: NOT APPLIED (its acceptance criteria 2 and 3 fail in every variant: the room is a wedge).
// (no private bathroom; the wet areas stay in the two clusters; bedroom 1 keeps its size; low-level motion-sensor night lights along the route: design_ff.typ). This file is the record.
// Bedroom 1 (north-east, over the maid wing) has no bathroom; its walk to the family bath crosses the family living and the gallery.
// Option A: accept the route (the family bath, enlarged by the stair flip, is enough). Option B: a private bathroom for bedroom 1: the best position,
// the drain route to a stack, the room left with its furniture, the windows, the structure. Compare, recommend, wait for the owner's decision.
// Nothing here changes the design files. Geometry copied from data/rooms_ff.csv, data/rooms_gf.csv, studies/ff_family.typ, studies/ff_suite.typ, studies/structure.typ.
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
#let area(P) = calc.abs(range(P.len()).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, P.len())); a.at(0) * b.at(1) - b.at(0) * a.at(1) }).sum()) / 2
#let rect-pts(x0, y0, x1, y1) = ((x0, y0), (x1, y0), (x1, y1), (x0, y1))
#let plen(P) = range(P.len() - 1).map(i => calc.sqrt(calc.pow(P.at(i + 1).at(0) - P.at(i).at(0), 2) + calc.pow(P.at(i + 1).at(1) - P.at(i).at(1), 2))).sum()
#let box-overlap(a, b) = a.at(0) < b.at(2) and b.at(0) < a.at(2) and a.at(1) < b.at(3) and b.at(1) < a.at(3)
#let inside(pt, P) = { let (x, y) = pt; let c = false; for i in range(P.len()) { let (xi, yi) = P.at(i); let (xj, yj) = P.at(calc.rem(i + 1, P.len())); if (yi > y) != (yj > y) and x < (xj - xi) * (y - yi) / (yj - yi) + xi { c = not c } }; c }

// ---------- Bedroom 1 today (data/rooms_ff.csv, studies/ff_family.typ) ----------
#let bed1 = ((8.95, 1), (10.594, 1), (13.311, 6), (13.311, 6.5), (10.15, 6.5), (10.15, 5.3), (8.95, 5.3))
#let cut-x(y) = 10.594 + (13.311 - 10.594) / 5.0 * (y - 1)     // the cut wall between (10.594, 1) and (13.311, 6)
#let door = ((9.05, 5.3), (10.05, 5.3))                         // from the family link, opening into the room (north)
#let w-escape = ((10.92, 1.6), (11.79, 3.2))                    // the escape casement on the cut wall (fire study)
#let w2 = ((12.3, 4.15), (12.9, 5.25))                          // the second cut-wall window
#let furn-now = ((9.05, 1.1, 10.45, 3.1, [bed 1.4 × 2.0]), (10.5, 2.7, 10.9, 3.1, []), (10.9, 3.9, 12.0, 4.5, [desk]), (11.2, 3.35, 11.65, 3.8, []), (10.3, 5.85, 12.9, 6.4, [wardrobe wall 2.6 m]))
#let link = rect-pts(8.95, 5.3, 10.15, 6.5)
#let suite-lobby = rect-pts(8.95, 6.5, 10.3, 11.9)
#let suite-bath = ((10.3, 6.5), (12.211, 6.5), (12.211, 8), (13.311, 8), (13.311, 10.45), (10.3, 10.45))
#let suite-wc = rect-pts(12.211, 6.5, 13.311, 8)
#let stack = (13.45, 7.05)                                      // the suite bath's stack outside the east wall (studies/ff_suite.typ drains → (13.311, 7.0))
#let gf-below = ((rect-pts(10.65, 2.8, 13.311, 7.0), [GF maid room]), (rect-pts(8.95, 2.8, 10.65, 7.0), [GF laundry]), (((8.95, 1), (10.594, 1), (11.572, 2.8), (8.95, 2.8)), [GF maid bath]), (rect-pts(8.95, 7.0, 13.311, 13.0), [GF kitchen (hood on the east wall y 10.2–11.2)]))
// the walk to the family bath after the stair flip (the bath's door stays at x 4.25, y 9.3–10.3; studies/ff_family.typ "Bedroom 1 door → family bath door")
#let route-A = ((9.55, 5.3), (9.55, 5.9), (8.4, 5.9), (8.4, 3.55), (3.5, 3.55), (3.5, 8.6), (4.9, 8.6), (4.9, 9.8), (4.25, 9.8))
#let route-A-steps = ([its door], [the family link], [the family living (behind the sofa)], [the gallery's north part (past the stair arrival)], [the gallery], [the family bath's door])

// ---------- Option B positions ----------
// B2 (recommended of the B's): a bath along bedroom 1's south wall, next to the suite's wet stack; the slanted east end follows the cut wall
#let b2 = ((10.6, 5.0), (cut-x(5.0), 5.0), (13.311, 6.0), (13.311, 6.5), (10.6, 6.5))
#let b2-clear-w = 13.186 - 10.7
#let b2-clear-d = 6.4 - 5.1
#let b2-fix = ((11.9, 5.1, 12.8, 6.3, [shower 0.9 × 1.2]), (11.3, 5.75, 11.7, 6.4, [WC]), (10.7, 5.6, 11.1, 6.1, [basin]))
#let b2-door = ((10.65, 5.0), (11.65, 5.0))                     // sliding, 1.00 opening, from the room
#let b2-win = ((cut-x(5.35), 5.35), (cut-x(5.85), 5.85))        // a small window on the cut wall, sill +1.6, obscured
#let bed1-b2 = ((8.95, 1), (10.594, 1), (cut-x(5.0), 5.0), (10.6, 5.0), (10.6, 6.5), (10.15, 6.5), (10.15, 5.3), (8.95, 5.3))
#let furn-b2 = ((9.05, 1.1, 10.45, 3.1, [bed 1.4 × 2.0]), (10.5, 2.7, 10.9, 3.1, []), (10.8, 3.35, 11.9, 3.95, [desk]), (11.1, 3.95, 11.55, 4.28, []), (11.0, 4.3, 12.3, 4.9, [wardrobe 1.3]), (9.05, 3.3, 9.65, 4.2, [wardrobe 0.9]))
#let drain-b2 = ((11.5, 6.1), (12.3, 6.25), (13.0, 6.3), (13.311, 6.4), stack)
// B1: the south-east wedge by the cut wall (keeps the wardrobe wall's west end only; the second window straddles its wall)
#let b1 = ((11.2, 4.6), (cut-x(4.6), 4.6), (13.311, 6.0), (13.311, 6.5), (11.2, 6.5))
// B3: the north-east corner by the cut wall (it would take the escape window): listed, not drawn
#let b3-note = [the north-east corner (x 10.6–12.0, y 1.0–2.9) holds the room's *escape window* and the bed's head wall: a bath there moves the escape window and the bed; rejected without drawing]

// ---------- checks of this study ----------
#let checks = (
  ([B2 lies inside bedroom 1 (its vertices on or inside the room's polygon)], b2.all(p => inside((p.at(0) - 0.01 * calc.clamp(p.at(0) - 11.5, -1, 1), p.at(1) - 0.01), bed1) or inside((p.at(0) - 0.02, p.at(1) - 0.02), bed1) or inside((p.at(0) + 0.02, p.at(1) - 0.02), bed1) or inside((p.at(0) - 0.02, p.at(1) + 0.02), bed1))),
  ([B2 leaves bedroom 1 ≥ 10 m² clear (#r2(area(bed1-b2)) m² on axes)], area(bed1-b2) >= 11.5),
  ([B2's fixtures do not overlap and stay inside its clear box], range(b2-fix.len()).all(i => range(i + 1, b2-fix.len()).all(j => not box-overlap((b2-fix.at(i).at(0), b2-fix.at(i).at(1), b2-fix.at(i).at(2), b2-fix.at(i).at(3)), (b2-fix.at(j).at(0), b2-fix.at(j).at(1), b2-fix.at(j).at(2), b2-fix.at(j).at(3))))) and b2-fix.all(f => f.at(0) >= 10.7 and f.at(2) <= 13.186 and f.at(1) >= 5.1 and f.at(3) <= 6.4)),
  ([B2's shower corner stays west of the cut wall (x #r2(b2-fix.at(0).at(2)) ≤ #r2(cut-x(5.1)) at y 5.1)], b2-fix.at(0).at(2) <= cut-x(5.1)),
  ([bedroom 1's furniture after B2: inside the room, not overlapping, the door's swing square clear], furn-b2.all(f => inside(((f.at(0) + f.at(2)) / 2, (f.at(1) + f.at(3)) / 2), bed1-b2)) and range(furn-b2.len()).all(i => range(i + 1, furn-b2.len()).all(j => not box-overlap((furn-b2.at(i).at(0), furn-b2.at(i).at(1), furn-b2.at(i).at(2), furn-b2.at(i).at(3)), (furn-b2.at(j).at(0), furn-b2.at(j).at(1), furn-b2.at(j).at(2), furn-b2.at(j).at(3))))) and furn-b2.all(f => not box-overlap((9.05, 4.3, 10.05, 5.3), (f.at(0), f.at(1), f.at(2), f.at(3))))),
  ([B2's drain runs over the GF maid room only (never the kitchen's hood zone or the master bedroom) to the suite's stack #r1(plen(drain-b2)) m away], drain-b2.slice(0, 4).all(p => p.at(1) < 7.0 and p.at(0) > 10.65) and plen(drain-b2) < 4.0),
  ([the escape window stays bedroom 1's in B2 (it is north of the bath)], w-escape.at(1).at(1) < 5.0),
  ([B1's north wall (y 4.6) cuts the second window (y 4.15–5.25): a conflict to report], w2.at(0).at(1) < 4.6 and w2.at(1).at(1) > 4.6),
)
#let all-ok = checks.all(c => c.at(1))

// ---------- drawing ----------
#let q(p) = (p.at(0), -p.at(1))
#let plan(variant, length: 0.95cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, body, size: 3.6pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, body))
  let poly(P, fill: none, stroke: none) = line(..P.map(q), close: true, fill: fill, stroke: stroke)
  let R(b, fill: none, stroke: none) = rect(q((b.at(0), b.at(1))), q((b.at(2), b.at(3))), fill: fill, stroke: stroke)
  // the ground floor below (dotted) and the neighbours
  for (P, l) in gf-below { poly(P, stroke: (paint: rgb("#8a5a2b"), dash: "dotted", thickness: 0.5pt)) }
  poly(link, fill: rgb("#f2efe8"), stroke: 0.5pt + ink); T((9.55, 5.9), [link], size: 3.2pt)
  poly(suite-lobby, fill: rgb("#f2efe8"), stroke: 0.5pt + ink); T((9.62, 8.5), [suite lobby], size: 3.2pt, angle: 90deg)
  poly(suite-bath, fill: rgb("#cfe6ef"), stroke: 0.5pt + ink); T((11.6, 9.2), [suite bath], size: 3.2pt); poly(suite-wc, fill: rgb("#cfe6ef"), stroke: 0.5pt + ink); T((12.76, 7.25), [WC], size: 3pt)
  R((6.6, 1, 8.95, 3.0), fill: rgb("#f3d6c4")); T((7.8, 2.0), [kids' room], size: 3.2pt); R((6.6, 3.0, 8.95, 6.5), fill: rgb("#f6e3c0")); T((7.8, 4.75), [family living], size: 3.2pt)
  R((6.6, 6.5, 8.95, 11.0), fill: rgb("#dbe9f4")); T((7.8, 8.8), [courtyard sky], size: 3.2pt, fill: blue)
  // bedroom 1
  let room = if variant == "B2" { bed1-b2 } else { bed1 }
  poly(room, fill: rgb("#f6e3c0"), stroke: 0.7pt + ink)
  let F = if variant == "B2" { furn-b2 } else { furn-now }
  for (x0, y0, x1, y1, l) in F { R((x0, y0, x1, y1), fill: white.transparentize(20%), stroke: (paint: luma(110), thickness: 0.4pt, dash: "dashed")); T(((x0 + x1) / 2, (y0 + y1) / 2), l, size: 3pt, fill: luma(80)) }
  line(q(door.at(0)), q(door.at(1)), stroke: 2.4pt + red); line(q((door.at(0).at(0), 5.3)), q((door.at(0).at(0), 4.3)), stroke: (paint: red, thickness: 0.4pt, dash: "dotted"))
  for (a, b) in (w-escape, w2) { line(q(a), q(b), stroke: 2.4pt + blue) }
  T((11.0, 2.2), [escape\ window], size: 3pt, fill: blue, anchor: "east"); T((12.4, 4.9), [window], size: 3pt, fill: blue, anchor: "east")
  circle(q(stack), radius: 0.12, fill: rgb("#1f7a99"), stroke: none); T((13.65, 7.05), [suite stack], size: 3pt, fill: rgb("#1f7a99"), anchor: "west")
  if variant == "A" {
    line(..route-A.slice(0, 4).map(q), q((6.7, 3.55)), stroke: (paint: red, thickness: 0.8pt, dash: "dashed"), mark: (end: "stealth", fill: red, scale: 0.5))
    T((7.6, 3.3), [→ the family bath\ #r1(plen(route-A)) m], size: 3.4pt, fill: red)
    T((11.6, 3.0), [BEDROOM 1 today\ #r2(area(bed1)) m² axes · 13.9 clear], size: 3.8pt)
  }
  if variant == "B2" {
    poly(b2, fill: rgb("#cfe6ef"), stroke: 0.8pt + ink)
    for (x0, y0, x1, y1, l) in b2-fix { R((x0, y0, x1, y1), fill: white, stroke: 0.4pt + ink); T(((x0 + x1) / 2, (y0 + y1) / 2), l, size: 2.8pt) }
    line(q(b2-door.at(0)), q(b2-door.at(1)), stroke: 1.6pt + red); T((11.15, 4.85), [sliding 1.0], size: 2.8pt, fill: red)
    line(q(b2-win.at(0)), q(b2-win.at(1)), stroke: 2.4pt + blue); T((13.35, 5.6), [bath window], size: 2.8pt, fill: blue, anchor: "west")
    line(..drain-b2.map(q), stroke: (paint: rgb("#1f7a99"), thickness: 0.8pt, dash: "dashed"), mark: (end: ">", fill: rgb("#1f7a99"), scale: 0.4))
    T((11.6, 2.4), [BEDROOM 1 with B2\ #r2(area(bed1-b2)) m² axes · ≈ 10.3 clear], size: 3.8pt); T((11.95, 5.45), [BATH B2 #r2(area(b2)) m²], size: 3.4pt, fill: blue)
  }
  if variant == "B1" {
    poly(b1, fill: rgb("#cfe6ef").transparentize(30%), stroke: (paint: ink, thickness: 0.8pt, dash: "dashed"))
    T((12.2, 5.6), [B1 wedge #r2(area(b1)) m²], size: 3.2pt, fill: blue); T((12.1, 4.45), [✗ window cut], size: 2.8pt, fill: red)
    T((11.6, 2.4), [BEDROOM 1 with B1 (rejected)], size: 3.6pt)
  }
  T((6.6, -0.5), [bedroom 1 · #variant · 1 m = 0.95 cm · north up · brown dotted = the ground floor below], size: 3.4pt, fill: accent, anchor: "west")
})

// ====================================================================================== PAGE 1
#text(14pt, weight: "bold", fill: accent)[Bedroom 1's bathroom · design review F-05 · accept the route (A) or a private bathroom (B)? · Taif / Palm House V8.1 · STUDY ONLY]
#v(1pt)
#text(8pt, fill: gray)[*OPTION A ADOPTED by the owner (2 Nov 2026): no private bathroom; the wet areas stay grouped in the two clusters; night lights along the route.* 2 Nov 2026, after the stair flip (option B, F-b) · bedroom 1 is the north-east room over the maid wing, #r2(area(bed1)) m² on axes, 13.9 m² clear, one room without a bath · nothing in the design files changes until the owner decides · all sizes assumed]
#v(3pt)
#grid(columns: (auto, auto, 1fr), gutter: 8pt,
  plan("A"), plan("B2"),
  [
    #set text(6.5pt)
    #H[Option A · accept the route]
    - *The walk, measured after Part 1* (the stair flipped, the family bath enlarged northwards; its door stays at x 4.25, y 9.3–10.3): bedroom 1's door → the family link → the family living, behind the sofa → the gallery's north part, past the stair arrival → the gallery → the bath's door: *#r1(plen(route-A)) m* (the same as before the flip: the bath grew, its door did not move). Five spaces, two of them lived in (the living, the gallery).
    - *Who shares the family bath:* bedroom 1 (#r1(plen(route-A)) m), bedroom 2 (2.7 m), the kids' room and the family living (a bedroom later); bedroom 3 and the suite have their own. Since F-b it has *two compartments* (a WC by the shaft and the shower + double basin), so two children at once.
    - *Comfort:* a child or a guest in bedroom 1 crosses the *family living* at night and in the morning, in sight of whoever is there; 17 m is the longest bathroom walk in the house (the suite's is 0, bedroom 3's 2.7, bedroom 2's 2.7).
    - *Cost:* nothing; the plumbing stays as it is.
    #v(2pt)
    #H[Option B · a private bathroom: the positions tried]
    - *B2 (the best, drawn):* a bath along bedroom 1's *south wall*, x 10.6–13.311, y 5.0–6.5, its east end following the cut wall: *#r2(area(b2)) m² on axes, #r2(b2-clear-w) × #r2(b2-clear-d) clear less the slant ≈ 3.0 m²*: a walk-in shower 0.9 × 1.2 at the east end (its corner #r2(cut-x(5.1) - b2-fix.at(0).at(2)) m west of the cut wall), the WC in the middle facing north, the basin on the west wall, a *sliding 1.0 m door* from the room (no swing), a *small window on the cut wall* (y 5.35–5.85, sill +1.60, obscured). It is *next to the master suite's wet stack*: the pipes run #r1(plen(drain-b2)) m east in the bath's own floor zone to the suite's stack outside the east wall (y 7.05), *over the GF maid room only* (the kitchen and its hood zone start at y 7.0; nothing over the master bedroom).
    - *B1 (the south-east wedge, dashed on page 2):* x 11.2–13.311 on the cut wall, #r2(area(b1)) m²: a wedge, its north wall cuts the second window (y 4.15–5.25) and leaves 0.8 m of the wardrobe wall: worse than B2 for the same plumbing. *B3 (the north-east corner):* #b3-note.
    - *Bedroom 1 with B2:* *#r2(area(bed1-b2)) m² on axes, ≈ 10.3 m² clear* (was #r2(area(bed1)) / 13.9): the bed 1.4 × 2.0 stays on the west wall with its bedside table, the desk and chair under the escape window, the wardrobe wall (2.6 m) becomes *two wardrobes, 1.3 m on the bath's wall and 0.9 m on the west wall* (2.2 m in all); the door's swing stays clear; the *escape window stays the room's* (the fire study unchanged); the second window (y 4.15–5.25) lights the desk. Still a full bedroom (a 1.4 bed, a desk, 2.2 m of wardrobe), no longer a two-bed room.
  ],
)

// ====================================================================================== PAGE 2
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[Plumbing, structure and windows for B2 · B1 for the record · the comparison · recommendation · the decision needed]
#v(2pt)
#grid(columns: (auto, 1fr), gutter: 10pt,
  plan("B1", length: 0.85cm),
  [
    #set text(6.5pt)
    #H[B2 · plumbing, structure, windows]
    - *Drain:* the shower, the WC and the basin to one branch running east along the bath's south side to the *suite's stack* outside the east wall (y 7.05), #r1(plen(drain-b2)) m; the branch crosses the room's south wall line at x 13.311 and turns south outside the wall for 0.6 m (or a second stack beside the suite's; the MEP engineer). *Over the GF maid room only*: not over the kitchen (y ≥ 7.0), its hood zone (the east wall y 10.2–11.2) or the master bedroom (x 8.95–13.311, y 11.9–19.25).
    - *Structure (`studies/structure.typ`):* the maid wing's first-floor bay is a *solid 0.20 slab* spanning east–west 4.36 m to the cut wall; a 0.15 depressed zone cannot be cut from 0.20. Two ways, the engineer's choice: *(i)* cast the bay 0.35 thick under the bath with its top depressed 0.15 (as the suite bath, X10), or *(ii)* keep the slab and run the pipes *below* it in the maid room's ceiling void (the maid room gets a gypsum ceiling anyway; 3.1 m clear left) with a wall-hung WC and a shower tray raised ≈ 0.10. The bath's walls are light partitions on the slab (no beam; B6 at y 6.5 is the room's south wall beam, untouched).
    - *Windows:* the bath's small window on the cut wall faces the lane side (obscured glass, a vent); the room keeps both its windows. *Ventilation:* the window plus an extract fan to the roof riser is not available here: an extract through the cut wall (a small louvre) or a duct in the ceiling void to the east wall.
    - *Neighbours:* the maid room below hears the bath (pipes in a ceiling void: wrap them); the suite's WC closet shares the stack; the family link and the suite lobby are untouched; the family bath keeps serving bedroom 2, the kids' room and the living.
    #v(2pt)
    #H[Comparison]
    #table(columns: (1fr, 1.4fr, 1.4fr), inset: 2.2pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      [*Criterion*], [*A · accept the route*], [*B2 · a private bath along the south wall*],
      [Comfort at night, privacy], [#r1(plen(route-A)) m through the family living and the gallery, in sight of the living], [0 m; a guest never crosses the family's rooms],
      [Room size left], [#r2(area(bed1)) m² axes · 13.9 clear; 2.6 m of wardrobe; a two-bed room possible], [#r2(area(bed1-b2)) m² axes · ≈ 10.3 clear; 2.2 m of wardrobe (two pieces); one bed + desk],
      [Plumbing], [none], [#r1(plen(drain-b2)) m to the suite's stack, over the maid room only; a depressed or thickened bay, or pipes in the ceiling void],
      [Structure], [none], [the maid wing's 0.20 solid bay: thicken to 0.35 (depressed top) or keep and raise the tray; light partitions],
      [Windows], [unchanged], [a small obscured window on the cut wall; the room keeps both windows and its escape casement],
      [Cost], [nothing], [one more small bathroom (fittings, tiling, waterproofing, the slab detail, the stack connection, a vent)],
      [Effect on the neighbours], [the family bath carries four users (two compartments since F-b)], [the maid room's ceiling carries the pipes (noise: wrap); the family bath carries three users],
      [Who it suits], [bedroom 1 as a child's room in a family that shares baths], [bedroom 1 as a guest room or an older child's room; resale value],
    )
    #v(2pt)
    #H[Recommendation: B2, if bedroom 1 is to be a guest room or an older child's room; otherwise A]
    - The route is the longest in the house and crosses the living: that is the real cost of A, and the only one. B2 answers it for ≈ 3 m² of the room and one more wet room; it is the only tidy position (B1 is a wedge that cuts a window, B3 takes the escape window). *Conditions for B2:* the engineer chooses the slab detail (i) or (ii); the MEP engineer the stack connection and the vent; the wardrobe split accepted.
    - *If A:* keep the family bath as F-b (two compartments) and note in the house rules that bedroom 1's user has the family bath; nothing else to do.
    #v(2pt)
    #H[Decision needed from the owner]
    + *A* (accept the #r1(plen(route-A)) m route, no bath) or *B2* (the private bath along the south wall, ≈ 3.0 m² clear, the room 10.3 m² clear)? If B2: the slab detail is the engineer's; the wardrobe split (1.3 + 0.9 m) accepted?
    #v(3pt)
    #text(8pt)[#if all-ok [*Study checks passed* (#checks.len())] else [*STUDY CHECKS FAILED:* #checks.filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]]
    #v(2pt)
    #text(6pt, fill: gray)[Checks: #checks.map(c => c.at(0)).join([ · ]). Nothing here changes the room CSVs, the design files or the structure; every size is assumed.]
  ],
)

// ====================================================================================== PAGE 3 · B4 (3 Nov 2026): the "hotel layout" en-suite · NOT applied
// Brief: an entry zone just inside the door at the room's south side (by the link); from it TWO DOORS SIDE BY SIDE ON ONE STRAIGHT LINE (the bedroom proper, the shower room);
// the shower room ≈ 1.6 × 2.4 (level shower, wall-hung WC and basin on a service wall); the bedroom a clean rectangle ≈ 10–10.5 m² clear with a bed 1.4 × 2.0, a wardrobe ≥ 1.8,
// a desk, the escape window kept; over wet / service rooms only (the laundry, the maid bath), never over the maid room (a bedroom) or the kitchen's hood zone; short runs in the east cluster.
#let maid-x = 10.65                                                   // the GF laundry / maid room partition: wet or service rooms below only WEST of it (the laundry x 8.95–10.65), the maid bath y 1–2.8
#let clear-area(P) = area(P) - 0.1 * plen(P + (P.at(0),))           // ≈ half a 0.20 wall off every edge (the outer walls are thicker: a slightly generous figure)
// B4-a: the vestibule on the room's south strip beside the link, the shower room over the laundry; the shower room's door opens from the bedroom (the two doors are NOT on one line)
#let v-a = rect-pts(10.15, 5.3, 11.75, 6.5)
#let sr-a = rect-pts(8.95, 2.9, 10.55, 5.3)
#let bed-a = ((8.95, 1), (10.594, 1), (13.311, 6), (13.311, 6.5), (11.75, 6.5), (11.75, 5.3), (10.55, 5.3), (10.55, 2.9), (8.95, 2.9))
// B4-b: the vestibule north of the link (entered through the existing door), the shower room north of it over the laundry and the maid bath; the two doors meet at a corner, not on one line
#let v-b = rect-pts(8.95, 4.1, 10.55, 5.3)
#let sr-b = rect-pts(8.95, 1.0, 10.55, 4.1)
#let bed-b = ((10.55, 1), (10.594, 1), (13.311, 6), (13.311, 6.5), (10.15, 6.5), (10.15, 5.3), (10.55, 5.3))
// B4-c: the two doors on ONE line (the vestibule's north wall y 4.1 from the link to x 11.75): the shower room must then stand EAST of the vestibule's west part, i.e. over the maid room
#let v-c = rect-pts(8.95, 4.1, 11.75, 5.3)
#let sr-c = rect-pts(8.95, 1.7, 10.55, 4.1)
#let bed-c = ((10.55, 1), (10.594, 1), (13.311, 6), (13.311, 6.5), (10.15, 6.5), (10.15, 5.3), (11.75, 5.3), (11.75, 4.1), (10.55, 4.1))
#let over-maid-room(P) = P.any(p => p.at(0) > maid-x + 1e-6 and p.at(1) > 2.8)
#let b4 = (
  (name: "B4-a", v: v-a, sr: sr-a, bed: bed-a, line: false, note: [the shower room's door opens from the bedroom (x 10.55); the vestibule's north wall y 5.3 (x 10.15–11.75) holds only the bedroom door]),
  (name: "B4-b", v: v-b, sr: sr-b, bed: bed-b, line: false, note: [the shower room's door on the vestibule's north wall (y 4.1), the bedroom's door on its east wall (x 10.55): a corner, not one line]),
  (name: "B4-c", v: v-c, sr: sr-c, bed: bed-c, line: true, note: [both doors on y 4.1 side by side: the vestibule 2.8 × 1.2 eats the room's middle; the bedroom is two pieces round it]),
)
#let crit(x) = (
  over-wet: not over-maid-room(x.sr),
  bed-area: clear-area(x.bed) >= 10.0,
  rect: x.bed.len() == 4,
  line: x.line,
  window: w-escape.all(p => inside((p.at(0) - 0.05, p.at(1)), x.bed)),
)
#let b4-pass(x) = crit(x).values().all(v => v)
#let b4-checks = (
  ([the room's clear area (#r2(area(bed1) - 0.1 * plen(bed1 + (bed1.at(0),))) m²) cannot hold a 3.84 m² shower room + a 1.9 m² vestibule + a 10 m² bedroom (#r2(3.84 + 1.9 + 10.0 + 1.6) m² with their walls): the sum exceeds the room], area(bed1) - 0.1 * plen(bed1 + (bed1.at(0),)) < 3.84 + 1.9 + 10.0),
  ([every B4 variant fails at least one criterion (none is applied)], b4.all(x => not b4-pass(x))),
  ([B4-a and B4-b keep the shower room over the laundry / maid bath only; B4-c (the doors on one line) is also over wet rooms only but its bedroom is two pieces], b4.all(x => not over-maid-room(x.sr))),
  ([the bedroom proper stays under 10 m² clear in every variant (#b4.map(x => r2(clear-area(x.bed))).join(" / ") m²)], b4.all(x => clear-area(x.bed) < 10.0)),
)
#let plan4(x, length: 0.8cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, body, size: 3.4pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, body))
  let poly(P, fill: none, stroke: none) = line(..P.map(q), close: true, fill: fill, stroke: stroke)
  for (P, l) in gf-below { poly(P, stroke: (paint: rgb("#8a5a2b"), dash: "dotted", thickness: 0.5pt)) }
  poly(link, fill: rgb("#f2efe8"), stroke: 0.5pt + ink); T((9.55, 5.9), [link], size: 3pt)
  poly(suite-lobby, fill: rgb("#f2efe8"), stroke: 0.5pt + ink)
  poly(x.bed, fill: rgb("#f6e3c0"), stroke: 0.7pt + ink); poly(x.sr, fill: rgb("#cfe6ef"), stroke: 0.7pt + ink); poly(x.v, fill: rgb("#e4ded2"), stroke: 0.7pt + ink)
  line(q(w-escape.at(0)), q(w-escape.at(1)), stroke: 2.4pt + blue)
  let (sx0, sy0, sx1, sy1) = (x.sr.at(0).at(0), x.sr.at(0).at(1), x.sr.at(2).at(0), x.sr.at(2).at(1))
  T(((sx0 + sx1) / 2, (sy0 + sy1) / 2), [shower room\ #r2(area(x.sr)) m² axes], size: 3pt)
  let (vx0, vy0, vx1, vy1) = (x.v.at(0).at(0), x.v.at(0).at(1), x.v.at(2).at(0), x.v.at(2).at(1))
  T(((vx0 + vx1) / 2, (vy0 + vy1) / 2), [entry], size: 3pt)
  T((12.0, 3.2), [bedroom\ #r2(clear-area(x.bed)) m² clear\ (#r2(area(x.bed)) axes)], size: 3.2pt)
  T((8.95, 0.6), [#x.name · 1 m = 0.8 cm], size: 3.4pt, fill: accent, anchor: "west")
  T((9.1, 3.9), [over the laundry], size: 2.6pt, fill: rgb("#8a5a2b"), angle: 90deg); T((12.0, 5.9), [over the maid room (a bedroom)], size: 2.6pt, fill: rgb("#8a5a2b"))
})
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[B4 (3 Nov 2026) · an en-suite shower room in a "hotel layout" for bedroom 1 · studied, NOT applied: the acceptance criteria 2 and 3 fail in every variant]
#v(2pt)
#grid(columns: (auto, auto, auto), gutter: 6pt, plan4(b4.at(0)), plan4(b4.at(1)), plan4(b4.at(2)))
#v(3pt)
#grid(columns: (1.1fr, 1fr), gutter: 10pt,
  [
    #set text(6.4pt)
    #table(columns: (1.4fr, auto, auto, auto), inset: 2pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      ..([Acceptance criterion], [B4-a], [B4-b], [B4-c]).map(c => text(6pt, weight: "bold", fill: accent, c)),
      ..((("(1) over wet / service rooms only (the laundry, the maid bath), short runs in the east cluster", "over-wet"), ("(2) the bedroom a usable rectangle ≥ 10 m² clear with its furniture", "bed-area"), ("(2′) … a clean rectangle", "rect"), ("(3) the two doors side by side on one straight line; the bed not seen from the door", "line"), ("(4) the escape window kept in the bedroom", "window")).map(((l, k)) => ([#l],) + b4.map(x => if crit(x).at(k) { OK } else { NO })).flatten()),
      [bedroom clear m² (axes)], ..b4.map(x => [#r2(clear-area(x.bed)) (#r2(area(x.bed)))]),
      [shower room axes m² · entry axes m²], ..b4.map(x => [#r2(area(x.sr)) · #r2(area(x.v))]),
      [(5) structure, the suite bath, the link, the gallery], [#OK], [#OK], [#OK],
    )
    #text(5.8pt, fill: gray)[Clear ≈ axes less 0.10 m along every edge. (1) with a short new vertical in the laundry's corner (a service room of the east cluster) to the buried east branch: the suite bath's stack is 3 m away across the maid room's ceiling, so the brief's "east stack or suite stack" is met only by that new drop (acceptable: no new cluster). The bed can be hidden from the door in B4-a / B4-b (the door looks at the entry zone).]
    #v(2pt)
    #H[Why it fails: the room is a wedge]
    - Bedroom 1 is #r2(area(bed1)) m² on axes, ≈ #r2(area(bed1) - 0.1 * plen(bed1 + (bed1.at(0),))) m² clear, *wide in the south (x 8.95–13.3 at y 5.3–6.5) and narrow in the north* (the cut wall runs from (10.59, 1.0) to (13.31, 6.0)). The brief's programme is a 3.84 m² shower room + a ≈ 1.9 m² entry + a ≥ 10 m² clean rectangle = ≥ 15.7 m² with their walls: *more than the room holds*. Whatever is cut off for the shower room and the entry, the bedroom left is the wedge: 5.7–8.2 m² clear and never a clean rectangle.
    - *Criterion (3)* (the two doors on one continuous line) needs the shower room and the bedroom side by side north of the entry's wall; the only wet rooms below are the laundry (x ≤ #r2(maid-x)) and the maid bath, so the shower room must sit at x ≤ #r2(maid-x) and the bedroom door east of it on the same line: that is B4-c, whose entry (2.8 m long) cuts the room in two. B4-a and B4-b keep a usable bedroom shape but their two doors meet at a corner.
    - *Not squeezed:* no variant was made to pass by shrinking the shower room below 1.6 × 2.4, the wardrobe below 1.8 m or the door swings.
  ],
  [
    #set text(6.4pt)
    #H[The best variant, if the owner still wants an en-suite here: B4-b]
    - *B4-b:* the existing door from the link (y 5.3) opens into a 1.6 × 1.2 *entry zone*; straight ahead the *shower room* 1.6 × 3.1 on axes (#r2(area(sr-b)) m²; a level shower 1.0 × 1.4, the wall-hung WC and basin on a service wall on its east side x 10.55, the channel along it; mechanically vented: no outer wall of its own) *over the maid bath and the laundry only*, its drains down a new short vertical in the laundry's north-east corner (a service room) to the buried east branch; the *bedroom* through a door on the entry's east wall: #r2(clear-area(bed-b)) m² clear, an L with the bed 1.4 × 2.0 along the south wall (x 11.5–12.9, its head on the wall y 6.5), the desk under the escape window on the cut wall, a 1.8 m wardrobe on the service wall's bedroom side (x 10.55, y 1.3–3.1); the bed is out of sight from the link's door (it looks at the entry and the shower room's door).
    - *What it costs:* criterion (2) (≈ #r2(clear-area(bed-b)) m² instead of 10, an L) and criterion (3) (a corner, not one line). Everything else passes. *Alternative:* keep option A as decided on 2 Nov (no bath; since 3 Nov 2026 the first-floor family bath is a WC only, so bedroom 1 would have *no shower on its floor*: it would use bedroom 2's or 3's en-suite, or the suite's); or *B2 of 2 Nov* (3.0 m² along the south wall), which fails criterion (1) (over the maid room).
    - *Decision needed:* B4-b with its two failed criteria accepted, or another answer for bedroom 1's shower (e.g. a shower added to the first-floor family WC: the strip y 7.9–9.2 is 2.75 × 1.3, too small for a shower without taking bedroom 2's bath back).
    #v(3pt)
    #text(8pt)[#if b4-checks.all(c => c.at(1)) [*B4 checks passed* (#b4-checks.len())] else [*B4 CHECKS FAILED:* #b4-checks.filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]]
    #v(2pt)
    #text(6pt, fill: gray)[B4 checks: #b4-checks.map(c => c.at(0)).join([ · ]). Nothing here changes the room CSVs or the design files (B4 not applied); every size assumed, the plumbing to be designed by the plumbing engineer.]
  ],
)

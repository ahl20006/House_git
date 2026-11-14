// west_wing_ff.typ · Taif / Palm House · STUDY, rev 5 (14 Nov 2026, owner): THE PRIORITY = big, well-proportioned bedrooms 2 and 3; the baths minimal (X3); the gym gives what the rooms need.
// Rev 5 = N-lock: bedroom 3 and the gym INTERLOCK (the gym's tongue north along the gallery with its door straight from the gallery on x 4.25, no nib east of x 4.25; bedroom 3 south into the
// gym's band on the window side): L1 (the west cut y 19.75), L2 (20.05), L3 (the smallest gym that still holds the equipment). Rev 4 (14 Nov 2026, owner): rev 4 = NO entrance nib (the gym's east wall on x 4.25 like every west room, nothing built east of x 4.25
// south of the gallery, the double-height living's clerestory windows unshaded), the gallery's end the shared entry point (a glass door onto the suite court, the gym door beside it on the court's
// west wall; bedroom 3's door paired there too in N-best); options N0 / N1 / N1-b / N-best against G1; the sun on the clerestory with and without the nib. Rev 3 (14 Nov 2026, owner): the first-floor WEST BAND, bedrooms 2 and 3 with their baths BACK TO BACK between
// the two bedrooms (one shared wet wall, one stack). Rev 2 (X1–X3): the strip beside the shaft is bedroom 2's ENTRY with its gallery door inside y 9.2–10.4; two big equal
// bedrooms first, the baths may shrink; both WCs at the SOUTH end of the shared wet wall so the stack lands inside the GF powder room's WC compartment. Rev 3: X3 ADOPTED
// as the base; a strip taken from the GYM (bedroom 3's south wall, the acoustic double wall, moved 0.5 / 0.8 m south: G1 / G2 against G0), studied with the gym's entrance,
// the gallery's south end, the suite court's north strip and the roof ladder. Nothing in the design files is changed. Fixed (studies/ff_family.typ, studies/ff_suite.typ):
// the band x 0–4.25 (axes); the gallery east of x 4.25; the west shaft x 0–1.5 × y 9.2–10.4; the family WC north of y 9.2; the west outer wall; the gym's south wall y 24; the court east of x 5.8. CSV frame.
#import "@preview/cetz:0.4.2"
#import "../base.typ": dist

#set page(paper: "a4", flipped: true, margin: 8mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 7.2pt)
#set par(leading: 0.4em)
#let ink = rgb("#3d4a45"); #let accent = rgb("#2f6b4f"); #let red = rgb("#b5452f"); #let blue = rgb("#2f5f8a"); #let amber = rgb("#c98a12"); #let gray = rgb("#6d736f"); #let brown = rgb("#8a5a2b")
#let H(t) = block(above: 5pt, below: 2.5pt, text(9pt, weight: "bold", fill: accent, t))
#let r2(v) = { let s = str(calc.round(v, digits: 2)); if not s.contains(".") { s + ".00" } else if s.split(".").at(1).len() == 1 { s + "0" } else { s } }
#let r1(v) = str(calc.round(v, digits: 1))
#let ah(t) = text(font: ("Segoe UI", "Arial", "Tahoma"), lang: "ar", dir: rtl, t)
#let rect-pts(x0, y0, x1, y1) = ((x0, y0), (x1, y0), (x1, y1), (x0, y1))

// ---------- fixed geometry ----------
#let X1 = 4.25; #let Y0 = 9.2; #let YG0 = 19.25; #let YS = 24.0; #let XN = 5.8   // the band, the gym's north line today, the gym's south wall, the nib's east wall
#let shaft = rect-pts(0, 9.2, 1.5, 10.4)
#let strip = rect-pts(1.5, 9.2, X1, 10.4)                 // bedroom 2's entry (kept clear of furniture)
#let gf-below = (   // data/rooms_gf.csv (V10.0 + 10–11 Nov 2026): what stands under the band; wet / service = true
  (rect-pts(0, 7.9, 2.75, 10.4), [GF utility · shaft], true), (rect-pts(0, 10.4, 2.75, 12.9), [GF hospitality kitchen], true),
  (rect-pts(0, 12.9, 2.75, 16.1), [GF powder room], true), (rect-pts(0, 16.1, 2.75, 17.5), [GF serving passage], true),
  (rect-pts(1.25, 17.5, 2.75, 19.4), [GF guest WC], true), (rect-pts(1.25, 19.4, 2.75, 21.4), [GF guest basins], true), (rect-pts(0, 17.5, 1.25, 21.4), [GF guest passage], false), (rect-pts(0, 21.4, 2.75, 24.0), [GF foyer], false),
  (rect-pts(2.75, 7.9, 4.25, 19.25), [GF riwaq (from y 0)], false), (rect-pts(2.75, 19.25, 7.6, 24.0), [GF men's majlis (to x 13.311)], false),
)
#let gf-compartment = rect-pts(0, 14.55, 2.75, 16.1)      // the GF powder room's WC compartment (its 100 mm partition on y 14.55; the wall-hung WC on y 16.1 with the FWC stack)
#let gf-lines-y = (10.4, 12.9, 16.1, 17.5, 19.25, 19.4, 21.4)   // GF walls across the band (E–W): 19.25 the men's majlis north wall (x ≥ 2.75), 19.4 the guest WC / basins wall (x 1.25–2.75), 21.4 the foyer's
#let west-run-x = 0.5                                     // the GF buried west run (studies/plumbing.typ)
#let xw = 2.1                                             // the shared wet wall between the two baths
#let court-strip = (5.9, 19.35, 9.9, 20.55)               // studies/ff_suite.typ: the 1.2 m movement strip in front of the three court doors
#let court-furn = ((5.0, 21.7, 5.75, 22.45, [armchair]), (7.1, 20.6, 7.85, 21.35, [winter armchair]), (6.5, 21.95, 7.7, 22.65, [table]), (4.4, 23.2, 5.0, 23.8, [tree pot]), (6.0, 22.95, 8.2, 23.8, [sofa]))   // the court's west part (ff_suite.typ)

// ---------- today (studies/ff_family.typ, 14 Nov 2026) ----------
#let today = (rooms: (("Bedroom 2 bath", ((1.5, 9.2), (4.25, 9.2), (4.25, 11.0), (0, 11.0), (0, 10.4), (1.5, 10.4)), "wet"), ("Bedroom 2", rect-pts(0, 11.0, 4.25, 14.4), "bed"), ("Bedroom 3 bath", rect-pts(0, 14.4, 2.2, 16.1), "wet"), ("Bedroom 3", ((2.2, 14.4), (4.25, 14.4), (4.25, 19.25), (0, 19.25), (0, 16.1), (2.2, 16.1)), "bed")))

// ---------- helpers ----------
#let area(P) = calc.abs(range(P.len()).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, P.len())); a.at(0) * b.at(1) - b.at(0) * a.at(1) }).sum()) / 2
#let inset(P, d) = {
  let n = P.len()
  let lines = range(n).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, n)); let (dx, dy) = (b.at(0) - a.at(0), b.at(1) - a.at(1)); let L = calc.sqrt(dx * dx + dy * dy); ((a.at(0) - dy / L * d.at(i), a.at(1) + dx / L * d.at(i)), (dx, dy)) })
  range(n).map(i => { let (p1, v1) = lines.at(calc.rem(i + n - 1, n)); let (p2, v2) = lines.at(i); let den = v1.at(0) * v2.at(1) - v1.at(1) * v2.at(0); let t = ((p2.at(0) - p1.at(0)) * v2.at(1) - (p2.at(1) - p1.at(1)) * v2.at(0)) / den; (p1.at(0) + v1.at(0) * t, p1.at(1) + v1.at(1) * t) })
}
#let is-cw(P) = range(P.len()).map(i => { let a = P.at(i); let b = P.at(calc.rem(i + 1, P.len())); a.at(0) * b.at(1) - b.at(0) * a.at(1) }).sum() > 0
#let cw(P) = if is-cw(P) { P } else { P.rev() }
#let half(a, b) = if (calc.abs(a.at(0)) < 1e-6 and calc.abs(b.at(0)) < 1e-6) or (calc.abs(a.at(1) - YS) < 1e-6 and calc.abs(b.at(1) - YS) < 1e-6) { 0.125 } else { 0.10 }   // the outer walls 0.25; every other wall 0.20 (the double wall counted 0.20 on the bedroom side)
#let clear(P) = { let Q = cw(P); area(inset(Q, range(Q.len()).map(i => half(Q.at(i), Q.at(calc.rem(i + 1, Q.len())))))) }
#let bbox(P) = (calc.min(..P.map(p => p.at(0))), calc.min(..P.map(p => p.at(1))), calc.max(..P.map(p => p.at(0))), calc.max(..P.map(p => p.at(1))))
#let inside(p, P) = { let c = false; let n = P.len(); for i in range(n) { let (xi, yi) = P.at(i); let (xj, yj) = P.at(calc.rem(i + n - 1, n)); if ((yi > p.at(1)) != (yj > p.at(1))) and (p.at(0) < (xj - xi) * (p.at(1) - yi) / (yj - yi) + xi) { c = not c } }; c }
#let box-in(b, P) = { let e = 0.001; ((b.at(0) + e, b.at(1) + e), (b.at(2) - e, b.at(1) + e), (b.at(2) - e, b.at(3) - e), (b.at(0) + e, b.at(3) - e)).all(p => inside(p, P)) }
#let overlap(a, b) = not (a.at(2) <= b.at(0) + 1e-9 or b.at(2) <= a.at(0) + 1e-9 or a.at(3) <= b.at(1) + 1e-9 or b.at(3) <= a.at(1) + 1e-9)
#let no-overlaps(L) = range(L.len()).all(i => range(L.len()).all(j => i == j or not overlap(L.at(i), L.at(j))))
#let swing-box(d) = { let (a, b, dir) = (d.at(0), d.at(1), d.at(2)); let w = dist(a, b); let (x0, x1, y0, y1) = (calc.min(a.at(0), b.at(0)), calc.max(a.at(0), b.at(0)), calc.min(a.at(1), b.at(1)), calc.max(a.at(1), b.at(1)))
  if dir == (0, 0) { none } else if dir.at(1) < 0 { (x0, y0 - w, x1, y0) } else if dir.at(1) > 0 { (x0, y0, x1, y0 + w) } else if dir.at(0) > 0 { (x0, y0, x0 + w, y1) } else { (x0 - w, y0, x0, y1) } }
#let jog(P) = { let Q = cw(P); let n = Q.len(); range(n).any(i => { let a = Q.at(calc.rem(i + n - 1, n)); let b = Q.at(i); let c = Q.at(calc.rem(i + 1, n)); ((b.at(0) - a.at(0)) * (c.at(1) - b.at(1)) - (b.at(1) - a.at(1)) * (c.at(0) - b.at(0)) < -1e-6) and calc.min(dist(a, b), dist(b, c)) < 1.0 - 1e-6 }) }
#let P-of(L, n) = { let r = L.rooms.find(r => r.at(0) == n); if r == none { none } else { r.at(1) } }
#let Cz(L, n) = { let P = P-of(L, n); if P == none { 0 } else { clear(P) } }
#let Az(L, n) = { let P = P-of(L, n); if P == none { 0 } else { area(P) } }
#let bx(b) = (b.at(0), b.at(1), b.at(2), b.at(3))

// ---------- the option builder: D = the bath pair's depth on axes; yg = the gym's north line (bedroom 3's south wall); yb = the pair's north wall, solved so that the two bedrooms' clear areas match ----------
// clear areas: bedroom 2 = 4.025 (yb − 10.6) + 2.55 × 1.2 (the entry strip); bedroom 3 = 4.025 (yg − 0.2 − yb − D)  →  yb = (yg + 10.4 − D) / 2 − 0.38
#let option(short, name, D, sh, bw, note, yg: YG0, b3: "x3", yb-given: none) = {
  let yb = if yb-given != none { yb-given } else { calc.round(((yg + 10.4 - D) / 2 - 0.38) * 20) / 20 }   // to 0.05
  let ys = yb + D
  let rooms = (("Bedroom 2", ((1.5, 9.2), (X1, 9.2), (X1, yb), (0, yb), (0, 10.4), (1.5, 10.4)), "bed"), ("Bedroom 2 bath", rect-pts(0, yb, xw, ys), "wet"), ("Bedroom 3 bath", rect-pts(xw, yb, X1, ys), "wet"), ("Bedroom 3", rect-pts(0, ys, X1, yg), "bed"))
  let (sw, sd) = sh
  let furniture = (
    // bedroom 2: the bed's head on the west wall, the desk at the west window south of it, the wardrobe on the south (bath) wall east of the bath door; the entry strip by the shaft kept clear
    (0.125, 10.55, 2.125, 11.95, [bed 1.4 × 2.0], "Bedroom 2"), (0.125, 12.0, 0.525, 12.4, [], "Bedroom 2"), (2.15, 10.55, 2.55, 10.95, [], "Bedroom 2"),
    (0.125, yb - 1.0, 0.725, yb - 0.1, [desk 0.9 × 0.6], "Bedroom 2"), (0.8, yb - 0.85, 1.25, yb - 0.4, [], "Bedroom 2"), (2.0, yb - 0.7, 3.8, yb - 0.1, [wardrobe 1.8 × 0.6], "Bedroom 2"),
    // bedroom 3: the bed's head on the west wall (away from the gym's double wall), the desk at the west window south of it, the wardrobe on the gallery wall south of the door
    (0.125, ys + 0.6, 2.125, ys + 2.0, [bed 1.4 × 2.0], "Bedroom 3"), (0.125, ys + 0.15, 0.525, ys + 0.55, [], "Bedroom 3"), (0.125, ys + 2.05, 0.525, ys + 2.45, [], "Bedroom 3"),
    (0.125, yg - 1.25, 0.725, yg - 0.15, [desk 1.1 × 0.6], "Bedroom 3"),
  ) + (if b3 == "end" { ((0.8, yg - 1.45, 1.25, yg - 1.0, [], "Bedroom 3"), (1.0, yg - 0.75, 2.8, yg - 0.15, [wardrobe 1.8 × 0.6 · on the gym wall], "Bedroom 3")) } else { ((0.8, yg - 0.95, 1.25, yg - 0.5, [], "Bedroom 3"), (3.55, yg - 1.95, 4.15, yg - 0.15, [wardrobe 1.8 × 0.6], "Bedroom 3")) })
  let fixtures = (
    (0.125, yb + 0.1, 0.125 + sw, yb + 0.1 + sd, [shower #r1(sw) × #r1(sd) · screen], "Bedroom 2 bath"), (0.125, ys - 0.1 - bw, 0.475, ys - 0.1, [basin], "Bedroom 2 bath"), (1.4, ys - 0.5, 2.0, ys - 0.1, [WC], "Bedroom 2 bath"),
    (2.2, yb + 0.1, 2.2 + sw, yb + 0.1 + sd, [shower #r1(sw) × #r1(sd) · screen], "Bedroom 3 bath"), (2.2, ys - 0.5, 2.8, ys - 0.1, [WC], "Bedroom 3 bath"), (3.8, yb + 0.3, 4.15, yb + 0.3 + bw, [basin], "Bedroom 3 bath"),
  )
  let fronts = (((0.8, ys - 0.5, 1.4, ys - 0.1), 2), ((0.475, ys - 0.1 - bw, 1.075, ys - 0.1), 1), ((2.8, ys - 0.5, 3.4, ys - 0.1), 4), ((3.2, yb + 0.3, 3.8, yb + 0.3 + bw), 5))   // ≥ 0.60 in front of each WC and basin
  let doors = (
    ((X1, 9.35), (X1, 10.25), (-1, 0), [bedroom 2 door 0.90, from the gallery, in the entry strip], "Bedroom 2"),
    ((1.2, yb), (1.9, yb), (0, 1), [bath 2 door 0.70, from bedroom 2, opens into the bath], "Bedroom 2 bath"),
    ((3.0, ys), (3.7, ys), (0, -1), [bath 3 door 0.70, from bedroom 3, opens into the bath], "Bedroom 3 bath"),
  ) + (if b3 == "end" { (((X1, yg - 1.1), (X1, yg - 0.2), (-1, 0), [bedroom 3 door 0.90, at the gallery's end, paired with the glass door], "Bedroom 3"),) } else { (((X1, ys + 0.3), (X1, ys + 1.2), (-1, 0), [bedroom 3 door 0.90, from the gallery], "Bedroom 3"),) })
  let windows = (((0, 10.7), (0, 11.8), [bedroom 2 escape window, at the bed]), ((0, yb - 1.0), (0, yb - 0.2), [bedroom 2, at the desk]), ((0, yb + 0.15), (0, yb + 0.1 + sd - 0.05), [bath 2 · small, high, obscure]), ((0, ys + 0.7), (0, ys + 1.9), [bedroom 3 escape window, at the bed]), ((0, yg - 1.15), (0, yg - 0.25), [bedroom 3, at the desk]))
  let stack = (xw, ys - 0.3)   // in the shared wet wall between the two WCs, at its south end
  (short: short, name: name, yb: yb, D: D, sh: sh, bw: bw, yg: yg, note: note, rooms: rooms, furniture: furniture, fixtures: fixtures, fronts: fronts, doors: doors, windows: windows, stack: stack, gym: none)
}
// ---------- the gym (studies/ff_suite.typ v2) with its north line at yg: the band x 0–4.25 × yg–24 + the entrance nib x 4.25–5.8, 1.3 m deep (kept), the sliding gym door from the gallery's end on the nib's north wall,
// the court door on the nib's east wall (x 5.8), the roof ladder recess on the gym's east wall south of the nib; the gym's north wall ONE line across the band and the nib (choice (c)) ----------
#let with-gym(L, label) = {
  let yg = L.yg; let yn = yg + 1.3
  let poly = ((0, yg), (XN, yg), (XN, yn), (X1, yn), (X1, YS), (0, YS))
  let clear-box = (0.125, yg + 0.1, X1 - 0.1, YS - 0.125)            // the band inside its walls
  let furniture = (   // the owner's list: a treadmill 2.0 × 0.8 (its 0.5 safety zone behind), a bike, a free-weights rack, a 2.0 × 1.0 mat; the TV on the south wall; a clear 1.0 m path from the door
    (0.6, 21.675, 1.4, 23.675, [treadmill 2.0 × 0.8 → S]), (1.6, 22.5, 2.2, 23.7, [bike]), (2.6, 22.4, 4.1, 23.8, [free-weights rack 1.5 × 1.4]), (1.6, 21.25, 3.6, 22.25, [mat 2.0 × 1.0]), (0.45, 23.775, 1.65, 23.875, [TV]),
  )
  let zone = (0.6, 21.175, 1.4, 21.675)                                // the 0.5 safety zone behind the treadmill (free)
  let walk = (1.5, yg + 0.1, XN - 0.1, yg + 1.1)                      // the 1.0 m path from the gym door through the nib into the band (free)
  let gym-door = ((4.35, yg), (5.45, yg), (0, 0), [gym door 1.10, sliding, from the gallery's end], "Gym")
  let court-door = ((XN, yg + 0.25), (XN, yg + 1.15), (1, 0), [court door 0.90, from the nib, opens into the court], "Suite court")
  let ladder = (4.35, yn + 0.1, 4.70, yn + 1.4)                        // the ladder pilaster / recess on the gym's east wall, 0.1 south of the nib (ff_suite.typ: 4.35–4.70 × 20.65–21.95 today)
  let strip-west = (5.9, 19.35, 7.0, yg + 1.25)                        // the movement strip's west end, widened to the court door's south jamb when the door moves south
  (..L, gym: (label: label, poly: poly, clear-box: clear-box, furniture: furniture, zone: zone, walk: walk, gym-door: gym-door, court-door: court-door, ladder: ladder, strip-west: strip-west, yn: yn))
}
#let X1o = option("X1", [X1 · the bath pair 1.8 m deep (the W2 baths, ≈ 3.0 m² clear): showers 0.9 × 0.9], 1.8, (0.9, 0.9), 0.5, [the pair at y 13.55–15.35])
#let X2o = option("X2", [X2 · the pair 1.6 m deep (≈ 2.5 m² clear): showers 0.8 × 0.9, compact basins 0.35 deep], 1.6, (0.8, 0.9), 0.4, [the pair at y 13.65–15.25])
#let X3o = option("X3", [X3 · the smallest workable pair, 1.4 m deep (1.2 clear): showers 0.8 × 0.8, basins 0.35 deep, hinged inward doors still fit], 1.4, (0.8, 0.8), 0.4, [the pair at y 13.75–15.15])
#let X-options = (X1o, X2o, X3o)
#let G0 = with-gym(option("G0", [G0 · X3 as adopted, the gym unchanged (its north line y 19.25 on the beams B22 / B8)], 1.4, (0.8, 0.8), 0.4, [reference]), [the gym as today])
#let G1 = with-gym(option("G1", [G1 · bedroom 3's south wall (the double wall) moved 0.5 m south to y 19.75; the gym's north line one line across the band and the nib], 1.4, (0.8, 0.8), 0.4, [choice (c): the gallery extended to y 19.75, the gym door on it, the nib kept 1.3 m deep, the court door and the ladder recess 0.5 m south], yg: 19.75), [the gym −0.5 m])
#let G2 = with-gym(option("G2", [G2 · the double wall moved 0.8 m south to y 20.05; the gym's north line one line across the band and the nib], 1.4, (0.8, 0.8), 0.4, [choice (c): the gallery extended to y 20.05, the gym door on it, the nib kept 1.3 m deep, the court door and the ladder recess 0.8 m south, the strip's west end widened], yg: 20.05), [the gym −0.8 m])
#let G-options = (G0, G1, G2)
// ---------- rev 4: NO nib. The gym = the band x 0–4.25 × yg–24 only; its east wall x 4.25 the straight line of all the west rooms; the former nib's floor is court. The gallery ends at y 19.25 as today;
// at its end a GLASS DOOR onto the court (x 4.4–5.5 on y 19.25, hinged, opening into the court) and the gym door on the court's west wall right beside it (x 4.25, y yg+0.1 … yg+1.0, opening into the gym):
// "عاشق ومعشوق", two doors at one point: the family reaches the gym from the gallery through the glass door and one step of court; the owner from the court. N1-b: no glass door (a window), the gym's only door from the court.
#let with-nonib(L, label, glass: true, furn: none, walk-box: none) = {
  let yg = L.yg
  let poly = rect-pts(0, yg, X1, YS)
  let clear-box = (0.125, yg + 0.1, X1 - 0.1, YS - 0.125)
  let furniture = if furn != none { furn } else { ((0.6, 21.675, 1.4, 23.675, [treadmill 2.0 × 0.8 → S]), (1.6, 22.5, 2.2, 23.7, [bike]), (2.6, 22.4, 4.1, 23.8, [free-weights rack 1.5 × 1.4]), (1.6, 21.25, 3.6, 22.25, [mat 2.0 × 1.0]), (0.45, 23.775, 1.65, 23.875, [TV])) }
  let tr = furniture.at(0)
  let zone = (tr.at(0), tr.at(1) - 0.5, tr.at(2), tr.at(1))
  let walk = if walk-box != none { walk-box } else { (1.5, yg + 0.1, X1 - 0.1, yg + 1.1) }   // the 1.0 m path from the gym door (on the east wall at the north end) west into the band
  let gym-door = ((X1, yg + 0.1), (X1, yg + 1.0), (-1, 0), [gym door 0.90, from the court, opens into the gym], "Gym")
  let glass-door = if glass { ((4.4, YG0), (5.5, YG0), (0, 1), [glass door 1.10 at the gallery's end, opens into the court], "Suite court") } else { none }
  let ladder = (4.35, yg + 1.1, 4.70, yg + 2.4)                         // the ladder recess on the gym's east wall, 0.1 south of the gym door
  (..L, gym: (label: label, nib: false, poly: poly, clear-box: clear-box, furniture: furniture, zone: zone, walk: walk, gym-door: gym-door, court-door: gym-door, glass-door: glass-door, ladder: ladder, yn: yg))
}
#let N0 = with-nonib(option("N0", [N0 · no nib; bedroom 3 / gym wall on y 19.25 (on the beams B22 + B8); the glass door at the gallery's end, the gym door beside it from the court], 1.4, (0.8, 0.8), 0.4, [X3; the gym's east wall on x 4.25, nothing east of it south of the gallery]), [no nib, y 19.25])
#let N1 = with-nonib(option("N1", [N1 · no nib; the wall on y 19.75 (−0.5, a light double gypsum acoustic wall on the slab, Rw ≥ 55); the glass door at the gallery's end, the gym door beside it], 1.4, (0.8, 0.8), 0.4, [X3; the gym 0.5 m shallower], yg: 19.75), [no nib, y 19.75])
#let N1b = with-nonib(option("N1-b", [N1-b · as N1, but NO glass door at the gallery's end (a window): the gym's only door from the suite court], 1.4, (0.8, 0.8), 0.4, [for comparison: the gym reached only through the suite], yg: 19.75), [no nib, y 19.75, court only], glass: false)
#let Nb = with-nonib(option("N-best", [N-best · N1 + bedroom 3's door moved to the gallery's end: three doors at one point (bedroom 3 west, the glass door south, the gym just beyond it)], 1.4, (0.8, 0.8), 0.4, [X3; the gallery's end the one entry point of the south-west corner], yg: 19.75, b3: "end"), [no nib, y 19.75, paired doors])
#let N-options = (N0, N1, N1b, Nb)
// ---------- rev 5: N-LOCK. The gym = the band x 0–4.25 × yw–24 + a TONGUE x 3.05–4.25 × yt–yw north along the gallery side; the gym door on x 4.25 straight from the gallery inside the tongue
// (y yt+0.1 … yt+1.0; the gallery ends at y 19.25 as today, so yt = 18.15); bedroom 3 = the full width from the bath pair to yt + the west alcove x 0–3.05 × yt–yw (the bed under the window);
// bedroom 3's door on x 4.25 north of the tongue, the wardrobe on the tongue's north wall; the gym's court door on the tongue's east wall (it costs nothing); the glass door at the gallery's end kept.
#let XT = 3.05; #let YT = 18.15
#let lock(short, name, yw, yb, gfurn, note) = {
  let L = option(short, name, 1.4, (0.8, 0.8), 0.4, note, yg: 24.0, yb-given: yb)
  let ys = yb + 1.4
  let bed3 = ((0, ys), (X1, ys), (X1, YT), (XT, YT), (XT, yw), (0, yw))
  let gym = ((0, yw), (XT, yw), (XT, YT), (X1, YT), (X1, YS), (0, YS))
  let rooms = L.rooms.filter(r => r.at(0) != "Bedroom 3") + (("Bedroom 3", bed3, "bed"), ("Gym", gym, "gym"))
  let furniture = L.furniture.filter(f => f.at(5) != "Bedroom 3") + (
    (0.125, YT + 0.1, 2.125, YT + 1.5, [bed 1.4 × 2.0 · in the alcove], "Bedroom 3"), (2.2, YT + 0.1, 2.6, YT + 0.5, [], "Bedroom 3"),
    (0.125, ys + 0.2, 0.725, ys + 1.3, [desk 1.1 × 0.6], "Bedroom 3"), (0.8, ys + 0.45, 1.25, ys + 0.9, [], "Bedroom 3"),
    (2.35, YT - 0.7, 4.15, YT - 0.1, [wardrobe 1.8 × 0.6 · on the tongue's wall], "Bedroom 3"),
  )
  let doors = L.doors.slice(0, 3) + (((X1, YT - 1.8), (X1, YT - 0.9), (-1, 0), [bedroom 3 door 0.90, from the gallery, north of the tongue], "Bedroom 3"),)
  let windows = L.windows.slice(0, 3) + (((0, YT + 0.3), (0, YT + 1.3), [bedroom 3, at the bed (the alcove)]), ((0, ys + 0.3), (0, ys + 1.2), [bedroom 3, at the desk]))
  let clear-box = (0.125, yw + 0.1, X1 - 0.1, YS - 0.125)
  let tongue = (XT + 0.1, YT + 0.1, X1 - 0.1, yw + 0.1)
  let tr = gfurn.at(0)
  let g = (label: [N-lock], nib: false, lock: true, poly: gym, clear-box: clear-box, extra: (tongue.at(2) - tongue.at(0)) * (tongue.at(3) - tongue.at(1)), tongue: tongue, furniture: gfurn, zone: (tr.at(0), tr.at(1) - 0.5, tr.at(2), tr.at(1)),
    walk: (XT + 0.1, YT + 0.1, X1 - 0.1, yw + 0.15), gym-door: ((X1, YT + 0.1), (X1, YT + 1.0), (-1, 0), [gym door 0.90, straight from the gallery, into the tongue], "Gym"),
    court-door: ((X1, 19.35), (X1, 20.25), (-1, 0), [court door 0.90, into the tongue], "Gym"), glass-door: ((4.4, YG0), (5.5, YG0), (0, 1), [glass door 1.10 at the gallery's end], "Suite court"),
    ladder: (4.35, 20.35, 4.70, 21.65), yn: YG0, wall: ((0, yw), (XT, yw), (XT, YT), (X1, YT)), yw: yw)
  (..L, rooms: rooms, furniture: furniture, doors: doors, windows: windows, gym: g, yg: 24.0, parts: ("Bedroom 3": ((0, ys, X1, YT), (0, YT, XT, yw)), "Gym": ((0, yw, X1, YS), (XT, YT, X1, yw))))
}
#let gf-deep = ((0.6, 21.675, 1.4, 23.675, [treadmill 2.0 × 0.8 → S]), (1.6, 22.5, 2.2, 23.7, [bike]), (2.6, 22.4, 4.1, 23.8, [free-weights rack 1.5 × 1.4]), (1.6, 21.25, 3.6, 22.25, [mat 2.0 × 1.0]), (0.45, 23.775, 1.65, 23.875, [TV]))
#let gf-min = ((0.6, 21.6, 1.4, 23.6, [treadmill 2.0 × 0.8 → S]), (1.5, 21.1, 2.5, 23.1, [mat 1.0 × 2.0]), (2.7, 21.2, 3.3, 22.4, [bike]), (2.6, 22.5, 4.1, 23.8, [weights rack 1.5 × 1.3]), (0.45, 23.775, 1.65, 23.875, [TV]))
// equal rooms: bedroom 2 = 4.025 (yb − 10.6) + 3.06; bedroom 3 = 4.025 (YT − 0.2 − yb − 1.4) + 2.825 (yw − YT)  →  yb = 13.575 + (2.825 (yw − YT) − 3.06) / 8.05
#let yb-lock(yw) = calc.round((13.575 + (2.825 * (yw - YT) - 3.06) / 8.05) * 20) / 20
#let L1o = lock("L1", [L1 · N-lock: the west cut at y 19.75, the tongue 1.2 wide (x 3.05–4.25) from y 18.15; the gym door straight from the gallery], 19.75, yb-lock(19.75), gf-deep, [the bath pair re-centred; the gym 0.5 m shallower on the window side, 1.1 m longer on the gallery side])
#let L2o = lock("L2", [L2 · N-lock: the west cut at y 20.05, the tongue 1.2 wide from y 18.15], 20.05, yb-lock(20.05), gf-deep, [the gym 0.8 m shallower on the window side])
#let L3o = lock("L3", [L3 · N-lock: the largest bedrooms the gym can give · the west cut at y 21.0 (the band 2.78 m clear), the tongue from y 18.15], 21.0, yb-lock(21.0), gf-min, [the smallest gym that still holds the owner's equipment])
#let L-options = (L1o, L2o, L3o)
#let N1d = with-nonib(option("N1-deep", [N1-deep · the third way: no tongue, the wall at y 21.0 (the gym as in L3), the gym door from the court: L3's areas with N1's shape], 1.4, (0.8, 0.8), 0.4, [for the owner's judgement: the areas of L3, the proportions of N1], yg: 21.0), [no nib, y 21.0], furn: ((0.6, 21.6, 1.4, 23.6, [treadmill 2.0 × 0.8 → S]), (1.5, 21.1, 2.5, 23.1, [mat 1.0 × 2.0]), (2.6, 22.6, 3.2, 23.8, [bike]), (3.3, 22.4, 4.1, 23.8, [weights rack 0.8 × 1.4]), (0.45, 23.775, 1.65, 23.875, [TV])), walk-box: (2.6, 21.1, X1 - 0.1, 22.1))
#let bed3-main(L) = { let ys = L.yb + L.D; if L.gym != none and L.gym.at("lock", default: false) { [4.03 × #r2(YT - ys - 0.2) + the alcove 2.83 × #r2(L.gym.yw - YT)] } else { [4.03 × #r2(L.yg - ys - 0.2)] } }
#let bed3-ratio(L) = { let ys = L.yb + L.D; let d = if L.gym != none and L.gym.at("lock", default: false) { YT - ys - 0.2 } else { L.yg - ys - 0.2 }; calc.max(4.025, d) / calc.min(4.025, d) }
#let bed2-ratio(L) = 4.025 / (L.yb - 10.6)
#let free-floor(L, n) = Cz(L, n) - L.furniture.filter(f => f.at(5) == n).map(f => (f.at(2) - f.at(0)) * (f.at(3) - f.at(1))).sum()
#let today-furn = (bed2: 2.8 + 0.36 + 0.72 + 1.08, bed3: 0.63 + 2.8 + 0.32 + 0.96 + 0.72 + 0.225)   // studies/ff_family.typ: bedroom 2 (bed, desk, two tables, wardrobe), bedroom 3 (two wardrobes, bed, two tables, desk, chair)

#let court-area(L) = if L.gym.at("nib", default: true) { 5.75 * 4.75 - 1.55 * 1.3 } else { 5.75 * 4.75 }
#let glass-of(L) = L.gym.at("glass-door", default: none)
#let glass-ok(L) = { let g = L.gym; if glass-of(L) == none { true } else { let sw = swing-box(glass-of(L)); (court-furn.map(bx) + (g.ladder, swing-box(g.gym-door))).all(b => not overlap(b, sw)) } }
#let family-ok(L) = glass-of(L) != none   // the family reaches the gym without passing through the suite
// ---------- the sun on the double-height living's clerestory windows (the court's north wall y 19.25; x 6.0–7.0 and 7.6–8.6; sill +5.00, head +6.00 = 1.40–2.40 above the court floor +3.60; studies/sections.typ) ----------
// the nib (x 4.25–5.8 × y 19.25–20.55, its roof +7.2 = 3.6 m above the court floor) stands WEST of the windows: its shadow falls on them when the sun is west of south (the afternoon).
// shadow of the nib's south-east top corner (5.8, 20.55, 3.6) on the plane y 19.25: x = 5.8 + 1.3 tan A, z = 3.6 − 1.3 tan h / cos A (A = the sun's azimuth west of south, h its altitude); the shaded part of a window = the rectangle below z and west of x (an estimate: the real edge is slanted)
#let lat = 21.4deg
#let sun(dec, hour) = { let Hh = (hour - 12) * 15deg; let sh = calc.sin(lat) * calc.sin(dec) + calc.cos(lat) * calc.cos(dec) * calc.cos(Hh); let h = calc.asin(sh); let ca = (sh * calc.sin(lat) - calc.sin(dec)) / (calc.cos(h) * calc.cos(lat)); let A = calc.acos(calc.max(-1, calc.min(1, ca))); (h, A) }   // h altitude, A azimuth from south (positive = west, by the afternoon hour)
#let nib-h = 3.6; #let nib-d = 1.3; #let cl = ((6.0, 7.0), (7.6, 8.6)); #let cl-z = (1.4, 2.4)
#let shade(dec, hour, win) = { let (h, A) = sun(dec, hour); if h <= 0deg or A >= 90deg { 0 } else { let reach = 5.8 + nib-d * calc.tan(A); let top = nib-h - nib-d * calc.tan(h) / calc.cos(A); let fx = calc.max(0, calc.min(win.at(1), reach) - win.at(0)) / (win.at(1) - win.at(0)); let fz = calc.max(0, calc.min(cl-z.at(1), top) - cl-z.at(0)) / (cl-z.at(1) - cl-z.at(0)); fx * fz } }
#let sun-rows = ((-23.44deg, 12, [21 Dec, solar noon]), (-23.44deg, 13, [21 Dec, 13:00]), (-23.44deg, 14, [21 Dec, 14:00]), (-23.44deg, 15, [21 Dec, 15:00]), (-23.44deg, 16, [21 Dec, 16:00]), (0deg, 15, [21 Mar / Sep, 15:00]), (23.44deg, 12, [21 Jun, solar noon]), (23.44deg, 15, [21 Jun, 15:00]))
#let direct(dec, hour) = { let (h, A) = sun(dec, hour); h > 0deg and A < 90deg }   // the south-facing windows see the sun only while it is south of east–west


// ---------- checks ----------
#let band-of(L) = rect-pts(0, Y0, X1, L.yg)
#let tile-ok(L) = calc.abs(area(band-of(L)) - area(shaft) - L.rooms.map(r => area(r.at(1))).sum()) < 0.01 and no-overlaps(L.rooms.map(r => L.at("parts", default: (:)).at(r.at(0), default: (bbox(r.at(1)),))).join())   // L-shaped rooms give their rectangular parts
#let in-rooms(L, items) = items.all(f => { let P = P-of(L, f.at(5)); P != none and box-in(bx(f), P) })
#let fix-ok(L) = in-rooms(L, L.fixtures) and no-overlaps(L.fixtures.map(bx))
#let furn-ok(L) = in-rooms(L, L.furniture) and no-overlaps(L.furniture.map(bx))
#let swings-ok(L) = L.doors.map(swing-box).all(s => (L.furniture + L.fixtures).map(bx).all(b => not overlap(s, b)))
#let fronts-ok(L) = L.fronts.all(((b, i)) => { let P = P-of(L, L.fixtures.at(i).at(5)); box-in(b, P) and L.fixtures.enumerate().all(((j, f)) => j == i or not overlap(b, bx(f))) })
#let shower-ok(L) = L.sh.at(0) >= 0.8 - 1e-6 and L.sh.at(1) >= 0.8 - 1e-6
#let equal-ok(L) = calc.abs(Cz(L, "Bedroom 2") - Cz(L, "Bedroom 3")) <= 0.3 + 1e-6
#let stack-ok(L) = inside(L.stack, gf-compartment)
#let strip-ok(L) = L.furniture.map(bx).all(b => not overlap(b, bbox(strip)))
#let jog-ok(L) = L.rooms.all(r => not jog(r.at(1)))
#let checks(L) = (
  ([the rooms and the shaft tile the band, no overlaps; no small jog in any room], tile-ok(L) and jog-ok(L)),
  ([fixtures inside their baths, no overlaps; ≥ 0.60 clear in front of each WC and basin; showers ≥ 0.8 × 0.8], fix-ok(L) and fronts-ok(L) and shower-ok(L)),
  ([furniture inside its rooms, no overlaps; bedroom 2's entry strip clear], furn-ok(L) and strip-ok(L)),
  ([every door leaf swings clear of furniture and fixtures], swings-ok(L)),
  ([the two bedrooms within 0.3 m² clear (#r2(Cz(L, "Bedroom 2")) / #r2(Cz(L, "Bedroom 3")))], equal-ok(L)),
  ([the stack lands inside the GF powder room's WC compartment (y > 14.55)], stack-ok(L)),
)
#let gym-clear(G) = { let g = G.gym; let b = g.clear-box; (b.at(2) - b.at(0)) * (b.at(3) - b.at(1)) + g.at("extra", default: if g.at("nib", default: true) { (XN - 0.1 - (X1 + 0.1)) * (g.yn - 0.1 - (G.yg + 0.1)) } else { 0 }) }
#let gym-checks(G) = { let g = G.gym; let boxes = g.furniture.map(bx); (
  ([the gym furniture inside the band's clear box, no overlaps], boxes.all(b => box-in(b, rect-pts(..g.clear-box))) and no-overlaps(boxes)),
  ([the 0.5 m zone behind the treadmill free], boxes.all(b => not overlap(b, g.zone))),
  ([a 1.0 m clear path from the gym door into the band], boxes.all(b => not overlap(b, g.walk))),
  ([the court door's swing clear of the court's furniture and the ladder recess], (court-furn.map(bx) + (g.ladder,)).all(b => not overlap(b, swing-box(g.court-door)))),
  ([the court door on the 1.2 m strip], (g.court-door.at(0).at(1) + g.court-door.at(1).at(1)) / 2 <= court-strip.at(3) + 1e-6),
) }
#let all-ok(L) = checks(L).all(c => c.at(1))
#let gym-all-ok(G) = gym-checks(G).all(c => c.at(1))
#let walls-on-gf(L) = (L.yb, L.yb + L.D).filter(y => gf-lines-y.any(g => calc.abs(g - y) < 1e-6))
#let walls-off-gf(L) = (L.yb, L.yb + L.D).filter(y => not gf-lines-y.any(g => calc.abs(g - y) < 1e-6))

// ---------- drawing (1.0 cm / m, as the presentation's sheet 04) ----------
#let q(p) = (p.at(0), -p.at(1))
#let fillc = (bed: rgb("#f6e3c0"), wet: rgb("#cfe6ef"), gym: rgb("#d9e4f2"))
#let plan(L, length: 1.0cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, body, size: 4.4pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, body))
  let poly(P, fill: none, stroke: none) = line(..P.map(q), close: true, fill: fill, stroke: stroke)
  let R(b, fill: none, stroke: none) = rect(q((b.at(0), b.at(1))), q((b.at(2), b.at(3))), fill: fill, stroke: stroke)
  let has-gym = L.gym != none
  let ymax = if has-gym { 24.4 } else { 20.3 }
  rect(q((-0.7, 7.5)), q((if has-gym { 7.8 } else { 6.2 }, ymax)), fill: rgb("#f3efe6"), stroke: none)
  for x in range(0, if has-gym { 8 } else { 6 }) { line(q((x, 7.7)), q((x, ymax - 0.2)), stroke: 0.2pt + luma(220)); T((x, 7.55), str(x), size: 3.6pt, fill: gray) }
  for y in range(8, int(ymax)) { line(q((-0.3, y)), q((if has-gym { 7.6 } else { 6.0 }, y)), stroke: 0.2pt + luma(220)); T((-0.45, y), str(y), size: 3.6pt, fill: gray, anchor: "east") }
  for (P, l, wet) in gf-below { if has-gym or bbox(P).at(1) < 19.3 { poly(P, stroke: (paint: brown, dash: "dotted", thickness: 0.5pt)) } }
  poly(gf-compartment, fill: rgb("#f0d9c0").transparentize(60%), stroke: (paint: brown, dash: "dotted", thickness: 0.5pt)); T((1.4, 14.45), [GF WC compartment y 14.55–16.1 (below)], size: 3pt, fill: brown)
  rect(q((0, 7.9)), q((2.75, 9.2)), fill: luma(236), stroke: 0.8pt + ink); T((1.4, 8.55), [family WC], size: 4pt, fill: gray)
  rect(q((2.75, 7.9)), q((4.25, 9.2)), fill: rgb("#f2efe8"), stroke: 0.8pt + ink)
  let yend = if L.gym == none or L.gym.at("nib", default: true) { L.yg } else { YG0 }
  rect(q((4.25, 7.9)), q((5.8, yend)), fill: rgb("#f2efe8"), stroke: 0.8pt + ink); T((5.02, 13.5), [gallery (on the projection) · 1.55 · ends at y #r2(yend)], size: 4pt, fill: gray, angle: 90deg)
  if has-gym {
    let g = L.gym
    let nib = g.at("nib", default: true)
    rect(q((if nib { 5.8 } else { 4.25 }, 19.25)), q((7.6, 24.0)), fill: rgb("#eef5e8"), stroke: 0.8pt + ink); T((6.9, 23.3), [suite court (to x 10)], size: 4pt, fill: gray)
    if not nib { T((5.0, 20.1), [court · the nib's place], size: 3.2pt, fill: accent) }
    R(court-strip, fill: none, stroke: (paint: accent, thickness: 0.4pt, dash: "dotted")); if L.yg > YG0 and nib { R(g.strip-west, fill: rgb("#eef5e8"), stroke: (paint: accent, thickness: 0.4pt, dash: "dotted")) }
    T((6.5, 19.5), [the 1.2 m strip], size: 3.2pt, fill: accent)
    poly(g.poly, fill: rgb("#d9e4f2"), stroke: 0.9pt + ink)
    let wall = g.at("wall", default: ((0, L.yg), (X1, L.yg)))
    line(..wall.map(q), stroke: 3.2pt + red); T((1.5, wall.at(0).at(1) - 0.18), [the acoustic wall · y #r2(wall.at(0).at(1))#if g.at("lock", default: false) [ · the tongue from y #r2(YT)]], size: 3.4pt, fill: red)
    let ygn = if g.at("lock", default: false) { g.yw } else { L.yg }
    R(g.walk, fill: none, stroke: (paint: accent, thickness: 0.4pt, dash: "dotted")); T(((g.walk.at(0) + g.walk.at(2)) / 2, (g.walk.at(1) + g.walk.at(3)) / 2), [1.0 m path], size: 3.2pt, fill: accent, angle: if g.at("lock", default: false) { 90deg } else { 0deg })
    R(g.zone, fill: none, stroke: (paint: amber, thickness: 0.4pt, dash: "dotted")); T((1.0, 21.42), [0.5 zone], size: 3pt, fill: amber)
    for (x0, y0, x1, y1, l) in g.furniture { R((x0, y0, x1, y1), fill: rgb("#fbf6ea"), stroke: 0.45pt + rgb("#8a7a5a")); T(((x0 + x1) / 2, (y0 + y1) / 2), l, size: 3.3pt, angle: if (y1 - y0) > (x1 - x0) * 1.4 { 90deg } else { 0deg }) }
    for (x0, y0, x1, y1, l) in court-furn { R((x0, y0, x1, y1), fill: white, stroke: (paint: luma(140), thickness: 0.4pt, dash: "dashed")); T(((x0 + x1) / 2, (y0 + y1) / 2), l, size: 3pt, fill: gray) }
    R(g.ladder, fill: rgb("#c9a86a"), stroke: 0.5pt + ink); T((g.ladder.at(2) + 0.08, (g.ladder.at(1) + g.ladder.at(3)) / 2), [ladder recess], size: 3pt, fill: brown, anchor: "west", angle: 90deg)
    if nib {
      let gd = g.gym-door; line(q(gd.at(0)), q(gd.at(1)), stroke: 1.8pt + red); T((4.9, L.yg - 0.2), [gym door (sliding)], size: 3.2pt, fill: red)
      let cd = g.court-door; line(q(cd.at(0)), q(cd.at(1)), stroke: 3pt + red); R(swing-box(cd), stroke: (paint: red, thickness: 0.35pt, dash: "dashed"))
    } else {
      let gd = g.gym-door; line(q(gd.at(0)), q(gd.at(1)), stroke: 3pt + red); R(swing-box(gd), stroke: (paint: red, thickness: 0.35pt, dash: "dashed"))
      if g.at("lock", default: false) { T((3.65, YT + 1.2), [gym door · from the gallery], size: 3.0pt, fill: red); let cd = g.court-door; line(q(cd.at(0)), q(cd.at(1)), stroke: 3pt + red); R(swing-box(cd), stroke: (paint: red, thickness: 0.35pt, dash: "dashed")); T((3.65, 20.45), [court door], size: 3.0pt, fill: red) } else { T((3.6, L.yg + 1.25), [gym door, from the court], size: 3.2pt, fill: red) }
      if g.glass-door != none { let gl = g.glass-door; line(q(gl.at(0)), q(gl.at(1)), stroke: 3pt + blue); R(swing-box(gl), stroke: (paint: blue, thickness: 0.35pt, dash: "dashed")); T((5.0, 19.05), [glass door → court], size: 3.2pt, fill: blue) } else { line(q((4.5, YG0)), q((5.5, YG0)), stroke: (paint: blue, thickness: 2.2pt, dash: "dashed")); T((5.0, 19.05), [window · no door], size: 3.2pt, fill: blue) }
      line(q((4.25, 19.25)), q((4.25, YS)), stroke: 1.2pt + ink)
    }
    T(if g.at("lock", default: false) { (3.6, g.yw + 0.45) } else { (2.1, 22.9) }, [*Gym* #r2(area(g.poly)) · ≈ #r2(gym-clear(L)) clear], size: 4.4pt)
    line(q((0, 7.9)), q((0, YS)), stroke: 2pt + ink); line(q((0, YS)), q((7.6, YS)), stroke: 2pt + ink)
    for (a, b) in (((0, calc.max(19.6 + ygn - YG0, ygn + 0.35)), (0, calc.min(20.9 + ygn - YG0, 21.8))), ((0, 22.0), (0, 23.5)), ((2.0, YS), (3.9, YS))) { if b.at(1) > a.at(1) + 0.3 { line(q(a), q(b), stroke: (paint: blue, thickness: 2.2pt, dash: "dashed")) } }
  } else {
    rect(q((0, 19.25)), q((4.25, 20.3)), fill: rgb("#d9e4f2"), stroke: 0.8pt + ink); T((2.1, 19.8), [gym · the acoustic double wall on y 19.25], size: 4pt, fill: gray)
    line(q((0, 7.9)), q((0, 20.3)), stroke: 2pt + ink)
  }
  for (n, P, k) in L.rooms.filter(r => r.at(2) != "gym") { poly(P, fill: fillc.at(k), stroke: 0.9pt + ink) }
  R(bbox(strip), fill: none, stroke: (paint: accent, thickness: 0.4pt, dash: "dotted")); T((2.9, 9.45), [entry · kept clear], size: 3.4pt, fill: accent)
  poly(shaft, fill: luma(205), stroke: 0.9pt + ink); T((0.75, 9.8), [west shaft], size: 4pt)
  line(q((xw, L.yb)), q((xw, L.yb + L.D)), stroke: 2.4pt + blue)
  for (x0, y0, x1, y1, l, rm) in L.furniture { R((x0, y0, x1, y1), fill: rgb("#fbf6ea"), stroke: 0.45pt + rgb("#8a7a5a")); T(((x0 + x1) / 2, (y0 + y1) / 2), l, size: 3.4pt, angle: if (y1 - y0) > (x1 - x0) * 1.4 { 90deg } else { 0deg }) }
  for (b, i) in L.fronts { R(b, fill: none, stroke: (paint: blue, thickness: 0.3pt, dash: "dotted")) }
  for (x0, y0, x1, y1, l, rm) in L.fixtures { R((x0, y0, x1, y1), fill: white, stroke: 0.45pt + blue); T(((x0 + x1) / 2, (y0 + y1) / 2), l, size: 3.1pt, fill: blue, angle: if (y1 - y0) > (x1 - x0) * 1.4 { 90deg } else { 0deg }) }
  for d in L.doors { line(q(d.at(0)), q(d.at(1)), stroke: 3pt + red); let s = swing-box(d); if s != none { R(s, stroke: (paint: red, thickness: 0.35pt, dash: "dashed")) } }
  for (a, b, l) in L.windows { line(q(a), q(b), stroke: (paint: blue, thickness: 2.2pt, dash: "dashed")) }
  circle(q(L.stack), radius: 0.14, fill: brown, stroke: none); T((L.stack.at(0) + 0.2, L.stack.at(1) + 0.22), [stack], size: 3.6pt, fill: brown, anchor: "west")
  for y in gf-lines-y { if y < L.yg + 2 { line(q((-0.6, y)), q((-0.35, y)), stroke: 1pt + brown); T((-0.62, y), [GF], size: 3pt, fill: brown, anchor: "east") } }
  for (n, P, k) in L.rooms.filter(r => r.at(2) != "gym") { let c = if n == "Bedroom 2" { (2.9, 12.3) } else if n == "Bedroom 3" { (2.3, L.yb + L.D + 1.9) } else if n == "Bedroom 2 bath" { (1.35, L.yb + 0.95) } else { (3.3, L.yb + L.D - 0.85) }
    T(c, [*#n*\ #r2(area(P)) · ≈ #r2(clear(P))], size: if k == "wet" { 3.4pt } else { 4.4pt }) }
  line(q((0, ymax + 0.3)), q((1, ymax + 0.3)), stroke: 1pt + ink); T((0.5, ymax + 0.55), [1 m], size: 4pt)
})
#let AC(L, n) = { let P = P-of(L, n); if P == none { [—] } else { [#r2(area(P)) · *#r2(clear(P))*] } }
#let gain(L, n) = { let v = Cz(L, n) - Cz(today, n); [#if v >= 0 [+] #r2(v)] }

// ======================= PAGE 1 · rev 5: N-lock, the biggest well-proportioned bedrooms =======================
#let RT = (N1, Nb, L1o, L2o, L3o, N1d)
#let AC(L, n) = { let P = P-of(L, n); if P == none { [—] } else { [#r2(area(P)) · *#r2(clear(P))*] } }
#let gain(L, n) = { let v = Cz(L, n) - Cz(today, n); [#if v >= 0 [+] #r2(v)] }
#let is-lock(L) = L.gym != none and L.gym.at("lock", default: false)
#text(13pt, weight: "bold", fill: accent)[First-floor west band, rev 5 · N-lock: bedroom 3 and the gym interlocked · the biggest well-proportioned bedrooms] #h(1fr) #text(6.6pt, fill: gray)[study · 14 Nov 2026 · nothing in the design files changed · m² on axes · *clear* inside the walls]
#v(1pt) #line(length: 100%, stroke: 0.6pt + accent)
#grid(columns: (1.25fr, 1fr), column-gutter: 10pt,
  [
    #table(columns: (1.4fr, 0.8fr, 0.85fr, 0.85fr, 0.9fr, 0.9fr, 0.9fr, 0.9fr), stroke: 0.3pt + luma(190), inset: 2.0pt, align: (left, right, right, right, right, right, right, right), fill: (_, y) => if y == 0 { rgb("#e1e9e3") } else if calc.even(y) { rgb("#efece4") },
      table.header([*axes · clear m²*], [*Today*], [*N1*], [*N-best*], [*L1*], [*L2*], [*L3*], [*N1-deep*]),
      [The gym's north line], [19.25 + nib], [19.75], [19.75], [19.75 W · tongue from 18.15], [20.05 W · tongue 18.15], [21.00 W · tongue 18.15], [21.00, no tongue],
      [Bedroom 2 (with its entry strip)], AC(today, "Bedroom 2"), ..RT.map(L => AC(L, "Bedroom 2")),
      [… main clear width × depth · ratio], [4.03 × 3.20 · 1.26], ..RT.map(L => [4.03 × #r2(L.yb - 10.6) · #r2(bed2-ratio(L))]),
      [… free floor after the furniture], [#r2(Cz(today, "Bedroom 2") - today-furn.bed2)], ..RT.map(L => [#r2(free-floor(L, "Bedroom 2"))]),
      [Bedroom 3], AC(today, "Bedroom 3"), ..RT.map(L => AC(L, "Bedroom 3")),
      [… main clear width × depth · ratio], [4.03 × 2.95 (+ entry) · 1.37], ..RT.map(L => [#bed3-main(L) · #r2(bed3-ratio(L))]),
      [… free floor after the furniture], [#r2(Cz(today, "Bedroom 3") - today-furn.bed3)], ..RT.map(L => [#r2(free-floor(L, "Bedroom 3"))]),
      [Gains over today (clear)], [—], ..RT.map(L => [#gain(L, "Bedroom 2") · #gain(L, "Bedroom 3")]),
      [Baths 2 · 3 (clear, X3)], [#r2(Cz(today, "Bedroom 2 bath")) · #r2(Cz(today, "Bedroom 3 bath"))], ..RT.map(L => [#r2(Cz(L, "Bedroom 2 bath")) · #r2(Cz(L, "Bedroom 3 bath"))]),
      [Gym, axes · clear], [22.20 · 19.70], ..RT.map(L => [#r2(area(L.gym.poly)) · *#r2(gym-clear(L))*]),
      [Gym door], [sliding, nib], [court, 19.85–20.75], [court, 19.85–20.75], [gallery, x 4.25 y 18.25–19.15], [gallery, 18.25–19.15], [gallery, 18.25–19.15], [court, 21.1–22.0 (off the strip)],
      [Court door · glass door at the gallery's end], [— · —], [the same door · 1.10], [the same door · 1.10], [19.35–20.25 · 1.10], [19.35–20.25 · 1.10], [19.35–20.25 · 1.10], [the same door · 1.10],
      [Bedroom 3's door (x 4.25) at y], [15.2–16.2], ..RT.map(L => { let d = L.doors.at(3); [#r2(d.at(0).at(1))–#r2(d.at(1).at(1))] }),
      [Built east of x 4.25 south of the gallery], [the nib], [nothing], [nothing], [nothing], [nothing], [nothing], [nothing],
      [Walls on the beams B22 / B8 (y 19.25)], [the double wall], [none], [none], [none (the tongue's west wall crosses B8)], [none], [none], [none],
      [Checks: bedrooms (6) · gym (5) · doors], [—], ..RT.map(L => [#if all-ok(L) [ok] else [FAIL: #checks(L).filter(c => not c.at(1)).map(c => c.at(0)).join([; ])] · #if gym-all-ok(L) [ok] else [#gym-checks(L).filter(c => not c.at(1)).map(c => c.at(0)).join([; ])] · #if glass-ok(L) [ok] else [clash]]),
    )
    #v(2pt)
    #text(6.3pt, fill: gray)[All options carry X3 (the bath pair 1.4 m deep, the stack into the GF WC compartment, bedroom 2's entry by the shaft), the pair re-centred so the bedrooms stay equal within 0.3 m². Bedroom 2's "main" = the room without its entry strip; bedroom 3's "main" in L1–L3 = the full-width part north of the tongue, + the west alcove x 0–3.05 south of it. Free floor = clear area − the bed, the bedside tables, the desk and chair, the wardrobe. Ratio = the longer side / the shorter side of the main part (the owner's target 1.0–1.3). The gym checks: the equipment inside the band, the 0.5 m zone behind the treadmill, the path from the door (L1–L3: the tongue, 1.0 m clear), the court door's swing and the strip; doors: the glass door's swing clear of the gym door, the ladder and the court's furniture.]
    #v(2pt)
    #H[How the interlock works, and what it costs]
    #text(6.4pt)[
      - *The tongue* x 3.05–4.25 runs north along the gallery to y 18.15 so that the gym door (0.90, x 4.25, y 18.25–19.15) opens straight from the gallery, which ends at y 19.25 as today: nothing east of x 4.25, the clerestory keeps its winter sun (page 11). The tongue is the gym's 1.0 m entrance corridor and takes 1.1 m² of bedroom 3; the west cut returns the band's window side south of y 19.25 (2.83 m wide): 1.4 m² in L1, 2.3 in L2, 5.0 in L3. The court door on the tongue's east wall (y 19.35–20.25) costs nothing and is kept; the glass door at the gallery's end stays for the family's way onto the winter court; the ladder recess sits 0.1 m south of the court door; nothing else in the court moves.
      - *Bedroom 3* becomes an L: the full-width part (4.03 wide) from the bath pair to the tongue's wall at y 18.15, and the *bed alcove* on the window side south of it. Its door on x 4.25 north of the tongue (y 16.35–17.25); entering, the tongue's wall is ahead-left with the *wardrobe 1.8 × 0.6 on it* (0.7 m of its back past the tongue's corner as joinery), the bed in the alcove under its window, the desk at the north-west window; the bed's head is west, no door faces it.
      - *The price in proportion:* to keep the two bedrooms equal, every square metre the alcove wins moves the bath pair south and shortens bedroom 3's full-width part: #r2(YT - L1o.yb - 1.6) m in L1, #r2(YT - L2o.yb - 1.6) m in L2, #r2(YT - L3o.yb - 1.6) m in L3, against 4.03 m of width (ratios #r2(bed3-ratio(L1o)), #r2(bed3-ratio(L2o)), #r2(bed3-ratio(L3o))). Bedroom 2 keeps its proportion.
    ]
  ],
  [
    #box(fill: accent.lighten(86%), stroke: 1pt + accent, inset: 6pt, radius: 3pt, width: 100%)[
      #text(9.5pt, weight: "bold", fill: accent)[The study's view (the owner decides; his priority is the bedrooms' size)] \
      #text(6.8pt)[
        *By area* L3 wins: #r2(Cz(L3o, "Bedroom 2")) and #r2(Cz(L3o, "Bedroom 3")) m² clear (+#r2(Cz(L3o, "Bedroom 2") - Cz(today, "Bedroom 2")) and +#r2(Cz(L3o, "Bedroom 3") - Cz(today, "Bedroom 3")) on today), with the gym cut to #r2(gym-clear(L3o)) m² and the treadmill's zone touching the mat. *By proportion* it loses: bedroom 3's full-width part is only #r2(YT - L3o.yb - 1.6) m deep (ratio #r2(bed3-ratio(L3o))) in front of a 2.83 × 2.85 alcove, a dumb-bell rather than a room; L1 and L2 give less area than N1 for the same reason (the tongue's 1.1 m² is paid before the alcove earns). *N1 / N-best* give the best-proportioned bedroom 3 (4.03 × 4.05, ratio 1.0, #r2(Cz(N1, "Bedroom 3")) m², free floor #r2(free-floor(N1, "Bedroom 3"))) and the same bedroom 2 (ratio #r2(bed2-ratio(N1))), for a gym door reached through the court's corner.
        \ *The study's view:* if the owner wants the bedrooms big AND well-proportioned, N-best (or N1) is the answer; the interlock is worth it only for the direct gallery door, and then L1, whose bedroom 3 still reads as a 4.0 × 2.8 room with a bed alcove, not L3. A third way, if the owner wants the biggest rooms with N1's shape: the gym as small as in L3 (its north wall at y 21.0) but *without a tongue*, the gym door from the court beside the glass door: the whole bath pair and bedroom 3 move south together and both rooms grow: bedroom 2 4.03 × #r2(N1d.yb - 10.6) (#r2(Cz(N1d, "Bedroom 2")) m²), bedroom 3 4.03 × #r2(21.0 - N1d.yb - 1.6) (#r2(Cz(N1d, "Bedroom 3")) m²), ratios #r2(bed2-ratio(N1d)) and #r2(bed3-ratio(N1d)): #r2(Cz(N1d, "Bedroom 3") - Cz(L3o, "Bedroom 3")) m² more than L3 in each room, because no tongue is paid for. It is N1 with the wall at y 21.0, drawn on page 5 as *N1-deep*; its one cost: the gym door lies 1.5 m south of the court's door strip, reached along the court's west side (the strip rule it fails is that one).
      ]
    ]
    #v(3pt)
    #box(fill: rgb("#f4efe3"), stroke: 0.6pt + luma(170), inset: 5pt, radius: 3pt, width: 100%)[
      #ah[
        #text(8.5pt, weight: "bold", fill: accent)[الخلاصة بالعربية] \
        #text(7.0pt)[
          أولوية المالك (14 نوفمبر 2026): غرفتا نوم كبيرتان بنسب جيدة (الطول إلى العرض نحو 1 : 1.0–1.3)، الحمّامان في حدّهما الأدنى (X3)، والنادي يعطي ما تحتاجه الغرفتان. فكرة المالك "عاشق ومعشوق": غرفة النوم 3 والنادي متشابكان: لسان النادي شمالًا بجانب الممر وبابه منه مباشرة على x 4.25 بلا عتبة شرق x 4.25، وغرفة النوم 3 جنوبًا في جهة النوافذ. \
          *L1:* القطع الغربي على y 19.75؛ الغرفتان #r2(Cz(L1o, "Bedroom 2")) و#r2(Cz(L1o, "Bedroom 3")) م²، النادي #r2(gym-clear(L1o)) م²؛ غرفة 3 على شكل L: جزء كامل العرض 4.03 × #r2(YT - L1o.yb - 1.6) م وفجوة سرير 2.83 × 1.6 م. \
          *L2:* القطع على y 20.05؛ الغرفتان #r2(Cz(L2o, "Bedroom 2")) و#r2(Cz(L2o, "Bedroom 3")) م²، النادي #r2(gym-clear(L2o)) م². \
          *L3:* أكبر ما يعطيه النادي (القطع على y 21.0): الغرفتان #r2(Cz(L3o, "Bedroom 2")) و#r2(Cz(L3o, "Bedroom 3")) م²، النادي #r2(gym-clear(L3o)) م² بالكاد يحوي الأجهزة؛ لكن الجزء كامل العرض من غرفة 3 يصير #r2(YT - L3o.yb - 1.6) م فقط. \
          *رأي الدراسة:* للمساحة والنسب معًا N-best (أو N1)؛ التشابك يستحق فقط لأجل الباب المباشر من الممر، وعندها L1 لا L3؛ وطريق ثالث: N1 بالجدار على y 21.0 بلا لسان (N1-deep، الصفحة 5): الغرفتان #r2(Cz(N1d, "Bedroom 2")) و#r2(Cz(N1d, "Bedroom 3")) م² بنسب N1، أكبر من L3 لأن لا لسان يُدفع ثمنه؛ باب النادي من الفناء بعيدًا 1.5 م عن شريط الأبواب.
        ]
      ]
    ]
  ],
)

// ======================= PAGES 2–4 · L1, L2, L3 · PAGE 5 · N1-deep =======================
#let N1d-ok = { let g = N1d.gym; g.furniture.map(bx).all(b => box-in(b, rect-pts(..g.clear-box))) }
#for L in (L1o, L2o, L3o, N1d) [
  #pagebreak()
  #text(12pt, weight: "bold", fill: accent)[#L.name] #h(1fr) #text(6.6pt, fill: gray)[1 : 100 (1.0 cm / m, as sheet 04) · CSV frame, north up · #L.note]
  #v(1pt) #line(length: 100%, stroke: 0.6pt + accent)
  #grid(columns: (auto, 1fr), column-gutter: 12pt,
    plan(L),
    [
      #let ys = L.yb + L.D
      #let g = L.gym
      #let lk = is-lock(L)
      #let d3 = L.doors.at(3)
      #set text(6.6pt)
      #H[Clear sizes and areas]
      #table(columns: (1.4fr, 1.1fr, 1.1fr, 0.8fr, 1.2fr), stroke: 0.3pt + luma(190), inset: 2.2pt, align: (left, right, right, right, right), fill: (_, y) => if y == 0 { rgb("#e1e9e3") } else if calc.even(y) { rgb("#efece4") },
        table.header([*Room*], [*axes w × d*], [*main clear w × d*], [*clear m²*], [*free floor*]),
        [Bedroom 2 (+ the entry strip)], [4.25 × #r2(L.yb - 10.4) (L)], [4.03 × #r2(L.yb - 10.6) · ratio #r2(bed2-ratio(L))], [*#r2(Cz(L, "Bedroom 2"))*], [#r2(free-floor(L, "Bedroom 2")) (today #r2(Cz(today, "Bedroom 2") - today-furn.bed2))],
        [Bedroom 3], [#if lk [4.25 × #r2(YT - ys) + 3.05 × #r2(g.yw - YT) (L)] else [4.25 × #r2(L.yg - ys)]], [#bed3-main(L) · ratio #r2(bed3-ratio(L))], [*#r2(Cz(L, "Bedroom 3"))*], [#r2(free-floor(L, "Bedroom 3")) (today #r2(Cz(today, "Bedroom 3") - today-furn.bed3))],
        [Bath 2 · bath 3 (X3)], [2.10 · 2.15 × 1.40], [1.88 · 1.95 × 1.20], [#r2(Cz(L, "Bedroom 2 bath")) · #r2(Cz(L, "Bedroom 3 bath"))], [—],
        [Gym], [#if lk [band 4.25 × #r2(YS - g.yw) + tongue 1.20 × #r2(g.yw - YT)] else [4.25 × #r2(YS - L.yg)]], [#if lk [4.03 × #r2(YS - 0.125 - g.yw - 0.1) + 1.00 × #r2(g.yw - YT)] else [4.03 × #r2(YS - 0.125 - L.yg - 0.1)]], [*#r2(gym-clear(L))*], [the equipment: #if gym-all-ok(L) [fits] else [see the checks]],
      )
      *Checks:* bedrooms #if all-ok(L) [passed (#checks(L).len())] else [FAILED: #checks(L).filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]; gym #if gym-all-ok(L) [passed (#gym-checks(L).len())] else [FAILED: #gym-checks(L).filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]; the doors at the gallery's end #if glass-ok(L) [clear of each other, the ladder and the court's furniture] else [CLASH]. The bath pair y #r2(L.yb)–#r2(ys), the stack at y #r2(L.stack.at(1)) inside the GF WC compartment (#r2(L.stack.at(1) - 14.55) m south of its partition).
      #H[Doors at the gallery's end · the rooms]
      - #if lk [*The gym door 0.90* on x 4.25 straight from the gallery (y 18.25–19.15, opening into the tongue, its leaf against the tongue's east wall); the tongue (1.0 m clear, #r2(g.yw - YT) m long) is the path into the band. *The court door 0.90* on the tongue's east wall (y 19.35–20.25, into the tongue; its swing inside the gym, on the strip): kept, it costs nothing. *The glass door 1.10* at the gallery's end onto the court (y 19.25): kept for the family's way onto the winter court; its swing (4.4–5.5 × 19.25–20.35) is clear of the court door (which opens inward), the ladder recess (y 20.35–21.65) and the winter armchair.] else [*The gym door 0.90* on the court's west wall (x 4.25, y #r2(g.gym-door.at(0).at(1))–#r2(g.gym-door.at(1).at(1)), into the gym) beside *the glass door 1.10* at the gallery's end: the family through the glass door and one step of court, the owner from the court; the ladder recess at y #r2(g.ladder.at(1))–#r2(g.ladder.at(3)).]
      - *Bedroom 3's door 0.90* on x 4.25 at y #r2(d3.at(0).at(1))–#r2(d3.at(1).at(1)), opening into the room; #if lk [0.9 m north of the tongue's wall, which carries the wardrobe (1.8 × 0.6, 0.7 m of its back as joinery past the tongue's corner) that one faces on entering; the bed 1.4 × 2.0 in the west alcove (x 0.125–2.125, y #r2(YT + 0.1)–#r2(YT + 1.5)) under its window, its head on the west wall; the desk 1.1 × 0.6 at the north-west window. Two purposeful steps in the bedroom 3 / gym wall (y #r2(g.yw) → x 3.05 → y #r2(YT)), both returns ≥ 1.0 m: no sliver.] else [beside the bath pair; the bed's head on the west wall, the desk at the south-west window, the wardrobe on the gallery wall south of the door.] No door faces a bed head.
      - *Bedroom 2* as X3: the entry by the shaft, the bed's head on the west wall, the desk at the west window, the wardrobe on the bath wall; #r2(free-floor(L, "Bedroom 2")) m² of free floor.
      #H[Gym · sun · structure · court]
      - *Gym* #r2(gym-clear(L)) m² clear: #if lk [the band 4.03 × #r2(YS - 0.125 - g.yw - 0.1) south of y #r2(g.yw) plus the tongue; the treadmill with its 0.5 m zone against the west wall, the mat, the bike and the rack in the band's east part, the path = the tongue (1.0 m) into the band (checked).] else [the band 4.03 × #r2(YS - 0.125 - L.yg - 0.1); the treadmill with its 0.5 m zone, the mat, the bike and the rack; a 1.0 m path from the door (checked).] #if L.short == "L3" or L.short == "N1-deep" [The band is at its minimum: the treadmill's zone (0.5) and the front gap (0.25) just fit the 2.78 m; the rack 1.5 × 1.3 and the bike beside the mat; a smaller gym would lose one item.]
      - *Sun:* the gym's east wall is the straight line x 4.25 from y #if lk [#r2(YT)] else [#r2(L.yg)] to 24; nothing is built east of it south of the gallery: the clerestory windows keep their winter afternoon sun (page 11).
      - *Structure:* #if lk [the three bedroom 3 / gym walls (y #r2(g.yw) west part, x 3.05 the tongue's west wall, y 18.15 the tongue's north wall) are light double gypsum acoustic walls (two independent stud leaves, mineral wool, Rw ≥ 55, ≈ 0.8 kN/m) on the men's majlis roof slab and the west slab; none stands on the beams B22 / B8 (the tongue's west wall crosses B8 at y 19.25); the gym's east wall x 4.25 on B19 as today; the bath pair's walls as in X3.] else [the acoustic wall at y #r2(L.yg) a light double gypsum wall on the men's majlis roof slab, #r2(L.yg - YG0) m south of the beams B22 / B8; the gym's east wall on B19.] No column or beam moved; the nib's partitions and R21 not built.
      - *The court:* 27.31 m² on axes (the nib's place is court); the strip y 19.35–20.55 with the bedroom's door, the office door, #if lk [the court door into the tongue and the glass door at its west end;] else [the gym door and the glass door at its west end;] the ladder recess at y #r2(g.ladder.at(1))–#r2(g.ladder.at(3)); the winter armchairs, the table and the seating untouched.
    ],
  )
]

// ======================= PAGE 6 · rev 4 =======================
#pagebreak()
#let NT = (G1, N0, N1, N1b, Nb)
#let col-head = ([*Today*], [*G1*], [*N0*], [*N1*], [*N1-b*], [*N-best*])
#let nib-of(L) = L.gym.at("nib", default: true)
#let AC(L, n) = { let P = P-of(L, n); if P == none { [—] } else { [#r2(area(P)) · *#r2(clear(P))*] } }
#let w-shade(L) = if nib-of(L) { shade(-23.44deg, 15, cl.at(0)) } else { 0 }
#text(13pt, weight: "bold", fill: accent)[Rev 4 · no entrance nib · paired doors at the gallery's end · the sun on the clerestory (pages 6–11)] #h(1fr) #text(6.6pt, fill: gray)[study · 14 Nov 2026 · nothing in the design files changed · m² on axes · *clear* inside the walls]
#v(1pt) #line(length: 100%, stroke: 0.6pt + accent)
#grid(columns: (1.25fr, 1fr), column-gutter: 10pt,
  [
    #table(columns: (1.45fr, 0.8fr, 0.9fr, 0.9fr, 0.9fr, 0.9fr, 1fr), stroke: 0.3pt + luma(190), inset: 2.2pt, align: (left, right, right, right, right, right, right), fill: (_, y) => if y == 0 { rgb("#e1e9e3") } else if calc.even(y) { rgb("#efece4") },
      table.header([*axes · clear m²*], ..col-head),
      [Bedroom 3 / gym wall on y], [19.25], ..NT.map(L => [#r2(L.yg)]),
      [Nib x 4.25–5.8], [yes], ..NT.map(L => if nib-of(L) [yes] else [*no*]),
      [Bedroom 2 (with its entry strip)], AC(today, "Bedroom 2"), ..NT.map(L => AC(L, "Bedroom 2")),
      [Bedroom 3], AC(today, "Bedroom 3"), ..NT.map(L => AC(L, "Bedroom 3")),
      [… gains over today (clear)], [—], ..NT.map(L => [#gain(L, "Bedroom 2") · #gain(L, "Bedroom 3")]),
      [Baths 2 · 3 (clear)], [#r2(Cz(today, "Bedroom 2 bath")) · #r2(Cz(today, "Bedroom 3 bath"))], ..NT.map(L => [#r2(Cz(L, "Bedroom 2 bath")) · #r2(Cz(L, "Bedroom 3 bath"))]),
      [Gym, axes · clear], [22.20 · 19.70], ..NT.map(L => [#r2(area(L.gym.poly)) · *#r2(gym-clear(L))*]),
      [Gym band, clear w × d], [4.03 × 4.53], ..NT.map(L => [4.03 × #r2(YS - 0.125 - L.yg - 0.1)]),
      [Gallery ends at y · its length], [19.25 · 18.55], ..NT.map(L => if nib-of(L) [#r2(L.yg) · #r2(L.yg - 0.7)] else [19.25 · 18.55]),
      [Gym door], [sliding, from the gallery (nib)], ..NT.map(L => if nib-of(L) [sliding, from the gallery (nib)] else [x 4.25, y #r2(L.yg + 0.1)–#r2(L.yg + 1.0), from the court]),
      [Glass door at the gallery's end], [—], ..NT.map(L => if nib-of(L) [— (the nib's door)] else if glass-of(L) == none [none (a window)] else [1.10, y 19.25]),
      [Bedroom 3's door (x 4.25) at y], [15.2–16.2], ..NT.map(L => { let d = L.doors.at(3); [#r2(d.at(0).at(1))–#r2(d.at(1).at(1))] }),
      [The family reaches the gym], [from the gallery], ..NT.map(L => if nib-of(L) [from the gallery] else if family-ok(L) [glass door + 1 step of court] else [*through the suite only*]),
      [Suite court, axes], [25.30], ..NT.map(L => [#r2(court-area(L))]),
      [Ladder recess on the gym's east wall, y], [20.65–21.95], ..NT.map(L => [#r2(L.gym.ladder.at(1))–#r2(L.gym.ladder.at(3))]),
      [West clerestory window shaded, 21 Dec 15:00], [#calc.round(shade(-23.44deg, 15, cl.at(0)) * 100)%], ..NT.map(L => [#calc.round(w-shade(L) * 100)%]),
      [The double wall stands on], [B22 + B8], ..NT.map(L => if L.yg == YG0 [B22 + B8] else [the slab, #r2(L.yg - YG0) off]),
      [Checks: bedrooms (6) · gym (5) · doors], [—], ..NT.map(L => [#if all-ok(L) [ok] else [FAIL] · #if gym-all-ok(L) [ok] else [#gym-checks(L).filter(c => not c.at(1)).map(c => c.at(0)).join([; ])] · #if glass-ok(L) [ok] else [clash]]),
    )
    #v(2pt)
    #text(6.3pt, fill: gray)[Today / G1 = pages 12–15 (the nib kept). N0–N-best carry X3 (the bath pair 1.4 m deep, the stack into the GF WC compartment, bedroom 2's entry by the shaft), the pair re-centred. Gym checks: the furniture inside the band, the 0.5 m zone behind the treadmill free, a 1.0 m path from the door, the court door's swing clear of the court's furniture and the ladder, the court door within the 1.2 m strip. Doors: the glass door's swing clear of the gym door's swing, the ladder and the court's furniture. Shading = the share of the west clerestory window's area in the nib's shadow (page 11).]
    #v(2pt)
    #H[The gallery's end (عاشق ومعشوق)]
    #text(6.6pt)[
      - *Without the nib* the gym cannot have a door from the gallery: the gallery ends at y 19.25 on the court's edge, and the gym is west of x 4.25 south of that line, so the two only touch at the column C19. The one straight way in is *through the court's corner*: a glass door at the gallery's end onto the court and the gym door on the court's west wall right beside it (one step of court, 0.6 m, under the sky and the first-floor roof edge: a small canopy or the mashrabiya's shade, to detail). The family: gallery → glass door → gym; the owner: court → gym. N1-b shows the alternative without the glass door: the gym is then reached only through the suite bedroom or the office, which is no family gym.
      - *N-best* moves bedroom 3's door to the gallery's end as well (x 4.25, y 18.65–19.55): three doors at one point, no vestibule, no corridor; bedroom 3's wardrobe goes onto the gym wall and the door opens on the bed's foot side (the head is on the west wall). The gallery keeps its full 1.55 m to the glass door; nothing is built east of x 4.25 south of it; the court gains the nib's 2.0 m².
    ]
  ],
  [
    #box(fill: accent.lighten(86%), stroke: 1pt + accent, inset: 6pt, radius: 3pt, width: 100%)[
      #text(9.5pt, weight: "bold", fill: accent)[The study's view (the owner decides): N-best] \
      #text(6.9pt)[
        Removing the nib does three things at once: the gym's east wall becomes the one straight line x 4.25 of all the west rooms; the west clerestory window of the double-height living gets its winter afternoon sun back (today the nib covers #calc.round(shade(-23.44deg, 15, cl.at(0)) * 100)% of it at 15:00 on 21 Dec, #calc.round(shade(-23.44deg, 14, cl.at(0)) * 100)% at 14:00; the east window and the noon sun were never touched); the court gains 2.0 m². The price is the gym's door: from the court's corner through the glass door, one step outside. N-best adds bedroom 3's door at the same point, so the gallery's end is the whole south-west corner's entry and the gallery's last 3 m has no door on its west wall but that one. With the wall on y 19.75 the bedrooms reach #r2(Cz(Nb, "Bedroom 2")) and #r2(Cz(Nb, "Bedroom 3")) m² clear (+#r2(Cz(Nb, "Bedroom 2") - Cz(today, "Bedroom 2")) and +#r2(Cz(Nb, "Bedroom 3") - Cz(today, "Bedroom 3"))) and the gym keeps #r2(gym-clear(Nb)) m² with the owner's list fitted. *N0* is the same with the wall on its beams (the bedrooms #r2(Cz(N0, "Bedroom 2")) / #r2(Cz(N0, "Bedroom 3")), the gym #r2(gym-clear(N0))). *G1* keeps the nib and its shade.
      ]
    ]
    #v(3pt)
    #box(fill: rgb("#f4efe3"), stroke: 0.6pt + luma(170), inset: 5pt, radius: 3pt, width: 100%)[
      #ah[
        #text(8.5pt, weight: "bold", fill: accent)[الخلاصة بالعربية] \
        #text(7.0pt)[
          نقاط المالك (14 نوفمبر 2026): عتبة مدخل النادي (x 4.25–5.8) تحجب شمس نوافذ الصالة العلوية على فناء الجناح، فتُدرس إزالتها: جدار النادي الشرقي على x 4.25 كبقية الغرف الغربية؛ ونهاية الممر نقطة الدخول المشتركة: باب زجاجي على الفناء وباب النادي بجانبه ("عاشق ومعشوق"). \
          *N0:* بلا عتبة، الجدار على y 19.25 فوق الجسرين؛ الغرفتان #r2(Cz(N0, "Bedroom 2")) و#r2(Cz(N0, "Bedroom 3")) م²، النادي #r2(gym-clear(N0)) م²؛ باب النادي من الفناء بجانب الباب الزجاجي. \
          *N1:* بلا عتبة، الجدار على y 19.75 (جدار جبسي مزدوج عازل على البلاطة)؛ الغرفتان #r2(Cz(N1, "Bedroom 2")) و#r2(Cz(N1, "Bedroom 3")) م²، النادي #r2(gym-clear(N1)) م². \
          *N1-b:* كما N1 بلا باب زجاجي: لا تصل العائلة إلى النادي إلا عبر الجناح؛ للمقارنة فقط. \
          *N-best (رأي الدراسة):* N1 مع باب غرفة النوم 3 عند نهاية الممر أيضًا: ثلاثة أبواب في نقطة واحدة بلا ممر ضائع؛ نافذة الصالة الغربية تستعيد شمس بعد الظهر شتاءً (العتبة تحجب #calc.round(shade(-23.44deg, 15, cl.at(0)) * 100)% منها الساعة 15:00 في 21 ديسمبر).
        ]
      ]
    ]
  ],
)

// ======================= PAGES 2–5 · N0, N1, N1-b, N-best =======================
#for L in N-options [
  #pagebreak()
  #text(12pt, weight: "bold", fill: accent)[#L.name] #h(1fr) #text(6.6pt, fill: gray)[1 : 100 (1.0 cm / m, as sheet 04) · CSV frame, north up · #L.note]
  #v(1pt) #line(length: 100%, stroke: 0.6pt + accent)
  #grid(columns: (auto, 1fr), column-gutter: 12pt,
    plan(L),
    [
      #let ys = L.yb + L.D
      #let g = L.gym
      #let d3 = L.doors.at(3)
      #set text(6.6pt)
      #H[Clear sizes and areas]
      #table(columns: (1.4fr, 1fr, 1fr, 1fr, 1fr), stroke: 0.3pt + luma(190), inset: 2.2pt, align: (left, right, right, right, right), fill: (_, y) => if y == 0 { rgb("#e1e9e3") } else if calc.even(y) { rgb("#efece4") },
        table.header([*Room*], [*axes w × d*], [*clear w × d*], [*axes m²*], [*clear m²*]),
        [Bedroom 2 (+ the entry strip 2.55 × 1.20)], [4.25 × #r2(L.yb - 10.4) (L)], [4.03 × #r2(L.yb - 10.6)], [#r2(Az(L, "Bedroom 2"))], [*#r2(Cz(L, "Bedroom 2"))* (today #r2(Cz(today, "Bedroom 2")): #gain(L, "Bedroom 2"))],
        [Bedroom 3], [4.25 × #r2(L.yg - ys)], [4.03 × #r2(L.yg - ys - 0.2)], [#r2(Az(L, "Bedroom 3"))], [*#r2(Cz(L, "Bedroom 3"))* (today #r2(Cz(today, "Bedroom 3")): #gain(L, "Bedroom 3"))],
        [Bath 2 · bath 3 (X3)], [2.10 · 2.15 × 1.40], [1.88 · 1.95 × 1.20], [#r2(Az(L, "Bedroom 2 bath")) · #r2(Az(L, "Bedroom 3 bath"))], [*#r2(Cz(L, "Bedroom 2 bath")) · #r2(Cz(L, "Bedroom 3 bath"))*],
        [Gym (no nib)], [4.25 × #r2(YS - L.yg)], [4.03 × #r2(YS - 0.125 - L.yg - 0.1)], [#r2(area(g.poly))], [*#r2(gym-clear(L))*],
        [Suite court (the nib's place now court)], [5.75 × 4.75], [5.55 × 4.53], [#r2(court-area(L))], [—],
      )
      *Checks:* bedrooms #if all-ok(L) [passed (#checks(L).len())] else [FAILED: #checks(L).filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]; gym #if gym-all-ok(L) [passed (#gym-checks(L).len())] else [FAILED: #gym-checks(L).filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]; the doors at the gallery's end #if glass-ok(L) [clear of each other, the ladder and the court's furniture] else [CLASH]. The bath pair y #r2(L.yb)–#r2(ys), the stack at y #r2(L.stack.at(1)) inside the GF WC compartment.
      #H[The gallery's end and its doors]
      - *The gallery* ends at y 19.25 as today (18.55 m from the linen cupboard), its full 1.55 m to the end wall; #if g.glass-door != none [in that wall the *glass door 1.10* (x 4.4–5.5, hinged, opening into the court; its swing 4.4–5.5 × 19.25–20.35 on the court's corner, clear of the gym door's swing, the ladder recess and the winter armchair at x 7.1).] else [that wall is solid with a window: no door onto the court.]
      - *The gym door 0.90* on the court's west wall (the gym's east wall x 4.25), y #r2(g.gym-door.at(0).at(1))–#r2(g.gym-door.at(1).at(1)), opening into the gym; #if g.glass-door != none [#r2(g.gym-door.at(0).at(1) - YG0 - 0.1) m south of the glass door's jamb: the two doors at one point, one step of court between them (a canopy or the mashrabiya's shade over that step, to detail); the family: gallery → glass door → gym; the owner: court → gym.] else [reached from the court only: the family passes through the suite bedroom or the office: no family gym.] Inside, a 1.0 m path along the north wall to the equipment (checked).
      - *Bedroom 3's door 0.90* at y #r2(d3.at(0).at(1))–#r2(d3.at(1).at(1)) on x 4.25, opening into the room (the leaf against the bath wall side); the bed's head on the west wall, so no door faces it. #if L.doors.at(3).at(3) == [bedroom 3 door 0.90, at the gallery's end, paired with the glass door] [*Paired at the gallery's end:* bedroom 3 (west), the glass door (south) and, one step beyond, the gym: no vestibule, no wasted corridor; its wardrobe 1.8 × 0.6 on the gym wall, the desk at the south-west window.] else [As in X3, beside the bath pair.]
      - *The court:* its north strip y 19.35–20.55 keeps the bedroom's and the office's doors and gains the glass door and the gym door at its west end (both within the strip); the ladder recess slides to y #r2(g.ladder.at(1))–#r2(g.ladder.at(3)) on the gym's east wall (0.1 m south of the gym door); the winter armchairs, the table and the seating do not move; the court grows by the nib's 2.0 m² (#r2(court-area(L)) m² on axes).
      #H[Sun on the clerestory · structure]
      - *Sun:* without the nib nothing stands west of the clerestory windows: the west window (x 6.0–7.0) keeps its direct sun on 21 Dec from noon to sunset (with the nib: #calc.round(shade(-23.44deg, 14, cl.at(0)) * 100)% shaded at 14:00, #calc.round(shade(-23.44deg, 15, cl.at(0)) * 100)% at 15:00, #calc.round(shade(-23.44deg, 16, cl.at(0)) * 100)% at 16:00); the east window and the noon sun were never shaded; in summer the south-facing windows see no direct sun at all (the sun stands north of east–west at noon and in the afternoon). Page 11.
      - *Structure:* #if L.yg == YG0 [the double wall on the beams B22 (x 0–2.75) and B8 (x 2.75–4.25) on the column line C6 – C13 – C19, as designed.] else [the acoustic wall #r2(L.yg - YG0) m south of the beams B22 / B8 as a *light double gypsum wall* (two independent stud leaves with mineral wool, Rw ≥ 55, ≈ 0.8 kN/m) on the men's majlis roof slab (ribbed 0.30 spanning N–S): a small line load near the support, no thickened rib needed in the engineer's first view; the beams stay on y 19.25 and carry the slab edge.] The nib's two partitions and its roof edge R21 are *not built* (R21 was a cantilever from C23: one less item for the engineer); the gym's east wall x 4.25 stands on B19 (C19 – C20) as today; no column or beam moved.
    ],
  )
]

// ======================= PAGE 6 · the sun on the clerestory windows: the nib today vs no nib =======================
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[The sun on the double-height living's clerestory windows · the nib today vs no nib] #h(1fr) #text(6.6pt, fill: gray)[Taif #calc.round(lat / 1deg, digits: 1)° N · solar time · a plan estimate: the nib's roof 3.6 m above the court floor (+7.2 / +3.6), the windows 1.40–2.40 above it (sill +5.00, head +6.00), x 6.0–7.0 and 7.6–8.6 on the court's north wall y 19.25 (studies/sections.typ, studies/ff_suite.typ)]
#v(1pt) #line(length: 100%, stroke: 0.6pt + accent)
#grid(columns: (1fr, 1fr), column-gutter: 14pt,
  [
    #table(columns: (1.3fr, 0.6fr, 0.7fr, 0.9fr, 0.9fr, 0.8fr, 0.8fr), stroke: 0.3pt + luma(190), inset: 2.4pt, align: (left, right, right, right, right, right, right), fill: (_, y) => if y == 0 { rgb("#e1e9e3") } else if calc.even(y) { rgb("#efece4") },
      table.header([*When*], [*alt.*], [*azimuth*], [*shadow reach, x*], [*shadow top, m*], [*west window shaded*], [*east window*]),
      ..sun-rows.map(((dec, hr, l)) => { let (h, A) = sun(dec, hr); let on = direct(dec, hr); let reach = if on { 5.8 + nib-d * calc.tan(A) } else { 0 }; let top = if on { nib-h - nib-d * calc.tan(h) / calc.cos(A) } else { 0 }
        ([#l], [#calc.round(h / 1deg)°], [#if on [#calc.round(A / 1deg)° W] else [#calc.round(A / 1deg)° (N of E–W)]], [#if on [#r2(reach)] else [—]], [#if on [#r2(top)] else [—]], [#if on [#calc.round(shade(dec, hr, cl.at(0)) * 100)%] else [no direct sun]], [#if on [#calc.round(shade(dec, hr, cl.at(1)) * 100)%] else [no direct sun]]) }).join(),
    )
    #v(2pt)
    #text(6.4pt, fill: gray)[Altitude and azimuth from the latitude, the declination (21 Dec −23.44°, 21 Jun +23.44°) and the hour angle; the shadow of the nib's south-east roof corner on the window plane: x = 5.8 + 1.3 tan A, top = 3.6 − 1.3 tan h / cos A; "shaded" = the share of the window's area west of x and below the top (the true edge is slanted: an estimate within ≈ 10 %). Without the nib every value is 0 %: nothing else stands west of the windows (the gym's east wall x 4.25 is in line with the gallery's end wall).]
    #v(3pt)
    #H[What the nib shades, what is gained]
    #text(6.8pt)[
      - *Winter (the season that matters for these windows):* at noon the sun is due south, 45° high: the nib casts no shadow eastwards and the court's south frame is too far to matter; both windows are in full sun with or without the nib. From about 13:00 the sun moves west and the nib's shadow walks east along the north wall: the west window is #calc.round(shade(-23.44deg, 13, cl.at(0)) * 100)% shaded at 13:00, #calc.round(shade(-23.44deg, 14, cl.at(0)) * 100)% at 14:00, #calc.round(shade(-23.44deg, 15, cl.at(0)) * 100)% at 15:00, #calc.round(shade(-23.44deg, 16, cl.at(0)) * 100)% at 16:00; the east window is touched only after 15:30 (#calc.round(shade(-23.44deg, 16, cl.at(1)) * 100)% at 16:00). *Removing the nib gives the west window its whole winter afternoon*, ≈ 3 h of low, warm sun into the double-height living, and the court's north-west corner the same.
      - *Equinox:* the sun at 15:00 is high (#calc.round(sun(0deg, 15).at(0) / 1deg)°): the nib's shadow stays below the sills: no loss, no gain.
      - *Summer:* at noon the sun stands slightly north (altitude #calc.round(sun(23.44deg, 12).at(0) / 1deg)°) and at 15:00 north of west: the south-facing windows receive no direct sun in either case; the nib changes nothing. The owner's concern is a winter one, and it is real.
      - *The office wall* (x 10) east of the windows shades them symmetrically in the winter *morning*: 4.75 m deep, its shadow top on the north wall stays below the sills until the sun is low (≈ 09:00); that is as designed and unchanged here.
    ]
  ],
  [
    #cetz.canvas(length: 1.0cm, {
      import cetz.draw: *
      let T(p, body, size: 4.2pt, fill: ink, anchor: "center", angle: 0deg) = content((p.at(0), -p.at(1)), anchor: anchor, angle: angle, text(size, fill: fill, body))
      rect((3.8, -24.5), (11.6, -17.6), fill: rgb("#f3efe6"), stroke: none)
      rect((4.25, -24.0), (10.0, -19.25), fill: rgb("#eef5e8"), stroke: 0.8pt + ink); T((7.1, 23.6), [suite court], size: 4pt, fill: gray)
      rect((4.25, -20.55), (5.8, -19.25), fill: rgb("#d9e4f2"), stroke: 0.9pt + ink); T((5.0, 19.9), [nib today], size: 3.8pt)
      line((4.25, -24.0), (4.25, -19.25), stroke: 1.2pt + ink); T((4.1, 21.7), [gym], size: 4pt, angle: 90deg, anchor: "center")
      line((5.8, -19.25), (10.0, -19.25), stroke: 2pt + ink); T((7.9, 17.85), [the double-height living's south wall · the two clerestory windows (sill +1.40 above the court)], size: 3.4pt)
      for (a, b) in cl { line((a, -19.25), (b, -19.25), stroke: 3pt + blue) }
      T((6.5, 18.1), [W 6.0–7.0], size: 3.4pt, fill: blue); T((8.1, 18.1), [E 7.6–8.6], size: 3.4pt, fill: blue)
      // the shadow of the nib's SE corner on the court floor and the reach on the wall, 21 Dec 13–16 h
      let k = 0
      for (hr, c) in ((13, rgb("#e8b84a")), (14, rgb("#d99a2b")), (15, rgb("#c47a1f")), (16, rgb("#a85e18"))) {
        let (h, A) = sun(-23.44deg, hr); let reach = 5.8 + nib-d * calc.tan(A); let top = nib-h - nib-d * calc.tan(h) / calc.cos(A)
        line((5.8, -20.55), (reach, -19.25), stroke: (paint: c, thickness: 0.8pt, dash: "dashed"))
        line((5.8, -19.25 + 0.35 + k * 0.22), (reach, -19.25 + 0.35 + k * 0.22), stroke: 1.6pt + c); T((reach + 0.1, 19.25 - 0.35 - k * 0.22), [#hr:00 · to x #r2(reach) · up to #r2(top) m], size: 3.2pt, fill: c, anchor: "west")
        k += 1
      }
      line((10.0, -24.0), (10.0, -19.25), stroke: 1.2pt + ink); T((10.15, 21.7), [office wall x 10], size: 3.6pt, angle: 90deg)
      T((7.1, 24.2), [the sun's direction on 21 Dec: 13:00 from the SSW, 16:00 from the WSW; the dashed lines = the nib's roof-corner shadow on the court floor, the bars = its reach on the wall], size: 3.4pt, fill: gray)
    })
    #v(2pt)
    #text(6.4pt, fill: gray)[Plan of the court's north-west corner (1 : 100). Without the nib the gym's east wall ends at the gallery's end wall (y 19.25) 1.75 m west of the first window; it stands in the plane of the gallery's end wall and, being west of the gallery and the court's north edge, casts nothing onto the windows.]
  ],
)

// ======================= PAGE 7 · rev 3: the gym strip G0–G2 on the X3 base =======================
#pagebreak()
#text(13pt, weight: "bold", fill: accent)[Rev 3 · X3 adopted + a strip from the gym: G0 / G1 / G2 · the gym's entrance and the gallery's end (the nib kept; pages 12–15)] #h(1fr) #text(6.6pt, fill: gray)[study · 14 Nov 2026 · nothing in the design files changed · m² on axes · *clear* inside the walls]
#v(1pt) #line(length: 100%, stroke: 0.6pt + accent)
#grid(columns: (1.15fr, 1fr), column-gutter: 12pt,
  [
    #table(columns: (1.5fr, 1fr, 1fr, 1fr, 1fr), stroke: 0.3pt + luma(190), inset: 2.5pt, align: (left, right, right, right, right), fill: (_, y) => if y == 0 { rgb("#e1e9e3") } else if calc.even(y) { rgb("#efece4") },
      table.header([*axes · clear m²*], [*Today*], [*G0 (X3)*], [*G1 (−0.5)*], [*G2 (−0.8)*]),
      [Bedroom 3 / gym wall on y], [19.25], [19.25], [19.75], [20.05],
      [Bedroom 2 (with its entry strip)], AC(today, "Bedroom 2"), AC(G0, "Bedroom 2"), AC(G1, "Bedroom 2"), AC(G2, "Bedroom 2"),
      [… gain over today (clear)], [—], gain(G0, "Bedroom 2"), gain(G1, "Bedroom 2"), gain(G2, "Bedroom 2"),
      [Bedroom 3], AC(today, "Bedroom 3"), AC(G0, "Bedroom 3"), AC(G1, "Bedroom 3"), AC(G2, "Bedroom 3"),
      [… gain over today (clear)], [—], gain(G0, "Bedroom 3"), gain(G1, "Bedroom 3"), gain(G2, "Bedroom 3"),
      [the two bedrooms differ by (clear)], [#r2(calc.abs(Cz(today, "Bedroom 2") - Cz(today, "Bedroom 3")))], [#r2(calc.abs(Cz(G0, "Bedroom 2") - Cz(G0, "Bedroom 3")))], [#r2(calc.abs(Cz(G1, "Bedroom 2") - Cz(G1, "Bedroom 3")))], [#r2(calc.abs(Cz(G2, "Bedroom 2") - Cz(G2, "Bedroom 3")))],
      [Baths 2 · 3 (clear)], [#r2(Cz(today, "Bedroom 2 bath")) · #r2(Cz(today, "Bedroom 3 bath"))], [#r2(Cz(G0, "Bedroom 2 bath")) · #r2(Cz(G0, "Bedroom 3 bath"))], [#r2(Cz(G1, "Bedroom 2 bath")) · #r2(Cz(G1, "Bedroom 3 bath"))], [#r2(Cz(G2, "Bedroom 2 bath")) · #r2(Cz(G2, "Bedroom 3 bath"))],
      [Bath pair (axes y) · the stack at y], [—], [#r2(G0.yb)–#r2(G0.yb + G0.D) · #r2(G0.stack.at(1))], [#r2(G1.yb)–#r2(G1.yb + G1.D) · #r2(G1.stack.at(1))], [#r2(G2.yb)–#r2(G2.yb + G2.D) · #r2(G2.stack.at(1))],
      [Gym (band + nib), axes · clear], [22.20 · 19.70], [#r2(area(G0.gym.poly)) · #r2(gym-clear(G0))], [#r2(area(G1.gym.poly)) · #r2(gym-clear(G1))], [#r2(area(G2.gym.poly)) · #r2(gym-clear(G2))],
      [Gym band, clear w × d], [4.03 × 4.53], [4.03 × #r2(YS - 0.125 - G0.yg - 0.1)], [4.03 × #r2(YS - 0.125 - G1.yg - 0.1)], [4.03 × #r2(YS - 0.125 - G2.yg - 0.1)],
      [Gallery ends at y · its length from y 0.7], [19.25 · 18.55], [19.25 · 18.55], [19.75 · 19.05], [20.05 · 19.35],
      [Gym door (sliding, on the gym's north line)], [y 19.25], [y 19.25], [y 19.75], [y 20.05],
      [Nib (1.3 deep) · court door (x 5.8) at y], [19.25–20.55 · 19.5–20.4], [19.25–20.55 · 19.5–20.4], [19.75–21.05 · 20.0–20.9], [20.05–21.35 · 20.3–21.2],
      [Ladder recess on the gym's east wall, y], [20.65–21.95], [20.65–21.95], [#r2(G1.gym.ladder.at(1))–#r2(G1.gym.ladder.at(3))], [#r2(G2.gym.ladder.at(1))–#r2(G2.gym.ladder.at(3))],
      [The double wall stands on], [B22 + B8], [B22 + B8], [the slab, 0.5 off the beams], [the slab, 0.8 off the beams],
      [Checks: bedrooms (6) · gym (5)], [—], [#if all-ok(G0) [passed] else [FAILED] · #if gym-all-ok(G0) [passed] else [#gym-checks(G0).filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]], [#if all-ok(G1) [passed] else [FAILED] · #if gym-all-ok(G1) [passed] else [#gym-checks(G1).filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]], [#if all-ok(G2) [passed] else [FAILED] · #if gym-all-ok(G2) [passed] else [#gym-checks(G2).filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]],
    )
    #v(2pt)
    #text(6.4pt, fill: gray)[Today = `studies/ff_family.typ` / `studies/ff_suite.typ` (14 Nov 2026). G0–G2 all carry X3 (the bath pair 1.4 m deep, the WCs at the south end of the wet wall, the stack into the GF WC compartment, bedroom 2's entry by the shaft), the pair re-centred so the bedrooms stay equal. The gym checks: the furniture inside the band's clear box without overlaps, the 0.5 m zone behind the treadmill free, a 1.0 m path from the door, the court door's swing clear of the court's furniture and the ladder, the court door within the 1.2 m movement strip.]
    #v(3pt)
    #H[The entrance and the gallery's end: (a), (b), (c)]
    #text(6.8pt)[
      - *(a) the gallery extended to the new line, the gym door on it:* the gym's north wall becomes ONE line across the band and the nib; the gallery's floor already exists there (the nib's slab); the nib keeps its depth only if its south wall moves with it. Taken.
      - *(b) the gallery unchanged, the nib kept at y 19.25:* the band's wall at 19.75 / 20.05 and the nib's north wall at 19.25 make a *0.5 / 0.8 m jog at x 4.25*, the kind the owner excludes; and the nib would grow to 1.8 / 2.1 m deep for nothing. Rejected.
      - *(c) = (a) with the nib kept 1.3 m deep:* its south wall and its court door move south by the same 0.5 / 0.8 m, the ladder recess (0.1 m south of the nib on the gym's east wall) with them; nothing else in the court moves. *Chosen for G1 and G2.* In G1 the court door (y 20.0–20.9) still sits on the 1.2 m movement strip; in G2 (y 20.3–21.2) it falls 0.65 m past the strip's edge: the strip's west end is widened to y 21.3 in front of the door (x 5.9–7.0), the winter armchair at x 7.1 stays; the door's swing is clear of it (checked).
    ]
  ],
  [
    #box(fill: accent.lighten(86%), stroke: 1pt + accent, inset: 6pt, radius: 3pt, width: 100%)[
      #text(9.5pt, weight: "bold", fill: accent)[The study's view (the owner decides): G1] \
      #text(7pt)[
        Each 0.1 m taken from the gym gives each bedroom 0.05 m, about 0.2 m² clear: G0 → G1 → G2 is #r2(Cz(G0, "Bedroom 2")) → #r2(Cz(G1, "Bedroom 2")) → #r2(Cz(G2, "Bedroom 2")) m² for bedroom 2 and #r2(Cz(G0, "Bedroom 3")) → #r2(Cz(G1, "Bedroom 3")) → #r2(Cz(G2, "Bedroom 3")) for bedroom 3 (today #r2(Cz(today, "Bedroom 2")) and #r2(Cz(today, "Bedroom 3"))). The gym pays: #r2(gym-clear(G0)) → #r2(gym-clear(G1)) → #r2(gym-clear(G2)) m² clear; the owner's list (the treadmill with its 0.5 m zone, the bike, the rack, the 2.0 × 1.0 mat, the 1.0 m path) fits in all three, in G2 with the mat touching the treadmill's zone and the rack. *G1* keeps the court door on the movement strip, the gallery's end 0.5 m further south with the gym door on it, and the double wall 0.5 m off the beams B22 / B8: a line load the engineer sets on a thickened rib. *G2* needs the strip widened in front of the court door and puts the wall 0.8 m into the span for 0.4 m² more per bedroom. *G0* keeps the double wall on its beams and the gym as the owner furnished it.
        \ *What never moves:* the columns C6, C13, C19, the beams B22 / B8 / B19 / B20, the gym's south and west walls and windows, the court's north edge (the living's south wall), the office door, the ladder's wall (its recess slides 0.5 / 0.8 m on it).
      ]
    ]
    #v(4pt)
    #box(fill: rgb("#f4efe3"), stroke: 0.6pt + luma(170), inset: 6pt, radius: 3pt, width: 100%)[
      #ah[
        #text(9pt, weight: "bold", fill: accent)[الخلاصة بالعربية] \
        #text(7.4pt)[
          قرار المالك (14 نوفمبر 2026): X3 هو الأساس (الحمّامان بعمق 1.4 م، المرحاضان في الطرف الجنوبي للجدار الرطب، الماسورة في حجرة مرحاض دورة المياه الأرضية، مدخل غرفة النوم 2 بجانب الشفت)؛ وتُدرس شريحة من النادي بتحريك جدار غرفة النوم 3 الجنوبي (الجدار الصوتي المزدوج) جنوبًا. \
          *G0:* النادي كما هو؛ الغرفتان #r2(Cz(G0, "Bedroom 2")) و#r2(Cz(G0, "Bedroom 3")) م² صافية، النادي #r2(gym-clear(G0)) م². \
          *G1 (رأي الدراسة):* الجدار على y 19.75 (−0.5 م)؛ الغرفتان #r2(Cz(G1, "Bedroom 2")) و#r2(Cz(G1, "Bedroom 3")) م²، النادي #r2(gym-clear(G1)) م²؛ الممر يمتد إلى الخط الجديد وباب النادي عليه، والعتبة (النتوء) تحتفظ بعمقها 1.3 م وباب الفناء ومشكاة السلّم ينزلان 0.5 م؛ باب الفناء يبقى على شريط الحركة. \
          *G2:* الجدار على y 20.05 (−0.8 م)؛ الغرفتان #r2(Cz(G2, "Bedroom 2")) و#r2(Cz(G2, "Bedroom 3")) م²، النادي #r2(gym-clear(G2)) م²؛ يحتاج توسيع طرف شريط الحركة أمام باب الفناء، والجدار المزدوج يقف 0.8 م داخل البلاطة.
        ]
      ]
    ]
  ],
)

// ======================= PAGES 2–4 · G0, G1, G2 =======================
#for L in G-options [
  #pagebreak()
  #text(12pt, weight: "bold", fill: accent)[#L.name] #h(1fr) #text(6.6pt, fill: gray)[1 : 100 (1.0 cm / m, as sheet 04) · CSV frame, north up · #L.note]
  #v(1pt) #line(length: 100%, stroke: 0.6pt + accent)
  #grid(columns: (auto, 1fr), column-gutter: 12pt,
    plan(L),
    [
      #let ys = L.yb + L.D
      #let g = L.gym
      #set text(6.6pt)
      #H[Clear sizes and areas]
      #table(columns: (1.4fr, 1fr, 1fr, 1fr, 1fr), stroke: 0.3pt + luma(190), inset: 2.2pt, align: (left, right, right, right, right), fill: (_, y) => if y == 0 { rgb("#e1e9e3") } else if calc.even(y) { rgb("#efece4") },
        table.header([*Room*], [*axes w × d*], [*clear w × d*], [*axes m²*], [*clear m²*]),
        [Bedroom 2 (+ the entry strip 2.55 × 1.20)], [4.25 × #r2(L.yb - 10.4) (L)], [4.03 × #r2(L.yb - 10.6)], [#r2(Az(L, "Bedroom 2"))], [*#r2(Cz(L, "Bedroom 2"))* (today #r2(Cz(today, "Bedroom 2")): #gain(L, "Bedroom 2"))],
        [Bedroom 3], [4.25 × #r2(L.yg - ys)], [4.03 × #r2(L.yg - ys - 0.2)], [#r2(Az(L, "Bedroom 3"))], [*#r2(Cz(L, "Bedroom 3"))* (today #r2(Cz(today, "Bedroom 3")): #gain(L, "Bedroom 3"))],
        [Bath 2 · bath 3 (X3)], [2.10 · 2.15 × 1.40], [1.88 · 1.95 × 1.20], [#r2(Az(L, "Bedroom 2 bath")) · #r2(Az(L, "Bedroom 3 bath"))], [*#r2(Cz(L, "Bedroom 2 bath")) · #r2(Cz(L, "Bedroom 3 bath"))*],
        [Gym band · nib], [4.25 × #r2(YS - L.yg) · 1.55 × 1.30], [4.03 × #r2(YS - 0.125 - L.yg - 0.1) · 1.35 × 1.10], [#r2(area(g.poly))], [*#r2(gym-clear(L))*],
      )
      *Checks:* bedrooms #if all-ok(L) [passed (#checks(L).len())] else [FAILED: #checks(L).filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]; gym #if gym-all-ok(L) [passed (#gym-checks(L).len())] else [FAILED: #gym-checks(L).filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]. The bath pair y #r2(L.yb)–#r2(ys), the stack at y #r2(L.stack.at(1)) inside the GF WC compartment (#r2(L.stack.at(1) - 14.55) m south of its partition).
      #H[The gym, its entrance, the gallery's end, the court]
      - *Gym* #r2(gym-clear(L)) m² clear: the treadmill 2.0 × 0.8 facing the south wall's TV with its 0.5 m zone behind, the bike beside it, the free-weights rack 1.5 × 1.4 in the south-east corner, the 2.0 × 1.0 mat in the middle, the 1.0 m path from the door along the north wall; the windows west (y #r2(19.6 + L.yg - YG0)–#r2(20.9 + L.yg - YG0) and 22.0–23.5) and south as today.
      - *Entrance:* the gallery ends at y #r2(L.yg) (#r2(L.yg - 0.7) m from the linen cupboard); the sliding gym door 1.10 on the gym's north line at the gallery's end (x 4.35–5.45); the nib x 4.25–5.8 × y #r2(L.yg)–#r2(g.yn) (1.3 deep) with the court door 0.90 on its east wall (y #r2(L.yg + 0.25)–#r2(L.yg + 1.15), opening into the court). #if L.yg > YG0 [The gym's north wall is one straight line from the west outer wall to x 5.8; the gallery's extension stands on the nib's slab (the men's majlis roof), no new floor.] else [As today.]
      - *Court:* the north strip y 19.35–20.55 with the three doors; #if L.yg > YG0 [the gym's court door moved #r2(L.yg - YG0) m south #if (g.court-door.at(0).at(1) + g.court-door.at(1).at(1)) / 2 <= 20.55 [and still within the strip] else [and 0.65 m past the strip's edge: the strip's west end widened to y #r2(g.strip-west.at(3)) in front of it (x 5.9–7.0), the winter armchair at x 7.1 untouched]; the ladder recess on the gym's east wall slides #r2(L.yg - YG0) m south to y #r2(g.ladder.at(1))–#r2(g.ladder.at(3)) (clear of the west armchair at y 21.7 and the tree pot at 23.2); the office door, the bedroom's court door, the seating and the mashrabiya unchanged.] else [nothing moves.]
      #H[Structure]
      - #if L.yg > YG0 [*The double wall* (200 dense block + an independent lined stud, Rw ≈ 55) moves #r2(L.yg - YG0) m south onto the men's majlis roof slab (ribbed 0.30, spanning N–S 4.75 m from the beams B22 / B8 on y 19.25 to B9 on y 24): a line load ≈ 3 kN/m across the ribs #r2(L.yg - YG0) m from the support, on a thickened rib or a hidden beam the engineer sizes; the beams B22 (x 0–2.75) and B8 (x 2.75–4.25) stay on y 19.25 and still carry the slab edge; bedroom 3's floor is the same slab. *Below it* on the GF: the guest passage (x 0–1.25), the guest basins (x 1.25–2.75; their north wall y 19.4 is #r2(L.yg - 19.4) m north of the line) and the men's majlis (x 2.75–4.25): no GF wall under it. The nib's partitions (its north wall on the new line, its east wall on x 5.8 over the rib B20, its south wall on y #r2(g.yn)) are light; R21 (the nib's roof edge) unchanged. *No column or beam touched* (C6, C13, C19, C20, B19, B20, B22, B8).] else [*The double wall* stands on the beams B22 (x 0–2.75, over the guest passage and the guest WC door) and B8 (x 2.75–4.25) on the column line C6 – C13 – C19, as designed.]
      - The bath pair's walls (y #r2(L.yb), #r2(ys)) and the wet wall x 2.10 as in X3: 0.20 block partitions on the solid west slab, none on a GF wall; the wet wall carries the stack and the two WC frames mid-bay.
    ],
  )
]

// ======================= PAGE 5 · rev 2: X1 / X2 / X3 by bath size (the comparison) =======================
#pagebreak()
#text(13pt, weight: "bold", fill: accent)[Rev 2 · X1 / X2 / X3 by bath size (X3 adopted, 14 Nov 2026)] #h(1fr) #text(6.6pt, fill: gray)[pages 16–19 · the gym as today (y 19.25) · m² on axes · *clear* inside the walls (west wall 0.125, others 0.10 a side)]
#v(1pt) #line(length: 100%, stroke: 0.6pt + accent)
#grid(columns: (1.15fr, 1fr), column-gutter: 12pt,
  [
    #table(columns: (1.5fr, 1fr, 1fr, 1fr, 1fr), stroke: 0.3pt + luma(190), inset: 2.6pt, align: (left, right, right, right, right), fill: (_, y) => if y == 0 { rgb("#e1e9e3") } else if calc.even(y) { rgb("#efece4") },
      table.header([*axes · clear m²*], [*Today*], [*X1*], [*X2*], [*X3*]),
      [Bedroom 2 (with its entry strip)], AC(today, "Bedroom 2"), AC(X1o, "Bedroom 2"), AC(X2o, "Bedroom 2"), AC(X3o, "Bedroom 2"),
      [… gain over today (clear)], [—], gain(X1o, "Bedroom 2"), gain(X2o, "Bedroom 2"), gain(X3o, "Bedroom 2"),
      [Bedroom 3], AC(today, "Bedroom 3"), AC(X1o, "Bedroom 3"), AC(X2o, "Bedroom 3"), AC(X3o, "Bedroom 3"),
      [… gain over today (clear)], [—], gain(X1o, "Bedroom 3"), gain(X2o, "Bedroom 3"), gain(X3o, "Bedroom 3"),
      [the two bedrooms differ by (clear)], [#r2(calc.abs(Cz(today, "Bedroom 2") - Cz(today, "Bedroom 3")))], [#r2(calc.abs(Cz(X1o, "Bedroom 2") - Cz(X1o, "Bedroom 3")))], [#r2(calc.abs(Cz(X2o, "Bedroom 2") - Cz(X2o, "Bedroom 3")))], [#r2(calc.abs(Cz(X3o, "Bedroom 2") - Cz(X3o, "Bedroom 3")))],
      [Bath 2 (west, window)], AC(today, "Bedroom 2 bath"), AC(X1o, "Bedroom 2 bath"), AC(X2o, "Bedroom 2 bath"), AC(X3o, "Bedroom 2 bath"),
      [Bath 3 (east, fan)], AC(today, "Bedroom 3 bath"), AC(X1o, "Bedroom 3 bath"), AC(X2o, "Bedroom 3 bath"), AC(X3o, "Bedroom 3 bath"),
      [Bath pair: axes y · clear depth], [—], [#r2(X1o.yb)–#r2(X1o.yb + X1o.D) · #r2(X1o.D - 0.2)], [#r2(X2o.yb)–#r2(X2o.yb + X2o.D) · #r2(X2o.D - 0.2)], [#r2(X3o.yb)–#r2(X3o.yb + X3o.D) · #r2(X3o.D - 0.2)],
      [Shower · basin depth], [—], [#r1(X1o.sh.at(0)) × #r1(X1o.sh.at(1)) · 0.35], [#r1(X2o.sh.at(0)) × #r1(X2o.sh.at(1)) · 0.35], [#r1(X3o.sh.at(0)) × #r1(X3o.sh.at(1)) · 0.35],
      [The stack (x #r2(xw)) lands at y], [—], [#r2(X1o.stack.at(1)) · in the GF WC compartment], [#r2(X2o.stack.at(1)) · in the compartment], [#r2(X3o.stack.at(1)) · in the compartment (0.30 inside)],
      [Checks (6)], [—], [#if all-ok(X1o) [passed] else [FAILED]], [#if all-ok(X2o) [passed] else [FAILED]], [#if all-ok(X3o) [passed] else [FAILED]],
    )
    #v(2pt)
    #text(6.4pt, fill: gray)[The six checks: the rooms tile the band with no small jog; fixtures inside with ≥ 0.60 clear in front of every WC and basin and showers ≥ 0.8 × 0.8; furniture inside and the entry strip clear; door swings clear; the bedrooms within 0.3 m² clear; the stack inside the GF WC compartment. Bedroom 2's clear area includes its entry strip (2.55 × 1.2 = 3.06 m²).]
    #v(3pt)
    #H[Common to the three]
    #text(6.8pt)[
      - *Bedroom 2's entry:* the strip x 1.5–4.25 × y 9.2–10.4 beside the shaft, its 0.90 door from the gallery inside it (x 4.25, y 9.35–10.25, opening in); entering, one faces the shaft's box 2.65 m ahead; nothing stored there. The bed's head on the west wall, the desk at the west window south of it, the 1.8 m wardrobe on the bath wall east of the bath door.
      - *The pair:* bath 2 west (its window above the shower, the basin on the west wall, the WC on the shared wall), bath 3 east by the gallery (the shower on the shared wall's north part, the WC at its south end, the basin on the gallery wall; a fan to the roof). *Both WCs at the south end of the shared wet wall x #r2(xw)*, the stack between them 0.3 m north of the pair's south wall: it drops straight into the *GF powder room's WC compartment* (y 14.55–16.1), boxed 0.30 × 0.30 at the compartment's partition, then ≈ #r1(xw - west-run-x) m in the GF floor build-up to the buried west run (x #r2(west-run-x)); one stack instead of today's two.
      - *Structure:* the pair's two cross walls and the wet wall are 0.20 block partitions on the solid 0.20 west slab (none on a GF wall); the wet wall carries the stack and two WC frames mid-bay between the GF riwaq wall x 2.75 and the outer wall (for the engineer's list). Removed: bath 2's niche walls (y 11.0, x 1.5 south of the shaft) and bath 3's walls (y 14.4, x 2.2).
    ]
  ],
  [
    #box(fill: accent.lighten(86%), stroke: 1pt + accent, inset: 6pt, radius: 3pt, width: 100%)[
      #text(9.5pt, weight: "bold", fill: accent)[The study's view was X2 · the owner adopted X3 (14 Nov 2026)] \
      #text(7pt)[
        Each 0.2 m taken from the pair's depth gives each bedroom 0.1 m, about 0.4 m² clear: X1 → X2 → X3 is #r2(Cz(X1o, "Bedroom 2")) → #r2(Cz(X2o, "Bedroom 2")) → #r2(Cz(X3o, "Bedroom 2")) m² for bedroom 2 and #r2(Cz(X1o, "Bedroom 3")) → #r2(Cz(X2o, "Bedroom 3")) → #r2(Cz(X3o, "Bedroom 3")) for bedroom 3. *X2* (1.6 m deep, 1.4 clear) is where the bath still feels like a room. *X3* (1.4 m deep, 1.2 clear) passes every rule with nothing to spare: the shower, the WC and the basin touch in a row, the door leaf stops 0.1 m from the shower screen. The owner chose the bedrooms: X3 is the base of rev 3, rev 4 and rev 5 (pages 1–15).
      ]
    ]
    #v(4pt)
    #box(fill: rgb("#f4efe3"), stroke: 0.6pt + luma(170), inset: 6pt, radius: 3pt, width: 100%)[
      #ah[
        #text(9pt, weight: "bold", fill: accent)[الخلاصة بالعربية · X1–X3] \
        #text(7.4pt)[
          *X1:* الحمّامان بعمق 1.8 م (#r2(Cz(X1o, "Bedroom 2 bath")) و#r2(Cz(X1o, "Bedroom 3 bath")) م² صافية)؛ الغرفتان #r2(Cz(X1o, "Bedroom 2")) و#r2(Cz(X1o, "Bedroom 3")) م². \
          *X2:* الحمّامان بعمق 1.6 م (#r2(Cz(X2o, "Bedroom 2 bath")) و#r2(Cz(X2o, "Bedroom 3 bath")) م²)؛ الغرفتان #r2(Cz(X2o, "Bedroom 2")) و#r2(Cz(X2o, "Bedroom 3")) م². \
          *X3 (المعتمد):* أصغر زوج يعمل، 1.4 م (#r2(Cz(X3o, "Bedroom 2 bath")) و#r2(Cz(X3o, "Bedroom 3 bath")) م²) بدُش 0.8 × 0.8؛ الغرفتان #r2(Cz(X3o, "Bedroom 2")) و#r2(Cz(X3o, "Bedroom 3")) م².
        ]
      ]
    ]
  ],
)

// ======================= PAGES 6–8 · X1, X2, X3 =======================
#for L in X-options [
  #pagebreak()
  #text(12pt, weight: "bold", fill: accent)[#L.name] #h(1fr) #text(6.6pt, fill: gray)[1 : 100 (1.0 cm / m, as sheet 04) · CSV frame, north up · #L.note]
  #v(1pt) #line(length: 100%, stroke: 0.6pt + accent)
  #grid(columns: (auto, 1fr), column-gutter: 14pt,
    plan(L),
    [
      #let ys = L.yb + L.D
      #H[Clear sizes and areas]
      #table(columns: (1.4fr, 1fr, 1fr, 1fr, 1fr), stroke: 0.3pt + luma(190), inset: 2.4pt, align: (left, right, right, right, right), fill: (_, y) => if y == 0 { rgb("#e1e9e3") } else if calc.even(y) { rgb("#efece4") },
        table.header([*Room*], [*axes w × d*], [*clear w × d*], [*axes m²*], [*clear m²*]),
        [Bedroom 2 (+ the entry strip 2.55 × 1.20 clear)], [4.25 × #r2(L.yb - 10.4) (L)], [#r2(X1 - 0.225) × #r2(L.yb - 10.6)], [#r2(Az(L, "Bedroom 2"))], [*#r2(Cz(L, "Bedroom 2"))* (today #r2(Cz(today, "Bedroom 2")): #gain(L, "Bedroom 2"))],
        [Bedroom 3], [4.25 × #r2(YG0 - ys)], [#r2(X1 - 0.225) × #r2(YG0 - ys - 0.2)], [#r2(Az(L, "Bedroom 3"))], [*#r2(Cz(L, "Bedroom 3"))* (today #r2(Cz(today, "Bedroom 3")): #gain(L, "Bedroom 3"))],
        [Bath 2], [#r2(xw) × #r2(L.D)], [#r2(xw - 0.225) × #r2(L.D - 0.2)], [#r2(Az(L, "Bedroom 2 bath"))], [*#r2(Cz(L, "Bedroom 2 bath"))*],
        [Bath 3], [#r2(X1 - xw) × #r2(L.D)], [#r2(X1 - xw - 0.2) × #r2(L.D - 0.2)], [#r2(Az(L, "Bedroom 3 bath"))], [*#r2(Cz(L, "Bedroom 3 bath"))*],
      )
      #text(6.4pt)[*Checks:* #if all-ok(L) [passed (#checks(L).len())] else [FAILED: #checks(L).filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]. The bath pair y #r2(L.yb)–#r2(ys); the shower #r1(L.sh.at(0)) × #r1(L.sh.at(1)) behind a fixed glass screen, a wall mixer and a floor drain; the basin #r1(L.bw) wide × 0.35 deep; ≥ 0.60 in front of each WC and basin (the dotted boxes); the two bath doors 0.70 hinged, opening into the baths, their leaves clear of every fixture.]
      #H[Furniture and doors]
      #text(6.8pt)[
        - *Bedroom 2:* the door 0.90 from the gallery in the entry strip (x 4.25, y 9.35–10.25, opening in: the leaf stays inside the strip); entering, the shaft's box is straight ahead and the room opens to the left. The bed 1.4 × 2.0 with its head on the west wall (y 10.55–11.95) under the escape window, the desk 0.9 × 0.6 at the second west window south of it, the wardrobe 1.8 × 0.6 on the bath wall east of the bath door (x 2.0–3.8). The bath door (y #r2(L.yb), x 1.2–1.9) is out of the bed's line.
        - *Bedroom 3:* the door 0.90 from the gallery (x 4.25, y #r2(ys + 0.3)–#r2(ys + 1.2), opening in); the bed's head on the west wall (y #r2(ys + 0.6)–#r2(ys + 2.0)) under its escape window, away from the gym's double wall; the desk 1.1 × 0.6 at the south-west window; the wardrobe 1.8 × 0.6 on the gallery wall south of the door. The bath door (y #r2(ys), x 3.0–3.7) beside the entry, not facing the bed.
        - *Bath 2 (from bedroom 2):* the shower in the north-west corner under the high window, the basin on the west wall at the south end, the WC on the shared wall facing west; the door at the east end of the north wall. *Bath 3 (from bedroom 3):* the shower on the shared wall's north part, the WC at its south end facing east, the basin on the gallery wall; the door at the east part of the south wall; an exhaust fan.
      ]
      #H[Drainage and structure]
      #text(6.8pt)[
        - *The stack* in the shared wet wall x #r2(xw) at y #r2(L.stack.at(1)), between the two wall-hung pans (0.4 m from each); the showers' floor drains ≈ #r1(dist((0.5, L.yb + 0.5), L.stack)) m (bath 2) and ≈ #r1(dist((2.6, L.yb + 0.5), L.stack)) m (bath 3), the basins ≈ #r1(dist((0.3, ys - 0.3), L.stack)) m and ≈ #r1(dist((4.0, L.yb + 0.5), L.stack)) m, in the floor build-up or the wet wall's chase, 100 mm waste, falls ≥ 1 : 60.
        - *On the ground floor* it lands at (#r2(L.stack.at(0)), #r2(L.stack.at(1))): #if stack-ok(L) [*inside the powder room's WC compartment* (y 14.55–16.1, #r2(L.stack.at(1) - 14.55) m south of its partition), boxed 0.30 × 0.30 against that partition's south face] else [*NOT inside the WC compartment*], then ≈ #r1(xw - west-run-x) m in the GF floor build-up to the buried west run (x #r2(west-run-x)); a cleanout at the foot; the vent up through the pair's ceiling to the roof. Today's two stacks become one.
        - *Structure:* the new E–W walls (y #walls-off-gf(L).map(r2).join(", ")) stand on no GF wall (the nearest: y 12.9 and 16.1); they and the wet wall x #r2(xw) are 0.20 block partitions on the solid 0.20 west slab; the wet wall carries the stack and the two WC frames mid-bay (the GF riwaq wall x 2.75 and the outer wall carry the slab): for the engineer's list.
      ]
    ],
  )
]

// ======================= PAGE 9 · appendix: W1–W3 (the first round, superseded) =======================
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[Appendix · the first round W1–W3 (14 Nov 2026, superseded)] #h(1fr) #text(6.6pt, fill: gray)[the summary table only; the plans are in the git history (commit "Study: FF west band, back-to-back baths (W1–W3)")]
#v(1pt) #line(length: 100%, stroke: 0.6pt + accent)
#grid(columns: (1.2fr, 1fr), column-gutter: 14pt,
  [
    #table(columns: (1.5fr, 1fr, 1fr, 1fr, 1fr), stroke: 0.3pt + luma(190), inset: 2.6pt, align: (left, right, right, right, right), fill: (_, y) => if y == 0 { rgb("#e1e9e3") } else if calc.even(y) { rgb("#efece4") },
      table.header([*axes · clear m²*], [*Today*], [*W1*], [*W2*], [*W3*]),
      [Bedroom 2], [14.45 · 12.88], [14.98 · 13.38], [16.69 · 14.93], [20.30 · 18.36],
      [Bedroom 3], [16.87 · 15.02], [14.98 · 13.38], [16.57 · 14.89], [13.39 · 11.87],
      [the two bedrooms differ by (clear)], [2.14], [0.00], [0.04], [6.48],
      [Bath 2], [5.85 · 4.67], [3.78 · 3.00], [3.78 · 3.00], [3.57 · 2.81],
      [Bath 3], [3.74 · 2.96], [3.87 · 3.12], [3.87 · 3.12], [3.66 · 2.93],
      [Store off the gallery], [—], [3.30 · 2.55], [—], [—],
      [Bath pair (axes y)], [—], [13.93–15.73], [13.55–15.35], [14.40–16.10],
      [New E–W walls on GF walls], [—], [y 10.4], [none], [y 16.1],
      [The stack landed in (the WCs then mid-wall)], [—], [the GF WC compartment], [the GF basin zone], [the GF WC compartment],
      [Checks (9)], [—], [passed], [passed], [baths < 3.0; rooms unequal],
    )
  ],
  [
    #text(6.8pt)[
      - *W1:* the bath pair 1.8 m deep side by side across the band, bedroom 2's north wall straight on y 10.4 (the shaft's south face, a GF wall), the strip x 1.5–4.25 × y 9.2–10.4 a store off the gallery.
      - *W2 (the owner's idea then):* as W1, the strip given to bedroom 2 with a deep wardrobe beside the shaft, its face flush with the shaft's face.
      - *W3:* as W2 with the pair's walls on y 14.4–16.1: y 14.4 is no longer a GF wall (the GF powder room runs 12.9–16.1, its compartment partition is at 14.55), the baths fell under 3.0 m² and the rooms differed by 6.5 m².
      - *What the owner kept for rev 2:* the pair back to back between the bedrooms on one wet wall and one stack, bath 2 west with a window, bath 3 east with a fan, straight walls, equal rooms. *What changed:* no store and no wardrobe in the strip (it is bedroom 2's entry, the gallery door inside it); the bedrooms first, the baths may shrink; both WCs at the south end of the wet wall so the stack lands in the GF WC compartment. *Rev 3:* X3 adopted; the gym strip G0–G2 (pages 12–15). *Rev 4:* no nib, the paired doors at the gallery's end, the sun on the clerestory (pages 6–11). *Rev 5:* N-lock L1–L3 and N1-deep (pages 1–5).
    ]
  ],
)

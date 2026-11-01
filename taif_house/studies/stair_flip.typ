// stair_flip.typ · Taif / Palm House V8.0 (work) · STUDY ONLY (owner's idea, 1 Nov 2026 after V8.0): flip the main stair's direction.
// CURRENT: the stair well in the west band (x 0–2.75, y 2.2–7.9 on axes; 2.525 × 5.50 clear) between the lift (north) and the first-floor landing
// (south); the lower flight on the WEST half starts at the SOUTH end (from the riwaq), the half landing at the north end, the upper flight on the
// EAST half arrives at the SOUTH end on the arrival strip and the landing room (y 7.9–9.2). FLIPPED (proposal): the same well and the same stair
// geometry turned round: the lower flight starts at the NORTH end next to the lift door and the entry cupboard, the half landing at the south end,
// the arrival at the NORTH end beside the lift's first-floor door, the family living and the kids' room; the south landing freed.
// Nothing here changes the design files: compare, recommend, wait for the owner's decision. Geometry copied from studies/structure.typ (st),
// data/rooms_gf.csv, data/rooms_ff.csv, design_gf.typ, studies/ff_family.typ, 3d/params.yaml (levels, slab, finish, trimmers 0.20 × 0.40).
// CSV frame: x east, y south, wall centre lines; levels above the finished ground floor ±0.00.
#import "@preview/cetz:0.4.2"
#set page(paper: "a4", flipped: true, margin: 9mm, fill: rgb("#fbfaf6"))
#set text(font: ("Segoe UI", "Arial", "DejaVu Sans"), size: 7.2pt)
#let ink = rgb("#3d4a45")
#let accent = rgb("#5a7d2a")
#let red = rgb("#b5452f")
#let amber = rgb("#b58a1f")
#let blue = rgb("#2f5f8a")
#let green = rgb("#2f7a3f")
#let stone = rgb("#c9a86a")
#let r1(v) = str(calc.round(v, digits: 1))
#let r2(v) = str(calc.round(v, digits: 2))
#let f2(v) = { let s = str(calc.round(calc.abs(v), digits: 2)); if not s.contains(".") { s + ".00" } else if s.split(".").at(1).len() == 1 { s + "0" } else { s } }
#let lv(v) = if v < 0 { "−" + f2(v) } else { "+" + f2(v) }
#let H(body) = text(9.5pt, weight: "bold", fill: accent, body)
#let OK = text(fill: green, weight: "bold")[OK]
#let NO = text(fill: red, weight: "bold")[NO]
#let plen(P) = range(P.len() - 1).map(i => calc.sqrt(calc.pow(P.at(i + 1).at(0) - P.at(i).at(0), 2) + calc.pow(P.at(i + 1).at(1) - P.at(i).at(1), 2))).sum()
#let dist(a, b) = calc.sqrt(calc.pow(a.at(0) - b.at(0), 2) + calc.pow(a.at(1) - b.at(1), 2))

// ---------- Levels and the stair geometry (studies/structure.typ, 3d/params.yaml): the same for both options ----------
#let ff = 3.6                 // first floor finished
#let fin = 0.08               // floor finish: the FF structural slab top +3.52
#let slab = 0.20              // the FF slab over the west band (solid)
#let slab-soffit = ff - fin - slab   // +3.32
#let trim-d = 0.40            // the trimmers B16–B18, 0.20 × 0.40 total: soffit +3.20
#let trim-soffit = ff - trim-d
#let roof-soffit = 7.0        // the roof slab underside over the open well (the roof slab is closed over the well since V8.0)
#let st = (x0: 0.125, x1: 2.65, y0: 2.30, y1: 7.80, split: 1.3875, gap: 0.10, r: 3.6 / 22, g: 0.28, n: 11)
#let wf = (st.x1 - st.x0 - st.gap) / 2     // flight clear width 1.2125
#let land-d = 1.25            // the half landing
#let arr-d = st.y1 - st.y0 - land-d - 10 * st.g   // the arrival / start strip: 1.45
#let W = (st.x0, st.split - st.gap / 2)     // the west half x 0.125–1.3375
#let E = (st.split + st.gap / 2, st.x1)     // the east half x 1.4375–2.65
#let mir(y) = st.y0 + st.y1 - y             // the mirror in y about the well's middle (y 5.05)

// an option: where the stair starts (the ground-floor foot) and which half carries the lower flight
#let option(name, start, lower) = {
  // the lower flight runs from the first riser (at the start end) to the half landing at the far end; the upper flight returns on the other half
  let first = if start == "S" { st.y1 - arr-d } else { st.y0 + arr-d }     // the first riser line: 6.35 (S) or 3.75 (N)
  let d = if start == "S" { -1 } else { 1 }                                  // the lower flight's direction in y (S: up to the north)
  let land = if start == "S" { (st.y0, st.y0 + land-d) } else { (st.y1 - land-d, st.y1) }
  let arr = if start == "S" { (first, st.y1) } else { (st.y0, first) }       // the arrival strip (FF, +3.60) = the start strip (GF, ±0.00), full width
  let lo = if lower == "W" { W } else { E }
  let up = if lower == "W" { E } else { W }
  // the lower flight's treads: tread i (1 … 11) between riser lines; z = i · r; the 11th riser lands on the half landing
  let treads = range(1, st.n + 1).map(i => { let ra = first + d * (i - 1) * st.g; let rb = first + d * i * st.g; (i: i, ya: calc.min(ra, rb), yb: calc.max(ra, rb), z: i * st.r) })
  // the FF slab over the lower flight: from the start end to the trimmer line beside tread 6 (its riser line); the opening beyond
  let t6 = first + d * 6 * st.g                                              // tread 6's far riser line: 4.95 (S) or 5.15 (N)
  let b16 = (calc.min(t6, t6 - d * 0.2), calc.max(t6, t6 - d * 0.2))          // the trimmer 0.20 wide, inside the slab, its far face on tread 6's riser line
  let b18 = (calc.min(first, first - d * 0.2), calc.max(first, first - d * 0.2))   // the arrival-edge trimmer, under the strip's edge
  let b17x = if lower == "W" { st.split - 0.10 } else { st.split + 0.10 }    // on the lower flight's side of the split: never over the upper flight
  let slab-lo = if start == "S" { (t6, st.y1) } else { (st.y0, t6) }         // the slab over the lower half
  let open-lo = if start == "S" { (st.y0, t6) } else { (t6, st.y1) }
  let open-up = if start == "S" { (st.y0, first) } else { (first, st.y1) }    // the upper half is open from the top riser to the far end
  (name: name, start: start, lower: lower, first: first, d: d, land: land, arr: arr, lo: lo, up: up, treads: treads, t6: t6, b16: b16, b17x: b17x, b18: b18, slab-lo: slab-lo, open-lo: open-lo, open-up: open-up,
   top: first,                                                                  // the top riser line of the upper flight = the first riser line (mirror geometry)
   foot: ((lo.at(0) + lo.at(1)) / 2, first),                                    // the foot of the stair (GF), the middle of the first riser
   head: ((up.at(0) + up.at(1)) / 2, first))                                    // the top of the stair (FF)
}
#let CUR = option("current", "S", "W")
#let FLP = option("flipped (B)", "N", "E")     // the recommended flip: the lower flight on the east, straight off the lobby
#let FLA = option("flipped (A)", "N", "W")     // the alternative: the mirror image only
#let opts = (CUR, FLP)

// headroom over every tread of the lower flight: the slab (+3.32), the trimmer B16 (+3.20) where it crosses the tread, B17 over the inner 0.10 strip, else the open well (the roof soffit)
#let over(o, t) = {
  let hits-b16 = t.ya < o.b16.at(1) - 1e-9 and t.yb > o.b16.at(0) + 1e-9
  let in-slab = t.ya < o.slab-lo.at(1) - 1e-9 and t.yb > o.slab-lo.at(0) + 1e-9
  let under-b17 = t.ya < calc.max(o.b18.at(1), o.b16.at(1)) and t.yb > calc.min(o.b18.at(0), o.b16.at(0))   // B17 runs between B18 and B16 along the inner edge
  if hits-b16 { (what: "B16 trimmer (soffit " + lv(trim-soffit) + ")", h: trim-soffit - t.z) }
  else if in-slab and under-b17 { (what: "slab " + lv(slab-soffit) + " · B17 over the inner 0.10 strip " + lv(trim-soffit), h: trim-soffit - t.z) }
  else if in-slab { (what: "slab (soffit " + lv(slab-soffit) + ")", h: slab-soffit - t.z) }
  else { (what: "open well (roof soffit " + lv(roof-soffit) + ")", h: roof-soffit - t.z) }
}
#let head-rows(o) = o.treads.map(t => (t: t, s: over(o, t)))
#let head-min(o) = calc.min(..head-rows(o).map(r => r.s.h))

// ---------- The surroundings (data/rooms_gf.csv, rooms_ff.csv, design_gf.typ, ff_family.typ) ----------
#let lift = (0, 0, 2.25, 2.2)              // the shaft (placeholder); its door on x 2.25, y 0.9–1.9, sliding, both floors
#let lift-door = (0.9, 1.9)
#let notch = (2.25, 0.9, 2.75, 2.2)        // the lobby / gallery in front of the lift door
#let cupboard = (2.25, 0, 2.75, 0.9)       // GF entry cupboard, doors onto the lobby (x 2.75)
#let linen = (2.25, 0, 4.25, 0.7)          // FF linen cupboard, doors onto the gallery (y 0.7, x 2.45–4.05)
#let entry = (3.0, 4.0)                    // GF family entrance in the north wall, 1.0 m leaf opening inward
#let lobby = (2.75, 4.25)                  // the family lobby / riwaq (GF) and the gallery's north part (FF) on axes: 1.30 clear
#let majlis-wall = (0, 6.5)                // the women's majlis west wall x 4.25 (GF)
#let riwaq-glass = (6.8, 8.9)              // the riwaq's courtyard glass, x 4.25 (GF)
#let utility = (0, 7.9, 2.75, 10.4)        // GF utility room (the shaft inside, x 0–1.5, y 9.2–10.4)
#let landing-room = (0, 7.9, 2.75, 9.2)    // FF landing room (current)
#let bath = (1.5, 9.2, 4.25, 11.0)         // FF family bath; door at x 4.25, y 9.3–10.3 opening into the bath
#let shaft-ff = (0, 9.2, 1.5, 10.4)
#let kids-door = (1.9, 2.9)                // x 4.25, into the kids' room
#let living-open = (3.1, 4.5)              // x 4.25, the family living open to the gallery
#let store-cur = (0, 6.9, 2.75, 7.9)       // GF: the full-height store under the arrival strip (design_gf.typ inner box)
#let t-wall = 0.20
#let t-out = 0.25

// ---------- Ground-floor congestion test for the flipped start (persons as 0.60 m circles; a bag 0.45 × 0.35) ----------
#let P-lift = (2.6, 1.55)                  // waiting for the lift, in the notch in front of the sliding door
#let P-entry = (3.55, 1.05)                // coming in from the family entrance with bags, just inside the door's swing
#let bag = (3.9, 0.85, 4.1, 1.3)
#let P-stair = (2.05, 3.05)                // starting up the flipped stair: on the start strip, in front of the east flight's first riser (y 3.75)
#let cup-sweep = (2.75, 0.0, 3.2, 0.9)     // the entry cupboard's two 0.45 leaves open into the lobby (0.45 deep sweep)
#let door-sweep = (3.0, 0.0, 4.0, 1.0)     // the family entrance leaf (1.0) open, inside
#let persons = ((P-lift, [lift]), (P-entry, [entry + bags]), (P-stair, [stair]))
#let rect-dist(p, b) = { let dx = calc.max(b.at(0) - p.at(0), 0, p.at(0) - b.at(2)); let dy = calc.max(b.at(1) - p.at(1), 0, p.at(1) - b.at(3)); calc.sqrt(dx * dx + dy * dy) }
#let congestion-ok = persons.all(((p, l)) => persons.all(((q, m)) => l == m or dist(p, q) >= 0.60 + 0.15)) and rect-dist(P-stair, cup-sweep) >= 0.30 and rect-dist(P-stair, door-sweep) >= 0.30 and rect-dist(P-lift, door-sweep) >= 0.30 and rect-dist(P-stair, bag) >= 0.30
#let clear = (lobby: 4.25 - 2.75 - t-wall, notch: 2.75 - 2.25, start-open-flp: FLP.first - st.y0, start-strip-cur: store-cur.at(1) - CUR.first, flight: wf, entry-leaf: entry.at(1) - entry.at(0) - 0.1)

// ---------- Routes (metres along the walked lines, through the doors): to the stair top (FF), to the lift (FF, the same for both), from the family entrance to the stair foot (GF) ----------
#let top-cur = (1.4, 8.3)                                  // on the landing room, as studies/ff_family.typ
#let top-flp = (2.9, 3.05)                                 // at the arrival strip's opening onto the gallery (x 2.75, y 2.3–3.75)
#let via-gallery-cur(rest) = ((1.4, 8.3), (3.5, 8.3)) + rest                 // the current stair top joins the gallery's north part at y 8.3
#let via-gallery-flp-N(rest) = ((2.9, 3.05), (3.5, 3.05)) + rest             // the flipped top joins it at y 3.05
#let rooms-ff = (
  ([Kids' room (study; a bedroom later)], ((3.5, 2.4), (4.25, 2.4)), ((3.5, 2.4), (4.25, 2.4)), [gallery north → its door (4.25, y 1.9–2.9)]),
  ([Family living (open to the gallery)], ((3.5, 3.55), (4.8, 3.55), (4.8, 4.1)), ((3.5, 3.55), (4.8, 3.55), (4.8, 4.1)), [gallery north → the opening (y 3.1–4.5)]),
  ([Bedroom 1 (via the living)], ((3.5, 3.55), (8.4, 3.55), (8.4, 5.9), (9.55, 5.9), (9.55, 5.3)), ((3.5, 3.55), (8.4, 3.55), (8.4, 5.9), (9.55, 5.9), (9.55, 5.3)), [living (behind the sofa) → family link → its door]),
  ([Master suite (the suite door, via the family link)], ((3.5, 3.55), (8.4, 3.55), (8.4, 5.9), (9.55, 5.9), (9.55, 6.5)), ((3.5, 3.55), (8.4, 3.55), (8.4, 5.9), (9.55, 5.9), (9.55, 6.5)), [living → family link → the suite door (y 6.5)]),
  ([Family bath], ((4.9, 8.3), (4.9, 9.8), (4.25, 9.8)), ((3.5, 8.3), (4.9, 8.3), (4.9, 9.8), (4.25, 9.8)), [gallery → its door (4.25, y 9.3–10.3)]),
  ([Bedroom 2], ((4.9, 8.3), (4.9, 11.6), (4.25, 11.6)), ((3.5, 8.3), (4.9, 8.3), (4.9, 11.6), (4.25, 11.6)), [gallery on the projection → its door]),
  ([Bedroom 3], ((4.9, 8.3), (4.9, 15.0), (4.25, 15.0)), ((3.5, 8.3), (4.9, 8.3), (4.9, 15.0), (4.25, 15.0)), [gallery on the projection → its door]),
  ([Gym (the gallery's south end)], ((4.9, 8.3), (4.9, 19.25)), ((3.5, 8.3), (4.9, 8.3), (4.9, 19.25)), [gallery → the gym's sliding door]),
)
#let route-cur(r) = plen(via-gallery-cur(r.at(1)))
#let route-flp(r) = plen(via-gallery-flp-N(r.at(2)))
// to the lift (x 2.25, y 0.9–1.9): the same for both options (the lift does not move); from each room's door via the gallery's north part
#let lift-pt = (2.5, 1.4)
#let to-lift = (
  ([Kids' room], ((4.25, 2.4), (3.5, 2.4), (3.5, 1.4), lift-pt)),
  ([Family living], ((4.8, 4.1), (4.8, 3.55), (3.5, 3.55), (3.5, 1.4), lift-pt)),
  ([Bedroom 1], ((9.55, 5.3), (9.55, 5.9), (8.4, 5.9), (8.4, 3.55), (3.5, 3.55), (3.5, 1.4), lift-pt)),
  ([Master suite], ((9.55, 6.5), (9.55, 5.9), (8.4, 5.9), (8.4, 3.55), (3.5, 3.55), (3.5, 1.4), lift-pt)),
  ([Family bath], ((4.25, 9.8), (4.9, 9.8), (4.9, 8.3), (3.5, 8.3), (3.5, 1.4), lift-pt)),
  ([Bedroom 2], ((4.25, 11.6), (4.9, 11.6), (4.9, 8.3), (3.5, 8.3), (3.5, 1.4), lift-pt)),
  ([Bedroom 3], ((4.25, 15.0), (4.9, 15.0), (4.9, 8.3), (3.5, 8.3), (3.5, 1.4), lift-pt)),
  ([Gym], ((4.9, 19.25), (4.9, 8.3), (3.5, 8.3), (3.5, 1.4), lift-pt)),
)
// ground floor: the family entrance → the stair foot; the stair foot → the family door (escape)
#let gf-entry-cur = ((3.5, 0.5), (3.5, 6.6), (CUR.foot.at(0), 6.6), CUR.foot)       // along the riwaq, into the well through its open east side, across to the west flight
#let gf-entry-flp = ((3.5, 0.5), (3.5, 3.05), (FLP.foot.at(0), 3.05), FLP.foot)    // through the start opening, straight onto the east flight
#let gf-entry-lift = ((3.5, 0.5), (3.5, 1.4), lift-pt)
#let stair-walk = 2 * calc.sqrt(calc.pow(10 * st.g, 2) + calc.pow(11 * st.r, 2)) + land-d   // walked on the stair: two flights + the half landing (studies/fire_escape.typ)
#let foot-to-door-cur = plen((CUR.foot, (CUR.foot.at(0), 6.6), (3.5, 6.6), (3.5, 0.0)))
#let foot-to-door-flp = plen((FLP.foot, (FLP.foot.at(0), 3.05), (3.5, 3.05), (3.5, 0.0)))

// ---------- The freed landing (flipped): what it can become ----------
#let land-gross = (landing-room.at(2) - landing-room.at(0)) * (landing-room.at(3) - landing-room.at(1))     // 3.575 on axes
#let land-clear-w = landing-room.at(2) - t-out / 2 - t-wall / 2                                                 // 2.525 between the west wall face and the gallery line
#let land-clear-d = landing-room.at(3) - landing-room.at(1) - t-wall / 2 - t-wall / 2                           // 1.10 with a wall on y 7.9 (over the opening) and the bath wall y 9.2
#let land-net = land-clear-w * land-clear-d
#let linen-opt = (0.6, land-clear-w)                                                                             // F-a: a 0.6 m deep linen cupboard along the west wall
#let bath-L = (bath.at(2) - bath.at(0)) * (bath.at(3) - bath.at(1))                                              // the family bath today, 4.95 on axes

// ---------- Checks of this study ----------
#let checks = (
  ([the stair fits the well in both options: landing #r2(land-d) + flights #r2(10 * st.g) + strip #r2(arr-d) = #r2(st.y1 - st.y0) clear], calc.abs(land-d + 10 * st.g + arr-d - (st.y1 - st.y0)) < 1e-9),
  ([risers 0.164 × 22 = 3.60, goings 0.28: 2R + G = #r2(2 * st.r + st.g) in 0.60–0.65], 2 * st.r + st.g >= 0.60 and 2 * st.r + st.g <= 0.65),
  ([headroom ≥ 2.10 over every tread of the lower flight, both options (min #r2(head-min(CUR)) / #r2(head-min(FLP)))], head-min(CUR) >= 2.10 and head-min(FLP) >= 2.10),
  ([headroom aim ≥ 2.20 met in both (the trimmer over tread 6)], head-min(CUR) >= 2.20 and head-min(FLP) >= 2.20),
  ([the flipped B17′ lies on the lower flight's side of the split, never over the upper flight], FLP.b17x >= FLP.lo.at(0) and FLP.b17x <= FLP.lo.at(1)),
  ([the flipped start strip is #r2(clear.start-open-flp) m deep in front of the first riser (≥ 1.20); the current one has #r2(clear.start-strip-cur) m before the store wall], clear.start-open-flp >= 1.2),
  ([ground-floor congestion (flipped): the lift waiter, the person with bags and the stair starter keep ≥ 0.15 m between their 0.60 m circles and 0.30 m off the open leaves], congestion-ok),
  ([the lobby's real clear width #r2(clear.lobby) m ≥ 1.20 (the notch adds #r2(clear.notch) in front of the lift door)], clear.lobby >= 1.2),
  ([the flipped arrival strip opens onto the gallery 0.10 m south of the lift notch: the two do not overlap], FLP.arr.at(0) >= notch.at(3) + 0.1 - 1e-9),
  ([the children's study room and the family living gain, bedrooms 2 and 3 lose (routes computed)], route-flp(rooms-ff.at(0)) < route-cur(rooms-ff.at(0)) and route-flp(rooms-ff.at(5)) > route-cur(rooms-ff.at(5))),
  ([the ground-floor escape from the stair foot to the family door shortens in the flip (#r1(foot-to-door-cur) → #r1(foot-to-door-flp) m)], foot-to-door-flp < foot-to-door-cur),
)
#let all-ok = checks.all(c => c.at(1))

// ====================================================================================== drawing helpers
#let q(p) = (p.at(0), -p.at(1))
#let plan-gf(o, length: 1.25cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, t, size: 3.6pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, t))
  let R(b, fill: none, stroke: none) = rect(q((b.at(0), b.at(1))), q((b.at(2), b.at(3))), fill: fill, stroke: stroke)
  let wall(x0, y0, x1, y1) = R((x0, y0, x1, y1), fill: luma(120))
  // floors
  R((-0.125, -0.125, 4.75, 11.0), fill: rgb("#f1efe8"))                       // the riwaq / lobby and the west band
  R((2.75, 0, 4.25, 11.0), fill: rgb("#f6f2e6"))                              // the lobby + riwaq
  R((4.25, 0, 4.75, 6.5), fill: rgb("#f6e3c0")); T((4.5, 3.3), [women's majlis], size: 3.2pt, angle: 90deg)
  R((4.25, 6.5, 4.75, 11.0), fill: rgb("#dbe9f4")); T((4.5, 8.8), [courtyard], size: 3.2pt, angle: 90deg, fill: blue)
  R(lift, fill: rgb("#e4ded2")); T((1.1, 1.3), [LIFT shaft\ 2.25 × 2.2 (placeholder)], size: 3.4pt)
  R(utility, fill: rgb("#e4ded2")); T((1.4, 9.0), [utility room\ (the shaft x 0–1.5)], size: 3.4pt); R((0, 9.2, 1.5, 10.4), fill: none, stroke: (paint: ink, dash: "dashed", thickness: 0.4pt))
  R(cupboard, fill: rgb("#d9cfb8")); T((2.5, 0.45), [entry\ cupb.], size: 2.8pt)
  // the well floor: the start strip (GF ±0.00) and the under-stair zones
  R((st.x0, st.y0, st.x1, st.y1), fill: rgb("#ece8dd"))
  R((st.x0, o.arr.at(0), st.x1, o.arr.at(1)), fill: rgb("#f7f3e8"), stroke: 0.3pt + ink)
  R((o.up.at(0), calc.min(o.first, o.first + o.d * 10 * st.g), o.up.at(1), calc.max(o.first, o.first + o.d * 10 * st.g)), fill: rgb("#e6e2d6"))   // under the upper flight
  R((st.x0, o.land.at(0), st.x1, o.land.at(1)), fill: rgb("#d9d3c4"), stroke: 0.3pt + ink)   // under the half landing: the store (1.65 m)
  T(((st.x0 + st.x1) / 2, (o.land.at(0) + o.land.at(1)) / 2), [store under the half landing\ ≈ 1.65 m headroom], size: 3pt)
  T(((o.up.at(0) + o.up.at(1)) / 2, 5.05), [under the\ upper flight], size: 3pt, fill: luma(110), angle: 90deg)
  if o.start == "S" { R(store-cur, fill: rgb("#d9d3c4"), stroke: 0.3pt + ink); T((1.4, 7.4), [full-height store 2.525 × 0.8 clear], size: 3pt) }
  else { R((W.at(0), st.y0, W.at(1), o.first), fill: rgb("#d9cfb8"), stroke: 0.3pt + ink); T((0.73, 3.0), [NEW coat / shoe\ cupboard 1.21 × 1.45\ full height, sliding doors], size: 2.9pt) }
  // the lower flight (GF): risers and the arrow
  for t in o.treads { line(q((o.lo.at(0), if o.d < 0 { t.ya } else { t.yb })), q((o.lo.at(1), if o.d < 0 { t.ya } else { t.yb })), stroke: 0.4pt + ink); T((o.lo.at(0) + 0.14, (t.ya + t.yb) / 2), [#t.i], size: 2.6pt) }
  line(q((o.lo.at(0), o.first)), q((o.lo.at(1), o.first)), stroke: 0.9pt + ink)
  line(q(((o.lo.at(0) + o.lo.at(1)) / 2, o.first - o.d * 0.1)), q(((o.lo.at(0) + o.lo.at(1)) / 2, o.first + o.d * 2.4)), stroke: 0.8pt + red, mark: (end: "stealth", fill: red, scale: 0.5)); T(((o.lo.at(0) + o.lo.at(1)) / 2 + 0.3, o.first + o.d * 1.3), [UP · lower flight], size: 3pt, fill: red, angle: 90deg)
  // the upper flight (above, light) and the central handrail
  for i in range(11) { let y = o.land.at(if o.d < 0 { 1 } else { 0 }) - o.d * i * st.g; line(q((o.up.at(0), y)), q((o.up.at(1), y)), stroke: 0.3pt + luma(170)) }
  R((st.split - st.gap / 2, calc.min(o.first, o.first + o.d * 10 * st.g), st.split + st.gap / 2, calc.max(o.first, o.first + o.d * 10 * st.g)), fill: luma(100))
  line(q((o.lo.at(0) + 0.08, calc.min(o.first, o.first + o.d * 10 * st.g))), q((o.lo.at(0) + 0.08, calc.max(o.first, o.first + o.d * 10 * st.g))), stroke: 0.5pt + luma(90))   // wall handrail
  T((o.lo.at(0) + 0.08, 5.05 + o.d * 0.0), [], size: 2pt)
  // walls: the well, the lift, the band, the north outer wall, the majlis wall, the riwaq glass
  wall(-0.125, -0.125, 0.125, 11.0); wall(-0.125, -0.125, 4.75, 0.125)
  wall(0, 2.1, 2.75, 2.3); wall(0, 7.8, 2.85, 8.0); wall(2.15, 0, 2.35, 0.9); wall(2.15, 1.9, 2.35, 2.3)
  wall(2.65, 2.1, 2.85, 2.4)
  if o.start == "S" { wall(2.65, 6.8, 2.85, 8.0); line(q((2.75, 2.4)), q((2.75, 6.8)), stroke: (paint: luma(120), dash: "dashed", thickness: 0.6pt)); T((2.95, 4.6), [open to the riwaq (4.4 m)], size: 3pt, angle: 90deg) }
  else {
    line(q((2.75, 2.3)), q((2.75, o.first)), stroke: (paint: luma(120), dash: "dashed", thickness: 0.6pt)); T((2.95, 3.0), [start opening #r2(o.first - st.y0)], size: 3pt, angle: 90deg)
    line(q((2.72, o.first)), q((2.72, o.land.at(0))), stroke: 1.2pt + luma(60)); T((2.95, 5.2), [balustrade 0.90 along the lower flight (or a wall)], size: 3pt, angle: 90deg)
    wall(2.65, o.land.at(0), 2.85, 8.0); line(q((2.75, 6.7)), q((2.75, 7.6)), stroke: 2.4pt + red); T((2.95, 7.15), [store door], size: 3pt, angle: 90deg, fill: red)
  }
  wall(4.15, 0, 4.35, 6.5); wall(4.15, 8.9, 4.35, 11.0); line(q((4.25, 6.5)), q((4.25, 6.8)), stroke: 1pt + ink); line(q((4.25, 6.8)), q((4.25, 8.9)), stroke: 2pt + blue); T((4.05, 7.85), [riwaq glass], size: 3pt, angle: 90deg, fill: blue)
  wall(2.65, 7.9, 2.85, 11.0)
  // the lift door (sliding) and the entry cupboard doors, the family entrance door with its swing
  line(q((2.25, lift-door.at(0))), q((2.25, lift-door.at(1))), stroke: 2.4pt + red); T((2.5, 1.4), [lift\ door], size: 2.8pt, fill: red)
  line(q((2.75, 0.05)), q((2.75, 0.85))); arc(q((2.75, 0.05)), start: 0deg, stop: 90deg, radius: 0.45, stroke: (paint: red, thickness: 0.3pt, dash: "dotted"), anchor: "origin"); arc(q((2.75, 0.85)), start: 0deg, stop: -90deg, radius: 0.45, stroke: (paint: red, thickness: 0.3pt, dash: "dotted"), anchor: "origin")
  line(q((entry.at(0), 0)), q((entry.at(1), 0)), stroke: 2.6pt + red); arc(q((entry.at(0), 0)), start: 0deg, stop: -90deg, radius: 1.0, stroke: (paint: red, thickness: 0.4pt, dash: "dotted"), anchor: "origin"); T((3.5, -0.35), [FAMILY ENTRANCE · 1.0 leaf, opens in], size: 3pt, fill: red)
  // the flipped congestion test
  if o.start == "N" {
    for (p, l) in persons { circle(q(p), radius: 0.30, fill: rgb("#ffe08a").transparentize(30%), stroke: 0.4pt + amber); T(p, l, size: 2.8pt) }
    R(bag, fill: rgb("#ffe08a"), stroke: 0.4pt + amber)
    line(q((3.1, 0.5)), q((3.5, 3.05)), q((FLP.foot.at(0), 3.05)), q(FLP.foot), stroke: (paint: green, thickness: 0.7pt, dash: "dashed"), mark: (end: "stealth", fill: green, scale: 0.5))
  } else {
    line(q((3.5, 0.5)), q((3.5, 6.6)), q((CUR.foot.at(0), 6.6)), q(CUR.foot), stroke: (paint: green, thickness: 0.7pt, dash: "dashed"), mark: (end: "stealth", fill: green, scale: 0.5))
  }
  // dimensions and labels
  T((1.4, -0.45), [GF · #o.name · 1 m = 1.25 cm · north up], size: 4pt, fill: accent)
  line(q((2.85, 10.6)), q((4.15, 10.6)), stroke: 0.4pt + ink, mark: (start: "|", end: "|", scale: 0.4)); T((3.5, 10.45), [#r2(clear.lobby) clear], size: 3pt)
  T((3.5, 5.0), [riwaq], size: 3.6pt, fill: luma(110), angle: 90deg)
  T((1.4, (o.arr.at(0) + o.arr.at(1)) / 2 + (if o.start == "S" { 0.25 } else { -0.5 })), [start strip ±0.00 · #r2(arr-d) deep], size: 3pt, fill: luma(90))
})
#let plan-ff(o, length: 1.25cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, t, size: 3.6pt, fill: ink, anchor: "center", angle: 0deg) = content(q(p), anchor: anchor, angle: angle, text(size, fill: fill, t))
  let R(b, fill: none, stroke: none) = rect(q((b.at(0), b.at(1))), q((b.at(2), b.at(3))), fill: fill, stroke: stroke)
  let wall(x0, y0, x1, y1) = R((x0, y0, x1, y1), fill: luma(120))
  R((-0.125, -0.125, 4.75, 11.0), fill: rgb("#f1efe8"))
  R((2.25, 0.7, 4.25, 11.0), fill: rgb("#f6f2e6"))                           // the gallery's north part (+ the notch)
  R((4.25, 0, 4.75, 3.0), fill: rgb("#f3d6c4")); T((4.5, 1.5), [kids' room], size: 3.2pt, angle: 90deg)
  R((4.25, 3.0, 4.75, 6.5), fill: rgb("#f6e3c0")); T((4.5, 4.75), [family living], size: 3.2pt, angle: 90deg)
  R((4.25, 6.5, 4.75, 11.0), fill: rgb("#dbe9f4")); T((4.5, 8.8), [void · W1], size: 3.2pt, angle: 90deg, fill: blue)
  R(lift, fill: rgb("#e4ded2")); T((1.1, 1.3), [LIFT], size: 3.6pt)
  R(linen, fill: rgb("#d9cfb8")); T((3.25, 0.35), [linen cupboard], size: 3pt)
  R(bath, fill: rgb("#cfe6ef")); T((3.3, 10.1), [family bath 2.75 × 1.8], size: 3.2pt); R(shaft-ff, fill: rgb("#e4ded2")); T((0.75, 9.8), [shaft], size: 3pt); R((0, 10.4, 1.5, 11.0), fill: rgb("#f6e3c0")); T((0.75, 10.7), [wardrobe niche (bed 2)], size: 2.6pt)
  R((1.6, 9.35, 2.25, 9.8), fill: white, stroke: 0.3pt + ink); T((1.9, 9.57), [WC], size: 2.6pt); R((1.6, 10.0, 2.5, 10.9), fill: white, stroke: 0.3pt + ink); T((2.05, 10.45), [shower], size: 2.6pt)
  // the well at the FF: slab (grey), the opening (white), the arrival strip, the trimmers
  R((st.x0, st.y0, st.x1, st.y1), fill: luma(225))
  R((o.lo.at(0), o.open-lo.at(0), o.lo.at(1), o.open-lo.at(1)), fill: white, stroke: 0.3pt + ink)
  R((o.up.at(0), o.open-up.at(0), o.up.at(1), o.open-up.at(1)), fill: white, stroke: 0.3pt + ink)
  R((st.x0, o.land.at(0), st.x1, o.land.at(1)), fill: rgb("#f3dfb8"), stroke: 0.3pt + ink); T(((st.x0 + st.x1) / 2, (o.land.at(0) + o.land.at(1)) / 2), [half landing +1.80], size: 3pt)
  R((st.x0, o.arr.at(0), st.x1, o.arr.at(1)), fill: rgb("#e8e2d2"), stroke: 0.3pt + ink); T((1.4, (o.arr.at(0) + o.arr.at(1)) / 2), [arrival strip +3.60 · #r2(arr-d) deep], size: 3pt)
  // the upper flight treads (up to the top riser), the lower flight below (dashed, under the slab)
  for i in range(11) { let y = o.land.at(if o.d < 0 { 1 } else { 0 }) - o.d * i * st.g; line(q((o.up.at(0), y)), q((o.up.at(1), y)), stroke: 0.4pt + ink); T((o.up.at(1) - 0.14, y + o.d * 0.14), [#(i + 12)], size: 2.6pt) }
  line(q((o.up.at(0), o.top)), q((o.up.at(1), o.top)), stroke: 0.9pt + ink)
  line(q(((o.up.at(0) + o.up.at(1)) / 2, o.land.at(if o.d < 0 { 1 } else { 0 }) + o.d * 0.0)), q(((o.up.at(0) + o.up.at(1)) / 2, o.top + o.d * 0.9)), stroke: 0.8pt + red, mark: (end: "stealth", fill: red, scale: 0.5)); T(((o.up.at(0) + o.up.at(1)) / 2 - 0.3, 5.05), [upper flight · UP], size: 3pt, fill: red, angle: 90deg)
  for t in o.treads.filter(t => t.i > 6) { line(q((o.lo.at(0), if o.d < 0 { t.ya } else { t.yb })), q((o.lo.at(1), if o.d < 0 { t.ya } else { t.yb })), stroke: (paint: luma(150), thickness: 0.3pt, dash: "dashed")) }
  R((st.split - st.gap / 2, calc.min(o.first, o.first + o.d * 10 * st.g), st.split + st.gap / 2, calc.max(o.first, o.first + o.d * 10 * st.g)), fill: luma(100))
  // trimmers
  line(q((o.lo.at(0) - (if o.lower == "W" { 0.125 } else { 0 }), (o.b16.at(0) + o.b16.at(1)) / 2)), q((if o.lower == "W" { o.b17x } else { 2.75 }, (o.b16.at(0) + o.b16.at(1)) / 2)), stroke: 2.2pt + red)
  if o.lower == "E" { line(q((o.lo.at(0), (o.b16.at(0) + o.b16.at(1)) / 2)), q((2.75, (o.b16.at(0) + o.b16.at(1)) / 2)), stroke: 2.2pt + red) }
  line(q((o.b17x, (o.b16.at(0) + o.b16.at(1)) / 2)), q((o.b17x, (o.b18.at(0) + o.b18.at(1)) / 2)), stroke: 2.2pt + red)
  if o.lower == "W" { line(q((o.b17x, (o.b18.at(0) + o.b18.at(1)) / 2)), q((2.75, (o.b18.at(0) + o.b18.at(1)) / 2)), stroke: 2.2pt + red) } else { line(q((0, (o.b18.at(0) + o.b18.at(1)) / 2)), q((o.b17x, (o.b18.at(0) + o.b18.at(1)) / 2)), stroke: 2.2pt + red) }
  T((o.lo.at(0) + 0.5, (o.b16.at(0) + o.b16.at(1)) / 2 + o.d * 0.22), [B16#if o.start == "N" [′] · soffit #lv(trim-soffit)], size: 3pt, fill: red)
  T((o.b17x + (if o.lower == "W" { -0.14 } else { 0.14 }), (o.b16.at(1) + o.b18.at(0)) / 2), [B17#if o.start == "N" [′]], size: 3pt, fill: red, angle: 90deg)
  T((if o.lower == "W" { 2.1 } else { 0.7 }, (o.b18.at(0) + o.b18.at(1)) / 2 - o.d * 0.22), [B18#if o.start == "N" [′]], size: 3pt, fill: red)
  // walls and the railing
  wall(-0.125, -0.125, 0.125, 11.0); wall(-0.125, -0.125, 4.75, 0.125)
  wall(0, 2.1, 2.75, 2.3); wall(2.15, 0.7, 2.35, 0.9); wall(2.15, 1.9, 2.35, 2.3); wall(2.65, 2.1, 2.85, 2.4)
  wall(4.15, 0, 4.35, 1.9); wall(4.15, 2.9, 4.35, 3.1); wall(4.15, 4.5, 4.35, 6.5); wall(1.5, 9.1, 4.25, 9.3); wall(1.4, 9.2, 1.6, 11.0); wall(0, 10.9, 4.25, 11.1); wall(4.15, 9.2, 4.35, 9.3); wall(4.15, 10.3, 4.35, 11.0)
  line(q((4.25, 6.5)), q((4.25, 9.2)), stroke: 2pt + blue)   // W1 on the projection edge starts south of y 6.5 (here only the gallery line)
  if o.start == "S" {
    line(q((2.72, 2.4)), q((2.72, 6.8)), stroke: 1.2pt + luma(60)); T((2.95, 4.6), [railing 1.10 on the well], size: 3pt, angle: 90deg)
    wall(2.65, 6.8, 2.85, 7.9); R(landing-room, fill: rgb("#e8e2d2"), stroke: 0.3pt + ink); T((1.4, 8.55), [LANDING ROOM 2.75 × 1.3 · open to the gallery →], size: 3.2pt)
  } else {
    line(q((2.72, o.first)), q((2.72, 7.9)), stroke: 1.2pt + luma(60)); T((2.95, 5.8), [railing 1.10 on the well], size: 3pt, angle: 90deg)
    line(q((0.125, 7.87)), q((2.65, 7.87)), stroke: 1.2pt + luma(60)); T((1.4, 7.65), [guard 1.10 over the opening (or a wall on B12)], size: 2.8pt)
    R(landing-room, fill: rgb("#dcecd2"), stroke: (paint: green, thickness: 0.6pt, dash: "dashed")); T((1.4, 8.55), [FREED #r2(land-gross) m² on axes · #r2(land-net) m² net\ (F-a nook + linen · F-b bigger bath)], size: 3pt, fill: green)
    line(q((2.75, st.y0)), q((2.75, o.first)), stroke: (paint: luma(120), dash: "dashed", thickness: 0.6pt)); T((2.95, 3.0), [arrival → gallery #r2(o.first - st.y0)], size: 3pt, angle: 90deg)
  }
  // doors
  line(q((2.25, lift-door.at(0))), q((2.25, lift-door.at(1))), stroke: 2.4pt + red); T((2.5, 1.4), [lift\ door], size: 2.8pt, fill: red)
  line(q((2.45, 0.7)), q((4.05, 0.7)), stroke: 1.6pt + red); arc(q((2.45, 0.7)), start: 0deg, stop: 90deg, radius: 0.6, stroke: (paint: red, thickness: 0.3pt, dash: "dotted"), anchor: "origin")
  line(q((4.25, kids-door.at(0))), q((4.25, kids-door.at(1))), stroke: 2.4pt + red); T((4.45, 2.4), [kids' door →], size: 2.6pt, fill: red, angle: 90deg)
  line(q((4.25, living-open.at(0))), q((4.25, living-open.at(1))), stroke: (paint: red, thickness: 1pt, dash: "dashed")); T((4.45, 3.8), [open], size: 2.6pt, fill: red, angle: 90deg)
  line(q((4.25, 9.3)), q((4.25, 10.3)), stroke: 2.4pt + red); arc(q((4.25, 9.3)), start: 180deg, stop: 270deg, radius: 1.0, stroke: (paint: red, thickness: 0.3pt, dash: "dotted"), anchor: "origin"); T((4.45, 9.8), [bath door], size: 2.6pt, fill: red, angle: 90deg)
  // the route from the stair top to the gallery
  let top = if o.start == "S" { top-cur } else { top-flp }
  line(q(o.head), q((o.head.at(0), top.at(1))), q(top), q((3.5, top.at(1))), stroke: (paint: green, thickness: 0.7pt, dash: "dashed"), mark: (end: "stealth", fill: green, scale: 0.5)); T((o.head.at(0), o.first + o.d * 0.35), [▲ top], size: 3pt, fill: green)
  T((1.4, -0.45), [FF · #o.name · 1 m = 1.25 cm · white = opening · grey = slab], size: 4pt, fill: accent)
  T((3.5, 5.5), [gallery north part], size: 3.4pt, fill: luma(110), angle: 90deg)
})
#let section(o, length: 1.0cm) = cetz.canvas(length: length, {
  import cetz.draw: *
  let T(p, t, size: 3.6pt, fill: ink, anchor: "center", angle: 0deg) = content(p, anchor: anchor, angle: angle, text(size, fill: fill, t))
  // N–S section through the well looking east (y along, z up): the lower flight (near, solid), the upper flight (far, dashed), the slab, the trimmers, the walls
  let Y(y) = y - 1.6
  line((Y(1.6), 0), (Y(8.6), 0), stroke: 0.8pt + ink)
  rect((Y(2.1), 0), (Y(2.3), 7.2), fill: luma(190), stroke: none); rect((Y(7.8), 0), (Y(8.0), 7.2), fill: luma(190), stroke: none)
  rect((Y(0.0), ff - fin - slab), (Y(2.1), ff - fin), fill: luma(120), stroke: none); rect((Y(8.0), ff - fin - slab), (Y(8.6), ff - fin), fill: luma(120), stroke: none)   // the slabs beyond the well walls
  rect((Y(1.6), 7.0), (Y(8.6), 7.2), fill: luma(120), stroke: none); T((Y(5.05), 7.4), [roof slab closed over the well (V8.0) · soffit #lv(roof-soffit)], size: 3.2pt)
  // the lower flight
  for t in o.treads { let ya = if o.d < 0 { t.yb } else { t.ya }; let yb = if o.d < 0 { t.ya } else { t.yb }; line((Y(ya), t.z - st.r), (Y(ya), t.z), (Y(yb), t.z), stroke: 0.6pt + ink) }
  line((Y(o.first), 0), (Y(o.first + o.d * 10 * st.g), 10 * st.r), stroke: 0.3pt + luma(140))
  // the half landing and the store under it; the upper flight (dashed)
  rect((Y(o.land.at(0)), 1.8 - 0.15), (Y(o.land.at(1)), 1.8), fill: luma(120), stroke: none); T((Y((o.land.at(0) + o.land.at(1)) / 2), 0.8), [store\ ≈ 1.65], size: 3.2pt)
  line(..range(12).map(i => (Y(o.land.at(if o.d < 0 { 1 } else { 0 }) - o.d * i * st.g), 1.8 + i * st.r)), stroke: (paint: luma(120), dash: "dashed", thickness: 0.6pt)); T((Y(o.first + o.d * 1.2), 3.2), [upper flight beyond], size: 3.2pt, fill: luma(110))
  // the FF slab over the lower half: from the start end to B16; the arrival strip; the trimmers B16 and B18
  rect((Y(o.slab-lo.at(0)), ff - fin - slab), (Y(o.slab-lo.at(1)), ff - fin), fill: luma(120), stroke: none)
  rect((Y(o.b16.at(0)), trim-soffit), (Y(o.b16.at(1)), ff - fin - slab), fill: red, stroke: none); T((Y((o.b16.at(0) + o.b16.at(1)) / 2), trim-soffit - 0.18), [B16#if o.start == "N" [′] soffit #lv(trim-soffit)], size: 3.2pt, fill: red)
  rect((Y(o.b18.at(0)), trim-soffit), (Y(o.b18.at(1)), ff - fin - slab), fill: red.transparentize(50%), stroke: none); T((Y((o.b18.at(0) + o.b18.at(1)) / 2), trim-soffit - 0.18), [B18#if o.start == "N" [′] (far half)], size: 3pt, fill: red)
  // finish line and the arrival strip
  rect((Y(o.arr.at(0)), ff - fin), (Y(o.arr.at(1)), ff), fill: luma(200), stroke: none); T((Y((o.arr.at(0) + o.arr.at(1)) / 2), ff + 0.2), [arrival +3.60], size: 3.2pt)
  // headroom marks over every tread under the slab / trimmer
  for r in head-rows(o).filter(r => r.s.h < 4) { let ym = (r.t.ya + r.t.yb) / 2; line((Y(ym), r.t.z), (Y(ym), r.t.z + r.s.h), stroke: (paint: green, thickness: 0.4pt, dash: "dotted")) }
  let m = head-rows(o).sorted(key: r => r.s.h).first()
  line((Y((m.t.ya + m.t.yb) / 2), m.t.z), (Y((m.t.ya + m.t.yb) / 2), m.t.z + m.s.h), stroke: 0.7pt + green, mark: (start: "|", end: "|", scale: 0.4)); T((Y((m.t.ya + m.t.yb) / 2) - o.d * 0.55, m.t.z + 1.0), [#r2(m.s.h)\ tread #m.t.i], size: 3.4pt, fill: green)
  for (z, l) in ((0, [±0.00]), (1.8, [+1.80]), (3.6, [+3.60]), (7.2, [+7.20])) { T((Y(1.45), z), l, size: 3.2pt, fill: gray, anchor: "east") }
  T((Y(2.2), -0.4), [N], size: 4pt); T((Y(7.9), -0.4), [S], size: 4pt)
  T((Y(5.05), -0.75), [#o.name · section along the lower flight, looking east · 1 m = 1 cm], size: 4pt, fill: accent)
})

// ====================================================================================== PAGE 1 · the ground floor
#text(14pt, weight: "bold", fill: accent)[Stair flip study · the main stair turned round: start and arrival at the NORTH end, next to the lift · Taif / Palm House V8.0 (work) · STUDY ONLY]
#v(1pt)
#text(8pt, fill: gray)[Owner's idea, 1 Nov 2026 after V8.0 · the same well (2.75 × 5.7 on axes, 2.525 × 5.50 clear), the same 22 risers × 0.164 / goings 0.28, flights #r2(wf) clear · nothing in the design files changes until the owner decides · all sizes assumed]
#v(3pt)
#grid(columns: (auto, auto, 1fr), gutter: 8pt,
  plan-gf(CUR), plan-gf(FLP),
  [
    #set text(6.5pt)
    #H[1 · The two options on the ground floor]
    - *Current:* the lower flight on the *west* half starts at the *south* end (first riser y #r2(CUR.first)); the person comes along the riwaq, enters the well through its open east side (4.4 m open) and turns west onto the flight; in front of the first riser only *#r2(clear.start-strip-cur) m* before the full-height store's wall (the start is really made from the side, under the upper flight's high end). Half landing at the north end (+1.80, a 1.65 m store below it, opening east onto the riwaq); the full-height store 2.525 × 0.8 clear at the south end.
    - *Flipped (B, recommended of the two flips):* the lower flight on the *east* half starts at the *north* end (first riser y #r2(FLP.first)), *straight off the lobby*: a #r2(clear.start-open-flp) m opening in the x 2.75 line between the lift notch and the flight, a start strip #r2(arr-d) m deep in front of the first riser. The lower flight rises along the riwaq side (a 0.90 balustrade on the riwaq, or a wall: the owner's choice); the half landing at the south end with its 1.65 m store (door onto the riwaq at y 6.7–7.6, in front of the courtyard glass; or into the utility room). The *west half of the start strip* (1.21 × 1.45, full height) becomes a *coat / shoe cupboard* beside the family entrance (sliding doors onto the strip).
    - *Flipped (A):* the mirror image only (the lower flight stays west): the person crosses the whole strip to the far half before climbing; no cupboard. Not recommended; everything else below holds for both.
    #v(2pt)
    #H[2 · Congestion test at the flipped start (drawn)]
    Three people at once: *one waiting for the lift* in the 0.50 m notch in front of its sliding door, *one coming in with bags* inside the family entrance's 1.0 m swing, *one starting up the stair* on the start strip, with the *entry cupboard's two 0.45 leaves open* into the lobby. Clear widths, not axes: the lobby *#r2(clear.lobby) m* between the lift / cupboard wall face and the women's majlis wall face (the notch adds #r2(clear.notch) m at y 0.9–2.2); the start opening *#r2(clear.start-open-flp) m*; the first riser *#r2(wf) m* wide; the entrance *#r2(clear.entry-leaf) m* clear. The three stand in three separate zones along the lobby (y 0–1.0 the door swing, y 0.9–2.2 the lift notch, y 2.3–3.75 the start strip); the stair starter passes 0.3 m south of the lift waiter and never crosses the entrance swing: #if congestion-ok [#OK] else [#NO]. Two people can pass in the 1.30 m lobby (0.60 + 0.60 + 0.10) but a person with two bags blocks it for a moment, as today. *Furniture up the stair:* the 90° turn from the 1.30 lobby through the 1.45 opening onto the 1.21 flight is a tight but normal house stair turn; the current start (0.55 m strip, sideways) is worse.
    #v(2pt)
    #H[7 · Under-stair storage]
    - *Current:* the 1.65 m store under the half landing (2.525 × 1.25, north end, door onto the riwaq) *+* the full-height store at the south end (2.525 × 0.8 clear, 3.4 m high): ≈ #r1(2.525 * 1.25 + 2.525 * 0.8) m² of floor, the tall one behind the stair, far from the entrance.
    - *Flipped (B):* the 1.65 m store moves to the *south* end (door onto the riwaq by the courtyard glass, or into the utility room's north wall: a service store for the shaft side); the full-height store becomes the *coat / shoe cupboard at the entrance* (1.21 × 1.45 = #r1(1.21 * 1.45) m², 3.4 m high) *+* the low wedge under the upper (west) flight's foot (≈ 1.2 × 1.2, 1.0–1.6 m). ≈ #r1(2.525 * 1.25 + 1.21 * 1.45) m² of floor: a little less, far more useful (coats, shoes, the pram by the door; the entry cupboard today is 0.5 × 0.9). The utility room is untouched in both (its north wall y 7.9 stays; only the store's door may come through it).
  ],
)

// ====================================================================================== PAGE 2 · the first floor
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[First floor · the arrival, the opening and its trimmers, the freed landing · current vs flipped]
#v(2pt)
#grid(columns: (auto, auto, 1fr), gutter: 8pt,
  plan-ff(CUR), plan-ff(FLP),
  [
    #set text(6.5pt)
    #H[1 · The arrival]
    - *Current:* the upper flight (east half) lands at +3.60 on the arrival strip (y #r2(CUR.arr.at(0))–#r2(CUR.arr.at(1))), then the *landing room* (2.75 × 1.3, y 7.9–9.2) and east into the gallery; the bedrooms and the family bath are at hand, the kids' room, the living and the lift are 6–9 m north along the gallery.
    - *Flipped (B):* the upper flight (west half) lands on the arrival strip at the *north* end (y #r2(FLP.arr.at(0))–#r2(FLP.arr.at(1))); the strip opens east onto the gallery's north part (#r2(clear.start-open-flp) m), *0.10 m south of the lift notch*: the lift's first-floor door, the linen cupboard (its leaves swing south, 0.6 m), the kids' room door (opens into the room) and the family living's opening are all within 1–3 m. The gallery's north part (1.30 clear) carries the arrival traffic as it carries the lift's today; the linen leaves and the lift door are 1.0 m north of the arrival: no clash. The railing on the well runs from the arrival (y #r2(FLP.first)) to the south wall; the landing room is *freed* (§ 5).
    #v(2pt)
    #H[4 · The first-floor opening and its trimmers]
    - *Current (studies/structure.typ):* an L-shaped opening ≈ 8.2 m²: the west half open from the north wall to B16 (y 4.85), the east half open to B18 (y 6.45); B16 (0.20 × 0.40, soffit #lv(trim-soffit)) from the west wall to B17; B17 (x #r2(CUR.b17x), on the lower flight's side of the split) from B16 to B18; B18 (y 6.45) from B17 to the riwaq-line beam B10 (x 2.75).
    - *Flipped (B):* the *same opening turned round* (≈ 8.2 m²): the east half open from B16′ (y #r2((FLP.b16.at(0) + FLP.b16.at(1)) / 2)) to the south wall, the west half from B18′ (y #r2((FLP.b18.at(0) + FLP.b18.at(1)) / 2)) to the south wall. *B16′* (y #r2((FLP.b16.at(0) + FLP.b16.at(1)) / 2)) from the riwaq-line beam B10 to B17′; *B17′* (x #r2(FLP.b17x), on the east, lower flight's side of the split: never over the upper flight) from B16′ to B18′; *B18′* (y #r2((FLP.b18.at(0) + FLP.b18.at(1)) / 2), the arrival edge) from the west wall to B17′. The same zigzag, mirrored: one beam-on-beam junction at each end of B17′, the torsion the engineer's; B18′ now bears on the west wall (as B16 does today) and B16′ on B10 (as B18 does today). *Neither better nor worse* for the structure: the spans (1.3–1.6 m) and the bearings are the same kind. *Not verified.*
    - *Slab edges:* the arrival strip (1.45 × 2.525) spans between the north wall beam B11 (y 2.2) and B18′; over the lower flight's first six treads the slab spans from B18′ to B16′ (1.6 m) between B10 and B17′. The guard round the opening: the railing on x 2.75 from the arrival south to y 7.9, the well's south wall line y 7.9 (a 1.10 guard or a wall on B12), the upper flight's balustrade on the split.
    #v(2pt)
    #H[5 · The freed landing: what it can really become]
    - *Gross* #r2(land-gross) m² on axes (2.75 × 1.3). *Net* between finished faces, keeping the gallery connection on its east side and a guard or wall on the opening (y 7.9): *#r2(land-clear-w) × #r2(land-clear-d) = #r2(land-net) m²*.
    - *F-a · gallery nook + linen:* leave it open to the gallery with a 1.10 guard over the well; a *0.6 m linen / towel cupboard* along the west wall (#r2(linen-opt.at(0)) × #r2(linen-opt.at(1)) = #r2(linen-opt.at(0) * linen-opt.at(1)) m², next to the family bath's door); the rest (#r2(land-clear-w - 0.6) × #r2(land-clear-d)) widens the gallery to a *2.9 m deep nook* in front of the bath door: a bench, the laundry basket, a window on the west wall (y 8.0–9.1). Net storage gained #r2(linen-opt.at(0) * linen-opt.at(1)) m²; the gallery is not wider where it matters (the 1.30 m north part stays 1.30).
    - *F-b · a larger family bath (recommended):* a wall on y 7.9 (on B12) and the bath's north wall y 9.2 opened: the bath becomes an *L of #r2(bath-L) + #r2(land-gross) = #r2(bath-L + land-gross) m² on axes* (≈ #r2(land-net + 2.525 * 1.6) m² clear) with its door where it is (4.25, y 9.3–10.3): a *separate WC compartment* 1.3 × 1.1 at the north-west corner next to the shaft (the stack is right there: the WC drains to the x 1.5 shaft as today), the shower and a *second basin* for the two children, the linen in the compartment's wall. Net usable gain ≈ #r2(land-net) m²: one WC door more than today (two children at the same time), nothing lost. The family bath serves bedrooms 1 and 2 and the living; this also answers part of the review's next item (bedroom 1's bathroom route: no nearer, but a bath with two compartments).
    - *Not possible:* a bath for bedroom 1 here (it is on the east side); widening the projection gallery (the landing is west of the gallery line x 2.75, not on it).
  ],
)

// ====================================================================================== PAGE 3 · sections and headroom
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[Headroom · a section along the lower flight for each option · the slab #r2(slab) thick (soffit #lv(slab-soffit)), the trimmers 0.20 × #r2(trim-d) (soffit #lv(trim-soffit)), the finish #r2(fin) · over the full walking width of every tread]
#v(2pt)
#grid(columns: (auto, auto), gutter: 14pt, section(CUR), section(FLP))
#v(4pt)
#grid(columns: (1fr, 1fr), gutter: 12pt,
  ..opts.map(o => [
    #set text(6.4pt)
    #H[3 · #o.name: the lower flight, tread by tread]
    #table(columns: (auto, auto, auto, 1fr, auto, auto), inset: 1.8pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      [*tread*], [*y*], [*z*], [*what is above (full width)*], [*headroom*], [*≥ 2.10 / aim 2.20*],
      ..head-rows(o).map(r => ([#r.t.i], [#r2(r.t.ya)–#r2(r.t.yb)], [#lv(r.t.z)], [#r.s.what], [#r2(r.s.h)], [#if r.s.h >= 2.10 [#OK] else [#NO]#if r.s.h >= 2.20 [ · aim] else [ · *below the aim*]])).flatten())
    #text(6pt)[The upper flight, the half landing and the arrival are under the open well (the roof slab's soffit #lv(roof-soffit)): ≥ #r2(roof-soffit - 3.6) m. Minimum of this option: *#r2(head-min(o)) m* at tread #head-rows(o).sorted(key: r => r.s.h).first().t.i under the trimmer, across the whole #r2(wf) m width (the trimmer spans the half); B17#if o.start == "N" [′] over the inner 0.10 strip of treads 1–5: ≥ #r2(trim-soffit - 5 * st.r) m.]
  ])
)
#v(3pt)
#text(6.6pt)[*Verdict on the headroom:* identical in both options (*#r2(head-min(CUR)) m* at tread 6 under the trimmer, #r2(slab-soffit - 3 * st.r) m at tread 3 under the slab; ≥ 2.10 required, the 2.20 aim just met) because the flip mirrors the geometry: the trimmers sit in the same places relative to the treads. *The flip neither improves nor worsens the trimmers.* What would improve both: trimmers 0.20 × *0.30* (soffit +3.30 → *#r2(ff - 0.30 - 6 * st.r) m* at tread 6) if the engineer accepts a 0.30 depth for the 1.3–1.6 m spans, or the slab edge moved one tread (the opening 0.28 m longer, ≈ 0.35 m² more void, tread 6 under open sky → the minimum moves to tread 5: #r2(trim-soffit - 5 * st.r) m). Both options can take either. The walls' handrails run the full flights (0.08 off the walls); the central handrail on the 0.10 split.]

// ====================================================================================== PAGE 4 · routes and escape
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[Walking routes · measured along the walked lines through the doors · to the stair top, to the lift, from the family entrance · who gains, who loses · the escape routes]
#v(2pt)
#grid(columns: (1.15fr, 1fr), gutter: 12pt,
  [
    #set text(6.5pt)
    #H[6 · First floor: from each room's door to the stair top]
    #table(columns: (1.5fr, auto, auto, auto, 1.3fr), inset: 2pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      [*From*], [*current*], [*flipped*], [*Δ*], [*through*],
      ..rooms-ff.map(r => (r.at(0), [#r1(route-cur(r)) m], [#r1(route-flp(r)) m], text(fill: if route-flp(r) < route-cur(r) { green } else { red }, weight: "bold")[#if route-flp(r) < route-cur(r) [−] else [+]#r1(calc.abs(route-flp(r) - route-cur(r)))], text(6pt, r.at(3)))).flatten())
    #text(6pt, fill: gray)[Stair top: current on the landing room (#r2(top-cur.at(0)), #r2(top-cur.at(1))); flipped at the arrival strip's opening onto the gallery (#r2(top-flp.at(0)), #r2(top-flp.at(1))). The walked lengths add #r1(stair-walk) m on the stair itself in both (two flights + the half landing).]
    #v(2pt)
    #H[To the lift (its door x 2.25, y 0.9–1.9: the same in both options)]
    #table(columns: (1.5fr, auto, 2fr), inset: 2pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      [*From*], [*m*], [*note*],
      ..to-lift.map(((n, P)) => (n, [#r1(plen(P))], text(6pt)[via the gallery's north part])).flatten())
    #v(2pt)
    #H[Ground floor: the family entrance → the stair foot / the lift]
    - To the stair foot: *current #r1(plen(gf-entry-cur)) m* (along the riwaq, into the well from the side, across to the west flight) · *flipped #r1(plen(gf-entry-flp)) m* (straight into the start opening and onto the east flight): *−#r1(plen(gf-entry-cur) - plen(gf-entry-flp)) m*. To the lift: #r1(plen(gf-entry-lift)) m in both.
    #v(2pt)
    #H[Who gains, who loses]
    - *Gain:* the *children's study room* (−#r1(route-cur(rooms-ff.at(0)) - route-flp(rooms-ff.at(0))) m) and the *family living* (−#r1(route-cur(rooms-ff.at(1)) - route-flp(rooms-ff.at(1))) m): the rooms used every day by everyone; *bedroom 1* (−#r1(route-cur(rooms-ff.at(2)) - route-flp(rooms-ff.at(2))) m) and the *parents' suite* via the family link (−#r1(route-cur(rooms-ff.at(3)) - route-flp(rooms-ff.at(3))) m); and every trip from the *family entrance* (−#r1(plen(gf-entry-cur) - plen(gf-entry-flp)) m on the ground floor).
    - *Lose:* *bedrooms 2 and 3* (+#r1(route-flp(rooms-ff.at(5)) - route-cur(rooms-ff.at(5))) m each: the children's bedrooms), the *family bath* from the stair (+#r1(route-flp(rooms-ff.at(4)) - route-cur(rooms-ff.at(4))) m) and the *gym* (+#r1(route-flp(rooms-ff.at(7)) - route-cur(rooms-ff.at(7))) m). The lift's routes are unchanged, so a bedroom-2 / 3 child who uses the lift loses nothing.
    - *Net:* the daily traffic is the living / study room / suite side (several trips a day by each person) against the bedrooms (a few trips a day): the flip puts the stair where the house is lived in, 2–3 m from the lift and the entrance, and moves the bedrooms' walk from the quiet south end to the busier north end. The children's *bedrooms* lose 3.7 m; their *study room* gains 6.7 m.
  ],
  [
    #set text(6.5pt)
    #H[9 · Escape: every first-floor room to the outside (the family door), with the doors on the way]
    #table(columns: (1.4fr, auto, auto, 2fr), inset: 2pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      [*From*], [*current*], [*flipped*], [*doors on the way (both)*],
      ..rooms-ff.filter(r => not repr(r.at(0)).contains("Gym")).map(r => (r.at(0), [#r1(route-cur(r) + stair-walk + foot-to-door-cur) m], [#r1(route-flp(r) + stair-walk + foot-to-door-flp) m], text(6pt)[its door → the gallery → the stair (open well) → the lobby → the family entrance (1.0 leaf, thumb-turn)])).flatten())
    #text(6pt, fill: gray)[From the stair foot to the family door: current #r1(foot-to-door-cur) m (back north along the riwaq), flipped #r1(foot-to-door-flp) m (the foot is 3 m from the door). The stair itself #r1(stair-walk) m. The escape windows and the suite court's fresh-air role are unchanged (`studies/fire_escape.typ`).]
    - *Flipped:* the stair foot lands *beside the family entrance*: the shortest way out for everyone on the ground floor, and the lobby is the assembly space inside the door; the kitchen service door and the guest door stay the secondary exits.
    - *Fire-study notes affected by a flip:* `stair-top` (2.0, 7.6) → (2.0, 3.05) and `gf-from-stair` → (2.05, 3.05) → (3.5, 3.05) → (3.5, 0); the routes table; the smoke alarm "S · stair foot" (3.3, 6.0) → (3.3, 2.9); the extinguisher "E · stair" (2.9, 6.9) → beside the start; the plan "everyone out by the stair and the family door" unchanged; the first floor keeps one stair + the escape windows (home-level strategy).
    #v(2pt)
    #H[8 · Light along the routes and at the start / arrival]
    - *Ground floor, current:* the start faces the riwaq's courtyard glass (x 4.25, y 6.8–8.9), 1.5 m away: daylight at the foot of the stair; the lobby by the entrance is lit by the door only. *Flipped:* the start at the north end sits in the lobby, whose only daylight is the family entrance (a solid door today): the foot of the stair needs a *glazed panel or side light at the family entrance* (or a small north window in the lobby's north wall, x 4.0–4.2 is too narrow: the door itself) and good artificial light; the riwaq glass is 3.5 m away. *The well has no window in either option:* a *west window at the half landing* (sill ≈ +2.6, head +3.4, 1.0 wide, in the 0.785 m strip to the M line, obscured glass) lights the whole well and the store below is dark anyway: an option for both, more needed in the flip.
    - *First floor, current:* the landing room is 2 m from the gallery's W1 arched windows on the void: well lit. *Flipped:* the arrival opens to the gallery's north part beside the family living's opening (y 3.1–4.5), whose W2 arched windows face the courtyard: lit through the living; the gallery's north part itself has no window (as today). No window is lost in either option; the freed landing (F-a) can gain a west window.
    - *Artificial:* in both, a wall light on each flight's wall and a light over each landing; the flipped start shares the lobby's light (one switch by the entrance, one at the top).
  ],
)

// ====================================================================================== PAGE 5 · knock-on, pros / cons, recommendation
#pagebreak()
#text(12pt, weight: "bold", fill: accent)[Knock-on effects · pros and cons · recommendation · the decisions needed]
#v(2pt)
#grid(columns: (1fr, 1fr), gutter: 12pt,
  [
    #set text(6.5pt)
    #H[10 · What moves if the stair is flipped]
    - *Ground floor, the x 2.75 line:* today open to the riwaq over 4.4 m (y 2.4–6.8); flipped: the *start opening* #r2(clear.start-open-flp) m (y 2.3–#r2(FLP.first)), then the lower flight's *balustrade* (0.90, open) or a *wall* along the riwaq (y #r2(FLP.first)–#r2(FLP.land.at(0))), then the store's wall with its *door* (y 6.7–7.6). The riwaq's north part keeps its 1.30 m; the open view into the well moves north.
    - *The family lobby:* the stair start joins the lift notch and the entry cupboard in one 3.75 m length of the lobby: the house's "arrival knot" (entrance, lift, stair, coats) in one place, as in most villas; the congestion test passes. The cupboard (0.5 × 0.9) can stay or give way to the new 1.21 × 1.45 coat cupboard.
    - *The full-height store at the south end is lost;* the 1.65 m store moves south. *The utility room:* untouched (the store door may open into it instead of the riwaq).
    - *First floor, the gallery's north part:* it carries the arrival (as it carries the lift today); the railing on the well runs y #r2(FLP.first)–7.9; a *guard or a wall on y 7.9* (B12) closes the opening's south side; the *landing room is freed* (F-a / F-b).
    - *The family bath:* unchanged in F-a; in F-b its north wall y 9.2 is opened and the WC moves into a compartment by the shaft (the stack stays at x 1.5): a plumbing re-plan, no structure.
    - *The lift doors:* unchanged on both floors (x 2.25, y 0.9–1.9, sliding); the stair is now 0.1–0.5 m from the notch on both floors.
    - *The WC by the shaft (FF family bath):* moves in F-b only. *The GF family WC* (y 14.4–16.1) and the serving passage: untouched.
    - *Structure:* the trimmers mirrored (B16′ / B17′ / B18′), the slab bays of the well re-cut; B10 / B11 / B12 unchanged; the stair walls unchanged. *3D, DXF, presentation, fire study, ff_family / design_gf / structure studies:* all updated at the decision (a normal work round).
    - *No wall moves outside the well* except the x 2.75 infill and the y 7.9 line at the first floor.
    #v(2pt)
    #H[Pros and cons]
    #table(columns: (1fr, 1fr), inset: 2.4pt, stroke: 0.4pt + luma(170), fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
      [*Flipped: for*], [*Flipped: against*],
      [the stair where the house is lived in: study room −#r1(route-cur(rooms-ff.at(0)) - route-flp(rooms-ff.at(0))) m, living −#r1(route-cur(rooms-ff.at(1)) - route-flp(rooms-ff.at(1))) m, suite −#r1(route-cur(rooms-ff.at(3)) - route-flp(rooms-ff.at(3))) m, entrance → foot −#r1(plen(gf-entry-cur) - plen(gf-entry-flp)) m], [bedrooms 2 / 3 +#r1(route-flp(rooms-ff.at(5)) - route-cur(rooms-ff.at(5))) m, the family bath +#r1(route-flp(rooms-ff.at(4)) - route-cur(rooms-ff.at(4))) m, the gym +#r1(route-flp(rooms-ff.at(7)) - route-cur(rooms-ff.at(7))) m from the stair],
      [the entrance, the lift, the stair and the coats in one knot; the escape to the family door −#r1(foot-to-door-cur - foot-to-door-flp) m for everyone], [the busy knot: three people at once at the lobby's north end (passes the test, but it is the house's one pinch point)],
      [a proper foot: #r2(clear.start-open-flp) m in front of the first riser, straight in (today 0.55 m, sideways)], [the start loses the courtyard daylight (the riwaq glass is 3.5 m away): a glazed entrance panel and lights needed],
      [#r2(land-net) m² freed upstairs: a two-compartment family bath (F-b) or a linen nook (F-a); a 1.21 × 1.45 coat cupboard downstairs], [the tall store behind the stair is lost (the coat cupboard replaces it); the lower flight shows along the riwaq (balustrade) unless walled],
      [the same headroom, the same trimmers mirrored, no structural penalty, no wall moves outside the well], [a re-draw of five studies, the 3D, the DXFs, the presentation (a work round), and the bedrooms' arrival is no longer private],
    )
  ],
  [
    #set text(6.5pt)
    #H[Recommendation: FLIP, with conditions]
    - *Flip it (option B: the lower flight on the east, straight off the lobby).* The numbers favour it: the rooms everybody uses many times a day (the living, the study room, the suite, the entrance) come 5–7 m nearer the stair; the bedrooms lose 3.7 m once or twice a day; the foot of the stair becomes a real foot (1.45 m, in line) instead of a sideways 0.55 m; the escape to the family door shortens for everyone; nothing structural is gained or lost; and the flip frees #r2(land-net) m² upstairs and gives a coat cupboard at the door.
    - *Conditions:* (1) a glazed panel / side light in the family entrance (or a lobby window) and a *west window at the half landing* so the start and the well are not dark; (2) the *balustrade* along the lower flight on the riwaq side, 0.90 m, black steel in the design language (not a wall), so the riwaq keeps its width of view; (3) the freed landing as *F-b, the two-compartment family bath* (the WC by the shaft, a second basin), or F-a if the owner prefers a nook; (4) the half-landing store's door onto the riwaq (household) — or into the utility room (service), the owner's choice; (5) the headroom improvement, open to both: ask the engineer for *0.30 trimmers* (2.32 m at tread 6) before the slab is detailed.
    - *If the owner keeps the current stair:* add the 0.30-trimmer question all the same, and widen the current foot (the full-height store shortened to 0.5 m, the strip 0.85 m).
    #v(2pt)
    #H[Decisions needed from the owner]
    + *Current or flipped?* (flipped recommended)
    + If flipped: *B* (lower flight east, the coat cupboard) or *A* (mirror only)? (B recommended)
    + The freed landing: *F-b* bigger family bath with a WC compartment (recommended) or *F-a* gallery nook + linen cupboard?
    + The lower flight's riwaq side: *balustrade* (recommended) or wall?
    + The half-landing store's door: *riwaq* (recommended) or utility room?
    + The west window at the half landing: yes (recommended) / no.
    + The family entrance: a glazed panel / side light (recommended) or lights only.
    + The entry cupboard (0.5 × 0.9): keep beside the new coat cupboard, or remove (the lobby gains 0.5 × 0.9).
    #v(2pt)
    #H[What this study does not do]
    - It changes nothing in the room CSVs, the design files, the structure, the 3D or the fire study; it claims no structural verification (the trimmers' torsion and bearings are the engineer's, as today); the lift's shaft is still a placeholder; every size is assumed.
    - *After the decision* (a work round): `data/rooms_gf.csv` / `rooms_ff.csv` (the landing room, the stores, the cupboard), `design_gf.typ` (the x 2.75 line, the stores, the safety marks), `studies/ff_family.typ` (the stair top, the routes, the bath), `studies/structure.typ` (st, the trimmers, the slab bays), `studies/fire_escape.typ`, `3d/build_3d.py` (reads st: the direction flag), the DXFs and the presentation.
    #v(3pt)
    #text(8pt)[#if all-ok [*Study checks passed* (#checks.len())] else [*STUDY CHECKS FAILED:* #checks.filter(c => not c.at(1)).map(c => c.at(0)).join([; ])]]
    #v(2pt)
    #text(6pt, fill: gray)[Checks: #checks.map(c => c.at(0)).join([ · ])]
  ],
)

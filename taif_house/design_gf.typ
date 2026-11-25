// design_gf.typ · Taif / Palm House · GROUND FLOOR V10.0 (the owner's ground-floor review of 10 Nov 2026 applied on `work`) · the file you compile for the ground floor
// Compact courtyard house: courtyard at the centre, west service band, east service block, the malqaf at the courtyard's north-west corner (V10.0, L5); step 7 (idea-ne-corner, draft): the courtyard open on its west side, the FF cantilevered west; GF step 6 (idea-ne-corner, draft): the malqaf chamber and a liwan on the courtyard's EAST side.
// Three columns on x 5.8 carry the edge beam of the first floor's 1.55 m west projection over the courtyard and the living (a colonnade); V6.4: enclosure option A.
// Reads data/rooms_gf.csv (rooms) and base.typ (site). Room studies: studies/guest_wing.typ (west wash block), studies/east_wing.typ (east service block).
// Full description: docs/PROJECT_V10.md · DXF: tools/make_dxf.py reads this file
#import "base.typ": *
#show: setup

// ---------- Place the whole building ----------
#let shift = (0.91, 7.3734)   // 17 Nov 2026 (owner): the whole house 1.3 m further south along the M line (B1 7.29 m from M1) with the north-east corner as ONE step (studies/step_corner.typ option 6); 8 Nov 2026 (owner, his car tested on site: a full forward turn into the north strip needs it): B1 exactly 6.00 m from M1 (0.785 east of the M line, 5.948 south: a further 0.5104 m south); V9.0 6 Nov 2026: 5.563 (B1 5.49);   // 6 Nov 2026 (owner): a further 0.50 m south, B1 5.49 m from M1 (studies/shift_south.typ, adopted); before: 5.063 = site-test option Z4: outer west face 0.785 m from the M line; 4 Nov 2026 (owner, on site): 1.238 m further south than V8.3 (3.825) so that the north-west outer corner B1 is exactly 5.00 m from peg M1 (the gate's east post); to be confirmed by the official survey (studies/setout.typ)
#let rot = 0deg               // square to the M line

// ---------- Rows from the CSV (# at the start of a name switches the row off) ----------
// optional "pts" column (corner points of a room that is not a rectangle) moves with the room
#let map-pts(r, f) = {
  let r = r
  let P = pts-of(r)
  if P.len() >= 3 { r.insert("pts", P.map(f).map(p => str(p.at(0)) + " " + str(p.at(1))).join(";")) }
  r
}
#let all-rows = csv("data/rooms_gf.csv", row-type: dictionary).filter(r => not r.name.starts-with("#")).map(r => {
  let r = r
  r.insert("x", str(float(r.x) + shift.at(0)))
  r.insert("y", str(float(r.y) + shift.at(1)))
  map-pts(r, p => addv(p, 1, shift))
})
#let crow = all-rows.find(r => r.name == "Courtyard")
#assert(crow != none, message: "ERROR: no row named Courtyard in data/rooms_gf.csv.")
#let rooms = all-rows.filter(r => r.name != "Courtyard")

// ---------- Rotation (round the courtyard centre) ----------
#let pivot = (float(crow.x), float(crow.y))
#let rotv(v) = (v.at(0) * calc.cos(rot) - v.at(1) * calc.sin(rot), v.at(0) * calc.sin(rot) + v.at(1) * calc.cos(rot))
#let rotp(p) = addv(pivot, 1, rotv((p.at(0) - pivot.at(0), p.at(1) - pivot.at(1))))
#let place(p) = rotp(addv(p, 1, shift))   // CSV coordinates → drawing
#let rotrow(r) = {
  let r = map-pts(r, rotp)
  let c = rotp((float(r.x), float(r.y)))
  r.insert("x", str(c.at(0)))
  r.insert("y", str(c.at(1)))
  r.insert("angle", str(float(r.at("angle", default: "0")) + rot.deg()))
  r
}

// ---------- Building outline (wall centre lines, CSV coordinates) ----------
// 8 Nov 2026 (owner): after the house moved 0.5104 m further south the cut wall moved outwards a further 0.24 m, parallel (B2 10.188 → 10.461, B3 y 5.749 → 5.245; 0.42 m from the wall as built again, the same 2 cm cushion at the 2.30 field reading). 6 Nov 2026 (owner, field 2.30 m to the wall at the tightest point): the cut wall moved outwards 0.12 m, parallel (B2 10.051 → 10.188, B3 y 6.0 → 5.749; ≈ 0.42 m from the wall as built). pentagon: north-east corner cut parallel to the lane from (10.461, 0) to (13.311, 5.245), then the east wall straight south; south wall at y 24.0
// 17 Nov 2026 (owner, studies/step_corner.typ option 6): the slanted cut wall replaced by ONE orthogonal step: the north wall ends at x 11.275, the step's wall on y 3.2, the east wall from y 3.2; with the house 1.3 m further south the margins are 1.06 m (deed line) and 0.44 m (2.0 m from the wall as built), both better than the slant's.
// the FIRST floor's outline (unchanged: design_ff.typ, sections.typ, tools/schedule.py, the 3D and the DXFs read this line: keep it bare)
// GF step 7 (draft, 25 Nov 2026): the FIRST floor's outline with its 1.55 m west CANTILEVER over the driveway from y 9.2 to the south facade (the ground floor stays on x 0: outline-csv-gf-floor below)
#let outline-csv-gf = ((0, 0), (11.275, 0), (11.275, 3.2), (13.311, 3.2), (13.311, 24.0), (-1.55, 24.0), (-1.55, 9.2), (0, 9.2))
// 23 Nov 2026 · IDEA (branch idea-ne-corner): the north-east corner x 8.95–13.311 × y 0–6.5 (with the step) is OUTSIDE the ground floor: open ground under the first floor, which stands
// on the existing corner columns (the slab's underside insulated). The ground-floor outline runs along the women's majlis east wall (x 8.95, y 0–6.5) and the kitchen's north wall (y 6.5).
#let outline-csv-gf-floor = ((0, 0), (11.275, 0), (11.275, 6.5), (13.311, 6.5), (13.311, 24.0), (0, 24.0))   // GF step 3: the lobby and the maid room run to the north facade (x 8.95–11.275, under the first floor's north wall); ONE re-entrant step at (11.275, 6.5)
#let outline-gf = outline-csv-gf-floor.map(place)   // the GROUND floor as drawn and checked here

// ---------- Building against the envelope: outer wall face = centre line + 0.125 m (250 mm outer walls) ----------
#let outer-wall = 0.125
#assert(sample(outline-gf, step: 0.1).all(p => inside(p, env)), message: "ERROR: the building centre line leaves the envelope.")
#let env-gap = calc.min(..sample(outline-gf, step: 0.1).map(p => calc.min(..edges(env).filter(e => not (calc.abs(e.at(0).at(0)) < 0.01 and calc.abs(e.at(1).at(0)) < 0.01)).map(e => seg-dist(p, ..e))))) - outer-wall   // V9.0: to the setback lines only (the M line has no setback; the west face's 0.785 m is m-gap)
#assert(env-gap >= 0, message: "ERROR: the outer wall face crosses the envelope (setback line).")
#let m-gap = calc.min(..outline-gf.map(p => p.at(0))) - outer-wall   // outer west face to the M line

// ---------- Courtyard ----------
#let cw = float(crow.w)
#let cd = float(crow.d)
#let cx0 = float(crow.x) - cw / 2
#let cy0 = float(crow.y) - cd / 2
#let court = (if crow.at("pts", default: "").trim() != "" { pts-of(crow) } else { ((cx0, cy0), (cx0 + cw, cy0), (cx0 + cw, cy0 + cd), (cx0, cy0 + cd)) }).map(rotp)   // GF step 6: the full rectangle again (the malqaf chamber moved east, into the open space)

// ---------- Entry arrows (CSV coordinates): (point on the wall, outward direction, label) ----------
#let entries = (
  ((3.5, 0.0), (0.0, -1.0), [Family entry]),      // family lobby, north wall
  ((0.0, 22.2), (-1.0, 0.0), [Guest entry]),      // foyer, double door at the north end of its west wall
)

// ---------- Outlines drawn INSIDE a host room (not counted as area, no overlap check): (x0, y0, x1, y1, label), CSV ----------
#let inner-boxes = (
  (0.0, 6.55, 2.75, 7.9, [utility · low part under the half landing (1.65 m): batteries + inverter]),   // 10 Nov 2026 (owner): the store and the utility room are ONE room; the wall y 7.9 between them opened (the engineer: the half landing's support)
  (0.125, 2.3, 1.3875, 3.75, [coat cupboard · full height]),   // the west half of the start strip: the family's coat / shoe cupboard by the entrance (sliding doors onto the strip)
  // GF step 7: col 1 at (5.8, 6.5) removed with the strip over the courtyard (the courtyard open from the riwaq line); two columns under the first floor's west projection edge beam (x 5.8, V6.4), each in a wall / glass line:
  (5.65, 12.85, 5.95, 13.15, [col 2]),           // the women's majlis south wall (y 6.5), the courtyard / living glass (y 13.0), the living's south wall (y 19.25)
  (5.65, 19.1, 5.95, 19.4, [col 3]),
  (4.35, 14.5, 5.05, 14.75, [TV niche pier]),       // V6.3: the living's west wall is solid; an arched TV niche 4.40 wide × 0.70 deep between this pier and the south wall, head ≈ 3.0–3.2 m
  (4.35, 14.75, 5.05, 19.15, [TV niche 4.40 × 0.70]),
  (5.925, 7.8, 7.25, 12.9, [free seating 1.33 × 5.1 · level · no TV]),   // GF step 6: the free rectangle between the column line and the liwan
  (7.25, 8.0, 8.85, 12.9, [LIWAN · bench +0.40 · 1.6 × 4.9 · first-floor suite extends over it (next step)]),   // GF step 6 (draft): the raised liwan along the courtyard's east wall, south of the malqaf outlet   // 11 Nov 2026 (owner, studies/courtyard_layout.typ): a 3-seat sofa facing north, an armchair at the kitchen wall, a low table; the open part
  (4.35, 10.3, 5.925, 12.3, [seating · covered pocket · 2-seat sofa]),   // 11 Nov 2026 (owner): the zone extended under the first-floor projection, south of the 1.1 m door path (y 9.2–10.3); NO TV
  (7.4, 6.75, 8.4, 7.75, [olive · fixed pot Ø 1.0 · in the jet]),   // GF step 6: in front of the new outlet (y 6.5), between it and the liwan   // 11 Nov 2026 (owner): the olive BETWEEN the outlet and the water, its trunk on the jet's axis; the crown +2.0…+4.0; ≈ 1.2 t mid-slab (the engineer)
  (7.65, 2.3, 8.85, 4.2, [alcove: storage (later)]),   // GF step 11: the maid room's open alcove between her bath and the chamber
  (7.55, 6.35, 9.25, 6.65, [chamber's courtyard wall 0.30 · the outlet in it]),   // GF step 10: 0.30 east with the majlis wall   // GF step 6: the chamber's south (courtyard) wall RC 0.30 like L5's core face   // 10 Nov 2026 (owner): the malqaf core's courtyard face one straight line flush with the columns and the edge beam (x 5.80 ± 0.15): the chamber reads as the arcade's first bay filled
  (4.6, 6.6, 6.7, 7.55, [water trough under the women's majlis window · 2.1 × 0.95 (GF step 6; H2 to re-check)]),   // GF step 6: the trough on the courtyard's north wall, west of the olive and the outlet (the sink window is gone)   // 11 Nov 2026 (owner): the trough 2.1 × 0.95 on the kitchen wall in front of the sink window (rim +0.80, the spout under the window, a 0.40 fall, the skimmer at the south end)
)
#let inner-marks = inner-boxes.map(((x0, y0, x1, y1, l)) => {
  let P = ((x0, y0), (x1, y0), (x1, y1), (x0, y1)).map(place)
  (((P.at(0), P.at(1)), l), ((P.at(1), P.at(2)), []), ((P.at(2), P.at(3)), []), ((P.at(3), P.at(0)), []))
}).fold((), (acc, m) => acc + m)

// ceiling-height change inside the living room (one open room, no wall), and the first-floor edges above this floor
#let level-marks = (((place((8.95, 0)), place((11.275, 0))), [first floor above, on columns; the slab's underside insulated]), ((place((11.275, 0)), place((11.275, 3.2))), []), ((place((11.275, 3.2)), place((13.311, 3.2))), []), ((place((13.311, 3.2)), place((13.311, 6.5))), []),   // idea-ne-corner: the first-floor outline over the open ground
  ((place((8.95, 13.0)), place((8.95, 19.25))), [ceiling height change]), ((place((5.8, 13.0)), place((5.8, 19.25))), [FF projection edge (beam + window W1) above, over the living only (step 7)]), ((place((-1.55, 9.2)), place((-1.55, 24.0))), [first floor cantilevers 1.55 m over the driveway (step 7)]), ((place((0, 9.2)), place((-1.55, 9.2))), []))

// ---------- Doors, openings, windows and special walls (CSV): ((x1, y1), (x2, y2), label) · the // comment names each line ----------
// labels left empty at this scale; output/guest_wing.pdf and output/east_wing.pdf carry the full labels
// west band and west wash block (studies/guest_wing.typ: local y + 10.4 = CSV y)
#let west-lines = (
  ((2.25, 0.9), (2.25, 1.9), []),            // lift door (sliding landing door; the lift is installed at construction, V6.3)
  ((0.1, 7.9), (2.65, 7.9), [wall opened: one utility room]),   // 10 Nov 2026 (owner): the store's door onto the riwaq removed; the store under the half landing joins the utility room (ONE door, from the riwaq at y 8.2–9.0)
  ((2.75, 8.2), (2.75, 9.0), [utility door]),
  ((0.0, 9.2), (0.0, 10.4), []), ((0.0, 10.4), (1.5, 10.4), []), ((1.5, 10.4), (1.5, 9.2), []), ((1.5, 9.2), (0.0, 9.2), []),   // the west service shaft (x 0–1.5, y 9.2–10.4, unchanged): its own sealed walls, the maintenance door on its east face
  ((1.5, 9.4), (1.5, 10.2), [shaft door · 0.9 m clear in front]),
  // GF step 6: the L5 chamber door (y 8.667) and the outlet on x 5.8 removed with the chamber: the corner is courtyard again
  ((4.4, 6.5), (5.55, 6.5), []), ((6.05, 6.5), (7.4, 6.5), []),   // GF step 10: the majlis 0.30 wider, the east pane to x 7.4 ·   // GF step 6: the women's majlis's courtyard window full length again, in two panes either side of column 1   // H2 (10 Nov 2026): the breeze outlet 1.4 × 1.0 centred in the first arcade bay, raised, the louvres fixed 15° SE (11 Nov 2026: outlet → olive → water) at the trough: a low door (head 1.55) onto the riwaq (stair flip, V8.1 work)
  ((0.0, 6.7), (0.0, 7.6), []),              // the half landing's small west window (sill +2.60, head +3.30, 0.9 wide, obscured glass, a deep shaded reveal): lights the whole well
  ((2.4, 0.0), (2.9, 0.0), []),              // the family entrance's glazed side light (obscured glass, sill +0.30, head +2.10) west of the door: daylight at the stair foot
  ((2.75, 10.6), (2.75, 12.7), []),           // hospitality kitchen, open to the riwaq
  ((2.75, 13.05), (2.75, 14.4), [open 1.35 to the riwaq]),   // 10 Nov 2026 (owner): the powder room has NO outer door: a 1.35 m open opening onto the riwaq (the old 1.00 door); 10 Nov 2026 (owner): the WC in its own compartment with a hand basin, the two basins + mirror in the open zone in front of the entrance; no shower
  ((0.0, 14.55), (2.75, 14.55), []),   // the WC compartment's 100 mm partitions (x 1.3–2.75, y 14.55–16.1: ≈ 1.3 × 1.4 clear)
  ((1.6, 14.55), (2.3, 14.55), [WC door 0.70]),
  ((0.0, 12.9), (2.75, 12.9), []),           // hospitality kitchen / powder room wall, full height
  ((2.75, 16.25), (2.75, 17.15), []),         // serving door 1 (0.90), to the riwaq, lockable from the riwaq side; opposite: the living's solid west wall (the TV wall, V6.3)
  ((0.1, 17.5), (1.15, 17.5), [serving doors 1 + 2]),   // serving door 2 (1.05, guest side), lockable from inside the passage
  ((0.1, 16.1), (2.6, 16.1), []),            // the powder room's south service wall (the WC's frame, bath 3's stack)
  ((0.0, 17.5), (2.75, 17.5), []),           // family / guest line
  ((1.35, 19.4), (2.25, 19.4), [guest WC door 0.90 from the basins room]),   // 11 Nov 2026 (owner): the door back on the WC's south wall, from the basins room (as before the redraw of 10 Nov); hinged at the west jamb, opens in, its swing clear of the WC (x 2.2–2.65)
  ((1.25, 19.5), (1.25, 21.3), [basins opening 1.8]),   // 10 Nov 2026 (owner, redrawn): the basins room open to the passage through a wide opening
  ((0.0, 21.5), (0.0, 22.9), []),            // guest entrance, double door 1.40 m (two leaves), opens in, north end of the foyer's west wall
  ((2.75, 22.15), (2.75, 23.95), []),        // open passage into the men's majlis, 1.80 m, no door, south end of the foyer's east wall
  ((4.25, 13.1), (4.25, 14.5), []),          // living room: arched entrance from the riwaq, 1.40 m, no door (head ≈ 2.60); V6.3: the rest of the west wall (y 14.5–19.25) is solid and full height, the TV wall
)
// east service block (studies/east_wing.typ: local + (8.95, 0) = CSV)
#let east-lines = (
  // 23 Nov 2026 · IDEA (branch idea-ne-corner): the maid room (G06), the maid bath (G05) and the laundry (G07) removed, and the north-east corner taken OUT of the ground floor
  // (open ground under the first floor on the corner columns); the kitchen's north wall and the women's majlis east wall are outside walls now.
  // GF step 1 (23 Nov 2026): a DISTRIBUTION LOBBY x 8.95–10.55 × y 4.9–8.3 (the kitchen's north-west part + a 1.6 × 1.6 piece of the corner) between the courtyard, the laundry, the kitchen and the back garden;
  // GF step 3 (24 Nov 2026): the LOBBY x 8.95–11.275 widened and run to the north facade, the MAID ROOM in its north end (y 0–3.35, her escape casement on the facade, her door into the lobby);
  // the strip from the majlis as narrow as possible (x 7.25–8.95, 1.5 m clear) the full depth: the MAID BATH at its north end (y 0–1.9, from her room only), the LAUNDRY in the rest down to the
  // courtyard wall (an exhaust fan, the machines on its east wall, the majlis wall acoustic); the majlis a clean rectangle x 4.25–7.25; the kitchen's north-east part back
  // GF step 8 (25 Nov 2026, draft): the open space divided: a SMALL ENTRY x 8.95–10.55 × y 5.5–8.3 at the courtyard door, a CORRIDOR y 4.3–5.5 north of it to the only outside door (x 11.275),
  // the MAID ROOM x 7.25–9.85 × y 0–4.3 with her BATH x 9.85–11.275 × y 0–1.9 (from her room), the LAUNDRY x 9.85–11.275 × y 1.9–4.3, a cupboard x 10.55–11.275 × y 5.5–6.5; the kitchen an L with the strip x 10.55–13.311 × y 6.5–8.3
  // GF step 9 (25 Nov 2026, draft): the LAUNDRY south of the kitchen in the dining's north-east corner (x 10.55–13.311 × y 13–15.5, door from the kitchen only, east window, acoustic walls to the dining);
  // the maid area cleaned: her BATH x 9.85–11.275 × y 0–2.8, a linen STORE x 9.85–11.275 × y 2.8–4.3 off the corridor; the entry compact (y 5.5–7.9); the kitchen takes x 8.95–10.55 × y 7.9–8.3 and the pantry niche x 10.55–11.275 × y 5.5–6.5
  // GF step 10 (25 Nov 2026, draft): the pantry niche x 10.55–11.275 × y 5.5–6.5 joins the ENTRY and the only outside door moves onto its east wall (x 11.275, y 5.5–6.4); the kitchen's north wall straight on y 6.5;
  // the store joins the MAID BATH, now on the majlis wall (x 7.55–8.95 × y 0–4.3, from her room only), the MAID ROOM east of it 2.10 clear (x 8.95–11.275); the MAJLIS +0.30 (x 4.25–7.55), the CHAMBER with it (x 7.55–9.25, lengthwise);
  // the KITCHEN DOOR on the kitchen's north wall y 7.9; the LAUNDRY half in the kitchen, half in the dining (x 10.55–13.311 × y 11.75–14.25), its door from the kitchen's arm
  ((8.95, 6.8), (8.95, 7.7), []),             // small entry ← COURTYARD door 0.90 on the courtyard's east wall (GF step 9: 0.1 north, the entry's south wall on y 7.9)
  ((9.25, 5.5), (11.275, 5.5), [open]),       // GF step 8/10: the entry opens north into the corridor (no door)
  ((9.7, 4.3), (10.5, 4.3), []),              // GF step 10: the maid room's door 0.80 from the corridor (the room now x 8.95–11.275)
  // GF step 10: the linen store removed (it joins the maid bath)
  ((8.95, 1.1), (8.95, 1.8), []),             // GF step 10: the maid bath's door 0.70 from her room only (the bath on the majlis wall; GF step 11: the bath y 0–2.2 only)
  ((8.95, 2.2), (8.95, 4.3), [open]),         // GF step 11: the rest of the strip (x 7.55–8.95 × y 2.2–4.3) an open ALCOVE of the maid room, no door
  ((10.55, 11.95), (10.55, 12.75), []),       // GF step 10: the laundry's door 0.80 from the kitchen's arm (its only door)
  ((13.311, 12.5), (13.311, 13.5), []),       // GF step 10: the laundry's window on the east outside wall, centred on y 13
  // GF step 5 (24 Nov 2026): the maid bath, the laundry, the maid room and the lobby ONE OPEN SPACE with no inner partitions (to be planned later): the three inner doors (the maid room's,
  // the laundry's, the bath's) removed; the boundary kept exactly: the outside walls with their windows, the majlis wall x 7.25 (no door), the courtyard wall, the kitchen's north wall y 8.3
  ((9.55, 7.9), (10.45, 7.9), []),            // GF step 10: entry → KITCHEN door 0.90 on the kitchen's north wall y 7.9 (option a; was on x 10.55 opposite the courtyard door) (the kitchen's east service door and the closed door on y 6.5 are removed)
  // GF step 4 (24 Nov 2026): the lobby / kitchen wall y 8.3 runs to the east wall: the kitchen a rectangle x 8.95–13.311 × y 8.3–13, the lobby an L reaching the east wall with a window there
  ((11.275, 5.5), (11.275, 6.4), []),         // GF step 10: entry → BACK GARDEN on x 11.275 (the old niche's east wall) under the first floor · GF step 8: from the corridor (the y 6.5 door removed) · was: lobby → BACK GARDEN: the ONLY outside door of the house to the back garden (0.90), moved to the lobby's north wall y 6.5 in its east arm (GF step 4; was on x 11.275)
  ((13.311, 7.0), (13.311, 7.9), []),         // the kitchen strip's east window (GF step 8; was the lobby's, GF step 4)
  ((9.6, 0), (10.74, 0), []),                 // GF step 10: the maid room's escape casement (the room east) on the north facade, 1.14 × 1.00, sill +1.10, obscured below +1.60, no screen
  ((7.95, 0), (8.55, 0), []),                 // GF step 10: the maid bath's small window (the bath west) on the north facade, obscured, sill +1.5
  // the laundry: no window (an exhaust fan); the kitchen's north-east part back where the step-2 laundry was 11 Nov 2026 (owner, the straight-walls rule): the kitchen's north wall ON the structural line y 6.5, one line with the women's majlis wall (was y 7.0, V6.4)
  // (idea-ne-corner) laundry ↔ maid room 0.90: removed with the rooms (layout D; 11 Nov 2026: 0.35 m east, in line with the kitchen entrance, the table's end clear; her only door, not from the kitchen)
  // (idea-ne-corner) maid room ↔ maid bath 0.70: removed with the rooms on the bath's west wall (17 Nov 2026, the step: the bath x 11.275–13.311 × y 3.2–4.7 east of the room; its door from her room only)
  // (idea-ne-corner) the laundry's east window 0.9: removed with the room onto the east yard (insect screen; the extract fan above it); 11 Nov 2026: the straight east wall now 1.255 m
  ((9.4, 13.0), (10.5, 13.0), []),            // kitchen ↔ dining
  // (GF step 1) the kitchen's east service door 0.90: removed (the lobby's garden door is the only door to the back garden)
  // GF step 6: the kitchen's sink window on x 8.95 removed (the liwan's back wall; the sink stays on the blind wall, the kitchen keeps its east window)
  ((9.25, 5.6), (9.25, 6.3), []),             // GF step 10: the chamber 0.30 east · GF step 8: the malqaf chamber's maintenance door 0.70 at the south end of its east wall, from the small entry (its north wall and the rest of its east wall solid)
  ((7.7, 6.5), (9.1, 6.5), [outlet +0.60…+1.60]),   // GF step 6: the breeze outlet 1.4 × 1.0 in the chamber's courtyard wall, raised louvres as L5, facing south over the olive onto the liwan
  ((13.311, 8.7), (13.311, 10.1), []),        // kitchen window, east
  // (idea-ne-corner) the maid room's escape casement on the step: removed with the room (17 Nov 2026): one casement 1.14 × 1.00, sill +1.10, obscured below +1.60, no screen (fire safety, 1 Nov 2026)
  // (idea-ne-corner) the maid bath's window on the step: removed with the room (17 Nov 2026), obscured, sill +1.5, above the WC
)
#let door-marks = (west-lines + east-lines).map(((a, b, l)) => ((place(a), place(b)), l))
// fire safety (owner, 1 Nov 2026; studies/fire_escape.typ): interconnected mains smoke alarms (S), the kitchen heat alarm (H), one CO alarm (CO), the gas detector (G), extinguishers (E), the fire blanket (B): drawn as short marks
#let safety = (((3.4, 3.0), [S · stair foot]), ((6.5, 16.1), [S · void ceiling]), ((11.0, 16.1), [S · dining]), ((11.0, 10.0), [H · kitchen]), ((9.9, 11.5), [CO]), ((13.0, 10.7), [G · hob]), ((12.8, 8.5), [E · kitchen]), ((12.6, 11.3), [B · blanket]), ((2.95, 4.3), [E · stair]))
#let safety-marks = safety.map(((p, l)) => ((place(p), place((p.at(0) + 0.3, p.at(1)))), l))

// ---------- The malqaf (V10.0, owner: L5, studies/malqaf_L5.typ): the foot chamber at the courtyard's NORTH-WEST corner, inside the covered strip under the first-floor projection, against the women's majlis's wall, on the wall centre lines (x 4.25–5.80 on axes, 11 Nov 2026: the west wall on the riwaq's straight line, the east wall 0.30 on the column line; y 6.4–8.767; RC 0.20); the shaft above it (y 6.5–7.5) and the head on the roof; drawn blue with the air list ----------
#let tower-csv = ((7.55, 4.3), (9.25, 4.3), (9.25, 6.5), (7.55, 6.5))   // GF step 10: 0.30 east with the majlis wall (lengthwise kept)   // read by 3d/build_3d.py and tools/make_dxf.py; 11 Nov 2026 (owner): the west wall ON the riwaq's line x 4.25 (the 0.15 jog removed), 1.55 wide like the projection
#let tower-pts = tower-csv.map(place)
#let tower-marks = (((tower-pts.at(0), tower-pts.at(1)), [malqaf chamber · GF step 6: at its new place; FF and roof to follow]),)   // GF step 6: the chamber x 7.25–8.95 × y 4.3–6.5 inside the open space, against the courtyard's north wall at its east end
// 10 Nov 2026 (owner): the west service shaft drawn as a void with a black outline (x 0–1.5, y 9.2–10.4; the utility room's polygon wraps round it)
#let shaft-csv = ((0, 9.2), (1.5, 9.2), (1.5, 10.4), (0, 10.4))
#let shaft-pts = shaft-csv.map(place)
// 3 Nov 2026 (owner): the outdoor kitchen: the counter and sink against the house's east wall NEXT TO the kitchen service door (a few steps from it, under the kitchen
// window; a canopy over it optional), the grill and tannour a little apart in the yard's south part (≥ 3 m from every door, window and the hood outlet, ≈ 12 m from the malqaf's
// filtered inlet (V10.0), downwind of the house in the north-west wind); the yard re-planned: the screen 1.8 m east of the counter's working strip, the gas cabinet on its outer face at the
// north end (≥ 3 m from the grill), the bins north of the service door away from the food. No gate on the lane. Outlines only (CSV)
#let site-boxes = (
  (13.45, 8.3, 14.05, 10.1, [outdoor counter + sink, by the service door (canopy optional)]),   // 3 Nov 2026 (owner): next to the kitchen service door, a few steps from it
  (16.5, 12.6, 17.6, 13.8, [grill + tannour (≥ 3 m from every opening, downwind)]),
  (15.2, 7.6, 15.3, 13.0, [yard screen 1.8 m]),
  (13.7, 5.3, 14.5, 6.1, [bins]),
  (15.35, 7.8, 15.85, 8.8, [LPG cabinet (on the screen's outer face)]),
)
#let site-marks = site-boxes.map(((x0, y0, x1, y1, l)) => {
  let P = ((x0, y0), (x1, y0), (x1, y1), (x0, y1)).map(place)
  (((P.at(0), P.at(1)), l), ((P.at(1), P.at(2)), []), ((P.at(2), P.at(3)), []), ((P.at(3), P.at(0)), []))
}).fold((), (acc, m) => acc + m)

#let arrows = entries.map(((p, d, l)) => {
  let b = place(p)
  (addv(b, 2.6, rotv(d)), b, l)
})

#render(
  title: [Ground floor V10.0 · pentagon on site option Z4 · the owner's review of 10 Nov 2026],
  subtitle: [Taif / Palm House V10.0 · base.typ + design_gf.typ + data/rooms_gf.csv · room studies in studies/ · full description docs/PROJECT_V10.md],
  court: court,
  rooms: rooms.map(rotrow),
  extras: (("shaft", shaft-pts),),
  air: (("Air tower", tower-pts),),
  arrows: arrows,
  marks: inner-marks + level-marks + door-marks + tower-marks + safety-marks + site-marks,
  limit: outline-gf,
  note: [*V11-idea · step 11 (draft, 25 Nov 2026): fixes* — the sheet-02 leftovers removed (the old majlis seating across the strip); the maid bath 1.2 × 2.0 clear at the north end of the strip (WC, basin, a shower mixer over a floor drain, no tray), from her room only; the rest of the strip (1.2 × 1.9 clear) an open alcove of her room, storage later. *Step 10 (draft, 25 Nov 2026):* the dead niche joins the entry and the only outside door is on its east wall (x 11.275, y 5.5–6.4), the kitchen's north wall straight on y 6.5; the store joins the maid bath (now on the majlis wall, 1.2 × 4.075 clear, from her room only), the maid room east of it 2.10 clear; the women's majlis 3.1 clear wide (+0.30), the chamber lengthwise with it (x 7.55–9.25); the kitchen door on the kitchen's north wall (y 7.9); the laundry half in the kitchen, half in the dining (x 10.55–13.311 × y 11.75–14.25, ≈ 5.8 m² clear, door from the kitchen's arm, east window, acoustic walls); the dining a 4.14 × 4.8 m rectangle plus its arm. *Step 9 (draft, 25 Nov 2026): the laundry south of the kitchen* (x 10.55–13.311 × y 13–15.5 in the dining's north-east corner, ≈ 5.8 m² clear, door from the kitchen only, east window, acoustic walls; the dining keeps a clean 4.14 × 3.55 m rectangle plus its arm by the kitchen door), *the maid area cleaned* (her bath x 9.85–11.275 × y 0–2.8, a linen store y 2.8–4.3 off the corridor, no slivers), the entry compact (y 5.5–7.9), the kitchen takes the leftovers (≈ 24.2 m² clear). *Step 8 (draft, 25 Nov 2026): the service open space divided* — a small entry at the courtyard door (x 8.95–10.55 × y 5.5–8.3; its doors: the courtyard, the kitchen opposite, the malqaf chamber at the south end of its east wall), a corridor north of it (y 4.3–5.5, 1.0 clear) to the house's only outside door on x 11.275 under the first floor, the maid room on the facade (2.4 clear wide) with her bath from her room only, the laundry beside the corridor, a cupboard; the kitchen takes the strip x 10.55–13.311 × y 6.5–8.3 back (≈ 23 m² clear); the women's majlis, the chamber, the courtyard and the liwan unchanged. *Step 7 (draft, 25 Nov 2026): the courtyard OPEN on its west side* — column 1 and the edge beam's arches over the courtyard removed: the sky opening from the riwaq line x 4.25 to the liwan (4.7 × 6.5 on axes, was 3.15 × 5.5); the first floor's gallery pulled back to x 4.25 and the west rooms moved into a 1.55 m west cantilever over the driveway (y 9.2–24, design_ff.typ); the ground floor's west wall stays on x 0, nothing else on it changes. *Step 6 (draft, 24 Nov 2026): the malqaf chamber and the liwan on the courtyard's EAST side* (the chamber inside the open space against the courtyard's north wall, x 7.25–8.95 × y 4.3–6.5, its maintenance door from the open space, its outlet into the courtyard; the liwan x 7.25–8.85 × y 8.0–12.9, bench +0.40, the first-floor suite to extend over it next step; *the malqaf core rises at its new place: FF and roof to follow*). Below, the V10.0 text as it stands. *Ground floor V10.0* on site option Z4, *straight walls (the owner's rule, 11 Nov 2026): every wall one continuous line, no jogs between rooms except for a structural reason (the lift shaft's RC wall, the service shaft, the malqaf's RC core); the riwaq's line x 4.25 and the laundry / kitchen wall y 6.5 straightened;* with *three columns* on x 5.8 (in the women's majlis south wall, between the courtyard glass and the living, in the living's south wall) under the edge beam of the first floor's 1.55 m west projection (enclosure option A, the gallery glazed on the edge beam), a colonnade along the courtyard edge with a three-arch arcade: a 13.311 × 24.0 m outline on wall centre lines with its north-east corner stepped (17 Nov 2026: one orthogonal step at x 11.275 / y 3.2 instead of the slant, the house 1.3 m further south) (13.561 × 24.25 outside), the north-east corner cut parallel to the lane down to y 5.245, then the east wall straight south. Outer west wall face #num(m-gap) m from the M line; nearest outer wall face to the envelope #num(env-gap) m (to be confirmed by the official survey). Both palms lie beyond the south facade. Wall allowances 250 mm outer, 200 mm inner, 100 mm dry block partitions. *Middle band:* *women's majlis* 4.70 × 6.5 · *courtyard* an L-shape round the malqaf chamber (27.19 m² on axes, ≈ 24.9 m² clear), open to the sky, the floor level; *no TV* (owner, 10 Nov 2026); *H2 (the haven study, adopted 10 Nov 2026; the owner's corrections of 11 Nov 2026):* the riwaq's line x 4.25 one straight line (the malqaf chamber's west wall on it, its courtyard face on the column line); the order along the breeze *outlet → olive → water*: the malqaf outlet raised to +0.60…+1.60 and centred in the first bay with its louvres fixed 15° south-east, the *olive* in its fixed pot in the jet's path (x 6.4–7.4, y 7.35–8.35) so the breeze passes under its crown, then over the *water trough* in front of the kitchen sink window (2.1 × 0.95 on the kitchen wall, rim +0.80, the spout under the window, a 0.40 fall, the skimmer at the south end), then onto the seating; the seating zone extended under the first-floor projection (a covered pocket x 4.35–5.925, y 10.3–12.3) keeping a 1.1 m path from the riwaq's sliding door, ≈ 16.4 m² free: a 3-seat sofa facing north, a 2-seat sofa under the projection facing east, an armchair at the kitchen wall, a low table (6 seats, every seat with a back, all facing the olive and the water); the living's glass fixed, the riwaq's sliding door the only door, a curtain inside the women's majlis; the colonnade walkway and the cleaning strips at the glass kept clear; the core's east wall 0.30 on the column line, its courtyard face flush with the columns under the edge beam · *living (double height)* 4.70 × 6.25, entered from the riwaq through a 1.40 m arched opening; its west wall solid and full height with the arched TV niche 4.40 × 0.70 m. *The malqaf (V10.0, L5):* its chamber at the courtyard's north-west corner inside the covered strip (the dust trap, the filters and the fan, the space for a cooler; the carved door onto the strip), its *courtyard outlet* 1.4 × 1.0 in the first arcade arch facing the seating, the shaft and the head above. *East service block* (studies/east_wing.typ): *kitchen* 4.361 × 6.0, two parallel counter runs, no island, sink on the courtyard wall, hob and hood on the outside east wall, hood extract straight out through the east wall (no east duct); *the maid's wing re-planned, layout D (owner, 10 Nov 2026; studies/maid_wing.typ, adopted):* from the kitchen the *laundry* across the whole width (y 4.7–6.5, *1.8 m deep: its kitchen wall on the structural line y 6.5 in one line with the women's majlis wall*, 11 Nov 2026; the two washers, the stacked dryer, the cupboards and the steam station in one run on the kitchen wall, the folding table on the majlis wall, the ceiling drying rack at the east-yard window, an extract fan with a humidity sensor, a floor drain), then the *maid bath* against the south part of the cut wall, 1.5 m deep, a simple wet room (a wall-mounted shower and mixer over a floor drain with falls, tanked and tiled, no tray, no cubicle; the WC under its own window on the cut; a basin; its drains straight out through the cut wall; door only from her room), then the *maid room* north of it (the bed in the north corner with its head on the north wall, the wardrobe on the majlis wall south of it, the shelf wedge in the north tip, a small desk under the escape casement on the cut's north part; its one door from the laundry); no store; maid access kitchen → laundry → her room → her bath. *West band (the owner's review, 10 Nov 2026):* the lift (installed at construction), the open stair (flipped, V8.2; the coat cupboard in its start strip), *one utility room with one door from the riwaq*: the west service *shaft* (x 0–1.5, y 9.2–10.4, drawn black, its maintenance door with 0.9 m clear in front), the panel, the heater and the manifold on the walls, and the *low part under the stair's half landing* (1.65 m) for the future batteries and inverter: the wall between them opened (the engineer), the store's door onto the riwaq removed. *West wash block* (2.75 × 13.6, studies/guest_wing.typ): *hospitality kitchen* 2.75 × 2.5 (open to the riwaq), a full-height wall, the *family powder room* 2.75 × 3.2 (owner, 10 Nov 2026, redrawn simple and rectangular): the *WC compartment across the full width* at the south end (2.75 × 1.55 on axes, ≈ 2.55 × 1.38 clear; its own 0.70 door) with *only the WC* (on the south service wall, east end) *and one basin* (west end); *outside*, the open zone (2.75 × 1.65, ≈ 2.55 × 1.5 clear) with *exactly two basins under a large mirror* on the west wall *opens directly onto the riwaq through a 1.35 m opening, no door* (owner, 10 Nov 2026); only the WC compartment has a door, in the zone's south partition, perpendicular to the riwaq's line of sight: from the riwaq one sees the basins and the mirror straight ahead, the compartment's door only obliquely and the WC never; no shower. The *serving passage* with its two doors (never open together). *Guest side (owner, 10 Nov 2026, redrawn):* two clean rectangles side by side along the wing, the basins onto the guest passage and the WC off the basins room: the *guest WC* 1.5 × 1.9 (≈ 1.3 × 1.7 clear; its 0.90 door on the south wall *from the basins room*, back where it was before the redraw: owner, 11 Nov 2026) with *only the WC and a shower mixer on the wall* (no shower zone, no floor marking; a floor drain, the room tanked and tiled; no basin, no cubicle wall), and right next to it the *guest basins* 1.5 × 2.0 (≈ 1.3 × 1.8 clear) with *three basins in one straight row and a mirror* on the east wall, open to the passage through a 1.8 m opening, the WC's door in its north wall beside the first basin; every drain into the west run; the guest passage and the foyer with the double door and the 1.80 m opening into the *men's majlis* 10.561 × 4.75.]
)

// ---------- Design idea and philosophy (last page) ----------
#pagebreak()
#text(17pt, fill: accent, weight: "bold")[Design idea and philosophy]
#v(2pt)
#text(9pt, fill: gray)[Taif / Palm House · Ground floor · *V11-idea · NE corner out, GF step 5* (24 Nov 2026, branch idea-ne-corner: the whole service area, from the women's majlis wall x 7.25 to the east wall, north of the kitchen and the courtyard, ONE OPEN SPACE with no inner partitions, to be planned later; the kitchen an exact rectangle; one step in the outside wall at (11.275, 6.5))]
#v(4pt)
#line(length: 100%, stroke: 0.7pt + accent)
#v(8pt)
#set par(leading: 0.55em, justify: true)
#grid(columns: (1fr, 1fr), column-gutter: 22pt, [
  #text(11pt, weight: "bold", fill: accent)[A house around a cool heart]

  The house is organised around one idea: a small, shaded courtyard at its centre that stays cool through the day. The rooms the family uses most open onto it. The wide double-height living room, which also holds the dining, faces it from the south; the kitchen from the east; the women's majlis from the north. On the west, the riwaq runs along it with windows. The courtyard is not a leftover space between rooms; it is the room the rest of the house looks into.

  #v(6pt)
  #text(11pt, weight: "bold", fill: accent)[Looking in, not out]

  The outer walls stay quiet, with small openings, as in the traditional houses of the region. Light, air and view come from the inside. This gives privacy from the street and the lane, protects the rooms from the hot sun and dust, and lets the family live openly within their own walls.

  #v(6pt)
  #text(11pt, weight: "bold", fill: accent)[Air before sun]

  Taif's prevailing wind comes from the north-west. The malqaf (V10.0, L5) stands at the courtyard's north-west corner: an RC core inside the covered strip with its foot chamber (the dust trap, the filters and the fan, the space for a cooler; a carved door onto the strip), the breeze outlet in the first arcade arch aimed over the olive at the water trough, the shaft in the gallery's end and the head 1.6 × 2.4 on the roof; it catches the wind above the roof, where it is strong and clean, and brings it down the shaft to the dust trap and the louvred outlet in the first arcade arch, a metre from the seating; a small filtered fan in the same chamber supplies the house. Nothing of the air system is in the maid's wing any more. Warm air rises and leaves through the open sky. The narrow courtyard is enclosed on all four sides and shaded by its walls, so it receives air without receiving sun. Every opening can be closed: open at night and early morning, closed in hot afternoons, dust and cold.

  #v(6pt)
  #text(11pt, weight: "bold", fill: accent)[On firm ground, as far north as possible]

  The house sits on the firm, higher ground in the north of the plot, square to the M line so every wall can be set out from the site pegs, and pushed as far north as the setbacks allow. The narrow courtyard keeps the house narrow, and the north-east corner steps back once, square (17 Nov 2026: one orthogonal step instead of the slant, easier to build and giving straight rooms), so the house keeps clear of the lane's setback and both palms stay well clear behind it.

  #v(6pt)
  #text(11pt, weight: "bold", fill: accent)[One living room, two heights]

  The living room is one open space with two ceiling heights. The half next to the courtyard is double height: it continues the courtyard's vertical space, gives the best view into it, and works as a chimney, with high operable windows that let warm air rise and leave while cool air is drawn in from the courtyard; its 4.70 m axis width (4.50 m clear) is a simple roof span. The east half is normal height: a warmer, lower place for dining beside the kitchen door, easier to air-condition and light, with ducts hidden in its ceiling, and the first floor continues above it. No upper floor is built over the double-height half or the courtyard.
], [
  #text(11pt, weight: "bold", fill: accent)[One band that serves the house]

  Everything that serves the house sits in one band on the west: the family entrance with the coat cupboard beside the stair's foot, the lift shaft (the lift is installed at construction), the stair, the utility room with the service shaft and the west wash block, one strip of wet rooms on one drain run (hospitality kitchen, family basins, family WC, guest WC, guest basins). Pipes, cables and air rise in one place, the structure gains one stiff core, and every service can be reached for maintenance without breaking a wall. The family lobby and riwaq run along this band as one straight strip on the courtyard side, the family's covered route from the front door to the living room.

  #v(6pt)
  #text(11pt, weight: "bold", fill: accent)[Family, guests and service, each in their place]

  The family enters through the lobby; women guests use the same door to reach the women's majlis. The men's majlis has its own foyer, entered by a double door at one end and opening into the majlis at the other (a bent entry), with a shoe cabinet and hooks for the bisht and shemagh, a trough basin with three taps and a WC whose door hides behind a short screen wall, all in the south of the west wash block; the guest side has no door onto the riwaq. Its only link to the house is a short serving passage with only two doors that are never open together: the family opens door 1 from the riwaq, leaves the tray and closes it, then calls the host, who opens door 2 from the guest passage and collects. Door 1 locks from the riwaq side and door 2 from inside the passage, so the family controls both. An open door 2 shows only the passage and a blank wall, a bent entry (majaz). The hospitality kitchen just north of it, a light kitchen for coffee, tea, dates and desserts, is the serving base; the east kitchen is the heavy one. The living room opens to the riwaq without a door and only a 1.20 m low partition faces the serving door, so the family's privacy rests on the two serving doors never being open together. The kitchen stays isolated beside the courtyard, a clean 4.36 × 6.5 m room on the same lines as the courtyard, with two parallel counter runs, its only door to the dining and an open entrance to the laundry. The maid's wing (layout D, 10 Nov 2026) is reached only through the kitchen: the laundry first, across the whole width; then her bath on the south part of the cut wall, with its own window and the shortest drain; then her room in the north, with the bed and the wardrobe on solid walls and the tip as built-in shelves. Kitchen, laundry and maid bath drain straight out to the east, to a manhole in the east service yard; the vent stack runs up the outside face of the east wall, and the kitchen extract leaves straight through the east wall at the hood (no east duct).

  #v(6pt)
  #text(11pt, weight: "bold", fill: accent)[Services built for life]

  The service shaft sits inside a utility room, so every service is in one place behind one door: the shaft, the main electrical panel, the water manifold with its isolation valves and the water heater, and (10 Nov 2026, owner) the low part under the stair's half landing as the same room, where the future batteries and inverter go. The shaft is a closed box of about 1.0 × 1.2 m clear with sealed walls and one full-height maintenance door, and the 0.9 m in front of that door is always kept clear. It stands directly beside the west wash block, so drainage runs stay short; first-floor bathrooms should stack over the north part of the block, near the shaft. The block's drain crosses under the serving passage floor, with a cleanout access point there. The space under the stair's half landing is the low part of the utility room (1.65 m headroom), not a separate store. The lift shaft is built now as a store and fitted with a two-stop lift later. The Saudi Building Code sets no fixed size for a closed pipe shaft; the sizes here follow general professional guidance and must be confirmed with the code, the municipality and the plumbing engineer.

  #v(10pt)
  #text(7pt, fill: gray)[Concept for discussion (V10.0). The malqaf's breeze and its filtered supply, the waterproofing, the drainage, the structure and the services need the engineers' review; the wind faces to be confirmed by the on-site weather station.]
])

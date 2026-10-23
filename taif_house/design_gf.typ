// design_gf.typ · Taif / Palm House · GROUND FLOOR V6.0 · the file you compile for the ground floor
// Compact courtyard house: courtyard at the centre, west service band, east service block, air tower with an underground tunnel.
// No columns: the first floor's west projection is split (0.675 m inward as a plain cantilever, 0.675 m outward over the west wall).
// Reads data/rooms_gf.csv (rooms) and base.typ (site). Room studies: studies/guest_wing.typ (west wash block), studies/east_wing.typ (east service block).
// Full description: docs/PROJECT_V6.md · DXF: tools/make_dxf.py reads this file
#import "base.typ": *
#show: setup

// ---------- Place the whole building ----------
#let shift = (0.91, 3.525)   // site-test option Z4: outer west face 0.785 m from the M line, north wall as far north as the setbacks allow
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
// pentagon: north-east corner cut parallel to the lane from (10.051, 0) to (13.311, 6.0), then the east wall straight south; south wall at y 24.0
#let outline-csv-gf = ((0, 0), (10.051, 0), (13.311, 6.0), (13.311, 24.0), (0, 24.0))
#let outline-gf = outline-csv-gf.map(place)

// ---------- Building against the envelope: outer wall face = centre line + 0.125 m (250 mm outer walls) ----------
#let outer-wall = 0.125
#assert(sample(outline-gf, step: 0.1).all(p => inside(p, env)), message: "ERROR: the building centre line leaves the envelope.")
#let env-gap = calc.min(..sample(outline-gf, step: 0.1).map(p => calc.min(..edges(env).map(e => seg-dist(p, ..e))))) - outer-wall
#assert(env-gap >= 0, message: "ERROR: the outer wall face crosses the envelope (setback line).")
#let m-gap = calc.min(..outline-gf.map(p => p.at(0))) - outer-wall   // outer west face to the M line

// ---------- Courtyard ----------
#let cw = float(crow.w)
#let cd = float(crow.d)
#let cx0 = float(crow.x) - cw / 2
#let cy0 = float(crow.y) - cd / 2
#let court = ((cx0, cy0), (cx0 + cw, cy0), (cx0 + cw, cy0 + cd), (cx0, cy0 + cd)).map(rotp)

// ---------- Entry arrows (CSV coordinates): (point on the wall, outward direction, label) ----------
#let entries = (
  ((3.5, 0.0), (0.0, -1.0), [Family entry]),      // family lobby, north wall
  ((0.0, 22.2), (-1.0, 0.0), [Guest entry]),      // foyer, double door at the north end of its west wall
)

// ---------- Outlines drawn INSIDE a host room (not counted as area, no overlap check): (x0, y0, x1, y1, label), CSV ----------
#let inner-boxes = (
  (0.0, 9.2, 1.5, 10.4, [shaft]),                 // west service shaft, inside the utility room
  (0.0, 6.9, 2.75, 7.9, [under-stair store]),
)
#let inner-marks = inner-boxes.map(((x0, y0, x1, y1, l)) => {
  let P = ((x0, y0), (x1, y0), (x1, y1), (x0, y1)).map(place)
  (((P.at(0), P.at(1)), l), ((P.at(1), P.at(2)), []), ((P.at(2), P.at(3)), []), ((P.at(3), P.at(0)), []))
}).fold((), (acc, m) => acc + m)

// ceiling-height change inside the living room (one open room, no wall), and the first-floor edges above this floor
#let level-marks = (((place((8.95, 13.0)), place((8.95, 19.25))), [ceiling height change]), ((place((4.925, 6.5)), place((4.925, 19.25))), [FF cantilever edge above (0.675, no beam)]), ((place((-0.675, 10.4)), place((-0.675, 24.0))), [FF west wall above, on cantilever beams]))

// ---------- Doors, openings, windows and special walls (CSV): ((x1, y1), (x2, y2), label) · the // comment names each line ----------
// labels left empty at this scale; output/guest_wing.pdf and output/east_wing.pdf carry the full labels
// west band and west wash block (studies/guest_wing.typ: local y + 10.4 = CSV y)
#let west-lines = (
  ((2.25, 0.9), (2.25, 1.9), []),            // future lift door (behind the removable south part of the entry cupboard)
  ((2.75, 0.2), (2.75, 2.0), []),             // entry cupboard, open to the family lobby
  ((2.75, 10.6), (2.75, 12.7), []),           // hospitality kitchen, open to the riwaq
  ((2.75, 13.0), (2.75, 14.3), []),           // family basins, open to the riwaq
  ((1.6, 14.4), (2.4, 14.4), []),            // family WC door, off the basins
  ((0.0, 12.9), (2.75, 12.9), []),           // hospitality kitchen / basins wall, full height
  ((2.75, 16.25), (2.75, 17.15), []),         // serving door 1 (0.90), to the riwaq, lockable from the riwaq side; opposite: the living room's 1.20 m low partition
  ((0.1, 17.5), (1.15, 17.5), [serving doors 1 + 2]),   // serving door 2 (1.05, guest side), lockable from inside the passage
  ((0.0, 17.5), (2.75, 17.5), []),           // family / guest line
  ((1.3, 19.25), (2.05, 19.25), []),         // guest WC door, south wall (on the men's majlis line), opens in
  ((1.25, 19.25), (1.25, 19.85), []),        // WC screen wall
  ((0.0, 21.5), (0.0, 22.9), []),            // guest entrance, double door 1.40 m (two leaves), opens in, north end of the foyer's west wall
  ((2.75, 22.15), (2.75, 23.95), []),        // open passage into the men's majlis, 1.80 m, no door, south end of the foyer's east wall
  ((4.25, 13.1), (4.25, 14.5), []),          // living room: open entrance from the riwaq, 1.40 m, no door
  ((4.25, 14.5), (4.25, 19.25), [low wall 1.20 m]),     // living room: low partition 1.20 m high to the riwaq, open above
)
// east service block (studies/east_wing.typ: local + (8.95, 0) = CSV)
#let east-lines = (
  ((9.7, 6.5), (10.55, 6.5), []),             // open entrance kitchen ↔ laundry (no door)
  ((10.65, 2.95), (10.65, 3.75), []),         // laundry ↔ maid room, north end of the 100 mm partition
  ((10.715, 2.8), (11.415, 2.8), []),         // maid room ↔ maid bath, 0.70 m clear (sliding or opening out)
  ((9.4, 13.0), (10.5, 13.0), []),            // kitchen ↔ dining
  ((8.95, 9.1), (8.95, 11.1), []),            // sink window onto the courtyard
  ((13.311, 8.7), (13.311, 10.1), []),        // kitchen window, east
  ((12.170, 3.9), (12.714, 4.9), []),         // maid room window in the cut wall, high sill ≥ 1.5 m
  ((11.138, 2.0), (11.464, 2.6), []),         // maid bath vent window in the cut wall
)
#let door-marks = (west-lines + east-lines).map(((a, b, l)) => ((place(a), place(b)), l))

// ---------- Air tower: tip of the north-east cut corner, 1.0 m deep (CSV), drawn blue with the air list ----------
#let tower-pts = ((8.95, 0), (10.051, 0), (10.594, 1.0), (8.95, 1.0)).map(place)
#let tower-marks = (((tower-pts.at(0), tower-pts.at(1)), [Air tower]),)

#let arrows = entries.map(((p, d, l)) => {
  let b = place(p)
  (addv(b, 2.6, rotv(d)), b, l)
})

#render(
  title: [Ground floor V6.0 · pentagon on site option Z4],
  subtitle: [Taif / Palm House V6.0 · base.typ + design_gf.typ + data/rooms_gf.csv · room studies in studies/ · full description docs/PROJECT_V6.md],
  court: court,
  rooms: rooms.map(rotrow),
  air: (("Air tower", tower-pts),),
  arrows: arrows,
  marks: inner-marks + level-marks + door-marks + tower-marks,
  limit: outline-gf,
  note: [*Ground floor V6.0* on site option Z4, *no columns* (the first-floor projection is split: 0.675 m inward as a plain cantilever, 0.675 m outward over the west wall): a pentagon 13.311 × 24.0 m on wall centre lines (13.561 × 24.25 outside), the north-east corner cut parallel to the lane down to y 6.0, then the east wall straight south. Outer west wall face #num(m-gap) m from the M line; nearest outer wall face to the envelope #num(env-gap) m (to be confirmed by the official survey). Both palms lie beyond the south facade. Wall allowances 250 mm outer, 200 mm inner, 100 mm dry block partitions. *Middle band* 4.50 m clear: *women's majlis* 4.70 × 6.5 · *courtyard* 4.70 × 6.5 (4.50 × 6.30 clear) · *living (double height)* 4.70 × 6.25, open to the riwaq through a 1.40 m opening, then a 1.20 m low partition. *East service block* (studies/east_wing.typ): *kitchen* 4.361 × 6.5, two parallel counter runs, no island, sink on the courtyard wall, hob and hood on the outside east wall, hood extract straight out through the east wall (no east duct); *laundry* 1.70 × 3.7, ≈ 0.95 m clear beside the machines; *maid room* ≈ 6.0 m² clear and *maid bath* 1.8 m deep (≈ 3.0 m² clear), both up to the sloped wall; *air tower* 1.0 m deep (≈ 0.9 m² clear); maid access only kitchen → laundry → maid room → maid bath. *West band:* entry cupboard and *future lift* (2.25 × 2.2, shaft placeholder, a store until then), stair (open, no door), utility room with the service shaft, then the *west wash block* (2.75 × 13.6, studies/guest_wing.typ): *hospitality kitchen* 2.75 × 2.5 (light kitchen, open to the riwaq), a full-height wall, family basins, family WC (no shower), *serving passage* 2.75 × 1.4 (1.20 m clear, two doors never open together, both locked from the family side), then the guest side: guest WC 1.5 × 1.75, *guest basins* (one trough, 3 taps), guest passage, *foyer* with a 1.40 m double door at the north end of its west wall and a 1.80 m opening into the men's majlis at the south end of its east wall. *Family lobby + riwaq* 1.5 × 19.25 · *living (normal height) · dining* 4.361 × 6.25 · *men's majlis* 10.561 × 4.75. Blue outlines inside rooms are the shaft and the under-stair store (not extra area); blue lines mark the ceiling-height change, the FF cantilever edge over the courtyard (x 4.925), the FF west wall above (x -0.675, outside this floor), the low wall and the doors, openings and walls of both blocks.],
)

// ---------- Design idea and philosophy (last page) ----------
#pagebreak()
#text(17pt, fill: accent, weight: "bold")[Design idea and philosophy]
#v(2pt)
#text(9pt, fill: gray)[Taif / Palm House · Ground floor V6.0 · pentagon with the north-east corner cut]
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

  Taif's prevailing wind comes from the north-west. An air tower filling the leftover tip of the north-east cut corner (1.0 m deep, about 0.9 m² clear: enough for one person to step in and clean, with the main cleaning from a roof hatch), so it takes no usable room space, catches it above the roof, where it is strong and clean, and brings it down to a tunnel below the floor. The tunnel passes through the cool ground and releases the air through a low, closable opening in the courtyard wall. Warm air rises and leaves through the open sky. The narrow courtyard is enclosed on all four sides and shaded by its walls, so it receives air without receiving sun. Every opening can be closed: open at night and early morning, closed in hot afternoons, dust and cold.

  #v(6pt)
  #text(11pt, weight: "bold", fill: accent)[On firm ground, as far north as possible]

  The house sits on the firm, higher ground in the north of the plot, square to the M line so every wall can be set out from the site pegs, and pushed as far north as the setbacks allow. The narrow courtyard keeps the house narrow, and the north-east corner is cut parallel to the lane, so the whole house reaches further north and both palms stay well clear behind it.

  #v(6pt)
  #text(11pt, weight: "bold", fill: accent)[One living room, two heights]

  The living room is one open space with two ceiling heights. The half next to the courtyard is double height: it continues the courtyard's vertical space, gives the best view into it, and works as a chimney, with high operable windows that let warm air rise and leave while cool air is drawn in from the courtyard; its 4.70 m axis width (4.50 m clear) is a simple roof span. The east half is normal height: a warmer, lower place for dining beside the kitchen door, easier to air-condition and light, with ducts hidden in its ceiling, and the first floor continues above it. No upper floor is built over the double-height half or the courtyard.
], [
  #text(11pt, weight: "bold", fill: accent)[One band that serves the house]

  Everything that serves the house sits in one band on the west: the family entrance with its entry cupboard, the future lift shaft, the stair, the utility room with the service shaft and the west wash block, one strip of wet rooms on one drain run (hospitality kitchen, family basins, family WC, guest WC, guest basins). Pipes, cables and air rise in one place, the structure gains one stiff core, and every service can be reached for maintenance without breaking a wall. The family lobby and riwaq run along this band as one straight strip on the courtyard side, the family's covered route from the front door to the living room.

  #v(6pt)
  #text(11pt, weight: "bold", fill: accent)[Family, guests and service, each in their place]

  The family enters through the lobby; women guests use the same door to reach the women's majlis. The men's majlis has its own foyer, entered by a double door at one end and opening into the majlis at the other (a bent entry), with a shoe cabinet and hooks for the bisht and shemagh, a trough basin with three taps and a WC whose door hides behind a short screen wall, all in the south of the west wash block; the guest side has no door onto the riwaq. Its only link to the house is a short serving passage with only two doors that are never open together: the family opens door 1 from the riwaq, leaves the tray and closes it, then calls the host, who opens door 2 from the guest passage and collects. Door 1 locks from the riwaq side and door 2 from inside the passage, so the family controls both. An open door 2 shows only the passage and a blank wall, a bent entry (majaz). The hospitality kitchen just north of it, a light kitchen for coffee, tea, dates and desserts, is the serving base; the east kitchen is the heavy one. The living room opens to the riwaq without a door and only a 1.20 m low partition faces the serving door, so the family's privacy rests on the two serving doors never being open together. The kitchen stays isolated beside the courtyard, a clean 4.36 × 6.5 m room on the same lines as the courtyard, with two parallel counter runs, its only door to the dining and an open entrance to the laundry. The laundry runs north along the solid wall of the women's majlis to the maid room and maid bath, which use the sloped corner to the full; the maid wing is reached only through the kitchen. Kitchen, laundry and maid bath drain straight out to the east, to a manhole in the east service yard; the vent stack runs up the outside face of the east wall, and the kitchen extract leaves straight through the east wall at the hood (no east duct).

  #v(6pt)
  #text(11pt, weight: "bold", fill: accent)[Services built for life]

  The service shaft sits inside a utility room, so every service is in one place behind one door: the shaft, the main electrical panel, the water manifold with its isolation valves and the water heater. The shaft is a closed box of about 1.0 × 1.2 m clear with sealed walls and one full-height maintenance door, and the 0.9 m in front of that door is always kept clear. It stands directly beside the west wash block, so drainage runs stay short; first-floor bathrooms should stack over the north part of the block, near the shaft. The block's drain crosses under the serving passage floor, with a cleanout access point there. The space under the stair's landing becomes a store instead of dead space. The lift shaft is built now as a store and fitted with a two-stop lift later. The Saudi Building Code sets no fixed size for a closed pipe shaft; the sizes here follow general professional guidance and must be confirmed with the code, the municipality and the plumbing engineer.

  #v(10pt)
  #text(7pt, fill: gray)[Concept for discussion. Airflow, tunnel depth, waterproofing, drainage, structure and services need the engineers' review; wind direction to be confirmed on site.]
])

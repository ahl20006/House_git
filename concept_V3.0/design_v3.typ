// design_v3.typ · Taif / Palm House · Design V3.2 (Revision 02, 16 Oct 2026) · the file you compile for V3 (folder name stays concept_V3.0)
// Compact courtyard house: courtyard at the centre, west service band, air tower with an underground tunnel.
#import "base.typ": *
#show: setup

// ---------- Place the whole building ----------
#let shift = (0.91, 3.525)   // V3.2: on site-test option Z4, moved 0.26 m east (outer west face 0.785 m from the M line); NE corner cut parallel to the lane
#let rot = 0deg               // square to the M line

// ---------- Rows from the CSV (# at the start of a name switches the row off) ----------
// optional "pts" column (corner points of a room that is not a rectangle) moves with the room
#let map-pts(r, f) = {
  let r = r
  let P = pts-of(r)
  if P.len() >= 3 { r.insert("pts", P.map(f).map(p => str(p.at(0)) + " " + str(p.at(1))).join(";")) }
  r
}
#let all-rows = csv("data/rooms_v3.csv", row-type: dictionary).filter(r => not r.name.starts-with("#")).map(r => {
  let r = r
  r.insert("x", str(float(r.x) + shift.at(0)))
  r.insert("y", str(float(r.y) + shift.at(1)))
  map-pts(r, p => addv(p, 1, shift))
})
#let crow = all-rows.find(r => r.name == "Courtyard")
#assert(crow != none, message: "ERROR: no row named Courtyard in data/rooms_v3.csv.")
#let air-rows = all-rows.filter(r => r.at("colour", default: "") == "air")   // optional, drawn blue under rooms
#let rooms = all-rows.filter(r => r.name != "Courtyard" and r.at("colour", default: "") != "air")

// ---------- Rotation ----------
#let pivot = (float(crow.x), float(crow.y))
#let rotv(v) = (v.at(0) * calc.cos(rot) - v.at(1) * calc.sin(rot), v.at(0) * calc.sin(rot) + v.at(1) * calc.cos(rot))
#let rotp(p) = addv(pivot, 1, rotv((p.at(0) - pivot.at(0), p.at(1) - pivot.at(1))))
#let rotrow(r) = {
  let r = map-pts(r, rotp)
  let c = rotp((float(r.x), float(r.y)))
  r.insert("x", str(c.at(0)))
  r.insert("y", str(c.at(1)))
  r.insert("angle", str(float(r.at("angle", default: "0")) + rot.deg()))
  r
}

// ---------- Building outline (wall centre lines, CSV coordinates): pentagon, NE corner cut along the lane ----------
// V3.2: the cut runs on to y 6.0 (x 13.311), then the east wall goes straight south; south wall at y 23.5
#let outline-v3 = ((0, 0), (10.051, 0), (13.311, 6.0), (13.311, 23.5), (0, 23.5)).map(p => rotp(addv(p, 1, shift)))

// ---------- Building against the envelope: outer wall face = centre line + 0.125 m (250 mm outer walls) ----------
#let outer-wall = 0.125
#assert(sample(outline-v3, step: 0.1).all(p => inside(p, env)), message: "ERROR: the building centre line leaves the envelope.")
#let env-gap = calc.min(..sample(outline-v3, step: 0.1).map(p => calc.min(..edges(env).map(e => seg-dist(p, ..e))))) - outer-wall
#assert(env-gap >= 0, message: "ERROR: the outer wall face crosses the envelope (setback line).")
#let m-gap = calc.min(..outline-v3.map(p => p.at(0))) - outer-wall   // outer west face to the M line

// ---------- Courtyard ----------
#let cw = float(crow.w)
#let cd = float(crow.d)
#let cx0 = float(crow.x) - cw / 2
#let cy0 = float(crow.y) - cd / 2
#let court = ((cx0, cy0), (cx0 + cw, cy0), (cx0 + cw, cy0 + cd), (cx0, cy0 + cd)).map(rotp)

// ---------- Entry arrows, tied to rooms (CSV coordinates before shift, so they follow the building) ----------
// (point on the wall, outward direction, label)
#let entries = (
  ((3.5, 0.0), (0.0, -1.0), [Family entry]),      // family lobby, north wall
  ((0.0, 22.1), (-1.0, 0.0), [Guest entry]),      // foyer, west wall (west wash block)
)
// ---------- Outlines drawn INSIDE a host room (not counted as area, no overlap check) ----------
// (x0, y0, x1, y1, label) in CSV coordinates
#let inner-boxes = (
  (0.0, 9.2, 1.5, 10.4, [shaft]),
  (0.0, 6.9, 2.75, 7.9, [under-stair store]),
)
#let inner-marks = inner-boxes.map(((x0, y0, x1, y1, l)) => {
  let P = ((x0, y0), (x1, y0), (x1, y1), (x0, y1)).map(p => rotp(addv(p, 1, shift)))
  (((P.at(0), P.at(1)), l), ((P.at(1), P.at(2)), []), ((P.at(2), P.at(3)), []), ((P.at(3), P.at(0)), []))
}).fold((), (acc, m) => acc + m)

// ceiling-height change inside the living room (same open room, no wall)
#let level-marks = (((rotp(addv((8.95, 12.5), 1, shift)), rotp(addv((8.95, 18.75), 1, shift))), [ceiling height change]),)
// west wash block: doors, openings, screen wall and the family / guest line, from studies/guest_wing.typ (local y + 10.4 = CSV y)
// labels left empty at this scale; studies/guest_wing.pdf carries the full labels
#let wash-lines = (
  ((2.75, 10.6), (2.75, 12.25), []),          // coffee corner, open to the riwaq
  ((2.75, 12.5), (2.75, 13.8), []),           // family basins, open to the riwaq
  ((1.6, 13.9), (2.4, 13.9), []),            // family WC door, off the basins
  ((0.0, 12.4), (2.75, 12.4), []),           // coffee / basins wall, full height (V3.2)
  ((2.75, 15.75), (2.75, 16.65), []),         // serving door 1 (0.90), to the riwaq, lockable from the riwaq side; opposite: the living room's 1.20 m low partition
  ((1.0, 15.7), (1.7, 15.7), []),             // serving shelf 0.70 × 0.20 on the passage's north wall, 1.20 m clear in front
  ((0.1, 17.2), (1.15, 17.2), [serving doors 1 + 2]),   // serving door 2 (1.05, guest side), lockable from inside the passage
  ((0.0, 17.2), (2.75, 17.2), []),           // family / guest line
  ((1.3, 18.9), (2.05, 18.9), []),           // guest WC door, south wall, opens in
  ((1.25, 18.9), (1.25, 19.5), []),          // WC screen wall
  ((0.0, 21.5), (0.0, 22.7), []),            // guest entrance
  ((2.75, 21.4), (2.75, 22.6), []),          // door to the men's majlis
  ((4.25, 12.6), (4.25, 14.0), []),          // living room: open entrance from the riwaq, 1.40 m, no door (V3.2)
  ((4.25, 14.0), (4.25, 18.75), [low wall 1.20 m]),     // living room: low partition 1.20 m high to the riwaq, open above (V3.2)
)
// east service block: doors, open entrance and windows, from studies/east_wing.typ (local + (8.95, 0) = CSV); labels in studies/east_wing.pdf
#let east-lines = (
  ((9.6, 6.0), (10.4, 6.0), []),              // open entrance kitchen ↔ laundry (no door)
  ((10.5, 2.95), (10.5, 3.75), []),           // laundry ↔ maid room, north end of the laundry's east wall
  ((10.7, 2.8), (11.4, 2.8), []),             // maid room ↔ maid bath (sliding or opening out)
  ((9.4, 12.5), (10.5, 12.5), []),            // kitchen ↔ dining
  ((8.95, 8.6), (8.95, 10.6), []),            // sink window onto the courtyard
  ((13.311, 8.2), (13.311, 9.6), []),         // kitchen window, east
  ((12.170, 3.9), (12.714, 4.9), []),         // maid room window in the cut wall, high sill
  ((11.138, 2.0), (11.464, 2.6), []),         // maid bath vent window in the cut wall
)
#let door-marks = (wash-lines + east-lines).map(((a, b, l)) => ((rotp(addv(a, 1, shift)), rotp(addv(b, 1, shift))), l))

// air tower: polygon filling the tip of the north-east cut corner (CSV coordinates), drawn with the air list


#let tower-pts = ((8.95, 0), (10.051, 0), (10.703, 1.2), (8.95, 1.2)).map(p => rotp(addv(p, 1, shift)))

#let tower-marks = (((tower-pts.at(0), tower-pts.at(1)), [Air tower]),)

#let arrows = entries.map(((p, d, l)) => {
  let b = rotp(addv(p, 1, shift))
  (addv(b, 2.6, rotv(d)), b, l)
})

#render(
  title: [Design V3.2 · pentagon Z4 · Revision 02],
  subtitle: [16 Oct 2026 · Design V3.2 (Concept V3.1 Revision 02) · base.typ + design_v3.typ + data/rooms_v3.csv · room studies in studies/],
  court: court,
  rooms: rooms.map(rotrow),
  air: air-rows.map(rotrow).map(r => (r.name, room-poly(r))) + (("Air tower", tower-pts),),
  arrows: arrows,
  marks: inner-marks + level-marks + door-marks + tower-marks,
  limit: outline-v3,
  note: [*V3.2* (Revision 02) on site-test option Z4: a pentagon 13.311 × 23.5 m on wall centre lines (13.561 × 23.75 outside, ≈ 312 m²). The north-east cut runs parallel to the lane all the way to the south end of the maid room (y 6.0), then the east wall goes straight south. Moved 0.26 m east: outer west wall face #num(m-gap) m from the M line; nearest outer wall face to the envelope #num(env-gap) m (wall allowances 250 mm outer, 200 mm inner). Both palms lie well beyond the south facade. *Middle band* exactly 4.50 m clear: *women's majlis* 4.70 × 6 · *courtyard* 4.70 × 6.5 on axes (4.50 × 6.30 clear) · *living (double height)* 4.70 × 6.25, open to the riwaq through a 1.40 m opening with no door, then a 1.20 m low partition (open above). *East service block* (studies/east_wing.typ): *kitchen* 4.361 × 6.5 (≈ 4.14 m clear wide), exactly on the courtyard lines, sink under the courtyard window, hob, hood and fridge on the outside east wall, doors only to the dining and the laundry; *laundry* 1.55 × 3.2 on the solid women's majlis wall, open entrance from the kitchen, ≈ 0.75 m beside the machines; *maid room* (≈ 6.21 m²) and *maid bath* (≈ 3.50 m²) run up to the sloped wall, each with a window in it; maid access only kitchen → laundry → maid room → maid bath. *Air tower* (blue, ≈ 1.7 m², ≈ 1.1 m² clear) in the tip of the cut corner. *West band:* lift, stair (open access, no door; store under its landing), *utility room with the service shaft inside it*, then the *west wash block* (2.75 × 13.1 m, studies/guest_wing.typ), one strip of wet rooms on one drain run: coffee corner (2.75 × 2, the serving base) and family basins (2.75 × 1.5), separated by a full-height wall and each open to the riwaq; family WC (2.75 × 1.7); *serving passage* (2.75 × 1.6: a 0.70 × 0.20 shelf and 1.20 m clear in front of it, door 1 0.90 m to the riwaq, door 2 1.05 m to the guest passage, never open together, both locked from the family side) as the only link between family and guests; then the guest side, moved 0.50 m south as one block: guest WC (1.5 × 1.7) behind a short screen wall, three guest basins, guest passage, foyer. Opposite door 1 the living room has only the low partition, so family privacy relies on the two serving doors. *Family lobby + riwaq* 1.5 × 18.75, one straight strip from the front door to the men's majlis; the guest side has no door onto it · *living (normal height) · dining* 4.361 × 6.25 · *men's majlis* 10.561 × 4.75, its west wall on the west band line (x = 2.75). Blue outlines inside rooms are the shaft and the under-stair store (not extra area); blue lines mark the ceiling-height change, the low wall and the doors, openings and walls of both blocks.],
)

// ---------- Design idea and philosophy (last page) ----------
#pagebreak()
#text(17pt, fill: accent, weight: "bold")[Design idea and philosophy]
#v(2pt)
#text(9pt, fill: gray)[Taif / Palm House · Design V3.2 · pentagon with the north-east corner cut]
#v(4pt)
#line(length: 100%, stroke: 0.7pt + accent)
#v(8pt)
#set par(leading: 0.65em, justify: true)
#grid(columns: (1fr, 1fr), column-gutter: 22pt, [
  #text(11pt, weight: "bold", fill: accent)[A house around a cool heart]

  The house is organised around one idea: a small, shaded courtyard at its centre that stays cool through the day. The rooms the family uses most open onto it. The wide double-height living room, which also holds the dining, faces it from the south; the kitchen from the east; the women's majlis from the north. On the west, the riwaq runs along it with windows. The courtyard is not a leftover space between rooms; it is the room the rest of the house looks into.

  #v(6pt)
  #text(11pt, weight: "bold", fill: accent)[Looking in, not out]

  The outer walls stay quiet, with small openings, as in the traditional houses of the region. Light, air and view come from the inside. This gives privacy from the street and the lane, protects the rooms from the hot sun and dust, and lets the family live openly within their own walls.

  #v(6pt)
  #text(11pt, weight: "bold", fill: accent)[Air before sun]

  Taif's prevailing wind comes from the north-west. An air tower filling the leftover tip of the north-east cut corner, so it takes no usable room space, catches it above the roof, where it is strong and clean, and brings it down to a tunnel below the floor. The tunnel passes through the cool ground and releases the air through a low, closable opening in the courtyard wall. Warm air rises and leaves through the open sky. The narrow courtyard is enclosed on all four sides and shaded by its walls, so it receives air without receiving sun. Every opening can be closed: open at night and early morning, closed in hot afternoons, dust and cold.
  #v(6pt)
  #text(11pt, weight: "bold", fill: accent)[On firm ground, as far north as possible]

  The house sits on the firm, higher ground in the north of the plot, square to the M line so every wall can be set out from the site pegs, and pushed as far north as the setbacks allow. The narrow courtyard keeps the house narrow, and the north-east corner is cut parallel to the lane, so the whole house reaches further north and both palms stay well clear behind it.
  #v(6pt)
  #text(11pt, weight: "bold", fill: accent)[One living room, two heights]

  The living room is one open space with two ceiling heights. The half next to the courtyard is double height: it continues the courtyard's vertical space, gives the best view into it, and works as a chimney, with high operable windows that let warm air rise and leave while cool air is drawn in from the courtyard; its 4.70 m axis width (4.50 m clear) is a simple roof span. The east half is normal height: a warmer, lower place for dining beside the kitchen door, easier to air-condition and light, with ducts hidden in its ceiling, and the first floor continues above it. No upper floor is built over the double-height half or the courtyard.
], [
  #text(11pt, weight: "bold", fill: accent)[One band that serves the house]

  Everything that serves the house sits in one band on the west: the family entrance, the lift, the stair, the utility room with the service shaft and the west wash block, one strip of wet rooms on one drain run (coffee corner, family basins, family WC, guest WC, guest basins). Pipes, cables and air rise in one place, the structure gains one stiff core, and every service can be reached for maintenance without breaking a wall. The family lobby and riwaq run along this band as one straight strip on the courtyard side, the family's covered route from the front door to the living room.

  #v(6pt)
  #text(11pt, weight: "bold", fill: accent)[Family, guests and service, each in their place]

  The family enters through the lobby; women guests use the same door to reach the women's majlis. The men's majlis has its own entrance, foyer, three basins open to the guest passage and a WC whose door hides behind a short screen wall, all in the south of the west wash block; the guest side has no door onto the riwaq. Its only link to the house is a short serving passage with a shelf and only two doors that are never open together: the family opens door 1 from the riwaq, puts coffee, trays or food on the shelf, closes it and calls the host; the host opens door 2 from the guest passage and collects. Door 1 locks from the riwaq side and door 2 from inside the passage, so the family controls both. An open door 2 shows only the passage and a blank wall, a bent entry (majaz), and the coffee corner just north of it is the serving base. The living room opens to the riwaq without a door and only a 1.20 m low partition faces the serving door, so the family's privacy rests on the two serving doors never being open together. The kitchen stays isolated beside the courtyard, a clean 4.36 × 6.5 m room on the same lines as the courtyard, with its only door to the dining and an open entrance to the laundry. The laundry runs north along the solid wall of the women's majlis to the maid room and maid bath, which use the sloped corner to the full; the maid bath, laundry and kitchen sink share one drain line down the west side of the block, and the maid wing is reached only through the kitchen.

  #v(6pt)
  #text(11pt, weight: "bold", fill: accent)[Services built for life]

  The service shaft sits inside a utility room, so every service is in one place behind one door: the shaft, the main electrical panel, the water manifold with its isolation valves and the water heater. The shaft is a closed box of about 1.0 × 1.2 m clear with sealed walls and one full-height maintenance door, and the 0.9 m in front of that door is always kept clear. It stands directly beside the west wash block, so drainage runs stay short; first-floor bathrooms should stack over the north part of the block, near the shaft. The block's drain crosses under the serving passage floor, with a cleanout access point there. The space under the stair's landing becomes a store instead of dead space. The Saudi Building Code sets no fixed size for a closed pipe shaft; the sizes here follow general professional guidance and must be confirmed with the code, the municipality and the plumbing engineer.

  #v(10pt)
  #text(7pt, fill: gray)[Concept for discussion. Airflow, tunnel depth, waterproofing, drainage, structure and services need the engineers' review; wind direction to be confirmed on site.]
])

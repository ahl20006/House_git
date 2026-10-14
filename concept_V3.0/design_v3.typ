// design_v3.typ · Taif / Palm House · Design V3.0 · the file you compile for V3
// Compact courtyard house: courtyard at the centre, west service band, air tower with an underground tunnel.
#import "base.typ": *
#show: setup

// ---------- Place the whole building ----------
#let shift = (1.025, 3.525)  // V3 sits on site-test option Z3 (pentagon, NE corner cut parallel to the lane)
#let rot = 0deg               // square to the M line

// ---------- Rows from the CSV (# at the start of a name switches the row off) ----------
#let all-rows = csv("data/rooms_v3.csv", row-type: dictionary).filter(r => not r.name.starts-with("#")).map(r => {
  let r = r
  r.insert("x", str(float(r.x) + shift.at(0)))
  r.insert("y", str(float(r.y) + shift.at(1)))
  r
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
  let r = r
  let c = rotp((float(r.x), float(r.y)))
  r.insert("x", str(c.at(0)))
  r.insert("y", str(c.at(1)))
  r.insert("angle", str(float(r.at("angle", default: "0")) + rot.deg()))
  r
}

// ---------- Building outline (wall centre lines, CSV coordinates): pentagon, NE corner cut along the lane ----------
#let outline-v3 = ((0, 0), (9.301, 0), (12.25, 5.427), (12.25, 23), (0, 23)).map(p => rotp(addv(p, 1, shift)))

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
  ((0.0, 21.35), (-1.0, 0.0), [Guest entry]),     // guest wing, west wall
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
#let level-marks = (((rotp(addv((8.25, 12.5), 1, shift)), rotp(addv((8.25, 18.25), 1, shift))), [ceiling height change]),)
// door: riwaq → guest wing extension, in the 1.55 m wall at x = 2.75, lockable from the family side
#let door-marks = (((rotp(addv((2.75, 16.9), 1, shift)), rotp(addv((2.75, 18.05), 1, shift))), [door to family side, lockable]),)

// air tower: polygon filling the tip of the north-east cut corner (CSV coordinates), drawn with the air list


#let tower-pts = ((8.25, 0), (9.301, 0), (9.953, 1.2), (8.25, 1.2)).map(p => rotp(addv(p, 1, shift)))

#let tower-marks = (((tower-pts.at(0), tower-pts.at(1)), [Air tower]),)

#let arrows = entries.map(((p, d, l)) => {
  let b = rotp(addv(p, 1, shift))
  (addv(b, 2.6, rotv(d)), b, l)
})

#render(
  title: [Design V3.0 · pentagon Z3 · north-east corner cut along the lane],
  subtitle: [11 Oct 2026 · Design V3.0 · base.typ + design_v3.typ + data/rooms_v3.csv],
  court: court,
  rooms: rooms.map(rotrow),
  air: air-rows.map(rotrow).map(r => (r.name, room-poly(r))) + (("Air tower", tower-pts),),
  arrows: arrows,
  marks: inner-marks + level-marks + door-marks + tower-marks,
  limit: outline-v3,
  note: [*V3.0* on site-test option Z3: a pentagon 12.25 × 23 m on wall centre lines (12.5 × 23.25 outside), its north-east corner cut parallel to the lane; both palms lie well beyond the south facade. The *air tower* (blue, a 4-sided polygon of about 2.8 m², ≈ 2 m² clear) fills the tip of the cut corner, taking no room space; the *maid bath* (2 × 2) and *maid room* (3.05 × 2.2) sit below it; maid access only kitchen → laundry → maid room → maid bath. *West band:* lift, stair (with a store under its landing), *utility room with the service shaft inside it* (shaft beside the family wash rooms), family basins (2), family WC, then the plumbing wall shared with the guest wing. *Family lobby + riwaq* runs as one straight strip from the front door to the men's majlis; one lockable door links it to the guest wing. *Women's majlis* 4 × 6 m · *courtyard* 4 × 6.5 m · *living* one open room 8 × 5.75 m: double-height half (4 × 5.75) on the courtyard, normal-height half (4 × 5.75) for dining beside the kitchen door; no upper floor over the double-height half or the courtyard · *men's majlis* 10 × 4.75 m. Blue outlines inside rooms are the shaft and the under-stair store (not extra area); blue lines mark the ceiling-height change in the living room and the guest door.],
)

// ---------- Design idea and philosophy (last page) ----------
#pagebreak()
#text(17pt, fill: accent, weight: "bold")[Design idea and philosophy]
#v(2pt)
#text(9pt, fill: gray)[Taif / Palm House · Design V3.0 · pentagon with the north-east corner cut]
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
], [
  #text(11pt, weight: "bold", fill: accent)[One band that serves the house]

  Everything that serves the house sits in one band on the west: the family entrance, the lift, the stair, the utility room with the service shaft and the family wash rooms. Pipes, cables and air rise in one place, the structure gains one stiff core, and every service can be reached for maintenance without breaking a wall. The family lobby and riwaq run along this band as one straight strip on the courtyard side, the family's covered route from the front door to the living room.

  #v(6pt)
  #text(11pt, weight: "bold", fill: accent)[Family, guests and service, each in their place]

  The family enters through the lobby; women guests use the same door to reach the women's majlis. The men's majlis has its own entrance, basins and WC in the guest wing in the south-west; its only link to the house is one door between the guest wing and the riwaq, lockable from the family side, for serving from inside the house. A solid plumbing wall separates the guest wing from the family WC. The kitchen stays isolated beside the courtyard, with its only doors to the living room and the laundry. The laundry, maid room and maid bath sit north of it on the east, in one band with one drain run; the maid wing is reached only through the kitchen.

  #v(6pt)
  #text(11pt, weight: "bold", fill: accent)[On firm ground, as far north as possible]

  The house sits on the firm, higher ground in the north of the plot, square to the M line so every wall can be set out from the site pegs, and pushed as far north as the setbacks allow. The narrow courtyard keeps the house narrow, and the north-east corner is cut parallel to the lane, so the whole house reaches further north and both palms stay well clear behind it.

  #v(6pt)
  #text(11pt, weight: "bold", fill: accent)[One living room, two heights]

  The living room is one open space with two ceiling heights. The half next to the courtyard is double height: it continues the courtyard's vertical space, gives the best view into it, and works as a chimney, with high operable windows that let warm air rise and leave while cool air is drawn in from the courtyard; its 4 m width is a simple roof span. The east half is normal height: a warmer, lower place for dining beside the kitchen door, easier to air-condition and light, with ducts hidden in its ceiling, and the first floor continues above it. No upper floor is built over the double-height half or the courtyard.

  #v(6pt)
  #text(11pt, weight: "bold", fill: accent)[Services built for life]

  The service shaft sits inside a utility room, so every service is in one place behind one door: the shaft, the main electrical panel, the water manifold with its isolation valves and the water heater. The shaft is a closed box of about 1.0 × 1.2 m clear with sealed walls and one full-height maintenance door, and the 0.9 m in front of that door is always kept clear. It stands directly beside the family wash rooms, so drainage runs stay short, and first-floor bathrooms will stack above or beside it. The space under the stair's landing becomes a store instead of dead space. The Saudi Building Code sets no fixed size for a closed pipe shaft; the sizes here follow general professional guidance and must be confirmed with the code, the municipality and the plumbing engineer.

  #v(10pt)
  #text(7pt, fill: gray)[Concept for discussion. Airflow, tunnel depth, waterproofing, drainage, structure and services need the engineers' review; wind direction to be confirmed on site.]
])

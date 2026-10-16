// design_ff.typ · Taif / Palm House · FIRST FLOOR · starting point (16 Oct 2026, on ground floor V4.0) · compile THIS file for the first floor
// Same framework as design_gf.typ: rooms go in data/rooms_ff.csv (CSV coordinates of the ground floor, same shift and rotation).
// Drawn as fixed elements from the ground floor: outline, voids (courtyard, double-height living), stair, future lift shaft, service shaft, east duct, air tower.
// Constraints: docs/FIRST_FLOOR_BRIEF.md
#import "base.typ": *
#show: setup

// ---------- Same placement as the ground floor ----------
#let shift = (0.91, 3.525)
#let rot = 0deg
#let court-csv = (6.6, 9.75)            // courtyard centre (CSV): the rotation pivot, as on the ground floor
#let pivot = addv(court-csv, 1, shift)
#let rotv(v) = (v.at(0) * calc.cos(rot) - v.at(1) * calc.sin(rot), v.at(0) * calc.sin(rot) + v.at(1) * calc.cos(rot))
#let rotp(p) = addv(pivot, 1, rotv((p.at(0) - pivot.at(0), p.at(1) - pivot.at(1))))
#let place(p) = rotp(addv(p, 1, shift))
#let rect-csv(x0, y0, x1, y1) = ((x0, y0), (x1, y0), (x1, y1), (x0, y1))

// ---------- Ground-floor outline (wall centre lines, CSV) ----------
#let outline-gf = ((0, 0), (10.051, 0), (13.311, 6.0), (13.311, 24.0), (0, 24.0)).map(place)

// ---------- Voids: no floor here (CSV) ----------
#let court = rect-csv(4.25, 6.5, 8.95, 13.0).map(place)                              // courtyard, open to the sky
#let voids = (("Void · double-height living", rect-csv(4.25, 13.0, 8.95, 19.25).map(place)),)

// ---------- Fixed vertical elements from the ground floor (CSV), drawn grey as "core" rooms ----------
#let fixed-csv = (
  ("Stair (fixed, from GF)", rect-csv(0, 2.2, 2.75, 7.9)),             // 2.75 × 5.7, arrives on the first floor; slab opening to suit
  ("Lift shaft (future, 2 stops)", rect-csv(0, 0, 2.25, 2.2)),          // ground + first only, no roof stop
  ("Service shaft (west)", rect-csv(0, 9.2, 1.5, 10.4)),
  ("East duct", rect-csv(12.711, 6.5, 13.311, 7.1)),
)
#let as-row(n, P) = {
  let xs = P.map(p => p.at(0)); let ys = P.map(p => p.at(1))
  (name: n, x: str((calc.min(..xs) + calc.max(..xs)) / 2), y: str((calc.min(..ys) + calc.max(..ys)) / 2),
   w: str(calc.max(..xs) - calc.min(..xs)), d: str(calc.max(..ys) - calc.min(..ys)), angle: "0", frame: "M", colour: "core",
   pts: P.map(place).map(p => str(p.at(0)) + " " + str(p.at(1))).join(";"))
}
#let fixed = fixed-csv.map(((n, P)) => as-row(n, P))
#let tower = ((8.95, 0), (10.051, 0), (10.594, 1.0), (8.95, 1.0)).map(place)   // air tower rises to the roof

// ---------- First-floor rooms from the CSV (none yet) ----------
#let ff-rows = csv("data/rooms_ff.csv", row-type: dictionary).filter(r => r.name != "" and not r.name.starts-with("#")).map(r => {
  let r = r
  let c = place((float(r.x), float(r.y)))
  r.insert("x", str(c.at(0)))
  r.insert("y", str(c.at(1)))
  let P = pts-of(r)
  if P.len() >= 3 { r.insert("pts", P.map(place).map(p => str(p.at(0)) + " " + str(p.at(1))).join(";")) }
  r
})

// ---------- Ground-floor wall lines that can carry first-floor walls (CSV) ----------
#let grid-lines = (
  ((2.75, 0), (2.75, 24.0), [GF line x 2.75]), ((4.25, 0), (4.25, 19.25), [x 4.25]), ((8.95, 0), (8.95, 19.25), [x 8.95]),
  ((0, 6.5), (4.25, 6.5), []), ((8.95, 6.5), (13.311, 6.5), [GF line y 6.5]),
  ((0, 13.0), (4.25, 13.0), []), ((8.95, 13.0), (13.311, 13.0), [y 13.0]),
  ((2.75, 19.25), (13.311, 19.25), [y 19.25]),
)
#let marks = grid-lines.map(((a, b, l)) => ((place(a), place(b)), l))

#render(
  title: [First floor · starting point · on ground floor V4.0],
  subtitle: [16 Oct 2026 · base.typ + design_ff.typ + data/rooms_ff.csv · constraints in docs/FIRST_FLOOR_BRIEF.md],
  court: court,
  extras: voids,
  rooms: fixed + ff-rows,
  air: (("Air tower", tower),),
  marks: marks,
  limit: outline-gf,
  note: [*First floor*, not designed yet. Drawn from the ground floor V4.0: the outline (13.311 × 24.0 m on wall centre lines), the *voids* with no floor (the courtyard, open to the sky, and the double-height living), and the *fixed vertical elements* in grey: the stair (2.75 × 5.7), the future lift shaft (two stops, ground and first), the west service shaft and the east duct; the air tower (blue) rises to the roof. Blue lines are ground-floor wall lines that can carry first-floor walls. Storey height assumption 3.6 m floor to floor. Add rooms to data/rooms_ff.csv (same CSV coordinates as the ground floor); first-floor bathrooms over or beside the west shaft (north part of the west wash block) or the east duct. #ff-rows.len() first-floor rooms so far.],
)

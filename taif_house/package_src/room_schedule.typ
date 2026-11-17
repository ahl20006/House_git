// room_schedule.typ · the delivery package · every room of both floors with its area on axes and clear (from package_src/room_schedule.csv, written by make_schedule.py)
#import "common.typ": *
#let rows = csv("room_schedule.csv", row-type: dictionary)
#let rooms(fl) = rows.filter(r => r.floor == fl and r.id != "total" and r.id != "footprint")
#let total(fl) = rows.find(r => r.floor == fl and r.id == "total").axes_m2
#let footprint = rows.find(r => r.id == "footprint").axes_m2
#let sched(fl) = table(columns: (auto, 1fr, auto, auto, auto), stroke: 0.3pt + luma(190), inset: 3.6pt, align: (left, left, right, right, right),
  fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") },
  ..([No.], [Room], [Axis size (m)], [Axes m²], [≈ Clear m²]).map(c => text(weight: "bold", fill: accent, c)),
  ..rooms(fl).map(r => ([#r.id], [#r.name], [#r.axis_size_m], [#r.axes_m2], [#r.clear_m2])).flatten(),
)
#show: setup.with([Room schedule · ground floor and first floor], [From `data/rooms_gf.csv` and `data/rooms_ff.csv` as drawn on #DATE (the presentation's sheet 08). Axes = wall centre lines; clear = inside the walls as drawn (250 mm outer walls, 200 mm inner walls, 100 mm partitions, the steel windows on the courtyard edges), furniture and thresholds not deducted. The same table as `05_room_schedule.csv`.], [design reviewer · engineering office])
#grid(columns: (1fr, 1fr), column-gutter: 12pt,
  [#H[Ground floor] #sched("GF") #v(3pt) #text(8.5pt)[*Ground-floor rooms:* #total("GF") m² on axes (the courtyard excluded). *Outside footprint:* #footprint m² including the courtyard.]],
  [#H[First floor] #sched("FF") #v(3pt) #text(8.5pt)[*First-floor rooms:* #total("FF") m² on axes (the suite court F14 excluded). Fixed cores not listed: the stair, the lift shaft (2.25 × 2.2, a placeholder until the supplier's drawing), the west shaft, the malqaf shaft.]],
)
#v(6pt)
#note[*Reading the numbers.* Every room is a polygon in the room CSVs; the plans, the DXFs, the schedule and the 3D are generated from the same files. The clear areas are concept values from the drawn wall thicknesses, not survey values. *15 Nov 2026 (the last change):* bedrooms 2 and 3 are twins, each with an entry strip and a main room of 4.03 × 3.5 m clear; their baths F04 / F06 back to back on one stack; the gym F13 without the entry strip; the gallery F01 to y 20.55.]
#ar[جدول الغرف للدورين: المساحة على محاور الجدران والمساحة الصافية داخل الجدران كما هي مرسومة (جدران خارجية 25 سم، داخلية 20 سم، قواطع 10 سم). القيم تصميمية لا مساحية. آخر تعديل 15 نوفمبر 2026: غرفتا النوم 2 و3 توأم بشريط مدخل لكلٍّ منهما وحمامان ظهرًا لظهر على ماسورة واحدة.]

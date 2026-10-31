// design_ff.typ · Taif / Palm House · FIRST FLOOR V6.3 · compile THIS file for the whole first floor
// Zoning: family part (kids' room, family living, bedrooms 1–3, family bath) on the north and west, around the courtyard; the gallery on the
// 1.55 m west projection over the courtyard and the double-height void, on an edge beam and three columns at x 5.8 (V7.0: enclosure option A; 1.35 m on x 5.6 as in V5.0 until V6.3);
// the south wing v2 (1 Nov 2026): the gym on the west band, the suite court from the gym to the office, the owner's office on the east beside the master suite.
// Rooms: data/rooms_ff.csv. Room-by-room design, furniture, doors, drains and checks: studies/ff_family.typ (part 1) and studies/ff_suite.typ (part 2);
// this file checks that the CSV and the two studies agree. Sections and the light check: studies/sections.typ. Placement: design_gf.typ.
// Pages: 1 plan in the site with checks · 2 schedules (envelope, rooms) · 3 room schedule with clear areas · 4 light check · 5 the west projection.
// The <ff-data> metadata at the end feeds tools/make_dxf_ff.py (first-floor DXF). Full description: docs/PROJECT_V6.md
#import "base.typ": *
#import "design_gf.typ": place, outline-gf
#import "studies/ff_family.typ" as fam
#import "studies/ff_suite.typ" as suite
#import "studies/sections.typ" as sec
#show: setup

#let rect-csv(x0, y0, x1, y1) = ((x0, y0), (x1, y0), (x1, y1), (x0, y1))

// ---------- Outline, voids and fixed elements (CSV) ----------
#let outline-csv = sec.ff-outline                                  // the first floor stands on the ground-floor walls
#assert(sample(outline-csv.map(place), step: 0.1).all(p => inside(p, env)), message: "ERROR: the first-floor centre line leaves the envelope.")
#let ff-env-gap = calc.min(..sample(outline-csv.map(place), step: 0.1).map(p => calc.min(..edges(env).map(e => seg-dist(p, ..e))))) - sec.outer-half
#assert(ff-env-gap >= 0, message: "ERROR: the first-floor outer wall face crosses the envelope.")
#let ff-m-gap = calc.min(..outline-csv.map(place).map(p => p.at(0))) - sec.outer-half
#let court-sky = rect-csv(sec.pj-edge, sec.y-court, sec.x-east, 13.0)       // courtyard, open to the sky (its west 1.35 m is under the projection)
#let living-void = rect-csv(sec.pj-edge, 13.0, sec.x-east, sec.y-living)    // double-height living, no floor
#let fixed-csv = fam.fixed.filter(f => f.name != "Air tower").map(f => (f.name, f.pts))
#let tower-csv = fam.fixed.find(f => f.name == "Air tower").pts           // the air tower rises to the roof
#let as-row(n, P, colour) = {
  let xs = P.map(p => p.at(0)); let ys = P.map(p => p.at(1))
  (name: n, x: str((calc.min(..xs) + calc.max(..xs)) / 2), y: str((calc.min(..ys) + calc.max(..ys)) / 2),
   w: str(calc.round(calc.max(..xs) - calc.min(..xs), digits: 3)), d: str(calc.round(calc.max(..ys) - calc.min(..ys), digits: 3)),
   angle: "0", frame: "M", colour: colour, pts: P.map(place).map(p => str(p.at(0)) + " " + str(p.at(1))).join(";"))
}
#let fixed = fixed-csv.map(((n, P)) => as-row(n, P, "core"))

// ---------- First-floor rooms (data/rooms_ff.csv; # at the start of a name switches a row off) ----------
#let open-kinds = ("terrace", "open")
#let ff-csv = csv("data/rooms_ff.csv", row-type: dictionary).filter(r => r.name != "" and not r.name.starts-with("#")).map(r => (name: r.name, colour: r.colour, P: sec.parse-pts(r.pts)))
#let ff-rooms = ff-csv.filter(r => r.colour not in open-kinds)
#let ff-open = ff-csv.filter(r => r.colour in open-kinds)

// ---------- The CSV against the two studies: every CSV room must be a study room (same corners), and nothing missing ----------
#let study-rooms = fam.rooms.map(r => (r, fam)) + suite.rooms.map(r => (r, suite))
#let same-poly(P, Q) = P.len() == Q.len() and P.all(p => Q.any(q => calc.abs(p.at(0) - q.at(0)) < 0.002 and calc.abs(p.at(1) - q.at(1)) < 0.002))
#let match(r) = study-rooms.find(((s, m)) => same-poly(r.P, s.pts))
#let sync-issues = ff-csv.filter(r => match(r) == none).map(r => r.name + ": not in the studies") + study-rooms.filter(((s, m)) => not ff-csv.any(r => same-poly(r.P, s.pts))).map(((s, m)) => s.name + ": in a study but not in data/rooms_ff.csv")
#let clear-of(r) = { let hit = match(r); if hit == none { none } else { let (s, m) = hit; (m.clear-approx)(s.pts) } }

// ---------- Areas ----------
#let available = area(outline-csv) - area(court-sky) - area(living-void) - fixed-csv.map(((n, P)) => area(P)).sum() - area(tower-csv)
#let used-in = ff-rooms.map(r => area(r.P)).sum(default: 0)
#let used-out = ff-open.map(r => area(r.P)).sum(default: 0)
#let circulation = ff-rooms.filter(r => r.colour == "circ").map(r => area(r.P)).sum(default: 0)
#let is-rect(P) = P.len() == 4 and calc.abs(P.at(0).at(1) - P.at(1).at(1)) < 1e-6 and calc.abs(P.at(1).at(0) - P.at(2).at(0)) < 1e-6
#let size-of(P) = if is-rect(P) { num(calc.abs(P.at(1).at(0) - P.at(0).at(0))) + " × " + num(calc.abs(P.at(2).at(1) - P.at(1).at(1))) } else { "polygon" }
#let suite-names = ("Suite lobby", "Suite bath", "Suite WC (closet)", "Suite dressing", "Suite bedroom")
#let suite-area = ff-csv.filter(r => r.name in suite-names).map(r => area(r.P)).sum()
#let all-doors = fam.doors + suite.doors
// fire safety (owner, 1 Nov 2026; studies/fire_escape.typ): interconnected mains smoke alarms (S) in every bedroom, outside the sleeping areas and at the stair top; one extinguisher at the stair top (E)
#let safety = (((11.0, 3.5), [S · bed 1]), ((2.0, 12.7), [S · bed 2]), ((2.0, 17.5), [S · bed 3]), ((6.5, 1.5), [S · kids]), ((11.0, 15.6), [S · suite]), ((9.5, 9.0), [S · suite lobby]), ((4.8, 11.0), [S · gallery]), ((3.4, 5.0), [S · gallery N]), ((6.5, 4.75), [S · family living]), ((1.3, 8.5), [S · landing]), ((2.9, 8.9), [E · stair]))
#let safety-marks = safety.map(((p, l)) => ((place(p), place((p.at(0) + 0.3, p.at(1)))), l))
#let r3(v) = str(calc.round(v, digits: 3))

// ---------- PAGE 1: plan in the site, with the framework checks ----------
#render(
  title: [First floor V7.1 · family part + the L (office, gym, suite court, master suite)],
  subtitle: [Taif / Palm House V7.1 · rooms in data/rooms_ff.csv · design and furniture in studies/ff_family.typ and studies/ff_suite.typ · schedule, light check and the split projection on the next pages],
  court: court-sky.map(place),
  extras: (("Void · double-height living", living-void.map(place)),) + ff-open.map(r => (r.name, r.P.map(place))),
  rooms: fixed + ff-rooms.map(r => as-row(r.name, r.P, r.colour)),
  air: (("Air tower", tower-csv.map(place)),),
  marks: all-doors.map(d => ((place(d.a), place(d.b)), [])) + sec.clerestory.map(((a, b)) => ((place(a), place(b)), [])) + safety-marks,
  limit: outline-csv.map(place),
  note: [*First floor V7.1.* The gallery runs on a *#num(sec.pj.depth) m west projection* along the courtyard and the double-height void (x #num(sec.x-court)–#num(sec.pj-edge), y #num(sec.y-court)–#num(sec.y-living)), on an *edge beam and #sec.pj.columns columns* at x #num(sec.pj-edge), each in an existing wall or glass line; the first-floor west wall stands on the GF west wall (#r3(ff-m-gap) m from the M line). Courtyard sky and void #r3(sec.pj.sky) m on axes. West rooms #num(sec.pj.room) m and gallery #num(sec.pj.gallery) m on axes: *bedroom 2*, *bedroom 3 with its own bath*, the *family bath* by the west shaft. North band: *kids' room (study + gaming)* and the *family living* on the courtyard edge. *Bedroom 1* is one room on the straight y 6.5 line. The *south wing v2* (1 Nov 2026): the *gym* on the west band (the treadmill with its 2.0 / 0.5 m zone, an acoustic double wall to bedroom 3, an entrance nib at the gallery end), the *suite court* from the gym to the office (≈ 25 m², open to the sky, the three court doors on a 1.2 m strip along its north edge) in front of the clerestory windows, the *owner's office* on the east beside the suite (no door to the bedroom; from the court, and for visitors from the external stair tower), and the *master suite* (lobby, luxury bath with WC closet, walk-in dressing, bedroom). No east duct. Stair, lift, landing and west shaft rise from the ground floor. Colours: suite (beige) · family (yellow) · baths, office and linen (blue-grey) · gym (blue) · circulation (light) · fixed (grey) · courtyard, void and court (white / blue). Blue marks: doors and the clerestory windows. Areas: available #num(available) m² · rooms #num(used-in) m² (circulation #num(circulation) m²) · suite court #num(used-out) m².
    #linebreak()
    #if sync-issues.len() == 0 [*✓ data/rooms_ff.csv matches the two studies room for room.*] else [#text(fill: warn)[*CSV and studies differ:* #sync-issues.join("; ")]]],
)

// ---------- PAGE 3: room schedule ----------
#pagebreak()
#text(15pt, fill: accent, weight: "bold")[First floor V6.3 · room schedule]
#h(8pt) #text(8pt, fill: gray)[wall centre lines (axes) · clear ≈ axes minus half a wall on every edge (from the studies) · CSV coordinates]
#v(4pt)
#let part-of(n) = if n in suite-names or n in ("Gym route", "Owner's office", "Gym", "Suite court (open to the sky)") { [L] } else { [family] }
#grid(columns: (1.35fr, 1fr), column-gutter: 16pt, [
  #set text(7.4pt)
  #table(columns: (auto, auto, auto, auto, auto), stroke: none, inset: 2.6pt, fill: (_, y) => if calc.even(y) { rgb("#efece4") },
    [*Room*], [*Part*], [*Axes w × d (m)*], [*Axes m²*], [*≈ clear m²*],
    ..ff-csv.map(r => ([#r.name], part-of(r.name), [#size-of(r.P)], [#num(area(r.P))], [#if r.colour in open-kinds or r.name.starts-with("Linen") or r.name.starts-with("Wardrobe") [–] else { let c = clear-of(r); if c == none [?] else [#num(c)] }])).flatten(),
    [*Rooms (indoor)*], [], [], [*#num(used-in)*], [],
    [*Suite court (open)*], [], [], [*#num(used-out)*], [],
    [Stair, lift, west shaft, air tower], [], [], [#num(fixed-csv.map(((n, P)) => area(P)).sum() + area(tower-csv))], [],
  )
], [
  #set text(7.6pt)
  #text(10pt, weight: "bold", fill: accent)[Key numbers]
  - *Master suite:* #num(suite-area) m² indoors (lobby, bath + WC closet, dressing, bedroom), + the suite court #num(used-out) m².
  - *Circulation:* #num(circulation) m² (landing, gallery, family link, suite lobby).
  - *Courtyard sky* #r3(sec.pj.sky) × #num(13.0 - sec.y-court) m and *double-height void* #r3(sec.pj.sky) × #num(sec.y-living - 13.0) m on axes; the ground-floor courtyard and living keep their full floor.
  - *West rooms:* #num(sec.pj.room) m on axes (≈ #r3(sec.pj.room-clear) m clear); *gallery* #num(sec.pj.gallery) m (≈ #r3(sec.pj.gallery-clear) m clear); *family bath* #num(sec.pj.bath-w) m wide.
  - *Edge beam* on x #num(sec.pj-edge) (spans #sec.pj.spans.map(num).join(" and ") m) on #sec.pj.columns columns; the FF west wall on the GF west wall, #r3(ff-m-gap) m from the M line.
  #v(4pt)
  #text(10pt, weight: "bold", fill: accent)[Where the detail is]
  - *Furniture, doors, windows, drains, walking distances, routes ≥ 1.0 m and room checks:* studies/ff_family.typ (part 1) and studies/ff_suite.typ (part 2).
  - *Decisions with reasons, construction notes, changelog:* docs/PROJECT_V6.md · *open items:* docs/OPEN_ITEMS.md.
  #v(4pt)
  #text(10pt, weight: "bold", fill: accent)[Open items (first floor)]
  - Engineer: the edge beam (spans #sec.pj.spans.map(num).join(" and ") m) and the #sec.pj.columns columns at x #num(sec.pj-edge): sizes and foundations.
  - Engineer: loads and vibration of the gym and the office over the men's majlis; the y 3.0 partition over the women's majlis.
  - MEP: the stack outside the east wall (suite bath, vent stack), the kitchen extract through the east wall, the hood south of y ≈ 7.5.
  - The clerestory sill against the suite court floor (eye height, or obscured glass); a daylight check of the courtyard.
])

// ---------- PAGE 4: light check of the clerestory windows behind the suite court ----------
#pagebreak()
#text(15pt, fill: accent, weight: "bold")[First floor V7.1 · light check · the double-height living's south windows]
#h(8pt) #text(8pt, fill: gray)[section north → south through the middle band (CSV x ≈ 7.3) · levels to confirm: GF ±0.00 · FF +#sec.f2(sec.ff-level) · roof +#sec.f2(sec.roof-level) · parapets #num(sec.parapet)]
#v(3pt)
#sec.ns-section(length: 0.6cm, ink: ink, warn: warn)
#v(2pt)
#set text(7.5pt)
#grid(columns: (1.15fr, 1fr), column-gutter: 16pt, [
  #sec.light-table()
  #text(6.3pt, fill: gray, sec.light-note)
], [
  - *The main light of the double-height living comes from the courtyard.* The #sec.clerestory.len() small south windows add light and let warm air out high on the south.
  - *The #num(sec.strip) m in front of them is the suite court*, walled on four sides and open to the sky; the gym's north wall is its south side, ending in a *railing, not a parapet*.
  - *Privacy:* the windows open onto the suite court, so their sill stays above eye level from the court floor (or obscured glass); to check against the floor levels.
  - *Summer:* the sun is almost overhead; light-coloured court walls and small hoods over the windows.
])

// ---------- PAGE 5: the west projection · the two east–west sections · against the reverted split projection ----------
#pagebreak()
#text(15pt, fill: accent, weight: "bold")[First floor V7.1 · the west projection on three columns]
#h(8pt) #text(8pt, fill: gray)[sections looking north, CSV x · the column on x #num(sec.pj-edge) is beyond the cut (columns at y #sec.columns.map(c => num(c.at(1))).join(", "))]
#v(3pt)
#grid(columns: (1fr, 1fr), column-gutter: 10pt,
  [#text(8pt, weight: "bold")[A–A · through the courtyard (y 12.0)] #sec.section("court", length: 0.62cm)],
  [#text(8pt, weight: "bold")[B–B · through the double-height living (y 16.5)] #sec.section("living", length: 0.62cm)],
)
#v(2pt)
#grid(columns: (1.25fr, 1fr), column-gutter: 16pt, [
  #sec.compare-table(size: 7pt)
  #text(6pt, fill: gray)[V6.3 read from data/rooms_ff.csv; the split projection (V5.1–V6.0) from tag v6.0. Clear ≈ axes − ½ wall each side (250 outer, 200 inner, ≈ 50 mm for the steel window W1 on the void edge, V6.4); sky opening clear = axes − ½ of the east wall − the slab edge with its upstand.]
], [
  #set text(7.2pt)
  - *Projection:* #num(sec.pj.depth) m over the courtyard and the double-height void; the west rooms (#num(sec.pj.room) m) and the gallery (#num(sec.pj.gallery) m) take the band over the GF west band and riwaq.
  - *Structure:* an edge beam on x #num(sec.pj-edge) (spans #sec.pj.spans.map(num).join(" and ") m) on #sec.pj.columns columns, each in an existing wall or glass line: the women's majlis south wall, the courtyard / living glass, the living's south wall. On the ground floor it reads as a colonnade along the courtyard. Walls stand on walls; nothing hangs on cantilever beams.
  - *V6.1:* the split projection of V5.1–V6.0 (#num(sec.split.inward) m in + #num(sec.split.outward) m out, the west wall on cantilever beams #num(sec.split.m-gap) m from the M line) is reverted: a wall on cantilever beams along ≈ #num(sec.split.cant-wall) m costs more and is less direct than walls on walls, and the M-line projection needed municipal approval.
  - *Cost of the revert:* courtyard sky #r3(sec.split.sky) → #r3(sec.pj.sky) m; #sec.pj.columns columns on the courtyard edge.
])

// ---------- Data for tools/make_dxf_ff.py (typst eval --in design_ff.typ "query(<ff-data>).first().value") ----------
#let plain(c) = if type(c) == str { c } else if c.has("text") { c.text } else if c.has("children") { c.children.map(plain).join("", default: "") } else if c.has("body") { plain(c.body) } else { " " }
#let ids = ff-csv.enumerate().map(((i, r)) => (r.name, "F" + (if i < 9 { "0" } else { "" }) + str(i + 1)))
#metadata((
  outline: outline-csv.map(place), gf-outline: outline-gf,
  rooms: ff-csv.map(r => (name: r.name, id: ids.find(((n, i)) => n == r.name).at(1), colour: r.colour, pts: r.P.map(place), area: area(r.P))),
  fixed: fixed-csv.map(((n, P)) => (name: n, pts: P.map(place))) + ((name: "Air tower", pts: tower-csv.map(place)),),
  voids: (("Courtyard (open to the sky)", court-sky), ("Double-height living (void)", living-void)).map(((n, P)) => (name: n, pts: P.map(place))),
  doors: all-doors.map(d => (a: place(d.a), b: place(d.b), label: plain(d.label), open: d.open)),
  windows: (fam.windows + suite.windows).map(((a, b)) => (place(a), place(b))),
  furniture: (fam.furniture + suite.furniture).map(f => (a: place((f.at(0), f.at(1))), b: place((f.at(2), f.at(3))), label: plain(f.at(4)))),
  marks: ((sec.pj-edge, sec.y-court), (sec.pj-edge, sec.y-living)).map(place), columns: sec.columns.map(place),
  m-gap: ff-m-gap,
)) <ff-data>

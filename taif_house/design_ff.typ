// design_ff.typ · Taif / Palm House · FIRST FLOOR V5.1 · split projection (24 Oct 2026, on ground floor V5.1) · compile THIS file for the whole first floor
// V5.1: the V5.0 1.35 m west projection is split, 0.675 m inward over the courtyard / void (plain cantilever, no columns) and 0.675 m outward
// beyond the GF west wall (the FF west wall on cantilever beams, y 10.4–24); the whole west band moves 0.675 m west. Study record: docs/VARIANT_SP.md
// Zoning: family part (kids' room, family living, bedrooms 1–3, family bath) on the north and west, around the courtyard; the gallery on a
// 1.35 m west projection over the courtyard and the double-height void; the L to the south and east: owner's office → gym route → gym →
// suite court → master suite. Rooms: data/rooms_ff.csv. Room-by-room design, furniture, doors, drains and checks:
// studies/ff_family.typ (part 1) and studies/ff_suite.typ (part 2). This file checks that the CSV and the two studies agree.
// Pages: 1 plan in the site with checks · 2 schedules (envelope, rooms) · 3 room schedule with clear areas · 4 light check of the clerestory windows
// · 5 V5.1 against V5.0 (record of the split-projection decision): comparison and the east–west sections through the courtyard and the double-height living (studies/sp_compare.typ)
// Brief: docs/FIRST_FLOOR_BRIEF.md (V5.1 section) · construction notes: docs/DETAILS.md
#import "base.typ": *
#import "@preview/cetz:0.4.2"
#import "studies/ff_family.typ" as fam
#import "studies/ff_suite.typ" as suite
#import "studies/sp_compare.typ" as sp
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
#let parse-pts(s) = s.split(";").map(t => t.trim()).filter(t => t != "").map(t => { let v = t.split(" ").filter(u => u != ""); (float(v.at(0)), float(v.at(1))) })

// ---------- Outline, voids and fixed elements (CSV) ----------
#let outline-csv = ((0, 0), (10.051, 0), (13.311, 6.0), (13.311, 24.0), (-0.675, 24.0), (-0.675, 10.4), (0, 10.4))   // V5.1: west face 0.675 m out from y 10.4
#let gf-outline-csv = ((0, 0), (10.051, 0), (13.311, 6.0), (13.311, 24.0), (0, 24.0))
#let proj-in = 4.925     // inward cantilever edge (V5.0: 5.6 on an edge beam and three columns)
#let proj-out = -0.675   // FF west wall (V5.0: 0, on the GF west wall)
// the FF outer wall face inside the envelope, and its gap to the M line
#assert(sample(outline-csv.map(place), step: 0.1).all(p => inside(p, env)), message: "ERROR: the first-floor centre line leaves the envelope.")
#let ff-env-gap = calc.min(..sample(outline-csv.map(place), step: 0.1).map(p => calc.min(..edges(env).map(e => seg-dist(p, ..e))))) - 0.125
#assert(ff-env-gap >= 0, message: "ERROR: the first-floor outer wall face crosses the envelope.")
#let ff-m-gap = calc.min(..outline-csv.map(place).map(p => p.at(0))) - 0.125
#let court-sky = rect-csv(proj-in, 6.5, 8.95, 13.0)      // courtyard, open to the sky (the west 0.675 m is under the inward cantilever)
#let living-void = rect-csv(proj-in, 13.0, 8.95, 19.25)  // double-height living, no floor
#let fixed-csv = (
  ("Stair (arrives at its south end)", rect-csv(0, 2.2, 2.75, 7.9)),
  ("Lift shaft (future, 2 stops)", rect-csv(0, 0, 2.25, 2.2)),
  ("Service shaft (west)", rect-csv(0, 9.2, 1.5, 10.4)),
)
#let tower-csv = ((8.95, 0), (10.051, 0), (10.594, 1.0), (8.95, 1.0))   // air tower rises to the roof
#let as-row(n, P, colour) = {
  let xs = P.map(p => p.at(0)); let ys = P.map(p => p.at(1))
  (name: n, x: str((calc.min(..xs) + calc.max(..xs)) / 2), y: str((calc.min(..ys) + calc.max(..ys)) / 2),
   w: str(calc.round(calc.max(..xs) - calc.min(..xs), digits: 3)), d: str(calc.round(calc.max(..ys) - calc.min(..ys), digits: 3)),
   angle: "0", frame: "M", colour: colour, pts: P.map(place).map(p => str(p.at(0)) + " " + str(p.at(1))).join(";"))
}
#let fixed = fixed-csv.map(((n, P)) => as-row(n, P, "core"))

// ---------- First-floor rooms (data/rooms_ff.csv) ----------
#let open-kinds = ("terrace", "open")
#let ff-csv = csv("data/rooms_ff.csv", row-type: dictionary).filter(r => r.name != "" and not r.name.starts-with("#")).map(r => (name: r.name, colour: r.colour, P: parse-pts(r.pts)))
#let ff-rooms = ff-csv.filter(r => r.colour not in open-kinds)
#let ff-open = ff-csv.filter(r => r.colour in open-kinds)
#let room(n) = ff-csv.find(r => r.name == n)

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

// ---------- Doors (from the two studies) and the two clerestory windows ----------
#let all-doors = fam.doors + suite.doors
#let clerestory = (((6.0, 19.25), (7.0, 19.25)), ((7.6, 19.25), (8.6, 19.25)))
#let cl-sill = 5.0
#let cl-head = 6.0

// ---------- PAGE 1: plan in the site, with the framework checks ----------
#render(
  title: [First floor V5.1 · split projection (0.675 m in + 0.675 m out)],
  subtitle: [24 Oct 2026 · on ground floor V5.1 · rooms in data/rooms_ff.csv · design and furniture in studies/ff_family.typ and studies/ff_suite.typ · schedule and light check on the next pages],
  court: court-sky.map(place),
  extras: (("Void · double-height living", living-void.map(place)),) + ff-open.map(r => (r.name, r.P.map(place))),
  rooms: fixed + ff-rooms.map(r => as-row(r.name, r.P, r.colour)),
  air: (("Air tower", tower-csv.map(place)),),
  marks: all-doors.map(d => ((place(d.a), place(d.b)), [])) + clerestory.map(((a, b)) => ((place(a), place(b)), [])),
  limit: outline-csv.map(place),
  note: [*First floor V5.1 (split projection).* The V5.0 1.35 m projection is split: *0.675 m inward* over the courtyard and the double-height void (x 4.25–4.925, a plain cantilever, *no columns*) and *0.675 m outward* beyond the GF west wall (y 10.4–24, the west wall on cantilever beams); the whole west band moves 0.675 m west. FF west wall face *#num(ff-m-gap) m from the M line* (GF 0.785 m); courtyard sky and void *#str(calc.round(8.95 - proj-in, digits: 3)) m* on axes (V5.0 3.35). The gallery (1.35 m) and the west rooms (4.25 m) keep their width: *bedroom 2*, *bedroom 3 with its own bath*; the *family bath* narrows to 2.075 m (the shaft is fixed). North band: *kids' room (study + gaming)* and the *family living* on the courtyard edge. *Bedroom 1* is one room on the straight y 6.5 line. The *L*: *owner's office* (west), *gym route*, *gym*, the *suite court* open to the sky in front of the clerestory windows, and the *master suite* (lobby, luxury bath with WC closet, walk-in dressing, bedroom). The east duct is removed. Stair, lift, landing and west shaft stay; the west face steps out at y 10.4. Colours: suite (beige) · family (yellow) · baths, office and linen (blue-grey) · gym (blue) · circulation (light) · fixed (grey) · courtyard, void and court (white / blue). Blue marks: doors and the two clerestory windows. Areas: available #num(available) m² · rooms #num(used-in) m² (circulation #num(circulation) m²) · suite court #num(used-out) m².
    #linebreak()
    #if sync-issues.len() == 0 [*✓ data/rooms_ff.csv matches the two studies room for room.*] else [#text(fill: warn)[*CSV and studies differ:* #sync-issues.join("; ")]]],
)

// ---------- PAGE 2: room schedule ----------
#pagebreak()
#text(15pt, fill: accent, weight: "bold")[First floor V5.1 · room schedule]
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
  - *Circulation:* #num(circulation) m² (landing, gallery incl. the projection, family link, gym route, suite lobby).
  - *Courtyard sky* #str(calc.round(8.95 - proj-in, digits: 3)) × 6.5 m and *double-height void* #str(calc.round(8.95 - proj-in, digits: 3)) × 6.25 m on axes (V5.0 3.35, GF 4.70); the ground-floor courtyard and living keep their full floor.
  - *Bedrooms 2 and 3:* 4.25 m wide on axes (≈ 4.0 m clear), 0.675 m further west. *Family bath* 2.075 m wide (V5.0 2.75): the shaft is fixed.
  - *FF west wall* #num(ff-m-gap) m from the M line; on cantilever beams y 10.4–24.
  #v(4pt)
  #text(10pt, weight: "bold", fill: accent)[Where the detail is]
  - *Furniture, doors, windows, drains, walking distances, routes ≥ 1.0 m and room checks:* studies/ff_family.typ (part 1) and studies/ff_suite.typ (part 2).
  - *Construction notes* (projection, columns, east duct, sunken baths, suite court, cupboards, loads): docs/DETAILS.md.
  - *Decisions and open items:* docs/FIRST_FLOOR_BRIEF.md (V5.1) and docs/notes.md (Changes in V5.1).
  #v(4pt)
  #text(10pt, weight: "bold", fill: accent)[Open items]
  - *TOP OPEN ITEM, before construction drawings:* municipality / engineering office to confirm that an upper-floor projection #num(ff-m-gap) m from the M line is allowed. If not, go back to the V5.0 solution (full 1.35 m inward projection on three columns at x 5.6, tag v5.0).
  - Engineer: the FF west wall on cantilever beams (0.675 m, y 10.4–24: beam depth, wall load, deflection); the inward 0.675 m cantilever with no columns; loads and vibration of the gym and walls over the men's majlis, the y 3.0 partition over the women's majlis.
  - MEP: the stack outside the east wall (suite bath, vent stack), the kitchen extract through the east wall, the hood position south of y ≈ 7.5.
  - The clerestory sill vs the suite court floor (eye height, or obscured glass); a daylight check of the narrower courtyard.
])

// ---------- PAGE 3: light check of the clerestory windows behind the suite court ----------
#pagebreak()
#text(15pt, fill: accent, weight: "bold")[First floor V5.1 · light check · the double-height living's south windows]
#h(8pt) #text(8pt, fill: gray)[section north → south through the middle band (CSV x ≈ 7.3) · levels to confirm: GF ±0.00 · FF +3.60 · roof +7.20 · parapets 1.10 · a full daylight simulation comes later]
#v(3pt)
#let tn(deg) = calc.tan(deg * 1deg)
#let w-alt = 90 - 21.4 - 23.44     // winter solstice noon, from the south
#let e-alt = 90 - 21.4             // equinox noon
#let s-alt = 90 - 21.4 + 23.44     // summer solstice noon (> 90: slightly to the NORTH)
#let eye = (16.1, 1.2)             // seated eye in the middle of the double-height living (y, h)
#let ang(p, q) = calc.atan((q.at(1) - p.at(1)) / (q.at(0) - p.at(0))).deg()
#let strip = 2.0
#let sun-share(top, deg) = calc.clamp((cl-head - (top - strip * tn(deg))) / (cl-head - cl-sill), 0, 1)
#let sky-share(top) = {
  let a-sill = ang(eye, (19.25, cl-sill)); let a-head = ang(eye, (19.25, cl-head)); let a-obs = ang(eye, (19.25 + strip, top))
  calc.clamp((a-head - calc.max(a-sill, a-obs)) / (a-head - a-sill), 0, 1)
}
#let cases = (
  (label: [gym with a 1.10 m parapet (top +8.30)], top: 8.3),
  (label: [gym with a railing only (solid top +7.20) · *V5.1*], top: 7.2),
)
#cetz.canvas(length: 0.6cm, {
  import cetz.draw: *
  let S(y, h) = (y, h)
  line(S(-1.5, 0), S(30, 0), stroke: 1pt + ink)
  rect(S(0, 0), S(6.5, 3.6), fill: rgb("#f6e3c0"), stroke: 0.6pt + ink)
  content(S(3.25, 1.8), text(6pt)[Women's majlis (GF)])
  rect(S(0, 3.6), S(6.5, 7.2), fill: rgb("#fbf2e2"), stroke: 0.6pt + ink)
  content(S(3.25, 5.4), text(6pt)[Kids' room / family living (FF)])
  line(S(0, 7.2), S(0, 8.3), stroke: 0.6pt + ink); line(S(6.5, 7.2), S(6.5, 8.3), stroke: 0.6pt + ink)
  content(S(9.75, 1.5), text(6pt, fill: rgb("#2f5f8a"))[COURTYARD · open to the sky])
  rect(S(13, 0), S(19.25, 7.2), fill: rgb("#fbf2e2"), stroke: 0.6pt + ink)
  line(S(13, 0.9), S(13, 6.6), stroke: 3pt + rgb("#7fb8d0"))
  content(S(13.3, 0.6), anchor: "west", text(5.3pt, fill: rgb("#2f5f8a"))[main light: courtyard glazing])
  content(S(16.1, 4.4), text(6pt)[Living (double height)])
  line(S(13, 7.2), S(13, 8.3), stroke: 0.6pt + ink); line(S(19.25, 7.2), S(19.25, 8.3), stroke: 0.6pt + ink)
  line(S(19.25, cl-sill), S(19.25, cl-head), stroke: 3pt + rgb("#1f7a99"))
  content(S(19.1, 6.6), anchor: "east", text(5.3pt, fill: rgb("#1f7a99"))[2 windows 1.0 × 1.0 · sill +5.00 · head +6.00])
  rect(S(19.25, 0), S(24, 3.6), fill: rgb("#e9d9c4"), stroke: 0.6pt + ink)
  content(S(21.6, 1.8), text(6pt)[Men's majlis (GF)])
  line(S(19.25, 3.6), S(21.25, 3.6), stroke: 2pt + rgb("#e0c060"))
  content(S(20.25, 3.95), text(5pt)[suite court 2.0 m])
  rect(S(21.25, 3.6), S(24, 7.2), fill: rgb("#cfe3f3"), stroke: 0.6pt + ink)
  content(S(22.6, 5.4), text(6pt)[Gym (FF)])
  line(S(21.25, 7.2), S(21.25, 8.3), stroke: (paint: warn, thickness: 0.8pt, dash: "dotted")); line(S(24, 7.2), S(24, 8.3), stroke: (paint: warn, thickness: 0.8pt, dash: "dotted"))
  content(S(22.6, 8.6), text(5pt, fill: warn)[railing (not a parapet)])
  circle(S(..eye), radius: 0.12, fill: ink)
  content(S(eye.at(0), eye.at(1) - 0.4), text(5pt)[eye +1.20])
  for h in (cl-sill, cl-head) { line(S(..eye), S(eye.at(0) + (19.25 - eye.at(0)) * 2.0, eye.at(1) + (h - eye.at(1)) * 2.0), stroke: (paint: luma(150), thickness: 0.5pt, dash: "dotted")) }
  let ray(y0, h0, deg, len, col, dash) = line(S(y0, h0), S(y0 + len * calc.cos(deg * 1deg), h0 + len * calc.sin(deg * 1deg)), stroke: (paint: col, thickness: 0.9pt, dash: dash))
  ray(19.25, cl-sill, w-alt, 6, rgb("#d08a00"), "solid"); ray(19.25, cl-head, w-alt, 6, rgb("#d08a00"), "solid")
  content(S(25.6, 11.0), text(6pt, fill: rgb("#d08a00"))[winter noon #calc.round(w-alt, digits: 1)°])
  ray(19.25, cl-sill, e-alt, 6, rgb("#c25b00"), "dashed")
  content(S(20.6, 11.4), text(6pt, fill: rgb("#c25b00"))[equinox #calc.round(e-alt, digits: 1)°])
  line(S(9.75, 0.2), S(9.45, 9.5), stroke: (paint: rgb("#e0b000"), thickness: 0.9pt))
  content(S(9.5, 9.9), text(6pt, fill: rgb("#b08a00"))[summer noon: almost overhead (#calc.round(180 - s-alt, digits: 1)° from the north)])
  for (h, l) in ((0, [±0.00 GF]), (3.6, [+3.60 FF]), (7.2, [+7.20 roof])) {
    line(S(-1.2, h), S(-0.2, h), stroke: 0.5pt + gray)
    content(S(-1.3, h), anchor: "east", text(5.5pt, fill: gray, l))
  }
  content(S(0, -0.6), anchor: "north-west", text(6pt)[N])
  content(S(24, -0.6), anchor: "north-east", text(6pt)[S])
})
#v(2pt)
#set text(7.5pt)
#grid(columns: (1.15fr, 1fr), column-gutter: 16pt, [
  #table(columns: (auto, auto, auto, auto), stroke: none, inset: 3pt, fill: (_, y) => if calc.even(y) { rgb("#efece4") },
    [*Behind the 2.0 m suite court*], [*Winter noon sun on the windows*], [*Equinox noon sun*], [*Sky seen through the windows from the eye*],
    ..cases.map(c => ([#c.label], [#calc.round(sun-share(c.top, w-alt) * 100) %], [#calc.round(sun-share(c.top, e-alt) * 100) %], [#calc.round(sky-share(c.top) * 100) %])).flatten(),
  )
  #text(6.3pt, fill: gray)[*How the percentages are defined.* "Sun on the windows": the share of the window height (sill +5.00 to head +6.00) that receives direct sun at solar noon on 21 Dec (winter) or 21 Mar / 23 Sep (equinox), in this section; the ray from each point of the window must pass over the top of the gym's north wall 2.0 m away. "Sky seen": from a seated eye 1.20 m high in the middle of the double-height living floor (CSV y 16.1), the share of the vertical angle of the windows that shows sky rather than the gym. Pure geometry: no reflections, no sky model.]
], [
  - *The main light of the double-height living comes from the courtyard.* The two small south windows (1.0 × 1.0 m, sill +5.00) add light and let warm air out high on the south.
  - *V5.0:* the 2.0 m strip in front of them is now the *suite court*, walled on four sides and open to the sky; the gym's north wall is its south side, ending in a *railing, not a parapet*.
  - *Privacy:* the windows open onto the suite court, so their sill stays above eye level from the court floor (or obscured glass); to check against the floor levels.
  - *Summer:* the sun is almost overhead; light-coloured court walls and small hoods (≈ 0.4 m) over the windows.
])

// ---------- PAGE 5: V5.1 against V5.0 (record of the decision) · the two east–west sections ----------
#pagebreak()
#text(15pt, fill: accent, weight: "bold")[V5.1 · split projection · against V5.0 (record of the decision)]
#h(8pt) #text(8pt, fill: gray)[sections looking north, CSV x · levels to confirm: GF ±0.00 · FF +3.60 · roof +7.20 · grey dashed = V5.0 (FF west wall on x 0, gallery edge beam and column on x 5.6)]
#v(3pt)
#grid(columns: (1fr, 1fr), column-gutter: 10pt,
  [#text(8pt, weight: "bold")[A–A · through the courtyard (y 12.0)] #sp.section("court", length: 0.62cm)],
  [#text(8pt, weight: "bold")[B–B · through the double-height living (y 16.5)] #sp.section("living", length: 0.62cm)],
)
#v(2pt)
#grid(columns: (1.25fr, 1fr), column-gutter: 16pt, [
  #sp.compare-table(size: 7pt)
  #text(6pt, fill: gray)[V5.0 from git tag v5.0; variant from data/rooms_ff.csv (live). Clear ≈ axes − ½ wall each side (250 outer, 200 inner, ≈ 50 mm railing on the void edge); sky opening clear = axes − 0.10 east wall − 0.10 slab edge with railing.]
], [
  #set text(7.2pt)
  - *Split:* band 4.25 + 1.35 = 5.6 m kept. Rooms ≥ 4.0 m clear needs ≥ 4.225 m on axes, gallery ≥ 1.0 m clear ≥ 1.125 m: both hold for any split. The site caps the outward part at 0.785 m (GF face to the M line); the *even split 0.675 / 0.675* leaves #num(sp.sp.m-gap) m.
  - *Structure:* the inward 0.675 m cantilever (back span 1.5 m to x 2.75) carries only the gallery and its railing: *no columns needed* (to confirm); the three V5.0 columns at x 5.6 are removed from both floors. The FF west wall (y 10.4–24) stands on *cantilever beams* 0.675 m beyond the GF west wall: engineer to size beam depth, wall load and deflection.
  - *Climate:* the outward projection shades the top of the GF west wall from the afternoon sun (≈ 0.675 × tan of the sun's profile angle: 0.7 m at 45°, 1.2 m at 60°) and roofs the guest entrance.
  - *Top open item:* FF west face #num(sp.sp.m-gap) m from the M line: municipality / engineering office to confirm an upper-floor projection this close is allowed; if not, back to V5.0 (tag v5.0).
  - *Forced changes:* family bath 2.75 → 2.075 m wide (shaft fixed); wardrobe niche 1.5 → 2.175 m; gallery 2.18 m at the stair top; gym +0.675 m, suite court +0.675 m; west doors, windows and furniture 0.675 m west. Everything else as V5.0.
])

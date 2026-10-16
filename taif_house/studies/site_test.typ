// site_test.typ · Taif / Palm House · building-rectangle site test (compile THIS file for the test)
// Uses ../base.typ (site, envelope, palms, north) and building.csv (outside wall faces of each option). Does not touch the design files.
#import "../base.typ": *
#show: setup

// ---------- Controls ----------
#let shift = (0.0, 0.0)    // move the building: (x: + = right/east, y: + = down/south), metres
#let rot = 0deg            // turn the building around ITS OWN centre: + = clockwise on the drawing
#let env-margin = 0.5      // required gap from the buildable envelope (survey uncertainty allowance), m
#let palm-clear = 1.0      // required gap from the building to each palm trunk face, m

// ---------- Rows (one page per row; names starting with # are skipped) ----------
// x, y = centre in the design frame (origin M1, x east, y south along the M line)
// w = width across the M line, d = depth along it, both OUTSIDE wall faces
// tapered building: write w as "north/south", e.g. 12.75/14.5 (west wall straight, east wall leans)
// pentagon (north-east corner cut): write w as "width|a|b", e.g. 12.75|2|3.68
//   a = cut along the north facade from the NE corner, b = cut along the east facade (b ≈ 1.84 × a follows the lane)
// final angle = row angle + rot (each rectangle turns once, around its own centre)
#let rows = csv("building.csv", row-type: dictionary).filter(r => not r.name.starts-with("#")).map(r => {
  let r = r
  r.insert("x", str(float(r.x) + shift.at(0)))
  r.insert("y", str(float(r.y) + shift.at(1)))
  r.insert("angle", str(float(r.at("angle", default: "0")) + rot.deg()))
  r
})
#assert(rows.len() > 0, message: "ERROR: no row in building.csv.")

// ---------- Measurements ----------
#let trunk = 0.265
#let tn-unit = (north.at(0), -north.at(1))   // true north in the design frame
#let widths(r) = { let w0 = r.w.split("|").first(); let ws = w0.split("/"); (float(ws.first()), float(ws.last())) }
#let cut(r) = { let p = r.w.split("|"); if p.len() == 3 { (float(p.at(1)), float(p.at(2))) } else { none } }
#let shape(r) = {
  let (wn, ws) = widths(r)
  let d = float(r.d)
  let t = float(r.angle) * 1deg
  let c = (float(r.x), float(r.y))
  let k = cut(r)
  let loc = if k == none { ((-wn / 2, -d / 2), (wn / 2, -d / 2), (-wn / 2 + ws, d / 2), (-wn / 2, d / 2)) }
    else { ((-wn / 2, -d / 2), (wn / 2 - k.at(0), -d / 2), (wn / 2, -d / 2 + k.at(1)), (-wn / 2 + ws, d / 2), (-wn / 2, d / 2)) }
  loc.map(((a, b)) => (c.at(0) + a * calc.cos(t) - b * calc.sin(t), c.at(1) + a * calc.sin(t) + b * calc.cos(t)))
}
#let test(r) = {
  let P = shape(r)
  let pts = sample(P, step: 0.05)           // every edge checked at ≤ 5 cm
  let inside-env = pts.all(p => inside(p, env))
  let env-gap = calc.min(..pts.map(p => boundary-dist(p, env)))
  let ang = float(r.angle) * 1deg
  let v = (-calc.sin(ang), calc.cos(ang))    // along the depth (towards the south facade)
  let c = (float(r.x), float(r.y))
  let d = float(r.d)
  let palm(T, n) = {
    let gap = boundary-dist(T, P) - trunk
    let into = inside(T, P)
    let b = (T.at(0) - c.at(0)) * v.at(0) + (T.at(1) - c.at(1)) * v.at(1)
    let where = if into { [*inside the building*] } else if b > d / 2 { [beyond the south facade] } else { [beside the building] }
    (n: n, gap: if into { -1 } else { gap }, where: where, ok: (not into) and gap >= palm-clear)
  }
  let palms = (palm(T1, [Palm 1]), palm(T2, [Palm 2]))
  // west edge = the two corners with the smallest x
  let wc = P.sorted(key: p => p.at(0)).slice(0, 2).sorted(key: p => p.at(1))
  let mid = ((wc.at(0).at(0) + wc.at(1).at(0)) / 2, (wc.at(0).at(1) + wc.at(1).at(1)) / 2)
  let west-pts = (wc.at(0), mid, wc.at(1))
  let west-area = area(((0, wc.at(0).at(1)), wc.at(0), wc.at(1), (0, wc.at(1).at(1))))
  let north-y = calc.min(..P.map(p => p.at(1)))
  let true-north = calc.max(..P.map(p => p.at(0) * tn-unit.at(0) + p.at(1) * tn-unit.at(1)))
  (P: P, inside-env: inside-env, env-gap: env-gap, env-ok: inside-env and env-gap >= env-margin,
   palms: palms, west-pts: west-pts, west-area: west-area, north-y: north-y, true-north: true-north)
}

#let ok(b) = if b { text(fill: accent, weight: "bold")[✓ OK] } else { text(fill: warn, weight: "bold")[✗ NO] }

#for (i, r) in rows.enumerate() {
  if i > 0 { pagebreak() }
  let t = test(r)
  let (wn, ws) = widths(r)
  render(
    title: [Site test · #r.name · #if wn == ws [#num(wn)] else [#num(wn)→#num(ws)] × #num(float(r.d)) m · #num(float(r.angle))°#if cut(r) != none [ · NE cut #num(cut(r).at(0)) × #num(cut(r).at(1))]],
    subtitle: [Building rectangle only · outside wall faces · env margin #num(env-margin) m · palm clearance #num(palm-clear) m],
    extras: ((r.name, t.P),),
    note: [
      #table(columns: (1fr, auto, auto), stroke: none, inset: 3pt,
        [*Inside the buildable envelope*], [#if t.inside-env [yes] else [no]], ok(t.env-ok),
        [Smallest gap to the envelope (incl. M line)], [#num(t.env-gap) m], ok(t.env-gap >= env-margin),
        ..t.palms.map(p => ([#p.n: gap to trunk face · #p.where], [#if p.gap < 0 [—] else [#num(p.gap) m]], ok(p.ok))).flatten(),
        [Open land west of the building (to the M line)], [#num(t.west-area) m²], [],
        [  width at NW corner / middle / SW corner], [#t.west-pts.map(p => num(p.at(0))).join(" / ") m], [],
        [Most northern point, along the M line (y)], [#num(t.north-y) m], [],
        [Reach towards TRUE north (projection from M1)], [#num(t.true-north) m], [],
        [Area (outside faces)#if wn != ws [ · north #num(wn) m, south #num(ws) m wide]], [#num(area(t.P)) m²], [],
      )
      #text(6.5pt, fill: gray)[Drawing "up" is the M line, not true north (true north is 21.4° off). Edges checked every 5 cm. "Beyond the south facade" = the palm lies past the extended line of the south facade. The red warnings below repeat the envelope check only.]
    ],
  )
}

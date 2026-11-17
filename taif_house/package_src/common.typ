// common.typ · Taif / Palm House · the delivery package's shared style (A4 portrait, the presentation's colours and fonts)
// Used by: room_schedule.typ, decisions_summary.typ, structural_brief.typ, mep_brief.typ (built by build_package.py into package/ on the main branch).
#let accent = rgb("#2f6b4f")
#let dark = rgb("#22352e")
#let ink = rgb("#3d4a45")
#let soft = luma(120)
#let red = rgb("#b5452f")
#let paper = rgb("#f9f8f4")
#let VERSION = "V10.1-preview"
#let DATE = "17 Nov 2026"
#let STATUS = "design development, not for construction"

#let setup(title, subtitle, audience, doc) = {
  set page(paper: "a4", margin: (x: 15mm, top: 15mm, bottom: 16mm), fill: paper,
    header: grid(columns: (1fr, auto), text(9pt, weight: "bold", fill: accent)[TAIF / PALM HOUSE], text(7.5pt, fill: soft)[#VERSION · #DATE · #audience]),
    footer: grid(columns: (1fr, auto), text(7pt, fill: soft)[DESIGN DEVELOPMENT STUDY | NOT FOR CONSTRUCTION | every size assumed until the engineers confirm it | coordinates: the plans' CSV frame (x east, y south, metres, wall centre lines)],
      context text(8pt, weight: "bold", fill: accent)[#counter(page).display() / #counter(page).final().first()]))
  set text(font: ("Segoe UI", "Arial"), size: 9pt, fill: dark)
  set par(leading: 0.55em, spacing: 0.7em, justify: false)
  block(text(17pt, weight: "bold", fill: accent, title))
  block(above: 4pt, text(9pt, fill: soft, subtitle))
  line(length: 100%, stroke: 0.7pt + accent)
  v(4pt)
  doc
}
#let H(t) = block(above: 9pt, below: 4pt, text(11pt, weight: "bold", fill: accent, t))
#let h3(t) = block(above: 6pt, below: 3pt, text(9.5pt, weight: "bold", fill: dark, t))
// an Arabic line (right to left) under an English item
#let ar(body) = block(width: 100%, above: 2pt, below: 5pt, {
  set text(lang: "ar", dir: rtl, font: ("Segoe UI", "Arial", "Tahoma"), size: 9pt, fill: ink)
  set par(leading: 0.6em, justify: false)
  set align(right)
  body
})
#let note(body) = block(width: 100%, fill: rgb("#eef2ea"), inset: 7pt, radius: 2pt, text(8.5pt, body))
#let warn(body) = block(width: 100%, fill: rgb("#fbe3dd"), inset: 7pt, radius: 2pt, text(8.5pt, body))
#let tbl(cols, ..cells) = table(columns: cols, stroke: 0.3pt + luma(190), inset: 4pt, align: left, fill: (_, y) => if y == 0 { rgb("#e4eedf") } else if calc.even(y) { rgb("#f1efe8") }, ..cells)

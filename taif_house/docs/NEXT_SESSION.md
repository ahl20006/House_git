# Next session · start here

Taif / Palm House · state on 20 Oct 2026 · git tag `v5.0` (GitHub Release "V5.0" with the PDFs and the DXF)

## Where we are
- **V5.0:** the first floor is designed and the ground floor is coordinated with it.
  - **Ground floor V5.0** = V4.0 + east duct removed + three columns for the first-floor west projection. Drawing `design_gf.typ` + `data/rooms_gf.csv`; description `docs/GROUND_FLOOR_V4.md`.
  - **First floor V5.0:** whole floor `design_ff.typ` + `data/rooms_ff.csv`; the design room by room in `studies/ff_family.typ` (part 1: kids' room, family living, bedrooms 1–3, family bath, gallery on the west projection) and `studies/ff_suite.typ` (part 2, the L: owner's office, gym, suite court, master suite). Decisions: `docs/FIRST_FLOOR_BRIEF.md` (V5.0 section).
- **Construction notes** for the engineers: `docs/DETAILS.md`. **Decisions log:** `docs/notes.md`.

## Open and compile
```
python taif_house/tools/check.py                                   # compiles everything into output/, must end with ALL CHECKS PASSED
typst compile --root taif_house taif_house/design_ff.typ taif_house/output/design_ff.pdf   # first floor only
```

## Open items
- **Engineer:** the west projection (three columns + edge beam, or a plain cantilever); loads and vibration of the gym and the office walls over the men's majlis; the y 3.0 partition over the women's majlis.
- **MEP:** the stack outside the east wall (suite bath, vent stack); the kitchen extract through the east wall; the hood south of y ≈ 7.5.
- **Light:** the clerestory sill against the suite court floor (eye height, or obscured glass); a daylight check of the narrower courtyard (sky 3.35 m).
- **Layout:** bedroom 1 is ≈ 17 m from the family bath; the bedrooms' 10 cm partition idea (DETAILS.md).
- **Still open from the ground floor:** locked laundry service door (owner), envelope gap 0.05 m (official survey), foyer majaz only partial, `plumbing.typ` study.

## First question for the next session
Detail round on the master suite and the owner's office (windows, built-ins, lighting), or the engineer's answer on the projection.

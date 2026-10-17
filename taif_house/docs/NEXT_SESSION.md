# Next session · start here

Taif / Palm House · state on 17 Oct 2026 · git tag `v4.1`

## Where we are
- **Ground floor V4.0: frozen.**
  - Drawing: `design_gf.typ` + `data/rooms_gf.csv`.
  - Description: `docs/GROUND_FLOOR_V4.md`.
- **First floor V4.1: the baseline** (zoning + first room layout); the details are still to do.
  - Drawing: `design_ff.typ` + `data/rooms_ff.csv`.
  - Decisions, open items and history: `docs/FIRST_FLOOR_BRIEF.md` (the "V4.1" section and §10c).
  - The earlier zoning options are in `data/zones_ff.csv`, for reference only.
- **Decisions log:** `docs/notes.md`.

## Open and compile
```
python taif_house/tools/check.py                                   # compiles everything into output/, must end with ALL CHECKS PASSED
typst compile --root taif_house taif_house/design_ff.typ taif_house/output/design_ff.pdf   # first floor only
```
Look at `output/design_ff.pdf`:
- page 1: the plan with checks;
- page 3: the furnished plan;
- page 4: rooms, circulation, walls, problems;
- page 5: the light-strip check.

## Review order for the detail rounds
1. **Stair / lift / landing**
2. **West:** children's rooms, shared bath, office, children's study, storage
3. **North:** family living
4. **East:** bedroom 1 + bath, master suite
5. **Men's majlis roof:** gym, terrace, light strip
6. **Whole floor**

## Known issues (first floor V4.1)
- Bedroom 3 is 3.05 m wide (the gym route takes the rest).
- Family seating is 15.75 m² (target ≥ 16).
- Suite lobby ≈ 8.2 m².
- Circulation 49.8 m² (incl. 4.2 m² route in the family living).
- Walls off the ground-floor lines: list on page 4, for the engineer.
- Terrace size vs the gym route.
- Engineer: load and vibration check for the gym and bedroom 3 over the men's majlis.

## Still open from the ground floor
- Locked laundry service door (owner decision).
- Envelope gap 0.05 m, to be confirmed by the official survey.
- Foyer majaz only partial (curtain or screen).
- `plumbing.typ` study still to do.

## First question for the next session
**Stair / lift / landing:**
- Where exactly does the stair arrive?
- How does the lift landing work with the gallery and the entry cupboard?
- Is the landing the right buffer for visitors?

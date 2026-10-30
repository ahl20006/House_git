# Next session · start here

Taif / Palm House · **V7.0** (git tag `v7.0`, GitHub Release "V7.0"; the branch `work` is kept for the next round)

## Where we are
- **V7.0 = V6.3 + the big decisions of the design review**, all owner decisions (`PROJECT_V7.md` §4.25–4.29, `data/decisions.csv`, the status of every critical and major finding in `output/Design_Review_status_V7.pdf`):
  - **Courtyard enclosure, option A:** the conditioned house is closed round the open courtyard by black steel divided-lite windows: W1 on the gallery edge (on the B3 upstand, +3.82 … +6.75), W2 on the family living's edge, W3 over the living's courtyard glass; the projection 1.55 m (B3, R11, C21–C23 at x 5.80), the gallery 1.405 m clear (1.235 at the columns), the sky 3.15 m (`studies/courtyard_enclosure.typ`).
  - **Maid room:** the kitchen's north wall at y 7.0 (a partition; the y 6.5 beam stays): maid room 7.28 m² clear, 2.49 m at the bed; laundry 6.2 m²; kitchen 24.0 m² clear (`studies/east_wing.typ`).
  - **Roof access and the roofline:** the main stair continues to the roof (flights 3 / 4, trimmers R16–R18, a stair room 2.20 m clear); flat roof with a honey-stone main cornice all round, the north block's coping +7.65, the attic screen 1.8 m set back 1.0 m (coping +9.10), the south wing's parapet +8.40; the reserved roof zones (plant, tank, PV, strip, outlets, walkways, guards) (`studies/roof.typ`, `output/taif_roof_V7.0.dxf`).
  - **Design language:** `DESIGN_LANGUAGE.md` (cream plaster, honey stone, black steel divided lites, walnut, Roman arches, round stone columns, black bar railing, little mashrabiya, hidden lighting, the roofline).
  - **3D:** generated with all of it (the enclosure windows W1–W3, the stair to the roof and the stair room, the attic, the cornice, the band, the parapets, the quoins, the guards, the design-language colours); four renders in `3d/output/`: `char_north.png`, `char_aerial_sw.png`, `char_eye2.png`, `char_tv.png`.
- **Everything else as in V6.3:** the TV wall, the lift at construction, the door widths, the 0.30 m south (provisional), the L-shaped gym, the structural study (X5 unverified, X9 no soil report), the air study v2.1.

## The next open items, in this order (from the review status)
1. **Fire and escape** (E-08, critical): interconnected alarms, a smoke vent at the top of the double-height void, the escape strategy from the first floor (the single stair opens onto the riwaq; the stair room door to the roof is a way out upwards), sprinklers to decide, the maid's window sill.
2. **Courtyard: the sunken seating, the level play zone and the drainage outfall** (Y-03, Y-02, Y-04, E-03): a guard or a shallower pit, a level play zone ≥ 3 × 3 m, the hose point, where the courtyard, the roof and the suite court drain to.
3. **The malqaf's value in the sealed house and the pergola** (E-01; open items 17, 18): a feature only, the ERV's filtered intake, or drop it; the pergola kept, lightened or dropped.
4. **Gym: the treadmill clearances and vibration** (F-09, X6, X5): with the engineer; rubber floor over the whole gym.
5. **Bedroom 1's bathroom route** (F-05, open item 16).
6. **The food route from the kitchen to the men's majlis** (X-01): an outside service path to a majlis serving door, or accept.
7. **The site and roof services plan** (S-01 … S-08, E-04 … E-06): parking, the guest approach, the garden door, the service yard, the outdoor kitchen path, tanks, septic, generator, inverter room, security, the safe room; the roof zones tie into it.
8. **Structure X5 and the soil report** (T-01, T-03, the engineers).
9. **The legal survey** (S-03, open item 1).

Small things noted on the way: the gym route's east wall stays on x 5.6 (a 0.20 m nib at y 19.25 against the gallery edge x 5.8: follow to x 5.8 in the L study if one line is wanted); the plan views of the 3D (`view_*.png`, `plan_*.png`, `eye*.png`, `sun_*.png`, `char_living.png`, `char_night.png`) were not re-rendered for V7.0: run `python taif_house/3d/render_views.py` to refresh them.

## What to open
| File | What it is |
|---|---|
| `output/Taif_House_V7.0_presentation.pdf` | the A3 set, 12 sheets (for the owner and the engineers): site, both floors, the family part, the L and the suite, the two ground-floor blocks, sections and light, schedules, decisions, open items, the roof plan, the elevations |
| `output/Design_Review_status_V7.pdf` | the status of the design review after V7.0; the review itself: `output/Design_Review_V6.pdf` |
| `output/roof.pdf`, `output/courtyard_enclosure.pdf` | the roof study and the enclosure study (decided) |
| `output/design_gf.pdf`, `output/design_ff.pdf` | both floors in the site, with checks, schedules, the light check and the projection sections |
| `output/ff_family.pdf`, `output/ff_suite.pdf`, `output/guest_wing.pdf`, `output/east_wing.pdf` | the room studies |
| `output/structure.pdf`, `output/air_system.pdf` | the structural and air studies |
| `output/taif_ground_floor_V7.0.dxf`, `output/taif_first_floor_V7.0.dxf`, `output/taif_roof_V7.0.dxf` | CAD, see `docs/README_DXF.md` |
| `3d/viewer.html` | the 3D (plain model and the character study with the design-language colours) |

## Compile and check
```
python taif_house/tools/check.py      # compiles everything, rebuilds the three DXFs and the 3D, must end with ALL CHECKS PASSED
typst compile --root taif_house taif_house/presentation.typ taif_house/output/Taif_House_V7.0_presentation.pdf
typst compile --root taif_house taif_house/docs/review/review_status.typ taif_house/output/Design_Review_status_V7.pdf
python taif_house/3d/render_views.py char_north.png char_aerial_sw.png char_eye2.png char_tv.png   # the four V7.0 renders (headless Edge)
```
Tools: Typst 0.15, Python 3.10+ with ezdxf, shapely, trimesh, pyyaml, mapbox_earcut, pdftotext (on Windows from Git for Windows: `C:\Program Files\Git\ucrt64\bin`). The 3D renders need headless Edge outside a sandbox (`3d/README_3D.md`).

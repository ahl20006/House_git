# Next session · start here

Taif / Palm House · **V6.3** (git tag `v6.3`, GitHub Release "V6.3")

## Where we are
- **V6.3 = V6.2 + the quick fixes from the design review** (`docs/review/design_review.typ` → `output/Design_Review_V6.pdf`, tag `review-1`; the owner's requirements in `docs/REQUIREMENTS.md`). The fixes, all owner decisions (`PROJECT_V6.md` §4.23, `data/decisions.csv` V6.3):
  - **TV wall:** the living's west wall on x 4.25 is solid and full height; a 1.40 m arched entrance from the riwaq at its north end (head +2.60), then an arched TV niche 4.40 × 0.70 m (crown +3.10) with the 85″ TV centred, a low cabinet and side shelves; the sofa (3.8 m) faces west with its back at x 8.45, eye-to-screen 3.47 m, the dining behind it, a 1.9 m path at the sofa's north end. No arches between the colonnade columns (the 3D's arches variant removed).
  - **Lift at construction:** two stops, sliding landing doors from the family lobby (y 0.9–1.9) and the gallery; the entry cupboard is 0.5 × 0.9 and the strip in front of the lift door is lobby. The shaft 2.25 × 2.2 is a placeholder until a supplier's civil drawing is chosen (open item 14).
  - **Doors:** every bedroom and bathroom door is a 1.00 m opening with a 0.90 m leaf (≥ 0.85 m clear); the suite WC closet door opens out into the bath; bedroom 3's door at y 15.2–16.2 (south of its entry wardrobe), its bath door sliding. Not reached: the guest WC (0.90 m opening, the room is 1.3 m clear) and the maid bath (0.70 m: column C31 and the cut wall) — both wait for the maid wing / wash block decisions.
  - **X3 resolved:** the suite bath's east window 0.55 m at y 9.50–10.05, its frame 0.05 m clear of column C33 (assumed 0.25 × 0.60 along the wall).
  - **Slabs in the 3D:** the first-floor and roof bays carry the structural study's thicknesses (0.30 ribbed over the kitchen, dining, men's majlis, suite and office; 0.22 flat over the void; 0.20 elsewhere), assumed. Clear heights before finishes: +3.32 under the 0.20 slabs, +3.22 under the 0.30 bays, +3.05 under B5, +3.10 under B4, +3.20 under B1; the stair headroom stays 2.14 m (under B16).
  - **House 0.30 m further south** (shift (0.91, 3.825), provisional until the official survey): the nearest outer face is 0.20 m from the lane setback line (it governs; the north street line is 0.80 m away) instead of 0.05 m; the palms 5.99 / 7.84 m from the walls; the south garden 7.2 m deep at the middle of the south facade. To reach 0.35 m on the lane the house would need 0.63 m south, or 0.30 m south + 0.17 m west.
  - **Two-children test** (`tools/bedroom_test.py`, a randomized wall-hugging search with 0.75 m clearances and the door swing): bedroom 3 (15.02 m² clear) takes two beds, two wardrobes and two desks with every clearance; bedroom 2 (12.88 m²) takes two beds, two wardrobes and one desk (no wall left for the second). Details in `PROJECT_V6.md` §4.24. No layout change was made.
- **Everything else as in V6.2:** the L-shaped gym, the two-storey colonnade, the upturned edge beam, the malqaf outlet on the kitchen wall (air study v2.1), the 3D character study r2 (style, provisional), the structural study (X5 unverified, X9 no soil report).

## The big items still open, in this order (from the design review)
1. **Courtyard enclosure** (review Y-01, critical): the first-floor gallery and family living are railings on the open sky, and the double-height living has nothing above its courtyard glass. Decide: an open sky well with glazed first-floor edges, or an atrium with an operable glass roof. It settles the dust strategy, the malqaf, the light of the living, the pergola and the first-floor plan.
2. **Maid room** (G-04): 6.04 m² clear and 0.7 m wide at its north end against the municipal ≥ 6.5 m² / ≥ 2.1 m; exit only through the kitchen; the maid bath door 0.70 m. Redesign the maid wing (where does the laundry go?).
3. **Roof access** (F-07): no stair or hatch to the roof (plant, malqaf hatch, PV, tank). A third flight in the stair well with a roof pavilion, or an external stair.
4. **Fire and escape** (E-08): the single stair opens onto the riwaq and the gallery onto the living void; no alarms, no sprinklers; the maid's window sill 1.50 m. Interconnected alarms, a smoke vent at the top of the void, sprinklers to decide.
5. **Serving route and bedroom 1's bath** (X-01, F-05): the weekly meal crosses the family's TV room (17.5 m, four doors); an outside service path to a majlis serving door, or accept. Bedroom 1 is 6.9 m from the family bath.
6. **Malqaf** (E-01): a dry malqaf into an open courtyard adds nothing to a closed filtered house; keep as a feature, make the tower the ERV intake, or ventilate an atrium with it. Decide with item 1.
7. **Gym: treadmill clearances and vibration** (F-09, X6): the arm's clearances and the majlis roof's vibration with the engineer; rubber floor over the whole gym.
8. **Site and roof plan** (S-01 … S-08, E-04 … E-06): parking (two shaded spaces), the guest / family approach, the garden door and the family terrace, the service yard, the outdoor kitchen path, tanks, septic, generator, PV, security and the safe room.

## What to open
| File | What it is |
|---|---|
| `output/Taif_House_V6.3_presentation.pdf` | the A3 set, 10 sheets (for the owner and the engineers) |
| `output/Design_Review_V6.pdf` | the design review (written against V6.2; compiled again it shows the V6.3 files) |
| `output/design_gf.pdf`, `output/design_ff.pdf` | both floors in the site, with checks, schedules, the light check and the projection sections |
| `output/ff_family.pdf`, `output/ff_suite.pdf`, `output/guest_wing.pdf`, `output/east_wing.pdf` | the room studies |
| `output/structure.pdf`, `output/air_system.pdf` | the structural and air studies |
| `output/taif_ground_floor_V6.3.dxf`, `output/taif_first_floor_V6.3.dxf` | CAD, see `docs/README_DXF.md` |
| `3d/viewer.html` | the 3D (plain model and the character study) |

## Compile and check
```
python taif_house/tools/check.py      # compiles everything, rebuilds both DXFs and the 3D, must end with ALL CHECKS PASSED
typst compile --root taif_house taif_house/presentation.typ taif_house/output/Taif_House_V6.3_presentation.pdf
python taif_house/tools/bedroom_test.py   # the two-children test (no file changed)
```
Tools: Typst 0.15, Python 3.10+ with ezdxf, shapely, trimesh, pyyaml, mapbox_earcut, pdftotext (on Windows from Git for Windows: `C:\Program Files\Git\ucrt64\bin`). The 3D renders need headless Edge outside a sandbox (`3d/README_3D.md`).

# DXFs · Taif / Palm House V6.0 · ground floor and first floor

Two DXFs for anyone working in CAD (AutoCAD, BricsCAD, DraftSight, LibreCAD, QCAD …), one per floor. Both are in the same coordinate frame, so they overlay exactly.

| File | Shows | Same plan as |
|---|---|---|
| `output/taif_ground_floor_V6.0.dxf` | the site, the ground-floor outline, every room, doors, windows and openings, special walls, the fixtures of both blocks, the first-floor edges above | `output/design_gf.pdf` |
| `output/taif_first_floor_V6.0.dxf` | the site, the first-floor outline (and the ground-floor outline dashed), every room with its number, the voids, the fixed elements, doors, windows, furniture | `output/design_ff.pdf` |

## Units and coordinates
- **Units:** metres (`$INSUNITS = 6`). Draw scale 1:1.
- **Origin:** (0, 0) = survey peg **M1** (east post of the gate).
- **Axes:** x is east, square to the M line; y runs along the M line. The Typst drawings count y southwards; the DXFs have y pointing **up** (north up), so a Typst point (x, y) is (x, −y) in the DXF.
- **The building** sits on site option **Z4**, shifted (0.91, 3.525) from the room coordinates in `data/rooms_*.csv`, with rotation 0°:
  - **ground floor:** a pentagon 13.311 × 24.0 m on wall centre lines (13.561 × 24.25 outside), its north-east corner cut along the lane down to y 6.0;
  - **first floor:** the same, with the west face 0.675 m further west south of y 10.4 (the split projection).
- **Walls:** room outlines are on **wall centre lines**; wall thickness is not drawn. Clear sizes (`docs/PROJECT_V6.md`) assume 250 mm outer, 200 mm inner and 100 mm dry partition walls.
- **Extended data:** every room polyline carries its name and area as extended data (application `HOUSE`), so a CAD user can list them. The first-floor room labels carry the room numbers F01–F21.

## Layers
**Ground floor:**
| Layer | What is on it |
|---|---|
| SITE-LAND / -ENVELOPE / -DRIVEWAY / -LANE / -SOUTH | plot, buildable envelope, driveway, lane and north wall, south line |
| SITE-PALMS · SITE-PEGS | palm trunks (r 0.265) and 1 m circles · survey pegs M1–M4 |
| BUILDING-OUTLINE · COURTYARD | ground-floor outline · courtyard, open to the sky |
| ROOMS-FAMILY / -GUEST / -SERVICE / -CIRC / -CORE · ROOM-LABELS | one closed polyline per room, by use · name and area |
| AIR-TOWER | air tower in the tip of the cut corner |
| DOORS · OPENINGS · WINDOWS · WALLS-SPECIAL | doors · openings without a door · windows · solid wall to the women's majlis, kitchen / basins wall, WC screen wall, living low partition, family / guest line |
| FIXTURES | east block: counters, machines, bed, wardrobe, shower, WC, basin · west block: hospitality counter, basin counter, trough, shoe cabinet |
| MARKS | service shaft, under-stair store, the living's ceiling-height change, the first-floor cantilever edge and the first-floor west wall above |
| ENTRIES · ANNOTATION | family and guest entry arrows · title, north arrow, scale bar |

**First floor:**
| Layer | What is on it |
|---|---|
| SITE-* | as on the ground floor |
| BUILDING-OUTLINE · GF-OUTLINE | first-floor outline · ground-floor outline below (dashed) |
| VOIDS | the courtyard (open to the sky) and the double-height living (no floor) |
| ROOMS-FAMILY / -GUEST (master suite) / -SERVICE / -CIRC / -OPEN (suite court) / -GYM / -CORE · ROOM-LABELS | one closed polyline per room · number, name and area |
| DOORS · OPENINGS · WINDOWS | hinged doors · sliding doors and openings · windows |
| FURNITURE | furniture and fixtures from the two first-floor studies, including the treadmill at the gym's west end |
| MARKS | the ground-floor lines the cantilevers start from (x 4.25 courtyard edge, x 0 west wall) |
| ANNOTATION | title, scale bar |

## How to regenerate
```
pip install ezdxf
python taif_house/tools/make_dxf.py       # ground floor
python taif_house/tools/make_dxf_ff.py    # first floor (needs typst on PATH)
```
- **`make_dxf.py`** reads:
  - `base.typ` (site);
  - `design_gf.typ` (shift, rotation, outline, air tower, marks, door and window lines);
  - `data/rooms_gf.csv`;
  - `studies/east_wing.typ` and `studies/guest_wing.typ` (fixtures).
- **`make_dxf_ff.py`** reads the `<ff-data>` metadata of `design_ff.typ` with `typst eval`. That is the rooms of `data/rooms_ff.csv` already placed on the site, plus the doors, windows and furniture of the two first-floor studies.

Nothing is typed in twice: change the design there, then run the scripts again.

## How to check
```
python taif_house/tools/check.py
```
It rebuilds both DXFs and checks that every room in each DXF has the same area as its CSV. It must end with **ALL CHECKS PASSED**.

## Limits
These are concept drawings: wall centre lines, no wall thickness, no dimensions, no levels. Ground-floor doors and windows outside the two studied blocks are not in the DXF; the presentation shows them as indicative.

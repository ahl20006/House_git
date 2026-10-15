# design_v3.dxf · Taif / Palm House · Design V3.1

One DXF with the whole design: the site, the building outline, every room, the doors, windows and openings, and the fixtures of the east service block. It shows the same plan as `design_v3.pdf`, for anyone working in CAD (AutoCAD, BricsCAD, DraftSight, LibreCAD, QCAD …).

## Units and coordinates
- Units: **metres** (`$INSUNITS = 6`). Draw scale 1:1.
- Origin (0, 0) = survey peg **M1** (east post of the gate).
- x = east, square to the M line. y = along the M line. The Typst drawings count y southwards; the DXF has y pointing **up** (north up), so a Typst point (x, y) is (x, −y) in the DXF.
- The building sits on site-test option **Z4** (pentagon 13 × 23 m on wall centre lines, north-east corner cut along the lane), shifted (0.65, 3.525) from the room coordinates in `data/rooms_v3.csv`, rotation 0°.
- Room outlines are on **wall centre lines**. Wall thickness is not drawn yet.

## Layers

| Layer | What is on it |
|---|---|
| SITE-LAND | plot boundary |
| SITE-ENVELOPE | buildable envelope (setback lines) |
| SITE-DRIVEWAY | driveway |
| SITE-LANE | lane edge and north wall |
| SITE-SOUTH | south line of the plot (dashed) |
| SITE-PALMS | palm trunks (r 0.265) and 1 m clear circles |
| SITE-PEGS | survey pegs M1–M4 on the M line |
| BUILDING-OUTLINE | ground-floor outline |
| COURTYARD | courtyard, open to the sky |
| ROOMS-FAMILY / -GUEST / -SERVICE / -CIRC / -CORE | one closed polyline per room, by use |
| ROOM-LABELS | room name and area |
| AIR-TOWER | air tower in the tip of the cut corner |
| DOORS | doors (with a short description) |
| OPENINGS | open entrances and openings without a door |
| WINDOWS | windows |
| WALLS-SPECIAL | solid wall to the women's majlis, guest WC screen wall, family / guest line |
| FIXTURES | counters, machines, bed, wardrobe, shower (east service block) |
| MARKS | service shaft, under-stair store, living-room ceiling-height change |
| ENTRIES | family and guest entry arrows |
| ANNOTATION | title, north arrow, 10 m scale bar |

Every room polyline carries its name and area as extended data (application `HOUSE`), so a CAD user can list them.

## How to regenerate
```
pip install ezdxf
python concept_V3.0/tools/make_dxf.py
```
The script reads `base.typ` (site), `design_v3.typ` (shift, rotation, outline, air tower, marks, door and window lines), `data/rooms_v3.csv` (rooms) and `studies/east_wing.typ` (fixtures). Nothing is typed in twice: change the design there, then run the script again.

## How to check
```
python concept_V3.0/tools/check_v3.py
```
It compiles all Typst files, compares both studies with the CSV, rebuilds the DXF and checks that every room in the DXF has the same area as the CSV. It must end with **ALL CHECKS PASSED**.

## Limits
- Concept drawing: wall centre lines only, no wall thickness, no dimensions, no first floor.
- Fixtures are drawn for the east service block only; the west wash block shows its doors, openings and screen wall (its fixtures are described in `studies/guest_wing.typ` and `notes.md`).

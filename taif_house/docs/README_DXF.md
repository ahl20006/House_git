# taif_ground_floor_V4.dxf · Taif / Palm House · Ground floor V4.0

One DXF with the whole ground floor: the site, the building outline, every room, the doors, windows and openings, the special walls and the fixtures of both blocks. It shows the same plan as `output/design_gf.pdf`, for anyone working in CAD (AutoCAD, BricsCAD, DraftSight, LibreCAD, QCAD …). File: `output/taif_ground_floor_V4.dxf`.

## Units and coordinates
- **Units:** metres (`$INSUNITS = 6`). Draw scale 1:1.
- **Origin:** (0, 0) = survey peg **M1** (east post of the gate).
- **Axes:** x is east, square to the M line; y runs along the M line. The Typst drawings count y southwards; the DXF has y pointing **up** (north up), so a Typst point (x, y) is (x, −y) in the DXF.
- **The building** sits on site-test option **Z4**:
  - a pentagon 13.311 × 24.0 m on wall centre lines (13.561 × 24.25 outside), its north-east corner cut along the lane down to y 6.0;
  - shifted (0.91, 3.525) from the room coordinates in `data/rooms_gf.csv`, rotation 0°.
- **Walls:** room outlines are on **wall centre lines**. Wall thickness is not drawn; the clear sizes in `docs/GROUND_FLOOR_V4.md` assume 250 mm outer, 200 mm inner and 100 mm dry partition walls.

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
| AIR-TOWER | air tower in the tip of the cut corner (1.0 m deep, ≈ 0.9 m² clear) |
| DOORS | doors (with a short description), incl. the foyer double door and the future lift door |
| OPENINGS | open entrances and openings without a door (hospitality kitchen, family basins, entry cupboard, living room, kitchen ↔ laundry, foyer → men's majlis) |
| WINDOWS | windows |
| WALLS-SPECIAL | solid wall to the women's majlis, hospitality kitchen / basins wall, guest WC screen wall, living-room 1.20 m low partition, family / guest line |
| FIXTURES | east block: counters, east duct, washer, dryer, utility sink, bed, wardrobe, shower, WC, basin · west block: hospitality counter, basin counter, trough, shoe cabinet |
| MARKS | service shaft, under-stair store, east duct, living-room ceiling-height change |
| ENTRIES | family and guest entry arrows |
| ANNOTATION | title, north arrow, 10 m scale bar |

Every room polyline carries its name and area as extended data (application `HOUSE`), so a CAD user can list them.

## How to regenerate
```
pip install ezdxf
python taif_house/tools/make_dxf.py
```
The script reads:
- `base.typ` (site);
- `design_gf.typ` (shift, rotation, outline, air tower, marks, door and window lines);
- `data/rooms_gf.csv` (rooms);
- `studies/east_wing.typ` and `studies/guest_wing.typ` (fixtures).

Nothing is typed in twice: change the design there, then run the script again.

## How to check
```
python taif_house/tools/check.py
```
It compiles all Typst files into `output/`, compares both studies with the CSV, rebuilds the DXF and checks that every room in the DXF has the same area as the CSV. It must end with **ALL CHECKS PASSED**.

## Limits
Concept drawing of the ground floor only: wall centre lines, no wall thickness, no dimensions. The first floor is not in the DXF yet (`design_ff.typ` is its starting point).

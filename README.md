# House_git · Taif / Palm House

Concept design of a courtyard house in Taif, drawn with [Typst](https://typst.app) from CSV room data.

Current version: **V3.2** (16 Oct 2026, git tag `v3.2`: Concept V3.1 Revision 02), in the folder `concept_V3.0/`. Previous: `v3.1` (15 Oct 2026).

| File | What it is |
|---|---|
| `concept_V3.0/design_v3.typ` → `design_v3.pdf` | the design: plan, schedules, design idea |
| `concept_V3.0/data/rooms_v3.csv` | every room (position, size, use) |
| `concept_V3.0/base.typ` | site, envelope, palms, checks, drawing engine |
| `concept_V3.0/studies/` | room-by-room layout studies of the west wash block and the east service block |
| `concept_V3.0/design_v3.dxf` | the same plan as one DXF for CAD (see `README_DXF.md`) |
| `concept_V3.0/notes.md` | decisions log |
| `concept_V3.0/tools/` | `make_dxf.py` (writes the DXF), `check_v3.py` (checks everything) |

Compile: `typst compile concept_V3.0/design_v3.typ` · Check: `python concept_V3.0/tools/check_v3.py` (needs `pip install ezdxf`).

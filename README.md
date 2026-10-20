# House_git · Taif / Palm House

Concept design of a courtyard house in Taif, drawn with [Typst](https://typst.app) from CSV room data.

**Current version: V5.0 (20 Oct 2026, git tag `v5.0`)** · first floor designed, ground floor coordinated. Everything is in `taif_house/`. Start the next session with `taif_house/docs/NEXT_SESSION.md`.

**For engineers and anyone without git:** open the **[Releases](../../releases)** page and download the release **V5.0**: the presentation set (`Taif_House_V5.0_presentation.pdf`, 8 sheets: site, both floors, enlarged first-floor plans, sections, area schedules, engineer items), all drawings in one PDF, and the ground floor as DXF. Each release is a frozen version; `main` always holds the latest work.

```
taif_house/
  base.typ                 site, envelope, palms, checks, drawing engine (fixed)
  design_gf.typ            ground floor V5.0            ← data/rooms_gf.csv
  design_ff.typ            first floor V5.0 (whole floor, checked against the two first-floor studies) ← data/rooms_ff.csv
  presentation.typ         V5.0 presentation set, both floors (walls with thickness, doors, fixtures, Arabic notes)
  studies/                 ff_family.typ (first floor part 1: family part), ff_suite.typ (part 2: office, gym, suite court, master suite),
                           guest_wing.typ (west wash block), east_wing.typ (east service block), site_test.typ + building.csv
  tools/                   check.py (check everything), make_dxf.py (DXF), schedule.py (room schedule)
  docs/                    NEXT_SESSION.md (start here), FIRST_FLOOR_BRIEF.md, GROUND_FLOOR_V4.md, DETAILS.md (construction notes),
                           notes.md (decisions log), README_DXF.md
  output/                  PDFs and taif_ground_floor_V5.dxf (all generated)
  archive/                 superseded files (V4.1 first floor, older versions)
```

- **Compile one file:** `typst compile --root taif_house taif_house/design_ff.typ taif_house/output/design_ff.pdf`. The `--root` lets the studies reach `../base.typ`.
- **Check everything:** `python taif_house/tools/check.py` (needs `pip install ezdxf`). It must end with **ALL CHECKS PASSED**.
- **Versions:** tags `v3.1` … `v3.4`, `v4.0` (ground floor final), `v4.1` (first-floor baseline), `v5.0` (current). The decisions of each version are in `taif_house/docs/notes.md`.

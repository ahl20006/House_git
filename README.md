# House_git · Taif / Palm House

Concept design of a courtyard house in Taif, drawn with [Typst](https://typst.app) from CSV room data.

**Current version: V5.1 (24 Oct 2026, git tag `v5.1`)** · the first-floor west projection split (0.675 m inward, 0.675 m outward, no columns) and a rectangular gym with the treadmill at its west end. **Top open item:** the municipality / engineering office must confirm the first-floor projection 0.11 m from the M line; if it is not allowed, the design goes back to V5.0 (tag `v5.0`). Everything is in `taif_house/`. Start the next session with `taif_house/docs/NEXT_SESSION.md`.

**For engineers and anyone without git:** the **[Releases](../../releases)** page holds frozen versions up to **V5.0** (presentation set, all drawings in one PDF, the ground floor as DXF). For V5.1, take `taif_house/output/Taif_House_V5.1_presentation.pdf` (9 sheets: site, both floors, enlarged first-floor plans, sections, the split-projection decision, area schedules, engineer items) and `taif_house/output/taif_ground_floor_V5.1.dxf` from the `v5.1` tag. `main` always holds the latest work.

```
taif_house/
  base.typ                 site, envelope, palms, checks, drawing engine (fixed)
  design_gf.typ            ground floor V5.1            ← data/rooms_gf.csv
  design_ff.typ            first floor V5.1 (whole floor, checked against the two first-floor studies; page 5: V5.1 against V5.0) ← data/rooms_ff.csv
  presentation.typ         V5.1 presentation set, both floors (walls with thickness, doors, fixtures, Arabic notes)
  studies/                 ff_family.typ (first floor part 1: family part), ff_suite.typ (part 2: office, gym, suite court, master suite),
                           sp_compare.typ (split projection: comparison with V5.0 and east–west sections),
                           guest_wing.typ (west wash block), east_wing.typ (east service block), site_test.typ + building.csv
  tools/                   check.py (check everything), make_dxf.py (DXF), schedule.py (room schedule)
  docs/                    NEXT_SESSION.md (start here), FIRST_FLOOR_BRIEF.md, GROUND_FLOOR_V4.md, DETAILS.md (construction notes),
                           notes.md (decisions log), VARIANT_SP.md (split-projection study record), README_DXF.md
  output/                  PDFs and taif_ground_floor_V5.1.dxf (all generated)
  archive/                 superseded files (V4.1 first floor, older versions)
```

- **Compile one file:** `typst compile --root taif_house taif_house/design_ff.typ taif_house/output/design_ff.pdf`. The `--root` lets the studies reach `../base.typ`.
- **Check everything:** `python taif_house/tools/check.py` (needs `pip install ezdxf`). It must end with **ALL CHECKS PASSED**.
- **Versions:** tags `v3.1` … `v3.4`, `v4.0` (ground floor final), `v4.1` (first-floor baseline), `v5.0` (first floor designed), `v5.1` (current). The decisions of each version are in `taif_house/docs/notes.md`.
- **Study branches (local, not pushed):** `v5-split-projection` (accepted, merged into V5.1) and `v5-gym-L` (L-shaped gym, rejected, kept for reference).

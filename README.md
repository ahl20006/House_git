# House_git · Taif / Palm House

Concept design of a courtyard house in Taif, drawn with [Typst](https://typst.app) from CSV room data.

**Current version: Ground floor V4.0 (final) + First floor V4.1 (baseline, 17 Oct 2026, git tag `v4.1`).** Everything is in `taif_house/`. Start the next session with `taif_house/docs/NEXT_SESSION.md`. Earlier tags: `v3.1` … `v3.4`, `v4.0`.

```
taif_house/
  base.typ                 site, envelope, palms, checks, drawing engine (fixed)
  design_gf.typ            ground floor V4.0           ← data/rooms_gf.csv
  design_ff.typ            first floor V4.1 baseline   ← data/rooms_ff.csv (zoning options: data/zones_ff.csv)
  studies/                 guest_wing.typ (west wash block), east_wing.typ (east service block),
                           site_test.typ + building.csv (footprint against the site)
  tools/                   check.py (check everything), make_dxf.py (DXF), schedule.py (room schedule)
  docs/                    NEXT_SESSION.md (start here), GROUND_FLOOR_V4.md, FIRST_FLOOR_BRIEF.md, notes.md (decisions log), README_DXF.md
  output/                  PDFs and taif_ground_floor_V4.dxf (all generated)
  archive/                 superseded files
```

- **Compile one file:** `typst compile --root taif_house taif_house/design_gf.typ taif_house/output/design_gf.pdf`. The `--root` lets the studies reach `../base.typ`.
- **Check everything:** `python taif_house/tools/check.py` (needs `pip install ezdxf`). It must end with **ALL CHECKS PASSED**.

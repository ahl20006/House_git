# House_git · Taif / Palm House

Concept design of a two-storey courtyard house in Taif, drawn with [Typst](https://typst.app) from CSV room data.

**Current version: V6.2** (git tag `v6.2`, GitHub Release "V6.2").
- **Both floors are designed:**
  - the 1.35 m west projection over the courtyard and the double-height void, on an edge beam and three columns (the V5.0 columns solution, restored in V6.1 after the split projection of V5.1–V6.0 was reverted);
  - an L-shaped gym (V6.2): the long arm along the south facade and a treadmill arm at the east end along the suite bedroom wall, with acoustic separation; the suite court is 11.97 m².
- **Walls on walls:** the first-floor walls stand on the ground-floor walls (0.785 m from the M line), so no M-line approval is needed. The open items are in `taif_house/docs/OPEN_ITEMS.md`.
- **Start here:** `taif_house/docs/NEXT_SESSION.md`. The whole house is described in `taif_house/docs/PROJECT_V6.md`.

**For engineers and anyone without git:** open the **[Releases](../../releases)** page and download **V6.2**:
- the A3 presentation set `Taif_House_V6.2_presentation.pdf` (10 sheets: site, both floors, the family part, the L and the master suite, the two ground-floor blocks, sections and light, area schedules, decisions log, open items);
- the two DXFs (`taif_ground_floor_V6.2.dxf`, `taif_first_floor_V6.2.dxf`).

Each release is a frozen version; `main` always holds the latest work.

## How the repo is organised
```
taif_house/
  base.typ                 site, envelope, palms, checks, drawing engine (fixed)
  design_gf.typ            ground floor  ← data/rooms_gf.csv        (also the building placement, used by the first floor)
  design_ff.typ            first floor   ← data/rooms_ff.csv        (checked room for room against the two first-floor studies)
  presentation.typ         the A3 presentation set, 10 sheets, English + Arabic notes, every number from the files
  data/                    rooms_gf.csv, rooms_ff.csv (one row per room; # at the start of a name switches a row off),
                           decisions.csv (decisions log), open_items.csv (open items)
  studies/                 ff_family.typ (first floor: family part), ff_suite.typ (office, gym, suite court, master suite),
                           guest_wing.typ (west wash block), east_wing.typ (east service block),
                           sections.typ (levels, the west projection and its columns, light check, sections; imported, not compiled alone),
                           site_test.typ + building.csv (the footprint against the site)
  tools/                   check.py (check everything), make_dxf.py (ground-floor DXF), make_dxf_ff.py (first-floor DXF),
                           schedule.py (ground-floor room schedule in Markdown)
  docs/                    NEXT_SESSION.md (start here), PROJECT_V6.md (master document), DETAILS.md (construction notes), OPEN_ITEMS.md, README_DXF.md
  output/                  all PDFs and both DXFs (generated, committed)
  3d/                      the 3D model, generated from the project files (build_3d.py → GLB, viewer.html, check_3d.py, README_3D.md)
  archive/                 superseded files: earlier drawings, PDFs, DXFs, room lists and docs (archive/docs/)
```

## Compile, check, regenerate
- **Tools:** Typst 0.15 (`typst`), Python 3.12 with `pip install ezdxf`, and `pdftotext` (on Windows it comes with Git for Windows in `C:\Program Files\Git\ucrt64\bin`), all on PATH.
- **Compile one file** (the `--root` lets the studies reach `../base.typ` and `../data`):
  ```
  typst compile --root taif_house taif_house/design_ff.typ taif_house/output/design_ff.pdf
  typst compile --root taif_house taif_house/presentation.typ taif_house/output/Taif_House_V6.2_presentation.pdf
  ```
- **Check everything:** `python taif_house/tools/check.py` must end with **ALL CHECKS PASSED**. It:
  - compiles every drawing, the studies, the presentation and the archived first-floor drawing;
  - reads the PDFs' check lines and confirms the presentation has 10 A3 sheets;
  - compares the ground-floor studies with the CSV;
  - rebuilds both DXFs and compares their areas with the CSVs;
  - checks the open items against `docs/OPEN_ITEMS.md`, and that no old version label is left in the active files;
  - rebuilds the 3D model and runs its checks (`3d/check_3d.py`).
- **DXFs only:** `python taif_house/tools/make_dxf.py` and `python taif_house/tools/make_dxf_ff.py` (see `taif_house/docs/README_DXF.md`).

## Versions
- **Tags:** `v3.1` … `v3.4`, `v4.0` (ground floor final), `v4.1` (first-floor baseline), `v5.0` (first floor designed), `v5.1` (split projection), `v6.0` (clean release), `v6.1` (the split projection reverted to the V5.0 columns solution), `v6.2` (current: the L-shaped gym). The changelog is in `taif_house/docs/PROJECT_V6.md` §6. Work tags after V6.2: `3d-p2`, `struct-p1`, `struct-p1b`, `3d-p3`.
- **Study branches, kept for reference:** `v5-split-projection` (the split projection: merged in V5.1, reverted in V6.1) and `v5-gym-L` (the L-shaped gym study, rejected in V5.1, adopted in V6.2).

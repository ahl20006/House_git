# House_git · Taif / Palm House

Concept design of a two-storey courtyard house in Taif, drawn with [Typst](https://typst.app) from CSV room data.

**Current version: V7.1** (git tag `v7.1`, GitHub Release "V7.1").
- **Both floors are designed:**
  - the 1.55 m west projection over the courtyard and the double-height void, on an edge beam and three columns at x 5.80 (the V5.0 columns solution, restored in V6.1 after the split projection of V5.1–V6.0 was reverted; widened in V7.0);
  - an L-shaped gym: the long arm along the south facade and a treadmill arm at the east end along the suite bedroom wall, with acoustic separation; the suite court is 11.97 m².
- **V7.1:** the courtyard enclosure windows get semicircular heads in black steel with divided lites (six on the gallery edge, two on the family living's edge, one large one over the living's courtyard glass) and the courtyard gets a three-arch arcade under the projection (two slender stone columns, decorative): a two-tier classical arcade.
- **V7.0 (the big decisions of the design review):** the conditioned house closed round the open courtyard with black steel divided-lite windows (option A: the gallery edge, the family living's edge, the living's upper courtyard side; the gallery 1.405 m clear); the maid room to the municipal minimum (7.28 m² clear, the kitchen's north wall at y 7.0); the main stair continued to the roof into a stair room; a flat roof with a honey-stone main cornice, a set-back attic 1.8 m on the north block and a plain parapet on the south wing (a stepped roofline); the design language (`taif_house/docs/DESIGN_LANGUAGE.md`); the review status in `output/Design_Review_status_V7.pdf`. The next items are in `taif_house/docs/NEXT_SESSION.md`.
- **V6.3 (quick fixes from the design review, tag `review-1`):** the living's west wall solid with the TV arch and the entrance arch (no arches between the colonnade columns); the lift installed at construction; bedroom and bathroom doors 1.00 m openings; the suite bath window 0.55 m (X3 resolved); the 3D with the study's slab thicknesses; the house 0.30 m further south (provisional). (Resolved in V7.0: the courtyard enclosure, the maid room, roof access.)
- **Walls on walls:** the first-floor walls stand on the ground-floor walls (0.785 m from the M line), so no M-line approval is needed. The open items are in `taif_house/docs/OPEN_ITEMS.md`.
- **Start here:** `taif_house/docs/NEXT_SESSION.md`. The whole house is described in `taif_house/docs/PROJECT_V7.md`.

**For engineers and anyone without git:** open the **[Releases](../../releases)** page and download **V7.1**:
- the A3 presentation set `Taif_House_V7.1_presentation.pdf` (12 sheets: site, both floors, the family part, the L and the master suite, the two ground-floor blocks, sections and light, area schedules, decisions log, open items, the roof plan, the elevations);
- the design review's status `Design_Review_status_V7.pdf`;
- the three DXFs (`taif_ground_floor_V7.1.dxf`, `taif_first_floor_V7.1.dxf`, `taif_roof_V7.1.dxf`).

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
  docs/                    NEXT_SESSION.md (start here), PROJECT_V7.md (master document), DETAILS.md (construction notes), OPEN_ITEMS.md, README_DXF.md
  output/                  all PDFs and both DXFs (generated, committed)
  3d/                      the 3D model, generated from the project files (build_3d.py → GLB, viewer.html, check_3d.py, README_3D.md)
  archive/                 superseded files: earlier drawings, PDFs, DXFs, room lists and docs (archive/docs/)
```

## Compile, check, regenerate
- **Tools:** Typst 0.15 (`typst`), Python 3.12 with `pip install ezdxf`, and `pdftotext` (on Windows it comes with Git for Windows in `C:\Program Files\Git\ucrt64\bin`), all on PATH.
- **Compile one file** (the `--root` lets the studies reach `../base.typ` and `../data`):
  ```
  typst compile --root taif_house taif_house/design_ff.typ taif_house/output/design_ff.pdf
  typst compile --root taif_house taif_house/presentation.typ taif_house/output/Taif_House_V7.1_presentation.pdf
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
- **Tags:** `v3.1` … `v3.4`, `v4.0` (ground floor final), `v4.1` (first-floor baseline), `v5.0` (first floor designed), `v5.1` (split projection), `v6.0` (clean release), `v6.1` (the split projection reverted to the V5.0 columns solution), `v6.2` (the L-shaped gym), `v6.3` (the quick fixes from the design review), `v7.0` (the courtyard enclosure, the maid room, roof access and the attic, the design language), `v7.1` (current: the arched enclosure windows and the courtyard arcade). The changelog is in `taif_house/docs/PROJECT_V7.md` §6. Work tags: `3d-p2`, `struct-p1`, `struct-p1b`, `3d-p3`, `air-p1`, `air-p2`, `3d-char1`, `3d-char2`, `review-1`; the branch `work` carries the work between releases.
- **Study branches, kept for reference:** `v5-split-projection` (the split projection: merged in V5.1, reverted in V6.1) and `v5-gym-L` (the L-shaped gym study, rejected in V5.1, adopted in V6.2).

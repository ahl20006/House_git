# House_git · Taif / Palm House

Concept design of a two-storey courtyard house in Taif, drawn with [Typst](https://typst.app) from CSV room data.

**Current version: V9.0, the layout freeze** (git tag `v9.0`, GitHub Release "V9.0", 6 Nov 2026).
- **V9.0:** the layout frozen (room positions, sizes, stairs, wet rooms, the site position); the house set out on site by the owner (day 1, the diagonals exact) and its final position (1.24 + 0.50 m further south, B1 5.49 m from peg M1); the cut wall 0.12 m shorter after the field reading of 2.30 m (0.42 m from the boundary wall as built, 0.90 m from the deed setback line); the whole-farm base v2 (the deed is the boundary authority) with the old house and its majlis, the covered parking, the water tanks and the septic placed (approximate, to be measured); bedroom 1 the young children's room without an en-suite. The review status is `Design_Review_status_V9.0.pdf`; the field record `taif_house/docs/SITE_SETOUT.md`.
- **V8.3:** bedroom 2's en-suite and a family WC upstairs; the ground-floor powder room (no ground-floor shower); the level courtyard with movable seating, the fountain and tree in front of the kitchen window, the TV moved south; the outdoor kitchen by the service door; the plumbing decisions (external east stack, trap primers, rain / sewage separate); the facade principle R-37; bedroom 1's hotel en-suite studied, not applied. The interim V&V review is `output/VV_Review_V8.3.pdf`; the review status `output/Design_Review_status_V8.3.pdf`.
- **V8.2:** the main stair flipped (option B) with the larger family bath F-b, the coat cupboard and the lobby; bedroom 1 without a private bath; the ground-floor shower deferred to the plumbing study (P1 preferred); the suite court's south side a mashrabiya; the clerestories openable; the food route accepted; the site and services plan (`taif_house/studies/site_plan.typ`: single 4 m gate, the north parking kept, the guest stone path, the south family garden, the service yard and gas cabinet, the existing water tank and the reserved tank east of peg R, the existing septic outside the wall near C1, PV provision without a generator, intercom and cameras); the plumbing study rounds 1–2 (`taif_house/studies/plumbing.typ`, proposals). The review status is in `output/Design_Review_status_V8.2.pdf`.
- **V8.1:** the roof by a maintenance ladder in a recess of the gym's east wall in the suite court (behind a locked walnut panel); the office for the owner only, reached from the suite court (visitors are met in the men's majlis); the roofline lowered and balanced (the attic 1.40 m, the south-wing parapet 0.70 m with a set-back 1.10 m guardrail); the outdoor kitchen relocated; one site entry (the farm's 4 m main gate); the fire study updated (the main stair plus the escape windows). The stair flip study (`taif_house/studies/stair_flip.typ`) was adopted in V8.2.
- **V8.0 (six owner decisions of 1 Nov 2026):** fire safety at home level; the courtyard layout (the seating one step down, the TV wall with a stone surround and the malqaf grille below it, a water and tree enclosure, no pergola) and the kitchen sink window moved north; the air system v3.1 (one tower, two separate paths: the courtyard breeze and the HRV's intake with the unit in the tower's base on the roof); the internal stair stops at the first floor; the south wing v2 (the gym on the west band, a 25 m² suite court, the office on the east).
- **V7.1:** the arched courtyard enclosure windows and the three-arch courtyard arcade. **V7.0:** the courtyard enclosure (option A), the maid room to the municipal minimum, the flat roof with the main cornice and the set-back attic, the design language. **V6.3:** the quick fixes of the design review.
- **Both floors are designed:** the 1.55 m west projection over the courtyard and the double-height void on an edge beam and three columns at x 5.80; walls on walls (0.785 m from the M line).
- **Start here:** `taif_house/docs/NEXT_SESSION.md`. The whole house is described in `taif_house/docs/PROJECT_V9.md`; the open items in `taif_house/docs/OPEN_ITEMS.md`.

**For engineers and anyone without git:** open the **[Releases](../../releases)** page and download **V9.0**:
- the A3 presentation set `Taif_House_V9.0_presentation.pdf` (12 sheets: the site and services plan, both floors, the family part, the south wing and the master suite, the two ground-floor blocks, sections and light, area schedules, decisions log, open items, the roof plan, the elevations);
- the review status `Design_Review_status_V9.0.pdf` and the set-out sheet `setout.pdf` (the tapes for the site);
- the whole farm `whole_farm.pdf`, the site and services plan `site_plan.pdf` and the plumbing study `plumbing.pdf` (studies, proposals);
- the three DXFs (`taif_ground_floor_V9.0.dxf`, `taif_first_floor_V9.0.dxf`, `taif_roof_V9.0.dxf`).

Each release is a frozen version; `main` always holds the latest work.

## How the repo is organised
```
taif_house/
  base.typ                 site, envelope, palms, checks, drawing engine (fixed)
  design_gf.typ            ground floor  ← data/rooms_gf.csv        (also the building placement, used by the first floor)
  design_ff.typ            first floor   ← data/rooms_ff.csv        (checked room for room against the two first-floor studies)
  presentation.typ         the A3 presentation set, 12 sheets, English + Arabic notes, every number from the files
  data/                    rooms_gf.csv, rooms_ff.csv (one row per room; # at the start of a name switches a row off),
                           decisions.csv (decisions log), open_items.csv (open items)
  studies/                 ff_family.typ (first floor: family part), ff_suite.typ (the south wing and the master suite),
                           fire_escape.typ, courtyard_layout.typ, air_system.typ, south_wing.typ, roof.typ, structure.typ, courtyard_enclosure.typ, stair_flip.typ,
                           bedroom1_bath.typ, gf_shower.typ, site_plan.typ, plumbing.typ (studies),
                           guest_wing.typ (west wash block), east_wing.typ (east service block),
                           sections.typ (levels, the west projection and its columns, light check, sections; imported, not compiled alone),
                           setout.typ (the set-out sheet), whole_farm.typ (the farm on the site base v2), shift_south.typ, cut_wall.typ (the final position),
                           site_test.typ + building.csv (superseded by setout.typ)
  tools/                   check.py (check everything), make_dxf.py / make_dxf_ff.py / make_dxf_roof.py (the three DXFs),
                           schedule.py (ground-floor room schedule in Markdown)
  docs/                    NEXT_SESSION.md (start here), PROJECT_V9.md (master document), SITE_SETOUT.md (the field record), DETAILS.md (construction notes), OPEN_ITEMS.md, README_DXF.md,
                           REQUIREMENTS.md, DESIGN_LANGUAGE.md, AIR_SYSTEM.md, STRUCTURE_STUDY.md, PENDING_CHANGES.md, review/ (the design review and its status)
  output/                  all PDFs and the three DXFs (generated, committed)
  3d/                      the 3D model, generated from the project files (build_3d.py → GLB, viewer.html, check_3d.py, README_3D.md)
  archive/                 superseded files: earlier drawings, PDFs, DXFs, room lists and docs (archive/docs/)
```

## Compile, check, regenerate
- **Tools:** Typst 0.15 (`typst`), Python 3.12 with `pip install ezdxf`, and `pdftotext` (on Windows it comes with Git for Windows in `C:\Program Files\Git\ucrt64\bin`) or `pip install pypdf` as the PDF text reader, all on PATH.
- **Compile one file** (the `--root` lets the studies reach `../base.typ` and `../data`):
  ```
  typst compile --root taif_house taif_house/design_ff.typ taif_house/output/design_ff.pdf
  typst compile --root taif_house taif_house/presentation.typ taif_house/output/Taif_House_V9.0_presentation.pdf
  ```
- **Check everything:** `python taif_house/tools/check.py` must end with **ALL CHECKS PASSED**. It:
  - compiles every drawing, the studies, the presentation and the archived first-floor drawing;
  - reads the PDFs' check lines and confirms the presentation has 12 A3 sheets;
  - compares the ground-floor studies with the CSV;
  - rebuilds the three DXFs and compares their areas with the CSVs;
  - checks the open items against `docs/OPEN_ITEMS.md`, and that no old version label is left in the active files;
  - rebuilds the 3D model and runs its checks (`3d/check_3d.py`).
- **DXFs only:** `python taif_house/tools/make_dxf.py`, `make_dxf_ff.py` and `make_dxf_roof.py` (see `taif_house/docs/README_DXF.md`).

## Versions
- **Tags:** `v3.1` … `v3.4`, `v4.0` (ground floor final), `v4.1` (first-floor baseline), `v5.0` (first floor designed), `v5.1` (split projection), `v6.0` (clean release), `v6.1` (the split projection reverted to the V5.0 columns solution), `v6.2` (the L-shaped gym), `v6.3` (the quick fixes from the design review), `v7.0` (the courtyard enclosure, the maid room, roof access and the attic, the design language), `v7.1` (the arched enclosure windows and the courtyard arcade), `v8.0` (fire safety, the courtyard layout, the air system, the south wing v2), `v8.1` (a checkpoint: the roof ladder, the lowered roofline, the office from the suite court), `v8.2` (a checkpoint: the stair flip, the site plan, the plumbing studies), `v8.3` (a checkpoint: bedroom 2's en-suite, the powder room, the level courtyard, the outdoor kitchen, the plumbing decisions), `v9.0` (current, the layout freeze: the site set out and the final position, the cut wall −0.12 m, the whole farm, bedroom 1 for young children). The changelog is in `taif_house/docs/PROJECT_V9.md` §7. Work tags: `3d-p2`, `struct-p1`, `struct-p1b`, `3d-p3`, `air-p1`, `air-p2`, `3d-char1`, `3d-char2`, `review-1`; the branch `work` carries the work between releases (reset to `main` after each release).
- **Study branches, kept for reference:** `v5-split-projection` (the split projection: merged in V5.1, reverted in V6.1) and `v5-gym-L` (the L-shaped gym study, rejected in V5.1, adopted in V6.2, replaced by the south wing v2 in V8.0).

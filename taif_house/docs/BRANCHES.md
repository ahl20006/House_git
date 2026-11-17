# Branches · what goes where (owner, 17 Nov 2026)

Three branches in `ahl20006/House_git`:

| Branch | What it holds | Who reads it | Rules |
|---|---|---|---|
| `work` | The daily design work: the room data, the plans, every study, the presentation, the tools, the 3D, the documentation, `docs/PENDING_CHANGES.md`, and `package_src/` (the sources of the delivery package) | the designer | Commit every round here; lean mode: touch only the files of the round, list the rest in `PENDING_CHANGES.md`. Nothing is deleted from `work` without the owner's word. |
| `archive` | The full history and every study, as `work` stood at each hand-over | the designer, the record | Fast-forward it to `work`'s head at every hand-over (`git checkout archive && git merge --ff-only work && git push`). Never rebased. The old releases stay reachable through their tags (`v5.0` … `v10.0`) and this branch. |
| `main` | **The delivery package only**: `README.md` (English + Arabic index) and `package/` (the presentation, the two plans, the site and set-out sheets, the DXFs, the room schedule, the decisions summary, the structural brief, the MEP brief, the 3D renders) | the design reviewer, the engineering office | No studies, no code, no data, no temp files. One commit per issue, replacing the previous package; a tag per issue (`V10.1-preview`, `V11.0`, …). Its history and its old tags (the releases up to `v10.0`) stay untouched. |

## How the package is built

On `work`: `python taif_house/package_src/build_package.py <out_dir>` compiles the presentation, the two floor plans, the site plan and the set-out sheet (merged into one PDF), regenerates the three DXFs, writes the room schedule (CSV + PDF from the presentation's schedule), compiles the decisions summary and the two briefs (`package_src/*.typ`, the presentation's style), copies the existing 3D renders and the README. Then, in a separate worktree of `main` (`git worktree add <dir> main`): `git rm -r .`, copy `<out_dir>/package` and `<out_dir>/README.md`, commit, tag, push `main` and the tag, remove the worktree.

The package's sources stay on `work` under `package_src/`; the texts of the briefs are hand-written and must be re-read against `docs/PENDING_CHANGES.md` and `data/open_items.csv` before each issue.

## The issues
- **V10.1-preview (17 Nov 2026):** built from `work` at `6d8ddda` (the twin bedrooms applied) plus the package sources; the 3D renders of before 15 Nov 2026.
- **V11.0 (17 Nov 2026, the light release):** the north-east corner as one step and the house 1.3 m south everywhere (the plans, the site and set-out sheets, the roof plan and the elevations, the DXFs, the 3D rebuilt with the 10–17 Nov changes and re-rendered), the studies the build does not need removed from `work` (below), one open list (`docs/OPEN_LIST.md`). Status: design development, not for construction.

## What stays on `work` (the build needs it)
`base.typ`, `design_gf.typ`, `design_ff.typ`, `presentation.typ`; `studies/ff_family.typ`, `ff_suite.typ`, `east_wing.typ`, `guest_wing.typ` (the room studies the plans and the presentation read), `sections.typ`, `roof.typ`, `site_plan.typ`, `setout.typ` (the set-out sheet), `structure.typ` and `air_system.typ` (the 3D reads them); `docs/review/` (the review documents); `tools/`, `3d/`, `package_src/`, `data/`, `docs/`, `archive/` (the old drawings `tools/check.py` compiles as a test).

## Archived studies (branch `archive`)
Removed from `work` at V11.0 with their PDFs; every one is at `archive:taif_house/studies/<name>.typ` (and its PDF in `archive:taif_house/output/`), last commit `a4775c6` or later on `archive`:
`site_test.typ` (superseded by `setout.typ`), `whole_farm.typ` (the whole farm with the old buildings; its page 3 the 1.3 m preview), `courtyard_enclosure.typ`, `courtyard_layout.typ`, `courtyard_haven.typ`, `malqaf_outlet_B.typ`, `malqaf_tower.typ`, `malqaf_L5.typ` (the adopted L5 study), `ne_corner.typ`, `cut_wall.typ`, `shift_south.typ`, `placement_steps.typ`, `rotation_b2.typ`, `south_wing.typ`, `stair_flip.typ`, `fire_escape.typ`, `bedroom1_bath.typ`, `bedroom1_ensuite.typ`, `gf_shower.typ`, `plumbing.typ`, `kids_room.typ`, `east_wing_ff.typ` (M3 adopted), `west_wing_ff.typ` (the twins adopted), `step_corner.typ` (option 6 adopted), `maid_wing.typ` (layout D adopted); the 3D study scripts `3d/malqaf_variants.py` and `3d/malqaf_L5_views.py` with their renders; `output/sections.pdf`, `output/Design_Review_V6.pdf` (the V6 review, in the archive).
To read one: `git show archive:taif_house/studies/<name>.typ > …` or check out `archive`.

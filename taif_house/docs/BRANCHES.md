# Branches · what goes where (owner, 17 Nov 2026)

Three branches in `ahl20006/House_git`:

| Branch | What it holds | Who reads it | Rules |
|---|---|---|---|
| `work` | The daily design work: the room data, the plans, every study, the presentation, the tools, the 3D, the documentation, `docs/PENDING_CHANGES.md`, and `package_src/` (the sources of the delivery package) | the designer | Commit every round here; lean mode: touch only the files of the round, list the rest in `PENDING_CHANGES.md`. Nothing is deleted from `work` without the owner's word. |
| `archive` | The full history and every study, as `work` stood at each hand-over | the designer, the record | Fast-forward it to `work`'s head at every hand-over (`git checkout archive && git merge --ff-only work && git push`). Never rebased. The old releases stay reachable through their tags (`v5.0` … `v10.0`) and this branch. |
| `main` | **The delivery package only**: `README.md` (English + Arabic index) and `package/` (the presentation, the two plans, the site and set-out sheets, the DXFs, the room schedule, the decisions summary, the structural brief, the MEP brief, the 3D renders) | the design reviewer, the engineering office | No studies, no code, no data, no temp files. One commit per issue, replacing the previous package; a tag per issue (`V10.1-preview`, …). Its history and its old tags (the releases up to `v10.0`) stay untouched. |

## How the package is built

On `work`: `python taif_house/package_src/build_package.py <out_dir>` compiles the presentation, the two floor plans, the site plan and the set-out sheet (merged into one PDF), regenerates the three DXFs, writes the room schedule (CSV + PDF from the presentation's schedule), compiles the decisions summary and the two briefs (`package_src/*.typ`, the presentation's style), copies the existing 3D renders and the README. Then, in a separate worktree of `main` (`git worktree add <dir> main`): `git rm -r .`, copy `<out_dir>/package` and `<out_dir>/README.md`, commit, tag, push `main` and the tag, remove the worktree.

The package's sources stay on `work` under `package_src/`; the texts of the briefs are hand-written and must be re-read against `docs/PENDING_CHANGES.md` and `data/open_items.csv` before each issue.

## The first issue · V10.1-preview (17 Nov 2026)

Built from `work` at `6d8ddda` (the twin bedrooms applied) plus the package sources. Status: design development, not for construction; the site study (the step instead of the slanted wall, the length, the south shift) still open; the 3D renders outdated (before 15 Nov 2026).

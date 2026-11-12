# Setting up a new Windows computer for this repository

Written 12 Nov 2026 from the computer the project was built on (Windows 11, Typst 0.15.1, Python 3.10, Git 2.56). Everything below is free. Allow about an hour, most of it downloads.

## 1 · Install

| What | Why | How |
|---|---|---|
| **Git for Windows** | the repository, Git Bash (the scripts below assume Bash paths) | <https://git-scm.com/download/win>, defaults are fine |
| **Visual Studio Code** | the editor; Claude Code's extension runs in it | <https://code.visualstudio.com> |
| **Tinymist** (VS Code extension) | Typst language support and the live PDF preview | VS Code → Extensions → search "Tinymist Typst" |
| **Typst 0.15 or later** | compiles every drawing (`.typ` → PDF / PNG); the `cetz` package downloads itself on the first compile | `winget install --id Typst.Typst` (or the release zip from <https://github.com/typst/typst/releases>, put `typst.exe` on the PATH) |
| **Python 3.10 or later** | the checks, the DXFs, the 3D model | <https://www.python.org/downloads/windows/>, tick "Add python.exe to PATH" |
| Python packages | `tools/check.py`, the DXF makers, `3d/build_3d.py` | `pip install ezdxf shapely numpy pyyaml trimesh mapbox_earcut pypdf pillow` |
| **pdftotext** (optional) | `check.py` reads the compiled PDFs with it; without it the script falls back to `pypdf`, which is installed above | the xpdf command-line tools <https://www.xpdfreader.com/download.html>, or skip it |
| **Claude Code** | the assistant that did the work; it reads `CLAUDE.md` and `docs/` on start | <https://claude.com/claude-code> (the VS Code extension or the CLI); sign in with the same account |
| Microsoft Edge | only for the headless 3D renders (`3d/render_views.py`) | already on Windows |

Fonts: the drawings use Segoe UI and Arial (on every Windows). The Arabic text uses the same fonts.

## 2 · Clone and switch to the working branch

```
cd %USERPROFILE%\Desktop
git clone https://github.com/ahl20006/House_git.git house_project
cd house_project
git checkout work
git log --oneline -3
```

`main` holds the releases (the last one V10.0, 9 Nov 2026). **`work` holds everything since** (the owner's ground-floor review rounds, the courtyard H2, the kids'-room and east-wing studies). The backup tag `backup-2026-11-12` marks the last commit made on the old computer. Set your name and email once: `git config user.name "…"` and `git config user.email "…"`.

The design lives in `taif_house/`. Open that folder in VS Code (or the repository root; the compile commands below are written for the root).

## 3 · Compile

Every drawing compiles on its own with `--root taif_house` (the files read `/data/*.csv` from that root):

```
typst compile --root taif_house taif_house/presentation.typ taif_house/output/Taif_House_V10.0_presentation.pdf
typst compile --root taif_house taif_house/design_gf.typ taif_house/output/design_gf.pdf
typst compile --root taif_house taif_house/studies/east_wing_ff.typ taif_house/output/east_wing_ff.pdf
```

A PNG of one sheet (for a quick look): add `--format png --ppi 150 --pages 2` and give a `.png` output name. In VS Code, Tinymist's preview needs the root set: Settings → Tinymist → "Root Path" = `taif_house`.

## 4 · Quick checks

Each drawing prints its own result in the PDF. After a compile, look for the line:

| File | The line that must appear |
|---|---|
| `design_gf.typ` | `All checks passed` |
| `studies/courtyard_layout.typ` | `Study checks passed` |
| `studies/maid_wing.typ` | `Maid wing study checks passed` |
| `studies/east_wing.typ` | `no overlaps` |
| `studies/guest_wing.typ` | `no overlaps, no gaps` |
| `studies/air_system.typ` | `checks passed` |
| `studies/kids_room.typ` | `Checks A: passed` |
| `studies/east_wing_ff.typ` | `L1: passed … K3: passed` |
| `presentation.typ` | 12 sheets (count the pages) |

and nothing saying `WARNING` or `CHECKS FAILED`. In Git Bash with pdftotext: `pdftotext taif_house/output/design_gf.pdf - | grep -c "All checks passed"`.

**The full check** (compiles everything, rebuilds the DXFs and the 3D, takes a few minutes; it must end with `ALL CHECKS PASSED`):

```
python taif_house/tools/check.py
```

## 5 · How we work (the short version)

- Work on `work`; `main` only at a release. Commit often with a one-line message; push after every round.
- Every change not yet folded into the documentation, the presentation, the DXFs or the 3D is one row in `taif_house/docs/PENDING_CHANGES.md`. Clear the table at the release.
- "LEAN" rounds touch only the files the owner lists, compile only those, and record the rest in `PENDING_CHANGES.md`.
- Start a session by reading `taif_house/docs/NEXT_SESSION.md`.

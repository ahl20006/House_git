"""check.py · Taif / Palm House V6.2 · one command to check the whole design before you stop or push.

Run from anywhere:   python taif_house/tools/check.py
It
  1. compiles every drawing into output/ (design_gf, design_ff, the studies incl. the structural study, the presentation) and the archived first-floor drawing
     into a temporary folder (any error is a problem), and reads the PDFs (pdftotext) for their "all checks passed" lines;
  2. checks the presentation: A3, 10 sheets;
  3. compares every room of studies/guest_wing.typ and studies/east_wing.typ with data/rooms_gf.csv;
  4. rebuilds both DXFs (tools/make_dxf.py, tools/make_dxf_ff.py) and reads them back: same rooms, same areas as the two CSVs;
  5. checks that every open item of data/open_items.csv is in docs/OPEN_ITEMS.md, and that the active files carry no old version label;
  6. rebuilds the 3D model (3d/build_3d.py) and runs its own checks (3d/check_3d.py: rooms enclosed, walls, slab areas, outline, levels);
and ends with "ALL CHECKS PASSED" or a list of problems (exit code 1). Needs typst, pdftotext and ezdxf.
"""
import ast
import csv
import math
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent          # taif_house
OUTPUT = ROOT / "output"
VERSION = "V6.2"
problems = []


def ok(msg):
    print("  ok  " + msg)


def bad(msg):
    print("  !!  " + msg)
    problems.append(msg)


def area(P):
    return abs(sum(P[i][0] * P[(i + 1) % len(P)][1] - P[(i + 1) % len(P)][0] * P[i][1] for i in range(len(P)))) / 2


def rect(x, y, w, d):
    return [(x - w / 2, y - d / 2), (x + w / 2, y - d / 2), (x + w / 2, y + d / 2), (x - w / 2, y + d / 2)]


def same_poly(P, Q, tol=0.002):
    return len(P) == len(Q) and all(any(math.dist(p, q) <= tol for q in Q) for p in P)


def read_csv(name):
    with open(ROOT / "data" / name, encoding="utf-8", newline="") as f:
        return [r for r in csv.DictReader(f) if r.get("name", "x") and not r.get("name", "").startswith("#")]


def csv_poly(r):
    pts = [s.strip() for s in (r.get("pts") or "").split(";") if s.strip()]
    if len(pts) >= 3:
        return [tuple(float(v) for v in s.split()) for s in pts]
    return rect(*(float(r[k]) for k in ("x", "y", "w", "d")))


# ---------- 1: compile and read the check lines ----------
print("1. Compile")
PRESENTATION = OUTPUT / f"Taif_House_{VERSION}_presentation.pdf"
jobs = [   # (source, output, lines the PDF must contain)
    ("design_gf.typ", OUTPUT / "design_gf.pdf", ["All checks passed"]),
    ("design_ff.typ", OUTPUT / "design_ff.pdf", ["All checks passed", "matches the two studies room for room"]),
    ("studies/site_test.typ", OUTPUT / "site_test.pdf", []),
    ("studies/guest_wing.typ", OUTPUT / "guest_wing.pdf", ["All rooms inside the block, no overlaps, no gaps"]),
    ("studies/east_wing.typ", OUTPUT / "east_wing.pdf", ["All rooms inside the block, no overlaps"]),
    ("studies/ff_family.typ", OUTPUT / "ff_family.pdf", ["All rooms inside the zone"]),
    ("studies/ff_suite.typ", OUTPUT / "ff_suite.pdf", ["All rooms inside the zone"]),
    ("studies/structure.typ", OUTPUT / "structure.pdf", ["Preliminary structural study"]),
    ("presentation.typ", PRESENTATION, []),
]
tmp = Path(tempfile.mkdtemp())
jobs += [(str(p.relative_to(ROOT)).replace("\\", "/"), tmp / (p.stem + ".pdf"), []) for p in sorted((ROOT / "archive").glob("*.typ"))]   # archived drawings: compile only
typst = shutil.which("typst")
pdftotext = shutil.which("pdftotext")
if not typst:
    bad("typst not found on PATH")
if not pdftotext:
    bad("pdftotext not found on PATH (Git for Windows: C:\\Program Files\\Git\\ucrt64\\bin)")


def pdf_text(path, layout=True):
    return subprocess.run([pdftotext] + (["-layout"] if layout else []) + [str(path), "-"], capture_output=True, text=True, encoding="utf-8", errors="replace").stdout


for src, out, musts in jobs if typst else []:
    r = subprocess.run([typst, "compile", "--root", str(ROOT), str(ROOT / src), str(out)], capture_output=True, text=True, encoding="utf-8")
    errors = [l for l in r.stderr.splitlines() if l.startswith("error")]
    if r.returncode != 0 or errors:
        bad(f"{src} does not compile: {errors[:1] or r.stderr[:200]}")
        continue
    ok(f"{src} compiles → {out.name}" + ("  (archive, compile only)" if src.startswith("archive/") else ""))
    if musts and pdftotext:
        text = pdf_text(out)
        for must in musts:
            if must in text and "WARNING" not in text:
                ok(f"{src}: “{must}”")
            else:
                bad(f"{src}: “{must}” not found (or a WARNING is shown)")
shutil.rmtree(tmp, ignore_errors=True)

# ---------- 2: the presentation ----------
print("2. Presentation")
if PRESENTATION.exists() and pdftotext:
    pages = pdf_text(PRESENTATION, layout=False).count("\f")
    info = PRESENTATION.read_bytes()
    a3 = re.search(rb"/MediaBox\s*\[\s*0\s+0\s+(1190\.\d+|1191(\.\d+)?)\s+(841\.\d+|842(\.\d+)?)\s*\]", info) is not None
    if pages == 10 and a3:
        ok(f"{PRESENTATION.name}: 10 sheets, A3 landscape")
    else:
        bad(f"{PRESENTATION.name}: {pages} sheets, A3 landscape: {a3} (expected 10 sheets, A3)")

# ---------- 3: ground-floor studies against the CSV ----------
print("3. Studies against data/rooms_gf.csv")
rows = {r["name"]: r for r in read_csv("rooms_gf.csv")}


def grab(text, name):
    m = re.search(r"#let\s+" + re.escape(name) + r"\s*=\s*\(", text)
    if not m:
        return ""
    i, depth = m.end() - 1, 0
    for j in range(i, len(text)):
        depth += {"(": 1, ")": -1}.get(text[j], 0)
        if depth == 0:
            return text[i:j + 1]
    return ""


def live(block):
    return "\n".join(l for l in block.splitlines() if not l.strip().startswith("//"))


RECT = r'\(\s*"([^"]+)",\s*(-?[\d.]+),\s*(-?[\d.]+),\s*(-?[\d.]+),\s*(-?[\d.]+),\s*"(\w+)"\s*\)'
POLY = r'\(\s*"([^"]+)",\s*(\((?:\s*\(\s*-?[\d.]+\s*,\s*-?[\d.]+\s*\)\s*,?)+\s*\)),\s*"(\w+)"\s*\)'
studies = {"studies/guest_wing.typ": (0.0, 10.4, 37.4), "studies/east_wing.typ": (8.95, 0.0, 45.54)}   # (dx, dy, rooms total m²)
for src, (dx, dy, total) in studies.items():
    text = (ROOT / src).read_text(encoding="utf-8")
    found = [(n, rect(float(x) + dx, float(y) + dy, float(w), float(d))) for n, x, y, w, d, _ in re.findall(RECT, live(grab(text, "rooms-data")))]
    found += [(n, [(p[0] + dx, p[1] + dy) for p in ast.literal_eval(pts)]) for n, pts, _ in re.findall(POLY, live(grab(text, "poly-rooms")))]
    for n, P in found:
        if n not in rows:
            bad(f"{src}: room “{n}” is not in the CSV")
        elif not same_poly(P, csv_poly(rows[n])):
            bad(f"{src}: room “{n}” differs from the CSV")
    s = sum(area(P) for _, P in found)
    if abs(s - total) < 0.02:
        ok(f"{src}: {len(found)} rooms match the CSV, {s:.2f} m²")
    else:
        bad(f"{src}: rooms add up to {s:.2f} m², expected {total}")

# ---------- 4: both DXFs ----------
print("4. DXF")
try:
    import ezdxf
except ImportError:
    ezdxf = None
    bad("ezdxf not installed (pip install ezdxf)")
for tool, out, csv_name in (("make_dxf.py", f"taif_ground_floor_{VERSION}.dxf", "rooms_gf.csv"), ("make_dxf_ff.py", f"taif_first_floor_{VERSION}.dxf", "rooms_ff.csv")):
    r = subprocess.run([sys.executable, str(ROOT / "tools" / tool)], capture_output=True, text=True, encoding="utf-8", errors="replace")
    if r.returncode != 0:
        bad(f"{tool} failed: " + r.stderr.strip()[-300:])
        continue
    ok(r.stdout.strip())
    if ezdxf is None:
        continue
    want = {r["name"]: area(csv_poly(r)) for r in read_csv(csv_name)}
    seen = {}
    for e in ezdxf.readfile(OUTPUT / out).modelspace().query("LWPOLYLINE"):
        if e.has_xdata("HOUSE"):
            seen[e.get_xdata("HOUSE")[0].value] = area([(p[0], -p[1]) for p in e.get_points("xy")])
    missing = set(want) - set(seen)
    wrong = [n for n in seen if n in want and abs(seen[n] - want[n]) > 0.005]
    if missing:
        bad(f"{out}: rooms missing: {sorted(missing)}")
    if wrong:
        bad(f"{out}: areas differ from {csv_name}: {wrong}")
    if not missing and not wrong:
        ok(f"{out}: {len(seen)} rooms, every area equals {csv_name} ({sum(seen.values()):.2f} m²)")

# ---------- 5: open items and version labels ----------
print("5. Open items and version labels")
items_md = (ROOT / "docs" / "OPEN_ITEMS.md").read_text(encoding="utf-8") if (ROOT / "docs" / "OPEN_ITEMS.md").exists() else ""
items = read_csv("open_items.csv")
lost = [o["key"] for o in items if o["key"].lower() not in items_md.lower()]
if not items_md:
    bad("docs/OPEN_ITEMS.md is missing")
elif lost:
    bad(f"open items not in docs/OPEN_ITEMS.md: {lost}")
else:
    ok(f"all {len(items)} open items of data/open_items.csv are in docs/OPEN_ITEMS.md")
# active files: no V3.x / V4.x / V5.x label, except where the line names the V5.0 columns solution (restored in V6.1), the reverted split projection or a decision's version
active = [p for p in ROOT.rglob("*") if p.is_file() and p.suffix in (".typ", ".py", ".md", ".csv") and "archive" not in p.parts and p.name not in ("PROJECT_V6.md", "decisions.csv")]
active.append(ROOT.parent / "README.md")
old = []
for p in active:
    for i, line in enumerate(p.read_text(encoding="utf-8").splitlines(), 1):
        if re.search(r"\bV[345]\.\d", line) and not re.search(r"fallback|tag v5\.0|tag v6\.0|V5\.0 solution|V5\.0 columns|as in V5\.0|split", line, re.I):
            old.append(f"{p.relative_to(ROOT.parent)}:{i}")
if old:
    bad(f"old version labels in active files: {old[:8]}{' …' if len(old) > 8 else ''}")
else:
    ok(f"no old version labels in {len(active)} active files")

# ---------- 6: the 3D model ----------
print("6. 3D model")
for tool in ("build_3d.py", "check_3d.py"):
    r = subprocess.run([sys.executable, str(ROOT / "3d" / tool)], capture_output=True, text=True, encoding="utf-8", errors="replace")
    last = (r.stdout.strip().splitlines() or [""])[-1]
    if r.returncode != 0:
        bad(f"3d/{tool}: {last or r.stderr.strip()[-300:]}")
        break
    ok(f"3d/{tool}: {last}")

print()
if problems:
    print(f"{len(problems)} PROBLEM(S) — fix before you push")
    sys.exit(1)
print("ALL CHECKS PASSED")

"""check.py · Taif / Palm House · one command to check the design (ground floor V4.0 + first-floor start) before you stop or push.

Run from anywhere:   python taif_house/tools/check.py
It
  1. compiles design_gf.typ, design_ff.typ, studies/site_test.typ and both studies into output/ (any error stops here),
  2. reads the PDFs (if pdftotext is installed) and looks for the "all checks passed" lines,
  3. compares every room of studies/guest_wing.typ and studies/east_wing.typ with data/rooms_gf.csv,
  4. rebuilds output/taif_ground_floor_V4.dxf with tools/make_dxf.py and reads it back: same rooms, same areas as the CSV,
and ends with "ALL CHECKS PASSED" or a list of problems (exit code 1).
"""
import ast
import csv
import math
import re
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent          # taif_house
OUTPUT = ROOT / "output"
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


# ---------- 1 + 2: compile and read the check lines ----------
print("1. Compile")
jobs = [
    ("design_gf.typ", OUTPUT / "design_gf.pdf", "All checks passed"),
    ("design_ff.typ", OUTPUT / "design_ff.pdf", "All checks passed"),
    ("studies/site_test.typ", OUTPUT / "site_test.pdf", None),
    ("studies/guest_wing.typ", OUTPUT / "guest_wing.pdf", "All rooms inside the block, no overlaps, no gaps"),
    ("studies/east_wing.typ", OUTPUT / "east_wing.pdf", "All rooms inside the block, no overlaps"),
]
typst = shutil.which("typst")
pdftotext = shutil.which("pdftotext")
if not typst:
    bad("typst not found on PATH")
for src, out, must in jobs if typst else []:
    r = subprocess.run([typst, "compile", "--root", str(ROOT), str(ROOT / src), str(out)], capture_output=True, text=True, encoding="utf-8")
    errors = [l for l in r.stderr.splitlines() if l.startswith("error")]
    if r.returncode != 0 or errors:
        bad(f"{src} does not compile: {errors[:1] or r.stderr[:200]}")
        continue
    ok(f"{src} compiles → {out.name}")
    if must and pdftotext:
        text = subprocess.run([pdftotext, "-layout", str(out), "-"], capture_output=True, text=True, encoding="utf-8", errors="replace").stdout
        if must in text and "WARNING" not in text:
            ok(f"{src}: “{must}”")
        else:
            bad(f"{src}: “{must}” not found (or a WARNING is shown)")
if not pdftotext:
    print("  ..  pdftotext not installed: open the PDFs and look for the ✓ lines yourself")

# ---------- 3: studies against the CSV ----------
print("2. Studies against data/rooms_gf.csv")
with open(ROOT / "data" / "rooms_gf.csv", encoding="utf-8", newline="") as f:
    rows = {r["name"]: r for r in csv.DictReader(f) if r.get("name") and not r["name"].startswith("#")}


def csv_poly(r):
    pts = [s.strip() for s in (r.get("pts") or "").split(";") if s.strip()]
    if len(pts) >= 3:
        return [tuple(float(v) for v in s.split()) for s in pts]
    return rect(*(float(r[k]) for k in ("x", "y", "w", "d")))


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
    found = []
    for n, x, y, w, d, _ in re.findall(RECT, live(grab(text, "rooms-data"))):
        found.append((n, rect(float(x) + dx, float(y) + dy, float(w), float(d))))
    for n, pts, _ in re.findall(POLY, live(grab(text, "poly-rooms"))):
        found.append((n, [(p[0] + dx, p[1] + dy) for p in ast.literal_eval(pts)]))
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

# ---------- 4: DXF ----------
print("3. DXF")
r = subprocess.run([sys.executable, str(ROOT / "tools" / "make_dxf.py")], capture_output=True, text=True, encoding="utf-8", errors="replace")
if r.returncode != 0:
    bad("make_dxf.py failed: " + r.stderr.strip()[-300:])
else:
    ok(r.stdout.strip())
    try:
        import ezdxf
        doc = ezdxf.readfile(OUTPUT / "taif_ground_floor_V4.dxf")
        seen = {}
        for e in doc.modelspace().query("LWPOLYLINE"):
            if e.has_xdata("HOUSE"):
                tags = e.get_xdata("HOUSE")
                pts = [(p[0], -p[1]) for p in e.get_points("xy")]
                seen[tags[0].value] = area(pts)
        missing = set(rows) - set(seen)
        if missing:
            bad(f"rooms missing in the DXF: {sorted(missing)}")
        wrong = [n for n in seen if n in rows and abs(seen[n] - area(csv_poly(rows[n]))) > 0.005]
        if wrong:
            bad(f"DXF areas differ from the CSV: {wrong}")
        if not missing and not wrong:
            ok(f"taif_ground_floor_V4.dxf: {len(seen)} rooms, every area equals the CSV ({sum(seen.values()):.2f} m² incl. courtyard)")
    except ImportError:
        bad("ezdxf not installed (pip install ezdxf)")

print()
if problems:
    print(f"{len(problems)} PROBLEM(S) — fix before you push")
    sys.exit(1)
print("ALL CHECKS PASSED")

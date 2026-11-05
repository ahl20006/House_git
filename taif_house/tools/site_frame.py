"""site_frame.py · Taif / Palm House · the site baseline v2 in the design frame.

Reads site/inputs/taif_north_zone_final_v2.csv (UTM deed coordinates; the field check of 03 Oct 2026, the SOURCE OF TRUTH for the site)
and writes data/site_v2.csv with every point in the design frame: origin M1 = the gate's east post G', y along the M line southwards
(M1 -> M4), x east, square to it. The source column is kept. The old buildings digitised from the deed sketch (site/inputs/Scanned_20190818-1737.pdf)
are appended from data/deed_sketch.csv when it exists (approximate, +/- 1-3 m).

Usage: python taif_house/tools/site_frame.py        (then base.typ asserts its literals against data/site_v2.csv)
"""
import csv
import math
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "site" / "inputs" / "taif_north_zone_final_v2.csv"
SKETCH = ROOT / "data" / "deed_sketch.csv"
OUT = ROOT / "data" / "site_v2.csv"


def read_v2():
    rows = [r for r in csv.reader(SRC.open(encoding="utf-8-sig")) if len(r) == 5 and r[0].startswith("F")]
    return [(r[0], r[1], float(r[2]), float(r[3]), r[4]) for r in rows]


def frame(rows):
    """The design frame's origin and unit vectors in UTM: M1 and the M line towards M4."""
    pts = {r[1]: (r[2], r[3]) for r in rows}
    m1, m4 = pts["gate east post G' = M1"], pts["M line peg M4 (28.80 m from M1)"]
    de, dn = m4[0] - m1[0], m4[1] - m1[1]
    length = math.hypot(de, dn)
    uy = (de / length, dn / length)        # along the M line, southwards
    ux = (-uy[1], uy[0])                   # square to it, east (towards the lane)
    return m1, ux, uy


def to_design(p, m1, ux, uy):
    e, n = p[0] - m1[0], p[1] - m1[1]
    return round(e * ux[0] + n * ux[1], 3), round(e * uy[0] + n * uy[1], 3)


def main():
    rows = read_v2()
    m1, ux, uy = frame(rows)
    out = [("ref", "item", "x", "y", "easting_m", "northing_m", "source")]
    for ref, item, e, n, src in rows:
        x, y = to_design((e, n), m1, ux, uy)
        out.append((ref, item, f"{x:.3f}", f"{y:.3f}", f"{e:.2f}", f"{n:.2f}", src))
    if SKETCH.exists():
        for r in csv.DictReader(SKETCH.open(encoding="utf-8-sig")):
            e, n = float(r["easting_m"]), float(r["northing_m"])
            x, y = to_design((e, n), m1, ux, uy)
            out.append((r["ref"], r["item"], f"{x:.3f}", f"{y:.3f}", f"{e:.2f}", f"{n:.2f}", r["source"]))
    with OUT.open("w", encoding="utf-8", newline="") as f:
        csv.writer(f).writerows(out)
    heading = math.degrees(math.atan2(uy[0], uy[1])) % 360
    print(f"wrote {OUT.relative_to(ROOT)}: {len(out) - 1} points · M line heading {heading:.1f}° (UTM grid) · frame origin E {m1[0]:.2f} N {m1[1]:.2f}")


if __name__ == "__main__":
    main()

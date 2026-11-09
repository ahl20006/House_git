"""climate_taif.py · Taif / Palm House · the climate basis of studies/malqaf_L5.typ (Phase 0), reproducible.

Downloads (into a cache folder outside the repo) the public hourly records of the Taif station (WMO 41036, Taif Regional Airport,
21.48 N 40.54 E, 1 478 m):
  - Meteostat bulk hourly (https://bulk.meteostat.net/v2/hourly/41036.csv.gz): wind direction / speed, temperature, humidity, 2011–2025;
  - NOAA ISD global-hourly (https://noaa-global-hourly-pds.s3.amazonaws.com/<year>/41036099999.csv): the present-weather codes
    (dust 06–09, 30–35) and the visibility, 2015–2024 (synoptic FM-12 reports only).
and prints the tables the study quotes. Local time = UTC + 3.

    python taif_house/tools/climate_taif.py [cache_dir]
"""
import csv, gzip, math, sys, os, urllib.request, datetime as dt
from collections import defaultdict

CACHE = sys.argv[1] if len(sys.argv) > 1 else os.path.join(os.path.expanduser("~"), ".cache", "taif_climate")
os.makedirs(CACHE, exist_ok=True)
def get(url, name):
    p = os.path.join(CACHE, name)
    if not os.path.exists(p):
        urllib.request.urlretrieve(url, p)
    return p

met = get("https://bulk.meteostat.net/v2/hourly/41036.csv.gz", "41036.csv.gz")
rows = []
for r in csv.reader(gzip.open(met, "rt")):
    try:
        t = dt.datetime.fromisoformat(r[0]) + dt.timedelta(hours=int(r[1]) + 3)
    except (ValueError, IndexError):
        continue
    if not 2011 <= t.year <= 2025:
        continue
    f = lambda i: float(r[i]) if r[i] else None
    rows.append((t, f(2), f(4), f(7), f(8)))
SECT = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
sec = lambda a: SECT[int(((a + 22.5) % 360) // 45)]
band = lambda h: 0 if h < 6 else 1 if h < 12 else 2 if h < 18 else 3
BANDS = ["night 00-06", "morning 06-12", "afternoon 12-18", "evening 18-24"]
W = [x for x in rows if x[4] is not None]
def table(sub_of, keys, names):
    for k, nm in zip(keys, names):
        sub = [x for x in W if sub_of(x) == k]
        nc = [x for x in sub if x[4] >= 2.0 and x[3] is not None]
        cnt = defaultdict(int)
        for x in nc:
            cnt[sec(x[3])] += 1
        print(f"{nm:16s}", " ".join(f"{s}:{100 * cnt[s] / max(1, len(nc)):4.1f}" for s in SECT),
              f"| v {sum(x[4] for x in sub) / len(sub):4.1f} km/h | calm {100 * sum(x[4] < 2.0 for x in sub) / len(sub):4.1f}%")
print("Meteostat rows", len(rows), rows[0][0], "->", rows[-1][0])
print("\nBy month (direction % of non-calm hours; calm < 2 km/h)"); table(lambda x: x[0].month, range(1, 13), [str(m) for m in range(1, 13)])
print("\nBy time of day, all year"); table(lambda x: band(x[0].hour), range(4), BANDS)
W0 = W
W = [x for x in W0 if 5 <= x[0].month <= 9]; print("\nBy time of day, May-Sep"); table(lambda x: band(x[0].hour), range(4), BANDS)
W = [x for x in W0 if x[0].month in (11, 12, 1, 2)]; print("\nBy time of day, Nov-Feb"); table(lambda x: band(x[0].hour), range(4), BANDS)
W = W0
days = defaultdict(list)
for t, T, RH, d, v in rows:
    if T is not None:
        days[t.date()].append(T)
def wb(T, RH):   # Stull 2011 wet-bulb
    return T * math.atan(0.151977 * (RH + 8.313659) ** 0.5) + math.atan(T + RH) - math.atan(RH - 1.676331) + 0.00391838 * RH ** 1.5 * math.atan(0.023101 * RH) - 4.686035
print("\nMonth: Tmax Tmin Tmin-p10 | 15h T RH WB | 21h T RH")
for m in range(1, 13):
    ds = [v for k, v in days.items() if k.month == m and len(v) >= 6]
    mins = sorted(min(v) for v in ds)
    a = [(T, RH) for t, T, RH, d, v in rows if t.month == m and 14 <= t.hour <= 16 and T is not None and RH is not None]
    e = [(T, RH) for t, T, RH, d, v in rows if t.month == m and 20 <= t.hour <= 22 and T is not None and RH is not None]
    av = lambda L, i: sum(x[i] for x in L) / len(L)
    print(f"{m:2d}: {sum(max(v) for v in ds) / len(ds):4.1f} {sum(mins) / len(mins):4.1f} {mins[len(mins) // 10]:4.1f} | {av(a, 0):4.1f} {av(a, 1):3.0f}% {sum(wb(*x) for x in a) / len(a):4.1f} | {av(e, 0):4.1f} {av(e, 1):3.0f}%")
DUST = {"06", "07", "08", "09", "30", "31", "32", "33", "34", "35"}
ddays = defaultdict(set); seat = defaultdict(lambda: [0, 0, 0]); low = 0
for y in range(2015, 2025):
    p = get(f"https://noaa-global-hourly-pds.s3.amazonaws.com/{y}/41036099999.csv", f"isd_{y}.csv")
    for r in csv.DictReader(open(p, encoding="utf-8")):
        if r["REPORT_TYPE"].strip() != "FM-12":
            continue
        t = dt.datetime.fromisoformat(r["DATE"]) + dt.timedelta(hours=3)
        if not 2015 <= t.year <= 2024:
            continue
        dust = bool({(r.get(k) or "").split(",")[0] for k in ("MW1", "MW2")} & DUST)
        if dust:
            ddays[t.month].add(t.date())
            vis = (r.get("VIS") or "").split(",")[0]
            low += vis.isdigit() and int(vis) < 1000
        if 16 <= t.hour <= 23:
            tmp, w = r["TMP"].split(","), r["WND"].split(",")
            T = int(tmp[0]) / 10 if tmp[0] not in ("+9999", "9999") else None
            v = int(w[3]) / 10 * 3.6 if w[3] != "9999" else None
            s = seat[t.month]; s[0] += 1; s[1] += dust
            s[2] += T is not None and v is not None and 20 <= T <= 32 and 7 <= v <= 35 and not dust
print("\nDust days / year by month (ISD present weather 06-09, 30-35; 2015-2024):", {m: round(len(ddays[m]) / 10, 1) for m in range(1, 13)},
      "total", round(sum(len(v) for v in ddays.values()) / 10, 1), "| dust reports with visibility < 1 km:", low)
tot = 0
print("Seating hours 16-23: dust share, pleasant (20-32 C, 7-35 km/h) and dust-free share, hours")
for m in range(1, 13):
    n, d, ok = seat[m]; h = ok / n * 8 * [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][m - 1]; tot += h
    print(f"{m:2d}: {100 * d / n:4.1f}%  {100 * ok / n:3.0f}%  {h:4.0f} h")
print("pleasant and dust-free seating hours per year:", round(tot), "of", 8 * 365)

"""render_views.py · Taif / Palm House · screenshots of the 3D viewer with headless Microsoft Edge (Windows), for the README and the owner.

Run from anywhere:   python taif_house/3d/render_views.py            (or with file names to render only those)
Writes to 3d/output/:
  the plain model (character=0): view_nw.png, view_se.png (overviews), plan_gf.png, plan_ff.png, plan_air.png (orthographic plans with the
  room names), eye1.png … eye3.png (eye-level bookmarks, 1.6 m above the floor), sun_summer_09.png … sun_winter_15.png (plans with shadows);
  the character study (style study, provisional; the sun and its shadows from character.yaml): char_eye2 (the courtyard looking west
  to the colonnade), char_living (inside the double-height living looking to the TV wall's opposite, the courtyard and the sunken
  seating), char_night (the courtyard at night). Other views (street, north, aerial_sw, eye1, eye3) can be rendered by name:
  python render_views.py char_street.png (name = char_<view>.png).
Needs Edge (or Chrome: set BROWSER below). The viewer renders from the embedded GLB, so no server is needed.
"""
import re
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
BROWSER = [p for p in (r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe", r"C:\Program Files\Google\Chrome\Application\chrome.exe") if Path(p).exists()]
if not BROWSER:
    raise SystemExit("no Edge / Chrome found")
VIEWS = {"view_nw.png": "view=nw", "view_se.png": "view=se", "plan_gf.png": "view=top_gf", "plan_ff.png": "view=top_ff",
         "eye1.png": "view=eye1", "eye2.png": "view=eye2", "eye3.png": "view=eye3", "plan_air.png": "view=top_air"}
for season in ("summer", "winter"):
    for hour in ("09", "12", "15"):
        VIEWS[f"sun_{season}_{hour}.png"] = f"view=top&sun={season}-{hour}&labels=0"
VIEWS = {k: v + "&character=0" for k, v in VIEWS.items()}          # the plain phase-3 model
VIEWS.update({"char_eye2.png": "view=eye2&character=1", "char_living.png": "view=living&character=1", "char_night.png": "view=night&character=1",
              "char_north.png": "view=north&character=1", "char_aerial_sw.png": "view=aerial_sw&character=1", "char_tv.png": "view=tv&character=1"})   # the character study; V7.0: the north facade, the aerial, the TV wall
only = sys.argv[1:]          # optional: render only these files (any char_<view>[_arches].png name works, e.g. char_street.png, char_eye1_arches.png)
for name in only:
    m = re.fullmatch(r"char_(\w+)\.png", name)
    if m and name not in VIEWS:
        VIEWS[name] = f"view={m.group(1)}&character=1"
for name, query in VIEWS.items():
    if only and name not in only:
        continue
    out = HERE / "output" / name
    out.unlink(missing_ok=True)
    url = (HERE / "viewer.html").as_uri() + "?" + query + "&ui=0"
    for attempt in (1, 2):   # headless Edge occasionally hangs on a view: kill it after the timeout and try once more
        try:
            # --timeout (real time) rather than --virtual-time-budget: with virtual time, Edge 156 never finishes a WebGL page that animates
            r = subprocess.run([BROWSER[0], "--headless=new", "--disable-gpu", "--use-angle=swiftshader", "--enable-unsafe-swiftshader", "--hide-scrollbars",
                                "--window-size=1400,900", "--timeout=15000", f"--screenshot={out}", url], capture_output=True, text=True, timeout=240)
        except subprocess.TimeoutExpired:   # Edge sometimes writes the screenshot and then fails to exit: keep the file
            print(f"timeout on {name} (attempt {attempt}){' · screenshot written anyway' if out.exists() else ''}")
            if out.exists():
                break
            continue
        if out.exists():
            break
    if not out.exists():
        print("failed:", name)
        sys.exit(1)
    print("wrote", out.relative_to(HERE.parent.parent))

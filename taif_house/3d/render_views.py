"""render_views.py · Taif / Palm House · screenshots of the 3D viewer with headless Microsoft Edge (Windows), for the README and the owner.

Run from anywhere:   python taif_house/3d/render_views.py
Writes to 3d/output/: view_nw.png, view_se.png (overviews), plan_gf.png, plan_ff.png (orthographic plans with the room names),
eye1.png … eye3.png (eye-level bookmarks, 1.6 m above the floor), sun_summer_09.png … sun_winter_15.png (plans with shadows).
Needs Edge (or Chrome: set BROWSER below). The viewer renders from the embedded GLB, so no server is needed.
"""
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
only = sys.argv[1:]          # optional: render only these files
for name, query in VIEWS.items():
    if only and name not in only:
        continue
    out = HERE / "output" / name
    out.unlink(missing_ok=True)
    url = (HERE / "viewer.html").as_uri() + "?" + query + "&ui=0"
    for attempt in (1, 2):   # headless Edge occasionally hangs on a view: kill it after the timeout and try once more
        try:
            r = subprocess.run([BROWSER[0], "--headless=new", "--disable-gpu", "--use-angle=swiftshader", "--enable-unsafe-swiftshader", "--hide-scrollbars",
                                "--window-size=1400,900", "--virtual-time-budget=8000", f"--screenshot={out}", url], capture_output=True, text=True, timeout=240)
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

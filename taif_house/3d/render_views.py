"""render_views.py · Taif / Palm House · screenshots of the 3D viewer with headless Microsoft Edge (Windows), for the README.

Run from anywhere:   python taif_house/3d/render_views.py
Writes 3d/output/view_nw.png (north-west), view_se.png (south-east), view_top_noroof.png (from above, roof hidden).
Needs Edge (or Chrome: set BROWSER below). The viewer renders from the embedded GLB, so no server is needed.
"""
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
BROWSER = [p for p in (r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe", r"C:\Program Files\Google\Chrome\Application\chrome.exe") if Path(p).exists()]
if not BROWSER:
    raise SystemExit("no Edge / Chrome found")
VIEWS = {"view_nw.png": "view=nw", "view_se.png": "view=se", "view_top_noroof.png": "view=top&roof=0"}
for name, query in VIEWS.items():
    out = HERE / "output" / name
    url = (HERE / "viewer.html").as_uri() + "?" + query + "&ui=0"
    r = subprocess.run([BROWSER[0], "--headless=new", "--disable-gpu", "--use-angle=swiftshader", "--enable-unsafe-swiftshader", "--hide-scrollbars",
                        "--window-size=1400,900", "--virtual-time-budget=6000", f"--screenshot={out}", url], capture_output=True, text=True)
    if not out.exists():
        print("failed:", name, r.stderr[-300:])
        sys.exit(1)
    print("wrote", out.relative_to(HERE.parent.parent))

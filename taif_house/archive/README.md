# archive/ · superseded files

Kept for reference only; nothing in the current design or tools reads them (`tools/check.py` only compiles the archived drawing). Git keeps every earlier state as well (tags `v3.1` … `v6.3`).

| File | What it was | Superseded by |
|---|---|---|
| `rooms_C1.csv` | room list of the early concept C1 (V1–V2: courtyard 6 × 5, men's majlis 10 × 5.5) | `data/rooms_gf.csv` |
| `design_v3.4.pdf`, `design_v3.4.dxf` | drawing and DXF of design V3.4 (the last state before the ground-floor freeze) | `output/design_gf.pdf`, `output/taif_ground_floor_V6.3.dxf` |
| `building_options_Z3_Z4_V3.csv` | site-test rows for options Z3, Z4 (V3.0/V3.1), Z4 Rev 02 (V3.2) and Z4 V3.3 | `studies/building.csv` |
| `design_ff_V4.1.typ` | first-floor drawing V4.1 (baseline, 17 Oct 2026); compiles from here (`typst compile --root taif_house taif_house/archive/design_ff_V4.1.typ out.pdf`), reading `rooms_ff_V4.1.csv` | `design_ff.typ` + `studies/ff_family.typ`, `studies/ff_suite.typ` |
| `rooms_ff_V4.1.csv` | first-floor room list V4.1 | `data/rooms_ff.csv` |
| `zones_ff_V4.1.csv` | first-floor zoning options A / B (17 Oct 2026) | the current first-floor layout |
| `Taif_House_V5.1_presentation.pdf` | the V5.1 presentation set (A4, 9 sheets) | `output/Taif_House_V6.3_presentation.pdf` |
| `taif_ground_floor_V5.1.dxf` | the V5.1 ground-floor DXF | `output/taif_ground_floor_V6.3.dxf` |
| `docs/GROUND_FLOOR_V4.md` | master description of the ground floor (V4.0 with the V5.0 and V5.1 changes) | `docs/PROJECT_V6.md` |
| `docs/FIRST_FLOOR_BRIEF.md` | first-floor brief, programme, zoning and layouts (V4.1 → V5.1) | `docs/PROJECT_V6.md` |
| `docs/notes.md` | decisions log, version by version (V3.1 → V5.1) | `docs/PROJECT_V6.md` (decisions, changelog), `data/decisions.csv` |
| `docs/DETAILS.md` | construction notes (V5.0 / V5.1) | `docs/DETAILS.md` (V6.3) |
| `docs/VARIANT_SP.md` | the split-projection study record (accepted in V5.1) | `docs/PROJECT_V6.md` §4.15 |
| `Taif_House_V6.0_presentation.pdf`, `taif_ground_floor_V6.0.dxf`, `taif_first_floor_V6.0.dxf` | the V6.0 set (split projection) | the V6.3 files in `output/` |
| `Taif_House_V6.1_presentation.pdf`, `taif_ground_floor_V6.1.dxf`, `taif_first_floor_V6.1.dxf` | the V6.1 set | the V6.3 files in `output/` |
| `Taif_House_V6.2_presentation.pdf`, `taif_ground_floor_V6.2.dxf`, `taif_first_floor_V6.2.dxf` | the V6.2 set (the L-shaped gym; before the design review's quick fixes) | the V6.3 files in `output/` |
| `Taif_House_V6.1_presentation.pdf`, `taif_ground_floor_V6.1.dxf`, `taif_first_floor_V6.1.dxf` | the V6.1 set (rectangular gym) | the V6.2 files in `output/` |

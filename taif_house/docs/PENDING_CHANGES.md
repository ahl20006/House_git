# Pending changes (branch `work`)

One line per change made on the `work` branch since the last release, not yet folded into the documentation, the presentation, the DXFs or the 3D. Fold them in at the next version and clear this table.

**Cleared at V9.1 (8 Nov 2026):** the 10 entries of 8 Nov 2026 (the house moved to B1 6.00 m from M1; the cut wall shortened again; the record studies kept at their geometry; the set-out sheet re-issued; the site re-checked with the swept path; the soakaways moved; the levels note; the small fixes; the decision row; the fold-in list) are folded into `PROJECT_V9.md` (§1, §2, §3, §4.61, §5 and the changelog §7), `OPEN_ITEMS.md`, `SITE_SETOUT.md`, `NEXT_SESSION.md`, `README_DXF.md`, the READMEs, the 3D, the presentation V9.1, the DXFs V9.1 and the review status V9.1.

**Cleared at V9.0, V8.3, V8.2 and V8.1:** see `PROJECT_V9.md` §7.

| Date | What | Why | Files |
|---|---|---|---|
| 8 Nov 2026 | The utility room (G13) labelled on the presentation's plans (the "core" rooms other than the stair had no label) | owner: it showed no name | `presentation.typ` |
| 8 Nov 2026 | The low store door under the stair's half landing labelled "store" | owner | `design_gf.typ`, `presentation.typ` |
| 8 Nov 2026 | The air tower back to a modest RECTANGLE: 8.95–10.375 × 0–1.0 on axes (1.43 m², was the whole cut tip 1.78 m²), 1.20 × 0.75 = 0.90 m² clear (the breeze shaft 0.54, the airtight partition, the HRV intake compartment 0.28); its east face a new 200 mm wall on x 10.375; its head still +9.80; the 3D shaft opening 0.98 m² (was 1.25) | owner: not a triangle, ≈ 0.90 m² clear | `design_gf.typ`, `studies/air_system.typ`, `studies/ff_family.typ`, `studies/roof.typ`, `3d/build_3d.py`, `3d/check_3d.py` |
| 8 Nov 2026 | The wedge between the tower and the cut wall given to the rooms: the maid bath (a shelf niche; 4.94 m² on axes, 3.85 clear, was 3.68) and bedroom 1 above (a shelf cupboard; 18.01 m² on axes, 15.91 clear, was 15.74); the maid room does not touch the tower (8.41 m² clear, unchanged) | owner: the leftovers to the rooms | `data/rooms_gf.csv`, `data/rooms_ff.csv`, `studies/east_wing.typ`, `studies/ff_family.typ`, `studies/ff_suite.typ`, `studies/plumbing.typ`, `studies/gf_shower.typ`, `tools/check.py` |
| 8 Nov 2026 | The HRV base on the roof kept to its V9.0 footprint (5.84 m², was 6.49 at V9.1): its cut face 0.24 m inside the cut facade | owner: no larger than at V9.0 | `studies/air_system.typ`, `studies/roof.typ`, `3d/params.yaml` |
| 8 Nov 2026 | The structure note: B15 / R9 1.43 m (was 2.05); a new 200 mm wall on x 10.375 against C30; the slabs closed over the wedge | the rectangular tower | `studies/structure.typ` |
| 8 Nov 2026 | The east wing study's overlap test takes the maid bath (no longer convex) as two convex parts | the wedge | `studies/east_wing.typ` |
| 8 Nov 2026 | The attic 2 cm lower: 1.38 m above the roof finish, coping +8.68 (was +8.70): hidden again from the north boundary (13 mm below the cornice's sight line, was 7 mm above); the condensers (+8.60) and the tank (+8.30) stay hidden; the roof check back to "hidden" | the V9.1 hairline | `studies/roof.typ`, `studies/sections.typ`, `studies/structure.typ`, `3d/params.yaml`, `3d/character.yaml`, `presentation.typ` |
| 8 Nov 2026 | At the release (V9.2): fold into `PROJECT_V9.md` (§2 the tower, §3 the schedules, §7 the changelog) | — | `docs/PROJECT_V9.md` |

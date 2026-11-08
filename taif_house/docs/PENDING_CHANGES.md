# Pending changes (branch `work`)

One line per change made on the `work` branch since the last release, not yet folded into the documentation, the presentation, the DXFs or the 3D. Fold them in at the next version and clear this table.

**Cleared at V9.2 (8 Nov 2026):** the 9 entries of 8 Nov 2026 (the utility room's label; the store door's label; the rectangular air tower; the wedge to the maid bath and bedroom 1; the HRV base at its V9.0 footprint; the structure note; the east wing study's overlap test; the attic 2 cm lower; the fold-in list) are folded into `PROJECT_V9.md` (§3, §4.10, §4.38 and the changelog §7), `NEXT_SESSION.md`, `README_DXF.md`, the READMEs, the 3D, the presentation V9.2 and the DXFs V9.2.

**Cleared at V9.1, V9.0, V8.3, V8.2 and V8.1:** see `PROJECT_V9.md` §7.

| Date | What | Why | Files |
|---|---|---|---|
| 8 Nov 2026 | New study: the malqaf tower (STUDY ONLY, the design files unchanged): a slim shaft 0.575 × 1.565 m clear (0.90 m²: breeze 0.54, service 0.30) hugging the cut wall, the maid bath and bedroom 1 with one straight wall parallel to the cut, a store / cupboard north of y 1.0; the HRV unit in a plant room behind the attic; a 1.25 m square stone tower set back on the attic's corner; six variants (heads a / b / c, 2.5 / 3.5 m above the attic, flat or dome) compared; recommendation (c) at 3.5 m with a flat Hijazi cornice; Arabic summary | owner: the present tower looks like a box on a box and its shaft makes awkward corners | `studies/malqaf_tower.typ` → `output/malqaf_tower.pdf`, `tools/check.py` (its job) |
| 8 Nov 2026 | New tool: the gate-view renders of the tower variants (the current model with the present head and its HRV base taken out, the roofline rebuilt round the new tower, the variant added; a temporary viewer copy, the char_gate camera, cropped) | the study's renders | `3d/malqaf_variants.py` → `3d/output/malqaf_gate_*.png` (6) |
| 8 Nov 2026 | Malqaf tower study, pages 6–7: where the tower stands (STUDY ONLY): four positions (the NE cut corner, the courtyard's NE corner in the women's majlis, the west band beside the west shaft, over the kitchen) compared on the breeze route and flow, the HRV intake's separations, the rooms and walls, the structure, the roof, the view from the gate, the street and the courtyard, the cost; recommendation: keep the NE cut corner with the breeze channel at its full width (no throat); the courtyard corner the strong alternative; Arabic summary | owner: compare the tower's location | `studies/malqaf_tower.typ` → `output/malqaf_tower.pdf` |

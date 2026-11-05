# Site set-out · field instructions and results · تعليمات التوقيع في الموقع ونتائجه

Taif / Palm House · V8.3 with the owner's site decision of 4 Nov 2026 (the house 1.238 m further south: corner B1 exactly 5.00 m from M1). Sheet: `studies/setout_v83.typ` → `output/setout_v83.pdf` (page 1 the test on the land, page 2 the tape table). Every value below is taken from that sheet; if a value here ever differs from the sheet, **the sheet is right**. Concept only: the official survey fixes the wall faces.

Frame: origin M1 (the gate's east post) · y along the M line southwards · x east, square to the M line. Corners are the **outer wall faces**. Tapes in metres, read to the centimetre.

## 1 · The method · الطريقة

Two tapes from two fixed points: swing each tape and draw its arc on the ground; the corner is where the two arcs cross **on the house side** (east of the driveway). Drive a peg, mark the point on it, and only then move to the next corner.

**WARNING · تنبيه:** two arcs cross at **two** points, and where the arcs run nearly tangent the crossing is poorly defined. **Always confirm a new corner with a third distance or a diagonal** before setting the next corner from it (day 1: B4 was first set at the wrong crossing, 5.5 m off, and B3 at a tangent crossing, 2.1 m off; both caught by the diagonals from B1).

## 2 · Reference points on site · النقاط المرجعية

| Point | What | Position (x, y) | Use |
|---|---|---|---|
| **M1** | the main gate's east post | 0.00, 0.00 | the origin: every tape 1 starts here |
| **D** | the dakka corner | −5.49, 27.89 | every tape 2 starts here |
| **R** | reference peg R (v2 field check, least-squares fitted: a reference point, no longer the ± 2 m helper of v1) | −1.19, 35.05 (on the driveway, 8.35 m from D) | tapes 3 from R check every corner; also usable for setting out |
| **S** | reference peg S (v2 field check, least-squares fitted) | 16.27, 34.48 (in the build land, 5.5 m from palm 2) | tapes 4 from S check every corner |
| M2, M3, M4 | the old pegs on the M line | gone | M4 is re-established in step 3 |

Tape distances between the reference points (model): M1 → D 28.43 · M1 → R 35.07 · D → R 8.35 · M1 → S 38.13 · D → S 22.74 · R → S 17.47. Source: `data/site_v2.csv` (the site baseline v2 in the design frame, written by `tools/site_frame.py`).

## 3 · Base check · الفحص الأساسي

1. **M1 → D = 28.43 m.** Measured 4 Nov 2026: **28.50 m** (+0.07 m, 0.25 %): accepted within the concept tolerance.
2. **Re-establish M4** on the M line: from M1 **28.80 m**, from D **5.56 m** (the two tapes meet on the M line, south of the gate).
3. **M4 → the trunk faces:** palm 1 ≈ **20.35 m**, palm 2 ≈ **21.34 m** (± 0.3 m). Within the tolerance → the frame sits on the ground. (The brief's 20.36 / 21.35 came from the field CSV's palm positions; the sheet uses `base.typ`: 1 cm apart, within the tolerance.)

## 4 · Target table · جدول الأهداف (outer wall faces, the new position)

Verified against the sheet: every value equal.

| Corner | Where | x east | y along M | Tape 1 from M1 | Tape 2 from D |
|---|---|---|---|---|---|
| **B1** | north-west corner | 0.79 | 4.94 | **5.00** | **23.79** |
| **B2** | north end of the cut wall (north-east) | 11.04 | 4.94 | **12.09** | **28.28** |
| **B3** | east end of the cut wall (the east wall starts) | 14.35 | 11.03 | **18.10** | **26.03** |
| **B4** | south-east corner | 14.35 | 29.19 | **32.52** | **19.88** |
| **B5** | south-west corner | 0.79 | 29.19 | **29.20** | **6.41** |

Check tapes from R and S (v2 fitted pegs; use them to confirm every corner set from M1 and D):

| Corner | from R | from S |
|---|---|---|
| B1 | 30.17 | 33.35 |
| B2 | 32.49 | 30.00 |
| B3 | 28.60 | 23.52 |
| B4 | 16.60 | 5.63 |
| B5 | 6.18 | 16.36 |

R → palm 1 / palm 2 trunk face 22.62 / 22.54; S → palm 1 / palm 2 trunk face 7.47 / 5.49.

| Side | m | | Diagonal | m |
|---|---|---|---|---|
| B1–B2 | **10.25** | | B1–B4 | **27.78** |
| B2–B3 | **6.93** | | B2–B5 | **26.33** |
| B3–B4 | **18.16** | | B1–B3 | **14.87** |
| B4–B5 | **13.56** | | | |
| B5–B1 | **24.25** | | **Perimeter** | **73.15** |

String check (method B on the sheet): string M1 → M4, y along the string from M1, 3-4-5 square, x east. The west wall face B1–B5 lies 0.785 m east of the string. A side or a diagonal more than 0.10 m off → re-measure the two corners before anything else.

## 5 · The tightest point check · فحص أضيق نقطة

The nearest wall to a setback line is the **cut wall B2–B3** at the lane notch: the tightest point lies at x 13.37, y 9.23 (**M1 → 16.25 m, D → 26.53 m**), **0.79 m** inside the setback line (model).

- From that point, measure **square to the lane wall** (the farm's boundary wall on the lane). Expected from the sheet: **≈ 2.97 m** (the brief's ≈ 2.8 m was an estimate; the sheet's value governs).
- **Less than 2.00 m = stop and report** (the house would be in the setback: do not set out further).

## 6 · R and S · الأوتاد المساعدة

Measure from R and from S to the two nearest corners (B5 and B4 for R) and to both palm trunk faces; record them in the table. Model values for R, assumed position only: R → B5 19.33, R → B4 24.06, R → palm 1 28.73, R → palm 2 26.83. They are for the record, not for setting out.

## 7 · Field results, day 1 · نتائج الموقع، اليوم الأول

**4 Nov 2026, the owner on site**, with string and two tapes from M1 and D and from the set corners; R and S check-only. All five corners set and checked; the diagonals exact. An excellent result.

| # | Item | Measured (m) | Model (m) | Difference (m) | Note |
|---|---|---|---|---|---|
| 1 | M1 → D | 28.50 | 28.43 | +0.07 | accepted (0.25 %) |
| 2 | M1 → B1 | 5.00 | 5.00 | 0 | the owner's choice (the car test at the gate) |
| 3 | M1 → B5 | 29.30 | 29.20 | +0.10 | accepted |
| 4 | M1 → B2 | 12.16 | 12.09 | +0.07 | accepted (the same +0.07 as M1 → D) |
| 5 | B1 → B2 | 10.25 | 10.25 | 0 | final (the first reading 10.30) |
| 6 | B2 → B3 | 6.93 | 6.93 | 0 | after B2 was re-set |
| 7 | B3 → B4 | 18.16 | 18.16 | 0 | |
| 8 | B5 → B4 | 13.56 | 13.56 | 0 | |
| 9 | B1 → B3 | 14.87 | 14.87 | 0 | the check diagonal of the cut |
| 10 | Diagonal B1 → B4 | 27.78 | 27.78 | 0 | exact |
| 11 | Diagonal B2 → B5 | 26.33 | 26.33 | 0 | exact |
| 12 | Perimeter string round the five blocks | 74.0 | 73.15 | +0.85 | the string runs round the outside of the blocks, plus sag; accepted (the diagonals are exact) |
| 13 | B1 → B5 | adjusted | 24.25 | (+0.25 first) | the first reading 24.50; B1 / B5 adjusted, both corners accepted |
| 14 | M4 from M1 / from D | | 28.80 / 5.56 | | still to do |
| 15 | M4 → palm 1 trunk face | | 20.35 | | still to do (± 0.3; the brief's 20.36) |
| 16 | M4 → palm 2 trunk face | | 21.34 | | still to do (± 0.3; the brief's 21.35) |
| 17 | Tightest point from M1 / from D | | 16.25 / 26.53 | | still to do |
| 18 | Tightest point square to the lane wall | | 2.97 | | still to do; stop below 2.00 |
| 19 | R → B5 / B4 | | 6.18 / 16.60 | | still to do (5 Nov 2026: R is the v2 fitted peg, not the assumed one) |
| 20 | R → palm 1 / palm 2 | | 22.62 / 22.54 | | still to do |
| 21 | S → B4 / B3 | | 5.63 / 23.52 | | still to do (5 Nov 2026: S is the v2 fitted peg) |
| 22 | S → palm 1 / palm 2 | | 7.47 / 5.49 | | still to do |

**Corrections made on site (lessons) · دروس اليوم الأول**

- **B5:** B1 → B5 first read 24.50 m (+0.25), adjusted; an early M1 → B5 reading of 25.30 m was taken from a wrong point, corrected.
- **B4:** first set at the **wrong intersection** of the two arcs (M1 → B4 read 35.94 m against 32.52, ≈ 5.5 m south); re-set from B5 13.56 m and M1 32.52 m; then B1 → B4 = 27.78 m exact.
- **B3:** the first point (tangent arcs from B2 / B4) gave B1 → B3 = 12.77 m, rejected; re-set on the 18.16 m arc from B4 until B1 → B3 = 14.87 m.
- **B2:** B2 → B3 then read 7.50 m (+0.57); B2 re-set from B1 10.25 m and B3 6.93 m; then B2 → B5 = 26.33 m exact.
- The lesson behind all four: two arcs cross twice and a near-tangent crossing is vague; a corner is only set when a third distance or a diagonal confirms it (section 1).

**Status:** all five corners set and checked; the outline is on site. **Still to do:** M4 → both palms (≈ 20.35 / 21.34 m by the sheet, the brief's 20.36 / 21.35; re-establish M4 from M1 28.80 m and D 5.56 m), the tightest-point check, the R and S check distances (rows 19–22), the old house (§ 8), photos.

Tolerances: ± 0.10 m on a corner, ± 0.30 m on the palms (concept). Anything larger: report with the measured numbers before changing the model. The model is not changed by the day-1 results (every difference within the tolerance); the official survey still has the last word (open item 1).

## 8 · The old house, its annex, the covered parking and the water tank · البيت القديم وملحقه والمظلة والخزان (next site visit)

**The owner's answers (5 Nov 2026):** the old house is west of the driveway along the west boundary, as on the deed sketch (confirmed; its corners still to be measured); **the old majlis is part of the old house** (no separate building); the **covered parking for two cars is south of the old house**, west of the driveway; the **existing ground tank is south of the old house, west of the driveway, near peg R** (not in the new house's garden), the reserved tank next to it; the **septic outside the north wall near C1 serves the old house** and takes the new house's drains. Nothing of the farm lies south of the build land.

The scanned deed carries a plan sketch with the old house (a one-storey reinforced-concrete building, *بناء دور مسلح*) and a thin-line annex (*ملحق*, probably the dakka / carport / yard) near plot corner 1 on the west boundary, west of the driveway. They were digitised from the sketch (georeferenced on seven deed corners, rms 1.36 m; checked on the well, 0.84 m, and on D, 1.01 m): **approximate, ± 1–3 m, to be measured on site.** Study: `studies/whole_farm.typ` → `output/whole_farm.pdf`. Model position (design frame): the house envelope ≈ 22.1 × 10.2 m at x −18.2 … −6.0, y 5.6 … 28.5 (the sketch shows an L); the annex ≈ 12.0 × 6.0 m at x −10.8 … −3.8, y 16.6 … 28.7, its south corner about 1 m from D.

Measure each corner by two tapes from the pair given (the pair whose arcs cross nearest to a right angle) and confirm with the third distance. Mark the corners at the outer wall face at ground level.

| # | Corner | Where | Tape 1 | Tape 2 | Check (third tape) | Measured 1 / 2 / check | Note |
|---|---|---|---|---|---|---|---|
| W1 | old house, north-west | x −16.1, y 5.6 | M1 → 17.06 | D → 24.73 | R → 33.05 | | |
| W2 | old house, south-west | x −18.2, y 27.6 | M1 → 33.02 | R → 18.59 | D → 12.72 | | |
| W3 | old house, south-east | x −8.0, y 28.5 | M1 → 29.62 | R → 9.47 | D → 2.63 | | the arcs cross at 118°: the D check is short and decisive |
| W4 | old house, north-east | x −6.0, y 6.5 | M1 → 8.84 | R → 28.92 | D → 21.37 | | |
| A1 | annex, north-east (on the driveway's west edge) | x −3.8, y 16.7 | M1 → 17.11 | D → 11.34 | R → 18.56 | | the M1 / R arcs are near-tangent (159°): use M1 and D, check with R |
| A2 | annex, south-east (≈ the dakka corner D) | x −4.8, y 28.7 | M1 → 29.06 | R → 7.35 | D → 1.01 | | if this is D itself, say so |
| A3 | annex, south-west | x −10.8, y 28.6 | M1 → 30.57 | R → 11.62 | D → 5.41 | | |
| A4 | annex, north-west | x −9.8, y 16.6 | M1 → 19.29 | R → 20.37 | D → 12.10 | | |

Also tape the sides as a check: the house W1–W2 22.1, W2–W3 10.2, W3–W4 22.1, W4–W1 10.2 (diagonals 24.3); the annex A1–A2 12.0, A2–A3 6.0, A3–A4 12.0, A4–A1 6.0. Note on site whether the house is an L (the sketch suggests the west part is deeper), where its doors face, and what the annex is (dakka, carport, yard wall). Then the corners are corrected in `data/deed_sketch.csv` and the whole-farm study recompiled.

**The covered parking and the water tank** (owner, 5 Nov 2026: south of the old house, west of the driveway, near peg R; drawn in `studies/site_plan.typ` at the positions below, **assumed sizes**: the parking 5.5 × 5.5 open to the driveway, the tank 3 × 2.5). Measure the parking's four corners (its roof posts or walls at ground level) and the tank's lid centre and fill point; note the tank's size, its pump and where its pipe runs today.

| # | Point | Where (model) | Tape 1 | Tape 2 | Check (third tape) | Measured 1 / 2 / check | Note |
|---|---|---|---|---|---|---|---|
| P1 | covered parking, north-east (at the driveway) | x −4.5, y 29.2 | D → 1.64 | M1 → 29.54 | R → 6.72 | | D is beside it: the short tape is decisive |
| P2 | covered parking, south-east (at the driveway) | x −4.5, y 34.7 | M1 → 34.99 | R → 3.33 | D → 6.88 | | the arcs cross at 89° |
| P3 | covered parking, south-west | x −10.0, y 34.7 | M1 → 36.11 | R → 8.82 | D → 8.17 | | |
| P4 | covered parking, north-west | x −10.0, y 29.2 | M1 → 30.86 | R → 10.58 | D → 4.70 | | |
| K1 | water tank, fill point (north-east corner) | x −4.5, y 35.7 | D → 7.87 | R → 3.38 | M1 → 35.98 | | the arcs cross at 86° |
| K0 | water tank, lid centre | x −6.0, y 36.95 | D → 9.08 | R → 5.18 | M1 → 37.43 | | |
| K2 | water tank, south-east corner | x −4.5, y 38.2 | D → 10.36 | R → 4.57 | M1 → 38.46 | | |

Also tape: the parking's sides P1–P2 and P3–P4 (model 5.5), P2–P3 and P4–P1 (5.5), the gap from the old house's south wall to the parking, the gap from the parking to the tank (model 1.0), the tank's length and width, the tank's east side to the driveway's west edge (model 0.55). Where the water truck stands today and where the old house's drain enters the septic (and the septic's lids) also go on the sketch.

**Still without data (to be measured when convenient):** the septic (its position near C1, its lids, its inlet level, its capacity for both houses, the old house's connection), the reserved tank's place beside the existing one, where guests park (the brief's farm parking south of the build land is withdrawn), the south gate, the workers' house position, the service gate position.

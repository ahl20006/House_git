# Taif / Palm House · delivery package V10.1-preview

**Status: V10.1-preview · design development, not for construction.** The site study (the step instead of the slanted wall, the length, the south shift) is still open. Issued 17 Nov 2026 from the design files of the `work` branch (commit 6d8ddda and the package sources). Every size is a design value until the engineers confirm it.

This branch (`main`) holds the package only. The full history, every study and the source files are on the `archive` branch; the daily work is on `work`.

| File | What it is | For whom | Status |
|---|---|---|---|
| `package/01_presentation.pdf` | The A3 presentation set, 12 sheets: the site, the two floors, the family part, the south wing and the suite, the wash and service blocks, the sections and the light, the room schedules, the decisions log, the open items, the roof, the elevations | reviewer · both engineers | current (17 Nov 2026) |
| `package/02_ground_floor_plan.pdf` | The dimensioned ground-floor plan on the site with its checks and the furniture studies (5 pages) | reviewer · structural · MEP | current |
| `package/03_first_floor_plan.pdf` | The dimensioned first-floor plan, the room schedule with clear areas, the light check, the west projection sections (5 pages) | reviewer · structural · MEP | current |
| `package/04_site_and_setout.pdf` | The site and services plan (5 pages: the gate, the parking, the paths, the drainage, the chambers, the soakaways, the tanks) + the set-out sheet (2 pages: the corners from the gate post M1 and the dakka corner D) | reviewer · MEP · the surveyor | current; the services positions proposed, to confirm with the survey |
| `package/dxf/taif_ground_floor_V10.0.dxf` | The ground floor in DXF (metres, north up): the site, the outline, every room, doors, windows, fixtures, the first-floor edges above | both engineers | regenerated 17 Nov 2026 from the current data |
| `package/dxf/taif_first_floor_V10.0.dxf` | The first floor in DXF: the outline, every room with its number, the voids, doors, windows, furniture | both engineers | regenerated 17 Nov 2026 |
| `package/dxf/taif_roof_V10.0.dxf` | The roof plan in DXF: the holes, the attic line, the ladder, the guardrails, the reserved zones, the outlets | both engineers | regenerated 17 Nov 2026 (the ladder recess still at its 8 Nov position) |
| `package/05_room_schedule.pdf` · `05_room_schedule.csv` | Every room of both floors: axis size, area on axes, clear area | reviewer · both engineers | current |
| `package/06_decisions_summary.pdf` | The adopted decisions that still stand, in plain English with an Arabic line each (2 pages) | reviewer | current |
| `package/07_structural_brief.pdf` | One list for the structural engineer: the scheme, the grid and columns, the long spans, the malqaf core, the projection and its edge beam, the south wing, the light partitions on the slab, the soil report, the open questions | structural engineer | current |
| `package/08_mep_brief.pdf` | One list for the MEP engineer: the air system (two switches, the dust relay, the filtered fan, no HRV), AC by inverter splits per zone, the drainage stacks, the courtyard and roof rain, the water supply and heaters, greywater from the first floor only, the open questions | MEP engineer | current |
| `package/3d/` | The existing 3D renders (the courtyard, the gate, the suite court, the aerials, the malqaf L5 views) | reviewer | **outdated, before 15 Nov 2026** (the 3D was not rebuilt: it shows the first floor before the east-wing and west-band changes of 14–15 Nov 2026) |

There is no separate site DXF: the site (the land, the envelope, the driveway, the lane, the north wall, the palms, the set-out pegs) is a layer group in the ground-floor and roof DXFs.

**How to read the drawings.** Coordinates in the briefs are the plans' frame: x east, y south, metres, wall centre lines; the outer walls 250 mm, the inner walls 200 mm, partitions 100 mm. Levels GF ±0.00, FF +3.60, roof +7.20 (to confirm). The building stands on the ground-floor outline; the house was set out on site with two tapes (see the set-out sheet).

**What is not in this package:** the studies (the structure, the air system, the plumbing, the roof, the malqaf, the courtyard, the first-floor options), the 3D model and its sources, the tools, the room data and the documentation. They are on the `archive` branch of the same repository, where this package can be rebuilt with `taif_house/package_src/build_package.py` on `work`.

---

# بيت الطائف / بيت النخيل · حزمة التسليم V10.1-preview

**الحالة: نسخة تطوير التصميم، ليست للتنفيذ.** دراسة الموقع (درجة بدل الجدار المائل، طول المبنى، الإزاحة جنوبًا) ما زالت مفتوحة. أُصدرت في 17 نوفمبر 2026 من ملفات التصميم على فرع `work`. كل المقاسات تصميمية حتى يؤكدها المهندسون.

| الملف | ما هو | لمن | الحالة |
|---|---|---|---|
| `01_presentation.pdf` | مجموعة العرض A3، 12 لوحة: الموقع والدوران وجزء العائلة والجناح الجنوبي وكتل الخدمات والقطاعات والمساحات والقرارات والبنود المفتوحة والسطح والواجهات | المراجع والمهندسان | حديث (17 نوفمبر 2026) |
| `02_ground_floor_plan.pdf` | مخطط الدور الأرضي بالأبعاد على الموقع مع فحوصه | المراجع والمهندسان | حديث |
| `03_first_floor_plan.pdf` | مخطط الدور الأول بالأبعاد وجدول الغرف وفحص الإضاءة وقطاعات البروز الغربي | المراجع والمهندسان | حديث |
| `04_site_and_setout.pdf` | مخطط الموقع والخدمات + لوحة التوقيع في الموقع | المراجع ومهندس الخدمات والمساح | حديث؛ مواضع الخدمات مقترحة تُؤكَّد بالرفع |
| `dxf/` | الدور الأرضي والدور الأول والسطح بصيغة DXF (بالمتر، الشمال للأعلى) | المهندسان | مُعاد توليدها في 17 نوفمبر 2026 |
| `05_room_schedule.pdf` و `.csv` | جدول كل الغرف في الدورين: المقاس على المحاور والمساحة على المحاور والمساحة الصافية | المراجع والمهندسان | حديث |
| `06_decisions_summary.pdf` | ملخص القرارات المعتمدة السارية بالإنجليزية مع سطر عربي لكل قرار (صفحتان) | المراجع | حديث |
| `07_structural_brief.pdf` | قائمة واحدة للمهندس الإنشائي: الهيكل والشبكة والأعمدة والبحور الطويلة ونواة الملقف والبروز وجسر الحافة والقواطع الخفيفة وتقرير التربة والأسئلة المفتوحة | المهندس الإنشائي | حديث |
| `08_mep_brief.pdf` | قائمة واحدة لمهندس الخدمات: نظام الهواء والتكييف والصرف والأمطار وتغذية المياه والمياه الرمادية من الدور الأول فقط والأسئلة المفتوحة | مهندس الخدمات | حديث |
| `3d/` | صور النموذج ثلاثي الأبعاد الموجودة | المراجع | **قديمة، قبل 15 نوفمبر 2026** (لم يُعَد بناء النموذج) |

الإحداثيات في الملخصات بإطار المخططات: x شرقًا و y جنوبًا بالمتر على محاور الجدران؛ الجدران الخارجية 25 سم والداخلية 20 سم والقواطع 10 سم. الدراسات والنموذج ثلاثي الأبعاد والأدوات على فرع `archive`.

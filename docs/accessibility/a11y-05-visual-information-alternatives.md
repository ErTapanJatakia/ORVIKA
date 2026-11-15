# A11Y-05 — Accessible alternatives for visual information

**Status:** Source review and implementation guidance prepared; device/browser verification pending  
**Scope:** Dashboard, security findings, status/progress, and any future charts or maps

## Implementation rules

1. Never communicate a security verdict, severity, progress state, or required action through colour, icon, shape, position, animation, or a chart alone.
2. Pair each visual status with visible text and a meaningful semantic label/value. Keep the text concise and consistent with the visual result.
3. Ensure severity names are explicit (for example, “High risk”), not only red/amber/green.
4. Decorative illustrations and icons must not add redundant screen-reader stops. Interactive icons must have localized action names.
5. Any future chart must provide a concise text summary and an accessible data table or equivalent linear representation. Users must not need to interpret colour, hover, or spatial position to obtain the underlying values.
6. Any future map must provide a searchable/list-based location or item alternative, with the same actionable information in a logical reading order. A map is supplementary, not the only route to information.
7. Progress indicators must expose a label, current value, and meaningful range. Updates should be announced without repeatedly interrupting users.
8. Motion must respect the app's reduced-motion preference and Android's system animation setting.

## Current source inventory

- Privacy and Academy expose progress labels and values through Flutter semantics and have regression coverage in `feature_semantics_test.dart`.
- Link, QR, Message and Intelligence workflows expose live-region result/status updates in existing widget tests.
- Link Check, QR Check and Message Check result section titles are explicitly exposed as semantic headings in the current A11Y-04 branch.
- No dedicated map or chart feature was identified in the current `lib/features` source inventory. Do not claim map/chart conformance for components that are not present.

## Required validation

- Inspect every result state with TalkBack and a browser screen reader.
- Verify severity and recommended action are understandable without colour.
- Verify progress value, label, and update frequency.
- If charts/maps are introduced, add text/table or list alternatives and tests in the same feature PR.
- Verify high contrast, 200% text scaling, RTL reading order, and reduced motion.

## Evidence status

All items above are implementation requirements or source-level observations. They are not a completed WCAG conformance assessment. Record exact build, platform, assistive technology, date, and observed result in the A11Y-08 evidence record.

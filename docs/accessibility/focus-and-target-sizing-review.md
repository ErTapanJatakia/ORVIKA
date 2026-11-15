# A11Y-03 — Focus visibility and target sizing review

## Implemented shared baseline

The application theme now explicitly uses Material's padded tap-target mode and standard visual density. Material icon buttons receive a minimum 48 × 48 logical-pixel target through the shared `IconButtonThemeData`.

A widget regression test verifies these shared theme values. This is a component-level baseline, not proof that every interactive control meets WCAG 2.2 SC 2.5.8.

## Required control-by-control review

The following surfaces require rendered-layout inspection because shared theme defaults do not resize arbitrary gesture detectors, custom-painted controls, nested clickable cards, or controls with explicit constraints:

- Language picker rows, search and selection controls
- Dashboard module cards and header actions
- Theme and accessibility settings controls
- Dialog actions, menus, chips, tabs and icon-only affordances
- QR/camera controls and any map/chart interactions
- Any custom drag, swipe, reorder or slider interaction

For each control, record the rendered target dimensions, spacing to adjacent targets, keyboard focus appearance, focus order, and whether a non-drag single-pointer alternative exists.

## Focus verification

The dashboard module card already draws a stronger border while it has keyboard focus. This must be checked in the rendered web and Android interfaces against surrounding surfaces and at 200% text scaling. Other controls still require a full keyboard traversal and assistive-technology review.

Check that focused content is not entirely hidden by sticky headers, dialogs, bottom navigation, or other overlays. A theme-level focus color alone is not sufficient evidence for SC 2.4.7 or SC 2.4.11.

## Evidence still required

- Web: keyboard-only traversal, visible focus screenshots, 320 CSS-pixel reflow, 200% text resize, and browser accessibility-tree checks.
- Android: TalkBack focus traversal, Switch Access navigation, platform text scaling, and physical target inspection on representative devices.
- SC 2.5.7: inspect each drag interaction and provide a tap/click alternative unless dragging is essential.
- SC 2.5.8: verify all applicable targets against the WCAG 2.2 minimum-size and spacing exceptions, rather than relying solely on the shared 48 dp default.

## Status

Implementation baseline added; full control inventory and manual conformance evaluation remain open. No WCAG criterion is marked conformant by this document.

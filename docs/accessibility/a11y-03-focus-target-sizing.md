# A11Y-03 — Focus visibility and target sizing

**Scope:** Flutter web and Android shared UI.  
**Implementation status:** Automated baseline implemented; rendered-browser and physical-target evidence remain separate release checks.  
**Conformance status:** No WCAG criterion is declared conformant by this document.

## Implemented baseline

- Material tap targets use the padded platform baseline and standard visual density.
- Shared Material icon buttons have a minimum 48 × 48 logical-pixel target.
- Dashboard module cards expose keyboard focus through a 2.5 logical-pixel border using the active theme's primary colour.
- Dashboard module cards remain keyboard-focusable and activatable; existing traversal/activation coverage is retained.
- Focused card containers have stable test keys so regression tests do not depend on lazy-list text lookup or first-run onboarding state.

## Regression coverage

The dedicated `test/features/accessibility/focus_target_sizing_test.dart` checks:

1. The resolved icon-button minimum size and padded tap-target mode.
2. The rendered dashboard settings icon action is at least 48 × 48 logical pixels.
3. Tab traversal reaches the Link Check module card.
4. The focused card renders the expected 2.5-pixel active-theme outline.

The test uses a stable dashboard heading as its app-state anchor. It deliberately avoids looking up the first-run language-picker heading after seeding completed-onboarding preferences; this removes the brittle `Bad state: No element` assumption from the earlier draft without weakening any assertion.

## Remaining control-by-control review

The shared Material baseline does not resize arbitrary gesture detectors, custom-painted surfaces, nested click targets, or controls with explicit constraints. Review these rendered surfaces:

- Language picker rows, search and selection controls
- Dashboard module cards and header actions
- Theme and accessibility settings controls
- Dialog actions, menus, chips, tabs and icon-only affordances
- QR/camera controls and map/chart interactions
- Any custom drag, swipe, reorder or slider interaction

For each applicable target, verify actual hit-area dimensions, spacing to adjacent targets, focus visibility, focus order, and whether a single-pointer non-drag alternative exists. Apply WCAG 2.2 SC 2.5.8 exceptions only where their conditions are demonstrably met.

## Validation evidence still required

- **Web:** keyboard-only traversal across primary journeys; screenshots of focus states in all themes; verify focused content is not obscured by sticky headers, dialogs or bottom navigation; check 320 CSS-pixel reflow and 200% text resize.
- **Android:** inspect representative rendered touch targets and focus traversal on physical devices. Existing TalkBack/Switch Access validation is useful evidence but does not itself measure target dimensions.
- **Dragging:** inventory every drag interaction and verify a single-pointer alternative unless dragging is essential.

Do not infer WCAG 2.2 AA conformance from shared theme defaults or widget tests alone.

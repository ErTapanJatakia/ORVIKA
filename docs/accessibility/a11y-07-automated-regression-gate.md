# A11Y-07 — Automated accessibility regression gate

**Status:** Test inventory and gate definition prepared

## CI coverage

The existing Flutter CI already runs static analysis, the Flutter test suite, and a Flutter web build. The accessibility tests under `test/features/accessibility/` are included in the Flutter test suite; they must remain enabled.

The A11Y suite currently covers:
- Feature headings and selected live-region announcements.
- Form-control accessible labels.
- Locale semantics.
- Onboarding and settings headings/search announcements.
- Dashboard keyboard traversal and selected target dimensions.
- Responsive layout simulations and text scaling.
- Dashboard module readability, header/hero, and scrolling/footer regressions.

The current A11Y-04 branch adds semantic-heading assertions for Link, QR and Message Check result sections and exposes QR camera preview/status information to semantics.

## Required gate policy

- Do not delete, skip, quarantine, or weaken an accessibility test to obtain a green build.
- Add deterministic widget tests for app-owned semantics: labels, roles, values, state, headings, live regions, focus restoration, and non-gesture alternatives.
- Keep native Android build validation distinct from web-only/documentation validation. Run Android build validation after a coherent Android implementation batch, not after documentation-only edits.
- Do not treat Lighthouse, axe-core, Flutter widget tests, or automated browser checks as proof of WCAG conformance.
- Preserve manual TalkBack, Switch Access, VoiceOver, keyboard, and visual inspection as explicit release gates.
- When the same CI failure repeats three times, stop repeating the same repair strategy; investigate a different root cause, redesign the test, or defer the affected item without weakening coverage.

## Evidence artefacts

For each CI run, retain the commit SHA, run URL, job conclusions, Flutter version, and test result summary. A passing CI establishes only that the automated checks in that run passed.

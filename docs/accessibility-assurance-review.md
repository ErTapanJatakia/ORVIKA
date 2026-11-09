# ORVIKA Accessibility Assurance Review

Review date: 2026-11-09
Baseline: `main` at the time of review
Status: code-level review completed; real-platform validation not executed

## Purpose and assurance boundary

This review consolidates what the repository currently demonstrates through documentation and automated Flutter tests, and separates that evidence from validation that still requires real browsers, operating systems, devices and assistive technologies.

The review does not certify accessibility, establish WCAG 2.2 AA conformance, or claim that any platform has passed manual assistive-technology testing. The WCAG 2.2 AA target in `docs/accessibility.md` remains a target.

## Evidence reviewed

- `docs/accessibility.md`
- `test/features/accessibility/feature_semantics_test.dart`
- `test/features/accessibility/interaction_validation_test.dart`
- `test/features/accessibility/browser_navigation_focus_test.dart`
- `test/features/accessibility/onboarding_settings_semantics_test.dart`

The Dashboard UX work in PR #58 is paused and is not treated as merged baseline evidence.

## Current automated evidence

| Area | Existing evidence | What it establishes | Boundary |
|---|---|---|---|
| Feature headings | Feature semantics tests | Seven feature screen titles are flagged as semantic headings | Does not prove spoken heading navigation on a screen reader |
| Dynamic analysis results | Link, QR and Message Check semantics tests | Result summaries are represented as live regions in the Flutter semantics tree | Announcement timing, verbosity and interruption behaviour remain unverified on devices |
| Dynamic counts and progress | Intelligence, Privacy and Academy tests | Selected result counts and progress values/updates have labels and live-region semantics | Does not establish consistent announcements across assistive technologies |
| Onboarding and settings | Onboarding/settings semantics tests | Language search, onboarding progress and selected settings headings expose intended semantics | Does not cover every control, route or language/script combination |
| Colour contrast | Interaction validation test | Selected primary, secondary, success, warning and danger accents meet 4.5:1 against each palette's app background and surface | Not a complete inventory of text, links, disabled states, focus indicators, borders or every rendered state |
| Touch targets | Interaction validation test | Two dashboard icon actions meet 48×48 logical-pixel dimensions in the tested widget configuration | Not a complete target-size audit or physical-device touch assessment |
| Keyboard traversal | Interaction and browser-navigation widget tests | Selected dashboard destination supports Tab, Shift+Tab, Enter and Space in Flutter widget tests | Not browser/OS keyboard validation; overlay, dialog, menu and all-screen traversal remain unverified |
| Route focus | Browser-navigation widget test | Returning from one feature route restores focus to its invoking dashboard card in the tested widget environment | Browser history, browser back, route edge cases and real assistive-technology focus announcements remain unverified |

## Gap register and exit criteria

### A. Manual platform validation — outstanding

No manual execution evidence was present in the reviewed repository material for the following combinations:

- Android TalkBack on a supported physical device, including touch exploration, headings, controls, result announcements and navigation across all primary screens.
- Android Switch Access on a supported physical device.
- Windows NVDA with Firefox and/or Chrome against the deployed Web/PWA build.
- Windows Narrator with a supported browser.
- macOS/iOS VoiceOver with Safari on supported devices.
- Browser-only keyboard use, including Tab, Shift+Tab, Enter, Space, visible focus, Escape, dialog dismissal and focus return.
- Browser zoom/reflow at 200% and 400%, narrow viewports, and enlarged system/app text.
- Platform magnification, bold text, high contrast, reduced motion and RTL combinations on actual supported platforms.
- Voice-control activation names and switch navigation where those capabilities are supported.

**Exit evidence:** record device/OS, browser and version, assistive technology and version, viewport/zoom/text scale, test date, expected behaviour, observed output, pass/fail and linked defect for every failed case. A test protocol or CI pass is not execution evidence.

### B. Contrast and visual presentation — partial

The automated contrast test checks five semantic palette accents against two surfaces across the four app palettes. It does not establish contrast for every text/background pair or every interactive state.

**Exit evidence:** complete a rendered-state inventory covering body text, headings, secondary text, links, buttons, icons conveying information, borders, focus indicators, selected/disabled/hover states, status messages and error content in all palettes. Measure actual foreground/background pairs and record exceptions with rationale. Check non-colour cues and focus visibility at relevant zoom/text scales.

### C. Touch and pointer alternatives — partial

The current 48×48 test covers the dashboard language and appearance icon actions only.

**Exit evidence:** inventory actionable controls across onboarding, dashboard, Link Check, QR Check, Message Check, Intelligence, Privacy, Academy, Response and settings. Verify target dimensions and spacing, and confirm that drag/swipe or precision gestures have accessible alternatives.

### D. Keyboard and focus — partial

Widget tests cover selected dashboard traversal and one route return path. They do not establish end-to-end browser behaviour or all overlay/focus scenarios.

**Exit evidence:** complete the browser keyboard protocol in `docs/accessibility.md` for every primary route and interactive overlay. Verify no traps, logical forward/reverse order, visible focus, keyboard activation, Escape/dismissal behaviour where expected, and focus restoration to the invoking control.

### E. Content, localization and reading direction — partial

The reviewed accessibility tests do not establish screen-reader pronunciation, translated accessible names, or complete RTL behaviour across the authored language catalogue.

**Exit evidence:** sample each authored script and RTL language in real supported assistive technologies; verify language metadata, pronunciation, reading order, wrapping, non-clipped controls and non-reversed bidirectional text. Native-speaker review remains a separate localization quality requirement.

### F. Security-result accessibility — implementation intent documented; platform behaviour unverified

The standard requires uncertainty, evidence, severity and recommended next steps to remain available without colour or visual-only cues, and prohibits accessibility presentation from changing security decisions.

**Exit evidence:** manually verify Link, QR and Message Check results with screen readers and enlarged text. Confirm that uncertainty and caveats are exposed, announcements are concise and non-duplicative, and the underlying analysis result is unchanged.

## Execution record

No real-device, browser/screen-reader, Switch Access, VoiceOver, NVDA, TalkBack, magnification or manual contrast execution was performed as part of this repository review. These items remain **not tested**, not passed.

Automated Flutter tests and CI may provide regression evidence for the specific semantics and interactions they exercise. They must not be presented as proof of platform compatibility or WCAG conformance.

## Recommended next sequence

1. Complete a representative physical Android TalkBack and Switch Access pass, recording versions and observed output.
2. Complete Windows browser keyboard and NVDA/Narrator passes against the deployed Web/PWA build.
3. Complete VoiceOver/Safari coverage on an available supported Apple device.
4. Run the full visual contrast, zoom/reflow, text-scale, touch-target and RTL inventories.
5. Convert each reproducible failure into a focused issue and regression test where automation is appropriate.
6. Update this record only with observed evidence; retain explicit not-tested status for unavailable platforms.

## Release communication rule

Until the manual evidence is recorded and gaps are resolved or explicitly accepted, describe ORVIKA as having **automated accessibility regression coverage with manual platform validation outstanding**. Do not claim WCAG 2.2 AA conformance, platform certification, or full screen-reader compatibility.

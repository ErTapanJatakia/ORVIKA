# ORVIKA accessibility focus and target-size consolidation

Status: shared Flutter Material defaults and widget regression coverage added  
Scope: application theme defaults; not a complete rendered-control audit

## Shared implementation

- The app's default text scale is 100%. Existing user-selected text scale remains supported from 50% to 200%, and the platform text scaler is composed rather than replaced.
- Material tap targets use padded sizing and standard visual density.
- Icon, elevated, outlined and text buttons receive a 48 × 48 logical-pixel minimum size through shared theme configuration.
- The shared focus colour token uses the active theme primary colour at 32% alpha.
- Existing dashboard keyboard traversal, focus outline and route-focus restoration behaviour is retained.

## Automated regression evidence

`test/features/accessibility/focus_and_target_size_test.dart` checks the four shared Material button theme styles, minimum dimensions, padded tap-target mode, standard visual density and focus token. Existing tests continue to cover dashboard keyboard traversal, reverse traversal, activation and route focus restoration.

These tests establish theme configuration in Flutter's widget environment. They do not prove that every rendered hit region is 48 × 48, that adjacent targets have sufficient spacing, or that focus remains visible and unobscured in every viewport and theme.

## Controls requiring separate review

Shared button themes do not automatically resize or validate all custom interactions. Inspect language rows, chips, sliders, expansion tiles, camera controls, QR/image pickers, dashboard cards, menus, dialogs, text fields, navigation affordances and any gesture detector. Verify actual hit regions and provide alternatives to drag or precision gestures.

## Manual validation still outstanding

- Web keyboard-only traversal on every primary screen, including Tab, Shift+Tab, Enter, Space, Escape, visible focus and focus return.
- Browser zoom/reflow at 200% and 400%, narrow viewport behaviour and 200% text resize.
- Android TalkBack and Switch Access on supported physical devices.
- NVDA/Firefox or Chrome and Narrator/browser combinations on Windows.
- VoiceOver/Safari on a supported Apple device where available.
- Actual rendered focus contrast, focus obstruction, target dimensions and spacing across all four themes.
- RTL, bold text, high contrast and reduced-motion combinations at enlarged text sizes.

Record the device/OS, browser, assistive-technology versions, viewport/scale, expected behaviour, observed behaviour and pass/fail. A test protocol or widget test is not manual execution evidence.

## Conformance boundary

This implementation is an accessibility baseline, not WCAG 2.2 AA conformance or platform certification. Do not claim full screen-reader compatibility or that every interactive control meets target-size criteria until the outstanding manual and control-by-control checks have been completed.

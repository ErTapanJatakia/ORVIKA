# ORVIKA-14 — Accessibility and responsive assurance increment

Status: integration regression coverage added; test execution and physical-device checks pending  
Review date: 16 November 2026

## Delivered

- Added app-root integration tests for Arabic and Urdu that verify the selected locale is published to the semantics tree and the rendered subtree uses right-to-left directionality.
- Added an English regression to ensure switching to a left-to-right locale does not retain RTL direction.
- Confirmed the app-root composition includes a reading-order focus traversal group and exposes the selected semantics locale.
- Existing dashboard responsive matrix remains the automated viewport/text-scale regression baseline.

## Physical verification protocol

Automated tests do not replace manual verification. Use synthetic content only and record:

| Platform | Required checks | Status |
|---|---|---|
| Android | TalkBack swipe and touch exploration; Switch Access scan/activation; system font/display size; portrait/landscape; camera permission denial; Arabic/Urdu input and mixed-script URLs | Not run |
| Web / Chrome | Keyboard-only traversal; screen-reader names/roles/states; zoom and 320 CSS px reflow; RTL punctuation and URL rendering | Not run |
| Web / Firefox | Same keyboard, screen-reader, reflow and RTL checks | Not run |
| iOS / Safari | VoiceOver traversal, zoom, dynamic type, RTL and QR camera permission/fallback where supported | Not run |

## Evidence rules

- Record device/browser model, OS/browser version, build commit, locale, text scaling, assistive-technology version, steps, expected result and observed result.
- Do not record actual messages, OTPs, phone numbers, personal URLs or account identifiers.
- Mark each check Pass only after it is actually performed on the named platform.
- Do not claim WCAG 2.2 AA conformance or platform certification from widget tests or source inspection.

The new widget tests have not been executed. No physical-device or browser testing was performed in this increment.

# A11Y-08 — Manual and assistive-technology validation record

**Status:** Protocol prepared; physical-device and assistive-technology execution pending  
**No manual test is recorded as passed by source inspection or CI.**

## Test environment record

Complete one record per platform/device combination:

| Field | Value |
|---|---|
| App commit / build number | Pending |
| Platform and OS version | Pending |
| Device model / viewport | Pending |
| Browser and version (web) | Pending / N/A |
| TalkBack / VoiceOver version and settings | Pending / N/A |
| Switch Access configuration | Pending / N/A |
| Font size / display size / text scale | Pending |
| Locale / text direction | Pending |
| Test date and tester | Pending |

## Required manual checks

### Web
- Keyboard-only navigation, visible focus, logical order, focus not obscured, no keyboard trap.
- Screen-reader names, roles, values, headings, landmarks, errors, status messages and dialog focus.
- Reflow at 320 CSS px and 200% text resize; zoom; high-contrast/forced-colour behaviour where supported.
- Pointer target size/spacing, dragging alternatives, consistent help, redundant-entry behaviour and accessible authentication.

### Android
- TalkBack touch exploration and linear navigation through every representative journey.
- Switch Access scanning and activation without touch gestures.
- Android font size and display size, app text scaling, portrait/landscape and RTL.
- Camera permission denial, scanner start/stop, failure and manual paste fallback.
- Dialog/menu focus entry and restoration; live-region announcement clarity and timing.

## Defect/evidence log

| ID | Build / journey | Expected | Observed | Severity | Owner / issue | Retest |
|---|---|---|---|---|---|---|
| — | No physical-device results recorded yet | — | — | — | — | — |

## Privacy-safe testing

Use synthetic URLs, messages, QR payloads, and account-like strings only. Do not capture real OTPs, personal messages, phone numbers, contacts, account IDs, or private URLs. Avoid screen recordings unless necessary and separately approved; redact identifiers before storing evidence.

## Exit criteria

A platform is ready for a conformance decision only after all applicable A/AA criteria have evidence, blocking defects are closed, and representative assistive-technology journeys have been repeated against the release candidate. Web and Android are evaluated independently.

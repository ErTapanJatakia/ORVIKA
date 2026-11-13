# Arabic (ar) full-localization implementation plan

## Product target

Deliver Arabic as a complete, selectable ORVIKA locale using Modern Standard Arabic (العربية الفصحى), with right-to-left presentation. This is a localization workstream, not a change to detection, scoring, parsing, network, privacy, or data-handling behaviour.

Arabic already exists in the unified language catalogue, has a draft shared translation map, has a small feature-translation map, and is included in the app's RTL language-code set. Those foundations do not constitute full localization.

## Required coverage

- First-launch language selection, onboarding, dashboard, navigation, settings, themes, accessibility labels and all shared application strings.
- Every feature screen: Sentinel/dashboard, Link Check, QR Check, Message Check, Intelligence, Privacy, Academy and Response.
- All feature content: 8 Academy lessons, 12 Privacy practices, 5 Response playbooks and 10 Intelligence references.
- All 22 stable checker finding identifiers, finding details, severity labels, result notices and QR/link/message result states.
- Camera and image scanner controls, permissions, instructions, privacy notices, loading states, empty states, errors and diagnostics owned by ORVIKA.
- Dialogs, reset flows, progress announcements, interpolation placeholders and accessibility semantics.
- Framework-owned Material/Cupertino labels where supported, while keeping ORVIKA's custom localization layer coherent.
- RTL layout and mixed-direction content, including URLs, email addresses, phone numbers, code, numbers, punctuation and Latin security identifiers.

## RTL engineering requirements

- Use the existing language-direction metadata rather than adding Arabic-only widget exceptions.
- Audit Directionality propagation through app root, navigation, app bars, drawers, cards, forms, dialogs, bottom sheets, lists, progress indicators and scanner overlays.
- Use direction-aware start/end alignment and padding; avoid left/right assumptions in newly touched UI.
- Preserve LTR rendering for URLs, domains, email addresses, code, hashes, IP addresses and other technical tokens using appropriate bidi isolation/directionality.
- Verify Arabic shaping, diacritics, numerals, punctuation, mixed-script strings, text selection and screen-reader order.
- Confirm the selected Arabic font supports Arabic shaping and fallback glyphs; do not reuse the Urdu Nastaliq font for Modern Standard Arabic.

## Translation and review quality

- Translate meaning, not word-for-word syntax. Preserve security severity, limitations, warnings, privacy claims and response instructions exactly.
- Use consistent Arabic cybersecurity terminology and a maintained glossary across all modules.
- Do not claim native-speaker approval or reviewed status until a qualified Arabic native speaker reviews the complete experience.
- Keep the locale in draft status until full coverage, regression checks, RTL visual review and native-speaker sign-off are complete.

## Milestones

1. Inventory: map every user-visible string, translation key, feature-content record, finding ID, fallback and RTL-sensitive component.
2. Shared application UI: complete the existing Arabic draft pack to the full shared-key baseline; add completeness and placeholder tests.
3. Feature interface: translate and wire every screen, checker, scanner, privacy, accessibility, dialog and error string.
4. Feature content: add Arabic packs for Academy, Privacy, Response and Intelligence, preserving stable IDs, answer indices, severity and content structure.
5. Checker coverage: translate every stable finding title/detail and all result/notice variants without changing analyzer output or severity.
6. RTL hardening: fix direction-aware layout and mixed-direction rendering; add screen-level tests at narrow widths and 200% text scaling.
7. Consolidated validation: run analyzer, focused localization tests, full web tests and web build once the meaningful implementation batch is complete. Android validation remains deferred until the complete app-code batch is ready.
8. Native-speaker review: obtain review of every screen and feature-content pack, resolve findings, and only then promote the locale from draft to reviewed.
9. Release gate: no production deployment until the complete localization batch is merged and the project-wide consolidated release gate is approved.

## Acceptance criteria

- Every required user-facing key resolves to Arabic; no silent English fallback remains in the supported Arabic experience.
- Every Academy, Privacy, Response and Intelligence content record is translated and structurally equivalent to its source.
- All 22 checker finding IDs and all scanner/checker states are translated; stable identifiers, placeholders and severity are unchanged.
- RTL visual and interaction tests pass across all feature screens, including mixed Arabic/Latin content, 320px viewport and 200% text scaling.
- No changes to security analysis, scoring, detection, parsing, network or data handling.
- Qualified native-speaker review is recorded separately from automated CI.
- `hasReviewedTranslation` is not promoted until every gate above is satisfied.

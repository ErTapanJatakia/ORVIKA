# Simplified Chinese (zh-CN) full-app localization plan

## Product target

Deliver Simplified Chinese (简体中文, zh-CN) as a complete, selectable ORVIKA locale. The language is Standard Mandarin Chinese written in Simplified Chinese characters, using mainland-China terminology and conventions. This is a localization workstream only; it must not change detection, scoring, parsing, network, analytics, privacy, storage, or data-handling behaviour.

The locale must remain in draft status until implementation coverage, visual/accessibility checks, and qualified native-speaker review are complete.

## Required coverage

- First-launch language selection, onboarding, dashboard, navigation, settings, themes, accessibility labels and every shared application string.
- Every feature screen: Sentinel/dashboard, Link Check, QR Check, Message Check, Intelligence, Privacy, Academy and Response.
- All curated feature content: 8 Academy lessons, 12 Privacy practices, 5 Response playbooks and 10 Intelligence references.
- All 22 stable checker finding identifiers, finding titles/details, severity labels, result notices and QR/link/message result states.
- Camera and image scanner controls, permissions, instructions, privacy notices, loading states, empty states, errors and diagnostics owned by ORVIKA.
- All privacy disclosures, including analytics disclosure, device/privacy limitations, image/camera processing, local storage, consent and any data-retention statements surfaced in the app.
- Dialogs, reset flows, progress announcements, interpolation placeholders, semantics and screen-reader labels.
- Framework-owned Material/Cupertino labels where supported, while keeping ORVIKA's custom localization layer coherent.
- Technical tokens and mixed-script content: URLs, domains, email addresses, phone numbers, code, hashes, IP addresses, file names, identifiers, numbers and punctuation.

## Language and typography conventions

- Locale code: `zh-CN`; native language label: `中文（简体）`; English label: `Chinese (Simplified)`.
- Use natural, contemporary Simplified Chinese suitable for a broad mainland-China audience; avoid region-specific slang and machine-translated phrasing.
- Maintain a project glossary for cybersecurity, privacy, phishing, social engineering, QR codes, authentication, credentials, incident response and legal/privacy terms.
- Prefer established Chinese cybersecurity terminology; preserve the exact meaning and limits of every security claim and warning.
- Confirm the selected font has complete Simplified Chinese glyph coverage, correct punctuation metrics and offline availability on Web and Android. Prefer a properly licensed Noto Sans CJK SC / Source Han Sans SC asset if a reliable bundled font is needed; inspect repository licensing and asset size before adding it. Do not assume Inter or generic device fallback guarantees consistent Chinese rendering.
- Chinese is left-to-right. Do not add RTL behavior. Ensure mixed Latin/Chinese strings, inline technical tokens, punctuation, line wrapping and text scaling remain readable.

## Milestones

1. Inventory: map all translation keys, feature-content records, finding IDs, hard-coded user-facing strings, privacy notices, fallbacks, placeholders and typography-sensitive components.
2. Shared application UI: add a complete Simplified Chinese shared-string pack and tests for required keys, placeholders and fallback detection.
3. Feature interface: translate and wire every screen, checker, scanner, settings, accessibility, dialog, empty/error/loading and progress string.
4. Feature content: add Chinese packs for all Academy, Privacy, Response and Intelligence records while preserving stable IDs, answer indices, severity, links and content structure.
5. Checker coverage: translate all stable finding titles/details and every result/notice variant without changing analyzer output, IDs or severity.
6. Privacy and trust review: translate every user-facing privacy notice and consent/disclosure statement with exact semantic equivalence; verify no unsupported privacy, security, offline or data-retention promise is introduced.
7. Typography and accessibility: validate Chinese glyph coverage, line-height, punctuation, wrapping, 320px viewport, 200% text scaling, keyboard navigation and screen-reader pronunciation/order on Web and Android.
8. Consolidated validation: run localization-focused checks, Flutter analysis, full tests and Web release build after the meaningful implementation batch. Run Android release validation only after the full app-code batch is complete.
9. Native-speaker review: obtain qualified Simplified Chinese native-speaker review of every screen, feature-content record, checker result and privacy notice; resolve findings and record sign-off. Automated CI is not linguistic certification.
10. Release gate: do not promote to reviewed/selectable-complete status or deploy production until all gates are satisfied and the project owner explicitly authorizes release.

## Acceptance criteria

- Every required user-facing key resolves to Simplified Chinese; no silent English fallback remains in the supported zh-CN experience.
- All 8 Academy lessons, 12 Privacy practices, 5 Response playbooks and 10 Intelligence references are translated and structurally equivalent to their source.
- All 22 checker finding IDs, scanner states and notices are translated; stable identifiers, placeholders, analyzer semantics and severity are unchanged.
- All privacy notices, analytics disclosures, consent text and device/image/camera limitations are translated without changing the underlying disclosure.
- Automated coverage checks demonstrate complete key/content coverage; tests must not be weakened or deleted to obtain a pass.
- Visual/accessibility checks pass across representative narrow and desktop layouts, including 320px width and 200% text scale.
- No changes to security analysis, scoring, detection, parsing, network, analytics or data handling.
- Native-speaker review is recorded separately from automated CI.
- `hasReviewedTranslation` is not promoted until every gate above is satisfied.

## Operational controls

- Keep translation resources offline; do not add machine-translation APIs, telemetry or runtime translation services.
- Preserve existing language preference storage and migration behavior.
- Do not modify Arabic RTL behavior or other locale packs as part of this workstream.
- Do not merge without the project owner's explicit approval.
- Do not initiate production deployment as part of localization implementation.
- Follow the project three-failure rule: after the same CI/test strategy fails three consecutive times, stop repeating it and redesign, work around or defer the issue without weakening/deleting tests.

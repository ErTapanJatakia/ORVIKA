# ORVIKA localization audit — 8 November 2026

## Current architecture

- Localization is implemented in `lib/core/localization/orvika_language.dart` and `orvika_localizations.dart`.
- The language picker is a unified, de-duplicated catalogue built from Russia- and India-focused source catalogues. The current automated test expects 191 selectable language codes.
- ORVIKA uses a custom `OrvikaLanguageScope` and `OrvikaLocalizations` lookup. It does not currently use generated ARB files.
- Flutter Material/Cupertino framework delegates are configured for English and Russian only. The custom ORVIKA language scope is independent of those framework delegates.
- Authored non-English packs are Russian plus Hindi, German, French, Italian, Punjabi, Urdu, Arabic, Marathi, Gujarati and Sanskrit. The latter ten are explicitly classified as draft packs; only English and Russian are marked reviewed.
- Each authored non-English pack currently contains the same 50 application keys. A picker entry is not evidence of translated UI coverage.

## Observed coverage gap

The seven feature presentation screens were inspected:

| Module | Presentation file | Existing localization calls |
|---|---|---:|
| Link Check | `lib/features/link_check/presentation/link_check_screen.dart` | 0 |
| QR Check | `lib/features/qr_check/presentation/qr_check_screen.dart` | 0 |
| Message Check | `lib/features/message_check/presentation/message_check_screen.dart` | 0 |
| Intelligence | `lib/features/intelligence/presentation/intelligence_screen.dart` | Interface labels and guidance headings localized |
| Privacy | `lib/features/privacy/presentation/privacy_screen.dart` | Interface labels and progress framing localized |
| Academy | `lib/features/academy/presentation/academy_screen.dart` | UI chrome, category labels and progress framing localized |
| Response | `lib/features/response/presentation/response_screen.dart` | UI chrome, urgency notice and playbook section labels localized |

Their visible labels, helper text, actions, empty states, dialogs and progress messages are predominantly hard-coded English. The Dashboard is already connected to the localization API for its module labels and shared copy, but feature content is not.

## This implementation increment

- The shared feature app bar resolves the seven known feature titles through existing `module.*` localization keys. Unknown/custom app-bar titles remain unchanged.
- Link Check, QR Check and Message Check resolve their main instructions, input labels/hints, primary actions, result headings, destination/link headings and scope notices through the existing lookup API.
- Intelligence localizes its heading, description, search controls, category filters, result count, empty state, detail-section headings and educational-scope notice. Curated reference entry titles and explanatory content remain canonical English in this increment.
- Privacy localizes its heading, description, category labels, review progress framing and announcements, guidance-section headings, review checkbox and reset tooltip. Detailed practice content and analytics/privacy disclosures remain canonical English to avoid unreviewed translation of nuanced security and data-handling statements.
- Academy localizes its heading, description, category labels, progress framing and announcements, reset action, lesson-section labels, answer feedback and scope notice. Curriculum titles, summaries, key points, questions, answer options and explanations remain canonical English in this increment.
- Response localizes its heading, description, urgent-action banner, scenario category labels, playbook section labels and scope notice. Scenario titles, summaries, recommended actions and detailed playbook steps remain canonical English so incident guidance is not translated without specialist review.
- Russian and Hindi draft packs contain authored strings for the three checker interfaces plus Intelligence and Privacy UI chrome. Other language packs use explicit English fallback until screen-level strings are authored and reviewed. Neither draft pack is promoted to reviewed status.
- Analyzer-generated finding titles, details, normalized addresses and result notices remain canonical analyzer output; this increment does not translate or alter security evidence.
- Widget tests cover Russian Link Check, Message Check, Intelligence and Academy; Hindi QR Check, Privacy and Response; plus English fallback for an unsupported language. Localization contract tests cover Russian/Hindi keys for all seven implemented feature screens and the seven feature titles.

## Remaining implementation work

1. Review remaining dialogs, errors, empty states and checker result framing.
2. Expand screen-level translation coverage beyond Russian and Hindi without changing draft packs to reviewed status.
3. Translate Academy curriculum and Response playbook content only after appropriate subject-matter and native-speaker review.
4. Test language switching across every module, RTL layout (Arabic and Urdu), long strings, narrow viewports and 200% text scaling.
5. Keep security-analysis output, scoring, parsing and data-flow behavior unchanged; this work is presentation-only.
6. Treat automated tests as localization regression evidence, not as proof of translation quality. Native-speaker review remains necessary before promoting draft packs.

## Validation boundaries

No claim of complete localization, native-speaker review, full Material framework translation, or full RTL conformance is made by this audit. Android device and Aurora OS runtime validation remain separate follow-up activities.


## Phase 2 — checker control coverage (9 November 2026)

- Added a dedicated offline feature-translation overlay for the eleven existing authored packs: Russian, Hindi, German, French, Italian, Punjabi, Urdu, Arabic, Marathi, Gujarati and Sanskrit.
- The phase-two key set covers primary Link Check, QR Check and Message Check headings, input labels and primary actions; shared severity labels; and the two QR acquisition actions (camera and selected image).
- QR camera and image acquisition remain opt-in. Only presentation labels changed; camera permission flow, image selection, decoding, analyzer behavior and result semantics are unchanged.
- The image-scanner instruction and image-selection/size/empty-image/no-code/generic decode error copy now resolve through localization keys with explicit English fallbacks. Decoder-provided platform/format diagnostics remain canonical English because their wording originates outside the authored UI copy.
- Added contract tests asserting every phase-two key exists in all eleven authored packs, explicit English fallback for an un-authored language, and RTL metadata for Arabic and Urdu. Widget tests verify French and Arabic QR acquisition labels render.
- Translation packs remain draft where previously classified as draft. No language has been promoted to reviewed status.
- Detailed descriptions, analyzer-generated findings, incident-response instructions, legal/privacy disclosures, Academy curriculum and Intelligence reference content remain outside this increment. These require specialist and native-speaker review before translation.

## Phase 2 validation boundary

Automated coverage verifies key presence and widget rendering, not linguistic correctness, regional appropriateness, typography quality or complete RTL conformance. Human review by fluent speakers remains required. This is a partial expansion of feature UI coverage, not a claim of full localization.


## Phase 2 — extended hard-coded UI review (9 November 2026)

The broader source review extended beyond the three primary checker forms:

- QR camera scanner title, close tooltip, explicit camera-start/requesting labels and stop-camera action now resolve through localization keys.
- QR image scanner title, close tooltip, choose/choose-another, preview fallback, scan progress/action, clear action, detected-code count and result-selection instruction now resolve through localization keys.
- Privacy checklist reset dialog title/body/actions and persistence error messages now resolve through localization keys.
- The shared feature app bar already resolves the known feature titles through the existing `module.*` keys.
- These newly keyed scanner and privacy strings intentionally use explicit English fallback until translations are authored and reviewed. They are no longer untracked literals embedded in widget code, but they are not claimed as translated in the eleven draft packs.
- Scanner permission/error explanations, image-decoder diagnostics, security-analysis findings and the detailed privacy/analytics disclosures remain canonical English. They communicate platform behavior, limitations or data-handling claims and require specialist/native-speaker review before translation.
- Privacy checklist practice titles and guidance are content, not decorative UI chrome; they remain canonical pending review.
- Automated fallback-contract tests cover representative new camera, image and privacy controls. This is not a linguistic-quality test.

### Milestone closure criteria

The Phase 2 implementation can be considered code-complete only when all visible widget-owned controls, titles, dialogs, errors and empty-state labels have a localization key or a documented canonical-English exception; tests cover the key/fallback contract; and CI passes on the final PR head. Translation quality, native-speaker sign-off, complete RTL behavior and physical-device/browser checks remain separate acceptance activities and must not be inferred from CI.


### Audit correction — current Phase 2 head

The initial audit table above records the pre-localization baseline and should be read as a historical snapshot, not the current state. On the current Phase 2 branch, Link Check, QR Check and Message Check already resolve their primary form copy, result headings/notices and severity labels through localization lookup. Their result announcements and QR detected-format label have also now been moved behind localization keys. Scanner controls and Privacy reset/error controls are keyed as detailed above. A key with no authored value intentionally falls back to English; keying and translation coverage are tracked separately.


## Portugal Portuguese implementation batch — 13 November 2026

The distinct `pt-PT` locale has moved beyond the initial selector scaffold. The current draft branch wires the locale through the application interface, checker/scanner controls, accessibility settings and all localized feature-content adapters. Regression coverage includes the 146-key base UI baseline, all 22 checker finding IDs, all feature-content records (8 Academy, 12 Privacy, 5 Response and 10 Intelligence), placeholder interpolation, severity preservation, and screen-level rendering for Academy, Privacy, Response, Intelligence, Link Check, Message Check and QR Check.

Regional terminology adaptation is applied to the Portuguese source strings while preserving Brazilian Portuguese (`pt`) unchanged. This is a complete technical-coverage draft, not a native-reviewed translation. Portugal Portuguese remains unreviewed, and the existing `hasReviewedTranslation` gate is intentionally unchanged. Native-speaker review must validate every screen, security term, legal/privacy notice, error, scanner flow, accessibility label, responsive layout and long-string behavior before promotion.

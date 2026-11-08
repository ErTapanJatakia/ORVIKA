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
| Academy | `lib/features/academy/presentation/academy_screen.dart` | 0 |
| Response | `lib/features/response/presentation/response_screen.dart` | 0 |

Their visible labels, helper text, actions, empty states, dialogs and progress messages are predominantly hard-coded English. The Dashboard is already connected to the localization API for its module labels and shared copy, but feature content is not.

## This implementation increment

- The shared feature app bar resolves the seven known feature titles through existing `module.*` localization keys. Unknown/custom app-bar titles remain unchanged.
- Link Check, QR Check and Message Check resolve their main instructions, input labels/hints, primary actions, result headings, destination/link headings and scope notices through the existing lookup API.
- Intelligence localizes its heading, description, search controls, category filters, result count, empty state, detail-section headings and educational-scope notice. Curated reference entry titles and explanatory content remain canonical English in this increment.
- Privacy localizes its heading, description, category labels, review progress framing and announcements, guidance-section headings, review checkbox and reset tooltip. Detailed practice content and analytics/privacy disclosures remain canonical English to avoid unreviewed translation of nuanced security and data-handling statements.
- Russian and Hindi draft packs contain authored strings for the three checker interfaces plus Intelligence and Privacy UI chrome. Other language packs use explicit English fallback until screen-level strings are authored and reviewed. Neither draft pack is promoted to reviewed status.
- Analyzer-generated finding titles, details, normalized addresses and result notices remain canonical analyzer output; this increment does not translate or alter security evidence.
- Widget tests cover Russian Link Check, Message Check and Intelligence; Hindi QR Check and Privacy; plus English fallback for an unsupported language. Localization contract tests cover Russian/Hindi keys for all five implemented screens and the seven feature titles.

## Remaining implementation work

1. Complete screen-level localization for Academy and Response, then review remaining dialogs, errors and checker strings.
2. Expand screen-level translation coverage beyond Russian and Hindi without changing draft packs to reviewed status.
3. Translate dialogs, errors, empty states, result framing and learning content—not only primary labels.
4. Test language switching across every module, RTL layout (Arabic and Urdu), long strings, narrow viewports and 200% text scaling.
5. Keep security-analysis output, scoring, parsing and data-flow behavior unchanged; this work is presentation-only.
6. Treat automated tests as localization regression evidence, not as proof of translation quality. Native-speaker review remains necessary before promoting draft packs.

## Validation boundaries

No claim of complete localization, native-speaker review, full Material framework translation, or full RTL conformance is made by this audit. Android device and Aurora OS runtime validation remain separate follow-up activities.

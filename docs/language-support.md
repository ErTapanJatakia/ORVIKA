# ORVIKA language support

## First-launch experience

ORVIKA presents a searchable language selector before onboarding on a first launch. The selected language is saved locally with the `appearance.language` preference. The launch splash and dashboard header also provide a direct language-selection action; Appearance & Accessibility settings expose the same picker.

The app combines two curated source catalogues into one searchable language list. Users do not choose a Russia or India section. The selected language is saved locally. The picker is also available from the dashboard and settings. Tatar (`tt`) and Bashkir (`ba`) remain excluded from the selectable list as previously directed. The combined catalogue currently contains 192 unique selectable language codes; this is a product catalogue, not a statistical ranking.

## Translation coverage

The unified selector excludes Tatar (`tt`) and Bashkir (`ba`) for now; their catalogue metadata is retained internally but neither language is selectable or has an active translation pack. Only codes explicitly listed in `OrvikaLocalizations.translatedLanguageCodes` contain authored ORVIKA strings. Every other selectable language remains an English-fallback language until its offline pack is translated and tested. Per-key coverage is available through `hasTranslation`; named interpolation and writing-direction metadata are independent of translation status.

- English: reviewed UI fallback.
- Russian: reviewed initial UI pack for onboarding, dashboard module labels/descriptions and language settings.
- Hindi (`hi`): initial draft strings cover onboarding, dashboard headings, core module labels/descriptions and selected settings. This draft is not reviewed or certified; qualified native-speaker validation is required before it can be promoted to reviewed status. Untranslated screens and content continue to use English.
- German (`de`), French (`fr`), Punjabi (`pa`), Urdu (`ur`), Italian (`it`), Arabic (`ar`), Marathi (`mr`), Gujarati (`gu`) and Sanskrit (`sa`): draft coverage varies by locale. Arabic now has a complete 146-key shared interface baseline, checker/camera/image UI, and dedicated Academy, Privacy, Response, Intelligence and checker-result content packs. Arabic remains an unreviewed draft pending consolidated automated validation, RTL device/browser review and qualified native-speaker review of security terminology.
- Arabic and Urdu apply right-to-left app layout. Arabic is included in Flutter's supported framework locales; RTL metadata alone does not establish full layout conformance.
- Other available catalogue entries: selectable and persisted, but currently display the English fallback. A language being listed does not imply that its complete UI translation is already available.

## Coverage boundary

Translation coverage differs by locale. The six priority locales (German, French, Italian, Spanish, Brazilian Portuguese and Russian) have completed their original implementation/review batches. Portugal Portuguese is being finalized separately. Feature-content and checker coverage are tracked by stable IDs and tests; a passing test suite demonstrates implementation coverage, not native-speaker quality. Do not infer full localization from a language being selectable or from a non-empty translation pack.

No machine-translation API, remote service, telemetry, or backend is used. New translation packs should be reviewed by fluent speakers and added as offline resources. Avoid auto-translating security, incident-response, legal, or privacy guidance without human review.

## India catalogue methodology and limitations

The India catalogue is a curated 100-entry product selection, not a claim to be a statistically exact top-100 ranking. It includes the 22 languages in the Eighth Schedule and 78 selected languages or mother-tongue varieties drawn from Census of India language classifications and commonly represented regional and Indigenous communities. The official 2011 Census publication reports 121 language groups and 270 identifiable mother tongues with at least 10,000 speakers; many regional varieties are grouped under broader language headings. The catalogue keeps some well-known varieties separately searchable where useful, so its entries must not be added together as if they were independent Census categories.

## Russia catalogue methodology and limitations

There is no single universally accepted ranked list of the 100 most-used languages in Russia. Rosstat's 2020 All-Russian Population Census, Volume 5, reports language proficiency, everyday use and native-language data; Rosstat also notes that the Institute of Linguistics of the Russian Academy of Sciences analysed the census language responses to support consistent language identification. Academic language inventories identify well over 100 languages spoken in the Russian Federation, with totals depending on how diaspora languages, language varieties and dialects are classified.

Accordingly, this is a curated 100-language product catalogue, not a claim that the entries are a statistically exact top-100 ranking. It includes languages used by regional, Indigenous and diaspora communities. Some labels and identifiers may need specialist review, especially where language varieties have overlapping or disputed classification.

## Reference sources

- Office of the Registrar General, India, Census of India 2011, Paper 1 of 2018, Language — India, States and Union Territories (Table C-16): https://censusindia.gov.in/nada/index.php/catalog/42458/download/46089/C-1625062018.pdf
- Rosstat, 2020 All-Russian Population Census, Volume 5 — National composition and language proficiency: https://rosstat.gov.ru/vpn/2020/Tom5_Nacionalnyj_sostav_i_vladenie_yazykami
- Rosstat, census language information: https://43.rosstat.gov.ru/folder/69369/document/128065
- Indiana University Center for Language Technology, Languages in the Russian Federation: https://celt.indiana.edu/portal/Russian/language_russia.html
- Koryakov, Languages of Russia: How many are they? (HSE): https://www.hse.ru/data/2019/12/16/1523560036/Koryakov%20-2019-%20Languages%20of%20Russia.%20How%20many%20are%20they%20%28in%20English%29.pdf

## Engineering rules

- Store language choice on-device only.
- Keep the picker searchable by English name, native name and language code.
- Use English as the explicit fallback for keys without a translation; keep draft and reviewed coverage visibly distinct.
- Never mark a draft translation as reviewed without qualified native-speaker validation.
- Do not represent an untranslated language as fully supported.
- Keep language codes stable; changing a code after a user has selected it requires a migration.


## Phase-two checker controls

The phase-two checker interface increment adds offline translations for primary headings, input labels and actions in Link Check, QR Check and Message Check, plus severity labels and QR camera/image entry actions. These keys are authored for Russian, Hindi, German, French, Italian, Punjabi, Urdu, Arabic, Marathi, Gujarati and Sanskrit.

The additional locale packs remain drafts; the existing reviewed/draft classification is unchanged. Arabic now has dedicated translations for feature descriptions, checker findings and QR payload results, as well as all curated feature-content collections. Arabic and Urdu retain RTL metadata; automated tests must be supplemented by visual RTL review at narrow widths and enlarged text sizes.


## Phase-two extended UI coverage

QR camera and image scanner controls, plus Privacy checklist reset/error controls, now use the localization lookup API. These newly keyed strings currently use explicit English fallback across the draft packs until translations are authored and reviewed. Scanner platform/privacy explanations, decoder diagnostics, detailed privacy disclosures, analyzer findings and curated security guidance remain canonical English by design. A localization key prevents an untracked literal; it does not by itself mean a language has a translation for that key.


Phase 2 also keys checker result announcements and the QR detected-format label. Where a key has no authored translation in a selected language, the app uses its explicit English fallback. Key coverage must not be reported as translated coverage.


## Phase-three Marathi and Sanskrit interface batch

Marathi (`mr`) and Sanskrit (`sa`) now include draft translations for the Intelligence, Privacy, Academy and Response screen headings and interface controls, including search/filter labels, progress labels, category names and action labels. This batch deliberately does not translate detailed security findings, privacy/legal disclosures, emergency guidance, or incident-response instructions. Those remain in the canonical fallback language until qualified specialist and native-speaker review.

The added strings are draft content, not reviewed translations. Both languages remain unavailable in the language picker. Automated coverage tests verify the authored interface keys only; they do not establish linguistic accuracy, accessibility quality, or complete screen localization. Native-speaker review and visual checks on representative devices are still required before any promotion.


## Script typography and writing direction

- Devanagari locales use the locally bundled Noto Sans Devanagari variable font.
- Gujarati (gu) uses the locally bundled Noto Sans Gujarati variable font; Gujarati is not routed through the Devanagari family.
- Urdu (ur) uses the locally bundled Noto Nastaliq Urdu variable font to preserve Nastaliq-specific glyph forms and vertical metrics.
- The app selects the primary font from the language's script metadata and retains explicit script fallbacks. Font assets and their SIL Open Font License 1.1 texts are bundled for offline rendering.
- RTL layout is driven by the language's writing-direction metadata rather than a hard-coded two-language check. Current metadata includes Arabic, Urdu, Hebrew, Persian and Pashto; this does not mean those languages have complete translations or are selectable.
- Automated tests verify font-family selection and direction metadata. They do not prove visual shaping, line-height suitability, bidirectional punctuation behavior or screen-reader quality on every platform. Urdu Nastaliq in particular requires real-device and browser review before any language pack can be promoted.


## Portugal Portuguese (pt-PT) implementation status

Portugal Portuguese is maintained as a distinct regional locale from Brazilian Portuguese (pt). The pt-PT draft now has an interface-key map covering the 146-key application baseline, the checker/scanner UI key set, and regional terminology adaptation for Portugal (including telemóvel, palavra-passe, ecrã, ficheiro, aplicação, utilizador, definições, câmara and digitalizar). The existing Brazilian Portuguese pack remains unchanged.

A narrow-viewport regression also exercises all seven feature screens at 320px and 200% text scale. The five feature content areas are wired to pt-PT: 8 Academy lessons, 12 Privacy practices, 5 Response playbooks and 10 Intelligence references, plus all 22 deterministic checker finding identifiers and QR/message/link result notices. Accessibility controls (50%–200% text sizing, bold text and reduced motion), camera/image scanner controls, privacy/analytics notices, placeholders and error states are included in the automated coverage.

The Portugal Portuguese reviewer has approved all translated content. The sole recommendation was to replace remaining English fallbacks with the closest contextually accurate European Portuguese wording. A dedicated pt-PT fallback map now covers the previously English scanner, checker-result, privacy-reset and error-state copy; placeholder interpolation and key coverage are regression-tested. `hasReviewedTranslation` remains false until this completion pass and its final regression CI pass. CI proves code/test coverage, not linguistic quality.


## Portugal Portuguese review and fallback completion

The native European Portuguese reviewer approved the translation content. The only recommendation was to replace remaining English call-site fallbacks with contextually accurate Portugal Portuguese wording. PR #98 adds a dedicated fallback map and placeholder/key regression coverage. The locale remains in the review gate until the final fallback audit and CI pass; native approval is recorded separately from technical verification. The Priberam dictionary is used as a lexical reference, with feature context and security meaning taking precedence over literal substitution.

## Localization consolidation queue

1. Close the `pt-PT` fallback completeness and CI gate.
2. Audit the six priority locales for shared-key completeness, checker strings, screen-level rendering, language switching, fallback behavior, long strings, narrow layouts and accessibility scaling.
3. Resume the paused Hindi draft only after the six-language audit.
4. Run consolidated Android validation after the complete app-code batch; keep production deployment deferred until consolidation is complete.

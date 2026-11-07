# ORVIKA language support

## First-launch experience

ORVIKA presents a searchable language selector before onboarding on a first launch. The selected language is saved locally with the `appearance.language` preference. The launch splash and dashboard header also provide a direct language-selection action; Appearance & Accessibility settings expose the same picker.

The app provides two separately searchable catalogues: 100 languages and language varieties associated with communities in Russia, and 100 entries for India. Users choose the catalogue (Russia or India) and then the language on first launch; both choices are saved locally. The picker also remains available from the dashboard and settings. The Russia catalogue prioritises Russian and English; the India catalogue includes the 22 Eighth Schedule languages plus 78 selected regional, Indigenous and community languages/varieties, with English fallback included.

## Translation coverage

The unified selector currently contains 193 distinct language codes across the India and Russia catalogues. Only codes explicitly listed in `OrvikaLocalizations.translatedLanguageCodes` contain authored ORVIKA strings. Every other selectable language remains an English-fallback language until its offline pack is translated and tested. Per-key coverage is available through `hasTranslation`; named interpolation and writing-direction metadata are independent of translation status.

- English: reviewed UI fallback.
- Russian: reviewed initial UI pack for onboarding, dashboard module labels/descriptions and language settings.
- Tatar (`tt`): initial draft strings cover onboarding, dashboard headings, core module labels/descriptions and selected settings. This draft is not reviewed or certified; native-speaker validation is required before it can be promoted to reviewed status. Untranslated screens and content continue to use English.
- Bashkir (`ba`): initial draft strings cover onboarding, dashboard headings, core module labels/descriptions and selected settings. This draft is not reviewed or certified; qualified native-speaker validation is required before it can be promoted to reviewed status. Untranslated screens and content continue to use English.
- Hindi (`hi`): initial draft strings cover onboarding, dashboard headings, core module labels/descriptions and selected settings. This draft is not reviewed or certified; qualified native-speaker validation is required before it can be promoted to reviewed status. Untranslated screens and content continue to use English.
- German (`de`), French (`fr`), Punjabi (`pa`), Urdu (`ur`), Italian (`it`), Arabic (`ar`), Marathi (`mr`), Gujarati (`gu`) and Sanskrit (`sa`): initial draft packs now cover onboarding, dashboard module labels/descriptions, shared navigation and appearance settings. These are unreviewed drafts and require qualified native-speaker review, especially for security and privacy terminology.
- Arabic and Urdu apply right-to-left app layout. Flutter framework widgets continue using the supported English/Russian framework locales; ORVIKA's selected language is carried independently.
- Other catalogue entries: selectable and persisted, but currently display the English fallback. A language being listed does not imply that its complete UI translation is already available.

## Coverage boundary

These draft packs translate the shared onboarding/dashboard/navigation/appearance surface. The eight feature screens (Sentinel, Link Check, QR Check, Message Check, Intelligence, Privacy, Academy and Response), including their detailed instructional copy, validation messages and analysis findings, still require dedicated localization work. Untranslated feature content must not be represented as fully localized.

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

# ORVIKA language support

## First-launch experience

ORVIKA presents a searchable language selector before onboarding on a first launch. The selected language is saved locally with the `appearance.language` preference. The launch splash and dashboard header also provide a direct language-selection action; Appearance & Accessibility settings expose the same picker.

The catalogue contains 100 language entries using language identifiers and native-script labels. The order prioritises Russian and English, followed by widely used languages and then regional, Indigenous and diaspora languages represented in Russia.

## Translation coverage

- English: reviewed UI fallback.
- Russian: reviewed initial UI pack for onboarding, dashboard module labels/descriptions and language settings.
- Other catalogue entries: selectable and persisted, but currently display the English fallback. A language being listed does not imply that its complete UI translation is already available.

No machine-translation API, remote service, telemetry, or backend is used. New translation packs should be reviewed by fluent speakers and added as offline resources. Avoid auto-translating security, incident-response, legal, or privacy guidance without human review.

## Catalogue methodology and limitations

There is no single universally accepted ranked list of the 100 most-used languages in Russia. Rosstat's 2020 All-Russian Population Census, Volume 5, reports language proficiency, everyday use and native-language data; Rosstat also notes that the Institute of Linguistics of the Russian Academy of Sciences analysed the census language responses to support consistent language identification. Academic language inventories identify well over 100 languages spoken in the Russian Federation, with totals depending on how diaspora languages, language varieties and dialects are classified.

Accordingly, this is a curated 100-language product catalogue, not a claim that the entries are a statistically exact top-100 ranking. It includes languages used by regional, Indigenous and diaspora communities. Some labels and identifiers may need specialist review, especially where language varieties have overlapping or disputed classification.

## Reference sources

- Rosstat, 2020 All-Russian Population Census, Volume 5 — National composition and language proficiency: https://rosstat.gov.ru/vpn/2020/Tom5_Nacionalnyj_sostav_i_vladenie_yazykami
- Rosstat, census language information: https://43.rosstat.gov.ru/folder/69369/document/128065
- Indiana University Center for Language Technology, Languages in the Russian Federation: https://celt.indiana.edu/portal/Russian/language_russia.html
- Koryakov, Languages of Russia: How many are they? (HSE): https://www.hse.ru/data/2019/12/16/1523560036/Koryakov%20-2019-%20Languages%20of%20Russia.%20How%20many%20are%20they%20%28in%20English%29.pdf

## Engineering rules

- Store language choice on-device only.
- Keep the picker searchable by English name, native name and language code.
- Use English as the explicit fallback for languages without a reviewed translation pack.
- Do not represent an untranslated language as fully supported.
- Keep language codes stable; changing a code after a user has selected it requires a migration.

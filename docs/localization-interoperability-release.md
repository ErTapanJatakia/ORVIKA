# ORVIKA-12 — Localization interoperability and release coverage

Status: implementation and regression coverage added; test execution pending  
Review date: 16 November 2026

## Delivered

- Added a full-catalogue BCP 47 round-trip regression for all 192 selectable language entries.
- Added explicit region-variant checks for Portugal Portuguese (`pt-PT`) and Brazilian Portuguese (`pt`).
- Added safe-default checks for empty, unknown and temporarily withheld locale tags.
- Pinned reviewed translation status to the four reviewed locales: English, Russian, Arabic and Portugal Portuguese.
- Kept authored draft translations distinct from reviewed release status.

## What this does not claim

- It does not translate missing UI strings or the 12 newer Intelligence references.
- It does not promote any draft translation to reviewed status.
- It does not replace native-speaker, security-terminology or legal-content review.
- It does not prove RTL layout, glyph rendering or line wrapping on physical devices.

## Release gates still open

1. Complete and review missing shared UI strings and feature-content packs before locale promotion.
2. Review the newer Intelligence entries in every target locale with qualified language reviewers.
3. Validate Arabic/Urdu bidirectional text, punctuation, mixed-script URLs and input direction on Android and Web.
4. Validate Simplified Chinese and Indic font glyphs/metrics on supported devices.
5. Record reviewer, locale, commit, scope, date and corrections for every promoted locale.

The regression test is committed but has not been run. It must not be described as a passed test until explicitly executed.

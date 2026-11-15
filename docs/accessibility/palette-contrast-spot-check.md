# ORVIKA shared palette contrast spot-check

**Workstream:** ORVIKA-A11Y-02  
**Status:** Token-level calculation only; not a WCAG conformance result  
**Scope:** The four declared theme palettes in `lib/main.dart`

## Method

Contrast ratios are calculated from the supplied sRGB hex values using the WCAG relative-luminance formula:

1. Convert each sRGB channel to the linear-light value (divide by 12.92 at or below 0.04045; otherwise use ((channel + 0.055) / 1.055)^2.4).
2. Calculate relative luminance as 0.2126 R + 0.7152 G + 0.0722 B.
3. Calculate (lighter luminance + 0.05) / (darker luminance + 0.05).

Values below are rounded to two decimal places. The reference surfaces are the palette's declared background and surface colours. The text token is the explicit `onSurface` colour configured in the app's ColorScheme.

## Results

| Theme | Token | Hex | On background | On surface |
|---|---|---|---:|---:|
| Obsidian | onSurface text | #F3F7FC | 17.15:1 | 14.73:1 |
| Obsidian | primary | #00D5FF | 10.51:1 | 9.02:1 |
| Obsidian | secondary | #A58BFF | 6.80:1 | 5.84:1 |
| Obsidian | success | #20D69A | 9.79:1 | 8.41:1 |
| Obsidian | warning | #FFB547 | 10.50:1 | 9.02:1 |
| Obsidian | danger | #FF5263 | 5.83:1 | 5.01:1 |
| Aurora | onSurface text | #F3F7FC | 17.37:1 | 14.96:1 |
| Aurora | primary | #9CEBFF | 14.00:1 | 12.07:1 |
| Aurora | secondary | #B69CFF | 8.17:1 | 7.04:1 |
| Aurora | success | #70E2B7 | 11.79:1 | 10.16:1 |
| Aurora | warning | #FFD080 | 12.98:1 | 11.18:1 |
| Aurora | danger | #FF7886 | 7.37:1 | 6.35:1 |
| Daylight | onSurface text | #172536 | 14.40:1 | 15.51:1 |
| Daylight | primary | #006B86 | 5.66:1 | 6.09:1 |
| Daylight | secondary | #6246B5 | 6.37:1 | 6.86:1 |
| Daylight | success | #087A55 | 4.97:1 | 5.35:1 |
| Daylight | warning | #946000 | 4.96:1 | 5.34:1 |
| Daylight | danger | #B42336 | 6.03:1 | 6.49:1 |
| High contrast | onSurface text | #F3F7FC | 19.52:1 | 17.55:1 |
| High contrast | primary | #00FFFF | 16.75:1 | 15.06:1 |
| High contrast | secondary | #D7B8FF | 12.19:1 | 10.96:1 |
| High contrast | success | #66FFB2 | 16.51:1 | 14.85:1 |
| High contrast | warning | #FFD166 | 14.56:1 | 13.10:1 |
| High contrast | danger | #FF6262 | 7.18:1 | 6.45:1 |

## Interpretation and limits

- The listed token-to-surface pairs meet the 4.5:1 text contrast threshold as calculated for these exact solid colours.
- This is a palette-level spot-check, not proof that every text instance, component state, gradient, overlay, disabled control, border, focus indicator, chart, image, or hover/focus surface meets WCAG.
- The configured `onPrimary` pair, outline, `onSurfaceVariant`, error foreground/background combinations, opacity-modified borders and gradients require separate measurement.
- Non-text contrast (including control boundaries, state indicators and focus visuals) requires a separate 3:1 assessment against adjacent colours.
- Actual rendering, opacity compositing, anti-aliasing, font size/weight, and every UI state must be checked in browser/device output.
- Do not mark WCAG 1.4.3 or 1.4.11 Pass from this document alone.

## Next checks

1. Add automated regression coverage for all declared palette tokens and key foreground/background pairs.
2. Inspect all direct colour usages and alpha blends across feature screens.
3. Measure focus indicators, input borders, icons, chart states and control boundaries.
4. Validate with rendered browser and Android screenshots, including all four themes.

# ORVIKA dashboard responsive assurance

Review baseline: 16 November 2026  
Scope: dashboard layout implementation and automated widget-test coverage  
Status: regression coverage authored; tests not executed in this increment

## Responsive layout contract

The Sentinel dashboard uses one scroll surface and a constrained content column. Its responsive behaviour is designed around these breakpoints:

- Below 420 logical pixels: compact horizontal page padding.
- Below 560 logical pixels: one module-card column.
- From 560 to 759 logical pixels: two module-card columns.
- From 760 to 999 logical pixels: three module-card columns.
- At 1000 logical pixels and above: four module-card columns.
- The top bar switches to a stacked brand/actions arrangement below 760 logical pixels, and also at larger widths when text scaling is high.
- The hero switches from a side-by-side owl/copy composition to a stacked composition on compact widths.

Module-card height scales with the active text scale to reserve room for longer descriptions. The cards retain full descriptions rather than truncating the body copy; module titles and status labels have bounded line counts.

## Regression coverage

The existing dashboard suites cover module-description readability, header/hero rendering, and scroll/footer access. The new responsive assurance matrix adds explicit checks for:

- 320, 360 and 390 logical-pixel portrait widths.
- 560 and 768 logical-pixel tablet breakpoints.
- 1280 logical-pixel desktop width.
- 100%, 150%, 200% and 400% application text scales.
- Single-line ORVIKA wordmark behaviour and bounded brand width.
- Hero heading remaining within the viewport.
- Flutter layout exceptions during each scenario.

These tests are regression specifications, not evidence of successful execution. They do not replace real-device checks for the previously reported portrait-header issue across Galaxy, iPhone and Pixel families.

## Remaining manual checks

1. Verify the dashboard in Chrome and Firefox on representative Android devices.
2. Verify Safari on iOS where available.
3. Check portrait and landscape orientation, browser zoom, system font scaling and RTL layouts.
4. Inspect visual focus, touch target spacing, module-card balance and footer reachability on physical devices.
5. Record device/browser versions and screenshots for any layout defect.

No production deployment or manual device/browser verification was performed in this increment.

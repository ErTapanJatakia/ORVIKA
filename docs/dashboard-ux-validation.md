# Dashboard UX validation — consolidated batch

## Scope

This batch refines the dashboard presentation without changing module behavior, navigation destinations, security-analysis logic, permissions, or local-data handling.

- Increase module-card title and description legibility.
- Give status indicators a consistent, readable pill treatment.
- Increase card vertical space and scale it with the app's text-size preference.
- Use responsive outer page gutters across phone, tablet and desktop widths.
- Preserve the existing responsive column breakpoints and dashboard scroll container.
- Add automated viewport regression coverage for compact phones, standard phones, tablet, desktop and landscape, including 150% and 200% app text scaling.

## Automated viewport matrix

| Width × height | Text scale | Intended profile |
|---|---:|---|
| 320 × 640 | 100% | compact phone |
| 360 × 800 | 100% | phone portrait |
| 390 × 844 | 200% | phone portrait / large text |
| 600 × 900 | 100% | compact tablet |
| 768 × 1024 | 150% | tablet portrait / large text |
| 1024 × 768 | 100% | tablet landscape |
| 1440 × 900 | 100% | desktop |
| 844 × 390 | 100% | phone landscape |

The widget test checks dashboard heading visibility, module description rendering, scroll access to the trust note/footer area, and Flutter layout exceptions at each viewport.

## Validation boundaries

CI is the automated evidence for this batch. No local Flutter execution is claimed. Widget tests do not replace manual checks on physical devices, browser engines, keyboard-only navigation, screen readers, magnification, or operating-system text scaling. No WCAG conformance claim is made by this change.

# Focus visibility and target-size implementation notes

## Implemented shared defaults

The application theme now provides a stronger shared focus colour token and a 48 × 48 logical-pixel minimum size with padded tap-target behaviour for Material icon, elevated, outlined and text buttons.

These defaults are a baseline, not proof that every control conforms. Custom-painted controls, gesture-only surfaces, compact chips, navigation elements and widgets that override their theme must be audited individually.

## WCAG 2.2 mapping

- **2.4.7 Focus Visible (AA):** a shared focus colour is configured. Verify every keyboard-operable control in every theme, including contrast and visibility against adjacent surfaces.
- **2.4.11 Focus Not Obscured (Minimum) (AA):** not established by this change. Verify sticky headers, overlays, dialogs, scroll containers and viewport edges with keyboard navigation.
- **2.5.8 Target Size (Minimum) (AA):** common Material button themes receive 48 × 48 logical-pixel minimums. Verify actual rendered hit regions and all non-button interactive controls; WCAG exceptions and spacing rules require contextual review.

## Evidence and limitations

Automated widget tests assert theme-level minimum dimensions and padded tap-target defaults. They do not establish rendered hit-area geometry, visual focus contrast, unobscured focus, or full application conformance. Manual keyboard testing and real-device touch-target inspection remain required on web and Android separately.

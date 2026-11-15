# A11Y-06 — Accessible navigation, forms, onboarding and help

**Status:** Existing semantic foundations identified; full interaction audit pending

## Existing foundations

The current test suite includes coverage for:
- Language picker heading and search-field label, including the no-results announcement.
- Onboarding page headings and progress announcement.
- Language, visual-environment, and accessibility settings headings.
- Feature input labels and live result updates.
- BCP 47 locale metadata, including selected locale semantics.
- Responsive language/onboarding/settings layouts, including simulated RTL and enlarged text.

These Flutter widget tests are regression evidence only. Native TalkBack, Switch Access, browser assistive technology, and real platform scaling remain separate checks.

## Implementation requirements

- Every text field has a persistent programmatic label; placeholder text is not the only label.
- Required/invalid fields expose state and a useful error associated with the field. Do not rely on colour alone.
- Every control exposes its role, name, current value, and selected/expanded/disabled state.
- Dialogs have a meaningful title, predictable focus entry, keyboard/switch-accessible actions, and focus restoration after dismissal.
- Menus, chips, tabs, sliders, and icon-only controls must be reachable and operable without precision gestures.
- Provide non-drag alternatives for any drag-only operation; provide non-swipe alternatives for any swipe-only operation.
- Help and safety guidance must be available consistently and must not obscure the task or keyboard focus.
- Avoid asking users to enter information already available in the current workflow unless re-entry is essential.
- Authentication, if introduced, must support accessible password managers, paste, and non-cognitive alternatives consistent with WCAG 2.2 SC 3.3.8.
- RTL layout must preserve logical reading and focus order; locale changes must not strand focus.
- Text and controls must remain usable at 200% text resizing and with Android system font/display scaling.

## Release evidence required

For each journey (language selection, onboarding, dashboard, Link/QR/Message Check, Intelligence, Privacy, Academy, Response, settings, dialogs), record:
1. Keyboard-only result on web.
2. Browser screen-reader result on web.
3. TalkBack result on Android.
4. Switch Access result on Android.
5. 200% text resizing / Android font and display size.
6. RTL result for supported RTL locales.
7. Defects, retest commit, and evidence reference.

No criterion is marked conformant by this checklist alone.

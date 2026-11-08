# ORVIKA Accessibility Standard

Status: implementation baseline and staged acceptance criteria  
Platforms: Android, Web/PWA, Aurora OS  
Principles: privacy-first, offline-first, zero-cost, security semantics preserved

ORVIKA treats accessibility as a product requirement across every feature, not a release-only audit. The target is WCAG 2.2 AA for web-facing experiences, with applicable platform accessibility guidance followed on Android and Aurora OS. WCAG conformance is a target to validate, not a claim of certification.

## 1. Perceptual access

- Screen-reader support through meaningful Flutter semantics, labels, roles, values, hints, state announcements and logical traversal order.
- Dynamic text resizing, including large accessibility text sizes without clipping, overlap or loss of controls.
- Bold text and readable typography options; do not rely on a special font unless its licence and script coverage are verified.
- High-contrast presentation, contrast-safe text, visible focus indicators and non-colour status cues.
- Support system colour inversion, magnification, display scaling and platform contrast settings where the operating system provides them.
- Avoid text embedded in images; provide text alternatives for meaningful illustrations and charts.
- Do not communicate risk, severity, selection or completion by colour or icon alone.

## 2. Hearing and audio access

- All meaningful audio or spoken information must have captions or equivalent text.
- No essential instruction may be audio-only.
- Any future sound alert must have a visual and/or haptic equivalent and a user-configurable setting.
- No autoplaying audio or time-critical audio-only prompt.

## 3. Motor and interaction access

- Full keyboard operation on Web/PWA, with logical tab order, visible focus, keyboard activation and no keyboard traps.
- Screen-reader switch access and platform switch-control compatibility through standard semantic controls.
- Generous touch targets (minimum 48 logical pixels where practical), adequate spacing, and no precision-only gestures.
- Provide alternatives to drag, swipe, multi-finger and timed interactions.
- Do not require repeated rapid taps; support undo or confirmation for consequential actions.
- Respect platform input methods, hardware keyboards, assistive switches and voice-control activation labels.

## 4. Speech and hands-free access

- Controls must have stable, visible names that can be spoken by platform voice-control systems.
- Voice input is optional; every voice-driven action must have a non-voice equivalent.
- Do not require microphone permission for core ORVIKA functionality.
- Any future speech recognition must explain processing location, request permission only at point of use, and never upload content without explicit consent.

## 5. Cognitive, learning and neurological access

- Plain-language instructions, predictable navigation, consistent control placement and clear headings.
- Short, chunked content; explain security terminology and avoid unexplained acronyms.
- No unnecessary time limits, flashing, parallax, autoplay or distracting animation.
- Respect reduced-motion preferences and provide a low-distraction presentation.
- Make errors specific, actionable and associated with the relevant field; preserve user input after validation errors.
- Confirm destructive or consequential actions and provide a safe way back.
- Offer clear progress, completion and next-step feedback without relying on colour alone.

## 6. Security-result accessibility

- Keep the distinction between suspicion, evidence and confirmation explicit in text and assistive announcements.
- Evidence score 0–100 describes evidence quality, never the probability that something is malicious.
- Announce finding title, severity, evidence and recommended next step in a logical order.
- Never make a colour, animation, sound or haptic cue the only carrier of a security finding.
- Do not hide caveats, limitations, source context or uncertainty from screen-reader users.
- Accessibility presentation must not alter URL/message/QR analysis, risk scoring, detection thresholds or evidence.

## 7. Language, scripts and reading direction

- Preserve correct Unicode text, language metadata and right-to-left layout for supported RTL scripts.
- Avoid truncating translated strings; allow wrapping and expansion.
- Ensure screen-reader pronunciation follows the selected language where supported by the platform.
- Do not reverse RTL strings manually; use framework bidirectional layout.

## 8. Personalisation and privacy

- Accessibility preferences are local to the device by default and work offline.
- No account, analytics, advertising SDK or cloud service is required for accessibility.
- Respect OS-level accessibility settings rather than overriding them.
- Provide in-app controls for app-specific text scaling, bold text, reduced motion and contrast where platform behaviour does not already cover the need.
- Do not store disability labels, diagnoses or inferred health information.

## 9. Validation and release gates

Each feature must be tested with:
- Flutter widget tests for semantics labels, roles, values, focus, text scaling and state announcements.
- Automated accessibility guideline checks where supported by Flutter.
- Keyboard-only navigation on Web/PWA.
- Android TalkBack and Switch Access.
- Aurora OS native assistive technologies available on supported target devices.
- Browser screen readers and zoom/reflow checks on supported browsers.
- Large text, bold text, high contrast, reduced motion, RTL and narrow viewport combinations.
- Manual checks for contrast, focus visibility, target size, reading order, error recovery and non-colour cues.

A feature is not accessibility-complete solely because automated tests pass. Record platform coverage and known limitations; never claim WCAG or platform certification without a formal audit.

## 10. Keyboard and dashboard navigation implementation

Implemented on the dedicated keyboard/assistive-navigation branch:

- The app shell uses Flutter's reading-order focus traversal group and a root semantic container with explicit child semantics.
- Actionable dashboard cards expose one complete semantic label, button state and tap action; informational cards are announced without a false action.
- Dashboard and Accessibility settings headings are exposed as semantic headings.
- Dashboard cards remain keyboard-focusable only when actionable and display a high-visibility focus outline plus a focus highlight.
- Regression tests cover card labels/actions, heading semantics, traversal-group presence, Tab navigation to a dashboard card and Enter activation.

This increment does not establish full WCAG 2.2 AA conformance. Browser-level keyboard testing, reverse traversal (Shift+Tab), Escape behaviour for each overlay, TalkBack/VoiceOver/browser screen-reader testing, Switch Access, and assistive navigation across every feature screen remain validation and follow-on coverage items. Automated widget tests cannot replace those manual checks.

## 11. Delivery sequence

1. Shared accessibility preferences and app-wide text scaling, bold text, reduced motion and contrast support.
2. Semantics and focus audit of onboarding, language selection, dashboard and appearance settings.
3. Accessible forms and result announcements for Link Check, QR Check and Message Check.
4. Accessible reading order, filters, progress and structured content for Intelligence and Privacy.
5. Accessible lesson navigation, knowledge checks and response playbooks.
6. Cross-platform assistive-technology validation, regression tests and a public accessibility statement.

## Definition of done

A screen is ready only when its primary tasks are available without sight, without colour perception, without a pointer, without precise gestures, and with enlarged text; instructions and results are available without sound; and no accessibility setting changes the underlying security decision.


## 12. Feature-screen semantics and dynamic state

Implemented on the dedicated feature-screen accessibility branch:

- Link Check, QR Check, Message Check, Intelligence, Privacy, Academy and Response expose their primary screen titles as semantic headings.
- Link, QR and message analysis results publish concise live-region summaries when a result becomes available. Detailed findings remain available as ordinary readable content; the announcement does not replace or conceal them.
- Intelligence publishes the updated reference-entry count as a live-region status when search or category filters change.
- Privacy and Academy progress indicators expose descriptive labels and current values. Their changing progress summaries are also announced through live regions.
- Academy answer feedback is exposed as a live region so correct and incorrect responses are not communicated only through visual styling.
- Existing standard Flutter controls (text fields, buttons, filter chips, expansion tiles and checklist controls) remain the interaction primitives; no custom pointer-only controls or altered security logic were introduced.

Automated semantic-tree tests cover heading flags, analysis-result announcements, Intelligence result counts and Privacy/Academy progress values. These tests establish the intended Flutter semantics tree only. They do not prove that TalkBack, NVDA, VoiceOver, browser screen readers or Switch Access announce or navigate the screens correctly on real devices.

### Native assistive-technology validation still required

- Android: enable TalkBack in Settings > Accessibility > TalkBack, then test the seven feature screens with touch exploration, swipe navigation, headings navigation, actions and result announcements. Test Switch Access separately.
- Windows: test the deployed web app with Narrator and at least one supported browser/screen-reader combination such as NVDA with Firefox or Chrome.
- Browser keyboard: test Tab, Shift+Tab, Enter, Space, focus visibility, overlays and escape/return behaviour.
- Record OS, browser, screen-reader version, viewport, text scale, observed announcement, expected announcement and pass/fail for each test. Do not mark a platform complete from widget tests alone.

## 13. Onboarding, language selection and appearance settings semantics

Implemented in the onboarding/settings accessibility increment:

- Language selection exposes its page title as a semantic heading and its search field has an explicit accessible label.
- Language search publishes the current result count through a live region, including the zero-results state.
- Each onboarding page title is exposed as a semantic heading. The current page number is visible and announced as a live update, so progress is not conveyed by coloured pagination dots alone.
- Appearance settings expose the Language, visual-environment and Accessibility section titles as semantic headings.
- The existing Material controls remain in place for keyboard and assistive-technology compatibility; this increment does not replace them with custom controls.

This is partial coverage of delivery-sequence item 2, not completion of the onboarding/settings audit. Keyboard traversal, focus restoration after language selection, screen-reader testing, large-text visual checks and full theme contrast review remain outstanding. Automated widget tests verify Flutter semantics only and do not establish native assistive-technology compatibility or WCAG conformance.

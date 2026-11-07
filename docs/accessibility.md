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

## 10. Delivery sequence

1. Shared accessibility preferences and app-wide text scaling, bold text, reduced motion and contrast support.
2. Semantics and focus audit of onboarding, language selection, dashboard and appearance settings.
3. Accessible forms and result announcements for Link Check, QR Check and Message Check.
4. Accessible reading order, filters, progress and structured content for Intelligence and Privacy.
5. Accessible lesson navigation, knowledge checks and response playbooks.
6. Cross-platform assistive-technology validation, regression tests and a public accessibility statement.

## Definition of done

A screen is ready only when its primary tasks are available without sight, without colour perception, without a pointer, without precise gestures, and with enlarged text; instructions and results are available without sound; and no accessibility setting changes the underlying security decision.

# ORVIKA Android Assistive-Technology Validation Matrix

Status: validation plan prepared; execution evidence pending  
Scope: native Android build on `com.orvika.app`  
Target assistive technologies: TalkBack and Switch Access  
Rule: no criterion is marked Pass until its specific evidence is recorded.

## Evidence boundary

Flutter widget tests and semantics-tree assertions are useful automated evidence. They do not establish that Android TalkBack speaks the right content, that Switch Access can reach and activate every control, or that focus and announcements behave correctly on a physical device.

This matrix keeps automated evidence, source review and real-device execution separate. Do not record personal information, user content, screen recordings or diagnostic captures containing user data.

## Journey coverage

| ID | User journey | Required Android checks | Existing automated evidence to map |
|---|---|---|---|
| AND-A11Y-01 | First-launch language selection | TalkBack announces screen title, selected language, search field, result count and selection state; Switch Access reaches search, results and continue action | `onboarding_settings_semantics_test.dart`; language-picker tests in `widget_test.dart` |
| AND-A11Y-02 | Onboarding | Page heading, progress, next/back controls and completion state are announced in logical order | `onboarding_settings_semantics_test.dart`; onboarding tests in `widget_test.dart` |
| AND-A11Y-03 | Dashboard | App identity and actionable cards have meaningful names and roles; informational cards are not announced as actions; traversal is predictable | `widget_test.dart`; `browser_navigation_focus_test.dart` (Flutter widget evidence only) |
| AND-A11Y-04 | Link Check | Label and hint are announced; input errors are associated with the field; analysis result announces summary, severity, evidence and next step without colour dependency | `form_control_semantics_test.dart`; feature semantics tests |
| AND-A11Y-05 | QR Check | Manual input, camera and image actions are reachable; camera permission denial is understandable; scan result and uncertainty are announced | QR Check screen and semantics tests; `qr_check_screen_test.dart` |
| AND-A11Y-06 | Message Check | Input label, validation and result summary are announced; detailed findings remain reachable | `form_control_semantics_test.dart`; feature semantics tests |
| AND-A11Y-07 | Intelligence | Search, filters, result count, empty state and evidence details are reachable and announced | Intelligence semantics and responsive tests |
| AND-A11Y-08 | Privacy | Checklist items expose state; progress changes are announced; review actions are operable without precise gestures | Privacy semantics tests |
| AND-A11Y-09 | Academy | Lesson headings, progress, answers and feedback are announced; correct/incorrect state is not colour-only | Academy semantics tests |
| AND-A11Y-10 | Response | Playbook headings, ordered steps and action controls have meaningful names and order | Response feature semantics tests |
| AND-A11Y-11 | Appearance and accessibility settings | Current values and toggles are announced; text scale, bold text and reduced motion can be changed and retained | `onboarding_settings_semantics_test.dart`; `widget_test.dart` |

> Replace any provisional test-file references above with exact current test names during implementation review. Do not infer coverage from a filename alone; inspect the assertion and the widget journey it exercises.

## Physical-device protocol

Record one row per device and assistive-technology combination.

| Check ID | Protocol | Expected result | Evidence required |
|---|---|---|---|
| AT-01 | Enable TalkBack; traverse every journey using swipe navigation | Every actionable control has a concise, accurate spoken name, role and state | Device/OS, TalkBack version, journey, observed result |
| AT-02 | Use TalkBack touch exploration on all primary screens | Touch exploration identifies controls and does not hide essential information | Device/OS, screen, observed result |
| AT-03 | Navigate by headings and controls where supported | Headings and controls follow a meaningful reading order | Device/OS, screen, observed result |
| AT-04 | Trigger Link, QR and Message analysis results | Summary announcement is timely and understandable; details and uncertainty remain accessible | Device/OS, input category only (never actual user content), observed result |
| AT-05 | Enable Switch Access and scan every primary journey | All essential controls can be focused and activated; no gesture-only task blocks completion | Device/OS, Switch Access version, journey, observed result |
| AT-06 | Increase Android font size and display size to the largest practical settings | Text wraps; controls remain visible and operable; no clipping or overlap blocks tasks | Device/OS, font/display settings, affected screen |
| AT-07 | Rotate portrait/landscape where supported | Layout and traversal remain usable; state is not unexpectedly lost | Device/OS, orientation, screen |
| AT-08 | Enable bold text, magnification and high-contrast/system display options where available | Content remains perceivable and controls remain operable | Device/OS, setting, observed result |
| AT-09 | Deny camera permission, then revisit QR Check | Manual and image-analysis alternatives remain understandable and reachable; no repeated permission loop | Device/OS, permission state, observed result |
| AT-10 | Navigate backward from feature screens and dialogs | Focus/reading position returns to a sensible location; no inaccessible overlay remains | Device/OS, journey, observed result |

## Execution record

For every check, record:

- Check ID and journey
- Device model and Android version
- ORVIKA build version and commit SHA
- TalkBack or Switch Access version and relevant settings
- Date of execution
- Expected behaviour
- Observed behaviour
- Result: Not run / Pass / Fail / Blocked
- Defect reference and retest result, if applicable

Do not mark a check Pass from source inspection, a Flutter widget test, a CI result, or a browser test alone.

## Release gate

- Automated Flutter semantics tests are mapped to concrete journeys and assertions.
- Every real-device check above has an explicit execution record.
- Failed checks have a tracked defect and retest evidence.
- Manual TalkBack and Switch Access results remain Pending until executed on a physical Android device.
- No WCAG 2.2 AA, WCAG2ICT, Android accessibility certification or independent-audit claim is made from this matrix.
- Android build validation is run only after the complete relevant implementation batch is ready, consistent with the repository's validation policy.

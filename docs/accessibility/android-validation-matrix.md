# ORVIKA Android Assistive-Technology Validation Matrix

Status: automated-evidence mapping reviewed; physical-device execution pending  
Scope: native Android build on `com.orvika.app`  
Target assistive technologies: TalkBack and Switch Access  
Rule: no criterion is marked Pass until its specific evidence is recorded.

## Evidence boundary

Flutter widget tests and semantics-tree assertions are useful automated evidence. They do not establish that Android TalkBack speaks the right content, that Switch Access can reach and activate every control, or that focus and announcements behave correctly on a physical device.

This matrix keeps automated evidence, source review and real-device execution separate. Do not record personal information, user content, screen recordings or diagnostic captures containing user data.

## Verified automated-evidence map

The following references were checked against files present on the current A11Y-04 branch. They identify what the tests actually assert; they are not a claim that the full Android assistive-technology journey has passed.

| Journey | Verified automated evidence | Coverage boundary / remaining check |
|---|---|---|
| First-launch language selection | `test/features/accessibility/onboarding_settings_semantics_test.dart`: heading, labelled search field and live result-count announcement. `test/features/accessibility/onboarding_settings_responsive_test.dart`: responsive widths and locale-tag search for every selectable language. | Does not prove TalkBack selection-state speech or Switch Access scanning/activation on Android. |
| Onboarding | `test/features/accessibility/onboarding_settings_semantics_test.dart`: page heading, page progress live region and progression to page 2. `test/features/accessibility/onboarding_settings_responsive_test.dart`: responsive navigation. | Back/complete announcement order and physical assistive-tech operation remain to be checked. |
| Dashboard | `test/features/accessibility/interaction_validation_test.dart`: 48-pixel icon targets and Tab/Shift+Tab/Enter navigation. `test/features/accessibility/browser_navigation_focus_test.dart`: Space activation and focus restoration after returning from a feature. `test/features/accessibility/focus_target_sizing_test.dart`: icon target sizing and visible keyboard focus outline. | Keyboard/browser evidence is not equivalent to TalkBack traversal or Switch Access scanning. |
| Link Check | `test/features/accessibility/form_control_semantics_test.dart`: input label. `test/features/accessibility/feature_semantics_test.dart`: screen heading, live result announcement and result heading. | Error-to-field association, severity/evidence reading order and Switch Access operation need direct verification. |
| QR Check | `test/features/accessibility/form_control_semantics_test.dart`: manual-input label. `test/features/accessibility/feature_semantics_test.dart`: heading, live result announcement and result heading. `test/features/qr_check/qr_check_screen_test.dart`: camera/image/manual alternatives, camera permission preflight, responsive layout and 200% text scaling in RTL. | Actual permission denial, scanner dialogs, TalkBack reading order and Switch Access operation remain physical-device checks. |
| Message Check | `test/features/accessibility/form_control_semantics_test.dart`: input label. `test/features/accessibility/feature_semantics_test.dart`: screen heading, live result announcement and result heading. | Error-to-field association, detailed finding order and Switch Access operation need direct verification. |
| Intelligence | `test/features/accessibility/form_control_semantics_test.dart`: search label. `test/features/accessibility/feature_semantics_test.dart`: screen heading and live reference-count update. | Filter traversal, empty-state and evidence-detail announcements need further audit and device validation. |
| Privacy | `test/features/accessibility/feature_semantics_test.dart`: screen heading, progress accessible value and live progress update. | Checklist item checked state and all action controls need direct semantic/device validation. |
| Academy | `test/features/accessibility/feature_semantics_test.dart`: screen heading, progress value, progress announcement and live answer feedback. | Full lesson traversal and correct/incorrect state beyond the tested feedback need direct validation. |
| Response | `test/features/accessibility/feature_semantics_test.dart`: screen heading. | Ordered-step semantics and action-control names/order need further audit and device validation. |
| Appearance and accessibility settings | `test/features/accessibility/onboarding_settings_semantics_test.dart`: section headings. `test/features/accessibility/text_scale_range_test.dart`: default, saved value, slider range/steps and localization keys. `test/features/accessibility/interaction_validation_test.dart`: dashboard icon target sizes. | Current toggle values, persisted changes, Switch Access operation and Android system font/display scaling need direct validation. |
| Cross-feature accessibility preferences | `test/features/accessibility/interaction_validation_test.dart`: theme accent contrast. `test/features/accessibility/text_scale_range_test.dart`: 50%–200% app text-scale range. | Automated contrast calculations and app-controlled scaling do not replace Android system display/font scaling checks. |

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

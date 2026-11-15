# ORVIKA Android Accessibility Assessment — A11Y-04

**Workstream:** ORVIKA-A11Y-04  
**Status:** Assessment baseline prepared; real-device verification pending  
**Target:** Native Android accessibility, interpreted with WCAG2ICT guidance where applicable  
**Application ID:** `com.orvika.app`

> **No conformance claim:** This is an assessment plan and source-level test inventory. Flutter widget semantics tests do not prove the Android accessibility tree, TalkBack behaviour, Switch Access operation, or WCAG2ICT conformance.

## 1. Assessment boundaries

ORVIKA is implemented in Flutter and uses Flutter's Android embedding. Flutter's semantics layer is expected to expose accessible information to Android, but this must be verified on a built application with Android assistive technologies.

This workstream covers the native Android experience. Browser accessibility-tree behaviour and web keyboard navigation are tracked separately.

No custom Android accessibility service is proposed. ORVIKA must not inspect, collect, transmit, or persist other applications' accessibility content.

## 2. Existing automated evidence inventory

The following tests were identified by repository inspection. They are useful regression evidence, not proof of native Android behaviour.

| Existing test file | Existing coverage visible in source | Android evidence status |
|---|---|---|
| `test/features/accessibility/feature_semantics_test.dart` | Seven feature headings; live-region updates for Link Check, QR Check, Message Check and Intelligence; Privacy/Academy progress labels and numeric values; Academy answer feedback | Flutter semantics assertions only; TalkBack announcement timing, verbosity and reading order pending |
| `test/features/accessibility/onboarding_settings_semantics_test.dart` | Language heading and search label; zero-result search announcement; onboarding page headings and progress; Language, visual-environment and Accessibility settings headings | Flutter semantics assertions only; selection state, option traversal and native focus behaviour pending |
| `test/features/accessibility/semantics_locale_test.dart` | BCP 47 locale mapping for English, Russian, Hindi, Portuguese variants, Simplified Chinese, Punjabi, Urdu and Serbian; selected Russian locale published on a Text semantics node | Locale metadata assertion only; native pronunciation, script handling and RTL reading order pending |
| `test/features/accessibility/interaction_validation_test.dart` | Palette accent contrast calculation against background/surface; two dashboard IconButton hit-box dimensions; Flutter keyboard Tab/Shift+Tab/Enter traversal to Link Check | The 48px assertion currently covers only two dashboard icon actions; does not prove every target meets WCAG 2.2 target-size/spacing requirements. Keyboard test is not Android Switch Access evidence |
| `test/features/accessibility/text_scale_range_test.dart` | Current `main` test asserts 85% initial in-app scale and a 50–200% slider range in 5-point steps; verifies accessibility labels in 14 language packs | In-app preference only; Android system font/display scaling and combined scaling behaviour pending. A11Y-02 draft proposes a 100% fresh-install default, so re-check this test after that PR is integrated |
| `test/features/accessibility/browser_navigation_focus_test.dart` | Space activation of dashboard destination; focus restoration after returning from Link Check | Browser/keyboard-oriented Flutter test; not native Android hardware-keyboard or Switch Access evidence |
| `test/features/accessibility/onboarding_settings_responsive_test.dart` | Language picker and onboarding at widths 280–1920; visible locale tags; settings readable width; RTL plus 200% Flutter text scaling scenario | Simulated Flutter viewport coverage only; not Android display-size/font-scale testing |
| `test/widget_test.dart` | General dashboard labels/actions and other application widget regressions | Flutter test environment only; no native accessibility service observation |

## 3. Evidence interpretation and identified automation gaps

The current source-level tests establish a useful baseline for headings, selected live-region nodes, progress values, locale metadata, a limited set of dashboard hit boxes, and simulated responsive layouts. They do **not** currently establish:

- Android `AccessibilityNodeInfo` output, TalkBack speech/announcement timing, traversal order, or focus restoration on-device.
- Switch Access scan order, activation, or completion of workflows without touch gestures.
- Platform Android font-size/display-size behaviour, including interaction with the app's own text-scale preference.
- Accessible names, roles, values and state for every form control, camera permission path, dialog, menu, snackbar, result severity and error state.
- Equivalent non-drag/non-swipe alternatives for every gesture-driven interaction.
- RTL reading order and pronunciation through TalkBack.

These are coverage gaps to validate, not confirmed product defects. Do not add synthetic assertions that merely restate framework defaults; new automated tests should target app-owned semantics and remain deterministic.

## 4. Journey and assistive-technology matrix

Use the same representative journeys across supported Android device sizes. Record the exact app commit, build variant, Android version, device model, display size, font size, TalkBack version/settings, and test date.

| Journey / component | TalkBack checks | Switch Access checks | Scaling / layout checks | Current status |
|---|---|---|---|---|
| First-launch language picker | Heading, search field, result count, selected/unavailable state, language pronunciation | Reach and select each enabled option; no focus dead ends | Large font, portrait/landscape, RTL | Pending device |
| Onboarding | Page heading, progress, Continue/Back action names and state | All actions reachable and activatable | Large font; no clipped actions | Pending device |
| Dashboard and module cards | Card name, role, action, reading order, decorative content suppression | Every module and header action reachable | Large font, orientation, scroll | Pending device |
| Link Check | Input label/hint, validation errors, result severity and completion announcement | Input and submit/result actions operable | Keyboard visible, large font, landscape | Pending device |
| QR Check | Camera permission rationale, scan action, manual-entry path, result announcement | Camera/manual path and result actions operable | Camera permission and orientation transitions | Pending device |
| Message Check | Input label, detected findings/counts, result announcement | Input and action operable | Large font and multiline content | Pending device |
| Intelligence | Search/filter labels, result count, reference reading order | Search and filters operable | Large font, RTL, scroll | Pending device |
| Privacy and Academy | Progress labels/values, question/answer labels, feedback announcements | Review and lesson actions operable | Large font and scroll | Pending device |
| Response | Playbook headings, ordered steps, action labels | All actions reachable | Large font and scroll | Pending device |
| Appearance/accessibility settings | Control names, current values, selected state, slider adjustment | Every setting adjustable without precision gestures | Font scaling, bold text, reduced motion, contrast theme | Pending device |
| Dialogs, menus and snackbars | Focus entry/return, dismissal, announcement and no trapped focus | Dismiss/confirm actions reachable | Large font and orientation | Pending device |

## 5. Manual test protocol

### TalkBack
1. Install the debug build generated from the exact candidate commit.
2. Enable TalkBack through Android Settings; do not use a production account or real personal data.
3. Complete each journey using touch exploration and linear navigation.
4. Confirm each interactive element has a meaningful name, role and state; confirm decorative elements do not create noise.
5. Confirm focus order follows the visual and task sequence and remains visible where applicable.
6. Trigger validation, loading, completion, progress and error states; confirm important changes are announced without requiring the user to hunt for them.
7. Open and dismiss dialogs/menus; confirm focus is restored to a sensible control.
8. Repeat key journeys in RTL and with increased Android font/display size.

### Switch Access
1. Enable Android Switch Access using a standard scanning configuration.
2. Traverse the same journeys without touch gestures.
3. Confirm all actions can be reached and activated; verify there are no gesture-only paths or scanning traps.
4. Record controls requiring a simpler alternative.

### Scaling and orientation
1. Test Android font size and display size at default and the largest practical settings.
2. Test portrait and landscape on a compact phone and a larger phone/tablet where available.
3. Confirm text, controls, dialogs and bottom actions remain visible and usable; scrolling must expose content rather than clipping it.
4. Test RTL with a reviewed RTL locale.

## 6. Evidence and defect recording

For every finding record:
- Unique finding ID and affected journey/control.
- App commit SHA and build variant.
- Device model, Android version, screen size/orientation and scaling settings.
- Assistive technology and version/settings.
- Exact reproduction steps and expected/actual result.
- Severity and user impact.
- Fix commit and regression test, if remediated.
- Retest result.

Do not include real messages, phone numbers, URLs, QR payloads, contacts, account identifiers, or other personal data in evidence. Use synthetic examples only. Avoid retaining screen recordings unless separately justified and explicitly approved; concise written observations are preferred.

## 7. Initial risks to investigate (not confirmed defects)

| ID | Risk | Required evidence |
|---|---|---|
| AND-01 | Flutter semantics may differ between widget tests and Android accessibility node output | TalkBack node names/roles/states on a real device |
| AND-02 | Dynamic live-region announcements may be duplicated, omitted or poorly timed on Android | TalkBack observations for analysis, progress and validation updates |
| AND-03 | Gesture-driven camera/QR and other controls may lack equivalent Switch Access paths | Switch Access end-to-end completion |
| AND-04 | Platform font/display scaling may interact with in-app scaling and responsive layouts | Device screenshots/observations at large settings |
| AND-05 | RTL reading order and pronunciation may differ from visual layout | TalkBack testing in Arabic and Urdu |
| AND-06 | Focus may not be restored appropriately after dialogs, menus or route changes | TalkBack and Switch Access navigation observations |

## 8. Exit criteria

- The journey matrix has device-specific results and evidence references.
- Existing automated tests are mapped to the behaviour they actually assert.
- Reproducible issues are either fixed with regression coverage or explicitly deferred with rationale.
- TalkBack and Switch Access checks are performed on real Android hardware before claiming native accessibility readiness.
- Android findings remain separate from web results in the master WCAG 2.2 register.
- No WCAG2ICT/WCAG conformance claim is made from this workstream alone.

## 9. References

- W3C, [WCAG2ICT: Guidance on Applying WCAG 2 to Non-Web Information and Communications Technologies](https://www.w3.org/TR/wcag2ict/)
- Android Developers, [Build accessible apps](https://developer.android.com/guide/topics/ui/accessibility)
- Android Developers, [Test your app's accessibility](https://developer.android.com/guide/topics/ui/accessibility/testing)

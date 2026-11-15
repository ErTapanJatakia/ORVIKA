# ORVIKA WCAG 2.2 Level AA Accessibility Baseline

**Workstream:** ORVIKA-A11Y-01  
**Status:** Baseline initiated; conformance not assessed  
**Target:** WCAG 2.2 Level AA for the complete web application; WCAG2ICT-informed accessibility assessment for the native Android application.  
**Application:** ORVIKA Flutter web and Android; Android application ID `com.orvika.app`.

> **No conformance claim:** This document is a planning and evidence register, not an audit report or certification. All criteria begin as **Not assessed**. Existing source code and widget tests are leads for evaluation, not proof of conformance.

## 1. Assessment method and status vocabulary

Assess all 31 Level A and 24 Level AA success criteria in WCAG 2.2. WCAG Level AA is cumulative: every applicable Level A and Level AA criterion must be satisfied.

| Status | Meaning |
|---|---|
| Not assessed | No sufficient evaluation has been completed. |
| Needs manual verification | Source/tests suggest support, but required human, browser, device or assistive-technology verification remains. |
| Fail | A reproducible barrier or unmet criterion has been documented. |
| Pass | Criterion-specific evidence demonstrates conformance for the tested scope. |
| Not applicable | Criterion does not apply to the evaluated content/process; document the rationale. |

Do not mark a criterion Pass solely because an automated scanner or unit test reports no issue. Record evidence separately for web and Android. For Android, use W3C WCAG2ICT guidance to interpret relevant criteria for non-web software and record where platform behaviour or a criterion is not directly applicable.

## 2. Initial repository inventory (static review only)

The repository is a Flutter application targeting web and Android. The following existing coverage was identified by source-tree inspection:

- Accessibility tests exist for feature headings and semantics, live status announcements, progress values, onboarding/settings semantics, text-scale range and keyboard navigation/focus restoration.
- Application preferences include text scaling, bold text and reduced motion.
- Four themes are present: Obsidian, Aurora, Daylight and High Contrast.
- Main user-facing feature areas include Link Check, QR Check, Message Check, Intelligence, Privacy, Academy and Response.
- Language selection and appearance/accessibility settings are part of onboarding and account/settings flows.
- Existing tests are useful evidence inputs but do not establish full WCAG 2.2 AA conformance.
- Flutter web's browser accessibility tree and the native Android accessibility tree must be evaluated independently.

### Initial risk register (not yet confirmed failures)

| ID | Area | Why it requires assessment | Planned evidence |
|---|---|---|---|
| R-01 | Text scaling | App preference currently starts at 85%; verify effective system scaling, 200% enlargement, clipping and content/functionality. | Browser zoom/text resize; Android font/display scaling; screenshots and AT notes. |
| R-02 | Contrast | Four themes and multiple semantic status colours exist. | Contrast measurements for text, controls, focus indicators, charts and states in every theme. |
| R-03 | Reflow/responsive layouts | Flutter layouts change across mobile, tablet and desktop sizes. | 320 CSS px, 400% zoom/equivalent reflow, portrait/landscape and large text. |
| R-04 | Keyboard and focus | Existing tests cover selected browser focus journeys. | Full keyboard-only journey across every interactive page, dialogs, menus and errors. |
| R-05 | Screen-reader semantics | Existing tests cover selected labels, headings and live regions. | NVDA/Firefox or NVDA/Chrome and VoiceOver/Safari for web; TalkBack for Android. |
| R-06 | Touch targets and gestures | Dashboard cards, icon controls, camera and QR interactions need platform-specific review. | Target-size measurement and alternatives to dragging/multipointer gestures. |
| R-07 | Forms and security results | Security analysis inputs/results contain validation, progress and status information. | Label/error association, input purpose, error recovery and announcement tests. |
| R-08 | Maps and visual analytics | Threat/map/chart information may be visually encoded. | Text equivalent, accessible legend, table/summary and non-colour cues. |
| R-09 | Authentication and session flows | Account and session controls may introduce cognitive or time-limit barriers. | Accessible authentication review and applicable timing/extension assessment. |
| R-10 | Language and script support | Multiple languages and right-to-left scripts are supported. | Programmatic language, language-of-parts, reading order, glyph shaping and AT pronunciation. |

## 3. WCAG 2.2 Level A and AA criterion register

**Initial result for every row:** Web = Not assessed; Android = Not assessed.  
Evidence and results must be added only after the relevant evaluation has been performed.

| Criterion | Name | Level | Web result | Android result | Evidence / finding |
|---|---|---:|---|---|---|
| 1.1.1 | Non-text Content | A | Not assessed | Not assessed | |
| 1.2.1 | Audio-only and Video-only (Prerecorded) | A | Not assessed | Not assessed | |
| 1.2.2 | Captions (Prerecorded) | A | Not assessed | Not assessed | |
| 1.2.3 | Audio Description or Media Alternative (Prerecorded) | A | Not assessed | Not assessed | |
| 1.3.1 | Info and Relationships | A | Not assessed | Not assessed | |
| 1.3.2 | Meaningful Sequence | A | Not assessed | Not assessed | |
| 1.3.3 | Sensory Characteristics | A | Not assessed | Not assessed | |
| 1.4.1 | Use of Color | A | Not assessed | Not assessed | |
| 1.4.2 | Audio Control | A | Not assessed | Not assessed | |
| 2.1.1 | Keyboard | A | Not assessed | Not assessed | |
| 2.1.2 | No Keyboard Trap | A | Not assessed | Not assessed | |
| 2.1.4 | Character Key Shortcuts | A | Not assessed | Not assessed | |
| 2.2.1 | Timing Adjustable | A | Not assessed | Not assessed | |
| 2.2.2 | Pause, Stop, Hide | A | Not assessed | Not assessed | |
| 2.3.1 | Three Flashes or Below Threshold | A | Not assessed | Not assessed | |
| 2.4.1 | Bypass Blocks | A | Not assessed | Not assessed | |
| 2.4.2 | Page Titled | A | Not assessed | Not assessed | |
| 2.4.3 | Focus Order | A | Not assessed | Not assessed | |
| 2.4.4 | Link Purpose (In Context) | A | Not assessed | Not assessed | |
| 2.5.1 | Pointer Gestures | A | Not assessed | Not assessed | |
| 2.5.2 | Pointer Cancellation | A | Not assessed | Not assessed | |
| 2.5.3 | Label in Name | A | Not assessed | Not assessed | |
| 2.5.4 | Motion Actuation | A | Not assessed | Not assessed | |
| 3.1.1 | Language of Page | A | Not assessed | Not assessed | |
| 3.1.2 | Language of Parts | AA | Not assessed | Not assessed | |
| 3.2.1 | On Focus | A | Not assessed | Not assessed | |
| 3.2.2 | On Input | A | Not assessed | Not assessed | |
| 3.2.3 | Consistent Navigation | AA | Not assessed | Not assessed | |
| 3.2.4 | Consistent Identification | AA | Not assessed | Not assessed | |
| 3.2.6 | Consistent Help | A | Not assessed | Not assessed | |
| 3.3.1 | Error Identification | A | Not assessed | Not assessed | |
| 3.3.2 | Labels or Instructions | A | Not assessed | Not assessed | |
| 3.3.3 | Error Suggestion | AA | Not assessed | Not assessed | |
| 3.3.4 | Error Prevention (Legal, Financial, Data) | AA | Not assessed | Not assessed | |
| 3.3.7 | Redundant Entry | A | Not assessed | Not assessed | |
| 3.3.8 | Accessible Authentication (Minimum) | AA | Not assessed | Not assessed | |
| 4.1.2 | Name, Role, Value | A | Not assessed | Not assessed | |
| 4.1.3 | Status Messages | AA | Not assessed | Not assessed | |
| 1.2.4 | Captions (Live) | AA | Not assessed | Not assessed | |
| 1.2.5 | Audio Description (Prerecorded) | AA | Not assessed | Not assessed | |
| 1.3.4 | Orientation | AA | Not assessed | Not assessed | |
| 1.3.5 | Identify Input Purpose | AA | Not assessed | Not assessed | |
| 1.4.3 | Contrast (Minimum) | AA | Not assessed | Not assessed | |
| 1.4.4 | Resize Text | AA | Not assessed | Not assessed | |
| 1.4.5 | Images of Text | AA | Not assessed | Not assessed | |
| 1.4.10 | Reflow | AA | Not assessed | Not assessed | |
| 1.4.11 | Non-text Contrast | AA | Not assessed | Not assessed | |
| 1.4.12 | Text Spacing | AA | Not assessed | Not assessed | |
| 1.4.13 | Content on Hover or Focus | AA | Not assessed | Not assessed | |
| 2.4.5 | Multiple Ways | AA | Not assessed | Not assessed | |
| 2.4.6 | Headings and Labels | AA | Not assessed | Not assessed | |
| 2.4.7 | Focus Visible | AA | Not assessed | Not assessed | |
| 2.4.11 | Focus Not Obscured (Minimum) | AA | Not assessed | Not assessed | |
| 2.5.7 | Dragging Movements | AA | Not assessed | Not assessed | |
| 2.5.8 | Target Size (Minimum) | AA | Not assessed | Not assessed | |

## 4. Evaluation scope and representative journeys

Evaluate full pages/screens and complete user journeys, not isolated widgets alone.

### Web journeys
1. First visit → language selection → onboarding → dashboard.
2. Dashboard → each security module → submit input → review result → return.
3. Appearance/accessibility settings → change theme/text size/bold text/reduced motion → persist and restore.
4. Keyboard-only navigation through header, dashboard, modules, dialogs, settings and footer.
5. Error, empty, loading, success and warning states.
6. Narrow viewport, browser zoom, text spacing overrides and landscape/portrait changes.

### Android journeys
1. First launch → language selection → onboarding → dashboard using TalkBack.
2. Dashboard → security module → input → result → return using TalkBack and Switch Access.
3. Change system font/display size and in-app accessibility preferences.
4. Camera/QR workflow with accessible permission, scanning and result states.
5. Dialogs, system back, focus restoration, keyboard and external keyboard navigation.
6. Portrait/landscape, supported Android versions and high-contrast/theme combinations.

## 5. Required test environments

| Platform | Minimum evaluation set |
|---|---|
| Web | Current Chromium-based browser + NVDA; Firefox + NVDA; Safari + VoiceOver where available. |
| Android | TalkBack on at least one real device; Switch Access or equivalent switch navigation; Voice Access where available. |
| Responsive | 320 CSS px width, common mobile widths, tablet and desktop; browser zoom and text scaling. |
| Themes | Obsidian, Aurora, Daylight and High Contrast. |
| Locales | English, at least one RTL locale (Arabic or Urdu), and representative Indic/CJK script locales. |

Record browser/OS version, device model, assistive technology/version, test date, steps, expected result, actual result and evidence reference. Real-device and assistive-technology validation is required; automated CI is supplementary.

## 6. Automated tooling and CI plan

- Web: axe-core integrated with browser tests for representative routes; use Lighthouse as a diagnostic, not a conformance verdict.
- Flutter: widget semantics tests and Flutter accessibility guideline checks where supported by the pinned SDK.
- Add regression assertions for accessible names, roles/states, heading semantics, focus order, status announcements and text scaling.
- Run colour-contrast checks against actual rendered theme tokens and states; manually inspect cases automated tools cannot resolve.
- Keep accessibility CI separate from DP-01–DP-06. Avoid running Android release validation for web-only documentation or browser-only changes; run platform-specific suites based on changed scope and batch completion.
- Preserve all existing tests. Do not lower thresholds or remove assertions to make CI green.

## 7. A11Y workstream sequencing

| Work item | Scope | Dependency |
|---|---|---|
| A11Y-01 | Baseline, criterion register, journey and evidence inventory | Current repository |
| A11Y-02 | Shared visual/accessibility design tokens: contrast, typography, focus, targets | A11Y-01 |
| A11Y-03 | Web semantics, keyboard, reflow, forms and browser AT remediation | A11Y-01, A11Y-02 |
| A11Y-04 | Flutter/Android semantics, TalkBack, Switch Access, scaling and focus | A11Y-01, A11Y-02 |
| A11Y-05 | Dashboard, maps, charts and module-specific accessible alternatives | A11Y-03, A11Y-04 |
| A11Y-06 | Language selector, onboarding, account settings, dialogs and help | A11Y-03, A11Y-04 |
| A11Y-07 | Automated accessibility regression CI | A11Y-03 through A11Y-06 |
| A11Y-08 | Manual and assistive-technology validation; defect closure | A11Y-07 |
| A11Y-09 | W3C-generated web and Android accessibility statements | Verified findings from A11Y-08 |
| A11Y-10 | Conditional W3C WCAG 2.2 AA web logo placement | Web conformance evidence |

## 8. Conformance and badge release gate

Do not publish a WCAG 2.2 AA conformance claim or display the W3C WCAG 2.2 AA logo until:
- all applicable Level A and AA criteria pass for the complete web pages and responsive variations in scope;
- complete processes and accessibility-supported ways of using the content have been assessed;
- manual and assistive-technology testing has been completed and evidence retained;
- any exclusions or partial-conformance qualifications are accurately disclosed;
- the statement identifies the exact product scope, standard, level, date and feedback contact.

The web conformance logo does not certify the native Android app. Publish a separate Android accessibility statement based on WCAG2ICT-informed evaluation and platform testing. Reassess after material changes.

## 9. Normative and supporting references

- [W3C WCAG 2.2 Recommendation](https://www.w3.org/TR/WCAG22/)
- [W3C WCAG 2.2 Quick Reference](https://www.w3.org/WAI/WCAG22/quickref/)
- [W3C WCAG2ICT guidance](https://www.w3.org/TR/wcag2ict-22/)
- [W3C Accessibility Statement Generator](https://www.w3.org/WAI/planning/statements/generator/)
- [W3C WCAG conformance logo guidance](https://www.w3.org/WAI/WCAG22/wcag2.2AA)

**Baseline sign-off:** Pending criterion review and evidence collection.  
**Conformance status:** Not assessed. No WCAG 2.2 AA conformance claim is authorised by this document.

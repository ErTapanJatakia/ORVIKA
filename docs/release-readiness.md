# ORVIKA release readiness checklist

Status: pre-release prototype  
Review date: 16 November 2026  
Release channels under consideration: Web/PWA, Android, RuStore and Aurora OS

This checklist separates implemented application capabilities from evidence required before a public production release. A checked-in workflow, test or policy is not evidence that it has been executed.

## 1. Product and functional acceptance

- [ ] Complete an authorised end-to-end review of all eight modules: Sentinel, Link Check, QR Check, Message Check, Intelligence, Privacy, Academy and Response.
- [ ] Verify normal, empty, malformed-input, error, reset and navigation states.
- [ ] Confirm all security findings retain their evidence, uncertainty and safe-next-step explanation.
- [ ] Confirm no module automatically opens destinations, executes QR actions, sends messages or changes account/device settings.
- [ ] Review all module descriptions and limitations against the actual release build.

## 2. Security and privacy

- [ ] Run the manual repository configuration check: `node scripts/verify-security-config.cjs`.
- [ ] Run the authorised security/parser/persistence regression suites.
- [ ] Inspect actual production response headers and CSP enforcement in supported browsers.
- [ ] Capture network activity during Link, QR and Message analysis on supported Web and Android platforms.
- [ ] Verify QR selected-image cleanup and Web object-URL revocation, including cancellation and route disposal.
- [ ] Review Android permissions and confirm camera access is requested only for an explicitly started scan.
- [ ] Review dependencies, advisories, transitive licences and third-party notices.
- [ ] Confirm no submitted analysis content or findings enter analytics, crash reports or persistent app storage by design.
- [ ] Re-review the privacy notice whenever data flows, analytics, hosting or external services change.

## 3. Accessibility

- [ ] Run the physical Android TalkBack and Switch Access protocol.
- [ ] Run keyboard-only and screen-reader checks on supported desktop browsers.
- [ ] Run VoiceOver/Safari checks on a supported Apple device where available.
- [ ] Inspect rendered contrast, visible focus, touch targets and spacing across themes.
- [ ] Verify 200% text scaling, zoom/reflow, narrow viewports and RTL scripts.
- [ ] Record platform, version, test date, expected behaviour, observed result and linked defect.
- [ ] Do not claim WCAG 2.2 AA conformance or platform certification without complete supporting evidence.

## 4. Localization

- [ ] Keep reviewed locale status restricted to locales with documented human review.
- [ ] Complete native-speaker review of each draft UI/content pack before promotion.
- [ ] Review security, privacy, legal and incident-response terminology with appropriate subject-matter expertise.
- [ ] Validate Arabic and Urdu RTL behaviour on real platforms.
- [ ] Validate Simplified Chinese glyph coverage and line metrics on representative Android and browser platforms.
- [ ] Check language switching, placeholders, long strings, dialogs, errors and empty states.
- [ ] Keep Bashkir and Tatar excluded until their language packs and review gates are deliberately reopened.

## 5. Android, RuStore and Aurora

- [ ] Confirm the current Android scaffold, Gradle wrapper, package ID and minimum/target SDK requirements.
- [ ] Run the complete authorised Android validation batch after app-code changes are frozen.
- [ ] Test install, upgrade, launch, permissions, camera, offline behaviour and lifecycle on representative physical devices.
- [ ] Generate the release APK/AAB with a production upload key held outside the repository.
- [ ] Verify signing identity, artifact integrity, version code/name and reproducible build inputs.
- [ ] Keep the keystore and credentials out of Git, issues, chat and logs; maintain an encrypted offline recovery backup.
- [ ] Confirm current RuStore submission/signing requirements and account eligibility.
- [ ] Confirm Aurora certificate issuance and current Aurora packaging/signing requirements before preparing its artifact.
- [ ] Prepare store metadata, screenshots, privacy disclosures, support contact and release notes.

## 6. Web/PWA

- [ ] Build the production Web artifact from the approved source commit.
- [ ] Verify PWA installability, service-worker update behaviour and offline/online transitions.
- [ ] Test Chrome, Firefox and other explicitly supported browsers.
- [ ] Verify CSP compatibility, camera access, image decoding and critical asset loading.
- [ ] Verify analytics behaviour and ensure it remains separate from security-analysis data.
- [ ] Deploy only after explicit maintainer approval; verify the deployed commit and provide a rollback path.

## 7. Governance and release communication

- [ ] Update version, changelog and release notes.
- [ ] Reconcile README module status, supported platforms and known limitations.
- [ ] Review privacy notice, security policy, accessibility statement and third-party notices.
- [ ] Complete trademark/name and store-policy review separately from technical acceptance.
- [ ] Publish a clear vulnerability-reporting route and support contact.
- [ ] Obtain explicit release approval after all mandatory gates are either passed or consciously accepted with documented risk.

## Current execution boundary

As of this review, no CI run, Android validation, physical-device accessibility pass, production network capture, production header inspection or deployment was performed for the ORVIKA-08 through ORVIKA-11 implementation batch. Tests and scripts added during the batch remain unexecuted. Record them as **not run**, not passed.

## Release decision

ORVIKA should remain labelled a prototype until the mandatory functional, security/privacy, accessibility, localization, platform packaging and deployment gates are completed. Do not imply that local heuristics provide a guaranteed verdict or that code-level assurance is a certification.

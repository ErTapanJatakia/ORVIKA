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

- [ ] Run `node scripts/verify-pwa-readiness.cjs` against the approved Web source/build.
- [ ] Build the production Web artifact from the approved source commit.
- [ ] Verify install metadata and icon rendering in Chromium and Safari; add a PNG Apple touch icon if required by target iOS versions.
- [ ] Verify first-load, offline reload/navigation, reconnect, service-worker cache update and rollback behaviour on the exact production artifact.
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


## Dated assurance update — 23 November 2026

This addendum supersedes the earlier execution-boundary statement above **for the specific checks and run snapshots listed here**. The original checklist and historical review boundary are retained as a record of their review date.

### Completed automated evidence

- PR #268 merged: `f2cdcde1e9398940aea00f1848ac346b8b6087f8`.
- Post-merge ORVIKA CI, Free Security Assurance, Workflow Lint, Cloudflare Pages Preview Validation and CodeQL runs succeeded. Run IDs and scope limitations are recorded in [the dated release-assurance evidence](release-assurance-evidence-2026-11-23.md).
- Android Build Validation Run #75 successfully built and verified the signed release APK and AAB, confirmed matching signatures and the approved upload certificate fingerprint, and passed package/manifest/permission checks.
- The post-merge CI run intentionally skipped Android Build Validation and deployment steps; the separate Run #75 supplied the Android signing evidence.
- The preview validation was isolated; it was not a production deployment.

### Still outstanding / not inferred as passed

- Manual Android TalkBack and Switch Access testing.
- Browser-only end-to-end keyboard testing and desktop screen-reader testing.
- VoiceOver/Safari testing on a supported Apple device.
- Full rendered contrast/focus, zoom/reflow, text-scale, RTL and touch-target inventories.
- Full functional acceptance of all modules on the approved candidate build.
- Production network/data-flow capture, production response-header inspection, and platform-specific QR cleanup/lifecycle verification.
- Final store-specific RuStore and Aurora requirements and explicit maintainer release approval.

**Decision remains pre-release.** Successful automated workflows and signed artifact verification do not close manual accessibility, production-runtime, store-readiness or release-authorization gates. No production deployment or store submission is implied or authorised by this addendum.

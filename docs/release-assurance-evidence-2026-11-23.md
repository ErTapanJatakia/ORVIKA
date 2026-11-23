# ORVIKA Release-Assurance Evidence — 23 November 2026

**Assessment baseline:** repository `main` after PR #268 (merge commit `f2cdcde1e9398940aea00f1848ac346b8b6087f8`), with subsequent authorised workflow executions recorded below.  
**Status:** automated assurance evidence consolidated; manual accessibility and several release gates remain outstanding.  
**Release boundary:** no production deployment, store submission, public distribution or release publication was performed as part of this evidence collection.

## 1. Executive assessment

The Android production-signing pipeline has completed a successful end-to-end validation. The signed APK and Android App Bundle (AAB) were built and verified against the approved upload-certificate fingerprint. The 23 November post-merge security and preview workflows also completed successfully.

These results establish that the named automation and artifact checks passed for their respective run snapshots. They do **not** establish that ORVIKA is vulnerability-free, independently penetration-tested, certified, fully accessible, or ready for public release without the remaining acceptance gates.

## 2. Repository change and post-merge workflow evidence

PR #268 — [Fix Cloudflare Pages worker bundle upload and Android signing docs](https://github.com/ErTapanJatakia/ORVIKA/pull/268) — was merged on 23 November 2026.

- Merge commit: `f2cdcde1e9398940aea00f1848ac346b8b6087f8`
- Change: preserve Wrangler's multipart Pages Functions output as `build/web/_worker.bundle`, rather than misnaming it `_worker.js`; add a bundle metadata assertion.
- Documentation: align the Android signing guide with the actual CI secret names and local Gradle mapping.

Post-merge workflow evidence:

| Workflow | Run ID | Result | Scope / boundary |
|---|---:|---|---|
| ORVIKA CI | [45113805637](https://github.com/ErTapanJatakia/ORVIKA/actions/runs/45113805637) | Success | Flutter analysis, tests and Web build; Android Build Validation intentionally skipped; deployment steps skipped |
| Free Security Assurance | [45113805724](https://github.com/ErTapanJatakia/ORVIKA/actions/runs/45113805724) | Success | Configured static/security tool suite completed for this run |
| Workflow Lint | [45113805737](https://github.com/ErTapanJatakia/ORVIKA/actions/runs/45113805737) | Success | Workflow syntax/lint checks |
| Cloudflare Pages Preview Validation | [45113805698](https://github.com/ErTapanJatakia/ORVIKA/actions/runs/45113805698) | Success | Isolated preview validation, CSP/nonce checks, browser smoke checks and passive ZAP baseline; not a production deployment |
| CodeQL | [45113805333](https://github.com/ErTapanJatakia/ORVIKA/actions/runs/45113805333) | Success | Python, JavaScript/TypeScript and GitHub Actions analysis for this run |

The security assurance run included the configured Trivy, Semgrep, Gitleaks, Bandit, Bearer, DevSkim and OpenSSF Scorecard checks. A successful workflow means those configured jobs completed successfully; it is not a guarantee that every vulnerability class or runtime condition was tested.

## 3. Android signed release validation — Run #75

[Android Build Validation run #75](https://github.com/ErTapanJatakia/ORVIKA/actions/runs/45116016871) completed successfully with the signed-release option enabled by the maintainer.

Verified outcomes:

- Android project preflight and dependency resolution passed.
- Debug APK build and identity validation passed.
- All four required production signing secrets were detected by the workflow and the keystore was decoded and configured successfully.
- Signed release APK and AAB builds completed.
- APK signature verification and AAB signature verification passed.
- APK and AAB signer certificate sets matched.
- The signer fingerprint matched the previously approved SHA-256 upload-key fingerprint: `b859b30cd703e7592fa169618fe934f47533a95338f5e1b1a11b6bf985b822b5`.
- Application ID verified as `com.orvika.app`.
- AAB contained the expected `base` module.
- Manifest and permissions verification passed, including the reviewed permission allowlist and signature-level protection for the AndroidX dynamic receiver permission.
- The AAB manifest verifier passed its 21 automated checks.

Artifacts (GitHub retention is time-limited; preserve approved release evidence in the maintainer's controlled archive):

- [Signed APK/AAB artifacts](https://github.com/ErTapanJatakia/ORVIKA/actions/runs/45116016871/artifacts/14792280429)
- [Debug validation artifact](https://github.com/ErTapanJatakia/ORVIKA/actions/runs/45116016871/artifacts/14791667396)
- [AAB manifest diagnostics](https://github.com/ErTapanJatakia/ORVIKA/actions/runs/45116016871/artifacts/14792345157)

The debug APK is a validation artifact and is not a required user-side installation or test. The signed artifacts are build outputs, not a store submission or published release. Keep the private signing key and secret values confidential; do not place them in this repository or in public evidence.

## 4. Accessibility assurance status

The repository's [Accessibility Assurance Review](accessibility-assurance-review.md) records automated code-level coverage for semantic headings, selected live-region announcements, descriptive progress values, selected contrast pairs, dashboard touch targets, keyboard traversal and focus restoration.

The automated evidence must not be conflated with native assistive-technology execution. The following remain **not tested / outstanding** unless a separate dated execution record is added:

- Android TalkBack across the primary screens and dynamic security results.
- Android Switch Access.
- Desktop browser keyboard-only traversal across all primary routes and overlays.
- NVDA with Firefox and/or Chrome, and Windows Narrator with a supported browser.
- VoiceOver with Safari on a supported Apple device.
- Rendered contrast and focus-indicator inventory across themes and states.
- 200%/400% zoom, text scaling, reflow, magnification and representative RTL combinations on real platforms.

When performed, record device/OS, browser and version, assistive technology and version, viewport/text scale, test date, expected and observed behaviour, result, and linked defect. A widget test, CI pass or test protocol is not evidence that a manual test was executed. Do not claim WCAG 2.2 AA conformance or full screen-reader compatibility on this evidence alone.

## 5. Remaining release gates

The following are not closed by the successful runs above:

1. Manual accessibility validation listed in Section 4.
2. Complete functional acceptance of all eight product modules on the approved candidate build.
3. Production network/data-flow capture for Link, QR and Message analysis, with hosting/analytics traffic distinguished.
4. Inspection of actual production response headers and CSP behaviour on the approved deployment, if/when production deployment is separately authorised.
5. QR temporary-file/object-URL cleanup and lifecycle verification on representative real platforms.
6. Dependency/advisory/licence review against the exact release artifact and final resolved dependency graph.
7. Store-specific RuStore and Aurora packaging, account, certificate and metadata requirements.
8. Explicit maintainer release approval after mandatory gates are passed or risks are consciously accepted and documented.

Localization remains within its previously frozen scope. Bashkir and Tatar remain deferred; draft locale availability must not be represented as completed human-reviewed localization.

## 6. Deployment, distribution and authorization boundary

- No production Vercel or Cloudflare deployment was performed by the post-merge validation runs recorded here.
- No APK/AAB was submitted to RuStore, Aurora, Google Play, Apple App Store or another distribution channel.
- No public release was created or announced.
- No production signing secret or private key is reproduced in this document.

Any deployment, store submission, public distribution or release publication remains a separate action requiring explicit maintainer authorization.

## 7. Current decision

**Technical status:** Android signing pipeline verified; the listed automated assurance workflows passed for their recorded snapshots.  
**Accessibility status:** automated regression coverage exists; manual platform validation remains outstanding.  
**Release status:** **not yet approved for public release**. Retain prototype/pre-release positioning until the remaining mandatory acceptance gates are completed or explicitly risk-accepted by the maintainer.

---

*Evidence is time- and commit-scoped. Re-run or refresh the relevant checks when source, dependencies, workflows, build configuration, hosting configuration or release artifacts change.*

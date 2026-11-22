# ORVIKA SAST and DAST Findings Triage — 23 November 2026

## Scope and evidence

This is a finding-level review of the scanner artifacts produced by **ORVIKA Free Security Assurance**, workflow run [45058778552](https://github.com/ErTapanJatakia/ORVIKA/actions/runs/45058778552), associated with PR #254. The artifacts were downloaded and parsed, not inferred from green workflow status.

| Evidence | Artifact ID | Results |
|---|---:|---:|
| Bearer SARIF | 14768411992 | 18 |
| Bandit SARIF | 14768477868 | 6 |
| DevSkim SARIF | 14769045068 | 21 |
| ZAP passive JSON/HTML | 14768880970 | 4 alert categories |

**45 SARIF results were reviewed across the three SAST tools.** These are scanner results, not necessarily 45 unique vulnerabilities; overlapping rules and locations may describe the same underlying code path.

The separately reported **57 open GitHub Code Scanning alerts are not yet reconciled**. The connected GitHub integration does not expose the Code Scanning alerts endpoint. This report must not be interpreted as a disposition of all 57 alerts.

## Post-merge scanner verification

PR #256 was merged to `main` at commit `15690e01a18e5bdefe2a0f49f27af61c6f038265`. The post-merge **ORVIKA Free Security Assurance** run is [45060046869](https://github.com/ErTapanJatakia/ORVIKA/actions/runs/45060046869). Its SAST artifacts were downloaded and compared with the pre-merge outputs above.

| Scanner | Pre-merge results | Post-merge results | Change |
|---|---:|---:|---|
| Bearer | 18 | 17 | 1 fewer result |
| Bandit | 6 | 3 | 3 fewer results; both B101 import-guard notes and B607 PATH executable note disappeared |
| DevSkim | 21 | 21 | No change; all remain explained false positives |

Post-merge artifact IDs: Bearer **14769266563**, Bandit **14768906833**, DevSkim **14768677669**. The combined post-merge total is **41 SARIF results**, down from 45. This is not equivalent to closing 57 GitHub Code Scanning alerts.

Bearer still reports the subprocess, filesystem-path and dynamic-regex rules. Code review confirms the subprocess uses separate argv elements with `shell=False`; the privacy walker now skips symlinks and receives filenames from `readdirSync`; and the regex is loaded from the local generated Vercel route configuration and applied to fixed paths. The remaining logger rules still flag dynamic but sanitized diagnostic values, public build metadata, or counts; no credential or user-submitted content is included in the reviewed log statements after PR #256.

Bandit now reports only B404 for intentional subprocess module use and B603 for the controlled bundletool invocation. These remain documented low-severity notes; they are not hidden or suppressed.

Post-merge Bearer residual locations (17 results) are: `scripts/verify-android-aab-manifest.py:84`; `scripts/verify-privacy-boundaries.cjs:33`; `.github/scripts/verify-vercel-output.cjs:38,51`; `.github/scripts/orvika-browser-smoke.cjs:89,151,166,193`; `scripts/verify-android-apk-manifest.cjs:59,60`; `scripts/verify-android-release-readiness.cjs:179-182,186`; `scripts/verify-privacy-boundaries.cjs:63`; and `scripts/verify-pwa-readiness.cjs:87`. The four browser-smoke log findings now refer to sanitized URLs/headers, structural renderer metadata, a fixed viewport label and a count of console errors; the raw DOM, markup, script URLs, console text and exception stack are no longer logged.

Post-merge Bandit residuals (3 results) are B404 at `scripts/tests/test_verify_android_aab_manifest.py:8` and `scripts/verify-android-aab-manifest.py:6`, plus B603 at `scripts/verify-android-aab-manifest.py:84`. The two B101 findings and B607 no longer appear.

The post-merge ZAP artifact is **14769520647**. It still reports the same four categories, including Medium/High-confidence `style-src unsafe-inline` on the validation host. That finding remains open.

## Executive disposition

- No confirmed remotely exploitable vulnerability was established from the 41 post-merge SARIF results alone; context-dependent scanner findings remain documented.
- Bearer identified code paths that warranted hardening, especially verbose browser-smoke diagnostics, symlink traversal during source walking, and subprocess invocation. The hardening changes were merged in PR #256 after Workflow Lint, CI and Security Assurance passed. Post-merge SARIF confirms the Bandit B101 and B607 records disappeared; several context-dependent Bearer logger/path/subprocess rules remain and are documented below.
- Bandit produced six low-severity notes. Two test-only import guards are being replaced; subprocess usage remains intentional and is constrained to an argv list with `shell=False`.
- All 21 DevSkim results are explainable false positives in this repository: Android XML namespace URIs or public integrity identifiers (pinned Flutter commit SHAs and a public certificate fingerprint). No credential or secret value was identified in these results.
- ZAP's Medium/High-confidence CSP observation is real for the scanned validation host at scan time: its response used `style-src 'self' 'unsafe-inline'`. This remains open pending a fresh preview deployment/compatibility validation. The other three ZAP categories are informational observations.
- The first npm lockfile-backed install reported 38 dependency advisories (16 moderate, 21 high, 1 critical). The individual advisory inventory is being captured in PR #258; npm dependency remediation is open and blocks completion.

## 1. Bearer — 18 results

| # | Rule | Location | Triage and disposition |
|---:|---|---|---|
| 1 | `python_lang_os_command_injection` | `scripts/verify-android-aab-manifest.py:79` | **Contextual/accepted residual.** The code calls `subprocess.run` with a list of separate arguments and does not use a shell or construct a command string. The AAB and bundletool paths are explicit workflow inputs. PR #256 resolves Java to an executable path and explicitly sets `shell=False`. The post-merge Bearer rule remains, but code review found no shell interpolation; Bandit B603 remains as a low-severity note. |
| 2 | `javascript_lang_path_traversal` | `scripts/verify-privacy-boundaries.cjs:31` | **Mitigated design; scanner rule remains.** The path segment is a filename returned by `readdirSync`, not an arbitrary user-supplied path. PR #256 now skips symbolic links, and its CI verified that the privacy checker still scans 15 Dart files. Bearer still flags the dynamic `path.join`; no attacker-controlled path component is present in this walk. |
| 3 | `javascript_lang_dynamic_regex` | `.github/scripts/verify-vercel-output.cjs:38` | **Contextual/low risk; monitor.** `route.src` is read from the locally generated Vercel Build Output configuration and evaluated only against the fixed paths `/` and `/index.html`. It is not a runtime user-controlled regex. Retain the finding in the register; consider a bounded-pattern check if generated route configuration becomes externally influenced. |
| 4 | `javascript_lang_logger_leak` | `.github/scripts/orvika-browser-smoke.cjs:80` | **Reviewed residual; no sensitive data observed.** The prior diagnostic logged full response URLs, redirect information and response headers. PR #256 now strips URL query/fragment/user-info by logging origin/path only and narrows the header allowlist. The remaining rule flags the sanitized diagnostics; reviewed fields are limited to origin/path and security response headers. |
| 5 | `javascript_lang_logger_leak` | `.github/scripts/orvika-browser-smoke.cjs:142` | **Hardening implemented; retest pending.** The renderer diagnostic previously included body text, body markup and script URLs. PR #256 now replaces content with lengths/counts, avoiding page-content disclosure in CI logs. The remaining rule flags structural renderer metadata only; body content, markup and script URLs are no longer logged. |
| 6 | `javascript_lang_logger_leak` | `.github/scripts/orvika-browser-smoke.cjs:157` | **False positive.** The logged value is a fixed viewport label followed by the static text “viewport passed”; it does not contain user input, credentials or page content. |
| 7 | `javascript_lang_logger_leak` | `.github/scripts/orvika-browser-smoke.cjs:184` | **Hardening implemented; retest pending.** Raw browser console messages were logged. PR #256 now logs only the count of observed console errors; CSP detection remains active. The remaining rule flags the numeric count, not console message contents. |
| 8 | `javascript_lang_logger_leak` | `.github/scripts/orvika-browser-smoke.cjs:194` | **Hardening implemented; retest pending.** The catch handler previously printed the complete error object/stack. PR #256 now reports only the error class and preserves a failing exit code; the raw exception object and stack are no longer logged. |
| 9 | `javascript_lang_logger_leak` | `.github/scripts/verify-vercel-output.cjs:51` | **Hardening implemented; retest pending.** The prior logger printed complete generated route objects. PR #256 now logs only route-match and header-route counts; the full generated route objects are no longer logged. |
| 10 | `javascript_lang_logger_leak` | `scripts/verify-android-apk-manifest.cjs:59` | **False positive.** Logs the public Android application ID, `com.orvika.app`; no signing material or credentials are printed. |
| 11 | `javascript_lang_logger_leak` | `scripts/verify-android-apk-manifest.cjs:60` | **False positive.** Logs the reviewed Android permission names; these are manifest metadata, not secrets. |
| 12 | `javascript_lang_logger_leak` | `scripts/verify-android-release-readiness.cjs:179` | **False positive.** Logs the public app version only. |
| 13 | `javascript_lang_logger_leak` | `scripts/verify-android-release-readiness.cjs:180` | **False positive.** Logs the reviewed Gradle wrapper version and the fact that its checksum is pinned, not the signing key. |
| 14 | `javascript_lang_logger_leak` | `scripts/verify-android-release-readiness.cjs:181` | **False positive.** Logs the public Android Gradle Plugin version. |
| 15 | `javascript_lang_logger_leak` | `scripts/verify-android-release-readiness.cjs:182` | **False positive.** Logs the public Kotlin plugin version. |
| 16 | `javascript_lang_logger_leak` | `scripts/verify-android-release-readiness.cjs:186` | **False positive.** Logs only a categorical signing-readiness state; it explicitly avoids displaying credential values. |
| 17 | `javascript_lang_logger_leak` | `scripts/verify-privacy-boundaries.cjs:61` | **False positive.** Logs the count of scanned Dart files only. |
| 18 | `javascript_lang_logger_leak` | `scripts/verify-pwa-readiness.cjs:87` | **False positive.** Logs whether Flutter emitted a service-worker artifact; no sensitive data is included. |

### Bearer verification required

PR #256 has passed its PR checks and is merged. Review the fresh post-merge Bearer SARIF from main workflow run #118 to verify the implemented changes. Do not suppress the rules to obtain a clean count.

## 2. Bandit — 6 results

| # | Rule | Location | Triage and disposition |
|---:|---|---|---|
| 1 | B101 | `scripts/tests/test_merge_pub_deps_into_cyclonedx.py:9` | **Resolved in PR #256.** A module-import precondition used Python `assert`, which can be removed under optimized execution. PR #256 replaced it with an explicit runtime exception; B101 no longer appears in post-merge Bandit SARIF. |
| 2 | B404 | `scripts/tests/test_verify_android_aab_manifest.py:8` | **Informational/accepted.** The test imports `subprocess` to mock the production verifier's intentional external-tool invocation. It does not execute an untrusted shell command. |
| 3 | B101 | `scripts/tests/test_verify_android_aab_manifest.py:12` | **Test guard hardening implemented; retest pending.** Same import-loader precondition as finding #1; PR #256 replaced the assertion with an explicit runtime check; B101 no longer appears in post-merge Bandit SARIF. |
| 4 | B404 | `scripts/verify-android-aab-manifest.py:5` | **Informational/accepted.** The verifier intentionally invokes the pinned bundletool JAR through Java to inspect AAB manifests. |
| 5 | B607 | `scripts/verify-android-aab-manifest.py:79` | **Hardening implemented; retest pending.** Previously invoked the `java` executable by its PATH name. PR #256 now resolves it with `shutil.which` and passes the resulting executable path; B607 no longer appears in post-merge Bandit SARIF. |
| 6 | B603 | `scripts/verify-android-aab-manifest.py:79` | **Mitigated design; accepted residual.** The subprocess call uses an argv list, not shell interpolation; PR #256 explicitly sets `shell=False`. The executable and artifact paths are controlled by the CI workflow; retain the low-severity residual in the next SARIF review. Keep this low-severity note documented rather than hiding the rule. |

Bandit marked these records as low severity and low confidence in its SARIF properties. The successful job status is not treated as proof of zero findings.

## 3. DevSkim — 21 results

### DS137138 — 14 “Insecure URL” warnings

All 14 locations contain the Android XML namespace URI `http://schemas.android.com/apk/res/android`. This URI identifies an XML namespace; it is not a remote HTTP request or a cleartext application endpoint.

| # | Location |
|---:|---|
| 1 | `scripts/verify-android-aab-manifest.py:14` |
| 2 | `scripts/tests/test_verify_android_aab_manifest.py:96` |
| 3 | `scripts/tests/test_verify_android_aab_manifest.py:58` |
| 4 | `scripts/tests/test_verify_android_aab_manifest.py:29` |
| 5 | `scripts/tests/test_verify_android_aab_manifest.py:20` |
| 6 | `android/app/src/main/res/drawable/ic_launcher_foreground.xml:2` |
| 7 | `android/app/src/main/res/drawable-v21/launch_background.xml:2` |
| 8 | `.github/workflows/android-build.yml:83` |
| 9 | `android/app/src/main/AndroidManifest.xml:2` |
| 10 | `android/app/src/main/res/drawable/launch_background.xml:2` |
| 11 | `android/app/src/profile/AndroidManifest.xml:1` |
| 12 | `android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml:2` |
| 13 | `android/app/src/debug/AndroidManifest.xml:1` |
| 14 | `android/app/src/main/res/mipmap-anydpi/ic_launcher.xml:2` |

**Disposition:** False positives. Do not rewrite Android namespace identifiers to HTTPS; that would be incorrect XML namespace usage. No insecure network endpoint was identified by these 14 records.

### DS173237 — 7 “Token or key in source” errors

| # | Location | Value type | Disposition |
|---:|---|---|---|
| 1 | `.github/workflows/cloudflare-preview.yml:68` | Pinned Flutter Git commit SHA | False positive; public immutable source revision. |
| 2 | `.github/workflows/ci.yml:72` | Pinned Flutter Git commit SHA | False positive; public immutable source revision. |
| 3 | `.github/workflows/cloudflare-pages.yml:68` | Pinned Flutter Git commit SHA | False positive; public immutable source revision. |
| 4 | `.github/workflows/android-build.yml:292` | SHA-256 fingerprint of the expected signing certificate | False positive; public certificate identity pin, not private key material. |
| 5 | `.github/workflows/android-build.yml:69` | Pinned Flutter Git commit SHA | False positive; public immutable source revision. |
| 6 | `.github/workflows/security-assurance.yml:192` | Pinned Flutter Git commit SHA | False positive; public immutable source revision. |
| 7 | `.github/workflows/security-assurance.yml:67` | Pinned Flutter Git commit SHA | False positive; public immutable source revision. |

**Disposition:** False positives based on the exact matched values and their use. No API token, password, private key or signing secret was identified in these seven records. Keep the public integrity pins; do not remove them to satisfy a heuristic scanner.

## 4. OWASP ZAP passive DAST — 4 alert categories

The scan target was `https://orvika-validation.orvika.pages.dev`.

| Alert | Risk / confidence | Instances | Disposition |
|---|---|---:|---|
| CSP: `style-src unsafe-inline` | Medium / High | 4 | **Open.** The response evidence contains `style-src 'self' 'unsafe-inline'`. This is a real policy weakness on the scanned preview at scan time. The repository already contains a host-gated nonce prototype in `functions/_middleware.js`, but the scan did not observe its nonce-based policy. A fresh preview deployment and browser compatibility validation are required before changing production policy. |
| Modern Web Application | Informational / Medium | 4 | Informational fingerprinting only; no remediation required. |
| Re-examine Cache-control Directives | Informational / Low | 5 | Review confirms public static application resources and `public, max-age=0, must-revalidate` behavior. No sensitive authenticated response was identified in the listed instances. Retain as informational; do not blindly apply `no-store` to all static assets. |
| Storable but Non-Cacheable Content | Informational / Medium | 5 | Responses are storable but require revalidation (`max-age=0`). The listed instances are public application resources. No sensitive user-specific response was identified. Retain as informational. |

### CSP follow-up

The current source policy in `vercel.json` and the default Cloudflare middleware policy still include `style-src 'unsafe-inline'`. The validation-host nonce branch in `functions/_middleware.js` is intended to replace that policy only on the dedicated preview hostname. The ZAP evidence demonstrates that this replacement was not present in the scanned response. The dedicated Cloudflare preview workflow is manually dispatched and was not available through the connected GitHub action controls in this session. Do not alter production CSP or deploy to production as a shortcut. Re-run the preview-only validation workflow, then re-scan and test the Flutter UI before making a policy change.

## 5. Bounded parser fuzzing verification

PR #255 was merged to `main` at commit `fe49325700c211ed3a802d9d1a1f4f508a10bc04`. The deterministic URL, message and QR fuzz test passed the full Flutter CI test suite and the Free Security Assurance workflow. The first generator design failed three consecutive CI attempts (two analyzer lint issues and one character-bound violation); in accordance with the three-failure rule, the generator was redesigned to enforce a character-level ceiling before the final successful run. No test was weakened or removed. The corpus is deterministic, seeded, capped at 1,024 characters and 192 cases, with explicit oversized-input checks.

## 6. Outstanding items and acceptance criteria

1. **PR #256:** merged after all three required workflows passed. Post-merge SARIF shows the Bandit B101 and B607 records have cleared; remaining Bearer results are contextually reviewed and documented.
2. **PR #255:** merged after Workflow Lint, CI and Security Assurance passed. Deterministic bounded fuzz coverage is now in `main`.
3. **npm integrity:** **PR #258** now contains a dedicated tooling manifest and npm v3 lockfile (480 package entries; zero registry entries missing integrity metadata). It replaces the six npm install invocations and ephemeral Wrangler execution with lockfile-backed `npm ci` and local CLI binaries in the CI, Cloudflare Pages and Cloudflare preview workflows. A new verifier checks exact direct versions and requires registry integrity metadata for every locked package before installation. The final `npm ci` commands retain npm's default audit behavior; only funding notices are suppressed. PR #258 also adds an explicit `npm audit --audit-level=high` gate and a targeted Trivy scan of `.github/tooling` with a HIGH/CRITICAL exit gate. However, the first lockfile-backed `npm ci` audited 340 installed packages and reported **38 advisories (16 moderate, 21 high, 1 critical)**. PR #258 now captures the full `npm audit --json` report and targeted Trivy evidence before enforcing high/critical gates. Dependency remediation is therefore still open; do not merge or call npm hardening complete until the advisories are individually reviewed and resolved or justified.
4. **CSP:** run the dedicated preview-only Cloudflare workflow and confirm nonce-based response headers and application compatibility; re-run ZAP. Production remains untouched.
5. **GitHub Code Scanning:** obtain the 57-alert inventory from GitHub UI or a supported alert endpoint. For each alert, capture rule/tool, severity, file/line, state, code context and fix/dismissal evidence. No bulk dismissal is authorised.
6. **Final assurance:** publish a final report only after all findings have an evidence-backed disposition and all fixes have passed the relevant regression/scanner checks.

## 7. Guardrails

- No alert was dismissed, suppressed or bulk-closed as part of this triage.
- No scanner, test or CI gate was weakened.
- No production deployment, signed release, store publication or keystore change was performed.
- ZAP informational alerts and scanner false positives remain documented with rationale; they are not represented as fixed vulnerabilities.
- After three consecutive failures of the same CI/test strategy, stop repeating that strategy and redesign or defer it.

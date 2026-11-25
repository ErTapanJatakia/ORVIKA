# ORVIKA — OWASP MASTG Android Test Execution Plan

**Workstream:** 3 of 3  
**Status:** Prepared; no MASTG test executed under this assessment yet  
**Guide baseline:** OWASP MASTG v2.0.0 and current atomic test catalogue  
**Target:** Android Flutter APK, package `com.orvika.app`  
**Source baseline:** `41c73039b146b8f83418a156c51adde458523921`

## Test approach

Use current MASTG v2 test entries only; older entries marked deprecated are not valid substitutes. At execution record test ID, title, platform, profile, exact test revision and official page. Combine source/configuration review, APK static analysis, isolated runtime testing, network interception, dependency/SBOM and signing verification, and manual privacy/platform testing.

Automated tools are supporting evidence, not an overall verdict. Tailor tests to Flutter, Android embedding, plugins and native transitive dependencies.

## Mandatory artifact gate

Before binary or runtime tests:
- Obtain the exact signed APK intended for distribution.
- Copy it to a read-only evidence directory; do not rebuild, re-sign, zipalign, patch or modify it.
- Record filename, size, SHA-256, package ID, versionName/versionCode, signing certificate SHA-256, signature scheme and build timestamp.
- Confirm package `com.orvika.app` and confirm the APK is the intended distribution artifact.
- If split APK/APKS/AAB is the actual distribution artefact, record/test that package set separately.
- If unavailable, binary/runtime tests remain BLOCKED; do not substitute an unverified debug APK.

## Prioritised current Android MASTG test matrix

IDs and topics below were checked against the current MASTG catalogue during planning. Final applicability must be reconciled with the selected MAS profile and current catalogue at execution. All start as NOT TESTED.

| MASTG test ID | Current catalogue topic | ORVIKA-specific execution |
|---|---|---|
| MASTG-TEST-0200 | Files written to external storage | Inspect runtime writes and QR picker/cache paths |
| MASTG-TEST-0201 | Runtime APIs accessing external storage | Trace plugin and app runtime file access |
| MASTG-TEST-0202 | External storage API/permission references | Static scan source and packaged code |
| MASTG-TEST-0203 | Runtime logging APIs | Trigger Link/QR/Message checks; inspect logcat for input/result leakage |
| MASTG-TEST-0204 | Insecure random API usage | Search Dart/native code and dependencies for non-cryptographic RNG in security-sensitive functions |
| MASTG-TEST-0205 | Non-random sources usage | Review security-relevant random/identifier sources |
| MASTG-TEST-0207 | Unencrypted data in app sandbox at runtime | Inspect app-private files and persistence during/after analysis |
| MASTG-TEST-0208 | Insufficient key sizes | Apply if cryptographic keys are present |
| MASTG-TEST-0212 | Hardcoded cryptographic keys in code | Search source and APK strings/resources/native libs |
| MASTG-TEST-0216 | Sensitive data not excluded from backup | Inspect effective backup policy and test backup/restore where supported |
| MASTG-TEST-0217 | Insecure TLS protocols explicitly allowed in code | Static review of Android/network config and plugin stacks |
| MASTG-TEST-0218 | Insecure TLS protocols in network traffic | Capture app/SDK traffic and inspect negotiated protocol/cipher |
| MASTG-TEST-0221 | Broken symmetric encryption algorithms | Apply if app/SDK crypto usage exists |
| MASTG-TEST-0224 | Insecure APK signature version | Verify signature schemes on immutable release APK |
| MASTG-TEST-0225 | Insecure APK signature key size | Inspect signing certificate/key parameters |
| MASTG-TEST-0226 | Debuggable flag enabled | Inspect packaged release manifest |
| MASTG-TEST-0227 | Debugging enabled for WebViews | Verify WebView usage and packaged/runtime debugging flags |
| MASTG-TEST-0233 | Hardcoded HTTP URLs | Search source, assets, APK strings and runtime destinations |
| MASTG-TEST-0235 | Android configuration allowing cleartext traffic | Inspect packaged manifest and network security config |
| MASTG-TEST-0250 | WebView content-provider access references | Execute if Android WebView is present in app/plugin code |
| MASTG-TEST-0251 | Runtime WebView content-provider access | Execute if WebView is present |
| MASTG-TEST-0252 | WebView local-file access references | Execute if WebView is present |
| MASTG-TEST-0253 | Runtime WebView local-file access | Execute if WebView is present |
| MASTG-TEST-0254 | Dangerous app permissions | Inspect packaged permissions and runtime prompts |
| MASTG-TEST-0258 | Keyboard caching attributes | Assess text fields and sensitive input handling; L2 applicability |
| MASTG-TEST-0262 | Backup configurations not excluding sensitive data | Review legacy and Android 12+ backup/data-extraction rules |
| MASTG-TEST-0272 | Dependencies with known vulnerabilities in Android project | Scan resolved Gradle/Maven/AAR graph |
| MASTG-TEST-0274 | Dependencies with known vulnerabilities in app SBOM | Generate Android SBOM and scan it |
| MASTG-TEST-0282 | Unsafe custom trust evaluation | Search native/plugin code and dynamically test trust failures |
| MASTG-TEST-0283 | Incorrect server hostname verification | Verify hostname mismatch is rejected on applicable stacks |
| MASTG-TEST-0287 | Runtime unencrypted SharedPreferences storage | Inspect preference files; assess against L2 and data sensitivity |
| MASTG-TEST-0289 | Sensitive content in screenshots during app backgrounding | Inspect app-switcher snapshots while checker inputs/results are displayed |
| MASTG-TEST-0291 | References to screen-capture prevention APIs | Determine whether prevention is required for data sensitivity/profile |
| MASTG-TEST-0295 | GMS security provider not updated | Determine applicability to resolved SDK/runtime and supported Android versions |
| MASTG-TEST-0312 | Explicit security provider references in crypto APIs | Apply if app/native dependencies invoke crypto providers |
| MASTG-TEST-0315 | Sensitive data exposed via notifications | Verify whether app/dependencies create notifications |
| MASTG-TEST-0318 | SDK APIs known to handle sensitive user data | Review SDK APIs and privacy implications |
| MASTG-TEST-0319 | Runtime use of SDK APIs handling sensitive user data | Runtime-observe relevant SDK behaviour |

## Profile-dependent and conditional tests

- MAS-L2: additional runtime storage, screenshots, keyboard caching, certificate pinning and sensitive-data controls where selected.
- MAS-R: signing, debugging symbols, anti-debugging, root/emulator detection, reverse-engineering resistance and runtime integrity. Do not assume these are required unless MAS-R is formally selected.
- MAS-P: privacy-specific traffic, tracking-domain, permission and SDK data-collection checks; add current privacy-profile tests at kickoff.
- Placeholder tests: do not report placeholder entries as executed/passed. Use a documented manual test if a control still requires verification.

## Free-first tooling plan

| Tool/source | Purpose | Evidence |
|---|---|---|
| Android SDK `apkanalyzer` / `aapt2` | Package identity, manifest, SDK and resources | Commands/output and tool version |
| `apksigner` | APK signature scheme and certificate fingerprint | Verification output |
| JADX | DEX/source reconstruction and string/resource inspection | Search notes and relevant extracts |
| MobSF (local/self-hosted) | Static/dynamic APK triage | Raw report plus manual validation |
| adb / logcat | Runtime component, permission, logging and lifecycle tests | Redacted logs and commands |
| Frida (isolated lab only) | Runtime instrumentation when needed | Script, target hash and output |
| Burp Suite Community or mitmproxy | Network interception and TLS validation | Redacted proxy capture and CA/test setup |
| OSV-Scanner / Dependency-Check / osv.dev | Dependency advisory review | SBOM/input lockfiles, DB timestamp and raw output |
| Syft / CycloneDX tooling | SBOM generation | SBOM file and hash |
| Android Studio APK Analyzer | Packaged manifest/DEX/native library inspection | Exported report/screenshots |

Do not upload proprietary binaries or user data to public scanning services. Prefer local execution. Use synthetic data and an isolated device/profile for interception.

## Runtime scenarios

1. Fresh install, first launch and permission prompt timing.
2. Camera permission allow, deny, deny permanently, revoke in settings and camera unavailable.
3. Link Check with benign/adversarial URL syntax; confirm no automatic navigation or outbound reputation lookup.
4. Message Check with synthetic phishing text, URLs and contacts; inspect logs and traffic.
5. QR camera/image scanning: normal completion, no code, multiple codes, invalid/oversized file, cancel, route pop and process termination.
6. Clear/reset input and result; inspect app-private files, cache and process state.
7. Background/foreground while inputs/results are visible; inspect recents snapshots and lifecycle cleanup.
8. Offline/constrained/untrusted network; observe app and SDK behaviour separately.
9. TLS interception, invalid CA, hostname mismatch and cleartext attempts; confirm expected failure without weakening trust.
10. Update/install over existing data and backup/restore scenarios where supported.
11. Inspect permissions, exported components, deep links, notifications, clipboard, keyboard and accessibility surfaces.
12. Release build integrity, debuggability, signing, native symbols and dependency inventory.

## Test case record template

| Field | Required value |
|---|---|
| Test ID/title | Exact current MASTG identifier and title |
| MASVS mapping | Exact control ID(s) |
| MASWE mapping | Stable weakness ID(s) |
| Artifact | APK filename, SHA-256, package/version, signing fingerprint |
| Environment | Device, Android build/patch, architecture, tools |
| Preconditions | State, permissions, test data and network |
| Steps | Reproducible numbered procedure |
| Expected result | Security requirement |
| Actual result | Observed behaviour |
| Evidence | Evidence ID, redacted capture/log/screenshot |
| Result | PASS / FAIL / PARTIAL / N/A / NOT TESTED / BLOCKED |
| Finding | Finding ID, severity and remediation |
| Retest | New build/hash, date and outcome |

## Execution constraints

- No production deployment or production configuration mutation.
- No rebuild, patch, re-sign or replacement of signed Android release.
- No use of signing secrets or private keys during assessment.
- Do not run Android build-validation CI as part of this planning step.
- Runtime tests require an isolated device/profile and synthetic data.
- Stop if a test risks modifying the signed artifact, production data, account state or store submission.
- Preserve original evidence; redact personal data and credentials.
- After three consecutive failures of the same test/tool strategy, change approach or document BLOCKED; do not weaken tests.

## Current conclusion

No MASTG test has been executed under this plan. The exact signed APK and its hash are the principal prerequisites for binary/runtime testing. Source-only checks may proceed separately but cannot substitute for APK-based verification.

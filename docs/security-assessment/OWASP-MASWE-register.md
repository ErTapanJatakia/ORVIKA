# ORVIKA — OWASP MASWE Weakness Register

**Workstream:** 2 of 3  
**Status:** Prepared; weakness applicability review and testing pending  
**Catalogue baseline:** OWASP MASWE v1.0.0 (stable)  
**Source baseline:** `41c73039b146b8f83418a156c51adde458523921`

## Method

Use stable MASWE v1.0.0 identifiers. The 2026 stable release consolidated and renumbered the beta catalogue; beta identifiers must not be copied into this assessment.

Review all catalogue entries. The ranges below are triage aids only: split every range into its individual official MASWE IDs in the execution register. “Candidate” is a prioritisation, not a confirmed vulnerability. Every entry remains NOT TESTED until evidence supports a conclusion.

## Prioritised weakness worklist

| MASWE ID(s) | Weakness theme | ORVIKA-specific assessment focus | Initial triage |
|---|---|---|---|
| MASWE-0001 | Sensitive data unencrypted in private storage | Preferences, files, cached image data and analysis inputs | Candidate |
| MASWE-0002 | Sensitive data outside private storage | QR picker temporary files and shared/external storage | Candidate |
| MASWE-0003 | Keys outside platform keystore | Determine whether app or SDK creates/stores keys | Conditional |
| MASWE-0004 | Sensitive data hardcoded in package | Secrets, endpoints, tokens, signing material and embedded credentials | Candidate |
| MASWE-0005 | Sensitive data in logs | Dart/native/plugin logs and crash/error output | Candidate |
| MASWE-0006 | Sensitive data not excluded from backup | Effective backup and data-extraction rules | Candidate |
| MASWE-0007–0017 | Cryptography misuse | Identify app-owned crypto, key generation/derivation, RNG, MAC, hashing, signatures, rotation and device-lock dependency | Conditional |
| MASWE-0018–0025 | Authentication/authorization | No account/auth feature identified; verify components, sensitive actions and SDK auth flows | Conditional / likely N/A by control |
| MASWE-0026 | Network traffic not encrypted | Runtime traffic from app and bundled SDKs | Candidate |
| MASWE-0027 | Insecure certificate validation | TLS trust and hostname verification, including custom stacks | Candidate |
| MASWE-0028 | Insecure identity pinning | Decide profile requirement and whether pinning is appropriate; absence alone is not automatically a defect | Conditional |
| MASWE-0029 | Insecure deep links | Inspect manifest and packaged intent filters; none visible in main manifest | Conditional |
| MASWE-0030 | Improper clipboard use | Verify no sensitive content is copied or retained unexpectedly | Candidate |
| MASWE-0031–0035 | Extensions, intents and WebViews | Inspect merged manifest, IPC, plugin components, platform views and native bridges | Conditional |
| MASWE-0036 | Sensitive data exposed in UI | Results, recents snapshot, screen sharing, error messages and accessibility tree | Candidate |
| MASWE-0037 | Sensitive data in notifications | Determine whether app/dependencies create notifications | Conditional |
| MASWE-0038 | Screenshot/screen-recording exposure | Test background snapshots and sensitive screen exposure | Candidate |
| MASWE-0039 | Overlay attacks | Determine sensitive UI surfaces and assess tapjacking exposure proportionately | Conditional |
| MASWE-0040 | Sensitive data leaked via accessibility services | Screen-reader semantics and sensitive output exposure | Candidate |
| MASWE-0041–0043 | Platform version and enforced updating | minSdk/targetSdk, OS support policy and update mechanism/store distribution | Candidate |
| MASWE-0044 | Dependencies with known vulnerabilities | Full Dart, Maven/AAR, Gradle plugin and bundled SDK graph | Candidate |
| MASWE-0045–0047 | Compiler/security APIs/deprecated APIs | Release compiler flags, API use and security-critical platform APIs | Candidate |
| MASWE-0048 | Malicious code in app | Dependency provenance, package integrity and binary review | Candidate |
| MASWE-0049 | Unsafe dynamic code loading | Flutter assets, WebAssembly/CDN code and native dynamic loading | Candidate |
| MASWE-0050 | Unsafe handling of untrusted data | URL, message, QR payload, image parsing and imported file boundaries | Candidate |
| MASWE-0051–0065 | Resilience family | Signing, debug artifacts, integrity, RASP/anti-debugging, root/emulator detection and obfuscation; scope per selected profile | Profile-dependent |
| MASWE-0066 | Inadequate permission management | CAMERA/INTERNET minimisation, prompt timing, denial and fallback | Candidate |
| MASWE-0067–0069 | Anonymisation, identifiers and tracking | Analytics, SDK identifiers, diagnostics and tracking domains | Candidate |
| MASWE-0070–0071 | Privacy awareness and defaults | Camera disclosure, privacy controls and default behaviour | Candidate |
| MASWE-0072 | Inadequate privacy policy | Notice completeness, accuracy, languages and third-party SDK disclosures | Candidate |
| MASWE-0073–0074 | Data collection and tracking-domain declarations | Store privacy disclosures and SDK/analytics domain inventory | Candidate |
| MASWE-0075 | Non-reproducible builds | Pinned Flutter/Gradle/toolchain, provenance and repeat-build comparison | Candidate |
| MASWE-0076–0078 | Data management, visibility and consent | User controls, clear/reset behaviour, retention and consent semantics | Candidate |

## ORVIKA-specific hypotheses to verify

1. **Backup exclusion:** Android manifest sets `allowBackup=false` and explicit backup/data-extraction resources exist. Verify merged release manifest and actual platform backup/transfer behaviour.
2. **Local data boundary:** Existing source docs say Link, QR and Message inputs/results remain in screen state and are not intentionally persisted. Verify runtime files, logs, memory, clipboard, screenshots and keyboard cache.
3. **QR image cache:** Native image picker can create a temporary cache file; cleanup is best-effort and can be interrupted by process termination. Verify normal, cancel, error, force-stop and navigation-away paths.
4. **Third-party SDK telemetry:** Android scanner uses bundled ML Kit through `mobile_scanner`. Validate exact SDK versions, telemetry, network domains and store disclosures.
5. **Web analytics:** Page-view analytics exists on Web. Verify no analysis payloads, message contents, QR payloads or submitted URLs are sent as custom analytics events; record host/CDN metadata separately.
6. **No backend/API discovered:** Initial repository inventory did not identify an app API. Confirm with full source search, build output and runtime traffic; add externally managed endpoints to separate ASVS/API scope.
7. **No authentication discovered:** Do not claim auth weaknesses N/A until source, manifest, SDK and binary review is complete.

## Finding record format

Each confirmed weakness must include:
- Stable MASWE ID and official title.
- Related MASVS control ID(s).
- MASTG test ID(s), or documented custom test if no current atomic test exists.
- Component and affected version/build hash.
- Preconditions, reproduction steps and expected/actual behaviour.
- Evidence IDs, impact, likelihood and severity (CVSS 4.0 preferred where suitable; explain alternatives).
- Root cause, remediation and compensating controls.
- Fix commit/build, retest evidence and closure decision.

## Status

No MASWE weakness is currently confirmed or cleared. Source observations are not findings unless testing establishes a weakness. Final report must account for all catalogue entries, including justified N/A and NOT TESTED outcomes.

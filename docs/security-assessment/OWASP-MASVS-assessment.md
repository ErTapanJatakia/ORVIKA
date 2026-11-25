# ORVIKA — OWASP MASVS Control Assessment

**Workstream:** 1 of 3  
**Status:** Prepared; controls not yet verified  
**Source baseline:** `41c73039b146b8f83418a156c51adde458523921`  
**Target:** Android Flutter application, package `com.orvika.app`  
**Profile proposal:** MAS-L1 + MAS-P baseline; evaluate relevant MAS-L2 controls; separately decide MAS-R.

## Method

Use the current OWASP MASVS v2 control catalogue. At kickoff, pin the exact catalogue revision and save a local snapshot. Review every control and record PASS/FAIL/PARTIAL/NOT APPLICABLE/NOT TESTED/BLOCKED, evidence IDs, assessor notes and finding references.

The eight control groups are Storage, Cryptography, Authentication and Authorization, Network Communication, Platform Interaction, Code Quality, Resilience Against Reverse Engineering and Tampering, and Privacy. Reconcile this workpaper against the exact upstream control list before final scoring.

## Control-group register

| MASVS group | ORVIKA-specific verification focus | Current source evidence | Initial status |
|---|---|---|---|
| MASVS-STORAGE | SharedPreferences; app-private files; QR picker cache; logs; process memory; screenshots/recents; clipboard; keyboard cache; backup/transfer; clear/reset | `main.dart`, QR image scanner/cleanup, privacy data-flow doc, backup rules | NOT TESTED |
| MASVS-CRYPTO | Identify app-owned crypto, keys, random sources, hashing, signatures and encryption; review native/third-party SDK crypto | No first-party crypto feature identified initially; dependency graph incomplete | NOT TESTED |
| MASVS-AUTH | Determine whether authentication, local auth, account/session state or privileged components exist; validate exported components | No user account/auth feature identified; exported launcher activity exists | NOT TESTED |
| MASVS-NETWORK | Cleartext, TLS versions, trust/hostname validation, proxy behaviour, SDK endpoints, WebView/network stacks, analytics and destinations | INTERNET permission; `usesCleartextTraffic=false`; ML Kit and Vercel analytics documented | NOT TESTED |
| MASVS-PLATFORM | Permission minimisation; intents/IPC; deep links; providers; WebView exposure; camera/media; clipboard; screen capture; accessibility data | Main manifest and camera/image-picker code | NOT TESTED |
| MASVS-CODE | Dart/native source; input parsing; unsafe deserialization; dynamic loading; debug/error handling; API levels; dependency vulnerabilities; build settings | `pubspec.lock`, Gradle files, scripts and tests | NOT TESTED |
| MASVS-RESILIENCE | Release debuggability, signing, native symbols, obfuscation, integrity, tampering and reverse engineering | Signing config exists; actual APK/build output unavailable | NOT TESTED |
| MASVS-PRIVACY | Data inventory/minimisation, SDK disclosures, permissions, analytics domains, consent/defaults, user controls, retention and declarations | Privacy notice, data-flow docs, analytics bootstrap, ML Kit disclosure | NOT TESTED |

## Preliminary applicability decisions — not final

| Topic | Provisional decision | Required justification/evidence |
|---|---|---|
| Authentication controls | Candidate N/A if no user identity, authentication, session or privileged operation exists | Full source/dependency and packaged-component review |
| Cryptographic controls | Candidate N/A only for controls requiring first-party crypto if none exists; platform TLS and SDK crypto remain in scope | Source/binary/dependency review and runtime traffic |
| Network controls | Applicable because INTERNET permission and third-party SDK/hosting traffic exist | Packet capture and trust/TLS tests |
| Storage/privacy controls | Applicable because preferences, temporary image files and SDK telemetry exist | Runtime storage and traffic evidence |
| Platform controls | Applicable because camera, image picker, exported launcher activity and platform storage/permissions exist | Merged manifest and device tests |
| Resilience controls | Profile-dependent; minimum release hardening remains in scope | Release APK and risk/profile decision |

Do not mark an entire group N/A. Decide at individual-control level using official control wording.

## Required evidence per control

- Control ID and exact requirement text/version.
- Applicability rationale and target component.
- Method: source review, binary inspection, static tool, dynamic test, manual review or combination.
- Exact artifact/source commit and SHA-256.
- Environment: device model, Android version/patch, architecture, app build/version, account/role, tool versions.
- Evidence references: redacted screenshots, command output, logcat, proxy capture, APK Analyzer output, scripts and notes.
- Result and finding references.
- Remediation owner, retest build/hash and outcome.

## Exit criteria

- Every current MASVS control accounted for.
- No NOT TESTED item counted as PASS.
- All N/A decisions justified at control level.
- Failed/partial controls map to findings and remediation.
- Profile scope and exclusions explicit.
- A second reviewer reviews evidence and self-review disclosure before any public assurance statement.

## Current conclusion

This is a prepared assessment register only. No MASVS control has yet been verified. Source observations are test leads, not conformance results.

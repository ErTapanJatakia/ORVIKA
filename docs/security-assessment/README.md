# ORVIKA Security Assessment Programme

**Status:** Planning and evidence inventory; no conformance result issued  
**Assessment owner:** ORVIKA project owner / self-assessment auditor (dual role disclosed)  
**Baseline source revision:** `41c73039b146b8f83418a156c51adde458523921`  
**Inventory date:** 19 November 2026

## Purpose and workstreams

Establish a reproducible, evidence-led security assessment for ORVIKA. Three separate OWASP Mobile Application Security workstreams are maintained:

1. [MASVS control verification](OWASP-MASVS-assessment.md)
2. [MASWE weakness applicability and findings register](OWASP-MASWE-register.md)
3. [MASTG Android test execution plan](OWASP-MASTG-test-plan.md)

They share traceability but retain separate registers and report outputs. A separate web, edge, privacy, dependency and supply-chain assessment is also required because MASVS/MASTG do not verify ORVIKA's hosting platforms or remote endpoints.

## Scope and safeguards

- Android Flutter application: package `com.orvika.app`.
- Source baseline: `41c73039b146b8f83418a156c51adde458523921`.
- Source metadata declares version `0.1.0+1`; this is not proof of the version/signature of a distributed APK.
- Initial mobile assessment is Android-only. No iOS project was identified in the repository tree.
- Hosted Flutter Web is a separate web assessment target. Cloudflare Pages and Vercel are separate hosting/deployment surfaces and must be assessed independently.
- Cloudflare Functions middleware is in scope for edge configuration review. No application API/service implementation was identified in the source tree inventory; confirm externally managed endpoints, if any.
- Android ML Kit / `mobile_scanner` SDK behaviour and telemetry are in scope.
- No production deployment, production configuration mutation, store submission, signed-release rebuild, re-signing, key rotation, or release signing configuration change is authorised.
- Use a copy of the exact release artifact for analysis. Keep the signed source artifact immutable and record its SHA-256.
- Runtime testing must use an isolated test device/profile and synthetic data. Do not submit real-user content or credentials.
- Do not actively probe production endpoints. Prefer preview/test endpoints and passive configuration inspection unless separately authorised.

## Standards and version control

- MASVS: current OWASP MASVS v2 control catalogue; record exact upstream revision/date at kickoff.
- MASWE: stable MASWE v1.0.0 identifiers. The 2026 stable release renumbered the beta catalogue; do not reuse beta IDs.
- MASTG: MASTG v2.0.0 and current test catalogue. Do not use old test entries marked deprecated.
- Record URL, version/tag or commit, retrieval date and SHA-256 for every catalogue snapshot.
- Proposed profile baseline: MAS-L1 plus MAS-P, with MAS-L2 controls added where data sensitivity/threat analysis warrants. MAS-R is a separate resilience profile and must be explicitly decided.

## Result vocabulary

| Result | Definition |
|---|---|
| PASS | Requirement/test executed with sufficient evidence and satisfied |
| FAIL | Executed and requirement not satisfied |
| PARTIAL | Some sub-requirements satisfied; at least one remains open |
| NOT APPLICABLE | Reasoned, documented determination that the requirement does not apply |
| NOT TESTED | No test/evidence sufficient to make a conclusion |
| BLOCKED | Test could not be completed because an artifact, access or dependency was unavailable |

A source observation is not automatically a runtime PASS. A static guard is not proof of runtime behaviour. NOT TESTED must never be represented as PASS.

## Evidence inventory

| Evidence ID | Evidence item | Availability | Initial use / gap |
|---|---|---|---|
| EV-001 | Git source baseline | Available: commit `41c73039b146b8f83418a156c51adde458523921` | Reproducible source baseline |
| EV-002 | Flutter dependency manifest | `pubspec.yaml`, `pubspec.lock` available | Dart dependency review |
| EV-003 | Android manifest | Main manifest available | Static review only; merged release manifest required |
| EV-004 | Gradle build configuration | Android Gradle files and wrapper available | Build flags, SDK levels and signing flow |
| EV-005 | Backup/data-extraction rules | XML resources available | Static review; runtime backup behaviour untested |
| EV-006 | Privacy/data-flow documentation | Privacy notice, data-flow and QR camera docs available | Cross-check against implementation and SDK behaviour |
| EV-007 | Android security configuration review | Available: `docs/android-security-configuration-review.md` | Prior source review, explicitly not a full audit |
| EV-008 | Security/privacy assurance ledger | Available: `docs/security-privacy-assurance-ledger.md` | Existing claims and residual work |
| EV-009 | Source regression scripts/tests | Available: security/privacy scripts and tests | Re-run in authorised isolated assessment environment |
| EV-010 | Cloudflare Pages middleware | Available: `functions/_middleware.js` | Static edge policy review |
| EV-011 | Web analytics bootstrap | Available: `web/orvika-analytics-bootstrap.js` | Analytics boundary review |
| EV-012 | Exact signed release APK | **Not yet obtained/verified** | Required for binary analysis, signature/hash and runtime testing |
| EV-013 | APK SHA-256 and signing fingerprint | **Not recorded** | Required to bind reports to exact artifact |
| EV-014 | Merged release manifest / APK Analyzer output | **Not obtained** | Required to inspect packaged permissions/components |
| EV-015 | Runtime traffic capture | **Not collected** | Required to distinguish app, SDK, analytics and platform traffic |
| EV-016 | Device/runtime evidence | **Not collected for this assessment** | Prior functional device testing is not MASTG evidence |
| EV-017 | Full Maven/AAR dependency graph and SBOM | **Not obtained** | Dart lockfile alone is insufficient |
| EV-018 | Store-distributed artifact identity | **Not verified** | Obtain from actual distribution channel or owner-held archive |
| EV-019 | Cloudflare preview response evidence | Prior automation exists in project history | Re-capture for this assessment; smoke tests are not VAPT |
| EV-020 | Vercel response evidence | Config exists in repository | Separate passive review and later controlled validation |

### Artifact discovery note

The GitHub Releases API returned no published releases at inventory time. The most recently inspected CI run `44335089453` had no workflow artifacts. This does not prove that no APK exists in a separate local archive, older Actions run, store console or other channel. The exact release APK must be supplied or located before binary-level conclusions are possible.

## Preliminary architecture and attack-surface inventory

| Surface | Source observation | Assessment implication |
|---|---|---|
| Android permissions | Main manifest declares CAMERA and INTERNET; camera and autofocus hardware are optional | Verify merged manifest, permission prompt timing, denial paths and actual network destinations |
| Android components | Exported launcher activity; no other component/deep-link filter visible in reviewed main manifest | Inspect merged manifest and APK for plugin-added components and intent filters |
| Cleartext | Main manifest sets `usesCleartextTraffic=false` | Verify packaged config and runtime traffic; this flag alone does not prove TLS correctness |
| Backup | `allowBackup=false` and backup/data-extraction XML exist | Validate effective manifest and runtime backup/transfer behaviour |
| Persistence | SharedPreferences for appearance/accessibility and learning/review progress; checker inputs documented as screen-state only | Verify files, logs, process memory, clipboard, keyboard cache, screenshots and backup |
| QR scanning | `mobile_scanner`, `image_picker`, bundled ML Kit Android path; local Web decoding | Inspect SDK graph, telemetry, camera lifecycle and temporary image cleanup |
| Local analysis | Link, QR and Message checks documented as local/deterministic; no backend API identified in source inventory | Confirm via repository-wide search and runtime traffic capture |
| Web hosting | Cloudflare middleware and separate Vercel configuration/analytics | Separate web/edge workstream |
| Analytics | Vercel page-view integration exists on Web; analysis data documented as excluded | Validate runtime requests, domains and metadata |
| Authentication | No user account/auth feature identified in README or reviewed source | Candidate N/A only after architecture and component review |
| Cryptography | No first-party crypto workflow identified in initial feature inventory | Search Dart/native/dependency code and binary before N/A |
| Resilience | No explicit RASP/anti-tamper implementation identified in initial inventory | Decide profile requirements; absence is not automatically a defect outside selected profile |

## Workstream sequence and gates

1. Freeze/hash exact APK and source revision.
2. Complete source/configuration inventory and profile applicability.
3. Execute MASVS control review.
4. Review all MASWE entries and map findings to stable IDs.
5. Execute current MASTG Android tests against exact APK in isolated lab.
6. Conduct separate web/edge, privacy, SCA/SBOM and API-surface assessments.
7. Remediate on a separate development branch; do not change the assessed artifact.
8. Retest a new candidate build and preserve old/new evidence trail.
9. Issue an auditor statement only after evidence review and self-review disclosure.

## Auditor independence and report wording

The assessor is also product owner/developer. Disclose this relationship in every report and badge landing page. This is an owner-led self-assessment, not third-party independent certification. External peer review is recommended before public trust-mark issuance.

Permitted wording: “ORVIKA independently assessed by its owner against the stated OWASP MASVS controls using documented MASTG tests and MASWE mappings.”

Do not use “OWASP Certified”, “OWASP approved”, “OWASP endorsed”, or imply OWASP issued/registered the report or badge. OWASP states it does not certify vendors, verifiers or software.

## Initial status

**No MASVS conformance conclusion, MASWE finding count, MASTG pass rate, VAPT conclusion, certificate or badge is issued by this planning document.** All technical test outcomes remain NOT TESTED until supported by workpapers.

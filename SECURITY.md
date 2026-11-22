# ORVIKA Security Policy and Security Assessment Programme

**Document updated:** 22 November 2026  
**Repository:** [ErTapanJatakia/ORVIKA](https://github.com/ErTapanJatakia/ORVIKA)  
**Application:** ORVIKA — Check Before You Trust  
**Document purpose:** provide a single public-facing reference for vulnerability reporting, security scope, automated assurance, evidence, finding triage, limitations and ongoing maintenance.

> **Security statement:** This document records the project's security practices and the evidence available for the stated assessment snapshots. A successful build or scanner workflow means only that the relevant automation completed. It does not establish that ORVIKA is vulnerability-free, independently audited, penetration-tested, certified, or safe for every deployment context.

---

## 1. Reporting a Security Vulnerability

Please report suspected security vulnerabilities privately. Do not publish exploit details, proof-of-concept payloads, credentials, personal data, or sensitive logs in public issues, discussions, pull requests, commits, or screenshots.

### Preferred reporting route

Use GitHub's [Report a vulnerability form](https://github.com/ErTapanJatakia/ORVIKA/security/advisories/new) when private vulnerability reporting is available for this repository.

If GitHub does not offer the private reporting form, contact the repository owner through the [ErTapanJatakia GitHub profile](https://github.com/ErTapanJatakia) and request a private reporting channel **before** sending technical details. Do not use a public issue as a substitute for private disclosure.

### What to include

Include as much of the following as can be shared safely:

- A concise description of the suspected vulnerability and its potential security or privacy impact.
- Affected commit SHA, release/version, component, platform and relevant browser/OS/device details.
- Preconditions, configuration and user interaction required to reproduce the issue.
- Minimal, non-destructive reproduction steps or a minimal proof of concept.
- Sanitised screenshots, logs, HTTP traces or test output that demonstrate the behaviour.
- Whether the issue is reproducible on the latest development branch and whether a workaround is known.

Remove passwords, access tokens, API keys, signing material, private certificates, personal data, real user messages, QR contents, and unrelated sensitive information before sharing evidence.

### What not to do

- Do not publish a vulnerability before allowing a reasonable opportunity for private investigation and coordinated remediation.
- Do not access, modify, delete, retain, or exfiltrate another person's data.
- Do not perform denial-of-service, resource-exhaustion, destructive, social-engineering, or availability-impacting tests.
- Do not test third-party hosting, identity, analytics, app-store, browser, operating-system, CDN, or other provider systems without that provider's permission.
- Do not attempt to obtain production credentials, signing keys, private certificates, or repository secrets.
- Stop testing and report privately if real user data, credentials, or other sensitive information is encountered.

## 2. Scope and Boundaries

This policy covers security issues in ORVIKA-controlled source code, repository configuration, build workflows and project-operated application behaviour.

### In scope

- Flutter/Dart application source, UI flows, validation, analysis logic, error handling and local data handling.
- Link Check, Message Check, QR Check and related input-processing boundaries.
- QR image decoding, image-size/resource limits, camera permission and scanner lifecycle handling.
- Application privacy, local processing, preferences, analytics integration and data-flow claims.
- Web application assets, bootstrap code, browser-facing security controls and application-owned edge middleware.
- Android application configuration, manifest, permissions, backup/data-extraction rules, package identity and build configuration.
- Repository source, dependency manifests/lockfiles, generated software inventory, secrets exposure and security-relevant configuration.
- GitHub Actions workflows, action pinning, workflow permissions, artifact handling and CI-produced assessment evidence.
- Security headers and application-owned configuration on ORVIKA's supported hosting configurations, when assessed within an authorised project environment.

### Out of scope unless separately authorised

- GitHub, Vercel, Cloudflare, RuStore, Aurora Store, Google Play, Apple App Store, email providers, analytics providers, browsers, operating systems, device manufacturers and other third-party infrastructure.
- Testing or exploitation of systems, accounts, networks, APIs or services that ORVIKA does not own or have permission to assess.
- Production deployment, production credentials, production signing operations, store submission and release operations.
- Human-led penetration testing, social engineering, physical testing, broad infrastructure testing or denial-of-service exercises.
- Findings that require access to another user's device, account, private data or network without explicit authorisation.

A weakness in a third-party service should be reported to that provider under its own security disclosure policy. ORVIKA's policy does not grant permission to test third-party systems.

### Application behaviour relevant to security review

ORVIKA is designed as a cyber-safety and digital-fraud-prevention application. The current analysis flows are intended to inspect user-supplied inputs locally and provide risk-oriented guidance. In particular:

- Link, message and QR analysis should not be represented as a guarantee that a destination, sender, payment request or message is safe.
- QR analysis should not automatically open a decoded URL, join a Wi-Fi network, initiate a payment, or perform another consequential action merely because a QR code was scanned.
- Camera access is initiated through an explicit user action and should be stopped when capture is complete or the relevant screen/lifecycle ends.
- Security analysis content is distinct from privacy-conscious product analytics. Do not assume user-entered URLs, messages, QR payloads or other analysis content are analytics events.
- Reported behaviour must be checked against the affected commit and actual data flow; documentation statements are not substitutes for source or runtime evidence.

These are design expectations and review boundaries, not a claim that every possible input or platform path has been independently audited.

## 3. Supported Versions and Maintenance

ORVIKA is under active development. Security fixes are developed against the latest code on the `main` branch.

There is currently no published long-term support window for older commits, unreleased snapshots, preview builds or historical branches. A particular commit or build may be used as an assessment target, but that does not create a separate maintenance commitment.

The project is maintained on a best-effort basis. The maintainer will make reasonable efforts to review credible reports, investigate reproducible issues and coordinate remediation. No fixed acknowledgement, severity-classification, response, patch, or remediation SLA is promised.

## 4. Coordinated Disclosure and Safe Harbor

Good-faith security research that follows this policy and applicable law is welcome.

Please allow a reasonable period for private investigation and remediation coordination before public disclosure. The appropriate disclosure timing depends on severity, exploitability, affected users, remediation complexity, and whether a fix or mitigation is available.

The maintainer may ask for clarification or additional sanitised evidence. Reports may be closed when they are not reproducible, are outside scope, duplicate an existing report, or do not describe a security issue.

The project will not promise a bounty, payment, public acknowledgement, CVE assignment, or fixed remediation deadline.

### Safe-harbour boundaries

The maintainer does not intend to pursue legal action against researchers solely for good-faith activity that:

- Is limited to ORVIKA-controlled assets and follows this policy.
- Avoids privacy violations, data destruction, service disruption and unauthorised access.
- Uses the least intrusive method reasonably necessary to demonstrate the issue.
- Stops promptly when sensitive data or an unintended impact is encountered.
- Is reported privately and handled through coordinated disclosure.

This statement is not legal advice, does not override applicable law, and does not authorise activity that would otherwise be unlawful or violate a third party's terms or security policy.

## 5. Security Architecture and Assurance Areas

The project's assurance work is organised around the following areas. The existence of a review area does not mean every control has been fully assessed.

| Area | Security questions and assessment focus |
|---|---|
| Application logic and input handling | Are untrusted links, messages, QR payloads and image inputs parsed safely? Are limits, validation, error paths and user-visible warnings tested? |
| Data protection and privacy | What information remains on-device, what is persisted, what is sent to analytics or hosting services, and are these flows minimised and documented? |
| Web and hosting | Are CSP and other response headers appropriate? Are edge middleware, static assets, caching and preview/production boundaries configured and verified? |
| Android platform | Are permissions narrow, cleartext traffic disabled, backup rules intentional, components appropriately scoped, and build identity/signatures verified? |
| Dependencies and supply chain | Are dependency lockfiles used, known vulnerabilities and licence notices reviewed, build actions pinned, and software inventory evidence retained? |
| CI/CD and repository governance | Are workflow permissions least-privilege, secrets protected, scanners configured appropriately, and findings tracked to verified outcomes? |
| Accessibility and functional resilience | Do supported layouts, keyboard/assistive navigation, error states and input boundaries remain usable without bypassing security controls? |

### Data-handling principles

- Treat user-provided links, messages, QR contents, images and other analysis inputs as potentially sensitive.
- Do not include real user content in public issues, scanner artifacts, screenshots, test fixtures or logs.
- Prefer local and deterministic analysis where the application design supports it.
- Keep analytics separate from security-analysis content and collect only what is needed for product operation.
- Do not add an external lookup, telemetry path or upload of analysis content without a documented product and privacy review.
- Keep credentials, signing keys and private certificates out of source control and CI logs.

## 6. Automated Security Assessment Programme

ORVIKA uses a free/open-source and repository-native security assurance stack. Tools are selected according to the languages, frameworks, build outputs and infrastructure actually present in the repository. A tool is not considered applicable merely because it appears in a general scanner catalogue.

### 6.1 Current and configured assessment controls

| Control / tool | Intended coverage | Important boundary |
|---|---|---|
| GitHub CodeQL Default Setup | GitHub-managed code analysis for the configured languages and supported source paths | Default Setup is the active CodeQL configuration. Do not add a competing advanced-configuration workflow while Default Setup is enabled. |
| Semgrep Community Edition | Source security patterns and secrets rules; includes the configured security-audit and secrets rulesets | Rule coverage depends on language support and configured rules. Experimental Dart rules are not equivalent to exhaustive Dart analysis. |
| Trivy filesystem scan | Repository/dependency filesystem scan for vulnerabilities, misconfiguration, secrets and licence metadata | The report must identify the actual scanned paths and lockfiles; a clean result for one target is not whole-repository assurance. |
| Gitleaks | Secret-pattern detection across repository history | A clean scan does not prove that no secret has ever been exposed or that every secret format is detectable. |
| Microsoft DevSkim | Source security linting and SARIF reporting | Notes and warnings require contextual validation; a note is not automatically an exploitable vulnerability. |
| Bearer OSS | Static source and privacy-oriented analysis for supported JavaScript/Python paths | Coverage is limited to supported languages and the configured scan scope. |
| PyCQA Bandit | Python security analysis for repository Python tooling under `scripts/` | It is not a Dart/Flutter scanner and does not assess the full application. |
| CycloneDX / Syft SBOM | Software inventory and dependency evidence | Inventory completeness depends on available manifests, lockfiles and enrichment; an SBOM is not a vulnerability verdict. |
| OpenSSF Scorecard | Repository and software-supply-chain posture indicators | Scores and neutral/advisory detections are governance signals, not direct vulnerability findings. |
| OWASP ZAP passive baseline | Passive web security observations against the dedicated ORVIKA validation deployment | This is not an active exploit test, authenticated assessment or production-host penetration test. |
| Flutter analysis, tests and web build | Static analysis, regression tests and build validation for the Flutter application | Passing tests establish only the assertions exercised by those tests. |
| Isolated Android assessment APK build | Build, package identity, temporary signing and digest verification for security assessment | The artifact is ephemeral-CI-signed, not a production/store-signed release and not Android Build Validation. |

The workflow definitions are maintained in [`.github/workflows/`](https://github.com/ErTapanJatakia/ORVIKA/tree/main/.github/workflows). Relevant controls include [ORVIKA Free Security Assurance](https://github.com/ErTapanJatakia/ORVIKA/blob/main/.github/workflows/security-assurance.yml), [application CI](https://github.com/ErTapanJatakia/ORVIKA/blob/main/.github/workflows/ci.yml), and [workflow lint](https://github.com/ErTapanJatakia/ORVIKA/blob/main/.github/workflows/workflow-lint.yml).

### 6.2 Applicability and exclusions

Scanner selection is based on the repository's actual technology and risk surface. For example, Bandit is scoped to Python tooling; it does not replace Flutter/Dart analysis. A Node.js-specific scanner is not automatically applicable to Cloudflare edge middleware simply because the middleware uses JavaScript. Likewise, infrastructure-as-code, container, server-framework or API scanners should be added only when the corresponding assets and meaningful coverage exist.

MobSF integration is not treated as a currently reliable automated gate. Earlier integration instability is a known limitation; do not describe MobSF static or dynamic assessment as currently passing unless a fresh, successful run and its report are verified.

A scanner may be deferred when it is incompatible, redundant, unavailable without a paid account/service, or not meaningful for the repository. Such a decision should be documented rather than disguising an inapplicable tool as a completed control.

### 6.3 Workflow security principles

- Prefer least-privilege workflow permissions and read-only repository access unless a specific job requires more.
- Pin third-party GitHub Actions to reviewed immutable commit SHAs where feasible.
- Avoid persisting checkout credentials when a job does not need them.
- Do not expose secrets to untrusted pull-request code.
- Upload sanitised evidence artifacts and use bounded retention.
- Do not treat a green workflow badge as proof that every scanner reported zero findings.
- Do not remove a scanner, suppress a finding, or weaken a test merely to obtain a green check.

## 7. Assessment Evidence and Snapshot History

This section records known evidence snapshots. Historical run results must not be presented as the current state of a later commit. Always inspect the linked workflow run, commit SHA, report and artifact before making a new release or remediation decision.

### 7.1 Main-branch assurance snapshot — 21 November 2026

**Assessment report:** [ORVIKA Security Assurance Report — 21 November 2026](https://github.com/ErTapanJatakia/ORVIKA/blob/main/docs/security/ORVIKA-Security-Assurance-Report-2026-11-21.md)  
**Main-branch baseline recorded in that report:** `f61328b900f528762aa28ed27b4a9085d2018099`

The report records successful completion of the configured repository security assurance workflow, application CI, CodeQL and workflow lint on the stated baseline. The security assurance workflow included repository/dependency/secret/configuration scans, Semgrep SARIF, SBOM graph validation, Gitleaks, passive ZAP, OpenSSF Scorecard and an isolated Android assessment APK build.

| Evidence area | Recorded run | Interpretation |
|---|---|---|
| Security assurance | [Run #44843587431](https://github.com/ErTapanJatakia/ORVIKA/actions/runs/44843587431) | Four security-assurance jobs completed successfully on the documented baseline. Review the run and retained artifacts for actual scan output. |
| Application CI | [Run #44843587487](https://github.com/ErTapanJatakia/ORVIKA/actions/runs/44843587487) | Web analysis, tests and build passed. Deployment and production smoke-test steps were skipped; Android validation was skipped by design. |
| CodeQL | [Run #44843586934](https://github.com/ErTapanJatakia/ORVIKA/actions/runs/44843586934) | Actions, Python and JavaScript/TypeScript analyses completed successfully on that baseline. |
| Workflow lint | [Run #44843587384](https://github.com/ErTapanJatakia/ORVIKA/actions/runs/44843587384) | Workflow lint completed successfully. |
| Isolated Cloudflare preview | [Run #44836293165](https://github.com/ErTapanJatakia/ORVIKA/actions/runs/44836293165) | Dedicated preview smoke test completed; this was not a production deployment. |

The detailed report contains tool-specific findings, limitations, artifact identifiers and remediation history. Its results must not be silently carried forward as the result of later commits.

### 7.2 Recorded scanner observations and residual risks

The 21 November report recorded the following contextual outcomes:

- Trivy's recorded `pubspec.lock` target had zero reported vulnerabilities, misconfigurations, secrets and licence findings for that target. This must not be generalized to every repository path or runtime component.
- Semgrep's exported report recorded zero findings for the configured rules and scan context. The report's rule and file counts describe that run only.
- Gitleaks recorded zero findings in the full-history scan performed for that snapshot.
- CodeQL's configured analyses completed successfully; this is not exhaustive language or runtime coverage.
- OpenSSF Scorecard completed and reported advisory repository-posture detections, including branch-protection and online-SCM configuration observations. These are governance follow-ups, not confirmed exploitable vulnerabilities.
- Passive ZAP identified a Medium / High-confidence CSP alert for `style-src 'unsafe-inline'`, plus informational cache-related observations.
- The CSP inline-style item remained an open hardening concern because a strict nonce/hash-only alternative had not been proven compatible with Flutter and all supported hosting targets.
- The cache observations were assessed against the observed public static routes and documented as informational for that snapshot. Reassess if authenticated or user-specific routes are introduced.
- The Android assessment APK was generated with a temporary CI-only RSA-3072 signing identity and was explicitly not a store-release artifact.

For the full evidence, findings and residual-risk reasoning, consult the [dated assurance report](https://github.com/ErTapanJatakia/ORVIKA/blob/main/docs/security/ORVIKA-Security-Assurance-Report-2026-11-21.md) and [Gate 2 residual-risk review](https://github.com/ErTapanJatakia/ORVIKA/blob/main/docs/security/ORVIKA-Gate-2-Residual-Risk-Review-2026-11-21.md).

### 7.3 PR #252 — tablet regression and scanner expansion

[PR #252](https://github.com/ErTapanJatakia/ORVIKA/pull/252) adds tablet portrait/landscape regression coverage and expands the free static-analysis workflow with DevSkim, Bandit for repository Python tooling, and Bearer OSS. It also removes a duplicate custom CodeQL advanced-configuration workflow to avoid conflict with GitHub CodeQL Default Setup.

**Status at the time this document was prepared:** PR #252 remained open and its complete validation batch had not yet been accepted as a merged main-branch baseline. Do not record its scanners or tablet tests as a permanent main-branch control until the PR is merged and post-merge checks are verified.

The tablet regression tests exercise portrait and landscape layouts at defined viewport sizes. Automated viewport coverage is not equivalent to physical tablet testing, camera hardware validation, or a complete accessibility acceptance test.


### 7.4 OpenSSF Scorecard triage — 22 November 2026

**Evidence:** [PR #252 security assurance run #44986099020](https://github.com/ErTapanJatakia/ORVIKA/actions/runs/44986099020), OpenSSF Scorecard job. The job completed successfully and uploaded its SARIF report; a successful upload means the assessment ran, not that every posture observation was cleared.

| Observation | Evidence and disposition |
|---|---|
| Pinned npm dependencies | Scorecard identified six npm install commands without integrity hashes: two in `.github/workflows/ci.yml`, two in `.github/workflows/cloudflare-pages.yml`, and two in `.github/workflows/cloudflare-preview.yml`. The packages are version-pinned, but version pinning is not equivalent to hash verification. **Open supply-chain hardening item**; assess and remediate in a dedicated workflow change with reproducible package integrity, preserving existing install behaviour and tests. |
| Pinned Python test dependency | The prior `defusedxml==0.7.1` installation used a fixed version but no artifact hash. Corrected in PR #252 commit `6109bfb149f5e46fbe220e8093e1f86dd829c7f7` by requiring hashes, binary-only installation and the published wheel SHA-256. **Fixed in source; pending rerun verification**. |
| SAST posture metric | Scorecard returned score 0 with the explanation that no pull requests had been merged into a branch named `dev`. ORVIKA's active integration uses `main`; CodeQL Default Setup, Semgrep, DevSkim and Bearer are configured. Treat this as a branch-detection/metric limitation, not proof that SAST is absent. Keep scanner run evidence as the authoritative record. |
| Binary artifact | Scorecard identified `android/gradle/wrapper/gradle-wrapper.jar`. This is the committed Gradle Wrapper JAR required to bootstrap the pinned Android build tooling. Its presence is expected; retain it and verify it through the Gradle wrapper checksum controls rather than deleting a required build component. |
| Fuzzing | Scorecard found no fuzzer integration. This is a genuine assurance-coverage gap, not a confirmed vulnerability. **Deferred maturity item**: plan targeted parser/input fuzzing for URL, message and QR processing with bounded, deterministic CI execution. Do not claim comprehensive fuzzing until such tests and reports exist. |

The PR review annotations for `.github/workflows/codeql.yml` were attached to an outdated path and marked outdated/resolved in GitHub's review timeline. That custom advanced-configuration file is not part of PR #252's changed-file set; the repository's CodeQL Default Setup remains the selected configuration. The DevSkim token/key annotation on that same outdated path is not evidence of a current exposed secret. Do not dismiss any future alert on that basis: re-evaluate its current path, commit and source excerpt.

The Scorecard run's npm findings and fuzzing observation remain open as documented above. No blanket suppression or scanner exclusion was applied. The updated Python dependency installation is not marked verified fixed until the post-change workflow rerun succeeds.

## 8. Finding Triage and Remediation Register

A scanner alert is a lead for investigation, not automatically a confirmed vulnerability. Each material finding should be reviewed in context and tracked to a decision and verification result.

### Required finding record

| Field | Required information |
|---|---|
| Finding ID | GitHub alert, scanner rule, CVE or report identifier |
| Source | Scanner/tool, workflow name and run link |
| Affected asset | File/line, dependency and version, Android component, web route or workflow |
| Original severity | Scanner's own severity and confidence; do not convert to CVSS unless a valid CVSS score/vector is supplied |
| Evidence | Sanitised excerpt, report reference, package path or reproducible observation |
| Validation | Confirmed, false positive, not exploitable in context, duplicate or needs investigation |
| Impact | Realistic confidentiality, integrity, availability, privacy or safety consequence |
| Decision | Fix, mitigate, accept temporarily, or defer |
| Rationale | Technical reasoning and affected deployment/version |
| Remediation | Specific code/configuration/workflow change |
| Verification | Regression test and relevant scanner/build rerun |
| Status | Open, investigating, in progress, fixed pending verification, verified fixed, accepted risk or deferred |
| Review condition | Date, release, dependency update or other trigger for reassessment |

### Triage rules

- Validate the affected code path and deployment context before assigning a final disposition.
- Preserve original scanner severity and confidence separately from the project's risk assessment.
- Do not dismiss an alert solely because a workflow is green or another scanner did not report it.
- Do not mark a finding fixed until the relevant change is present and a suitable verification has passed.
- Do not apply blanket suppressions or broad exclusions to silence recurring scanner output.
- Record accepted risks with rationale, owner, affected version and reassessment condition.
- Keep historical alerts and workflow failures distinguishable from current open findings.
- Where a report cannot be retrieved or an endpoint is unavailable, state that the finding remains unverified rather than infer its status.

## 9. Android Build, Signing and Distribution Boundaries

ORVIKA's Android security evidence distinguishes among an assessment APK, an Android validation build and a production/store-signed release.

- A CI assessment APK may use an ephemeral signing identity for package and signature verification. It is not suitable for store submission.
- Android Build Validation is a separate workflow and must not be described as passed unless its own run is verified.
- The permanent Android signing keystore and credentials are sensitive release assets. They must not be printed, pasted into issues, committed, uploaded to public artifacts, or included in this document.
- Never request or disclose keystore passwords, private keys, signing-key material or secret values in a vulnerability report.
- Production signing, signed release generation, store submission and publication require their own release approval and evidence.
- A successful assessment APK build does not prove compatibility or security on every Android device or OS version.

The project should preserve the distinction between development/assessment artifacts and the production release identity throughout CI, documentation and distribution.

## 10. Known Limitations and Assurance Caveats

1. **No independent audit:** the documented work is tool-assisted engineering assurance, not an independent security audit or human-led penetration test.
2. **No formal mobile certification:** no formal OWASP MASVS, MASWE or MASTG assessment is claimed. That work remains separately deferred.
3. **Scanner coverage:** language support, rulesets, scan paths, dependency metadata and tool versions limit what each scanner can detect.
4. **ZAP scope:** passive baseline testing against the dedicated validation deployment does not establish production-host security and is not an authenticated or active exploit assessment.
5. **CSP residual risk:** the recorded `style-src 'unsafe-inline'` alert remains an open compatibility/security-hardening item until a tested alternative or accepted residual-risk decision is documented.
6. **Cache observations:** prior informational observations were assessed for the public static routes seen in that snapshot. New authenticated, private or user-specific responses require a fresh cache-control review.
7. **Android coverage:** an ephemeral assessment APK and its signature verification are not equivalent to Android Build Validation, physical-device acceptance, runtime penetration testing or store-release verification.
8. **Fuzzing:** comprehensive parser/input fuzzing is not claimed by the cited 21 November assurance snapshot.
9. **Third-party services:** provider infrastructure and services are outside this policy unless separately authorised.
10. **Artifacts expire:** GitHub Actions artifacts have retention limits. Verify that an artifact still exists and check its expiry before relying on or linking it as current evidence.
11. **No zero-risk claim:** absence of findings in a scan does not prove absence of vulnerabilities.
12. **Historical evidence:** workflow results are tied to a branch and commit SHA. A result for an older commit does not establish the state of the current branch.

## 11. Security Assessment Operating Rules

- Prefer free/open-source tools and repository-native security capabilities where they provide meaningful coverage.
- Keep security checks reproducible, scoped and documented.
- Preserve existing working scanners and regression tests when adding new coverage.
- Do not weaken, delete or bypass tests to obtain a green CI result.
- After three consecutive failures of the same check using the same strategy, stop repeating that strategy; investigate the cause, redesign the approach, or defer with documented evidence.
- Keep localisation, product content, visual identity and application behaviour out of security-only changes unless a validated security issue requires a product change.
- Do not modify production hosting, deploy production, generate a permanent-key-signed release, or submit to an app store as an incidental part of documentation or scanner work.
- Treat a merge as a change to the repository baseline: update evidence and re-check the main-branch result before claiming the new baseline is verified.

## 12. Ongoing Document and Evidence Maintenance

Update this document or its linked dated assessment reports when a material security workflow is added, removed, changed, executed, fails, is cancelled, or produces a significant finding or remediation.

For each material assessment, record:

1. Assessment date and time (UTC), workflow name, trigger and run ID.
2. Branch, commit SHA and associated pull request or merge commit.
3. Exact target and scope: repository paths, lockfiles, local/preview URL, Android artifact, emulator/device or other target.
4. Tool and version, relevant configuration and ruleset.
5. Execution outcome separately from scanner findings.
6. Finding counts only when read from the actual report, with the tool's severity taxonomy identified.
7. Workflow run and artifact links, artifact identity and expiry where available.
8. Triage decisions, remediation PR/commit and verification rerun.
9. Skipped tests, unsupported coverage, cancellations, rate limits and other limitations.
10. Updated status of open, fixed, accepted and deferred risks.

For a failed or cancelled run, describe what actually executed and what did not. Do not create a report or artifact link when no artifact exists. Preserve previous snapshots as historical evidence; add a dated update rather than silently rewriting an old result to appear current.

## 13. Reference Links

- [ORVIKA repository](https://github.com/ErTapanJatakia/ORVIKA)
- [GitHub Actions](https://github.com/ErTapanJatakia/ORVIKA/actions)
- [GitHub Code Scanning](https://github.com/ErTapanJatakia/ORVIKA/security/code-scanning)
- [Private vulnerability reporting](https://github.com/ErTapanJatakia/ORVIKA/security/advisories/new)
- [Security workflow definitions](https://github.com/ErTapanJatakia/ORVIKA/tree/main/.github/workflows)
- [ORVIKA Security Assurance Report — 21 November 2026](https://github.com/ErTapanJatakia/ORVIKA/blob/main/docs/security/ORVIKA-Security-Assurance-Report-2026-11-21.md)
- [ORVIKA Gate 2 Residual-Risk Review — 21 November 2026](https://github.com/ErTapanJatakia/ORVIKA/blob/main/docs/security/ORVIKA-Gate-2-Residual-Risk-Review-2026-11-21.md)
- [SECURITY.md history](https://github.com/ErTapanJatakia/ORVIKA/commits/main/SECURITY.md)

---

**Document status:** maintained project security policy and assessment index. The linked assessment reports remain the authoritative detailed evidence for their respective dates and commits.


## 7.5 Current evidence reconciliation — 22 November 2026

**Baseline:** main commit `8b07c87ce9d5cede2ed9fed9c620e2b16779077d`. **Evidence run:** [ORVIKA Free Security Assurance #44989972247](https://github.com/ErTapanJatakia/ORVIKA/actions/runs/44989972247).

The run completed successfully. Review of its retained artifacts establishes the following bounded results:

| Control | Observed result | Scope / limitation |
|---|---|---|
| Trivy filesystem | 0 vulnerabilities, 0 misconfigurations, 0 secrets and 0 licence findings | The exported result contains `pubspec.lock` as its scanned target; do not generalise this to all repository assets. |
| Semgrep | 0 results; 0 scanner errors in exported JSON | Configured rules and scan context only. |
| Gitleaks | 0 findings in exported full-history JSON | This is the run's repository history scan. |
| Bandit | SARIF generated and uploaded successfully | The action invokes Bandit with `|| true`; the successful job is not proof of zero findings. Alert/SARIF contents require separate review. |
| Bearer | Scan completed and SARIF uploaded | The action sets `exit-code: 0`; its SARIF upload emitted inconsistent fingerprint warnings for existing script findings. These warnings are identity/tracking evidence, not proof that the underlying findings are false positives. |
| DevSkim | SARIF upload completed | Individual findings require alert-level review. |
| OWASP ZAP passive | 4 alert categories in JSON | One Medium/High-confidence CSP `style-src 'unsafe-inline'` alert (4 instances); three informational categories: Modern Web Application (4), Re-examine Cache-control Directives (5), and Storable but Non-Cacheable Content (5). These are not automatically exploitable vulnerabilities. |
| OpenSSF Scorecard | Job completed and SARIF uploaded | Previously documented npm integrity and fuzzing gaps remain open; branch-name SAST metric is a metric limitation. |

The artifact archive for repository evidence is retained under run #44989972247 (artifact `orvika-repository-security-evidence`, ID `14741611968`). The ZAP evidence is retained as `orvika-web-zap-passive-evidence` (artifact ID `14741282867`).

### Current remediation status

- The Python `defusedxml==0.7.1` installation now uses a requirements file with a verified SHA-256 hash and `pip install --require-hashes --only-binary=:all:`; the security regression job passed on this baseline.
- Six npm install commands previously identified by Scorecard remain a supply-chain hardening item. They are version-pinned, but integrity-lockfile verification has not yet been implemented and verified. Do not describe this item as fixed.
- Targeted bounded fuzzing for URL, message and QR input parsing remains deferred and is not claimed as complete.
- No confirmed exploitable vulnerability is established by the Trivy, Semgrep or Gitleaks artifact results above. This does not disposition the separate GitHub Code Scanning alerts, Bearer/Bandit/DevSkim SARIF findings, or the ZAP observations.
- GitHub's Code Scanning alert inventory could not be retrieved through the connected repository integration during this reconciliation. Therefore the reported 57 open alerts have not been individually inspected, classified, remediated or dismissed in this report. Their status must remain open until alert-level evidence is reviewed.

### Required next step for the alert inventory

For every open Code Scanning alert, record its alert number, tool/rule, severity, file and line, first-seen commit, latest affected commit, evidence, validation decision, remediation or dismissal rationale, and verification result. Close an alert only after the relevant fix is present and verified, or after a documented false-positive/duplicate/out-of-scope decision supported by the actual code path. Do not bulk-dismiss alerts or infer closure from successful workflow status.


## 7.6 SAST and DAST findings triage — 23 November 2026

The evidence-backed, location-level triage register for the 22 November Bearer, Bandit, DevSkim and OWASP ZAP outputs is maintained in [`docs/security/ORVIKA-SAST-DAST-Triage-2026-11-23.md`](docs/security/ORVIKA-SAST-DAST-Triage-2026-11-23.md). It records 45 SARIF results, their code context, dispositions, merged remediation changes and outstanding validation. The separate 57 GitHub Code Scanning alerts remain open pending retrieval and individual review; this register does not claim those alerts are closed.

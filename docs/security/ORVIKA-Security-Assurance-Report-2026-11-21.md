# ORVIKA Security Assurance Report

**Assessment snapshot:** 21 November 2026  
**Repository:** https://github.com/ErTapanJatakia/ORVIKA  
**Assessed application:** ORVIKA prototype, web and Android build pipeline  
**Report status:** Evidence-consolidation draft; subject to PR review and final disposition  
**Main branch baseline:** `f1ce21a392b817d65c73793a2b6b38fe3039df96`  
**Latest remediation PR:** [#235](https://github.com/ErTapanJatakia/ORVIKA/pull/235), merged 20 November 2026

## 1. Executive summary

The security assurance programme completed its four planned engineering batches to the extent described in this report. Repository and dependency scans, source analysis, secret scanning, CodeQL, passive web DAST, an isolated Cloudflare preview smoke test, SBOM graph validation, and generation/signature verification of an Android assessment APK completed successfully on the recorded workflow runs.

This is a bounded, tool-assisted assurance snapshot—not a penetration-test certification, formal OWASP MASVS/MASWE/MASTG assessment, or guarantee that ORVIKA is free of vulnerabilities. One substantive web-hardening item remains open: the passive ZAP report flags `style-src 'unsafe-inline'` in the Content Security Policy. Several informational ZAP alerts also require contextual disposition. The OpenSSF Scorecard job completed, with two advisory configuration detections reported as neutral.

**Release interpretation:** the generated Android APK is an ephemeral-CI-signed assessment artifact only. It is not the production/store signing build and must not be submitted to RuStore or another app store. This report does not authorize or perform a production deployment, store release, or change to the existing signed Android release.

## 2. Scope and approach

### Included

- Repository and dependency filesystem scanning using Trivy.
- Semgrep Community Edition static analysis, including experimental Dart rules, with SARIF publication to GitHub code scanning.
- Full-history Gitleaks secret scanning.
- CodeQL analyses for three configured languages.
- CycloneDX repository SBOM generation and Dart Pub dependency-relationship enrichment.
- OpenSSF Scorecard repository-posture workflow.
- OWASP ZAP passive baseline scan against the dedicated Cloudflare validation site.
- Isolated Cloudflare Pages preview build and desktop/mobile browser smoke test.
- CI-only Android assessment APK build, package identity inspection, signature verification, and SHA-256 recording.
- Review of remediation changes in PRs #230, #231, #233, #234 and #235.

### Not included / limitations

- No formal independent penetration test or comprehensive manual source-code audit.
- No formal OWASP MASVS, MASWE or MASTG assessment; this remains deferred until after RuStore publication.
- Android validation CI was deliberately skipped in accordance with the project release workflow. The APK build job is not equivalent to full Android validation or device testing.
- No production deployment or production security-configuration change was performed by this assurance work.
- ZAP was a passive baseline scan of the dedicated preview URL, not an authenticated, active exploit test or broad assessment of third-party services.
- Trivy's recorded filesystem result covered `pubspec.lock`; it does not establish comprehensive configuration, container, infrastructure or runtime coverage.
- Fuzzing is not integrated into this assessment snapshot.
- The assessment APK uses a temporary CI signing identity and is not a store-release artifact.

## 3. Evidence and workflow register

| Evidence area | Workflow run | Result / evidence |
|---|---:|---|
| Repository scans, Semgrep SARIF, SBOM graph, Gitleaks, ZAP, Scorecard and Android assessment APK | [44838303792](https://github.com/ErTapanJatakia/ORVIKA/actions/runs/44838303792) | Completed successfully; all four jobs reported success |
| Isolated Cloudflare Pages preview validation | [44836293165](https://github.com/ErTapanJatakia/ORVIKA/actions/runs/44836293165) | Completed successfully; all 18 workflow steps passed |
| Remediation PR validation | [PR #235](https://github.com/ErTapanJatakia/ORVIKA/pull/235) | Required PR checks passed before squash merge |

The security assurance workflow ran against PR head `28b514fd61deff871206e2319052d784164ca3aa`. The Cloudflare preview run used `170d2ebdd286de159d5e0b2861faa7b29d736fda`. The PR #235 squash merge produced main commit `f1ce21a392b817d65c73793a2b6b38fe3039df96`.

**Post-merge verification caveat:** the GitHub workflow-run lookup for merge commit `f1ce21a392b817d65c73793a2b6b38fe3039df96` returned no associated PR-triggered workflow runs. Therefore, this report records successful PR-head validation and the separately successful preview run; it does not claim a fresh post-merge workflow run was observed on the final merge commit.

## 4. Repository and source-analysis results

### Trivy

- Workflow job: `Repository, dependency, secret and configuration scans`.
- Recorded target: `pubspec.lock` (Pub ecosystem).
- Recorded result: 0 vulnerabilities, 0 misconfigurations, 0 secrets and 0 licence findings for that target.
- Coverage caveat: this result must not be generalized to every repository configuration or runtime component.

### Semgrep

- 0 findings in the exported Semgrep JSON report.
- No scanner errors were recorded in that report.
- The workflow uploaded Semgrep SARIF to GitHub code scanning using the least-privilege security-events permission; fork PR uploads are skipped by workflow design.
- Prior recorded scan context: 197 tracked files and 151 rules. Treat those counts as the scan's reported context, not proof of exhaustive language coverage.

### Gitleaks

- 0 findings in the exported full-history scan report.
- The recorded scan covered 1,859 commits.

### CodeQL

- Three configured language analyses completed successfully on the PR validation.
- This is evidence of successful configured analyses, not proof that every language, generated artifact or runtime path is covered.

### OpenSSF Scorecard

- The Scorecard job completed successfully and uploaded its results.
- Two advisory configuration detections were reported as neutral because the scanner could not find `supply-chain/branch-protection` and `supply-chain/online-scm` configurations on main.
- These are recorded as repository-posture follow-ups, not failed CI jobs or confirmed exploitable vulnerabilities. The main branch protection endpoint was observed as not enabled at the time of inspection; repository governance settings should be reviewed separately if branch protection is desired.

## 5. SBOM and dependency-graph evidence

PR #235 added authoritative Dart Pub dependency relationships to the CycloneDX inventory using the pinned Flutter SDK and lockfile-enforced dependency resolution.

Recorded evidence:

- 79 Pub package records resolved.
- 78 third-party Pub packages matched Syft inventory entries.
- 232 dependency edges were validated by the graph-generation workflow/tests.
- Enriched CycloneDX inventory: 91 components and 79 dependency entries.
- Raw Syft inventory was retained separately; its dependency-entry array is empty because the graph is supplied by the enriched artifact.
- Regression tests cover valid graph construction and malformed/incomplete inputs, including missing identities, unresolved edges, duplicate names and pre-existing relationships.

The enriched graph is the dependency-relationship evidence for this snapshot. The raw inventory should not be mistaken for the graph-enriched output.

## 6. Web security assessment

### Passive ZAP findings

The ZAP baseline report for `https://orvika-validation.orvika.pages.dev` recorded:

| Alert | Risk / confidence | Instances | Disposition |
|---|---|---:|---|
| CSP: `style-src unsafe-inline` | Medium / High | 4 | **Open hardening item.** Investigate Flutter-generated inline-style requirements and nonce/hash alternatives. Do not remove the directive without compatibility testing. |
| Modern Web Application | Informational / Medium | 4 | Informational observation; no vulnerability claim. |
| Re-examine Cache-control Directives | Informational / Low | 5 | Review caching behavior against response sensitivity and intended cache policy; disposition required. |
| Storable but Non-Cacheable Content | Informational / Medium | 2 | Contextual cache observation; verify whether affected responses contain sensitive or user-specific data before deciding remediation. |

These are ZAP alert categories and scanner assessments, not four confirmed exploitable vulnerabilities. The CSP inline-style alert is the principal outstanding hardening concern. No CSP policy change was included in PR #235 because a change without isolated preview and browser compatibility evidence could break Flutter rendering.

### Isolated Cloudflare preview

Run [44836293165](https://github.com/ErTapanJatakia/ORVIKA/actions/runs/44836293165) completed successfully:

- Desktop viewport: 1440 px; mobile viewport: 390 px.
- Both browser smoke-test targets returned HTTP 200.
- No browser runtime errors were reported.
- COOP: `same-origin`.
- COEP: `credentialless`.
- CORP: `same-origin` on desktop and mobile.
- CSP was present; its `style-src 'unsafe-inline'` allowance remains under review.
- Preview deployment was isolated to the dedicated validation site.

The preview run also validated source/edge middleware, Cloudflare configuration, Flutter analysis/tests/web build, preview artifact checks, and the browser smoke test. It did not deploy production.

## 7. Android assessment artifact

The successful assessment artifact was produced by run [44838303792](https://github.com/ErTapanJatakia/ORVIKA/actions/runs/44838303792).

| Attribute | Recorded value |
|---|---|
| Artifact | `orvika-android-assessment-apk` |
| Artifact ID | `14679687660` |
| Artifact archive size | 36,692,216 bytes |
| Artifact archive SHA-256 | `68abf23bc5ad91b9943dabf2a4e9fb4e5849f8a04c026cb6ee6c129d65b59a0` |
| Created | 20 November 2026, 23:43:39 UTC |
| Expires | 4 December 2026, 23:43:36 UTC |
| APK package | `com.orvika.app` |
| Version | `0.1.0` (versionCode 1) |
| Minimum SDK | 24 |
| Target SDK | 36 |
| APK file SHA-256 | `b1d8535c7ce126f3b0bee3c145c70154110e37a109109f61003f042ec507efc2` |
| Signing | Temporary CI-only RSA-3072 identity; APK v2 signature verification passed |
| Signing certificate SHA-256 | `2591df9103186e69064242646eb5071ba9e9741dbb9429f13e226300d3a8e688` |

The archive SHA-256 and the APK file SHA-256 identify different byte streams and must not be interchanged. The signing certificate is ephemeral and is not the production/store signing identity. The workflow explicitly labels this artifact as security-assessment-only and not for RuStore submission.

The artifact expires on 4 December 2026. Preserve any required evidence and assessment copy before expiry, following the project's confidentiality and distribution requirements.

## 8. Remediation history

| PR | Change | Status |
|---|---|---|
| [#230](https://github.com/ErTapanJatakia/ORVIKA/pull/230) | Removed automated MobSF workflow integration; generated isolated CI assessment APK and verification evidence | Merged |
| [#231](https://github.com/ErTapanJatakia/ORVIKA/pull/231) | Aligned Cloudflare preview COOP assertion with strict same-origin policy and cache-busting requests | Merged |
| [#233](https://github.com/ErTapanJatakia/ORVIKA/pull/233) | Enforced CORP `same-origin` in Cloudflare and Vercel response configuration and regression checks | Merged |
| [#234](https://github.com/ErTapanJatakia/ORVIKA/pull/234) | Added live Cloudflare preview verification for CORP on desktop/mobile | Merged |
| [#235](https://github.com/ErTapanJatakia/ORVIKA/pull/235) | Published Semgrep SARIF, enriched CycloneDX with validated Pub dependency graph, pinned CodeQL upload action and clarified private vulnerability reporting | Merged |

PR #235 was squash-merged to main as `f1ce21a392b817d65c73793a2b6b38fe3039df96`. Its PR-head CI passed before merge. No production deployment, production configuration change, signed Android release change, or Android validation CI invocation was part of that PR.

## 9. Residual-risk and follow-up register

| Item | Priority / state | Recommended next action |
|---|---|---|
| CSP `style-src 'unsafe-inline'` | Medium scanner alert; open | Assess Flutter inline-style dependencies and nonce/hash feasibility in an isolated preview. Keep current working policy until a compatible, tested alternative exists. |
| Cache-control informational alerts | Informational; disposition pending | Inspect affected response types and data sensitivity; document whether current caching is intentional. |
| Scorecard branch-protection detection | Advisory; neutral | Decide whether to enable branch protection/rulesets and required checks as repository governance hardening. |
| Scorecard online-SCM detection | Advisory; neutral | Review the relevant Scorecard configuration and document the intended source-control posture. |
| Fuzzing | Deferred | Consider targeted fuzzing for parsers and input-analysis boundaries if risk and maintenance value justify it. |
| Formal OWASP mobile assessment | Deferred by project plan | Schedule MASVS/MASWE/MASTG work after RuStore publication. |
| Android validation CI | Skipped by design | Run only at a later complete-batch/release gate when explicitly authorized by the project workflow. |
| Evidence artifact retention | Time-sensitive | Preserve required APK and scan evidence before 4 December 2026 expiry. |

## 10. Overall conclusion

The recorded assurance activities provide useful evidence that the assessed repository state and isolated preview passed the configured automated checks. The most important completed improvements are the stricter cross-origin response policy verification, Semgrep SARIF publication, dependency-graph-enriched SBOM, clearer private vulnerability reporting route, and repeatable Android assessment-artifact verification.

The assurance snapshot should be considered **substantially complete with documented residual risks**, not a clean bill of health. The CSP inline-style alert and cache-related dispositions remain open, Scorecard advisories remain documented, Android validation was skipped, and formal OWASP mobile assessment remains deferred. A release decision should account for those boundaries and any separate product, privacy, operational and store-publishing requirements.

---

## Appendix A — retained workflow artifacts

All three artifacts below were reported as available when this report was assembled and have an expiry of 4 December 2026:

| Artifact | Artifact ID | Archive SHA-256 |
|---|---:|---|
| Android assessment APK | `14679687660` | `68abf23bc5ad91b9943dabf2a4e9fb4e5849f8a04c026cb6ee6c129d65b59a0` |
| ZAP passive evidence | `14679647163` | `84b761c6ba4ccc9757c069333dfcb600556e97af9e81f4ffe0040ea7162ea9e3` |
| Repository security evidence | `14678838700` | `1a5188d8fd00d397aef06fe7b75b7bc998625a3ad541571290c1907a9cb467a3` |

Artifacts are accessible from the workflow run's Artifacts section while retained and authorized. This report records their identifiers and digests; it does not embed the APK or raw scanner output.

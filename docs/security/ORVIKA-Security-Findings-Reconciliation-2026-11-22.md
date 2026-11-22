# ORVIKA Security Findings Reconciliation — 22 November 2026

**Repository:** ErTapanJatakia/ORVIKA  
**Baseline:** `8b07c87ce9d5cede2ed9fed9c620e2b16779077d`  
**Evidence run:** [ORVIKA Free Security Assurance #44989972247](https://github.com/ErTapanJatakia/ORVIKA/actions/runs/44989972247)  
**Status:** Evidence reconciliation in progress; not a security sign-off.

## Executive summary

The post-merge security-assurance workflow completed successfully. The retained artifacts were downloaded and inspected for Trivy, Semgrep, Gitleaks and OWASP ZAP. Bandit, Bearer and DevSkim workflow job results and SARIF upload steps were reviewed. The successful job conclusions do not prove that all three SARIF-producing tools returned zero findings.

The connected GitHub integration did not expose the repository's Code Scanning alerts inventory. The 57 alerts reported in the GitHub Security page have therefore not been individually reviewed or closed. No alert should be dismissed based on this report.

## Evidence register

| Control | Evidence observed | Assessment |
|---|---|---|
| Trivy filesystem | Exported JSON lists `pubspec.lock`; 0 vulnerabilities, 0 misconfigurations, 0 secrets and 0 licence findings for that target | Clean for this target only |
| Semgrep | Exported JSON: 0 results and 0 scanner errors | No findings for configured rules and scan context |
| Gitleaks | Exported full-history JSON is an empty findings array | No findings in this scan |
| Bandit | Bandit generated SARIF and uploaded it; invocation uses `|| true` | Finding count and disposition require SARIF/alert review |
| Bearer | Scan and SARIF upload completed; invocation sets `exit-code: 0` | Not a zero-finding assertion; SARIF processing emitted inconsistent fingerprint warnings |
| DevSkim | SARIF upload completed | Individual findings require review |
| OWASP ZAP passive | JSON report contains four alert categories | One Medium risk / High confidence CSP alert; three informational categories |
| OpenSSF Scorecard | Job and SARIF upload completed | Previously recorded npm integrity and fuzzing observations remain open |

### ZAP observations

- **CSP: style-src unsafe-inline** — Medium risk, High confidence, 4 instances. Remains an open hardening observation; any change requires Flutter compatibility testing in the isolated preview.
- **Modern Web Application** — Informational, 4 instances.
- **Re-examine Cache-control Directives** — Informational, 5 instances.
- **Storable but Non-Cacheable Content** — Informational, 5 instances.

These categories are scanner observations, not automatically confirmed exploitable vulnerabilities. The affected response paths and data sensitivity must be assessed before disposition.

## Remediation and hardening register

| Item | Status | Next action |
|---|---|---|
| Python dependency hash pinning for `defusedxml==0.7.1` | Implemented; regression job passed | Retain requirements-file hash verification |
| Six Scorecard-identified npm install commands | Open | Move installs to committed lockfile-backed `npm ci` or equivalent integrity-verified installation; preserve versions and behaviour |
| Bounded fuzzing for URL, message and QR parsers | Deferred / open | Add deterministic, resource-bounded tests with regression corpus and CI execution |
| Bearer/Bandit/DevSkim findings | Untriaged at alert level | Retrieve SARIF/Code Scanning alert details and classify individually |
| 57 GitHub Code Scanning alerts | Untriaged | Inspect every alert; remediate confirmed issues; dismiss only with documented evidence |
| ZAP CSP/cache observations | Open for contextual review | Verify routes, headers, caching semantics and Flutter compatibility |

## Alert disposition protocol

For each alert, capture:

1. Alert number, tool, rule ID and original severity.
2. File, line, code path, first-seen commit and latest affected commit.
3. SARIF message and relevant source context.
4. Validation outcome: confirmed, false positive, duplicate, not exploitable in context, or needs more investigation.
5. Technical rationale and realistic impact.
6. Fix, mitigation, accepted-risk owner or dismissal rationale.
7. Regression test and scanner rerun evidence.
8. Final state and verification commit.

No blanket dismissal, mass suppression, severity downgrading or test weakening is permitted. A fix is not verified until it exists in the assessed branch and a relevant check passes.

## Limitations and boundaries

- This report does not claim a full manual code audit, penetration test, zero-vulnerability state, or formal OWASP MASVS/MASWE/MASTG assessment.
- The Trivy result is limited to the exported target.
- Successful SARIF upload means the report was accepted for processing, not that it contained zero findings.
- The current integration could not retrieve Code Scanning alert records. The reported 57 alerts remain open and unclassified until their details are available.
- Production deployment, signed release, store publication and production credential changes were not performed.

## Evidence provenance

- Repository scan artifact: run #44989972247, artifact `orvika-repository-security-evidence`, ID `14741611968`.
- ZAP artifact: run #44989972247, artifact `orvika-web-zap-passive-evidence`, ID `14741282867`.
- Main baseline SHA: `8b07c87ce9d5cede2ed9fed9c620e2b16779077d`.

**Conclusion:** automated checks completed and several artifact-level results are clean within their stated scope. The security findings programme remains open pending individual SARIF/Code Scanning alert triage, npm integrity hardening, targeted fuzzing and evidence-backed remediation.

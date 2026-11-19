# ORVIKA Security Assurance — Initial Baseline

**Assessment type:** owner-led automated security assurance  
**Formal OWASP MASVS / MASWE / MASTG workstreams:** deferred until after RuStore publication  
**Baseline source revision:** `3524679d7d6b2b842e2d8377f47351111a88babc`  
**Build type:** isolated Android debug assessment APK; not a store artifact  
**MobSF version:** 4.6.2  
**Scan run:** [GitHub Actions run 44463609361](https://github.com/ErTapanJatakia/ORVIKA/actions/runs/44463609361)

## Repository scan summary

| Tool | Result | Interpretation |
|---|---|---|
| Trivy 0.76.2 | No HIGH/CRITICAL findings in the configured scan scope | Initial gate passed; report was configured to include only HIGH/CRITICAL and ignore unfixed items. A broader all-severity inventory is planned. |
| Gitleaks 8.24.3 | 0 findings | No detected secrets in scanned Git history. |
| Semgrep 1.180.0 | 1 finding | Review required in the AAB manifest verification script. |
| OpenSSF Scorecard | Analysis and SARIF upload completed | Review individual Scorecard checks separately; job success is not a security rating. |

## Semgrep finding

**File:** `scripts/verify-android-aab-manifest.py`  
**Rule:** `python.lang.security.use-defused-xml.use-defused-xml`  
**Location:** line 8 in the scanned revision  
**Description:** standard-library XML parsing was used on manifest text emitted by bundletool.

The verifier processes an AAB manifest, which is a structured input. Even though bundletool is invoked locally, defensive XML parsing is warranted. Remediation is to use `defusedxml` and add regression tests for external entities, internal entity expansion, malformed XML and valid manifests.

## Android APK / MobSF baseline

**Artifact:** `orvika-apk-mobsf-assessment`  
**APK SHA-256:** `5798fc1020647e9eb57ad801a7025dada5d00b43a0fa5b54b9fafd0f39f6cef6`  
**Package:** `com.orvika.app`  
**Version:** `0.1.0+1`  
**minSdk / targetSdk:** 24 / 36  
**APK size:** 170.11 MB  
**Signing certificate:** ephemeral GitHub runner Android Debug certificate (SHA-256: `e731a4f120762c92dc51b69e5ef570c815c7af7c7507fecf426d8b1a48fe42da`)

MobSF reported:

| Finding | Initial classification | Follow-up |
|---|---|---|
| Debug certificate | Expected for debug build; not a production finding | Re-scan a release-mode assessment APK signed with a throwaway, ephemeral assessment key. |
| `android:debuggable=true` | Expected for debug build | Re-scan release-mode assessment APK. |
| minSdk 24 / Android 7 | Product compatibility and security-policy decision | Evaluate supported-device requirements before changing minSdk; do not raise it automatically. |
| AndroidX ProfileInstallReceiver permission warning | Dependency/manifest review required | Verify merged manifest and permission protection level. |
| Hardcoded-secret heuristic | Likely native-library/test-vector false positives | Inspect string origins; do not suppress until confirmed. |
| MobileScanner logging heuristic | Informational; vendor Java file | Inspect logged values and ensure no QR payload or personal data is emitted. |
| Privacy trackers | 0 detected | Positive static signal; does not replace runtime network observation. |
| Network security findings | 0 reported | Static result only; does not prove runtime traffic is safe. |

The MobSF report contained 3 high, 2 warning and 1 informational items. Two high items (debug signing and debuggable mode) are expected consequences of this debug-only assessment build. The minSdk finding remains a genuine policy question, not an automatic defect. The warnings and informational result require manual validation.

## Scope limitations

- This was not the RuStore-distributed artifact and does not verify the production signing identity.
- The debug APK is not suitable for distribution.
- Static analysis does not establish runtime behaviour, server-side security, accessibility or privacy compliance.
- A successful workflow means the scanners completed; it does not mean that all findings are false positives or that ORVIKA is vulnerability-free.
- Reports and APK are retained as GitHub Actions artifacts for 14 days from the run; preserve copies before expiry if required.

## Next assurance actions

1. Harden the AAB XML parser and test hostile XML inputs.
2. Produce repository and APK CycloneDX SBOMs.
3. Build a release-mode assessment APK using a short-lived, runner-generated assessment key (never the production signing key).
4. Re-run MobSF against that release-mode artifact.
5. Review the minSdk policy and third-party manifest/logging findings.
6. Keep the eventual RuStore-signed artifact assessment separate and verify its actual certificate fingerprint.

# ORVIKA security and privacy assurance ledger

Review baseline: 16 November 2026  
Scope: repository source, configuration and automated regression assets  
Status: implementation-level review record; no live deployment or device validation performed in this increment

## 1. Security-analysis data boundary

| Data | Current intended handling | Evidence available | Remaining boundary |
|---|---|---|---|
| Submitted URL text and findings | Active Link Check screen state only | `test/privacy_data_isolation_test.dart`; source review of analyzer and screen | Does not cover OS memory, browser extensions, crash dumps or screenshots |
| Decoded QR payload and findings | Active QR Check screen state only | Same persistence regression suite; QR domain/presentation source review | Image-picker cache lifecycle requires device validation |
| Submitted message and findings | Active Message Check screen state only | Same persistence regression suite; source review | Does not prove absence of every platform side channel |
| QR image bytes | Active scanner flow; temporary picker cache may be platform-managed | QR image cleanup implementation and cleanup tests | Force-stop may interrupt best-effort deletion; validate on physical devices |
| App preferences | Local preference storage | Reviewed SharedPreferences write paths | Clear-data/site-data behaviour is platform-specific |
| Academy completion | Local progress marker | Academy persistence implementation and tests | Not security-analysis history |
| Privacy checklist review markers | Local stable practice identifiers | Privacy implementation and tests | Self-assessment answers remain session-only |
| Web analytics | Aggregate page-view/basic technical metrics only; no custom security-analysis events | `docs/analytics.md`; source integration review | Host/CDN request metadata and provider retention are outside application-source control |

## 2. Web response hardening

The current `vercel.json` defines:

- HSTS with a one-year max-age and subdomain coverage.
- `X-Content-Type-Options: nosniff`.
- `X-Frame-Options: DENY` and CSP `frame-ancestors 'none'`.
- Strict-origin referrer handling.
- A Permissions Policy that allows camera access only to the same origin and disables microphone/geolocation.
- A restrictive CSP with same-origin connections, no object embedding, and explicit worker/media/image/font allowances.
- Cross-origin isolation headers using `credentialless` and `same-origin-allow-popups`.

A new manual Node verification script, `scripts/verify-security-config.cjs`, checks the repository configuration for required header presence and key directive values. It validates the checked-in configuration only. It does not inspect production response headers, prove browser enforcement, or test compatibility with every browser.

Run manually when authorised:

```sh
node scripts/verify-security-config.cjs
```

## 3. Threat and assurance boundaries

- Local deterministic analysis is not a live reputation, DNS, redirect-following or threat-feed service.
- A no-finding result is not proof that a URL, message, QR payload, device or account is safe.
- Source inspection and widget tests are not packet-capture evidence or proof of total network isolation.
- Vercel/Cloudflare, browsers, operating systems, extensions and endpoint security products may process technical metadata outside ORVIKA's analysis code.
- The app does not claim device scanning, account inspection, automatic remediation or regulatory certification.
- CSP and response-header compatibility must be verified against the deployed Web/PWA build before release.

## 4. Release evidence still required

1. Run the security configuration script and relevant automated tests when CI/test execution is authorised.
2. Inspect actual production response headers and critical asset loading in supported browsers.
3. Capture network activity during Link, QR and Message analysis on supported Web and Android platforms; document expected hosting/analytics traffic separately from analysis traffic.
4. Verify QR temporary-file cleanup and object-URL revocation on representative physical devices and browsers, including cancellation and navigation away.
5. Review Android manifest permissions and platform permission prompts against the camera-only requirement.
6. Review dependency advisories, package licences and release artefacts before publication.

## 5. Change control

Do not add remote reputation APIs, telemetry, account services or cloud analysis as part of assurance work without a separate architecture and privacy decision. Do not weaken tests or relax security headers merely to obtain a passing build. Record unavailable platform checks as **not tested**, not passed.

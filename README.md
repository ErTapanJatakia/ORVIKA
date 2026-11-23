# ORVIKA

**Online Risk Verification, Intelligence, Knowledge & Assistance**  
*Personal Cyber Safety Intelligence*

**Check Before You Trust.**  
*See the Risk. Verify the Signal. Stay in Control.*

ORVIKA is a privacy-first personal cyber-safety application built around deterministic, explainable checks. It helps people inspect digital signals and make informed decisions without presenting suspicion as proof.

- Web/PWA: https://orvika.pages.dev
- Vercel preview: https://orvika-web.vercel.app
- Android package ID: `com.orvika.app`

## Visual identity

The ORVIKA identity is built around a geometric AI owl — the Intelligent Guardian — and a restrained cyber palette:

- Obsidian Navy `#081426`
- Neural Cyan `#00D5FF`
- Quantum Violet `#795CFF`
- Guardian Green `#20D69A`
- Alert Amber `#FFB547`
- Threat Crimson `#FF5263`

Brand assets and implementation notes are maintained in [the visual identity guide](docs/brand-system.md). The full lockup is available at [web/brand/orvika-lockup.svg](web/brand/orvika-lockup.svg).

## Product modules

The following capabilities are implemented in the current prototype. This status describes code availability, not a completed production release or independent security certification.

| Module | Implemented capability |
|---|---|
| Sentinel | Dashboard, module navigation, theme and accessibility preferences |
| Link Check | Local URL structure and risk-indicator inspection |
| QR Check | Decoded QR/barcode content inspection, with opt-in camera and image scanning |
| Message Check | Local heuristic review for common social-engineering signals |
| Intelligence | Curated offline risk-reference catalogue and explainable indicators |
| Privacy | 12-practice guided privacy self-assessment; answers remain session-only |
| Academy | Eight short cyber-safety lessons with knowledge checks and local progress |
| Response | Five incident-response playbooks with evidence-preservation and escalation guidance |

## Product principles and limitations

- Privacy-first and offline-friendly analysis by default.
- Explainable, deterministic findings where possible.
- An algorithmic suspicion is a signal to investigate, not proof of malicious intent.
- No automatic opening of inspected destinations or execution of QR actions.
- No live reputation, DNS, redirect-following or threat-feed lookup is implied by the local analysis modules.
- The Privacy module is a self-assessment, not a device scanner, compliance audit or certification.
- Academy progress is a local learning marker, not a professional qualification.
- Response playbooks provide general guidance; they do not replace emergency services, legal advice or qualified incident response.
- The hosted Web version uses limited page-view analytics; security-analysis content is not intentionally sent to analytics.

## Localization

The unified language catalogue currently contains 192 selectable entries. Reviewed translation status is limited to English, Russian, Arabic and Portugal Portuguese. Other authored language packs remain drafts pending their applicable linguistic and platform release gates. Bashkir and Tatar remain temporarily excluded. See the [localization audit](docs/localization-audit.md).

## Development

ORVIKA is a Flutter/Dart application. Repository workflows and manual verification scripts are maintained under `.github/` and `scripts/`. GitHub Actions is currently disabled at repository level by maintainer choice; do not assume CI, Android validation or deployment runs automatically. Test execution and release validation are performed only when explicitly authorised.

Useful references:

- [Privacy notice](docs/privacy-notice.md)
- [Privacy data-flow audit](docs/privacy-data-flow.md)
- [Security and privacy assurance ledger](docs/security-privacy-assurance-ledger.md)
- [Accessibility assurance review](docs/accessibility-assurance-review.md)
- [Dashboard responsive assurance](docs/dashboard-responsive-assurance.md)
- [Dated release-assurance evidence — 23 November 2026](docs/release-assurance-evidence-2026-11-23.md)
- [Android release signing](android/RELEASE_SIGNING.md)
- [Release readiness checklist](docs/release-readiness.md)
- [Third-party notices](THIRD_PARTY_NOTICES.md)
- [Security reporting policy](SECURITY.md)

The current application remains a prototype until the release gates in [docs/release-readiness.md](docs/release-readiness.md) are completed. Do not rely on any single assessment as a guarantee that a destination, message, QR code, device or account is safe.

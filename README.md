# ORVIKA

**Online Risk Verification, Intelligence, Knowledge & Assistance**  
*Personal Cyber Safety Intelligence*

**Check Before You Trust.**  
*See the Risk. Verify the Signal. Stay in Control.*

ORVIKA is a privacy-first personal cyber-safety application built around deterministic, explainable checks. The product is designed to help people inspect digital signals and make informed decisions without presenting suspicion as proof.

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

| Module | Current status |
|---|---|
| Sentinel | Dashboard / overview |
| Link | Available — on-device URL structure inspection |
| QR | Available — inspection of pasted decoded QR content |
| Message | In development |
| Intelligence | In development |
| Privacy | In development |
| Academy | In development |
| Response | In development |

## Product principles

- Privacy-first and offline-first by default.
- Explainable, deterministic findings where possible.
- AI or algorithmic suspicion is not a confirmed malicious verdict.
- No automatic opening of inspected destinations or execution of QR actions.
- Responsive Web/PWA experience with Android and Aurora OS as target platforms.

## Development

Flutter SDK, dependency, static analysis, unit/widget test and Web release build checks run through GitHub Actions. Production Web deployment is performed through the configured Vercel workflow.

The current application is an early prototype. See the source and tests before relying on any assessment for a real-world security decision.

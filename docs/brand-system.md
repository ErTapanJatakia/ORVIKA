# ORVIKA visual identity system

**Product:** ORVIKA — Online Risk Verification, Intelligence, Knowledge & Assistance  
**Descriptor:** Personal Cyber Safety Intelligence  
**Tagline:** Check Before You Trust.  
**Motto:** See the Risk. Verify the Signal. Stay in Control.  
**Archetype:** The Intelligent Guardian

## Brand symbol

The geometric owl represents vigilance, intelligence, precision and protection. Its symmetrical angular silhouette, luminous eyes and restrained circuit detail should remain legible at small sizes. The beak is an amber focal point; cyan and violet define the technology layer.

Approved asset family:
- `web/brand/orvika-lockup.svg` — full emblem and wordmark.
- `web/brand/orvika-owl.svg` — standalone colour emblem.
- `web/brand/orvika-owl-monochrome.svg` — one-colour emblem.
- `web/favicon.svg` and `web/icons/` — compact web/PWA variants.

Do not distort, rotate, add cartoon facial features, or use the owl as a substitute for a security verdict.

## Core palette

| Token | Hex | Use |
|---|---|---|
| Obsidian Navy | `#081426` | Primary dark canvas |
| Neural Cyan | `#00D5FF` | Primary interaction and signal |
| Quantum Violet | `#795CFF` | Intelligence and secondary emphasis |
| Guardian Green | `#20D69A` | Positive / verified state |
| Alert Amber | `#FFB547` | Caution |
| Threat Crimson | `#FF5263` | High-risk warning |

Risk colours must always be paired with explicit labels and explanatory text. Colour alone must never carry a security verdict.

## Interface themes

The first implementation provides four accessible presets:
1. **Obsidian** — canonical dark ORVIKA identity.
2. **Aurora** — softer violet-blue dark palette.
3. **Daylight** — bright, neutral surface palette.
4. **High contrast** — near-black canvas, brighter signal colours and stronger outlines.

The theme selector currently applies for the active app session. Persistent preference storage is intentionally deferred until a privacy-reviewed local settings layer is introduced.

## Typography

The intended type direction is **Space Grotesk** for display headings and **Inter** for interface text, with a system sans-serif fallback. Font binaries are not yet bundled; the current Flutter build uses platform fallback typography. Bundle licensed local font assets before claiming exact typography parity or offline font independence.

## Product modules

| Module | Initial availability |
|---|---|
| Sentinel | Dashboard / overview |
| Link | Available: deterministic URL structure inspection |
| QR | Available: inspection of pasted decoded QR content |
| Message | Planned |
| Intelligence | Planned |
| Privacy | Planned |
| Academy | Planned |
| Response | Planned |

Planned modules are visibly labelled as in development and must not be represented as operational features.

## Product principles

- Privacy-first and offline-first by default.
- Explainable, deterministic findings where possible.
- Suspicion is not proof; never overstate confidence.
- Accessible contrast, readable labels and responsive layouts.
- Keep the same brand system across Web/PWA, Android and Aurora OS.

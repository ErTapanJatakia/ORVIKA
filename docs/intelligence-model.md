# ORVIKA Intelligence — evidence model

## Scope

The first Intelligence foundation is a local, deterministic evidence model. It is
not a live threat feed, reputation lookup service, classifier, or verdict engine.
No network requests are made by these domain types.

## Records

- **ThreatIndicator** identifies an observable value and its type. The supplied
  value is retained; type-aware canonicalisation belongs in a separately tested
  ingestion boundary.
- **IntelligenceEvidence** records a source-attributed observation, its direction
  (supports concern, contradicts concern, or context only), confidence, observation
  time, optional expiry, and a human-readable summary.
- **IntelligenceSource** records source identity, kind, trust tier, publisher,
  optional reference URI, publication/retrieval times, and licence metadata.
  A URI is provenance only; the model never fetches it.
- **IndicatorAssessment** aggregates evidence without asserting maliciousness.

## Evidence support score

The 0–100 score is an evidence-quality indicator, **not a probability, risk score,
or maliciousness verdict**. It is the rounded mean of eligible supporting evidence
quality weights: confidence weight multiplied by source trust weight multiplied
by freshness weight.

| Dimension | Values |
|---|---|
| Confidence | Low 35; Medium 65; High 90 |
| Source trust | Unverified 0.40; Community 0.60; Vendor 0.80; Official 0.95 |
| Freshness | ≤24 hours 1.00; ≤7 days 0.90; ≤30 days 0.70; older 0.40 |

Expired evidence, future-dated evidence, and evidence with an unknown source are
excluded from the score and counted separately. Stale evidence remains visible
with a reduced weight. Contradicting and contextual evidence are counted but
do not increase the supporting score.

## Interpretation

- evidenceAvailable: eligible supporting evidence exists.
- conflictingEvidence: both supporting and contradicting evidence exist.
- staleEvidence: supporting evidence exists, but its newest observation is stale.
- counterEvidenceOnly: only evidence contradicting concern exists.
- contextualOnly: context exists without supporting or contradicting evidence.
- noEvidence: no eligible evidence remains.

The UI must show source, observation time, freshness, direction, and limitations
alongside any score. Never label a score as a percentage chance of maliciousness.
Never convert an indicator match into a confirmed threat verdict.

## Deferred

- No feed connectors or scheduled ingestion.
- No cloud reputation APIs or third-party telemetry.
- No automatic URL opening, DNS resolution, or QR action execution.
- No AI-generated classification.
- Feed signing, licensing, deduplication, canonicalisation, and source-specific
  trust governance require separate design and tests before ingestion is enabled.

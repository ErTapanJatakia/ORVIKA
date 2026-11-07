import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/features/intelligence/domain/threat_intelligence.dart';

void main() {
  final now = DateTime.utc(2026, 11, 7, 12);
  const official = IntelligenceSource(
    id: 'official-1', name: 'Example National CERT',
    kind: IntelligenceSourceKind.officialAdvisory,
    trust: IntelligenceSourceTrust.official,
    uri: 'https://example.invalid/advisory',
  );
  const community = IntelligenceSource(
    id: 'community-1', name: 'Community report',
    kind: IntelligenceSourceKind.communityReport,
    trust: IntelligenceSourceTrust.community,
  );

  ThreatIndicator indicator(List<IntelligenceEvidence> evidence) => ThreatIndicator(
    id: 'indicator-1', type: IntelligenceIndicatorType.domain,
    value: 'example.invalid',
    firstSeenAt: now.subtract(const Duration(days: 2)),
    lastUpdatedAt: now, evidence: evidence,
  );

  IntelligenceEvidence evidence({
    String id = 'evidence-1',
    String sourceId = 'official-1',
    IntelligenceEvidenceDirection direction = IntelligenceEvidenceDirection.supportsConcern,
    IntelligenceEvidenceConfidence confidence = IntelligenceEvidenceConfidence.high,
    DateTime? observedAt,
    DateTime? expiresAt,
  }) => IntelligenceEvidence(
    id: id, sourceId: sourceId, direction: direction, confidence: confidence,
    observedAt: observedAt ?? now.subtract(const Duration(hours: 1)),
    expiresAt: expiresAt, summary: 'Test evidence record',
  );

  const engine = IndicatorAssessmentEngine();

  test('scores fresh high-confidence evidence from an official source', () {
    final result = engine.assess(indicator: indicator([evidence()]), sources: [official], now: now);
    expect(result.status, IndicatorAssessmentStatus.evidenceAvailable);
    expect(result.supportScore, 86);
    expect(result.freshness, IntelligenceEvidenceFreshness.fresh);
    expect(result.supportingEvidenceCount, 1);
    expect(result.independentSourceCount, 1);
  });

  test('reduces evidence score for lower source trust and confidence', () {
    final result = engine.assess(
      indicator: indicator([evidence(sourceId: 'community-1', confidence: IntelligenceEvidenceConfidence.low)]),
      sources: [community], now: now,
    );
    expect(result.supportScore, 21);
    expect(result.status, IndicatorAssessmentStatus.evidenceAvailable);
  });

  test('marks supporting evidence as stale without discarding provenance', () {
    final result = engine.assess(
      indicator: indicator([evidence(observedAt: now.subtract(const Duration(days: 45)))]),
      sources: [official], now: now,
    );
    expect(result.status, IndicatorAssessmentStatus.staleEvidence);
    expect(result.freshness, IntelligenceEvidenceFreshness.stale);
    expect(result.supportingEvidenceCount, 1);
  });

  test('flags supporting and contradicting evidence as conflicting', () {
    final result = engine.assess(
      indicator: indicator([
        evidence(),
        evidence(id: 'evidence-2', direction: IntelligenceEvidenceDirection.contradictsConcern),
      ]),
      sources: [official], now: now,
    );
    expect(result.status, IndicatorAssessmentStatus.conflictingEvidence);
    expect(result.hasConflictingEvidence, isTrue);
    expect(result.supportScore, 86);
  });

  test('excludes expired, future-dated and unknown-source evidence', () {
    final result = engine.assess(
      indicator: indicator([
        evidence(id: 'expired', expiresAt: now.subtract(const Duration(seconds: 1))),
        evidence(id: 'future', observedAt: now.add(const Duration(minutes: 1))),
        evidence(id: 'unknown-source', sourceId: 'missing'),
      ]),
      sources: [official], now: now,
    );
    expect(result.status, IndicatorAssessmentStatus.noEvidence);
    expect(result.excludedEvidenceCount, 3);
    expect(result.supportScore, 0);
  });

  test('context-only evidence does not create a concern score', () {
    final result = engine.assess(
      indicator: indicator([evidence(direction: IntelligenceEvidenceDirection.contextOnly)]),
      sources: [official], now: now,
    );
    expect(result.status, IndicatorAssessmentStatus.contextualOnly);
    expect(result.supportScore, 0);
    expect(result.contextualEvidenceCount, 1);
  });

  test('counter-evidence alone is not converted into a positive finding', () {
    final result = engine.assess(
      indicator: indicator([evidence(direction: IntelligenceEvidenceDirection.contradictsConcern)]),
      sources: [official], now: now,
    );
    expect(result.status, IndicatorAssessmentStatus.counterEvidenceOnly);
    expect(result.supportScore, 0);
  });

  test('reports independent supporting source count', () {
    final result = engine.assess(
      indicator: indicator([evidence(id: 'one'), evidence(id: 'two', sourceId: 'community-1')]),
      sources: [official, community], now: now,
    );
    expect(result.independentSourceCount, 2);
    expect(result.supportingEvidenceCount, 2);
  });
}

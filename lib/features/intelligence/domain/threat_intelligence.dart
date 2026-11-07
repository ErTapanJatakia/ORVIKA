/// Provenance-aware, deterministic threat-intelligence primitives.
///
/// These types describe evidence about an indicator. They do not determine
/// whether a person, device, URL, or file is malicious.
enum IntelligenceIndicatorType { domain, url, ipv4, ipv6, email, sha256, package }
enum IntelligenceSourceKind {
  officialAdvisory, vendorReport, communityReport, curatedReference,
  userSubmitted, importedFeed,
}
enum IntelligenceSourceTrust { unverified, community, vendor, official }
enum IntelligenceEvidenceDirection { supportsConcern, contradictsConcern, contextOnly }
enum IntelligenceEvidenceConfidence { low, medium, high }
enum IntelligenceEvidenceFreshness { none, fresh, recent, aging, stale }
enum IndicatorAssessmentStatus {
  noEvidence, contextualOnly, evidenceAvailable, conflictingEvidence,
  counterEvidenceOnly, staleEvidence,
}

/// Source metadata is descriptive provenance only. ORVIKA does not fetch [uri].
class IntelligenceSource {
  const IntelligenceSource({
    required this.id, required this.name, required this.kind, required this.trust,
    this.publisher, this.uri, this.publishedAt, this.retrievedAt, this.licence,
  });
  final String id;
  final String name;
  final IntelligenceSourceKind kind;
  final IntelligenceSourceTrust trust;
  final String? publisher;
  /// Optional source reference; never opened or fetched by the domain layer.
  final String? uri;
  final DateTime? publishedAt;
  final DateTime? retrievedAt;
  final String? licence;
}

/// A single, attributable observation or assessment about an indicator.
class IntelligenceEvidence {
  const IntelligenceEvidence({
    required this.id, required this.sourceId, required this.direction,
    required this.confidence, required this.observedAt, required this.summary,
    this.expiresAt,
  });
  final String id;
  final String sourceId;
  final IntelligenceEvidenceDirection direction;
  final IntelligenceEvidenceConfidence confidence;
  final DateTime observedAt;
  final DateTime? expiresAt;
  final String summary;
}

/// An observable value with attached evidence, not a maliciousness verdict.
///
/// [value] is retained as supplied. Ingestion/normalisation must be explicit
/// and type-aware; this model does not silently rewrite indicators.
class ThreatIndicator {
  const ThreatIndicator({
    required this.id, required this.type, required this.value,
    required this.firstSeenAt, required this.lastUpdatedAt,
    required this.evidence, this.description, this.tags = const [],
  });
  final String id;
  final IntelligenceIndicatorType type;
  final String value;
  final DateTime firstSeenAt;
  final DateTime lastUpdatedAt;
  final String? description;
  final List<String> tags;
  final List<IntelligenceEvidence> evidence;
}

class IndicatorAssessment {
  const IndicatorAssessment({
    required this.status, required this.supportScore, required this.freshness,
    required this.supportingEvidenceCount, required this.contradictingEvidenceCount,
    required this.contextualEvidenceCount, required this.independentSourceCount,
    required this.excludedEvidenceCount,
  });
  final IndicatorAssessmentStatus status;
  /// Evidence-quality score (0–100), not a probability or risk verdict.
  final int supportScore;
  final IntelligenceEvidenceFreshness freshness;
  final int supportingEvidenceCount;
  final int contradictingEvidenceCount;
  final int contextualEvidenceCount;
  final int independentSourceCount;
  final int excludedEvidenceCount;
  bool get hasConflictingEvidence =>
      supportingEvidenceCount > 0 && contradictingEvidenceCount > 0;
}

/// Deterministic evidence aggregation with explicit provenance and freshness.
///
/// This engine performs no network access, feed ingestion, reputation lookup,
/// URL resolution, or AI inference.
class IndicatorAssessmentEngine {
  const IndicatorAssessmentEngine();

  static const _confidenceWeight = <IntelligenceEvidenceConfidence, double>{
    IntelligenceEvidenceConfidence.low: 35,
    IntelligenceEvidenceConfidence.medium: 65,
    IntelligenceEvidenceConfidence.high: 90,
  };
  static const _trustWeight = <IntelligenceSourceTrust, double>{
    IntelligenceSourceTrust.unverified: 0.40,
    IntelligenceSourceTrust.community: 0.60,
    IntelligenceSourceTrust.vendor: 0.80,
    IntelligenceSourceTrust.official: 0.95,
  };

  IndicatorAssessment assess({
    required ThreatIndicator indicator,
    required List<IntelligenceSource> sources,
    required DateTime now,
  }) {
    final sourceById = <String, IntelligenceSource>{
      for (final source in sources) source.id: source,
    };
    var supporting = 0;
    var contradicting = 0;
    var contextual = 0;
    var excluded = 0;
    var weightedSupport = 0.0;
    var supportingWeight = 0.0;
    final supportingObservations = <DateTime>[];
    final supportingSourceIds = <String>{};

    for (final evidence in indicator.evidence) {
      final source = sourceById[evidence.sourceId];
      if (source == null ||
          evidence.observedAt.isAfter(now) ||
          (evidence.expiresAt != null && evidence.expiresAt!.isBefore(now))) {
        excluded++;
        continue;
      }
      switch (evidence.direction) {
        case IntelligenceEvidenceDirection.supportsConcern:
          supporting++;
          supportingSourceIds.add(source.id);
          supportingObservations.add(evidence.observedAt);
          final freshnessWeight = _freshnessWeight(_freshnessFor(evidence.observedAt, now));
          weightedSupport += _confidenceWeight[evidence.confidence]! *
              _trustWeight[source.trust]! * freshnessWeight;
          supportingWeight += 1;
          break;
        case IntelligenceEvidenceDirection.contradictsConcern:
          contradicting++;
          break;
        case IntelligenceEvidenceDirection.contextOnly:
          contextual++;
          break;
      }
    }

    final freshness = supportingObservations.isEmpty
        ? IntelligenceEvidenceFreshness.none
        : _freshnessFor(
            supportingObservations.reduce((a, b) => a.isAfter(b) ? a : b), now);
    final score = supportingWeight == 0
        ? 0
        : (weightedSupport / supportingWeight).round().clamp(0, 100);

    return IndicatorAssessment(
      status: _status(
        supporting: supporting,
        contradicting: contradicting,
        contextual: contextual,
        freshness: freshness,
      ),
      supportScore: score,
      freshness: freshness,
      supportingEvidenceCount: supporting,
      contradictingEvidenceCount: contradicting,
      contextualEvidenceCount: contextual,
      independentSourceCount: supportingSourceIds.length,
      excludedEvidenceCount: excluded,
    );
  }

  IndicatorAssessmentStatus _status({
    required int supporting,
    required int contradicting,
    required int contextual,
    required IntelligenceEvidenceFreshness freshness,
  }) {
    if (supporting > 0 && contradicting > 0) {
      return IndicatorAssessmentStatus.conflictingEvidence;
    }
    if (supporting > 0 && freshness == IntelligenceEvidenceFreshness.stale) {
      return IndicatorAssessmentStatus.staleEvidence;
    }
    if (supporting > 0) return IndicatorAssessmentStatus.evidenceAvailable;
    if (contradicting > 0) return IndicatorAssessmentStatus.counterEvidenceOnly;
    if (contextual > 0) return IndicatorAssessmentStatus.contextualOnly;
    return IndicatorAssessmentStatus.noEvidence;
  }

  IntelligenceEvidenceFreshness _freshnessFor(DateTime observedAt, DateTime now) {
    final age = now.difference(observedAt);
    if (age <= const Duration(hours: 24)) return IntelligenceEvidenceFreshness.fresh;
    if (age <= const Duration(days: 7)) return IntelligenceEvidenceFreshness.recent;
    if (age <= const Duration(days: 30)) return IntelligenceEvidenceFreshness.aging;
    return IntelligenceEvidenceFreshness.stale;
  }

  double _freshnessWeight(IntelligenceEvidenceFreshness freshness) =>
      switch (freshness) {
        IntelligenceEvidenceFreshness.fresh => 1.0,
        IntelligenceEvidenceFreshness.recent => 0.9,
        IntelligenceEvidenceFreshness.aging => 0.7,
        IntelligenceEvidenceFreshness.stale => 0.4,
        IntelligenceEvidenceFreshness.none => 0.0,
      };
}

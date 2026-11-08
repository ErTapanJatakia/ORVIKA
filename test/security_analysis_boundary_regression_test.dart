import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/features/link_check/domain/url_analyzer.dart';
import 'package:orvika/features/qr_check/domain/qr_payload_analyzer.dart';
import 'package:orvika/features/message_check/domain/message_analyzer.dart';
import 'package:orvika/features/intelligence/domain/threat_intelligence.dart';

void main() {
  group('URL analyzer boundary and adversarial regression', () {
    const analyzer = UrlAnalyzer();

    test('accepts the documented 2,048-character boundary and rejects 2,049', () {
      const prefix = 'https://example.com/';
      final atLimit = '$prefix${'a' * (2048 - prefix.length)}';
      final overLimit = '$prefix${'a' * (2049 - prefix.length)}';
      expect(atLimit.length, 2048);
      expect(analyzer.analyze(atLimit).isValid, isTrue);
      expect(analyzer.analyze(overLimit).isValid, isFalse);
    });

    test('preserves original input while returning a normalised destination', () {
      const raw = '  https://example.com/path  ';
      final result = analyzer.analyze(raw);
      expect(result.input, raw);
      expect(result.normalizedUrl, 'https://example.com/path');
    });

    test('does not treat an ordinary named subdomain as a confirmed threat', () {
      final result = analyzer.analyze('https://login.example.com/account');
      expect(result.isValid, isTrue);
      expect(result.findings.every((finding) =>
          !finding.title.toLowerCase().contains('malicious')), isTrue);
      expect(result.notice, contains('No network request'));
    });

    test('handles valid IPv4 literals separately from malformed numeric hosts', () {
      final valid = analyzer.analyze('https://192.0.2.10/path');
      final invalid = analyzer.analyze('https://192.0.2.999/path');
      expect(valid.findings.map((f) => f.title),
          contains('IP-address destination'));
      expect(invalid.findings.map((f) => f.title),
          contains('Malformed IPv4-looking hostname'));
    });

    test('flags unusual numeric hosts and non-standard ports', () {
      final numeric = analyzer.analyze('https://123.456/path');
      final port = analyzer.analyze('https://example.com:8443/path');
      expect(numeric.findings.map((f) => f.title),
          contains('Unusual numeric hostname'));
      expect(port.findings.map((f) => f.title), contains('Non-standard port'));
    });
  });

  group('QR payload analyzer boundary and action-safety regression', () {
    const analyzer = QrPayloadAnalyzer();

    test('accepts the 8,192-character boundary and rejects 8,193', () {
      final atLimit = 'x' * 8192;
      expect(analyzer.analyze(atLimit).isValid, isTrue);
      expect(analyzer.analyze(atLimit).kind, QrPayloadKind.plainText);
      expect(analyzer.analyze('${atLimit}x').isValid, isFalse);
    });

    test('recognises scheme names case-insensitively without executing them', () {
      final result = analyzer.analyze('INTENT://scan/#Intent;scheme=zxing;end');
      expect(result.kind, QrPayloadKind.applicationLink);
      expect(result.severity, FindingSeverity.warning);
      expect(result.detail, contains('Do not open'));
    });

    test('rejects whitespace-only UPI payee values', () {
      final result = analyzer.analyze('upi://pay?pa=%20%20&pn=Merchant');
      expect(result.isValid, isFalse);
      expect(result.kind, QrPayloadKind.invalid);
    });

    test('propagates the strongest URL finding severity into QR result', () {
      final result = analyzer.analyze('http://192.0.2.10:8080/path');
      expect(result.kind, QrPayloadKind.webLink);
      expect(result.severity, FindingSeverity.warning);
      expect(result.linkFindings, isNotEmpty);
    });

    test('does not echo Wi-Fi credentials into the result detail', () {
      const secret = 'not-for-display-123';
      final result = analyzer.analyze('WIFI:T:WPA;S:Office;P:$secret;;');
      expect(result.kind, QrPayloadKind.wifiCredentials);
      expect(result.detail, isNot(contains(secret)));
      expect(result.detail, contains('will not connect automatically'));
    });

    test('keeps arbitrary custom schemes as untrusted application actions', () {
      final result = analyzer.analyze('bankapp://transfer?amount=100');
      expect(result.kind, QrPayloadKind.applicationLink);
      expect(result.severity, FindingSeverity.warning);
      expect(result.detail, contains('may launch an app'));
    });
  });

  group('Message analyzer boundary and extraction regression', () {
    const analyzer = MessageAnalyzer();

    test('accepts 10,000 characters and rejects 10,001', () {
      expect(analyzer.analyze('x' * 10000).isValid, isTrue);
      expect(analyzer.analyze('x' * 10001).isValid, isFalse);
    });

    test('trims common sentence punctuation from extracted links', () {
      final result = analyzer.analyze(
        'Open https://example.test/path, then (https://second.test/login).',
      );
      expect(result.detectedLinks, [
        'https://example.test/path',
        'https://second.test/login',
      ]);
    });

    test('keeps obfuscated addresses distinct from extracted navigable links', () {
      final result = analyzer.analyze('Review hxxps://example.test/login carefully.');
      expect(result.findings.map((f) => f.title),
          contains('Obfuscated web address detected'));
      expect(result.detectedLinks, isEmpty);
      expect(result.notice, contains('no link was opened'));
    });

    test('deduplicates links while preserving distinct destinations', () {
      final result = analyzer.analyze(
        'https://one.test https://two.test https://one.test',
      );
      expect(result.detectedLinks, ['https://one.test', 'https://two.test']);
    });

    test('does not elevate ordinary text solely because it contains a URL', () {
      final result = analyzer.analyze('Project notes: https://example.test/docs');
      expect(result.isValid, isTrue);
      expect(result.findings.single.severity, FindingSeverity.caution);
      expect(result.findings.single.title, 'Link or web address detected');
      expect(result.notice, contains('sender identity or intent was verified') == false);
    });
  });

  group('Threat-intelligence evidence time and provenance boundaries', () {
    final now = DateTime.utc(2026, 11, 7, 12);
    const official = IntelligenceSource(
      id: 'official', name: 'Example CERT',
      kind: IntelligenceSourceKind.officialAdvisory,
      trust: IntelligenceSourceTrust.official,
    );
    const community = IntelligenceSource(
      id: 'community', name: 'Community',
      kind: IntelligenceSourceKind.communityReport,
      trust: IntelligenceSourceTrust.community,
    );
    const engine = IndicatorAssessmentEngine();

    ThreatIndicator makeIndicator(List<IntelligenceEvidence> evidence) =>
        ThreatIndicator(
          id: 'indicator', type: IntelligenceIndicatorType.domain,
          value: 'example.test', firstSeenAt: now, lastUpdatedAt: now,
          evidence: evidence,
        );

    IntelligenceEvidence makeEvidence({
      String id = 'evidence',
      String sourceId = 'official',
      DateTime? observedAt,
      DateTime? expiresAt,
      IntelligenceEvidenceDirection direction =
          IntelligenceEvidenceDirection.supportsConcern,
      IntelligenceEvidenceConfidence confidence =
          IntelligenceEvidenceConfidence.high,
    }) => IntelligenceEvidence(
      id: id, sourceId: sourceId, direction: direction,
      confidence: confidence,
      observedAt: observedAt ?? now,
      expiresAt: expiresAt,
      summary: 'Boundary evidence',
    );

    test('uses inclusive freshness thresholds at 24 hours, 7 days and 30 days', () {
      final cases = <(Duration, IntelligenceEvidenceFreshness)>[
        (const Duration(hours: 24), IntelligenceEvidenceFreshness.fresh),
        (const Duration(hours: 24, milliseconds: 1), IntelligenceEvidenceFreshness.recent),
        (const Duration(days: 7), IntelligenceEvidenceFreshness.recent),
        (const Duration(days: 7, milliseconds: 1), IntelligenceEvidenceFreshness.aging),
        (const Duration(days: 30), IntelligenceEvidenceFreshness.aging),
        (const Duration(days: 30, milliseconds: 1), IntelligenceEvidenceFreshness.stale),
      ];
      for (final (age, expected) in cases) {
        final result = engine.assess(
          indicator: makeIndicator([
            makeEvidence(observedAt: now.subtract(age)),
          ]),
          sources: const [official],
          now: now,
        );
        expect(result.freshness, expected, reason: 'Age: $age');
      }
    });

    test('treats evidence observed at the assessment instant as fresh', () {
      final result = engine.assess(
        indicator: makeIndicator([makeEvidence(observedAt: now)]),
        sources: const [official],
        now: now,
      );
      expect(result.freshness, IntelligenceEvidenceFreshness.fresh);
      expect(result.status, IndicatorAssessmentStatus.evidenceAvailable);
    });

    test('excludes future-dated evidence without creating a support score', () {
      final result = engine.assess(
        indicator: makeIndicator([
          makeEvidence(observedAt: now.add(const Duration(microseconds: 1))),
        ]),
        sources: const [official],
        now: now,
      );
      expect(result.status, IndicatorAssessmentStatus.noEvidence);
      expect(result.excludedEvidenceCount, 1);
      expect(result.supportScore, 0);
    });

    test('counts independent sources, not repeated observations from one source', () {
      final result = engine.assess(
        indicator: makeIndicator([
          makeEvidence(id: 'one'),
          makeEvidence(id: 'two'),
          makeEvidence(id: 'three', sourceId: 'community'),
        ]),
        sources: const [official, community],
        now: now,
      );
      expect(result.supportingEvidenceCount, 3);
      expect(result.independentSourceCount, 2);
    });

    test('keeps counter-evidence visible without adding to support score', () {
      final result = engine.assess(
        indicator: makeIndicator([
          makeEvidence(),
          makeEvidence(
            id: 'counter',
            direction: IntelligenceEvidenceDirection.contradictsConcern,
          ),
        ]),
        sources: const [official],
        now: now,
      );
      expect(result.status, IndicatorAssessmentStatus.conflictingEvidence);
      expect(result.supportScore, 86);
      expect(result.hasConflictingEvidence, isTrue);
      expect(result.contradictingEvidenceCount, 1);
    });

    test('source trust changes evidence quality but never creates a verdict', () {
      final result = engine.assess(
        indicator: makeIndicator([
          makeEvidence(sourceId: 'community'),
        ]),
        sources: const [community],
        now: now,
      );
      expect(result.supportScore, 54);
      expect(result.status, IndicatorAssessmentStatus.evidenceAvailable);
      expect(result.status, isNot(IndicatorAssessmentStatus.noEvidence));
    });
  });
}

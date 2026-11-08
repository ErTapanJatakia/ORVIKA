import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/features/intelligence/domain/threat_intelligence.dart';
import 'package:orvika/features/link_check/domain/url_analyzer.dart';
import 'package:orvika/features/message_check/domain/message_analyzer.dart';
import 'package:orvika/features/qr_check/domain/qr_payload_analyzer.dart';

void main() {
  group('Adversarial URL authority and parser assurance', () {
    const analyzer = UrlAnalyzer();

    test('identifies the actual host when a trusted-looking user-info prefix is present', () {
      const input = 'https://trusted.example@attacker.example/login';
      final result = analyzer.analyze(input);

      expect(result.isValid, isTrue);
      expect(result.normalizedUrl, input);
      expect(result.findings.map((finding) => finding.title),
          contains('Embedded sign-in information'));
      expect(Uri.parse(result.normalizedUrl!).host, 'attacker.example');
    });

    test('retains query and fragment data in the normalised URL', () {
      const input = 'HTTPS://EXAMPLE.TEST/path?next=%2Faccount&mode=review#section';
      final result = analyzer.analyze(input);

      expect(result.isValid, isTrue);
      expect(result.normalizedUrl,
          'https://example.test/path?next=%2Faccount&mode=review#section');
      expect(result.findings.map((finding) => finding.title),
          contains('Fragment present'));
    });

    test('rejects tabs, embedded newlines, NUL and DEL control characters', () {
      for (final input in [
        'https://exa\tmple.test',
        'https://example.test/\nlogin',
        'https://example.test/\u0000path',
        'https://example.test/\u007fpath',
      ]) {
        expect(analyzer.analyze(input).isValid, isFalse, reason: input);
      }
    });

    test('does not promote an IP-literal destination to a safety verdict', () {
      final result = analyzer.analyze('https://198.51.100.7/');

      expect(result.isValid, isTrue);
      expect(result.findings.map((finding) => finding.title),
          contains('IP-address destination'));
      expect(result.notice, contains('No network request'));
      expect(result.findings.every((finding) =>
          !finding.title.toLowerCase().contains('safe')), isTrue);
    });
  });

  group('QR action and payload isolation assurance', () {
    const analyzer = QrPayloadAnalyzer();

    test('recognises uppercase action schemes without executing them', () {
      final phone = analyzer.analyze('TEL:+911234567890');
      final email = analyzer.analyze('MAILTO:security@example.test');

      expect(phone.kind, QrPayloadKind.phoneAction);
      expect(phone.detail, contains('will not place a call'));
      expect(email.kind, QrPayloadKind.emailAction);
      expect(email.detail, contains('will not open an email app'));
    });

    test('rejects a percent-encoded whitespace-only UPI payee', () {
      final result = analyzer.analyze('upi://pay?pa=%09%20&pn=Merchant');

      expect(result.isValid, isFalse);
      expect(result.kind, QrPayloadKind.invalid);
    });

    test('keeps a UPI recipient and amount out of explanatory output', () {
      const recipient = 'private-payee@example.test';
      const amount = '98765.43';
      final result = analyzer.analyze(
        'upi://pay?pa=$recipient&pn=Private%20Merchant&am=$amount',
      );

      expect(result.kind, QrPayloadKind.paymentRequest);
      expect(result.detail, isNot(contains(recipient)));
      expect(result.detail, isNot(contains(amount)));
      expect(result.detail, contains('will not initiate or approve a payment'));
    });

    test('does not convert a malformed web URL into a recognised web link', () {
      final result = analyzer.analyze('https://exa mple.test/path');

      expect(result.isValid, isFalse);
      expect(result.kind, QrPayloadKind.invalid);
      expect(result.normalizedUrl, isNull);
    });

    test('keeps custom application actions untrusted even with a familiar host', () {
      final result = analyzer.analyze('bankapp://trusted.example/transfer');

      expect(result.kind, QrPayloadKind.applicationLink);
      expect(result.severity, FindingSeverity.warning);
      expect(result.detail, contains('Do not open'));
    });
  });

  group('Message link extraction and social-engineering boundaries', () {
    const analyzer = MessageAnalyzer();

    test('extracts a URL from HTML-like text without including markup delimiters', () {
      final result = analyzer.analyze(
        '<a href="https://login.example.test/session">Review account</a>',
      );

      expect(result.detectedLinks, ['https://login.example.test/session']);
      expect(result.notice, contains('No message was uploaded'));
    });

    test('does not treat a lookalike Unicode hostname as a verified identity', () {
      final result = analyzer.analyze(
        'Please review https://раypal.example/account',
      );

      expect(result.detectedLinks, ['https://раypal.example/account']);
      expect(result.findings.map((finding) => finding.title),
          contains('Link or web address detected'));
      expect(result.notice, contains('no sender identity or intent was verified'));
    });

    test('does not turn an obfuscated address into an extracted navigable URL', () {
      final result = analyzer.analyze(
        'hxxp://first.example hxxps://second.example',
      );

      expect(result.detectedLinks, isEmpty);
      expect(result.findings.map((finding) => finding.title),
          contains('Obfuscated web address detected'));
    });

    test('keeps distinct query strings as distinct destinations', () {
      final result = analyzer.analyze(
        'https://example.test/login?tenant=one '
        'https://example.test/login?tenant=two',
      );

      expect(result.detectedLinks, [
        'https://example.test/login?tenant=one',
        'https://example.test/login?tenant=two',
      ]);
    });

    test('does not infer malicious intent from urgency-like text outside the configured phrase', () {
      final result = analyzer.analyze(
        'The incident response team will review this next week.',
      );

      expect(result.isValid, isTrue);
      expect(result.findings.single.title,
          'No listed social-engineering cues detected');
      expect(result.findings.single.severity, FindingSeverity.info);
    });
  });

  group('Threat-intelligence expiry and provenance assurance', () {
    final now = DateTime.utc(2026, 11, 8, 12);
    const official = IntelligenceSource(
      id: 'official',
      name: 'Example CERT',
      kind: IntelligenceSourceKind.officialAdvisory,
      trust: IntelligenceSourceTrust.official,
      uri: 'https://example.test/advisory',
    );
    const community = IntelligenceSource(
      id: 'community',
      name: 'Community report',
      kind: IntelligenceSourceKind.communityReport,
      trust: IntelligenceSourceTrust.community,
    );
    const engine = IndicatorAssessmentEngine();

    ThreatIndicator indicator(List<IntelligenceEvidence> evidence) =>
        ThreatIndicator(
          id: 'indicator',
          type: IntelligenceIndicatorType.domain,
          value: 'example.test',
          firstSeenAt: now,
          lastUpdatedAt: now,
          evidence: evidence,
        );

    IntelligenceEvidence evidence({
      required String id,
      String sourceId = 'official',
      IntelligenceEvidenceDirection direction =
          IntelligenceEvidenceDirection.supportsConcern,
      IntelligenceEvidenceConfidence confidence =
          IntelligenceEvidenceConfidence.high,
      DateTime? observedAt,
      DateTime? expiresAt,
    }) =>
        IntelligenceEvidence(
          id: id,
          sourceId: sourceId,
          direction: direction,
          confidence: confidence,
          observedAt: observedAt ?? now,
          expiresAt: expiresAt,
          summary: 'Assurance evidence',
        );

    test('accepts evidence expiring exactly at assessment time', () {
      final result = engine.assess(
        indicator: indicator([
          evidence(id: 'expires-now', expiresAt: now),
        ]),
        sources: const [official],
        now: now,
      );

      expect(result.excludedEvidenceCount, 0);
      expect(result.supportingEvidenceCount, 1);
      expect(result.status, IndicatorAssessmentStatus.evidenceAvailable);
    });

    test('excludes evidence that expired one microsecond before assessment', () {
      final result = engine.assess(
        indicator: indicator([
          evidence(
            id: 'just-expired',
            expiresAt: now.subtract(const Duration(microseconds: 1)),
          ),
        ]),
        sources: const [official],
        now: now,
      );

      expect(result.excludedEvidenceCount, 1);
      expect(result.supportingEvidenceCount, 0);
      expect(result.supportScore, 0);
      expect(result.status, IndicatorAssessmentStatus.noEvidence);
    });

    test('does not count repeated observations from one source as independent sources', () {
      final result = engine.assess(
        indicator: indicator([
          evidence(id: 'official-one'),
          evidence(id: 'official-two'),
          evidence(id: 'community-one', sourceId: 'community'),
        ]),
        sources: const [official, community],
        now: now,
      );

      expect(result.supportingEvidenceCount, 3);
      expect(result.independentSourceCount, 2);
    });

    test('does not let counter-evidence inflate the support score', () {
      final supportingOnly = engine.assess(
        indicator: indicator([evidence(id: 'support')]),
        sources: const [official],
        now: now,
      );
      final withCounterEvidence = engine.assess(
        indicator: indicator([
          evidence(id: 'support'),
          evidence(
            id: 'counter',
            direction: IntelligenceEvidenceDirection.contradictsConcern,
          ),
        ]),
        sources: const [official],
        now: now,
      );

      expect(withCounterEvidence.supportScore, supportingOnly.supportScore);
      expect(withCounterEvidence.hasConflictingEvidence, isTrue);
      expect(withCounterEvidence.status,
          IndicatorAssessmentStatus.conflictingEvidence);
    });

    test('keeps evidence-quality scores distinct from probability or a verdict', () {
      final result = engine.assess(
        indicator: indicator([evidence(id: 'official-support')]),
        sources: const [official],
        now: now,
      );

      expect(result.supportScore, inInclusiveRange(0, 100));
      expect(result.status, IndicatorAssessmentStatus.evidenceAvailable);
      expect(result.status, isNot(IndicatorAssessmentStatus.noEvidence));
    });
  });
}

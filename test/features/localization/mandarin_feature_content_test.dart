import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/core/localization/mandarin_academy_content.dart';
import 'package:orvika/core/localization/mandarin_checker_content.dart';
import 'package:orvika/core/localization/mandarin_intelligence_content.dart';
import 'package:orvika/core/localization/mandarin_privacy_content.dart';
import 'package:orvika/core/localization/mandarin_response_content.dart';
import 'package:orvika/features/academy/domain/academy_curriculum.dart';
import 'package:orvika/features/intelligence/domain/intelligence_library.dart';
import 'package:orvika/features/link_check/domain/url_analyzer.dart';
import 'package:orvika/features/privacy/domain/privacy_checklist.dart';
import 'package:orvika/features/response/domain/response_playbooks.dart';

void main() {
  group('Simplified Chinese feature content completeness', () {
    test('all eight Academy lessons are translated without changing answer logic', () {
      expect(AcademyCurriculum.lessons, hasLength(8));
      for (final source in AcademyCurriculum.lessons) {
        final item = MandarinAcademyContent.localize(source, 'zh');
        expect(item.id, source.id);
        expect(item.title, isNot(source.title));
        expect(item.summary, isNot(source.summary));
        expect(item.keyPoints, hasLength(source.keyPoints.length));
        expect(item.keyPoints.every((value) => value.isNotEmpty), isTrue);
        expect(item.question, isNot(source.question));
        expect(item.options, hasLength(source.options.length));
        expect(item.options.every((value) => value.isNotEmpty), isTrue);
        expect(item.correctIndex, source.correctIndex);
        expect(item.explanation, isNot(source.explanation));
      }
    });

    test('all twelve Privacy practices are translated', () {
      expect(PrivacyChecklist.practices, hasLength(12));
      for (final source in PrivacyChecklist.practices) {
        final item = MandarinPrivacyContent.localize(source, 'zh');
        expect(item.id, source.id);
        expect(item.title, isNot(source.title));
        expect(item.why, isNot(source.why));
        expect(item.action, isNot(source.action));
        expect(item.limit, isNot(source.limit));
      }
    });

    test('all five Response playbooks are translated without changing structure', () {
      expect(ResponsePlaybooks.playbooks, hasLength(5));
      for (final source in ResponsePlaybooks.playbooks) {
        final item = MandarinResponseContent.localize(source, 'zh');
        expect(item.id, source.id);
        expect(item.title, isNot(source.title));
        expect(item.summary, isNot(source.summary));
        expect(item.firstAction, isNot(source.firstAction));
        expect(item.steps, hasLength(source.steps.length));
        expect(item.steps.every((value) => value.isNotEmpty), isTrue);
        expect(item.preserve, hasLength(source.preserve.length));
        expect(item.avoid, hasLength(source.avoid.length));
        expect(item.limit, isNot(source.limit));
      }
    });

    test('all ten Intelligence references are translated', () {
      expect(IntelligenceLibrary.entries, hasLength(10));
      for (final source in IntelligenceLibrary.entries) {
        final item = MandarinIntelligenceContent.localize(source, 'zh');
        expect(item.id, source.id);
        expect(item.title, isNot(source.title));
        expect(item.signal, isNot(source.signal));
        expect(item.meaning, isNot(source.meaning));
        expect(item.action, isNot(source.action));
        expect(item.limit, isNot(source.limit));
      }
    });

    test('all 22 stable checker findings are translated and severity is preserved', () {
      const titles = [
        'Unicode hostname', 'Unencrypted connection',
        'Embedded sign-in information', 'Internationalised domain encoding',
        'IP-address destination', 'Malformed IPv4-looking hostname',
        'Unusual numeric hostname', 'Long subdomain chain', 'Non-standard port',
        'Fragment present', 'No structural warning detected', 'Address not analysed',
        'Urgency or pressure language', 'Credential or sign-in request',
        'OTP or authentication-code reference', 'Payment or financial action',
        'Prize or unexpected reward', 'Threat or consequence language',
        'Obfuscated web address detected', 'Link or web address detected',
        'No listed social-engineering cues detected', 'Message not analysed',
      ];
      for (final title in titles) {
        final source = LinkFinding(
          title: title,
          detail: title == 'Non-standard port'
              ? 'This address uses port 8443.'
              : title == 'Link or web address detected'
                  ? '2 web addresses were detected.'
                  : 'Source detail for $title.',
          severity: FindingSeverity.warning,
        );
        final item = MandarinCheckerContent.localizeFinding(source, 'zh');
        expect(item.title, isNot(source.title), reason: 'Untranslated finding: $title');
        expect(item.detail, isNot(source.detail), reason: 'Untranslated detail: $title');
        expect(item.severity, source.severity);
      }
      expect(MandarinCheckerContent.localizeLinkNotice('No network request was made.', 'zh'),
          contains('网络请求'));
      expect(MandarinCheckerContent.localizeMessageNotice('zh'), contains('消息未上传'));
    });

    test('unknown locale keeps source content unchanged', () {
      final source = AcademyCurriculum.lessons.first;
      final item = MandarinAcademyContent.localize(source, 'en');
      expect(item.title, source.title);
      expect(item.correctIndex, source.correctIndex);
    });
  });
}

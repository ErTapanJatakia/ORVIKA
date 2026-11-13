import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/core/localization/orvika_language.dart';
import 'package:orvika/core/localization/orvika_localizations.dart';
import 'package:orvika/core/localization/portuguese_academy_content.dart';
import 'package:orvika/core/localization/portuguese_privacy_content.dart';
import 'package:orvika/core/localization/portuguese_response_content.dart';
import 'package:orvika/core/localization/portuguese_intelligence_content.dart';
import 'package:orvika/core/localization/portuguese_checker_content.dart';
import 'package:orvika/features/link_check/domain/url_analyzer.dart';
import 'package:orvika/features/qr_check/domain/qr_payload_analyzer.dart';
import 'package:orvika/features/academy/domain/academy_curriculum.dart';
import 'package:orvika/features/privacy/domain/privacy_checklist.dart';
import 'package:orvika/features/response/domain/response_playbooks.dart';
import 'package:orvika/features/intelligence/domain/intelligence_library.dart';

void main() {
  group('Brazilian Portuguese localization coverage', () {
    final l10n = OrvikaLocalizations(OrvikaLanguage.fromCode('pt'));

    test('covers every key in the 146-key expanded reviewed baseline', () {
      expect(OrvikaLocalizations.requiredTranslationKeys, hasLength(146));
      for (final key in OrvikaLocalizations.requiredTranslationKeys) {
        expect(l10n.hasTranslation(key), isTrue, reason: 'Portuguese is missing $key');
        expect(l10n.text(key), isNot(key), reason: 'Portuguese resolves $key to its key');
      }
    });

    test('Portugal Portuguese localizes all feature content while preserving stable IDs and scoring', () {
      final pt = OrvikaLanguage.fromCode('pt-PT');
      final l10n = OrvikaLocalizations(pt);
      for (final key in OrvikaLocalizations.requiredTranslationKeys) {
        expect(l10n.hasTranslation(key), isTrue, reason: 'pt-PT is missing $key');
        expect(l10n.text(key), isNot(key), reason: 'pt-PT falls back for $key');
      }
      for (final lesson in AcademyCurriculum.lessons) {
        final translated = PortugueseAcademyContent.localize(lesson, 'pt-PT');
        expect(translated.id, lesson.id);
        expect(translated.correctIndex, lesson.correctIndex);
        expect(translated.title, isNot(lesson.title));
      }
      for (final practice in PrivacyChecklist.practices) {
        final translated = PortuguesePrivacyContent.localize(practice, 'pt-PT');
        expect(translated.id, practice.id);
        expect(translated.title, isNot(practice.title));
      }
      for (final playbook in ResponsePlaybooks.playbooks) {
        final translated = PortugueseResponseContent.localize(playbook, 'pt-PT');
        expect(translated.id, playbook.id);
        expect(translated.steps, hasLength(playbook.steps.length));
      }
      for (final entry in IntelligenceLibrary.entries) {
        final translated = PortugueseIntelligenceContent.localize(entry, 'pt-PT');
        expect(translated.id, entry.id);
        expect(translated.title, isNot(entry.title));
      }
    });

    test('Portugal Portuguese localizes checker findings and notices without changing severity', () {
      const source = LinkFinding(
        title: 'Unencrypted connection',
        detail: 'This address uses HTTP.',
        severity: FindingSeverity.warning,
      );
      final translated = PortugueseCheckerContent.localizeFinding(source, 'pt-PT');
      expect(translated.title, 'Ligação sem criptografia');
      expect(translated.detail, contains('HTTP'));
      expect(translated.severity, source.severity);
      const qr = QrPayloadAnalysis(
        kind: QrPayloadKind.wifiCredentials,
        title: 'Wi-Fi configuration',
        detail: 'A Wi-Fi network configuration was detected.',
        severity: FindingSeverity.caution,
        normalizedUrl: null,
        isValid: true,
      );
      final localizedQr = PortugueseCheckerContent.localizeQr(qr, 'pt-PT');
      expect(localizedQr.title, 'Definição de Wi-Fi');
      expect(localizedQr.severity, qr.severity);
      expect(localizedQr.kind, qr.kind);
      expect(localizedQr.isValid, qr.isValid);

      const findingTitles = [
        'Unicode hostname',
        'Unencrypted connection',
        'Embedded sign-in information',
        'Internationalised domain encoding',
        'IP-address destination',
        'Malformed IPv4-looking hostname',
        'Unusual numeric hostname',
        'Long subdomain chain',
        'Non-standard port',
        'Fragment present',
        'No structural warning detected',
        'Address not analysed',
        'Urgency or pressure language',
        'Credential or sign-in request',
        'OTP or authentication-code reference',
        'Payment or financial action',
        'Prize or unexpected reward',
        'Threat or consequence language',
        'Obfuscated web address detected',
        'Link or web address detected',
        'No listed social-engineering cues detected',
        'Message not analysed',
      ];
      for (final title in findingTitles) {
        final result = PortugueseCheckerContent.localizeFinding(
          LinkFinding(title: title, detail: 'A sample finding.', severity: FindingSeverity.caution),
          'pt-PT',
        );
        expect(result.title, isNot(title), reason: 'pt-PT checker finding missing: $title');
        expect(result.severity, FindingSeverity.caution);
      }
      final port = PortugueseCheckerContent.localizeFinding(
        const LinkFinding(title: 'Non-standard port', detail: 'This address uses port 8080.', severity: FindingSeverity.warning),
        'pt-PT',
      );
      expect(port.detail, contains('8080'));
      final count = PortugueseCheckerContent.localizeFinding(
        const LinkFinding(title: 'Link or web address detected', detail: '2 web addresses were found.', severity: FindingSeverity.caution),
        'pt-PT',
      );
      expect(count.detail, contains('2'));

      expect(
        PortugueseCheckerContent.localizeLinkNotice('No network request was made.', 'pt-PT'),
        'Nenhuma solicitação de rede foi realizada.',
      );
      expect(
        PortugueseCheckerContent.localizeMessageNotice('pt-PT'),
        contains('verificações heurísticas'),
      );
    });

    test('preserves named placeholders in progress strings', () {
      expect(l10n.textWithParameters('privacy.progressUpdate', parameters: const {'reviewed': 3, 'total': 12}),
          'Progresso atualizado: 3 de 12 práticas revisadas.');
      expect(l10n.textWithParameters('academy.progressUpdate', parameters: const {'completed': 2, 'total': 8}),
          'Progresso atualizado: 2 de 8 lições concluídas.');
    });

    test('localizes all eight Academy lessons without changing scoring', () {
      expect(AcademyCurriculum.lessons, hasLength(8));
      for (final lesson in AcademyCurriculum.lessons) {
        final translated = PortugueseAcademyContent.localize(lesson, 'pt');
        expect(translated.id, lesson.id);
        expect(translated.title, isNot(lesson.title));
        expect(translated.summary, isNot(lesson.summary));
        expect(translated.keyPoints, hasLength(lesson.keyPoints.length));
        expect(translated.options, hasLength(lesson.options.length));
        expect(translated.correctIndex, lesson.correctIndex);
        expect(translated.explanation, isNot(lesson.explanation));
      }
    });

    test('localizes all twelve Privacy practices', () {
      expect(PrivacyChecklist.practices, hasLength(12));
      for (final practice in PrivacyChecklist.practices) {
        final translated = PortuguesePrivacyContent.localize(practice, 'pt');
        expect(translated.id, practice.id);
        expect(translated.title, isNot(practice.title));
        expect(translated.why, isNot(practice.why));
        expect(translated.action, isNot(practice.action));
        expect(translated.limit, isNot(practice.limit));
      }
    });

    test('localizes all five Response playbooks', () {
      expect(ResponsePlaybooks.playbooks, hasLength(5));
      for (final playbook in ResponsePlaybooks.playbooks) {
        final translated = PortugueseResponseContent.localize(playbook, 'pt');
        expect(translated.id, playbook.id);
        expect(translated.title, isNot(playbook.title));
        expect(translated.summary, isNot(playbook.summary));
        expect(translated.firstAction, isNot(playbook.firstAction));
        expect(translated.steps, hasLength(playbook.steps.length));
        expect(translated.preserve, hasLength(playbook.preserve.length));
        expect(translated.avoid, hasLength(playbook.avoid.length));
        expect(translated.limit, isNot(playbook.limit));
      }
    });

    test('localizes all ten Intelligence references', () {
      expect(IntelligenceLibrary.entries, hasLength(10));
      for (final entry in IntelligenceLibrary.entries) {
        final translated = PortugueseIntelligenceContent.localize(entry, 'pt');
        expect(translated.id, entry.id);
        expect(translated.title, isNot(entry.title));
        expect(translated.signal, isNot(entry.signal));
        expect(translated.meaning, isNot(entry.meaning));
        expect(translated.action, isNot(entry.action));
        expect(translated.limit, isNot(entry.limit));
      }
    });
  });
}

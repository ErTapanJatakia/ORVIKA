import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/core/localization/orvika_language.dart';
import 'package:orvika/core/localization/orvika_localizations.dart';
import 'package:orvika/core/localization/russian_academy_content.dart';
import 'package:orvika/core/localization/russian_privacy_content.dart';
import 'package:orvika/core/localization/russian_response_content.dart';
import 'package:orvika/core/localization/russian_intelligence_content.dart';
import 'package:orvika/core/localization/russian_checker_content.dart';
import 'package:orvika/features/academy/domain/academy_curriculum.dart';
import 'package:orvika/features/privacy/domain/privacy_checklist.dart';
import 'package:orvika/features/response/domain/response_playbooks.dart';
import 'package:orvika/features/intelligence/domain/intelligence_library.dart';
import 'package:orvika/features/link_check/domain/url_analyzer.dart';

void main() {
  group('Russian feature localization completeness', () {
    const code = 'ru';
    final l10n = OrvikaLocalizations(OrvikaLanguage.fromCode(code));

    test('covers all reviewed core interface keys', () {
      expect(OrvikaLocalizations.requiredTranslationKeys, hasLength(138));
      for (final key in OrvikaLocalizations.requiredTranslationKeys) {
        expect(l10n.hasTranslation(key), isTrue, reason: 'Missing Russian key: $key');
        expect(l10n.text(key), isNot(key), reason: 'Unresolved Russian key: $key');
      }
    });

    test('localizes every Academy lesson and preserves assessment logic', () {
      expect(AcademyCurriculum.lessons, hasLength(8));
      for (final source in AcademyCurriculum.lessons) {
        final item = RussianAcademyContent.localize(source, code);
        expect(item.id, source.id);
        expect(item.title, isNot(source.title));
        expect(item.summary, isNot(source.summary));
        expect(item.keyPoints, hasLength(source.keyPoints.length));
        expect(item.question, isNot(source.question));
        expect(item.options, hasLength(source.options.length));
        expect(item.correctIndex, source.correctIndex);
        expect(item.explanation, isNot(source.explanation));
      }
    });

    test('localizes all twelve Privacy practices', () {
      expect(PrivacyChecklist.practices, hasLength(12));
      for (final source in PrivacyChecklist.practices) {
        final item = RussianPrivacyContent.localize(source, code);
        expect(item.id, source.id);
        expect(item.title, isNot(source.title));
        expect(item.why, isNot(source.why));
        expect(item.action, isNot(source.action));
        expect(item.limit, isNot(source.limit));
      }
    });

    test('localizes all five Response playbooks and preserves list counts', () {
      expect(ResponsePlaybooks.playbooks, hasLength(5));
      for (final source in ResponsePlaybooks.playbooks) {
        final item = RussianResponseContent.localize(source, code);
        expect(item.id, source.id);
        expect(item.title, isNot(source.title));
        expect(item.summary, isNot(source.summary));
        expect(item.firstAction, isNot(source.firstAction));
        expect(item.steps, hasLength(source.steps.length));
        expect(item.preserve, hasLength(source.preserve.length));
        expect(item.avoid, hasLength(source.avoid.length));
        expect(item.limit, isNot(source.limit));
      }
    });

    test('localizes all ten Intelligence references', () {
      expect(IntelligenceLibrary.entries, hasLength(10));
      for (final source in IntelligenceLibrary.entries) {
        final item = RussianIntelligenceContent.localize(source, code);
        expect(item.id, source.id);
        expect(item.title, isNot(source.title));
        expect(item.signal, isNot(source.signal));
        expect(item.meaning, isNot(source.meaning));
        expect(item.action, isNot(source.action));
        expect(item.limit, isNot(source.limit));
      }
    });

    test('localizes checker findings without changing severity', () {
      const source = LinkFinding(
        title: 'Unencrypted connection',
        detail: 'This address uses HTTP.',
        severity: FindingSeverity.warning,
      );
      final item = RussianCheckerContent.localizeFinding(source, code);
      expect(item.title, 'Незашифрованное соединение');
      expect(item.detail, isNot(source.detail));
      expect(item.severity, source.severity);
      expect(RussianCheckerContent.localizeMessageNotice(code), contains('эвристические'));
      expect(RussianCheckerContent.localizeLinkNotice('No network request was made.', code),
          'Сетевые запросы не выполнялись.');
    });

    test('retains named placeholders in Russian UI notices', () {
      expect(l10n.text('checker.camera.previewError'), contains('{error}'));
      expect(l10n.text('checker.qr.detectedFormat', 'Detected code format: {format}'), contains('{format}'));
      expect(l10n.text('privacy.analytics.notice'), contains('Vercel Web Analytics'));
    });
  });
}

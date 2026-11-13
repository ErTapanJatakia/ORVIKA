import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/core/localization/orvika_language.dart';
import 'package:orvika/core/localization/orvika_localizations.dart';
import 'package:orvika/core/localization/spanish_academy_content.dart';
import 'package:orvika/core/localization/spanish_privacy_content.dart';
import 'package:orvika/core/localization/spanish_response_content.dart';
import 'package:orvika/core/localization/spanish_intelligence_content.dart';
import 'package:orvika/features/academy/domain/academy_curriculum.dart';
import 'package:orvika/features/privacy/domain/privacy_checklist.dart';
import 'package:orvika/features/response/domain/response_playbooks.dart';
import 'package:orvika/features/intelligence/domain/intelligence_library.dart';

void main() {
  group('Spanish localization coverage', () {
    final l10n = OrvikaLocalizations(OrvikaLanguage.fromCode('es'));

    test('covers every key in the 146-key reviewed baseline', () {
      expect(OrvikaLocalizations.requiredTranslationKeys, hasLength(146));
      for (final key in OrvikaLocalizations.requiredTranslationKeys) {
        expect(l10n.hasTranslation(key), isTrue, reason: 'Spanish is missing $key');
        expect(l10n.text(key), isNot(key), reason: 'Spanish resolves $key to its key');
      }
    });

    test('preserves named placeholders in progress and dynamic strings', () {
      expect(l10n.textWithParameters('privacy.progressUpdate', parameters: const {'reviewed': 3, 'total': 12}),
          'Progreso actualizado: 3 de 12 prácticas revisadas.');
      expect(l10n.textWithParameters('academy.progressUpdate', parameters: const {'completed': 2, 'total': 8}),
          'Progreso actualizado: 2 de 8 lecciones completadas.');
    });

    test('localizes all eight Academy lessons without changing scoring', () {
      expect(AcademyCurriculum.lessons, hasLength(8));
      for (final lesson in AcademyCurriculum.lessons) {
        final translated = SpanishAcademyContent.localize(lesson, 'es');
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
        final translated = SpanishPrivacyContent.localize(practice, 'es');
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
        final translated = SpanishResponseContent.localize(playbook, 'es');
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
        final translated = SpanishIntelligenceContent.localize(entry, 'es');
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

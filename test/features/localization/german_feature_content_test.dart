import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/core/localization/german_academy_content.dart';
import 'package:orvika/core/localization/german_intelligence_content.dart';
import 'package:orvika/core/localization/german_privacy_content.dart';
import 'package:orvika/core/localization/german_response_content.dart';
import 'package:orvika/features/academy/domain/academy_curriculum.dart';
import 'package:orvika/features/intelligence/domain/intelligence_library.dart';
import 'package:orvika/features/privacy/domain/privacy_checklist.dart';
import 'package:orvika/features/response/domain/response_playbooks.dart';

void main() {
  test('German Academy content covers every lesson and preserves quiz structure', () {
    for (final source in AcademyCurriculum.lessons) {
      final translated = GermanAcademyContent.localize(source, 'de');
      expect(translated.title, isNot(source.title), reason: source.id);
      expect(translated.summary, isNot(source.summary), reason: source.id);
      expect(translated.keyPoints, hasLength(source.keyPoints.length), reason: source.id);
      expect(translated.question, isNot(source.question), reason: source.id);
      expect(translated.options, hasLength(source.options.length), reason: source.id);
      expect(translated.correctIndex, source.correctIndex, reason: source.id);
      expect(translated.explanation, isNot(source.explanation), reason: source.id);
      expect(translated.keyPoints.every((value) => value.isNotEmpty), isTrue, reason: source.id);
      expect(translated.options.every((value) => value.isNotEmpty), isTrue, reason: source.id);
    }
  });

  test('German privacy content covers every practice field', () {
    for (final source in PrivacyChecklist.practices) {
      final translated = GermanPrivacyContent.localize(source, 'de');
      expect(translated.title, isNot(source.title), reason: source.id);
      expect(translated.why, isNot(source.why), reason: source.id);
      expect(translated.action, isNot(source.action), reason: source.id);
      expect(translated.limit, isNot(source.limit), reason: source.id);
    }
  });

  test('German response content covers every playbook field and list item', () {
    for (final source in ResponsePlaybooks.playbooks) {
      final translated = GermanResponseContent.localize(source, 'de');
      expect(translated.title, isNot(source.title), reason: source.id);
      expect(translated.summary, isNot(source.summary), reason: source.id);
      expect(translated.firstAction, isNot(source.firstAction), reason: source.id);
      expect(translated.steps, hasLength(source.steps.length), reason: source.id);
      expect(translated.preserve, hasLength(source.preserve.length), reason: source.id);
      expect(translated.avoid, hasLength(source.avoid.length), reason: source.id);
      expect(translated.limit, isNot(source.limit), reason: source.id);
      expect([...translated.steps, ...translated.preserve, ...translated.avoid]
          .every((value) => value.isNotEmpty), isTrue, reason: source.id);
    }
  });

  test('German intelligence reference translates all curated entries', () {
    for (final source in IntelligenceLibrary.entries) {
      final translated = GermanIntelligenceContent.localize(source, 'de');
      expect(translated.title, isNot(source.title), reason: source.id);
      expect(translated.signal, isNot(source.signal), reason: source.id);
      expect(translated.meaning, isNot(source.meaning), reason: source.id);
      expect(translated.action, isNot(source.action), reason: source.id);
      expect(translated.limit, isNot(source.limit), reason: source.id);
    }
  });

  test('non-German locales retain the source content unchanged', () {
    final lesson = AcademyCurriculum.lessons.first;
    final practice = PrivacyChecklist.practices.first;
    final playbook = ResponsePlaybooks.playbooks.first;
    final entry = IntelligenceLibrary.entries.first;
    expect(GermanAcademyContent.localize(lesson, 'en'), same(lesson));
    expect(GermanPrivacyContent.localize(practice, 'en'), same(practice));
    expect(GermanResponseContent.localize(playbook, 'en'), same(playbook));
    expect(GermanIntelligenceContent.localize(entry, 'en'), same(entry));
  });
}

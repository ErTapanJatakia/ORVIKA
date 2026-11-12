import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/core/localization/italian_academy_content.dart';
import 'package:orvika/core/localization/italian_intelligence_content.dart';
import 'package:orvika/core/localization/italian_privacy_content.dart';
import 'package:orvika/core/localization/italian_response_content.dart';
import 'package:orvika/features/academy/domain/academy_curriculum.dart';
import 'package:orvika/features/intelligence/domain/intelligence_library.dart';
import 'package:orvika/features/privacy/domain/privacy_checklist.dart';
import 'package:orvika/features/response/domain/response_playbooks.dart';

void main() {
  test('Italian Academy translates every lesson and preserves quiz semantics', () {
    for (final source in AcademyCurriculum.lessons) {
      final translated = ItalianAcademyContent.localize(source, 'it');
      expect(translated.title, isNot(source.title), reason: source.id);
      expect(translated.summary, isNot(source.summary), reason: source.id);
      expect(translated.keyPoints, hasLength(source.keyPoints.length), reason: source.id);
      expect(translated.question, isNot(source.question), reason: source.id);
      expect(translated.options, hasLength(source.options.length), reason: source.id);
      expect(translated.correctIndex, source.correctIndex, reason: source.id);
      expect(translated.explanation, isNot(source.explanation), reason: source.id);
    }
  });

  test('Italian Privacy translates every practice field', () {
    for (final source in PrivacyChecklist.practices) {
      final translated = ItalianPrivacyContent.localize(source, 'it');
      expect(translated.title, isNot(source.title), reason: source.id);
      expect(translated.why, isNot(source.why), reason: source.id);
      expect(translated.action, isNot(source.action), reason: source.id);
      expect(translated.limit, isNot(source.limit), reason: source.id);
    }
  });

  test('Italian Response translates all playbooks without changing scenario or list sizes', () {
    for (final source in ResponsePlaybooks.playbooks) {
      final translated = ItalianResponseContent.localize(source, 'it');
      expect(translated.title, isNot(source.title), reason: source.id);
      expect(translated.summary, isNot(source.summary), reason: source.id);
      expect(translated.firstAction, isNot(source.firstAction), reason: source.id);
      expect(translated.scenario, source.scenario);
      expect(translated.steps, hasLength(source.steps.length), reason: source.id);
      expect(translated.preserve, hasLength(source.preserve.length), reason: source.id);
      expect(translated.avoid, hasLength(source.avoid.length), reason: source.id);
      expect(translated.limit, isNot(source.limit), reason: source.id);
    }
  });

  test('Italian Intelligence translates every curated reference field', () {
    for (final source in IntelligenceLibrary.entries) {
      final translated = ItalianIntelligenceContent.localize(source, 'it');
      expect(translated.title, isNot(source.title), reason: source.id);
      expect(translated.signal, isNot(source.signal), reason: source.id);
      expect(translated.meaning, isNot(source.meaning), reason: source.id);
      expect(translated.action, isNot(source.action), reason: source.id);
      expect(translated.limit, isNot(source.limit), reason: source.id);
    }
  });

  test('other locales retain canonical source objects', () {
    expect(ItalianAcademyContent.localize(AcademyCurriculum.lessons.first, 'en'),
        same(AcademyCurriculum.lessons.first));
    expect(ItalianPrivacyContent.localize(PrivacyChecklist.practices.first, 'en'),
        same(PrivacyChecklist.practices.first));
    expect(ItalianResponseContent.localize(ResponsePlaybooks.playbooks.first, 'en'),
        same(ResponsePlaybooks.playbooks.first));
    expect(ItalianIntelligenceContent.localize(IntelligenceLibrary.entries.first, 'en'),
        same(IntelligenceLibrary.entries.first));
  });
}

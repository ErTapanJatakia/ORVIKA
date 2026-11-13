import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/features/academy/domain/academy_curriculum.dart';
import 'package:orvika/features/intelligence/domain/intelligence_library.dart';
import 'package:orvika/features/privacy/domain/privacy_checklist.dart';
import 'package:orvika/features/response/domain/response_playbooks.dart';
import 'package:orvika/features/link_check/domain/url_analyzer.dart';
import 'package:orvika/core/localization/german_academy_content.dart';
import 'package:orvika/core/localization/german_checker_content.dart';
import 'package:orvika/core/localization/german_intelligence_content.dart';
import 'package:orvika/core/localization/german_privacy_content.dart';
import 'package:orvika/core/localization/german_response_content.dart';
import 'package:orvika/core/localization/french_academy_content.dart';
import 'package:orvika/core/localization/french_checker_content.dart';
import 'package:orvika/core/localization/french_intelligence_content.dart';
import 'package:orvika/core/localization/french_privacy_content.dart';
import 'package:orvika/core/localization/french_response_content.dart';
import 'package:orvika/core/localization/italian_academy_content.dart';
import 'package:orvika/core/localization/italian_checker_content.dart';
import 'package:orvika/core/localization/italian_intelligence_content.dart';
import 'package:orvika/core/localization/italian_privacy_content.dart';
import 'package:orvika/core/localization/italian_response_content.dart';
import 'package:orvika/core/localization/spanish_academy_content.dart';
import 'package:orvika/core/localization/spanish_checker_content.dart';
import 'package:orvika/core/localization/spanish_intelligence_content.dart';
import 'package:orvika/core/localization/spanish_privacy_content.dart';
import 'package:orvika/core/localization/spanish_response_content.dart';
import 'package:orvika/core/localization/portuguese_academy_content.dart';
import 'package:orvika/core/localization/portuguese_checker_content.dart';
import 'package:orvika/core/localization/portuguese_intelligence_content.dart';
import 'package:orvika/core/localization/portuguese_privacy_content.dart';
import 'package:orvika/core/localization/portuguese_response_content.dart';
import 'package:orvika/core/localization/russian_academy_content.dart';
import 'package:orvika/core/localization/russian_checker_content.dart';
import 'package:orvika/core/localization/russian_intelligence_content.dart';
import 'package:orvika/core/localization/russian_privacy_content.dart';
import 'package:orvika/core/localization/russian_response_content.dart';

void main() {
  group('Six-priority locale feature-content coverage', () {
    test('German content covers every canonical feature identifier and preserves semantics', () {
      verifyLocaleContent(
        locale: 'de',
        academy: (value) => GermanAcademyContent.localize(value, 'de'),
        intelligence: (value) => GermanIntelligenceContent.localize(value, 'de'),
        privacy: (value) => GermanPrivacyContent.localize(value, 'de'),
        response: (value) => GermanResponseContent.localize(value, 'de'),
        checkerFinding: (value) => GermanCheckerContent.localizeFinding(value, 'de'),
      );
    });

    test('French content covers every canonical feature identifier and preserves semantics', () {
      verifyLocaleContent(
        locale: 'fr',
        academy: (value) => FrenchAcademyContent.localize(value, 'fr'),
        intelligence: (value) => FrenchIntelligenceContent.localize(value, 'fr'),
        privacy: (value) => FrenchPrivacyContent.localize(value, 'fr'),
        response: (value) => FrenchResponseContent.localize(value, 'fr'),
        checkerFinding: (value) => FrenchCheckerContent.localizeFinding(value, 'fr'),
      );
    });

    test('Italian content covers every canonical feature identifier and preserves semantics', () {
      verifyLocaleContent(
        locale: 'it',
        academy: (value) => ItalianAcademyContent.localize(value, 'it'),
        intelligence: (value) => ItalianIntelligenceContent.localize(value, 'it'),
        privacy: (value) => ItalianPrivacyContent.localize(value, 'it'),
        response: (value) => ItalianResponseContent.localize(value, 'it'),
        checkerFinding: (value) => ItalianCheckerContent.localizeFinding(value, 'it'),
      );
    });

    test('Spanish content covers every canonical feature identifier and preserves semantics', () {
      verifyLocaleContent(
        locale: 'es',
        academy: (value) => SpanishAcademyContent.localize(value, 'es'),
        intelligence: (value) => SpanishIntelligenceContent.localize(value, 'es'),
        privacy: (value) => SpanishPrivacyContent.localize(value, 'es'),
        response: (value) => SpanishResponseContent.localize(value, 'es'),
        checkerFinding: (value) => SpanishCheckerContent.localizeFinding(value, 'es'),
      );
    });

    test('Portuguese content covers every canonical feature identifier and preserves semantics', () {
      verifyLocaleContent(
        locale: 'pt',
        academy: (value) => PortugueseAcademyContent.localize(value, 'pt'),
        intelligence: (value) => PortugueseIntelligenceContent.localize(value, 'pt'),
        privacy: (value) => PortuguesePrivacyContent.localize(value, 'pt'),
        response: (value) => PortugueseResponseContent.localize(value, 'pt'),
        checkerFinding: (value) => PortugueseCheckerContent.localizeFinding(value, 'pt'),
      );
    });

    test('Russian content covers every canonical feature identifier and preserves semantics', () {
      verifyLocaleContent(
        locale: 'ru',
        academy: (value) => RussianAcademyContent.localize(value, 'ru'),
        intelligence: (value) => RussianIntelligenceContent.localize(value, 'ru'),
        privacy: (value) => RussianPrivacyContent.localize(value, 'ru'),
        response: (value) => RussianResponseContent.localize(value, 'ru'),
        checkerFinding: (value) => RussianCheckerContent.localizeFinding(value, 'ru'),
      );
    });
  });
}

void verifyLocaleContent({
  required String locale,
  required AcademyLesson Function(AcademyLesson) academy,
  required IntelligenceEntry Function(IntelligenceEntry) intelligence,
  required PrivacyPractice Function(PrivacyPractice) privacy,
  required ResponsePlaybook Function(ResponsePlaybook) response,
  required LinkFinding Function(LinkFinding) checkerFinding,
}) {
  for (final source in AcademyCurriculum.lessons) {
    final translated = academy(source);
    expect(translated.id, source.id, reason: '$locale Academy ID changed');
    expect(translated.title, isNot(source.title), reason: '$locale missing Academy title: ${source.id}');
    expect(translated.correctIndex, source.correctIndex, reason: '$locale changed answer index: ${source.id}');
    expect(translated.options, hasLength(source.options.length), reason: '$locale changed answer count: ${source.id}');
    expect(translated.keyPoints, hasLength(source.keyPoints.length), reason: '$locale changed key-point count: ${source.id}');
  }

  for (final source in IntelligenceLibrary.entries) {
    final translated = intelligence(source);
    expect(translated.id, source.id, reason: '$locale Intelligence ID changed');
    expect(translated.title, isNot(source.title), reason: '$locale missing Intelligence title: ${source.id}');
    expect(translated.category, source.category, reason: '$locale changed Intelligence category: ${source.id}');
  }

  for (final source in PrivacyChecklist.practices) {
    final translated = privacy(source);
    expect(translated.id, source.id, reason: '$locale Privacy ID changed');
    expect(translated.title, isNot(source.title), reason: '$locale missing Privacy title: ${source.id}');
    expect(translated.category, source.category, reason: '$locale changed Privacy category: ${source.id}');
  }

  for (final source in ResponsePlaybooks.playbooks) {
    final translated = response(source);
    expect(translated.id, source.id, reason: '$locale Response ID changed');
    expect(translated.title, isNot(source.title), reason: '$locale missing Response title: ${source.id}');
    expect(translated.scenario, source.scenario, reason: '$locale changed Response scenario: ${source.id}');
    expect(translated.steps, hasLength(source.steps.length), reason: '$locale changed response steps: ${source.id}');
    expect(translated.preserve, hasLength(source.preserve.length), reason: '$locale changed evidence-preservation steps: ${source.id}');
    expect(translated.avoid, hasLength(source.avoid.length), reason: '$locale changed avoid-list count: ${source.id}');
  }

  const checkerTitles = [
    'Unicode hostname', 'Unencrypted connection', 'Embedded sign-in information',
    'Internationalised domain encoding', 'IP-address destination',
    'Malformed IPv4-looking hostname', 'Unusual numeric hostname',
    'Long subdomain chain', 'Non-standard port', 'Fragment present',
    'No structural warning detected', 'Address not analysed',
    'Urgency or pressure language', 'Credential or sign-in request',
    'OTP or authentication-code reference', 'Payment or financial action',
    'Prize or unexpected reward', 'Threat or consequence language',
    'Obfuscated web address detected', 'Link or web address detected',
    'No listed social-engineering cues detected', 'Message not analysed',
  ];
  for (final title in checkerTitles) {
    final source = LinkFinding(title: title, detail: 'Canonical checker detail', severity: FindingSeverity.warning);
    final translated = checkerFinding(source);
    expect(translated.title, isNot(source.title), reason: '$locale missing checker finding: $title');
    expect(translated.severity, source.severity, reason: '$locale changed finding severity: $title');
  }
}

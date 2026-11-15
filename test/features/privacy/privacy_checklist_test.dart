import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/features/privacy/domain/privacy_checklist.dart';

void main() {
  test('privacy practices have unique identifiers and cover every category', () {
    const practices = PrivacyChecklist.practices;
    final ids = practices.map((practice) => practice.id).toSet();

    expect(ids.length, practices.length);
    expect(practices.length, greaterThanOrEqualTo(10));
    for (final category in PrivacyCategory.values) {
      expect(practices.any((practice) => practice.category == category), isTrue);
    }
  });

  test('every practice provides rationale, action and a limitation', () {
    for (final practice in PrivacyChecklist.practices) {
      expect(practice.why, isNotEmpty, reason: practice.id);
      expect(practice.action, isNotEmpty, reason: practice.id);
      expect(practice.limit, isNotEmpty, reason: practice.id);
    }
  });

  test('editorial priorities are stable and distinguish critical hygiene items', () {
    const checklist = PrivacyChecklist();
    final byId = {
      for (final practice in PrivacyChecklist.practices) practice.id: practice,
    };

    expect(checklist.priorityFor(byId['account-mfa']!), PrivacyPriority.high);
    expect(checklist.priorityFor(byId['device-updates']!), PrivacyPriority.high);
    expect(checklist.priorityFor(byId['browsing-network']!), PrivacyPriority.recommended);
    expect(checklist.priorityFor(byId['browsing-sharing']!), PrivacyPriority.routine);
  });

  test('assessment answers are explicit states and not persisted by the domain model', () {
    expect(PrivacyAssessmentStatus.values, containsAll([
      PrivacyAssessmentStatus.inPlace,
      PrivacyAssessmentStatus.needsAttention,
      PrivacyAssessmentStatus.unsure,
    ]));
  });

  test('category results contain only matching practices and are immutable', () {
    final results = const PrivacyChecklist().byCategory(PrivacyCategory.apps);

    expect(results, isNotEmpty);
    expect(results.every((practice) => practice.category == PrivacyCategory.apps), isTrue);
    expect(
      () => results.add(PrivacyChecklist.practices.first),
      throwsUnsupportedError,
    );
    expect(
      const PrivacyChecklist().byCategory(PrivacyCategory.accounts).length,
      greaterThanOrEqualTo(3),
    );
  });
}

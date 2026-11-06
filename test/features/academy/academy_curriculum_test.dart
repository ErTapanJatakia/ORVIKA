import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/features/academy/domain/academy_curriculum.dart';

void main() {
  const curriculum = AcademyCurriculum();

  test('curriculum has unique lesson identifiers and complete knowledge checks', () {
    const lessons = AcademyCurriculum.lessons;
    expect(lessons, isNotEmpty);
    expect(lessons.map((lesson) => lesson.id).toSet().length, lessons.length);
    for (final lesson in lessons) {
      expect(lesson.title, isNotEmpty);
      expect(lesson.summary, isNotEmpty);
      expect(lesson.keyPoints, isNotEmpty);
      expect(lesson.question, isNotEmpty);
      expect(lesson.options.length, greaterThanOrEqualTo(2));
      expect(lesson.correctIndex, inInclusiveRange(0, lesson.options.length - 1));
      expect(lesson.explanation, isNotEmpty);
    }
  });

  test('category filters return only matching lessons', () {
    for (final category in AcademyCategory.values) {
      final results = curriculum.byCategory(category);
      expect(results, isNotEmpty);
      expect(results.every((lesson) => lesson.category == category), isTrue);
    }
  });
}

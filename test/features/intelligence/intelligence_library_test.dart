import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/features/intelligence/domain/intelligence_library.dart';

void main() {
  const library = IntelligenceLibrary();

  test('curated reference entries have unique identifiers', () {
    final ids = IntelligenceLibrary.entries.map((entry) => entry.id).toSet();
    expect(ids.length, IntelligenceLibrary.entries.length);
    expect(IntelligenceLibrary.entries.length, greaterThanOrEqualTo(8));
  });

  test('search finds relevant entries across explanatory fields', () {
    expect(library.search(query: 'Punycode').map((entry) => entry.id),
        contains('url-punycode'));
    expect(library.search(query: 'approval prompt').map((entry) => entry.id),
        contains('account-mfa'));
  });

  test('category filter narrows results without changing source entries', () {
    final results = library.search(category: IntelligenceCategory.qrCodes);
    expect(results, isNotEmpty);
    expect(results.every((entry) => entry.category == IntelligenceCategory.qrCodes), isTrue);
    expect(library.search().length, IntelligenceLibrary.entries.length);
  });

  test('combined query and category filter returns only matching entries', () {
    final results = library.search(
      query: 'payment',
      category: IntelligenceCategory.qrCodes,
    );
    expect(results.map((entry) => entry.id), contains('qr-payment'));
    expect(results.any((entry) => entry.id == 'message-payment'), isFalse);
  });

  test('search with no matches returns an empty immutable result', () {
    final results = library.search(query: 'not-a-real-indicator');
    expect(results, isEmpty);
    expect(() => results.add(IntelligenceLibrary.entries.first), throwsUnsupportedError);
  });
}

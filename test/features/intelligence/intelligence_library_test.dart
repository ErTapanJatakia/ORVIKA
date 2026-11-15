import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/features/intelligence/domain/intelligence_library.dart';

void main() {
  const library = IntelligenceLibrary();

  test('curated reference entries have unique identifiers', () {
    final ids = IntelligenceLibrary.entries.map((entry) => entry.id).toSet();
    expect(ids.length, IntelligenceLibrary.entries.length);
    expect(IntelligenceLibrary.entries.length, equals(22));
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
    expect(library.search().length, 22);
  });

  test('combined query and category filter returns only matching entries', () {
    final results = library.search(
      query: 'payment',
      category: IntelligenceCategory.qrCodes,
    );
    expect(results.map((entry) => entry.id), contains('qr-payment'));
    expect(results.length, 1);
    expect(results.any((entry) => entry.id == 'message-payment'), isFalse);
  });


  test('catalogue entries provide complete explanations and safe actions', () {
    for (final entry in IntelligenceLibrary.entries) {
      expect(entry.title.trim(), isNotEmpty, reason: entry.id);
      expect(entry.signal.trim(), isNotEmpty, reason: entry.id);
      expect(entry.meaning.trim(), isNotEmpty, reason: entry.id);
      expect(entry.action.trim(), isNotEmpty, reason: entry.id);
      expect(entry.limit.trim(), isNotEmpty, reason: entry.id);
    }
  });

  test('expanded references cover shorteners, downloads, remote access and recovery', () {
    expect(library.search(query: 'redirect').map((entry) => entry.id),
        contains('url-shortener'));
    expect(library.search(query: 'executable').map((entry) => entry.id),
        contains('url-download'));
    expect(library.search(query: 'screen-sharing').map((entry) => entry.id),
        contains('message-remote-access'));
    expect(library.search(query: 'password-reset').map((entry) => entry.id),
        contains('account-recovery'));
    expect(library.search(query: 'Wi-Fi').map((entry) => entry.id),
        contains('qr-wifi'));
  });

  test('search with no matches returns an empty immutable result', () {
    final results = library.search(query: 'not-a-real-indicator');
    expect(results, isEmpty);
    expect(() => results.add(IntelligenceLibrary.entries.first), throwsUnsupportedError);
  });
}

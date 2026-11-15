import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/core/platform/accessibility_contact_launcher.dart';

void main() {
  test('accessibility contact launcher is available on every platform', () {
    expect(openAccessibilityContact, returnsNormally);
  });
}

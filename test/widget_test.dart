import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/main.dart';

void main() {
  testWidgets('ORVIKA dashboard presents its core safety modules', (tester) async {
    await tester.pumpWidget(const OrvikaApp());

    expect(find.text('ORVIKA'), findsOneWidget);
    expect(find.text('CHECK BEFORE YOU TRUST.'), findsOneWidget);
    expect(find.text('Link Check'), findsOneWidget);
    expect(find.text('QR Check'), findsOneWidget);
    expect(find.text('Message Check'), findsOneWidget);
    expect(find.text('Privacy Check'), findsOneWidget);
    expect(find.textContaining('early prototype'), findsOneWidget);
  });
}

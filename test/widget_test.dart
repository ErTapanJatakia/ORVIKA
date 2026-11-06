import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/main.dart';

void main() {
  testWidgets('renders ORVIKA Sentinel landing screen', (tester) async {
    await tester.pumpWidget(const OrvikaApp());

    expect(find.text('ORVIKA'), findsOneWidget);
    expect(find.text('Check before\nyou trust.'), findsOneWidget);
    expect(find.text('Link Check'), findsOneWidget);
    expect(find.text('QR Check'), findsOneWidget);
    expect(find.text('Message Check'), findsOneWidget);
  });

  testWidgets('clearly identifies planned tools as inactive', (tester) async {
    await tester.pumpWidget(const OrvikaApp());

    await tester.tap(find.text('Link Check'));
    await tester.pump();

    expect(
      find.text('Link Check is planned and not active yet.'),
      findsOneWidget,
    );
  });
}

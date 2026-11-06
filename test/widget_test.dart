import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
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

    // Scroll the outer dashboard so its lazily built trust note enters the tree.
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -900));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('ORVIKA is an early prototype'),
      findsOneWidget,
    );
  });

  testWidgets('QR Check opens and inspects a payment payload without initiating it', (tester) async {
    await tester.pumpWidget(const OrvikaApp());

    await tester.ensureVisible(find.text('QR Check'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('QR Check'));
    await tester.pumpAndSettle();

    expect(find.text('Inspect QR content'), findsOneWidget);
    await tester.enterText(
      find.byType(TextField),
      'upi://pay?pa=merchant@example&pn=Merchant',
    );
    await tester.tap(find.text('Inspect QR content'));
    await tester.pumpAndSettle();

    expect(find.text('UPI payment request'), findsOneWidget);
    expect(find.textContaining('will not initiate or approve a payment'), findsOneWidget);
  });

}

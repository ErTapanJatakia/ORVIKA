import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/main.dart';

void main() {
  testWidgets('privacy notice ends with developer and DPO contact details', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: OrvikaPrivacyNoticeScreen(),
    ));
    await tester.pumpAndSettle();

    expect(find.text('App developer and Data Protection Officer'), findsOneWidget);
    final contact = tester.widget<SelectableText>(find.byType(SelectableText).last);
    expect(contact.data, contains('Er. Tapan Jatakia (C.Eng.)'));
    expect(contact.data, contains('ertapanjatakia@yandex.com'));
    expect(contact.data, contains('tapan_ditu_17.20@outlook.com'));
    expect(contact.data, contains('+91 9664332984'));
    expect(contact.data, contains('http://linktr.ee/ertapanjatakia'));

    final disclaimer = find.textContaining('This notice describes the current implementation');
    expect(tester.getTopLeft(find.text('App developer and Data Protection Officer')).dy,
        greaterThan(tester.getTopLeft(disclaimer).dy));
    expect(tester.takeException(), isNull);
  });
}

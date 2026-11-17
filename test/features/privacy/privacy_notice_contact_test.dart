import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/main.dart';

void main() {
  testWidgets('privacy notice ends with developer and DPO contact details', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: OrvikaPrivacyNoticeScreen(),
    ));
    await tester.pumpAndSettle();

    final noticeScrollable = find.descendant(
      of: find.byType(ListView),
      matching: find.byType(Scrollable),
    ).first;
    await tester.scrollUntilVisible(
      find.text('App developer and Data Protection Officer'),
      250,
      scrollable: noticeScrollable,
    );
    await tester.pumpAndSettle();

    expect(find.text('App developer and Data Protection Officer'), findsOneWidget);
    final contact = tester.widget<SelectableText>(find.byType(SelectableText).last);
    expect(contact.data, contains('Er. Tapan Jatakia (C.Eng.)'));
    expect(contact.data, contains('ertapanjatakia@yandex.com'));
    expect(contact.data, contains('tapan_ditu_17.20@outlook.com'));
    expect(contact.data, contains('+91 9664332984'));
    expect(contact.data, contains('http://linktr.ee/ertapanjatakia'));

    await tester.drag(find.byType(ListView), const Offset(0, -1200));
    await tester.pumpAndSettle();
    final scrollableState = tester.state<ScrollableState>(noticeScrollable);
    expect(
      scrollableState.position.pixels,
      closeTo(scrollableState.position.maxScrollExtent, 1.0),
      reason: 'Developer and DPO details must be reachable at the end of the notice.',
    );
    expect(find.text('App developer and Data Protection Officer'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/main.dart';

void main() {
  testWidgets('privacy notice ends with separate developer and DPO contact details', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: OrvikaPrivacyNoticeScreen()));
    await tester.pumpAndSettle();

    final noticeScrollable = find.descendant(
      of: find.byType(ListView),
      matching: find.byType(Scrollable),
    ).first;
    final developerHeading = find.text('The Contact Information of the App Developer and the Support Team is:');
    await tester.scrollUntilVisible(developerHeading, 250, scrollable: noticeScrollable);
    expect(developerHeading, findsOneWidget);
    final developer = tester.widget<SelectableText>(
      find.byWidgetPredicate((widget) => widget is SelectableText &&
        (widget.data ?? '').contains('ertapanjatakia@yandex.com')),
    );
    expect(developer.data, contains('Er. Tapan Jatakia (C.Eng.)'));
    expect(developer.data, contains('ertapanjatakia@yandex.com (for Russia)'));
    expect(developer.data, contains('tapan_ditu_17.20@outlook.com (for regions except Russia)'));
    expect(developer.data, contains('+91 9664332984'));
    expect(developer.data, contains('https://linktr.ee/ertapanjatakia'));

    final dpoHeading = find.text('The Contact Information of the Data Protection Officer is:');
    await tester.scrollUntilVisible(dpoHeading, 220, scrollable: noticeScrollable);
    expect(dpoHeading, findsOneWidget);
    final dpo = tester.widget<SelectableText>(
      find.byWidgetPredicate((widget) => widget is SelectableText &&
        (widget.data ?? '').contains('cyber.litigation.advisor@gmail.com')),
    );
    expect(dpo.data, contains('Er. Tapan Jatakia (C.Eng.)'));
    expect(dpo.data, contains('+91 9664332984'));
    expect(dpo.data, contains('https://linktr.ee/ertapanjatakia'));

    await tester.drag(find.byType(ListView), const Offset(0, -1200));
    await tester.pumpAndSettle();
    final scrollableState = tester.state<ScrollableState>(noticeScrollable);
    expect(scrollableState.position.pixels,
      closeTo(scrollableState.position.maxScrollExtent, 1.0));
    expect(tester.takeException(), isNull);
  });
}

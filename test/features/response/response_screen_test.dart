import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/features/response/presentation/response_screen.dart';

void main() {
  testWidgets('Response lists incident playbooks and explains its boundaries',
      (tester) async {
    tester.view.physicalSize = const Size(900, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: ResponseScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Know your next step.'), findsOneWidget);
    expect(find.text('An account may be compromised'), findsOneWidget);
    expect(find.text('A suspicious or unauthorised payment'), findsOneWidget);
    expect(find.text('A phone, laptop or device is lost'), findsOneWidget);
    expect(find.text('A device may have malware'), findsOneWidget);
    expect(find.text('Personal or identity information was exposed'), findsOneWidget);
    expect(find.textContaining('does not detect incidents'), findsOneWidget);
  });

  testWidgets('expanding an incident shows priority, steps and evidence guidance',
      (tester) async {
    tester.view.physicalSize = const Size(900, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: ResponseScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('An account may be compromised'));
    await tester.pumpAndSettle();

    expect(find.text('FIRST PRIORITY'), findsOneWidget);
    expect(find.text('STEP-BY-STEP'), findsOneWidget);
    expect(find.text('PRESERVE USEFUL INFORMATION'), findsOneWidget);
    expect(find.text('AVOID'), findsOneWidget);
    expect(find.text('IMPORTANT LIMIT'), findsOneWidget);

    final semantics = tester.ensureSemantics();
    addTearDown(semantics.dispose);
    expect(
      tester.getSemantics(find.text('FIRST PRIORITY')).flagsCollection.isHeader,
      isTrue,
    );
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/features/response/presentation/response_screen.dart';

void main() {
  testWidgets(
    'Response remains readable across narrow, tablet and desktop widths',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      for (final width in [
        280.0,
        320.0,
        360.0,
        390.0,
        430.0,
        600.0,
        760.0,
        1024.0,
        1920.0,
      ]) {
        tester.view.physicalSize = Size(width, 900);
        await tester.pumpWidget(
          MaterialApp(
            key: ValueKey('response-$width'),
            home: const ResponseScreen(),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Know your next step.'), findsOneWidget,
            reason: 'heading should remain available at width $width');
        expect(find.byType(ListView), findsOneWidget);
        expect(
          tester.getSize(find.byType(ListView)).width,
          lessThanOrEqualTo(760),
          reason: 'Response content should remain readable at width $width',
        );
        expect(find.text('An account may be compromised'), findsOneWidget);
        expect(find.textContaining('does not detect incidents'), findsOneWidget);
        expect(tester.takeException(), isNull,
            reason: 'Response layout overflow at width $width');
      }
    },
  );

  testWidgets('all incident playbooks expand without narrow-screen overflow',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 900);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: ResponseScreen()));
    await tester.pumpAndSettle();

    const playbooks = [
      'An account may be compromised',
      'A suspicious or unauthorised payment',
      'A phone, laptop or device is lost',
      'A device may have malware',
      'Personal or identity information was exposed',
    ];

    for (final title in playbooks) {
      final tile = find.text(title);
      await tester.ensureVisible(tile);
      await tester.tap(tile);
      await tester.pumpAndSettle();

      expect(find.text('FIRST PRIORITY'), findsOneWidget,
          reason: 'priority guidance should appear for $title');
      expect(find.text('STEP-BY-STEP'), findsOneWidget,
          reason: 'ordered guidance should appear for $title');
      expect(find.text('PRESERVE USEFUL INFORMATION'), findsOneWidget,
          reason: 'evidence guidance should appear for $title');
      expect(tester.takeException(), isNull,
          reason: 'expanded playbook overflow for $title');

      await tester.tap(tile);
      await tester.pumpAndSettle();
    }
  });

  testWidgets('Response supports RTL and 200 percent text scaling',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 900);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: ResponseScreen(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final heading = find.text('Know your next step.');
    expect(heading, findsOneWidget);
    expect(Directionality.of(tester.element(heading)), TextDirection.rtl);
    expect(MediaQuery.textScalerOf(tester.element(heading)).scale(10), 20);

    final firstPlaybook = find.text('An account may be compromised');
    await tester.ensureVisible(firstPlaybook);
    await tester.tap(firstPlaybook);
    await tester.pumpAndSettle();

    expect(find.text('FIRST PRIORITY'), findsOneWidget);
    expect(find.text('STEP-BY-STEP'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

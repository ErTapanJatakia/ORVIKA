import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/features/link_check/presentation/link_check_screen.dart';

void main() {
  testWidgets('Link Check analyses an address and explains its local-only scope',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 900);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(home: LinkCheckScreen()),
    );

    await tester.enterText(find.byType(TextField), 'http://example.com');
    await tester.tap(find.text('Analyse address'));
    await tester.pumpAndSettle();

    expect(find.text('Analysis findings'), findsOneWidget);
    expect(find.text('Unencrypted connection'), findsOneWidget);
    expect(find.textContaining('No network request or reputation lookup'),
        findsOneWidget);
    expect(find.textContaining('does not open the URL'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Link Check remains usable across narrow, tablet and desktop widths',
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
          key: ValueKey('link-check-$width'),
          home: const LinkCheckScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Inspect before you connect.'), findsOneWidget,
          reason: 'heading should remain available at width $width');
      expect(find.byType(TextField), findsOneWidget,
          reason: 'URL input should remain available at width $width');
      expect(find.text('Analyse address'), findsOneWidget,
          reason: 'analysis action should remain available at width $width');
      expect(tester.takeException(), isNull,
          reason: 'Link Check layout overflow at width $width');

      await tester.enterText(find.byType(TextField), 'https://example.com');
      await tester.tap(find.text('Analyse address'));
      await tester.pumpAndSettle();

      expect(find.text('Analysis findings'), findsOneWidget,
          reason: 'result should render at width $width');
      expect(tester.takeException(), isNull,
          reason: 'Link Check result overflow at width $width');
    }
  });
}

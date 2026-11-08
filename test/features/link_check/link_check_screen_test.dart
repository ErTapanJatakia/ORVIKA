import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/main.dart';
import 'package:orvika/features/link_check/presentation/link_check_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

String _linkAction(String language) =>
    language == 'ar' ? 'تحقّق من العنوان' : 'Analyse address';

Future<void> _openLinkCheck(
  WidgetTester tester, {
  String language = 'en',
  double textScale = 1,
}) async {
  SharedPreferences.setMockInitialValues({
    'onboarding.completed.v1': true,
    'appearance.language': language,
    'accessibility.textScale': textScale,
  });

  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(320, 900);
  await tester.pumpWidget(const OrvikaApp());
  await tester.pumpAndSettle();

  final moduleFinder = find.text(
    language == 'ar' ? 'فحص الروابط' : 'Link Check',
  );
  await tester.dragUntilVisible(
    moduleFinder,
    find.byType(CustomScrollView),
    const Offset(0, -300),
  );
  await tester.pumpAndSettle();

  final moduleRect = tester.getRect(moduleFinder);
  expect(
    (Offset.zero & tester.view.physicalSize).overlaps(moduleRect),
    isTrue,
    reason: 'Link Check dashboard entry must be inside the viewport before tapping',
  );
  await tester.tap(moduleFinder);
  await tester.pumpAndSettle();

  expect(
    find.text(
      language == 'ar'
          ? 'تحقّق قبل الاتصال.'
          : 'Inspect before you connect.',
    ),
    findsOneWidget,
  );
}

Future<void> _revealLinkCheckControl(
  WidgetTester tester,
  Finder control,
) async {
  final featureScrollable = find.descendant(
    of: find.byType(LinkCheckScreen),
    matching: find.byType(Scrollable),
  ).first;

  await tester.scrollUntilVisible(
    control,
    200,
    scrollable: featureScrollable,
  );
  await tester.pumpAndSettle();
}

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
    await tester.tap(find.text(_linkAction('ar')));
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
      expect(
        tester.getSize(find.byType(ListView)).width,
        lessThanOrEqualTo(760),
        reason: 'content width should remain readable at width $width',
      );
      expect(
        tester.widget<TextField>(find.byType(TextField)).maxLength,
        2048,
        reason: 'the input should enforce the analyzer length limit',
      );
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

  testWidgets('Link Check supports RTL independently of enlarged text',
      (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await _openLinkCheck(tester, language: 'ar');

    final context = tester.element(find.text('تحقّق قبل الاتصال.'));
    expect(Directionality.of(context), TextDirection.rtl);
    expect(MediaQuery.textScalerOf(context).scale(10), 10);
    await _revealLinkCheckControl(tester, find.byType(TextField));
    expect(find.byType(TextField), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'https://example.com');
    await _revealLinkCheckControl(tester, find.text(_linkAction('ar')));
    await tester.tap(find.text('Analyse address'));
    await tester.pumpAndSettle();
    expect(find.text('Analysis findings'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Link Check supports 200 percent text scaling independently of RTL',
      (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await _openLinkCheck(tester, textScale: 2);

    final context = tester.element(find.text('Inspect before you connect.'));
    expect(Directionality.of(context), TextDirection.ltr);
    expect(MediaQuery.textScalerOf(context).scale(10), 20);
    await _revealLinkCheckControl(tester, find.byType(TextField));
    expect(find.byType(TextField), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'https://example.com');
    await _revealLinkCheckControl(tester, find.text(_linkAction('en')));
    await tester.tap(find.text(_linkAction('en')));
    await tester.pumpAndSettle();
    expect(find.text('Analysis findings'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Link Check remains usable at 200 percent text scaling in RTL',
      (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await _openLinkCheck(tester, language: 'ar', textScale: 2);

    final context = tester.element(find.text('تحقّق قبل الاتصال.'));
    expect(Directionality.of(context), TextDirection.rtl);
    expect(MediaQuery.textScalerOf(context).scale(10), 20);
    await _revealLinkCheckControl(tester, find.byType(TextField));
    expect(find.byType(TextField), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'https://example.com');
    await _revealLinkCheckControl(tester, find.text(_linkAction('ar')));
    expect(find.text(_linkAction('ar')), findsOneWidget);
    await tester.tap(find.text(_linkAction('ar')));
    await tester.pumpAndSettle();

    expect(find.text('Analysis findings'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/features/academy/presentation/academy_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('Academy content remains readable across phone, tablet and desktop widths',
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
          key: ValueKey('academy-$width'),
          home: const AcademyScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Build safer digital habits.'), findsOneWidget);
      expect(find.text('0 of 8 lessons completed'), findsOneWidget);
      expect(find.text('Verify the sender, not the display name'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      expect(
        tester.getSize(find.byType(ListView)).width,
        lessThanOrEqualTo(760),
        reason: 'Academy content should be constrained at width $width',
      );
      expect(tester.takeException(), isNull,
          reason: 'Academy layout overflow at width $width');
    }
  });

  testWidgets('Academy narrow-screen answer handler updates completion and local progress',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(280, 900);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: AcademyScreen()));
    await tester.pumpAndSettle();

    final correctAnswer = find.text(
      'Use the bank app or a known official contact route independently',
    );
    final answerButton = find.ancestor(
      of: correctAnswer,
      matching: find.byType(OutlinedButton),
    );
    expect(answerButton, findsOneWidget);

    final button = tester.widget<OutlinedButton>(answerButton);
    expect(button.onPressed, isNotNull,
        reason: 'The correct answer must be enabled at 280px.');

    // Invoke the real button callback directly to separate application-state
    // handling from pointer hit-testing/scroll geometry.
    button.onPressed!();
    await tester.pumpAndSettle();

    expect(find.text('1 of 8 lessons completed'), findsOneWidget);
    expect(
      find.textContaining('Use a contact route you obtain independently.'),
      findsOneWidget,
    );
    final preferences = await SharedPreferences.getInstance();
    expect(
      preferences.getStringList('academy.completed.v1'),
      contains('verify_sender'),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Academy narrow-screen answer can be activated by a real pointer tap',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(280, 900);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: AcademyScreen()));
    await tester.pumpAndSettle();

    final correctAnswer = find.text(
      'Use the bank app or a known official contact route independently',
    );
    final answerButton = find.ancestor(
      of: correctAnswer,
      matching: find.byType(OutlinedButton),
    );
    expect(answerButton, findsOneWidget);
    expect(tester.widget<OutlinedButton>(answerButton).onPressed, isNotNull);

    // Bring the actual button into the viewport before checking its hit target.
    await tester.ensureVisible(answerButton);
    await tester.pumpAndSettle();

    final buttonRect = tester.getRect(answerButton);
    final viewportRect = tester.getRect(find.byType(Scaffold));
    expect(
      buttonRect.overlaps(viewportRect),
      isTrue,
      reason: 'The answer button must be inside the visible Academy viewport.',
    );
    expect(
      answerButton.hitTestable(),
      findsOneWidget,
      reason: 'The answer button must receive pointer events at 280px.',
    );

    // Tap the centre of the rendered button, not the text finder.
    await tester.tapAt(buttonRect.center);
    await tester.pumpAndSettle();

    expect(find.text('1 of 8 lessons completed'), findsOneWidget);
    expect(
      find.textContaining('Use a contact route you obtain independently.'),
      findsOneWidget,
    );
    final preferences = await SharedPreferences.getInstance();
    expect(
      preferences.getStringList('academy.completed.v1'),
      contains('verify_sender'),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Academy supports RTL and 200 percent text scaling',
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
            child: AcademyScreen(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final heading = find.text('Build safer digital habits.');
    expect(heading, findsOneWidget);
    expect(Directionality.of(tester.element(heading)), TextDirection.rtl);
    expect(MediaQuery.textScalerOf(tester.element(heading)).scale(10), 20);
    expect(tester.takeException(), isNull);
  });
}

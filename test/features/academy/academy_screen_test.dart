import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/features/academy/presentation/academy_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Academy displays lessons and completes a lesson after a correct answer', (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(900, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: AcademyScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Build safer digital habits.'), findsOneWidget);
    expect(find.text('0 of 8 lessons completed'), findsOneWidget);
    expect(find.text('Verify the sender, not the display name'), findsOneWidget);

    await tester.tap(find.text('Use the bank app or a known official contact route independently'));
    await tester.pumpAndSettle();

    expect(find.text('1 of 8 lessons completed'), findsOneWidget);
    expect(find.textContaining('Use a contact route you obtain independently.'), findsOneWidget);

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getStringList('academy.completed.v1'), contains('verify_sender'));
  });

  testWidgets('incorrect answer does not mark a lesson complete', (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(900, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: AcademyScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Reply and ask the sender to confirm'));
    await tester.pumpAndSettle();

    expect(find.text('0 of 8 lessons completed'), findsOneWidget);
    expect(find.text('Not quite. Review the key points and try again.'), findsOneWidget);
  });

  testWidgets('Academy restores locally saved completion progress', (tester) async {
    SharedPreferences.setMockInitialValues({
      'academy.completed.v1': <String>['verify_sender', 'phishing_links'],
    });
    tester.view.physicalSize = const Size(900, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: AcademyScreen()));
    await tester.pumpAndSettle();

    expect(find.text('2 of 8 lessons completed'), findsOneWidget);
  });
}

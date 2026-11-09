import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('dashboard module cards use readable title, description and status typography',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'onboarding.completed.v1': true,
      'appearance.language': 'en',
    });
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);

    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();

    final description = find.text(
      'Inspect website addresses before you open them.',
    );
    final scrollable = find.descendant(
      of: find.byType(CustomScrollView),
      matching: find.byType(Scrollable),
    ).first;
    await tester.scrollUntilVisible(
      description,
      180,
      scrollable: scrollable,
      maxScrolls: 20,
    );
    await tester.pumpAndSettle();

    final descriptionText = tester.widget<Text>(description);
    expect(descriptionText.style?.fontSize, 13);
    expect(descriptionText.style?.height, 1.45);

    final titleText = tester.widget<Text>(find.text('Link Check'));
    expect(titleText.style?.fontSize, 16);

    final statusText = tester.widget<Text>(find.text('AVAILABLE').first);
    expect(statusText.style?.fontSize, 10);
    expect(statusText.style?.fontWeight, FontWeight.w900);
    expect(tester.takeException(), isNull);

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}

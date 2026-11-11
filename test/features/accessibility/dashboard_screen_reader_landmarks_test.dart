import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets(
    'dashboard hero and toolkit are exposed as navigable screen-reader headings',
    (tester) async {
      final semantics = tester.ensureSemantics();
      addTearDown(semantics.dispose);
      SharedPreferences.setMockInitialValues({
        'onboarding.completed.v1': true,
        'appearance.language': 'en',
      });

      await tester.pumpWidget(const OrvikaApp());
      await tester.pumpAndSettle();

      final heroHeading = find.text('Check before\nyou trust.');
      expect(heroHeading, findsOneWidget);
      expect(
        tester.getSemantics(heroHeading).flagsCollection.isHeader,
        isTrue,
        reason: 'The main dashboard message should be reachable by heading navigation.',
      );

      final toolkitHeading = find.text('Your safety toolkit');
      expect(
        tester.getSemantics(toolkitHeading).flagsCollection.isHeader,
        isTrue,
        reason: 'The module collection should remain a separate heading landmark.',
      );

      final linkCheck = find.bySemanticsLabel(
        RegExp(r'^Link Check'),
      );
      expect(linkCheck, findsOneWidget);
      final linkSemantics = tester.getSemantics(linkCheck);
      expect(linkSemantics.flagsCollection.isButton, isTrue);
      expect(linkSemantics.flagsCollection.isEnabled, isTrue);
      expect(tester.takeException(), isNull);
    },
  );
}

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
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

      // The module card deliberately excludes its visual descendants from the
      // semantics tree and exposes one labelled Semantics ancestor instead.
      // Locate that ancestor through the widget tree, then inspect its actual
      // semantics node rather than relying on a label finder that cannot see
      // descendants hidden by ExcludeSemantics.
      final linkCheckTitle = find.text('Link Check');
      expect(linkCheckTitle, findsOneWidget);
      final linkCheckSemantics = find.ancestor(
        of: linkCheckTitle,
        matching: find.byType(Semantics),
      );
      expect(linkCheckSemantics, findsWidgets);
      final linkSemantics = tester.getSemantics(linkCheckSemantics.first);
      expect(linkSemantics.flagsCollection.isButton, isTrue);
      expect(linkSemantics.flagsCollection.isEnabled, isTrue);
      expect(tester.takeException(), isNull);
    },
  );
}

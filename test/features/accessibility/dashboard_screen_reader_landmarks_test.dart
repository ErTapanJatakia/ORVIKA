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

      // The dashboard grid is lazily built inside its scroll view. Bring the
      // Link Check card into the viewport before inspecting its semantics.
      final dashboardScrollable = find.descendant(
        of: find.byType(CustomScrollView),
        matching: find.byType(Scrollable),
      ).first;
      final linkCheckTitle = find.text('Link Check');
      await tester.scrollUntilVisible(
        linkCheckTitle,
        240,
        scrollable: dashboardScrollable,
      );
      await tester.pumpAndSettle();
      expect(linkCheckTitle, findsOneWidget);

      // The card excludes its visual descendants from the semantics tree and
      // exposes one labelled Semantics ancestor instead.
      final linkCheckSemantics = find.ancestor(
        of: linkCheckTitle,
        matching: find.byType(Semantics),
      );
      expect(linkCheckSemantics, findsWidgets);
      final linkSemanticsWidget = tester.widget<Semantics>(linkCheckSemantics.first);
      expect(linkSemanticsWidget.properties.button, isTrue);
      expect(
        linkSemanticsWidget.properties.enabled,
        isTrue,
        reason: 'The enabled module should expose its enabled state to assistive technology.',
      );
      expect(tester.takeException(), isNull);
    },
  );
}

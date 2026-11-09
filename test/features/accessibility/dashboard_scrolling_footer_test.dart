import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets(
    'dashboard scrolling and footer remain usable across mobile, tablet and desktop widths',
    (tester) async {
      SharedPreferences.setMockInitialValues({
        'onboarding.completed.v1': true,
        'appearance.language': 'en',
      });
      tester.view.devicePixelRatio = 1;

      for (final viewport in <Size>[
        const Size(320, 720),
        const Size(390, 844),
        const Size(768, 1024),
        const Size(1280, 900),
      ]) {
        tester.view.physicalSize = viewport;
        await tester.pumpWidget(
          OrvikaApp(key: ValueKey('dashboard-footer-${viewport.width}')),
        );
        await tester.pumpAndSettle();

        final dashboardFinder = find.byType(CustomScrollView);
        expect(dashboardFinder, findsOneWidget);
        final dashboard = tester.widget<CustomScrollView>(dashboardFinder);
        expect(
          dashboard.keyboardDismissBehavior,
          ScrollViewKeyboardDismissBehavior.onDrag,
        );
        expect(dashboard.scrollBehavior, isNotNull);

        final scrollable = find.descendant(
          of: dashboardFinder,
          matching: find.byType(Scrollable),
        ).first;
        final footer = find.byKey(const ValueKey('dashboard-footer'));
        await tester.scrollUntilVisible(
          footer,
          220,
          scrollable: scrollable,
          maxScrolls: 35,
        );
        await tester.pumpAndSettle();

        expect(footer, findsOneWidget);
        expect(
          tester.getSize(footer).width,
          lessThanOrEqualTo(760),
          reason: 'Footer should remain within its readable maximum width.',
        );
        final footerRect = tester.getRect(footer);
        expect(footerRect.left, greaterThanOrEqualTo(0));
        expect(footerRect.right, lessThanOrEqualTo(viewport.width));
        expect(
          find.text('SEE THE RISK  •  VERIFY THE SIGNAL  •  STAY IN CONTROL'),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull, reason: 'viewport: $viewport');
      }

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    },
  );
}

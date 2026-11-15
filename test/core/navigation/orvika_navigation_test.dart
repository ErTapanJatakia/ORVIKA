import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/core/navigation/orvika_navigation.dart';
import 'package:orvika/features/academy/presentation/academy_screen.dart';
import 'package:orvika/features/intelligence/presentation/intelligence_screen.dart';
import 'package:orvika/features/link_check/presentation/link_check_screen.dart';
import 'package:orvika/features/message_check/presentation/message_check_screen.dart';
import 'package:orvika/features/privacy/presentation/privacy_screen.dart';
import 'package:orvika/features/qr_check/presentation/qr_check_screen.dart';
import 'package:orvika/features/response/presentation/response_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _RouteRecorder extends NavigatorObserver {
  Route<dynamic>? lastPushed;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    lastPushed = route;
    super.didPush(route, previousRoute);
  }
}

void main() {
  const destinations = <({String module, String route, Type screen})>[
    (module: 'Link Check', route: '/link-check', screen: LinkCheckScreen),
    (module: 'QR Check', route: '/qr-check', screen: QrCheckScreen),
    (module: 'Message Check', route: '/message-check', screen: MessageCheckScreen),
    (module: 'Intelligence', route: '/intelligence', screen: IntelligenceScreen),
    (module: 'Privacy', route: '/privacy', screen: PrivacyScreen),
    (module: 'Academy', route: '/academy', screen: AcademyScreen),
    (module: 'Response', route: '/response', screen: ResponseScreen),
  ];

  test('module registry exposes stable internal route identifiers', () {
    for (final destination in destinations) {
      expect(OrvikaNavigation.hasDestination(destination.module), isTrue);
      expect(OrvikaNavigation.routeNameForModule(destination.module), destination.route);
      expect(OrvikaNavigation.screenForModule(destination.module), isA<Widget>());
    }

    expect(OrvikaNavigation.hasDestination('Sentinel'), isFalse);
    expect(OrvikaNavigation.routeNameForModule('Sentinel'), isNull);
    expect(OrvikaNavigation.screenForModule('Unknown module'), isNull);
  });

  testWidgets('each module opens its screen and returns through system navigation',
      (tester) async {
    for (final destination in destinations) {
      SharedPreferences.setMockInitialValues({});
      final observer = _RouteRecorder();

      await tester.pumpWidget(MaterialApp(
        key: ValueKey(destination.module),
        navigatorObservers: [observer],
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () =>
                    OrvikaNavigation.openModule(context, destination.module),
                child: Text('Open ${destination.module}'),
              ),
            ),
          ),
        ),
      ));

      await tester.tap(find.text('Open ${destination.module}'));
      await tester.pumpAndSettle();

      expect(observer.lastPushed?.settings.name, destination.route);
      expect(find.byType(destination.screen), findsOneWidget);
      expect(find.byTooltip('Back'), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('Open ${destination.module}'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('overview and unknown modules do not push an empty route',
      (tester) async {
    var opened = true;
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: ElevatedButton(
            onPressed: () => opened =
                OrvikaNavigation.openModule(context, 'Sentinel'),
            child: const Text('Open overview'),
          ),
        ),
      ),
    ));

    await tester.tap(find.text('Open overview'));
    await tester.pumpAndSettle();

    expect(opened, isFalse);
    expect(find.text('Open overview'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/core/localization/orvika_language.dart';
import 'package:orvika/features/academy/presentation/academy_screen.dart';
import 'package:orvika/features/intelligence/presentation/intelligence_screen.dart';
import 'package:orvika/features/link_check/presentation/link_check_screen.dart';
import 'package:orvika/features/message_check/presentation/message_check_screen.dart';
import 'package:orvika/features/privacy/presentation/privacy_screen.dart';
import 'package:orvika/features/qr_check/presentation/qr_check_screen.dart';
import 'package:orvika/features/response/presentation/response_screen.dart';
import 'package:orvika/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _expectNoOverflow(
  WidgetTester tester,
  Size viewport,
  String screen,
  Widget app,
) async {
  tester.view.physicalSize = viewport;
  await tester.pumpWidget(app);
  await tester.pumpAndSettle();
  expect(
    find.byType(Scaffold),
    findsWidgets,
    reason: '$screen should render a scaffold at ${viewport.width}x${viewport.height}',
  );
  expect(
    tester.takeException(),
    isNull,
    reason: '$screen overflowed or threw at ${viewport.width}x${viewport.height}',
  );
}

void main() {
  for (final viewport in const <Size>[
    Size(768, 1024), // Tablet portrait.
    Size(1024, 768), // Tablet landscape.
  ]) {
    testWidgets(
      'all primary app screens remain usable at ${viewport.width.toInt()}x${viewport.height.toInt()} tablet viewport',
      (tester) async {
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        SharedPreferences.setMockInitialValues({
          'onboarding.completed.v1': true,
          'appearance.language': 'en',
        });
        await _expectNoOverflow(tester, viewport, 'Dashboard', const OrvikaApp());

        SharedPreferences.setMockInitialValues({});
        await _expectNoOverflow(
          tester, viewport, 'Language selection',
          MaterialApp(home: LanguageSelectionScreen(
            selectedLanguage: OrvikaLanguage.english,
            selectedCatalogue: 'russia',
            onLanguageChanged: (_) {},
            onCatalogueChanged: (_) {},
          )),
        );

        await _expectNoOverflow(
          tester, viewport, 'Onboarding',
          MaterialApp(home: OrvikaOnboardingScreen(
            onCompleted: () {},
            language: OrvikaLanguage.english,
            selectedCatalogue: 'russia',
            onCatalogueChanged: (_) {},
          )),
        );

        await _expectNoOverflow(
          tester, viewport, 'Appearance settings',
          MaterialApp(home: AppearanceSettingsScreen(
            selectedTheme: OrvikaTheme.obsidian,
            onThemeChanged: (_) {},
            selectedLanguage: OrvikaLanguage.english,
            selectedCatalogue: 'russia',
            onLanguageChanged: (_) {},
            onCatalogueChanged: (_) {},
            textScale: 1,
            onTextScaleChanged: (_) {},
            boldText: false,
            onBoldTextChanged: (_) {},
            reduceMotion: false,
            onReduceMotionChanged: (_) {},
          )),
        );

        final featureScreens = <(String, Widget)>[
          ('Academy', const AcademyScreen()),
          ('Intelligence', const IntelligenceScreen()),
          ('Link Check', const LinkCheckScreen()),
          ('Message Check', const MessageCheckScreen()),
          ('Privacy', const PrivacyScreen()),
          ('QR Check', const QrCheckScreen()),
          ('Response', const ResponseScreen()),
        ];

        for (final (name, screen) in featureScreens) {
          SharedPreferences.setMockInitialValues({});
          await _expectNoOverflow(
            tester,
            viewport,
            name,
            MaterialApp(key: ValueKey('$name-${viewport.width}x${viewport.height}'), home: screen),
          );
        }
      },
    );
  }
}

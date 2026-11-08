import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:orvika/core/localization/orvika_language.dart';
import 'package:orvika/core/localization/orvika_localizations.dart';
import 'package:orvika/features/link_check/presentation/link_check_screen.dart';
import 'package:orvika/features/qr_check/presentation/qr_check_screen.dart';
import 'package:orvika/features/message_check/presentation/message_check_screen.dart';
import 'package:orvika/features/intelligence/presentation/intelligence_screen.dart';
import 'package:orvika/features/privacy/presentation/privacy_screen.dart';

Widget _localizedApp(String languageCode, Widget child) {
  return MaterialApp(
    home: OrvikaLanguageScope(
      language: OrvikaLanguage.fromCode(languageCode),
      child: child,
    ),
  );
}

void main() {
  testWidgets('Link Check renders Russian interface strings', (tester) async {
    await tester.pumpWidget(_localizedApp('ru', const LinkCheckScreen()));
    expect(find.text('Проверьте, прежде чем подключаться.'), findsOneWidget);
    expect(find.text('Адрес сайта'), findsOneWidget);
    await tester.ensureVisible(find.text('Проверить адрес'));
    expect(find.text('Проверить адрес'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('QR Check renders Hindi interface strings', (tester) async {
    await tester.pumpWidget(_localizedApp('hi', const QrCheckScreen()));
    expect(find.text('स्कैन करने से पहले जाँचें।'), findsOneWidget);
    expect(find.text('डिकोड की गई QR सामग्री'), findsOneWidget);
    await tester.ensureVisible(find.text('QR सामग्री की जाँच करें'));
    expect(find.text('QR सामग्री की जाँच करें'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Message Check renders Russian interface strings', (tester) async {
    await tester.pumpWidget(_localizedApp('ru', const MessageCheckScreen()));
    expect(find.text('Остановитесь. Проверьте. Затем отвечайте.'), findsOneWidget);
    expect(find.text('Текст сообщения'), findsOneWidget);
    await tester.ensureVisible(find.text('Проверить сообщение'));
    expect(find.text('Проверить сообщение'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });


  testWidgets('Intelligence renders Russian interface strings', (tester) async {
    await tester.pumpWidget(_localizedApp('ru', const IntelligenceScreen()));
    expect(find.text('Понимайте сигналы.'), findsOneWidget);
    expect(find.text('Поиск индикаторов'), findsOneWidget);
    expect(find.text('АВТОНОМНЫЙ СПРАВОЧНИК'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Privacy renders Hindi interface strings', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(_localizedApp('hi', const PrivacyScreen()));
    await tester.pumpAndSettle();
    expect(find.text('अपनी गोपनीयता पर नियंत्रण रखें।'), findsOneWidget);
    expect(find.text('खाते'), findsOneWidget);
    expect(find.text('मैंने इस अभ्यास की समीक्षा कर ली है'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('untranslated language keeps the English checker fallback',
      (tester) async {
    await tester.pumpWidget(_localizedApp('ce', const LinkCheckScreen()));
    expect(find.text('Inspect before you connect.'), findsOneWidget);
    expect(find.text('Website address'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

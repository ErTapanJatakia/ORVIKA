import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:orvika/core/localization/orvika_language.dart';
import 'package:orvika/core/localization/orvika_localizations.dart';
import 'package:orvika/features/academy/presentation/academy_screen.dart';
import 'package:orvika/features/privacy/presentation/privacy_screen.dart';
import 'package:orvika/features/response/presentation/response_screen.dart';
import 'package:orvika/features/intelligence/presentation/intelligence_screen.dart';
import 'package:orvika/features/link_check/presentation/link_check_screen.dart';
import 'package:orvika/features/message_check/presentation/message_check_screen.dart';
import 'package:orvika/features/qr_check/presentation/qr_check_screen.dart';

Widget russianApp(Widget child) => MaterialApp(
  home: OrvikaLanguageScope(language: OrvikaLanguage.fromCode('ru'), child: child),
);

void main() {
  testWidgets('Russian feature screens render localized titles and content', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(russianApp(const AcademyScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Обучение'), findsOneWidget);
    expect(find.text('Формируйте более безопасные цифровые привычки.'), findsOneWidget);
    expect(find.text('Проверяйте отправителя, а не отображаемое имя'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(russianApp(const PrivacyScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Конфиденциальность'), findsOneWidget);
    expect(find.text('Возьмите конфиденциальность под контроль.'), findsOneWidget);
    expect(find.text('Используйте уникальные пароли для важных аккаунтов'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(russianApp(const ResponseScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Реагирование'), findsOneWidget);
    expect(find.text('Знайте, что делать дальше.'), findsOneWidget);
    expect(find.text('Возможно, аккаунт скомпрометирован'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(russianApp(const IntelligenceScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Аналитика'), findsOneWidget);
    expect(find.text('Понимайте сигналы.'), findsOneWidget);
    expect(find.text('Незашифрованное HTTP-соединение'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'незашифрованное');
    await tester.pumpAndSettle();
    expect(find.text('Незашифрованное HTTP-соединение'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(russianApp(const LinkCheckScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Проверка ссылок'), findsOneWidget);
    expect(find.text('Проверьте, прежде чем подключаться.'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(russianApp(const MessageCheckScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Проверка сообщений'), findsOneWidget);
    expect(find.text('Остановитесь. Проверьте. Затем отвечайте.'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(russianApp(const QrCheckScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Проверка QR'), findsOneWidget);
    expect(find.text('Проверьте, прежде чем сканировать.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

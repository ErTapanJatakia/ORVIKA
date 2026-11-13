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

Widget arabicApp(Widget child) => MaterialApp(
  home: Directionality(
    textDirection: TextDirection.rtl,
    child: OrvikaLanguageScope(language: OrvikaLanguage.fromCode('ar'), child: child),
  ),
);

void main() {
  testWidgets('Arabic feature screens render translated content in RTL at 320px and 200% text', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.binding.setSurfaceSize(const Size(320, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final screens = <(Widget, String, String)>[
      (const AcademyScreen(), 'الأكاديمية', 'تحقّق من المرسل، لا من الاسم الظاهر'),
      (const PrivacyScreen(), 'الخصوصية', 'استخدم كلمات مرور فريدة للحسابات المهمة'),
      (const ResponseScreen(), 'الاستجابة', 'اشتباه في اختراق الحساب'),
      (const IntelligenceScreen(), 'المعلومات الاستخباراتية', 'اتصال HTTP غير مشفّر'),
      (const LinkCheckScreen(), 'فحص الروابط', 'تحقّق قبل فتح الرابط.'),
      (const MessageCheckScreen(), 'فحص الرسائل', 'توقّف. تحقّق. ثم أجب.'),
      (const QrCheckScreen(), 'فحص QR', 'تحقّق قبل المسح.'),
    ];

    for (final (screen, title, content) in screens) {
      await tester.pumpWidget(MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2.0)),
        child: arabicApp(screen),
      ));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text(title), findsWidgets,
          reason: 'Arabic app-bar title missing for ${screen.runtimeType}');
      expect(find.text(content), findsWidgets,
          reason: 'Arabic feature content missing for ${screen.runtimeType}');
      expect(tester.takeException(), isNull,
          reason: 'Arabic RTL layout overflowed at 320px / 200% for ${screen.runtimeType}');
    }
  });

  testWidgets('Arabic checker labels and camera/image controls are translated', (tester) async {
    await tester.pumpWidget(arabicApp(const QrCheckScreen()));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('مسح رمز QR بالكاميرا'), findsOneWidget);
    expect(find.text('فحص رمز QR من صورة'), findsOneWidget);
    expect(find.text('تحقّق قبل المسح.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

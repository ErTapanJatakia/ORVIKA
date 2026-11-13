import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:orvika/core/localization/orvika_language.dart';
import 'package:orvika/core/localization/orvika_localizations.dart';
import 'package:orvika/features/academy/presentation/academy_screen.dart';
import 'package:orvika/features/intelligence/presentation/intelligence_screen.dart';
import 'package:orvika/features/link_check/presentation/link_check_screen.dart';
import 'package:orvika/features/message_check/presentation/message_check_screen.dart';
import 'package:orvika/features/privacy/presentation/privacy_screen.dart';
import 'package:orvika/features/qr_check/presentation/qr_check_screen.dart';
import 'package:orvika/features/response/presentation/response_screen.dart';

Widget mandarinApp(Widget child) => MaterialApp(
  builder: (context, content) => MediaQuery(
    data: MediaQuery.of(context).copyWith(
      textScaler: const TextScaler.linear(2.0),
    ),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: content ?? const SizedBox.shrink(),
    ),
  ),
  home: OrvikaLanguageScope(
    language: OrvikaLanguage.fromCode('zh'),
    child: child,
  ),
);

void main() {
  testWidgets(
    'Simplified Chinese feature screens render translated headings at 320px and 200% text',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      await tester.binding.setSurfaceSize(const Size(320, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final screens = <(Widget, String, String)>[
        (const AcademyScreen(), '安全学院', '养成更安全的数字习惯。'),
        (const PrivacyScreen(), '隐私保护', '掌握自己的隐私。'),
        (const ResponseScreen(), '事件响应', '了解接下来该怎么做。'),
        (const IntelligenceScreen(), '风险知识库', '读懂风险信号。'),
        (const LinkCheckScreen(), '链接检查', '连接之前，先检查。'),
        (const MessageCheckScreen(), '消息检查', '先暂停，核查后再回复。'),
        (const QrCheckScreen(), '二维码检查', '扫描之前，先检查。'),
      ];

      for (final (screen, title, heading) in screens) {
        await tester.pumpWidget(mandarinApp(screen));
        await tester.pumpAndSettle();
        expect(find.text(title), findsWidgets,
            reason: 'Simplified Chinese app-bar title missing for ${screen.runtimeType}');
        expect(find.text(heading), findsWidgets,
            reason: 'Simplified Chinese heading missing for ${screen.runtimeType}');
        expect(tester.takeException(), isNull,
            reason: 'Layout failed at 320px / 200% for ${screen.runtimeType}');
      }
    },
  );
}

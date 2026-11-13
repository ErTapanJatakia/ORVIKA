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

Widget app(String code, Widget child) => MaterialApp(
  home: OrvikaLanguageScope(language: OrvikaLanguage.fromCode(code), child: child),
);

void main() {
  testWidgets('Portugal Portuguese long labels render at narrow width and 200% text scale', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    Widget scaledApp(Widget child) => MaterialApp(
      builder: (context, content) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: const TextScaler.linear(2.0),
        ),
        child: content!,
      ),
      home: OrvikaLanguageScope(
        language: OrvikaLanguage.fromCode('pt-PT'),
        child: child,
      ),
    );

    for (final screen in <Widget>[
      const AcademyScreen(),
      const PrivacyScreen(),
      const ResponseScreen(),
      const IntelligenceScreen(),
      const LinkCheckScreen(),
      const MessageCheckScreen(),
      const QrCheckScreen(),
    ]) {
      await tester.pumpWidget(scaledApp(screen));
      // These screens may contain intentionally repeating animations; one
      // deterministic frame is sufficient to surface layout/paint exceptions.
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.takeException(), isNull,
          reason: 'pt-PT layout overflowed at 320px / 200% text scale for ${screen.runtimeType}');
    }
  });

  testWidgets('Spanish feature screens render translated headings and content', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(app('es', const AcademyScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Aprende a protegerte'), findsOneWidget);
    expect(find.text('Verifica al remitente, no al nombre mostrado'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(app('es', const PrivacyScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Revisión de privacidad'), findsOneWidget);
    expect(find.text('Utiliza contraseñas únicas para tus cuentas importantes'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(app('es', const ResponseScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Guías de respuesta ante incidentes'), findsOneWidget);
    expect(find.text('Una cuenta podría estar comprometida'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(app('es', const IntelligenceScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Guía de señales de riesgo digital'), findsOneWidget);
    expect(find.text('HTTP sin cifrar'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Brazilian Portuguese feature screens render translated headings and content', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(app('pt', const AcademyScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Aprenda a proteger-se'), findsOneWidget);
    expect(find.text('Verifique o remetente, não o nome exibido'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(app('pt', const PrivacyScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Revisão de privacidade'), findsOneWidget);
    expect(find.text('Use senhas exclusivas nas contas importantes'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(app('pt', const ResponseScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Guias de resposta a incidentes'), findsOneWidget);
    expect(find.text('Uma conta pode ter sido comprometida'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(app('pt', const IntelligenceScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Guia de sinais de risco digital'), findsOneWidget);
    expect(find.text('HTTP sem criptografia'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Portugal Portuguese renders localized feature screens and checker surfaces', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(app('pt-PT', const AcademyScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Aprenda a se proteger'), findsOneWidget);
    expect(find.text('Verifique o remetente, não o nome exibido'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(app('pt-PT', const PrivacyScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Revisão de privacidade'), findsOneWidget);
    expect(find.text('Use palavras-passe exclusivas nas contas importantes'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(app('pt-PT', const ResponseScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Guias de resposta a incidentes'), findsOneWidget);
    expect(find.text('Uma conta pode ter sido comprometida'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(app('pt-PT', const IntelligenceScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Guia de sinais de risco digital'), findsOneWidget);
    expect(find.text('HTTP sem criptografia'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(app('pt-PT', const LinkCheckScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Verifique antes de se ligar.'), findsOneWidget);
    expect(find.text('Endereço do site'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(app('pt-PT', const MessageCheckScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Pare. Verifique. Depois responda.'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(app('pt-PT', const QrCheckScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Verifique antes de digitalizar.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Spanish and Portuguese checker headings and input labels are localized', (tester) async {
    await tester.pumpWidget(app('es', const LinkCheckScreen()));
    expect(find.text('Comprueba antes de conectarte.'), findsOneWidget);
    expect(find.text('Dirección web'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(app('pt', const LinkCheckScreen()));
    expect(find.text('Confira antes de se conectar.'), findsOneWidget);
    expect(find.text('Endereço do site'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(app('es', const MessageCheckScreen()));
    expect(find.text('Detente. Comprueba. Después responde.'), findsOneWidget);
    expect(find.text('Texto del mensaje'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(app('pt', const MessageCheckScreen()));
    expect(find.text('Pare. Verifique. Depois responda.'), findsOneWidget);
    expect(find.text('Texto da mensagem'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(app('es', const QrCheckScreen()));
    expect(find.text('Comprueba antes de escanear.'), findsOneWidget);
    expect(find.text('Contenido QR decodificado'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(app('pt', const QrCheckScreen()));
    expect(find.text('Confira antes de escanear.'), findsOneWidget);
    expect(find.text('Conteúdo do QR code decodificado'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

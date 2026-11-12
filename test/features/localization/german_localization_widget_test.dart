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

Widget _app(Widget child) => MaterialApp(
      home: OrvikaLanguageScope(
        language: OrvikaLanguage.fromCode('de'),
        child: child,
      ),
    );

void main() {
  testWidgets('German Academy renders translated lesson content', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(_app(const AcademyScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Lernbereich'), findsOneWidget);
    expect(find.text('Prüfe den Absender, nicht den Anzeigenamen'), findsOneWidget);
    expect(find.textContaining('Namen, Logos und Profilbilder'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('German Privacy renders translated practices and disclosures', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(_app(const PrivacyScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Datenschutz'), findsOneWidget);
    expect(find.text('Verwende einzigartige Passwörter für wichtige Konten'), findsOneWidget);
    expect(find.textContaining('Website-Analyse: ORVIKA verwendet Vercel Web Analytics'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('German Response renders translated incident playbooks', (tester) async {
    await tester.pumpWidget(_app(const ResponseScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Reaktion'), findsOneWidget);
    expect(find.text('Ein Konto könnte kompromittiert sein'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('German Intelligence renders translated reference entries', (tester) async {
    await tester.pumpWidget(_app(const IntelligenceScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Intelligence'), findsOneWidget);
    expect(find.text('Unverschlüsseltes HTTP'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('German checker screens render localized headings and controls', (tester) async {
    await tester.pumpWidget(_app(const LinkCheckScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Prüfen, bevor Sie eine Verbindung herstellen.'), findsOneWidget);
    expect(find.text('Webadresse'), findsOneWidget);
    await tester.pumpWidget(_app(const QrCheckScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Prüfen, bevor Sie scannen.'), findsOneWidget);
    expect(find.text('Dekodierter QR-Inhalt'), findsOneWidget);
    await tester.pumpWidget(_app(const MessageCheckScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Halten Sie inne. Prüfen Sie. Antworten Sie dann.'), findsOneWidget);
    expect(find.text('Nachrichtentext'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

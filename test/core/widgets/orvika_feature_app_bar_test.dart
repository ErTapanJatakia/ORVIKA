import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/core/localization/orvika_language.dart';
import 'package:orvika/core/localization/orvika_localizations.dart';
import 'package:orvika/core/widgets/orvika_feature_app_bar.dart';

void main() {
  testWidgets('shared feature app bar renders its title and supplied actions',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: OrvikaFeatureAppBar(
            title: 'Link Check',
            actions: [
              IconButton(
                tooltip: 'Help',
                onPressed: () {},
                icon: const Icon(Icons.help_outline),
              ),
            ],
          ),
          body: const SizedBox.expand(),
        ),
      ),
    );

    expect(find.text('Link Check'), findsOneWidget);
    expect(find.byTooltip('Help'), findsOneWidget);
    expect(find.byType(OrvikaFeatureAppBar), findsOneWidget);
  });

  testWidgets('feature titles use the selected Russian language pack',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: OrvikaLanguageScope(
          language: OrvikaLanguage.fromCode('ru'),
          child: Scaffold(
            appBar: const OrvikaFeatureAppBar(title: 'Link Check'),
            body: const SizedBox.expand(),
          ),
        ),
      ),
    );

    expect(find.text('Проверка ссылок'), findsOneWidget);
    expect(find.text('Link Check'), findsNothing);
  });

  testWidgets('feature titles use the selected Hindi draft pack',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: OrvikaLanguageScope(
          language: OrvikaLanguage.fromCode('hi'),
          child: Scaffold(
            appBar: const OrvikaFeatureAppBar(title: 'QR Check'),
            body: const SizedBox.expand(),
          ),
        ),
      ),
    );

    expect(find.text('QR कोड जाँच'), findsOneWidget);
    expect(find.text('QR Check'), findsNothing);
  });

  testWidgets('unknown app-bar titles remain unchanged', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: const OrvikaFeatureAppBar(title: 'Custom Screen'),
          body: const SizedBox.expand(),
        ),
      ),
    );

    expect(find.text('Custom Screen'), findsOneWidget);
  });
}

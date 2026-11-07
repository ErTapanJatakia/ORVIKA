import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
}

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const descriptions = <String>[
    'Your safety overview and recent checks.',
    'Inspect website addresses before you open them.',
    'Review decoded QR content before taking action.',
    'Review suspicious texts, emails and messages.',
    'Explore explainable digital-risk indicators and safer next steps.',
    'Review practical privacy controls with a guided self-audit.',
    'Build everyday cyber-safety knowledge with short lessons and knowledge checks.',
    'Find clear next steps when something goes wrong.',
  ];

  const viewports = <({Size size, double textScale})>[
    (size: Size(320, 720), textScale: 1),
    (size: Size(390, 844), textScale: 2),
    (size: Size(560, 900), textScale: 1),
    (size: Size(768, 1024), textScale: 1.5),
    (size: Size(1280, 900), textScale: 1),
  ];

  testWidgets(
    'dashboard module descriptions remain fully readable across widths and text scales',
    (tester) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      tester.view.devicePixelRatio = 1;

      for (final viewport in viewports) {
        tester.view.physicalSize = viewport.size;
        SharedPreferences.setMockInitialValues({
          'onboarding.completed.v1': true,
          'appearance.language': 'en',
          'accessibility.textScale': viewport.textScale,
        });

        await tester.pumpWidget(
          OrvikaApp(
            key: ValueKey(
              'module-readability-${viewport.size.width}-${viewport.textScale}',
            ),
          ),
        );
        await tester.pumpAndSettle();

        final dashboard = find.byType(CustomScrollView);
        expect(dashboard, findsOneWidget);
        final scrollable = find.descendant(
          of: dashboard,
          matching: find.byType(Scrollable),
        ).first;

        for (final description in descriptions) {
          final finder = find.text(description);
          await tester.scrollUntilVisible(
            finder,
            180,
            scrollable: scrollable,
            maxScrolls: 30,
          );
          await tester.pumpAndSettle();

          final paragraph = tester.renderObject<RenderParagraph>(finder);
          final requiredHeight =
              paragraph.getMaxIntrinsicHeight(paragraph.size.width);
          expect(
            paragraph.size.height + 1,
            greaterThanOrEqualTo(requiredHeight),
            reason:
                'Module description was vertically clipped at ${viewport.size.width}px '
                'with text scale ${viewport.textScale}: $description',
          );
          expect(
            paragraph.size.width,
            greaterThan(0),
            reason: 'Module description should have a measurable layout width.',
          );
          expect(
            tester.takeException(),
            isNull,
            reason:
                'Module card layout exception at ${viewport.size.width}px '
                'with text scale ${viewport.textScale}',
          );
        }

        final title = find.text('Link Check');
        expect(tester.widget<Text>(title).style?.fontSize, 16);
        final status = find.text('AVAILABLE').first;
        expect(tester.widget<Text>(status).style?.fontSize, 10);
      }
    },
  );
}

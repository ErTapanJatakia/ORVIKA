import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/main.dart';
import 'package:orvika/core/localization/orvika_language.dart';
import 'package:orvika/core/localization/orvika_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({'onboarding.completed.v1': true, 'appearance.language': 'en'}));

  testWidgets('first launch language selection immediately opens the dashboard', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();

    expect(find.text('Choose your language'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'English');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('language-en')));
    await tester.pumpAndSettle();

    expect(find.text('Your safety toolkit'), findsOneWidget);
    expect(find.text('Choose your language'), findsNothing);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('appearance.language'), 'en');
    expect(preferences.getBool('onboarding.completed.v1'), isTrue);
  });

  testWidgets('completed onboarding is not shown on the next launch', (tester) async {
    SharedPreferences.setMockInitialValues({'onboarding.completed.v1': true, 'appearance.language': 'en'});
    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();

    expect(find.text('Your safety toolkit'), findsOneWidget);
    expect(find.text('Check before you trust.'), findsNothing);
  });

  testWidgets('first launch language picker does not require a separate Continue action', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();
    expect(find.text('Continue'), findsNothing);
    await tester.enterText(find.byType(TextField), 'Hindi');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('language-hi')));
    await tester.pumpAndSettle();
    expect(find.text('आपके डिजिटल सुरक्षा उपकरण'), findsOneWidget);
  });

  testWidgets('ORVIKA dashboard presents its visual identity and core modules', (tester) async {
    SharedPreferences.setMockInitialValues({'onboarding.completed.v1': true, 'appearance.language': 'en'});
    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();

    expect(find.text('ORVIKA'), findsOneWidget);
    expect(find.text('Check before\nyou trust.'), findsOneWidget);
    expect(find.byType(OrvikaOwlMark), findsWidgets);
    expect(find.text('Sentinel'), findsOneWidget);
    expect(find.text('Link Check'), findsOneWidget);
    expect(find.text('QR Check'), findsOneWidget);
    expect(find.text('Message Check'), findsOneWidget);
    expect(find.text('Intelligence'), findsOneWidget);
    expect(find.text('Privacy'), findsOneWidget);
    expect(find.text('Academy'), findsOneWidget);
    expect(find.text('Response'), findsOneWidget);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -900));
    await tester.pumpAndSettle();
    expect(find.textContaining('ORVIKA is an early prototype'), findsOneWidget);
  });

  testWidgets('theme selector switches to the Daylight palette', (tester) async {
    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Choose visual theme'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Daylight').last);
    await tester.pumpAndSettle();

    expect(find.text('Daylight'), findsOneWidget);
    expect(Theme.of(tester.element(find.text('Your safety toolkit'))).brightness, Brightness.light);
  });


  testWidgets('appearance settings saves and restores the selected theme', (tester) async {
    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Appearance and accessibility settings'));
    await tester.pumpAndSettle();

    expect(find.text('Choose your visual environment'), findsOneWidget);
    await tester.tap(find.text('Daylight'));
    await tester.pumpAndSettle();

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('appearance.theme'), 'daylight');

    await tester.pumpWidget(const OrvikaApp(key: ValueKey('restarted-app')));
    await tester.pumpAndSettle();
    expect(find.text('Daylight'), findsOneWidget);
    expect(Theme.of(tester.element(find.text('Your safety toolkit'))).brightness,
      Brightness.light);
  });

  testWidgets('QR Check opens and inspects a payment payload without initiating it', (tester) async {
    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('QR Check'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('QR Check'));
    await tester.pumpAndSettle();

    expect(find.text('Inspect QR content'), findsOneWidget);
    await tester.enterText(
      find.byType(TextField),
      'upi://pay?pa=merchant@example&pn=Merchant',
    );
    await tester.tap(find.text('Inspect QR content'));
    await tester.pumpAndSettle();

    expect(find.text('UPI payment request'), findsOneWidget);
    expect(find.textContaining('will not initiate or approve a payment'), findsOneWidget);
  });

  testWidgets('Intelligence opens the offline reference and explains indicators', (tester) async {
    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -700));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Intelligence'));
    await tester.pumpAndSettle();

    expect(find.text('Understand the signal.'), findsOneWidget);
    expect(find.text('OFFLINE REFERENCE'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Punycode');
    await tester.pumpAndSettle();
    expect(find.text('Internationalised domain / Punycode'), findsOneWidget);

    await tester.tap(find.text('Internationalised domain / Punycode'));
    await tester.pumpAndSettle();
    expect(find.text('WHAT TO NOTICE'), findsOneWidget);
    expect(find.text('WHAT IT MEANS'), findsOneWidget);
    expect(find.text('SAFER NEXT STEP'), findsOneWidget);
    expect(find.text('IMPORTANT LIMIT'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -1400));
    await tester.pumpAndSettle();
    expect(find.textContaining('not a live threat-intelligence feed'), findsOneWidget);
  });
  testWidgets('Academy opens the offline learning curriculum from the dashboard', (tester) async {
    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Academy'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Academy'));
    await tester.pumpAndSettle();

    expect(find.text('Build safer digital habits.'), findsOneWidget);
    expect(find.text('8 lessons'), findsNothing);
    expect(find.text('0 of 8 lessons completed'), findsOneWidget);
    expect(find.text('KNOWLEDGE CHECK'), findsWidgets);
  });

  testWidgets('Response opens incident playbooks from the dashboard', (tester) async {
    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Response'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Response'));
    await tester.pumpAndSettle();

    expect(find.text('Know your next step.'), findsOneWidget);
    expect(find.text('An account may be compromised'), findsOneWidget);

    // The scope disclaimer follows all five playbooks in the scrollable page.
    await tester.drag(find.byType(ListView), const Offset(0, -1800));
    await tester.pumpAndSettle();
    expect(find.textContaining('does not detect incidents'), findsOneWidget);
  });

  testWidgets('Privacy opens the guided self-audit from the dashboard', (tester) async {
    SharedPreferences.setMockInitialValues({'onboarding.completed.v1': true, 'appearance.language': 'en'});
    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Privacy'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Privacy'));
    await tester.pumpAndSettle();

    expect(find.text('Take control of your privacy.'), findsOneWidget);
    expect(find.text('0 of 12 practices reviewed'), findsOneWidget);
  });

  testWidgets('Russian language selection updates the dashboard and persists', (tester) async {
    SharedPreferences.setMockInitialValues({
      'onboarding.completed.v1': true,
      'appearance.language': 'ru',
    });
    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();

    expect(find.text('Ваш набор цифровой безопасности'), findsOneWidget);

    // Verify the header controls while they are still in the viewport.
    await tester.tap(find.byTooltip('Внешний вид и доступность'));
    await tester.pumpAndSettle();
    expect(find.text('Язык'), findsOneWidget);
    expect(find.text('Русский'), findsOneWidget);
    expect(find.text('Внешний вид и доступность'), findsOneWidget);
    await tester.tapAt(const Offset(12, 12));
    await tester.pumpAndSettle();

    // The dashboard grid is below the hero panel and lazily builds its cards.
    // Scroll the outer dashboard until the grid is mounted, then reveal each
    // translated card before asserting its label.
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -900));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Проверка ссылок'));
    await tester.pumpAndSettle();
    expect(find.text('Проверка ссылок'), findsOneWidget);
    await tester.ensureVisible(find.text('Проверка QR'));
    await tester.pumpAndSettle();
    expect(find.text('Проверка QR'), findsOneWidget);
  });

  testWidgets('language selector saves Russian preference from appearance settings', (tester) async {
    SharedPreferences.setMockInitialValues({'onboarding.completed.v1': true, 'appearance.language': 'en'});
    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Appearance and accessibility settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English').first);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Russian');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('language-ru')));
    await tester.pumpAndSettle();

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('appearance.language'), 'ru');
  });

  testWidgets('Tatar draft localizes dashboard while retaining review status', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Tatar');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('language-tt')));
    await tester.pumpAndSettle();
    expect(find.text('Сезнең санлы иминлек кораллары'), findsOneWidget);
    // Dashboard module cards are built lazily; reveal the grid before checking
    // the translated module label.
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -900));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Сылтаманы тикшерү'));
    await tester.pumpAndSettle();
    expect(find.text('Сылтаманы тикшерү'), findsOneWidget);
    expect(
      OrvikaLocalizations.of(tester.element(find.text('Сезнең санлы иминлек кораллары'))).language.code,
      'tt',
      reason: 'The selected Tatar locale must remain available to app localization.',
    );
    expect(OrvikaLanguage.fromCode('tt').hasDraftTranslation, isTrue);
    expect(OrvikaLanguage.fromCode('tt').hasReviewedTranslation, isFalse);
  });

  testWidgets('Bashkir draft localizes dashboard while retaining review status', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Bashkir');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('language-ba')));
    await tester.pumpAndSettle();
    expect(find.text('Һеҙҙең һанлы именлек ҡоралдары'), findsOneWidget);
    // Dashboard module cards are built lazily; reveal the grid before checking
    // the translated module label.
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -900));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Һылтанманы тикшереү'));
    await tester.pumpAndSettle();
    expect(find.text('Һылтанманы тикшереү'), findsOneWidget);
    expect(
      OrvikaLocalizations.of(tester.element(find.text('Һеҙҙең һанлы именлек ҡоралдары'))).language.code,
      'ba',
      reason: 'The selected Bashkir locale must remain available to app localization.',
    );
    expect(OrvikaLanguage.fromCode('ba').hasDraftTranslation, isTrue);
    expect(OrvikaLanguage.fromCode('ba').hasReviewedTranslation, isFalse);
  });

  testWidgets('Hindi draft localizes dashboard immediately after selection', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Hindi');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('language-hi')));
    await tester.pumpAndSettle();
    expect(find.text('आपके डिजिटल सुरक्षा उपकरण'), findsOneWidget);
    expect(find.text('लिंक जाँच'), findsOneWidget);
    expect(find.text('भरोसा करने से पहले जाँचें।'), findsOneWidget);
    expect(find.text('डिवाइस पर जाँच'), findsOneWidget);
    expect(find.text('गोपनीयता सर्वोपरि'), findsOneWidget);
    expect(find.byTooltip('भाषा बदलें'), findsOneWidget);

    expect(
      OrvikaLocalizations.of(tester.element(find.text('आपके डिजिटल सुरक्षा उपकरण'))).language.code,
      'hi',
      reason: 'The selected app locale must not be silently coerced to English.',
    );
    expect(OrvikaLanguage.fromCode('hi').hasDraftTranslation, isTrue);
    expect(OrvikaLanguage.fromCode('hi').hasReviewedTranslation, isFalse);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('appearance.language'), 'hi');
  });

  test('India language catalogue contains 100 unique codes and names', () {
    expect(OrvikaLanguage.indiaValues, hasLength(100));
    expect(OrvikaLanguage.allValues.map((language) => language.code).toSet().length, OrvikaLanguage.allValues.length);
    expect(OrvikaLanguage.allValues.length, greaterThan(100));
    expect(OrvikaLanguage.indiaValues.map((language) => language.code).toSet(), hasLength(100));
    expect(OrvikaLanguage.indiaValues.map((language) => language.name).toSet(), hasLength(100));
    expect(OrvikaLanguage.fromCode('hi').name, 'Hindi');
    expect(OrvikaLanguage.fromCode('tcy').name, 'Tulu');
    expect(OrvikaLanguage.fromCode('bho').name, 'Bhojpuri');
  });

  test('Russia language catalogue contains 100 unique language codes', () {
    expect(OrvikaLanguage.values, hasLength(100));
    expect(OrvikaLanguage.values.map((language) => language.code).toSet(), hasLength(100));
    expect(OrvikaLanguage.values.map((language) => language.name).toSet(), hasLength(100));
    expect(OrvikaLanguage.fromCode('ru').code, 'ru');
    expect(OrvikaLanguage.fromCode('sah').name, 'Sakha (Yakut)');
    expect(OrvikaLanguage.fromCode('unknown').code, 'en');
  });

  testWidgets('language picker inherits the persisted Daylight theme', (tester) async {
    SharedPreferences.setMockInitialValues({'appearance.theme': 'daylight'});
    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();

    expect(find.text('Choose your language'), findsOneWidget);
    final context = tester.element(find.text('Choose your language'));
    expect(Theme.of(context).scaffoldBackgroundColor, OrvikaPalette.daylight.background);
    expect(Theme.of(context).brightness, Brightness.light);
  });

  testWidgets('first launch language picker can search and select a regional language', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();

    expect(find.text('Choose your language'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Tatar');
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('language-tt')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('language-tt')));
    await tester.pumpAndSettle();

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('appearance.language'), 'tt');
  });


  test('nine requested language packs translate shared app interface strings', () {
    const expected = <String, String>{
      'de': 'Ihre Werkzeuge für digitale Sicherheit',
      'fr': 'Vos outils de sécurité numérique',
      'pa': 'ਤੁਹਾਡੇ ਡਿਜ਼ਿਟਲ ਸੁਰੱਖਿਆ ਸਾਧਨ',
      'ur': 'آپ کے ڈیجیٹل تحفظ کے اوزار',
      'it': 'I tuoi strumenti per la sicurezza digitale',
      'ar': 'أدواتك للسلامة الرقمية',
      'mr': 'तुमची डिजिटल सुरक्षा साधने',
      'gu': 'તમારા ડિજિટલ સુરક્ષા સાધનો',
      'sa': 'भवतः अङ्कीयसुरक्षायाः साधनानि',
    };
    for (final entry in expected.entries) {
      final language = OrvikaLanguage.fromCode(entry.key);
      final localizations = OrvikaLocalizations(language);
      expect(localizations.text('dashboard.title'), entry.value, reason: entry.key);
      expect(localizations.text('onboarding.title.1', 'Check before you trust.'),
        isNot('Check before you trust.'), reason: 'Onboarding must be translated for ${entry.key}');
      expect(localizations.text('module.link', 'Link Check'),
        isNot('Link Check'), reason: 'Module label must be translated for ${entry.key}');
      expect(language.hasDraftTranslation, isTrue);
      expect(language.hasReviewedTranslation, isFalse);
    }
  });

  testWidgets('Arabic selection applies right-to-left layout and translated dashboard', (tester) async {
    SharedPreferences.setMockInitialValues({
      'onboarding.completed.v1': true,
      'appearance.language': 'ar',
    });
    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();
    expect(find.text('أدواتك للسلامة الرقمية'), findsOneWidget);
    expect(Directionality.of(tester.element(find.text('أدواتك للسلامة الرقمية'))), TextDirection.rtl);
  });

  testWidgets('Urdu selection applies right-to-left layout and translated dashboard', (tester) async {
    SharedPreferences.setMockInitialValues({
      'onboarding.completed.v1': true,
      'appearance.language': 'ur',
    });
    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();
    expect(find.text('آپ کے ڈیجیٹل تحفظ کے اوزار'), findsOneWidget);
    expect(Directionality.of(tester.element(find.text('آپ کے ڈیجیٹل تحفظ کے اوزار'))), TextDirection.rtl);
  });

  testWidgets('accessibility preferences apply globally and persist locally', (tester) async {
    SharedPreferences.setMockInitialValues({
      'onboarding.completed.v1': true,
      'appearance.language': 'en',
    });
    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Appearance and accessibility settings'));
    await tester.pumpAndSettle();
    expect(find.text('Appearance & accessibility'), findsOneWidget);
    await tester.drag(find.byType(ListView).last, const Offset(0, -620));
    await tester.pumpAndSettle();
    expect(find.text('Accessibility'), findsOneWidget);
    expect(find.text('Text size'), findsOneWidget);

    final slider = tester.widget<Slider>(find.byType(Slider).first);
    slider.onChanged!(1.25);
    await tester.pumpAndSettle();

    final boldSwitch = find.descendant(
      of: find.widgetWithText(SwitchListTile, 'Bold text'),
      matching: find.byType(Switch),
    );
    await tester.ensureVisible(boldSwitch);
    await tester.tap(boldSwitch);
    await tester.pumpAndSettle();

    final reduceMotionSwitch = find.descendant(
      of: find.widgetWithText(SwitchListTile, 'Reduce motion'),
      matching: find.byType(Switch),
    );
    await tester.ensureVisible(reduceMotionSwitch);
    await tester.tap(reduceMotionSwitch);
    await tester.pumpAndSettle();

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getDouble('accessibility.textScale'), 1.25);
    expect(preferences.getBool('accessibility.boldText'), isTrue);
    expect(preferences.getBool('accessibility.reduceMotion'), isTrue);

    // Accessibility settings live on a separate route. Return to the dashboard
    // before asserting that the app-wide MediaQuery and theme are applied there.
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Your safety toolkit'), findsOneWidget);
    final dashboardContext = tester.element(find.text('Your safety toolkit'));
    expect(MediaQuery.of(dashboardContext).textScaler.scale(10), 12.5);
    // ignore: deprecated_member_use
    expect(MediaQuery.of(dashboardContext).textScaler.textScaleFactor, 1.25);
    expect(MediaQuery.of(dashboardContext).disableAnimations, isTrue);
    expect(Theme.of(dashboardContext).textTheme.bodyMedium!.fontWeight!.value,
      greaterThanOrEqualTo(FontWeight.w500.value));
  });


  testWidgets('dashboard header adapts across narrow, tablet and desktop widths', (tester) async {
    SharedPreferences.setMockInitialValues({
      'onboarding.completed.v1': true,
      'appearance.language': 'en',
    });
    tester.view.devicePixelRatio = 1;
    for (final width in [320.0, 375.0, 600.0, 760.0, 1024.0, 1920.0]) {
      tester.view.physicalSize = Size(width, 900);
      await tester.pumpWidget(OrvikaApp(key: ValueKey('responsive-$width')));
      await tester.pumpAndSettle();

      expect(find.text('ORVIKA'), findsOneWidget, reason: 'width: $width');
      expect(find.byTooltip('Change language'), findsOneWidget, reason: 'width: $width');
      expect(tester.takeException(), isNull, reason: 'layout overflow at width: $width');
    }
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('dashboard header remains usable at 200 percent text scaling in RTL', (tester) async {
    SharedPreferences.setMockInitialValues({
      'onboarding.completed.v1': true,
      'appearance.language': 'ar',
    });
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 900);
    await tester.pumpWidget(
      const MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(2.0)),
        child: OrvikaApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('ORVIKA'), findsOneWidget);
    expect(find.byTooltip('تغيير اللغة'), findsOneWidget);
    expect(tester.takeException(), isNull);
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });


  testWidgets('dashboard module cards adapt across viewport and text-scale sizes', (tester) async {
    SharedPreferences.setMockInitialValues({
      'onboarding.completed.v1': true,
      'appearance.language': 'en',
    });
    tester.view.devicePixelRatio = 1;

    for (final width in [320.0, 560.0, 760.0, 1024.0]) {
      tester.view.physicalSize = Size(width, 900);
      await tester.pumpWidget(OrvikaApp(key: ValueKey('dashboard-grid-$width')));
      await tester.pumpAndSettle();

      // The dashboard is a sliver list and the module grid sits below the
      // hero panel. Scroll the outer dashboard viewport first so the lazy
      // grid children are built before asking the tester to reveal a card.
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -900));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Link Check'));
      await tester.pumpAndSettle();
      expect(find.text('Link Check'), findsOneWidget, reason: 'module card at width: $width');
      expect(tester.takeException(), isNull, reason: 'module grid overflow at width: $width');
    }

    tester.view.physicalSize = const Size(320, 900);
    await tester.pumpWidget(
      const MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(2.0)),
        child: OrvikaApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Link Check'));
    await tester.pumpAndSettle();
    expect(find.text('Link Check'), findsOneWidget);
    expect(tester.takeException(), isNull, reason: 'module card overflow at 200% text scaling');

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });


}

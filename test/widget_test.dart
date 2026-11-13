import 'dart:ui' show SemanticsAction;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/main.dart';
import 'package:orvika/core/localization/orvika_language.dart';
import 'package:orvika/core/localization/orvika_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'helpers/dashboard_test_helpers.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({'onboarding.completed.v1': true, 'appearance.language': 'en'}));

  testWidgets('bundled Devanagari font asset is available offline', (tester) async {
    final fontData = await rootBundle.load(
      'assets/fonts/NotoSansDevanagari[wdth,wght].ttf',
    );
    expect(fontData.lengthInBytes, greaterThan(500000));
  });

  testWidgets('Gujarati and Urdu font assets and their licenses are bundled offline', (tester) async {
    for (final asset in [
      'assets/fonts/NotoSansGujarati[wdth,wght].ttf',
      'assets/fonts/NotoNastaliqUrdu[wght].ttf',
    ]) {
      final fontData = await rootBundle.load(asset);
      expect(fontData.lengthInBytes, greaterThan(500000), reason: asset);
    }

    for (final license in [
      'assets/fonts/OFL-NotoSansGujarati.txt',
      'assets/fonts/OFL-NotoNastaliqUrdu.txt',
    ]) {
      final licenseText = await rootBundle.loadString(license);
      expect(licenseText, contains('SIL OPEN FONT LICENSE Version 1.1'));
    }
  });

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

  testWidgets('draft packs expose native-script text and provisional font fallbacks', (tester) async {
    SharedPreferences.setMockInitialValues({});
    const expectedScripts = <String, (int, int)>{
      'hi': (0x0900, 0x097F),
      'mr': (0x0900, 0x097F),
      'gu': (0x0A80, 0x0AFF),
      'ur': (0x0600, 0x06FF),
    };

    for (final entry in expectedScripts.entries) {
      final localization = OrvikaLocalizations(OrvikaLanguage.fromCode(entry.key));
      final heading = localization.text('dashboard.title');
      expect(
        heading.runes.any((rune) => rune >= entry.value.$1 && rune <= entry.value.$2),
        isTrue,
        reason: '${entry.key} draft must contain native-script dashboard text',
      );
    }

    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();
    final textTheme = Theme.of(tester.element(find.text('Choose your language'))).textTheme;
    expect(
      textTheme.bodyMedium?.fontFamilyFallback,
      containsAll(const [
        'Noto Sans Devanagari',
        'Noto Sans Gujarati',
        'Noto Nastaliq Urdu',
        'Noto Naskh Arabic',
        'Noto Sans Arabic',
      ]),
      reason: 'System fallbacks are provisional and do not replace bundled font validation',
    );
  });

  testWidgets('saved draft language falls back safely without overwriting preference', (tester) async {
    SharedPreferences.setMockInitialValues({
      'onboarding.completed.v1': true,
      'appearance.language': 'hi',
    });
    final semantics = tester.ensureSemantics();
    try {
      await tester.pumpWidget(const OrvikaApp());
      await tester.pumpAndSettle();

      expect(find.text('Choose your language'), findsOneWidget);
      expect(find.text('Your safety toolkit'), findsNothing);
      expect(find.bySemanticsLabel(
        'Languages listed: 191. Available to select: 2',
      ), findsOneWidget);

      // Search results are lazily built; filter before inspecting the Hindi tile.
      await tester.enterText(find.byType(TextField), 'Hindi');
      await tester.pumpAndSettle();
      final hindiTile = tester.widget<ListTile>(
        find.byKey(const ValueKey('language-hi')),
      );
      expect(hindiTile.onTap, isNull);

      final preferences = await SharedPreferences.getInstance();
      expect(preferences.getString('appearance.language'), 'hi');
    } finally {
      semantics.dispose();
    }
  });

  testWidgets('completed onboarding is not shown on the next launch', (tester) async {
    SharedPreferences.setMockInitialValues({'onboarding.completed.v1': true, 'appearance.language': 'en'});
    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();

    expect(find.text('Your safety toolkit'), findsOneWidget);
    expect(find.text('Check before you trust.'), findsNothing);
  });

  testWidgets('first launch language picker disables languages without complete translations', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();
    expect(find.text('Continue'), findsNothing);
    await tester.enterText(find.byType(TextField), 'Hindi');
    await tester.pumpAndSettle();

    final hindiTile = tester.widget<ListTile>(find.byKey(const ValueKey('language-hi')));
    expect(hindiTile.onTap, isNull);
    expect(find.text('हिन्दी · Coming soon'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'English');
    await tester.pumpAndSettle();
    final englishTile = tester.widget<ListTile>(find.byKey(const ValueKey('language-en')));
    expect(englishTile.onTap, isNotNull);
    await tester.tap(find.byKey(const ValueKey('language-en')));
    await tester.pumpAndSettle();
    expect(find.text('Your safety toolkit'), findsOneWidget);
  });

  testWidgets('ORVIKA dashboard presents its visual identity and core modules', (tester) async {
    SharedPreferences.setMockInitialValues({'onboarding.completed.v1': true, 'appearance.language': 'en'});
    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();

    expect(find.text('ORVIKA'), findsOneWidget);
    expect(find.text('Check before\nyou trust.'), findsOneWidget);
    expect(find.byType(OrvikaOwlMark), findsWidgets);
    await revealDashboardContent(tester);
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

    await revealDashboardContent(tester);
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

  testWidgets('feature navigation preserves dashboard back-stack behaviour', (tester) async {
    SharedPreferences.setMockInitialValues({
      'onboarding.completed.v1': true,
      'appearance.language': 'en',
    });
    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();

    await revealDashboardContent(tester);
    await tester.ensureVisible(find.text('Link Check'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Link Check'));
    await tester.pumpAndSettle();

    expect(find.text('Inspect before you connect.'), findsOneWidget);
    expect(find.text('Link Check'), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    // The dashboard preserves its scroll offset. Verify the visible module
    // card rather than a heading that is above the viewport and lazily unbuilt.
    expect(find.text('Link Check'), findsOneWidget);
    expect(find.text('Inspect before you connect.'), findsNothing);

    await tester.ensureVisible(find.text('QR Check'));
    await tester.tap(find.text('QR Check'));
    await tester.pumpAndSettle();

    expect(find.text('Look before you scan.'), findsOneWidget);
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('QR Check'), findsOneWidget);
    expect(find.text('Look before you scan.'), findsNothing);
    expect(tester.takeException(), isNull);
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

    await revealDashboardContent(tester);
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

    await revealDashboardContent(tester);
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

    await revealDashboardContent(tester);
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

  testWidgets('Tatar and Bashkir are temporarily unavailable in the language picker', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Tatar');
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('language-tt')), findsNothing);
    await tester.enterText(find.byType(TextField), 'Bashkir');
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('language-ba')), findsNothing);
    expect(OrvikaLanguage.fromCode('tt').code, 'en');
    expect(OrvikaLanguage.fromCode('ba').code, 'en');
    expect(OrvikaLanguage.fromCode('tt').hasDraftTranslation, isFalse);
    expect(OrvikaLanguage.fromCode('ba').hasDraftTranslation, isFalse);
    expect(OrvikaLocalizations.translatedLanguageCodes, isNot(contains('tt')));
    expect(OrvikaLocalizations.translatedLanguageCodes, isNot(contains('ba')));
  });

  test('Hindi draft strings remain available to localization work while selection is gated', () {
    final localization = OrvikaLocalizations(OrvikaLanguage.fromCode('hi'));
    expect(localization.text('dashboard.title'), 'आपके डिजिटल सुरक्षा उपकरण');
    expect(localization.text('onboarding.title.1'), 'भरोसा करने से पहले जाँचें।');
    expect(localization.hasTranslation('dashboard.title'), isTrue);
    expect(OrvikaLanguage.fromCode('hi').hasDraftTranslation, isTrue);
    expect(OrvikaLanguage.fromCode('hi').hasReviewedTranslation, isFalse);
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
    await tester.enterText(find.byType(TextField), 'Chechen');
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('language-ce')), findsOneWidget);
    final chechenTile = tester.widget<ListTile>(find.byKey(const ValueKey('language-ce')));
    expect(chechenTile.onTap, isNull);
    expect(find.text('Нохчийн мотт · Coming soon'), findsOneWidget);

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('appearance.language'), isNull);
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

  testWidgets('Arabic locale scope resolves its dashboard title with RTL direction', (tester) async {
    final language = OrvikaLanguage.fromCode('ar');
    await tester.pumpWidget(MaterialApp(
      home: OrvikaLanguageScope(
        language: language,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Builder(
            builder: (context) => Text(
              OrvikaLocalizations.of(context).text('dashboard.title'),
            ),
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();
    const heading = 'أدواتك للسلامة الرقمية';
    expect(find.text(heading), findsOneWidget);
    expect(Directionality.of(tester.element(find.text(heading))), TextDirection.rtl);
  });

  testWidgets('Urdu locale scope resolves its dashboard title with RTL direction', (tester) async {
    final language = OrvikaLanguage.fromCode('ur');
    await tester.pumpWidget(MaterialApp(
      home: OrvikaLanguageScope(
        language: language,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Builder(
            builder: (context) => Text(
              OrvikaLocalizations.of(context).text('dashboard.title'),
            ),
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();
    const heading = 'آپ کے ڈیجیٹل تحفظ کے اوزار';
    expect(find.text(heading), findsOneWidget);
    expect(Directionality.of(tester.element(find.text(heading))), TextDirection.rtl);
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

    await tester.ensureVisible(find.text('Bold text'));
    await tester.tap(find.text('Bold text'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.widgetWithText(SwitchListTile, 'Reduce motion'));
    await tester.tap(find.text('Reduce motion'));
    await tester.pumpAndSettle();

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getDouble('accessibility.textScale'), 1.25);
    expect(preferences.getBool('accessibility.boldText'), isTrue);
    expect(preferences.getBool('accessibility.reduceMotion'), isTrue);

    // Accessibility settings live on a separate route. Return to the dashboard
    // before asserting that the app-wide MediaQuery and theme are applied there.
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    await revealDashboardContent(tester);
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
    // Portrait logical-width profiles covering the reported Galaxy, iPhone and
    // Pixel families, plus narrow browser viewports. Browser-engine/device
    // verification is still required outside this widget test.
    for (final width in [
      280.0, 320.0, 360.0, 375.0, 390.0, 393.0, 402.0, 412.0, 414.0, 430.0,
      473.0, // Exact screenshot viewport width (CSS/logical px must be confirmed in browser).
      600.0, 760.0, 1024.0, 1920.0,
    ]) {
      tester.view.physicalSize = Size(width, 850);
      await tester.pumpWidget(OrvikaApp(key: ValueKey('responsive-portrait-$width')));
      await tester.pumpAndSettle();

      expect(find.text('ORVIKA'), findsOneWidget, reason: 'width: $width');
      final wordmark = tester.widget<Text>(find.text('ORVIKA'));
      expect(wordmark.maxLines, 1, reason: 'wordmark must remain on one line at width: $width');
      expect(wordmark.softWrap, isFalse, reason: 'wordmark must not wrap at width: $width');
      final wordmarkFit = find.ancestor(
        of: find.text('ORVIKA'),
        matching: find.byType(FittedBox),
      );
      expect(wordmarkFit, findsOneWidget,
          reason: 'wordmark must scale down rather than clip at width: $width');
      expect(tester.getSize(wordmarkFit).width, greaterThanOrEqualTo(100),
          reason: 'wordmark must have usable horizontal layout space at width: $width');
      expect(find.text('PERSONAL CYBER SAFETY INTELLIGENCE'), findsOneWidget,
          reason: 'brand descriptor must remain present at width: $width');
      expect(find.byTooltip('Change language'), findsOneWidget, reason: 'width: $width');
      expect(tester.takeException(), isNull, reason: 'layout overflow at width: $width');
    }
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('dashboard header and hero remain usable at 200 percent text scaling in RTL', (tester) async {
    final language = OrvikaLanguage.fromCode('ar');
    final palette = OrvikaTheme.obsidian.palette;
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 900);
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: palette.primary,
          brightness: Brightness.dark,
          surface: palette.surface,
        ),
        scaffoldBackgroundColor: palette.background,
      ),
      home: OrvikaLanguageScope(
        language: language,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Builder(
            builder: (context) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(2.0),
              ),
              child: SentinelDashboard(
                selectedTheme: OrvikaTheme.obsidian,
                onThemeChanged: (_) {},
                selectedLanguage: language,
                selectedCatalogue: 'india',
                onLanguageChanged: (_) {},
                onCatalogueChanged: (_) {},
                textScale: 2.0,
                onTextScaleChanged: (_) {},
                boldText: false,
                onBoldTextChanged: (_) {},
                reduceMotion: false,
                onReduceMotionChanged: (_) {},
              ),
            ),
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('ORVIKA'), findsOneWidget);
    expect(find.byTooltip('تغيير اللغة'), findsOneWidget);
    final headerContext = tester.element(find.text('ORVIKA'));
    expect(MediaQuery.of(headerContext).textScaler.scale(10), 20);
    expect(tester.takeException(), isNull, reason: 'header or hero overflow at 200% RTL scaling');
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

    // Exercise ORVIKA's persisted accessibility setting rather than wrapping
    // the app in a MediaQuery that MaterialApp can replace during its build.
    SharedPreferences.setMockInitialValues({
      'onboarding.completed.v1': true,
      'appearance.language': 'en',
      'accessibility.textScale': 2.0,
    });
    tester.view.physicalSize = const Size(320, 900);
    await tester.pumpWidget(const OrvikaApp(key: ValueKey('dashboard-grid-200-scale')));
    await tester.pumpAndSettle();

    final dashboardScrollable = find.descendant(
      of: find.byType(CustomScrollView),
      matching: find.byType(Scrollable),
    ).first;
    await tester.scrollUntilVisible(
      find.text('Link Check'),
      250,
      scrollable: dashboardScrollable,
      maxScrolls: 30,
    );
    await tester.pumpAndSettle();
    expect(find.text('Link Check'), findsOneWidget);

    // Every dashboard module description must remain present and wrap naturally
    // at 200% scaling; fixed line caps previously hid part of the copy.
    const dashboardDescriptions = [
      'Your safety overview and recent checks.',
      'Inspect website addresses before you open them.',
      'Review decoded QR content before taking action.',
      'Review suspicious texts, emails and messages.',
      'Explore explainable digital-risk indicators and safer next steps.',
      'Review practical privacy controls with a guided self-audit.',
      'Build everyday cyber-safety knowledge with short lessons and knowledge checks.',
      'Find clear next steps when something goes wrong.',
    ];
    for (final description in dashboardDescriptions) {
      expect(find.text(description), findsOneWidget, reason: 'module description at 200%: $description');
    }
    expect(
      tester.getSize(find.text(
        'Build everyday cyber-safety knowledge with short lessons and knowledge checks.',
      )).height,
      greaterThan(80),
      reason: 'long module description should wrap across multiple readable lines',
    );
    expect(find.text('AVAILABLE'), findsNWidgets(7));

    // The outer dashboard scroll must reach the trust note and footer after
    // the full module grid, even when enlarged cards substantially increase
    // the page height.
    await tester.scrollUntilVisible(
      find.text(
        'ORVIKA is an early prototype. Findings are evidence-led: an algorithmic suspicion is never presented as proof that a person, message or destination is malicious.',
      ),
      250,
      scrollable: dashboardScrollable,
      maxScrolls: 50,
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('ORVIKA is an early prototype.'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('SEE THE RISK  •  VERIFY THE SIGNAL  •  STAY IN CONTROL'),
      250,
      scrollable: dashboardScrollable,
      maxScrolls: 20,
    );
    await tester.pumpAndSettle();
    expect(find.text('SEE THE RISK  •  VERIFY THE SIGNAL  •  STAY IN CONTROL'), findsOneWidget);
    expect(tester.takeException(), isNull, reason: 'module grid, trust note or footer overflow at 200% text scaling');

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });



  testWidgets('dashboard cards expose concise screen-reader labels and correct actions', (tester) async {
    SharedPreferences.setMockInitialValues({
      'onboarding.completed.v1': true,
      'appearance.language': 'en',
    });
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();

    final heroHeading = find.text('Check before\nyou trust.');
    expect(heroHeading, findsOneWidget);
    expect(
      tester.getSemantics(heroHeading).getSemanticsData().flagsCollection.isHeader,
      isTrue,
      reason: 'The primary dashboard message must be exposed as a screen-reader heading.',
    );

    final dashboardHeading = find.text('Your safety toolkit');
    expect(dashboardHeading, findsOneWidget);
    expect(
      tester.getSemantics(dashboardHeading).getSemanticsData().flagsCollection.isHeader,
      isTrue,
    );

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -700));
    await tester.pumpAndSettle();

    final linkCard = find.bySemanticsLabel(
      'Link Check. Inspect website addresses before you open them. Available.',
    );
    expect(linkCard, findsOneWidget);
    expect(
      tester.getSemantics(linkCard).getSemanticsData().hasAction(SemanticsAction.tap),
      isTrue,
    );

    final overviewCard = find.bySemanticsLabel(
      'Sentinel. Your safety overview and recent checks. OVERVIEW.',
    );
    expect(overviewCard, findsOneWidget);
    expect(
      tester.getSemantics(overviewCard).getSemanticsData().hasAction(SemanticsAction.tap),
      isFalse,
    );

    expect(find.byType(FocusTraversalGroup), findsWidgets);
    semantics.dispose();
  });

  testWidgets('Tab traverses focusable controls and Enter activates a dashboard card', (tester) async {
    SharedPreferences.setMockInitialValues({
      'onboarding.completed.v1': true,
      'appearance.language': 'en',
    });
    await tester.pumpWidget(const OrvikaApp());
    await tester.pumpAndSettle();

    await revealDashboardContent(tester);
    final linkCardTitle = find.text('Link Check');
    await tester.ensureVisible(linkCardTitle);
    await tester.pumpAndSettle();

    var reachedLinkCard = false;
    for (var attempt = 0; attempt < 40; attempt++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      if (Focus.of(tester.element(linkCardTitle)).hasFocus) {
        reachedLinkCard = true;
        break;
      }
    }

    expect(
      reachedLinkCard,
      isTrue,
      reason: 'Tab traversal must reach the Link Check card in dashboard reading order.',
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.text('Inspect before you connect.'), findsOneWidget);
  });

}

import 'package:flutter/widgets.dart';
import 'orvika_language.dart';

class OrvikaLocalizations {
  const OrvikaLocalizations(this.language);

  final OrvikaLanguage language;

  static const Map<String, String> _russian = {
    'skip': 'Пропустить',
    'continue': 'Продолжить',
    'enter': 'Войти в ORVIKA',
    'onboarding.title.1': 'Проверьте, прежде чем доверять.',
    'onboarding.description.1': 'Проверяйте ссылки и содержимое QR-кодов до перехода, передачи данных или выполнения действий.',
    'onboarding.detail.1': 'Начните с сигнала. Решение остаётся за вами.',
    'onboarding.title.2': 'Понимайте риски.',
    'onboarding.description.2': 'ORVIKA объясняет признаки, лежащие в основе результата, а не скрывает их за загадочной оценкой.',
    'onboarding.detail.2': 'Подозрение — повод проверить, а не доказательство злого умысла.',
    'onboarding.title.3': 'Ваши данные остаются вашими.',
    'onboarding.description.3': 'Приложение создаётся с приоритетом конфиденциальности и автономной работы. Для начала аккаунт не нужен.',
    'onboarding.detail.3': 'В этом прототипе не гарантируется автономная работа всех будущих функций.',
    'dashboard.title': 'Ваш набор цифровой безопасности',
    'dashboard.subtitle': 'Восемь возможностей. Более ясное понимание цифровых рисков.',
    'settings.title': 'Внешний вид и доступность',
    'settings.language': 'Язык',
    'settings.language.help': 'Выберите язык интерфейса. Настройка хранится только на этом устройстве.',
    'settings.appearance': 'Выберите оформление',
    'settings.saved': 'Выбор сохраняется на этом устройстве. ORVIKA не отправляет настройки оформления на сервер.',
    'settings.accessibility': 'Примечание о доступности: режим высокой контрастности использует более яркие сигнальные цвета и чёткое визуальное разделение. Предупреждения всегда сопровождаются текстом; цвет не является единственным индикатором.',
    'module.sentinel': 'Обзор',
    'module.sentinel.description': 'Общая картина безопасности и последние проверки.',
    'module.link': 'Проверка ссылок',
    'module.link.description': 'Проверьте адрес сайта перед переходом.',
    'module.qr': 'Проверка QR',
    'module.qr.description': 'Проверьте содержимое QR-кода перед действием.',
    'module.message': 'Проверка сообщений',
    'module.message.description': 'Проверяйте подозрительные SMS, письма и сообщения.',
    'module.intelligence': 'Аналитика',
    'module.intelligence.description': 'Изучайте понятные индикаторы цифрового риска и безопасные действия.',
    'module.privacy': 'Конфиденциальность',
    'module.privacy.description': 'Проверьте настройки конфиденциальности с помощью самоаудита.',
    'module.academy': 'Обучение',
    'module.academy.description': 'Изучайте основы кибербезопасности на коротких уроках.',
    'module.response': 'Реагирование',
    'module.response.description': 'Узнайте, что делать, если возникла проблема.',
  };


  // Initial Hindi draft. It remains unreviewed pending qualified native-speaker
  // validation of security, privacy and incident-response terminology.
  static const Map<String, String> _hindiDraft = {
    'skip': 'छोड़ें',
    'continue': 'जारी रखें',
    'enter': 'ORVIKA में प्रवेश करें',
    'onboarding.title.1': 'भरोसा करने से पहले जाँचें।',
    'onboarding.description.1': 'लिंक और QR कोड की सामग्री खोलने, जानकारी साझा करने या कोई कार्रवाई करने से पहले जाँचें।',
    'onboarding.detail.1': 'पहले संकेतों को जाँचें। निर्णय आपका है।',
    'onboarding.title.2': 'जोखिम को समझें।',
    'onboarding.description.2': 'ORVIKA परिणाम के पीछे के संकेतों को समझाता है, उन्हें किसी रहस्यमय स्कोर के पीछे नहीं छिपाता।',
    'onboarding.detail.2': 'संदेह जाँच करने का कारण है, दुर्भावना का प्रमाण नहीं।',
    'onboarding.title.3': 'आपका डेटा आपके नियंत्रण में।',
    'onboarding.description.3': 'ऐप गोपनीयता और ऑफ़लाइन उपयोग को प्राथमिकता देता है। शुरुआत करने के लिए खाते की आवश्यकता नहीं है।',
    'onboarding.detail.3': 'यह प्रोटोटाइप भविष्य की हर सुविधा के ऑफ़लाइन काम करने की गारंटी नहीं देता।',
    'dashboard.title': 'आपके डिजिटल सुरक्षा उपकरण',
    'dashboard.subtitle': 'आठ सुविधाएँ। डिजिटल जोखिमों की बेहतर समझ।',
    'settings.title': 'रूप-रंग और सुलभता',
    'settings.language': 'भाषा',
    'settings.language.help': 'ऐप की भाषा चुनें। यह सेटिंग केवल इसी डिवाइस पर सहेजी जाती है।',
    'settings.appearance': 'अपना रूप-रंग चुनें',
    'settings.saved': 'आपकी पसंद इसी डिवाइस पर सहेजी जाती है। ORVIKA रूप-रंग की सेटिंग सर्वर पर नहीं भेजता।',
    'module.sentinel': 'सुरक्षा अवलोकन',
    'module.sentinel.description': 'सुरक्षा की समग्र स्थिति और हाल की जाँचें।',
    'module.link': 'लिंक जाँच',
    'module.link.description': 'वेबसाइट खोलने से पहले उसका पता जाँचें।',
    'module.qr': 'QR कोड जाँच',
    'module.qr.description': 'कार्रवाई करने से पहले QR कोड की सामग्री जाँचें।',
    'module.message': 'संदेश जाँच',
    'module.message.description': 'संदिग्ध SMS, ईमेल और संदेशों की जाँच करें।',
    'module.intelligence': 'खुफिया जानकारी',
    'module.intelligence.description': 'समझने योग्य डिजिटल जोखिम संकेतों और सुरक्षित अगले कदमों को जानें।',
    'module.privacy': 'गोपनीयता',
    'module.privacy.description': 'स्व-मूल्यांकन के माध्यम से अपनी गोपनीयता सेटिंग्स की समीक्षा करें।',
    'module.academy': 'शिक्षा',
    'module.academy.description': 'छोटे पाठों के माध्यम से साइबर सुरक्षा की मूल बातें सीखें।',
    'module.response': 'प्रतिक्रिया',
    'module.response.description': 'समस्या होने पर जानें कि आगे क्या करना है।',
  };

  // Draft Tatar UI strings. They are deliberately not classified as reviewed:
  // security and privacy terminology requires native-speaker validation.
  static const Map<String, String> _tatarDraft = {
    'skip': 'Уздырып җибәрү',
    'continue': 'Дәвам итү',
    'enter': 'ORVIKA-га керү',
    'onboarding.title.1': 'Ышанганчы тикшерегез.',
    'onboarding.description.1': 'Сылтамаларны һәм QR-код эчтәлеген ачканчы, мәгълүмат биргәнче яки гамәл кылганчы тикшерегез.',
    'onboarding.detail.1': 'Башта билгеләрне тикшерегез. Карарны сез кабул итәсез.',
    'onboarding.title.2': 'Хәвефләрне аңлагыз.',
    'onboarding.description.2': 'ORVIKA нәтиҗәнең нинди билгеләргә нигезләнүен аңлата, серле бәя белән генә чикләнми.',
    'onboarding.detail.2': 'Шикләнү — тикшерү өчен сәбәп, явыз ниятнең дәлиле түгел.',
    'onboarding.title.3': 'Мәгълүматларыгыз үзегездә кала.',
    'onboarding.description.3': 'Кушымта хосусыйлыкны һәм офлайн эшләүне өстен куеп эшләнә. Башлау өчен хисап язмасы кирәкми.',
    'onboarding.detail.3': 'Бу прототип киләчәктәге барлык функцияләрнең дә офлайн эшләвен гарантияләми.',
    'dashboard.title': 'Сезнең санлы иминлек кораллары',
    'dashboard.subtitle': 'Сигез мөмкинлек. Санлы хәвефләрне яхшырак аңлау.',
    'settings.title': 'Күренеш һәм мөмкинлекләр',
    'settings.language': 'Тел',
    'settings.language.help': 'Кушымта телен сайлагыз. Бу көйләү бары тик җайланмагызда саклана.',
    'settings.appearance': 'Күренешне сайлагыз',
    'settings.saved': 'Сайлау җайланмагызда саклана. ORVIKA күренеш көйләүләрен серверга җибәрми.',
    'module.sentinel': 'Гомуми күзәтү',
    'module.sentinel.description': 'Иминлекнең гомуми торышы һәм соңгы тикшерүләр.',
    'module.link': 'Сылтаманы тикшерү',
    'module.link.description': 'Күчкәнче сайт адресын тикшерегез.',
    'module.qr': 'QR-кодны тикшерү',
    'module.qr.description': 'Гамәл кылганчы QR-код эчтәлеген тикшерегез.',
    'module.message': 'Хәбәрләрне тикшерү',
    'module.message.description': 'Шикле SMS, электрон хатлар һәм хәбәрләрне тикшерегез.',
    'module.intelligence': 'Аналитика',
    'module.intelligence.description': 'Санлы хәвеф билгеләрен һәм куркынычсыз гамәлләрне өйрәнегез.',
    'module.privacy': 'Хосусыйлык',
    'module.privacy.description': 'Үз-үзеңне тикшерү ярдәмендә хосусыйлык көйләүләрен карагыз.',
    'module.academy': 'Өйрәнү',
    'module.academy.description': 'Кыска дәресләрдә кибериминлек нигезләрен өйрәнегез.',
    'module.response': 'Җавап чаралары',
    'module.response.description': 'Проблема килеп чыкса, нәрсә эшләргә икәнен белегез.',
  };


  // Draft Bashkir UI strings. These are not reviewed or certified:
  // security, privacy and incident-response terms require native-speaker review.
  static const Map<String, String> _bashkirDraft = {
    'skip': 'Үткәреп ебәреү',
    'continue': 'Дауам итергә',
    'enter': 'ORVIKA-ға инергә',
    'onboarding.title.1': 'Ышаныр алдынан тикшерегеҙ.',
    'onboarding.description.1': 'Һылтанмаларҙы һәм QR-код эсендәге мәғлүмәтте асырҙан, мәғлүмәт бирерҙән йәки ғәмәл ҡылырҙан алда тикшерегеҙ.',
    'onboarding.detail.1': 'Башта билдәләрҙе тикшерегеҙ. Ҡарарҙы үҙегеҙ ҡабул итәһегеҙ.',
    'onboarding.title.2': 'Хәүефтәрҙе аңлағыҙ.',
    'onboarding.description.2': 'ORVIKA һөҙөмтәнең ниндәй билдәләргә нигеҙләнеүен аңлата, уны серле баһа менән генә сикләмәй.',
    'onboarding.detail.2': 'Шикләнеү — тикшереү өсөн сәбәп, яуыз ниәттең дәлиле түгел.',
    'onboarding.title.3': 'Мәғлүмәттәрегеҙ үҙегеҙҙә ҡала.',
    'onboarding.description.3': 'Ҡушымта шәхси мәғлүмәтте һаҡлауҙы һәм офлайн эшләүҙе өҫтөн ҡуя. Башлау өсөн иҫәп яҙмаһы кәрәкмәй.',
    'onboarding.detail.3': 'Был прототип киләсәктәге бөтә функцияларҙың да офлайн эшләүен гарантияламай.',
    'dashboard.title': 'Һеҙҙең һанлы именлек ҡоралдары',
    'dashboard.subtitle': 'Һигеҙ мөмкинлек. Һанлы хәүефтәрҙе яҡшыраҡ аңлау.',
    'settings.title': 'Күренеш һәм мөмкинлектәр',
    'settings.language': 'Тел',
    'settings.language.help': 'Ҡушымта телен һайлағыҙ. Был көйләү тик ошо ҡоролмала һаҡлана.',
    'settings.appearance': 'Күренеште һайлағыҙ',
    'settings.saved': 'Һайлау ҡоролмағыҙҙа һаҡлана. ORVIKA күренеш көйләүҙәрен серверға ебәрмәй.',
    'module.sentinel': 'Дөйөм күҙәтеү',
    'module.sentinel.description': 'Именлектең дөйөм торошо һәм һуңғы тикшереүҙәр.',
    'module.link': 'Һылтанманы тикшереү',
    'module.link.description': 'Күсмәҫтән алда сайт адресын тикшерегеҙ.',
    'module.qr': 'QR-кодты тикшереү',
    'module.qr.description': 'Ғәмәл ҡылырҙан алда QR-код эсендәге мәғлүмәтте тикшерегеҙ.',
    'module.message': 'Хәбәрҙәрҙе тикшереү',
    'module.message.description': 'Шикле SMS, электрон хаттар һәм хәбәрҙәрҙе тикшерегеҙ.',
    'module.intelligence': 'Аналитика',
    'module.intelligence.description': 'Һанлы хәүеф билдәләрен һәм хәүефһеҙ ғәмәлдәрҙе өйрәнегеҙ.',
    'module.privacy': 'Шәхси мәғлүмәтте һаҡлау',
    'module.privacy.description': 'Үҙ-үҙеңде тикшереү ярҙамында шәхси мәғлүмәт көйләүҙәрен ҡарағыҙ.',
    'module.academy': 'Өйрәнеү',
    'module.academy.description': 'Ҡыҫҡа дәрестәрҙә киберименлек нигеҙҙәрен өйрәнегеҙ.',
    'module.response': 'Яуап саралары',
    'module.response.description': 'Проблема килеп сыҡһа, нимә эшләргә кәрәклеген белегеҙ.',
  };

  String text(String key, [String? fallback]) {
    final translations = switch (language.code) {
      'ru' => _russian,
      'hi' => _hindiDraft,
      'tt' => _tatarDraft,
      'ba' => _bashkirDraft,
      _ => const <String, String>{},
    };
    return translations[key] ?? fallback ?? key;
  }

  static OrvikaLocalizations of(BuildContext context) {
    final selectedLanguage = OrvikaLanguageScope.maybeOf(context);
    if (selectedLanguage != null) {
      return OrvikaLocalizations(selectedLanguage);
    }
    final locale = Localizations.localeOf(context);
    return OrvikaLocalizations(OrvikaLanguage.fromCode(locale.languageCode));
  }
}

/// Carries ORVIKA's selected catalogue language independently of Flutter's
/// framework locale delegates, which do not provide Material translations for
/// every regional language in the 200-language picker.
class OrvikaLanguageScope extends InheritedWidget {
  const OrvikaLanguageScope({
    super.key,
    required this.language,
    required super.child,
  });

  final OrvikaLanguage language;

  static OrvikaLanguage? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<OrvikaLanguageScope>()?.language;

  @override
  bool updateShouldNotify(OrvikaLanguageScope oldWidget) =>
      language.code != oldWidget.language.code;
}

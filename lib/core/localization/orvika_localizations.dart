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

  String text(String key, [String? fallback]) {
    if (language.code != 'ru') return fallback ?? key;
    return _russian[key] ?? fallback ?? key;
  }

  static OrvikaLocalizations of(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return OrvikaLocalizations(
      OrvikaLanguage.fromCode(locale.languageCode),
    );
  }
}

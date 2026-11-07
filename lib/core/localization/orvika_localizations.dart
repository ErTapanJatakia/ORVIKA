import 'package:flutter/widgets.dart';

enum OrvikaLanguage {
  english('en', 'English'),
  russian('ru', 'Русский');

  const OrvikaLanguage(this.code, this.label);
  final String code;
  final String label;
}

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
    'module.link': 'Проверка ссылок',
    'module.qr': 'Проверка QR',
    'module.message': 'Проверка сообщений',
    'module.intelligence': 'Аналитика',
    'module.privacy': 'Конфиденциальность',
    'module.academy': 'Обучение',
    'module.response': 'Реагирование',
  };

  String text(String key, [String? fallback]) {
    if (language == OrvikaLanguage.english) return fallback ?? key;
    return _russian[key] ?? fallback ?? key;
  }

  static OrvikaLocalizations of(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return OrvikaLocalizations(
      locale.languageCode == 'ru'
          ? OrvikaLanguage.russian
          : OrvikaLanguage.english,
    );
  }
}

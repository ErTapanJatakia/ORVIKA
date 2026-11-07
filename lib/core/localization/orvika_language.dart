class OrvikaLanguage {
  const OrvikaLanguage(this.code, this.name, this.nativeName);

  final String code;
  final String name;
  final String nativeName;

  String get label => '$name — $nativeName';
  bool get hasReviewedTranslation => code == 'en' || code == 'ru';
  bool get hasDraftTranslation => code == 'tt' || code == 'ba';

  static const english = OrvikaLanguage('en', 'English', 'English');
  static const russian = OrvikaLanguage('ru', 'Russian', 'Русский');

  /// Curated catalogue of 100 languages spoken by communities in Russia.
  /// This is not a census ranking; entries include regional, Indigenous and
  /// diaspora languages. English and Russian are the currently translated UI packs.
  static const values = <OrvikaLanguage>[
    OrvikaLanguage('ru', 'Russian', 'Русский'),
    OrvikaLanguage('en', 'English', 'English'),
    OrvikaLanguage('tt', 'Tatar', 'Татарча'),
    OrvikaLanguage('ce', 'Chechen', 'Нохчийн мотт'),
    OrvikaLanguage('ba', 'Bashkir', 'Башҡорт теле'),
    OrvikaLanguage('cv', 'Chuvash', 'Чӑвашла'),
    OrvikaLanguage('av', 'Avar', 'Магӏарул мацӏ'),
    OrvikaLanguage('hy', 'Armenian', 'Հայերեն'),
    OrvikaLanguage('de', 'German', 'Deutsch'),
    OrvikaLanguage('uk', 'Ukrainian', 'Українська'),
    OrvikaLanguage('az', 'Azerbaijani', 'Azərbaycan dili'),
    OrvikaLanguage('kbd', 'Kabardian', 'Адыгэбзэ'),
    OrvikaLanguage('dar', 'Dargwa', 'Дарган мез'),
    OrvikaLanguage('kum', 'Kumyk', 'Къумукъ тил'),
    OrvikaLanguage('lez', 'Lezghian', 'Лезги чӀал'),
    OrvikaLanguage('sah', 'Sakha (Yakut)', 'Саха тыла'),
    OrvikaLanguage('bua', 'Buryat', 'Буряад хэлэн'),
    OrvikaLanguage('udm', 'Udmurt', 'Удмурт кыл'),
    OrvikaLanguage('myv', 'Erzya', 'Эрзянь кель'),
    OrvikaLanguage('mdf', 'Moksha', 'Мокшень кяль'),
    OrvikaLanguage('inh', 'Ingush', 'ГӀалгӀай мотт'),
    OrvikaLanguage('os', 'Ossetian', 'Ирон æвзаг'),
    OrvikaLanguage('krc', 'Karachay-Balkar', 'Къарачай-малкъар тил'),
    OrvikaLanguage('tyv', 'Tuvan', 'Тыва дыл'),
    OrvikaLanguage('ady', 'Adyghe', 'Адыгабзэ'),
    OrvikaLanguage('lbe', 'Lak', 'Лакку маз'),
    OrvikaLanguage('kpv', 'Komi-Zyrian', 'Коми кыв'),
    OrvikaLanguage('mhr', 'Meadow Mari', 'Олык марий'),
    OrvikaLanguage('mrj', 'Hill Mari', 'Кырык мары'),
    OrvikaLanguage('koi', 'Komi-Permyak', 'Перем коми кыв'),
    OrvikaLanguage('yrk', 'Nenets', 'Ненэцяʼ вада'),
    OrvikaLanguage('kca', 'Khanty', 'Ханты ясаӈ'),
    OrvikaLanguage('mns', 'Mansi', 'Мāньщи лāтыӈ'),
    OrvikaLanguage('evn', 'Evenki', 'Эвэды̄ турэ̄н'),
    OrvikaLanguage('eve', 'Even', 'Эвэн'),
    OrvikaLanguage('ckt', 'Chukchi', 'Чукотский язык'),
    OrvikaLanguage('kpy', 'Koryak', 'Нымылан'),
    OrvikaLanguage('itl', 'Itelmen', 'Итэнмэн'),
    OrvikaLanguage('niv', 'Nivkh', 'Нивхгу диф'),
    OrvikaLanguage('ykg', 'Yukaghir', 'Одунь о̄й'),
    OrvikaLanguage('dlg', 'Dolgan', 'Дулҕан тыла'),
    OrvikaLanguage('sel', 'Selkup', 'Шӧльӄумыт әты'),
    OrvikaLanguage('nio', 'Nganasan', 'Няʼ'),
    OrvikaLanguage('ket', 'Ket', 'Остыганна ӄʼ'),
    OrvikaLanguage('clw', 'Chulym', 'Чулымский язык'),
    OrvikaLanguage('kim', 'Tofa', 'Тоъфа дыл'),
    OrvikaLanguage('alt', 'Altai', 'Алтай тил'),
    OrvikaLanguage('kjh', 'Khakas', 'Хакас тілі'),
    OrvikaLanguage('cjs', 'Shor', 'Шор тили'),
    OrvikaLanguage('nog', 'Nogai', 'Ногай тили'),
    OrvikaLanguage('rut', 'Rutul', 'МыхӀабишды чӀел'),
    OrvikaLanguage('agx', 'Aghul', 'Агъул чӀал'),
    OrvikaLanguage('tab', 'Tabasaran', 'Табасаран чӀал'),
    OrvikaLanguage('tkr', 'Tsakhur', 'ЦӀаӀхна миз'),
    OrvikaLanguage('udi', 'Udi', 'Удин'),
    OrvikaLanguage('abq', 'Abaza', 'Абаза бызшва'),
    OrvikaLanguage('abk', 'Abkhaz', 'Аҧсуа бызшәа'),
    OrvikaLanguage('ka', 'Georgian', 'ქართული'),
    OrvikaLanguage('tg', 'Tajik', 'Тоҷикӣ'),
    OrvikaLanguage('uz', 'Uzbek', 'Oʻzbekcha'),
    OrvikaLanguage('ky', 'Kyrgyz', 'Кыргызча'),
    OrvikaLanguage('kk', 'Kazakh', 'Қазақ тілі'),
    OrvikaLanguage('tk', 'Turkmen', 'Türkmençe'),
    OrvikaLanguage('ro', 'Romanian', 'Română'),
    OrvikaLanguage('be', 'Belarusian', 'Беларуская'),
    OrvikaLanguage('pl', 'Polish', 'Polski'),
    OrvikaLanguage('lt', 'Lithuanian', 'Lietuvių'),
    OrvikaLanguage('lv', 'Latvian', 'Latviešu'),
    OrvikaLanguage('et', 'Estonian', 'Eesti'),
    OrvikaLanguage('fi', 'Finnish', 'Suomi'),
    OrvikaLanguage('sv', 'Swedish', 'Svenska'),
    OrvikaLanguage('el', 'Greek', 'Ελληνικά'),
    OrvikaLanguage('he', 'Hebrew', 'עברית'),
    OrvikaLanguage('ko', 'Korean', '한국어'),
    OrvikaLanguage('zh', 'Chinese', '中文'),
    OrvikaLanguage('vi', 'Vietnamese', 'Tiếng Việt'),
    OrvikaLanguage('tr', 'Turkish', 'Türkçe'),
    OrvikaLanguage('ar', 'Arabic', 'العربية'),
    OrvikaLanguage('fa', 'Persian', 'فارسی'),
    OrvikaLanguage('ps', 'Pashto', 'پښتو'),
    OrvikaLanguage('hi', 'Hindi', 'हिन्दी'),
    OrvikaLanguage('ur', 'Urdu', 'اردو'),
    OrvikaLanguage('bn', 'Bengali', 'বাংলা'),
    OrvikaLanguage('pa', 'Punjabi', 'ਪੰਜਾਬੀ'),
    OrvikaLanguage('ne', 'Nepali', 'नेपाली'),
    OrvikaLanguage('ta', 'Tamil', 'தமிழ்'),
    OrvikaLanguage('ku', 'Kurdish', 'Kurdî'),
    OrvikaLanguage('rom', 'Romani', 'Romani ćhib'),
    OrvikaLanguage('yi', 'Yiddish', 'ייִדיש'),
    OrvikaLanguage('fr', 'French', 'Français'),
    OrvikaLanguage('es', 'Spanish', 'Español'),
    OrvikaLanguage('it', 'Italian', 'Italiano'),
    OrvikaLanguage('pt', 'Portuguese', 'Português'),
    OrvikaLanguage('ja', 'Japanese', '日本語'),
    OrvikaLanguage('th', 'Thai', 'ไทย'),
    OrvikaLanguage('id', 'Indonesian', 'Bahasa Indonesia'),
    OrvikaLanguage('ms', 'Malay', 'Bahasa Melayu'),
    OrvikaLanguage('si', 'Sinhala', 'සිංහල'),
    OrvikaLanguage('mn', 'Mongolian', 'Монгол хэл'),
    OrvikaLanguage('sr', 'Serbian', 'Српски'),
  ];

  static OrvikaLanguage fromCode(String? code) {
    if (code == null) return english;
    for (final language in values) {
      if (language.code == code) return language;
    }
    return english;
  }
}

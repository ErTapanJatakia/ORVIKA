class OrvikaLanguage {
  const OrvikaLanguage(this.code, this.name, this.nativeName);

  final String code;
  final String name;
  final String nativeName;

  /// Canonical BCP 47 language tag for this catalogue entry.
  ///
  /// The catalogue's [code] remains the stable internal translation/storage
  /// key. This tag is the standards-oriented locale identity used for
  /// interoperability and locale-aware platform integrations.
  String get localeTag {
    switch (code) {
      case 'pt-PT':
        return 'pt-PT';
      case 'pt':
        return 'pt-BR';
      case 'zh':
        return 'zh-Hans-CN';
      case 'sr':
        return 'sr-Cyrl-RS';
      case 'pa':
        return 'pa-Guru-IN';
      case 'ks':
        return 'ks-Arab-IN';
      case 'sd':
        return 'sd-Arab-IN';
      case 'ur':
        return 'ur-PK';
      case 'en':
        return 'en';
      case 'ru':
        return 'ru-RU';
      case 'ar':
        return 'ar';
      case 'hi':
        return 'hi-IN';
      case 'gu':
        return 'gu-IN';
      case 'mr':
        return 'mr-IN';
      case 'bn':
        return 'bn-IN';
      case 'ta':
        return 'ta-IN';
      case 'te':
        return 'te-IN';
      case 'kn':
        return 'kn-IN';
      case 'ml':
        return 'ml-IN';
      case 'or':
        return 'or-IN';
      case 'as':
        return 'as-IN';
      case 'ne':
        return 'ne-NP';
      default:
        // ISO 639-1 and registered ISO 639-3 identifiers are valid BCP 47
        // primary language subtags. Keep catalogue identifiers unchanged.
        return code;
    }
  }

  String get label => '$name — $nativeName';

  /// True when this locale's standard writing system is Devanagari.
  bool get usesDevanagariScript => const {
        'hi', 'mr', 'ne', 'sa', 'mai', 'doi', 'kok', 'brx', 'bho'
      }.contains(code);

  /// Gujarati has a distinct script and must not rely on device font fallback.
  bool get usesGujaratiScript => code == 'gu';

  /// Urdu uses Nastaliq shaping and metrics rather than a generic Arabic face.
  bool get usesUrduScript => code == 'ur';

  /// Bundled font selected for the language's primary writing system.
  String get preferredFontFamily {
    if (usesDevanagariScript) return 'NotoSansDevanagari';
    if (usesGujaratiScript) return 'NotoSansGujarati';
    if (usesUrduScript) return 'NotoNastaliqUrdu';
    return 'Inter';
  }
  bool get hasReviewedTranslation => code == 'en' || code == 'ru' || code == 'ar';
  bool get hasDraftTranslation => const {
        'hi', 'de', 'fr', 'pa', 'ur', 'it', 'mr', 'gu', 'sa', 'es', 'pt', 'pt-PT'
      }.contains(code);

  /// Languages temporarily withheld from the app's selectable UI catalogue.
  /// Their catalogue metadata is retained for a possible future reintroduction.
  static const Set<String> temporarilyUnavailableCodes = {'tt', 'ba'};

  /// Writing direction is independent of translation completeness.
  bool get isRightToLeft => const {'ar', 'ur', 'he', 'fa', 'ps'}.contains(code);

  static const english = OrvikaLanguage('en', 'English', 'English');
  static const russian = OrvikaLanguage('ru', 'Russian', 'Русский');
  static const portugalPortuguese =
      OrvikaLanguage('pt-PT', 'Portuguese (Portugal)', 'Português (Portugal)');

  /// Curated catalogue of 100 languages spoken by communities in Russia.
  /// This is not a census ranking; entries include regional, Indigenous and
  /// diaspora languages. Locale translation status is tracked independently.
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
    OrvikaLanguage('pt', 'Portuguese (Brazil)', 'Português (Brasil)'),
    OrvikaLanguage('ja', 'Japanese', '日本語'),
    OrvikaLanguage('th', 'Thai', 'ไทย'),
    OrvikaLanguage('id', 'Indonesian', 'Bahasa Indonesia'),
    OrvikaLanguage('ms', 'Malay', 'Bahasa Melayu'),
    OrvikaLanguage('si', 'Sinhala', 'සිංහල'),
    OrvikaLanguage('mn', 'Mongolian', 'Монгол хэл'),
    OrvikaLanguage('sr', 'Serbian', 'Српски'),
  ];


  /// Curated India-focused catalogue: the 22 Eighth Schedule languages plus
  /// 78 widely represented regional, Indigenous and community languages.
  /// This is a product selection, not a strict 2011 Census top-100 ranking.
  static const indiaValues = <OrvikaLanguage>[
    OrvikaLanguage('hi', 'Hindi', 'हिन्दी'),
    OrvikaLanguage('bn', 'Bengali', 'বাংলা'),
    OrvikaLanguage('mr', 'Marathi', 'मराठी'),
    OrvikaLanguage('te', 'Telugu', 'తెలుగు'),
    OrvikaLanguage('ta', 'Tamil', 'தமிழ்'),
    OrvikaLanguage('gu', 'Gujarati', 'ગુજરાતી'),
    OrvikaLanguage('ur', 'Urdu', 'اردو'),
    OrvikaLanguage('kn', 'Kannada', 'ಕನ್ನಡ'),
    OrvikaLanguage('or', 'Odia', 'ଓଡ଼ିଆ'),
    OrvikaLanguage('ml', 'Malayalam', 'മലയാളം'),
    OrvikaLanguage('pa', 'Punjabi', 'ਪੰਜਾਬੀ'),
    OrvikaLanguage('as', 'Assamese', 'অসমীয়া'),
    OrvikaLanguage('mai', 'Maithili', 'मैथिली'),
    OrvikaLanguage('sat', 'Santali', 'ᱥᱟᱱᱛᱟᱲᱤ'),
    OrvikaLanguage('ks', 'Kashmiri', 'کٲشُر'),
    OrvikaLanguage('ne', 'Nepali', 'नेपाली'),
    OrvikaLanguage('sd', 'Sindhi', 'سنڌي'),
    OrvikaLanguage('doi', 'Dogri', 'डोगरी'),
    OrvikaLanguage('kok', 'Konkani', 'कोंकणी'),
    OrvikaLanguage('mni', 'Manipuri (Meitei)', 'মৈতৈলোন্'),
    OrvikaLanguage('brx', 'Bodo', 'बड़ो'),
    OrvikaLanguage('sa', 'Sanskrit', 'संस्कृतम्'),
    OrvikaLanguage('bho', 'Bhojpuri', 'भोजपुरी'),
    OrvikaLanguage('raj', 'Rajasthani', 'राजस्थानी'),
    OrvikaLanguage('bhb', 'Bhili / Bhilodi', 'भीली'),
    OrvikaLanguage('hne', 'Chhattisgarhi', 'छत्तीसगढ़ी'),
    OrvikaLanguage('bgc', 'Haryanvi', 'हरियाणवी'),
    OrvikaLanguage('mwr', 'Marwari', 'मारवाड़ी'),
    OrvikaLanguage('mag', 'Magahi', 'मगही'),
    OrvikaLanguage('khn', 'Khandeshi', 'खान्देशी'),
    OrvikaLanguage('tcy', 'Tulu', 'ತುಳು'),
    OrvikaLanguage('gon', 'Gondi', 'गोंडी'),
    OrvikaLanguage('kru', 'Kurukh (Oraon)', 'कुड़ुख'),
    OrvikaLanguage('unr', 'Mundari', 'मुंडारी'),
    OrvikaLanguage('mrg', 'Mising', 'মিচিং'),
    OrvikaLanguage('lus', 'Mizo (Lushai)', 'Mizo'),
    OrvikaLanguage('grt', 'Garo', 'A·chik'),
    OrvikaLanguage('hoc', 'Ho', 'Ho'),
    OrvikaLanguage('kxu', 'Kui', 'କୁଇ'),
    OrvikaLanguage('kfq', 'Korku', 'कोरकू'),
    OrvikaLanguage('kff', 'Koya', 'Koya'),
    OrvikaLanguage('srb', 'Sora (Savara)', 'ସୋରା'),
    OrvikaLanguage('trp', 'Kokborok (Tripuri)', 'ককবরক'),
    OrvikaLanguage('bfy', 'Bagheli', 'बघेली'),
    OrvikaLanguage('hlb', 'Halabi', 'हलबी'),
    OrvikaLanguage('xis', 'Kisan', 'Kisan'),
    OrvikaLanguage('sck', 'Sadri', 'सदरी'),
    OrvikaLanguage('sgj', 'Surgujia', 'सुरगुजिया'),
    OrvikaLanguage('sjp', 'Surjapuri', 'सुरजापुरी'),
    OrvikaLanguage('bjl', 'Banjari', 'बंजारी'),
    OrvikaLanguage('lmn', 'Lambadi (Lamani)', 'लमाणी'),
    OrvikaLanguage('wbr', 'Wagdi', 'वागड़ी'),
    OrvikaLanguage('gju', 'Gojri', 'گوجری'),
    OrvikaLanguage('kfy', 'Kumaoni', 'कुमाऊँनी'),
    OrvikaLanguage('gbm', 'Garhwali', 'गढ़वाली'),
    OrvikaLanguage('xnr', 'Kangri', 'कांगड़ी'),
    OrvikaLanguage('mtr', 'Mewari', 'मेवाड़ी'),
    OrvikaLanguage('noe', 'Nimadi', 'निमाड़ी'),
    OrvikaLanguage('mup', 'Malvi', 'मालवी'),
    OrvikaLanguage('wtm', 'Mewati', 'मेवाती'),
    OrvikaLanguage('dhd', 'Dhundhari', 'ढूंढाड़ी'),
    OrvikaLanguage('awa', 'Awadhi', 'अवधी'),
    OrvikaLanguage('bra', 'Braj Bhasha', 'ब्रजभाषा'),
    OrvikaLanguage('bns', 'Bundeli', 'बुंदेली'),
    OrvikaLanguage('tdb', 'Panchpargania', 'पंचपरगनिया'),
    OrvikaLanguage('kur', 'Kurmali', 'कुर्माली'),
    OrvikaLanguage('kfr', 'Kachchhi', 'કચ્છી'),
    OrvikaLanguage('spv', 'Sambalpuri', 'ସମ୍ବଲପୁରୀ'),
    OrvikaLanguage('dso', 'Desia', 'ଦେଶିଆ'),
    OrvikaLanguage('dng', 'Dangi', 'ડાંગી'),
    OrvikaLanguage('lod', 'Lodha', 'ଲୋଧା'),
    OrvikaLanguage('ppr', 'Pawri', 'पावरी'),
    OrvikaLanguage('kzn', 'Kokna', 'કોકણી'),
    OrvikaLanguage('vav', 'Varli', 'वारली'),
    OrvikaLanguage('gbl', 'Gamit', 'ગામિત'),
    OrvikaLanguage('dho', 'Dhodia', 'ધોડિયા'),
    OrvikaLanguage('bhi', 'Bhilali', 'भिलाली'),
    OrvikaLanguage('dap', 'Nissi (Nyishi)', 'Nyishi'),
    OrvikaLanguage('adi', 'Adi', 'Adi'),
    OrvikaLanguage('njo', 'Ao', 'Ao'),
    OrvikaLanguage('njm', 'Angami', 'Angami'),
    OrvikaLanguage('nbe', 'Konyak', 'Konyak'),
    OrvikaLanguage('nmf', 'Tangkhul', 'Tangkhul'),
    OrvikaLanguage('njh', 'Lotha', 'Lotha'),
    OrvikaLanguage('lep', 'Lepcha', 'Lepcha'),
    OrvikaLanguage('lif', 'Limbu', 'Limbu'),
    OrvikaLanguage('bod', 'Tibetan', 'བོད་སྐད་'),
    OrvikaLanguage('bft', 'Balti', 'Balti'),
    OrvikaLanguage('scl', 'Shina', 'Shina'),
    OrvikaLanguage('tcz', 'Thado', 'Thado'),
    OrvikaLanguage('mjw', 'Karbi', 'Karbi'),
    OrvikaLanguage('dis', 'Dimasa', 'Dimasa'),
    OrvikaLanguage('kha', 'Khasi', 'Khasi'),
    OrvikaLanguage('bpy', 'Bishnupriya', 'মৈতৈ'),
    OrvikaLanguage('nbu', 'Rongmei (Kabui)', 'Rongmei'),
    OrvikaLanguage('hmr', 'Hmar', 'Hmar'),
    OrvikaLanguage('pck', 'Paite', 'Paite'),
    OrvikaLanguage('nst', 'Tangsa', 'Tangsa'),
    OrvikaLanguage('nnp', 'Wancho', 'Wancho'),
    OrvikaLanguage('en', 'English', 'English'),
  ];

  /// One unified, de-duplicated language list for the language picker.
  /// Russia and India catalogues remain available as curated source sets.
  static List<OrvikaLanguage> get allValues {
    final byCode = <String, OrvikaLanguage>{};
    for (final language in [...values, ...indiaValues]) {
      if (temporarilyUnavailableCodes.contains(language.code)) continue;
      byCode.putIfAbsent(language.code, () => language);
    }
    final result = byCode.values.toList(growable: true)
      ..add(portugalPortuguese);
    return result..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  static List<OrvikaLanguage> valuesForCatalogue(String catalogue) =>
      (catalogue == 'india' ? indiaValues : values)
          .where((language) => !temporarilyUnavailableCodes.contains(language.code))
          .toList(growable: false);

  static OrvikaLanguage defaultForCatalogue(String catalogue) =>
      catalogue == 'india' ? indiaValues.first : english;

  /// Resolve a BCP 47 tag back to the stable catalogue identifier.
  /// Region and script subtags are intentionally ignored after the primary
  /// language subtag, except for Portuguese variants with distinct entries.
  static OrvikaLanguage fromLocaleTag(String? tag) {
    if (tag == null || tag.trim().isEmpty) return english;
    final normalized = tag.trim().replaceAll('_', '-').toLowerCase();
    if (normalized == 'pt-pt' || normalized.startsWith('pt-pt-')) {
      return portugalPortuguese;
    }
    if (normalized == 'pt-br' || normalized.startsWith('pt-br-')) {
      return fromCode('pt');
    }
    final languageSubtag = normalized.split('-').first;
    return fromCode(languageSubtag);
  }

  static OrvikaLanguage fromCode(String? code) {
    if (code == 'pt-PT') return portugalPortuguese;
    if (code == null || temporarilyUnavailableCodes.contains(code)) return english;
    for (final language in values) {
      if (language.code == code) return language;
    }
    for (final language in indiaValues) {
      if (language.code == code) return language;
    }
    return english;
  }
}

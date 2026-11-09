import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/localization/orvika_language.dart';
import 'core/localization/orvika_localizations.dart';
import 'core/navigation/orvika_navigation.dart';


void main() => runApp(const OrvikaApp());

/// Composes ORVIKA's optional text-size preference with the platform scaler.
/// This preserves nonlinear system text scaling instead of replacing it with
/// a linear scale whenever the in-app preference is changed.
class _CombinedTextScaler extends TextScaler {
  const _CombinedTextScaler(this.platformScaler, this.factor);

  final TextScaler platformScaler;
  final double factor;

  @override
  double scale(double fontSize) => platformScaler.scale(fontSize * factor);

  /// Legacy compatibility only; rendering uses [scale] to retain nonlinear
  /// platform scaling. The value at 1 logical pixel is the best scalar
  /// approximation available for older consumers of TextScaler.
  // ignore: deprecated_member_use
  @override
  double get textScaleFactor => scale(1.0);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _CombinedTextScaler &&
          other.platformScaler == platformScaler &&
          other.factor == factor;

  @override
  int get hashCode => Object.hash(platformScaler, factor);
}

enum OrvikaTheme { obsidian, aurora, daylight, highContrast }

class OrvikaPalette {
  const OrvikaPalette({
    required this.background,
    required this.surface,
    required this.primary,
    required this.secondary,
    required this.success,
    required this.warning,
    required this.danger,
    required this.isDark,
  });

  final Color background, surface, primary, secondary, success, warning, danger;
  final bool isDark;

  static const obsidian = OrvikaPalette(
    background: Color(0xFF081426), surface: Color(0xFF10233B),
    primary: Color(0xFF00D5FF), secondary: Color(0xFFA58BFF),
    success: Color(0xFF20D69A), warning: Color(0xFFFFB547),
    danger: Color(0xFFFF5263), isDark: true,
  );
  static const aurora = OrvikaPalette(
    background: Color(0xFF101026), surface: Color(0xFF201D3D),
    primary: Color(0xFF9CEBFF), secondary: Color(0xFFB69CFF),
    success: Color(0xFF70E2B7), warning: Color(0xFFFFD080),
    danger: Color(0xFFFF7886), isDark: true,
  );
  static const daylight = OrvikaPalette(
    background: Color(0xFFF3F7FB), surface: Color(0xFFFFFFFF),
    primary: Color(0xFF006B86), secondary: Color(0xFF6246B5),
    success: Color(0xFF087A55), warning: Color(0xFF946000),
    danger: Color(0xFFB42336), isDark: false,
  );
  static const highContrast = OrvikaPalette(
    background: Color(0xFF000000), surface: Color(0xFF111111),
    primary: Color(0xFF00FFFF), secondary: Color(0xFFD7B8FF),
    success: Color(0xFF66FFB2), warning: Color(0xFFFFD166),
    danger: Color(0xFFFF6262), isDark: true,
  );
}

extension OrvikaThemeDetails on OrvikaTheme {
  String get label => switch (this) {
    OrvikaTheme.obsidian => 'Obsidian',
    OrvikaTheme.aurora => 'Aurora',
    OrvikaTheme.daylight => 'Daylight',
    OrvikaTheme.highContrast => 'High contrast',
  };
  String get description => switch (this) {
    OrvikaTheme.obsidian => 'The original ORVIKA dark identity',
    OrvikaTheme.aurora => 'A softer violet-blue night palette',
    OrvikaTheme.daylight => 'A clean, bright interface',
    OrvikaTheme.highContrast => 'Maximum contrast and clear edges',
  };
  OrvikaPalette get palette => switch (this) {
    OrvikaTheme.obsidian => OrvikaPalette.obsidian,
    OrvikaTheme.aurora => OrvikaPalette.aurora,
    OrvikaTheme.daylight => OrvikaPalette.daylight,
    OrvikaTheme.highContrast => OrvikaPalette.highContrast,
  };
}

class OrvikaApp extends StatefulWidget {
  const OrvikaApp({super.key});
  @override
  State<OrvikaApp> createState() => _OrvikaAppState();
}

class _OrvikaAppState extends State<OrvikaApp> {
  static const _themePreferenceKey = 'appearance.theme';
  OrvikaTheme _selectedTheme = OrvikaTheme.obsidian;
  OrvikaLanguage _selectedLanguage = OrvikaLanguage.english;
  String _selectedCatalogue = 'russia';
  bool _hasSelectedLanguage = false;
  bool _isLoadingPreferences = true;
  bool _hasCompletedOnboarding = false;
  double _textScale = 1.0;
  bool _boldText = false;
  bool _reduceMotion = false;

  @override
  void initState() {
    super.initState();
    _restoreAppPreferences();
  }

  Future<void> _restoreAppPreferences() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final savedName = preferences.getString(_themePreferenceKey);
      final savedLanguage = preferences.getString('appearance.language');
      final savedCatalogue = preferences.getString('appearance.languageCatalogue') ?? 'russia';
      final completed = preferences.getBool('onboarding.completed.v1') ?? false;
      final textScale = preferences.getDouble('accessibility.textScale') ?? 1.0;
      final boldText = preferences.getBool('accessibility.boldText') ?? false;
      final reduceMotion = preferences.getBool('accessibility.reduceMotion') ?? false;
      if (!mounted) return;
      setState(() {
        _selectedCatalogue = savedCatalogue;
        _selectedLanguage = OrvikaLanguage.fromCode(savedLanguage);
        _hasSelectedLanguage = savedLanguage != null;
        if (savedName != null) {
          for (final theme in OrvikaTheme.values) {
            if (theme.name == savedName) {
              _selectedTheme = theme;
              break;
            }
          }
        }
        _hasCompletedOnboarding = completed;
        _textScale = textScale.clamp(0.85, 2.0).toDouble();
        _boldText = boldText;
        _reduceMotion = reduceMotion;
        _isLoadingPreferences = false;
      });
    } catch (_) {
      if (mounted) setState(() => _isLoadingPreferences = false);
    }
  }

  Future<void> _completeLanguageSelection() async {
    await _selectLanguage(_selectedLanguage);
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setBool('onboarding.completed.v1', true);
    } catch (_) {
      // Language selection must not be blocked by local storage.
    }
    if (mounted) {
      setState(() {
        _hasSelectedLanguage = true;
        _hasCompletedOnboarding = true;
      });
    }
  }

  Future<void> _completeOnboarding() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setBool('onboarding.completed.v1', true);
    } catch (_) {
      // Keep the app usable if local preference storage is unavailable.
    }
    if (mounted) setState(() => _hasCompletedOnboarding = true);
  }

  Future<void> _selectLanguage(OrvikaLanguage language) async {
    setState(() => _selectedLanguage = language);
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString('appearance.language', language.code);
    } catch (_) {
      // Keep the selected language for this session if storage is unavailable.
    }
  }

  Future<void> _selectCatalogue(String catalogue) async {
    final options = OrvikaLanguage.valuesForCatalogue(catalogue);
    final selected = options.any((language) => language.code == _selectedLanguage.code)
        ? _selectedLanguage
        : OrvikaLanguage.defaultForCatalogue(catalogue);
    setState(() {
      _selectedCatalogue = catalogue;
      _selectedLanguage = selected;
    });
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString('appearance.languageCatalogue', catalogue);
      await preferences.setString('appearance.language', selected.code);
    } catch (_) {
      // Keep catalogue and language selection for this session.
    }
  }

  Future<void> _setTextScale(double value) async {
    final safeValue = value.clamp(0.85, 2.0).toDouble();
    setState(() => _textScale = safeValue);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setDouble('accessibility.textScale', safeValue);
  }

  Future<void> _setBoldText(bool value) async {
    setState(() => _boldText = value);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool('accessibility.boldText', value);
  }

  Future<void> _setReduceMotion(bool value) async {
    setState(() => _reduceMotion = value);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool('accessibility.reduceMotion', value);
  }

  Future<void> _selectTheme(OrvikaTheme theme) async {
    setState(() => _selectedTheme = theme);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_themePreferenceKey, theme.name);
  }

  @override
  Widget build(BuildContext context) {
    final palette = _selectedTheme.palette;
    final baseTextTheme = ThemeData(
      brightness: palette.isDark ? Brightness.dark : Brightness.light,
    ).textTheme.apply(fontFamily: 'Inter');
    final brandTextTheme = baseTextTheme.copyWith(
      displayLarge: baseTextTheme.displayLarge?.copyWith(fontFamily: 'SpaceGrotesk'),
      displayMedium: baseTextTheme.displayMedium?.copyWith(fontFamily: 'SpaceGrotesk'),
      displaySmall: baseTextTheme.displaySmall?.copyWith(fontFamily: 'SpaceGrotesk'),
      headlineLarge: baseTextTheme.headlineLarge?.copyWith(fontFamily: 'SpaceGrotesk'),
      headlineMedium: baseTextTheme.headlineMedium?.copyWith(fontFamily: 'SpaceGrotesk'),
      headlineSmall: baseTextTheme.headlineSmall?.copyWith(fontFamily: 'SpaceGrotesk'),
      titleLarge: baseTextTheme.titleLarge?.copyWith(fontFamily: 'SpaceGrotesk'),
    );
    final scheme = ColorScheme.fromSeed(
      seedColor: palette.primary,
      brightness: palette.isDark ? Brightness.dark : Brightness.light,
      surface: palette.surface,
    ).copyWith(
      primary: palette.primary,
      secondary: palette.secondary,
      error: palette.danger,
      surface: palette.surface,
      onSurface: palette.isDark ? const Color(0xFFF3F7FC) : const Color(0xFF172536),
      onPrimary: palette.isDark ? const Color(0xFF061321) : Colors.white,
      outline: palette.isDark ? Colors.white24 : const Color(0xFF8292A4),
    );

    return MaterialApp(
      title: 'ORVIKA — Check Before You Trust',
      // Flutter framework widgets need locales supported by its Material and
      // Cupertino delegates. ORVIKA's own language packs are carried separately
      // by OrvikaLanguageScope, so regional selections never break framework UI.
      locale: Locale(_selectedLanguage.code == 'ru' ? 'ru' : 'en'),
      supportedLocales: const [Locale('en'), Locale('ru')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      builder: (context, child) {
        final platformMediaQuery = MediaQuery.of(context);
        return MediaQuery(
        data: platformMediaQuery.copyWith(
          textScaler: _CombinedTextScaler(platformMediaQuery.textScaler, _textScale),
          disableAnimations: _reduceMotion || platformMediaQuery.disableAnimations,
        ),
        child: FocusTraversalGroup(
          policy: ReadingOrderTraversalPolicy(),
          child: Semantics(
            container: true,
            explicitChildNodes: true,
            child: Directionality(
              textDirection: const {'ar', 'ur'}.contains(_selectedLanguage.code)
                  ? TextDirection.rtl : TextDirection.ltr,
              child: OrvikaLanguageScope(
                language: _selectedLanguage,
                child: child ?? const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      );
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Inter',
        textTheme: _boldText
            ? brandTextTheme.copyWith(
                displayLarge: brandTextTheme.displayLarge?.copyWith(fontWeight: FontWeight.w900),
                displayMedium: brandTextTheme.displayMedium?.copyWith(fontWeight: FontWeight.w900),
                displaySmall: brandTextTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900),
                headlineLarge: brandTextTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w900),
                headlineMedium: brandTextTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
                headlineSmall: brandTextTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
                titleLarge: brandTextTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                titleMedium: brandTextTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                titleSmall: brandTextTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                bodyLarge: brandTextTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
                bodyMedium: brandTextTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                bodySmall: brandTextTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
                labelLarge: brandTextTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                labelMedium: brandTextTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
                labelSmall: brandTextTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700),
              )
            : brandTextTheme,
        colorScheme: scheme,
        scaffoldBackgroundColor: palette.background,
        canvasColor: palette.surface,
        cardColor: palette.surface,
        focusColor: scheme.primary.withValues(alpha: 0.22),
        appBarTheme: AppBarTheme(
          backgroundColor: palette.background,
          foregroundColor: scheme.onSurface,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: palette.surface,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: scheme.outline.withValues(alpha: 0.65)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: palette.primary, width: 1.6),
          ),
        ),
      ),
      home: _isLoadingPreferences
          ? OrvikaSplashScreen(selectedLanguage: _selectedLanguage, selectedCatalogue: _selectedCatalogue, onLanguageChanged: _selectLanguage, onCatalogueChanged: _selectCatalogue)
          : !_hasSelectedLanguage
              ? LanguageSelectionScreen(
                  selectedLanguage: _selectedLanguage,
                  selectedCatalogue: _selectedCatalogue,
                  onLanguageChanged: _selectLanguage,
                  onCatalogueChanged: _selectCatalogue,
                  onContinue: _completeLanguageSelection,
                )
              : _hasCompletedOnboarding
              ? SentinelDashboard(
                  selectedTheme: _selectedTheme,
                  onThemeChanged: _selectTheme,
                  selectedLanguage: _selectedLanguage,
                  selectedCatalogue: _selectedCatalogue,
                  onLanguageChanged: _selectLanguage,
                  onCatalogueChanged: _selectCatalogue,
                  textScale: _textScale, onTextScaleChanged: _setTextScale,
                  boldText: _boldText, onBoldTextChanged: _setBoldText,
                  reduceMotion: _reduceMotion, onReduceMotionChanged: _setReduceMotion,
                )
              : OrvikaOnboardingScreen(onCompleted: _completeOnboarding, language: _selectedLanguage, selectedCatalogue: _selectedCatalogue, onCatalogueChanged: _selectCatalogue),
    );
  }
}

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({
    required this.selectedLanguage,
    required this.selectedCatalogue,
    required this.onLanguageChanged,
    required this.onCatalogueChanged,
    this.onContinue,
    this.showContinueButton = true,
    super.key,
  });

  final OrvikaLanguage selectedLanguage;
  final String selectedCatalogue;
  final ValueChanged<OrvikaLanguage> onLanguageChanged;
  final ValueChanged<String> onCatalogueChanged;
  final VoidCallback? onContinue;
  final bool showContinueButton;

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  late OrvikaLanguage _selected = widget.selectedLanguage;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = OrvikaTheme.values.firstWhere(
      (theme) => theme.palette.background == Theme.of(context).scaffoldBackgroundColor,
      orElse: () => OrvikaTheme.obsidian,
    );
    final palette = appTheme.palette;
    final scheme = Theme.of(context).colorScheme;
    final isRussian = _selected.code == 'ru';
    final catalogueLanguages = OrvikaLanguage.allValues;
    final filtered = catalogueLanguages.where((language) {
      final query = _query.trim().toLowerCase();
      if (query.isEmpty) return true;
      return language.name.toLowerCase().contains(query) ||
          language.nativeName.toLowerCase().contains(query) ||
          language.code.toLowerCase().contains(query);
    }).toList(growable: false);

    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      OrvikaOwlMark(size: 46, palette: palette),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text('ORVIKA', style: TextStyle(
                          color: scheme.onSurface, fontSize: 20,
                          fontWeight: FontWeight.w900, letterSpacing: 2.8)),
                      ),
                      Text('LANGUAGES', style: TextStyle(
                        color: palette.primary, fontSize: 10,
                        fontWeight: FontWeight.w800, letterSpacing: 1.1)),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Semantics(
                    header: true,
                    child: Text(
                      isRussian ? 'Выберите язык' : 'Choose your language',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isRussian
                      ? 'Выберите язык интерфейса перед началом работы с ORVIKA.'
                      : 'Choose your interface language before you start using ORVIKA.',
                    style: TextStyle(color: scheme.onSurfaceVariant, height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _query = value),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      labelText: isRussian ? 'Поиск языков' : 'Search languages',
                      hintText: isRussian ? 'Поиск по названию или коду' : 'Search by language name or code',
                      suffixIcon: _query.isEmpty ? null : IconButton(
                        tooltip: isRussian ? 'Очистить поиск' : 'Clear search',
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: palette.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: palette.primary.withValues(alpha: 0.2)),
                      ),
                      child: filtered.isEmpty
                        ? Center(child: Text(isRussian ? 'Язык не найден' : 'No matching language'))
                        : ListView.builder(
                            key: const ValueKey('language-options'),
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final language = filtered[index];
                              final selected = language.code == _selected.code;
                              return Material(
                                color: palette.surface,
                                borderRadius: BorderRadius.circular(12),
                                child: ListTile(
                                  key: ValueKey('language-${language.code}'),
                                selected: selected,
                                leading: Icon(
                                  selected ? Icons.radio_button_checked : Icons.radio_button_off,
                                  color: selected ? palette.primary : scheme.onSurfaceVariant,
                                ),
                                title: Text(language.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                                subtitle: Text(language.nativeName),
                                trailing: language.hasReviewedTranslation
                                  ? const Icon(Icons.verified_outlined, size: 17)
                                  : language.hasDraftTranslation
                                      ? const Tooltip(message: 'Draft translation — native-speaker review required', child: Icon(Icons.edit_note_rounded, size: 19))
                                      : null,
                                onTap: () {
                                  setState(() => _selected = language);
                                  widget.onLanguageChanged(language);
                                  if (widget.showContinueButton) {
                                    widget.onContinue?.call();
                                  } else {
                                    Navigator.of(context).popUntil((route) => route.isFirst);
                                  }
                                },
                                ),
                              );
                            },
                          ),
                    ),
                  ),
                  Semantics(
                    container: true,
                    liveRegion: true,
                    label: isRussian
                        ? 'Доступно языков: ${filtered.length}'
                        : '${filtered.length} ${filtered.length == 1 ? 'language' : 'languages'} available',
                    child: const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isRussian
                      ? 'Перевод интерфейса проверен для русского и английского. Для хинди и некоторых других языков подготовлены черновики, требующие проверки носителями языков; непереведённые разделы остаются на английском.'
                      : 'English and Russian have reviewed interface translations. Hindi and selected additional languages have unreviewed drafts; languages without an available translation use English.',
                    style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 11, height: 1.4),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OrvikaSplashScreen extends StatelessWidget {
  const OrvikaSplashScreen({
    required this.selectedLanguage,
    required this.selectedCatalogue,
    required this.onLanguageChanged,
    required this.onCatalogueChanged,
    super.key,
  });

  final OrvikaLanguage selectedLanguage;
  final String selectedCatalogue;
  final ValueChanged<OrvikaLanguage> onLanguageChanged;
  final ValueChanged<String> onCatalogueChanged;

  @override
  Widget build(BuildContext context) {
    const palette = OrvikaPalette.obsidian;
    return Scaffold(
      backgroundColor: palette.background,
      body: Stack(
        children: [
          const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OrvikaOwlMark(size: 112, palette: palette),
                SizedBox(height: 22),
                Text(
                  'ORVIKA',
                  style: TextStyle(
                    color: Color(0xFFF3F7FC),
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 5,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'PERSONAL CYBER SAFETY INTELLIGENCE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF9BB0C8),
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(height: 28),
                SizedBox(width: 92, child: LinearProgressIndicator(minHeight: 2)),
              ],
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: SafeArea(
              child: TextButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => LanguageSelectionScreen(
                      selectedLanguage: selectedLanguage,
                      selectedCatalogue: selectedCatalogue,
                      onCatalogueChanged: onCatalogueChanged,
                      onLanguageChanged: onLanguageChanged,
                      showContinueButton: false,
                    ),
                  ),
                ),
                icon: const Icon(Icons.translate_rounded, color: Color(0xFF00D5FF)),
                label: Text(selectedLanguage.name, style: const TextStyle(color: Color(0xFFF3F7FC))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrvikaOnboardingScreen extends StatefulWidget {
  const OrvikaOnboardingScreen({required this.onCompleted, required this.language, required this.selectedCatalogue, required this.onCatalogueChanged, super.key});

  final VoidCallback onCompleted;
  final OrvikaLanguage language;
  final String selectedCatalogue;
  final ValueChanged<String> onCatalogueChanged;

  @override
  State<OrvikaOnboardingScreen> createState() => _OrvikaOnboardingScreenState();
}

class _OrvikaOnboardingScreenState extends State<OrvikaOnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static List<_OnboardingPageData> _pagesFor(OrvikaLanguage language) => [
    _OnboardingPageData(
      title: OrvikaLocalizations(language).text('onboarding.title.1', 'Check before you trust.'),
      description: OrvikaLocalizations(language).text('onboarding.description.1', 'Inspect links and QR content before you open a destination, share information or take action.'),
      detail: OrvikaLocalizations(language).text('onboarding.detail.1', 'Start with a signal. Make the decision yourself.'),
      icon: Icons.travel_explore_rounded,
    ),
    _OnboardingPageData(
      title: OrvikaLocalizations(language).text('onboarding.title.2', 'Understand the risk.'),
      description: OrvikaLocalizations(language).text('onboarding.description.2', 'ORVIKA is designed to explain the indicators behind a finding—not hide them behind a mysterious score.'),
      detail: OrvikaLocalizations(language).text('onboarding.detail.2', 'A suspicion is a signal to investigate, not proof of malicious intent.'),
      icon: Icons.radar_rounded,
    ),
    _OnboardingPageData(
      title: OrvikaLocalizations(language).text('onboarding.title.3', 'Your data stays yours.'),
      description: OrvikaLocalizations(language).text('onboarding.description.3', 'The experience is designed around privacy-first, offline-friendly checks. No account is required to begin.'),
      detail: OrvikaLocalizations(language).text('onboarding.detail.3', 'This prototype does not promise that every future feature will work offline.'),
      icon: Icons.shield_outlined,
    ),
  ];

  late final _pages = _pagesFor(widget.language);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage == _pages.length - 1) {
      widget.onCompleted();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  void _skip() {
    widget.onCompleted();
  }

  @override
  Widget build(BuildContext context) {
    const palette = OrvikaPalette.obsidian;
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: palette.background,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              palette.background,
              Color.lerp(palette.background, palette.secondary, 0.13)!,
              palette.background,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const OrvikaOwlMark(size: 42, palette: palette),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'ORVIKA',
                            style: TextStyle(
                              color: Color(0xFFF3F7FC),
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2.8,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _skip,
                          child: Text(OrvikaLocalizations(widget.language).text('skip', 'Skip')),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _pages.length,
                        onPageChanged: (index) =>
                            setState(() => _currentPage = index),
                        itemBuilder: (context, index) {
                          final page = _pages[index];
                          return SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                Container(
                                  width: 176,
                                  height: 176,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: palette.surface,
                                    border: Border.all(
                                      color: palette.primary.withValues(alpha: 0.32),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: palette.secondary.withValues(alpha: 0.12),
                                        blurRadius: 42,
                                      ),
                                    ],
                                  ),
                                  child: index == 0
                                      ? const Center(
                                          child: OrvikaOwlMark(
                                            size: 136,
                                            palette: palette,
                                          ),
                                        )
                                      : Icon(
                                          page.icon,
                                          size: 76,
                                          color: index == 1
                                              ? palette.secondary
                                              : palette.success,
                                        ),
                                ),
                                const SizedBox(height: 34),
                                Semantics(
                                  header: true,
                                  child: Text(
                                    page.title,
                                    textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        color: scheme.onSurface,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: -0.7,
                                      ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 530),
                                  child: Text(
                                    page.description,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: scheme.onSurfaceVariant,
                                      fontSize: 15,
                                      height: 1.6,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 18),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: palette.surface,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: palette.primary.withValues(alpha: 0.18),
                                    ),
                                  ),
                                  child: Text(
                                    page.detail,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: palette.primary,
                                      fontSize: 12,
                                      height: 1.45,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List<Widget>.generate(_pages.length, (index) {
                        final selected = index == _currentPage;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: selected ? 26 : 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: selected
                                ? palette.primary
                                : palette.primary.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    Semantics(
                      container: true,
                      liveRegion: true,
                      label: 'Onboarding page ${_currentPage + 1} of ${_pages.length}',
                      child: ExcludeSemantics(
                        child: Text(
                          '${_currentPage + 1} / ${_pages.length}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: scheme.onSurfaceVariant,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _next,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          child: Text(
                            _currentPage == _pages.length - 1
                                ? OrvikaLocalizations(widget.language).text('enter', 'Enter ORVIKA')
                                : OrvikaLocalizations(widget.language).text('continue', 'Continue'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'CHECK BEFORE YOU TRUST',
                      style: TextStyle(
                        color: scheme.onSurfaceVariant,
                        fontSize: 9,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.title,
    required this.description,
    required this.detail,
    required this.icon,
  });

  final String title;
  final String description;
  final String detail;
  final IconData icon;
}

class SentinelDashboard extends StatelessWidget {
  const SentinelDashboard({
    required this.selectedTheme,
    required this.onThemeChanged,
    required this.selectedLanguage,
    required this.selectedCatalogue,
    required this.onLanguageChanged,
    required this.onCatalogueChanged,
    required this.textScale, required this.onTextScaleChanged,
    required this.boldText, required this.onBoldTextChanged,
    required this.reduceMotion, required this.onReduceMotionChanged,
    super.key,
  });

  final double textScale;
  final ValueChanged<double> onTextScaleChanged;
  final bool boldText;
  final ValueChanged<bool> onBoldTextChanged;
  final bool reduceMotion;
  final ValueChanged<bool> onReduceMotionChanged;
  final OrvikaTheme selectedTheme;
  final ValueChanged<OrvikaTheme> onThemeChanged;
  final OrvikaLanguage selectedLanguage;
  final String selectedCatalogue;
  final ValueChanged<OrvikaLanguage> onLanguageChanged;
  final ValueChanged<String> onCatalogueChanged;

  static const modules = <_SafetyModule>[
    _SafetyModule('Sentinel', 'Your safety overview and recent checks.', Icons.shield_moon_outlined, _ModuleAccent.cyan, 'OVERVIEW'),
    _SafetyModule('Link Check', 'Inspect website addresses before you open them.', Icons.link_rounded, _ModuleAccent.cyan, 'AVAILABLE'),
    _SafetyModule('QR Check', 'Review decoded QR content before taking action.', Icons.qr_code_scanner_rounded, _ModuleAccent.violet, 'AVAILABLE'),
    _SafetyModule('Message Check', 'Review suspicious texts, emails and messages.', Icons.mark_email_unread_outlined, _ModuleAccent.amber, 'AVAILABLE'),
    _SafetyModule('Intelligence', 'Explore explainable digital-risk indicators and safer next steps.', Icons.radar_rounded, _ModuleAccent.violet, 'AVAILABLE'),
    _SafetyModule('Privacy', 'Review practical privacy controls with a guided self-audit.', Icons.privacy_tip_outlined, _ModuleAccent.green, 'AVAILABLE'),
    _SafetyModule('Academy', 'Build everyday cyber-safety knowledge with short lessons and knowledge checks.', Icons.school_outlined, _ModuleAccent.cyan, 'AVAILABLE'),
    _SafetyModule('Response', 'Find clear next steps when something goes wrong.', Icons.health_and_safety_outlined, _ModuleAccent.amber, 'AVAILABLE'),
  ];

  @override
  Widget build(BuildContext context) {
    final palette = selectedTheme.palette;
    final scheme = Theme.of(context).colorScheme;
    final viewportWidth = MediaQuery.sizeOf(context).width;
    final pagePadding = viewportWidth < 420 ? 16.0 : viewportWidth < 760 ? 20.0 : 28.0;
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              palette.background,
              Color.lerp(palette.background, palette.secondary, 0.075)!,
              palette.background,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(pagePadding, 18, pagePadding, 40),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _TopBar(
                          palette: palette,
                          selectedTheme: selectedTheme,
                          onThemeChanged: onThemeChanged,
                          selectedLanguage: selectedLanguage,
                          selectedCatalogue: selectedCatalogue,
                          onLanguageChanged: onLanguageChanged,
                          onCatalogueChanged: onCatalogueChanged,
                          textScale: textScale, onTextScaleChanged: onTextScaleChanged,
                          boldText: boldText, onBoldTextChanged: onBoldTextChanged,
                          reduceMotion: reduceMotion, onReduceMotionChanged: onReduceMotionChanged,
                        ),
                        const SizedBox(height: 28),
                        _HeroPanel(palette: palette, language: selectedLanguage),
                        const SizedBox(height: 30),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final compact = constraints.maxWidth < 620;
                            final heading = Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Semantics(
                                  header: true,
                                  child: Text(
                                    OrvikaLocalizations(selectedLanguage).text(
                                      'dashboard.title', 'Your safety toolkit',
                                    ),
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  OrvikaLocalizations(selectedLanguage).text(
                                    'dashboard.subtitle',
                                    'Eight focused capabilities. One clearer view of digital risk.',
                                  ),
                                  style: TextStyle(
                                    color: scheme.onSurfaceVariant,
                                    fontSize: 13,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            );
                            final privacy = _StatusPill(
                              label: OrvikaLocalizations(selectedLanguage).text(
                                'dashboard.privacyFirst', 'PRIVACY-FIRST',
                              ),
                              color: palette.success,
                            );
                            if (compact) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  heading,
                                  const SizedBox(height: 10),
                                  privacy,
                                ],
                              );
                            }
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(child: heading),
                                const SizedBox(width: 12),
                                privacy,
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 17),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final columns = constraints.maxWidth >= 1000
                                ? 4
                                : constraints.maxWidth >= 760
                                    ? 3
                                    : constraints.maxWidth >= 560
                                        ? 2
                                        : 1;
                            final textScale = MediaQuery.textScalerOf(context).scale(11) / 11;
                            final cardExtent = (212 + ((textScale - 1).clamp(0, 1.5) * 176))
                                .clamp(212, 476)
                                .toDouble();
                            return GridView.builder(
                              shrinkWrap: true,
                              primary: false,
                              clipBehavior: Clip.none,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: modules.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columns,
                                crossAxisSpacing: 14,
                                mainAxisSpacing: 14,
                                mainAxisExtent: cardExtent,
                              ),
                              itemBuilder: (context, index) {
                                final module = modules[index];
                                final destination =
                                    OrvikaNavigation.screenForModule(module.title);
                                final VoidCallback? onTap = destination == null
                                    ? null
                                    : () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute<void>(
                                            builder: (_) => destination,
                                          ),
                                        );
                                      };
                                return _ModuleCard(module: _localizedModule(module, selectedLanguage), palette: palette, onTap: onTap);
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        _TrustNote(palette: palette, language: selectedLanguage),
                        const SizedBox(height: 24),
                        Center(
                          child: Text(
                            OrvikaLocalizations(selectedLanguage).text('footer.motto', 'SEE THE RISK  •  VERIFY THE SIGNAL  •  STAY IN CONTROL'),
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: TextStyle(
                              color: scheme.onSurfaceVariant.withValues(alpha: 0.8),
                              fontSize: 10,
                              letterSpacing: MediaQuery.textScalerOf(context).scale(10) > 12
                                  ? 0.55
                                  : 1.2,
                              fontWeight: FontWeight.w700),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class AppearanceSettingsScreen extends StatefulWidget {
  const AppearanceSettingsScreen({
    required this.selectedTheme,
    required this.onThemeChanged,
    required this.selectedLanguage,
    required this.selectedCatalogue,
    required this.onLanguageChanged,
    required this.onCatalogueChanged,
    required this.textScale, required this.onTextScaleChanged,
    required this.boldText, required this.onBoldTextChanged,
    required this.reduceMotion, required this.onReduceMotionChanged,
    super.key,
  });

  final OrvikaTheme selectedTheme;
  final ValueChanged<OrvikaTheme> onThemeChanged;
  final OrvikaLanguage selectedLanguage;
  final String selectedCatalogue;
  final ValueChanged<OrvikaLanguage> onLanguageChanged;
  final ValueChanged<String> onCatalogueChanged;
  final double textScale;
  final ValueChanged<double> onTextScaleChanged;
  final bool boldText;
  final ValueChanged<bool> onBoldTextChanged;
  final bool reduceMotion;
  final ValueChanged<bool> onReduceMotionChanged;

  @override
  State<AppearanceSettingsScreen> createState() => _AppearanceSettingsScreenState();
}

class _AppearanceSettingsScreenState extends State<AppearanceSettingsScreen> {
  late OrvikaTheme _selectedTheme = widget.selectedTheme;
  late OrvikaLanguage _selectedLanguage = widget.selectedLanguage;
  late String _selectedCatalogue = widget.selectedCatalogue;
  late double _textScale = widget.textScale;
  late bool _boldText = widget.boldText;
  late bool _reduceMotion = widget.reduceMotion;

  @override
  Widget build(BuildContext context) {
    final palette = _selectedTheme.palette;
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(OrvikaLocalizations(_selectedLanguage).text('settings.title', 'Appearance & accessibility')),
        backgroundColor: palette.background,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.all(20),
        children: [
          Semantics(
            header: true,
            child: Text(
              OrvikaLocalizations(_selectedLanguage).text('settings.language', 'Language'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 8),
          Text(OrvikaLocalizations(_selectedLanguage).text('settings.language.help', 'Choose the interface language. This setting is stored only on this device.'), style: TextStyle(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.translate_rounded),
              title: Text(_selectedLanguage.name),
              subtitle: Text(_selectedLanguage.nativeName),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => LanguageSelectionScreen(
                    selectedLanguage: _selectedLanguage,
                    selectedCatalogue: _selectedCatalogue,
                    showContinueButton: false,
                    onCatalogueChanged: (catalogue) {
                      setState(() => _selectedCatalogue = catalogue);
                      widget.onCatalogueChanged(catalogue);
                    },
                    onLanguageChanged: (language) {
                      setState(() => _selectedLanguage = language);
                      widget.onLanguageChanged(language);
                    },
                  ),
                ),
              ),
            ),
          ),
          const Divider(height: 28),
          Semantics(
            header: true,
            child: Text(
              OrvikaLocalizations(_selectedLanguage).text('settings.appearance', 'Choose your visual environment'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            OrvikaLocalizations(_selectedLanguage).text('settings.saved', 'Your choice is saved on this device. ORVIKA does not send appearance preferences to a server.'),
            style: TextStyle(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 20),
          RadioGroup<OrvikaTheme>(
            groupValue: _selectedTheme,
            onChanged: (value) {
              if (value == null) return;
              setState(() => _selectedTheme = value);
              widget.onThemeChanged(value);
            },
            child: Column(
              children: [
                for (final theme in OrvikaTheme.values)
                  Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: RadioListTile<OrvikaTheme>(
                      value: theme,
                      title: Text(theme.label, style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text(theme.description),
                      secondary: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: theme.palette.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.palette.primary, width: 2),
                        ),
                        child: Icon(Icons.visibility_outlined, color: theme.palette.primary),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 28),
          Semantics(
            header: true,
            child: Text('Accessibility', style: Theme.of(context).textTheme.titleLarge),
          ),
          const SizedBox(height: 6),
          Text('These preferences are stored on this device. Operating-system accessibility settings remain respected.',
            style: TextStyle(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 12),
          Text('Text size', style: Theme.of(context).textTheme.titleMedium),
          Semantics(
            label: 'Text size', value: '${(_textScale * 100).round()} percent',
            child: Slider(
              min: 0.85, max: 2.0, divisions: 23, value: _textScale,
              label: '${(_textScale * 100).round()}%',
              onChanged: (value) { setState(() => _textScale = value); widget.onTextScaleChanged(value); },
            ),
          ),
          Text('${(_textScale * 100).round()}% · 85%–200%',
            style: TextStyle(color: scheme.onSurfaceVariant)),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Bold text'),
            subtitle: const Text('Increase text weight throughout the app.'),
            value: _boldText,
            onChanged: (value) { setState(() => _boldText = value); widget.onBoldTextChanged(value); },
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Reduce motion'),
            subtitle: const Text('Request reduced or disabled interface animations.'),
            value: _reduceMotion,
            onChanged: (value) { setState(() => _reduceMotion = value); widget.onReduceMotionChanged(value); },
          ),
          Text(
            OrvikaLocalizations(_selectedLanguage).text('settings.accessibility', 'Accessibility note: High contrast uses brighter signal colours and stronger visual separation. Security findings always include text labels; colour is never the only indicator.'),
            style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12),
          ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.palette, required this.selectedTheme, required this.onThemeChanged, required this.selectedLanguage, required this.selectedCatalogue, required this.onLanguageChanged, required this.onCatalogueChanged, required this.textScale, required this.onTextScaleChanged, required this.boldText, required this.onBoldTextChanged, required this.reduceMotion, required this.onReduceMotionChanged});
  final OrvikaPalette palette;
  final OrvikaTheme selectedTheme;
  final ValueChanged<OrvikaTheme> onThemeChanged;
  final OrvikaLanguage selectedLanguage;
  final String selectedCatalogue;
  final ValueChanged<OrvikaLanguage> onLanguageChanged;
  final ValueChanged<String> onCatalogueChanged;
  final double textScale;
  final ValueChanged<double> onTextScaleChanged;
  final bool boldText;
  final ValueChanged<bool> onBoldTextChanged;
  final bool reduceMotion;
  final ValueChanged<bool> onReduceMotionChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final brand = Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        OrvikaOwlMark(size: 48, palette: palette),
        const SizedBox(width: 12),
        Flexible(
          fit: FlexFit.loose,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  'ORVIKA',
                  maxLines: 1,
                  softWrap: false,
                  style: TextStyle(
                    color: scheme.onSurface,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.8,
                    height: 1.1,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                OrvikaLocalizations(selectedLanguage).text(
                  'brand.descriptor', 'PERSONAL CYBER SAFETY INTELLIGENCE'),
                softWrap: true,
                style: TextStyle(
                  color: scheme.onSurfaceVariant, fontSize: 8.5,
                  letterSpacing: 0.8, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ],
    );

    final actions = Wrap(
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 4,
      runSpacing: 4,
      children: [
        IconButton(
          tooltip: OrvikaLocalizations(selectedLanguage).text('nav.changeLanguage', 'Change language'),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => LanguageSelectionScreen(
                selectedLanguage: selectedLanguage,
                selectedCatalogue: selectedCatalogue,
                showContinueButton: false,
                onCatalogueChanged: onCatalogueChanged,
                onLanguageChanged: onLanguageChanged,
              ),
            ),
          ),
          icon: Icon(Icons.translate_rounded, color: palette.primary),
        ),
        IconButton(
          tooltip: OrvikaLocalizations(selectedLanguage).text('nav.appearance', 'Appearance and accessibility settings'),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => AppearanceSettingsScreen(
                selectedTheme: selectedTheme,
                onThemeChanged: onThemeChanged,
                selectedLanguage: selectedLanguage,
                selectedCatalogue: selectedCatalogue,
                onLanguageChanged: onLanguageChanged,
                onCatalogueChanged: onCatalogueChanged,
                textScale: textScale, onTextScaleChanged: onTextScaleChanged,
                boldText: boldText, onBoldTextChanged: onBoldTextChanged,
                reduceMotion: reduceMotion, onReduceMotionChanged: onReduceMotionChanged,
              ),
            ),
          ),
          icon: Icon(Icons.settings_outlined, color: palette.primary),
        ),
        PopupMenuButton<OrvikaTheme>(
          tooltip: OrvikaLocalizations(selectedLanguage).text('nav.chooseTheme', 'Choose visual theme'),
          initialValue: selectedTheme,
          onSelected: onThemeChanged,
          itemBuilder: (context) => OrvikaTheme.values.map((theme) => PopupMenuItem<OrvikaTheme>(
            value: theme,
            child: Row(
              children: [
                Icon(theme == selectedTheme ? Icons.radio_button_checked : Icons.radio_button_off,
                  size: 18, color: theme.palette.primary),
                const SizedBox(width: 10),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(theme.label, style: const TextStyle(fontWeight: FontWeight.w700)),
                    Text(theme.description, style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
                  ],
                )),
              ],
            ),
          )).toList(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: palette.surface,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: scheme.outline.withValues(alpha: 0.4)),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.palette_outlined, size: 17, color: palette.primary),
              const SizedBox(width: 7),
              Text(selectedTheme.label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: scheme.onSurface)),
              const SizedBox(width: 3),
              Icon(Icons.expand_more_rounded, size: 17, color: scheme.onSurfaceVariant),
            ]),
          ),
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final textScale = MediaQuery.textScalerOf(context).scale(10) / 10;
        final compact = constraints.maxWidth < 760 ||
            (textScale >= 1.5 && constraints.maxWidth < 1020);
        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              brand,
              const SizedBox(height: 10),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: actions,
              ),
            ],
          );
        }
        return Row(
          children: [
            Expanded(child: brand),
            const SizedBox(width: 18),
            actions,
          ],
        );
      },
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({required this.palette, required this.language});
  final OrvikaPalette palette;
  final OrvikaLanguage language;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        MediaQuery.sizeOf(context).width < 420 ? 18 : 26,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: palette.primary.withValues(alpha: 0.28)),
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [
            Color.lerp(palette.surface, palette.primary, palette.isDark ? 0.13 : 0.055)!,
            palette.surface,
            Color.lerp(palette.surface, palette.secondary, palette.isDark ? 0.17 : 0.06)!,
          ],
        ),
        boxShadow: [BoxShadow(
          color: palette.secondary.withValues(alpha: palette.isDark ? 0.10 : 0.045),
          blurRadius: 34, spreadRadius: 1)],
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        final textScale = MediaQuery.textScalerOf(context).scale(10) / 10;
        final compact = constraints.maxWidth < 680 ||
            (textScale >= 1.5 && constraints.maxWidth < 900);
        final owl = OrvikaOwlMark(size: compact ? 96 : 148, palette: palette);
        final copyContent = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Text(OrvikaLocalizations(language).text('hero.eyebrow', 'SEE THE RISK. VERIFY THE SIGNAL.'), style: TextStyle(
                color: palette.primary, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.65)),
              const SizedBox(height: 14),
              Text(OrvikaLocalizations(language).text('hero.title', 'Check before\nyou trust.'), style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: scheme.onSurface, fontWeight: FontWeight.w900, height: 1.02, letterSpacing: -1.1)),
              const SizedBox(height: 13),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Text(OrvikaLocalizations(language).text('hero.description', 'A clearer way to inspect digital signals, understand risk and make informed decisions.'),
                  style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 14, height: 1.55)),
              ),
              const SizedBox(height: 17),
              Wrap(spacing: 8, runSpacing: 8, children: [
                _StatusPill(label: OrvikaLocalizations(language).text('hero.onDevice', 'ON-DEVICE CHECKS'), color: palette.success),
                _StatusPill(label: OrvikaLocalizations(language).text('hero.explainable', 'EXPLAINABLE FINDINGS'), color: palette.primary),
              ]),
          ],
        );
        if (compact) {
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Align(alignment: Alignment.centerRight, child: owl),
            const SizedBox(height: 4),
            copyContent,
          ]);
        }
        return Row(children: [
          Expanded(child: copyContent),
          const SizedBox(width: 22),
          Container(
            width: 190, height: 190, alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: palette.primary.withValues(alpha: 0.045),
              border: Border.all(color: palette.primary.withValues(alpha: 0.18)),
            ),
            child: owl,
          ),
        ]);
      }),
    );
  }
}

class OrvikaOwlMark extends StatelessWidget {
  const OrvikaOwlMark({required this.size, required this.palette, super.key});
  final double size;
  final OrvikaPalette palette;
  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size, child: CustomPaint(painter: _OwlPainter(palette)));
}

class _OwlPainter extends CustomPainter {
  const _OwlPainter(this.palette);
  final OrvikaPalette palette;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 200, size.height / 200);
    final outline = Paint()
      ..style = PaintingStyle.stroke ..strokeWidth = 4
      ..strokeJoin = StrokeJoin.round ..color = palette.primary;
    final shell = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topLeft, end: Alignment.bottomRight,
        colors: [palette.primary.withValues(alpha: 0.30), palette.secondary.withValues(alpha: 0.23)],
      ).createShader(const Rect.fromLTWH(18, 18, 164, 164));
    final outer = Path()
      ..moveTo(19, 76) ..lineTo(47, 25) ..lineTo(84, 51)
      ..lineTo(100, 43) ..lineTo(116, 51) ..lineTo(153, 25)
      ..lineTo(181, 76) ..lineTo(163, 151)
      ..quadraticBezierTo(100, 190, 37, 151) ..close();
    canvas.drawPath(outer, shell);
    canvas.drawPath(outer, outline);

    final face = Path()
      ..moveTo(35, 82) ..lineTo(66, 57) ..lineTo(100, 78)
      ..lineTo(134, 57) ..lineTo(165, 82) ..lineTo(151, 139)
      ..quadraticBezierTo(100, 174, 49, 139) ..close();
    canvas.drawPath(face, Paint()..color = palette.surface);
    canvas.drawPath(face, Paint()
      ..color = palette.primary.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke ..strokeWidth = 2.4);

    final wing = Paint()
      ..color = palette.secondary.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke ..strokeWidth = 2.5 ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(42, 105), const Offset(58, 139), wing);
    canvas.drawLine(const Offset(158, 105), const Offset(142, 139), wing);
    canvas.drawLine(const Offset(51, 119), const Offset(65, 146), wing);
    canvas.drawLine(const Offset(149, 119), const Offset(135, 146), wing);

    final eyeRing = Paint()..color = palette.primary..style = PaintingStyle.stroke..strokeWidth = 4;
    final eyeFill = Paint()..shader = LinearGradient(colors: [palette.primary, palette.secondary])
      .createShader(const Rect.fromLTWH(54, 76, 92, 50));
    final pupil = Paint()..color = palette.background;
    canvas.drawCircle(const Offset(73, 101), 22, eyeRing);
    canvas.drawCircle(const Offset(127, 101), 22, eyeRing);
    canvas.drawCircle(const Offset(73, 101), 17, eyeFill);
    canvas.drawCircle(const Offset(127, 101), 17, eyeFill);
    canvas.drawCircle(const Offset(77, 101), 7, pupil);
    canvas.drawCircle(const Offset(131, 101), 7, pupil);
    final glint = Paint()..color = Colors.white.withValues(alpha: 0.9);
    canvas.drawCircle(const Offset(80, 96), 3, glint);
    canvas.drawCircle(const Offset(134, 96), 3, glint);

    final beak = Path()
      ..moveTo(91, 128) ..lineTo(100, 117) ..lineTo(109, 128) ..lineTo(100, 145) ..close();
    canvas.drawPath(beak, Paint()..color = palette.warning);
    canvas.drawPath(beak, Paint()
      ..color = palette.background.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke ..strokeWidth = 1.5);

    final circuit = Paint()..color = palette.primary.withValues(alpha: 0.65)
      ..strokeWidth = 2 ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(100, 16), const Offset(100, 34), circuit);
    canvas.drawCircle(const Offset(100, 12), 4, Paint()..color = palette.secondary);
    canvas.drawCircle(const Offset(25, 158), 3, Paint()..color = palette.primary);
    canvas.drawCircle(const Offset(175, 158), 3, Paint()..color = palette.primary);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _OwlPainter oldDelegate) => oldDelegate.palette != palette;
}

enum _ModuleAccent { cyan, violet, green, amber }

class _SafetyModule {
  const _SafetyModule(this.title, this.description, this.icon, this.accent, this.status);
  final String title, description, status;
  final IconData icon;
  final _ModuleAccent accent;
}

class _ModuleCard extends StatefulWidget {
  const _ModuleCard({required this.module, required this.palette, this.onTap});
  final _SafetyModule module;
  final OrvikaPalette palette;
  final VoidCallback? onTap;

  @override
  State<_ModuleCard> createState() => _ModuleCardState();
}

class _ModuleCardState extends State<_ModuleCard> {
  bool _hasKeyboardFocus = false;

  Color _accent() => switch (widget.module.accent) {
    _ModuleAccent.cyan => widget.palette.primary,
    _ModuleAccent.violet => widget.palette.secondary,
    _ModuleAccent.green => widget.palette.success,
    _ModuleAccent.amber => widget.palette.warning,
  };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = _accent();
    final enabled = widget.onTap != null;
    final description = widget.module.description.trim().replaceFirst(
      RegExp(r'[.!?]+$'),
      '',
    );
    final availability = widget.module.status == 'AVAILABLE'
        ? 'Available'
        : widget.module.status;

    return Semantics(
      container: true,
      label: '${widget.module.title}. $description. $availability.',
      button: enabled,
      enabled: enabled,
      onTap: widget.onTap,
      child: ExcludeSemantics(
        child: Material(
          color: widget.palette.surface.withValues(alpha: enabled ? 1 : 0.72),
          borderRadius: BorderRadius.circular(19),
          child: InkWell(
            onTap: widget.onTap,
            canRequestFocus: enabled,
            focusColor: scheme.primary.withValues(alpha: 0.18),
            onFocusChange: (hasFocus) {
              if (_hasKeyboardFocus != hasFocus) {
                setState(() => _hasKeyboardFocus = hasFocus);
              }
            },
            borderRadius: BorderRadius.circular(19),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(19),
                border: Border.all(
                  color: _hasKeyboardFocus
                      ? scheme.primary
                      : accent.withValues(alpha: enabled ? 0.30 : 0.16),
                  width: _hasKeyboardFocus ? 2.5 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.13),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Icon(widget.module.icon, color: accent, size: 22),
                      ),
                      const Spacer(),
                      Icon(
                        enabled
                            ? Icons.arrow_outward_rounded
                            : widget.module.status == 'OVERVIEW'
                                ? Icons.dashboard_outlined
                                : Icons.lock_outline_rounded,
                        size: 15,
                        color: scheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.module.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        widget.module.description,
                        softWrap: true,
                        style: TextStyle(
                          color: scheme.onSurfaceVariant,
                          fontSize: 12.5,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: _StatusPill(
                      label: availability.toUpperCase(),
                      color: accent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.09),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: color.withValues(alpha: 0.35)),
    ),
    child: Text(label, style: TextStyle(
      color: color, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 0.85)),
  );
}

class _TrustNote extends StatelessWidget {
  const _TrustNote({required this.palette, required this.language});
  final OrvikaPalette palette;
  final OrvikaLanguage language;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: palette.surface.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.24)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: palette.primary, size: 20),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              OrvikaLocalizations(language).text(
                'trust.note',
                'ORVIKA is an early prototype. Findings are evidence-led: an algorithmic suspicion is never presented as proof that a person, message or destination is malicious.',
              ),
              style: TextStyle(
                color: scheme.onSurfaceVariant,
                fontSize: 12.5,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


_SafetyModule _localizedModule(_SafetyModule module, OrvikaLanguage language) {
  final strings = OrvikaLocalizations(language);
  final key = switch (module.title) {
    'Sentinel' => 'sentinel',
    'Link Check' => 'link',
    'QR Check' => 'qr',
    'Message Check' => 'message',
    'Intelligence' => 'intelligence',
    'Privacy' => 'privacy',
    'Academy' => 'academy',
    'Response' => 'response',
    _ => '',
  };
  if (key.isEmpty || language.code == 'en') return module;
  return _SafetyModule(
    strings.text('module.$key', module.title),
    strings.text('module.$key.description', module.description),
    module.icon,
    module.accent,
    strings.text(
      module.status == 'OVERVIEW' ? 'module.status.overview' : 'module.status.available',
      module.status,
    ),
  );
}
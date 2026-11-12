import 'package:flutter/material.dart';

import '../../../core/widgets/orvika_feature_app_bar.dart';
import '../../../core/localization/orvika_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/academy_curriculum.dart';
import '../../../core/localization/german_academy_content.dart';
import '../../../core/localization/italian_academy_content.dart';
import '../../../core/localization/french_academy_content.dart';

class AcademyScreen extends StatefulWidget {
  const AcademyScreen({super.key});

  @override
  State<AcademyScreen> createState() => _AcademyScreenState();
}

class _AcademyScreenState extends State<AcademyScreen> {
  static const _progressKey = 'academy.completed.v1';
  final Set<String> _completed = <String>{};
  final Map<String, int> _answers = <String, int>{};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _restoreProgress();
  }

  Future<void> _restoreProgress() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final saved = preferences.getStringList(_progressKey) ?? const <String>[];
      if (!mounted) return;
      setState(() {
        _completed
          ..clear()
          ..addAll(saved.where((id) => AcademyCurriculum.lessons.any((lesson) => lesson.id == id)));
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _submitAnswer(AcademyLesson lesson, int index) async {
    setState(() => _answers[lesson.id] = index);
    if (index != lesson.correctIndex) return;
    setState(() => _completed.add(lesson.id));
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setStringList(_progressKey, _completed.toList()..sort());
    } catch (_) {
      // Learning remains usable if local progress storage is unavailable.
    }
  }

  Future<void> _resetProgress() async {
    setState(() {
      _completed.clear();
      _answers.clear();
    });
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.remove(_progressKey);
    } catch (_) {
      // Keep the current session usable if storage is unavailable.
    }
  }

  String _categoryLabel(AcademyCategory category, OrvikaLocalizations l10n) => switch (category) {
        AcademyCategory.accountSafety => l10n.text('academy.category.accounts', 'Account safety'),
        AcademyCategory.socialEngineering => l10n.text('academy.category.social', 'Social engineering'),
        AcademyCategory.deviceSafety => l10n.text('academy.category.device', 'Device safety'),
        AcademyCategory.payments => l10n.text('academy.category.payments', 'Payments & QR'),
      };

  IconData _categoryIcon(AcademyCategory category) => switch (category) {
        AcademyCategory.accountSafety => Icons.verified_user_outlined,
        AcademyCategory.socialEngineering => Icons.phishing_outlined,
        AcademyCategory.deviceSafety => Icons.devices_outlined,
        AcademyCategory.payments => Icons.qr_code_2_rounded,
      };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = OrvikaLocalizations.of(context);
    final lessons = AcademyCurriculum.lessons
        .map((lesson) => l10n.language.code == 'fr' ? FrenchAcademyContent.localize(lesson, l10n.language.code) : l10n.language.code == 'it' ? ItalianAcademyContent.localize(lesson, l10n.language.code) : GermanAcademyContent.localize(lesson, l10n.language.code))
        .toList(growable: false);
    final progress = _completed.length;
    return Scaffold(
      appBar: const OrvikaFeatureAppBar(title: 'Academy'),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    l10n.text('academy.heading', 'Build safer digital habits.'),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.text('academy.description', 'Short, practical lessons to help you recognise common risks and choose safer next steps.'),
                  style: TextStyle(color: scheme.onSurfaceVariant, height: 1.45),
                ),
                const SizedBox(height: 18),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final label = Text(
                              l10n.textWithParameters('academy.progress', fallback: '$progress of ${lessons.length} lessons completed', parameters: {'completed': progress, 'total': lessons.length}),
                              style: const TextStyle(fontWeight: FontWeight.w800),
                            );
                            final percentage = Text(
                              '${(progress / lessons.length * 100).round()}%',
                              style: TextStyle(
                                color: scheme.primary,
                                fontWeight: FontWeight.w800,
                              ),
                            );
                            if (constraints.maxWidth < 320) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  label,
                                  const SizedBox(height: 4),
                                  percentage,
                                ],
                              );
                            }
                            return Row(
                              children: [
                                Expanded(child: label),
                                percentage,
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        LinearProgressIndicator(
                          value: progress / lessons.length,
                          semanticsLabel: l10n.textWithParameters('academy.progressSemantics', fallback: 'Academy lesson completion: $progress of ${lessons.length} lessons completed', parameters: {'completed': progress, 'total': lessons.length}),
                          semanticsValue: '${progress / lessons.length}',
                        ),
                        Semantics(
                          container: true,
                          liveRegion: true,
                          label: l10n.textWithParameters('academy.progressUpdate', fallback: 'Academy progress: $progress of ${lessons.length} lessons completed', parameters: {'completed': progress, 'total': lessons.length}),
                          child: const SizedBox.shrink(),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.text('academy.progressNote', 'Progress is stored locally on this device. Completion means you answered the lesson check correctly; it is not a certification.'),
                          style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12, height: 1.4),
                        ),
                        if (progress > 0) ...[
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: _resetProgress,
                              icon: const Icon(Icons.restart_alt_rounded, size: 18),
                              label: Text(l10n.text('academy.reset', 'Reset progress')), 
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                for (final category in AcademyCategory.values) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 18, bottom: 8),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 9,
                      runSpacing: 4,
                      children: [
                        Icon(_categoryIcon(category), color: scheme.primary, size: 20),
                        Text(
                          _categoryLabel(category, l10n),
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  for (final lesson in lessons.where((lesson) => lesson.category == category))
                    Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(lesson.title,
                                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                                ),
                                if (_completed.contains(lesson.id))
                                  Icon(Icons.check_circle_rounded, color: scheme.primary, size: 21),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(lesson.summary,
                              style: TextStyle(color: scheme.onSurfaceVariant, height: 1.45)),
                            const SizedBox(height: 12),
                            Text(l10n.text('academy.keyPoints', 'KEY POINTS'),
                              style: const TextStyle(fontSize: 10, letterSpacing: 0.8, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 6),
                            for (final point in lesson.keyPoints)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.arrow_right_rounded, color: scheme.primary, size: 20),
                                    Expanded(child: Text(point, style: TextStyle(height: 1.4, color: scheme.onSurfaceVariant))),
                                  ],
                                ),
                              ),
                            const Divider(height: 24),
                            Text(l10n.text('academy.knowledgeCheck', 'KNOWLEDGE CHECK'),
                              style: TextStyle(color: scheme.primary, fontSize: 10, letterSpacing: 0.8, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 7),
                            Text(lesson.question, style: const TextStyle(fontWeight: FontWeight.w700, height: 1.4)),
                            const SizedBox(height: 8),
                            for (var index = 0; index < lesson.options.length; index++)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 7),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    onPressed: _completed.contains(lesson.id)
                                        ? null
                                        : () => _submitAnswer(lesson, index),
                                    style: OutlinedButton.styleFrom(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                      side: BorderSide(
                                        color: _answers[lesson.id] == index
                                            ? scheme.primary
                                            : scheme.outline.withValues(alpha: 0.6),
                                      ),
                                    ),
                                    child: Text(lesson.options[index], textAlign: TextAlign.left),
                                  ),
                                ),
                              ),
                            if (_answers.containsKey(lesson.id))
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Semantics(
                                  liveRegion: true,
                                  child: Text(
                                    _answers[lesson.id] == lesson.correctIndex
                                        ? '${l10n.text('academy.correct', 'Correct.')} ${lesson.explanation}'
                                        : l10n.text('academy.tryAgain', 'Not quite. Review the key points and try again.'), 
                                    style: TextStyle(
                                      color: _answers[lesson.id] == lesson.correctIndex
                                          ? scheme.primary
                                          : scheme.onSurfaceVariant,
                                      height: 1.4,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              )
                            else if (_completed.contains(lesson.id))
                              Text(l10n.text('academy.completed', 'Lesson completed.'),
                                style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ),
                ],
                const SizedBox(height: 12),
                Text(
                  l10n.text('academy.notice', 'ORVIKA Academy provides general educational guidance, not professional, legal or financial advice. Threats and platform settings change; verify important instructions with official sources. Completing a lesson does not certify expertise.'),
                  style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12, height: 1.45),
                ),
                  ],
                ),
              ),
            ),
    );
  }
}

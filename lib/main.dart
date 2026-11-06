import 'package:flutter/material.dart';

void main() {
  runApp(const OrvikaApp());
}

abstract final class OrvikaColors {
  static const obsidian = Color(0xFF081426);
  static const surface = Color(0xFF10233B);
  static const cyan = Color(0xFF00D5FF);
  static const violet = Color(0xFF795CFF);
  static const green = Color(0xFF20D69A);
  static const amber = Color(0xFFFFB547);
  static const muted = Color(0xFF9BAFC5);
}

class OrvikaApp extends StatelessWidget {
  const OrvikaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: OrvikaColors.cyan,
      brightness: Brightness.dark,
      surface: OrvikaColors.surface,
    );
    return MaterialApp(
      title: 'ORVIKA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: OrvikaColors.obsidian,
      ),
      home: const SentinelDashboard(),
    );
  }
}

class SentinelDashboard extends StatelessWidget {
  const SentinelDashboard({super.key});

  static const modules = <_SafetyModule>[
    _SafetyModule('Link Check', 'Inspect URLs before you open them', Icons.link_rounded, OrvikaColors.cyan, 'URL'),
    _SafetyModule('QR Check', 'Reveal and review QR destinations', Icons.qr_code_scanner_rounded, OrvikaColors.violet, 'QR'),
    _SafetyModule('Message Check', 'Review suspicious texts and emails', Icons.mark_email_unread_rounded, OrvikaColors.amber, 'SMS'),
    _SafetyModule('Privacy Check', 'Build safer everyday digital habits', Icons.shield_outlined, OrvikaColors.green, 'CARE'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0B1D34), OrvikaColors.obsidian, Color(0xFF10152C)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1120),
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        const _TopBar(),
                        const SizedBox(height: 34),
                        const _HeroPanel(),
                        const SizedBox(height: 30),
                        const Text('Your safety toolkit', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 5),
                        const Text('Verify first. Decide with confidence.', style: TextStyle(color: OrvikaColors.muted, fontSize: 13)),
                        const SizedBox(height: 16),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final columns = constraints.maxWidth >= 760 ? 4 : constraints.maxWidth >= 480 ? 2 : 1;
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: modules.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columns,
                                crossAxisSpacing: 14,
                                mainAxisSpacing: 14,
                                mainAxisExtent: 164,
                              ),
                              itemBuilder: (context, index) => _ModuleCard(module: modules[index]),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        const _TrustNote(),
                        const SizedBox(height: 22),
                        const Center(
                          child: Text(
                            'ORVIKA  •  CHECK BEFORE YOU TRUST',
                            style: TextStyle(color: OrvikaColors.muted, fontSize: 11, letterSpacing: 1.6, fontWeight: FontWeight.w600),
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

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(colors: [OrvikaColors.cyan, OrvikaColors.violet]),
            boxShadow: [BoxShadow(color: OrvikaColors.cyan.withValues(alpha: 0.18), blurRadius: 22)],
          ),
          child: const Icon(Icons.visibility_rounded, color: OrvikaColors.obsidian),
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ORVIKA', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 2.2)),
            Text('PERSONAL CYBER SAFETY INTELLIGENCE', style: TextStyle(fontSize: 8, color: OrvikaColors.muted, letterSpacing: 1.1)),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: OrvikaColors.green.withValues(alpha: 0.09),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: OrvikaColors.green.withValues(alpha: 0.35)),
          ),
          child: const Row(
            children: [
              Icon(Icons.lock_outline_rounded, size: 14, color: OrvikaColors.green),
              SizedBox(width: 6),
              Text('Privacy-first', style: TextStyle(fontSize: 12, color: OrvikaColors.green)),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: OrvikaColors.cyan.withValues(alpha: 0.22)),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF15334D), Color(0xFF101D36), Color(0xFF211D46)],
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 540;
          return Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('SEE THE RISK. VERIFY THE SIGNAL.', style: TextStyle(color: OrvikaColors.cyan, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.8)),
                    const SizedBox(height: 14),
                    const Text('Your digital world.\nA little more secure.', style: TextStyle(fontSize: 30, height: 1.12, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 12),
                    const Text('Check links, QR codes and suspicious messages before you trust them.', style: TextStyle(color: OrvikaColors.muted, height: 1.5, fontSize: 14)),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
                      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(12)),
                      child: const Text('CHECK BEFORE YOU TRUST.', style: TextStyle(fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
              if (!compact) ...[
                const SizedBox(width: 20),
                Container(
                  width: 132,
                  height: 132,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: OrvikaColors.cyan.withValues(alpha: 0.06),
                    border: Border.all(color: OrvikaColors.cyan.withValues(alpha: 0.25)),
                    boxShadow: [BoxShadow(color: OrvikaColors.violet.withValues(alpha: 0.18), blurRadius: 42, spreadRadius: 5)],
                  ),
                  child: const Icon(Icons.shield_moon_outlined, size: 72, color: OrvikaColors.cyan),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _SafetyModule {
  const _SafetyModule(this.title, this.subtitle, this.icon, this.color, this.label);

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String label;
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({required this.module});

  final _SafetyModule module;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: OrvikaColors.surface.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(color: module.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                child: Icon(module.icon, color: module.color, size: 21),
              ),
              const Spacer(),
              Text(module.label, style: TextStyle(color: module.color, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
            ],
          ),
          const Spacer(),
          Text(module.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 5),
          Text(module.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: OrvikaColors.muted, fontSize: 11, height: 1.35)),
        ],
      ),
    );
  }
}

class _TrustNote extends StatelessWidget {
  const _TrustNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: OrvikaColors.surface.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: OrvikaColors.cyan, size: 19),
          SizedBox(width: 11),
          Expanded(
            child: Text(
              'ORVIKA is an early prototype. Risk assessments will be evidence-led; an AI-generated suspicion will never be presented as a confirmed malicious verdict.',
              style: TextStyle(color: OrvikaColors.muted, fontSize: 12, height: 1.45),
            ),
          ),
        ],
      ),
    );
  }
}

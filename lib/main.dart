import 'package:flutter/material.dart';

void main() {
  runApp(const OrvikaApp());
}

class OrvikaApp extends StatelessWidget {
  const OrvikaApp({super.key});

  static const _navy = Color(0xFF081426);
  static const _cyan = Color(0xFF00D5FF);
  static const _violet = Color(0xFF795CFF);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ORVIKA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: _navy,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _cyan,
          brightness: Brightness.dark,
          surface: const Color(0xFF101F34),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF101F34),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFF263B55)),
          ),
        ),
      ),
      home: const SentinelHomePage(),
    );
  }
}

class SentinelHomePage extends StatelessWidget {
  const SentinelHomePage({super.key});

  static const _cyan = Color(0xFF00D5FF);
  static const _muted = Color(0xFF9FB1C8);

  void _announceComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature is planned and not active yet.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: const Row(
          children: [
            Icon(Icons.shield_moon_outlined, color: _cyan),
            SizedBox(width: 10),
            Text('ORVIKA', style: TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () => _announceComingSoon(context, 'Notifications'),
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 760;
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: wide ? 32 : 20,
                vertical: 20,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1080),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'PERSONAL CYBER SAFETY INTELLIGENCE',
                        style: TextStyle(
                          color: _cyan,
                          fontSize: 11,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Check before\nyou trust.',
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(
                          fontWeight: FontWeight.w800,
                          height: 1.08,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'A calmer, smarter way to make safer decisions online.',
                        style: TextStyle(color: _muted, fontSize: 15),
                      ),
                      const SizedBox(height: 28),
                      _TrustPanel(onTap: () {
                        _announceComingSoon(context, 'Security assessment');
                      }),
                      const SizedBox(height: 28),
                      Text(
                        'YOUR SAFETY TOOLKIT',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: _muted,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 14),
                      GridView.count(
                        crossAxisCount: wide ? 4 : 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: wide ? 1.3 : 1.12,
                        children: [
                          _ToolTile(
                            icon: Icons.link_rounded,
                            title: 'Link Check',
                            subtitle: 'Inspect a URL',
                            onTap: () => _announceComingSoon(context, 'Link Check'),
                          ),
                          _ToolTile(
                            icon: Icons.qr_code_2_rounded,
                            title: 'QR Check',
                            subtitle: 'Inspect before scanning',
                            onTap: () => _announceComingSoon(context, 'QR Check'),
                          ),
                          _ToolTile(
                            icon: Icons.chat_bubble_outline_rounded,
                            title: 'Message Check',
                            subtitle: 'Review suspicious messages',
                            onTap: () => _announceComingSoon(context, 'Message Check'),
                          ),
                          _ToolTile(
                            icon: Icons.school_outlined,
                            title: 'Safety Academy',
                            subtitle: 'Learn practical defences',
                            onTap: () => _announceComingSoon(context, 'Safety Academy'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      const Center(
                        child: Text(
                          'ORVIKA  •  Online Risk Verification, Intelligence, Knowledge & Assistance',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: _muted, fontSize: 11),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TrustPanel extends StatelessWidget {
  const _TrustPanel({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF142E49), Color(0xFF182443), Color(0xFF211F48)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: const Color(0xFF31506B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.radar_rounded, color: Color(0xFF00D5FF), size: 22),
              SizedBox(width: 9),
              Text(
                'ORVIKA SENTINEL',
                style: TextStyle(
                  color: Color(0xFFB8EFFF),
                  letterSpacing: 1.4,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Pause. Inspect. Decide.',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Verify a digital signal before you act. Analysis tools are being built; no live security verdicts are issued in this preview.',
            style: TextStyle(color: Color(0xFFC1D0E1), height: 1.45),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: onTap,
            icon: const Icon(Icons.arrow_forward_rounded),
            label: const Text('Explore safety tools'),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF00AFCF),
              foregroundColor: const Color(0xFF041321),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolTile extends StatelessWidget {
  const _ToolTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: const Color(0xFF00D5FF), size: 26),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: Color(0xFF9FB1C8), fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

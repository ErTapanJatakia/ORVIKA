import 'orvika_analytics_stub.dart'
    if (dart.library.js_interop) 'orvika_analytics_web.dart' as platform;

/// Privacy-limited product analytics. Only fixed event names and allowlisted
/// module labels are emitted; user-entered content is never accepted.
abstract final class OrvikaAnalytics {
  static const supportedModules = <String>{
    'Link Check', 'QR Check', 'Message Check', 'Intelligence',
    'Privacy', 'Academy', 'Response',
  };

  static bool supportsModule(String module) => supportedModules.contains(module);

  static void moduleOpened(String module) {
    if (!supportsModule(module)) return;
    platform.track('module_opened', module);
  }
}

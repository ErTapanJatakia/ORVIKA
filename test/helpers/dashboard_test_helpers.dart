import 'package:flutter_test/flutter_test.dart';

/// Scrolls the dashboard's lazy sliver content into the widget tree before
/// tests look up module cards or the dashboard section heading.
Future<void> revealDashboardContent(WidgetTester tester) async {
  final dashboard = find.byType(CustomScrollView);
  if (dashboard.evaluate().isEmpty) return;
  await tester.drag(dashboard, const Offset(0, -500));
  await tester.pumpAndSettle();
}

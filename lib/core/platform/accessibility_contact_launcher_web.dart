import 'package:web/web.dart' as web;

/// Opens the hosted accessibility statement and protected contact flow.
void openAccessibilityContact() {
  web.window.open('/accessibility-contact.html', '_blank', 'noopener');
}

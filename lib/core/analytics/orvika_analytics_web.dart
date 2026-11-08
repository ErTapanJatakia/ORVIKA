import 'dart:js_interop';

@JS('window.orvikaAnalyticsTrack')
external void _sendAnalyticsEvent(String eventName, String moduleName);

void track(String eventName, String moduleName) {
  _sendAnalyticsEvent(eventName, moduleName);
}

/// Supplemental QR format labels for the six-priority locale audit.
class QrFeatureTranslationOverrides {
  static const Map<String, Map<String, String>> values = {
    'de': {
      'checker.qr.detectedFormat': 'Erkanntes Codeformat: {format}',
    },
    'fr': {
      'checker.qr.detectedFormat': 'Format de code détecté : {format}',
    },
    'it': {
      'checker.qr.detectedFormat': 'Formato del codice rilevato: {format}',
    },
    'es': {
      'checker.qr.detectedFormat': 'Formato de código detectado: {format}',
    },
  };
}

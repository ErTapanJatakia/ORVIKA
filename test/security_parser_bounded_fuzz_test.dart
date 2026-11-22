import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/features/link_check/domain/url_analyzer.dart';
import 'package:orvika/features/message_check/domain/message_analyzer.dart';
import 'package:orvika/features/qr_check/domain/qr_payload_analyzer.dart';

/// Deterministic, resource-bounded property-style fuzzing for the three
/// user-controlled text parsers. No network access or external services.
void main() {
  const urlAnalyzer = UrlAnalyzer();
  const messageAnalyzer = MessageAnalyzer();
  const qrAnalyzer = QrPayloadAnalyzer();

  final alphabet = <String>[
    'a', 'Z', '0', '.', '/', ':', '?', '#', '@', '%', '&', '=', '+', '-',
    '_', '\\', '<', '>', '"', "'", ' ', '\t', '\n', '\u0000',
    '\u007f', '\u200b', '\u202e', '\u2066', 'अ', 'م', 'я', '🔐',
    'https://', 'hxxps://', 'javascript:', 'upi://pay?', 'WIFI:', 'mailto:',
    'tel:', 'BEGIN:VCARD', 'BEGIN:VEVENT',
  ];

  String generate(Random random, int maxLength) {
    final length = random.nextInt(maxLength + 1);
    final output = StringBuffer();
    var remaining = length;
    while (remaining > 0) {
      final token = alphabet[random.nextInt(alphabet.length)];
      final chunk = token.length <= remaining ? token : token.substring(0, remaining);
      output.write(chunk);
      remaining -= chunk.length;
    }
    return output.toString();
  }

  test('seeded URL, message and QR fuzz corpus is deterministic and bounded', () {
    final random = Random(0x4f525649); // Stable seed for reproducible regressions.
    for (var i = 0; i < 192; i++) {
      final input = generate(random, 1024);

      final urlFirst = urlAnalyzer.analyze(input);
      final urlSecond = urlAnalyzer.analyze(input);
      expect(urlFirst.isValid, urlSecond.isValid, reason: 'URL case $i');
      expect(urlFirst.normalizedUrl, urlSecond.normalizedUrl, reason: 'URL case $i');
      expect(urlFirst.findings.map((f) => (f.title, f.detail, f.severity)).toList(),
          urlSecond.findings.map((f) => (f.title, f.detail, f.severity)).toList(),
          reason: 'URL case $i');
      expect(urlFirst.input.length, lessThanOrEqualTo(1024));

      final messageFirst = messageAnalyzer.analyze(input);
      final messageSecond = messageAnalyzer.analyze(input);
      expect(messageFirst.isValid, messageSecond.isValid, reason: 'Message case $i');
      expect(messageFirst.detectedLinks, messageSecond.detectedLinks,
          reason: 'Message case $i');
      expect(messageFirst.detectedContacts, messageSecond.detectedContacts,
          reason: 'Message case $i');
      expect(messageFirst.findings.map((f) => (f.title, f.detail, f.severity)).toList(),
          messageSecond.findings.map((f) => (f.title, f.detail, f.severity)).toList(),
          reason: 'Message case $i');
      expect(messageFirst.detectedLinks.length, lessThanOrEqualTo(input.length));

      final qrFirst = qrAnalyzer.analyze(input);
      final qrSecond = qrAnalyzer.analyze(input);
      expect(qrFirst.kind, qrSecond.kind, reason: 'QR case $i');
      expect(qrFirst.isValid, qrSecond.isValid, reason: 'QR case $i');
      expect(qrFirst.normalizedUrl, qrSecond.normalizedUrl, reason: 'QR case $i');
      expect(qrFirst.title, qrSecond.title, reason: 'QR case $i');
      expect(qrFirst.detail, qrSecond.detail, reason: 'QR case $i');
      expect(qrFirst.linkFindings.map((f) => (f.title, f.detail, f.severity)).toList(),
          qrSecond.linkFindings.map((f) => (f.title, f.detail, f.severity)).toList(),
          reason: 'QR case $i');
    }
  });

  test('hard input ceilings reject oversized content before parsing', () {
    final oversizedUrl = 'https://example.test/${'a' * 8193}';
    final oversizedQr = 'a' * 8193;
    final oversizedMessage = 'a' * 10001;

    expect(urlAnalyzer.analyze(oversizedUrl).isValid, isFalse);
    expect(qrAnalyzer.analyze(oversizedQr).isValid, isFalse);
    expect(messageAnalyzer.analyze(oversizedMessage).isValid, isFalse);
  });
}

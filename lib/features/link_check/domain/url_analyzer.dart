enum FindingSeverity { info, caution, warning }

class LinkFinding {
  const LinkFinding({required this.title, required this.detail, required this.severity});
  final String title;
  final String detail;
  final FindingSeverity severity;
}

class LinkAnalysisResult {
  const LinkAnalysisResult({required this.input, required this.normalizedUrl, required this.findings, required this.isValid, required this.notice});
  final String input;
  final String? normalizedUrl;
  final List<LinkFinding> findings;
  final bool isValid;
  final String notice;
}

/// Performs local, deterministic URL-structure checks only.
/// It does not visit the URL, resolve DNS, follow redirects, or certify safety.
class UrlAnalyzer {
  const UrlAnalyzer();
  static final RegExp _ipv4 = RegExp(r'^(?:\d{1,3}\.){3}\d{1,3}$');

  LinkAnalysisResult analyze(String rawInput) {
    final input = rawInput.trim();
    if (input.isEmpty) return _invalid(rawInput, 'Enter a web address to inspect.');
    if (input.length > 2048) return _invalid(rawInput, 'The address is longer than the supported 2,048 characters.');
    if (RegExp(r'[\s\u0000-\u001F\u007F]').hasMatch(rawInput)) {
      return _invalid(rawInput, 'The address contains whitespace or control characters. Check it before continuing.');
    }

    final candidate = input.contains('://') ? input : 'https://$input';
    final uri = Uri.tryParse(candidate);
    if (uri == null || !uri.hasAuthority || uri.host.isEmpty) return _invalid(rawInput, 'The address could not be parsed as a web URL.');
    if (uri.scheme != 'http' && uri.scheme != 'https') return _invalid(rawInput, 'Only HTTP and HTTPS web addresses are supported.');

    final findings = <LinkFinding>[];
    final host = uri.host.toLowerCase();

    if (RegExp(r'[^\x00-\x7F]').hasMatch(host)) {
      findings.add(const LinkFinding(
        title: 'Unicode hostname',
        detail: 'The hostname contains non-ASCII characters. Check the internationalised domain carefully for visually similar characters and verify its exact spelling.',
        severity: FindingSeverity.caution,
      ));
    }
    if (uri.scheme == 'http') {
      findings.add(const LinkFinding(
        title: 'Unencrypted connection',
        detail: 'This address uses HTTP. Data exchanged with the site may not be protected in transit.',
        severity: FindingSeverity.warning,
      ));
    }
    if (uri.userInfo.isNotEmpty) {
      findings.add(const LinkFinding(
        title: 'Embedded sign-in information',
        detail: 'The address contains user information before the host. This can make the displayed destination misleading.',
        severity: FindingSeverity.warning,
      ));
    }
    if (host.contains('xn--')) {
      findings.add(const LinkFinding(
        title: 'Internationalised domain encoding',
        detail: 'The hostname contains Punycode. Verify the displayed domain carefully for look-alike characters.',
        severity: FindingSeverity.caution,
      ));
    }
    if (_ipv4.hasMatch(host)) {
      final octets = host.split('.').map(int.tryParse).toList();
      if (octets.every((part) => part != null && part >= 0 && part <= 255)) {
        findings.add(const LinkFinding(
          title: 'IP-address destination',
          detail: 'The address points directly to an IPv4 literal rather than a named domain. This is not inherently malicious, but deserves verification.',
          severity: FindingSeverity.caution,
        ));
      } else {
        findings.add(const LinkFinding(
          title: 'Malformed IPv4-looking hostname',
          detail: 'The hostname resembles a dotted IPv4 address but contains an out-of-range octet. Do not assume it identifies the intended destination.',
          severity: FindingSeverity.warning,
        ));
      }
    } else if (RegExp(r'^[0-9.]+$').hasMatch(host) && host.contains('.')) {
      findings.add(const LinkFinding(
        title: 'Unusual numeric hostname',
        detail: 'The hostname is numeric but is not a standard four-octet IPv4 address. Some clients may interpret unusual numeric forms differently.',
        severity: FindingSeverity.warning,
      ));
    }

    final labels = host.split('.');
    if (labels.length >= 4) {
      findings.add(const LinkFinding(
        title: 'Long subdomain chain',
        detail: 'The hostname contains multiple subdomain levels. Read the registrable domain carefully; a familiar brand name in a subdomain does not establish who controls the destination.',
        severity: FindingSeverity.caution,
      ));
    }
    if (uri.hasPort && uri.port != 80 && uri.port != 443) {
      findings.add(LinkFinding(
        title: 'Non-standard port',
        detail: 'The address uses port ${uri.port}, rather than the usual HTTP or HTTPS port.',
        severity: FindingSeverity.caution,
      ));
    }
    if (uri.hasFragment && uri.fragment.isNotEmpty) {
      findings.add(const LinkFinding(
        title: 'Fragment present',
        detail: 'The address includes a fragment. It is part of the supplied URL and may affect the page or client-side routing.',
        severity: FindingSeverity.info,
      ));
    }
    if (findings.isEmpty) {
      findings.add(const LinkFinding(
        title: 'No structural warning detected',
        detail: 'The address passed these basic local checks. This does not establish that the website is trustworthy or safe.',
        severity: FindingSeverity.info,
      ));
    }
    return LinkAnalysisResult(
      input: rawInput,
      normalizedUrl: uri.toString(),
      findings: List.unmodifiable(findings),
      isValid: true,
      notice: 'Local structure checks only. No network request or reputation lookup was performed.',
    );
  }

  LinkAnalysisResult _invalid(String input, String message) => LinkAnalysisResult(
    input: input,
    normalizedUrl: null,
    findings: [LinkFinding(title: 'Address not analysed', detail: message, severity: FindingSeverity.warning)],
    isValid: false,
    notice: 'No network request was made.',
  );
}
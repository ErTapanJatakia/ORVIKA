import '../../features/link_check/domain/url_analyzer.dart';
import '../../features/qr_check/domain/qr_payload_analyzer.dart';

/// Hindi wording for deterministic checker findings.
/// Analyzer signals, severity and payload semantics remain unchanged.
class HindiCheckerContent {
  HindiCheckerContent._();

  static const Map<String, ({String title, String detail})> _findings = {
    'Unicode hostname': (
      title: 'यूनिकोड होस्टनाम',
      detail: 'होस्टनाम में ASCII के बाहर के अक्षर हैं। मिलते-जुलते दिखने वाले अक्षरों और सही वर्तनी की जाँच के लिए अंतरराष्ट्रीयकृत डोमेन को ध्यान से देखें।',
    ),
    'Unencrypted connection': (
      title: 'एन्क्रिप्शन रहित कनेक्शन',
      detail: 'यह पता HTTP का उपयोग करता है। भेजा गया डेटा संचार के दौरान सुरक्षित न हो सकता है।',
    ),
    'Embedded sign-in information': (
      title: 'पते में शामिल लॉगिन जानकारी',
      detail: 'होस्टनाम से पहले पते में उपयोगकर्ता की जानकारी मौजूद है। इससे वास्तविक गंतव्य के बारे में भ्रम हो सकता है।',
    ),
    'Internationalised domain encoding': (
      title: 'अंतरराष्ट्रीयकृत डोमेन का एन्कोडेड रूप',
      detail: 'होस्टनाम में Punycode है। मिलते-जुलते दिखने वाले अक्षरों के लिए प्रदर्शित डोमेन की सावधानी से जाँच करें।',
    ),
    'IP-address destination': (
      title: 'IP पते पर जाने वाला गंतव्य',
      detail: 'यह पता किसी नामित डोमेन के बजाय सीधे IPv4 पते पर जाता है। यह अपने-आप में दुर्भावनापूर्ण नहीं है, फिर भी इसकी जाँच करें।',
    ),
    'Malformed IPv4-looking hostname': (
      title: 'IPv4 जैसा दिखने वाला अमान्य होस्टनाम',
      detail: 'होस्टनाम बिंदुओं वाला IPv4 पता दिखता है, लेकिन इसमें अनुमत सीमा से बाहर का ऑक्टेट है। यह न मानें कि यह अपेक्षित गंतव्य पर ही जाएगा।',
    ),
    'Unusual numeric hostname': (
      title: 'असामान्य संख्यात्मक होस्टनाम',
      detail: 'होस्टनाम संख्यात्मक है, लेकिन चार ऑक्टेट वाले सामान्य IPv4 पते जैसा नहीं है। कुछ क्लाइंट ऐसे असामान्य प्रारूपों की अलग-अलग व्याख्या कर सकते हैं।',
    ),
    'Long subdomain chain': (
      title: 'सबडोमेन की लंबी श्रृंखला',
      detail: 'होस्टनाम में सबडोमेन के कई स्तर हैं। पंजीकरण योग्य डोमेन की जाँच करें; सबडोमेन में किसी परिचित ब्रांड का नाम होना गंतव्य पर उसके नियंत्रण का प्रमाण नहीं है।',
    ),
    'Non-standard port': (
      title: 'गैर-मानक पोर्ट',
      detail: 'यह पता सामान्य HTTP या HTTPS पोर्ट के बजाय पोर्ट {port} का उपयोग करता है।',
    ),
    'Fragment present': (
      title: 'URL में फ़्रैगमेंट मौजूद है',
      detail: 'पते में फ़्रैगमेंट शामिल है। यह दिए गए URL का हिस्सा है और पेज या क्लाइंट-साइड रूटिंग को प्रभावित कर सकता है।',
    ),
    'No structural warning detected': (
      title: 'कोई संरचनात्मक चेतावनी नहीं मिली',
      detail: 'पते ने ये बुनियादी स्थानीय जाँचें पूरी कर लीं। इससे यह साबित नहीं होता कि वेबसाइट भरोसेमंद या सुरक्षित है।',
    ),
    'Address not analysed': (
      title: 'पते का विश्लेषण नहीं हुआ',
      detail: 'वेब पते का विश्लेषण नहीं किया जा सका। इनपुट जाँचें और फिर प्रयास करें।',
    ),
    'Urgency or pressure language': (
      title: 'जल्दबाज़ी या दबाव बनाने वाली भाषा',
      detail: 'संदेश समय का दबाव बनाता है या तुरंत कार्रवाई करने को कहता है। रुकें और किसी अलग, भरोसेमंद माध्यम से अनुरोध की पुष्टि करें।',
    ),
    'Credential or sign-in request': (
      title: 'लॉगिन या प्रमाण-पत्र माँगने का अनुरोध',
      detail: 'ऐसा लगता है कि संदेश पासवर्ड, लॉगिन या खाते के सत्यापन की माँग करता है। संदेश में दिए गए लिंक से अपने लॉगिन विवरण दर्ज न करें।',
    ),
    'OTP or authentication-code reference': (
      title: 'OTP या प्रमाणीकरण कोड का उल्लेख',
      detail: 'संदेश में वन-टाइम पासवर्ड या प्रमाणीकरण कोड का उल्लेख है। किसी को भी OTP या रिकवरी कोड न बताएँ और अनपेक्षित लॉगिन अनुरोधों की पुष्टि न करें।',
    ),
    'Payment or financial action': (
      title: 'भुगतान या वित्तीय कार्रवाई',
      detail: 'संदेश में भुगतान, धन हस्तांतरण, रिफंड, शुल्क या किसी अन्य वित्तीय कार्रवाई का उल्लेख है। आगे बढ़ने से पहले प्राप्तकर्ता और राशि की स्वतंत्र रूप से पुष्टि करें।',
    ),
    'Prize or unexpected reward': (
      title: 'इनाम या अप्रत्याशित पुरस्कार',
      detail: 'संदेश में अप्रत्याशित इनाम या पुरस्कार का उल्लेख है। उसे पाने के लिए शुल्क या निजी जानकारी माँगे जाने पर सावधान रहें।',
    ),
    'Threat or consequence language': (
      title: 'धमकी या परिणाम भुगतने की चेतावनी',
      detail: 'संदेश जुर्माने, कानूनी कार्रवाई, गिरफ्तारी या पहुँच खोने की धमकी देता है। संबंधित संस्था के स्वतंत्र रूप से प्राप्त संपर्क विवरण से ऐसे दावों की पुष्टि करें।',
    ),
    'Obfuscated web address detected': (
      title: 'छिपाया गया वेब पता मिला',
      detail: 'संदेश में hxxp या hxxps जैसे बदले हुए स्कीम वाला लिंक है। इसे हाथ से जाँचने योग्य पता मानें; इसे न तो सामान्यीकृत किया गया है और न ही खोला गया है।',
    ),
    'Link or web address detected': (
      title: 'लिंक या वेब पता मिला',
      detail: '{count} वेब पते मिले। दिखाई देने वाला लिंक किसी दूसरे गंतव्य पर ले जा सकता है। हर पते को अलग से जाँचें।',
    ),
    'No listed social-engineering cues detected': (
      title: 'सूचीबद्ध सोशल इंजीनियरिंग संकेत नहीं मिले',
      detail: 'यह पाठ इस संस्करण के सीमित पैटर्न से मेल नहीं खाता। हानिकारक संदेश सामान्य दिख सकते हैं या ऐसी भाषा इस्तेमाल कर सकते हैं जिसे यह जाँच नहीं पहचानती।',
    ),
    'Message not analysed': (
      title: 'संदेश का विश्लेषण नहीं हुआ',
      detail: 'संदेश का विश्लेषण नहीं किया जा सका। पाठ जाँचें और फिर प्रयास करें।',
    ),
  };

  static LinkFinding localizeFinding(LinkFinding finding, String languageCode) {
    if (languageCode != 'hi') return finding;
    final translated = _findings[finding.title];
    if (translated == null) return finding;
    var detail = translated.detail;
    final portMatch = RegExp(r'port (\d+)').firstMatch(finding.detail);
    final countMatch = RegExp(r'^(\d+) web address').firstMatch(finding.detail);
    if (portMatch != null) detail = detail.replaceAll('{port}', portMatch.group(1)!);
    if (countMatch != null) detail = detail.replaceAll('{count}', countMatch.group(1)!);
    return LinkFinding(
      title: translated.title,
      detail: detail,
      severity: finding.severity,
    );
  }

  static String localizeLinkNotice(String notice, String languageCode) {
    if (languageCode != 'hi') return notice;
    return notice == 'No network request was made.'
        ? 'कोई नेटवर्क अनुरोध नहीं किया गया।'
        : 'केवल स्थानीय संरचनात्मक जाँचें की गईं। कोई नेटवर्क अनुरोध या प्रतिष्ठा जाँच नहीं की गई।';
  }

  static String localizeMessageNotice(String languageCode) =>
      languageCode == 'hi'
          ? 'यहाँ केवल अनुमान-आधारित पाठ जाँचें की जाती हैं। कोई संदेश अपलोड नहीं किया गया, कोई लिंक नहीं खोला गया और भेजने वाले की पहचान या मंशा सत्यापित नहीं की गई।'
          : 'Heuristic text checks only. No message was uploaded, no link was opened, and no sender identity or intent was verified.';

  static QrPayloadAnalysis localizeQr(
    QrPayloadAnalysis result,
    String languageCode,
  ) {
    if (languageCode != 'hi') return result;
    const titles = <String, String>{
      'Wi-Fi configuration': 'Wi-Fi कॉन्फ़िगरेशन',
      'Contact card': 'संपर्क कार्ड',
      'Calendar event': 'कैलेंडर कार्यक्रम',
      'UPI payment request': 'UPI भुगतान अनुरोध',
      'Phone call action': 'फ़ोन कॉल कार्रवाई',
      'Email action': 'ईमेल कार्रवाई',
      'Text-message action': 'SMS कार्रवाई',
      'Location coordinates': 'स्थान निर्देशांक',
      'Application-specific link': 'ऐप-विशिष्ट लिंक',
      'Plain text': 'साधारण पाठ',
      'Web address': 'वेब पता',
      'Unrecognised web address': 'अपरिचित वेब पता',
      'QR content not analysed': 'QR सामग्री का विश्लेषण नहीं हुआ',
    };
    const details = <String, String>{
      'Wi-Fi configuration': 'इस QR सामग्री में नेटवर्क का नाम, सुरक्षा प्रकार और Wi-Fi पासवर्ड हो सकता है। नेटवर्क से जुड़ने से पहले उसकी जाँच करें; ORVIKA अपने-आप कनेक्ट नहीं करता।',
      'Contact card': 'इस सामग्री में संपर्क विवरण हैं। सहेजने से पहले नाम, फ़ोन नंबर, ईमेल पते और संगठन की जानकारी जाँचें।',
      'Calendar event': 'यह सामग्री कैलेंडर कार्यक्रम बताती है। आयात करने से पहले शीर्षक, स्थान, समय और शामिल लिंक जाँचें।',
      'UPI payment request': 'यह QR सामग्री UPI ऐप में भुगतान तैयार कर सकती है। UPI ID, प्राप्तकर्ता का नाम और राशि की स्वतंत्र रूप से पुष्टि करें। ORVIKA भुगतान शुरू या अधिकृत नहीं करता।',
      'Phone call action': 'इस सामग्री में फ़ोन कॉल की कार्रवाई है। नंबर की स्वतंत्र रूप से पुष्टि करें; ORVIKA कॉल नहीं करता।',
      'Email action': 'यह सामग्री ईमेल प्राप्तकर्ता या संदेश का पाठ पहले से भर सकती है। भेजने से पहले सभी फ़ील्ड जाँचें; ORVIKA ईमेल ऐप नहीं खोलता।',
      'Text-message action': 'यह सामग्री प्राप्तकर्ता या संदेश पहले से भर सकती है। भेजने से पहले नंबर और पाठ जाँचें; ORVIKA SMS नहीं भेजता।',
      'Location coordinates': 'इस सामग्री में स्थान का संदर्भ है। उपयोग करने से पहले निर्देशांक और संदर्भ जाँचें; ORVIKA मैप नहीं खोलता।',
      'Application-specific link': 'यह सामग्री सामान्य वेब URL के बजाय “{scheme}:” स्कीम का उपयोग करती है। इससे कोई ऐप या कार्रवाई शुरू हो सकती है। इसे तभी खोलें जब स्वतंत्र रूप से स्रोत पर भरोसा हो।',
      'Plain text': 'इस QR सामग्री में पहचाने गए वेब पते या कार्रवाई के बजाय पाठ है। इसे ध्यान से पढ़ें; पाठ में भ्रामक निर्देश या संवेदनशील जानकारी भी हो सकती है।',
      'Web address': 'एक वेब गंतव्य मिला। आगे क्या करना है, यह तय करने से पहले नीचे दिए गए संरचनात्मक संकेत जाँचें। गंतव्य को न खोला गया है और न ही उससे संपर्क किया गया है।',
      'Unrecognised web address': 'वेब पता पहचाना नहीं जा सका। आगे बढ़ने से पहले इसमें मौजूद संकेतों की जाँच करें।',
      'QR content not analysed': 'QR सामग्री का विश्लेषण नहीं किया जा सका। इनपुट जाँचें और फिर प्रयास करें।',
    };
    var detail = details[result.title] ?? result.detail;
    final schemeMatch =
        RegExp(r'([a-zA-Z][a-zA-Z0-9+.-]*):').firstMatch(result.detail);
    if (schemeMatch != null) {
      detail = detail.replaceAll('{scheme}', schemeMatch.group(1)!);
    }
    return QrPayloadAnalysis(
      kind: result.kind,
      title: titles[result.title] ?? result.title,
      detail: detail,
      severity: result.severity,
      normalizedUrl: result.normalizedUrl,
      linkFindings: result.linkFindings
          .map((finding) => localizeFinding(finding, languageCode))
          .toList(growable: false),
      isValid: result.isValid,
    );
  }
}

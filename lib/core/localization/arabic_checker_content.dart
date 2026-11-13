import '../../features/link_check/domain/url_analyzer.dart';
import '../../features/qr_check/domain/qr_payload_analyzer.dart';

/// Arabic wording for deterministic checker results. Stable IDs, severity,
/// parsing, and analysis behaviour remain canonical.
class ArabicCheckerContent {
  ArabicCheckerContent._();

  static const Map<String, ({String title, String detail})> _findings = {
    'Unicode hostname': (title: 'اسم المضيف يحتوي على محارف Unicode', detail: 'يحتوي اسم المضيف على محارف غير ASCII. افحص اسم النطاق الدولي بعناية بحثاً عن محارف متشابهة بصرياً وتأكد من التهجئة الدقيقة.'),
    'Unencrypted connection': (title: 'اتصال غير مشفّر', detail: 'يستخدم هذا العنوان بروتوكول HTTP. قد لا تكون البيانات المتبادلة محمية أثناء النقل.'),
    'Embedded sign-in information': (title: 'معلومات تسجيل الدخول مضمنة في العنوان', detail: 'يتضمن العنوان معلومات مستخدم قبل اسم المضيف. قد يؤدي ذلك إلى إظهار وجهة مضللة.'),
    'Internationalised domain encoding': (title: 'ترميز اسم نطاق دولي', detail: 'يحتوي اسم المضيف على Punycode. افحص النطاق المعروض بحثاً عن محارف متشابهة بصرياً.'),
    'IP-address destination': (title: 'الوجهة محددة بعنوان IP', detail: 'يشير العنوان مباشرة إلى عنوان IPv4 بدلاً من اسم نطاق. لا يعني ذلك بالضرورة أنه ضار، لكنه يستحق التحقق.'),
    'Malformed IPv4-looking hostname': (title: 'اسم مضيف غير سليم يشبه عنوان IPv4', detail: 'يشبه اسم المضيف عنوان IPv4 منقوطاً، لكنه يحتوي على جزء يتجاوز النطاق المسموح. لا تفترض أنه يقود إلى الوجهة المتوقعة.'),
    'Unusual numeric hostname': (title: 'اسم مضيف رقمي غير مألوف', detail: 'يتكون اسم المضيف من أرقام، لكنه لا يطابق عنوان IPv4 تقليدياً بأربعة أجزاء. قد تفسّر بعض البرامج الصيغ الرقمية غير المعتادة بطرق مختلفة.'),
    'Long subdomain chain': (title: 'سلسلة طويلة من النطاقات الفرعية', detail: 'يحتوي اسم المضيف على مستويات متعددة من النطاقات الفرعية. تحقّق من النطاق المسجّل؛ فوجود اسم علامة معروفة ضمن نطاق فرعي لا يثبت الجهة التي تتحكم بالوجهة.'),
    'Non-standard port': (title: 'منفذ غير قياسي', detail: 'يستخدم هذا العنوان المنفذ {port} بدلاً من منفذ HTTP أو HTTPS المعتاد.'),
    'Fragment present': (title: 'وجود جزء لاحق في عنوان URL', detail: 'يتضمن العنوان جزءاً لاحقاً. وهو جزء من عنوان URL المقدّم وقد يؤثر في الصفحة أو التوجيه داخل المتصفح.'),
    'No structural warning detected': (title: 'لم يُكتشف تحذير بنيوي', detail: 'اجتاز العنوان هذه الفحوصات المحلية الأساسية. لا يثبت ذلك أن الموقع موثوق أو آمن.'),
    'Address not analysed': (title: 'لم يُحلّل العنوان', detail: 'تعذّر تحليل عنوان الويب. راجع القيمة التي أدخلتها ثم حاول مرة أخرى.'),
    'Urgency or pressure language': (title: 'لغة الاستعجال أو الضغط', detail: 'تخلق الرسالة شعوراً بالإلحاح أو تطلب إجراءً فورياً. توقّف قليلاً وتحقّق من الطلب عبر قناة موثوقة أخرى.'),
    'Credential or sign-in request': (title: 'طلب بيانات اعتماد أو تسجيل دخول', detail: 'يبدو أن النص يطلب كلمة مرور أو تسجيل دخول أو التحقق من حساب. لا تُدخل بيانات الاعتماد عبر رابط ورد في رسالة.'),
    'OTP or authentication-code reference': (title: 'إشارة إلى رمز OTP أو رمز مصادقة', detail: 'تذكر الرسالة كلمة مرور لمرة واحدة أو رمز مصادقة. لا تشارك أبداً رمز OTP أو الاسترداد، ولا توافق على طلب مصادقة لم تبدأه.'),
    'Payment or financial action': (title: 'إجراء مالي أو متعلق بالدفع', detail: 'تتعلق الرسالة بدفع أو تحويل أو استرداد أو رسوم أو إجراء مالي آخر. تحقّق بشكل مستقل من المستفيد والمبلغ قبل المتابعة.'),
    'Prize or unexpected reward': (title: 'جائزة أو مكافأة غير متوقعة', detail: 'تذكر الرسالة جائزة أو مكافأة غير متوقعة. احذر طلب الرسوم أو البيانات الشخصية للمطالبة بها.'),
    'Threat or consequence language': (title: 'لغة تهديد أو التلويح بعواقب', detail: 'تهدد الرسالة بعقوبة أو إجراء قانوني أو سجن أو فقدان الوصول. تحقّق من الادعاءات باستخدام بيانات اتصال حصلت عليها من الجهة بشكل مستقل.'),
    'Obfuscated web address detected': (title: 'اكتُشف عنوان ويب مخفي الصياغة', detail: 'تتضمن الرسالة رابطاً استُبدل مخططه، مثل hxxp أو hxxps. تعامل معه كعنوان يحتاج إلى مراجعة يدوية؛ لم تتم تسويته أو فتحه.'),
    'Link or web address detected': (title: 'اكتُشف رابط أو عنوان ويب', detail: 'تم العثور على {count} من عناوين الويب. قد يخفي الرابط الظاهر وجهة مختلفة. تحقّق من كل عنوان على حدة قبل فتحه.'),
    'No listed social-engineering cues detected': (title: 'لم تُكتشف مؤشرات الهندسة الاجتماعية المدرجة', detail: 'لا يطابق النص الأنماط المحدودة في هذا الإصدار. قد تبدو الرسائل الضارة عادية أو تستخدم عبارات لا تكشفها هذه الفحوصات.'),
    'Message not analysed': (title: 'لم تُحلّل الرسالة', detail: 'تعذّر تحليل الرسالة. راجع النص الذي أدخلته ثم حاول مرة أخرى.'),
  };

  static LinkFinding localizeFinding(LinkFinding finding, String code) {
    if (code != 'ar') return finding;
    final translated = _findings[finding.title];
    if (translated == null) return finding;
    var detail = translated.detail;
    final port = RegExp(r'port (\d+)').firstMatch(finding.detail);
    final count = RegExp(r'^(\d+) web address').firstMatch(finding.detail);
    if (port != null) detail = detail.replaceAll('{port}', port.group(1)!);
    if (count != null) detail = detail.replaceAll('{count}', count.group(1)!);
    return LinkFinding(title: translated.title, detail: detail, severity: finding.severity);
  }

  static String localizeLinkNotice(String notice, String code) {
    if (code != 'ar') return notice;
    if (notice == 'No network request was made.') return 'لم يتم إجراء أي طلب عبر الشبكة.';
    return 'أُجريت فحوصات بنيوية محلية فقط. لم يتم إجراء طلب عبر الشبكة أو التحقق من سمعة الموقع.';
  }

  static String localizeMessageNotice(String code) => code == 'ar'
      ? 'فحوصات استدلالية للنص فقط. لم تُرفع أي رسالة، ولم يُفتح أي رابط، ولم يتم التحقق من هوية المرسل أو نيته.'
      : 'Heuristic text checks only. No message was uploaded, no link was opened, and no sender identity or intent was verified.';

  static QrPayloadAnalysis localizeQr(QrPayloadAnalysis result, String code) {
    if (code != 'ar') return result;
    const titles = <String, String>{
      'Wi-Fi configuration': 'إعداد شبكة Wi-Fi',
      'Contact card': 'بطاقة جهة اتصال',
      'Calendar event': 'حدث في التقويم',
      'UPI payment request': 'طلب دفع عبر UPI',
      'Phone call action': 'إجراء اتصال هاتفي',
      'Email action': 'إجراء بريد إلكتروني',
      'Text-message action': 'إجراء رسالة نصية',
      'Location coordinates': 'إحداثيات موقع',
      'Application-specific link': 'رابط خاص بتطبيق',
      'Plain text': 'نص عادي',
      'Web address': 'عنوان ويب',
      'Unrecognised web address': 'عنوان ويب غير معروف',
      'QR content not analysed': 'لم يُحلّل محتوى QR',
    };
    const details = <String, String>{
      'Wi-Fi configuration': 'قد يتضمن محتوى QR اسم الشبكة ونوع الحماية وكلمة مرور Wi-Fi. تحقّق من الشبكة قبل الاتصال؛ لا يتصل ORVIKA تلقائياً.',
      'Contact card': 'يتضمن هذا المحتوى بيانات جهة اتصال. تحقّق من الأسماء وأرقام الهواتف والبريد الإلكتروني ومعلومات المؤسسة قبل الحفظ.',
      'Calendar event': 'يصف هذا المحتوى حدثاً في التقويم. تحقّق من العنوان والموقع والأوقات والروابط المضمنة قبل الاستيراد.',
      'UPI payment request': 'قد يجهّز محتوى QR دفعة في تطبيق UPI. تحقّق بشكل مستقل من معرّف UPI واسم المستفيد والمبلغ. لا يبدأ ORVIKA المدفوعات ولا يصرّح بها.',
      'Phone call action': 'يتضمن هذا المحتوى إجراء اتصال. تحقّق من الرقم بشكل مستقل؛ لا يجري ORVIKA مكالمات.',
      'Email action': 'قد يملأ هذا المحتوى مستلماً أو نص رسالة بريد إلكتروني. راجع جميع الحقول قبل الإرسال؛ لا يفتح ORVIKA تطبيقات البريد.',
      'Text-message action': 'قد يملأ هذا المحتوى مستلماً أو نص رسالة. تحقّق من الرقم والنص قبل الإرسال؛ لا يرسل ORVIKA رسائل SMS.',
      'Location coordinates': 'يتضمن هذا المحتوى إحداثيات موقع. تحقّق من الإحداثيات والسياق قبل استخدامها؛ لا يفتح ORVIKA الخرائط.',
      'Application-specific link': 'يستخدم هذا المحتوى مخططاً مثل {scheme}: بدلاً من عنوان ويب عادي. قد يشغّل تطبيقاً أو إجراءً. لا تفتحه إلا بعد التحقق المستقل من المصدر.',
      'Plain text': 'يحتوي رمز QR على نص بدلاً من عنوان ويب أو إجراء معروف. افحصه بعناية؛ فقد يتضمن النص تعليمات مضللة أو معلومات حساسة.',
      'Web address': 'تم اكتشاف وجهة ويب. تحقّق من النطاق والمسار قبل فتح الرابط.',
      'Unrecognised web address': 'يبدو المحتوى كعنوان ويب، لكن تعذّر تفسيره بثقة. لا تفتحه قبل التحقق من الوجهة.',
      'QR content not analysed': 'تعذّر تحليل محتوى QR. راجع الرمز أو الصورة ثم حاول مرة أخرى.',
    };
    final title = titles[result.title] ?? result.title;
    var detail = details[result.title] ?? result.detail;
    final scheme = RegExp(r'([a-zA-Z][a-zA-Z0-9+.-]*):').firstMatch(result.detail);
    if (scheme != null) detail = detail.replaceAll('{scheme}', scheme.group(1)!);
    return QrPayloadAnalysis(
      title: title,
      detail: detail,
      severity: result.severity,
      kind: result.kind,
      normalizedUrl: result.normalizedUrl,
      linkFindings: result.linkFindings
          .map((finding) => localizeFinding(finding, code))
          .toList(growable: false),
      isValid: result.isValid,
    );
  }
}

import '../../features/link_check/domain/url_analyzer.dart';
import '../../features/qr_check/domain/qr_payload_analyzer.dart';

/// Simplified Chinese wording for deterministic checker results.
/// Stable identifiers, severity, parsing and analysis behaviour are unchanged.
class MandarinCheckerContent {
  MandarinCheckerContent._();
  static const Map<String, ({String title, String detail})> _findings = {
    'Unicode hostname': (title: '主机名包含 Unicode 字符', detail: '主机名包含非 ASCII 字符。请仔细检查国际化域名中的相似字符，并确认拼写准确。'),
    'Unencrypted connection': (title: '连接未加密', detail: '该地址使用 HTTP。传输中的数据可能未受到保护。'),
    'Embedded sign-in information': (title: '地址中嵌入了登录信息', detail: '主机名前包含用户信息，这可能会掩盖实际访问目标。'),
    'Internationalised domain encoding': (title: '国际化域名编码', detail: '主机名包含 Punycode。请检查显示的域名是否存在容易混淆的相似字符。'),
    'IP-address destination': (title: '目标使用 IP 地址', detail: '该地址直接指向 IPv4 地址，而不是域名。这不一定表示恶意，但值得进一步核查。'),
    'Malformed IPv4-looking hostname': (title: '类似 IPv4 的主机名格式错误', detail: '主机名看起来像 IPv4 地址，但其中一个数字段超出允许范围。不要假定它会指向预期目标。'),
    'Unusual numeric hostname': (title: '异常数字主机名', detail: '主机名由数字组成，但不符合常见的四段式 IPv4 地址格式。不同客户端可能以不同方式解释此类格式。'),
    'Long subdomain chain': (title: '子域名层级过多', detail: '主机名包含多个子域名层级。请确认可注册域名；子域名中出现知名品牌，并不能证明该品牌控制此地址。'),
    'Non-standard port': (title: '使用非标准端口', detail: '该地址使用端口 {port}，而不是常见的 HTTP 或 HTTPS 端口。'),
    'Fragment present': (title: 'URL 包含片段标识符', detail: '该地址包含片段标识符。它属于提交的 URL，可能影响页面内容或客户端路由。'),
    'No structural warning detected': (title: '未发现结构性警告', detail: '该地址通过了本版本的基础本地结构检查。这并不能证明网站可信或安全。'),
    'Address not analysed': (title: '未分析地址', detail: '无法分析此网址。请检查输入内容后重试。'),
    'Urgency or pressure language': (title: '包含紧迫或施压措辞', detail: '消息营造紧迫感或要求立即采取行动。请先暂停，并通过另一条可信渠道核实请求。'),
    'Credential or sign-in request': (title: '要求提供凭据或登录', detail: '文本似乎在索要密码、登录信息或账户验证。请勿通过消息中的链接输入账户凭据。'),
    'OTP or authentication-code reference': (title: '提及 OTP 或身份验证代码', detail: '消息提及一次性密码或身份验证代码。切勿分享 OTP 或恢复代码，也不要批准自己未发起的登录请求。'),
    'Payment or financial action': (title: '涉及付款或金融操作', detail: '消息涉及付款、转账、退款、手续费或其他金融操作。请独立核实收款方和金额。'),
    'Prize or unexpected reward': (title: '声称有奖品或意外奖励', detail: '消息提及意外奖品或奖励。警惕以领取奖励为由索要费用或个人信息的要求。'),
    'Threat or consequence language': (title: '包含威胁或后果措辞', detail: '消息威胁罚款、法律行动、逮捕或账户访问受限。请使用独立查证的机构联系方式核实相关说法。'),
    'Obfuscated web address detected': (title: '发现经过混淆的网址', detail: '消息包含替换了协议写法的链接，例如 hxxp 或 hxxps。请手动核查；本应用未对该地址进行规范化或打开。'),
    'Link or web address detected': (title: '发现链接或网址', detail: '发现 {count} 个网址。显示的链接文字可能与实际目标不同。请逐一核实后再打开。'),
    'No listed social-engineering cues detected': (title: '未发现已列出的社会工程学线索', detail: '文本未匹配本版本有限的检测模式。恶意消息也可能使用普通措辞，或采用这些检查无法识别的表达方式。'),
    'Message not analysed': (title: '未分析消息', detail: '无法分析此消息。请检查输入文本后重试。'),
  };

  static LinkFinding localizeFinding(LinkFinding item, String code) {
    if (code != 'zh') return item;
    final v = _findings[item.title];
    if (v == null) return item;
    var detail = v.detail;
    final p = RegExp(r'port (\d+)').firstMatch(item.detail);
    final c = RegExp(r'^(\d+) web address').firstMatch(item.detail);
    if (p != null) detail = detail.replaceAll('{port}', p.group(1)!);
    if (c != null) detail = detail.replaceAll('{count}', c.group(1)!);
    return LinkFinding(title: v.title, detail: detail, severity: item.severity);
  }

  static String localizeLinkNotice(String notice, String code) {
    if (code != 'zh') return notice;
    return notice == 'No network request was made.'
        ? '未发起任何网络请求。'
        : '仅执行了本地结构检查。未发起网络请求，也未查询网站信誉。';
  }

  static String localizeMessageNotice(String code) => code == 'zh'
      ? '仅执行启发式文本检查。消息未上传，链接未打开，也未验证发件人身份或意图。'
      : 'Heuristic text checks only. No message was uploaded, no link was opened, and no sender identity or intent was verified.';

  static QrPayloadAnalysis localizeQr(QrPayloadAnalysis r, String code) {
    if (code != 'zh') return r;
    const titles = {
      'Wi-Fi configuration':'Wi-Fi 网络配置','Contact card':'联系人名片','Calendar event':'日历事件',
      'UPI payment request':'UPI 付款请求','Phone call action':'拨打电话','Email action':'发送电子邮件',
      'Text-message action':'发送短信','Location coordinates':'位置坐标','Application-specific link':'应用专用链接',
      'Plain text':'纯文本','Web address':'网址','Unrecognised web address':'无法识别的网址','QR content not analysed':'未分析二维码内容'
    };
    const details = {
      'Wi-Fi configuration':'二维码内容可能包含网络名称、安全类型和 Wi-Fi 密码。连接前请核实网络；ORVIKA 不会自动连接。',
      'Contact card':'内容包含联系人信息。保存前请核实姓名、电话号码、电子邮件地址及所属机构。',
      'Calendar event':'内容描述一个日历事件。导入前请核实标题、地点、时间和链接。',
      'UPI payment request':'二维码可能会在 UPI 应用中预填付款信息。请独立核实 UPI ID、收款人姓名和金额。ORVIKA 不会发起或确认付款。',
      'Phone call action':'内容包含拨打电话的操作。请独立核实电话号码；ORVIKA 不会拨打电话。',
      'Email action':'内容可能预填收件人或邮件正文。发送前请检查所有字段；ORVIKA 不会打开邮件应用。',
      'Text-message action':'内容可能预填收件人或短信正文。发送前请核实号码和文本；ORVIKA 不会发送短信。',
      'Location coordinates':'内容包含地理坐标。使用前请核实坐标及其上下文；ORVIKA 不会打开地图。',
      'Application-specific link':'内容使用 {scheme}: 等应用专用协议，而不是普通网址。它可能启动应用或操作。请先独立核实来源。',
      'Plain text':'二维码包含文本，而不是已识别的网址或操作。请仔细阅读；文本也可能包含欺骗性指令或敏感信息。',
      'Web address':'检测到网址。打开前请核实域名和路径。',
      'Unrecognised web address':'内容看起来像网址，但无法可靠解析。确认目标之前请勿打开。',
      'QR content not analysed':'无法分析二维码内容。请检查二维码或图像后重试。'
    };
    var detail = details[r.title] ?? r.detail;
    final s = RegExp(r'([a-zA-Z][a-zA-Z0-9+.-]*):').firstMatch(r.detail);
    if (s != null) detail = detail.replaceAll('{scheme}', s.group(1)!);
    return QrPayloadAnalysis(
      title: titles[r.title] ?? r.title, detail: detail, severity: r.severity,
      kind: r.kind, normalizedUrl: r.normalizedUrl,
      linkFindings: r.linkFindings.map((f) => localizeFinding(f, code)).toList(growable: false),
      isValid: r.isValid,
    );
  }
}

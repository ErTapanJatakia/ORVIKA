import '../../features/intelligence/domain/intelligence_library.dart';

/// Simplified Chinese intelligence reference entries; canonical IDs/categories remain unchanged.
class MandarinIntelligenceContent {
  MandarinIntelligenceContent._();
  static const Map<String, Map<String, String>> _data = {
    'url-http': {'title':'未加密的 HTTP 地址','signal':'网址以 http:// 开头，而不是 https://。','meaning':'浏览器与网站之间的连接可能缺少传输加密。','action':'不要通过该连接提交密码或敏感信息。请确认是否存在官方 HTTPS 地址，并独立核实网站域名。','limit':'HTTPS 只保护传输链路，不代表网站本身可信或无害。'},
    'url-userinfo': {'title':'网址中包含用户信息','signal':'主机名之前的 URL 部分包含用户名或密码样式的信息。','meaning':'此类写法可能用于混淆实际主机名或隐藏真实访问目标。','action':'仔细解析主机名，并通过已知官方渠道独立确认目标。不要在此类地址中输入凭据。','limit':'URL 中出现用户信息并不能单独证明恶意行为。'},
    'url-punycode': {'title':'国际化域名使用 Punycode 编码','signal':'主机名包含以 xn-- 开头的标签。','meaning':'Punycode 用于表示国际化域名；外观相似的字符可能被用于仿冒。','action':'核实可注册域名，并通过书签或已知官方地址访问服务。','limit':'Punycode 本身是合法编码方式，不代表域名恶意。'},
    'url-subdomains': {'title':'存在多个子域名层级','signal':'主机名包含多个点分隔的子域名。','meaning':'攻击者可能把知名品牌名称放在自己控制的子域名中，以制造可信假象。','action':'从右向左识别可注册域名，并核实域名注册主体和实际目标。','limit':'子域名较多并不必然表示恶意；应结合上下文判断。'},
    'message-urgency': {'title':'紧迫感或施压措辞','signal':'消息要求立即行动、制造恐慌或设置很短的处理期限。','meaning':'施压可能让收件人跳过正常核实流程。','action':'暂停操作，通过独立且可信的联系方式核实请求。','limit':'合法服务也可能发送紧急通知；措辞模式不能证明发件人身份。'},
    'message-credentials': {'title':'索要凭据或身份验证代码','signal':'消息提及密码、登录、OTP、恢复代码或批准身份验证请求。','meaning':'这些信息可能让他人访问账户或批准交易。','action':'不要透露密码或 OTP。拒绝意外的批准请求，并通过官方渠道联系服务提供商。','limit':'关键词匹配只能提示消息主题，不能确定发件人身份或意图。'},
    'message-payment': {'title':'意外付款或退款要求','signal':'消息要求转账、支付手续费、办理退款，或先付款才能获得利益。','meaning':'意外的金融指示可能被用于转移资金或收集付款信息。','action':'采取行动前，通过另一条可信渠道独立核实收款方、金额和原因。','limit':'合法账单和通知也会提及付款；应结合上下文核查。'},
    'qr-payment': {'title':'二维码付款请求','signal':'二维码内容使用付款协议，例如 upi://pay。','meaning':'扫描后可能在付款应用中预填收款方和交易信息。二维码不能证明收款人身份或金额正确。','action':'确认前，在付款应用中核实收款人姓名、UPI ID 和金额。任何信息不符都应取消操作。','limit':'付款内容本身并不等于诈骗；请核实具体交易信息。'},
    'qr-action': {'title':'包含操作链接的二维码','signal':'二维码包含网站、电话、电子邮件、短信或应用专用操作。','meaning':'其他应用处理该内容时，可能打开地址或预填一项操作。','action':'先检查解码内容。不要打开陌生链接，也不要未经核实就确认预填操作。','limit':'内容类型本身不能证明来源可信。'},
    'account-mfa': {'title':'意外的多因素身份验证请求','signal':'您收到自己未发起的登录批准请求或一次性验证码。','meaning':'有人可能正在使用您的用户名和密码尝试登录；也可能是误触发。','action':'拒绝请求，不要分享代码；必要时通过官方服务更改密码并检查活动会话。','limit':'意外请求是警示信号，并不能单独证明账户已遭入侵。'}
  };
  static IntelligenceEntry localize(IntelligenceEntry item, String code) {
    if (code != 'zh') return item;
    final v = _data[item.id]; if (v == null) return item;
    return IntelligenceEntry(id:item.id,title:v['title']!,category:item.category,signal:v['signal']!,meaning:v['meaning']!,action:v['action']!,limit:v['limit']!);
  }
}

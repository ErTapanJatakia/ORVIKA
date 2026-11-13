import '../../features/academy/domain/academy_curriculum.dart';

/// Simplified Chinese Academy content. IDs and correct answer indices stay canonical.
class MandarinAcademyContent {
  MandarinAcademyContent._();
  static const Map<String, Map<String, Object>> _data = {
    'verify_sender': {'title':'核实发件人，而不只是显示名称','summary':'名称、徽标和头像很容易被复制。在信任请求之前，请核实真实的电子邮件地址、电话号码或账户标识。','keyPoints':['打开发件人详细信息，检查完整电子邮件地址或账户标识。','遇到意外请求时，通过您此前已信任的渠道联系对方。','熟悉的名称或徽标不能证明发件人身份。'],'question':'一条自称来自您银行的消息要求您立即操作。最安全的第一步是什么？','options':['回复消息并要求发件人确认','自行打开银行应用，或通过已知的官方渠道联系银行','因为徽标看起来正确就相信消息'],'explanation':'请使用独立查证的联系方式。不要点击意外消息中的链接，也不要拨打其中提供的电话号码。'},
    'phishing_links': {'title':'打开链接前先核实','summary':'链接可能模仿知名品牌，却指向无关或欺骗性域名。','keyPoints':['从右向左识别可注册域名；额外的子域名可能掩盖真实目标。','留意拼写错误、相似字符、意外出现的短链接以及误导性文字。','如有疑问，请使用已保存的书签，或自行输入已知网址。'],'question':'消息显示 example.com，但链接实际指向 example-login.security-check.invalid。应该怎么做？','options':['显示文字熟悉，因此打开链接','不要打开链接，通过已知官方渠道访问服务','在隐私浏览模式下打开链接'],'explanation':'链接显示文字可能与实际网址不同。隐私浏览模式不会让恶意网站变得安全。'},
    'otp_secrecy': {'title':'切勿泄露一次性验证码或恢复代码','summary':'一次性密码、登录批准请求和恢复代码可能让他人访问您的账户。','keyPoints':['不要向任何人透露一次性密码或恢复代码，即使对方自称客服。','不要批准自己未发起的登录请求。','如果已经泄露代码，请立即通过官方服务保护账户。'],'question':'有人自称客服，要求您提供一次性验证码以取消交易。您应该怎么做？','options':['如果对方知道您的姓名，就提供验证码','只提供验证码的前半部分','不提供验证码，结束对话并通过官方方式联系服务提供商'],'explanation':'一次性验证码是身份验证秘密。正规的客服不应要求您透露此类代码。'},
    'mfa_fatigue': {'title':'识别意外的多因素身份验证请求','summary':'反复出现的登录批准请求，可能意味着有人正尝试使用您的凭据登录账户。','keyPoints':['拒绝所有由您未发起的请求。','不要仅仅为了停止重复通知而批准登录。','怀疑账户遭入侵时，请通过官方网站更改密码并检查活动会话。'],'question':'您没有尝试登录，却不断收到登录批准请求。正确做法是什么？','options':['拒绝请求，并通过官方设置检查账户','批准一次请求以停止通知','忽略今后的所有通知'],'explanation':'拒绝意外请求，然后使用可信设备通过官方渠道检查账户。'},
    'payment_pressure': {'title':'警惕紧急付款施压','summary':'诈骗者利用紧迫感、保密要求和权威身份施压，诱使您转账或批准付款。','keyPoints':['紧急转账要求或突然更改银行账户信息，都应触发额外核查。','使用您此前已知的收款方电话号码核实付款指示。','不要让来电者绕过正常审批流程。'],'question':'供应商发来新的银行账户信息，并要求您在十分钟内付款。应该怎么做？','options':['立即付款以免产生罚款','通过此前已知的联系电话核实账户变更','直接回复该邮件询问是否属实'],'explanation':'请通过独立渠道核实付款信息变更。在可能已遭入侵的同一邮件对话中回复，并不构成独立核实。'},
    'qr_safety': {'title':'像对待链接一样谨慎对待二维码','summary':'二维码可能包含网站地址、付款请求、联系人或其他操作。扫描本身并不能证明内容安全。','keyPoints':['继续操作前先查看解码后的网址或付款信息。','确认付款前，仔细核实收款方和金额。','留意覆盖在原有二维码上的可疑贴纸。'],'question':'二维码打开了付款页面。确认付款前应该检查什么？','options':['只看二维码图案是否专业','通过可信来源核实收款方、金额和付款用途','只看二维码扫描速度'],'explanation':'二维码只是传递数据的一种方式。确认前请核实实际交易信息。'},
    'device_updates': {'title':'及时更新设备和应用','summary':'更新可修复已知漏洞。推迟更新会使设备继续暴露于已有修复方案的风险之中。','keyPoints':['通过官方更新机制安装操作系统和应用更新。','删除不需要的应用，并定期检查权限。','创建备份，并使用屏幕锁保护设备。'],'question':'设备官方应用商店提供了应用更新。哪种做法更安全？','options':['核实来源后及时通过官方渠道更新','从广告中下载所谓的快速更新安装包','永久关闭更新'],'explanation':'请使用平台官方更新机制，并及时更新软件。'},
    'incident_first_steps': {'title':'账户可能遭入侵时的第一步','summary':'冷静、有序地采取措施，有助于限制进一步访问并保留有用信息。','keyPoints':['使用可信设备，通过官方服务保护受影响的账户。','更改重复使用的密码、结束未知会话，并在可用时启用多因素身份验证。','保存重要消息和交易信息；如涉及资金，请立即联系银行。'],'question':'您怀疑自己的电子邮件账户遭到入侵。首先应该做什么？','options':['立即删除所有可疑消息','使用可信设备，通过官方恢复流程保护账户','在网上公开恢复代码以寻求帮助'],'explanation':'通过官方流程恢复访问，检查会话，并保存可能有助于调查的证据。'}
  };
  static AcademyLesson localize(AcademyLesson item, String code) {
    if (code != 'zh') return item;
    final v = _data[item.id]; if (v == null) return item;
    return AcademyLesson(id:item.id,title:v['title']! as String,category:item.category,summary:v['summary']! as String,keyPoints:List<String>.unmodifiable(v['keyPoints']! as List<String>),question:v['question']! as String,options:List<String>.unmodifiable(v['options']! as List<String>),correctIndex:item.correctIndex,explanation:v['explanation']! as String);
  }
}

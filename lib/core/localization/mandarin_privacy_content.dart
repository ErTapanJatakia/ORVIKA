import '../../features/privacy/domain/privacy_checklist.dart';

/// Simplified Chinese privacy guidance mapped to canonical practice IDs.
class MandarinPrivacyContent {
  MandarinPrivacyContent._();
  static const Map<String, Map<String, String>> _data = {
    'account-unique-passwords': {'title':'为重要账户使用独立密码','why':'如果某项服务发生数据泄露，重复使用密码可能使您的其他账户也面临风险。','action':'使用可靠的密码管理器，为每个重要账户创建足够长且独立的密码。使用主密码保护管理器，并配置可用的恢复方式。','limit':'如果主密码或恢复渠道遭到入侵，密码管理器也无法保护账户。'},
    'account-mfa': {'title':'启用多因素身份验证','why':'额外的验证因素可以降低密码被盗造成的影响。','action':'为电子邮件、金融、云服务和社交账户启用多因素身份验证。尽可能使用通行密钥或硬件安全密钥，并保护身份验证器备份。','limit':'不同多因素验证方式的安全强度不同。短信验证码可能受到 SIM 卡交换或号码转移攻击。'},
    'account-recovery': {'title':'检查账户恢复方式','why':'过期的恢复邮箱或电话号码可能妨碍合法恢复，也可能帮助他人接管账户。','action':'在每项服务的官方安全设置中，检查备用邮箱、电话号码、恢复代码和受信任设备。','limit':'恢复设置因服务而异。ORVIKA 无法确认服务提供商是否已应用您的更改。'},
    'device-updates': {'title':'更新操作系统和应用','why':'更新通常会修复攻击者可能利用的已知漏洞。','action':'尽可能启用自动安全更新。通过设备内置更新机制或官方应用商店安装更新。','limit':'更新可以降低已知风险，但不能保证设备未遭入侵。'},
    'device-lock': {'title':'使用强屏幕锁保护设备','why':'丢失或无人看管且未锁定的设备，可能泄露消息、账户和已保存的数据。','action':'使用较长的 PIN 或密码，并设置较短的自动锁定时间。可将生物识别作为便捷的辅助解锁方式。','limit':'生物识别和锁屏选项因设备而异。屏幕锁并不一定意味着所有外部备份都已加密。'},
    'device-backups': {'title':'检查备份和设备查找功能','why':'备份有助于恢复数据；设备查找功能可帮助定位或远程保护丢失的设备。','action':'检查备份包含哪些数据、谁能访问备份账户、是否提供备份加密，以及设备查找和远程锁定功能是否已启用。','limit':'功能可用性和加密设置取决于操作系统及服务提供商。请查阅最新官方文档。'},
    'apps-permissions': {'title':'检查应用权限','why':'应用可能持续访问位置、联系人、相机、麦克风、照片或附近设备，即使这些权限已超出其实际需要。','action':'打开系统的隐私或应用权限设置。撤销不必要的访问权限；如有选项，优先选择仅在使用期间或仅本次允许。','limit':'权限名称和控制方式因操作系统及版本而异。ORVIKA 不会读取或更改这些权限。'},
    'apps-unused': {'title':'卸载不再使用的应用','why':'不再使用的应用可能停止接收更新，或继续保留不再需要的数据和权限。','action':'检查已安装应用并卸载不再需要的应用。卸载前，请确认是否需要导出数据、取消订阅或删除关联账户。','limit':'卸载应用不一定会删除服务提供商保存的账户或云端数据。'},
    'apps-sources': {'title':'仅从可信官方来源安装应用','why':'非官方安装包可能被篡改，或包含不需要的权限和恶意组件。','action':'优先使用操作系统官方应用商店或开发者官方网站。安装前核实发布者、应用名称和权限请求。','limit':'官方商店也不能保证每个应用都安全。仍需检查开发者和权限。'},
    'browsing-tracking': {'title':'了解浏览器跟踪与隐私设置','why':'Cookie、跟踪器和浏览器标识可能用于跨网站识别或分析您的活动。','action':'查看浏览器的跟踪防护、第三方 Cookie 和网站权限设置，并根据需要调整。','limit':'阻止跟踪可能影响部分网站功能；隐私模式不会让您对网站或网络服务完全匿名。'},
    'browsing-sharing': {'title':'谨慎共享个人信息','why':'发布或发送的信息可能被复制、转发或长期保存。','action':'共享前确认接收方、用途和必要范围。避免公开身份证件、验证码、恢复代码或不必要的个人资料。','limit':'删除原始帖子或消息，无法保证其他副本也会被删除。'},
    'browsing-network': {'title':'使用公共网络时保持谨慎','why':'开放或不可信网络可能使您暴露于仿冒热点、流量观察或中间人攻击。','action':'核实网络名称，优先使用可信网络，并确保网站连接使用 HTTPS。避免在不可信网络上执行敏感操作。','limit':'HTTPS 不能证明网站本身可信；VPN 也不能防止钓鱼或恶意软件。'}
  };
  static PrivacyPractice localize(PrivacyPractice item, String code) {
    if (code != 'zh') return item;
    final v = _data[item.id]; if (v == null) return item;
    return PrivacyPractice(id:item.id,title:v['title']!,category:item.category,why:v['why']!,action:v['action']!,limit:v['limit']!);
  }
}

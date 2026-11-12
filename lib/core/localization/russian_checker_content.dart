import '../../features/link_check/domain/url_analyzer.dart';
import '../../features/qr_check/domain/qr_payload_analyzer.dart';

/// Русские формулировки результатов локальных проверок; сигналы и оценки неизменны.
class RussianCheckerContent {
  RussianCheckerContent._();
  static const Map<String, ({String title,String detail})> _findings = {
    'Unicode hostname':(title:'Имя узла содержит Unicode',detail:'Имя узла содержит символы вне ASCII. Внимательно проверьте интернационализированный домен на похожие символы и точность написания.'),
    'Unencrypted connection':(title:'Незашифрованное соединение',detail:'Адрес использует HTTP. Передаваемые данные могут быть не защищены при передаче.'),
    'Embedded sign-in information':(title:'Данные входа встроены в адрес',detail:'Перед именем узла в адресе указаны пользовательские данные. Это может маскировать фактическое назначение.'),
    'Internationalised domain encoding':(title:'Кодирование интернационализированного домена',detail:'Имя узла содержит Punycode. Проверьте отображаемый домен на похожие символы.'),
    'IP-address destination':(title:'Назначение задано IP-адресом',detail:'Адрес ведёт непосредственно на IPv4-адрес, а не на доменное имя. Это не обязательно вредоносно, но требует проверки.'),
    'Malformed IPv4-looking hostname':(title:'Некорректное имя узла, похожее на IPv4',detail:'Имя узла похоже на IPv4-адрес, но содержит октет вне допустимого диапазона. Не предполагайте, что оно ведёт туда, куда ожидается.'),
    'Unusual numeric hostname':(title:'Необычное числовое имя узла',detail:'Имя узла состоит из чисел, но не соответствует обычному IPv4-адресу из четырёх октетов. Клиенты могут по-разному интерпретировать такие форматы.'),
    'Long subdomain chain':(title:'Длинная цепочка поддоменов',detail:'Имя узла содержит несколько уровней поддоменов. Проверьте регистрируемый домен: известный бренд в поддомене не подтверждает контроль над адресом.'),
    'Non-standard port':(title:'Нестандартный порт',detail:'Адрес использует порт {port} вместо обычного порта HTTP или HTTPS.'),
    'Fragment present':(title:'В URL присутствует фрагмент',detail:'Адрес содержит фрагмент. Он является частью переданного URL и может влиять на страницу или маршрутизацию на стороне клиента.'),
    'No structural warning detected':(title:'Структурных предупреждений не обнаружено',detail:'Адрес прошёл эти базовые локальные проверки. Это не доказывает, что сайт надёжен или безопасен.'),
    'Address not analysed':(title:'Адрес не проанализирован',detail:'Не удалось проанализировать веб-адрес. Проверьте введённое значение и повторите попытку.'),
    'Urgency or pressure language':(title:'Срочность или давление в сообщении',detail:'Сообщение создаёт ощущение срочности или требует немедленных действий. Сделайте паузу и проверьте запрос по другому надёжному каналу.'),
    'Credential or sign-in request':(title:'Запрос учётных данных или входа',detail:'Похоже, текст запрашивает пароль, вход или подтверждение аккаунта. Не вводите учётные данные по ссылке из сообщения.'),
    'OTP or authentication-code reference':(title:'Упоминание OTP или кода аутентификации',detail:'Упоминается одноразовый пароль или код аутентификации. Никогда не сообщайте OTP, код восстановления или не ожидаемый запрос подтверждения.'),
    'Payment or financial action':(title:'Платёжное или финансовое действие',detail:'Сообщение касается платежа, перевода, возврата, комиссии или другого финансового действия. Независимо проверьте получателя и сумму.'),
    'Prize or unexpected reward':(title:'Приз или неожиданное вознаграждение',detail:'Упоминается неожиданный приз или вознаграждение. Остерегайтесь требований оплатить сбор или предоставить личные данные для его получения.'),
    'Threat or consequence language':(title:'Угроза или заявление о последствиях',detail:'Сообщение угрожает штрафом, юридическими мерами, арестом или потерей доступа. Проверьте утверждения по контактам организации, найденным независимо.'),
    'Obfuscated web address detected':(title:'Обнаружен замаскированный веб-адрес',detail:'Сообщение содержит ссылку с заменённой схемой, например hxxp или hxxps. Проверьте её вручную: адрес не нормализовался и не открывался.'),
    'Link or web address detected':(title:'Обнаружена ссылка или веб-адрес',detail:'Обнаружено веб-адресов: {count}. Видимая ссылка может скрывать другое назначение. Проверяйте каждый адрес отдельно.'),
    'No listed social-engineering cues detected':(title:'Известные признаки социальной инженерии не обнаружены',detail:'Текст не совпал с ограниченным набором шаблонов этой версии. Вредоносные сообщения могут выглядеть обычно или использовать незнакомые формулировки.'),
    'Message not analysed':(title:'Сообщение не проанализировано',detail:'Не удалось проанализировать сообщение. Проверьте текст и повторите попытку.'),
  };
  static LinkFinding localizeFinding(LinkFinding item,String code) {
    if(code!='ru') return item; final v=_findings[item.title]; if(v==null)return item;
    var detail=v.detail;
    final p=RegExp(r'port (\\d+)').firstMatch(item.detail);
    final c=RegExp(r'^(\\d+) web address').firstMatch(item.detail);
    if(p!=null) detail=detail.replaceAll('{port}',p.group(1)!);
    if(c!=null) detail=detail.replaceAll('{count}',c.group(1)!);
    return LinkFinding(title:v.title,detail:detail,severity:item.severity);
  }
  static String localizeLinkNotice(String notice,String code) => code!='ru' ? notice : notice=='No network request was made.' ? 'Сетевые запросы не выполнялись.' : 'Выполнялись только локальные структурные проверки. Сетевые запросы и проверки репутации не проводились.';
  static String localizeMessageNotice(String code) => code=='ru' ? 'Выполнялись только эвристические проверки текста. Сообщение не загружалось, ссылки не открывались, личность и намерения отправителя не проверялись.' : 'Heuristic text checks only. No message was uploaded, no link was opened, and no sender identity or intent was verified.';
  static QrPayloadAnalysis localizeQr(QrPayloadAnalysis r,String code) {
    if(code!='ru') return r;
    const titles={'Wi-Fi configuration':'Настройки Wi-Fi','Contact card':'Контактная карточка','Calendar event':'Событие календаря','UPI payment request':'Запрос платежа UPI','Phone call action':'Действие вызова','Email action':'Действие электронной почты','Text-message action':'Действие SMS','Location coordinates':'Координаты местоположения','Application-specific link':'Ссылка приложения','Plain text':'Обычный текст','Web address':'Веб-адрес','Unrecognised web address':'Не распознанный веб-адрес','QR content not analysed':'QR-содержимое не проанализировано'};
    const details={'Wi-Fi configuration':'QR-содержимое может включать имя сети, тип защиты и пароль Wi-Fi. Проверьте сеть перед подключением: ORVIKA не подключается автоматически.','Contact card':'Содержимое включает контактные данные. Проверьте имена, телефоны, адреса почты и сведения об организации перед сохранением.','Calendar event':'Содержимое описывает событие календаря. Проверьте название, место, время и ссылки перед импортом.','UPI payment request':'QR-код может подготовить платёж в приложении UPI. Независимо проверьте UPI ID, имя получателя и сумму. ORVIKA не инициирует и не подтверждает платежи.','Phone call action':'Содержимое включает действие вызова. Независимо проверьте номер: ORVIKA не совершает звонки.','Email action':'Содержимое может заполнить адресата или текст письма. Проверьте все поля перед отправкой: ORVIKA не открывает почтовые приложения.','Text-message action':'Содержимое может заполнить адресата или текст сообщения. Проверьте номер и текст перед отправкой: ORVIKA не отправляет SMS.','Location coordinates':'Содержимое включает координаты. Проверьте их и контекст перед использованием: ORVIKA не открывает карты.','Application-specific link':'Содержимое использует схему «{scheme}:» вместо обычного веб-адреса. Оно может запустить приложение или действие. Открывайте его только после независимой проверки источника.','Plain text':'QR-код содержит текст, а не распознанный веб-адрес или действие. Внимательно изучите его: текст также может содержать обманные инструкции или чувствительные сведения.','Web address':'Обнаружено веб-направление. Проверьте домен и путь перед открытием ссылки.','Unrecognised web address':'Содержимое похоже на веб-адрес, но его не удалось надёжно интерпретировать. Не открывайте его до проверки назначения.','QR content not analysed':'Не удалось проанализировать QR-содержимое. Проверьте код или изображение и повторите попытку.'};
    var detail=details[r.title] ?? r.detail;
    final s=RegExp(r'([a-zA-Z][a-zA-Z0-9+.-]*):').firstMatch(r.detail);
    if(s!=null) detail=detail.replaceAll('{scheme}',s.group(1)!);
    return QrPayloadAnalysis(title:titles[r.title] ?? r.title,detail:detail,severity:r.severity,kind:r.kind,normalizedUrl:r.normalizedUrl,linkFindings:r.linkFindings.map((f)=>localizeFinding(f,code)).toList(growable:false),isValid:r.isValid);
  }
}

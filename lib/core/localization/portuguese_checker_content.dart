import '../../features/link_check/domain/url_analyzer.dart';
import '../../features/qr_check/domain/qr_payload_analyzer.dart';

/// Brazilian Portuguese wording for deterministic checker findings.
class PortugueseCheckerContent {
  PortugueseCheckerContent._();

  static const Map<String, ({String title, String detail})> _findings = {
    'Unicode hostname': (title:'Nome de host Unicode', detail:'O nome de host contém caracteres não ASCII. Examine o domínio internacionalizado com atenção para identificar caracteres semelhantes e conferir a grafia exata.'),
    'Unencrypted connection': (title:'Conexão sem criptografia', detail:'Este endereço usa HTTP. Os dados trocados podem não estar protegidos durante a transmissão.'),
    'Embedded sign-in information': (title:'Informações de login incorporadas ao endereço', detail:'O endereço contém informações de usuário antes do nome de host. Isso pode tornar o destino exibido enganoso.'),
    'Internationalised domain encoding': (title:'Codificação de domínio internacionalizado', detail:'O nome de host contém Punycode. Examine o domínio exibido para identificar caracteres visualmente semelhantes.'),
    'IP-address destination': (title:'Destino em endereço IP', detail:'O endereço aponta diretamente para um endereço IPv4 em vez de um nome de domínio. Isso não é necessariamente malicioso, mas merece verificação.'),
    'Malformed IPv4-looking hostname': (title:'Nome de host semelhante a IPv4 malformado', detail:'O nome de host parece um endereço IPv4 pontuado, mas contém um octeto fora do intervalo permitido. Não presuma que ele leve ao destino esperado.'),
    'Unusual numeric hostname': (title:'Nome de host numérico incomum', detail:'O nome de host é numérico, mas não corresponde a um endereço IPv4 convencional de quatro octetos. Alguns clientes podem interpretar formatos numéricos incomuns de maneiras diferentes.'),
    'Long subdomain chain': (title:'Cadeia longa de subdomínios', detail:'O nome de host contém vários níveis de subdomínios. Confira o domínio registrável: uma marca conhecida em um subdomínio não comprova quem controla o destino.'),
    'Non-standard port': (title:'Porta não padrão', detail:'Este endereço usa a porta {port} em vez da porta HTTP ou HTTPS habitual.'),
    'Fragment present': (title:'Fragmento de URL presente', detail:'O endereço contém um fragmento. Ele faz parte da URL fornecida e pode afetar a página ou o roteamento no lado do cliente.'),
    'No structural warning detected': (title:'Nenhum alerta estrutural detectado', detail:'O endereço passou por estas verificações locais básicas. Isso não comprova que o site seja confiável ou seguro.'),
    'Address not analysed': (title:'Endereço não analisado', detail:'Não foi possível analisar o endereço web. Confira o valor informado e tente novamente.'),
    'Urgency or pressure language': (title:'Linguagem de urgência ou pressão', detail:'A mensagem cria urgência ou exige ação imediata. Faça uma pausa e verifique a solicitação por outro canal confiável.'),
    'Credential or sign-in request': (title:'Solicitação de credenciais ou login', detail:'O texto parece solicitar uma senha, login ou verificação de conta. Não informe credenciais por um link recebido em uma mensagem.'),
    'OTP or authentication-code reference': (title:'Referência a OTP ou código de autenticação', detail:'Uma senha de uso único ou código de autenticação é mencionado. Nunca compartilhe OTP, código de recuperação ou solicitação de aprovação.'),
    'Payment or financial action': (title:'Pagamento ou ação financeira', detail:'A mensagem trata de pagamento, transferência, reembolso, taxa ou outra ação financeira. Verifique o destinatário e o valor de forma independente antes de continuar.'),
    'Prize or unexpected reward': (title:'Prêmio ou recompensa inesperada', detail:'Um prêmio ou recompensa inesperada é mencionado. Desconfie de pedidos de taxas ou dados pessoais para resgatá-lo.'),
    'Threat or consequence language': (title:'Ameaça ou anúncio de consequências', detail:'A mensagem ameaça aplicar penalidade, ação judicial, prisão ou perda de acesso. Verifique as alegações usando contatos da organização obtidos de forma independente.'),
    'Obfuscated web address detected': (title:'Endereço web ofuscado detectado', detail:'A mensagem contém um link cujo esquema foi substituído, como hxxp ou hxxps. Trate-o como endereço que exige revisão manual: ele não foi normalizado nem aberto.'),
    'Link or web address detected': (title:'Link ou endereço web detectado', detail:'Foram encontrados {count} endereços web. Um link visível pode ocultar outro destino. Verifique cada endereço separadamente antes de abri-lo.'),
    'No listed social-engineering cues detected': (title:'Nenhum indicador listado de engenharia social detectado', detail:'O texto não corresponde aos padrões limitados desta versão. Mensagens maliciosas ainda podem parecer comuns ou usar expressões que estas verificações não detectam.'),
    'Message not analysed': (title:'Mensagem não analisada', detail:'Não foi possível analisar a mensagem. Confira o texto informado e tente novamente.'),
  };

  static LinkFinding localizeFinding(LinkFinding finding, String languageCode) {
    if (languageCode != 'pt') return finding;
    final translated = _findings[finding.title];
    if (translated == null) return finding;
    var detail = translated.detail;
    final portMatch = RegExp(r'port (\d+)').firstMatch(finding.detail);
    final countMatch = RegExp(r'^(\d+) web address').firstMatch(finding.detail);
    if (portMatch != null) detail = detail.replaceAll('{port}', portMatch.group(1)!);
    if (countMatch != null) detail = detail.replaceAll('{count}', countMatch.group(1)!);
    return LinkFinding(title: translated.title, detail: detail, severity: finding.severity);
  }

  static String localizeLinkNotice(String notice, String languageCode) {
    if (languageCode != 'pt') return notice;
    if (notice == 'No network request was made.') return 'Nenhuma solicitação de rede foi realizada.';
    return 'Somente verificações estruturais locais foram realizadas. Não houve solicitação de rede nem verificação de reputação.';
  }

  static String localizeMessageNotice(String languageCode) => languageCode == 'pt'
      ? 'Somente verificações heurísticas de texto. Nenhuma mensagem foi enviada, nenhum link foi aberto e a identidade ou intenção do remetente não foi verificada.'
      : 'Heuristic text checks only. No message was uploaded, no link was opened, and no sender identity or intent was verified.';

  static QrPayloadAnalysis localizeQr(QrPayloadAnalysis result, String languageCode) {
    if (languageCode != 'pt') return result;
    const titles = <String, String>{
      'Wi-Fi configuration':'Configuração de Wi-Fi','Contact card':'Cartão de contato','Calendar event':'Evento de calendário',
      'UPI payment request':'Solicitação de pagamento UPI','Phone call action':'Ação de chamada telefônica','Email action':'Ação de e-mail',
      'Text-message action':'Ação de SMS','Location coordinates':'Coordenadas de localização','Application-specific link':'Link específico de aplicativo',
      'Plain text':'Texto simples','Web address':'Endereço web','Unrecognised web address':'Endereço web não reconhecido','QR content not analysed':'Conteúdo QR não analisado',
    };
    const details = <String, String>{
      'Wi-Fi configuration':'Este conteúdo QR pode incluir nome da rede, tipo de segurança e senha do Wi-Fi. Verifique a rede antes de se conectar: o ORVIKA não se conecta automaticamente.',
      'Contact card':'Este conteúdo inclui dados de contato. Confira nomes, telefones, e-mails e informações da organização antes de salvar.',
      'Calendar event':'Este conteúdo descreve um evento de calendário. Confira título, local, horários e links incorporados antes de importar.',
      'UPI payment request':'Este conteúdo QR pode preparar um pagamento em um aplicativo UPI. Verifique o ID UPI, o nome do beneficiário e o valor de forma independente. O ORVIKA não inicia nem autoriza pagamentos.',
      'Phone call action':'Este conteúdo inclui uma ação de chamada. Verifique o número de forma independente: o ORVIKA não faz chamadas.',
      'Email action':'Este conteúdo pode preencher um destinatário ou texto de e-mail. Confira todos os campos antes de enviar: o ORVIKA não abre aplicativos de e-mail.',
      'Text-message action':'Este conteúdo pode preencher um destinatário ou mensagem. Confira o número e o texto antes de enviar: o ORVIKA não envia SMS.',
      'Location coordinates':'Este conteúdo inclui uma referência de localização. Confira as coordenadas e o contexto antes de usar: o ORVIKA não abre mapas.',
      'Application-specific link':'Este conteúdo usa o esquema “{scheme}:” em vez de uma URL web comum. Pode iniciar um aplicativo ou ação. Abra somente se confiar na origem após verificação independente.',
      'Plain text':'Este conteúdo QR contém texto em vez de endereço web ou ação reconhecida. Examine com atenção: o texto também pode conter instruções enganosas ou informações sensíveis.',
      'Web address':'Um destino web foi detectado. Confira o domínio e o caminho antes de abrir o link.',
      'Unrecognised web address':'O conteúdo parece um endereço web, mas não pôde ser interpretado com confiança. Não o abra antes de verificar o destino.',
      'QR content not analysed':'Não foi possível analisar o conteúdo QR. Confira o código ou a imagem e tente novamente.',
    };
    final title = titles[result.title] ?? result.title;
    var detail = details[result.title] ?? result.detail;
    final scheme = RegExp(r'([a-zA-Z][a-zA-Z0-9+.-]*):').firstMatch(result.detail);
    if (scheme != null) detail = detail.replaceAll('{scheme}', scheme.group(1)!);
    return QrPayloadAnalysis(title:title, detail:detail, severity:result.severity, kind:result.kind,
      normalizedUrl:result.normalizedUrl, linkFindings:result.linkFindings, isValid:result.isValid);
  }
}

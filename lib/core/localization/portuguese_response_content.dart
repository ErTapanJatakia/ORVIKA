import '../../features/response/domain/response_playbooks.dart';
import 'portuguese_portugal_text.dart';

/// Brazilian Portuguese incident-response guidance.
class PortugueseResponseContent {
  PortugueseResponseContent._();

  static const Map<String, Map<String, Object>> _playbooks = {
    'account-compromise': {
      'title':'Uma conta pode ter sido comprometida','summary':'Você percebe logins desconhecidos, dados de recuperação alterados, mensagens que não enviou ou solicitações inesperadas de autenticação.','firstAction':'Use outro dispositivo confiável e acesse o serviço pelo aplicativo ou endereço oficial.',
      'steps':['Proteja primeiro a conta de e-mail principal se ela puder estar afetada; muitas vezes ela controla a redefinição de senhas de outros serviços.','Altere a senha afetada para uma senha exclusiva e ative um método forte de MFA disponível.','Revise e-mails e telefones de recuperação, chaves de acesso e métodos de autenticação; remova entradas desconhecidas.','Encerre sessões desconhecidas e revogue aplicativos conectados ou tokens de acesso não reconhecidos, quando o serviço permitir.','Confira regras de encaminhamento, filtros da caixa de entrada, mensagens enviadas e alterações recentes na conta.','Se for uma conta de trabalho ou estudo, avise prontamente a equipe de TI ou segurança da organização.'],
      'preserve':['Registre e-mails de alerta, horários de login, detalhes de dispositivos e sessões e notificações relevantes.','Guarde mensagens originais e cabeçalhos quando disponíveis; anote o que foi alterado e quando.'],
      'avoid':['Não compartilhe senhas, OTPs, códigos de recuperação ou links de sessão com ninguém que ofereça ajuda.','Não use links ou telefones de recuperação fornecidos em mensagens inesperadas.','Não exclua alertas potencialmente relevantes antes de registrar seus detalhes.'],
      'limit':'O ORVIKA não verifica acessos, encerra sessões nem recupera contas. Siga o processo oficial de recuperação do serviço; etapas e nomes variam.',
    },
    'payment-fraud': {
      'title':'Pagamento suspeito ou não autorizado','summary':'Você enviou dinheiro sob pressão, aprovou um pagamento inesperado, compartilhou credenciais de pagamento ou identificou uma transação desconhecida.','firstAction':'Entre em contato imediatamente com seu banco ou provedor de pagamento pelo aplicativo oficial, número do cartão ou site verificado de forma independente.',
      'steps':['Peça ao provedor que proteja a conta, cartão, carteira ou instrumento de pagamento afetado e explique o processo disponível para contestação ou tentativa de estorno.','Informe a transação como não autorizada ou induzida por golpe; forneça referência, valor, data e dados do destinatário.','Altere credenciais bancárias ou de e-mail expostas em um dispositivo confiável e revise sessões e autorizações de pagamento ativas.','Se credenciais ou o SIM puderem estar comprometidos, informe o banco e a operadora móvel pertinente.','Use o canal oficial de denúncia governamental ou policial da sua jurisdição e guarde o protocolo ou número do caso.'],
      'preserve':['Guarde IDs de transação, avisos bancários, recibos, dados do beneficiário, registros de chamadas e conversas.','Anote quando percebeu o problema e quando entrou em contato com o provedor.'],
      'avoid':['Não pague a ninguém que prometa recuperar o dinheiro com garantia ou exija taxa antecipada.','Não aprove novas solicitações de cobrança, autorizações de pagamento ou sessões de acesso remoto.','Não confie nos dados de contato enviados pelo suposto fraudador.'],
      'limit':'Um pagamento pode não ser reversível. O ORVIKA não bloqueia contas, rastreia fundos nem registra denúncias. Contate o provedor sem demora; canais e prazos variam.',
    },
    'lost-device': {
      'title':'Um telefone, computador ou dispositivo foi perdido','summary':'Um dispositivo desapareceu, foi roubado ou pode estar acessível a outra pessoa.','firstAction':'Em outro dispositivo confiável, use o serviço oficial de segurança da conta e localização do fabricante ou da plataforma.',
      'steps':['Se disponível, marque o dispositivo como perdido ou bloqueie-o remotamente; avalie a limpeza remota conforme a sensibilidade dos dados e as chances de recuperação.','Contate a operadora móvel para suspender um SIM ou eSIM perdido e pergunte como proteger o número.','Altere senhas do e-mail principal e de contas financeiras e de identidade se o dispositivo podia estar desbloqueado ou armazenava credenciais.','Revogue sessões de dispositivos confiáveis e revise métodos de recuperação em outro dispositivo seguro.','Denuncie suspeita de roubo à autoridade local apropriada e siga o processo da organização para dispositivos corporativos.'],
      'preserve':['Guarde número de série, IMEI quando aplicável, comprovante de compra e alertas oficiais de localização e segurança.','Registre quando e onde o dispositivo foi visto pela última vez e as medidas tomadas para bloqueá-lo ou denunciá-lo.'],
      'avoid':['Não confronte nem encontre alguém que diga estar com o dispositivo; procure as autoridades apropriadas.','Não siga mensagens que peçam para desativar a proteção do dispositivo ou revelar credenciais.','Não presuma que uma estimativa de localização seja exata ou segura para agir por conta própria.'],
      'limit':'Localização, bloqueio e limpeza remotos dependem da configuração anterior, conectividade e suporte da plataforma. A limpeza pode afetar evidências ou recuperação; avalie antes de prosseguir.',
    },
    'suspected-malware': {
      'title':'Um dispositivo pode estar com malware','summary':'Você vê pop-ups inesperados, alertas de segurança, aplicativos desconhecidos, atividade incomum em contas ou comportamento estranho após abrir um arquivo suspeito.','firstAction':'Pare de inserir senhas ou dados de pagamento no dispositivo afetado. Se houver suspeita de comprometimento ativo, desconecte-o das redes quando for viável.',
      'steps':['Use outro dispositivo confiável para alterar dados de contas sensíveis e avise a equipe de segurança se o dispositivo for gerenciado pela organização.','Não abra novamente o arquivo suspeito nem instale ferramentas recomendadas por pop-ups ou ligações não solicitadas.','Use ferramentas de segurança integradas ou confiáveis obtidas de fontes oficiais e siga as orientações documentadas.','Atualize o sistema operacional e os aplicativos quando a situação imediata estiver clara e o dispositivo puder ser usado com segurança.','Se credenciais puderem ter sido expostas, altere-as em outro dispositivo confiável e revogue sessões ativas.','Em incidentes graves ou corporativos, preserve o estado do dispositivo e procure suporte especializado antes de apagar ou reinstalar.'],
      'preserve':['Registre textos de alertas, nomes de arquivos, origem do download, horários e resultados de ferramentas de segurança.','Guarde e-mails, URLs e capturas relevantes; não envie arquivos sensíveis a serviços públicos de análise.'],
      'avoid':['Não execute scripts aleatórios de limpeza, correções de registro ou downloads desconhecidos de antivírus.','Não restaure o dispositivo de fábrica nem exclua arquivos antes de considerar necessidades de evidência e recuperação.','Não conecte unidades de backup ou outros dispositivos sem necessidade enquanto houver suspeita de comprometimento.'],
      'limit':'Esses sinais não comprovam a presença de malware. O ORVIKA não verifica arquivos, processos nem limpa dispositivos. Incidentes graves exigem análise especializada.',
    },
    'identity-exposure': {
      'title':'Dados pessoais ou de identidade foram expostos','summary':'Documentos de identidade, dados pessoais, credenciais ou registros privados podem ter sido divulgados a uma pessoa ou serviço não confiável.','firstAction':'Identifique exatamente quais informações foram expostas e proteja as contas ou serviços que dependem delas.',
      'steps':['Altere senhas expostas e senhas reutilizadas em um dispositivo confiável; ative MFA quando disponível.','Contate a organização emissora por um canal verificado de forma independente se documentos de identidade, dados financeiros ou credenciais oficiais foram expostos.','Pergunte às instituições financeiras relevantes sobre monitoramento, substituição, restrições de conta ou outras opções de proteção.','Revise configurações de recuperação e acompanhe alertas de redefinição, crédito, transações ou verificação de identidade.','Denuncie a exposição pelo canal oficial de privacidade, regulador ou autoridade policial aplicável à sua jurisdição.'],
      'preserve':['Guarde o aviso original, comunicações relevantes, datas, categorias de dados afetados e referências de protocolo.','Registre quem foi notificado e quais orientações ou medidas de proteção foram fornecidas.'],
      'avoid':['Não publique o documento exposto nem identificadores pessoais completos ao pedir ajuda.','Não envie documentos de identidade adicionais a um agente de recuperação não verificado.','Não presuma que apagar uma publicação ou mensagem remova cópias já obtidas por outras pessoas.'],
      'limit':'As opções de proteção de identidade e denúncia dependem do tipo de dado e da jurisdição. O ORVIKA não determina se as informações foram copiadas ou usadas indevidamente.',
    },
  };

  static ResponsePlaybook localize(ResponsePlaybook playbook, String languageCode) {
    if (languageCode != 'pt' && languageCode != 'pt-PT') return playbook;
    final values = _playbooks[playbook.id];
    if (values == null) return playbook;
    return ResponsePlaybook(id: playbook.id, title: languageCode == 'pt-PT' ? PortuguesePortugalText.adapt(values['title']! as String) : values['title']! as String, scenario: playbook.scenario,
      summary: languageCode == 'pt-PT' ? PortuguesePortugalText.adapt(values['summary']! as String) : values['summary']! as String, firstAction: languageCode == 'pt-PT' ? PortuguesePortugalText.adapt(values['firstAction']! as String) : values['firstAction']! as String,
      steps: List<String>.unmodifiable((values['steps']! as List<String>).map((v) => languageCode == 'pt-PT' ? PortuguesePortugalText.adapt(v) : v)),
      preserve: List<String>.unmodifiable((values['preserve']! as List<String>).map((v) => languageCode == 'pt-PT' ? PortuguesePortugalText.adapt(v) : v)),
      avoid: List<String>.unmodifiable((values['avoid']! as List<String>).map((v) => languageCode == 'pt-PT' ? PortuguesePortugalText.adapt(v) : v)), limit: languageCode == 'pt-PT' ? PortuguesePortugalText.adapt(values['limit']! as String) : values['limit']! as String);
  }
}

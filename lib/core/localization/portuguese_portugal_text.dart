/// European Portuguese (pt-PT) terminology adaptation for ORVIKA's
/// existing Portuguese source strings. Stable IDs, placeholders and analysis
/// results are deliberately untouched.
class PortuguesePortugalText {
  PortuguesePortugalText._();

  static const Map<String, String> _terms = {
    'aplicativos': 'aplicações', 'aplicativo': 'aplicação',
    'Aplicativos': 'Aplicações', 'Aplicativo': 'Aplicação',
    'celular': 'telemóvel', 'Celular': 'Telemóvel',
    'senha': 'palavra-passe', 'senhas': 'palavras-passe',
    'Senha': 'Palavra-passe', 'Senhas': 'Palavras-passe',
    'tela': 'ecrã', 'Telas': 'Ecrãs', 'telas': 'ecrãs',
    'arquivo': 'ficheiro', 'arquivos': 'ficheiros',
    'Arquivo': 'Ficheiro', 'Arquivos': 'Ficheiros',
    'usuário': 'utilizador', 'usuários': 'utilizadores',
    'Usuário': 'Utilizador', 'Usuários': 'Utilizadores',
    'configurações': 'definições', 'Configurações': 'Definições',
    'configuração': 'definição', 'Configuração': 'Definição',
    'compartilhar': 'partilhar', 'compartilhamento': 'partilha',
    'compartilhada': 'partilhada', 'compartilhado': 'partilhado',
    'compartilhadas': 'partilhadas', 'compartilhados': 'partilhados',
    'compartilhe': 'partilhe',
    'cadastro': 'registo', 'cadastrar': 'registar',
    'endereço de e-mail': 'endereço de correio eletrónico',
    'e-mail': 'correio eletrónico', 'E-mail': 'Correio eletrónico',
    'mensagem de texto': 'SMS', 'mensagens de texto': 'SMS',
    'ônibus': 'autocarro',
    'rede sem fio': 'rede sem fios', 'Wi-Fi': 'Wi-Fi',
    'acessar': 'aceder', 'Acessar': 'Aceder',
    'acesso': 'acesso', 'acessível': 'acessível',
    'obter': 'obter', 'celulares': 'telemóveis',
    'apagar': 'eliminar', 'excluir': 'eliminar',
    'Exclua': 'Elimine', 'exclua': 'elimine',
    'contate': 'contacte', 'Contate': 'Contacte',
    'contatar': 'contactar', 'Contatar': 'Contactar',
    'contato': 'contacto', 'contatos': 'contactos',
    'Contato': 'Contacto', 'Contatos': 'Contactos',
    'usuária': 'utilizadora', 'usuárias': 'utilizadoras',
    'aplicação móvel': 'aplicação móvel',
    'loja de aplicativos': 'loja de aplicações',
    'loja oficial de aplicativos': 'loja oficial de aplicações',
    'no aplicativo': 'na aplicação', 'pelo aplicativo': 'pela aplicação',
    'do aplicativo': 'da aplicação', 'um aplicativo': 'uma aplicação',
    'seu dispositivo': 'o seu dispositivo',
    'seus dados': 'os seus dados',
    'seu banco': 'o seu banco',
    'seu navegador': 'o seu navegador',
    'conectar': 'ligar', 'Conectar': 'Ligar', 'conecte': 'ligue', 'Conecte': 'Ligue',
    'escanear': 'digitalizar', 'Escanear': 'Digitalizar', 'escaneamento': 'digitalização',
    'câmera': 'câmara', 'Câmera': 'Câmara', 'câmeras': 'câmaras', 'Câmeras': 'Câmaras',
    'QR codes': 'códigos QR', 'QR code': 'código QR', 'QR Code': 'código QR',
    'conexão': 'ligação', 'Conexão': 'Ligação', 'Confira': 'Verifique', 'confira': 'verifique',
    'Pular': 'Ignorar', 'pular': 'ignorar',
    'atualizações': 'atualizações', 'celular perdido': 'telemóvel perdido',
  };

  /// European Portuguese equivalents for UI strings that previously used
  /// English call-site fallbacks. Keep these keyed by stable localization ID.
  /// Wording follows feature context rather than literal word-for-word mapping.
  static const Map<String, String> fallbacks = {
    'checker.camera.title': 'Digitalizar código',
    'checker.camera.close': 'Fechar o leitor',
    'checker.camera.requesting': 'A solicitar acesso à câmara…',
    'checker.camera.allow': 'Permitir o acesso à câmara para esta leitura',
    'checker.camera.stop': 'Parar a leitura',
    'checker.image.title': 'Digitalizar a partir de uma imagem',
    'checker.image.close': 'Fechar o leitor de imagens',
    'checker.image.instruction': 'Selecione uma imagem que contenha um código QR ou um código de barras. O processamento é efetuado neste dispositivo.',
    'checker.image.error.selection': 'Não foi possível selecionar a imagem. Verifique o ficheiro e tente novamente.',
    'checker.image.error.empty': 'A imagem selecionada está vazia ou não foi possível lê-la.',
    'checker.image.error.tooLarge': 'Selecione uma imagem com menos de 20 MB.',
    'checker.image.error.noCode': 'Não foi detetado qualquer código QR ou código de barras compatível. Experimente uma imagem mais nítida, com o código totalmente visível.',
    'checker.image.error.decode': 'Não foi possível descodificar esta imagem neste dispositivo ou navegador.',
    'checker.image.choose': 'Selecionar imagem',
    'checker.image.chooseAnother': 'Selecionar outra imagem',
    'checker.image.previewUnavailable': 'A pré-visualização da imagem não está disponível.',
    'checker.image.selected': 'Imagem selecionada',
    'checker.image.scanning': 'A analisar a imagem…',
    'checker.image.detect': 'Detetar códigos na imagem',
    'checker.image.clear': 'Limpar imagem selecionada',
    'checker.image.selectResult': 'Selecionar este resultado',
    'checker.image.detectedMany': 'Foram detetados {count} códigos',
    'checker.link.complete': 'Análise da ligação concluída. {count} ocorrências.',
    'checker.message.complete': 'Análise da mensagem concluída. {findings} ocorrências. Foram detetados {links} endereços Web.',
    'checker.qr.complete': 'Análise do código QR concluída. {title}. Gravidade: {severity}. {count} ocorrências em ligações.',
    'checker.link.description': 'Cole um URL para verificar a respetiva estrutura e identificar sinais de alerta comuns. A análise é efetuada neste dispositivo.',
    'checker.link.result': 'Resultados da análise',
    'checker.link.notice': 'Importante: a ausência de alertas estruturais não constitui um certificado de segurança. Nesta versão, o ORVIKA não abre o URL, não contacta o destino nem verifica a sua reputação.',
    'checker.message.description': 'Cole uma mensagem SMS, um e-mail ou uma mensagem de conversação suspeita para procurar sinais comuns de engenharia social. A análise é efetuada neste dispositivo.',
    'checker.message.hint': 'Cole aqui a mensagem. Evite incluir dados pessoais que não sejam relevantes.',
    'checker.message.result': 'Resultados da análise',
    'checker.message.links': 'Endereços Web detetados',
    'checker.message.notice': 'Importante: esta versão utiliza um conjunto limitado de padrões de texto transparentes. Não determina se o remetente é legítimo, não prova a existência de fraude, não analisa anexos nem compara a mensagem com fontes externas de informação sobre ameaças. Nunca partilhe códigos de utilização única (OTP), palavras-passe ou códigos de recuperação.',
    'checker.qr.description': 'Analise o conteúdo descodificado do código QR antes de abrir uma ligação, aderir a uma rede, guardar um contacto ou efetuar um pagamento.',
    'checker.qr.hint': 'Cole o texto ou o destino descodificado de um código QR',
    'checker.qr.result': 'Resultado da análise',
    'checker.qr.destination': 'Destino detetado',
    'checker.qr.notice': 'A leitura com a câmara só começa depois de selecionar explicitamente «Digitalizar» e, em seguida, «Permitir acesso à câmara para esta leitura». A câmara para quando um código é captado ou quando sai do leitor. O conteúdo descodificado é analisado neste dispositivo; o ORVIKA não abre destinos, não se liga a redes Wi-Fi, não guarda contactos, não envia mensagens nem inicia pagamentos. As permissões do navegador e do sistema operativo permanecem sob o seu controlo.',
    'privacy.reset.title': 'Repor o progresso da revisão?',
    'privacy.reset.action': 'Repor o progresso',
    'privacy.error.save': 'Não foi possível guardar esta revisão no dispositivo.',
    'checker.qr.detectedFormat': 'Formato de código detetado: {format}',
    'checker.image.error.noCode.short': 'Não foi detetado qualquer código compatível. Experimente uma imagem mais nítida.',
  };

  static String adapt(String input) {
    var value = input;
    // Longest phrases first to avoid replacing a term inside a phrase.
    final entries = _terms.entries.toList()
      ..sort((a, b) => b.key.length.compareTo(a.key.length));
    for (final entry in entries) {
      value = value.replaceAll(entry.key, entry.value);
    }
    return value;
  }

  static Map<String, String> adaptMap(Map<String, String> source) =>
      Map<String, String>.unmodifiable(source.map(
        (key, value) => MapEntry(key, adapt(value)),
      ));
}

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

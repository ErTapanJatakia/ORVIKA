import '../../features/link_check/domain/url_analyzer.dart';
import '../../features/qr_check/domain/qr_payload_analyzer.dart';

/// Spanish wording for deterministic checker findings. Detection identifiers remain canonical.
class SpanishCheckerContent {
  SpanishCheckerContent._();

  static const Map<String, ({String title, String detail})> _findings = {
    'Unicode hostname': (title:'Nombre de host Unicode', detail:'El nombre de host contiene caracteres no ASCII. Examina cuidadosamente el dominio internacionalizado para detectar caracteres parecidos y verificar su escritura exacta.'),
    'Unencrypted connection': (title:'Conexión sin cifrar', detail:'Esta dirección utiliza HTTP. Es posible que los datos intercambiados no estén protegidos durante la transmisión.'),
    'Embedded sign-in information': (title:'Información de inicio de sesión incrustada en la dirección', detail:'La dirección contiene información de usuario antes del nombre de host. Esto puede hacer que el destino parezca engañoso.'),
    'Internationalised domain encoding': (title:'Codificación de dominio internacionalizado', detail:'El nombre de host contiene Punycode. Examina cuidadosamente el dominio mostrado para detectar caracteres similares.'),
    'IP-address destination': (title:'Destino con dirección IP', detail:'La dirección apunta directamente a una dirección IPv4 en lugar de a un nombre de dominio. No tiene por qué ser malicioso, pero merece una comprobación.'),
    'Malformed IPv4-looking hostname': (title:'Nombre de host similar a IPv4 mal formado', detail:'El nombre de host parece una dirección IPv4 con puntos, pero contiene un octeto fuera del rango permitido. No supongas que conduce al destino esperado.'),
    'Unusual numeric hostname': (title:'Nombre de host numérico inusual', detail:'El nombre de host es numérico, pero no corresponde a una dirección IPv4 convencional de cuatro octetos. Algunos clientes pueden interpretar de forma diferente estos formatos numéricos.'),
    'Long subdomain chain': (title:'Cadena larga de subdominios', detail:'El nombre de host contiene varios niveles de subdominios. Comprueba cuidadosamente el dominio registrable: una marca conocida dentro de un subdominio no demuestra quién controla el destino.'),
    'Non-standard port': (title:'Puerto no estándar', detail:'Esta dirección utiliza el puerto {port} en lugar del puerto HTTP o HTTPS habitual.'),
    'Fragment present': (title:'Fragmento de URL presente', detail:'La dirección contiene un fragmento. Este forma parte de la URL proporcionada y puede afectar a la página o al enrutamiento del lado del cliente.'),
    'No structural warning detected': (title:'No se detectaron advertencias estructurales', detail:'La dirección superó estas comprobaciones locales básicas. Esto no demuestra que el sitio sea fiable o seguro.'),
    'Address not analysed': (title:'Dirección no analizada', detail:'No se pudo analizar la dirección web. Comprueba el valor introducido e inténtalo de nuevo.'),
    'Urgency or pressure language': (title:'Lenguaje de urgencia o presión', detail:'El mensaje crea sensación de urgencia o exige actuar inmediatamente. Haz una pausa y verifica la solicitud por otro canal fiable.'),
    'Credential or sign-in request': (title:'Solicitud de credenciales o inicio de sesión', detail:'El texto parece solicitar una contraseña, un inicio de sesión o la verificación de una cuenta. No introduzcas credenciales mediante un enlace recibido en un mensaje.'),
    'OTP or authentication-code reference': (title:'Referencia a OTP o código de autenticación', detail:'Se menciona una contraseña de un solo uso o un código de autenticación. Nunca compartas un OTP, código de recuperación ni solicitud de aprobación.'),
    'Payment or financial action': (title:'Pago o acción financiera', detail:'El mensaje se refiere a un pago, transferencia, reembolso, tasa u otra acción financiera. Verifica de forma independiente el destinatario y el importe antes de continuar.'),
    'Prize or unexpected reward': (title:'Premio o recompensa inesperada', detail:'Se menciona un premio o recompensa inesperada. Desconfía de solicitudes de pago o datos personales para reclamarla.'),
    'Threat or consequence language': (title:'Amenaza o anuncio de consecuencias', detail:'El mensaje amenaza con una sanción, acción legal, arresto o pérdida de acceso. Verifica estas afirmaciones usando datos de contacto de la organización obtenidos de forma independiente.'),
    'Obfuscated web address detected': (title:'Dirección web ofuscada detectada', detail:'El mensaje contiene un enlace cuyo esquema ha sido sustituido, por ejemplo hxxp o hxxps. Trátalo como una dirección que debe revisarse manualmente: no se ha normalizado ni abierto.'),
    'Link or web address detected': (title:'Enlace o dirección web detectados', detail:'Se encontraron {count} direcciones web. Un enlace visible puede ocultar un destino diferente. Comprueba cada dirección por separado antes de abrirla.'),
    'No listed social-engineering cues detected': (title:'No se detectaron indicadores conocidos de ingeniería social', detail:'El texto no coincide con los patrones limitados de esta versión. Los mensajes maliciosos también pueden parecer normales o utilizar expresiones que estas comprobaciones no detectan.'),
    'Message not analysed': (title:'Mensaje no analizado', detail:'No se pudo analizar el mensaje. Comprueba el texto introducido e inténtalo de nuevo.'),
  };

  static LinkFinding localizeFinding(LinkFinding finding, String languageCode) {
    if (languageCode != 'es') return finding;
    final translated = _findings[finding.title];
    if (translated == null) return finding;
    var detail = translated.detail;
    final portMatch = RegExp(r'port (\\d+)').firstMatch(finding.detail);
    final countMatch = RegExp(r'^(\\d+) web address').firstMatch(finding.detail);
    if (portMatch != null) detail = detail.replaceAll('{port}', portMatch.group(1)!);
    if (countMatch != null) detail = detail.replaceAll('{count}', countMatch.group(1)!);
    return LinkFinding(title: translated.title, detail: detail, severity: finding.severity);
  }

  static String localizeLinkNotice(String notice, String languageCode) {
    if (languageCode != 'es') return notice;
    if (notice == 'No network request was made.') return 'No se realizó ninguna solicitud de red.';
    return 'Solo se realizaron comprobaciones estructurales locales. No hubo solicitudes de red ni comprobaciones de reputación.';
  }

  static String localizeMessageNotice(String languageCode) => languageCode == 'es'
      ? 'Solo se realizaron comprobaciones heurísticas del texto. No se subió ningún mensaje, no se abrió ningún enlace y no se verificó la identidad ni la intención del remitente.'
      : 'Heuristic text checks only. No message was uploaded, no link was opened, and no sender identity or intent was verified.';

  static QrPayloadAnalysis localizeQr(QrPayloadAnalysis result, String languageCode) {
    if (languageCode != 'es') return result;
    const titles = <String, String>{
      'Wi-Fi configuration':'Configuración Wi-Fi','Contact card':'Tarjeta de contacto','Calendar event':'Evento de calendario',
      'UPI payment request':'Solicitud de pago UPI','Phone call action':'Acción de llamada telefónica','Email action':'Acción de correo electrónico',
      'Text-message action':'Acción de mensaje SMS','Location coordinates':'Coordenadas de ubicación','Application-specific link':'Enlace específico de una aplicación',
      'Plain text':'Texto sin formato','Web address':'Dirección web','Unrecognised web address':'Dirección web no reconocida','QR content not analysed':'Contenido QR no analizado',
    };
    const details = <String, String>{
      'Wi-Fi configuration':'Este contenido QR puede incluir el nombre de la red, el tipo de seguridad y la contraseña Wi-Fi. Verifica la red antes de conectarte: ORVIKA no se conecta automáticamente.',
      'Contact card':'Este contenido incluye datos de contacto. Comprueba nombres, teléfonos, correos e información de la organización antes de guardarlos.',
      'Calendar event':'Este contenido describe un evento de calendario. Comprueba el título, lugar, horario y enlaces incluidos antes de importarlo.',
      'UPI payment request':'Este contenido QR puede preparar un pago en una aplicación UPI. Verifica de forma independiente el identificador UPI, el nombre del beneficiario y el importe. ORVIKA no inicia ni autoriza pagos.',
      'Phone call action':'Este contenido incluye una acción de llamada. Verifica el número de forma independiente: ORVIKA no realiza llamadas.',
      'Email action':'Este contenido puede rellenar un destinatario o el texto de un correo. Comprueba todos los campos antes de enviarlo: ORVIKA no abre aplicaciones de correo.',
      'Text-message action':'Este contenido puede rellenar un destinatario o un mensaje. Comprueba el número y el texto antes de enviarlo: ORVIKA no envía SMS.',
      'Location coordinates':'Este contenido incluye una referencia de ubicación. Comprueba las coordenadas y el contexto antes de utilizarlas: ORVIKA no abre mapas.',
      'Application-specific link':'Este contenido utiliza el esquema «{scheme}:» en lugar de una URL web convencional. Puede iniciar una aplicación o acción. Ábrelo solo si confías en el origen tras verificarlo de forma independiente.',
      'Plain text':'Este contenido QR contiene texto en lugar de una dirección web o acción reconocida. Revísalo con atención: el texto también puede incluir instrucciones engañosas o información sensible.',
      'Web address':'Se detectó un destino web. Comprueba el dominio y la ruta antes de abrir el enlace.',
      'Unrecognised web address':'El contenido parece una dirección web, pero no se pudo interpretar de forma fiable. No lo abras antes de verificar el destino.',
      'QR content not analysed':'No se pudo analizar el contenido QR. Comprueba el código o la imagen e inténtalo de nuevo.',
    };
    final title = titles[result.title] ?? result.title;
    var detail = details[result.title] ?? result.detail;
    final scheme = RegExp(r'([a-zA-Z][a-zA-Z0-9+.-]*):').firstMatch(result.detail);
    if (scheme != null) detail = detail.replaceAll('{scheme}', scheme.group(1)!);
    return QrPayloadAnalysis(title:title, detail:detail, severity:result.severity, kind:result.kind,
      normalizedUrl:result.normalizedUrl, linkFindings:result.linkFindings, isValid:result.isValid);
  }
}

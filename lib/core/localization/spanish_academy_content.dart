import '../../features/academy/domain/academy_curriculum.dart';

/// Spanish lesson content keyed by stable curriculum IDs.
class SpanishAcademyContent {
  SpanishAcademyContent._();

  static const Map<String, Map<String, Object>> _lessons = {
    'verify_sender': {
      'title': 'Verifica al remitente, no al nombre mostrado',
      'summary': 'Los nombres, logotipos y fotos de perfil se pueden copiar fácilmente. Comprueba la dirección, el número o el identificador real de la cuenta antes de confiar en una solicitud.',
      'keyPoints': ['Abre los detalles del remitente y revisa la dirección de correo completa o el identificador de la cuenta.', 'Ante una solicitud inesperada, contacta con la persona u organización por un canal que ya sepas que es fiable.', 'Un nombre o logotipo conocido no demuestra la identidad.'],
      'question': 'Un mensaje parece proceder de tu banco y te pide actuar con urgencia. ¿Cuál es el primer paso más seguro?',
      'options': ['Responder y pedir al remitente que lo confirme', 'Usar directamente la aplicación del banco o un contacto oficial que ya conozcas', 'Confiar en el mensaje porque el logotipo parece correcto'],
      'explanation': 'Utiliza datos de contacto obtenidos de forma independiente. No confíes en los enlaces ni teléfonos incluidos en el mensaje inesperado.',
    },
    'phishing_links': {
      'title': 'Lee los enlaces antes de abrirlos',
      'summary': 'Un enlace puede imitar una marca de confianza y, aun así, dirigirte a un dominio ajeno o engañoso.',
      'keyPoints': ['Identifica el dominio registrable leyendo el nombre de host de derecha a izquierda; los subdominios adicionales pueden ocultar el destino.', 'Desconfía de errores ortográficos, caracteres parecidos, acortadores inesperados y textos de enlace engañosos.', 'Si tienes dudas, utiliza un marcador guardado o escribe tú mismo la dirección conocida.'],
      'question': 'Un mensaje muestra «example.com», pero el enlace real dirige a example-login.security-check.invalid. ¿Qué deberías hacer?',
      'options': ['Abrirlo porque el texto visible parece conocido', 'Evitarlo y acceder al servicio por su canal oficial conocido', 'Abrirlo en una ventana privada'],
      'explanation': 'El texto visible de un enlace puede ser distinto de su destino. La navegación privada no vuelve seguro un destino malicioso.',
    },
    'otp_secrecy': {
      'title': 'Mantén en secreto los OTP y códigos de recuperación',
      'summary': 'Las contraseñas de un solo uso, las solicitudes de aprobación de inicio de sesión y los códigos de recuperación pueden permitir que otra persona acceda a tu cuenta.',
      'keyPoints': ['Nunca reveles un OTP ni un código de recuperación a una persona que llame, a un contacto de chat o a alguien que suplante al soporte técnico.', 'No apruebes una solicitud de inicio de sesión que no hayas iniciado.', 'Si compartiste un código, protege inmediatamente la cuenta mediante el servicio oficial.'],
      'question': 'Alguien que dice ser del servicio de asistencia te pide un OTP para cancelar una transacción. ¿Qué deberías hacer?',
      'options': ['Compartirlo si conoce tu nombre', 'Compartir solo la primera mitad', 'No compartirlo, terminar el contacto y utilizar el canal oficial del servicio'],
      'explanation': 'Un OTP es un secreto de autenticación. Un proceso legítimo de asistencia no debería pedirte que lo reveles.',
    },
    'mfa_fatigue': {
      'title': 'Reconoce las solicitudes MFA inesperadas',
      'summary': 'Las solicitudes de aprobación repetidas o inesperadas pueden indicar que alguien intenta iniciar sesión con tus credenciales.',
      'keyPoints': ['Rechaza las solicitudes que no hayas iniciado.', 'No apruebes una solicitud solo para detener las notificaciones repetidas.', 'Si sospechas que la cuenta está comprometida, cambia la contraseña mediante el servicio oficial y revisa las sesiones activas.'],
      'question': 'Tu teléfono recibe varias solicitudes de aprobación de inicio de sesión cuando no estás intentando entrar. ¿Cuál es la respuesta segura?',
      'options': ['Rechazarlas y revisar la cuenta desde la configuración oficial', 'Aprobar una para detener las alertas', 'Ignorar todas las alertas futuras de la cuenta'],
      'explanation': 'Rechaza las solicitudes inesperadas. Después, revisa la cuenta desde un dispositivo de confianza y mediante el canal oficial.',
    },
    'payment_pressure': {
      'title': 'Haz una pausa antes de realizar pagos urgentes',
      'summary': 'Los estafadores aprovechan la urgencia, el secreto y la autoridad para presionar a las personas a realizar transferencias, comprar tarjetas regalo o aprobar pagos.',
      'keyPoints': ['Considera de alto riesgo los cambios de última hora en datos bancarios y las solicitudes urgentes de transferencia.', 'Verifica las instrucciones de pago con el destinatario usando un número que ya conozcas.', 'No permitas que una llamada te apresure ni te haga saltarte los controles habituales de autorización.'],
      'question': 'Un proveedor envía nuevos datos bancarios por correo y exige el pago en diez minutos. ¿Qué deberías hacer?',
      'options': ['Pagar inmediatamente para evitar una penalización', 'Verificar el cambio usando un contacto conocido previamente', 'Responder al mismo correo para preguntar si es auténtico'],
      'explanation': 'Verifica los cambios de pago de forma independiente. Responder al mismo hilo de correo, que podría estar comprometido, no es una verificación independiente.',
    },
    'qr_safety': {
      'title': 'Trata los códigos QR como enlaces',
      'summary': 'Un código QR puede contener un sitio web, una solicitud de pago, una acción de contacto u otros datos. Escanearlo no lo convierte en fiable.',
      'keyPoints': ['Previsualiza el destino decodificado o los datos del pago antes de continuar.', 'Comprueba cuidadosamente el destinatario y el importe antes de autorizar un pago.', 'Desconfía de pegatinas QR colocadas encima de un código que esperabas encontrar.'],
      'question': 'Un código QR abre una pantalla de pago. ¿Qué debes verificar antes de aprobarlo?',
      'options': ['Solo si la imagen del QR parece profesional', 'El destinatario, el importe y el motivo mediante una fuente fiable', 'Si el código se escanea rápidamente'],
      'explanation': 'Un código QR es simplemente una forma práctica de transportar datos. Verifica los detalles reales de la transacción antes de autorizarla.',
    },
    'device_updates': {
      'title': 'Mantén tus dispositivos y aplicaciones actualizados',
      'summary': 'Las actualizaciones de seguridad corrigen vulnerabilidades conocidas. Retrasarlas puede dejar los dispositivos expuestos a problemas que ya tienen solución.',
      'keyPoints': ['Instala las actualizaciones del sistema y de las aplicaciones mediante los mecanismos oficiales.', 'Elimina las aplicaciones que ya no utilizas y revisa sus permisos periódicamente.', 'Mantén una copia de seguridad recuperable y protege el dispositivo con un bloqueo de pantalla.'],
      'question': 'Hay una actualización de una aplicación en la tienda oficial de tu dispositivo. ¿Cuál es la práctica más segura?',
      'options': ['Instalarla pronto tras comprobar la fuente', 'Descargar desde un anuncio cualquier paquete que prometa una «actualización más rápida»', 'Desactivar las actualizaciones para siempre'],
      'explanation': 'Utiliza el mecanismo oficial de actualización de la plataforma y mantén el software razonablemente actualizado.',
    },
    'incident_first_steps': {
      'title': 'Actúa rápido si una cuenta puede estar comprometida',
      'summary': 'Una respuesta tranquila y ordenada puede limitar nuevos accesos y conservar información útil.',
      'keyPoints': ['Desde un dispositivo de confianza, protege la cuenta afectada mediante el servicio oficial.', 'Cambia las contraseñas reutilizadas, revoca las sesiones desconocidas y activa MFA cuando esté disponible.', 'Conserva los mensajes y registros de transacciones pertinentes; si hay dinero implicado, contacta con tu banco de inmediato.'],
      'question': 'Crees que tu cuenta de correo ha sido comprometida. ¿Cuál es el mejor punto de partida?',
      'options': ['Eliminar inmediatamente todos los mensajes sospechosos', 'Proteger la cuenta desde un dispositivo de confianza mediante el proceso oficial de recuperación', 'Publicar tus códigos de recuperación en internet para pedir ayuda'],
      'explanation': 'Protege la cuenta mediante el proceso oficial de recuperación, revisa las sesiones y conserva las pruebas que puedan ayudar en la investigación.',
    },
  };

  static AcademyLesson localize(AcademyLesson lesson, String languageCode) {
    if (languageCode != 'es') return lesson;
    final values = _lessons[lesson.id];
    if (values == null) return lesson;
    return AcademyLesson(
      id: lesson.id, title: values['title']! as String, category: lesson.category,
      summary: values['summary']! as String,
      keyPoints: List<String>.unmodifiable(values['keyPoints']! as List<String>),
      question: values['question']! as String,
      options: List<String>.unmodifiable(values['options']! as List<String>),
      correctIndex: lesson.correctIndex, explanation: values['explanation']! as String,
    );
  }
}

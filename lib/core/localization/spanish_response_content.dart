import '../../features/response/domain/response_playbooks.dart';

/// Spanish incident-response guidance keyed by stable playbook IDs.
class SpanishResponseContent {
  SpanishResponseContent._();

  static const Map<String, Map<String, Object>> _playbooks = {
    'account-compromise': {
      'title':'Una cuenta podría estar comprometida',
      'summary':'Detectas inicios de sesión desconocidos, datos de recuperación modificados, mensajes que no enviaste o solicitudes de autenticación inesperadas.',
      'firstAction':'Utiliza otro dispositivo de confianza y accede al servicio mediante su aplicación o dirección oficial.',
      'steps':['Protege primero la cuenta de correo principal si puede estar afectada; a menudo controla los restablecimientos de contraseña de otros servicios.','Cambia la contraseña afectada por una única y activa un método MFA sólido disponible.','Revisa direcciones de recuperación, teléfonos, llaves de acceso y métodos de autenticación; elimina los que no reconozcas.','Cierra las sesiones desconocidas y revoca aplicaciones conectadas o tokens de acceso que no reconozcas, si el servicio lo permite.','Comprueba reglas de reenvío, filtros del buzón, mensajes enviados y cambios recientes en la cuenta.','Si se trata de una cuenta laboral o educativa, avisa cuanto antes al equipo de TI o seguridad.'],
      'preserve':['Registra correos de alerta, horas de inicio de sesión, detalles de dispositivos o sesiones y notificaciones relevantes.','Conserva los mensajes originales y sus encabezados cuando estén disponibles; anota qué cambiaste y cuándo.'],
      'avoid':['No compartas contraseñas, OTP, códigos de recuperación ni enlaces de sesión con nadie que ofrezca ayuda.','No utilices enlaces de recuperación ni teléfonos incluidos en mensajes inesperados.','No elimines alertas potencialmente relevantes antes de registrar sus detalles.'],
      'limit':'ORVIKA no puede verificar accesos, revocar sesiones ni recuperar cuentas. Sigue el proceso oficial de recuperación del servicio; los pasos y nombres varían.',
    },
    'payment-fraud': {
      'title':'Pago sospechoso o no autorizado',
      'summary':'Enviaste dinero bajo presión, aprobaste un pago inesperado, compartiste credenciales de pago o ves una transacción que no reconoces.',
      'firstAction':'Contacta inmediatamente con tu banco o proveedor de pagos mediante su aplicación oficial, el número de tu tarjeta o un sitio web verificado de forma independiente.',
      'steps':['Solicita al proveedor que proteja la cuenta, tarjeta, cartera o instrumento de pago afectado y explica el proceso disponible para disputar o recuperar la operación.','Notifica la transacción como no autorizada o inducida por una estafa; facilita referencia, importe, fecha y datos del destinatario.','Cambia las credenciales bancarias o de correo expuestas desde un dispositivo de confianza y revisa sesiones y mandatos de pago activos.','Si las credenciales o la SIM pueden estar comprometidas, informa al banco y al operador móvil correspondiente.','Utiliza el canal oficial de denuncia gubernamental o policial de tu jurisdicción y conserva el justificante o número de caso.'],
      'preserve':['Guarda identificadores de transacción, avisos bancarios, recibos, datos del beneficiario, registros de llamadas y conversaciones.','Anota cuándo detectaste el problema y cuándo contactaste con el proveedor.'],
      'avoid':['No pagues a nadie que prometa recuperar el dinero de forma garantizada o exija una tarifa por adelantado.','No apruebes nuevas solicitudes de cobro, mandatos de pago ni sesiones de acceso remoto.','No confíes en los datos de contacto enviados por el presunto estafador.'],
      'limit':'Un pago puede no ser reversible. ORVIKA no puede bloquear cuentas, rastrear fondos ni presentar denuncias. Contacta con el proveedor sin demora; los plazos y canales varían.',
    },
    'lost-device': {
      'title':'Se ha perdido un teléfono, ordenador o dispositivo',
      'summary':'Un dispositivo ha desaparecido, ha sido robado o puede estar al alcance de otra persona.',
      'firstAction':'Desde otro dispositivo de confianza, utiliza el servicio oficial de seguridad de cuenta y localización del fabricante o la plataforma.',
      'steps':['Si está disponible, marca el dispositivo como perdido o bloquéalo de forma remota; valora el borrado remoto según la sensibilidad de los datos y las posibilidades de recuperación.','Contacta con tu operador móvil para suspender la SIM o eSIM perdida y pregunta cómo proteger el número.','Cambia las contraseñas del correo principal y de cuentas financieras o de identidad si el dispositivo podía estar desbloqueado o guardaba credenciales.','Revoca sesiones de dispositivos de confianza y revisa los métodos de recuperación desde otro dispositivo seguro.','Denuncia el posible robo ante la autoridad local correspondiente y sigue el procedimiento de tu organización si era un dispositivo gestionado.'],
      'preserve':['Guarda el número de serie, IMEI cuando corresponda, comprobante de compra y alertas oficiales de localización o seguridad.','Registra cuándo y dónde se vio por última vez y las medidas adoptadas para bloquearlo o denunciarlo.'],
      'avoid':['No confrontes ni te reúnas con alguien que afirme tener el dispositivo; recurre a las autoridades competentes.','No sigas mensajes que pidan desactivar la protección del dispositivo o revelar credenciales.','No supongas que una estimación de ubicación es exacta ni que sea seguro actuar por tu cuenta.'],
      'limit':'La localización, el bloqueo y el borrado remoto dependen de la configuración previa, la conectividad y la plataforma. El borrado puede afectar a las pruebas o la recuperación; valora la situación antes de continuar.',
    },
    'suspected-malware': {
      'title':'Un dispositivo podría tener malware',
      'summary':'Aparecen ventanas emergentes inesperadas, alertas de seguridad, aplicaciones desconocidas, actividad inusual en cuentas o comportamientos extraños tras abrir un archivo sospechoso.',
      'firstAction':'Deja de introducir contraseñas o datos de pago en el dispositivo afectado. Si sospechas de una intrusión activa, desconéctalo de las redes cuando sea práctico.',
      'steps':['Utiliza otro dispositivo de confianza para cambiar datos de cuentas sensibles y avisa al equipo de seguridad si el dispositivo es corporativo.','No vuelvas a abrir el archivo sospechoso ni instales herramientas recomendadas por ventanas emergentes o llamadas no solicitadas.','Utiliza herramientas de seguridad integradas o fiables obtenidas de fuentes oficiales y sigue sus instrucciones documentadas.','Actualiza el sistema operativo y las aplicaciones cuando se haya comprendido la situación inmediata y el dispositivo sea seguro de usar.','Si las credenciales pudieron quedar expuestas, cámbialas desde otro dispositivo de confianza y revoca las sesiones activas.','En incidentes graves o laborales, conserva el estado del dispositivo y busca ayuda especializada antes de borrarlo o reinstalarlo.'],
      'preserve':['Registra el texto de las alertas, nombres de archivos, origen de descarga, horas y resultados de herramientas de seguridad.','Conserva correos, URL y capturas relevantes; no subas archivos sensibles a servicios públicos de análisis.'],
      'avoid':['No ejecutes scripts de limpieza, correcciones del registro ni descargas antivirus desconocidas.','No restablezcas el dispositivo de fábrica ni elimines archivos antes de considerar las necesidades de prueba y recuperación.','No conectes unidades de respaldo u otros dispositivos innecesariamente mientras sospeches de una intrusión.'],
      'limit':'Estas señales no demuestran que exista malware. ORVIKA no analiza archivos, procesos ni limpia dispositivos. Los incidentes graves requieren análisis especializado.',
    },
    'identity-exposure': {
      'title':'Se han expuesto datos personales o de identidad',
      'summary':'Documentos de identidad, datos personales, credenciales o registros privados pueden haberse divulgado a una persona o servicio no fiable.',
      'firstAction':'Identifica exactamente qué información se expuso y protege las cuentas o servicios que dependan de ella.',
      'steps':['Cambia las contraseñas expuestas y las que hayas reutilizado desde un dispositivo de confianza; activa MFA cuando esté disponible.','Contacta con la entidad emisora por un canal verificado de forma independiente si se expusieron documentos de identidad, datos financieros o credenciales oficiales.','Pregunta a las instituciones financieras pertinentes por opciones de supervisión, sustitución, restricciones u otras medidas de protección.','Revisa la configuración de recuperación y vigila alertas de restablecimiento, crédito, transacciones o verificación de identidad.','Denuncia la exposición mediante el canal oficial de privacidad, regulador o autoridad policial aplicable en tu jurisdicción.'],
      'preserve':['Conserva el aviso original, comunicaciones relevantes, fechas, categorías de datos afectados y referencias de caso.','Registra a quién notificaste y qué consejos o medidas de protección te proporcionaron.'],
      'avoid':['No publiques el documento expuesto ni identificadores personales completos al pedir ayuda.','No envíes documentos de identidad adicionales a un agente de recuperación no verificado.','No supongas que borrar una publicación o mensaje elimina las copias que otras personas ya hayan obtenido.'],
      'limit':'Las opciones de protección de identidad y denuncia dependen del tipo de datos y la jurisdicción. ORVIKA no puede determinar si la información se copió o utilizó indebidamente.',
    },
  };

  static ResponsePlaybook localize(ResponsePlaybook playbook, String languageCode) {
    if (languageCode != 'es') return playbook;
    final values = _playbooks[playbook.id];
    if (values == null) return playbook;
    return ResponsePlaybook(
      id: playbook.id, title: values['title']! as String, scenario: playbook.scenario,
      summary: values['summary']! as String, firstAction: values['firstAction']! as String,
      steps: List<String>.unmodifiable(values['steps']! as List<String>),
      preserve: List<String>.unmodifiable(values['preserve']! as List<String>),
      avoid: List<String>.unmodifiable(values['avoid']! as List<String>),
      limit: values['limit']! as String,
    );
  }
}

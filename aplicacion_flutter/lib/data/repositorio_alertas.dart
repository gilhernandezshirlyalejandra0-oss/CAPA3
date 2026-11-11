import 'dart:async';

import '../models/alerta_seguridad.dart';

enum EscenarioAlerta { conDatos, vacio, falla, cargando }

class RepositorioAlertas {
  EscenarioAlerta escenario = EscenarioAlerta.conDatos;

  final List<AlertaSeguridad> _ejemplos = const [
    AlertaSeguridad(
      id: 1,
      titulo: 'Un premio inesperado',
      tipo: 'SMS',
      nivelRiesgo: 'Alto',
      descripcion: 'Un mensaje afirma que ganaste un premio que no recuerdas haber participado.',
      mensajeEjemplo: '¡FELICIDADES! Ganaste un celular. Reclámalo hoy ingresando tus datos en este enlace.',
      senales: [
        'Te ofrecen un premio que no esperabas.',
        'Te piden actuar rápidamente.',
        'Solicitan tus datos personales.',
      ],
      recomendacion: 'No abras el enlace ni entregues tus datos. Si no participaste en un concurso, desconfía del supuesto premio.',
    ),
    AlertaSeguridad(
      id: 2,
      titulo: 'Supuesto bloqueo bancario',
      tipo: 'WhatsApp',
      nivelRiesgo: 'Alto',
      descripcion: 'Un mensaje afirma que tu cuenta bancaria será bloqueada.',
      mensajeEjemplo: 'Su cuenta será bloqueada en 10 minutos. Envíe su clave para evitar el cierre.',
      senales: [
        'Utiliza amenazas para asustarte.',
        'Te exige responder inmediatamente.',
        'Solicita una clave bancaria.',
      ],
      recomendacion: 'No respondas ni compartas tus claves. Comunícate con tu banco utilizando su número oficial.',
    ),
    AlertaSeguridad(
      id: 3,
      titulo: 'Paquete retenido',
      tipo: 'SMS',
      nivelRiesgo: 'Medio',
      descripcion: 'Un mensaje dice que tienes un paquete detenido y debes pagar para recibirlo.',
      mensajeEjemplo: 'Su paquete está retenido. Pague un pequeño valor en este enlace para recibirlo.',
      senales: [
        'No identifica claramente la empresa de mensajería.',
        'Solicita un pago inesperado.',
        'Incluye un enlace para realizar el supuesto pago.',
      ],
      recomendacion: 'No pagues desde el enlace. Consulta directamente con la empresa de mensajería mediante sus canales oficiales.',
    ),
    AlertaSeguridad(
      id: 4,
      titulo: 'Correo de remitente desconocido',
      tipo: 'Correo electrónico',
      nivelRiesgo: 'Medio',
      descripcion: 'Recibes un correo que intenta convencerte de abrir un archivo o enlace.',
      mensajeEjemplo: 'Estimado usuario: revise urgentemente el documento adjunto para evitar inconvenientes con su cuenta.',
      senales: [
        'No reconoces a la persona que envía el correo.',
        'El mensaje utiliza expresiones de urgencia.',
        'Te invita a abrir archivos inesperados.',
      ],
      recomendacion: 'No abras archivos ni enlaces inesperados. Verifica quién envió el mensaje antes de realizar cualquier acción.',
    ),
    AlertaSeguridad(
      id: 5,
      titulo: 'Solicitud de código de verificación',
      tipo: 'WhatsApp',
      nivelRiesgo: 'Alto',
      descripcion: 'Una persona te pide un código que recibiste en tu celular.',
      mensajeEjemplo: 'Hola, te envié un código por error. ¿Me lo puedes compartir, por favor?',
      senales: [
        'Te solicitan un código personal.',
        'La persona puede hacerse pasar por un conocido.',
        'El código podría permitir el acceso a tu cuenta.',
      ],
      recomendacion: 'Nunca compartas códigos de verificación. Si alguien conocido te lo pide, confirma su identidad por otro medio.',
    ),
  ];

  Future<List<AlertaSeguridad>> obtenerTodas() async {
    if (escenario == EscenarioAlerta.cargando) {
      await Completer<void>().future;
    }

    await Future<void>.delayed(const Duration(milliseconds: 800));

    if (escenario == EscenarioAlerta.falla) {
      throw Exception('Falla simulada al cargar los ejemplos educativos');
    }

    if (escenario == EscenarioAlerta.vacio) {
      return const [];
    }

    return _ejemplos;
  }
}

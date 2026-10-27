import 'dart:async';

import '../models/alerta_seguridad.dart';

enum EscenarioAlerta { conDatos, vacio, falla, cargando }

class RepositorioAlertas {
  EscenarioAlerta escenario = EscenarioAlerta.conDatos;

  final List<AlertaSeguridad> _ejemplos = const [
    AlertaSeguridad(
      id: 1,
      titulo: 'Mensaje de premio inesperado',
      tipo: 'SMS',
      nivelRiesgo: 'Alto',
      descripcion: 'Promete un premio y solicita abrir un enlace.',
    ),
    AlertaSeguridad(
      id: 2,
      titulo: 'Supuesto bloqueo bancario',
      tipo: 'WhatsApp',
      nivelRiesgo: 'Alto',
      descripcion: 'Pide datos personales con urgencia.',
    ),
    AlertaSeguridad(
      id: 3,
      titulo: 'Paquete retenido',
      tipo: 'SMS',
      nivelRiesgo: 'Medio',
      descripcion: 'Solicita pagar un cargo mediante un enlace.',
    ),
    AlertaSeguridad(
      id: 4,
      titulo: 'Correo de remitente desconocido',
      tipo: 'Correo',
      nivelRiesgo: 'Medio',
      descripcion: 'Incluye un enlace que conviene verificar.',
    ),
    AlertaSeguridad(
      id: 5,
      titulo: 'Solicitud de código de verificación',
      tipo: 'WhatsApp',
      nivelRiesgo: 'Alto',
      descripcion: 'Nunca compartas códigos de acceso con terceros.',
    ),
  ];

  Future<List<AlertaSeguridad>> obtenerTodas() async {
    if (escenario == EscenarioAlerta.cargando) {
      await Completer<void>().future;
    }

    await Future<void>.delayed(const Duration(milliseconds: 1500));

    if (escenario == EscenarioAlerta.falla) {
      throw Exception('Falla simulada al cargar las alertas');
    }

    if (escenario == EscenarioAlerta.vacio) {
      return const [];
    }

    return _ejemplos;
  }
}

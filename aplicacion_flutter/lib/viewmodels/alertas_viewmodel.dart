import 'package:flutter/foundation.dart';

import '../data/repositorio_alertas.dart';
import '../models/alerta_seguridad.dart';

enum EstadoAlertas { cargando, vacio, error, listo }

class AlertasViewModel extends ChangeNotifier {
  AlertasViewModel({RepositorioAlertas? repositorio})
    : _repositorio = repositorio ?? RepositorioAlertas();

  final RepositorioAlertas _repositorio;

  List<AlertaSeguridad> alertas = [];
  EstadoAlertas estado = EstadoAlertas.cargando;
  String mensajeError = '';

  Future<void> cargar() async {
    estado = EstadoAlertas.cargando;
    mensajeError = '';
    notifyListeners();

    try {
      alertas = await _repositorio.obtenerTodas();
      estado = alertas.isEmpty ? EstadoAlertas.vacio : EstadoAlertas.listo;
    } catch (_) {
      alertas = [];
      mensajeError = 'No pudimos cargar las alertas. Intenta nuevamente.';
      estado = EstadoAlertas.error;
    }

    notifyListeners();
  }

  Future<void> cambiarEscenario(EscenarioAlerta escenario) async {
    _repositorio.escenario = escenario;
    await cargar();
  }
}

import 'package:flutter/material.dart';

import '../data/opciones_repository.dart';
import '../models/opcion_menu.dart';

enum EstadoPantalla { carga, vacio, error, datos }

class BienvenidaViewModel extends ChangeNotifier {
  BienvenidaViewModel({OpcionesRepository? repositorio})
    : _repositorio = repositorio ?? OpcionesRepository();

  final OpcionesRepository _repositorio;

  List<OpcionMenu> opciones = [];
  EstadoPantalla estado = EstadoPantalla.carga;
  String mensajeError = '';

  void cargarOpciones() {
    try {
      estado = EstadoPantalla.carga;
      mensajeError = '';

      opciones = _repositorio.obtenerOpciones();

      estado = opciones.isEmpty ? EstadoPantalla.vacio : EstadoPantalla.datos;
    } catch (error) {
      opciones = [];
      mensajeError = 'No se pudieron cargar las opciones. Intenta nuevamente.';
      estado = EstadoPantalla.error;
    }

    notifyListeners();
  }
}

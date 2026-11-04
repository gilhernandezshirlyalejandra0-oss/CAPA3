import 'package:flutter/material.dart';

import '../models/opcion_menu.dart';

class OpcionesRepository {
  List<OpcionMenu> obtenerOpciones() {
    return const [
      OpcionMenu(
        icono: Icons.link,
        titulo: 'Revisar un enlace',
        descripcion: 'Comprueba si un enlace puede ser sospechoso.',
      ),
      OpcionMenu(
        icono: Icons.message_outlined,
        titulo: 'Analizar un mensaje',
        descripcion: 'Identifica señales de posibles engaños.',
      ),
      OpcionMenu(
        icono: Icons.school_outlined,
        titulo: 'Aprender sobre seguridad',
        descripcion: 'Aprende a protegerte de las estafas digitales.',
      ),
      OpcionMenu(
        icono: Icons.shield_outlined,
        titulo: 'Consultar un riesgo',
        descripcion: 'Conoce señales de alerta para navegar con cuidado.',
      ),
    ];
  }
}

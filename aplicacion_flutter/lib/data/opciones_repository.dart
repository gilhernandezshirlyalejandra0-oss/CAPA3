import 'package:flutter/material.dart';

import '../models/opcion_menu.dart';

class OpcionesRepository {
  List<OpcionMenu> obtenerOpciones() {
    return const [
      OpcionMenu(
        icono: Icons.menu_book_rounded,
        titulo: 'Aprende sobre el phishing',
        descripcion: 'Conoce qué es el phishing y cómo pueden engañarte.',
      ),
      OpcionMenu(
        icono: Icons.mark_chat_unread_rounded,
        titulo: 'Reconoce los engaños',
        descripcion: 'Aprende a identificar engaños con ejemplos cotidianos.',
      ),
      OpcionMenu(
        icono: Icons.quiz_rounded,
        titulo: 'Pon a prueba lo aprendido',
        descripcion: 'Practica con preguntas y actividades educativas.',
      ),
      OpcionMenu(
        icono: Icons.shield_rounded,
        titulo: 'Consejos de seguridad',
        descripcion: 'Descubre cómo cuidar tus datos y cuentas personales.',
      ),
    ];
  }
}

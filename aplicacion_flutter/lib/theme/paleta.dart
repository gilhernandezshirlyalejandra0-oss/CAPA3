import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Paleta "Intenso e Impactante": colores planos y vivos, estilo póster ilustrado.
class Paleta {
  Paleta._();

  // Colores principales (referencia: Papaya, Mustard, Blush, Aqua)
  static const Color papaya = Color(0xFFE24E42);
  static const Color mostaza = Color(0xFFE9B000);
  static const Color rubor = Color(0xFFEB6E80);
  static const Color aqua = Color(0xFF008F95);

  // Neutros
  static const Color tinta = Color(0xFF22201F);
  static const Color tintaSuave = Color(0xFF4A4542);
  static const Color crema = Color(0xFFFFF8EF);
  static const Color arena = Color(0xFFF1E6D6);
  static const Color ciruela = Color(0xFF3B2A3F); // tono oscuro de las ilustraciones

  // Versiones suaves para fondos de tarjetas
  static const Color papayaSuave = Color(0xFFFBE0DC);
  static const Color mostazaSuave = Color(0xFFFCEFC7);
  static const Color ruborSuave = Color(0xFFFCE3E7);
  static const Color aquaSuave = Color(0xFFD3EFEF);

  static const List<Color> vivos = [papaya, mostaza, rubor, aqua];
}

/// Tipografías: Fredoka para títulos llamativos, Nunito para leer cómodo.
class Letras {
  Letras._();

  static TextStyle titulo({
    double size = 28,
    Color color = Paleta.tinta,
    FontWeight weight = FontWeight.w700,
    double? height,
    double? letterSpacing,
  }) =>
      GoogleFonts.fredoka(
        fontSize: size,
        color: color,
        fontWeight: weight,
        height: height,
        letterSpacing: letterSpacing,
      );

  static String? get familiaCuerpo => GoogleFonts.nunito().fontFamily;
}

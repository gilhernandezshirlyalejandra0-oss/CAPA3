import 'package:flutter/material.dart';

enum TipoPelo { rizosLargos, rizosCortos, monoCanoso, cortoCanoso, lisoLargo, lisoCorto, trenzas, calvo }

enum GeneroVoz { femenina, masculina }

/// Un personaje que acompaña a la persona y le habla con cariño.
class Personaje {
  const Personaje({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.saludo,
    required this.piel,
    required this.pelo,
    required this.peloOscuro,
    required this.tipoPelo,
    required this.camisa,
    required this.fondo,
    this.ojos = const Color(0xFF241A17),
    this.pestanas = false,
    this.pecas = false,
    this.gafas = false,
    this.bigote = false,
    this.ganchos = false,
    this.esNino = true,
    this.gorra,
    this.sombrero = false,
    this.gafasOscuras = false,
    this.aretes = false,
    this.barba = false,
    this.corbata = false,
    required this.genero,
    required this.tono,
    required this.ritmo,
  });

  final String id;
  final String nombre;
  final String descripcion;
  final String saludo;

  final Color piel;
  final Color pelo;
  final Color peloOscuro;
  final TipoPelo tipoPelo;
  final Color camisa;
  final Color fondo;
  final Color ojos;
  final bool pestanas;
  final bool pecas;
  final bool gafas;
  final bool bigote;
  final bool ganchos;
  final bool esNino;

  // Accesorios para que cada personaje se vea distinto
  final Color? gorra;
  final bool sombrero;
  final bool gafasOscuras;
  final bool aretes;
  final bool barba;
  final bool corbata;

  // Voz
  final GeneroVoz genero;
  final double tono;
  final double ritmo;
}

class Asistente {
  Asistente._();

  static const List<Personaje> todos = [
    Personaje(
      id: 'luna',
      nombre: 'Luna',
      descripcion: 'Voz de niña',
      saludo:
          '¡Hola, hola! Soy Luna. ¡Qué alegría que estés aquí! Yo te voy a acompañar para que nadie te engañe por el celular. ¿Empezamos juntos?',
      piel: Color(0xFFFBE3D3),
      pelo: Color(0xFFD9542B),
      peloOscuro: Color(0xFFA63A1B),
      tipoPelo: TipoPelo.rizosLargos,
      camisa: Color(0xFF008F95),
      fondo: Color(0xFFFCE3E7),
      pestanas: true,
      pecas: true,
      ganchos: true,
      genero: GeneroVoz.femenina,
      tono: 1.55,
      ritmo: 1.05,
    ),
    Personaje(
      id: 'tomas',
      nombre: 'Tomás',
      descripcion: 'Voz de niño',
      saludo:
          '¡Quiubo! Soy Tomás. Me encanta que vengas a aprender conmigo. Te voy a contar los trucos de los tramposos para que no te pase nada. ¿Listo?',
      piel: Color(0xFFD9A47E),
      pelo: Color(0xFF1E1A1C),
      peloOscuro: Color(0xFF000000),
      tipoPelo: TipoPelo.rizosCortos,
      camisa: Color(0xFF2C3E78),
      fondo: Color(0xFFD3EFEF),
      pecas: true,
      genero: GeneroVoz.masculina,
      tono: 1.45,
      ritmo: 1.05,
    ),
    Personaje(
      id: 'rosa',
      nombre: 'Doña Rosa',
      descripcion: 'Voz de mujer',
      saludo:
          'Hola, mi amor. Soy Rosa. Tómate tu tiempo, que aquí vamos despacito. Te voy a enseñar a cuidar tu platica y tu WhatsApp. ¿Te parece?',
      piel: Color(0xFFF3CDB3),
      pelo: Color(0xFFD9D4CF),
      peloOscuro: Color(0xFFA9A29C),
      tipoPelo: TipoPelo.monoCanoso,
      camisa: Color(0xFFE24E42),
      fondo: Color(0xFFFCEFC7),
      pestanas: true,
      gafas: true,
      esNino: false,
      genero: GeneroVoz.femenina,
      tono: 1.0,
      ritmo: 0.88,
    ),
    Personaje(
      id: 'julio',
      nombre: 'Don Julio',
      descripcion: 'Voz de hombre',
      saludo:
          '¡Buenas, buenas! Soy Julio. Cuente conmigo como con un vecino de confianza. Vamos a aprender a reconocer a los estafadores, sin afanes. ¿Arrancamos?',
      piel: Color(0xFFC98E6B),
      pelo: Color(0xFFE6E2DD),
      peloOscuro: Color(0xFFB5AEA7),
      tipoPelo: TipoPelo.cortoCanoso,
      camisa: Color(0xFFE9B000),
      fondo: Color(0xFFFBE0DC),
      gafas: true,
      bigote: true,
      esNino: false,
      genero: GeneroVoz.masculina,
      tono: 0.85,
      ritmo: 0.9,
    ),
  ];

  static final ValueNotifier<Personaje> actual = ValueNotifier<Personaje>(todos.first);

  // ───── Personajes de los cuentos y escenas (no se eligen, actúan) ─────

  static const Personaje carmen = Personaje(
    id: 'carmen', nombre: 'Doña Carmen', descripcion: '', saludo: '',
    piel: Color(0xFFF1C9AE), pelo: Color(0xFFCFCAC4), peloOscuro: Color(0xFF9D968F),
    tipoPelo: TipoPelo.monoCanoso, camisa: Color(0xFFEB6E80), fondo: Color(0xFFFCE3E7),
    pestanas: true, gafas: true, aretes: true, esNino: false,
    genero: GeneroVoz.femenina, tono: 1.0, ritmo: 0.9,
  );

  static const Personaje andres = Personaje(
    id: 'andres', nombre: 'Andrés', descripcion: '', saludo: '',
    piel: Color(0xFFE2B08D), pelo: Color(0xFF4A2F22), peloOscuro: Color(0xFF2B1A12),
    tipoPelo: TipoPelo.lisoCorto, camisa: Color(0xFF008F95), fondo: Color(0xFFD3EFEF),
    genero: GeneroVoz.masculina, tono: 1.2, ritmo: 1.0,
  );

  static const Personaje estafador = Personaje(
    id: 'estafador', nombre: 'Estafador', descripcion: '', saludo: '',
    piel: Color(0xFFBFA79A), pelo: Color(0xFF2B2B33), peloOscuro: Color(0xFF111116),
    tipoPelo: TipoPelo.lisoCorto, camisa: Color(0xFF3B2A3F), fondo: Color(0xFFE4DDE8),
    gafasOscuras: true, corbata: true, esNino: false,
    genero: GeneroVoz.masculina, tono: 0.8, ritmo: 1.0,
  );

  static const Personaje hernando = Personaje(
    id: 'hernando', nombre: 'Don Hernando', descripcion: '', saludo: '',
    piel: Color(0xFF9E6B4E), pelo: Color(0xFFE6E2DD), peloOscuro: Color(0xFFB5AEA7),
    tipoPelo: TipoPelo.calvo, camisa: Color(0xFF6E9B5B), fondo: Color(0xFFFCEFC7),
    bigote: true, sombrero: true, esNino: false,
    genero: GeneroVoz.masculina, tono: 0.9, ritmo: 0.9,
  );

  static const Personaje gloria = Personaje(
    id: 'gloria', nombre: 'Gloria', descripcion: '', saludo: '',
    piel: Color(0xFFE8B996), pelo: Color(0xFF6B4A3A), peloOscuro: Color(0xFF3F2A20),
    tipoPelo: TipoPelo.lisoCorto, camisa: Color(0xFF008F95), fondo: Color(0xFFD3EFEF),
    pestanas: true, aretes: true, esNino: false,
    genero: GeneroVoz.femenina, tono: 1.0, ritmo: 0.9,
  );

  static const Personaje ruben = Personaje(
    id: 'ruben', nombre: 'Rubén', descripcion: '', saludo: '',
    piel: Color(0xFFC98E6B), pelo: Color(0xFFDAD6D0), peloOscuro: Color(0xFFADA6A0),
    tipoPelo: TipoPelo.calvo, camisa: Color(0xFFE24E42), fondo: Color(0xFFFBE0DC),
    gafas: true, barba: true, esNino: false,
    genero: GeneroVoz.masculina, tono: 0.9, ritmo: 0.9,
  );

  static const Personaje mercedes = Personaje(
    id: 'mercedes', nombre: 'Mercedes', descripcion: '', saludo: '',
    piel: Color(0xFF8D5B40), pelo: Color(0xFF231815), peloOscuro: Color(0xFF000000),
    tipoPelo: TipoPelo.trenzas, camisa: Color(0xFFE9B000), fondo: Color(0xFFFCEFC7),
    pestanas: true, aretes: true, esNino: false,
    genero: GeneroVoz.femenina, tono: 1.0, ritmo: 0.9,
  );

  static const Personaje valentina = Personaje(
    id: 'valentina', nombre: 'Valentina', descripcion: '', saludo: '',
    piel: Color(0xFFF5D5C0), pelo: Color(0xFFE2B354), peloOscuro: Color(0xFFB8862C),
    tipoPelo: TipoPelo.lisoLargo, camisa: Color(0xFFEB6E80), fondo: Color(0xFFFCE3E7),
    pestanas: true, aretes: true, esNino: false,
    genero: GeneroVoz.femenina, tono: 1.1, ritmo: 1.0,
  );

  // ───── "Disfraces" de los estafadores en la sección Chats ─────

  static const Personaje estafadorPremio = Personaje(
    id: 'e_premio', nombre: 'Promociones Ganadoras', descripcion: '', saludo: '',
    piel: Color(0xFFE0B596), pelo: Color(0xFF3A2A20), peloOscuro: Color(0xFF1C130E),
    tipoPelo: TipoPelo.lisoCorto, camisa: Color(0xFFE9B000), fondo: Color(0xFFFCEFC7),
    gorra: Color(0xFFE24E42), esNino: false,
    genero: GeneroVoz.masculina, tono: 1.0, ritmo: 1.0,
  );

  static const Personaje estafadorBanco = Personaje(
    id: 'e_banco', nombre: 'Banco Seguridad', descripcion: '', saludo: '',
    piel: Color(0xFFCFA68A), pelo: Color(0xFF1E1A1C), peloOscuro: Color(0xFF000000),
    tipoPelo: TipoPelo.lisoCorto, camisa: Color(0xFF2C3E78), fondo: Color(0xFFD3EFEF),
    gafasOscuras: true, corbata: true, esNino: false,
    genero: GeneroVoz.masculina, tono: 0.8, ritmo: 1.0,
  );

  static const Personaje estafadorPaquete = Personaje(
    id: 'e_paquete', nombre: 'Envíos Express', descripcion: '', saludo: '',
    piel: Color(0xFFA9745A), pelo: Color(0xFF2B1A12), peloOscuro: Color(0xFF000000),
    tipoPelo: TipoPelo.rizosCortos, camisa: Color(0xFFE24E42), fondo: Color(0xFFFBE0DC),
    gorra: Color(0xFFE9B000), barba: true, esNino: false,
    genero: GeneroVoz.masculina, tono: 0.9, ritmo: 1.0,
  );

  static const Personaje estafadorCobro = Personaje(
    id: 'e_cobro', nombre: 'Cobranzas Jurídicas', descripcion: '', saludo: '',
    piel: Color(0xFFE7C2A6), pelo: Color(0xFF8A817A), peloOscuro: Color(0xFF5A534D),
    tipoPelo: TipoPelo.calvo, camisa: Color(0xFF3B2A3F), fondo: Color(0xFFE4DDE8),
    gafas: true, bigote: true, corbata: true, esNino: false,
    genero: GeneroVoz.masculina, tono: 0.8, ritmo: 1.0,
  );

  static const Personaje estafadorVecina = Personaje(
    id: 'e_vecina', nombre: 'Vecina (¿será?)', descripcion: '', saludo: '',
    piel: Color(0xFFF1CDB5), pelo: Color(0xFF7A3E2A), peloOscuro: Color(0xFF4E2618),
    tipoPelo: TipoPelo.lisoLargo, camisa: Color(0xFF6E9B5B), fondo: Color(0xFFE4F0DD),
    pestanas: true, aretes: true, gafasOscuras: true, esNino: false,
    genero: GeneroVoz.femenina, tono: 1.1, ritmo: 1.0,
  );
}

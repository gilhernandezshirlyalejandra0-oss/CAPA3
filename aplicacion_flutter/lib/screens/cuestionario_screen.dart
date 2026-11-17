import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../services/asistente.dart';
import '../services/voz_humana.dart';
import '../theme/paleta.dart';
import '../widgets/avatar_parlante.dart';
import '../widgets/escena_animada.dart';
import '../widgets/fondos_dibujados.dart';

const Color fondoCrema = Paleta.crema;
const Color textoCarbon = Paleta.tinta;
const Color verdeSalvia = Paleta.aqua;
const Color verdeSuave = Paleta.aquaSuave;
const Color terracota = Paleta.papaya;
const Color terracotaSuave = Paleta.papayaSuave;
const Color amarilloCalido = Paleta.mostazaSuave;

/// La escena que ilustra cada caso del juego.
const List<Escena> _escenasJuego = [
  Escena(imagen: 'juego_1.png', lugar: Lugar.sala, personaje: Asistente.mercedes,
      objeto: Icons.card_giftcard_rounded, globo: '?'),
  Escena(imagen: 'juego_2.png', lugar: Lugar.oficina, personaje: Asistente.hernando,
      objeto: Icons.phone_in_talk_rounded, globo: '?'),
  Escena(imagen: 'juego_3.png', lugar: Lugar.casa, personaje: Asistente.carmen,
      acompanante: Asistente.estafadorVecina, objeto: Icons.chat_rounded, globo: '?'),
  Escena(imagen: 'juego_4.png', lugar: Lugar.calle, personaje: Asistente.ruben,
      objeto: Icons.local_shipping_rounded, globo: '?'),
];

/// Misma escena, pero el personaje reacciona a la respuesta.
Escena _reaccion(Escena e, bool acerto) => Escena(
      imagen: e.imagen,
      lugar: e.lugar,
      personaje: e.personaje,
      acompanante: e.acompanante,
      objeto: acerto ? Icons.verified_user_rounded : Icons.warning_rounded,
      expresion: acerto ? Expresion.feliz : Expresion.preocupada,
      globo: acerto ? '¡Bien!' : '¡Uy!',
      saludando: acerto,
    );

class CuestionarioScreen extends StatefulWidget {
  const CuestionarioScreen({super.key});

  @override
  State<CuestionarioScreen> createState() => _CuestionarioScreenState();
}

class _CuestionarioScreenState extends State<CuestionarioScreen> {
  final AdaptadorVoz _tts = VozHumana.adaptador();

  int _preguntaActual = 0;
  int _puntaje = 0;
  int? _respuestaSeleccionada;
  bool _finalizado = false;

  static const List<_PreguntaCaso> _preguntas = [
    _PreguntaCaso(
      situacion:
          'Te llega un mensaje diciendo que ganaste un bono o mercado, pero debes tocar unas letras azules y anotar tu cédula y clave. ¿Qué haces?',
      opciones: [
        'Anoto mis datos rápido antes de que se acabe.',
        'No toco nada y borro el mensaje porque nadie pide claves para dar premios.',
        'Se lo reenvío a toda mi familia para que también participen.',
      ],
      correcta: 1,
      explicacionAcierto:
          '¡Eso es! Cuando te pidan claves o tocar enlaces raros por un supuesto premio, seguro es una trampa.',
      explicacionFallo:
          '¡Cuidado! Ahí caíste en la trampa. Ningún premio real te pide tus claves. Lo mejor es borrar el mensaje.',
    ),
    _PreguntaCaso(
      situacion:
          'Te llaman muy apurados diciendo que son de tu banco y que les dictes los 6 numeritos que acabaron de llegar a tu celular. ¿Qué haces?',
      opciones: [
        'Se los dicto para que no me bloqueen la tarjeta.',
        'Les mando una foto por WhatsApp.',
        'Cuelgo de inmediato. Esos numeritos no se le dan a nadie.',
      ],
      correcta: 2,
      explicacionAcierto:
          '¡Muy bien hecho! Esos 6 numeritos son la llave de tu plata. Tu banco jamás te los pide por teléfono.',
      explicacionFallo:
          '¡Ojo con eso! Si entregas esos 6 numeritos, les abres la puerta de tu cuenta. Siempre debes colgar.',
    ),
    _PreguntaCaso(
      situacion:
          'Te escribe un número desconocido por WhatsApp diciendo: "Hola familia, cambié de celular, necesito que me presten plata urgente". ¿Qué haces?',
      opciones: [
        'Llamo a mi familiar a su número de siempre para escuchar su voz y confirmar.',
        'Envío la plata corriendo porque puede ser una emergencia.',
        'Le pregunto por el mismo chat cómo se llama.',
      ],
      correcta: 0,
      explicacionAcierto:
          '¡Excelente decisión! Una llamada al número de toda la vida desenmascara al instante a cualquier imitador.',
      explicacionFallo:
          '¡Peligro! Los estafadores fingen emergencias por chat. Antes de mandar un peso, llama siempre al número antiguo de tu familiar.',
    ),
    _PreguntaCaso(
      situacion:
          'Recibes un mensaje de texto diciendo que tienes un paquete retenido o una multa y que debes pagar hoy mismo en un enlace. ¿Qué haces?',
      opciones: [
        'Conservo la calma, no toco el enlace y le pregunto a alguien de confianza en casa.',
        'Entro al enlace y pongo los datos de mi tarjeta.',
        'Llamo al número extraño que mandó el mensaje.',
      ],
      correcta: 0,
      explicacionAcierto:
          '¡Perfecto! El afán es el arma de los tramposos. Tomarte unos minutos y consultar en casa te mantiene a salvo.',
      explicacionFallo:
          'Recuerda que los tramposos meten miedo y urgencia para que no pienses. Nunca toques enlaces de multas o paquetes sorpresivos.',
    ),
  ];

  Future<void> _leerPreguntaActual() async {
    final p = _preguntas[_preguntaActual];
    await _tts.stop();
    await _tts.speak(
      'Caso ${_preguntaActual + 1}. ${p.situacion} '
      'Opción A: ${p.opciones[0]} '
      'Opción B: ${p.opciones[1]} '
      'Opción C: ${p.opciones[2]}',
    );
  }

  void _seleccionarRespuesta(int indice) {
    if (_respuestaSeleccionada != null) return;

    final p = _preguntas[_preguntaActual];
    final esCorrecta = indice == p.correcta;

    setState(() {
      _respuestaSeleccionada = indice;
      if (esCorrecta) _puntaje++;
    });

    _tts.stop();
    _tts.speak(esCorrecta ? p.explicacionAcierto : p.explicacionFallo);
  }

  void _siguientePregunta() {
    if (_preguntaActual < _preguntas.length - 1) {
      setState(() {
        _preguntaActual++;
        _respuestaSeleccionada = null;
      });
      _leerPreguntaActual();
    } else {
      setState(() => _finalizado = true);
      _tts.stop();
      _tts.speak(
        '¡Felicitaciones! Terminaste la práctica con $_puntaje de ${_preguntas.length} aciertos. '
        'Cada día estás más listo para usar tu celular con total tranquilidad.',
      );
    }
  }

  void _reiniciar() {
    setState(() {
      _preguntaActual = 0;
      _puntaje = 0;
      _respuestaSeleccionada = null;
      _finalizado = false;
    });
    _leerPreguntaActual();
  }

  @override
  void dispose() {
    _tts.stop();
    _tts.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondoCrema,
      appBar: AppBar(
        backgroundColor: fondoCrema,
        foregroundColor: textoCarbon,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text('¿Qué harías tú?', style: Letras.titulo(size: 26)),
        actions: [
          // Estrellas ganadas
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Row(
              children: [
                for (var i = 0; i < _preguntas.length; i++)
                  AnimatedScale(
                    scale: i < _puntaje ? 1.15 : 0.9,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.elasticOut,
                    child: Icon(
                      Icons.star_rounded,
                      size: 30,
                      color: i < _puntaje ? Paleta.mostaza : Paleta.arena,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 450),
        child: _finalizado
            ? KeyedSubtree(key: const ValueKey('fin'), child: _pantallaResultado())
            : KeyedSubtree(key: ValueKey('p$_preguntaActual'), child: _pantallaPregunta()),
      ),
    );
  }

  Widget _pantallaPregunta() {
    final p = _preguntas[_preguntaActual];
    const letras = ['A', 'B', 'C'];
    final respondio = _respuestaSeleccionada != null;
    final acerto = _respuestaSeleccionada == p.correcta;
    final base = _escenasJuego[_preguntaActual % _escenasJuego.length];

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(18, 4, 18, 32),
          children: [
            // Escena del caso (el personaje reacciona a tu respuesta)
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Paleta.ciruela, width: 3),
                boxShadow: const [BoxShadow(color: Paleta.ciruela, offset: Offset(5, 5))],
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 190,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: EscenaAnimada(
                        key: ValueKey('$_preguntaActual-$respondio'),
                        escena: respondio ? _reaccion(base, acerto) : base,
                        habla: true,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    color: Paleta.mostaza,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Text(
                      'CASO ${_preguntaActual + 1} DE ${_preguntas.length}',
                      style: Letras.titulo(size: 17, letterSpacing: 1),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
                    child: Text(
                      p.situacion,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: textoCarbon,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(child: Text('Toca tu respuesta:', style: Letras.titulo(size: 22))),
                TextButton.icon(
                  onPressed: _leerPreguntaActual,
                  icon: const Icon(Icons.volume_up_rounded, color: verdeSalvia, size: 28),
                  label: const Text(
                    'Escuchar',
                    style: TextStyle(color: verdeSalvia, fontWeight: FontWeight.w900, fontSize: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...List.generate(p.opciones.length, (indice) {
              final seleccionada = _respuestaSeleccionada == indice;
              final esLaCorrecta = indice == p.correcta;

              Color fondo = Colors.white;
              Color borde = Paleta.ciruela;
              Color colorCirculo = Paleta.vivos[indice % 4];
              Widget circulo = Text(letras[indice], style: Letras.titulo(size: 24, color: Colors.white));

              if (respondio && esLaCorrecta) {
                fondo = verdeSuave;
                borde = verdeSalvia;
                colorCirculo = verdeSalvia;
                circulo = const Icon(Icons.check_rounded, color: Colors.white, size: 30);
              } else if (seleccionada && !esLaCorrecta) {
                fondo = terracotaSuave;
                borde = terracota;
                colorCirculo = terracota;
                circulo = const Icon(Icons.close_rounded, color: Colors.white, size: 30);
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: AnimatedScale(
                  scale: seleccionada ? 1.03 : 1,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutBack,
                  child: Material(
                    color: fondo,
                    borderRadius: BorderRadius.circular(22),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(22),
                      onTap: respondio ? null : () => _seleccionarRespuesta(indice),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: borde, width: 3),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: colorCirculo,
                                shape: BoxShape.circle,
                                border: Border.all(color: Paleta.ciruela, width: 2),
                              ),
                              child: circulo,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                p.opciones[indice],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: textoCarbon,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
            if (respondio) ...[
              const SizedBox(height: 4),
              _BurbujaGuia(
                texto: acerto ? p.explicacionAcierto : p.explicacionFallo,
                acerto: acerto,
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 64,
                child: FilledButton.icon(
                  onPressed: _siguientePregunta,
                  icon: const Icon(Icons.arrow_forward_rounded, size: 28),
                  label: Text(
                    _preguntaActual == _preguntas.length - 1 ? 'Ver cómo me fue' : 'Siguiente caso',
                    style: Letras.titulo(size: 22, color: Colors.white),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: Paleta.papaya,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
            ],
          ],
        ),
        if (respondio && acerto) const Positioned.fill(child: IgnorePointer(child: _Confeti())),
      ],
    );
  }

  Widget _pantallaResultado() {
    final todos = _puntaje == _preguntas.length;
    return Stack(
      children: [
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: ValueListenableBuilder<Personaje>(
              valueListenable: Asistente.actual,
              builder: (context, guia, _) => Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Paleta.ciruela, width: 3),
                  boxShadow: const [BoxShadow(color: Paleta.ciruela, offset: Offset(6, 6))],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 200,
                      child: EscenaAnimada(
                        escena: Escena(
                          imagen: 'juego_final.png',
                          lugar: Lugar.sala,
                          personaje: guia,
                          objeto: Icons.workspace_premium_rounded,
                          globo: todos ? '¡Wow!' : '¡Bien!',
                          saludando: true,
                        ),
                        habla: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (var i = 0; i < _preguntas.length; i++)
                                Icon(
                                  Icons.star_rounded,
                                  size: 46,
                                  color: i < _puntaje ? Paleta.mostaza : Paleta.arena,
                                ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            todos ? '¡Perfecto!' : '¡Muy bien hecho!',
                            textAlign: TextAlign.center,
                            style: Letras.titulo(size: 34),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Acertaste $_puntaje de ${_preguntas.length} casos',
                            textAlign: TextAlign.center,
                            style: Letras.titulo(size: 22, color: Paleta.aqua),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Ya sabes cómo actuar con calma cuando llegue un mensaje o llamada sospechosa a tu celular.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20, height: 1.45, color: textoCarbon),
                          ),
                          const SizedBox(height: 22),
                          SizedBox(
                            width: double.infinity,
                            height: 64,
                            child: FilledButton.icon(
                              onPressed: _reiniciar,
                              icon: const Icon(Icons.replay_rounded, size: 28),
                              label: Text('Volver a jugar', style: Letras.titulo(size: 22, color: Colors.white)),
                              style: FilledButton.styleFrom(
                                backgroundColor: Paleta.papaya,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const Positioned.fill(child: IgnorePointer(child: _Confeti())),
      ],
    );
  }
}

class _BurbujaGuia extends StatelessWidget {
  const _BurbujaGuia({required this.texto, required this.acerto});

  final String texto;
  final bool acerto;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Personaje>(
      valueListenable: Asistente.actual,
      builder: (context, guia, _) => Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(color: guia.fondo, shape: BoxShape.circle),
            child: AvatarParlante(
              personaje: guia,
              tamano: 86,
              expresion: acerto ? Expresion.feliz : Expresion.preocupada,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: acerto ? verdeSuave : terracotaSuave,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: acerto ? verdeSalvia : terracota, width: 2),
              ),
              child: Text(
                texto,
                style: const TextStyle(fontSize: 19, height: 1.45, fontWeight: FontWeight.w800, color: textoCarbon),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Lluvia de papelitos de colores para celebrar.
class _Confeti extends StatefulWidget {
  const _Confeti();

  @override
  State<_Confeti> createState() => _ConfetiState();
}

class _ConfetiState extends State<_Confeti> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  )..forward();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CustomPaint(painter: _ConfetiPainter(_c));
}

class _ConfetiPainter extends CustomPainter {
  _ConfetiPainter(this.anim) : super(repaint: anim);

  final Animation<double> anim;

  @override
  void paint(Canvas canvas, Size size) {
    final t = anim.value;
    if (t >= 1) return;
    final azar = math.Random(7);
    const colores = [Paleta.papaya, Paleta.mostaza, Paleta.rubor, Paleta.aqua, Paleta.ciruela];
    for (var i = 0; i < 70; i++) {
      final x0 = azar.nextDouble() * size.width;
      final velocidad = 0.6 + azar.nextDouble() * 0.8;
      final y = -20 + t * velocidad * (size.height + 60);
      final x = x0 + math.sin(t * 8 + i) * 14;
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(t * 10 + i);
      canvas.drawRect(
        const Rect.fromLTWH(-5, -3, 10, 6),
        Paint()..color = colores[i % colores.length].withValues(alpha: 1 - t * 0.6),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfetiPainter old) => false;
}

class _PreguntaCaso {
  const _PreguntaCaso({
    required this.situacion,
    required this.opciones,
    required this.correcta,
    required this.explicacionAcierto,
    required this.explicacionFallo,
  });

  final String situacion;
  final List<String> opciones;
  final int correcta;
  final String explicacionAcierto;
  final String explicacionFallo;
}

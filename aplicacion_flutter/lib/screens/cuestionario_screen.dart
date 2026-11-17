import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

const Color fondoCrema = Color(0xFFFAF8F5);
const Color textoCarbon = Color(0xFF2C3539);
const Color verdeSalvia = Color(0xFF2A6F4E);
const Color verdeSuave = Color(0xFFE9F5EE);
const Color terracota = Color(0xFFD96B43);
const Color terracotaSuave = Color(0xFFFDF0EA);
const Color amarilloCalido = Color(0xFFFFF6E5);

class CuestionarioScreen extends StatefulWidget {
  const CuestionarioScreen({super.key});

  @override
  State<CuestionarioScreen> createState() => _CuestionarioScreenState();
}

class _CuestionarioScreenState extends State<CuestionarioScreen> {
  final FlutterTts _tts = FlutterTts();

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

  @override
  void initState() {
    super.initState();
    _configurarVoz();
  }

  Future<void> _configurarVoz() async {
    await _tts.setLanguage('es-CO');
    await _tts.setSpeechRate(0.42);
    await _tts.setPitch(0.98);
  }

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
      if (esCorrecta) {
        _puntaje++;
      }
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
      setState(() {
        _finalizado = true;
      });
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
        title: const Text(
          '¿Qué harías tú?',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
        ),
        actions: [
          if (!_finalizado)
            TextButton.icon(
              onPressed: _leerPreguntaActual,
              icon: const Icon(Icons.volume_up_rounded, color: verdeSalvia, size: 28),
              label: const Text(
                'Escuchar caso',
                style: TextStyle(
                  color: verdeSalvia,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: _finalizado ? _pantallaResultado() : _pantallaPregunta(),
    );
  }

  Widget _pantallaPregunta() {
    final p = _preguntas[_preguntaActual];
    final letras = ['A', 'B', 'C'];

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: [
        Row(
          children: List.generate(_preguntas.length, (i) {
            final activo = i <= _preguntaActual;
            return Expanded(
              child: Container(
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: activo ? verdeSalvia : const Color(0xFFDAD4C8),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: amarilloCalido,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: const Color(0xFFE5CFA3), width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.record_voice_over_rounded, color: terracota, size: 26),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'CASO ${_preguntaActual + 1} DE ${_preguntas.length}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: terracota,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                p.situacion,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: textoCarbon,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Toca la respuesta que creas correcta:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textoCarbon,
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(p.opciones.length, (indice) {
          final seleccionada = _respuestaSeleccionada == indice;
          final mostrarResultado = _respuestaSeleccionada != null;
          final esLaCorrecta = indice == p.correcta;

          Color colorFondo = Colors.white;
          Color colorBorde = const Color(0xFFE0DAD0);
          Color colorCirculo = terracotaSuave;
          Color colorLetra = terracota;

          if (mostrarResultado && esLaCorrecta) {
            colorFondo = verdeSuave;
            colorBorde = verdeSalvia;
            colorCirculo = verdeSalvia;
            colorLetra = Colors.white;
          } else if (seleccionada && !esLaCorrecta) {
            colorFondo = terracotaSuave;
            colorBorde = terracota;
            colorCirculo = terracota;
            colorLetra = Colors.white;
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Material(
              color: colorFondo,
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: _respuestaSeleccionada == null
                    ? () => _seleccionarRespuesta(indice)
                    : null,
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: colorBorde, width: 2),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: colorCirculo,
                        child: mostrarResultado && esLaCorrecta
                            ? const Icon(Icons.check_rounded, color: Colors.white, size: 26)
                            : Text(
                                letras[indice],
                                style: TextStyle(
                                  color: colorLetra,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          p.opciones[indice],
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
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
          );
        }),
        if (_respuestaSeleccionada != null) ...[
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _respuestaSeleccionada == p.correcta ? verdeSuave : terracotaSuave,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: _respuestaSeleccionada == p.correcta ? verdeSalvia : terracota,
                width: 2,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  _respuestaSeleccionada == p.correcta
                      ? Icons.verified_rounded
                      : Icons.info_rounded,
                  color: _respuestaSeleccionada == p.correcta ? verdeSalvia : terracota,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _respuestaSeleccionada == p.correcta
                        ? p.explicacionAcierto
                        : p.explicacionFallo,
                    style: const TextStyle(
                      fontSize: 19,
                      height: 1.45,
                      fontWeight: FontWeight.w700,
                      color: textoCarbon,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 60,
            child: FilledButton.icon(
              onPressed: _siguientePregunta,
              icon: const Icon(Icons.arrow_forward_rounded, size: 28),
              label: Text(
                _preguntaActual == _preguntas.length - 1
                    ? 'Ver cómo me fue'
                    : 'Siguiente caso',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: verdeSalvia,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _pantallaResultado() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(26),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFFE0DAD0), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                  color: verdeSuave,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  color: verdeSalvia,
                  size: 58,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '¡Muy bien hecho!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: textoCarbon,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Acertaste $_puntaje de ${_preguntas.length} casos',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  color: verdeSalvia,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Ya sabes cómo actuar con calma cuando llegue un mensaje o llamada sospechosa a tu celular.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19,
                  height: 1.45,
                  color: textoCarbon,
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: FilledButton.icon(
                  onPressed: _reiniciar,
                  icon: const Icon(Icons.replay_rounded, size: 28),
                  label: const Text(
                    'Volver a practicar',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: verdeSalvia,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
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
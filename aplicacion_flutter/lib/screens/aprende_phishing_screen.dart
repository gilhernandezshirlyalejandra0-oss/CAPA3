import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

const Color fondoCrema = Color(0xFFFAF8F5);
const Color textoCarbon = Color(0xFF2C3539);
const Color verdeSalvia = Color(0xFF2A6F4E);
const Color verdeSuave = Color(0xFFE9F5EE);
const Color terracota = Color(0xFFD96B43);
const Color terracotaSuave = Color(0xFFFDF0EA);
const Color amarilloCalido = Color(0xFFFFF6E5);

class AprendePhishingScreen extends StatefulWidget {
  const AprendePhishingScreen({super.key});

  @override
  State<AprendePhishingScreen> createState() => _AprendePhishingScreenState();
}

class _AprendePhishingScreenState extends State<AprendePhishingScreen> {
  final FlutterTts _tts = FlutterTts();
  final PageController _pageController = PageController();
  int _historiaActual = 0;
  bool _hablando = false;

  final List<_HistoriaCotidiana> _historias = const [
    _HistoriaCotidiana(
      etiqueta: 'HISTORIA 1 DE 4',
      titulo: 'El falso premio o subsidio',
      icono: Icons.card_giftcard_rounded,
      colorFondo: amarilloCalido,
      colorAcento: Color(0xFFB7791F),
      relato:
          'Te llega un mensaje diciendo que ganaste un mercado, un bono del gobierno o un premio sorpresa, pero te piden tocar un enlace azul para reclamarlo.',
      secreto:
          'Nadie regala premios por mensaje pidiendo tus claves. Si no te inscribiste en ningún sorteo, bórralo de inmediato.',
    ),
    _HistoriaCotidiana(
      etiqueta: 'HISTORIA 2 DE 4',
      titulo: 'El susto de la cuenta bloqueada',
      icono: Icons.account_balance_rounded,
      colorFondo: terracotaSuave,
      colorAcento: terracota,
      relato:
          'Te llaman o escriben con mucha urgencia diciendo que alguien está robando tu cuenta del banco o tu pensión y que debes dictarles un código que llegó a tu celular.',
      secreto:
          'Los tramposos usan el miedo para que no pienses. Tu banco jamás te pedirá claves ni códigos por teléfono. Cuelga sin miedo.',
    ),
    _HistoriaCotidiana(
      etiqueta: 'HISTORIA 3 DE 4',
      titulo: 'El familiar en apuros por WhatsApp',
      icono: Icons.chat_bubble_outline_rounded,
      colorFondo: verdeSuave,
      colorAcento: verdeSalvia,
      relato:
          'Te escribe alguien con la foto de un hijo o sobrino diciendo: "Cambié de número, tengo una emergencia y necesito que me prestes plata ya mismo".',
      secreto:
          'Antes de enviar un solo peso, llama a tu familiar a su número de toda la vida para escuchar su voz y confirmar si es verdad.',
    ),
    _HistoriaCotidiana(
      etiqueta: 'HISTORIA 4 DE 4',
      titulo: 'La regla de los 5 minutos',
      icono: Icons.verified_user_rounded,
      colorFondo: Color(0xFFEBF3FA),
      colorAcento: Color(0xFF2C4A6F),
      relato:
          'Siempre que un mensaje te pida hacer algo "ya mismo", respira profundo, deja el celular en la mesa y pregúntale a alguien de tu casa.',
      secreto:
          'Tomarte cinco minutos para preguntar te salva de cualquier trampa. Tu tranquilidad vale más que cualquier mensaje urgente.',
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

    _tts.setStartHandler(() {
      if (mounted) setState(() => _hablando = true);
    });
    _tts.setCompletionHandler(() {
      if (mounted) setState(() => _hablando = false);
    });
    _tts.setCancelHandler(() {
      if (mounted) setState(() => _hablando = false);
    });

    _narrarHistoria(0);
  }

  Future<void> _narrarHistoria(int index) async {
    final h = _historias[index];
    await _tts.stop();
    await _tts.speak(
      '${h.etiqueta}. ${h.titulo}. ${h.relato} Consejo clave: ${h.secreto}',
    );
  }

  Future<void> _detenerVoz() async {
    await _tts.stop();
    if (mounted) setState(() => _hablando = false);
  }

  void _cambiarPagina(int nuevaPagina) {
    _pageController.animateToPage(
      nuevaPagina,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _tts.stop();
    _pageController.dispose();
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
          'Así funcionan las trampas',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
        ),
        actions: [
          IconButton(
            tooltip: _hablando ? 'Detener voz' : 'Escuchar esta pantalla',
            icon: Icon(
              _hablando ? Icons.stop_circle_rounded : Icons.volume_up_rounded,
              color: _hablando ? terracota : verdeSalvia,
              size: 32,
            ),
            onPressed: () {
              if (_hablando) {
                _detenerVoz();
              } else {
                _narrarHistoria(_historiaActual);
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
            child: Row(
              children: List.generate(_historias.length, (i) {
                final activo = i <= _historiaActual;
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
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _historias.length,
              onPageChanged: (index) {
                setState(() => _historiaActual = index);
                _narrarHistoria(index);
              },
              itemBuilder: (context, index) {
                final h = _historias[index];
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: h.colorFondo,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: h.colorAcento.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.white,
                              child: Icon(h.icono, color: h.colorAcento, size: 32),
                            ),
                            const SizedBox(width: 14),
                            Text(
                              h.etiqueta,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: h.colorAcento,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(
                          h.titulo,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: textoCarbon,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          h.relato,
                          style: const TextStyle(
                            fontSize: 21,
                            height: 1.5,
                            color: textoCarbon,
                          ),
                        ),
                        const SizedBox(height: 22),
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.lightbulb_rounded, color: h.colorAcento, size: 30),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  h.secreto,
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
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => _narrarHistoria(index),
                            icon: const Icon(Icons.volume_up_rounded, size: 26),
                            label: const Text(
                              'Volver a escuchar esta historia',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: h.colorAcento,
                              side: BorderSide(color: h.colorAcento, width: 2),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
            child: Row(
              children: [
                if (_historiaActual > 0)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _cambiarPagina(_historiaActual - 1),
                      icon: const Icon(Icons.arrow_back_rounded),
                      label: const Text(
                        'Anterior',
                        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: textoCarbon,
                        side: const BorderSide(color: textoCarbon, width: 2),
                        minimumSize: const Size.fromHeight(56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                if (_historiaActual > 0) const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    onPressed: () {
                      if (_historiaActual < _historias.length - 1) {
                        _cambiarPagina(_historiaActual + 1);
                      } else {
                        _cambiarPagina(0);
                      }
                    },
                    icon: Icon(
                      _historiaActual < _historias.length - 1
                          ? Icons.arrow_forward_rounded
                          : Icons.replay_rounded,
                    ),
                    label: Text(
                      _historiaActual < _historias.length - 1
                          ? 'Siguiente historia'
                          : 'Repasar desde la 1',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: verdeSalvia,
                      minimumSize: const Size.fromHeight(56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoriaCotidiana {
  const _HistoriaCotidiana({
    required this.etiqueta,
    required this.titulo,
    required this.icono,
    required this.colorFondo,
    required this.colorAcento,
    required this.relato,
    required this.secreto,
  });

  final String etiqueta;
  final String titulo;
  final IconData icono;
  final Color colorFondo;
  final Color colorAcento;
  final String relato;
  final String secreto;
}
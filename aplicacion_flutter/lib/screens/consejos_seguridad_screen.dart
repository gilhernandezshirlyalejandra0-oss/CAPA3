import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

const Color fondoCrema = Color(0xFFFAF8F5);
const Color textoCarbon = Color(0xFF2C3539);
const Color verdeSalvia = Color(0xFF2A6F4E);
const Color verdeSuave = Color(0xFFE9F5EE);
const Color terracota = Color(0xFFD96B43);
const Color terracotaSuave = Color(0xFFFDF0EA);
const Color amarilloCalido = Color(0xFFFFF6E5);

class ConsejosSeguridadScreen extends StatefulWidget {
  const ConsejosSeguridadScreen({super.key});

  @override
  State<ConsejosSeguridadScreen> createState() =>
      _ConsejosSeguridadScreenState();
}

class _ConsejosSeguridadScreenState extends State<ConsejosSeguridadScreen> {
  final FlutterTts _tts = FlutterTts();
  int? _consejoActivo;

  static const List<_ReglaDeOro> _reglas = [
    _ReglaDeOro(
      numero: '1',
      icono: Icons.dialpad_rounded,
      titulo: 'Los 6 numeritos son sagrados',
      descripcion:
          'Si te llega un mensaje con un código de números al celular, no se lo dictes a nadie, ni siquiera si dicen llamarte del banco o de WhatsApp.',
      ejemplo:
          'Ese código es como la llave de tu casa: quien lo tiene puede entrar a tu cuenta.',
    ),
    _ReglaDeOro(
      numero: '2',
      icono: Icons.phone_callback_rounded,
      titulo: 'Ante la duda, cuelga tú primero',
      descripcion:
          'Si alguien te llama apurado diciendo que hay un problema con tu pensión, tu EPS o tu tarjeta, cuelga sin pena.',
      ejemplo:
          'Los bancos de verdad nunca se enojan porque cuelgues para verificar con un familiar.',
    ),
    _ReglaDeOro(
      numero: '3',
      icono: Icons.touch_app_rounded,
      titulo: 'No toques letras azules de desconocidos',
      descripcion:
          'Las letras azules o subrayadas en los mensajes te llevan a páginas falsas hechas para robar tus datos.',
      ejemplo:
          'Si dicen que tienes un paquete retenido o una multa, no toques el enlace.',
    ),
    _ReglaDeOro(
      numero: '4',
      icono: Icons.family_restroom_rounded,
      titulo: 'Confirma por voz con tu familia',
      descripcion:
          'Si un supuesto hijo, nieto o amigo te pide plata prestada por mensaje diciendo que cambió de número, llámalo primero.',
      ejemplo:
          'Escuchar su voz por llamada normal desenmascara al instante a los imitadores.',
    ),
    _ReglaDeOro(
      numero: '5',
      icono: Icons.menu_book_rounded,
      titulo: 'Anota tus claves en una libreta en casa',
      descripcion:
          'Es mucho más seguro tener tus claves escritas en un cuaderno guardado en tu mesa de noche que mandarlas por chat.',
      ejemplo:
          'No uses tu año de nacimiento ni números seguidos como 1234.',
    ),
    _ReglaDeOro(
      numero: '6',
      icono: Icons.coffee_rounded,
      titulo: 'Nada en el celular es tan urgente',
      descripcion:
          'El truco favorito de los estafadores es meterte afán. Si algo parece urgente, tómate un café y pregunta primero.',
      ejemplo:
          'Consultar con alguien de confianza en casa evita el 99% de los engaños.',
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

    _tts.setCompletionHandler(() {
      if (mounted) setState(() => _consejoActivo = null);
    });
    _tts.setCancelHandler(() {
      if (mounted) setState(() => _consejoActivo = null);
    });
  }

  Future<void> _escucharRegla(int index) async {
    if (_consejoActivo == index) {
      await _tts.stop();
      setState(() => _consejoActivo = null);
      return;
    }

    final r = _reglas[index];
    setState(() => _consejoActivo = index);
    await _tts.stop();
    await _tts.speak(
      'Regla número ${r.numero}: ${r.titulo}. ${r.descripcion} Recuerda: ${r.ejemplo}',
    );
  }

  Future<void> _escucharResumenCompleto() async {
    setState(() => _consejoActivo = -1);
    await _tts.stop();
    final textoCompleto = _reglas
        .map((r) => 'Regla ${r.numero}: ${r.titulo}. ${r.descripcion}')
        .join(' ');
    await _tts.speak('Estas son tus seis reglas de oro. $textoCompleto');
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
          'Tus 6 Reglas de Oro',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
        ),
        actions: [
          TextButton.icon(
            onPressed: _escucharResumenCompleto,
            icon: Icon(
              _consejoActivo == -1
                  ? Icons.stop_circle_rounded
                  : Icons.volume_up_rounded,
              color: verdeSalvia,
              size: 28,
            ),
            label: const Text(
              'Escuchar todas',
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
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: amarilloCalido,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE5CFA3), width: 1.5),
            ),
            child: const Row(
              children: [
                Icon(Icons.touch_app_rounded, color: terracota, size: 38),
                SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'Toca cualquier tarjeta para que Don Prudencio te la lea en voz alta.',
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.35,
                      fontWeight: FontWeight.w700,
                      color: textoCarbon,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          for (int i = 0; i < _reglas.length; i++)
            _TarjetaRegla(
              regla: _reglas[i],
              activa: _consejoActivo == i,
              onTap: () => _escucharRegla(i),
            ),
        ],
      ),
    );
  }
}

class _TarjetaRegla extends StatelessWidget {
  const _TarjetaRegla({
    required this.regla,
    required this.activa,
    required this.onTap,
  });

  final _ReglaDeOro regla;
  final bool activa;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: activa ? verdeSuave : Colors.white,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: activa ? verdeSalvia : const Color(0xFFE4DFD7),
                width: activa ? 2.5 : 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: activa ? verdeSalvia : terracotaSuave,
                      child: Icon(
                        regla.icono,
                        color: activa ? Colors.white : terracota,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'REGLA ${regla.numero}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: verdeSalvia,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            regla.titulo,
                            style: const TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w900,
                              color: textoCarbon,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      activa
                          ? Icons.stop_circle_rounded
                          : Icons.volume_up_rounded,
                      color: activa ? terracota : verdeSalvia,
                      size: 32,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  regla.descripcion,
                  style: const TextStyle(
                    fontSize: 19,
                    height: 1.45,
                    color: textoCarbon,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: activa ? Colors.white : const Color(0xFFF7F4EE),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.verified_rounded,
                        color: verdeSalvia,
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          regla.ejemplo,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: textoCarbon,
                            height: 1.35,
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
    );
  }
}

class _ReglaDeOro {
  const _ReglaDeOro({
    required this.numero,
    required this.icono,
    required this.titulo,
    required this.descripcion,
    required this.ejemplo,
  });

  final String numero;
  final IconData icono;
  final String titulo;
  final String descripcion;
  final String ejemplo;
}
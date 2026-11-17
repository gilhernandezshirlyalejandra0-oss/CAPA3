import 'package:flutter/material.dart';
import '../services/voz_humana.dart';
import '../theme/paleta.dart';
import '../services/asistente.dart';
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

class ConsejosSeguridadScreen extends StatefulWidget {
  const ConsejosSeguridadScreen({super.key});

  @override
  State<ConsejosSeguridadScreen> createState() =>
      _ConsejosSeguridadScreenState();
}

class _ConsejosSeguridadScreenState extends State<ConsejosSeguridadScreen> {
  final AdaptadorVoz _tts = VozHumana.adaptador();
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
        title: Text('Tus 6 reglas de oro', style: Letras.titulo(size: 26)),
        actions: [
          IconButton(
            tooltip: 'Escuchar todas',
            onPressed: _escucharResumenCompleto,
            icon: Icon(
              _consejoActivo == -1 ? Icons.stop_circle_rounded : Icons.volume_up_rounded,
              color: verdeSalvia,
              size: 32,
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 32),
        children: [
          ValueListenableBuilder<Personaje>(
            valueListenable: Asistente.actual,
            builder: (context, guia, _) => Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(color: guia.fondo, shape: BoxShape.circle),
                  child: AvatarParlante(personaje: guia, tamano: 90, saludando: true),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: amarilloCalido,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Paleta.mostaza, width: 2),
                    ),
                    child: Text(
                      'Toca cualquier tarjeta y ${guia.nombre} te la lee en voz alta.',
                      style: const TextStyle(fontSize: 19, height: 1.35, fontWeight: FontWeight.w800, color: textoCarbon),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          for (int i = 0; i < _reglas.length; i++)
            _TarjetaRegla(
              regla: _reglas[i],
              escena: _escenasReglas[i % _escenasReglas.length],
              color: Paleta.vivos[i % 4],
              activa: _consejoActivo == i,
              onTap: () => _escucharRegla(i),
            ),
        ],
      ),
    );
  }
}

/// Una escena dibujada para cada regla.
const List<Escena> _escenasReglas = [
  Escena(imagen: 'regla_1.png', lugar: Lugar.casa, personaje: Asistente.valentina,
      expresion: Expresion.sorprendida, objeto: Icons.dialpad_rounded, globo: '¡No!'),
  Escena(imagen: 'regla_2.png', lugar: Lugar.sala, personaje: Asistente.hernando,
      objeto: Icons.call_end_rounded, globo: '¡Chao!'),
  Escena(imagen: 'regla_3.png', lugar: Lugar.casa, personaje: Asistente.andres,
      expresion: Expresion.preocupada, objeto: Icons.link_off_rounded, globo: '!'),
  Escena(imagen: 'regla_4.png', lugar: Lugar.sala, personaje: Asistente.carmen,
      acompanante: Asistente.andres, objeto: Icons.phone_rounded),
  Escena(imagen: 'regla_5.png', lugar: Lugar.casa, personaje: Asistente.gloria,
      objeto: Icons.menu_book_rounded, globo: '1234 no'),
  Escena(imagen: 'regla_6.png', lugar: Lugar.casa, personaje: Asistente.ruben,
      objeto: Icons.coffee_rounded, globo: 'Calma'),
];

class _TarjetaRegla extends StatelessWidget {
  const _TarjetaRegla({
    required this.regla,
    required this.escena,
    required this.color,
    required this.activa,
    required this.onTap,
  });

  final _ReglaDeOro regla;
  final Escena escena;
  final Color color;
  final bool activa;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textoSobreColor = color == Paleta.mostaza ? Paleta.tinta : Colors.white;
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: Paleta.ciruela, width: 3),
            boxShadow: [
              BoxShadow(color: activa ? color : Paleta.ciruela, offset: const Offset(6, 6)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 180,
                    width: double.infinity,
                    child: EscenaAnimada(escena: escena, habla: activa),
                  ),
                  // Número grande de la regla
                  Positioned(
                    left: 12,
                    top: 12,
                    child: Container(
                      width: 56,
                      height: 56,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(color: Paleta.ciruela, width: 3),
                      ),
                      child: Text(regla.numero, style: Letras.titulo(size: 30, color: textoSobreColor)),
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                color: color,
                padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
                child: Row(
                  children: [
                    Icon(regla.icono, color: textoSobreColor, size: 30),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        regla.titulo,
                        style: Letras.titulo(size: 22, color: textoSobreColor, height: 1.15),
                      ),
                    ),
                    Icon(
                      activa ? Icons.stop_circle_rounded : Icons.volume_up_rounded,
                      color: textoSobreColor,
                      size: 34,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      regla.descripcion,
                      style: const TextStyle(fontSize: 21, height: 1.45, color: textoCarbon),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.lightbulb_rounded, color: Paleta.papaya, size: 28),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              regla.ejemplo,
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
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
            ],
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

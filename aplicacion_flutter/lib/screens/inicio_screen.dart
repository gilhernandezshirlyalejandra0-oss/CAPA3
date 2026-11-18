import 'dart:async';
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../services/asistente.dart';
import '../theme/paleta.dart';
import '../widgets/animalitos.dart';
import '../widgets/avatar_parlante.dart';

/// Página de Inicio. El fondo de pantalla completo lo pone el contenedor
/// (ver FondoInicio en main.dart); aquí va el contenido encima, en
/// tarjetas de vidrio suave para que se lea bien sobre cualquier imagen.
class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key, required this.onAbrir});

  /// Abre la sección [indice] (0 Historias, 1 Chats, 2 Cuentos, 3 Claves, 4 Juego).
  final ValueChanged<int> onAbrir;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
      children: [
        const _Saludo(),
        const SizedBox(height: 14),
        const CarruselFrases(),
        // Espacio libre para que se luzca el fondo de pantalla.
        const SizedBox(height: 150),
        Vidrio(
          opacidad: 0.86,
          padding: const EdgeInsets.fromLTRB(14, 16, 14, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  '¿Qué quieres hacer hoy?',
                  style: Letras.titulo(size: 23),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(4, 2, 4, 12),
                child: Text(
                  'Toca una tarjeta para entrar. Siempre puedes volver aquí con el botón Inicio.',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.35,
                    color: Paleta.tintaSuave,
                  ),
                ),
              ),
              for (var i = 0; i < _secciones.length; i++)
                _TarjetaSeccion(
                  seccion: _secciones[i],
                  onTap: () => onAbrir(i),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Tarjeta translúcida con desenfoque del fondo (efecto vidrio).
class Vidrio extends StatelessWidget {
  const Vidrio({
    super.key,
    required this.child,
    this.opacidad = 0.82,
    this.radio = 26,
    this.padding = const EdgeInsets.all(14),
    this.color = Colors.white,
  });

  final Widget child;
  final double opacidad;
  final double radio;
  final EdgeInsets padding;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radio),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: color.withValues(alpha: opacidad),
            borderRadius: BorderRadius.circular(radio),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.9),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _Seccion {
  const _Seccion(this.titulo, this.resumen, this.icono, this.color, this.suave);
  final String titulo;
  final String resumen;
  final IconData icono;
  final Color color;
  final Color suave;
}

const List<_Seccion> _secciones = [
  _Seccion(
    'Historias',
    'Así funcionan las trampas',
    Icons.auto_stories_rounded,
    Paleta.papaya,
    Paleta.papayaSuave,
  ),
  _Seccion(
    'Chats',
    'Descubre al estafador disfrazado',
    Icons.mark_chat_unread_rounded,
    Paleta.aqua,
    Paleta.aquaSuave,
  ),
  _Seccion(
    'Cuentos',
    'Anécdotas y chisme informativo',
    Icons.theater_comedy_rounded,
    Paleta.rubor,
    Paleta.ruborSuave,
  ),
  _Seccion(
    'Claves',
    'Tus 6 reglas de oro',
    Icons.key_rounded,
    Paleta.mostaza,
    Paleta.mostazaSuave,
  ),
  _Seccion(
    'Juego',
    'Practica y gana estrellas',
    Icons.extension_rounded,
    Paleta.papaya,
    Paleta.papayaSuave,
  ),
];

class _Saludo extends StatelessWidget {
  const _Saludo();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Personaje>(
      valueListenable: Asistente.actual,
      builder: (context, guia, _) => Vidrio(
        opacidad: 0.84,
        padding: const EdgeInsets.fromLTRB(10, 10, 14, 10),
        child: Row(
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: guia.fondo,
                shape: BoxShape.circle,
              ),
              child: AvatarParlante(
                personaje: guia,
                tamano: 70,
                saludando: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hola, soy ${guia.nombre}',
                    style: Letras.titulo(size: 17, color: Paleta.papaya),
                  ),
                  const Text(
                    'Tómate tu tiempo, aquí no hay afán.',
                    style: TextStyle(
                      fontSize: 17,
                      height: 1.3,
                      fontWeight: FontWeight.w800,
                      color: Paleta.tinta,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Frase {
  const _Frase(this.texto, this.animal, this.regalo, this.tono);
  final String texto;
  final Animalito animal;
  final Regalo regalo;
  final Color tono;
}

const List<_Frase> _frases = [
  _Frase(
    '¡Hola! Vengo a recordarte que sí vas a poder.',
    Animalito.patito,
    Regalo.flor,
    Color(0xFFDDEFF7),
  ),
  _Frase(
    'No tienes que ser fuerte todo el tiempo.',
    Animalito.osito,
    Regalo.corazon,
    Color(0xFFFFF1C7),
  ),
  _Frase(
    'Respira hondo. Nada en el celular es tan urgente.',
    Animalito.conejito,
    Regalo.ninguno,
    Color(0xFFFCE3E7),
  ),
  _Frase(
    'Ora más y preocúpate menos.',
    Animalito.gatito,
    Regalo.flor,
    Color(0xFFE3F2DF),
  ),
  _Frase(
    'Nunca dejes de ser agradecido.',
    Animalito.osito,
    Regalo.flor,
    Color(0xFFFFF1C7),
  ),
];

/// Carrusel de frases motivacionales dichas por animalitos.
class CarruselFrases extends StatefulWidget {
  const CarruselFrases({super.key});

  @override
  State<CarruselFrases> createState() => _CarruselFrasesState();
}

class _CarruselFrasesState extends State<CarruselFrases> {
  final PageController _control = PageController();
  int _pagina = 0;
  Timer? _temporizador;

  @override
  void initState() {
    super.initState();
    _programar();
  }

  void _programar() {
    _temporizador?.cancel();
    _temporizador = Timer.periodic(
      const Duration(seconds: 7),
      (_) => _ir(1, reiniciar: false),
    );
  }

  void _ir(int delta, {bool reiniciar = true}) {
    if (!_control.hasClients) return;
    final destino = (_pagina + delta + _frases.length) % _frases.length;
    _control.animateToPage(
      destino,
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeInOutCubic,
    );
    if (reiniciar) _programar();
  }

  @override
  void dispose() {
    _temporizador?.cancel();
    _control.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 170,
          child: PageView.builder(
            controller: _control,
            itemCount: _frases.length,
            onPageChanged: (i) {
              setState(() => _pagina = i);
              _programar();
            },
            itemBuilder: (context, i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: _TarjetaFrase(frase: _frases[i]),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Vidrio(
          opacidad: 0.8,
          radio: 30,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Flecha(
                icono: Icons.chevron_left_rounded,
                etiqueta: 'Frase anterior',
                onTap: () => _ir(-1),
              ),
              for (var i = 0; i < _frases.length; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: i == _pagina ? 22 : 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: i == _pagina
                        ? Paleta.aqua
                        : Paleta.tintaSuave.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
              _Flecha(
                icono: Icons.chevron_right_rounded,
                etiqueta: 'Frase siguiente',
                onTap: () => _ir(1),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TarjetaFrase extends StatelessWidget {
  const _TarjetaFrase({required this.frase});

  final _Frase frase;

  @override
  Widget build(BuildContext context) {
    return Vidrio(
      opacidad: 0.88,
      color: frase.tono,
      padding: const EdgeInsets.fromLTRB(4, 8, 12, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AnimalitoAnimado(
            tipo: frase.animal,
            regalo: frase.regalo,
            tamano: 128,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: _Globo(texto: frase.texto),
            ),
          ),
        ],
      ),
    );
  }
}

/// Globo de diálogo con la colita hacia el animalito.
class _Globo extends StatelessWidget {
  const _Globo({required this.texto});

  final String texto;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GloboPainter(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 12, 14),
        child: Text(
          texto,
          style: Letras.titulo(
            size: 18,
            height: 1.2,
            color: Paleta.ciruela,
            weight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _GloboPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cuerpo = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(20),
    );
    final cola = Path()
      ..moveTo(4, size.height * 0.55)
      ..lineTo(-10, size.height * 0.72)
      ..lineTo(12, size.height * 0.72)
      ..close();
    final pintura = Paint()..color = Colors.white;
    canvas.drawShadow(
      Path()..addRRect(cuerpo),
      const Color(0x33000000),
      3,
      false,
    );
    canvas.drawPath(cola, pintura);
    canvas.drawRRect(cuerpo, pintura);
  }

  @override
  bool shouldRepaint(_GloboPainter old) => false;
}

class _Flecha extends StatelessWidget {
  const _Flecha({
    required this.icono,
    required this.etiqueta,
    required this.onTap,
  });

  final IconData icono;
  final String etiqueta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: etiqueta,
      onPressed: onTap,
      icon: Icon(icono, size: 30, color: Paleta.ciruela),
    );
  }
}

class _TarjetaSeccion extends StatelessWidget {
  const _TarjetaSeccion({required this.seccion, required this.onTap});

  final _Seccion seccion;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final sobreColor = seccion.color == Paleta.mostaza
        ? Paleta.tinta
        : Colors.white;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: seccion.suave,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 8, 10),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: seccion.color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(seccion.icono, color: sobreColor, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(seccion.titulo, style: Letras.titulo(size: 20)),
                      Text(
                        seccion.resumen,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Paleta.tintaSuave,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Paleta.ciruela,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

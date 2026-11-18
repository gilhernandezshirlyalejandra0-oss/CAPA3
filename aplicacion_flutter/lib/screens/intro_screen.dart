import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/asistente.dart';
import '../services/voz_humana.dart';
import '../theme/paleta.dart';
import '../widgets/avatar_parlante.dart';

/// Entrada: la persona elige con quién quiere aprender. El personaje
/// la saluda con cariño, mueve la boca al hablar y su texto aparece debajo.
class IntroPersonajesScreen extends StatefulWidget {
  const IntroPersonajesScreen({super.key});

  @override
  State<IntroPersonajesScreen> createState() => _IntroPersonajesScreenState();
}

class _IntroPersonajesScreenState extends State<IntroPersonajesScreen> {
  Personaje _elegido = Asistente.actual.value;
  bool _saludando = true;
  int _cambios = 0;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 700), () {
      if (mounted) _presentar(_elegido, automatico: true);
    });
  }

  Future<void> _presentar(Personaje p, {bool automatico = false}) async {
    setState(() {
      _elegido = p;
      _saludando = true;
      _cambios++;
    });
    Asistente.actual.value = p;
    final cambio = _cambios;
    Future<void>.delayed(const Duration(milliseconds: 2600), () {
      if (mounted && cambio == _cambios) setState(() => _saludando = false);
    });
    await VozHumana.usarPersonaje(
      femenina: p.genero == GeneroVoz.femenina,
      tono: p.tono,
      ritmo: p.ritmo,
    );
    if (automatico) {
      await VozHumana.narrar(p.saludo);
    } else {
      await VozHumana.hablar(p.saludo);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = _elegido;
    return Scaffold(
      backgroundColor: Paleta.crema,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, c) {
            final avatar = (c.maxHeight * 0.3).clamp(160.0, 260.0);
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: c.maxHeight - 36),
                child: Column(
                  children: [
                    // Marca, como en la versión original
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: Paleta.aqua,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        'ESCUDO MAYOR',
                        style: Letras.titulo(size: 20, color: Colors.white, letterSpacing: 1.5),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Personaje en el centro
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 450),
                      transitionBuilder: (child, anim) => ScaleTransition(
                        scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
                        child: FadeTransition(opacity: anim, child: child),
                      ),
                      child: Container(
                        key: ValueKey(p.id),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(color: p.fondo, shape: BoxShape.circle),
                        child: AvatarParlante(
                          personaje: p,
                          tamano: avatar,
                          saludando: _saludando,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Burbuja con lo que dice
                    _BurbujaTexto(nombre: p.nombre, texto: p.saludo),
                    const SizedBox(height: 22),

                    Text(
                      '¿Con quién quieres aprender?',
                      textAlign: TextAlign.center,
                      style: Letras.titulo(size: 24),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        for (final op in Asistente.todos)
                          Expanded(
                            child: _OpcionPersonaje(
                              personaje: op,
                              elegido: op.id == p.id,
                              onTap: () => _presentar(op),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 22),

                    SizedBox(
                      width: double.infinity,
                      height: 68,
                      child: FilledButton(
                        onPressed: () {
                          VozHumana.detener();
                          context.go('/');
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: Paleta.papaya,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Empezar con ${p.nombre}',
                          style: Letras.titulo(size: 24, color: Colors.white),
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
    );
  }
}

class _BurbujaTexto extends StatelessWidget {
  const _BurbujaTexto({required this.nombre, required this.texto});

  final String nombre;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Piquito de la burbuja apuntando al personaje
        CustomPaint(size: const Size(28, 14), painter: _Piquito()),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.07),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(nombre, style: Letras.titulo(size: 20, color: Paleta.papaya)),
              const SizedBox(height: 6),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  texto,
                  key: ValueKey(texto),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 21,
                    height: 1.4,
                    fontWeight: FontWeight.w700,
                    color: Paleta.tinta,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Piquito extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _OpcionPersonaje extends StatelessWidget {
  const _OpcionPersonaje({
    required this.personaje,
    required this.elegido,
    required this.onTap,
  });

  final Personaje personaje;
  final bool elegido;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: elegido,
      label: '${personaje.nombre}, ${personaje.descripcion}',
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedScale(
          scale: elegido ? 1.06 : 1,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutBack,
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: elegido ? Paleta.papaya : Colors.transparent,
                    width: 4,
                  ),
                ),
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(color: personaje.fondo, shape: BoxShape.circle),
                  child: AvatarParlante(
                    personaje: personaje,
                    tamano: 70,
                    hablaConLaVoz: false,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                personaje.nombre,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: elegido ? FontWeight.w900 : FontWeight.w700,
                  color: Paleta.tinta,
                ),
              ),
              Text(
                personaje.descripcion,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Paleta.tintaSuave),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

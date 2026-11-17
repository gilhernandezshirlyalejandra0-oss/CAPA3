import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../services/asistente.dart';
import '../theme/paleta.dart';
import 'avatar_parlante.dart';
import 'fondos_dibujados.dart';

/// Una viñeta de una historia: dónde pasa, quién aparece, cómo se siente
/// y qué objeto es importante en ese momento.
///
/// Si existe la imagen `assets/escenas/<imagen>` (por ejemplo una ilustración
/// en acuarela hecha con IA), se muestra esa imagen con movimiento suave.
/// Si no existe, se dibuja la escena con código.
class Escena {
  const Escena({
    required this.imagen,
    required this.lugar,
    required this.personaje,
    this.expresion = Expresion.feliz,
    this.objeto,
    this.globo,
    this.acompanante,
    this.saludando = false,
  });

  final String imagen;
  final Lugar lugar;
  final Personaje personaje;
  final Expresion expresion;
  final IconData? objeto;

  /// Texto cortito en una nube de pensamiento: "?", "!", "💡", "❤".
  final String? globo;
  final Personaje? acompanante;
  final bool saludando;
}

class EscenaAnimada extends StatefulWidget {
  const EscenaAnimada({super.key, required this.escena, this.habla = false});

  final Escena escena;

  /// Si el personaje mueve la boca con la voz.
  final bool habla;

  @override
  State<EscenaAnimada> createState() => _EscenaAnimadaState();
}

class _EscenaAnimadaState extends State<EscenaAnimada> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 14),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Image.asset(
        'assets/escenas/${widget.escena.imagen}',
        fit: BoxFit.cover,
        frameBuilder: (context, child, frame, sincrono) {
          // "Ken Burns": la ilustración se acerca y se desliza despacio.
          return AnimatedBuilder(
            animation: _c,
            builder: (context, _) {
              final v = Curves.easeInOut.transform(_c.value);
              return Transform.scale(
                scale: 1.04 + v * 0.08,
                alignment: Alignment(-0.6 + v * 1.2, -0.2 + v * 0.3),
                child: child,
              );
            },
          );
        },
        errorBuilder: (context, error, stack) =>
            _EscenaDibujada(escena: widget.escena, habla: widget.habla, anim: _c),
      ),
    );
  }
}

class _EscenaDibujada extends StatelessWidget {
  const _EscenaDibujada({required this.escena, required this.habla, required this.anim});

  final Escena escena;
  final bool habla;
  final Animation<double> anim;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final alto = c.maxHeight;
        final tam = alto * 0.78;
        final hayAcompanante = escena.acompanante != null;
        return Stack(
          fit: StackFit.expand,
          children: [
            FondoLugar(lugar: escena.lugar),
            // Personaje principal
            Positioned(
              bottom: -tam * 0.04,
              left: hayAcompanante ? c.maxWidth * 0.04 : (c.maxWidth - tam) / 2 - c.maxWidth * 0.08,
              child: AvatarParlante(
                personaje: escena.personaje,
                tamano: tam,
                expresion: escena.expresion,
                saludando: escena.saludando,
                hablaConLaVoz: habla,
              ),
            ),
            if (hayAcompanante)
              Positioned(
                bottom: -tam * 0.04,
                right: c.maxWidth * 0.04,
                child: Transform.flip(
                  flipX: true,
                  child: AvatarParlante(
                    personaje: escena.acompanante!,
                    tamano: tam * 0.9,
                    hablaConLaVoz: false,
                  ),
                ),
              ),
            // Objeto importante flotando
            if (escena.objeto != null)
              Positioned(
                right: c.maxWidth * (hayAcompanante ? 0.38 : 0.1),
                top: alto * 0.14,
                child: AnimatedBuilder(
                animation: anim,
                builder: (context, child) {
                  final v = anim.value * 2 * math.pi * 3;
                  return Transform.translate(
                    offset: Offset(0, math.sin(v) * 6),
                    child: Transform.rotate(angle: math.sin(v) * 0.12, child: child),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(alto * 0.05),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Paleta.ciruela, width: 3),
                    boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 10, offset: Offset(0, 4))],
                  ),
                  child: Icon(escena.objeto, size: alto * 0.16, color: Paleta.ciruela),
                ),
              ),
              ),
            // Nube de pensamiento
            if (escena.globo != null)
              Positioned(
                left: hayAcompanante ? c.maxWidth * 0.3 : c.maxWidth * 0.5,
                top: alto * 0.06,
                child: _NubePensamiento(texto: escena.globo!, alto: alto),
              ),
          ],
        );
      },
    );
  }
}

class _NubePensamiento extends StatefulWidget {
  const _NubePensamiento({required this.texto, required this.alto});

  final String texto;
  final double alto;

  @override
  State<_NubePensamiento> createState() => _NubePensamientoState();
}

class _NubePensamientoState extends State<_NubePensamiento> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  )..forward();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: CurvedAnimation(parent: _c, curve: Curves.elasticOut),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: widget.alto * 0.06, vertical: widget.alto * 0.03),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Paleta.ciruela, width: 2.5),
        ),
        child: Text(
          widget.texto,
          style: TextStyle(fontSize: widget.alto * 0.13, fontWeight: FontWeight.w900, color: Paleta.papaya),
        ),
      ),
    );
  }
}

/// Muestra varias escenas como un cuento: cambia de viñeta con un
/// fundido suave cuando cambia [indice].
class SecuenciaEscenas extends StatelessWidget {
  const SecuenciaEscenas({
    super.key,
    required this.escenas,
    required this.indice,
    this.habla = false,
    this.onCambiar,
  });

  final List<Escena> escenas;
  final int indice;
  final bool habla;
  final ValueChanged<int>? onCambiar;

  @override
  Widget build(BuildContext context) {
    final i = indice.clamp(0, escenas.length - 1);
    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 700),
          switchInCurve: Curves.easeOut,
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: ScaleTransition(
              scale: Tween(begin: 1.06, end: 1.0).animate(anim),
              child: child,
            ),
          ),
          child: EscenaAnimada(
            key: ValueKey('${escenas[i].imagen}-$i'),
            escena: escenas[i],
            habla: habla,
          ),
        ),
        if (escenas.length > 1)
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var k = 0; k < escenas.length; k++)
                  GestureDetector(
                    onTap: onCambiar == null ? null : () => onCambiar!(k),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: k == i ? 26 : 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: k == i ? Paleta.papaya : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Paleta.ciruela, width: 2),
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

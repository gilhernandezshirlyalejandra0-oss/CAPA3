import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/paleta.dart';

/// Logo de Escudo Mayor: un escudo con corazón y visto bueno, que entra
/// rebotando y luego se balancea suavemente con un brillo que lo recorre.
class LogoEscudo extends StatefulWidget {
  const LogoEscudo({super.key, this.tamano = 140, this.animado = true});

  final double tamano;
  final bool animado;

  @override
  State<LogoEscudo> createState() => _LogoEscudoState();
}

class _LogoEscudoState extends State<LogoEscudo> with TickerProviderStateMixin {
  late final AnimationController _entrada = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );
  late final AnimationController _vaiven = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  );

  @override
  void initState() {
    super.initState();
    if (widget.animado) {
      _entrada.forward().then((_) {
        if (mounted) _vaiven.repeat();
      });
    } else {
      _entrada.value = 1;
    }
  }

  @override
  void dispose() {
    _entrada.dispose();
    _vaiven.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_entrada, _vaiven]),
      builder: (context, _) {
        final escala = Curves.elasticOut.transform(_entrada.value.clamp(0.0, 1.0));
        final giroEntrada = (1 - Curves.easeOut.transform(_entrada.value)) * -0.6;
        final t = _vaiven.value * 2 * math.pi;
        final balanceo = math.sin(t) * 0.05;
        final flotar = math.sin(t) * 4;
        return Transform.translate(
          offset: Offset(0, flotar),
          child: Transform.rotate(
            angle: giroEntrada + balanceo,
            child: Transform.scale(
              scale: escala,
              child: CustomPaint(
                size: Size.square(widget.tamano),
                painter: _EscudoPainter(brillo: _vaiven.value),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _EscudoPainter extends CustomPainter {
  _EscudoPainter({required this.brillo});

  final double brillo;

  Path _escudo(Rect r) {
    final w = r.width;
    final h = r.height;
    return Path()
      ..moveTo(r.left + w * 0.5, r.top)
      ..cubicTo(r.left + w * 0.72, r.top + h * 0.10, r.left + w * 0.88, r.top + h * 0.10,
          r.right, r.top + h * 0.12)
      ..cubicTo(r.right, r.top + h * 0.55, r.left + w * 0.82, r.top + h * 0.82,
          r.left + w * 0.5, r.bottom)
      ..cubicTo(r.left + w * 0.18, r.top + h * 0.82, r.left, r.top + h * 0.55, r.left,
          r.top + h * 0.12)
      ..cubicTo(r.left + w * 0.12, r.top + h * 0.10, r.left + w * 0.28, r.top + h * 0.10,
          r.left + w * 0.5, r.top)
      ..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final exterior = Rect.fromLTWH(s * 0.08, s * 0.06, s * 0.84, s * 0.9);

    // Sombra "sólida" desplazada, como en los pósters planos.
    canvas.drawPath(
      _escudo(exterior.shift(Offset(s * 0.04, s * 0.04))),
      Paint()..color = Paleta.ciruela,
    );

    final pathExterior = _escudo(exterior);
    canvas.drawPath(pathExterior, Paint()..color = Paleta.papaya);

    // Franja mostaza en diagonal recortada al escudo.
    canvas.save();
    canvas.clipPath(pathExterior);
    final franja = Path()
      ..moveTo(0, s * 0.62)
      ..lineTo(s, s * 0.30)
      ..lineTo(s, s * 0.44)
      ..lineTo(0, s * 0.76)
      ..close();
    canvas.drawPath(franja, Paint()..color = Paleta.mostaza);

    // Brillo que recorre el escudo.
    final x = -s * 0.4 + brillo * s * 1.8;
    final brilloPath = Path()
      ..moveTo(x, 0)
      ..lineTo(x + s * 0.12, 0)
      ..lineTo(x - s * 0.18, s)
      ..lineTo(x - s * 0.30, s)
      ..close();
    canvas.drawPath(brilloPath, Paint()..color = Colors.white.withValues(alpha: 0.28));
    canvas.restore();

    // Escudo interior aqua.
    final interior = Rect.fromLTWH(s * 0.24, s * 0.2, s * 0.52, s * 0.58);
    canvas.drawPath(_escudo(interior), Paint()..color = Paleta.aqua);

    // Corazón rubor (cuidado) con visto bueno blanco.
    final c = Offset(s * 0.5, s * 0.47);
    final r = s * 0.12;
    final corazon = Path()
      ..moveTo(c.dx, c.dy + r * 1.05)
      ..cubicTo(c.dx - r * 1.6, c.dy - r * 0.1, c.dx - r * 0.9, c.dy - r * 1.4, c.dx,
          c.dy - r * 0.55)
      ..cubicTo(c.dx + r * 0.9, c.dy - r * 1.4, c.dx + r * 1.6, c.dy - r * 0.1, c.dx,
          c.dy + r * 1.05)
      ..close();
    canvas.drawPath(corazon, Paint()..color = Paleta.rubor);

    final check = Path()
      ..moveTo(c.dx - r * 0.5, c.dy - r * 0.05)
      ..lineTo(c.dx - r * 0.1, c.dy + r * 0.35)
      ..lineTo(c.dx + r * 0.6, c.dy - r * 0.45);
    canvas.drawPath(
      check,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = s * 0.045
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Borde tinta.
    canvas.drawPath(
      pathExterior,
      Paint()
        ..color = Paleta.ciruela
        ..style = PaintingStyle.stroke
        ..strokeWidth = s * 0.025,
    );
  }

  @override
  bool shouldRepaint(covariant _EscudoPainter old) => old.brillo != brillo;
}

/// Título con letras que saltan una por una, cada una de un color vivo,
/// y luego hacen una "ola" suave en bucle.
class TituloSaltarin extends StatefulWidget {
  const TituloSaltarin({
    super.key,
    required this.texto,
    this.tamano = 44,
    this.retraso = Duration.zero,
    this.colores = Paleta.vivos,
  });

  final String texto;
  final double tamano;
  final Duration retraso;
  final List<Color> colores;

  @override
  State<TituloSaltarin> createState() => _TituloSaltarinState();
}

class _TituloSaltarinState extends State<TituloSaltarin> with TickerProviderStateMixin {
  late final AnimationController _entrada = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 500 + widget.texto.length * 90),
  );
  late final AnimationController _ola = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  );

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(widget.retraso, () {
      if (!mounted) return;
      _entrada.forward().then((_) {
        if (mounted) _ola.repeat();
      });
    });
  }

  @override
  void dispose() {
    _entrada.dispose();
    _ola.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final letras = widget.texto.split('');
    final n = letras.length;
    return AnimatedBuilder(
      animation: Listenable.merge([_entrada, _ola]),
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(n, (i) {
            final inicio = i / (n + 4);
            final fin = (i + 5) / (n + 4);
            final p = Interval(inicio, fin.clamp(0.0, 1.0), curve: Curves.elasticOut)
                .transform(_entrada.value);
            final ola = math.sin((_ola.value * 2 * math.pi) - i * 0.6) * 3;
            final color = widget.colores[i % widget.colores.length];
            return Transform.translate(
              offset: Offset(0, (1 - p) * -60 + (_ola.isAnimating ? ola : 0)),
              child: Opacity(
                opacity: p.clamp(0.0, 1.0),
                child: Text(
                  letras[i],
                  style: Letras.titulo(
                    size: widget.tamano,
                    color: color,
                    weight: FontWeight.w700,
                    height: 1,
                  ).copyWith(
                    shadows: const [
                      Shadow(color: Paleta.ciruela, offset: Offset(3, 3)),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

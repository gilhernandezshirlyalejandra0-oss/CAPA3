import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Animalitos tiernos para las frases del Inicio.
///
/// Tienen un estilo distinto a los personajes de la app: formas suaves,
/// sin contorno, colores pastel y mejillas rosadas, como un cuento infantil.
enum Animalito { osito, patito, conejito, gatito }

enum Regalo { corazon, flor, ninguno }

class AnimalitoAnimado extends StatefulWidget {
  const AnimalitoAnimado({
    super.key,
    required this.tipo,
    this.regalo = Regalo.ninguno,
    this.tamano = 120,
  });

  final Animalito tipo;
  final Regalo regalo;
  final double tamano;

  @override
  State<AnimalitoAnimado> createState() => _AnimalitoAnimadoState();
}

class _AnimalitoAnimadoState extends State<AnimalitoAnimado>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 4200),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.tamano,
      height: widget.tamano,
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          final t = _c.value;
          // Balanceo suave y un parpadeo cada vuelta.
          final balanceo = math.sin(t * 2 * math.pi);
          final parpadeo = (t > 0.62 && t < 0.67) ? 1.0 : 0.0;
          return CustomPaint(
            painter: _AnimalitoPainter(
              tipo: widget.tipo,
              regalo: widget.regalo,
              balanceo: balanceo,
              parpadeo: parpadeo,
            ),
          );
        },
      ),
    );
  }
}

class _Colores {
  const _Colores(
    this.cuerpo,
    this.claro,
    this.oreja,
    this.orejaDentro,
    this.nariz,
  );
  final Color cuerpo;
  final Color claro;
  final Color oreja;
  final Color orejaDentro;
  final Color nariz;
}

const _colores = {
  Animalito.osito: _Colores(
    Color(0xFFA9744F),
    Color(0xFFF3DCC0),
    Color(0xFF7A4E33),
    Color(0xFF7A4E33),
    Color(0xFF2B1D17),
  ),
  Animalito.patito: _Colores(
    Color(0xFFFFFBF2),
    Color(0xFFFFFFFF),
    Color(0xFFFFFBF2),
    Color(0xFFFFFBF2),
    Color(0xFFF29A3B),
  ),
  Animalito.conejito: _Colores(
    Color(0xFFF7F1EA),
    Color(0xFFFFFFFF),
    Color(0xFFF7F1EA),
    Color(0xFFF6B7C2),
    Color(0xFFE88A9B),
  ),
  Animalito.gatito: _Colores(
    Color(0xFFF2B36B),
    Color(0xFFFFEBD3),
    Color(0xFFF2B36B),
    Color(0xFFF7C3B5),
    Color(0xFFE88A9B),
  ),
};

class _AnimalitoPainter extends CustomPainter {
  _AnimalitoPainter({
    required this.tipo,
    required this.regalo,
    required this.balanceo,
    required this.parpadeo,
  });

  final Animalito tipo;
  final Regalo regalo;
  final double balanceo;
  final double parpadeo;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final c = _colores[tipo]!;
    Paint p(Color color) => Paint()
      ..color = color
      ..isAntiAlias = true;

    // Sombrita en el suelo
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(s * 0.5, s * 0.97),
        width: s * 0.62,
        height: s * 0.07,
      ),
      p(const Color(0x22000000)),
    );

    // Cuerpo (no se mueve)
    final cuerpo = RRect.fromRectAndCorners(
      Rect.fromLTWH(s * 0.2, s * 0.6, s * 0.6, s * 0.38),
      topLeft: Radius.circular(s * 0.28),
      topRight: Radius.circular(s * 0.28),
      bottomLeft: Radius.circular(s * 0.06),
      bottomRight: Radius.circular(s * 0.06),
    );
    canvas.drawRRect(cuerpo, p(c.cuerpo));
    if (tipo == Animalito.osito || tipo == Animalito.gatito) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(s * 0.5, s * 0.84),
          width: s * 0.34,
          height: s * 0.3,
        ),
        p(c.claro),
      );
    }

    // Cabeza con balanceo
    canvas.save();
    canvas.translate(s * 0.5, s * 0.62);
    canvas.rotate(balanceo * 0.06);
    canvas.translate(-s * 0.5, -s * 0.62);

    _orejas(canvas, s, c, p);

    final cabezaCentro = Offset(s * 0.5, s * 0.43);
    final radio = s * (tipo == Animalito.patito ? 0.27 : 0.29);
    canvas.drawCircle(cabezaCentro, radio, p(c.cuerpo));
    // Luz suave arriba de la cabeza
    canvas.drawCircle(
      cabezaCentro.translate(-radio * 0.25, -radio * 0.35),
      radio * 0.45,
      p(Colors.white.withValues(alpha: 0.12)),
    );

    if (tipo == Animalito.patito) {
      // Copete de plumas
      final copete = Path()
        ..moveTo(s * 0.47, s * 0.17)
        ..quadraticBezierTo(s * 0.49, s * 0.09, s * 0.53, s * 0.12)
        ..quadraticBezierTo(s * 0.52, s * 0.15, s * 0.55, s * 0.17)
        ..close();
      canvas.drawPath(copete, p(c.cuerpo));
    }

    // Hocico claro
    if (tipo == Animalito.osito ||
        tipo == Animalito.gatito ||
        tipo == Animalito.conejito) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(s * 0.5, s * 0.52),
          width: s * 0.3,
          height: s * 0.2,
        ),
        p(c.claro),
      );
    }
    if (tipo == Animalito.gatito) {
      // Rayitas en la frente
      final rayas = Paint()
        ..color = const Color(0xFFD98E43)
        ..strokeWidth = s * 0.025
        ..strokeCap = StrokeCap.round;
      for (final dx in [-0.05, 0.0, 0.05]) {
        canvas.drawLine(
          Offset(s * (0.5 + dx), s * 0.17),
          Offset(s * (0.5 + dx), s * 0.23),
          rayas,
        );
      }
    }

    // Mejillas
    final mejilla = p(const Color(0xFFF59AA5).withValues(alpha: 0.55));
    canvas.drawCircle(Offset(s * 0.33, s * 0.5), s * 0.055, mejilla);
    canvas.drawCircle(Offset(s * 0.67, s * 0.5), s * 0.055, mejilla);

    // Ojos (parpadean)
    final ojo = p(const Color(0xFF2B1D17));
    for (final x in [0.4, 0.6]) {
      final centro = Offset(s * x, s * 0.42);
      if (parpadeo > 0) {
        canvas.drawLine(
          centro.translate(-s * 0.025, 0),
          centro.translate(s * 0.025, 0),
          Paint()
            ..color = const Color(0xFF2B1D17)
            ..strokeWidth = s * 0.014
            ..strokeCap = StrokeCap.round,
        );
      } else {
        canvas.drawOval(
          Rect.fromCenter(center: centro, width: s * 0.045, height: s * 0.055),
          ojo,
        );
        canvas.drawCircle(
          centro.translate(-s * 0.008, -s * 0.012),
          s * 0.009,
          p(Colors.white),
        );
      }
    }

    // Nariz y boca
    if (tipo == Animalito.patito) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(s * 0.5, s * 0.52),
          width: s * 0.2,
          height: s * 0.11,
        ),
        p(c.nariz),
      );
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(s * 0.5, s * 0.5),
          width: s * 0.12,
          height: s * 0.035,
        ),
        p(Colors.white.withValues(alpha: 0.35)),
      );
    } else {
      final nariz = Path()
        ..moveTo(s * 0.47, s * 0.48)
        ..quadraticBezierTo(s * 0.5, s * 0.465, s * 0.53, s * 0.48)
        ..quadraticBezierTo(s * 0.5, s * 0.52, s * 0.47, s * 0.48)
        ..close();
      canvas.drawPath(nariz, p(c.nariz));
      final boca = Paint()
        ..color = const Color(0xFF2B1D17)
        ..style = PaintingStyle.stroke
        ..strokeWidth = s * 0.014
        ..strokeCap = StrokeCap.round;
      final w = Path()
        ..moveTo(s * 0.45, s * 0.53)
        ..quadraticBezierTo(s * 0.475, s * 0.565, s * 0.5, s * 0.53)
        ..quadraticBezierTo(s * 0.525, s * 0.565, s * 0.55, s * 0.53);
      canvas.drawPath(w, boca);
    }
    canvas.restore();

    // Regalo sostenido con las patitas
    _regalo(canvas, s, p);
    final pata = p(
      tipo == Animalito.osito ? const Color(0xFF6B4630) : c.cuerpo,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(s * 0.41, s * 0.8),
        width: s * 0.13,
        height: s * 0.1,
      ),
      pata,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(s * 0.59, s * 0.8),
        width: s * 0.13,
        height: s * 0.1,
      ),
      pata,
    );
  }

  void _orejas(Canvas canvas, double s, _Colores c, Paint Function(Color) p) {
    switch (tipo) {
      case Animalito.osito:
        for (final x in [0.27, 0.73]) {
          canvas.drawCircle(Offset(s * x, s * 0.2), s * 0.075, p(c.oreja));
        }
      case Animalito.conejito:
        for (final lado in [-1.0, 1.0]) {
          canvas.save();
          canvas.translate(s * (0.5 + 0.11 * lado), s * 0.2);
          canvas.rotate(0.18 * lado);
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(
                center: Offset(0, -s * 0.08),
                width: s * 0.14,
                height: s * 0.34,
              ),
              Radius.circular(s * 0.07),
            ),
            p(c.oreja),
          );
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(
                center: Offset(0, -s * 0.07),
                width: s * 0.07,
                height: s * 0.25,
              ),
              Radius.circular(s * 0.035),
            ),
            p(c.orejaDentro),
          );
          canvas.restore();
        }
      case Animalito.gatito:
        for (final lado in [-1.0, 1.0]) {
          final x = s * (0.5 + 0.2 * lado);
          final oreja = Path()
            ..moveTo(x - s * 0.09, s * 0.27)
            ..lineTo(x + s * 0.03 * lado, s * 0.09)
            ..lineTo(x + s * 0.09, s * 0.27)
            ..close();
          canvas.drawPath(oreja, p(c.oreja));
          final dentro = Path()
            ..moveTo(x - s * 0.045, s * 0.25)
            ..lineTo(x + s * 0.02 * lado, s * 0.15)
            ..lineTo(x + s * 0.045, s * 0.25)
            ..close();
          canvas.drawPath(dentro, p(c.orejaDentro));
        }
      case Animalito.patito:
        break;
    }
  }

  void _regalo(Canvas canvas, double s, Paint Function(Color) p) {
    final centro = Offset(s * 0.5, s * 0.74);
    switch (regalo) {
      case Regalo.corazon:
        final r = s * 0.075;
        final corazon = Path()
          ..moveTo(centro.dx, centro.dy + r * 1.1)
          ..cubicTo(
            centro.dx - r * 2.2,
            centro.dy - r * 0.2,
            centro.dx - r * 0.9,
            centro.dy - r * 1.6,
            centro.dx,
            centro.dy - r * 0.5,
          )
          ..cubicTo(
            centro.dx + r * 0.9,
            centro.dy - r * 1.6,
            centro.dx + r * 2.2,
            centro.dy - r * 0.2,
            centro.dx,
            centro.dy + r * 1.1,
          )
          ..close();
        canvas.drawPath(corazon, p(const Color(0xFFE5483D)));
      case Regalo.flor:
        canvas.drawLine(
          centro.translate(0, s * 0.02),
          centro.translate(0, s * 0.16),
          Paint()
            ..color = const Color(0xFF5E9B4E)
            ..strokeWidth = s * 0.02
            ..strokeCap = StrokeCap.round,
        );
        for (var i = 0; i < 6; i++) {
          final a = i * math.pi / 3;
          canvas.drawCircle(
            centro.translate(math.cos(a) * s * 0.045, math.sin(a) * s * 0.045),
            s * 0.035,
            p(const Color(0xFFF07D6E)),
          );
        }
        canvas.drawCircle(centro, s * 0.028, p(const Color(0xFFF6C744)));
      case Regalo.ninguno:
        break;
    }
  }

  @override
  bool shouldRepaint(_AnimalitoPainter old) =>
      old.balanceo != balanceo ||
      old.parpadeo != parpadeo ||
      old.tipo != tipo ||
      old.regalo != regalo;
}

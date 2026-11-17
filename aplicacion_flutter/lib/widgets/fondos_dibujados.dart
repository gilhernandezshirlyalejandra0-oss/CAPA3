import 'dart:math' as math;

import 'package:flutter/material.dart';

enum Lugar { casa, calle, oficina, sala }

/// Fondos dibujados estilo cuento, con detalles que se mueven:
/// nubes, cortinas, vapor del café, reloj, hojas.
class FondoLugar extends StatefulWidget {
  const FondoLugar({super.key, required this.lugar});

  final Lugar lugar;

  @override
  State<FondoLugar> createState() => _FondoLugarState();
}

class _FondoLugarState extends State<FondoLugar> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 20),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(painter: _LugarPainter(widget.lugar, _c)),
    );
  }
}

// Colores cálidos de ilustración
const _pared = Color(0xFFF3E7D3);
const _paredSombra = Color(0xFFE8D9C0);
const _madera = Color(0xFFC9935F);
const _maderaOscura = Color(0xFF9C6B3F);
const _cielo = Color(0xFFBFE0EC);
const _verde = Color(0xFF6E9B5B);
const _verdeOscuro = Color(0xFF4D7A44);
const _rojo = Color(0xFFD2584A);
const _linea = Color(0xFF5A4334);

class _LugarPainter extends CustomPainter {
  _LugarPainter(this.lugar, this.anim) : super(repaint: anim);

  final Lugar lugar;
  final Animation<double> anim;

  double get t => anim.value * 2 * math.pi;

  Paint _p(Color c) => Paint()..color = c;
  Paint _trazo(Color c, double w) => Paint()
    ..color = c
    ..style = PaintingStyle.stroke
    ..strokeWidth = w
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    switch (lugar) {
      case Lugar.casa:
        _casa(canvas, size, cocina: true);
      case Lugar.sala:
        _casa(canvas, size, cocina: false);
      case Lugar.calle:
        _calle(canvas, size);
      case Lugar.oficina:
        _oficina(canvas, size);
    }
  }

  // ───────── Casa / cocina ─────────
  void _casa(Canvas canvas, Size s, {required bool cocina}) {
    final w = s.width, h = s.height;
    canvas.drawRect(Offset.zero & s, _p(_pared));
    // Textura suave de pared
    for (var i = 0; i < 6; i++) {
      canvas.drawRect(Rect.fromLTWH(0, h * i / 6, w, h / 12), _p(_paredSombra.withValues(alpha: 0.25)));
    }

    _ventana(canvas, Rect.fromLTWH(w * 0.07, h * 0.16, w * 0.32, h * 0.36));

    // Piso de madera
    final piso = h * 0.74;
    canvas.drawRect(Rect.fromLTWH(0, piso, w, h - piso), _p(_madera));
    for (var i = 1; i < 4; i++) {
      final y = piso + (h - piso) * i / 4;
      canvas.drawLine(Offset(0, y), Offset(w, y), _trazo(_maderaOscura.withValues(alpha: 0.5), 1.5));
    }
    canvas.drawRect(Rect.fromLTWH(0, piso - 6, w, 6), _p(_maderaOscura));

    // Tapete
    final tapete = Rect.fromCenter(center: Offset(w * 0.5, h * 0.9), width: w * 0.55, height: h * 0.09);
    canvas.drawRRect(RRect.fromRectAndRadius(tapete, const Radius.circular(4)), _p(const Color(0xFFF6EEDF)));
    for (final dx in [0.06, 0.94]) {
      canvas.drawLine(
        Offset(tapete.left + tapete.width * dx, tapete.top + 3),
        Offset(tapete.left + tapete.width * dx, tapete.bottom - 3),
        _trazo(_rojo, 3),
      );
    }

    if (cocina) {
      // Repisa con frascos y matas
      final repisa = Rect.fromLTWH(w * 0.55, h * 0.3, w * 0.4, h * 0.025);
      canvas.drawRect(repisa, _p(_maderaOscura));
      _mata(canvas, Offset(w * 0.62, repisa.top), h * 0.09, t);
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.7, repisa.top - h * 0.08, w * 0.06, h * 0.08), const Radius.circular(4)),
        _p(const Color(0xFFF7F1E6)),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.79, repisa.top - h * 0.06, w * 0.07, h * 0.06), const Radius.circular(3)),
        _p(_rojo),
      );
      // Mesón
      final meson = Rect.fromLTWH(w * 0.56, h * 0.52, w * 0.44, piso - h * 0.52);
      canvas.drawRect(meson, _p(const Color(0xFF7C9A86)));
      canvas.drawRect(Rect.fromLTWH(meson.left - 4, meson.top - 8, meson.width + 4, 10), _p(_madera));
      canvas.drawLine(Offset(meson.left + meson.width / 2, meson.top + 6), Offset(meson.left + meson.width / 2, piso - 4),
          _trazo(const Color(0xFF5E7A68), 2));
      // Taza con vapor
      final taza = Offset(w * 0.66, meson.top - 8);
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(taza.dx, taza.dy - h * 0.06, w * 0.05, h * 0.06), const Radius.circular(3)),
        _p(Colors.white),
      );
      for (var k = 0; k < 2; k++) {
        final vapor = Path()..moveTo(taza.dx + w * 0.015 + k * 8, taza.dy - h * 0.07);
        for (var j = 1; j <= 6; j++) {
          vapor.lineTo(
            taza.dx + w * 0.015 + k * 8 + math.sin(t * 3 + j + k) * 3,
            taza.dy - h * 0.07 - j * 4,
          );
        }
        canvas.drawPath(vapor, _trazo(_linea.withValues(alpha: 0.35), 1.6));
      }
    } else {
      // Sala: cuadro, lámpara y sillón
      final cuadro = Rect.fromLTWH(w * 0.6, h * 0.14, w * 0.22, h * 0.18);
      canvas.drawRect(cuadro.inflate(5), _p(_maderaOscura));
      canvas.drawRect(cuadro, _p(const Color(0xFFCFE6D8)));
      canvas.drawCircle(Offset(cuadro.right - 14, cuadro.top + 14), 7, _p(const Color(0xFFF2C14E)));
      final montana = Path()
        ..moveTo(cuadro.left, cuadro.bottom)
        ..lineTo(cuadro.left + cuadro.width * 0.4, cuadro.top + cuadro.height * 0.4)
        ..lineTo(cuadro.right, cuadro.bottom)
        ..close();
      canvas.drawPath(montana, _p(_verde));
      final sillon = RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.58, h * 0.52, w * 0.4, piso - h * 0.5), const Radius.circular(18));
      canvas.drawRRect(sillon, _p(const Color(0xFFD98C6B)));
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.6, h * 0.62, w * 0.36, h * 0.1), const Radius.circular(12)),
        _p(const Color(0xFFC0735A)),
      );
    }

    // Mata grande en el piso, a la izquierda
    _maceta(canvas, Offset(w * 0.08, piso), h * 0.16);
  }

  void _ventana(Canvas canvas, Rect r) {
    canvas.drawRect(r.inflate(6), _p(_maderaOscura));
    canvas.drawRect(r, _p(_cielo));
    // Nubes que pasan
    canvas.save();
    canvas.clipRect(r);
    for (var k = 0; k < 2; k++) {
      final x = r.left + ((anim.value + k * 0.5) % 1.0) * (r.width + 60) - 30;
      final y = r.top + r.height * (0.25 + k * 0.3);
      for (final d in const [Offset(0, 0), Offset(12, -6), Offset(24, 0)]) {
        canvas.drawCircle(Offset(x + d.dx, y + d.dy), 9, _p(Colors.white));
      }
    }
    // Arbolitos afuera
    for (final fx in [0.25, 0.7]) {
      final base = Offset(r.left + r.width * fx, r.bottom);
      final arbol = Path()
        ..moveTo(base.dx - r.width * 0.14, base.dy)
        ..lineTo(base.dx, base.dy - r.height * 0.55)
        ..lineTo(base.dx + r.width * 0.14, base.dy)
        ..close();
      canvas.drawPath(arbol, _p(_verdeOscuro));
    }
    canvas.restore();
    // Marco en cruz
    canvas.drawLine(Offset(r.center.dx, r.top), Offset(r.center.dx, r.bottom), _trazo(_maderaOscura, 5));
    canvas.drawLine(Offset(r.left, r.center.dy), Offset(r.right, r.center.dy), _trazo(_maderaOscura, 5));
    // Cortinas que se mecen
    final vaiven = math.sin(t * 2) * 3;
    for (final lado in [-1, 1]) {
      final x0 = lado < 0 ? r.left - 14 : r.right + 14;
      final cortina = Path()
        ..moveTo(x0, r.top - 12)
        ..lineTo(x0 - lado * r.width * 0.22, r.top - 12)
        ..quadraticBezierTo(x0 - lado * r.width * 0.12 + vaiven, r.center.dy, x0 - lado * r.width * 0.2, r.bottom + 14)
        ..lineTo(x0, r.bottom + 14)
        ..close();
      canvas.drawPath(cortina, _p(const Color(0xFFF7EBD5)));
      canvas.drawPath(cortina, _trazo(_paredSombra, 1.5));
    }
    canvas.drawLine(Offset(r.left - 22, r.top - 12), Offset(r.right + 22, r.top - 12), _trazo(_linea, 3));
  }

  void _mata(Canvas canvas, Offset base, double alto, double fase) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: base.translate(0, -alto * 0.18), width: alto * 0.5, height: alto * 0.36),
          const Radius.circular(3)),
      _p(const Color(0xFFC47A4E)),
    );
    for (var k = -2; k <= 2; k++) {
      final ang = -math.pi / 2 + k * 0.45 + math.sin(fase * 2 + k) * 0.05;
      final fin = base.translate(math.cos(ang) * alto * 0.7, -alto * 0.3 + math.sin(ang) * alto * 0.6);
      canvas.drawLine(base.translate(0, -alto * 0.32), fin, _trazo(_verdeOscuro, 2));
      canvas.drawOval(Rect.fromCenter(center: fin, width: alto * 0.24, height: alto * 0.14), _p(_verde));
    }
  }

  void _maceta(Canvas canvas, Offset base, double alto) {
    final maceta = Path()
      ..moveTo(base.dx - alto * 0.22, base.dy - alto * 0.3)
      ..lineTo(base.dx + alto * 0.22, base.dy - alto * 0.3)
      ..lineTo(base.dx + alto * 0.17, base.dy)
      ..lineTo(base.dx - alto * 0.17, base.dy)
      ..close();
    for (var k = 0; k < 7; k++) {
      final ang = -math.pi / 2 + (k - 3) * 0.32 + math.sin(t * 2 + k) * 0.06;
      final fin = base.translate(math.cos(ang) * alto * 0.75, -alto * 0.3 + math.sin(ang) * alto * 0.8);
      final hoja = Path()
        ..moveTo(base.dx, base.dy - alto * 0.3)
        ..quadraticBezierTo((base.dx + fin.dx) / 2 + 8, (base.dy - alto * 0.3 + fin.dy) / 2, fin.dx, fin.dy)
        ..quadraticBezierTo((base.dx + fin.dx) / 2 - 8, (base.dy - alto * 0.3 + fin.dy) / 2, base.dx, base.dy - alto * 0.3);
      canvas.drawPath(hoja, _p(k.isEven ? _verde : _verdeOscuro));
    }
    canvas.drawPath(maceta, _p(const Color(0xFFC47A4E)));
  }

  // ───────── Calle con corresponsal ─────────
  void _calle(Canvas canvas, Size s) {
    final w = s.width, h = s.height;
    canvas.drawRect(Offset.zero & s, _p(_cielo));
    canvas.drawCircle(Offset(w * 0.85, h * 0.15), h * 0.07, _p(const Color(0xFFF6CF57)));
    for (var k = 0; k < 3; k++) {
      final x = ((anim.value * 0.6 + k / 3) % 1.0) * (w + 80) - 40;
      final y = h * (0.1 + k * 0.08);
      for (final d in const [Offset(0, 0), Offset(16, -8), Offset(32, 0)]) {
        canvas.drawCircle(Offset(x + d.dx, y + d.dy), 12, _p(Colors.white));
      }
    }
    // Edificios
    const colores = [Color(0xFFF2B8A2), Color(0xFFF6E2B3), Color(0xFFB9D8C9), Color(0xFFE9C3D0)];
    final anchos = [0.24, 0.28, 0.22, 0.26];
    var x = 0.0;
    for (var i = 0; i < 4; i++) {
      final bw = w * anchos[i];
      final top = h * (0.28 + (i.isEven ? 0.0 : 0.06));
      final r = Rect.fromLTWH(x, top, bw, h * 0.72 - top);
      canvas.drawRect(r, _p(colores[i]));
      canvas.drawRect(Rect.fromLTWH(x - 2, top - 8, bw + 4, 8), _p(_maderaOscura.withValues(alpha: 0.7)));
      for (var fy = 0; fy < 2; fy++) {
        for (var fx = 0; fx < 2; fx++) {
          canvas.drawRect(
            Rect.fromLTWH(x + bw * (0.18 + fx * 0.42), top + 14 + fy * (r.height * 0.32), bw * 0.24, r.height * 0.18),
            _p(const Color(0xFF8FB7C9)),
          );
        }
      }
      x += bw;
    }
    // Letrero del corresponsal
    final cartel = Rect.fromLTWH(w * 0.27, h * 0.5, w * 0.26, h * 0.08);
    canvas.drawRRect(RRect.fromRectAndRadius(cartel, const Radius.circular(4)), _p(const Color(0xFFF2C14E)));
    final tp = TextPainter(
      text: TextSpan(
        text: 'CORRESPONSAL',
        style: TextStyle(color: _linea, fontSize: cartel.height * 0.42, fontWeight: FontWeight.w900),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: cartel.width);
    tp.paint(canvas, cartel.center - Offset(tp.width / 2, tp.height / 2));
    // Andén y calle
    canvas.drawRect(Rect.fromLTWH(0, h * 0.72, w, h * 0.1), _p(const Color(0xFFD9D2C5)));
    canvas.drawRect(Rect.fromLTWH(0, h * 0.82, w, h * 0.18), _p(const Color(0xFF8D8A86)));
    for (var k = 0; k < 6; k++) {
      final lx = ((k / 6 - anim.value * 0.3) % 1.0) * w;
      canvas.drawRect(Rect.fromLTWH(lx, h * 0.905, w * 0.07, 4), _p(Colors.white));
    }
    // Arbolito en el andén
    canvas.drawRect(Rect.fromLTWH(w * 0.85, h * 0.55, 8, h * 0.18), _p(_maderaOscura));
    canvas.drawCircle(Offset(w * 0.85 + 4, h * 0.5 + math.sin(t) * 2), h * 0.09, _p(_verde));
  }

  // ───────── Oficina / banco ─────────
  void _oficina(Canvas canvas, Size s) {
    final w = s.width, h = s.height;
    canvas.drawRect(Offset.zero & s, _p(const Color(0xFFDDEDEA)));
    canvas.drawRect(Rect.fromLTWH(0, h * 0.62, w, h * 0.38), _p(const Color(0xFFB7CFCB)));
    // Reloj de pared con manecillas que giran
    final centro = Offset(w * 0.8, h * 0.22);
    final r = h * 0.11;
    canvas.drawCircle(centro, r + 4, _p(_linea));
    canvas.drawCircle(centro, r, _p(Colors.white));
    final minuto = t * 4;
    canvas.drawLine(centro, centro + Offset(math.sin(minuto) * r * 0.8, -math.cos(minuto) * r * 0.8), _trazo(_linea, 2.5));
    canvas.drawLine(centro, centro + Offset(math.sin(minuto / 12) * r * 0.5, -math.cos(minuto / 12) * r * 0.5), _trazo(_rojo, 3.5));
    // Cuadro de alcancía
    final cuadro = Rect.fromLTWH(w * 0.08, h * 0.12, w * 0.24, h * 0.22);
    canvas.drawRect(cuadro.inflate(4), _p(_maderaOscura));
    canvas.drawRect(cuadro, _p(const Color(0xFFFCEFC7)));
    canvas.drawOval(Rect.fromCenter(center: cuadro.center, width: cuadro.width * 0.5, height: cuadro.height * 0.5), _p(const Color(0xFFF48FA0)));
    // Escritorio con teléfono
    final mesa = Rect.fromLTWH(w * 0.5, h * 0.6, w * 0.5, h * 0.06);
    canvas.drawRect(mesa, _p(_madera));
    canvas.drawRect(Rect.fromLTWH(mesa.left + 10, mesa.bottom, 8, h - mesa.bottom), _p(_maderaOscura));
    final tel = Rect.fromLTWH(w * 0.6, mesa.top - h * 0.07, w * 0.12, h * 0.07);
    canvas.drawRRect(RRect.fromRectAndRadius(tel, const Radius.circular(6)), _p(_rojo));
    // Ondas de "ring"
    final ring = (math.sin(t * 6) + 1) / 2;
    for (var k = 1; k <= 2; k++) {
      canvas.drawArc(
        Rect.fromCircle(center: tel.topCenter, radius: 10.0 * k + ring * 4),
        math.pi * 1.2,
        math.pi * 0.6,
        false,
        _trazo(_rojo.withValues(alpha: 0.6), 2.5),
      );
    }
    _maceta(canvas, Offset(w * 0.08, h * 0.98), h * 0.2);
  }

  @override
  bool shouldRepaint(covariant _LugarPainter old) => old.lugar != lugar;
}

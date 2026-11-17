import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../services/asistente.dart';
import '../services/voz_humana.dart';

enum Expresion { feliz, sorprendida, preocupada }

/// Personaje ilustrado (estilo cuento) que respira, parpadea, saluda
/// y mueve la boca al ritmo de la voz.
class AvatarParlante extends StatefulWidget {
  const AvatarParlante({
    super.key,
    required this.personaje,
    this.tamano = 220,
    this.expresion = Expresion.feliz,
    this.saludando = false,
    this.hablaConLaVoz = true,
  });

  final Personaje personaje;
  final double tamano;
  final Expresion expresion;
  final bool saludando;

  /// Si es false, el personaje no mueve la boca (útil para miniaturas).
  final bool hablaConLaVoz;

  @override
  State<AvatarParlante> createState() => _AvatarParlanteState();
}

class _AvatarParlanteState extends State<AvatarParlante>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  Duration _tiempo = Duration.zero;
  double _parpadeo = 1; // 1 abierto, 0 cerrado
  double _boca = 0; // 0 cerrada, 1 muy abierta
  double _impulsoPalabra = 0;
  Timer? _timerParpadeo;
  final _azar = math.Random();

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_cuadro)..start();
    _programarParpadeo();
    VozHumana.palabra.addListener(_nuevaPalabra);
  }

  void _nuevaPalabra() {
    if (widget.hablaConLaVoz) _impulsoPalabra = 1;
  }

  void _programarParpadeo() {
    _timerParpadeo = Timer(Duration(milliseconds: 1800 + _azar.nextInt(2800)), () async {
      if (!mounted) return;
      for (final v in [0.5, 0.0, 0.5, 1.0]) {
        await Future<void>.delayed(const Duration(milliseconds: 45));
        if (!mounted) return;
        _parpadeo = v;
      }
      _programarParpadeo();
    });
  }

  void _cuadro(Duration t) {
    final dt = (t - _tiempo).inMicroseconds / 1e6;
    _tiempo = t;
    final segundos = t.inMicroseconds / 1e6;

    double objetivo = 0;
    if (widget.hablaConLaVoz && VozHumana.estado.value == EstadoVoz.hablando) {
      // Sílabas: mezcla de ondas + golpe en cada palabra nueva.
      final silabas = (math.sin(segundos * 17) * 0.5 + 0.5) *
          (0.55 + 0.45 * math.sin(segundos * 5.3).abs());
      objetivo = (0.25 + silabas * 0.6 + _impulsoPalabra * 0.35).clamp(0.0, 1.0);
    }
    _impulsoPalabra = math.max(0, _impulsoPalabra - dt * 4);
    _boca += (objetivo - _boca) * math.min(1, dt * 18);
    setState(() {});
  }

  @override
  void dispose() {
    VozHumana.palabra.removeListener(_nuevaPalabra);
    _timerParpadeo?.cancel();
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = _tiempo.inMicroseconds / 1e6;
    final respiracion = math.sin(s * 2.2) * 0.012;
    final balanceo = math.sin(s * 1.1) * 0.025;
    return SizedBox.square(
      dimension: widget.tamano,
      child: Transform.rotate(
        angle: balanceo,
        alignment: Alignment.bottomCenter,
        child: Transform.scale(
          scaleY: 1 + respiracion,
          alignment: Alignment.bottomCenter,
          child: CustomPaint(
            painter: _PersonajePainter(
              p: widget.personaje,
              parpadeo: _parpadeo,
              boca: _boca,
              expresion: widget.expresion,
              mano: widget.saludando ? math.sin(s * 7) : null,
              miradaX: math.sin(s * 0.7) * 0.4,
            ),
          ),
        ),
      ),
    );
  }
}

class _PersonajePainter extends CustomPainter {
  _PersonajePainter({
    required this.p,
    required this.parpadeo,
    required this.boca,
    required this.expresion,
    required this.mano,
    required this.miradaX,
  });

  final Personaje p;
  final double parpadeo;
  final double boca;
  final Expresion expresion;
  final double? mano;
  final double miradaX;

  late double _s;
  Offset _o(double x, double y) => Offset(x * _s, y * _s);

  @override
  void paint(Canvas canvas, Size size) {
    _s = size.width;
    final cabeza = _o(0.5, 0.45);
    final rx = 0.27 * _s;
    final ry = 0.26 * _s;

    _peloAtras(canvas, cabeza);
    _cuerpo(canvas);
    _orejas(canvas, cabeza, rx);

    // Cabeza
    canvas.drawOval(
      Rect.fromCenter(center: cabeza, width: rx * 2, height: ry * 2),
      Paint()..color = p.piel,
    );

    _cachetes(canvas);
    if (p.barba) _barba(canvas);
    _ojos(canvas);
    _nariz(canvas);
    _bocaDibujo(canvas);
    if (p.bigote) _bigote(canvas);
    _peloDelante(canvas, cabeza);
    if (p.gafas) _gafas(canvas);
    if (p.gafasOscuras) _gafasOscuras(canvas);
    if (p.ganchos) _ganchos(canvas);
    if (p.sombrero) {
      _sombreroVueltiao(canvas);
    } else if (p.gorra != null) {
      _gorra(canvas, p.gorra!);
    }
    if (mano != null) _manoSaludando(canvas, mano!);
  }

  // ───────── Accesorios ─────────

  void _barba(Canvas canvas) {
    final barba = Path()
      ..moveTo(_s * 0.27, _s * 0.5)
      ..quadraticBezierTo(_s * 0.28, _s * 0.74, _s * 0.5, _s * 0.76)
      ..quadraticBezierTo(_s * 0.72, _s * 0.74, _s * 0.73, _s * 0.5)
      ..quadraticBezierTo(_s * 0.66, _s * 0.6, _s * 0.5, _s * 0.58)
      ..quadraticBezierTo(_s * 0.34, _s * 0.6, _s * 0.27, _s * 0.5)
      ..close();
    canvas.drawPath(barba, Paint()..color = p.pelo);
  }

  void _gafasOscuras(Canvas canvas) {
    final lente = Paint()..color = const Color(0xFF1E1A22);
    for (final x in [0.395, 0.605]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: _o(x, 0.47), width: _s * 0.17, height: _s * 0.11),
          Radius.circular(_s * 0.04),
        ),
        lente,
      );
      canvas.drawLine(_o(x - 0.05, 0.45), _o(x - 0.02, 0.43),
          Paint()
            ..color = Colors.white.withValues(alpha: 0.7)
            ..strokeWidth = _s * 0.012
            ..strokeCap = StrokeCap.round);
    }
    canvas.drawLine(_o(0.48, 0.46), _o(0.52, 0.46), Paint()
      ..color = const Color(0xFF1E1A22)
      ..strokeWidth = _s * 0.012);
  }

  void _gorra(Canvas canvas, Color color) {
    final copa = Path()
      ..moveTo(_s * 0.22, _s * 0.33)
      ..quadraticBezierTo(_s * 0.24, _s * 0.1, _s * 0.5, _s * 0.1)
      ..quadraticBezierTo(_s * 0.76, _s * 0.1, _s * 0.78, _s * 0.33)
      ..close();
    canvas.drawPath(copa, Paint()..color = color);
    // Visera
    canvas.drawOval(
      Rect.fromCenter(center: _o(0.42, 0.33), width: _s * 0.5, height: _s * 0.08),
      Paint()..color = Color.lerp(color, Colors.black, 0.2)!,
    );
    canvas.drawCircle(_o(0.5, 0.11), _s * 0.02, Paint()..color = Colors.white);
  }

  void _sombreroVueltiao(Canvas canvas) {
    const crema = Color(0xFFF2E3C2);
    const negro = Color(0xFF2B2420);
    final ala = Rect.fromCenter(center: _o(0.5, 0.27), width: _s * 0.86, height: _s * 0.16);
    canvas.drawOval(ala, Paint()..color = crema);
    for (var k = 1; k <= 2; k++) {
      canvas.drawOval(
        ala.deflate(_s * 0.035 * k),
        Paint()
          ..color = negro
          ..style = PaintingStyle.stroke
          ..strokeWidth = _s * 0.012,
      );
    }
    final copa = Path()
      ..moveTo(_s * 0.3, _s * 0.27)
      ..lineTo(_s * 0.34, _s * 0.08)
      ..quadraticBezierTo(_s * 0.5, _s * 0.04, _s * 0.66, _s * 0.08)
      ..lineTo(_s * 0.7, _s * 0.27)
      ..close();
    canvas.drawPath(copa, Paint()..color = crema);
    for (var k = 0; k < 3; k++) {
      canvas.drawLine(
        _o(0.32 + k * 0.005, 0.22 - k * 0.05),
        _o(0.68 - k * 0.005, 0.22 - k * 0.05),
        Paint()
          ..color = negro
          ..strokeWidth = _s * 0.014,
      );
    }
  }

  // ───────── Pelo ─────────

  void _rizo(Canvas canvas, Offset c, double r, int i) {
    canvas.drawCircle(c, r, Paint()..color = p.pelo);
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: r * 0.55),
      i * 1.3,
      4.2,
      false,
      Paint()
        ..color = p.peloOscuro
        ..style = PaintingStyle.stroke
        ..strokeWidth = _s * 0.009
        ..strokeCap = StrokeCap.round,
    );
  }

  void _melena(Canvas canvas, Offset centro, double rx, double ry, double rRizo) {
    final azar = math.Random(p.id.hashCode);
    canvas.drawOval(
      Rect.fromCenter(center: centro, width: rx * 2 * _s, height: ry * 2 * _s),
      Paint()..color = p.pelo,
    );
    // Rizos del contorno (tamaños un poco distintos para que se vea natural)
    var i = 0;
    for (double a = 0; a < 360; a += 17) {
      final r = a * math.pi / 180;
      final c = centro + Offset(math.cos(r) * rx * _s, math.sin(r) * ry * _s);
      _rizo(canvas, c, _s * rRizo * (0.85 + azar.nextDouble() * 0.35), i++);
    }
    // Espirales dentro de la melena
    final espiral = Paint()
      ..color = p.peloOscuro
      ..style = PaintingStyle.stroke
      ..strokeWidth = _s * 0.008
      ..strokeCap = StrokeCap.round;
    for (var k = 0; k < 26; k++) {
      final a = azar.nextDouble() * 2 * math.pi;
      final d = 0.45 + azar.nextDouble() * 0.45;
      final c = centro + Offset(math.cos(a) * rx * d * _s, math.sin(a) * ry * d * _s);
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: _s * rRizo * 0.45),
        azar.nextDouble() * 6,
        4,
        false,
        espiral,
      );
    }
  }

  void _peloAtras(Canvas canvas, Offset cabeza) {
    switch (p.tipoPelo) {
      case TipoPelo.rizosLargos:
        // Melena esponjosa: una masa redonda con rizos en todo el borde.
        _melena(canvas, _o(0.5, 0.44), 0.38, 0.36, 0.075);
      case TipoPelo.rizosCortos:
        _melena(canvas, cabeza.translate(0, -_s * 0.03), 0.31, 0.28, 0.06);
      case TipoPelo.monoCanoso:
        _rizo(canvas, _o(0.5, 0.12), _s * 0.1, 3);
        var i = 0;
        for (double a = -200; a <= 20; a += 25) {
          final r = a * math.pi / 180;
          _rizo(canvas, cabeza + Offset(math.cos(r) * _s * 0.28, math.sin(r) * _s * 0.26),
              _s * 0.07, i++);
        }
      case TipoPelo.cortoCanoso:
      case TipoPelo.calvo:
        for (final lado in [-1, 1]) {
          canvas.drawOval(
            Rect.fromCenter(center: _o(0.5 + lado * 0.26, 0.42), width: _s * 0.1, height: _s * 0.18),
            Paint()..color = p.pelo,
          );
        }
      case TipoPelo.lisoLargo:
        canvas.drawRRect(
          RRect.fromRectAndCorners(
            Rect.fromLTRB(_s * 0.18, _s * 0.14, _s * 0.82, _s * 0.84),
            topLeft: Radius.circular(_s * 0.3),
            topRight: Radius.circular(_s * 0.3),
            bottomLeft: Radius.circular(_s * 0.06),
            bottomRight: Radius.circular(_s * 0.06),
          ),
          Paint()..color = p.pelo,
        );
        _mechones(canvas, 0.2, 0.8, 0.55, 0.82);
      case TipoPelo.lisoCorto:
        canvas.drawOval(
          Rect.fromCenter(center: _o(0.5, 0.38), width: _s * 0.62, height: _s * 0.52),
          Paint()..color = p.pelo,
        );
      case TipoPelo.trenzas:
        canvas.drawOval(
          Rect.fromCenter(center: _o(0.5, 0.38), width: _s * 0.62, height: _s * 0.52),
          Paint()..color = p.pelo,
        );
        for (final lado in [-1, 1]) {
          for (var k = 0; k < 6; k++) {
            final c = _o(0.5 + lado * (0.31 - k * 0.004), 0.5 + k * 0.06);
            canvas.drawOval(
              Rect.fromCenter(center: c, width: _s * 0.085, height: _s * 0.07),
              Paint()..color = p.pelo,
            );
            canvas.drawArc(
              Rect.fromCenter(center: c, width: _s * 0.085, height: _s * 0.07),
              0.3,
              math.pi - 0.6,
              false,
              Paint()
                ..color = p.peloOscuro
                ..style = PaintingStyle.stroke
                ..strokeWidth = _s * 0.008,
            );
          }
          canvas.drawCircle(_o(0.5 + lado * 0.29, 0.88), _s * 0.028, Paint()..color = const Color(0xFFE24E42));
        }
    }
  }

  void _mechones(Canvas canvas, double x0, double x1, double y0, double y1) {
    final paint = Paint()
      ..color = p.peloOscuro.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = _s * 0.008
      ..strokeCap = StrokeCap.round;
    for (final x in [x0 + 0.03, x0 + 0.07, x1 - 0.07, x1 - 0.03]) {
      canvas.drawLine(_o(x, y0), _o(x, y1 - 0.04), paint);
    }
  }

  /// Flequillo liso con raya al lado.
  void _flequilloLiso(Canvas canvas) {
    final path = Path()
      ..moveTo(_s * 0.23, _s * 0.46)
      ..quadraticBezierTo(_s * 0.2, _s * 0.17, _s * 0.5, _s * 0.16)
      ..quadraticBezierTo(_s * 0.8, _s * 0.17, _s * 0.77, _s * 0.46)
      ..quadraticBezierTo(_s * 0.7, _s * 0.3, _s * 0.44, _s * 0.27)
      ..quadraticBezierTo(_s * 0.34, _s * 0.32, _s * 0.23, _s * 0.46)
      ..close();
    canvas.drawPath(path, Paint()..color = p.pelo);
    final linea = Paint()
      ..color = p.peloOscuro.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = _s * 0.009
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(
      Path()
        ..moveTo(_s * 0.44, _s * 0.2)
        ..quadraticBezierTo(_s * 0.6, _s * 0.22, _s * 0.7, _s * 0.36),
      linea,
    );
    canvas.drawPath(
      Path()
        ..moveTo(_s * 0.42, _s * 0.2)
        ..quadraticBezierTo(_s * 0.32, _s * 0.26, _s * 0.28, _s * 0.38),
      linea,
    );
  }

  void _peloDelante(Canvas canvas, Offset cabeza) {
    switch (p.tipoPelo) {
      case TipoPelo.rizosLargos:
      case TipoPelo.rizosCortos:
        // Flequillo de rizos sobre la frente.
        var i = 7;
        for (double a = -168; a <= -12; a += 19) {
          final r = a * math.pi / 180;
          final c = cabeza + Offset(math.cos(r) * _s * 0.21, math.sin(r) * _s * 0.2 - _s * 0.035);
          _rizo(canvas, c, _s * 0.068, i++);
        }
      case TipoPelo.monoCanoso:
        var i = 2;
        for (double a = -160; a <= -20; a += 28) {
          final r = a * math.pi / 180;
          _rizo(canvas, cabeza + Offset(math.cos(r) * _s * 0.2, math.sin(r) * _s * 0.2 - _s * 0.03),
              _s * 0.06, i++);
        }
      case TipoPelo.lisoLargo:
      case TipoPelo.lisoCorto:
      case TipoPelo.trenzas:
        _flequilloLiso(canvas);
      case TipoPelo.calvo:
        // Brillo en la calva
        canvas.drawArc(
          Rect.fromCenter(center: _o(0.42, 0.26), width: _s * 0.14, height: _s * 0.08),
          math.pi * 1.1,
          math.pi * 0.5,
          false,
          Paint()
            ..color = Colors.white.withValues(alpha: 0.6)
            ..style = PaintingStyle.stroke
            ..strokeWidth = _s * 0.014
            ..strokeCap = StrokeCap.round,
        );
      case TipoPelo.cortoCanoso:
        final gorro = Path()
          ..addArc(
            Rect.fromCenter(center: cabeza.translate(0, -_s * 0.03), width: _s * 0.56, height: _s * 0.48),
            math.pi * 1.03,
            math.pi * 0.94,
          )
          ..close();
        canvas.drawPath(gorro, Paint()..color = p.pelo);
        // Mechón
        canvas.drawArc(
          Rect.fromCenter(center: _o(0.44, 0.27), width: _s * 0.16, height: _s * 0.08),
          0,
          math.pi,
          false,
          Paint()
            ..color = p.peloOscuro
            ..style = PaintingStyle.stroke
            ..strokeWidth = _s * 0.012
            ..strokeCap = StrokeCap.round,
        );
    }
  }

  // ───────── Cuerpo ─────────

  void _cuerpo(Canvas canvas) {
    // Cuello
    canvas.drawRect(
      Rect.fromCenter(center: _o(0.5, 0.74), width: _s * 0.12, height: _s * 0.1),
      Paint()..color = Color.lerp(p.piel, Colors.black, 0.08)!,
    );
    // Camisa
    final camisa = RRect.fromRectAndCorners(
      Rect.fromLTRB(_s * 0.2, _s * 0.78, _s * 0.8, _s * 1.08),
      topLeft: Radius.circular(_s * 0.16),
      topRight: Radius.circular(_s * 0.16),
    );
    canvas.drawRRect(camisa, Paint()..color = p.camisa);
    // Cuello de la camisa
    final cuello = Path()
      ..moveTo(_s * 0.42, _s * 0.78)
      ..lineTo(_s * 0.5, _s * 0.86)
      ..lineTo(_s * 0.58, _s * 0.78);
    canvas.drawPath(
      cuello,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = _s * 0.018
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );
    if (p.corbata) {
      final corbata = Path()
        ..moveTo(_s * 0.48, _s * 0.8)
        ..lineTo(_s * 0.52, _s * 0.8)
        ..lineTo(_s * 0.545, _s * 0.97)
        ..lineTo(_s * 0.5, _s * 1.01)
        ..lineTo(_s * 0.455, _s * 0.97)
        ..close();
      canvas.drawPath(corbata, Paint()..color = const Color(0xFFE24E42));
    }
  }

  void _orejas(Canvas canvas, Offset cabeza, double rx) {
    for (final lado in [-1, 1]) {
      final c = cabeza + Offset(lado * rx * 0.98, _s * 0.03);
      canvas.drawCircle(c, _s * 0.045, Paint()..color = p.piel);
      canvas.drawCircle(c, _s * 0.022, Paint()..color = const Color(0xFFF2A7A0).withValues(alpha: 0.6));
      if (p.aretes) {
        canvas.drawCircle(c + Offset(0, _s * 0.055), _s * 0.018, Paint()..color = const Color(0xFFE9B000));
      }
    }
  }

  // ───────── Cara ─────────

  void _cachetes(Canvas canvas) {
    final rubor = Paint()..color = const Color(0xFFF48FA0).withValues(alpha: p.esNino ? 0.55 : 0.4);
    for (final lado in [-1, 1]) {
      canvas.drawOval(
        Rect.fromCenter(center: _o(0.5 + lado * 0.165, 0.54), width: _s * 0.1, height: _s * 0.065),
        rubor,
      );
      if (p.pecas) {
        final peca = Paint()..color = const Color(0xFFB0644A).withValues(alpha: 0.55);
        for (final d in const [Offset(-0.02, -0.01), Offset(0.015, -0.015), Offset(0.0, 0.012), Offset(0.025, 0.008)]) {
          canvas.drawCircle(_o(0.5 + lado * 0.165 + d.dx, 0.54 + d.dy), _s * 0.0055, peca);
        }
      }
    }
  }

  void _ojos(Canvas canvas) {
    final r = _s * (p.esNino ? 0.058 : 0.045);
    final y = 0.47;
    for (final lado in [-1, 1]) {
      final c = _o(0.5 + lado * 0.105, y);
      final abierto = parpadeo.clamp(0.0, 1.0);
      final sorpresa = expresion == Expresion.sorprendida ? 1.12 : 1.0;

      if (abierto < 0.2) {
        canvas.drawArc(
          Rect.fromCircle(center: c, radius: r * 0.8),
          0.2,
          math.pi - 0.4,
          false,
          Paint()
            ..color = p.ojos
            ..style = PaintingStyle.stroke
            ..strokeWidth = _s * 0.012
            ..strokeCap = StrokeCap.round,
        );
      } else {
        canvas.save();
        canvas.translate(c.dx, c.dy);
        canvas.scale(sorpresa, abierto * sorpresa);
        // Blanco del ojo (fino, como en las ilustraciones)
        canvas.drawCircle(Offset.zero, r * 1.12, Paint()..color = Colors.white);
        final pupila = Offset(miradaX * r * 0.18, r * 0.05);
        canvas.drawCircle(pupila, r, Paint()..color = p.ojos);
        canvas.drawCircle(pupila + Offset(-r * 0.35, -r * 0.38), r * 0.3, Paint()..color = Colors.white);
        canvas.drawCircle(pupila + Offset(r * 0.38, r * 0.35), r * 0.12, Paint()..color = Colors.white);
        canvas.restore();
      }

      // Pestañas
      if (p.pestanas && abierto >= 0.2) {
        final pest = Paint()
          ..color = p.ojos
          ..style = PaintingStyle.stroke
          ..strokeWidth = _s * 0.008
          ..strokeCap = StrokeCap.round;
        for (var k = 0; k < 3; k++) {
          final ang = -math.pi / 2 + lado * (0.55 + k * 0.32);
          final ini = c + Offset(math.cos(ang) * r * 1.1, math.sin(ang) * r * 1.1 * abierto);
          final fin = c + Offset(math.cos(ang) * r * 1.5, math.sin(ang) * r * 1.45 * abierto);
          canvas.drawLine(ini, fin, pest);
        }
      }

      // Cejas
      final subida = switch (expresion) {
        Expresion.sorprendida => -0.035,
        Expresion.preocupada => -0.01,
        Expresion.feliz => 0.0,
      };
      final inclinacion = expresion == Expresion.preocupada ? lado * -0.25 : 0.0;
      canvas.save();
      canvas.translate(c.dx, c.dy - r * 1.75 + subida * _s);
      canvas.rotate(inclinacion);
      canvas.drawArc(
        Rect.fromCenter(center: Offset.zero, width: r * 1.6, height: r * 0.7),
        math.pi * 1.15,
        math.pi * 0.7,
        false,
        Paint()
          ..color = p.tipoPelo == TipoPelo.rizosLargos ? p.peloOscuro : p.ojos.withValues(alpha: 0.85)
          ..style = PaintingStyle.stroke
          ..strokeWidth = _s * 0.013
          ..strokeCap = StrokeCap.round,
      );
      canvas.restore();
    }
  }

  void _nariz(Canvas canvas) {
    canvas.drawArc(
      Rect.fromCenter(center: _o(0.5, 0.535), width: _s * 0.035, height: _s * 0.025),
      0.2,
      math.pi - 0.4,
      false,
      Paint()
        ..color = Color.lerp(p.piel, const Color(0xFF8A4A3A), 0.45)!
        ..style = PaintingStyle.stroke
        ..strokeWidth = _s * 0.008
        ..strokeCap = StrokeCap.round,
    );
  }

  void _bocaDibujo(Canvas canvas) {
    final c = _o(0.5, 0.605);
    final ancho = _s * (expresion == Expresion.sorprendida ? 0.06 : 0.085);
    final abierta = expresion == Expresion.sorprendida ? math.max(boca, 0.55) : boca;

    if (abierta < 0.08) {
      // Sonrisa cerrada (o boquita preocupada)
      final curva = expresion == Expresion.preocupada ? -1 : 1;
      final path = Path()
        ..moveTo(c.dx - ancho / 2, c.dy)
        ..quadraticBezierTo(c.dx, c.dy + curva * _s * 0.035, c.dx + ancho / 2, c.dy);
      canvas.drawPath(
        path,
        Paint()
          ..color = const Color(0xFF8C3A3F)
          ..style = PaintingStyle.stroke
          ..strokeWidth = _s * 0.012
          ..strokeCap = StrokeCap.round,
      );
      return;
    }

    final alto = _s * (0.015 + abierta * 0.06);
    final boquita = Path()
      ..moveTo(c.dx - ancho / 2, c.dy - alto * 0.15)
      ..quadraticBezierTo(c.dx, c.dy - alto * 0.35, c.dx + ancho / 2, c.dy - alto * 0.15)
      ..quadraticBezierTo(c.dx + ancho * 0.45, c.dy + alto, c.dx, c.dy + alto)
      ..quadraticBezierTo(c.dx - ancho * 0.45, c.dy + alto, c.dx - ancho / 2, c.dy - alto * 0.15)
      ..close();
    canvas.drawPath(boquita, Paint()..color = const Color(0xFF7A2E3A));
    canvas.save();
    canvas.clipPath(boquita);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(c.dx, c.dy + alto * 0.85), width: ancho * 0.7, height: alto * 0.9),
      Paint()..color = const Color(0xFFF07A8A),
    );
    canvas.drawRect(
      Rect.fromLTWH(c.dx - ancho / 2, c.dy - alto * 0.4, ancho, alto * 0.25),
      Paint()..color = Colors.white,
    );
    canvas.restore();
  }

  void _bigote(Canvas canvas) {
    final paint = Paint()..color = p.pelo;
    for (final lado in [-1, 1]) {
      canvas.drawOval(
        Rect.fromCenter(center: _o(0.5 + lado * 0.035, 0.57), width: _s * 0.085, height: _s * 0.04),
        paint,
      );
    }
  }

  void _gafas(Canvas canvas) {
    final paint = Paint()
      ..color = const Color(0xFF6B3E2E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = _s * 0.012;
    final r = _s * 0.072;
    canvas.drawCircle(_o(0.395, 0.47), r, paint);
    canvas.drawCircle(_o(0.605, 0.47), r, paint);
    canvas.drawLine(_o(0.395, 0.47) + Offset(r, 0), _o(0.605, 0.47) - Offset(r, 0), paint);
  }

  void _ganchos(Canvas canvas) {
    final colores = [const Color(0xFFF7A8C4), const Color(0xFFFFD86B)];
    final pos = [_o(0.33, 0.27), _o(0.37, 0.22)];
    for (var i = 0; i < 2; i++) {
      canvas.save();
      canvas.translate(pos[i].dx, pos[i].dy);
      canvas.rotate(-0.6);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: _s * 0.09, height: _s * 0.028),
          Radius.circular(_s * 0.014),
        ),
        Paint()..color = colores[i],
      );
      canvas.restore();
    }
    // Estrellita
    final c = _o(0.66, 0.22);
    final estrella = Path();
    for (var k = 0; k < 10; k++) {
      final r = k.isEven ? _s * 0.035 : _s * 0.015;
      final a = -math.pi / 2 + k * math.pi / 5;
      final pt = c + Offset(math.cos(a) * r, math.sin(a) * r);
      k == 0 ? estrella.moveTo(pt.dx, pt.dy) : estrella.lineTo(pt.dx, pt.dy);
    }
    canvas.drawPath(estrella..close(), Paint()..color = const Color(0xFFF7A8C4));
  }

  void _manoSaludando(Canvas canvas, double fase) {
    final hombro = _o(0.74, 0.86);
    final angulo = -1.15 + fase * 0.28;
    final largo = _s * 0.2;
    final mano = hombro + Offset(math.cos(angulo) * largo, math.sin(angulo) * largo);
    canvas.drawLine(
      hombro,
      mano,
      Paint()
        ..color = p.camisa
        ..strokeWidth = _s * 0.075
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(mano, _s * 0.05, Paint()..color = p.piel);
    // Deditos
    for (var k = -1; k <= 1; k++) {
      final a = angulo + k * 0.35;
      canvas.drawCircle(
        mano + Offset(math.cos(a) * _s * 0.05, math.sin(a) * _s * 0.05),
        _s * 0.018,
        Paint()..color = p.piel,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PersonajePainter old) => true;
}

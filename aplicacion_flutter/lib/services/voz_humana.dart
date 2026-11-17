import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lottie/lottie.dart';

class VozHumana {
  static final FlutterTts _tts = FlutterTts();
  static bool _configurado = false;
  static final ValueNotifier<bool> hablando = ValueNotifier<bool>(false);

  static Future<void> _inicializar() async {
    if (_configurado) return;

    try {
      final voces = await _tts.getVoices;
      if (voces is List) {
        Map<dynamic, dynamic>? mejorVoz;

        for (final v in voces) {
          if (v is Map) {
            final nombre = (v['name'] ?? '').toString().toLowerCase();
            final locale = (v['locale'] ?? '').toString().toLowerCase();

            if (locale.contains('es')) {
              if (nombre.contains('natural') ||
                  nombre.contains('neural') ||
                  nombre.contains('google') ||
                  nombre.contains('online') ||
                  nombre.contains('sabina') ||
                  nombre.contains('dalia') ||
                  nombre.contains('salome') ||
                  nombre.contains('gonzalo')) {
                mejorVoz = v;
                if (nombre.contains('natural') || nombre.contains('google')) {
                  break;
                }
              }
            }
          }
        }

        if (mejorVoz != null) {
          await _tts.setVoice({
            'name': mejorVoz['name'].toString(),
            'locale': mejorVoz['locale'].toString(),
          });
        } else {
          await _tts.setLanguage('es-MX');
        }
      } else {
        await _tts.setLanguage('es-MX');
      }
    } catch (_) {
      await _tts.setLanguage('es-MX');
    }

    // En navegador web 0.92 es velocidad natural humana; en Android 0.52 es fluida
    await _tts.setSpeechRate(kIsWeb ? 0.85 : 0.42);
    await _tts.setPitch(0.98);
    await _tts.setVolume(1.0);

    _tts.setStartHandler(() => hablando.value = true);
    _tts.setCompletionHandler(() => hablando.value = false);
    _tts.setCancelHandler(() => hablando.value = false);
    _tts.setErrorHandler((_) => hablando.value = false);

    _configurado = true;
  }

  static Future<void> hablar(String texto) async {
    await _inicializar();
    await _tts.stop();
    hablando.value = true;
    await _tts.speak(texto);
  }

  static Future<void> detener() async {
    await _tts.stop();
    hablando.value = false;
  }
}

class AvatarGuiaAnimado extends StatelessWidget {
  const AvatarGuiaAnimado({super.key, this.tamano = 150});

  final double tamano;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: tamano,
      height: tamano,
      child: Lottie.network(
        'https://assets9.lottiefiles.com/packages/lf20_puciaact.json',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return CustomPaint(
            size: Size(tamano, tamano),
            painter: _AbueloIlustradoPainter(),
          );
        },
      ),
    );
  }
}

class _AbueloIlustradoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final fondoPaint = Paint()..color = const Color(0xFFFFE5D4);
    canvas.drawCircle(Offset(w * 0.5, h * 0.5), w * 0.46, fondoPaint);

    final sueterPaint = Paint()..color = const Color(0xFF1E5E4B);
    canvas.drawArc(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.92), width: w * 0.72, height: h * 0.55),
      3.1416,
      3.1416,
      true,
      sueterPaint,
    );

    final pielPaint = Paint()..color = const Color(0xFFF6C39E);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(w * 0.5, h * 0.46), width: w * 0.46, height: h * 0.48),
        Radius.circular(w * 0.22),
      ),
      pielPaint,
    );

    final peloPaint = Paint()..color = const Color(0xFFECEAE6);
    canvas.drawArc(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.34), width: w * 0.50, height: h * 0.32),
      3.1416,
      3.1416,
      true,
      peloPaint,
    );

    final gafasPaint = Paint()
      ..color = const Color(0xFF3E2723)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2;

    canvas.drawCircle(Offset(w * 0.40, h * 0.45), w * 0.08, gafasPaint);
    canvas.drawCircle(Offset(w * 0.60, h * 0.45), w * 0.08, gafasPaint);
    canvas.drawLine(Offset(w * 0.48, h * 0.45), Offset(w * 0.52, h * 0.45), gafasPaint);

    final ojosPaint = Paint()..color = const Color(0xFF263238);
    canvas.drawCircle(Offset(w * 0.40, h * 0.45), w * 0.025, ojosPaint);
    canvas.drawCircle(Offset(w * 0.60, h * 0.45), w * 0.025, ojosPaint);

    final bigotePaint = Paint()..color = const Color(0xFFECEAE6);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(w * 0.5, h * 0.56), width: w * 0.24, height: h * 0.06),
        const Radius.circular(12),
      ),
      bigotePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
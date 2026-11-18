import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lottie/lottie.dart';

enum EstadoVoz { detenido, hablando, pausado }

/// Una voz instalada en el dispositivo/navegador.
class OpcionVoz {
  const OpcionVoz({required this.nombre, required this.locale});

  final String nombre;
  final String locale;

  static const Map<String, String> _paises = {
    'co': 'Colombia',
    'mx': 'México',
    'es': 'España',
    'us': 'Estados Unidos',
    'ar': 'Argentina',
    'cl': 'Chile',
    'pe': 'Perú',
    've': 'Venezuela',
    'ec': 'Ecuador',
    '419': 'Latinoamérica',
  };

  /// Nombre amable para mostrar: "Salome · Colombia".
  String get etiqueta {
    var limpio = nombre
        .replaceAll('Microsoft ', '')
        .replaceAll(RegExp(r'\s*Online\s*\(Natural\)', caseSensitive: false), '')
        .replaceAll(RegExp(r'\s*-\s*Spanish.*$', caseSensitive: false), '')
        .replaceAll('Google ', '')
        .trim();
    if (limpio.isEmpty) limpio = nombre;
    final partes = locale.toLowerCase().split(RegExp('[-_]'));
    final pais = partes.length > 1 ? _paises[partes[1]] : null;
    return pais == null ? limpio : '$limpio · $pais';
  }

  bool get esNatural {
    final n = nombre.toLowerCase();
    return n.contains('natural') || n.contains('neural') || n.contains('online');
  }

  @override
  bool operator ==(Object other) =>
      other is OpcionVoz && other.nombre == nombre && other.locale == locale;

  @override
  int get hashCode => Object.hash(nombre, locale);
}

/// Estilo de narración: cambia tono y velocidad. Sirve incluso cuando el
/// celular solo trae una voz en español instalada.
class EstiloVoz {
  const EstiloVoz(this.nombre, this.descripcion, this.icono, this.tono, this.ritmo);

  final String nombre;
  final String descripcion;
  final IconData icono;
  final double tono;
  final double ritmo;

  static const List<EstiloVoz> todos = [
    EstiloVoz('Calmada', 'Despacio y grave, como la abuela', Icons.spa_rounded, 0.85, 0.85),
    EstiloVoz('Natural', 'Como una conversación normal', Icons.record_voice_over_rounded, 1.0, 1.0),
    EstiloVoz('Alegre', 'Más aguda y animada', Icons.celebration_rounded, 1.25, 1.08),
  ];
}

/// Motor de voz único para toda la app: elegir voz, pausar, reanudar y detener.
class VozHumana {
  static final FlutterTts _tts = FlutterTts();
  static Future<void>? _inicializando;

  /// Compatibilidad con el código anterior.
  static final ValueNotifier<bool> hablando = ValueNotifier<bool>(false);

  static final ValueNotifier<EstadoVoz> estado =
      ValueNotifier<EstadoVoz>(EstadoVoz.detenido);
  static final ValueNotifier<List<OpcionVoz>> voces =
      ValueNotifier<List<OpcionVoz>>(const []);
  static final ValueNotifier<OpcionVoz?> vozActual = ValueNotifier<OpcionVoz?>(null);
  static final ValueNotifier<EstiloVoz> estilo =
      ValueNotifier<EstiloVoz>(EstiloVoz.todos[1]);

  /// Si está apagada, la app no narra sola (solo cuando tocas "escuchar").
  static final ValueNotifier<bool> narracionAutomatica = ValueNotifier<bool>(true);

  static final ValueNotifier<String> textoActual = ValueNotifier<String>('');

  /// Aumenta cada vez que la voz empieza una palabra (para mover la boca).
  static final ValueNotifier<int> palabra = ValueNotifier<int>(0);

  /// Letra del texto actual por la que va leyendo (para cambiar de escena).
  static final ValueNotifier<int> posicion = ValueNotifier<int>(0);

  static const _nombresFemeninos = [
    'sabina', 'dalia', 'salome', 'salomé', 'helena', 'elena', 'paloma', 'elvira',
    'paulina', 'monica', 'mónica', 'laura', 'ximena', 'catalina', 'camila',
    'lupe', 'francisca', 'isabel', 'marisol', 'renata', 'beatriz', 'carlota',
    'larissa', 'valentina', 'abril', 'estrella', 'irene', 'lucia', 'lucía',
    'female', 'mujer',
  ];

  static const _nombresMasculinos = [
    'raul', 'raúl', 'jorge', 'pablo', 'gonzalo', 'alvaro', 'álvaro', 'diego',
    'gerardo', 'emilio', 'tomas', 'tomás', 'alonso', 'carlos', 'andres', 'andrés',
    'jose', 'josé', 'juan', 'lorenzo', 'federico', 'mateo', 'arnau', 'dario',
    'darío', 'male', 'hombre',
  ];

  static bool _coincide(OpcionVoz v, List<String> nombres) {
    final n = v.nombre.toLowerCase();
    return nombres.any(n.contains);
  }

  /// Cambia la voz para que suene como el personaje: busca una voz
  /// femenina o masculina y ajusta el tono (más agudo para niños).
  static Future<void> usarPersonaje({
    required bool femenina,
    required double tono,
    required double ritmo,
  }) async {
    await _inicializar();
    final lista = voces.value;
    final candidatas =
        lista.where((v) => _coincide(v, femenina ? _nombresFemeninos : _nombresMasculinos)).toList();
    if (candidatas.isNotEmpty) {
      candidatas.sort((a, b) => (a.esNatural ? 0 : 1).compareTo(b.esNatural ? 0 : 1));
      await _aplicarVoz(candidatas.first);
    }
    estilo.value = EstiloVoz('Personaje', '', Icons.face_rounded, tono, ritmo);
    await _aplicarEstilo();
  }

  static double get _ritmoBase => kIsWeb ? 0.85 : 0.42;

  static void _cambiarEstado(EstadoVoz nuevo) {
    estado.value = nuevo;
    hablando.value = nuevo == EstadoVoz.hablando;
  }

  static Future<void> _inicializar() => _inicializando ??= _configurar();

  static Future<void> _configurar() async {
    await cargarVoces();

    final elegida = _mejorVozPorDefecto();
    if (elegida != null) {
      await _aplicarVoz(elegida);
    } else {
      await _tts.setLanguage('es-CO');
    }

    await _aplicarEstilo();
    await _tts.setVolume(1.0);

    _tts.setStartHandler(() => _cambiarEstado(EstadoVoz.hablando));
    _tts.setContinueHandler(() => _cambiarEstado(EstadoVoz.hablando));
    _tts.setPauseHandler(() => _cambiarEstado(EstadoVoz.pausado));
    _tts.setCompletionHandler(() => _cambiarEstado(EstadoVoz.detenido));
    _tts.setCancelHandler(() {
      if (estado.value != EstadoVoz.pausado) _cambiarEstado(EstadoVoz.detenido);
    });
    _tts.setErrorHandler((_) => _cambiarEstado(EstadoVoz.detenido));
    _tts.setProgressHandler((texto, inicio, fin, palabraActual) {
      posicion.value = inicio;
      palabra.value++;
    });
  }

  /// Lee las voces en español disponibles. En el navegador llegan con retraso,
  /// por eso se reintenta unas cuantas veces.
  static Future<void> cargarVoces() async {
    for (var intento = 0; intento < 6; intento++) {
      try {
        final crudas = await _tts.getVoices;
        if (crudas is List && crudas.isNotEmpty) {
          final lista = <OpcionVoz>[];
          for (final v in crudas) {
            if (v is! Map) continue;
            final locale = (v['locale'] ?? '').toString();
            final nombre = (v['name'] ?? '').toString();
            if (!locale.toLowerCase().startsWith('es') || nombre.isEmpty) continue;
            final opcion = OpcionVoz(nombre: nombre, locale: locale);
            if (!lista.contains(opcion)) lista.add(opcion);
          }
          lista.sort((a, b) {
            int puntaje(OpcionVoz o) =>
                (o.locale.toLowerCase().contains('co') ? 0 : 2) + (o.esNatural ? 0 : 1);
            final c = puntaje(a).compareTo(puntaje(b));
            return c != 0 ? c : a.etiqueta.compareTo(b.etiqueta);
          });
          voces.value = lista;
          return;
        }
      } catch (_) {
        // Algunos dispositivos no exponen la lista; seguimos con la voz por defecto.
      }
      await Future<void>.delayed(const Duration(milliseconds: 300));
    }
  }

  static OpcionVoz? _mejorVozPorDefecto() {
    final lista = voces.value;
    if (lista.isEmpty) return null;
    for (final v in lista) {
      if (v.esNatural) return v;
    }
    return lista.first;
  }

  static Future<void> _aplicarVoz(OpcionVoz voz) async {
    await _tts.setVoice({'name': voz.nombre, 'locale': voz.locale});
    vozActual.value = voz;
  }

  static Future<void> _aplicarEstilo() async {
    await _tts.setSpeechRate(_ritmoBase * estilo.value.ritmo);
    await _tts.setPitch(estilo.value.tono);
  }

  static Future<void> elegirVoz(OpcionVoz voz) async {
    await _inicializar();
    await _aplicarVoz(voz);
  }

  static Future<void> elegirEstilo(EstiloVoz nuevo) async {
    await _inicializar();
    estilo.value = nuevo;
    await _aplicarEstilo();
  }

  /// Habla siempre (cuando la persona lo pidió con un botón).
  static Future<void> hablar(String texto) async {
    await _inicializar();
    await _tts.stop();
    textoActual.value = texto;
    posicion.value = 0;
    _cambiarEstado(EstadoVoz.hablando);
    await _tts.speak(texto);
  }

  /// Narración que la app inicia sola: respeta el interruptor de narración.
  static Future<void> narrar(String texto) async {
    if (!narracionAutomatica.value) {
      textoActual.value = texto;
      return;
    }
    await hablar(texto);
  }

  static Future<void> pausar() async {
    if (estado.value != EstadoVoz.hablando) return;
    await _tts.pause();
    _cambiarEstado(EstadoVoz.pausado);
  }

  static Future<void> reanudar() async {
    if (estado.value != EstadoVoz.pausado) return;
    // En el navegador continúa donde iba; en el celular vuelve a leer el texto.
    _cambiarEstado(EstadoVoz.hablando);
    await _tts.speak(textoActual.value);
  }

  /// Botón único de reproducir / pausar.
  static Future<void> alternar() async {
    switch (estado.value) {
      case EstadoVoz.hablando:
        await pausar();
      case EstadoVoz.pausado:
        await reanudar();
      case EstadoVoz.detenido:
        if (textoActual.value.isNotEmpty) await hablar(textoActual.value);
    }
  }

  static Future<void> detener() async {
    await _tts.stop();
    _cambiarEstado(EstadoVoz.detenido);
  }

  /// Reemplazo de `FlutterTts` para pantallas que tenían su propio motor:
  /// así todas usan la voz elegida y el mismo botón de pausa.
  static AdaptadorVoz adaptador() => AdaptadorVoz._();
}

class AdaptadorVoz {
  AdaptadorVoz._() {
    VozHumana.estado.addListener(_escuchar);
  }

  VoidCallback? _alIniciar;
  VoidCallback? _alTerminar;
  EstadoVoz _anterior = VozHumana.estado.value;

  void _escuchar() {
    final ahora = VozHumana.estado.value;
    if (ahora == _anterior) return;
    _anterior = ahora;
    if (ahora == EstadoVoz.hablando) {
      _alIniciar?.call();
    } else if (ahora == EstadoVoz.detenido) {
      _alTerminar?.call();
    }
  }

  Future<void> setLanguage(String _) async {}
  Future<void> setSpeechRate(double _) async {}
  Future<void> setPitch(double _) async {}
  void setStartHandler(VoidCallback c) => _alIniciar = c;
  void setCompletionHandler(VoidCallback c) => _alTerminar = c;
  void setCancelHandler(VoidCallback c) => _alTerminar = c;
  Future<void> speak(String texto) => VozHumana.hablar(texto);
  Future<void> narrar(String texto) => VozHumana.narrar(texto);
  Future<void> stop() => VozHumana.detener();
  void dispose() => VozHumana.estado.removeListener(_escuchar);
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

    final fondoPaint = Paint()..color = const Color(0xFFFCEFC7);
    canvas.drawCircle(Offset(w * 0.5, h * 0.5), w * 0.46, fondoPaint);

    final sueterPaint = Paint()..color = const Color(0xFF008F95);
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
      ..color = const Color(0xFF3B2A3F)
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

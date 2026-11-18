import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/paleta.dart';

/// Fondo de pantalla completo del Inicio, como el fondo de un celular.
///
/// Usa las imágenes de `assets/fondos/` en orden alfabético. Cada una se
/// queda quieta 4 segundos (con un acercamiento muy lento) y luego se
/// funde despacio con la siguiente.
class FondoInicio extends StatefulWidget {
  const FondoInicio({super.key});

  static const Duration pausa = Duration(seconds: 4);
  static const Duration fundido = Duration(milliseconds: 2200);

  @override
  State<FondoInicio> createState() => _FondoInicioState();
}

class _FondoInicioState extends State<FondoInicio> {
  List<String> _imagenes = const [];
  int _actual = 0;
  Timer? _temporizador;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    try {
      final manifiesto = await AssetManifest.loadFromAssetBundle(rootBundle);
      final lista =
          manifiesto
              .listAssets()
              .where((a) => a.startsWith('assets/fondos/'))
              .where(
                (a) => RegExp(
                  r'\.(png|jpe?g|webp)$',
                  caseSensitive: false,
                ).hasMatch(a),
              )
              .toList()
            ..sort();
      if (!mounted || lista.isEmpty) return;
      setState(() => _imagenes = lista);
      if (lista.length > 1) {
        _temporizador = Timer.periodic(
          FondoInicio.pausa + FondoInicio.fundido,
          (_) => _siguiente(),
        );
      }
    } catch (_) {
      // Sin imágenes: queda el color crema.
    }
  }

  void _siguiente() {
    if (!mounted) return;
    final proxima = (_actual + 1) % _imagenes.length;
    // Se carga antes para que el cambio no parpadee.
    precacheImage(
      AssetImage(_imagenes[(proxima + 1) % _imagenes.length]),
      context,
    );
    setState(() => _actual = proxima);
  }

  @override
  void dispose() {
    _temporizador?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_imagenes.isEmpty) return const ColoredBox(color: Paleta.crema);
    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedSwitcher(
          duration: FondoInicio.fundido,
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          layoutBuilder: (actual, anteriores) =>
              Stack(fit: StackFit.expand, children: [...anteriores, ?actual]),
          child: _ImagenLenta(key: ValueKey(_actual), ruta: _imagenes[_actual]),
        ),
        // Velo suave: arriba y abajo un poco más claro para que todo se lea.
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0x40FFF8EF),
                Color(0x00FFF8EF),
                Color(0x00FFF8EF),
                Color(0x30FFF8EF),
              ],
              stops: [0, 0.22, 0.7, 1],
            ),
          ),
        ),
      ],
    );
  }
}

class _ImagenLenta extends StatelessWidget {
  const _ImagenLenta({super.key, required this.ruta});

  final String ruta;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: 1.07),
      duration: FondoInicio.pausa + FondoInicio.fundido * 2,
      curve: Curves.easeOut,
      builder: (context, escala, child) =>
          Transform.scale(scale: escala, child: child),
      child: Image.asset(
        ruta,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        gaplessPlayback: true,
        errorBuilder: (_, _, _) => const ColoredBox(color: Paleta.crema),
      ),
    );
  }
}

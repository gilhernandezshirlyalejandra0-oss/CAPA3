import 'package:flutter/material.dart';

import '../theme/paleta.dart';

/// Tamaño de letra de toda la app (se aplica en main.dart con MediaQuery).
class TamanoLetra {
  TamanoLetra._();

  static const double minimo = 0.85;
  static const double maximo = 1.45;
  static const double paso = 0.15;

  static final ValueNotifier<double> escala = ValueNotifier<double>(1.0);

  static bool get puedeAumentar => escala.value < maximo - 0.01;
  static bool get puedeDisminuir => escala.value > minimo + 0.01;

  static void aumentar() {
    if (puedeAumentar) {
      escala.value = (escala.value + paso).clamp(minimo, maximo);
    }
  }

  static void disminuir() {
    if (puedeDisminuir) {
      escala.value = (escala.value - paso).clamp(minimo, maximo);
    }
  }
}

/// Dos botones grandes: "A-" y "A+".
class ControlLetra extends StatelessWidget {
  const ControlLetra({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: TamanoLetra.escala,
      builder: (context, _, _) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Paleta.ciruela, width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _BotonLetra(
              texto: 'A',
              tamano: 15,
              signo: '−',
              tooltip: 'Letra más pequeña',
              activo: TamanoLetra.puedeDisminuir,
              onTap: TamanoLetra.disminuir,
            ),
            Container(width: 2, height: 26, color: Paleta.arena),
            _BotonLetra(
              texto: 'A',
              tamano: 21,
              signo: '+',
              tooltip: 'Letra más grande',
              activo: TamanoLetra.puedeAumentar,
              onTap: TamanoLetra.aumentar,
            ),
          ],
        ),
      ),
    );
  }
}

class _BotonLetra extends StatelessWidget {
  const _BotonLetra({
    required this.texto,
    required this.tamano,
    required this.signo,
    required this.tooltip,
    required this.activo,
    required this.onTap,
  });

  final String texto;
  final double tamano;
  final String signo;
  final String tooltip;
  final bool activo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = activo
        ? Paleta.ciruela
        : Paleta.ciruela.withValues(alpha: 0.3);
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        label: tooltip,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: activo ? onTap : null,
          child: SizedBox(
            width: 52,
            height: 44,
            child: Center(
              // La letra del botón no crece con la escala, para que siempre quepa.
              child: MediaQuery.withNoTextScaling(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: texto,
                        style: Letras.titulo(size: tamano, color: color),
                      ),
                      TextSpan(
                        text: signo,
                        style: Letras.titulo(size: 15, color: color),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

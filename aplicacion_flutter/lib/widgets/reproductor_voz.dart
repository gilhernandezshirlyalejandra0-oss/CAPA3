import 'package:flutter/material.dart';

import '../services/asistente.dart';
import '../services/voz_humana.dart';
import '../theme/paleta.dart';
import 'avatar_parlante.dart';

/// Barrita que aparece cuando la app está hablando: pausar, continuar,
/// detener y elegir la voz.
class ReproductorVoz extends StatelessWidget {
  const ReproductorVoz({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<EstadoVoz>(
      valueListenable: VozHumana.estado,
      builder: (context, estado, _) {
        final visible = estado != EstadoVoz.detenido;
        return AnimatedSize(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutBack,
          child: !visible
              ? const SizedBox(width: double.infinity)
              : Container(
                  margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                  padding: const EdgeInsets.fromLTRB(8, 6, 6, 6),
                  decoration: BoxDecoration(
                    color: Paleta.ciruela,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      _BotonRedondo(
                        icono: estado == EstadoVoz.hablando
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: Paleta.mostaza,
                        tooltip: estado == EstadoVoz.hablando ? 'Pausar' : 'Continuar',
                        onTap: VozHumana.alternar,
                      ),
                      const SizedBox(width: 8),
                      ValueListenableBuilder<Personaje>(
                        valueListenable: Asistente.actual,
                        builder: (context, p, _) => Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(color: p.fondo, shape: BoxShape.circle),
                          child: AvatarParlante(personaje: p, tamano: 48),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              estado == EstadoVoz.hablando ? 'Escuchando…' : 'En pausa',
                              style: Letras.titulo(size: 16, color: Colors.white),
                            ),
                            ValueListenableBuilder<EstiloVoz>(
                              valueListenable: VozHumana.estilo,
                              builder: (context, estilo, _) => Text(
                                'Voz ${estilo.nombre.toLowerCase()} · cámbiala aquí →',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white70, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _BotonRedondo(
                        icono: Icons.tune_rounded,
                        color: Paleta.aqua,
                        tooltip: 'Elegir voz',
                        onTap: () => mostrarSelectorVoz(context),
                      ),
                      const SizedBox(width: 6),
                      _BotonRedondo(
                        icono: Icons.stop_rounded,
                        color: Paleta.papaya,
                        tooltip: 'Detener',
                        onTap: VozHumana.detener,
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

class _BotonRedondo extends StatelessWidget {
  const _BotonRedondo({
    required this.icono,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icono;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: color,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(icono, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }
}

/// Botón de "ajustes de voz" para poner en las barras superiores.
class BotonAjustesVoz extends StatelessWidget {
  const BotonAjustesVoz({super.key, this.color = Paleta.tinta});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Elegir voz',
      icon: Icon(Icons.record_voice_over_rounded, color: color, size: 28),
      onPressed: () => mostrarSelectorVoz(context),
    );
  }
}

Future<void> mostrarSelectorVoz(BuildContext context) async {
  await VozHumana.cargarVoces();
  if (!context.mounted) return;
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Paleta.crema,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) => const _SelectorVoz(),
  );
}

class _SelectorVoz extends StatelessWidget {
  const _SelectorVoz();

  static const String _muestra =
      'Hola, así sueno yo. Recuerda: nunca compartas tus claves por mensaje.';

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.92,
      builder: (context, scroll) => ListView(
        controller: scroll,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        children: [
          Center(
            child: Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: Paleta.arena,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('¿Con qué voz quieres escuchar?', style: Letras.titulo(size: 24)),
          const SizedBox(height: 6),
          const Text(
            'Toca una opción y escucharás cómo suena.',
            style: TextStyle(fontSize: 16, color: Paleta.tintaSuave),
          ),
          const SizedBox(height: 18),
          Text('Estilo', style: Letras.titulo(size: 18, color: Paleta.papaya)),
          const SizedBox(height: 8),
          ValueListenableBuilder<EstiloVoz>(
            valueListenable: VozHumana.estilo,
            builder: (context, actual, _) => Row(
              children: [
                for (var i = 0; i < EstiloVoz.todos.length; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  Expanded(
                    child: _TarjetaEstilo(
                      estilo: EstiloVoz.todos[i],
                      color: Paleta.vivos[i],
                      elegido: actual.nombre == EstiloVoz.todos[i].nombre,
                      onTap: () async {
                        await VozHumana.elegirEstilo(EstiloVoz.todos[i]);
                        await VozHumana.hablar(_muestra);
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 22),
          Text('Narrador', style: Letras.titulo(size: 18, color: Paleta.aqua)),
          const SizedBox(height: 8),
          ValueListenableBuilder<List<OpcionVoz>>(
            valueListenable: VozHumana.voces,
            builder: (context, voces, _) {
              if (voces.isEmpty) {
                return const Text(
                  'Este dispositivo solo tiene una voz en español. '
                  'Puedes cambiar el estilo arriba.',
                  style: TextStyle(fontSize: 16),
                );
              }
              return ValueListenableBuilder<OpcionVoz?>(
                valueListenable: VozHumana.vozActual,
                builder: (context, actual, _) => Column(
                  children: [
                    for (final v in voces)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Material(
                          color: v == actual ? Paleta.aquaSuave : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: v == actual ? Paleta.aqua : Paleta.arena,
                                width: 2,
                              ),
                            ),
                            leading: Icon(
                              v == actual
                                  ? Icons.check_circle_rounded
                                  : Icons.person_rounded,
                              color: v == actual ? Paleta.aqua : Paleta.tintaSuave,
                            ),
                            title: Text(
                              v.etiqueta,
                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                            ),
                            subtitle: v.esNatural ? const Text('Voz natural') : null,
                            trailing: const Icon(Icons.play_circle_fill_rounded,
                                color: Paleta.mostaza, size: 30),
                            onTap: () async {
                              await VozHumana.elegirVoz(v);
                              await VozHumana.hablar(_muestra);
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 14),
          ValueListenableBuilder<bool>(
            valueListenable: VozHumana.narracionAutomatica,
            builder: (context, activa, _) => SwitchListTile(
              value: activa,
              activeThumbColor: Paleta.papaya,
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Leer en voz alta automáticamente',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
              ),
              subtitle: const Text(
                'Si lo apagas, solo hablará cuando toques el botón de escuchar.',
              ),
              onChanged: (v) {
                VozHumana.narracionAutomatica.value = v;
                if (!v) VozHumana.detener();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaEstilo extends StatelessWidget {
  const _TarjetaEstilo({
    required this.estilo,
    required this.color,
    required this.elegido,
    required this.onTap,
  });

  final EstiloVoz estilo;
  final Color color;
  final bool elegido;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: elegido ? 1.04 : 1,
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: elegido ? color : Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: elegido ? Paleta.ciruela : Paleta.arena, width: 2),
            ),
            child: Column(
              children: [
                Icon(estilo.icono, color: elegido ? Colors.white : color, size: 30),
                const SizedBox(height: 6),
                Text(
                  estilo.nombre,
                  style: Letras.titulo(
                    size: 16,
                    color: elegido ? Colors.white : Paleta.tinta,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  estilo.descripcion,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: elegido ? Colors.white : Paleta.tintaSuave,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

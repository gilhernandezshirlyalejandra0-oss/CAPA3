import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'models/alerta_seguridad.dart';
import 'screens/alertas_screen.dart';
import 'screens/aprende_phishing_screen.dart';
import 'screens/consejos_seguridad_screen.dart';
import 'screens/cuentos_screen.dart';
import 'screens/cuestionario_screen.dart';
import 'screens/inicio_screen.dart';
import 'services/tamano_letra.dart';
import 'widgets/fondo_inicio.dart';
import 'services/voz_humana.dart';
import 'theme/paleta.dart';
import 'screens/bienvenida_screen.dart';
import 'screens/intro_screen.dart';
import 'widgets/reproductor_voz.dart';

const Color colorPapel = Paleta.crema;
const Color colorTinta = Paleta.tinta;
const Color colorBosque = Paleta.aqua;
const Color colorArcilla = Paleta.papaya;
const Color colorArena = Paleta.arena;

final GoRouter _router = GoRouter(
  initialLocation: '/bienvenida',
  routes: [
    GoRoute(
      path: '/bienvenida',
      builder: (context, state) => const BienvenidaScreen(),
    ),
    GoRoute(
      path: '/intro',
      builder: (context, state) => const IntroPersonajesScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const ContenedorCuatroPantallas(),
    ),
    GoRoute(
      path: '/alertas/:id',
      builder: (context, state) {
        final alerta = state.extra as AlertaSeguridad;
        return DetalleAlertaScreen(alerta: alerta);
      },
    ),
  ],
);

void main() {
  runApp(const EscudoMayorApp());
}

class EscudoMayorApp extends StatelessWidget {
  const EscudoMayorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Escudo Mayor',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: Letras.familiaCuerpo,
        scaffoldBackgroundColor: colorPapel,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Paleta.aqua,
          primary: Paleta.aqua,
          secondary: Paleta.papaya,
          tertiary: Paleta.mostaza,
          surface: colorPapel,
        ),
        appBarTheme: AppBarTheme(titleTextStyle: Letras.titulo(size: 22)),
      ),
      builder: (context, hijo) {
        // Aplica el tamaño de letra elegido con los botones A− / A+.
        final child = ValueListenableBuilder<double>(
          valueListenable: TamanoLetra.escala,
          builder: (context, escala, _) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(escala)),
            child: hijo!,
          ),
        );
        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 520) {
              // En computador se muestra dentro de un "celular".
              return Container(
                color: Paleta.ciruela,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Container(
                  width: 412,
                  height: math.min(860, constraints.maxHeight - 32),
                  decoration: BoxDecoration(
                    color: colorPapel,
                    borderRadius: BorderRadius.circular(38),
                    border: Border.all(color: Paleta.tinta, width: 8),
                    boxShadow: const [
                      BoxShadow(color: Paleta.papaya, offset: Offset(14, 14)),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: child,
                ),
              );
            }
            return child;
          },
        );
      },
    );
  }
}

class ContenedorCuatroPantallas extends StatefulWidget {
  const ContenedorCuatroPantallas({super.key});

  @override
  State<ContenedorCuatroPantallas> createState() =>
      _ContenedorCuatroPantallasState();
}

class _ContenedorCuatroPantallasState extends State<ContenedorCuatroPantallas> {
  /// -1 es la página de Inicio; 0 a 4 son las secciones de la barra de abajo.
  int _indiceActual = -1;

  late final List<Widget> _pantallas = [
    InicioScreen(onAbrir: _cambiarPantalla),
    const AprendePhishingScreen(),
    const AlertasScreen(),
    const CuentosScreen(),
    const ConsejosSeguridadScreen(),
    const CuestionarioScreen(),
  ];

  void _volverAlInicio() {
    if (_indiceActual == -1) return;
    setState(() => _indiceActual = -1);
    VozHumana.narrar('Estás en el inicio. Elige qué quieres hacer.');
  }

  static const List<_Destino> _destinos = [
    _Destino('Historias', Icons.auto_stories_rounded, Paleta.papaya),
    _Destino('Chats', Icons.mark_chat_unread_rounded, Paleta.aqua),
    _Destino('Cuentos', Icons.theater_comedy_rounded, Paleta.rubor),
    _Destino('Claves', Icons.key_rounded, Paleta.mostaza),
    _Destino('Juego', Icons.extension_rounded, Paleta.papaya),
  ];

  void _cambiarPantalla(int index) {
    if (index == _indiceActual) return;
    setState(() => _indiceActual = index);
    const saludos = [
      'Historias reales. Desliza para escuchar cómo engañan por teléfono.',
      'Buzón de mensajes falsos. Toca un chat para abrirlo.',
      'Cuentos que enseñan. Escucha anécdotas de estafas y el chisme informativo del barrio.',
      'Seis costumbres seguras para tu día a día.',
      'Juego de práctica. ¿Qué responderías tú en estos casos?',
    ];
    VozHumana.narrar(saludos[index]);
  }

  @override
  Widget build(BuildContext context) {
    final enInicio = _indiceActual == -1;
    return PopScope(
      // El botón "atrás" del celular lleva al Inicio antes de salir.
      canPop: enInicio,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _volverAlInicio();
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Fondo de pantalla completo, solo en el Inicio.
            Positioned.fill(
              child: AnimatedOpacity(
                opacity: enInicio ? 1 : 0,
                duration: const Duration(milliseconds: 400),
                child: const FondoInicio(),
              ),
            ),
            Column(
              children: [
                _FranjaSuperior(enInicio: enInicio, onInicio: _volverAlInicio),
                Expanded(
                  // La franja de arriba ya respeta la barra de estado del celular.
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: IndexedStack(
                      index: _indiceActual + 1,
                      children: _pantallas,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MediaQuery.withNoTextScaling(child: const ReproductorVoz()),
            // La barra de abajo mantiene su tamaño para que nunca se corte.
            MediaQuery.withNoTextScaling(
              child: Container(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Paleta.ciruela, width: 3),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      for (var i = 0; i < _destinos.length; i++)
                        Expanded(
                          child: _BotonNavegacion(
                            destino: _destinos[i],
                            activo: i == _indiceActual,
                            onTap: () => _cambiarPantalla(i),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Franja de arriba: botón para volver al Inicio y controles de letra.
class _FranjaSuperior extends StatelessWidget {
  const _FranjaSuperior({required this.enInicio, required this.onInicio});

  final bool enInicio;
  final VoidCallback onInicio;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: enInicio ? Colors.transparent : colorPapel,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
          child: Row(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: enInicio
                    ? MediaQuery.withNoTextScaling(
                        key: const ValueKey('logo'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Paleta.aqua,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            'ESCUDO MAYOR',
                            style: Letras.titulo(
                              size: 17,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      )
                    : Semantics(
                        key: const ValueKey('volver'),
                        button: true,
                        label: 'Volver al inicio',
                        child: Material(
                          color: Paleta.mostaza,
                          borderRadius: BorderRadius.circular(30),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: onInicio,
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(10, 7, 16, 7),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: Paleta.ciruela,
                                  width: 2,
                                ),
                              ),
                              child: MediaQuery.withNoTextScaling(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.arrow_back_rounded,
                                      color: Paleta.tinta,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.home_rounded,
                                      color: Paleta.tinta,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Inicio',
                                      style: Letras.titulo(
                                        size: 18,
                                        color: Paleta.tinta,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
              const Spacer(),
              const ControlLetra(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Destino {
  const _Destino(this.etiqueta, this.icono, this.color);

  final String etiqueta;
  final IconData icono;
  final Color color;
}

class _BotonNavegacion extends StatelessWidget {
  const _BotonNavegacion({
    required this.destino,
    required this.activo,
    required this.onTap,
  });

  final _Destino destino;
  final bool activo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorIcono = activo
        ? (destino.color == Paleta.mostaza ? Paleta.tinta : Colors.white)
        : Paleta.tintaSuave;
    return Semantics(
      button: true,
      selected: activo,
      label: destino.etiqueta,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutBack,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              transform: Matrix4.translationValues(0, activo ? -4 : 0, 0),
              decoration: BoxDecoration(
                color: activo ? destino.color : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: activo ? Paleta.ciruela : Colors.transparent,
                  width: 2,
                ),
              ),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: activo ? 1 : 0),
                duration: const Duration(milliseconds: 400),
                builder: (context, v, child) => Transform.rotate(
                  angle: math.sin(v * math.pi) * 0.25,
                  child: child,
                ),
                child: Icon(destino.icono, color: colorIcono, size: 26),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              destino.etiqueta,
              style: TextStyle(
                fontSize: 13,
                fontWeight: activo ? FontWeight.w900 : FontWeight.w700,
                color: activo ? Paleta.tinta : Paleta.tintaSuave,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

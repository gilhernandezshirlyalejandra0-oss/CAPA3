import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'models/alerta_seguridad.dart';
import 'screens/alertas_screen.dart';
import 'screens/aprende_phishing_screen.dart';
import 'screens/consejos_seguridad_screen.dart';
import 'screens/cuestionario_screen.dart';
import 'services/voz_humana.dart';

const Color colorPapel = Color(0xFFF6F2EA);
const Color colorTinta = Color(0xFF1F2421);
const Color colorBosque = Color(0xFF1B5E49);
const Color colorArcilla = Color(0xFFC85A32);
const Color colorArena = Color(0xFFEBE4D6);

final GoRouter _router = GoRouter(
  initialLocation: '/intro',
  routes: [
    GoRoute(
      path: '/intro',
      builder: (context, state) => const IntroBienvenidaScreen(),
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
        scaffoldBackgroundColor: colorPapel,
        colorScheme: ColorScheme.fromSeed(
          seedColor: colorBosque,
          primary: colorBosque,
          secondary: colorArcilla,
          surface: colorPapel,
        ),
      ),
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 520) {
              return Container(
                color: const Color(0xFF222826),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Container(
                  width: 412,
                  height: 860,
                  decoration: BoxDecoration(
                    color: colorPapel,
                    borderRadius: BorderRadius.circular(38),
                    border: Border.all(color: const Color(0xFF3A423F), width: 8),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black45,
                        blurRadius: 35,
                        offset: Offset(0, 18),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: child,
                ),
              );
            }
            return child!;
          },
        );
      },
    );
  }
}

class IntroBienvenidaScreen extends StatefulWidget {
  const IntroBienvenidaScreen({super.key});

  @override
  State<IntroBienvenidaScreen> createState() => _IntroBienvenidaScreenState();
}

class _IntroBienvenidaScreenState extends State<IntroBienvenidaScreen>
    with SingleTickerProviderStateMixin {
  double _opacidadLogo = 0.0;
  double _opacidadPersonaje = 0.0;

  @override
  void initState() {
    super.initState();
    _iniciarEntrada();
  }

  Future<void> _iniciarEntrada() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;
    setState(() => _opacidadLogo = 1.0);

    await Future<void>.delayed(const Duration(milliseconds: 1100));
    if (!mounted) return;
    setState(() => _opacidadPersonaje = 1.0);

    VozHumana.hablar(
      '¡Hola! Qué bueno verte por aquí. Soy prudencio, y hoy te voy a enseñar varios trucos sencillos para que nadie te engañe por el celular. Toca el botón de abajo para empezar.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPapel,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedOpacity(
                opacity: _opacidadLogo,
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeOut,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: colorBosque,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Text(
                        'ESCUDO MAYOR',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              AnimatedOpacity(
                opacity: _opacidadPersonaje,
                duration: const Duration(milliseconds: 800),
                child: Column(
                  children: [
                    const AvatarGuiaAnimado(tamano: 190),
                    const SizedBox(height: 16),
                    const Text(
                      'Tu plata y tu WhatsApp bien cuidados',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: colorTinta,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(22),
                          bottomLeft: Radius.circular(22),
                          bottomRight: Radius.circular(22),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Text(
                        '“Aquí no hablamos con palabras raras. Te muestro los mensajes falsos tal como llegan al celular y te los leo en voz alta.”',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          height: 1.4,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF3D4441),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              AnimatedOpacity(
                opacity: _opacidadPersonaje,
                duration: const Duration(milliseconds: 800),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: FilledButton(
                        onPressed: () {
                          VozHumana.detener();
                          context.go('/');
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: colorArcilla,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text(
                          'Comenzar recorrido',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton.icon(
                      onPressed: () => VozHumana.hablar(
                        '¡Hola! Toca el botón naranja que dice Comenzar recorrido para ver los mensajes de ejemplo.',
                      ),
                      icon: const Icon(Icons.volume_up_rounded, color: colorBosque),
                      label: const Text(
                        'Probar sonido de voz',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: colorBosque,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
  int _indiceActual = 0;

  final List<Widget> _pantallas = const [
    AprendePhishingScreen(),
    AlertasScreen(),
    ConsejosSeguridadScreen(),
    CuestionarioScreen(),
  ];

  void _cambiarPantalla(int index) {
    setState(() => _indiceActual = index);
    const saludos = [
      'Historias reales. Desliza para escuchar cómo engañan por teléfono.',
      'Buzón de mensajes falsos. Toca un chat para abrirlo.',
      'Seis costumbres seguras para tu día a día.',
      'Juego de práctica. ¿Qué responderías tú en estos casos?',
    ];
    VozHumana.hablar(saludos[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _indiceActual,
        children: _pantallas,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: colorArena, width: 1.5)),
        ),
        child: NavigationBar(
          height: 68,
          backgroundColor: Colors.white,
          elevation: 0,
          indicatorColor: const Color(0xFFDCECE5),
          selectedIndex: _indiceActual,
          onDestinationSelected: _cambiarPantalla,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.auto_stories_outlined),
              selectedIcon: Icon(Icons.auto_stories_rounded, color: colorBosque),
              label: 'Historias',
            ),
            NavigationDestination(
              icon: Icon(Icons.mark_chat_unread_outlined),
              selectedIcon: Icon(Icons.mark_chat_unread_rounded, color: colorBosque),
              label: 'Chats falsos',
            ),
            NavigationDestination(
              icon: Icon(Icons.key_outlined),
              selectedIcon: Icon(Icons.key_rounded, color: colorBosque),
              label: 'Claves',
            ),
            NavigationDestination(
              icon: Icon(Icons.extension_outlined),
              selectedIcon: Icon(Icons.extension_rounded, color: colorBosque),
              label: 'Juego',
            ),
          ],
        ),
      ),
    );
  }
}
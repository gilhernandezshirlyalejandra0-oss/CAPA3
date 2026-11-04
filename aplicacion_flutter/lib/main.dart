import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'models/alerta_seguridad.dart';
import 'models/opcion_menu.dart';
import 'screens/alertas_screen.dart';
import 'viewmodels/bienvenida_viewmodel.dart';

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const BienvenidaScreen()),
    GoRoute(
      path: '/alertas',
      builder: (context, state) => const AlertasScreen(),
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
  runApp(const FortalezaApp());
}

class FortalezaApp extends StatelessWidget {
  const FortalezaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Fortaleza Cibern\u00E9tica',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF2F7FC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1557A6),
          primary: const Color(0xFF1557A6),
        ),
        fontFamily: 'Roboto',
      ),
    );
  }
}

class BienvenidaScreen extends StatefulWidget {
  const BienvenidaScreen({super.key});

  @override
  State<BienvenidaScreen> createState() => _BienvenidaScreenState();
}

class _BienvenidaScreenState extends State<BienvenidaScreen> {
  static const MethodChannel _voz = MethodChannel('fortaleza/voz');

  String? _mensaje;
  late final BienvenidaViewModel _viewModel;

  List<OpcionMenu> get _opciones => _viewModel.opciones;

  @override
  void initState() {
    super.initState();
    _viewModel = BienvenidaViewModel();
    _viewModel.cargarOpciones();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _reproducirSaludo();
    });
  }

  Future<void> _reproducirSaludo() async {
    try {
      await _voz.invokeMethod('saludar', {
        'texto':
            'Nosotros somos Fortaleza Cibern\u00E9tica. '
            '\u00BFQu\u00E9 necesitas? Puedes revisar un enlace, '
            'analizar un mensaje, aprender sobre seguridad '
            'o consultar un riesgo.',
      });

      if (mounted) {
        setState(() => _mensaje = null);
      }
    } on PlatformException {
      _mostrarAvisoVoz();
    } on MissingPluginException {
      _mostrarAvisoVoz();
    }
  }

  void _mostrarAvisoVoz() {
    if (!mounted) return;

    setState(() {
      _mensaje =
          'La bienvenida hablada no est\u00E1 disponible todav\u00EDa. '
          'Puedes usar los botones para continuar.';
    });
  }

  void _seleccionarOpcion(String titulo) {
    if (titulo == 'Revisar un enlace') {
      context.push('/alertas');
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Seleccionaste: $titulo. '
          'Esta funci\u00F3n se desarrollar\u00E1 en el siguiente paso.',
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.shield_moon_outlined,
                    size: 76,
                    color: Color(0xFF1557A6),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Fortaleza Cibern\u00E9tica',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      height: 1.2,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF153B66),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Nosotros somos Fortaleza Cibern\u00E9tica, '
                    '\u00BFqu\u00E9 necesitas?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF153B66),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Estamos aqu\u00ED para ayudarte a navegar '
                    'por internet con m\u00E1s seguridad.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      height: 1.4,
                      color: Color(0xFF35485C),
                    ),
                  ),
                  if (_mensaje != null) ...[
                    const SizedBox(height: 20),
                    Semantics(
                      liveRegion: true,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3CD),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFF8A5A00)),
                        ),
                        child: Text(
                          _mensaje!,
                          style: const TextStyle(
                            fontSize: 18,
                            height: 1.4,
                            color: Color(0xFF573900),
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  for (final opcion in _opciones) ...[
                    _BotonAccesible(
                      icono: opcion.icono,
                      titulo: opcion.titulo,
                      descripcion: opcion.descripcion,
                      onPressed: () => _seleccionarOpcion(opcion.titulo),
                    ),
                    const SizedBox(height: 14),
                  ],
                  OutlinedButton.icon(
                    onPressed: _reproducirSaludo,
                    icon: const Icon(Icons.volume_up, size: 28),
                    label: const Text('Repetir saludo'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(60),
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      side: const BorderSide(
                        color: Color(0xFF1557A6),
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Tu seguridad digital comienza aqu\u00ED.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.blueGrey.shade700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Proyecto acad\u00E9mico \u00B7 Ingenier\u00EDa Inform\u00E1tica',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Color(0xFF526579)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BotonAccesible extends StatelessWidget {
  const _BotonAccesible({
    required this.icono,
    required this.titulo,
    required this.descripcion,
    required this.onPressed,
  });

  final IconData icono;
  final String titulo;
  final String descripcion;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$titulo. $descripcion',
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF153B66),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(18),
            minimumSize: const Size.fromHeight(96),
            side: const BorderSide(color: Color(0xFF9AB9DB), width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: Row(
            children: [
              Icon(icono, size: 38, color: const Color(0xFF1557A6)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      titulo,
                      style: const TextStyle(
                        fontSize: 21,
                        height: 1.25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      descripcion,
                      style: const TextStyle(fontSize: 16, height: 1.3),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, size: 30),
            ],
          ),
        ),
      ),
    );
  }
}

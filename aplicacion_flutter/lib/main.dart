import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'models/alerta_seguridad.dart';
import 'models/opcion_menu.dart';
import 'screens/alertas_screen.dart';
import 'screens/aprende_phishing_screen.dart';
import 'screens/cuestionario_screen.dart';
import 'screens/consejos_seguridad_screen.dart';
import 'viewmodels/bienvenida_viewmodel.dart';

const Color azul = Color(0xFF1557A6);
const Color azulOscuro = Color(0xFF153B66);
const Color fondo = Color(0xFFF3F7FC);
const Color verde = Color(0xFF159B83);

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const BienvenidaScreen()),
    GoRoute(
      path: '/aprende-phishing',
      builder: (context, state) => const AprendePhishingScreen(),
    ),
    GoRoute(
      path: '/aprende-phishing',
      builder: (context, state) => const AprendePhishingScreen(),
    ),
    GoRoute(
      path: '/cuestionario',
      builder: (context, state) => const CuestionarioScreen(),
    ),
    GoRoute(
      path: '/consejos-seguridad',
      builder: (context, state) => const ConsejosSeguridadScreen(),
    ),
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
      title: 'Fortaleza Cibernética',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: fondo,
        colorScheme: ColorScheme.fromSeed(seedColor: azul, primary: azul),
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
            'Bienvenido a Fortaleza Cibernética. '
            'Aquí aprenderás a reconocer engaños digitales, '
            'proteger tus datos y navegar por internet con seguridad.',
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
          'Puedes continuar utilizando los botones. '
          'La bienvenida hablada no está disponible en este dispositivo.';
    });
  }

  void _seleccionarOpcion(String titulo) {
    if (titulo == 'Aprende sobre el phishing') {
      context.push('/aprende-phishing');
      return;
    }

    if (titulo == 'Reconoce los engaños') {
      context.push('/alertas');
      return;
    }

    if (titulo == 'Pon a prueba lo aprendido') {
      context.push('/cuestionario');
      return;
    }

    if (titulo == 'Consejos de seguridad') {
      context.push('/consejos-seguridad');
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('La sección "$titulo" estará disponible próximamente.'),
        behavior: SnackBarBehavior.floating,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('La sección "$titulo" estará disponible próximamente.'),
        behavior: SnackBarBehavior.floating,
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
            constraints: const BoxConstraints(maxWidth: 1000),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _encabezado(),
                  const SizedBox(height: 24),
                  _bienvenida(),
                  if (_mensaje != null) ...[
                    const SizedBox(height: 16),
                    _avisoVoz(),
                  ],
                  const SizedBox(height: 30),
                  const Text(
                    '¿Qué quieres aprender hoy?',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: azulOscuro,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Elige un tema y aprende a protegerte paso a paso.',
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.4,
                      color: Color(0xFF526579),
                    ),
                  ),
                  const SizedBox(height: 20),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final dobleColumna = constraints.maxWidth >= 620;
                      final ancho = dobleColumna
                          ? (constraints.maxWidth - 18) / 2
                          : constraints.maxWidth;

                      return Wrap(
                        spacing: 18,
                        runSpacing: 18,
                        children: [
                          for (int i = 0; i < _opciones.length; i++)
                            SizedBox(
                              width: ancho,
                              child: _TarjetaEducativa(
                                opcion: _opciones[i],
                                numero: i + 1,
                                onPressed: () =>
                                    _seleccionarOpcion(_opciones[i].titulo),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  _tarjetaAyuda(),
                  const SizedBox(height: 26),
                  Center(
                    child: OutlinedButton.icon(
                      onPressed: _reproducirSaludo,
                      icon: const Icon(Icons.volume_up_rounded, size: 26),
                      label: const Text('Escuchar bienvenida'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: azul,
                        minimumSize: const Size(240, 58),
                        side: const BorderSide(color: azul, width: 1.5),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 26),
                  const Divider(color: Color(0xFFD8E3EF)),
                  const SizedBox(height: 12),
                  const Text(
                    'Fortaleza Cibernética',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: azulOscuro,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Aprender también es protegerse.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Color(0xFF526579)),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Proyecto académico · Ingeniería Informática',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Color(0xFF718096)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _encabezado() {
    return Row(
      children: [
        Container(
          height: 54,
          width: 54,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [azul, Color(0xFF3586D5)]),
            borderRadius: BorderRadius.circular(17),
          ),
          child: const Icon(
            Icons.shield_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),
        const SizedBox(width: 13),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fortaleza Cibernética',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: azulOscuro,
                ),
              ),
              Text(
                'Educación para una vida digital segura',
                style: TextStyle(fontSize: 14, color: Color(0xFF526579)),
              ),
            ],
          ),
        ),
        const Icon(Icons.verified_user_rounded, color: verde, size: 30),
      ],
    );
  }

  Widget _bienvenida() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1557A6), Color(0xFF287BC2)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: azul.withValues(alpha: 0.20),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¡Hola! 👋',
                      style: TextStyle(
                        fontSize: 31,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Tu seguridad comienza aprendiendo.',
                      style: TextStyle(
                        fontSize: 23,
                        height: 1.3,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.school_rounded,
                size: 75,
                color: Color(0xFFD8F4EE),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'Descubre cómo reconocer los engaños digitales '
            'y cuidar tu información con lecciones fáciles y prácticas.',
            style: TextStyle(fontSize: 18, height: 1.5, color: Colors.white),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.menu_book_rounded, color: Colors.white, size: 23),
                SizedBox(width: 9),
                Flexible(
                  child: Text(
                    'Aprende a tu propio ritmo',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _avisoVoz() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4D8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8C66A)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: Color(0xFF805B13),
            size: 27,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _mensaje!,
              style: const TextStyle(
                fontSize: 16,
                height: 1.4,
                color: Color(0xFF634B19),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaAyuda() {
    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: const Color(0xFFE2F4EF),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFB5DFD2)),
      ),
      child: const Row(
        children: [
          Icon(Icons.favorite_rounded, color: verde, size: 38),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¡No tienes que saberlo todo!',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF126D5D),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Aprende con calma. Cada paso te ayuda a '
                  'navegar por internet con mayor confianza.',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.4,
                    color: Color(0xFF285B53),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaEducativa extends StatelessWidget {
  const _TarjetaEducativa({
    required this.opcion,
    required this.numero,
    required this.onPressed,
  });

  final OpcionMenu opcion;
  final int numero;
  final VoidCallback onPressed;

  Color get _color {
    switch (numero) {
      case 1:
        return const Color(0xFF3478C5);
      case 2:
        return const Color(0xFFE39A36);
      case 3:
        return const Color(0xFF159B83);
      default:
        return const Color(0xFF8064B5);
    }
  }

  Color get _fondoIcono {
    switch (numero) {
      case 1:
        return const Color(0xFFE8F1FF);
      case 2:
        return const Color(0xFFFFF2DF);
      case 3:
        return const Color(0xFFE3F5EF);
      default:
        return const Color(0xFFF0EAFE);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${opcion.titulo}. ${opcion.descripcion}',
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(23),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(23),
              border: Border.all(color: const Color(0xFFE0E9F2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.035),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 62,
                      width: 62,
                      decoration: BoxDecoration(
                        color: _fondoIcono,
                        borderRadius: BorderRadius.circular(19),
                      ),
                      child: Icon(opcion.icono, size: 34, color: _color),
                    ),
                    Icon(Icons.arrow_forward_rounded, color: _color, size: 27),
                  ],
                ),
                const SizedBox(height: 17),
                Text(
                  opcion.titulo,
                  style: const TextStyle(
                    fontSize: 20,
                    height: 1.25,
                    fontWeight: FontWeight.bold,
                    color: azulOscuro,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  opcion.descripcion,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.4,
                    color: Color(0xFF526579),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Comenzar a aprender',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: _color,
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

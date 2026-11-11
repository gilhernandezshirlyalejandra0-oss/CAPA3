import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Color azulPhishing = Color(0xFF1557A6);
const Color azulOscuroPhishing = Color(0xFF153B66);
const Color fondoPhishing = Color(0xFFF3F7FC);
const Color verdePhishing = Color(0xFF159B83);

class AprendePhishingScreen extends StatefulWidget {
  const AprendePhishingScreen({super.key});

  @override
  State<AprendePhishingScreen> createState() => _AprendePhishingScreenState();
}

class _AprendePhishingScreenState extends State<AprendePhishingScreen> {
  static const MethodChannel _voz = MethodChannel('fortaleza/voz');

  bool _reproduciendo = false;
  String? _leccionActual;
  String? _mensaje;

  Future<void> _escuchar(String titulo, String contenido) async {
    setState(() {
      _reproduciendo = true;
      _leccionActual = titulo;
      _mensaje = null;
    });

    try {
      await _voz.invokeMethod('leer', {'texto': '$titulo. $contenido'});
    } on PlatformException {
      _mostrarError();
    } on MissingPluginException {
      _mostrarError();
    }
  }

  Future<void> _detener() async {
    try {
      await _voz.invokeMethod('detener');
    } on PlatformException {
      _mostrarError();
      return;
    } on MissingPluginException {
      _mostrarError();
      return;
    }

    if (mounted) {
      setState(() {
        _reproduciendo = false;
        _leccionActual = null;
      });
    }
  }

  void _mostrarError() {
    if (!mounted) return;

    setState(() {
      _reproduciendo = false;
      _leccionActual = null;
      _mensaje =
          'No fue posible reproducir el audio. '
          'Puedes continuar leyendo la lección.';
    });
  }

  @override
  void dispose() {
    _voz.invokeMethod('detener').catchError((_) {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondoPhishing,
      appBar: AppBar(
        backgroundColor: azulPhishing,
        foregroundColor: Colors.white,
        title: const Text(
          'Aprende sobre el phishing',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 750),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [azulPhishing, Color(0xFF287BC2)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.school_rounded, size: 55, color: Colors.white),
                    SizedBox(height: 15),
                    Text(
                      '¡Vamos a aprender!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Conoce los engaños que pueden aparecer '
                      'en tu celular y aprende a protegerte.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              if (_reproduciendo)
                Card(
                  color: const Color(0xFFE2F4EF),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.volume_up_rounded,
                              color: verdePhishing,
                              size: 30,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Reproduciendo: $_leccionActual',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: azulOscuroPhishing,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: _detener,
                            icon: const Icon(Icons.stop_circle_rounded),
                            label: const Text('Detener audio'),
                            style: FilledButton.styleFrom(
                              backgroundColor: azulOscuroPhishing,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              if (_mensaje != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    _mensaje!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),

              const Text(
                'Tus primeras lecciones',
                style: TextStyle(
                  color: azulOscuroPhishing,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Toca cada tema para descubrir su explicación.',
                style: TextStyle(fontSize: 17, color: Color(0xFF526579)),
              ),
              const SizedBox(height: 18),

              _LeccionCard(
                numero: '01',
                icono: Icons.menu_book_rounded,
                titulo: '¿Qué es el phishing?',
                resumen: 'Aprende qué significa esta palabra.',
                contenido:
                    'El phishing es un engaño que busca que una persona '
                    'entregue información privada, como contraseñas, '
                    'datos bancarios o códigos de seguridad. '
                    'Los estafadores se hacen pasar por personas '
                    'o empresas conocidas para ganar tu confianza.',
                color: azulPhishing,
                reproduciendo: _leccionActual == '¿Qué es el phishing?',
                onEscuchar: () => _escuchar(
                  '¿Qué es el phishing?',
                  'El phishing es un engaño que busca que una persona '
                      'entregue información privada, como contraseñas, '
                      'datos bancarios o códigos de seguridad. '
                      'Los estafadores se hacen pasar por personas '
                      'o empresas conocidas para ganar tu confianza.',
                ),
              ),
              _LeccionCard(
                numero: '02',
                icono: Icons.phone_android_rounded,
                titulo: '¿Cómo llegan los engaños?',
                resumen: 'Conoce los medios que pueden utilizar.',
                contenido:
                    'Los engaños pueden llegar mediante mensajes de '
                    'WhatsApp, mensajes de texto, correos electrónicos '
                    'o llamadas telefónicas. Por ejemplo, alguien puede '
                    'decirte que ganaste un premio o que tu cuenta '
                    'bancaria será bloqueada.',
                color: const Color(0xFFE39A36),
                reproduciendo: _leccionActual == '¿Cómo llegan los engaños?',
                onEscuchar: () => _escuchar(
                  '¿Cómo llegan los engaños?',
                  'Los engaños pueden llegar mediante mensajes de '
                      'WhatsApp, mensajes de texto, correos electrónicos '
                      'o llamadas telefónicas. Por ejemplo, alguien puede '
                      'decirte que ganaste un premio o que tu cuenta '
                      'bancaria será bloqueada.',
                ),
              ),
              _LeccionCard(
                numero: '03',
                icono: Icons.person_search_rounded,
                titulo: '¿Qué buscan los estafadores?',
                resumen: 'Descubre por qué quieren engañarte.',
                contenido:
                    'Algunas personas buscan conseguir tu contraseña, '
                    'robar dinero, obtener tus datos personales o entrar '
                    'a tus cuentas. Por eso, nunca debes compartir '
                    'contraseñas ni códigos de verificación.',
                color: verdePhishing,
                reproduciendo: _leccionActual == '¿Qué buscan los estafadores?',
                onEscuchar: () => _escuchar(
                  '¿Qué buscan los estafadores?',
                  'Algunas personas buscan conseguir tu contraseña, '
                      'robar dinero, obtener tus datos personales o entrar '
                      'a tus cuentas. Por eso, nunca debes compartir '
                      'contraseñas ni códigos de verificación.',
                ),
              ),
              _LeccionCard(
                numero: '04',
                icono: Icons.shield_rounded,
                titulo: '¿Cómo puedes protegerte?',
                resumen: 'Aprende a tomar decisiones seguras.',
                contenido:
                    'Mantén la calma cuando recibas un mensaje '
                    'sospechoso. No entregues tus datos ni compartas '
                    'códigos. Si dicen ser de tu banco, comunícate '
                    'directamente con la entidad usando sus canales '
                    'oficiales. Si tienes dudas, pide ayuda a alguien '
                    'de confianza.',
                color: const Color(0xFF8064B5),
                reproduciendo: _leccionActual == '¿Cómo puedes protegerte?',
                onEscuchar: () => _escuchar(
                  '¿Cómo puedes protegerte?',
                  'Mantén la calma cuando recibas un mensaje '
                      'sospechoso. No entregues tus datos ni compartas '
                      'códigos. Si dicen ser de tu banco, comunícate '
                      'directamente con la entidad usando sus canales '
                      'oficiales. Si tienes dudas, pide ayuda a alguien '
                      'de confianza.',
                ),
              ),

              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2F4EF),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFB5DFD2)),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.favorite_rounded,
                      color: verdePhishing,
                      size: 34,
                    ),
                    SizedBox(width: 13),
                    Expanded(
                      child: Text(
                        'Recuerda: aprender a protegerte toma tiempo. '
                        'Puedes leer estas lecciones todas las veces '
                        'que lo necesites.',
                        style: TextStyle(
                          fontSize: 17,
                          height: 1.5,
                          color: Color(0xFF285B53),
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

class _LeccionCard extends StatelessWidget {
  const _LeccionCard({
    required this.numero,
    required this.icono,
    required this.titulo,
    required this.resumen,
    required this.contenido,
    required this.color,
    required this.reproduciendo,
    required this.onEscuchar,
  });

  final String numero;
  final IconData icono;
  final String titulo;
  final String resumen;
  final String contenido;
  final Color color;
  final bool reproduciendo;
  final VoidCallback onEscuchar;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFE0E9F2)),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        leading: CircleAvatar(
          radius: 27,
          backgroundColor: color.withValues(alpha: 0.12),
          child: Icon(icono, color: color, size: 29),
        ),
        title: Text(
          titulo,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: azulOscuroPhishing,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            resumen,
            style: const TextStyle(fontSize: 15, color: Color(0xFF526579)),
          ),
        ),
        children: [
          const Divider(),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'LECCIÓN $numero',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            contenido,
            style: const TextStyle(
              fontSize: 17,
              height: 1.6,
              color: Color(0xFF34495E),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onEscuchar,
              icon: Icon(
                reproduciendo
                    ? Icons.volume_up_rounded
                    : Icons.play_circle_fill_rounded,
              ),
              label: Text(reproduciendo ? 'Reproduciendo' : 'Escuchar lección'),
              style: FilledButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';

const Color azulPhishing = Color(0xFF1557A6);
const Color azulOscuroPhishing = Color(0xFF153B66);
const Color fondoPhishing = Color(0xFFF3F7FC);
const Color verdePhishing = Color(0xFF159B83);

class AprendePhishingScreen extends StatelessWidget {
  const AprendePhishingScreen({super.key});

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
        centerTitle: false,
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
                    Icon(
                      Icons.school_rounded,
                      size: 55,
                      color: Colors.white,
                    ),
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
              const SizedBox(height: 25),
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
                style: TextStyle(
                  fontSize: 17,
                  color: Color(0xFF526579),
                ),
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
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2F4EF),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFB5DFD2),
                  ),
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
  });

  final String numero;
  final IconData icono;
  final String titulo;
  final String resumen;
  final String contenido;
  final Color color;

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
        tilePadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),
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
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF526579),
            ),
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
        ],
      ),
    );
  }
}

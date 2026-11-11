import 'package:flutter/material.dart';

const Color azulConsejos = Color(0xFF1557A6);
const Color fondoConsejos = Color(0xFFF3F7FC);
const Color verdeConsejos = Color(0xFF159B83);

class ConsejosSeguridadScreen extends StatelessWidget {
  const ConsejosSeguridadScreen({super.key});

  static const List<Map<String, dynamic>> consejos = [
    {
      'icono': Icons.lock_rounded,
      'titulo': 'Protege tus contraseñas',
      'descripcion': 'Utiliza contraseñas difíciles de adivinar y evita compartirlas con otras personas.',
      'ejemplo': 'No uses tu fecha de nacimiento como contraseña.',
    },
    {
      'icono': Icons.message_rounded,
      'titulo': 'Desconfía de mensajes inesperados',
      'descripcion': 'Algunos mensajes ofrecen premios o anuncian problemas urgentes para engañarte.',
      'ejemplo': 'Si recibes un mensaje diciendo que ganaste un premio, no te apresures a responder.',
    },
    {
      'icono': Icons.pin_rounded,
      'titulo': 'No compartas códigos personales',
      'descripcion': 'Los códigos que llegan a tu celular sirven para proteger tus cuentas.',
      'ejemplo': 'Nunca entregues por teléfono o mensajes los códigos de verificación de tus cuentas.',
    },
    {
      'icono': Icons.phone_in_talk_rounded,
      'titulo': 'Ten cuidado con las llamadas',
      'descripcion': 'Una persona puede hacerse pasar por un trabajador de un banco o una empresa.',
      'ejemplo': 'Si tienes dudas, cuelga y comunícate directamente con el número oficial de la entidad.',
    },
    {
      'icono': Icons.link_rounded,
      'titulo': 'Piensa antes de abrir enlaces',
      'descripcion': 'No abras enlaces enviados por personas desconocidas o mediante mensajes inesperados.',
      'ejemplo': 'Si un mensaje te pide entrar a un enlace para evitar un supuesto bloqueo, verifica primero.',
    },
    {
      'icono': Icons.support_agent_rounded,
      'titulo': 'Pide ayuda cuando tengas dudas',
      'descripcion': 'No tienes que resolver todo solo. Consultar con alguien de confianza puede evitar un engaño.',
      'ejemplo': 'Antes de enviar dinero o información, habla con un familiar o una persona de confianza.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondoConsejos,
      appBar: AppBar(
        backgroundColor: azulConsejos,
        foregroundColor: Colors.white,
        title: const Text(
          'Consejos de seguridad',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [azulConsejos, Color(0xFF2879C7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.shield_rounded, color: Colors.white, size: 48),
                      SizedBox(height: 14),
                      Text(
                        '¡Cuida tu seguridad digital!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Pequeñas acciones pueden ayudarte a proteger tu información y evitar engaños en internet.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Recomendaciones para tu día a día',
                  style: TextStyle(
                    color: azulConsejos,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                ...consejos.map((consejo) {
                  return _ConsejoCard(consejo: consejo);
                }),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2F5EF),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: verdeConsejos),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.favorite_rounded,
                        color: verdeConsejos,
                        size: 36,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Recuerda',
                        style: TextStyle(
                          color: azulConsejos,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'No tengas miedo de preguntar. Aprender a protegerte es un paso importante para navegar por internet con tranquilidad.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 17, height: 1.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'Fortaleza Cibernética · Aprende y protégete',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54, fontSize: 14),
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

class _ConsejoCard extends StatelessWidget {
  const _ConsejoCard({required this.consejo});

  final Map<String, dynamic> consejo;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF2FC),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    consejo['icono'] as IconData,
                    color: azulConsejos,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    consejo['titulo'] as String,
                    style: const TextStyle(
                      color: azulConsejos,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              consejo['descripcion'] as String,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF7F2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.lightbulb_rounded,
                    color: verdeConsejos,
                    size: 23,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      consejo['ejemplo'] as String,
                      style: const TextStyle(fontSize: 15, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

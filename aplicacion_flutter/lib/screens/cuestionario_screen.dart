
import 'package:flutter/material.dart';

class CuestionarioScreen extends StatefulWidget {
  const CuestionarioScreen({super.key});

  @override
  State<CuestionarioScreen> createState() => _CuestionarioScreenState();
}

class _CuestionarioScreenState extends State<CuestionarioScreen> {
  int preguntaActual = 0;
  int puntaje = 0;
  int? respuestaSeleccionada;
  bool finalizado = false;

  final List<Map<String, dynamic>> preguntas = [
    {
      'pregunta': 'Recibes un mensaje que dice que ganaste un premio, pero debes entregar tus datos. ¿Qué debes hacer?',
      'respuestas': [
        'Entregar mis datos rápidamente.',
        'No compartir mis datos y verificar la información.',
        'Enviar el mensaje a mis contactos.',
      ],
      'correcta': 1,
      'explicacion': '¡Muy bien! Los premios inesperados pueden ser un engaño. Nunca entregues tus datos sin verificar.',
    },
    {
      'pregunta': 'Una persona que dice ser del banco te pide el código que llegó a tu celular. ¿Qué haces?',
      'respuestas': [
        'Le comparto el código.',
        'Le envío una fotografía del mensaje.',
        'No comparto el código con nadie.',
      ],
      'correcta': 2,
      'explicacion': '¡Correcto! Los códigos de seguridad son privados. No debes compartirlos con otras personas.',
    },
    {
      'pregunta': 'Recibes un mensaje que anuncia que tu cuenta será bloqueada si no haces clic en un enlace. ¿Qué debes hacer?',
      'respuestas': [
        'Mantener la calma y consultar directamente con la entidad.',
        'Abrir el enlace inmediatamente.',
        'Responder con mi contraseña.',
      ],
      'correcta': 0,
      'explicacion': '¡Excelente! No actúes por presión. Consulta siempre por los canales oficiales.',
    },
    {
      'pregunta': '¿Por cuáles medios pueden llegar los engaños digitales?',
      'respuestas': [
        'Solamente por llamadas.',
        'Por WhatsApp, SMS, correos y llamadas.',
        'Solamente por redes sociales.',
      ],
      'correcta': 1,
      'explicacion': '¡Así es! Los engaños pueden llegar por diferentes medios de comunicación.',
    },
    {
      'pregunta': 'Si tienes dudas sobre un mensaje sospechoso, ¿qué puedes hacer?',
      'respuestas': [
        'Pedir ayuda a alguien de confianza.',
        'Compartirlo con todos tus contactos.',
        'Entregar la información que te solicitan.',
      ],
      'correcta': 0,
      'explicacion': '¡Muy bien! Pedir ayuda y verificar antes de actuar es una decisión segura.',
    },
  ];

  void seleccionarRespuesta(int indice) {
    if (respuestaSeleccionada != null) return;

    setState(() {
      respuestaSeleccionada = indice;
      if (indice == preguntas[preguntaActual]['correcta']) {
        puntaje++;
      }
    });
  }

  void siguientePregunta() {
    setState(() {
      if (preguntaActual < preguntas.length - 1) {
        preguntaActual++;
        respuestaSeleccionada = null;
      } else {
        finalizado = true;
      }
    });
  }

  void reiniciar() {
    setState(() {
      preguntaActual = 0;
      puntaje = 0;
      respuestaSeleccionada = null;
      finalizado = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1557A6),
        foregroundColor: Colors.white,
        title: const Text(
          'Pon a prueba lo aprendido',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 750),
          child: finalizado ? pantallaResultado() : pantallaPregunta(),
        ),
      ),
    );
  }

  Widget pantallaPregunta() {
    final pregunta = preguntas[preguntaActual];
    final respuestas = pregunta['respuestas'] as List<String>;
    final correcta = pregunta['correcta'] as int;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: const Color(0xFF1557A6),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.quiz_rounded,
                color: Colors.white,
                size: 42,
              ),
              const SizedBox(height: 12),
              const Text(
                '¡Aprendamos practicando!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Pregunta ${preguntaActual + 1} de ${preguntas.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 15),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: (preguntaActual + 1) / preguntas.length,
                  minHeight: 10,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF64D6B2),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        Text(
          pregunta['pregunta'] as String,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF153B66),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 20),
        ...List.generate(respuestas.length, (indice) {
          final seleccionada = respuestaSeleccionada == indice;
          final mostrarResultado = respuestaSeleccionada != null;

          Color colorFondo = Colors.white;
          Color colorBorde = const Color(0xFFDCE6F0);

          if (mostrarResultado && indice == correcta) {
            colorFondo = const Color(0xFFE2F4EF);
            colorBorde = const Color(0xFF159B83);
          } else if (seleccionada) {
            colorFondo = const Color(0xFFFFE8E8);
            colorBorde = Colors.redAccent;
          }

          return Container(
            margin: const EdgeInsets.only(bottom: 13),
            child: Material(
              color: colorFondo,
              borderRadius: BorderRadius.circular(17),
              child: InkWell(
                borderRadius: BorderRadius.circular(17),
                onTap: respuestaSeleccionada == null
                    ? () => seleccionarRespuesta(indice)
                    : null,
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    border: Border.all(color: colorBorde, width: 1.8),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: mostrarResultado && indice == correcta
                            ? const Color(0xFF159B83)
                            : const Color(0xFFE8F0FA),
                        child: mostrarResultado && indice == correcta
                            ? const Icon(Icons.check, color: Colors.white)
                            : Text(
                                String.fromCharCode(65 + indice),
                                style: const TextStyle(
                                  color: Color(0xFF1557A6),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          respuestas[indice],
                          style: const TextStyle(
                            fontSize: 17,
                            color: Color(0xFF34495E),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
        if (respuestaSeleccionada != null) ...[
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: respuestaSeleccionada == correcta
                  ? const Color(0xFFE2F4EF)
                  : const Color(0xFFFFF2DE),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Text(
              pregunta['explicacion'] as String,
              style: const TextStyle(
                fontSize: 17,
                height: 1.5,
                color: Color(0xFF34495E),
              ),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 58,
            child: ElevatedButton(
              onPressed: siguientePregunta,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1557A6),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                preguntaActual == preguntas.length - 1
                    ? 'Ver mi resultado'
                    : 'Siguiente pregunta',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget pantallaResultado() {
    final porcentaje = (puntaje / preguntas.length * 100).round();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            porcentaje >= 60
                ? Icons.emoji_events_rounded
                : Icons.school_rounded,
            color: const Color(0xFFE5A52D),
            size: 85,
          ),
          const SizedBox(height: 20),
          const Text(
            '¡Terminaste la actividad!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
              color: Color(0xFF153B66),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            '$puntaje de ${preguntas.length} respuestas correctas',
            style: const TextStyle(
              fontSize: 23,
              color: Color(0xFF1557A6),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '$porcentaje% de aciertos',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          Text(
            porcentaje >= 80
                ? '¡Excelente trabajo! Has aprendido muchos consejos para protegerte.'
                : '¡Buen esfuerzo! Puedes repasar las lecciones y volver a intentarlo.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, height: 1.5),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton.icon(
              onPressed: reiniciar,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text(
                'Intentar nuevamente',
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1557A6),
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Volver al menú principal',
              style: TextStyle(fontSize: 17),
            ),
          ),
        ],
      ),
    );
  }
}

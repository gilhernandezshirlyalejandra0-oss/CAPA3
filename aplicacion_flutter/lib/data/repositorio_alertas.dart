import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/alerta_seguridad.dart';

enum EscenarioAlerta { conDatos, vacio, falla, cargando }

class RepositorioAlertas {
  EscenarioAlerta escenario = EscenarioAlerta.conDatos;

  static const String _urlApiRemota =
      'https://raw.githubusercontent.com/escudo-mayor/datos-alertas/main/alertas.json';

  final List<AlertaSeguridad> _ejemplos = const [
    AlertaSeguridad(
      id: 1,
      titulo: 'El cuento del mercado o bono ganador',
      tipo: 'Mensaje de texto (SMS)',
      nivelRiesgo: 'Alto',
      descripcion:
          'Te llega un mensaje felicitándote por un supuesto premio, subsidio o mercado en el que nunca te inscribiste.',
      mensajeEjemplo:
          '¡FELICIDADES! Fuiste elegido para recibir un bono de 500 mil pesos hoy. Toca estas letras azules y escribe tu cédula y clave para reclamarlo.',
      senales: [
        'Nadie regala plata ni mercados si no participaste en un sorteo.',
        'Te meten afán diciendo que tienes que reclamarlo hoy mismo.',
        'Te piden tocar un enlace azul y anotar tus claves.',
      ],
      recomendacion:
          'No toques las letras azules ni respondas nada. Borra el mensaje de una vez y sigue tranquilo con tu día.',
    ),
    AlertaSeguridad(
      id: 2,
      titulo: 'El susto de la cuenta o pensión bloqueada',
      tipo: 'WhatsApp',
      nivelRiesgo: 'Alto',
      descripcion:
          'Intentan asustarte diciendo que tu cuenta del banco se va a cerrar para que entregues tu clave sin pensar.',
      mensajeEjemplo:
          'AVISO URGENTE: Su cuenta de ahorros será bloqueada en 10 minutos por movimientos raros. Envíe su clave por aquí para cancelar el bloqueo.',
      senales: [
        'Usan el miedo y te dan pocos minutos para que te asustes.',
        'Un banco de verdad jamás atiende bloqueos por un chat común.',
        'Te piden tu clave secreta del cajero o del celular.',
      ],
      recomendacion:
          'Respira con calma y no contestes ese mensaje. Tu plata está segura. Si quieres salir de dudas, ve al banco o llama con ayuda de un familiar.',
    ),
    AlertaSeguridad(
      id: 3,
      titulo: 'La encomienda que pide plata para llegar',
      tipo: 'Mensaje de texto (SMS)',
      nivelRiesgo: 'Medio',
      descripcion:
          'Te dicen que hay una caja o regalo a tu nombre que no han podido entregar y te cobran unos pesos para llevártelo.',
      mensajeEjemplo:
          'Su paquete no pudo ser entregado porque falta pagar 8.500 pesos de envío. Pague aquí con su tarjeta para recibirlo hoy.',
      senales: [
        'No estabas esperando ninguna compra ni encomienda.',
        'Te cobran un valor pequeñito solo para sacarte los datos de tu tarjeta.',
        'Trae un enlace extraño para que pagues por internet.',
      ],
      recomendacion:
          'Nunca pongas los números de tu tarjeta en enlaces que llegan por mensaje. Pregúntale primero a tu familia si alguien te envió algo.',
    ),
    AlertaSeguridad(
      id: 4,
      titulo: 'La supuesta deuda o factura vencida',
      tipo: 'Correo electrónico',
      nivelRiesgo: 'Medio',
      descripcion:
          'Te mandan un correo inventando que debes una factura o un comparendo para que descargues un archivo trampa.',
      mensajeEjemplo:
          'Estimado cliente: Tiene una factura pendiente de pago con cobro jurídico mañana. Abra el archivo adjunto para ver su deuda.',
      senales: [
        'Ni siquiera dicen tu nombre completo, solo ponen "Estimado cliente".',
        'Amenazan con embargos o multas de un día para otro.',
        'Quieren que abras un archivo que no pediste.',
      ],
      recomendacion:
          'No abras ese archivo. Revisa tus recibos de papel de toda la vida; si están al día, borra ese correo sin preocuparte.',
    ),
    AlertaSeguridad(
      id: 5,
      titulo: 'El robo de WhatsApp con los 6 numeritos',
      tipo: 'WhatsApp',
      nivelRiesgo: 'Alto',
      descripcion:
          'Alguien haciéndose pasar por un vecino, amigo o empresa te pide un código de 6 números que acaba de llegar a tu celular.',
      mensajeEjemplo:
          'Hola vecino, qué pena la molestia, por equivocación mandé un código de 6 números a su celular. ¿Me lo pasa por favor que es urgente?',
      senales: [
        'Te piden esos 6 numeritos que llegaron por mensaje de texto.',
        'Ponen la excusa de que fue un error o una inscripción a un grupo.',
        'Si les das ese código, te quitan tu WhatsApp para pedirle plata a tu familia.',
      ],
      recomendacion:
          'Esos 6 numeritos son sagrados, no se los pases absolutamente a nadie. Llama a tu conocido por teléfono para avisarle que le hackearon el chat.',
    ),
  ];

  Future<List<AlertaSeguridad>> obtenerTodas() async {
    if (escenario == EscenarioAlerta.cargando) {
      await Completer<void>().future;
    }

    if (escenario == EscenarioAlerta.falla) {
      throw Exception('No pudimos cargar los casos en este momento.');
    }

    if (escenario == EscenarioAlerta.vacio) {
      return const [];
    }

    try {
      final respuesta = await http
          .get(Uri.parse(_urlApiRemota))
          .timeout(const Duration(milliseconds: 1200));

      if (respuesta.statusCode == 200) {
        final List<dynamic> datosJson =
            jsonDecode(respuesta.body) as List<dynamic>;
        return datosJson.map((item) {
          final mapa = item as Map<String, dynamic>;
          return AlertaSeguridad(
            id: mapa['id'] as int,
            titulo: mapa['titulo'] as String,
            tipo: mapa['tipo'] as String,
            nivelRiesgo: mapa['nivelRiesgo'] as String,
            descripcion: mapa['descripcion'] as String,
            mensajeEjemplo: mapa['mensajeEjemplo'] as String,
            senales: List<String>.from(mapa['senales'] as List<dynamic>),
            recomendacion: mapa['recomendacion'] as String,
          );
        }).toList();
      }
    } catch (_) {}

    return _ejemplos;
  }
}
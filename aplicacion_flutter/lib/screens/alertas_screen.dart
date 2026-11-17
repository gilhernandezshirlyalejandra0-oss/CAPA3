import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/alerta_seguridad.dart';
import '../services/voz_humana.dart';
import '../viewmodels/alertas_viewmodel.dart';

const Color colorPapel = Color(0xFFF6F2EA);
const Color colorTinta = Color(0xFF1F2421);
const Color colorBosque = Color(0xFF1B5E49);
const Color colorArcilla = Color(0xFFC85A32);
const Color verdeWhatsApp = Color(0xFFE7FFDB);

class AlertasScreen extends StatelessWidget {
  const AlertasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AlertasViewModel()..cargar(),
      child: const _BandejaChatsFalsos(),
    );
  }
}

class _BandejaChatsFalsos extends StatelessWidget {
  const _BandejaChatsFalsos();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AlertasViewModel>();

    return Scaffold(
      backgroundColor: colorPapel,
      appBar: AppBar(
        backgroundColor: colorBosque,
        foregroundColor: Colors.white,
        title: const Text(
          'Mensajes sospechosos',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up_rounded),
            onPressed: () => VozHumana.hablar(
              'Estos son cinco mensajes falsos que suelen llegar al celular. Toca cualquiera para abrirlo y ver dónde está la trampa.',
            ),
          ),
        ],
      ),
      body: vm.estado == EstadoAlertas.cargando
          ? const Center(child: CircularProgressIndicator(color: colorBosque))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: vm.alertas.length + 1,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const Padding(
                    padding: EdgeInsets.only(bottom: 6),
                    child: Text(
                      'Toca un mensaje para abrirlo paso a paso:',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF4A524E),
                      ),
                    ),
                  );
                }
                final alerta = vm.alertas[index - 1];
                final horas = ['9:14 a. m.', '10:42 a. m.', '2:15 p. m.', '4:30 p. m.', '6:05 p. m.'];
                return _ItemChatSimulado(
                  alerta: alerta,
                  hora: horas[(index - 1) % horas.length],
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => DetalleAlertaScreen(alerta: alerta),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class _ItemChatSimulado extends StatelessWidget {
  const _ItemChatSimulado({
    required this.alerta,
    required this.hora,
    required this.onTap,
  });

  final AlertaSeguridad alerta;
  final String hora;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final esWhatsApp = alerta.tipo.toLowerCase().contains('whatsapp');

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: esWhatsApp
                    ? const Color(0xFF25D366)
                    : const Color(0xFF3B6E8C),
                child: Icon(
                  esWhatsApp ? Icons.chat_rounded : Icons.sms_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          alerta.tipo,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: colorArcilla,
                          ),
                        ),
                        Text(
                          hora,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      alerta.titulo,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: colorTinta,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      alerta.mensajeEjemplo,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        height: 1.3,
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

class DetalleAlertaScreen extends StatefulWidget {
  const DetalleAlertaScreen({super.key, required this.alerta});

  final AlertaSeguridad alerta;

  @override
  State<DetalleAlertaScreen> createState() => _DetalleAlertaScreenState();
}

class _DetalleAlertaScreenState extends State<DetalleAlertaScreen> {
  final PageController _controller = PageController();
  int _paso = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _hablarPaso(0));
  }

  @override
  void dispose() {
    VozHumana.detener();
    _controller.dispose();
    super.dispose();
  }

  void _hablarPaso(int index) {
    final a = widget.alerta;
    final textos = [
      'Mira cómo llega este mensaje por ${a.tipo}: ${a.mensajeEjemplo}',
      '¿Qué están intentando hacerte? ${a.descripcion}',
      'Fíjate en estas trampas: ${a.senales.join(". ")}',
      'Lo que debes hacer es muy sencillo: ${a.recomendacion}',
    ];
    VozHumana.hablar(textos[index]);
  }

  void _irAPaso(int nuevo) {
    _controller.animateToPage(
      nuevo,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.alerta;

    return Scaffold(
      backgroundColor: const Color(0xFFEAE3D5),
      appBar: AppBar(
        backgroundColor: colorBosque,
        foregroundColor: Colors.white,
        title: Text(
          a.titulo,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up_rounded),
            onPressed: () => _hablarPaso(_paso),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Parte ${_paso + 1} de 4',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: colorBosque,
                  ),
                ),
                Row(
                  children: List.generate(4, (i) {
                    return Container(
                      width: i == _paso ? 24 : 10,
                      height: 10,
                      margin: const EdgeInsets.only(left: 6),
                      decoration: BoxDecoration(
                        color: i == _paso ? colorArcilla : Colors.black12,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (i) {
                setState(() => _paso = i);
                _hablarPaso(i);
              },
              children: [
                // Pantalla 1: Simulación real de chat de teléfono
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Número desconocido · ${a.tipo}',
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '~ Desconocido',
                              style: TextStyle(
                                color: colorArcilla,
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              a.mensajeEjemplo,
                              style: const TextStyle(
                                fontSize: 21,
                                height: 1.4,
                                fontWeight: FontWeight.w700,
                                color: colorTinta,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                '10:42 a. m.',
                                style: TextStyle(fontSize: 13, color: Colors.black45),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE8E0),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.pan_tool_rounded, color: colorArcilla),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                '¡Alto ahí! Así se ve el mensaje cuando llega a tu celular. Toca "Siguiente" abajo.',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Pantalla 2: Qué buscan
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '¿En qué consiste el engaño?',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: colorArcilla,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          a.descripcion,
                          style: const TextStyle(
                            fontSize: 21,
                            height: 1.45,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Pantalla 3: Las pistas
                ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    const Text(
                      '3 detalles que los delatan:',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 12),
                    for (int i = 0; i < a.senales.length; i++)
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: colorArcilla,
                              child: Text(
                                '${i + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                a.senales[i],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),

                // Pantalla 4: Respuesta correcta
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: verdeWhatsApp,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(4),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Lo que tú haces:',
                              style: TextStyle(
                                color: colorBosque,
                                fontWeight: FontWeight.w900,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              a.recomendacion,
                              style: const TextStyle(
                                fontSize: 21,
                                height: 1.4,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Seguro ', style: TextStyle(fontSize: 13, color: Colors.black54)),
                                Icon(Icons.done_all_rounded, size: 18, color: Colors.blue),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
            child: Row(
              children: [
                if (_paso > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _irAPaso(_paso - 1),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                      ),
                      child: const Text('Atrás', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                    ),
                  ),
                if (_paso > 0) const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: () {
                      if (_paso < 3) {
                        _irAPaso(_paso + 1);
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: _paso < 3 ? colorBosque : colorArcilla,
                      minimumSize: const Size.fromHeight(52),
                    ),
                    child: Text(
                      _paso < 3 ? 'Siguiente' : 'Listo, volver al buzón',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
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
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/alerta_seguridad.dart';
import '../services/asistente.dart';
import '../services/voz_humana.dart';
import '../theme/paleta.dart';
import '../viewmodels/alertas_viewmodel.dart';
import '../widgets/avatar_parlante.dart';
import '../widgets/escena_animada.dart';
import '../widgets/fondos_dibujados.dart';

const Color colorPapel = Paleta.crema;
const Color colorTinta = Paleta.tinta;
const Color colorBosque = Paleta.aqua;
const Color colorArcilla = Paleta.papaya;
const Color verdeWhatsApp = Color(0xFFDCF8C6);

/// Cada mensaje falso tiene un "estafador disfrazado" y un objeto que lo representa.
class _Disfraz {
  const _Disfraz(this.personaje, this.objeto, this.hora);

  final Personaje personaje;
  final IconData objeto;
  final String hora;
}

_Disfraz _disfrazDe(AlertaSeguridad a) {
  switch (a.id) {
    case 1:
      return const _Disfraz(Asistente.estafadorPremio, Icons.card_giftcard_rounded, '9:14 a. m.');
    case 2:
      return const _Disfraz(Asistente.estafadorBanco, Icons.lock_rounded, '10:42 a. m.');
    case 3:
      return const _Disfraz(Asistente.estafadorPaquete, Icons.local_shipping_rounded, '2:15 p. m.');
    case 4:
      return const _Disfraz(Asistente.estafadorCobro, Icons.receipt_long_rounded, '4:30 p. m.');
    case 5:
      return const _Disfraz(Asistente.estafadorVecina, Icons.pin_rounded, '6:05 p. m.');
    default:
      return const _Disfraz(Asistente.estafador, Icons.warning_rounded, '8:00 a. m.');
  }
}

IconData _iconoTipo(String tipo) {
  final t = tipo.toLowerCase();
  if (t.contains('whatsapp')) return Icons.chat_rounded;
  if (t.contains('correo')) return Icons.email_rounded;
  return Icons.sms_rounded;
}

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
        backgroundColor: colorPapel,
        foregroundColor: colorTinta,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text('Chats tramposos', style: Letras.titulo(size: 26)),
        actions: [
          IconButton(
            tooltip: 'Escuchar',
            icon: const Icon(Icons.volume_up_rounded, color: Paleta.aqua, size: 30),
            onPressed: () => VozHumana.hablar(
              'Estos son mensajes falsos que suelen llegar al celular. Aquí puedes abrirlos sin miedo. Toca cualquiera para ver dónde está la trampa.',
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: vm.estado == EstadoAlertas.cargando
          ? const Center(child: CircularProgressIndicator(color: colorBosque))
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              itemCount: vm.alertas.length + 1,
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                if (index == 0) return const _PortadaChats();
                final alerta = vm.alertas[index - 1];
                return _Aparecer(
                  retraso: index * 90,
                  child: _ItemChatSimulado(
                    alerta: alerta,
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder<void>(
                          transitionDuration: const Duration(milliseconds: 420),
                          pageBuilder: (_, _, _) => DetalleAlertaScreen(alerta: alerta),
                          transitionsBuilder: (_, anim, _, child) => SlideTransition(
                            position: Tween(begin: const Offset(1, 0), end: Offset.zero)
                                .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
                            child: child,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

class _PortadaChats extends StatelessWidget {
  const _PortadaChats();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Personaje>(
      valueListenable: Asistente.actual,
      builder: (context, guia, _) => Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Paleta.ciruela, width: 3),
          boxShadow: const [BoxShadow(color: Paleta.ciruela, offset: Offset(5, 5))],
        ),
        child: Column(
          children: [
            SizedBox(
              height: 190,
              child: EscenaAnimada(
                escena: Escena(
                  imagen: 'chats_portada.png',
                  lugar: Lugar.sala,
                  personaje: guia,
                  expresion: Expresion.sorprendida,
                  objeto: Icons.mark_chat_unread_rounded,
                  globo: '¡Ojo!',
                ),
              ),
            ),
            Container(
              width: double.infinity,
              color: Paleta.mostaza,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              child: Text(
                'Estos mensajes son FALSOS. Ábrelos sin miedo: aquí no te pasa nada.',
                style: Letras.titulo(size: 19, height: 1.25),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemChatSimulado extends StatefulWidget {
  const _ItemChatSimulado({required this.alerta, required this.onTap});

  final AlertaSeguridad alerta;
  final VoidCallback onTap;

  @override
  State<_ItemChatSimulado> createState() => _ItemChatSimuladoState();
}

class _ItemChatSimuladoState extends State<_ItemChatSimulado> {
  bool _presionado = false;

  @override
  Widget build(BuildContext context) {
    final a = widget.alerta;
    final d = _disfrazDe(a);
    final alto = a.nivelRiesgo.toLowerCase() == 'alto';
    final sombra = _presionado ? 1.0 : 5.0;

    return GestureDetector(
      onTapDown: (_) => setState(() => _presionado = true),
      onTapCancel: () => setState(() => _presionado = false),
      onTapUp: (_) => setState(() => _presionado = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        transform: Matrix4.translationValues(5 - sombra, 5 - sombra, 0),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Paleta.ciruela, width: 3),
          boxShadow: [BoxShadow(color: Paleta.ciruela, offset: Offset(sombra, sombra))],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: d.personaje.fondo,
                    shape: BoxShape.circle,
                    border: Border.all(color: Paleta.ciruela, width: 2),
                  ),
                  child: AvatarParlante(personaje: d.personaje, tamano: 72, hablaConLaVoz: false),
                ),
                Positioned(
                  right: -4,
                  bottom: -2,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Paleta.aqua,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(_iconoTipo(a.tipo), size: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          d.personaje.nombre,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Letras.titulo(size: 18, color: Paleta.papaya),
                        ),
                      ),
                      Text(
                        d.hora,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Paleta.tintaSuave),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    a.titulo,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: colorTinta, height: 1.2),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    a.mensajeEjemplo,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 17, color: Paleta.tintaSuave, height: 1.3),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: alto ? Paleta.papaya : Paleta.mostaza,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.warning_amber_rounded, size: 18, color: alto ? Colors.white : Paleta.tinta),
                            const SizedBox(width: 4),
                            Text(
                              alto ? 'Peligro alto' : 'Peligro medio',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                color: alto ? Colors.white : Paleta.tinta,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      const _PuntoSinLeer(),
                    ],
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

/// Burbujita de "1 sin leer" que late.
class _PuntoSinLeer extends StatefulWidget {
  const _PuntoSinLeer();

  @override
  State<_PuntoSinLeer> createState() => _PuntoSinLeerState();
}

class _PuntoSinLeerState extends State<_PuntoSinLeer> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween(begin: 0.9, end: 1.15).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut)),
      child: Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        decoration: const BoxDecoration(color: Color(0xFF25D366), shape: BoxShape.circle),
        child: const Text('1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
      ),
    );
  }
}

// ───────────────────────── Detalle paso a paso ─────────────────────────

class DetalleAlertaScreen extends StatefulWidget {
  const DetalleAlertaScreen({super.key, required this.alerta});

  final AlertaSeguridad alerta;

  @override
  State<DetalleAlertaScreen> createState() => _DetalleAlertaScreenState();
}

class _DetalleAlertaScreenState extends State<DetalleAlertaScreen> {
  final PageController _controller = PageController();
  int _paso = 0;

  static const _nombresPasos = ['Así llega', '¿Qué buscan?', 'Las pistas', '¿Qué hago?'];

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
    VozHumana.narrar(textos[index]);
  }

  void _irAPaso(int nuevo) {
    _controller.animateToPage(
      nuevo,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.alerta;
    final d = _disfrazDe(a);

    return Scaffold(
      backgroundColor: colorPapel,
      appBar: AppBar(
        backgroundColor: colorPapel,
        foregroundColor: colorTinta,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(color: d.personaje.fondo, shape: BoxShape.circle),
              child: AvatarParlante(personaje: d.personaje, tamano: 44, hablaConLaVoz: false),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                a.titulo,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Letras.titulo(size: 18, height: 1.1),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Escuchar',
            icon: const Icon(Icons.volume_up_rounded, color: Paleta.aqua, size: 30),
            onPressed: () => VozHumana.hablar(
              ['Mira cómo llega este mensaje: ${a.mensajeEjemplo}', a.descripcion, a.senales.join('. '), a.recomendacion][_paso],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Pasos con nombre
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
            child: Row(
              children: [
                for (var i = 0; i < 4; i++)
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _irAPaso(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: i == _paso ? Paleta.papaya : (i < _paso ? Paleta.aquaSuave : Colors.white),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: i == _paso ? Paleta.ciruela : Paleta.arena, width: 2),
                        ),
                        child: Text(
                          _nombresPasos[i],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: i == _paso ? Colors.white : Paleta.tinta,
                          ),
                        ),
                      ),
                    ),
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
                _PasoAsiLlega(alerta: a, disfraz: d),
                _PasoQueBuscan(alerta: a, disfraz: d),
                _PasoPistas(alerta: a),
                _PasoQueHago(alerta: a),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Paleta.arena, width: 2)),
            ),
            child: Row(
              children: [
                if (_paso > 0)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _irAPaso(_paso - 1),
                      icon: const Icon(Icons.arrow_back_rounded),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Paleta.tinta,
                        side: const BorderSide(color: Paleta.tinta, width: 2),
                        minimumSize: const Size.fromHeight(58),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      ),
                      label: const Text('Atrás', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
                    ),
                  ),
                if (_paso > 0) const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    onPressed: () {
                      if (_paso < 3) {
                        _irAPaso(_paso + 1);
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: _paso < 3 ? Paleta.aqua : Paleta.papaya,
                      minimumSize: const Size.fromHeight(58),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    ),
                    icon: Icon(_paso < 3 ? Icons.arrow_forward_rounded : Icons.check_rounded, size: 26),
                    label: Text(
                      _paso < 3 ? 'Siguiente' : '¡Entendido!',
                      style: Letras.titulo(size: 21, color: Colors.white),
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

/// Paso 1: un celular dibujado donde el mensaje llega "escribiéndose".
class _PasoAsiLlega extends StatefulWidget {
  const _PasoAsiLlega({required this.alerta, required this.disfraz});

  final AlertaSeguridad alerta;
  final _Disfraz disfraz;

  @override
  State<_PasoAsiLlega> createState() => _PasoAsiLlegaState();
}

class _PasoAsiLlegaState extends State<_PasoAsiLlega> {
  bool _llego = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _llego = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.alerta;
    final d = widget.disfraz;
    final esWhatsApp = a.tipo.toLowerCase().contains('whatsapp');
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
      children: [
        // Celular dibujado
        Container(
          decoration: BoxDecoration(
            color: Paleta.ciruela,
            borderRadius: BorderRadius.circular(34),
            boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 16, offset: Offset(0, 8))],
          ),
          padding: const EdgeInsets.all(10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: Column(
              children: [
                // Barra del chat
                Container(
                  color: esWhatsApp ? const Color(0xFF075E54) : const Color(0xFF3B6E8C),
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: Row(
                    children: [
                      Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(color: d.personaje.fondo, shape: BoxShape.circle),
                        child: AvatarParlante(personaje: d.personaje, tamano: 46, hablaConLaVoz: false),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              d.personaje.nombre,
                              style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900),
                            ),
                            Text(
                              _llego ? a.tipo : 'escribiendo…',
                              style: const TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      Icon(_iconoTipo(a.tipo), color: Colors.white),
                    ],
                  ),
                ),
                // Fondo del chat
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(minHeight: 230),
                  color: esWhatsApp ? const Color(0xFFECE5DD) : const Color(0xFFF1F3F5),
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF3C4),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Este número no está en tus contactos',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 450),
                        transitionBuilder: (child, anim) => ScaleTransition(
                          alignment: Alignment.topLeft,
                          scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
                          child: child,
                        ),
                        child: _llego
                            ? Container(
                                key: const ValueKey('mensaje'),
                                padding: const EdgeInsets.all(14),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(18),
                                    bottomLeft: Radius.circular(18),
                                    bottomRight: Radius.circular(18),
                                    topLeft: Radius.circular(4),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      a.mensajeEjemplo,
                                      style: const TextStyle(fontSize: 20, height: 1.4, fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 6),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        d.hora,
                                        style: const TextStyle(fontSize: 13, color: Colors.black45),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const _Escribiendo(key: ValueKey('escribiendo')),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        AnimatedOpacity(
          opacity: _llego ? 1 : 0,
          duration: const Duration(milliseconds: 600),
          child: _ConsejoGuia(
            texto: '¡Alto ahí! Así se ve cuando llega a tu celular. Toca "Siguiente" para descubrir la trampa.',
            expresion: Expresion.sorprendida,
          ),
        ),
      ],
    );
  }
}

class _Escribiendo extends StatefulWidget {
  const _Escribiendo({super.key});

  @override
  State<_Escribiendo> createState() => _EscribiendoState();
}

class _EscribiendoState extends State<_Escribiendo> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) => Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final fase = ((_c.value * 3) - i).clamp(0.0, 1.0);
            return Transform.translate(
              offset: Offset(0, -6 * (fase < 0.5 ? fase * 2 : (1 - fase) * 2)),
              child: Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: const BoxDecoration(color: Colors.black38, shape: BoxShape.circle),
              ),
            );
          }),
        ),
      ),
    );
  }
}

/// Paso 2: el estafador disfrazado en su "oficina" con lo que quiere quitarte.
class _PasoQueBuscan extends StatelessWidget {
  const _PasoQueBuscan({required this.alerta, required this.disfraz});

  final AlertaSeguridad alerta;
  final _Disfraz disfraz;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
      children: [
        _MarcoEscena(
          escena: Escena(
            imagen: 'chat_${alerta.id}_trampa.png',
            lugar: Lugar.oficina,
            personaje: disfraz.personaje,
            objeto: disfraz.objeto,
            globo: r'$$$',
          ),
          pie: 'Detrás del mensaje hay alguien así, disfrazado.',
        ),
        const SizedBox(height: 18),
        Text('¿En qué consiste el engaño?', style: Letras.titulo(size: 26, color: Paleta.papaya)),
        const SizedBox(height: 10),
        Text(
          alerta.descripcion,
          style: const TextStyle(fontSize: 22, height: 1.45, fontWeight: FontWeight.w700, color: Paleta.tinta),
        ),
      ],
    );
  }
}

/// Paso 3: el guía con lupa y las pistas que van apareciendo.
class _PasoPistas extends StatelessWidget {
  const _PasoPistas({required this.alerta});

  final AlertaSeguridad alerta;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Personaje>(
      valueListenable: Asistente.actual,
      builder: (context, guia, _) => ListView(
        padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
        children: [
          _MarcoEscena(
            escena: Escena(
              imagen: 'chat_${alerta.id}_pistas.png',
              lugar: Lugar.casa,
              personaje: guia,
              expresion: Expresion.sorprendida,
              objeto: Icons.search_rounded,
              globo: '!',
            ),
            pie: 'Busquemos juntos las pistas.',
          ),
          const SizedBox(height: 16),
          Text('Detalles que los delatan', style: Letras.titulo(size: 26)),
          const SizedBox(height: 12),
          for (var i = 0; i < alerta.senales.length; i++)
            _Aparecer(
              retraso: 250 + i * 250,
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Paleta.vivos[i % 4], width: 3),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: Paleta.vivos[i % 4], shape: BoxShape.circle),
                      child: Text('${i + 1}', style: Letras.titulo(size: 22, color: Colors.white)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        alerta.senales[i],
                        style: const TextStyle(fontSize: 20, height: 1.35, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Paso 4: el guía feliz y la respuesta correcta como mensaje enviado.
class _PasoQueHago extends StatelessWidget {
  const _PasoQueHago({required this.alerta});

  final AlertaSeguridad alerta;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Personaje>(
      valueListenable: Asistente.actual,
      builder: (context, guia, _) => ListView(
        padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
        children: [
          _MarcoEscena(
            escena: Escena(
              imagen: 'chat_${alerta.id}_solucion.png',
              lugar: Lugar.sala,
              personaje: guia,
              objeto: Icons.verified_user_rounded,
              globo: '¡Bien!',
              saludando: true,
            ),
            pie: '¡Tú tienes el control!',
          ),
          const SizedBox(height: 18),
          Align(
            alignment: Alignment.centerRight,
            child: _Aparecer(
              retraso: 300,
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: verdeWhatsApp,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(4),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  border: Border.all(color: const Color(0xFF7BC67B), width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Lo que tú haces:', style: Letras.titulo(size: 19, color: Paleta.aqua)),
                    const SizedBox(height: 8),
                    Text(
                      alerta.recomendacion,
                      style: const TextStyle(fontSize: 22, height: 1.4, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 6),
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Seguro ', style: TextStyle(fontSize: 14, color: Colors.black54)),
                        Icon(Icons.done_all_rounded, size: 20, color: Colors.blue),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MarcoEscena extends StatelessWidget {
  const _MarcoEscena({required this.escena, required this.pie});

  final Escena escena;
  final String pie;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Paleta.ciruela, width: 3),
      ),
      child: Column(
        children: [
          SizedBox(height: 200, child: EscenaAnimada(escena: escena, habla: true)),
          Container(
            width: double.infinity,
            color: Paleta.ciruela,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Text(pie, style: Letras.titulo(size: 17, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _ConsejoGuia extends StatelessWidget {
  const _ConsejoGuia({required this.texto, this.expresion = Expresion.feliz});

  final String texto;
  final Expresion expresion;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Personaje>(
      valueListenable: Asistente.actual,
      builder: (context, guia, _) => Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(color: guia.fondo, shape: BoxShape.circle),
            child: AvatarParlante(personaje: guia, tamano: 84, expresion: expresion),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Paleta.mostazaSuave,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Paleta.mostaza, width: 2),
              ),
              child: Text(
                texto,
                style: const TextStyle(fontSize: 18, height: 1.35, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Aparecer extends StatefulWidget {
  const _Aparecer({required this.child, this.retraso = 0});

  final Widget child;
  final int retraso;

  @override
  State<_Aparecer> createState() => _AparecerState();
}

class _AparecerState extends State<_Aparecer> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(Duration(milliseconds: widget.retraso), () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _c,
      child: SlideTransition(
        position: Tween(begin: const Offset(0, 0.3), end: Offset.zero)
            .animate(CurvedAnimation(parent: _c, curve: Curves.easeOutBack)),
        child: widget.child,
      ),
    );
  }
}

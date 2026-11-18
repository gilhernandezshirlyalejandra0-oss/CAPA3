import 'package:flutter/material.dart';

import '../services/asistente.dart';
import '../services/voz_humana.dart';
import '../theme/paleta.dart';
import '../widgets/avatar_parlante.dart';
import '../widgets/escena_animada.dart';
import '../widgets/fondos_dibujados.dart';
import '../widgets/reproductor_voz.dart';

/// Sección "Cuentos": anécdotas narradas de estafas y chisme informativo.
/// Los personajes son inventados, pero los trucos son los que se usan de verdad.
class CuentosScreen extends StatelessWidget {
  const CuentosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Paleta.crema,
        appBar: AppBar(
          backgroundColor: Paleta.crema,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text('Cuentos que enseñan', style: Letras.titulo(size: 24)),
          actions: const [BotonAjustesVoz(), SizedBox(width: 6)],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Paleta.arena,
                borderRadius: BorderRadius.circular(18),
              ),
              child: TabBar(
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: Paleta.papaya,
                  borderRadius: BorderRadius.circular(14),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Paleta.tinta,
                labelStyle: Letras.titulo(size: 16),
                tabs: const [
                  Tab(text: 'Anécdotas', icon: null),
                  Tab(text: 'Chisme informativo'),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [_ListaAnecdotas(), _ListaChismes()],
        ),
      ),
    );
  }
}

// ─────────────────────────── Anécdotas ───────────────────────────

class _Anecdota {
  const _Anecdota({
    required this.titulo,
    required this.protagonista,
    required this.icono,
    required this.fondo,
    required this.acento,
    required this.parrafos,
    required this.moraleja,
    required this.escenas,
  });

  final String titulo;
  final String protagonista;
  final IconData icono;
  final Color fondo;
  final Color acento;
  final List<String> parrafos;
  final String moraleja;

  /// Una escena por párrafo y una última para la moraleja.
  final List<Escena> escenas;

  String get textoNarrado =>
      '$titulo. ${parrafos.join(' ')} La moraleja de esta historia: $moraleja';

  /// En qué letra del texto narrado empieza cada parte (párrafos + moraleja).
  List<int> get inicios {
    final lista = <int>[];
    var pos = titulo.length + 2;
    for (final p in parrafos) {
      lista.add(pos);
      pos += p.length + 1;
    }
    lista.add(pos);
    return lista;
  }

  int escenaEn(int letra) {
    var i = 0;
    final ini = inicios;
    for (var k = 0; k < ini.length; k++) {
      if (letra >= ini[k]) i = k;
    }
    return i.clamp(0, escenas.length - 1);
  }

  int get minutos => (textoNarrado.split(' ').length / 130).ceil();
}

const List<_Anecdota> _anecdotas = [
  _Anecdota(
    titulo: 'Doña Carmen y el nieto que no era',
    protagonista: 'Carmen, 71 años, Bucaramanga',
    icono: Icons.phone_android_rounded,
    fondo: Paleta.ruborSuave,
    acento: Paleta.rubor,
    parrafos: [
      'Un martes en la mañana, mientras regaba las matas, a doña Carmen le llegó un WhatsApp: "Abuela, soy Andrés, se me dañó el celular y este es mi número nuevo".',
      'Al rato, el supuesto Andrés le contó que estaba varado y necesitaba 800 mil pesos para pagar una multa. "No le diga a mi mamá que me regaña", escribió.',
      'Doña Carmen ya iba camino al corresponsal cuando se acordó de algo: Andrés siempre le dice "Mamita Carmen", nunca "abuela". Lo llamó a su número de siempre… y Andrés estaba en clase, tranquilito.',
    ],
    moraleja:
        'Si alguien cambia de número y pide plata, llama al número viejo antes de mandar un solo peso.',
    escenas: [
      Escena(imagen: 'carmen_1.png', lugar: Lugar.casa, personaje: Asistente.carmen,
          objeto: Icons.phone_android_rounded, globo: '?'),
      Escena(imagen: 'carmen_2.png', lugar: Lugar.sala, personaje: Asistente.carmen,
          expresion: Expresion.preocupada, objeto: Icons.payments_rounded, globo: '¡Uy!'),
      Escena(imagen: 'carmen_3.png', lugar: Lugar.calle, personaje: Asistente.carmen,
          expresion: Expresion.sorprendida, objeto: Icons.lightbulb_rounded, globo: '¡Ajá!'),
      Escena(imagen: 'carmen_4.png', lugar: Lugar.sala, personaje: Asistente.carmen,
          acompanante: Asistente.andres, objeto: Icons.favorite_rounded, saludando: true),
    ],
  ),
  _Anecdota(
    titulo: 'El paquete que nunca existió',
    protagonista: 'Don Hernando, 66 años, Cali',
    icono: Icons.local_shipping_rounded,
    fondo: Paleta.mostazaSuave,
    acento: Paleta.mostaza,
    parrafos: [
      'A don Hernando le llegó un mensaje de texto: "Su paquete está retenido en aduana. Pague 6.900 pesos aquí para liberarlo", con un enlace azul.',
      'Como era poquita plata, tocó el enlace y puso los datos de la tarjeta. Esa misma noche le llegaron tres compras en el extranjero por casi dos millones.',
      'Él ni siquiera esperaba ningún paquete. El cobro chiquito era solo la carnada para robarle los datos de la tarjeta.',
    ],
    moraleja:
        'Si no compraste nada, no hay paquete. Nunca pongas tu tarjeta en un enlace que te llegó por mensaje.',
    escenas: [
      Escena(imagen: 'hernando_1.png', lugar: Lugar.casa, personaje: Asistente.hernando,
          objeto: Icons.local_shipping_rounded, globo: '?'),
      Escena(imagen: 'hernando_2.png', lugar: Lugar.sala, personaje: Asistente.hernando,
          expresion: Expresion.preocupada, objeto: Icons.credit_card_rounded, globo: '¡Uy!'),
      Escena(imagen: 'hernando_3.png', lugar: Lugar.oficina, personaje: Asistente.hernando,
          expresion: Expresion.sorprendida, objeto: Icons.receipt_long_rounded, globo: '!'),
      Escena(imagen: 'hernando_4.png', lugar: Lugar.casa, personaje: Asistente.hernando,
          objeto: Icons.block_rounded),
    ],
  ),
  _Anecdota(
    titulo: 'La llamada del "banco" a la hora del almuerzo',
    protagonista: 'Gloria, 69 años, Medellín',
    icono: Icons.account_balance_rounded,
    fondo: Paleta.aquaSuave,
    acento: Paleta.aqua,
    parrafos: [
      'Sonó el teléfono y una voz muy amable dijo: "Señora Gloria, le hablamos del área de seguridad del banco. Detectamos un movimiento raro en su cuenta".',
      'Le dijeron que para bloquearlo debía dictar un código de seis números que le iba a llegar. Ella sintió el corazón a mil.',
      'Pero Gloria había visto Escudo Mayor: "Mijo, el banco nunca pide esos números". Colgó, llamó a la línea que está detrás de su tarjeta y su cuenta estaba perfecta.',
    ],
    moraleja:
        'El código que llega al celular es la llave de tu cuenta. Ni el banco, ni nadie, te lo debe pedir.',
    escenas: [
      Escena(imagen: 'gloria_1.png', lugar: Lugar.casa, personaje: Asistente.gloria,
          expresion: Expresion.sorprendida, objeto: Icons.phone_in_talk_rounded, globo: '!'),
      Escena(imagen: 'gloria_2.png', lugar: Lugar.sala, personaje: Asistente.gloria,
          expresion: Expresion.preocupada, acompanante: Asistente.estafador,
          objeto: Icons.pin_rounded, globo: '?'),
      Escena(imagen: 'gloria_3.png', lugar: Lugar.oficina, personaje: Asistente.gloria,
          objeto: Icons.call_end_rounded, globo: '¡Ajá!'),
      Escena(imagen: 'gloria_4.png', lugar: Lugar.sala, personaje: Asistente.gloria,
          objeto: Icons.verified_user_rounded, saludando: true),
    ],
  ),
  _Anecdota(
    titulo: 'El amor que llegó por Facebook',
    protagonista: 'Rubén, 74 años, Barranquilla',
    icono: Icons.favorite_rounded,
    fondo: Paleta.papayaSuave,
    acento: Paleta.papaya,
    parrafos: [
      'Rubén conoció a "Valeria" en Facebook. Era muy cariñosa, le escribía todas las mañanas y le decía que quería venir a conocerlo desde España.',
      'Después de dos meses, ella le pidió ayuda para pagar el tiquete porque "le habían congelado la cuenta". Luego fue el hotel, luego un trámite…',
      'Su hija buscó las fotos de Valeria en internet y aparecieron en páginas de modelos. Valeria no existía.',
    ],
    moraleja:
        'Si alguien que nunca has visto en persona te pide plata, es una estafa, por bonitas que sean sus palabras.',
    escenas: [
      Escena(imagen: 'ruben_1.png', lugar: Lugar.sala, personaje: Asistente.ruben,
          objeto: Icons.favorite_rounded),
      Escena(imagen: 'ruben_2.png', lugar: Lugar.sala, personaje: Asistente.ruben,
          expresion: Expresion.preocupada, objeto: Icons.flight_rounded, globo: '?'),
      Escena(imagen: 'ruben_3.png', lugar: Lugar.casa, personaje: Asistente.ruben,
          expresion: Expresion.sorprendida, acompanante: Asistente.valentina,
          objeto: Icons.image_search_rounded, globo: '!'),
      Escena(imagen: 'ruben_4.png', lugar: Lugar.casa, personaje: Asistente.ruben,
          objeto: Icons.shield_rounded),
    ],
  ),
  _Anecdota(
    titulo: 'El subsidio que costaba plata',
    protagonista: 'Mercedes, 63 años, Pasto',
    icono: Icons.card_giftcard_rounded,
    fondo: Paleta.mostazaSuave,
    acento: Paleta.papaya,
    parrafos: [
      'En un grupo de WhatsApp del barrio circuló un mensaje: "Nuevo subsidio para adultos mayores de 1.200.000. Inscríbete aquí antes del viernes".',
      'Al entrar, la página pedía cédula, foto y… 50 mil pesos "para el estudio de la solicitud".',
      'Mercedes le preguntó a la vecina que trabaja en la alcaldía, y ella le explicó que los subsidios del gobierno nunca cobran por inscribirse.',
    ],
    moraleja:
        'Los programas del gobierno son gratis. Si te cobran por inscribirte, es trampa.',
    escenas: [
      Escena(imagen: 'mercedes_1.png', lugar: Lugar.casa, personaje: Asistente.mercedes,
          objeto: Icons.groups_rounded, globo: '?'),
      Escena(imagen: 'mercedes_2.png', lugar: Lugar.sala, personaje: Asistente.mercedes,
          expresion: Expresion.preocupada, objeto: Icons.attach_money_rounded, globo: '¡Uy!'),
      Escena(imagen: 'mercedes_3.png', lugar: Lugar.calle, personaje: Asistente.mercedes,
          expresion: Expresion.sorprendida, acompanante: Asistente.gloria,
          objeto: Icons.account_balance_rounded, globo: '!'),
      Escena(imagen: 'mercedes_4.png', lugar: Lugar.casa, personaje: Asistente.mercedes,
          objeto: Icons.check_circle_rounded),
    ],
  ),
];

class _ListaAnecdotas extends StatelessWidget {
  const _ListaAnecdotas();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
      itemCount: _anecdotas.length,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (context, i) {
        final a = _anecdotas[i];
        return _AparecerDeslizando(
          retraso: i * 90,
          child: _TarjetaPoster(
            onTap: () => Navigator.of(context).push(
              PageRouteBuilder<void>(
                transitionDuration: const Duration(milliseconds: 450),
                pageBuilder: (_, _, _) => _LectorAnecdota(anecdota: a, indice: i),
                transitionsBuilder: (_, anim, _, child) => SlideTransition(
                  position: Tween(begin: const Offset(0, 0.15), end: Offset.zero)
                      .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
                  child: FadeTransition(opacity: anim, child: child),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 190,
                  child: EscenaAnimada(escena: a.escenas.first),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(a.titulo, style: Letras.titulo(size: 22, height: 1.15)),
                      const SizedBox(height: 6),
                      Text(
                        a.protagonista,
                        style: const TextStyle(fontSize: 15, color: Paleta.tintaSuave),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _Chip(texto: 'Narrada', icono: Icons.headphones_rounded, color: a.acento),
                          const SizedBox(width: 8),
                          _Chip(
                            texto: '${a.minutos} min',
                            icono: Icons.schedule_rounded,
                            color: Paleta.ciruela,
                          ),
                          const Spacer(),
                          const Icon(Icons.arrow_forward_rounded, color: Paleta.tinta),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LectorAnecdota extends StatefulWidget {
  const _LectorAnecdota({required this.anecdota, required this.indice});

  final _Anecdota anecdota;
  final int indice;

  @override
  State<_LectorAnecdota> createState() => _LectorAnecdotaState();
}

class _LectorAnecdotaState extends State<_LectorAnecdota> {
  int _escena = 0;

  @override
  void initState() {
    super.initState();
    VozHumana.posicion.addListener(_seguirVoz);
    Future<void>.delayed(const Duration(milliseconds: 500), () {
      if (mounted) VozHumana.narrar(widget.anecdota.textoNarrado);
    });
  }

  /// Cambia la viñeta según la parte de la historia que se está leyendo.
  void _seguirVoz() {
    if (VozHumana.textoActual.value != widget.anecdota.textoNarrado) return;
    final nueva = widget.anecdota.escenaEn(VozHumana.posicion.value);
    if (nueva != _escena && mounted) setState(() => _escena = nueva);
  }

  @override
  void dispose() {
    VozHumana.posicion.removeListener(_seguirVoz);
    VozHumana.detener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.anecdota;
    return Scaffold(
      backgroundColor: Paleta.crema,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 300,
            backgroundColor: a.fondo,
            foregroundColor: Paleta.tinta,
            actions: const [BotonAjustesVoz(), SizedBox(width: 6)],
            flexibleSpace: FlexibleSpaceBar(
              background: SecuenciaEscenas(
                escenas: a.escenas,
                indice: _escena,
                habla: true,
                onCambiar: (i) => setState(() => _escena = i),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
            sliver: SliverList.list(
              children: [
                Text(a.titulo, style: Letras.titulo(size: 30, height: 1.1)),
                const SizedBox(height: 6),
                Text(a.protagonista,
                    style: const TextStyle(fontSize: 16, color: Paleta.tintaSuave)),
                const SizedBox(height: 16),
                _BotonEscuchar(texto: a.textoNarrado, color: a.acento),
                const SizedBox(height: 18),
                for (var i = 0; i < a.parrafos.length; i++)
                  _AparecerDeslizando(
                    retraso: 150 + i * 160,
                    child: GestureDetector(
                      onTap: () => setState(() => _escena = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 350),
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: i == _escena ? a.fondo : Colors.transparent,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: i == _escena ? a.acento : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          a.parrafos[i],
                          style: const TextStyle(fontSize: 22, height: 1.5, color: Paleta.tinta),
                        ),
                      ),
                    ),
                  ),
                _AparecerDeslizando(
                  retraso: 700,
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: a.acento,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: Paleta.ciruela, width: 3),
                      boxShadow: const [BoxShadow(color: Paleta.ciruela, offset: Offset(5, 5))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.lightbulb_rounded, color: Colors.white, size: 28),
                            const SizedBox(width: 8),
                            Text('La moraleja', style: Letras.titulo(size: 20, color: Colors.white)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          a.moraleja,
                          style: const TextStyle(
                            fontSize: 19,
                            height: 1.45,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const SafeArea(child: ReproductorVoz()),
    );
  }
}

// ───────────────────────── Chisme informativo ─────────────────────────

class _Chisme {
  const _Chisme({
    required this.gancho,
    required this.chisme,
    required this.dato,
    required this.color,
    required this.icono,
    required this.nivel,
  });

  final String gancho;
  final String chisme;
  final String dato;
  final Color color;
  final IconData icono;
  final String nivel;

  String get textoNarrado => '$gancho $chisme Y el dato que nadie te cuenta: $dato';
}

const List<_Chisme> _chismes = [
  _Chisme(
    gancho: '¿Ya supiste lo que le pasó a la señora del 302?',
    chisme:
        'Dicen que le llegó un correo "de la DIAN" diciendo que tenía una deuda y que si no pagaba ese mismo día le embargaban el apartamento. ¡Casi se desmaya!',
    dato:
        'La DIAN no cobra por correo con enlaces ni amenaza con embargos de un día para otro. Siempre se verifica en la página oficial escribiéndola tú mismo.',
    color: Paleta.papaya,
    icono: Icons.mark_email_unread_rounded,
    nivel: 'Muy común',
  ),
  _Chisme(
    gancho: 'Me contaron en la tienda de don Pacho…',
    chisme:
        'Que andan llamando a la gente diciendo que se ganaron una moto en un sorteo del supermercado, pero que para entregarla hay que pagar "los impuestos" por Nequi.',
    dato:
        'Si de verdad te ganas algo, nunca tienes que pagar para recibirlo. Ese "impuesto" es lo que se roban.',
    color: Paleta.mostaza,
    icono: Icons.two_wheeler_rounded,
    nivel: 'Va en aumento',
  ),
  _Chisme(
    gancho: 'Uy, ¿y lo de la voz clonada? ¡Qué miedo!',
    chisme:
        'A un señor lo llamaron con la voz idéntica de su hija llorando, pidiendo plata urgente. Ahora con inteligencia artificial pueden copiar una voz con unos segundos de audio.',
    dato:
        'Pónganse de acuerdo en familia con una "palabra secreta". Si te llaman con una emergencia, pídela. Los estafadores no la saben.',
    color: Paleta.rubor,
    icono: Icons.graphic_eq_rounded,
    nivel: 'Nuevo truco',
  ),
  _Chisme(
    gancho: 'Lo que pasó en el grupo de la parroquia…',
    chisme:
        'Alguien le robó el WhatsApp a doña Rosa y empezó a pedirle plata prestada a todos los del grupo, con su foto y todo.',
    dato:
        'Activa la "verificación en dos pasos" en WhatsApp (Ajustes, Cuenta). Así, aunque te roben el código, no pueden entrar a tu cuenta.',
    color: Paleta.aqua,
    icono: Icons.groups_rounded,
    nivel: 'Muy común',
  ),
  _Chisme(
    gancho: 'No me lo van a creer, pero en el cajero…',
    chisme:
        'Un muchacho muy amable se ofreció a ayudar a un abuelo que no podía sacar plata. Le cambió la tarjeta sin que se diera cuenta y vio la clave.',
    dato:
        'En el cajero no aceptes ayuda de desconocidos. Si algo falla, entra al banco o llama a la línea oficial.',
    color: Paleta.papaya,
    icono: Icons.atm_rounded,
    nivel: 'De toda la vida',
  ),
];

class _ListaChismes extends StatelessWidget {
  const _ListaChismes();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
      itemCount: _chismes.length + 1,
      separatorBuilder: (_, _) => const SizedBox(height: 14),
      itemBuilder: (context, i) {
        if (i == 0) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Paleta.ciruela,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Text('🤫', style: TextStyle(fontSize: 34)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Chisme del bueno: el que te cuida el bolsillo. Toca uno para escucharlo.',
                    style: Letras.titulo(size: 17, color: Colors.white, height: 1.25),
                  ),
                ),
              ],
            ),
          );
        }
        final c = _chismes[i - 1];
        return _AparecerDeslizando(
          retraso: i * 80,
          child: _TarjetaChisme(chisme: c),
        );
      },
    );
  }
}

class _TarjetaChisme extends StatefulWidget {
  const _TarjetaChisme({required this.chisme});

  final _Chisme chisme;

  @override
  State<_TarjetaChisme> createState() => _TarjetaChismeState();
}

class _TarjetaChismeState extends State<_TarjetaChisme> {
  bool _abierto = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.chisme;
    return _TarjetaPoster(
      onTap: () {
        setState(() => _abierto = !_abierto);
        if (_abierto) VozHumana.narrar(c.textoNarrado);
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: c.color,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(c.icono, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Chip(texto: c.nivel, icono: Icons.local_fire_department_rounded, color: c.color),
                      const SizedBox(height: 6),
                      Text(c.gancho, style: Letras.titulo(size: 19, height: 1.2)),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: _abierto ? 0.5 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: const Icon(Icons.expand_more_rounded, size: 30),
                ),
              ],
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState: _abierto ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              firstChild: const SizedBox(width: double.infinity),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Burbuja de "chisme"
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Paleta.arena,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(18),
                          bottomLeft: Radius.circular(18),
                          bottomRight: Radius.circular(18),
                        ),
                      ),
                      child: Text(
                        c.chisme,
                        style: const TextStyle(fontSize: 18, height: 1.45, color: Paleta.tinta),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: c.color.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: c.color, width: 2),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.verified_rounded, color: c.color, size: 26),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              c.dato,
                              style: const TextStyle(
                                fontSize: 18,
                                height: 1.4,
                                fontWeight: FontWeight.w800,
                                color: Paleta.tinta,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    _BotonEscuchar(texto: c.textoNarrado, color: c.color),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────── Piezas compartidas ─────────────────────────

class _TarjetaPoster extends StatefulWidget {
  const _TarjetaPoster({required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;

  @override
  State<_TarjetaPoster> createState() => _TarjetaPosterState();
}

class _TarjetaPosterState extends State<_TarjetaPoster> {
  bool _presionada = false;

  @override
  Widget build(BuildContext context) {
    final desplazamiento = _presionada ? 1.0 : 5.0;
    return GestureDetector(
      onTapDown: (_) => setState(() => _presionada = true),
      onTapCancel: () => setState(() => _presionada = false),
      onTapUp: (_) => setState(() => _presionada = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        transform: Matrix4.translationValues(5 - desplazamiento, 5 - desplazamiento, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Paleta.ciruela, width: 3),
          boxShadow: [
            BoxShadow(color: Paleta.ciruela, offset: Offset(desplazamiento, desplazamiento)),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: widget.child,
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.texto, required this.icono, required this.color});

  final String texto;
  final IconData icono;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: 16, color: color == Paleta.mostaza ? Paleta.tinta : color),
          const SizedBox(width: 4),
          Text(
            texto,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: color == Paleta.mostaza ? Paleta.tinta : color,
            ),
          ),
        ],
      ),
    );
  }
}

class _BotonEscuchar extends StatelessWidget {
  const _BotonEscuchar({required this.texto, required this.color});

  final String texto;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<EstadoVoz>(
      valueListenable: VozHumana.estado,
      builder: (context, estado, _) {
        final esEste = VozHumana.textoActual.value == texto;
        final hablandoEste = esEste && estado == EstadoVoz.hablando;
        final pausadoEste = esEste && estado == EstadoVoz.pausado;
        return SizedBox(
          width: double.infinity,
          height: 54,
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: color,
              foregroundColor: color == Paleta.mostaza ? Paleta.tinta : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: () {
              if (hablandoEste || pausadoEste) {
                VozHumana.alternar();
              } else {
                VozHumana.hablar(texto);
              }
            },
            icon: Icon(
              hablandoEste ? Icons.pause_rounded : Icons.play_arrow_rounded,
              size: 28,
            ),
            label: Text(
              hablandoEste
                  ? 'Pausar'
                  : pausadoEste
                      ? 'Continuar'
                      : 'Escuchar historia',
              style: Letras.titulo(
                size: 18,
                color: color == Paleta.mostaza ? Paleta.tinta : Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Aparece subiendo y desvaneciéndose, con un pequeño retraso.
class _AparecerDeslizando extends StatefulWidget {
  const _AparecerDeslizando({required this.child, this.retraso = 0});

  final Widget child;
  final int retraso;

  @override
  State<_AparecerDeslizando> createState() => _AparecerDeslizandoState();
}

class _AparecerDeslizandoState extends State<_AparecerDeslizando>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 520),
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
    final curva = CurvedAnimation(parent: _c, curve: Curves.easeOutBack);
    return FadeTransition(
      opacity: _c,
      child: SlideTransition(
        position: Tween(begin: const Offset(0, 0.25), end: Offset.zero).animate(curva),
        child: widget.child,
      ),
    );
  }
}

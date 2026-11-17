import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/asistente.dart';
import '../services/voz_humana.dart';
import '../theme/paleta.dart';
import '../widgets/avatar_parlante.dart';
import '../widgets/fondos_dibujados.dart';
import '../widgets/logo_escudo.dart';

/// Primera pantalla: logo de Escudo Mayor, letras que saltan y los
/// personajes que salen a saludar. Luego pasa a elegir personaje.
class BienvenidaScreen extends StatefulWidget {
  const BienvenidaScreen({super.key});

  @override
  State<BienvenidaScreen> createState() => _BienvenidaScreenState();
}

class _BienvenidaScreenState extends State<BienvenidaScreen> {
  bool _personajes = false;
  bool _boton = false;

  static const _saludo =
      '¡Bienvenidos a Escudo Mayor! Aquí aprendemos juntos, con cuentos y dibujos, a cuidarnos de los engaños por el celular.';

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 1700), () {
      if (mounted) setState(() => _personajes = true);
    });
    Future<void>.delayed(const Duration(milliseconds: 2600), () async {
      if (!mounted) return;
      setState(() => _boton = true);
      final luna = Asistente.todos.first;
      await VozHumana.usarPersonaje(
        femenina: luna.genero == GeneroVoz.femenina,
        tono: luna.tono,
        ritmo: luna.ritmo,
      );
      await VozHumana.narrar(_saludo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: FondoLugar(lugar: Lugar.casa)),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, c) {
                final tamPersonaje = (c.maxWidth / 4.4).clamp(70.0, 110.0);
                return Column(
                  children: [
                    const SizedBox(height: 20),
                    // Cartel con el logo y el nombre
                    Flexible(
                      flex: 5,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.fromLTRB(28, 18, 28, 20),
                      decoration: BoxDecoration(
                        color: Paleta.crema.withValues(alpha: 0.94),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: const Color(0xFF8A5A3B), width: 4),
                        boxShadow: const [
                          BoxShadow(color: Color(0x33000000), blurRadius: 18, offset: Offset(0, 8)),
                        ],
                      ),
                      child: const Column(
                        children: [
                          LogoEscudo(tamano: 120),
                          SizedBox(height: 10),
                          TituloSaltarin(
                              texto: 'ESCUDO',
                              tamano: 56,
                              retraso: Duration(milliseconds: 400),
                            ),
                          SizedBox(height: 2),
                          TituloSaltarin(
                              texto: 'MAYOR',
                              tamano: 56,
                              retraso: Duration(milliseconds: 800),
                              colores: [Paleta.aqua, Paleta.rubor, Paleta.mostaza, Paleta.papaya],
                            ),
                        ],
                      ),
                    ),
                      ),
                    ),
                    const Spacer(),
                    // Burbuja de bienvenida
                    AnimatedOpacity(
                      opacity: _boton ? 1 : 0,
                      duration: const Duration(milliseconds: 500),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 22),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Text(
                          '¡Hola! Qué alegría tenerte aquí',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Paleta.tinta,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Los cuatro personajes salen saltando a saludar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < Asistente.todos.length; i++)
                          AnimatedSlide(
                            offset: _personajes ? Offset.zero : const Offset(0, 1.6),
                            duration: Duration(milliseconds: 650 + i * 140),
                            curve: Curves.elasticOut,
                            child: AvatarParlante(
                              personaje: Asistente.todos[i],
                              tamano: tamPersonaje,
                              saludando: true,
                              hablaConLaVoz: i == 0,
                            ),
                          ),
                      ],
                    ),
                    Container(
                      color: Paleta.crema,
                      padding: const EdgeInsets.fromLTRB(22, 14, 22, 18),
                      child: AnimatedScale(
                        scale: _boton ? 1 : 0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOutBack,
                        child: SizedBox(
                          width: double.infinity,
                          height: 68,
                          child: FilledButton(
                            onPressed: () {
                              VozHumana.detener();
                              context.go('/intro');
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: Paleta.papaya,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              'Entrar',
                              style: Letras.titulo(size: 26, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

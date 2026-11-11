import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/repositorio_alertas.dart';
import '../models/alerta_seguridad.dart';
import '../viewmodels/alertas_viewmodel.dart';

const Color azulPrincipal = Color(0xFF1557A6);
const Color azulOscuro = Color(0xFF153B66);
const Color verdePrincipal = Color(0xFF159B83);
const Color fondoClaro = Color(0xFFF2F7FC);

class AlertasScreen extends StatelessWidget {
  const AlertasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AlertasViewModel()..cargar(),
      child: const _ContenidoAlertas(),
    );
  }
}

class _ContenidoAlertas extends StatelessWidget {
  const _ContenidoAlertas();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AlertasViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FF),
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.85),
        foregroundColor: azulOscuro,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Reconoce los engaños',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
          ),
        ),
        actions: [
          if (kDebugMode)
            PopupMenuButton<EscenarioAlerta>(
              tooltip: 'Probar escenarios',
              onSelected: vm.cambiarEscenario,
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: EscenarioAlerta.conDatos,
                  child: Text('Probar: con datos'),
                ),
                PopupMenuItem(
                  value: EscenarioAlerta.vacio,
                  child: Text('Probar: lista vacía'),
                ),
                PopupMenuItem(
                  value: EscenarioAlerta.falla,
                  child: Text('Probar: error'),
                ),
                PopupMenuItem(
                  value: EscenarioAlerta.cargando,
                  child: Text('Probar: cargando'),
                ),
              ],
            ),
        ],
      ),
      body: _construirContenido(context, vm),
    );
  }

  Widget _construirContenido(BuildContext context, AlertasViewModel vm) {
    switch (vm.estado) {
      case EstadoAlertas.cargando:
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF4F8FF), Color(0xFFEAF4FF)],
            ),
          ),
          child: const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: verdePrincipal),
                SizedBox(height: 16),
                Text(
                  'Preparando tus ejemplos...',
                  style: TextStyle(
                    fontSize: 18,
                    color: azulOscuro,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );

      case EstadoAlertas.vacio:
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF4F8FF), Color(0xFFEAF4FF)],
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.all(28),
                constraints: const BoxConstraints(maxWidth: 420),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: azulPrincipal.withValues(alpha: 0.12),
                      blurRadius: 24,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 94,
                      height: 94,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9F2FF),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: const Icon(
                        Icons.menu_book_outlined,
                        size: 52,
                        color: azulPrincipal,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Todavía no hay ejemplos disponibles.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        color: azulOscuro,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton.icon(
                      onPressed: vm.cargar,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Volver a intentar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: azulPrincipal,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

      case EstadoAlertas.error:
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF4F8FF), Color(0xFFEAF4FF)],
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.all(28),
                constraints: const BoxConstraints(maxWidth: 420),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 94,
                      height: 94,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFECEC),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: const Icon(
                        Icons.error_outline_rounded,
                        size: 52,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      vm.mensajeError,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        color: azulOscuro,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton.icon(
                      onPressed: vm.cargar,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Reintentar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade500,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

      case EstadoAlertas.listo:
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF4F8FF), Color(0xFFE9F1FF), Color(0xFFF5F9FF)],
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 32),
            children: [
              _HeroAlertas(),
              const SizedBox(height: 24),
              const Row(
                children: [
                  Icon(Icons.local_library_rounded, color: azulPrincipal, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Situaciones para aprender',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: azulOscuro,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Selecciona un ejemplo para descubrir cómo reconocerlo.',
                style: TextStyle(fontSize: 16, color: Color(0xFF53677F)),
              ),
              const SizedBox(height: 18),
              for (int index = 0; index < vm.alertas.length; index++) ...[
                _TarjetaEjemplo(
                  alerta: vm.alertas[index],
                  numero: index + 1,
                  onTap: () => _mostrarDetalle(context, vm.alertas[index]),
                ),
                const SizedBox(height: 14),
              ],
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2F5EF),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFBFE6D8)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.favorite_rounded, color: verdePrincipal, size: 30),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Recuerda: tomarte un momento para verificar un mensaje puede ayudarte a evitar engaños.',
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.4,
                          color: azulOscuro,
                          fontWeight: FontWeight.w700,
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

  void _mostrarDetalle(BuildContext context, AlertaSeguridad alerta) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DetalleAlertaScreen(alerta: alerta),
      ),
    );
  }
}

class _HeroAlertas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1557A6),
            Color(0xFF1B6FCA),
            Color(0xFF2B97D8),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: azulPrincipal.withValues(alpha: 0.25),
            blurRadius: 24,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            top: -16,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 28,
            bottom: -18,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shield_outlined, color: Colors.white, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'Aprende y protege',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Icon(Icons.lightbulb_outline, color: Colors.white, size: 46),
              const SizedBox(height: 14),
              const Text(
                '¡Aprende a reconocer los engaños!',
                style: TextStyle(
                  fontSize: 28,
                  height: 1.2,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Conoce situaciones que pueden ocurrir por mensajes, correos o WhatsApp. '
                'Identifica señales claras y actúa con calma.',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TarjetaEjemplo extends StatelessWidget {
  const _TarjetaEjemplo({
    required this.alerta,
    required this.numero,
    required this.onTap,
  });

  final AlertaSeguridad alerta;
  final int numero;
  final VoidCallback onTap;

  IconData get icono {
    switch (alerta.tipo) {
      case 'SMS':
        return Icons.sms_rounded;
      case 'WhatsApp':
        return Icons.chat_rounded;
      case 'Correo electrónico':
        return Icons.email_rounded;
      default:
        return Icons.message_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: azulPrincipal.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: const Color(0xFFE0EAF4)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFEAF3FF), Color(0xFFDDEEFF)],
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(icono, color: azulPrincipal, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EJEMPLO $numero',
                        style: const TextStyle(
                          color: verdePrincipal,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        alerta.titulo,
                        style: const TextStyle(
                          color: azulOscuro,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        alerta.tipo,
                        style: const TextStyle(
                          color: Color(0xFF53677F),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Row(
                        children: [
                          Text(
                            'Aprender a reconocerlo',
                            style: TextStyle(
                              color: azulPrincipal,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.arrow_forward_rounded, color: azulPrincipal, size: 18),
                        ],
                      ),
                    ],
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

class DetalleAlertaScreen extends StatelessWidget {
  const DetalleAlertaScreen({super.key, required this.alerta});

  final AlertaSeguridad alerta;

  @override
  Widget build(BuildContext context) {
    final Color chipColor = alerta.nivelRiesgo == 'Alto'
        ? const Color(0xFFFFE7E7)
        : const Color(0xFFEAF8F2);
    final Color chipTextColor = alerta.nivelRiesgo == 'Alto'
        ? const Color(0xFFB42318)
        : const Color(0xFF0F766E);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FF),
      appBar: AppBar(
        title: const Text('Aprende a reconocerlo'),
        backgroundColor: Colors.white.withValues(alpha: 0.82),
        foregroundColor: azulOscuro,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFEAF3FF), Color(0xFFF5F7FF)],
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xFFD9E7F8)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: azulPrincipal.withValues(alpha: 0.10),
                            blurRadius: 16,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.school_rounded,
                        color: azulPrincipal,
                        size: 34,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: chipColor,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'Riesgo ${alerta.nivelRiesgo}',
                        style: TextStyle(
                          color: chipTextColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  alerta.titulo,
                  style: const TextStyle(
                    fontSize: 28,
                    height: 1.2,
                    color: azulOscuro,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'Medio: ${alerta.tipo}',
                    style: const TextStyle(
                      fontSize: 15,
                      color: azulOscuro,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  alerta.descripcion,
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1.5,
                    color: azulOscuro,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _TituloSeccion(
            icono: Icons.chat_bubble_outline_rounded,
            titulo: 'Ejemplo de mensaje ficticio',
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFD8E4F0)),
              boxShadow: [
                BoxShadow(
                  color: azulPrincipal.withValues(alpha: 0.05),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Text(
              alerta.mensajeEjemplo,
              style: const TextStyle(
                fontSize: 19,
                height: 1.6,
                color: azulOscuro,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Este mensaje es inventado y se utiliza únicamente para aprender.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF526579),
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 26),
          _TituloSeccion(
            icono: Icons.visibility_rounded,
            titulo: 'Señales que debes reconocer',
          ),
          const SizedBox(height: 12),
          for (final senal in alerta.senales)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4DF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFEAD9A8)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Color(0xFFB7791F),
                      size: 27,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        senal,
                        style: const TextStyle(
                          fontSize: 17,
                          height: 1.4,
                          color: azulOscuro,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
          _TituloSeccion(
            icono: Icons.shield_rounded,
            titulo: '¿Qué debes hacer?',
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(19),
            decoration: BoxDecoration(
              color: const Color(0xFFE2F5EF),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFBDE7D5)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: verdePrincipal,
                  size: 30,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    alerta.recomendacion,
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1.5,
                      color: azulOscuro,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            height: 58,
            child: FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text(
                'Volver a los ejemplos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: azulPrincipal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                minimumSize: const Size.fromHeight(58),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _TituloSeccion extends StatelessWidget {
  const _TituloSeccion({required this.icono, required this.titulo});

  final IconData icono;
  final String titulo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF3FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icono, color: azulPrincipal, size: 24),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            titulo,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: azulOscuro,
            ),
          ),
        ),
      ],
    );
  }
}

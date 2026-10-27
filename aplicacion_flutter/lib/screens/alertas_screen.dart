import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../data/repositorio_alertas.dart';
import '../models/alerta_seguridad.dart';
import '../viewmodels/alertas_viewmodel.dart';

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
      appBar: AppBar(
        title: const Text('Alertas de seguridad'),
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
                  child: Text('Probar: lista vac\u00EDa'),
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
        return const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Cargando alertas de seguridad...',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        );

      case EstadoAlertas.vacio:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.inbox_outlined, size: 64),
                const SizedBox(height: 16),
                const Text(
                  'No hay alertas para mostrar.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: vm.cargar,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Volver a cargar'),
                ),
              ],
            ),
          ),
        );

      case EstadoAlertas.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 64),
                const SizedBox(height: 16),
                Text(
                  vm.mensajeError,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: vm.cargar,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        );

      case EstadoAlertas.listo:
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: vm.alertas.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final alerta = vm.alertas[index];

            return Card(
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  child: Icon(_iconoRiesgo(alerta.nivelRiesgo)),
                ),
                title: Text(
                  alerta.titulo,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Tipo: ${alerta.tipo}\n'
                    'Nivel de riesgo: ${alerta.nivelRiesgo}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _mostrarDetalle(context, alerta),
              ),
            );
          },
        );
    }
  }

  IconData _iconoRiesgo(String nivel) {
    if (nivel.toLowerCase() == 'alto') {
      return Icons.warning_amber_rounded;
    }
    return Icons.shield_outlined;
  }

  void _mostrarDetalle(BuildContext context, AlertaSeguridad alerta) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DetalleAlertaScreen(alerta: alerta),
      ),
    );
  }
}

class DetalleAlertaScreen extends StatelessWidget {
  const DetalleAlertaScreen({super.key, required this.alerta});

  final AlertaSeguridad alerta;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de la alerta')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Icon(
            alerta.nivelRiesgo.toLowerCase() == 'alto'
                ? Icons.warning_amber_rounded
                : Icons.shield_outlined,
            size: 72,
          ),
          const SizedBox(height: 20),
          Text(alerta.titulo, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 20),
          Text(
            'Tipo de mensaje: ${alerta.tipo}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 12),
          Text(
            'Nivel de riesgo: ${alerta.nivelRiesgo}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          const Text(
            'Descripci\u00F3n',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(alerta.descripcion, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Volver a las alertas'),
          ),
        ],
      ),
    );
  }
}

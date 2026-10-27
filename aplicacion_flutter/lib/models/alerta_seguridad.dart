class AlertaSeguridad {
  const AlertaSeguridad({
    required this.id,
    required this.titulo,
    required this.tipo,
    required this.nivelRiesgo,
    required this.descripcion,
  });

  final int id;
  final String titulo;
  final String tipo;
  final String nivelRiesgo;
  final String descripcion;
}

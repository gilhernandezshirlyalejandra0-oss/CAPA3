import 'package:flutter_test/flutter_test.dart';
import 'package:fortaleza_cibernetica/main.dart';

void main() {
  testWidgets('La pantalla de bienvenida muestra las opciones principales', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FortalezaApp());

    expect(find.text('Fortaleza Cibernética'), findsOneWidget);
    expect(find.text('Revisar un enlace'), findsOneWidget);
    expect(find.text('Analizar un mensaje'), findsOneWidget);
    expect(find.text('Aprender sobre seguridad'), findsOneWidget);
    expect(find.text('Consultar un riesgo'), findsOneWidget);
  });
}

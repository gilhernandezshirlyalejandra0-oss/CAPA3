import 'package:flutter_test/flutter_test.dart';
import 'package:fortaleza_cibernetica/main.dart';

void main() {
  testWidgets('Carga inicial de Escudo Mayor', (WidgetTester tester) async {
    await tester.pumpWidget(const EscudoMayorApp());
    await tester.pump(const Duration(seconds: 3));
    // El título se dibuja letra por letra, así que se revisa el botón de entrada.
    expect(find.text('Entrar'), findsOneWidget);
  });
}
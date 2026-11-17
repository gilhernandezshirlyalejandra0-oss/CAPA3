import 'package:flutter_test/flutter_test.dart';
import 'package:fortaleza_cibernetica/main.dart';

void main() {
  testWidgets('Carga inicial de Escudo Mayor', (WidgetTester tester) async {
    await tester.pumpWidget(const EscudoMayorApp());
    expect(find.text('ESCUDO MAYOR'), findsOneWidget);
  });
}
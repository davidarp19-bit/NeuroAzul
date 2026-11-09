import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('El entorno de pruebas de NeuroAzul renderiza correctamente', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Center(child: Text('NeuroAzul'))),
      ),
    );

    expect(find.text('NeuroAzul'), findsOneWidget);
  });
}

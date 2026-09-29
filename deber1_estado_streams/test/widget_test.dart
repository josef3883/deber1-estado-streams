// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:deber1_estado_streams/main.dart';
import 'package:deber1_estado_streams/domain/repositories/contador_repository.dart';
import 'package:deber1_estado_streams/domain/usecases/decrementar.dart';
import 'package:deber1_estado_streams/domain/usecases/incrementar.dart';
import 'package:deber1_estado_streams/domain/usecases/obtener_contador.dart';

void main() {
  testWidgets('controla el contador y devuelve el valor al visor', (
    WidgetTester tester,
  ) async {
    final repository = _FakeContadorRepository(2);

    await tester.pumpWidget(
      MyApp(
        obtenerContador: ObtenerContador(repository),
        incrementar: Incrementar(repository),
        decrementar: Decrementar(repository),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Contador: 2'), findsOneWidget);

    await tester.tap(find.text('Ir a Control'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('+1'));
    await tester.pumpAndSettle();
    expect(find.text('Contador: 3'), findsOneWidget);

    await tester.tap(find.text('Volver'));
    await tester.pumpAndSettle();
    expect(find.text('Contador: 3'), findsOneWidget);
  });
}

class _FakeContadorRepository implements ContadorRepository {
  _FakeContadorRepository(this.valor);

  int valor;

  @override
  Future<int> leer() async => valor;

  @override
  Future<void> guardar(int valor) async {
    this.valor = valor;
  }
}

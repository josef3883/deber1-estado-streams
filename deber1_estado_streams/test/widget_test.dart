// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:deber1_estado_streams/main.dart';
import 'package:deber1_estado_streams/domain/repositories/contador_repository.dart';
import 'package:deber1_estado_streams/presentation/estado/contador_provider.dart';

void main() {
  testWidgets('contador se controla y persiste al volver al visor', (
    WidgetTester tester,
  ) async {
    final repository = _FakeContadorRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [contadorRepositoryProvider.overrideWithValue(repository)],
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('0'), findsOneWidget);

    await tester.tap(find.byTooltip('Control'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Incrementar'));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
    expect(repository.valor, 1);
  });
}

class _FakeContadorRepository implements ContadorRepository {
  int valor = 0;

  @override
  Future<int> leer() async => valor;

  @override
  Future<void> guardar(int valor) async {
    this.valor = valor;
  }
}

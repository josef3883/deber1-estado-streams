// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:deber1_estado_streams/main.dart';
import 'package:deber1_estado_streams/domain/repositories/contador_repository.dart';
import 'package:deber1_estado_streams/domain/usecases/decrementar.dart';
import 'package:deber1_estado_streams/domain/usecases/incrementar.dart';
import 'package:deber1_estado_streams/domain/usecases/obtener_contador.dart';
import 'package:deber1_estado_streams/presentation/estado/contador_cubit.dart';

void main() {
  testWidgets('contador se conserva al volver de la pantalla de control', (
    WidgetTester tester,
  ) async {
    final repository = _FakeContadorRepository();
    await tester.pumpWidget(
      BlocProvider(
        create: (_) => ContadorCubit(
          ObtenerContador(repository),
          Incrementar(repository),
          Decrementar(repository),
        )..cargar(),
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

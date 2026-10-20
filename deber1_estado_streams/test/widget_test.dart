import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:deber1_estado_streams/data/repositories/contador_prefs_repository.dart';
import 'package:deber1_estado_streams/domain/usecases/obtener_contador.dart';
import 'package:deber1_estado_streams/domain/usecases/incrementar.dart';
import 'package:deber1_estado_streams/domain/usecases/decrementar.dart';
import 'package:deber1_estado_streams/presentation/app.dart';
import 'package:deber1_estado_streams/presentation/estado/contador_cubit.dart';

void main() {
  for (final version in ['setstate', 'riverpod', 'cubit']) {
    for (final volver in ['Volver', 'flecha']) {
      testWidgets('$version persiste y actualiza al regresar con $volver', (
        tester,
      ) async {
        var disco = 3;
        final repo = ContadorPrefsRepository(
          leer: () async => disco,
          guardar: (valor) async {
            disco = valor;
          },
        );
        await tester.pumpWidget(
          ContadorApp(
            version: version,
            obtener: ObtenerContador(repo),
            incrementar: Incrementar(repo),
            decrementar: Decrementar(repo),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Contador: 3'), findsOneWidget);
        await tester.tap(find.text('Ir a Control'));
        await tester.pumpAndSettle();
        // Cambiar, regresar y reconstruir conserva el valor guardado.
        await tester.tap(find.text('+1'));
        await tester.pumpAndSettle();
        expect(disco, 4);
        await tester.tap(find.text('-1'));
        await tester.pumpAndSettle();
        expect(disco, 3);
        await tester.tap(find.text('+1'));
        await tester.pumpAndSettle();
        if (volver == 'Volver') {
          await tester.tap(find.text('Volver'));
        } else {
          await tester.tap(find.byType(BackButton));
        }
        await tester.pumpAndSettle();
        expect(find.text('Contador: 4'), findsOneWidget);
        expect(disco, 4);
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpAndSettle();
        // Simula reiniciar la UI conservando el almacenamiento.
        await tester.pumpWidget(
          ContadorApp(
            version: version,
            obtener: ObtenerContador(repo),
            incrementar: Incrementar(repo),
            decrementar: Decrementar(repo),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Contador: 4'), findsOneWidget);
      });
    }
  }
  test('BlocObserver imprime la transicion 3 -> 4', () async {
    var valor = 3;
    final repo = ContadorPrefsRepository(
      leer: () async => valor,
      guardar: (nuevo) async {
        valor = nuevo;
      },
    );
    final cubit = ContadorCubit(
      ObtenerContador(repo),
      Incrementar(repo),
      Decrementar(repo),
    );
    final mensajes = <String>[];
    final observer = RegistroContador(mensajes.add);
    await cubit.cargar();
    final antes = cubit.state;
    await cubit.incrementar();
    // El formato del observer se verifica sin depender de la consola.
    observer.onChange(
      cubit,
      Change(currentState: antes, nextState: cubit.state),
    );
    expect(mensajes, contains('ContadorCubit: 3 -> 4'));
    await cubit.close();
  });
}

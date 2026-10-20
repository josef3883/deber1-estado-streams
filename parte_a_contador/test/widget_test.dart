import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:deber1_estado_streams/domain/repositories/contador_repository.dart';
import 'package:deber1_estado_streams/main.dart';

class RepositorioPrueba implements ContadorRepository {
  int valor = 3;
  @override
  Future<int> leer() async => valor;
  @override
  Future<void> guardar(int nuevo) async {
    valor = nuevo;
  }
}

void main() {
  for (final volver in ['Volver', 'flecha', 'sistema']) {
    testWidgets('persiste y actualiza al regresar con $volver', (tester) async {
      final repo = RepositorioPrueba();
      await tester.pumpWidget(crearApp(repo));
      await tester.pumpAndSettle();
      expect(find.text('Contador: 3'), findsOneWidget);
      await tester.tap(find.text('Ir a Control'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('+1'));
      await tester.pumpAndSettle();
      expect(repo.valor, 4);
      await tester.tap(find.text('-1'));
      await tester.pumpAndSettle();
      expect(repo.valor, 3);
      await tester.tap(find.text('+1'));
      await tester.pumpAndSettle();
      if (volver == 'Volver') {
        await tester.tap(find.text('Volver'));
      } else if (volver == 'flecha') {
        await tester.tap(find.byType(BackButton));
      } else {
        await tester.binding.handlePopRoute();
      }
      await tester.pumpAndSettle();
      expect(find.text('Contador: 4'), findsOneWidget);
      expect(repo.valor, 4);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      await tester.pumpWidget(crearApp(repo));
      await tester.pumpAndSettle();
      expect(find.text('Contador: 4'), findsOneWidget);
    });
  }
}

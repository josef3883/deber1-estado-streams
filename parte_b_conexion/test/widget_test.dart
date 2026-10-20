import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parte_b_conexion/domain/entities/estado_conexion.dart';
import 'package:parte_b_conexion/domain/repositories/conexion_repository.dart';
import 'package:parte_b_conexion/domain/usecases/consultar_conexion.dart';
import 'package:parte_b_conexion/domain/usecases/observar_conexion.dart';
import 'package:parte_b_conexion/presentation/estado/conexion_cubit.dart';
import 'package:parte_b_conexion/presentation/app.dart';

class ConexionPrueba implements ConexionRepository {
  EstadoConexion actual = EstadoConexion.wifi;
  int escuchas = 0;
  int cancelaciones = 0;
  late final controlador = StreamController<EstadoConexion>.broadcast(
    onListen: () {
      escuchas++;
    },
    onCancel: () {
      cancelaciones++;
    },
  );
  Completer<EstadoConexion>? pendiente;
  @override
  Future<EstadoConexion> consultarAhora() =>
      pendiente?.future ?? Future.value(actual);
  @override
  Stream<EstadoConexion> observarCambios() => controlador.stream;
  void cambiar(EstadoConexion estado) {
    actual = estado;
    controlador.add(estado);
  }
}

void main() {
  test('iniciar es idempotente y close cancela la escucha', () async {
    final repo = ConexionPrueba();
    final cubit = ConexionCubit(
      ConsultarConexion(repo),
      ObservarConexion(repo),
    );
    expect(cubit.state, EstadoConexion.otro);
    await Future.wait([cubit.iniciar(), cubit.iniciar()]);
    expect(repo.escuchas, 1);
    expect(cubit.state, EstadoConexion.wifi);
    repo.cambiar(EstadoConexion.sinConexion);
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state, EstadoConexion.sinConexion);
    await cubit.close();
    expect(repo.cancelaciones, 1);
    await repo.controlador.close();
  });
  test('consulta el estado antes de suscribirse', () async {
    final repo = ConexionPrueba()..pendiente = Completer();
    final cubit = ConexionCubit(
      ConsultarConexion(repo),
      ObservarConexion(repo),
    );
    final inicio = cubit.iniciar();
    expect(repo.escuchas, 0);
    repo.pendiente!.complete(EstadoConexion.wifi);
    await inicio;
    expect(cubit.state, EstadoConexion.wifi);
    expect(repo.escuchas, 1);
    await cubit.close();
    await repo.controlador.close();
  });
  test('cerrar mientras consulta no emite despues de close', () async {
    final repo = ConexionPrueba()..pendiente = Completer();
    final cubit = ConexionCubit(
      ConsultarConexion(repo),
      ObservarConexion(repo),
    );
    final inicio = cubit.iniciar();
    await cubit.close();
    repo.pendiente!.complete(EstadoConexion.wifi);
    await inicio;
    expect(cubit.isClosed, isTrue);
    expect(repo.cancelaciones, 0);
    expect(repo.escuchas, 0);
    await repo.controlador.close();
  });
  testWidgets('Future conserva la foto y Stream cambia sin pulsar consultar', (
    tester,
  ) async {
    final repo = ConexionPrueba();
    await tester.pumpWidget(
      ConexionApp(
        consultar: ConsultarConexion(repo),
        observar: ObservarConexion(repo),
      ),
    );
    await tester.tap(find.text('Consultar ahora'));
    await tester.pumpAndSettle();
    expect(find.text('Wi-Fi'), findsOneWidget);
    expect(
      find.textContaining(RegExp(r'Consulta: \d{2}:\d{2}:\d{2}')),
      findsOneWidget,
    );
    await tester.tap(find.text('Con Stream'));
    await tester.pumpAndSettle();
    expect(find.text('Wi-Fi'), findsOneWidget);
    repo.cambiar(EstadoConexion.sinConexion);
    await tester.pumpAndSettle();
    expect(find.text('Sin conexion'), findsOneWidget);
    expect(find.textContaining('Cambios recibidos:'), findsOneWidget);
    await tester.tap(find.text('Con Future'));
    await tester.pumpAndSettle();
    expect(find.text('Wi-Fi'), findsOneWidget);
    await tester.tap(find.text('Consultar ahora'));
    await tester.pumpAndSettle();
    expect(find.text('Sin conexion'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await repo.controlador.close();
  });
}

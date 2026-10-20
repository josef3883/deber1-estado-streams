import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/usecases/obtener_contador.dart';
import '../domain/usecases/incrementar.dart';
import '../domain/usecases/decrementar.dart';
import 'estado/contador_cubit.dart';
import 'estado/contador_provider.dart';
import 'pantallas/contador_setstate.dart';
import 'pantallas/contador_compartido.dart';
import 'seleccion.dart';

class ContadorApp extends StatelessWidget {
  const ContadorApp({
    super.key,
    required this.obtener,
    required this.incrementar,
    required this.decrementar,
    this.version = const String.fromEnvironment(
      'VERSION',
      defaultValue: versionPredeterminada,
    ),
  });
  final ObtenerContador obtener;
  final Incrementar incrementar;
  final Decrementar decrementar;
  final String version;

  @override
  Widget build(BuildContext context) {
    final Widget app;
    switch (version) {
      case 'riverpod':
        app = ProviderScope(
          overrides: [
            obtenerProvider.overrideWithValue(obtener),
            sumarProvider.overrideWithValue(incrementar),
            restarProvider.overrideWithValue(decrementar),
          ],
          child: const MaterialApp(home: PantallaRiverpod()),
        );
      case 'cubit':
        Bloc.observer = RegistroContador(debugPrint);
        app = BlocProvider(
          create: (_) =>
              ContadorCubit(obtener, incrementar, decrementar)..cargar(),
          child: const MaterialApp(home: PantallaCubit()),
        );
      default:
        app = MaterialApp(
          home: PantallaSetState(
            obtener: obtener,
            incrementar: incrementar,
            decrementar: decrementar,
          ),
        );
    }
    return app;
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/repositories/contador_prefs_repository.dart';
import 'domain/repositories/contador_repository.dart';
import 'domain/usecases/obtener_contador.dart';
import 'domain/usecases/incrementar.dart';
import 'domain/usecases/decrementar.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'presentation/estado/contador_cubit.dart';
import 'presentation/pantallas/pantalla_visor.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferencias = await SharedPreferences.getInstance();
  final repositorio = ContadorPrefsRepository(
    leer: () async => preferencias.getInt('contador') ?? 0,
    guardar: (valor) async {
      if (!await preferencias.setInt('contador', valor)) {
        throw StateError('No se pudo guardar el contador');
      }
    },
  );
  runApp(crearApp(repositorio));
}

Widget crearApp(ContadorRepository repositorio) {
  final obtener = ObtenerContador(repositorio);
  final incrementar = Incrementar(repositorio);
  final decrementar = Decrementar(repositorio);

  Bloc.observer = RegistroContador(debugPrint);
  return BlocProvider(
    create: (_) => ContadorCubit(obtener, incrementar, decrementar)..cargar(),
    child: const MaterialApp(home: PantallaVisor()),
  );
}

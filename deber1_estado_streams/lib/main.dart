import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/repositories/contador_prefs_repository.dart';
import 'domain/usecases/obtener_contador.dart';
import 'domain/usecases/incrementar.dart';
import 'domain/usecases/decrementar.dart';
import 'presentation/app.dart';

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
  runApp(
    ContadorApp(
      obtener: ObtenerContador(repositorio),
      incrementar: Incrementar(repositorio),
      decrementar: Decrementar(repositorio),
    ),
  );
}

import 'package:deber1_estado_streams/data/repositories/contador_prefs_repository.dart';
import 'package:deber1_estado_streams/domain/usecases/decrementar.dart';
import 'package:deber1_estado_streams/domain/usecases/incrementar.dart';
import 'package:deber1_estado_streams/domain/usecases/obtener_contador.dart';
import 'package:deber1_estado_streams/presentation/pantallas/pantalla_visor.dart';
import 'package:flutter/material.dart';

void main() {
  final repository = ContadorPrefsRepository();

  runApp(
    MyApp(
      obtenerContador: ObtenerContador(repository),
      incrementar: Incrementar(repository),
      decrementar: Decrementar(repository),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.obtenerContador,
    required this.incrementar,
    required this.decrementar,
  });

  final ObtenerContador obtenerContador;
  final Incrementar incrementar;
  final Decrementar decrementar;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contador',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: PantallaVisor(
        obtenerContador: obtenerContador,
        incrementar: incrementar,
        decrementar: decrementar,
      ),
    );
  }
}

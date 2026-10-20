import 'package:flutter/material.dart';

import 'data/repositories/conexion_plus_repository.dart';
import 'domain/usecases/consultar_conexion.dart';
import 'domain/usecases/observar_conexion.dart';
import 'infrastructure/conectividad_dispositivo.dart';
import 'presentation/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final fuente = crearFuenteConexion();
  final repositorio = ConexionPlusRepository(
    consultar: fuente.consultar,
    observar: fuente.observar,
  );
  runApp(
    ConexionApp(
      consultar: ConsultarConexion(repositorio),
      observar: ObservarConexion(repositorio),
    ),
  );
}

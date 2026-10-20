import 'package:flutter/material.dart';

import '../domain/usecases/consultar_conexion.dart';
import '../domain/usecases/observar_conexion.dart';
import 'pantallas/pantalla_foto.dart';
import 'pantallas/pantalla_stream.dart';

class ConexionApp extends StatelessWidget {
  const ConexionApp({
    super.key,
    required this.consultar,
    required this.observar,
  });
  final ConsultarConexion consultar;
  final ObservarConexion observar;
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Future y Stream',
    home: DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Estado de conexion'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Con Future'),
              Tab(text: 'Con Stream'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PantallaFoto(consultarConexion: consultar),
            PantallaStream(
              consultarConexion: consultar,
              observarConexion: observar,
            ),
          ],
        ),
      ),
    ),
  );
}

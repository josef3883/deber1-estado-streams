import 'package:flutter/material.dart';
import 'domain/repositories/contador_repository.dart';

void main() => runApp(crearApp(null));
Widget crearApp(ContadorRepository? repositorio) => const MaterialApp(
  home: Scaffold(body: Center(child: Text('Seleccione version/setstate, version/riverpod o version/bloc'))));

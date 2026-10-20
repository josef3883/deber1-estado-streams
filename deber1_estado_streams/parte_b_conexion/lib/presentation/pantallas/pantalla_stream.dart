import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parte_b_conexion/domain/entities/estado_conexion.dart';
import 'package:parte_b_conexion/domain/usecases/consultar_conexion.dart';
import 'package:parte_b_conexion/domain/usecases/observar_conexion.dart';
import 'package:parte_b_conexion/presentation/estado/conexion_cubit.dart';

class PantallaStream extends StatelessWidget {
  const PantallaStream({
    super.key,
    required this.consultarConexion,
    required this.observarConexion,
  });

  final ConsultarConexion consultarConexion;
  final ObservarConexion observarConexion;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = ConexionCubit(consultarConexion, observarConexion);
        unawaited(cubit.iniciar());
        return cubit;
      },
      child: const _PantallaStreamContenido(),
    );
  }
}

class _PantallaStreamContenido extends StatefulWidget {
  const _PantallaStreamContenido();

  @override
  State<_PantallaStreamContenido> createState() =>
      _PantallaStreamContenidoState();
}

class _PantallaStreamContenidoState extends State<_PantallaStreamContenido>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  int _cambios = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Cambios en tiempo real')),
      body: BlocListener<ConexionCubit, EstadoConexion>(
        listener: (context, estado) => setState(() => _cambios++),
        child: BlocBuilder<ConexionCubit, EstadoConexion>(
          builder: (context, estado) {
            final (etiqueta, icono, color) = switch (estado) {
              EstadoConexion.wifi => ('Wi-Fi', Icons.wifi, Colors.green),
              EstadoConexion.datosMoviles => (
                'Datos moviles',
                Icons.signal_cellular_alt,
                Colors.green,
              ),
              EstadoConexion.otro => ('Otra conexion', Icons.lan, Colors.green),
              EstadoConexion.sinConexion => (
                'Sin conexion',
                Icons.wifi_off,
                Colors.red,
              ),
            };
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icono, size: 84, color: color),
                  const SizedBox(height: 16),
                  Text(
                    etiqueta,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  Text('Cambios recibidos: $_cambios'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

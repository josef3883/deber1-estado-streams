import 'package:flutter/material.dart';
import 'package:parte_b_conexion/domain/entities/estado_conexion.dart';
import 'package:parte_b_conexion/domain/usecases/consultar_conexion.dart';

class PantallaFoto extends StatefulWidget {
  const PantallaFoto({super.key, required this.consultarConexion});

  final ConsultarConexion consultarConexion;

  @override
  State<PantallaFoto> createState() => _PantallaFotoState();
}

class _PantallaFotoState extends State<PantallaFoto>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  EstadoConexion? _estado;
  DateTime? _horaConsulta;
  bool _consultando = false;
  bool _error = false;

  Future<void> _consultarAhora() async {
    setState(() {
      _consultando = true;
      _horaConsulta = DateTime.now();
      _error = false;
    });
    try {
      final estado = await widget.consultarConexion();
      if (!mounted) return;
      setState(() {
        _estado = estado;
        _consultando = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = true;
        _consultando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final estado = _estado;
    final etiqueta = _error
        ? 'No se pudo consultar'
        : switch (estado) {
            EstadoConexion.wifi => 'Wi-Fi',
            EstadoConexion.datosMoviles => 'Datos moviles',
            EstadoConexion.otro => 'Otra conexion',
            EstadoConexion.sinConexion => 'Sin conexion',
            null => 'Sin consultar',
          };
    final conectado = estado != null && estado != EstadoConexion.sinConexion;
    final color = _error
        ? Colors.red
        : estado == null
        ? Colors.blueGrey
        : conectado
        ? Colors.green
        : Colors.red;
    final icono = switch (estado) {
      EstadoConexion.wifi => Icons.wifi,
      EstadoConexion.datosMoviles => Icons.signal_cellular_alt,
      EstadoConexion.otro => Icons.lan,
      EstadoConexion.sinConexion => Icons.wifi_off,
      null => Icons.wifi_find,
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Consulta puntual')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, size: 84, color: color),
            const SizedBox(height: 16),
            Text(etiqueta, style: Theme.of(context).textTheme.headlineMedium),
            if (_horaConsulta case final hora?)
              Text(
                'Consulta: ${hora.hour.toString().padLeft(2, '0')}:'
                '${hora.minute.toString().padLeft(2, '0')}:'
                '${hora.second.toString().padLeft(2, '0')}',
              ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _consultando ? null : _consultarAhora,
              icon: const Icon(Icons.refresh),
              label: const Text('Consultar ahora'),
            ),
          ],
        ),
      ),
    );
  }
}

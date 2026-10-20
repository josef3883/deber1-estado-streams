import 'package:flutter/material.dart';

import 'pantalla_control.dart';

import '../../domain/usecases/obtener_contador.dart';
import '../../domain/usecases/incrementar.dart';
import '../../domain/usecases/decrementar.dart';

class PantallaVisor extends StatefulWidget {
  const PantallaVisor({
    super.key,
    required this.obtener,
    required this.incrementar,
    required this.decrementar,
  });
  final ObtenerContador obtener;
  final Incrementar incrementar;
  final Decrementar decrementar;
  @override
  State<PantallaVisor> createState() => _PantallaVisorState();
}

class _PantallaVisorState extends State<PantallaVisor> {
  int _valor = 0;
  bool _cargando = true;
  String? _error;
  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    try {
      final valor = await widget.obtener();
      if (mounted) {
        setState(() {
          _valor = valor;
          _cargando = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = '$e';
          _cargando = false;
        });
      }
    }
  }

  Future<void> _abrir() async {
    final resultado = await Navigator.of(context).push<int>(
      MaterialPageRoute(
        builder: (_) => PantallaControl(
          valorInicial: _valor,
          incrementar: widget.incrementar,
          decrementar: widget.decrementar,
        ),
      ),
    );
    if (!mounted) return;
    // AppBar, gesto y boton del sistema pueden volver sin resultado.
    // En ese caso reconciliamos la UI con la persistencia.
    if (resultado == null) {
      await _cargar();
    } else {
      setState(() => _valor = resultado);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Contador')),
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Contador: $_valor',
            key: const Key('valor'),
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          if (_cargando) const CircularProgressIndicator(),
          if (_error != null) Text(_error!),
          ElevatedButton(
            onPressed: _cargando || _error != null ? null : _abrir,
            child: const Text('Ir a Control'),
          ),
        ],
      ),
    ),
  );
}

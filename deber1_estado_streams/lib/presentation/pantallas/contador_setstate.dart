import 'package:flutter/material.dart';

import '../../domain/usecases/obtener_contador.dart';
import '../../domain/usecases/incrementar.dart';
import '../../domain/usecases/decrementar.dart';

class PantallaSetState extends StatefulWidget {
  const PantallaSetState({
    super.key,
    required this.obtener,
    required this.incrementar,
    required this.decrementar,
  });
  final ObtenerContador obtener;
  final Incrementar incrementar;
  final Decrementar decrementar;
  @override
  State<PantallaSetState> createState() => _PantallaSetStateState();
}

class _PantallaSetStateState extends State<PantallaSetState> {
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
        builder: (_) => _Control(
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
    appBar: AppBar(title: const Text('Contador - setState')),
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Contador: $_valor', key: const Key('valor')),
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

class _Control extends StatefulWidget {
  const _Control({
    required this.valorInicial,
    required this.incrementar,
    required this.decrementar,
  });
  final int valorInicial;
  final Incrementar incrementar;
  final Decrementar decrementar;
  @override
  State<_Control> createState() => _ControlState();
}

class _ControlState extends State<_Control> {
  late int _valor = widget.valorInicial;
  bool _ocupado = false;
  String? _error;
  Future<void> _cambiar(Future<int> Function() accion) async {
    if (_ocupado) return;
    setState(() {
      _ocupado = true;
      _error = null;
    });
    try {
      final valor = await accion();
      if (mounted) setState(() => _valor = valor);
    } catch (e) {
      if (mounted) setState(() => _error = '$e');
    } finally {
      if (mounted) setState(() => _ocupado = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Control')),
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Contador: $_valor'),
          if (_error != null) Text(_error!),
          ElevatedButton(
            onPressed: _ocupado
                ? null
                : () => _cambiar(widget.incrementar.call),
            child: const Text('+1'),
          ),
          ElevatedButton(
            onPressed: _ocupado
                ? null
                : () => _cambiar(widget.decrementar.call),
            child: const Text('-1'),
          ),
          ElevatedButton(
            onPressed: _ocupado
                ? null
                : () => Navigator.pop<int>(context, _valor),
            child: const Text('Volver'),
          ),
        ],
      ),
    ),
  );
}

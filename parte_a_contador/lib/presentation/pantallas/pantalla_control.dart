import 'package:flutter/material.dart';

import '../../domain/usecases/incrementar.dart';
import '../../domain/usecases/decrementar.dart';

class PantallaControl extends StatefulWidget {
  const PantallaControl({
    super.key,
    required this.valorInicial,
    required this.incrementar,
    required this.decrementar,
  });
  final int valorInicial;
  final Incrementar incrementar;
  final Decrementar decrementar;
  @override
  State<PantallaControl> createState() => _ControlState();
}

class _ControlState extends State<PantallaControl> {
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
          Text(
            'Contador: $_valor',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
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

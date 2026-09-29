import 'package:deber1_estado_streams/domain/usecases/decrementar.dart';
import 'package:deber1_estado_streams/domain/usecases/incrementar.dart';
import 'package:flutter/material.dart';

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
  State<PantallaControl> createState() => _PantallaControlState();
}

class _PantallaControlState extends State<PantallaControl> {
  late int _contador = widget.valorInicial;
  bool _actualizando = false;

  Future<void> _actualizar(Future<int> Function() accion) async {
    if (_actualizando) return;
    setState(() => _actualizando = true);

    try {
      final contador = await accion();
      if (!mounted) return;
      setState(() => _contador = contador);
    } finally {
      if (mounted) setState(() => _actualizando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Control')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Contador: $_contador',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _actualizando
                      ? null
                      : () => _actualizar(widget.decrementar.call),
                  child: const Text('-1'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _actualizando
                      ? null
                      : () => _actualizar(widget.incrementar.call),
                  child: const Text('+1'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _actualizando
                  ? null
                  : () => Navigator.pop<int>(context, _contador),
              child: const Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}

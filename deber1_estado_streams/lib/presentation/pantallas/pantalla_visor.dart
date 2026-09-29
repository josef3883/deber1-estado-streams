import 'package:deber1_estado_streams/domain/usecases/decrementar.dart';
import 'package:deber1_estado_streams/domain/usecases/incrementar.dart';
import 'package:deber1_estado_streams/domain/usecases/obtener_contador.dart';
import 'package:deber1_estado_streams/presentation/pantallas/pantalla_control.dart';
import 'package:flutter/material.dart';

class PantallaVisor extends StatefulWidget {
  const PantallaVisor({
    super.key,
    required this.obtenerContador,
    required this.incrementar,
    required this.decrementar,
  });

  final ObtenerContador obtenerContador;
  final Incrementar incrementar;
  final Decrementar decrementar;

  @override
  State<PantallaVisor> createState() => _PantallaVisorState();
}

class _PantallaVisorState extends State<PantallaVisor> {
  int _contador = 0;

  @override
  void initState() {
    super.initState();
    _cargarContador();
  }

  Future<void> _cargarContador() async {
    final contador = await widget.obtenerContador();
    if (!mounted) return;
    setState(() => _contador = contador);
  }

  Future<void> _irAControl() async {
    final contador = await Navigator.of(context).push<int>(
      MaterialPageRoute(
        builder: (_) => PantallaControl(
          valorInicial: _contador,
          incrementar: widget.incrementar,
          decrementar: widget.decrementar,
        ),
      ),
    );

    if (contador == null || !mounted) return;
    setState(() => _contador = contador);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contador')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Contador: $_contador',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _irAControl,
              child: const Text('Ir a Control'),
            ),
          ],
        ),
      ),
    );
  }
}

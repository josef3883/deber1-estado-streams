import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../estado/contador_provider.dart';
import 'pantalla_control.dart';

class PantallaVisor extends ConsumerWidget {
  const PantallaVisor({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(contadorProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Contador')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Contador: ${estado.valor}',
              key: const Key('valor'),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            if (estado.ocupado) const CircularProgressIndicator(),
            if (estado.error != null) Text(estado.error!),

            ElevatedButton(
              onPressed: estado.ocupado
                  ? null
                  : () => Navigator.of(context).push<void>(
                      MaterialPageRoute(
                        builder: (_) => const PantallaControl(),
                      ),
                    ),
              child: const Text('Ir a Control'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../estado/contador_provider.dart';

class PantallaControl extends ConsumerWidget {
  const PantallaControl({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(contadorProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Control')),
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
                  : ref.read(contadorProvider.notifier).incrementar,
              child: const Text('+1'),
            ),
            ElevatedButton(
              onPressed: estado.ocupado
                  ? null
                  : ref.read(contadorProvider.notifier).decrementar,
              child: const Text('-1'),
            ),
            ElevatedButton(
              onPressed: estado.ocupado ? null : () => Navigator.pop(context),
              child: const Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}

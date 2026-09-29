import 'package:deber1_estado_streams/presentation/estado/contador_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PantallaControl extends ConsumerWidget {
  const PantallaControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contadorNotifier = ref.read(contadorProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Control del contador'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: .center,
          children: [
            IconButton(
              onPressed: contadorNotifier.decrementar,
              tooltip: 'Decrementar',
              icon: const Icon(Icons.remove),
            ),
            const SizedBox(width: 24),
            IconButton(
              onPressed: contadorNotifier.incrementar,
              tooltip: 'Incrementar',
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
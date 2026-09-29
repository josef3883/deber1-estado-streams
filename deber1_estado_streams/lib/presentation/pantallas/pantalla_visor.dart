import 'package:deber1_estado_streams/presentation/estado/contador_provider.dart';
import 'package:deber1_estado_streams/presentation/pantallas/pantalla_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PantallaVisor extends ConsumerWidget {
  const PantallaVisor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contador = ref.watch(contadorProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Flutter Demo Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$contador',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push<void>(
            MaterialPageRoute<void>(
              builder: (_) => const PantallaControl(),
            ),
          );
        },
        tooltip: 'Control',
        child: const Icon(Icons.add),
      ),
    );
  }
}
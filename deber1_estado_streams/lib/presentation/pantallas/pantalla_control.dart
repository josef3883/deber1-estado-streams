import 'package:deber1_estado_streams/presentation/estado/contador_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PantallaControl extends StatelessWidget {
  const PantallaControl({super.key});

  @override
  Widget build(BuildContext context) {
    final contadorCubit = context.read<ContadorCubit>();

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
              onPressed: contadorCubit.decrementar,
              tooltip: 'Decrementar',
              icon: const Icon(Icons.remove),
            ),
            const SizedBox(width: 24),
            IconButton(
              onPressed: contadorCubit.incrementar,
              tooltip: 'Incrementar',
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
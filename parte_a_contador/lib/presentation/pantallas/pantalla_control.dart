import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../estado/contador_cubit.dart';

class PantallaControl extends StatelessWidget {
  const PantallaControl({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Control')),
    body: Center(
      child: BlocBuilder<ContadorCubit, int>(
        builder: (context, valor) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Contador: $valor',
              key: const Key('valor'),
              style: Theme.of(context).textTheme.headlineLarge,
            ),

            ElevatedButton(
              onPressed: context.read<ContadorCubit>().incrementar,
              child: const Text('+1'),
            ),
            ElevatedButton(
              onPressed: context.read<ContadorCubit>().decrementar,
              child: const Text('-1'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Volver'),
            ),
          ],
        ),
      ),
    ),
  );
}

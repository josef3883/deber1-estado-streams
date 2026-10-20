import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../estado/contador_cubit.dart';
import 'pantalla_control.dart';

class PantallaVisor extends StatelessWidget {
  const PantallaVisor({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Contador')),
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
              onPressed: () => Navigator.of(context).push<void>(
                MaterialPageRoute(builder: (_) => const PantallaControl()),
              ),
              child: const Text('Ir a Control'),
            ),
          ],
        ),
      ),
    ),
  );
}

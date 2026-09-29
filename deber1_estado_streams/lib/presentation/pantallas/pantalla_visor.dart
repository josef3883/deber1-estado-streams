import 'package:deber1_estado_streams/presentation/estado/contador_cubit.dart';
import 'package:deber1_estado_streams/presentation/pantallas/pantalla_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PantallaVisor extends StatelessWidget {
  const PantallaVisor({super.key});

  @override
  Widget build(BuildContext context) {
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
            BlocBuilder<ContadorCubit, int>(
              builder: (context, contador) => Text(
                '$contador',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
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
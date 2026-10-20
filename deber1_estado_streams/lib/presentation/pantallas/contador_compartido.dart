import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../estado/contador_cubit.dart';
import '../estado/contador_provider.dart';
import '../estado/contador_estado.dart';

class PantallaRiverpod extends ConsumerWidget {
  const PantallaRiverpod({super.key, this.control = false});
  final bool control;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(contadorProvider);
    final notifier = ref.read(contadorProvider.notifier);
    return _contenido(
      context,
      'Riverpod',
      estado,
      control,
      notifier.incrementar,
      notifier.decrementar,
      () => Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (_) => const PantallaRiverpod(control: true),
        ),
      ),
    );
  }
}

class PantallaCubit extends StatelessWidget {
  const PantallaCubit({super.key, this.control = false});
  final bool control;
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ContadorCubit, ContadorEstado>(
        builder: (context, estado) {
          final cubit = context.read<ContadorCubit>();
          return _contenido(
            context,
            'Cubit',
            estado,
            control,
            cubit.incrementar,
            cubit.decrementar,
            () => Navigator.of(context).push<void>(
              MaterialPageRoute(
                builder: (_) => const PantallaCubit(control: true),
              ),
            ),
          );
        },
      );
}

Widget _contenido(
  BuildContext context,
  String version,
  ContadorEstado estado,
  bool control,
  VoidCallback sumar,
  VoidCallback restar,
  VoidCallback abrir,
) => Scaffold(
  appBar: AppBar(title: Text(control ? 'Control' : 'Contador - $version')),
  body: Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Contador: ${estado.valor}', key: const Key('valor')),
        if (estado.ocupado) const CircularProgressIndicator(),
        if (estado.error != null) Text(estado.error!),
        if (control) ...[
          ElevatedButton(
            onPressed: estado.ocupado ? null : sumar,
            child: const Text('+1'),
          ),
          ElevatedButton(
            onPressed: estado.ocupado ? null : restar,
            child: const Text('-1'),
          ),
          ElevatedButton(
            onPressed: estado.ocupado ? null : () => Navigator.pop(context),
            child: const Text('Volver'),
          ),
        ] else
          ElevatedButton(
            onPressed: estado.ocupado ? null : abrir,
            child: const Text('Ir a Control'),
          ),
      ],
    ),
  ),
);

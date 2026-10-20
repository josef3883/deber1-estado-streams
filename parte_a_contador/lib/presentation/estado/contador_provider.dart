import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/obtener_contador.dart';
import '../../domain/usecases/incrementar.dart';
import '../../domain/usecases/decrementar.dart';
import 'contador_estado.dart';
import '../../domain/repositories/contador_repository.dart';

final contadorRepositoryProvider = Provider<ContadorRepository>(
  (ref) => throw UnimplementedError(),
);

// Declarados fuera del arbol. La composicion inyecta casos de uso, nunca data.
final obtenerProvider = Provider<ObtenerContador>(
  (ref) => throw UnimplementedError(),
);
final sumarProvider = Provider<Incrementar>(
  (ref) => throw UnimplementedError(),
);
final restarProvider = Provider<Decrementar>(
  (ref) => throw UnimplementedError(),
);
final contadorProvider = NotifierProvider<ContadorNotifier, ContadorEstado>(
  ContadorNotifier.new,
);

class ContadorNotifier extends Notifier<ContadorEstado> {
  @override
  ContadorEstado build() {
    Future<void>.microtask(cargar);
    return const ContadorEstado(ocupado: true);
  }

  bool _ejecutando = false;
  Future<void> cargar() => _ejecutar(ref.read(obtenerProvider).call);
  Future<void> incrementar() => _ejecutar(ref.read(sumarProvider).call);
  Future<void> decrementar() => _ejecutar(ref.read(restarProvider).call);
  Future<void> _ejecutar(Future<int> Function() accion) async {
    if (_ejecutando || !ref.mounted) return;
    _ejecutando = true;
    state = ContadorEstado(valor: state.valor, ocupado: true);
    try {
      final valor = await accion();
      if (ref.mounted) state = ContadorEstado(valor: valor);
    } catch (e) {
      if (ref.mounted) state = ContadorEstado(valor: state.valor, error: '$e');
    } finally {
      _ejecutando = false;
    }
  }
}

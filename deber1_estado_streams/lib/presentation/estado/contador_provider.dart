import 'package:deber1_estado_streams/data/repositories/contador_prefs_repository.dart';
import 'package:deber1_estado_streams/domain/repositories/contador_repository.dart';
import 'package:deber1_estado_streams/domain/usecases/decrementar.dart';
import 'package:deber1_estado_streams/domain/usecases/incrementar.dart';
import 'package:deber1_estado_streams/domain/usecases/obtener_contador.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final contadorRepositoryProvider = Provider<ContadorRepository>(
  (ref) => ContadorPrefsRepository(),
);

final obtenerContadorProvider = Provider<ObtenerContador>(
  (ref) => ObtenerContador(ref.watch(contadorRepositoryProvider)),
);

final incrementarProvider = Provider<Incrementar>(
  (ref) => Incrementar(ref.watch(contadorRepositoryProvider)),
);

final decrementarProvider = Provider<Decrementar>(
  (ref) => Decrementar(ref.watch(contadorRepositoryProvider)),
);

final contadorProvider = NotifierProvider<ContadorNotifier, int>(
  ContadorNotifier.new,
);

class ContadorNotifier extends Notifier<int> {
  @override
  int build() {
    Future<void>.microtask(cargar);
    return 0;
  }

  Future<void> cargar() async {
    state = await ref.read(obtenerContadorProvider)();
  }

  Future<void> incrementar() async {
    state = await ref.read(incrementarProvider)();
  }

  Future<void> decrementar() async {
    state = await ref.read(decrementarProvider)();
  }
}
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/obtener_contador.dart';
import '../../domain/usecases/incrementar.dart';
import '../../domain/usecases/decrementar.dart';
import 'contador_estado.dart';

class ContadorCubit extends Cubit<ContadorEstado> {
  ContadorCubit(this.obtener, this.sumar, this.restar)
    : super(const ContadorEstado());
  final ObtenerContador obtener;
  final Incrementar sumar;
  final Decrementar restar;

  Future<void> cargar() => _ejecutar(obtener.call);
  Future<void> incrementar() => _ejecutar(sumar.call);
  Future<void> decrementar() => _ejecutar(restar.call);

  Future<void> _ejecutar(Future<int> Function() accion) async {
    if (state.ocupado || isClosed) return;
    emit(ContadorEstado(valor: state.valor, ocupado: true));
    try {
      final valor = await accion();
      if (!isClosed) emit(ContadorEstado(valor: valor));
    } catch (e) {
      if (!isClosed) emit(ContadorEstado(valor: state.valor, error: '$e'));
    }
  }
}

class RegistroContador extends BlocObserver {
  RegistroContador(this.escribir);
  final void Function(String) escribir;
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    if (bloc is ContadorCubit) {
      final antes = change.currentState as ContadorEstado;
      final despues = change.nextState as ContadorEstado;
      if (antes.valor != despues.valor) {
        escribir('ContadorCubit: ${antes.valor} -> ${despues.valor}');
      }
    }
  }
}

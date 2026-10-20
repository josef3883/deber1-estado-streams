import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/obtener_contador.dart';
import '../../domain/usecases/incrementar.dart';
import '../../domain/usecases/decrementar.dart';

class ContadorCubit extends Cubit<int> {
  ContadorCubit(this._obtener, this._sumar, this._restar) : super(0);
  final ObtenerContador _obtener;
  final Incrementar _sumar;
  final Decrementar _restar;
  bool _ocupado = false;
  Future<void> cargar() => _ejecutar(_obtener.call);
  Future<void> incrementar() => _ejecutar(_sumar.call);
  Future<void> decrementar() => _ejecutar(_restar.call);
  Future<void> _ejecutar(Future<int> Function() accion) async {
    if (_ocupado || isClosed) return;
    _ocupado = true;
    try {
      final valor = await accion();
      if (!isClosed) emit(valor);
    } catch (error, stack) {
      if (!isClosed) addError(error, stack);
    } finally {
      _ocupado = false;
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
      escribir('ContadorCubit: ${change.currentState} -> ${change.nextState}');
    }
  }
}

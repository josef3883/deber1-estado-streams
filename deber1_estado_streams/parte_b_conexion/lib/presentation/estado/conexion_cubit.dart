import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/usecases/consultar_conexion.dart';
import '../../domain/usecases/observar_conexion.dart';

class ConexionCubit extends Cubit<EstadoConexion> {
  ConexionCubit(this._consultar, this._observar) : super(EstadoConexion.otro);
  final ConsultarConexion _consultar;
  final ObservarConexion _observar;
  StreamSubscription<EstadoConexion>? _suscripcion;
  Future<void>? _inicio;
  bool _cerrando = false;

  // Repetir iniciar no crea otra suscripcion ni otra consulta.
  Future<void> iniciar() => _inicio ??= _iniciar();
  Future<void> _iniciar() async {
    if (_cerrando || isClosed) return;
    var recibioEvento = false;
    try {
      // Escuchar antes de consultar evita perder cambios durante el Future.
      _suscripcion = _observar().listen(
        (estado) {
          recibioEvento = true;
          if (!_cerrando && !isClosed) emit(estado);
        },
        onError: (Object error, StackTrace stack) {
          if (!_cerrando && !isClosed) addError(error, stack);
        },
      );
      final actual = await _consultar();
      if (!_cerrando && !isClosed && !recibioEvento) emit(actual);
    } catch (error, stack) {
      if (!_cerrando && !isClosed) addError(error, stack);
    }
  }

  @override
  Future<void> close() async {
    _cerrando = true;
    await _suscripcion?.cancel();
    await super.close();
  }
}

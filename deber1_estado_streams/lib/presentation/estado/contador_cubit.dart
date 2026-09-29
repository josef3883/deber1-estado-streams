import 'package:deber1_estado_streams/domain/usecases/decrementar.dart';
import 'package:deber1_estado_streams/domain/usecases/incrementar.dart';
import 'package:deber1_estado_streams/domain/usecases/obtener_contador.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContadorCubit extends Cubit<int> {
  ContadorCubit(
    this._obtenerContador,
    this._incrementar,
    this._decrementar,
  ) : super(0);

  final ObtenerContador _obtenerContador;
  final Incrementar _incrementar;
  final Decrementar _decrementar;

  Future<void> cargar() async {
    emit(await _obtenerContador());
  }

  Future<void> incrementar() async {
    emit(await _incrementar());
  }

  Future<void> decrementar() async {
    emit(await _decrementar());
  }
}
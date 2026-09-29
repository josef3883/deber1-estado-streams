import 'package:deber1_estado_streams/domain/repositories/contador_repository.dart';

class ObtenerContador {
  ObtenerContador(this._repository);

  final ContadorRepository _repository;

  Future<int> call() => _repository.leer();
}
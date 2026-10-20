import '../../domain/entities/estado_conexion.dart';
import '../../domain/repositories/conexion_repository.dart';

class ConexionPlusRepository implements ConexionRepository {
  ConexionPlusRepository({required this._consultar, required this._observar});
  final Future<EstadoConexion> Function() _consultar;
  final Stream<EstadoConexion> Function() _observar;
  @override
  Future<EstadoConexion> consultarAhora() => _consultar();
  @override
  Stream<EstadoConexion> observarCambios() => _observar();
}

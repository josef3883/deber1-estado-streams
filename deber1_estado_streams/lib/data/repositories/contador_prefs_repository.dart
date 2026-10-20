import '../../domain/repositories/contador_repository.dart';

// El adaptador recibe operaciones: data no conoce plugins ni Flutter.
class ContadorPrefsRepository implements ContadorRepository {
  ContadorPrefsRepository({required this._leer, required this._guardar});

  final Future<int> Function() _leer;
  final Future<void> Function(int) _guardar;

  @override
  Future<int> leer() => _leer();
  @override
  Future<void> guardar(int valor) => _guardar(valor);
}

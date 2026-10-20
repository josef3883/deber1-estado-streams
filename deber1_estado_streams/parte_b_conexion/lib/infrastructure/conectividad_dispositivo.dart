import 'package:connectivity_plus/connectivity_plus.dart';

import '../domain/entities/estado_conexion.dart';

// Este es el unico archivo de lib que conoce el plugin.
({
  Future<EstadoConexion> Function() consultar,
  Stream<EstadoConexion> Function() observar,
})
crearFuenteConexion() {
  final dispositivo = Connectivity();
  EstadoConexion traducir(List<ConnectivityResult> resultados) {
    if (resultados.contains(ConnectivityResult.wifi)) {
      return EstadoConexion.wifi;
    }
    if (resultados.contains(ConnectivityResult.mobile)) {
      return EstadoConexion.datosMoviles;
    }
    if (resultados.any((r) => r != ConnectivityResult.none)) {
      return EstadoConexion.otro;
    }
    return EstadoConexion.sinConexion;
  }

  return (
    consultar: () async => traducir(await dispositivo.checkConnectivity()),
    observar: () => dispositivo.onConnectivityChanged.map(traducir).distinct(),
  );
}

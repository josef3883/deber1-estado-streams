class ContadorEstado {
  const ContadorEstado({this.valor = 0, this.ocupado = false, this.error});
  final int valor;
  final bool ocupado;
  final String? error;
}

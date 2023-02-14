class PagosDetalles {
  String? id;
  String? ordeDePago;
  String numeroDeFactura;
  DateTime? fechavencimiento;
  DateTime? fechaEmision;

  double valorfactura;
  double valorpendiente;
  double montoPagado;

  int activo;

  PagosDetalles(
      {this.id,
      required this.ordeDePago,
      required this.numeroDeFactura,
      this.fechavencimiento,
      this.fechaEmision,
      required this.montoPagado,
      required this.valorfactura,
      required this.valorpendiente,
      required this.activo});

  static List<PagosDetalles> pagos = [];

  static agregarFacturasaPagos(PagosDetalles pago) {
    return pagos.add(pago);
    print(pagos.length);
  }

  static List<PagosDetalles> getDetalleFactura() {
    return pagos;
  }

  static double obtenerSubtotal() {
    return 1000;
  }

  static double obtenerTotal() {
    return 1000;
  }
}

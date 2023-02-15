class Pagos {
  String? id;
  String formadePago;
  String? banco;
  double valordelpago;
  String? numeroDeCheque;
  String? fechaCheque;

  Pagos(
      {this.id,
      required this.formadePago,
      this.banco,
      required this.valordelpago,
      this.fechaCheque,
      this.numeroDeCheque});

  static List<Pagos> pago = [];
  // Pagos pagos =;
  static agregarpago(Pagos pagos) {
    pago.add(pagos);
  }

  static var pagos = new Pagos(formadePago: "1", valordelpago: 0);
  static agregarpago1() {}

  static actualizarmontodelpago(double monto) {
    pagos.valordelpago = monto;
  }

  static obtenermontodelpago() {
    return pagos.valordelpago;
  }

  static eliminarPago(int index) {
    pago.clear();
  }

  static updatePago(Pagos pagos, index) {
    pago[index].formadePago = pagos.formadePago;
    pago[index].banco = pagos.banco;
    pago[index].valordelpago = pagos.valordelpago;
    pago[index].numeroDeCheque = pagos.numeroDeCheque;
    pago[index].numeroDeCheque = pagos.numeroDeCheque;
  }
}

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

  static eliminarpago(int index) {
    pagos.removeAt(index);
    pagos.remove(index);
    return null;
  }

  static List<PagosDetalles> getDetalleFactura() {
    return pagos;
  }

  static double obtenerSubtotal() {
    if (pagos.length > 0) {
      double monto = pagos
          .map((e) => e.montoPagado)
          .reduce((value, element) => value + element);
      if (monto != 0) {
        return monto;
      }
    }
    return 0;

    // double pagos = pagos
    //     .map((e) => e.montoPagado)
    //     .reduce((value, element) => value + element);
  }

  static double obtenerTotal() {
    return 1000;
  }

  static actualizardetalle(int index, double? monto) {
    if (monto != null) {
      pagos[index].montoPagado = monto;
    }
  }
}

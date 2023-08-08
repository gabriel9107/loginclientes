import 'package:sigalogin/clases/factura.dart';
import 'package:sigalogin/clases/modelos/pago.dart';

class comprobanteDePago {
  final String clienteNombre;
  final String clienteCodigo;
  final String vendedorNombre;
  final DateTime fechaComprobante;

  final List<Pago> pagos;

  const comprobanteDePago({
    required this.clienteNombre,
    required this.clienteCodigo,
    required this.fechaComprobante,
    required this.vendedorNombre,
    required this.pagos,
  });
}

class reciboDePago {
  final String clienteNombre;
  final String clienteCodigo;
  final String vendedorNombre;
  final DateTime fechaPago;
  final double montoPagado;
  final String facturaNumero;
  final double MontoPendiente;

  const reciboDePago(
      {required this.clienteCodigo,
      required this.clienteNombre,
      required this.vendedorNombre,
      required this.fechaPago,
      required this.montoPagado,
      required this.facturaNumero,
      required this.MontoPendiente});
}

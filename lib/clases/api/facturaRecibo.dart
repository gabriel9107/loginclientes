import 'package:sigalogin/clases/factura.dart';
import 'package:sigalogin/clases/modelos/pago.dart';

class facturaRecibo {
  final String clienteNombre;
  final String clienteCodigo;
  final String vendedorNombre;
  final DateTime facturaFecha;

  final List<Pago> pagos;

  const facturaRecibo({
    required this.clienteNombre,
    required this.clienteCodigo,
    required this.facturaFecha,
    required this.vendedorNombre,
    required this.pagos,
  });
}

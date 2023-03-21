class FacturaMaster {
  String? id;
  String clienteId;
  String fechaFactura;
  String fechaVencimiento;
  double montoFactura;
  double montoPagado;
  double montoPendiente;

  FacturaMaster(
      {this.id,
      required this.clienteId,
      required this.fechaFactura,
      required this.fechaVencimiento,
      required this.montoFactura,
      required this.montoPagado,
      required this.montoPendiente});
}

class Factudadetalle {
  String? id;
  String facturaId;
  String clienteId;
  String codigoProducto;
  String nombreProducto;
  String cantidad;
  String montounitaroio;
  String monto;

  Factudadetalle(
      {this.id,
      required this.facturaId,
      required this.cantidad,
      required this.clienteId,
      required this.codigoProducto,
      required this.nombreProducto,
      required this.montounitaroio,
      required this.monto});
}







// class DetalleFactura {
//   String? id;
//   String clienteId;
//   String facturaId; 
//   DateTime fechapedido;
//   double montoPedido;
// }



// // import 'package:http/http.dart';

// // class FacturaMaster {
// //   String? id;

// //   String idClientePago;
// //   String nombreCliente;
// //   String formaDePago;
// //   String valorDelpago;
// //   String? entidadBancaria;
// //   String numeroDeCheque;
// //   String fechaCheque;
// //   String subTotalPago;
// //   String totalPago;

// //   FacturaMaster(
// //       {this.id,
// //       required this.idClientePago,
// //       required this.nombreCliente,
// //       required this.formaDePago,
// //       required this.entidadBancaria,
// //       required this.numeroDeCheque,
// //       required this.fechaCheque,
      
// //       required this.subTotalPago,
// //       required this.totalPago});


// // }

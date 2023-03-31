// import 'dart:convert';
// import 'global.dart';
// import 'package:sigalogin/pantallas/clientes/detalleDelCLiente.dart';

// import '../servicios/db_helper.dart';

// Map<String, Factura> facturaFromJson(String str) => Map.from(json.decode(str))
//     .map((k, v) => MapEntry<String, Factura>(k, Factura.fromJson(v)));

// String facturaToJson(Map<String, Factura> data) => json.encode(
//     Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

// class Factura {
//   Factura({
//     required this.id,
//     required this.clienteId,
//     required this.facturaFecha,
//     required this.facturaId,
//     required this.facturaVencimiento,
//     required this.metodoDePago,
//     required this.montoFactura,
//     required this.pedidosId,
//     required this.totalPagado,
//   });

//   int? id;
//   int clienteId;
//   String? facturaFecha;
//   String? facturaId;
//   String? facturaVencimiento;
//   String? metodoDePago;
//   String montoFactura;

//   String? pedidosId;
//   int? totalPagado;

//   factory Factura.fromJson(Map<String, dynamic> json) => Factura(
//         id: json["Id"],
//         clienteId: 7488803,
//         facturaFecha: json["FacturaFecha"],
//         facturaId: json["FacturaId"],
//         facturaVencimiento: json["FacturaVencimiento"],
//         metodoDePago: json["MetodoDePago"],
//         montoFactura: json["MontoFactura"].toString(),
//         pedidosId: json["PedidosId"],
//         totalPagado: json["totalPagado"],
//       );

//   Map<String, dynamic> toJson() => {
//         "Id": id,
//         "clienteId": clienteId,
//         "FacturaFecha": facturaFecha,
//         "FacturaId": facturaId,
//         "FacturaVencimiento": facturaVencimiento,
//         "MetodoDePago": metodoDePago,
//         "MontoFactura": montoFactura,
//         "PedidosId": pedidosId,
//         "totalPagado": totalPagado,
//       };

//   Map<String, dynamic> toMap() {
//     return {
//       "Id": id,
//       "clienteId": clienteId,
//       "FacturaFecha": facturaFecha,
//       "FacturaId": facturaId,
//       "FacturaVencimiento": facturaVencimiento,
//       "MetodoDePago": metodoDePago,
//       "MontoFactura": montoFactura,
//       "PedidosId": pedidosId,
//       "totalPagado": totalPagado,
//     };
//   }

//   static List<Factura> facturatemp = <Factura>[];

// static void addfacturaDetalle(Factura detalle) {
//   facturatemp.add(detalle);
//   print('detalle de factura');
//   print(facturatemp.length);
// }

//   static List<Factura> obtenerfacturadetalle() {
//     return facturatemp;
//   }

//   List<Factura> factura = [];
//   static Future obtenerFacturas() async {
//     var documento =
//         await DatabaseHelper.instance.getFacturas() as List<Factura>;

//     if (ListasFactura == false) {
//       documento.forEach((element) {
//         Factura a = new Factura(
//             id: element.id,
//             clienteId: element.clienteId,
//             facturaFecha: element.facturaFecha,
//             facturaId: element.facturaId,
//             facturaVencimiento: element.facturaVencimiento,
//             metodoDePago: element.metodoDePago,
//             montoFactura: element.montoFactura,
//             pedidosId: element.pedidosId,
//             totalPagado: element.totalPagado);
//         TodasLasFacturas.add(a);
//       });
//       ListasFactura = true;
//     }
//     // TodosProductos.add(documento);
//     // Lista.add(documento);
//     return documento;
//   }
// }

// To parse this JSON data, do
//
//     final factura = facturaFromMap(jsonString);

import 'dart:convert';

import '../servicios/db_helper.dart';

class Factura {
  Factura({
    this.id,
    required this.compagnia,
    required this.facturaFecha,
    required this.facturaId,
    required this.facturaVencimiento,
    required this.isDelete,
    required this.metodoDePago,
    required this.montoFactura,
    required this.montoPendiente,
    required this.pedidoId,
    required this.sincronizado,
    required this.clienteId,
    required this.clienteNombre,
    required this.totalPagado,
    required this.vendedorId,
  });

  int? id;
  String facturaId;
  String vendedorId;
  String metodoDePago;
  double montoFactura;
  double montoPendiente;
  double totalPagado;
  String facturaVencimiento;
  String facturaFecha;
  String pedidoId;
  String clienteId;
  String clienteNombre;
  int sincronizado;
  int compagnia;
  int isDelete;

  static List<Factura> facturatemp = <Factura>[];

  static void addfacturaDetalle(Factura detalle) {
    facturatemp.add(detalle);
    print('detalle de factura');
    print(facturatemp.length);
  }

  static List<Factura> obtenerfacturadetalle() {
    return facturatemp;
  }

  factory Factura.fromJson(String str) => Factura.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return {
      "Compagnia": compagnia,
      "FacturaFecha": facturaFecha,
      "FacturaId": facturaId,
      "FacturaVencimiento": facturaVencimiento,
      "Id": id,
      "IsDelete": isDelete,
      "MetodoDePago": metodoDePago,
      "MontoFactura": montoFactura,
      "MontoPendiente": montoPendiente,
      "PedidoId": pedidoId,
      "Sincronizado": sincronizado,
      "clienteId": clienteId,
      "clienteNombre": clienteNombre,
      "totalPagado": totalPagado,
      "vendedorId": vendedorId,
    };
  }

  factory Factura.fromMap(Map<String, dynamic> json) => Factura(
        compagnia: json["Compagnia"],
        facturaFecha: json["FacturaFecha"],
        facturaId: json["FacturaId"].toString().trim(),
        facturaVencimiento: json["FacturaVencimiento"],
        isDelete: json["IsDelete"],
        metodoDePago: json["MetodoDePago"].toString().trim(),
        montoFactura: json["MontoFactura"].toDouble(),
        montoPendiente: json["MontoPendiente"],
        pedidoId: json["PedidoId"].toString().trim(),
        sincronizado: json["Sincronizado"],
        clienteId: json["clienteId"].toString().trim(),
        clienteNombre: json["clienteNombre"].toString().trim(),
        id: json["Id"],
        totalPagado: json["totalPagado"].toDouble(),
        vendedorId: json["vendedorId"].toString().trim(),
      );

  List<Factura> factura = [];

  static Future obtenerFacturas() async {
    var documento =
        await DatabaseHelper.instance.getFacturas() as List<Factura>;

    //   if (ListasFactura == false) {
    //     documento.forEach((element) {
    //       Factura a = new Factura(
    //           id: element.id,
    //           clienteId: element.clienteId,
    //           facturaFecha: element.facturaFecha,
    //           facturaId: element.facturaId,
    //           facturaVencimiento: element.facturaVencimiento,
    //           metodoDePago: element.metodoDePago,
    //           montoFactura: element.montoFactura,
    //           pedidosId: element.pedidosId,
    //           totalPagado: element.totalPagado);
    //       TodasLasFacturas.add(a);
    //     });
    //     ListasFactura = true;
    //   }
    //   // TodosProductos.add(documento);
    //   // Lista.add(documento);
    //   return documento;
    // }
  }
}

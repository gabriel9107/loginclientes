// // To parse this JSON data, do
// //
// //     final pagodetalle = pagodetalleFromJson(jsonString);

// import 'dart:convert';
// import 'dart:ffi';

// import 'package:sigalogin/clases/factura.dart';
// import 'package:sigalogin/servicios/db_helper.dart';

// List<Pagodetalle?> pagodetalleFromJson(String str) => List<Pagodetalle?>.from(
//     json.decode(str).map((x) => x == null ? null : Pagodetalle.fromJson(x)));

// String pagodetalleToJson(List<Pagodetalle?> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x?.toJson())));

// class Pagodetalle {
//   Pagodetalle({
//     required this.activo,
//     required this.fechaEmision,
//     required this.fechavencimiento,
//     required this.montoPagado,
//     required this.numeroDeFactura,
//     required this.pago,
//     required this.valorfactura,
//     required this.valorpendiente,
//   });

//   int activo;
//   DateTime fechaEmision;
//   DateTime fechavencimiento;
//   double montoPagado;
//   String numeroDeFactura;
//   int pago;
//   double valorfactura;
//   double valorpendiente;

//   factory Pagodetalle.fromJson(Map<String, dynamic> json) => Pagodetalle(
//         activo: json["activo"],
//         fechaEmision: DateTime.parse(json["fechaEmision"]),
//         fechavencimiento: DateTime.parse(json["fechavencimiento"]),
//         montoPagado: json["montoPagado"]?.toDouble(),
//         numeroDeFactura: json["numeroDeFactura"],
//         pago: json["pago"],
//         valorfactura: json["valorfactura"]?.toDouble(),
//         valorpendiente: json["valorpendiente"]?.toDouble(),
//       );

//   Map<String, dynamic> toJson() => {
//         "activo": activo,
//         "fechaEmision": fechaEmision.toIso8601String(),
//         "fechavencimiento": fechavencimiento.toIso8601String(),
//         "montoPagado": montoPagado,
//         "numeroDeFactura": numeroDeFactura,
//         "pago": pago,
//         "valorfactura": valorfactura,
//         "valorpendiente": valorpendiente,
//       };

//   static List<Pagodetalle> pagos = [];

//   static void agregarFacturasaPagos(Pagodetalle pago) {
//     return pagos.add(pago);
//   }

//   static List<Pagodetalle> getDetalleFactura() {
//     return pagos;
//   }

//   static actualizardetalle(int index, double? monto) {
//     if (monto != null) {
//       pagos[index].montoPagado = monto;
//     }
//   }

//   static eliminarpago(int index) {
//     pagos.removeAt(index);
//     pagos.remove(index);
//     return null;
//   }

//   static double obtenerSubtotal() {
//     if (pagos.length > 0) {
//       double monto = pagos
//           .map((e) => e.montoPagado)
//           .reduce((value, element) => value + element);
//       if (monto != 0) {
//         return monto;
//       }
//     }
//     return 0;
//   }

//   static ActualizarFacutas() {
//     pagos.forEach((element) {
//       actualizarMontoFactura(
//           element.numeroDeFactura, element.montoPagado.toString());
//     });
//   }

//   static void actualizarMontoFactura(String numerofactura, String montoPagado) {
//     DatabaseHelper.instance.actualizarMontoFactura(numerofactura, montoPagado);
//   }
// }

// To parse this JSON data, do
//
//     final pagoDetalle = pagoDetalleFromJson(jsonString);

import 'dart:convert';

Map<String, PagoDetalle> pagoDetalleFromJson(String str) =>
    Map.from(json.decode(str)).map(
        (k, v) => MapEntry<String, PagoDetalle>(k, PagoDetalle.fromJson(v)));

String pagoDetalleToJson(Map<String, PagoDetalle> data) => json.encode(
    Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

class PagoDetalle {
  PagoDetalle(
      {this.id,
      this.pagoId,
      required this.formaDePago,
      required this.facturaId,
      required this.montoAplicado,
      required this.montoDeFacturaAlMomento,
      required this.sincronizado,
      required this.compagni,
      required this.isDelete,
      required this.activo,
      this.estado});

  int? id;
  int? pagoId;
  String facturaId;
  String formaDePago;
  double montoAplicado;
  double montoDeFacturaAlMomento;
  int sincronizado;
  int compagni;
  int isDelete;
  int activo;
  int? estado;

  Map<String, dynamic> toJsonsqlinsert() => {
        "pagoId": pagoId,
        "facturaId": facturaId,
        "formaDePago": formaDePago,
        "montoAplicado": montoAplicado,
        "montoDeFacturaAlMomento": montoDeFacturaAlMomento,
        "sincronizado": sincronizado,
        "compagni": compagni,
        "isDelete": isDelete,
      };

  factory PagoDetalle.fromJson(Map<String, dynamic> json) => PagoDetalle(
        id: json["Id"],
        facturaId: json["facturaId"],
        pagoId: json["pagoId"],
        montoAplicado: json["montoAplicado"]?.toDouble(),
        montoDeFacturaAlMomento: json["montoDeFacturaAlMomento"]?.toDouble(),
        sincronizado: json["sincronizado"],
        compagni: json["compagni"],
        isDelete: json["isDelete"],
        activo: 0,
        formaDePago: 'N/A',
      );

  Map<String, dynamic> toJson() => {
        "pagoId": pagoId,
        "Compagni": compagni,
        "facturaId": facturaId,
        "IsDelete": isDelete,
        "montoAplicado": montoAplicado,
        "sincronizado": sincronizado,
        "montoDeFacturaAlMomento": montoDeFacturaAlMomento,
      };

  static List<PagoDetalle> pagos = [];

  static void agregarFacturasaPagos(PagoDetalle pago) {
    return pagos.add(pago);
  }

  static List<PagoDetalle> getDetalleFactura() {
    return pagos;
  }

  static actualizardetalle(int index, double? monto) {
    if (monto != null) {
      pagos[index].montoAplicado = monto;
    }
  }

  static eliminarpago(int index) {
    pagos.removeAt(index);
    pagos.remove(index);
    return null;
  }

  static double obtenerSubtotal() {
    if (pagos.length > 0) {
      double monto = pagos
          .map((e) => e.montoAplicado)
          .reduce((value, element) => value + element);
      if (monto != 0) {
        return monto;
      }
    }
    return 0;
  }
}

class PagoDetalleLista {
  PagoDetalleLista(
      {this.id,
      this.facturaId,
      required this.fechaPago,
      this.metodoDePago,
      this.montoPagado,
      this.estado});

  int? id;
  DateTime fechaPago;
  String? facturaId;
  String? metodoDePago;
  double? montoPagado;
  String? estado;

  factory PagoDetalleLista.fromMapSqlLiteWitId(Map<String, dynamic> json) =>
      PagoDetalleLista(
          id: json["id"],
          fechaPago: DateTime.parse(json["fechaPago"]),
          metodoDePago: json["MetodoDePago"],
          montoPagado: json["montoPagado"]?.toDouble(),
          facturaId: json["facturaId"],
          estado: json["estado"]);

  // int sincronizado;
  // int compagni;
  // int isDelete;
  // int activo;
  // int? estado;
}

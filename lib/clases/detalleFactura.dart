// import 'dart:convert' show json;

// FacturaDetalleAsync facturaDetalleAsyncFromJson(String str) =>
//     FacturaDetalleAsync.fromJson(json.decode(str));

// String facturaDetalleAsyncToJson(FacturaDetalleAsync data) =>
//     json.encode(data.toJson());

// class FacturaDetalleAsync {
//   FacturaDetalleAsync({
//     required this.facturaNumero,
//     required this.lineaNumero,
//     required this.nombre,
//     required this.precioDeventa,
//     required this.productoCodigo,
//     required this.qty,
//     required this.montoLinea,
//   });

//   String facturaNumero;
//   int lineaNumero;
//   String nombre;
//   double precioDeventa;
//   String productoCodigo;
//   int qty;
//   double montoLinea;

//   factory FacturaDetalleAsync.fromJson(Map<String, dynamic> json) =>
//       FacturaDetalleAsync(
//         facturaNumero: json["FacturaNumero"],
//         lineaNumero: json["LineaNumero"],
//         nombre: json["Nombre"],
//         precioDeventa: json["PrecioDeventa"]?.toDouble(),
//         productoCodigo: json["ProductoCodigo"],
//         qty: json["Qty"],
//         montoLinea: json["montoLinea"]?.toDouble(),
//       );

//   Map<String, dynamic> toJson() => {
//         "FacturaNumero": facturaNumero,
//         "LineaNumero": lineaNumero,
//         "Nombre": nombre,
//         "PrecioDeventa": precioDeventa,
//         "ProductoCodigo": productoCodigo,
//         "Qty": qty,
//         "montoLinea": montoLinea,
//       };

//   Map<String, dynamic> toMap() {
//     return {
//       "FacturaNumero": facturaNumero,
//       "LineaNumero": lineaNumero,
//       "Nombre": nombre,
//       "PrecioDeventa": precioDeventa,
//       "ProductoCodigo": productoCodigo,
//       "Qty": qty,
//       "montoLinea": montoLinea,
//     };
//   }
// }

// To parse this JSON data, do
//
//     final facturaDetalle = facturaDetalleFromMap(jsonString);

import 'dart:convert';

import 'package:flutter/physics.dart';
import 'package:sigalogin/clases/global.dart';
import 'package:sigalogin/clases/modelos/facturaM.dart';
import 'package:sigalogin/pantallas/clientes/detalleDeFactura.dart';
import 'package:sigalogin/servicios/db_helper.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class FacturaDetalle {
  FacturaDetalle({
    this.id,
    required this.facturaId,
    required this.lineaNumero,
    required this.productoCodigo,
    required this.nombre,
    required this.precioVenta,
    required this.qty,
    required this.compagnia,
    required this.montoLinea,
    required this.sincronizado,
    required this.isDelete,
  });

  String facturaId;
  int? id;
  String nombre;
  double lineaNumero;
  double montoLinea;
  double precioVenta;
  String productoCodigo;
  double qty;
  int compagnia;
  int isDelete;
  int sincronizado;

  factory FacturaDetalle.fromJson(String str) =>
      FacturaDetalle.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FacturaDetalle.fromMap(Map<String, dynamic> json) => FacturaDetalle(
        id: json["ID"],
        facturaId: json["FacturaId"].toString().trim(),
        lineaNumero: json["LineaNumero"].toDouble(),
        nombre: json["Nombre"].toString().trim(),
        precioVenta: json["PrecioVenta"].toDouble(),
        productoCodigo: json["ProductoCodigo"].toString().trim(),
        qty: json["Qty"],
        montoLinea: json["montoLinea"].toDouble(),
        sincronizado: json["Sincronizado"],
        compagnia: json["Compagnia"],
        isDelete: json["IsDelete"],
      );

  Map<String, dynamic> toMap() => {
        "Compagnia": compagnia,
        "FacturaId": facturaId,
        "ID": id,
        "IsDelete": isDelete,
        "LineaNumero": lineaNumero,
        "Nombre": nombre,
        "PrecioVenta": precioVenta,
        "ProductoCodigo": productoCodigo,
        "Qty": qty,
        "Sincronizado": sincronizado,
        "montoLinea": montoLinea,
      };

  static List<FacturaDetalle> _detalle = [];
  static Future obtenerDetalle() async {
    var documento = await DatabaseHelper.instance.obtenerDetalleDeFactura()
        as List<FacturaDetalle>;
    documento.forEach((element) {
      _detalle.add(element);
    });
  }

  static Future obtenerDetallePorFacturaId(String facturaId) async {
    var documento = await DatabaseHelper.instance
        .obtenerDetalleDeFacturaPorFacturaId(facturaId);
    documento.forEach((element) {
      _detalle.add(element);
    });
  }

  static List<FacturaDetalle> getDetalleFactura() {
    return _detalle;
  }
}

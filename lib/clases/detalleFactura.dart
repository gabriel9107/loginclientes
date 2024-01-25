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
  int qty;
  int compagnia;
  int isDelete;
  int sincronizado;

  factory FacturaDetalle.fromJson(String str) =>
      FacturaDetalle.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FacturaDetalle.fromMap(Map<String, dynamic> json) => FacturaDetalle(
        compagnia: json["Compagnia"],
        facturaId: json["FacturaId"].toString().trim(),
        id: json["ID"],
        lineaNumero: json["LineaNumero"].toDouble(),
        montoLinea: json["MontoLinea"].toDouble(),
        nombre: json["Nombre"].toString().trim(),
        precioVenta: json["PrecioVenta"].toDouble(),
        productoCodigo: json["ProductoCodigo"].toString().trim(),
        qty: json["Qty"],
        sincronizado: json["Sincronizado"],
        isDelete: json["isDelete"],
      );

  factory FacturaDetalle.fromMapSql(Map<String, dynamic> json) =>
      FacturaDetalle(
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

  Map<String, dynamic> toMapSql() => {
        "Compagnia": compagnia,
        "FacturaId": facturaId,
        "isDelete": isDelete,
        "LineaNumero": lineaNumero,
        "Nombre": nombre,
        "PrecioVenta": precioVenta,
        "ProductoCodigo": productoCodigo,
        "Qty": qty,
        "Sincronizado": sincronizado,
        "MontoLinea": montoLinea,
      };
  Map<String, dynamic> toMap() => {
        "Compagnia": compagnia,
        "FacturaId": facturaId,
        "ID": id,
        "isDelete": isDelete,
        "LineaNumero": lineaNumero,
        "Nombre": nombre,
        "PrecioVenta": precioVenta,
        "ProductoCodigo": productoCodigo,
        "Qty": qty,
        "Sincronizado": sincronizado,
        "MontoLinea": montoLinea,
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

  static limpiarFactura() {
    _detalle.clear();
  }

  static List<FacturaDetalle> getDetalleFactura() {
    return _detalle;
  }
}


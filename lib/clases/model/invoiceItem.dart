import 'package:flutter/foundation.dart';

class InvoiceItem {
  final String description;
  final DateTime date;
  final int quantity;
  final double vat;
  final double unitPrice;

  const InvoiceItem(
      {required this.description,
      required this.date,
      required this.quantity,
      required this.vat,
      required this.unitPrice});
}

class Cuadre {
  final String sistema;
  final String reporteNombre;
  final String nombreVendedor;
  final DateTime fechaReporte;

  const Cuadre(
      {required this.sistema,
      required this.reporteNombre,
      required this.nombreVendedor,
      required this.fechaReporte});
}

class detalleCuadre {
  final int? numeroRecibo;
  final int codigo;
  final String nombre;
  final DateTime fechaRecibo;
  final double montoRecibo;
  final String facturaNumero;
  final String metodoPago;
  final String referencia;

  const detalleCuadre(
      {this.numeroRecibo,
      required this.codigo,
      required this.nombre,
      required this.fechaRecibo,
      required this.montoRecibo,
      required this.facturaNumero,
      required this.metodoPago,
      required this.referencia});

  factory detalleCuadre.fromMapSql(Map<String, dynamic> json) => detalleCuadre(
      numeroRecibo: json['numeroRecibo'],
      codigo: json['codigo'],
      nombre: json['nombre'],
      fechaRecibo: json['fechaRecibo'],
      montoRecibo: json['montoRecibo'],
      facturaNumero: json['facturaNumero'],
      metodoPago: json['metodoPago'],
      referencia: json['referencia']);
}

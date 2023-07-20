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

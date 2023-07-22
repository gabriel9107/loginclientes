import 'package:sigalogin/clases/model/InvoiceItem.dart';
import 'package:sigalogin/clases/model/customer.dart';
import 'package:sigalogin/clases/model/supplier.dart';

class Invoice {
  final InvoiceInfo info;
  final Supplier supplier;
  final Customer customer;
  final List<InvoiceItem> items;

  const Invoice(
      {required this.info,
      required this.supplier,
      required this.customer,
      required this.items});
}

class InvoiceInfo {
  final String descripction;
  final String number;
  final DateTime date;
  final DateTime dueDate;

  const InvoiceInfo(
      {required this.descripction,
      required this.number,
      required this.date,
      required this.dueDate});
}

class CuadreHeader {
  final String sistema;
  final String tema;
  final String vendedor;
  final List<detalleCuadre> items;

  const CuadreHeader(
      {required this.sistema,
      required this.tema,
      required this.vendedor,
      required this.items});
}

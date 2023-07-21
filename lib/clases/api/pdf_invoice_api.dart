import 'dart:async';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:sigalogin/clases/api/pdf_api.dart';

import '../model/invoice.dart';

class PdfInvoiceApi {
  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (Context) =>
          [buildTitle(invoice), builInvoice(invoice), Divider()],
      buildTotales(),
    ));

    return PdfFile.saveDocument(name: 'myCobros.pdf', pdf: pdf);
  }

  static Widget buildTitle(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SISTEMA SIGA, SRL',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text('Cuadre de transacciones por origen del ingreso'),
          SizedBox(height: 0.5 * PdfPageFormat.cm),
          Text('Gabriel Montero Terrero'),
          SizedBox(height: 0.9 * PdfPageFormat.cm)
        ],
      );

  static Widget builInvoice(Invoice invoice) {
    final headers = [
      'Numero',
      'Codigo',
      'Nombre',
      'Fecha Recibo',
      'Monto Recibo',
      'Factura Pagada',
      'Medio de Pago',
      'Referencia'
    ];

    final data = invoice.items.map((item) {
      final total = item.unitPrice * item.quantity * (1 + item.vat);

      return [
        item.description,
        item.description,
        item.description,
        item.description,
        item.description,
        item.description,
        item.description,
        item.description
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellHeight: 10,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.center,
        2: Alignment.centerLeft,
        3: Alignment.centerLeft,
        4: Alignment.centerLeft,
        5: Alignment.centerLeft,
        6: Alignment.centerLeft,
        7: Alignment.centerLeft
      },
    );
  }
}

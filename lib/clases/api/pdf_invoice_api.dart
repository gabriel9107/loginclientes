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
      build: (Context) => [
        buildTitle(invoice),
        builInvoice(invoice),
      ],
    ));

    return PdfFile.saveDocument(name: 'myCobros.pdf', pdf: pdf);
  }

  static Widget buildTitle(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cuadre de transacciones por origen de ingreso',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text(invoice.info.descripction)
        ],
      );

  static Widget builInvoice(Invoice invoice) {
    final headers = [
      'Numero Recibo',
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
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.green300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
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

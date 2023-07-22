import 'dart:async';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:sigalogin/clases/api/pdf_api.dart';
import 'package:sigalogin/clases/model/invoiceItem.dart';

import '../model/invoice.dart';
import '../utils.dart';

class PdfInvoiceApi {
  static Future<File> generate(CuadreHeader invoice) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (Context) => [
        buildTitle(invoice),
        builInvoice(invoice),
        Divider(),
        buildTotal(invoice)
      ],
      // buildTotales(),
    ));

    return PdfFile.saveDocument(name: 'myCobros.pdf', pdf: pdf);
  }

  static Widget buildTitle(CuadreHeader invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SISTEMA SIGA, SRL',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text(invoice.tema),
          SizedBox(height: 0.5 * PdfPageFormat.cm),
          Text(invoice.vendedor),
          SizedBox(height: 0.9 * PdfPageFormat.cm)
        ],
      );

  static Widget builInvoice(CuadreHeader invoice) {
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
      // final total = item.montoRecibo.sum;

      return [
        item.codigo,
        item.codigo,
        item.nombre,
        item.fechaRecibo,
        item.montoRecibo,
        item.facturaNumero,
        item.metodoPago,
        item.referencia,
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 9),
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
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

  static Widget buildTotal(CuadreHeader invoice) {
    final netTotal = invoice.items
        .map((item) => item.montoRecibo)
        .reduce((item1, item2) => item1 + item2);

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'total',
                  value: Utils.formatPrice(netTotal),
                  unite: true,
                ),
                Divider(),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}

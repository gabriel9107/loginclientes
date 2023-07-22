import 'dart:async';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:sigalogin/clases/api/pdf_api.dart';

import '../model/invoice.dart';

class pdfFacturaAPi {
  static Future<File> generarFactura(Invoice invoice) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (Context) => [
        crearTitulo(invoice)
        // , builInvoice(invoice), Divider()
      ],
      // buildTotales(),
    ));

    return PdfFile.saveDocument(name: 'myCobros.pdf', pdf: pdf);
  }

  static Widget crearTitulo(Invoice invoice) => Column(
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
}

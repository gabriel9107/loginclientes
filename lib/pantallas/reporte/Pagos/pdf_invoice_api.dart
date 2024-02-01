import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sigalogin/clases/global.dart';
import 'package:sigalogin/clases/modelos/pago.dart';
import 'file_handle_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfInvoiceApi {
  static Future<File> generate(List<PagoReporte> tableDataa) async {
    final pdf = pw.Document();

    double totalMonto = 0;
    tableDataa.forEach((element) {
      totalMonto += element.montoPagado;
    });

    final tableHeaders = [
      'Numero Recibo',
      'Codigo',
      'Nombre',
      'Fecha Recibo',
      'Monto Recibo',
      'Factura',
      'Tipo de Pago',
      'Soporte'
    ];

    // final tableData = [
    //   [
    //     'Coffee',
    //     '7',
    //     '\$ 5',
    //     '1 %',
    //     '\$ 35',
    //   ],
    //   [
    //     'Blue Berries',
    //     '5',
    //     '\$ 10',
    //     '2 %',
    //     '\$ 50',
    //   ],
    //   [
    //     'Water',
    //     '1',
    //     '\$ 3',
    //     '1.5 %',
    //     '\$ 3',
    //   ],
    //   [
    //     'Apple',
    //     '6',
    //     '\$ 8',
    //     '2 %',
    //     '\$ 48',
    //   ],
    //   [
    //     'Lunch',
    //     '3',
    //     '\$ 90',
    //     '12 %',
    //     '\$ 270',
    //   ],
    //   [
    //     'Drinks',
    //     '2',
    //     '\$ 15',
    //     '0.5 %',
    //     '\$ 30',
    //   ],
    //   [
    //     'Lemon',
    //     '4',
    //     '\$ 7',
    //     '0.5 %',
    //     '\$ 28',
    //   ],
    // ];

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.legal,
        orientation: pw.PageOrientation.landscape,

        // header: (context) {
        //   return pw.Text(
        //     'Flutter Approach',
        //     style: pw.TextStyle(
        //       fontWeight: pw.FontWeight.bold,
        //       fontSize: 15.0,
        //     ),
        //   );
        // },
        build: (context) {
          return [
            pw.Row(
              children: [
                pw.SizedBox(width: 1 * PdfPageFormat.mm),
                pw.Column(
                  mainAxisSize: pw.MainAxisSize.min,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "siga SRL",
                      style: pw.TextStyle(
                        fontSize: 17.0,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'CUADRE DE TRANSACCIONES POR ORIGEN DEL INGRESO',
                      style: const pw.TextStyle(
                        fontSize: 10.0,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
                pw.Spacer(),
                pw.Column(
                  mainAxisSize: pw.MainAxisSize.min,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      nombre_Usuario,
                      style: pw.TextStyle(
                        fontSize: 15.5,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      usuario,
                    ),
                    pw.Text(
                      DateTime.now().toString().substring(1, 10),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.Divider(),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            // pw.Text(
            //   'Dear John,\nLorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitia, molestiae quas vel sint commodi repudiandae consequuntur voluptatum laborum numquam blanditiis harum quisquam eius sed odit fugiat iusto fuga praesentium optio, eaque rerum! Provident similique accusantium nemo autem. Veritatis obcaecati tenetur iure eius earum ut molestias architecto voluptate aliquam nihil, eveniet aliquid culpa officia aut! Impedit sit sunt quaerat, odit, tenetur error',
            //   textAlign: pw.TextAlign.justify,
            // ),
            pw.SizedBox(height: 5 * PdfPageFormat.mm),

            ///
            /// PDF Table Create
            ///
            pw.Table.fromTextArray(
              headers: tableHeaders,
              data: List<List<String>>.generate(
                  tableDataa.length,
                  (row) => List<String>.generate(tableHeaders.length,
                      (col) => tableDataa[row].getIndex(col))),
              border: null,
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.grey300),
              cellHeight: 30.0,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerRight,
                2: pw.Alignment.centerRight,
                3: pw.Alignment.centerRight,
                4: pw.Alignment.centerRight,
              },
            ),
            pw.Divider(),
            pw.Container(
              alignment: pw.Alignment.centerRight,
              child: pw.Row(
                children: [
                  pw.Spacer(flex: 6),
                  pw.Expanded(
                    flex: 4,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Divider(),
                        pw.Row(
                          children: [
                            pw.Expanded(
                              child: pw.Text(
                                'Total',
                                style: pw.TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                            pw.Text(
                              '\$' + totalMonto.toStringAsFixed(2),
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 2 * PdfPageFormat.mm),
                        pw.Container(height: 1, color: PdfColors.grey400),
                        pw.SizedBox(height: 0.5 * PdfPageFormat.mm),
                        pw.Container(height: 1, color: PdfColors.grey400),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
        footer: (context) {
          return pw.Column(
            mainAxisSize: pw.MainAxisSize.min,
            children: [],
          );
        },
      ),
    );

    return FileHandleApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }
}

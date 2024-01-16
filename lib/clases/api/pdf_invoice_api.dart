import 'dart:io';
import 'dart:typed_data';

// import 'package:open_document/open_document.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:sigalogin/clases/global.dart';
import 'package:sigalogin/clases/model/customer.dart';
import 'package:sigalogin/clases/modelos/pago.dart';
import 'package:sigalogin/clases/utils.dart';
import 'package:sigalogin/helper/model/invoice.dart';

import '../../helper/pdf_helper.dart';
import '../model/supplier.dart';

class customRow {
  final String itemName;
  final String itemPrice;
  final String ammount;
  final String total;
  final String vat;

  customRow(this.itemName, this.itemPrice, this.ammount, this.total, this.vat);
}

class customRowPago {
  final String numeroRecibo;
  final String codigo;
  final String nombre;
  final String fechaRecibo;
  final String montoRecibo;
  final String facturaPagada;
  final String tipoPago;

  final String fechaCorrecta;
  final String noCheque;

  customRowPago(
      this.numeroRecibo,
      this.codigo,
      this.nombre,
      this.fechaRecibo,
      this.montoRecibo,
      this.facturaPagada,
      this.tipoPago,
      this.fechaCorrecta,
      this.noCheque);
}

class pdfInvoiceServices {
  static Future<Uint8List> createInvoice(List<Pago> pagos) async {
    final pdf = pw.Document();

    pdf.addPage(
      Page(
          pageFormat:
              PdfPageFormat.a4.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
          margin: EdgeInsets.all(20),
          orientation: PageOrientation.landscape,
          build: (Context context) {
            return ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: 20),
                  alignment: Alignment.bottomLeft,
                  child: Text(compagniaTexto,
                      style: TextStyle(color: PdfColors.black, fontSize: 20)),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 20),
                  alignment: Alignment.topLeft,
                  child: Text("CUADRE DE TRANSACIONES POR ORIGEN DEL INGRESO",
                      style: TextStyle(color: PdfColors.black, fontSize: 20)),
                ),
                Container(
                    height: 1.0,
                    width: 600.0,
                    color: PdfColors.red,
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 10)),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(10),
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text("Gabriel Montero Terrero",
                                  style: TextStyle(color: PdfColors.red)),
                            ),
                            Container(
                              child: Text("402-21025725-5"),
                            ),
                          ]),
                      SizedBox(height: 30, width: 30),
                      // Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: <Widget>[
                      //       SizedBox(height: 30),
                      //       Container(child: Text("GSTIN")),
                      //       Container(child: Text("State")),
                      //       Container(child: Text("Pan")),
                      //     ]),
                      // Column(
                      //     crossAxisAlignment: CrossAxisAlignment.end,
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: <Widget>[
                      //       SizedBox(height: 30),
                      //       Container(child: Text("  0727232387A8")),
                      //       Container(child: Text("07-Delhi")),
                      //       Container(child: Text("AAGCB9745G")),
                      //     ]),
                      // Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //     children: <Widget>[
                      //       SizedBox(height: 30),
                      //       Container(child: Text("Invoice Date")),
                      //       Container(child: Text("Invoice No.")),
                      //       Container(child: Text("Refrence No.")),
                      //     ]),
                      // Column(
                      //     crossAxisAlignment: CrossAxisAlignment.end,
                      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //     children: <Widget>[
                      //       SizedBox(height: 30),
                      //       Container(child: Text("12/07/2019")),
                      //       Container(child: Text("BNMK/2020/18")),
                      //       Container(child: Text("")),
                      //     ]),
                    ]),
                // //Create a line

                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[]),
                Container(
                    height: 1.0,
                    width: 600.0,
                    color: PdfColors.red,
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 10)),
                Container(
                  color: PdfColors.yellow200,
                  padding: EdgeInsets.all(20),
                  child: Table(
                      tableWidth: TableWidth.max,
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: <TableRow>[
                        TableRow(children: <Widget>[
                          Container(child: Text("Numero\nRecibo")),
                          Container(width: 50, child: Text('Codigo')),
                          Container(width: 80, child: Text("Nombre")),
                          Container(child: Text("Fecha recibo")),
                          Container(child: Text("Monto Recibo")),
                          Container(child: Text("Factura pgada")),
                          Container(child: Text("Tipo De Pago")),
                          Container(child: Text("Fecha ")),
                          Container(child: Text("Referencia")),
                        ]),

                        // TableRow(children: <Widget>[
                        //   Container(child: Text("4456")),
                        //   Container(width: 30, child: Text("90600142658")),
                        //   Container(
                        //       width: 80,
                        //       child: Text("Taller y Rep. Juan (Navarrete)")),
                        //   Container(child: Text("3/28/2023")),
                        //   Container(child: Text("3280.00")),
                        //   Container(child: Text("FVS02531")),
                        //   Container(child: Text("Cheque")),
                        //   Container(child: Text("3/28/2023")),
                        //   Container(height: 30, child: Text("5702")),

                        // TableRow(children: <Widget>[
                        //   SizedBox(),
                        //   Container(child: Text("Total")),
                        //   Container(child: Text("1")),
                        //   Container(child: Text("4000.00")),
                        //   Container(child: Text("3280.00")),
                        //   Container(child: Text("720.00")),
                        //   Container(child: Text("4000.00")),
                        // ]),
                      ]),
                ),

                for (var item in pagos)
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Table(
                        tableWidth: TableWidth.max,
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: <TableRow>[
                          TableRow(children: <Widget>[
                            Container(width: 50, child: Text("90600142658")),
                            Container(
                                width: 80,
                                child: Text("Taller y Rep. Juan (Navarrete)")),
                            Container(child: Text("3/28/2023")),
                            Container(child: Text("3280.00")),
                            Container(child: Text("FVS02531")),
                            Container(child: Text("Cheque")),
                            Container(child: Text("3/28/2023")),
                            Container(height: 30, child: Text("5702")),
                          ]),
                        ]),
                  ),

                Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            SizedBox(height: 15),
                            Container(child: Text("Grand Total")),
                            SizedBox(width: 15),
                            Container(child: Text("4000")),
                          ]),
                      SizedBox(height: 15),
                      // Column(
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: <Widget>[
                      //       Container(child: Text("SNA SISTEC Pvt Ltd")),
                      //       Container(child: PdfLogo()),
                      //       Container(child: Text("Authorized Signatory")),
                      //     ])
                    ]),
                // Container(
                //     height: 1.0,
                //     width: 600.0,
                //     color: PdfColors.black,
                //     margin: const EdgeInsets.fromLTRB(0, 10, 0, 10)),
                // Text("Terms and Condition Applied*")
              ],
            );
          }),
    );
    return pdf.save();
  }

  static Future<Uint8List> createHelloWorld() async {
    // final font = await rootBundle.load("assets/OpenSans-Bold.ttf");
    // final ttf = pdfLib.Font.ttf(font);
    // final fontBold = await rootBundle.load("assets/OpenSans-BoldItalic.ttf");
    // final ttfBold = pdfLib.Font.ttf(fontBold);
    // final fontItalic = await rootBundle.load("assets/OpenSans-Italic.ttf");
    // final ttfItalic = pdfLib.Font.ttf(fontItalic);
    // final fontBoldItalic = await rootBundle.load("assets/OpenSans-Regular.ttf");
    // final ttfBoldItalic = pdfLib.Font.ttf(fontBoldItalic);

    // var myTheme = ThemeData.withFont(
    //   base: ttf,
    //   bold: ttfBold,
    //   italic: ttfItalic,
    //   boldItalic: ttfBoldItalic,
    // );

    final font = await rootBundle.load("assets/OpenSans-Bold.ttf");
    final ttf = Font.ttf(font);

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
              child: pw.Text("hello world", style: pw.TextStyle(font: ttf)));
        },
      ),
    );
    return pdf.save();
  }

  static Future<void> savePdfFile(String fileName, Uint8List byteList) async {
    final output = await getTemporaryDirectory();
    var filePath = "${output.path}/$fileName.pdf";
    final file = File(filePath);
    await file.writeAsBytes(byteList);

    await OpenFile.open(filePath);
    //  await OpenDocument.openDocument(filePath: filePath);
  }

  static Future<File> saveDocument(
      {required String name, required Document pdf}) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);
    return file;
  }

  static Future openFile(File file) async {
    final Url = file.path;

    await OpenFile.open(Url);
  }

  static pw.Row address() {
    return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            children: [
              pw.Text("Nombre Vendedor"),
              pw.Text("Codigo Vendedor"),
            ],
          ),
          pw.Column(
            children: [pw.Text("Gabriel Montero"), pw.Text("40221025725")],
          )
        ]);
  }
}

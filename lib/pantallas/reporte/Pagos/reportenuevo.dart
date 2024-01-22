import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sigalogin/clases/modelos/pago.dart';
import 'package:sigalogin/clases/themes.dart';
import 'package:sigalogin/pantallas/NavigationDrawer.dart';
import 'package:sigalogin/pantallas/reporte/Pagos/file_handle_api.dart';
import 'package:sigalogin/pantallas/reporte/Pagos/pdf_invoice_api.dart';
import 'package:sigalogin/servicios/db_helper.dart';

import 'package:sigalogin/clases/api/pdf_api.dart';
import 'package:sigalogin/clases/api/pdf_invoice_api.dart';

class MyReportePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyReportePage> {
  List<Pago> pagoList = [];
  var formatter = new DateFormat('yyyy-MM-dd');
  DateTime fromDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime toDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  Future<DateTime> selectDate(BuildContext context, DateTime _date) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2018),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      _date = picked;
    }
    return _date;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Reporte de cobro"),
          backgroundColor: navBar,
          actions: [
            IconButton(
              icon: const Icon(Icons.print),
              onPressed: () async {
                final pdfFile = await PdfInvoiceApi.generate();

                // opening the pdf file
                FileHandleApi.openFile(pdfFile);

                // final data = await pdfInvoiceServices.createInvoice(pagoList);
                // pdfInvoiceServices.savePdfFile("Invociee", data);
              },
            )
          ],
        ),
        drawer: navegacions(),
        body: SafeArea(
            top: true,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                    width: 700,
                    height: 80,
                    child: Row(children: [
                      Text("Desde"),
                      IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () async {
                          fromDate = await selectDate(context, fromDate);
                          setState(() {});
                        },
                      ),
                      Text('${formatter.format(fromDate)}'),
                      Spacer(flex: 1),
                      Text("Hasta"),
                      IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () async {
                          toDate = await selectDate(context, toDate);
                          setState(() {});
                        },
                      ),
                      Text('${formatter.format(toDate)}'),
                      IconButton(
                          icon: const Icon(Icons.search),
                          color: Colors.blue,
                          onPressed: () async {
                            List<Pago> pagos = await DatabaseHelper.instance
                                .obtenerPagosPorFechaParaReporte(
                                    fromDate.toString(), toDate.toString());
                            setState(() {
                              pagoList = pagos;
                            });
                            print(pagoList);
                          })
                    ])),

                Column(
                  children: <Widget>[
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: pagoList.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = pagoList[index];
                        return Card(
                          color: Colors.white,
                          elevation: 2.0,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: const Icon(Icons.money),
                            ),
                            title: Text(
                                "Nombre Cliente : Cliente de Prueba (Cambiar Nombre)      "
                                        "Cliente ID :" +
                                    item.clienteId.toString()),
                            subtitle: Text("Monto Recibido" +
                                item.montoPagado.toStringAsFixed(2) +
                                "                     Fecha Pago : " +
                                item.fechaPago.toString()),
                          ),
                        );
                      },
                    ),
                  ],
                )

                // Column(children: [
                //   ListView.builder(
                //     itemCount: pagoList.length,
                //     itemBuilder: (BuildContext context, int index) {
                //       return;
                //     },
                //   ),
                // ])
              ],
            )));
  }
}

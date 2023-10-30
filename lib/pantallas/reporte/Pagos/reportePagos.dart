import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sigalogin/clases/api/pdf_api.dart';
import 'package:sigalogin/clases/api/pdf_invoice_api.dart';
import 'package:sigalogin/clases/modelos/pago.dart';

import 'package:sigalogin/clases/themes.dart';
import 'package:sigalogin/helper/model/customer.dart';
import 'package:sigalogin/helper/model/invoice.dart';
import 'package:sigalogin/pantallas/NavigationDrawer.dart';

import 'package:sqflite/sqflite.dart';

import '../../../clases/model/supplier.dart';
import '../../../servicios/db_helper.dart';

class ReportePagos extends StatefulWidget {
  @override
  createState() => ProductsListState();
}
// State<StatefulWidget> createState() {
//   return ProductsList();
// }

class ProductsListState extends State<ReportePagos> {
  Future<List<Pago>> pagos = DatabaseHelper.instance.obtenerPagosPorFecha();
  TextEditingController desdeController = TextEditingController();
  TextEditingController hastaController = TextEditingController();

  @override
  void initState() {
    pagos = DatabaseHelper.instance.obtenerPagosPorFecha();
    super.initState();
  }

  Widget build(BuildContext context) {
    // DBProvider().initializeDB();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporte de Cobros'),
        backgroundColor: navBar,
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () async {
              // final invoice = CuadreHeader(
              //     sistema: 'SISTEMA SIGA SRL.',
              //     vendedor: 'GABRIEL MONTERO TERRERO',
              //     tema: 'CUADRE DE TRANSACCIONES POR ORIGEN DEL INGRESO',
              //     items: [
              //       detalleCuadre(
              //           codigo: 4554,
              //           nombre: 'Taller y Respuesto Juan',
              //           numeroRecibo: 1,
              //           montoRecibo: 7500.00,
              //           facturaNumero: 'fVS025351',
              //           metodoPago: 'Efectivo',
              //           referencia: 'null',
              //           fechaRecibo: DateTime.now())
              //     ]);

              final date = DateTime.now();
              final dueDate = date.add(
                const Duration(days: 7),
              );

              final invoice = Invoice(
                supplier: const Supplier(
                  name: 'Faysal Neowaz',
                  address: 'Dhaka, Bangladesh',
                  paymentInfo: 'https://paypal.me/codespec',
                ),
                customer: const Customer(
                  name: 'Google',
                  address: 'Mountain View, California, United States',
                ),
                info: InvoiceInfo(
                  date: date,
                  dueDate: dueDate,
                  description: 'First Order Invoice',
                  number: '${DateTime.now().year}-9999',
                ),
                items: [
                  InvoiceItem(
                    description: 'Coffee',
                    date: DateTime.now(),
                    quantity: 3,
                    vat: 0.19,
                    unitPrice: 5.99,
                  ),
                  InvoiceItem(
                    description: 'Water',
                    date: DateTime.now(),
                    quantity: 8,
                    vat: 0.19,
                    unitPrice: 0.99,
                  ),
                  InvoiceItem(
                    description: 'Orange',
                    date: DateTime.now(),
                    quantity: 3,
                    vat: 0.19,
                    unitPrice: 2.99,
                  ),
                  InvoiceItem(
                    description: 'Apple',
                    date: DateTime.now(),
                    quantity: 8,
                    vat: 0.19,
                    unitPrice: 3.99,
                  ),
                  InvoiceItem(
                    description: 'Mango',
                    date: DateTime.now(),
                    quantity: 1,
                    vat: 0.19,
                    unitPrice: 1.59,
                  ),
                  InvoiceItem(
                    description: 'Blue Berries',
                    date: DateTime.now(),
                    quantity: 5,
                    vat: 0.19,
                    unitPrice: 0.99,
                  ),
                  InvoiceItem(
                    description: 'Lemon',
                    date: DateTime.now(),
                    quantity: 4,
                    vat: 0.19,
                    unitPrice: 1.29,
                  ),
                ],
              );

              final pdfFile = await PdfInvoicePdfHelper.generate(invoice);
              PdfFile.openFile(pdfFile);
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
              child: Row(
                children: [
                  Text('Desde :'),
                  Expanded(
                      child: Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(8, 10, 0, 10),
                            child: TextFormField(
                              controller: desdeController,
                              autocorrect: true,
                              decoration:
                                  InputDecoration(labelText: '2021/03/03'),
                              onTap: () async {
                                DateTime date = DateTime(1900);
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                              },
                            ),
                          ))),
                  Spacer(flex: 1),
                  Text('Hasta'),
                  Expanded(
                    child: Align(
                        alignment: AlignmentDirectional(0, 0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                          child: TextFormField(
                            controller: desdeController,
                            autocorrect: true,
                            decoration:
                                InputDecoration(labelText: '2021/03/03'),
                          ),
                        )),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    color: Colors.blue,
                    onPressed: () => {
                      // showSearch(
                      //     context: context,
                      //     delegate: MySearchDelegateParaProductos())
                    },
                  )
                ],
              ),
            ),
            Column(
              children: <Widget>[
                SizedBox(
                  height: 800,
                  child: FutureBuilder<List<Pago>>(
                    future: DatabaseHelper.instance.obtenerPagosPorFecha(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Pago>> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: Text('Cargando...'));
                      }
                      return snapshot.data!.isEmpty
                          ? Center(
                              child: Text(
                                  'No existen Pagos realizados para esta fechas...'))
                          : ListView(
                              children: snapshot.data!.map((producto) {
                                return Card(
                                  color: Colors.white,
                                  elevation: 2.0,
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Icon(Icons.money),
                                    ),
                                    title:
                                        Text('No : ' + producto.id.toString()),
                                    subtitle: Text('Nombre :' +
                                        producto.clienteId.toString()),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text('Monto Recibido :  '),
                                        Text(producto.montoPagado.toString())
                                      ],
                                    ),
                                    onTap: () {
                                      // NavigateDetail('Edit Product');
                                    },
                                  ),
                                );
                              }).toList(),
                            );
                    },
                  ),

                  // ListView(
                  //   padding: const EdgeInsets.all(8),
                  //   children: <Widget>[
                  //     Container(
                  //       height: 50,
                  //       color: Colors.amber[600],
                  //       child: const Center(child: Text('Entry A')),
                  //     ),
                  //     Container(
                  //       height: 50,
                  //       color: Colors.amber[500],
                  //       child: const Center(child: Text('Entry B')),
                  //     ),
                  //     Container(
                  //       height: 50,
                  //       color: Colors.amber[100],
                  //       child: const Center(child: Text('Entry C')),
                  //     ),
                  //   ],
                  // ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

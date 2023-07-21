import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sigalogin/clases/model/InvoiceItem.dart';
import 'package:sigalogin/clases/model/customer.dart';
import 'package:sigalogin/clases/model/invoice.dart';
import 'package:sigalogin/clases/model/supplier.dart';
import 'package:sigalogin/clases/modelos/pago.dart';
import 'package:sigalogin/clases/modelos/productos.dart';
import 'package:sigalogin/clases/themes.dart';
import 'package:sigalogin/pantallas/NavigationDrawer.dart';
import 'package:sigalogin/pantallas/buscar/busquedadeProductos.dart';
import 'package:sigalogin/pantallas/productos/products_detail.dart';
import 'package:sqflite/sqflite.dart';

import '../../../clases/api/pdf_api.dart';
import '../../../clases/api/pdf_invoice_api.dart';
import '../../../servicios/db_helper.dart';
import '../../busquedas/busquedaProductosenProducto.dart';

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
              final invoice = Invoice(
                  supplier: Supplier(
                      name: 'Gabriel Montero',
                      address: 'Nicolas Ramon #31',
                      paymentInfo: 'htttp://paypal.me/gamontero'),
                  customer: Customer(
                      name: 'Apple Inc', address: 'Direccion de prueba'),
                  info: InvoiceInfo(
                      date: DateTime.now(),
                      descripction: 'SISTEMA SIGA SRL.',
                      dueDate: DateTime.now(),
                      number: '1'),
                  items: [
                    InvoiceItem(
                        description: 'description',
                        date: DateTime.now(),
                        quantity: 40,
                        vat: 1.5,
                        unitPrice: 25.5)
                  ]);

              final pdfFile = await PdfInvoiceApi.generate(invoice);
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
                      showSearch(
                          context: context,
                          delegate: MySearchDelegateParaProductos())
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

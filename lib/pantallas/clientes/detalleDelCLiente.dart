import 'package:flutter/material.dart';
import 'package:sigalogin/clases/factura.dart';
import 'package:sigalogin/clases/modelos/pagodetalle.dart';
import 'package:sigalogin/clases/pedidos.dart';
import 'package:sigalogin/clases/themes.dart';

import 'package:sigalogin/pantallas/Pagos/realizarPago.dart';
import 'package:sigalogin/pantallas/clientes/detalleDeFactura.dart';
import 'package:sigalogin/pantallas/pedidos/PedidosVentas.dart';

import '../../clases/modelos/pago.dart';
import '../../servicios/db_helper.dart';
import '../NavigationDrawer.dart';
import '../Pagos/pago.dart';
import '../Pagos/pagodeprueba.dart';
import '../alertas.dart';
import 'new_cliente.dart';
import 'package:intl/intl.dart';

class DetalleDelCliente extends StatelessWidget {
  String? customerCode;
  String? nombredelcliente;
  DetalleDelCliente(this.customerCode, this.nombredelcliente);
  // const DetalleDelCliente({super.key}, this.customerCode);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.card_giftcard), text: 'Pedidos'),
                Tab(
                  icon: Icon(Icons.inventory),
                  text: 'Facturas',
                ),
                Tab(icon: Icon(Icons.paypal), text: 'Pagos'),
                // Tab(
                //   icon: Icon(Icons.directions_bike),
                //   text: 'Pedidos',
                // ),
              ],
            ),
            title:
                Text('Detalle del Cliente ' + this.nombredelcliente.toString()),
          ),
          drawer: navegacions(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              var existenPendientes = DatabaseHelper.instance
                  .obtenerFacturasPendientesdepago(customerCode.toString());

              if (existenPendientes == true) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RealizarPagodeprueba(
                          this.nombredelcliente.toString(),
                          this.customerCode.toString())),
                );
              } else {
                // print('No existen facturas pendientes de pago');
                showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                            title: const Text("Notificación :"),
                            content: const Text(
                                "No existen facturas pendientes de pago"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  child: const Text("Ok"),
                                ),
                              )
                            ]));
              }
            },
            tooltip: 'Agregar',
            child: const Icon(
              Icons.add,
            ),
          ),
          body: TabBarView(
            children: [
              // ListadoPedidos(const Icon(Icons.send), customerCode.toString()),
              ListadoPedidos(
                  const Icon(Icons.directions_car), customerCode.toString()),
              ListFactura(
                  const Icon(Icons.directions_car), customerCode.toString()),
              ListPagos(
                  const Icon(Icons.directions_car), customerCode.toString()),
              // ListPedidos(const Icon(Icons.directions_car)),
            ],
          ),
        ),
      ),
    );
  }
}

class ListadoPedidos extends StatelessWidget {
  Icon ic = const Icon(Icons.send);
  String customerCode;
  ListadoPedidos(this.ic, this.customerCode, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Pedido>>(
      future:
          DatabaseHelper.instance.obtenerPedidosPorClient(this.customerCode),
      builder: (BuildContext context, AsyncSnapshot<List<Pedido>> snapshot) {
        Future<void> _showMyDialog() async {
          return showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Country List'),
              );
            },
          );
        }

        if (!snapshot.hasData) {
          return Center(child: Text('Cargando...'));
        }
        return snapshot.data!.isEmpty
            ? Center(child: Text('No existen Facturas en el momento...'))
            : ListView(
                children: snapshot.data!.map((pedido) {
                  return Card(
                    color: Colors.white,
                    elevation: 2.0,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.inventory),
                      ),
                      title:
                          Text('Pedido Numero :' + ' ' + pedido.id.toString()),
                      subtitle: Text(
                        'Fecha ' +
                            DateFormat('dd-MM-yyy').format(pedido.fechaOrden),
                        textAlign: TextAlign.left,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                children: [
                                  Text('Monto pedido  : ',
                                      textAlign: TextAlign.left)
                                ],
                              ),
                              Column(
                                children: [
                                  Text('Estado : ', textAlign: TextAlign.left)
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    pedido.totalAPagar.toStringAsFixed(2),
                                  ),
                                  Text(
                                      pedido.sincronizado == 1
                                          ? 'Pendiente'
                                          : 'Recibido',
                                      style: TextStyle(
                                          color: pedido.sincronizado == 1
                                              ? Colors.deepOrange
                                              : Colors.blue),
                                      textAlign: TextAlign.left),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                      onTap: () {
                        // _showMyDialog();
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             DetalleDeFactura(pedidos.facturaId))
                        // );
                      },
                    ),
                  );
                }).toList(),
              );
      },
    );
  }
}

class ListFactura extends StatelessWidget {
  Icon ic = const Icon(Icons.abc);
  String customerCode;
  ListFactura(this.ic, this.customerCode, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> list = [
      "item1",
      "item2",
      "item3",
      "item4",
      "item5",
      "item6",
      "item7",
      "item8"
    ];
    return FutureBuilder<List<Factura>>(
      future: DatabaseHelper.instance
          // .getFacturas(),
          .getFacturasporClientes(this.customerCode.toString()),
      builder: (BuildContext context, AsyncSnapshot<List<Factura>> snapshot) {
        Future<void> _showMyDialog() async {
          return showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Country List'),
              );
              //   title: const Text('AlertDialog Title'),
              //   content: SingleChildScrollView(
              //     child: ListBody(
              //       children: const <Widget>[
              //         Text('This is a demo alert dialog.'),
              //         Text('Would you like to approve of this message?'),
              //       ],
              //     ),
              //   ),
              //   actions: <Widget>[
              //     TextButton(
              //       child: const Text('Approve'),
              //       onPressed: () {
              //         Navigator.of(context).pop();
              //       },
              //     ),
              //   ],
              // );
            },
          );
        }

        if (!snapshot.hasData) {
          return Center(child: Text('Cargando...'));
        }
        return snapshot.data!.isEmpty
            ? Center(child: Text('No existen Facturas en el momento...'))
            : ListView(
                children: snapshot.data!.map((factura) {
                  return Card(
                    color: Colors.white,
                    elevation: 2.0,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.inventory),
                      ),
                      title: Text('Factura Numero :' +
                          ' ' +
                          factura.facturaId.toString()),
                      subtitle: Text(
                        'Pedido Numero' + ' ' + factura.pedidoId,
                        textAlign: TextAlign.left,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                children: [
                                  Text('Monto Pagado : ',
                                      textAlign: TextAlign.left)
                                ],
                              ),
                              Column(
                                children: [
                                  Text('Monto Pendiente : ',
                                      textAlign: TextAlign.left)
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    factura.montoFactura.toString(),
                                  ),
                                  Text(
                                      ((factura.montoFactura -
                                              factura.totalPagado))
                                          .toString(),
                                      textAlign: TextAlign.left),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                      onTap: () {
                        // _showMyDialog();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetalleDeFactura(factura.facturaId)));
                      },
                    ),
                  );
                }).toList(),
              );
      },
    );
  }
}

class ListPagos extends StatelessWidget {
  Icon ic = const Icon(Icons.abc);
  String? clientesId;
  ListPagos(this.ic, this.clientesId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PagoDetalleLista>>(
        future: DatabaseHelper.instance
            .obtenerDetalleDePagoPorCliente(this.clientesId.toString()),
        builder: (BuildContext context,
            AsyncSnapshot<List<PagoDetalleLista>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Text('Cargando...'));
          }
          return snapshot.data!.isEmpty
              ? Center(child: Text('No existen Pagos en el momento...'))
              : ListView(
                  children: snapshot.data!.map((pago) {
                    return Card(
                        color: Colors.white,
                        elevation: 2.0,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.monetization_on),
                          ),

                          title: Text('Numero de Pago : ' + pago.id.toString()),

                          subtitle: Text('Fecha del pago : ' +
                              DateFormat('dd-MM-yyy').format(pago.fechaPago)),
                          // subtitle: Text(
                          //     'Fecha del pago :' + pago.fechaPago.toString()),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Column(
                                    children: [
                                      Text('Factura : ' +
                                          pago.facturaId.toString())
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('Forma de Pago : ' +
                                          pago.metodoDePago.toString())
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('Monto : ' +
                                          pago.montoPagado.toString())
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                height: 10,
                              ),
                              // Column(
                              //   children: [
                              //     Column(
                              //       children: [
                              //         Text('Monto'),
                              //         Text(
                              //           pago.montoPagado.toString(),
                              //         ),
                              //       ],
                              //     )
                              //   ],
                              // ),
                            ],
                          ),
                        ));
                  }).toList(),
                );
        });
  }

  Widget setupAlertDialoadContainer() {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text('Gujarat, India'),
          );
        },
      ),
    );
  }
//
}

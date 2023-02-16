import 'package:flutter/material.dart';
import 'package:sigalogin/clases/factura.dart';
import 'package:sigalogin/clases/themes.dart';

import 'package:sigalogin/pantallas/Pagos/realizarPago.dart';
import 'package:sigalogin/pantallas/pedidos/PedidosVentas.dart';

import '../../clases/modelos/pago.dart';
import '../../servicios/db_helper.dart';
import '../NavigationDrawer.dart';
import '../Pagos/pago.dart';
import '../Pagos/pagodeprueba.dart';
import 'new_cliente.dart';

class DetalleDelCliente extends StatelessWidget {
  String? customerCode;
  String? nombredelcliente;
  DetalleDelCliente(this.customerCode, this.nombredelcliente);
  // const DetalleDelCliente({super.key}, this.customerCode);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
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
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RealizarPagodeprueba(
                        this.nombredelcliente.toString(),
                        this.customerCode.toString())),
              );
            },
            tooltip: 'Agregar',
            child: const Icon(
              Icons.add,
            ),
          ),
          body: TabBarView(
            children: [
              ListFactura(
                  const Icon(Icons.directions_car), customerCode.toString()),
              ListPagos(const Icon(Icons.directions_car)),
              // ListPedidos(const Icon(Icons.directions_car)),
            ],
          ),
        ),
      ),
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
      future: DatabaseHelper.instance.getFacturas(),
      builder: (BuildContext context, AsyncSnapshot<List<Factura>> snapshot) {
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
                          'Pedido Numero' + ' ' + factura.pedidosId.toString()),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Column(
                                children: [Text('Monto Pagado : ')],
                              ),
                              Column(
                                children: [Text('Monto Pendiente : ')],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    factura.montoFactura,
                                  ),
                                  Text(
                                    factura.montoFactura,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                      onTap: () {},
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
  ListPagos(this.ic, {Key? key}) : super(key: key);

  String clientesId = '';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Pago>>(
        future: DatabaseHelper.instance.obtenerPagosPorClientes(clientesId),
        builder: (BuildContext context, AsyncSnapshot<List<Pago>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Text('Cargando...'));
          }
          return snapshot.data!.isEmpty
              ? Center(child: Text('No existen Facturas en el momento...'))
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
                          title: Text('Fecha de Pago : '),
                          subtitle: Text('No. Recibo'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Column(
                                    children: [Text('Factura : ')],
                                  ),
                                  Column(
                                    children: [Text('Tipo de Pago : ')],
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Column(
                                    children: [
                                      Text('Numero de factura'),
                                      Text(
                                        pago.clienteNombre.toString(),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ));
                  }).toList(),
                );
        });
  }

//
//
//
//           return snapshot.data!.isEmpty
//             ? Center(child: Text('No existen Facturas en el momento...'))
//             : ListView(

//             ));
//       }
//   }
}

import 'package:flutter/material.dart';
import 'package:sigalogin/clases/themes.dart';
import 'package:sigalogin/pantallas/Pagos/realizarPago.dart';

import '../NavigationDrawer.dart';
import 'new_cliente.dart';

class DetalleDelCliente extends StatelessWidget {
  const DetalleDelCliente({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.monetization_on_sharp),
                  text: 'Facturas',
                ),
                Tab(icon: Icon(Icons.paypal), text: 'Pagos'),
                Tab(
                  icon: Icon(Icons.directions_bike),
                  text: 'Pedidos',
                ),
              ],
            ),
            title: const Text('Detalle Cliente'),
          ),
          drawer: navegacions(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RealizarPago()),
              );
            },
            tooltip: 'Agregar',
            child: Icon(Icons.add),
          ),
          body: TabBarView(
            children: [
              ListFactura(const Icon(Icons.directions_car)),
              ListPagos(const Icon(Icons.directions_car)),
              ListPedidos(const Icon(Icons.directions_car)),
            ],
          ),
        ),
      ),
    );
  }
}

class ListFactura extends StatelessWidget {
  Icon ic = const Icon(Icons.abc);
  ListFactura(this.ic, {Key? key}) : super(key: key);

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
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: ((context, index) {
          return Card(
            child: ListTile(
              leading: ic,
              title: Text(list[index]),
            ),
          );
        }));
  }
}

class ListPagos extends StatelessWidget {
  Icon ic = const Icon(Icons.abc);
  ListPagos(this.ic, {Key? key}) : super(key: key);

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
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: ((context, index) {
          return Card(
            child: ListTile(
              leading: ic,
              title: Text(list[index]),
            ),
          );
        }));
  }
}

class ListPedidos extends StatelessWidget {
  Icon ic = const Icon(Icons.abc);
  ListPedidos(this.ic, {Key? key}) : super(key: key);

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
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: ((context, index) {
          return Card(
            child: ListTile(
              leading: ic,
              title: Text(list[index]),
            ),
          );
        }));
  }
}

import 'package:flutter/material.dart';
import 'package:sigalogin/pantallas/clientes/listaClientes.dart';
import 'package:sigalogin/pantallas/pedidos/PedidosVentas%20copy.dart';
import 'package:sigalogin/pantallas/pedidos/PedidosVentas.dart';

import '../clases/ordenDeventa.dart';
import '../servicios/db_helper.dart';
import 'NavigationDrawer.dart';

class pedidosLista extends StatefulWidget {
  @override
  createState() => _ListaOedidosState();
}

class _ListaOedidosState extends State<pedidosLista> {
  // late List<Client> Clients;
  int count = 0;

  @override
  void initState() {
    // Clients = Client.getClients();
    super.initState();
  }

  Widget build(BuildContext context) {
    // Clients.sort();
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedido de Ventas'),

        // backgroundColor: Color.fromARGB(255, 25, 28, 228),

        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.search),
        //     onPressed: () => {
        //       // showSearch(context: context, delegate: MySearchDelegate())
        //     },
        //   )
        // ],
      ),
      drawer: navegacions(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => clienteLista()),
          );
        },
        tooltip: 'Agregar',
        child: Icon(
          Icons.add,
        ),
      ),
      body: Center(
        child: FutureBuilder<List<OrdenVenta>>(
          future: DatabaseHelper.instance.getOrdenes(),
          builder:
              (BuildContext context, AsyncSnapshot<List<OrdenVenta>> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Text('Cargando...'));
            }
            return snapshot.data!.isEmpty
                ? Center(child: Text('No existen Orenes en el momento...'))
                : ListView(
                    children: snapshot.data!.map((pedidos) {
                      return Card(
                        color: Colors.white,
                        elevation: 2.0,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.emoji_people),
                          ),
                          title: Text("Pre orden :" +
                              pedidos.id.toString() +
                              ' |  Cliente :' +
                              pedidos.customerID),
                          subtitle: Text("Fecha Orden" +
                              pedidos.date.toString() +
                              ' | Total : ' +
                              pedidos.totals.toString()),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.check,
                                ),
                                onPressed: () {
                                  print("debe de sincronizar la orden");
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(

                                  //         builder: (context) => CartPage())
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PedidoHistorico(pedidos)),
                            );
                            // NavigateDetail('Edit Product');
                          },
                        ),
                      );
                    }).toList(),
                  );
          },
        ),
      ),
    );
  }
}

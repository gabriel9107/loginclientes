import 'package:flutter/material.dart';
import 'package:sigalogin/servicios/productos_servicio.dart';

import '../../clases/customers.dart';
import '../../clases/themes.dart';
import '../../servicios/db_helper.dart';
import '../NavigationDrawer.dart';

import 'package:provider/provider.dart';

class clienteLista extends StatefulWidget {
  @override
  createState() => CustomerListState();
}

class CustomerListState extends State<clienteLista> {
  // late List<Client> Clients;
  int count = 0;

  @override
  void initState() {
    // Clients = Client.getClients();
    super.initState();
  }

  Widget build(BuildContext context) {
    final productoServices = Provider.of<ClienteSevices>(context);

    // Clients.sort();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: navBar,
        title: Text(' Mantenimiento de clientes'),
        // backgroundColor: Color.fromARGB(255, 25, 28, 228),

        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => {
              // showSearch(context: context, delegate: MySearchDelegate())
            },
          )
        ],
      ),
      drawer: NavigationDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => nuevoCliente('Nuevo cliente')
          //       ),
          // );
        },
        tooltip: 'Agregar',
        child: Icon(Icons.add),
      ),
      body: Center(
        child: FutureBuilder<List<Customers>>(
          future: DatabaseHelper.instance.getCustomers(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Customers>> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Text('Cargando...'));
            }
            return snapshot.data!.isEmpty
                ? Center(child: Text('No existen clientes en el momento...'))
                : ListView(
                    children: snapshot.data!.map((customer) {
                      return Card(
                        color: Colors.white,
                        elevation: 2.0,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.emoji_people),
                          ),
                          title: Text(customer.CustomerCode +
                              ' | ' +
                              customer.CustomerName),
                          subtitle: Text(
                              customer.CustomerDir + ' | ' + customer.Phone1),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.point_of_sale_sharp,
                                ),
                                onPressed: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => CartPage(
                                  //             customer.CustomerCode.toString(),
                                  //             null)));
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                ),
                                onPressed: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) =>
                                  //           nuevoCliente('Editar Cliente')),
                                  // );
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                ),
                                onPressed: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) =>
                                  //           nuevoCliente('Editar Cliente')),
                                  // );
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) =>
                            //           detallePage(customer.CustomerName)),
                            // );
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

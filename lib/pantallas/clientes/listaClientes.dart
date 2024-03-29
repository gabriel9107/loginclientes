import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sigalogin/clases/global.dart';
import 'package:sigalogin/clases/modelos/clientes.dart';
import 'package:sigalogin/pantallas/clientes/detalleDelCLiente.dart';
import 'package:sigalogin/pantallas/clientes/new_cliente.dart';

import '../../clases/customers.dart';
import '../../clases/facturaDetalle.dart';
import '../../clases/themes.dart';
import '../../servicios/clientes_Services.dart';
import '../../servicios/db_helper.dart';
import '../NavigationDrawer.dart';

import 'package:provider/provider.dart';

import '../buscar/buscarClientesEnCLientes.dart';
import '../pedidos/PedidosVentas.dart';
import 'nuevoCliente.dart';

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
              showSearch(
                  context: context,
                  delegate: MySearchDelegateParaClientesEnClientes())
            },
          )
        ],
      ),
      drawer: navegacions(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewClient("Nuevo Cliente")),
          );
        },
        tooltip: 'Agregar',
        child: Icon(Icons.add),
      ),
      body: Center(
        child: FutureBuilder<List<Cliente>>(
          // future: DatabaseHelper.instance.obtenerClientesPorVendedor(usuario),
          future: DatabaseHelper.instance
              .obtenerClientesPorVendedor(usuario, compagnia),
          builder:
              (BuildContext context, AsyncSnapshot<List<Cliente>> snapshot) {
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
                            backgroundColor: customer.sincronizado == 0
                                ? Colors.blue
                                : Colors.red,
                            child: Icon(Icons.emoji_people),
                          ),
                          title: Text(customer.codigo.toString() +
                              ' | ' +
                              customer.nombre),
                          subtitle: Text(
                              customer.direccion + ' | ' + customer.telefono1),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.point_of_sale_sharp,
                                  color: red,
                                ),
                                onPressed: () {
                                  FacturaDetalle.limpiarfacturas();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CartPage(
                                              customer.codigo.toString(),
                                              customer.nombre.toString())));
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: customer.sincronizado == 0
                                      ? Colors.white
                                      : Colors.blue,
                                ),
                                onPressed: customer.sincronizado == 0
                                    ? () {
                                        FacturaDetalle.limpiarfacturas();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => CartPage(
                                                    customer.codigo.toString(),
                                                    customer.nombre
                                                        .toString())));
                                      }
                                    : () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditarCliente(customer)),
                                        );
                                      },
                              ),
                              // IconButton(
                              //   icon: Icon(
                              //     Icons.delete,
                              //   ),
                              //   onPressed: () {
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) =>
                              //               NewClient('Editar Cliente')),
                              //     );
                              //   },
                              // ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetalleDelCliente(
                                        customer.codigo.toString(),
                                        customer.nombre.toString())
                                    //  CartPage(
                                    //     customer.CustomerCode,
                                    //     customer.CustomerName.toString())

                                    ));

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

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sigalogin/clases/global.dart';
import 'package:sigalogin/clases/modelos/clientes.dart';
import 'package:sigalogin/clases/usuario.dart';
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
import 'nuevoUsuario.dart';

class listaUsuarios extends StatefulWidget {
  @override
  createState() => UsariosListState();
}

class UsariosListState extends State<listaUsuarios> {
  // late List<Client> Clients;
  int count = 0;

  @override
  void initState() {
    // Clients = Client.getClients();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: navBar,
        title: const Text(' Mantenimiento de Usuarios'),
      ),
      drawer: navegacions(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NuevoUsuario("Nuevo Usuario")),
          );
        },
        tooltip: 'Agregar',
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: FutureBuilder<List<Usuario>>(
          // future: DatabaseHelper.instance.obtenerClientesPorVendedor(usuario),
          future: DatabaseHelper.instance.obtenerListaDeUsuarios(compagnia),
          builder:
              (BuildContext context, AsyncSnapshot<List<Usuario>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: Text('Cargando...'));
            }
            return snapshot.data!.isEmpty
                ? const Center(
                    child: Text('No existen Usuarios en el momento...'))
                : ListView(
                    children: snapshot.data!.map((usuarios) {
                      return Card(
                        color: Colors.white,
                        elevation: 2.0,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: usuarios.sincronizado == 0
                                ? Colors.blue
                                : Colors.red,
                            child: const Icon(Icons.check),
                          ),
                          title: Text(usuarios.usuarioNombre.toString()),
                          subtitle:
                              Text('${usuarios.nombre} ${usuarios.apellido}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: red,
                                ),
                                onPressed: () {
                                  //Editar el usuario
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => CartPage(
                                  //             customer.codigo.toString(),
                                  //             customer.nombre.toString())));
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => DetalleDelCliente(
                            //             customer.codigo.toString(),
                            //             customer.nombre.toString())
                            //         //  CartPage(
                            //         //     customer.CustomerCode,
                            //         //     customer.CustomerName.toString())

                            //         ));

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

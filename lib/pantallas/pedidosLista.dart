import 'dart:convert';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sigalogin/clases/modelos/clientes.dart';
import 'package:sigalogin/clases/pedidos.dart';
import 'package:sigalogin/pantallas/clientes/listaClientes.dart';
import 'package:sigalogin/pantallas/pedidos/PedidosVentas%20copy.dart';
import 'package:sigalogin/servicios/PedidoDetalle_Servicio.dart';

import '../clases/modelos/resumen.dart';
import '../clases/pedidoDetalle.dart';
import '../servicios/db_helper.dart';
import 'NavigationDrawer.dart';
import 'package:http/http.dart' as http;

class pedidosLista extends StatefulWidget {
  @override
  createState() => _ListaOedidosState();
}

class _ListaOedidosState extends State<pedidosLista> {
  late DatabaseReference dbref;
  // late List<Client> Clients;
  int count = 0;

  @override
  void initState() {
    dbref = FirebaseDatabase.instance.ref().child('Pedidos');
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
        //       icon: Icon(Icons.refresh),
        //       onPressed: () => {
        //             // DatabaseHelper.instance
        //             //     .obtenerPedidosPendienteDeSincornizacion()
        //             //     .then(
        //             //   (value) {
        //             //     value.forEach((element) {
        //             //       Map<String, dynamic> pedido = {
        //             //         "ClienteId": element.clienteId,
        //             //         "Compagnia": element.compagnia,
        //             //         "FechaOrden": element.fechaOrden.toIso8601String(),
        //             //         "Id": element.id,
        //             //         "Impuestos": element.impuestos,
        //             //         "IsDelete": element.isDelete,
        //             //         "NumeroOrden": element.numeroOrden,
        //             //         "Sincronizado": element.sincronizado,
        //             //         "totalAPagar": element.totalAPagar,
        //             //         "Estado": element.estado
        //             //       };

        //             //       dbref.push().set(pedido);
        //             //     });
        //             //   },
        //             // )

        //             sincronizar()
        //           })
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
        child: FutureBuilder<List<Pedido>>(
          future: DatabaseHelper.instance.getOrdenesPorvendedor(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Pedido>> snapshot) {
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
                              ' |  Cliente Numero :' +
                              pedidos.clienteId +
                              ' | Nombre Cliente : ' +
                              pedidos.clienteNombre.toString()),
                          subtitle: Text("Fecha Orden : " +
                              DateFormat('dd-MM-yyy')
                                  .format(pedidos.fechaOrden) +

                              // pedidos.fechaOrden.toString() +
                              ' | Total : ' +
                              pedidos.totalAPagar.toStringAsFixed(2)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Checkbox(
                                  value: false,
                                  onChanged: (val) {
                                    print(val);
                                  }),
                              IconButton(
                                icon: Icon(
                                  Icons.check,
                                  color: pedidos.sincronizado == 0
                                      ? Colors.red
                                      : Colors.blue,
                                ),
                                onPressed: () {
                                  print("debe de sincronizar la orden");
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            // habilitar nuevamente
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) =>
                            //           PedidoHistorico(pedidos)),
                            // );
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

Future sincronizar() async {
  final String _baseUrl = 'siga-d5296-default-rtdb.firebaseio.com';
  final List<Pedido> pedidos = [];
  final url = Uri.https(_baseUrl, 'Pedidos.json');

  final resp = await http.get(url);

  final Map<String, dynamic> map = json.decode(resp.body);
  map.forEach((key, value) {
    final temp = Pedido.fromMap(value);
    temp.idfirebase = key;

    pedidos.add(temp);
  });

  pedidos.forEach((pedido) {
    DatabaseHelper.instance.AgregarPedidoNoDescargado(pedido).then((value) {
      if (value == 1) {}
    });
  });
  sincronizarDetalle;
}

Future sincronizarDetalle() async {
  final List<PedidoDetalle> detalle = [];
  final String _baseUrl = 'siga-d5296-default-rtdb.firebaseio.com';
  final url = Uri.https(_baseUrl, 'PedidoDetalle.json');

  final resp = await http.get(url);

  final Map<String, dynamic> map = json.decode(resp.body);
  map.forEach((key, value) {
    final temp = PedidoDetalle.fromMapFire(value);
    temp.idfirebase = key;
    detalle.add(temp);
  });

  detalle.forEach((pedido) {
    DatabaseHelper.instance
        .AgregarPedidoDetalleNoDescargado(pedido)
        .then((value) => {});
  });
}

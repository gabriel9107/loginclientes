import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sigalogin/clases/modelos/clientes.dart';
import 'package:sigalogin/clases/pedidos.dart';
import 'package:sigalogin/clases/themes.dart';
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
  Color _iconColor = Colors.grey;

  late DatabaseReference dbref;
  // late List<Client> Clients;
  int count = 0;

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      dbref = FirebaseDatabase.instance.ref().child('Pedidos');
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    // Clients.sort();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: navBar2,
        title: Text('Pedido de Ventas'),
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
                              IconButton(
                                  icon: Icon(Icons.check, color: _iconColor),
                                  onPressed: () {
                                    if (pedidos.sincronizado == 0) {
                                      Future.delayed(
                                          const Duration(seconds: 2));
                                      setState(() {
                                        _iconColor = Colors.red;
                                        updateEstadoPedido(pedidos.id!, 3);
                                        print(
                                            'se actualizo el estado a no actualizar');
                                      });
                                    } else if (pedidos.sincronizado == 1) {
                                      print('No hacer nada ');
                                    } else if (pedidos.sincronizado == 3) {
                                      setState(() {
                                        print(
                                            'Actualizado a pendiente nuevamente y se debe de poner el rojo');
                                        _iconColor = Colors.green;
                                        updateEstadoPedido(pedidos.id!, 0);
                                      });
                                    }

                                    // icon: Icon(Icons.check,
                                    //     color: getColor(pedidos.sincronizado)),
                                    // onPressed: () {
                                    //   if (pedidos.sincronizado == 0) {
                                    //     print(
                                    //         'se actualizo el estado a no actualizar');

                                    //     updateEstadoPedido(pedidos.id!, 3);
                                    //   } else if (pedidos.sincronizado == 1) {
                                    //     print('No hacer nada ');
                                    //   } else if (pedidos.sincronizado == 1) {
                                    //     RefreshIndicator() {
                                    //       setState(() {
                                    //         updateEstadoPedido(pedidos.id!, 0);
                                    //       });
                                    //     }

                                    //     print(
                                    //         'Actualizado a pendiente nuevamente y se debe de poner el rojo');
                                    //   }
                                    // },
                                  }),
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

void updateEstadoPedido(int id, int estadoSincronizacion) {
  var resultado =
      DatabaseHelper.instance.UpdateEstadoPedido(id, estadoSincronizacion);
}

Color getColor(int index) {
  switch (index) {
    case 0:
      return Colors.red;
    case 1:
      return Colors.blue;
    case 2:
      return Colors.green;
    case 3:
      return Colors.grey;
    case 4:
      return Colors.purple;
    default:
      return Colors.white;
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

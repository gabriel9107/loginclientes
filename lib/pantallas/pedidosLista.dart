// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:sigalogin/clases/modelos/clientes.dart';
// import 'package:sigalogin/clases/pedidos.dart';
// import 'package:sigalogin/pantallas/clientes/listaClientes.dart';
// import 'package:sigalogin/pantallas/pedidos/PedidosVentas%20copy.dart';
// import 'package:sigalogin/servicios/PedidoDetalle_Servicio.dart';

// import '../clases/modelos/resumen.dart';
// import '../clases/pedidoDetalle.dart';
// import '../servicios/db_helper.dart';
// import 'NavigationDrawer.dart';
// import 'package:http/http.dart' as http;

// class pedidosLista extends StatefulWidget {
//   @override
//   createState() => _ListaOedidosState();
// }

// class _ListaOedidosState extends State<pedidosLista> {
//   // late List<Client> Clients;
//   int count = 0;

//   @override
//   void initState() {
//     // Clients = Client.getClients();
//     super.initState();
//   }

//   Widget build(BuildContext context) {
//     // Clients.sort();
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Pedido de Ventas'),

//         // backgroundColor: Color.fromARGB(255, 25, 28, 228),

//         actions: [
//           IconButton(
//               icon: Icon(Icons.refresh),
//               onPressed: () => {
//                     DatabaseHelper.instance
//                         .obtenerPedidosPendienteDeSincornizacion()
//                         .then((value) async {
//                       value.forEach((element) {
//                         crearPedido(element);
//                       });
//                     }),
//                     DatabaseHelper.instance
//                         .obtenerDetallePedidosPendienteDeSincornizacion()
//                         .then(
//                       (value) {
//                         value.forEach((pedidoLista) async {
//                           crearDetallePedido(pedidoLista);
//                         });
//                       },
//                     )
//                   })
//         ],
//       ),
//       drawer: navegacions(),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => clienteLista()),
//           );
//         },
//         tooltip: 'Agregar',
//         child: Icon(
//           Icons.add,
//         ),
//       ),
//       body: Center(
//         child: FutureBuilder<List<Pedido>>(
//           future: DatabaseHelper.instance.getOrdenesPorvendedor(),
//           builder:
//               (BuildContext context, AsyncSnapshot<List<Pedido>> snapshot) {
//             if (!snapshot.hasData) {
//               return Center(child: Text('Cargando...'));
//             }
//             return snapshot.data!.isEmpty
//                 ? Center(child: Text('No existen Orenes en el momento...'))
//                 : ListView(
//                     children: snapshot.data!.map((pedidos) {
//                       return Card(
//                         color: Colors.white,
//                         elevation: 2.0,
//                         child: ListTile(
//                           leading: CircleAvatar(
//                             backgroundColor: Colors.blue,
//                             child: Icon(Icons.emoji_people),
//                           ),
//                           title: Text("Pre orden :" +
//                               pedidos.id.toString() +
//                               ' |  Cliente Numero :' +
//                               pedidos.clienteId),
//                           subtitle: Text("Fecha Orden : " +
//                               DateFormat('dd-MM-yyy')
//                                   .format(pedidos.fechaOrden) +

//                               // pedidos.fechaOrden.toString() +
//                               ' | Total : ' +
//                               pedidos.totalAPagar.toStringAsFixed(2)),
//                           trailing: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: <Widget>[
//                               IconButton(
//                                 icon: Icon(
//                                   Icons.check,
//                                   color: pedidos.sincronizado == 1
//                                       ? Colors.red
//                                       : Colors.blue,
//                                 ),
//                                 onPressed: () {
//                                   print("debe de sincronizar la orden");
//                                 },
//                               ),
//                             ],
//                           ),
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) =>
//                                       PedidoHistorico(pedidos)),
//                             );
//                             // NavigateDetail('Edit Product');
//                           },
//                         ),
//                       );
//                     }).toList(),
//                   );
//           },
//         ),
//       ),
//     );
//   }
// }

// Future<String> crearDetallePedido(PedidoDetalle detalle) async {
//   cargarClientes();
//   final String _baseUrl = 'sigaapp-127c4-default-rtdb.firebaseio.com';
//   final url = Uri.https(_baseUrl, 'PedidoDetalle.json');
//   final resp = await http.post(url, body: detalle.toJson());

//   final decodeData = resp.body;

//   print(decodeData);

//   if (decodeData.isNotEmpty) {
//     DatabaseHelper.instance.actualizarPedidoDetalleCargado(detalle.id as int);
//   }

//   return '';
// }

// Future<String> crearPedido(Pedido pedido) async {
//   final String _baseUrl = 'sigaapp-127c4-default-rtdb.firebaseio.com';
//   final url = Uri.https(_baseUrl, 'Pedidos.json');
//   final resp = await http.post(url, body: pedido.toJson());

//   final decodeData = resp.body;

//   print(decodeData);

//   if (decodeData.isNotEmpty) {
//     DatabaseHelper.instance.actualizarPedidoCargado(pedido.id as int);
//   }

//   return '';
// }

// Future cargarClientes() async {
//   print('sincronizando clientes');
//   var clientes = await DatabaseHelper.instance
//       .obtenerClientesNuevos()
//       .then((value) => sincronizaClienteFire(value));
// }

// sincronizaClienteFire(List<Cliente> clienteList) async {
//   final String _baseUrl = 'sigaapp-127c4-default-rtdb.firebaseio.com';
//   final url = Uri.https(_baseUrl, 'Clientes.json');
//   clienteList.forEach((element) async {
//     final resp = await http.post(url, body: json.encode(element.toJsonUp()));
//     final decodeData = resp.body;
//     print(decodeData);
//     if (decodeData.isNotEmpty) {
//       DatabaseHelper.instance.actualizarClientesCargado(element.id as int);
//     }
//   });
//   Resumen.resumentList.add(Resumen(
//       accion: 'Clientes Subidos', cantidad: clienteList.length.toString()));
// }

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

        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () => {
                    // DatabaseHelper.instance
                    //     .obtenerPedidosPendienteDeSincornizacion()
                    //     .then(
                    //   (value) {
                    //     value.forEach((element) {
                    //       Map<String, dynamic> pedido = {
                    //         "ClienteId": element.clienteId,
                    //         "Compagnia": element.compagnia,
                    //         "FechaOrden": element.fechaOrden.toIso8601String(),
                    //         "Id": element.id,
                    //         "Impuestos": element.impuestos,
                    //         "IsDelete": element.isDelete,
                    //         "NumeroOrden": element.numeroOrden,
                    //         "Sincronizado": element.sincronizado,
                    //         "totalAPagar": element.totalAPagar,
                    //         "Estado": element.estado
                    //       };

                    //       dbref.push().set(pedido);
                    //     });
                    //   },
                    // )

                    cargarPedidos()
                  })
        ],
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
                              pedidos.clienteId),
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
                                icon: Icon(
                                  Icons.check,
                                  color: pedidos.sincronizado == 1
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

Future cargarPedidos() async {
  var clientes = await DatabaseHelper.instance
      .obtenerPedidosPendienteDeSincornizacion()
      .then((pedido) {
    pedido.forEach((element) {
      sincronizarPedidos(element);
      cargarPedidoDetalle(element);
    });
  });
}

Future sincronizarPedidos(Pedido pedido) async {
  final String _baseUrl = 'sigaapp-127c4-default-rtdb.firebaseio.com';
  final url = Uri.https(_baseUrl, 'Pedidos.json');

  final resp = await http.post(url, body: json.encode(pedido.toJsonUp()));
  final decodeData = resp.body;
  print(decodeData);
  if (decodeData.isNotEmpty) {
    DatabaseHelper.instance
        .actualizarPedidoCargado(pedido.id as int, decodeData);
  }

  return '';
}

Future cargarPedidoDetalle(Pedido Pedido) async {
  var busquedarDetalle = await DatabaseHelper.instance
      .obtenerPedidoDetalleEspecificoASincronizar(Pedido.id as int)
      .then((value) => sincronizarPedidoDetalles(value, Pedido.clienteId));
  // var detalle = await DatabaseHelper.instance
  //     .obtenerDetallePedidosPendienteDeSincornizacion()
}

sincronizarPedidoDetalles(
    List<PedidoDetalle> pedidoLista, String clienteID) async {
  // final databaseReference = FirebaseDatabase.instance.ref('PedidoDetalle');

  final String _baseUrl = 'sigaapp-127c4-default-rtdb.firebaseio.com';
  final url = Uri.https(_baseUrl, 'PedidoDetalle.json');

  pedidoLista.forEach((element) async {
    final resp = await http.post(url, body: json.encode(element.toJsonUp()));
    final decodeData = resp.body;
    print(decodeData);
    if (decodeData.isNotEmpty) {
      DatabaseHelper.instance
          .actualizarPedidoDetalleCargado(element.id as int, decodeData);
    }
  });

  Resumen.resumentList.add(Resumen(
      accion: 'Pedidos Detalle Subidos',
      cantidad: pedidoLista.length.toString()));
}
